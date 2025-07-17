<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	<link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
	<title> Seccion de encuestas - Coordinador</title>
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
		/* Estilo adicional para los botones para asegurar uniformidad */
		.btn-uniform {
			min-width: 90px; /*  */
			text-align: center; /*  */
			display: inline-block; /*  */
			padding: 0.375rem 0.75rem; /*  */
			font-size: 0.875rem; /*  */
			line-height: 1.5; /*  */
		}

		/* Estilo para el botón de icono de perfil */
		.btn-icon-profile {
			background: none; /*  */
			border: none; /*  */
			padding: 0.25rem; /*  */
			/* Ajuste de padding para el icono */
			cursor: pointer; /*  */
			color: #6c757d; /* Color gris suave */ /*  */
			transition: color 0.2s ease-in-out; /*  */
			margin-right: 0.25rem; /* Espacio entre el icono y el nombre */ /*  */
		}
		.btn-icon-profile:hover {
			color: #007bff; /*  */
		}
		.btn-icon-profile i {
			font-size: 1.25rem; /*  */
		}

		/* ----- Ajustes para la barra de navegación superior y el bloque de usuario ----- */
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

		/* FIN DE LOS AJUSTES DE ALINEACIÓN DE USUARIO */


		.filter-section .form-label {
			margin-bottom: 0.5rem; /*  */
		}

		/* Ajuste para alinear la barra de búsqueda con el select del filtro */
		.filter-section .col-md-8 {
			display: flex; /*  */
			align-items: flex-end; /*  */
			justify-content: flex-end; /*  */
		}

		.filter-section .col-md-8 .input-group {
			margin-top: 0; /*  */
			max-width: 280px; /*  */
		}

		/* Asegurar que el select y el input tengan la misma altura para una alineación visual perfecta */
		.filter-section .form-select,
		.filter-section .input-group .form-control,
		.filter-section .input-group .input-group-text {
			height: 38px; /*  */
		}

		/* ESTILOS PARA LA LISTA DESPLEGABLE (SELECT) */
		.form-select {
			border-radius: 0.5rem; /*  */
			/*padding: 0.5rem 1rem; !*  *!*/
			box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /*  */
			border: 1px solid #ced4da; /*  */
			transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out; /*  */
		}

		.form-select:focus {
			border-color: #86b7fe; /*  */
			outline: 0; /*  */
			box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25); /*  */
		}

		/* Separación del título "Encuestas Totales" */
		.container-fluid .h3 {
			margin-bottom: 2.5rem; /*  */
		}


		/* Redondear los bordes de la tarjeta de la tabla con sombra */
		.card {
			border-radius: 1rem; /*  */
			overflow: hidden; /*  */
			box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); /*  */
		}

		/* AJUSTES DE PADDING PARA ALINEACIÓN DE ENCABEZADOS Y CELDAS */
		.table-hover thead th,
		.table-hover tbody td {
			padding-left: 1.2rem; /*  */
			padding-right: 1.5rem; /*  */
			vertical-align: middle; /*  */
		}

		/* Asegurar que el card-header también tenga el padding consistente */
		.card-header {
			padding-left: 1.2rem; /*  */
			padding-right: 1.5rem; /*  */
			padding-top: 1.5rem; /*  */
			padding-bottom: 1rem; /*  */
		}
		.card-header .card-title {
			margin-bottom: 0; /*  */
			font-size: 1.25rem; /*  */
		}

		/* Mover el ícono de perfil más a la izquierda usando un margen negativo para mayor separación */
		.table-hover tbody td:first-child .btn-icon-profile {
			margin-left: -1rem; /*  */
			margin-right: 0.5rem; /*  */
		}

		/* Nuevos estilos para el círculo de estado */
		.status-container, .form-action-group, .ban-action-group {
			display: flex; /*  */
			align-items: center; /*  */
			justify-content: flex-start; /*  */
			white-space: nowrap; /*  */
			height: 100%; /*  */
		}

		.status-dot {
			height: 10px; /*  */
			width: 10px; /*  */
			border-radius: 50%; /*  */
			display: inline-block; /*  */
			margin-right: 8px; /*  */
			flex-shrink: 0; /*  */
		}

		/* Estilo para el texto del Nombre (en mayúsculas) */
		.name-text {
			color: #343a40; /*  */
			font-weight: 350; /*  */
			font-size: 0.9em; /*  */
			text-transform: uppercase; /*  */
			/*white-space: nowrap; !*  *!*/
		}

		/* Estilos para DNI (no aplica directamente aquí pero se mantiene por consistencia de estilos generales) */
		.dni-text {
			color: #343a40; /*  */
			font-weight: 350; /*  */
			font-size: 1em; /*  */
			white-space: nowrap; /*  */
		}

		/* ESTILO ESPECÍFICO PARA EMAIL (no aplica directamente aquí) */
		.email-text {
			font-weight: 350; /*  */
			color: #343a40; /*  */
			font-size: 0.95em; /*  */
			/* white-space: nowrap; */
			font-style: italic; /*  */
		}

		/* Estilos para ACTIVO, ZONA / DISTRITO (aplicable a estado) */
		.status-text, .zone-text {
			color: #343a40; /*  */
			font-weight: 350; /*  */
			font-size: 0.9em; /*  */
			text-transform: uppercase; /*  */
			white-space: nowrap; /*  */
		}

		/* ESTILO ESPECÍFICO PARA TEXTOS DE ACCIÓN (ASIGNAR, DESACTIVAR, ACTIVAR) */
		.action-text {
			color: #343a40; /*  */
			font-weight: 350; /*  */
			font-size: 0.9em; /*  */
			text-transform: uppercase; /*  */
			white-space: nowrap; /*  */
			margin-right: 0.4rem; /*  */
			height: 32px; /*  */
			line-height: 32px; /*  */
		}

		.status-active .status-dot {
			background-color: #28a745; /*  */
		}

		.status-banned .status-dot {
			background-color: #dc3545; /*  */
		}

		/* Estilos para el botón de icono (sin texto) */
		.icon-only-button {
			padding: 0.3rem 0.5rem; /*  */
			border-radius: 0.75rem; /*  */
			transition: all 0.2s ease-in-out; /*  */
			display: flex; /*  */
			align-items: center; /*  */
			justify-content: center; /*  */
			min-width: 35px; /*  */
			height: 32px; /*  */
		}
		.icon-only-button i {
			font-size: 1rem; /*  */
			margin: 0; /*  */
		}

		/* Colores para los botones de acción */
		.btn-assign-icon {
			background-color: #20c997; /*  */
			border-color: #20c997; /*  */
			color: white; /*  */
		}
		.btn-assign-icon:hover {
			background-color: #1abc9c; /*  */
			border-color: #1abc9c; /*  */
		}

		.btn-ban-icon {
			background-color: #dc3545; /*  */
			border-color: #dc3545; /*  */
			color: white; /*  */
		}
		.btn-ban-icon:hover {
			background-color: #c82333; /*  */
			border-color: #bd2130; /*  */
		}

		.btn-activate-icon {
			background-color: #28a745; /*  */
			border-color: #28a745; /*  */
			color: white; /*  */
		}
		.btn-activate-icon:hover {
			background-color: #218838; /*  */
			border-color: #1e7e34; /*  */
		}

		/* Ajustes de ancho para las columnas */
		.table-hover thead th:nth-child(1) { /* ID */
			/*min-width: 80px; !* Ajustado para el ID *!*/
		}

		.table-hover thead th:nth-child(2) { /* Nombre */
			min-width: 100px;
		}

		.table-hover thead th:nth-child(3) { /* Descripción */
			min-width: 250px;
		}

		.table-hover thead th:nth-child(4) { /* Estado */
			min-width: 100px;
		}

		.table-hover thead th:nth-child(5) { /* Encuestador (Botón Asignar) */
			min-width: 120px;
		}

		.table-hover thead th:nth-child(6) { /* Acciones (Botones Activar/Desactivar) */
			min-width: 120px;
		}

		/* Ocultar barra de desplazamiento horizontal si no es necesaria */
		.table-responsive {
			overflow-x: auto; /*  */
			-webkit-overflow-scrolling: touch; /*  */
		}
		/* Ejemplo de CSS para centrar verticalmente */
		.perfil-contenedor {
			display: flex; /*  */
			align-items: center; /*  */
			gap: 12px; /*  */
		}

		.foto-perfil {
			width: 40px; /*  */
			height: 40px; /*  */
			border-radius: 50%; /*  */
			object-fit: cover; /*  */
		}

		.info-perfil {
			display: flex; /*  */
			flex-direction: column; /*  */
			justify-content: center; /*  */
		}

		.nombre {
			font-weight: bold; /*  */
		}

		.rol {
			font-size: 0.9em; /*  */
			color: #888; /*  */
		}


		 .main {
			 position: relative;
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
				<li class="sidebar-item ">
					<a class="sidebar-link" href="CoordinadorServlet?action=lista">
						<i class="align-middle" data-feather="users"></i> <span class="align-middle">Encuestadores de zona</span>
					</a>
				</li>
				<li class="sidebar-item active">
					<a class="sidebar-link " href="CoordinadorServlet?action=listarEncuestas">
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
			</ul>
		</div>
	</nav>
	<div class="main">
		<%-- confirmación de asginación -->
		<c:if test="${param.mensaje == 'asignacionExitosa'}">
			<div id="mensajeExito"
				 class="alert d-flex align-items-center justify-content-center mt-4 mx-auto shadow-sm rounded border-0"
				 role="alert"
				 style="max-width: 600px; padding: 1rem 1.5rem; background-color: #d1e7dd; color: #0f5132;">
				<i data-feather="check-circle" class="me-2"></i>
				<span><strong>Asignación Exitosa:</strong> La encuesta fue asignada correctamente.</span>
			</div>
		</c:if>
		<%-- -- --%>
		<nav class="navbar navbar-expand navbar-light navbar-bg">
			<a class="sidebar-toggle js-sidebar-toggle">
				<i class="hamburger align-self-center"></i>
			</a>
			<div class="navbar-collapse collapse">
				<ul class="navbar-nav navbar-align">
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle    " href="#" data-bs-toggle="dropdown">
							<%-- Se adapta la imagen de perfil y la información del usuario --%>
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
							<a class="dropdown-item" href="CoordinadorServlet?action=verPerfil"><i class="align-middle me-1" data-feather="user"></i> Mi Perfil</a>
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
				<div class="mb-4 filter-section">
					<form method="get" action="CoordinadorServlet" class="row g-2 align-items-center">
						<input type="hidden" name="action" value="listarEncuestas"/>
						<div class="col-auto">
							<label for="carpeta" class="form-label fw-bold text-muted text-uppercase" style="font-size: 0.8em; letter-spacing: 0.05em;">Filtrar por carpeta:</label>
						</div>
						<div class="col-auto">
							<select name="carpeta" id="carpeta" class="form-select" onchange="this.form.submit()">
								<option value="" ${empty carpetaSeleccionada ? 'selected' : ''}>-- SELECCIONAR UNA CARPETA --</option>
								<c:forEach var="c" items="${listaCarpetas}">
									<option value="${c}" ${c == carpetaSeleccionada ? 'selected' : ''}>${c}</option>
								</c:forEach>
							</select>
						</div>
					</form>
				</div>
				<div class="card">
					<div class="card-header">
						<h5 class="card-title mb-0">Lista de Encuestas</h5>
					</div>
					<div class="table-responsive">
						<table class="table table-hover my-0">
							<thead>
							<tr>
								<th class="text-uppercase">#</th>
								<th class="text-uppercase">Nombre</th>
								<th class="text-uppercase">Descripción</th>
								<th class="text-uppercase">Estado</th>
								<th class="text-uppercase">Asignar</th>
								<th class="text-uppercase">Acciones</th>
							</tr>
							</thead>
							<tbody>
							<c:forEach var="e" items="${listaEncuestas}">
								<tr>
									<td class="dni-text">${e.encuestaId}</td>
									<td class="name-text">${e.nombre}</td>
									<td class="email-text">
										<c:choose>
											<c:when test="${fn:length(e.descripcion) > 100}">
												<span id="corta-${e.encuestaId}">${fn:substring(e.descripcion, 0, 100)}...</span>
												<a href="#" onclick="toggleDescripcion('${e.encuestaId}'); return false;" id="toggle-btn-${e.encuestaId}">Ver más</a>
												<span id="completa-${e.encuestaId}" style="display:none;">${e.descripcion}</span>
											</c:when>
											<c:otherwise>
												${e.descripcion}
											</c:otherwise>
										</c:choose>
									</td>

									<td>
										<div class="status-container ${e.estado == 'activo' ? 'status-active' : 'status-banned'}">
											<span class="status-dot"></span>
											<span class="status-text">${e.estado == 'activo' ? 'ACTIVO' : 'INACTIVO'}</span>
										</div>
									</td>
									<td class="name-text">
										<c:choose>
											<c:when test="${e.estado == 'activo'}">
												<div class="form-action-group">
													<span class="action-text">ASIGNAR</span>
													<a href="CoordinadorServlet?action=filtrarAsignar&encuestaId=${e.encuestaId}&nombreEncuesta=${e.nombre}&carpeta=${carpetaSeleccionada}" class="btn icon-only-button btn-assign-icon" title="Asignar Encuesta">
														<i data-feather="file-text"></i>
													</a>
												</div>
											</c:when>
											<c:otherwise>
												<div class="form-action-group">
													<span class="action-text">ASIGNAR</span>
													<button class="btn icon-only-button btn-secondary" disabled title="Encuesta inactiva">
														<i data-feather="file-text"></i>
													</button>
												</div>
											</c:otherwise>
										</c:choose>
									</td>
									<%-- Logica para confirmación de acción --%>
									<td>
										<div class="ban-action-group">
											<span class="action-text">
													${e.estado == 'activo' ? 'DESACTIVAR' : 'ACTIVAR'}
											</span>

											<form method="post" action="CoordinadorServlet" class="m-0"
												  onsubmit="return confirm('¿Está seguro de ${e.estado == 'activo' ? 'desactivar' : 'activar'} la encuesta \'${e.nombre}\'?');">
												<input type="hidden" name="action" value="cambiarEstadoEncuesta"/>
												<input type="hidden" name="id" value="${e.encuestaId}"/>
												<input type="hidden" name="estado" value="${e.estado}"/>
												<input type="hidden" name="carpeta" value="${carpetaSeleccionada}"/>
												<button type="submit"
														class="btn icon-only-button ${e.estado == 'activo' ? 'btn-ban-icon' : 'btn-activate-icon'}"
														title="${e.estado == 'activo' ? 'Desactivar Encuesta' : 'Activar Encuesta'}">
													<i data-feather="${e.estado == 'activo' ? 'slash' : 'check-circle'}"></i>
												</button>
											</form>
										</div>
									</td>
										<%-- -------- --%>
								</tr>
							</c:forEach>
							</tbody>
						</table>
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
	});
</script>

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

<script>
	document.addEventListener("DOMContentLoaded", function () {
		feather.replace();
		const mensaje = document.getElementById("mensajeExito");
		if (mensaje) {
			setTimeout(() => {
				mensaje.classList.add("fade");
				setTimeout(() => mensaje.remove(), 500);
			}, 5000);
		}
	});
</script>


</body>
</html>