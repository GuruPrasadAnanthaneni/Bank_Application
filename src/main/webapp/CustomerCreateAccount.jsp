<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Open Account | NexusBank</title>

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

        .dashboard-layout {
            display: flex;
            height: 100vh;
        }

        /* --- SIDEBAR (Consistent) --- */
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

        .nav-menu {
            list-style: none;
            padding: 0 15px;
            margin-top: 10px;
            flex-grow: 1;
        }

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

        /* --- CONTENT GRID --- */
        .content-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr; /* Form takes more space */
            gap: 30px;
            align-items: start;
        }

        /* Form Card */
        .form-card {
            background: var(--bg-card);
            padding: 40px;
            border-radius: 16px;
            box-shadow: var(--shadow-card);
        }

        .form-group { margin-bottom: 25px; }

        .form-label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--brand-dark);
            font-size: 0.9rem;
        }

        /* Custom Select Styling */
        .form-select {
            width: 100%;
            padding: 15px;
            border: 2px solid var(--input-border);
            border-radius: 10px;
            font-size: 1rem;
            color: var(--text-main);
            background-color: white;
            appearance: none; /* Remove default arrow */
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%230052cc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1em;
            cursor: pointer;
            transition: border-color 0.2s;
            font-family: 'Poppins', sans-serif;
        }

        .form-select:focus {
            outline: none;
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 4px rgba(0, 82, 204, 0.1);
        }

        /* Submit Button */
        .btn-submit {
            width: 100%;
            background: var(--brand-primary);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }

        .btn-submit:hover {
            background: #0046b0;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 82, 204, 0.2);
        }

        /* Info Card */
        .info-card {
            background: linear-gradient(135deg, var(--brand-dark) 0%, #1a3b5c 100%);
            color: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: var(--shadow-card);
        }
        
        .info-card h3 { margin-bottom: 20px; font-size: 1.4rem; }
        
        .feature-list { list-style: none; }
        
        .feature-list li {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: flex-start;
        }
        
        .feature-icon {
            background: rgba(255,255,255,0.1);
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--brand-accent);
            flex-shrink: 0;
        }

        /* Alerts */
        .alert {
            margin-top: 25px;
            padding: 15px 20px;
            border-radius: 10px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .alert-success { background: var(--success-bg); color: var(--success-text); }
        .alert-error { background: var(--danger-bg); color: var(--danger-text); }

        @media (max-width: 900px) {
            .content-grid { grid-template-columns: 1fr; }
        }
        
        @media (max-width: 768px) {
            .dashboard-layout { flex-direction: column; height: auto; }
            .sidebar { width: 100%; height: auto; }
            .nav-menu { display: flex; overflow-x: auto; padding-bottom: 10px; }
            .main-content { padding: 20px; }
        }
    </style>
</head>

<body>

<div class="dashboard-layout">

    <aside class="sidebar">
        <div class="brand-logo">
            <i class="fas fa-cube"></i> NexusBank
        </div>

        <ul class="nav-menu">
            <li class="nav-item">
                <a href="<%=request.getContextPath()%>/customer/dashboard" class="nav-link">
                    <i class="fas fa-chart-pie"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="<%=request.getContextPath()%>/customer/accounts" class="nav-link">
                    <i class="fas fa-wallet"></i> My Accounts
                </a>
            </li>
            <li class="nav-item active">
                <a href="<%=request.getContextPath()%>/customer/create-account" class="nav-link">
                    <i class="fas fa-plus-circle"></i> Open Account
                </a>
            </li>
            <li class="nav-item">
                <a href="<%=request.getContextPath()%>/customer/check-balance" class="nav-link">
                    <i class="fas fa-search-dollar"></i> Check Balance
                </a>
            </li>
            <li class="nav-item">
                <a href="<%=request.getContextPath()%>/customer/deposit" class="nav-link">
                    <i class="fas fa-arrow-circle-down"></i> Deposit
                </a>
            </li>
            <li class="nav-item">
                <a href="<%=request.getContextPath()%>/customer/transfer" class="nav-link">
                    <i class="fas fa-exchange-alt"></i> Fund Transfer
                </a>
            </li>
            <li class="nav-item">
                <a href="<%=request.getContextPath()%>/customer/passbook" class="nav-link">
                    <i class="fas fa-history"></i> Passbook
                </a>
            </li>
        </ul>

        <div class="logout-link">
            <a href="<%=request.getContextPath()%>/logout" class="nav-link" style="color: #ff8a8a;">
                <i class="fas fa-sign-out-alt"></i> Sign Out
            </a>
        </div>
    </aside>

    <main class="main-content">

        <div class="page-header">
            <h1>Open New Account</h1>
            <p>Expand your financial portfolio with NexusBank today.</p>
        </div>

        <div class="content-grid">
            
            <div class="form-card">
                <form action="<%=request.getContextPath()%>/customer/create-account" method="post">
                    
                    <div class="form-group">
                        <label for="accType" class="form-label">Select Account Type</label>
                        <select name="accType" id="accType" class="form-select" required>
                            <option value="" disabled selected>-- Choose an option --</option>
                            <option value="SAVINGS">Savings Account (Standard)</option>
                            <option value="CURRENT">Current Account (High Volume)</option>
                            <option value="FD">Fixed Deposit (Term Savings)</option>
                            <option value="LOAN">Loan Account (Credit Facility)</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-submit">
                        Submit Application <i class="fas fa-arrow-right"></i>
                    </button>

                </form>

                <%
                    String msg = (String) request.getAttribute("msg");
                    if (msg != null && !msg.trim().isEmpty()) {
                        boolean isSuccess = msg.toLowerCase().contains("success") || msg.toLowerCase().contains("submitted");
                %>
                    <div class="alert <%= isSuccess ? "alert-success" : "alert-error" %>">
                        <i class="fas <%= isSuccess ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
                        <%= msg %>
                    </div>
                <% } %>
            </div>

            <div class="info-card">
                <h3>Why NexusBank?</h3>
                <ul class="feature-list">
                    <li>
                        <div class="feature-icon"><i class="fas fa-globe"></i></div>
                        <div>
                            <strong>Global Access</strong>
                            <p style="font-size: 0.85rem; opacity: 0.8;">Access your funds anywhere, anytime with 24/7 support.</p>
                        </div>
                    </li>
                    <li>
                        <div class="feature-icon"><i class="fas fa-shield-alt"></i></div>
                        <div>
                            <strong>Secure Banking</strong>
                            <p style="font-size: 0.85rem; opacity: 0.8;">Top-tier encryption keeps your financial data safe.</p>
                        </div>
                    </li>
                    <li>
                        <div class="feature-icon"><i class="fas fa-bolt"></i></div>
                        <div>
                            <strong>Instant Transfers</strong>
                            <p style="font-size: 0.85rem; opacity: 0.8;">Move money between your accounts instantly.</p>
                        </div>
                    </li>
                </ul>
            </div>

        </div>

    </main>
</div>

</body>
</html>