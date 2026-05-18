package com.disha.model.assessment;

import java.util.List;

// AssessmentReport is NOT a database table.
// It bundles everything needed to display the result page in one object.
// The servlet builds this object and puts it in the request for the JSP to use.
public class AssessmentReport {

    private AssessmentAttempt attempt;      // scores and cluster
    private List<NepalCareer> topCareers;   // top 3 matched careers
    private List<AttemptSkill> skills;      // skill strength and weakness list

    public AssessmentReport() {
    }

    public AssessmentAttempt getAttempt() {
        return attempt;
    }

    public void setAttempt(AssessmentAttempt attempt) {
        this.attempt = attempt;
    }

    public List<NepalCareer> getTopCareers() {
        return topCareers;
    }

    public void setTopCareers(List<NepalCareer> topCareers) {
        this.topCareers = topCareers;
    }

    public List<AttemptSkill> getSkills() {
        return skills;
    }

    public void setSkills(List<AttemptSkill> skills) {
        this.skills = skills;
    }
}
