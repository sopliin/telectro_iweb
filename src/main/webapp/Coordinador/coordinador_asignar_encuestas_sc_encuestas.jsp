<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<% Usuario user = (Usuario) session.getAttribute("usuario"); %>
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
    <link rel="shortcut icon" href="img/icons/icon-48x48.png" />
    <link rel="canonical" href="https://demo-basic.adminkit.io/" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

    <title> Asignar encuestas desde la sección encuestas - Coordinador</title>

    <style>

        /* Footer (SIN CAMBIOS) */
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

        /* NUEVOS ESTILOS Y MEJORAS PARA EL CONTENIDO PRINCIPAL */

        .content {
            padding: 1.5rem; /* Padding general del contenido principal */
        }

        h1.h3 {
            font-size: 1.75rem; /* Título principal un poco más grande y claro */
            font-weight: 600;
            color: #344767;
            margin-bottom: 1.5rem;
        }

        .alert {
            border-radius: 0.5rem;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border-color: #bee5eb;
        }

        /* Card general */
        .card {
            border: none; /* Eliminar borde por defecto */
            border-radius: 0.75rem; /* Bordes más redondeados */
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.08); /* Sombra más suave y moderna */
        }

        .card-body {
            padding: 2rem; /* Aumentar el padding dentro de la card */
        }

        /* Información de la encuesta a asignar */
        .card-body h5 {
            font-size: 1.2rem;
            color: #344767;
            margin-bottom: 1rem;
            border-bottom: 1px solid #eee; /* Línea separadora */
            padding-bottom: 0.5rem;
        }

        .card-body ul {
            list-style: none; /* Quitar viñetas */
            padding-left: 0;
            margin-bottom: 1.5rem; /* Espacio debajo de la lista */
        }

        .card-body ul li {
            margin-bottom: 0.5rem;
            color: #555;
            font-size: 0.95rem;
        }

        .card-body ul li strong {
            color: #333;
        }

        /* Filtros y buscador */
        .row.align-items-end.justify-content-between {
            margin-bottom: 2rem; /* Más espacio antes de la tabla */
        }

        .form-label {
            font-weight: 500;
            color: #444;
            margin-bottom: 0.5rem;
            display: block; /* Asegura que ocupe su propia línea */
        }

        .form-select, .form-control {
            border-radius: 0.4rem;
            font-size: 0.9rem !important; /* Reducir ligeramente el tamaño del texto en inputs */
        }

        .form-select {
            width: 280px !important; /* Ancho fijo para el selector de distrito */
        }

        .input-group-text {
            background-color: #f8f9fa; /* Fondo claro para el ícono de búsqueda */
            border-right: none;
            border-color: #dee2e6;
            border-radius: 0.4rem 0 0 0.4rem;
        }

        .input-group .form-control.border-start-0 {
            border-radius: 0 0.4rem 0.4rem 0;
        }

        .input-group .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25); /* Sombra azul al enfocar */
            border-color: #80bdff;
        }

        /* Tabla */
        .table-responsive {
            margin-top: 1.5rem;
            border: 1px solid #e9ecef; /* Borde sutil alrededor de la tabla */
            border-radius: 0.5rem;
            overflow-x: auto; /* Para tablas muy anchas en móviles */
        }

        .table {
            margin-bottom: 0; /* Eliminar margen inferior de la tabla */
            border-collapse: separate; /* Necesario para que border-radius funcione en thead */
            border-spacing: 0;
        }

        .table thead th {
            background-color: #f8f9fa; /* Fondo para el encabezado de la tabla */
            color: #555;
            font-weight: 600;
            font-size: 0.9rem;
            padding: 0.85rem 1rem;
            border-bottom: 2px solid #dee2e6;
        }

        .table tbody td {
            padding: 0.75rem 1rem;
            vertical-align: middle;
            font-size: 0.88rem; /* Tamaño de fuente para celdas */
            color: #495057;
            border-bottom: 1px solid #e9ecef; /* Borde inferior para cada fila */
        }

        .table tbody tr:last-child td {
            border-bottom: none; /* Eliminar borde inferior de la última fila */
        }

        .table tbody tr:hover {
            background-color: #f2f6fc; /* Ligero hover en las filas */
        }

        /* Mensaje de "No hay encuestadores" */
        .table td div.text-center.text-muted {
            padding: 1.5rem 0;
            font-size: 1rem;
            color: #888 !important;
        }
        .table td div.text-center.text-muted i {
            font-size: 1.2rem;
            vertical-align: middle;
        }

        /* Acciones de la tabla */
        .form-control-sm {
            padding: 0.35rem 0.65rem;
            font-size: 0.85rem;
            height: auto; /* Asegurar que no se estire demasiado */
            width: 3rem;
            flex-grow: 1; /* Permite que el input crezca para ocupar espacio disponible si está dentro de un flexbox */
        }

        .btn-sm {
            padding: 0.35rem 0.75rem;
            font-size: 0.85rem;
            border-radius: 0.3rem;
            white-space: nowrap; /* Mantener el botón en una sola línea */
        }

        .badge {
            font-size: 0.75em;
            padding: 0.4em 0.7em;
            border-radius: 0.3rem;
            white-space: normal; /* PERMITE QUE EL TEXTO DEL BADGE SE ENVUELVA SI ES NECESARIO */
            display: inline-block; /* Asegura que el padding y el margin funcionen correctamente */
            text-align: center; /* Centra el texto si se envuelve */
        }

        /* Añadir un estilo para la celda de acciones para usar flexbox */
        .table tbody td:last-child {
            width: 1%; /* Intenta que la columna ocupe el mínimo espacio necesario */
            white-space: nowrap; /* Esto es para que la celda misma no se rompa, pero el contenido interno sí si se permite */
        }

        /* Estilo para el contenedor del formulario dentro de las acciones */
        .d-flex.align-items-center.gap-2 {
            flex-wrap: nowrap; /* Evita que el input y el botón se envuelvan */
            justify-content: flex-end; /* Alinea el contenido a la derecha dentro de la celda */
        }

        .text-danger.small {
            font-size: 0.75rem; /* Ajustar tamaño para mensajes de error */
            margin-top: 0.25rem;
            display: block; /* Asegura que ocupe su propia línea */
        }

        /* Paginación */
        .pagination {
            margin-top: 1.5rem;
            margin-bottom: 0;
        }
        .pagination .page-item .page-link {
            border-radius: 0.4rem;
            margin: 0 0.2rem;
            padding: 0.5rem 0.8rem;
            font-size: 0.9rem;
            border: 1px solid #dee2e6;
            color: #007bff;
            transition: all 0.2s ease-in-out;
        }
        .pagination .page-item .page-link:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
            color: #0056b3;
        }
        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
            color: white;
            z-index: 2; /* Para que quede por encima de los bordes adyacentes */
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            background-color: #f8f9fa;
            border-color: #dee2e6;
            cursor: not-allowed;
        }

        /* Botón de volver */
        .mt-4 .btn-secondary {
            border-radius: 0.5rem;
            padding: 0.75rem 1.25rem;
            font-size: 0.95rem;
            color: #ffffff;
            background-color: #16244a !important;
            border-color: #191919;
        }
        .mt-4 .btn-secondary:hover {
            background-color: #dae0e5;
            border-color: #dae0e5;
        }

        /* Ajustes para íconos de Feather */
        [data-feather] {
            width: 1rem;
            height: 1rem;
            vertical-align: text-bottom;
        }

        .text {
            color: #343a40; /* Color gris oscuro */
            font-weight: 350;
            font-size: 0.9em; /* Ligeramente más grande*/
            text-transform: uppercase; /* Asegurar mayúsculas */
            white-space: nowrap; /* Evita que el texto se parta en varias líneas */
        }

        .cursiva-text {
            font-weight: 350; /* Texto en negrita */
            color: #343a40; /* Color gris oscuro sugerido para el email */
            font-size: 0.95em; /* Unificado el tamaño*/
            white-space: nowrap; /* Evita que el texto se parta en varias líneas */
            font-style: italic;
        }

        .btn-outline-primary {
            border-color: #f01c74;
            background: #f01c74;
            color: #ffffff;
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

        .bg-danger {
            background-color: #6f42c1 !important;
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
                <li class="sidebar-header">Menu del coordinador</li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=lista">
                        <i class="align-middle" data-feather="users"></i> <span class="align-middle">Encuestadores de zona</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=listarEncuestas">
                        <i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestas</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=dashboard">
                        <i class="align-middle" data-feather="bar-chart"></i> <span class="align-middle">Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=subirexcel">
                        <i class="align-middle" data-feather="upload"></i> <span class="align-middle">Subir respuestas</span>
                    </a>
                </li>
                <li class="sidebar-header">
                    Acción
                </li>
                <li class="sidebar-item active">
                    <a class="sidebar-link" href="CoordinadorServlet?action=filtrarAsignar&encuestaId=${encuestaId}&nombreEncuesta=${encuestaSeleccionada.nombre}&carpeta=">
                        <i class="align-middle" data-feather="user"></i> <span class="align-middle">Asignar encuestas</span>
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
                            <a class="dropdown-item" href="CoordinadorServlet?action=verPerfil"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <main class="content">
            <div class="container-fluid p-4">
                <h1 class="h3 mb-4 fw-bold" style="color: #16244a">Asignación de Encuestas</h1>
                <!-- Alertas -->
                <c:if test="${param.mensaje == 'asignacionExitosa'}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        ✅ Encuesta asignada correctamente.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                    </div>
                </c:if>

                <c:if test="${not empty carpetaSeleccionada}">
                    <div class="alert alert-info shadow-sm mb-4">
                        Carpeta seleccionada: <strong>${carpetaSeleccionada}</strong>
                    </div>
                </c:if>

                <!-- Card de Detalles -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">

                        <c:if test="${not empty encuestaId}">
                            <h5 class="fw-semibold text-dark border-bottom pb-2 mb-3">Detalles de la encuesta</h5>
                            <ul class="list-unstyled small text-secondary mb-4">
                                <li><strong>Nombre:</strong> ${encuestaSeleccionada.nombre}</li>
                                <li><strong>Descripción:</strong> ${encuestaSeleccionada.descripcion}</li>
                            </ul>
                        </c:if>

                        <!-- Filtros y buscador -->
                        <div class="row gy-3 align-items-end justify-content-between mb-4">
                            <div class="col-md-auto">
                                <c:if test="${not empty listaDistritos}">
                                    <form method="get" action="CoordinadorServlet" class="d-inline">
                                        <input type="hidden" name="action" value="filtrarAsignar" />
                                        <input type="hidden" name="encuestaId" value="${encuestaId}" />
                                        <input type="hidden" name="carpeta" value="${carpetaSeleccionada}" />

                                        <label for="distrito" class="form-label text-secondary text-uppercase small">Filtrar por distrito</label>
                                        <select name="distritoId" id="distrito" class="form-select form-select-sm" onchange="this.form.submit()">
                                            <option value="">-- Todos los Distritos --</option>
                                            <c:forEach var="distrito" items="${listaDistritos}">
                                                <option value="${distrito.distritoId}" ${distritoSeleccionado == distrito.distritoId ? 'selected' : ''}>
                                                        ${distrito.nombre}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </form>
                                </c:if>
                            </div>
                            <div class="col-md-auto">
                                <label for="buscadorEncuestadores" class="form-label text-secondary text-uppercase small">Buscar Encuestador</label>
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light border-end-0"><i data-feather="search"></i></span>
                                    <input type="text" id="buscadorEncuestadores" class="form-control border-start-0" placeholder="Nombre, DNI, correo...">
                                </div>
                            </div>
                        </div>

                        <!-- Tabla -->
                        <h5 class="fw-semibold text-dark mb-3">Lista de Encuestadores</h5>
                        <div class="table-responsive border rounded-3">
                            <table class="table table-hover align-middle mb-0" id="tablaEncuestadores">
                                <thead class="table-light">
                                <tr class="small text-uppercase text-muted">
                                    <th>Nombre Completo</th>
                                    <th>DNI</th>
                                    <th>Correo Electrónico</th>
                                    <th>Zona / Distrito</th>
                                    <th>Acciones</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${empty listaEncuestadores}">
                                        <tr>
                                            <td colspan="5">
                                                <div class="text-center text-muted py-4">
                                                    <i data-feather="info" class="me-2"></i> No se encontraron encuestadores.
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="e" items="${listaEncuestadores}">
                                            <tr>
                                                <td class="text-nowrap">${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}</td>
                                                <td>${e.dni}</td>
                                                <td class="fst-italic text-secondary">${e.correo}</td>
                                                <td>${e.zona.nombre} / ${e.distrito.nombre}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${e.estado == 'activo'}">
                                                            <form method="post" action="CoordinadorServlet" class="d-flex align-items-center gap-2">
                                                                <input type="hidden" name="action" value="guardarAsignacionDesdeEncuestas" />
                                                                <input type="hidden" name="idEncuestador" value="${e.usuarioId}" data-nombre="${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}" />
                                                                <input type="hidden" name="encuestaId" value="${encuestaId}" />
                                                                <input type="hidden" name="carpeta" value="${carpetaSeleccionada}" />
                                                                <input type="hidden" name="zonaId" value="${zonaSeleccionada}" />
                                                                <input type="hidden" name="distritoId" value="${distritoSeleccionado}" />

                                                                <input type="number" name="cantidad" min="1" max="1000" step="1" value="1"
                                                                       class="form-control form-control-sm">

                                                                <button type="button" class="btn btn-sm btn-outline-primary"
                                                                        onclick="confirmarAsignacionDesdeListado(this)">
                                                                    <i data-feather="send" class="me-1"></i>Asignar
                                                                </button>

                                                                <div class="text-danger small mt-1 d-none" id="error-cantidad-${e.usuarioId}">
                                                                    Debe asignar al menos 1 encuesta.
                                                                </div>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Este usuario fue baneado</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Paginación -->
                        <c:if test="${not empty totalPaginas and not empty listaEncuestadores}">
                            <nav class="mt-4">
                                <ul class="pagination justify-content-center small">
                                    <c:set var="accionPaginacion" value="filtrarAsignar"/>
                                    <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="CoordinadorServlet?action=${accionPaginacion}&page=${paginaActual - 1}&encuestaId=${encuestaId}&carpeta=${carpetaSeleccionada}<c:if test='${not empty distritoSeleccionado}'>&distritoId=${distritoSeleccionado}</c:if>">
                                            Anterior
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPaginas}" var="i">
                                        <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                            <a class="page-link"
                                               href="CoordinadorServlet?action=${accionPaginacion}&page=${i}&encuestaId=${encuestaId}&carpeta=${carpetaSeleccionada}<c:if test='${not empty distritoSeleccionado}'>&distritoId=${distritoSeleccionado}</c:if>">
                                                    ${i}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="CoordinadorServlet?action=${accionPaginacion}&page=${paginaActual + 1}&encuestaId=${encuestaId}&carpeta=${carpetaSeleccionada}<c:if test='${not empty distritoSeleccionado}'>&distritoId=${distritoSeleccionado}</c:if>">
                                            Siguiente
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>

                        <div class="mt-4 text-end">
                            <a href="CoordinadorServlet?action=listarEncuestas&carpeta=${carpetaSeleccionada}" class="btn btn-secondary"><i class="align-middle me-1" data-feather="arrow-left"></i> Volver a la lista</a>
                        </div>
                    </div>
                </div>

            </div>
        </main>

        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>

<script src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        feather.replace();

        // Inicializar alertas de Bootstrap
        var alertList = document.querySelectorAll('.alert');
        alertList.forEach(function (alert) {
            new bootstrap.Alert(alert)
        });

        const input = document.getElementById("buscadorEncuestadores");
        const tabla = document.getElementById("tablaEncuestadores")?.getElementsByTagName("tbody")[0];

        if (input && tabla) {
            input.addEventListener("input", function () {
                const filtro = input.value.toLowerCase();
                Array.from(tabla.rows).forEach(fila => {
                    const textoFila = fila.textContent.toLowerCase();
                    fila.style.display = textoFila.includes(filtro) ? "" : "none";
                });
            });
        }
    });
