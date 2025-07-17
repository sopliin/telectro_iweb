<%@ page import="org.example.onu_mujeres_crud.beans.Zona" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Distrito" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="listaDistritos" type="java.util.ArrayList<org.example.onu_mujeres_crud.beans.Distrito>" scope="request"/>
<% Usuario user = (Usuario) session.getAttribute("usuario"); %>
<%
    Map<Integer, Zona> zonasMap = new LinkedHashMap<>();
    for (Distrito distrito : listaDistritos) {
        Zona zona = distrito.getZona();
        zonasMap.putIfAbsent(zona.getZonaId(), zona);
    }
    List<Zona> zonasUnicas = new ArrayList<>(zonasMap.values());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Nuevo Coordinador - Administrador</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

        .form-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-top: 1rem;
        }

        .form-title {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .btn-submit {
            background-color: #3498db;
            border: none;
            transition: all 0.3s;
        }

        .btn-submit:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }

        .form-label {
            font-weight: 500;
            color: #2c3e50;
        }

        .form-control, .form-select {
            border-radius: 0.375rem;
            border: 1px solid #ced4da;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .form-control:focus, .form-select:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
        }

        .nombre {
            font-weight: bold;
        }

        .rol {
            font-size: 0.9em;
            color: #888;
        }



        .botones-container {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-top: 2rem;
        }

        @media (min-width: 768px) {
            .botones-container {
                flex-direction: row;
                justify-content: space-between;
                align-items: center;
            }
        }

        .btn-volver {
            width: 100%;
        }

        @media (min-width: 768px) {
            .btn-volver {
                width: auto;
            }
        }

        .botones-derecha {
            display: flex;
            gap: 0.75rem;
            width: 100%;
        }

        @media (min-width: 768px) {
            .botones-derecha {
                width: auto;
            }
        }

        .btn-accion {
            flex: 1;
        }

        @media (min-width: 768px) {
            .btn-accion {
                flex: none;
                padding: 0.5rem 1.25rem;
            }
        }




        .btn-volver {
            background-color: #6c757d; /* Gris */
            color: white;
            border: none;
            border-radius: 0.375rem;
            padding: 0.5rem 1.25rem;
            transition: all 0.3s ease;
        }

        .btn-volver:hover {
            background-color: #5a6268; /* Gris oscuro */
            color: white;
            transform: translateY(-1px);
        }

        .btn-registrar {
            background-color: #3498db; /* Azul */
            color: white;
            border: none;
            border-radius: 0.375rem;
            padding: 0.5rem 1.25rem;
            transition: all 0.3s ease;
        }

        .btn-registrar:hover {
            background-color: #2980b9; /* Azul oscuro */
            color: white;
            transform: translateY(-1px);
        }

        .btn-cancelar {
            background-color: #e74c3c; /* Rojo */
            color: white;
            border: none;
            border-radius: 0.375rem;
            padding: 0.5rem 1.25rem;
            transition: all 0.3s ease;
        }

        .btn-cancelar:hover {
            background-color: #c0392b; /* Rojo oscuro */
            color: white;
            transform: translateY(-1px);
        }

        /* Estilos para el hover en dispositivos táctiles */
        @media (hover: none) {
            .btn-volver:hover,
            .btn-registrar:hover,
            .btn-cancelar:hover {
                transform: none;
            }
        }




        .alert {
            padding: 0.75rem 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: 0.25rem;
        }
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .alert-dismissible {
            position: relative; /* Necesario para posicionar el botón de cierre */
            padding-right: 3.5rem; /* Espacio para el botón */
        }

        .btn-close {
            position: absolute;
            top: 0.75rem; /* Ajusta la posición vertical */
            right: 0.75rem; /* Lo coloca en el extremo derecho */
            padding: 0.5rem;
            background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 011.414 0L8 6.586 14.293.293a1 1 0 111.414 1.414L9.414 8l6.293 6.293a1 1 0 01-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 01-1.414-1.414L6.586 8 .293 1.707a1 1 0 010-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
            border: 0;
            opacity: 0.5;
            cursor: pointer;
        }

        .btn-close:hover {
            opacity: 0.75;
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
            <a class="sidebar-brand" href="AdminServlet?action=dashboard">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">Menú del administrador</li>
                <li class="sidebar-item ">
                    <a class="sidebar-link" href="AdminServlet?action=dashboard">
                        <i class="align-middle" data-feather="pie-chart"></i> <span
                            class="align-middle">Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="AdminServlet?action=listaUsuarios">
                        <i class="align-middle" data-feather="user-check"></i> <span
                            class="align-middle">Usuarios</span>
                    </a>
                </li>
                <li class="sidebar-item <%= (request.getParameter("action") == null || request.getParameter("action").equals("nuevoCoordinador")) ? "active" : "" %>">
                    <a class="sidebar-link" href="AdminServlet?action=nuevoCoordinador">
                        <i class="align-middle" data-feather="user-plus"></i> <span class="align-middle">Crear coordinadores</span>
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
                            <a class="dropdown-item" href="AdminServlet?action=verPerfil"><i class="align-middle me-1" data-feather="user"></i> Ver Perfil</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>

        <main class="content">
            <div class="container-fluid p-0">
                <h1 class="h2">
                    <i class="bi bi-person-plus me-2"></i>Registrar Nuevo Coordinador
                </h1>

            </div>

            <!-- Mensajes de error -->
            <% if (request.getSession().getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= request.getSession().getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
            <% request.getSession().removeAttribute("error"); %>
            <% } %>

            <% if (request.getSession().getAttribute("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= request.getSession().getAttribute("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
            <% request.getSession().removeAttribute("success"); %>
            <% } %>

            <!-- Formulario -->
            <div class="form-container">
                <form action="AdminServlet?action=crearCoordinador" method="post">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="nombre" class="form-label">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label for="apellidoPaterno" class="form-label">Apellido Paterno:</label>
                            <input type="text" id="apellidoPaterno" name="apellidoPaterno" class="form-control"
                                   required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="apellidoMaterno" class="form-label">Apellido Materno:</label>
                            <input type="text" id="apellidoMaterno" name="apellidoMaterno" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label for="dni" class="form-label">DNI:</label>
                            <input type="text" id="dni" name="dni" class="form-control"
                                   pattern="[0-9]{8}"
                                   title="Debe contener exactamente 8 dígitos numéricos"
                                   required>
                            <small id="dni-feedback" class="text-danger" style="display:none;"></small>
                            <small class="text-muted">Formato: 8 dígitos numéricos</small>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="correo" class="form-label">Correo Electrónico(@gmail.com)</label>
                            <input type="email" id="correo" name="correo" class="form-control"
                                   pattern="[a-z0-9._%+-]+@(gmail\.com|pucp\.edu\.pe)"
                                   title="Solo se permiten cuentas de Gmail (@gmail.com) o PUCP (@pucp.edu.pe)"
                                   required>
                            <small id="email-feedback" class="text-danger" style="display:none;"></small>
                            <small class="text-muted">Solo se permiten: @gmail.com o @pucp.edu.pe</small>
                        </div>
                        <div class="col-md-6">
                            <label for="confirmarCorreo" class="form-label">Confirmar Correo:</label>
                            <input type="email" id="confirmarCorreo" class="form-control" pattern="[a-z0-9._%+-]+@(gmail\.com|pucp\.edu\.pe)"
                                   title="Solo se permiten cuentas de Gmail (@gmail.com) o PUCP (@pucp.edu.pe)"
                                   required>
                            <small id="email-feedback1" class="text-danger" style="display:none;"></small>
                            <small class="text-muted">Solo se permiten: @gmail.com o @pucp.edu.pe</small>
                        </div>
                    </div>


                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="zonaId" class="form-label">Zona Asignada:</label>
                            <select id="zonaId" name="zonaId" class="form-select" required onchange="filtrarDistritos()">
                                <option value="">Seleccione una zona</option>
                                <% for (Zona zona : zonasUnicas) { %>
                                <option value="<%=zona.getZonaId()%>"><%=zona.getNombre()%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="distritoId" class="form-label">Distrito:</label>
                            <select id="distritoId" name="distritoId" class="form-select" required disabled>
                                <option value="">Seleccione primero una zona</option>
                            </select>
                        </div>
                    </div>

                    <div class="botones-container">
                        <a href="AdminServlet?action=listaUsuarios" class="btn btn-volver">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </a>

                        <div class="botones-derecha">
                            <button type="submit" class="btn btn-registrar">
                                <i class="bi bi-save me-1"></i> Registrar
                            </button>
                            <a href="AdminServlet?action=listaUsuarios" class="btn btn-cancelar">
                                <i class="bi bi-x-circle me-1"></i> Cancelar
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </main>
        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>
<script >
    document.getElementById('dni').addEventListener('input', function() {
        const emailRegex = /^[0-9]{8}$/;
        const feedback = document.getElementById('dni-feedback');

        if(this.value && !emailRegex.test(this.value)) {
            this.classList.add('is-invalid');
            feedback.textContent = 'Formato no válido. Dni debe tener 8 digitos';
            feedback.style.display = 'block';
        } else {
            this.classList.remove('is-invalid');
            feedback.style.display = 'none';
        }
    });

</script>
<script >
    document.getElementById('correo').addEventListener('input', function() {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@(gmail\.com|pucp\.edu\.pe)$/;
        const feedback = document.getElementById('email-feedback');

        if(this.value && !emailRegex.test(this.value)) {
            this.classList.add('is-invalid');
            feedback.textContent = 'Formato no válido. Use @gmail.com o @pucp.edu.pe';
            feedback.style.display = 'block';
        } else {
            this.classList.remove('is-invalid');
            feedback.style.display = 'none';
        }
    });
    document.getElementById('confirmarCorreo').addEventListener('input', function() {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@(gmail\.com|pucp\.edu\.pe)$/;
        const feedback = document.getElementById('email-feedback1');

        if(this.value && !emailRegex.test(this.value)) {
            this.classList.add('is-invalid');
            feedback.textContent = 'Formato no válido. Use @gmail.com o @pucp.edu.pe';
            feedback.style.display = 'block';
        } else {
            this.classList.remove('is-invalid');
            feedback.style.display = 'none';
        }
    });
</script>
<script >
    document.addEventListener('DOMContentLoaded', function() {
    // Inicializar toasts con Bootstrap
    const toastEl = document.getElementById('errorToast');
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl, {
            autohide: true,
            delay: 5000
        });
        toast.show();

        // Configurar el botón de cierre
        const closeButton = toastEl.querySelector('[data-bs-dismiss="toast"]');
        if (closeButton) {
            closeButton.addEventListener('click', function() {
                toast.hide();
            });
        }
    }});
</script>
<script>
    // Convertimos la lista de distritos a un array JavaScript
    const todosDistritos = [
        <% for (Distrito distrito : listaDistritos) { %>
        {
            id: <%=distrito.getDistritoId()%>,
            nombre: "<%=distrito.getNombre()%>",
            zonaId: <%=distrito.getZona().getZonaId()%>
        },
        <% } %>
    ];

    function filtrarDistritos() {
        const zonaId = document.getElementById('zonaId').value;
        const distritoSelect = document.getElementById('distritoId');

        // Limpiar opciones actuales
        distritoSelect.innerHTML = '';

        if (zonaId) {
            // Habilitar el select
            distritoSelect.disabled = false;

            // Agregar opción por defecto
            const defaultOption = new Option('Seleccione un distrito', '');
            distritoSelect.add(defaultOption);

            // Filtrar distritos por zonaId
            const distritosFiltrados = todosDistritos.filter(distrito => distrito.zonaId == zonaId);

            // Agregar opciones filtradas
            distritosFiltrados.forEach(distrito => {
                const option = new Option(distrito.nombre, distrito.id);
                distritoSelect.add(option);
            });
        } else {
            // Deshabilitar si no hay zona seleccionada
            distritoSelect.disabled = true;
            const defaultOption = new Option('Seleccione primero una zona', '');
            distritoSelect.add(defaultOption);
        }
    }
</script>
<script>
    // Validación de coincidencia de correos
    document.querySelector('form').addEventListener('submit', function (e) {
        const correo = document.getElementById('correo').value;
        const confirmarCorreo = document.getElementById('confirmarCorreo').value;
        const emailRegex = /^[a-zA-Z0-9._%+-]+@(gmail\.com|pucp\.edu\.pe)$/;

        if (correo !== confirmarCorreo) {
            e.preventDefault();
            alert('Los correos electrónicos no coinciden');
            return false;
        }

        if (!emailRegex.test(correo)) {
            e.preventDefault();
            alert('Formato de correo no válido. Solo se permiten @gmail.com o @pucp.edu.pe');
            return false;
        }

        return true;
    });

    // Cerrar alertas automáticamente después de 5 segundos
    setTimeout(function () {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function (alert) {
            new bootstrap.Alert(alert).close();
        });
    }, 5000);
</script>
<!-- Incluir estos scripts antes del cierre del body -->
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