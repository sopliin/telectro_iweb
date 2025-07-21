<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
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
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/onu_mujeres/static/img/icons/icon-48x48.png" />
	<link rel="canonical" href="https://demo-basic.adminkit.io/" />
	<link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

	<title>Perfil de Encuestador - Coordinador</title>

	<style>
		body {
			font-family: 'Inter', sans-serif;
			background: linear-gradient(120deg, #f8fafc 0%, #e9ecef 100%);
		}

		.user-info-container .text-dark {
			font-weight: 700;
			color: #344767 !important;
			font-size: 1.05em;
		}
		.user-info-container .text-muted {
			font-size: 0.8em;
			text-transform: uppercase;
			color: #6c757d !important;
			letter-spacing: 0.04em;
		}

		/* Cabecera del perfil */
		.profile-header {
			display: flex;
			align-items: center;
			gap: 28px;
			margin-bottom: 36px;
			padding: 32px 24px 24px 24px;
			/*background: linear-gradient(195deg, #42424a, #191919) !important; !* Fondo oscuro elegante *!*/
			background: linear-gradient(7deg, #16244a, #191919) !important;
			color: rgba(255, 255, 255, 0.8) !important;
			border-radius: 1.2rem 1.2rem 0 0;
			/*box-shadow: 0 4px 16px rgba(0,123,255,0.08);*/
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

		/* Card principal */
		.card {
			border-radius: 1.2rem;
			box-shadow: 0 1.5rem 2.5rem rgba(0, 123, 255, 0.08), 0 0.5rem 1rem rgba(52,71,103,0.06);
			border: none;
			background: #fff;
			margin-top: -30px;
		}
		.card-header {
			background: linear-gradient(195deg, #16244a, #191919) !important;
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
			/*color: #222e3c;*/
			font-size: 0.93em;
		}
		.table-bordered tr:nth-child(even) td {
			background: #f0f4fa;
		}
		.table-bordered tr:hover td {
			background: #e3eafc;
			transition: background 0.2s;
		}

		/* Badge de estado */
		.badge {
			padding: 0.6em 1.1em;
			border-radius: 0.7rem;
			font-size: 0.92em;
			font-weight: 700;
			text-transform: uppercase;
			/*box-shadow: 0 2px 8px rgba(0,123,255,0.08);*/
			letter-spacing: 0.04em;
		}
		.bg-success {
			background: #28a745 !important;
			background: linear-gradient(195deg, #12830b 0%, #15830b 100%) !important;
			color: #fff !important;
		}
		.bg-danger {
			background: linear-gradient(195deg, #dc3545 0%, #dc3555 100%) !important;
			color: #fff !important;
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

		/* Footer */
		.footer {
			background: #f8fafc;
			border-top: 1px solid #e9ecef;
			padding: 1.2rem 0 0.7rem 0;
			font-size: 0.98em;
			color: #6c757d;
		}
		.footer a.text-muted:hover {
			color: #007bff !important;
			text-decoration: underline;
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
					Perfil
				</li>
				<li class="sidebar-item active">
					<a class="sidebar-link" href="CoordinadorServlet?action=verPerfil">
						<i class="align-middle" data-feather="user"></i> <span class="align-middle">Perfil del Coordinador</span>
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
				<div class="profile-header">
					<h1><i class="align-middle me-2" data-feather="user" style="width:42px;height:42px;stroke-width:2.5px"></i> Perfil del Encuestador</h1>
				</div>

				<div class="card shadow-sm">
					<div class="card-body">
						<h5 class="card-title mb-4"><i class="align-middle me-2" data-feather="info"></i> Detalles del Encuestador</h5>
						<table class="table table-bordered mb-0">
							<tr>
								<th><i class="align-middle me-1" data-feather="user"></i> Nombre</th>
								<td class="text-uppercase">${encuestador.nombre}</td>
							</tr>
							<tr>
								<th><i class="align-middle me-1" data-feather="users"></i> Apellidos</th>
								<td class="text-uppercase">${encuestador.apellidoPaterno} ${encuestador.apellidoMaterno}</td>
							</tr>
							<tr>
								<th><i class="align-middle me-1" data-feather="credit-card"></i> DNI</th>
								<td>${encuestador.dni}</td>
							</tr>
							<tr>
								<th><i class="align-middle me-1" data-feather="mail"></i> Email</th>
								<td style="font-style: italic">${encuestador.correo}</td>
							</tr>
							<tr>
								<th><i class="align-middle me-1" data-feather="map-pin"></i> Zona / Distrito</th>
								<td class="text-uppercase">${encuestador.zona.nombre} / ${encuestador.distrito.nombre}</td>
							</tr>
							<tr>
								<th><i class="align-middle me-1" data-feather="activity"></i> Estado</th>
								<td>
									<span class="badge ${encuestador.estado == 'activo' ? 'bg-success' : 'bg-danger'}">
										<i class="align-middle me-1" data-feather="${encuestador.estado == 'activo' ? 'check-circle' : 'x-circle'}"></i>
										${encuestador.estado}
									</span>
								</td>
							</tr>
<%--							<tr>--%>
<%--								<th><i class="align-middle me-1" data-feather="clock"></i> Última Conexión</th>--%>
<%--								<td>--%>
<%--									<c:choose>--%>
<%--										<c:when test="${not empty ultimaConexion}">--%>
<%--											<fmt:formatDate value="${ultimaConexion}" pattern="yyyy-MM-dd HH:mm:ss"/>--%>
<%--										</c:when>--%>
<%--										<c:otherwise>--%>
<%--											<em>No se ha conectado aún</em>--%>
<%--										</c:otherwise>--%>
<%--									</c:choose>--%>
<%--								</td>--%>
<%--							</tr>--%>
						</table>
						<div class="mt-4 text-end">
							<a href="CoordinadorServlet?action=lista" class="btn btn-secondary"><i class="align-middle me-1" data-feather="arrow-left"></i> Volver a la lista</a>
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
	});
</script>
</body>
</html>
