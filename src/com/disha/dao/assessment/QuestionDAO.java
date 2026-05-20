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

public class QuestionDAO extends DBUtil {

    public List<Question> getAllQuestions() {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM aptitude_questions ORDER BY question_order";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
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
            System.err.println("Error loading aptitude questions: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return questions;
    }

    public int getScoreValueByOptionId(int optionId) {
        return getOptionInt(optionId, "score_value");
    }

    public boolean isCorrectOption(int optionId) {
        return getOptionInt(optionId, "is_correct") == 1;
    }

    private List<Option> getOptionsForQuestion(Connection conn, int questionId) throws SQLException {
        List<Option> options = new ArrayList<>();
        String sql = "SELECT * FROM aptitude_options WHERE question_id = ? ORDER BY option_id";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, questionId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Option o = new Option();
                o.setOptionId(rs.getInt("option_id"));
                o.setQuestionId(rs.getInt("question_id"));
                o.setOptionText(rs.getString("option_text"));
                o.setScoreValue(rs.getInt("score_value"));
                o.setCorrect(rs.getBoolean("is_correct"));
                options.add(o);
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
        }
        return options;
    }

    private int getOptionInt(int optionId, String column) {
        String sql = "SELECT " + column + " FROM aptitude_options WHERE option_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, optionId);
            rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            System.err.println("Error reading aptitude option: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, ps, rs);
        }
    }
}
