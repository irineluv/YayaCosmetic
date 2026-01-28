package com.yc.dao;

import com.yc.model.Product;
import com.yc.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY productId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                products.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE productId = ?";
        Product product = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = mapResultSetToProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return product;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE categoryId = ? ORDER BY productId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                products.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ? OR description LIKE ? ORDER BY productId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchTerm = "%" + keyword + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                products.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (categoryId, createdBy, name, description, price, stock_qty, image, colors) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, product.getCategoryId());
            ps.setInt(2, product.getCreatedBy());
            ps.setString(3, product.getName());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setInt(6, product.getStockQty());
            ps.setString(7, product.getImage());
            ps.setString(8, product.getColors());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET categoryId = ?, updatedBy = ?, name = ?, " +
                     "description = ?, price = ?, stock_qty = ?, image = ?, colors = ? WHERE productId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, product.getCategoryId());
            ps.setInt(2, product.getUpdatedBy());
            ps.setString(3, product.getName());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setInt(6, product.getStockQty());
            ps.setString(7, product.getImage());
            ps.setString(8, product.getColors());
            ps.setInt(9, product.getProductId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE productId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock_qty = stock_qty - ? WHERE productId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";

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

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("productId"));
        p.setCategoryId(rs.getInt("categoryId"));
        p.setCreatedBy(rs.getInt("createdBy"));
        p.setUpdatedBy(rs.getInt("updatedBy"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setStockQty(rs.getInt("stock_qty"));
        p.setImage(rs.getString("image"));
        p.setColors(rs.getString("colors"));
        return p;
    }
}
