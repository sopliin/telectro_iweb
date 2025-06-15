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
	<link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
	<!-- Google Fonts -->
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
	<title> Seccion de encuestadores - Coordinador</title>
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
			<a class="sidebar-toggle js-sidebar-toggle"><i class="hamburger align-self-center"></i></a>
			<div class="navbar-collapse collapse">
				<ul class="navbar-nav navbar-align">
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
							<img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>" class="avatar img-fluid rounded me-1" alt="Foto" />
							<span class="text-dark"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
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
				<h1 class="h3 mb-3">Encuestadores Registrados</h1>

				<div class="row mb-3">
					<div class="col-md-4">
						<form method="get" action="CoordinadorServlet">
							<input type="hidden" name="action" value="filtrar"/>
							<label for="distritoId" class="form-label">Filtrar por distrito:</label>
							<select name="distritoId" id="distritoId" class="form-select" onchange="this.form.submit()" ${empty listaDistritos ? 'disabled' : ''}>
								<option value="">-- Seleccione un distrito --</option>
								<c:forEach var="d" items="${listaDistritos}">
									<option value="${d.distritoId}" ${d.distritoId == distritoSeleccionado ? 'selected' : ''}>${d.nombre}</option>
								</c:forEach>
							</select>
						</form>
					</div>
					<div class="col-md-8 d-flex justify-content-end align-items-end">
						<div class="input-group" style="max-width: 220px;">
    <span class="input-group-text bg-white border-end-0" style="background: transparent;">
      <i data-feather="search"></i>
    </span>
							<input type="text" id="buscadorEncuestadores" class="form-control border-start-0" placeholder="Buscar..." aria-label="Buscar">
						</div>
					</div>
				</div>

				<div class="card">
					<div class="card-header">
						<h5 class="card-title mb-0">Lista de Encuestadores</h5>
					</div>
					<div class="table-responsive">
						<table class="table table-hover my-0" id="tablaEncuestadores">
							<thead>
							<tr>
								<th>ID</th>
								<th>Nombre</th>
								<th class="d-none d-xl-table-cell">Apellidos</th>
								<th class="d-none d-xl-table-cell">DNI</th>
								<th>Email</th>
								<th class="d-none d-xl-table-cell">Zona / Distrito</th>
								<th>Estado</th>
								<th>Formulario</th>
								<th>Acciones</th>
							</tr>
							</thead>
							<tbody>
							<c:forEach var="u" items="${listaEncuestadores}">
								<tr>
									<td>${u.usuarioId}</td>
									<td>${u.nombre}</td>
									<td class="d-none d-xl-table-cell">${u.apellidoPaterno} ${u.apellidoMaterno}</td>
									<td class="d-none d-xl-table-cell">${u.dni}</td>
									<td>${u.correo}</td>
									<td class="d-none d-xl-table-cell">${u.zona.nombre} / ${u.distrito.nombre}</td>
									<td><span class="badge ${u.estado == 'activo' ? 'bg-success' : 'bg-danger'}">${u.estado}</span></td>
									<td>
										<c:if test="${u.estado == 'activo'}">
											<form method="get" action="CoordinadorServlet">
												<input type="hidden" name="action" value="asignarFormulario"/>
												<input type="hidden" name="id" value="${u.usuarioId}"/>
												<input type="hidden" name="zonaId" value="${zonaSeleccionada}"/>
												<input type="hidden" name="distritoId" value="${distritoSeleccionado}"/>
												<button type="submit" class="btn btn-primary btn-sm">Asignar</button>
											</form>
										</c:if>
									</td>
									<td>
										<div class="d-flex gap-1">
											<form method="get" action="CoordinadorServlet">
												<input type="hidden" name="action" value="verPerfilEncuestador"/>
												<input type="hidden" name="id" value="${u.usuarioId}"/>
												<input type="hidden" name="zonaId" value="${zonaSeleccionada}"/>
												<input type="hidden" name="distritoId" value="${distritoSeleccionado}"/>
												<button type="submit" class="btn btn-info btn-sm text-white">Perfil</button>
											</form>
											<form method="post" action="CoordinadorServlet">
												<input type="hidden" name="action" value="estado"/>
												<input type="hidden" name="id" value="${u.usuarioId}"/>
												<input type="hidden" name="estado" value="${u.estado}"/>
												<input type="hidden" name="zonaId" value="${zonaSeleccionada}"/>
												<input type="hidden" name="distritoId" value="${distritoSeleccionado}"/>
												<button type="submit" class="btn btn-${u.estado == 'activo' ? 'danger' : 'success'} btn-sm">
														${u.estado == 'activo' ? 'Banear' : 'Activar'}
												</button>
											</form>
										</div>
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

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
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
	});
</script>
</body>
</html>
