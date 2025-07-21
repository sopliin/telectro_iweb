package org.example.onu_mujeres_crud.daos;

import org.example.onu_mujeres_crud.beans.Encuesta;
import org.example.onu_mujeres_crud.beans.EncuestaAsignada;
import org.example.onu_mujeres_crud.beans.Usuario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EncuestaDAO extends BaseDAO {

    //Para obtener la lista de todas las encuestas
    public List<Encuesta> obtenerTodasLasEncuestas(int encuestadorId) {
        List<Encuesta> todasLasEncuestas = new ArrayList<>();
        String sql = "SELECT e.encuesta_id, e.nombre, e.descripcion\n" +
                "FROM encuestas_asignadas ea\n" +
                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
                "WHERE ea.encuestador_id = ? AND ea.estado = 'asignada'";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre"));
                    encuesta.setDescripcion(rs.getString("descripcion"));
                    todasLasEncuestas.add(encuesta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return todasLasEncuestas;
    }

    //OBtener solo las encuestas sin completas
    public List<Encuesta> obtenerFormulariosSinLlenar(int encuestadorId) {
        List<Encuesta> encuestasSinLlenar = new ArrayList<>();
        String sql = "SELECT e.encuesta_id, e.nombre, e.descripcion\n" +
                "FROM encuestas_asignadas ea\n" +
                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
                "LEFT JOIN respuestas r ON e.encuesta_id = r.encuesta_id AND r.encuestador_id = ea.encuestador_id\n" +
                "WHERE ea.encuestador_id = ? AND ea.estado = 'activo' AND r.respuesta_id IS NULL";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre"));
                    encuesta.setDescripcion(rs.getString("descripcion"));
                    encuestasSinLlenar.add(encuesta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return encuestasSinLlenar;
    }

    //Obtener las encuestas a medio hacer
    public List<Encuesta> obtenerFormulariosConBorradores(int encuestadorId) {
        List<Encuesta> encuestasConBorradores = new ArrayList<>();
        String sql = "SELECT e.encuesta_id, e.nombre, COUNT(r.respuesta_id) AS borradores\n" +
                "FROM encuestas_asignadas ea\n" +
                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
                "INNER JOIN respuestas r ON e.encuesta_id = r.encuesta_id AND r.encuestador_id = ea.encuestador_id\n" +
                "WHERE ea.encuestador_id = ? AND ea.estado = 'activo' AND r.estado = 'borrador'\n" +
                "GROUP BY e.encuesta_id, e.nombre";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre"));
                    encuestasConBorradores.add(encuesta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return encuestasConBorradores;
    }

    //Para las encuenstas ya completadas
    public List<Encuesta> obtenerFormulariosCompletados(int encuestadorId) {
        List<Encuesta> encuestasCompletadas = new ArrayList<>();
        String sql = "SELECT e.encuesta_id, e.nombre, COUNT(r.respuesta_id) AS completadas\n" +
                "FROM encuestas_asignadas ea\n" +
                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
                "INNER JOIN respuestas r ON e.encuesta_id = r.encuesta_id AND r.encuestador_id = ea.encuestador_id\n" +
                "WHERE ea.encuestador_id = ? AND ea.estado = 'activo' AND r.estado = 'completo'\n" +
                "GROUP BY e.encuesta_id, e.nombre";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre"));
                    encuestasCompletadas.add(encuesta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return encuestasCompletadas;
    }
    public List<EncuestaAsignada> obtenerFormulariosCompletados1(int encuestadorId,String estado, int offset, int limit) {
        List<EncuestaAsignada> encuestasCompletadas = new ArrayList<>();
        String sql = "SELECT ea.asignacion_id, e.encuesta_id, e.nombre AS nombre_encuesta, " +
                "e.descripcion, ea.fecha_asignacion, ea.fecha_completado, " +
                "u_coord.nombre AS coordinador_asignador, u_coord.apellido_paterno AS coordinador_apellido, " +
                "u_encuest.nombre AS encuestador,e.estado " +
                "FROM encuestas_asignadas ea " +
                "JOIN encuestas e ON ea.encuesta_id = e.encuesta_id " +
                "JOIN usuarios u_coord ON ea.coordinador_id = u_coord.usuario_id " +
                "JOIN usuarios u_encuest ON ea.encuestador_id = u_encuest.usuario_id " +
                "WHERE ea.encuestador_id = ? AND ea.estado = ? " +
                "ORDER BY ea.fecha_completado DESC LIMIT ? OFFSET ?;";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            pstmt.setString(2, estado);
            pstmt.setInt(3, limit);
            pstmt.setInt(4, offset);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    EncuestaAsignada encuestaAsignada = new EncuestaAsignada();
                    encuestaAsignada.setAsignacionId(rs.getInt("asignacion_id"));
                    encuestaAsignada.setFechaCompletado(rs.getString("fecha_completado"));
                    encuestaAsignada.setFechaAsignacion(rs.getString("fecha_asignacion"));
                    encuestaAsignada.setEstado(estado);
                    Usuario coordinador = new Usuario();
                    coordinador.setNombre(rs.getString("coordinador_asignador"));
                    coordinador.setApellidoPaterno(rs.getString("coordinador_apellido"));
                    encuestaAsignada.setCoordinador(coordinador);
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre_encuesta"));
                    encuesta.setDescripcion(rs.getString("descripcion"));
                    encuesta.setEstado(rs.getString("e.estado"));
                    encuestaAsignada.setEncuesta(encuesta);

                    encuestasCompletadas.add(encuestaAsignada);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return encuestasCompletadas;
    }
    public List<EncuestaAsignada> obtenerFormulariosCompletados2(int encuestadorId, int offset, int limit) {
        List<EncuestaAsignada> encuestasCompletadas = new ArrayList<>();
        String sql = "SELECT ea.asignacion_id, e.encuesta_id, e.nombre AS nombre_encuesta, " +
                "e.descripcion, ea.fecha_asignacion, ea.fecha_completado,e.estado,ea.estado, " +
                "u_coord.nombre AS coordinador_asignador, u_coord.apellido_paterno AS coordinador_apellido, " +
                "u_encuest.nombre AS encuestador,u_coord.usuario_id " +
                "FROM encuestas_asignadas ea " +
                "JOIN encuestas e ON ea.encuesta_id = e.encuesta_id " +
                "JOIN usuarios u_coord ON ea.coordinador_id = u_coord.usuario_id " +
                "JOIN usuarios u_encuest ON ea.encuestador_id = u_encuest.usuario_id " +
                "WHERE ea.encuestador_id = ? "+
                "ORDER BY ea.fecha_asignacion DESC LIMIT ? OFFSET ?;";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            pstmt.setInt(2, limit);
            pstmt.setInt(3, offset);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    EncuestaAsignada encuestaAsignada = new EncuestaAsignada();
                    encuestaAsignada.setAsignacionId(rs.getInt("asignacion_id"));
                    encuestaAsignada.setFechaCompletado(rs.getString("fecha_completado"));
                    encuestaAsignada.setFechaAsignacion(rs.getString("fecha_asignacion"));
                    encuestaAsignada.setEstado(rs.getString("ea.estado"));
                    Usuario coordinador = new Usuario();
                    coordinador.setNombre(rs.getString("u_coord.usuario_id"));
                    coordinador.setNombre(rs.getString("coordinador_asignador"));
                    coordinador.setApellidoPaterno(rs.getString("coordinador_apellido"));

                    encuestaAsignada.setCoordinador(coordinador);
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("e.encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre_encuesta"));
                    encuesta.setDescripcion(rs.getString("descripcion"));
                    encuesta.setEstado(rs.getString("e.estado"));

                    encuestaAsignada.setEncuesta(encuesta);

                    encuestasCompletadas.add(encuestaAsignada);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return encuestasCompletadas;
    }
    public int contarEncuestasAsignadas(int encuestadorId, String estado) {
        String sql = "SELECT COUNT(*) FROM encuestas_asignadas WHERE encuestador_id = ?";
        if (estado != null && !estado.isEmpty()) {
            sql += " AND estado = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, encuestadorId);
            if (estado != null && !estado.isEmpty()) {
                pstmt.setString(2, estado);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public String obtenerCoordinador(int coordinadorId) {

        String sql = "SELECT nombre from usuarios where usuario_id = ?";
        String nombreCoordinador = "";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, coordinadorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    nombreCoordinador=rs.getString("nombre");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nombreCoordinador;
    }
    public int contarFormulariosCompletados1(int encuestadorId, String estado) {
        String sql = "SELECT COUNT(*) FROM encuestas_asignadas WHERE encuestador_id = ? AND estado = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, encuestadorId);
            pstmt.setString(2, estado);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // A partir de acá se realizo los nuevos metodos para la sección de coordinador
    // ------------------------------------------------------------------------------
    // Para obtener las carpetas que estan disponibles
    public ArrayList<String> obtenerCarpetasDisponibles() {
        ArrayList<String> carpetas = new ArrayList<>();
        String sql = "SELECT DISTINCT carpeta FROM encuestas";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                carpetas.add(rs.getString("carpeta"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return carpetas;
    }

    // Obtener las encuestas por carpeta para el filtrado
    public ArrayList<Encuesta> obtenerEncuestasPorCarpeta(String carpeta) {
        ArrayList<Encuesta> encuestas = new ArrayList<>();
        String sql;

        if (carpeta == null || carpeta.isEmpty()) {
            sql = "SELECT encuesta_id, nombre, descripcion, estado FROM encuestas";
        } else {
            sql = "SELECT encuesta_id, nombre, descripcion, estado FROM encuestas WHERE carpeta = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (carpeta != null && !carpeta.isEmpty()) {
                pstmt.setString(1, carpeta);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre"));
                    encuesta.setDescripcion(rs.getString("descripcion"));
                    encuesta.setEstado(rs.getString("estado"));
                    encuestas.add(encuesta);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return encuestas;
    }

    // para asignar encuestas a los encuestadores desde la vista de "encuestadores"
    public ArrayList<Encuesta> obtenerEncuestasPorCarpetaAsignar(String carpeta) {
        ArrayList<Encuesta> encuestas = new ArrayList<>();
        String sql;

        if (carpeta == null || carpeta.isEmpty()) {
            sql = "SELECT encuesta_id, nombre, descripcion, estado, carpeta FROM encuestas";
        } else {
            sql = "SELECT encuesta_id, nombre, descripcion, estado FROM encuestas WHERE carpeta = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (carpeta != null && !carpeta.isEmpty()) {
                pstmt.setString(1, carpeta);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Encuesta encuesta = new Encuesta();
                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                    encuesta.setNombre(rs.getString("nombre"));
                    encuesta.setDescripcion(rs.getString("descripcion"));
                    encuesta.setEstado(rs.getString("estado"));
                    encuesta.setCarpeta(rs.getString("carpeta"));
                    encuestas.add(encuesta);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return encuestas;
    }


    // actualiza los estados de ENCUESTAS
    public void actualizarEstadoEncuesta(int encuestaId, String nuevoEstado) {
        String sql = "UPDATE encuestas SET estado = ? WHERE encuesta_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nuevoEstado);
            pstmt.setInt(2, encuestaId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Encuestas para realizar el filtrado
    public Encuesta obtenerEncuestaPorId(int id) {
        Encuesta encuesta = null;
        String sql = "SELECT * FROM encuestas WHERE encuesta_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                encuesta = new Encuesta();
                encuesta.setEncuestaId(rs.getInt("encuesta_id"));
                encuesta.setNombre(rs.getString("nombre"));
                encuesta.setDescripcion(rs.getString("descripcion"));
                encuesta.setCarpeta(rs.getString("carpeta"));
                encuesta.setEstado(rs.getString("estado"));
                encuesta.setFechaCreacion(String.valueOf(rs.getTimestamp("fecha_creacion").toLocalDateTime()));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return encuesta;
    }
    // ------------------------------------------------------------------------------
}



//package org.example.onu_mujeres_crud.daos;
//
//import org.example.onu_mujeres_crud.beans.Encuesta;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class EncuestaDAO extends BaseDAO{
//
//    //Para obtener la lista de todas las encuestas
//    public List<Encuesta> obtenerTodasLasEncuestas(int encuestadorId) {
//        List<Encuesta> todasLasEncuestas = new ArrayList<>();
//        String sql = "SELECT e.encuesta_id, e.nombre, e.descripcion\n" +
//                "FROM encuestas_asignadas ea\n" +
//                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
//                "WHERE ea.encuestador_id = ? AND ea.estado = 'activo'";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//            pstmt.setInt(1, encuestadorId);
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Encuesta encuesta = new Encuesta();
//                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
//                    encuesta.setNombre(rs.getString("nombre"));
//                    encuesta.setDescripcion(rs.getString("descripcion"));
//                    todasLasEncuestas.add(encuesta);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return todasLasEncuestas;
//    }
//
//    //OBtener solo las encuestas sin completas
//    public List<Encuesta> obtenerFormulariosSinLlenar(int encuestadorId) {
//        List<Encuesta> encuestasSinLlenar = new ArrayList<>();
//        String sql = "SELECT e.encuesta_id, e.nombre, e.descripcion\n" +
//                "FROM encuestas_asignadas ea\n" +
//                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
//                "LEFT JOIN respuestas r ON e.encuesta_id = r.encuesta_id AND r.encuestador_id = ea.encuestador_id\n" +
//                "WHERE ea.encuestador_id = ? AND ea.estado = 'activo' AND r.respuesta_id IS NULL";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//            pstmt.setInt(1, encuestadorId);
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Encuesta encuesta = new Encuesta();
//                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
//                    encuesta.setNombre(rs.getString("nombre"));
//                    encuesta.setDescripcion(rs.getString("descripcion"));
//                    encuestasSinLlenar.add(encuesta);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return encuestasSinLlenar;
//    }
//
//    //Obtener las encuestas a medio hacer
//    public List<Encuesta> obtenerFormulariosConBorradores(int encuestadorId) {
//        List<Encuesta> encuestasConBorradores = new ArrayList<>();
//        String sql = "SELECT e.encuesta_id, e.nombre, COUNT(r.respuesta_id) AS borradores\n" +
//                "FROM encuestas_asignadas ea\n" +
//                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
//                "INNER JOIN respuestas r ON e.encuesta_id = r.encuesta_id AND r.encuestador_id = ea.encuestador_id\n" +
//                "WHERE ea.encuestador_id = ? AND ea.estado = 'activo' AND r.estado = 'borrador'\n" +
//                "GROUP BY e.encuesta_id, e.nombre";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//            pstmt.setInt(1, encuestadorId);
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Encuesta encuesta = new Encuesta();
//                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
//                    encuesta.setNombre(rs.getString("nombre"));
//                    encuestasConBorradores.add(encuesta);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return encuestasConBorradores;
//    }
//
//    //Para las encuenstas ya completadas
//    public List<Encuesta> obtenerFormulariosCompletados(int encuestadorId) {
//        List<Encuesta> encuestasCompletadas = new ArrayList<>();
//        String sql = "SELECT e.encuesta_id, e.nombre, COUNT(r.respuesta_id) AS completadas\n" +
//                "FROM encuestas_asignadas ea\n" +
//                "INNER JOIN encuestas e ON ea.encuesta_id = e.encuesta_id\n" +
//                "INNER JOIN respuestas r ON e.encuesta_id = r.encuesta_id AND r.encuestador_id = ea.encuestador_id\n" +
//                "WHERE ea.encuestador_id = ? AND ea.estado = 'activo' AND r.estado = 'completo'\n" +
//                "GROUP BY e.encuesta_id, e.nombre";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//            pstmt.setInt(1, encuestadorId);
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Encuesta encuesta = new Encuesta();
//                    encuesta.setEncuestaId(rs.getInt("encuesta_id"));
//                    encuesta.setNombre(rs.getString("nombre"));
//                    encuestasCompletadas.add(encuesta);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return encuestasCompletadas;
//    }
//
//}
//
//
