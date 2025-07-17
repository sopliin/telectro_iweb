<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<%Usuario user = (Usuario) session.getAttribute("usuario");%>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
	<meta name="author" content="AdminKit">
	<meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">

	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link rel="shortcut icon" href="<%=request.getContextPath()%>/img/icons/icon-48x48.png" />

	<link rel="canonical" href="https://demo-basic.adminkit.io/" />

	<link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" type="text/css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
	<title>Perfil de Usuario - ONU Mujeres</title>
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

		.nombre {
			font-weight: bold;
		}

		.rol {
			font-size: 0.9em;
			color: #888;
		}
		/* Cabecera del perfil */
		.profile-header {
			display: flex;
			align-items: center;
			gap: 28px;
			margin-bottom: 36px;
			padding: 32px 24px 24px 24px;
			background: rgba(34,46,60,0.95) !important;
			color: rgba(255, 255, 255, 0.8) !important;
			border-radius: 1.2rem 1.2rem 0 0;
		}
		.profile-header img {
			width: 110px;
			height: 110px;
			border-radius: 50%;
			object-fit: cover;
			border: 4px solid #fff;
			box-shadow: 0 4px 16px rgba(0,123,255,0.15);
			background: #e9ecef;
		}
		.profile-header h1 {
			margin: 0;
			font-size: 2.2rem;
			color: #fff;
			font-weight: 700;
			text-shadow: 0 2px 8px rgba(0,0,0,0.08);
		}

		.profile-photo {
			width: 160px;
			height: 160px;
			border: 4px solid #e3eafc;
			border-radius: 50%;
			object-fit: cover;
			box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
			margin: 0 auto 1.5rem auto;
			display: block;
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
		/* Badge de estado */
		.badge {
			padding: 0.6em 1.1em;
			border-radius: 0.7rem;
			font-size: 0.92em;
			font-weight: 700;
			text-transform: uppercase;
			letter-spacing: 0.04em;
		}
		/* Tabla de detalles */
		.table-bordered {
			border-radius: 0.7rem;
			overflow: hidden;
			background: #f8fafc;
		}
		.table-bordered th, .table-bordered td {
			border-color: #e9ecef;
			padding: 1.05rem 1.5rem;
			font-family: 'Inter', sans-serif;
			vertical-align: middle;
		}
		.table-bordered th {
			width: 35%;
			background: #e3eafc;
			color: #222e3c;
			font-weight: 700;
			text-transform: uppercase;
			font-size: 0.93em;
			letter-spacing: 0.04em;
			border-right: 2px solid #e9ecef;
		}
		.table-bordered td {
			font-weight: 500;
			font-size: 0.93em;
		}
		.table-bordered tr:nth-child(even) td {
			background: #f0f4fa;
		}
		.table-bordered tr:hover td {
			background: #e3eafc;
			transition: background 0.2s;
		}
		/* Estilos para botones compactos */
		.btn-sm {
			padding: 0.5rem 1rem !important;
			font-size: 0.875rem !important;
			border-radius: 0.5rem !important;
		}
		/* Card principal */
		.card {
			border-radius: 1.2rem;
			box-shadow: 0 1.5rem 2.5rem rgba(0, 123, 255, 0.08), 0 0.5rem 1rem rgba(52,71,103,0.06);
			border: none;
			background: #fff;
			margin-top: -30px;
			margin-bottom: 30px;
		}
		.card-header {
			background: #222e3c;
			border-bottom: 1px solid #e9ecef;
			padding: 1.7rem 1.5rem 1.2rem 1.5rem;
			border-radius: 1.2rem 1.2rem 0 0;
		}
		.card-title {
			font-size: 1.35rem;
			font-weight: 700;
			color: #222e3c;
			letter-spacing: 0.01em;
		}
		.card-body {
			padding: 2rem 1.7rem 1.7rem 1.7rem;
		}

		/* Estilos para los botones de acciones */
		.btn-primary {
			background: linear-gradient(195deg, #4a8cff, #0062ff) !important;
			border: none;
			transition: all 0.3s ease;
			border-radius: 0.7rem;
			padding: 0.7rem 1.5rem;
			font-weight: 600;
		}

		.btn-primary:hover {
			transform: translateY(-2px);
			box-shadow: 0 4px 12px rgba(0, 98, 255, 0.25);
		}

		.btn-outline-primary {
			border: 2px solid #0062ff;
			color: #0062ff;
			background: transparent !important;
			transition: all 0.3s ease;
			border-radius: 0.7rem;
			padding: 0.7rem 1.5rem;
			font-weight: 600;
		}

		.btn-outline-primary:hover {
			background: rgba(0, 98, 255, 0.1) !important;
			transform: translateY(-2px);
		}
		/* Contenedor de botones más estrecho */
		.actions-container {
			width: 80%;
			max-width: 220px;
			margin: 0 auto;
		}
		/* Ajuste para móviles */
		@media (max-width: 768px) {
			.profile-header {
				flex-direction: column;
				text-align: center;
				gap: 16px;
				padding: 24px 16px;
			}

			.profile-header h1 {
				font-size: 1.8rem;
			}

			.card-body {
				padding: 1.5rem 1rem;
			}

			.table-bordered th,
			.table-bordered td {
				padding: 0.75rem 1rem;
				font-size: 0.85em;
			}

			.table-bordered th {
				width: 40%;
				font-size: 0.82em;
			}

			.profile-photo {
				width: 120px !important;
				height: 120px !important;
				margin-bottom: 1rem !important;
			}

			.actions-container {
				width: 100%;
				max-width: 100%;
			}

			.btn-sm {
				padding: 0.4rem 0.8rem !important;
				font-size: 0.8rem !important;
			}

			/* Cambiar a disposición vertical en móviles */
			.row {
				flex-direction: column-reverse;
			}

			.col-md-4 {
				margin-bottom: 1.5rem;
			}

			/* Ajustar márgenes en móviles */
			.container-fluid {
				padding-left: 15px;
				padding-right: 15px;
			}
		}
		@media (max-width: 992px) {
			.profile-photo {
				width: 140px;
				height: 140px;
			}
		}

		/* Ajustes adicionales para pantallas muy pequeñas */
		@media (max-width: 576px) {
			.profile-header h1 {
				font-size: 1.5rem;
			}

			.table-bordered th,
			.table-bordered td {
				padding: 0.6rem 0.8rem;
				font-size: 0.8em;
			}

			.badge {
				padding: 0.4em 0.8em;
				font-size: 0.8em;
			}
		}

		/* Mejor alineación de íconos */
		.position-absolute.start-0.ms-3 {
			left: 1rem !important;
		}
		/* Ajuste de íconos en botones */
		.btn i {
			width: 18px;
			height: 18px;
		}

		/* Ajuste para móviles */
		@media (max-width: 768px) {
			/* ... (otros estilos móviles permanecen igual) ... */

			/* Nuevos estilos para el contenedor de la foto */
			.col-md-4.order-md-2 {
				padding-top: 1.5rem; /* Espacio adicional arriba */
				margin-bottom: 1.5rem; /* Espacio adicional abajo */
				background: #f8f9fa; /* Fondo sutil para distinguir la sección */
				border-radius: 1rem;
				padding-bottom: 1rem;
				box-shadow: 0 2px 8px rgba(0,0,0,0.05);
			}

			.profile-photo {
				width: 30vw;  /* 30% del ancho de la pantalla */
				height: 30vw;
				max-width: 140px; /* Límite máximo */
				max-height: 140px;
				min-width: 120px; /* Límite mínimo */
				min-height: 120px;
				margin-bottom: 1.5rem;
			}
			/* Ajustar el espacio entre la foto y los botones */
			.d-flex.flex-column.align-items-center {
				gap: 1rem;
			}

			/* Ajustar margen superior del contenedor de datos */
			.col-md-4.order-md-2 {
				padding: 1.5rem;
				margin-bottom: 1.5rem;
			}
		}
		.profile-photo-container {
			display: flex;
			justify-content: center;
			margin-bottom: 1.5rem;
		}

		/* Ajustes adicionales para pantallas muy pequeñas */
		@media (max-width: 576px) {
			/* ... (otros estilos para pantallas pequeñas permanecen igual) ... */

			.col-md-4.order-md-2 {
				padding-top: 1.2rem;
				margin-bottom: 1.2rem;
			}

			.profile-photo {
				width: 35vw;
				height: 35vw;
				min-width: 100px;
				min-height: 100px;
			}
		}
		/* Ajustar grosor y tamaño de letra en los datos */
		.table-bordered td {
			font-weight: 600 !important; /* Más grueso */
			color: #222e3c !important; /* Color más oscuro */
			font-size: 0.95em !important; /* Un poco más grande */
		}

		/* Mejorar visibilidad de los botones */
		.btn-outline-primary {
			background: rgba(0, 98, 255, 0.05) !important; /* Fondo sutil */
			border: 2px solid #0062ff !important;
			color: #0062ff !important;
			transition: all 0.3s ease;
			border-radius: 0.7rem;
			padding: 0.7rem 1.5rem;
			font-weight: 600;
		}

		.btn-outline-primary:hover {
			background: rgba(0, 98, 255, 0.15) !important;
			transform: translateY(-2px);
			box-shadow: 0 4px 8px rgba(0, 98, 255, 0.1);
		}

		/* Ajustar tamaño del icono en el encabezado */
		.profile-header h1 i {
			width: 36px !important;
			height: 36px !important;
			margin-right: 12px !important;
			vertical-align: middle;
		}

		/* Ajustes específicos para móviles */
		@media (max-width: 768px) {
			.table-bordered td {
				font-size: 0.9em !important;
			}

			.btn-outline-primary {
				padding: 0.6rem 1.2rem !important;
			}

			.profile-header h1 i {
				width: 28px !important;
				height: 28px !important;
				margin-right: 8px !important;
			}
		}

		@media (max-width: 576px) {
			.table-bordered td {
				font-size: 0.85em !important;
			}

			.btn-outline-primary {
				padding: 0.5rem 1rem !important;
				font-size: 0.85rem !important;
			}
		}
		/* Icono de usuario en el encabezado - TAMAÑO AUMENTADO */
		.profile-header h1 i {
			width: 42px !important;  /* Tamaño significativamente mayor */
			height: 42px !important;
			margin-right: 15px !important;
			vertical-align: middle;
			stroke-width: 2px; /* Hacer el trazo más grueso */
		}
		.btn-outline-primary, .btn-secondary {
			border-radius: 0.7rem;
			padding: 0.7rem 1rem; /* Reducir padding horizontal */
			font-weight: 600;
			text-align: center;
			transition: all 0.3s ease;
			width: 100%; /* Ocupar todo el ancho disponible */
			max-width: 220px; /* Ancho máximo para escritorio */
			margin: 0 auto 0.5rem; /* Centrar y espacio entre botones */
			display: block; /* Hacer que ocupen su propia línea */
		}

		/* Contenedor de botones */
		.action-buttons {
			display: flex;
			flex-direction: column;
			gap: 0.8rem; /* Espacio entre botones */
			width: 100%;
			max-width: 220px; /* Mismo máximo que los botones */
			margin: 0 auto; /* Centrar el contenedor */
		}

		/* Botones con fondo claro VISIBLE */
		.btn-outline-primary {
			background: rgba(0, 98, 255, 0.1) !important; /* Fondo más visible */
			border: 2px solid #0062ff !important;
			color: #0062ff !important;
			transition: all 0.3s ease;
			border-radius: 0.7rem;
			padding: 0.7rem 1.5rem;
			font-weight: 600;
			box-shadow: 0 2px 4px rgba(0, 98, 255, 0.1); /* Sombra sutil */
		}

		.btn-outline-primary:hover {
			background: rgba(0, 98, 255, 0.2) !important; /* Fondo más oscuro al pasar mouse */
			transform: translateY(-2px);
			box-shadow: 0 4px 8px rgba(0, 98, 255, 0.15);
		}

		/* Ajustes para móviles */
		@media (max-width: 768px) {
			.profile-header h1 i {
				width: 36px !important;
				height: 36px !important;
				margin-right: 12px !important;
			}

			.btn-outline-primary {
				background: rgba(0, 98, 255, 0.15) !important; /* Fondo aún más visible en móviles */
				padding: 0.75rem 1.25rem !important;
			}
			.btn-outline-primary, .btn-secondary {
				padding: 0.6rem 0.8rem; /* Padding más ajustado */
				font-size: 0.9rem; /* Tamaño de fuente ligeramente menor */
				max-width: 180px; /* Ancho máximo reducido */
			}

			.action-buttons {
				max-width: 180px; /* Reducir contenedor también */
				gap: 0.6rem; /* Menor espacio entre botones */
			}
		}

		@media (max-width: 576px) {
			.profile-header h1 i {
				width: 32px !important;
				height: 32px !important;
			}

			.btn-outline-primary {
				padding: 0.65rem 1.15rem !important;
			}
			.btn-outline-primary, .btn-secondary {
				padding: 0.5rem 0.7rem;
				font-size: 0.85rem;
				max-width: 160px; /* Aún más estrecho */
			}

			.action-buttons {
				max-width: 160px;
			}
		}
		.profile-header h1 i[data-feather="user"] {
			width: 42px !important;
			height: 42px !important;
			stroke-width: 2.5px !important;
			margin-right: 12px !important;
			vertical-align: middle;
		}

		/* Asegurar que Feather Icons aplique el tamaño */
		[data-feather] {
			width: inherit !important;
			height: inherit !important;
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
			<a class="sidebar-brand" href="EncuestadorServlet?action=total">
				<span class="align-middle">ONU Mujeres</span>
			</a>
			<ul class="sidebar-nav">
				<li class="sidebar-header">Encuestas</li>
				<li class="sidebar-item">
					<a class="sidebar-link" href="EncuestadorServlet?action=total">
						<i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestas totales</span>
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
				<li class="sidebar-header">
					Perfil
				</li>
				<li class="sidebar-item active">
					<a class="sidebar-link" href="EncuestadorServlet?action=ver">
						<i class="align-middle" data-feather="user"></i> <span class="align-middle">Mi Perfil</span>
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
						<a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
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
							<a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
							<div class="dropdown-divider"></div>
							<a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
						</div>
					</li>
				</ul>
			</div>
		</nav>

		<main class="content">
			<div class="container-fluid p-0">
				<div class="profile-header">
					<h1><i class="align-middle me-2" data-feather="user" style="width:42px;height:42px;stroke-width:2.5px"></i> Perfil de Encuestador</h1>
				</div>

				<div class="card shadow-sm">
					<div class="card-body">
						<div class="row">
							<!-- En móviles, la foto aparece primero (columna arriba) -->
							<div class="col-md-4 order-md-2">
								<div class="d-flex flex-column align-items-center">
									<!-- Foto de perfil -->
									<div class="profile-photo-container">
									<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>"
										 class="profile-photo mb-3" alt="Foto de perfil">
								</div>
									<!-- Botones de acciones -->
									<div class="d-flex flex-column align-items-center w-100">
										<ul class="list-unstyled mb-0 w-100">
											<li class="mb-2">
												<a href="EncuestadorServlet?action=cambiarContrasena"
												   class="btn btn-outline-primary w-100 btn-sm py-2">
													<i class="me-2" data-feather="lock"></i>
													Cambiar contraseña
												</a>
											</li>
											<li class="mb-2">
												<a href="EncuestadorServlet?action=editarPerfil"
												   class="btn btn-outline-primary w-100 btn-sm py-2">
													<i class="me-2" data-feather="edit"></i>
													Editar perfil
												</a>
											</li>
											<li class="mb-2">
												<form action="EncuestadorServlet?action=uploadPhoto" method="post"
													  enctype="multipart/form-data" id="photoForm">
													<input type="file" id="photoInput" name="foto"
														   accept="image/jpeg, image/png" style="display: none;">
													<button type="button" class="btn btn-outline-primary w-100 btn-sm py-2"
															onclick="document.getElementById('photoInput').click()">
														<i class="me-2" data-feather="image"></i>
														Cambiar foto
													</button>
												</form>
											</li>
											<li>
												<a href="EncuestadorServlet"
												   class="btn btn-secondary w-100 btn-sm py-2">
													<i class="me-2" data-feather="chevrons-left"></i>
													Volver al Menú
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>

							<!-- En móviles, los datos aparecen después (columna abajo) -->
							<div class="col-md-8 order-md-1">
								<div class="table-responsive">
									<table class="table table-bordered mb-0">
										<tr>
											<th><i class="align-middle me-1" data-feather="user"></i> Nombre</th>
											<td class="text-uppercase"><%=user.getNombre()%></td>
										</tr>
										<tr>
											<th><i class="align-middle me-1" data-feather="users"></i> Apellidos</th>
											<td class="text-uppercase"><%=user.getApellidoPaterno()%> <%=user.getApellidoMaterno()%></td>
										</tr>
										<tr>
											<th><i class="align-middle me-1" data-feather="credit-card"></i> DNI</th>
											<td><%=user.getDni()%></td>
										</tr>
										<tr>
											<th><i class="align-middle me-1" data-feather="mail"></i> Email</th>
											<td style="font-style: italic"><%=user.getCorreo()%></td>
										</tr>
										<tr>
											<th><i class="align-middle me-1" data-feather="home"></i> Dirección</th>
											<td class="text-uppercase"><%=user.getDireccion()%></td>
										</tr>
										<tr>
											<th><i class="align-middle me-1" data-feather="map-pin"></i> Zona / Distrito</th>
											<td class="text-uppercase"><%=user.getZona().getNombre()%> / <%=user.getDistrito().getNombre()%></td>
										</tr>
										<tr>
											<th><i class="align-middle me-1" data-feather="activity"></i> Estado</th>
											<td><span class="badge <%=user.getEstado().equals("activo") ? "bg-success" : "bg-danger"%>"><i class="align-middle me-1" data-feather="<%=user.getEstado().equals("activo") ? "check-circle" : "x-circle"%>"></i><%=user.getEstado()%></span>
											</td>
										</tr>
									</table>
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

<script type="text/javascript" src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
<script>
	document.addEventListener('DOMContentLoaded', function() {
		// Inicializar feather icons
		feather.replace();

		// Manejar el cambio de foto
		document.getElementById('photoInput').addEventListener('change', function() {
			if(this.files.length > 0) {
				document.getElementById('photoForm').submit();
			}
		});

		<% if (session.getAttribute("photoSuccess") != null) { %>
		alert("<%= session.getAttribute("photoSuccess") %>");
		<% session.removeAttribute("photoSuccess"); %>
		<% } %>

		<% if (session.getAttribute("photoError") != null) { %>
		alert("<%= session.getAttribute("photoError") %>");
		<% session.removeAttribute("photoError"); %>
		<% } %>
	});
</script>
</body>
</html>