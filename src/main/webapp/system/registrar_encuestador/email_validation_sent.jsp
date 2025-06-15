<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Validación Enviada - ONU Mujeres</title>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .validation-container {
      max-width: 600px;
      margin: 2rem auto;
      padding: 2rem;
      background: white;
      border-radius: 0.5rem;
      box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
      text-align: center;
    }
  </style>
</head>
<body>
<main class="container py-5">
  <div class="validation-container">
    <h2><i class="fas fa-envelope-circle-check text-primary mb-3"></i></h2>
    <h3 class="mb-4">¡Correo de Validación Enviado!</h3>

    <div class="alert alert-info">
      <p>Hemos enviado un enlace de validación a:</p>
      <p class="fw-bold">${param.email}</p>
      <p>Por favor revisa tu bandeja de entrada y haz clic en el enlace para completar tu registro.</p>
    </div>

    <div class="mt-4">
      <p class="text-muted">¿No recibiste el correo?</p>
      <div class="d-flex flex-column gap-2">
        <a href="#" onclick="resendValidationEmail()" class="btn btn-outline-primary">
          <i class="fas fa-paper-plane me-2"></i>Reenviar correo de validación
        </a>
        <a href="<%=request.getContextPath()%>/login" class="btn btn-outline-secondary">
          <i class="fas fa-sign-in-alt me-2"></i>Volver al inicio de sesión
        </a>
      </div>
    </div>
  </div>


  <script>
    function resendValidationEmail() {
      const email = '<%= request.getParameter("email") %>'; // Obtener el email directamente desde JSP
      const btn = document.querySelector('.btn-outline-primary');
      btn.disabled = true;
      btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Enviando...';

      Swal.fire({
        title: 'Enviando...',
        allowOutsideClick: false,
        didOpen: () => Swal.showLoading()
      });

      fetch('<%=request.getContextPath()%>/login?action=resend_validation', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(email)
      })
              .then(response => {
                if (!response.ok) {
                  throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.text();
              })
              .then(() => {
                Swal.fire({
                  icon: 'success',
                  title: '¡Correo reenviado!',
                  html: 'Se ha enviado nuevamente el enlace a <strong>' + email + '</strong>',
                  timer: 3000,
                  showConfirmButton: false
                });
              })
              .catch(error => {
                console.error('Error al reenviar correo:', error);
                Swal.fire({
                  icon: 'error',
                  title: 'Error',
                  text: 'No se pudo reenviar el correo. Por favor intente más tarde.'
                });
              })
              .finally(() => {
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Reenviar correo de validación';
              });
      return false;
    }
  </script>
</main>
</body>
</html>