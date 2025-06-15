<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Usuario usuario = (Usuario) request.getAttribute("detalles");
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Perfil de usuario</title>
  <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
  <style>
    .profile-card {
      max-width: 600px;
      margin: 2rem auto;
      padding: 2rem;
      box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      border-radius: 1rem;
    }

    .profile-header {
      text-align: center;
      margin-bottom: 1.5rem;
    }

    .profile-photo {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      object-fit: cover;
      margin-bottom: 1rem;
      border: 4px solid #0d6efd;
    }
  </style>
</head>
<body>
<main class="content">
  <div class="container">
    <div class="profile-card">
      <div class="profile-header">
        <% if (usuario.getProfilePhotoUrl() != null && !usuario.getProfilePhotoUrl().isEmpty()) { %>
        <img src="<%= request.getContextPath() %>/fotos/<%= usuario.getProfilePhotoUrl() %>"
             alt="Foto de perfil" class="profile-photo">
        <% } else { %>
        <div class="profile-photo bg-secondary d-flex align-items-center justify-content-center">
          <span class="text-white display-4"><%= usuario.getNombre().charAt(0) %></span>
        </div>
        <% } %>
        <h2><%= usuario.getNombre() %> <%= usuario.getApellidoPaterno() %>
        </h2>
        <h5 class="text-muted">Rol de <%= usuario.  getRol().getNombre() %></h5>
      </div>

      <div class="profile-info">
        <div class="mb-3">
          <strong>DNI:</strong> <%= usuario.getDni() %>
        </div>
        <div class="mb-3">
          <strong>Correo:</strong> <%= usuario.getCorreo() %>
        </div>
        <div class="mb-3">
          <strong>Estado:</strong>
          <% if (usuario.getEstado().equalsIgnoreCase("activo")) { %>
                                <span class="badge bg-success status-badge">Activo</span>
                                <% } else { %>
                                <span class="badge bg-danger status-badge">Inactivo</span>
                                <% } %>
        </div>
        <div class="mb-3">
          <strong>Última conexión:</strong> <%= usuario.getUltimaConexion() %>
        </div>


      </div>
    </div>
  </div>
</main>
<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
</body>
</html>
