<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Select Your Account Type - NexusBank</title>
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
            padding: 15px;
            animation: fadeIn 0.4s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-5px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .account-card-container {
            background: #fff;
            width: 380px;
            border-radius: 14px;
            box-shadow: 0 18px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .account-card-container:hover {
            transform: translateY(-4px);
            box-shadow: 0 22px 40px rgba(0, 0, 0, 0.25);
        }

        .account-header {
            background: linear-gradient(135deg, #004aad 0%, #0077cc 100%);
            color: #fff;
            text-align: center;
            padding: 30px 20px;
            border-bottom-left-radius: 16px;
            border-bottom-right-radius: 16px;
        }

        .account-body {
            padding: 22px 22px 28px;
        }

        label {
            display: block;
            font-size: 0.85em;
            color: #555;
            margin-bottom: 5px;
        }

        input, select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 0.9em;
            margin-bottom: 14px;
        }

        .account-type-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin: 15px 0;
        }

        .type-card {
            background: #f9fafc;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 8px;
        }

        .btn {
            flex: 1;
            padding: 10px;
            font-size: 0.95em;
            border-radius: 8px;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: linear-gradient(135deg, #004aad 0%, #0077cc 100%);
            color: #fff;
        }

        .btn-secondary {
            background: transparent;
            border: 1px solid #0077cc;
            color: #0077cc;
        }

        /* Message Styles */
        .msg-box {
            padding: 12px 14px;
            border-left: 5px solid;
            border-radius: 10px;
            margin-bottom: 15px;
            text-align: center;
            font-size: 0.9em;
            animation: fadeMsg 0.4s ease;
        }

        @keyframes fadeMsg {
            from {
                opacity: 0;
                transform: translateY(-4px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body>

    <div class="account-card-container">
        <div class="account-header">
            <div class="bank-icon" style="font-size: 2em;">🏦</div>
            <h2>Select Your Account Type</h2>
            <p>Choose the account that best fits your financial needs</p>
        </div>

        <form action="select-account" method="post">
            <div class="account-body">

                <%-- SHOW MESSAGE IF ANY --%>
                <%
    String msg = (String) request.getAttribute("msg");

    if (msg != null) {
        String bg = "#fff";
        String border = "#000";
        String color = "#000";

        if (msg.contains("🎉")) { 
            // SUCCESS - GREEN
            bg = "#eaffea";
            border = "#00b300";
            color = "#0a6b0a";
        } 
        else if (msg.contains("⚠️")) { 
            // WARNING - ORANGE
            bg = "#fff4e0";
            border = "#ff9900";
            color = "#b36b00";
        } 
        else if (
            msg.contains("❌") || 
            msg.contains("⛔") || 
            msg.contains("🚫")
        ) {
            // ERROR - RED
            bg = "#ffe6e6";
            border = "#ff1a1a";
            color = "#a80000";
        }
%>

<div class="msg-box" style="background:<%=bg%>; border-color:<%=border%>; color:<%=color%>;">
    <%= msg %>
</div>

<% } %>


                <label for="email">Email Address</label>
                <input type="email" id="email" name="mail" placeholder="Enter your email address" required />

                <label for="account-type">Account Type</label>
                <select id="account-type" name="accType" required>
                    <option>Select Account Type</option>
                    <option>SAVINGS</option>
                    <option>CURRENT</option>
                    <option>FD</option>
                    <option>LOAN</option>
                </select>

                <div class="account-type-grid">
                    <div class="type-card">
                        <img src="https://img.icons8.com/emoji/48/money-bag-emoji.png" />
                        <span>Savings</span>
                    </div>

                    <div class="type-card">
                        <img src="https://img.icons8.com/fluency/48/briefcase.png" />
                        <span>Current</span>
                    </div>

                    <div class="type-card">
                        <img src="https://img.icons8.com/color/48/combo-chart--v1.png" />
                        <span>Fixed Deposit</span>
                    </div>

                    <div class="type-card">
                        <img src="https://img.icons8.com/color/48/home.png" />
                        <span>Loan</span>
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Create Account</button>
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='BankDashboard.jsp'">
                        Back to Home
                    </button>
                </div>

            </div>
        </form>

    </div>

</body>
</html>