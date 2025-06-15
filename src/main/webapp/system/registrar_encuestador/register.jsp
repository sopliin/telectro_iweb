<%@ page import="java.util.ArrayList" %>

<%@ page import="org.example.onu_mujeres_crud.beans.Distrito" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="distritos" type="java.util.ArrayList<org.example.onu_mujeres_crud.beans.Distrito>" scope="request"/>
<%@ page import="org.example.onu_mujeres_crud.daos.UsuarioDAO" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>

<%-- Agrega esto después de los imports y antes del DOCTYPE --%>
<%
    // Verificación de email existente
    String emailParam = request.getParameter("email");
    if(emailParam != null && !emailParam.isEmpty()) {
        UsuarioDAO userDao = new UsuarioDAO();
        Usuario existingUser = userDao.usuarioByEmail(emailParam);
        if(existingUser != null) {
            if(existingUser.isCorreoVerificado()) {
                response.sendRedirect(request.getContextPath()+"/login?action=register&error=email_exists");
            } else {
                request.setAttribute("pendingVerification", true);
                request.setAttribute("pendingEmail", emailParam);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Encuestador - ONU Mujeres</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Estilos personalizados -->
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #f8f9fc;
            --error-color: #e74c3c;
            --success-color: #2ecc71;
        }

        body {
            background-color: var(--secondary-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .registration-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .registration-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .registration-header h2 {
            color: var(--primary-color);
            font-weight: 600;
        }

        .form-control-custom {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-control-custom label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-control-custom input,
        .form-control-custom select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 0.25rem;
        }

        .form-control-custom small {
            color: var(--error-color);
            position: absolute;
            bottom: -20px;
            left: 0;
            visibility: hidden;
            font-size: 0.8rem;
        }

        .form-control-custom.error small {
            visibility: visible;
        }

        .form-control-custom i {
            position: absolute;
            right: 10px;
            top: 38px;
            visibility: hidden;
        }

        .form-control-custom.success i.fa-check-circle {
            color: var(--success-color);
            visibility: visible;
        }

        .form-control-custom.error i.fa-exclamation-circle {
            color: var(--error-color);
            visibility: visible;
        }

        .btn-register {
            background-color: var(--primary-color);
            border: none;
            color: white;
            padding: 0.75rem;
            width: 100%;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 0.25rem;
            cursor: pointer;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 10px 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .alert-danger i {
            margin-right: 10px;
            font-size: 1.2em;
        }

        .back-link {
            text-align: center;
            margin-top: 1rem;
        }

        footer {
            text-align: center;
            padding: 1rem;
            color: #858796;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>
<main class="container py-5">
    <div class="registration-container">
        <div class="registration-header">
            <h2>Registro de Encuestador</h2>
            <p class="text-muted">Complete el formulario para registrarse</p>
        </div>

        <%-- Bloque para mostrar errores del servidor --%>
        <%
            String error = request.getParameter("error");
            if(error != null && error.equals("no_valid")) {
        %>
        <div class="alert alert-danger" role="alert">
            <i class="fas fa-exclamation-triangle"></i> El correo electrónico o DNI ya están registrados.
            Por favor, utiliza otros datos o inicia sesión si ya tienes una cuenta.
        </div>
        <% } %>
        <% if(request.getAttribute("pendingVerification") != null) { %>
        <div class="alert alert-warning d-flex align-items-center">
            <i class="fas fa-exclamation-circle me-3 fs-4"></i>
            <div>
                <h5 class="alert-heading">¡Registro pendiente!</h5>
                <p class="mb-1">Ya existe un registro no verificado para: <strong>${pendingEmail}</strong></p>
                <p class="mb-0">
                    <a href="#" onclick="resendValidationEmail('${pendingEmail}')" class="alert-link">
                        <i class="fas fa-paper-plane me-1"></i>Reenviar correo de validación
                    </a>
                    o
                    <a href="<%=request.getContextPath()%>/login" class="alert-link">
                        <i class="fas fa-sign-in-alt me-1"></i>Iniciar sesión
                    </a>
                </p>
            </div>
        </div>
        <% } %>
        <form id="registrationForm" action="<%=request.getContextPath()%>/login?action=confirm_register" method="POST">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-control-custom">
                        <label for="names">Nombre</label>
                        <input type="text" id="names" name="names" required>
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Este campo es requerido</small>
                    </div>

                    <div class="form-control-custom">
                        <label for="lastnames1">Apellido Paterno</label>
                        <input type="text" id="lastnames1" name="lastnames1" required>
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Este campo es requerido</small>
                    </div>

                    <div class="form-control-custom">
                        <label for="lastnames2">Apellido Materno</label>
                        <input type="text" id="lastnames2" name="lastnames2" required>
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Este campo es requerido</small>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="form-control-custom">
                        <label for="code">DNI</label>
                        <input type="text" id="code" name="code" pattern="[0-9]{8}" title="Debe contener 8 dígitos" required>
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Debe contener 8 dígitos</small>
                    </div>

                    <div class="form-control-custom">
                        <label for="email">Correo Electrónico (Gmail)</label>
                        <input type="email" id="email" name="email" pattern="[a-z0-9._%+-]+@gmail\.com$" title="Debe ser un correo de Gmail" required>
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Debe ser un correo válido de Gmail</small>
                    </div>

                    <div class="form-control-custom">
                        <label for="direccion">Dirección</label>
                        <input type="text" id="direccion" name="direccion" required>
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Este campo es requerido</small>
                    </div>

                    <div class="form-control-custom">
                        <label for="distrito">Distrito</label>
                        <select class="form-select" id="distrito" name="distrito" required>
                            <option value="" selected disabled>Seleccione un distrito</option>
                            <% for (Distrito distrito : distritos) { %>
                            <option value="<%=distrito.getDistritoId()%>"><%=distrito.getNombre()%></option>
                            <% } %>
                        </select>
                        <small>Este campo es requerido</small>
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-register">Registrarse</button>
            </div>

            <div class="back-link mt-3">
                <a href="<%=request.getContextPath()%>/login" class="text-decoration-none">← Volver al inicio de sesión</a>
            </div>
        </form>
    </div>
</main>

<footer class="container">
    <p>© ONU Mujeres - Todos los derechos reservados</p>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script para validación en cliente -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registrationForm');

        form.addEventListener('submit', function(e) {
            let isValid = true;

            // Validar cada campo
            document.querySelectorAll('.form-control-custom input, .form-control-custom select').forEach(input => {
                const formControl = input.parentElement;

                if (!input.checkValidity()) {
                    formControl.classList.add('error');
                    formControl.classList.remove('success');
                    isValid = false;
                } else {
                    formControl.classList.remove('error');
                    formControl.classList.add('success');
                }
            });

            if (!isValid) {
                e.preventDefault();
            }
        });
    });
</script>
<%-- Agrega esto antes del cierre del body, después de tus otros scripts --%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function resendValidationEmail(email) {
        Swal.fire({
            title: 'Reenviando correo...',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        fetch('<%=request.getContextPath()%>/login?action=resend_validation&email=' + encodeURIComponent(email))
            .then(response => {
                Swal.close();
                if(response.ok) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Correo reenviado',
                        html: `Se ha enviado nuevamente el correo de validación a <strong>${email}</strong>`,
                        confirmButtonText: 'Entendido'
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'No se pudo reenviar el correo. Por favor intente más tarde.'
                    });
                }
            })
            .catch(error => {
                Swal.fire({
                    icon: 'error',
                    title: 'Error de conexión',
                    text: 'No se pudo conectar con el servidor'
                });
            });

        return false;
    }
</script>
</body>
</html>