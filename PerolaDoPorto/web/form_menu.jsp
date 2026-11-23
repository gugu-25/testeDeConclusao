<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cadastro de menu</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="form-card">
                    <div class="form-header"><h3>${menu.idMenu > 0 ? 'Editar menu/permissão' : 'Novo menu/permissão'}</h3></div>
                    <form method="POST" action="gerenciar_menu.do">
                        <input type="hidden" name="idMenu" value="${menu.idMenu}">
                        <input type="hidden" name="acao" value="${menu.idMenu > 0 ? 'alterar' : 'cadastrar'}">
                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="nome">Nome</label>
                                <input type="text" id="nome" name="nome" value="${menu.nome}" maxlength="45" required>
                            </div>
                            <div class="form-field full">
                                <label for="link">Destino ou chave de permissão</label>
                                <input type="text" id="link" name="link" value="${menu.link}" maxlength="100" required>
                            </div>
                            <div class="form-field">
                                <label for="icone">Ícone</label>
                                <input type="text" id="icone" name="icone" value="${menu.icone}" maxlength="45">
                            </div>
                            <div class="form-field">
                                <label for="exibir">Exibição</label>
                                <select id="exibir" name="exibir" required>
                                    <option value="1" <c:if test="${menu.exibir==1}">selected</c:if>>Mostrar no menu</option>
                                    <option value="0" <c:if test="${menu.exibir!=1}">selected</c:if>>Permissão interna</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Salvar</button>
                            <a href="gerenciar_menu.do?acao=listarTodos" class="btn btn-warning">Voltar</a>
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
