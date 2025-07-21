package org.example.onu_mujeres_crud.daos;
import org.example.onu_mujeres_crud.beans.*;
import org.example.onu_mujeres_crud.dtos.EstadisticasEncuestadorDTO;
import org.example.onu_mujeres_crud.dtos.EstadisticasZonaDTO;
import org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO;

import java.sql.*;
import java.util.ArrayList;

// Pega y copia todo esta sección tal como esta ya que nadie trabajo con esta parte
public class CoordinadorDao extends BaseDAO {

    public ArrayList<Usuario> listarEncuestadores() {
        ArrayList<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito \n" +
                "FROM usuarios u \n" +
                "LEFT JOIN zonas z ON u.zona_id = z.zona_id\n" +
                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id\n" +
                "WHERE u.rol_id = 1\n";

        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setUsuarioId(rs.getInt("usuario_id"));
                u.setNombre(rs.getString("nombre"));
                u.setApellidoPaterno(rs.getString("apellido_paterno"));
                u.setApellidoMaterno(rs.getString("apellido_materno"));
                u.setDni(rs.getString("dni"));
                u.setCorreo(rs.getString("correo"));
                u.setEstado(rs.getString("estado"));

                // Zona
                Zona zona = new Zona();
                zona.setNombre(rs.getString("nombre_zona"));
                u.setZona(zona);

                // Distrito
                Distrito distrito = new Distrito();
                distrito.setNombre(rs.getString("nombre_distrito"));
                u.setDistrito(distrito);

                lista.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Usuario obtenerEncuestadorPorId(int id) {
        Usuario u = null;
        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
                "FROM usuarios u " +
                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
                "WHERE u.usuario_id = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario();
                    u.setUsuarioId(rs.getInt("usuario_id"));
                    u.setNombre(rs.getString("nombre"));
                    u.setApellidoPaterno(rs.getString("apellido_paterno"));
                    u.setApellidoMaterno(rs.getString("apellido_materno"));
                    u.setCorreo(rs.getString("correo"));
                    u.setDni(rs.getString("dni"));
                    u.setDireccion(rs.getString("direccion"));
                    u.setEstado(rs.getString("estado"));

                    // Zona
                    Zona zona = new Zona();
                    zona.setNombre(rs.getString("nombre_zona"));
                    u.setZona(zona);

                    // Distrito
                    Distrito distrito = new Distrito();
                    distrito.setNombre(rs.getString("nombre_distrito"));
                    u.setDistrito(distrito);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return u;
    }


    public void cambiarEstadoEncuestador(int usuarioId, String nuevoEstado) {
        String sql = "UPDATE usuarios SET estado = ? WHERE usuario_id = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, usuarioId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean existeDNI(String dni) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE dni = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dni);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    //asignar encuestas en ambos secciones
    public void asignarEncuesta(String nombreEncuesta, String carpeta, int encuestadorId, int coordinadorId) {
        String sql = "INSERT INTO encuestas_asignadas (encuesta_id, encuestador_id, coordinador_id, estado) " +
                "SELECT encuesta_id, ?, ?, 'asignada' FROM encuestas WHERE nombre = ? AND carpeta = ? AND estado = 'activo'";

        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, encuestadorId);
            stmt.setInt(2, coordinadorId);
            stmt.setString(3, nombreEncuesta);
            stmt.setString(4, carpeta);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // Filtrar por DISTRITO si un coordinador se le a asignado una ZONA
    public ArrayList<Distrito> listarDistritosPorZona(int zonaId) {
        ArrayList<Distrito> lista = new ArrayList<>();
        String sql = "SELECT distrito_id, nombre FROM distritos WHERE zona_id = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, zonaId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Distrito d = new Distrito();
                    d.setDistritoId(rs.getInt("distrito_id"));
                    d.setNombre(rs.getString("nombre"));
                    lista.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Cuando el Coordinador se le a asignado un DISTRITO

    public ArrayList<Usuario> listarEncuestadoresPorDistrito(int distritoId) {
        ArrayList<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
                "FROM usuarios u " +
                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
                "WHERE u.rol_id = 1";

        if (distritoId != -1) {
            sql += " AND u.distrito_id = ?";
        }

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (distritoId != -1) {
                pstmt.setInt(1, distritoId);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Usuario u = new Usuario();
                    u.setUsuarioId(rs.getInt("usuario_id"));
                    u.setNombre(rs.getString("nombre"));
                    u.setApellidoPaterno(rs.getString("apellido_paterno"));
                    u.setApellidoMaterno(rs.getString("apellido_materno"));
                    u.setDni(rs.getString("dni"));
                    u.setCorreo(rs.getString("correo"));
                    u.setEstado(rs.getString("estado"));

                    Zona zona = new Zona();
                    zona.setNombre(rs.getString("nombre_zona"));
                    u.setZona(zona);

                    Distrito distrito = new Distrito();
                    distrito.setNombre(rs.getString("nombre_distrito"));
                    u.setDistrito(distrito);

                    lista.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    // Filtrar solo por ZONA sin seleccionar distrito
    public ArrayList<Usuario> listarEncuestadoresPorZona(int zonaId) {
        ArrayList<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
                "FROM usuarios u " +
                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
                "WHERE u.rol_id = 1 AND u.zona_id = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, zonaId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Usuario u = new Usuario();
                    u.setUsuarioId(rs.getInt("usuario_id"));
                    u.setNombre(rs.getString("nombre"));
                    u.setApellidoPaterno(rs.getString("apellido_paterno"));
                    u.setApellidoMaterno(rs.getString("apellido_materno"));
                    u.setDni(rs.getString("dni"));
                    u.setCorreo(rs.getString("correo"));
                    u.setEstado(rs.getString("estado"));

                    Zona zona = new Zona();
                    zona.setNombre(rs.getString("nombre_zona"));
                    u.setZona(zona);

                    Distrito distrito = new Distrito();
                    distrito.setNombre(rs.getString("nombre_distrito"));
                    u.setDistrito(distrito);

                    lista.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // encuestadores por zona y distrito al asignar un formulario a encuestadores
    public ArrayList<Usuario> obtenerEncuestadoresPorZonaYDistrito(int zonaId, int distritoId) {
        ArrayList<Usuario> listaEncuestadores = new ArrayList<>();
        String sql = "SELECT u.usuario_id, u.nombre AS usuario_nombre, u.apellido_paterno, u.apellido_materno, " +
                "u.correo, u.dni, u.estado, " +
                "z.nombre AS zona_nombre, d.nombre AS distrito_nombre, r.nombre AS rol_nombre " +
                "FROM onu_mujeres.usuarios u " +
                "INNER JOIN onu_mujeres.roles r ON u.rol_id = r.rol_id " +
                "LEFT JOIN onu_mujeres.distritos d ON u.distrito_id = d.distrito_id " +
                "LEFT JOIN onu_mujeres.zonas z ON u.zona_id = z.zona_id " +
                "WHERE u.rol_id = 1 " +
                "AND u.estado = 'activo' AND u.zona_id = ? AND u.distrito_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, zonaId);
            pstmt.setInt(2, distritoId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setUsuarioId(rs.getInt("usuario_id"));
                    usuario.setNombre(rs.getString("usuario_nombre"));
                    usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
                    usuario.setApellidoMaterno(rs.getString("apellido_materno"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setEstado(rs.getString("estado"));

                    Zona zona = new Zona();
                    zona.setNombre(rs.getString("zona_nombre"));
                    usuario.setZona(zona);

                    Distrito distrito = new Distrito();
                    distrito.setNombre(rs.getString("distrito_nombre"));
                    usuario.setDistrito(distrito);

                    Rol rol = new Rol();
                    rol.setNombre(rs.getString("rol_nombre"));
                    usuario.setRol(rol);

                    listaEncuestadores.add(usuario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaEncuestadores;
    }

    // obtener todos los encuestadores por zona y distrito en la vista listavistaEncuestador
    public ArrayList<Usuario> obtenerTodosEncuestadoresPorZonaYDistrito(int zonaId, int distritoId) {
        ArrayList<Usuario> listaEncuestadores = new ArrayList<>();
        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
                "FROM usuarios u " +
                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
                "WHERE u.rol_id = 1 AND u.zona_id = ? AND u.distrito_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, zonaId);
            pstmt.setInt(2, distritoId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setUsuarioId(rs.getInt("usuario_id"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
                    usuario.setApellidoMaterno(rs.getString("apellido_materno"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setEstado(rs.getString("estado"));

                    Zona zona = new Zona();
                    zona.setNombre(rs.getString("nombre_zona"));
                    usuario.setZona(zona);

                    Distrito distrito = new Distrito();
                    distrito.setNombre(rs.getString("nombre_distrito"));
                    usuario.setDistrito(distrito);

                    listaEncuestadores.add(usuario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listaEncuestadores;
    }

    //asignar encuesta por Id para la seccion "Encuestas"
    public void asignarEncuestaPorId(int encuestaId, int encuestadorId, int coordinadorId) {
        String sql = "INSERT INTO encuestas_asignadas (encuesta_id, encuestador_id, coordinador_id, estado) " +
                "VALUES (?, ?, ?, 'asignada')";

        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, encuestaId);
            stmt.setInt(2, encuestadorId);
            stmt.setInt(3, coordinadorId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public ArrayList<EstadisticasEncuestadorDTO> obtenerEstadisticasPorEncuestador(int coordinadorId) {
        ArrayList<EstadisticasEncuestadorDTO> estadisticas = new ArrayList<>();
        String sql = "SELECT u.nombre, COUNT(ea.asignacion_id) as total " +
                "FROM usuarios u " +
                "JOIN encuestas_asignadas ea ON u.usuario_id = ea.encuestador_id " +
                "WHERE ea.coordinador_id = ? AND ea.estado = 'completada' " +
                "GROUP BY u.nombre";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, coordinadorId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    EstadisticasEncuestadorDTO dto = new EstadisticasEncuestadorDTO();
                    dto.setNombreEncuestador(rs.getString("nombre"));
                    dto.setCantidadRespuestas(rs.getInt("total"));
                    dto.setCompletadas(rs.getInt("total"));
                    dto.setEnProgreso(0);
                    estadisticas.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return estadisticas;
    }

    public ArrayList<EstadisticasZonaDTO> obtenerEstadisticasPorZona(int coordinadorId)  {
        ArrayList<EstadisticasZonaDTO> estadisticas = new ArrayList<>();
        String sql = "SELECT z.nombre as zona, d.nombre as distrito, " +
                "COUNT(ea.asignacion_id) as total " +
                "FROM zonas z " +
                "JOIN distritos d ON z.zona_id = d.zona_id " +
                "JOIN usuarios u ON d.distrito_id = u.distrito_id " +
                "JOIN encuestas_asignadas ea ON u.usuario_id = ea.encuestador_id " +
                "WHERE ea.coordinador_id = ? AND ea.estado = 'completada' " +
                "GROUP BY z.nombre, d.nombre";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, coordinadorId);
            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    EstadisticasZonaDTO dto = new EstadisticasZonaDTO();
                    dto.setNombreZona(rs.getString("zona"));
                    dto.setNombreDistrito(rs.getString("distrito"));
                    dto.setTotalRespuestas(rs.getInt("total"));
                    dto.setCompletadas(rs.getInt("total"));
                    dto.setPendientes(0);
                    estadisticas.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return estadisticas;
    }
    // Obtener estadísticas de respuestas para las preguntas SI y NO
    public ArrayList<RespuestaSiNoDTO> obtenerEstadisticasPreguntaSiNo(int preguntaId) {
        ArrayList<RespuestaSiNoDTO> lista = new ArrayList<>();

        String sql = "SELECT po.texto_opcion, COUNT(*) AS cantidad " +
                "FROM respuestas_detalle rd " +
                "JOIN respuestas r ON rd.respuesta_id = r.respuesta_id " +
                "JOIN encuestas_asignadas ea ON r.asignacion_id = ea.asignacion_id " +
                "JOIN pregunta_opciones po ON rd.opcion_id = po.opcion_id " +
                "WHERE po.pregunta_id = ? AND ea.estado = 'completada' " +
                "GROUP BY po.texto_opcion";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, preguntaId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    RespuestaSiNoDTO dto = new RespuestaSiNoDTO();
                    dto.setRespuesta(rs.getString("texto_opcion"));
                    dto.setCantidad(rs.getInt("cantidad"));
                    lista.add(dto);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}

//package org.example.onu_mujeres_crud.daos;
//import org.example.onu_mujeres_crud.beans.*;
//import java.sql.*;
//import java.util.ArrayList;
//
//// Pega y copia todo esta sección tal como esta ya que nadie trabajo con esta parte
//public class CoordinadorDao extends BaseDAO {
//
//    public ArrayList<Usuario> listarEncuestadores() {
//        ArrayList<Usuario> lista = new ArrayList<>();
//        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito \n" +
//                "FROM usuarios u \n" +
//                "LEFT JOIN zonas z ON u.zona_id = z.zona_id\n" +
//                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id\n" +
//                "WHERE u.rol_id = 1\n";
//
//        try (Connection conn = this.getConnection();
//             Statement stmt = conn.createStatement();
//             ResultSet rs = stmt.executeQuery(sql)) {
//
//            while (rs.next()) {
//                Usuario u = new Usuario();
//                u.setUsuarioId(rs.getInt("usuario_id"));
//                u.setNombre(rs.getString("nombre"));
//                u.setApellidoPaterno(rs.getString("apellido_paterno"));
//                u.setApellidoMaterno(rs.getString("apellido_materno"));
//                u.setDni(rs.getString("dni"));
//                u.setCorreo(rs.getString("correo"));
//                u.setEstado(rs.getString("estado"));
//
//                // Zona
//                Zona zona = new Zona();
//                zona.setNombre(rs.getString("nombre_zona"));
//                u.setZona(zona);
//
//                // Distrito
//                Distrito distrito = new Distrito();
//                distrito.setNombre(rs.getString("nombre_distrito"));
//                u.setDistrito(distrito);
//
//                lista.add(u);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return lista;
//    }
//
//    public Usuario obtenerEncuestadorPorId(int id) {
//        Usuario u = null;
//        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
//                "FROM usuarios u " +
//                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
//                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
//                "WHERE u.usuario_id = ?";
//
//        try (Connection conn = this.getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//
//            pstmt.setInt(1, id);
//            try (ResultSet rs = pstmt.executeQuery()) {
//                if (rs.next()) {
//                    u = new Usuario();
//                    u.setUsuarioId(rs.getInt("usuario_id"));
//                    u.setNombre(rs.getString("nombre"));
//                    u.setApellidoPaterno(rs.getString("apellido_paterno"));
//                    u.setApellidoMaterno(rs.getString("apellido_materno"));
//                    u.setCorreo(rs.getString("correo"));
//                    u.setDni(rs.getString("dni"));
//                    u.setDireccion(rs.getString("direccion"));
//                    u.setEstado(rs.getString("estado"));
//
//                    // Zona
//                    Zona zona = new Zona();
//                    zona.setNombre(rs.getString("nombre_zona"));
//                    u.setZona(zona);
//
//                    // Distrito
//                    Distrito distrito = new Distrito();
//                    distrito.setNombre(rs.getString("nombre_distrito"));
//                    u.setDistrito(distrito);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return u;
//    }
//
//
//    public void cambiarEstadoEncuestador(int usuarioId, String nuevoEstado) {
//        String sql = "UPDATE usuarios SET estado = ? WHERE usuario_id = ?";
//        try (Connection conn = this.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, nuevoEstado);
//            stmt.setInt(2, usuarioId);
//            stmt.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//    public boolean existeDNI(String dni) throws SQLException {
//        String sql = "SELECT COUNT(*) FROM usuarios WHERE dni = ?";
//        try (Connection conn = this.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setString(1, dni);
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//                    return rs.getInt(1) > 0;
//                }
//            }
//        }
//        return false;
//    }
//
//    //asignar encuestas en ambos secciones
//    public void asignarEncuesta(String nombreEncuesta, String carpeta, int encuestadorId, int coordinadorId) {
//        String sql = "INSERT INTO encuestas_asignadas (encuesta_id, encuestador_id, coordinador_id, estado) " +
//                "SELECT encuesta_id, ?, ?, 'asignada' FROM encuestas WHERE nombre = ? AND carpeta = ? AND estado = 'activo'";
//
//        try (Connection conn = this.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, encuestadorId);
//            stmt.setInt(2, coordinadorId);
//            stmt.setString(3, nombreEncuesta);
//            stmt.setString(4, carpeta);
//            stmt.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//    // Filtrar por DISTRITO si un coordinador se le a asignado una ZONA
//    public ArrayList<Distrito> listarDistritosPorZona(int zonaId) {
//        ArrayList<Distrito> lista = new ArrayList<>();
//        String sql = "SELECT distrito_id, nombre FROM distritos WHERE zona_id = ?";
//
//        try (Connection conn = this.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, zonaId);
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Distrito d = new Distrito();
//                    d.setDistritoId(rs.getInt("distrito_id"));
//                    d.setNombre(rs.getString("nombre"));
//                    lista.add(d);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return lista;
//    }
//
//    // Cuando el Coordinador se le a asignado un DISTRITO
//
//    public ArrayList<Usuario> listarEncuestadoresPorDistrito(int distritoId) {
//        ArrayList<Usuario> lista = new ArrayList<>();
//        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
//                "FROM usuarios u " +
//                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
//                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
//                "WHERE u.rol_id = 1";
//
//        if (distritoId != -1) {
//            sql += " AND u.distrito_id = ?";
//        }
//
//        try (Connection conn = this.getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//
//            if (distritoId != -1) {
//                pstmt.setInt(1, distritoId);
//            }
//
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Usuario u = new Usuario();
//                    u.setUsuarioId(rs.getInt("usuario_id"));
//                    u.setNombre(rs.getString("nombre"));
//                    u.setApellidoPaterno(rs.getString("apellido_paterno"));
//                    u.setApellidoMaterno(rs.getString("apellido_materno"));
//                    u.setDni(rs.getString("dni"));
//                    u.setCorreo(rs.getString("correo"));
//                    u.setEstado(rs.getString("estado"));
//
//                    Zona zona = new Zona();
//                    zona.setNombre(rs.getString("nombre_zona"));
//                    u.setZona(zona);
//
//                    Distrito distrito = new Distrito();
//                    distrito.setNombre(rs.getString("nombre_distrito"));
//                    u.setDistrito(distrito);
//
//                    lista.add(u);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return lista;
//    }
//    // Filtrar solo por ZONA sin seleccionar distrito
//    public ArrayList<Usuario> listarEncuestadoresPorZona(int zonaId) {
//        ArrayList<Usuario> lista = new ArrayList<>();
//        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
//                "FROM usuarios u " +
//                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
//                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
//                "WHERE u.rol_id = 1 AND u.zona_id = ?";
//
//        try (Connection conn = this.getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//
//            pstmt.setInt(1, zonaId);
//
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Usuario u = new Usuario();
//                    u.setUsuarioId(rs.getInt("usuario_id"));
//                    u.setNombre(rs.getString("nombre"));
//                    u.setApellidoPaterno(rs.getString("apellido_paterno"));
//                    u.setApellidoMaterno(rs.getString("apellido_materno"));
//                    u.setDni(rs.getString("dni"));
//                    u.setCorreo(rs.getString("correo"));
//                    u.setEstado(rs.getString("estado"));
//
//                    Zona zona = new Zona();
//                    zona.setNombre(rs.getString("nombre_zona"));
//                    u.setZona(zona);
//
//                    Distrito distrito = new Distrito();
//                    distrito.setNombre(rs.getString("nombre_distrito"));
//                    u.setDistrito(distrito);
//
//                    lista.add(u);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return lista;
//    }
//
//    // encuestadores por zona y distrito al asignar un formulario a encuestadores
//    public ArrayList<Usuario> obtenerEncuestadoresPorZonaYDistrito(int zonaId, int distritoId) {
//        ArrayList<Usuario> listaEncuestadores = new ArrayList<>();
//        String sql = "SELECT * FROM onu_mujeres.usuarios u " +
//                "INNER JOIN onu_mujeres.roles r ON u.rol_id = r.rol_id " +
//                "LEFT JOIN onu_mujeres.distritos d ON u.distrito_id = d.distrito_id " +
//                "LEFT JOIN onu_mujeres.zonas z ON u.zona_id = z.zona_id " +
//                "WHERE u.rol_id = 1 " +
//                "AND u.estado = 'activo' AND u.zona_id = ? AND u.distrito_id = ?";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//
//            pstmt.setInt(1, zonaId);
//            pstmt.setInt(2, distritoId);
//
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Usuario usuario = new Usuario();
//
//                    usuario.setUsuarioId(rs.getInt("usuario_id"));
//                    usuario.setNombre(rs.getString("u.nombre"));
//                    usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
//                    usuario.setApellidoMaterno(rs.getString("apellido_materno"));
//                    usuario.setCorreo(rs.getString("correo"));
//                    usuario.setDni(rs.getString("dni"));
//
//                    Zona zona = new Zona();
//                    zona.setNombre(rs.getString("z.nombre"));
//                    usuario.setZona(zona);
//
//                    Distrito distrito = new Distrito();
//                    distrito.setNombre(rs.getString("d.nombre"));
//                    usuario.setDistrito(distrito);
//
//                    Rol rol = new Rol();
//                    rol.setNombre(rs.getString("r.nombre"));
//                    usuario.setRol(rol);
//
//                    listaEncuestadores.add(usuario);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return listaEncuestadores;
//    }
//
//    // obtener todos los encuestadores por zona y distrito en la vista listavistaEncuestador
//    public ArrayList<Usuario> obtenerTodosEncuestadoresPorZonaYDistrito(int zonaId, int distritoId) {
//        ArrayList<Usuario> listaEncuestadores = new ArrayList<>();
//        String sql = "SELECT u.*, z.nombre AS nombre_zona, d.nombre AS nombre_distrito " +
//                "FROM usuarios u " +
//                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
//                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
//                "WHERE u.rol_id = 1 AND u.zona_id = ? AND u.distrito_id = ?";
//
//        try (Connection conn = getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//
//            pstmt.setInt(1, zonaId);
//            pstmt.setInt(2, distritoId);
//
//            try (ResultSet rs = pstmt.executeQuery()) {
//                while (rs.next()) {
//                    Usuario usuario = new Usuario();
//                    usuario.setUsuarioId(rs.getInt("usuario_id"));
//                    usuario.setNombre(rs.getString("nombre"));
//                    usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
//                    usuario.setApellidoMaterno(rs.getString("apellido_materno"));
//                    usuario.setCorreo(rs.getString("correo"));
//                    usuario.setDni(rs.getString("dni"));
//                    usuario.setEstado(rs.getString("estado"));
//
//                    Zona zona = new Zona();
//                    zona.setNombre(rs.getString("nombre_zona"));
//                    usuario.setZona(zona);
//
//                    Distrito distrito = new Distrito();
//                    distrito.setNombre(rs.getString("nombre_distrito"));
//                    usuario.setDistrito(distrito);
//
//                    listaEncuestadores.add(usuario);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return listaEncuestadores;
//    }
//
//    //asignar encuesta por Id para la seccion "Encuestas"
//    public void asignarEncuestaPorId(int encuestaId, int encuestadorId, int coordinadorId) {
//        String sql = "INSERT INTO encuestas_asignadas (encuesta_id, encuestador_id, coordinador_id, estado) " +
//                "VALUES (?, ?, ?, 'asignada')";
//
//        try (Connection conn = this.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, encuestaId);
//            stmt.setInt(2, encuestadorId);
//            stmt.setInt(3, coordinadorId);
//            stmt.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//
//
//}
