<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*"
    import="in.ps.bankapp.dto.*"
%>

<%
    // ** BACKEND LOGIC **
    ArrayList<Account> accounts = (ArrayList<Account>) request.getAttribute("accountsList");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    String senderAcc = request.getAttribute("senderAcc") != null ? request.getAttribute("senderAcc").toString() : "";
    String receiverAcc = request.getAttribute("receiverAcc") != null ? request.getAttribute("receiverAcc").toString() : "";
    String updatedBalance = request.getAttribute("updatedBalance") != null ? request.getAttribute("updatedBalance").toString() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Money | NexusBank</title>

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

        /* Grid Layout */
        .content-grid {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
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
        .input-icon { position: absolute; left: 15px; color: var(--text-muted); z-index: 2; }

        .form-input, .form-select {
            width: 100%;
            padding: 15px 15px 15px 45px;
            border: 2px solid var(--input-border);
            border-radius: 10px;
            font-size: 1rem;
            transition: border-color 0.2s;
            font-family: 'Poppins', sans-serif;
            background: white;
        }

        /* Custom Select Arrow */
        .form-select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%230052cc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1em;
        }

        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 4px rgba(0, 82, 204, 0.1);
        }

        .btn-transfer {
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
        .btn-transfer:hover { background: #0046b0; transform: translateY(-2px); }

        /* Error Box */
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

        /* Receipt Card */
        .receipt-card {
            background: white;
            border: 1px solid var(--input-border);
            border-radius: 12px;
            padding: 25px;
            margin-top: 25px;
            position: relative;
            overflow: hidden;
            animation: slideUp 0.4s ease-out;
        }

        .receipt-card::before {
            content: ""; position: absolute; top: 0; left: 0; width: 100%; height: 6px; background: var(--success-text);
        }

        .receipt-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px dashed #e0e6ed;
        }
        
        .status-badge {
            background: var(--success-bg); color: var(--success-text); padding: 5px 12px; border-radius: 50px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase;
        }

        .transfer-flow {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 20px 0;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }

        .tf-box { font-size: 0.9rem; color: var(--text-muted); }
        .tf-val { font-weight: 700; color: var(--brand-dark); font-family: monospace; font-size: 1.1rem; display: block; margin-top: 4px; }
        
        .tf-arrow { color: var(--brand-primary); font-size: 1.2rem; }

        .balance-update { text-align: center; margin-top: 20px; font-size: 0.9rem; color: var(--text-muted); }
        .balance-update strong { color: var(--brand-dark); }

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
            content: "➤"; color: var(--brand-accent); position: absolute; left: 0; font-size: 0.8em; top: 3px;
        }

        @media (max-width: 900px) { .content-grid { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .dashboard-layout { flex-direction: column; height: auto; } .sidebar { width: 100%; height: auto; } .main-content { padding: 20px; } }
        
        @keyframes slideUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
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
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/deposit" class="nav-link"><i class="fas fa-arrow-circle-down"></i> Deposit</a></li>
            <li class="nav-item active"><a href="<%=request.getContextPath()%>/customer/transfer" class="nav-link"><i class="fas fa-exchange-alt"></i> Fund Transfer</a></li>
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/passbook" class="nav-link"><i class="fas fa-history"></i> Passbook</a></li>
        </ul>
        <div class="logout-link">
            <a href="<%=request.getContextPath()%>/logout" class="nav-link" style="color: #ff8a8a;"><i class="fas fa-sign-out-alt"></i> Sign Out</a>
        </div>
    </aside>

    <main class="main-content">

        <div class="page-header">
            <h1>Transfer Money</h1>
            <p>Send funds securely to any NexusBank account.</p>
        </div>

        <div class="content-grid">

            <div class="card">
                <form action="<%=request.getContextPath()%>/customer/transfer" method="post">

                    <div class="form-group">
                        <label for="senderAcc" class="form-label">From Account (Sender)</label>
                        <div class="input-group">
                            <i class="fas fa-wallet input-icon"></i>
                            <select name="senderAcc" id="senderAcc" class="form-select" required>
                                <option value="" disabled selected>-- Select Source Account --</option>
                                <% if (accounts != null) {
                                    for (Account a : accounts) { %>
                                        <option value="<%=a.getAccount_number()%>" 
                                            <%= senderAcc.equals(String.valueOf(a.getAccount_number())) ? "selected" : "" %>>
                                            <%= a.getAccount_number() %> (Bal: ₹ <%= String.format("%.2f", a.getBalance()) %>)
                                        </option>
                                <% }} %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="receiverAcc" class="form-label">To Account (Beneficiary)</label>
                        <div class="input-group">
                            <i class="fas fa-user-check input-icon"></i>
                            <input type="text" id="receiverAcc" name="receiverAcc" value="<%=receiverAcc%>" class="form-input" placeholder="Enter 12-digit Account Number" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="amount" class="form-label">Amount (₹)</label>
                        <div class="input-group">
                            <i class="fas fa-rupee-sign input-icon"></i>
                            <input type="number" id="amount" name="amount" class="form-input" placeholder="0.00" min="1" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="pin" class="form-label">Security PIN</label>
                        <div class="input-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="pin" name="pin" class="form-input" maxlength="4" placeholder="4-Digit PIN" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-transfer">
                        Initiate Transfer <i class="fas fa-paper-plane"></i>
                    </button>
                </form>

                <% if (error != null) { %>
                    <div class="alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span><%= error %></span>
                    </div>
                <% } %>

                <% if (success != null) { %>
                    <div class="receipt-card">
                        <div class="receipt-header">
                            <h3 style="margin:0; font-size:1.1rem; color:var(--brand-dark);">Transaction Receipt</h3>
                            <span class="status-badge">Successful</span>
                        </div>

                        <div class="transfer-flow">
                            <div class="tf-box">
                                From<span class="tf-val"><%= senderAcc %></span>
                            </div>
                            <div class="tf-arrow">
                                <i class="fas fa-arrow-right"></i>
                            </div>
                            <div class="tf-box" style="text-align: right;">
                                To<span class="tf-val"><%= receiverAcc %></span>
                            </div>
                        </div>

                        <div class="balance-update">
                            Sender Updated Balance: <strong>₹ <%= updatedBalance %></strong>
                        </div>
                        
                        <div style="text-align: center; margin-top: 15px;">
                             <a href="<%=request.getContextPath()%>/customer/passbook" style="color: var(--brand-primary); text-decoration: none; font-weight: 600; font-size: 0.9rem;">Check Passbook</a>
                        </div>
                    </div>
                <% } %>
            </div>

            <div class="info-panel">
                <h3><i class="fas fa-shield-alt"></i> Transfer Rules</h3>
                <ul class="info-list">
                    <li>Transfers within NexusBank are instantaneous.</li>
                    <li>Double-check the Beneficiary Account Number. Reversals are not possible once processed.</li>
                    <li>Ensure you maintain the Minimum Average Balance (MAB) after transfer.</li>
                    <li>Daily transaction limit: <strong>₹ 10,00,000</strong>.</li>
                    <li>Transactions over ₹ 50,000 require OTP verification (simulated).</li>
                </ul>
            </div>

        </div>

    </main>
</div>

</body>
</html>