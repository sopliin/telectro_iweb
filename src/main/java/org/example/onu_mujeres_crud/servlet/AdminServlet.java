package org.example.onu_mujeres_crud.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.example.onu_mujeres_crud.EmailSender;
import org.example.onu_mujeres_crud.beans.Distrito;
import org.example.onu_mujeres_crud.beans.Rol;
import org.example.onu_mujeres_crud.beans.Usuario;
import org.example.onu_mujeres_crud.beans.Zona;
import org.example.onu_mujeres_crud.daos.*;
import org.example.onu_mujeres_crud.dtos.DashboardDTO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

//Hola :D
@WebServlet(name = "AdminServlet", value = "/AdminServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class AdminServlet extends HttpServlet {

    private static final int REGISTROS_POR_PAGINA = 10;
    private static final int DEFAULT_REGISTROS_POR_PAGINA = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        //Verificar sesion y rol de admin
        if (user == null || user.getRol().getRolId() != 3) {
            response.sendRedirect("index.jsp?error=notLoggedIn");
            return;
        }

        String action = request.getParameter("action") == null ? "dashboard" : request.getParameter("action");
        RequestDispatcher view;

        switch (action) {
            case "dashboard":
                //Logica para dashboard
                //view = request.getRequestDispatcher("admin/dashboard.jsp");
                //view.forward(request, response);
                cargarDashboard(request, response);
                break;

            case "generarReporte":
                generarReporteExcel(request, response);
                break;

            case "listaUsuarios":
                String filtroRol = request.getParameter("filtroRol");
                String filtroEstado = request.getParameter("filtroEstado");
                String filtroBusqueda = request.getParameter("filtroBusqueda");

                // Validar que el filtro de rol no sea para administradores
                if (filtroRol != null && filtroRol.equals("3")) {
                    filtroRol = null; // Ignorar este filtro
                }

                // Obtener número de página
                int pagina = 1;
                try {
                    pagina = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    // Si no viene parámetro, queda en 1
                }

                // Obtener registros por página
                int registrosPorPagina = DEFAULT_REGISTROS_POR_PAGINA;
                try {
                    registrosPorPagina = Integer.parseInt(request.getParameter("registrosPorPagina"));
                } catch (NumberFormatException e) {
                    // Si no viene parámetro o es inválido, usa el valor por defecto
                }

                UsuarioAdminDao usuarioAdminDao = new UsuarioAdminDao();

                // Obtener total de registros para paginación
                int totalUsuarios = usuarioAdminDao.contarUsuariosFiltrados(filtroRol, filtroEstado, filtroBusqueda);
                int totalPaginas = (int) Math.ceil((double) totalUsuarios / registrosPorPagina);

                // Asegurarse de que la página actual no exceda el total
                if (pagina > totalPaginas && totalPaginas > 0) {
                    pagina = totalPaginas;
                }

                // Obtener usuarios para la página actual
                ArrayList<Usuario> usuariosFiltrados = usuarioAdminDao.listarUsuariosFiltrados(
                        filtroRol, filtroEstado, filtroBusqueda, pagina, registrosPorPagina
                );

                request.setAttribute("listaUsuarios", usuariosFiltrados);
                request.setAttribute("paginaActual", pagina);
                request.setAttribute("totalPaginas", totalPaginas);
                request.setAttribute("totalUsuarios", totalUsuarios);
                request.setAttribute("registrosPorPagina", registrosPorPagina);

                view = request.getRequestDispatcher("admin/lista.jsp");
                view.forward(request, response);
                break;

            case "nuevoCoordinador":
                DistritoDAO distritoDAO = new DistritoDAO();

                request.setAttribute("listaDistritos", distritoDAO.obtenerListaDistritos2());
                view = request.getRequestDispatcher("/admin/formularioNuevo.jsp");
                view.forward(request, response);
                break;


            case "verPerfil":
                view = request.getRequestDispatcher("/admin/administrador_ver_tu_perfil.jsp");
                view.forward(request, response);
                break;

            case "cambiarContrasena":
                view = request.getRequestDispatcher("/admin/cambiar_contrasena.jsp");
                view.forward(request, response);
                //handleChangePasswordGet(request, response);
                break;

            case "desactivarUsuario":
                int usuarioIdDesactivar = Integer.parseInt(request.getParameter("id"));
                UsuarioAdminDao adminDao = new UsuarioAdminDao();
                adminDao.desactivarUsuario(usuarioIdDesactivar);
                response.sendRedirect(request.getContextPath() +"/AdminServlet?action=listaUsuarios");
                break;

            case "activarUsuario":
                int usuarioIdActivar = Integer.parseInt(request.getParameter("id"));
                UsuarioAdminDao adminDaoAct = new UsuarioAdminDao();
                adminDaoAct.activarUsuario(usuarioIdActivar);
                response.sendRedirect(request.getContextPath() +"/AdminServlet?action=listaUsuarios");
                break;
            case "detallesUsuario":
                UsuarioDAO usuarioDao = new UsuarioDAO();
                int usuarioIdVer= Integer.parseInt(request.getParameter("id"));
                Usuario user2 = usuarioDao.obtenerUsuario1(usuarioIdVer);
                request.setAttribute("detalles", user2);
                view = request.getRequestDispatcher("/admin/ver_detalles_coord.jsp");
                view.forward(request, response);
                //TO DO
                break;

            default:
                response.sendRedirect(request.getContextPath() +"/AdminServlet?action=dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null || user.getRol().getRolId() != 3) {
            response.sendRedirect("index.jsp?error=notLoggedIn");
            return;
        }

//        usuario.setNombre(request.getParameter("nombre"));
//        usuario.setApellidoPaterno(request.getParameter("apellidoPaterno"));
//        usuario.setApellidoMaterno(request.getParameter("apellidoMaterno"));
//        usuario.setDni(request.getParameter("dni"));
//        usuario.setCorreo(request.getParameter("correo"));
//
//        Rol rol = new Rol();
//        rol.setRolId(2);    //Rol de Coordinador
//        usuario.setRol(rol);
//
//        //Capturar zona-id desde el form
//        Zona zona = new Zona();
//        zona.setZonaId(Integer.parseInt(request.getParameter("zonaId")));
//        usuario.setZona(zona);
//
//        //Capturar Distrito-id desde el form
//        Distrito distrito = new Distrito();
//        distrito.setDistritoId(Integer.parseInt(request.getParameter("distritoId")));
//        usuario.setDistrito(distrito);
//
//        try {
//            //Validar dni unico
//            if(usuarioDAO.existeDNI(usuario.getDni())) {
//                request.setAttribute("error", "Ya existe un Coordinador Interno con ese DNI.");
//                request.getRequestDispatcher("admin/formularioNuevo.jsp").forward(request, response);
//                return;
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Error al registrar nuevo coordinador");
//            request.getRequestDispatcher("admin/formularioNuevo.jsp").forward(request, response);
//        }

        switch (action) {
            case "crearCoordinador":
                crearNuevoCoordinador(request,response);
                break;
            case "actualizarPassword":
                actualizarContrasenaAdmin(request, response);
                break;
            case "generarReporte":
                generarReporteExcel(request,response);
                break;
            case "uploadPhoto":
                subirFoto(request, response);
                break;
        }
    }

    private void crearNuevoCoordinador(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario coordinador = new Usuario();
        coordinador.setNombre(request.getParameter("nombre"));
        coordinador.setApellidoPaterno(request.getParameter("apellidoPaterno"));
        coordinador.setApellidoMaterno(request.getParameter("apellidoMaterno"));
        coordinador.setDni(request.getParameter("dni"));
        coordinador.setCorreo(request.getParameter("correo"));
        HttpSession session = request.getSession();
        Rol rol = new Rol();
        rol.setRolId(2);
        coordinador.setRol(rol);

        Distrito distrito = new Distrito();
        distrito.setDistritoId(Integer.parseInt(request.getParameter("distritoId")));
        coordinador.setDistrito(distrito);

        Zona zona = new Zona();
        zona.setZonaId(Integer.parseInt(request.getParameter("zonaId")));
        coordinador.setZona(zona);
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        UsuarioAdminDao adminDao = new UsuarioAdminDao();
        try {
            if (adminDao.existeDNI(coordinador.getDni())) {
                session.setAttribute("error", "Ya existe un usuario con ese DNI");
                response.sendRedirect(request.getContextPath() +"/AdminServlet?action=nuevoCoordinador");
            } else if(usuarioDAO.verificarCorreo(coordinador.getCorreo())!= null){
                session.setAttribute("error", "Ya existe un correo registrado ");
                response.sendRedirect(request.getContextPath() +"/AdminServlet?action=nuevoCoordinador");
            }
            else{
                if (adminDao.crearUsuario1(coordinador)) {
                    TokenDAO tokenDao = new TokenDAO();
                    String token = tokenDao.generateToken(coordinador.getCorreo());
                    String validationLink = request.getRequestURL().toString().replace(request.getServletPath(), "") + "/login?action=validate_email&token=" + token;
                    String emailBody = "Por favor valide su correo haciendo clic en el siguiente enlace:\n" + validationLink;
                    System.out.println(request.getRequestURL().toString().replace(request.getServletPath(), ""));
                    System.out.println(request.getContextPath());
                    EmailSender.sendEmail(coordinador.getCorreo(), "Validación de correo - ONU Mujeres", emailBody);
                    session.setAttribute("success", "Se envio el correo al coordinador con exito al correo "+coordinador.getCorreo());
                    response.sendRedirect(request.getContextPath() +"/AdminServlet?action=nuevoCoordinador");


                } else {
                    session.setAttribute("error", "creacion fallida ");
                    response.sendRedirect(request.getContextPath() +"/AdminServlet?action=nuevoCoordinador");
                }
                //adminDao.registrarCoordinador(coordinador);
                //response.sendRedirect("AdminServlet?action=listaUsuarios&sucess=1");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() +"/AdminServlet?action=nuevoCoordinador");
        }
    }


    private void actualizarContrasenaAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        if (user == null) {
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "Las contraseñas no coinciden");
            response.sendRedirect(request.getContextPath() +"/AdminServlet?action=cambiarContrasena");
            return;
        }
        // Verificar contraseña actual
        if (!usuarioDAO.verificarContrasena(user.getUsuarioId(), currentPassword)) {
            session.setAttribute("error", "La contraseña actual es incorrecta");
            response.sendRedirect(request.getContextPath() +"/AdminServlet?action=cambiarContrasena");
            return;
        }

        // Actualizar contraseña
        boolean success = usuarioDAO.actualizarContrasena(user.getUsuarioId(), newPassword);

        if (success) {
            session.setAttribute("success", "Contraseña actualizada correctamente");
        } else {
            session.setAttribute("error", "Error al actualizar la contraseña");
        }

        response.sendRedirect(request.getContextPath() +"/AdminServlet?action=cambiarContrasena");
    }
    private void subirFoto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            System.out.println("ultimo encuestador");
            response.sendRedirect("login.jsp");
            return;
        }

        Part filePart = request.getPart("foto");
        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("no seleccioo una foto");
            request.setAttribute("error", "No se seleccionó una foto.");

            request.getRequestDispatcher("/admin/administrador_ver_tu_perfil.jsp").forward(request, response);
            return;
        }

        String contentType = filePart.getContentType();
        System.out.println("Content-Type recibido: " + contentType);
        String extension = getExtension(contentType);
        if (extension == null) {
            System.out.println("no seleccioo no peritido");
            request.setAttribute("error", "Tipo de archivo no permitido.");
            request.getRequestDispatcher("/admin/administrador_ver_tu_perfil.jsp").forward(request, response);
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

        response.sendRedirect(request.getContextPath() +"/AdminServlet?action=verPerfil");
    }

    private String getExtension(String contentType) {
        return switch (contentType) {
            case "image/jpeg" -> "jpg";
            case "image/png" -> "png";
            case "image/gif" -> "gif";
            default -> null;
        };
    }

    private void cargarDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioAdminDao adminDao = new UsuarioAdminDao();
        DashboardDTO estadisticas = adminDao.obtenerEstadisticasDashboard();
        Map<String, Integer> usuariosPorMes = adminDao.obtenerUsuariosPorMes();
        Map<String, Integer> distribucionRoles = adminDao.obtenerDistribucionRoles();

        request.setAttribute("estadisticas", estadisticas);
        request.setAttribute("usuariosPorMes", usuariosPorMes);
        request.setAttribute("distribucionRoles", distribucionRoles);

        RequestDispatcher view = request.getRequestDispatcher("/admin/dashboard.jsp");
        view.forward(request, response);
    }

    private void generarReporteExcel(HttpServletRequest request, HttpServletResponse response) {
        String tipoReporte = request.getParameter("tipoReporte");
        String nombreReporte;
        if (tipoReporte.equals("todos")) {
            nombreReporte = "usuarios";
        } else if (tipoReporte.equals("activos")) {
            nombreReporte = "activos";
        } else if (tipoReporte.equals("inactivos")) {
            nombreReporte = "inactivos";
        } else if (tipoReporte.equals("coordinadores")) {
            nombreReporte = "coordinadores";
        } else if (tipoReporte.equals("encuestadores")) {
            nombreReporte = "encuestadores";
        } else {
            nombreReporte = tipoReporte;
        }
        try {
            UsuarioAdminDao adminDao = new UsuarioAdminDao();
            ArrayList<Usuario> usuarios = adminDao.obtenerUsuariosParaReporte(tipoReporte);

            // Configurar respuesta
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=reporte_" + nombreReporte +".xlsx");
//            response.setHeader("Content-Disposition", "attachment; filename=reporte_usuarios.xlsx");

            // Crear libro Excel
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Usuarios");

            // Crear fila de encabezados
            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "Nombre", "Apellidos", "DNI", "Correo", "Rol", "Zona", "Distrito","Código único de Encuestador", "Estado", "Fecha Registro"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
            }

            // Llenar datos
            int rowNum = 1;
            for (Usuario usuario : usuarios) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(rowNum-1);
                row.createCell(1).setCellValue(usuario.getNombre());
                row.createCell(2).setCellValue(usuario.getApellidoPaterno() + " " +
                        (usuario.getApellidoMaterno() != null ? usuario.getApellidoMaterno() : ""));
                row.createCell(3).setCellValue(usuario.getDni());
                row.createCell(4).setCellValue(usuario.getCorreo());
                row.createCell(5).setCellValue(usuario.getRol().getNombre());
                row.createCell(6).setCellValue(usuario.getZona() != null ? usuario.getZona().getNombre() : "N/A");
                row.createCell(7).setCellValue(usuario.getDistrito() != null ? usuario.getDistrito().getNombre() : "N/A");
                String codigoUnico = usuario.getCodigoUnicoEncuestador();
                row.createCell(8).setCellValue(
                        codigoUnico != null && !codigoUnico.isEmpty() ? codigoUnico : "No aplica"
                );
                row.createCell(9).setCellValue(usuario.getEstado());
                row.createCell(10).setCellValue(usuario.getFechaRegistro());
            }

            // Autoajustar columnas
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Escribir archivo
            workbook.write(response.getOutputStream());
            workbook.close();

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.sendRedirect("AdminServlet?action=dashboard&error=Error al generar reporte");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}