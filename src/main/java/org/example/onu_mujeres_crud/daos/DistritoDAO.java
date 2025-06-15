package org.example.onu_mujeres_crud.daos;

import org.example.onu_mujeres_crud.beans.Distrito;
import org.example.onu_mujeres_crud.beans.Usuario;
import org.example.onu_mujeres_crud.beans.Zona;

import java.sql.*;
import java.util.ArrayList;

public class DistritoDAO extends BaseDAO{

    public ArrayList<Distrito> obtenerListaDistritos() {
        ArrayList<Distrito> listaDistritos = new ArrayList<>();
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM onu_mujeres.distritos")){

            while (rs.next()) {
                Distrito distrito = new Distrito();
                distrito.setDistritoId(rs.getInt(1));
                distrito.setNombre(rs.getString(2));
                Zona zona = new Zona();
                zona.setZonaId(rs.getInt(3));
                distrito.setZona(zona);

                listaDistritos.add(distrito);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaDistritos;
    }
    //ever
    public String  obtenerNombreDistrito(int distritoId) {
        String distrito = "";
        String sql = "SELECT nombre FROM distritos where distrito_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, distritoId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    distrito = rs.getString(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return distrito;
    }
    public ArrayList<Distrito> obtenerListaDistritosxZona(int zonaId) {
        ArrayList<Distrito> listaDistritos = new ArrayList<>();
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM onu_mujeres.distritos where zona_id = " + zonaId)){

            while (rs.next()) {
                Distrito distrito = new Distrito();
                distrito.setDistritoId(rs.getInt(1));
                distrito.setNombre(rs.getString(2));
                Zona zona = new Zona();
                zona.setZonaId(rs.getInt(3));
                distrito.setZona(zona);

                listaDistritos.add(distrito);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaDistritos;
    }
    public ArrayList<Distrito> obtenerListaDistritos2() {
        ArrayList<Distrito> listaDistritos = new ArrayList<>();
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM onu_mujeres.distritos join zonas on zonas.zona_id=distritos.zona_id;")){

            while (rs.next()) {
                Distrito distrito = new Distrito();
                distrito.setDistritoId(rs.getInt(1));
                distrito.setNombre(rs.getString(2));
                Zona zona = new Zona();
                zona.setZonaId(rs.getInt(3));
                zona.setNombre(rs.getString(5));
                distrito.setZona(zona);

                listaDistritos.add(distrito);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaDistritos;
    }

}
