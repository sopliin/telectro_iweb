package org.example.onu_mujeres_crud.dtos;

public class EstadisticasEncuestadorDTO {
    private String nombreEncuestador;
    private int cantidadRespuestas;
    private int completadas;
    private int enProgreso;

    public String getNombreEncuestador() {
        return nombreEncuestador;
    }

    public void setNombreEncuestador(String nombreEncuestador) {
        this.nombreEncuestador = nombreEncuestador;
    }

    public int getCantidadRespuestas() {
        return cantidadRespuestas;
    }

    public void setCantidadRespuestas(int cantidadRespuestas) {
        this.cantidadRespuestas = cantidadRespuestas;
    }

    public int getCompletadas() {
        return completadas;
    }

    public void setCompletadas(int completadas) {
        this.completadas = completadas;
    }

    public int getEnProgreso() {
        return enProgreso;
    }

    public void setEnProgreso(int enProgreso) {
        this.enProgreso = enProgreso;
    }
}
