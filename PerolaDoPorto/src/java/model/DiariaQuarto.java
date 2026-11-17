package model;

import java.util.ArrayList;
import java.util.Date;

public class DiariaQuarto {

    private Diaria diaria;
    private Quarto quarto;
    private double valorAtual;
    private Date checkIn;
    private Date checkOut;
    private ArrayList<DiariaQuarto> quartosVinculados;
    private ArrayList<Quarto> quartosNaoVinculados;

    public DiariaQuarto() {
    }

    public DiariaQuarto(Diaria diaria, Quarto quarto, double valorAtual, Date checkIn, Date checkOut, ArrayList<DiariaQuarto> quartosVinculados, ArrayList<Quarto> quartosNaoVinculados) {
        this.diaria = diaria;
        this.quarto = quarto;
        this.valorAtual = valorAtual;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
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

    public Date getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Date checkIn) {
        this.checkIn = checkIn;
    }

    public Date getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(Date checkOut) {
        this.checkOut = checkOut;
    }

    public ArrayList<DiariaQuarto> getQuartosVinculados() {
        return quartosVinculados;
    }

    public void setQuartosVinculados(ArrayList<DiariaQuarto> quartosVinculados) {
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
        return "DiariaQuarto{" + "diaria=" + diaria + ", quarto=" + quarto + ", valorAtual=" + valorAtual + '}';
    }
}