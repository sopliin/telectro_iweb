<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario"%>
<%@ page import="org.example.onu_mujeres_crud.beans.EncuestaAsignada" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
	<link rel="shortcut icon" href="img/icons/icon-48x48.png" />

	<link rel="canonical" href="https://demo-basic.adminkit.io/" />
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

			.pagination-container {
				display: flex;
				justify-content: center; /* Cambiado de space-between a center */
				align-items: center;
				margin-top: 20px;
				width: 100%; /* Asegura que ocupe todo el ancho */
			}

			.page-size-selector {
				width: 80px;
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
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
	<title>AdminKit Demo - Bootstrap 5 Admin Template</title>

	<link href="css/app.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>

<body>
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
					<li class="sidebar-item active">
						<a class="sidebar-link" href="EncuestadorServlet?action=pendientes">
							<i class="align-middle" data-feather="edit-3"></i> <span class="align-middle">Encuestas por hacer</span>
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
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle">Encuestas asignadas</h1>
					</div>

					<div class="row mb-3">
						<div class="col-md-3">
							<%
								// Manejo de parámetros con valores por defecto
								String action = request.getParameter("action") != null ? request.getParameter("action") : "total";
								int pageNumber = 1;
								int pageSize = 10;
								try {
									pageNumber = Integer.parseInt(request.getParameter("page"));
								} catch (NumberFormatException e) {
									pageNumber = 1;
								}
								try {
									pageSize = Integer.parseInt(request.getParameter("pageSize"));
								} catch (NumberFormatException e) {
									pageSize = 10;
								}
							%>
							<form id="pageSizeForm" method="get" action="EncuestadorServlet">
								<input type="hidden" name="action" value="<%= action %>">
								<input type="hidden" name="page" value="1"> <!-- Resetear a página 1 al cambiar tamaño -->
								<div class="col-auto">
									<label class="col-form-label">Registros por página:</label>
								</div>
								<div class="input-group">
									<select class="form-select page-size-selector" name="pageSize" onchange="this.form.submit()">
										<option value="5" <%= pageSize == 5 ? "selected" : "" %>>5 por página</option>
										<option value="10" <%= pageSize == 10 ? "selected" : "" %>>10 por página</option>
										<option value="20" <%= pageSize == 20 ? "selected" : "" %>>20 por página</option>
										<option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 por página</option>
									</select>
								</div>
							</form>
						</div>
					</div>

					<div class="row">
						<div class="col-12 d-flex">
							<div class="card flex-fill">

								<div class="table-responsive">
								<table class="table table-hover my-0">
									<thead>
										<tr>

											<th>Nombre de Encuesta</th>
											<th >Descripción</th>
											<th>Acciones</th>
											<th class="d-md-table-cell">Fecha de asignación</th>
										</tr>
									</thead>
									<tbody>
									<%
										List<EncuestaAsignada> listaEncuestas = (List<EncuestaAsignada>) request.getAttribute("listaEncuestas");
										if (listaEncuestas != null && !listaEncuestas.isEmpty()) {
											List<EncuestaAsignada> encuestasActivas = new ArrayList<>();

											// Filtra encuestas activas y pendientes
											for (EncuestaAsignada encuesta : listaEncuestas) {
												if (encuesta.getEncuesta().getEstado() != null &&
														encuesta.getEncuesta().getEstado().equalsIgnoreCase("activo") &&
														!"completada".equalsIgnoreCase(encuesta.getEstado()) &&
														!"en_progreso".equalsIgnoreCase(encuesta.getEstado()))
												{
													encuestasActivas.add(encuesta);
												}
											}

											if (!encuestasActivas.isEmpty()) {
												for (EncuestaAsignada encuesta : encuestasActivas) {
													String nombreEncuesta = encuesta.getEncuesta() != null ? encuesta.getEncuesta().getNombre() : "N/A";
									%>
									<tr>

										<td ><%= nombreEncuesta %></td>
										<td ><button class="btn btn-sm btn-info" title="Ver detalles" onclick="verDetalles(<%= encuesta.getEncuesta().getEncuestaId() %>)">
											<i class="bi bi-eye"></i>
										</button>
										</td></td>
										<td>
											<a href="<%= request.getContextPath() %>/ContenidoEncuestaServlet?action=mostrar&asignacionId=<%= encuesta.getAsignacionId() %>">
												<i class="align-middle" data-feather="edit-2"></i>
											</a>
										</td>
										<td class="d-md-table-cell">
											<%= encuesta.getFechaAsignacion() != null
													? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss")
													.format(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
															.parse(encuesta.getFechaAsignacion()))
													: "N/A" %>
										</td>
									</tr>
									<%
										}
									} else {
									%>
									<tr>
										<td colspan="4" class="text-center">No tienes encuestas pendientes activas.</td>
									</tr>
									<%
										}
									} else {
									%>
									<tr>
										<td colspan="4" class="text-center">No hay encuestas pendientes.</td>
									</tr>
									<%
										}
									%>
										
									</tbody>
								</table>
								</div>

								<!-- Paginación -->
								<div class="pagination-container">
									<%
										int totalCount = (Integer) request.getAttribute("totalCount");
										int startItem = (pageNumber - 1) * pageSize + 1;
										int endItem = Math.min(pageNumber * pageSize, totalCount);
									%>


									<nav aria-label="Page navigation">
										<ul class="pagination">
											<li class="page-item <%= pageNumber <= 1 ? "disabled" : "" %>">
												<a class="page-link" href="EncuestadorServlet?action=<%= action %>&page=<%= pageNumber - 1 %>&pageSize=<%= pageSize %>">Anterior</a>
											</li>

											<%
												int totalPages = (int) Math.ceil((double) totalCount / pageSize);
												int startPage = Math.max(1, pageNumber - 2);
												int endPage = Math.min(totalPages, pageNumber + 2);

												if (startPage > 1) {
											%>
											<li class="page-item">
												<a class="page-link" href="EncuestadorServlet?action=<%= action %>&page=1&pageSize=<%= pageSize %>">1</a>
											</li>
											<% if (startPage > 2) { %>
											<li class="page-item disabled">
												<span class="page-link">...</span>
											</li>
											<% } %>
											<% } %>

											<% for (int i = startPage; i <= endPage; i++) { %>
											<li class="page-item <%= i == pageNumber ? "active" : "" %>">
												<a class="page-link" href="EncuestadorServlet?action=<%= action %>&page=<%= i %>&pageSize=<%= pageSize %>"><%= i %></a>
											</li>
											<% } %>

											<% if (endPage < totalPages) { %>
											<% if (endPage < totalPages - 1) { %>
											<li class="page-item disabled">
												<span class="page-link">...</span>
											</li>
											<% } %>
											<li class="page-item">
												<a class="page-link" href="EncuestadorServlet?action=<%= action %>&page=<%= totalPages %>&pageSize=<%= pageSize %>"><%= totalPages %></a>
											</li>
											<% } %>

											<li class="page-item <%= pageNumber >= totalPages ? "disabled" : "" %>">
												<a class="page-link" href="EncuestadorServlet?action=<%= action %>&page=<%= pageNumber + 1 %>&pageSize=<%= pageSize %>">Siguiente</a>
											</li>
										</ul>
									</nav>
								</div>


							</div>
						</div>
					</div>

				</div>
			</main>

			<jsp:include page="../includes/footer.jsp"/>
		</div>
	</div>
	<div class="modal fade" id="detallesModal" tabindex="-1" aria-labelledby="detallesModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="detallesModalLabel">Descripción de la encuesta</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body" id="detallesUsuarioContent">
					<!-- Contenido cargado por AJAX -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
	<script src="js/app.js"></script>
	<script>
		// Función para ver detalles del usuario
		function verDetalles(usuarioId) {
			fetch('EncuestadorServlet?action=descripcion&id=' + usuarioId)
					.then(response => response.text())
					.then(data => {
						document.getElementById('detallesUsuarioContent').innerHTML = data;
						var modal = new bootstrap.Modal(document.getElementById('detallesModal'));
						modal.show();
					})
					.catch(error => console.error('Error:', error));
		}
	</script>



</body>

</html>