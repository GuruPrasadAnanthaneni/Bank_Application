<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*"
    import="in.ps.bankapp.dto.*"
%>

<%
    // ** BACKEND LOGIC **
    ArrayList<Account> accounts = (ArrayList<Account>) request.getAttribute("accountsList");
    if(accounts == null) accounts = new ArrayList<>(); // Safety check
    
    ArrayList<Transaction> txns = (ArrayList<Transaction>) request.getAttribute("txnList");
    String selectedAcc = (String) request.getAttribute("selectedAccNo");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passbook | NexusBank</title>

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

        /* Filter Section */
        .filter-card {
            background: var(--bg-card);
            padding: 30px;
            border-radius: 16px;
            box-shadow: var(--shadow-card);
            margin-bottom: 30px;
            display: flex;
            align-items: flex-end;
            gap: 20px;
            flex-wrap: wrap;
        }

        .filter-group { flex-grow: 1; min-width: 250px; }
        .filter-label { display: block; margin-bottom: 10px; font-weight: 600; color: var(--brand-dark); }

        .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid var(--input-border);
            border-radius: 10px;
            font-size: 1rem;
            background: white;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%230052cc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1em;
            font-family: 'Poppins', sans-serif;
        }
        .form-select:focus { outline: none; border-color: var(--brand-primary); }

        .btn-filter {
            background: var(--brand-primary);
            color: white;
            border: none;
            padding: 14px 25px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .btn-filter:hover { background: #0046b0; }

        /* Transaction Table */
        .table-wrapper {
            background: var(--bg-card);
            border-radius: 16px;
            box-shadow: var(--shadow-card);
            overflow: hidden;
        }

        .txn-table {
            width: 100%;
            border-collapse: collapse;
        }

        .txn-table th {
            text-align: left;
            padding: 20px 25px;
            background: #f8f9fe;
            color: var(--text-muted);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #edf2f7;
        }

        .txn-table td {
            padding: 20px 25px;
            border-bottom: 1px solid #edf2f7;
            font-size: 0.95rem;
            color: var(--brand-dark);
        }

        .txn-table tr:last-child td { border-bottom: none; }
        .txn-table tr:hover { background-color: #fbfcfe; }

        /* Badge Styles */
        .badge {
            padding: 6px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-credit { background: var(--success-bg); color: var(--success-text); }
        .badge-debit { background: var(--danger-bg); color: var(--danger-text); }

        .amt-credit { color: var(--success-text); font-weight: 600; }
        .amt-debit { color: var(--danger-text); font-weight: 600; }
        
        .txn-id { font-family: monospace; color: var(--text-muted); font-size: 0.9rem; }
        .running-bal { font-weight: 700; color: var(--brand-dark); }

        /* Empty State */
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: var(--text-muted);
        }
        .empty-state i { font-size: 3rem; margin-bottom: 15px; color: #e0e6ed; }

        @media (max-width: 768px) { .dashboard-layout { flex-direction: column; height: auto; } .sidebar { width: 100%; height: auto; } .main-content { padding: 20px; } .filter-card { flex-direction: column; align-items: stretch; } .table-wrapper { overflow-x: auto; } }
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
            <li class="nav-item"><a href="<%=request.getContextPath()%>/customer/transfer" class="nav-link"><i class="fas fa-exchange-alt"></i> Fund Transfer</a></li>
            <li class="nav-item active"><a href="<%=request.getContextPath()%>/customer/passbook" class="nav-link"><i class="fas fa-history"></i> Passbook</a></li>
        </ul>
        <div class="logout-link">
            <a href="<%=request.getContextPath()%>/logout" class="nav-link" style="color: #ff8a8a;"><i class="fas fa-sign-out-alt"></i> Sign Out</a>
        </div>
    </aside>

    <main class="main-content">

        <div class="page-header">
            <h1>Transaction History</h1>
            <p>View statement and track expenses for your accounts.</p>
        </div>

        <form method="get" action="<%=request.getContextPath()%>/customer/passbook" class="filter-card">
            <div class="filter-group">
                <label for="accNo" class="filter-label">Select Account to View</label>
                <select name="accNo" id="accNo" class="form-select" required>
                    <option value="" disabled selected>-- Choose Account --</option>
                    <% 
                    for (Account a : accounts) {
                        String accStr = String.valueOf(a.getAccount_number());
                        String isSelected = accStr.equals(selectedAcc) ? "selected" : "";
                    %>
                    <option value="<%=accStr%>" <%= isSelected %>>
                        <%= accStr %> (Bal: ₹ <%= String.format("%.2f", a.getBalance()) %>)
                    </option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn-filter">
                <i class="fas fa-filter"></i> Get Statement
            </button>
        </form>

        <div class="table-wrapper">
            <% if (txns != null) { %>
                
                <table class="txn-table">
                    <thead>
                        <tr>
                            <th width="20%">Date & Time</th>
                            <th width="20%">Transaction ID</th>
                            <th width="15%">Type</th>
                            <th width="20%">Amount</th>
                            <th width="25%">Running Balance</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (txns.isEmpty()) { %>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <i class="fas fa-receipt"></i>
                                        <h3>No Transactions Found</h3>
                                        <p>There is no history available for the selected account yet.</p>
                                    </div>
                                </td>
                            </tr>
                        <% } else { 
                            for (Transaction t : txns) {
                                boolean isDebit = t.getTran_type().equalsIgnoreCase("DEBIT");
                        %>
                        <tr>
                            <td><%= t.getDate() %></td>
                            <td><span class="txn-id">#<%= t.getTransaction_id() %></span></td>
                            <td>
                                <span class="badge <%= isDebit ? "badge-debit" : "badge-credit" %>">
                                    <%= t.getTran_type().toUpperCase() %>
                                </span>
                            </td>
                            <td>
                                <span class="<%= isDebit ? "amt-debit" : "amt-credit" %>">
                                    <%= isDebit ? "-" : "+" %> ₹ <%= String.format("%.2f", t.getAmount()) %>
                                </span>
                            </td>
                            <td><span class="running-bal">₹ <%= String.format("%.2f", t.getBalance()) %></span></td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>

            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-search-dollar"></i>
                    <h3>Select an Account</h3>
                    <p>Please select an account from the dropdown above to view its passbook.</p>
                </div>
            <% } %>
        </div>

    </main>
</div>

</body>
</html>