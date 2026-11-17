package model;

import java.util.ArrayList;

public class Diaria_quarto_servico {
    
    private Diaria_quarto diariaQuarto;
    private Servico servico;
    private double valorServicoAtual;
    private ArrayList<Diaria_quarto_servico> servicosVinculados;
    private ArrayList<Servico> servicosNaoVinculados;

    public Diaria_quarto_servico() {
    }

    public Diaria_quarto_servico(Diaria_quarto diariaQuarto, Servico servico, double valorServicoAtual, ArrayList<Diaria_quarto_servico> servicosVinculados, ArrayList<Servico> servicosNaoVinculados) {
        this.diariaQuarto = diariaQuarto;
        this.servico = servico;
        this.valorServicoAtual = valorServicoAtual;
        this.servicosVinculados = servicosVinculados;
        this.servicosNaoVinculados = servicosNaoVinculados;
    }

    public Diaria_quarto getDiariaQuarto() {
        return diariaQuarto;
    }

    public void setDiariaQuarto(Diaria_quarto diariaQuarto) {
        this.diariaQuarto = diariaQuarto;
    }

    public Servico getServico() {
        return servico;
    }

    public void setServico(Servico servico) {
        this.servico = servico;
    }

    public double getValorServicoAtual() {
        return valorServicoAtual;
    }

    public void setValorServicoAtual(double valorServicoAtual) {
        this.valorServicoAtual = valorServicoAtual;
    }

    public ArrayList<Diaria_quarto_servico> getServicosVinculados() {
        return servicosVinculados;
    }

    public void setServicosVinculados(ArrayList<Diaria_quarto_servico> servicosVinculados) {
        this.servicosVinculados = servicosVinculados;
    }

    public ArrayList<Servico> getServicosNaoVinculados() {
        return servicosNaoVinculados;
    }

    public void setServicosNaoVinculados(ArrayList<Servico> servicosNaoVinculados) {
        this.servicosNaoVinculados = servicosNaoVinculados;
    }

    @Override
    public String toString() {
        return "Diaria_quarto_servico{" + "diariaQuarto=" + diariaQuarto + ", servico=" + servico + ", valorServicoAtual=" + valorServicoAtual + '}';
    }
    
}