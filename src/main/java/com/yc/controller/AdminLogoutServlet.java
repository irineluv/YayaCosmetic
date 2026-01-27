package com.yc.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminLogoutServlet")
public class AdminLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Remove admin-specific attributes
            session.removeAttribute("adminId");
            session.removeAttribute("adminEmail");
            session.removeAttribute("adminName");
            
            // Optionally invalidate entire session
            session.invalidate();
        }

        response.sendRedirect("AdminLogin.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
