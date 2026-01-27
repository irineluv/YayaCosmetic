package com.yc.controller;

import com.yc.dao.OrderDAO;
import com.yc.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminOrderServlet")
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        // Get filter parameter
        String statusFilter = request.getParameter("status");
        List<Order> orders;

        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
            orders = orderDAO.getOrdersByStatus(statusFilter);
            request.setAttribute("currentFilter", statusFilter);
        } else {
            orders = orderDAO.getAllOrders();
            request.setAttribute("currentFilter", "all");
        }

        // Get order counts for badges
        int pendingCount = orderDAO.getOrderCountByStatus("pending");
        int processingCount = orderDAO.getOrderCountByStatus("processing");
        int shippedCount = orderDAO.getOrderCountByStatus("shipped");
        int deliveredCount = orderDAO.getOrderCountByStatus("delivered");
        int cancelledCount = orderDAO.getOrderCountByStatus("cancelled");

        request.setAttribute("orders", orders);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("processingCount", processingCount);
        request.setAttribute("shippedCount", shippedCount);
        request.setAttribute("deliveredCount", deliveredCount);
        request.setAttribute("cancelledCount", cancelledCount);
        request.setAttribute("totalOrders", orders.size());

        request.getRequestDispatcher("AdminOrder.jsp").forward(request, response);
    }
}
