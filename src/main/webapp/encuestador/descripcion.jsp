<%@ page import="org.example.onu_mujeres_crud.beans.Usuario" %>
<%@ page import="org.example.onu_mujeres_crud.beans.Encuesta" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Encuesta encuesta = (Encuesta) request.getAttribute("detalles");
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Perfil de usuario</title>
    <link href="<%=request.getContextPath()%>/onu_mujeres/static/css/app.css" rel="stylesheet">
    <style>
        .profile-card {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            border-radius: 1rem;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .profile-photo {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 1rem;
            border: 4px solid #0d6efd;
        }
    </style>
</head>
<body>
<main class="content">
    <div class="container">
        <div class="profile-card">


            <div class="profile-info">
                <strong>Descripción:</strong> <%= encuesta.getDescripcion() %>


            </div>
        </div>
    </div>
</main>
<script src="<%=request.getContextPath()%>/onu_mujeres/static/js/app.js"></script>
</body>
</html>
