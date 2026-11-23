<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cadastro de Usuário</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>

            <div class="content">
                <div class="form-card">
                    <div class="form-header">
                        <h3>Formulário de Usuário</h3>
                    </div>

                    <form method="POST" action="gerenciar_usuario.do">
                        <input type="hidden" name="idUsuario" id="idUsuario" value="${usuario.idUsuario}"/>
                        <c:choose>
                            <c:when test="${usuario.idUsuario > 0}">
                                <input type="hidden" name="acao" value="alterar"/>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="acao" value="cadastrar"/>
                            </c:otherwise>
                        </c:choose>

                        <div class="form-grid">
                            <div class="form-field">
                                <label for="nome">Nome</label>
                                <input type="text" name="nome" id="nome" value="${usuario.nome}" required/>
                            </div>

                            <div class="form-field">
                                <label for="login">Login</label>
                                <input type="text" name="login" id="login" value="${usuario.login}" required/>
                            </div>

                            <div class="form-field">
                                <label for="senha">Senha</label>
                                <input type="password" name="senha" id="senha" autocomplete="new-password" required/>
                            </div>

                            <div class="form-field">
                                <label for="dataNasc">Data de Nascimento</label>
                                <input type="date" name="dataNasc" id="dataNasc" value="${usuario.dataNasc}"/>
                            </div>

                            <div class="form-field">
                                <label for="idPerfil">Perfil</label>
                                <select name="idPerfil" id="idPerfil" required>
                                    <option value="">Selecione o perfil</option>
                                    <jsp:useBean class="model.PerfilDAO" id="pDAO"/>
                                    <c:forEach var="p" items="${pDAO.lista}">
                                        <option value="${p.idPerfil}" <c:if test="${p.idPerfil==usuario.perfil.idPerfil}">selected</c:if>>${p.nome}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-field">
                                <label for="status">Status</label>
                                <select name="status" id="status" required>
                                    <option value="">Selecione</option>
                                    <option value="1" <c:if test="${usuario.status==1}">selected</c:if>>Ativo</option>
                                    <option value="2" <c:if test="${usuario.status==2}">selected</c:if>>Inativo</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Gravar</button>
                            <a href="gerenciar_usuario.do?acao=listarTodos" class="btn btn-warning">Voltar</a>
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
