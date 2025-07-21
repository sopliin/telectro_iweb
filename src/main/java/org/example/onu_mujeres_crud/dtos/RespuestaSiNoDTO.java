package org.example.onu_mujeres_crud.dtos;

public class RespuestaSiNoDTO {
    private String respuesta;     // "Sí" o "No"
    private int cantidad;         // total de respuestas con esa opción


    public RespuestaSiNoDTO() {}

    public RespuestaSiNoDTO(String respuesta, int cantidad, int completadas) {
        this.respuesta = respuesta;
        this.cantidad = cantidad;

    }

    public String getRespuesta() {
        return respuesta;
    }

    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }


}

