<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ===== PURCHASE HISTORY PAGE LOGIC =====
    // This page displays user's past orders
    
    // Define Order class to hold order data
    // Later: move this to a separate model class (com.mycompany.yayacosmetic.model.Order)
    class Order {
        String id;
        String productName;
        String productImg;
        String price;
        String status;
        
        Order(String id, String name, String img, String price, String status) {
            this.id = id;
            this.productName = name;
            this.productImg = img;
            this.price = price;
            this.status = status;
        }
    }
    
    // Create sample order history (hardcoded for demonstration)
    // Later with database: fetch using OrderDAO.getOrdersByUserId(userId)
    List<Order> orders = new ArrayList<>();
    orders.add(new Order("1", "YAYA GOLD PALLATE", "pic product/3.png", "RM 100", "Parcel preparing for delivery"));
    orders.add(new Order("2", "YAYA GREEN PALLATE", "pic product/5.png", "RM 100", "Parcel has been delivered"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Purchase History</title>
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
        .history-container {
            padding: 40px 10%;
            min-height: 60vh;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 30px 0;
            color: #000;
        }

        .order-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .order-card {
            display: flex;
            align-items: center;
            background-color: #f9f6f2;
            padding: 25px;
            border-radius: 15px;
            gap: 30px;
        }

        .order-image {
            flex: 0 0 150px;
        }

        .order-image img {
            width: 100%;
            border-radius: 10px;
        }

        .order-info {
            flex: 1;
        }

        .order-info h3 {
            font-size: 22px;
            margin: 0 0 10px 0;
            font-weight: bold;
        }

        .order-info .price {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin: 10px 0;
        }

        .order-status {
            flex: 0 0 250px;
            text-align: right;
        }

        .status-badge {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
        }

        .status-preparing {
            background-color: #FFF3CD;
            color: #856404;
        }

        .status-delivered {
            background-color: #D4EDDA;
            color: #155724;
        }

        .empty-history {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-history h2 {
            font-size: 24px;
            margin-bottom: 15px;
        }

        .empty-history p {
            font-size: 16px;
            margin-bottom: 30px;
        }

        .btn-shop {
            display: inline-block;
            padding: 12px 30px;
            background-color: #001a72;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }

        .btn-shop:hover {
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
            .order-card {
                flex-direction: column;
                text-align: center;
            }
            
            .order-status {
                text-align: center;
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
                         <a href="Login.html">Login</a>
                         <a href="SignUp.html">Sign up</a>
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

    <div class="history-container">
        <h1 class="page-title">HISTORY</h1>

        <!-- Check if user has any orders -->
        <% if (orders.isEmpty()) { %>
            <!-- Show empty state if no orders found -->
            <div class="empty-history">
                <h2>No Purchase History</h2>
                <p>You haven't placed any orders yet.</p>
                <a href="Product.html" class="btn-shop">START SHOPPING</a>
            </div>
        <% } else { %>
            <!-- Display list of orders -->
            <div class="order-list">
                <% for (Order order : orders) { %>
                    <div class="order-card">
                        <div class="order-image">
                            <img src="<%= order.productImg %>" alt="<%= order.productName %>">
                        </div>
                        
                        <div class="order-info">
                            <h3><%= order.productName %></h3>
                            <div class="price"><%= order.price %></div>
                        </div>
                        
                        <!-- Display order status with appropriate color badge -->
                        <div class="order-status">
                            <% if (order.status.contains("delivered")) { %>
                                <!-- Green badge for delivered orders -->
                                <span class="status-badge status-delivered"><%= order.status %></span>
                            <% } else { %>
                                <!-- Yellow badge for pending/preparing orders -->
                                <span class="status-badge status-preparing"><%= order.status %></span>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
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
