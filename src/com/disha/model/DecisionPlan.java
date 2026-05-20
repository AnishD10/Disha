package com.disha.model;

public class DecisionPlan {

    private int planId;
    private String collegeName;
    private String degreeName;
    private String faculty;
    private int durationYears;
    private String affiliation;
    private boolean scholarshipAvailable;
    private double annualFeeNPR;
    private double minimumPercentage;
    private String location;
    private String careerPath;
    private String contactInfo;

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

    public int getDurationYears() {
        return durationYears;
    }

    public void setDurationYears(int durationYears) {
        this.durationYears = durationYears;
    }

    public String getAffiliation() {
        return affiliation;
    }

    public void setAffiliation(String affiliation) {
        this.affiliation = affiliation;
    }

    public boolean isScholarshipAvailable() {
        return scholarshipAvailable;
    }

    public void setScholarshipAvailable(boolean scholarshipAvailable) {
        this.scholarshipAvailable = scholarshipAvailable;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getCareerPath() {
        return careerPath;
    }

    public void setCareerPath(String careerPath) {
        this.careerPath = careerPath;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }
}
