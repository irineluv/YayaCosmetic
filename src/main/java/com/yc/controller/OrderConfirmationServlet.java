package com.yc.controller;

import com.yc.dao.OrderDAO;
import com.yc.dao.CartDAO;
import com.yc.model.Order;
import com.yc.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/OrderConfirmationServlet")
public class OrderConfirmationServlet extends HttpServlet {

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

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect("OrderHistoryServlet");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int userId = (Integer) session.getAttribute("userId");
            
            Order order = orderDAO.getOrderById(orderId);
            
            // Verify order belongs to user
            if (order == null || order.getUserId() != userId) {
                response.sendRedirect("OrderHistoryServlet");
                return;
            }
            
            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
            
            // Get cart count
            int cartId = cartDAO.getOrCreateCart(userId);
            int cartCount = cartDAO.getCartItemCount(cartId);

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("cartCount", cartCount);
            request.getRequestDispatcher("PlaceOrder.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("OrderHistoryServlet");
        }
    }
}
