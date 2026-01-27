<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.CartItem, com.yc.model.Address, java.math.BigDecimal" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    BigDecimal cartTotal = (BigDecimal) request.getAttribute("cartTotal");
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    Address defaultAddress = (Address) request.getAttribute("defaultAddress");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    
    if (cartItems == null) {
        response.sendRedirect("CheckoutServlet");
        return;
    }
    
    if (cartTotal == null) cartTotal = BigDecimal.ZERO;
    if (cartCount == null) cartCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Checkout</title>
    <style>
        body { margin: 0; font-family: 'Arial', sans-serif; background-color: #fcfcfc; }
        header { background-color: #7b0d1e; color: white; padding: 10px 50px; display: flex; justify-content: space-between; align-items: center; }
        .logo-container { display: flex; align-items: center; gap: 15px; }
        .logo-img { height: 50px; width: auto; }
        .brand-name { font-family: 'Times New Roman', serif; font-size: 26px; letter-spacing: 2px; text-transform: uppercase; }
        nav { display: flex; align-items: center; gap: 25px; }
        nav a { color: white; text-decoration: none; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; }

        .checkout-section { padding: 40px 60px; min-height: 60vh; }
        .section-title { font-size: 32px; font-weight: bold; margin: 0 0 30px 0; }
        .checkout-container { display: flex; gap: 40px; }
        .checkout-form { flex: 2; }
        .order-summary { flex: 1; background-color: #f5ebe0; padding: 30px; border-radius: 15px; height: fit-content; }

        .form-section { background: #fff; padding: 25px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .form-section h3 { margin: 0 0 20px 0; font-size: 18px; padding-bottom: 10px; border-bottom: 2px solid #f0f0f0; }

        .address-option { padding: 15px; border: 2px solid #ddd; border-radius: 8px; margin-bottom: 10px; cursor: pointer; display: flex; align-items: flex-start; gap: 12px; }
        .address-option:hover { border-color: #7b0d1e; }
        .address-option.selected { border-color: #7b0d1e; background-color: #fff5f5; }
        .address-option input { margin-top: 3px; flex-shrink: 0; }
        .address-option > div { flex: 1; }
        .address-label { font-weight: bold; }
        .address-text { font-size: 14px; color: #666; margin-top: 5px; line-height: 1.5; }

        .payment-option { padding: 15px; border: 2px solid #ddd; border-radius: 8px; margin-bottom: 10px; cursor: pointer; display: flex; align-items: center; gap: 15px; }
        .payment-option:hover { border-color: #7b0d1e; }
        .payment-option.selected { border-color: #7b0d1e; background-color: #fff5f5; }

        .summary-title { font-size: 20px; font-weight: bold; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #ddd; }
        .summary-item { display: flex; gap: 15px; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
        .summary-item img { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; }
        .summary-item-details { flex: 1; }
        .summary-item-name { font-size: 14px; font-weight: bold; }
        .summary-item-qty { font-size: 12px; color: #666; }
        .summary-item-price { font-weight: bold; }

        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; }
        .summary-total { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; margin-top: 15px; padding-top: 15px; border-top: 2px solid #ddd; }

        .btn-place-order { display: block; width: 100%; padding: 15px; background-color: #7b0d1e; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; text-transform: uppercase; margin-top: 20px; }
        .btn-place-order:hover { background-color: #5a0a15; }

        .no-address { padding: 20px; text-align: center; color: #666; }
        .no-address a { color: #7b0d1e; }

        footer { background-color: #7b0d1e; color: white; padding: 40px 60px; display: flex; justify-content: space-between; margin-top: 50px; }
        .footer-col { flex: 1; }
        .footer-col h4 { font-size: 16px; margin-bottom: 20px; text-transform: uppercase; }
        .footer-col p, .footer-col a { display: block; color: #ffffff; text-decoration: none; font-size: 13px; margin: 8px 0; }

        @media (max-width: 800px) { .checkout-container { flex-direction: column; } }
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
            <a href="ProductListServlet">Products</a>
            <a href="OrderHistoryServlet">History</a>
            <a href="ProfileServlet">Profile</a>
            <a href="LogoutServlet">Logout</a>
        </nav>
    </header>

    <section class="checkout-section">
        <h2 class="section-title">CHECKOUT</h2>

        <form action="PlaceOrderServlet" method="POST">
            <div class="checkout-container">
                <div class="checkout-form">
                    <div class="form-section">
                        <h3>Shipping Address</h3>
                        <% if (addresses == null || addresses.isEmpty()) { %>
                            <div class="no-address">
                                <p>You don't have any saved addresses.</p>
                                <a href="ProfileServlet">Add an address in your profile</a>
                            </div>
                        <% } else { 
                            for (Address addr : addresses) { 
                                boolean isSelected = (defaultAddress != null && addr.getAddressId() == defaultAddress.getAddressId());
                        %>
                            <label class="address-option <%= isSelected ? "selected" : "" %>">
                                <input type="radio" name="addressId" value="<%= addr.getAddressId() %>" <%= isSelected ? "checked" : "" %> required>
                                <div>
                                    <div class="address-label"><%= addr.getLabel() != null ? addr.getLabel() : "Address" %></div>
                                    <div class="address-text">
                                        <%= addr.getAddressLine() %>, <%= addr.getCity() %>, <%= addr.getState() %> <%= addr.getPostalCode() %>
                                        <br>Phone: <%= addr.getPhone() %>
                                    </div>
                                </div>
                            </label>
                        <% } 
                        } %>
                    </div>

                    <div class="form-section">
                        <h3>Payment Method</h3>
                        <label class="payment-option selected">
                            <input type="radio" name="paymentMethod" value="bank" checked>
                            <div>
                                <strong>Online Banking</strong>
                                <div style="font-size:12px; color:#666;">Pay securely via bank transfer</div>
                            </div>
                        </label>
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="cod">
                            <div>
                                <strong>Cash on Delivery</strong>
                                <div style="font-size:12px; color:#666;">Pay when you receive your order</div>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="order-summary">
                    <div class="summary-title">Order Summary</div>
                    <% for (CartItem item : cartItems) { %>
                        <div class="summary-item">
                            <img src="<%= item.getProductImage() %>" alt="<%= item.getProductName() %>">
                            <div class="summary-item-details">
                                <div class="summary-item-name"><%= item.getProductName() %></div>
                                <div class="summary-item-qty">Qty: <%= item.getQuantity() %></div>
                            </div>
                            <div class="summary-item-price">RM <%= item.getSubtotal() %></div>
                        </div>
                    <% } %>
                    
                    <div class="summary-row">
                        <span>Subtotal</span>
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

                    <button type="submit" class="btn-place-order" <%= (addresses == null || addresses.isEmpty()) ? "disabled" : "" %>>
                        Place Order
                    </button>
                </div>
            </div>
        </form>
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

    <script>
        document.querySelectorAll('.address-option').forEach(function(el) {
            el.addEventListener('click', function() {
                document.querySelectorAll('.address-option').forEach(function(e) { e.classList.remove('selected'); });
                this.classList.add('selected');
                this.querySelector('input').checked = true;
            });
        });
        document.querySelectorAll('.payment-option').forEach(function(el) {
            el.addEventListener('click', function() {
                document.querySelectorAll('.payment-option').forEach(function(e) { e.classList.remove('selected'); });
                this.classList.add('selected');
                this.querySelector('input').checked = true;
            });
        });
    </script>

</body>
</html>
