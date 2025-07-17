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
import java.io.File;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "EncuestadorServlet", value = "/EncuestadorServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class EncuestadorServlet extends HttpServlet {
    private static final int DEFAULT_PAGE_SIZE = 10;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") == null ? "total" : request.getParameter("action");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        int encuestadorId = user.getUsuarioId();
        //
        if (encuestadorId == 0) {
            response.sendRedirect("login.jsp?error=notLoggedIn");
            return;
        }


        //TODO: Obtener el id del encuestador de la sesión (Mover esto dentro de cada case donde se use)
        //int encuestadorId = 27;

        // Parámetros de paginación
        int page = 1;
        int pageSize = DEFAULT_PAGE_SIZE;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }

        try {
            pageSize = Integer.parseInt(request.getParameter("pageSize"));
        } catch (NumberFormatException e) {
            pageSize = DEFAULT_PAGE_SIZE;
        }

        EncuestaDAO encuestaDAO = new EncuestaDAO();
        //ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();
        RequestDispatcher view;

        switch (action) {
            case "total":
                int totalCount = encuestaDAO.contarEncuestasAsignadas(encuestadorId, null);
                List<EncuestaAsignada> todasLasEncuestas = encuestaDAO.obtenerFormulariosCompletados2(
                        encuestadorId, (page - 1) * pageSize, pageSize);

                request.setAttribute("listaEncuestas", todasLasEncuestas);
                request.setAttribute("totalCount", totalCount);
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                view = request.getRequestDispatcher("/encuestador/encuestador_encuestadas.jsp");
                view.forward(request, response);
                break;
            case "terminados":
                int terminadosCount = encuestaDAO.contarEncuestasAsignadas(encuestadorId, "completada");
                List<EncuestaAsignada> encuestasTerminadas = encuestaDAO.obtenerFormulariosCompletados1(
                        encuestadorId, "completada", (page - 1) * pageSize, pageSize);

                request.setAttribute("listaEncuestas", encuestasTerminadas);
                request.setAttribute("totalCount", terminadosCount);
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                view = request.getRequestDispatcher("/encuestador/encuestador_encuestas_completadas.jsp");
                view.forward(request, response);
                break;
            case "pendientes":
                int pendientesCount = encuestaDAO.contarEncuestasAsignadas(encuestadorId, "asignada");
                List<EncuestaAsignada> encuestasPendientes = encuestaDAO.obtenerFormulariosCompletados1(
                        encuestadorId, "asignada", (page - 1) * pageSize, pageSize);

                request.setAttribute("listaEncuestas", encuestasPendientes);
                request.setAttribute("totalCount", pendientesCount);
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                view = request.getRequestDispatcher("/encuestador/encuestador_encuestas_sin_completar.jsp");
                view.forward(request, response);
                break;
            case "borradores":
                int borradoresCount = encuestaDAO.contarEncuestasAsignadas(encuestadorId, "en_progreso");
                List<EncuestaAsignada> encuestasBorradores = encuestaDAO.obtenerFormulariosCompletados1(
                        encuestadorId, "en_progreso", (page - 1) * pageSize, pageSize);

                request.setAttribute("listaEncuestas", encuestasBorradores);
                request.setAttribute("totalCount", borradoresCount);
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                view = request.getRequestDispatcher("/encuestador/encuestador_encuestas_progreso.jsp");
                view.forward(request, response);
                break;
            //ever
            case "ver":
                view = request.getRequestDispatcher("/encuestador/encuestador_ver_tu_perfil.jsp");
                view.forward(request, response);
                break;
            case "editarPerfil":
                handleEditProfileGet(request, response);
                break;
            case "cambiarContrasena":
                handleChangePasswordGet(request, response);
                break;
            case "crearFormulario":
                view = request.getRequestDispatcher("/encuestador/encuestador_formulario.jsp");
                view.forward(request, response);
                    break;
            case "descripcion":
                EncuestaDAO encuestaDAO2 = new EncuestaDAO();
                int usuarioIdVer= Integer.parseInt(request.getParameter("id"));
                Encuesta enc = encuestaDAO2.obtenerEncuestaPorId(usuarioIdVer);
                request.setAttribute("detalles", enc);
                view = request.getRequestDispatcher("/encuestador/descripcion.jsp");
                view.forward(request, response);
                break;
//            case "obtenerBorrador":
//                if (request.getParameter("encuestaId") != null) {
//                    int encuestaId = Integer.parseInt(request.getParameter("encuestaId"));
//
//                    //TODO: Obtener el respuestaId del borrador para la encuesta y el encuestador
//                    int respuestaId = obtenerRespuestaIdDeBorrador(encuestadorId, encuestaId); // Replace with actual logi
//                    if (respuestaId == 0) {
//
//                        response.sendRedirect("EncuestadorServlet?action=pendientes");
//                        return;
//                    }
//
//                    List<RespuestaDetalle> respuestasGuardadas = contenidoEncuestaDAO.obtenerRespuestasAnteriores(respuestaId);
//                    request.setAttribute("respuestasGuardadas", respuestasGuardadas);
//                    request.setAttribute("encuestaId", encuestaId);
//                    List<PreguntaEncuesta> preguntas = contenidoEncuestaDAO.obtenerPreguntasDeEncuesta(encuestadorId, encuestaId);
//                    request.setAttribute("preguntas", preguntas);
//                    view = request.getRequestDispatcher("encuestador/encuestador_formulario.jsp");
//                    view.forward(request, response);
//                } else {
//                    response.sendRedirect("EncuestadorServlet?action=borradores");
//                }
//                break;
            default:
                response.sendRedirect(request.getContextPath() +"/EncuestadorServlet?action=total");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        //TODO: Obtener el id del encuestador de la sesión

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        int encuestadorId = user.getUsuarioId();
        if (encuestadorId == 0) {
            response.sendRedirect("login.jsp?error=notLoggedIn");
            return;
        }

        ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();
        //ever
        switch (action) {
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

//        switch (action) {
//            case "guardarRespuestas":
//                int encuestaId = Integer.parseInt(request.getParameter("encuestaId"));
//
//                //TODO: Obtener o crear el respuestaId (if it's a new or existing response)
//                int respuestaId = obtenerOCrearRespuestaId(encuestadorId, encuestaId);
//                if (respuestaId == 0) {
//                    response.sendRedirect("EncuestadorServlet?error=dbError");
//                    return;
//                }
//
//                java.util.Enumeration<String> paramNames = request.getParameterNames();
//                while (paramNames.hasMoreElements()) {
//                    String paramName = paramNames.nextElement();
//                    if (paramName.startsWith("pregunta_")) {
//                        int preguntaId = Integer.parseInt(paramName.substring(9));
//                        String respuesta = request.getParameter(paramName);
//                        int opcionId = 0;
//
//                        if (paramName.contains("opcion")) {
//                            opcionId = Integer.parseInt(respuesta);
//                            respuesta = null;
//                        }
//
//                        LocalDateTime now = LocalDateTime.now();
//                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
//                        String fechaContestacion = now.format(formatter);
//
//                        RespuestaDetalle detalle = new RespuestaDetalle();
//                        detalle.setRespuestaId(respuestaId);
//                        detalle.setPreguntaId(preguntaId);
//                        detalle.setOpcionId(opcionId);
//                        detalle.setRespuestaTexto(respuesta);
//                        detalle.setFechaContestacion(fechaContestacion);
//
//                        contenidoEncuestaDAO.guardarRespuesta(detalle);
//                    }
//                }
//                response.sendRedirect("EncuestadorServlet?action=total");
//                break;
//
//            case "guardar":
//                response.sendRedirect("login.jsp");
//                break;
//        }
    }
    private void handleChangePasswordGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }

        RequestDispatcher view = request.getRequestDispatcher("/encuestador/cambiar_contrasena.jsp");
        view.forward(request, response);
    }

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
            response.sendRedirect(request.getContextPath() +"EncuestadorServlet?action=cambiarContrasena");
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        // Verificar contraseña actual
        if (!usuarioDAO.verificarContrasena(user.getUsuarioId(), currentPassword)) {
            session.setAttribute("error", "La contraseña actual es incorrecta");
            response.sendRedirect(request.getContextPath() +"/EncuestadorServlet?action=cambiarContrasena");
            return;
        }

        // Actualizar contraseña
        boolean success = usuarioDAO.actualizarContrasena(user.getUsuarioId(), newPassword);

        if (success) {
            session.setAttribute("success", "Contraseña actualizada correctamente");
        } else {
            session.setAttribute("error", "Error al actualizar la contraseña");
        }

        response.sendRedirect(request.getContextPath() +"/EncuestadorServlet?action=cambiarContrasena");
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
            request.getRequestDispatcher("/encuestador/encuestador_ver_tu_perfil.jsp").forward(request, response);
            return;
        }

        String contentType = filePart.getContentType();
        System.out.println("Content-Type recibido: " + contentType);
        String extension = getExtension(contentType);
        if (extension == null) {
            System.out.println("no seleccioo no peritido");
            request.setAttribute("error", "Tipo de archivo no permitido.");
            request.getRequestDispatcher("/encuestador/encuestador_ver_tu_perfil.jsp").forward(request, response);
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

        response.sendRedirect(request.getContextPath() +"/EncuestadorServlet?action=ver");
    }

    private String getExtension(String contentType) {
        return switch (contentType) {
            case "image/jpeg" -> "jpg";
            case "image/png" -> "png";
            case "image/gif" -> "gif";
            default -> null;
        };
    }
    private void handleEditProfileGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        DistritoDAO distritoDAO = new DistritoDAO();
        int zonaid = user.getZona().getZonaId();
        System.out.println("es de la zona "+zonaid);
        ArrayList<Distrito> distritos = distritoDAO.obtenerListaDistritosxZona(zonaid);

        request.setAttribute("distritos", distritos);
        RequestDispatcher view = request.getRequestDispatcher("/encuestador/editar_perfil.jsp");
        view.forward(request, response);
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String direccion = request.getParameter("direccion");
        int distritoId = Integer.parseInt(request.getParameter("distrito"));
        DistritoDAO distritoDAO = new DistritoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean success = usuarioDAO.actualizarPerfil(user.getUsuarioId(), direccion, distritoId);

        if (success) {
            // Actualizar datos en sesión
            user.setDireccion(direccion);
            ;
            Distrito distrito = new Distrito();
            distrito.setDistritoId(distritoId);
            distrito.setNombre(distritoDAO.obtenerNombreDistrito(distritoId));
            user.setDistrito(distrito);

            session.setAttribute("usuario", user);
            session.setAttribute("success", "Perfil actualizado correctamente");
        } else {
            session.setAttribute("error", "Error al actualizar el perfil");
        }

        response.sendRedirect(request.getContextPath() +"/EncuestadorServlet?action=editarPerfil");
    }
    //ever fin de mis metodos


    private int obtenerEncuestadorIdDeSesion(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer encuestadorId = (Integer) session.getAttribute("encuestadorId"); // Assuming you store it as "encuestadorId"
        if (encuestadorId == null) {
            return 0; // Or throw an exception, or handle as appropriate for your app
        }
        return encuestadorId;
    }

    private int obtenerRespuestaIdDeBorrador(int encuestadorId, int encuestaId) {
        // TODO: Implement this method to query the database and get the respuesta_id
        //       for the given encuestadorId and encuestaId where the response is a draft.
        //       You'll likely need a RespuestaDAO for this.
        //       Return 0 if no draft exists.
        // For now, return a placeholder:
        return 0;  // Placeholder
    }

    private int obtenerOCrearRespuestaId(int encuestadorId, int encuestaId) {
        // TODO: Implement this method.
        //       It should check if a respuesta_id exists for the encuestadorId and encuestaId.
        //       If it exists (a draft), return the existing ID.
        //       If it doesn't exist (new response), create a new Respuesta record in the database
        //       and return the generated respuesta_id.  Again, use a RespuestaDAO.
        //       Return 0 if there's an error.
        // For now, return a placeholder:
        return 0; // Placeholder
    }
}
