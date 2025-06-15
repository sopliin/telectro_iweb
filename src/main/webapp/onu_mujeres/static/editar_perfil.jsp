<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Usuario, org.example.onu_mujeres_crud.beans.Distrito, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%Usuario user = (Usuario) session.getAttribute("usuario");%>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="ONU Mujeres - Editar Perfil">
  <meta name="author" content="ONU Mujeres">
  <meta name="keywords" content="onu, mujeres, encuestas, administración">

  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link rel="shortcut icon" href="img/icons/icon-48x48.png" />

  <title>Editar Perfil - ONU Mujeres</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/css/app.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
    .profile-container {
      max-width: 600px;
      margin: 0 auto;
      padding: 2rem;
      background: white;
      border-radius: 0.5rem;
      box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
    }
  </style>
</head>
<body>
<script type="text/javascript" src="js/app.js"></script>
<div class="wrapper">
  <nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
      <a class="sidebar-brand" href="EncuestadorServlet?action=total">
        <span class="align-middle">ONU Mujeres</span>
      </a>

      <ul class="sidebar-nav">
        <li class="sidebar-header">
          Encuestas
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="EncuestadorServlet?action=total">
            <i class="align-middle" data-feather="list"></i> <span class="align-middle">Encuestas totales</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="EncuestadorServlet?action=terminados">
            <i class="align-middle" data-feather="check"></i> <span class="align-middle">Encuestas completadas</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="EncuestadorServlet?action=borradores">
            <i class="align-middle" data-feather="save"></i> <span class="align-middle">Encuestas en progreso</span>
          </a>
        </li>

        <li class="sidebar-item">
          <a class="sidebar-link" href="EncuestadorServlet?action=pendientes">
            <i class="align-middle" data-feather="edit-3"></i> <span class="align-middle">Encuestas por hacer</span>
          </a>
        </li>

        <li class="sidebar-header">
          Perfil
        </li>

        <li class="sidebar-item active">
          <a class="sidebar-link" href="EncuestadorServlet?action=ver">
            <i class="align-middle" data-feather="user"></i> <span class="align-middle">Mi Perfil</span>
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
              <img src="<%=request.getContextPath()%>/fotos/<%=user.getProfilePhotoUrl() %>" class="avatar img-fluid rounded me-1" alt="<%=user.getNombre()%>" />
              <span class="text-dark"><%=user.getNombre()+" "+user.getApellidoPaterno() %>(<%=user.getRol() != null ?
                      user.getRol().getNombre().substring(0, 1).toUpperCase() + user.getRol().getNombre().substring(1).toLowerCase() : ""%>)</span>
            </a>
            <div class="dropdown-menu dropdown-menu-end">
              <a class="dropdown-item" href="EncuestadorServlet?action=ver"><i class="align-middle me-1" data-feather="eye"></i> Perfil</a>
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
          <h1 class="h3 d-inline align-middle">Editar Perfil</h1>
        </div>

        <div class="row">
          <div class="col-12">
            <div class="profile-container">
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

              <form action="EncuestadorServlet?action=updateProfile" method="post">
                <div class="mb-3">
                  <label for="direccion" class="form-label">Dirección</label>
                  <input type="text" class="form-control" id="direccion" name="direccion"
                         value="${usuario.direccion}" required>
                </div>

                <div class="mb-3">
                  <label for="distrito" class="form-label">Distrito</label>
                  <select class="form-select" id="distrito" name="distrito" required>
                    <option value="">Seleccione un distrito</option>
                    <%
                      ArrayList<Distrito> distritos = (ArrayList<Distrito>) request.getAttribute("distritos");
                      Usuario usuario = (Usuario) session.getAttribute("usuario");
                      for (Distrito distrito : distritos) {
                    %>
                    <option value="<%= distrito.getDistritoId() %>"
                            <%= usuario.getDistrito() != null && usuario.getDistrito().getDistritoId() == distrito.getDistritoId() ? "selected" : "" %>>
                      <%= distrito.getNombre() %>
                    </option>
                    <% } %>
                  </select>
                </div>

                <div class="d-grid gap-2">
                  <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                  <a href="EncuestadorServlet?action=ver" class="btn btn-secondary">Volver al perfil</a>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </main>

    <jsp:include page="../../includes/footer.jsp"/>
  </div>
</div>

<script src="js/app.js"></script>
<script type="text/javascript" src="js/app.js"></script>

<script type="text/javascript" src="http://localhost:8080/onu_mujeres_crud_war_exploded/onu_mujeres/static/js/app.js"></script>
</body>
</html>