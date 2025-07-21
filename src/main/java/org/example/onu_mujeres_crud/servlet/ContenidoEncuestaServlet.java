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

        // 1. Obtener parámetros básicos
        int asignacionId = obtenerAsignacionId(request);
        String dniEncuestado = request.getParameter("dniEncuestado");
        String fechaInicio = request.getParameter("fechaInicio");

        // 2. Procesar respuestas del formulario (esto debe hacerse ANTES de las validaciones)
        List<RespuestaDetalle> detallesRespuesta = new ArrayList<>();
        Map<Integer, Boolean> preguntasRespondidas = new HashMap<>();
        String fechaContestacion = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        try {
            ArrayList<BancoPreguntas> preguntasEnDb = contenidoEncuestaDAO.obtenerPreguntasDeEncuestaAsignada(asignacionId);

            // Inicializar mapa de preguntas respondidas
            for (BancoPreguntas bp : preguntasEnDb) {
                preguntasRespondidas.put(bp.getPreguntaId(), false);
            }

            // Procesar parámetros del request para construir detallesRespuesta
            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();

                if (paramName.startsWith("respuesta_")) {
                    int preguntaId = Integer.parseInt(paramName.substring("respuesta_".length()));
                    String respuestaTexto = request.getParameter(paramName);

                    if (respuestaTexto != null && !respuestaTexto.trim().isEmpty()) {
                        RespuestaDetalle detalle = new RespuestaDetalle();
                        BancoPreguntas pregunta = new BancoPreguntas();
                        pregunta.setPreguntaId(preguntaId);
                        detalle.setPregunta(pregunta);
                        detalle.setRespuestaTexto(respuestaTexto.trim());
                        detalle.setFechaContestacion(fechaContestacion);
                        detallesRespuesta.add(detalle);
                        preguntasRespondidas.put(preguntaId, true);
                    }
                } else if (paramName.startsWith("opcion_")) {
                    int preguntaId = Integer.parseInt(paramName.substring("opcion_".length()));
                    String[] selectedOptions = request.getParameterValues(paramName);

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
                        preguntasRespondidas.put(preguntaId, true);
                    }
                }
            }

            // 3. Validaciones (ahora tenemos acceso a detallesRespuesta)
            if ("guardarCompleta".equals(action)) {
                // Validación de formato DNI
                if (dniEncuestado == null || dniEncuestado.trim().isEmpty() || !dniEncuestado.matches("\\d{8}")) {
                    request.setAttribute("error", "Para enviar la encuesta completa, el DNI debe tener 8 dígitos.");
                    recargarFormularioConDatos(request, response, asignacionId, dniEncuestado, fechaInicio, detallesRespuesta);
                    return;
                }

                // Validación de DNI único
                boolean dniExisteEnCompletadas = contenidoEncuestaDAO.verificarDniEnAsignacionesCompletadas(dniEncuestado);
                if (dniExisteEnCompletadas) {
                    request.setAttribute("error", "El DNI " + dniEncuestado + " ya existe en una encuesta completada.");
                    recargarFormularioConDatos(request, response, asignacionId, dniEncuestado, fechaInicio, detallesRespuesta);
                    return;
                }

                // Validación de preguntas completas
                boolean allQuestionsAnswered = preguntasEnDb.stream()
                        .allMatch(p -> preguntasRespondidas.getOrDefault(p.getPreguntaId(), false));


            }


            // 4. Si pasó todas las validaciones, guardar
            Respuesta respuesta = new Respuesta();
            EncuestaAsignada asignacion = new EncuestaAsignada();
            asignacion.setAsignacionId(asignacionId);
            respuesta.setAsignacion(asignacion);
            respuesta.setDniEncuestado(dniEncuestado);
            respuesta.setFechaInicio(fechaInicio);
            respuesta.setFechaEnvio(fechaContestacion);

            if ("guardarCompleta".equals(action)) {
                contenidoEncuestaDAO.guardarEncuestaCompleta(respuesta, detallesRespuesta);
                response.sendRedirect(request.getContextPath() + "/EncuestadorServlet?success=encuestaCompletada&asignacionId=" + asignacionId);
            } else if ("guardarBorrador".equals(action)) {
                contenidoEncuestaDAO.guardarRespuesta(respuesta, detallesRespuesta);
                response.sendRedirect(request.getContextPath() + "/ContenidoEncuestaServlet?success=borradorGuardado&asignacionId=" + asignacionId);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la encuesta: " + e.getMessage());
            recargarFormularioConDatos(request, response, asignacionId, dniEncuestado, fechaInicio, detallesRespuesta);
        }
    }

    private int obtenerAsignacionId(HttpServletRequest request) {
        String asignacionIdParam = request.getParameter("asignacionId");
        if (asignacionIdParam != null && !asignacionIdParam.isEmpty()) {
            try {
                return Integer.parseInt(asignacionIdParam);
            } catch (NumberFormatException e) {
                throw new RuntimeException("ID de asignación inválido", e);
            }
        }
        throw new RuntimeException("ID de asignación no presente");
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

    private void recargarFormularioConDatos(HttpServletRequest request, HttpServletResponse response,
                                            int asignacionId, String dniEncuestado, String fechaInicio,
                                            List<RespuestaDetalle> detallesRespuesta)
            throws ServletException, IOException {
        ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();

        try {
            // 1. Obtener preguntas de la encuesta
            ArrayList<BancoPreguntas> preguntas = contenidoEncuestaDAO.obtenerPreguntasDeEncuestaAsignada(asignacionId);

            // 2. Preparar mapas para respuestas ya ingresadas
            Map<Integer, List<String>> respuestasUsuarioOpciones = new HashMap<>();
            Map<Integer, String> respuestasUsuarioTextoNumerico = new HashMap<>();

            for (RespuestaDetalle rd : detallesRespuesta) {
                if (rd.getOpcion() != null) {
                    respuestasUsuarioOpciones.computeIfAbsent(rd.getPregunta().getPreguntaId(), k -> new ArrayList<>())
                            .add(String.valueOf(rd.getOpcion().getOpcionId()));
                } else if (rd.getRespuestaTexto() != null) {
                    respuestasUsuarioTextoNumerico.put(rd.getPregunta().getPreguntaId(), rd.getRespuestaTexto());
                }
            }

            // 3. Obtener opciones para preguntas de selección
            for (BancoPreguntas pregunta : preguntas) {
                if (pregunta.getTipo().equals("opcion_unica") || pregunta.getTipo().equals("opcion_multiple")) {
                    ArrayList<PreguntaOpcion> opciones = contenidoEncuestaDAO.obtenerOpcionesDePregunta(pregunta.getPreguntaId());
                    request.setAttribute("opciones_" + pregunta.getPreguntaId(), opciones);
                }
            }

            // 4. Establecer atributos para la vista
            request.setAttribute("preguntasEncuesta", preguntas);
            request.setAttribute("asignacionId", asignacionId);
            request.setAttribute("respuestasUsuarioOpciones", respuestasUsuarioOpciones);
            request.setAttribute("respuestasUsuarioTextoNumerico", respuestasUsuarioTextoNumerico);
            request.setAttribute("dniEncuestadoBorrador", dniEncuestado);
            request.setAttribute("fechaInicioBorrador", fechaInicio);

            // 5. Redirigir manteniendo los datos
            request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al recargar el formulario: " + e.getMessage());
            request.getRequestDispatcher("/encuestador/mostrarEncuesta.jsp").forward(request, response);
        }
    }

}