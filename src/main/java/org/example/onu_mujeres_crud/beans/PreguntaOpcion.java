package org.example.onu_mujeres_crud.beans;

public class PreguntaOpcion {
    private int opcionId;
    private BancoPreguntas pregunta;
    private String textoOpcion;
    private int valor;

    public int getOpcionId() {
        return opcionId;
    }

    public void setOpcionId(int opcionId) {
        this.opcionId = opcionId;
    }

    public BancoPreguntas getPregunta() {
        return pregunta;
    }

    public void setPregunta(BancoPreguntas pregunta) {
        this.pregunta = pregunta;
    }

    public String getTextoOpcion() {
        return textoOpcion;
    }

    public void setTextoOpcion(String textoOpcion) {
        this.textoOpcion = textoOpcion;
    }

    public int getValor() {
        return valor;
    }

    public void setValor(int valor) {
        this.valor = valor;
    }

}