package org.example.onu_mujeres_crud.daos;

import org.example.onu_mujeres_crud.beans.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContenidoEncuestaDAO extends BaseDAO { // Asumiendo que BaseDAO provee getConnection()

    /**
     * Obtiene una lista de preguntas de un banco de preguntas para una encuesta asignada específica.
     * La consulta SQL busca el `encuesta_id` a partir del `asignacion_id` y luego recupera las preguntas asociadas.
     *
     * @param asignacionId El ID de la asignación de la encuesta.
     * @return Una ArrayList de objetos BancoPreguntas.
     * @throws SQLException Si ocurre un error en la base de datos.
     */
    public ArrayList<BancoPreguntas> obtenerPreguntasDeEncuestaAsignada(int asignacionId) throws SQLException {
        ArrayList<BancoPreguntas> preguntasEncuesta = new ArrayList<>();
        // Modificado: La consulta ahora usa asignacion_id para encontrar el encuesta_id
        // El alias de la columna 'texto' de banco_preguntas ahora es 'pregunta_texto' para evitar conflictos
        String sql = "SELECT \n" +
                "    ROW_NUMBER() OVER (ORDER BY pe.pregunta_id) AS orden,\n" +
                "    bp.pregunta_id, \n" +
                "    bp.texto AS pregunta_texto, \n" + // Usamos alias para evitar conflicto con palabra reservada o claridad
                "    bp.tipo\n" +
                "FROM onu_mujeres.preguntas_encuesta pe\n" +
                "INNER JOIN onu_mujeres.banco_preguntas bp \n" +
                "    ON pe.pregunta_id = bp.pregunta_id\n" +
                "WHERE pe.encuesta_id = (\n" +
                "        SELECT encuesta_id FROM onu_mujeres.encuestas_asignadas WHERE asignacion_id = ?\n" +
                "    )\n" +
                "ORDER BY orden";

        try (Connection conn = this.getConnection(); // Asumiendo que getConnection() está en BaseDAO
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, asignacionId); // Usamos el asignacionId directamente

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    BancoPreguntas pregunta = new BancoPreguntas();
                    pregunta.setPreguntaId(rs.getInt("pregunta_id"));
                    pregunta.setTexto(rs.getString("pregunta_texto")); // Usar el alias 'pregunta_texto'
                    pregunta.setTipo(rs.getString("tipo"));
                    preguntasEncuesta.add(pregunta);
                }
            }
        }
        return preguntasEncuesta;
    }

    /**
     * Obtiene las opciones para una pregunta específica.
     * Este método es independiente y se llamará solo si la pregunta es de tipo 'opcion_unica' o 'opcion_multiple'.
     *
     * @param preguntaId El ID de la pregunta para la cual se desean obtener las opciones.
     * @return Una ArrayList de objetos PreguntaOpcion.
     * @throws SQLException Si ocurre un error en la base de datos.
     */
    public ArrayList<PreguntaOpcion> obtenerOpcionesDePregunta(int preguntaId) throws SQLException {
        ArrayList<PreguntaOpcion> opciones = new ArrayList<>();
        String sql = "SELECT " +
                "opcion_id, texto_opcion, valor " +
                "FROM onu_mujeres.pregunta_opciones " +
                "WHERE pregunta_id = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, preguntaId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    PreguntaOpcion opcion = new PreguntaOpcion();
                    opcion.setOpcionId(rs.getInt("opcion_id"));
                    opcion.setTextoOpcion(rs.getString("texto_opcion"));
                    opcion.setValor(rs.getInt("valor"));
                    opciones.add(opcion);
                }
            }
        }
        return opciones;
    }

    /**
     * Guarda una encuesta completa y actualiza el estado de la asignación.
     * Esta operación es transaccional.
     *
     * @param respuesta El objeto Respuesta principal (con dniEncuestado, asignacion_id, fechas).
     * @param detalles Una lista de RespuestaDetalle.
     * @throws SQLException Si ocurre un error en la base de datos.
     */
    public void guardarEncuestaCompleta(Respuesta respuesta, List<RespuestaDetalle> detalles) throws SQLException {
        Connection conn = null;
        try {
            conn = this.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            // 1. Insertar o actualizar en la tabla 'respuestas'
            Integer respuestaIdExistente = null;
            String checkRespuestaSql = "SELECT respuesta_id FROM onu_mujeres.respuestas WHERE asignacion_id = ? ";
            try (PreparedStatement psCheck = conn.prepareStatement(checkRespuestaSql)) {
                psCheck.setInt(1, respuesta.getAsignacion().getAsignacionId());

                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        respuestaIdExistente = rsCheck.getInt("respuesta_id");
                        respuesta.setRespuestaId(respuestaIdExistente);
                        //Actualizar fecha_ultima_edicion (fecha de última modificación/guardado borrador)
                        String updateRespuestaSql = "UPDATE onu_mujeres.respuestas SET fecha_ultima_edicion = ?, dni_encuestado=? WHERE respuesta_id = ?";
                        try (PreparedStatement psUpdateRespuesta = conn.prepareStatement(updateRespuestaSql)) {
                            psUpdateRespuesta.setString(1, respuesta.getFechaEnvio());
                            psUpdateRespuesta.setString(2, respuesta.getDniEncuestado());
                            psUpdateRespuesta.setInt(3, respuestaIdExistente);
                            psUpdateRespuesta.executeUpdate();
                        }
                    }

                }
            }

            if (respuestaIdExistente == null) {
                System.out.println("se ingrso 2 veces");
                // Si no existe, insertar nueva respuesta
                String insertRespuestaSql = "INSERT INTO onu_mujeres.respuestas (dni_encuestado, asignacion_id, fecha_inicio, fecha_ultima_edicion) VALUES (?,?,?,?)";
                try (PreparedStatement pstmtRespuesta = conn.prepareStatement(insertRespuestaSql, Statement.RETURN_GENERATED_KEYS)) {
                    pstmtRespuesta.setString(1, respuesta.getDniEncuestado());
                    pstmtRespuesta.setInt(2, respuesta.getAsignacion().getAsignacionId());
                    pstmtRespuesta.setString(3, respuesta.getFechaInicio());
                    pstmtRespuesta.setString(4, respuesta.getFechaEnvio());
                    pstmtRespuesta.executeUpdate();

                    try (ResultSet rs = pstmtRespuesta.getGeneratedKeys()) {
                        if (rs.next()) {
                            respuesta.setRespuestaId(rs.getInt(1));
                        }
                    }
                }
            } else {
                respuesta.setRespuestaId(respuestaIdExistente);
            }

            // 2. Eliminar detalles antiguos y insertar nuevos en la tabla 'respuesta_detalle'
            if (respuesta.getRespuestaId() > 0) { // Asegurarse de que tenemos un respuestaId válido
                String deleteDetallesSql = "DELETE FROM onu_mujeres.respuestas_detalle WHERE respuesta_id = ?"; // Corregido el nombre de la tabla
                try (PreparedStatement psDeleteDetalles = conn.prepareStatement(deleteDetallesSql)) {
                    psDeleteDetalles.setInt(1, respuesta.getRespuestaId());
                    psDeleteDetalles.executeUpdate();
                }
            }

            String sqlDetalle = "INSERT INTO onu_mujeres.respuestas_detalle (respuesta_id, pregunta_id, opcion_id, respuesta_texto, fecha_contestacion) VALUES (?,?,?,?,?)"; // Corregido el nombre de la tabla
            try (PreparedStatement pstmtDetalle = conn.prepareStatement(sqlDetalle)) {
                for (RespuestaDetalle detalle : detalles) {
                    pstmtDetalle.setInt(1, respuesta.getRespuestaId());
                    pstmtDetalle.setInt(2, detalle.getPregunta().getPreguntaId());
                    if (detalle.getOpcion() != null) {
                        pstmtDetalle.setInt(3, detalle.getOpcion().getOpcionId());
                    } else {
                        pstmtDetalle.setNull(3, Types.INTEGER); // Para preguntas sin opción (abierta, numérica)
                    }
                    pstmtDetalle.setString(4, detalle.getRespuestaTexto());
                    pstmtDetalle.setString(5, detalle.getFechaContestacion());
                    pstmtDetalle.addBatch(); // Agrega la operación al batch
                }
                pstmtDetalle.executeBatch(); // Ejecuta todas las operaciones en batch
            }

            // 3. Actualizar el estado de la encuesta asignada
            String sqlUpdateAsignacion = "UPDATE onu_mujeres.encuestas_asignadas SET estado = ?, fecha_completado = ? WHERE asignacion_id = ?";
            try (PreparedStatement pstmtUpdate = conn.prepareStatement(sqlUpdateAsignacion)) {
                pstmtUpdate.setString(1, "completada");
                pstmtUpdate.setString(2, respuesta.getFechaEnvio());
                pstmtUpdate.setInt(3, respuesta.getAsignacion().getAsignacionId());
                pstmtUpdate.executeUpdate();
            }

            conn.commit(); // Confirmar transacción

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Revertir transacción en caso de error
                } catch (SQLException ex) {
                    System.err.println("Error al hacer rollback en guardarEncuestaCompleta: " + ex.getMessage());
                }
            }
            throw e; // Re-lanzar la excepción
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restaurar auto-commit
                    conn.close();
                } catch (SQLException ex) {
                    System.err.println("Error al cerrar conexión en guardarEncuestaCompleta: " + ex.getMessage());
                }
            }
        }
    }

    /**
     * Guarda respuestas como borrador o respuestas individuales.
     * Esta operación es transaccional.
     *
     * @param respuesta El objeto Respuesta principal.
     * @param detalles Una lista de RespuestaDetalle.
     * @throws SQLException Si ocurre un error en la base de datos.
     */
    public void guardarRespuesta(Respuesta respuesta, List<RespuestaDetalle> detalles) throws SQLException {
        Connection conn = null;
        try {
            conn = this.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            Integer respuestaIdExistente = null;
            String checkRespuestaSql = "SELECT respuesta_id FROM onu_mujeres.respuestas WHERE asignacion_id = ? ";
            try (PreparedStatement psCheck = conn.prepareStatement(checkRespuestaSql)) {
                psCheck.setInt(1, respuesta.getAsignacion().getAsignacionId());

                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        respuestaIdExistente = rsCheck.getInt("respuesta_id");
                        respuesta.setRespuestaId(respuestaIdExistente);
                        //Actualizar fecha_ultima_edicion (fecha de última modificación/guardado borrador)
                        String updateRespuestaSql = "UPDATE onu_mujeres.respuestas SET fecha_ultima_edicion = ?, dni_encuestado=? WHERE respuesta_id = ?";
                        try (PreparedStatement psUpdateRespuesta = conn.prepareStatement(updateRespuestaSql)) {
                            psUpdateRespuesta.setString(1, respuesta.getFechaEnvio());
                            psUpdateRespuesta.setString(2, respuesta.getDniEncuestado());
                            psUpdateRespuesta.setInt(3, respuestaIdExistente);
                            psUpdateRespuesta.executeUpdate();
                        }
                    }
                    else {
                        String insertRespuestaSql = "INSERT INTO onu_mujeres.respuestas (dni_encuestado, asignacion_id, fecha_inicio, fecha_ultima_edicion) VALUES (?,?,?,?)";
                        try (PreparedStatement pstmtRespuesta = conn.prepareStatement(insertRespuestaSql, Statement.RETURN_GENERATED_KEYS)) {
                            pstmtRespuesta.setString(1, respuesta.getDniEncuestado());
                            pstmtRespuesta.setInt(2, respuesta.getAsignacion().getAsignacionId());
                            pstmtRespuesta.setString(3, respuesta.getFechaInicio());
                            pstmtRespuesta.setString(4, respuesta.getFechaEnvio());
                            pstmtRespuesta.executeUpdate();

                            try (ResultSet rs = pstmtRespuesta.getGeneratedKeys()) {
                                if (rs.next()) {
                                    respuesta.setRespuestaId(rs.getInt(1));
                                }
                            }
                        }
                    }
                }
            }













            // 2. Eliminar detalles antiguos y insertar nuevos en la tabla 'respuesta_detalle'
            if (respuesta.getRespuestaId() > 0) {
                String deleteDetallesSql = "DELETE FROM onu_mujeres.respuestas_detalle WHERE respuesta_id = ?"; // Corregido el nombre de la tabla
                try (PreparedStatement psDeleteDetalles = conn.prepareStatement(deleteDetallesSql)) {
                    psDeleteDetalles.setInt(1, respuesta.getRespuestaId());
                    psDeleteDetalles.executeUpdate();
                }
            }

            String sqlDetalle = "INSERT INTO onu_mujeres.respuestas_detalle (respuesta_id, pregunta_id, opcion_id, respuesta_texto, fecha_contestacion) VALUES (?,?,?,?,?)"; // Corregido el nombre de la tabla
            try (PreparedStatement pstmtDetalle = conn.prepareStatement(sqlDetalle)) {
                for (RespuestaDetalle detalle : detalles) {
                    pstmtDetalle.setInt(1, respuesta.getRespuestaId());
                    pstmtDetalle.setInt(2, detalle.getPregunta().getPreguntaId());
                    if (detalle.getOpcion() != null) {
                        pstmtDetalle.setInt(3, detalle.getOpcion().getOpcionId());
                    } else {
                        pstmtDetalle.setNull(3, Types.INTEGER);
                    }
                    pstmtDetalle.setString(4, detalle.getRespuestaTexto());
                    pstmtDetalle.setString(5, detalle.getFechaContestacion());
                    pstmtDetalle.addBatch();
                }
                pstmtDetalle.executeBatch();
            }

            // 3. Actualizar el estado de la encuesta asignada a 'en_progreso' si no está ya 'completada'
            String checkEstadoSql = "SELECT estado FROM onu_mujeres.encuestas_asignadas WHERE asignacion_id = ?";
            String currentState = "";
            try (PreparedStatement psCheckState = conn.prepareStatement(checkEstadoSql)) {
                psCheckState.setInt(1, respuesta.getAsignacion().getAsignacionId());
                try (ResultSet rsState = psCheckState.executeQuery()) {
                    if (rsState.next()) {
                        currentState = rsState.getString("estado");
                    }
                }
            }

            if (!"completada".equalsIgnoreCase(currentState)) { // Solo cambia a 'en_progreso' si no está ya completa
                String sqlUpdateAsignacion = "UPDATE onu_mujeres.encuestas_asignadas SET estado = ? WHERE asignacion_id = ?";
                try (PreparedStatement pstmtUpdate = conn.prepareStatement(sqlUpdateAsignacion)) {
                    pstmtUpdate.setString(1, "en_progreso"); // Estado para borrador
                    pstmtUpdate.setInt(2, respuesta.getAsignacion().getAsignacionId());
                    pstmtUpdate.executeUpdate();
                }
            }

            conn.commit(); // Confirmar transacción

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Revertir transacción en caso de error
                } catch (SQLException ex) {
                    System.err.println("Error al hacer rollback en guardarRespuesta: " + ex.getMessage());
                }
            }
            throw e; // Re-lanzar la excepción
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restaurar auto-commit
                    conn.close();
                } catch (SQLException ex) {
                    System.err.println("Error al cerrar conexión en guardarRespuesta: " + ex.getMessage());
                }
            }
        }
    }
    public String obtenerEstadoEncuestaAsignada(int asignacionId) throws SQLException {
        String sql = "SELECT estado FROM onu_mujeres.encuestas_asignadas WHERE asignacion_id = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, asignacionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println(" si entro a obtener estado");
                    return rs.getString("estado");
                }
            }
        }
        return null; // O lanza una excepción si prefieres
    }


    /**
     * Obtiene las respuestas guardadas previamente para una asignación específica,
     * útil para prellenar el formulario de una encuesta en progreso.
     *
     * @param asignacionId El ID de la asignación.
     * @return Una lista de RespuestaDetalle con las respuestas existentes.
     * @throws SQLException Si ocurre un error en la base de datos.
     */
    public ArrayList<RespuestaDetalle> obtenerRespuestasDeAsignacion(int asignacionId) throws SQLException {
        ArrayList<RespuestaDetalle> respuestas = new ArrayList<>();
        String sql = "SELECT " +
                "    rd.detalle_id, " +
                "    r.respuesta_id, " +
                "    bp.pregunta_id, " +
                "    bp.texto AS pregunta_texto, " +
                "    bp.tipo AS pregunta_tipo, " +
                "    po.opcion_id, " +
                "    po.texto_opcion AS opcion_texto, " + // Asegúrate de que el alias sea 'opcion_texto'
                "    rd.respuesta_texto, " +
                "    rd.fecha_contestacion, " +
                "    r.dni_encuestado, " + // Añadido para obtener el DNI
                "    r.fecha_inicio " +   // Añadido para obtener la fecha de inicio
                "FROM onu_mujeres.respuestas_detalle rd " + // Corregido el nombre de la tabla
                "INNER JOIN onu_mujeres.respuestas r ON rd.respuesta_id = r.respuesta_id " +
                "INNER JOIN onu_mujeres.banco_preguntas bp ON rd.pregunta_id = bp.pregunta_id " +
                "LEFT JOIN onu_mujeres.pregunta_opciones po ON rd.opcion_id = po.opcion_id " +
                "WHERE r.asignacion_id = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, asignacionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    respuestas.add(mapearRespuestaDetalle(rs));
                }
            }
        }
        return respuestas;
    }

    /**
     * Mapea un ResultSet a un objeto RespuestaDetalle.
     * @param rs ResultSet de la consulta.
     * @return Objeto RespuestaDetalle mapeado.
     * @throws SQLException Si ocurre un error al acceder a los datos del ResultSet.
     */
    private RespuestaDetalle mapearRespuestaDetalle(ResultSet rs) throws SQLException {
        // Mapear respuesta principal (simplificada)
        Respuesta respuesta = new Respuesta();
        respuesta.setRespuestaId(rs.getInt("respuesta_id"));
        respuesta.setDniEncuestado(rs.getString("dni_encuestado"));
        respuesta.setFechaInicio(rs.getString("fecha_inicio"));
        EncuestaAsignada asignacion = new EncuestaAsignada();
        respuesta.setAsignacion(asignacion);

        // Mapear pregunta
        BancoPreguntas pregunta = new BancoPreguntas();
        pregunta.setPreguntaId(rs.getInt("pregunta_id"));
        pregunta.setTexto(rs.getString("pregunta_texto"));
        pregunta.setTipo(rs.getString("pregunta_tipo"));

        // Mapear opción (si existe)
        PreguntaOpcion opcion = null;
        if (rs.getObject("opcion_id") != null) {
            opcion = new PreguntaOpcion();
            opcion.setOpcionId(rs.getInt("opcion_id"));
            opcion.setTextoOpcion(rs.getString("opcion_texto"));
        }

        // Construir objeto RespuestaDetalle
        RespuestaDetalle detalle = new RespuestaDetalle();
        detalle.setDetalleId(rs.getInt("detalle_id"));
        detalle.setRespuesta(respuesta);
        detalle.setPregunta(pregunta);
        detalle.setOpcion(opcion);
        detalle.setRespuestaTexto(rs.getString("respuesta_texto"));
        detalle.setFechaContestacion(rs.getString("fecha_contestacion"));
        return detalle;
    }
    public EncuestaAsignada obtenerEncuestaAsignadaPorEncuestador(int encuestadorId) throws SQLException {
        EncuestaAsignada asignacion = null;
        String sql = "SELECT \n" +
                "    ea.asignacion_id,\n" +
                "    ea.encuesta_id,\n" +
                "    e.nombre AS encuesta_nombre,\n" +
                "    ea.estado AS asignacion_estado,\n" +
                "    ea.fecha_asignacion,\n" +
                "    ea.fecha_completado\n" +
                "FROM \n" +
                "    encuestas_asignadas ea\n" +
                "JOIN\n" +
                "    encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
                "WHERE \n" +
                "    ea.encuestador_id = ? AND ea.estado IN ('asignada', 'en_progreso')\n" +
                "ORDER BY \n" +
                "    ea.fecha_asignacion DESC, ea.asignacion_id DESC \n" +
                "LIMIT 1;";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    asignacion = new EncuestaAsignada();
                    asignacion.setAsignacionId(rs.getInt("asignacion_id"));

                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("encuesta_nombre"));
                    asignacion.setEncuesta(encuesta);

                    asignacion.setEstado(rs.getString("asignacion_estado"));
                    asignacion.setFechaAsignacion(rs.getString("fecha_asignacion"));
                    asignacion.setFechaCompletado(rs.getString("fecha_completado"));
                }
            }
        }
        return asignacion;
    }
    public boolean verificarDniEnAsignacionesCompletadas(String dniEncuestado) throws SQLException {
        String sql = "SELECT COUNT(*) FROM onu_mujeres.respuestas r " +
                "JOIN encuestas_asignadas ea ON r.asignacion_id = ea.asignacion_id " +
                "WHERE r.dni_encuestado = ? AND ea.estado = 'completada' " ;


        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, dniEncuestado);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}

