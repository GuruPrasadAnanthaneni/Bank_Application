<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    // Fetch attributes from Controller
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    
    // Data for receipt generation
    String accNo = request.getAttribute("accNo") != null ? request.getAttribute("accNo").toString() : "";
    String balance = request.getAttribute("balance") != null ? request.getAttribute("balance").toString() : "";
    String tranId = request.getAttribute("tranId") != null ? request.getAttribute("tranId").toString() : "";

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deposit Funds | NexusBank</title>

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
        .page-header h1 { font-size: 1.8rem; color: var(--brand-dark); font-weight: 700; margin-bottom: 5px; }
        .page-header p { color: var(--text-muted); font-size: 0.95rem; }

        .content-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 30px;
            align-items: start;
        }

        /* Card Styles */
        .card {
            background: var(--bg-card);
            padding: 35px;
            border-radius: 16px;
            box-shadow: var(--shadow-card);
        }

        .form-group { margin-bottom: 25px; }
        .form-label { display: block; margin-bottom: 10px; font-weight: 600; color: var(--brand-dark); }

        .input-group { position: relative; display: flex; align-items: center; }
        .input-icon { position: absolute; left: 15px; color: var(--text-muted); z-index: 2;}

        .form-input {
            width: 100%;
            padding: 15px 15px 15px 45px;
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
            transition: transform 0.2s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }
        .btn-submit:hover { background: #0046b0; transform: translateY(-2px); }

        /* Error & Success States */
        .alert-error {
            margin-top: 20px;
            background: var(--danger-bg);
            color: var(--danger-text);
            padding: 15px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        /* Receipt Card for Success */
        .receipt-card {
            background: white;
            border: 1px solid var(--input-border);
            border-top: 5px solid var(--success-text);
            border-radius: 12px;
            padding: 25px;
            margin-top: 20px;
            animation: slideUp 0.4s ease-out;
        }
        
        @keyframes slideUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .receipt-header {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--success-text);
            font-weight: 700;
            margin-bottom: 20px;
            font-size: 1.1rem;
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 0.95rem;
            border-bottom: 1px dashed #e0e6ed;
            padding-bottom: 12px;
        }
        .receipt-row:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0;}

        .r-label { color: var(--text-muted); }
        .r-value { color: var(--brand-dark); font-weight: 600; font-family: monospace; font-size: 1rem; }

        /* Info Panel */
        .info-panel {
            background: var(--brand-dark);
            color: white;
            padding: 30px;
            border-radius: 16px;
        }
        .info-panel h3 { margin-bottom: 15px; font-size: 1.2rem; display:flex; align-items:center; gap:10px; }
        .info-list li { margin-bottom: 15px; color: #aab7c4; font-size: 0.9rem; list-style: none; padding-left: 20px; position: relative; }
        .info-list li::before {
            content: "•"; color: var(--brand-accent); font-weight: bold; position: absolute; left: 0; font-size: 1.2em; top: -3px;
        }

        @media (max-width: 900px) { .content-grid { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .dashboard-layout { flex-direction: column; height: auto; } .sidebar { width: 100%; height: auto; } .main-content { padding: 20px; } }
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
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/check-balance" class="nav-link"><i class="fas fa-search-dollar"></i> Check Balance</a></li>
            <li class="nav-item active"><a href="<%=request.getContextPath()%>/customer/deposit" class="nav-link"><i class="fas fa-arrow-circle-down"></i> Deposit</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/transfer" class="nav-link"><i class="fas fa-exchange-alt"></i> Fund Transfer</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/passbook" class="nav-link"><i class="fas fa-history"></i> Passbook</a></li>
        </ul>
        <div class="logout-link">
            <a href="<%=request.getContextPath()%>/logout" class="nav-link" style="color: #ff8a8a;"><i class="fas fa-sign-out-alt"></i> Sign Out</a>
        </div>
    </aside>

    <main class="main-content">

        <div class="page-header">
            <h1>Deposit Funds</h1>
            <p>Securely add money to your account instantly.</p>
        </div>

        <div class="content-grid">

            <div class="card">
                
                <form action="<%=request.getContextPath()%>/customer/deposit" method="post">
                    
                    <div class="form-group">
                        <label for="accNo" class="form-label">Account Number</label>
                        <div class="input-group">
                            <i class="fas fa-university input-icon"></i>
                            <input type="text" id="accNo" name="accNo" class="form-input" placeholder="e.g. 100020003000" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="amount" class="form-label">Amount (₹)</label>
                        <div class="input-group">
                            <i class="fas fa-money-bill-wave input-icon"></i>
                            <input type="number" id="amount" name="amount" class="form-input" placeholder="0.00" min="1" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="pin" class="form-label">Transaction PIN</label>
                        <div class="input-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="pin" name="pin" class="form-input" maxlength="4" placeholder="Enter 4-digit PIN" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        Confirm Deposit <i class="fas fa-check"></i>
                    </button>

                </form>

                <% if (error != null) { %>
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= error %></span>
                    </div>
                <% } %>

                <% if (success != null) { %>
                    <div class="receipt-card">
                        <div class="receipt-header">
                            <i class="fas fa-check-circle"></i> Deposit Successful
                        </div>
                        <div class="receipt-row">
                            <span class="r-label">Account</span>
                            <span class="r-value"><%= accNo %></span>
                        </div>
                        
                        <div class="receipt-row">
						    <span class="r-label">Transaction ID</span>
						    <span class="r-value"><%= tranId %></span>
						</div>
                        
                        <div class="receipt-row">
                            <span class="r-label">Status</span>
                            <span class="r-value" style="color: var(--success-text);">Credited</span>
                        </div>
                        <div class="receipt-row">
                            <span class="r-label">New Balance</span>
                            <span class="r-value">₹ <%= balance %></span>
                        </div>
                        <div style="margin-top: 15px; text-align: center;">
                            <a href="<%=request.getContextPath()%>/customer/passbook" style="color: var(--brand-primary); font-size: 0.9rem; font-weight:600; text-decoration:none;">View in Passbook</a>
                        </div>
                    </div>
                <% } %>

            </div>

            <div class="info-panel">
                <h3><i class="fas fa-info-circle"></i> Important Info</h3>
                <ul class="info-list">
                    <li>Deposits are usually processed instantly.</li>
                    <li>Ensure you enter the correct Account Number. We are not liable for transfers to wrong accounts.</li>
                    <li>Maximum daily deposit limit via online portal is <strong>₹ 5,00,000</strong>.</li>
                    <li>For larger amounts, please visit your nearest NexusBank branch.</li>
                </ul>
            </div>

        </div>

    </main>
</div>

</body>
</html>