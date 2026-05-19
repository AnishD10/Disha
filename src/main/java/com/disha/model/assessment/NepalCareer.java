package com.disha.model.assessment;

/**
 * Represents a career path in the Nepal job market.
 * Careers are stored in the database and matched to students based on their
 * personality clusters (e.g., Analytical, Social) and minimum aptitude requirements.
 * 
 * @author Ashmit
 */
public class NepalCareer {

    private int careerId;
    private String careerName;
    private String careerDescription;
    private String suitableClusters;    // comma-separated e.g. "Analytical,Creative"
    private int minAptitudeScore;
    private String nepalRelevanceNote;

    public NepalCareer() {
    }

    public int getCareerId() {
        return careerId;
    }

    public void setCareerId(int careerId) {
        this.careerId = careerId;
    }

    public String getCareerName() {
        return careerName;
    }

    public void setCareerName(String careerName) {
        this.careerName = careerName;
    }

    public String getCareerDescription() {
        return careerDescription;
    }

    public void setCareerDescription(String careerDescription) {
        this.careerDescription = careerDescription;
    }

    public String getSuitableClusters() {
        return suitableClusters;
    }

    public void setSuitableClusters(String suitableClusters) {
        this.suitableClusters = suitableClusters;
    }

    public int getMinAptitudeScore() {
        return minAptitudeScore;
    }

    public void setMinAptitudeScore(int minAptitudeScore) {
        this.minAptitudeScore = minAptitudeScore;
    }

    public String getNepalRelevanceNote() {
        return nepalRelevanceNote;
    }

    public void setNepalRelevanceNote(String nepalRelevanceNote) {
        this.nepalRelevanceNote = nepalRelevanceNote;
    }
}
