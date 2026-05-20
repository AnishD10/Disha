package com.disha.service.assessment;

import com.disha.dao.assessment.CareerDAO;
import com.disha.model.assessment.NepalCareer;

import java.util.ArrayList;
import java.util.List;

public class RecommendationService {
    private final CareerDAO careerDAO = new CareerDAO();

    public List<NepalCareer> getTopThreeCareers(String personalityCluster, int aptitudeScore) {
        List<NepalCareer> result = new ArrayList<>();
        appendUnique(result, careerDAO.getMatchingCareers(personalityCluster, aptitudeScore));
        if (result.size() < 3) appendUnique(result, careerDAO.getMatchingCareers("", aptitudeScore));
        if (result.size() < 3) appendUnique(result, careerDAO.getMatchingCareers("", 10));
        return result.size() > 3 ? result.subList(0, 3) : result;
    }

    private void appendUnique(List<NepalCareer> target, List<NepalCareer> candidates) {
        for (NepalCareer candidate : candidates) {
            if (target.size() >= 3) return;
            boolean exists = false;
            for (NepalCareer current : target) {
                if (current.getCareerId() == candidate.getCareerId()) {
                    exists = true;
                    break;
                }
            }
            if (!exists) target.add(candidate);
        }
    }
}
