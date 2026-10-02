package com.campusconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Model class representing post-resolution student feedback.
 */
public class Feedback implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String complaintId;
    private String rollNumber;
    private String studentName;
    private String complaintSubject;
    private int rating; // 1 to 5
    private String message;
    private Timestamp createdAt;

    public Feedback() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(String complaintId) {
        this.complaintId = complaintId;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getComplaintSubject() {
        return complaintSubject;
    }

    public void setComplaintSubject(String complaintSubject) {
        this.complaintSubject = complaintSubject;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStarsDisplay() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < rating; i++) {
            sb.append("★");
        }
        for (int i = rating; i < 5; i++) {
            sb.append("☆");
        }
        return sb.toString();
    }

    public String getFormattedDate() {
        if (createdAt == null) return "";
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(createdAt);
    }
}
