(function () {
    var dialogElement;

    if (!document.querySelector('link[href$="css/estilo.css"]')) {
        var stylesheet = document.createElement("link");
        stylesheet.rel = "stylesheet";
        stylesheet.href = "css/estilo.css";
        document.head.appendChild(stylesheet);
    }

    function createDialog() {
        if (dialogElement) {
            return;
        }

        if (!document.body) {
            var bodyElement = document.createElement("body");
            if (document.documentElement) {
                document.documentElement.appendChild(bodyElement);
            } else {
                return;
            }
        }

        dialogElement = document.createElement("div");
        dialogElement.className = "app-dialog-backdrop";
        dialogElement.setAttribute("aria-hidden", "true");
        dialogElement.innerHTML =
            '<div class="app-dialog" role="dialog" aria-modal="true" aria-labelledby="app-dialog-title">' +
            '  <div class="app-dialog-icon" aria-hidden="true"></div>' +
            '  <h2 id="app-dialog-title"></h2>' +
            '  <p class="app-dialog-message"></p>' +
            '  <div class="app-dialog-actions"></div>' +
            '</div>';
        document.body.appendChild(dialogElement);
    }

    function closeDialog() {
        if (!dialogElement) {
            return;
        }
        dialogElement.classList.remove("is-open");
        dialogElement.setAttribute("aria-hidden", "true");
    }

    function openDialog(message, options) {
        createDialog();

        var meaningfulContent = document.querySelector(
            ".page-shell, .auth-shell, .form-card, .content, main"
        );
        if (!meaningfulContent) {
            document.body.classList.add("app-dialog-standalone");
        }

        var dialog = dialogElement.querySelector(".app-dialog");
        var icon = dialogElement.querySelector(".app-dialog-icon");
        var title = dialogElement.querySelector("#app-dialog-title");
        var messageElement = dialogElement.querySelector(".app-dialog-message");
        var actions = dialogElement.querySelector(".app-dialog-actions");

        dialog.className = "app-dialog " + (options.type || "info");
        icon.textContent = options.type === "success" ? "✓" :
            options.type === "error" ? "!" : "i";
        title.textContent = options.title || (options.type === "success" ? "Operação concluída" :
            options.type === "error" ? "Não foi possível concluir" : "Aviso");
        messageElement.textContent = message;
        actions.innerHTML = "";

        if (options.confirm) {
            var cancelButton = document.createElement("button");
            cancelButton.type = "button";
            cancelButton.className = "app-dialog-button app-dialog-button-secondary";
            cancelButton.textContent = options.cancelText || "Cancelar";

            var confirmButton = document.createElement("button");
            confirmButton.type = "button";
            confirmButton.className = "app-dialog-button " +
                (options.type === "error"
                    ? "app-dialog-button-danger"
                    : "app-dialog-button-primary");
            confirmButton.textContent = options.confirmText || "Confirmar";

            cancelButton.addEventListener("click", closeDialog);
            confirmButton.addEventListener("click", function () {
                closeDialog();
                if (typeof options.onConfirm === "function") {
                    options.onConfirm();
                }
            });

            actions.appendChild(cancelButton);
            actions.appendChild(confirmButton);
        } else {
            var okButton = document.createElement("button");
            okButton.type = "button";
            okButton.className = "app-dialog-button app-dialog-button-primary";
            okButton.textContent = "OK";
            okButton.addEventListener("click", function () {
                closeDialog();
                if (options.redirect) {
                    window.location.href = options.redirect;
                } else if (options.back) {
                    window.history.back();
                }
            });
            actions.appendChild(okButton);
        }

        dialogElement.classList.add("is-open");
        dialogElement.setAttribute("aria-hidden", "false");
        document.body.classList.add("has-app-dialog");
        var focusedButton = actions.querySelector("button");
        if (focusedButton) {
            focusedButton.focus();
        }
    }

    window.appMessage = function (message, options) {
        openDialog(message, options || {});
    };

    window.appConfirm = function (message, onConfirm, options) {
        var dialogOptions = options || {};
        dialogOptions.confirm = true;
        dialogOptions.onConfirm = onConfirm;
        openDialog(message, dialogOptions);
    };

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape" && dialogElement
                && dialogElement.classList.contains("is-open")) {
            closeDialog();
        }
    });

    document.addEventListener("click", function (event) {
        if (event.target === dialogElement) {
            closeDialog();
        }
    });

    function iniciarInteracoesGlobais() {
        var caminhoAtual = window.location.pathname.split("/").pop();

        document.querySelectorAll(".main-nav a[href]").forEach(function (link) {
            var destino = link.getAttribute("href").split("?")[0];
            var destinoEhPaginaAtual =
                destino === caminhoAtual ||
                (destino.indexOf("gerenciar_cliente.do") === 0 &&
                    (caminhoAtual.indexOf("cliente") !== -1)) ||
                (destino.indexOf("gerenciar_quarto.do") === 0 &&
                    (caminhoAtual.indexOf("quarto") !== -1)) ||
                (destino.indexOf("gerenciar_servico.do") === 0 &&
                    (caminhoAtual.indexOf("servico") !== -1)) ||
                (destino.indexOf("gerenciar_diaria.do") === 0 &&
                    (caminhoAtual.indexOf("diaria") !== -1)) ||
                (destino.indexOf("gerenciar_pendencias.do") === 0 &&
                    (caminhoAtual.indexOf("pendencias") !== -1)) ||
                (destino.indexOf("gerenciar_usuario.do") === 0 &&
                    (caminhoAtual.indexOf("usuario") !== -1)) ||
                (destino.indexOf("gerenciar_perfil.do") === 0 &&
                    (caminhoAtual.indexOf("perfil") !== -1)) ||
                (destino.indexOf("gerenciar_menu.do") === 0 &&
                    (caminhoAtual.indexOf("menu") !== -1));

            if (destinoEhPaginaAtual) {
                link.classList.add("active");
                link.setAttribute("aria-current", "page");
            }
        });

        document.querySelectorAll(".btn").forEach(function (botao) {
            botao.addEventListener("pointerdown", function (event) {
                var retangulo = botao.getBoundingClientRect();
                botao.style.setProperty("--ripple-x", (event.clientX - retangulo.left) + "px");
                botao.style.setProperty("--ripple-y", (event.clientY - retangulo.top) + "px");
                botao.classList.remove("is-rippling");
                void botao.offsetWidth;
                botao.classList.add("is-rippling");
            });
        });

        var campos = document.querySelectorAll(
            "input:not([type='hidden']), select, textarea"
        );
        campos.forEach(function (campo) {
            campo.addEventListener("invalid", function () {
                campo.classList.add("campo-invalido");
            });
            campo.addEventListener("input", function () {
                campo.classList.remove("campo-invalido");
            });
            campo.addEventListener("change", function () {
                campo.classList.remove("campo-invalido");
            });
        });
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", iniciarInteracoesGlobais);
    } else {
        iniciarInteracoesGlobais();
    }
})();
