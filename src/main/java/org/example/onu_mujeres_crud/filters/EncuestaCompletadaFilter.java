package org.example.onu_mujeres_crud.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.onu_mujeres_crud.daos.ContenidoEncuestaDAO;
import java.io.IOException;
import java.sql.SQLException;

@WebFilter("/ContenidoEncuestaServlet") // Filtra todas las solicitudes al servlet
public class EncuestaCompletadaFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 1. Configurar headers para evitar caché
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setHeader("Expires", "0");

        // 2. Verificar solo en acciones de "mostrar" encuesta
        String action = httpRequest.getParameter("action");
        if ("mostrar".equals(action)) {
            String asignacionIdParam = httpRequest.getParameter("asignacionId");
            if (asignacionIdParam != null) {
                try {
                    int asignacionId = Integer.parseInt(asignacionIdParam);
                    ContenidoEncuestaDAO dao = new ContenidoEncuestaDAO();
                    String estado = dao.obtenerEstadoEncuestaAsignada(asignacionId);

                    // 3. Redirigir si está completada
                    if ("completada".equalsIgnoreCase(estado)) {
                        httpResponse.sendRedirect(httpRequest.getContextPath() + "/EncuestadorServlet?action=total");
                        return;
                    }
                } catch (SQLException | NumberFormatException e) {
                    e.printStackTrace();
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/error.jsp");
                    return;
                }
            }
        }

        // 4. Continuar con la solicitud si no hay redirección
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
