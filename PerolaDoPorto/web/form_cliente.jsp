<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cadastro de Cliente</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>

            <div class="content">
                <div class="form-card">
                    <div class="form-header">
                        <h3>Formulário de Cliente</h3>
                    </div>

                    <form method="POST" action="gerenciar_cliente.do">
                        <input type="hidden" name="idCliente" id="idCliente" value="${cliente.idCliente}"/>
                        <c:choose>
                            <c:when test="${cliente.idCliente > 0}">
                                <input type="hidden" name="acao" value="alterar"/>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="acao" value="cadastrar"/>
                            </c:otherwise>
                        </c:choose>

                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="nomeRazao">Nome/Razão Social</label>
                                <input type="text" name="nomeRazao" id="nomeRazao" value="${cliente.nomeRazao}" required/>
                            </div>

                            <div class="form-field">
                                <label for="cpfCnpj">CPF/CNPJ</label>
                                <input type="text" name="cpfCnpj" id="cpfCnpj" value="${cliente.cpfCnpj}" required/>
                            </div>

                            <div class="form-field">
                                <label for="rgIe">RG/IE</label>
                                <input type="text" name="rgIe" id="rgIe" value="${cliente.rgIe}"/>
                            </div>

                            <div class="form-field">
                                <label for="dataNascAbertura">Data de Nascimento/Abertura</label>
                                <input type="date" name="dataNascAbertura" id="dataNascAbertura" value="${cliente.dataNascAbertura}"/>
                            </div>

                            <div class="form-field">
                                <label for="tipo">Tipo</label>
                                <select name="tipo" id="tipo" required>
                                    <option value="">Selecione</option>
                                    <option value="1" <c:if test="${cliente.tipo==1}">selected</c:if>>Pessoa Física</option>
                                    <option value="2" <c:if test="${cliente.tipo==2}">selected</c:if>>Pessoa Jurídica</option>
                                </select>
                            </div>

                            <div class="form-field">
                                <label for="status">Status</label>
                                <select name="status" id="status" required>
                                    <option value="">Selecione</option>
                                    <option value="1" <c:if test="${cliente.status==1}">selected</c:if>>Ativo</option>
                                    <option value="2" <c:if test="${cliente.status==2}">selected</c:if>>Inativo</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Cadastrar</button>
                            <a href="gerenciar_cliente.do?acao=listarTodos" class="btn btn-warning">Voltar</a>
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
