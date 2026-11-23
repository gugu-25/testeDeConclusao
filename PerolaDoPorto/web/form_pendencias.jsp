<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cadastro de pendência</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="form-card">
                    <div class="form-header"><h3>${pendencias.idPendencias > 0 ? 'Editar pendência' : 'Nova pendência'}</h3></div>
                    <jsp:useBean class="model.DiariaDAO" id="diariasDAO"/>
                    <jsp:useBean class="model.QuartoDAO" id="quartosDAO"/>
                    <jsp:useBean class="model.ServicoDAO" id="servicosDAO"/>
                    <form method="POST" action="gerenciar_pendencias.do">
                        <input type="hidden" name="idPendencias" value="${pendencias.idPendencias}">
                        <input type="hidden" name="acao" value="${pendencias.idPendencias > 0 ? 'alterar' : 'cadastrar'}">
                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="descricao">Descrição</label>
                                <input type="text" id="descricao" name="descricao" maxlength="100" value="${pendencias.descricao}" required>
                            </div>
                            <div class="form-field">
                                <label for="valor">Valor</label>
                                <input type="number" id="valor" name="valor" min="0" step="0.01" value="${pendencias.valor}" required>
                            </div>
                            <div class="form-field">
                                <label for="dataRegistro">Data de registro</label>
                                <fmt:formatDate value="${pendencias.dataRegistro}" pattern="yyyy-MM-dd" var="dataRegistroFormatada"/>
                                <input type="date" id="dataRegistro" name="dataRegistro" value="${dataRegistroFormatada}">
                            </div>
                            <div class="form-field">
                                <label for="status">Status</label>
                                <select id="status" name="status" required>
                                    <option value="1" <c:if test="${pendencias.status==1 || pendencias.idPendencias==0}">selected</c:if>>Ativa</option>
                                    <option value="2" <c:if test="${pendencias.status==2}">selected</c:if>>Inativa</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label for="idDiaria">Diária</label>
                                <select id="idDiaria" name="idDiaria" required>
                                    <option value="">Selecione</option>
                                    <c:forEach var="d" items="${diariasDAO.lista}">
                                        <option value="${d.idDiaria}" <c:if test="${d.idDiaria==pendencias.diariaQuartoServico.diariaQuarto.diaria.idDiaria}">selected</c:if>>Diária ${d.idDiaria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-field">
                                <label for="idQuarto">Quarto</label>
                                <select id="idQuarto" name="idQuarto" required>
                                    <option value="">Selecione</option>
                                    <c:forEach var="q" items="${quartosDAO.lista}">
                                        <option value="${q.idQuarto}" <c:if test="${q.idQuarto==pendencias.diariaQuartoServico.diariaQuarto.quarto.idQuarto}">selected</c:if>>Quarto ${q.numero}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-field">
                                <label for="idServico">Serviço</label>
                                <select id="idServico" name="idServico" required>
                                    <option value="">Selecione</option>
                                    <c:forEach var="s" items="${servicosDAO.lista}">
                                        <option value="${s.idServico}" <c:if test="${s.idServico==pendencias.diariaQuartoServico.servico.idServico}">selected</c:if>>${s.nome}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Salvar pendência</button>
                            <a href="gerenciar_pendencias.do?acao=listarTodos" class="btn btn-warning">Voltar</a>
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
