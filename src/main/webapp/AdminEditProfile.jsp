<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // ===== EDIT ADMIN PROFILE PAGE LOGIC =====
    // This page displays a form to edit a specific admin profile field
    // Accessed from AdminProfile.jsp when admin clicks EDIT button
    
    // Get field name from URL parameter (e.g., AdminEditProfile.jsp?field=name)
    String field = request.getParameter("field");
    
    // Initialize variables for form display
    // Later with database: fetch current value from session or AdminDAO
    String currentValue = "";
    String fieldLabel = "";
    String inputType = "text"; // Default input type
    
    // Determine which field is being edited and set appropriate values
    if ("name".equals(field)) {
        currentValue = "Aiya Johan";
        fieldLabel = "Name";
    } else if ("email".equals(field)) {
        currentValue = "aiyaJo@mail.com";
        fieldLabel = "Email";
        inputType = "email"; // Use email input type for validation
    } else if ("address".equals(field)) {
        currentValue = "18-9 Damansara Height, Kota Damansara 92083 Damansara Selangor";
        fieldLabel = "Address";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Yaya Cosmetic Admin</title>
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
        .edit-container {
            padding: 40px 10%;
            min-height: 60vh;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 30px 0;
        }

        .edit-form {
            max-width: 600px;
            background-color: #f9f9f9;
            padding: 40px;
            border-radius: 10px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            font-family: Arial, sans-serif;
            box-sizing: border-box;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background-color: #001a72;
            color: white;
        }

        .btn-primary:hover {
            background-color: #000f45;
        }

        .btn-secondary {
            background-color: #999;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #777;
        }

        .info-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
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

    <div class="edit-container">
        <h1 class="page-title">EDIT <%= fieldLabel.toUpperCase() %></h1>

        <!-- Edit form container -->
        <div class="edit-form">
            <!-- Form submits to UpdateAdminProfileServlet (backend) -->
            <!-- Later: servlet will update admin profile in database and redirect back -->
            <form action="UpdateAdminProfileServlet" method="POST">
                <!-- Hidden field to tell servlet which field is being updated -->
                <input type="hidden" name="field" value="<%= field %>">
                
                <div class="form-group">
                    <label>Current <%= fieldLabel %>:</label>
                    <!-- Use textarea for address (longer text), input for name/email -->
                    <% if ("address".equals(field)) { %>
                        <textarea name="value" required><%= currentValue %></textarea>
                    <% } else { %>
                        <!-- Input type changes based on field (text for name, email for email) -->
                        <input type="<%= inputType %>" name="value" value="<%= currentValue %>" required>
                    <% } %>
                    <p class="info-text">* This will update your admin profile information</p>
                </div>
                
                <!-- Action buttons -->
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">UPDATE</button>
                    <a href="AdminProfile.jsp" class="btn btn-secondary">CANCEL</a>
                </div>
            </form>
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

</body>
</html>
