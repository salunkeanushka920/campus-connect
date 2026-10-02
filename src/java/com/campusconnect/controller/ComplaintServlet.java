package com.campusconnect.controller;

import com.campusconnect.dao.ComplaintDAO;
import com.campusconnect.dao.LocationDAO;
import com.campusconnect.model.Complaint;
import com.campusconnect.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling Student Complaint submissions and details view.
 */
@WebServlet(name = "ComplaintServlet", urlPatterns = {"/complaint"})
public class ComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final LocationDAO locationDAO = new LocationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "new";

        if ("details".equalsIgnoreCase(action)) {
            String complaintId = request.getParameter("id");
            if (complaintId != null && !complaintId.trim().isEmpty()) {
                Complaint complaint = complaintDAO.getComplaintById(complaintId.trim());
                if (complaint != null) {
                    request.setAttribute("complaint", complaint);
                    request.getRequestDispatcher("/student/complaint-details.jsp").forward(request, response);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Complaint+not+found");
        } else if ("my".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp");
        } else {
            // Load active locations into request
            request.setAttribute("locations", locationDAO.getAllActiveLocations());
            request.getRequestDispatcher("/student/submit-complaint.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in+to+submit+a+complaint.");
            return;
        }

        String category = request.getParameter("category");
        String locationIdStr = request.getParameter("locationId");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");

        // Validation
        if (category == null || category.trim().isEmpty() ||
            locationIdStr == null || locationIdStr.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priority == null || priority.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required. Please fill in category, location, subject, description, and priority.");
            request.setAttribute("locations", locationDAO.getAllActiveLocations());
            request.getRequestDispatcher("/student/submit-complaint.jsp").forward(request, response);
            return;
        }

        int locationId;
        try {
            locationId = Integer.parseInt(locationIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid campus location selected.");
            request.setAttribute("locations", locationDAO.getAllActiveLocations());
            request.getRequestDispatcher("/student/submit-complaint.jsp").forward(request, response);
            return;
        }

        Complaint complaint = new Complaint();
        complaint.setRollNumber(student.getRollNumber());
        complaint.setCategory(category.trim());
        complaint.setLocationId(locationId);
        complaint.setSubject(subject.trim());
        complaint.setDescription(description.trim());
        complaint.setPriority(priority.trim());

        String generatedId = complaintDAO.submitComplaint(complaint);
        if (generatedId != null) {
            response.sendRedirect(request.getContextPath() 
                + "/student/my-complaints.jsp?success=Complaint+submitted+successfully.+Complaint+ID:+<strong>" 
                + generatedId + "</strong>");
        } else {
            request.setAttribute("error", "Failed to submit complaint to the database. Please try again.");
            request.setAttribute("locations", locationDAO.getAllActiveLocations());
            request.getRequestDispatcher("/student/submit-complaint.jsp").forward(request, response);
        }
    }
}
