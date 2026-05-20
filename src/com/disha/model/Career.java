package com.disha.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Career model representing a career path in Nepal.
 * Maps to the 'careers' table.
 */
public class Career {
    private int careerId;
    private String careerName;
    private String overview;
    private String responsibilities;
    private String industry;
    private String futureScope;
    private BigDecimal salaryEntry;
    private BigDecimal salaryMid;
    private BigDecimal salarySenior;
    private String demandLevel;
    private String automationRisk;
    private String remoteOpportunity;
    private BigDecimal growthRate;
    private String description;
    private String suggestedCertifications;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Career() {}

    // Getters & Setters
    public int getCareerId() { return careerId; }
    public void setCareerId(int careerId) { this.careerId = careerId; }

    public String getCareerName() { return careerName; }
    public void setCareerName(String careerName) { this.careerName = careerName; }

    public String getOverview() { return overview; }
    public void setOverview(String overview) { this.overview = overview; }

    public String getResponsibilities() { return responsibilities; }
    public void setResponsibilities(String responsibilities) { this.responsibilities = responsibilities; }

    public String getIndustry() { return industry; }
    public void setIndustry(String industry) { this.industry = industry; }

    public String getFutureScope() { return futureScope; }
    public void setFutureScope(String futureScope) { this.futureScope = futureScope; }

    public BigDecimal getSalaryEntry() { return salaryEntry; }
    public void setSalaryEntry(BigDecimal salaryEntry) { this.salaryEntry = salaryEntry; }

    public BigDecimal getSalaryMid() { return salaryMid; }
    public void setSalaryMid(BigDecimal salaryMid) { this.salaryMid = salaryMid; }

    public BigDecimal getSalarySenior() { return salarySenior; }
    public void setSalarySenior(BigDecimal salarySenior) { this.salarySenior = salarySenior; }

    public String getDemandLevel() { return demandLevel; }
    public void setDemandLevel(String demandLevel) { this.demandLevel = demandLevel; }

    public String getAutomationRisk() { return automationRisk; }
    public void setAutomationRisk(String automationRisk) { this.automationRisk = automationRisk; }

    public String getRemoteOpportunity() { return remoteOpportunity; }
    public void setRemoteOpportunity(String remoteOpportunity) { this.remoteOpportunity = remoteOpportunity; }

    public BigDecimal getGrowthRate() { return growthRate; }
    public void setGrowthRate(BigDecimal growthRate) { this.growthRate = growthRate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSuggestedCertifications() { return suggestedCertifications; }
    public void setSuggestedCertifications(String suggestedCertifications) { this.suggestedCertifications = suggestedCertifications; }

    public String getCareerDescription() { return description != null ? description : overview; }
    public void setCareerDescription(String careerDescription) {
        this.description = careerDescription;
        if (this.overview == null || this.overview.trim().isEmpty()) this.overview = careerDescription;
    }

    public String getRequiredAptitudeCluster() { return industry; }
    public void setRequiredAptitudeCluster(String requiredAptitudeCluster) { this.industry = requiredAptitudeCluster; }

    public BigDecimal getAverageSalary() { return salaryMid; }
    public void setAverageSalary(BigDecimal averageSalary) { this.salaryMid = averageSalary; }

    public String getSalaryCurrency() { return "NPR"; }
    public void setSalaryCurrency(String salaryCurrency) {}

    public String getMarketDemand() { return demandLevel; }
    public void setMarketDemand(String marketDemand) { this.demandLevel = marketDemand; }

    public int getRiskIndex() {
        if ("LOW".equalsIgnoreCase(automationRisk)) return 3;
        if ("HIGH".equalsIgnoreCase(automationRisk)) return 8;
        return 5;
    }
    public void setRiskIndex(int riskIndex) {
        if (riskIndex <= 3) this.automationRisk = "LOW";
        else if (riskIndex >= 7) this.automationRisk = "HIGH";
        else this.automationRisk = "MEDIUM";
    }

    public BigDecimal getJobMarketGrowthRate() { return growthRate; }
    public void setJobMarketGrowthRate(BigDecimal jobMarketGrowthRate) { this.growthRate = jobMarketGrowthRate; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
