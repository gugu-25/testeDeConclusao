/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Cliente;
import model.ClienteDAO;

/**
 *
 * @author adm_pfelacio
 */
public class GerenciarCliente extends HttpServlet {

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
       String idClienteStr = request.getParameter("idCliente");
       Cliente c = new Cliente();
       
       try{
           ClienteDAO cDAO = new ClienteDAO();
           int idCliente=0;
           
           if(acao.equals("listarTodos")){
               if(GerenciarLogin.verificarPermissao(request, response)){
                        ArrayList<Cliente> listarTodos = new ArrayList<>();
                        listarTodos = cDAO.getLista();
                        RequestDispatcher disp = 
                                getServletContext().getRequestDispatcher("/listar_cliente.jsp");
                        request.setAttribute("listarTodos", listarTodos);
                        disp.forward(request, response);
               }else{
                  exibirMensagem("Acesso negado", false,"",response);
               }
           }
           else if (acao.equals("alterar")) {
               if (GerenciarLogin.verificarPermissao(request, response)) {
                   idCliente = Integer.parseInt(idClienteStr);
                   c = cDAO.getCarregaPorID(idCliente);
                   
                   if (c.getIdCliente() > 0) {
                       RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_cliente.jsp");
                       request.setAttribute("cliente", c);
                       disp.forward(request, response);
                   } else {
                       exibirMensagem("Cliente não encontrado", false, "", response);
                   }
               } else {
                   exibirMensagem("Acesso negado", false, "", response);
               }
           } 
           else if (acao.equals("desativar")) {
               if (GerenciarLogin.verificarPermissao(request, response)) {
                   idCliente = Integer.parseInt(idClienteStr);
                   c.setIdCliente(idCliente);
                   
                   if (cDAO.desativar(c)) {
                       exibirMensagem("Cliente desativado com sucesso", true, "gerenciar_cliente.do?acao=listarTodos", response);
                   } else {
                       exibirMensagem("Erro ao desativar o cliente", false, "", response);
                   }
               } else {
                   exibirMensagem("Acesso negado", false, "", response);
               }
           }
           
       }catch(Exception e){
           out.println(e);
           exibirMensagem("Erro ao acessar o banco",false,"",response);
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
    
    request.setCharacterEncoding("UTF-8");
    
    try {
        String idClienteStr = request.getParameter("idCliente");
        String nomeRazao = request.getParameter("nomeRazao");
        String cpfCnpj = request.getParameter("cpfCnpj");
        String rgIe = request.getParameter("rgIe");
        String dataNascAberturaStr = request.getParameter("dataNascAbertura");
        String tipoStr = request.getParameter("tipo");
        String statusStr = request.getParameter("status");

        if (nomeRazao == null || nomeRazao.trim().isEmpty() || cpfCnpj == null || cpfCnpj.trim().isEmpty()) {
            request.setAttribute("mensagemErro", "Os campos Nome/Razão Social e CPF/CNPJ são obrigatórios!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/form_cliente.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Cliente cliente = new Cliente();
        
        if (idClienteStr != null && !idClienteStr.trim().isEmpty()) {
            cliente.setIdCliente(Integer.parseInt(idClienteStr));
        } else {
            cliente.setIdCliente(0);
        }

        cliente.setNomeRazao(nomeRazao);
        cliente.setCpfCnpj(cpfCnpj);
        cliente.setRgIe(rgIe);
        
        if (dataNascAberturaStr != null && !dataNascAberturaStr.trim().isEmpty()) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dataFormatada = sdf.parse(dataNascAberturaStr);
            cliente.setDataNascAbertura(dataFormatada);
        }

        if (tipoStr != null && !tipoStr.trim().isEmpty()) {
            cliente.setTipo(Integer.parseInt(tipoStr));
        }
        
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            cliente.setStatus(Integer.parseInt(statusStr));
        }

        ClienteDAO dao = new ClienteDAO();
        boolean sucesso = dao.gravar(cliente); 

        if (sucesso) {
            response.sendRedirect("gerenciar_cliente.do?acao=listarTodos");
        } else {
            request.setAttribute("mensagemErro", "Erro ao gravar no banco de dados. Verifique as informações.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/form_cliente.jsp");
            dispatcher.forward(request, response);
        }

    } catch (java.text.ParseException e) {
        e.printStackTrace();
        request.setAttribute("mensagemErro", "Formato de data inválido!");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/form_cliente.jsp");
        dispatcher.forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensagemErro", "Ocorreu um erro ao processar o cliente: " + e.getMessage());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/form_cliente.jsp");
        dispatcher.forward(request, response);
        }
    }
    
     private static void 
        exibirMensagem(String mensagem, boolean resposta,
                String link, HttpServletResponse response){
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