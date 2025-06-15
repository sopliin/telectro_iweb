package org.example.onu_mujeres_crud.beans;

public class LogActividad {
    private int logId;
    private Usuario usuario;
    private String accion;
    private String entidad;
    private String detalle;
    private String fechaLog;

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public String getAccion() {
        return accion;
    }

    public void setAccion(String accion) {
        this.accion = accion;
    }

    public String getEntidad() {
        return entidad;
    }

    public void setEntidad(String entidad) {
        this.entidad = entidad;
    }

    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }

    public String getFechaLog() {
        return fechaLog;
    }

    public void setFechaLog(String fechaLog) {
        this.fechaLog = fechaLog;
    }
}