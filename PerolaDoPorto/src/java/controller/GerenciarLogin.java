/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Menu;
import model.Usuario;
import model.UsuarioDAO;

/**
 *
 * @author adm_pfelacio
 */
public class GerenciarLogin extends HttpServlet {

    private static HttpServletResponse response;

    private static boolean paginaPublica(String uri) {
        if (uri == null) {
            return false;
        }
        String caminho = uri.toLowerCase();
        return caminho.endsWith("/index.jsp")
                || caminho.endsWith("/index.html")
                || caminho.endsWith("/form_login.jsp")
                || caminho.endsWith("/")
                || caminho.contains("gerenciar_login.do");
    }

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
        
        GerenciarLogin.response=response;
        HttpSession sessao = request.getSession(false);
        if (sessao != null) {
            sessao.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/form_login.jsp");
        
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
        
        GerenciarLogin.response = response;
        request.setCharacterEncoding("UTF-8");
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");
        
        ArrayList<String> erros = new ArrayList<>();
        if(login==null || login.trim().isEmpty())
            erros.add("Preencha o login");
        if(senha==null || senha.trim().isEmpty())
            erros.add("Preencha a senha");
        
        if(erros.size()>0){
            StringBuilder campos = new StringBuilder();
            for(String erro: erros){
                campos.append("\n - ").append(erro);
            }
            redirecionarComMensagem("Preencha o(s) campo(s)" + campos, request, response);
            return;
        }

        Usuario u;
        try {
            UsuarioDAO uDAO = new UsuarioDAO();
            u = uDAO.getRecuperarUsuario(login);
        } catch (ClassNotFoundException e) {
            redirecionarComMensagem("Erro ao acessar o banco", request, response);
            return;
        }

        if (u.getIdUsuario() > 0 && u.getStatus() == 1
                && u.getPerfil() != null && u.getPerfil().getStatus() == 1
                && u.getSenha().equals(senha)) {
            HttpSession sessao = request.getSession(false);
            if (sessao != null) {
                sessao.invalidate();
            }
            sessao = request.getSession(true);
            sessao.setAttribute("ulogado", u);
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            redirecionarComMensagem("Login ou senha inválidos", request, response);
        }
    }

    private void redirecionarComMensagem(String mensagem, HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        request.getSession().setAttribute("mensagem", mensagem);
        response.sendRedirect(request.getContextPath() + "/form_login.jsp");
    }
    
    private static void exibirMensagem(String mensagem){
        DialogoUtil.exibir(response, mensagem, false, "form_login.jsp", false);
    }
    
    public static Usuario verificarAcesso(HttpServletRequest request,
            HttpServletResponse response){
        HttpSession sessao = request.getSession(false);
        if (sessao == null) {
            return null;
        }
        Object usuario = sessao.getAttribute("ulogado");
        return usuario instanceof Usuario ? (Usuario) usuario : null;
    }
    
     public static boolean verificarPermissao(HttpServletRequest request,
            HttpServletResponse response){
    
        Usuario u = null;
        GerenciarLogin.response= response;
        boolean possuiAcesso = false;
        try{
            HttpSession sessao = request.getSession();
            if(sessao.getAttribute("ulogado")==null){
                response.sendRedirect("form_login.jsp");
            }else{
                String uri = request.getRequestURI();
                String queryString = request.getQueryString();
                if(queryString!=null){
                    uri += "?" +queryString;
                }
                u = (Usuario) request.getSession().getAttribute("ulogado");
                if(u==null){
                    sessao.setAttribute("mensagem", "Você não está autenticado");
                    response.sendRedirect("form_login.jsp");
                }else{
                    if (u.getPerfil() == null || u.getPerfil().getMenus() == null || u.getPerfil().getMenus().getMenusVinculados() == null || u.getPerfil().getMenus().getMenusVinculados().isEmpty()) {
                        exibirMensagem("Acesso Negado!");
                        return false;
                    }

                    if (paginaPublica(uri)) {
                        return true;
                    }

                    for(Menu m: u.getPerfil().getMenus().getMenusVinculados()){
                        if(m != null && m.getLink() != null && uri.contains(m.getLink())){
                            possuiAcesso = true;
                            break;
                        }
                    }
                    if(!possuiAcesso){
                        exibirMensagem("Acesso Negado!");
                    }
                }
            }
        }catch(Exception e){
            exibirMensagem("Exceção: "+e);
        }
        return possuiAcesso;
    
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
