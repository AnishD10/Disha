package com.disha.model;

import java.util.List;

public class ParentDashboardData {

    private String childName;
    private String aptitudeSummary;
    private String strengthClusters;
    private String weaknessClusters;
    private List<CareerMatch> matchedCareers;
    private List<DegreeOption> degreeOptions;

    public static class CareerMatch {
        private String careerName;
        private String salaryRange;
        private String demandLevel;
        private String riskIndex;
        private String plainDescription;

        public CareerMatch(String careerName, String salaryRange,
                           String demandLevel, String riskIndex,
                           String plainDescription) {
            this.careerName       = careerName;
            this.salaryRange      = salaryRange;
            this.demandLevel      = demandLevel;
            this.riskIndex        = riskIndex;
            this.plainDescription = plainDescription;
        }

        public String getCareerName()       { return careerName; }
        public String getSalaryRange()      { return salaryRange; }
        public String getDemandLevel()      { return demandLevel; }
        public String getRiskIndex()        { return riskIndex; }
        public String getPlainDescription() { return plainDescription; }
    }

    public static class DegreeOption {
        private String degreeName;
        private String collegeName;
        private String location;
        private String annualFeeNPR;
        private String duration;

        public DegreeOption(String degreeName, String collegeName,
                             String location, String annualFeeNPR,
                             String duration) {
            this.degreeName   = degreeName;
            this.collegeName  = collegeName;
            this.location     = location;
            this.annualFeeNPR = annualFeeNPR;
            this.duration     = duration;
        }

        public String getDegreeName()   { return degreeName; }
        public String getCollegeName()  { return collegeName; }
        public String getLocation()     { return location; }
        public String getAnnualFeeNPR() { return annualFeeNPR; }
        public String getDuration()     { return duration; }
    }

    public String getChildName()                                   { return childName; }
    public void   setChildName(String childName)                   { this.childName = childName; }

    public String getAptitudeSummary()                             { return aptitudeSummary; }
    public void   setAptitudeSummary(String aptitudeSummary)       { this.aptitudeSummary = aptitudeSummary; }

    public String getStrengthClusters()                            { return strengthClusters; }
    public void   setStrengthClusters(String strengthClusters)     { this.strengthClusters = strengthClusters; }

    public String getWeaknessClusters()                            { return weaknessClusters; }
    public void   setWeaknessClusters(String weaknessClusters)     { this.weaknessClusters = weaknessClusters; }

    public List<CareerMatch> getMatchedCareers()                   { return matchedCareers; }
    public void setMatchedCareers(List<CareerMatch> matchedCareers){ this.matchedCareers = matchedCareers; }

    public List<DegreeOption> getDegreeOptions()                   { return degreeOptions; }
    public void setDegreeOptions(List<DegreeOption> degreeOptions) { this.degreeOptions = degreeOptions; }
}
