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

    // Store user profile in session for persistence
    Map<String, String> userProfile = (Map<String, String>) session.getAttribute("userProfile");
    
    if (userProfile == null) {
        userProfile = new LinkedHashMap<>();
        userProfile.put("name", "Aiya Mala Johan");
        userProfile.put("email", "aiyamala@gmail.com");
        userProfile.put("phone", "012-3456789");
        userProfile.put("password", "user123");
        session.setAttribute("userProfile", userProfile);
    }
    
    String userName = userProfile.get("name");
    String userEmail = userProfile.get("email");
    String userPhone = userProfile.get("phone");
    String userPassword = userProfile.get("password");
    
    // Check for success message
    String successMsg = request.getParameter("success");
    String updatedField = request.getParameter("updated");
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
        
        .dropdown:hover .dropbtn {
            color: #ccc;
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

        /* Success Message */
        .success-message {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .success-message .close-btn {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #155724;
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
            background-color: #7b0d1e;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
        }

        .avatar svg {
            width: 50px;
            height: 50px;
            fill: white;
        }

        .avatar-info h2 {
            margin: 0 0 5px 0;
            font-size: 24px;
        }

        .avatar-info p {
            margin: 0;
            color: #666;
            font-size: 14px;
        }

        .profile-field {
            margin-bottom: 25px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 10px;
            border-left: 4px solid #7b0d1e;
        }

        .field-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .field-label {
            font-size: 12px;
            font-weight: bold;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .field-value {
            font-size: 18px;
            color: #333;
            font-weight: 500;
        }

        .edit-btn {
            background-color: #001a72;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.3s;
        }

        .edit-btn:hover {
            background-color: #000f45;
        }

        /* Password field special styling */
        .password-field {
            border-left-color: #001a72;
        }

        .password-value-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .password-value {
            font-size: 18px;
            color: #333;
            font-weight: 500;
            letter-spacing: 3px;
        }

        .eye-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px;
            font-size: 18px;
            color: #666;
        }

        .eye-btn:hover {
            color: #333;
        }

        .change-password-btn {
            background-color: #7b0d1e;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.3s;
        }

        .change-password-btn:hover {
            background-color: #5a0a15;
        }

        /* Non-editable field */
        .field-readonly {
            opacity: 0.8;
        }

        .readonly-badge {
            font-size: 10px;
            background-color: #e0e0e0;
            color: #666;
            padding: 4px 10px;
            border-radius: 10px;
            text-transform: uppercase;
        }

        .logout-section {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid #e0e0e0;
        }

        .logout-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.3s;
        }

        .logout-btn:hover {
            background-color: #c82333;
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
            .field-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .avatar-section {
                flex-direction: column;
                text-align: center;
            }
            
            .avatar {
                margin-right: 0;
                margin-bottom: 15px;
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
        <h1 class="page-title">MY PROFILE</h1>

        <% if ("true".equals(successMsg)) { %>
            <div class="success-message" id="successMsg">
                <span><strong>Success!</strong> 
                    <% if ("name".equals(updatedField)) { %>
                        Your name has been updated.
                    <% } else if ("phone".equals(updatedField)) { %>
                        Your phone number has been updated.
                    <% } else if ("password".equals(updatedField)) { %>
                        Your password has been changed successfully.
                    <% } else { %>
                        Profile updated successfully.
                    <% } %>
                </span>
                <button class="close-btn" onclick="document.getElementById('successMsg').style.display='none'">&times;</button>
            </div>
        <% } %>

        <div class="profile-content">
            <div class="avatar-section">
                <div class="avatar">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </div>
                <div class="avatar-info">
                    <h2><%= userName %></h2>
                    <p>Member</p>
                </div>
            </div>

            <!-- Full Name - Editable -->
            <div class="profile-field">
                <div class="field-header">
                    <span class="field-label">Full Name</span>
                    <button class="edit-btn" onclick="window.location.href='EditProfile.jsp?field=name'">EDIT</button>
                </div>
                <div class="field-value"><%= userName %></div>
            </div>

            <!-- Email - Not Editable -->
            <div class="profile-field field-readonly">
                <div class="field-header">
                    <span class="field-label">Email Address</span>
                    <span class="readonly-badge">Cannot be changed</span>
                </div>
                <div class="field-value"><%= userEmail %></div>
            </div>

            <!-- Phone Number - Editable -->
            <div class="profile-field">
                <div class="field-header">
                    <span class="field-label">Phone Number</span>
                    <button class="edit-btn" onclick="window.location.href='EditProfile.jsp?field=phone'">EDIT</button>
                </div>
                <div class="field-value"><%= userPhone %></div>
            </div>

            <!-- Password - With Eye Toggle and Change Password -->
            <div class="profile-field password-field">
                <div class="field-header">
                    <span class="field-label">Password</span>
                    <button class="change-password-btn" onclick="window.location.href='EditProfile.jsp?field=password'">CHANGE PASSWORD</button>
                </div>
                <div class="password-value-container">
                    <span class="password-value" id="passwordDisplay">••••••••</span>
                    <button class="eye-btn" onclick="togglePassword()" id="eyeBtn" title="Show password">
                        <span id="eyeIcon">👁️</span>
                    </button>
                </div>
            </div>

            <div class="logout-section">
                <button class="logout-btn" onclick="if(confirm('Are you sure you want to logout?')) { window.location.href='Logout.jsp'; }">LOGOUT</button>
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
        var passwordVisible = false;
        var actualPassword = '<%= userPassword %>';
        
        function togglePassword() {
            var display = document.getElementById('passwordDisplay');
            var eyeIcon = document.getElementById('eyeIcon');
            var eyeBtn = document.getElementById('eyeBtn');
            
            if (passwordVisible) {
                display.textContent = '••••••••';
                eyeIcon.textContent = '👁️';
                eyeBtn.title = 'Show password';
                passwordVisible = false;
            } else {
                display.textContent = actualPassword;
                eyeIcon.textContent = '🙈';
                eyeBtn.title = 'Hide password';
                passwordVisible = true;
            }
        }

        // Auto-hide success message after 5 seconds
        setTimeout(function() {
            var msg = document.getElementById('successMsg');
            if (msg) {
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() { msg.style.display = 'none'; }, 500);
            }
        }, 5000);
    </script>

</body>
</html>
