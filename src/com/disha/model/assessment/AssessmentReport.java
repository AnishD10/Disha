package com.disha.model.assessment;

import java.util.List;

public class AssessmentReport {
    private AssessmentAttempt attempt;
    private List<NepalCareer> topCareers;
    private List<AttemptSkill> skills;

    public AssessmentAttempt getAttempt() { return attempt; }
    public void setAttempt(AssessmentAttempt attempt) { this.attempt = attempt; }
    public List<NepalCareer> getTopCareers() { return topCareers; }
    public void setTopCareers(List<NepalCareer> topCareers) { this.topCareers = topCareers; }
    public List<AttemptSkill> getSkills() { return skills; }
    public void setSkills(List<AttemptSkill> skills) { this.skills = skills; }
}
