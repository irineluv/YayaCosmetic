<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yc.model.Product" %>
<%
    Product product = (Product) request.getAttribute("product");

    if (product == null) {
        response.sendRedirect("ProductServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Product Detail</title>
    <style>
        /* Global Styles */
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

        /* Search Bar Area */
        .search-container {
            padding: 20px 5%;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 10px;
        }

        .search-wrapper {
            position: relative;
            width: 300px;
        }

        .search-bar {
            width: 100%;
            padding: 8px 35px 8px 15px;
            border: 1px solid #ccc;
            border-radius: 20px;
            outline: none;
        }

        .search-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }

        /* Product Detail Layout */
        .main-content {
            display: flex;
            padding: 40px 10%;
            gap: 60px;
            min-height: 60vh;
        }

        /* Left side: Images */
        .product-images {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
        }

        .product-images img {
            max-width: 100%;
            border-radius: 8px;
        }

        /* Right side: Information */
        .product-info {
            flex: 1.2;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .product-info h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #000;
        }

        .price {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 25px;
        }

        .description {
            line-height: 1.6;
            color: #444;
            margin-bottom: 40px;
            font-size: 1rem;
        }

        .add-to-cart-btn {
            background-color: #001a72; /* Deep Blue from your design */
            color: white;
            border: none;
            padding: 15px 0;
            width: 100%;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            transition: background 0.3s;
        }

        .add-to-cart-btn:hover {
            background-color: #000f45;
        }

        /* Footer Section */
        footer {
            background-color: #7b0d1e;
            color: white;
            padding: 40px 60px;
            display: flex;
            justify-content: space-between;
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
        
        #toast {
            position: fixed;
            top: 90px; /* BELOW NAVBAR */
            right: 30px;
            background-color: #7b0d1e; /* Brand Burgundy */
            color: #ffffff;
            padding: 14px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 12px 30px rgba(123, 13, 30, 0.35);
            opacity: 0;
            transform: translateY(-15px);
            transition: all 0.45s ease;
            z-index: 9999;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Show animation */
        #toast.show {
            opacity: 1;
            transform: translateY(0);
        }

        /* Optional icon styling */
        #toast span::before {
            content: "✔";
            background-color: rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            padding: 4px 7px;
            font-size: 12px;
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

        /* Responsive - stack on small screens */
        @media (max-width: 768px) {
            .hero, footer {
                flex-direction: column;
            }
            header {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
<%
    String cartMessage = (String) session.getAttribute("cartMessage");
    if (cartMessage != null) {
%>
    <div id="toast">
        <span><%= cartMessage %></span>
    </div>

    <script>
        const toast = document.getElementById("toast");
        toast.classList.add("show");

        setTimeout(() => {
            toast.classList.remove("show");
        }, 3000);
    </script>
<%
        session.removeAttribute("cartMessage");
    }
%>


    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">YAYA COSMETIC</div>
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
    
    <main class="main-content">
    <div class="product-images">
        <img src="<%= product.getImage() %>" alt="<%= product.getName() %>">
    </div>

    <div class="product-info">
        <h1><%= product.getName() %></h1>

        <div class="price">
            RM <%= String.format("%.2f", product.getPrice()) %>
        </div>

        <div class="description">
            <strong>COLOR:</strong> <%= product.getColors() != null ? product.getColors() : "Various" %>
        </div>

        <form action="CartServlet" method="POST">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
            <input type="hidden" name="quantity" value="1">
            <button type="submit" class="add-to-cart-btn">ADD TO CART</button>
        </form>
    </div>
</main>


    <footer>
        <div class="footer-col">
            <h4>ABOUT YAYA</h4>
            <a href="#">HISTORY</a>
            <a href="#">WORK IN YAYA</a>
        </div>
        <div class="footer-col">
            <h4>ADDRESS</h4>
            <p>BANGI AVENUE HEIGHT<br>DAMANSARA UTAMA<br>96029 DAMANSARA<br>SELANGOR</p>
        </div>
        <div class="footer-col">
            <h4>CONTACT</h4>
            <p>03-78279388 (OFFICE HOUR)</p>
            <p>yayacosmetic@hotline.com</p>
            <p>@yayacosmeticofficial</p>
        </div>
    </footer>

</body>
</html>
