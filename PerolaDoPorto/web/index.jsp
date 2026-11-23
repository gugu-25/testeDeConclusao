<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="theme-color" content="#183c38">
        <meta name="description" content="Pérola do Porto: acolhimento, conforto e momentos especiais à beira-mar.">
        <title>Pérola do Porto | Pousada</title>
        <link rel="stylesheet" href="css/estilo.css">
    </head>
    <body>
        <div class="page-shell">
            <c:choose>
                <c:when test="${not empty sessionScope.ulogado}">
                    <div class="banner-holder">
                        <%@include file="banner.jsp" %>
                    </div>
                    <%@include file="menu.jsp" %>
                    <main class="content">
                        <section class="hero dashboard-heading">
                            <div>
                                <span class="eyebrow">Painel da equipe · ${sessionScope.ulogado.perfil.nome}</span>
                                <h1>Olá, ${sessionScope.ulogado.nome}</h1>
                                <p>O que você gostaria de organizar hoje?</p>
                            </div>
                        </section>

                        <section class="dashboard-intro">
                            <div>
                                <span class="dashboard-icon">✦</span>
                                <div>
                                    <strong>A hospitalidade começa nos detalhes</strong>
                                    <p>Cuide de cada estadia com a atenção que faz a diferença.</p>
                                </div>
                            </div>
                            <span class="dashboard-caption">Pérola do Porto · Gestão</span>
                        </section>

                        <section class="actions-grid" aria-label="Funcionalidades">
                            <c:forEach var="menu" items="${sessionScope.ulogado.perfil.menus.menusVinculados}">
                                <c:if test="${menu.exibir==1 && menu.link!='index.jsp'}">
                                    <a class="action-tile" href="${menu.link}">
                                        <span>Pérola do Porto</span>
                                        <strong>${menu.nome}</strong>
                                        <small>Abrir módulo <b aria-hidden="true">→</b></small>
                                    </a>
                                </c:if>
                            </c:forEach>
                        </section>
                    </main>
                </c:when>
                <c:otherwise>
                    <nav class="landing-nav" aria-label="Navegação principal">
                        <a class="landing-nav-brand" href="index.jsp">Pérola <span>do Porto</span></a>
                        <div class="landing-nav-links">
                            <a href="#experiencia">A pousada</a>
                            <a class="btn btn-primary" href="form_login.jsp">Acesso da equipe</a>
                        </div>
                    </nav>

                    <main>
                        <section class="welcome-hero">
                            <div class="welcome-copy">
                                <span class="eyebrow">Seu refúgio à beira-mar</span>
                                <h1>O prazer de se sentir <em>em casa.</em></h1>
                                <p>Um lugar especial para desacelerar, aproveitar cada momento e colecionar boas lembranças.</p>
                                <a class="btn btn-primary btn-large" href="#experiencia">Conheça a pousada <span aria-hidden="true">↓</span></a>
                            </div>
                            <div class="welcome-note">
                                <span class="welcome-note-star" aria-hidden="true">✦</span>
                                <span>Hospitalidade que<br>fica na memória</span>
                            </div>
                        </section>

                        <section class="experience-section" id="experiencia">
                            <div class="section-heading">
                                <span class="eyebrow">Pérola do Porto</span>
                                <h2>Descanso com um toque de prazer.</h2>
                                <p>Preparamos cada detalhe para você aproveitar a estadia no seu ritmo.</p>
                            </div>
                            <div class="experience-grid">
                                <article class="experience-card">
                                    <span class="experience-number">01</span>
                                    <h3>Acolhimento de verdade</h3>
                                    <p>Atendimento atencioso para que você se sinta bem-vindo desde a chegada.</p>
                                </article>
                                <article class="experience-card">
                                    <span class="experience-number">02</span>
                                    <h3>Conforto para relaxar</h3>
                                    <p>Ambientes preparados para desacelerar e aproveitar uma pausa merecida.</p>
                                </article>
                                <article class="experience-card">
                                    <span class="experience-number">03</span>
                                    <h3>Momentos para guardar</h3>
                                    <p>Uma estadia tranquila, com espaço para criar lembranças especiais.</p>
                                </article>
                            </div>
                        </section>
                    </main>
                    <footer class="landing-footer">
                        <a class="landing-nav-brand" href="index.jsp">Pérola <span>do Porto</span></a>
                        <span>Hospitalidade feita com carinho.</span>
                        <a href="form_login.jsp">Acesso da equipe</a>
                    </footer>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>
