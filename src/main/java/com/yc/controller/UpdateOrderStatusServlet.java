package com.yc.controller;

import com.yc.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        String newStatus = request.getParameter("status");
        String currentFilter = request.getParameter("currentFilter");

        if (orderIdStr == null || newStatus == null) {
            response.sendRedirect("AdminOrderServlet?error=invalid");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int adminId = (Integer) session.getAttribute("adminId");

            // Validate status
            if (!isValidStatus(newStatus)) {
                response.sendRedirect("AdminOrderServlet?error=invalidstatus");
                return;
            }

            boolean success = orderDAO.updateOrderStatus(orderId, newStatus, adminId);

            // Update payment status if order is cancelled
            if (success && "cancelled".equals(newStatus)) {
                orderDAO.updatePaymentStatus(orderId, "refunded");
            }

            String redirectUrl = "AdminOrderServlet?success=updated";
            if (currentFilter != null && !currentFilter.isEmpty()) {
                redirectUrl += "&status=" + currentFilter;
            }

            response.sendRedirect(redirectUrl);

        } catch (NumberFormatException e) {
            response.sendRedirect("AdminOrderServlet?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminOrderServlet?error=system");
        }
    }

    private boolean isValidStatus(String status) {
        return status != null && (
            status.equals("pending") ||
            status.equals("processing") ||
            status.equals("shipped") ||
            status.equals("delivered") ||
            status.equals("cancelled")
        );
    }
}
