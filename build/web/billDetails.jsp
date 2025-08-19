<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, model.DBConnection, java.text.DecimalFormat, java.text.SimpleDateFormat, java.util.Date"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Bill Details • Pahana Edu Billing</title>
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

    /* Navbar */
    .navbar{position:sticky; top:0; z-index:5; background:linear-gradient(90deg,var(--brand),var(--brand-2)); color:#fff; padding:14px 18px; box-shadow:var(--shadow)}
    .nav-inner{max-width:1200px; margin:0 auto; display:flex; align-items:center; gap:12px}
    .brand{display:flex; align-items:center; gap:10px; font-weight:700}
    .brand .logo{width:34px; height:34px; border-radius:9px; background:#ffffff1a; display:grid; place-items:center; border:1px solid #ffffff22}
    .brand span{font-size:18px; letter-spacing:.2px}
    .nav-spacer{flex:1}
    .logout{background:#ffffff1e; border:1px solid #ffffff33; color:#fff; padding:8px 14px; border-radius:10px; font-weight:600; transition:.2s}
    .logout:hover{background:#ffffff33}

    .container{max-width:1200px; margin:24px auto; padding:0 18px}
    .panel{background:var(--card); border:1px solid var(--border); border-radius:12px; box-shadow:var(--shadow); padding:18px}
    .header{display:flex; justify-content:space-between; gap:16px; flex-wrap:wrap; border-bottom:1px dashed #eceef7; padding-bottom:12px; margin-bottom:12px}
    .h-left h1{margin:0 0 4px; font-size:22px}
    .meta{color:var(--muted); font-size:13px}
    .amount{font-weight:800; font-size:22px}
    .badge{display:inline-block; padding:6px 10px; border:1px solid var(--border); border-radius:999px; font-weight:700; font-size:12px; background:#f8f9ff}
    .table{width:100%; border-collapse:collapse}
    .table th,.table td{border-bottom:1px dashed #eceef7; padding:10px 6px; text-align:left; font-size:14px}
    .table th{color:var(--muted); font-weight:600}
    .right{text-align:right}
    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:16px}
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid var(--border); background:#fff; transition:.2s; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.secondary{background:#f3f4f6}
    .btn.warn{background:#ef4444; color:#fff; border-color:#ef4444}
    .btn:hover{transform:translateY(-1px)}
    .alert{background:#fff7ed; color:#92400e; border:1px solid #fed7aa; padding:10px 12px; border-radius:10px; font-size:14px; margin-bottom:12px}

    /* Print */
    @media print{
      .navbar, .actions{display:none !important}
      .container{margin:0; max-width:none; padding:0}
      body{background:#fff}
      .panel{box-shadow:none; border:none}
    }
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

<%
  // Helpers
  DecimalFormat money = new DecimalFormat("#,##0.00");
  SimpleDateFormat dts = new SimpleDateFormat("yyyy-MM-dd HH:mm");

  // Parse and validate bill_id
  String billParam = request.getParameter("bill_id");
  Integer billId = null;
  try { billId = (billParam == null ? null : Integer.valueOf(billParam.trim())); } catch (Exception ignore) {}

  if (billId == null) {
%>
    <div class="panel">
      <div class="alert">No or invalid bill ID provided.</div>
      <div class="actions">
        <a class="btn secondary" href="billList.jsp">Back to Bill List</a>
      </div>
    </div>
  </div>
</body>
</html>
<%  return; } %>

<%
  String billNo = null, customerName = null;
  String billedAtStr = null;
  Double totalAmount = null;

  // Load header + items
  boolean billFound = false;
  try (Connection con = DBConnection.getConnection()) {
      // Header
      String hSql = "SELECT b.id, c.name AS customer_name, b.billing_date, b.total_amount " +
                    "FROM bills b JOIN customers c ON c.id = b.customer_id WHERE b.id = ?";
      try (PreparedStatement ps = con.prepareStatement(hSql)) {
          ps.setInt(1, billId);
          try (ResultSet rs = ps.executeQuery()) {
              if (rs.next()) {
                  billFound = true;
                  int id = rs.getInt("id");
                  billNo = "B" + String.format("%05d", id);
                  customerName = rs.getString("customer_name");
                  // try TIMESTAMP then DATE
                  java.sql.Timestamp ts = null;
                  Date billedAt = null;
                  try { ts = rs.getTimestamp("billing_date"); } catch (Exception ignored) {}
                  if (ts != null) billedAt = new Date(ts.getTime());
                  if (billedAt == null) {
                      java.sql.Date d = rs.getDate("billing_date");
                      if (d != null) billedAt = new Date(d.getTime());
                  }
                  billedAtStr = (billedAt != null) ? dts.format(billedAt) : rs.getString("billing_date");
                  totalAmount = rs.getDouble("total_amount");
              }
          }
      }
%>

  <div class="panel">
<%
      if (!billFound) {
%>
    <div class="alert">Bill not found.</div>
    <div class="actions">
      <a class="btn secondary" href="billList.jsp">Back to Bill List</a>
    </div>
  </div>
</div>
</body>
</html>
<%
        return;
      }
%>

    <!-- Header -->
    <div class="header">
      <div class="h-left">
        <h1>Invoice <span class="badge"><%= billNo %></span></h1>
        <div class="meta">Customer: <strong><%= customerName %></strong></div>
        <div class="meta">Date: <strong><%= billedAtStr %></strong></div>
      </div>
      <div class="h-right">
        <div class="meta">Total</div>
        <div class="amount">Rs. <%= money.format(totalAmount) %></div>
      </div>
    </div>

    <!-- Line items -->
    <table class="table">
      <thead>
        <tr>
          <th>Item</th>
          <th class="right" style="width:140px">Unit Price (Rs.)</th>
          <th style="width:100px">Qty</th>
          <th class="right" style="width:160px">Line Total (Rs.)</th>
        </tr>
      </thead>
      <tbody>
<%
      String iSql = "SELECT i.item_name, i.unit_price, bi.quantity, bi.line_total " +
                    "FROM bill_items bi JOIN items i ON i.id = bi.item_id " +
                    "WHERE bi.bill_id = ? ORDER BY i.item_name";
      try (PreparedStatement ps = con.prepareStatement(iSql)) {
          ps.setInt(1, billId);
          try (ResultSet rs = ps.executeQuery()) {
              int rows = 0;
              while (rs.next()) {
                  rows++;
                  String itemName = rs.getString("item_name");
                  double uprice   = rs.getDouble("unit_price");
                  int qty         = rs.getInt("quantity");
                  double ltotal   = rs.getDouble("line_total");
%>
        <tr>
          <td><%= itemName %></td>
          <td class="right">Rs. <%= money.format(uprice) %></td>
          <td><%= qty %></td>
          <td class="right">Rs. <%= money.format(ltotal) %></td>
        </tr>
<%
              }
              if (rows == 0) {
%>
        <tr><td colspan="4" style="color:#6b7280">No line items.</td></tr>
<%
              }
          }
      }
  } catch (Exception e) {
%>
      <tr>
        <td colspan="4"><div class="alert">Error loading bill: <%= e.getMessage() %></div></td>
      </tr>
<%
  }
%>
      </tbody>
    </table>

    <!-- Actions -->
    <div class="actions">
      <button class="btn primary" onclick="window.print()">Print</button>
      <a class="btn" href="GenerateBillPDFServlet?bill_id=<%= billId %>" target="_blank">Download PDF</a>
      <a class="btn secondary" href="billList.jsp">Back to Bill List</a>

      <!-- Optional: Delete here too (POST + confirm) -->
      <form action="DeleteBillServlet" method="post"
            onsubmit="return confirm('Delete bill <%= billNo %>? This action cannot be undone.');">
        <input type="hidden" name="bill_id" value="<%= billId %>"/>
        <button class="btn warn" type="submit">Delete Bill</button>
      </form>
    </div>

  </div> <!-- /panel -->

    <div style="margin:24px 0; color:#6b7280; font-size:12px; text-align:center">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System
    </div>
  </div> <!-- /container -->
</body>
</html>
