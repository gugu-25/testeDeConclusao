<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Diárias</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarDesativacao(id) {
                appConfirm('Desativar a diária ' + id + '?', function () {
                    window.location.href = 'gerenciar_diaria.do?acao=desativar&idDiaria=' + id;
                }, {title: 'Desativar diária', type: 'error', confirmText: 'Desativar'});
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
                        <span class="eyebrow">Hospedagens</span>
                        <h2>Diárias</h2>
                    </div>
                </div>
                <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                    <div class="form-card">
                        <form method="GET" action="gerenciar_diaria.do">
                            <input type="hidden" name="acao" value="novaDiaria">
                            <div class="form-grid">
                                <div class="form-field full">
                                    <label for="idCliente">Hóspede</label>
                                    <jsp:useBean class="model.ClienteDAO" id="clientesDAO"/>
                                    <select id="idCliente" name="idCliente" required>
                                        <option value="">Selecione o hóspede para iniciar a diária</option>
                                        <c:forEach var="cliente" items="${clientesDAO.lista}">
                                            <c:if test="${cliente.status==1}">
                                                <option value="${cliente.idCliente}">${cliente.nomeRazao}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Iniciar diária</button>
                            </div>
                        </form>
                    </div>
                </c:if>
                <c:choose>
                    <c:when test="${not empty listarTodos}">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr><th>Diária</th><th>Hóspede</th><th>Responsável</th><th>Feita em</th><th>Total</th><th>Hospedagem</th><th>Pagamento</th><th>Opções</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="d" items="${listarTodos}">
                                        <tr>
                                            <td>${d.idDiaria}</td>
                                            <td><c:out value="${d.cliente.nomeRazao}"/></td>
                                            <td><c:out value="${d.usuario.nome}"/></td>
                                            <td><fmt:formatDate value="${d.feitoEm}" pattern="dd/MM/yyyy" /></td>
                                            <td><fmt:formatNumber value="${d.valorTotal}" type="currency" currencySymbol="R$ " /></td>
                                            <td><c:choose><c:when test="${d.statusHospedagem==1}">Ativa</c:when><c:otherwise>Inativa</c:otherwise></c:choose></td>
                                            <td><c:choose><c:when test="${d.statusPagamento==1}">Pendente</c:when><c:otherwise>Pago</c:otherwise></c:choose></td>
                                            <td>
                                                <a class="btn btn-primary" href="gerenciar_diaria_quarto.do?acao=gerenciar&idDiaria=${d.idDiaria}">Quartos</a>
                                                <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                                    <a class="btn btn-warning" href="gerenciar_diaria.do?acao=alterar&idDiaria=${d.idDiaria}">Editar</a>
                                                    <button class="btn btn-danger" type="button" onclick="confirmarDesativacao(${d.idDiaria})">Desativar</button>
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
                            <span class="eyebrow">Hospedagens</span>
                            <h3>Nenhuma diária cadastrada</h3>
                            <p>As diárias registradas para os hóspedes aparecerão aqui.</p>
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
