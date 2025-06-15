<%@page import="java.util.ArrayList" %>
<%@ page import="org.example.onu_mujeres_crud.beans.BancoPreguntas" %>
<%@ page import="org.example.onu_mujeres_crud.beans.PreguntaOpcion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
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
  <link rel="shortcut icon" href="img/icons/icon-48x48.png" />

  <title>ONU Mujeres - Completa la Encuesta</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
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
            <i class="align-middle" data-feather="sliders"></i> <span class="align-middle">Encuestas totales</span>
          </a>
        </li>

        <li class="sidebar-item active">
          <a class="sidebar-link" href="<%=request.getContextPath()%>/EncuestadorServlet?action=terminados">
            <i class="align-middle" data-feather="book"></i> <span class="align-middle">Encuestas completadas</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="<%=request.getContextPath()%>/EncuestadorServlet?action=borradores">
            <i class="align-middle" data-feather="book"></i> <span class="align-middle">Encuestas en progreso</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="<%=request.getContextPath()%>/EncuestadorServlet?action=pendientes">
            <i class="align-middle" data-feather="book"></i> <span class="align-middle">Encuestas por hacer</span>
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
            <a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#" data-bs-toggle="dropdown">
              <i class="align-middle" data-feather="settings"></i>
            </a>
            <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
              <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" class="avatar img-fluid rounded me-1" alt="Charles Hall" />
              <span class="text-dark"><%=user.getNombre()+" "+user.getApellidoPaterno() %>(<%=user.getRol() != null ?
                      user.getRol().getNombre().substring(0, 1).toUpperCase() + user.getRol().getNombre().substring(1).toLowerCase() : ""%>)</span>
            </a>
            <div class="dropdown-menu dropdown-menu-end">
              <a class="dropdown-item" href="<%=request.getContextPath()%>/EncuestadorServlet?action=ver"><i class="align-middle me-1" data-feather="pie-chart"></i> Ver Perfil</a>
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
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                  </div>

                <%
                } else if (success.equals("borradorGuardado")) {
                %>
                  <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ¡Borrador de encuesta guardado exitosamente!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                  </div>

                <%
                    }
                  }
                  String error = (String) request.getAttribute("error");
                  if (error != null) {
                %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                  <%= error %>
                  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
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
                  <a href="ContenidoEncuestaServlet?action=mostrar&asignacionId=<%= asignacionIdForLoad %>" class="btn btn-info">Cargar Respuestas Guardadas</a>
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
                    <input type="text" class="form-control" id="dniEncuestado" name="dniEncuestado" value="<%= dniValue %>" required>
                  </div>

                  <input type="hidden" name="fechaInicio" value="<%= fechaInicioValue %>">

                  <%
                    ArrayList<BancoPreguntas> preguntasEncuesta = (ArrayList<BancoPreguntas>) request.getAttribute("preguntasEncuesta");
                    if (preguntasEncuesta != null && !preguntasEncuesta.isEmpty()) {
                      int questionCounter = 1;
                      for (BancoPreguntas pregunta : preguntasEncuesta) {
                  %>
                  <% if (questionCounter == 1){%>
                  <h4 class="mt-4 mb-3">A. DATOS DE LA ENTREVISTA</h4>
                  <%}%>
                  <% if (questionCounter == 3){%>
                  <h4 class="mt-4 mb-3">B. DATOS DEL TERRITORIO</h4>
                  <%}%>
                  <% if (questionCounter == 5){%>
                  <h4 class="mt-4 mb-3">C. DATOS DE LA PERSONA ENTREVISTADA (Cuidadora no remunerada)</h4>
                  <%}%>
                  <% if (questionCounter == 9){%>
                  <h4 class="mt-4 mb-3">D. DATOS SOBRE NIÑOS Y NIÑAS</h4>
                  <%}%>
                  <% if (questionCounter == 13){%>
                  <h4 class="mt-4 mb-3">E. DATOS SOBRE PERSONAS ADULTAS MAYORES (mayores de 60 años)</h4>
                  <%}%>
                  <% if (questionCounter == 17){%>
                  <h4 class="mt-4 mb-3">F. DATOS SOBRE PERSONAS CON DISCAPACIDAD Y/O ENFERMEDAD CRÓNICA</h4>
                  <%}%>
                  <% if (questionCounter == 21){%>
                  <h4 class="mt-4 mb-3">G. DATOS SOBRE TRABAJADORAS DEL HOGAR REMUNERADA</h4>
                  <%}%>
                  <% if (questionCounter == 25){%>
                  <h4 class="mt-4 mb-3">H. DATOS SOBRE TRABAJADORAS DEL HOGAR REMUNERADA</h4>
                  <%}%>
                  <% if (questionCounter == 29){%>
                  <h4 class="mt-4 mb-3">OBSERVACIONES</h4>
                  <%}%>
                  <div class="question-card">
                    <h5><%= questionCounter++ %>. <%= pregunta.getTexto() %></h5>
                    <div class="form-group">
                      <%
                        String tipoPregunta = pregunta.getTipo();
                        int preguntaId = pregunta.getPreguntaId();

                        switch (tipoPregunta) {
                          case "abierta":
                            String respuestaAbierta = respuestasUsuarioTextoNumerico.getOrDefault(preguntaId, "");
                      %>
                      <textarea class="form-control" name="respuesta_<%= preguntaId %>" rows="3" placeholder="Escriba su respuesta aquí"><%= respuestaAbierta %></textarea>
                      <%
                          break;
                        case "numerica":
                          String respuestaNumerica = respuestasUsuarioTextoNumerico.getOrDefault(preguntaId, "");
                      %>
                      <input type="number" class="form-control" name="respuesta_<%= preguntaId %>" placeholder="Ingrese un número" value="<%= respuestaNumerica %>">
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
                        <input class="form-check-input" type="radio" name="opcion_<%= preguntaId %>" id="opcion_<%= opcion.getOpcionId() %>" value="<%= opcion.getOpcionId() %>" <%= isChecked ? "checked" : "" %>>
                        <label class="form-check-label" for="opcion_<%= opcion.getOpcionId() %>">
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
                        <input class="form-check-input" type="checkbox" name="opcion_<%= preguntaId %>" id="opcion_<%= opcion.getOpcionId() %>" value="<%= opcion.getOpcionId() %>" <%= isChecked ? "checked" : "" %>>
                        <label class="form-check-label" for="opcion_<%= opcion.getOpcionId() %>">
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
                  <div class="alert alert-warning">No hay preguntas disponibles para esta encuesta.</div>
                  <%
                    }
                  %>

                  <div class="mt-4">
                    <button type="submit" name="action" value="guardarCompleta" class="btn btn-success me-2">Guardar Encuesta</button>
                    <button type="submit" name="action" value="guardarBorrador" class="btn btn-secondary">Guardar Borrador</button>
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

<script src="/onu_mujeres/static/js/app.js"></script>
<script type="text/javascript" src="/onu_mujeres/static/js/app.js"></script>
<script type="text/javascript" src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>
</body>
</html>