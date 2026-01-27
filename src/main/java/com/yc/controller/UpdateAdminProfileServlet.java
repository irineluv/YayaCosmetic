package com.yc.controller;

import com.yc.dao.AdminDAO;
import com.yc.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateAdminProfileServlet")
public class UpdateAdminProfileServlet extends HttpServlet {

    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        // Get field to edit
        String field = request.getParameter("field");
        int adminId = (Integer) session.getAttribute("adminId");
        Admin admin = adminDAO.getAdminById(adminId);

        request.setAttribute("admin", admin);
        request.setAttribute("editField", field);
        request.getRequestDispatcher("AdminEditProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");
        String field = request.getParameter("field");
        String value = request.getParameter("value");

        boolean success = false;
        String updatedField = "";

        try {
            if ("name".equals(field)) {
                Admin admin = adminDAO.getAdminById(adminId);
                admin.setFullName(value);
                success = adminDAO.updateAdmin(admin);
                updatedField = "name";
                
                // Update session
                if (success) {
                    session.setAttribute("adminName", value);
                }

            } else if ("phone".equals(field)) {
                Admin admin = adminDAO.getAdminById(adminId);
                admin.setPhone(value);
                success = adminDAO.updateAdmin(admin);
                updatedField = "phone";

            } else if ("password".equals(field)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                // Validate current password
                if (!adminDAO.validatePassword(adminId, currentPassword)) {
                    request.setAttribute("error", "Current password is incorrect");
                    doGet(request, response);
                    return;
                }

                // Validate new password match
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "New passwords do not match");
                    doGet(request, response);
                    return;
                }

                // Validate password length
                if (newPassword.length() < 6) {
                    request.setAttribute("error", "Password must be at least 6 characters");
                    doGet(request, response);
                    return;
                }

                success = adminDAO.updatePassword(adminId, newPassword);
                updatedField = "password";
            }

            if (success) {
                response.sendRedirect("AdminProfileServlet?success=true&updated=" + updatedField);
            } else {
                request.setAttribute("error", "Failed to update profile");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            doGet(request, response);
        }
    }
}
