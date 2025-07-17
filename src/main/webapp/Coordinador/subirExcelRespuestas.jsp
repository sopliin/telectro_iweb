<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Encuesta" %>
<% Usuario user = (Usuario) session.getAttribute("usuario"); %>
<jsp:useBean id="listaEncuestas" type="java.util.ArrayList<org.example.onu_mujeres_crud.beans.Encuesta>" scope="request"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="ONU Mujeres - Subir Respuestas de Excel">
    <meta name="author" content="ONU Mujeres">
    <meta name="keywords" content="onu, mujeres, encuestas, administración, excel, subir">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="img/icons/icon-48x48.png"/>

    <title>Subir Respuestas de Excel - Coordinador</title>

    <link href="${pageContext.request.contextPath}/onu_mujeres/static/css/app.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        /* Estilos generales para el cuerpo y fuentes */
        body {
            font-family: 'Inter', sans-serif;
            color: #344767; /* Un color de texto más suave */
            background-color: #f8f9fa; /* Fondo más claro para toda la página */
        }

        /* Estilo adicional para los botones para asegurar uniformidad */
        .btn-uniform {
            min-width: 90px; /* Ancho mínimo del botón */
            text-align: center; /* Texto centrado */
            display: inline-block; /* Comportamiento inline-block */
            padding: 0.375rem 0.75rem; /* Padding estándar de Bootstrap */
            font-size: 0.875rem; /* Tamaño de fuente estándar */
            line-height: 1.5; /* Altura de línea estándar */
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

        /* Contenido principal */
        .main {
            background-color: #f8f9fa; /* Color de fondo del main */
        }
        /* Aumentar el margen del contenido principal respecto a la barra lateral */
        .main .container-fluid {
            padding-left: 3rem; /* Más padding a la izquierda */
            padding-right: 3rem; /* Más padding a la derecha */
        }


        /* Título de la página */
        .content h1 {
            font-weight: 700;
            color: #344767;
            margin-bottom: 3rem; /* Espacio debajo del título */
        }

        /* Tarjeta del formulario */
        .card-form {
            background: #ffffff;
            border-radius: 1rem; /* Bordes más redondeados */
            box-shadow: 0 8px 30px rgba(0,0,0,0.15); /* Sombra más pronunciada */
            padding: 30px;
            margin-bottom: 30px; /* Espacio debajo de la tarjeta */
        }

        /* Etiquetas de formulario */
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.75rem;
            font-size: 1.05rem; /* Aumento de tamaño de letra */
        }

        /* Campos de formulario */
        .form-control {
            border-radius: 0.75rem; /* Bordes más redondeados para inputs */
            padding: 12px 18px; /* Aumento del padding */
            border: 1px solid #dee2e6;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            font-size: 1rem; /* Aumento de tamaño de letra */
        }
        .form-control:focus {
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        /* Texto de ayuda (form-text) */
        .form-text {
            font-size: 0.95rem; /* Aumento de tamaño de letra */
            color: #6c757d;
            margin-top: 0.5rem;
        }

        /* Botón de submit */
        .btn-primary {
            background-color: #344767;
            border-color: #344767;
            padding: 10px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.2s ease, border-color 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #0a0b6c;
            border-color: #010168;
        }

        /* Mensajes de alerta */
        .alert {
            border-radius: 8px;
            padding: 1rem 1.25rem;
            font-weight: 500;
            margin-top: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }


        .list-inline-item:not(:last-child) {
            margin-right: 1.5rem;
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
        .form-select {
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            border: 1px solid #ced4da;
            font-size: 1rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        .form-select:focus {
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
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
            <a class="sidebar-brand" href="CoordinadorServlet?action=lista">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">
                    Menú del coordinador
                </li>
                <li class="sidebar-item">
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
                <li class="sidebar-item active"> <%-- Marked as active for this page --%>
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
            <div class="container-fluid p-0">
                <h1 class="h3 mb-3">Subir Respuestas de Encuesta desde Excel</h1>

                <div class="card-form"> <%-- Nueva clase para la tarjeta del formulario --%>
                    <form action="<%=request.getContextPath()%>/CoordinadorServlet" method="post"
                          enctype="multipart/form-data" class="mt-2">
                        <input type="hidden" name="action" value="uploadExcel">

                        <div class="mb-4">

                            <label for="encuesta" class="form-label">Nombre de la encuesta</label>
                            <select class="form-select" id="encuesta" name="encuestaId" required>
                                <option value="" selected disabled>Seleccione una encuesta</option>
                                <% for (Encuesta encuesta : listaEncuestas) { %>
                                <option value="<%=encuesta.getEncuestaId()%>"><%=encuesta.getNombre()%>
                                </option>
                                <% } %>
                            </select>
                            <div class="form-text">
                                Selecciona la encuesta a la que corresponden las respuestas del archivo Excel.
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="excelFile" class="form-label">Seleccionar archivo Excel (.xlsx):</label>
                            <input class="form-control" type="file" id="excelFile" name="excelFile" accept=".xlsx" required>
                            <div class="form-text">
                                Asegúrate de que el archivo tenga el formato correcto (DNI, Fecha Inicio, Fecha Envío, Pregunta 1, Pregunta 2...).
                            </div>
                            <div class="form-text pt-3 pb-1" style="font-style: italic; font-weight: bold">
                                Puedes descargar el formato del excel: <a href="CoordinadorServlet?action=descargarFormatoExcel&nombreArchivo=modeloExcel_onuMujeres.xlsx">aquí</a>

                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-uniform">Subir Respuestas</button>
                    </form>
                </div>

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

        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>

<script src="${pageContext.request.contextPath}/onu_mujeres/static/js/app.js"></script>
<script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        feather.replace();
    });
</script>
</body>
</html>