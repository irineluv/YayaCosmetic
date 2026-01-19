<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #611515; /* Burgundy Background */
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
            margin-bottom: 30px;
            font-family: Arial, sans-serif;
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
            border-radius: 25px; /* Large rounded corners */
            color: #333;
            text-align: left;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
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
            box-sizing: border-box; /* Ensures padding doesn't affect width */
            font-size: 14px;
        }

        input::placeholder {
            color: #ccc;
            text-transform: uppercase;
            font-size: 11px;
        }

        .sign-in-btn {
            width: 100%;
            background-color: #001a72; /* Deep Blue Button */
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
        
        .forgot-dropdown {
            position: relative;
            display: inline-block;
        }

        .forgot-content {
            display: none;
            position: absolute;
            bottom: 25px; 
            right: 0;
            background-color: #f9f9f9;
            min-width: 200px;
            padding: 15px;
            border: 1px solid #0047ab;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
            z-index: 10;
            color: #333;
            text-align: center;
        }

        .forgot-content p {
            font-size: 11px;
            margin-bottom: 5px;
            text-transform: none;
            color: #555;
        }

        .forgot-content strong {
            font-size: 12px;
            color: #0047ab;
            word-break: break-all;
        }

        .forgot-dropdown:hover .forgot-content {
            display: block;
        }

        .forgot-trigger {
            cursor: pointer;
        }
        
        .left-links {
            display: flex;
            flex-direction: column;
            gap: 8px; /* Space between the two links */
        }
        
        .footer-links {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
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
        
        <h2 class="page-title">LOGIN</h2>

        <div class="login-card">
            <form>
                <div class="form-group">
                    <label>EMAIL</label>
                    <input type="email" placeholder="ENTER EMAIL" required>
                </div>

                <div class="form-group">
                    <label>PASSWORD</label>
                    <input type="password" placeholder="ENTER PASSWORD" required>
                </div>

                <button type="submit" class="sign-in-btn">SIGN IN</button>

               <div class="footer-links">
                    <div class="left-links">
                        <a href="SignUp.html">Don't have account?</a>
                        <a href="AdminLogin.jsp" style="color: #611515;">ADMIN? Click Here to Login</a>
                    </div>

                    <div class="forgot-link-area">
                        <a href="ForgotPass.jsp" class="forgot-trigger">Forgot password?</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

</body>
</html>