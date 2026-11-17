package model;

import java.util.ArrayList;
import java.util.Date;

public class Diaria {

    private int idDiaria;
    private double valorDiaria;
    private String descricao;
    private int statusHospedagem;
    private double valorTotal;
    private int statusPagamento;
    private Date feitoEm;
    private Date pagoEm;
    private Usuario usuario;
    private Cliente cliente;
    private Pendencias pendencias;
    private ArrayList<DiariaQuarto> carrinhoQuarto;

    public Diaria() {
    }

    public Diaria(int idDiaria, double valorDiaria, String descricao, int statusHospedagem, double valorTotal, int statusPagamento, Date feitoEm, Date pagoEm, Usuario usuario, Cliente cliente, Pendencias pendencias, ArrayList<DiariaQuarto> carrinhoQuarto) {
        this.idDiaria = idDiaria;
        this.valorDiaria = valorDiaria;
        this.descricao = descricao;
        this.statusHospedagem = statusHospedagem;
        this.valorTotal = valorTotal;
        this.statusPagamento = statusPagamento;
        this.feitoEm = feitoEm;
        this.pagoEm = pagoEm;
        this.usuario = usuario;
        this.cliente = cliente;
        this.pendencias = pendencias;
        this.carrinhoQuarto = carrinhoQuarto;
    }

    public int getIdDiaria() {
        return idDiaria;
    }

    public void setIdDiaria(int idDiaria) {
        this.idDiaria = idDiaria;
    }

    public double getValorDiaria() {
        return valorDiaria;
    }

    public void setValorDiaria(double valorDiaria) {
        this.valorDiaria = valorDiaria;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public int getStatusHospedagem() {
        return statusHospedagem;
    }

    public void setStatusHospedagem(int statusHospedagem) {
        this.statusHospedagem = statusHospedagem;
    }

    public double getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(double valorTotal) {
        this.valorTotal = valorTotal;
    }

    public int getStatusPagamento() {
        return statusPagamento;
    }

    public void setStatusPagamento(int statusPagamento) {
        this.statusPagamento = statusPagamento;
    }

    public Date getFeitoEm() {
        return feitoEm;
    }

    public void setFeitoEm(Date feitoEm) {
        this.feitoEm = feitoEm;
    }

    public Date getPagoEm() {
        return pagoEm;
    }

    public void setPagoEm(Date pagoEm) {
        this.pagoEm = pagoEm;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public Pendencias getPendencias() {
        return pendencias;
    }

    public void setPendencias(Pendencias pendencias) {
        this.pendencias = pendencias;
    }

    public ArrayList<DiariaQuarto> getCarrinhoQuarto() {
        return carrinhoQuarto;
    }

    public void setCarrinhoQuarto(ArrayList<DiariaQuarto> carrinhoQuarto) {
        this.carrinhoQuarto = carrinhoQuarto;
    }

    @Override
    public String toString() {
        return "Diaria{" + "idDiaria=" + idDiaria + '}';
    }
}