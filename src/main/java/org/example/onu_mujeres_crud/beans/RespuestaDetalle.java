package org.example.onu_mujeres_crud.beans;

public class RespuestaDetalle {
    private int detalleId;
    private Respuesta respuesta;
    private BancoPreguntas pregunta;
    private PreguntaOpcion opcion;
    private String respuestaTexto;
    private String fechaContestacion;

    public int getDetalleId() {
        return detalleId;
    }

    public void setDetalleId(int detalleId) {
        this.detalleId = detalleId;
    }

    public Respuesta getRespuesta() {
        return respuesta;
    }

    public void setRespuesta(Respuesta respuesta) {
        this.respuesta = respuesta;
    }

    public BancoPreguntas getPregunta() {
        return pregunta;
    }

    public void setPregunta(BancoPreguntas pregunta) {
        this.pregunta = pregunta;
    }

    public PreguntaOpcion getOpcion() {
        return opcion;
    }

    public void setOpcion(PreguntaOpcion opcion) {
        this.opcion = opcion;
    }

    public String getRespuestaTexto() {
        return respuestaTexto;
    }

    public void setRespuestaTexto(String respuestaTexto) {
        this.respuestaTexto = respuestaTexto;
    }

    public String getFechaContestacion() {
        return fechaContestacion;
    }

    public void setFechaContestacion(String fechaContestacion) {
        this.fechaContestacion = fechaContestacion;
    }
}