package model;

/**
 * Required aptitude profile for one career. Scores are stored from 0 to 100.
 */
public class CareerMatchRule {
    private int ruleId;
    private int careerId;
    private int requiredAnalytical;
    private int requiredCreativity;
    private int requiredLeadership;
    private int requiredTechnical;
    private int requiredCommunication;
    private int requiredEntrepreneurial;
    private int requiredResearch;

    public int getRuleId() {
        return ruleId;
    }

    public void setRuleId(int ruleId) {
        this.ruleId = ruleId;
    }

    public int getCareerId() {
        return careerId;
    }

    public void setCareerId(int careerId) {
        this.careerId = careerId;
    }

    public int getRequiredAnalytical() {
        return requiredAnalytical;
    }

    public void setRequiredAnalytical(int requiredAnalytical) {
        this.requiredAnalytical = requiredAnalytical;
    }

    public int getRequiredCreativity() {
        return requiredCreativity;
    }

    public void setRequiredCreativity(int requiredCreativity) {
        this.requiredCreativity = requiredCreativity;
    }

    public int getRequiredLeadership() {
        return requiredLeadership;
    }

    public void setRequiredLeadership(int requiredLeadership) {
        this.requiredLeadership = requiredLeadership;
    }

    public int getRequiredTechnical() {
        return requiredTechnical;
    }

    public void setRequiredTechnical(int requiredTechnical) {
        this.requiredTechnical = requiredTechnical;
    }

    public int getRequiredCommunication() {
        return requiredCommunication;
    }

    public void setRequiredCommunication(int requiredCommunication) {
        this.requiredCommunication = requiredCommunication;
    }

    public int getRequiredEntrepreneurial() {
        return requiredEntrepreneurial;
    }

    public void setRequiredEntrepreneurial(int requiredEntrepreneurial) {
        this.requiredEntrepreneurial = requiredEntrepreneurial;
    }

    public int getRequiredResearch() {
        return requiredResearch;
    }

    public void setRequiredResearch(int requiredResearch) {
        this.requiredResearch = requiredResearch;
    }
}
