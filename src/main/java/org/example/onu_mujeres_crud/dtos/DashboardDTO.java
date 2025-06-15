package org.example.onu_mujeres_crud.dtos;

public class DashboardDTO {
    private int totalUsuarios;
    private int totalActivos;
    private int totalInactivos;
    private int totalCoordinadores;
    private int totalEncuestadores;
    private int nuevosUltimoMes;
    private String zonaMasActiva;
    private int reportesGenerados;

    // Getters y Setters
    public int getTotalUsuarios() {
        return totalUsuarios;
    }

    public void setTotalUsuarios(int totalUsuarios) {
        this.totalUsuarios = totalUsuarios;
    }

    public int getTotalActivos() {
        return totalActivos;
    }

    public void setTotalActivos(int totalActivos) {
        this.totalActivos = totalActivos;
    }

    public int getTotalInactivos() {
        return totalInactivos;
    }

    public void setTotalInactivos(int totalInactivos) {
        this.totalInactivos = totalInactivos;
    }

    public int getTotalCoordinadores() {
        return totalCoordinadores;
    }

    public void setTotalCoordinadores(int totalCoordinadores) {
        this.totalCoordinadores = totalCoordinadores;
    }

    public int getTotalEncuestadores() {
        return totalEncuestadores;
    }

    public void setTotalEncuestadores(int totalEncuestadores) {
        this.totalEncuestadores = totalEncuestadores;
    }

    public int getNuevosUltimoMes() {
        return nuevosUltimoMes;
    }

    public void setNuevosUltimoMes(int nuevosUltimoMes) {
        this.nuevosUltimoMes = nuevosUltimoMes;
    }

    public String getZonaMasActiva() {
        return zonaMasActiva;
    }

    public void setZonaMasActiva(String zonaMasActiva) {
        this.zonaMasActiva = zonaMasActiva;
    }

    public int getReportesGenerados() {
        return reportesGenerados;
    }

    public void setReportesGenerados(int reportesGenerados) {
        this.reportesGenerados = reportesGenerados;
    }
}