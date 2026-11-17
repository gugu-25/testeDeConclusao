<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (request.getAttribute("statusQuartos") == null) {
        response.sendRedirect(request.getContextPath() + "/gerenciar_quarto.do?acao=novo");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cadastro de Quarto</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>

            <div class="content">
                <div class="form-card">
                    <div class="form-header">
                        <h3>Formulário de Quarto</h3>
                    </div>

                    <form method="POST" action="gerenciar_quarto.do">
                        <input type="hidden" name="idQuarto" id="idQuarto" value="${quarto.idQuarto}"/>

                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="tipo">Tipo do quarto</label>
                                <select name="tipo" id="tipo" required>
                                    <option value="">Escolha o tipo antes de selecionar o quarto</option>
                                    <option value="1" <c:if test="${quarto.tipo==1}">selected</c:if>>Standard · finais 01 a 07 por andar</option>
                                    <option value="2" <c:if test="${quarto.tipo==2}">selected</c:if>>Luxo · finais 08 a 14 por andar</option>
                                    <option value="3" <c:if test="${quarto.tipo==3}">selected</c:if>>Suíte · finais 15 a 20 por andar</option>
                                </select>
                            </div>

                            <fieldset class="room-picker form-field full" id="room-picker">
                                <legend>Número do quarto</legend>
                                <p class="room-picker-hint" id="room-picker-hint">
                                    <c:choose>
                                        <c:when test="${quarto.tipo == 1}">Standard: quartos com finais 01 a 07 em cada andar.</c:when>
                                        <c:when test="${quarto.tipo == 2}">Luxo: quartos com finais 08 a 14 em cada andar.</c:when>
                                        <c:when test="${quarto.tipo == 3}">Suítes: quartos com finais 15 a 20 em cada andar.</c:when>
                                        <c:otherwise>Escolha primeiro o tipo. Os quartos correspondentes aparecerão por andar.</c:otherwise>
                                    </c:choose>
                                    Quartos ocupados ou em manutenção ficam identificados.
                                </p>
                                <input type="hidden" name="numero" id="numero" value="${quarto.numero}"/>

                                <div class="room-legend" aria-label="Legenda de status">
                                    <span><i class="room-status-dot available"></i> Disponível</span>
                                    <span><i class="room-status-dot occupied"></i> Ocupado</span>
                                    <span><i class="room-status-dot maintenance"></i> Manutenção</span>
                                </div>

                                <button type="button" class="room-map-toggle" id="room-map-toggle" aria-expanded="true" aria-controls="room-map-content" <c:if test="${quarto.numero == 0 or quarto.tipo == 0}">hidden</c:if>>
                                    <span id="room-map-toggle-label"><c:choose><c:when test="${quarto.numero > 0}">Recolher mapa</c:when><c:otherwise>Selecione um quarto para recolher o mapa</c:otherwise></c:choose></span>
                                    <span class="room-map-toggle-icon" aria-hidden="true">⌃</span>
                                </button>

                                <div class="room-map-summary" id="room-map-summary" hidden>
                                    <span class="room-summary-icon" aria-hidden="true">⌂</span>
                                    <span id="room-map-summary-text"><c:if test="${quarto.numero > 0}">Quarto ${quarto.numero} selecionado</c:if></span>
                                </div>

                                <div id="room-map-content" <c:if test="${quarto.tipo == 0}">hidden</c:if>>
                                <div class="floor-tabs" role="group" aria-label="Selecione o andar">
                                    <c:forEach var="andar" begin="1" end="7">
                                        <c:set var="inicioAndar" value="${andar == 1 ? 101 : andar * 100}"/>
                                        <c:set var="fimAndar" value="${inicioAndar + 19}"/>
                                        <c:set var="andarAtivo" value="${(quarto.numero ge inicioAndar and quarto.numero le fimAndar) or (quarto.numero == 0 and andar == 1)}"/>
                                        <button type="button"
                                                class="${andarAtivo ? 'floor-tab active' : 'floor-tab'}"
                                                data-floor="${andar}"
                                                aria-pressed="${andarAtivo}">
                                            <span>${andar}º andar</span>
                                            <small>${inicioAndar}–${fimAndar}</small>
                                        </button>
                                    </c:forEach>
                                </div>

                                <c:forEach var="andar" begin="1" end="7">
                                    <c:set var="inicioAndar" value="${andar == 1 ? 101 : andar * 100}"/>
                                    <c:set var="fimAndar" value="${inicioAndar + 19}"/>
                                    <c:set var="andarAtivo" value="${(quarto.numero ge inicioAndar and quarto.numero le fimAndar) or (quarto.numero == 0 and andar == 1)}"/>
                                    <section class="${andarAtivo ? 'floor-panel' : 'floor-panel is-hidden'}"
                                             data-floor-panel="${andar}"
                                             aria-label="${andar}º andar, quartos ${inicioAndar} a ${fimAndar}"
                                             aria-hidden="${not andarAtivo}">
                                        <div class="floor-panel-heading">
                                            <div>
                                                <strong>${andar}º andar</strong>
                                                <span>Quartos ${inicioAndar} a ${fimAndar}</span>
                                            </div>
                                            <span class="floor-capacity" data-room-count>Escolha o tipo</span>
                                        </div>
                                        <div class="room-grid">
                                            <c:forEach var="numeroQuarto" begin="${inicioAndar}" end="${fimAndar}">
                                                <c:set var="statusQuarto" value="${statusQuartos[numeroQuarto]}"/>
                                                <c:set var="quartoSelecionado" value="${quarto.numero == numeroQuarto}"/>
                                                <c:set var="posicaoNoAndar" value="${andar == 1 ? numeroQuarto mod 100 : numeroQuarto mod 100 + 1}"/>
                                                <c:set var="tipoDistribuido" value="${posicaoNoAndar le 7 ? 1 : posicaoNoAndar le 14 ? 2 : 3}"/>
                                                <c:set var="tipoDoQuarto" value="${quartoSelecionado and quarto.tipo ge 1 ? quarto.tipo : tipoDistribuido}"/>
                                                <c:set var="quartoOcupado" value="${statusQuarto == 2}"/>
                                                <c:set var="quartoManutencao" value="${statusQuarto == 3}"/>
                                                <c:set var="quartoBloqueado" value="${(quartoOcupado or quartoManutencao) and not quartoSelecionado}"/>
                                                <button type="button"
                                                        class="room-option<c:if test='${quartoSelecionado}'> selected</c:if><c:if test='${quartoOcupado}'> occupied</c:if><c:if test='${quartoManutencao}'> maintenance</c:if><c:if test='${quartoSelecionado and tipoDistribuido != quarto.tipo}'> legacy-room</c:if>"
                                                        data-room-number="${numeroQuarto}"
                                                        data-room-type="${tipoDoQuarto}"
                                                        data-room-status="${quartoOcupado ? 'Ocupado' : quartoManutencao ? 'Em manutenção' : 'Disponível'}"
                                                        aria-pressed="${quartoSelecionado}"
                                                        <c:if test="${quartoBloqueado}">disabled="disabled" aria-disabled="true"</c:if>>
                                                    <span class="room-option-icon" aria-hidden="true"></span>
                                                    <span>Quarto</span>
                                                    <strong>${numeroQuarto}</strong>
                                                    <span class="room-option-status"><c:choose><c:when test="${quartoOcupado}">Ocupado</c:when><c:when test="${quartoManutencao}">Manutenção</c:when><c:otherwise>Disponível</c:otherwise></c:choose></span>
                                                </button>
                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:forEach>
                                </div>

                                <div class="room-picker-footer">
                                    <span class="room-selection-message" id="room-selection-message" aria-live="polite">
                                        <c:choose>
                                            <c:when test="${quarto.numero > 0}">Quarto ${quarto.numero} selecionado</c:when>
                                            <c:otherwise>Nenhum quarto selecionado</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="room-selection-error" id="room-selection-error" role="alert" hidden>Selecione um quarto para continuar.</span>
                                </div>
                            </fieldset>

                            <div class="form-field full">
                                <label for="descricao">Descrição</label>
                                <textarea name="descricao" id="descricao" required>${quarto.descricao}</textarea>
                            </div>

                            <div class="form-field">
                                <label for="valor">Valor da Diária</label>
                                <input type="number" step="0.01" name="valor" id="valor" value="${quarto.valor}" required/>
                            </div>

                            <div class="form-field">
                                <label for="status">Status</label>
                                <select name="status" id="status" required>
                                    <option value="">Selecione</option>
                                    <option value="1" <c:if test="${quarto.status==1}">selected</c:if>>Disponível</option>
                                    <option value="2" <c:if test="${quarto.status==2}">selected</c:if>>Ocupado</option>
                                    <option value="3" <c:if test="${quarto.status==3}">selected</c:if>>Manutenção</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Gravar</button>
                            <a href="gerenciar_quarto.do?acao=listarTodos" class="btn btn-warning">Voltar</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function toggleMenu() {
                var menu = document.getElementById("nav-links");
                menu.classList.toggle("show");
            }

            (function () {
                var picker = document.getElementById("room-picker");
                var typeSelect = document.getElementById("tipo");
                var numeroInput = document.getElementById("numero");
                var message = document.getElementById("room-selection-message");
                var error = document.getElementById("room-selection-error");
                var mapToggle = document.getElementById("room-map-toggle");
                var mapToggleLabel = document.getElementById("room-map-toggle-label");
                var mapSummary = document.getElementById("room-map-summary");
                var mapSummaryText = document.getElementById("room-map-summary-text");
                var mapContent = document.getElementById("room-map-content");
                var pickerHint = document.getElementById("room-picker-hint");
                var form = numeroInput.form;

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

                function filterRoomsByType() {
                    var selectedType = typeSelect.value;
                    var selectedRoom = picker.querySelector('.room-option[data-room-number="' + numeroInput.value + '"]');

                    if (selectedRoom && selectedRoom.getAttribute("data-room-type") !== selectedType) {
                        numeroInput.value = "";
                        selectedRoom = null;
                        picker.querySelectorAll(".room-option.selected").forEach(function (item) {
                            item.classList.remove("selected");
                            item.setAttribute("aria-pressed", "false");
                        });
                        message.textContent = "Nenhum quarto selecionado";
                        mapSummary.hidden = true;
                        mapToggle.hidden = true;
                        mapToggle.setAttribute("aria-expanded", "true");
                        mapToggleLabel.textContent = "Recolher mapa";
                        mapContent.hidden = !selectedType;
                    }

                    picker.querySelectorAll(".room-option").forEach(function (room) {
                        var matchesType = room.getAttribute("data-room-type") === selectedType;
                        room.hidden = !matchesType;
                        room.tabIndex = matchesType && !room.disabled ? 0 : -1;
                    });

                    picker.querySelectorAll(".floor-panel").forEach(function (panel) {
                        var roomsOfType = panel.querySelectorAll('.room-option[data-room-type="' + selectedType + '"]');
                        var hasRooms = roomsOfType.length > 0;
                        panel.classList.toggle("is-hidden", !hasRooms || panel.getAttribute("aria-hidden") === "true");
                        panel.querySelector("[data-room-count]").textContent = selectedType
                                ? roomsOfType.length + (roomsOfType.length === 1 ? " quarto deste tipo" : " quartos deste tipo")
                                : "Escolha o tipo";
                    });

                    mapContent.hidden = !selectedType;
                    pickerHint.textContent = selectedType
                            ? typeNames[selectedType] + ": quartos com " + typeRanges[selectedType] + " em cada andar. Quartos ocupados ou em manutenção ficam identificados."
                            : "Escolha primeiro o tipo. Os quartos correspondentes aparecerão por andar.";

                    if (selectedType && selectedRoom) {
                        mapToggle.hidden = false;
                    }
                }

                typeSelect.addEventListener("change", filterRoomsByType);

                mapToggle.addEventListener("click", function () {
                    var collapsed = mapToggle.getAttribute("aria-expanded") === "true";
                    mapToggle.setAttribute("aria-expanded", !collapsed);
                    mapContent.hidden = collapsed;
                    mapSummary.hidden = !collapsed;
                    mapToggleLabel.textContent = collapsed ? "Trocar quarto" : "Recolher mapa";
                });

                picker.querySelectorAll(".floor-tab").forEach(function (tab) {
                    tab.addEventListener("click", function () {
                        picker.querySelectorAll(".floor-tab").forEach(function (item) {
                            var active = item === tab;
                            item.classList.toggle("active", active);
                            item.setAttribute("aria-pressed", active);
                        });
                        picker.querySelectorAll(".floor-panel").forEach(function (panel) {
                            var active = panel.getAttribute("data-floor-panel") === tab.getAttribute("data-floor");
                            panel.setAttribute("aria-hidden", !active);
                            panel.classList.toggle("is-hidden", !active || !panel.querySelector('.room-option[data-room-type="' + typeSelect.value + '"]'));
                        });
                    });
                });

                picker.querySelectorAll(".room-option").forEach(function (room) {
                    room.addEventListener("click", function () {
                        numeroInput.value = room.getAttribute("data-room-number");
                        picker.querySelectorAll(".room-option").forEach(function (item) {
                            var selected = item === room;
                            item.classList.toggle("selected", selected);
                            item.setAttribute("aria-pressed", selected);
                        });
                        var status = room.getAttribute("data-room-status");
                        message.textContent = "Quarto " + numeroInput.value + " selecionado · " + status;
                        mapSummaryText.textContent = "Quarto " + numeroInput.value + " · " + status;
                        mapToggle.hidden = false;
                        error.hidden = true;
                    });
                });

                if (numeroInput.value) {
                    var selectedRoom = picker.querySelector('.room-option[data-room-number="' + numeroInput.value + '"]');
                    if (selectedRoom) {
                        var selectedStatus = selectedRoom.getAttribute("data-room-status");
                        mapSummaryText.textContent = "Quarto " + numeroInput.value + " · " + selectedStatus;
                        message.textContent = "Quarto " + numeroInput.value + " selecionado · " + selectedStatus;
                    }
                }

                filterRoomsByType();

                form.addEventListener("submit", function (event) {
                    if (!numeroInput.value) {
                        event.preventDefault();
                        error.hidden = false;
                        if (!typeSelect.value) {
                            typeSelect.focus();
                            return;
                        }
                        var firstAvailableRoom = picker.querySelector(".floor-panel:not(.is-hidden) .room-option:not([hidden]):not([disabled])");
                        if (firstAvailableRoom) {
                            firstAvailableRoom.focus();
                        } else {
                            typeSelect.focus();
                        }
                    }
                });
            }());
        </script>
    </body>
</html>
