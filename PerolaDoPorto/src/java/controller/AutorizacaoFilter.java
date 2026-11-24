package controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Menu;
import model.MenuPerfil;
import model.Perfil;
import model.Usuario;

public class AutorizacaoFilter implements Filter {

    private static final List<String> PAGINAS_PUBLICAS = Arrays.asList(
            "/index.jsp", "/form_login.jsp", "/acesso_negado.jsp");

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getServletPath();
        httpRequest.setCharacterEncoding("UTF-8");
        httpResponse.setCharacterEncoding("UTF-8");
        if ("POST".equals(httpRequest.getMethod())) {
            httpRequest.setCharacterEncoding("UTF-8");
        }

        if (PAGINAS_PUBLICAS.contains(path)
                || "/gerenciar_login.do".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        Object usuarioSessao = session == null ? null : session.getAttribute("ulogado");
        if (!(usuarioSessao instanceof Usuario)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/form_login.jsp");
            return;
        }

        Usuario usuario = (Usuario) usuarioSessao;
        Perfil perfil = usuario.getPerfil();
        if (usuario.getStatus() != 1 || perfil == null || perfil.getStatus() != 1) {
            session.invalidate();
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/form_login.jsp");
            return;
        }

        String permissao = resolverPermissao(httpRequest);
        if (permissao == null || !possuiPermissao(perfil, permissao)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }

        chain.doFilter(request, response);
    }

    private String resolverPermissao(HttpServletRequest request) {
        String caminho = request.getServletPath();
        if (caminho.endsWith(".jsp")) {
            return permissaoDaPagina(caminho);
        }
        if (!caminho.endsWith(".do")) {
            return null;
        }
        if (!"GET".equals(request.getMethod()) && !"POST".equals(request.getMethod())) {
            return null;
        }

        String acao = request.getParameter("acao");
        if ("GET".equals(request.getMethod())
                && "gerenciar_diaria.do".equals(caminho)
                && (acao == null || acao.trim().isEmpty())) {
            acao = "listarTodos";
        }
        if ((acao == null || acao.trim().isEmpty()) && "POST".equals(request.getMethod())) {
            acao = acaoDoFormulario(caminho, request);
        }
        if (acao == null || acao.trim().isEmpty()) {
            acao = "listarTodos";
        }
        return caminho.substring(1) + "?acao=" + acao;
    }

    private String permissaoDaPagina(String caminho) {
        switch (caminho) {
            case "/listar_cliente.jsp":
                return "gerenciar_cliente.do?acao=listarTodos";
            case "/form_cliente.jsp":
                return "gerenciar_cliente.do?acao=cadastrar";
            case "/listar_quarto.jsp":
                return "gerenciar_quarto.do?acao=listarTodos";
            case "/form_quarto.jsp":
                return "gerenciar_quarto.do?acao=novo";
            case "/listar_servico.jsp":
                return "gerenciar_servico.do?acao=listarTodos";
            case "/form_servico.jsp":
                return "gerenciar_servico.do?acao=cadastrar";
            case "/listar_usuario.jsp":
                return "gerenciar_usuario.do?acao=listarTodos";
            case "/form_usuario.jsp":
                return "gerenciar_usuario.do?acao=cadastrar";
            case "/listar_pendencias.jsp":
                return "gerenciar_pendencias.do?acao=listarTodos";
            case "/form_pendencias.jsp":
                return "gerenciar_pendencias.do?acao=cadastrar";
            case "/listar_perfil.jsp":
                return "gerenciar_perfil.do?acao=listarTodos";
            case "/form_perfil.jsp":
                return "gerenciar_perfil.do?acao=cadastrar";
            case "/listar_menu.jsp":
                return "gerenciar_menu.do?acao=listarTodos";
            case "/form_menu.jsp":
                return "gerenciar_menu.do?acao=cadastrar";
            case "/form_menu_perfil.jsp":
                return "gerenciar_menu_perfil.do?acao=gerenciar";
            case "/form_diaria.jsp":
                return "gerenciar_diaria.do?acao=novaDiaria";
            case "/form_finalizar_diaria.jsp":
                return "gerenciar_diaria.do?acao=gravar";
            case "/listar_diaria.jsp":
                return "gerenciar_diaria.do?acao=listarTodos";
            case "/form_diaria_quarto.jsp":
                return "gerenciar_diaria_quarto.do?acao=gerenciar";
            case "/form_diaria_quarto_servico.jsp":
                return "gerenciar_diaria_quarto_servico.do?acao=gerenciar";
            default:
                return null;
        }
    }

    private String acaoDoFormulario(String caminho, HttpServletRequest request) {
        if ("gerenciar_diaria.do".equals(caminho)) {
            return "gravar";
        }
        if ("gerenciar_diaria_quarto.do".equals(caminho)
                || "gerenciar_diaria_quarto_servico.do".equals(caminho)) {
            return "vincular";
        }
        if ("gerenciar_menu_perfil.do".equals(caminho)) {
            return "vincular";
        }

        String id = null;
        if ("gerenciar_cliente.do".equals(caminho)) {
            id = request.getParameter("idCliente");
        } else if ("gerenciar_quarto.do".equals(caminho)) {
            id = request.getParameter("idQuarto");
        } else if ("gerenciar_servico.do".equals(caminho)) {
            id = request.getParameter("idServico");
        } else if ("gerenciar_usuario.do".equals(caminho)) {
            id = request.getParameter("idUsuario");
        } else if ("gerenciar_pendencias.do".equals(caminho)) {
            id = request.getParameter("idPendencias");
        } else if ("gerenciar_perfil.do".equals(caminho)) {
            id = request.getParameter("idPerfil");
        } else if ("gerenciar_menu.do".equals(caminho)) {
            id = request.getParameter("idMenu");
        }
        return id == null || id.trim().isEmpty() || "0".equals(id)
                ? "cadastrar" : "alterar";
    }

    private boolean possuiPermissao(Perfil perfil, String link) {
        MenuPerfil menusDoPerfil = perfil.getMenus();
        if (menusDoPerfil == null || menusDoPerfil.getMenusVinculados() == null) {
            return false;
        }
        for (Menu menu : menusDoPerfil.getMenusVinculados()) {
            if (menu != null && link.equals(menu.getLink())) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
    }
}
