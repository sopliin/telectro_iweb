<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%-- If you have the coordinator user in session, you can use it here --%>
<% Usuario user = (Usuario) session.getAttribute("usuario"); %>
<% Usuario usuario = (Usuario) request.getAttribute("detalles"); %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
  <meta name="author" content="AdminKit">
  <meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/onu_mujeres/static/img/icons/icon-48x48.png" />
  <link rel="canonical" href="https://demo-basic.adminkit.io/" />
  <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
  <title>Perfil de Encuestador - Coordinador - Administrador</title>
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(120deg, #f8fafc 0%, #e9ecef 100%);
    }
    /* Sidebar mejorado - Estilos copiados de coordinador_encuestadores.jsp */
    .sidebar {
      background: linear-gradient(195deg, #42424a, #191919) !important; /* Fondo oscuro elegante */
      color: rgba(255, 255, 255, 0.8) !important;
    }
    .sidebar .sidebar-brand {
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }
    .sidebar-link {
      color: rgba(255, 255, 255, 0.7) !important;
      transition: all 0.2s ease-in-out;
    }
    /* Estilo para el elemento activo de la sidebar - como en la imagen 'Encuestadores de zona' */
    .sidebar-item.active > .sidebar-link {
      color: #ffffff !important;
      background-color: transparent !important; /* Fondo transparente */
      border-left: 5px solid #007bff; /* Borde izquierdo azul fuerte */
      padding-left: calc(1.5rem - 5px); /* Ajustar padding para compensar el borde */
      border-radius: 0; /* Sin bordes redondeados en este lado */
      box-shadow: none; /* Eliminar sombra para este estilo */
    }
    .sidebar-item.active > .sidebar-link:hover {
      background-color: rgba(255, 255, 255, 0.05) !important; /* Un ligero hover */
    }
    .sidebar-link:hover { /* Estilo de hover general */
      color: #ffffff !important;
      background-color: rgba(255, 255, 255, 0.1) !important;
      border-radius: 0.5rem;
    }

    .sidebar-header {
      color: rgba(255, 255, 255, 0.5) !important;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .sidebar-link {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .sidebar-link .text-nowrap {
      white-space: nowrap;
    }

    /* Navbar y avatar */
    .navbar {
      min-height: 56px;
      background-color: #ffffff !important; /* Navbar blanca */
      box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }
    .navbar-nav .nav-item {
      display: flex;
      align-items: center;
      height: 100%;
    }
    .navbar-align .nav-item .dropdown-toggle {
      display: flex;
      align-items: center;
      height: 100%;
      padding-top: 0;
      padding-bottom: 0;
      padding-left: 1rem;
      padding-right: 1rem;
    }
    /* Estilo para la imagen de perfil del usuario */
    .user-avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      object-fit: cover;
      margin-right: 0.5rem;
      flex-shrink: 0;
      border: 2px solid #e9ecef; /* Pequeño borde para la foto de perfil */
    }
    /* Contenedor del nombre y rol */
    .navbar-align .nav-item .dropdown-toggle .user-info-container {
      display: flex;
      flex-direction: column;
      justify-content: center;
      line-height: 1.2;
      white-space: nowrap;
    }
    .navbar-align .nav-item .dropdown-toggle .user-info-container .text-dark {
      line-height: 1.2;
      font-weight: 600; /* Negrita para el nombre */
      color: #344767 !important;
    }
    .navbar-align .nav-item .dropdown-toggle .user-info-container .text-muted {
      font-size: 0.75em;
      line-height: 1.2;
      text-transform: uppercase; /* Rol en mayúsculas */
      color: #6c757d !important;
    }
    /* Espaciado del botón desplegable (flecha) a la derecha del nombre/rol */
    .navbar-align .nav-item .dropdown-toggle::after {
      margin-left: 0.5rem;
    }

    .user-info-container .text-dark {
      font-weight: 700;
      color: #344767 !important;
      font-size: 1.05em;
    }
    .user-info-container .text-muted {
      font-size: 0.8em;
      text-transform: uppercase;
      color: #6c757d !important;
      letter-spacing: 0.04em;
    }

    /* Cabecera del perfil */
    .profile-header {
      display: flex;
      align-items: center;
      gap: 28px;
      margin-bottom: 36px;
      padding: 32px 24px 24px 24px;
      /*background: linear-gradient(195deg, #42424a, #191919) !important; !* Fondo oscuro elegante *!*/
      background: rgba(34,46,60,0.95) !important;
      color: rgba(255, 255, 255, 0.8) !important;
      border-radius: 1.2rem 1.2rem 0 0;
      /*box-shadow: 0 4px 16px rgba(0,123,255,0.08);*/
    }
    .profile-header img {
      width: 110px;
      height: 110px;
      border-radius: 50%;
      object-fit: cover;
      border: 4px solid #fff;
      box-shadow: 0 4px 16px rgba(0,123,255,0.15);
      background: #e9ecef;
    }
    .profile-header h1 {
      margin: 0;
      font-size: 2.2rem;
      color: #fff;
      font-weight: 700;
      text-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }

    /* Card principal */
    .card {
      border-radius: 1.2rem;
      box-shadow: 0 1.5rem 2.5rem rgba(0, 123, 255, 0.08), 0 0.5rem 1rem rgba(52,71,103,0.06);
      border: none;
      background: #fff;
      margin-top: -30px;
    }
    .card-header {
      background: #222e3c;
      border-bottom: 1px solid #e9ecef;
      padding: 1.7rem 1.5rem 1.2rem 1.5rem;
      border-radius: 1.2rem 1.2rem 0 0;
    }
    .card-title {
      font-size: 1.35rem;
      font-weight: 700;
      color: #222e3c;
      letter-spacing: 0.01em;
    }
    .card-body {
      padding: 2rem 1.7rem 1.7rem 1.7rem;
    }

    /* Tabla de detalles */
    .table-bordered {
      border-radius: 0.7rem;
      overflow: hidden;
      background: #f8fafc;
    }
    .table-bordered th, .table-bordered td {
      border-color: #e9ecef;
      padding: 1.05rem 1.5rem;
      font-family: 'Inter', sans-serif;
      vertical-align: middle;
    }
    .table-bordered th {
      width: 35%;
      background: #e3eafc;
      color: #222e3c;
      font-weight: 700;
      text-transform: uppercase;
      font-size: 0.93em;
      letter-spacing: 0.04em;
      border-right: 2px solid #e9ecef;
    }
    .table-bordered td {
      font-weight: 500;
      /*color: #222e3c;*/
      font-size: 0.93em;
    }
    .table-bordered tr:nth-child(even) td {
      background: #f0f4fa;
    }
    .table-bordered tr:hover td {
      background: #e3eafc;
      transition: background 0.2s;
    }

    /* Badge de estado */
    .badge {
      padding: 0.6em 1.1em;
      border-radius: 0.7rem;
      font-size: 0.92em;
      font-weight: 700;
      text-transform: uppercase;
      /*box-shadow: 0 2px 8px rgba(0,123,255,0.08);*/
      letter-spacing: 0.04em;
    }
    .bg-success {
      background: #28a745 !important;
      background: linear-gradient(195deg, #12830b 0%, #15830b 100%) !important;
      color: #fff !important;
    }
    .bg-danger {
      background: linear-gradient(195deg, #dc3545 0%, #dc3555 100%) !important;
      color: #fff !important;
    }

    /* Botón de volver */
    .btn-secondary {
      background: #222e3c;
      border: none;
      color: #fff;
      padding: 0.7rem 1.5rem;
      border-radius: 0.7rem;
      font-weight: 700;
      font-size: 1.05em;
      transition: all 0.2s cubic-bezier(.4,0,.2,1);
      box-shadow: 0 2px 8px rgba(52,71,103,0.08);
    }
    .btn-secondary:hover {
      background: linear-gradient(90deg, #222e3c 0%, #343a40 100%);
      transform: translateY(-2px) scale(1.03);
      box-shadow: 0 4px 16px rgba(52,71,103,0.15);
    }

    /* Footer */
    .footer {
      background: #f8fafc;
      border-top: 1px solid #e9ecef;
      padding: 1.2rem 0 0.7rem 0;
      font-size: 0.98em;
      color: #6c757d;
    }
    .footer a.text-muted:hover {
      color: #007bff !important;
      text-decoration: underline;
    }

    .nombre {
      font-weight: bold;
    }

    .rol {
      font-size: 0.9em;
      color: #888;
    }

  </style>
  <style>


    .footer .row {
      flex-wrap: wrap; /* Permite que los elementos se ajusten en móviles */
    }

    .footer .col-6 {
      width: 100% !important; /* Ocupa todo el ancho en móviles */
      text-align: center !important; /* Centra el texto */
      margin-bottom: 0.5rem; /* Espacio entre elementos */
    }

    .footer .list-inline {

      flex-wrap: wrap; /* Permite que los ítems se ajusten */
    }

    .footer .list-inline-item {
      margin: 0 0.5rem; /* Espacio entre ítems */
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
        <li class="sidebar-header">Menú del administrador</li>
        <li class="sidebar-item ">
          <a class="sidebar-link" href="AdminServlet?action=dashboard">
            <i class="align-middle" data-feather="pie-chart"></i> <span class="align-middle">Dashboard</span>
          </a>
        </li>
        <li class="sidebar-item <%= (request.getParameter("action") != null && request.getParameter("action").equals("listaUsuarios")) ? "active" : "" %>">
          <a class="sidebar-link" href="AdminServlet?action=listaUsuarios">
            <i class="align-middle" data-feather="user-check"></i> <span class="align-middle">Usuarios</span>
          </a>
        </li>
        <li class="sidebar-item">
          <a class="sidebar-link" href="AdminServlet?action=nuevoCoordinador">
            <i class="align-middle" data-feather="user-plus"></i> <span class="align-middle">Crear coordinadores</span>
          </a>
        </li>
        <li class="sidebar-header">Perfil</li>
        <li class="sidebar-item active">
          <a class="sidebar-link" href="AdminServlet?action=detallesUsuario&id=${param.id}">
            <i class="align-middle" data-feather="user"></i> <span class="align-middle">Perfil del usuario</span>
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
            <a class="nav-link dropdown-toggle    " href="#" data-bs-toggle="dropdown">
              <%-- Aquí se reemplaza el icono Feather por la imagen de perfil --%>
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
              <a class="dropdown-item" href="AdminServlet?action=desactivarUsuario&id=${param.id}"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
            </div>
          </li>
        </ul>
      </div>
    </nav>

    <main class="content">
      <div class="container-fluid p-0">
        <div class="profile-header">
          <h1><i class="align-middle me-2" data-feather="user"></i> Perfil del Usuario</h1>
        </div>

        <div class="card shadow-sm">
          <div class="card-body">
            <h5 class="card-title mb-4"><i class="align-middle me-2" data-feather="info"></i> Detalles del <%= usuario.getRol().getNombre() %></h5>
            <table class="table table-bordered mb-0">
              <tr>
                <th><i class="align-middle me-1" data-feather="user"></i> Nombre</th>
                <td class="text-uppercase"><%= usuario.getNombre() %></td>
              </tr>
              <tr>
                <th><i class="align-middle me-1" data-feather="users"></i> Apellidos</th>
                <td class="text-uppercase"><%= usuario.getApellidoPaterno() + " " + usuario.getApellidoMaterno() %></td>
              </tr>
              <tr>
                <th><i class="align-middle me-1" data-feather="credit-card"></i> DNI</th>
                <td><%= usuario.getDni() %></td>
              </tr>
              <tr>
                <th><i class="align-middle me-1" data-feather="mail"></i> Email</th>
                <td style="font-style: italic"><%= usuario.getCorreo() %></td>
              </tr>
              <tr>
                <th><i class="align-middle me-1" data-feather="map-pin"></i> Zona / Distrito</th>
                <td class="text-uppercase"><%= usuario.getZona().getNombre() %> / <%= usuario.getDistrito().getNombre() %></td>
              </tr>
              <tr>
                <th><i class="align-middle me-1" data-feather="activity"></i> Estado</th>
                <td>
                  <div class="d-flex align-items-center"> <%-- Contenedor flex para alinear el badge y el botón --%>
                    <%-- Muestra el badge de estado --%>
                    <span class="badge <%= usuario.getEstado().equalsIgnoreCase("activo") ? "bg-success" : "bg-danger" %> me-2">
                      <i class="align-middle me-1" data-feather="<%= usuario.getEstado().equalsIgnoreCase("activo") ? "check-circle" : "x-circle" %>"></i>
                      <%= usuario.getEstado().equalsIgnoreCase("activo") ? "ACTIVO" : "INACTIVO" %>
                    </span>
                  </div>
                </td>
              </tr>
            </table>
            <div class="mt-4 text-end">
              <a href="AdminServlet?action=listaUsuarios" class="btn btn-secondary"><i class="align-middle me-1" data-feather="arrow-left"></i> Volver a la lista</a>
            </div>
          </div>
        </div>
      </div>
    </main>
    <jsp:include page="../includes/footer.jsp"/>
  </div>
</div>
<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    feather.replace();
  });
</script>
</body>
</html>




<%--<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>--%>
<%--<%@ page import="java.time.format.DateTimeFormatter" %>--%>
<%--<%@ page import="java.time.LocalDateTime" %>--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%--%>
<%--  Usuario usuario = (Usuario) request.getAttribute("detalles");--%>
<%--%>--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Perfil de usuario</title>--%>
<%--  <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">--%>
<%--  <style>--%>

<%--  </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<main class="content">--%>

<%--  <div class="container">--%>
<%--    <div class="profile-card">--%>
<%--      <div class="profile-header">--%>
<%--        <% if (usuario.getProfilePhotoUrl() != null && !usuario.getProfilePhotoUrl().isEmpty()) { %>--%>
<%--        <img src="<%= request.getContextPath() %>/fotos/<%= usuario.getProfilePhotoUrl() %>"--%>
<%--             alt="Foto de perfil" class="profile-photo">--%>
<%--        <% } else { %>--%>
<%--        <div class="profile-photo bg-secondary d-flex align-items-center justify-content-center">--%>
<%--          <span class="text-white display-4"><%= usuario.getNombre().charAt(0) %></span>--%>
<%--        </div>--%>
<%--        <% } %>--%>
<%--        <h2><%= usuario.getNombre() %> <%= usuario.getApellidoPaterno() %>--%>
<%--        </h2>--%>
<%--        <h5 class="text-muted">Rol de <%= usuario.  getRol().getNombre() %></h5>--%>
<%--      </div>--%>

<%--      <div class="profile-info">--%>
<%--        <div class="mb-3">--%>
<%--          <strong>DNI:</strong> <%= usuario.getDni() %>--%>
<%--        </div>--%>
<%--        <div class="mb-3">--%>
<%--          <strong>Correo:</strong> <%= usuario.getCorreo() %>--%>
<%--        </div>--%>
<%--        <div class="mb-3">--%>
<%--          <strong>Estado:</strong>--%>
<%--          <% if (usuario.getEstado().equalsIgnoreCase("activo")) { %>--%>
<%--                                <span class="badge bg-success status-badge">Activo</span>--%>
<%--                                <% } else { %>--%>
<%--                                <span class="badge bg-danger status-badge">Inactivo</span>--%>
<%--                                <% } %>--%>
<%--        </div>--%>
<%--        <div class="mb-3">--%>
<%--          <%--%>
<%--            String fechaOriginal = usuario.getFechaRegistro();--%>
<%--            DateTimeFormatter formatoEntrada = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");--%>
<%--            LocalDateTime fecha = LocalDateTime.parse(fechaOriginal, formatoEntrada);--%>
<%--            DateTimeFormatter formatoSalida = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");--%>
<%--            String fechaFormateada = fecha.format(formatoSalida);--%>
<%--          %>--%>
<%--          <strong>Última conexión:</strong> <%= fechaFormateada %>--%>
<%--        </div>--%>


<%--      </div>--%>
<%--    </div>--%>
<%--  </div>--%>
<%--</main>--%>
<%--<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>--%>
<%--</body>--%>
<%--</html>--%>
