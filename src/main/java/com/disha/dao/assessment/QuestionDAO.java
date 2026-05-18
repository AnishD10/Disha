package com.disha.dao.assessment;

import com.disha.model.assessment.Option;
import com.disha.model.assessment.Question;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * QuestionDAO handles all database operations related to assessment questions 
 * and their respective options. This includes loading question banks for 
 * various sections (MCQ, Likert) and validating answers.
 * 
 * @author DISHA Team
 */
public class QuestionDAO {

    /**
     * Retrieves all 30 assessment questions from the database, including their options.
     * 
     * @return A list of all Question objects ordered by their sequence
     */
    public List<Question> getAllQuestions() {
        List<Question> questions = new ArrayList<Question>();
        String sql = "SELECT * FROM questions ORDER BY question_order";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql); rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setSection(rs.getString("section"));
                q.setQuestionType(rs.getString("question_type"));
                q.setQuestionOrder(rs.getInt("question_order"));
                q.setOptions(getOptionsForQuestion(conn, q.getQuestionId()));
                questions.add(q);
            }
        } catch (SQLException e) {
            System.out.println("Error loading questions: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return questions;
    }

    /**
     * Retrieves all questions belonging to a specific assessment section.
     * 
     * @param section The section name (e.g., "APTITUDE", "PERSONALITY")
     * @return A list of Question objects for the requested section
     */
    public List<Question> getQuestionsBySection(String section) {
        List<Question> questions = new ArrayList<Question>();
        String sql = "SELECT * FROM questions WHERE section = ? ORDER BY question_order";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setString(1, section); rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setSection(rs.getString("section"));
                q.setQuestionType(rs.getString("question_type"));
                q.setQuestionOrder(rs.getInt("question_order"));
                q.setOptions(getOptionsForQuestion(conn, q.getQuestionId()));
                questions.add(q);
            }
        } catch (SQLException e) {
            System.out.println("Error loading questions by section: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return questions;
    }

    // Loads all options for a given question_id using an existing connection.
    private List<Option> getOptionsForQuestion(Connection conn, int questionId) throws SQLException {
        List<Option> options = new ArrayList<Option>();
        String sql = "SELECT * FROM options WHERE question_id = ?";
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql); ps.setInt(1, questionId); rs = ps.executeQuery();
            while (rs.next()) {
                Option o = new Option();
                o.setOptionId(rs.getInt("option_id"));
                o.setQuestionId(rs.getInt("question_id"));
                o.setOptionText(rs.getString("option_text"));
                o.setScoreValue(rs.getInt("score_value"));
                o.setCorrect(rs.getInt("is_correct") == 1);
                options.add(o);
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
        return options;
    }

    /**
     * Retrieves the weight (score_value) of a specific option.
     * Used for calculating personality and interest scores.
     * 
     * @param optionId The unique ID of the option
     * @return The integer score value (usually 1-5)
     */
    public int getScoreValueByOptionId(int optionId) {
        int score = 0;
        String sql = "SELECT score_value FROM options WHERE option_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, optionId); rs = ps.executeQuery();
            if (rs.next()) { score = rs.getInt("score_value"); }
        } catch (SQLException e) {
            System.out.println("Error getting score value: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return score;
    }

    /**
     * Validates whether a specific option is the correct answer for an MCQ question.
     * 
     * @param optionId The unique ID of the option
     * @return true if the option is marked as correct, false otherwise
     */
    public boolean isCorrectOption(int optionId) {
        boolean correct = false;
        String sql = "SELECT is_correct FROM options WHERE option_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, optionId); rs = ps.executeQuery();
            if (rs.next()) { correct = rs.getInt("is_correct") == 1; }
        } catch (SQLException e) {
            System.out.println("Error checking correct option: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return correct;
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
