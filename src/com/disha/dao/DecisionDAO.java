package com.disha.dao;

import com.disha.model.DecisionPlan;
import com.disha.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DecisionDAO — Dynamic constraint-based SQL filter for college programmes.
 * All optional filters are applied only when a value is actually provided.
 */
public class DecisionDAO extends DBUtil {

    private static final String BASE_SELECT =
            "SELECT plan_id, college_name, degree_name, faculty, location, " +
                    "annual_fee_npr, minimum_percentage, career_path, affiliation, " +
                    "duration_years, scholarship_available, contact_info " +
                    "FROM college_programmes WHERE is_active = 1 ";

    private static final String ORDER_BY =
            "ORDER BY annual_fee_npr ASC, minimum_percentage DESC";

    private static final String SAVE_SEARCH =
            "INSERT INTO student_decision_searches " +
                    "(user_id, max_budget, location_filter, min_percentage, career_path_filter, result_count, searched_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, NOW())";

    private static final String ALL_FACULTIES =
            "SELECT DISTINCT faculty FROM college_programmes WHERE is_active = 1 ORDER BY faculty";

    private static final String ALL_LOCATIONS =
            "SELECT DISTINCT location FROM college_programmes WHERE is_active = 1 ORDER BY location";

    private static final String ALL_CAREER_PATHS =
            "SELECT DISTINCT career_path FROM college_programmes WHERE is_active = 1 ORDER BY career_path";

    // ── Core Filter ───────────────────────────────────────────────────────────

    /**
     * Return college programmes matching ALL provided constraints.
     * Pass 0 or null for any filter to skip it.
     */
    public List<DecisionPlan> filterProgrammes(
            double maxBudgetNPR,
            String location,
            double studentPercentage,
            String careerPathKeyword,
            String faculty,
            boolean scholarshipOnly) throws SQLException {

        List<Object> params = new ArrayList<>();
        StringBuilder sql   = new StringBuilder(BASE_SELECT);

        if (maxBudgetNPR > 0) {
            sql.append("AND annual_fee_npr <= ? ");
            params.add(maxBudgetNPR);
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND location = ? ");
            params.add(location.trim());
        }
        if (studentPercentage > 0) {
            sql.append("AND minimum_percentage <= ? ");
            params.add(studentPercentage);
        }
        if (careerPathKeyword != null && !careerPathKeyword.trim().isEmpty()) {
            sql.append("AND career_path LIKE ? ");
            params.add("%" + careerPathKeyword.trim() + "%");
        }
        if (faculty != null && !faculty.trim().isEmpty()) {
            sql.append("AND faculty = ? ");
            params.add(faculty.trim());
        }
        if (scholarshipOnly) {
            sql.append("AND scholarship_available = 1 ");
        }
        sql.append(ORDER_BY);

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<DecisionPlan> results = new ArrayList<>();

        try {
            conn = getConnection();
            ps   = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Double)  ps.setDouble(i + 1, (Double) p);
                else if (p instanceof String) ps.setString(i + 1, (String) p);
            }
            rs = ps.executeQuery();
            while (rs.next()) results.add(mapRow(rs));
            return results;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ── Search History ────────────────────────────────────────────────────────

    /** Log search to audit table — non-critical, failure is caught by caller. */
    public void saveSearchHistory(int userId, double maxBudget, String location,
                                  double minPercentage, String careerPath,
                                  int resultCount) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(SAVE_SEARCH);
            ps.setInt(1, userId);
            ps.setDouble(2, maxBudget);
            ps.setString(3, location  != null ? location  : "");
            ps.setDouble(4, minPercentage);
            ps.setString(5, careerPath != null ? careerPath : "");
            ps.setInt(6, resultCount);
            ps.executeUpdate();
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ── Dropdown Data ─────────────────────────────────────────────────────────

    public List<String> getAllFaculties()   throws SQLException { return fetchStrings(ALL_FACULTIES); }
    public List<String> getAllLocations()   throws SQLException { return fetchStrings(ALL_LOCATIONS); }
    public List<String> getAllCareerPaths() throws SQLException { return fetchStrings(ALL_CAREER_PATHS); }

    // ── Private helpers ───────────────────────────────────────────────────────

    private List<String> fetchStrings(String sql) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<String> list = new ArrayList<>();
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(sql);
            rs   = ps.executeQuery();
            while (rs.next()) list.add(rs.getString(1));
            return list;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private DecisionPlan mapRow(ResultSet rs) throws SQLException {
        DecisionPlan dp = new DecisionPlan();
        dp.setPlanId(rs.getInt("plan_id"));
        dp.setCollegeName(rs.getString("college_name"));
        dp.setDegreeName(rs.getString("degree_name"));
        dp.setFaculty(rs.getString("faculty"));
        dp.setLocation(rs.getString("location"));
        dp.setAnnualFeeNPR(rs.getDouble("annual_fee_npr"));
        dp.setMinimumPercentage(rs.getDouble("minimum_percentage"));
        dp.setCareerPath(rs.getString("career_path"));
        dp.setAffiliation(rs.getString("affiliation"));
        dp.setDurationYears(rs.getInt("duration_years"));
        dp.setScholarshipAvailable(rs.getBoolean("scholarship_available"));
        dp.setContactInfo(rs.getString("contact_info"));
        return dp;
    }
}
