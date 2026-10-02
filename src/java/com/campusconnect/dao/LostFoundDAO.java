package com.campusconnect.dao;

import com.campusconnect.model.LostFound;
import com.campusconnect.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Lost & Found items.
 */
public class LostFoundDAO {

    /**
     * Reports a lost or found item.
     */
    public boolean reportItem(LostFound item) {
        String sql = "INSERT INTO lost_found (roll_number, type, item_name, category, description, location, report_date, status, contact) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, item.getRollNumber().trim());
            stmt.setString(2, item.getType().trim().toUpperCase());
            stmt.setString(3, item.getItemName().trim());
            stmt.setString(4, item.getCategory().trim());
            stmt.setString(5, item.getDescription().trim());
            stmt.setString(6, item.getLocation().trim());
            stmt.setDate(7, item.getReportDate());
            stmt.setString(8, item.getStatus() != null ? item.getStatus() : item.getType());
            stmt.setString(9, item.getContact().trim());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[LostFoundDAO] reportItem error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }

    /**
     * Retrieves items by type (LOST or FOUND).
     */
    public List<LostFound> getItemsByType(String type) {
        List<LostFound> list = new ArrayList<>();
        String sql = "SELECT lf.*, s.full_name AS student_name FROM lost_found lf "
                   + "JOIN students s ON lf.roll_number = s.roll_number "
                   + "WHERE lf.type = ? ORDER BY lf.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, type.trim().toUpperCase());
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            System.err.println("[LostFoundDAO] getItemsByType error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Retrieves all items for admin moderation.
     */
    public List<LostFound> getAllItems() {
        List<LostFound> list = new ArrayList<>();
        String sql = "SELECT lf.*, s.full_name AS student_name FROM lost_found lf "
                   + "JOIN students s ON lf.roll_number = s.roll_number "
                   + "ORDER BY lf.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            System.err.println("[LostFoundDAO] getAllItems error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Updates item status (e.g. CLAIMED, CLOSED).
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE lost_found SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status.trim());
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[LostFoundDAO] updateStatus error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }

    private LostFound mapResultSet(ResultSet rs) throws Exception {
        LostFound item = new LostFound();
        item.setId(rs.getInt("id"));
        item.setRollNumber(rs.getString("roll_number"));
        item.setStudentName(rs.getString("student_name"));
        item.setType(rs.getString("type"));
        item.setItemName(rs.getString("item_name"));
        item.setCategory(rs.getString("category"));
        item.setDescription(rs.getString("description"));
        item.setLocation(rs.getString("location"));
        item.setReportDate(rs.getDate("report_date"));
        item.setStatus(rs.getString("status"));
        item.setContact(rs.getString("contact"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        return item;
    }
}
