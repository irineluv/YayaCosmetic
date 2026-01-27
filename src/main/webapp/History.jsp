<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.Order, java.text.SimpleDateFormat" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    
    if (orders == null) {
        response.sendRedirect("OrderHistoryServlet");
        return;
    }
    
    if (cartCount == null) cartCount = 0;
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Order History</title>
    <style>
        body { margin: 0; font-family: 'Arial', sans-serif; background-color: #fcfcfc; }
        header { background-color: #7b0d1e; color: white; padding: 10px 50px; display: flex; justify-content: space-between; align-items: center; }
        .logo-container { display: flex; align-items: center; gap: 15px; }
        .logo-img { height: 50px; width: auto; }
        .brand-name { font-family: 'Times New Roman', serif; font-size: 26px; letter-spacing: 2px; text-transform: uppercase; }
        nav { display: flex; align-items: center; gap: 25px; }
        nav a { color: white; text-decoration: none; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; }
        .cart-icon { position: relative; }
        .cart-badge { position: absolute; top: -8px; right: -8px; background-color: #ffc107; color: #000; font-size: 10px; font-weight: bold; padding: 2px 6px; border-radius: 50%; }

        .history-section { padding: 40px 60px; min-height: 60vh; }
        .section-title { font-size: 32px; font-weight: bold; margin: 0 0 30px 0; }

        .order-card { background: #fff; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); overflow: hidden; }
        .order-header { display: flex; justify-content: space-between; align-items: center; padding: 20px; background-color: #f5ebe0; }
        .order-id { font-weight: bold; font-size: 16px; }
        .order-date { font-size: 13px; color: #666; }
        .order-body { padding: 20px; }
        .order-info { display: flex; justify-content: space-between; flex-wrap: wrap; gap: 20px; }
        .order-info-item { }
        .order-info-label { font-size: 12px; color: #666; text-transform: uppercase; }
        .order-info-value { font-size: 16px; font-weight: bold; margin-top: 5px; }

        .status-badge { display: inline-block; padding: 6px 15px; border-radius: 20px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .status-pending { background-color: #FFF3CD; color: #856404; }
        .status-processing { background-color: #CCE5FF; color: #004085; }
        .status-shipped { background-color: #E2D5F1; color: #4A2C7A; }
        .status-delivered { background-color: #D4EDDA; color: #155724; }
        .status-cancelled { background-color: #F8D7DA; color: #721C24; }

        .no-orders { text-align: center; padding: 60px; color: #666; }
        .no-orders a { display: inline-block; margin-top: 20px; padding: 12px 30px; background-color: #7b0d1e; color: white; text-decoration: none; border-radius: 5px; }

        footer { background-color: #7b0d1e; color: white; padding: 40px 60px; display: flex; justify-content: space-between; margin-top: 50px; }
        .footer-col { flex: 1; }
        .footer-col h4 { font-size: 16px; margin-bottom: 20px; text-transform: uppercase; }
        .footer-col p, .footer-col a { display: block; color: #ffffff; text-decoration: none; font-size: 13px; margin: 8px 0; }
    </style>
</head>
<body>

    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <span class="brand-name">Yaya Cosmetic</span>
        </div>
        <nav>
            <a href="HomePage.jsp">Home</a>
            <a href="ProductListServlet">Products</a>
            <a href="OrderHistoryServlet">History</a>
            <a href="ProfileServlet">Profile</a>
            <a href="LogoutServlet">Logout</a>
            <a href="CartServlet" class="cart-icon">🛒<% if (cartCount > 0) { %><span class="cart-badge"><%= cartCount %></span><% } %></a>
        </nav>
    </header>

    <section class="history-section">
        <h2 class="section-title">ORDER HISTORY</h2>

        <% if (orders.isEmpty()) { %>
            <div class="no-orders">
                <h3>No Orders Yet</h3>
                <p>You haven't placed any orders yet.</p>
                <a href="ProductListServlet">Start Shopping</a>
            </div>
        <% } else { 
            for (Order order : orders) { 
                String statusClass = "status-" + order.getStatus().toLowerCase();
        %>
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <div class="order-id">Order #<%= order.getOrderId() %></div>
                        <div class="order-date"><%= order.getOrderDate() != null ? sdf.format(order.getOrderDate()) : "-" %></div>
                    </div>
                    <span class="status-badge <%= statusClass %>"><%= order.getStatus() %></span>
                </div>
                <div class="order-body">
                    <div class="order-info">
                        <div class="order-info-item">
                            <div class="order-info-label">Total Amount</div>
                            <div class="order-info-value">RM <%= order.getTotalAmount() %></div>
                        </div>
                        <div class="order-info-item">
                            <div class="order-info-label">Payment Method</div>
                            <div class="order-info-value"><%= order.getPaymentMethod() != null ? order.getPaymentMethod().toUpperCase() : "-" %></div>
                        </div>
                        <div class="order-info-item">
                            <div class="order-info-label">Payment Status</div>
                            <div class="order-info-value"><%= order.getPaymentStatus() != null ? order.getPaymentStatus().toUpperCase() : "-" %></div>
                        </div>
                        <div class="order-info-item">
                            <div class="order-info-label">Shipping Address</div>
                            <div class="order-info-value" style="font-weight:normal; font-size:14px;"><%= order.getFullAddress() %></div>
                        </div>
                    </div>
                </div>
            </div>
        <% } 
        } %>
    </section>

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

</body>
</html>
