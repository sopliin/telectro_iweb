<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Correo de recuperación enviado</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            text-align: center;
            background: white;
        }
        .icon-success {
            color: #4CAF50;
            font-size: 60px;
            margin-bottom: 20px;
        }
        .email-display {
            background: #f5f5f5;
            padding: 10px;
            border-radius: 5px;
            margin: 20px 0;
            font-weight: bold;
        }
        .resend-section {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .btn-resend {
            background: #4285f4;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s;
        }
        .btn-resend:hover {
            background: #3367d6;
        }
        .btn-resend:disabled {
            background: #cccccc;
            cursor: not-allowed;
        }
        .status-message {
            margin-top: 10px;
            font-size: 14px;
        }
        .success {
            color: #4CAF50;
        }
        .error {
            color: #f44336;
        }
        .info {
            color: #2196F3;
        }
        .popup {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 15px 25px;
            border-radius: 5px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            z-index: 1000;
            display: none;
        }
        .popup-success {
            background: #4CAF50;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="icon-success">
        <i class="fas fa-paper-plane"></i>
    </div>

    <h2>Correo de recuperación enviado</h2>

    <p>Hemos enviado un enlace para restablecer tu contraseña a:</p>

    <div class="email-display">
        <i class="fas fa-envelope"></i> ${param.email}
    </div>

    <p>Por favor revisa tu bandeja de entrada y sigue las instrucciones.</p>

    <div class="resend-section">
        <p>¿No recibiste el correo electrónico?</p>
        <button id="resendButton" class="btn-resend">
            <i class="fas fa-redo"></i> Reenviar correo
        </button>
        <div id="resendStatus" class="status-message"></div>
        <a href="<%=request.getContextPath()%>/login" class="btn btn-outline-secondary">
            <i class="fas fa-sign-in-alt me-2"></i>Volver al inicio de sesión
        </a>
    </div>
</div>

<div id="successPopup" class="popup popup-success">
    <i class="fas fa-check-circle"></i> ¡Correo reenviado con éxito!
</div>

<script>
    $(document).ready(function() {
        // Animación para mostrar el popup
        function showPopup() {
            const popup = $("#successPopup");
            popup.fadeIn(300);
            setTimeout(() => {
                popup.fadeOut(300);
            }, 3000);
        }

        $("#resendButton").click(function() {
            const email = "${param.email}";
            const $btn = $(this);
            const $status = $("#resendStatus");

            if (!email) {
                $status.html('<i class="fas fa-exclamation-circle"></i> Error: No se encontró dirección de correo')
                    .removeClass().addClass('status-message error');
                return;
            }

            $btn.prop("disabled", true);
            $status.html('<i class="fas fa-spinner fa-pulse"></i> Enviando...')
                .removeClass().addClass('status-message info');

            $.post("login", {
                action: "resend_reset_email",
                email: email
            })
                .done(function(response) {
                    $status.html('<i class="fas fa-check-circle"></i> ¡Correo reenviado!')
                        .removeClass().addClass('status-message success');
                    showPopup();

                    setTimeout(() => {
                        $status.text("");
                        $btn.prop("disabled", false);
                    }, 3000);
                })
                .fail(function(xhr) {
                    const icon = '<i class="fas fa-exclamation-circle"></i> ';
                    let errorMsg = "";

                    if (xhr.status === 400) {
                        errorMsg = icon + "Email no válido o no encontrado";
                    } else if (xhr.status === 500) {
                        errorMsg = icon + "Error del servidor, intente nuevamente";
                    } else {
                        errorMsg = icon + "Error inesperado";
                    }

                    $status.html(errorMsg).removeClass().addClass('status-message error');
                    $btn.prop("disabled", false);
                });
        });
    });
</script>
</body>
</html>