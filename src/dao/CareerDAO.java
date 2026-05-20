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
        String sql = "INSERT INTO careers (career_name, career_description, required_aptitude_cluster, average_salary, market_demand, risk_index, job_market_growth_rate) VALUES (?,?,?,?,?,?,?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setString(1, c.getCareerName());
            ps.setString(2, c.getCareerDescription());
            ps.setString(3, c.getRequiredAptitudeCluster());
            ps.setBigDecimal(4, c.getAverageSalary());
            ps.setString(5, c.getMarketDemand());
            ps.setInt(6, c.getRiskIndex());
            ps.setBigDecimal(7, c.getJobMarketGrowthRate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error creating career", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public boolean updateCareer(Career c) {
        String sql = "UPDATE careers SET career_name=?, career_description=?, required_aptitude_cluster=?, average_salary=?, market_demand=?, risk_index=?, job_market_growth_rate=? WHERE career_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setString(1, c.getCareerName());
            ps.setString(2, c.getCareerDescription());
            ps.setString(3, c.getRequiredAptitudeCluster());
            ps.setBigDecimal(4, c.getAverageSalary());
            ps.setString(5, c.getMarketDemand());
            ps.setInt(6, c.getRiskIndex());
            ps.setBigDecimal(7, c.getJobMarketGrowthRate());
            ps.setInt(8, c.getCareerId());
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
        String sql = "SELECT * FROM careers WHERE career_name LIKE ? OR career_description LIKE ? ORDER BY career_name";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            String like = "%" + keyword + "%";
            ps.setString(1, like); ps.setString(2, like);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapCareer(rs));
        } catch (SQLException e) { logError("Error searching careers", e); }
        finally { closeAllResources(rs, ps, conn); }
        return list;
    }

    private Career mapCareer(ResultSet rs) throws SQLException {
        Career c = new Career();
        c.setCareerId(rs.getInt("career_id"));
        c.setCareerName(rs.getString("career_name"));
        c.setCareerDescription(rs.getString("career_description"));
        c.setRequiredAptitudeCluster(rs.getString("required_aptitude_cluster"));
        c.setAverageSalary(rs.getBigDecimal("average_salary"));
        c.setSalaryCurrency(rs.getString("salary_currency"));
        c.setMarketDemand(rs.getString("market_demand"));
        c.setRiskIndex(rs.getInt("risk_index"));
        c.setJobMarketGrowthRate(rs.getBigDecimal("job_market_growth_rate"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }
}
