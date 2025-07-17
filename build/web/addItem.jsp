<!DOCTYPE html>
<html>
<head>
    <title>Add Item</title>
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

<div class="navbar">Online Billing System - Add Item</div>

<div class="container">
    <h1>Add New Item</h1>

    <form action="AddItemServlet" method="post">
        <input type="text" name="item_name" placeholder="Item Name" required>
        <input type="number" step="0.01" name="unit_price" placeholder="Unit Price" required>
        <button type="submit">Save</button>
    </form>

    <div class="back-button">
        <a href="itemList.jsp">Back to Item List</a>
    </div>
</div>

</body>
</html>
