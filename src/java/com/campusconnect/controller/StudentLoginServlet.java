package com.campusconnect.controller;

import com.campusconnect.dao.StudentDAO;
import com.campusconnect.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling Student Authentication.
 */
@WebServlet(name = "StudentLoginServlet", urlPatterns = {"/student-login"})
public class StudentLoginServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String rollNumber = request.getParameter("rollNumber");
        String password = request.getParameter("password");

        if (rollNumber == null || rollNumber.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+enter+both+roll+number+and+password.");
            return;
        }

        Student student = studentDAO.authenticate(rollNumber.trim(), password);
        if (student != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("student", student);
            session.setAttribute("studentRollNumber", student.getRollNumber());
            session.setAttribute("studentName", student.getFullName());
            // Session expires after 30 minutes of inactivity
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Invalid+roll+number+or+password.");
        }
    }
}
