package com.campusconnect.controller;

import com.campusconnect.dao.StaffDAO;
import com.campusconnect.model.Staff;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling Admin additions to Staff / Department directory.
 */
@WebServlet(name = "AdminStaffServlet", urlPatterns = {"/admin/staff-action"})
public class AdminStaffServlet extends HttpServlet {

    private final StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Unauthorized.");
            return;
        }

        String staffName = request.getParameter("staffName");
        String department = request.getParameter("department");
        String contact = request.getParameter("contact");

        if (staffName != null && department != null && contact != null &&
            !staffName.trim().isEmpty() && !department.trim().isEmpty()) {
            Staff s = new Staff(0, staffName.trim(), department.trim(), contact.trim(), true);
            staffDAO.addStaff(s);
            response.sendRedirect(request.getContextPath() + "/admin/staff.jsp?success=Staff+member+added+successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/staff.jsp?error=Please+provide+all+staff+details.");
        }
    }
}
