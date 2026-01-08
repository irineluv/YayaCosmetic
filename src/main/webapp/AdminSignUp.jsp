<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ===== ADMIN REGISTRATION PAGE ===== -->
<!-- This page allows new administrators to register -->
<!-- Requires admin verification code for security -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration - Yaya Cosmetic</title>
    <style>
        /* ===== PAGE STYLES ===== */
        body {
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #5a0a15; /* Darker burgundy for admin */
            font-family: 'Times New Roman', serif;
            color: white;
        }

        .container {
            text-align: center;
            width: 100%;
            max-width: 500px;
        }

        .brand-name {
            font-size: clamp(30px, 5vw, 48px);
            margin-bottom: 5px;
            letter-spacing: 3px;
        }

        .slogan {
            font-size: 14px;
            letter-spacing: 4px;
            text-transform: uppercase;
            margin-bottom: 10px;
            font-family: Arial, sans-serif;
        }

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
            margin-bottom: 40px;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .form-card {
            background-color: white;
            padding: 40px 30px;
            border-radius: 25px;
            color: #333;
            text-align: left;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 12px;
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
            font-family: Arial, sans-serif;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
        }

        input::placeholder {
            color: #ddd;
            font-size: 11px;
            text-transform: uppercase;
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

        .footer-link {
            text-align: center;
            margin-top: 20px;
        }

        .footer-link a {
            font-size: 11px;
            color: #0047ab;
            text-decoration: none;
            font-weight: bold;
            font-family: Arial, sans-serif;
            text-transform: uppercase;
        }

        .footer-link a:hover {
            text-decoration: underline;
        }

        .info-text {
            font-size: 11px;
            color: #999;
            margin-top: 10px;
            font-family: Arial, sans-serif;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1 class="brand-name">YAYA COSMETIC</h1>
        <p class="slogan">Every Shade of Beautiful</p>
        <span class="admin-badge">ADMIN REGISTRATION</span>
        
        <h2 class="page-title">REGISTER</h2>

        <!-- White card containing registration form -->
        <div class="form-card">
            <!-- Form submits to AdminSignUpServlet for registration -->
            <!-- Later: servlet will validate admin code and create admin account -->
            <form action="AdminSignUpServlet" method="POST">
                <!-- Full name input -->
                <div class="form-group">
                    <label>NAME</label>
                    <input type="text" name="name" placeholder="ENTER FULL NAME" required>
                </div>
                
                <!-- Email input -->
                <div class="form-group">
                    <label>EMAIL</label>
                    <input type="email" name="email" placeholder="ENTER EMAIL" required>
                </div>
                
                <!-- Password input -->
                <div class="form-group">
                    <label>PASSWORD</label>
                    <input type="password" name="password" placeholder="ENTER PASSWORD" required>
                </div>
                
                <!-- Confirm password input -->
                <div class="form-group">
                    <label>CONFIRM PASSWORD</label>
                    <input type="password" name="confirmPassword" placeholder="CONFIRM PASSWORD" required>
                </div>
                
                <!-- Admin verification code (security measure) -->
                <div class="form-group">
                    <label>ADMIN CODE</label>
                    <input type="text" name="adminCode" placeholder="ENTER ADMIN VERIFICATION CODE" required>
                    <p class="info-text">* Demo code: <strong>ADMIN123</strong> (For demonstration purposes only)</p>
                </div>
                
                <!-- Address input -->
                <div class="form-group">
                    <label>ADDRESS</label>
                    <input type="text" name="address" placeholder="ENTER ADDRESS" required>
                </div>
                
                <!-- Submit button -->
                <button type="submit" class="sign-in-btn">REGISTER</button>
                
                <!-- Link to login page -->
                <div class="footer-link">
                    <a href="AdminLogin.jsp">Already have admin account? Login</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
