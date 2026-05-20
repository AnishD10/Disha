package dao;

import com.disha.model.Career;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Career CRUD operations.
 */
public class CareerDAO extends BaseDAO {

    public List<Career> getAllCareers() {
        List<Career> list = new ArrayList<>();
        String sql = "SELECT * FROM careers ORDER BY career_name";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapCareer(rs));
        } catch (SQLException e) { logError("Error fetching careers", e); }
        finally { closeAllResources(rs, ps, conn); }
        return list;
    }

    public Career getCareerById(int id) {
        String sql = "SELECT * FROM careers WHERE career_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) return mapCareer(rs);
        } catch (SQLException e) { logError("Error fetching career by ID", e); }
        finally { closeAllResources(rs, ps, conn); }
        return null;
    }

    public boolean createCareer(Career c) {
        String sql = "INSERT INTO careers (career_name, overview, responsibilities, industry, future_scope, salary_entry, salary_mid, salary_senior, demand_level, automation_risk, remote_opportunity, growth_rate, description, suggested_certifications) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            setCareerParams(ps, c);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error creating career", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public boolean updateCareer(Career c) {
        String sql = "UPDATE careers SET career_name=?, overview=?, responsibilities=?, industry=?, future_scope=?, salary_entry=?, salary_mid=?, salary_senior=?, demand_level=?, automation_risk=?, remote_opportunity=?, growth_rate=?, description=?, suggested_certifications=? WHERE career_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            setCareerParams(ps, c);
            ps.setInt(15, c.getCareerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error updating career", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public boolean deleteCareer(int id) {
        String sql = "DELETE FROM careers WHERE career_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error deleting career", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM careers";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { logError("Error counting careers", e); }
        finally { closeAllResources(rs, ps, conn); }
        return 0;
    }

    public List<Career> searchCareers(String keyword) {
        List<Career> list = new ArrayList<>();
        String sql = "SELECT * FROM careers WHERE career_name LIKE ? OR overview LIKE ? OR industry LIKE ? OR description LIKE ? ORDER BY career_name";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            String like = "%" + keyword + "%";
            ps.setString(1, like); ps.setString(2, like); ps.setString(3, like); ps.setString(4, like);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapCareer(rs));
        } catch (SQLException e) { logError("Error searching careers", e); }
        finally { closeAllResources(rs, ps, conn); }
        return list;
    }

    private void setCareerParams(PreparedStatement ps, Career c) throws SQLException {
        ps.setString(1, valueOrDefault(c.getCareerName(), "Untitled Career"));
        ps.setString(2, valueOrDefault(c.getOverview(), c.getCareerDescription()));
        ps.setString(3, valueOrDefault(c.getResponsibilities(), "Responsibilities to be updated."));
        ps.setString(4, valueOrDefault(c.getIndustry(), "General"));
        ps.setString(5, valueOrDefault(c.getFutureScope(), "Future scope to be updated."));
        ps.setBigDecimal(6, c.getSalaryEntry() != null ? c.getSalaryEntry() : BigDecimal.ZERO);
        ps.setBigDecimal(7, c.getSalaryMid() != null ? c.getSalaryMid() : BigDecimal.ZERO);
        ps.setBigDecimal(8, c.getSalarySenior() != null ? c.getSalarySenior() : BigDecimal.ZERO);
        ps.setString(9, valueOrDefault(c.getDemandLevel(), "MEDIUM"));
        ps.setString(10, valueOrDefault(c.getAutomationRisk(), "MEDIUM"));
        ps.setString(11, valueOrDefault(c.getRemoteOpportunity(), "MEDIUM"));
        ps.setBigDecimal(12, c.getGrowthRate() != null ? c.getGrowthRate() : BigDecimal.ZERO);
        ps.setString(13, valueOrDefault(c.getDescription(), c.getOverview()));
        ps.setString(14, c.getSuggestedCertifications());
    }

    private String valueOrDefault(String value, String fallback) {
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }

    private Career mapCareer(ResultSet rs) throws SQLException {
        Career c = new Career();
        c.setCareerId(rs.getInt("career_id"));
        c.setCareerName(rs.getString("career_name"));
        c.setOverview(rs.getString("overview"));
        c.setResponsibilities(rs.getString("responsibilities"));
        c.setIndustry(rs.getString("industry"));
        c.setFutureScope(rs.getString("future_scope"));
        c.setSalaryEntry(rs.getBigDecimal("salary_entry"));
        c.setSalaryMid(rs.getBigDecimal("salary_mid"));
        c.setSalarySenior(rs.getBigDecimal("salary_senior"));
        c.setDemandLevel(rs.getString("demand_level"));
        c.setAutomationRisk(rs.getString("automation_risk"));
        c.setRemoteOpportunity(rs.getString("remote_opportunity"));
        c.setGrowthRate(rs.getBigDecimal("growth_rate"));
        c.setDescription(rs.getString("description"));
        c.setSuggestedCertifications(rs.getString("suggested_certifications"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }
}
