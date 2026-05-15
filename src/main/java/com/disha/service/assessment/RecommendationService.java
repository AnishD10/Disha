package com.disha.service.assessment;

import com.disha.dao.assessment.CareerDAO;
import com.disha.model.assessment.NepalCareer;

import java.util.ArrayList;
import java.util.List;

/**
 * RecommendationService manages the algorithm for selecting the most suitable
 * Nepal-based careers for a student based on their assessment results.
 * 
 * @author DISHA Team
 */
public class RecommendationService {

    private CareerDAO careerDAO = new CareerDAO();

    /**
     * Logic to find the top 3 careers for a student.
     * It first looks for careers matching the personality cluster.
     * If fewer than 3 are found, it falls back to careers matching only aptitude.
     * As a final safety, it provides top-rated careers if scores are very low.
     * 
     * @param personalityCluster The student's personality cluster
     * @param aptitudeScore The student's aptitude score (0-10)
     * @return A list of exactly 3 NepalCareer recommendations (or fewer if total DB careers < 3)
     */
    public List<NepalCareer> getTopThreeCareers(String personalityCluster, int aptitudeScore) {
        List<NepalCareer> result = new ArrayList<NepalCareer>();

        System.out.println("DEBUG: Finding careers for Cluster: [" + personalityCluster + "] with Aptitude: [" + aptitudeScore + "]");
        List<NepalCareer> clusterMatches = careerDAO.getMatchingCareers(personalityCluster, aptitudeScore);
        for (int i = 0; i < clusterMatches.size() && result.size() < 3; i++) {
            result.add(clusterMatches.get(i));
        }

        if (result.size() < 3) {
            System.out.println("DEBUG: Not enough cluster matches. Falling back to general recommendations.");
            List<NepalCareer> fallback = careerDAO.getMatchingCareers("", aptitudeScore);
            for (int i = 0; i < fallback.size() && result.size() < 3; i++) {
                NepalCareer candidate = fallback.get(i);
                if (!alreadyInList(result, candidate.getCareerId())) {
                    result.add(candidate);
                }
            }
        }

        // Final safety check: if still empty (maybe score was too low), just give top 3 careers regardless of score
        if (result.size() < 3) {
             System.out.println("DEBUG: Extremely low score. Giving top careers as general guidance.");
             List<NepalCareer> fallback = careerDAO.getMatchingCareers("", 10); // Use max score to get everything
             for (int i = 0; i < fallback.size() && result.size() < 3; i++) {
                NepalCareer candidate = fallback.get(i);
                if (!alreadyInList(result, candidate.getCareerId())) {
                    result.add(candidate);
                }
            }
        }

        return result;
    }

    // Checks if a career with the given ID is already in the list.
    private boolean alreadyInList(List<NepalCareer> list, int careerId) {
        for (NepalCareer c : list) {
            if (c.getCareerId() == careerId) return true;
        }
        return false;
    }
}
