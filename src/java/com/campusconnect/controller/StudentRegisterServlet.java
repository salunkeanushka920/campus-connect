package com.campusconnect.controller;

import com.campusconnect.dao.StudentDAO;
import com.campusconnect.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet handling Student Registration with comprehensive server-side validation.
 */
@WebServlet(name = "StudentRegisterServlet", urlPatterns = {"/register"})
public class StudentRegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String rollNumber = request.getParameter("rollNumber");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String course = request.getParameter("course");
        String year = request.getParameter("year");
        String division = request.getParameter("division");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Check required fields
        if (fullName == null || fullName.trim().isEmpty() ||
            rollNumber == null || rollNumber.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            course == null || course.trim().isEmpty() ||
            year == null || year.trim().isEmpty() ||
            division == null || division.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required. Please fill out the complete form.");
            preserveFormInputs(request, fullName, rollNumber, email, phone, course, year, division);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 2. Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Please provide a valid college or personal email address.");
            preserveFormInputs(request, fullName, rollNumber, email, phone, course, year, division);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 3. Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password and Confirm Password do not match.");
            preserveFormInputs(request, fullName, rollNumber, email, phone, course, year, division);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 4. Validate password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            preserveFormInputs(request, fullName, rollNumber, email, phone, course, year, division);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 5. Check if roll number already exists
        if (studentDAO.isRollNumberExists(rollNumber.trim())) {
            request.setAttribute("error", "This Roll Number (" + rollNumber.trim() + ") is already registered. Please log in.");
            preserveFormInputs(request, fullName, rollNumber, email, phone, course, year, division);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 6. Save new student
        Student student = new Student(rollNumber.trim(), fullName.trim(), email.trim(), phone.trim(),
                                      course.trim(), year.trim(), division.trim(), password);
        try {
            boolean success = studentDAO.registerStudent(student);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&success=Registration+successful.+You+can+now+log+in.");
            } else {
                request.setAttribute("error", "Database error occurred while creating your account. Please try again.");
                preserveFormInputs(request, fullName, rollNumber, email, phone, course, year, division);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong while processing your request: " + e.getMessage());
            preserveFormInputs(request, fullName, rollNumber, email, phone, course, year, division);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveFormInputs(HttpServletRequest req, String name, String roll, String email, 
                                    String phone, String course, String year, String div) {
        req.setAttribute("fullName", name);
        req.setAttribute("rollNumber", roll);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
        req.setAttribute("course", course);
        req.setAttribute("year", year);
        req.setAttribute("division", div);
    }
}
