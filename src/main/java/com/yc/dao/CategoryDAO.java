package com.yc.dao;

import com.yc.model.Category;
import com.yc.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY categoryId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = mapResultSetToCategory(rs);
                categories.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE categoryId = ?";
        Category category = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                category = mapResultSetToCategory(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return category;
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (createdBy, name, description) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, category.getCreatedBy());
            ps.setString(2, category.getName());
            ps.setString(3, category.getDescription());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET updatedBy = ?, name = ?, description = ? WHERE categoryId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, category.getUpdatedBy());
            ps.setString(2, category.getName());
            ps.setString(3, category.getDescription());
            ps.setInt(4, category.getCategoryId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE categoryId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(rs.getInt("categoryId"));
        c.setCreatedBy(rs.getInt("createdBy"));
        c.setUpdatedBy(rs.getInt("updatedBy"));
        c.setName(rs.getString("name"));
        c.setDescription(rs.getString("description"));
        return c;
    }
}
