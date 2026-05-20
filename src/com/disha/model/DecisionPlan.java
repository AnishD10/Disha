package com.disha.model;

/**
 * DecisionPlan — Represents one college/degree programme returned
 * by the Decision Planning constraint filter.
 */
public class DecisionPlan {

    private int     planId;
    private String  collegeName;
    private String  degreeName;
    private String  faculty;
    private String  location;
    private double  annualFeeNPR;
    private double  minimumPercentage;
    private String  careerPath;
    private String  affiliation;
    private int     durationYears;
    private boolean scholarshipAvailable;
    private String  contactInfo;

    // ── Constructors ──────────────────────────────────────────────────────────
    public DecisionPlan() {}

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public int     getPlanId()                               { return planId; }
    public void    setPlanId(int planId)                     { this.planId = planId; }

    public String  getCollegeName()                          { return collegeName; }
    public void    setCollegeName(String collegeName)        { this.collegeName = collegeName; }

    public String  getDegreeName()                           { return degreeName; }
    public void    setDegreeName(String degreeName)          { this.degreeName = degreeName; }

    public String  getFaculty()                              { return faculty; }
    public void    setFaculty(String faculty)                { this.faculty = faculty; }

    public String  getLocation()                             { return location; }
    public void    setLocation(String location)              { this.location = location; }

    public double  getAnnualFeeNPR()                         { return annualFeeNPR; }
    public void    setAnnualFeeNPR(double annualFeeNPR)      { this.annualFeeNPR = annualFeeNPR; }

    public double  getMinimumPercentage()                          { return minimumPercentage; }
    public void    setMinimumPercentage(double minimumPercentage)  { this.minimumPercentage = minimumPercentage; }

    public String  getCareerPath()                           { return careerPath; }
    public void    setCareerPath(String careerPath)          { this.careerPath = careerPath; }

    public String  getAffiliation()                          { return affiliation; }
    public void    setAffiliation(String affiliation)        { this.affiliation = affiliation; }

    public int     getDurationYears()                        { return durationYears; }
    public void    setDurationYears(int durationYears)       { this.durationYears = durationYears; }

    public boolean isScholarshipAvailable()                              { return scholarshipAvailable; }
    public void    setScholarshipAvailable(boolean scholarshipAvailable) { this.scholarshipAvailable = scholarshipAvailable; }

    public String  getContactInfo()                          { return contactInfo; }
    public void    setContactInfo(String contactInfo)        { this.contactInfo = contactInfo; }
}
