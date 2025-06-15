<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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

    <%
      String email = (String) request.getAttribute("emailParam");
      if(email != null && !email.isEmpty()) {
    %>
    <p class="lead mb-4">El enlace de recuperación ha expirado.</p>
    <form action="<%=request.getContextPath()%>/login" method="post">
      <input type="hidden" name="action" value="resend_reset_email">
      <input type="hidden" name="email" value="<%=email%>">
      <button type="submit" class="btn btn-primary">
        <i class="fas fa-paper-plane me-2"></i>Reenviar correo de recuperación
      </button>
    </form>
    <%
    } else {
    %>
    <p class="lead mb-4">El token de recuperación no es válido o ha expirado.</p>
    <a href="<%=request.getContextPath()%>/login?action=forgot_password" class="btn btn-primary">
      <i class="fas fa-key me-2"></i>Solicitar nuevo correo
    </a>
    <%
      }
    %>
  </div>
</main>
</body>
</html>