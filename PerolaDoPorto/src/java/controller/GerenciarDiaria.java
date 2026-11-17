package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
                    d.setValorDiaria(Double.parseDouble(request.getParameter("valorDiaria").replace(",", ".")));
                    d.setValorTotal(Double.parseDouble(request.getParameter("valorTotal").replace(",", ".")));
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
        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('" + mensagem + "');");
            if (linkRedirecionamento != null && !linkRedirecionamento.isEmpty()) {
                out.println("location.href='" + linkRedirecionamento + "';");
            } else {
                out.println("history.back();");
            }
            out.println("</script>");
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
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