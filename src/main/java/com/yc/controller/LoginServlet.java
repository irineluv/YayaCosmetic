package com.yc.controller;

import com.yc.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT userId, email, full_name FROM users WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ LOGIN SUCCESS
                HttpSession session = request.getSession();

                session.setAttribute("userId", rs.getInt("userId"));
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userName", rs.getString("full_name"));

                response.sendRedirect("HomePage.jsp");

            } else {
                // ❌ LOGIN FAILED
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}
