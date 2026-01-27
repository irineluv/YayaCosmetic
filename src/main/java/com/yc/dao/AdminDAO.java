package com.yc.dao;

import com.yc.model.Admin;
import com.yc.util.DBConnection;

import java.sql.*;

public class AdminDAO {

    public Admin getAdminById(int adminId) {
        String sql = "SELECT * FROM admin WHERE adminId = ?";
        Admin admin = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                admin = mapResultSetToAdmin(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    public Admin getAdminByEmail(String email) {
        String sql = "SELECT * FROM admin WHERE email = ?";
        Admin admin = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                admin = mapResultSetToAdmin(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admin SET fullName = ?, phone = ?, updated_at = CURRENT_TIMESTAMP WHERE adminId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, admin.getFullName());
            ps.setString(2, admin.getPhone());
            ps.setInt(3, admin.getAdminId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int adminId, String newPassword) {
        String sql = "UPDATE admin SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE adminId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean validatePassword(int adminId, String password) {
        String sql = "SELECT password FROM admin WHERE adminId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return password.equals(rs.getString("password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setAdminId(rs.getInt("adminId"));
        a.setEmail(rs.getString("email"));
        a.setPassword(rs.getString("password"));
        a.setFullName(rs.getString("fullName"));
        a.setPhone(rs.getString("phone"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));
        return a;
    }
}
