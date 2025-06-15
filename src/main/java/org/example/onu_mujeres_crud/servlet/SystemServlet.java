package org.example.onu_mujeres_crud.servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.onu_mujeres_crud.EmailSender;

import org.example.onu_mujeres_crud.beans.Distrito;
import org.example.onu_mujeres_crud.beans.Rol;
import org.example.onu_mujeres_crud.beans.Usuario;
import org.example.onu_mujeres_crud.daos.*;


import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;

@WebServlet(name = "SystemServlet", value ={"/login"} )
public class SystemServlet extends HttpServlet {

    private final TokenDAO tokenDao = new TokenDAO();
    private final UsuarioDAO userDao = new UsuarioDAO();
    private final EncuestadorDao encDao = new EncuestadorDao();
    private final DistritoDAO distritoDAO = new DistritoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "login" : request.getParameter("action");
        System.out.println("mi pagina es:"+ request.getContextPath());

        RequestDispatcher view;

        switch (action) {
            case "register":
                handleRegisterGet(request, response);
                break;

            case "confirm_account":
                view = request.getRequestDispatcher("/system/registrar_encuestador/confirm_account.jsp");
                view.forward(request, response);
                break;


            case "email_validation_sent":
                view = request.getRequestDispatcher("/system/registrar_encuestador/email_validation_sent.jsp");
                view.forward(request, response);
                break;


            case "validate_email":
                handleValidateEmail(request, response);
                break;

            case "create_password":
                handleCreatePasswordGet(request, response);
                break;

            case "registration_complete":
                view = request.getRequestDispatcher("/system/registrar_encuestador/registration_complete.jsp");
                view.forward(request, response);
                break;

            case "invalid_token":
                String email = request.getParameter("email");
                boolean tieneRegistroNoVerificado = false;

                if (email != null && !email.isEmpty()) {
                    Usuario user = userDao.usuarioByEmailNoVer(email);
                    tieneRegistroNoVerificado = (user != null && !user.isCorreoVerificado());
                }

                request.setAttribute("tieneRegistroNoVerificado", tieneRegistroNoVerificado);
                request.setAttribute("emailParam", email);
                view = request.getRequestDispatcher("/system/registrar_encuestador/invalid_token.jsp");
                view.forward(request, response);
                break;


//sesion finalizada
            case "unvalid_session":
                System.out.println("en servlet systema cerrada sesion");

                view = request.getRequestDispatcher("/system/unvalid_session.jsp");
                view.forward(request, response);
                System.out.println("en servlet systema cerrada sesion");
                break;


//recuperar contraseña
            case "forgot_password":
                // Verificar si ya hay una solicitud pendiente para este email
                String emailParam = request.getParameter("email");
                if (emailParam != null && !emailParam.isEmpty()) {
                    Usuario user = userDao.usuarioByEmail(emailParam);
                    if (user != null) {
                        // Verificar si hay tokens activos para este usuario
                        if (tokenDao.hasActiveTokenForUser(String.valueOf(user.getUsuarioId()))) {
                            request.setAttribute("pendingReset", true);
                            request.setAttribute("pendingEmail", emailParam);
                        }
                    }
                }
                view = request.getRequestDispatcher("/system/recuperar_contra/forgot_password.jsp");
                view.forward(request, response);
                break;

            case "reset_password":
                String token = request.getParameter("token");
                if (tokenDao.findToken(token)) {
                    request.setAttribute("token", token);
                    view = request.getRequestDispatcher("/system/recuperar_contra/reset_password.jsp");
                    view.forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() +"login?action=invalid_token_forgot");
                }
                break;


            case "reset_email_sent":
                view = request.getRequestDispatcher("/system/recuperar_contra/reset_email_sent.jsp");
                view.forward(request, response);
                break;
            case "invalid_token_forgot":
                String emailForgot = request.getParameter("email");
                boolean tieneRegistro = false;
                if (emailForgot != null && !emailForgot.isEmpty()) {
                    Usuario user = userDao.usuarioByEmail(emailForgot);
                    tieneRegistro = (user != null && user.isCorreoVerificado()); // Solo usuarios verificados pueden recuperar
                }
                request.setAttribute("tieneRegistro", tieneRegistro);
                request.setAttribute("emailParam", emailForgot);
                view = request.getRequestDispatcher("/system/recuperar_contra/invalid_token_forgot.jsp");
                view.forward(request, response);

