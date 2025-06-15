package org.example.onu_mujeres_crud.beans;

public class EncuestaAsignada {
    private int asignacionId;
    private Encuesta encuesta;
    private Usuario encuestador;
    private Usuario coordinador;
    private String estado; // ENUM('asignada', 'en_progreso', 'completada', 'cancelada')
    private String fechaAsignacion;
    private String fechaCompletado;

    public int getAsignacionId() {
        return asignacionId;
    }

    public void setAsignacionId(int asignacionId) {
        this.asignacionId = asignacionId;
    }

    public Encuesta getEncuesta() {
        return encuesta;
    }

    public void setEncuesta(Encuesta encuesta) {
        this.encuesta = encuesta;
    }

    public Usuario getEncuestador() {
        return encuestador;
    }

    public void setEncuestador(Usuario encuestador) {
        this.encuestador = encuestador;
    }

    public Usuario getCoordinador() {
        return coordinador;
    }

    public void setCoordinador(Usuario coordinador) {
        this.coordinador = coordinador;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getFechaAsignacion() {
        return fechaAsignacion;
    }

    public void setFechaAsignacion(String fechaAsignacion) {
        this.fechaAsignacion = fechaAsignacion;
    }

    public String getFechaCompletado() {
        return fechaCompletado;
    }

    public void setFechaCompletado(String fechaCompletado) {
        this.fechaCompletado = fechaCompletado;
    }
}