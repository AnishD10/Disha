package com.disha.model.counselor;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CounselorDashboardData {
    private int totalStudents;
    private int completedAssessments;
    private int flaggedStudents;
    private double averageAptitudeScore;
    private String topCluster;
    private List<StudentSummary> students = new ArrayList<>();
    private List<ClusterStat> clusterStats = new ArrayList<>();
    private List<CareerInterestStat> careerInterestStats = new ArrayList<>();

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getCompletedAssessments() {
        return completedAssessments;
    }

    public void setCompletedAssessments(int completedAssessments) {
        this.completedAssessments = completedAssessments;
    }

    public int getFlaggedStudents() {
        return flaggedStudents;
    }

    public void setFlaggedStudents(int flaggedStudents) {
        this.flaggedStudents = flaggedStudents;
    }

    public double getAverageAptitudeScore() {
        return averageAptitudeScore;
    }

    public void setAverageAptitudeScore(double averageAptitudeScore) {
        this.averageAptitudeScore = averageAptitudeScore;
    }

    public String getTopCluster() {
        return topCluster;
    }

    public void setTopCluster(String topCluster) {
        this.topCluster = topCluster;
    }

    public List<StudentSummary> getStudents() {
        return students;
    }

    public void setStudents(List<StudentSummary> students) {
        this.students = students == null ? new ArrayList<StudentSummary>() : students;
    }

    public List<ClusterStat> getClusterStats() {
        return clusterStats;
    }

    public void setClusterStats(List<ClusterStat> clusterStats) {
        this.clusterStats = clusterStats == null ? new ArrayList<ClusterStat>() : clusterStats;
    }

    public List<CareerInterestStat> getCareerInterestStats() {
        return careerInterestStats;
    }

    public void setCareerInterestStats(List<CareerInterestStat> careerInterestStats) {
        this.careerInterestStats = careerInterestStats == null
                ? new ArrayList<CareerInterestStat>()
                : careerInterestStats;
    }

    public static class StudentSummary {
        private int userId;
        private String fullName;
        private String email;
        private Integer attemptId;
        private Timestamp attemptDate;
        private Integer aptitudeScore;
        private Integer personalityScore;
        private Integer interestScore;
        private String personalityCluster;
        private boolean atRisk;
        private String assignmentStatus;
        private String counselorNote;

        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public Integer getAttemptId() {
            return attemptId;
        }

        public void setAttemptId(Integer attemptId) {
            this.attemptId = attemptId;
        }

        public Timestamp getAttemptDate() {
            return attemptDate;
        }

        public void setAttemptDate(Timestamp attemptDate) {
            this.attemptDate = attemptDate;
        }

        public Integer getAptitudeScore() {
            return aptitudeScore;
        }

        public void setAptitudeScore(Integer aptitudeScore) {
            this.aptitudeScore = aptitudeScore;
        }

        public Integer getPersonalityScore() {
            return personalityScore;
        }

        public void setPersonalityScore(Integer personalityScore) {
            this.personalityScore = personalityScore;
        }

        public Integer getInterestScore() {
            return interestScore;
        }

        public void setInterestScore(Integer interestScore) {
            this.interestScore = interestScore;
        }

        public String getPersonalityCluster() {
            return personalityCluster;
        }

        public void setPersonalityCluster(String personalityCluster) {
            this.personalityCluster = personalityCluster;
        }

        public boolean isAtRisk() {
            return atRisk;
        }

        public void setAtRisk(boolean atRisk) {
            this.atRisk = atRisk;
        }

        public String getAssignmentStatus() {
            return assignmentStatus;
        }

        public void setAssignmentStatus(String assignmentStatus) {
            this.assignmentStatus = assignmentStatus;
        }

        public String getCounselorNote() {
            return counselorNote;
        }

        public void setCounselorNote(String counselorNote) {
            this.counselorNote = counselorNote;
        }

        public boolean hasCompletedAssessment() {
            return attemptId != null;
        }

        public String getAssessmentStatusLabel() {
            return hasCompletedAssessment() ? "Completed" : "Pending";
        }
    }

    public static class ClusterStat {
        private String clusterName;
        private int total;

        public String getClusterName() {
            return clusterName;
        }

        public void setClusterName(String clusterName) {
            this.clusterName = clusterName;
        }

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }
    }

    public static class CareerInterestStat {
        private String careerName;
        private int total;

        public String getCareerName() {
            return careerName;
        }

        public void setCareerName(String careerName) {
            this.careerName = careerName;
        }

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }
    }
}
