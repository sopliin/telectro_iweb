<%@ page import="org.example.onu_mujeres_crud.beans.BancoPreguntas" %>
<%@ page import="org.example.onu_mujeres_crud.beans.PreguntaOpcion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%Usuario user = (Usuario) session.getAttribute("usuario");%>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="ONU Mujeres - Encuestas">
    <meta name="author" content="ONU Mujeres">
    <meta name="keywords" content="onu, mujeres, encuestas, formularios">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="img/icons/icon-48x48.png"/>

    <title>ONU Mujeres - Completa la Encuesta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
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
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
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

        .question-card {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            background-color: #f9f9f9;
        }

        .form-group {
            margin-bottom: 15px;
        }


        .is-invalid {
            border-color: #dc3545 !important;
        }

        .invalid-feedback {
            color: #dc3545;
            font-size: 0.875em;
            display: none;
        }

        .invalid-feedback.d-block {
            display: block;
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
            <a class="sidebar-brand" href="<%=request.getContextPath()%>/EncuestadorServlet?action=total">
                <span class="align-middle">ONU Mujeres</span>
            </a>
            <ul class="sidebar-nav">
                <li class="sidebar-header">
                    Encuestas
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="<%=request.getContextPath()%>/EncuestadorServlet?action=total">
                        <i class="align-middle" data-feather="list"></i> <span
                            class="align-middle">Encuestas totales</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="<%=request.getContextPath()%>/EncuestadorServlet?action=terminados">
                        <i class="align-middle" data-feather="check"></i> <span class="align-middle">Encuestas completadas</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="<%=request.getContextPath()%>/EncuestadorServlet?action=borradores">
                        <i class="align-middle" data-feather="save"></i> <span class="align-middle">Encuestas en progreso</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a class="sidebar-link" href="<%=request.getContextPath()%>/EncuestadorServlet?action=pendientes">
                        <i class="align-middle" data-feather="edit-3"></i> <span class="align-middle">Encuestas por hacer</span>
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
                            <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl()%>"
                                 class="avatar img-fluid rounded me-2" alt="Foto"/>
                            <div class="d-inline-block">
                                <div class="nombre">
                                    <span class="text-dark d-block"><%=user.getNombre()%> <%=user.getApellidoPaterno()%></span>
                                </div>
                                <div class="rol">
                                    <small class="text-muted d-block text-uppercase"><%= user.getRol() != null ? user.getRol().getNombre() : "ROL DESCONOCIDO" %>
                                    </small>
                                </div>
                            </div>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1"
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
                <div class="mb-3">
                    <h1 class="h3 d-inline align-middle">Complete la Encuesta</h1>
                </div>

                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <%-- Sección para mostrar mensajes de éxito o error --%>
                                <%
                                    String success = (String) request.getParameter("success");
                                    if (success != null) {
                                        if (success.equals("encuestaCompletada")) {
                                %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ¡Encuesta completada y guardada exitosamente!
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Cerrar"></button>
                                </div>

                                <%
                                } else if (success.equals("borradorGuardado")) {
                                %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ¡Borrador de encuesta guardado exitosamente!
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Cerrar"></button>
                                </div>

                                <%
                                        }
                                    }
                                    String error = (String) request.getAttribute("error");
                                    if (error != null) {
                                %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <%= error %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Cerrar"></button>
                                </div>
                                <%
                                    }
                                %>

                                <%
                                    // Obtener asignacionId para el botón de cargar, si existe
                                    Integer asignacionIdForLoad = (Integer) request.getAttribute("asignacionId");
                                %>

                                <div class="mb-3">
                                    <% if (asignacionIdForLoad != null) { %>
                                    <a href="ContenidoEncuestaServlet?action=mostrar&asignacionId=<%= asignacionIdForLoad %>"
                                       class="btn btn-info">Cargar Respuestas Guardadas</a>
                                    <% } else { %>
                                    <p class="text-muted">No se puede cargar respuestas sin un ID de asignación.</p>
                                    <% } %>
                                </div>

                                <form action="ContenidoEncuestaServlet" method="post">
                                    <%
                                        // El asignacionId se pasa desde el Servlet fijado a 1
                                        Integer asignacionId = (Integer) request.getAttribute("asignacionId");
                                        System.out.println(asignacionId);
                                        if (asignacionId != null) {
                                    %>
                                    <input type="hidden" name="asignacionId" value="<%= asignacionId %>">
                                    <%
                                        }

                                        // Obtener respuestas existentes (para prellenar el formulario)
                                        Map<Integer, List<String>> respuestasUsuarioOpciones = (Map<Integer, List<String>>) request.getAttribute("respuestasUsuarioOpciones");
                                        if (respuestasUsuarioOpciones == null) {
                                            respuestasUsuarioOpciones = new HashMap<>(); // Inicializar si es null
                                        }
                                        Map<Integer, String> respuestasUsuarioTextoNumerico = (Map<Integer, String>) request.getAttribute("respuestasUsuarioTextoNumerico");
                                        if (respuestasUsuarioTextoNumerico == null) {
                                            respuestasUsuarioTextoNumerico = new HashMap<>(); // Inicializar si es null
                                        }

                                        // Obtener DNI y Fecha de Inicio para prellenar
                                        String dniValue = (String) request.getAttribute("dniEncuestadoBorrador");
                                        if (dniValue == null) {
                                            dniValue = ""; // Si no hay borrador, el campo DNI estará vacío
                                        }

                                        String fechaInicioValue = (String) request.getAttribute("fechaInicioBorrador");
                                        if (fechaInicioValue == null || fechaInicioValue.isEmpty()) {
                                            // Si no hay borrador, establecer la fecha actual al cargar el formulario
                                            fechaInicioValue = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                                        }
                                    %>
                                    <div class="mb-3">
                                        <label for="dniEncuestado" class="form-label">DNI del Encuestado:</label>
                                        <input type="text" class="form-control" id="dniEncuestado" name="dniEncuestado"
                                               value="<%= dniValue %>"
                                               maxlength="8"
                                               oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                        <!-- Este div mostrará el error -->
                                        <div class="invalid-feedback"></div>
                                    </div>

                                    <input type="hidden" name="fechaInicio" value="<%= fechaInicioValue %>">

                                    <%
                                        ArrayList<BancoPreguntas> preguntasEncuesta = (ArrayList<BancoPreguntas>) request.getAttribute("preguntasEncuesta");
                                        if (preguntasEncuesta != null && !preguntasEncuesta.isEmpty()) {
                                            int questionCounter = 1;
                                            for (BancoPreguntas pregunta : preguntasEncuesta) {
                                    %>
                                    <% if (questionCounter == 1) {%>
                                    <h4 class="mt-4 mb-3">A. DATOS DE LA ENTREVISTA</h4>
                                    <%}%>
                                    <% if (questionCounter == 3) {%>
                                    <h4 class="mt-4 mb-3">B. DATOS DEL TERRITORIO</h4>
                                    <%}%>
                                    <% if (questionCounter == 5) {%>
                                    <h4 class="mt-4 mb-3">C. DATOS DE LA PERSONA ENTREVISTADA (Cuidadora no
                                        remunerada)</h4>
                                    <%}%>
                                    <% if (questionCounter == 9) {%>
                                    <h4 class="mt-4 mb-3">D. DATOS SOBRE NIÑOS Y NIÑAS</h4>
                                    <%}%>
                                    <% if (questionCounter == 13) {%>
                                    <h4 class="mt-4 mb-3">E. DATOS SOBRE PERSONAS ADULTAS MAYORES (mayores de 60
                                        años)</h4>
                                    <%}%>
                                    <% if (questionCounter == 17) {%>
                                    <h4 class="mt-4 mb-3">F. DATOS SOBRE PERSONAS CON DISCAPACIDAD Y/O ENFERMEDAD
                                        CRÓNICA</h4>
                                    <%}%>
                                    <% if (questionCounter == 21) {%>
                                    <h4 class="mt-4 mb-3">G. DATOS SOBRE TRABAJADORAS DEL HOGAR REMUNERADA</h4>
                                    <%}%>
                                    <% if (questionCounter == 25) {%>
                                    <h4 class="mt-4 mb-3">H. DATOS SOBRE TRABAJADORAS DEL HOGAR REMUNERADA</h4>
                                    <%}%>
                                    <% if (questionCounter == 29) {%>
                                    <h4 class="mt-4 mb-3">OBSERVACIONES</h4>
                                    <%}%>
                                    <div class="question-card">
                                        <h5><%= questionCounter++ %>. <%= pregunta.getTexto() %>
                                        </h5>
                                        <div class="form-group">
                                            <%
                                                String tipoPregunta = pregunta.getTipo();
                                                int preguntaId = pregunta.getPreguntaId();

                                                switch (tipoPregunta) {
                                                    case "abierta":
                                                        String respuestaAbierta = respuestasUsuarioTextoNumerico.getOrDefault(preguntaId, "");
                                            %>
                                            <% if (preguntaId == 1) { %>
                                            <input type="datetime-local" class="form-control" name="respuesta_<%= preguntaId %>"
                                                   value="<%= !respuestaAbierta.isEmpty() ? respuestaAbierta : LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) %>" required>
                                            <% } else { %>
                                            <textarea class="form-control" name="respuesta_<%= preguntaId %>" rows="3"
                                                      placeholder="Escriba su respuesta aquí"><%= respuestaAbierta %></textarea>
                                            <% } %>
                                            <%
                                                    break;
                                                case "numerica":
                                                    String respuestaNumerica = respuestasUsuarioTextoNumerico.getOrDefault(preguntaId, "");
                                            %>
                                            <input type="text" class="form-control"
                                            name="respuesta_<%= preguntaId %>"
                                            placeholder="Ingrese un número"
                                            value="<%= !respuestaNumerica.isEmpty() ? Integer.parseInt(respuestaNumerica) : "0" %>"
                                            oninput="this.value = this.value.replace(/[^0-9]/g, ''); this.value = this.value === '' ? '0' : parseInt(this.value, 10).toString()">
                                            <%
                                                    break;
                                                case "opcion_unica":
                                                    ArrayList<PreguntaOpcion> opcionesUnica = (ArrayList<PreguntaOpcion>) request.getAttribute("opciones_" + preguntaId);
                                                    List<String> selectedOptionUnica = respuestasUsuarioOpciones.getOrDefault(preguntaId, new ArrayList<>());

                                                    if (opcionesUnica != null && !opcionesUnica.isEmpty()) {
                                                        for (PreguntaOpcion opcion : opcionesUnica) {
                                                            boolean isChecked = selectedOptionUnica.contains(String.valueOf(opcion.getOpcionId()));
                                            %>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio"
                                                       name="opcion_<%= preguntaId %>"
                                                       id="opcion_<%= opcion.getOpcionId() %>"
                                                       value="<%= opcion.getOpcionId() %>" <%= isChecked ? "checked" : "" %>
                                                       onclick="toggleRadioButton(this, 'opcion_<%= preguntaId %>')">
                                                <label class="form-check-label"
                                                       for="opcion_<%= opcion.getOpcionId() %>">
                                                    <%= opcion.getTextoOpcion() %>
                                                </label>
                                            </div>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <p class="text-danger">No hay opciones disponibles para esta pregunta.</p>
                                            <%
                                                    }
                                                    break;
                                                case "opcion_multiple":
                                                    ArrayList<PreguntaOpcion> opcionesMultiple = (ArrayList<PreguntaOpcion>) request.getAttribute("opciones_" + preguntaId);
                                                    List<String> selectedOptionsMultiple = respuestasUsuarioOpciones.getOrDefault(preguntaId, new ArrayList<>());

                                                    if (opcionesMultiple != null && !opcionesMultiple.isEmpty()) {
                                                        for (PreguntaOpcion opcion : opcionesMultiple) {
                                                            boolean isChecked = selectedOptionsMultiple.contains(String.valueOf(opcion.getOpcionId()));
                                            %>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox"
                                                       name="opcion_<%= preguntaId %>"
                                                       id="opcion_<%= opcion.getOpcionId() %>"
                                                       value="<%= opcion.getOpcionId() %>" <%= isChecked ? "checked" : "" %>>
                                                <label class="form-check-label"
                                                       for="opcion_<%= opcion.getOpcionId() %>">
                                                    <%= opcion.getTextoOpcion() %>
                                                </label>
                                            </div>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <p class="text-danger">No hay opciones disponibles para esta pregunta.</p>
                                            <%
                                                    }
                                                    break;
                                                default:
                                            %>
                                            <p class="text-warning">Tipo de pregunta no soportado.</p>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <div class="alert alert-warning">No hay preguntas disponibles para esta encuesta.
                                    </div>
                                    <%
                                        }
                                    %>

                                    <div class="mt-4">
                                        <button type="submit" name="action" value="guardarCompleta"
                                                class="btn btn-success me-2">Guardar Encuesta
                                        </button>
                                        <button type="submit" name="action" value="guardarBorrador"
                                                class="btn btn-secondary">Guardar Borrador
                                        </button>
                                        <button type="button" id="btnBorrarTodo" class="btn btn-danger">Borrar Todo
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="../includes/footer.jsp"/>
    </div>
</div>
<script>
    function toggleRadioButton(radio, groupName) {
        // Si el radio ya está seleccionado
        if (radio.checked && radio.dataset.lastState === 'checked') {
            radio.checked = false;
            radio.dataset.lastState = '';
        } else {
            // Guarda el estado actual
            radio.dataset.lastState = 'checked';

            // Desmarca otros radios del mismo grupo
            document.querySelectorAll(`input[name="${groupName}"]`).forEach(r => {
                if (r !== radio) {
                    r.dataset.lastState = '';
                }
            });
        }
    }
</script>
<script>
    document.getElementById('btnBorrarTodo').addEventListener('click', function () {
        if (confirm('¿Estás seguro de que quieres borrar todas las respuestas?')) {
            // Limpiar campos de texto y textarea
            const textInputs = document.querySelectorAll('input[type="text"], input[type="number"], textarea');
            textInputs.forEach(input => {
                input.value = '';
            });

            // Desmarcar radio buttons
            const radioButtons = document.querySelectorAll('input[type="radio"]');
            radioButtons.forEach(radio => {
                radio.checked = false;
            });

            // Desmarcar checkboxes
            const checkboxes = document.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = false;
            });

            // Limpiar el DNI del encuestado
            document.getElementById('dniEncuestado').value = '';
        }
    });
</script>
<script>
    // Función para manejar el comportamiento de los radio buttons
    function toggleRadioButton(radio, groupName) {
        // Si el radio ya está seleccionado
        if (radio.checked && radio.dataset.lastState === 'checked') {
            radio.checked = false;
            radio.dataset.lastState = '';
        } else {
            // Guarda el estado actual
            radio.dataset.lastState = 'checked';

            // Desmarca otros radios del mismo grupo
            document.querySelectorAll(`input[name="${groupName}"]`).forEach(r => {
                if (r !== radio) {
                    r.dataset.lastState = '';
                }
            });
        }
    }

    // Validación adicional para campos numéricos
    document.addEventListener('DOMContentLoaded', function() {
        // Asegurar que los campos numéricos no sean negativos
        document.querySelectorAll('input[type="number"]').forEach(input => {
            input.addEventListener('change', function() {
                if (this.value < 0) {
                    this.value = 0;
                }
                if (this.value === '') {
                    this.value = 0;
                }
            });
        });

        // Formatear fecha inicial para la pregunta 1 si está vacía
        const fechaInput = document.querySelector('input[type="datetime-local"][name^="respuesta_1"]');
        if (fechaInput && !fechaInput.value) {
            const now = new Date();
            const timezoneOffset = now.getTimezoneOffset() * 60000;
            const localISOTime = (new Date(now - timezoneOffset)).toISOString().slice(0, 16);
            fechaInput.value = localISOTime;
        }
    });
</script>
<script>
    document.querySelector('form').addEventListener('submit', function(event) {
        const action = document.activeElement.value; // Obtener qué botón se clickeó
        const dniInput = document.getElementById('dniEncuestado');

        // Solo validar DNI si es "guardarCompleta"
        if (action === 'guardarCompleta') {
            dniInput.removeAttribute('formnovalidate'); // Habilitar validación HTML5
            if (!/^\d{8}$/.test(dniInput.value)) {
                dniInput.classList.add('is-invalid');
                event.preventDefault();
                return;
            }
        } else {
            dniInput.setAttribute('formnovalidate', 'true'); // Desactivar validación
        }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const dniInput = document.getElementById('dniEncuestado');
        const btnGuardarCompleto = document.querySelector('button[value="guardarCompleta"]');

        // Validación al hacer clic en "Guardar Encuesta"
        btnGuardarCompleto.addEventListener('click', function(e) {
            if (!validarDNI()) {
                e.preventDefault(); // Detener el envío del formulario
                mostrarErrorDNI("❌ El DNI debe tener 8 dígitos numéricos");
            }
        });

        // Función para validar DNI
        function validarDNI() {
            const dniValue = dniInput.value.trim();
            return /^\d{8}$/.test(dniValue);
        }

        // Mostrar mensaje de error
        function mostrarErrorDNI(mensaje) {
            // Eliminar errores previos
            let errorDiv = dniInput.nextElementSibling;
            if (!errorDiv || !errorDiv.classList.contains('invalid-feedback')) {
                errorDiv = document.createElement('div');
                errorDiv.className = 'invalid-feedback d-block';
                dniInput.parentNode.appendChild(errorDiv);
            }
            errorDiv.textContent = mensaje;
            dniInput.classList.add('is-invalid');

            // Scroll al campo con error
            dniInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Limpiar error al escribir
        dniInput.addEventListener('input', function() {
            if (this.classList.contains('is-invalid')) {
                this.classList.remove('is-invalid');
                const errorDiv = this.nextElementSibling;
                if (errorDiv && errorDiv.classList.contains('invalid-feedback')) {
                    errorDiv.textContent = '';
                }
            }
        });
    });
</script>
<script>
    document.querySelectorAll('input[name^="respuesta_"]').forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value !== '') {
                this.value = parseInt(this.value, 10).toString(); // Elimina ceros al perder foco
            }
        });
    });
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
</body>

</html>