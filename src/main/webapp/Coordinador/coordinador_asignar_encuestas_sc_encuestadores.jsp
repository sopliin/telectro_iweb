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
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

    <title> Asignar encuestas desde la sección encuestadores - Coordinador</title>

    <style>
        /* ESTILOS GENERALES Y DE DISEÑO DE PÁGINA */
        body {
            background-color: #f8f9fa; /* Un fondo muy ligero para todo el body */
        }

        .content {
            padding: 1.5rem; /* Padding general del contenido principal */
        }

        /* TÍTULOS */
        h1.h3 {
            font-size: 1.75rem;
            font-weight: 600;
            color: #344767;
            margin-bottom: 1.5rem;
            text-align: left !important; /* Asegura alineación a la izquierda */
        }
        h5 {
            font-size: 1.2rem;
            color: #344767;
            margin-bottom: 1rem;
            border-bottom: 1px solid #eee; /* Línea separadora */
            padding-bottom: 0.5rem;
            font-weight: 600; /* Negrita para los títulos de sección */
        }

        /* ALERTAS */
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

        /* CARD GENERAL */
        .card {
            border: none; /* Eliminar borde por defecto */
            border-radius: 0.75rem; /* Bordes más redondeados */
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.08); /* Sombra más suave y moderna */
        }

        .card-body {
            padding: 2rem; /* Aumentar el padding dentro de la card */
        }

        /* CAMPOS DE FORMULARIO */
        .form-label {
            font-weight: 500;
            color: #444;
            margin-bottom: 0.5rem;
            display: block; /* Asegura que ocupe su propia línea */
            font-size: 0.9rem;
        }

        .form-select, .form-control {
            border-radius: 0.4rem;
            font-size: 0.9rem; /* Reducir ligeramente el tamaño del texto en inputs */
            padding: 0.5rem 0.75rem; /* Ajustar padding para que sean más grandes */
            border: 1px solid #ced4da; /* Borde estándar de Bootstrap */
        }
        .form-select:focus, .form-control:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25);
        }

        /* LAYOUT DE FORMULARIO - CARPETA Y ENCUESTA */
        .form-contenedor {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start; /* Alinea los elementos al inicio */
            gap: 1.5rem; /* Más espacio entre campos */
            margin-bottom: 1.5rem; /* Espacio antes de la sección de cantidad */
        }

        .form-contenedor .campo {
            flex: 1 1 40%; /* Ajustado para que sean más compactos */
            min-width: 250px; /* Asegura que no sean demasiado pequeños */
        }

        .campo input, .campo select {
            width: 100%;
        }

        /* SECCIÓN CANTIDAD Y BOTÓN ASIGNAR */
        .seccion-cantidad-botones {
            margin: 2.5rem 0 0 0; /* Alineado a la izquierda, no centrado */
            text-align: left; /* Asegura que el texto y el input estén a la izquierda */
        }

        .seccion-cantidad-botones .form-group-boton {
            display: flex;
            flex-direction: row;
            justify-content: flex-start; /* Alinea los botones al inicio */
            gap: 1rem;
        }

        /* BOTONES */
        .btn-outline-primary {
            border-color: #f01c74;
            background: #f01c74;
            color: #ffffff;
            padding: 0.5rem 1.5rem; /* Hacer el botón "Asignar Encuesta" más grande */
            font-size: 1rem;
            border-radius: 0.5rem;
            transition: all 0.2s cubic-bezier(.4,0,.2,1);
            box-shadow: 0 2px 8px rgba(240,28,116,0.15); /* Sombra suave */
        }
        .btn-outline-primary:hover {
            background: #d41865; /* Color ligeramente más oscuro al pasar el ratón */
            border-color: #d41865;
            box-shadow: 0 4px 12px rgba(240,28,116,0.25);
        }

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

        /* MISCELÁNEOS */
        .list-unstyled {
            padding-left: 0;
            list-style: none;
        }
        .list-unstyled li {
            margin-bottom: 0.5rem;
            color: #555;
            font-size: 0.95rem;
        }
        .list-unstyled li strong {
            color: #333;
        }
        .badge.bg-danger {
            background-color: #6f42c1 !important; /* Usar el color morado de encuestas_asignadas.txt */
            padding: 0.4em 0.7em;
            border-radius: 0.3rem;
            font-size: 0.75em;
        }
        [data-feather] {
            width: 1rem;
            height: 1rem;
            vertical-align: text-bottom;
        }

        /* Footer (SIN CAMBIOS) */
        .footer .row {
            flex-wrap: wrap;
        }
        .footer .col-6 {
            width: 100% !important;
            text-align: center !important;
            margin-bottom: 0.5rem;
        }
        .footer .list-inline {
            flex-wrap: wrap;
        }
        .footer .list-inline-item {
            margin: 0 0.5rem;
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
                    <a class="sidebar-link" href="CoordinadorServlet?action=asignarFormulario&id=${param.id}&zonaId=&distritoId=">
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

                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <c:if test="${not empty encuestador}">
                            <div class="alert alert-info shadow-sm mb-4">
                                <h5 class="fw-semibold text-dark mb-2">Asignando a:</h5>
                                <ul class="list-unstyled small text-secondary mb-0">
                                    <li><strong>Nombre y Apellidos:</strong> ${encuestador.nombre} ${encuestador.apellidoPaterno} ${encuestador.apellidoMaterno}</li>
                                    <li><strong>DNI:</strong> ${encuestador.dni}</li>
                                    <li><strong>Email:</strong> ${encuestador.correo}</li>
                                    <li><strong>Zona:</strong> ${encuestador.zona.nombre}</li>
                                    <li><strong>Distrito:</strong> ${encuestador.distrito.nombre}</li>
                                </ul>
                            </div>
                        </c:if>

                        <h5 class="fw-semibold text-dark border-bottom pb-2 mb-3">Formulario de asignación</h5>

                        <form id="formAsignacion" method="post" action="CoordinadorServlet">
                            <input type="hidden" name="action" value="guardarAsignacion"/>
                            <input type="hidden" name="idEncuestador" value="${param.id}"/>
                            <input type="hidden" name="origen" value="vistaEncuestadores" />
                            <input type="hidden" name="zonaId" value="${zonaIdFiltro}" />
                            <input type="hidden" name="distritoId" value="${distritoIdFiltro}" />

                            <div class="form-contenedor">
                                <div class="campo">
                                    <label class="form-label">Carpeta:</label>
                                    <select name="carpeta" id="carpetaSelect" class="form-select" required>
                                        <option value="">Seleccione una carpeta</option>
                                        <c:forEach var="c" items="${listaCarpetas}">
                                            <option value="${c}" ${carpeta == c ? 'selected' : ''}>${c}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="campo">
                                    <label class="form-label">Nombre de la Encuesta:</label>
                                    <select name="nombreEncuesta" id="encuestaSelect" class="form-select" required disabled>
                                        <option value="">Seleccione una encuesta</option>
                                        <c:forEach var="e" items="${listaEncuestas}">
                                            <option value="${e.nombre}"
                                                    data-carpeta="${e.carpeta}"
                                                    <c:if test="${e.estado != 'activo'}">disabled</c:if>>
                                                    ${e.nombre}<c:if test="${e.estado != 'activo'}"> (desactivada)</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="seccion-cantidad-botones">
                                <div class="row">
                                    <div class="col-auto">
                                        <label class="form-label">Cantidad de encuestas a asignar:</label>
                                    </div>
                                    <div class="col-3 col-sm-2 col-xl-1">
                                        <input type="number" name="cantidad" min="1" max="1000" value="1" required class="form-control" />
                                    </div>
                                    <div class="col">
                                        <div class="form-group-boton">
                                            <button type="submit" class="btn btn-outline-primary" onclick="return validarYConfirmarAsignacion();">
                                                Asignar Encuesta
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>

                        <div class="mt-4 text-end">
                            <a href="CoordinadorServlet?action=filtrar&zonaId=${zonaIdFiltro}&distritoId=${distritoIdFiltro}" class="btn btn-secondary">
                                <i class="align-middle me-1" data-feather="arrow-left"></i> Volver a la lista
                            </a>
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
        // Inicializar alertas de Bootstrap si las hubiera
        var alertList = document.querySelectorAll('.alert');
        alertList.forEach(function (alert) {
            new bootstrap.Alert(alert)
        });
    });
