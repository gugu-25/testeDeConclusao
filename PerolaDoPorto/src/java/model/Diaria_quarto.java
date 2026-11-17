package model;

import java.util.ArrayList;

public class Diaria_quarto {
    
    private Diaria diaria;
    private Quarto quarto;
    private double valorAtual;
    private ArrayList<Diaria_quarto> quartosVinculados;
    private ArrayList<Quarto> quartosNaoVinculados;

    public Diaria_quarto() {
    }

    public Diaria_quarto(Diaria diaria, Quarto quarto, double valorAtual, ArrayList<Diaria_quarto> quartosVinculados, ArrayList<Quarto> quartosNaoVinculados) {
        this.diaria = diaria;
        this.quarto = quarto;
        this.valorAtual = valorAtual;
        this.quartosVinculados = quartosVinculados;
        this.quartosNaoVinculados = quartosNaoVinculados;
    }
    
    public Diaria getDiaria() {
        return diaria;
    }

    public void setDiaria(Diaria diaria) {
        this.diaria = diaria;
    }

    public Quarto getQuarto() {
        return quarto;
    }

    public void setQuarto(Quarto quarto) {
        this.quarto = quarto;
    }

    public double getValorAtual() {
        return valorAtual;
    }

    public void setValorAtual(double valorAtual) {
        this.valorAtual = valorAtual;
    }

    public ArrayList<Diaria_quarto> getQuartosVinculados() {
        return quartosVinculados;
    }

    public void setQuartosVinculados(ArrayList<Diaria_quarto> quartosVinculados) {
        this.quartosVinculados = quartosVinculados;
    }

    public ArrayList<Quarto> getQuartosNaoVinculados() {
        return quartosNaoVinculados;
    }

    public void setQuartosNaoVinculados(ArrayList<Quarto> quartosNaoVinculados) {
        this.quartosNaoVinculados = quartosNaoVinculados;
    }
    
    @Override
    public String toString() {
        return "Diaria_quarto{" + "diaria=" + diaria + ", quarto=" + quarto + ", valorAtual=" + valorAtual + '}';
    }
}