package com.yc.dao;

import com.yc.model.Cart;
import com.yc.model.CartItem;
import com.yc.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public Cart getCartByUserId(int userId) {
        String sql = "SELECT * FROM carts WHERE userId = ?";
        Cart cart = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cart = new Cart();
                cart.setCartId(rs.getInt("cartId"));
                cart.setUserId(rs.getInt("userId"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cart;
    }

    public int createCart(int userId) {
        String sql = "INSERT INTO carts (userId) VALUES (?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
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

    public int getOrCreateCart(int userId) {
        Cart cart = getCartByUserId(userId);
        if (cart != null) {
            return cart.getCartId();
        }
        return createCart(userId);
    }

    public List<CartItem> getCartItems(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.*, p.name as productName, p.price as productPrice, p.image as productImage, p.stock_qty as stockQty " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.productId = p.productId " +
                     "WHERE ci.cartId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartItemId(rs.getInt("cartItemId"));
                item.setCartId(rs.getInt("cartId"));
                item.setProductId(rs.getInt("productId"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProductName(rs.getString("productName"));
                item.setProductPrice(rs.getBigDecimal("productPrice"));
                item.setProductImage(rs.getString("productImage"));
                item.setStockQty(rs.getInt("stockQty"));
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean addToCart(int cartId, int productId, int quantity) {
        // Check if item already exists in cart
        String checkSql = "SELECT cartItemId, quantity FROM cart_items WHERE cartId = ? AND productId = ?";
        String insertSql = "INSERT INTO cart_items (cartId, productId, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE cart_items SET quantity = quantity + ? WHERE cartItemId = ?";

        try (Connection conn = DBConnection.getConnection()) {
            // Check existing
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, cartId);
            checkPs.setInt(2, productId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Update existing
                int cartItemId = rs.getInt("cartItemId");
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, quantity);
                updatePs.setInt(2, cartItemId);
                return updatePs.executeUpdate() > 0;
            } else {
                // Insert new
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setInt(1, cartId);
                insertPs.setInt(2, productId);
                insertPs.setInt(3, quantity);
                return insertPs.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCartItemQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE cart_items SET quantity = ? WHERE cartItemId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeCartItem(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE cartItemId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cartId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            return ps.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getCartItemCount(int cartId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) as total FROM cart_items WHERE cartId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal getCartTotal(int cartId) {
        String sql = "SELECT COALESCE(SUM(ci.quantity * p.price), 0) as total " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.productId = p.productId " +
                     "WHERE ci.cartId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
