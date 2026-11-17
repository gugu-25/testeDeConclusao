package model;

public class Quarto {
    
    private int idQuarto;
    private int numero;
    private int tipo;
    private String descricao;
    private double valor;
    private int status;

    public Quarto() {
    }

    public Quarto(int idQuarto, int numero, int tipo, String descricao, double valor, int status) {
        this.idQuarto = idQuarto;
        this.numero = numero;
        this.tipo = tipo;
        this.descricao = descricao;
        this.valor = valor;
        this.status = status;
    }

    public int getIdQuarto() {
        return idQuarto;
    }

    public void setIdQuarto(int idQuarto) {
        this.idQuarto = idQuarto;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public int getTipo() {
        return tipo;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Quarto{" + "numero=" + numero + ", tipo=" + tipo + '}';
    }
    
}