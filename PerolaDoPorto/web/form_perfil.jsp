<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cadastro de perfil</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="form-card">
                    <div class="form-header"><h3>${perfil.idPerfil > 0 ? 'Editar perfil' : 'Novo perfil'}</h3></div>
                    <form method="POST" action="gerenciar_perfil.do">
                        <input type="hidden" name="idPerfil" value="${perfil.idPerfil}">
                        <input type="hidden" name="acao" value="${perfil.idPerfil > 0 ? 'alterar' : 'cadastrar'}">
                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="nome">Nome do perfil</label>
                                <input type="text" id="nome" name="nome" value="${perfil.nome}" maxlength="45" required>
                            </div>
                            <div class="form-field">
                                <label for="status">Status</label>
                                <select id="status" name="status" required>
                                    <option value="1" <c:if test="${perfil.status==1 || perfil.idPerfil==0}">selected</c:if>>Ativo</option>
                                    <option value="2" <c:if test="${perfil.status==2}">selected</c:if>>Inativo</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Salvar perfil</button>
                            <a href="gerenciar_perfil.do?acao=listarTodos" class="btn btn-warning">Voltar</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
        <script>
            function toggleMenu() {
                document.getElementById("nav-links").classList.toggle("show");
            }
        </script>
    </body>
</html>
