<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Selecionar quartos</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="hero">
                    <div>
                        <span class="eyebrow">Nova hospedagem</span>
                        <h2>Quartos da diária</h2>
                        <p>Hóspede: ${sessionScope.diaria.cliente.nomeRazao}</p>
                    </div>
                </div>
                <div class="form-card">
                    <jsp:useBean class="model.QuartoDAO" id="quartosDAO"/>
                    <form method="GET" action="gerenciar_diaria.do">
                        <input type="hidden" name="acao" value="adicionarQuarto">
                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="tipoQuarto">Tipo do quarto</label>
                                <select id="tipoQuarto" required>
                                    <option value="">Escolha o tipo do quarto</option>
                                    <option value="1">Standard · finais 01 a 07 por andar</option>
                                    <option value="2">Luxo · finais 08 a 14 por andar</option>
                                    <option value="3">Suíte · finais 15 a 20 por andar</option>
                                </select>
                            </div>

                            <fieldset class="room-picker form-field full" id="diaria-room-picker">
                                <legend>Seleção do quarto</legend>
                                <p class="room-picker-hint" id="diaria-room-picker-hint">
                                    Escolha primeiro o tipo. Os quartos disponíveis aparecerão por andar.
                                </p>
                                <input type="hidden" name="idQuarto" id="idQuarto" value="">

                                <div class="room-legend" aria-label="Legenda">
                                    <span><i class="room-status-dot available"></i> Disponível</span>
                                </div>

                                <div id="diaria-room-map" hidden>
                                    <div class="floor-tabs" role="group" aria-label="Selecione o andar">
                                        <c:forEach var="andar" begin="1" end="7">
                                            <c:set var="inicioAndar" value="${andar == 1 ? 101 : andar * 100}"/>
                                            <c:set var="fimAndar" value="${inicioAndar + 19}"/>
                                            <button type="button"
                                                    class="${andar == 1 ? 'floor-tab active' : 'floor-tab'}"
                                                    data-floor="${andar}"
                                                    aria-pressed="${andar == 1}">
                                                <span>${andar}º andar</span>
                                                <small>${inicioAndar}–${fimAndar}</small>
                                            </button>
                                        </c:forEach>
                                    </div>

                                    <c:forEach var="andar" begin="1" end="7">
                                        <c:set var="inicioAndar" value="${andar == 1 ? 101 : andar * 100}"/>
                                        <c:set var="fimAndar" value="${inicioAndar + 19}"/>
                                        <section class="${andar == 1 ? 'floor-panel' : 'floor-panel is-hidden'}"
                                                 data-floor-panel="${andar}"
                                                 aria-label="${andar}º andar"
                                                 aria-hidden="${andar != 1}">
                                            <div class="floor-panel-heading">
                                                <div>
                                                    <strong>${andar}º andar</strong>
                                                    <span>Quartos ${inicioAndar} a ${fimAndar}</span>
                                                </div>
                                                <span class="floor-capacity" data-room-count>Selecione o tipo</span>
                                            </div>
                                            <div class="room-grid">
                                                <c:forEach var="q" items="${quartosDAO.lista}">
                                                    <c:if test="${q.status==1 and q.numero ge inicioAndar and q.numero le fimAndar}">
                                                        <button type="button"
                                                                class="room-option"
                                                                data-room-id="${q.idQuarto}"
                                                                data-room-number="${q.numero}"
                                                                data-room-type="${q.tipo}"
                                                                aria-pressed="false">
                                                            <span class="room-option-icon" aria-hidden="true">⌂</span>
                                                            <span>Quarto</span>
                                                            <strong>${q.numero}</strong>
                                                            <span class="room-option-status">Disponível</span>
                                                        </button>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </section>
                                    </c:forEach>
                                </div>

                                <div class="room-picker-footer">
                                    <span class="room-selection-message" id="diaria-room-selection-message" aria-live="polite">
                                        Nenhum quarto selecionado
                                    </span>
                                    <span class="room-selection-error" id="diaria-room-selection-error" role="alert" hidden>
                                        Selecione um quarto para continuar.
                                    </span>
                                </div>
                            </fieldset>

                            <div class="form-field">
                                <label for="checkIn">Check-in</label>
                                <input type="date" id="checkIn" name="checkIn" required>
                            </div>
                            <div class="form-field">
                                <label for="checkOut">Check-out</label>
                                <input type="date" id="checkOut" name="checkOut" required>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Adicionar quarto</button>
                        </div>
                    </form>
                </div>
                <c:if test="${not empty sessionScope.diaria.carrinhoQuarto}">
                    <h3>Quartos selecionados</h3>
                    <div class="table-wrap">
                        <table>
                            <thead><tr><th>Quarto</th><th>Check-in</th><th>Check-out</th><th>Valor atual</th><th></th></tr></thead>
                            <tbody>
                                <c:forEach var="item" items="${sessionScope.diaria.carrinhoQuarto}" varStatus="loop">
                                    <tr>
                                        <td>${item.quarto.numero}</td>
                                        <td>${item.checkIn}</td>
                                        <td>${item.checkOut}</td>
                                        <td>R$ ${item.valorAtual}</td>
                                        <td><a class="btn btn-danger" href="gerenciar_diaria.do?acao=retirarQuarto&index=${loop.index}">Remover</a></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
                <div class="form-actions">
                    <a href="form_finalizar_diaria.jsp" class="btn btn-success">Continuar para os dados da diária</a>
                    <a href="gerenciar_diaria.do?acao=listarTodos" class="btn btn-warning">Cancelar</a>
                </div>
            </main>
        </div>
        <script>
            function toggleMenu() {
                document.getElementById("nav-links").classList.toggle("show");
            }

            (function () {
                var typeSelect = document.getElementById("tipoQuarto");
                var picker = document.getElementById("diaria-room-picker");
                var idQuarto = document.getElementById("idQuarto");
                var roomMap = document.getElementById("diaria-room-map");
                var hint = document.getElementById("diaria-room-picker-hint");
                var message = document.getElementById("diaria-room-selection-message");
                var error = document.getElementById("diaria-room-selection-error");
                var form = idQuarto.form;
                var checkIn = document.getElementById("checkIn");
                var checkOut = document.getElementById("checkOut");

                var typeNames = {
                    "1": "Standard",
                    "2": "Luxo",
                    "3": "Suíte"
                };
                var typeRanges = {
                    "1": "finais 01 a 07",
                    "2": "finais 08 a 14",
                    "3": "finais 15 a 20"
                };

                function activateFloor(tab) {
                    picker.querySelectorAll(".floor-tab").forEach(function (item) {
                        var active = item === tab;
                        item.classList.toggle("active", active);
                        item.setAttribute("aria-pressed", active);
                    });

                    picker.querySelectorAll(".floor-panel").forEach(function (panel) {
                        var active = panel.getAttribute("data-floor-panel") === tab.getAttribute("data-floor");
                        panel.setAttribute("aria-hidden", active ? "false" : "true");
                        panel.classList.toggle("is-hidden", !active);
                    });
                }

                function filterRoomsByType() {
                    var selectedType = typeSelect.value;
                    idQuarto.value = "";
                    message.textContent = "Nenhum quarto selecionado";
                    error.hidden = true;
                    roomMap.hidden = !selectedType;

                    picker.querySelectorAll(".room-option").forEach(function (room) {
                        var matchesType = room.getAttribute("data-room-type") === selectedType;
                        room.hidden = !matchesType;
                        room.classList.remove("selected");
                        room.setAttribute("aria-pressed", "false");
                        room.tabIndex = matchesType ? 0 : -1;
                    });

                    picker.querySelectorAll(".floor-panel").forEach(function (panel) {
                        var roomsOfType = panel.querySelectorAll(
                            '.room-option[data-room-type="' + selectedType + '"]'
                        );
                        var visibleCount = 0;

                        roomsOfType.forEach(function () {
                            visibleCount++;
                        });

                        panel.querySelector("[data-room-count]").textContent = selectedType
                            ? visibleCount + (visibleCount === 1 ? " quarto disponível" : " quartos disponíveis")
                            : "Selecione o tipo";
                    });

                    hint.textContent = selectedType
                        ? typeNames[selectedType] + ": quartos com " + typeRanges[selectedType] + " em cada andar."
                        : "Escolha primeiro o tipo. Os quartos disponíveis aparecerão por andar.";

                    if (selectedType) {
                        var firstAvailableTab = null;
                        picker.querySelectorAll(".floor-tab").forEach(function (tab) {
                            if (firstAvailableTab) {
                                return;
                            }
                            var panel = picker.querySelector(
                                '.floor-panel[data-floor-panel="' + tab.getAttribute("data-floor") + '"]'
                            );
                            if (panel && panel.querySelector(
                                    '.room-option[data-room-type="' + selectedType + '"]:not([hidden])')) {
                                firstAvailableTab = tab;
                            }
                        });
                        if (firstAvailableTab) {
                            activateFloor(firstAvailableTab);
                        }
                    }
                }

                typeSelect.addEventListener("change", filterRoomsByType);

                picker.querySelectorAll(".floor-tab").forEach(function (tab) {
                    tab.addEventListener("click", function () {
                        activateFloor(tab);
                    });
                });

                picker.querySelectorAll(".room-option").forEach(function (room) {
                    room.addEventListener("click", function () {
                        idQuarto.value = room.getAttribute("data-room-id");

                        picker.querySelectorAll(".room-option").forEach(function (item) {
                            var selected = item === room;
                            item.classList.toggle("selected", selected);
                            item.setAttribute("aria-pressed", selected);
                        });

                        message.textContent = "Quarto " + room.getAttribute("data-room-number") + " selecionado";
                        error.hidden = true;
                    });
                });

                if (checkIn && checkOut) {
                    var hoje = new Date();
                    var hojeISO = hoje.toISOString().split("T")[0];
                    checkIn.min = hojeISO;
                    checkOut.min = hojeISO;

                    checkIn.addEventListener("change", function () {
                        checkOut.min = checkIn.value || hojeISO;
                        if (checkOut.value && checkOut.value < checkIn.value) {
                            checkOut.value = "";
                        }
                    });
                }

                form.addEventListener("submit", function (event) {
                    if (!idQuarto.value) {
                        event.preventDefault();
                        error.hidden = false;
                        if (!typeSelect.value) {
                            typeSelect.focus();
                        } else {
                            var firstRoom = picker.querySelector(".room-option:not([hidden])");
                            if (firstRoom) {
                                firstRoom.focus();
                            }
                        }
                    }
                });

                filterRoomsByType();
            }());
        </script>
    </body>
</html>