                break;
            case "password_updated":
                view = request.getRequestDispatcher("/system/recuperar_contra/password_updated.jsp");
                view.forward(request, response);
                break;
            case "login":
                Usuario u = (Usuario) request.getSession().getAttribute("usuario");

                if (u != null && u.getUsuarioId() != 0) {

                    switch (u.getRol().getRolId()) {
                        case 1:

                            response.sendRedirect(request.getContextPath() +"/EncuestadorServlet");
                            break;
                        case 2:

                            response.sendRedirect(request.getContextPath() +"/CoordinadorServlet");
                            break;
                        case 3:
                            response.sendRedirect(request.getContextPath() +"/AdminServlet");
                            break;
                        default:
                            response.sendRedirect(request.getContextPath() +"/login");
                            System.out.println("444");
                            break;

                    }
                } else {
                    System.out.println("333");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);

                }
                break;

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") == null ? "auth" : request.getParameter("action");
//action vacio
        switch (action) {
            case "auth":
                response.sendRedirect(request.getContextPath() + "/login");
                break;
//logueo
            case "login":
                System.out.println("este es mi clave" + request.getParameter("email"));
                System.out.println("este es mi clave" + request.getParameter("passwd"));
                handleLogin(request, response);
                break;

            case "confirm_register":
                handleRegistration(request, response);
                break;
            case "resend_validation":
                System.out.println("Solicitud de reenvío recibida"); // Log de depuración
                String emailToResend = request.getParameter("email");
                System.out.println("Email recibido: " + emailToResend); // Log de depuración

                try {
                    if (emailToResend != null && !emailToResend.isEmpty()) {
                        Usuario user = userDao.usuarioByEmailNoVer(emailToResend);
                        if (user != null && !user.isCorreoVerificado()) {
                            // 1. Eliminar tokens antiguos
                            tokenDao.deleteTokensForEmail(emailToResend);

                            // 2. Generar nuevo token
                            String token = tokenDao.generateToken(emailToResend);
                            System.out.println("Token generado: " + token); // Log de depuración

                            // 3. Construir enlace
                            String baseUrl = request.getScheme() + "://" +
                                    request.getServerName() +
                                    (request.getServerPort() != 80 ? ":" + request.getServerPort() : "") +
                                    request.getContextPath();

                            String validationLink = baseUrl + "/login?action=validate_email&token=" + token;
                            System.out.println("Enlace generado: " + validationLink); // Log de depuración

                            // 4. Enviar email
                            String emailBody = "Por favor valide su correo haciendo clic en:\n" + validationLink;
                            System.out.println("Intentando enviar correo..."); // Log de depuración
                            EmailSender.sendEmail(emailToResend, "Validación de correo - ONU Mujeres", emailBody);
                            System.out.println("Correo enviado exitosamente"); // Log de depuración

                            response.setStatus(HttpServletResponse.SC_OK);
                            return;
                        }
                    }
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                } catch (Exception e) {
                    System.out.println("Error al reenviar correo:"); // Log de depuración
                    e.printStackTrace();
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
                break;


            case "save_password":
                handlePasswordCreation(request, response);
                break;

//cambio de contra
            case "send_reset_email":
                handleSendResetEmail(request, response);
                break;

            case "update_password":
                handleUpdatePassword(request, response);
                break;

            case "resend_reset_email":
                String resetEmail = request.getParameter("email");
                try {
                    if (resetEmail != null && !resetEmail.isEmpty()) {
                        Usuario user = userDao.usuarioByEmail(resetEmail);
                        if (user != null && user.isCorreoVerificado()) {
                            // 1. Eliminar tokens antiguos
                            tokenDao.deleteTokensForEmail(resetEmail);

                            // 2. Generar nuevo token
                            String newToken = tokenDao.generateToken(resetEmail);

                            // 3. Construir enlace
                            String baseUrl = request.getScheme() + "://" +
                                    request.getServerName() +
                                    (request.getServerPort() != 80 ? ":" + request.getServerPort() : "") +
                                    request.getContextPath();

                            String resetLink = baseUrl + "/login?action=reset_password&token=" + newToken;

                            // 4. Enviar email
                            String emailBody = "Para restablecer tu contraseña, haz clic en el siguiente enlace:\n" + resetLink;
                            EmailSender.sendEmail(resetEmail, "Restablecer contraseña - ONU Mujeres", emailBody);

                            response.setStatus(HttpServletResponse.SC_OK);
                            return;
                        }
                    }
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
                break;


            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }

    //de doget
    private void handleRegisterGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<Distrito> distritos = distritoDAO.obtenerListaDistritos();
        request.setAttribute("distritos", distritos);
        RequestDispatcher view = request.getRequestDispatcher("/system/registrar_encuestador/register.jsp");
        view.forward(request, response);
    }


    private void handleValidateEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String validationToken = request.getParameter("token");
        if (tokenDao.findToken(validationToken)) {
            response.sendRedirect(request.getContextPath() + "/login?action=create_password&token=" + validationToken);
        } else {
            response.sendRedirect(request.getContextPath() + "/login?action=invalid_token");
        }
    }

    private void handleCreatePasswordGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        if (tokenDao.findToken(token)) {
            request.setAttribute("token", token);
            RequestDispatcher view = request.getRequestDispatcher("/system/registrar_encuestador/create_password.jsp");
            view.forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login?action=invalid_token");
        }
    }

