package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Diaria;
import model.DiariaQuarto;
import model.DiariaQuartoDAO;
import model.DiariaQuartoServico;
import model.Pendencias;
import model.PendenciasDAO;
import model.Quarto;
import model.Servico;

public class GerenciarPendencias extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String acao = request.getParameter("acao");
        String idPendenciasStr = request.getParameter("idPendencias");
        Pendencias p = new Pendencias();
        
        try {
            PendenciasDAO pDAO = new PendenciasDAO();
            int idPendencias = 0;
            
            if (acao == null) {
                acao = "listarTodos";
            }

            if ("nova".equals(acao)) {
                ArrayList<Quarto> quartosOcupados = new DiariaQuartoDAO().quartosOcupados();
                request.setAttribute("quartosOcupados", quartosOcupados);
                RequestDispatcher disp =
                        getServletContext().getRequestDispatcher("/form_pendencias.jsp");
                disp.forward(request, response);
                return;
            }

            if ("servicosQuarto".equals(acao)) {
                String numeroStr = request.getParameter("numero");
                int numero;
                try {
                    numero = Integer.parseInt(numeroStr);
                    if (numero <= 0) {
                        throw new NumberFormatException();
                    }
                } catch (NumberFormatException e) {
                    exibirMensagem("Informe um número de quarto válido", false, "", response);
                    return;
                }

                DiariaQuartoDAO diariaQuartoDAO = new DiariaQuartoDAO();
                ArrayList<DiariaQuarto> hospedagens =
                        diariaQuartoDAO.hospedagensAtivasPorNumeroQuarto(numero);
                if (hospedagens.isEmpty()) {
                    exibirMensagem("Não há hospedagem ativa no quarto " + numero, false, "", response);
                } else if (hospedagens.size() > 1) {
                    exibirMensagem("Há mais de uma hospedagem ativa nesse quarto. Verifique as diárias antes de continuar.", false, "", response);
                } else {
                    DiariaQuarto diariaQuarto = hospedagens.get(0);
                    response.sendRedirect("gerenciar_diaria_quarto_servico.do?acao=gerenciar&idDiaria="
                            + diariaQuarto.getDiaria().getIdDiaria() + "&idQuarto="
                            + diariaQuarto.getQuarto().getIdQuarto() + "&origem=pendencias");
                }
                return;
            }

            if (acao.equals("listarTodos")) {
                ArrayList<Pendencias> listarTodos = pDAO.getLista();
                RequestDispatcher disp =
                        getServletContext().getRequestDispatcher("/listar_pendencias.jsp");
                request.setAttribute("listarTodos", listarTodos);
                disp.forward(request, response);
            } 
            else if (acao.equals("alterar")) {
                try {
                    idPendencias = Integer.parseInt(idPendenciasStr);
                    p = pDAO.getCarregaPorID(idPendencias);

                    if (p.getIdPendencias() > 0) {
                        RequestDispatcher disp =
                                getServletContext().getRequestDispatcher("/form_pendencias.jsp");
                        request.setAttribute("pendencias", p);
                        disp.forward(request, response);
                    } else {
                        exibirMensagem("Pendência não encontrada", false, "", response);
                    }
                } catch (NumberFormatException e) {
                    exibirMensagem("ID de Pendência inválido", false, "", response);
                }
            } 
            else if (acao.equals("desativar")) {
                try {
                    idPendencias = Integer.parseInt(idPendenciasStr);
                    p.setIdPendencias(idPendencias);

                    if (pDAO.desativar(p)) {
                        exibirMensagem("Pendência desativada com sucesso", true, "gerenciar_pendencias.do?acao=listarTodos", response);
                    } else {
                        exibirMensagem("Erro ao desativar a Pendência", false, "", response);
                    }
                } catch (NumberFormatException e) {
                    exibirMensagem("ID de Pendência inválido", false, "", response);
                }
            }
            
        } catch (Exception e) {
            out.println(e);
            exibirMensagem("Erro ao acessar o banco", false, "", response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        ArrayList<String> erros = new ArrayList<String>();
        
        String idPendenciasStr = request.getParameter("idPendencias");
        String descricao = request.getParameter("descricao");
        String valorStr = request.getParameter("valor");
        String dataRegistroStr = request.getParameter("dataRegistro");
        String statusStr = request.getParameter("status");
        
        // IDs das tabelas compostas
        String idDiariaStr = request.getParameter("idDiaria");
        String idQuartoStr = request.getParameter("idQuarto");
        String idServicoStr = request.getParameter("idServico");
        
        try {
            PendenciasDAO pDAO = new PendenciasDAO();
            int idPendencias = 0;
            double valor = 0.0;
            int status = 0;
            int idDiaria = 0;
            int idQuarto = 0;
            int idServico = 0;
            Date dataRegistro = new Date();
            
            if (idPendenciasStr != null && !idPendenciasStr.trim().isEmpty()) {
                try {
                    idPendencias = Integer.parseInt(idPendenciasStr);
                } catch (NumberFormatException n) {
                    erros.add("ID de Pendência inválido");
                }
            }
            
            if (valorStr == null || valorStr.trim().isEmpty()) {
                erros.add("O valor é obrigatório");
            } else {
                try {
                    valor = Double.parseDouble(valorStr.replace(",", "."));
                    if (Double.isNaN(valor) || Double.isInfinite(valor) || valor < 0) {
                        erros.add("O valor não pode ser negativo");
                    }
                } catch (NumberFormatException n) {
                    erros.add("Valor inválido");
                }
            }
            
            if (statusStr != null && !statusStr.trim().isEmpty()) {
                try {
                    status = Integer.parseInt(statusStr);
                } catch (NumberFormatException n) {
                    erros.add("Status inválido");
                }
            }
            
            if (idDiariaStr != null && !idDiariaStr.trim().isEmpty()) {
                try {
                    idDiaria = Integer.parseInt(idDiariaStr);
                } catch (NumberFormatException n) {
                    erros.add("ID da Diária inválido");
                }
            }
            
            if (idQuartoStr != null && !idQuartoStr.trim().isEmpty()) {
                try {
                    idQuarto = Integer.parseInt(idQuartoStr);
                } catch (NumberFormatException n) {
                    erros.add("ID do Quarto inválido");
                }
            }
            
            if (idServicoStr != null && !idServicoStr.trim().isEmpty()) {
                try {
                    idServico = Integer.parseInt(idServicoStr);
                } catch (NumberFormatException n) {
                    erros.add("ID do Serviço inválido");
                }
            }
            if (idDiaria <= 0) {
                erros.add("Selecione uma diária");
            }
            if (idQuarto <= 0) {
                erros.add("Selecione um quarto");
            }
            if (idServico <= 0) {
                erros.add("Selecione um serviço");
            }
            
            if (descricao == null || descricao.trim().isEmpty()) {
                erros.add("O campo descrição é obrigatório");
            }
            
            if (dataRegistroStr != null && !dataRegistroStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    dataRegistro = sdf.parse(dataRegistroStr);
                } catch (Exception e) {
                    erros.add("Data de registro inválida");
                }
            }
            
            if (erros.size() > 0) {
                StringBuilder campos = new StringBuilder();
                for (String erro : erros) {
                    campos.append("\\n - ").append(erro);
                }
                exibirMensagem("Preencha o(s) campo(s):" + campos.toString(), false, "", response);
            } else {
                Pendencias p = new Pendencias();
                p.setIdPendencias(idPendencias);
                p.setDescricao(descricao);
                p.setValor(valor);
                p.setDataRegistro(dataRegistro);
                p.setStatus(status);
                
                // Reconstrução dos objetos compostos
                DiariaQuartoServico dqs = new DiariaQuartoServico();
                DiariaQuarto dq = new DiariaQuarto();
                Diaria diaria = new Diaria();
                Quarto quarto = new Quarto();
                Servico servico = new Servico();
                
                diaria.setIdDiaria(idDiaria);
                quarto.setIdQuarto(idQuarto);
                servico.setIdServico(idServico);
                
                dq.setDiaria(diaria);
                dq.setQuarto(quarto);
                dqs.setDiariaQuarto(dq);
                dqs.setServico(servico);
                
                p.setDiariaQuartoServico(dqs);
                
                boolean sucesso = pDAO.gravar(p);
                if (sucesso) {
                    exibirMensagem("Pendência gravada com sucesso", true,
                            "gerenciar_pendencias.do?acao=listarTodos", response); 
                } else {
                    exibirMensagem("Erro ao gravar a Pendência", false, "", response);
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(GerenciarPendencias.class.getName()).log(Level.SEVERE, null, ex);
            exibirMensagem("Erro na classe de conexão", false, "", response);
        }
    }

    private static void exibirMensagem(String mensagem, boolean resposta,
                String link, HttpServletResponse response) {
        DialogoUtil.exibir(response, mensagem, resposta, link,
                link == null || link.trim().isEmpty());
    }

    @Override
    public String getServletInfo() {
        return "Gerenciador de Pendências";
    }
}