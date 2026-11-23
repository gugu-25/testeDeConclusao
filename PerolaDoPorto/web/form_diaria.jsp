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
                                <label for="idQuarto">Quarto disponível</label>
                                <select id="idQuarto" name="idQuarto" required>
                                    <option value="">Selecione</option>
                                    <c:forEach var="q" items="${quartosDAO.lista}">
                                        <c:if test="${q.status==1}">
                                            <option value="${q.idQuarto}">Quarto ${q.numero} — ${q.descricao}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
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
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Adicionar quarto</button>
                        </div>
                    </form>
                </div>
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
        </script>
    </body>
</html>
