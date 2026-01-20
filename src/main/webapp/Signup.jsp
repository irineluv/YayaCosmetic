<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Register</title>
    <style>
        body {
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #611515; 
            font-family: 'Times New Roman', serif;
            color: white;
        }
        .container {
            text-align: center;
            width: 100%;
            max-width: 1000px;
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
            margin-bottom: 30px;
            font-family: Arial, sans-serif;
        }
        .page-title {
            font-size: 36px;
            margin-bottom: 40px;
            letter-spacing: 2px;
            text-transform: uppercase;
        }
        .register-wrapper {
            display: flex;
            justify-content: center;
            align-items: stretch;
            gap: 20px;
            flex-wrap: wrap; 
        }
        .form-card {
            background-color: white;
            padding: 30px;
            border-radius: 25px;
            color: #333;
            text-align: left;
            flex: 1;
            max-width: 450px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .benefit-card {
            flex: 1;
            max-width: 450px;
        }
        .benefit-card img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 25px; 
        }
        .form-group {
            margin-bottom: 15px;
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
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
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

<div class="container">
    <h1 class="brand-name">YAYA COSMETIC</h1>
    <p class="slogan">Every Shade of Beautiful</p>

    <h2 class="page-title">REGISTER</h2>

    <div class="register-wrapper">
        <div class="form-card">

            <form action="SignupServlet" method="post">

                <!-- Optional error display -->
                <% if (request.getAttribute("error") != null) { %>
                    <p style="color:red; font-size:12px;">
                        <%= request.getAttribute("error") %>
                    </p>
                <% } %>

                <div class="form-group">
                    <label>NAME</label>
                    <input type="text" name="name" placeholder="ENTER NAME" required>
                </div>

                <div class="form-group">
                    <label>EMAIL</label>
                    <input type="email" name="email" placeholder="ENTER EMAIL" required>
                </div>

                <div class="form-group">
                    <label>PHONE</label>
                    <input type="text" name="phone" placeholder="ENTER PHONE NUMBER">
                </div>

                <div class="form-group">
                    <label>PASSWORD</label>
                    <input type="password" name="password" placeholder="ENTER PASSWORD" required>
                </div>

                <div class="form-group">
                    <label>CONFIRM PASSWORD</label>
                    <input type="password" name="confirmPassword" placeholder="RE-ENTER PASSWORD" required>
                </div>

                <button type="submit" class="sign-in-btn">SIGN UP</button>

                <div class="footer-links">
                    <div class="left-links">
                        <a href="Login.jsp">Already have an account? Login here.</a>
                    </div>
                </div>

            </form>
        </div>

        <div class="benefit-card">
            <img src="Benefit.png" alt="Member Benefits">
        </div>
    </div>
</div>

</body>
</html>
