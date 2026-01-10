<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // 1. Logic to handle "Add" or "Remove" actions
    List<String> cart = (List<String>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
        session.setAttribute("cart", cart);
    }

    String action = request.getParameter("action");
    String productId = request.getParameter("id");

    if ("add".equals(action) && productId != null) {
        if (!cart.contains(productId)) cart.add(productId);
    } else if ("remove".equals(action) && productId != null) {
        cart.remove(productId);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Yaya Cosmetic - Cart</title>
    <style>
        /* Shared Header/Footer Styles from your code */
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; }
        
        header {
            background-color: #7b0d1e;
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-area { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
        }
        
        .logo-img { 
            height: 45px; 
            width: auto; 
        }
        
        .brand-name { 
            font-family: 'Times New Roman', serif; 
            font-size: 24px; 
            letter-spacing: 2px; 
            text-transform: uppercase; 
        }
        
        nav a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .cart-container { padding: 40px 10%; }
        .cart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        
        /* Product Card in Cart */
        .cart-item {
            display: flex;
            background-color: #f9f6f2;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            align-items: center;
            gap: 30px;
        }
        .cart-item img { width: 200px; border-radius: 10px; }
        .item-details { flex-grow: 1; }
        .item-details h2 { margin: 0; font-size: 24px; }
        .item-details p { color: #666; margin: 10px 0; }
        .item-price { font-size: 20px; font-weight: bold; }
        
        /* Buttons */
        .action-btns { display: flex; flex-direction: column; gap: 10px; }
        .btn { border: none; padding: 8px 30px; border-radius: 8px; font-weight: bold; cursor: pointer; color: white; background-color: #001a72; }
        .checkout-btn { background-color: #001a72; padding: 12px 50px; float: right; margin-top: 20px; border-radius: 8px; color: white; border: none; font-weight: bold; }
        
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
    </style>
</head>
<body>

    <header>
        <div class="logo-area">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">Yaya Cosmetic</div>
        </div>
        <nav>
            <a href="HomePage.jsp">HOME</a>
            <a href="Product.html">PRODUCT</a>
            <a href="Cart.jsp">CART</a>
            <a href="#">HISTORY</a>
            <a href="#">PROFILE</a>
        </nav>
    </header>

    <div class="cart-container">
        <div class="cart-header">
            <h1 style="font-size: 36px; margin: 0;">CART</h1>
            <div style="position: relative;">
                <input type="text" placeholder="SEARCH" style="padding: 8px 30px 8px 15px; border-radius: 20px; border: 1px solid #ccc;">
                <span style="position: absolute; right: 10px; top: 5px;">🔍</span>
            </div>
        </div>

        <% 
        if (cart.isEmpty()) { 
        %>
            <p style="text-align: center; font-size: 18px; margin-top: 50px;">Your cart is empty.</p>
        <% 
        } else {
            for (String id : cart) {
                // Determine which product to show based on ID
                String name = "YAYA GOLD PALLATE";
                String img = "pic product/3.png";
                String desc = "Contain 12 Shining Color";
                
                if ("2".equals(id)) { name = "YAYA BLUE PALLATE"; img = "pic product/4.png"; desc="Contain 12 blue shade color"; }
                else if ("3".equals(id)) { name = "YAYA GREEN PALLATE"; img = "pic product/5.png"; desc="Contain 12 earthy tone color"; }
                else if ("4".equals(id)) { name = "YAYA BLACK PALLATE"; img = "pic product/6.png"; desc="Contain 12 dark shade color"; }
                else if ("5".equals(id)) { name = "YAYA PINK PALLATE"; img = "pic product/7.png"; desc="Contain 12 pink shade color"; }
                else if ("6".equals(id)) { name = "YAYA ORANG PALLATE"; img = "pic product/8.png"; desc="Contain 12 fruity shade color"; }
                else if ("7".equals(id)) { name = "YAYA PURPLE PALLATE"; img = "pic product/9.png"; desc="Contain 12 purple shade color"; }
                else if ("8".equals(id)) { name = "YAYA RED PALLATE"; img = "pic product/10.png"; desc="Contain 12 red shade color"; }
        %>
            <div class="cart-item">
                <img src="<%= img %>" alt="Product Image">
                <div class="item-details">
                    <h2><%= name %></h2>
                    <p><%= desc %></p>
                    <div class="item-price">RM 100</div>
                </div>
                <div class="action-btns">
                    <button class="btn">EDIT</button>
                    <a href="Cart.jsp?action=remove&id=<%= id %>" class="btn" style="text-decoration:none; text-align:center; background-color:#001a72;">REMOVE</a>
                </div>
            </div>
        <% 
            }
        %>
            <div style="width: 100%; display: flex; justify-content: flex-end; padding: 20px 0;">
                <button class="checkout-btn">CHECKOUT</button>
            </div>
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

</body>
</html>