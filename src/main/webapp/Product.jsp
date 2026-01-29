<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.yc.model.Product" %>
<%
    if (request.getAttribute("products") == null) {
        response.sendRedirect("ProductServlet");
        return;
    }
%>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    String query = (String) request.getAttribute("searchQuery");
    if (query == null) query = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Products</title>

    <style>
        body {
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #fcfcfc;
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
        }

        .brand-name {
            font-size: 28px;
            font-family: 'Times New Roman', serif;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        nav {
            display: flex;
            align-items: center;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-size: 13px;
            font-weight: bold;
            text-transform: uppercase;
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
            box-shadow: 0px 8px 16px black;
            z-index: 1;
            right: 0;
            margin-top: 5px;
        }

        .dropdown-content a {
            color: #7b0d1e !important;
            padding: 12px 16px;
            display: block;
            text-align: left;
            font-size: 13px;
            border-bottom: 1px solid;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .product-section {
            padding: 40px 5%;
        }

        .controls-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h1 {
            margin: 0;
            font-size: 32px;
            text-transform: uppercase;
        }

        .search-filter {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-bar {
            padding: 8px 15px;
            border: 1px solid #ccc;
            border-radius: 20px;
            width: 250px;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            padding: 20px 5%;
        }

        .product-card {
            background-color: #f9f6f2;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            color: inherit;
            display: block;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .product-card img {
            width: 100%;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .product-card h3 {
            font-size: 18px;
        }

        .product-card p {
            font-size: 13px;
            color: #666;
        }

        .price {
            font-weight: bold;
            font-size: 16px;
            margin-top: 10px;
        }
        .cart-link {
            position: relative;
            display: inline-block;
            padding-right: 12px;
        }
        /* Floating badge */
        .cart-badge {
            position: absolute;
            top: -6px;
            right: -8px;
            background-color: #FFC107; /* Luxury Yellow */
            color: #000;
            font-size: 11px;
            font-weight: bold;
            min-width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.25);
            animation: popIn 0.3s ease;
        }

        /* Cute pop animation */
        @keyframes popIn {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
    </style>
</head>

<body>

<header>
    <div class="logo-container">
        <img src="LOGO.png" class="logo-img">
        <div class="brand-name">YAYA COSMETIC</div>
    </div>

    <nav>
        <a href="HomePage.jsp">HOME</a>
        <a href="ProductServlet">PRODUCT</a>
        <a href="CartServlet" class="cart-link">
                Cart
                <%
                    Integer cartCount = (Integer) session.getAttribute("cartCount");
                    if (cartCount != null && cartCount > 0) {
                %>
                    <span class="cart-badge"><%= cartCount %></span>
                <% } %>
            </a>
        <a href="OrderHistoryServlet">History</a>


        <div class="dropdown">
            <%
                String currentUser = (String) session.getAttribute("userEmail");
                if (currentUser == null) {
            %>
                <a href="#" class="dropbtn">PROFILE</a>
                <div class="dropdown-content">
                    <a href="Login.jsp">Login</a>
                    <a href="Signup.jsp">Sign up</a>
                </div>
            <%
                } else {
            %>
                <a href="#" class="dropbtn">Hi, <%= currentUser %></a>
                <div class="dropdown-content">
                    <a href="ProfileServlet">View Profile</a>
                    <a href="LogoutServlet">Logout</a>
                </div>
            <%
                }
            %>
        </div>
    </nav>
</header>

<main class="product-section">

    <div class="controls-row">
        <h1>PRODUCTS</h1>

        <form action="ProductServlet" method="GET" class="search-filter">
            <input type="text" name="searchQuery" class="search-bar"
                   placeholder="SEARCH" value="<%= query %>">
            <button type="submit" style="background:none;border:none;font-size:20px;">🔍</button>
        </form>
    </div>

    <div class="product-grid">
        <%
            if (products != null && !products.isEmpty()) {
                for (Product p : products) {
        %>
            <a href="ProductDetailServlet?id=<%= p.getProductId() %>" class="product-card">
                <img src="<%= p.getImage() != null ? p.getImage() : "pic product/3.png" %>" alt="<%= p.getName() %>">
                <h3><%= p.getName() %></h3>
                <p><%= p.getDescription() != null ? p.getDescription() : "" %></p>
                <div class="price">RM <%= String.format("%.2f", p.getPrice()) %></div>
            </a>
        <%
                }
            } else {
        %>
            <p style="grid-column:1/-1;text-align:center;padding:50px;">
                No products found for "<%= query %>"
            </p>
        <%
            }
        %>
    </div>

</main>

</body>
</html>
