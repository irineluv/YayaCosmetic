<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.CartItem, java.math.BigDecimal" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    BigDecimal cartTotal = (BigDecimal) request.getAttribute("cartTotal");
    
    if (cartItems == null) {
        response.sendRedirect("CartServlet");
        return;
    }
    
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Shopping Cart</title>
    <style>
        body {
            margin: 0;
            font-family: 'Serif', 'Arial', sans-serif;
            background-color: #f9f9f9;
            
        }

        /* Header / Navbar */
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

        .cart-section {
            padding: 40px 60px;
            min-height: 60vh;
        }

        .section-title {
            font-size: 32px;
            font-weight: bold;
            margin: 0 0 30px 0;
        }

        .cart-container {
            display: flex;
            gap: 40px;
        }

        .cart-items {
            flex: 2;
        }

        .cart-summary {
            flex: 1;
            background-color: #f5ebe0;
            padding: 30px;
            border-radius: 15px;
            height: fit-content;
        }

        .cart-item {
            display: flex;
            gap: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .cart-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }

        .item-details {
            flex: 1;
        }

        .item-details h3 {
            margin: 0 0 5px 0;
            font-size: 16px;
        }

        .item-details .price {
            color: #7b0d1e;
            font-weight: bold;
            font-size: 16px;
        }

        .item-actions {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 10px;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-control button {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: #fff;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
        }

        .quantity-control span {
            font-weight: bold;
            min-width: 30px;
            text-align: center;
        }

        .btn-remove {
            color: #dc3545;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 13px;
        }

        .item-subtotal {
            text-align: right;
            font-weight: bold;
            font-size: 18px;
            color: #333;
        }

        .summary-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #ddd;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: bold;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid #ddd;
        }

        .btn-checkout {
            display: block;
            width: 100%;
            padding: 15px;
            background-color: #7b0d1e;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
        }

        .btn-checkout:hover {
            background-color: #5a0a15;
        }

        .btn-continue {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #7b0d1e;
            text-decoration: none;
            font-size: 14px;
        }

        .empty-cart {
            text-align: center;
            padding: 60px;
        }

        .empty-cart h3 {
            color: #666;
        }

        .empty-cart a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background-color: #7b0d1e;
            color: white;
            text-decoration: none;
            border-radius: 5px;
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
        .cart-link {
            position: relative;
            display: inline-block;
            padding-right: 12px;
        }
        /* Floating badge */
        .cart-badge {
            position: absolute;
            top: -6px;
            right: -8px;
            background-color: #FFC107; /* Luxury Yellow */
            color: #000;
            font-size: 11px;
            font-weight: bold;
            min-width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.25);
            animation: popIn 0.3s ease;
        }

        /* Cute pop animation */
        @keyframes popIn {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        @media (max-width: 800px) {
            .cart-container {
                flex-direction: column;
            }
        }
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
            <a href="ProductServlet">Product</a>
            <a href="CartServlet" class="cart-link">
                Cart
                <%
                    Integer cartCount = (Integer) session.getAttribute("cartCount");
                    if (cartCount != null && cartCount > 0) {
                %>
                    <span class="cart-badge"><%= cartCount %></span>
                <% } %>
            </a>
            <a href="OrderHistoryServlet">History</a>
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
                         <a href="ProfileServlet">View Profile</a>
                         <a href="LogoutServlet">Logout</a>
                     </div>
                 <% 
                     } 
                 %>
            </div>
        </nav>
    </header>

    <section class="cart-section">
        <h2 class="section-title">SHOPPING CART</h2>

        <% if (cartItems.isEmpty()) { %>
            <div class="empty-cart">
                <h3>Your cart is empty</h3>
                <p>Looks like you haven't added any products yet.</p>
                <a href="ProductListServlet">Continue Shopping</a>
            </div>
        <% } else { %>
            <div class="cart-container">
                <div class="cart-items">
                    <% for (CartItem item : cartItems) { %>
                        <div class="cart-item">
                            <img src="<%= item.getProductImage() != null ? item.getProductImage() : "pic product/3.png" %>" 
                                 alt="<%= item.getProductName() %>">
                            <div class="item-details">
                                <h3><%= item.getProductName() %></h3>
                                <div class="price">RM <%= item.getProductPrice() %></div>
                                <div class="item-actions">
                                    <div class="quantity-control">
                                        <form action="CartServlet" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                            <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                            <button type="submit">-</button>
                                        </form>
                                        <span><%= item.getQuantity() %></span>
                                        <form action="CartServlet" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                            <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                            <button type="submit">+</button>
                                        </form>
                                    </div>
                                    <form action="CartServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                        <button type="submit" class="btn-remove">Remove</button>
                                    </form>
                                </div>
                            </div>
                            <div class="item-subtotal">
                                RM <%= item.getSubtotal() %>
                            </div>
                        </div>
                    <% } %>
                </div>

                <div class="cart-summary">
                    <div class="summary-title">Order Summary</div>
                    <div class="summary-row">
                        <span>Items (<%= cartCount %>)</span>
                        <span>RM <%= cartTotal %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span>FREE</span>
                    </div>
                    <div class="summary-total">
                        <span>Total</span>
                        <span>RM <%= cartTotal %></span>
                    </div>
                    <a href="CheckoutServlet" class="btn-checkout">Proceed to Checkout</a>
                    <a href="ProductListServlet" class="btn-continue">Continue Shopping</a>
                </div>
            </div>
        <% } %>
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
