package com.yc.controller;

import com.yc.model.Product;
import com.yc.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/ProductDetailServlet")
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        Product product = null;

        if (idParam != null) {
            try (Connection conn = DBConnection.getConnection()) {

                String sql = "SELECT productId, name, description, price, image, colors " +
                             "FROM products WHERE productId = ?";

                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idParam));

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    product = new Product();
                    product.setProductId(rs.getInt("productId"));
                    product.setName(rs.getString("name"));
                    product.setDescription(rs.getString("description"));
                    product.setPrice(rs.getDouble("price"));
                    product.setImage(rs.getString("image"));
                    product.setColors(rs.getString("colors"));
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("product", product);
        request.getRequestDispatcher("ProductDetail.jsp").forward(request, response);
    }
}
