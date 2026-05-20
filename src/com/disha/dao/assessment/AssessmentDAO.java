package com.disha.dao.assessment;

import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.assessment.AttemptAnswer;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AssessmentDAO extends DBUtil {

    public int createAttempt(int studentId) {
        String sql = "INSERT INTO assessment_attempts (student_id, is_completed) VALUES (?, 0)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, studentId);
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } catch (SQLException e) {
            System.err.println("Error creating assessment attempt: " + e.getMessage());
            return -1;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public void saveAnswer(int attemptId, int questionId, int selectedOptionId) {
        String sql = "INSERT INTO attempt_answers (attempt_id, question_id, selected_option_id) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ps.setInt(2, questionId);
            ps.setInt(3, selectedOptionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error saving assessment answer: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public void updateAttemptScores(int attemptId, int aptitudeScore, int personalityScore,
                                    int interestScore, String personalityCluster) {
        String sql = "UPDATE assessment_attempts SET aptitude_score=?, personality_score=?, interest_score=?, " +
                "personality_cluster=?, is_completed=1 WHERE attempt_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, aptitudeScore);
            ps.setInt(2, personalityScore);
            ps.setInt(3, interestScore);
            ps.setString(4, personalityCluster);
            ps.setInt(5, attemptId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating assessment scores: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public AssessmentAttempt getAttemptById(int attemptId) {
        String sql = "SELECT * FROM assessment_attempts WHERE attempt_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } catch (SQLException e) {
            System.err.println("Error loading assessment attempt: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public List<AssessmentAttempt> getAttemptsByStudent(int studentId) {
        List<AssessmentAttempt> attempts = new ArrayList<>();
        String sql = "SELECT * FROM assessment_attempts WHERE student_id = ? AND is_completed = 1 ORDER BY attempt_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) attempts.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Error loading assessment history: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return attempts;
    }

    public List<AttemptAnswer> getAnswersByAttempt(int attemptId) {
        List<AttemptAnswer> answers = new ArrayList<>();
        String sql = "SELECT * FROM attempt_answers WHERE attempt_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            while (rs.next()) {
                AttemptAnswer a = new AttemptAnswer();
                a.setAnswerId(rs.getInt("answer_id"));
                a.setAttemptId(rs.getInt("attempt_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setSelectedOptionId(rs.getInt("selected_option_id"));
                answers.add(a);
            }
        } catch (SQLException e) {
            System.err.println("Error loading assessment answers: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return answers;
    }

    private AssessmentAttempt mapRow(ResultSet rs) throws SQLException {
        AssessmentAttempt a = new AssessmentAttempt();
        a.setAttemptId(rs.getInt("attempt_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setAttemptDate(rs.getTimestamp("attempt_date"));
        a.setCompleted(rs.getBoolean("is_completed"));
        a.setAptitudeScore(rs.getInt("aptitude_score"));
        a.setPersonalityScore(rs.getInt("personality_score"));
        a.setInterestScore(rs.getInt("interest_score"));
        a.setPersonalityCluster(rs.getString("personality_cluster"));
        return a;
    }
}
