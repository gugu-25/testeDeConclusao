<%@page import="model.Usuario"%>
<%@page import="controller.GerenciarLogin"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>


<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<nav class="main-nav">
    <button type="button" class="mobile-menu-backdrop" aria-label="Fechar menu" onclick="toggleMenu()" tabindex="-1"></button>
    <ul id="nav-links">
        <li class="mobile-menu-header">
            <div class="mobile-menu-brand">
                <div>
                    <strong>Pérola do Porto</strong>
                    <small>Menu principal</small>
                </div>
            </div>
            <button type="button" class="mobile-menu-close" onclick="toggleMenu()" aria-label="Fechar menu">&times;</button>
        </li>
        <li class="mobile-menu-section">NAVEGAÇÃO</li>
        <c:if test="${ulogado!=null && ulogado.perfil!=null}">
            <c:forEach var="menu" items="${ulogado.perfil.menus.menusVinculados}">
                <c:if test="${menu.exibir==1}">
                    <li><a href="${menu.link}">${menu.nome}</a></li>
                </c:if>
            </c:forEach>
        </c:if>
        <li class="mobile-menu-footer">
            <div>
                <strong><c:out value="${ulogado.nome}"/></strong>
                <span><c:out value="${ulogado.perfil.nome}"/></span>
            </div>
            <a href="#" class="logout" onclick="confirmarSaida(event)">Sair</a>
        </li>
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
    function toggleMobileMenu() {
        toggleMenu();
    }

    function toggleMenu() {
        var menu = document.getElementById("nav-links");
        var brandButton = document.querySelector(".brand-menu-toggle");
        var backdrop = document.querySelector(".mobile-menu-backdrop");
        if (!menu) {
            return;
        }
        var aberto = menu.classList.toggle("show");
        if (brandButton) {
            brandButton.setAttribute("aria-expanded", aberto ? "true" : "false");
            brandButton.setAttribute("aria-label", aberto ? "Fechar menu" : "Abrir menu");
        }
        if (backdrop) {
            backdrop.classList.toggle("show", aberto);
        }
        document.body.classList.toggle("mobile-menu-open", aberto);
    }

    document.addEventListener("DOMContentLoaded", function () {
        var menu = document.getElementById("nav-links");
        if (!menu) {
            return;
        }
        menu.querySelectorAll("a").forEach(function (link) {
            link.addEventListener("click", function () {
                if (window.innerWidth <= 768) {
                    menu.classList.remove("show");
                    var backdrop = document.querySelector(".mobile-menu-backdrop");
                    if (backdrop) {
                        backdrop.classList.remove("show");
                    }
                    document.body.classList.remove("mobile-menu-open");
                    var brandButton = document.querySelector(".brand-menu-toggle");
                    if (brandButton) {
                        brandButton.setAttribute("aria-expanded", "false");
                        brandButton.setAttribute("aria-label", "Abrir menu");
                    }
                }
            });

            document.addEventListener("keydown", function (event) {
                if (event.key === "Escape" && menu.classList.contains("show")) {
                    toggleMenu();
                }
            });
        });

        window.addEventListener("resize", function () {
            if (window.innerWidth > 768 && menu.classList.contains("show")) {
                menu.classList.remove("show");
                document.body.classList.remove("mobile-menu-open");
                var backdrop = document.querySelector(".mobile-menu-backdrop");
                if (backdrop) {
                    backdrop.classList.remove("show");
                }
                var brandButton = document.querySelector(".brand-menu-toggle");
                if (brandButton) {
                    brandButton.setAttribute("aria-expanded", "false");
                    brandButton.setAttribute("aria-label", "Abrir menu");
                }
            }
        });
    });

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
