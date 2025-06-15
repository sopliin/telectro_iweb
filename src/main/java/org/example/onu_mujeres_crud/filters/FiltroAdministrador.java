package org.example.onu_mujeres_crud.filters;

import org.example.onu_mujeres_crud.beans.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(servletNames = {"AdminServlet"})
public class FiltroAdministrador implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;


        // 1. Establecer headers anti-caché primero
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, private");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", -1);

        HttpSession session = request.getSession(false);

        // 2. Validación mejorada
        if (session != null) {
            Usuario user = (Usuario) session.getAttribute("usuario");

            if (user != null && user.getRol() != null ) {
                int rolId = user.getRol().getRolId();
                if (rolId == 3 ) {
                    filterChain.doFilter(request, response);
                    return;
                }

            }
            // Invalidar sesión si no cumple requisitos
            session.invalidate();
        }

        // 3. Redirección con parámetro anti-caché
        String redirectUrl = request.getContextPath() + "/login?nocache=" + System.currentTimeMillis();
        response.sendRedirect(redirectUrl);
    }
}
