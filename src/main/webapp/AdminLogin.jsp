<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ===== ADMIN LOGIN PAGE ===== -->
<!-- This page allows administrators to log into the system -->
<!-- Uses darker burgundy theme to distinguish from user login -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Yaya Cosmetic</title>
    <style>
        /* ===== PAGE STYLES ===== */
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #5a0a15; /* Darker burgundy for admin */
            font-family: 'Times New Roman', serif;
            color: white;
        }

        .login-container {
            text-align: center;
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }

        .brand-name {
            font-size: 42px;
            margin-bottom: 5px;
            letter-spacing: 2px;
        }

        .slogan {
            font-size: 14px;
            letter-spacing: 3px;
            text-transform: uppercase;
            margin-bottom: 10px;
            font-family: Arial, sans-serif;
        }

        /* Gold badge to indicate admin access */
        .admin-badge {
            background-color: #ffd700;
            color: #5a0a15;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 20px;
        }

        .page-title {
            font-size: 36px;
            margin-bottom: 30px;
            letter-spacing: 1px;
        }

        /* The White Login Card */
        .login-card {
            background-color: white;
            padding: 40px 30px;
            border-radius: 25px;
            color: #333;
            text-align: left;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 12px;
            font-weight: bold;
            color: #666;
            margin-bottom: 8px;
            font-family: Arial, sans-serif;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
        }

        input::placeholder {
            color: #ccc;
            text-transform: uppercase;
            font-size: 11px;
        }

        .sign-in-btn {
            width: 100%;
            background-color: #001a72;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
            font-family: Arial, sans-serif;
            font-size: 13px;
        }

        .sign-in-btn:hover {
            background-color: #000f45;
        }

        .footer-links {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .footer-links a {
            font-size: 11px;
            color: #0047ab;
            text-decoration: none;
            font-weight: bold;
            font-family: Arial, sans-serif;
            text-transform: uppercase;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <h1 class="brand-name">YAYA COSMETIC</h1>
        <p class="slogan">Every Shade of Beautiful</p>
        <span class="admin-badge">ADMIN ACCESS</span>
        
        <h2 class="page-title">ADMIN LOGIN</h2>

        <!-- White card containing login form -->
        <div class="login-card">
            <!-- Form submits to AdminLoginServlet for authentication -->
            <!-- Later: servlet will validate credentials and create admin session -->
            <form action="AdminLoginServlet" method="POST">
                <!-- Email input field -->
                <div class="form-group">
                    <label>EMAIL</label>
                    <input type="email" name="email" placeholder="ENTER ADMIN EMAIL" required>
                </div>

                <!-- Password input field -->
                <div class="form-group">
                    <label>PASSWORD</label>
                    <input type="password" name="password" placeholder="ENTER PASSWORD" required>
                </div>

                <!-- Submit button -->
                <button type="submit" class="sign-in-btn">SIGN IN</button>

                <!-- Links to registration and user login -->
                <div class="footer-links">
                    <a href="AdminSignUp.jsp">Register as Admin</a>
                    <a href="Login.html">User Login</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
