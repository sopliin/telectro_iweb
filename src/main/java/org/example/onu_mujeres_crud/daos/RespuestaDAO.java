// src/main/java/org/example/onu_mujeres_crud/daos/RespuestaDAO.java
package org.example.onu_mujeres_crud.daos;

import org.example.onu_mujeres_crud.beans.Respuesta;
import org.example.onu_mujeres_crud.beans.RespuestaDetalle;
import org.example.onu_mujeres_crud.beans.BancoPreguntas; // Necesitas este bean
import org.example.onu_mujeres_crud.beans.PreguntaOpcion; // Necesitas este bean
import org.example.onu_mujeres_crud.beans.EncuestaAsignada; // Necesitas este bean

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList; // Asegúrate de importar ArrayList si lo usas en otros métodos

public class RespuestaDAO extends BaseDAO {

    /**
     * Guarda la información principal de una respuesta de encuesta.
     *
     * @param dniEncuestado El DNI del encuestado.
     * @param asignacionId  El ID de la asignación de encuesta a la que pertenece esta respuesta.
     * @param fechaInicio   Fecha y hora de inicio de la encuesta (en formato "yyyy-MM-dd HH:mm:ss").
     * @param fechaEnvio    Fecha y hora de envío de la encuesta (en formato "yyyy-MM-dd HH:mm:ss").
     * @return El ID generado para la nueva respuesta, o 0 si hubo un error.
     * @throws SQLException Si ocurre un error en la base de datos.
     */
    public int guardarRespuestaPrincipal(String dniEncuestado, int asignacionId, String fechaInicio, String fechaEnvio) throws SQLException {
        int respuestaId = 0;
        String sql = "INSERT INTO respuestas (dni_encuestado, asignacion_id, fecha_inicio, fecha_ultima_edicion) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, dniEncuestado);
            pstmt.setInt(2, asignacionId);
            pstmt.setString(3, fechaInicio);
            pstmt.setString(4, fechaEnvio);

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        respuestaId = rs.getInt(1);
                    }
                }
            }
        }
        return respuestaId;
    }

    public void guardarRespuestasDetalle(int respuestaId, List<RespuestaDetalle> listaDetalles) throws SQLException {
        // Usamos un batch para mayor eficiencia
        String sql = "INSERT INTO respuestas_detalle (respuesta_id, pregunta_id, opcion_id, respuesta_texto, fecha_contestacion) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (RespuestaDetalle detalle : listaDetalles) {
                pstmt.setInt(1, respuestaId);
                pstmt.setInt(2, detalle.getPregunta().getPreguntaId());

                // Manejo de opcion_id: si la opción es nula, se inserta NULL en la columna
                if (detalle.getOpcion() != null) {
                    pstmt.setInt(3, detalle.getOpcion().getOpcionId());
                } else {
                    pstmt.setNull(3, Types.INTEGER); // Establecer NULL si no hay opción
                }

                pstmt.setString(4, detalle.getRespuestaTexto());
                pstmt.setString(5, detalle.getFechaContestacion());
                pstmt.addBatch(); // Añadir a la cola de batch
            }
            pstmt.executeBatch(); // Ejecutar todas las inserciones en un batch
        }
    }
}

    // Puedes añadir otros métodos aquí si necesitas, por ejemplo, obtener respuestas de una asignación
