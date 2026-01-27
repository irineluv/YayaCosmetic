//package com.yc.controller;
//
//import com.yc.model.CartItem;
//import com.yc.model.Product;
//import com.yc.util.DBConnection;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//
//import java.io.IOException;
//import java.sql.*;
//import java.util.*;
//
//@WebServlet("/CartServlet")
//public class CartServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//
//        // Session cart: productId → quantity
//        Map<Integer, Integer> cartItems =
//                (Map<Integer, Integer>) session.getAttribute("cartItems");
//
//        if (cartItems == null) {
//            cartItems = new LinkedHashMap<>();
//            session.setAttribute("cartItems", cartItems);
//        }
//
//        String action = request.getParameter("action");
//        String idStr = request.getParameter("id");
//        String qtyStr = request.getParameter("quantity");
//
//        /* ================= CART ACTIONS ================= */
//
//        if ("add".equals(action) && idStr != null) {
//            int id = Integer.parseInt(idStr);
//            int qty = qtyStr != null ? Integer.parseInt(qtyStr) : 1;
//            cartItems.put(id, cartItems.getOrDefault(id, 0) + qty);
//        }
//
//        if ("update".equals(action) && idStr != null && qtyStr != null) {
//            int id = Integer.parseInt(idStr);
//            int qty = Integer.parseInt(qtyStr);
//            if (qty >= 0 && qty <= 99) {
//                cartItems.put(id, qty);
//            }
//        }
//
//        if ("remove".equals(action) && idStr != null) {
//            int id = Integer.parseInt(idStr);
//            if (cartItems.getOrDefault(id, 0) == 0) {
//                cartItems.remove(id);
//            }
//        }
//
//        /* ================= LOAD PRODUCT DETAILS ================= */
//
//        List<CartItem> cartList = new ArrayList<>();
//        int totalItems = 0;
//        int totalPrice = 0;
//
//        try (Connection conn = DBConnection.getConnection()) {
//
//            String sql = "SELECT productId, name, description, price, image " +
//                         "FROM products WHERE productId = ?";
//
//            PreparedStatement ps = conn.prepareStatement(sql);
//
//            for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
//
//                ps.setInt(1, entry.getKey());
//                ResultSet rs = ps.executeQuery();
//
//                if (rs.next()) {
//                    Product item = new Product();
//                    item.setProductId(rs.getInt("productId"));
//                    item.setName(rs.getString("name"));
//                    item.setDescription(rs.getString("description"));
//                    item.setPrice(rs.getInt("price"));
//                    item.setImage(rs.getString("image"));
//                    item.setQuantity(entry.getValue());
//
//                    cartList.add(item);
//
//                    totalItems += item.getQuantity();
//                    totalPrice += item.getSubtotal();
//                }
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        request.setAttribute("cartList", cartList);
//        request.setAttribute("totalItems", totalItems);
//        request.setAttribute("totalPrice", totalPrice);
//
//        request.getRequestDispatcher("Cart.jsp").forward(request, response);
//    }
//}
