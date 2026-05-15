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

// AssessmentDAO handles all database operations related to attempts and answers.
// It creates new attempts, saves answers, and updates scores after submission.
/**
 * AssessmentDAO handles all database operations related to student assessment attempts.
 * This includes initializing new attempts, saving individual answers, and
 * finalizing scores and personality clusters after submission.
 * 
 * @author DISHA Team
 */
public class AssessmentDAO {

    // Creates a new attempt row for a student and returns the generated attempt_id.
    // This is called as soon as the student clicks Start Assessment.
    /**
     * Initializes a new assessment attempt for a student.
     * This is called when the student clicks the "Start Assessment" button.
     * 
     * @param studentId The unique ID of the student starting the test
     * @return The auto-generated attempt_id from the database, or -1 if failed
     */
    public int createAttempt(int studentId) {
        int attemptId = -1;
        String sql = "INSERT INTO assessment_attempts (student_id, is_completed) VALUES (?, 0)";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, studentId);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                attemptId = rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("Error creating attempt: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }

        return attemptId;
    }

    // Saves one answer row for a question in a specific attempt.
    // Called in a loop inside SubmitAssessmentServlet for all 30 answers.
    /**
     * Saves a single answer for a specific question within an assessment attempt.
     * 
     * @param attemptId The current assessment attempt ID
     * @param questionId The ID of the question being answered
     * @param selectedOptionId The ID of the option selected by the student
     */
    public void saveAnswer(int attemptId, int questionId, int selectedOptionId) {
        String sql = "INSERT INTO attempt_answers (attempt_id, question_id, selected_option_id) VALUES (?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ps.setInt(2, questionId);
            ps.setInt(3, selectedOptionId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error saving answer: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // Updates the scores and personality cluster for an attempt after all answers are scored.
    // Also marks the attempt as completed so it shows up in history.
    /**
     * Updates an assessment attempt with the final calculated scores and cluster.
     * Marks the attempt as completed (is_completed = 1).
     * 
     * @param attemptId The ID of the attempt to update
     * @param aptitudeScore Total score for Section A (MCQ)
     * @param personalityScore Total Likert score for Section B
     * @param interestScore Total Likert score for Section C
     * @param personalityCluster The determined personality cluster (e.g., "Social")
     */
    public void updateAttemptScores(int attemptId, int aptitudeScore, int personalityScore,
                                    int interestScore, String personalityCluster) {
        String sql = "UPDATE assessment_attempts " +
                "SET aptitude_score = ?, personality_score = ?, interest_score = ?, " +
                "personality_cluster = ?, is_completed = 1 " +
                "WHERE attempt_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, aptitudeScore);
            ps.setInt(2, personalityScore);
            ps.setInt(3, interestScore);
            ps.setString(4, personalityCluster);
            ps.setInt(5, attemptId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error updating attempt scores: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // Loads one attempt by its ID so the result page can display the scores.
    /**
     * Retrieves a single assessment attempt by its unique ID.
     * 
     * @param attemptId The unique ID of the attempt
     * @return AssessmentAttempt object if found, null otherwise
     */
    public AssessmentAttempt getAttemptById(int attemptId) {
        AssessmentAttempt attempt = null;
        String sql = "SELECT * FROM assessment_attempts WHERE attempt_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();

            if (rs.next()) {
                attempt = mapRow(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error loading attempt: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }

        return attempt;
    }

    // Loads all completed attempts for one student, newest first.
    // Used on the student history page to show all past results.
    /**
     * Retrieves all completed assessment attempts for a specific student.
     * Ordered by the most recent attempt first.
     * 
     * @param studentId The unique ID of the student
     * @return A list of completed AssessmentAttempt objects
     */
    public List<AssessmentAttempt> getAttemptsByStudent(int studentId) {
        List<AssessmentAttempt> list = new ArrayList<AssessmentAttempt>();
        String sql = "SELECT * FROM assessment_attempts " +
                "WHERE student_id = ? AND is_completed = 1 " +
                "ORDER BY attempt_date DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error loading student attempts: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }

        return list;
    }

    // Loads all answers saved for a specific attempt.
    // Used by ScoringService to calculate the scores.
    /**
     * Retrieves all answers saved for a specific assessment attempt.
     * Used by the ScoringService to calculate final results.
     * 
     * @param attemptId The ID of the attempt
     * @return A list of AttemptAnswer objects
     */
    public List<AttemptAnswer> getAnswersByAttempt(int attemptId) {
        List<AttemptAnswer> answers = new ArrayList<AttemptAnswer>();
        String sql = "SELECT * FROM attempt_answers WHERE attempt_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
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
            System.out.println("Error loading attempt answers: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }

        return answers;
    }

    // Converts a ResultSet row into an AssessmentAttempt object.
    // Kept here to avoid repeating the same mapping code in multiple methods.
    private AssessmentAttempt mapRow(ResultSet rs) throws SQLException {
        AssessmentAttempt a = new AssessmentAttempt();
        a.setAttemptId(rs.getInt("attempt_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setAttemptDate(rs.getTimestamp("attempt_date"));
        a.setCompleted(rs.getInt("is_completed") == 1);
        a.setAptitudeScore(rs.getInt("aptitude_score"));
        a.setPersonalityScore(rs.getInt("personality_score"));
        a.setInterestScore(rs.getInt("interest_score"));
        a.setPersonalityCluster(rs.getString("personality_cluster"));
        return a;
    }

    // Closes all database resources safely to avoid memory leaks.
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
