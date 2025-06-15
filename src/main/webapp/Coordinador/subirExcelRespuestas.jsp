<%-- admin/subirExcelRespuestas.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <%Usuario user = (Usuario) session.getAttribute("usuario");%>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="ONU Mujeres - Cambiar Contraseña">
    <meta name="author" content="ONU Mujeres">
    <meta name="keywords" content="onu, mujeres, encuestas, administración">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="img/icons/icon-48x48.png"/>

    <title>Cambiar Contraseña - ONU Mujeres</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css"
          href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Subir Respuestas de Excel</title>

</head>
<body>
<script type="text/javascript" src="js/app.js"></script>
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="CoordinadorServlet?action=lista">
                <span class="align-middle">ONU Mujeres</span>
            </a>

            <ul class="sidebar-nav">
                <li class="sidebar-header">
                    Menu del coordinador
                </li>

                <li class="sidebar-item active">
                    <a class="sidebar-link" href="CoordinadorServlet?action=lista">
                        <i class="align-middle" data-feather="users"></i> <span
                            class="align-middle">Encuestadores de zona</span>
                    </a>
                </li>

                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=listarEncuestas">
                        <i class="align-middle" data-feather="list"></i> <span
                            class="align-middle">Encuestas</span>
                    </a>
                </li>

                <li class="sidebar-item">
                    <a class="sidebar-link" href="CoordinadorServlet?action=dashboard">
                        <i class="align-middle" data-feather="bar-chart"></i> <span class="align-middle">Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item active">
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


                    <li class="nav-item dropdown">
                        <a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#" data-bs-toggle="dropdown">
                            <i class="align-middle" data-feather="settings"></i>
                        </a>

                        <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>"
                                 class="avatar img-fluid rounded me-1" alt="Charles Hall"/> <span
                                class="text-dark"><%=user.getNombre() + " " + user.getApellidoPaterno() %></span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="CoordinadorServlet?action=verPerfil"><i class="align-middle me-1"
                                                                                             data-feather="pie-chart"></i>
                                Ver Perfil</a>
                            <div class="dropdown-divider"></div>

                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>


                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <main class="content">
            <div class="container mt-5">
                <h1>Subir Respuestas de Encuesta desde Excel</h1>

                <form action="<%=request.getContextPath()%>/CoordinadorServlet" method="post"
                      enctype="multipart/form-data" class="mt-4">
                    <input type="hidden" name="action" value="uploadExcel">

                    <div class="mb-3">
                        <label for="encuestaId" class="form-label">ID de la Encuesta:</label>
                        <input type="number" class="form-control" id="encuestaId" name="encuestaId" required
                               placeholder="Ej: 123">
                        <div class="form-text">Introduce el ID de la encuesta a la que corresponden las respuestas del
                            archivo
                            Excel.
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="excelFile" class="form-label">Seleccionar archivo Excel (.xlsx):</label>
                        <input class="form-control" type="file" id="excelFile" name="excelFile" accept=".xlsx" required>
                        <div class="form-text">Asegúrate de que el archivo tenga el formato correcto (DNI, Fecha Inicio,
                            Fecha
                            Envío, Pregunta 1, Pregunta 2...).
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">Subir Respuestas</button>
                </form>

                <%-- Mensajes de éxito o error --%>
                <div class="mt-4">
                    <%
                        String info = (String) request.getSession().getAttribute("info");
                        if (info != null) {
                    %>
                    <div class="alert alert-success" role="alert">
                        <%= info %>
                    </div>
                    <%
                            request.getSession().removeAttribute("info"); // Limpiar el atributo para que no se muestre de nuevo
                        }
                    %>
                    <%
                        String error = (String) request.getSession().getAttribute("error");
                        if (error != null) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        <%= error %>
                    </div>
                    <%
                            request.getSession().removeAttribute("error"); // Limpiar el atributo
                        }
                    %>
                </div>
            </div>
        </main>
        <footer class="footer">
            <div class="container-fluid">
                <div class="row text-muted">
                    <div class="col-6 text-start">
                        <p class="mb-0">
                            <a class="text-muted" href="#" target="_blank"><strong>ONU Mujeres</strong></a> &copy;
                        </p>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</div>


<script type="text/javascript" src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>
</body>
</html>