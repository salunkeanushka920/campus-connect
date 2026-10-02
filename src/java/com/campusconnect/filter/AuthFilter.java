package com.campusconnect.filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication and Session Security Filter.
 * Protects Student-only and Admin-only portals from unauthorized direct URL access.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/student/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Prevent client browser caching of protected pages
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        res.setHeader("Pragma", "no-cache"); // HTTP 1.0
        res.setDateHeader("Expires", 0); // Proxies

        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);
        String contextPath = req.getContextPath();

        // 1. Guard Student Portal
        if (uri.contains("/student/")) {
            boolean isStudentLoggedIn = (session != null && session.getAttribute("student") != null);
            if (!isStudentLoggedIn) {
                res.sendRedirect(contextPath + "/login.jsp?portal=student&error=Please+login+to+access+student+portal");
                return;
            }
        }

        // 2. Guard Admin Portal
        if (uri.contains("/admin/")) {
            boolean isAdminLoggedIn = (session != null && session.getAttribute("admin") != null);
            if (!isAdminLoggedIn) {
                res.sendRedirect(contextPath + "/login.jsp?portal=admin&error=Please+login+with+administrator+credentials");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
