/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Servico;
import model.ServicoDAO;

/**
 *
 * @author adm_pfelacio
 */
public class GerenciarServico extends HttpServlet {

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
        String acao = request.getParameter("acao");
        String idServicoStr = request.getParameter("idServico");
        Servico s = new Servico();
        
        try {
            ServicoDAO sDAO = new ServicoDAO();
            int idServico = 0;
            
            if (acao.equals("listarTodos")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    ArrayList<Servico> listarTodos = new ArrayList<>();
                    listarTodos = sDAO.getLista();
                    RequestDispatcher disp = 
                            getServletContext().getRequestDispatcher("/listar_servico.jsp");
                    request.setAttribute("listarTodos", listarTodos);
                    disp.forward(request, response);
                } else {
                    exibirMensagem("Acesso negado", false, "", response);
                }
            } 
            else if (acao.equals("alterar")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        idServico = Integer.parseInt(idServicoStr);
                        s = sDAO.getCarregaPorID(idServico);
                        
                        if (s.getIdServico() > 0) {
                            RequestDispatcher disp = 
                                    getServletContext().getRequestDispatcher("/form_servico.jsp");
                            request.setAttribute("servico", s);
                            disp.forward(request, response);
                        } else {
                            exibirMensagem("Serviço não encontrado", false, "", response);
                        }
                    } catch (NumberFormatException e) {
                        exibirMensagem("ID de Serviço inválido", false, "", response);
                    }
                } else {
                    exibirMensagem("Acesso negado", false, "", response);
                }
            } 
            else if (acao.equals("desativar")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        idServico = Integer.parseInt(idServicoStr);
                        s.setIdServico(idServico);
                        
                        if (sDAO.desativar(s)) {
                            exibirMensagem("Serviço desativado com sucesso", true, "gerenciar_servico.do?acao=listarTodos", response);
                        } else {
                            exibirMensagem("Erro ao desativar o Serviço", false, "", response);
                        }
                    } catch (NumberFormatException e) {
                        exibirMensagem("ID de Serviço inválido", false, "", response);
                    }
                } else {
                    exibirMensagem("Acesso negado", false, "", response);
                }
            }
            
        } catch (Exception e) {
            out.println(e);
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
        response.setContentType("text/html");
        ArrayList<String> erros = new ArrayList<String>();
        
        String idServicoStr = request.getParameter("idServico");
        String nome = request.getParameter("nome");
        String valorStr = request.getParameter("valor");
        String statusStr = request.getParameter("status");
        
        try {
            ServicoDAO sDAO = new ServicoDAO();
            int status = 0;
            int idServico = 0;
            double valor = 0;
            
            if (idServicoStr != null && !idServicoStr.isEmpty()) {
                try {
                    idServico = Integer.parseInt(idServicoStr);
                } catch (NumberFormatException n) {
                    erros.add("ID de Serviço inválido");
                }
            }
            
            if (statusStr != null && !statusStr.isEmpty()) {
                try {
                    status = Integer.parseInt(statusStr);
                } catch (NumberFormatException n) {
                    erros.add("Status do serviço inválido");
                }
            }
            
            if (valorStr == null || valorStr.trim().isEmpty()) {
                erros.add("O valor do serviço é obrigatório");
            } else {
                try {
                    valor = Double.parseDouble(valorStr.replace(",", "."));
                    if (Double.isNaN(valor) || Double.isInfinite(valor) || valor < 0) {
                        erros.add("O valor do serviço não pode ser negativo");
                    }
                } catch (NumberFormatException n) {
                    erros.add("Valor do serviço inválido");
                }
            }
            
            if (nome == null || nome.trim().isEmpty()) {
                erros.add("O campo nome é obrigatório");
            }
            
            if (erros.size() > 0) {
                String campos = "";
                for (String erro : erros) {
                    campos += "\\n - " + erro;
                }
                exibirMensagem("Preencha o(s) campo(s) " + campos, false, "", response);
            } else {
                Servico s = new Servico();
                s.setIdServico(idServico);
                s.setNome(nome);
                s.setValor(valor);
                s.setStatus(status);
                
                boolean sucesso = sDAO.gravar(s);
                if (sucesso) {
                    exibirMensagem("Serviço gravado com sucesso", true,
                            "gerenciar_servico.do?acao=listarTodos", response); 
                } else {
                    exibirMensagem("Erro ao gravar o Serviço", false, "", response);
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(GerenciarServico.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private static void 
        exibirMensagem(String mensagem, boolean resposta,
                String link, HttpServletResponse response) {
            try {
                PrintWriter out = response.getWriter();
                out.println("<script src='js/app-dialog.js'></script>");
                out.println("<script>");
                out.println("appMessage('" + mensagem + "', {");
                if (resposta) {
                    out.println("type: 'success', redirect: '" + link + "'");
                } else {
                    out.println("type: 'error', back: true");
                }
                out.println("});");
                out.println("</script>");
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet de gerenciamento de Serviços";
    }// </editor-fold>

}