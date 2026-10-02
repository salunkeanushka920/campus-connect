package com.campusconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model class representing a registered Student in the system.
 */
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private String rollNumber;
    private String fullName;
    private String email;
    private String phone;
    private String course;
    private String year;
    private String division;
    private String password;
    private Timestamp createdAt;

    public Student() {
    }

    public Student(String rollNumber, String fullName, String email, String phone, 
                   String course, String year, String division, String password) {
        this.rollNumber = rollNumber;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.course = course;
        this.year = year;
        this.division = division;
        this.password = password;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getDivision() {
        return division;
    }

    public void setDivision(String division) {
        this.division = division;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
