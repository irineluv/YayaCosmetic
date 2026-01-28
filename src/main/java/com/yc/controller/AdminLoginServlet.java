package com.yc.controller;

import com.yc.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT adminId, email, fullName FROM admin WHERE email=? AND password=?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // LOGIN SUCCESS
                    HttpSession session = request.getSession();

                    session.setAttribute("adminId", rs.getInt("adminId"));
                    session.setAttribute("adminEmail", rs.getString("email"));
                    session.setAttribute("adminName", rs.getString("fullName"));

                    response.sendRedirect("AdminHome.jsp");

                } else {
                    // LOGIN FAILED
                    request.setAttribute("error", "Invalid email or password");
                    request.getRequestDispatcher("AdminLogin.jsp").forward(request, response);
                }
            }
        }
            

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error");
            request.getRequestDispatcher("AdminLogin.jsp").forward(request, response);
        }
    }
}