</script>

<script>
    function validarYConfirmarAsignacion() {
        const carpetaSelect = document.querySelector('select[name="carpeta"]');
        const encuestaSelect = document.querySelector('select[name="nombreEncuesta"]');
        const cantidadInput = document.querySelector('input[name="cantidad"]');
        const cantidad = parseInt(cantidadInput.value);

        if (!carpetaSelect.value || !encuestaSelect.value) {
            alert("Por favor, selecciona una carpeta y una encuesta antes de continuar.");
            return false;
        }

        if (isNaN(cantidad) || !Number.isInteger(cantidad)|| cantidad < 1 || cantidad > 1000) {
            alert("La cantidad debe ser un número entero entre 1 y 1000.");
            return false;
        }

        return confirm("¿Está seguro de realizar esta asignación?");
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const carpetaSelect = document.getElementById("carpetaSelect");
        const encuestaSelect = document.getElementById("encuestaSelect");

        // Guardamos una copia de las opciones originales
        const originalOptions = Array.from(encuestaSelect.options)
            .filter(opt => opt.value !== "")
            .map(opt => opt.cloneNode(true));

        carpetaSelect.addEventListener("change", function () {
            const selectedCarpeta = this.value;

            // Restaurar el select con solo la opción por defecto
            encuestaSelect.innerHTML = '<option value="">Seleccione una encuesta</option>';

            if (selectedCarpeta !== "") {
                encuestaSelect.disabled = false;

                // Filtrar y mostrar solo las encuestas que pertenecen a esa carpeta
                originalOptions.forEach(opt => {
                    if (opt.getAttribute("data-carpeta") === selectedCarpeta) {
                        encuestaSelect.appendChild(opt.cloneNode(true));
                    }
                });
            } else {
                encuestaSelect.disabled = true;
            }
        });

        // Trigger change on load if a folder is pre-selected (e.g., after form submission with errors)
        if (carpetaSelect.value !== "") {
            carpetaSelect.dispatchEvent(new Event('change'));
        }
    });
</script>
</body>
</html>