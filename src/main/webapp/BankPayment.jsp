<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal" %>
<%
    Integer orderId = (Integer) session.getAttribute("pendingOrderId");
    BigDecimal orderTotal = (BigDecimal) session.getAttribute("pendingOrderTotal");
    
    if (orderId == null || orderTotal == null) {
        response.sendRedirect("CartServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Bank Payment</title>
    <style>
        body { margin: 0; font-family: 'Arial', sans-serif; background-color: #f5f5f5; }
        header { background-color: #7b0d1e; color: white; padding: 10px 50px; display: flex; justify-content: space-between; align-items: center; }
        .logo-container { display: flex; align-items: center; gap: 15px; }
        .logo-img { height: 50px; width: auto; }
        .brand-name { font-family: 'Times New Roman', serif; font-size: 26px; letter-spacing: 2px; text-transform: uppercase; }

        .payment-section { padding: 60px 20px; min-height: 60vh; display: flex; justify-content: center; align-items: center; }
        .payment-card { background: white; border-radius: 15px; padding: 40px; max-width: 450px; width: 100%; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
        .payment-header { text-align: center; margin-bottom: 30px; }
        .payment-header h2 { margin: 0 0 10px 0; font-size: 24px; }
        .payment-header p { color: #666; margin: 0; }

        .order-summary { background: #f9f9f9; padding: 20px; border-radius: 10px; margin-bottom: 30px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .summary-total { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; padding-top: 15px; border-top: 2px solid #ddd; margin-top: 10px; }

        .bank-options { margin-bottom: 30px; }
        .bank-option { display: flex; align-items: center; gap: 15px; padding: 15px; border: 2px solid #ddd; border-radius: 8px; margin-bottom: 10px; cursor: pointer; }
        .bank-option:hover { border-color: #7b0d1e; }
        .bank-option.selected { border-color: #7b0d1e; background-color: #fff5f5; }
        .bank-option input { margin: 0; }
        .bank-name { font-weight: bold; }

        .btn-group { display: flex; gap: 15px; }
        .btn { flex: 1; padding: 15px; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; text-transform: uppercase; }
        .btn-confirm { background-color: #28a745; color: white; }
        .btn-confirm:hover { background-color: #218838; }
        .btn-cancel { background-color: #dc3545; color: white; }
        .btn-cancel:hover { background-color: #c82333; }

        .secure-badge { text-align: center; margin-top: 20px; color: #666; font-size: 13px; }
        .secure-badge span { color: #28a745; }

        footer { background-color: #7b0d1e; color: white; padding: 40px 60px; display: flex; justify-content: space-between; }
        .footer-col { flex: 1; }
        .footer-col h4 { font-size: 16px; margin-bottom: 20px; text-transform: uppercase; }
        .footer-col p, .footer-col a { display: block; color: #ffffff; text-decoration: none; font-size: 13px; margin: 8px 0; }
    </style>
</head>
<body>

    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <span class="brand-name">Yaya Cosmetic</span>
        </div>
    </header>

    <section class="payment-section">
        <div class="payment-card">
            <div class="payment-header">
                <h2>Online Banking Payment</h2>
                <p>Complete your payment securely</p>
            </div>

            <div class="order-summary">
                <div class="summary-row">
                    <span>Order #</span>
                    <span><%= orderId %></span>
                </div>
                <div class="summary-total">
                    <span>Total Amount</span>
                    <span>RM <%= orderTotal %></span>
                </div>
            </div>

            <div class="bank-options">
                <label class="bank-option selected">
                    <input type="radio" name="bank" value="maybank" checked>
                    <div>
                        <div class="bank-name">Maybank2u</div>
                    </div>
                </label>
                <label class="bank-option">
                    <input type="radio" name="bank" value="cimb">
                    <div>
                        <div class="bank-name">CIMB Clicks</div>
                    </div>
                </label>
                <label class="bank-option">
                    <input type="radio" name="bank" value="rhb">
                    <div>
                        <div class="bank-name">RHB Now</div>
                    </div>
                </label>
                <label class="bank-option">
                    <input type="radio" name="bank" value="publicbank">
                    <div>
                        <div class="bank-name">Public Bank</div>
                    </div>
                </label>
            </div>

            <div class="btn-group">
                <form action="PaymentServlet" method="POST" style="flex:1;">
                    <input type="hidden" name="action" value="cancel">
                    <button type="submit" class="btn btn-cancel" style="width:100%;">Cancel</button>
                </form>
                <form action="PaymentServlet" method="POST" style="flex:1;">
                    <input type="hidden" name="action" value="confirm">
                    <button type="submit" class="btn btn-confirm" style="width:100%;">Pay Now</button>
                </form>
            </div>

            <div class="secure-badge">
                <span>🔒</span> Your payment is secure and encrypted
            </div>
        </div>
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
        document.querySelectorAll('.bank-option').forEach(function(el) {
            el.addEventListener('click', function() {
                document.querySelectorAll('.bank-option').forEach(function(e) { e.classList.remove('selected'); });
                this.classList.add('selected');
                this.querySelector('input').checked = true;
            });
        });
    </script>

</body>
</html>
