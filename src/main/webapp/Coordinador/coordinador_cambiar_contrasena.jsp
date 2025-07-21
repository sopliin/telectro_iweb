<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <%Usuario user = (Usuario) session.getAttribute("usuario");%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

    <title>Cambiar Contraseña - ONU Mujeres</title>

    <style>

        /* ESTILOS MODIFICADOS PARA EL FORMULARIO DE CAMBIO DE CONTRASEÑA */
        .password-container {
            max-width: 650px; /* Un poco más ancho */
            margin: 3rem auto;
            padding: 2.5rem;
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 0.25rem 1.5rem rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
        }

        .password-container h1.h3 {
            font-size: 1.7rem; /* Ligeramente más pequeño que antes, pero aún prominente */
            font-weight: 600;
            color: #333;
            margin-bottom: 2rem; /* Más espacio debajo del título */
            text-align: center;
        }

        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 0.6rem; /* Un poco más de espacio debajo de la etiqueta */
            font-size: 0.95rem; /* Ligeramente más pequeño */
        }

        .form-control {
            border-radius: 0.5rem;
            padding: 0.65rem 1rem; /* Padding ligeramente reducido */
            font-size: 0.95rem; /* Tamaño de fuente ligeramente más pequeño */
        }

        .input-group .btn {
            border-radius: 0 0.5rem 0.5rem 0;
            border-left: 1px solid #ced4da;
            background-color: #f8f9fa;
            color: #6c757d;
        }

        .input-group .btn:hover {
            background-color: #e9ecef;
        }

        .requirements {
            background-color: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-top: 1.5rem;
            border: 1px solid #e9ecef;
        }

        .requirements p.mb-1 {
            font-weight: 600;
            color: #555;
            margin-bottom: 0.75rem !important;
            font-size: 0.9rem; /* Ligeramente más pequeño */
        }

        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 0.4rem; /* Reducido el margen entre requisitos */
            font-size: 0.88rem; /* Tamaño de fuente ligeramente más pequeño */
            transition: all 0.3s ease; /* Transición para los cambios de color y ícono */
        }

        .requirement i {
            margin-right: 0.75rem;
            font-size: 1em; /* Ajustado el tamaño del ícono */
        }

        .requirement.valid {
            color: #28a745;
        }
        .requirement.invalid {
            color: #dc3545;
        }

        /* Estilo inicial para los requisitos (gris neutro y ícono de círculo) */
        .requirement:not(.valid):not(.invalid) {
            color: #6c757d; /* Color gris para el estado por defecto */
        }
        .requirement:not(.valid):not(.invalid) i {
            color: #6c757d; /* Ícono gris */
            content: "\f111"; /* Círculo sólido (Font Awesome) */
        }

        #confirm-feedback {
            font-size: 0.85rem; /* Ligeramente más pequeño */
            margin-top: 0.5rem;
            color: #dc3545;
        }

        .d-grid.gap-3 { /* Cambiado a gap-3 para más espacio entre botones */
            margin-top: 2.5rem;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            padding: 0.7rem 1.5rem; /* Padding ligeramente reducido */
            font-size: 1rem; /* Ligeramente más pequeño */
            border-radius: 0.5rem;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .btn-secondary {
            padding: 0.7rem 1.5rem; /* Padding ligeramente reducido */
            font-size: 1rem; /* Ligeramente más pequeño */
            border-radius: 0.5rem;
        }

        /* Estilos para alertas (sin cambios) */
        .alert {
            margin-top: 1.5rem;
            border-radius: 0.5rem;
        }

        .alert-dismissible .btn-close {
            padding: 0.75em 0.75em;
        }

        /* Responsive adjustments for footer (sin cambios) */
        .footer .row {
            flex-wrap: wrap;
        }

        .footer .col-6 {
            width: 100% !important;
            text-align: center !important;
            margin-bottom: 0.5rem;
        }

        .footer .list-inline {
            flex-wrap: wrap;
        }

        .footer .list-inline-item {
            margin: 0 0.5rem;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="CoordinadorServlet?action=lista">
                <span class="align-middle">ONU Mujeres</span>
            </a>

            <ul class="sidebar-nav">
                <li class="sidebar-header">Menú del coordinador</li>
                <li class="sidebar-item ">
                    <a class="sidebar-link" href="CoordinadorServlet?action=lista">
                        <i class="align-middle" data-feather="users"></i> <span class="align-middle">Encuestadores de zona</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=listarEncuestas">
                        <i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestas</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=dashboard">
                        <i class="align-middle" data-feather="bar-chart"></i> <span class="align-middle">Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=subirexcel">
                        <i class="align-middle" data-feather="upload"></i> <span class="align-middle">Subir respuestas</span>
                    </a>
                </li>
                <li class="sidebar-header">
                    Perfil
                </li>
                <li class="sidebar-item active">
                    <a class="sidebar-link" href="CoordinadorServlet?action=verPerfil">
                        <i class="align-middle" data-feather="user"></i> <span class="align-middle">Mi Perfil</span>
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="main">
        <nav class="navbar navbar-expand navbar-light navbar-bg">
            <a class="sidebar-toggle js-sidebar-toggle"><i class="hamburger align-self-center"></i></a>
            <div class="navbar-collapse collapse">
                <ul class="navbar-nav navbar-align">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>" class="avatar img-fluid rounded me-2" alt="Foto"/>
                            <div class="d-inline-block">
                                <div class="nombre">
                                    <span class="text-dark d-block"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
                                </div>
                                <div class="rol">
                                    <small class="text-muted d-block text-uppercase"><%= user.getRol() != null ? user.getRol().getNombre() : "ROL DESCONOCIDO" %></small>
                                </div>
                            </div>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="CoordinadorServlet?action=verPerfil"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>

        <main class="content">
            <div class="container-fluid p-0">
                <div class="password-container">
                    <h1 class="h3 mb-4">Cambiar Contraseña</h1>

                    <% if (request.getSession().getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <%= request.getSession().getAttribute("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                    </div>
                    <% request.getSession().removeAttribute("error"); %>
                    <% } %>

                    <% if (request.getSession().getAttribute("success") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <%= request.getSession().getAttribute("success") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                    </div>
                    <% request.getSession().removeAttribute("success"); %>
                    <% } %>

                    <form action="CoordinadorServlet?action=updatePassword" method="post" id="passwordForm">
                        <div class="mb-4">
                            <label for="currentPassword" class="form-label">Contraseña Actual</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                <button class="btn btn-outline-secondary toggle-password" type="button">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="newPassword" class="form-label">Nueva Contraseña</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required
                                       pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}"
                                       title="Debe contener: 8+ caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 carácter especial (!@#$%^&*)">
                                <button class="btn btn-outline-secondary toggle-password" type="button">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="requirements mt-3">
                                <p class="mb-1">Requisitos de Contraseña:</p>
                                <ul class="list-unstyled">
                                    <li class="requirement" id="length"><i class="far fa-circle me-2"></i>Mínimo 8 caracteres</li>
                                    <li class="requirement" id="uppercase"><i class="far fa-circle me-2"></i>Al menos 1 mayúscula</li>
                                    <li class="requirement" id="lowercase"><i class="far fa-circle me-2"></i>Al menos 1 minúscula</li>
                                    <li class="requirement" id="number"><i class="far fa-circle me-2"></i>Al menos 1 número</li>
                                    <li class="requirement" id="special"><i class="far fa-circle me-2"></i>Al menos 1 carácter especial</li>
                                </ul>
                            </div>
                        </div>

                        <div class="mb-5">
                            <label for="confirmPassword" class="form-label">Confirmar Nueva Contraseña</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <button class="btn btn-outline-secondary toggle-password" type="button">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="text-danger small mt-2" id="confirm-feedback" style="display: none;">
                                <i class="fas fa-exclamation-circle me-1"></i> Las contraseñas no coinciden.
                            </div>
                        </div>

                        <div class="d-grid gap-3">
                            <button type="submit" class="btn btn-primary">Cambiar Contraseña</button>
                            <a href="CoordinadorServlet?action=verPerfil" class="btn btn-secondary">Volver al perfil</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>

<script type="text/javascript" src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Inicializar toasts con Bootstrap
        const toastEl = document.getElementById('errorToast');
        if (toastEl) {
            const toast = new bootstrap.Toast(toastEl, {
                autohide: true,
                delay: 5000
            });
            toast.show();

            const closeButton = toastEl.querySelector('[data-bs-dismiss="toast"]');
            if (closeButton) {
                closeButton.addEventListener('click', function() {
                    toast.hide();
                });
            }
        }

        // Función para mostrar/ocultar contraseña
        const toggleButtons = document.querySelectorAll('.toggle-password');

        toggleButtons.forEach(button => {
            button.addEventListener('click', function() {
                const input = this.parentElement.querySelector('input');
                const icon = this.querySelector('i');

                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.replace('fa-eye', 'fa-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.replace('fa-eye-slash', 'fa-eye');
                }
            });
        });

        // Validación en tiempo real de la contraseña
        const passwordInput = document.getElementById('newPassword');
        const requirements = {
            length: document.getElementById('length'),
            uppercase: document.getElementById('uppercase'),
            lowercase: document.getElementById('lowercase'),
            number: document.getElementById('number'),
            special: document.getElementById('special')
        };

        passwordInput.addEventListener('input', function() {
            const password = this.value;

            // Si el campo está vacío, resetear los requisitos
            if (password.length === 0) {
                for (const key in requirements) {
                    resetRequirement(requirements[key]);
                }
                return; // Salir de la función si no hay texto
            }

            const isLengthValid = password.length >= 8;
            const hasUppercase = /[A-Z]/.test(password);
            const hasLowercase = /[a-z]/.test(password);
            const hasNumber = /\d/.test(password);
            const hasSpecial = /[!@#$%^&*]/.test(password);

            toggleClass(requirements.length, isLengthValid);
            toggleClass(requirements.uppercase, hasUppercase);
            toggleClass(requirements.lowercase, hasLowercase);
            toggleClass(requirements.number, hasNumber);
            toggleClass(requirements.special, hasSpecial);
        });

        // Función para resetear el estado de un requisito
        function resetRequirement(element) {
            element.classList.remove('valid', 'invalid');
            element.classList.add('default-state'); // Clase para el estado por defecto (gris)
            element.querySelector('i').className = 'far fa-circle me-2'; // Icono de círculo vacío
        }

        // Validación de coincidencia de contraseñas
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = passwordInput.value;
            const confirm = this.value;
            const feedback = document.getElementById('confirm-feedback');

            if (confirm && password !== confirm) {
                this.classList.add('is-invalid');
                feedback.style.display = 'block';
            } else {
                this.classList.remove('is-invalid');
                feedback.style.display = 'none';
            }
        });

        // Prevenir envío si las contraseñas no coinciden
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirm = document.getElementById('confirmPassword').value;
            const feedback = document.getElementById('confirm-feedback');

            if (password !== confirm) {
                e.preventDefault();
                document.getElementById('confirmPassword').classList.add('is-invalid');
                feedback.style.display = 'block';
            }
        });

        function toggleClass(element, isValid) {
            element.classList.remove('default-state'); // Eliminar el estado por defecto
            element.classList.toggle('valid', isValid);
            element.classList.toggle('invalid', !isValid);
            element.querySelector('i').className = isValid ?
                'fas fa-check-circle me-2' : 'fas fa-times-circle me-2';
        }

        // Asegurar que al cargar la página, los requisitos estén en estado por defecto
        for (const key in requirements) {
            resetRequirement(requirements[key]);
        }
    });
</script>
</body>
</html>