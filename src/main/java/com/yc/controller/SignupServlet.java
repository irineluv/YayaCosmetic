package com.yc.controller;

import com.yc.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Check password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("Signup.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            //Check email existance/existence/existense(?)
            String checkSql = "SELECT userId FROM users WHERE email = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Email already registered");
                request.getRequestDispatcher("Signup.jsp").forward(request, response);
                return;
            }

            // new user insertion yippee
            String insertSql =
                "INSERT INTO users (email, password, full_name, phone, role) " +
                "VALUES (?, ?, ?, ?, 'customer')";

            PreparedStatement ps = conn.prepareStatement(insertSql);
            ps.setString(1, email);
            ps.setString(2, password);   
            ps.setString(3, name);
            ps.setString(4, phone);

            ps.executeUpdate();

            // successful sign up, pergi login page 
            response.sendRedirect("Login.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error");
            request.getRequestDispatcher("Signup.jsp").forward(request, response);
        }
    }
}
