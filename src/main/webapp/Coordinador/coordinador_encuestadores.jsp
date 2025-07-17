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
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
	<link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">

	<title> Sección de encuestadores - Coordinador</title>
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

		/* Ajuste para el espaciado del filtro y buscador */
		.filter-section .row {
			align-items: flex-start; /* Alinea los elementos de la fila a la parte superior */
			margin-bottom: 2.5rem; /* Aumentado para mayor separación con la tabla */
		}

		.filter-section .form-label {
			margin-bottom: 0.5rem; /* Aseguramos un margen inferior estándar para la etiqueta */
		}

		/* Ajuste para alinear la barra de búsqueda con el select del filtro */
		.filter-section .col-md-8 {
			display: flex;
			align-items: flex-end; /* Alinea el input-group a la parte inferior de su columna, aliniando con el select */
			justify-content: flex-end; /* Mantiene el buscador a la derecha */
		}

		.filter-section .col-md-8 .input-group {
			margin-top: 0; /* Eliminar el margin-top para que se alinee con el bottom del label del select */
			max-width: 280px; /* Mantener el ancho si es deseado */
		}

		/* Asegurar que el select y el input tengan la misma altura para una alineación visual perfecta */
		.filter-section .form-select,
		.filter-section .input-group .form-control,
		.filter-section .input-group .input-group-text {
			height: 38px; /* Altura estándar de Bootstrap para form-control. Asegura que sean iguales. */
		}

		/* ESTILOS PARA LA LISTA DESPLEGABLE (SELECT) */
		.form-select {
			border-radius: 0.5rem; /* Bordes más redondeados */
			padding: 0.5rem 1rem; /* Aumentar el padding para un mejor aspecto */
			box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /* Sombra ligera */
			border: 1px solid #ced4da; /* Borde estándar */
			transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
		}

		.form-select:focus {
			border-color: #86b7fe;
			outline: 0;
			box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
		}

		/* Separación del título "Encuestadores Registrados" */
		.container-fluid .h3 {
			margin-bottom: 2.5rem; /* Aumentado para mayor separación uniforme con la sección de filtros*/
		}


		/* Redondear los bordes de la tarjeta de la tabla con sombra */
		.card {
			border-radius: 1rem; /* Aumentado el radio para un efecto más notorio */
			overflow: hidden; /* Asegura que el contenido interno se recorte con el border-radius */
			box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); /* Sombra sutil */
		}

		/* AJUSTES DE PADDING PARA ALINEACIÓN DE ENCABEZADOS Y CELDAS */
		.table-hover thead th,
		.table-hover tbody td {
			padding-left: 1.5rem; /* Ajuste el padding izquierdo para alinear las letras iniciales*/
			padding-right: 1.5rem; /* Mantener padding derecho */
			vertical-align: middle; /* Asegura que el contenido de la celda se alinee al medio */
		}

		/* Asegurar que el card-header también tenga el padding consistente */
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

		/* Mover el ícono de perfil más a la izquierda usando un margen negativo para mayor separación */
		.table-hover tbody td:first-child .btn-icon-profile {
			margin-left: -1rem; /* Ajustado para el nuevo padding*/
			margin-right: 0.5rem;
		}

		/* Nuevos estilos para el círculo de estado */
		.status-container, .form-action-group, .ban-action-group {
			display: flex;
			align-items: center; /* Centrar verticalmente los elementos*/
			justify-content: flex-start; /* Alinear a la izquierda por defecto (cambiado de center)*/
			white-space: nowrap;
			height: 100%; /* Asegurar que ocupan toda la altura de la celda */
		}

		.status-dot {
			height: 10px;
			width: 10px;
			border-radius: 50%;
			display: inline-block;
			margin-right: 8px;
			flex-shrink: 0;
		}

		/* Estilo para el texto del Nombre y Apellidos (en mayúsculas) */
		.name-text {
			color: #343a40; /* Color gris oscuro */
			font-weight: 350;
			font-size: 0.9em; /* Ligeramente más grande*/
			text-transform: uppercase; /* Asegurar mayúsculas */
			white-space: nowrap; /* Evita que el texto se parta en varias líneas */
		}

		/* Estilos para DNI */
		.dni-text {
			color: #343a40;
			font-weight: 350;
			font-size: 1em; /* Unificado el tamaño*/
			white-space: nowrap; /* Evita que el texto se parta en varias líneas */
		}

		/* ESTILO ESPECÍFICO PARA EMAIL */
		.email-text {
			font-weight: 350; /* Texto en negrita */
			color: #343a40; /* Color gris oscuro sugerido para el email */
			font-size: 0.95em; /* Unificado el tamaño*/
			white-space: nowrap; /* Evita que el texto se parta en varias líneas */
			font-style: italic;
		}

		/* Estilos para ACTIVO, ZONA / DISTRITO */
		.status-text, .zone-text {
			color: #343a40;
			font-weight: 350;
			font-size: 0.9em; /* Ligeramente más grande*/
			text-transform: uppercase; /* Asegurar mayúsculas para estos textos */
			white-space: nowrap; /* Evita que el texto se parta en varias líneas */
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

		.status-active .status-dot {
			background-color: #28a745;
		}

		.status-active .status-dot {
			background-color: #28a745;
		}

		.status-banned .status-dot {
			background-color: #dc3545;
		}

		/* Estilos para el botón de icono (sin texto) */
		.icon-only-button {
			padding: 0.3rem 0.5rem; /* Padding ligeramente ajustado para compactar el botón */
			border-radius: 0.75rem; /* Bordes redondeados, un poco menos que el status chip */
			transition: all 0.2s ease-in-out;
			display: flex; /* Asegura que el ícono esté centrado */
			align-items: center;
			justify-content: center;
			min-width: 35px; /* Un ancho mínimo para el botón del ícono (reducido) */
			height: 32px; /* Altura fija para el botón del ícono*/
		}
		.icon-only-button i {
			font-size: 1rem; /* Tamaño del ícono */
			margin: 0; /* No margin extra en el ícono */
		}

		/* Colores para los botones de acción */
		.btn-assign-icon {
			background-color: #20c997; /* Verde/Teal para asignar */
			border-color: #20c997;
			color: white;
		}
		.btn-assign-icon:hover {
			background-color: #1abc9c;
			border-color: #1abc9c;
		}

		.btn-ban-icon {
			background-color: #dc3545; /* Rojo para banear */
			border-color: #dc3545;
			color: white;
		}
		.btn-ban-icon:hover {
			background-color: #c82333;
			border-color: #bd2130;
		}

		.btn-activate-icon {
			background-color: #28a745; /* Verde para activar */
			border-color: #28a745;
			color: white;
		}
		.btn-activate-icon:hover {
			background-color: #218838;
			border-color: #1e7e34;
		}

		/* Ajustes de ancho para las columnas */
		/* Nombre */
		.table-hover thead th:nth-child(1) {
			min-width: 1rem;
		}

		/* Apellidos */
		.table-hover thead th:nth-child(2) {
			min-width: 1rem;
		}

		/* DNI */
		.table-hover thead th:nth-child(3) {
			min-width: 1rem;
			white-space: nowrap;
		}

		/* Email */
		.table-hover thead th:nth-child(4) {
			min-width: 1rem;
			white-space: nowrap;
		}

		/* Zona / Distrito */
		.table-hover thead th:nth-child(5) {
			min-width: 1rem;
		}

		/* Estado */
		.table-hover thead th:nth-child(6) {
			min-width: 1rem;
		}
		/* Formulario */
		.table-hover thead th:nth-child(7) {
			min-width: 1rem; /* Aumentado ligeramente para acomodar el texto y el botón */
		}
		/* Acciones */
		.table-hover thead th:nth-child(8) {
			min-width: 1rem; /* Aumentado ligeramente para acomodar el texto y el botón */
		}

		/* Ocultar barra de desplazamiento horizontal si no es necesaria */
		.table-responsive {
			overflow-x: auto; /* Permite el scroll solo si el contenido lo requiere*/
			-webkit-overflow-scrolling: touch; /* Mejora el desplazamiento en dispositivos táctiles */
		}
		/* Ejemplo de CSS para centrar verticalmente */
		.perfil-contenedor {
			display: flex;
			align-items: center; /* Centra verticalmente */
			gap: 12px; /* Espacio entre la foto y el texto */
		}

		.foto-perfil {
			width: 40px;
			height: 40px;
			border-radius: 50%;
			object-fit: cover;
		}

		.info-perfil {
			display: flex;
			flex-direction: column;
			justify-content: center; /* Centra verticalmente el texto respecto a la imagen */
		}

		.nombre {
			font-weight: bold;
		}

		.rol {
			font-size: 0.9em;
			color: #888;
		}
		/* Custom Toast Styles */
		#toastContainer {
			position: fixed;
			top: 20px;
			left: 50%;
			transform: translateX(-50%);
			z-index: 1050;
			width: 100%;
			max-width: 500px; /* Adjust as needed */
			padding: 0 15px;
			display: flex; /* For stacking multiple toasts */
			flex-direction: column;
			align-items: center; /* Center toasts horizontally */
		}

		.custom-toast {
			background-color: #2a3942; /* Dark background similar to WhatsApp */
			color: #ffffff;
			border-radius: 0.75rem;
			box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
			padding: 1rem 1.25rem;
			display: flex;
			flex-direction: column;
			align-items: flex-start; /* Align message to the left */
			font-family: 'Inter', sans-serif;
			animation: fadeInDown 0.5s ease-out; /* Animation for appearance */
			margin-bottom: 15px; /* Space between multiple toasts if any */
			width: 100%; /* Occupy max-width of container */
		}

		@keyframes fadeInDown {
			from {
				opacity: 0;
				transform: translateY(-20px);
			}
			to {
				opacity: 1;
				transform: translateY(0);
			}
		}

		.custom-toast.hide-animation {
			animation: fadeOutUp 0.5s ease-in forwards;
		}

		@keyframes fadeOutUp {
			from {
				opacity: 1;
				transform: translateY(0);
			}
			to {
				opacity: 0;
				transform: translateY(-20px);
			}
		}

		.custom-toast .toast-body {
			width: 100%;
		}

		.custom-toast .toast-message {
			margin-bottom: 1.25rem; /* Space between message and buttons */
			font-size: 1rem;
			line-height: 1.4;
		}

		.custom-toast .toast-buttons {
			display: flex;
			justify-content: flex-end; /* Align buttons to the right */
			width: 100%;
			gap: 0.75rem; /* Space between buttons */
		}

		.custom-toast .btn {
			padding: 0.6rem 1.2rem;
			border-radius: 0.5rem;
			font-weight: 600;
			font-size: 0.9rem;
			cursor: pointer;
			transition: all 0.2s ease;
			flex-shrink: 0; /* Prevent buttons from shrinking */
		}

		.custom-toast .toast-cancel-btn {
			background-color: transparent;
			border: none;
			color: #aebcbe; /* Light grey text for "Cerrar" */
		}
		.custom-toast .toast-cancel-btn:hover {
			background-color: rgba(255, 255, 255, 0.1);
			color: #ffffff;
		}

		.custom-toast .toast-confirm-btn {
			background-color: #25d366; /* WhatsApp green */
			border-color: #25d366;
			color: #ffffff;
		}
		.custom-toast .toast-confirm-btn:hover {
			background-color: #1eb857; /* Darker green on hover */
			border-color: #1eb857;
			transform: translateY(-1px);
		}
		/* Reducir ancho de la columna de numeración */
		.table-hover tbody td:nth-child(1),
		.table-hover thead th:nth-child(1) {
			width: 40px;
			min-width: 40px;
			text-align: center; /* Opcional para centrar los números */
			padding-left: 0.5rem;
			padding-right: 0.5rem;
		}

		.table-hover tbody td .d-flex .text-dark {
			margin-right: 8px; /* Ajusta este valor según la separación deseada */
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
				<li class="sidebar-item active">
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
				<h1 class="h3 mb-3">Encuestadores Registrados</h1>

				<div class="row mb-4 filter-section">
					<div class="col-md-4">
						<form method="get" action="CoordinadorServlet">
							<input type="hidden" name="action" value="filtrar"/>
							<div class="mb-3 mb-md-0">
								<label for="distritoId" class="form-label fw-bold text-muted text-uppercase" style="font-size: 0.8em; letter-spacing: 0.05em;">Filtrar por distrito:</label>
								<select name="distritoId" id="distritoId" class="form-select" onchange="reiniciarPagina(this.form)" ${empty listaDistritos ? 'disabled' : ''}>
									<option value="">-- SELECCIONE UN DISTRITO --</option>
									<c:forEach var="d" items="${listaDistritos}">
										<option value="${d.distritoId}" ${d.distritoId == distritoSeleccionado ? 'selected' : ''}>${d.nombre}</option>
									</c:forEach>
								</select>
							</div>
						</form>
					</div>
					<div class="col-md-8 d-flex justify-content-end align-items-end"> <%-- Cambiado a align-items-end --%>
						<div class="input-group" style="max-width: 280px;">
							<label for="buscadorEncuestadores" class="visually-hidden">Buscar encuestadores</label>
							<span class="input-group-text bg-light border-end-0 rounded-start">
                         <i data-feather="search" class="align-middle"></i>
                      </span>
							<input type="text" id="buscadorEncuestadores" class="form-control border-start-0 rounded-end" placeholder="Buscar encuestador..." aria-label="Buscar">
						</div>
					</div>
				</div>
				<%-- tabla de encuestadores --%>
				<div class="card p-2">
					<div class="card-header p-2 pt-3">
						<h5 class="card-title mb-0">Lista de Encuestadores</h5>
					</div>

					<div class="table-responsive">
						<table class="table table-hover my-0" id="tablaEncuestadores">
							<thead>
							<tr>
								<th class="text-uppercase">#</th> <!-- Nueva columna -->
								<th class="text-uppercase">Nombre</th>
								<th class="text-uppercase">Apellidos</th>
								<th class="text-uppercase">DNI</th>
								<th class="text-uppercase">Email</th>
								<th class="text-uppercase">Zona / Distrito</th>
								<th class="text-uppercase">Estado</th>
								<th class="text-uppercase">Formulario</th>
								<th class="text-uppercase">Acciones</th>
							</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${empty listaEncuestadores}">
									<tr>
										<td colspan="8" class="text-center">No hay encuestadores registrados.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<!-- Aquí van tus filas con datos de encuestadores -->
									<c:forEach var="u" items="${listaEncuestadores}" varStatus="status">
										<tr>
											<td class="dni-text">
												<c:out value="${(paginaActual - 1) * 4 + status.index + 1}"/>
											</td>
											<td>
												<div class="d-flex align-items-center justify-content-start">
													<form method="get" action="CoordinadorServlet" class="d-inline-block m-0 p-0">
														<input type="hidden" name="action" value="verPerfilEncuestador"/>
														<input type="hidden" name="id" value="${u.usuarioId}"/>
														<input type="hidden" name="zonaId" value="${zonaSeleccionada}"/>
														<input type="hidden" name="distritoId" value="${distritoSeleccionado}"/>
														<a href="CoordinadorServlet?action=verPerfilEncuestador&id=${u.usuarioId}&zonaId=${zonaSeleccionada}&distritoId=${distritoSeleccionado}" title="Ver Perfil" class="text-dark"><i class="bi bi-person"></i></a>

													</form>
													<span class="name-text">${u.nombre}</span>
												</div>
											</td>

											<td class="name-text">${u.apellidoPaterno} ${u.apellidoMaterno}</td>
											<td class="dni-text">${u.dni}</td>
											<td class="email-text">${u.correo}</td>
											<td class="table-cell"><span class="zone-text">${u.zona.nombre} / ${u.distrito.nombre}</span></td>
											<td>
												<div class="status-container ${u.estado == 'activo' ? 'status-active' : 'status-banned'}">
													<span class="status-dot"></span>
													<span class="status-text">${u.estado == 'activo' ? 'ACTIVO' : 'BANEADO'}</span>
												</div>
											</td>
											<td>
												<c:if test="${u.estado == 'activo'}">
													<div class="form-action-group">
														<span class="action-text">ASIGNAR</span>
														<form method="get" action="CoordinadorServlet" class="m-0">
															<input type="hidden" name="action" value="asignarFormulario"/>
															<input type="hidden" name="id" value="${u.usuarioId}"/>
															<input type="hidden" name="zonaId" value="${zonaSeleccionada}"/>
															<input type="hidden" name="distritoId" value="${distritoSeleccionado}"/>
															<button type="submit" class="btn icon-only-button btn-assign-icon" title="Asignar Formulario">
																<i data-feather="file-text"></i>
															</button>
														</form>
													</div>
												</c:if>
											</td>
											<td>
												<div class="ban-action-group">
													<span class="action-text">${u.estado == 'activo' ? 'BANEAR' : 'ACTIVAR'}</span>

													<form method="post" action="CoordinadorServlet" class="m-0">
														<input type="hidden" name="action" value="estado"/>
														<input type="hidden" name="id" value="${u.usuarioId}"/>
														<input type="hidden" name="estado" value="${u.estado}"/>
														<input type="hidden" name="zonaId" value="${zonaSeleccionada}"/>
														<input type="hidden" name="distritoId" value="${distritoSeleccionado}"/>
														<input type="hidden" name="page" value="${paginaActual}"/>

														<button type="submit"
																onclick="return confirm('¿Está seguro de ${u.estado == 'activo' ? 'banear' : 'activar'} al encuestador(a) ${u.nombre} ${u.apellidoPaterno} ${u.apellidoMaterno}?');"
																class="btn icon-only-button ${u.estado == 'activo' ? 'btn-ban-icon' : 'btn-activate-icon'}"
																title="${u.estado == 'activo' ? 'Banear Encuestador' : 'Activar Encuestador'}">
															<i data-feather="${u.estado == 'activo' ? 'slash' : 'check-circle'}"></i>
														</button>
													</form>
												</div>
											</td>

										</tr>
									</c:forEach>

								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
					</div>

					<!-- PAGINACIÓN VISUAL MEJORADA -->
					<c:if test="${not empty totalPaginas and not empty listaEncuestadores}">
						<div class="d-flex flex-column justify-content-center align-items-center mt-4">
							<nav aria-label="Paginación">
								<ul class="pagination justify-content-center py-4">
									<c:set var="accionPaginacion" value="${empty distritoSeleccionado ? 'lista' : 'filtrar'}"/>
									<li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
										<a class="page-link"
										   href="CoordinadorServlet?action=${accionPaginacion}&page=${paginaActual - 1}<c:if test='${not empty distritoSeleccionado}'>&distritoId=${distritoSeleccionado}</c:if>">
											Anterior
										</a>
									</li>
									<c:forEach begin="1" end="${totalPaginas}" var="i">
										<li class="page-item ${i == paginaActual ? 'active' : ''}">
											<a class="page-link"
											   href="CoordinadorServlet?action=${accionPaginacion}&page=${i}<c:if test='${not empty distritoSeleccionado}'>&distritoId=${distritoSeleccionado}</c:if>">
													${i}
											</a>
										</li>
									</c:forEach>
									<li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
										<a class="page-link"
										   href="CoordinadorServlet?action=${accionPaginacion}&page=${paginaActual + 1}<c:if test='${not empty distritoSeleccionado}'>&distritoId=${distritoSeleccionado}</c:if>">
											Siguiente
										</a>
									</li>
								</ul>
							</nav>
						</div>
					</c:if>
				</div>
				<%------------------------------%>
			</div>
		</main>

		<jsp:include page="../includes/footer.jsp"/>
	</div>
</div>


<%-- Contenedor para las notificaciones toast --%>
<div id="toastContainer"></div>

<%-- Plantilla para la notificación toast --%>
<template id="toastTemplate">
	<div class="custom-toast" role="alert" aria-live="assertive" aria-atomic="true" style="display: none;">
		<div class="toast-body">
			<p class="toast-message"></p>
			<div class="toast-buttons">
				<button type="button" class="btn toast-cancel-btn">Cerrar</button>
				<button type="button" class="btn toast-confirm-btn">Confirmar</button>
			</div>
		</div>
	</div>
</template>


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

		// Lógica para mostrar la notificación toast
		const toastContainer = document.getElementById('toastContainer');
		const toastTemplate = document.getElementById('toastTemplate');

		function showCustomToast(message, actionType, formToSubmit) {
			// Si ya hay un toast, lo ocultamos y removemos para mostrar el nuevo
			const existingToast = toastContainer.querySelector('.custom-toast');
			if (existingToast) {
				hideToast(existingToast, () => {
					createAndShowNewToast(message, actionType, formToSubmit);
				});
			} else {
				createAndShowNewToast(message, actionType, formToSubmit);
			}
		}

		function createAndShowNewToast(message, actionType, formToSubmit) {
			const clone = toastTemplate.content.cloneNode(true);
			const toastElement = clone.querySelector('.custom-toast');
			const toastMessage = toastElement.querySelector('.toast-message');
			const confirmBtn = toastElement.querySelector('.toast-confirm-btn');
			const cancelBtn = toastElement.querySelector('.toast-cancel-btn');

			toastMessage.innerHTML = message; // Usar innerHTML para permitir etiquetas como <strong>

			// Ajustar texto y estilos del botón de confirmación según la acción
			if (actionType === 'banear') {
				confirmBtn.textContent = 'Suspender';
				confirmBtn.style.backgroundColor = '#dc3545';
				confirmBtn.style.borderColor = '#dc3545';
			} else if (actionType === 'activar') {
				confirmBtn.textContent = 'Activar';
				confirmBtn.style.backgroundColor = '#28a745';
				confirmBtn.style.borderColor = '#28a745';
			}

			// Event listeners para los botones del toast
			confirmBtn.onclick = () => {
				formToSubmit.submit(); // Enviar el formulario original
				hideToast(toastElement);
			};

			cancelBtn.onclick = () => {
				hideToast(toastElement);
			};

			toastContainer.appendChild(toastElement);
			// Mostrar el toast después de que se ha añadido al DOM
			setTimeout(() => {
				toastElement.style.display = 'flex'; // Usar flex para la alineación
			}, 10); // Pequeño retraso para asegurar que la animación se dispare
		}

		function hideToast(toastElement, callback) {
			toastElement.classList.add('hide-animation');
			toastElement.addEventListener('animationend', function() {
				toastElement.remove();
				if (callback) callback();
			}, { once: true });
		}

		// Delegación de eventos para los botones de la tabla
		document.querySelectorAll('.confirm-action-btn').forEach(button => {
			button.addEventListener('click', function (event) {
				event.preventDefault(); // Prevenir el envío inmediato del formulario
				const form = this.closest('form');
				const surveyorName = form.dataset.surveyorName;
				const actionType = form.dataset.action;

				let message = '';
				if (actionType === 'banear') {
					message = `¿Estás completamente seguro de que deseas <strong>suspender</strong> al encuestador(a) <span class="fw-bold">${surveyorName}</span>? Esta acción restringirá su acceso.`;
				} else if (actionType === 'activar') {
					message = `¿Confirmas que deseas <strong>reactivar</strong> al encuestador(a) <span class="fw-bold">${surveyorName}</span>? Esto le permitirá volver a acceder al sistema.`;
				}
				showCustomToast(message, actionType, form);
			});
		});
	});
</script>

<script>
	function reiniciarPagina(form) {
		const pageInput = document.createElement("input");
		pageInput.setAttribute("type", "hidden");
		pageInput.setAttribute("name", "page");
		pageInput.setAttribute("value", "1");
		form.appendChild(pageInput);
		form.submit();
	}
</script>

</body>
</html>
