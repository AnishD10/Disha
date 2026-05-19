package com.disha.model.assessment;

/**
 * Represents a specific skill evaluation result (e.g., Logical Thinking) 
 * derived from the student's assessment scores.
 * 
 * @author Ashmit
 */
public class AttemptSkill {

    private int skillId;
    private int attemptId;
    /** Name of the skill (e.g., "Logical Thinking", "Communication", "Work Ethic") */
    private String skillName;
    /** The raw calculated score for this skill */
    private int skillScore;
    /** Qualitative level: STRONG, AVERAGE, or WEAK */
    private String skillLevel;  

    public AttemptSkill() {
    }

    public int getSkillId() {
        return skillId;
    }

    public void setSkillId(int skillId) {
        this.skillId = skillId;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }

    public int getSkillScore() {
        return skillScore;
    }

    public void setSkillScore(int skillScore) {
        this.skillScore = skillScore;
    }

    public String getSkillLevel() {
        return skillLevel;
    }

    public void setSkillLevel(String skillLevel) {
        this.skillLevel = skillLevel;
    }
}
