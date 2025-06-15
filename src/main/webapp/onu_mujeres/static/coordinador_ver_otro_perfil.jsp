<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%-- Si tienes el usuario coordinador en sesión, puedes usarlo aquí --%>
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
	<link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
	<!-- Google Fonts -->
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
	<title>Perfil de Encuestador - Coordinador</title>
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
						<i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestadores de zona</span>
					</a>
				</li>
				<li class="sidebar-item">
					<a class="sidebar-link" href="CoordinadorServlet?action=listarEncuestas">
						<i class="align-middle" data-feather="users"></i> <span class="align-middle">Encuestas</span>
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
			<a class="sidebar-toggle js-sidebar-toggle"><i class="hamburger align-self-center"></i></a>
			<div class="navbar-collapse collapse">
				<ul class="navbar-nav navbar-align">
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
							<img src="<%=request.getContextPath()%>/fotos/<%=user != null ? user.getProfilePhotoUrl() : "default.png"%>" class="avatar img-fluid rounded me-1" alt="Foto" />
							<span class="text-dark"><%=user != null ? user.getNombre() + " " + user.getApellidoPaterno() : "Coordinador"%></span>
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
				<h1 class="h3 mb-3">👤 Perfil del Encuestador</h1>
				<div class="card shadow-sm">
					<div class="card-body">
						<table class="table table-bordered mb-0">
							<tr>
								<th>ID</th>
								<td>${encuestador.usuarioId}</td>
							</tr>
							<tr>
								<th>Nombre</th>
								<td>${encuestador.nombre}</td>
							</tr>
							<tr>
								<th>Apellidos</th>
								<td>${encuestador.apellidoPaterno} ${encuestador.apellidoMaterno}</td>
							</tr>
							<tr>
								<th>DNI</th>
								<td>${encuestador.dni}</td>
							</tr>
							<tr>
								<th>Email</th>
								<td>${encuestador.correo}</td>
							</tr>
							<tr>
								<th>Zona / Distrito</th>
								<td>${encuestador.zona.nombre} / ${encuestador.distrito.nombre}</td>
							</tr>
							<tr>
								<th>Estado</th>
								<td>
									<span class="badge ${encuestador.estado == 'activo' ? 'bg-success' : 'bg-danger'}">${encuestador.estado}</span>
								</td>
							</tr>
						</table>
						<div class="mt-4">
							<a href="CoordinadorServlet?action=lista" class="btn btn-secondary">← Volver a la lista</a>
						</div>
					</div>
				</div>
			</div>
		</main>
		<footer class="footer">
			<div class="container-fluid">
				<div class="row text-muted">
					<div class="col-6 text-start">
						<p class="mb-0">
							<a class="text-muted" href="https://adminkit.io/" target="_blank"><strong>AdminKit</strong></a> &copy;
						</p>
					</div>
					<div class="col-6 text-end">
						<ul class="list-inline">
							<li class="list-inline-item"><a class="text-muted" href="#">Soporte</a></li>
							<li class="list-inline-item"><a class="text-muted" href="#">Centro de Ayuda</a></li>
							<li class="list-inline-item"><a class="text-muted" href="#">Privacidad</a></li>
							<li class="list-inline-item"><a class="text-muted" href="#">Términos</a></li>
						</ul>
					</div>
				</div>
			</div>
		</footer>
	</div>
</div>
<!-- Scripts -->
<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script>
	document.addEventListener("DOMContentLoaded", function () {
		feather.replace();
	});
</script>
</body>
</html>