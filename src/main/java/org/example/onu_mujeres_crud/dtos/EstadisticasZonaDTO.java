package org.example.onu_mujeres_crud.dtos;

public class EstadisticasZonaDTO {
    private String nombreZona;
    private String nombreDistrito;
    private int totalRespuestas;
    private int completadas;
    private int pendientes;

    public String getNombreZona() {
        return nombreZona;
    }

    public void setNombreZona(String nombreZona) {
        this.nombreZona = nombreZona;
    }

    public String getNombreDistrito() {
        return nombreDistrito;
    }

    public void setNombreDistrito(String nombreDistrito) {
        this.nombreDistrito = nombreDistrito;
    }

    public int getTotalRespuestas() {
        return totalRespuestas;
    }

    public void setTotalRespuestas(int totalRespuestas) {
        this.totalRespuestas = totalRespuestas;
    }

    public int getCompletadas() {
        return completadas;
    }

    public void setCompletadas(int completadas) {
        this.completadas = completadas;
    }

    public int getPendientes() {
        return pendientes;
    }

    public void setPendientes(int pendientes) {
        this.pendientes = pendientes;
    }
}
