<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * PAYMENT CONTEXT (DEMO):
     * - amount is pulled from URL query param (?amount=110)
     * - orderRef is generated using current timestamp
     *
     * Real-world: amount must be server-calculated from cart/order data,
     * not trusted from request parameters.
     */
    String totalAmount = request.getParameter("amount");
    if (totalAmount == null) totalAmount = "110";
    
    // Demo order reference (unique enough for demo; not safe for real gateway reconciliation)
    String orderRef = "YC" + System.currentTimeMillis();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MYBank Online Payment Gateway</title>
    <style>
        /* Global reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Full-page bank "portal" look */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Bank Header */
        .bank-header {
            background: linear-gradient(90deg, #0d47a1, #1565c0);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .bank-logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .bank-logo-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ffd700, #ffaa00);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: bold;
            color: #0d47a1;
        }
        
        .bank-name {
            color: white;
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        
        .bank-name span {
            color: #ffd700;
        }
        
        /* "Secure" badge UI decoration */
        .secure-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.1);
            padding: 8px 15px;
            border-radius: 20px;
            color: #4caf50;
            font-size: 12px;
        }
        
        .secure-badge::before {
            content: "🔒";
        }
        
        /* Centered payment box */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        
        .payment-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 500px;
            overflow: hidden;
        }
        
        /* Payment Header / Amount display */
        .payment-header {
            background: linear-gradient(135deg, #0d47a1, #1976d2);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .payment-header h2 {
            font-size: 20px;
            margin-bottom: 10px;
        }
        
        .merchant-info {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .amount-display {
            margin-top: 20px;
            padding: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
        }
        
        .amount-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.8;
        }
        
        .amount-value {
            font-size: 36px;
            font-weight: bold;
            margin-top: 5px;
        }
        
        /* Prefix "RM" in UI only (totalAmount already numeric-like text) */
        .amount-value::before {
            content: "RM ";
            font-size: 20px;
        }
        
        .order-ref {
            font-size: 11px;
            margin-top: 10px;
            opacity: 0.7;
        }
        
        /* Payment form layout */
        .payment-form {
            padding: 30px;
        }
        
        .form-section {
            margin-bottom: 25px;
        }
        
        .form-section h3 {
            font-size: 14px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        /* Bank selection grid (UI only - no real bank code captured) */
        .bank-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .bank-option {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 15px 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .bank-option:hover {
            border-color: #1976d2;
            background: #f5f9ff;
        }
        
        .bank-option.selected {
            border-color: #1976d2;
            background: #e3f2fd;
        }
        
        .bank-option-icon {
            font-size: 24px;
            margin-bottom: 5px;
        }
        
        .bank-option-name {
            font-size: 11px;
            color: #666;
        }
        
        /* Card input fields */
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            font-size: 13px;
            color: #555;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 14px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 15px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #1976d2;
        }
        
        .form-group input::placeholder {
            color: #aaa;
        }
        
        .card-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        /* Buttons */
        .btn-pay {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #0d47a1, #1976d2);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-pay:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(13, 71, 161, 0.4);
        }
        
        .btn-cancel {
            width: 100%;
            padding: 14px;
            background: transparent;
            color: #666;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 15px;
            transition: all 0.3s;
        }
        
        .btn-cancel:hover {
            border-color: #f44336;
            color: #f44336;
        }
        
        /* Security notice is purely UI copy for demo */
        .security-notice {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            background: #f5f5f5;
            border-radius: 10px;
            margin-top: 20px;
            font-size: 12px;
            color: #666;
        }
        
        .security-notice::before {
            content: "🛡️";
            font-size: 20px;
        }
        
        /* Footer */
        .bank-footer {
            background: #1a1a2e;
            color: #888;
            padding: 20px;
            text-align: center;
            font-size: 11px;
        }
        
        .bank-footer a {
            color: #64b5f6;
            text-decoration: none;
        }
        
        /* Demo Notice (important so lecturer knows it's dummy) */
        .demo-banner {
            background: #ff9800;
            color: white;
            text-align: center;
            padding: 10px;
            font-size: 13px;
            font-weight: bold;
        }
        
        /* Loading overlay simulates payment processing */
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            justify-content: center;
            align-items: center;
            flex-direction: column;
            z-index: 1000;
        }
        
        .loading-overlay.active {
            display: flex;
        }
        
        .spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255,255,255,0.3);
            border-top-color: #ffd700;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .loading-text {
            color: white;
            margin-top: 20px;
            font-size: 16px;
        }
    </style>
