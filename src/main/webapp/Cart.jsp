<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Cart stores product ID -> quantity mapping
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    if (cartItems == null) {
        cartItems = new LinkedHashMap<>();
        session.setAttribute("cartItems", cartItems);
    }

    String action = request.getParameter("action");
    String productId = request.getParameter("id");
    String quantityStr = request.getParameter("quantity");

    // Track if item was just added (for popup)
    boolean itemJustAdded = false;
    String addedProductName = "";
    
    // Handle add action (from ProductDetail.jsp)
    if ("add".equals(action) && productId != null) {
        int qty = 1;
        if (quantityStr != null) {
            try { qty = Integer.parseInt(quantityStr); } catch (NumberFormatException e) { qty = 1; }
        }
        if (cartItems.containsKey(productId)) {
            cartItems.put(productId, cartItems.get(productId) + qty);
        } else {
            cartItems.put(productId, qty);
        }
        session.setAttribute("cartItems", cartItems);
        
        // Set popup info
        itemJustAdded = true;
        if ("1".equals(productId)) addedProductName = "YAYA GOLD PALETTE";
        else if ("2".equals(productId)) addedProductName = "YAYA BLUE PALETTE";
        else if ("3".equals(productId)) addedProductName = "YAYA GREEN PALETTE";
        else if ("4".equals(productId)) addedProductName = "YAYA BLACK PALETTE";
        else if ("5".equals(productId)) addedProductName = "YAYA PINK PALETTE";
        else if ("6".equals(productId)) addedProductName = "YAYA ORANGE PALETTE";
        else if ("7".equals(productId)) addedProductName = "YAYA PURPLE PALETTE";
        else if ("8".equals(productId)) addedProductName = "YAYA RED PALETTE";
        else addedProductName = "Item";
    }
    
    // Handle update quantity action (minimum is 1)
    if ("update".equals(action) && productId != null && quantityStr != null) {
        try {
            int newQty = Integer.parseInt(quantityStr);
            if (newQty >= 1 && newQty <= 99) {
                cartItems.put(productId, newQty);
                session.setAttribute("cartItems", cartItems);
            }
        } catch (NumberFormatException e) {
            // Invalid quantity, ignore
        }
    }
    
    // Handle remove action (can remove anytime)
    if ("remove".equals(action) && productId != null) {
        if (cartItems.containsKey(productId)) {
            cartItems.remove(productId);
            session.setAttribute("cartItems", cartItems);
        }
    }

    // Calculate totals
    int totalItems = 0;
    int totalPrice = 0;
    for (Integer qty : cartItems.values()) {
        totalItems += qty;
        totalPrice += qty * 100;
    }
    
    int cartSize = cartItems.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Yaya Cosmetic - Cart</title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
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
        
        /* Cart badge */
        .cart-link {
            position: relative;
        }
        
        .cart-badge {
            position: absolute;
            top: -8px;
            right: -12px;
            background-color: #ffd700;
            color: #7b0d1e;
            font-size: 10px;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 50%;
            min-width: 8px;
            text-align: center;
        }
        
        /* Cart Container */
        .cart-container {
            padding: 40px 10%;
        }
        
        .cart-header {
            margin-bottom: 30px;
        }
        
        /* Cart Item */
        .cart-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 25px;
            background-color: #f9f6f2;
            border-radius: 15px;
            margin-bottom: 20px;
        }
        
        .cart-item img {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 10px;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-details h2 {
            font-size: 22px;
            margin: 0 0 10px 0;
        }
        
        .item-details p {
            color: #666;
            margin: 0 0 10px 0;
            font-size: 14px;
        }
        
        .item-price {
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
        }
        
        .item-subtotal {
            font-size: 18px;
            font-weight: bold;
            color: #7b0d1e;
        }
        
        /* Quantity Controls */
        .quantity-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }
        
        .quantity-label {
            font-size: 14px;
            color: #666;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .qty-btn {
            width: 35px;
            height: 35px;
            border: none;
            background-color: #001a72;
            color: white;
            font-size: 18px;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .qty-btn:hover:not(:disabled) {
            background-color: #000f45;
        }
        
        .qty-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        
        .qty-input {
            width: 50px;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            border: none;
            background: transparent;
        }
        
        .qty-input:focus {
            outline: none;
        }
        
        /* Remove button */
        .btn-remove {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            background-color: #ffebee;
            color: #dc3545;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-remove:hover {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-remove svg {
            width: 20px;
            height: 20px;
        }
        
        /* Cart Summary */
        .cart-summary {
            background-color: #f9f6f2;
            padding: 25px;
            border-radius: 15px;
            margin-top: 30px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 16px;
        }
        
        .summary-row.total {
            font-size: 20px;
            font-weight: bold;
            border-top: 2px solid #ddd;
            padding-top: 15px;
            margin-top: 15px;
        }
        
        .checkout-btn {
            background-color: #001a72; 
            padding: 15px 50px; 
            border-radius: 8px; 
            color: white; 
            border: none; 
            font-weight: bold; 
            font-size: 16px;
            cursor: pointer;
            text-transform: uppercase;
        }
        
        .checkout-btn:hover:not(:disabled) {
            background-color: #000f45;
        }
        
        .checkout-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        
        .checkout-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
        
        .select-all-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .select-all-section label {
            font-size: 14px;
            cursor: pointer;
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
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-cart h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .empty-cart p {
            color: #666;
            margin-bottom: 30px;
        }
        
        .shop-btn {
            display: inline-block;
            padding: 12px 30px;
            background-color: #001a72;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }
        
        .shop-btn:hover {
            background-color: #000f45;
        }
        
        .selection-note {
            color: #666;
            font-size: 13px;
            font-style: italic;
        }
        
        /* Popup Styles */
        .popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            opacity: 1;
            transition: opacity 0.3s ease;
        }
        
        .popup-overlay.hidden {
            opacity: 0;
            pointer-events: none;
        }
        
        .popup-box {
            background: white;
            padding: 30px 40px;
            border-radius: 15px;
            text-align: center;
            max-width: 400px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            transform: scale(1);
            transition: transform 0.3s ease;
        }
        
        .popup-overlay.hidden .popup-box {
            transform: scale(0.8);
        }
        
        .popup-icon {
            font-size: 50px;
            margin-bottom: 15px;
        }
        
        .popup-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .popup-message {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }
        
        .popup-product {
            font-weight: bold;
            color: #7b0d1e;
        }
        
        .popup-close-btn {
            padding: 10px 30px;
            background-color: #7b0d1e;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 14px;
            cursor: pointer;
        }
        
        .popup-close-btn:hover {
            background-color: #5a0a15;
        }
    </style>
</head>
<body>

    <% if (itemJustAdded) { %>
    <!-- Added to Cart Popup -->
    <div class="popup-overlay" id="addedPopup">
        <div class="popup-box">
            <div class="popup-icon">&#10003;</div>
            <div class="popup-title">Added to Cart!</div>
            <div class="popup-message">
                <span class="popup-product"><%= addedProductName %></span> has been added to your cart.
            </div>
            <button class="popup-close-btn" onclick="closePopup()">OK</button>
        </div>
    </div>
    <% } %>

    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">YAYA COSMETIC</div>
        </div>
        <nav>
            <a href="HomePage.jsp">Home</a>
            <a href="Product.jsp">Product</a>
            <a href="Cart.jsp" class="cart-link">Cart<% if (totalItems > 0) { %><span class="cart-badge"><%= totalItems > 99 ? "99+" : totalItems %></span><% } %></a>
            <a href="History.jsp">History</a>
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
            
    <div class="cart-container">
        <div class="cart-header">
            <h1 style="font-size: 36px; margin: 0;">CART (<%= totalItems %> items)</h1>
        </div>

        <% 
        if (cartItems.isEmpty()) { 
        %>
            <div class="empty-cart">
                <h2>Your cart is empty</h2>
                <p>Looks like you haven't added any items to your cart yet.</p>
                <a href="Product.jsp" class="shop-btn">START SHOPPING</a>
            </div>
        <% 
        } else {
        %>
            <form id="checkoutForm" action="Checkout.jsp" method="POST">
            <%
            for (Map.Entry<String, Integer> entry : cartItems.entrySet()) {
                String id = entry.getKey();
                int quantity = entry.getValue();
                
                // Product data lookup
                String name = "YAYA GOLD PALETTE";
                String img = "pic product/3.png";
                String desc = "Contain 12 Shining Color";
                int unitPrice = 100;
                
                if ("1".equals(id)) { name = "YAYA GOLD PALETTE"; img = "pic product/3.png"; desc = "Contain 12 shining color"; }
                else if ("2".equals(id)) { name = "YAYA BLUE PALETTE"; img = "pic product/4.png"; desc = "Contain 12 blue shade color"; }
                else if ("3".equals(id)) { name = "YAYA GREEN PALETTE"; img = "pic product/5.png"; desc = "Contain 12 earthy tone color"; }
                else if ("4".equals(id)) { name = "YAYA BLACK PALETTE"; img = "pic product/6.png"; desc = "Contain 12 dark shade color"; }
                else if ("5".equals(id)) { name = "YAYA PINK PALETTE"; img = "pic product/7.png"; desc = "Contain 12 pink shade color"; }
                else if ("6".equals(id)) { name = "YAYA ORANGE PALETTE"; img = "pic product/8.png"; desc = "Contain 12 fruity shade color"; }
                else if ("7".equals(id)) { name = "YAYA PURPLE PALETTE"; img = "pic product/9.png"; desc = "Contain 12 purple shade color"; }
                else if ("8".equals(id)) { name = "YAYA RED PALETTE"; img = "pic product/10.png"; desc = "Contain 12 red shade color"; }
                
                int subtotal = unitPrice * quantity;
                boolean isZeroQty = (quantity == 0);
            %>
            <div class="cart-item" data-id="<%= id %>" data-price="<%= unitPrice %>" data-qty="<%= quantity %>">
                <% if (cartSize > 1) { %>
                    <input type="checkbox" class="item-checkbox" name="selectedItems" value="<%= id %>" <%= !isZeroQty ? "checked" : "" %> onchange="updateSelection()" <%= isZeroQty ? "disabled" : "" %>>
                <% } else { %>
                    <input type="hidden" name="selectedItems" value="<%= id %>">
                <% } %>
                <img src="<%= img %>" alt="<%= name %>">
                <div class="item-details">
                    <h2><%= name %></h2>
                    <p><%= desc %></p>
                    <div class="item-price">RM <%= unitPrice %> each</div>
                    <div class="item-subtotal" id="subtotal-<%= id %>">Subtotal: RM <%= subtotal %></div>
                </div>
                <div class="quantity-section">
                    <span class="quantity-label">Quantity</span>
                    <div class="quantity-controls">
                        <button type="button" class="qty-btn" onclick="updateQuantity('<%= id %>', <%= quantity - 1 %>)" <%= quantity <= 1 ? "disabled" : "" %>>-</button>
                        <input type="text" class="qty-input" id="qty-<%= id %>" value="<%= quantity %>" readonly>
                        <button type="button" class="qty-btn" onclick="updateQuantity('<%= id %>', <%= quantity + 1 %>)" <%= quantity >= 99 ? "disabled" : "" %>>+</button>
                    </div>
                    <button type="button" class="btn-remove" onclick="removeItem('<%= id %>')" title="Remove item">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M3 6h18v2H3V6zm2 3h14l-1.5 13h-11L5 9zm4 2v8h2v-8H9zm4 0v8h2v-8h-2zM9 4V2h6v2h5v2H4V4h5z"/>
                        </svg>
                    </button>
                </div>
            </div>
            <% 
            }
            %>
            
            <!-- Cart Summary -->
            <div class="cart-summary">
                <div class="summary-row">
                    <span>Selected Items (<span id="selectedCount"><%= totalItems %></span>)</span>
                    <span>RM <span id="selectedPrice"><%= totalPrice %></span></span>
                </div>
                <div class="summary-row">
                    <span>Shipping</span>
                    <span>FREE</span>
                </div>
                <div class="summary-row">
                    <span>Tax</span>
                    <span>RM <span id="taxAmount">10</span></span>
                </div>
                <div class="summary-row total">
                    <span>TOTAL</span>
                    <span>RM <span id="totalPrice"><%= totalPrice + 10 %></span></span>
                </div>
            </div>
            
            <div class="checkout-section">
                <% if (cartSize > 1) { %>
                <div class="select-all-section">
                    <input type="checkbox" id="selectAll" checked onchange="toggleSelectAll()">
                    <label for="selectAll">Select All</label>
                    <span class="selection-note">(Select items to checkout)</span>
                </div>
                <% } else { %>
                <div></div>
                <% } %>
                <button type="submit" class="checkout-btn" id="checkoutBtn">PROCEED TO CHECKOUT</button>
            </div>
            </form>
        <% } %>
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
        function updateQuantity(productId, newQty) {
            if (newQty >= 1 && newQty <= 99) {
                window.location.href = 'Cart.jsp?action=update&id=' + productId + '&quantity=' + newQty;
            }
        }
        
        function removeItem(productId) {
            window.location.href = 'Cart.jsp?action=remove&id=' + productId;
        }
        
        function updateSelection() {
            var checkboxes = document.querySelectorAll('.item-checkbox');
            var selectedCount = 0;
            var selectedPrice = 0;
            
            // If only one item, no checkboxes, use hidden input
            if (checkboxes.length === 0) {
                var items = document.querySelectorAll('.cart-item');
                items.forEach(function(item) {
                    var qty = parseInt(item.dataset.qty);
                    var price = parseInt(item.dataset.price);
                    if (qty > 0) {
                        selectedCount += qty;
                        selectedPrice += qty * price;
                    }
                });
            } else {
                checkboxes.forEach(function(cb) {
                    if (cb.checked && !cb.disabled) {
                        var item = cb.closest('.cart-item');
                        var qty = parseInt(item.dataset.qty);
                        var price = parseInt(item.dataset.price);
                        if (qty > 0) {
                            selectedCount += qty;
                            selectedPrice += qty * price;
                        }
                    }
                });
            }
            
            var tax = 10;
            var total = selectedPrice + tax;
            
            document.getElementById('selectedCount').textContent = selectedCount;
            document.getElementById('selectedPrice').textContent = selectedPrice;
            document.getElementById('totalPrice').textContent = total;
            
            // Update select all checkbox
            var selectAll = document.getElementById('selectAll');
            if (selectAll) {
                var enabledCheckboxes = document.querySelectorAll('.item-checkbox:not(:disabled)');
                var checkedCheckboxes = document.querySelectorAll('.item-checkbox:checked:not(:disabled)');
                selectAll.checked = (enabledCheckboxes.length > 0 && enabledCheckboxes.length === checkedCheckboxes.length);
            }
            
            // Disable checkout if nothing selected or total is 0
            var checkoutBtn = document.getElementById('checkoutBtn');
            if (checkoutBtn) {
                checkoutBtn.disabled = (selectedCount === 0 || selectedPrice === 0);
            }
        }
        
        function toggleSelectAll() {
            var selectAll = document.getElementById('selectAll');
            var checkboxes = document.querySelectorAll('.item-checkbox:not(:disabled)');
            checkboxes.forEach(function(cb) {
                cb.checked = selectAll.checked;
            });
            updateSelection();
        }
        
        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateSelection();
            
            // Auto-close popup after 3 seconds
            var popup = document.getElementById('addedPopup');
            if (popup) {
                setTimeout(function() {
                    closePopup();
                }, 3000);
            }
        });
        
        // Close popup function
        function closePopup() {
            var popup = document.getElementById('addedPopup');
            if (popup) {
                popup.classList.add('hidden');
                setTimeout(function() {
                    popup.remove();
                }, 300);
            }
        }
    </script>

</body>
</html>
```
