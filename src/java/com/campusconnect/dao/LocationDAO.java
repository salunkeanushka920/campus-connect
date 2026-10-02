package com.campusconnect.dao;

import com.campusconnect.model.CampusLocation;
import com.campusconnect.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for College Campus Locations.
 * Loads dynamic blocks and rooms from the database.
 */
public class LocationDAO {

    /**
     * Gets all active campus locations ordered by block and name.
     */
    public List<CampusLocation> getAllActiveLocations() {
        List<CampusLocation> list = new ArrayList<>();
        String sql = "SELECT location_id, block, location_name, location_type, active "
                   + "FROM locations WHERE active = TRUE ORDER BY block ASC, location_name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                CampusLocation loc = new CampusLocation(
                    rs.getInt("location_id"),
                    rs.getString("block"),
                    rs.getString("location_name"),
                    rs.getString("location_type"),
                    rs.getBoolean("active")
                );
                list.add(loc);
            }
        } catch (Exception e) {
            System.err.println("[LocationDAO] getAllActiveLocations error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Gets all locations (including inactive) for admin management.
     */
    public List<CampusLocation> getAllLocations() {
        List<CampusLocation> list = new ArrayList<>();
        String sql = "SELECT location_id, block, location_name, location_type, active "
                   + "FROM locations ORDER BY block ASC, location_name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                CampusLocation loc = new CampusLocation(
                    rs.getInt("location_id"),
                    rs.getString("block"),
                    rs.getString("location_name"),
                    rs.getString("location_type"),
                    rs.getBoolean("active")
                );
                list.add(loc);
            }
        } catch (Exception e) {
            System.err.println("[LocationDAO] getAllLocations error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Retrieves unique blocks from database.
     */
    public List<String> getDistinctBlocks() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT block FROM locations WHERE active = TRUE ORDER BY block ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("block"));
            }
        } catch (Exception e) {
            System.err.println("[LocationDAO] getDistinctBlocks error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    /**
     * Adds a new campus location (admin feature).
     */
    public boolean addLocation(CampusLocation loc) {
        String sql = "INSERT INTO locations (block, location_name, location_type, active) VALUES (?, ?, ?, TRUE)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, loc.getBlock().trim());
            stmt.setString(2, loc.getLocationName().trim());
            stmt.setString(3, loc.getLocationType().trim());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[LocationDAO] addLocation error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }

    /**
     * Toggles active status of a location.
     */
    public boolean toggleLocationStatus(int locationId, boolean active) {
        String sql = "UPDATE locations SET active = ? WHERE location_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setBoolean(1, active);
            stmt.setInt(2, locationId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[LocationDAO] toggleLocationStatus error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }
}
