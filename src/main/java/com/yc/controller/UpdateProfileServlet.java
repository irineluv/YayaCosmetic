package com.yc.controller;

import com.yc.dao.UserDAO;
import com.yc.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");

            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setFullName(fullName);
                user.setPhone(phone);
                
                if (userDAO.updateUser(user)) {
                    session.setAttribute("userName", fullName);
                    response.sendRedirect("ProfileServlet?success=profile");
                } else {
                    response.sendRedirect("ProfileServlet?error=updatefailed");
                }
            } else {
                response.sendRedirect("ProfileServlet?error=usernotfound");
            }

        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User user = userDAO.getUserById(userId);
            if (user != null) {
                // Verify current password
                if (!currentPassword.equals(user.getPassword())) {
                    response.sendRedirect("ProfileServlet?error=wrongpassword");
                    return;
                }

                // Verify new passwords match
                if (!newPassword.equals(confirmPassword)) {
                    response.sendRedirect("ProfileServlet?error=passwordmismatch");
                    return;
                }

                // Verify password length
                if (newPassword.length() < 6) {
                    response.sendRedirect("ProfileServlet?error=passwordtooshort");
                    return;
                }

                if (userDAO.updatePassword(userId, newPassword)) {
                    response.sendRedirect("ProfileServlet?success=password");
                } else {
                    response.sendRedirect("ProfileServlet?error=updatefailed");
                }
            } else {
                response.sendRedirect("ProfileServlet?error=usernotfound");
            }

        } else {
            response.sendRedirect("ProfileServlet");
        }
    }
}
