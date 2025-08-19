<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Add Item • Pahana Edu Billing</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="css/styles.css"/>

  <style>
    :root{
      --brand:#3546a7; --brand-2:#6e87ff; --ink:#101319; --muted:#6b7280;
      --bg:#f5f7fb; --card:#fff; --border:#e7e9f5; --shadow:0 10px 30px rgba(16,19,25,.08);
      --radius:14px;
    }
    html,body{background:var(--bg); color:var(--ink); font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif; margin:0}
    a{color:inherit; text-decoration:none}

    /* Navbar */
    .navbar{position:sticky; top:0; z-index:5; background:linear-gradient(90deg,var(--brand),var(--brand-2)); color:#fff; padding:14px 18px; box-shadow:var(--shadow)}
    .nav-inner{max-width:1200px; margin:0 auto; display:flex; align-items:center; gap:12px}
    .brand{display:flex; align-items:center; gap:10px; font-weight:700}
    .brand .logo{width:34px; height:34px; border-radius:9px; background:#ffffff1a; display:grid; place-items:center; border:1px solid #ffffff22}
    .brand span{font-size:18px; letter-spacing:.2px}
    .nav-spacer{flex:1}
    .logout{background:#ffffff1e; border:1px solid #ffffff33; color:#fff; padding:8px 14px; border-radius:10px; font-weight:600; transition:.2s}
    .logout:hover{background:#ffffff33}

    /* Layout */
    .container{max-width:1200px; margin:24px auto; padding:0 18px; display:flex; flex-direction:column; gap:18px; align-items:center}
    .hero{background:radial-gradient(1200px 300px at 70% -20%, #c9d2ff55, transparent), linear-gradient(180deg,#ffffff 0%, #f3f6ff 100%); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); padding:18px; width:100%; max-width:900px}
    .hero h1{margin:0 0 6px; font-size:24px}
    .hero p{margin:0; color:var(--muted); font-size:13px}

    .panel{background:var(--card); border:1px solid var(--border); border-radius:12px; box-shadow:var(--shadow); padding:18px; width:100%; max-width:700px}
    .panel h3{margin:0 0 8px}
    .sub{color:var(--muted); font-size:13px; margin:0 0 14px}

    /* Form */
    .form{display:grid; gap:12px}
    .label{font-size:13px; font-weight:600; color:var(--muted)}
    .input{width:100%; padding:12px; border:1px solid var(--border); border-radius:10px; background:#fff; font-size:15px}
    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:6px}
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid var(--border); background:#fff; transition:.2s; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.secondary{background:#f3f4f6}
    .btn:hover{transform:translateY(-1px)}

    .alert{background:#fff7ed; color:#92400e; border:1px solid #fed7aa; padding:10px 12px; border-radius:10px; font-size:14px; width:100%; max-width:700px}
    .footer{margin:24px 0; color:#6b7280; font-size:12px; text-align:center}
  </style>
</head>
<body>

  <!-- NAV -->
  <div class="navbar">
    <div class="nav-inner">
      <div class="brand">
        <div class="logo">📚</div>
        <a href="<%= request.getContextPath() %>/dashboard"><span>Pahana Edu • Billing</span></a>
      </div>
      <div class="nav-spacer"></div>
      <a class="logout" href="login.jsp">Logout</a>
    </div>
  </div>

  <div class="container">
    <!-- Hero -->
    <section class="hero">
      <h1>Add New Item</h1>
      <p>Create a new inventory item for billing. Unit price uses two decimals.</p>
    </section>

    <!-- Optional error banner -->
    <%
      String err = request.getParameter("error");
      if (err != null) {
    %>
      <div class="alert">Could not save the item. Please check the details and try again.</div>
    <% } %>

    <!-- Form -->
    <section class="panel">
      <h3>Item Details</h3>
      <p class="sub">Fields marked * are required</p>

      <form class="form" action="AddItemServlet" method="post">
        <label class="label" for="iname">Item Name *</label>
        <input id="iname" class="input" type="text" name="item_name" placeholder="e.g., A4 Exercise Book" required autofocus>

        <label class="label" for="uprice">Unit Price (Rs.) *</label>
        <input id="uprice" class="input" type="number" step="0.01" min="0.00" name="unit_price" placeholder="e.g., 250.00" required>

        <div class="actions">
          <button class="btn primary" type="submit">Save Item</button>
          <a class="btn secondary" href="itemList.jsp">Back to Item List</a>
          <a class="btn secondary" href="<%= request.getContextPath() %>/dashboard">Back to Dashboard</a>
        </div>
      </form>
    </section>

    <div class="footer">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System
    </div>
  </div>

</body>
</html>
