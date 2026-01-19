<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - Yaya Cosmetic</title>
    <style>
        body { font-family: Arial; background-color: #fcfcfc; display: flex; justify-content: center; padding-top: 50px; }
        .form-container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); width: 350px; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; background: #7b0d1e; color: white; border: none; padding: 10px; cursor: pointer; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Reset Password</h2>
        <form action="ResetPasswordAction.jsp" method="POST">
            <input type="email" name="email" placeholder="Enter Registered Email" required>
            <input type="password" name="newPassword" placeholder="Enter New Password" required>
            <button type="submit">Update Password</button>
        </form>
    </div>
</body>
</html>