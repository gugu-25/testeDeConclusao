/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.DiariaQuartoServico;
import model.DiariaQuartoServicoDAO;

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
               if (GerenciarLogin.verificarPermissao(request, response)) { 
                    try {
                        idDiaria = Integer.parseInt(idDiariaStr);
                        idQuarto = Integer.parseInt(idQuartoStr);
                        
                        DiariaQuartoServico dqs = dqsDAO.getCarregaServicosPorDiariaQuarto(idDiaria, idQuarto);
                        
                        if (idDiaria > 0 && idQuarto > 0) {
                            RequestDispatcher disp = 
                                    getServletContext().getRequestDispatcher("/form_diaria_quarto_servico.jsp");
                            request.setAttribute("diaria_quarto_servico", dqs);
                            request.setAttribute("idDiaria", idDiaria);
                            request.setAttribute("idQuarto", idQuarto);
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
                                exibirMensagem("Desvinculado com sucesso", true, "gerenciarDiaria_quarto_servico?acao=gerenciar&idDiaria=" + idDiariaStr + "&idQuarto=" + idQuartoStr, response);
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
        String valorServicoAtualStr = request.getParameter("valorServicoAtual");
        
        try {
            DiariaQuartoServicoDAO dqsDAO = new DiariaQuartoServicoDAO();
            
            if (idDiariaStr == null || idDiariaStr.isEmpty() ||
                idQuartoStr == null || idQuartoStr.isEmpty() ||
                idServicoStr == null || idServicoStr.isEmpty() || 
                valorServicoAtualStr == null || valorServicoAtualStr.isEmpty()) {
                exibirMensagem("Campos obrigatórios devem ser preenchidos", false, "", response);
            } else {
                int idDiaria = Integer.parseInt(idDiariaStr);
                int idQuarto = Integer.parseInt(idQuartoStr);
                int idServico = Integer.parseInt(idServicoStr);
                double valorServicoAtual = Double.parseDouble(valorServicoAtualStr.replace(",", ".")); // Previne erro com vírgula no double
                
                if (dqsDAO.vincular(idDiaria, idQuarto, idServico, valorServicoAtual)) {
                    exibirMensagem("Vinculado com sucesso", true, "gerenciarDiaria_quarto_servico?acao=gerenciar&idDiaria=" + idDiariaStr + "&idQuarto=" + idQuartoStr, response);
                } else {
                    exibirMensagem("Erro ao vincular", false, "", response);
                }
            }
        
        } catch (Exception e) {
            out.print(e);
            exibirMensagem("Erro ao processar dados ou acessar o banco", false, "", response);
        }
    }
    
     private static void 
        exibirMensagem(String mensagem, boolean resposta, String link, HttpServletResponse response){
            try{
                PrintWriter out = response.getWriter();
                out.println("<script type='text/javascript'>");
                out.println("alert('"+mensagem+"')");
                if(resposta){
                    out.println("location.href='"+link+"'");
                }else{
                    out.println("history.back();");
                }
                out.println("</script>");
                out.close();
            }catch(Exception e){
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
        return "Short description";
    }// </editor-fold>

}