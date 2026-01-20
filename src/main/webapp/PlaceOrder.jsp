<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Get cart items from session before clearing
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    
    // Store order info before clearing cart
    List<String[]> orderItems = new ArrayList<>();
    int subtotal = 0;
    int totalQty = 0;
    
    if (cartItems != null && !cartItems.isEmpty()) {
        for (Map.Entry<String, Integer> entry : cartItems.entrySet()) {
            String id = entry.getKey();
            int qty = entry.getValue();
            totalQty += qty;
            
            String name = "YAYA GOLD PALETTE";
            String img = "pic product/3.png";
            String desc = "Contain 12 shining color";
            int price = 100;
            
            if ("1".equals(id)) { name = "YAYA GOLD PALETTE"; img = "pic product/3.png"; desc = "Contain 12 shining color"; }
            else if ("2".equals(id)) { name = "YAYA BLUE PALETTE"; img = "pic product/4.png"; desc = "Contain 12 blue shade color"; }
            else if ("3".equals(id)) { name = "YAYA GREEN PALETTE"; img = "pic product/5.png"; desc = "Contain 12 earthy tone color"; }
            else if ("4".equals(id)) { name = "YAYA BLACK PALETTE"; img = "pic product/6.png"; desc = "Contain 12 dark shade color"; }
            else if ("5".equals(id)) { name = "YAYA PINK PALETTE"; img = "pic product/7.png"; desc = "Contain 12 pink shade color"; }
            else if ("6".equals(id)) { name = "YAYA ORANGE PALETTE"; img = "pic product/8.png"; desc = "Contain 12 fruity shade color"; }
            else if ("7".equals(id)) { name = "YAYA PURPLE PALETTE"; img = "pic product/9.png"; desc = "Contain 12 purple shade color"; }
            else if ("8".equals(id)) { name = "YAYA RED PALETTE"; img = "pic product/10.png"; desc = "Contain 12 red shade color"; }
            
            subtotal += price * qty;
            orderItems.add(new String[]{id, name, img, desc, String.valueOf(price), String.valueOf(qty)});
        }
        
        // Clear cart after storing order info
        cartItems.clear();
        session.setAttribute("cartItems", cartItems);
    }
    
    int shipping = 0;
    int tax = 10;
    int total = subtotal + shipping + tax;
    
    // If no items, use defaults for display
    if (orderItems.isEmpty()) {
        orderItems.add(new String[]{"1", "YAYA GOLD PALETTE", "pic product/3.png", "Contain 12 shining color", "100", "1"});
        subtotal = 100;
        total = 110;
        totalQty = 1;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Order Placed</title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        /* Header */
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

        /* Main Content */
        .order-container {
            padding: 40px 10%;
            min-height: 50vh;
        }

        .order-content {
            background-color: #f9f6f2;
            border-radius: 15px;
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
        }

        .order-item {
            display: flex;
            gap: 40px;
            align-items: flex-start;
            padding-bottom: 25px;
            border-bottom: 1px solid #e0e0e0;
            margin-bottom: 25px;
        }

        .order-item:last-of-type {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .product-section {
            flex: 0 0 250px;
        }

        .product-section img {
            width: 100%;
            border-radius: 10px;
        }

        .product-info {
            flex: 1;
        }

        .product-info h2 {
            font-size: 24px;
            margin: 0 0 10px 0;
            color: #333;
        }

        .product-info p {
            color: #666;
            margin: 0;
            font-size: 14px;
        }

        .order-summary {
            flex: 0 0 200px;
            text-align: right;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .summary-row .label {
            color: #666;
        }

        .summary-row .value {
            font-weight: 500;
        }

        .summary-row.total {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #ddd;
            font-size: 16px;
            font-weight: bold;
        }

        .summary-row.total .label {
            color: #333;
        }

        .success-message {
            text-align: center;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #e0e0e0;
        }

        .success-message h3 {
            color: #7b0d1e;
            font-size: 22px;
            margin: 0;
            letter-spacing: 1px;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-transform: uppercase;
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
            .order-item {
                flex-direction: column;
            }
            
            .product-section {
                flex: none;
                width: 100%;
                max-width: 250px;
                margin: 0 auto;
            }
            
            .order-summary {
                flex: none;
                width: 100%;
                text-align: left;
                margin-top: 20px;
            }

            .action-buttons {
                flex-direction: column;
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
            <a href="Cart.jsp">CART</a>
            <a href="History.jsp">HISTORY</a>
            <a href="Profile.jsp">PROFILE</a>
        </nav>
    </header>

    <div class="order-container">
        <div class="order-content">
            <% for (String[] item : orderItems) { 
                String itemName = item[1];
                String itemImg = item[2];
                String itemDesc = item[3];
                int itemPrice = Integer.parseInt(item[4]);
                int itemQty = Integer.parseInt(item[5]);
            %>
            <div class="order-item">
                <div class="product-section">
                    <img src="<%= itemImg %>" alt="<%= itemName %>">
                </div>
                
                <div class="product-info">
                    <h2><%= itemName %></h2>
                    <p><%= itemDesc %></p>
                    <% if (itemQty > 1) { %>
                    <p style="margin-top: 10px; font-weight: bold;">Quantity: <%= itemQty %></p>
                    <% } %>
                </div>
                
                <div class="order-summary">
                    <div class="summary-row">
                        <span class="label">Subtotal</span>
                        <span class="value">RM <%= subtotal %></span>
                    </div>
                    <div class="summary-row">
                        <span class="label">Shipping</span>
                        <span class="value">FREE</span>
                    </div>
                    <div class="summary-row">
                        <span class="label">Estimated Tax</span>
                        <span class="value">RM <%= tax %></span>
                    </div>
                    <div class="summary-row total">
                        <span class="label">ESTIMATED TOTAL</span>
                        <span class="value">RM <%= total %></span>
                    </div>
                </div>
            </div>
            <% } %>

            <div class="success-message">
                <h3>ORDER SUCCESSFULLY PLACED</h3>
            </div>

            <div class="action-buttons">
                <a href="History.jsp" class="btn btn-primary">VIEW ORDER HISTORY</a>
                <a href="Product.jsp" class="btn btn-secondary">CONTINUE SHOPPING</a>
            </div>
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
