/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.DiariaQuartoServico;
import model.DiariaQuartoServicoDAO;
import model.QuartoDAO;
import model.Servico;

/**
 *
 * @author adm_pfelacio
 */
public class GerenciarDiaria_quarto_servico extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        PrintWriter out = response.getWriter();
        String idDiariaStr = request.getParameter("idDiaria");
        String idQuartoStr = request.getParameter("idQuarto"); // Agora precisamos do quarto também
        String acao = request.getParameter("acao");
        
        try {
            DiariaQuartoServicoDAO dqsDAO = new DiariaQuartoServicoDAO();
            int idDiaria = 0;
            int idQuarto = 0;
            
            if (acao.equals("gerenciar")) {
               if ("pendencias".equals(request.getParameter("origem"))
                       || GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        idDiaria = Integer.parseInt(idDiariaStr);
                        idQuarto = Integer.parseInt(idQuartoStr);
                        
                        DiariaQuartoServico dqs = dqsDAO.getCarregaServicosPorDiariaQuarto(idDiaria, idQuarto);
                        
                        if (idDiaria > 0 && idQuarto > 0) {
                            HttpSession session = request.getSession();
                            String chaveCarrinho = chaveCarrinho(idDiaria, idQuarto);
                            Map<Integer, Integer> carrinho = lerCarrinho(session, chaveCarrinho);
                            ArrayList<Integer> idsDisponiveis = new ArrayList<>();
                            ArrayList<Servico> servicosCarrinho = new ArrayList<>();
                            double totalCarrinho = 0;
                            int quantidadeCarrinho = 0;
                            for (Servico servico : dqs.getServicosNaoVinculados()) {
                                Integer quantidade = carrinho.get(servico.getIdServico());
                                if (quantidade != null) {
                                    idsDisponiveis.add(servico.getIdServico());
                                    servicosCarrinho.add(servico);
                                    servico.setQuantidade(quantidade);
                                    totalCarrinho += servico.getValor() * quantidade;
                                    quantidadeCarrinho += quantidade;
                                }
                            }
                            session.setAttribute(chaveCarrinho, carrinho);
                            RequestDispatcher disp = 
                                    getServletContext().getRequestDispatcher("/form_diaria_quarto_servico.jsp");
                            request.setAttribute("diaria_quarto_servico", dqs);
                            request.setAttribute("idDiaria", idDiaria);
                            request.setAttribute("idQuarto", idQuarto);
                            request.setAttribute("numeroQuarto",
                                    new QuartoDAO().getCarregaPorID(idQuarto).getNumero());
                            request.setAttribute("carrinhoServicos", servicosCarrinho);
                            request.setAttribute("quantidadeCarrinho", quantidadeCarrinho);
                            request.setAttribute("totalCarrinho", totalCarrinho);
                            request.setAttribute("origemPendencias",
                                    "pendencias".equals(request.getParameter("origem")));
                            disp.forward(request, response);
                        } else {
                            exibirMensagem("Diária ou Quarto não encontrados", false, "", response);
                        }
                    } catch (NumberFormatException ex) {
                        exibirMensagem("IDs inválidos", false, "", response);
                    }
               } else {
                   exibirMensagem("Acesso negado", false, "", response);
               }    
            }
            
            if (acao.equals("desvincular")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                        String idServicoStr = request.getParameter("idServico");
                        int idServico = 0;
                        try {
                            idDiaria = Integer.parseInt(idDiariaStr);
                            idQuarto = Integer.parseInt(idQuartoStr);
                            
                            if (idServicoStr == null || idServicoStr.isEmpty()) {
                                exibirMensagem("O serviço deve ser selecionado", false, "", response);
                            } else {
                                idServico = Integer.parseInt(idServicoStr);
                            }
                            
                            if (dqsDAO.desvincular(idDiaria, idQuarto, idServico)) {
                                exibirMensagem("Desvinculado com sucesso", true, "gerenciar_diaria_quarto_servico.do?acao=gerenciar&idDiaria=" + idDiariaStr + "&idQuarto=" + idQuartoStr, response);
                            } else {
                                exibirMensagem("Erro ao desvincular", false, "", response);
                            }

                        } catch (NumberFormatException e) {
                            exibirMensagem("IDs inválidos", false, "", response);
                        }
                } else {
                   exibirMensagem("Acesso negado", false, "", response);
               }
            }
        
        } catch (Exception e) {
            out.print(e);
            exibirMensagem("Erro ao acessar o banco", false, "", response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        PrintWriter out = response.getWriter();
        String idDiariaStr = request.getParameter("idDiaria");
        String idQuartoStr = request.getParameter("idQuarto");
        String idServicoStr = request.getParameter("idServico");
        String carrinhoAcao = request.getParameter("carrinhoAcao");
        
        try {
            DiariaQuartoServicoDAO dqsDAO = new DiariaQuartoServicoDAO();
            if (idDiariaStr == null || idDiariaStr.trim().isEmpty()
                    || idQuartoStr == null || idQuartoStr.trim().isEmpty()) {
                exibirMensagem("Diária e quarto são obrigatórios", false, "", response);
                return;
            }
            int idDiaria = Integer.parseInt(idDiariaStr);
            int idQuarto = Integer.parseInt(idQuartoStr);
            String redirect = "gerenciar_diaria_quarto_servico.do?acao=gerenciar&idDiaria="
                    + idDiaria + "&idQuarto=" + idQuarto;
            HttpSession session = request.getSession();
            String chaveCarrinho = chaveCarrinho(idDiaria, idQuarto);
            Map<Integer, Integer> carrinho = lerCarrinho(session, chaveCarrinho);
            boolean origemPendencias = "pendencias".equals(request.getParameter("origem"));
            if (origemPendencias) {
                redirect += "&origem=pendencias";
            }

            if ("adicionar".equals(carrinhoAcao)) {
                int idServico = Integer.parseInt(idServicoStr);
                DiariaQuartoServico dqs = dqsDAO.getCarregaServicosPorDiariaQuarto(idDiaria, idQuarto);
                boolean disponivel = false;
                for (Servico servico : dqs.getServicosNaoVinculados()) {
                    if (servico.getIdServico() == idServico) {
                        disponivel = true;
                        break;
                    }
                }
                if (!disponivel) {
                    exibirMensagem("Esse serviço não está disponível para o quarto", false, "", response);
                    return;
                }
                String quantidadeStr = request.getParameter("quantidade");
                int quantidade;
                try {
                    quantidade = Integer.parseInt(quantidadeStr);
                } catch (NumberFormatException ex) {
                    exibirMensagem("Informe uma quantidade válida", false, "", response);
                    return;
                }
                if (quantidade < 1) {
                    exibirMensagem("Informe pelo menos uma unidade", false, "", response);
                    return;
                }
                carrinho.put(idServico, carrinho.getOrDefault(idServico, 0) + quantidade);
                session.setAttribute(chaveCarrinho, carrinho);
                exibirMensagem("Serviço adicionado ao carrinho", true, redirect, response);
            } else if ("remover".equals(carrinhoAcao)) {
                int idServico = Integer.parseInt(idServicoStr);
                if (!carrinho.containsKey(idServico)) {
                    exibirMensagem("Serviço não encontrado no carrinho", false, "", response);
                    return;
                }
                carrinho.remove(idServico);
                session.setAttribute(chaveCarrinho, carrinho);
                exibirMensagem("Serviço removido do carrinho", true, redirect, response);
            } else if ("ajustar".equals(carrinhoAcao)) {
                int idServico = Integer.parseInt(idServicoStr);
                int quantidade;
                try {
                    quantidade = Integer.parseInt(request.getParameter("quantidade"));
                } catch (NumberFormatException ex) {
                    exibirMensagem("Informe uma quantidade válida", false, "", response);
                    return;
                }
                if (quantidade < 1) {
                    exibirMensagem("Informe pelo menos uma unidade", false, "", response);
                    return;
                }
                carrinho.put(idServico, quantidade);
                session.setAttribute(chaveCarrinho, carrinho);
                exibirMensagem("Quantidade atualizada", true, redirect, response);
            } else if ("confirmar".equals(carrinhoAcao)) {
                if (carrinho.isEmpty()) {
                    exibirMensagem("Adicione pelo menos um serviço ao carrinho", false, "", response);
                    return;
                }
                if (dqsDAO.adicionarEmConta(idDiaria, idQuarto, carrinho)) {
                    session.removeAttribute(chaveCarrinho);
                    String destino = origemPendencias
                            ? "gerenciar_pendencias.do?acao=listarTodos" : redirect;
                    exibirMensagem("Serviços adicionados à conta e às pendências", true, destino, response);
                } else {
                    exibirMensagem("Não foi possível adicionar os serviços à conta", false, "", response);
                }
            } else {
                exibirMensagem("Ação de carrinho inválida", false, "", response);
            }
        } catch (Exception e) {
            out.print(e);
            exibirMensagem("Erro ao processar dados ou acessar o banco", false, "", response);
        }
    }

    private String chaveCarrinho(int idDiaria, int idQuarto) {
        return "carrinhoServicos_" + idDiaria + "_" + idQuarto;
    }

    private Map<Integer, Integer> lerCarrinho(HttpSession session, String chaveCarrinho) {
        Map<Integer, Integer> itens = new HashMap<>();
        Object atual = session.getAttribute(chaveCarrinho);
        if (atual instanceof Map<?, ?>) {
            for (Map.Entry<?, ?> item : ((Map<?, ?>) atual).entrySet()) {
                if (item.getKey() instanceof Integer && item.getValue() instanceof Integer
                        && (Integer) item.getKey() > 0 && (Integer) item.getValue() > 0) {
                    itens.put((Integer) item.getKey(), (Integer) item.getValue());
                }
            }
            return itens;
        }
        if (atual instanceof ArrayList<?>) {
            for (Object item : (ArrayList<?>) atual) {
                if (item instanceof Integer && (Integer) item > 0) {
                    itens.put((Integer) item, 1);
                }
            }
        }
        return itens;
    }
    
     private static void 
        exibirMensagem(String mensagem, boolean resposta, String link, HttpServletResponse response){
        DialogoUtil.exibir(response, mensagem, resposta, link,
                link == null || link.trim().isEmpty());
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}