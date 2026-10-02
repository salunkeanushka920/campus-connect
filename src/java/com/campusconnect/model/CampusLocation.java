package com.campusconnect.model;

import java.io.Serializable;

/**
 * Model class representing a college location (block, room, lab, hall).
 */
public class CampusLocation implements Serializable {
    private static final long serialVersionUID = 1L;

    private int locationId;
    private String block;
    private String locationName;
    private String locationType;
    private boolean active;

    public CampusLocation() {
    }

    public CampusLocation(int locationId, String block, String locationName, String locationType, boolean active) {
        this.locationId = locationId;
        this.block = block;
        this.locationName = locationName;
        this.locationType = locationType;
        this.active = active;
    }

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public String getBlock() {
        return block;
    }

    public void setBlock(String block) {
        this.block = block;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public String getLocationType() {
        return locationType;
    }

    public void setLocationType(String locationType) {
        this.locationType = locationType;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getDisplayName() {
        return block + " - " + locationName;
    }
}
