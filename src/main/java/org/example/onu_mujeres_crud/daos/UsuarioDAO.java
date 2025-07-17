package org.example.onu_mujeres_crud.daos;
import org.example.onu_mujeres_crud.SHA256;
import org.example.onu_mujeres_crud.beans.*;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class UsuarioDAO extends BaseDAO{

    //Para admin, listar todos los usuarios
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
                listaUsuarios.add(usuario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaUsuarios;
    }

    public Usuario obtenerUsuario(int usuarioId) {
        Usuario usuario = null;
        String sql = "SELECT * FROM onu_mujeres.usuarios u\n" +
                "LEFT JOIN onu_mujeres.roles r ON u.rol_id = r.rol_id\n" +
                "LEFT JOIN onu_mujeres.distritos d ON u.distrito_id = d.distrito_id\n" +
                "LEFT JOIN onu_mujeres.zonas z ON u.zona_id = z.zona_id\n" +
                "WHERE u.rol_id = ?";

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
        String sql = "INSERT INTO onu_mujeres.usuarios (rol_id, nombre, apellido_paterno, apellido_materno, dni, correo, zona_id)\n"
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

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

        String sql = "UPDATE onu_mujeres.usuarios SET estado = 'inactivo' WHERE usuario_id = ?";

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
        usuario.setUsuarioId(rs.getInt("u.usuario_id"));
        usuario.setNombre(rs.getString("u.nombre"));
        usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
        usuario.setApellidoMaterno(rs.getString("apellido_materno"));
        usuario.setDni(rs.getString("dni"));
        usuario.setCorreo(rs.getString("correo"));
        usuario.setDireccion(rs.getString("direccion"));
        usuario.setFechaRegistro(rs.getString("fecha_registro"));
        usuario.setEstado(rs.getString("estado"));

        Zona zona = new Zona();
        zona.setNombre(rs.getString("z.nombre"));
        usuario.setZona(zona);

        Rol rol = new Rol();
        rol.setNombre(rs.getString("r.nombre"));
        usuario.setRol(rol);

        Distrito distrito = new Distrito();
        distrito.setNombre(rs.getString("d.nombre"));
        usuario.setDistrito(distrito);

        //Si el atributo no es nulo:
        if(rs.getString("codigo_unico_encuestador") != null){
            //Es encuestador
            usuario.setCodigoUnicoEncuestador(rs.getString("codigo_unico_encuestador"));
        }
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
    }
//EVER codigos nuevos

    public boolean login(String mail, String passwd){

        boolean valido = false;
        passwd = SHA256.cipherPassword(passwd);
        System.out.println(mail);
        System.out.println(passwd);

        String sql = "SELECT u.correo, u.contrasena_hash FROM usuarios u WHERE u.correo = ? AND u.contrasena_hash = ? AND u.estado = 'activo' AND u.correo_verificado = '1';";


        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, mail);
            pstmt.setString(2, passwd);
            System.out.println("holi");
            try(ResultSet rs = pstmt.executeQuery()){

                while(rs.next()){
                    String mailDB = rs.getString(1);
                    String passwdDB = rs.getString(2);
                    System.out.println(mailDB);
                    System.out.println(passwdDB);

                    if (mailDB == null || passwdDB == null){
                        valido = false;
                    } else if (mailDB.equals(mail) && passwdDB.equals(passwd)){
                        valido = true;
                    }
                }

            }
        }catch (SQLException e){
            throw new RuntimeException(e);
        }
        return valido;
    }

    public Usuario usuarioByEmailNoVer(String correo){

        Usuario usuario = null;
        //Conexión a la DB
        String sql = "select * from usuarios  where correo = ? and estado = 'activo' and correo_verificado='0';";


        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, correo);


            try(ResultSet rs = pstmt.executeQuery()){

                while(rs.next()){

                    usuario = new Usuario();
                    usuario.setUsuarioId(rs.getInt(1));
                    usuario.setEstado(rs.getString("estado"));
                    usuario.setCorreoVerificado(rs.getBoolean("correo_verificado"));

                }

            }
        }catch (SQLException e){
            throw new RuntimeException(e);
        }

        return usuario;
    }

    public Usuario usuarioByEmail(String correo){

        Usuario usuario = null;
        //Conexión a la DB
        String sql = "select * from usuarios  where correo = ? and estado = 'activo' and correo_verificado='1';";


        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, correo);


            try(ResultSet rs = pstmt.executeQuery()){

                while(rs.next()){

                    usuario = new Usuario();
                    usuario.setUsuarioId(rs.getInt(1));
                    usuario.setEstado(rs.getString("estado"));
                    usuario.setCorreoVerificado(rs.getBoolean("correo_verificado"));
                    usuario.setCorreo(rs.getString("correo"));
                    Rol rol = new Rol();
                    rol.setRolId(rs.getInt(2));
                    usuario.setRol(rol);
                }

            }
        }catch (SQLException e){
            throw new RuntimeException(e);
        }

        return usuario;
    }

    public String verificarCorreo(String email){

        String correo = null;

        String sql = "SELECT correo FROM usuarios where correo = ?;";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1,email);

            try(ResultSet rs = pstmt.executeQuery()){

                while (rs.next()){
                    correo = rs.getString(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return correo;
    }


    public String verificarDni(String dni){

        String code = null;

        String sql = "SELECT dni FROM usuarios where dni = ?;";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1,dni);

            try(ResultSet rs = pstmt.executeQuery()){

                while (rs.next()){
                    code = rs.getString(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return code;
    }
    public boolean crearUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuarios (rol_id, nombre, apellido_paterno, apellido_materno, " +
                "dni, correo, contrasena_hash, direccion, distrito_id, zona_id, " +
                "codigo_unico_encuestador, estado, correo_verificado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Setear parámetros
            pstmt.setInt(1, usuario.getRol().getRolId());
            pstmt.setString(2, usuario.getNombre());
            pstmt.setString(3, usuario.getApellidoPaterno());
            pstmt.setString(4, usuario.getApellidoMaterno());
            pstmt.setString(5, usuario.getDni());
            pstmt.setString(6, usuario.getCorreo());
            pstmt.setString(7, usuario.getContrasenaHash());
            pstmt.setString(8, usuario.getDireccion());

            if (usuario.getDistrito() != null) {
                pstmt.setInt(9, usuario.getDistrito().getDistritoId());

                // Obtener zona_id del distrito
                String sqlZona = "SELECT zona_id FROM distritos WHERE distrito_id = ?";
                try (PreparedStatement pstmtZona = conn.prepareStatement(sqlZona)) {
                    pstmtZona.setInt(1, usuario.getDistrito().getDistritoId());
                    try (ResultSet rsZona = pstmtZona.executeQuery()) {
                        if (rsZona.next()) {
                            pstmt.setInt(10, rsZona.getInt("zona_id"));
                        } else {
                            pstmt.setNull(10, Types.INTEGER);
                        }
                    }
                }
            } else {
                pstmt.setNull(9, Types.INTEGER);
                pstmt.setNull(10, Types.INTEGER);
            }

            // Solo para encuestadores
            if (usuario.getRol().getRolId() == 1) { // 1 = encuestador
                String codigoUnico = "ENC-" + new SimpleDateFormat("yyyy").format(new Date()) +
                        "-" + String.format("%03d", obtenerProximoNumeroEncuestador());
                pstmt.setString(11, codigoUnico);
            } else {
                pstmt.setNull(11, Types.VARCHAR);
            }

            pstmt.setString(12, usuario.getEstado() != null ? usuario.getEstado() : "activo");
            pstmt.setBoolean(13, usuario.isCorreoVerificado() != true ? usuario.isCorreoVerificado() : false);

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
    private int obtenerProximoNumeroEncuestador() {
        String sql = "SELECT MAX(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(codigo_unico_encuestador, '-', -1), ' ', -1) AS UNSIGNED)) + 1 AS next_num " +
                "FROM usuarios WHERE codigo_unico_encuestador LIKE 'ENC-%'";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("next_num");
            }
            return 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return 1;
        }
    }

    public void editarPassword(String newpass, int idUsuario){

        newpass = SHA256.cipherPassword(newpass);
        System.out.println("el hasheo de este es "+ newpass);

        String sql = "update usuarios set contrasena_hash = ? where usuario_id = ?";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1,newpass);
            pstmt.setInt(2, idUsuario);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void marcarCorreoComoVerificado(int usuarioId) {
        String sql = "UPDATE usuarios SET correo_verificado = 1,codigo_unico_encuestador=? WHERE usuario_id = ?";
        int anoActual = java.time.Year.now().getValue();
        String codigo="ENC-"+anoActual+"-"+usuarioId;
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, codigo);
            pstmt.setInt(2, usuarioId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public Usuario obtenerUsuario1(int usuarioId) {
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
                    usuario = fetchUsuarioData1(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return usuario;
    }

    private Usuario fetchUsuarioData1(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setUsuarioId(rs.getInt("u.usuario_id"));
        usuario.setNombre(rs.getString("u.nombre"));
        usuario.setApellidoPaterno(rs.getString("apellido_paterno"));
        usuario.setApellidoMaterno(rs.getString("apellido_materno"));
        usuario.setDni(rs.getString("dni"));
        usuario.setCorreo(rs.getString("correo"));
        usuario.setDireccion(rs.getString("direccion"));
        usuario.setFechaRegistro(rs.getString("fecha_registro"));
        usuario.setUltimaConexion(rs.getString("ultima_conexion"));
        usuario.setEstado(rs.getString("estado"));

        Zona zona = new Zona();
        zona.setZonaId(rs.getInt("zona_id"));
        zona.setNombre(rs.getString("z.nombre"));
        usuario.setZona(zona);
        usuario.setProfilePhotoUrl(rs.getString("profile_photo_url"));
        Rol rol = new Rol();
        rol.setRolId(rs.getInt("rol_id"));
        rol.setNombre(rs.getString("r.nombre"));
        usuario.setRol(rol);

        Distrito distrito = new Distrito();
        distrito.setDistritoId(rs.getInt("d.distrito_id"));
        distrito.setNombre(rs.getString("d.nombre"));
        usuario.setDistrito(distrito);

        //Si el atributo no es nulo:
        if(rs.getString("codigo_unico_encuestador") != null){
            //Es encuestador
            usuario.setCodigoUnicoEncuestador(rs.getString("codigo_unico_encuestador"));
        }
        return usuario;
    }

    public Usuario usuarioByEmailNoVer1(String correo) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuarios u " +
                "LEFT JOIN roles r ON u.rol_id = r.rol_id " +
                "WHERE u.correo = ? "; // Eliminado filtro de estado

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, correo);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setUsuarioId(rs.getInt("usuario_id"));
                    usuario.setEstado(rs.getString("estado"));
                    usuario.setCorreoVerificado(rs.getBoolean("correo_verificado"));
                    usuario.setCorreo(rs.getString("correo"));

                    Rol rol = new Rol();
                    rol.setRolId(rs.getInt("rol_id"));
                    usuario.setRol(rol);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return usuario;
    }
    public boolean actualizarPerfil(int usuarioId, String direccion, int distritoId) {
        String sql = "UPDATE usuarios SET direccion = ?, distrito_id = ? WHERE usuario_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, direccion);
            pstmt.setInt(2, distritoId);
            pstmt.setInt(3, usuarioId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public void actualizarFotoPerfil(int idUsuario, String nombreArchivo) {
        String sql = "UPDATE usuarios SET profile_photo_url = ? WHERE usuario_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nombreArchivo);
            stmt.setInt(2, idUsuario);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            // Manejo real con logger o excepciones personalizadas en producción
        }
    }
    public boolean verificarContrasena(int usuarioId, String password) {
        String sql = "SELECT contrasena_hash FROM usuarios WHERE usuario_id = ?";
        password = SHA256.cipherPassword(password);

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usuarioId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("contrasena_hash");
                    return storedHash.equals(password);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean actualizarContrasena(int usuarioId, String newPassword) {
        String sql = "UPDATE usuarios SET contrasena_hash = ? WHERE usuario_id = ?";
        newPassword = SHA256.cipherPassword(newPassword);

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, newPassword);
            pstmt.setInt(2, usuarioId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}