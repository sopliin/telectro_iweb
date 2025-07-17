<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasEncuestadorDTO" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasZonaDTO" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasEncuestadorDTO" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasZonaDTO" %>
<%Usuario user = (Usuario) session.getAttribute("usuario");%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Coordinador - Encuestas Completadas</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        /* Estilo adicional para los botones para asegurar uniformidad */
        .btn-uniform {
            min-width: 90px;
            text-align: center;
            display: inline-block;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            line-height: 1.5;
        }
        /* Estilo para el botón de icono de perfil */
        .btn-icon-profile {
            background: none;
            border: none;
            padding: 0.25rem;
            cursor: pointer;
            color: #6c757d;
            transition: color 0.2s ease-in-out;
            margin-right: 0.25rem;
        }
        .btn-icon-profile:hover {
            color: #007bff;
        }
        .btn-icon-profile i {
            font-size: 1.25rem;
        }
        /* ----- Ajustes para la barra de navegación superior y el bloque de usuario ----- */
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
        /* FIN DE LOS AJUSTES DE ALINEACIÓN DE USUARIO */
        /* Separación del título "Analytics Dashboard" */
        .container-fluid .h3 {
            margin-bottom: 2.5rem;
            font-weight: 600; /* Hacer el título un poco más negrita */
            color: #343a40; /* Color oscuro para el título */
        }
        .container-fluid .h3 strong {
            font-weight: 600; /* Asegurar que la parte en negrita sea consistente */
        }

        .dashboard-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
        }
        .chart-card {
            flex: 1 1 45%;
            min-width: 400px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .data-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .data-table th, .data-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .data-table th {
            background-color: #f2f2f2;
        }
        /* Ejemplo de CSS para centrar verticalmente */
        .perfil-contenedor {
            display: flex;
            align-items: center; /* Centra verticalmente */
            gap: 12px; /* Espacio entre la foto y el texto */
        }

        .foto-perfil {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .info-perfil {
            display: flex;
            flex-direction: column;
            justify-content: center; /* Centra verticalmente el texto respecto a la imagen */
        }

        .nombre {
            font-weight: bold;
        }

        .rol {
            font-size: 0.9em;
            color: #888;
        }
        /* Añade estos nuevos estilos */
        .dashboard-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 15px;
        }

        .chart-card {
            flex: 1 1 100%;
            width: 100%;
            min-width: 0;
            max-width: 100%;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px;
            box-sizing: border-box;
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
            margin-bottom: 15px;
        }

        .data-table {
            width: 100%;
            margin-top: 15px;
            border-collapse: collapse;
            font-size: 0.9em;
        }

        @media (min-width: 768px) {
            .chart-card {
                flex: 1 1 calc(50% - 20px);
            }

            .chart-container {
                height: 350px;
            }

            .data-table {
                font-size: 1em;
            }
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
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="CoordinadorServlet">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">Menú del coordinador</li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=lista">
                        <i class="align-middle" data-feather="users"></i> <span class="align-middle">Encuestadores de zona</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=listarEncuestas">
                        <i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestas</span>
                    </a>
                </li>
                <li class="sidebar-item active">
                    <a class="sidebar-link " href="CoordinadorServlet?action=dashboard">
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
                        <a class="nav-link dropdown-toggle   " href="#" data-bs-toggle="dropdown">
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
                            <a class="dropdown-item" href="CoordinadorServlet?action=verPerfil"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>

        <main class="content">
            <div class="dashboard-container">
                <!-- Gráfico de Encuestas Completadas por Encuestador -->
                <div class="chart-card">
                    <h2>Encuestas Completadas por Encuestador</h2>
                    <div class="chart-container">
                        <canvas id="encuestadorChart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Encuestador</th>
                            <th>Encuestas Completadas</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<EstadisticasEncuestadorDTO> statsEncuestadores =
                                    (ArrayList<EstadisticasEncuestadorDTO>) request.getAttribute("statsEncuestadores");
                            if (statsEncuestadores != null) {
                                for (EstadisticasEncuestadorDTO dto : statsEncuestadores) {
                        %>
                        <tr>
                            <td><%= dto.getNombreEncuestador() %></td>
                            <td><%= dto.getCompletadas() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>

                <!-- Gráfico de Encuestas Completadas por Zona/Distrito -->
                <div class="chart-card">
                    <h2>Encuestas Completadas por Zona/Distrito</h2>
                    <div class="chart-container">
                        <canvas id="zonaChart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Zona</th>
                            <th>Distrito</th>
                            <th>Encuestas Completadas</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<EstadisticasZonaDTO> statsZonas =
                                    (ArrayList<EstadisticasZonaDTO>) request.getAttribute("statsZonas");
                            if (statsZonas != null) {
                                for (EstadisticasZonaDTO dto : statsZonas) {
                        %>
                        <tr>
                            <td><%= dto.getNombreZona() %></td>
                            <td><%= dto.getNombreDistrito() %></td>
                            <td><%= dto.getCompletadas() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>
<script src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
<script>
    // Variables globales para las instancias de gráficos
    let encuestadorChart, zonaChart;

    // Datos para gráfico de encuestadores
    const encuestadorLabels = [];
    const encuestadorData = [];

    <% if (statsEncuestadores != null) {
        for (EstadisticasEncuestadorDTO dto : statsEncuestadores) { %>
    encuestadorLabels.push('<%= dto.getNombreEncuestador() %>');
    encuestadorData.push(<%= dto.getCompletadas() %>);
    <%    }
       } %>

    // Datos para gráfico de zonas
    const zonaLabels = [];
    const zonaData = [];

    <% if (statsZonas != null) {
        for (EstadisticasZonaDTO dto : statsZonas) { %>
    zonaLabels.push('<%= dto.getNombreZona() %> - <%= dto.getNombreDistrito() %>');
    zonaData.push(<%= dto.getCompletadas() %>);
    <%    }
       } %>

    // Función para determinar el tamaño de fuente según el dispositivo
    function getFontSize() {
        return window.innerWidth < 768 ? 10 : 12;
    }

    // Configuración gráfico de encuestadores
    function initEncuestadorChart() {
        const encuestadorCtx = document.getElementById('encuestadorChart').getContext('2d');
        encuestadorChart = new Chart(encuestadorCtx, {
            type: 'bar',
            data: {
                labels: encuestadorLabels,
                datasets: [{
                    label: 'Encuestas Completadas',
                    data: encuestadorData,
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            font: {
                                size: getFontSize()
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Cantidad de Encuestas',
                            font: {
                                size: getFontSize()
                            }
                        },
                        ticks: {
                            font: {
                                size: getFontSize()
                            }
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Encuestadores',
                            font: {
                                size: getFontSize()
                            }
                        },
                        ticks: {
                            font: {
                                size: getFontSize()
                            },
                            autoSkip: true,
                            maxRotation: 45,
                            minRotation: 45
                        }
                    }
                }
            }
        });
    }

    // Configuración gráfico de zonas
    function initZonaChart() {
        const zonaCtx = document.getElementById('zonaChart').getContext('2d');
        zonaChart = new Chart(zonaCtx, {
            type: 'bar',
            data: {
                labels: zonaLabels,
                datasets: [{
                    label: 'Encuestas Completadas',
                    data: zonaData,
                    backgroundColor: 'rgba(75, 192, 192, 0.7)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            font: {
                                size: getFontSize()
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Cantidad de Encuestas',
                            font: {
                                size: getFontSize()
                            }
                        },
                        ticks: {
                            font: {
                                size: getFontSize()
                            }
                        }
                    },
                    y: {
                        title: {
                            display: true,
                            text: 'Zonas/Distritos',
                            font: {
                                size: getFontSize()
                            }
                        },
                        ticks: {
                            font: {
                                size: getFontSize()
                            }
                        }
                    }
                }
            }
        });
    }

    // Función para redimensionar gráficos
    function handleResize() {
        if (encuestadorChart) {
            encuestadorChart.options.plugins.legend.labels.font.size = getFontSize();
            encuestadorChart.options.scales.x.ticks.font.size = getFontSize();
            encuestadorChart.options.scales.y.ticks.font.size = getFontSize();
            encuestadorChart.update();
        }

        if (zonaChart) {
            zonaChart.options.plugins.legend.labels.font.size = getFontSize();
            zonaChart.options.scales.x.ticks.font.size = getFontSize();
            zonaChart.options.scales.y.ticks.font.size = getFontSize();
            zonaChart.update();
        }
    }

    // Inicializar gráficos cuando el DOM esté listo
    document.addEventListener('DOMContentLoaded', function() {
        initEncuestadorChart();
        initZonaChart();

        // Redimensionar gráficos cuando cambie el tamaño de la ventana
        window.addEventListener('resize', handleResize);
    });
</script>
</body>
</html>