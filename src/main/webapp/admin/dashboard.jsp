<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.DashboardDTO" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.google.gson.internal.bind.util.ISO8601Utils" %>
<%
    boolean sidebarAbierto = request.getAttribute("sidebarAbierto") != null ? (Boolean) request.getAttribute("sidebarAbierto") : true;
    DashboardDTO estadisticas = (DashboardDTO) request.getAttribute("estadisticas");
    Map<String, Integer> usuariosPorMes = (Map<String, Integer>) request.getAttribute("usuariosPorMes");
    Map<String, Integer> distribucionRoles = (Map<String, Integer>) request.getAttribute("distribucionRoles");
%>
<%Usuario user = (Usuario) session.getAttribute("usuario");%>
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

    <title>Dashboard Coordinador - Encuestas Completadas</title>

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

        .col-md-2-4 {
            flex: 0 0 20%;
            max-width: 20%;
        }


    </style>
    <style>
        /* Pantallas medianas/grandes (md+) - 5 tarjetas por fila */
        @media (min-width: 768px) {
            .col-md-2-4 {
                flex: 0 0 20%;
                max-width: 20%;
            }
        }

        /* Pantallas pequeñas (sm) - 2 tarjetas por fila */
        @media (max-width: 767.98px) {
            .col-md-2-4 {
                flex: 0 0 50%;
                max-width: 50%;
            }
        }

        /* Móviles (xs) - 1 tarjeta por fila */
        @media (max-width: 575.98px) {
            .col-md-2-4 {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
        .chart-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .bg-custom-indigo {
            background-color: #6610f2 !important;  /* Color morado/indigo intenso */
        }
    </style>

    <style>
        .wrapper {
            display: flex;
            min-height: 100vh; /* Ocupa al menos el 100% del viewport */
            overflow-x: hidden;
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
    <nav id="sidebar" class="sidebar js-sidebar <%= sidebarAbierto ? "" : "collapsed" %>">
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
    <div class="main ">
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
                <div class="col-6 col-md-2-4">
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

                <div class="col-md-2-4">
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

                <div class="col-md-2-4">
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

                <div class="col-md-2-4">
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

                <div class="col-md-2-4">
                    <div class="card card-counter bg-custom-indigo text-white mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-white">Zona con más usuarios</h6>
                                    <h2 class="mb-0 text-white"><%= estadisticas.getZonaMasActiva() != null ? estadisticas.getZonaMasActiva() : "N/A" %></h2>
                                </div>
                                <i class="bi bi-geo-alt"></i>
                            </div>

                        </div>
                    </div>
                </div>

            </div>

            <!-- Gráficos y reportes -->
            <div class="row">
                <div class="col-md-6">
                    <div class="chart-container" style="position: relative; min-height: 400px; width: 100%">
                        <h4>Distribución de Usuarios por Rol</h4>
                        <div style="overflow-x: auto; max-width: 100%;">
                        <canvas id="rolesChart" height="300"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="chart-container" style="position: relative; height: 300px; width: 100%">
                        <h4>Registros Mensuales (Últimos 6 meses)</h4>

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
                                    <option value="respuestas">Respuestas de encuesta</option>
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


        </main>
        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>


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
                datalabels: {
                    color: function(context) {
                        // Color dinámico para mejor contraste
                        return context.dataset.backgroundColor[context.dataIndex] === '#f6c23e'
                            ? '#000' : '#fff';
                    },
                    formatter: (value, context) => {
                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                        if (total === 0) return '0%';
                        const percentage = Math.round((value / total) * 100);
                        return percentage + '%';
                    },
                    font: { weight: 'bold', size: 14 },
                    anchor: 'center',
                    align: 'center'
                },
                legend: {
                    position: window.innerWidth < 768 ? 'bottom' : 'right',
                    labels: {
                        boxWidth: 15,
                        padding: 15,
                        font: {
                            size: window.innerWidth < 900 ? 15 : 17 // Tamaño más pequeño en móviles
                        }
                    }
                }
            },
            layout: {
                padding: {
                    left: 10,
                    right: 30,
                    top: 10,
                    bottom: window.innerWidth < 900 ? 50 : 10 // Más espacio abajo en móviles
                }
            },
            cutout: window.innerWidth < 900 ? '50%' : '40%' // Hueco más grande en móviles
        },
        plugins: [ChartDataLabels]
    });
    window.addEventListener('resize', function() {
        rolesChart.options.plugins.legend.position = window.innerWidth < 900 ? 'bottom' : 'right';
        rolesChart.options.plugins.legend.labels.font.size = window.innerWidth < 900 ? 16.5 : 17;
        rolesChart.options.layout.padding.bottom = window.innerWidth < 900 ? 50 : 10;
        rolesChart.options.cutout = window.innerWidth < 900 ? '50%' : '40%';
        rolesChart.update();
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Toggle sidebar
    document.querySelector('.js-sidebar-toggle').addEventListener('click', function() {
        document.querySelector('.js-sidebar').classList.toggle('collapsed');
        document.querySelector('.main').classList.toggle('sidebar-collapsed');
    });

    // Inicializar feather icons
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();

        // Cerrar alertas automáticamente después de 5 segundos
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>
</body>
</html>