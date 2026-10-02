package com.campusconnect.controller;

import com.campusconnect.dao.ComplaintDAO;
import com.campusconnect.dao.StaffDAO;
import com.campusconnect.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling Admin actions on complaints: review, staff assignment, and status updates.
 */
@WebServlet(name = "AdminComplaintServlet", urlPatterns = {"/admin/complaint-action"})
public class AdminComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String complaintId = request.getParameter("id");

        if ("view".equalsIgnoreCase(action) && complaintId != null && !complaintId.trim().isEmpty()) {
            Complaint c = complaintDAO.getComplaintById(complaintId.trim());
            if (c != null) {
                request.setAttribute("complaint", c);
                request.setAttribute("staffList", staffDAO.getAllActiveStaff());
                request.getRequestDispatcher("/admin/complaint-detail.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/complaints.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Unauthorized+session.");
            return;
        }

        String action = request.getParameter("action");
        String complaintId = request.getParameter("complaintId");

        if (complaintId == null || complaintId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/complaints.jsp?error=Invalid+complaint+ID");
            return;
        }

        if ("assign".equalsIgnoreCase(action)) {
            String staffIdStr = request.getParameter("staffId");
            String remarks = request.getParameter("remarks");
            String status = request.getParameter("status"); // ASSIGNED or IN PROGRESS

            if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() 
                    + "/admin/complaint-action?action=view&id=" + complaintId + "&error=Please+select+a+staff+member.");
                return;
            }

            try {
                int staffId = Integer.parseInt(staffIdStr.trim());
                if (status == null || status.trim().isEmpty()) {
                    status = "ASSIGNED";
                }
                boolean ok = complaintDAO.assignStaff(complaintId.trim(), staffId, remarks, status.trim());
                if (ok) {
                    response.sendRedirect(request.getContextPath() 
                        + "/admin/complaint-action?action=view&id=" + complaintId + "&success=Complaint+assigned+successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() 
                        + "/admin/complaint-action?action=view&id=" + complaintId + "&error=Failed+to+assign+complaint.");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() 
                    + "/admin/complaint-action?action=view&id=" + complaintId + "&error=" + e.getMessage());
            }
        } else if ("updateStatus".equalsIgnoreCase(action)) {
            String status = request.getParameter("status");
            String remarks = request.getParameter("remarks");

            if (status == null || status.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() 
                    + "/admin/complaint-action?action=view&id=" + complaintId + "&error=Please+select+a+valid+status.");
                return;
            }

            boolean ok = complaintDAO.updateStatus(complaintId.trim(), status.trim(), remarks);
            if (ok) {
                response.sendRedirect(request.getContextPath() 
                    + "/admin/complaint-action?action=view&id=" + complaintId + "&success=Status+updated+to+" + status + ".");
            } else {
                response.sendRedirect(request.getContextPath() 
                    + "/admin/complaint-action?action=view&id=" + complaintId + "&error=Failed+to+update+status.");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/complaints.jsp");
        }
    }
}
