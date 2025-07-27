<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Item List</title>
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
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }
        h1 {
            margin-top: 0;
            text-align: center;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ccc;
        }
        a {
            color: #4b2c2c;
            text-decoration: none;
            margin: 0 5px;
            padding: 6px 12px;
            background: #ddd;
            border-radius: 4px;
            display: inline-block;
        }
        a:hover {
            background: #bbb;
        }
        .button-group {
            margin-top: 20px;
            text-align: center;
        }
        .button-group a {
            background: #4b2c2c;
            color: white;
        }
        .button-group a:hover {
            background: #2e1a1a;
        }
    </style>
</head>
<body>

<div class="navbar">Online Billing System - Item List</div>

<div class="container">
    <h1>Item List</h1>

    <%-- ✅ Show success message based on URL parameter --%>
    <%
        String success = request.getParameter("success");
        String updated = request.getParameter("updated");
        String deleted = request.getParameter("deleted");

        if ("1".equals(success)) {
    %>
        <div class="success-message">✅ Item added successfully!</div>
    <%
        } else if ("1".equals(updated)) {
    %>
        <div class="success-message">✏️ Item updated successfully!</div>
    <%
        } else if ("1".equals(deleted)) {
    %>
        <div class="success-message">🗑️ Item deleted successfully!</div>
    <%
        }
    %>

    <div class="button-group">
        <a href="addItem.jsp">Add New Item</a>
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>

    <table>
        <tr>
            <th>Item Name</th>
            <th>Unit Price</th>
            <th>Actions</th>
        </tr>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM items");

            while(rs.next()) {
    %>
        <tr>
            <td><%= rs.getString("item_name") %></td>
            <td><%= rs.getString("unit_price") %></td>
            <td>
                <a href="editItem.jsp?id=<%= rs.getInt("id") %>">Edit</a>
                <a href="DeleteItemServlet?id=<%= rs.getInt("id") %>">Delete</a>
            </td>
        </tr>
    <%
            }
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
    </table>
</div>

</body>
</html>
