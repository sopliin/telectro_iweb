package org.example.onu_mujeres_crud.daos;

import org.example.onu_mujeres_crud.beans.Distrito;
import org.example.onu_mujeres_crud.beans.Rol;
import org.example.onu_mujeres_crud.beans.Usuario;
import org.example.onu_mujeres_crud.beans.Zona;
import org.example.onu_mujeres_crud.dtos.DashboardDTO;

import java.sql.*;
import java.util.*;

public class UsuarioAdminDao extends BaseDAO{

    //Para admin, listar todos los usuarios entre Coordis y Encuestadores
    public ArrayList<Usuario> listarUsuariosAsAdmin() {
        ArrayList<Usuario> listaUsuarios = new ArrayList<>();

        String sql = "select * from onu_mujeres.usuarios u\n" +
                "inner join onu_mujeres.roles r on ((u.rol_id = 1 or u.rol_id = 2) and (u.rol_id = r.rol_id))\n" +
                "left join onu_mujeres.distritos d on (u.distrito_id = d.distrito_id)\n" +
                "left join onu_mujeres.zonas z on (u.zona_id = z.zona_id)";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)){
            while (rs.next()) {
                Usuario usuario = fetchUsuarioData(rs);
                if(usuario.getDistrito() == null){
                    Distrito distrito = new Distrito();
                    distrito.setDistritoId(0);
                    distrito.setNombre("N/A");
                    distrito.setZona(null);
                }
                listaUsuarios.add(usuario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaUsuarios;
    }

    //Obtener un usuario a partir de su ID
    public Usuario obtenerUsuario(int usuarioId) {
        Usuario usuario = null;
        String sql = "SELECT * FROM onu_mujeres.usuarios u\n" +
                "LEFT JOIN onu_mujeres.roles r ON u.rol_id = r.rol_id\n" +
                "LEFT JOIN onu_mujeres.distritos d ON u.distrito_id = d.distrito_id\n" +
                "LEFT JOIN onu_mujeres.zonas z ON u.zona_id = z.zona_id\n" +
                "WHERE u.usuario_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, usuarioId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = fetchUsuarioData(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return usuario;
    }


    //Registrar usuario para admin (crear coordinadores mediante el ingreso de nombre, apellido, DNI, Correo y zona)
    public void registrarCoordinador(Usuario usuario) {
        String sql = "INSERT INTO onu_mujeres.usuarios (rol_id, nombre, apellido_paterno, apellido_materno, dni, correo, zona_id, distrito_id, correo_verificado, profile_photo_url)\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            setCoordinadorData(usuario, pstmt);
            pstmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }


    //"Desactivar a los usuarios tipo coordi o encuestador"
    public void desactivarUsuario(int usuarioId) {

        String sql = "UPDATE onu_mujeres.usuarios SET estado = 'baneado' WHERE usuario_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usuarioId);
            pstmt.executeUpdate();

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    //Activar usuario tipo coordi o encuestador
    public void activarUsuario(int usuarioId) {
        String sql = "UPDATE onu_mujeres.usuarios SET estado = 'activo' WHERE usuario_id = ?";
        // Similar a desactivarUsuario() pero con estado 'activo'
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usuarioId);
            pstmt.executeUpdate();

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public boolean existeDNI(String dni) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE dni = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dni);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private Usuario fetchUsuarioData(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setUsuarioId(rs.getInt("usuario_id"));
        usuario.setNombre(rs.getString("nombre"));
        usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
        usuario.setApellidoMaterno(rs.getString("apellido_materno"));
        usuario.setDni(rs.getString("dni"));
        usuario.setCorreo(rs.getString("correo"));
        usuario.setDireccion(rs.getString("direccion"));
        usuario.setFechaRegistro(rs.getString("fecha_registro"));
        usuario.setEstado(rs.getString("estado"));
        usuario.setUltimaConexion(rs.getString("ultima_conexion"));
        usuario.setProfilePhotoUrl(rs.getString("profile_photo_url"));
        usuario.setCorreoVerificado(rs.getBoolean("correo_verificado"));    //*

        // Zona (usando alias)
        if (rs.getObject("zona_id") != null) {
            Zona zona = new Zona();
            zona.setZonaId(rs.getInt("zona_id"));
            zona.setNombre(rs.getString("zona_nombre")); // Cambiado de "z.nombre"
            usuario.setZona(zona);
        }

        // Rol (usando alias)
        Rol rol = new Rol();
        rol.setRolId(rs.getInt("rol_id"));
        rol.setNombre(rs.getString("rol_nombre")); // Cambiado de "r.nombre"
        usuario.setRol(rol);

        // Distrito (usando alias)
        if (rs.getObject("distrito_id") != null) {
            Distrito distrito = new Distrito();
            distrito.setDistritoId(rs.getInt("distrito_id"));
            distrito.setNombre(rs.getString("distrito_nombre")); // Cambiado de "d.nombre"
            usuario.setDistrito(distrito);
        }

        usuario.setCodigoUnicoEncuestador(rs.getString("codigo_unico_encuestador"));
        return usuario;
    }

    //Setear Coordi para Admin
    private void setCoordinadorData(Usuario usuario, PreparedStatement pstmt) throws SQLException {
        pstmt.setString(2, usuario.getNombre());
        pstmt.setString(6, usuario.getCorreo());

        if (usuario.getRol() == null) {
            pstmt.setNull(1, Types.INTEGER);
        } else {
            pstmt.setInt(1, usuario.getRol().getRolId());
        }
        if (usuario.getApellidoPaterno() == null) {
            pstmt.setNull(3, Types.VARCHAR);
        } else {
            pstmt.setString(3, usuario.getApellidoPaterno());
        }
        if (usuario.getApellidoMaterno() == null) {
            pstmt.setNull(4, Types.VARCHAR);
        } else {
            pstmt.setString(4, usuario.getApellidoMaterno());
        }
        if (usuario.getDni() == null) {
            pstmt.setNull(5, Types.CHAR);
        } else {
            pstmt.setString(5, usuario.getDni());
        }
        if (usuario.getZona() == null) {
            pstmt.setNull(7, Types.INTEGER);
        } else {
            pstmt.setInt(7, usuario.getZona().getZonaId());
        }
        if (usuario.getDistrito() == null) {
            pstmt.setNull(8, Types.INTEGER);
        } else {
            pstmt.setInt(8, usuario.getDistrito().getDistritoId());
        }

        //Ya que admin crea cordi, su correo ya esta verificado
        pstmt.setInt(9,1);

        //foto de Perfil por defecto
        pstmt.setString(10, "perfil.png");
    }

    public DashboardDTO obtenerEstadisticasDashboard(){
        DashboardDTO dashboardDTO = new DashboardDTO();
        String sql = "SELECT\n" +
                "          (SELECT COUNT(*) FROM usuarios where correo_verificado=1 ) AS totalUsuarios,\n" +
                "          (SELECT COUNT(*) FROM usuarios WHERE estado = 'activo' and correo_verificado=1) AS totalActivos,\n" +
                "          (SELECT COUNT(*) FROM usuarios WHERE estado = 'baneado' and correo_verificado=1) AS totalInactivos,\n" +
                "          (SELECT COUNT(*) FROM usuarios WHERE rol_id = 2 and correo_verificado=1) AS totalCoordinadores,\n" +
                "          (SELECT COUNT(*) FROM usuarios WHERE rol_id = 1 and correo_verificado=1) AS totalEncuestadores,\n" +
                "          (SELECT COUNT(*) FROM usuarios WHERE fecha_registro >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND rol_id IN (1, 2) and correo_verificado=1) AS nuevosUltimoMes,\n" +
                "          (SELECT z.nombre FROM zonas z JOIN usuarios u ON z.zona_id = u.zona_id  where u.rol_id<3 and u.correo_verificado=1 GROUP BY z.zona_id ORDER BY COUNT(*) DESC LIMIT 1) AS zonaMasActiva";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                dashboardDTO.setTotalUsuarios(rs.getInt("totalUsuarios"));
                dashboardDTO.setTotalActivos(rs.getInt("totalActivos"));
                dashboardDTO.setTotalInactivos(rs.getInt("totalInactivos"));
                dashboardDTO.setTotalCoordinadores(rs.getInt("totalCoordinadores"));
                dashboardDTO.setTotalEncuestadores(rs.getInt("totalEncuestadores"));
                dashboardDTO.setNuevosUltimoMes(rs.getInt("nuevosUltimoMes"));
                dashboardDTO.setZonaMasActiva(rs.getString("zonaMasActiva"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return dashboardDTO;
    }

    public Map<String, Integer> obtenerUsuariosPorMes() {
        Map<String, Integer> usuariosPorMes = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(fecha_registro, '%m/%Y') AS mes, COUNT(*) AS total " +
                "FROM usuarios " +
                "WHERE fecha_registro >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) and correo_verificado=1 " +
                "GROUP BY mes " +
                "ORDER BY mes";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                usuariosPorMes.put(rs.getString("mes"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuariosPorMes;
    }

    public Map<String, Integer> obtenerDistribucionRoles() {
        Map<String, Integer> distribucionRoles = new HashMap<>();
        String sql = "SELECT r.nombre, COUNT(*) AS total " +
                "FROM usuarios u " +
                "JOIN roles r ON u.rol_id = r.rol_id " +
                "WHERE u.rol_id IN (1, 2) AND u.correo_verificado=1 " +
                "GROUP BY r.nombre";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                distribucionRoles.put(rs.getString("nombre"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distribucionRoles;
    }

    public ArrayList<Usuario> obtenerUsuariosParaReporte(String tipoReporte) {
        ArrayList<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.*, r.nombre AS rol_nombre, z.nombre AS zona_nombre, d.nombre AS distrito_nombre, u.codigo_unico_encuestador " +
                "FROM usuarios u " +
                "JOIN roles r ON u.rol_id = r.rol_id " +
                "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
                "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
                "WHERE u.rol_id IN (1, 2)";

        switch (tipoReporte) {
            case "activos":
                sql += " AND u.estado = 'activo'";
                break;
            case "inactivos":
                sql += " AND u.estado = 'baneado'";
                break;
            case "coordinadores":
                sql += " AND u.rol_id = 2"; // ID de coordinador
                break;
            case "encuestadores":
                sql += " AND u.rol_id = 1"; // ID de encuestador
                break;
        }

        sql += " ORDER BY u.fecha_registro DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setUsuarioId(rs.getInt("usuario_id"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
                usuario.setApellidoMaterno(rs.getString("apellido_materno"));
                usuario.setDni(rs.getString("dni"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setEstado(rs.getString("estado"));
                usuario.setFechaRegistro(rs.getString("fecha_registro"));
                usuario.setCodigoUnicoEncuestador(rs.getString("codigo_unico_encuestador"));

                Rol rol = new Rol();
                rol.setNombre(rs.getString("rol_nombre"));
                usuario.setRol(rol);

                if (rs.getString("zona_nombre") != null) {
                    Zona zona = new Zona();
                    zona.setNombre(rs.getString("zona_nombre"));
                    usuario.setZona(zona);
                }

                if (rs.getString("distrito_nombre") != null) {
                    Distrito distrito = new Distrito();
                    distrito.setNombre(rs.getString("distrito_nombre"));
                    usuario.setDistrito(distrito);
                }

                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuarios;
    }
    public boolean crearUsuario1(Usuario usuario) {
        String sql = "INSERT INTO usuarios (rol_id, nombre, apellido_paterno, apellido_materno, " +
                "dni, correo, direccion, distrito_id, zona_id,profile_photo_url) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Setear parámetros
            pstmt.setInt(1, usuario.getRol().getRolId());
            pstmt.setString(2, usuario.getNombre());
            pstmt.setString(3, usuario.getApellidoPaterno());
            pstmt.setString(4, usuario.getApellidoMaterno());
            pstmt.setString(5, usuario.getDni());
            pstmt.setString(6, usuario.getCorreo());

            pstmt.setString(7, "");
            pstmt.setString(10,"perfil.png");
            pstmt.setInt(8, usuario.getDistrito().getDistritoId());
            pstmt.setInt(9, usuario.getZona().getZonaId());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }

            // Obtener el ID generado
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    usuario.setUsuarioId(generatedKeys.getInt(1));
                }
            }

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public ArrayList<Usuario> listarUsuariosFiltrados(String filtroRol, String filtroEstado, String filtroBusqueda, int pagina, int registrosPorPagina) {
        ArrayList<Usuario> listaUsuarios = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT u.*, r.nombre AS rol_nombre, z.nombre AS zona_nombre, d.nombre AS distrito_nombre " +
                        "FROM usuarios u " +
                        "JOIN roles r ON u.rol_id = r.rol_id " +
                        "LEFT JOIN zonas z ON u.zona_id = z.zona_id " +
                        "LEFT JOIN distritos d ON u.distrito_id = d.distrito_id " +
                        "WHERE u.rol_id IN (1, 2)"
        );

        List<Object> parametros = new ArrayList<>();

        // Filtro por rol
        if (filtroRol != null && !filtroRol.isEmpty()) {
            sql.append(" AND u.rol_id = ?");
            parametros.add(Integer.parseInt(filtroRol));
        }

        // Filtro por estado
        if (filtroEstado != null && !filtroEstado.isEmpty()) {
            if (filtroEstado.equals("inactivo")) {
                sql.append(" AND u.estado = 'baneado'");
            } else {
                sql.append(" AND u.estado = ?");
                parametros.add(filtroEstado);
            }
        }

        // Filtro por búsqueda
        if (filtroBusqueda != null && !filtroBusqueda.isEmpty()) {
            sql.append(" AND (u.nombre LIKE ? OR u.apellido_paterno LIKE ? OR u.dni LIKE ? OR u.correo LIKE ?)");
            String likeParam = "%" + filtroBusqueda + "%";
            parametros.add(likeParam);
            parametros.add(likeParam);
            parametros.add(likeParam);
            parametros.add(likeParam);
        }

        // Ordenación y paginación
        sql.append(" ORDER BY u.fecha_registro DESC");
        sql.append(" LIMIT ?, ?");
        parametros.add((pagina - 1) * registrosPorPagina);
        parametros.add(registrosPorPagina);

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            // Asignar parámetros
            for (int i = 0; i < parametros.size(); i++) {
                pstmt.setObject(i + 1, parametros.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = fetchUsuarioData(rs);
                    listaUsuarios.add(usuario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaUsuarios;
    }
    public int contarUsuariosFiltrados(String filtroRol, String filtroEstado, String filtroBusqueda) {
        int total = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM usuarios u WHERE u.rol_id IN (1, 2)");

        List<Object> parametros = new ArrayList<>();

        // Filtro por rol
        if (filtroRol != null && !filtroRol.isEmpty()) {
            sql.append(" AND u.rol_id = ?");
            parametros.add(Integer.parseInt(filtroRol));
        }

        // Filtro por estado
        if (filtroEstado != null && !filtroEstado.isEmpty()) {
            if (filtroEstado.equals("inactivo")) {
                sql.append(" AND u.estado = 'baneado'");
            } else {
                sql.append(" AND u.estado = ?");
                parametros.add(filtroEstado);
            }
        }

        // Filtro por búsqueda
        if (filtroBusqueda != null && !filtroBusqueda.isEmpty()) {
            sql.append(" AND (u.nombre LIKE ? OR u.apellido_paterno LIKE ? OR u.dni LIKE ? OR u.correo LIKE ?)");
            String likeParam = "%" + filtroBusqueda + "%";
            parametros.add(likeParam);
            parametros.add(likeParam);
            parametros.add(likeParam);
            parametros.add(likeParam);
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parametros.size(); i++) {
                pstmt.setObject(i + 1, parametros.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
}