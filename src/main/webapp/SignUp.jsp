<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // Dynamic messages
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    // Preserve form values
    String fname = request.getAttribute("fname") != null ? (String)request.getAttribute("fname") : "";
    String lname = request.getAttribute("lname") != null ? (String)request.getAttribute("lname") : "";
    String pho   = request.getAttribute("phone") != null ? (String)request.getAttribute("phone") : "";
    String mail  = request.getAttribute("mail")  != null ? (String)request.getAttribute("mail")  : "";

    // If success → clear form fields
    if (success != null) {
        fname = "";
        lname = "";
        pho = "";
        mail = "";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Create Your Account</title>

  <style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }

    body {
      height:100vh;
      display:flex;
      align-items:center;
      justify-content:center;
      background:#f4f7ff;
      padding:20px;
      animation: fadeIn 0.5s ease;
    }

    @keyframes fadeIn {
      from { opacity:0; transform:translateY(-5px); }
      to   { opacity:1; transform:translateY(0); }
    }

    .signup-card {
      background:#fff;
      width:400px;
      border-radius:16px;
      box-shadow:0 12px 35px rgba(0,0,0,0.15);
      overflow:hidden;
      animation: fadeIn 0.4s ease;
    }

    .signup-header {
      background:linear-gradient(135deg,#004aad 0%,#0077cc 100%);
      color:#fff;
      text-align:center;
      padding:30px 20px;
    }

    .bank-icon { font-size:2.2em; margin-bottom:8px; }

    form { padding:30px 25px 35px; }

    .row { display:flex; gap:12px; }
    .input-group { margin-bottom:18px; flex:1; }

    label { display:block; font-size:0.9em; color:#555; margin-bottom:6px; }

    input {
      width:100%;
      padding:12px 14px;
      border:1px solid #ccc;
      border-radius:10px;
      font-size:0.95em;
      transition:0.2s ease;
    }

    input:focus {
      border-color:#0077cc;
      box-shadow:0 0 7px rgba(0,119,204,0.25);
      outline:none;
    }

    .signup-btn {
      width:100%; padding:12px; font-size:1em;
      color:#fff; background:linear-gradient(135deg,#004aad,#0077cc);
      border:none; border-radius:10px;
      cursor:pointer; margin-top:10px;
      box-shadow:0 8px 20px rgba(0,0,0,0.15);
      transition:0.25s ease;
    }

    .signup-btn:hover {
      transform:translateY(-2px);
      box-shadow:0 12px 25px rgba(0,0,0,0.25);
    }

    .footer { text-align:center; margin-top:20px; font-size:0.9em; }
    .footer a { color:#0077cc; text-decoration:none; font-weight:600; }

    /* Error + Success Animations */
    .error-box, .success-box {
      padding:12px 14px;
      border-radius:10px;
      font-size:0.9em;
      margin-bottom:18px;
      animation:fadeSlide 0.4s ease;
    }

    .error-box {
      background:#ffe6e6;
      border-left:5px solid #ff1a1a;
      color:#b30000;
      animation:shake 0.3s ease;
    }

    .success-box {
      background:#eaffea;
      border-left:5px solid #00b300;
      color:#006600;
    }

    @keyframes fadeSlide {
      from { opacity:0; transform:translateY(-4px); }
      to   { opacity:1; transform:translateY(0); }
    }

    @keyframes shake {
      0% { transform:translateX(0); }
      25% { transform:translateX(-4px); }
      50% { transform:translateX(4px); }
      75% { transform:translateX(-4px); }
      100% { transform:translateX(0); }
    }
  </style>
</head>

<body>

  <div class="signup-card">

    <div class="signup-header">
      <div class="bank-icon">🏦</div>
      <h2>Create Your Account</h2>
      <p>Join our Nexus banking platform today</p>
    </div>

    <form action="<%=request.getContextPath()%>/SignUp" method="post">

      <% if (error != null) { %>
        <div class="error-box"><%= error %></div>
      <% } %>

      <% if (success != null) { %>
        <div class="success-box"><%= success %></div>
      <% } %>

      <div class="row">
        <div class="input-group">
          <label>First Name</label>
          <input type="text" name="fname" value="<%=fname%>" placeholder="Enter your first name" required>
        </div>

        <div class="input-group">
          <label>Last Name</label>
          <input type="text" name="lname" value="<%=lname%>" placeholder="Enter your last name" required>
        </div>
      </div>

      <div class="input-group">
        <label>Phone Number</label>
        <input type="tel" name="pho" maxlength="10" value="<%=pho%>" placeholder="Enter your 10-digit phone number" required>
      </div>

      <div class="input-group">
        <label>Email Address</label>
        <input type="email" name="mail" value="<%=mail%>" placeholder="Enter your email address" required>
      </div>

      <div class="row">
        <div class="input-group">
          <label>PIN (4-digit)</label>
          <input type="password" name="pin" maxlength="4" placeholder="Enter a 4-digit PIN" required>
        </div>

        <div class="input-group">
          <label>Confirm PIN</label>
          <input type="password" name="confirmpin" maxlength="4" placeholder="Confirm your PIN" required>
        </div>
      </div>

      <button type="submit" class="signup-btn">Create Account</button>

      <div class="footer">
        Already have an account?
        <a href="SignIn.jsp">Sign In</a>
      </div>

    </form>

  </div>

</body>
</html>