</script>

<script>
    // Esta función ha sido simplificada y mejorada para usar la validación nativa de HTML5
    function confirmarAsignacionDesdeListado(boton) {
        const form = boton.closest('form');
        const inputCantidad = form.querySelector('input[name="cantidad"]');

        // Dispara la validación nativa del navegador (basada en 'min' y 'required')
        if (!inputCantidad.reportValidity()) {
            return; // Detiene la ejecución si la validación falla
        }

        const nombre = form.querySelector('input[name="idEncuestador"]').dataset.nombre;

        if (confirm("¿Está seguro de asignar " + inputCantidad.value + " encuestas a " + nombre + "?")) {
            form.submit();
        }
    }
</script>
<script>
    function confirmarAsignacion(nombreEncuestador, inputCantidad, usuarioId) {
        const cantidad = parseInt(inputCantidad.value);
        const errorDiv = document.getElementById('error-cantidad-' + usuarioId);

        if (isNaN(cantidad) || cantidad < 1) {
            errorDiv.classList.remove('d-none');
            inputCantidad.classList.add('is-invalid');
            return false;
        } else {
            errorDiv.classList.add('d-none');
            inputCantidad.classList.remove('is-invalid');
        }

        return confirm("¿Está seguro de realizar esta asignación a ${nombreEncuestador}?");
    }
</script>
<script>
    function confirmarAsignacionDesdeListado(boton) {
        const form = boton.closest('form');
        const inputCantidad = form.querySelector('input[name="cantidad"]');
        const valorStr = inputCantidad.value.trim();
        const valor = Number(valorStr);

        // Validar si es un número entero entre 1 y 1000
        if (!Number.isInteger(valor) || valor < 1 || valor > 1000) {
            inputCantidad.reportValidity(); // Muestra mensaje nativo si input tiene min/step
            return;
        }

        const nombre = form.querySelector('input[name="idEncuestador"]').dataset.nombre;

        if (confirm("¿Está seguro de realizar esta asignación a " + nombre + "?")) {
            form.submit();
        }
    }
</script>

</body>
</html>