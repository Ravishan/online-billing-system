<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, model.DBConnection, java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Edit Item • Pahana Edu Billing</title>
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

    .container{max-width:1200px; margin:24px auto; padding:0 18px; display:flex; flex-direction:column; gap:18px}
    .hero{background:radial-gradient(1200px 300px at 70% -20%, #c9d2ff55, transparent), linear-gradient(180deg,#ffffff 0%, #f3f6ff 100%); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); padding:18px}
    .hero h1{margin:0 0 6px; font-size:24px}
    .hero p{margin:0; color:var(--muted); font-size:13px}

    .panel{background:var(--card); border:1px solid var(--border); border-radius:12px; box-shadow:var(--shadow); padding:18px; max-width:720px}
    .panel h3{margin:0 0 8px}
    .sub{color:var(--muted); font-size:13px; margin:0 0 14px}

    .form{display:grid; gap:12px}
    .label{font-size:13px; font-weight:600; color:var(--muted)}
    .input{ padding:12px; border:1px solid var(--border); border-radius:10px; background:#fff; font-size:15px}
    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:6px}
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid var(--border); background:#fff; transition:.2s; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.secondary{background:#f3f4f6}
    .btn:hover{transform:translateY(-1px)}

    .alert{background:#fff7ed; color:#92400e; border:1px solid #fed7aa; padding:10px 12px; border-radius:10px; font-size:14px}
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
      <h1>Edit Item</h1>
      <p>Update the item’s name or unit price.</p>
    </section>

<%
    // Validate id param
    String idParam = request.getParameter("id");
    Integer id = null;
    if (idParam != null) {
        try { id = Integer.valueOf(idParam.trim()); } catch (Exception ignore) {}
    }
    if (id == null) {
%>
    <div class="panel alert">Invalid or missing item ID. Please open this page from the Item List.</div>
    <div><a class="btn secondary" href="itemList.jsp">Back to Item List</a></div>
  </div>
</body>
</html>
<%  return; } %>

<%
    // Load item
    String itemName = null;
    Double unitPrice = null;
    String priceStr = "";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT item_name, unit_price FROM items WHERE id = ?")) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                itemName = rs.getString("item_name");
                unitPrice = rs.getDouble("unit_price");
            }
        }
    } catch (Exception e) {
%>
    <div class="panel alert">Error loading item: <%= e.getMessage() %></div>
    <div><a class="btn secondary" href="itemList.jsp">Back to Item List</a></div>
  </div>
</body>
</html>
<%  return; }

    if (itemName == null) {
%>
    <div class="panel alert">Item not found.</div>
    <div><a class="btn secondary" href="itemList.jsp">Back to Item List</a></div>
  </div>
</body>
</html>
<%  return; }

    // Format price for input
    DecimalFormat df = new DecimalFormat("#0.00");
    priceStr = df.format(unitPrice);
%>

    <!-- Edit Form -->
    <section class="panel">
      <h3>Item Details</h3>
      <p class="sub">Fields marked * are required</p>

      <form class="form" action="UpdateItemServlet" method="post">
        <input type="hidden" name="id" value="<%= id %>"/>

        <label class="label" for="iname">Item Name *</label>
        <input id="iname" class="input" type="text" name="item_name" value="<%= itemName %>" required>

        <label class="label" for="uprice">Unit Price (Rs.) *</label>
        <input id="uprice" class="input" type="number" step="0.01" min="0.00" name="unit_price" value="<%= priceStr %>" required>

        <div class="actions">
          <button class="btn primary" type="submit">Update Item</button>
          <a class="btn secondary" href="itemList.jsp">Back to Item List</a>
        </div>
      </form>
    </section>

    <div style="margin:24px 0; color:#6b7280; font-size:12px; text-align:center">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System
    </div>
  </div>
</body>
</html>
