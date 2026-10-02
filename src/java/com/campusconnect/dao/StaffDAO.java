package com.campusconnect.dao;

import com.campusconnect.model.Staff;
import com.campusconnect.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Maintenance Staff and Responsible Persons.
 */
public class StaffDAO {

    /**
     * Gets all active staff members.
     */
    public List<Staff> getAllActiveStaff() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT staff_id, staff_name, department, contact, active FROM staff WHERE active = TRUE ORDER BY department ASC, staff_name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Staff s = new Staff(
                    rs.getInt("staff_id"),
                    rs.getString("staff_name"),
                    rs.getString("department"),
                    rs.getString("contact"),
                    rs.getBoolean("active")
                );
                list.add(s);
            }
        } catch (Exception e) {
            System.err.println("[StaffDAO] getAllActiveStaff error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Adds a new staff member.
     */
    public boolean addStaff(Staff s) {
        String sql = "INSERT INTO staff (staff_name, department, contact, active) VALUES (?, ?, ?, TRUE)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, s.getStaffName().trim());
            stmt.setString(2, s.getDepartmentName().trim());
            stmt.setString(3, s.getContact().trim());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[StaffDAO] addStaff error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }
}
