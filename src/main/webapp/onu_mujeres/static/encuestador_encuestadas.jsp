<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Encuesta" %>
<%@ page import="org.example.onu_mujeres_crud.beans.EncuestaAsignada" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%Usuario user = (Usuario) session.getAttribute("usuario");%>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
    <meta name="author" content="AdminKit">
    <meta name="keywords"
          content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="img/icons/icon-48x48.png"/>

    <link rel="canonical" href="https://demo-basic.adminkit.io/"/>

    <title>AdminKit Demo - Bootstrap 5 Admin Template</title>
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
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" type="text/css"
          href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
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
                <li class="sidebar-header">
                    Encuestas
                </li>

                <li class="sidebar-item active">
                    <a class="sidebar-link" href="EncuestadorServlet?action=total">
                        <i class="align-middle" data-feather="list"></i> <span
                            class="align-middle">Encuestas totales</span>
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
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>"
                                 class="avatar img-fluid rounded me-1" alt="Charles Hall"/> <span
                                class="text-dark"><%=user.getNombre() + " " + user.getApellidoPaterno() %>
                        (<%=user.getRol() != null ?
                                user.getRol().getNombre().substring(0, 1).toUpperCase() + user.getRol().getNombre().substring(1).toLowerCase() : ""%>)</span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1"
                                                                                             data-feather="eye"></i>
                                Ver Perfil</a>
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
                    <h1 class="h3 d-inline align-middle">Encuestas Totales</h1>
                </div>
                <div class="row">
                    <div class="col-12 d-flex">
                        <div class="card flex-fill">

                            <div class="card flex-fill">
                                <div class="table-responsive">
                                    <table class="table table-hover my-0">
                                        <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th >Descripción</th>
                                            <th class="d-none d-xl-table-cell">Código</th>
                                            <th>Estado</th>
                                            <th class="d-none d-md-table-cell">Fecha De asignación</th>
                                            <th>Acciones</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <%
                                            List<EncuestaAsignada> listaEncuestas = (List<EncuestaAsignada>) request.getAttribute("listaEncuestas");
                                            if (listaEncuestas != null && !listaEncuestas.isEmpty()) {
                                                boolean hayActivas = false;

                                                // Primero verifica si hay encuestas activas
                                                for (EncuestaAsignada encuesta : listaEncuestas) {
                                                    if (encuesta.getEncuesta().getEstado().equalsIgnoreCase("activo")) {
                                                        hayActivas = true;
                                                        break;
                                                    }
                                                }

                                                if (hayActivas) {
                                                    // Muestra solo las encuestas activas
                                                    for (EncuestaAsignada encuesta : listaEncuestas) {
                                                        if (encuesta.getEncuesta().getEstado().equalsIgnoreCase("activo")) {
                                                            String codigo = "";
                                                            if (encuesta.getEstado().equalsIgnoreCase("Completada")) {
                                                                codigo = "0" + String.valueOf(user.getUsuarioId()) + "-" + "00" + String.valueOf(encuesta.getEncuesta().getEncuestaId());
                                                            } else {
                                                                codigo = "N/A";
                                                            }
                                        %>
                                        <tr>

                                            <td><%= encuesta.getEncuesta().getNombre() %></td>
                                            <td class="action-buttons">
                                                <button class="btn btn-sm btn-info" title="Ver detalles" onclick="verDetalles(<%= encuesta.getEncuesta().getEncuestaId() %>)">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </td>
                                            <td class="d-none d-xl-table-cell"><%= codigo %></td>
                                            <td>
                                                <% String estadoEncuesta = encuesta.getEstado();
                                                    String statusClass = "";
                                                    String statusText = "";
                                                    if ("completada".equalsIgnoreCase(estadoEncuesta)) {
                                                        statusClass = "badge bg-success";
                                                        statusText = "Completada";
                                                    } else if ("en_progreso".equalsIgnoreCase(estadoEncuesta)) {
                                                        statusClass = "badge bg-warning";
                                                        statusText = "En progreso";
                                                    } else {
                                                        statusClass = "badge bg-danger";
                                                        statusText = "Por hacer";
                                                    }
                                                %>
                                                <span class="<%= statusClass %>"><%= statusText %></span>
                                            </td>
                                            <td class="d-none d-md-table-cell"><%= encuesta.getFechaAsignacion() %></td>
                                            <td class="table-action">
                                                <% if (!"completada".equalsIgnoreCase(estadoEncuesta)) { %>
                                                <a href="<%= request.getContextPath() %>/ContenidoEncuestaServlet?action=mostrar&asignacionId=<%= encuesta.getAsignacionId()%>">
                                                    <i class="align-middle" data-feather="edit-2"></i>
                                                </a>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        } else {
                                            // Muestra mensaje si todas están desactivadas
                                        %>
                                        <tr>
                                            <td colspan="7" class="text-center">Tus encuestas están desactivadas.</td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                            // Muestra mensaje si no hay encuestas asignadas
                                        %>
                                        <tr>
                                            <td colspan="7" class="text-center">No hay encuestas asignadas.</td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </main>

        <jsp:include page="../../includes/footer.jsp"/>
    </div>
</div>
<div class="modal fade" id="detallesModal" tabindex="-1" aria-labelledby="detallesModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detallesModalLabel">Descripción de la encuesta</h5>
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
<script type="text/javascript"
        src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>
<script>
    // Función para ver detalles del usuario
    function verDetalles(usuarioId) {
        fetch('EncuestadorServlet?action=descripcion&id=' + usuarioId)
            .then(response => response.text())
            .then(data => {
                document.getElementById('detallesUsuarioContent').innerHTML = data;
                var modal = new bootstrap.Modal(document.getElementById('detallesModal'));
                modal.show();
            })
            .catch(error => console.error('Error:', error));
    }
</script>

</body>

</html>