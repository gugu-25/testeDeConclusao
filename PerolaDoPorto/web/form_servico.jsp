<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cadastro de Serviço</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>

            <div class="content">
                <div class="form-card">
                    <div class="form-header">
                        <h3>Formulário de Serviço</h3>
                    </div>

                    <form method="POST" action="gerenciar_servico.do">
                        <input type="hidden" name="idServico" id="idServico" value="${servico.idServico}"/>
                        <c:choose>
                            <c:when test="${servico.idServico > 0}">
                                <input type="hidden" name="acao" value="alterar"/>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="acao" value="cadastrar"/>
                            </c:otherwise>
                        </c:choose>

                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="nome">Nome do Serviço</label>
                                <input type="text" name="nome" id="nome" value="${servico.nome}" required/>
                            </div>

                            <div class="form-field">
                                <label for="valor">Valor</label>
                                <input type="number" min="0" step="0.01" name="valor" id="valor" value="${servico.valor}" required/>
                            </div>

                            <div class="form-field">
                                <label for="status">Status</label>
                                <select name="status" id="status" required>
                                    <option value="">Selecione</option>
                                    <option value="1" <c:if test="${servico.status==1}">selected</c:if>>Ativo</option>
                                    <option value="2" <c:if test="${servico.status==2}">selected</c:if>>Inativo</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Gravar</button>
                            <a href="gerenciar_servico.do?acao=listarTodos" class="btn btn-warning">Voltar</a>
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
        </script>
    </body>
</html>
