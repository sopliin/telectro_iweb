// src/main/java/org/example/onu_mujeres_crud/daos/EncuestaAsignadaDAO.java
package org.example.onu_mujeres_crud.daos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class EncuestaAsignadaDAO extends BaseDAO {

    // Método para crear una nueva asignación de encuesta para la importación de Excel
    public int crearAsignacionParaImportacion(int encuestaId, int coordinadorId) throws SQLException {
        int asignacionId = 0;
        String sql = "INSERT INTO encuestas_asignadas (encuesta_id, encuestador_id, coordinador_id, estado, fecha_asignacion, fecha_completado) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // IDs fijos para encuestador y coordinador
            int encuestadorIdFijo = 1;
            int coordinadorIdFijo = 1;
            String estado = "completada"; // O "importada" si prefieres un estado diferente para importaciones
            String fechaActual = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            pstmt.setInt(1, encuestaId);
            pstmt.setInt(2, encuestadorIdFijo);
            pstmt.setInt(3, coordinadorIdFijo);
            pstmt.setString(4, estado);
            pstmt.setString(5, fechaActual);
            pstmt.setString(6, fechaActual); // La fecha de completado es la misma que la de asignación para la importación

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        asignacionId = rs.getInt(1);
                    }
                }
            }
        }
        return asignacionId;
    }



    // Puedes agregar aquí métodos para obtener información sobre EncuestaAsignada si lo necesitas,
    // por ejemplo, para verificar si existe una asignación para una encuesta específica con estos IDs fijos.
}