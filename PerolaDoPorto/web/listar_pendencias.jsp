<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pendências</title>
        <link rel="stylesheet" href="css/estilo.css?v=pendencias-cards">
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
            <main class="content pending-page">
                <div class="hero">
                    <div>
                        <span class="eyebrow">Acompanhamento da hospedagem</span>
                        <h2>Pendências</h2>
                        <p>Consulte os lançamentos separados por quarto.</p>
                    </div>
                    <c:if test="${ulogado.perfil.nome!='Auxiliar de limpeza'}">
                        <a href="gerenciar_pendencias.do?acao=nova" class="btn btn-primary">Nova pendência</a>
                    </c:if>
                </div>
                <c:choose>
                    <c:when test="${not empty listarTodos}">
                        <div class="pending-room-intro">
                            <span class="pending-room-intro-icon" aria-hidden="true">01</span>
                            <div>
                                <strong>Escolha um quarto</strong>
                                <p>Clique em um cartão para ver os serviços e valores pendentes.</p>
                            </div>
                        </div>
                        <div class="pending-room-grid" id="pending-room-grid" aria-label="Quartos com pendências"></div>
                        <section class="pending-room-details" id="pending-room-details" hidden>
                            <div class="pending-room-details-header">
                                <button class="btn btn-primary" id="pending-room-back" type="button">Voltar aos quartos</button>
                                <h3 id="pending-room-title"></h3>
                            </div>
                            <div class="table-wrap">
                                <p class="pending-mobile-table-hint">Deslize a tabela para o lado para ver todas as informações.</p>
                                <table>
                                    <thead>
                                        <tr><th>Descrição / serviço consumido</th><th>Unidades</th><th>Valor unitário</th><th>Total pendente</th><th>Total da diária pendente</th><th>Registro</th><th>Hóspede / diária</th><th>Status</th><th>Opções</th></tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${listarTodos}">
                                            <tr class="pending-row" data-room="${p.diariaQuartoServico.diariaQuarto.quarto.numero}">
                                                <td>${p.descricao}</td>
                                                <td class="pending-quantity">—</td>
                                                <td><fmt:formatNumber value="${p.diariaQuartoServico.servico.valor}" type="currency" currencySymbol="R$ " /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.status==1}">
                                                            <fmt:formatNumber value="${p.valor}" type="currency" currencySymbol="R$ " />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="0" type="currency" currencySymbol="R$ " />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.diariaQuartoServico.diariaQuarto.diaria.statusPagamento==1}">
                                                            <fmt:formatNumber value="${p.diariaQuartoServico.diariaQuarto.diaria.valorTotal}" type="currency" currencySymbol="R$ " />
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatDate value="${p.dataRegistro}" pattern="dd/MM/yyyy" /></td>
                                                <td><c:out value="${p.diariaQuartoServico.diariaQuarto.diaria.cliente.nomeRazao}"/> / diária ${p.diariaQuartoServico.diariaQuarto.diaria.idDiaria}</td>
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
                        </section>
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

            (function () {
                var rows = Array.prototype.slice.call(document.querySelectorAll(".pending-row"));
                var roomGrid = document.getElementById("pending-room-grid");
                var roomDetails = document.getElementById("pending-room-details");
                var roomTitle = document.getElementById("pending-room-title");
                var backButton = document.getElementById("pending-room-back");
                if (!rows.length || !roomGrid || !roomDetails || !roomTitle || !backButton) {
                    return;
                }

                rows.forEach(function (row) {
                    var description = row.cells[0].textContent;
                    var match = description.match(/\(x(\d+)\)/);
                    row.querySelector(".pending-quantity").textContent = match ? match[1] : "1";
                });

                var rooms = {};
                rows.forEach(function (row) {
                    var room = row.getAttribute("data-room");
                    rooms[room] = (rooms[room] || 0) + 1;
                });

                function showRooms() {
                    roomDetails.hidden = true;
                    roomGrid.hidden = false;
                }

                function showRoom(room) {
                    rows.forEach(function (row) {
                        row.hidden = row.getAttribute("data-room") !== room;
                    });
                    roomTitle.textContent = "Pendências do Quarto " + room;
                    roomGrid.hidden = true;
                    roomDetails.hidden = false;
                }

                Object.keys(rooms).sort(function (a, b) { return Number(a) - Number(b); }).forEach(function (room) {
                    var card = document.createElement("button");
                    var title = document.createElement("span");
                    var count = document.createElement("span");
                    card.type = "button";
                    card.className = "pending-room-card";
                    title.className = "pending-room-card-title";
                    title.textContent = "Quarto " + room;
                    count.className = "pending-room-card-count";
                    count.textContent = rooms[room] + (rooms[room] === 1 ? " pendência" : " pendências");
                    card.appendChild(title);
                    card.appendChild(count);
                    card.addEventListener("click", function () { showRoom(room); });
                    roomGrid.appendChild(card);
                });

                backButton.addEventListener("click", showRooms);
            })();
        </script>
    </body>
</html>
