<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Clientes</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarExclusao(idCliente, nome) {
                appConfirm(
                    'Deseja realmente desativar o cliente ' + nome + '?',
                    function () {
                        window.location.href = 'gerenciar_cliente.do?acao=desativar&idCliente=' + idCliente;
                    },
                    {
                        title: 'Desativar cliente',
                        type: 'error',
                        confirmText: 'Desativar',
                        cancelText: 'Cancelar'
                    }
                );
            }
        </script>
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>

            <div class="content">
                <div class="hero">
                    <div>
                        <h2>Lista de Clientes</h2>
                    </div>
                    <c:if test="${ulogado.perfil.nome=='Atendente' || ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                        <a href="form_cliente.jsp" class="btn btn-primary">Novo cadastro</a>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty listarTodos}">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nome</th>
                                        <th>CPF/CNPJ</th>
                                        <th>Tipo</th>
                                        <th>Status</th>
                                        <th>Opções</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${listarTodos}">
                                        <tr>
                                            <td>${c.idCliente}</td>
                                            <td>${c.nomeRazao}</td>
                                            <td>${c.cpfCnpj}</td>
                                            <td>
                                                <c:if test="${c.tipo==1}">Pessoa Física</c:if>
                                                <c:if test="${c.tipo==2}">Pessoa Jurídica</c:if>
                                            </td>
                                            <td>
                                                <span class="status-pill ${c.status==1 ? 'active' : 'inactive'}">
                                                    <c:if test="${c.status==1}">Ativo</c:if>
                                                    <c:if test="${c.status==2}">Inativo</c:if>
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${ulogado.perfil.nome=='Atendente' || ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                                    <a href="gerenciar_cliente.do?acao=alterar&idCliente=${c.idCliente}" class="btn btn-primary">Editar</a>
                                                </c:if>
                                                <c:if test="${ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                                    <button class="btn btn-danger" onclick="confirmarExclusao(${c.idCliente}, '${c.nomeRazao}')">Desativar</button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <section class="empty-state">
                            <span class="empty-state-icon" aria-hidden="true">♡</span>
                            <span class="eyebrow">Relacionamento</span>
                            <h3>Seu primeiro cliente está esperando</h3>
                            <p>Adicione um cliente para manter os dados de hospedagem organizados em um só lugar.</p>
                            <a href="form_cliente.jsp" class="btn btn-primary">Cadastrar cliente<span aria-hidden="true"></span></a>
                        </section>
                    </c:otherwise>
                </c:choose>
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
