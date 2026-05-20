package dao;

import com.disha.model.LabourMarketData;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Nepal labour market records.
 */
public class LabourMarketDAO extends BaseDAO {

    public List<LabourMarketData> getAllRecords() {
        List<LabourMarketData> records = new ArrayList<>();
        String sql = "SELECT lmd.*, c.career_name FROM labour_market_data lmd " +
                "JOIN careers c ON lmd.career_id = c.career_id " +
                "ORDER BY lmd.data_year DESC, c.career_name";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql); rs = ps.executeQuery();
            while (rs.next()) records.add(mapRecord(rs));
        } catch (SQLException e) { logError("Error fetching labour market records", e); }
        finally { closeAllResources(rs, ps, conn); }
        return records;
    }

    public LabourMarketData getRecordById(int id) {
        String sql = "SELECT lmd.*, c.career_name FROM labour_market_data lmd " +
                "JOIN careers c ON lmd.career_id = c.career_id WHERE lmd.market_data_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql); ps.setInt(1, id); rs = ps.executeQuery();
            if (rs.next()) return mapRecord(rs);
        } catch (SQLException e) { logError("Error fetching labour market record", e); }
        finally { closeAllResources(rs, ps, conn); }
        return null;
    }

    public boolean createRecord(LabourMarketData record) {
        String sql = "INSERT INTO labour_market_data (career_id, data_year, job_openings, average_salary, salary_currency, market_demand, risk_index, growth_rate, updated_by) VALUES (?,?,?,?,?,?,?,?,?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql); setRecordParams(ps, record);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error creating labour market record", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public boolean updateRecord(LabourMarketData record) {
        String sql = "UPDATE labour_market_data SET career_id=?, data_year=?, job_openings=?, average_salary=?, salary_currency=?, market_demand=?, risk_index=?, growth_rate=?, updated_by=? WHERE market_data_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql); setRecordParams(ps, record);
            ps.setInt(10, record.getMarketDataId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error updating labour market record", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public boolean deleteRecord(int id) {
        String sql = "DELETE FROM labour_market_data WHERE market_data_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql); ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error deleting labour market record", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    private void setRecordParams(PreparedStatement ps, LabourMarketData record) throws SQLException {
        ps.setInt(1, record.getCareerId());
        ps.setInt(2, record.getDataYear());
        ps.setInt(3, record.getJobOpenings());
        ps.setBigDecimal(4, record.getAverageSalary());
        ps.setString(5, record.getSalaryCurrency());
        ps.setString(6, record.getMarketDemand());
        ps.setInt(7, record.getRiskIndex());
        ps.setBigDecimal(8, record.getGrowthRate());
        ps.setInt(9, record.getUpdatedBy());
    }

    private LabourMarketData mapRecord(ResultSet rs) throws SQLException {
        LabourMarketData record = new LabourMarketData();
        record.setMarketDataId(rs.getInt("market_data_id"));
        record.setCareerId(rs.getInt("career_id"));
        record.setCareerName(rs.getString("career_name"));
        record.setDataYear(rs.getInt("data_year"));
        record.setJobOpenings(rs.getInt("job_openings"));
        record.setAverageSalary(rs.getBigDecimal("average_salary"));
        record.setSalaryCurrency(rs.getString("salary_currency"));
        record.setMarketDemand(rs.getString("market_demand"));
        record.setRiskIndex(rs.getInt("risk_index"));
        record.setGrowthRate(rs.getBigDecimal("growth_rate"));
        record.setUpdatedBy(rs.getInt("updated_by"));
        record.setCreatedAt(rs.getTimestamp("created_at"));
        record.setUpdatedAt(rs.getTimestamp("updated_at"));
        return record;
    }
}
