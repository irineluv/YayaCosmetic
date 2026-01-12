<%-- 
    Document   : HomePage
    Created on : Jan 10, 2026, 10:54:46 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=0.5">
    <title>Yaya Cosmetic</title>
    <style>
        body {
            margin: 0;
            font-family: 'Serif', 'Arial', sans-serif;
            background-color: #f9f9f9;
            
        }

        /* Header / Navbar */
        header {
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
        

        /* Hero Section */
        .hero {
            display: flex;
            height: 450px;
            width: 100%;
        }

        .hero-left {
            flex: 2;
            position: relative;
            overflow: hidden;
        }

        .hero-left img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .hero-right {
            flex: 1;
            background-color: #c4b1a2; /* The taupe color from image */
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 30px;
            color: white;
            text-align: center;
        }

        .hero-right h1 {
            font-size: 36px;
            font-weight: normal;
            margin-bottom: 25px;
            line-height: 1.1;
        }

        .hero-right p {
            font-size: 15px;
            line-height: 1.8;
            margin-bottom: 35px;
            letter-spacing: 1px;
            max-width: 400px;
        }

        .shop-link {
            color: white;
            text-decoration: none;
            font-weight: bold;
            border-bottom: 2px solid white;
            padding-bottom: 2px;
            font-size: 14px;
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
            <a href="HomePage.jsp">Home</a>
            <a href="Product.jsp">Product</a>
            <a href="Cart.jsp">Cart</a>
            <a href="#">History</a>
            <div class="dropdown">
                 <% 
                     // Check if a user is logged in
                     String currentUser = (String) session.getAttribute("userEmail"); 

                     if (currentUser == null) { 
                 %>
                     <a href="#" class="dropbtn">Profile</a>
                     <div class="dropdown-content">
                         <a href="Login.html">Login</a>
                         <a href="SignUp.html">Sign up</a>
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

    <section class="hero">
        <div class="hero-left">
            <img src="Women-Makeup.png" alt="Model Picture">
        </div>
        <div class="hero-right">
            <h1>NEW IN: THE MAKEUP<br>PALLATE COLLECTION</h1>
            <p>
                UNVEIL A NEW LEVEL OF GLOW.<br>
                EXPLORE OUR LIMITED-EDITION<br>
                PALETTES AND SIGNATURE<br>
                SHADES. DESIGNED FOR<br>
                EFFORTLESS ELEGANCE.
            </p>
            <a href="Product.jsp" class="shop-link">SHOP THE COLLECTION NOW!</a>
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
            <p>yayacosmetic@hotline.com (official email)</p>
            <p>@yayacosmeticofficial (Instagram)</p>
        </div>
    </footer>

</body>
</html>