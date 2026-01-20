<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * Read cart from session.
     * If empty, redirect back (prevents direct access to checkout without items).
     */
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    if (cartItems == null || cartItems.isEmpty()) {
        response.sendRedirect("Cart.jsp");
        return;
    }
    
    /*
     * Selected items come from Cart.jsp (POST selectedItems).
     * Fallback: if nothing passed, select all items with qty > 0.
     *
     * NOTE: This is good defensive logic because your Cart.jsp sometimes uses hidden input.
     */
    String[] selectedIds = request.getParameterValues("selectedItems");
    Set<String> selectedSet = new HashSet<>();
    
    if (selectedIds != null && selectedIds.length > 0) {
        for (String id : selectedIds) {
            // Only accept IDs that exist in cart AND have qty > 0
            if (cartItems.containsKey(id) && cartItems.get(id) > 0) {
                selectedSet.add(id);
            }
        }
    } else {
        // Fallback: select all items with qty > 0
        for (Map.Entry<String, Integer> entry : cartItems.entrySet()) {
            if (entry.getValue() > 0) {
                selectedSet.add(entry.getKey());
            }
        }
    }
    
    // If no valid items selected (or all were qty 0), go back to cart
    if (selectedSet.isEmpty()) {
        response.sendRedirect("Cart.jsp");
        return;
    }
    
    /*
     * Store selected items for PlaceOrder.jsp.
     * PlaceOrder must use this session data (NOT trust URL amount).
     */
    session.setAttribute("checkoutItems", selectedSet);
    
    /*
     * Compute totals server-side for selected items only.
     * NOTE: Still hardcoded RM100 per item.
     */
    int subtotal = 0;
    int totalItems = 0;
    for (String id : selectedSet) {
        int qty = cartItems.get(id);
        totalItems += qty;
        subtotal += qty * 100;
    }

    // Current pricing rules
    int shipping = 0;
    int tax = 10; // fixed tax, not based on amount
    int total = subtotal + shipping + tax;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Checkout</title>
    <style>
        /* Base layout */
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

        /* Profile dropdown */
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
        
        /* Checkout Layout */
        .checkout-container {
            padding: 40px 10%;
            display: flex;
            gap: 40px;
        }
        
        .checkout-left {
            flex: 1;
        }
        
        .checkout-right {
            flex: 0 0 300px;
        }
        
        .order-summary-box {
            background-color: #f9f6f2;
            padding: 25px;
            border-radius: 10px;
        }
        
        h1 {
            font-size: 28px;
            margin-bottom: 30px;
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #7b0d1e;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        /* Summary rows */
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin: 12px 0;
            font-size: 14px;
        }
        
        .summary-row.total {
            font-size: 16px;
            font-weight: bold;
            padding-top: 15px;
            border-top: 1px solid #ccc;
            margin-top: 15px;
        }
        
        /* Section Box */
        .section-box {
            background-color: #f9f6f2;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .section-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        /* Address Input */
        .address-input {
            width: 100%;
            min-height: 100px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            font-family: Arial, sans-serif;
            resize: vertical;
            box-sizing: border-box;
        }
        
        .address-input:focus {
            outline: none;
            border-color: #7b0d1e;
        }
        
        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .payment-option {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }
        
        .payment-option input[type="radio"] {
            width: 18px;
            height: 18px;
            accent-color: #7b0d1e;
        }
        
        .payment-label {
            font-size: 14px;
        }
        
        /* Place Order Button */
        .place-order-btn {
            width: 100%;
            padding: 12px;
            background-color: #001a72;
            color: white;
            border: none;
            border-radius: 25px;
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
            margin-top: 40px;
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
    </style>
</head>
<body>

    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">YAYA COSMETIC</div>
        </div>
        <nav>
            <a href="HomePage.jsp">Home</a>
            <a href="Product.jsp">Product</a>
            <a href="Cart.jsp">Cart</a>
            <a href="History.jsp">History</a>
            <div class="dropdown">
                <% 
                    // This only affects the dropdown label; it does NOT protect checkout access
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
        <div class="checkout-left">
            <a href="Cart.jsp" class="back-link">← Back to Cart</a>
            <h1>CHECKOUT</h1>
            
            <!-- NOTE: No method/action set. JS handles “submit” and redirects by payment option. -->
            <form id="checkoutForm">
                <div class="section-box">
                    <div class="section-title">1. Address (ENTER FULL ADDRESS)</div>
                    <textarea name="address" class="address-input" placeholder="ENTER FULL ADDRESS" required></textarea>
                </div>
                
                <div class="section-box">
                    <div class="section-title">2. Payment Method</div>
                    <div class="payment-options">
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="card" checked>
                            <span class="payment-label">Online Payment</span>
                        </label>
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="cod">
                            <span class="payment-label">Cash On Delivery</span>
                        </label>
                    </div>
                </div>
                
                <!-- Amount is calculated server-side but later passed via URL to BankPayment.jsp -->
                <input type="hidden" name="amount" value="<%= total %>">
            </form>
        </div>
        
        <div class="checkout-right">
            <div class="order-summary-box">
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>RM <%= subtotal %></span>
                </div>
                <div class="summary-row">
                    <span>Shipping</span>
                    <span>FREE</span>
                </div>
                <div class="summary-row">
                    <span>Estimated Tax</span>
                    <span>RM <%= tax %></span>
                </div>
                <div class="summary-row total">
                    <span>ESTIMATED TOTAL</span>
                    <span>RM <%= total %></span>
                </div>
                
                <!-- Triggers submit handler below -->
                <button type="submit" form="checkoutForm" class="place-order-btn">PLACE ORDER</button>
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

    <script>
        /*
         * Submit handler decides route:
         * - COD: direct to PlaceOrder.jsp?method=cod
         * - Online Payment: go to BankPayment.jsp?amount=...
         *
         * WARNING: address is NOT stored anywhere. After redirect you lose it unless you save to session.
         */
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            var amount = document.querySelector('input[name="amount"]').value;
            
            if (paymentMethod === 'cod') {
                // COD - go straight to PlaceOrder
                window.location.href = 'PlaceOrder.jsp?method=cod';
            } else {
                // Card/Bank - go to BankPayment
                window.location.href = 'BankPayment.jsp?amount=' + amount;
            }
        });
    </script>

</body>
</html>
