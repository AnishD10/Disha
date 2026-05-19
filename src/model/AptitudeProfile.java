package model;

/**
 * Student aptitude score snapshot used by the career recommendation engine.
 */
public class AptitudeProfile {
    private int studentId;
    private int analyticalScore;
    private int creativityScore;
    private int leadershipScore;
    private int technicalScore;
    private int communicationScore;
    private int entrepreneurialScore;
    private int researchScore;

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getAnalyticalScore() {
        return analyticalScore;
    }

    public void setAnalyticalScore(int analyticalScore) {
        this.analyticalScore = analyticalScore;
    }

    public int getCreativityScore() {
        return creativityScore;
    }

    public void setCreativityScore(int creativityScore) {
        this.creativityScore = creativityScore;
    }

    public int getLeadershipScore() {
        return leadershipScore;
    }

    public void setLeadershipScore(int leadershipScore) {
        this.leadershipScore = leadershipScore;
    }

    public int getTechnicalScore() {
        return technicalScore;
    }

    public void setTechnicalScore(int technicalScore) {
        this.technicalScore = technicalScore;
    }

    public int getCommunicationScore() {
        return communicationScore;
    }

    public void setCommunicationScore(int communicationScore) {
        this.communicationScore = communicationScore;
    }

    public int getEntrepreneurialScore() {
        return entrepreneurialScore;
    }

    public void setEntrepreneurialScore(int entrepreneurialScore) {
        this.entrepreneurialScore = entrepreneurialScore;
    }

    public int getResearchScore() {
        return researchScore;
    }

    public void setResearchScore(int researchScore) {
        this.researchScore = researchScore;
    }
}
