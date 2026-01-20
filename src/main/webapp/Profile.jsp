<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Get cart count for badge
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    int cartCount = 0;
    if (cartItems != null) {
        for (Integer qty : cartItems.values()) {
            cartCount += qty;
        }
    }

    // ===== USER PROFILE PAGE LOGIC =====
    // This page displays user's profile information with edit options
    
    // Hardcoded user data for demonstration
    // Later with database: fetch from session.getAttribute("user") or UserDAO.getUserById(userId)
    String userName = "Aiya Mala Johan";
    String userEmail = "aiyamala@gmail.com";
    String userAddress = "18-9 Damansara Height, Kota Damansara 92083 Damansara Selangor";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Profile</title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        /* Header */
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
        
        /* Cart Badge */
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
        
        /* Main Content */
        .profile-container {
            padding: 40px 10%;
            min-height: 60vh;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 40px 0;
            color: #000;
        }

        .profile-content {
            max-width: 800px;
        }

        .avatar-section {
            display: flex;
            align-items: center;
            margin-bottom: 40px;
        }

        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: #d3d3d3;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
        }

        .avatar svg {
            width: 50px;
            height: 50px;
            fill: #999;
        }

        .profile-field {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .profile-field:last-child {
            border-bottom: none;
        }

        .field-label {
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }

        .field-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .field-value {
            font-size: 16px;
            color: #666;
            flex: 1;
        }

        .edit-btn {
            background-color: #001a72;
            color: white;
            border: none;
            padding: 8px 25px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
        }

        .edit-btn:hover {
            background-color: #000f45;
        }

        .logout-section {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid #e0e0e0;
        }

        .logout-btn {
            background-color: #7b0d1e;
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
        }

        .logout-btn:hover {
            background-color: #5a0a15;
        }

        /* Footer */
        footer {
            background-color: #7b0d1e;
            color: white;
            padding: 40px 60px;
            display: flex;
            justify-content: space-between;
            margin-top: 50px;
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

        @media (max-width: 768px) {
            .field-content {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
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
            <a href="Cart.jsp" class="cart-link">CART<% if (cartCount > 0) { %><span class="cart-badge"><%= cartCount > 99 ? "99+" : cartCount %></span><% } %></a>
            <a href="History.jsp">HISTORY</a>
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

    <div class="profile-container">
        <h1 class="page-title">PROFILE</h1>

        <div class="profile-content">
            <div class="avatar-section">
                <div class="avatar">
                    <!-- User avatar icon (SVG) -->
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </div>
            </div>

            <!-- Display user name with edit button -->
            <div class="profile-field">
                <span class="field-label">Name</span>
                <div class="field-content">
                    <span class="field-value"><%= userName %></span>
                    <!-- Edit button redirects to EditProfile.jsp with field parameter -->
                    <button class="edit-btn" onclick="editField('name')">EDIT</button>
                </div>
            </div>

            <!-- Display user email with edit button -->
            <div class="profile-field">
                <span class="field-label">Email</span>
                <div class="field-content">
                    <span class="field-value"><%= userEmail %></span>
                    <button class="edit-btn" onclick="editField('email')">EDIT</button>
                </div>
            </div>

            <!-- Display user address with edit button -->
            <div class="profile-field">
                <span class="field-label">Address</span>
                <div class="field-content">
                    <span class="field-value"><%= userAddress %></span>
                    <button class="edit-btn" onclick="editField('address')">EDIT</button>
                </div>
            </div>

            <div class="logout-section">
                <button class="logout-btn" onclick="if(confirm('Are you sure you want to logout?')) { window.location.href='Login.html'; }">LOGOUT</button>
            </div>
        </div>
    </div>

    <footer>
        <div class="footer-col">
            <h4>ABOUT YAYA</h4>
            <a href="#">HISTORY</a>
            <a href="#">WORK IN YAYA</a>
            <a href="#">BELABOUR</a>
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
        // JavaScript function to handle profile field editing
        function editField(field) {
            // Redirect to edit page with field name as URL parameter
            window.location.href = 'EditProfile.jsp?field=' + field;
            
            // Later with backend: EditProfile.jsp form will submit to UpdateProfileServlet
        }
    </script>

</body>
</html>
