<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario, org.example.onu_mujeres_crud.beans.Distrito, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <%Usuario user = (Usuario) session.getAttribute("usuario");%>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="ONU Mujeres - Editar Perfil">
    <meta name="author" content="ONU Mujeres">
    <meta name="keywords" content="onu, mujeres, encuestas, administración">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="img/icons/icon-48x48.png" />

    <title>Editar Perfil - ONU Mujeres</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>

        /* Sidebar mejorado */
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

        .nombre {
            font-weight: bold;
        }

        .rol {
            font-size: 0.9em;
            color: #888;
        }

        .profile-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
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
<script type="text/javascript" src="js/app.js"></script>
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="EncuestadorServlet?action=total">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">Encuestas</li>
                <li class="sidebar-item">
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
                <li class="sidebar-header">
                    Perfil
                </li>
                <li class="sidebar-item active">
                    <a class="sidebar-link" href="EncuestadorServlet?action=ver">
                        <i class="align-middle" data-feather="user"></i> <span class="align-middle">Mi Perfil</span>
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
                            <a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
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
                    <h1 class="h3 d-inline align-middle">Editar Perfil</h1>
                </div>

                <div class="row">
                    <div class="col-12">
                        <div class="profile-container">
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

                            <form action="EncuestadorServlet?action=updateProfile" method="post">
                                <div class="mb-3">
                                    <label for="direccion" class="form-label">Dirección</label>
                                    <input type="text" class="form-control" id="direccion" name="direccion"
                                           value="${usuario.direccion}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="distrito" class="form-label">Distrito</label>
                                    <select class="form-select" id="distrito" name="distrito" required>
                                        <option value="">Seleccione un distrito</option>
                                        <%
                                            ArrayList<Distrito> distritos = (ArrayList<Distrito>) request.getAttribute("distritos");
                                            Usuario usuario = (Usuario) session.getAttribute("usuario");
                                            for (Distrito distrito : distritos) {
                                        %>
                                        <option value="<%= distrito.getDistritoId() %>"
                                                <%= usuario.getDistrito() != null && usuario.getDistrito().getDistritoId() == distrito.getDistritoId() ? "selected" : "" %>>
                                            <%= distrito.getNombre() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                                    <a href="EncuestadorServlet?action=ver" class="btn btn-secondary">Volver al perfil</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>

<script src="js/app.js"></script>
<script type="text/javascript" src="js/app.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
</body>
</html>