package com.disha.career.model;

/**
 * Recommendation DTO returned to JSP pages.
 */
public class CareerMatch {
    private Career career;
    private double compatibilityPercentage;
    private String matchStrength;
    private String explanation;
    private String demandBadge;
    private String automationRiskBadge;
    private String remoteOpportunityBadge;
    private String growthTrendBadge;

    public Career getCareer() {
        return career;
    }

    public void setCareer(Career career) {
        this.career = career;
    }

    public double getCompatibilityPercentage() {
        return compatibilityPercentage;
    }

    public void setCompatibilityPercentage(double compatibilityPercentage) {
        this.compatibilityPercentage = compatibilityPercentage;
    }

    public String getMatchStrength() {
        return matchStrength;
    }

    public void setMatchStrength(String matchStrength) {
        this.matchStrength = matchStrength;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getDemandBadge() {
        return demandBadge;
    }

    public void setDemandBadge(String demandBadge) {
        this.demandBadge = demandBadge;
    }

    public String getAutomationRiskBadge() {
        return automationRiskBadge;
    }

    public void setAutomationRiskBadge(String automationRiskBadge) {
        this.automationRiskBadge = automationRiskBadge;
    }

    public String getRemoteOpportunityBadge() {
        return remoteOpportunityBadge;
    }

    public void setRemoteOpportunityBadge(String remoteOpportunityBadge) {
        this.remoteOpportunityBadge = remoteOpportunityBadge;
    }

    public String getGrowthTrendBadge() {
        return growthTrendBadge;
    }

    public void setGrowthTrendBadge(String growthTrendBadge) {
        this.growthTrendBadge = growthTrendBadge;
    }
}
