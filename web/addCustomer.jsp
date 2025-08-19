<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Add Customer • Pahana Edu Billing</title>
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

    /* Navbar (same as dashboard) */
    .navbar{position:sticky; top:0; z-index:5; background:linear-gradient(90deg,var(--brand),var(--brand-2)); color:#fff; padding:14px 18px; box-shadow:var(--shadow)}
    .nav-inner{max-width:1200px; margin:0 auto; display:flex; align-items:center; gap:12px}
    .brand{display:flex; align-items:center; gap:10px; font-weight:700}
    .brand .logo{width:34px; height:34px; border-radius:9px; background:#ffffff1a; display:grid; place-items:center; border:1px solid #ffffff22}
    .brand span{font-size:18px; letter-spacing:.2px}
    .nav-spacer{flex:1}
    .logout{background:#ffffff1e; border:1px solid #ffffff33; color:#fff; padding:8px 14px; border-radius:10px; font-weight:600; transition:.2s}
    .logout:hover{background:#ffffff33}

    /* Page layout */
    .container{max-width:1200px; margin:24px auto; padding:0 18px; display:flex; flex-direction:column; align-items:center;}
    .hero{background:radial-gradient(1200px 300px at 70% -20%, #c9d2ff55, transparent), linear-gradient(180deg,#ffffff 0%, #f3f6ff 100%); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); padding:22px; margin-bottom:18px}
    .hero h1{margin:0 0 6px; font-size:24px}
    .hero p{margin:0; color:var(--muted); font-size:13px}

    /* Card */
    .panel{background:var(--card); border:1px solid var(--border); border-radius:12px; box-shadow:var(--shadow); padding:18px; display:flex; flex-direction:column; align-items:center; max-width:800px; width:100%;}
    .panel h3{margin:0 0 8px}
    .sub{color:var(--muted); font-size:13px; margin:0 0 14px}

    /* Form */
    .form{display:grid; gap:12px; width:90%;}
    .label{font-size:13px; font-weight:600; color:var(--muted)}
    .input, .select, textarea{
      width:100%; padding:12px; border:1px solid var(--border);
      border-radius:10px; background:#fff; font-size:15px;
    }
    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:6px}
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid var(--border); background:#fff; transition:.2s; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.secondary{background:#f3f4f6}
    .btn:hover{transform:translateY(-1px)}
    .alert{background:#fff7ed; color:#92400e; border:1px solid #fed7aa; padding:10px 12px; border-radius:10px; font-size:14px; max-width:560px}
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
      <h1>Add Customer</h1>
      <p>Create a new customer record to use when generating bills.</p>
    </section>

    <!-- Error (optional) -->
    <%
      String err = request.getParameter("error");
      if (err != null) {
    %>
      <div class="alert">Could not save the customer. Please check the details and try again.</div>
    <% } %>

    <!-- Form Card -->
    <section class="panel">
      <h3>Customer Details</h3>
      <p class="sub">All fields marked * are required</p>

      <form class="form" action="AddCustomerServlet" method="post">
        <!-- tell servlet where to go after save -->
        <input type="hidden" name="redirect" value="list"/>

        <label class="label" for="acc">Customer ID *</label>
        <input id="acc" class="input" type="text" name="accountNumber" placeholder="e.g., CUST-1001" required autofocus>

        <label class="label" for="name">Name *</label>
        <input id="name" class="input" type="text" name="name" placeholder="Full name" required>

        <label class="label" for="addr">Address *</label>
        <input id="addr" class="input" type="text" name="address" placeholder="Street, City" required>

        <label class="label" for="tel">Telephone</label>
        <input id="tel" class="input" type="text" name="telephone" placeholder="07X-XXXXXXX" pattern="[0-9\\-+ ]{7,15}" title="Enter a valid phone number">

        <div class="actions">
          <button class="btn primary" type="submit">Save Customer</button>
          <a class="btn secondary" href="customerList.jsp">Back to Customer List</a>
        </div>
      </form>
    </section>

    <div style="margin:24px 0; color:#6b7280; font-size:12px; text-align:center">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System
    </div>
  </div>

</body>
</html>
