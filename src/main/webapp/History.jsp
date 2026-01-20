<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Get cart count for badge
    Map<String, Integer> cartItemsMap = (Map<String, Integer>) session.getAttribute("cartItems");
    int cartCount = 0;
    if (cartItemsMap != null) {
        for (Integer qty : cartItemsMap.values()) {
            cartCount += qty;
        }
    }

    // Define Order class with more details
    class Order {
        String id;
        String orderRef;
        String productName;
        String productImg;
        String price;
        String status;
        String date;
        String quantity;
        String paymentMethod;
        String shippingAddress;
        String phone;
        
        Order(String id, String orderRef, String name, String img, String price, String status, 
              String date, String quantity, String paymentMethod, String shippingAddress, String phone) {
            this.id = id;
            this.orderRef = orderRef;
            this.productName = name;
            this.productImg = img;
            this.price = price;
            this.status = status;
            this.date = date;
            this.quantity = quantity;
            this.paymentMethod = paymentMethod;
            this.shippingAddress = shippingAddress;
            this.phone = phone;
        }
    }
    
    // Sample order history with more details
    List<Order> orders = new ArrayList<>();
    orders.add(new Order("1", "YC1705123456789", "YAYA GOLD PALETTE", "pic product/3.png", "RM 100", 
               "Processing", "15/01/2026", "1", "Online Banking", 
               "18-9 Damansara Height, Kota Damansara 92083 Selangor", "012-3456789"));
    orders.add(new Order("2", "YC1705123456123", "YAYA GREEN PALETTE", "pic product/5.png", "RM 200", 
               "Delivered", "10/01/2026", "2", "Cash on Delivery", 
               "Lot 123, Jalan Bukit Bintang, 55100 Kuala Lumpur", "019-8765432"));
    orders.add(new Order("3", "YC1705123455555", "YAYA PINK PALETTE", "pic product/7.png", "RM 100", 
               "Shipped", "12/01/2026", "1", "Online Banking", 
               "Block A, Apartment Sri Muda, Shah Alam 40400 Selangor", "011-22334455"));
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
            background-color: #f9f6f2;
            padding: 25px;
            border-radius: 15px;
        }

        .order-main {
            display: flex;
            align-items: center;
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

        .order-ref {
            font-size: 12px;
            color: #666;
        }

        .order-actions {
            flex: 0 0 280px;
            text-align: right;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 15px;
        }

        .status-badge {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
        }

        .status-pending { background-color: #FFF3CD; color: #856404; }
        .status-processing { background-color: #CCE5FF; color: #004085; }
        .status-shipped { background-color: #E2D5F1; color: #4A2C7A; }
        .status-delivered { background-color: #D4EDDA; color: #155724; }
        .status-cancelled { background-color: #F8D7DA; color: #721C24; }

        .btn-details {
            padding: 10px 25px;
            background-color: #001a72;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
        }

        .btn-details:hover {
            background-color: #000f45;
        }

        /* Order Details Panel */
        .order-details {
            display: none;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
        }

        .order-details.active {
            display: block;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .detail-item {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
        }

        .detail-item .label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .detail-item .value {
            font-size: 15px;
            font-weight: 500;
            color: #333;
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
            .order-main {
                flex-direction: column;
                text-align: center;
            }
            
            .order-actions {
                align-items: center;
            }

            .details-grid {
                grid-template-columns: 1fr;
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
            <a href="Cart.jsp" class="cart-link">CART<% if (cartCount > 0) { %><span class="cart-badge"><%= cartCount > 99 ? "99+" : cartCount %></span><% } %></a>
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

    <div class="history-container">
        <h1 class="page-title">ORDER HISTORY</h1>

        <% if (orders.isEmpty()) { %>
            <div class="empty-history">
                <h2>No Purchase History</h2>
                <p>You haven't placed any orders yet.</p>
                <a href="Product.jsp" class="btn-shop">START SHOPPING</a>
            </div>
        <% } else { %>
            <div class="order-list">
                <% for (Order order : orders) { 
                    String statusClass = "status-processing";
                    if ("Delivered".equalsIgnoreCase(order.status)) statusClass = "status-delivered";
                    else if ("Shipped".equalsIgnoreCase(order.status)) statusClass = "status-shipped";
                    else if ("Pending".equalsIgnoreCase(order.status)) statusClass = "status-pending";
                    else if ("Cancelled".equalsIgnoreCase(order.status)) statusClass = "status-cancelled";
                %>
                    <div class="order-card">
                        <div class="order-main">
                            <div class="order-image">
                                <img src="<%= order.productImg %>" alt="<%= order.productName %>">
                            </div>
                            
                            <div class="order-info">
                                <h3><%= order.productName %></h3>
                                <div class="order-ref">Order: <%= order.orderRef %></div>
                                <div class="price"><%= order.price %></div>
                            </div>
                            
                            <div class="order-actions">
                                <span class="status-badge <%= statusClass %>"><%= order.status %></span>
                                <button class="btn-details" onclick="toggleDetails('<%= order.id %>')">VIEW DETAILS</button>
                            </div>
                        </div>

                        <!-- Expandable Details Section -->
                        <div class="order-details" id="details-<%= order.id %>">
                            <div class="details-grid">
                                <div class="detail-item">
                                    <div class="label">Order Reference</div>
                                    <div class="value"><%= order.orderRef %></div>
                                </div>
                                <div class="detail-item">
                                    <div class="label">Order Date</div>
                                    <div class="value"><%= order.date %></div>
                                </div>
                                <div class="detail-item">
                                    <div class="label">Quantity</div>
                                    <div class="value"><%= order.quantity %> item(s)</div>
                                </div>
                                <div class="detail-item">
                                    <div class="label">Total Amount</div>
                                    <div class="value"><%= order.price %></div>
                                </div>
                                <div class="detail-item">
                                    <div class="label">Payment Method</div>
                                    <div class="value"><%= order.paymentMethod %></div>
                                </div>
                                <div class="detail-item">
                                    <div class="label">Order Status</div>
                                    <div class="value"><%= order.status %></div>
                                </div>
                                <div class="detail-item" style="grid-column: span 2;">
                                    <div class="label">Shipping Address</div>
                                    <div class="value"><%= order.shippingAddress %></div>
                                </div>
                                <div class="detail-item">
                                    <div class="label">Contact Number</div>
                                    <div class="value"><%= order.phone %></div>
                                </div>
                            </div>
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

    <script>
        function toggleDetails(orderId) {
            var details = document.getElementById('details-' + orderId);
            var btn = event.target;
            
            if (details.classList.contains('active')) {
                details.classList.remove('active');
                btn.textContent = 'VIEW DETAILS';
            } else {
                details.classList.add('active');
                btn.textContent = 'HIDE DETAILS';
            }
        }
    </script>

</body>
</html>
