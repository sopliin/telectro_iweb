<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="org.example.onu_mujeres_crud.beans.EncuestaAsignada" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="canonical" href="https://demo-basic.adminkit.io/"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
    <link href="css/app.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

    <title>AdminKit Demo - Bootstrap 5 Admin Template</title>

    <style>
        .table-hover thead th,
        .table-hover tbody td {
            padding-left: 1.2rem; /* */
            padding-right: 1.5rem; /* */
            vertical-align: middle; /* */
        }

        .table-hover thead th:nth-child(1) { /* Nombre - Columna 1 */
            min-width: 2rem; /* Expandido para más espacio, ajusta si es necesario */
        }

        .table-hover thead th:nth-child(2) { /* Descripción - Columna 2 */
            min-width: 2rem; /* Puedes ajustar este también si la descripción es muy corta */
        }

        .table-hover thead th:nth-child(3) { /* Fecha de asignación - Columna 3 */
            min-width: 1rem;
        }

        .table-hover thead th:nth-child(4) { /* Acciones - Columna 4 */
            min-width: 1rem;
        }
        /* Estilo para el botón lila redondeado */
        .btn-lilac {
            background-color: #9C6ADE; /* Un tono lila. Puedes ajustar este valor hex si tienes uno específico */
            border-color: #9C6ADE;
            color: #ffffff; /* Color blanco para el ícono */
            border-radius: 0.5rem; /* Bordes redondeados */
            padding: 0.4rem 0.6rem; /* Ajustar el relleno para que se vea bien */
            display: inline-flex; /* Para alinear el ícono centralmente */
            align-items: center;
            justify-content: center;
            min-width: 32px; /* Ancho mínimo para que sea un pequeño círculo si el contenido es solo un ícono */
            height: 32px; /* Altura mínima para que sea un pequeño círculo si el contenido es solo un ícono */
            text-decoration: none; /* Asegura que no haya subrayado de enlace */
        }

        .btn-lilac:hover {
            background-color: #7D4BB3; /* Un tono lila un poco más oscuro al pasar el ratón */
            border-color: #7D4BB3;
            color: #ffffff; /* Asegura que el ícono siga siendo blanco al pasar el ratón */
        }

        /* Ajuste para los íconos dentro de los botones, si es necesario */
        .btn-lilac .feather {
            width: 1em; /* Asegura que el ícono tome el tamaño de la fuente */
            height: 1em;
            vertical-align: middle; /* Alineación vertical del ícono */
        }

        /* Asegurar que los íconos de "check-circle" también se vean bien si están deshabilitados */
        .table-action .text-muted .feather {
            width: 1em;
            height: 1em;
            vertical-align: middle;
        }

        .pagination-container {
            display: flex;
            justify-content: center; /* Cambiado de space-between a center */
            align-items: center;
            margin-top: 20px;
            width: 100%; /* Asegura que ocupe todo el ancho */
        }

        .page-size-selector {
            width: 80px;
        }

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

        .text {
            color: #343a40; /* */
            font-weight: 350; /* */
            font-size: 0.90em; /* */
            text-transform: uppercase; /* */
            /*white-space: nowrap; !* *!*/
        }

        .description-text {
            font-weight: 350; /* Texto en negrita */
            color: #343a40; /* Color gris oscuro sugerido para el email */
            font-size: 0.95em; /* Unificado el tamaño*/
            font-style: italic;
        }

    </style>
</head>

