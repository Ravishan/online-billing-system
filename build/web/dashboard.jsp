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
            justify-content: center;
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
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card button {
    text-decoration: none;
    color: white;
    background-color: #444; /* match navbar gray */
    padding: 10px 18px;
    border-radius: 6px;
    display: inline-block;
    margin: 10px 5px 0;
    font-weight: bold;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    transition: background 0.3s, transform 0.2s, box-shadow 0.2s;
    width: 150px;
    cursor: pointer;
}

.card button:hover {
    background-color: #222; /* darker on hover */
    transform: translateY(-3px);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

.card img{
    width: 148px;
    height: 148px;
}
.nav-inner{
    display: flex;
    justify-content: space-between;
    width: 100%;
    max-width: 1440px;
    align-items: center;
    align-self: center;
}
    


    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-inner">
            <h1>Online Billing System</h1>
        <div>
            <a href="login.jsp" style="color:white; text-decoration: none;">Logout</a>
        </div>
            
        </div>
        
    </div>

    <div class="dashboard-container">

    <%
        String successMessage = (String) session.getAttribute("loginSuccess");
        if (successMessage != null) {
    %>
        <div style="background: #d4edda; color: #155724; padding: 1rem; border: 1px solid #c3e6cb; border-radius: 5px; margin-bottom: 1.5rem;">
            <%= successMessage %>
        </div>
    <%
            session.removeAttribute("loginSuccess");
        }
    %>
        <div class="card-grid">
           <!-- Customers Card -->
<!-- Customers Card -->
<div class="card">
  <img src="Icons/Customer.png" alt="Customer Icon" class="icon" />
  <h2>Customers</h2>
  <a href="addCustomer.jsp"><button>Add Customer</button></a>
  <a href="customerList.jsp"><button>Customer List</button></a>
</div>

<!-- Items Card -->
<div class="card">
  <img src="Icons/Item.png" alt="Item Icon" class="icon" />
  <h2>Items</h2>
  <a href="addItem.jsp"><button>Add Item</button></a>
  <a href="itemList.jsp"><button>Item List</button></a>
</div>

<!-- Bills Card -->
<div class="card">
  <img src="Icons/Bill.png" alt="Bill Icon" class="icon" />
  <h2>Bills</h2>
  <a href="addBill.jsp"><button>Add Bill</button></a>
  <a href="billList.jsp"><button>Bill List</button></a>
</div>


            </div>
        </div>
    </div>
</body>
</html>
