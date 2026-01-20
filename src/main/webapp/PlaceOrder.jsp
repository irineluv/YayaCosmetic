<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * Cart is stored in session as Map<productId, quantity>.
     * This page reads the cart, builds an "orderItems" list for display,
     * calculates totals, then clears the cart.
     */
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    
    // orderItems stores: [id, name, img, desc, price, qty] as String[] for easy JSP rendering
    List<String[]> orderItems = new ArrayList<>();
    int subtotal = 0;
    int totalQty = 0;
    
    if (cartItems != null && !cartItems.isEmpty()) {
        for (Map.Entry<String, Integer> entry : cartItems.entrySet()) {
            String id = entry.getKey();
            int qty = entry.getValue();
            totalQty += qty;
            
            /*
             * Product data is hardcoded based on product ID.
             * In a real system, these would come from DB (product table).
             */
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
            
            // Totals are calculated using a fixed unit price of 100
            subtotal += price * qty;

            // Store this item for display rendering below
            orderItems.add(new String[]{id, name, img, desc, String.valueOf(price), String.valueOf(qty)});
        }
        
        /*
         * Cart is cleared after capturing order data.
         * This simulates "checkout completed".
         */
        cartItems.clear();
        session.setAttribute("cartItems", cartItems);
    }
    
    // Pricing summary (fixed values)
    int shipping = 0;
    int tax = 10;
    int total = subtotal + shipping + tax;
    
    /*
     * If cart is empty, the page still shows a default sample order.
     * NOTE: This is demo behavior and not a real checkout validation.
     */
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
        /* ... styles are presentation-only ... */
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

            <!-- Render every ordered item -->
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
                
                <!-- Summary uses totals calculated for the whole order -->
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
        <!-- Footer is static -->
    </footer>

</body>
</html>
