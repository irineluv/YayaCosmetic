package com.yc.dao;

import com.yc.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDAO {

    public Map<String, BigDecimal> getMonthlySales() {
        Map<String, BigDecimal> monthlySales = new LinkedHashMap<>();
        // Get last 6 months of sales data including previous year
        String sql = "SELECT DATE_FORMAT(order_date, '%b %Y') as month, " +
                     "SUM(totalAmount) as total " +
                     "FROM orders " +
                     "WHERE paymentStatus = 'paid' " +
                     "AND order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) " +
                     "GROUP BY YEAR(order_date), MONTH(order_date), DATE_FORMAT(order_date, '%b %Y') " +
                     "ORDER BY YEAR(order_date), MONTH(order_date)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                monthlySales.put(rs.getString("month"), rs.getBigDecimal("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return monthlySales;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(totalAmount), 0) as total FROM orders WHERE paymentStatus = 'paid'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getMonthlyRevenue() {
        String sql = "SELECT COALESCE(SUM(totalAmount), 0) as total FROM orders " +
                     "WHERE paymentStatus = 'paid' " +
                     "AND MONTH(order_date) = MONTH(CURRENT_DATE) " +
                     "AND YEAR(order_date) = YEAR(CURRENT_DATE)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";

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

    public int getTotalMembers() {
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

    public int getPendingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'pending'";

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

    public Map<String, Integer> getTopSellingProducts(int limit) {
        Map<String, Integer> topProducts = new LinkedHashMap<>();
        String sql = "SELECT p.name, SUM(oi.quantity) as totalSold " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.productId = p.productId " +
                     "JOIN orders o ON oi.orderId = o.orderId " +
                     "WHERE o.paymentStatus = 'paid' " +
                     "GROUP BY p.productId, p.name " +
                     "ORDER BY totalSold DESC " +
                     "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                topProducts.put(rs.getString("name"), rs.getInt("totalSold"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topProducts;
    }

    public Map<String, BigDecimal> getProductSalesPercentage() {
        Map<String, BigDecimal> salesPercentage = new LinkedHashMap<>();
        String sql = "SELECT p.name, " +
                     "ROUND(SUM(oi.totalPrice) * 100.0 / " +
                     "(SELECT SUM(totalPrice) FROM order_items oi2 " +
                     "JOIN orders o2 ON oi2.orderId = o2.orderId WHERE o2.paymentStatus = 'paid'), 2) as percentage " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.productId = p.productId " +
                     "JOIN orders o ON oi.orderId = o.orderId " +
                     "WHERE o.paymentStatus = 'paid' " +
                     "GROUP BY p.productId, p.name " +
                     "ORDER BY percentage DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BigDecimal pct = rs.getBigDecimal("percentage");
                if (pct != null) {
                    salesPercentage.put(rs.getString("name"), pct);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return salesPercentage;
    }

    public Map<String, Integer> getOrderStatusCounts() {
        Map<String, Integer> statusCounts = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM orders GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                statusCounts.put(rs.getString("status"), rs.getInt("count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return statusCounts;
    }
}
