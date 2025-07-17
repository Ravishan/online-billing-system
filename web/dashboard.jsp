<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Online Billing System</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        .navbar {
            background: #333;
            color: white;
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 {
            margin: 0;
            font-size: 1.5rem;
        }
        .dashboard-container {
            max-width: 1200px;
            margin: auto;
            padding: 2rem;
        }
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }
        .card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.2s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Online Billing System</h1>
        <div>
            <a href="login.jsp" style="color:white; text-decoration: none;">Logout</a>
        </div>
    </div>

    <div class="dashboard-container">
        <div class="card-grid">
            <div class="card">
                <h2>Customers</h2>
                <a href="addCustomer.jsp">Add Customer</a>
                <a href="customerList.jsp">Customer List</a>
            </div>
            <div class="card">
                <h2>Items</h2>
                <a href="addItem.jsp">Add Item</a>
                <a href="itemList.jsp">Item List</a>
            </div>
            <div class="card">
                <h2>Bills</h2>
                <a href="addBill.jsp">Add Bill</a>
                <a href="billList.jsp">Bill List</a>
            </div>
        </div>
    </div>
</body>
</html>
