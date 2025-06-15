package org.example.onu_mujeres_crud.beans;

public class Distrito {
    private int distritoId;
    private String nombre;
    private Zona zona;

    public int getDistritoId() {
        return distritoId;
    }

    public void setDistritoId(int distritoId) {
        this.distritoId = distritoId;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Zona getZona() {
        return zona;
    }

    public void setZona(Zona zona) {
        this.zona = zona;
    }
}