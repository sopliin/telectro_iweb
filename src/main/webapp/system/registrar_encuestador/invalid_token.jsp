<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.daos.UsuarioDAO" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Token Inválido - ONU Mujeres</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .error-container {
      max-width: 500px;
      margin: 2rem auto;
      padding: 2rem;
      background: white;
      border-radius: 0.5rem;
      box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
      text-align: center;
    }
    .error-icon {
      font-size: 5rem;
      color: #dc3545;
      margin-bottom: 1.5rem;
    }
  </style>
</head>
<body>
<main class="container py-5">
  <div class="error-container">
    <div class="error-icon">
      <i class="fas fa-exclamation-circle"></i>
    </div>
    <h2 class="mb-3">Token Inválido o Expirado</h2>

    <!-- Mensaje condicional -->
    <p class="lead mb-4">
      ${tieneRegistroNoVerificado ?
              'Ya existe un registro no verificado con este correo.' :
              'El token de validación no es válido o ha expirado.'}
    </p>

    <div class="d-flex justify-content-center gap-3">
      <%
        Boolean tieneRegistro = (Boolean) request.getAttribute("tieneRegistroNoVerificado");
        String email = (String) request.getAttribute("emailParam");

        if(tieneRegistro != null && tieneRegistro) {
      %>
      <form action="<%=request.getContextPath()%>/login" method="post">
        <input type="hidden" name="action" value="resend_validation">
        <input type="hidden" name="email" value="<%=email%>">
        <button type="submit" class="btn btn-primary">
          <i class="fas fa-paper-plane me-2"></i>Reenviar correo de validación
        </button>
      </form>
      <%
      } else {
      %>
      <a href="<%=request.getContextPath()%>/login?action=register" class="btn btn-outline-primary">
        <i class="fas fa-user-plus me-2"></i>Registrarse Nuevamente
      </a>
      <%
        }
      %>
      <a href="<%=request.getContextPath()%>/login" class="btn btn-primary">
        <i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión
      </a>
    </div>
  </div>
</main>
</body>
</html>