<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Bill</title>
    <link rel="stylesheet" href="css/styles.css">

    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

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
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        select, input[type=number] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            padding: 12px;
            background: #4b2c2c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #2e1a1a;
        }
        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .item-row input {
            width: 100px;
        }
        .back-link {
            margin-top: 20px;
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

<div class="navbar">Online Billing System - Add Bill</div>

<div class="container">
    <h1>Add Bill</h1>
    <form action="BillServlet" method="post">
        <label for="customerSelect">Customer:</label>
        <select id="customerSelect" name="customer_id" required>
            <% 
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT id, name FROM customers");
                while(rs.next()) {
            %>
                <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
            <% } con.close(); %>
        </select>

        <h3>Items:</h3>
        <% 
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");
            st = con.createStatement();
            rs = st.executeQuery("SELECT * FROM items");
            while(rs.next()) {
        %>
            <div class="item-row">
                <span><%= rs.getString("item_name") %> (Price: <%= rs.getDouble("unit_price") %>)</span>
                <input type="number" name="quantity_<%= rs.getInt("id") %>" value="0" min="0">
            </div>
        <% } con.close(); %>

        <button type="submit">Submit Bill</button>
    </form>

    <div class="back-link">
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>
</div>

<!-- jQuery + Select2 JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    $(document).ready(function() {
        $('#customerSelect').select2({
            placeholder: "Search for a customer",
            allowClear: true
        });
    });
</script>

</body>
</html>
