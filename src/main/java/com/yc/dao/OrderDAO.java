package com.yc.dao;

import com.yc.model.Order;
import com.yc.model.OrderItem;
import com.yc.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as customerName, u.email as customerEmail, " +
                     "a.addressLine, a.city, a.state, a.postalCode " +
                     "FROM orders o " +
                     "JOIN users u ON o.userId = u.userId " +
                     "JOIN addresses a ON o.addressId = a.addressId " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = mapResultSetToOrder(rs);
                orders.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.full_name as customerName, u.email as customerEmail, " +
                     "a.addressLine, a.city, a.state, a.postalCode, a.phone as addressPhone " +
                     "FROM orders o " +
                     "JOIN users u ON o.userId = u.userId " +
                     "JOIN addresses a ON o.addressId = a.addressId " +
                     "WHERE o.orderId = ?";
        Order order = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                order = mapResultSetToOrder(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as customerName, u.email as customerEmail, " +
                     "a.addressLine, a.city, a.state, a.postalCode " +
                     "FROM orders o " +
                     "JOIN users u ON o.userId = u.userId " +
                     "JOIN addresses a ON o.addressId = a.addressId " +
                     "WHERE o.status = ? " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = mapResultSetToOrder(rs);
                orders.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as customerName, u.email as customerEmail, " +
                     "a.addressLine, a.city, a.state, a.postalCode " +
                     "FROM orders o " +
                     "JOIN users u ON o.userId = u.userId " +
                     "JOIN addresses a ON o.addressId = a.addressId " +
                     "WHERE o.userId = ? " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = mapResultSetToOrder(rs);
                orders.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name as productName, p.image as productImage " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.productId = p.productId " +
                     "WHERE oi.orderId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("orderItemId"));
                item.setOrderId(rs.getInt("orderId"));
                item.setProductId(rs.getInt("productId"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getBigDecimal("unitPrice"));
                item.setTotalPrice(rs.getBigDecimal("totalPrice"));
                item.setProductName(rs.getString("productName"));
                item.setProductImage(rs.getString("productImage"));
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean updateOrderStatus(int orderId, String status, int adminId) {
        String sql = "UPDATE orders SET status = ?, handledBy = ?, updated_at = CURRENT_TIMESTAMP WHERE orderId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, adminId);
            ps.setInt(3, orderId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET paymentStatus = ?, updated_at = CURRENT_TIMESTAMP WHERE orderId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (userId, addressId, totalAmount, status, paymentMethod, paymentStatus) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getAddressId());
            ps.setBigDecimal(3, order.getTotalAmount());
            ps.setString(4, order.getStatus());
            ps.setString(5, order.getPaymentMethod());
            ps.setString(6, order.getPaymentStatus());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addOrderItem(OrderItem item) {
        String sql = "INSERT INTO order_items (orderId, productId, quantity, unitPrice, totalPrice) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getUnitPrice());
            ps.setBigDecimal(5, item.getTotalPrice());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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

    public int getOrderCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("orderId"));
        o.setUserId(rs.getInt("userId"));
        o.setAddressId(rs.getInt("addressId"));
        o.setHandledBy(rs.getInt("handledBy"));
        o.setTotalAmount(rs.getBigDecimal("totalAmount"));
        o.setStatus(rs.getString("status"));
        o.setPaymentMethod(rs.getString("paymentMethod"));
        o.setPaymentStatus(rs.getString("paymentStatus"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Additional joined fields
        try {
            o.setCustomerName(rs.getString("customerName"));
            o.setCustomerEmail(rs.getString("customerEmail"));
            o.setAddressLine(rs.getString("addressLine"));
            o.setCity(rs.getString("city"));
            o.setState(rs.getString("state"));
            o.setPostalCode(rs.getString("postalCode"));
        } catch (SQLException e) {
            // These fields may not exist in all queries
        }
        
        return o;
    }
}
