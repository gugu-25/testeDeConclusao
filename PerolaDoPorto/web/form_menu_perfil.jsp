<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Permissões do perfil</title>
        <link rel="stylesheet" href="css/estilo.css">
        <script src="js/app-dialog.js"></script>
        <script>
            function confirmarDesvinculo(idMenu, idPerfil, nome) {
                appConfirm('Remover "' + nome + '" deste perfil?', function () {
                    window.location.href = 'gerenciar_menu_perfil.do?acao=desvincular&idMenu='
                        + idMenu + '&idPerfil=' + idPerfil;
                }, {title: 'Remover permissão', type: 'error', confirmText: 'Remover'});
            }
        </script>
    </head>
    <body>
        <div class="page-shell">
            <%@include file="banner.jsp" %>
            <%@include file="menu.jsp" %>
            <main class="content">
                <div class="hero">
                    <div>
                        <span class="eyebrow">Controle de acesso</span>
                        <h2>Permissões: ${perfil.nome}</h2>
                    </div>
                    <a href="gerenciar_perfil.do?acao=listarTodos" class="btn btn-warning">Voltar aos perfis</a>
                </div>
                <div class="form-card">
                    <form method="POST" action="gerenciar_menu_perfil.do">
                        <input type="hidden" name="idPerfil" value="${perfil.idPerfil}">
                        <input type="hidden" name="acao" value="vincular">
                        <div class="form-grid">
                            <div class="form-field full">
                                <label for="idMenu">Adicionar menu ou permissão</label>
                                <select id="idMenu" name="idMenu" required>
                                    <option value="">Selecione</option>
                                    <c:forEach var="m" items="${perfil.menus.menusNaoVinculados}">
                                        <option value="${m.idMenu}">${m.nome} — ${m.link}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Vincular</button>
                        </div>
                    </form>
                </div>
                <h3>Itens permitidos</h3>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>Nome</th><th>Destino</th><th>Exibição</th><th>Opções</th></tr></thead>
                        <tbody>
                            <c:forEach var="m" items="${perfil.menus.menusVinculados}">
                                <tr>
                                    <td>${m.nome}</td>
                                    <td>${m.link}</td>
                                    <td><c:choose><c:when test="${m.exibir==1}">Menu</c:when><c:otherwise>Permissão</c:otherwise></c:choose></td>
                                    <td>
                                        <button class="btn btn-danger" type="button"
                                                onclick="confirmarDesvinculo(${m.idMenu}, ${perfil.idPerfil}, '${m.nome}')">
                                            Desvincular
                                        </button>
                                    </td>
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
