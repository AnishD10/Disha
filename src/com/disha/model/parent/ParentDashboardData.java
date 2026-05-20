package com.disha.model.parent;

import com.disha.model.User;
import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.assessment.AttemptSkill;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

public class ParentDashboardData {
    private User child;
    private AssessmentAttempt latestAttempt;
    private List<AttemptSkill> skills = new ArrayList<>();
    private List<CareerRecommendation> careerRecommendations = new ArrayList<>();
    private List<DegreeOption> degreeOptions = new ArrayList<>();
    private int selectedBudget;

    public User getChild() {
        return child;
    }

    public void setChild(User child) {
        this.child = child;
    }

    public AssessmentAttempt getLatestAttempt() {
        return latestAttempt;
    }

    public void setLatestAttempt(AssessmentAttempt latestAttempt) {
        this.latestAttempt = latestAttempt;
    }

    public List<AttemptSkill> getSkills() {
        return skills;
    }

    public void setSkills(List<AttemptSkill> skills) {
        this.skills = skills == null ? new ArrayList<AttemptSkill>() : skills;
    }

    public List<CareerRecommendation> getCareerRecommendations() {
        return careerRecommendations;
    }

    public void setCareerRecommendations(List<CareerRecommendation> careerRecommendations) {
        this.careerRecommendations = careerRecommendations == null
                ? new ArrayList<CareerRecommendation>()
                : careerRecommendations;
    }

    public List<DegreeOption> getDegreeOptions() {
        return degreeOptions;
    }

    public void setDegreeOptions(List<DegreeOption> degreeOptions) {
        this.degreeOptions = degreeOptions == null ? new ArrayList<DegreeOption>() : degreeOptions;
    }

    public int getSelectedBudget() {
        return selectedBudget;
    }

    public void setSelectedBudget(int selectedBudget) {
        this.selectedBudget = selectedBudget;
    }

    public boolean hasLinkedChild() {
        return child != null;
    }

    public boolean hasCompletedAssessment() {
        return latestAttempt != null && latestAttempt.isCompleted();
    }

    public static class CareerRecommendation {
        private String careerName;
        private String description;
        private String demandLevel;
        private String riskIndex;
        private BigDecimal averageSalary;
        private String nepalRelevanceNote;

        public String getCareerName() {
            return careerName;
        }

        public void setCareerName(String careerName) {
            this.careerName = careerName;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getDemandLevel() {
            return demandLevel;
        }

        public void setDemandLevel(String demandLevel) {
            this.demandLevel = demandLevel;
        }

        public String getRiskIndex() {
            return riskIndex;
        }

        public void setRiskIndex(String riskIndex) {
            this.riskIndex = riskIndex;
        }

        public BigDecimal getAverageSalary() {
            return averageSalary;
        }

        public void setAverageSalary(BigDecimal averageSalary) {
            this.averageSalary = averageSalary;
        }

        public String getNepalRelevanceNote() {
            return nepalRelevanceNote;
        }

        public void setNepalRelevanceNote(String nepalRelevanceNote) {
            this.nepalRelevanceNote = nepalRelevanceNote;
        }

        public String getSalaryLabel() {
            if (averageSalary == null) {
                return "Salary data pending";
            }
            return "NPR " + averageSalary.setScale(0, RoundingMode.HALF_UP).toPlainString();
        }
    }

    public static class DegreeOption {
        private String collegeName;
        private String degreeName;
        private String faculty;
        private String location;
        private BigDecimal annualFeeNpr;
        private BigDecimal minimumPercentage;
        private String duration;
        private boolean scholarshipAvailable;

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

        public BigDecimal getAnnualFeeNpr() {
            return annualFeeNpr;
        }

        public void setAnnualFeeNpr(BigDecimal annualFeeNpr) {
            this.annualFeeNpr = annualFeeNpr;
        }

        public BigDecimal getMinimumPercentage() {
            return minimumPercentage;
        }

        public void setMinimumPercentage(BigDecimal minimumPercentage) {
            this.minimumPercentage = minimumPercentage;
        }

        public String getDuration() {
            return duration;
        }

        public void setDuration(String duration) {
            this.duration = duration;
        }

        public boolean isScholarshipAvailable() {
            return scholarshipAvailable;
        }

        public void setScholarshipAvailable(boolean scholarshipAvailable) {
            this.scholarshipAvailable = scholarshipAvailable;
        }

        public String getFeeLabel() {
            if (annualFeeNpr == null) {
                return "Fee pending";
            }
            return "NPR " + annualFeeNpr.setScale(0, RoundingMode.HALF_UP).toPlainString();
        }
    }
}
