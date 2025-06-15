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
    <title> Asignar encuestas desde secc encuestadores - Coordinador</title>
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
                <h1 class="h3 mb-3">Asignar Encuesta al Encuestador</h1>

                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <c:if test="${not empty encuestador}">
                                    <div class="alert alert-info mb-4">
                                        <h5 class="mb-2">Asignando a:</h5>
                                        <ul class="mb-0">
                                            <li><strong>Nombre:</strong> ${encuestador.nombre} ${encuestador.apellidoPaterno} ${encuestador.apellidoMaterno}</li>
                                            <li><strong>DNI:</strong> ${encuestador.dni}</li>
                                            <li><strong>Email:</strong> ${encuestador.correo}</li>
                                            <li><strong>Zona:</strong> ${encuestador.zona.nombre}</li>
                                            <li><strong>Distrito:</strong> ${encuestador.distrito.nombre}</li>
                                        </ul>
                                    </div>
                                </c:if>

                                <!-- Filtro por carpeta -->
                                <form method="get" action="CoordinadorServlet" class="mb-3">
                                    <input type="hidden" name="action" value="asignarFormulario"/>
                                    <input type="hidden" name="id" value="${param.id}"/>
                                    <input type="hidden" name="zonaId" value="${zonaIdFiltro}" />
                                    <input type="hidden" name="distritoId" value="${distritoIdFiltro}" />
                                    <div class="mb-3">
                                        <label class="form-label">Carpeta:</label>
                                        <select name="carpeta" class="form-select" required onchange="this.form.submit()">
                                            <option value="" ${empty carpeta ? 'selected' : ''}>Seleccione una carpeta</option>
                                            <c:forEach var="c" items="${listaCarpetas}">
                                                <option value="${c}" ${carpeta == c ? 'selected' : ''}>${c}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </form>

                                <!-- Formulario para asignar encuesta -->
                                <form method="post" action="CoordinadorServlet">
                                    <input type="hidden" name="action" value="guardarAsignacion"/>
                                    <input type="hidden" name="idEncuestador" value="${param.id}"/>
                                    <input type="hidden" name="origen" value="vistaEncuestadores" />
                                    <input type="hidden" name="zonaId" value="${zonaIdFiltro}" />
                                    <input type="hidden" name="distritoId" value="${distritoIdFiltro}" />
                                    <input type="hidden" name="carpeta" value="${carpeta}"/>

                                    <div class="mb-3">
                                        <label class="form-label">Nombre de la Encuesta:</label>
                                        <select name="nombreEncuesta" class="form-select" required>
                                            <option value="">Seleccione una encuesta</option>
                                            <c:forEach var="e" items="${listaEncuestas}">
                                                <option value="${e.nombre}" <c:if test="${e.estado != 'activo'}">disabled</c:if>>
                                                        ${e.nombre}<c:if test="${e.estado != 'activo'}"> (desactivada)</c:if>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Cantidad de encuestas a asignar:</label>
                                        <input type="number" name="cantidad" min="1" value="10" required class="form-control" style="width: 120px;" />
                                    </div>

                                    <button type="submit" class="btn btn-primary">Asignar Encuesta</button>
                                </form>

                                <!-- Botón volver -->
                                <form method="get" action="CoordinadorServlet" class="mt-4">
                                    <input type="hidden" name="action" value="filtrar"/>
                                    <input type="hidden" name="zonaId" value="${zonaIdFiltro}" />
                                    <input type="hidden" name="distritoId" value="${distritoIdFiltro}" />
                                    <button type="submit" class="btn btn-secondary">← Volver a la lista</button>
                                </form>
                            </div>
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