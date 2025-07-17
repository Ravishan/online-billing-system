<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Add Customer</title>
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
        .form-container {
            max-width: 500px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }
        .form-container h1 {
            margin-bottom: 20px;
            color: #333;
        }
        .form-container input {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .form-container button {
            width: 100%;
            padding: 12px;
            background: #4b2c2c;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        .form-container button:hover {
            background: #3a2222;
        }
        .back-button {
            display: block;
            width: 100%;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            background: #777;
            color: white;
            padding: 10px;
            border-radius: 4px;
        }
        .back-button:hover {
            background: #555;
        }
    </style>
</head>
<body>

    <div class="navbar">Online Billing System</div>

    <div class="form-container">
        <form action="AddCustomerServlet" method="post">
            <h1>Add Customer</h1>
            <input type="text" name="accountNumber" placeholder="Account Number" required>
            <input type="text" name="name" placeholder="Name" required>
            <input type="text" name="address" placeholder="Address" required>
            <input type="text" name="telephone" placeholder="Telephone">
            <button type="submit">Save</button>
        </form>

        <a href="dashboard.jsp" class="back-button">Back to Dashboard</a>
    </div>

</body>
</html>
