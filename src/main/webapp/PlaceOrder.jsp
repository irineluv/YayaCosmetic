<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ===== ORDER CONFIRMATION PAGE LOGIC =====
    // This page displays order confirmation after user completes checkout
    
    // Get order details submitted from Checkout.jsp form
    String address = request.getParameter("address"); // Shipping address
    String payment = request.getParameter("payment"); // Payment method (online/cod)
    String subtotalStr = request.getParameter("subtotal");
    String shippingStr = request.getParameter("shipping");
    String taxStr = request.getParameter("tax");
    String totalStr = request.getParameter("total");
    
    // Convert string values to integers, use defaults if null
    int subtotal = (subtotalStr != null) ? Integer.parseInt(subtotalStr) : 100;
    int shipping = (shippingStr != null) ? Integer.parseInt(shippingStr) : 0;
    int tax = (taxStr != null) ? Integer.parseInt(taxStr) : 10;
    int total = (totalStr != null) ? Integer.parseInt(totalStr) : 110;
    
    // Get cart from session to display product information
    List<String> cart = (List<String>) session.getAttribute("cart");
    
    // Default product (Gold Palette) - shown if cart is empty
    String productId = "1";
    String productName = "YAYA GOLD PALLATE";
    String productDesc = "Contain 12 shining color";
    String productImg = "pic product/3.png";
    
    // If cart has items, get the first product to display
    if (cart != null && !cart.isEmpty()) {
        productId = cart.get(0); // Get first product ID from cart
        
        // Determine product details based on ID (hardcoded for now)
        // Later with database: fetch product details using ProductDAO
        if ("2".equals(productId)) { 
            productName = "YAYA BLUE PALLATE"; 
            productImg = "pic product/4.png"; 
            productDesc = "Contain 12 blue shade color"; 
        } else if ("3".equals(productId)) { 
            productName = "YAYA GREEN PALLATE"; 
            productImg = "pic product/5.png"; 
            productDesc = "Contain 12 earthy tone color"; 
        } else if ("4".equals(productId)) { 
            productName = "YAYA BLACK PALLATE"; 
            productImg = "pic product/6.png"; 
            productDesc = "Contain 12 dark shade color"; 
        } else if ("5".equals(productId)) { 
            productName = "YAYA PINK PALLATE"; 
            productImg = "pic product/7.png"; 
            productDesc = "Contain 12 pink shade color"; 
        } else if ("6".equals(productId)) { 
            productName = "YAYA ORANGE PALLATE"; 
            productImg = "pic product/8.png"; 
            productDesc = "Contain 12 fruity shade color"; 
        } else if ("7".equals(productId)) { 
            productName = "YAYA PURPLE PALLATE"; 
            productImg = "pic product/9.png"; 
            productDesc = "Contain 12 purple shade color"; 
        } else if ("8".equals(productId)) { 
            productName = "YAYA RED PALLATE"; 
            productImg = "pic product/10.png"; 
            productDesc = "Contain 12 red shade color"; 
        }
    }
    
    // Clear cart after successful order placement
    // This prevents duplicate orders if user refreshes the page
    if (cart != null) {
        cart.clear(); // Remove all items from cart
        session.setAttribute("cart", cart); // Update session
    }
    
    // Later with database: save order to database before clearing cart
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
            background-color: #7b0d1e; /* Deep Red/Burgundy */
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
            height: 50px; /* Adjust based on your logo size */
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
            display:flex;
            align-items:center;
        }
        
        .dropdown{
            position: relative;
            display: inline-block;
        }
        
        .dropdown-content{
            display: none;
            position: absolute;
            background-color: #ffffff;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px black;
            z-index: 1;
            right: 0;
            margin-top: 5px;
        }
        
        .dropdown-content a{
            color: #7b0d1e !important;
            padding: 12px 16px;
            display: block;
            text-align: left;
            margin: 0;
            font-size: 13px;
            text-transform: none;
            border-bottom: 1px solid;
        }
        
        .dropdown-content a:hover{
            background-color: #f1f1f1;
        }
        
        .dropdown:hover .dropdown-content{
            display:block;
        }
        
        .dropdown:hover .dropbtn{
            color:#ccc;
        }
        
        /* Main Content */
        .order-confirmation {
            padding: 60px 10%;
            min-height: 60vh;
        }

        .confirmation-content {
            display: flex;
            gap: 50px;
            align-items: center;
            background-color: #f9f6f2;
            padding: 40px;
            border-radius: 15px;
            max-width: 900px;
            margin: 0 auto;
        }

        .product-image {
            flex: 0 0 200px;
        }

        .product-image img {
            width: 100%;
            border-radius: 10px;
        }

        .order-details {
            flex: 1;
        }

        .order-details h2 {
            font-size: 28px;
            margin: 0 0 10px 0;
            font-weight: bold;
        }

        .order-details p {
            color: #666;
            margin: 5px 0 20px 0;
            font-size: 14px;
        }

        .order-summary {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .summary-row.total {
            font-weight: bold;
            font-size: 16px;
            padding-top: 10px;
            border-top: 2px solid #ddd;
            margin-top: 10px;
        }

        .success-message {
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
            font-size: 16px;
            margin-top: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
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
            text-align: center;
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
            .confirmation-content {
                flex-direction: column;
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
           <div class="dropdown">
                 <% 
                     // Check if a user is logged in
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

    <div class="order-confirmation">
        <div class="confirmation-content">
            <div class="product-image">
                <img src="<%= productImg %>" alt="<%= productName %>">
            </div>

            <div class="order-details">
                <h2><%= productName %></h2>
                <p><%= productDesc %></p>

                <div class="order-summary">
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>RM <%= subtotal %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span><%= shipping == 0 ? "FREE" : "RM " + shipping %></span>
                    </div>
                    <div class="summary-row">
                        <span>Estimated Tax</span>
                        <span>RM <%= tax %></span>
                    </div>
                    <div class="summary-row total">
                        <span>ESTIMATED TOTAL</span>
                        <span>RM <%= total %></span>
                    </div>
                </div>

                <div class="success-message">
                    ORDER SUCCESSFULLY PLACED
                </div>

                <div class="action-buttons">
                    <a href="History.jsp" class="btn btn-primary">VIEW ORDER HISTORY</a>
                    <a href="Product.jsp" class="btn btn-secondary">CONTINUE SHOPPING</a>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <div class="footer-col">
            <h4>ABOUT YAYA</h4>
            <a href="#">HISTORY</a>
            <a href="#">WORK IN YAYA</a>
            <a href="#">BELABOUR</a>
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
