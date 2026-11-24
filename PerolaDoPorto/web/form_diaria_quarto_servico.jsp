<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Serviços da diária</title>
        <link rel="stylesheet" href="css/estilo.css?v=cart-drawer">
        <script src="js/app-dialog.js"></script>
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="hero">
                    <div>
                        <span class="eyebrow">Diária ${idDiaria} · Quarto ${numeroQuarto}</span>
                        <c:choose>
                            <c:when test="${origemPendencias}"><h2>Adicionar pendências</h2></c:when>
                            <c:otherwise><h2>Serviços contratados</h2></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-primary cart-button" id="abrir-carrinho"
                                aria-haspopup="dialog" aria-controls="carrinho" aria-expanded="false">
                            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                <path d="M3 3h2l2.4 11.2a2 2 0 0 0 2 1.6h7.9a2 2 0 0 0 1.9-1.4L21 7H6" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
                                <circle cx="10" cy="19" r="1.5" fill="currentColor"/>
                                <circle cx="18" cy="19" r="1.5" fill="currentColor"/>
                            </svg>
                            <span>Carrinho</span>
                            <b class="cart-count">${quantidadeCarrinho}</b>
                        </button>
                        <a href="gerenciar_pendencias.do?acao=listarTodos" class="btn btn-success">Ver pendências</a>
                        <c:choose>
                            <c:when test="${origemPendencias}">
                                <a href="gerenciar_pendencias.do?acao=listarTodos" class="btn btn-warning">Voltar às pendências</a>
                            </c:when>
                            <c:otherwise>
                                <a href="gerenciar_diaria_quarto.do?acao=gerenciar&idDiaria=${idDiaria}" class="btn btn-warning">Voltar aos quartos</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <section class="form-card">
                    <div class="form-header"><h3>Serviços disponíveis</h3></div>
                    <c:choose>
                        <c:when test="${not empty diaria_quarto_servico.servicosNaoVinculados}">
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>Serviço</th><th>Valor</th><th></th></tr></thead>
                                    <tbody>
                                        <c:forEach var="s" items="${diaria_quarto_servico.servicosNaoVinculados}">
                                            <tr>
                                                <td><c:out value="${s.nome}"/></td>
                                                <td><fmt:formatNumber value="${s.valor}" type="currency" currencySymbol="R$ " /></td>
                                                <td>
                                                    <form method="POST" action="gerenciar_diaria_quarto_servico.do">
                                                        <input type="hidden" name="acao" value="vincular">
                                                        <input type="hidden" name="carrinhoAcao" value="adicionar">
                                                        <input type="hidden" name="idDiaria" value="${idDiaria}">
                                                        <input type="hidden" name="idQuarto" value="${idQuarto}">
                                                        <c:if test="${origemPendencias}"><input type="hidden" name="origem" value="pendencias"></c:if>
                                                        <input type="hidden" name="idServico" value="${s.idServico}">
                                                        <div class="cart-add-controls">
                                                            <label>
                                                                Unidades
                                                                <input type="number" name="quantidade" min="1" value="1" class="quantity-input" required>
                                                            </label>
                                                            <button class="btn btn-primary" type="submit">Adicionar</button>
                                                        </div>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p>Não há outros serviços disponíveis para este quarto.</p>
                        </c:otherwise>
                    </c:choose>
                </section>
                <dialog class="cart-drawer" id="carrinho" aria-labelledby="cart-title">
                    <div class="cart-drawer-header">
                        <h3 class="cart-heading" id="cart-title">
                            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                <path d="M3 3h2l2.4 11.2a2 2 0 0 0 2 1.6h7.9a2 2 0 0 0 1.9-1.4L21 7H6" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
                                <circle cx="10" cy="19" r="1.5" fill="currentColor"/>
                                <circle cx="18" cy="19" r="1.5" fill="currentColor"/>
                            </svg>
                            <c:choose><c:when test="${origemPendencias}">Carrinho de pendências</c:when><c:otherwise>Carrinho da diária</c:otherwise></c:choose>
                        </h3>
                        <button type="button" class="cart-drawer-close" id="fechar-carrinho"
                                aria-label="Fechar carrinho">&times;</button>
                    </div>
                    <c:choose>
                        <c:when test="${not empty carrinhoServicos}">
                            <div class="cart-drawer-items">
                                <c:forEach var="item" items="${carrinhoServicos}">
                                    <article class="cart-item">
                                        <div class="cart-item-header">
                                            <div>
                                                <h4><c:out value="${item.nome}"/></h4>
                                                <p><fmt:formatNumber value="${item.valor}" type="currency" currencySymbol="R$ " /> por unidade</p>
                                            </div>
                                            <form method="POST" action="gerenciar_diaria_quarto_servico.do">
                                                <input type="hidden" name="acao" value="vincular">
                                                <input type="hidden" name="carrinhoAcao" value="remover">
                                                <input type="hidden" name="idDiaria" value="${idDiaria}">
                                                <input type="hidden" name="idQuarto" value="${idQuarto}">
                                                <c:if test="${origemPendencias}"><input type="hidden" name="origem" value="pendencias"></c:if>
                                                <input type="hidden" name="idServico" value="${item.idServico}">
                                                <button class="cart-item-remove" type="submit" aria-label="Remover ${item.nome}">&times;</button>
                                            </form>
                                        </div>
                                        <div class="cart-item-details">
                                            <form method="POST" action="gerenciar_diaria_quarto_servico.do" class="cart-quantity-form">
                                                <input type="hidden" name="acao" value="vincular">
                                                <input type="hidden" name="carrinhoAcao" value="ajustar">
                                                <input type="hidden" name="idDiaria" value="${idDiaria}">
                                                <input type="hidden" name="idQuarto" value="${idQuarto}">
                                                <c:if test="${origemPendencias}"><input type="hidden" name="origem" value="pendencias"></c:if>
                                                <input type="hidden" name="idServico" value="${item.idServico}">
                                                <label for="quantidade-${item.idServico}">Unidades</label>
                                                <input id="quantidade-${item.idServico}" type="number" name="quantidade" min="1" value="${item.quantidade}" class="quantity-input" required>
                                                <button class="btn btn-primary" type="submit">Atualizar</button>
                                            </form>
                                            <div class="cart-item-subtotal">
                                                <span>Subtotal</span>
                                                <strong><fmt:formatNumber value="${item.valor * item.quantidade}" type="currency" currencySymbol="R$ " /></strong>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                            <div class="cart-drawer-footer">
                                <div class="cart-total-row">
                                    <span>Total do carrinho</span>
                                    <strong><fmt:formatNumber value="${totalCarrinho}" type="currency" currencySymbol="R$ " /></strong>
                                </div>
                                <form method="POST" action="gerenciar_diaria_quarto_servico.do">
                                    <input type="hidden" name="acao" value="vincular">
                                    <input type="hidden" name="carrinhoAcao" value="confirmar">
                                    <input type="hidden" name="idDiaria" value="${idDiaria}">
                                    <input type="hidden" name="idQuarto" value="${idQuarto}">
                                    <c:if test="${origemPendencias}"><input type="hidden" name="origem" value="pendencias"></c:if>
                                    <button class="btn btn-success cart-submit" type="submit">
                                        <c:choose><c:when test="${origemPendencias}">Lançar pendências</c:when><c:otherwise>Adicionar à conta</c:otherwise></c:choose>
                                    </button>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="cart-empty">
                                <span class="cart-empty-icon" aria-hidden="true">+</span>
                                <strong>Seu carrinho está vazio</strong>
                                <p>Adicione serviços para incluí-los na conta do hóspede.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </dialog>
            </main>
        </div>
        <script>
            function toggleMenu() {
                document.getElementById("nav-links").classList.toggle("show");
            }

            (function () {
                var drawer = document.getElementById("carrinho");
                var openButton = document.getElementById("abrir-carrinho");
                var closeButton = document.getElementById("fechar-carrinho");
                if (!drawer || !openButton || !closeButton) {
                    return;
                }

                openButton.addEventListener("click", function () {
                    if (!drawer.open) {
                        drawer.showModal();
                        openButton.setAttribute("aria-expanded", "true");
                    }
                });

                closeButton.addEventListener("click", function () {
                    drawer.close();
                });

                drawer.addEventListener("click", function (event) {
                    if (event.target === drawer) {
                        drawer.close();
                    }
                });

                drawer.addEventListener("close", function () {
                    openButton.setAttribute("aria-expanded", "false");
                    openButton.focus();
                });
            })();
        </script>
    </body>
</html>
