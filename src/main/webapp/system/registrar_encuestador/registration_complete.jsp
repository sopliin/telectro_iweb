<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Registro Completo - ONU Mujeres</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .complete-container {
      max-width: 500px;
      margin: 2rem auto;
      padding: 2rem;
      background: white;
      border-radius: 0.5rem;
      box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
      text-align: center;
    }
    .check-icon {
      font-size: 5rem;
      color: #198754;
      margin-bottom: 1.5rem;
    }
  </style>
</head>
<body>
<main class="container py-5">
  <div class="complete-container">
    <div class="check-icon">
      <i class="fas fa-check-circle"></i>
    </div>
    <h2 class="mb-3">¡Registro Completado!</h2>
    <p class="lead mb-4">Tu cuenta ha sido creada exitosamente.</p>
    <p class="mb-4">Ahora puedes iniciar sesión con tu correo y contraseña.</p>
    <a href="<%=request.getContextPath()%>/login" class="btn btn-primary px-4">
      <i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión
    </a>
  </div>
</main>
</body>
</html>