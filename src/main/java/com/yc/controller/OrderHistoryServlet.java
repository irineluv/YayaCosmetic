package com.yc.controller;

import com.yc.dao.OrderDAO;
import com.yc.dao.CartDAO;
import com.yc.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        
        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        
        // Get cart count
        int cartId = cartDAO.getOrCreateCart(userId);
        int cartCount = cartDAO.getCartItemCount(cartId);

        request.setAttribute("orders", orders);
        request.setAttribute("cartCount", cartCount);
        request.getRequestDispatcher("History.jsp").forward(request, response);
    }
}
