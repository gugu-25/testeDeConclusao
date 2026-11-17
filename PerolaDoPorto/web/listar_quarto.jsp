<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quartos</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script>
            function confirmarExclusao(idQuarto, numero) {
                if (confirm('Deseja realmente desativar o quarto ' + numero + '?')) {
                    window.open('gerenciar_quarto.do?acao=desativar&idQuarto=' + idQuarto, '_self');
                }
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
                    <a href="gerenciar_quarto.do?acao=novo" class="btn btn-primary">Novo cadastro</a>
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
                                                    <c:if test="${q.status==3}">Manutenção</c:if>
                                                </span>
                                            </td>
                                            <td>
                                                <a href="gerenciar_quarto.do?acao=alterar&idQuarto=${q.idQuarto}" class="btn btn-primary">Editar</a>
                                                <button class="btn btn-danger" onclick="confirmarExclusao(${q.idQuarto}, '${q.numero}')">Desativar</button>
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
                            <span class="eyebrow">Sua pousada começa aqui</span>
                            <h3>Nenhum quarto cadastrado ainda</h3>
                            <p>Cadastre a primeira acomodação para começar a organizar a disponibilidade e as diárias.</p>
                            <a href="gerenciar_quarto.do?acao=novo" class="btn btn-primary">Cadastrar quarto <span aria-hidden="true"></span></a>
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
