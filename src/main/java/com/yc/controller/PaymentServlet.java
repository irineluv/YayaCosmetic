package com.yc.controller;

import com.yc.dao.CartDAO;
import com.yc.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Integer orderId = (Integer) session.getAttribute("pendingOrderId");
        if (orderId == null) {
            response.sendRedirect("CartServlet");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        
        // Simulate payment processing
        String action = request.getParameter("action");
        
        if ("confirm".equals(action)) {
            // Payment successful
            orderDAO.updatePaymentStatus(orderId, "paid");
            orderDAO.updateOrderStatus(orderId, "processing", 0);
            
            // Clear cart
            int cartId = cartDAO.getOrCreateCart(userId);
            cartDAO.clearCart(cartId);
            
            // Clear pending order from session
            session.removeAttribute("pendingOrderId");
            session.removeAttribute("pendingOrderTotal");
            session.removeAttribute("pendingPaymentMethod");
            
            response.sendRedirect("OrderConfirmationServlet?orderId=" + orderId);
            
        } else if ("cancel".equals(action)) {
            // Payment cancelled - delete the order
            // For now, just mark as cancelled
            orderDAO.updateOrderStatus(orderId, "cancelled", 0);
            orderDAO.updatePaymentStatus(orderId, "cancelled");
            
            session.removeAttribute("pendingOrderId");
            session.removeAttribute("pendingOrderTotal");
            session.removeAttribute("pendingPaymentMethod");
            
            response.sendRedirect("CartServlet?message=cancelled");
        } else {
            response.sendRedirect("CheckoutServlet");
        }
    }
}
