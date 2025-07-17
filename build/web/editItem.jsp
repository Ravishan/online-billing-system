<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Item</title>
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
            margin-top: 0;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        input, button {
            padding: 10px;
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
        .back-link {
            display: block;
            margin: 20px 0;
            text-align: center;
        }
        .back-link a {
            background: #4b2c2c;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-link a:hover {
            background: #2e1a1a;
        }
    </style>
</head>
<body>

<div class="navbar">Online Billing System - Edit Item</div>

<div class="container">

<%
    int id = Integer.parseInt(request.getParameter("id"));
    String itemName = "";
    double unitPrice = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM items WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            itemName = rs.getString("item_name");
            unitPrice = rs.getDouble("unit_price");
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<h1>Edit Item</h1>

<form action="UpdateItemServlet" method="post">
    <input type="hidden" name="id" value="<%= id %>">
    <input type="text" name="item_name" value="<%= itemName %>" required placeholder="Item Name">
    <input type="number" step="0.01" name="unit_price" value="<%= unitPrice %>" required placeholder="Unit Price">
    <button type="submit">Update</button>
</form>

<div class="back-link">
    <a href="itemList.jsp">Back to Item List</a>
</div>

</div>

</body>
</html>
