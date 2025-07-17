<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        body {
            background: #f4f4f4;
            font-family: Arial, sans-serif;
            margin: 0;
        }
        .navbar {
            background: #4b2c2c;
            padding: 1rem;
            color: white;
            text-align: center;
        }
        .container {
            max-width: 400px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }
        h1 {
            text-align: center;
            margin-top: 0;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        input, button {
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
        }
        button {
            background: #4b2c2c;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background: #2e1a1a;
        }
        p {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="navbar">Online Billing System - Login</div>

<div class="container">
    <form action="LoginServlet" method="post">
        <h1>Login</h1>
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>

        <% if (request.getParameter("error") != null) { %>
            <p>Invalid Username or Password</p>
        <% } %>
    </form>
</div>

</body>
</html>
