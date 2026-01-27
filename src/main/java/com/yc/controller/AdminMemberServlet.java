package com.yc.controller;

import com.yc.dao.UserDAO;
import com.yc.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminMemberServlet")
public class AdminMemberServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        // Get search parameter
        String search = request.getParameter("search");
        List<User> members;

        if (search != null && !search.trim().isEmpty()) {
            members = userDAO.searchUsers(search.trim());
            request.setAttribute("searchQuery", search);
        } else {
            members = userDAO.getAllUsers();
        }

        int totalMembers = userDAO.getTotalUsers();

        request.setAttribute("members", members);
        request.setAttribute("totalMembers", totalMembers);

        request.getRequestDispatcher("AdminMember.jsp").forward(request, response);
    }
}
