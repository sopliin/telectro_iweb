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
	<link rel="shortcut icon" href="img/icons/icon-48x48.png" />

	<link rel="canonical" href="https://demo-basic.adminkit.io/" />

	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
	<title>AdminKit Demo - Bootstrap 5 Admin Template</title>

	<link href="css/app.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
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
				<li class="sidebar-header">
					Encuestas
				</li>
				<li class="sidebar-item">
					<a class="sidebar-link" href="EncuestadorServlet?action=total">
						<i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestas totales</span>
					</a>
				</li>
				<li class="sidebar-item">
					<a class="sidebar-link" href="EncuestadorServlet?action=total">
						<i class="align-middle" data-feather="check"></i> <span class="align-middle">Encuestas completadas</span>
					</a>
				</li>

				<li class="sidebar-item">
					<a class="sidebar-link" href="EncuestadorServlet?action=total">
						<i class="align-middle" data-feather="save"></i> <span class="align-middle">Encuestas en progreso</span>
					</a>
				</li>

				<li class="sidebar-item">
					<a class="sidebar-link" href="EncuestadorServlet?action=total">
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
							<a class="dropdown-item"  href="EncuestadorServlet?action=ver"><i class="align-middle me-1" data-feather="eye"></i> Ver Perfil</a>
							<div class="dropdown-divider"></div>

							<a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>


						</div>
					</li>
				</ul>
			</div>
		</nav>

		<div class="main">


			<main class="content">
				<div class="container-fluid p-0">
					<div class="row">
						<div class="col-12 col-md-4 col-xxl-3 order-1">
							<div class="card flex-fill">
								<div class="card-header">
									<h5 class="card-title mb-0">Fecha de la entrevista</h5>
								</div>
								<div class="card-body d-flex">
									<div class="align-self-center w-100">
										<div class="chart">
											<div id="datetimepicker-dashboard"></div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="col-12 col-md-8 col-xxl-9 order-2">
							<div class="mb-3">
								<h1 class="h3 d-inline align-middle">Datos generales</h1>
							</div>

							<div class="card">
								<div class="card-header">
									<h5 class="card-title mb-0">Nombres y apellidos de la persona que encuesta</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Colocar el nombre y apellido de la persona que encuestada">
								</div>

								<div class="card-header">
									<h5 class="card-title mb-0">Nombres del asentamiento humano</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Colocar el nombre del asentamiento humano">
								</div>

								<div class="card-header">
									<h5 class="card-title mb-0">Nombres del sector</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Colocar el nombre del sector">
								</div>
							</div>

						</div>
					</div>

					<div class="mt-3 ">
						<h1 class="h3 d-inline align-middle">Datos del encuestado</h1>
					</div>

					<div class="row">
						<div class="col-12 col-md-6 ">

							<div class="card">
								<div class="card-header">
									<h5 class="card-title mb-0">Nombres y apellidos del encuestado</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Colocar los nombres y apellidos del encuestado">
								</div>

								<div class="card-header">
									<h5 class="card-title mb-0">Edad del encuestado</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Colocar la edad del encuestado">
								</div>

								<div class="card-header">
									<h5 class="card-title mb-0">Direccion del encuestado</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Colocar la direccion del encuestado">
								</div>

								<div class="card-header">
									<h5 class="card-title mb-0">Numero celular del encuestado (opcional)</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Colocar el numero celular del encuestado">
								</div>
							</div>

							<div class="card">
								<div class="card-header">
									<h5 class="card-title mb-0">¿Hay niños/niñas de 0 a 5 años en el hogar?</h5>
								</div>
								<div>
									<label class="form-check ms-3">  <input class="form-check-input" type="radio" value="option1" name="radios-example" checked>
										<span class="form-check-label">
                                  Si
                               </span>
									</label>
									<label class="form-check ms-3">  <input class="form-check-input" type="radio" value="option1" name="radios-example" checked>
										<span class="form-check-label">
                                  No
                               </span>
									</label>

								</div>

								<div class="card-header">
									<h5 class="card-title mb-0">¿Cuántos niños/niñas de 0 a 5 años hay en el hogar?
									</h5>
								</div>
								<div class="card-body">
									<input type="text" class="form-control" placeholder="Respuesta">
								</div>

								<div class="card-header">
									<h5 class="card-title mb-0">¿Asisten a una guardería o preescolar?</h5>
								</div>
								<div>
									<label class="form-check ms-3">  <input class="form-check-input" type="radio" value="option1" name="radios-example" checked>
										<span class="form-check-label">
                                  Si
                               </span>
									</label>
									<label class="form-check ms-3">  <input class="form-check-input" type="radio" value="option1" name="radios-example" checked>
										<span class="form-check-label">
                                  No
                               </span>
									</label>

								</div>
							</div>


						</div>

						<div class="col-12 col-md-6 ">
						</div>
					</div>


				</div>

				<div class="mt-3 d-flex justify-content-center">
					<button class="btn btn-primary me-2">Entregar</button>
					<button class="btn btn-primary">Guardar</button>
				</div>

			</main>

			<jsp:include page="../includes/footer.jsp"/>
		</div>
	</div>

	<script src="js/app.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
	<script>
		document.addEventListener("DOMContentLoaded", function() {
			var date = new Date(Date.now() - 5 * 24 * 60 * 60 * 1000);
			var defaultDate = date.getUTCFullYear() + "-" + (date.getUTCMonth() + 1) + "-" + date.getUTCDate();
			document.getElementById("datetimepicker-dashboard").flatpickr({
				inline: true,
				prevArrow: "<span title=\"Previous month\">&laquo;</span>",
				nextArrow: "<span title=\"Next month\">&raquo;</span>",
				defaultDate: defaultDate
			});
		});
	</script>
</div>
</body>

</html>