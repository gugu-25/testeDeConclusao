package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Cliente;
import model.ClienteDAO;
import model.Diaria;
import model.DiariaDAO;
import model.DiariaQuarto;
import model.Pendencias;
import model.PendenciasDAO;
import model.Quarto;
import model.QuartoDAO;
import model.Usuario;

public class GerenciarDiaria extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            PrintWriter out = response.getWriter();
            HttpSession sessao = request.getSession();
            Usuario ulogado = (Usuario) sessao.getAttribute("ulogado");
            
            Diaria d = new Diaria();
            Cliente c = new Cliente();
            ClienteDAO cDAO = new ClienteDAO();
            QuartoDAO qDAO = new QuartoDAO(); 
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            
            String acao = request.getParameter("acao");
            ArrayList<DiariaQuarto> carrinho = new ArrayList<DiariaQuarto>();
            
            if (acao == null) {
                acao = "listarTodos";
            }

            if (acao.equals("listarTodos")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    DiariaDAO dDAO = new DiariaDAO();
                    request.setAttribute("listarTodos", dDAO.getLista());
                    RequestDispatcher dispatcher =
                            getServletContext().getRequestDispatcher("/listar_diaria.jsp");
                    dispatcher.forward(request, response);
                }
                return;
            }

            if (acao.equals("desativar")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    DiariaDAO dDAO = new DiariaDAO();
                    Diaria diaria = new Diaria();
                    diaria.setIdDiaria(Integer.parseInt(request.getParameter("idDiaria")));
                    if (dDAO.desativar(diaria)) {
                        exibirMensagem("Diária desativada com sucesso!",
                                "gerenciar_diaria.do?acao=listarTodos", response);
                    } else {
                        exibirMensagem("Não foi possível desativar a diária.", null, response);
                    }
                }
                return;
            }

            if (acao.equals("alterar")) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    int idDiaria = Integer.parseInt(request.getParameter("idDiaria"));
                    Diaria diaria = new DiariaDAO().getCarregaPorID(idDiaria);
                    if (diaria.getIdDiaria() > 0) {
                        sessao.setAttribute("diaria", diaria);
                        response.sendRedirect("form_finalizar_diaria.jsp");
                    } else {
                        exibirMensagem("Diária não encontrada.", null, response);
                    }
                }
                return;
            }
            
            if (acao.equals("novaDiaria")) {
                int idCliente = Integer.parseInt(request.getParameter("idCliente"));
                c = cDAO.getCarregaPorID(idCliente);
                
                d.setCliente(c);
                d.setUsuario(ulogado);
                d.setFeitoEm(new Date());
                d.setCarrinhoQuarto(new ArrayList<DiariaQuarto>());
                
                sessao.setAttribute("diaria", d);
                response.sendRedirect("form_diaria.jsp");
                return;
            }
            
            if (acao.equals("adicionarQuarto")) {
                d = (Diaria) sessao.getAttribute("diaria");
                Quarto q = new Quarto();
                int idQuarto = Integer.parseInt(request.getParameter("idQuarto"));
                
                q = qDAO.getCarregaPorID(idQuarto);
                carrinho = d.getCarrinhoQuarto();
                if (carrinho == null) {
                    carrinho = new ArrayList<>();
                }
                
                DiariaQuarto dq = new DiariaQuarto();
                dq.setQuarto(q);
                dq.setValorAtual(q.getValor());
                
                String checkInStr = request.getParameter("checkIn");
                String checkOutStr = request.getParameter("checkOut");
                
                if (checkInStr != null && !checkInStr.trim().isEmpty()) {
                    dq.setCheckIn(sdf.parse(checkInStr));
                }
                if (checkOutStr != null && !checkOutStr.trim().isEmpty()) {
                    dq.setCheckOut(sdf.parse(checkOutStr));
                }
                
                carrinho.add(dq);
                d.setCarrinhoQuarto(carrinho);
                sessao.setAttribute("diaria", d);
                
                response.sendRedirect("form_diaria.jsp");
                return;
            }
            
            if (acao.equals("retirarQuarto")) {
                d = (Diaria) sessao.getAttribute("diaria");
                int index = Integer.parseInt(request.getParameter("index"));
                
                carrinho = d.getCarrinhoQuarto();
                if (carrinho != null && index >= 0 && index < carrinho.size()) {
                    carrinho.remove(index);
                    d.setCarrinhoQuarto(carrinho);
                    sessao.setAttribute("diaria", d);
                }
                
                response.sendRedirect("form_finalizar_diaria.jsp");
                return;
            }
            
            if (acao.equals("gravar")) {
                try {
                    d = (Diaria) sessao.getAttribute("diaria");
                    if (d == null) {
                        d = new Diaria();
                    }
                    
                    String idDiariaStr = request.getParameter("idDiaria");
                    if (idDiariaStr != null && !idDiariaStr.trim().isEmpty()) {
                        d.setIdDiaria(Integer.parseInt(idDiariaStr));
                    }

                    d.setDescricao(request.getParameter("descricao"));
                    double valorDiaria = Double.parseDouble(request.getParameter("valorDiaria").replace(",", "."));
                    double valorTotal = Double.parseDouble(request.getParameter("valorTotal").replace(",", "."));
                    if (Double.isNaN(valorDiaria) || Double.isInfinite(valorDiaria) || valorDiaria < 0
                            || Double.isNaN(valorTotal) || Double.isInfinite(valorTotal) || valorTotal < 0) {
                        exibirMensagem("Os valores da diária não podem ser negativos.", null, response);
                        return;
                    }
                    d.setValorDiaria(valorDiaria);
                    double totalCalculado = 0.0;
                    ArrayList<DiariaQuarto> quartosDaDiaria = d.getCarrinhoQuarto();
                    if (quartosDaDiaria != null) {
                        for (DiariaQuarto item : quartosDaDiaria) {
                            if (item.getCheckIn() != null && item.getCheckOut() != null) {
                                long diferenca = item.getCheckOut().getTime()
                                        - item.getCheckIn().getTime();
                                long noites = Math.max(0L, Math.round(diferenca / 86400000.0));
                                totalCalculado += valorDiaria * noites;
                            }
                        }
                    }
                    d.setValorTotal(totalCalculado);
                    d.setStatusHospedagem(Integer.parseInt(request.getParameter("statusHospedagem")));
                    d.setStatusPagamento(Integer.parseInt(request.getParameter("statusPagamento")));

                    String feitoEmStr = request.getParameter("feitoEm");
                    if (feitoEmStr != null && !feitoEmStr.trim().isEmpty()) {
                        d.setFeitoEm(sdf.parse(feitoEmStr));
                    }
                    
                    String pagoEmStr = request.getParameter("pagoEm");
                    if (pagoEmStr != null && !pagoEmStr.trim().isEmpty()) {
                        d.setPagoEm(sdf.parse(pagoEmStr));
                    }

                    String idPendenciasStr = request.getParameter("idPendencias");
                    if (idPendenciasStr != null && !idPendenciasStr.trim().isEmpty() && !idPendenciasStr.equals("0")) {
                        PendenciasDAO pDAO = new PendenciasDAO();
                        Pendencias p = pDAO.getCarregaPorID(Integer.parseInt(idPendenciasStr));
                        d.setPendencias(p);
                    }

                    DiariaDAO dDAO = new DiariaDAO();
                    
                    if (dDAO.gravar(d)) {
                        sessao.removeAttribute("diaria");
                        exibirMensagem("Diária gravada com sucesso!", "gerenciar_diaria.do?acao=listarTodos", response);
                    } else {
                        exibirMensagem("Erro ao gravar a diária!", null, response);
                    }
                    
                } catch (Exception e) {
                    out.print("Erro ao gravar: " + e.getMessage());
                }
            }
            
        } catch (Exception e) {
            response.getWriter().print("Erro: " + e.getMessage());
        }
    }

    private static void exibirMensagem(String mensagem, String linkRedirecionamento, HttpServletResponse response) {
        boolean sucesso = linkRedirecionamento != null && !linkRedirecionamento.isEmpty();
        DialogoUtil.exibir(response, mensagem, sucesso, linkRedirecionamento, !sucesso);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Gerenciador de Diárias";
    }
}