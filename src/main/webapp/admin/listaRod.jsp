<%@page import="java.util.ArrayList" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%Usuario user = (Usuario) session.getAttribute("usuario");%>
<%
    int paginaActual = (request.getAttribute("paginaActual") != null) ? (Integer) request.getAttribute("paginaActual") : 1;
    int totalPaginas = (request.getAttribute("totalPaginas") != null) ? (Integer) request.getAttribute("totalPaginas") : 1;
    int totalUsuarios = (request.getAttribute("totalUsuarios") != null) ? (Integer) request.getAttribute("totalUsuarios") : 0;

    // Mantener los parámetros de filtro para la paginación
    String filtroRol = request.getParameter("filtroRol");
    String filtroEstado = request.getParameter("filtroEstado");
    String filtroBusqueda = request.getParameter("filtroBusqueda");


%>
<!DOCTYPE html>
<html>
<head>
    <title>Lista de Usuarios - Administrador</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no">
    <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

    <style>

        .table-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            padding: 20px;
            margin-top: 20px;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.35em 0.65em;
        }

        .action-buttons .btn {
            margin-right: 5px;
            margin-bottom: 5px;
        }
        .search-filter {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        /* Estilo para el texto del Nombre y Apellidos (en mayúsculas) */
        .list-text {
            color: #343a40; /* Color gris oscuro */
            font-weight: 350;
            font-size: 0.9em; /* Ligeramente más grande*/
            text-transform: uppercase; /* Asegurar mayúsculas */
            white-space: nowrap; /* Evita que el texto se parta en varias líneas */
        }

        /* Nuevos estilos para el círculo de estado */
        .status-container, .form-action-group, .ban-action-group {
            display: flex;
            align-items: center; /* Centrar verticalmente los elementos */
            justify-content: flex-start; /* Alinear a la izquierda */
            white-space: nowrap;
            height: 100%; /* Asegurar que ocupan toda la altura de la celda */
        }
        /* Flex container for action buttons */
        .action-buttons-container {
            display: flex;
            align-items: center; /* Aliena verticalmente los elementos dentro del contenedor */
            gap: 0.5rem; /* Espacio entre los botones/textos */
            flex-wrap: wrap; /* Permite que los elementos se envuelvan en pantallas pequeñas */
        }
        .action-buttons-container > div {
            display: flex;
            align-items: center;
        }

        .status-dot {
            height: 10px;
            width: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
            flex-shrink: 0;
        }

        .status-active .status-dot {
            background-color: #28a745;
        }

        .status-active .status-dot {
            background-color: #28a745;
        }

        .status-banned .status-dot {
            background-color: #dc3545;
        }

        /* ESTILO ESPECÍFICO PARA TEXTOS DE ACCIÓN (ASIGNAR, BANEAR, ACTIVAR) */
        .action-text {
            color: #343a40;
            font-weight: 350;
            font-size: 0.9em;
            text-transform: uppercase;
            white-space: nowrap;
            margin-right: 0.4rem; /* Reducido para acercar el texto al botón */
            height: 32px; /* Misma altura que el botón para una mejor alineación*/
            line-height: 32px; /* Centra el texto verticalmente en su altura */
        }

        /* Estilo adicional para los botones para asegurar uniformidad */
        .btn-uniform {
            min-width: 90px;
            text-align: center;
            display: inline-block;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            line-height: 1.5;
        }

        /* Estilo para el botón de icono de perfil */
        .btn-icon-profile {
            background: none; /* Asegura que no hay fondo de botón */
            border: none; /* Elimina el borde del botón */
            padding: 0; /* Elimina todo el padding para que solo el ícono ocupe espacio */
            align-items: center; /* Centra verticalmente */
            justify-content: center; /* Centra horizontalmente */
            width: 36px; /* Ajusta este valor al tamaño deseado del ícono/enlace */
            height: 36px; /* Ajusta este valor al tamaño deseado del ícono/enlace */
            cursor: pointer;
            color: #343a40; /* Color oscuro para el ícono, similar al texto del nombre  */
            transition: color 0.2s ease-in-out;
            margin-right: 8px; /* Mayor separación del nombre */
        }
        .btn-icon-profile:hover {
            color: #007bff; /* Color azul al pasar el ratón */
        }
        .btn-icon-profile i {
            font-size: 1.25rem; /* Tamaño del ícono */
            margin: 0; /* Asegura que el ícono no tenga márgenes internos */
        }

        /* Estilos para el botón de icono (sin texto) */
        .icon-only-button {
            padding: 0.3rem 0.5rem !important; /* Padding ligeramente ajustado para compactar el botón */
            border-radius: 0.75rem !important; /* Bordes redondeados, un poco menos que el status chip */
            transition: all 0.2s ease-in-out !important;
            display: flex !important; /* Asegura que el ícono esté centrado */
            align-items: center !important;
            justify-content: center !important;
            min-width: 35px !important; /* Un ancho mínimo para el botón del ícono (reducido) */
            height: 32px !important; /* Altura fija para el botón del ícono*/
        }
        .icon-only-button i {
            font-size: 1rem; /* Tamaño del ícono */
            margin: 0; /* No margin extra en el ícono */
        }

        .action-text {
            color: #343a40;
            font-weight: 350;
            font-size: 0.9em;
            text-transform: uppercase;
            white-space: nowrap;
            margin-right: 0.4rem;
            height: 32px;
            line-height: 32px;
        }

        .btn-ban-icon {
            background-color: #dc3545 !important;
            border-color: #dc3545 !important;
            color: white !important;
        }
        .btn-ban-icon:hover {
            background-color: #c82333 !important;
            border-color: #bd2130 !important;
        }

        .btn-activate-icon {
            background-color: #28a745 !important;
            border-color: #28a745 !important;
            color: white !important;
        }
        .btn-activate-icon:hover {
            background-color: #218838 !important;
            border-color: #1e7e34 !important;
        }
        .btn-info {
            background-color: #17a2b8;
            border-color: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background-color: #138496;
            border-color: #117a8b;
        }

        /* Redondear los bordes de la tarjeta de la tabla con sombra */
        .card {
            border-radius: 1rem; /* Aumentado el radio para un efecto más notorio */
            overflow: hidden; /* Asegura que el contenido interno se recorte con el border-radius */
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); /* Sombra sutil */
        }

        .card-header {
            padding-left: 1.2rem; /* Ajuste el padding izquierdo del card-header*/
            padding-right: 1.5rem;
            padding-top: 1.5rem; /* Separación superior para el título */
            padding-bottom: 1rem; /* Separación inferior para el título */
        }
        .card-header .card-title {
            margin-bottom: 0;
            font-size: 1.25rem;
        }

        /* AJUSTES DE PADDING PARA ALINEACIÓN DE ENCABEZADOS Y CELDAS */
        .table-hover thead th,
        .table-hover tbody td {
            padding-left: 1.5rem; /* Ajuste el padding izquierdo para alinear las letras iniciales*/
            padding-right: 1.5rem; /* Mantener padding derecho */
            vertical-align: middle; /* Asegura que el contenido de la celda se alinee al medio */
        }

        /* Mover el ícono de perfil más a la izquierda usando un margen negativo para mayor separación */
        .table-hover tbody td:first-child .btn-icon-profile {
            margin-left: -1rem; /* Ajustado para el nuevo padding*/
            margin-right: 0.5rem;
        }

        /* Ajustes de ancho para las columnas */
        .table-hover thead th:nth-child(1) { min-width: 2rem; }
        .table-hover thead th:nth-child(2) { min-width: 2rem; }
        .table-hover thead th:nth-child(3) { min-width: 2rem; }
        .table-hover thead th:nth-child(4) { min-width: 2rem; white-space: nowrap; }
        .table-hover thead th:nth-child(5) { min-width: 2rem; }
        .table-hover thead th:nth-child(6) { min-width: 2rem; }
        .table-hover thead th:nth-child(7) { min-width: 2rem; /* Aumentado para los dos botones y texto */ }

        .table-hover tbody td .d-flex .text-dark {
            margin-right: 8px; /* Ajusta este valor según la separación deseada */
        }

    </style>
    <style>
        .wrapper {
            display: flex;
            min-height: 100vh; /* Ocupa al menos el 100% del viewport */
            overflow-x: hidden;
        }
        /*.sidebar {*/
        /*    height: 100vh; !* Altura completa del viewport *!*/

        /*    left: 0;*/
        /*    top: 0;*/
        /*    z-index: 1000; !* Asegura que esté por encima del contenido *!*/
        /*    overflow-y: auto; !* Permite scroll si el contenido es muy largo *!*/
        /*}*/

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
    <nav id="sidebar" class="sidebar js-sidebar ">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="AdminServlet?action=menu">
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
            </ul>
        </div>
    </nav>
    <div class="main ">
        <nav class="navbar navbar-expand navbar-light navbar-bg">
            <a class="sidebar-toggle js-sidebar-toggle"><i class="hamburger align-self-center"></i></a>
            <div class="navbar-collapse collapse">
                <ul class="navbar-nav navbar-align">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle " href="#" data-bs-toggle="dropdown">
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
                            <a class="dropdown-item" href="AdminServlet?action=verPerfil"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main content -->
        <main class="content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Gestión de Usuarios</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="AdminServlet?action=nuevoCoordinador" class="btn btn-primary me-2">
                        <i class="bi bi-plus-circle"></i> Nuevo Coordinador
                    </a>
                </div>
            </div>

            <!-- Mensajes de éxito/error -->
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Operación realizada con éxito
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <!-- Filtros y búsqueda -->
            <div class="search-filter">
                <form method="GET" action="AdminServlet" class="row g-3">
                    <input type="hidden" name="action" value="listaUsuarios">
                    <input type="hidden" name="registrosPorPagina" value="<%= request.getParameter("registrosPorPagina") != null ? request.getParameter("registrosPorPagina") : "7" %>">
                    <div class="col-md-3">
                        <label for="filtroRol" class="form-label">Rol</label>
                        <select id="filtroRol" name="filtroRol" class="form-select">
                            <option value="">Todos</option>
                            <option value="1" <%= "1".equals(request.getParameter("filtroRol")) ? "selected" : "" %>>Encuestador</option>
                            <option value="2" <%= "2".equals(request.getParameter("filtroRol")) ? "selected" : "" %>>Coordinador</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="filtroEstado" class="form-label">Estado</label>
                        <select id="filtroEstado" name="filtroEstado" class="form-select">
                            <option value="">Todos</option>
                            <option value="activo" <%= "activo".equals(request.getParameter("filtroEstado")) ? "selected" : "" %>>Activo</option>
                            <option value="baneado" <%= "baneado".equals(request.getParameter("filtroEstado")) ? "selected" : "" %>>Inactivo</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label for="filtroBusqueda" class="form-label">Buscar</label>
                        <div class="input-group">
                            <input type="text" id="filtroBusqueda" name="filtroBusqueda"
                                   class="form-control" placeholder="Nombre, DNI o correo"
                                   value="<%= request.getParameter("filtroBusqueda") != null ? request.getParameter("filtroBusqueda") : "" %>">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Filtrar
                            </button>
                        </div>
                    </div>

                    <div class="col-md-2 d-flex align-items-end">
                        <a href="AdminServlet?action=listaUsuarios" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-counterclockwise"></i> Limpiar
                        </a>
                    </div>
                </form>
            </div>

            <div class="d-flex justify-content-between align-items-end mb-3 pb-2">
                <!-- Reportes -->
                <div>
                    <form action="AdminServlet?action=generarReporte" method="post" class="row g-3 align-items-center">
                        <div class="col-auto">
                            <label class="col-form-label">Generar reporte:</label>
                        </div>
                        <div class="col-auto">
                            <select name="tipoReporte" class="form-select">
                                <option value="todos">Todos los usuarios</option>
                                <option value="activos">Solo activos</option>
                                <option value="inactivos">Solo inactivos</option>
                                <option value="coordinadores">Coordinadores</option>
                                <option value="encuestadores">Encuestadores</option>
                                <option value="respuestas">Respuestas de Encuesta</option>
                            </select>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-file-earmark-excel"></i> Exportar Excel
                            </button>
                        </div>
                    </form>
                </div>

                <%
                    int registrosPorPagina = (request.getAttribute("registrosPorPagina") != null)
                            ? (Integer) request.getAttribute("registrosPorPagina")
                            : 7;
                %>

                <%
                    // Construir parámetros de filtro para mantenerlos
                    String filterParams = "";
                    if (filtroRol != null && !filtroRol.isEmpty()) {
                        filterParams += "&filtroRol=" + filtroRol;
                    }
                    if (filtroEstado != null && !filtroEstado.isEmpty()) {
                        filterParams += "&filtroEstado=" + filtroEstado;
                    }
                    if (filtroBusqueda != null && !filtroBusqueda.isEmpty()) {
                        filterParams += "&filtroBusqueda=" + URLEncoder.encode(filtroBusqueda, "UTF-8");
                    }
                    filterParams += "&page=" + paginaActual;
                    filterParams += "&registrosPorPagina=" + registrosPorPagina;
                %>

                <!-- Registros por página -->
                <div>
                    <form id="formRegistrosPorPagina" method="GET" action="AdminServlet" class="row g-3 align-items-center">
                        <input type="hidden" name="action" value="listaUsuarios">
                        <input type="hidden" name="action" value="listaUsuarios">
                        <input type="hidden" name="filtroRol" value="<%= request.getParameter("filtroRol") != null ? request.getParameter("filtroRol") : "" %>">
                        <input type="hidden" name="filtroEstado" value="<%= request.getParameter("filtroEstado") != null ? request.getParameter("filtroEstado") : "" %>">
                        <input type="hidden" name="filtroBusqueda" value="<%= request.getParameter("filtroBusqueda") != null ? request.getParameter("filtroBusqueda") : "" %>">

                        <div class="col-auto">
                            <label for="registrosPorPagina" class="col-form-label">Registros por página:</label>
                        </div>
                        <div class="col-auto">
                            <select id="registrosPorPagina" name="registrosPorPagina" class="form-select"
                                    onchange="document.getElementById('formRegistrosPorPagina').submit()">
                                <option value="7" <%= (request.getParameter("registrosPorPagina") == null || request.getParameter("registrosPorPagina").equals("7")) ? "selected" : "" %>>7</option>
                                <option value="15" <%= "15".equals(request.getParameter("registrosPorPagina")) ? "selected" : "" %>>15</option>
                                <option value="30" <%= "30".equals(request.getParameter("registrosPorPagina")) ? "selected" : "" %>>30</option>
                                <option value="50" <%= "50".equals(request.getParameter("registrosPorPagina")) ? "selected" : "" %>>50</option>
                            </select>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card p-2">
                <div class="card-header">
                    <h5 class="card-title mb-0">Lista de Usuarios</h5>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th class="text-uppercase">#</th>
                            <th class="text-uppercase">Nombre</th>
                            <th class="text-uppercase">Apellidos</th>
                            <th class="text-uppercase">Rol</th>
                            <th class="text-uppercase">Zona / Distrito</th>
                            <th class="text-uppercase">Estado</th>
                            <th class="text-uppercase">Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<Usuario> listaUsuarios = (ArrayList<Usuario>) request.getAttribute("listaUsuarios");
                            if (listaUsuarios != null && !listaUsuarios.isEmpty()) {
                                // Calcular el número inicial basado en la página actual
                                int counter = ((paginaActual - 1) * registrosPorPagina) + 1;
                                for (Usuario usuario : listaUsuarios) {
                        %>
                        <tr>
                            <td><%= counter++ %></td>
                            <td>
                                <div class="d-flex align-items-center justify-content-start">
                                    <a href="AdminServlet?action=detallesUsuario&id=<%= usuario.getUsuarioId() %>"
                                       title="Ver detalles" class="text-dark">
                                        <i class="bi bi-person"></i>
                                    </a>
                                    <span class="list-text"><%= usuario.getNombre() %></span>
                                </div>
                            </td>
                            <td class="list-text"><%= usuario.getApellidoPaterno() + " " + usuario.getApellidoMaterno() %></td>
                            <td class="list-text"><%= usuario.getRol().getNombre() %></td>
                            <td>
                                <% if (usuario.getZona() != null) { %>
                                <span class="list-text"><%= usuario.getZona().getNombre() %> /
                                            <%= usuario.getDistrito() != null ? usuario.getDistrito().getNombre() : "N/A" %></span>
                                <% } else { %>
                                <span class="list-text">N/A</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="status-container <%= usuario.getEstado().equalsIgnoreCase("activo") ? "status-active" : "status-banned" %>">
                                    <span class="status-dot"></span>
                                    <span class="status-text list-text"><%= usuario.getEstado().equalsIgnoreCase("activo") ? "ACTIVO" : "INACTIVO" %></span>
                                </div>
                            </td>
                            <td>
                                <div class="action-buttons-container"> <%-- Nuevo contenedor para los botones de acción --%>
                                    <div class="ban-action-group">
                                        <span class="action-text"><%= usuario.getEstado().equalsIgnoreCase("activo") ? "BANEAR" : "ACTIVAR" %></span>
                                        <% if (usuario.getEstado().equalsIgnoreCase("activo")) { %>
                                        <a href="AdminServlet?action=desactivarUsuario&id=<%= usuario.getUsuarioId() %><%=filterParams%>"
                                           class="btn icon-only-button btn-ban-icon"
                                           title="Desactivar usuario"
                                           onclick="return confirm('¿Está seguro de desactivar a el/la <%=usuario.getRol().getNombre() + "/a " + usuario.getNombre()+ " " + usuario.getApellidoPaterno() + " " + usuario.getApellidoMaterno()%>?')">
                                            <i data-feather="${usuario.estado == 'activo' ? 'slash' : 'check-circle'}"></i>
                                        </a>
                                        <% } else { %>
                                        <a href="AdminServlet?action=activarUsuario&id=<%= usuario.getUsuarioId() %><%=filterParams%>"
                                           class="btn icon-only-button btn-activate-icon"
                                           title="Activar usuario"
                                           onclick="return confirm('¿Está seguro de activar a el/la <%=usuario.getRol().getNombre() + "/a " + usuario.getNombre()+ " " + usuario.getApellidoPaterno() + " " + usuario.getApellidoMaterno()%>?')">
                                            <i data-feather="${usuario.estado == 'baneado' ? 'slash' : 'check-circle'}"></i>
                                        </a>
                                        <% } %>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="9" class="text-center">No se encontraron usuarios</td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Paginación -->
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center py-4">
                        <li class="page-item <%= paginaActual == 1 ? "disabled" : "" %>">
                            <a class="page-link"
                               href="AdminServlet?action=listaUsuarios&page=<%= paginaActual - 1 %>&registrosPorPagina=<%= registrosPorPagina %><%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + URLEncoder.encode(filtroBusqueda, "UTF-8") : "" %>"
                               tabindex="-1">Anterior</a>
                        </li>

                        <%
                            // Mostrar máximo 5 páginas alrededor de la actual
                            int inicio = Math.max(1, paginaActual - 2);
                            int fin = Math.min(totalPaginas, paginaActual + 2);

                            if (inicio > 1) { %>
                        <li class="page-item"><a class="page-link"
                                                 href="AdminServlet?action=listaUsuarios&page=1<%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %>&registrosPorPagina=<%= registrosPorPagina %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + URLEncoder.encode(filtroBusqueda, "UTF-8") : "" %>">1</a></li>
                        <% if (inicio > 2) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% }
                        }

                            for (int i = inicio; i <= fin; i++) { %>
                        <li class="page-item <%= i == paginaActual ? "active" : "" %>">
                            <a class="page-link"
                               href="AdminServlet?action=listaUsuarios&page=<%= i %>&registrosPorPagina=<%= registrosPorPagina %><%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + URLEncoder.encode(filtroBusqueda, "UTF-8") : "" %>"><%= i %></a>
                        </li>
                        <% }

                            if (fin < totalPaginas) {
                                if (fin < totalPaginas - 1) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <li class="page-item"><a class="page-link"
                                                 href="AdminServlet?action=listaUsuarios&page=<%= totalPaginas %>&registrosPorPagina=<%= registrosPorPagina %>
               <%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + URLEncoder.encode(filtroBusqueda, "UTF-8") : "" %>"><%= totalPaginas %></a></li>
                        <% } %>

                        <li class="page-item <%= paginaActual == totalPaginas ? "disabled" : "" %>">
                            <a class="page-link"
                               href="AdminServlet?action=listaUsuarios&page=<%=paginaActual+1%>&registrosPorPagina=<%= registrosPorPagina %><%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + URLEncoder.encode(filtroBusqueda, "UTF-8") : "" %>">Siguiente</a>
                        </li>
                    </ul>
                    <div class="d-flex justify-content-center align-items-center mb-3">
                        <div class="text-muted">
                            Mostrando <%= ((paginaActual - 1) * registrosPorPagina) + 1 %> -
                            <%= Math.min(paginaActual * registrosPorPagina, totalUsuarios) %> de <%= totalUsuarios %> resultados
                        </div>
                    </div>
                </nav>
            </div>

        </main>
        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>

<!-- Modal para detalles -->
<div class="modal fade" id="detallesModal" tabindex="-1" aria-labelledby="detallesModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detallesModalLabel">Detalles del Usuario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="detallesUsuarioContent">
                <!-- Contenido cargado por AJAX -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<!-- Script para cambiar registros por página -->
<script>
    function cambiarRegistrosPorPagina(valor) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('registrosPorPagina', valor);
        urlParams.set('page', 1); // Volver a la primera página
        window.location.search = urlParams.toString();
    }
</script>
<script>
    // Función para ver detalles del usuario
    function verDetalles(usuarioId) {
        fetch('AdminServlet?action=detallesUsuario&id=' + usuarioId)
            .then(response => response.text())
            .then(data => {
                document.getElementById('detallesUsuarioContent').innerHTML = data;
                var modal = new bootstrap.Modal(document.getElementById('detallesModal'));
                modal.show();
            })
            .catch(error => console.error('Error:', error));
    }

    // Cerrar mensajes de alerta automáticamente después de 5 segundos
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            new bootstrap.Alert(alert).close();
        });
    }, 5000);

</script>
<!-- Incluir estos scripts antes del cierre del body -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    // Toggle sidebar
    document.querySelector('.js-sidebar-toggle').addEventListener('click', function() {
        document.querySelector('.js-sidebar').classList.toggle('collapsed');
        document.querySelector('.main').classList.toggle('sidebar-collapsed');
    });

    // Inicializar feather icons
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();

        // Cerrar alertas automáticamente después de 5 segundos
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>
</body>
</html>
