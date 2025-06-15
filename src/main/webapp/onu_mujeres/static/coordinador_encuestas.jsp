<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%Usuario user = (Usuario) session.getAttribute("usuario");%>
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
	<title> Seccion de encuestas - Coordinador</title>
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
		<nav class="navbar navbar-expand navbar-light navbar-bg">
			<a class="sidebar-toggle js-sidebar-toggle">
				<i class="hamburger align-self-center"></i>
			</a>
			<div class="navbar-collapse collapse">
				<ul class="navbar-nav navbar-align">
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
							<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>" class="avatar img-fluid rounded me-1" alt="Foto" />
							<span class="text-dark"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
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
				<!-- Filtro por carpeta -->
				<div class="mb-3">
					<form method="get" action="CoordinadorServlet" class="row g-2 align-items-center">
						<input type="hidden" name="action" value="listarEncuestas"/>
						<div class="col-auto">
							<label for="carpeta" class="col-form-label">Filtrar por carpeta:</label>
						</div>
						<div class="col-auto">
							<select name="carpeta" id="carpeta" class="form-select" onchange="this.form.submit()">
								<option value="" ${empty carpetaSeleccionada ? 'selected' : ''}>-- Seleccionar una carpeta --</option>
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
								<th>ID</th>
								<th>Nombre</th>
								<th class="d-none d-xl-table-cell">Descripción</th>
								<th>Estado</th>
								<th class="d-none d-md-table-cell">Encuestador</th>
								<th>Acciones</th>
							</tr>
							</thead>
							<tbody>
							<c:forEach var="e" items="${listaEncuestas}">
								<tr>
									<td>${e.encuestaId}</td>
									<td>${e.nombre}</td>
									<td class="d-none d-xl-table-cell">${e.descripcion}</td>
									<td>
										<span class="badge ${e.estado == 'activo' ? 'bg-success' : 'bg-danger'}">${e.estado}</span>
									</td>
									<td class="d-none d-md-table-cell">
										<c:choose>
											<c:when test="${e.estado == 'activo'}">
												<a href="CoordinadorServlet?action=filtrarAsignar&encuestaId=${e.encuestaId}&nombreEncuesta=${e.nombre}&carpeta=${carpetaSeleccionada}" class="btn btn-primary btn-sm">Asignar</a>
											</c:when>
											<c:otherwise>
												<button class="btn btn-secondary btn-sm" disabled>Asignar</button>
											</c:otherwise>
										</c:choose>
									</td>
									<td>
										<form method="post" action="CoordinadorServlet" style="display:inline;">
											<input type="hidden" name="action" value="cambiarEstadoEncuesta"/>
											<input type="hidden" name="id" value="${e.encuestaId}"/>
											<input type="hidden" name="estado" value="${e.estado}"/>
											<input type="hidden" name="carpeta" value="${carpetaSeleccionada}"/>
											<button type="submit" class="btn btn-sm ${e.estado == 'activo' ? 'btn-danger' : 'btn-success'}">
													${e.estado == 'activo' ? 'Desactivar' : 'Activar'}
											</button>
										</form>
									</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
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
<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
</body>
</html>