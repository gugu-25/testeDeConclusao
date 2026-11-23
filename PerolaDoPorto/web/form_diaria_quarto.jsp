<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quartos da diária</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarRemocao(idDiaria, idQuarto, numero) {
                appConfirm('Desvincular o quarto ' + numero + ' desta diária?', function () {
                    window.location.href = 'gerenciar_diaria_quarto.do?acao=desvincular&idDiaria='
                        + idDiaria + '&idQuarto=' + idQuarto;
                }, {title: 'Desvincular quarto', type: 'error', confirmText: 'Desvincular'});
            }
        </script>
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="hero">
                    <div><span class="eyebrow">Diária ${idDiaria}</span><h2>Quartos vinculados</h2></div>
                    <a href="gerenciar_diaria.do?acao=listarTodos" class="btn btn-warning">Voltar às diárias</a>
                </div>
                <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                    <div class="form-card">
                        <form method="POST" action="gerenciar_diaria_quarto.do">
                            <input type="hidden" name="acao" value="vincular">
                            <input type="hidden" name="idDiaria" value="${idDiaria}">
                            <div class="form-grid">
                                <div class="form-field full">
                                    <label for="idQuarto">Quarto disponível</label>
                                    <select id="idQuarto" name="idQuarto" required>
                                        <option value="">Selecione</option>
                                        <c:forEach var="q" items="${diaria_quarto.quartosNaoVinculados}">
                                            <option value="${q.idQuarto}">Quarto ${q.numero} — <c:out value="${q.descricao}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label for="valorAtual">Valor atual</label>
                                    <input type="number" id="valorAtual" name="valorAtual" min="0" step="0.01" required>
                                </div>
                                <div class="form-field">
                                    <label for="checkIn">Check-in</label>
                                    <input type="date" id="checkIn" name="checkIn" required>
                                </div>
                                <div class="form-field">
                                    <label for="checkOut">Check-out</label>
                                    <input type="date" id="checkOut" name="checkOut" required>
                                </div>
                            </div>
                            <div class="form-actions"><button class="btn btn-success" type="submit">Vincular quarto</button></div>
                        </form>
                    </div>
                </c:if>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>Quarto</th><th>Check-in</th><th>Check-out</th><th>Valor atual</th><th>Serviços</th><th>Opções</th></tr></thead>
                        <tbody>
                            <c:forEach var="dq" items="${diaria_quarto.quartosVinculados}">
                                <tr>
                                    <td>${dq.quarto.numero}</td>
                                    <td><fmt:formatDate value="${dq.checkIn}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatDate value="${dq.checkOut}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatNumber value="${dq.valorAtual}" type="currency" currencySymbol="R$ " /></td>
                                    <td><a class="btn btn-primary" href="gerenciar_diaria_quarto_servico.do?acao=gerenciar&idDiaria=${idDiaria}&idQuarto=${dq.quarto.idQuarto}">Gerenciar serviços</a></td>
                                    <td>
                                        <c:if test="${ulogado.perfil.nome=='Atendente' || ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                            <button class="btn btn-danger" type="button" onclick="confirmarRemocao(${idDiaria}, ${dq.quarto.idQuarto}, '${dq.quarto.numero}')">Desvincular</button>
                                        </c:if>
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
