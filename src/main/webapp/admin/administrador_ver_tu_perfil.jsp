<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Mi Perfil - Administrador</title>
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
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="AdminServlet?action=dashboard">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">Menú del administrador</li>
                <li class="sidebar-item ">
                    <a class="sidebar-link" href="AdminServlet?action=dashboard">
                        <i class="align-middle" data-feather="pie-chart"></i> <span
                            class="align-middle">Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="AdminServlet?action=listaUsuarios">
                        <i class="align-middle" data-feather="user-check"></i> <span
                            class="align-middle">Usuarios</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="AdminServlet?action=nuevoCoordinador">
                        <i class="align-middle" data-feather="user-plus"></i> <span class="align-middle">Crear coordinadores</span>
                    </a>
                </li>
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
                        <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
                            <img src="<%=request.getContextPath()%>/fotos/<%=admin.getProfilePhotoUrl()%>"
                                 class="avatar img-fluid rounded me-1" alt="Foto"/>
                            <span class="text-dark"><%=admin.getNombre()%> <%=admin.getApellidoPaterno()%></span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="AdminServlet?action=verPerfil"><i class="align-middle me-1"
                                                                                             data-feather="user"></i>
                                Ver Perfil</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <main class="content">
            <div class="container">
                <div class="profile-card">
                    <div class="profile-header">
                        <% if (admin.getProfilePhotoUrl() != null && !admin.getProfilePhotoUrl().isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/fotos/<%= admin.getProfilePhotoUrl() %>"
                             alt="Foto de perfil" class="profile-photo">
                        <% } else { %>
                        <div class="profile-photo bg-secondary d-flex align-items-center justify-content-center">
                            <span class="text-white display-4"><%= admin.getNombre().charAt(0) %></span>
                        </div>
                        <% } %>
                        <h2><%= admin.getNombre() %> <%= admin.getApellidoPaterno() %>
                        </h2>
                        <h5 class="text-muted">Administrador del Sistema</h5>
                    </div>

                    <div class="profile-info">
                        <div class="mb-3">
                            <strong>DNI:</strong> <%= admin.getDni() %>
                        </div>
                        <div class="mb-3">
                            <strong>Correo:</strong> <%= admin.getCorreo() %>
                        </div>
                        <div class="mb-3">
                            <strong>Estado:</strong>
                            <span class="badge bg-success">Activo</span>
                        </div>
                        <div class="mb-3">
                            <strong>Última conexión:</strong> <%= admin.getUltimaConexion() %>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <ul class="list-unstyled mb-0">
                                <li class="mb-2 position-relative">
                                    <a href="AdminServlet?action=cambiarContrasena" class="btn btn-secondary w-100 position-relative text-center">
                                        <i class="position-absolute start-0 ms-3 top-50 translate-middle-y" data-feather="lock"></i>
                                        Cambiar contraseña
                                    </a>
                                </li>
                                <li class="mb-2 position-relative">
                                    <form action="AdminServlet?action=uploadPhoto" method="post" enctype="multipart/form-data" id="photoForm">
                                        <input type="file" id="photoInput" name="foto" accept="image/jpeg, image/png" style="display: none;">
                                        <button type="button" class="btn btn-secondary w-100 position-relative text-center" onclick="document.getElementById('photoInput').click()">
                                            <i class="position-absolute start-0 ms-3 top-50 translate-middle-y" data-feather="image"></i>
                                            Cambiar foto
                                        </button>
                                    </form>
                                </li>
                                <li class="mb-2 position-relative">
                                    <a href="AdminServlet?action=dashboard" class="btn btn-secondary w-100 position-relative text-center">
                                        <i class="position-absolute start-0 ms-3 top-50 translate-middle-y" data-feather="chevrons-left"></i>
                                        Volver al Panel
                                    </a>
                                </li>
                            </ul>

                        </div>
                    </div>
                </div>
            </div>
        </main>
        <footer class="footer">
            <div class="container-fluid">
                <div class="row text-muted">
                    <div class="col-6 text-start">
                        <p class="mb-0">
                            <a class="text-muted" href="https://adminkit.io/" target="_blank"><strong>AdminKit</strong></a>
                            &copy;
                        </p>
                    </div>
                    <div class="col-6 text-end">
                        <ul class="list-inline">
                            <li class="list-inline-item"><a class="text-muted" href="#">Soporte</a></li>
                            <li class="list-inline-item"><a class="text-muted" href="#">Centro de Ayuda</a></li>
                            <li class="list-inline-item"><a class="text-muted" href="#">Privacidad</a></li>
                            <li class="list-inline-item"><a class="text-muted" href="#">Términos</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</div>
<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Inicializar feather icons
        feather.replace();

        // Manejar el toggle del sidebar


        // Manejar el cambio de foto
        document.getElementById('photoInput').addEventListener('change', function() {
            if(this.files.length > 0) {
                document.getElementById('photoForm').submit();
            }
        });

        <% if (session.getAttribute("photoSuccess") != null) { %>
        alert("<%= session.getAttribute("photoSuccess") %>");
        <% session.removeAttribute("photoSuccess"); %>
        <% } %>

        <% if (session.getAttribute("photoError") != null) { %>
        alert("<%= session.getAttribute("photoError") %>");
        <% session.removeAttribute("photoError"); %>
        <% } %>
    });
</script>
</body>
</html>