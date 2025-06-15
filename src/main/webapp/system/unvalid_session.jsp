<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>ONU Mujeres - Sesión Cerrada</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Estilos personalizados consistentes con login.jsp -->
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        .session-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 2rem;
        }

        .session-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            padding: 2rem;
            background: white;
        }

        .session-logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .session-logo img {
            height: 60px;
        }

        .session-title {
            text-align: center;
            margin-bottom: 1.5rem;
            color: #2c3e50;
        }

        .session-message {
            text-align: center;
            margin-bottom: 2rem;
            color: #6c757d;
        }

        .session-button {
            width: 100%;
            padding: 0.75rem;
            font-size: 1.1rem;
            border-radius: 5px;
        }

        .footer {
            text-align: center;
            margin-top: 2rem;
            color: #6c757d;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>
<main class="d-flex align-items-center min-vh-100 py-3">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="session-logo">
                    <img src="<%=request.getContextPath()%>/onu_mujeres/static/img/logo.png" alt="Logo ONU Mujeres">
                </div>

                <div class="card session-card">
                    <div class="card-body">
                        <h2 class="session-title">¡Sesión Cerrada!</h2>

                        <p class="session-message">
                            Su sesión ha finalizado o no tiene permisos para acceder a esta página.<br>
                            Por favor, inicie sesión nuevamente para continuar.
                        </p>

                        <div class="d-grid gap-2">
                            <a href="<%=request.getContextPath()%>/login" class="btn btn-primary session-button">
                                <i class="fas fa-sign-in-alt me-2"></i>Volver al Inicio de Sesión
                            </a>
                        </div>
                    </div>
                </div>

                <div class="footer mt-4">
                    <p>© ONU Mujeres - Todos los derechos reservados</p>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>