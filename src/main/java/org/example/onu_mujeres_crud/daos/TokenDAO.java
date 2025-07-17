package org.example.onu_mujeres_crud.daos;


import org.example.onu_mujeres_crud.RandomTokenGenerator;
import org.example.onu_mujeres_crud.beans.Rol;

import org.example.onu_mujeres_crud.beans.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


public class TokenDAO extends BaseDAO {
    public String generateToken(String correo){

        Usuario usuario = userTokenByEmail(correo);
        String token = RandomTokenGenerator.generator();

        String idUsuario = String.valueOf(usuario.getUsuarioId());
        LocalDateTime expiration = LocalDateTime.now().plusHours(24);//24 horas de validez
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String expirationDate = expiration.format(formatter);

        String sql = "INSERT INTO `onu_mujeres`.`token_generado` (`usuario_id`, `token`,`fecha_expiracion`) VALUES (?, ?,?);";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, idUsuario);
            pstmt.setString(2, token);
            pstmt.setString(3, expirationDate);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return token;
    }





    public Usuario userTokenByEmail(String correo){

        Usuario usuario = null;
        System.out.println(correo);
        String sql = "SELECT * FROM usuarios U inner join roles r on U.rol_id=r.rol_id WHERE correo = ?;";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, correo);
            try(ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    usuario = new Usuario();

                    usuario.setUsuarioId(rs.getInt(1));
                    Rol rol = new Rol();
                    rol.setRolId(rs.getInt(2));
                    rol.setNombre(rs.getString("r.nombre"));
                    usuario.setRol(rol);

                    usuario.setEstado(rs.getString(13));
                    usuario.setNombre(rs.getString(3));
                    usuario.setApellidoPaterno(rs.getString(4));
                    usuario.setApellidoMaterno(rs.getString(5));
                    usuario.setDni(rs.getString(6));
                    usuario.setCorreo(rs.getString(7));

                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return usuario;
    }
    public void deleteTokensForEmail(String correo) {
        // Primero obtener el ID de usuario asociado al email
        Usuario usuario = userTokenByEmail(correo);
        if (usuario == null) return;

        String sql = "DELETE FROM `onu_mujeres`.`token_generado` WHERE (`usuario_id` = ?);";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usuario.getUsuarioId());
            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public Usuario UserTokenById(String id){

        Usuario usuario = null;

        String sql = "SELECT * FROM onu_mujeres.usuarios WHERE usuario_id = ?;";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, id);
            try(ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    usuario = new Usuario();

                    usuario.setUsuarioId(rs.getInt(1));

                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return usuario;
    }


    public boolean findToken(String enteredToken){

        String token = null;

        String sql = "SELECT token FROM onu_mujeres.token_generado WHERE token = ? AND fecha_expiracion > NOW();";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, enteredToken);
            try(ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    token = rs.getString(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return (token!=null);
    }





    public String getUserByToken(String token){

        String idUsuario = null;

        String sql = "SELECT usuario_id FROM onu_mujeres.token_generado WHERE token = ?;";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, token);
            try(ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    idUsuario = rs.getString(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return idUsuario;
    }



    public void deleteToken(String tokenExpired){

        String sql = "DELETE FROM `onu_mujeres`.`token_generado` WHERE (`token` = ?);";

        try(Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1,tokenExpired);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean hasActiveTokenForUser(String userId) {
        String sql = "SELECT COUNT(*) FROM token_generado WHERE usuario_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    public String getEmailByToken(String token) {
        String email = null;
        String sql = "SELECT u.correo FROM token_generado tg " +
                "JOIN usuarios u ON tg.usuario_id = u.usuario_id " +
                "WHERE tg.token = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, token);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    email = rs.getString("correo");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener email por token", e);
        }

        return email;
    }
}
