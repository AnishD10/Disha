package com.disha.model.assessment;

import java.sql.Timestamp;

/**
 * Represents a single assessment session completed by a student.
 * It stores the timestamp of the test, raw section scores, and the 
 * final personality cluster determined by the scoring algorithm.
 * 
 * @author Ashmit
 */
public class AssessmentAttempt {

    private int attemptId;
    private int studentId;
    private Timestamp attemptDate;
    /** Whether the assessment was submitted and finalized */
    private boolean completed;
    /** Total correct answers for the Aptitude section (Max 10) */
    private int aptitudeScore;       
    /** Total Likert-scale value for the Personality section (Max 50) */
    private int personalityScore;    
    /** Total Likert-scale value for the Interest section (Max 50) */
    private int interestScore;       
    /** The dominant trait determined (e.g., Analytical, Social, Creative, or Practical) */
    private String personalityCluster; 

    public AssessmentAttempt() {
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public Timestamp getAttemptDate() {
        return attemptDate;
    }

    public void setAttemptDate(Timestamp attemptDate) {
        this.attemptDate = attemptDate;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public int getAptitudeScore() {
        return aptitudeScore;
    }

    public void setAptitudeScore(int aptitudeScore) {
        this.aptitudeScore = aptitudeScore;
    }

    public int getPersonalityScore() {
        return personalityScore;
    }

    public void setPersonalityScore(int personalityScore) {
        this.personalityScore = personalityScore;
    }

    public int getInterestScore() {
        return interestScore;
    }

    public void setInterestScore(int interestScore) {
        this.interestScore = interestScore;
    }

    public String getPersonalityCluster() {
        return personalityCluster;
    }

    public void setPersonalityCluster(String personalityCluster) {
        this.personalityCluster = personalityCluster;
    }
}
