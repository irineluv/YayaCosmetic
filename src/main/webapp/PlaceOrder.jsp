<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.Order, com.yc.model.OrderItem" %>
<%
    Order order = (Order) request.getAttribute("order");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    
    if (order == null) {
        response.sendRedirect("OrderHistoryServlet");
        return;
    }
    
    if (cartCount == null) cartCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Order Confirmation</title>
    <style>
        body { margin: 0; font-family: 'Arial', sans-serif; background-color: #fcfcfc; }
        header { background-color: #7b0d1e; color: white; padding: 10px 50px; display: flex; justify-content: space-between; align-items: center; }
        .logo-container { display: flex; align-items: center; gap: 15px; }
        .logo-img { height: 50px; width: auto; }
        .brand-name { font-family: 'Times New Roman', serif; font-size: 26px; letter-spacing: 2px; text-transform: uppercase; }
        nav { display: flex; align-items: center; gap: 25px; }
        nav a { color: white; text-decoration: none; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; }

        .confirmation-section { padding: 40px 60px; min-height: 60vh; text-align: center; }
        .success-icon { font-size: 80px; color: #28a745; margin-bottom: 20px; }
        .section-title { font-size: 32px; font-weight: bold; margin: 0 0 10px 0; color: #28a745; }
        .section-subtitle { font-size: 16px; color: #666; margin-bottom: 40px; }

        .order-details { max-width: 600px; margin: 0 auto; background: #fff; border-radius: 10px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: left; }
        .order-header { text-align: center; padding-bottom: 20px; border-bottom: 2px solid #f0f0f0; margin-bottom: 20px; }
        .order-number { font-size: 24px; font-weight: bold; color: #7b0d1e; }

        .detail-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; }
        .detail-label { color: #666; }
        .detail-value { font-weight: bold; }

        .order-items { margin-top: 20px; }
        .order-item { display: flex; gap: 15px; padding: 15px 0; border-bottom: 1px solid #eee; }
        .order-item img { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; }
        .order-item-details { flex: 1; }
        .order-item-name { font-weight: bold; }
        .order-item-qty { font-size: 13px; color: #666; }
        .order-item-price { font-weight: bold; }

        .order-total { display: flex; justify-content: space-between; padding: 20px 0; font-size: 20px; font-weight: bold; border-top: 2px solid #f0f0f0; margin-top: 10px; }

        .action-buttons { margin-top: 30px; text-align: center; }
        .btn { display: inline-block; padding: 12px 30px; border-radius: 5px; text-decoration: none; font-weight: bold; margin: 0 10px; }
        .btn-primary { background-color: #7b0d1e; color: white; }
        .btn-secondary { background-color: #f0f0f0; color: #333; }

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
        </nav>
    </header>

    <section class="confirmation-section">
        <div class="success-icon">✓</div>
        <h2 class="section-title">Order Placed Successfully!</h2>
        <p class="section-subtitle">Thank you for your purchase. Your order has been received.</p>

        <div class="order-details">
            <div class="order-header">
                <div class="order-number">Order #<%= order.getOrderId() %></div>
            </div>

            <div class="detail-row">
                <span class="detail-label">Status</span>
                <span class="detail-value"><%= order.getStatus().toUpperCase() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Payment Method</span>
                <span class="detail-value"><%= order.getPaymentMethod() != null ? order.getPaymentMethod().toUpperCase() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Payment Status</span>
                <span class="detail-value"><%= order.getPaymentStatus() != null ? order.getPaymentStatus().toUpperCase() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Shipping Address</span>
                <span class="detail-value"><%= order.getFullAddress() %></span>
            </div>

            <div class="order-items">
                <% if (orderItems != null) { 
                    for (OrderItem item : orderItems) { %>
                    <div class="order-item">
                        <img src="<%= item.getProductImage() != null ? item.getProductImage() : "pic product/3.png" %>" alt="<%= item.getProductName() %>">
                        <div class="order-item-details">
                            <div class="order-item-name"><%= item.getProductName() %></div>
                            <div class="order-item-qty">Qty: <%= item.getQuantity() %> × RM <%= item.getUnitPrice() %></div>
                        </div>
                        <div class="order-item-price">RM <%= item.getTotalPrice() %></div>
                    </div>
                <% } 
                } %>
            </div>

            <div class="order-total">
                <span>Total</span>
                <span>RM <%= order.getTotalAmount() %></span>
            </div>
        </div>

        <div class="action-buttons">
            <a href="OrderHistoryServlet" class="btn btn-secondary">View All Orders</a>
            <a href="ProductListServlet" class="btn btn-primary">Continue Shopping</a>
        </div>
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
