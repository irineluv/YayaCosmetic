<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    // 1. Define all your products in an array
    String[][] allProducts = {
        {"1", "YAYA GOLD PALETTE", "Contain 12 shining color", "RM 100", "pic product/3.png"},
        {"2", "YAYA BLUE PALETTE", "Contain 12 blue shade color", "RM 100", "pic product/4.png"},
        {"3", "YAYA GREEN PALETTE", "Contain 12 earthy tone color", "RM 100", "pic product/5.png"},
        {"4", "YAYA BLACK PALETTE", "Contain 12 dark shade color", "RM 100", "pic product/6.png"},
        {"5", "YAYA PINK PALETTE", "Contain 12 pink shade color", "RM 100", "pic product/7.png"},
        {"6", "YAYA ORANGE PALETTE", "Contain 12 fruity shade color", "RM 100", "pic product/8.png"},
        {"7", "YAYA PURPLE PALETTE", "Contain 12 purple shade color", "RM 100", "pic product/9.png"},
        {"8", "YAYA RED PALETTE", "Contain 12 red color", "RM 100", "pic product/10.png"}
    };

    // 2. Capture the search query from the input
    String query = request.getParameter("searchQuery");
    if (query == null) query = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Products</title>
   <style>
        /* Global Styles */
        body {
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #fcfcfc;
        }

        /* Header */        header {
            background-color: #7b0d1e; /* Deep Red/Burgundy */
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
            height: 50px; /* Adjust based on your logo size */
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
        
        /* Product Header & Controls */
        .product-section { padding: 40px 5%; }
        
        .controls-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h1 { margin: 0; font-size: 32px; text-transform: uppercase; }

        .search-filter { display: flex; align-items: center; gap: 10px; }
        .search-bar {
            padding: 8px 15px;
            border: 1px solid #ccc;
            border-radius: 20px;
            width: 250px;
        }
        /* Product Grid */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            padding: 20px 5%;
        }

        /* The Button Container */
        .product-card {
            background-color: #f9f6f2; /* Light cream background */
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            text-decoration: none; /* Removes underline from text links */
            color: inherit;
            display: block; /* Makes the whole card clickable */
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .product-card img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .product-card h3 { font-size: 18px; margin: 10px 0; }
        .product-card p { font-size: 13px; color: #666; margin: 5px 0; }
        .product-card .price { font-weight: bold; margin-top: 10px; font-size: 16px; }

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

        /* Responsive - stack on small screens */
        @media (max-width: 768px) {
            .hero, footer {
                flex-direction: column;
            }
            header {
                flex-direction: column;
                gap: 15px;
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
            <a href="Cart.jsp">CART</a>
            <a href="#">HISTORY</a>
            <div class="dropdown">
                 <% 
                     // Check if a user is logged in
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

    <main class="product-section">
        <div class="controls-row">
            <h1>PRODUCTS</h1>
            
            <form action="Product.jsp" method="GET" class="search-filter">
                <input type="text" name="searchQuery" class="search-bar" placeholder="SEARCH" value="<%= query %>">
                <button type="submit" style="background:none; border:none; font-size: 20px; cursor: pointer;">🔍</button>
            </form>
        </div>

        <div class="product-grid">
            <%
                boolean hasResults = false;
                for (int i = 0; i < allProducts.length; i++) {
                    String id = allProducts[i][0];
                    String name = allProducts[i][1];
                    String desc = allProducts[i][2];
                    String price = allProducts[i][3];
                    String img = allProducts[i][4];

                    // FIX 2: Only display the card if it matches the search query
                    if (query.isEmpty() || name.toLowerCase().contains(query.toLowerCase()) || desc.toLowerCase().contains(query.toLowerCase())) {
                        hasResults = true;
            %>
                        <a href='ProductDetail.jsp?id=<%= id %>' class="product-card">
                            <img src="<%= img %>" alt="<%= name %>">
                            <h3><%= name %></h3>
                            <p><%= desc %></p>
                            <div class="price"><%= price %></div>
                        </a>
            <%
                    }
                }
                
                if (!hasResults) {
                    out.println("<p style='grid-column: 1/-1; text-align: center; padding: 50px;'>No products found for \"" + query + "\"</p>");
                }
            %>
        </div>
    </main>

    </body>
</html>