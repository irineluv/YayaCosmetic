<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.Order, java.text.SimpleDateFormat" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String currentFilter = (String) request.getAttribute("currentFilter");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer processingCount = (Integer) request.getAttribute("processingCount");
    Integer shippedCount = (Integer) request.getAttribute("shippedCount");
    Integer deliveredCount = (Integer) request.getAttribute("deliveredCount");
    Integer cancelledCount = (Integer) request.getAttribute("cancelledCount");
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    if (orders == null) {
        response.sendRedirect("AdminOrderServlet");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Order Management</title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        header {
            background-color: #7b0d1e;
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-area { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
        }
        
        .logo-img { 
            height: 45px; 
            width: auto; 
        }
        
        .brand-name { 
            font-family: 'Times New Roman', serif; 
            font-size: 24px; 
            letter-spacing: 2px; 
            text-transform: uppercase; 
        }
        
        nav a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .order-container {
            padding: 40px 5%;
            min-height: 60vh;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0;
        }

        .message {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .success-message {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .filter-tab {
            padding: 10px 20px;
            border: 2px solid #ddd;
            border-radius: 25px;
            background: white;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }

        .filter-tab:hover {
            border-color: #7b0d1e;
        }

        .filter-tab.active {
            background-color: #7b0d1e;
            border-color: #7b0d1e;
            color: white;
        }

        .filter-tab .count {
            background-color: #e0e0e0;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11px;
            margin-left: 5px;
        }

        .filter-tab.active .count {
            background-color: rgba(255,255,255,0.3);
        }

        .table-wrapper {
            overflow-x: auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-table thead {
            background-color: #7b0d1e;
            color: white;
        }

        .order-table th,
        .order-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .order-table th {
            font-weight: bold;
            text-transform: uppercase;
            font-size: 12px;
        }

        .order-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .order-id {
            font-weight: bold;
            color: #7b0d1e;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-pending { background-color: #FFF3CD; color: #856404; }
        .status-processing { background-color: #CCE5FF; color: #004085; }
        .status-shipped { background-color: #E2D5F1; color: #4A2C7A; }
        .status-delivered { background-color: #D4EDDA; color: #155724; }
        .status-cancelled { background-color: #F8D7DA; color: #721C24; }

        .status-select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 12px;
            cursor: pointer;
        }

        .btn-update {
            padding: 8px 15px;
            background-color: #001a72;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 11px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-update:hover {
            background-color: #000f45;
        }

        .no-orders {
            text-align: center;
            padding: 60px;
            color: #666;
        }

        footer {
            background-color: #7b0d1e;
            color: white;
            padding: 40px 60px;
            display: flex;
            justify-content: space-between;
            margin-top: 50px;
        }

        .footer-col {
            flex: 1;
        }

        .footer-col h4 {
            font-size: 16px;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        .footer-col p, .footer-col a {
            display: block;
            color: #ffffff;
            text-decoration: none;
            font-size: 13px;
            margin: 8px 0;
        }
    </style>
</head>
<body>

    <header>
        <div class="logo-area">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">Yaya Cosmetic</div>
        </div>
        <nav>
            <a href="AdminDashboardServlet">HOME</a>
            <a href="AdminProductServlet">PRODUCT</a>
            <a href="AdminOrderServlet">ORDER</a>
            <a href="AdminMemberServlet">MEMBER</a>
            <a href="AdminProfileServlet">PROFILE</a>
        </nav>
    </header>

    <div class="order-container">
        <div class="page-header">
            <h1 class="page-title">ORDER MANAGEMENT</h1>
        </div>

        <% if ("updated".equals(success)) { %>
            <div class="message success-message">Order status updated successfully!</div>
        <% } %>

        <div class="filter-tabs">
            <a href="AdminOrderServlet" class="filter-tab <%= "all".equals(currentFilter) ? "active" : "" %>">
                All <span class="count"><%= orders.size() %></span>
            </a>
            <a href="AdminOrderServlet?status=pending" class="filter-tab <%= "pending".equals(currentFilter) ? "active" : "" %>">
                Pending <span class="count"><%= pendingCount %></span>
            </a>
            <a href="AdminOrderServlet?status=processing" class="filter-tab <%= "processing".equals(currentFilter) ? "active" : "" %>">
                Processing <span class="count"><%= processingCount %></span>
            </a>
            <a href="AdminOrderServlet?status=shipped" class="filter-tab <%= "shipped".equals(currentFilter) ? "active" : "" %>">
                Shipped <span class="count"><%= shippedCount %></span>
            </a>
            <a href="AdminOrderServlet?status=delivered" class="filter-tab <%= "delivered".equals(currentFilter) ? "active" : "" %>">
                Delivered <span class="count"><%= deliveredCount %></span>
            </a>
            <a href="AdminOrderServlet?status=cancelled" class="filter-tab <%= "cancelled".equals(currentFilter) ? "active" : "" %>">
                Cancelled <span class="count"><%= cancelledCount %></span>
            </a>
        </div>

        <% if (orders.isEmpty()) { %>
            <div class="no-orders">
                <h2>No Orders Found</h2>
                <p>There are no orders matching your filter.</p>
            </div>
        <% } else { %>
            <div class="table-wrapper">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Total</th>
                            <th>Payment</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order order : orders) { 
                            String statusClass = "status-" + order.getStatus().toLowerCase();
                        %>
                            <tr>
                                <td class="order-id">#<%= order.getOrderId() %></td>
                                <td>
                                    <strong><%= order.getCustomerName() %></strong><br>
                                    <small><%= order.getCustomerEmail() %></small>
                                </td>
                                <td><%= order.getOrderDate() != null ? sdf.format(order.getOrderDate()) : "-" %></td>
                                <td><strong>RM <%= order.getTotalAmount() %></strong></td>
                                <td>
                                    <%= order.getPaymentMethod() %><br>
                                    <small>(<%= order.getPaymentStatus() %>)</small>
                                </td>
                                <td>
                                    <span class="status-badge <%= statusClass %>"><%= order.getStatus() %></span>
                                </td>
                                <td>
                                    <form action="UpdateOrderStatusServlet" method="POST" style="display:flex; gap:5px;">
                                        <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                        <input type="hidden" name="currentFilter" value="<%= currentFilter %>">
                                        <select name="status" class="status-select">
                                            <option value="pending" <%= "pending".equals(order.getStatus()) ? "selected" : "" %>>Pending</option>
                                            <option value="processing" <%= "processing".equals(order.getStatus()) ? "selected" : "" %>>Processing</option>
                                            <option value="shipped" <%= "shipped".equals(order.getStatus()) ? "selected" : "" %>>Shipped</option>
                                            <option value="delivered" <%= "delivered".equals(order.getStatus()) ? "selected" : "" %>>Delivered</option>
                                            <option value="cancelled" <%= "cancelled".equals(order.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn-update">Update</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <footer>
        <div class="footer-col">
            <h4>ABOUT YAYA</h4>
            <a href="#">HISTORY</a>
            <a href="#">WORK IN YAYA</a>
        </div>
        <div class="footer-col">
            <h4>ADDRESS</h4>
            <p>BANGI AVENUE HEIGHT</p>
            <p>DAMANSARA UTAMA</p>
            <p>96029 DAMANSARA</p>
            <p>SELANGOR</p>
        </div>
        <div class="footer-col">
            <h4>CONTACT</h4>
            <p>03-78279388 (OFFICE HOUR)</p>
            <p>yayacosmetic@hotline.com</p>
            <p>@yayacosmeticofficial (Instagram)</p>
        </div>
    </footer>

    <script>
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() { msg.style.display = 'none'; }, 500);
            });
        }, 5000);
    </script>

</body>
</html>
