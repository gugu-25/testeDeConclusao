package model;

public class Servico {
    
    private int idServico;
    private String nome;
    private double valor;
    private int status;

    public Servico() {
    }

    public Servico(int idServico, String nome, double valor, int status) {
        this.idServico = idServico;
        this.nome = nome;
        this.valor = valor;
        this.status = status;
    }

    public int getIdServico() {
        return idServico;
    }

    public void setIdServico(int idServico) {
        this.idServico = idServico;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
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
        return "Servico{" + "nome=" + nome + ", valor=" + valor + '}';
    }
    
}
