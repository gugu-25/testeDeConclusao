<%@page import="model.Usuario"%>
<%@page import="controller.GerenciarLogin"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<nav class="main-nav">
    <button type="button" class="menu-icon" onclick="toggleMenu()" aria-controls="nav-links" aria-label="Alternar menu">☰</button>
    <ul id="nav-links">
        <c:if test="${ulogado!=null && ulogado.perfil!=null}">
            <c:forEach var="menu" items="${ulogado.perfil.menus.menusVinculados}">
                <c:if test="${menu.exibir==1}">
                    <li><a href="${menu.link}">${menu.nome}</a></li>
                </c:if>
            </c:forEach>
        </c:if>
    </ul>
    <div class="user-panel">
        <span>
            Bem-vindo(a), <c:if test="${ulogado!=null && ulogado.perfil!=null}">
                <strong class="user-role">${ulogado.perfil.nome}</strong>
            </c:if>
            <c:if test="${ulogado!=null}">${ulogado.nome}</c:if>
           
        </span>
        <a href="#" class="logout" onclick="confirmarSaida(event)">Sair</a>
    </div>
</nav>
<script>
    function confirmarSaida(event) {
        event.preventDefault();
        appConfirm(
            'Deseja encerrar sua sessão na Pérola do Porto?',
            function () {
                window.location.href = 'gerenciar_login.do';
            },
            {
                title: 'Sair do sistema',
                type: 'error',
                confirmText: 'Sair',
                cancelText: 'Continuar aqui'
            }
        );
    }
</script>
