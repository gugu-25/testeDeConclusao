package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.DiariaQuarto;
import model.DiariaQuartoDAO;

/**
 *
 * @author adm_pfelacio
 */
public class GerenciarDiaria_quarto extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String idDiariaStr = request.getParameter("idDiaria");
        String acao = request.getParameter("acao");
        
        try {
            DiariaQuartoDAO dqDAO = new DiariaQuartoDAO();
            int idDiaria = 0;
            
            if ("gerenciar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) { 
                    try {
                        idDiaria = Integer.parseInt(idDiariaStr);
                        DiariaQuarto dq = dqDAO.getCarregaQuartosPorDiaria(idDiaria);
                        
                        if (idDiaria > 0) {
                            RequestDispatcher disp = 
                                    getServletContext().getRequestDispatcher("/form_diaria_quarto.jsp");
                            request.setAttribute("diaria_quarto", dq);
                            request.setAttribute("idDiaria", idDiaria); 
                            disp.forward(request, response);
                        } else {
                            exibirMensagem("Diária não encontrada", false, "", response);
                        }
                    } catch (NumberFormatException ex) {
                        exibirMensagem("idDiaria inválido", false, "", response);
                    }
                } else {
                    exibirMensagem("Acesso negado", false, "", response);
                }    
            }
            
            if ("desvincular".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    String idQuartoStr = request.getParameter("idQuarto");
                    int idQuarto = 0;
                    try {
                        idDiaria = Integer.parseInt(idDiariaStr);
                        if (idQuartoStr == null || idQuartoStr.trim().isEmpty()) {
                            exibirMensagem("O quarto deve ser selecionado", false, "", response);
                        } else {
                            idQuarto = Integer.parseInt(idQuartoStr);
                        }
                        
                        if (dqDAO.desvincular(idDiaria, idQuarto)) {
                            exibirMensagem("Desvinculado com sucesso", true, "gerenciarDiaria_quarto?acao=gerenciar&idDiaria=" + idDiariaStr, response);
                        } else {
                            exibirMensagem("Erro ao desvincular", false, "", response);
                        }

                    } catch (NumberFormatException e) {
                        exibirMensagem("idDiaria ou idQuarto inválido", false, "", response);
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String idQuartoStr = request.getParameter("idQuarto");
        String idDiariaStr = request.getParameter("idDiaria");
        String valorAtualStr = request.getParameter("valorAtual");
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        
        try {
            DiariaQuartoDAO dqDAO = new DiariaQuartoDAO();
            
            if (idQuartoStr == null || idQuartoStr.trim().isEmpty() || 
                idDiariaStr == null || idDiariaStr.trim().isEmpty() || 
                valorAtualStr == null || valorAtualStr.trim().isEmpty()) {
                exibirMensagem("Campos obrigatórios devem ser preenchidos", false, "", response);
            } else {
                int idQuarto = Integer.parseInt(idQuartoStr);
                int idDiaria = Integer.parseInt(idDiariaStr);
                double valorAtual = Double.parseDouble(valorAtualStr.replace(",", "."));  
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date checkIn = null;
                Date checkOut = null;
                
                if (checkInStr != null && !checkInStr.trim().isEmpty()) {
                    checkIn = sdf.parse(checkInStr);
                }
                
                if (checkOutStr != null && !checkOutStr.trim().isEmpty()) {
                    checkOut = sdf.parse(checkOutStr);
                }
                
                if (dqDAO.vincular(idDiaria, idQuarto, valorAtual, checkIn, checkOut)) {
                    exibirMensagem("Vinculado com sucesso", true, "gerenciarDiaria_quarto?acao=gerenciar&idDiaria=" + idDiariaStr, response);
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
                response.setContentType("text/html;charset=UTF-8");
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

    @Override
    public String getServletInfo() {
        return "Controle de vínculo entre Diária e Quarto";
    }

}