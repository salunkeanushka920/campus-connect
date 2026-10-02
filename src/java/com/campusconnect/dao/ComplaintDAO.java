package com.campusconnect.dao;

import com.campusconnect.model.Complaint;
import com.campusconnect.util.CodeGenerator;
import com.campusconnect.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Complaint lifecycle management.
 * Implements submitting, searching, filtering, assigning, and status updating.
 */
public class ComplaintDAO {

    /**
     * Submits a new student complaint.
     * @return Generated Complaint ID (e.g. CC-2026-00001) or null if failure
     */
    public String submitComplaint(Complaint complaint) {
        String insertSql = "INSERT INTO complaints (complaint_id, roll_number, category, location_id, subject, description, priority, status) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            // Generate next sequential Complaint ID
            String complaintId = CodeGenerator.generateComplaintId(conn);
            complaint.setComplaintId(complaintId);

            stmt = conn.prepareStatement(insertSql);
            stmt.setString(1, complaintId);
            stmt.setString(2, complaint.getRollNumber().trim());
            stmt.setString(3, complaint.getCategory().trim());
            stmt.setInt(4, complaint.getLocationId());
            stmt.setString(5, complaint.getSubject().trim());
            stmt.setString(6, complaint.getDescription().trim());
            stmt.setString(7, complaint.getPriority().trim());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                return complaintId;
            }
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] submitComplaint error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, null);
        }
        return null;
    }

    /**
     * Retrieves full complaint details by ID, joining student, location, and assigned staff.
     */
    public Complaint getComplaintById(String complaintId) {
        String sql = "SELECT c.*, s.full_name AS student_name, s.phone AS student_phone, s.email AS student_email, "
                   + "l.location_name, l.block, st.staff_name, st.department AS staff_department "
                   + "FROM complaints c "
                   + "JOIN students s ON c.roll_number = s.roll_number "
                   + "JOIN locations l ON c.location_id = l.location_id "
                   + "LEFT JOIN staff st ON c.assigned_staff_id = st.staff_id "
                   + "WHERE c.complaint_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, complaintId.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToComplaint(rs);
            }
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getComplaintById error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    /**
     * Retrieves complaints submitted by a specific student with optional filters.
     */
    public List<Complaint> getComplaintsByStudent(String rollNumber, String statusFilter, String categoryFilter) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, s.full_name AS student_name, s.phone AS student_phone, s.email AS student_email, "
          + "l.location_name, l.block, st.staff_name, st.department AS staff_department "
          + "FROM complaints c "
          + "JOIN students s ON c.roll_number = s.roll_number "
          + "JOIN locations l ON c.location_id = l.location_id "
          + "LEFT JOIN staff st ON c.assigned_staff_id = st.staff_id "
          + "WHERE c.roll_number = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(rollNumber.trim());

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.status = ? ");
            params.add(statusFilter.trim());
        }
        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(categoryFilter)) {
            sql.append("AND c.category = ? ");
            params.add(categoryFilter.trim());
        }

        sql.append("ORDER BY c.created_at DESC");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getComplaintsByStudent error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Retrieves all complaints for Admin view with optional status, category, and location filters.
     */
    public List<Complaint> getAllComplaints(String statusFilter, String categoryFilter, Integer locationFilter) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, s.full_name AS student_name, s.phone AS student_phone, s.email AS student_email, "
          + "l.location_name, l.block, st.staff_name, st.department AS staff_department "
          + "FROM complaints c "
          + "JOIN students s ON c.roll_number = s.roll_number "
          + "JOIN locations l ON c.location_id = l.location_id "
          + "LEFT JOIN staff st ON c.assigned_staff_id = st.staff_id "
          + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.status = ? ");
            params.add(statusFilter.trim());
        }
        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(categoryFilter)) {
            sql.append("AND c.category = ? ");
            params.add(categoryFilter.trim());
        }
        if (locationFilter != null && locationFilter > 0) {
            sql.append("AND c.location_id = ? ");
            params.add(locationFilter);
        }

        sql.append("ORDER BY c.created_at DESC");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getAllComplaints error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Assigns complaint to a staff member, sets status to ASSIGNED or IN PROGRESS, and records remarks.
     */
    public boolean assignStaff(String complaintId, int staffId, String remarks, String status) {
        String targetStatus = (status != null && !status.isEmpty()) ? status : "ASSIGNED";
        String sql = "UPDATE complaints SET assigned_staff_id = ?, admin_remarks = ?, status = ? WHERE complaint_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, staffId);
            stmt.setString(2, remarks);
            stmt.setString(3, targetStatus);
            stmt.setString(4, complaintId.trim());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] assignStaff error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }

    /**
     * Updates complaint status, appends remarks, and timestamps resolution when completed.
     */
    public boolean updateStatus(String complaintId, String status, String remarks) {
        StringBuilder sql = new StringBuilder("UPDATE complaints SET status = ?, admin_remarks = ? ");
        if ("RESOLVED".equalsIgnoreCase(status) || "CLOSED".equalsIgnoreCase(status)) {
            sql.append(", resolved_at = CURRENT_TIMESTAMP ");
        }
        sql.append("WHERE complaint_id = ?");

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            stmt.setString(1, status.trim());
            stmt.setString(2, remarks);
            stmt.setString(3, complaintId.trim());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] updateStatus error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }

    /**
     * Metrics for student dashboard: Total, Pending, In Progress, Resolved.
     */
    public Map<String, Integer> getStudentStats(String rollNumber) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("pending", 0);
        stats.put("inProgress", 0);
        stats.put("resolved", 0);

        String sql = "SELECT status, COUNT(*) AS cnt FROM complaints WHERE roll_number = ? GROUP BY status";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, rollNumber.trim());
            rs = stmt.executeQuery();
            int total = 0;
            while (rs.next()) {
                String st = rs.getString("status");
                int cnt = rs.getInt("cnt");
                total += cnt;
                if ("PENDING".equalsIgnoreCase(st)) {
                    stats.put("pending", cnt);
                } else if ("IN PROGRESS".equalsIgnoreCase(st) || "ASSIGNED".equalsIgnoreCase(st)) {
                    stats.put("inProgress", stats.get("inProgress") + cnt);
                } else if ("RESOLVED".equalsIgnoreCase(st) || "CLOSED".equalsIgnoreCase(st)) {
                    stats.put("resolved", stats.get("resolved") + cnt);
                }
            }
            stats.put("total", total);
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getStudentStats error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return stats;
    }

    /**
     * Metrics for admin dashboard.
     */
    public Map<String, Integer> getAdminStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("pending", 0);
        stats.put("assigned", 0);
        stats.put("inProgress", 0);
        stats.put("resolved", 0);
        stats.put("closed", 0);

        String sql = "SELECT status, COUNT(*) AS cnt FROM complaints GROUP BY status";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            int total = 0;
            while (rs.next()) {
                String st = rs.getString("status");
                int cnt = rs.getInt("cnt");
                total += cnt;
                if ("PENDING".equalsIgnoreCase(st)) stats.put("pending", cnt);
                else if ("ASSIGNED".equalsIgnoreCase(st)) stats.put("assigned", cnt);
                else if ("IN PROGRESS".equalsIgnoreCase(st)) stats.put("inProgress", cnt);
                else if ("RESOLVED".equalsIgnoreCase(st)) stats.put("resolved", cnt);
                else if ("CLOSED".equalsIgnoreCase(st)) stats.put("closed", cnt);
            }
            stats.put("total", total);
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getAdminStats error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return stats;
    }

    /**
     * Complaints by Category breakdown.
     */
    public Map<String, Integer> getComplaintsByCategory() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT category, COUNT(*) as cnt FROM complaints GROUP BY category ORDER BY cnt DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("category"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getComplaintsByCategory error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return map;
    }

    /**
     * Complaints by Block breakdown.
     */
    public Map<String, Integer> getComplaintsByBlock() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT l.block, COUNT(*) as cnt FROM complaints c JOIN locations l ON c.location_id = l.location_id GROUP BY l.block ORDER BY cnt DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("block"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getComplaintsByBlock error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return map;
    }

    /**
     * Recent complaints feed.
     */
    public List<Complaint> getRecentComplaints(int limit) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.full_name AS student_name, s.phone AS student_phone, s.email AS student_email, "
                   + "l.location_name, l.block, st.staff_name, st.department AS staff_department "
                   + "FROM complaints c "
                   + "JOIN students s ON c.roll_number = s.roll_number "
                   + "JOIN locations l ON c.location_id = l.location_id "
                   + "LEFT JOIN staff st ON c.assigned_staff_id = st.staff_id "
                   + "ORDER BY c.created_at DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
        } catch (Exception e) {
            System.err.println("[ComplaintDAO] getRecentComplaints error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getString("complaint_id"));
        c.setRollNumber(rs.getString("roll_number"));
        c.setStudentName(rs.getString("student_name"));
        c.setStudentPhone(rs.getString("student_phone"));
        c.setStudentEmail(rs.getString("student_email"));
        c.setCategory(rs.getString("category"));
        c.setLocationId(rs.getInt("location_id"));
        c.setLocationName(rs.getString("location_name"));
        c.setBlock(rs.getString("block"));
        c.setSubject(rs.getString("subject"));
        c.setDescription(rs.getString("description"));
        c.setPriority(rs.getString("priority"));
        c.setStatus(rs.getString("status"));
        
        int staffId = rs.getInt("assigned_staff_id");
        if (!rs.wasNull()) {
            c.setAssignedStaffId(staffId);
            c.setAssignedStaffName(rs.getString("staff_name"));
            c.setAssignedDepartment(rs.getString("staff_department"));
        }
        c.setAdminRemarks(rs.getString("admin_remarks"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        c.setResolvedAt(rs.getTimestamp("resolved_at"));
        return c;
    }
}
