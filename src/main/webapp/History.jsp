<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * Cart badge count:
     * cartItems is stored in session as Map<productId, quantity>.
     * We sum quantities to show total items count in badge.
     */
    Map<String, Integer> cartItemsMap = (Map<String, Integer>) session.getAttribute("cartItems");
    int cartCount = 0;
    if (cartItemsMap != null) {
        for (Integer qty : cartItemsMap.values()) {
            cartCount += qty;
        }
    }

    /*
     * Local inner class used only for rendering order history in this JSP.
     * NOTE: This is not persisted (no DB) – it is demo/sample data.
     */
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
    
    /*
     * Sample order history list.
     * IMPORTANT: This is hardcoded demo data.
     * A real system would load orders from DB based on logged-in user.
     */
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
        /* ... (CSS is presentation-only) ... */
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

            <!-- Cart link includes a badge when cartCount > 0 -->
            <a href="Cart.jsp" class="cart-link">CART
                <% if (cartCount > 0) { %>
                    <span class="cart-badge"><%= cartCount > 99 ? "99+" : cartCount %></span>
                <% } %>
            </a>

            <a href="History.jsp">HISTORY</a>

            <!-- Profile dropdown behavior depends on login state (session userEmail) -->
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

        <!-- Empty state -->
        <% if (orders.isEmpty()) { %>
            <div class="empty-history">
                <h2>No Purchase History</h2>
                <p>You haven't placed any orders yet.</p>
                <a href="Product.jsp" class="btn-shop">START SHOPPING</a>
            </div>
        <% } else { %>

            <div class="order-list">
                <% for (Order order : orders) { 
                    /*
                     * Map order.status -> CSS badge class for color styling.
                     * Default is "processing" unless it matches other known statuses.
                     */
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

                                <!-- Button toggles details section for this order id -->
                                <button class="btn-details" onclick="toggleDetails('<%= order.id %>')">VIEW DETAILS</button>
                            </div>
                        </div>

                        <!-- Expandable details (hidden by default) -->
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

                                <!-- Shipping address spans two columns -->
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
        <!-- Footer is static content -->
    </footer>

    <script>
        /*
         * Toggle details panel for an order card.
         * - Adds/removes "active" class on the details div.
         * - Switches button text between VIEW DETAILS / HIDE DETAILS.
         */
        function toggleDetails(orderId) {
            var details = document.getElementById('details-' + orderId);

            // NOTE: relies on global "event" (works in many browsers but it's not great practice)
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
