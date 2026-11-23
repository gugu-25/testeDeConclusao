<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Serviços</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarExclusao(idServico, nome) {
                appConfirm(
                    'Deseja realmente desativar o serviço ' + nome + '?',
                    function () {
                        window.location.href = 'gerenciar_servico.do?acao=desativar&idServico=' + idServico;
                    },
                    {
                        title: 'Desativar serviço',
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
                        <h2>Lista de Serviços</h2>
                    </div>
                    <c:if test="${ulogado.perfil.nome=='Atendente' || ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                        <a href="form_servico.jsp" class="btn btn-primary">Novo cadastro</a>
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
                                        <th>Valor</th>
                                        <th>Status</th>
                                        <th>Opções</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${listarTodos}">
                                        <tr>
                                            <td>${s.idServico}</td>
                                            <td>${s.nome}</td>
                                            <td>R$ ${s.valor}</td>
                                            <td>
                                                <span class="status-pill ${s.status==1 ? 'active' : 'inactive'}">
                                                    <c:if test="${s.status==1}">Ativo</c:if>
                                                    <c:if test="${s.status==2}">Inativo</c:if>
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${ulogado.perfil.nome=='Atendente' || ulogado.perfil.nome=='Gerente' || ulogado.perfil.nome=='Administrador'}">
                                                    <a href="gerenciar_servico.do?acao=alterar&idServico=${s.idServico}" class="btn btn-primary">Editar</a>
                                                    <button class="btn btn-danger" onclick="confirmarExclusao(${s.idServico}, '${s.nome}')">Desativar</button>
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
                            <span class="empty-state-icon" aria-hidden="true">✦</span>
                            <span class="eyebrow">Experiência</span>
                            <h3>Deixe a estadia ainda mais especial</h3>
                            <p>Cadastre os serviços da pousada para deixar tudo pronto para receber seus hóspedes.</p>
                            <a href="form_servico.jsp" class="btn btn-primary">Adicionar um serviço<span aria-hidden="true"></span></a>
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
