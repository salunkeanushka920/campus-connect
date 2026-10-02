package com.campusconnect.dao;

import com.campusconnect.model.Feedback;
import com.campusconnect.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for post-resolution student feedback.
 */
public class FeedbackDAO {

    /**
     * Submits student feedback for a resolved complaint.
     */
    public boolean submitFeedback(Feedback fb) {
        String sql = "INSERT INTO feedback (complaint_id, roll_number, rating, message) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, fb.getComplaintId().trim());
            stmt.setString(2, fb.getRollNumber().trim());
            stmt.setInt(3, fb.getRating());
            stmt.setString(4, fb.getMessage().trim());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[FeedbackDAO] submitFeedback error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }

    /**
     * Checks if feedback was already submitted for this complaint.
     */
    public boolean hasFeedback(String complaintId) {
        String sql = "SELECT id FROM feedback WHERE complaint_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, complaintId.trim());
            rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.err.println("[FeedbackDAO] hasFeedback error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
    }

    /**
     * Retrieves all feedback records for Admin viewing.
     */
    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT fb.*, s.full_name AS student_name, c.subject AS complaint_subject "
                   + "FROM feedback fb "
                   + "JOIN students s ON fb.roll_number = s.roll_number "
                   + "JOIN complaints c ON fb.complaint_id = c.complaint_id "
                   + "ORDER BY fb.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setId(rs.getInt("id"));
                f.setComplaintId(rs.getString("complaint_id"));
                f.setRollNumber(rs.getString("roll_number"));
                f.setStudentName(rs.getString("student_name"));
                f.setComplaintSubject(rs.getString("complaint_subject"));
                f.setRating(rs.getInt("rating"));
                f.setMessage(rs.getString("message"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(f);
            }
        } catch (Exception e) {
            System.err.println("[FeedbackDAO] getAllFeedback error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Calculates the overall average satisfaction rating.
     */
    public double getAverageRating() {
        String sql = "SELECT AVG(rating) as avg_rating FROM feedback";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (Exception e) {
            System.err.println("[FeedbackDAO] getAverageRating error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 0.0;
    }
}
