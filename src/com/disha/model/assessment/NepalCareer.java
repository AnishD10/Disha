package com.disha.model.assessment;

public class NepalCareer {
    private int careerId;
    private String careerName;
    private String careerDescription;
    private String suitableClusters;
    private int minAptitudeScore;
    private String nepalRelevanceNote;

    public int getCareerId() { return careerId; }
    public void setCareerId(int careerId) { this.careerId = careerId; }
    public String getCareerName() { return careerName; }
    public void setCareerName(String careerName) { this.careerName = careerName; }
    public String getCareerDescription() { return careerDescription; }
    public void setCareerDescription(String careerDescription) { this.careerDescription = careerDescription; }
    public String getSuitableClusters() { return suitableClusters; }
    public void setSuitableClusters(String suitableClusters) { this.suitableClusters = suitableClusters; }
    public int getMinAptitudeScore() { return minAptitudeScore; }
    public void setMinAptitudeScore(int minAptitudeScore) { this.minAptitudeScore = minAptitudeScore; }
    public String getNepalRelevanceNote() { return nepalRelevanceNote; }
    public void setNepalRelevanceNote(String nepalRelevanceNote) { this.nepalRelevanceNote = nepalRelevanceNote; }
}
