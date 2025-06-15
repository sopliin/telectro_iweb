<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%Usuario user = (Usuario) session.getAttribute("usuario");%>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="ONU Mujeres - Cambiar Contraseña">
  <meta name="author" content="ONU Mujeres">
  <meta name="keywords" content="onu, mujeres, encuestas, administración">

  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link rel="shortcut icon" href="img/icons/icon-48x48.png" />

  <title>Cambiar Contraseña - ONU Mujeres</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    .password-container {
      max-width: 500px;
      margin: 0 auto;
      padding: 2rem;
      background: white;
      border-radius: 0.5rem;
      box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
    }
    .requirement {
      transition: all 0.3s;
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

  </style>
</head>
<body >

<script type="text/javascript" src="js/app.js"></script>
<div class="wrapper">
  <nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
      <a class="sidebar-brand" href="EncuestadorServlet?action=total">
        <span class="align-middle">ONU Mujeres</span>
      </a>

      <ul class="sidebar-nav">
        <li class="sidebar-header">
          Encuestas
        </li>

        <li class="sidebar-item active">
          <a class="sidebar-link" href="EncuestadorServlet?action=total">
            <i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestas totales</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="EncuestadorServlet?action=terminados">
            <i class="align-middle" data-feather="check"></i> <span class="align-middle">Encuestas completadas</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="EncuestadorServlet?action=borradores">
            <i class="align-middle" data-feather="save"></i> <span class="align-middle">Encuestas en progreso</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="EncuestadorServlet?action=pendientes">
            <i class="align-middle" data-feather="edit-3"></i> <span class="align-middle">Encuestas por hacer</span>
          </a>
        </li>
        <!--
         <li class="sidebar-item active">
          <a class="sidebar-link" href="EncuestadorServlet?action=ver">
            <i class="align-middle" data-feather="user"></i> <span class="align-middle">Mi Perfil</span>
          </a>
        </li>
        -->

      </ul>
    </div>
  </nav>

  <div class="main">
    <nav class="navbar navbar-expand navbar-light navbar-bg">
      <a class="sidebar-toggle js-sidebar-toggle">
        <i class="hamburger align-self-center"></i>
      </a>

      <div class="navbar-collapse collapse">
        <ul class="navbar-nav navbar-align">
          <li class="nav-item dropdown">


          <li class="nav-item dropdown">
            <a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#" data-bs-toggle="dropdown">
              <i class="align-middle" data-feather="settings"></i>
            </a>

            <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
              <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" class="avatar img-fluid rounded me-1" alt="Charles Hall" /> <span class="text-dark"><%=user.getNombre()+" "+user.getApellidoPaterno() %>(<%=user.getRol() != null ?
                    user.getRol().getNombre().substring(0, 1).toUpperCase() + user.getRol().getNombre().substring(1).toLowerCase() : ""%>)</span>
            </a>
            <div class="dropdown-menu dropdown-menu-end">
              <a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1" data-feather="eye"></i> Ver Perfil</a>
              <div class="dropdown-divider"></div>

              <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>


            </div>
          </li>
        </ul>
      </div>
    </nav>

    <main class="content">
      <div class="container-fluid p-0">
        <div class="mb-3">
          <h1 class="h3 d-inline align-middle">Cambiar Contraseña</h1>
        </div>
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

        <div class="row">
          <div class="col-12">
            <div class="password-container">


              <form action="EncuestadorServlet?action=updatePassword" method="post" id="passwordForm">
                <div class="mb-3">
                  <label for="currentPassword" class="form-label">Contraseña Actual</label>
                  <div class="input-group">
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    <button class="btn btn-outline-secondary toggle-password" type="button">
                      <i class="fas fa-eye"></i>
                    </button>
                  </div>
                </div>

                <div class="mb-3">
                  <label for="newPassword" class="form-label">Nueva Contraseña</label>
                  <div class="input-group">
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required
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
                      <li class="requirement" id="lowercase"><i class="fas fa-check-circle me-2"></i>Al menos 1 minúscula</li>
                      <li class="requirement" id="number"><i class="fas fa-check-circle me-2"></i>Al menos 1 número</li>
                      <li class="requirement" id="special"><i class="fas fa-check-circle me-2"></i>Al menos 1 carácter especial</li>
                    </ul>
                  </div>
                </div>

                <div class="mb-4">
                  <label for="confirmPassword" class="form-label">Confirmar Nueva Contraseña</label>
                  <div class="input-group">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    <button class="btn btn-outline-secondary toggle-password" type="button">
                      <i class="fas fa-eye"></i>
                    </button>
                  </div>
                  <div class="text-danger small mt-1" id="confirm-feedback" style="display: none;">
                    <i class="fas fa-exclamation-circle me-1"></i> Las contraseñas no coinciden
                  </div>
                </div>

                <div class="d-grid gap-2">
                  <button type="submit" class="btn btn-primary">Cambiar Contraseña</button>
                  <a href="EncuestadorServlet?action=ver" class="btn btn-secondary">Volver al perfil</a>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </main>

    <jsp:include page="../../includes/footer.jsp"/>
  </div>
</div>


<script type="text/javascript" src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>
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

      // Configurar el botón de cierre
      const closeButton = toastEl.querySelector('[data-bs-dismiss="toast"]');
      if (closeButton) {
        closeButton.addEventListener('click', function() {
          toast.hide();
        });
      }
    }

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
      element.classList.toggle('valid', isValid);
      element.classList.toggle('invalid', !isValid);
      element.querySelector('i').className = isValid ?
              'fas fa-check-circle me-2' : 'fas fa-times-circle me-2';
    }
  });
</script>

</body>
</html>