<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="model.DBConnection"%>
<%
    String accountNumber = request.getParameter("accountNumber");
    String name = "";
    String address = "";
    String telephone = "";

    if (accountNumber != null) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM customers WHERE account_number = ?");
            ps.setString(1, accountNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                address = rs.getString("address");
                telephone = rs.getString("telephone");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer</title>
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
            color: #fff;
            text-align: center;
        }
        .container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        input {
            padding: 10px;
            margin: 8px 0;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        button {
            padding: 12px;
            background: #4b2c2c;
            color: white;
            border: none;
            border-radius: 4px;
            margin-top: 10px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #2e1a1a;
        }
        .back-button {
            margin-top: 15px;
            text-align: center;
        }
        .back-button a {
            background: #777;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .back-button a:hover {
            background: #555;
        }
    </style>
</head>
<body>

    <div class="navbar">Online Billing System - Edit Customer</div>

    <div class="container">
        <h1>Edit Customer</h1>
        <form action="UpdateCustomerServlet" method="post">
            <input type="hidden" name="accountNumber" value="<%=accountNumber%>">
            <input type="text" name="name" value="<%=name%>" placeholder="Name" required>
            <input type="text" name="address" value="<%=address%>" placeholder="Address" required>
            <input type="text" name="telephone" value="<%=telephone%>" placeholder="Telephone">
            <button type="submit">Update</button>
        </form>

        <div class="back-button">
            <a href="customerList.jsp">Back to Customer List</a>
        </div>
    </div>

</body>
</html>
