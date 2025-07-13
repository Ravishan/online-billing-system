<%-- 
    Document   : login
    Created on : Jul 13, 2025, 2:26:14 PM
    Author     : ravishan99
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

<form action="LoginServlet" method="post">
    <h1>Login</h1>
    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Login</button>

    <% if (request.getParameter("error") != null) { %>
        <p style="color:red;">Invalid Username or Password</p>
    <% } %>
</form>

</body>
</html>



