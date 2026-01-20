<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Get cart items from session (new Map-based structure)
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    if (cartItems == null || cartItems.isEmpty()) {
        // Redirect to cart if empty
        response.sendRedirect("Cart.jsp");
        return;
    }
    
    // Calculate order totals
    int subtotal = 0;
    int totalItems = 0;
    for (Integer qty : cartItems.values()) {
        totalItems += qty;
        subtotal += qty * 100; // Each product is RM 100
    }
    int shipping = 0; // FREE shipping
    int tax = 10; // Fixed tax
    int total = subtotal + shipping + tax;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Checkout</title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
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

        .checkout-container {
            padding: 40px 10%;
            display: flex;
            gap: 40px;
            min-height: 60vh;
        }

        .checkout-form {
            flex: 1;
        }

        .checkout-form h1 {
            font-size: 32px;
            margin: 0 0 30px 0;
        }

        .checkout-form h2 {
            font-size: 18px;
            margin-bottom: 15px;
            font-weight: bold;
            color: #333;
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

        .form-group textarea,
        .form-group input[type="text"],
        .form-group input[type="tel"] {
            width: 100%;
            padding: 14px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-family: Arial, sans-serif;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-group textarea:focus,
        .form-group input:focus {
            outline: none;
            border-color: #7b0d1e;
        }

        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .payment-option {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .payment-option:hover {
            border-color: #7b0d1e;
        }

        .payment-option.selected {
            border-color: #7b0d1e;
            background-color: #fff5f5;
        }

        .payment-option input[type="radio"] {
            margin-right: 15px;
            width: 18px;
            height: 18px;
        }

        .payment-option-content {
            flex: 1;
        }

        .payment-option-title {
            font-weight: bold;
            font-size: 15px;
            margin-bottom: 3px;
        }

        .payment-option-desc {
            font-size: 12px;
            color: #666;
        }

        .payment-icon {
            font-size: 24px;
            margin-left: 15px;
        }

        /* Order Summary */
        .order-summary {
            flex: 0 0 380px;
            background-color: #f9f6f2;
            padding: 30px;
            border-radius: 15px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }

        .order-summary h3 {
            font-size: 20px;
            margin: 0 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 2px solid #ddd;
        }

        .order-items {
            margin-bottom: 20px;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 14px;
            border-bottom: 1px solid #e0e0e0;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-item-name {
            flex: 1;
        }

        .order-item-qty {
            color: #666;
            margin: 0 15px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .summary-row.total {
            font-weight: bold;
            font-size: 18px;
            padding-top: 15px;
            border-top: 2px solid #ddd;
            margin-top: 15px;
        }

        .place-order-btn {
            width: 100%;
            background-color: #001a72;
            color: white;
            border: none;
            padding: 16px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            margin-top: 20px;
            transition: background-color 0.3s;
        }

        .place-order-btn:hover {
            background-color: #000f45;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #666;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link:hover {
            color: #7b0d1e;
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
                position: static;
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
            <a href="Cart.jsp" class="cart-link">CART<% if (totalItems > 0) { %><span class="cart-badge"><%= totalItems > 99 ? "99+" : totalItems %></span><% } %></a>
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

    <div class="checkout-container">
        <!-- LEFT SIDE: Checkout Form -->
        <div class="checkout-form">
            <h1>CHECKOUT</h1>
            
            <form id="checkoutForm" action="BankPayment.jsp" method="GET">
                <!-- Section 1: Shipping Address -->
                <div class="form-group">
                    <h2>1. Shipping Address</h2>
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="Enter your full name" required>
                </div>
                
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" name="phone" placeholder="e.g., 012-3456789" required>
                </div>
                
                <div class="form-group">
                    <label>Delivery Address</label>
                    <textarea name="address" required placeholder="Enter your full delivery address including:&#10;- Street address&#10;- City&#10;- State&#10;- Postal code"></textarea>
                </div>

                <!-- Section 2: Payment Method -->
                <div class="form-group">
                    <h2>2. Payment Method</h2>
                    <div class="payment-options">
                        <label class="payment-option selected" onclick="selectPayment(this, 'online')">
                            <input type="radio" name="payment" value="online" checked>
                            <div class="payment-option-content">
                                <div class="payment-option-title">Online Banking / Card Payment</div>
                                <div class="payment-option-desc">Pay securely via FPX or Credit/Debit Card</div>
                            </div>
                            <span class="payment-icon">💳</span>
                        </label>
                        <label class="payment-option" onclick="selectPayment(this, 'cod')">
                            <input type="radio" name="payment" value="cod">
                            <div class="payment-option-content">
                                <div class="payment-option-title">Cash on Delivery</div>
                                <div class="payment-option-desc">Pay when you receive your order</div>
                            </div>
                            <span class="payment-icon">💵</span>
                        </label>
                    </div>
                </div>

                <!-- Hidden fields -->
                <input type="hidden" name="amount" value="<%= total %>">
                <input type="hidden" name="subtotal" value="<%= subtotal %>">
                <input type="hidden" name="items" value="<%= totalItems %>">
            </form>
        </div>

        <!-- RIGHT SIDE: Order Summary -->
        <div class="order-summary">
            <h3>Order Summary</h3>
            
            <!-- List of items -->
            <div class="order-items">
                <%
                    for (Map.Entry<String, Integer> entry : cartItems.entrySet()) {
                        String id = entry.getKey();
                        int qty = entry.getValue();
                        
                        String name = "YAYA GOLD PALETTE";
                        if ("1".equals(id)) name = "YAYA GOLD PALETTE";
                        else if ("2".equals(id)) name = "YAYA BLUE PALETTE";
                        else if ("3".equals(id)) name = "YAYA GREEN PALETTE";
                        else if ("4".equals(id)) name = "YAYA BLACK PALETTE";
                        else if ("5".equals(id)) name = "YAYA PINK PALETTE";
                        else if ("6".equals(id)) name = "YAYA ORANGE PALETTE";
                        else if ("7".equals(id)) name = "YAYA PURPLE PALETTE";
                        else if ("8".equals(id)) name = "YAYA RED PALETTE";
                        
                        int itemTotal = qty * 100;
                %>
                    <div class="order-item">
                        <span class="order-item-name"><%= name %></span>
                        <span class="order-item-qty">x<%= qty %></span>
                        <span>RM <%= itemTotal %></span>
                    </div>
                <%
                    }
                %>
            </div>
            
            <div class="summary-row">
                <span>Subtotal (<%= totalItems %> items)</span>
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
                <span>TOTAL</span>
                <span>RM <%= total %></span>
            </div>
            
            <button type="button" class="place-order-btn" onclick="submitOrder()">
                PROCEED TO PAYMENT
            </button>
            
            <a href="Cart.jsp" class="back-link">← Back to Cart</a>
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

    <script>
        function selectPayment(element, value) {
            // Remove selected class from all options
            document.querySelectorAll('.payment-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            // Add selected class to clicked option
            element.classList.add('selected');
        }

        function submitOrder() {
            var form = document.getElementById('checkoutForm');
            var paymentMethod = document.querySelector('input[name="payment"]:checked').value;
            
            // Validate form
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            
            if (paymentMethod === 'online') {
                // Redirect to bank payment page
                form.action = 'BankPayment.jsp';
                form.submit();
            } else {
                // For COD, go directly to order confirmation
                form.action = 'PlaceOrder.jsp';
                form.submit();
            }
        }
    </script>

</body>
</html>
