<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // Dynamic error message from servlet
    String error = (String) request.getAttribute("error");

    // Prefill email after failed login
    String emailValue = request.getAttribute("emailValue") != null
                        ? (String) request.getAttribute("emailValue")
                        : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Sign In</title>

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Poppins', sans-serif;
    }

    body {
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #ffffff;
    }

    .signin-card {
      background: #fff;
      width: 380px;
      border-radius: 16px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.2);
      overflow: hidden;
    }

    .signin-header {
      background: linear-gradient(135deg, #004aad, #0077cc);
      color: #fff;
      padding: 30px 20px;
      text-align: center;
    }

    .signin-header .bank-icon {
      font-size: 2.5em;
      margin-bottom: 10px;
    }

    form { padding: 30px 25px; }
    .input-group { margin-bottom: 20px; }

    label {
      display: block;
      font-size: 0.9em;
      color: #555;
      margin-bottom: 8px;
    }

    input {
      width: 100%;
      padding: 12px 15px;
      border: 1px solid #ccc;
      border-radius: 10px;
      font-size: 0.95em;
      transition: 0.3s ease;
    }

    input:focus {
      border-color: #0077cc;
      box-shadow: 0 0 8px rgba(0,119,204,0.4);
      outline: none;
    }

    .options {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 25px;
      font-size: 0.85em;
      color: #333;
    }

    /* Clean Remember Me styling */
    .remember-label {
      display: flex;
      align-items: center;
      gap: 6px;
      cursor: pointer;
    }

    input[type="checkbox"] {
      width: 16px;
      height: 16px;
      accent-color: #0077cc;
      cursor: pointer;
    }

    .options a {
      color: #0077cc;
      text-decoration: none;
      font-weight: 500;
    }

    .signin-btn {
      width: 100%;
      padding: 12px;
      font-size: 1em;
      color: #fff;
      background: linear-gradient(135deg, #004aad, #0077cc);
      border: none;
      border-radius: 10px;
      cursor: pointer;
      transition: 0.3s;
    }

    .signin-btn:hover {
      background: linear-gradient(135deg, #003a8c, #005fa0);
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(0,0,0,0.2);
    }

    .links {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
      font-size: 0.85em;
    }

    .links a {
      color: #0077cc;
      text-decoration: none;
    }

    /* Error message box */
    .error-box {
      background: rgba(255,0,0,0.1);
      border-left: 4px solid red;
      padding: 10px 12px;
      border-radius: 8px;
      color: #b30000;
      margin-bottom: 15px;
      font-size: 0.9em;
      animation: fadeIn 0.4s ease;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-5px); }
      to { opacity: 1; transform: translateY(0); }
    }

  </style>
</head>

<body>
  <div class="signin-card">

    <div class="signin-header">
      <div class="bank-icon">🏦</div>
      <h2>Welcome Back</h2>
      <p>Sign in to continue</p>
    </div>

    <form action="<%=request.getContextPath()%>/login" method="post">

      <% if (error != null) { %>
        <div class="error-box"><%= error %></div>
      <% } %>

      <div class="input-group">
        <label>Email Address</label>
        <input type="email"
               name="email"
               placeholder="Enter your email address"
               value="<%=emailValue%>"
               required />
      </div>

      <div class="input-group">
        <label>PIN</label>
        <input type="password"
               name="pin"
               placeholder="Enter your 4-digit PIN"
               maxlength="4"
               required />
      </div>

      <div class="options">
        <label class="remember-label">
          <input type="checkbox" /> Remember me
        </label>
        <a href="ForgotPassword.jsp">Forgot PIN?</a>
      </div>

      <button type="submit" class="signin-btn">Sign In</button>

      <div class="links">
        <a href="AccountType.jsp">Security Tips</a>
        <a href="SignUp.jsp">Create Account</a>
      </div>

    </form>

  </div>
</body>
</html>