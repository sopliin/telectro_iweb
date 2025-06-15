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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
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
    </style>
    <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
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
            <a class="sidebar-toggle js-sidebar-toggle">
                <i class="hamburger align-self-center"></i>
            </a>
            <div class="navbar-collapse collapse">
                <ul class="navbar-nav navbar-align">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>"
                                 class="avatar img-fluid rounded me-1" alt="Foto"/>
                            <span class="text-dark"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="CoordinadorServlet?action=verPerfil"><i
                                    class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
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
                    <canvas id="encuestadorChart"></canvas>

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
                    <canvas id="zonaChart"></canvas>

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
        <footer class="footer">
            <div class="container-fluid">
                <div class="row text-muted">
                    <div class="col-6 text-start">
                        <p class="mb-0">
                            <a class="text-muted" href="https://adminkit.io/" target="_blank"><strong>AdminKit</strong></a>
                            &copy;
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
<script>
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

    // Configuración gráfico de encuestadores
    const encuestadorCtx = document.getElementById('encuestadorChart').getContext('2d');
    new Chart(encuestadorCtx, {
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
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Cantidad de Encuestas'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Encuestadores'
                    }
                }
            }
        }
    });

    // Configuración gráfico de zonas
    const zonaCtx = document.getElementById('zonaChart').getContext('2d');
    new Chart(zonaCtx, {
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
            indexAxis: 'y', // Barras horizontales
            responsive: true,
            scales: {
                x: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Cantidad de Encuestas'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Zonas/Distritos'
                    }
                }
            }
        }
    });
</script>
</body>
</html>