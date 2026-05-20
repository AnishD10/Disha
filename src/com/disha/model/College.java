package com.disha.model;

import java.sql.Timestamp;

/**
 * College model representing educational institutions.
 * Maps to the 'colleges' table.
 */
public class College {
    private int collegeId;
    private String collegeName;
    private String collegeLocation;
    private String collegeCity;
    private String collegeDescription;
    private String websiteUrl;
    private String contactEmail;
    private String contactPhone;
    private boolean isPublic;
    private boolean isVerified;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public College() {}

    // Getters & Setters
    public int getCollegeId() { return collegeId; }
    public void setCollegeId(int collegeId) { this.collegeId = collegeId; }

    public String getCollegeName() { return collegeName; }
    public void setCollegeName(String collegeName) { this.collegeName = collegeName; }

    public String getCollegeLocation() { return collegeLocation; }
    public void setCollegeLocation(String collegeLocation) { this.collegeLocation = collegeLocation; }

    public String getCollegeCity() { return collegeCity; }
    public void setCollegeCity(String collegeCity) { this.collegeCity = collegeCity; }

    public String getCollegeDescription() { return collegeDescription; }
    public void setCollegeDescription(String collegeDescription) { this.collegeDescription = collegeDescription; }

    public String getWebsiteUrl() { return websiteUrl; }
    public void setWebsiteUrl(String websiteUrl) { this.websiteUrl = websiteUrl; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public boolean isPublic() { return isPublic; }
    public void setPublic(boolean isPublic) { this.isPublic = isPublic; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
