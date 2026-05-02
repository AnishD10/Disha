package dao;

import utils.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public abstract class BaseDAO {

    protected Connection getConnection() throws SQLException {
        return DBUtil.getConnection();
    }

    protected void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet!");
                e.printStackTrace();
            }
        }
    }

    protected void closePreparedStatement(PreparedStatement ps) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                System.err.println("Error closing PreparedStatement!");
                e.printStackTrace();
            }
        }
    }

    protected void closeConnection(Connection conn) {
        if (conn != null) {
            DBUtil.closeConnection(conn);
        }
    }

    protected void closeAllResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        closeResultSet(rs);
        closePreparedStatement(ps);
        closeConnection(conn);
    }

    protected void closeResources(PreparedStatement ps, Connection conn) {
        closePreparedStatement(ps);
        closeConnection(conn);
    }

    protected int executeUpdate(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            setParameters(ps, params);
            return ps.executeUpdate();
        } finally {
            closeResources(ps, conn);
        }
    }

    protected ResultSet executeQuery(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            setParameters(ps, params);
            return ps.executeQuery();
        } catch (SQLException e) {
            closeResources(ps, conn);
            throw e;
        }
    }

    protected void setParameters(PreparedStatement ps, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            ps.setObject(i + 1, params[i]);
        }
    }

    protected void logError(String message, Exception e) {
        System.err.println(message);
        if (e != null) {
            e.printStackTrace();
        }
    }
}
