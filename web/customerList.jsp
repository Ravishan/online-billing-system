<%-- 
    Document   : customerList
    Created on : Jul 13, 2025, 5:48:57 PM
    Author     : ravishan99
--%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/styles.css">
    <title>Customer List</title>
</head>
<body>

<h1>Customer List</h1>

<table border="1">
    <tr>
        <th>Account Number</th>
        <th>Name</th>
        <th>Address</th>
        <th>Telephone</th>
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
    </tr>
<%
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

</table>

</body>
</html>

