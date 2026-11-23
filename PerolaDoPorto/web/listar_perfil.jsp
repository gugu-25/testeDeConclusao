<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Perfis de acesso</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarDesativacao(id, nome) {
                appConfirm('Desativar o perfil ' + nome + '?', function () {
                    window.location.href = 'gerenciar_perfil.do?acao=desativar&idPerfil=' + id;
                }, {title: 'Desativar perfil', type: 'error', confirmText: 'Desativar'});
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
                        <span class="eyebrow">Acessos da equipe</span>
                        <h2>Perfis</h2>
                    </div>
                    <a href="form_perfil.jsp" class="btn btn-primary">Novo perfil</a>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr><th>Perfil</th><th>Status</th><th>Opções</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${listarTodos}">
                                <tr>
                                    <td>${p.nome}</td>
                                    <td>
                                        <span class="status-pill ${p.status==1 ? 'active' : 'inactive'}">
                                            <c:choose><c:when test="${p.status==1}">Ativo</c:when><c:otherwise>Inativo</c:otherwise></c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <a class="btn btn-primary" href="gerenciar_perfil.do?acao=alterar&idPerfil=${p.idPerfil}">Editar</a>
                                        <c:if test="${ulogado.perfil.nome=='Administrador'}">
                                            <a class="btn btn-warning" href="gerenciar_menu_perfil.do?acao=gerenciar&idPerfil=${p.idPerfil}">Permissões</a>
                                        </c:if>
                                        <button class="btn btn-danger" type="button" onclick="confirmarDesativacao(${p.idPerfil}, '${p.nome}')">Desativar</button>
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
