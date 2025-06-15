// src/main/java/org/example/onu_mujeres_crud/servlet/ImportarRespuestasServlet.java
package org.example.onu_mujeres_crud.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession; // Importar HttpSession
import org.apache.poi.ss.usermodel.*;
import org.example.onu_mujeres_crud.beans.*;
import org.example.onu_mujeres_crud.daos.EncuestaAsignadaDAO;
import org.example.onu_mujeres_crud.daos.RespuestaDAO;
import org.example.onu_mujeres_crud.daos.ContenidoEncuestaDAO;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "ImportarRespuestasServlet", value = "/ImportarRespuestasServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ImportarRespuestasServlet extends HttpServlet {

    private EncuestaAsignadaDAO encuestaAsignadaDAO = new EncuestaAsignadaDAO();
    private RespuestaDAO respuestaDAO = new RespuestaDAO();
    private ContenidoEncuestaDAO contenidoEncuestaDAO = new ContenidoEncuestaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("uploadExcel".equals(action)) {
            HttpSession session = request.getSession();
            Usuario currentUser = (Usuario) session.getAttribute("usuario"); // Asumiendo que el objeto Usuario se guarda en la sesión

            if (currentUser == null) {
                // Si no hay usuario logueado, redirigir a login o mostrar error
                request.getSession().setAttribute("error", "No se encontró usuario logueado para asignar la importación.");
                response.sendRedirect(request.getContextPath() + "/login?action=login"); // Ajusta la URL de login si es diferente
                return;
            }

            int coordinadorId = currentUser.getUsuarioId(); // Obtener el ID del usuario logueado (que es el coordinador)

            try {
                int encuestaId = Integer.parseInt(request.getParameter("encuestaId"));
                Part filePart = request.getPart("excelFile");

                if (filePart != null && filePart.getSize() > 0) {
                    InputStream fileContent = filePart.getInputStream();

                    ArrayList<BancoPreguntas> preguntasEncuesta = contenidoEncuestaDAO.obtenerPreguntasDeEncuestaAsignada(encuestaId);

                    Map<Integer, ArrayList<PreguntaOpcion>> opcionesPorPreguntaId = new HashMap<>();
                    for (BancoPreguntas bp : preguntasEncuesta) {
                        if (bp.getTipo().equals("opcion_unica") || bp.getTipo().equals("opcion_multiple")) {
                            opcionesPorPreguntaId.put(bp.getPreguntaId(), contenidoEncuestaDAO.obtenerOpcionesDePregunta(bp.getPreguntaId()));
                        }
                    }

                    // 1. Crear la EncuestaAsignada para esta carga de respuestas, pasando el coordinadorId de la sesión
                    int asignacionId = encuestaAsignadaDAO.crearAsignacionParaImportacion(encuestaId, coordinadorId);

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
                                response.sendRedirect(request.getContextPath() + "/admin/subirExcelRespuestas.jsp");
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
            response.sendRedirect(request.getContextPath() + "/admin/subirExcelRespuestas.jsp");
        }
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