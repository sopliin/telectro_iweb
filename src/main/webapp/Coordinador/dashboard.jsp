<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasEncuestadorDTO" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasZonaDTO" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasEncuestadorDTO" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.EstadisticasZonaDTO" %>
<%@ page import="org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO" %>
<%Usuario user = (Usuario) session.getAttribute("usuario");%>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/CSS/sidebar-navbar-avatar.css" rel="stylesheet">

    <title>Dashboard Coordinador - Encuestas Completadas</title>

    <style>

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
</head>
<body>
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
                    <h2 style="font-size: 20px;">Encuestas Completadas por Encuestador</h2>
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
                    <h2 style="font-size: 20px;">Encuestas Completadas por Zona/Distrito</h2>
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
                <!-- Sección de Preguntas Si o NO-->
                    <!-- Gráfico de Respuestas a la Pregunta 9 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Hay niños/niñas de 0 a 5 años en el hogar?</h2>

                    <div class = "chart-container">
                     <canvas id="pregunta9Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta9 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta9");
                            if (statsPregunta9 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta9) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 11 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Asisten a una guardería o preescolar?</h2>

                    <div class = "chart-container">
                        <canvas id="pregunta11Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta11 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta11");
                            if (statsPregunta11 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta11) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 13 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Hay personas adultas mayores en el hogar?</h2>

                    <div class="chart-container">
                    <canvas id="pregunta13Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta13 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta11");
                            if (statsPregunta13 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta13) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 16 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Usan apoyos para movilizarse como sillas de rueda, bastón, muletas?</h2>

                    <div class="chart-container">
                    <canvas id="pregunta16Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta16 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta16");
                            if (statsPregunta16 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta16) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 17 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Hay personas con discapacidad o enfermedad crónica en el hogar?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta17Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta17 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta17");
                            if (statsPregunta17 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta17) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 20 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Tienen carnet CONADIS?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta20Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta20 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta20");
                            if (statsPregunta20 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta20) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 21 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Alguna persona integrante de su hogar se dedica al trabajo doméstico remunerado?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta21Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta21 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta21");
                            if (statsPregunta21 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta21) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 23 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Actualmente está contratada (tiene contrato formal) en la casa donde trabaja?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta23Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta23 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta23");
                            if (statsPregunta23 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta23) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 24 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Participa en algún sindicato u organización?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta24Chart"></canvas>
                    </div>


                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta24 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta24");
                            if (statsPregunta24 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta24) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 26 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Conoce los servicios de cuidados: cuna más, OMAPED, CIAM, etc.?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta26Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta26 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta26");
                            if (statsPregunta26 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta26) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>

                <!-- Gráfico de Respuestas a la Pregunta 27 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Usted realiza algún trabajo remunerado fuera de casa?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta27Chart"></canvas>
                    </div>


                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta27 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta27");
                            if (statsPregunta27 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta27) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <!-- Gráfico de Respuestas a la Pregunta 28 -->
                <div class="chart-card">
                    <h2 style="font-size: 20px;">¿Usted tiene algún emprendimiento (negocio)?</h2>

                    <div class="chart-container">
                        <canvas id="pregunta28Chart"></canvas>
                    </div>

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Respuesta</th>
                            <th>Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ArrayList<org.example.onu_mujeres_crud.dtos.RespuestaSiNoDTO> statsPregunta28 =
                                    (ArrayList<RespuestaSiNoDTO>) request.getAttribute("statsPregunta28");
                            if (statsPregunta28 != null) {
                                for (RespuestaSiNoDTO dto : statsPregunta28) {
                        %>
                        <tr>
                            <td><%= dto.getRespuesta() %></td>
                            <td><%= dto.getCantidad() %></td>
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
    let encuestadorChart, zonaChart,pregunta9Chart,pregunta11Chart,pregunta13Chart,pregunta16Chart,pregunta17Chart,pregunta20Chart,pregunta21Chart,
        pregunta23Chart, pregunta24Chart,pregunta26Chart,pregunta27Chart,pregunta28Chart;


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

    // Para la pregunta 9
    const pregunta9Labels = [];
    const pregunta9Data = [];

    <% if (statsPregunta9 != null) {
        for (RespuestaSiNoDTO dto : statsPregunta9) { %>
    pregunta9Labels.push('<%= dto.getRespuesta() %>');
    pregunta9Data.push(<%= dto.getCantidad() %>);
    <%  }
    } %>

    // Para la pregunta 11
    const pregunta11Labels = [];
    const pregunta11Data = [];

    <% if (statsPregunta11 != null) {
        for (RespuestaSiNoDTO dto : statsPregunta11) { %>
    pregunta11Labels.push('<%= dto.getRespuesta() %>');
    pregunta11Data.push(<%= dto.getCantidad() %>);
    <%  }
    } %>

    // Pregunta 13
    const pregunta13Labels = [];
    const pregunta13Data = [];
    <% if (statsPregunta13 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta13) { %>
    pregunta13Labels.push('<%= dto.getRespuesta() %>');
    pregunta13Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 16
    const pregunta16Labels = [];
    const pregunta16Data = [];
    <% if (statsPregunta16 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta16) { %>
    pregunta16Labels.push('<%= dto.getRespuesta() %>');
    pregunta16Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 17
    const pregunta17Labels = [];
    const pregunta17Data = [];
    <% if (statsPregunta17 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta17) { %>
    pregunta17Labels.push('<%= dto.getRespuesta() %>');
    pregunta17Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 20
    const pregunta20Labels = [];
    const pregunta20Data = [];
    <% if (statsPregunta20 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta20) { %>
    pregunta20Labels.push('<%= dto.getRespuesta() %>');
    pregunta20Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 21
    const pregunta21Labels = [];
    const pregunta21Data = [];
    <% if (statsPregunta21 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta21) { %>
    pregunta21Labels.push('<%= dto.getRespuesta() %>');
    pregunta21Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 23
    const pregunta23Labels = [];
    const pregunta23Data = [];
    <% if (statsPregunta23 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta23) { %>
    pregunta23Labels.push('<%= dto.getRespuesta() %>');
    pregunta23Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 24
    const pregunta24Labels = [];
    const pregunta24Data = [];
    <% if (statsPregunta24 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta24) { %>
    pregunta24Labels.push('<%= dto.getRespuesta() %>');
    pregunta24Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 26
    const pregunta26Labels = [];
    const pregunta26Data = [];
    <% if (statsPregunta26 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta26) { %>
    pregunta26Labels.push('<%= dto.getRespuesta() %>');
    pregunta26Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 27
    const pregunta27Labels = [];
    const pregunta27Data = [];
    <% if (statsPregunta27 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta27) { %>
    pregunta27Labels.push('<%= dto.getRespuesta() %>');
    pregunta27Data.push(<%= dto.getCantidad() %>);
    <% }} %>

    // Pregunta 28
    const pregunta28Labels = [];
    const pregunta28Data = [];
    <% if (statsPregunta28 != null) {
      for (RespuestaSiNoDTO dto : statsPregunta28) { %>
    pregunta28Labels.push('<%= dto.getRespuesta() %>');
    pregunta28Data.push(<%= dto.getCantidad() %>);
    <% }} %>

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

    // Configuración gráfico de encuestadores
    function initPregunta9Chart() {
        const ctx = document.getElementById('pregunta9Chart').getContext('2d');
        pregunta9Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta9Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta9Data,
                    backgroundColor: 'rgba(70, 120, 50, 0.5)',
                    borderColor: 'rgba(70, 120, 50, 0.5)',
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas Si/No',
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
    function initPregunta11Chart() {
        const ctx = document.getElementById('pregunta11Chart').getContext('2d');
        pregunta11Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta11Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta11Data,
                    backgroundColor: 'rgba(255, 140, 0, 0.5)',  // Naranja suave
                    borderColor: 'rgba(255, 140, 0, 1)',        // Naranja fuerte
                    borderWidth: 1,
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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

    //pregunta 13
    function initPregunta13Chart() {
        const ctx = document.getElementById('pregunta13Chart').getContext('2d');
        pregunta13Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta13Labels,
                datasets: [{
                    label: 'Respuestas Pregunta 13',
                    data: pregunta13Data,
                    backgroundColor: 'rgba(153, 102, 255, 0.7)', // morado claro
                    borderColor: 'rgba(153, 102, 255, 1)',       // morado fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    //pregunta 16
    function initPregunta16Chart() {
        const ctx = document.getElementById('pregunta16Chart').getContext('2d');
        pregunta16Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta16Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta16Data,
                    backgroundColor: 'rgba(255, 99, 132, 0.7)', // rojo claro
                    borderColor: 'rgba(255, 99, 132, 1)',       // rojo fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    //pregunta 17
    function initPregunta17Chart() {
        const ctx = document.getElementById('pregunta17Chart').getContext('2d');
        pregunta17Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta17Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta17Data,
                    backgroundColor: 'rgba(255, 206, 86, 0.7)', // amarillo claro
                    borderColor: 'rgba(255, 206, 86, 1)',       // amarillo fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    //pregunta 20
    function initPregunta20Chart() {
        const ctx = document.getElementById('pregunta20Chart').getContext('2d');
        pregunta20Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta20Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta20Data,
                    backgroundColor: 'rgba(54, 162, 235, 0.7)', // azul claro
                    borderColor: 'rgba(54, 162, 235, 1)',       // azul fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    // pregunta 21
    function initPregunta21Chart() {
        const ctx = document.getElementById('pregunta21Chart').getContext('2d');
        pregunta21Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta21Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta21Data,
                    backgroundColor: 'rgba(75, 192, 192, 0.7)', // verde agua claro
                    borderColor: 'rgba(75, 192, 192, 1)',       // verde agua fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    // pregunta 23
    function initPregunta23Chart() {
        const ctx = document.getElementById('pregunta23Chart').getContext('2d');
        pregunta23Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta23Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta23Data,
                    backgroundColor: 'rgba(201, 203, 207, 0.7)', // gris claro
                    borderColor: 'rgba(201, 203, 207, 1)',       // gris fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    //pregunta 24
    function initPregunta24Chart() {
        const ctx = document.getElementById('pregunta24Chart').getContext('2d');
        pregunta24Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta24Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta24Data,
                    backgroundColor: 'rgba(255, 99, 255, 0.7)', // rosado claro
                    borderColor: 'rgba(255, 99, 255, 1)',       // rosado fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    //pregunta 26
    function initPregunta26Chart() {
        const ctx = document.getElementById('pregunta26Chart').getContext('2d');
        pregunta26Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta26Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta26Data,
                    backgroundColor: 'rgba(0, 200, 83, 0.7)', // verde intenso claro
                    borderColor: 'rgba(0, 200, 83, 1)',       // verde fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
    // pregunta 27
    function initPregunta27Chart() {
        const ctx = document.getElementById('pregunta27Chart').getContext('2d');
        pregunta27Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta27Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta27Data,
                    backgroundColor: 'rgba(255, 140, 0, 0.7)', // naranja quemado claro
                    borderColor: 'rgba(255, 140, 0, 1)',       // naranja quemado fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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

    //pregunta 28
    function initPregunta28Chart() {
        const ctx = document.getElementById('pregunta28Chart').getContext('2d');
        pregunta28Chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: pregunta28Labels,
                datasets: [{
                    label: 'Cantidad de Respuestas',
                    data: pregunta28Data,
                    backgroundColor: 'rgba(0, 123, 255, 0.7)', // azul intenso claro
                    borderColor: 'rgba(0, 123, 255, 1)',       // azul intenso fuerte
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
                            text: 'Cantidad de Respuestas',
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
                            text: 'Respuestas (Sí / No)',
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
        if (pregunta9Chart) {
            pregunta9Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta9Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta9Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta9Chart.update();
        }
        if (pregunta11Chart) {
            pregunta11Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta11Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta11Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta11Chart.update();
        }
        if (pregunta13Chart) {
            pregunta13Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta13Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta13Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta13Chart.update();
        }
        if (pregunta16Chart) {
            pregunta16Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta16Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta16Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta16Chart.update();
        }
        if (pregunta17Chart) {
            pregunta17Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta17Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta17Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta17Chart.update();
        }
        if (pregunta20Chart) {
            pregunta20Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta20Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta20Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta20Chart.update();
        }
        if (pregunta21Chart) {
            pregunta21Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta21Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta21Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta21Chart.update();
        }
        if (pregunta23Chart) {
            pregunta23Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta23Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta23Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta23Chart.update();
        }
        if (pregunta24Chart) {
            pregunta24Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta24Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta24Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta24Chart.update();
        }
        if (pregunta26Chart) {
            pregunta26Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta26Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta26Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta26Chart.update();
        }
        if (pregunta27Chart) {
            pregunta27Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta27Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta27Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta27Chart.update();
        }
        if (pregunta28Chart) {
            pregunta28Chart.options.plugins.legend.labels.font.size = getFontSize();
            pregunta28Chart.options.scales.x.ticks.font.size = getFontSize();
            pregunta28Chart.options.scales.y.ticks.font.size = getFontSize();
            pregunta28Chart.update();
        }
    }

    // Inicializar gráficos cuando el DOM esté listo
    document.addEventListener('DOMContentLoaded', function() {
        initEncuestadorChart();
        initZonaChart();
        initPregunta9Chart();
        initPregunta11Chart();
        initPregunta13Chart();
        initPregunta16Chart();
        initPregunta17Chart();
        initPregunta20Chart();
        initPregunta21Chart();
        initPregunta23Chart();
        initPregunta24Chart();
        initPregunta26Chart();
        initPregunta27Chart();
        initPregunta28Chart();
        // Redimensionar gráficos cuando cambie el tamaño de la ventana
        window.addEventListener('resize', handleResize);
    });

</script>
</body>
</html>