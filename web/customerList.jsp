<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer List</title>
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
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table th, table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        table th {
            background: #4b2c2c;
            color: white;
        }
        table tr:hover {
            background: #f9f9f9;
        }
        .edit-link {
            background: #4b2c2c;
            color: white;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            transition: background 0.3s ease;
        }
        .edit-link:hover {
            background: #2e1a1a;
        }
        .back-button {
            margin-top: 20px;
            display: inline-block;
            background: #777;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
        }
        .back-button:hover {
            background: #555;
        }
    </style>
</head>
<body>

    <div class="navbar">Online Billing System - Customer List</div>

    <div class="container">
        <h1>Customer List</h1>

        <table>
            <tr>
                <th>Account Number</th>
                <th>Name</th>
                <th>Address</th>
                <th>Telephone</th>
                <th>Actions</th>
            </tr>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery("SELECT * FROM customers");

                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("account_number") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("address") %></td>
                <td><%= rs.getString("telephone") %></td>
                <td>
                    <a class="edit-link" href="editCustomer.jsp?accountNumber=<%= rs.getString("account_number") %>">Edit</a>
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

        <a href="dashboard.jsp" class="back-button">Back to Dashboard</a>
    </div>

</body>
</html>
