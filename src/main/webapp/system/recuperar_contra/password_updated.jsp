<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contraseña Actualizada - ONU Mujeres</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .updated-container {
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

    .btn-updated {
      width: 100%;
      padding: 0.75rem;
      font-weight: 600;
      margin-top: 1rem;
    }
  </style>
</head>
<body>
<div class="container py-5">
  <div class="updated-container">
    <div class="check-icon">
      <i class="fas fa-check-circle"></i>
    </div>
    <h2 class="mb-3">¡Contraseña Actualizada!</h2>
    <p class="lead mb-4">Tu contraseña ha sido cambiada exitosamente.</p>
    <a href="<%=request.getContextPath()%>/login" class="btn btn-primary btn-updated">
      <i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión
    </a>
  </div>
</div>
</body>
</html>