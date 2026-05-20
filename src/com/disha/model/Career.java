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
    private String careerDescription;
    private String requiredAptitudeCluster;
    private BigDecimal averageSalary;
    private String salaryCurrency;
    private String marketDemand;  // LOW, MEDIUM, HIGH
    private int riskIndex;
    private BigDecimal jobMarketGrowthRate;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Career() { this.salaryCurrency = "NPR"; }

    // Getters & Setters
    public int getCareerId() { return careerId; }
    public void setCareerId(int careerId) { this.careerId = careerId; }

    public String getCareerName() { return careerName; }
    public void setCareerName(String careerName) { this.careerName = careerName; }

    public String getCareerDescription() { return careerDescription; }
    public void setCareerDescription(String careerDescription) { this.careerDescription = careerDescription; }

    public String getRequiredAptitudeCluster() { return requiredAptitudeCluster; }
    public void setRequiredAptitudeCluster(String requiredAptitudeCluster) { this.requiredAptitudeCluster = requiredAptitudeCluster; }

    public BigDecimal getAverageSalary() { return averageSalary; }
    public void setAverageSalary(BigDecimal averageSalary) { this.averageSalary = averageSalary; }

    public String getSalaryCurrency() { return salaryCurrency; }
    public void setSalaryCurrency(String salaryCurrency) { this.salaryCurrency = salaryCurrency; }

    public String getMarketDemand() { return marketDemand; }
    public void setMarketDemand(String marketDemand) { this.marketDemand = marketDemand; }

    public int getRiskIndex() { return riskIndex; }
    public void setRiskIndex(int riskIndex) { this.riskIndex = riskIndex; }

    public BigDecimal getJobMarketGrowthRate() { return jobMarketGrowthRate; }
    public void setJobMarketGrowthRate(BigDecimal jobMarketGrowthRate) { this.jobMarketGrowthRate = jobMarketGrowthRate; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
