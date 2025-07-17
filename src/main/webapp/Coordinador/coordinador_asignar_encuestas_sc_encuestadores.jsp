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
    <!-- modificado para ruta relativa al contexto -->
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <title> Asignar encuestas desde la sección encuestadores - Coordinador</title>

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

        .seccion-cantidad-botones {
            max-width: 320px;
            margin: 2rem auto 0 auto;
            text-align: center;
        }

        .seccion-cantidad-botones .form-group-boton {
            justify-content: center;
        }

        .form-select-reducido {
            width: 40% !important; /* o prueba con 35% si quieres más compacto */
            min-width: 220px;
            max-width: 350px;
        }

        .form-contenedor {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 1rem;
        }

        .form-contenedor .campo {
            flex: 1 1 48%;
            min-width: 240px;
        }

        .campo input, .campo select {
            width: 100%;
        }

        .form-group-boton {
            display: flex;
            flex-direction: row;
            justify-content: flex-start;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .card-body h5 {
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 1rem;
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
            <div class="container-fluid p-0">

                <!-- Título general centrado fuera del card -->
                <h1 class="h3 text-center mb-4">Asignar Encuesta al Encuestador</h1>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="card-body">
                                    <c:if test="${not empty encuestador}">
                                        <div class="alert alert-info mb-4">
                                            <h5 class="mb-2">Asignando a:</h5>
                                            <ul class="mb-0">
                                                <li><strong>Nombre y Apellidos:</strong> ${encuestador.nombre} ${encuestador.apellidoPaterno} ${encuestador.apellidoMaterno}</li>
                                                <li><strong>DNI:</strong> ${encuestador.dni}</li>
                                                <li><strong>Email:</strong> ${encuestador.correo}</li>
                                                <li><strong>Zona:</strong> ${encuestador.zona.nombre}</li>
                                                <li><strong>Distrito:</strong> ${encuestador.distrito.nombre}</li>
                                            </ul>
                                        </div>
                                    </c:if>

                                    <h5>Formulario de asignación</h5>
                                    <form id="formAsignacion" method="post" action="CoordinadorServlet">
                                        <input type="hidden" name="action" value="guardarAsignacion"/>
                                        <input type="hidden" name="idEncuestador" value="${param.id}"/>
                                        <input type="hidden" name="origen" value="vistaEncuestadores" />
                                        <input type="hidden" name="zonaId" value="${zonaIdFiltro}" />
                                        <input type="hidden" name="distritoId" value="${distritoIdFiltro}" />

                                        <div class="form-contenedor">
                                            <div class="campo">
                                                <label class="form-label">Carpeta:</label>
                                                <select name="carpeta" class="form-select" required>
                                                    <option value="">Seleccione una carpeta</option>
                                                    <c:forEach var="c" items="${listaCarpetas}">
                                                        <option value="${c}" ${carpeta == c ? 'selected' : ''}>${c}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="campo">
                                                <label class="form-label">Nombre de la Encuesta:</label>
                                                <select name="nombreEncuesta" class="form-select" required>
                                                    <option value="">Seleccione una encuesta</option>
                                                    <c:forEach var="e" items="${listaEncuestas}">
                                                        <option value="${e.nombre}" <c:if test="${e.estado != 'activo'}">disabled</c:if>>
                                                                ${e.nombre}<c:if test="${e.estado != 'activo'}"> (desactivada)</c:if>
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="seccion-cantidad-botones">
                                            <label class="form-label">Cantidad de encuestas a asignar:</label>
                                            <input type="number" name="cantidad" min="1" max="1000" value="1" required class="form-control" />

                                            <div class="form-group-boton">
                                                <button type="submit" class="btn btn-primary" onclick="return validarYConfirmarAsignacion();">
                                                    Asignar Encuesta
                                                </button>
                                            </div>

                                        </div>
                                    </form>
                                    <!-- Botón separado para volver a la lista -->
                                    <form method="get" action="CoordinadorServlet" class="text-center mt-3">
                                        <input type="hidden" name="action" value="filtrar"/>
                                        <input type="hidden" name="zonaId" value="${zonaIdFiltro}" />
                                        <input type="hidden" name="distritoId" value="${distritoIdFiltro}" />
                                        <button type="submit" class="btn btn-secondary">← Volver a la lista</button>
                                    </form>
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

<!-- Scripts -->
<script src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        feather.replace();
    });
</script>

<script>
    function validarYConfirmarAsignacion() {
        const carpetaSelect = document.querySelector('select[name="carpeta"]');
        const encuestaSelect = document.querySelector('select[name="nombreEncuesta"]');
        const cantidadInput = document.querySelector('input[name="cantidad"]');
        const cantidad = parseInt(cantidadInput.value);

        if (!carpetaSelect.value || !encuestaSelect.value) {
            mostrarAlerta("Por favor, selecciona una carpeta y una encuesta antes de continuar.");
            return false;
        }

        if (isNaN(cantidad) || cantidad < 1 || cantidad > 1000) {
            mostrarAlerta("La cantidad debe estar entre 1 y 50.");
            return false;
        }

        return confirm("¿Está seguro de realizar esta asignación?");
    }

</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("formAsignacion");
        form.addEventListener("submit", function (e) {
            const cantidadInput = form.querySelector('input[name="cantidad"]');
            const cantidad = parseInt(cantidadInput.value);

            if (isNaN(cantidad) || cantidad < 1 || cantidad > 1000) {
                e.preventDefault(); // Cancela el envío
                mostrarAlerta("El valor debe ser superior o igual a 1 y no mayor a 1000.");
            }
        });

        function mostrarAlerta(mensaje) {
            const alerta = document.createElement("div");
            alerta.innerHTML = `
                <div id="alertaValidacion" style="
                    position: fixed;
                    top: 30%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    background-color: #1e1e2f;
                    color: white;
                    padding: 20px 30px;
                    border-radius: 12px;
                    box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.5);
                    z-index: 9999;
                    text-align: center;
                    font-size: 16px;
                ">
                    <strong>${mensaje}</strong><br><br>
                    <button onclick="this.parentElement.remove()" style="
                        background-color: #4f46e5;
                        color: white;
                        border: none;
                        padding: 6px 16px;
                        border-radius: 8px;
                        cursor: pointer;
                    ">Aceptar</button>
                </div>
            `;
            document.body.appendChild(alerta);
        }
    });
</script>

</body>
</html>