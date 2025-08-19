<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Help & About • Pahana Edu Billing</title>
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

    .navbar{position:sticky; top:0; z-index:5; background:linear-gradient(90deg,var(--brand),var(--brand-2)); color:#fff; padding:14px 18px; box-shadow:var(--shadow)}
    .nav-inner{max-width:1200px; margin:0 auto; display:flex; align-items:center; gap:12px}
    .brand{display:flex; align-items:center; gap:10px; font-weight:700}
    .brand .logo{width:34px; height:34px; border-radius:9px; background:#ffffff1a; display:grid; place-items:center; border:1px solid #ffffff22}
    .brand span{font-size:18px; letter-spacing:.2px}
    .nav-spacer{flex:1}
    .logout{background:#ffffff1e; border:1px solid #ffffff33; color:#fff; padding:8px 14px; border-radius:10px; font-weight:600}
    .logout:hover{background:#ffffff33}

    .container{max-width:1100px; margin:24px auto; padding:0 18px}
    .hero{background:radial-gradient(1200px 300px at 70% -20%, #c9d2ff55, transparent), linear-gradient(180deg,#ffffff 0%, #f3f6ff 100%); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); padding:22px}
    .hero h1{margin:0 0 6px; font-size:26px}
    .hero p{margin:0; color:var(--muted)}

    .grid{display:grid; grid-template-columns:1fr 1fr; gap:18px; margin-top:18px}
    .card{background:var(--card); border:1px solid var(--border); border-radius:12px; box-shadow:var(--shadow); padding:18px}
    .card h3{margin:0 0 8px}
    .card p{margin:6px 0 0; color:var(--muted)}
    .list{margin:8px 0 0 18px}
    .list li{margin:6px 0}

    .kbd{display:inline-block; padding:2px 6px; border:1px solid #d9dbe8; border-bottom-width:2px; border-radius:6px; background:#fff; font-size:12px}
    .btn{display:inline-flex; align-items:center; gap:8px; padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid var(--border); background:#fff; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.secondary{background:#f3f4f6}
    .btn:hover{transform:translateY(-1px)}

    .footer{margin:24px 0; color:#6b7280; font-size:12px; text-align:center}
    @media (max-width: 980px){ .grid{grid-template-columns:1fr} }
  </style>
</head>
<body>
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
    <section class="hero">
      <h1>Help & About</h1>
      <p>Quick usage guide for new users, plus tips, troubleshooting and FAQs.</p>
      <div style="margin-top:12px; display:flex; gap:10px; flex-wrap:wrap">
        <a class="btn" href="<%= request.getContextPath() %>/dashboard">← Back to Dashboard</a>
        <button class="btn primary" onclick="window.print()">🖨 Print this Guide</button>
      </div>
    </section>

    <section class="grid">
      <div class="card">
        <h3>About the System</h3>
        <ul class="list">
          <li>Purpose: manage bookstore customers, items, and sales bills efficiently.</li>
          <li>Key features: customer & item CRUD, bill generation, PDF export, live KPIs.</li>
          <li>Data model: <em>customers</em>, <em>items</em>, <em>bills</em>, and <em>bill_items</em>.</li>
        </ul>
      </div>

      <div class="card">
        <h3>Getting Started</h3>
        <ol class="list">
          <li><strong>Login</strong> with your username & password.</li>
          <li>Explore KPIs on the <strong>Dashboard</strong>.</li>
          <li>Use the big buttons to add Customers, Items, or create a Bill.</li>
        </ol>
      </div>

      <div class="card">
        <h3>Create a Bill</h3>
        <ol class="list">
          <li>Go to <strong>Add Bill</strong>.</li>
          <li>Select a customer.</li>
          <li>Enter quantities for the items being sold (leave zero to skip).</li>
          <li>Submit to generate the bill — you’ll see it on the Bill List.</li>
        </ol>
        <p>From <strong>Bill List</strong>, open a bill to <strong>Print</strong> or <strong>Download PDF</strong>.</p>
      </div>

      <div class="card">
        <h3>Manage Customers & Items</h3>
        <ul class="list">
          <li>Add via <span class="kbd">Add Customer</span> / <span class="kbd">Add Item</span>.</li>
          <li>Edit or Delete from the list pages.</li>
          <li>Items already used on bills cannot be deleted (safety check).</li>
        </ul>
      </div>

      <div class="card">
        <h3>Dashboard KPIs</h3>
        <ul class="list">
          <li><strong>Today’s Revenue</strong>: Sum of today’s bill totals.</li>
          <li><strong>Bills Today</strong>: Count of bills created today.</li>
          <li><strong>Total Customers</strong> and <strong>Active Items</strong> counts.</li>
          <li>Recent bills table for quick review.</li>
        </ul>
      </div>

      <div class="card">
        <h3>Tips & Shortcuts</h3>
        <ul class="list">
          <li>Use browser <span class="kbd">Ctrl</span> + <span class="kbd">F</span> to quickly find text in lists.</li>
          <li>Use the dashboard buttons to jump to common tasks fast.</li>
          <li>Always verify quantities before submitting a bill.</li>
        </ul>
      </div>

      <div class="card">
        <h3>Troubleshooting</h3>
        <ul class="list">
          <li><strong>Login failed</strong>: re-check username/password.</li>
          <li><strong>No items selected</strong>: you must enter a quantity &gt; 0 for at least one item.</li>
          <li><strong>Cannot delete item</strong>: it’s used by existing bills.</li>
          <li><strong>PDF error</strong>: ensure iText JARs and DB driver are present; retry the download.</li>
        </ul>
      </div>

      <div class="card">
        <h3>FAQ</h3>
        <ul class="list">
          <li><strong>Can I edit a bill?</strong> Not in this version; delete & re-create if needed.</li>
          <li><strong>Where are PDFs saved?</strong> They download directly to your computer.</li>
          <li><strong>How do totals update?</strong> Automatically from line totals when the bill is created.</li>
        </ul>
      </div>
    </section>

    <div class="footer">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System • Help & About
    </div>
  </div>
</body>
</html>