<body>
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
                <li class="sidebar-item">
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
                <li class="sidebar-item active">
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
            <a class="sidebar-toggle js-sidebar-toggle"><i class="hamburger align-self-center"></i></a>
            <div class="navbar-collapse collapse">
                <ul class="navbar-nav navbar-align">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle    " href="#" data-bs-toggle="dropdown">
                            <%-- Aquí se reemplaza el icono Feather por la imagen de perfil --%>
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>"
                                 class="avatar img-fluid rounded me-2" alt="Foto"/>
                            <div class="d-inline-block">
                                <div class="nombre">
                                    <span class="text-dark d-block"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
                                </div>
                                <div class="rol">
                                    <small class="text-muted d-block text-uppercase"><%= user.getRol() != null ? user.getRol().getNombre() : "ROL DESCONOCIDO" %>
                                    </small>
                                </div>
                            </div>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1"
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
            <div class="container-fluid p-0">
                <div class="mb-3">
                    <h1 class="h3 d-inline align-middle">Encuestas en progreso</h1>
                </div>
                <div class="row mb-3">
                    <div class="col-md-3">
                        <%
                            // Manejo de parámetros con valores por defecto
                            String action = request.getParameter("action") != null ? request.getParameter("action") : "total";
                            int pageNumber = 1;
                            int pageSize = 10;
                            try {
                                pageNumber = Integer.parseInt(request.getParameter("page"));
                            } catch (NumberFormatException e) {
                                pageNumber = 1;
                            }
                            try {
                                pageSize = Integer.parseInt(request.getParameter("pageSize"));
                            } catch (NumberFormatException e) {
                                pageSize = 10;
                            }
                        %>
                        <form id="pageSizeForm" method="get" action="EncuestadorServlet">
                            <input type="hidden" name="action" value="<%= action %>">
                            <input type="hidden" name="page" value="1"> <!-- Resetear a página 1 al cambiar tamaño -->
                            <div class="col-auto">
                                <label class="col-form-label">Registros por página:</label>
                            </div>
                            <div class="input-group">
                                <select class="form-select page-size-selector" name="pageSize"
                                        onchange="this.form.submit()">
                                    <option value="5" <%= pageSize == 5 ? "selected" : "" %>>5 por página</option>
                                    <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10 por página</option>
                                    <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20 por página</option>
                                    <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 por página</option>
                                </select>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0" style="font-size: 1.25rem">Lista de Encuestas en Progreso</h5>
                    </div>
                    <div class="row">
                        <div class="col-12 d-flex">
                            <div class="card flex-fill">
                                <div class="card flex-fill">
                                    <div class="table-responsive">
                                        <table class="table table-hover my-0">
                                            <thead>
                                            <tr>
                                                <th class="text-uppercase">Nombre de encuesta</th>
                                                <th class="d-xl-table-cell text-uppercase">Descripción</th>
                                                <th class="d-md-table-cell text-uppercase">Fecha de Asignación</th>
                                                <th class="text-uppercase">Acciones</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <%
                                                List<EncuestaAsignada> listaEncuestas = (List<EncuestaAsignada>) request.getAttribute("listaEncuestas");
                                                if (listaEncuestas != null && !listaEncuestas.isEmpty()) {
                                                    System.out.println("esta apareciendo el emnsaje progreso");
                                                    List<EncuestaAsignada> encuestasActivas = new ArrayList<>();

                                                    // Filtra encuestas activas y en progreso
                                                    for (EncuestaAsignada encuesta : listaEncuestas) {
                                                        if (encuesta.getEncuesta().getEstado() != null &&
                                                                encuesta.getEncuesta().getEstado().equalsIgnoreCase("activo") &&
                                                                "en_progreso".equalsIgnoreCase(encuesta.getEstado())) {
                                                            encuestasActivas.add(encuesta);
                                                        }
                                                    }

                                                    if (!encuestasActivas.isEmpty()) {
                                                        for (EncuestaAsignada encuesta : encuestasActivas) {

                                                            String nombreEncuesta = encuesta.getEncuesta() != null ? encuesta.getEncuesta().getNombre() : "N/A";
                                                            String descripcion = encuesta.getEncuesta() != null ? encuesta.getEncuesta().getDescripcion() : "N/A";
                                            %>
                                            <tr>
                                                <td class="text"><%= nombreEncuesta %></td>
                                                <td class="description-text"><%-- Lógica para truncar la descripción y mostrar "Ver más/menos" --%>
                                                    <% String fullDescription = encuesta.getEncuesta().getDescripcion();
                                                        int maxLength = 100; // Define la longitud máxima para la descripción
                                                        if (fullDescription != null && fullDescription.length() > maxLength) {
                                                            String shortDescription = fullDescription.substring(0, maxLength);
                                                    %>
                                                    <span id="corta-<%= encuesta.getEncuesta().getEncuestaId() %>"><%= shortDescription %>...</span>
                                                    <a href="#" onclick="toggleDescripcion('<%= encuesta.getEncuesta().getEncuestaId() %>'); return false;" id="toggle-btn-<%= encuesta.getEncuesta().getEncuestaId() %>" class="text-primary ms-1">Ver más</a>
                                                    <span id="completa-<%= encuesta.getEncuesta().getEncuestaId() %>" style="display:none;"><%= fullDescription %></span>
                                                    <% } else { %>
                                                    <%= fullDescription != null ? fullDescription : "" %>
                                                    <% } %>
                                                </td>
                                                <td class=" d-md-table-cell text">
                                                    <%= encuesta.getFechaAsignacion() != null
                                                            ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss")
                                                            .format(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                                                                    .parse(encuesta.getFechaAsignacion()))
                                                            : "N/A" %>
                                                </td>
                                                <td class="table-action text text-center">
                                                    <% String estadoEncuesta = encuesta.getEstado();
                                                        String dotClass = "";
                                                        String statusText = "";

                                                        if ("completada".equalsIgnoreCase(estadoEncuesta)) {
                                                            dotClass = "dot-success";
                                                            statusText = "Completada";
                                                        } else if ("en_progreso".equalsIgnoreCase(estadoEncuesta)) {
                                                            dotClass = "dot-warning";
                                                            statusText = "En progreso";
                                                        } else { // "por_hacer" o cualquier otro
                                                            dotClass = "dot-danger";
                                                            statusText = "Por hacer";
                                                        }
                                                    %>

                                                    <% if (!"completada".equalsIgnoreCase(estadoEncuesta)) { %>
                                                    <a class="btn btn-lilac btn-sm" href="<%= request.getContextPath() %>/ContenidoEncuestaServlet?action=mostrar&asignacionId=<%= encuesta.getAsignacionId()%>" title="Completar Encuesta">
                                                        <i class="align-middle" data-feather="edit-2"></i>
                                                    </a>
                                                    <% } else { %>
                                                    <%-- Si está completada, puedes mantener un ícono deshabilitado o un tooltip, ajustado para ser consistente --%>
                                                    <%--                                                    <span class="text-muted" title="Encuesta Completada">--%>
                                                    <%--                                                        <i class="align-middle" data-feather="check-circle"></i>--%>
                                                    <%--                                                    </span>--%>
                                                    <% } %>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <tr>
                                                <td colspan="4" class="text-center text">No tienes encuestas en progreso
                                                    activas.
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <tr>
                                                <td colspan="4" class="text-center text">No hay encuestas en progreso.</td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- Paginación -->
                                    <div class="pagination-container">
                                        <%
                                            int totalCount = (Integer) request.getAttribute("totalCount");
                                            int startItem = (pageNumber - 1) * pageSize + 1;
                                            int endItem = Math.min(pageNumber * pageSize, totalCount);
                                        %>
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination">
                                                <li class="page-item <%= pageNumber <= 1 ? "disabled" : "" %>">
                                                    <a class="page-link"
                                                       href="EncuestadorServlet?action=<%= action %>&page=<%= pageNumber - 1 %>&pageSize=<%= pageSize %>">Anterior</a>
                                                </li>

                                                <%
                                                    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                                                    int startPage = Math.max(1, pageNumber - 2);
                                                    int endPage = Math.min(totalPages, pageNumber + 2);

                                                    if (startPage > 1) {
                                                %>
                                                <li class="page-item">
                                                    <a class="page-link"
                                                       href="EncuestadorServlet?action=<%= action %>&page=1&pageSize=<%= pageSize %>">1</a>
                                                </li>
                                                <% if (startPage > 2) { %>
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                                <% } %>
                                                <% } %>
                                                <% for (int i = startPage; i <= endPage; i++) { %>
                                                <li class="page-item <%= i == pageNumber ? "active" : "" %>">
                                                    <a class="page-link"
                                                       href="EncuestadorServlet?action=<%= action %>&page=<%= i %>&pageSize=<%= pageSize %>"><%= i %>
                                                    </a>
                                                </li>
                                                <% } %>
                                                <% if (endPage < totalPages) { %>
                                                <% if (endPage < totalPages - 1) { %>
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                                <% } %>
                                                <li class="page-item">
                                                    <a class="page-link"
                                                       href="EncuestadorServlet?action=<%= action %>&page=<%= totalPages %>&pageSize=<%= pageSize %>"><%= totalPages %>
                                                    </a>
                                                </li>
                                                <% } %>
                                                <li class="page-item <%= pageNumber >= totalPages ? "disabled" : "" %>">
                                                    <a class="page-link"
                                                       href="EncuestadorServlet?action=<%= action %>&page=<%= pageNumber + 1 %>&pageSize=<%= pageSize %>">Siguiente</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="../includes/footer.jsp"/>
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

<script>
    function toggleDescripcion(id) {
        const corta = document.getElementById("corta-" + id);
        const completa = document.getElementById("completa-" + id);
        const boton = document.getElementById("toggle-btn-" + id);

        if (completa.style.display === "none") {
            completa.style.display = "inline";
            corta.style.display = "none";
            boton.textContent = "Ver menos";
        } else {
            completa.style.display = "none";
            corta.style.display = "inline";
            boton.textContent = "Ver más";
        }
    }
</script>
<script src="js/app.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
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