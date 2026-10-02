package com.campusconnect.dao;

import com.campusconnect.model.Admin;
import com.campusconnect.util.DBConnection;
import com.campusconnect.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Data Access Object for Administrator accounts.
 */
public class AdminDAO {

    /**
     * Authenticates administrator.
     */
    public Admin authenticate(String username, String plainPassword) {
        String sql = "SELECT * FROM admins WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username.trim());
            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(plainPassword, storedPassword)) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setFullName(rs.getString("full_name"));
                    return admin;
                }
            }
        } catch (Exception e) {
            System.err.println("[AdminDAO] Authentication error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }
}
