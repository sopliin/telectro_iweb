<%@page import="java.util.ArrayList" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

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
        /* Estilos adicionales para el menú activo */
        .sidebar-item.active .sidebar-link {
            background-color: #3b7ddd; /* Color azul */
            color: white !important;
            border-radius: 4px;
        }

        .sidebar-item.active .sidebar-link i {
            color: white !important;
        }

        .sidebar-item.active .sidebar-link:hover {
            background-color: #3068be; /* Color azul más oscuro al pasar el mouse */
        }
    </style>
    <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
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
    <div class="main">
        <nav class="navbar navbar-expand navbar-light navbar-bg">
            <a class="sidebar-toggle js-sidebar-toggle">
                <i class="hamburger align-self-center"></i>
            </a>
            <div class="navbar-collapse collapse">
                <ul class="navbar-nav navbar-align">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>" class="avatar img-fluid rounded me-1" alt="Foto" />
                            <span class="text-dark"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
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
                    <input type="hidden" name="registrosPorPagina" value="<%= request.getParameter("registrosPorPagina") != null ? request.getParameter("registrosPorPagina") : "10" %>">
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

            <!-- Reportes -->
            <div class="mb-3">
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
                        </select>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-file-earmark-excel"></i> Exportar Excel
                        </button>
                    </div>
                </form>
            </div>
            <!-- Mostrar información de paginación arriba de la tabla -->
            <%
                int registrosPorPagina = (request.getAttribute("registrosPorPagina") != null)
                        ? (Integer) request.getAttribute("registrosPorPagina")
                        : 10;
            %>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="text-muted">
                    Mostrando <%= ((paginaActual - 1) * registrosPorPagina) + 1 %> -
                    <%= Math.min(paginaActual * registrosPorPagina, totalUsuarios) %> de <%= totalUsuarios %> usuarios
                </div>
            </div>

            <!-- Tabla de usuarios -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Apellidos</th>
                            <th>DNI</th>
                            <th>Correo</th>
                            <th>Rol</th>
                            <th>Zona/Distrito</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<Usuario> listaUsuarios = (ArrayList<Usuario>) request.getAttribute("listaUsuarios");
                            if (listaUsuarios != null && !listaUsuarios.isEmpty()) {
                                int counter = 1;
                                for (Usuario usuario : listaUsuarios) {
                        %>
                        <tr>
                            <td><%= counter++ %></td>
                            <td><%= usuario.getNombre() %></td>
                            <td>
                                <%= usuario.getApellidoPaterno() %>
                                <%= usuario.getApellidoMaterno() != null ? usuario.getApellidoMaterno() : "" %>
                            </td>
                            <td><%= usuario.getDni() %></td>
                            <td><%= usuario.getCorreo() %></td>
                            <td><%= usuario.getRol().getNombre() %></td>
                            <td>
                                <% if (usuario.getZona() != null) { %>
                                <%= usuario.getZona().getNombre() %> /
                                <%= usuario.getDistrito() != null ? usuario.getDistrito().getNombre() : "N/A" %>
                                <% } else { %>
                                N/A
                                <% } %>
                            </td>
                            <td>
                                <% if (usuario.getEstado().equalsIgnoreCase("activo")) { %>
                                <span class="badge bg-success status-badge">Activo</span>
                                <% } else { %>
                                <span class="badge bg-danger status-badge">Inactivo</span>
                                <% } %>
                            </td>
                            <td class="action-buttons">
                                <div class="d-flex flex-wrap">
                                    <% if (usuario.getEstado().equalsIgnoreCase("activo")) { %>
                                    <a href="AdminServlet?action=desactivarUsuario&id=<%= usuario.getUsuarioId() %>"
                                       class="btn btn-sm btn-danger"
                                       title="Desactivar usuario"
                                       onclick="return confirm('¿Está seguro de desactivar este usuario?')">
                                        <i class="bi bi-person-x"></i>
                                    </a>
                                    <% } else { %>
                                    <a href="AdminServlet?action=activarUsuario&id=<%= usuario.getUsuarioId() %>"
                                       class="btn btn-sm btn-success"
                                       title="Activar usuario"
                                       onclick="return confirm('¿Está seguro de activar este usuario?')">
                                        <i class="bi bi-person-check"></i>
                                    </a>
                                    <% } %>

                                    <!-- <a href="AdminServlet?action=editar&id=<%= usuario.getUsuarioId() %>"
                                       class="btn btn-sm btn-primary"
                                       title="Editar usuario">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>-->

                                    <button class="btn btn-sm btn-info"
                                            title="Ver detalles"
                                            onclick="verDetalles(<%= usuario.getUsuarioId() %>)">
                                        <i class="bi bi-eye"></i>
                                    </button>
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
                    <ul class="pagination justify-content-center">
                        <li class="page-item <%= paginaActual == 1 ? "disabled" : "" %>">
                            <a class="page-link"
                               href="AdminServlet?action=listaUsuarios&page=<%= paginaActual - 1 %>&registrosPorPagina=<%= registrosPorPagina %><%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + filtroBusqueda : "" %>"
                               tabindex="-1">Anterior</a>
                        </li>

                        <%
                            // Mostrar máximo 5 páginas alrededor de la actual
                            int inicio = Math.max(1, paginaActual - 2);
                            int fin = Math.min(totalPaginas, paginaActual + 2);

                            if (inicio > 1) { %>
                        <li class="page-item"><a class="page-link"
                                                 href="AdminServlet?action=listaUsuarios&page=1<%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + filtroBusqueda : "" %>">1</a></li>
                        <% if (inicio > 2) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% }
                        }

                            for (int i = inicio; i <= fin; i++) { %>
                        <li class="page-item <%= i == paginaActual ? "active" : "" %>">
                            <a class="page-link"
                               href="AdminServlet?action=listaUsuarios&page=<%= i %><%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + filtroBusqueda : "" %>"><%= i %></a>
                        </li>
                        <% }

                            if (fin < totalPaginas) {
                                if (fin < totalPaginas - 1) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <li class="page-item"><a class="page-link"
                                                 href="AdminServlet?action=listaUsuarios&page=<%= totalPaginas %>
               <%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + filtroBusqueda : "" %>"><%= totalPaginas %></a></li>
                        <% } %>

                        <li class="page-item <%= paginaActual == totalPaginas ? "disabled" : "" %>">
                            <a class="page-link"
                               href="AdminServlet?action=listaUsuarios&page=<%=paginaActual+1%><%= filtroRol != null ? "&filtroRol=" + filtroRol : "" %><%= filtroEstado != null ? "&filtroEstado=" + filtroEstado : "" %><%= filtroBusqueda != null ? "&filtroBusqueda=" + filtroBusqueda : "" %>">Siguiente</a>
                        </li>
                    </ul>
                    <!-- Agregar selector de registros por página -->
                    <div class="col-md-2">
                        <label for="registrosPorPagina" class="form-label">Registros por página</label>
                        <form id="formRegistrosPorPagina" method="GET" action="AdminServlet" class="mb-3">
                            <input type="hidden" name="action" value="listaUsuarios">
                            <!-- Mantener los parámetros de filtro -->
                            <input type="hidden" name="filtroRol" value="<%= request.getParameter("filtroRol") != null ? request.getParameter("filtroRol") : "" %>">
                            <input type="hidden" name="filtroEstado" value="<%= request.getParameter("filtroEstado") != null ? request.getParameter("filtroEstado") : "" %>">
                            <input type="hidden" name="filtroBusqueda" value="<%= request.getParameter("filtroBusqueda") != null ? request.getParameter("filtroBusqueda") : "" %>">
                            <select id="registrosPorPagina" name="registrosPorPagina" class="form-select" onchange="document.getElementById('formRegistrosPorPagina').submit()">
                                <option value="10" <%= (request.getParameter("registrosPorPagina") == null || request.getParameter("registrosPorPagina").equals("10")) ? "selected" : "" %>>10</option>
                                <option value="25" <%= "25".equals(request.getParameter("registrosPorPagina")) ? "selected" : "" %>>25</option>
                                <option value="50" <%= "50".equals(request.getParameter("registrosPorPagina")) ? "selected" : "" %>>50</option>
                                <option value="100" <%= "100".equals(request.getParameter("registrosPorPagina")) ? "selected" : "" %>>100</option>
                            </select>
                        </form>
                    </div>
                </nav>
            </div>
        </main>
        <footer class="footer">
            <div class="container-fluid">
                <div class="row text-muted">
                    <div class="col-6 text-start">
                        <p class="mb-0">
                            <a class="text-muted" href="https://adminkit.io/" target="_blank"><strong>AdminKit</strong></a> &copy;
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
<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
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
</body>
</html>