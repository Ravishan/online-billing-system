<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, model.DBConnection, java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Bills • Pahana Edu Billing</title>
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
    .right{text-align:right}

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
      <h1>Bills</h1>
      <p>Browse, search, view and manage invoices.</p>
      <div class="hero-actions">
        <a class="btn primary" href="addBill.jsp">+ Create Bill</a>
        <a class="btn secondary" href="<%= request.getContextPath() %>/dashboard">Back to Dashboard</a>
      </div>
    </section>

    <!-- Success / info banners -->
    <%
      String billFlash = (String) session.getAttribute("billSuccess");
      if (billFlash != null) {
    %>
      <div class="alert"><%= billFlash %></div>
    <%
        session.removeAttribute("billSuccess");
      }

      if ("1".equals(request.getParameter("success"))) {
    %>
      <div class="alert">Bill submitted successfully.</div>
    <% } else if ("1".equals(request.getParameter("deleted"))) { %>
      <div class="alert">Bill deleted successfully.</div>
    <% } %>

    <% if (request.getParameter("notfound") != null) { %>
      <div class="alert warn">Bill not found.</div>
    <% } %>
    <% if (request.getParameter("blocked") != null) { %>
      <div class="alert warn">Cannot delete: this bill has dependent records.</div>
    <% } %>
    <%
      String err = request.getParameter("error");
      if ("1".equals(err)) {
    %>
      <div class="alert warn">An error occurred while processing your request.</div>
    <% } else if ("bad_id".equals(err)) { %>
      <div class="alert warn">Invalid bill id.</div>
    <% } else if ("bad_method".equals(err)) { %>
      <div class="alert warn">Delete must be performed via POST.</div>
    <% } %>

    <!-- List Panel -->
    <section class="panel">
      <div class="toolbar">
        <form class="search" method="get" action="billList.jsp">
          <input class="input" type="text" name="q"
                 value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"
                 placeholder="Search by Bill No, customer, or date (YYYY-MM-DD)…"/>
          <button class="btn" type="submit">Search</button>
          <a class="btn" href="billList.jsp">Clear</a>
        </form>
        <div></div>
      </div>

      <table class="table">
        <thead>
          <tr>
            <th style="width:140px">Bill No</th>
            <th>Customer</th>
            <th style="width:180px">Billing Date</th>
            <th class="right" style="width:160px">Total (Rs.)</th>
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
                String sql = 
                    "SELECT b.id, c.name AS customer_name, b.billing_date, b.total_amount " +
                    "FROM bills b JOIN customers c ON c.id = b.customer_id ";
                if (hasQ) {
                    sql += "WHERE c.name LIKE ? " +
                           "   OR CONCAT('B', LPAD(b.id, 5, '0')) LIKE ? " +
                           "   OR DATE_FORMAT(b.billing_date, '%Y-%m-%d') LIKE ? ";
                }
                sql += "ORDER BY b.billing_date DESC, b.id DESC";

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    if (hasQ) {
                        String like = "%" + q.trim() + "%";
                        ps.setString(1, like);
                        ps.setString(2, like);
                        ps.setString(3, like);
                    }
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            rowCount++;
                            int billId = rs.getInt("id");
                            String billNo = "B" + String.format("%05d", billId);
                            String customer = rs.getString("customer_name");
                            String billDate = rs.getString("billing_date"); // show as-is
                            String totalStr = df.format(rs.getDouble("total_amount"));
          %>
          <tr>
            <td><%= billNo %></td>
            <td><%= customer %></td>
            <td><%= billDate %></td>
            <td class="right">Rs. <%= totalStr %></td>
            <td class="actions">
              <a class="btn" href="billDetails.jsp?bill_id=<%= billId %>">View</a>

              <!-- POST + confirm delete -->
              <form action="DeleteBillServlet" method="post"
                    onsubmit="return confirm('Delete bill <%= billNo %>? This action cannot be undone.');">
                <input type="hidden" name="bill_id" value="<%= billId %>"/>
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
            <td colspan="5">
              <div class="alert warn">Error loading bills: <%= e.getMessage() %></div>
            </td>
          </tr>
          <%
            }
            if (rowCount == 0) {
          %>
          <tr>
            <td colspan="5" style="color:#6b7280">No bills found.</td>
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
