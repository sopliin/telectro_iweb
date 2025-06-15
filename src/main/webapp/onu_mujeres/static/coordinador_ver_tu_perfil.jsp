<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario"%>
<%
	Usuario usuario = (Usuario) session.getAttribute("usuario");
	if (usuario == null) {
		response.sendRedirect(request.getContextPath() +"/login");
		return;
	}
%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
	<meta name="author" content="AdminKit">
	<meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link rel="shortcut icon" href="img/icons/icon-48x48.png" />
	<link rel="canonical" href="https://demo-basic.adminkit.io/pages-profile.html" />
	<!-- modificado para ruta relativa al contexto -->
	<link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
	<!-- Google Fonts -->
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

	<title>Profile | AdminKit Demo</title>
</head>
<body>
<script type="text/javascript" src="js/app.js"></script>
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
			<div class="navbar-collapse collapse">
				<ul class="navbar-nav navbar-align">
					<li class="nav-item dropdown">
						<!-- esta parte falta añadir al href para que se pueda seleccionar las opciones de ver perfil y cerrar sesion-->
						<a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
							<img src="<%=request.getContextPath()%>/fotos/<%=usuario.getProfilePhotoUrl() %>" class="avatar img-fluid rounded me-1" alt="Charles Hall" /> <span class="text-dark"><%=usuario.getNombre()+" "+usuario.getApellidoPaterno() %></span>
						</a>
						<div class="dropdown-menu dropdown-menu-end">
							<a class="dropdown-item" href="CoordinadorServlet?action=verPerfil"><i class="align-middle me-1" data-feather="pie-chart"></i> Ver Perfil</a>
							<div class="dropdown-divider"></div>

							<a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
						</div>
					</li>
				</ul>
			</div>
		</nav>
		<main class="content">
			<div class="container-fluid p-0">
				<h1 class="h3 mb-3">Perfil del Coordinador</h1>
				<div class="row">
					<div class="col-md-4 col-xl-3">
						<div class="card mb-3">
							<div class="card-body text-center">
								<img src="<%=request.getContextPath()%>/fotos/<%=usuario.getProfilePhotoUrl() %>" alt="<%=usuario.getNombre()%>" class="img-fluid rounded-circle mb-2" width="128" height="128" />
								<h5 class="card-title mb-0"><%=usuario.getNombre()+" "+usuario.getApellidoPaterno()+" "+usuario.getApellidoMaterno()%></h5>
								<div class="text-muted mb-2">Rol de <%=usuario.getRol().getNombre()%></div>
							</div>
							<hr class="my-0" />
							<div class="card-body">
								<h5 class="h6 card-title">Datos personales</h5>
								<ul class="list-unstyled mb-0">
									<li><b>Correo:</b> <%= usuario.getCorreo() %></li>
									<li><b>Zona:</b> <%= usuario.getZona() != null ? usuario.getZona().getNombre() : "" %></li>
									<li><b>Distrito:</b> <%= usuario.getDistrito() != null ? usuario.getDistrito().getNombre() : "" %></li>
									<li><b>Dirección:</b> <%= usuario.getDireccion() %></li>
								</ul>
							</div>
							<hr class="my-0" />
							<div class="card-body">
								<h5 class="h6 card-title">Opciones</h5>
								<ul class="list-unstyled mb-0">
									<li class="mb-2">
										<a href="CoordinadorServlet?action=cambiarContrasena" class="btn btn-secondary w-100">Cambiar contraseña</a>
									</li>
									<li class="mb-2">
										<a href="#" class="btn btn-secondary w-100">Editar perfil</a>
									</li>
									<li class="mb-2">
										<form action="CoordinadorServlet?action=uploadPhoto" method="post" enctype="multipart/form-data" id="photoForm">
											<input type="file" id="photoInput" name="foto" accept="image/jpeg, image/png" style="display: none;">
											<button type="button" class="btn btn-secondary w-100 position-relative text-center" onclick="document.getElementById('photoInput').click()">
												<i class="position-absolute start-0 ms-3 top-50 translate-middle-y" data-feather="image"></i>
												Cambiar foto
											</button>
										</form>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="col-md-8 col-xl-9">
						<div class="card">
							<div class="card-header">
								<h5 class="card-title mb-0">Actividades Recientes</h5>
							</div>
							<div class="card-body h-100">
								<!-- Aquí puedes mostrar actividades recientes del coordinador si las tienes -->
								<p>No hay actividades recientes.</p>
							</div>
						</div>
					</div>
				</div>
				<div class="mt-4">
					<a href="CoordinadorServlet" class="btn btn-secondary">← Volver al Menú</a>
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
							<li class="list-inline-item">
								<a class="text-muted" href="https://adminkit.io/" target="_blank">Support</a>
							</li>
							<li class="list-inline-item">
								<a class="text-muted" href="https://adminkit.io/" target="_blank">Help Center</a>
							</li>
							<li class="list-inline-item">
								<a class="text-muted" href="https://adminkit.io/" target="_blank">Privacy</a>
							</li>
							<li class="list-inline-item">
								<a class="text-muted" href="https://adminkit.io/" target="_blank">Terms</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</footer>
	</div>
</div>
<script type="text/javascript" src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>
<script>
	document.addEventListener('DOMContentLoaded', function() {
		// Inicializar feather icons
		feather.replace();

		// Manejar el toggle del sidebar


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