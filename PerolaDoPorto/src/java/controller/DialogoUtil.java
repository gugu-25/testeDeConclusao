package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletResponse;

public final class DialogoUtil {

    private DialogoUtil() {
    }

    public static void exibir(HttpServletResponse response, String mensagem,
            boolean sucesso, String destino) {
        exibir(response, mensagem, sucesso, destino, false);
    }

    public static void exibir(HttpServletResponse response, String mensagem,
            boolean sucesso, String destino, boolean voltar) {
        try {
            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");

            String titulo = sucesso ? "Operação concluída" : "Não foi possível concluir";
            String tipo = sucesso ? "success" : "error";
            String simbolo = sucesso ? "✓" : "!";
            String destinoSeguro = destino == null ? "" : destino
                    .replace("\\", "\\\\")
                    .replace("'", "\\'")
                    .replace("\r", "")
                    .replace("\n", "");

            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html>");
            out.println("<html lang=\"pt-BR\"><head>");
            out.println("<meta charset=\"UTF-8\">");
            out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
            out.println("<title>" + titulo + " - Pérola do Porto</title>");
            out.println("<link rel=\"stylesheet\" href=\"css/estilo.css\">");
            out.println("</head><body>");
            out.println("<main class=\"result-page\"><section class=\"app-dialog result-card " + tipo + "\">");
            out.println("<div class=\"app-dialog-icon\" aria-hidden=\"true\">" + simbolo + "</div>");
            out.println("<h2>" + titulo + "</h2>");
            out.println("<p class=\"app-dialog-message\">" + escapar(mensagem) + "</p>");
            out.println("<div class=\"app-dialog-actions\">");
            out.println("<button type=\"button\" class=\"app-dialog-button app-dialog-button-primary\" id=\"resultadoOk\">OK</button>");
            out.println("</div></section></main>");
            out.println("<script>");
            out.println("document.getElementById('resultadoOk').addEventListener('click', function(){");
            if (sucesso && !destinoSeguro.isEmpty()) {
                out.println("window.location.href='" + destinoSeguro + "';");
            } else if (voltar) {
                out.println("window.location.href='index.jsp';");
            } else if (!destinoSeguro.isEmpty()) {
                out.println("window.location.href='" + destinoSeguro + "';");
            } else {
                out.println("window.location.href='index.jsp';");
            }
            out.println("});");
            out.println("</script>");
            out.println("</body></html>");
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String escapar(String valor) {
        if (valor == null) {
            return "";
        }
        return valor
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
}
