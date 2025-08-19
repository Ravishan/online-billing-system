<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, model.DBConnection, java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Create Bill • Pahana Edu Billing</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="css/styles.css"/>

  <!-- Optional: Select2 (kept, but page works fine without it) -->
  <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>

  <style>
    :root{ --brand:#3546a7; --brand-2:#6e87ff; --ink:#101319; --muted:#6b7280; --bg:#f5f7fb; --card:#fff; --border:#e7e9f5; --shadow:0 10px 30px rgba(16,19,25,.08); --radius:14px }
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

    .panel{background:var(--card); border:1px solid var(--border); border-radius:12px; box-shadow:var(--shadow); padding:18px}
    .form{display:grid; gap:12px}
    .label{font-size:13px; font-weight:600; color:var(--muted)}
    .select,.input{width:100%; padding:12px; border:1px solid var(--border); border-radius:10px; background:#fff; font-size:15px}

    .table{width:100%; border-collapse:collapse; margin-top:6px}
    .table th,.table td{border-bottom:1px dashed #eceef7; padding:10px 6px; text-align:left; font-size:14px}
    .table th{color:var(--muted); font-weight:600}
    .qty{width:96px; padding:8px; border:1px solid var(--border); border-radius:8px}
    .right{text-align:right}

    .totals{display:flex; justify-content:flex-end; align-items:center; gap:16px; margin-top:10px}
    .totals .label{font-weight:700}
    .amount{font-weight:800; font-size:18px}

    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:10px}
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:10px 16px; border-radius:10px; font-weight:700; border:1px solid var(--border); background:#fff; transition:.2s; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.secondary{background:#f3f4f6}
    .btn:hover{transform:translateY(-1px)}

    .alert{background:#fff7ed; color:#92400e; border:1px solid #fed7aa; padding:10px 12px; border-radius:10px; font-size:14px}
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
      <h1>Create Bill</h1>
      <p>Select a customer and enter quantities for items. Totals update automatically; the server will calculate the final amounts again.</p>
    </section>

    <!-- Error banners (optional flags from BillServlet) -->
    <%
      String err = request.getParameter("error");
      if ("invalid_customer".equals(err)) {
    %><div class="alert">Please select a valid customer.</div><%
      } else if ("no_items".equals(err)) {
    %><div class="alert">Add at least one item with quantity &gt; 0.</div><%
      } else if ("1".equals(err)) {
    %><div class="alert">Sorry, something went wrong while saving the bill.</div><%
      }
    %>

    <!-- Billing form -->
    <section class="panel">
      <form class="form" action="BillServlet" method="post" id="billForm">
        <!-- Customer -->
        <label class="label" for="customerSelect">Customer *</label>
        <select id="customerSelect" name="customer_id" class="select" required>
          <option value="" disabled selected>— Select customer —</option>
          <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT id, name FROM customers ORDER BY name");
                 ResultSet rs = ps.executeQuery()) {
              while (rs.next()) {
          %>
            <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
          <%
              }
            } catch (Exception e) {
          %>
            <option disabled>Error loading customers</option>
          <%
            }
          %>
        </select>

        <!-- Items table -->
        <div>
          <table class="table" id="itemsTable">
            <thead>
              <tr>
                <th>Item</th>
                <th class="right" style="width:140px">Unit Price (Rs.)</th>
                <th style="width:120px">Qty</th>
                <th class="right" style="width:160px">Line Total (Rs.)</th>
              </tr>
            </thead>
            <tbody>
              <%
                DecimalFormat df = new DecimalFormat("#,##0.00");
                int rows = 0;
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement("SELECT id, item_name, unit_price FROM items ORDER BY item_name");
                     ResultSet rs = ps.executeQuery()) {
                  while (rs.next()) {
                    rows++;
                    int id = rs.getInt("id");
                    String name = rs.getString("item_name");
                    double price = rs.getDouble("unit_price");
              %>
                <tr data-price="<%= price %>">
                  <td><%= name %></td>
                  <td class="right">Rs. <span class="uprice"><%= df.format(price) %></span></td>
                  <td>
                    <input class="qty" type="number" min="0" step="1" value="0" name="quantity_<%= id %>"/>
                  </td>
                  <td class="right">Rs. <span class="linetotal">0.00</span></td>
                </tr>
              <%
                  }
                } catch (Exception e) {
              %>
                <tr><td colspan="4">Error loading items: <%= e.getMessage() %></td></tr>
              <%
                }
                if (rows == 0) {
              %>
                <tr><td colspan="4" style="color:#6b7280">No items available. Add items first.</td></tr>
              <%
                }
              %>
            </tbody>
          </table>
        </div>

        <!-- Totals + actions -->
        <div class="totals">
          <div class="label">Grand Total:</div>
          <div class="amount">Rs. <span id="grandTotal">0.00</span></div>
        </div>

        <div class="actions">
          <button class="btn primary" type="submit">Submit Bill</button>
          <button class="btn secondary" type="button" id="clearQty">Clear Quantities</button>
          <a class="btn secondary" href="billList.jsp">Back to Bill List</a>
          <a class="btn secondary" href="<%= request.getContextPath() %>/dashboard">Back to Dashboard</a>
        </div>
      </form>
    </section>

    <div class="footer">
      © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop — Online Billing System
    </div>
  </div>

  <!-- jQuery + Select2 (optional) -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
  <script>
    (function(){
      // Enhance customer select if Select2 is available
      if (window.jQuery && jQuery.fn && jQuery.fn.select2) {
        jQuery('#customerSelect').select2({ placeholder: "Search for a customer", allowClear: true, width: '100%' });
      }

      // Live totals
      function recalc() {
        var grand = 0;
        document.querySelectorAll('#itemsTable tbody tr').forEach(function(tr){
          var price = parseFloat(tr.getAttribute('data-price') || '0');
          var qtyEl = tr.querySelector('.qty');
          var qty = parseInt(qtyEl && qtyEl.value ? qtyEl.value : 0, 10) || 0;
          var lt = price * qty;
          tr.querySelector('.linetotal').textContent = lt.toFixed(2);
          grand += lt;
        });
        document.getElementById('grandTotal').textContent = grand.toFixed(2);
      }

      document.querySelectorAll('.qty').forEach(function(inp){
        inp.addEventListener('input', recalc);
        inp.addEventListener('change', recalc);
      });

      document.getElementById('clearQty')?.addEventListener('click', function(){
        document.querySelectorAll('.qty').forEach(function(inp){ inp.value = 0; });
        recalc();
      });

      // Basic guard before submit: ensure at least one quantity > 0
      document.getElementById('billForm').addEventListener('submit', function(e){
        var any = false;
        document.querySelectorAll('.qty').forEach(function(inp){
          if (parseInt(inp.value || '0', 10) > 0) any = true;
        });
        if (!any) {
          e.preventDefault();
          alert('Please enter at least one item quantity greater than 0.');
        }
      });

      recalc();
    })();
  </script>
</body>
</html>
