<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Usuários</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarExclusao(idUsuario, nome) {
                appConfirm(
                    'Deseja realmente desativar o usuário ' + nome + '?',
                    function () {
                        window.location.href = 'gerenciar_usuario.do?acao=desativar&idUsuario=' + idUsuario;
                    },
                    {
                        title: 'Desativar usuário',
                        type: 'error',
                        confirmText: 'Desativar',
                        cancelText: 'Cancelar'
                    }
                );
            }
        </script>
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>

            <div class="content">
                <div class="hero">
                    <div>
                        <h2>Lista de Usuários</h2>
                    </div>
                    <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                        <a href="form_usuario.jsp" class="btn btn-primary">Novo cadastro</a>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty listarTodos}">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nome</th>
                                        <th>Login</th>
                                        <th>Perfil</th>
                                        <th>Status</th>
                                        <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                            <th>Opções</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${listarTodos}">
                                        <tr>
                                            <td>${u.idUsuario}</td>
                                            <td>${u.nome}</td>
                                            <td>${u.login}</td>
                                            <td>${u.perfil.nome}</td>
                                            <td>
                                                <span class="status-pill ${u.status==1 ? 'active' : 'inactive'}">
                                                    <c:if test="${u.status==1}">Ativo</c:if>
                                                    <c:if test="${u.status==2}">Inativo</c:if>
                                                </span>
                                            </td>
                                            <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                                <td>
                                                    <a href="gerenciar_usuario.do?acao=alterar&idUsuario=${u.idUsuario}" class="btn btn-primary">Editar</a>
                                                    <button class="btn btn-danger" onclick="confirmarExclusao(${u.idUsuario}, '${u.nome}')">Desativar</button>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <section class="empty-state">
                            <span class="empty-state-icon" aria-hidden="true">♙</span>
                            <span class="eyebrow">Equipe</span>
                            <h3>Convide sua equipe para começar</h3>
                            <p>Crie o primeiro usuário para organizar os acessos ao sistema da pousada.</p>
                            <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                <a href="form_usuario.jsp" class="btn btn-primary">Cadastrar um usuário <span aria-hidden="true"></span></a>
                            </c:if>
                        </section>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <script>
            function toggleMenu() {
                var menu = document.getElementById("nav-links");
                menu.classList.toggle("show");
            }
        </script>
    </body>
</html>
