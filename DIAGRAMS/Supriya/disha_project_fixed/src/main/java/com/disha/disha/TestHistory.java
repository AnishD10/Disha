package com.disha.disha;

/**
 * TestHistory — holds one row from the test_history table joined with assessments.
 * Populated by PersonalDashboardServlet.
 */
public class TestHistory {

    private int    id;
    private String assessmentName;
    private String dateTaken;
    private int    score;
    private int    assessmentId;

    public TestHistory() {}

    public int    getId()                             { return id; }
    public void   setId(int id)                       { this.id = id; }

    public String getAssessmentName()                  { return assessmentName; }
    public void   setAssessmentName(String name)       { this.assessmentName = name; }

    public String getDateTaken()                       { return dateTaken; }
    public void   setDateTaken(String dateTaken)       { this.dateTaken = dateTaken; }

    public int    getScore()                           { return score; }
    public void   setScore(int score)                  { this.score = score; }

    public int    getAssessmentId()                    { return assessmentId; }
    public void   setAssessmentId(int assessmentId)    { this.assessmentId = assessmentId; }

    /**
     * Returns a label string based on the score.
     * Used in JSP: ${th.resultLabel}
     */
    public String getResultLabel() {
        if (score >= 70) return "Excellent";
        if (score >= 50) return "Average";
        return "Needs Work";
    }

    /**
     * Returns the CSS badge class based on the score.
     * Used in JSP: ${th.badgeClass}
     */
    public String getBadgeClass() {
        if (score >= 70) return "badge-green";
        if (score >= 50) return "badge-blue";
        return "badge-orange";
    }
}
