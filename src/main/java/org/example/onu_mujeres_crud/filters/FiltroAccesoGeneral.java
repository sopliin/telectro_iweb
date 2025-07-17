package org.example.onu_mujeres_crud.filters;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.onu_mujeres_crud.beans.Usuario;

import java.io.IOException;
@WebFilter("/*")
public class FiltroAccesoGeneral implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getServletPath();
        System.out.println("enlaces "+path);

        // Headers anti-caché
        if (path.startsWith("/logout") || path.startsWith("/cambiarContrasena")) {
            System.out.println( "jajaja");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, private");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", -1);
        }
// Excluir TODOS los recursos estáticos
        // Excluir recursos estáticos y páginas públicas
        if (path.startsWith("/fotos/") || path.equals("/login") || path.equals("/")||path.startsWith("/onu_mujeres/stati c/css")||path.startsWith("/onu_mujeres/static/js")||path.startsWith("/onu_mujeres/static/fonts")||path.startsWith("/onu_mujeres/static/img")
        ) {
            System.out.println("ingreso foto1");
            if(path.startsWith("/fotos/")){
                System.out.println("ingreso foto");
            }
            filterChain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login?nocache=" + System.currentTimeMillis());
            return;
        }

        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null || user.getRol() == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?nocache=" + System.currentTimeMillis());
            return;
        }

        // Verificar acceso según rol y ruta solicitada
        int rolId = user.getRol().getRolId();

        if (path.startsWith("/EncuestadorServlet") && rolId != 1) {
            response.sendRedirect(getRedirectUrlForRole(rolId, request.getContextPath()));
            System.out.println("a");
            return;
        } else if (path.startsWith("/CoordinadorServlet") && rolId != 2) {
            response.sendRedirect(getRedirectUrlForRole(rolId, request.getContextPath()));
            System.out.println("b");
            return;
        } else if (path.startsWith("/AdminServlet") && rolId != 3) {
            response.sendRedirect(getRedirectUrlForRole(rolId, request.getContextPath()));
            System.out.println("c");
            return;
        }

        filterChain.doFilter(request, response);
    }

    private String getRedirectUrlForRole(int rolId, String contextPath) {
        switch(rolId) {
            case 1: return contextPath + "/EncuestadorServlet";
            case 2: return contextPath + "/CoordinadorServlet";
            case 3: return contextPath + "/AdminServlet";
            default: return contextPath + "/login";
        }
    }
}
