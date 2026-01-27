package com.yc.dao;

import com.yc.model.User;
import com.yc.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.*, " +
                     "(SELECT COUNT(*) FROM orders WHERE userId = u.userId) as orderCount " +
                     "FROM users u WHERE u.role = 'customer' ORDER BY u.userId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = mapResultSetToUser(rs);
                u.setOrderCount(rs.getInt("orderCount"));
                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(int userId) {
        String sql = "SELECT u.*, " +
                     "(SELECT COUNT(*) FROM orders WHERE userId = u.userId) as orderCount " +
                     "FROM users u WHERE u.userId = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
                user.setOrderCount(rs.getInt("orderCount"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, updated_at = CURRENT_TIMESTAMP WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setInt(3, user.getUserId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'customer'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<User> searchUsers(String keyword) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.*, " +
                     "(SELECT COUNT(*) FROM orders WHERE userId = u.userId) as orderCount " +
                     "FROM users u " +
                     "WHERE u.role = 'customer' AND (u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ?) " +
                     "ORDER BY u.userId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchTerm = "%" + keyword + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = mapResultSetToUser(rs);
                u.setOrderCount(rs.getInt("orderCount"));
                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("userId"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
