<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yc.model.Admin" %>
<%
    Admin admin = (Admin) request.getAttribute("admin");
    String editField = (String) request.getAttribute("editField");
    String error = (String) request.getAttribute("error");
    
    if (admin == null || editField == null) {
        response.sendRedirect("AdminProfileServlet");
        return;
    }
    
    String pageTitle = "Edit Profile";
    if ("name".equals(editField)) pageTitle = "Edit Name";
    else if ("phone".equals(editField)) pageTitle = "Edit Phone";
    else if ("password".equals(editField)) pageTitle = "Change Password";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - <%= pageTitle %></title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
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

        .edit-container {
            padding: 40px 10%;
            min-height: 60vh;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #7b0d1e;
            text-decoration: none;
            font-size: 14px;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 30px 0;
        }

        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .edit-card {
            background-color: #f9f6f2;
            padding: 40px;
            border-radius: 15px;
            max-width: 500px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group input:focus {
            outline: none;
            border-color: #7b0d1e;
        }

        .current-value {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        .btn-save {
            width: 100%;
            padding: 15px;
            background-color: #001a72;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
        }

        .btn-save:hover {
            background-color: #000f45;
        }

        .btn-cancel {
            width: 100%;
            padding: 15px;
            background-color: transparent;
            color: #666;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-cancel:hover {
            border-color: #999;
        }

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
            <a href="AdminDashboardServlet">HOME</a>
            <a href="AdminProductServlet">PRODUCT</a>
            <a href="AdminOrderServlet">ORDER</a>
            <a href="AdminMemberServlet">MEMBER</a>
            <a href="AdminProfileServlet">PROFILE</a>
        </nav>
    </header>

    <div class="edit-container">
        <a href="AdminProfileServlet" class="back-link">← Back to Profile</a>
        <h1 class="page-title"><%= pageTitle.toUpperCase() %></h1>

        <% if (error != null) { %>
            <div class="error-message"><%= error %></div>
        <% } %>

        <div class="edit-card">
            <% if ("name".equals(editField)) { %>
                <form action="UpdateAdminProfileServlet" method="POST">
                    <input type="hidden" name="field" value="name">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="value" value="<%= admin.getFullName() %>" required>
                        <p class="current-value">Current: <%= admin.getFullName() %></p>
                    </div>
                    <button type="submit" class="btn-save">Save Changes</button>
                    <button type="button" class="btn-cancel" onclick="window.location.href='AdminProfileServlet'">Cancel</button>
                </form>

            <% } else if ("phone".equals(editField)) { %>
                <form action="UpdateAdminProfileServlet" method="POST">
                    <input type="hidden" name="field" value="phone">
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="value" value="<%= admin.getPhone() != null ? admin.getPhone() : "" %>" required>
                        <p class="current-value">Current: <%= admin.getPhone() != null ? admin.getPhone() : "Not set" %></p>
                    </div>
                    <button type="submit" class="btn-save">Save Changes</button>
                    <button type="button" class="btn-cancel" onclick="window.location.href='AdminProfileServlet'">Cancel</button>
                </form>

            <% } else if ("password".equals(editField)) { %>
                <form action="UpdateAdminProfileServlet" method="POST">
                    <input type="hidden" name="field" value="password">
                    <div class="form-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required minlength="6">
                        <p class="current-value">Minimum 6 characters</p>
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" required minlength="6">
                    </div>
                    <button type="submit" class="btn-save">Change Password</button>
                    <button type="button" class="btn-cancel" onclick="window.location.href='AdminProfileServlet'">Cancel</button>
                </form>
            <% } %>
        </div>
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
            <p>yayacosmetic@hotline.com</p>
            <p>@yayacosmeticofficial (Instagram)</p>
        </div>
    </footer>

</body>
</html>
