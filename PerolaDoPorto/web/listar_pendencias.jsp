<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pendências</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarDesativacao(id) {
                appConfirm('Desativar esta pendência?', function () {
                    window.location.href = 'gerenciar_pendencias.do?acao=desativar&idPendencias=' + id;
                }, {title: 'Desativar pendência', type: 'error', confirmText: 'Desativar'});
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
                        <span class="eyebrow">Acompanhamento da hospedagem</span>
                        <h2>Pendências</h2>
                    </div>
                    <c:if test="${ulogado.perfil.nome!='Auxiliar de limpeza'}">
                        <a href="form_pendencias.jsp" class="btn btn-primary">Nova pendência</a>
                    </c:if>
                </div>
                <c:choose>
                    <c:when test="${not empty listarTodos}">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr><th>Descrição</th><th>Valor</th><th>Registro</th><th>Hóspede / diária</th><th>Quarto</th><th>Serviço</th><th>Status</th><th>Opções</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${listarTodos}">
                                        <tr>
                                            <td>${p.descricao}</td>
                                            <td><fmt:formatNumber value="${p.valor}" type="currency" currencySymbol="R$ " /></td>
                                            <td><fmt:formatDate value="${p.dataRegistro}" pattern="dd/MM/yyyy" /></td>
                                            <td><c:out value="${p.diariaQuartoServico.diariaQuarto.diaria.cliente.nomeRazao}"/> / diária ${p.diariaQuartoServico.diariaQuarto.diaria.idDiaria}</td>
                                            <td><c:choose><c:when test="${p.diariaQuartoServico.diariaQuarto.quarto.numero > 0}">Quarto ${p.diariaQuartoServico.diariaQuarto.quarto.numero}</c:when><c:otherwise>—</c:otherwise></c:choose></td>
                                            <td><c:out value="${p.diariaQuartoServico.servico.nome}"/></td>
                                            <td>
                                                <span class="status-pill ${p.status==1 ? 'active' : 'inactive'}">
                                                    <c:choose><c:when test="${p.status==1}">Ativa</c:when><c:otherwise>Inativa</c:otherwise></c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <a href="gerenciar_pendencias.do?acao=alterar&idPendencias=${p.idPendencias}" class="btn btn-primary">Editar</a>
                                                <button class="btn btn-danger" type="button" onclick="confirmarDesativacao(${p.idPendencias})">Desativar</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <section class="empty-state">
                            <span class="eyebrow">Tudo em ordem</span>
                            <h3>Nenhuma pendência registrada</h3>
                            <p>As pendências vinculadas às diárias aparecerão aqui.</p>
                        </section>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
        <script>
            function toggleMenu() {
                document.getElementById("nav-links").classList.toggle("show");
            }
        </script>
    </body>
</html>
