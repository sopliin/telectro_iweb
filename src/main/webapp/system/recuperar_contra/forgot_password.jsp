<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Recuperar Contraseña - ONU Mujeres</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .forgot-container {
            max-width: 500px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .forgot-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .forgot-form {
            margin-top: 1.5rem;
        }

        .btn-forgot {
            width: 100%;
            padding: 0.75rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="forgot-container">
        <div class="forgot-header">
            <h2><i class="fas fa-key me-2"></i>Recuperar Contraseña</h2>
            <p class="text-muted">Ingrese su correo electrónico para recibir un enlace de recuperación</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle me-2"></i>
            <% if ("email_not_found".equals(request.getParameter("error"))) { %>
            El correo electrónico no está registrado o no ha sido verificado.
            <% } %>
        </div>
        <% } %>

        <div class="forgot-form">
            <form action="<%=request.getContextPath()%>/login?action=send_reset_email" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <button type="submit" class="btn btn-primary btn-forgot">
                    <i class="fas fa-paper-plane me-2"></i>Enviar Enlace
                </button>
            </form>
        </div>

        <div class="text-center mt-3">
            <a href="<%=request.getContextPath()%>/login" class="text-decoration-none">
                <i class="fas fa-arrow-left me-1"></i>Volver al inicio de sesión
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>