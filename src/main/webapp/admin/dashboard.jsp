<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.DashboardDTO" %>
<%@ page import="java.util.Map" %>
<%
    DashboardDTO estadisticas = (DashboardDTO) request.getAttribute("estadisticas");
    Map<String, Integer> usuariosPorMes = (Map<String, Integer>) request.getAttribute("usuariosPorMes");
    Map<String, Integer> distribucionRoles = (Map<String, Integer>) request.getAttribute("distribucionRoles");
%>
<%Usuario user = (Usuario) session.getAttribute("usuario");%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Coordinador - Encuestas Completadas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .chart-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        /* Asegura que los canvas no se desborden */
        canvas {
            max-width: 100%;
            display: block;
        }

        /* Contenedor principal para prevenir scroll horizontal */
        .container-fluid {
            overflow-x: hidden;
        }
        .card-body {
            color: white !important;
        }
        /* Estilos adicionales para el menú activo */
        .sidebar-item.active .sidebar-link {
            background-color: #3b7ddd; /* Color azul */
            color: white !important;
            border-radius: 4px;
        }

        .sidebar-item.active .sidebar-link i {
            color: white !important;
        }

        .sidebar-item.active .sidebar-link:hover {
            background-color: #3068be; /* Color azul más oscuro al pasar el mouse */
        }
    </style>



    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="AdminServlet?action=menu">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">Menú del administrador</li>
                <li class="sidebar-item <%= (request.getParameter("action") == null || request.getParameter("action").equals("dashboard")) ? "active" : "" %>">
                    <a class="sidebar-link" href="AdminServlet?action=dashboard">
                        <i class="align-middle" data-feather="pie-chart"></i> <span class="align-middle">Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="AdminServlet?action=listaUsuarios">
                        <i class="align-middle" data-feather="user-check"></i> <span class="align-middle">Usuarios</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="AdminServlet?action=nuevoCoordinador">
                        <i class="align-middle" data-feather="user-plus"></i> <span class="align-middle">Crear coordinadores</span>
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
                            <a class="dropdown-item" href="AdminServlet?action=verPerfil"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <main class="content">
            <h2 class="mb-4">Panel de Administración</h2>

            <!-- Mensajes -->
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <!-- Estadísticas rápidas -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card card-counter bg-primary text-white mb-3">
                        <div class="card-body" >
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-white">Total Usuarios</h6>
                                    <h2 class="mb-0 text-white"><%= estadisticas.getTotalUsuarios() %></h2>
                                </div>
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-counter bg-success text-white mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-white">Activos</h6>
                                    <h2 class="mb-0 text-white"><%= estadisticas.getTotalActivos() %></h2>
                                </div>
                                <i class="bi bi-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-counter bg-warning text-white mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-white">Nuevos (mes)</h6>
                                    <h2 class="mb-0 text-white"><%= estadisticas.getNuevosUltimoMes() %></h2>
                                </div>
                                <i class="bi bi-plus-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-counter bg-secondary text-white mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-white">Baneados</h6>
                                    <h2 class="mb-0 text-white"><%= estadisticas.getTotalInactivos() %></h2>
                                </div>
                                <i class="bi bi-plus-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Gráficos y reportes -->
            <div class="row">
                <div class="col-md-6">
                    <div class="chart-container" style="position: relative; height: 300px; width: 100%">
                        <h5>Distribución de Usuarios por Rol</h5>
                        <canvas id="rolesChart" height="300"></canvas>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="chart-container" style="position: relative; height: 300px; width: 100%">
                        <h5>Registros Mensuales (Últimos 6 meses)</h5>
                        <canvas id="registrosChart" height="300"></canvas>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-12">
                    <div class="chart-container">
                        <h5>Generar Reportes</h5>
                        <form action="AdminServlet?action=generarReporte" method="post" class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Tipo de Reporte</label>
                                <select name="tipoReporte" class="form-select">
                                    <option value="todos">Todos los usuarios</option>
                                    <option value="activos">Usuarios activos</option>
                                    <option value="inactivos">Usuarios inactivos</option>
                                    <option value="coordinadores">Coordinadores</option>
                                    <option value="encuestadores">Encuestadores</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Formato</label>
                                <select class="form-select" disabled>
                                    <option>Excel (.xlsx)</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-download me-2"></i>Generar Reporte
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Zona más activa -->
            <div class="row mt-4">
                <div class="col-md-12">
                    <div class="chart-container">
                        <h5>Zona con Mayor Actividad</h5>
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>
                            La zona con más usuarios registrados es:
                            <strong><%= estadisticas.getZonaMasActiva() != null ? estadisticas.getZonaMasActiva() : "No disponible" %></strong>
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
<script type="text/javascript" src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>

<script>
    // Gráfico de distribución de roles
    const rolesCtx = document.getElementById('rolesChart');
    const rolesChart = new Chart(rolesCtx, {
        type: 'doughnut',
        data: {
            labels: [<%= distribucionRoles.keySet().stream()
            .map(rol -> "'" + rol + "'")
            .collect(java.util.stream.Collectors.joining(",")) %>],
            datasets: [{
                data: [<%= String.join(",", distribucionRoles.values()
                .stream()
                .map(String::valueOf)
                .toArray(String[]::new)) %>],
                backgroundColor: [
                    '#4e73df',
                    '#1cc88a',
                    '#36b9cc',
                    '#f6c23e'
                ],
                hoverBorderColor: "rgba(234, 236, 244, 1)",
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        boxWidth: 15,
                        padding: 15
                    }
                }
            },
            layout: {
                padding: {
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10
                }
            }
        }
    });

    // Gráfico de registros mensuales
    const registrosCtx = document.getElementById('registrosChart');
    const registrosChart = new Chart(registrosCtx, {
        type: 'bar',
        data: {
            labels: [<%= usuariosPorMes.keySet().stream()
            .map(mes -> "'" + mes + "'")
            .collect(java.util.stream.Collectors.joining(",")) %>],
            datasets: [{
                label: "Usuarios registrados",
                backgroundColor: "#4e73df",
                hoverBackgroundColor: "#2e59d9",
                borderColor: "#4e73df",
                data: [<%= String.join(",", usuariosPorMes.values()
                .stream()
                .map(String::valueOf)
                .toArray(String[]::new)) %>],
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0,
                        stepSize: 1
                    },
                    grid: {
                        display: true
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            },
            layout: {
                padding: {
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10
                }
            }
        }
    });

    // Cerrar alertas automáticamente después de 5 segundos

</script>
</body>
</html>