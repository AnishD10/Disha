package com.disha.model;

/**
 * Represents a college/degree option returned by the Decision Planning engine.
 * Each record is a matched programme filtered against the student's
 * constraints.
 */
public class DecisionPlan {

    private int planId;
    private String collegeName;
    private String degreeName;
    private String faculty; // Science, Management, Humanities, etc.
    private String location; // District / Province
    private double annualFeeNPR;
    private double minimumPercentage; // minimum academic score required
    private String careerPath; // comma-separated career tags
    private String affiliation; // TU, PU, KU, etc.
    private int durationYears;
    private boolean scholarshipAvailable;
    private String contactInfo;

    // ── Constructors ──────────────────────────────────────────────────────────

    public DecisionPlan() {
    }
    //sample
// added
    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
    }

    public String getCollegeName() {
        return collegeName;
    }

    public void setCollegeName(String collegeName) {
        this.collegeName = collegeName;
    }

    public String getDegreeName() {
        return degreeName;
    }

    public void setDegreeName(String degreeName) {
        this.degreeName = degreeName;
    }

    public String getFaculty() {
        return faculty;
    }

    public void setFaculty(String faculty) {
        this.faculty = faculty;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public double getAnnualFeeNPR() {
        return annualFeeNPR;
    }

    public void setAnnualFeeNPR(double annualFeeNPR) {
        this.annualFeeNPR = annualFeeNPR;
    }

    public double getMinimumPercentage() {
        return minimumPercentage;
    }

    public void setMinimumPercentage(double minimumPercentage) {
        this.minimumPercentage = minimumPercentage;
    }

    public String getCareerPath() {
        return careerPath;
    }

    public void setCareerPath(String careerPath) {
        this.careerPath = careerPath;
    }

    public String getAffiliation() {
        return affiliation;
    }

    public void setAffiliation(String affiliation) {
        this.affiliation = affiliation;
    }

    public int getDurationYears() {
        return durationYears;
    }

    public void setDurationYears(int durationYears) {
        this.durationYears = durationYears;
    }

    public boolean isScholarshipAvailable() {
        return scholarshipAvailable;
    }

    public void setScholarshipAvailable(boolean scholarshipAvailable) {
        this.scholarshipAvailable = scholarshipAvailable;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    @Override
    public String toString() {
        return "DecisionPlan{college='" + collegeName + "', degree='" + degreeName
                + "', fee=" + annualFeeNPR + ", location='" + location + "'}";
    }

}