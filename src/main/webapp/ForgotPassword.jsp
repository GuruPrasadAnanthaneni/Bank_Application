<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    String emailValue = request.getAttribute("emailValue") != null
                        ? (String) request.getAttribute("emailValue")
                        : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Reset PIN</title>

  <style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }

    body {
      height:100vh;
      display:flex;
      align-items:center;
      justify-content:center;
      background:#ffffff;
    }

    .forgot-card {
      background:#fff;
      width:380px;
      border-radius:16px;
      box-shadow:0 20px 40px rgba(0,0,0,0.2);
      overflow:hidden;
    }

    .forgot-header {
      background:linear-gradient(135deg,#004aad,#0077cc);
      color:#fff;
      padding:30px 20px;
      text-align:center;
    }

    .forgot-header .bank-icon { font-size:2.5em; margin-bottom:10px; }

    form { padding:30px 25px; }
    .input-group { margin-bottom:20px; }

    label {
      display:block;
      font-size:0.9em;
      margin-bottom:8px;
      color:#555;
    }

    input {
      width:100%;
      padding:12px 15px;
      border:1px solid #ccc;
      border-radius:10px;
      transition:0.3s;
    }
    input:focus {
      border-color:#0077cc;
      box-shadow:0 0 8px rgba(0,119,204,0.4);
    }

    .reset-btn {
      width:100%;
      padding:12px;
      font-size:1em;
      color:#fff;
      background:linear-gradient(135deg,#004aad,#0077cc);
      border:none;
      border-radius:10px;
      cursor:pointer;
      transition:0.3s;
      margin-top:10px;
    }
    .reset-btn:hover {
      background:linear-gradient(135deg,#003a8c,#005fa0);
      transform:translateY(-2px);
      box-shadow:0 8px 20px rgba(0,0,0,0.2);
    }

    .footer {
      text-align:center;
      margin-top:20px;
    }
    .footer a { color:#0077cc; text-decoration:none; font-size:0.85em; }

    /* Error & Success Messages */
    .error-box, .success-box {
      padding:10px 12px;
      border-radius:8px;
      margin-bottom:15px;
      font-size:0.9em;
      animation:fadeIn 0.4s ease;
    }
    .error-box {
      background:rgba(255,0,0,0.12);
      border-left:4px solid red;
      color:#b30000;
    }
    .success-box {
      background:rgba(0,200,0,0.12);
      border-left:4px solid #0a950a;
      color:#0a650a;
    }

    @keyframes fadeIn {
      from { opacity:0; transform:translateY(-4px); }
      to   { opacity:1; transform:translateY(0); }
    }
  </style>

</head>

<body>

  <div class="forgot-card">
    <div class="forgot-header">
      <div class="bank-icon">🏦</div>
      <h2>Reset Your PIN</h2>
      <p>Enter your email and set a new secure PIN</p>
    </div>

    <form action="<%=request.getContextPath()%>/ForgotPassword" method="post">

      <% if (error != null) { %>
        <div class="error-box"><%= error %></div>
      <% } %>

      <% if (success != null) { %>
        <div class="success-box"><%= success %></div>
      <% } %>

      <div class="input-group">
        <label>Email Address</label>
        <input type="email"
               name="mail"
               value="<%=emailValue%>"
               placeholder="Enter your email address"
               required />
      </div>

      <div class="input-group">
        <label>New PIN</label>
        <input type="password"
               name="pin"
               placeholder="Enter new 4-digit PIN"
               maxlength="4"
               required />
      </div>

      <div class="input-group">
        <label>Confirm PIN</label>
        <input type="password"
               name="confirmpin"
               placeholder="Re-enter new PIN"
               maxlength="4"
               required />
      </div>

      <button type="submit" class="reset-btn">Reset PIN</button>

      <div class="footer">
        <a href="SignIn.jsp">Back to Sign In</a>
      </div>

    </form>
  </div>

</body>
</html>
