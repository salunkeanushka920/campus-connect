package com.campusconnect.controller;

import com.campusconnect.dao.LostFoundDAO;
import com.campusconnect.model.LostFound;
import com.campusconnect.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

/**
 * Servlet handling Lost & Found item reports and status changes.
 */
@WebServlet(name = "LostFoundServlet", urlPatterns = {"/lost-found"})
public class LostFoundServlet extends HttpServlet {

    private final LostFoundDAO lostFoundDAO = new LostFoundDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String isAdmin = request.getParameter("admin");
        if ("true".equalsIgnoreCase(isAdmin)) {
            response.sendRedirect(request.getContextPath() + "/admin/lost-found.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/lost-found.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Action: Update Status (e.g. CLAIMED or CLOSED)
        if ("updateStatus".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");
            String redirectUrl = request.getParameter("redirect");
            if (idStr != null && status != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    lostFoundDAO.updateStatus(id, status.trim());
                } catch (Exception ignored) {}
            }
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                response.sendRedirect(redirectUrl + "?success=Item+status+updated+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/lost-found.jsp?success=Item+status+updated.");
            }
            return;
        }

        // Action: Report New Item
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in+to+report+items.");
            return;
        }

        String type = request.getParameter("type"); // LOST or FOUND
        String itemName = request.getParameter("itemName");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String dateStr = request.getParameter("reportDate");
        String contact = request.getParameter("contact");

        if (type == null || itemName == null || description == null || location == null ||
            itemName.trim().isEmpty() || description.trim().isEmpty() || location.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/lost-found.jsp?error=Please+fill+in+all+required+fields.");
            return;
        }

        Date reportDate = new Date(System.currentTimeMillis());
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            try {
                reportDate = Date.valueOf(dateStr.trim());
            } catch (Exception ignored) {}
        }

        LostFound item = new LostFound();
        item.setRollNumber(student.getRollNumber());
        item.setType(type.trim().toUpperCase());
        item.setItemName(itemName.trim());
        item.setCategory(category != null ? category.trim() : "General");
        item.setDescription(description.trim());
        item.setLocation(location.trim());
        item.setReportDate(reportDate);
        item.setStatus(type.trim().toUpperCase());
        item.setContact(contact != null && !contact.trim().isEmpty() ? contact.trim() : student.getEmail() + " | " + student.getPhone());

        boolean ok = lostFoundDAO.reportItem(item);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/student/lost-found.jsp?success=Item+reported+successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/lost-found.jsp?error=Failed+to+record+item.+Please+try+again.");
        }
    }
}
