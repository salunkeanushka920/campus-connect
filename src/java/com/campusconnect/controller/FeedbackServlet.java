package com.campusconnect.controller;

import com.campusconnect.dao.ComplaintDAO;
import com.campusconnect.dao.FeedbackDAO;
import com.campusconnect.model.Complaint;
import com.campusconnect.model.Feedback;
import com.campusconnect.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling Student Feedback submissions for resolved complaints.
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {"/feedback"})
public class FeedbackServlet extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in+to+submit+feedback.");
            return;
        }

        String complaintId = request.getParameter("complaintId");
        String ratingStr = request.getParameter("rating");
        String message = request.getParameter("message");

        if (complaintId == null || ratingStr == null || message == null ||
            complaintId.trim().isEmpty() || message.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Please+provide+both+a+star+rating+and+feedback+message.");
            return;
        }

        // Verify complaint exists and is resolved
        Complaint complaint = complaintDAO.getComplaintById(complaintId.trim());
        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Complaint+not+found.");
            return;
        }

        if (!student.getRollNumber().equalsIgnoreCase(complaint.getRollNumber())) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Unauthorized+feedback+submission.");
            return;
        }

        if (!"RESOLVED".equalsIgnoreCase(complaint.getStatus()) && !"CLOSED".equalsIgnoreCase(complaint.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Feedback+can+only+be+submitted+after+the+issue+is+resolved.");
            return;
        }

        if (feedbackDAO.hasFeedback(complaintId.trim())) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Feedback+has+already+been+submitted+for+this+complaint.");
            return;
        }

        int rating = 5;
        try {
            rating = Integer.parseInt(ratingStr.trim());
            if (rating < 1) rating = 1;
            if (rating > 5) rating = 5;
        } catch (NumberFormatException ignored) {}

        Feedback fb = new Feedback();
        fb.setComplaintId(complaintId.trim());
        fb.setRollNumber(student.getRollNumber());
        fb.setRating(rating);
        fb.setMessage(message.trim());

        boolean ok = feedbackDAO.submitFeedback(fb);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?success=Thank+you!+Your+feedback+has+been+recorded.");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Failed+to+save+feedback.+Please+try+again.");
        }
    }
}
