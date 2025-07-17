<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bill Details</title>
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
            max-width: 800px;
            margin: 40px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }
        h1, h2 {
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
        .button-group {
            text-align: center;
            margin-top: 20px;
        }
        .button-group a, .button-group button {
            background: #4b2c2c;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            margin: 5px;
            display: inline-block;
            cursor: pointer;
        }
        .button-group a:hover, .button-group button:hover {
            background: #2e1a1a;
        }
    </style>
</head>
<body>

<div class="navbar">Online Billing System - Bill Details</div>

<div class="container">
<%
    String billIdParam = request.getParameter("bill_id");
    if (billIdParam == null) {
        out.println("<p style='color:red;'>No bill ID provided.</p>");
    } else {
        int billId = Integer.parseInt(billIdParam);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");

            String billQuery = "SELECT b.id, c.name AS customer_name, b.billing_date, b.total_amount " +
                               "FROM bills b INNER JOIN customers c ON b.customer_id = c.id WHERE b.id = ?";
            PreparedStatement billPs = con.prepareStatement(billQuery);
            billPs.setInt(1, billId);
            ResultSet billRs = billPs.executeQuery();

            if (billRs.next()) {
%>
    <h1>Bill Details (ID: <%= billRs.getInt("id") %>)</h1>
    <p>Customer Name: <%= billRs.getString("customer_name") %></p>
    <p>Billing Date: <%= billRs.getString("billing_date") %></p>
    <p>Total Amount: <%= billRs.getDouble("total_amount") %></p>

    <h2>Items</h2>
    <table>
        <tr>
            <th>Item Name</th>
            <th>Unit Price</th>
            <th>Quantity</th>
            <th>Line Total</th>
        </tr>
<%
                String itemsQuery = "SELECT i.item_name, i.unit_price, bi.quantity, bi.line_total " +
                                    "FROM bill_items bi INNER JOIN items i ON bi.item_id = i.id " +
                                    "WHERE bi.bill_id = ?";
                PreparedStatement itemsPs = con.prepareStatement(itemsQuery);
                itemsPs.setInt(1, billId);
                ResultSet itemsRs = itemsPs.executeQuery();

                while (itemsRs.next()) {
%>
        <tr>
            <td><%= itemsRs.getString("item_name") %></td>
            <td><%= itemsRs.getDouble("unit_price") %></td>
            <td><%= itemsRs.getInt("quantity") %></td>
            <td><%= itemsRs.getDouble("line_total") %></td>
        </tr>
<%
                }
            } else {
                out.println("<p style='color:red;'>Bill not found.</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>
    </table>

    <div class="button-group">
        <button onclick="window.print()">Print Bill</button>
        <a href="GenerateBillPDFServlet?bill_id=<%= billIdParam %>" target="_blank">Download as PDF</a>
        <a href="billList.jsp">Back to Bill List</a>
    </div>
</div>

</body>
</html>