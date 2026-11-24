<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quartos</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarExclusao(idQuarto, numero) {
                appConfirm(
                    'Deseja realmente desativar o quarto ' + numero + '?',
                    function () {
                        window.location.href = 'gerenciar_quarto.do?acao=desativar&idQuarto=' + idQuarto;
                    },
                    {
                        title: 'Desativar quarto',
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
                        <h2>Lista de Quartos</h2>
                    </div>
                    <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                        <a href="gerenciar_quarto.do?acao=novo" class="btn btn-primary">Novo cadastro</a>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty listarTodos}">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Número</th>
                                        <th>Tipo</th>
                                        <th>Descrição</th>
                                        <th>Valor</th>
                                        <th>Status</th>
                                        <th>Opções</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="q" items="${listarTodos}">
                                        <tr>
                                            <td>${q.idQuarto}</td>
                                            <td>${q.numero}</td>
                                            <td>
                                                <c:if test="${q.tipo==1}">Standard</c:if>
                                                <c:if test="${q.tipo==2}">Luxo</c:if>
                                                <c:if test="${q.tipo==3}">Suíte</c:if>
                                            </td>
                                            <td>${q.descricao}</td>
                                            <td>R$ ${q.valor}</td>
                                            <td>
                                                <span class="status-pill ${q.status==1 ? 'active' : 'inactive'}">
                                                    <c:if test="${q.status==1}">Disponível</c:if>
                                                    <c:if test="${q.status==2}">Ocupado</c:if>
                                                    <c:if test="${q.status==3}">Serviço de quarto</c:if>
                                                </span>
                                            </td>
                                            <td>
                                                <a href="gerenciar_quarto.do?acao=alterar&idQuarto=${q.idQuarto}" class="btn btn-primary">
                                                    <c:choose>
                                                        <c:when test="${ulogado.perfil.nome=='Auxiliar de limpeza'}">Concluir serviço</c:when>
                                                        <c:otherwise>Editar</c:otherwise>
                                                    </c:choose>
                                                </a>
                                                <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                                    <button class="btn btn-danger" onclick="confirmarExclusao(${q.idQuarto}, '${q.numero}')">Desativar</button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <section class="empty-state">
                            <span class="empty-state-icon" aria-hidden="true">⌂</span>
                            <span class="eyebrow">
                                <c:choose>
                                    <c:when test="${ulogado.perfil.nome=='Auxiliar de limpeza'}">Serviço de quarto</c:when>
                                    <c:otherwise>Sua pousada começa aqui</c:otherwise>
                                </c:choose>
                            </span>
                            <h3>
                                <c:choose>
                                    <c:when test="${ulogado.perfil.nome=='Auxiliar de limpeza'}">Nenhum quarto precisa de serviço</c:when>
                                    <c:otherwise>Nenhum quarto cadastrado ainda</c:otherwise>
                                </c:choose>
                            </h3>
                            <p>
                                <c:choose>
                                    <c:when test="${ulogado.perfil.nome=='Auxiliar de limpeza'}">No momento, não há quartos marcados para serviço de quarto.</c:when>
                                    <c:otherwise>Cadastre a primeira acomodação para começar a organizar a disponibilidade e as diárias.</c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${ulogado.perfil.nome!='Auxiliar de limpeza'}">
                                <a href="gerenciar_quarto.do?acao=novo" class="btn btn-primary">Cadastrar quarto <span aria-hidden="true"></span></a>
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
