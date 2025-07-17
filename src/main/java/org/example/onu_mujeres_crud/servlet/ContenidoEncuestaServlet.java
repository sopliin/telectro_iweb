package org.example.onu_mujeres_crud.servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.onu_mujeres_crud.beans.*;
import org.example.onu_mujeres_crud.daos.ContenidoEncuestaDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.SQLOutput;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ContenidoEncuestaServlet", value = "/ContenidoEncuestaServlet")
public class ContenidoEncuestaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") == null ? "mostrar" : request.getParameter("action");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        int usuarioId = user.getUsuarioId();
        ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();
        RequestDispatcher view;

        switch (action) {
            case "mostrar":
                // AsignacionId quemado a 1 para fines de prueba o debe venir de la sesión/parámetros
                int id = Integer.parseInt(request.getParameter("asignacionId"));
                //demas inicio
                //EncuestaAsignada encuestaAsignada = null;
                //try {
                //    encuestaAsignada = contenidoEncuestaDAO.obtenerEncuestaAsignadaPorEncuestador(user.getUsuarioId());
                //} catch (SQLException e) {
                //    throw new RuntimeException(e);
                //}
                //encuestaAsignada.setAsignacionId(6);    //Hardcodeo
                //System.out.println(encuestaAsignada.getAsignacionId());
                //FALTA SETEAR LOS ATRIBUTOS DEL OBJETO
                //demas cierr
                //int asignacionId = encuestaAsignada.getAsignacionId(); // Ajusta esto para obtener el ID real de la asignación
                int asignacionId = id;  //DEBERIA DARME 6
                try {
                    // 1. Obtener las preguntas de la encuesta asignada
                    ArrayList<BancoPreguntas> preguntas = contenidoEncuestaDAO.obtenerPreguntasDeEncuestaAsignada(asignacionId);

                    // 2. Para cada pregunta de tipo "opcion_unica" o "opcion_multiple", obtener sus opciones
                    for (BancoPreguntas pregunta : preguntas) {
                        if (pregunta.getTipo().equals("opcion_unica") || pregunta.getTipo().equals("opcion_multiple")) {
                            ArrayList<PreguntaOpcion> opciones = contenidoEncuestaDAO.obtenerOpcionesDePregunta(pregunta.getPreguntaId());
                            request.setAttribute("opciones_" + pregunta.getPreguntaId(), opciones);
                        }
                    }

                    // 3. Intentar obtener las respuestas guardadas previamente para prellenar el formulario
                    ArrayList<RespuestaDetalle> respuestasBorrador = contenidoEncuestaDAO.obtenerRespuestasDeAsignacion(asignacionId);

                    Map<Integer, List<String>> respuestasUsuarioOpciones = new HashMap<>();
                    Map<Integer, String> respuestasUsuarioTextoNumerico = new HashMap<>();

                    String dniEncuestadoBorrador = null;
                    String fechaInicioBorrador = null;

                    if (!respuestasBorrador.isEmpty()) {
                        // Se asume que el DNI y la fecha de inicio son los mismos para todos los detalles de una misma respuesta.
                        dniEncuestadoBorrador = respuestasBorrador.get(0).getRespuesta().getDniEncuestado();
                        fechaInicioBorrador = respuestasBorrador.get(0).getRespuesta().getFechaInicio();

                        for (RespuestaDetalle rd : respuestasBorrador) {
                            if (rd.getOpcion() != null) {
                                respuestasUsuarioOpciones.computeIfAbsent(rd.getPregunta().getPreguntaId(), k -> new ArrayList<>())
                                        .add(String.valueOf(rd.getOpcion().getOpcionId()));
                            } else if (rd.getRespuestaTexto() != null) {
                                respuestasUsuarioTextoNumerico.put(rd.getPregunta().getPreguntaId(), rd.getRespuestaTexto());
                            }
                        }
                    }

                    request.setAttribute("respuestasUsuarioOpciones", respuestasUsuarioOpciones);
                    request.setAttribute("respuestasUsuarioTextoNumerico", respuestasUsuarioTextoNumerico);
                    request.setAttribute("dniEncuestadoBorrador", dniEncuestadoBorrador);
                    request.setAttribute("fechaInicioBorrador", fechaInicioBorrador);

                    request.setAttribute("preguntasEncuesta", preguntas);
                    request.setAttribute("asignacionId", id);
                    // Redirigir siempre a encuestador/mostrarEncuesta.jsp
                    view = request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp");
                    view.forward(request, response);

                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Error al cargar las preguntas de la encuesta: " + e.getMessage());
                    // Redirigir siempre a encuestador/mostrarEncuesta.jsp con el error
                    view = request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp");
                    view.forward(request, response);
                }
                break;
            default:
                // Si la acción no es "mostrar", redirigir a la página principal o a encuestador/mostrarEncuesta.jsp
                response.sendRedirect(request.getContextPath() + "/encuestador/mostrarEncuesta.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();

        String asignacionIdParam = request.getParameter("asignacionId");
        int asignacionId = 0;
        if (asignacionIdParam != null && !asignacionIdParam.isEmpty()) {
            try {
                asignacionId = Integer.parseInt(asignacionIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de asignación inválido al guardar.");
                request.getRequestDispatcher("encuestador/mostrarEncuesta.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("error", "ID de asignación no presente al guardar.");
            request.getRequestDispatcher("encuestador/mostrarEncuesta.jsp").forward(request, response);
            return;
        }
        System.out.println(asignacionId);
        String dniEncuestado = request.getParameter("dniEncuestado");
        String fechaInicio = request.getParameter("fechaInicio");

        // Validación STRICTA solo para "guardarCompleta"
        if ("guardarCompleta".equals(action)) {
            if (dniEncuestado == null || dniEncuestado.trim().isEmpty() || !dniEncuestado.matches("\\d{8}")) {
                request.setAttribute("error", "Para enviar la encuesta completa, el DNI debe tener 8 dígitos.");
                recargarFormulario(request, response, asignacionId); // Método auxiliar para recargar datos
                return;
            }
        }
// Para "guardarBorrador", aceptar DNI vacío o incompleto (pero no nulo)
        else if (dniEncuestado == null) {
            dniEncuestado = ""; // Asignar cadena vacía si es null
        }


        List<RespuestaDetalle> detallesRespuesta = new ArrayList<>();
        Map<Integer, Boolean> preguntasRespondidas = new HashMap<>(); // Para validar si todas las preguntas obligatorias fueron respondidas
        String fechaContestacion = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        ArrayList<BancoPreguntas> preguntasEnDb = null;
        try {
            preguntasEnDb = contenidoEncuestaDAO.obtenerPreguntasDeEncuestaAsignada(asignacionId);//tipo encuesta(encuestaid)
            for (BancoPreguntas bp : preguntasEnDb) {
                preguntasRespondidas.put(bp.getPreguntaId(), false); // Inicializar como no respondidas
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al obtener preguntas de la base de datos para validación.");
            doGet(request, response); // Volver a cargar el formulario con el error
            return;
        }

        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            if (paramName.startsWith("respuesta_")) { // Para respuestas de texto y numéricas
                int preguntaId = Integer.parseInt(paramName.substring("respuesta_".length()));
                String respuestaTexto = request.getParameter(paramName);

                // Asegúrate de que la pregunta existe en el banco de preguntas de esta encuesta
                if (preguntasEnDb.stream().anyMatch(p -> p.getPreguntaId() == preguntaId)) {
                    if (respuestaTexto != null && !respuestaTexto.trim().isEmpty()) {
                        RespuestaDetalle detalle = new RespuestaDetalle();
                        BancoPreguntas pregunta = new BancoPreguntas();
                        pregunta.setPreguntaId(preguntaId);
                        detalle.setPregunta(pregunta);
                        detalle.setRespuestaTexto(respuestaTexto.trim());
                        detalle.setFechaContestacion(fechaContestacion);
                        detallesRespuesta.add(detalle);
                        preguntasRespondidas.put(preguntaId, true); // Marcar como respondida
                    }
                }
            } else if (paramName.startsWith("opcion_")) { // Para respuestas de opción única o múltiple
                int preguntaId = Integer.parseInt(paramName.substring("opcion_".length()));
                String[] selectedOptions = request.getParameterValues(paramName);

                if (preguntasEnDb.stream().anyMatch(p -> p.getPreguntaId() == preguntaId)) {
                    if (selectedOptions != null && selectedOptions.length > 0) {
                        for (String opcionIdStr : selectedOptions) {
                            RespuestaDetalle detalle = new RespuestaDetalle();
                            BancoPreguntas pregunta = new BancoPreguntas();
                            pregunta.setPreguntaId(preguntaId);
                            detalle.setPregunta(pregunta);

                            PreguntaOpcion opcion = new PreguntaOpcion();
                            opcion.setOpcionId(Integer.parseInt(opcionIdStr));
                            detalle.setOpcion(opcion);
                            detalle.setFechaContestacion(fechaContestacion);
                            detallesRespuesta.add(detalle);
                        }
                        preguntasRespondidas.put(preguntaId, true); // Marcar como respondida
                    }
                }
            }
        }

        boolean allQuestionsAnswered = true;
        for (BancoPreguntas pregunta : preguntasEnDb) {
            // Asumiendo que todas las preguntas son obligatorias para "guardarCompleta"
            if (!preguntasRespondidas.getOrDefault(pregunta.getPreguntaId(), false)) {
                allQuestionsAnswered = false;
                break;
            }
        }

        Respuesta respuesta = new Respuesta();
        EncuestaAsignada asignacion = new EncuestaAsignada();
        asignacion.setAsignacionId(asignacionId);
        respuesta.setAsignacion(asignacion);
        respuesta.setDniEncuestado(dniEncuestado);
        respuesta.setFechaInicio(fechaInicio); // Esto debería ser la fecha de inicio real de la encuesta o la primera vez que se guarda
        respuesta.setFechaEnvio(fechaContestacion); // Esta es la fecha de la última modificación/envío

        try {
            if ("guardarCompleta".equals(action)) {
                if (allQuestionsAnswered) {
                    contenidoEncuestaDAO.guardarEncuestaCompleta(respuesta, detallesRespuesta);
                    response.sendRedirect(request.getContextPath() + "/ContenidoEncuestaServlet?success=encuestaCompletada&asignacionId=" + asignacionId);
                } else {
                    request.setAttribute("error", "Para guardar la encuesta completa, debe responder todas las preguntas.");
                    // Recargar el formulario con los datos y errores
                    request.setAttribute("preguntasEncuesta", preguntasEnDb);
                    request.setAttribute("asignacionId", asignacionId);

                    Map<Integer, List<String>> respuestasUsuarioOpcionesRecargar = new HashMap<>();
                    Map<Integer, String> respuestasUsuarioTextoNumericoRecargar = new HashMap<>();
                    for (RespuestaDetalle rd : detallesRespuesta) {
                        if (rd.getOpcion() != null) {
                            respuestasUsuarioOpcionesRecargar.computeIfAbsent(rd.getPregunta().getPreguntaId(), k -> new ArrayList<>())
                                    .add(String.valueOf(rd.getOpcion().getOpcionId()));
                        } else if (rd.getRespuestaTexto() != null) {
                            respuestasUsuarioTextoNumericoRecargar.put(rd.getPregunta().getPreguntaId(), rd.getRespuestaTexto());
                        }
                    }
                    request.setAttribute("respuestasUsuarioOpciones", respuestasUsuarioOpcionesRecargar);
                    request.setAttribute("respuestasUsuarioTextoNumerico", respuestasUsuarioTextoNumericoRecargar);
                    request.setAttribute("dniEncuestadoBorrador", dniEncuestado);
                    request.setAttribute("fechaInicioBorrador", fechaInicio);

                    for (BancoPreguntas pregunta : preguntasEnDb) {
                        if (pregunta.getTipo().equals("opcion_unica") || pregunta.getTipo().equals("opcion_multiple")) {
                            ArrayList<PreguntaOpcion> opciones = contenidoEncuestaDAO.obtenerOpcionesDePregunta(pregunta.getPreguntaId());
                            request.setAttribute("opciones_" + pregunta.getPreguntaId(), opciones);
                        }
                    }
                    request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp").forward(request, response);
                }
            } else if ("guardarBorrador".equals(action)) {
                contenidoEncuestaDAO.guardarRespuesta(respuesta, detallesRespuesta);
                response.sendRedirect(request.getContextPath() + "/ContenidoEncuestaServlet?success=borradorGuardado&asignacionId=" + asignacionId);
            } else {
                request.setAttribute("error", "Acción no válida.");
                request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al guardar las respuestas: " + e.getMessage());
            // Recargar el formulario con los datos y errores en caso de excepción SQL
            request.setAttribute("preguntasEncuesta", preguntasEnDb);
            request.setAttribute("asignacionId", asignacionId);

            Map<Integer, List<String>> respuestasUsuarioOpcionesRecargar = new HashMap<>();
            Map<Integer, String> respuestasUsuarioTextoNumericoRecargar = new HashMap<>();
            for (RespuestaDetalle rd : detallesRespuesta) {
                if (rd.getOpcion() != null) {
                    respuestasUsuarioOpcionesRecargar.computeIfAbsent(rd.getPregunta().getPreguntaId(), k -> new ArrayList<>())
                            .add(String.valueOf(rd.getOpcion().getOpcionId()));
                } else if (rd.getRespuestaTexto() != null) {
                    respuestasUsuarioTextoNumericoRecargar.put(rd.getPregunta().getPreguntaId(), rd.getRespuestaTexto());
                }
            }
            request.setAttribute("respuestasUsuarioOpciones", respuestasUsuarioOpcionesRecargar);
            request.setAttribute("respuestasUsuarioTextoNumerico", respuestasUsuarioTextoNumericoRecargar);
            request.setAttribute("dniEncuestadoBorrador", dniEncuestado);
            request.setAttribute("fechaInicioBorrador", fechaInicio);

            try {
                for (BancoPreguntas pregunta : preguntasEnDb) {
                    if (pregunta.getTipo().equals("opcion_unica") || pregunta.getTipo().equals("opcion_multiple")) {
                        ArrayList<PreguntaOpcion> opciones = contenidoEncuestaDAO.obtenerOpcionesDePregunta(pregunta.getPreguntaId());
                        request.setAttribute("opciones_" + pregunta.getPreguntaId(), opciones);
                    }
                }
            } catch (SQLException ex) {
                System.err.println("Error al recargar opciones para rellenar formulario en caso de error: " + ex.getMessage());
            }

            request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp").forward(request, response);
        }
    }
    private void recargarFormulario(HttpServletRequest request, HttpServletResponse response, int asignacionId)
            throws ServletException, IOException {
        ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();
        try {
            ArrayList<BancoPreguntas> preguntas = contenidoEncuestaDAO.obtenerPreguntasDeEncuestaAsignada(asignacionId);
            request.setAttribute("preguntasEncuesta", preguntas);
            request.setAttribute("asignacionId", asignacionId);

            for (BancoPreguntas pregunta : preguntas) {
                if (pregunta.getTipo().equals("opcion_unica") || pregunta.getTipo().equals("opcion_multiple")) {
                    ArrayList<PreguntaOpcion> opciones = contenidoEncuestaDAO.obtenerOpcionesDePregunta(pregunta.getPreguntaId());
                    request.setAttribute("opciones_" + pregunta.getPreguntaId(), opciones);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp").forward(request, response);
    }

}