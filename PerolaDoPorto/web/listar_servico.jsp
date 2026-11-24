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
            function confirmarDesativacao(idServico, nome) {
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

            function confirmarExclusao(formulario) {
                appConfirm(
                    'Deseja excluir permanentemente este serviço? Esta ação não pode ser desfeita.',
                    function () {
                        formulario.submit();
                    },
                    {
                        title: 'Excluir serviço',
                        type: 'error',
                        confirmText: 'Excluir',
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
                                                    <button class="btn btn-danger" type="button" onclick="confirmarDesativacao(${s.idServico}, '${s.nome}')">Desativar</button>
                                                    <form method="POST" action="gerenciar_servico.do" style="display:inline">
                                                        <input type="hidden" name="acao" value="excluir">
                                                        <input type="hidden" name="idServico" value="${s.idServico}">
                                                        <button class="btn btn-danger btn-icon" type="button" aria-label="Excluir permanentemente" title="Excluir permanentemente" onclick="confirmarExclusao(this.form)">
                                                            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                                                <path d="M3 6h18M8 6V4h8v2m3 0-1 14H6L5 6m4 4v6m6-6v6" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
                                                            </svg>
                                                        </button>
                                                    </form>
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
                            <span class="empty-state-icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" focusable="false">
                                    <path d="M12 3v18M3 12h18M6.5 6.5l11 11m0-11-11 11" fill="none" stroke="currentColor" stroke-linecap="round" stroke-width="1.5"/>
                                </svg>
                            </span>
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
