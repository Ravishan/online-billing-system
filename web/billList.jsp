<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bill List</title>
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
            max-width: 1000px;
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

<div class="navbar">Online Billing System - Bill List</div>

<div class="container">
    <h1>Bill List</h1>

    <table>
        <tr>
            <th>Bill ID</th>
            <th>Customer Name</th>
            <th>Billing Date</th>
            <th>Total Amount</th>
            <th>Action</th>
        </tr>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");

            String query = "SELECT b.id, c.name AS customer_name, b.billing_date, b.total_amount " +
                           "FROM bills b INNER JOIN customers c ON b.customer_id = c.id ORDER BY b.id DESC";

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(query);

            while (rs.next()) {
    %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("customer_name") %></td>
            <td><%= rs.getString("billing_date") %></td>
            <td><%= rs.getDouble("total_amount") %></td>
            <td><a href="billDetails.jsp?bill_id=<%= rs.getInt("id") %>">View Details</a></td>
        </tr>
    <%
            }
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
    </table>

    <div class="button-group">
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
