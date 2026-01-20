<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // =========================================================
    // CART SESSION MODEL (Prototype)
    // - Cart is stored in session as Map<productId, quantity>
    // - LinkedHashMap keeps insertion order stable (UI doesn't jump around)
    // =========================================================
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    if (cartItems == null) {
        cartItems = new LinkedHashMap<>();
        session.setAttribute("cartItems", cartItems);
    }

    // =========================================================
    // REQUEST PARAMETERS
    // - action controls server-side cart operations (add/update/remove)
    // - id identifies which product is being changed
    // - quantity is used for add/update
    // =========================================================
    String action = request.getParameter("action");
    String productId = request.getParameter("id");
    String quantityStr = request.getParameter("quantity");

    // =========================================================
    // UI FEEDBACK (Popup)
    // - itemJustAdded controls whether popup HTML should render
    // - addedProductName is displayed inside the popup
    // =========================================================
    boolean itemJustAdded = false;
    String addedProductName = "";
    
    // =========================================================
    // ACTION: ADD TO CART
    // - Triggered when ProductDetail.jsp redirects here with action=add
    // - Default quantity is 1 if missing/invalid
    // - If product exists, we increment quantity instead of overwriting
    // =========================================================
    if ("add".equals(action) && productId != null) {
        int qty = 1; // safe default
        if (quantityStr != null) {
            try { 
                qty = Integer.parseInt(quantityStr); 
            } catch (NumberFormatException e) { 
                // If quantity param is bad, do not break cart; use default
                qty = 1; 
            }
        }

        // Merge with existing quantity if item already in cart
        if (cartItems.containsKey(productId)) {
            cartItems.put(productId, cartItems.get(productId) + qty);
        } else {
            cartItems.put(productId, qty);
        }
        session.setAttribute("cartItems", cartItems);
        
        // Enable popup rendering
        itemJustAdded = true;

        // Prototype product-name lookup (hardcoded mapping)
        // NOTE: In real systems, product name comes from DB, not if/else chain
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
    
    // =========================================================
    // ACTION: UPDATE QUANTITY
    // - Accept range: 0..99
    // - Quantity 0 is allowed but item is NOT auto-removed
    //   (removal is only done by explicit action=remove)
    // =========================================================
    if ("update".equals(action) && productId != null && quantityStr != null) {
        try {
            int newQty = Integer.parseInt(quantityStr);
            if (newQty >= 0 && newQty <= 99) {
                cartItems.put(productId, newQty);
                session.setAttribute("cartItems", cartItems);
            }
        } catch (NumberFormatException e) {
            // Invalid quantity input -> ignore to protect cart state
        }
    }
    
    // =========================================================
    // ACTION: REMOVE ITEM
    // - This design only removes an item if its quantity is already 0
    // - So the "REMOVE" button becomes active only at qty = 0
    // =========================================================
    if ("remove".equals(action) && productId != null) {
        if (cartItems.containsKey(productId) && cartItems.get(productId) == 0) {
            cartItems.remove(productId);
            session.setAttribute("cartItems", cartItems);
        }
    }

    // =========================================================
    // TOTALS CALCULATION (Prototype)
    // - totalItems counts total quantities (badge + header)
    // - totalPrice is calculated using fixed RM100 per item here
    // NOTE: UI later uses unitPrice per item; for real correctness, totals
    // should be computed using each product's actual unitPrice.
    // =========================================================
    int totalItems = 0;
    int totalPrice = 0;
    for (Integer qty : cartItems.values()) {
        totalItems += qty;
        totalPrice += qty * 100; // prototype assumption: all items RM100
    }
    
    // cartSize = number of distinct product IDs (used for checkbox UI logic)
    int cartSize = cartItems.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Yaya Cosmetic - Cart</title>
    <style>
        /* =========================================================
           GLOBAL PAGE STYLES
           - Simple layout: header + main cart container + footer
           ========================================================= */
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        /* =========================================================
           HEADER + NAVIGATION
           - Reused brand header styling across pages
           ========================================================= */
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

        /* =========================================================
           PROFILE DROPDOWN
           - Shows login/signup if user not logged in
           - Shows "Hi, email" + logout if user logged in
           ========================================================= */
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
        
        .dropdown:hover .dropbtn {
            color: #ccc;
        }
        
        /* =========================================================
           CART BADGE
           - Small circle showing total cart quantity
           ========================================================= */
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
        
        /* =========================================================
           CART PAGE LAYOUT
           ========================================================= */
        .cart-container { 
            padding: 40px 10%; 
        }
        
        .cart-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 20px; 
        }
        
        /* =========================================================
           CART ITEM CARD
           - Each product in cart is displayed in a card-like row
           ========================================================= */
        .cart-item {
            display: flex;
            background-color: #f9f6f2;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            align-items: center;
            gap: 20px;
        }
        
        /* Checkbox allows selecting items for checkout (multi-item cart) */
        .item-checkbox {
            width: 22px;
            height: 22px;
            cursor: pointer;
            accent-color: #7b0d1e;
        }
        
        .cart-item img { 
            width: 180px; 
            border-radius: 10px; 
        }
        
        .item-details { 
            flex-grow: 1; 
        }
        
        .item-details h2 { 
            margin: 0; 
            font-size: 22px; 
        }
        
        .item-details p { 
            color: #666; 
            margin: 8px 0; 
        }
        
        .item-price { 
            font-size: 18px; 
            font-weight: bold; 
        }
        
        /* Subtotal shown per item: unit price * quantity */
        .item-subtotal {
            font-size: 16px;
            color: #7b0d1e;
            margin-top: 5px;
        }
        
        /* =========================================================
           QUANTITY CONTROLS
           - Buttons call JS which redirects to server-side update action
           ========================================================= */
        .quantity-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-label {
            font-size: 12px;
            font-weight: bold;
            color: #666;
            text-transform: uppercase;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
            background-color: #fff;
            padding: 8px 15px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        
        .qty-btn {
            width: 30px;
            height: 30px;
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
        
        /* Disabled button prevents invalid quantity changes */
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
        
        /* =========================================================
           REMOVE BUTTON LOGIC (by design)
           - Disabled unless qty is 0
           - Active only when qty==0 so user "decreases to 0" before removing
           ========================================================= */
        .btn-remove {
            padding: 8px 25px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 12px;
            text-transform: uppercase;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .btn-remove.active {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-remove.active:hover {
            background-color: #c82333;
        }
        
        .btn-remove.disabled {
            background-color: #ccc;
            color: #666;
            cursor: not-allowed;
        }
        
        /* =========================================================
           CART SUMMARY (Selected Items Totals)
           - Values are updated dynamically with JS based on selection
           ========================================================= */
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
            padding-top: 15px;
            border-top: 2px solid #ddd;
            margin-top: 15px;
        }
        
        /* Checkout button is disabled in JS when no items selected */
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
        
        /* =========================================================
           FOOTER (Static)
           ========================================================= */
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
        
        /* Empty cart UI */
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
        
        /* =========================================================
           ADD-TO-CART POPUP (Overlay)
           - Appears only when itemJustAdded == true
           ========================================================= */
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
    <!-- =========================================================
         POPUP HTML (Conditional)
         - Rendered only right after adding item (server-side flag)
         - JS later auto-closes it after 3 seconds
         ========================================================= -->
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

    <!-- =========================================================
         HEADER NAVBAR
         - Cart badge uses totalItems computed from session cart
         - Profile dropdown uses session userEmail to determine login state
         ========================================================= -->
    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">YAYA COSMETIC</div>
        </div>
        <nav>
            <a href="HomePage.jsp">Home</a>
            <a href="Product.jsp">Product</a>

            <!-- Cart badge shows totalItems quantity (capped at 99+) -->
            <a href="Cart.jsp" class="cart-link">Cart
                <% if (totalItems > 0) { %>
                    <span class="cart-badge"><%= totalItems > 99 ? "99+" : totalItems %></span>
                <% } %>
            </a>

            <a href="History.jsp">History</a>

            <!-- Profile dropdown changes based on login session -->
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
        <!-- Header shows total items (sum of quantities, not distinct products) -->
        <div class="cart-header">
            <h1 style="font-size: 36px; margin: 0;">CART (<%= totalItems %> items)</h1>
        </div>

        <% 
        // =========================================================
        // EMPTY CART STATE
        // - When cartItems has no entries OR all removed entries are gone
        // =========================================================
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
            <!-- =========================================================
                 CHECKOUT FORM
                 - Selected product IDs are posted as selectedItems[]
                 - Checkout.jsp decides what to process from submitted selection
                 ========================================================= -->
            <form id="checkoutForm" action="Checkout.jsp" method="POST">
            <%
            // =========================================================
            // RENDER EACH CART ITEM ROW
            // - Data attributes store price and qty for JS calculation
            // - Quantity controls redirect to server (action=update) to persist in session
            // =========================================================
            for (Map.Entry<String, Integer> entry : cartItems.entrySet()) {
                String id = entry.getKey();
                int quantity = entry.getValue();
                
                // ---------------------------------------------------------
                // PRODUCT LOOKUP (Prototype)
                // - Hardcoded product info based on ID
                // - In real systems, query DB using product ID
                // ---------------------------------------------------------
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
                
                // Per-item subtotal for display (unit price * quantity)
                int subtotal = unitPrice * quantity;

                // When quantity is 0, item becomes unselectable and removable
                boolean isZeroQty = (quantity == 0);
            %>
            <div class="cart-item" data-id="<%= id %>" data-price="<%= unitPrice %>" data-qty="<%= quantity %>">

                <!-- =========================================================
                     ITEM SELECTION RULES
                     - If more than 1 product in cart: show checkbox
                     - If only 1 product: use hidden input (auto-selected)
                     - If qty == 0: checkbox disabled to prevent checkout of invalid item
                     ========================================================= -->
                <% if (cartSize > 1) { %>
                    <input type="checkbox" class="item-checkbox"
                           name="selectedItems" value="<%= id %>"
                           <%= !isZeroQty ? "checked" : "" %>
                           onchange="updateSelection()"
                           <%= isZeroQty ? "disabled" : "" %>>
                <% } else { %>
                    <input type="hidden" name="selectedItems" value="<%= id %>">
                <% } %>

                <img src="<%= img %>" alt="<%= name %>">

                <div class="item-details">
                    <h2><%= name %></h2>
                    <p><%= desc %></p>
                    <div class="item-price">RM <%= unitPrice %> each</div>

                    <!-- Display per-item subtotal (this is NOT updated dynamically, page reload required) -->
                    <div class="item-subtotal" id="subtotal-<%= id %>">Subtotal: RM <%= subtotal %></div>
                </div>

                <div class="quantity-section">
                    <span class="quantity-label">Quantity</span>

                    <!-- =========================================================
                         QUANTITY BUTTONS
                         - Buttons call updateQuantity() which reloads page with action=update
                         - Server persists quantity changes into session cart
                         ========================================================= -->
                    <div class="quantity-controls">
                        <button type="button" class="qty-btn"
                                onclick="updateQuantity('<%= id %>', <%= quantity - 1 %>)"
                                <%= quantity <= 0 ? "disabled" : "" %>>-</button>

                        <input type="text" class="qty-input" id="qty-<%= id %>" value="<%= quantity %>" readonly>

                        <button type="button" class="qty-btn"
                                onclick="updateQuantity('<%= id %>', <%= quantity + 1 %>)"
                                <%= quantity >= 99 ? "disabled" : "" %>>+</button>
                    </div>

                    <!-- =========================================================
                         REMOVE BUTTON RULE
                         - Disabled unless qty == 0
                         - When qty==0: button is active and triggers removeItem()
                         - remove action on server only removes if qty==0 (double enforcement)
                         ========================================================= -->
                    <button type="button" class="btn-remove <%= isZeroQty ? "active" : "disabled" %>" 
                            onclick="<%= isZeroQty ? "removeItem('" + id + "')" : "" %>"
                            <%= !isZeroQty ? "disabled" : "" %>>REMOVE</button>
                </div>
            </div>
            <% 
            } // end for loop
            %>
            
            <!-- =========================================================
                 CART SUMMARY
                 - Initial values use totalItems/totalPrice from server
                 - JS recalculates based on item selection + dataset qty/price
                 ========================================================= -->
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
            
            <!-- =========================================================
                 CHECKOUT SECTION
                 - If multiple items, allow "Select All"
                 - Checkout button is disabled by JS if nothing selected
                 ========================================================= -->
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

    <!-- =========================================================
         FOOTER (Static Content)
         ========================================================= -->
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
        // =========================================================
        // updateQuantity(productId, newQty)
        // - Redirects to Cart.jsp with action=update
        // - Server validates range 0..99 and persists into session cart
        // NOTE: Uses URL parameters (GET). In real systems, prefer POST to avoid
        //       exposing actions in URL and prevent easy tampering.
        // =========================================================
        function updateQuantity(productId, newQty) {
            if (newQty >= 0 && newQty <= 99) {
                window.location.href = 'Cart.jsp?action=update&id=' + productId + '&quantity=' + newQty;
            }
        }
        
        // =========================================================
        // removeItem(productId)
        // - Confirms user intent
        // - Redirects to action=remove (server will remove only if qty==0)
        // =========================================================
        function removeItem(productId) {
            if (confirm('Are you sure you want to remove this item?')) {
                window.location.href = 'Cart.jsp?action=remove&id=' + productId;
            }
        }
        
        // =========================================================
        // updateSelection()
        // - Recalculates selectedCount and selectedPrice based on checkboxes
        // - Applies fixed tax (RM10)
        // - Updates "Select All" state and disables checkout if nothing selected
        // =========================================================
        function updateSelection() {
            var checkboxes = document.querySelectorAll('.item-checkbox');
            var selectedCount = 0;
            var selectedPrice = 0;
            
            // If only one item exists, there may be no checkbox (hidden input used)
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
            
            // Prototype: fixed tax amount
            var tax = 10;
            var total = selectedPrice + tax;
            
            // Update summary UI
            document.getElementById('selectedCount').textContent = selectedCount;
            document.getElementById('selectedPrice').textContent = selectedPrice;
            document.getElementById('totalPrice').textContent = total;
            
            // Update "Select All" checkbox state based on enabled item checkboxes
            var selectAll = document.getElementById('selectAll');
            if (selectAll) {
                var enabledCheckboxes = document.querySelectorAll('.item-checkbox:not(:disabled)');
                var checkedCheckboxes = document.querySelectorAll('.item-checkbox:checked:not(:disabled)');
                selectAll.checked = (enabledCheckboxes.length > 0 && enabledCheckboxes.length === checkedCheckboxes.length);
            }
            
            // Disable checkout when nothing selected or selected total is 0
            var checkoutBtn = document.getElementById('checkoutBtn');
            if (checkoutBtn) {
                checkoutBtn.disabled = (selectedCount === 0 || selectedPrice === 0);
            }
        }
        
        // =========================================================
        // toggleSelectAll()
        // - Checks/unchecks all enabled item checkboxes
        // - Triggers updateSelection() to refresh totals + button state
        // =========================================================
        function toggleSelectAll() {
            var selectAll = document.getElementById('selectAll');
            var checkboxes = document.querySelectorAll('.item-checkbox:not(:disabled)');
            checkboxes.forEach(function(cb) {
                cb.checked = selectAll.checked;
            });
            updateSelection();
        }
        
        // =========================================================
        // DOMContentLoaded init
        // - Ensures summary totals reflect current checkbox selection
        // - Auto-closes popup (if exists) after 3 seconds
        // =========================================================
        document.addEventListener('DOMContentLoaded', function() {
            updateSelection();
            
            var popup = document.getElementById('addedPopup');
            if (popup) {
                setTimeout(function() {
                    closePopup();
                }, 3000);
            }
        });
        
        // =========================================================
        // closePopup()
        // - Adds "hidden" class for fade/scale animation
        // - Removes popup element from DOM after animation finishes
        // =========================================================
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
