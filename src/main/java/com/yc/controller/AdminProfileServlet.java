package com.yc.controller;

import com.yc.dao.AdminDAO;
import com.yc.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminProfileServlet")
public class AdminProfileServlet extends HttpServlet {

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

        int adminId = (Integer) session.getAttribute("adminId");
        Admin admin = adminDAO.getAdminById(adminId);

        if (admin == null) {
            session.invalidate();
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        request.setAttribute("admin", admin);
        request.getRequestDispatcher("AdminProfile.jsp").forward(request, response);
    }
}
