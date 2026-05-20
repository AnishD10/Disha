package com.disha.model.assessment;

import java.sql.Timestamp;

public class AssessmentAttempt {
    private int attemptId;
    private int studentId;
    private Timestamp attemptDate;
    private boolean completed;
    private int aptitudeScore;
    private int personalityScore;
    private int interestScore;
    private String personalityCluster;

    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public Timestamp getAttemptDate() { return attemptDate; }
    public void setAttemptDate(Timestamp attemptDate) { this.attemptDate = attemptDate; }
    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }
    public int getAptitudeScore() { return aptitudeScore; }
    public void setAptitudeScore(int aptitudeScore) { this.aptitudeScore = aptitudeScore; }
    public int getPersonalityScore() { return personalityScore; }
    public void setPersonalityScore(int personalityScore) { this.personalityScore = personalityScore; }
    public int getInterestScore() { return interestScore; }
    public void setInterestScore(int interestScore) { this.interestScore = interestScore; }
    public String getPersonalityCluster() { return personalityCluster; }
    public void setPersonalityCluster(String personalityCluster) { this.personalityCluster = personalityCluster; }
}
