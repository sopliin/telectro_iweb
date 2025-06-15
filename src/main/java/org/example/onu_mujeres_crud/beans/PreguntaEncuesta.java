package org.example.onu_mujeres_crud.beans;

public class PreguntaEncuesta {
    private Encuesta encuesta;
    private BancoPreguntas pregunta;

    public Encuesta getEncuesta() {
        return encuesta;
    }

    public void setEncuesta(Encuesta encuesta) {
        this.encuesta = encuesta;
    }

    public BancoPreguntas getPregunta() {
        return pregunta;
    }

    public void setPregunta(BancoPreguntas pregunta) {
        this.pregunta = pregunta;
    }
}