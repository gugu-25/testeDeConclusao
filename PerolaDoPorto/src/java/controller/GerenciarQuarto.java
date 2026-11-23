/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Quarto;
import model.QuartoDAO;

/**
 *
 * @author adm_pfelacio
 */
public class GerenciarQuarto extends HttpServlet {

    private static boolean numeroQuartoValido(int numero) {
        return (numero >= 101 && numero <= 120)
                || (numero >= 200 && numero <= 719 && numero % 100 <= 19);
    }

    private static int tipoDoNumero(int numero) {
        int posicaoNoAndar = numero <= 120 ? numero % 100 : numero % 100 + 1;
        if (posicaoNoAndar <= 7) {
            return 1;
        }
        if (posicaoNoAndar <= 14) {
            return 2;
        }
        return 3;
    }

    private void carregarStatusQuartos(HttpServletRequest request, QuartoDAO qDAO) {
        Map<Integer, Integer> statusQuartos = new HashMap<>();
        for (Quarto quarto : qDAO.getLista()) {
            statusQuartos.put(quarto.getNumero(), quarto.getStatus());
        }
        request.setAttribute("statusQuartos", statusQuartos);
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
        
        PrintWriter out = response.getWriter();
        String acao = request.getParameter("acao");
        String idQuartoStr = request.getParameter("idQuarto");
        Quarto q = new Quarto();
        
        try {
            QuartoDAO qDAO = new QuartoDAO();
            int idQuarto = 0;
            
            if (acao.equals("listarTodos")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    ArrayList<Quarto> listarTodos = new ArrayList<>();
                    listarTodos = qDAO.getLista();
                    RequestDispatcher disp = 
                            getServletContext().getRequestDispatcher("/listar_quarto.jsp");
                    request.setAttribute("listarTodos", listarTodos);
                    disp.forward(request, response);
                } else {
                    exibirMensagem("Acesso negado", false, "", response);
                }
            } 
            else if ("novo".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    carregarStatusQuartos(request, qDAO);
                    RequestDispatcher disp =
                            getServletContext().getRequestDispatcher("/form_quarto.jsp");
                    disp.forward(request, response);
                } else {
                    exibirMensagem("Acesso negado", false, "", response);
                }
            }
            else if (acao.equals("alterar")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        idQuarto = Integer.parseInt(idQuartoStr);
                        q = qDAO.getCarregaPorID(idQuarto);
                        
                        if (q.getIdQuarto() > 0) {
                            carregarStatusQuartos(request, qDAO);
                            RequestDispatcher disp = 
                                    getServletContext().getRequestDispatcher("/form_quarto.jsp");
                            request.setAttribute("quarto", q);
                            disp.forward(request, response);
                        } else {
                            exibirMensagem("Quarto não encontrado", false, "", response);
                        }
                    } catch (NumberFormatException e) {
                        exibirMensagem("ID de Quarto inválido", false, "", response);
                    }
                } else {
                    exibirMensagem("Acesso negado", false, "", response);
                }
            } 
            else if (acao.equals("desativar")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        idQuarto = Integer.parseInt(idQuartoStr);
                        q.setIdQuarto(idQuarto);
                        
                        if (qDAO.desativar(q)) {
                            exibirMensagem("Quarto desativado com sucesso", true, "gerenciar_quarto.do?acao=listarTodos", response);
                        } else {
                            exibirMensagem("Erro ao desativar o Quarto", false, "", response);
                        }
                    } catch (NumberFormatException e) {
                        exibirMensagem("ID de Quarto inválido", false, "", response);
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
        
        String idQuartoStr = request.getParameter("idQuarto");
        String numeroStr = request.getParameter("numero");
        String tipoStr = request.getParameter("tipo");
        String descricao = request.getParameter("descricao");
        String valorStr = request.getParameter("valor");
        String statusStr = request.getParameter("status");
        
        try {
            QuartoDAO qDAO = new QuartoDAO();
            int status = 0;
            int idQuarto = 0;
            int numero = 0;
            int tipo = 0;
            double valor = 0;
            
            if (idQuartoStr != null && !idQuartoStr.isEmpty()) {
                try {
                    idQuarto = Integer.parseInt(idQuartoStr);
                } catch (NumberFormatException n) {
                    erros.add("ID de Quarto inválido");
                }
            }
            
            if (numeroStr == null || numeroStr.trim().isEmpty()) {
                erros.add("O número do quarto é obrigatório");
            } else {
                try {
                    numero = Integer.parseInt(numeroStr);
                    if (!numeroQuartoValido(numero)) {
                        erros.add("Escolha um quarto entre 101 e 120 ou nos blocos de 20 quartos iniciados em 200, 300, 400, 500, 600 ou 700");
                    } else if (qDAO.numeroEmUso(numero, idQuarto)) {
                        erros.add("Esse número de quarto já está cadastrado");
                    }
                } catch (NumberFormatException n) {
                    erros.add("Número do quarto inválido. Selecione um dos números disponíveis");
                }
            }
            
            if (tipoStr == null || tipoStr.trim().isEmpty()) {
                erros.add("O tipo do quarto é obrigatório");
            } else {
                try {
                    tipo = Integer.parseInt(tipoStr);
                    if (tipo < 1 || tipo > 3) {
                        erros.add("Selecione Standard, Luxo ou Suíte");
                    }
                } catch (NumberFormatException n) {
                    erros.add("Tipo do quarto inválido");
                }
            }

            if (numeroQuartoValido(numero) && tipo >= 1 && tipo <= 3
                    && tipo != tipoDoNumero(numero)) {
                Quarto quartoAtual = idQuarto > 0 ? qDAO.getCarregaPorID(idQuarto) : new Quarto();
                boolean mantendoQuartoExistente = quartoAtual.getIdQuarto() == idQuarto
                        && quartoAtual.getNumero() == numero
                        && quartoAtual.getTipo() == tipo;
                if (!mantendoQuartoExistente) {
                    erros.add("Esse número pertence a outro tipo de quarto. Escolha um quarto da faixa correspondente");
                }
            }

            if (statusStr != null && !statusStr.isEmpty()) {
                try {
                    status = Integer.parseInt(statusStr);
                } catch (NumberFormatException n) {
                    erros.add("Status do quarto inválido");
                }
            }
            
            if (valorStr == null || valorStr.trim().isEmpty()) {
                erros.add("O valor do quarto é obrigatório");
            } else {
                try {
                    valor = Double.parseDouble(valorStr.replace(",", "."));
                    if (Double.isNaN(valor) || Double.isInfinite(valor) || valor < 0) {
                        erros.add("O valor do quarto não pode ser negativo");
                    }
                } catch (NumberFormatException n) {
                    erros.add("Valor do quarto inválido");
                }
            }
            
            if (descricao == null || descricao.trim().isEmpty()) {
                erros.add("O campo descrição é obrigatório");
            }
            
            if (erros.size() > 0) {
                String campos = "";
                for (String erro : erros) {
                    campos += "\\n - " + erro;
                }
                exibirMensagem("Preencha o(s) campo(s) " + campos, false, "", response);
            } else {
                Quarto q = new Quarto();
                q.setIdQuarto(idQuarto);
                q.setNumero(numero);
                q.setTipo(tipo);
                q.setDescricao(descricao);
                q.setValor(valor);
                q.setStatus(status);
                
                boolean sucesso = qDAO.gravar(q);
                if (sucesso) {
                    exibirMensagem("Quarto gravado com sucesso", true,
                            "gerenciar_quarto.do?acao=listarTodos", response); 
                } else {
                    exibirMensagem("Erro ao gravar o Quarto", false, "", response);
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(GerenciarQuarto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(GerenciarQuarto.class.getName()).log(Level.SEVERE, null, ex);
            exibirMensagem("Erro ao verificar a disponibilidade do número do quarto", false, "", response);
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
        return "Short description";
    }// </editor-fold>

}