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
            confirmButton.className = "app-dialog-button app-dialog-button-primary";
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
})();
