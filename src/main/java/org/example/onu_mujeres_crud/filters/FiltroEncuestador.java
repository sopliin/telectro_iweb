package org.example.onu_mujeres_crud.filters;

import org.example.onu_mujeres_crud.beans.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(servletNames = {"EncuestadorServlett","EncuestadorServlet"})
public class FiltroEncuestador implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        // 1. PRIMERO establecer headers anti-caché (siempre se aplican)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, private");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", -1); // Mejor que 0

        HttpSession session = request.getSession(false);

        // 2. Validación mejorada
        if (session != null) {
            Usuario user = (Usuario) session.getAttribute("usuario");
            System.out.println(user.getRol().getNombre());

            if (user != null && user.getRol() != null) {
                int rolId = user.getRol().getRolId();
                if (rolId == 1 ) {
                    filterChain.doFilter(request, response);
                    return;
                }

            }
            // Invalidar sesión si existe pero no cumple requisitos
            session.invalidate();
        }

        // 3. Redirección con parámetro anti-caché
        System.out.println("Redirigiendo a login - Sesión inválida");
        String redirectUrl = request.getContextPath() + "/login?nocache=" + System.currentTimeMillis();
        response.sendRedirect(redirectUrl);
    }
}