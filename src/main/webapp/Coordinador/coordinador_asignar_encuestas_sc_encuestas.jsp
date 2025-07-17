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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

    <title> Asignar encuestas desde la sección encuestas - Coordinador</title>
    <style>

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

        .pagination .page-link {
            color: #435ebe;
            border: 1px solid #ddd;
            background-color: white;
            border-radius: 4px;
            margin: 0 2px;
        }
        .page-item.active .page-link {
            background-color: #435ebe;
            border-color: #435ebe;
            color: white;
        }
        .page-item.disabled .page-link {
            color: #ccc;
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
            <div class="container-fluid p-0">
                <h1 class="h3 mb-3">Asignar Encuesta a Encuestador</h1>

                <c:if test="${param.mensaje == 'asignacionExitosa'}">
                    <div class="alert alert-success">✅ Encuesta asignada correctamente.</div>
                </c:if>

                <c:if test="${not empty carpetaSeleccionada}">
                    <div class="alert alert-info mb-3">
                        Carpeta seleccionada: <strong>${carpetaSeleccionada}</strong>
                    </div>
                </c:if>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <c:if test="${not empty encuestaId}">
                            <div class="mb-4">
                                <h5>Encuesta a asignar:</h5>
                                <ul class="mb-0">

                                    <li><strong>Nombre:</strong> ${encuestaSeleccionada.nombre}</li>
                                    <li><strong>Descripción:</strong> ${encuestaSeleccionada.descripcion}</li>
                                </ul>
                            </div>
                        </c:if>

                        <!-- Filtros: Distrito y Buscador alineados -->
                        <div class="row mb-4 align-items-end justify-content-between">
                            <div class="col-md-auto">
                                <c:if test="${not empty listaDistritos}">
                                    <form method="get" action="CoordinadorServlet" class="mb-0">
                                        <input type="hidden" name="action" value="filtrarAsignar" />
                                        <input type="hidden" name="encuestaId" value="${encuestaId}" />
                                        <input type="hidden" name="carpeta" value="${carpetaSeleccionada}" />
                                        <label for="distrito" class="form-label">Distrito:</label>
                                        <select name="distritoId" id="distrito" class="form-select" style="width: 250px;" onchange="this.form.submit()">
                                            <option value="">-- Seleccione Distrito --</option>
                                            <c:forEach var="distrito" items="${listaDistritos}">
                                                <option value="${distrito.distritoId}" ${distritoSeleccionado == distrito.distritoId ? 'selected' : ''}>${distrito.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </form>
                                </c:if>
                            </div>

                            <div class="col-md-auto">
                                <div class="input-group" style="max-width: 220px;">
            <span class="input-group-text bg-white border-end-0" style="background: transparent;">
                <i data-feather="search"></i>
            </span>
                                    <input type="text" id="buscadorEncuestadores" class="form-control border-start-0" placeholder="Buscar..." aria-label="Buscar">
                                </div>
                            </div>
                        </div>


                        <!-- Lista de Encuestadores -->
                        <h5 class="mb-3">Encuestadores encontrados:</h5>
                        <div class="table-responsive">
                            <table class="table table-hover my-0" id="tablaEncuestadores">
                                <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>DNI</th>
                                    <th>Correo</th>
                                    <th>Zona/Distrito</th>
                                    <th>Acciones</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${empty listaEncuestadores}">
                                        <tr>
                                            <td colspan="5">
                                                <div class="text-center text-muted my-2">
                                                    <i data-feather="alert" class="me-1"></i> No hay encuestadores registrados.
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="e" items="${listaEncuestadores}">
                                            <tr>
                                                <td>${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}</td>
                                                <td>${e.dni}</td>
                                                <td>${e.correo}</td>
                                                <td>${e.zona.nombre} / ${e.distrito.nombre}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${e.estado == 'activo'}">
                                                            <form method="post" action="CoordinadorServlet" class="d-flex align-items-center gap-2">
                                                                <input type="hidden" name="action" value="guardarAsignacionDesdeEncuestas" />
                                                                <input type="hidden" name="idEncuestador" value="${e.usuarioId}"
                                                                       data-nombre="${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}" />
                                                                <input type="hidden" name="encuestaId" value="${encuestaId}" />
                                                                <input type="hidden" name="carpeta" value="${carpetaSeleccionada}" />
                                                                <input type="hidden" name="zonaId" value="${zonaSeleccionada}" />
                                                                <input type="hidden" name="distritoId" value="${distritoSeleccionado}" />
                                                                <input type="number" name="cantidad" min="1" value="10" required class="form-control form-control-sm" style="width: 80px;" />
                                                                <button type="button" class="btn btn-primary btn-sm"
                                                                        onclick="confirmarAsignacionDesdeListado(this)">
                                                                    Asignar
                                                                </button>
                                                                <div class="text-danger small mt-1 d-none" id="error-cantidad-${e.usuarioId}">
                                                                    ⚠ El valor debe ser superior o igual a 1
                                                                </div>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Baneado</span>
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
                        <c:if test="${not empty totalPaginas and not empty listaEncuestadores}">
                            <div class="d-flex flex-column justify-content-center align-items-center mt-4">
                                <nav aria-label="Paginación">
                                    <ul class="pagination justify-content-center">
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
                            </div>
                        </c:if>

                        <!-- Volver -->
                        <div class="mt-4">
                            <a href="CoordinadorServlet?action=listarEncuestas&carpeta=${carpetaSeleccionada}" class="btn btn-secondary">← Volver a encuestas</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>

<!-- Scripts -->
<script src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        feather.replace();

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

        return confirm(`¿Está seguro de realizar esta asignación a ${nombreEncuestador}?`);
    }
</script>

<script>
    function confirmarAsignacionDesdeListado(boton) {
        const form = boton.closest('form');
        const inputCantidad = form.querySelector('input[name="cantidad"]');
        const valor = parseInt(inputCantidad.value);

        if (isNaN(valor) || valor < 1) {
            inputCantidad.reportValidity(); // Usará el mensaje nativo del navegador
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