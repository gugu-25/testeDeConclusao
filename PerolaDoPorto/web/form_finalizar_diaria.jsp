<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><c:choose><c:when test="${sessionScope.diaria.idDiaria > 0}">Editar diária</c:when><c:otherwise>Finalizar diária</c:otherwise></c:choose></title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="form-card">
                    <div class="form-header"><h3><c:choose><c:when test="${sessionScope.diaria.idDiaria > 0}">Editar diária</c:when><c:otherwise>Dados da diária</c:otherwise></c:choose></h3></div>
                    <form method="POST" action="gerenciar_diaria.do">
                        <input type="hidden" name="acao" value="gravar">
                        <input type="hidden" name="idDiaria" value="${sessionScope.diaria.idDiaria}">
                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="descricao">Descrição</label>
                                <input type="text" id="descricao" name="descricao" maxlength="100" value="<c:out value='${sessionScope.diaria.descricao}'/>" required>
                            </div>
                            <div class="form-field">
                                <label for="valorDiaria">Valor da diária</label>
                                <input type="number" id="valorDiaria" name="valorDiaria" min="0" step="0.01" value="${sessionScope.diaria.valorDiaria}" required>
                            </div>
                            <div class="form-field">
                                <label for="valorTotal">Valor total</label>
                                <input type="number" id="valorTotal" name="valorTotal" min="0" step="0.01" value="${sessionScope.diaria.valorTotal}" required>
                            </div>
                            <div class="form-field">
                                <label for="statusHospedagem">Status da hospedagem</label>
                                <select id="statusHospedagem" name="statusHospedagem" required>
                                    <option value="1" <c:if test="${sessionScope.diaria.statusHospedagem==1}">selected</c:if>>Ativa</option>
                                    <option value="2" <c:if test="${sessionScope.diaria.statusHospedagem==2}">selected</c:if>>Inativa</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label for="statusPagamento">Status do pagamento</label>
                                <select id="statusPagamento" name="statusPagamento" required>
                                    <option value="1" <c:if test="${sessionScope.diaria.statusPagamento==1}">selected</c:if>>Pendente</option>
                                    <option value="2" <c:if test="${sessionScope.diaria.statusPagamento==2}">selected</c:if>>Pago</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label for="feitoEm">Data do registro</label>
                                <fmt:formatDate value="${sessionScope.diaria.feitoEm}" pattern="yyyy-MM-dd" var="feitoEmFormatado"/>
                                <input type="date" id="feitoEm" name="feitoEm" value="${feitoEmFormatado}" required>
                            </div>
                            <div class="form-field">
                                <label for="pagoEm">Data do pagamento</label>
                                <fmt:formatDate value="${sessionScope.diaria.pagoEm}" pattern="yyyy-MM-dd" var="pagoEmFormatado"/>
                                <input type="date" id="pagoEm" name="pagoEm" value="${pagoEmFormatado}">
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success"><c:choose><c:when test="${sessionScope.diaria.idDiaria > 0}">Salvar alterações</c:when><c:otherwise>Gravar diária</c:otherwise></c:choose></button>
                            <c:choose>
                                <c:when test="${sessionScope.diaria.idDiaria > 0}">
                                    <a href="gerenciar_diaria.do?acao=listarTodos" class="btn btn-warning">Voltar às diárias</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="form_diaria.jsp" class="btn btn-warning">Voltar aos quartos</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
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
