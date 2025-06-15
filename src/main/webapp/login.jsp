<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<% String msgSuccessNewPassword = (String) session.getAttribute("msgSuccessNewPassword"); %>
<% String msgErrorLogin = (String) session.getAttribute("msgErrorLogin"); %>


<!DOCTYPE html>
<html lang="es">

<head>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar Sesión | ONU Mujeres</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Estilos personalizados -->
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .form-control-lg {
            padding: 1rem 1.5rem;
        }
        .login-card a {
            font-size: 1rem;
            text-decoration: none;
        }
        .login-card small a {
            font-size: 0.9rem;
        }
        .border-top p {
            font-size: 1rem;
        }
        .form-check-input:checked {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .password-toggle {
            cursor: pointer;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1100;
        }
    </style>
</head>

<body <% if(msgSuccessNewPassword != null){ %>onload="showSuccessToast('<%=msgSuccessNewPassword%>')"<% } %>>
<!-- Contenedor para toasts -->
<div id="toastContainer" class="toast-container"></div>

<main class="d-flex align-items-center min-vh-100 py-3">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="text-center mb-4">
                    <img src="<%=request.getContextPath()%>/onu_mujeres/static/img/logo.png" alt="Logo" height="60" class="mb-3">
                    <h1 class="h2">Iniciar Sesión</h1>

                </div>

                <div class="card login-card">
                    <div class="card-body p-5">
                        <% if(msgErrorLogin != null){ %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <%=msgErrorLogin%>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% session.removeAttribute("msgErrorLogin"); } %>

                        <form method="POST" action="<%=request.getContextPath()%>/login?action=login" autocomplete="on">
                            <div class="mb-4">
                                <label for="email" class="form-label">Email</label>
                                <input id="email" class="form-control form-control-lg" type="email" name="email" placeholder="Ingresa tu correo" required>
                            </div>

                            <div class="mb-4">
                                <label for="passwd" class="form-label">Contraseña</label>
                                <div class="input-group">
                                    <input id="passwd" class="form-control form-control-lg" type="password" name="passwd" placeholder="Ingresa tu contraseña" required>
                                    <span class="input-group-text password-toggle" id="togglePassword">
                                        <i class="fas fa-eye"></i>
                                    </span>
                                </div>
                                <div class="form-check mt-2">
                                    <input class="form-check-input" type="checkbox" id="mostrarContrasena">
                                    <label class="form-check-label" for="mostrarContrasena">Mostrar contraseña</label>
                                </div>
                                <small class="d-block mt-2">
                                    <a href="<%=request.getContextPath()%>/login?action=forgot_password">¿Olvidaste tu contraseña?</a>
                                </small>
                            </div>

                            <div class="text-center mt-4">
                                <button type="submit" class="btn btn-primary btn-lg w-100 py-3">Iniciar Sesión</button>
                            </div>
                        </form>

                        <div class="text-center mt-4 pt-3 border-top">
                            <p class="mb-0">¿Quieres ser encuestador? <a href="<%=request.getContextPath()%>/login?action=register">Regístrate</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Scripts mejorados -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Toggle para mostrar contraseña con checkbox
        const toggleCheckbox = document.querySelector("#mostrarContrasena");
        const passwordInput = document.querySelector("input[name='passwd']");

        if(toggleCheckbox && passwordInput) {
            toggleCheckbox.addEventListener("change", function() {
                passwordInput.type = this.checked ? "text" : "password";
            });
        }

        // Toggle para mostrar contraseña con icono de ojo
        const toggleIcon = document.querySelector("#togglePassword");
        if(toggleIcon && passwordInput) {
            toggleIcon.addEventListener("click", function() {
                const isPassword = passwordInput.type === "password";
                passwordInput.type = isPassword ? "text" : "password";
                this.innerHTML = isPassword ? '<i class="fas fa-eye-slash"></i>' : '<i class="fas fa-eye"></i>';
            });
        }
    });

    <% if(msgSuccessNewPassword != null) { %>
    function showSuccessToast(message) {
        const toastContainer = document.getElementById('toastContainer');
        const toast = document.createElement('div');
        toast.className = 'toast show align-items-center text-white bg-success border-0';
        toast.role = 'alert';
        toast.ariaLive = 'assertive';
        toast.ariaAtomic = 'true';
        toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i>${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        `;
        toastContainer.appendChild(toast);

        // Eliminar el toast después de 5 segundos
        setTimeout(() => {
            toast.remove();
        }, 5000);

        <% session.removeAttribute("msgSuccessNewPassword"); %>
    }
    <% } %>
</script>
</body>
</html>
