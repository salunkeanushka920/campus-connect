package com.campusconnect.controller;

import com.campusconnect.dao.AdminDAO;
import com.campusconnect.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling Administrator Authentication.
 */
@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin-login"})
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+enter+both+username+and+password.");
            return;
        }

        Admin admin = adminDAO.authenticate(username.trim(), password);
        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("admin", admin);
            session.setAttribute("adminUsername", admin.getUsername());
            session.setAttribute("adminName", admin.getFullName());
            // Session expires after 30 minutes of inactivity
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Invalid+administrator+username+or+password.");
        }
    }
}
