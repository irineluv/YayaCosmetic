<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ===== CHECKOUT PAGE LOGIC =====
    // This page displays the checkout form where users enter shipping address and payment method
    
    // Get cart from session - session stores data across multiple page requests
    List<String> cart = (List<String>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>(); // Create empty cart if none exists
    }
    
    // Calculate order totals
    int subtotal = 0;
    if (!cart.isEmpty()) {
        subtotal = cart.size() * 100; // Each product costs RM 100
    }
    int shipping = 0; // FREE shipping for all orders
    int tax = 10; // Fixed tax amount
    int total = subtotal + shipping + tax; // Calculate final total
    
    // Later with database: fetch actual product prices and calculate dynamically
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Checkout</title>
    <style>
        /* ===== GLOBAL STYLES ===== */
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        /* ===== HEADER STYLES ===== */
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

        /* ===== MAIN CONTENT AREA ===== */
        .checkout-container {
            padding: 40px 10%;
            display: flex;
            gap: 40px;
            min-height: 60vh;
        }

        .checkout-form {
            flex: 1;
        }

        .checkout-form h2 {
            font-size: 18px;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .form-group {
            margin-bottom: 30px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-family: Arial, sans-serif;
            font-size: 14px;
            resize: vertical;
            min-height: 100px;
            box-sizing: border-box;
        }

        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .payment-options label {
            display: flex;
            align-items: center;
            font-size: 14px;
            font-weight: normal;
            cursor: pointer;
        }

        .payment-options input[type="radio"] {
            margin-right: 10px;
        }

        /* ===== ORDER SUMMARY BOX ===== */
        .order-summary {
            flex: 0 0 350px;
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 10px;
            height: fit-content;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .summary-row.total {
            font-weight: bold;
            font-size: 16px;
            padding-top: 15px;
            border-top: 2px solid #ddd;
            margin-top: 15px;
        }

        .place-order-btn {
            width: 100%;
            background-color: #001a72;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            margin-top: 20px;
        }

        .place-order-btn:hover {
            background-color: #000f45;
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
            .checkout-container {
                flex-direction: column;
            }
            
            .order-summary {
                flex: 1;
            }
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
            <a href="HomePage.jsp">HOME</a>
            <a href="Product.html">PRODUCT</a>
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

    <div class="checkout-container">
        <!-- LEFT SIDE: Checkout Form -->
        <div class="checkout-form">
            <form action="PlaceOrder.jsp" method="POST">
                <!-- Section 1: Shipping Address -->
                <div class="form-group">
                    <h2>1. Address (ENTER FULL ADDRESS)</h2>
                    <textarea name="address" required placeholder="Enter your full delivery address..."></textarea>
                </div>

                <!-- Section 2: Payment Method Selection -->
                <div class="form-group">
                    <h2>2. Payment Method</h2>
                    <div class="payment-options">
                        <label>
                            <input type="radio" name="payment" value="online" checked>
                            Online Payment
                        </label>
                        <label>
                            <input type="radio" name="payment" value="cod">
                            Cash on Delivery
                        </label>
                    </div>
                </div>

                <!-- Hidden fields to pass order totals to next page -->
                <input type="hidden" name="subtotal" value="<%= subtotal %>">
                <input type="hidden" name="shipping" value="<%= shipping %>">
                <input type="hidden" name="tax" value="<%= tax %>">
                <input type="hidden" name="total" value="<%= total %>">
            </form>
        </div>

        <!-- RIGHT SIDE: Order Summary -->
        <div class="order-summary">
            <!-- Display subtotal (sum of all products) -->
            <div class="summary-row">
                <span>Subtotal</span>
                <span>RM <%= subtotal %></span>
            </div>
            
            <!-- Display shipping cost (FREE in this case) -->
            <div class="summary-row">
                <span>Shipping</span>
                <span><%= shipping == 0 ? "FREE" : "RM " + shipping %></span>
            </div>
            
            <!-- Display tax amount -->
            <div class="summary-row">
                <span>Estimated Tax</span>
                <span>RM <%= tax %></span>
            </div>
            
            <!-- Display final total -->
            <div class="summary-row total">
                <span>ESTIMATED TOTAL</span>
                <span>RM <%= total %></span>
            </div>
            
            <!-- Submit button - triggers form submission -->
            <button type="submit" class="place-order-btn" onclick="document.querySelector('form').submit();">PLACE ORDER</button>
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
