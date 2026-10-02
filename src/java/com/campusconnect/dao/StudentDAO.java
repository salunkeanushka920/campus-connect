package com.campusconnect.dao;

import com.campusconnect.model.Student;
import com.campusconnect.util.DBConnection;
import com.campusconnect.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Student operations.
 * Uses PreparedStatement for all operations to prevent SQL injection.
 */
public class StudentDAO {

    /**
     * Registers a new student.
     * @return true if inserted, false otherwise.
     */
    public boolean registerStudent(Student student) throws SQLException {
        String sql = "INSERT INTO students (roll_number, full_name, email, phone, course, \"year\", division, password) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, student.getRollNumber().trim());
            stmt.setString(2, student.getFullName().trim());
            stmt.setString(3, student.getEmail().trim());
            stmt.setString(4, student.getPhone().trim());
            stmt.setString(5, student.getCourse().trim());
            stmt.setString(6, student.getYear().trim());
            stmt.setString(7, student.getDivision().trim());
            stmt.setString(8, PasswordUtil.hashPassword(student.getPassword()));

            int rows = stmt.executeUpdate();
            return rows > 0;
        } finally {
            DBConnection.close(conn, stmt, null);
        }
    }

    /**
     * Authenticates student by roll number and password.
     */
    public Student authenticate(String rollNumber, String plainPassword) {
        String sql = "SELECT * FROM students WHERE roll_number = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, rollNumber.trim());
            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(plainPassword, storedPassword)) {
                    Student s = new Student();
                    s.setRollNumber(rs.getString("roll_number"));
                    s.setFullName(rs.getString("full_name"));
                    s.setEmail(rs.getString("email"));
                    s.setPhone(rs.getString("phone"));
                    s.setCourse(rs.getString("course"));
                    s.setYear(rs.getString("year"));
                    s.setDivision(rs.getString("division"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    return s;
                }
            }
        } catch (Exception e) {
            System.err.println("[StudentDAO] Authentication error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    /**
     * Checks if a roll number is already registered.
     */
    public boolean isRollNumberExists(String rollNumber) {
        String sql = "SELECT roll_number FROM students WHERE roll_number = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, rollNumber.trim());
            rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.err.println("[StudentDAO] Check roll number error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
    }

    /**
     * Retrieves student profile by roll number.
     */
    public Student getStudentByRollNumber(String rollNumber) {
        String sql = "SELECT * FROM students WHERE roll_number = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, rollNumber.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                Student s = new Student();
                s.setRollNumber(rs.getString("roll_number"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                s.setCourse(rs.getString("course"));
                s.setYear(rs.getString("year"));
                s.setDivision(rs.getString("division"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                return s;
            }
        } catch (Exception e) {
            System.err.println("[StudentDAO] getStudent error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    /**
     * Retrieves all students for Admin view.
     */
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT roll_number, full_name, email, phone, course, \"year\", division, created_at FROM students ORDER BY roll_number ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setRollNumber(rs.getString("roll_number"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                s.setCourse(rs.getString("course"));
                s.setYear(rs.getString("year"));
                s.setDivision(rs.getString("division"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }
        } catch (Exception e) {
            System.err.println("[StudentDAO] getAllStudents error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }
}
