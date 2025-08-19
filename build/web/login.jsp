<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Login • Pahana Edu Billing</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="css/styles.css"/>

  <style>
    :root{
      --brand:#3546a7; --brand-2:#6e87ff; --ink:#101319; --muted:#6b7280;
      --bg:#f5f7fb; --card:#fff; --border:#e7e9f5; --shadow:0 10px 30px rgba(16,19,25,.08);
      --radius:14px;
    }
    html,body{background:var(--bg); color:var(--ink); font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif; margin:0}
    /* Top bar (same gradient as dashboard) */
    .navbar{position:sticky;top:0;z-index:5;background:linear-gradient(90deg,var(--brand),var(--brand-2));color:#fff;padding:14px 18px;box-shadow:var(--shadow)}
    .nav-inner{max-width:1200px;margin:0 auto;display:flex;align-items:center;gap:12px}
    .brand{display:flex;align-items:center;gap:10px;font-weight:700}
    .brand .logo{width:34px;height:34px;border-radius:9px;background:#ffffff1a;display:grid;place-items:center;border:1px solid #ffffff22}
    .brand span{font-size:18px;letter-spacing:.2px}

    /* Centered login card */
    .login-wrap{
      min-height: calc(100vh - 62px);
      display:grid; place-items:center;
      padding: 28px 18px;
      background:
        radial-gradient(600px 200px at 80% -10%, #c9d2ff55, transparent),
        radial-gradient(600px 200px at 10% 110%, #c9d2ff33, transparent);
    }
    .login-card{
      width: 100%; max-width: 420px;
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      padding: 26px;
    }
    .login-card h1{margin:0 0 6px; font-size:24px}
    .login-sub{color:var(--muted); margin:0 0 18px; font-size:13px}

    .form{display:grid; gap:12px}
    .label{font-size:13px; font-weight:600; color:var(--muted)}
    .input{
      width:100%; padding:12px; border:1px solid var(--border);
      border-radius:10px; background:#fff; font-size:15px;
    }
    .btn{display:inline-flex; align-items:center; justify-content:center; gap:8px;
         padding:12px 16px; border-radius:10px; font-weight:700;
         border:1px solid var(--border); background:#fff; transition:.2s; box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border-color:transparent}
    .btn.primary:hover{filter:brightness(.96); transform:translateY(-1px)}
    .alert{background:#fff7f7; color:#7f1d1d; border:1px solid #fecaca; padding:10px 12px; border-radius:10px; font-size:14px}

    .pw{
      display:grid; grid-template-columns:1fr auto; align-items:center; gap:8px;
      border:1px solid var(--border); border-radius:10px; padding:0 8px; background:#fff;
    }
    .pw input{border:none; outline:none; padding:12px; font-size:15px}
    .pw button{border:none; background:transparent; cursor:pointer; color:#4b5563; font-weight:600}
    .footer{margin:16px 0 0; color:var(--muted); font-size:12px; text-align:center}
  </style>
</head>
<body>

  <!-- NAV -->
  <div class="navbar">
    <div class="nav-inner">
      <div class="brand">
        <div class="logo">📚</div>
        <span>Pahana Edu • Billing</span>
      </div>
    </div>
  </div>

  <main class="login-wrap">
    <section class="login-card">
      <h1>Welcome back</h1>
      <p class="login-sub">Sign in to manage customers, items and bills.</p>

      <%-- Error messages from query param --%>
      <%
        String err = request.getParameter("error");
        if ("1".equals(err)) {
      %>
        <div class="alert">Invalid username or password.</div>
      <% } else if ("db".equals(err)) { %>
        <div class="alert">A database error occurred. Please try again.</div>
      <% } %>

      <form class="form" action="LoginServlet" method="post">
        <label class="label" for="username">Username</label>
        <input id="username" class="input" type="text" name="username" placeholder="Enter your username" required autofocus>

        <label class="label" for="password">Password</label>
        <div class="pw">
          <input id="password" type="password" name="password" placeholder="••••••••" required>
          <button type="button" id="togglePw">Show</button>
        </div>

        <button class="btn primary" type="submit">Login</button>
      </form>

      <div class="footer">
        © <script>document.write(new Date().getFullYear())</script> Pahana Edu Bookshop
      </div>
    </section>
  </main>

  <script>
    // Show / hide password
    (function () {
      const pw = document.getElementById('password');
      const btn = document.getElementById('togglePw');
      if (!pw || !btn) return;
      btn.addEventListener('click', () => {
        const isPw = pw.type === 'password';
        pw.type = isPw ? 'text' : 'password';
        btn.textContent = isPw ? 'Hide' : 'Show';
      });
    })();
  </script>
</body>
</html>

