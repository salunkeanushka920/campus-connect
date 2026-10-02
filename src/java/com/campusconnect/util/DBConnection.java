package com.campusconnect.util;

import java.net.InetSocketAddress;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.DatabaseMetaData;

/**
 * Resilient Dual-Engine Database Connection Manager.
 * Probes for MySQL (port 3306) in 250ms; if offline, seamlessly uses NetBeans Java DB (port 1527).
 */
public class DBConnection {

    private static final String MYSQL_HOST = "localhost";
    private static final int MYSQL_PORT = 3306;
    private static final String MYSQL_DB = "campus_connect";
    private static final String MYSQL_URL = "jdbc:mysql://" + MYSQL_HOST + ":" + MYSQL_PORT + "/" + MYSQL_DB 
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8&connectTimeout=1000";
    private static final String MYSQL_USER = "root";
    private static final String MYSQL_PASSWORD = "";

    private static final String DERBY_URL = "jdbc:derby://localhost:1527/campus_connect;create=true";
    private static final String DERBY_USER = "app";
    private static final String DERBY_PASSWORD = "app";

    private static volatile boolean derbySchemaInitialized = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            try { Class.forName("com.mysql.jdbc.Driver"); } catch (ClassNotFoundException ignored) {}
        }
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException ignored) {}
    }

    /**
     * Checks if MySQL port 3306 is actively accepting TCP connections.
     */
    private static boolean isMysqlListening() {
        try (Socket s = new Socket()) {
            s.connect(new InetSocketAddress(MYSQL_HOST, MYSQL_PORT), 250); // fast 250ms check
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Obtains an active database connection.
     * Uses MySQL if online; otherwise uses active NetBeans Java DB on port 1527.
     */
    public static Connection getConnection() throws SQLException {
        if (isMysqlListening()) {
            try {
                return DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD);
            } catch (SQLException e1) {
                try {
                    return DriverManager.getConnection(MYSQL_URL, MYSQL_USER, "root");
                } catch (SQLException ignored) {}
            }
        }

        // Use NetBeans Java DB (Derby on port 1527)
        Connection derbyConn = DriverManager.getConnection(DERBY_URL, DERBY_USER, DERBY_PASSWORD);
        if (!derbySchemaInitialized) {
            initDerbySchema(derbyConn);
        }
        return derbyConn;
    }

    private static synchronized void initDerbySchema(Connection conn) {
        if (derbySchemaInitialized) return;
        try {
            DatabaseMetaData dbm = conn.getMetaData();
            Statement stmt = conn.createStatement();

            // 1. Students
            ResultSet rs = dbm.getTables(null, null, "STUDENTS", null);
            if (!rs.next()) {
                stmt.executeUpdate("CREATE TABLE students (" +
                    "roll_number VARCHAR(50) NOT NULL PRIMARY KEY, " +
                    "full_name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL, " +
                    "phone VARCHAR(20) NOT NULL, " +
                    "course VARCHAR(50) NOT NULL, " +
                    "\"year\" VARCHAR(20) NOT NULL, " +
                    "division VARCHAR(10) NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            }

            // 2. Admins
            rs = dbm.getTables(null, null, "ADMINS", null);
            if (!rs.next()) {
                stmt.executeUpdate("CREATE TABLE admins (" +
                    "id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                    "username VARCHAR(50) NOT NULL UNIQUE, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "full_name VARCHAR(100) NOT NULL)");
                stmt.executeUpdate("INSERT INTO admins (username, password, full_name) VALUES ('admin', 'admin123', 'Campus Administrator')");
            }

            // 3. Locations
            rs = dbm.getTables(null, null, "LOCATIONS", null);
            if (!rs.next()) {
                stmt.executeUpdate("CREATE TABLE locations (" +
                    "location_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                    "block VARCHAR(50) NOT NULL, " +
                    "location_name VARCHAR(100) NOT NULL, " +
                    "location_type VARCHAR(50) NOT NULL, " +
                    "active BOOLEAN DEFAULT TRUE)");
                stmt.executeUpdate("INSERT INTO locations (block, location_name, location_type, active) VALUES " +
                    "('A Block', 'A-01 Lecture Hall', 'Classroom', TRUE), " +
                    "('A Block', 'A-02 Smart Classroom', 'Classroom', TRUE), " +
                    "('A Block', 'Staff Room', 'Faculty', TRUE), " +
                    "('X Block', 'Computer Lab 1', 'Laboratory', TRUE), " +
                    "('X Block', 'Lopez Lab (Electronics)', 'Laboratory', TRUE), " +
                    "('Y Block', 'Y-20 Classroom', 'Classroom', TRUE), " +
                    "('Central Block', 'Reading Room (Library)', 'Library', TRUE), " +
                    "('Central Block', 'Main Seminar Hall', 'Auditorium', TRUE)");
            }

            // 4. Staff
            rs = dbm.getTables(null, null, "STAFF", null);
            if (!rs.next()) {
                stmt.executeUpdate("CREATE TABLE staff (" +
                    "staff_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                    "staff_name VARCHAR(100) NOT NULL, " +
                    "department VARCHAR(100) NOT NULL, " +
                    "contact VARCHAR(50) NOT NULL, " +
                    "active BOOLEAN DEFAULT TRUE)");
                stmt.executeUpdate("INSERT INTO staff (staff_name, department, contact, active) VALUES " +
                    "('Rajesh Verma', 'Electrical Department', '+91 98201 11223', TRUE), " +
                    "('Sanjay Kulkarni', 'Air Conditioning & Cooling', '+91 98202 22334', TRUE), " +
                    "('Amit Deshmukh', 'IT Support & Systems', '+91 98203 33445', TRUE), " +
                    "('Sunita Shinde', 'Housekeeping & Cleanliness', '+91 98204 44556', TRUE)");
            }

            // 5. Complaints
            rs = dbm.getTables(null, null, "COMPLAINTS", null);
            if (!rs.next()) {
                stmt.executeUpdate("CREATE TABLE complaints (" +
                    "complaint_id VARCHAR(50) NOT NULL PRIMARY KEY, " +
                    "roll_number VARCHAR(50) NOT NULL, " +
                    "category VARCHAR(50) NOT NULL, " +
                    "location_id INT NOT NULL, " +
                    "subject VARCHAR(200) NOT NULL, " +
                    "description VARCHAR(3000) NOT NULL, " +
                    "priority VARCHAR(20) DEFAULT 'Medium', " +
                    "status VARCHAR(30) DEFAULT 'PENDING', " +
                    "assigned_staff_id INT, " +
                    "admin_remarks VARCHAR(2000), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "resolved_at TIMESTAMP)");
            }

            // 6. Lost & Found
            rs = dbm.getTables(null, null, "LOST_FOUND", null);
            if (!rs.next()) {
                stmt.executeUpdate("CREATE TABLE lost_found (" +
                    "id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                    "roll_number VARCHAR(50) NOT NULL, " +
                    "type VARCHAR(10) NOT NULL, " +
                    "item_name VARCHAR(100) NOT NULL, " +
                    "category VARCHAR(50) NOT NULL, " +
                    "description VARCHAR(2000) NOT NULL, " +
                    "location VARCHAR(100) NOT NULL, " +
                    "report_date DATE NOT NULL, " +
                    "status VARCHAR(20) DEFAULT 'OPEN', " +
                    "contact VARCHAR(100) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            }

            // 7. Feedback
            rs = dbm.getTables(null, null, "FEEDBACK", null);
            if (!rs.next()) {
                stmt.executeUpdate("CREATE TABLE feedback (" +
                    "id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                    "complaint_id VARCHAR(50) NOT NULL, " +
                    "roll_number VARCHAR(50) NOT NULL, " +
                    "rating INT NOT NULL, " +
                    "message VARCHAR(2000) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            }

            stmt.close();
            derbySchemaInitialized = true;
        } catch (Exception e) {
            System.err.println("[CampusConnect DB] Error initializing schema: " + e.getMessage());
        }
    }

    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) { try { rs.close(); } catch (SQLException ignored) {} }
        if (stmt != null) { try { stmt.close(); } catch (SQLException ignored) {} }
        if (conn != null) { try { conn.close(); } catch (SQLException ignored) {} }
    }
}
