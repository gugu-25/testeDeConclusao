package model;

import java.util.Date;

public class Pendencias {

    private int idPendencias;
    private String descricao;
    private double valor;
    private Date dataRegistro;
    private int status;
    
    private DiariaQuartoServico diariaQuartoServico; 

    public Pendencias() {
    }

    public Pendencias(int idPendencias, String descricao, double valor, Date dataRegistro, int status, DiariaQuartoServico diariaQuartoServico) {
        this.idPendencias = idPendencias;
        this.descricao = descricao;
        this.valor = valor;
        this.dataRegistro = dataRegistro;
        this.status = status;
        this.diariaQuartoServico = diariaQuartoServico;
    }

    public int getIdPendencias() {
        return idPendencias;
    }

    public void setIdPendencias(int idPendencias) {
        this.idPendencias = idPendencias;
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

    public Date getDataRegistro() {
        return dataRegistro;
    }

    public void setDataRegistro(Date dataRegistro) {
        this.dataRegistro = dataRegistro;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public DiariaQuartoServico getDiariaQuartoServico() {
        return diariaQuartoServico;
    }

    public void setDiariaQuartoServico(DiariaQuartoServico diariaQuartoServico) {
        this.diariaQuartoServico = diariaQuartoServico;
    }

    @Override
    public String toString() {
        return "Pendencias{" + "descricao=" + descricao + '}';
    }
}