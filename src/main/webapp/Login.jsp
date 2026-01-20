<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

<h2>User Login</h2>

<form action="LoginServlet" method="post">
    <label>Email:</label><br>
    <input type="email" name="email" required><br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>

    <button type="submit">Login</button>
</form>

<p style="color:red;">
    <%= request.getAttribute("error") == null ? "" : request.getAttribute("error") %>
</p>

</body>
</html>
