package com.yc.controller;

import com.yc.model.Product;
import com.yc.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    List<Product> products = new ArrayList<>();

    String query = request.getParameter("searchQuery");
    if (query == null) query = "";

    try (Connection conn = DBConnection.getConnection()) {

        String sql;
        PreparedStatement ps;

        if (query.isEmpty()) {
            sql = "SELECT productId, name, description, price, image FROM products";
            ps = conn.prepareStatement(sql);
        } else {
            sql = "SELECT productId, name, description, price, image " +
                  "FROM products WHERE name LIKE ? OR description LIKE ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
        }

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt("productId"));
            p.setName(rs.getString("name"));
            p.setDescription(rs.getString("description"));
            p.setPrice(rs.getDouble("price"));
            p.setImage(rs.getString("image"));
            products.add(p);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    request.setAttribute("products", products);
    request.setAttribute("searchQuery", query);
    request.getRequestDispatcher("Product.jsp").forward(request, response);
}

}
