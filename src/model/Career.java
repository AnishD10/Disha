package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Career entity with JSP-friendly nested collections for detail pages and cards.
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
    private List<CareerSkill> skills = new ArrayList<>();
    private List<CareerRoadmap> roadmaps = new ArrayList<>();
    private List<CareerCourse> courses = new ArrayList<>();

    public int getCareerId() {
        return careerId;
    }

    public void setCareerId(int careerId) {
        this.careerId = careerId;
    }

    public String getCareerName() {
        return careerName;
    }

    public void setCareerName(String careerName) {
        this.careerName = careerName;
    }

    public String getOverview() {
        return overview;
    }

    public void setOverview(String overview) {
        this.overview = overview;
    }

    public String getResponsibilities() {
        return responsibilities;
    }

    public void setResponsibilities(String responsibilities) {
        this.responsibilities = responsibilities;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    public String getFutureScope() {
        return futureScope;
    }

    public void setFutureScope(String futureScope) {
        this.futureScope = futureScope;
    }

    public BigDecimal getSalaryEntry() {
        return salaryEntry;
    }

    public void setSalaryEntry(BigDecimal salaryEntry) {
        this.salaryEntry = salaryEntry;
    }

    public BigDecimal getSalaryMid() {
        return salaryMid;
    }

    public void setSalaryMid(BigDecimal salaryMid) {
        this.salaryMid = salaryMid;
    }

    public BigDecimal getSalarySenior() {
        return salarySenior;
    }

    public void setSalarySenior(BigDecimal salarySenior) {
        this.salarySenior = salarySenior;
    }

    public String getDemandLevel() {
        return demandLevel;
    }

    public void setDemandLevel(String demandLevel) {
        this.demandLevel = demandLevel;
    }

    public String getAutomationRisk() {
        return automationRisk;
    }

    public void setAutomationRisk(String automationRisk) {
        this.automationRisk = automationRisk;
    }

    public String getRemoteOpportunity() {
        return remoteOpportunity;
    }

    public void setRemoteOpportunity(String remoteOpportunity) {
        this.remoteOpportunity = remoteOpportunity;
    }

    public BigDecimal getGrowthRate() {
        return growthRate;
    }

    public void setGrowthRate(BigDecimal growthRate) {
        this.growthRate = growthRate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSuggestedCertifications() {
        return suggestedCertifications;
    }

    public void setSuggestedCertifications(String suggestedCertifications) {
        this.suggestedCertifications = suggestedCertifications;
    }

    public List<CareerSkill> getSkills() {
        return skills;
    }

    public void setSkills(List<CareerSkill> skills) {
        this.skills = skills == null ? new ArrayList<CareerSkill>() : skills;
    }

    public List<CareerRoadmap> getRoadmaps() {
        return roadmaps;
    }

    public void setRoadmaps(List<CareerRoadmap> roadmaps) {
        this.roadmaps = roadmaps == null ? new ArrayList<CareerRoadmap>() : roadmaps;
    }

    public List<CareerCourse> getCourses() {
        return courses;
    }

    public void setCourses(List<CareerCourse> courses) {
        this.courses = courses == null ? new ArrayList<CareerCourse>() : courses;
    }

    public static class CareerSkill {
        private int skillId;
        private int careerId;
        private String skillName;
        private String skillType;
        private String skillLevel;

        public int getSkillId() {
            return skillId;
        }

        public void setSkillId(int skillId) {
            this.skillId = skillId;
        }

        public int getCareerId() {
            return careerId;
        }

        public void setCareerId(int careerId) {
            this.careerId = careerId;
        }

        public String getSkillName() {
            return skillName;
        }

        public void setSkillName(String skillName) {
            this.skillName = skillName;
        }

        public String getSkillType() {
            return skillType;
        }

        public void setSkillType(String skillType) {
            this.skillType = skillType;
        }

        public String getSkillLevel() {
            return skillLevel;
        }

        public void setSkillLevel(String skillLevel) {
            this.skillLevel = skillLevel;
        }
    }

    public static class CareerRoadmap {
        private int roadmapId;
        private int careerId;
        private String stageName;
        private String description;
        private String estimatedDuration;

        public int getRoadmapId() {
            return roadmapId;
        }

        public void setRoadmapId(int roadmapId) {
            this.roadmapId = roadmapId;
        }

        public int getCareerId() {
            return careerId;
        }

        public void setCareerId(int careerId) {
            this.careerId = careerId;
        }

        public String getStageName() {
            return stageName;
        }

        public void setStageName(String stageName) {
            this.stageName = stageName;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getEstimatedDuration() {
            return estimatedDuration;
        }

        public void setEstimatedDuration(String estimatedDuration) {
            this.estimatedDuration = estimatedDuration;
        }
    }

    public static class CareerCourse {
        private int courseId;
        private int careerId;
        private String courseName;
        private String platform;
        private String difficulty;
        private String duration;
        private String freePaid;

        public int getCourseId() {
            return courseId;
        }

        public void setCourseId(int courseId) {
            this.courseId = courseId;
        }

        public int getCareerId() {
            return careerId;
        }

        public void setCareerId(int careerId) {
            this.careerId = careerId;
        }

        public String getCourseName() {
            return courseName;
        }

        public void setCourseName(String courseName) {
            this.courseName = courseName;
        }

        public String getPlatform() {
            return platform;
        }

        public void setPlatform(String platform) {
            this.platform = platform;
        }

        public String getDifficulty() {
            return difficulty;
        }

        public void setDifficulty(String difficulty) {
            this.difficulty = difficulty;
        }

        public String getDuration() {
            return duration;
        }

        public void setDuration(String duration) {
            this.duration = duration;
        }

        public String getFreePaid() {
            return freePaid;
        }

        public void setFreePaid(String freePaid) {
            this.freePaid = freePaid;
        }
    }
}
