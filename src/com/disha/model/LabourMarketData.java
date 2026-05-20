package com.disha.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Labour market record for a career in a specific year.
 */
public class LabourMarketData {
    private int marketDataId;
    private int careerId;
    private String careerName;
    private int dataYear;
    private int jobOpenings;
    private BigDecimal averageSalary;
    private String salaryCurrency;
    private String marketDemand;
    private int riskIndex;
    private BigDecimal growthRate;
    private int updatedBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public LabourMarketData() {
        this.salaryCurrency = "NPR";
    }

    public int getMarketDataId() { return marketDataId; }
    public void setMarketDataId(int marketDataId) { this.marketDataId = marketDataId; }

    public int getCareerId() { return careerId; }
    public void setCareerId(int careerId) { this.careerId = careerId; }

    public String getCareerName() { return careerName; }
    public void setCareerName(String careerName) { this.careerName = careerName; }

    public int getDataYear() { return dataYear; }
    public void setDataYear(int dataYear) { this.dataYear = dataYear; }

    public int getJobOpenings() { return jobOpenings; }
    public void setJobOpenings(int jobOpenings) { this.jobOpenings = jobOpenings; }

    public BigDecimal getAverageSalary() { return averageSalary; }
    public void setAverageSalary(BigDecimal averageSalary) { this.averageSalary = averageSalary; }

    public String getSalaryCurrency() { return salaryCurrency; }
    public void setSalaryCurrency(String salaryCurrency) { this.salaryCurrency = salaryCurrency; }

    public String getMarketDemand() { return marketDemand; }
    public void setMarketDemand(String marketDemand) { this.marketDemand = marketDemand; }

    public int getRiskIndex() { return riskIndex; }
    public void setRiskIndex(int riskIndex) { this.riskIndex = riskIndex; }

    public BigDecimal getGrowthRate() { return growthRate; }
    public void setGrowthRate(BigDecimal growthRate) { this.growthRate = growthRate; }

    public int getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(int updatedBy) { this.updatedBy = updatedBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
