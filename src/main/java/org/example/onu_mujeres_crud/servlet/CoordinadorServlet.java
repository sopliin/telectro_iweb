package org.example.onu_mujeres_crud.servlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import org.example.onu_mujeres_crud.beans.*;
import org.example.onu_mujeres_crud.daos.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.onu_mujeres_crud.dtos.EstadisticasEncuestadorDTO;
import org.example.onu_mujeres_crud.dtos.EstadisticasZonaDTO;

import java.io.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;

import org.example.onu_mujeres_crud.daos.EncuestaAsignadaDAO;
import org.example.onu_mujeres_crud.daos.RespuestaDAO;
import java.sql.SQLException;
import java.util.Iterator;
import org.apache.poi.ss.usermodel.*;
import org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO;

import java.util.Map;

@WebServlet(name = "CoordinadorServlet", value = "/CoordinadorServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class CoordinadorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        HttpSession session = request.getSession();
        Usuario coordinador = (Usuario) session.getAttribute("usuario");
        RequestDispatcher view;
        ZonaDAO zonaDAO = new ZonaDAO();
        CoordinadorDao coordinadorDAO = new CoordinadorDao();
        EncuestaDAO encuestaDAO = new EncuestaDAO();

        switch (action) {
            // ver lista de encuestadores de acuerdo a su la zona asignada del coordinador
            case "lista":
                Usuario coordinadorSesion = (Usuario) request.getSession().getAttribute("usuario");
                if (coordinadorSesion == null || coordinadorSesion.getZona() == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                int zonaId = coordinadorSesion.getZona().getZonaId();
                ArrayList<Usuario> todosEncuestadores = coordinadorDAO.listarEncuestadoresPorZona(zonaId);

                // Reutilizar paginación
                aplicarPaginacion(request, todosEncuestadores, 8); // Puedes ajustar la cantidad por página

                // Otros atributos
                ArrayList<Distrito> listaDistritos = coordinadorDAO.listarDistritosPorZona(zonaId);
                ArrayList<Zona> listaZonas = new ArrayList<>();
                listaZonas.add(coordinadorSesion.getZona());

                request.setAttribute("listaDistritos", listaDistritos);
                request.setAttribute("listaZonas", listaZonas);

                view = request.getRequestDispatcher("/Coordinador/coordinador_encuestadores.jsp");
                view.forward(request, response);
                break;

            // ver su perfil (coordinador)
            case "verPerfil":
                view = request.getRequestDispatcher("/Coordinador/coordinador_ver_tu_perfil.jsp");
                view.forward(request, response);
                break;
            case "editarPerfil":
                handleEditProfileGet(request, response);
                break;
            case "cambiarContrasena":
                handleChangePasswordGet(request, response);
                break;

            // ver perfil de los encuestadores a su cargo
            case "verPerfilEncuestador":
                int idVer = Integer.parseInt(request.getParameter("id"));
                Usuario encuestador = coordinadorDAO.obtenerEncuestadorPorId(idVer);
                request.setAttribute("encuestador", encuestador);

                // Pasar filtros si existen
                String zonaIdFiltro = request.getParameter("zonaId");
                String distritoIdFiltro = request.getParameter("distritoId");

                request.setAttribute("zonaIdFiltro", zonaIdFiltro);
                request.setAttribute("distritoIdFiltro", distritoIdFiltro);

                view = request.getRequestDispatcher("/Coordinador/coordinador_ver_otro_perfil.jsp");
                view.forward(request, response);
                break;

            // Prepara los parametros que apareceran en la vista "asignarFormulario"
            case "asignarFormulario":

                System.out.println("Aquí llega sin problemas");

                int idEncuestador = Integer.parseInt(request.getParameter("id"));
                encuestador = coordinadorDAO.obtenerEncuestadorPorId(idEncuestador);
                request.setAttribute("encuestador", encuestador);
                request.setAttribute("idEncuestador", idEncuestador);

                String carpetaSeleccionada = request.getParameter("carpeta");

                if (carpetaSeleccionada == null) carpetaSeleccionada = "";
                request.setAttribute("carpeta", carpetaSeleccionada);

                request.setAttribute("carpeta", carpetaSeleccionada);

                // Lista de carpetas
                ArrayList<String> listaCarpetas = encuestaDAO.obtenerCarpetasDisponibles();
                request.setAttribute("listaCarpetas", listaCarpetas);

                // Lista de encuestas de esa carpeta (si está seleccionada)
                ArrayList<Encuesta> listaEncuestas;
                if (carpetaSeleccionada != null && !carpetaSeleccionada.isEmpty()) {
                    listaEncuestas = encuestaDAO.obtenerEncuestasPorCarpetaAsignar(carpetaSeleccionada);
                } else {
                    listaEncuestas = encuestaDAO.obtenerEncuestasPorCarpetaAsignar(""); // Muestra todas
                }
                request.setAttribute("listaEncuestas", listaEncuestas);

                // Mantener filtros anteriores si se volviera desde otra vista
                request.setAttribute("zonaIdFiltro", request.getParameter("zonaId"));
                request.setAttribute("distritoIdFiltro", request.getParameter("distritoId"));

                view = request.getRequestDispatcher("/Coordinador/coordinador_asignar_encuestas_sc_encuestadores.jsp");
                view.forward(request, response);
                break;

            // Obtener parámetros del filtro (encuestadores) en la vista ListaVistaEncuestador.jsp
            case "filtrar":
                Usuario coordinadorSesionFiltrar = (Usuario) request.getSession().getAttribute("usuario");
                if (coordinadorSesionFiltrar == null || coordinadorSesionFiltrar.getZona() == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                int zonaIdFiltrar = coordinadorSesionFiltrar.getZona().getZonaId();

                // Cargar lista de distritos para el filtro
                ArrayList<Distrito> listaDistritosFiltrar = coordinadorDAO.listarDistritosPorZona(zonaIdFiltrar);
                request.setAttribute("listaDistritos", listaDistritosFiltrar);

                // Obtener encuestadores según filtro
                String distritoIdStrFiltrar = request.getParameter("distritoId");
                ArrayList<Usuario> listaEncuestadoresFiltrar;

                if (distritoIdStrFiltrar != null && !distritoIdStrFiltrar.isEmpty()) {
                    int distritoId = Integer.parseInt(distritoIdStrFiltrar);
                    listaEncuestadoresFiltrar = coordinadorDAO.obtenerTodosEncuestadoresPorZonaYDistrito(zonaIdFiltrar, distritoId);
                    request.setAttribute("distritoSeleccionado", distritoId);
                } else {
                    listaEncuestadoresFiltrar = coordinadorDAO.listarEncuestadoresPorZona(zonaIdFiltrar);
                }

                // Reutilizar paginación
                aplicarPaginacion(request, listaEncuestadoresFiltrar, 8); // Ajusta el tamaño de página si deseas

                // Redirigir a la misma vista
                view = request.getRequestDispatcher("/Coordinador/coordinador_encuestadores.jsp");
                view.forward(request, response);
                break;

            // ----Encuestas -----
            // Ver encuestas de la vista coordinador
            case "listarEncuestas":
                carpetaSeleccionada = request.getParameter("carpeta");
                ArrayList<Encuesta> encuestas;
                ArrayList<String> carpetas = encuestaDAO.obtenerCarpetasDisponibles();

                if (carpetaSeleccionada != null && !carpetaSeleccionada.isEmpty()) {
                    encuestas = encuestaDAO.obtenerEncuestasPorCarpeta(carpetaSeleccionada);
                } else {
                    encuestas = encuestaDAO.obtenerEncuestasPorCarpeta(""); // Muestra todas si no se filtra
                }

                request.setAttribute("listaEncuestas", encuestas);
                request.setAttribute("listaCarpetas", carpetas);
                request.setAttribute("carpetaSeleccionada", carpetaSeleccionada);

                view = request.getRequestDispatcher("/Coordinador/coordinador_encuestas.jsp");
                view.forward(request, response);
                break;

            // filtrar por distrito para asignar formulario a encuestador
            case "filtrarAsignar":
                if (coordinador == null || coordinador.getZona() == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                zonaId = coordinador.getZona().getZonaId();

                // Obtener distritos de la zona asignada
                listaDistritos = coordinadorDAO.listarDistritosPorZona(zonaId);
                request.setAttribute("listaDistritos", listaDistritos);

                // Filtro de distrito
                String distritoFiltrarIdStr = request.getParameter("distritoId");
                ArrayList<Usuario> listaEncuestadores;

                if (distritoFiltrarIdStr != null && !distritoFiltrarIdStr.isEmpty()) {
                    int distritoId = Integer.parseInt(distritoFiltrarIdStr);
                    listaEncuestadores = coordinadorDAO.obtenerTodosEncuestadoresPorZonaYDistrito(zonaId, distritoId);
                    request.setAttribute("distritoSeleccionado", distritoId);
                } else {
                    listaEncuestadores = coordinadorDAO.listarEncuestadoresPorZona(zonaId);
                }

                // Mostrar la zona en la vista
                listaZonas = new ArrayList<>();
                listaZonas.add(coordinador.getZona());

                // Parámetros extra para mantener el estado de selección en la vista
                String encuestaIdStr = request.getParameter("encuestaId");
                String carpetaParam = request.getParameter("carpeta");

                if (encuestaIdStr != null && !encuestaIdStr.isEmpty()) {
                    int encuestaId = Integer.parseInt(encuestaIdStr);
                    Encuesta encuestaSeleccionada = encuestaDAO.obtenerEncuestaPorId(encuestaId);
                    request.setAttribute("encuestaSeleccionada", encuestaSeleccionada);
                    request.setAttribute("encuestaId", encuestaIdStr);
                }

                request.setAttribute("carpetaSeleccionada", carpetaParam != null ? carpetaParam : "");
                request.setAttribute("zonaSeleccionada", zonaId);
                request.setAttribute("listaZonas", listaZonas);

                // Aquí aplicas la paginación como en "filtrar"
                aplicarPaginacion(request, listaEncuestadores, 8); // 4 elementos por página

                view = request.getRequestDispatcher("/Coordinador/coordinador_asignar_encuestas_sc_encuestas.jsp");
                view.forward(request, response);
                break;

            case "dashboard":

                ArrayList<EstadisticasEncuestadorDTO> statsEncuestadores = coordinadorDAO.obtenerEstadisticasPorEncuestador(coordinador.getUsuarioId());
                ArrayList<EstadisticasZonaDTO> statsZonas = coordinadorDAO.obtenerEstadisticasPorZona(coordinador.getUsuarioId());

                ArrayList<RespuestaSiNoDTO> statsPregunta9 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(9);
                ArrayList<RespuestaSiNoDTO> statsPregunta11 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(11);
                ArrayList<RespuestaSiNoDTO> statsPregunta13 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(13);
                ArrayList<RespuestaSiNoDTO> statsPregunta16 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(16);
                ArrayList<RespuestaSiNoDTO> statsPregunta17 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(17);
                ArrayList<RespuestaSiNoDTO> statsPregunta20 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(20);
                ArrayList<RespuestaSiNoDTO> statsPregunta21 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(21);
                ArrayList<RespuestaSiNoDTO> statsPregunta23 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(23);
                ArrayList<RespuestaSiNoDTO> statsPregunta24 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(24);
                ArrayList<RespuestaSiNoDTO> statsPregunta26 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(26);
                ArrayList<RespuestaSiNoDTO> statsPregunta27 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(27);
                ArrayList<RespuestaSiNoDTO> statsPregunta28 = coordinadorDAO.obtenerEstadisticasPreguntaSiNo(28);


                request.setAttribute("statsZonas", statsZonas);
                request.setAttribute("statsEncuestadores", statsEncuestadores);

                request.setAttribute("statsPregunta9", statsPregunta9);
                request.setAttribute("statsPregunta11", statsPregunta11);
                request.setAttribute("statsPregunta13", statsPregunta13);
                request.setAttribute("statsPregunta16", statsPregunta16);
                request.setAttribute("statsPregunta17", statsPregunta17);
                request.setAttribute("statsPregunta20", statsPregunta20);
                request.setAttribute("statsPregunta21", statsPregunta21);
                request.setAttribute("statsPregunta23", statsPregunta23);
                request.setAttribute("statsPregunta24", statsPregunta24);
                request.setAttribute("statsPregunta26", statsPregunta26);
                request.setAttribute("statsPregunta27", statsPregunta27);
                request.setAttribute("statsPregunta28", statsPregunta28);

                request.getRequestDispatcher("/Coordinador/dashboard.jsp").forward(request, response);

                break;
            // --MENU--
            case "subirexcel":
                encuestas = encuestaDAO.obtenerEncuestasPorCarpeta("");
                request.setAttribute("listaEncuestas", encuestas);
                view = request.getRequestDispatcher("/Coordinador/subirExcelRespuestas.jsp");
                view.forward(request, response);
                break;

            case "descargarFormatoExcel":
                String nombreArchivo = request.getParameter("nombreArchivo");

                if (nombreArchivo == null || nombreArchivo.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetro 'nombreArchivo' es requerido.");
                    return;
                }

                // La ruta base ahora es la carpeta 'Coordinador' dentro de 'webapp'
                String rutaBaseCoordinador = getServletContext().getRealPath("/Coordinador/");
                File archivo = new File(rutaBaseCoordinador, nombreArchivo);

                if (!archivo.exists()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "El archivo '" + nombreArchivo + "' no se encontró en la ruta: " + rutaBaseCoordinador);
                    return;
                }

                response.setHeader("Content-Disposition", "attachment; filename=\"" + archivo.getName() + "\"");

                String mimeType = getServletContext().getMimeType(archivo.getName());
                if (mimeType == null) {
                    mimeType = "application/octet-stream";
                }
                response.setContentType(mimeType);

                response.setContentLength((int) archivo.length());

                try (FileInputStream in = new FileInputStream(archivo);
                     OutputStream out = response.getOutputStream()) {

                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                } catch (IOException e) {
                    System.err.println("Error al descargar el archivo: " + e.getMessage());
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno al procesar la descarga del archivo.");
                }

                break;

            default:
                response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=lista");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CoordinadorDao coordinadorDAO = new CoordinadorDao();
        EncuestaDAO encuestaDAO = new EncuestaDAO();

        String action = request.getParameter("action");

        // Obtener el coordinador desde la sesión
        Usuario coordinador = (Usuario) request.getSession().getAttribute("usuario");
        if (coordinador == null) {
            response.sendRedirect(request.getContextPath() +"/login"); // O la página de login correspondiente
            return;
        }
        int coordinadorId = coordinador.getUsuarioId();

        switch(action) {
            //Asignar encuesta desde la vista Asignacion de vista encuestadores
            case "guardarAsignacion":
                int encuestadorId = Integer.parseInt(request.getParameter("idEncuestador"));
                String nombreEncuesta = request.getParameter("nombreEncuesta");
                String carpeta = request.getParameter("carpeta");

                // asigna mas de 1 encuesta al encuestador
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                for (int i = 0; i < cantidad; i++) {
                    coordinadorDAO.asignarEncuesta(nombreEncuesta, carpeta, encuestadorId, coordinadorId);
                }

                // Revisar el origen de la solicitud
                String origen = request.getParameter("origen");

                if ("vistaEncuestadores".equals(origen)) {
                    // Recuperar filtros
                    String zonaId = request.getParameter("zonaId");
                    String distritoId = request.getParameter("distritoId");

                    String redirectUrl = request.getContextPath() +"/CoordinadorServlet?action=filtrar";
                    if (zonaId != null && !zonaId.isEmpty()) {
                        redirectUrl += "&zonaId=" + zonaId;
                    }
                    if (distritoId != null && !distritoId.isEmpty()) {
                        redirectUrl += "&distritoId=" + distritoId;
                    }
                    redirectUrl += "&mensaje=asignacionExitosa";

                    response.sendRedirect(redirectUrl);

                } else {
                    // Por defecto redirige a encuestas (lógica anterior intacta)
                    String redirectUrl = request.getContextPath() +"/CoordinadorServlet?action=listarEncuestas";
                    if (carpeta != null && !carpeta.isEmpty()) {
                        redirectUrl += "&carpeta=" + carpeta + "&mensaje=asignacionExitosa";
                    }
                    response.sendRedirect(redirectUrl);
                }
                break;
            //Asignar encuesta desde la vista Asignacion desde vista encuestas
            case "guardarAsignacionDesdeEncuestas":

                int encuestadorId2 = Integer.parseInt(request.getParameter("idEncuestador"));
                int encuestaId = Integer.parseInt(request.getParameter("encuestaId"));
                cantidad = Integer.parseInt(request.getParameter("cantidad")); // Nuevo

                // Asignar la encuesta la cantidad de veces indicada
                for (int i = 0; i < cantidad; i++) {
                    coordinadorDAO.asignarEncuestaPorId(encuestaId, encuestadorId2, coordinadorId);
                }

                carpeta = request.getParameter("carpeta");
                String redirectUrl = request.getContextPath() +"/CoordinadorServlet?action=listarEncuestas&mensaje=asignacionExitosa";
                if (carpeta != null && !carpeta.isEmpty()) {
                    redirectUrl += "&carpeta=" + carpeta;
                }
                response.sendRedirect(redirectUrl);
                break;

            // Cambiar estado de un encuestador (activo/baneado)
            case "estado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                String estadoActual = request.getParameter("estado");
                String nuevoEstado = estadoActual.equals("activo") ? "baneado" : "activo";
                coordinadorDAO.cambiarEstadoEncuestador(idEstado, nuevoEstado);
                String zonaIdParam = request.getParameter("zonaId");
                String distritoIdParam = request.getParameter("distritoId");
                String pageParam = request.getParameter("page");

                redirectUrl = request.getContextPath() + "/CoordinadorServlet?action=filtrar";

                if (zonaIdParam != null && !zonaIdParam.isEmpty()) {
                    redirectUrl += "&zonaId=" + zonaIdParam;
                }
                if (distritoIdParam != null && !distritoIdParam.isEmpty()) {
                    redirectUrl += "&distritoId=" + distritoIdParam;
                }
                if (pageParam != null && !pageParam.isEmpty()) {
                    redirectUrl += "&page=" + pageParam;
                }
                response.sendRedirect(redirectUrl);
                break;
            // Cambiar estado de una encuesta (activo/inactivo)
            case "cambiarEstadoEncuesta":
                encuestaId = Integer.parseInt(request.getParameter("id"));
                String estadoActualEncuesta = request.getParameter("estado"); // "activo" o "inactivo"
                String nuevoEstadoEncuesta = estadoActualEncuesta.equals("activo") ? "inactivo" : "activo";

                encuestaDAO.actualizarEstadoEncuesta(encuestaId, nuevoEstadoEncuesta);

                // Redireccionar de vuelta a la lista de encuestas
                String carpetaParam = request.getParameter("carpeta");
                redirectUrl = request.getContextPath() +"/CoordinadorServlet?action=listarEncuestas&mensaje=estadoActualizado";
                if (carpetaParam != null && !carpetaParam.isEmpty()) {
                    redirectUrl += "&carpeta=" + carpetaParam;
                }
                response.sendRedirect(redirectUrl);

                break;
            case "uploadExcel":
                EncuestaAsignadaDAO encuestaAsignadaDAO = new EncuestaAsignadaDAO();
                RespuestaDAO respuestaDAO = new RespuestaDAO();
                ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();
               // Obtener el ID del usuario logueado (que es el coordinador)

                try {
                    int encuestaId1 = Integer.parseInt(request.getParameter("encuestaId"));
                    Part filePart = request.getPart("excelFile");

                    if (filePart != null && filePart.getSize() > 0) {
                        InputStream fileContent = filePart.getInputStream();

                        ArrayList<BancoPreguntas> preguntasEncuesta = contenidoEncuestaDAO.obtenerPreguntasDeEncuestaAsignada(encuestaId1);

                        Map<Integer, ArrayList<PreguntaOpcion>> opcionesPorPreguntaId = new HashMap<>();
                        for (BancoPreguntas bp : preguntasEncuesta) {
                            if (bp.getTipo().equals("opcion_unica") || bp.getTipo().equals("opcion_multiple")) {
                                opcionesPorPreguntaId.put(bp.getPreguntaId(), contenidoEncuestaDAO.obtenerOpcionesDePregunta(bp.getPreguntaId()));
                            }
                        }




                            Workbook workbook = WorkbookFactory.create(fileContent);
                            Sheet sheet = workbook.getSheetAt(0);

                            Iterator<Row> rowIterator = sheet.iterator();
                            //el excel tiene 5 encabezados por defecto(con las intrucciones) luego vienen los datos
                            for (int i = 0; i < 5; i++) {
                                if (rowIterator.hasNext()) {
                                    rowIterator.next();
                                } else {
                                    System.err.println("Advertencia: El archivo Excel tiene menos de 6 filas para procesar.");
                                    request.getSession().setAttribute("error", "El archivo Excel no contiene suficientes filas de datos (mínimo fila 6 debe tener entradas) .");
                                    response.sendRedirect(request.getContextPath() + "/CoordinadorServlet?action=subirexcel");
                                    return;
                                }
                            }

                            List<String> dnisProcesadosEnArchivo = new ArrayList<>();
                            boolean noDni=false;
                            int  j=0;
                        System.out.println("Total de filas según POI: " + (sheet.getLastRowNum() + 1));
                            while (rowIterator.hasNext()) {

                                noDni=false;

                                Row currentRow = rowIterator.next();
                                //el dni es la primera columna de las filas a registrar(que empieza de la fila 6 y es necesario para continuar el registro de las respuestas
                                String dniEncuestado = getCellValue(currentRow.getCell(0));
                                System.out.println("kkk");
                                System.out.println(dniEncuestado);

                                //ver si el dni es null vacio o en la lista de dni con encuestas ya completadas debe ser de 8 numeros exactos
                                if (dniEncuestado == null || dniEncuestado.trim().isEmpty()||contenidoEncuestaDAO.verificarDniEnAsignacionesCompletadas(dniEncuestado)||!dniEncuestado.matches("\\d{8}")) {
                                    System.err.println("Advertencia: Se encontró una fila sin DNI. Se omitirá.");
                                    noDni=true;
                                    continue;
                                }
                                //los dnis del excel deben ser diferentes
                                if (dnisProcesadosEnArchivo.contains(dniEncuestado)) {
                                    request.getSession().setAttribute("error", "Error durante la importación: el DNI '" + dniEncuestado + "' está duplicado dentro del archivo Excel.");
                                    response.sendRedirect(request.getContextPath() + "/CoordinadorServlet?action=subirexcel");
                                    return;
                                } else {
                                    dnisProcesadosEnArchivo.add(dniEncuestado);
                                }
                                j=j+1;

                                int asignacionId = encuestaAsignadaDAO.crearAsignacionParaImportacion(encuestaId1, coordinadorId);
                                String fechaInicio = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                                String fechaEnvio = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));



                                int respuestaId;
                                try {
                                    respuestaId = respuestaDAO.guardarRespuestaPrincipal(dniEncuestado, asignacionId, fechaInicio, fechaEnvio);
                                } catch (SQLException e) {
                                    if (e.getMessage() != null && e.getMessage().contains("Incorrect datetime value")) {
                                        request.getSession().setAttribute("error", "Error durante la importación: el formato de la fecha es incorrecto - [línea asociada al DNI '" + dniEncuestado + "']: el formato correcto es DD/MM/AAAA HH:MM:SS.");
                                    } else if (e.getMessage() != null && e.getMessage().contains("Duplicate entry") && e.getMessage().contains("dni_encuestado_UNIQUE")) {
                                        request.getSession().setAttribute("error", "Error durante la importación: el DNI '" + dniEncuestado + "' está con un valor duplicado.");
                                    } else {
                                        request.getSession().setAttribute("error", "Error de base de datos durante la importación para DNI '" + dniEncuestado + "': " + e.getMessage());
                                    }
                                    e.printStackTrace();
                                    response.sendRedirect(request.getContextPath() + "/CoordinadorServlet?action=subirexcel");
                                    return;
                                }

                                if (respuestaId > 0) {
                                    List<RespuestaDetalle> detallesRespuestas = new ArrayList<>();
                                    String fechaContestacion = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                                    int k=0;
                                    int t=0;
                                    int p=0;
                                    int h=0;
                                    int f=0;
                                    for (int i = 1; i < currentRow.getLastCellNum(); i++) {
                                        System.out.println("celda nula1");
                                        System.out.println(currentRow.getLastCellNum());
                                        Cell cell = currentRow.getCell(i);
                                        String cellValue = getCellValue(cell);


                                        if (cellValue==null) {
                                            System.out.println("celda nula");
                                            continue;
                                        }
                                        if (i==9){
                                            cellValue.equalsIgnoreCase("No");
                                            k=1;
                                        }
                                        if (i==11){
                                            cellValue.equalsIgnoreCase("SÍ");
                                            t=1;
                                        }
                                        if (i==13){
                                            cellValue.equalsIgnoreCase("No");
                                            p=1;
                                        }
                                        if (i==17){
                                            cellValue.equalsIgnoreCase("No");
                                            h=1;
                                        }
                                        if (i==21){
                                            cellValue.equalsIgnoreCase("No");
                                            f=1;
                                        }

                                        if ((k==1) && ((i==10)||(i==11)||(i==12))){
                                            continue;
                                        }
                                        if ((t==1) && ((i==12))){
                                            continue;
                                        }
                                        if ((p==1) && ((i==14)||(i==15)||(i==16))){
                                            continue;
                                        }
                                        if ((h==1) && ((i==18)||(i==19)||(i==20))){
                                            continue;
                                        }
                                        if ((f==1) && ((i==22)||(i==23)||(i==24))){
                                            continue;
                                        }



                                        int preguntaIndex = i - 1;

                                        if (preguntaIndex < preguntasEncuesta.size()) {
                                            BancoPreguntas pregunta = preguntasEncuesta.get(preguntaIndex);

                                            RespuestaDetalle detalle = new RespuestaDetalle();
                                            detalle.setRespuesta(new Respuesta() {{ setRespuestaId(respuestaId); }});
                                            detalle.setPregunta(pregunta);
                                            detalle.setFechaContestacion(fechaContestacion);

                                            //String cellValue = getCellValue(cell);

                                            if (pregunta.getTipo().equals("opcion_unica") || pregunta.getTipo().equals("opcion_multiple")) {
                                                ArrayList<PreguntaOpcion> opciones = opcionesPorPreguntaId.get(pregunta.getPreguntaId());
                                                if (opciones != null && cellValue != null && !cellValue.trim().isEmpty()) {
                                                    PreguntaOpcion opcionSeleccionada = null;
                                                    for (PreguntaOpcion op : opciones) {
                                                        if (op.getTextoOpcion().equalsIgnoreCase(cellValue)) {
                                                            opcionSeleccionada = op;
                                                            break;
                                                        }
                                                    }
                                                    if (opcionSeleccionada != null) {
                                                        detalle.setOpcion(opcionSeleccionada);
                                                    } else {
                                                        detalle.setRespuestaTexto(cellValue);
                                                    }
                                                } else {
                                                    detalle.setRespuestaTexto(cellValue);
                                                }
                                            } else {
                                                detalle.setRespuestaTexto(cellValue);
                                            }
                                            detallesRespuestas.add(detalle);
                                        }
                                    }
                                    if (!detallesRespuestas.isEmpty()) {
                                        respuestaDAO.guardarRespuestasDetalle(respuestaId, detallesRespuestas);
                                    }
                                } else {
                                    System.err.println("Error: No se pudo guardar la respuesta principal para DNI: " + dniEncuestado);
                                }
                            }
                            workbook.close();
                            if(j==0){
                                request.getSession().setAttribute("error", "No hubo ninguna entrada con dni o 0 entradas importadas ");

                            }else{
                                request.getSession().setAttribute("info", j+" Respuesta de Excel importadas exitosamente.");
                            }


                    } else {
                        request.getSession().setAttribute("error", "No se seleccionó ningún archivo Excel o el archivo está vacío.");
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("error", "Error: El ID de la encuesta debe ser un número válido.");
                    e.printStackTrace();
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Error inesperado durante la importación: " + e.getMessage());
                    e.printStackTrace();
                }


                response.sendRedirect(request.getContextPath() + "/CoordinadorServlet?action=subirexcel");
                break;

            case "uploadPhoto":
                subirFoto(request, response);
                break;
            case "updateProfile":
                handleUpdateProfile(request, response);
                break;
            case "updatePassword":
                handleUpdatePassword(request, response);
                break;
        }
    }


    // --- Metodos auxiliares para manejar las vistas de edición de perfil y cambio de contraseña ---
    // Metodo para mostrar la vista de edición de perfil
    private void handleEditProfileGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }

        DistritoDAO distritoDAO = new DistritoDAO();
        int zonaid = user.getZona().getZonaId();
        System.out.println("es de la zona "+zonaid);
        ArrayList<Distrito> distritos = distritoDAO.obtenerListaDistritosxZona(zonaid);

        request.setAttribute("distritos", distritos);
        RequestDispatcher view = request.getRequestDispatcher("/Coordinador/editar_perfil.jsp");
        view.forward(request, response);
    }

    // Metodo para mostrar la vista de cambio de contraseña
    private void handleChangePasswordGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }

        RequestDispatcher view = request.getRequestDispatcher("/Coordinador/coordinador_cambiar_contrasena.jsp");
        view.forward(request, response);
    }

    // Metodo para subir la foto de perfil (actualizar foto)
    private void subirFoto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            System.out.println("ultimo coordinador");
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }


        Part filePart = request.getPart("foto");
        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("no seleccioo una foto");
            request.setAttribute("error", "No se seleccionó una foto.");
            request.getRequestDispatcher("/Coordinador/coordinador_ver_tu_perfil.jsp").forward(request, response);
            return;
        }

        String contentType = filePart.getContentType();
        System.out.println("Content-Type recibido: " + contentType);
        String extension = getExtension(contentType);
        if (extension == null) {
            System.out.println("no seleccioo no peritido");
            request.setAttribute("error", "Tipo de archivo no permitido.");
            request.getRequestDispatcher("/Coordinador/coordinador_ver_tu_perfil.jsp").forward(request, response);
            return;
        }

        // Crear nombre de archivo con rol_id
        String nombreArchivo = usuario.getUsuarioId() + "." + extension;

        // Ruta en el servidor
        String rutaFotos = getServletContext().getRealPath("/fotos");
        File directorio = new File(rutaFotos);
        if (!directorio.exists()) {
            directorio.mkdirs();
        }
        // 1. Eliminar archivo anterior si existe
        String nombreArchivoAnterior = usuario.getProfilePhotoUrl();
        if (!nombreArchivoAnterior.equalsIgnoreCase("perfil.png")) {
            if (nombreArchivoAnterior != null && !nombreArchivoAnterior.isEmpty()) {
                File archivoAnterior = new File(directorio, nombreArchivoAnterior);
                if (archivoAnterior.exists()) {
                    if (!archivoAnterior.delete()) {
                        System.out.println("No se pudo eliminar el archivo anterior: " + archivoAnterior.getAbsolutePath());
                    }
                }
            }
        }


        // Guardar archivo
        File archivo = new File(directorio, nombreArchivo);
        try (InputStream input = filePart.getInputStream();
             FileOutputStream output = new FileOutputStream(archivo)) {
            byte[] buffer = new byte[1024];
            int bytes;
            while ((bytes = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytes);
            }
        }
        System.out.println("pasa para subir foto");

        // Actualizar en la base de datos
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        usuarioDAO.actualizarFotoPerfil(usuario.getUsuarioId(), nombreArchivo);
        System.out.println(" nuevo foto para la sesion "+nombreArchivo);
        // Actualizar sesión
        usuario.setProfilePhotoUrl(nombreArchivo);
        session.setAttribute("usuario", usuario);

        response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=verPerfil");
    }

    // Metodo para obtener la extensión del archivo basado en el Content-Type
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }

        String direccion = request.getParameter("direccion");
        int distritoId = Integer.parseInt(request.getParameter("distrito"));

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean success = usuarioDAO.actualizarPerfil(user.getUsuarioId(), direccion, distritoId);

        if (success) {
            // Actualizar datos en sesión
            user.setDireccion(direccion);
            Distrito distrito = new Distrito();
            distrito.setDistritoId(distritoId);
            user.setDistrito(distrito);

            session.setAttribute("usuario", user);
            session.setAttribute("success", "Perfil actualizado correctamente");
        } else {
            session.setAttribute("error", "Error al actualizar el perfil");
        }

        response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=verPerfil");
    }
    // Actualizar la contraseña del coordinador
    private void handleUpdatePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validaciones
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "Las contraseñas no coinciden");
            response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=cambiarContrasena");
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        // Verificar contraseña actual
        if (!usuarioDAO.verificarContrasena(user.getUsuarioId(), currentPassword)) {
            session.setAttribute("error", "La contraseña actual es incorrecta");
            response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=cambiarContrasena");
            return;
        }

        // Actualizar contraseña
        boolean success = usuarioDAO.actualizarContrasena(user.getUsuarioId(), newPassword);

        if (success) {
            session.setAttribute("success", "Contraseña actualizada correctamente");
        } else {
            session.setAttribute("error", "Error al actualizar la contraseña");
        }

        response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=cambiarContrasena");
     }

     // Para obtener la extensión del archivo basado en el Content-Type
     private String getExtension(String contentType) {
         return switch (contentType) {
             case "image/jpeg" -> "jpg";
             case "image/png" -> "png";
             case "image/gif" -> "gif";
             default -> null;
         };
     }
    private String getCellValue(Cell cell) {
        if (cell == null) {
            return null;
        }
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> {
                if (DateUtil.isCellDateFormatted(cell)) {
                    LocalDateTime dateTime = cell.getLocalDateTimeCellValue();
                    yield dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                } else {
                    yield String.valueOf((long) cell.getNumericCellValue());
                }
            }
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            case FORMULA -> {
                try {
                    yield cell.getStringCellValue();
                } catch (IllegalStateException e) {
                    yield String.valueOf(cell.getNumericCellValue());
                }
            }
            case BLANK -> null;
            default -> null;
        };
    }
    
    private void aplicarPaginacion(HttpServletRequest request, List<Usuario> listaTotal, int pageSize) {
        int pagina = 1;
        if (request.getParameter("page") != null) {
            try {
                pagina = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException ignored) {}
        }

        int total = listaTotal.size();
        int totalPaginas = (int) Math.ceil((double) total / pageSize);
        if (totalPaginas == 0) totalPaginas = 1;

        int start = (pagina - 1) * pageSize;
        int end = Math.min(start + pageSize, total);

        // Validación extra por seguridad
        if (start > end) start = end;
        if (start < 0) start = 0;
        if (end > total) end = total;

        List<Usuario> listaPaginada = listaTotal.subList(start, end);

        request.setAttribute("listaEncuestadores", listaPaginada);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);
    }

}