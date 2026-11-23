<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Menus e permissões</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarExclusao(id, nome) {
                appConfirm('Excluir o menu/permissão ' + nome + '?', function () {
                    window.location.href = 'gerenciar_menu.do?acao=excluir&idMenu=' + id;
                }, {title: 'Excluir item', type: 'error', confirmText: 'Excluir'});
            }
        </script>
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="hero">
                    <div>
                        <span class="eyebrow">Administração</span>
                        <h2>Menus e permissões</h2>
                    </div>
                    <a href="form_menu.jsp" class="btn btn-primary">Novo item</a>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>Nome</th><th>Destino</th><th>Exibição</th><th>Opções</th></tr></thead>
                        <tbody>
                            <c:forEach var="m" items="${listarTodos}">
                                <tr>
                                    <td>${m.nome}</td>
                                    <td>${m.link}</td>
                                    <td><c:choose><c:when test="${m.exibir==1}">Menu de navegação</c:when><c:otherwise>Permissão interna</c:otherwise></c:choose></td>
                                    <td>
                                        <a class="btn btn-primary" href="gerenciar_menu.do?acao=alterar&idMenu=${m.idMenu}">Editar</a>
                                        <button class="btn btn-danger" type="button" onclick="confirmarExclusao(${m.idMenu}, '${m.nome}')">Excluir</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
