<%-- 
    Document   : addCustomer
    Created on : Jul 13, 2025, 5:48:24 PM
    Author     : ravishan99
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Add Customer</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

    <form action="AddCustomerServlet" method="post">
        <h1>Add Customer</h1>
        <input type="text" name="accountNumber" placeholder="Account Number" required>
        <input type="text" name="name" placeholder="Name" required>
        <input type="text" name="address" placeholder="Address" required>
        <input type="text" name="telephone" placeholder="Telephone">
        <button type="submit">Save</button>
    </form>

</body>
</html>

