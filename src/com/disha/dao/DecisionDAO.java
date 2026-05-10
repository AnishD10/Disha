package com.disha.dao;

import com.disha.model.DecisionPlan;
import com.disha.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DecisionDAO — All database operations for the Decision Planning feature.
 *
 * Core responsibility: complex constraint-based SQL filtering of the
 * college_programmes table to match a student's budget, location,
 * academic score, and career path preference.
 *
 * All raw JDBC boilerplate is handled by DBUtil (parent class).
 *
 * Author: Joyal Karki — Decision Planning Feature Owner
 */
public class DecisionDAO extends DBUtil {

    // ── SQL Constants ─────────────────────────────────────────────────────────

    /**
     * Core constraint filter query.
     * Dynamic WHERE clauses are appended by buildFilterQuery().
     * Base columns fetched from the college_programmes table.
     */
    private static final String BASE_SELECT = "SELECT cp.plan_id, cp.college_name, cp.degree_name, cp.faculty, " +
            "       cp.location, cp.annual_fee_npr, cp.minimum_percentage, " +
            "       cp.career_path, cp.affiliation, cp.duration_years, " +
            "       cp.scholarship_available, cp.contact_info " +
            "FROM college_programmes cp " +
            "WHERE cp.is_active = 1 ";

    private static final String ORDER_BY = "ORDER BY cp.annual_fee_npr ASC, cp.minimum_percentage DESC";

    private static final String SAVE_SEARCH = "INSERT INTO student_decision_searches " +
            "(user_id, max_budget, location_filter, min_percentage, career_path_filter, result_count, searched_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, NOW())";

    private static final String SELECT_FACULTIES = "SELECT DISTINCT faculty FROM college_programmes WHERE is_active = 1 ORDER BY faculty";

    private static final String SELECT_LOCATIONS = "SELECT DISTINCT location FROM college_programmes WHERE is_active = 1 ORDER BY location";

    private static final String SELECT_CAREER_PATHS = "SELECT DISTINCT career_path FROM college_programmes WHERE is_active = 1 ORDER BY career_path";

    // ── Core Filter Method ────────────────────────────────────────────────────

    /**
     * Retrieve degree/college options matching ALL provided constraints.
     *
     * All parameters are optional — pass null or 0 to skip that filter.
     *
     * @param maxBudgetNPR      maximum annual fee in Nepali Rupees (0 = no limit)
     * @param location          district/province name, or null for any location
     * @param studentPercentage the student's SEE/+2 percentage (0 = no filter)
     * @param careerPathKeyword keyword matching a career tag (null = any)
     * @param faculty           faculty preference, e.g. "Science" (null = any)
     * @param scholarshipOnly   if true, only return programmes with scholarships
     * @return list of matching DecisionPlan objects, ordered by fee ascending
     */
    public List<DecisionPlan> filterProgrammes(
            double maxBudgetNPR,
            String location,
            double studentPercentage,
            String careerPathKeyword,
            String faculty,
            boolean scholarshipOnly) throws SQLException {

        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT);

        // ── Apply constraints dynamically ─────────────────────────────────────

        if (maxBudgetNPR > 0) {
            sql.append("AND cp.annual_fee_npr <= ? ");
            params.add(maxBudgetNPR);
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND cp.location = ? ");
            params.add(location.trim());
        }

        if (studentPercentage > 0) {
            // Only show programmes the student qualifies for
            sql.append("AND cp.minimum_percentage <= ? ");
            params.add(studentPercentage);
        }

        if (careerPathKeyword != null && !careerPathKeyword.trim().isEmpty()) {
            // Career path is stored as a comma-separated list of tags
            sql.append("AND cp.career_path LIKE ? ");
            params.add("%" + careerPathKeyword.trim() + "%");
        }

        if (faculty != null && !faculty.trim().isEmpty()) {
            sql.append("AND cp.faculty = ? ");
            params.add(faculty.trim());
        }

        if (scholarshipOnly) {
            sql.append("AND cp.scholarship_available = 1 ");
        }

        sql.append(ORDER_BY);

        // ── Execute ───────────────────────────────────────────────────────────

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<DecisionPlan> results = new ArrayList<>();

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Double)
                    ps.setDouble(i + 1, (Double) p);
                else if (p instanceof String)
                    ps.setString(i + 1, (String) p);
                else if (p instanceof Boolean)
                    ps.setBoolean(i + 1, (Boolean) p);
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                results.add(mapRow(rs));
            }
            return results;

        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ── Search History ────────────────────────────────────────────────────────

    /**
     * Log a student's search to the student_decision_searches audit table.
     * Allows counselors to see what students are planning.
     *
     * @param userId      the student's user_id from session
     * @param resultCount the number of results returned for this search
     */
    public void saveSearchHistory(int userId, double maxBudget, String location,
            double minPercentage, String careerPath,
            int resultCount) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(SAVE_SEARCH);
            ps.setInt(1, userId);
            ps.setDouble(2, maxBudget);
            ps.setString(3, location);
            ps.setDouble(4, minPercentage);
            ps.setString(5, careerPath);
            ps.setInt(6, resultCount);
            ps.executeUpdate();
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ── Dropdown Data ─────────────────────────────────────────────────────────

    /**
     * Retrieve distinct faculty names for the filter dropdown.
     */
    public List<String> getAllFaculties() throws SQLException {
        return fetchDistinctStrings(SELECT_FACULTIES);
    }

    /**
     * Retrieve distinct location names for the filter dropdown.
     */
    public List<String> getAllLocations() throws SQLException {
        return fetchDistinctStrings(SELECT_LOCATIONS);
    }

    /**
     * Retrieve distinct career path values for the filter dropdown.
     */
    public List<String> getAllCareerPaths() throws SQLException {
        return fetchDistinctStrings(SELECT_CAREER_PATHS);
    }

    // ── Private Helpers ───────────────────────────────────────────────────────

    private List<String> fetchDistinctStrings(String sql) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<String> list = new ArrayList<>();
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString(1));
            }
            return list;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Map a ResultSet row to a DecisionPlan object.
     */
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