//de dopost

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mailStr = request.getParameter("email");
        String passwdStr = request.getParameter("passwd");
        Usuario user = userDao.usuarioByEmailNoVer1(mailStr);
        System.out.println("tengo en byemailnover1 " + mailStr);
        if (user == null) {
            // Usuario no existe
            System.out.println("no entra primero");
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("msgErrorLogin", "Usuario o contraseña incorrecto");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Verificar estado de la cuenta
        if ("baneado".equalsIgnoreCase(user.getEstado())) {
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("msgErrorLogin", "Su cuenta está baneada. Por favor, contacte al administrador.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Verificar correo electrónico
        if (!user.isCorreoVerificado()) {
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("msgErrorLogin", "Por favor verifique su correo electrónico antes de iniciar sesión.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        if (userDao.login(mailStr, passwdStr)) {

            Usuario user2 = userDao.obtenerUsuario1(user.getUsuarioId());
            HttpSession session = request.getSession();
            session.setAttribute("usuario", user2);
            session.setMaxInactiveInterval(1800); // 30 minutos
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
            response.setHeader("Pragma", "no-cache"); // HTTP 1.0
            response.setDateHeader("Expires", 0); // Proxies
            if (user.getRol() != null) {
                switch (user.getRol().getRolId()) {
                    case 1:
                        response.sendRedirect(request.getContextPath() +"/EncuestadorServlet");
                        break;
                    case 2:
                        response.sendRedirect(request.getContextPath() +"/CoordinadorServlet");
                        break;
                    case 3:
                        response.sendRedirect(request.getContextPath() +"/AdminServlet");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() +"/login");
                        break;
                }
            } else {
                // Usuario sin rol asignado
                response.sendRedirect("login");
            }
        } else {
            System.out.println("Usuario no encontrado2");
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("msgErrorLogin", "Usuario o contraseña incorrecto");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    //registro de encuestador
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String names = request.getParameter("names");
        String lastnames1 = request.getParameter("lastnames1");
        String lastnames2 = request.getParameter("lastnames2");
        String dniStr = request.getParameter("code");
        String email = request.getParameter("email");
        String direccion = request.getParameter("direccion");
        String distritoIdParam = request.getParameter("distrito");

        try {
            int dni = Integer.parseInt(dniStr);
            String correoDB = userDao.verificarCorreo(email);
            String codigoDB = userDao.verificarDni(String.valueOf(dni));

            if (correoDB != null || codigoDB != null) {
                response.sendRedirect(request.getContextPath() +"/login?action=register&error=no_valid");
                return;
            }

            Usuario user = createUserObject(names, lastnames1, lastnames2, dni, email, direccion, distritoIdParam);
            if (encDao.crearUsuario1(user)) {
                String token = tokenDao.generateToken(email);
                String validationLink = request.getRequestURL().toString().replace(request.getServletPath(), "") + "/login?action=validate_email&token=" + token;
                String emailBody = "Por favor valide su correo haciendo clic en el siguiente enlace:\n" + validationLink;
                System.out.println(request.getRequestURL().toString().replace(request.getServletPath(), ""));
                System.out.println(request.getContextPath());
                EmailSender.sendEmail(email, "Validación de correo - ONU Mujeres", emailBody);

                response.sendRedirect(request.getContextPath() +"/login?action=email_validation_sent&email=" + URLEncoder.encode(email, "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() +"/login?action=register&error=creation_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +"/login?action=register&error=invalid_dni");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +"/login?action=register&error=server_error");
        }
    }

    private Usuario createUserObject(String names, String lastnames1, String lastnames2,
                                     int dni, String email, String direccion, String distritoIdParam) {
        Usuario user = new Usuario();
        user.setNombre(names);
        user.setApellidoPaterno(lastnames1);
        user.setApellidoMaterno(lastnames2);
        user.setDni(String.valueOf(dni));
        user.setCorreo(email);
        user.setDireccion(direccion);

        Rol rol = new Rol();
        rol.setRolId(1); // Rol de encuestador
        user.setRol(rol);

        if (distritoIdParam != null && !distritoIdParam.isEmpty()) {
            try {
                Distrito distrito = new Distrito();
                distrito.setDistritoId(Integer.parseInt(distritoIdParam));
                user.setDistrito(distrito);
            } catch (NumberFormatException e) {
                // Si hay error al parsear, no asignamos distrito
            }
        }
        return user;
    }


    private void handlePasswordCreation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "password_mismatch");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/system/registrar_encuestador/create_password.jsp").forward(request, response);
            return;
        }

        if (!isPasswordSecure(password)) {
            request.setAttribute("error", "password_weak");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/system/registrar_encuestador/create_password.jsp").forward(request, response);
            return;
        }

        if (token != null && tokenDao.findToken(token)) {
            Usuario user = tokenDao.UserTokenById(tokenDao.getUserByToken(token));
            if (user != null) {
                userDao.editarPassword(password, user.getUsuarioId());
                userDao.marcarCorreoComoVerificado(user.getUsuarioId());
                tokenDao.deleteToken(token);
                response.sendRedirect(request.getContextPath() + "/login?action=registration_complete");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/login?action=invalid_token");
    }

    private boolean isPasswordSecure(String password) {
        return password != null &&
                password.length() >= 8 &&
                password.matches(".*[a-z].*") && // minúscula
                password.matches(".*[A-Z].*") && // mayúscula
                password.matches(".*\\d.*") &&    // número
                password.matches(".*[!@#$%^&*].*"); // especial
    }
//olvido de contraseña

    // Añade estos métodos nuevos
    private void handleSendResetEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        Usuario user = userDao.usuarioByEmail(email);

        if (user != null && user.isCorreoVerificado()) {
            // 1. Eliminar tokens antiguos
            tokenDao.deleteTokensForEmail(email);

            // 2. Generar nuevo token
            String token = tokenDao.generateToken(email);

            // 3. Crear enlace de recuperación CORREGIDO
            String baseUrl = request.getScheme() + "://" +
                    request.getServerName() +
                    (request.getServerPort() != 80 ? ":" + request.getServerPort() : "") +
                    request.getContextPath();
            String resetLink = baseUrl + "/login?action=reset_password&token=" + token;

            // 4. Enviar email
            String emailBody = "Para restablecer tu contraseña, haz clic en el siguiente enlace:\n" + resetLink;
            EmailSender.sendEmail(email, "Restablecer contraseña - ONU Mujeres", emailBody);

            // 5. Redireccionar a página de confirmación
            response.sendRedirect(request.getContextPath() + "/login?action=reset_email_sent&email=" + URLEncoder.encode(email, "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/login?action=forgot_password&error=email_not_found");
        }
    }

    private void handleUpdatePassword(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/system/recuperar_contra/reset_password.jsp").forward(request, response);
            return;
        }

        if (!isPasswordSecure(newPassword)) {
            request.setAttribute("error", "La contraseña debe tener al menos 8 caracteres, una mayúscula,una minuscula, un número y un carácter especial");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/system/recuperar_contra/reset_password.jsp").forward(request, response);
            return;
        }

        if (token != null && tokenDao.findToken(token)) {
            String userId = tokenDao.getUserByToken(token);
            System.out.println("aqui es" + newPassword);
            userDao.editarPassword(newPassword, Integer.parseInt(userId));
            tokenDao.deleteToken(token);
            response.sendRedirect(request.getContextPath() +"/login?action=password_updated");
        } else {
            response.sendRedirect(request.getContextPath() +"/login?action=invalid_token_forgot");
        }
    }

}