</head>
<body>

    <div class="demo-banner">
        ⚠️ DEMO MODE - This is a simulated payment gateway for testing purposes only
    </div>

    <header class="bank-header">
        <div class="bank-logo">
            <div class="bank-logo-icon">MB</div>
            <div class="bank-name">MY<span>Bank</span> Online</div>
        </div>
        <div class="secure-badge">
            256-bit SSL Encrypted
        </div>
    </header>

    <main class="main-content">
        <div class="payment-container">
            <div class="payment-header">
                <h2>Payment to Merchant</h2>
                <div class="merchant-info">YAYA COSMETIC SDN BHD</div>
                <div class="amount-display">
                    <div class="amount-label">Total Amount</div>
                    <!-- UI displays "RM " via CSS ::before -->
                    <div class="amount-value"><%= totalAmount %></div>
                    <div class="order-ref">Order Reference: <%= orderRef %></div>
                </div>
            </div>

            <!-- Note: form is not posted to server, it is intercepted by JS (demo flow) -->
            <form class="payment-form" onsubmit="processPayment(event)">
                <div class="form-section">
                    <h3>Select Your Bank</h3>
                    <div class="bank-options">
                        <!-- Default selected bank option -->
                        <div class="bank-option selected" onclick="selectBank(this)">
                            <div class="bank-option-icon">🏦</div>
                            <div class="bank-option-name">MYBank</div>
                        </div>
                        <div class="bank-option" onclick="selectBank(this)">
                            <div class="bank-option-icon">🏛️</div>
                            <div class="bank-option-name">CIMB</div>
                        </div>
                        <div class="bank-option" onclick="selectBank(this)">
                            <div class="bank-option-icon">💳</div>
                            <div class="bank-option-name">Maybank</div>
                        </div>
                        <div class="bank-option" onclick="selectBank(this)">
                            <div class="bank-option-icon">🏢</div>
                            <div class="bank-option-name">RHB</div>
                        </div>
                        <div class="bank-option" onclick="selectBank(this)">
                            <div class="bank-option-icon">🏪</div>
                            <div class="bank-option-name">Public Bank</div>
                        </div>
                        <div class="bank-option" onclick="selectBank(this)">
                            <div class="bank-option-icon">🏬</div>
                            <div class="bank-option-name">Hong Leong</div>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>Card Details</h3>
                    <div class="form-group">
                        <label>Card Number</label>
                        <!-- Input masking is done via JS event listener using placeholder selector -->
                        <input type="text" placeholder="1234 5678 9012 3456" maxlength="19" required>
                    </div>
                    <div class="form-group">
                        <label>Cardholder Name</label>
                        <input type="text" placeholder="JOHN DOE" required>
                    </div>
                    <div class="card-row">
                        <div class="form-group">
                            <label>Expiry Date</label>
                            <!-- MM/YY formatting done in JS via placeholder selector -->
                            <input type="text" placeholder="MM/YY" maxlength="5" required>
                        </div>
                        <div class="form-group">
                            <label>CVV</label>
                            <!-- password type hides CVV input (demo only, still on client-side) -->
                            <input type="password" placeholder="***" maxlength="4" required>
                        </div>
                    </div>
                </div>

                <!-- Pay button shows amount (still not validated server-side) -->
                <button type="submit" class="btn-pay">Pay RM <%= totalAmount %></button>
                <button type="button" class="btn-cancel" onclick="cancelPayment()">Cancel Transaction</button>

                <div class="security-notice">
                    Your payment information is protected with bank-level security. We do not store your card details.
                </div>
            </form>
        </div>
    </main>

    <footer class="bank-footer">
        <p>© 2024 MYBank Online Payment Gateway. All rights reserved.</p>
        <p style="margin-top: 5px;">
            <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a> | <a href="#">Contact Support</a>
        </p>
    </footer>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
        <div class="loading-text">Processing your payment...</div>
    </div>

    <script>
        /*
         * UI bank selection:
         * This only changes CSS class; it does not store bank selection anywhere.
         * If you need it for receipt/history, store selected bank in a hidden input.
         */
        function selectBank(element) {
            document.querySelectorAll('.bank-option').forEach(opt => opt.classList.remove('selected'));
            element.classList.add('selected');
        }

        /*
         * Demo payment handler:
         * - Prevent default form submit
         * - Show loading overlay
         * - After 3 seconds, redirect to PlaceOrder.jsp with success status and ref
         *
         * Real-world: never redirect success based purely on client-side timing.
         */
        function processPayment(event) {
            event.preventDefault();
            
            // Show loading overlay
            document.getElementById('loadingOverlay').classList.add('active');
            
            // Simulate gateway processing delay
            setTimeout(function() {
                // Redirect to order confirmation page
                window.location.href = 'PlaceOrder.jsp?status=success&ref=<%= orderRef %>';
            }, 3000);
        }

        /*
         * Cancel flow:
         * Sends user back to Cart.jsp after confirmation.
         * Note: if you want to preserve checkout state, redirect to Checkout.jsp instead.
         */
        function cancelPayment() {
            if (confirm('Are you sure you want to cancel this transaction?')) {
                window.location.href = 'Cart.jsp';
            }
        }

        /*
         * Input formatting:
         * WARNING: You are selecting inputs by placeholder text.
         * If placeholder changes, your JS breaks silently.
         * Better: add IDs (cardNumber, expiryDate) and select by ID.
         */
        document.querySelector('input[placeholder="1234 5678 9012 3456"]').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s/g, '').replace(/\D/g, '');
            let formatted = value.match(/.{1,4}/g)?.join(' ') || value;
            e.target.value = formatted;
        });

        document.querySelector('input[placeholder="MM/YY"]').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2);
            }
            e.target.value = value;
        });
    </script>

</body>
</html>
