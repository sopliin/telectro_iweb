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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
</head>
<body>
<div class="wrapper">
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" href="AdminServlet?action=dashboard">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">Menu del administrador</li>
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
                        <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>"
                                 class="avatar img-fluid rounded me-1" alt="Foto"/>
                            <span class="text-dark"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="AdminServlet?action=verPerfil"><i class="align-middle me-1"
                                                                                             data-feather="user"></i>
                                Ver Perfil</a>
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
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="AdminServlet?action=listaUsuarios" class="btn btn-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Volver
                    </a>
                </div>
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
                            <input type="text" id="apellidoMaterno" name="apellidoMaterno" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label for="dni" class="form-label">DNI:</label>
                            <input type="text" id="dni" name="dni" class="form-control"
                                   pattern="[0-9]{8}"
                                   title="Debe contener exactamente 8 dígitos numéricos"
                                   required>
                            <small class="text-muted">Formato: 8 dígitos numéricos</small>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="correo" class="form-label">Correo Electrónico:</label>
                            <input type="email" id="correo" name="correo" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label for="confirmarCorreo" class="form-label">Confirmar Correo:</label>
                            <input type="email" id="confirmarCorreo" class="form-control" required>
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

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <button type="submit" class="btn btn-primary btn-submit me-md-2">
                            <i class="bi bi-save me-1"></i> Registrar Coordinador
                        </button>
                        <a href="AdminServlet?action=listaUsuarios" class="btn btn-secondary">
                            <i class="bi bi-x-circle me-1"></i> Cancelar
                        </a>
                    </div>
                </form>
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
<script type="text/javascript" src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>
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

        if (correo !== confirmarCorreo) {
            e.preventDefault();
            alert('Los correos electrónicos no coinciden');
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
</body>
</html>