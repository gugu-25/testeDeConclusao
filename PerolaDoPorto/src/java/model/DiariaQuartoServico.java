package model;

import java.util.ArrayList;

public class DiariaQuartoServico {
    
    private DiariaQuarto diariaQuarto;
    private Servico servico;
    private double valorServicoAtual;
    private ArrayList<DiariaQuartoServico> servicosVinculados;
    private ArrayList<Servico> servicosNaoVinculados;

    public DiariaQuartoServico() {
    }

    public DiariaQuartoServico(DiariaQuarto diariaQuarto, Servico servico, double valorServicoAtual, ArrayList<DiariaQuartoServico> servicosVinculados, ArrayList<Servico> servicosNaoVinculados) {
        this.diariaQuarto = diariaQuarto;
        this.servico = servico;
        this.valorServicoAtual = valorServicoAtual;
        this.servicosVinculados = servicosVinculados;
        this.servicosNaoVinculados = servicosNaoVinculados;
    }

    public DiariaQuarto getDiariaQuarto() {
        return diariaQuarto;
    }

    public void setDiariaQuarto(DiariaQuarto diariaQuarto) {
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

    public ArrayList<DiariaQuartoServico> getServicosVinculados() {
        return servicosVinculados;
    }

    public void setServicosVinculados(ArrayList<DiariaQuartoServico> servicosVinculados) {
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