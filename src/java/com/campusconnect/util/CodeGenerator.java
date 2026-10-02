package com.campusconnect.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;

/**
 * Utility to generate unique Complaint IDs formatted as: CC-YYYY-XXXXX
 * Example: CC-2026-00001
 */
public class CodeGenerator {

    /**
     * Generates the next sequential Complaint ID.
     */
    public static synchronized String generateComplaintId(Connection conn) {
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        String prefix = "CC-" + currentYear + "-";
        int nextSeq = 1;

        String sql = "SELECT complaint_id FROM complaints WHERE complaint_id LIKE ? ORDER BY complaint_id DESC";
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, prefix + "%");
            rs = stmt.executeQuery();

            if (rs.next()) {
                String lastId = rs.getString("complaint_id");
                // lastId format is CC-2026-00001
                String[] parts = lastId.split("-");
                if (parts.length >= 3) {
                    try {
                        nextSeq = Integer.parseInt(parts[2]) + 1;
                    } catch (NumberFormatException ignored) {}
                }
            }
        } catch (Exception e) {
            System.err.println("[CodeGenerator] Error determining next complaint sequence: " + e.getMessage());
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (Exception ignored) {}
            }
            if (stmt != null) {
                try { stmt.close(); } catch (Exception ignored) {}
            }
        }

        return String.format("%s%05d", prefix, nextSeq);
    }
}
