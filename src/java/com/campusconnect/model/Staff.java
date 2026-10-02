package com.campusconnect.model;

import java.io.Serializable;

/**
 * Model class representing maintenance or academic staff members.
 */
public class Staff implements Serializable {
    private static final long serialVersionUID = 1L;

    private int staffId;
    private String staffName;
    private departmentEnum department;
    private String departmentName;
    private String contact;
    private boolean active;

    public enum departmentEnum {
        ELECTRICAL, AC, IT, CLEANING, CARPENTRY, SECURITY, ACADEMIC, OTHER
    }

    public Staff() {
    }

    public Staff(int staffId, String staffName, String departmentName, String contact, boolean active) {
        this.staffId = staffId;
        this.staffName = staffName;
        this.departmentName = departmentName;
        this.contact = contact;
        this.active = active;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getDisplayName() {
        return staffName + " (" + departmentName + ")";
    }
}
