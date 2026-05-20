package dao;

import com.disha.model.College;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for College CRUD operations.
 */
public class CollegeDAO extends BaseDAO {

    public List<College> getAllColleges() {
        List<College> list = new ArrayList<>();
        String sql = "SELECT * FROM colleges ORDER BY college_name";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapCollege(rs));
        } catch (SQLException e) { logError("Error fetching colleges", e); }
        finally { closeAllResources(rs, ps, conn); }
        return list;
    }

    public College getCollegeById(int id) {
        String sql = "SELECT * FROM colleges WHERE college_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) return mapCollege(rs);
        } catch (SQLException e) { logError("Error fetching college", e); }
        finally { closeAllResources(rs, ps, conn); }
        return null;
    }

    public boolean createCollege(College c) {
        String sql = "INSERT INTO colleges (college_name, college_location, college_city, college_description, website_url, contact_email, contact_phone, is_public, is_verified) VALUES (?,?,?,?,?,?,?,?,?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setString(1, c.getCollegeName());
            ps.setString(2, c.getCollegeLocation());
            ps.setString(3, c.getCollegeCity());
            ps.setString(4, c.getCollegeDescription());
            ps.setString(5, c.getWebsiteUrl());
            ps.setString(6, c.getContactEmail());
            ps.setString(7, c.getContactPhone());
            ps.setBoolean(8, c.isPublic());
            ps.setBoolean(9, c.isVerified());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error creating college", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public boolean updateCollege(College c) {
        String sql = "UPDATE colleges SET college_name=?, college_location=?, college_city=?, college_description=?, website_url=?, contact_email=?, contact_phone=?, is_public=?, is_verified=? WHERE college_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setString(1, c.getCollegeName());
            ps.setString(2, c.getCollegeLocation());
            ps.setString(3, c.getCollegeCity());
            ps.setString(4, c.getCollegeDescription());
            ps.setString(5, c.getWebsiteUrl());
            ps.setString(6, c.getContactEmail());
            ps.setString(7, c.getContactPhone());
            ps.setBoolean(8, c.isPublic());
            ps.setBoolean(9, c.isVerified());
            ps.setInt(10, c.getCollegeId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error updating college", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public boolean deleteCollege(int id) {
        String sql = "DELETE FROM colleges WHERE college_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { logError("Error deleting college", e); }
        finally { closeResources(ps, conn); }
        return false;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM colleges";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = getConnection(); ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { logError("Error counting colleges", e); }
        finally { closeAllResources(rs, ps, conn); }
        return 0;
    }

    private College mapCollege(ResultSet rs) throws SQLException {
        College c = new College();
        c.setCollegeId(rs.getInt("college_id"));
        c.setCollegeName(rs.getString("college_name"));
        c.setCollegeLocation(rs.getString("college_location"));
        c.setCollegeCity(rs.getString("college_city"));
        c.setCollegeDescription(rs.getString("college_description"));
        c.setWebsiteUrl(rs.getString("website_url"));
        c.setContactEmail(rs.getString("contact_email"));
        c.setContactPhone(rs.getString("contact_phone"));
        c.setPublic(rs.getBoolean("is_public"));
        c.setVerified(rs.getBoolean("is_verified"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }
}
