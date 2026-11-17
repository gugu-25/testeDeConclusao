<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String mensagem = (String) session.getAttribute("mensagem");
    if (mensagem != null) {
        session.removeAttribute("mensagem");
    } else {
        mensagem = request.getParameter("mensagem");
    }
    request.setAttribute("mensagemLogin", mensagem);
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="theme-color" content="#183c38">
        <title>Login - Pérola do Porto</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <main class="auth-shell">
            <a class="auth-home-link" href="index.jsp" aria-label="Voltar para a página inicial">← <span>Pérola do Porto</span></a>
            <div class="auth-layout">
                <section class="auth-aside">
                    <span class="eyebrow">Pérola do Porto</span>
                    <h1>Hospitalidade em cada detalhe.</h1>
                    <p>Um espaço tranquilo para receber bem. Acesse o painel para cuidar da experiência de cada hóspede.</p>
                    <a href="index.jsp">Voltar à página inicial <span aria-hidden="true">↗</span></a>
                </section>
                <section class="auth-card">
                    <span class="eyebrow">Área da equipe</span>
                    <h2>Bem-vindo de volta.</h2>
                    <p>Entre com seus dados para acessar o painel.</p>

                    <c:if test="${not empty mensagemLogin}">
                        <div class="alert" role="alert"><c:out value="${mensagemLogin}" /></div>
                    </c:if>

                    <form method="POST" action="gerenciar_login.do" class="auth-form">
                        <div class="form-field">
                            <label for="login">Login</label>
                            <input type="text" id="login" name="login" autocomplete="username" placeholder="Seu nome de usuário" required>
                        </div>

                        <div class="form-field">
                            <label for="senha">Senha</label>
                            <input type="password" id="senha" name="senha" autocomplete="current-password" placeholder="Sua senha" required>
                        </div>

                        <button type="submit" class="btn btn-primary btn-large">Acessar o painel <span aria-hidden="true">→</span></button>
                    </form>
                    <span class="auth-note">Acesso exclusivo para a equipe da pousada.</span>
                </section>
            </div>
        </main>
    </body>
</html>