//package org.example.onu_mujeres_crud.daos;
//
//import org.example.onu_mujeres_crud.beans.*;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class ContenidoEncuestaDAO extends BaseDAO {
//
//    //Metodo que devuelve una lista de preguntas (Devuelve una encuesta asignada por completar a un encuestador)
//    public ArrayList<BancoPreguntas> obtenerPreguntasDeEncuestaAsignada(EncuestaAsignada encuestaAsignada) {
//        ArrayList<BancoPreguntas> preguntasEncuesta = new ArrayList<>();
//        String sql = "SELECT \n" +
//                "    ROW_NUMBER() OVER (PARTITION BY pe.encuesta_id ORDER BY pe.pregunta_id) AS orden,\n" +
//                "    bp.pregunta_id, \n" +
//                "    bp.texto AS pregunta, \n" +
//                "    bp.tipo\n" +
//                "FROM onu_mujeres.preguntas_encuesta pe\n" +
//                "INNER JOIN onu_mujeres.banco_preguntas bp \n" +
//                "    ON pe.pregunta_id = bp.pregunta_id\n" +
//                "WHERE pe.encuesta_id = ?\n" +
//                "    AND EXISTS (\n" +
//                "        SELECT 1\n" +
//                "        FROM onu_mujeres.encuestas_asignadas ea\n" +
//                "        WHERE ea.encuesta_id = pe.encuesta_id\n" +
//                "            AND ea.encuestador_id = ?\n" +
//                "            AND ea.estado = 'asignada'\n" +
//                "    )\n" +
//                "ORDER BY pe.pregunta_id;";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//            pstmt.setInt(1, encuestaAsignada.getEncuestador().getUsuarioId());
//            pstmt.setInt(2, encuestaAsignada.getEncuesta().getEncuestaId());
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    BancoPreguntas preguntaEncuesta = new BancoPreguntas();
//                    preguntaEncuesta.setPreguntaId(rs.getInt("pregunta_id"));
//                    preguntaEncuesta.setTexto(rs.getString("pregunta"));
//                    preguntaEncuesta.setTipo(rs.getString("tipo"));
//                    preguntasEncuesta.add(preguntaEncuesta);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return preguntasEncuesta;
//    }
//
//    /**
//     * Guarda la respuesta general de una encuesta
//     * @param respuesta Objeto Respuesta con los datos principales
//     * @return ID de la respuesta generada
//     * @throws SQLException Si ocurre un error en la base de datos
//     */
//    public int guardarRespuesta(Respuesta respuesta) throws SQLException{
//        String sql = "INSERT INTO onu_mujeres.respuestas" +
//                "(asignacion_id, dni_encuestado,fecha_inicio, fecha_ultima_edicion) " +
//                "VALUES (?, ?, ?, ?)";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            pstmt.setInt(1, respuesta.getAsignacion().getAsignacionId());
//            pstmt.setString(2,respuesta.getDniEncuestado());
//            pstmt.setString(3,respuesta.getFechaInicio());
//            pstmt.setString(4, respuesta.getFechaEnvio());
//            pstmt.executeUpdate();
//
//            try (ResultSet rs = pstmt.getGeneratedKeys()) {
//                if (rs.next()) {
//                    return rs.getInt(1);
//                }
//                throw new SQLException("No se pudo obtener el ID de la respuesta");
//            }
//        }
//    }
//
//    /**
//     * Guarda todos los detalles de las respuestas
//     * @param respuestaId ID de la respuesta general
//     * @param detalles Lista de objetos RespuestaDetalle
//     * @throws SQLException Si ocurre un error en la base de datos
//     */
//    public void guardarDetallesRespuesta(int respuestaId, List<RespuestaDetalle> detalles) throws SQLException {
//        String sql = "INSERT INTO respuestas_detalle " +
//                "(respuesta_id, pregunta_id, opcion_id, respuesta_texto, fecha_contestacion) " +
//                "VALUES (?, ?, ?, ?, ?)";
//
//        try ( Connection conn = getConnection();
//              PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            for (RespuestaDetalle detalle : detalles) {
//                pstmt.setInt(1, respuestaId);
//                pstmt.setInt(2, detalle.getPregunta().getPreguntaId());
//
//                if (detalle.getOpcion() != null) {
//                    pstmt.setInt(3, detalle.getOpcion().getOpcionId());
//                } else {
//                    pstmt.setNull(3, Types.INTEGER);
//                }
//
//                if (detalle.getRespuestaTexto() != null) {
//                    pstmt.setString(4, detalle.getRespuestaTexto());
//                } else {
//                    pstmt.setNull(4, Types.VARCHAR);
//                }
//
//                pstmt.setString(5, detalle.getFechaContestacion());
//                pstmt.addBatch();
//            }
//            pstmt.executeBatch();
//        }
//    }
//
//    /**
//     * Método completo para guardar una encuesta respondida
//     * @param respuesta Objeto Respuesta con datos principales
//     * @param detalles Lista de respuestas individuales
//     * @return ID de la respuesta generada
//     * @throws SQLException Si ocurre un error en la base de datos
//     */
//    public int guardarEncuestaCompleta(Respuesta respuesta, List<RespuestaDetalle> detalles) throws SQLException {
//        try (Connection conn = getConnection()) {
//            try {
//                conn.setAutoCommit(false);
//
//                int respuestaId = guardarRespuesta(respuesta);
//                guardarDetallesRespuesta(respuestaId, detalles);
//
//                conn.commit();
//                return respuestaId;
//
//            } catch (SQLException e) {
//                conn.rollback();
//                throw e;
//            } finally {
//                conn.setAutoCommit(true);
//            }
//        }
//    }
//
//    /**
//     * Obtiene las respuestas parciales de una encuesta asignada
//     * @param asignacionId ID de la asignación de encuesta
//     * @return Lista de respuestas detalle ya guardadas
//     * @throws SQLException Si ocurre un error en la base de datos
//     */
//    public List<RespuestaDetalle> obtenerRespuestasParciales(int asignacionId) throws SQLException {
//        String sql = "SELECT rd.*, bp.texto AS pregunta_texto, bp.tipo AS pregunta_tipo, " +
//                "po.texto_opcion AS opcion_texto " +
//                "FROM respuestas r " +
//                "JOIN respuestas_detalle rd ON r.respuesta_id = rd.respuesta_id " +
//                "JOIN banco_preguntas bp ON rd.pregunta_id = bp.pregunta_id " +
//                "LEFT JOIN pregunta_opciones po ON rd.opcion_id = po.opcion_id " +
//                "WHERE r.asignacion_id = ? " +
//                "ORDER BY rd.detalle_id";
//
//        List<RespuestaDetalle> respuestas = new ArrayList<>();
//
//        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, asignacionId);
//
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    RespuestaDetalle detalle = mapearRespuestaDetalle(rs);
//                    respuestas.add(detalle);
//                }
//            }
//        }
//
//        return respuestas;
//    }
//    private RespuestaDetalle mapearRespuestaDetalle(ResultSet rs) throws SQLException {
//        // Mapear respuesta principal (simplificada)
//        Respuesta respuesta = new Respuesta();
//        respuesta.setRespuestaId(rs.getInt("respuesta_id"));
//
//        // Mapear pregunta
//        BancoPreguntas pregunta = new BancoPreguntas();
//        pregunta.setPreguntaId(rs.getInt("pregunta_id"));
//        pregunta.setTexto(rs.getString("pregunta_texto"));
//        pregunta.setTipo(rs.getString("pregunta_tipo"));
//
//        // Mapear opción (si existe)
//        PreguntaOpcion opcion = null;
//        if (rs.getObject("opcion_id") != null) {
//            opcion = new PreguntaOpcion();
//            opcion.setOpcionId(rs.getInt("opcion_id"));
//            opcion.setTextoOpcion(rs.getString("opcion_texto"));
//        }
//
//        // Construir objeto RespuestaDetalle
//        RespuestaDetalle detalle = new RespuestaDetalle();
//        detalle.setDetalleId(rs.getInt("detalle_id"));
//        detalle.setRespuesta(respuesta);
//        detalle.setPregunta(pregunta);
//        detalle.setOpcion(opcion);
//        detalle.setRespuestaTexto(rs.getString("respuesta_texto"));
//        detalle.setFechaContestacion(rs.getString("fecha_contestacion"));
//
//        return detalle;
//    }
//
//}