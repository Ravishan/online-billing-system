<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, model.DBConnection, java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Items • Pahana Edu Billing</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="css/styles.css"/>

  <style>
    :root{
      --brand:#3546a7; --brand-2:#6e87ff; --ink:#101319; --muted:#6b7280;
      --bg:#f5f7fb; --card:#fff; --border:#e7e9f5; --shadow:0 10px 30px rgba(16,19,25,.08);
      --radius:14px; --ok:#1bb57a; --warn:#f59e0b;
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

    .container{max-width:1200px; margin:24px auto; padding:0 18px}
    .hero{background:radial-gradient(1200px 300px at 70% -20%, #c9d2ff55, transparent), linear-gradient(180deg,#ffffff 0%, #f3f6ff 100%); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); padding:18px}
    .hero h1{margin:0 0 6px; font-size:24px}
    .hero p{margin:0; color:var(--muted); font-size:13px}
    .hero-actions{margin-top:12px; display:flex; gap:10px; flex-wrap:wrap}
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid var(--border); background:#fff; transition:.2s; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.warn{background:#ef4444; color:#fff; border-color:#ef4444}
    .btn.secondary{background:#f3f4f6}
    .btn:hover{transform:translateY(-1px)}

    .panel{background:var(--card); border:1px solid var(--border); border-radius:12px; box-shadow:var(--shadow); padding:18px}
    .toolbar{display:flex; gap:10px; justify-content:space-between; align-items:center; margin-bottom:12px; flex-wrap:wrap}
    .search{display:flex; gap:8px; align-items:center}
    .input{padding:10px 12px; border:1px solid var(--border); border-radius:10px; background:#fff; min-width:260px}
    .table{width:100%; border-collapse:collapse}
    .table th,.table td{border-bottom:1px dashed #eceef7; padding:10px 6px; text-align:left; font-size:14px}
    .table th{color:var(--muted); font-weight:600}
    .alert{background:#eafaf2; color:#124d35; border:1px solid #cceedd; padding:12px 14px; border-radius:10px; margin:14px 0}
    .alert.warn{background:#fff7ed; color:#92400e; border-color:#fed7aa}
    .footer{margin:24px 0; color:#6b7280; font-size:12px; text-align:center}

    .actions{display:flex; gap:8px; align-items:center}
    .actions form{display:inline}
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
      <h1>Items</h1>
      <p>Manage your bookstore inventory and unit prices.</p>
      <div class="hero-actions">
        <a class="btn primary" href="addItem.jsp">+ Add Item</a>
        <a class="btn secondary" href="<%= request.getContextPath() %>/dashboard">Back to Dashboard</a>
      </div>
    </section>

    <!-- Success / info banners -->
    <%
      String itemFlash = (String) session.getAttribute("itemSuccess");
      if (itemFlash != null) {
    %>
      <div class="alert"><%= itemFlash %></div>
    <%
        session.removeAttribute("itemSuccess");
      }

      if ("1".equals(request.getParameter("success"))) {
    %>
      <div class="alert">Item added successfully.</div>
    <% } else if ("1".equals(request.getParameter("updated"))) { %>
      <div class="alert">Item updated successfully.</div>
    <% } else if ("1".equals(request.getParameter("deleted"))) { %>
      <div class="alert">Item deleted successfully.</div>
    <% } %>

    <!-- Extra banners for delete edge-cases -->
    <% if (request.getParameter("notfound") != null) { %>
      <div class="alert warn">Item not found.</div>
    <% } %>
    <% if (request.getParameter("blocked") != null) { %>
      <div class="alert warn">Cannot delete: this item is used in bill items.</div>
    <% } %>
    <% 
       String err = request.getParameter("error");
       if ("1".equals(err)) {
    %>
      <div class="alert warn">An error occurred while processing your request.</div>
    <% } else if ("bad_id".equals(err)) { %>
      <div class="alert warn">Invalid item id.</div>
    <% } else if ("bad_method".equals(err)) { %>
      <div class="alert warn">Delete must be performed via POST.</div>
    <% } %>

    <!-- List Panel -->
    <section class="panel">
      <div class="toolbar">
        <form class="search" method="get" action="itemList.jsp">
          <input class="input" type="text" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"
                 placeholder="Search by name…"/>
          <button class="btn" type="submit">Search</button>
          <a class="btn" href="itemList.jsp">Clear</a>
        </form>
        <div></div>
      </div>

      <table class="table">
        <thead>
          <tr>
            <th>Item Name</th>
            <th style="width:140px">Unit Price (Rs.)</th>
            <th style="width:240px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
            String q = request.getParameter("q");
            boolean hasQ = (q != null && !q.trim().isEmpty());
            int rowCount = 0;
            DecimalFormat df = new DecimalFormat("#,##0.00");

            try (Connection con = DBConnection.getConnection()) {
                String sql = hasQ
                  ? "SELECT id, item_name, unit_price FROM items WHERE item_name LIKE ? ORDER BY item_name"
                  : "SELECT id, item_name, unit_price FROM items ORDER BY item_name";

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    if (hasQ) ps.setString(1, "%" + q.trim() + "%");
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            rowCount++;
                            int id = rs.getInt("id");
                            String name = rs.getString("item_name");
                            String price = df.format(rs.getDouble("unit_price"));
          %>
          <tr>
            <td><%= name %></td>
            <td>Rs. <%= price %></td>
            <td class="actions">
              <a class="btn" href="editItem.jsp?id=<%= id %>">Edit</a>

              <!-- POST + confirm delete -->
              <form action="DeleteItemServlet" method="post"
                    onsubmit="return confirm('Delete item &quot;<%= name %>&quot;? This action cannot be undone.');">
                <input type="hidden" name="id" value="<%= id %>"/>
                <button type="submit" class="btn warn">Delete</button>
              </form>
            </td>
          </tr>
          <%
                        }
                    }
                }
            } catch (Exception e) {
          %>
          <tr>
            <td colspan="3">
              <div class="alert warn">Error loading items: <%= e.getMessage() %></div>
            </td>
          </tr>
          <%
            }
            if (rowCount == 0) {
          %>
          <tr>
            <td colspan="3" style="color:#6b7280">No items found.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </section>

    <div class="footer">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System
    </div>
  </div>
</body>
</html>
