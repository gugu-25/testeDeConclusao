<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Serviços da diária</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="hero">
                    <div><span class="eyebrow">Diária ${idDiaria} · Quarto ${idQuarto}</span><h2>Serviços contratados</h2></div>
                    <div class="form-actions">
                        <a href="#carrinho" class="btn btn-primary cart-button" aria-label="Abrir carrinho">
                            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                <path d="M3 3h2l2.4 11.2a2 2 0 0 0 2 1.6h7.9a2 2 0 0 0 1.9-1.4L21 7H6" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
                                <circle cx="10" cy="19" r="1.5" fill="currentColor"/>
                                <circle cx="18" cy="19" r="1.5" fill="currentColor"/>
                            </svg>
                            <span>Carrinho</span>
                            <b class="cart-count">${quantidadeCarrinho}</b>
                        </a>
                        <a href="gerenciar_pendencias.do?acao=listarTodos" class="btn btn-success">Ver pendências</a>
                        <a href="gerenciar_diaria_quarto.do?acao=gerenciar&idDiaria=${idDiaria}" class="btn btn-warning">Voltar aos quartos</a>
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
                                                        <input type="hidden" name="idServico" value="${s.idServico}">
                                                        <button class="btn btn-primary" type="submit">Adicionar ao carrinho</button>
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
                <section class="form-card" id="carrinho">
                    <div class="form-header">
                        <h3 class="cart-heading">
                            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                <path d="M3 3h2l2.4 11.2a2 2 0 0 0 2 1.6h7.9a2 2 0 0 0 1.9-1.4L21 7H6" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
                                <circle cx="10" cy="19" r="1.5" fill="currentColor"/>
                                <circle cx="18" cy="19" r="1.5" fill="currentColor"/>
                            </svg>
                            Carrinho da diária
                        </h3>
                    </div>
                    <c:choose>
                        <c:when test="${not empty carrinhoServicos}">
                            <div class="table-wrap">
                                <table>
                                    <thead><tr><th>Serviço</th><th>Valor</th><th></th></tr></thead>
                                    <tbody>
                                        <c:forEach var="item" items="${carrinhoServicos}">
                                            <tr>
                                                <td><c:out value="${item.nome}"/></td>
                                                <td><fmt:formatNumber value="${item.valor}" type="currency" currencySymbol="R$ " /></td>
                                                <td>
                                                    <form method="POST" action="gerenciar_diaria_quarto_servico.do">
                                                        <input type="hidden" name="acao" value="vincular">
                                                        <input type="hidden" name="carrinhoAcao" value="remover">
                                                        <input type="hidden" name="idDiaria" value="${idDiaria}">
                                                        <input type="hidden" name="idQuarto" value="${idQuarto}">
                                                        <input type="hidden" name="idServico" value="${item.idServico}">
                                                        <button class="btn btn-danger" type="submit">Remover</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <tr>
                                            <th>Total</th>
                                            <th><fmt:formatNumber value="${totalCarrinho}" type="currency" currencySymbol="R$ " /></th>
                                            <th></th>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <form method="POST" action="gerenciar_diaria_quarto_servico.do" class="form-actions">
                                <input type="hidden" name="acao" value="vincular">
                                <input type="hidden" name="carrinhoAcao" value="confirmar">
                                <input type="hidden" name="idDiaria" value="${idDiaria}">
                                <input type="hidden" name="idQuarto" value="${idQuarto}">
                                <button class="btn btn-success" type="submit">Adicionar à conta</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <p>Seu carrinho está vazio. Adicione serviços para incluí-los na conta do hóspede.</p>
                        </c:otherwise>
                    </c:choose>
                </section>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>Serviço já adicionado à conta</th><th>Valor atual</th></tr></thead>
                        <tbody>
                            <c:forEach var="item" items="${diaria_quarto_servico.servicosVinculados}">
                                <tr>
                                    <td><c:out value="${item.servico.nome}"/></td>
                                    <td><fmt:formatNumber value="${item.valorServicoAtual}" type="currency" currencySymbol="R$ " /></td>
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
