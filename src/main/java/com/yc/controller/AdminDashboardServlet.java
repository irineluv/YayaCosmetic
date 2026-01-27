package com.yc.controller;

import com.yc.dao.DashboardDAO;
import com.yc.util.ChartGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    private DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        // Get dashboard statistics
        Map<String, BigDecimal> monthlySales = dashboardDAO.getMonthlySales();
        BigDecimal totalRevenue = dashboardDAO.getTotalRevenue();
        BigDecimal monthlyRevenue = dashboardDAO.getMonthlyRevenue();
        int totalOrders = dashboardDAO.getTotalOrders();
        int totalMembers = dashboardDAO.getTotalMembers();
        int totalProducts = dashboardDAO.getTotalProducts();
        int pendingOrders = dashboardDAO.getPendingOrders();

        // Get top selling products
        Map<String, Integer> topProducts = dashboardDAO.getTopSellingProducts(5);

        // Get order status counts
        Map<String, Integer> orderStatusCounts = dashboardDAO.getOrderStatusCounts();

        // Generate SVG Charts using Java
        String barChartSvg = ChartGenerator.generateBarChart(monthlySales, 450, 280, "#7b0d1e");
        
        String[] doughnutColors = {"#FFC107", "#17A2B8", "#9C27B0", "#28A745", "#DC3545"};
        String doughnutChartSvg = ChartGenerator.generateDoughnutChart(orderStatusCounts, 280, doughnutColors);
        
        String topProductsChartSvg = ChartGenerator.generateHorizontalBarChart(topProducts, 400, 200, "#001a72");

        // Set attributes
        request.setAttribute("monthlySales", monthlySales);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalMembers", totalMembers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("orderStatusCounts", orderStatusCounts);
        
        // Set chart SVGs
        request.setAttribute("barChartSvg", barChartSvg);
        request.setAttribute("doughnutChartSvg", doughnutChartSvg);
        request.setAttribute("topProductsChartSvg", topProductsChartSvg);

        request.getRequestDispatcher("AdminHome.jsp").forward(request, response);
    }
}
