<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Pahana Edu – Billing Dashboard</title>
  <link rel="stylesheet" href="css/styles.css"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    :root{ --brand:#3546a7; --brand-2:#6e87ff; --ink:#101319; --muted:#6b7280; --bg:#f5f7fb; --card:#ffffff; --ok:#1bb57a; --warn:#f59e0b; --shadow:0 10px 30px rgba(16,19,25,.08); --radius:14px; }
    *{box-sizing:border-box}
    html,body{margin:0;background:var(--bg);color:var(--ink);font-family: system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif}
    a{color:inherit;text-decoration:none}
    .navbar{position:sticky; top:0; z-index:5; background:linear-gradient(90deg,var(--brand) 0%, var(--brand-2) 100%); color:#fff; padding:14px 18px; box-shadow: var(--shadow);}
    .nav-inner{max-width:1200px;margin:0 auto;display:flex;align-items:center;gap:18px}
    .brand{display:flex;align-items:center;gap:10px;font-weight:700}
    .brand .logo{width:34px;height:34px;border-radius:9px;background:#fff1;display:grid;place-items:center;border:1px solid #ffffff22}
    .brand span{font-size:18px;letter-spacing:.2px}
    .nav-spacer{flex:1}
    .logout{background:#ffffff1e;border:1px solid #ffffff33;color:#fff;padding:8px 14px;border-radius:10px;font-weight:600;transition:.2s;backdrop-filter:saturate(110%) blur(2px)}
    .logout:hover{background:#ffffff33}
    .container{max-width:1200px;margin:24px auto;padding:0 18px}
    .hero{background: radial-gradient(1200px 300px at 70% -20%, #c9d2ff55, transparent), linear-gradient(180deg,#ffffff 0%, #f3f6ff 100%); border:1px solid #e7e9f5;border-radius: var(--radius);box-shadow: var(--shadow);padding:28px; display:grid; grid-template-columns:1.2fr .8fr; gap:26px;}
    .hero h1{margin:0 0 8px 0; font-size:28px}
    .hero p{margin:0;color:var(--muted)}
    .hero-actions{margin-top:18px; display:flex; gap:12px; flex-wrap:wrap}
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px;padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid #e6e8f3;background:#fff; transition:.2s; box-shadow: var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.primary:hover{filter:brightness(.95); transform:translateY(-1px)}
    .btn:hover{transform:translateY(-1px)}
    .hero-illu{background:#fff; border:1px solid #e7e9f5; border-radius:12px; box-shadow: var(--shadow);display:grid; place-items:center; padding:18px;}
    .hero-illu img{max-width:240px; height:auto}
    .kpis{display:grid; grid-template-columns:repeat(4, minmax(0,1fr)); gap:14px; margin-top:18px}
    .kpi{background:var(--card); border:1px solid #e7e9f5; border-radius:12px; box-shadow: var(--shadow);padding:16px;}
    .kpi label{display:block; color:var(--muted); font-size:12px; letter-spacing:.3px}
    .kpi .value{font-size:22px; font-weight:800; margin-top:6px}
    .kpi .trend{margin-top:6px; font-size:12px; color:var(--ok)}
    .grid{display:grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap:18px; margin-top:22px}
    .card{background:var(--card); border:1px solid #e7e9f5; border-radius:12px; box-shadow: var(--shadow);padding:20px; display:flex; flex-direction:column; align-items:center; text-align:center;}
    .card h3{margin:10px 0 4px}
    .card .sub{color:var(--muted); font-size:13px; margin-bottom:10px}
    .icon{width:80px;height:80px;border-radius:16px; display:grid; place-items:center;background:#eef2ff; border:1px solid #e2e8ff; margin-bottom:8px;}
    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:12px}
    .actions .btn{min-width:140px}
    .two-col{display:grid; grid-template-columns:1.2fr .8fr; gap:18px; margin-top:18px}
    .panel{background:var(--card); border:1px solid #e7e9f5; border-radius:12px; box-shadow: var(--shadow);padding:18px;}
    .panel h4{margin:0 0 10px 0}
    .table{width:100%; border-collapse:collapse}
    .table th,.table td{border-bottom:1px dashed #eceef7; padding:10px 6px; text-align:left; font-size:14px}
    .table th{color:var(--muted); font-weight:600}
    .alert{background:#eafaf2; color:#124d35; border:1px solid #cceedd; padding:12px 14px;border-radius:10px; margin:18px 0 0 0;}
    .footer{margin:32px 0 18px; color:var(--muted); font-size:12px; text-align:center}
    @media (max-width: 980px){ .hero{grid-template-columns:1fr} .kpis{grid-template-columns:repeat(2,1fr)} .grid{grid-template-columns:1fr} .two-col{grid-template-columns:1fr} .hero-illu img{max-width:180px}}
  </style>
</head>
<body>

<%
    if (request.getAttribute("todayRevenue") == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>

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

    <!-- HERO -->
    <section class="hero">
      <div>
        <h1>Welcome to Pahana Edu’s Billing Hub</h1>
        <p>Quickly manage customers, items and invoices for the bookstore. Generate bills, export PDFs and view real-time sales insights.</p>
        <div class="hero-actions">
          <a href="addBill.jsp" class="btn primary">+ Create Bill</a>
          <a href="addCustomer.jsp" class="btn">+ Add Customer</a>
          <a href="itemList.jsp" class="btn">View Items</a>
        </div>

        <%
          String msg;
          if ((msg = (String) session.getAttribute("loginSuccess")) != null) { %>
            <div class="alert"><%= msg %></div>
        <%  session.removeAttribute("loginSuccess"); }
          if ((msg = (String) session.getAttribute("customerSuccess")) != null) { %>
            <div class="alert"><%= msg %></div>
        <%  session.removeAttribute("customerSuccess"); }
          if ((msg = (String) session.getAttribute("itemSuccess")) != null) { %>
            <div class="alert"><%= msg %></div>
        <%  session.removeAttribute("itemSuccess"); }
          if ((msg = (String) session.getAttribute("billSuccess")) != null) { %>
            <div class="alert"><%= msg %></div>
        <%  session.removeAttribute("billSuccess"); }
          String dashError = (String) request.getAttribute("dashError");
          if (dashError != null) { %>
            <div class="alert" style="background:#fff7ed;color:#92400e;border-color:#fed7aa"><%= dashError %></div>
        <% } %>
      </div>

      <div class="hero-illu">
        <img src="Icons/Bill.png" alt="Billing Illustration"/>
      </div>
    </section>

    <!-- KPIs -->
    <section class="kpis">
      <div class="kpi">
        <label>Today’s Revenue</label>
        <div class="value">Rs. ${todayRevenue != null ? todayRevenue : 0}</div>
        <div class="trend">—</div>
      </div>
      <div class="kpi">
        <label>Bills Created (Today)</label>
        <div class="value">${billsToday != null ? billsToday : 0}</div>
        <div class="trend">—</div>
      </div>
      <div class="kpi">
        <label>Total Customers</label>
        <div class="value">${totalCustomers != null ? totalCustomers : 0}</div>
        <div class="trend">—</div>
      </div>
      <div class="kpi">
        <label>Active Items</label>
        <div class="value">${activeItems != null ? activeItems : 0}</div>
        <div class="trend">—</div>
      </div>
    </section>

    <!-- MAIN QUICK ACTION CARDS -->
    <section class="grid">
      <div class="card">
        <div class="icon">👥</div>
        <h3>Customers</h3>
        <div class="sub">Add new customers or manage existing accounts</div>
        <div class="actions">
          <a href="addCustomer.jsp" class="btn">Add Customer</a>
          <a href="customerList.jsp" class="btn">Customer List</a>
        </div>
      </div>

      <div class="card">
        <div class="icon">📦</div>
        <h3>Items</h3>
        <div class="sub">Maintain your bookstore inventory and prices</div>
        <div class="actions">
          <a href="addItem.jsp" class="btn">Add Item</a>
          <a href="itemList.jsp" class="btn">Item List</a>
        </div>
      </div>

      <div class="card">
        <div class="icon">🧾</div>
        <h3>Bills</h3>
        <div class="sub">Generate, review, and download customer bills</div>
        <div class="actions">
          <a href="addBill.jsp" class="btn primary">Add Bill</a>
          <a href="billList.jsp" class="btn">Bill List</a>
        </div>
      </div>
    </section>

    <!-- Recent bills + Help teaser -->
    <section class="two-col">
      <div class="panel">
        <h4>Recent Bills</h4>
        <table class="table">
          <thead>
            <tr><th>Bill No</th><th>Customer</th><th>Date</th><th>Total</th></tr>
          </thead>
          <tbody>
          <%
            java.util.List<dao.DashboardDao.BillSummary> bills =
                (java.util.List<dao.DashboardDao.BillSummary>) request.getAttribute("recentBills");
            if (bills != null && !bills.isEmpty()) {
                for (dao.DashboardDao.BillSummary b : bills) {
          %>
              <tr>
                <td><%= b.billNo %></td>
                <td><%= b.customerName %></td>
                <td><%= b.billingDate %></td>
                <td>Rs. <%= b.total %></td>
              </tr>
          <%
                }
            } else {
          %>
              <tr><td colspan="4" style="color:var(--muted)">No data yet.</td></tr>
          <%
            }
          %>
          </tbody>
        </table>
      </div>

      <!-- REPLACED PANEL -->
      <div class="panel">
        <h4>Help & About</h4>
        <p style="color:#6b7280; margin:8px 0 12px">
          New here? Read the quick usage guide to learn how to add customers & items, create bills,
          download PDFs, and understand the dashboard KPIs.
        </p>
        <ul style="margin:0 0 12px 18px; color:#6b7280">
          <li>Step-by-step: Add Customer → Add Item → Create Bill</li>
          <li>How to print or download a bill as PDF</li>
          <li>Troubleshooting common errors & FAQs</li>
        </ul>
        <div style="display:flex; gap:10px; flex-wrap:wrap">
          <a class="btn primary" href="help.jsp">Open Help Guide</a>
          <a class="btn" href="<%= request.getContextPath() %>/dashboard">Refresh KPIs</a>
        </div>
      </div>
    </section>

    <div class="footer">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System
    </div>
  </div>
</body>
</html>
 