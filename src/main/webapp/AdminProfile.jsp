<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Store admin profile in session for persistence
    Map<String, String> adminProfile = (Map<String, String>) session.getAttribute("adminProfile");
    
    if (adminProfile == null) {
        adminProfile = new java.util.LinkedHashMap<>();
        adminProfile.put("name", "Aiya Johan");
        adminProfile.put("email", "aiyaJo@mail.com");
        adminProfile.put("phone", "012-3456789");
        adminProfile.put("password", "admin123");
        session.setAttribute("adminProfile", adminProfile);
    }
    
    String adminName = adminProfile.get("name");
    String adminEmail = adminProfile.get("email");
    String adminPhone = adminProfile.get("phone");
    
    // Check for success message
    String successMsg = request.getParameter("success");
    String updatedField = request.getParameter("updated");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Admin Profile</title>
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

        .password-value {
            letter-spacing: 3px;
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
        <div class="logo-area">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">Yaya Cosmetic</div>
        </div>
        <nav>
            <a href="AdminHome.jsp">HOME</a>
            <a href="AdminProduct.jsp">PRODUCT</a>
            <a href="AdminOrder.jsp">ORDER</a>
            <a href="AdminMember.jsp">MEMBER</a>
            <a href="AdminProfile.jsp">PROFILE</a>
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
                    <h2><%= adminName %></h2>
                    <p>Administrator</p>
                </div>
            </div>

            <!-- Full Name - Editable -->
            <div class="profile-field">
                <div class="field-header">
                    <span class="field-label">Full Name</span>
                    <button class="edit-btn" onclick="window.location.href='AdminEditProfile.jsp?field=name'">EDIT</button>
                </div>
                <div class="field-value"><%= adminName %></div>
            </div>

            <!-- Email - Not Editable -->
            <div class="profile-field field-readonly">
                <div class="field-header">
                    <span class="field-label">Email Address</span>
                    <span class="readonly-badge">Cannot be changed</span>
                </div>
                <div class="field-value"><%= adminEmail %></div>
            </div>

            <!-- Phone Number - Editable -->
            <div class="profile-field">
                <div class="field-header">
                    <span class="field-label">Phone Number</span>
                    <button class="edit-btn" onclick="window.location.href='AdminEditProfile.jsp?field=phone'">EDIT</button>
                </div>
                <div class="field-value"><%= adminPhone %></div>
            </div>

            <!-- Password - Change Password -->
            <div class="profile-field password-field">
                <div class="field-header">
                    <span class="field-label">Password</span>
                    <button class="change-password-btn" onclick="window.location.href='AdminEditProfile.jsp?field=password'">CHANGE PASSWORD</button>
                </div>
                <div class="field-value password-value">••••••••</div>
            </div>

            <div class="logout-section">
                <button class="logout-btn" onclick="if(confirm('Are you sure you want to logout?')) { window.location.href='AdminLogin.jsp'; }">LOGOUT</button>
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
