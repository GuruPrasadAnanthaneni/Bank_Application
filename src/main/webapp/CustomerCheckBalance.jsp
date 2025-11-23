<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="in.ps.bankapp.dto.Account" %>

<%
    // Fetch attributes sent from Controller/Servlet
    Account acc = (Account) request.getAttribute("balanceAccount");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Balance | NexusBank</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            /* --- Modern Fintech Palette --- */
            --brand-dark: #0a2540;       /* Deep Navy */
            --brand-primary: #0052cc;    /* Trust Blue */
            --brand-accent: #00d4ff;     /* Electric Blue */
            
            --bg-body: #f4f7fa;
            --bg-card: #ffffff;
            
            --text-main: #32325d;
            --text-muted: #8898aa;
            
            --success-bg: #e8f5e9;
            --success-text: #2dce89;
            --danger-bg: #ffebee;
            --danger-text: #f5365c;
            
            --shadow-card: 0 4px 20px rgba(0, 0, 0, 0.05);
            --input-border: #e6ebf1;
            
            --sidebar-width: 260px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            height: 100vh;
            overflow: hidden;
        }

        .dashboard-layout { display: flex; height: 100vh; }

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--brand-dark);
            color: white;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }

        .brand-logo {
            padding: 30px 25px;
            font-size: 1.6rem;
            font-weight: 700;
            color: white;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .brand-logo i { color: var(--brand-accent); }

        .nav-menu { list-style: none; padding: 0 15px; margin-top: 10px; flex-grow: 1; }
        .nav-item { margin-bottom: 8px; }

        .nav-link {
            display: flex;
            align-items: center;
            color: #aab7c4;
            text-decoration: none;
            padding: 14px 20px;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .nav-link i { margin-right: 15px; width: 20px; text-align: center; font-size: 1.1rem; }
        .nav-link:hover { background: rgba(255,255,255, 0.05); color: white; }

        .nav-item.active .nav-link {
            background: var(--brand-primary);
            color: white;
            box-shadow: 0 4px 12px rgba(0, 82, 204, 0.3);
        }

        .logout-link {
            margin-top: auto;
            border-top: 1px solid rgba(255,255,255,0.1);
            padding: 20px;
        }

        /* --- MAIN CONTENT --- */
        .main-content {
            flex-grow: 1;
            overflow-y: auto;
            padding: 40px;
        }

        .page-header { margin-bottom: 40px; }
        .page-header h1 { font-size: 1.8rem; color: var(--brand-dark); font-weight: 700; margin-bottom: 5px;}
        .page-header p { color: var(--text-muted); font-size: 0.95rem; }

        /* --- GRID LAYOUT --- */
        .content-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 30px;
            align-items: start;
        }

        /* Cards */
        .card {
            background: var(--bg-card);
            padding: 35px;
            border-radius: 16px;
            box-shadow: var(--shadow-card);
        }

        .form-group { margin-bottom: 25px; }
        .form-label { display: block; margin-bottom: 10px; font-weight: 600; color: var(--brand-dark); }

        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            color: var(--text-muted);
        }

        .form-input {
            width: 100%;
            padding: 15px 15px 15px 45px; /* Padding left for icon */
            border: 2px solid var(--input-border);
            border-radius: 10px;
            font-size: 1rem;
            transition: border-color 0.2s;
            font-family: 'Poppins', sans-serif;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 4px rgba(0, 82, 204, 0.1);
        }

        .btn-check {
            width: 100%;
            background: var(--brand-primary);
            color: white;
            border: none;
            padding: 15px;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }

        .btn-check:hover { background: #0046b0; transform: translateY(-2px); }

        /* Error Box */
        .alert-error {
            margin-top: 20px;
            background: var(--danger-bg);
            color: var(--danger-text);
            padding: 15px;
            border-radius: 10px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Result Card (Gradient) */
        .result-box {
            margin-top: 30px;
            background: linear-gradient(135deg, var(--brand-primary) 0%, #0a2540 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 10px 20px rgba(0, 82, 204, 0.2);
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .result-label { font-size: 0.85rem; opacity: 0.8; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px; }
        
        .result-acc {
            font-family: monospace;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            background: rgba(255,255,255,0.1);
            padding: 8px 12px;
            border-radius: 6px;
            width: fit-content;
        }
        
        .result-amount { font-size: 2.2rem; font-weight: 700; color: var(--brand-accent); }
        .eye-toggle { cursor: pointer; opacity: 0.7; transition: opacity 0.2s; }
        .eye-toggle:hover { opacity: 1; }

        /* Tip Card */
        .tip-card {
            background: #fff;
            border: 1px solid var(--input-border);
        }
        .tip-card h3 { color: var(--brand-dark); margin-bottom: 15px; font-size: 1.2rem; }
        .tip-list li { margin-bottom: 12px; color: var(--text-muted); font-size: 0.9rem; list-style: none; display: flex; gap: 10px; }
        .tip-list i { color: var(--success-text); margin-top: 3px; }

        @media (max-width: 900px) { .content-grid { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .dashboard-layout { flex-direction: column; height: auto; } .sidebar { width: 100%; height: auto; } .nav-menu { display: flex; overflow-x: auto; } .main-content { padding: 20px; } }
    </style>
</head>

<body>

<div class="dashboard-layout">

    <aside class="sidebar">
        <div class="brand-logo">
            <i class="fas fa-cube"></i> NexusBank
        </div>
        <ul class="nav-menu">
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/dashboard" class="nav-link"><i class="fas fa-chart-pie"></i> Dashboard</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/accounts" class="nav-link"><i class="fas fa-wallet"></i> My Accounts</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/create-account" class="nav-link"><i class="fas fa-plus-circle"></i> Open Account</a></li>
            <li class="nav-item active"><a href="<%=request.getContextPath()%>/customer/check-balance" class="nav-link"><i class="fas fa-search-dollar"></i> Check Balance</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/deposit" class="nav-link"><i class="fas fa-arrow-circle-down"></i> Deposit</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/transfer" class="nav-link"><i class="fas fa-exchange-alt"></i> Fund Transfer</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/passbook" class="nav-link"><i class="fas fa-history"></i> Passbook</a></li>
        </ul>
        <div class="logout-link">
            <a href="<%=request.getContextPath()%>/logout" class="nav-link" style="color: #ff8a8a;"><i class="fas fa-sign-out-alt"></i> Sign Out</a>
        </div>
    </aside>

    <main class="main-content">
        
        <div class="page-header">
            <h1>Check Balance</h1>
            <p>Instantly retrieve the current balance of your linked accounts.</p>
        </div>

        <div class="content-grid">
            
            <div class="card">
                <form action="<%=request.getContextPath()%>/customer/check-balance" method="post">
                    
                    <div class="form-group">
                        <label for="accNo" class="form-label">Account Number</label>
                        <div class="input-group">
                            <i class="fas fa-university input-icon"></i>
                            <input type="text" id="accNo" name="accNo" class="form-input" placeholder="Enter 12-digit account number" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-check">
                        Search Account <i class="fas fa-search"></i>
                    </button>
                </form>

                <% if (error != null) { %>
                    <div class="alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span><%= error %></span>
                    </div>
                <% } %>

                <% 
                   if (acc != null) { 
                       String fullAcc = String.valueOf(acc.getAccount_number());
                       // Logic to ensure substring doesn't crash on short strings (though acc num should be long)
                       String masked = (fullAcc.length() > 4) ? "**** **** " + fullAcc.substring(fullAcc.length() - 4) : fullAcc;
                %>
                    <div class="result-box">
                        <div class="result-label">Account Details</div>
                        <div class="result-acc">
                            <span class="acc-val" data-full="<%= fullAcc %>"><%= masked %></span>
                            <i class="fas fa-eye eye-toggle" onclick="toggleResult(this)"></i>
                        </div>
                        
                        <div class="result-label">Available Balance</div>
                        <div class="result-amount">₹ <%= String.format("%.2f", acc.getBalance()) %></div>
                    </div>
                <% } %>
            </div>

            <div class="card tip-card">
                <h3><i class="fas fa-shield-alt" style="color: var(--brand-primary);"></i> Security Tips</h3>
                <ul class="tip-list">
                    <li><i class="fas fa-check-circle"></i> Always ensure you are on a secure connection (HTTPS).</li>
                    <li><i class="fas fa-check-circle"></i> Never share your OTP or Password with anyone.</li>
                    <li><i class="fas fa-check-circle"></i> NexusBank staff will never ask for your PIN.</li>
                    <li><i class="fas fa-check-circle"></i> Check your transaction history regularly for unauthorized charges.</li>
                </ul>
            </div>

        </div>

    </main>
</div>

<script>
    function toggleResult(icon) {
        const span = icon.previousElementSibling;
        const full = span.getAttribute("data-full");
        const masked = "**** **** " + full.substring(full.length - 4);

        if (span.textContent.trim() === masked.trim()) {
            span.textContent = full;
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
        } else {
            span.textContent = masked;
            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
        }
    }
</script>

</body>
</html>