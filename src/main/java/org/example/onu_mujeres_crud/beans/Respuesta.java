package org.example.onu_mujeres_crud.beans;

public class Respuesta {
    private int respuestaId;
    private String dniEncuestado;
    private EncuestaAsignada asignacion;
    private String fechaInicio;
    private String fechaEnvio;

    public int getRespuestaId() {
        return respuestaId;
    }

    public void setRespuestaId(int respuestaId) {
        this.respuestaId = respuestaId;
    }

    public String getDniEncuestado() {
        return dniEncuestado;
    }

    public void setDniEncuestado(String dniEncuestado) {
        this.dniEncuestado = dniEncuestado;
    }

    public EncuestaAsignada getAsignacion() {
        return asignacion;
    }

    public void setAsignacion(EncuestaAsignada asignacion) {
        this.asignacion = asignacion;
    }

    public String getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(String fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public String getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(String fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }
}