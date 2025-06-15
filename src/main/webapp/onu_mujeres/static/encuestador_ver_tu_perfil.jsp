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

	<link href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css" type="text/css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
	<title>Perfil de Usuario - ONU Mujeres</title>
</head>

<body>
<script type="text/javascript" src="js/app.js"></script>
<div class="wrapper">
	<nav id="sidebar" class="sidebar js-sidebar">
		<div class="sidebar-content js-simplebar">
			<a class="sidebar-brand" href="EncuestadorServlet?action=total">
				<span class="align-middle">ONU Mujeres</span>
			</a>

			<ul class="sidebar-nav">
				<li class="sidebar-header">
					Encuestas
				</li>

				<li class="sidebar-item active">
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


					<li class="nav-item dropdown">
						<a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#" data-bs-toggle="dropdown">
							<i class="align-middle" data-feather="settings"></i>
						</a>

						<a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
							<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" class="avatar img-fluid rounded me-1" alt="Charles Hall" /> <span class="text-dark"><%=user.getNombre()+" "+user.getApellidoPaterno() %>(<%=user.getRol() != null ?
								user.getRol().getNombre().substring(0, 1).toUpperCase() + user.getRol().getNombre().substring(1).toLowerCase() : ""%>)</span>
						</a>
						<div class="dropdown-menu dropdown-menu-end">
							<a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1" data-feather="eye"></i> Ver Perfil</a>
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
					<h1 class="h3 d-inline align-middle">Perfil</h1>
				</div>

				<div class="row">
					<div class="col-md-4 col-xl-3">
						<div class="card mb-3">
							<div class="card-body text-center">
								<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" alt="<%=user.getNombre()%>" class="img-fluid rounded-circle mb-2" width="128" height="128" />
								<h5 class="card-title mb-0"><%=user.getNombre()+" "+user.getApellidoPaterno()+" "+user.getApellidoMaterno()%></h5>
								<div class="text-muted mb-2"><%=user.getRol().getNombre()%></div>
							</div>

							<hr class="my-0" />
							<div class="card-body">
								<h5 class="h6 card-title">Acerca de mi</h5>
								<ul class="list-unstyled mb-0">
									<li class="mb-1"><span data-feather="home" class="feather-sm me-1"></span> Vive en <%=user.getDireccion()%></li>
									<li class="mb-1"><span data-feather="map-pin" class="feather-sm me-1"></span> Zona <%=user.getZona().getNombre()%> - <%=user.getDistrito().getNombre()%></li>
									<li class="mb-1"><span data-feather="briefcase" class="feather-sm me-1"></span> Trabaja en ONU Mujeres como <%=user.getRol().getNombre()%></li>
								</ul>
							</div>
							<hr class="my-0" />
							<div class="card-body">
								<h5 class="h6 card-title">Otras Opciones</h5>
								<ul class="list-unstyled mb-0">
									<li class="mb-2 position-relative">
										<a href="EncuestadorServlet?action=editarPerfil" class="btn btn-secondary w-100 position-relative text-center">
											<i class="position-absolute start-0 ms-3 top-50 translate-middle-y" data-feather="edit"></i>
											Editar datos personales
										</a>
									</li>
									<li class="mb-2 position-relative">
										<a href="EncuestadorServlet?action=cambiarContrasena" class="btn btn-secondary w-100 position-relative text-center">
											<i class="position-absolute start-0 ms-3 top-50 translate-middle-y" data-feather="lock"></i>
											Cambiar contraseña
										</a>
									</li>
									<li class="mb-2 position-relative">
										<form action="EncuestadorServlet?action=uploadPhoto" method="post" enctype="multipart/form-data" id="photoForm">
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
								<div class="d-flex align-items-start">
									<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" width="36" height="36" class="rounded-circle me-2" alt="Avatar">
									<div class="flex-grow-1">
										<small class="float-end text-navy">5m ago</small>
										<strong>Administrador</strong> te ha <strong>asignado tus primeras encuestas</strong><br />
										<small class="text-muted">Today 7:51 pm</small><br />
									</div>
								</div>

								<hr />
								<div class="d-flex align-items-start">
									<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" width="36" height="36" class="rounded-circle me-2" alt="Avatar">
									<div class="flex-grow-1">
										<small class="float-end text-navy">30m ago</small>
										<strong><%=user.getNombre()%></strong> has completado tus datos personales<br />
										<small class="text-muted">Today 7:21 pm</small>
									</div>
								</div>

								<hr />
								<div class="d-flex align-items-start">
									<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" width="36" height="36" class="rounded-circle me-2" alt="Avatar">
									<div class="flex-grow-1">
										<small class="float-end text-navy">1h ago</small>
										<strong><%=user.getNombre()%></strong> te has registrado como encuestador<br />
										<small class="text-muted">Today 6:35 pm</small>
									</div>
								</div>

								<hr />
								<div class="d-grid">
									<a href="#" class="btn btn-primary">Cargar más</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</main>

		<jsp:include page="../../includes/footer.jsp"/>
	</div>
</div>

<!-- Scripts al final del body -->



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