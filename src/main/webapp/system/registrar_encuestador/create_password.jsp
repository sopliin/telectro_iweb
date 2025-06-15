<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Contraseña - ONU Mujeres</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .reset-container {
            max-width: 500px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .reset-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .requirement {
            transition: all 0.3s;
            font-size: 0.9rem;
        }

        .requirement.valid {
            color: #198754;
        }

        .requirement.invalid {
            color: #dc3545;
        }

        .input-group .btn {
            border-left: none;
            border-color: #ced4da;
        }

        .btn-reset {
            width: 100%;
            padding: 0.75rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="reset-container">
        <div class="reset-header">
            <h2 class="text-center mb-4"><i class="fas fa-lock me-2"></i>Crear Contraseña</h2>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <% if ("password_mismatch".equals(request.getAttribute("error"))) { %>
            Las contraseñas no coinciden
            <% } else if ("password_weak".equals(request.getAttribute("error"))) { %>
            La contraseña no cumple con los requisitos
            <% } %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
        </div>

        <% } %>

        <form action="<%=request.getContextPath()%>/login?action=save_password" method="post">
            <input type="hidden" name="token" value="${param.token}">

            <div class="mb-3">
                <label for="password" class="form-label">Nueva Contraseña</label>
                <div class="input-group">
                    <input type="password" class="form-control" id="password" name="password" required
                           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}"
                           title="Debe contener: 8+ caracteres, 1 mayúscula, 1 minúscula, 1 número y 1 carácter especial (!@#$%^&*)">
                    <button class="btn btn-outline-secondary toggle-password" type="button">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <div class="requirements mt-2">
                    <p class="mb-1">Requisitos:</p>
                    <ul class="list-unstyled">
                        <li class="requirement" id="length"><i class="fas fa-check-circle me-2"></i>Mínimo 8 caracteres</li>
                        <li class="requirement" id="uppercase"><i class="fas fa-check-circle me-2"></i>Al menos 1 mayúscula</li>
                        <li class="requirement" id="lowercase"><i class="fas fa-check-circle me-2"></i>Al menos 1 minúscula</li> <!-- ¡Nuevo! -->
                        <li class="requirement" id="number"><i class="fas fa-check-circle me-2"></i>Al menos 1 número</li>
                        <li class="requirement" id="special"><i class="fas fa-check-circle me-2"></i>Al menos 1 carácter especial</li>
                    </ul>
                </div>
            </div>

            <div class="mb-4">
                <label for="confirm_password" class="form-label">Confirmar Contraseña</label>
                <div class="input-group">
                    <input type="password" class="form-control" id="confirm_password" name="confirm_password" required>
                    <button class="btn btn-outline-secondary toggle-password" type="button">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <div class="text-danger small mt-1" id="confirm-feedback" style="display: none;">
                    <i class="fas fa-exclamation-circle me-1"></i> Las contraseñas no coinciden
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-reset">
                <i class="fas fa-save me-2"></i>Guardar Contraseña
            </button>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
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
        const passwordInput = document.getElementById('password');
        const requirements = {
            length: document.getElementById('length'),
            uppercase: document.getElementById('uppercase'),
            lowercase: document.getElementById('lowercase'), // Falta esta línea
            number: document.getElementById('number'),
            special: document.getElementById('special')
        };

        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const isLengthValid = password.length >= 8;
            const hasUppercase = /[A-Z]/.test(password);
            const hasLowercase = /[a-z]/.test(password);  // ¡Nueva validación!
            const hasNumber = /\d/.test(password);
            const hasSpecial = /[!@#$%^&*]/.test(password);

            // Actualiza los elementos (añade 'lowercase')
            toggleClass(requirements.length, isLengthValid);
            toggleClass(requirements.uppercase, hasUppercase);
            toggleClass(requirements.lowercase, hasLowercase); // ¡Nuevo!
            toggleClass(requirements.number, hasNumber);
            toggleClass(requirements.special, hasSpecial);
        });

        // Validación de coincidencia de contraseñas
        document.getElementById('confirm_password').addEventListener('input', function() {
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
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirm = document.getElementById('confirm_password').value;
            const feedback = document.getElementById('confirm-feedback');

            if (password !== confirm) {
                e.preventDefault();
                document.getElementById('confirm_password').classList.add('is-invalid');
                feedback.style.display = 'block';
            }
        });

        function toggleClass(element, isValid) {
            element.classList.toggle('valid', isValid);
            element.classList.toggle('invalid', !isValid);
            element.querySelector('i').className = isValid ?
                'fas fa-check-circle me-2' : 'fas fa-times-circle me-2';
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>