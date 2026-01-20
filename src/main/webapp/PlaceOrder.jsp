<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Get order details from parameters
    String status = request.getParameter("status");
    String orderRef = request.getParameter("ref");
    String payment = request.getParameter("payment");
    String amountStr = request.getParameter("amount");
    
    // Generate order reference if not provided
    if (orderRef == null || orderRef.isEmpty()) {
        orderRef = "YC" + System.currentTimeMillis();
    }
    
    // Get cart items from session
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    
    // Calculate totals
    int subtotal = 0;
    int totalItems = 0;
    if (cartItems != null) {
        for (Integer qty : cartItems.values()) {
            totalItems += qty;
            subtotal += qty * 100;
        }
    }
    int shipping = 0;
    int tax = 10;
    int total = subtotal + shipping + tax;
    
    // Use amount from parameter if available
    if (amountStr != null) {
        try { total = Integer.parseInt(amountStr); } catch (NumberFormatException e) {}
    }
    
    // Determine payment method display
    String paymentDisplay = "Online Banking";
    if ("cod".equals(payment)) {
        paymentDisplay = "Cash on Delivery";
    }
    
    // Clear cart after order is placed
    if (cartItems != null) {
        cartItems.clear();
        session.setAttribute("cartItems", cartItems);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Order Confirmed</title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        header {
            background-color: #7b0d1e;
            color: white;
            padding: 10px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo-img {
            height: 50px;
            width: auto;
        }

        .brand-name {
            font-size: 28px;
            font-family: 'Times New Roman', serif;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-size: 13px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        nav {
            display: flex;
            align-items: center;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }
        
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #ffffff;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px black;
            z-index: 1;
            right: 0;
            margin-top: 5px;
        }
        
        .dropdown-content a {
            color: #7b0d1e !important;
            padding: 12px 16px;
            display: block;
            text-align: left;
            margin: 0;
            font-size: 13px;
            text-transform: none;
            border-bottom: 1px solid;
        }
        
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }
        
        .dropdown:hover .dropdown-content {
            display: block;
        }

        /* Cart Badge */
        .cart-link {
            position: relative;
            display: inline-block;
        }
        
        .cart-badge {
            position: absolute;
            top: -10px;
            right: -12px;
            background-color: #ffd700;
            color: #7b0d1e;
            font-size: 11px;
            font-weight: bold;
            min-width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        /* Main Content */
        .confirmation-container {
            padding: 60px 10%;
            min-height: 60vh;
            text-align: center;
        }

        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #4CAF50, #45a049);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: scaleIn 0.5s ease-out;
        }

        @keyframes scaleIn {
            0% { transform: scale(0); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .success-icon::after {
            content: "✓";
            font-size: 50px;
            color: white;
        }

        .confirmation-title {
            font-size: 32px;
            color: #333;
            margin-bottom: 10px;
        }

        .confirmation-subtitle {
            font-size: 16px;
            color: #666;
            margin-bottom: 40px;
        }

        .order-details-card {
            background-color: #f9f6f2;
            border-radius: 15px;
            padding: 40px;
            max-width: 600px;
            margin: 0 auto;
            text-align: left;
        }

        .order-ref {
            background-color: #7b0d1e;
            color: white;
            padding: 15px 25px;
            border-radius: 10px;
            display: inline-block;
            margin-bottom: 30px;
        }

        .order-ref-label {
            font-size: 12px;
            text-transform: uppercase;
            opacity: 0.8;
        }

        .order-ref-number {
            font-size: 20px;
            font-weight: bold;
            letter-spacing: 2px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            color: #666;
            font-size: 14px;
        }

        .detail-value {
            font-weight: bold;
            font-size: 14px;
        }

        .detail-row.total {
            padding-top: 20px;
            margin-top: 10px;
            border-top: 2px solid #ddd;
            border-bottom: none;
        }

        .detail-row.total .detail-label,
        .detail-row.total .detail-value {
            font-size: 18px;
            color: #7b0d1e;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 20px;
            background-color: #4CAF50;
            color: white;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 40px;
        }

        .btn {
            padding: 15px 35px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-transform: uppercase;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: #001a72;
            color: white;
        }

        .btn-primary:hover {
            background-color: #000f45;
        }

        .btn-secondary {
            background-color: #7b0d1e;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #5a0a15;
        }

        .email-notice {
            margin-top: 30px;
            padding: 20px;
            background-color: #e3f2fd;
            border-radius: 10px;
            font-size: 14px;
            color: #1565c0;
        }

        .email-notice::before {
            content: "📧 ";
        }

        /* Footer */
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
            line-height: 1.4;
        }

        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }
            
            .order-details-card {
                padding: 25px;
            }
        }
    </style>
</head>
<body>

    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">YAYA COSMETIC</div>
        </div>
        <nav>
            <a href="HomePage.jsp">HOME</a>
            <a href="Product.jsp">PRODUCT</a>
            <a href="Cart.jsp" class="cart-link">CART</a>
            <a href="History.jsp">HISTORY</a>
            <div class="dropdown">
                <% 
                    String currentUser = (String) session.getAttribute("userEmail"); 
                    if (currentUser == null) { 
                %>
                    <a href="#" class="dropbtn">Profile</a>
                    <div class="dropdown-content">
                        <a href="Login.jsp">Login</a>
                        <a href="Signup.jsp">Sign up</a>
                    </div>
                <% 
                    } else { 
                %>
                    <a href="#" class="dropbtn">Hi, <%= currentUser %></a>
                    <div class="dropdown-content">
                        <a href="Profile.jsp">View Profile</a>
                        <a href="Logout.jsp">Logout</a>
                    </div>
                <% 
                    } 
                %>
            </div>
        </nav>
    </header>

    <div class="confirmation-container">
        <div class="success-icon"></div>
        
        <h1 class="confirmation-title">Order Successfully Placed!</h1>
        <p class="confirmation-subtitle">Thank you for shopping with Yaya Cosmetic</p>

        <div class="order-details-card">
            <div style="text-align: center; margin-bottom: 25px;">
                <div class="order-ref">
                    <div class="order-ref-label">Order Reference</div>
                    <div class="order-ref-number"><%= orderRef %></div>
                </div>
            </div>

            <div class="detail-row">
                <span class="detail-label">Order Status</span>
                <span class="status-badge">Confirmed</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Payment Method</span>
                <span class="detail-value"><%= paymentDisplay %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Items Ordered</span>
                <span class="detail-value"><%= totalItems > 0 ? totalItems + " item(s)" : "Order processed" %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Subtotal</span>
                <span class="detail-value">RM <%= subtotal %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Shipping</span>
                <span class="detail-value">FREE</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Tax</span>
                <span class="detail-value">RM <%= tax %></span>
            </div>

            <div class="detail-row total">
                <span class="detail-label">Total Paid</span>
                <span class="detail-value">RM <%= total %></span>
            </div>
        </div>

        <div class="email-notice">
            A confirmation email will be sent to your registered email address with tracking details.
        </div>

        <div class="action-buttons">
            <a href="History.jsp" class="btn btn-primary">VIEW ORDER HISTORY</a>
            <a href="Product.jsp" class="btn btn-secondary">CONTINUE SHOPPING</a>
        </div>
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
            <p>yayacosmetic@hotline.com (official email)</p>
            <p>@yayacosmeticofficial (Instagram)</p>
        </div>
    </footer>

</body>
</html>
