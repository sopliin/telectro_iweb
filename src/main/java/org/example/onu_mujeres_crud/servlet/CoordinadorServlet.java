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

import java.io.File;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.HashMap;

import org.example.onu_mujeres_crud.daos.EncuestaAsignadaDAO;
import org.example.onu_mujeres_crud.daos.RespuestaDAO;
import java.sql.SQLException;
import java.util.Iterator;
import org.apache.poi.ss.usermodel.*;
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
                    response.sendRedirect(request.getContextPath() +"/login");
                    return;
                }
                int zonaId = coordinadorSesion.getZona().getZonaId();
                ArrayList<Usuario> listaEncuestadores = coordinadorDAO.listarEncuestadoresPorZona(zonaId);

                // Agrega esta línea para obtener los distritos de la zona asignada
                ArrayList<Distrito> listaDistritos = coordinadorDAO.listarDistritosPorZona(zonaId);
                request.setAttribute("listaDistritos", listaDistritos);

                ArrayList<Zona> listaZonas = new ArrayList<>();
                listaZonas.add(coordinadorSesion.getZona());

                request.setAttribute("listaEncuestadores", listaEncuestadores);
                request.setAttribute("listaZonas", listaZonas);

                view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_encuestadores.jsp");
                view.forward(request, response);
                break;
            // ver su perfil (coordinador)
            case "verPerfil":
                view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_ver_tu_perfil.jsp");
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

                view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_ver_otro_perfil.jsp");
                view.forward(request, response);
                break;

            // Prepara los parametros que apareceran en la vista "asignarFormulario"
            case "asignarFormulario":

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
                    listaEncuestas = encuestaDAO.obtenerEncuestasPorCarpeta(carpetaSeleccionada);
                } else {
                    listaEncuestas = encuestaDAO.obtenerEncuestasPorCarpeta(""); // Muestra todas
                }
                request.setAttribute("listaEncuestas", listaEncuestas);

                // Mantener filtros anteriores si se volviera desde otra vista
                request.setAttribute("zonaIdFiltro", request.getParameter("zonaId"));
                request.setAttribute("distritoIdFiltro", request.getParameter("distritoId"));

                view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_asignar_encuestas_sc_encuestadores.jsp");
                view.forward(request, response);
                break;

                // Obtener parámetros del filtro (encuestadores) en la vista ListaVistaEncuestador.jsp
            case "filtrar":
                // se obtiene el id de la zona del coordinador de la sesión
                Usuario coordinadorSesionFiltrar = (Usuario) request.getSession().getAttribute("usuario");
                if (coordinadorSesionFiltrar == null || coordinadorSesionFiltrar.getZona() == null) {
                    response.sendRedirect(request.getContextPath() +"/login");
                    return;
                }
                int zonaIdFiltrar = coordinadorSesionFiltrar.getZona().getZonaId();

                // Obtener distritos de la zona asignada
                ArrayList<Distrito> listaDistritosFiltrar = coordinadorDAO.listarDistritosPorZona(zonaIdFiltrar);
                request.setAttribute("listaDistritos", listaDistritosFiltrar);

                String distritoIdStrFiltrar = request.getParameter("distritoId");
                ArrayList<Usuario> listaEncuestadoresFiltrar;

                if (distritoIdStrFiltrar != null && !distritoIdStrFiltrar.isEmpty()) {
                    int distritoId = Integer.parseInt(distritoIdStrFiltrar);
                    listaEncuestadoresFiltrar = coordinadorDAO.obtenerTodosEncuestadoresPorZonaYDistrito(zonaIdFiltrar, distritoId);
                    request.setAttribute("distritoSeleccionado", distritoId);
                } else {
                    listaEncuestadoresFiltrar = coordinadorDAO.listarEncuestadoresPorZona(zonaIdFiltrar);
                }

                request.setAttribute("listaEncuestadores", listaEncuestadoresFiltrar);

                view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_encuestadores.jsp");
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

                view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_encuestas.jsp");
                view.forward(request, response);
                break;

            // Ver perfil de encuesta
            case "verEncuesta":
                int idEncuesta = Integer.parseInt(request.getParameter("id"));
                Encuesta encuesta = encuestaDAO.obtenerEncuestaPorId(idEncuesta);
                request.setAttribute("encuesta", encuesta);
                view = request.getRequestDispatcher("Coordinador/verEncuesta.jsp");
                view.forward(request, response);
                break;

            // filtrar por distrito para asignar formulario a encuestador
            case "filtrarAsignar":
                if (coordinador == null || coordinador.getZona() == null) {
                    response.sendRedirect(request.getContextPath() +"/login");
                    return;
                }
                zonaId = coordinador.getZona().getZonaId();

                // Obtener distritos de la zona asignada
                listaDistritos = coordinadorDAO.listarDistritosPorZona(zonaId);
                request.setAttribute("listaDistritos", listaDistritos);

                // Filtro de distrito
                String distritoFiltrarIdStr = request.getParameter("distritoId");
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

                // Pasar parámetros extra si los necesitas en el JSP
                String encuestaIdStr = request.getParameter("encuestaId");
                String carpetaParam = request.getParameter("carpeta");

                // Si se pasa un ID de encuesta, obtener la encuesta y pasarla al request
                if (encuestaIdStr != null && !encuestaIdStr.isEmpty()) {
                    int encuestaId = Integer.parseInt(encuestaIdStr);
                    Encuesta encuestaSeleccionada = encuestaDAO.obtenerEncuestaPorId(encuestaId);
                    request.setAttribute("encuestaSeleccionada", encuestaSeleccionada);
                    request.setAttribute("encuestaId", encuestaIdStr);
                }

                // Asegura que siempre se setea el atributo para el JSP
                request.setAttribute("carpetaSeleccionada", carpetaParam != null ? carpetaParam : "");

                // enviamos al jsp como atributo
                request.setAttribute("zonaSeleccionada", zonaId);
                request.setAttribute("listaEncuestadores", listaEncuestadores);
                request.setAttribute("listaZonas", listaZonas);

                view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_asignar_encuestas_sc_encuestas.jsp");
                view.forward(request, response);
                break;
            case "dashboard":

                ArrayList<EstadisticasEncuestadorDTO> statsEncuestadores = coordinadorDAO.obtenerEstadisticasPorEncuestador(coordinador.getUsuarioId());
                ArrayList<EstadisticasZonaDTO> statsZonas = coordinadorDAO.obtenerEstadisticasPorZona(coordinador.getUsuarioId());

                request.setAttribute("statsEncuestadores", statsEncuestadores);
                request.setAttribute("statsZonas", statsZonas);
                request.getRequestDispatcher("/Coordinador/dashboard.jsp").forward(request, response);

                break;

            // --MENU--
            case "subirexcel":
                view = request.getRequestDispatcher("/Coordinador/subirExcelRespuestas.jsp");
                view.forward(request, response);
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

                redirectUrl = request.getContextPath() +"/CoordinadorServlet?action=filtrar";

                if (zonaIdParam != null && !zonaIdParam.isEmpty()) {
                    redirectUrl += "&zonaId=" + zonaIdParam;
                }
                if (distritoIdParam != null && !distritoIdParam.isEmpty()) {
                    redirectUrl += "&distritoId=" + distritoIdParam;
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

                        // 1. Crear la EncuestaAsignada para esta carga de respuestas, pasando el coordinadorId de la sesión
                        int asignacionId = encuestaAsignadaDAO.crearAsignacionParaImportacion(encuestaId1, coordinadorId);

                        if (asignacionId > 0) {
                            Workbook workbook = WorkbookFactory.create(fileContent);
                            Sheet sheet = workbook.getSheetAt(0);

                            Iterator<Row> rowIterator = sheet.iterator();

                            for (int i = 0; i < 5; i++) {
                                if (rowIterator.hasNext()) {
                                    rowIterator.next();
                                } else {
                                    // Manejo de error si el archivo tiene menos de 6 filas
                                    System.err.println("Advertencia: El archivo Excel tiene menos de 6 filas para procesar.");
                                    request.getSession().setAttribute("error", "El archivo Excel no contiene suficientes filas de datos (mínimo fila 6).");
                                    //response.sendRedirect(request.getContextPath() + "/admin/subirExcelRespuestas.jsp");
                                    response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=subirexcel");
                                    return;
                                }
                            }

                            while (rowIterator.hasNext()) {
                                Row currentRow = rowIterator.next();

                                String dniEncuestado = getCellValue(currentRow.getCell(0));
                                String fechaInicio = getCellValue(currentRow.getCell(1));
                                String fechaEnvio = getCellValue(currentRow.getCell(2));

                                if (dniEncuestado == null || dniEncuestado.trim().isEmpty()) {
                                    System.err.println("Advertencia: Se encontró una fila sin DNI. Se omitirá.");
                                    continue;
                                }
                                if (fechaInicio == null || fechaInicio.trim().isEmpty()) {
                                    fechaInicio = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                                    System.err.println("Advertencia: Fecha de inicio vacía para DNI " + dniEncuestado + ". Usando fecha actual.");
                                }
                                if (fechaEnvio == null || fechaEnvio.trim().isEmpty()) {
                                    fechaEnvio = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                                    System.err.println("Advertencia: Fecha de envío vacía para DNI " + dniEncuestado + ". Usando fecha actual.");
                                }

                                // 2. Guardar la respuesta principal (Respuesta)
                                int respuestaId = respuestaDAO.guardarRespuestaPrincipal(dniEncuestado, asignacionId, fechaInicio, fechaEnvio);

                                if (respuestaId > 0) {
                                    List<RespuestaDetalle> detallesRespuestas = new ArrayList<>();
                                    String fechaContestacion = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                                    for (int i = 3; i < currentRow.getLastCellNum(); i++) {
                                        Cell cell = currentRow.getCell(i);

                                        int preguntaIndex = i - 3;
                                        if (preguntaIndex < preguntasEncuesta.size()) {
                                            BancoPreguntas pregunta = preguntasEncuesta.get(preguntaIndex);

                                            RespuestaDetalle detalle = new RespuestaDetalle();
                                            detalle.setRespuesta(new Respuesta() {{ setRespuestaId(respuestaId); }});
                                            detalle.setPregunta(pregunta);
                                            detalle.setFechaContestacion(fechaContestacion);

                                            String cellValue = getCellValue(cell);

                                            if (pregunta.getTipo().equals("opcion_unica") || pregunta.getTipo().equals("opcion_multiple")) {
                                                ArrayList<PreguntaOpcion> opciones = opcionesPorPreguntaId.get(pregunta.getPreguntaId());
                                                if (opciones != null && cellValue != null && !cellValue.trim().isEmpty()) {
                                                    for (PreguntaOpcion op : opciones) {
                                                        System.out.println(op.getOpcionId());
                                                        if (1==1) {
                                                            // detalle.setRespuestaTexto(op.getTextoOpcion());
                                                            detalle.setOpcion(op);
                                                            System.out.println("Respuesta de opción: " + op.getTextoOpcion() + " (ID: " + op.getOpcionId() + ")");

                                                            break;
                                                        }
                                                    }

                                                }
                                            } else {
                                                detalle.setRespuestaTexto(cellValue);
                                                System.out.println("Respuesta de texto: " + cellValue);
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
                            request.getSession().setAttribute("info", "Respuestas de Excel importadas exitosamente.");
                        } else {
                            request.getSession().setAttribute("error", "Error al crear la asignación de encuesta para la importación.");
                        }
                    } else {
                        request.getSession().setAttribute("error", "No se seleccionó ningún archivo Excel o el archivo está vacío.");
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("error", "Error: El ID de la encuesta debe ser un número válido.");
                    e.printStackTrace();
                } catch (SQLException e) {
                    request.getSession().setAttribute("error", "Error de base de datos durante la importación: " + e.getMessage());
                    e.printStackTrace();
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Error inesperado durante la importación: " + e.getMessage());
                    e.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() +"/CoordinadorServlet?action=subirexcel");
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
        RequestDispatcher view = request.getRequestDispatcher("/onu_mujeres/static/editar_perfil.jsp");
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

        RequestDispatcher view = request.getRequestDispatcher("/onu_mujeres/static/coordinador_cambiar_contrasena.jsp");
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
            request.getRequestDispatcher("/onu_mujeres/static/coordinador_ver_tu_perfil.jsp").forward(request, response);
            return;
        }

        String contentType = filePart.getContentType();
        System.out.println("Content-Type recibido: " + contentType);
        String extension = getExtension(contentType);
        if (extension == null) {
            System.out.println("no seleccioo no peritido");
            request.setAttribute("error", "Tipo de archivo no permitido.");
            request.getRequestDispatcher("/onu_mujeres/static/coordinador_ver_tu_perfil.jsp").forward(request, response);
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

}

//package org.example.onu_mujeres_crud.servlet;
//
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//import jakarta.servlet.annotation.*;
//import org.example.onu_mujeres_crud.beans.Usuario;
//import org.example.onu_mujeres_crud.beans.Zona;
//import org.example.onu_mujeres_crud.beans.Distrito;
//import org.example.onu_mujeres_crud.beans.Encuesta;
//import org.example.onu_mujeres_crud.daos.CoordinadorDao;
//import org.example.onu_mujeres_crud.daos.ZonaDAO;
//import org.example.onu_mujeres_crud.daos.EncuestaDAO;
//
//
//
//import java.io.IOException;
//import java.util.ArrayList;
//
//@WebServlet(name = "CoordinadorServlet", value = "/CoordinadorServlet")
//public class CoordinadorServlet extends HttpServlet {
//    ZonaDAO zonaDAO = new ZonaDAO();
//    CoordinadorDao coordinadorDAO = new CoordinadorDao();
//    EncuestaDAO encuestaDAO = new EncuestaDAO();
//
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String action = request.getParameter("action") == null ? "menu" : request.getParameter("action");
//
//        RequestDispatcher view;
//
//        switch (action) {
//            case "lista":
//                ArrayList<Usuario> listaEncuestadores = coordinadorDAO.listarEncuestadores();
//                ArrayList<Zona> listaZonas = zonaDAO.obtenerListaZonas();
//
//                request.setAttribute("listaEncuestadores", listaEncuestadores);
//                request.setAttribute("listaZonas", listaZonas);
//
//                view = request.getRequestDispatcher("Coordinador/VistaListaEncuestador.jsp");
//                view.forward(request, response);
//                break;
//
//            case "ver":
//                int idVer = Integer.parseInt(request.getParameter("id"));
//                Usuario encuestador = coordinadorDAO.obtenerEncuestadorPorId(idVer);
//                request.setAttribute("encuestador", encuestador);
//
//                // Pasar filtros si existen
//                String zonaIdFiltro = request.getParameter("zonaId");
//                String distritoIdFiltro = request.getParameter("distritoId");
//
//                request.setAttribute("zonaIdFiltro", zonaIdFiltro);
//                request.setAttribute("distritoIdFiltro", distritoIdFiltro);
//
//                view = request.getRequestDispatcher("Coordinador/verEncuestador.jsp");
//                view.forward(request, response);
//                break;
//            // actualiza estado (tiene ir en doPost)
//            case "estado":
//                int idEstado = Integer.parseInt(request.getParameter("id"));
//                String estadoActual = request.getParameter("estado");
//                String nuevoEstado = estadoActual.equals("activo") ? "inactivo" : "activo";
//                coordinadorDAO.cambiarEstadoEncuestador(idEstado, nuevoEstado);
//                String zonaIdParam = request.getParameter("zonaId");
//                String distritoIdParam = request.getParameter("distritoId");
//
//                String redirectUrl = "CoordinadorServlet?action=filtrar";
//
//                if (zonaIdParam != null && !zonaIdParam.isEmpty()) {
//                    redirectUrl += "&zonaId=" + zonaIdParam;
//                }
//
//                if (distritoIdParam != null && !distritoIdParam.isEmpty()) {
//                    redirectUrl += "&distritoId=" + distritoIdParam;
//                }
//
//                response.sendRedirect(redirectUrl);
//
//                break;
//
//            // Prepara los parametros que apareceran en la vista "asignarFormulario"
//            case "asignarFormulario":
//                int idEncuestador = Integer.parseInt(request.getParameter("id"));
//                request.setAttribute("idEncuestador", idEncuestador);
//
//                String carpetaSeleccionada = request.getParameter("carpeta");
//                request.setAttribute("carpeta", carpetaSeleccionada);
//
//                // Lista de carpetas
//                ArrayList<String> listaCarpetas = encuestaDAO.obtenerCarpetasDisponibles();
//                request.setAttribute("listaCarpetas", listaCarpetas);
//
//                // Lista de encuestas de esa carpeta (si está seleccionada)
//                ArrayList<Encuesta> listaEncuestas = new ArrayList<>();
//                if (carpetaSeleccionada != null && !carpetaSeleccionada.isEmpty()) {
//                    listaEncuestas = encuestaDAO.obtenerEncuestasPorCarpeta(carpetaSeleccionada);
//                }
//                request.setAttribute("listaEncuestas", listaEncuestas);
//
//                // Mantener filtros anteriores si se volviera desde otra vista
//                request.setAttribute("zonaIdFiltro", request.getParameter("zonaId"));
//                request.setAttribute("distritoIdFiltro", request.getParameter("distritoId"));
//
//                view = request.getRequestDispatcher("Coordinador/asignarFormulario.jsp");
//                view.forward(request, response);
//                break;
//
//
//            // Obtener parámetros del filtro en la vista ListaVistaEncuestador.jsp
//
//            case "filtrar":
//                String zonaIdStr = request.getParameter("zonaId");
//                String distritoIdStr = request.getParameter("distritoId");
//
//                ArrayList<Zona> listaZonasFiltro = zonaDAO.obtenerListaZonas();
//                request.setAttribute("listaZonas", listaZonasFiltro);
//
//                if (zonaIdStr == null || zonaIdStr.isEmpty()) {
//                    // Mostrar todos los encuestadores si no se elige zona
//                    ArrayList<Usuario> listaEncuestadores1 = coordinadorDAO.listarEncuestadores();
//                    request.setAttribute("listaEncuestadores", listaEncuestadores1);
//                    request.setAttribute("listaDistritos", new ArrayList<>()); // lista vacía para ocultar
//                } else {
//                    // Zona seleccionada
//                    int zonaId = Integer.parseInt(zonaIdStr);
//                    request.setAttribute("zonaSeleccionada", zonaId);
//
//                    // Cargar distritos asociados a la zona
//                    ArrayList<Distrito> listaDistritos = coordinadorDAO.listarDistritosPorZona(zonaId);
//                    request.setAttribute("listaDistritos", listaDistritos);
//
//                    if (distritoIdStr == null || distritoIdStr.isEmpty()) {
//                        // Solo zona seleccionada
//                        ArrayList<Usuario> listaFiltrada = coordinadorDAO.listarEncuestadoresPorZona(zonaId);
//                        request.setAttribute("listaEncuestadores", listaFiltrada);
//                    } else {
//                        // Zona + distrito seleccionados
//                        int distritoId = Integer.parseInt(distritoIdStr);
//                        ArrayList<Usuario> listaFiltrada = coordinadorDAO.obtenerTodosEncuestadoresPorZonaYDistrito(zonaId, distritoId);
//                        request.setAttribute("distritoSeleccionado", distritoId);
//                        request.setAttribute("listaEncuestadores", listaFiltrada);
//                    }
//                }
//
//                view = request.getRequestDispatcher("Coordinador/VistaListaEncuestador.jsp");
//                view.forward(request, response);
//                break;
//
//
//            // ----Encuestas -----
//
//            // Ver
//            case "listarEncuestas":
//                carpetaSeleccionada = request.getParameter("carpeta");
//                ArrayList<Encuesta> encuestas;
//                ArrayList<String> carpetas = encuestaDAO.obtenerCarpetasDisponibles();
//
//                if (carpetaSeleccionada != null && !carpetaSeleccionada.isEmpty()) {
//                    encuestas = encuestaDAO.obtenerEncuestasPorCarpeta(carpetaSeleccionada);
//                } else {
//                    encuestas = encuestaDAO.obtenerEncuestasPorCarpeta(""); // Muestra todas si no se filtra
//                }
//
//                request.setAttribute("listaEncuestas", encuestas);
//                request.setAttribute("listaCarpetas", carpetas);
//                request.setAttribute("carpetaSeleccionada", carpetaSeleccionada);
//
//                view = request.getRequestDispatcher("Coordinador/VistaListaEncuestas.jsp");
//                view.forward(request, response);
//                break;
//
//            // Actualizar estado de encuesta (tiene que ir en doPost)
//            case "cambiarEstadoEncuesta":
//                int encuestaId = Integer.parseInt(request.getParameter("id"));
//                String estadoActualEncuesta = request.getParameter("estado"); // "activo" o "inactivo"
//                String nuevoEstadoEncuesta = estadoActualEncuesta.equals("activo") ? "inactivo" : "activo";
//
//                encuestaDAO.actualizarEstadoEncuesta(encuestaId, nuevoEstadoEncuesta);
//
//                // Redireccionar de vuelta a la lista de encuestas
//                String carpetaParam = request.getParameter("carpeta");
//                redirectUrl = "CoordinadorServlet?action=listarEncuestas&mensaje=estadoActualizado";
//                if (carpetaParam != null && !carpetaParam.isEmpty()) {
//                    redirectUrl += "&carpeta=" + carpetaParam;
//                }
//                response.sendRedirect(redirectUrl);
//
//
//                break;
//
//            // Ver perfil de encuesta
//            case "verEncuesta":
//                int idEncuesta = Integer.parseInt(request.getParameter("id"));
//                Encuesta encuesta = encuestaDAO.obtenerEncuestaPorId(idEncuesta);
//                request.setAttribute("encuesta", encuesta);
//                view = request.getRequestDispatcher("Coordinador/verEncuesta.jsp");
//                view.forward(request, response);
//                break;
//
//            // filtrar zona y distrito para asignar formulario a encuestador
//
//            case "filtrarAsignar":
//
//                String zonaFiltrarIdStr = request.getParameter("zonaId");
//                String distritoFiltrarIdStr = request.getParameter("distritoId");
//                String encuestaIdStr = request.getParameter("encuestaId");
//                carpetaParam = request.getParameter("carpeta");
//                String nombreEncuesta = request.getParameter("nombreEncuesta");
//
//                if (carpetaParam != null) request.setAttribute("carpetaSeleccionada", carpetaParam);
//                if (nombreEncuesta != null) request.setAttribute("nombreEncuesta", nombreEncuesta);
//
//                ArrayList<Zona> zonas = zonaDAO.obtenerListaZonas();
//                request.setAttribute("listaZonas", zonas);
//
//                // Guardar el ID de la encuesta seleccionada para usarlo en el JSP
//                if (encuestaIdStr != null && !encuestaIdStr.isEmpty()) {
//                    request.setAttribute("encuestaId", encuestaIdStr);
//                }
//
//
//                if (zonaFiltrarIdStr != null && !zonaFiltrarIdStr.isEmpty()) {
//                    int zonaId = Integer.parseInt(zonaFiltrarIdStr);
//                    ArrayList<Distrito> distritos = coordinadorDAO.listarDistritosPorZona(zonaId);
//                    request.setAttribute("listaDistritos", distritos);
//                    request.setAttribute("zonaSeleccionada", zonaId);
//
//                    if (distritoFiltrarIdStr != null && !distritoFiltrarIdStr.isEmpty()) {
//                        int distritoId = Integer.parseInt(distritoFiltrarIdStr);
//                        ArrayList<Usuario> encuestadoresFiltrados = coordinadorDAO.obtenerEncuestadoresPorZonaYDistrito(zonaId, distritoId);
//                        request.setAttribute("listaEncuestadores", encuestadoresFiltrados);
//                        request.setAttribute("distritoSeleccionado", distritoId);
//                    }
//                }
//
//                view = request.getRequestDispatcher("Coordinador/asignarFormulario2.jsp");
//                view.forward(request, response);
//                break;
//
//
//            // --MENU--
//
//            case "menu":
//                view = request.getRequestDispatcher("Coordinador/CoordinadorMenu.jsp");
//                view.forward(request, response);
//                break;
//
//
//            default:
//                response.sendRedirect("CoordinadorServlet?action=lista");
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String action = request.getParameter("action");
//
//        if ("guardarAsignacion".equals(action)) {
//            int encuestadorId = Integer.parseInt(request.getParameter("idEncuestador"));
//            String nombreEncuesta = request.getParameter("nombreEncuesta");
//            String carpeta = request.getParameter("carpeta");
//
//            // En este ejemplo el coordinador que asigna es el ID 1 (en un caso real se obtiene del session)
//            int coordinadorId = 1;
//
//            coordinadorDAO.asignarEncuesta(nombreEncuesta, carpeta, encuestadorId, coordinadorId);
//
//            // Revisar el origen de la solicitud
//            String origen = request.getParameter("origen");
//
//            if ("vistaEncuestadores".equals(origen)) {
//                // Recuperar filtros
//                String zonaId = request.getParameter("zonaId");
//                String distritoId = request.getParameter("distritoId");
//
//                String redirectUrl = "CoordinadorServlet?action=filtrar";
//                if (zonaId != null && !zonaId.isEmpty()) {
//                    redirectUrl += "&zonaId=" + zonaId;
//                }
//                if (distritoId != null && !distritoId.isEmpty()) {
//                    redirectUrl += "&distritoId=" + distritoId;
//                }
//                redirectUrl += "&mensaje=asignacionExitosa";
//
//                response.sendRedirect(redirectUrl);
//
//            } else {
//                // Por defecto redirige a encuestas (lógica anterior intacta)
//                String redirectUrl = "CoordinadorServlet?action=listarEncuestas";
//                if (carpeta != null && !carpeta.isEmpty()) {
//                    redirectUrl += "&carpeta=" + carpeta + "&mensaje=asignacionExitosa";
//                }
//                response.sendRedirect(redirectUrl);
//            }
//        }
//        // Asignacion de encuestas desde la secion "encuestas"
//        if ("guardarAsignacionDesdeEncuestas".equals(action)) {
//            int encuestadorId = Integer.parseInt(request.getParameter("idEncuestador"));
//            int encuestaId = Integer.parseInt(request.getParameter("encuestaId"));
//            int coordinadorId = 1;
//
//            coordinadorDAO.asignarEncuestaPorId(encuestaId, encuestadorId, coordinadorId);
//
//            String carpeta = request.getParameter("carpeta");
//            String redirectUrl = "CoordinadorServlet?action=listarEncuestas&mensaje=asignacionExitosa";
//            if (carpeta != null && !carpeta.isEmpty()) {
//                redirectUrl += "&carpeta=" + carpeta;
//            }
//            response.sendRedirect(redirectUrl);
//        }
//
//
//    }
//
//
//}