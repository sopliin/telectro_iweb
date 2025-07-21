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
    if (emailParam != null && !emailParam.isEmpty()) {
        UsuarioDAO userDao = new UsuarioDAO();
        Usuario existingUser = userDao.usuarioByEmail(emailParam);
        if (existingUser != null) {
            if (existingUser.isCorreoVerificado()) {
                response.sendRedirect(request.getContextPath() + "/login?action=register&error=email_exists");
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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
    <!-- Estilos personalizados -->
    <style>
        /* Variables de color (mantendremos algunas para validación) */
        :root {
            --error-color: #e74c3c;
            --success-color: #2ecc71;
        }

        /* Estilos del body - Igual que el login */
        body {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
            url('https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?auto=format&fit=crop&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            font-family: 'Poppins', sans-serif;
        }

        /* Estilo de la tarjeta de registro - Adaptado del login-card */
        .registration-card {
            max-width: 900px; /* Mantener el ancho para 2 columnas */
            margin: 2rem auto;
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            background-color: rgba(255, 255, 255, 0.95);
            padding: 2.5rem !important; /* Mismo padding inicial que login-card */
        }

        /* Encabezado H2 - Igual que el login */
        .main-header-text {
            color: white;
            font-weight: 600;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            text-align: center; /* Asegura que el h2 esté centrado */
            margin-top: 1rem; /* Ajuste para espacio superior */
        }

        /* Logo - Igual que el login */
        img[alt="Logo"] {
            filter: brightness(0) invert(1); /* Pone el logo blanco */
            height: auto;
            max-height: 80px;
            width: auto;
            max-width: 100%;
            margin-bottom: 1.5rem;
        }

        /* Formulario de control general */
        .form-control-custom {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-control-custom label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #444; /* Color de label de login */
        }

        /* Inputs y selects - Igual que form-control-lg del login */
        .form-control-custom input,
        .form-control-custom select {
            width: 100%;
            padding: 1rem 1.5rem; /* Padding de form-control-lg */
            border: 1px solid #e0e0e0; /* Borde de form-control-lg */
            border-radius: 10px; /* Border-radius de form-control-lg */
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control-custom input:focus,
        .form-control-custom select:focus {
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.2);
            border-color: #0d6efd;
        }

        /* Mensajes de error */
        .form-control-custom small {
            color: var(--error-color);
            position: absolute;
            bottom: -20px; /* Ajustado por el padding de form-control-lg */
            left: 0;
            visibility: hidden;
            font-size: 0.8rem;
        }

        .form-control-custom.error small {
            visibility: visible;
        }

        /* Íconos de validación */
        .form-control-custom i {
            position: absolute;
            right: 15px; /* Ajustado por el padding de form-control-lg */
            top: 50%; /* Centra verticalmente */
            transform: translateY(-50%); /* Ajuste fino para centrar */
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

        /* Botón de registro - Igual que btn-primary del login */
        .btn-register {
            background-color: #0066cc;
            border-color: #0066cc;
            color: white;
            padding: 0.8rem 2rem;
            font-weight: 500;
            border-radius: 10px;
            transition: all 0.3s ease;
            width: 100%;
            font-size: 1.1rem; /* Ajustado para que sea grande */
            cursor: pointer;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 102, 204, 0.3);
            background-color: #0052a3;
            border-color: #0052a3;
        }

        /* Alertas - Estilo Bootstrap con pequeños ajustes */
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 15px 20px; /* Aumentado padding */
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Añadida sombra para consistencia */
        }

        .alert-danger i {
            margin-right: 10px;
            font-size: 1.5em; /* Aumentado tamaño de ícono */
        }

        .alert-warning {
            background-color: #fff3cd;
            border-color: #ffeeba;
            color: #856404;
            padding: 15px 20px;
            border-radius: 4px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .alert-warning .alert-link {
            color: #665003; /* Color de link para alerta warning */
        }

        .alert-warning .alert-heading {
            color: #665003;
        }

        .back-link {
            text-align: center;
            margin-top: 1rem;
        }

        .back-link a {
            font-size: 1rem;
            text-decoration: none;
            color: #0d6efd;
            transition: color 0.3s ease;
        }

        .back-link a:hover {
            color: #0a58ca;
        }


        footer {
            text-align: center;
            padding: 1.5rem; /* Más padding para el footer */
            color: #ccc; /* Color más claro para el texto del footer */
            font-size: 0.9rem;
            margin-top: 2rem; /* Más espacio arriba del footer */
        }

        /* --- Media Queries para Responsividad --- */

        /* Ajustes para pantallas pequeñas (hasta 991.98px - tablets y teléfonos) */
        @media (max-width: 991.98px) {
            .registration-card {
                max-width: 700px; /* Ajuste para el formulario en tablets */
            }
        }

        /* Ajustes para pantallas aún más pequeñas (hasta 767.98px - tablets y teléfonos) */
        @media (max-width: 767.98px) {
            .registration-card {
                padding: 1.5rem !important; /* Reduce el padding en pantallas más pequeñas */
                margin: 1rem auto; /* Ajusta margen en móviles */
                max-width: 95%; /* Ocupa más ancho en móviles */
            }

            .main-header-text {
                font-size: 1.8rem; /* Tamaño de fuente ligeramente más pequeño para el título */
                margin-bottom: 1rem;
            }

            img[alt="Logo"] {
                max-height: 60px; /* Reduce el tamaño del logo en móviles */
                margin-bottom: 1rem;
            }

            .form-control-custom small {
                bottom: -18px; /* Ajuste para mensajes de error */
            }

            .form-control-custom i {
                right: 10px; /* Ajuste para iconos de validación */
            }
        }

        /* Ajustes para pantallas extra pequeñas (hasta 575.98px - teléfonos) */
        @media (max-width: 575.98px) {
            .form-control-custom input,
            .form-control-custom select {
                padding: 0.8rem 1.2rem; /* Reduce el padding de los inputs en pantallas muy pequeñas */
            }
        }

    </style>
</head>

<body class="d-flex flex-column min-vh-100">
<main class="container py-3 flex-grow-1 d-flex align-items-center">
    <div class="w-100">
        <div class="text-center mt-5 mb-4">
            <img src="<%=request.getContextPath()%>/onu_mujeres/static/img/logo.png" alt="Logo" class="mb-3">
            <h1 class="main-header-text">Registro de Encuestador</h1>
        </div>
        <div class="registration-card">
            <div class="card-body">
        <%-- Bloque para mostrar errores del servidor --%>
        <%
            String error = request.getParameter("error");
            if (error != null && error.equals("no_valid")) {
        %>
            <div class="alert alert-danger" role="alert">
            <i class="fas fa-exclamation-triangle"></i> El correo electrónico o DNI ya están registrados.
            Por favor, utiliza otros datos o inicia sesión si ya tienes una cuenta.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>
        <% if (error != null && error.equals("invalid_email")) { %>
        <div class="alert alert-danger" role="alert">
            <i class="fas fa-exclamation-triangle"></i> Solo se permiten cuentas de Gmail (@gmail.com) para el registro.
        </div>
        <% } %>


        <% if (request.getAttribute("pendingVerification") != null) { %>
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
                        <input type="text" id="code" name="code" pattern="[0-9]{8}" title="Debe contener 8 dígitos"
                               required>
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Debe contener 8 dígitos</small>

                    </div>

                    <div class="form-control-custom">
                        <label for="email">Correo Electrónico(@gmail.com)</label>
                        <input type="email" id="email" name="email"
                               pattern="[a-zA-Z0-9._%+-]+@(gmail\.com|pucp\.edu\.pe)$"
                               title="Solo se permiten cuentas de Gmail (@gmail.com) o PUCP (@pucp.edu.pe)"
                               required
                               oninput="this.value = this.value.toLowerCase()">
                        <i class="fas fa-check-circle"></i>
                        <i class="fas fa-exclamation-circle"></i>
                        <small>Solo se permiten: @gmail.com o @pucp.edu.pe</small>
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
                            <option value="<%=distrito.getDistritoId()%>"><%=distrito.getNombre()%>
                            </option>
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
                <a href="<%=request.getContextPath()%>/login" class="text-decoration-none">← Volver al inicio de
                    sesión</a>
            </div>
        </form>
    </div>
        </div>
    </div>
</main>

<footer class="container">
    <p>© ONU Mujeres - Todos los derechos reservados</p>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script para validación en cliente -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Validación del DNI (8 dígitos)
        const dniInput = document.getElementById('code');
        dniInput.addEventListener('input', function () {
            const formControl = this.parentElement;
            if (!this.checkValidity()) {
                formControl.classList.add('error');
                formControl.classList.remove('success');
            } else {
                formControl.classList.remove('error');
                formControl.classList.add('success');
            }
        });

        // Validación del correo (Gmail/PUCP)
        const emailInput = document.getElementById('email');
        const emailPattern = /^[a-zA-Z0-9._%+-]+@(gmail\.com|pucp\.edu\.pe)$/i;
        emailInput.addEventListener('input', function () {
            const email = this.value;
            const formControl = this.parentElement;
            const small = formControl.querySelector('small');

            formControl.classList.remove('error', 'success');

            if (email === '') {
                small.textContent = 'Este campo es requerido';
                formControl.classList.add('error');
            } else if (!emailPattern.test(email)) {
                small.textContent = 'Solo se permiten: @gmail.com o @pucp.edu.pe';
                formControl.classList.add('error');
            } else {
                small.textContent = '';
                formControl.classList.add('success');
            }
        });

        // Bloquear envío si hay errores
        document.getElementById('registrationForm').addEventListener('submit', function (e) {
            if (!this.checkValidity()) {
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
                if (response.ok) {
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