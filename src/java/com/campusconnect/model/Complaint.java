package com.campusconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Model class representing a Complaint issue.
 */
public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    private String complaintId;
    private String rollNumber;
    private String studentName;
    private String studentPhone;
    private String studentEmail;
    private String category;
    private int locationId;
    private String locationName;
    private String block;
    private String subject;
    private String description;
    private String priority;
    private String status;
    private Integer assignedStaffId;
    private String assignedStaffName;
    private String assignedDepartment;
    private String adminRemarks;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp resolvedAt;

    public Complaint() {
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

    public String getStudentPhone() {
        return studentPhone;
    }

    public void setStudentPhone(String studentPhone) {
        this.studentPhone = studentPhone;
    }

    public String getStudentEmail() {
        return studentEmail;
    }

    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public String getBlock() {
        return block;
    }

    public void setBlock(String block) {
        this.block = block;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAssignedStaffId() {
        return assignedStaffId;
    }

    public void setAssignedStaffId(Integer assignedStaffId) {
        this.assignedStaffId = assignedStaffId;
    }

    public String getAssignedStaffName() {
        return assignedStaffName;
    }

    public void setAssignedStaffName(String assignedStaffName) {
        this.assignedStaffName = assignedStaffName;
    }

    public String getAssignedDepartment() {
        return assignedDepartment;
    }

    public void setAssignedDepartment(String assignedDepartment) {
        this.assignedDepartment = assignedDepartment;
    }

    public String getAdminRemarks() {
        return adminRemarks;
    }

    public void setAdminRemarks(String adminRemarks) {
        this.adminRemarks = adminRemarks;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public String getFormattedCreatedDate() {
        if (createdAt == null) return "";
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(createdAt);
    }

    public String getFormattedResolvedDate() {
        if (resolvedAt == null) return "Pending";
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(resolvedAt);
    }

    public String getPriorityBadgeClass() {
        if ("Urgent".equalsIgnoreCase(priority)) return "bg-danger";
        if ("High".equalsIgnoreCase(priority)) return "bg-warning text-dark";
        if ("Medium".equalsIgnoreCase(priority)) return "bg-primary";
        return "bg-secondary";
    }

    public String getStatusBadgeClass() {
        if ("RESOLVED".equalsIgnoreCase(status) || "CLOSED".equalsIgnoreCase(status)) return "bg-success";
        if ("IN PROGRESS".equalsIgnoreCase(status)) return "bg-info text-dark";
        if ("ASSIGNED".equalsIgnoreCase(status)) return "bg-warning text-dark";
        if ("REJECTED".equalsIgnoreCase(status)) return "bg-danger";
        return "bg-secondary";
    }

    /**
     * Timeline stage integer: 1=Submitted, 2=Assigned, 3=In Progress, 4=Resolved, 5=Closed
     */
    public int getTimelineStage() {
        if ("CLOSED".equalsIgnoreCase(status)) return 5;
        if ("RESOLVED".equalsIgnoreCase(status)) return 4;
        if ("IN PROGRESS".equalsIgnoreCase(status)) return 3;
        if ("ASSIGNED".equalsIgnoreCase(status)) return 2;
        if ("REJECTED".equalsIgnoreCase(status)) return -1;
        return 1; // PENDING / Submitted
    }
}
