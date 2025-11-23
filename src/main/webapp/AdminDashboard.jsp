<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" import="in.ps.bankapp.dto.Customer" import="in.ps.bankapp.dto.Account" import="in.ps.bankapp.dto.Transaction" %> 
<% 
    // ** LOGIC REMAINS UNCHANGED ** // Values coming from AdminDashboardServlet 
    Integer pendingCustomers = (Integer) request.getAttribute("pendingCustomers"); 
    Integer pendingAccounts = (Integer) request.getAttribute("pendingAccounts"); 
    Integer blockedAccounts = (Integer) request.getAttribute("blockedAccounts"); 
    Integer blockedCustomers = (Integer) request.getAttribute("blockedCustomers"); 
    Integer todayTransactions = (Integer) request.getAttribute("todayTransactions"); 

    if (pendingCustomers == null) pendingCustomers = 0; 
    if (pendingAccounts == null) pendingAccounts = 0; 
    if (blockedAccounts == null) blockedAccounts = 0; 
    if (todayTransactions == null) todayTransactions = 0; 
    if (blockedCustomers == null) blockedCustomers = 0; 

    // logged in admin 
    Customer adminUser = (Customer) session.getAttribute("customer"); 
    String adminName = (adminUser != null) ? adminUser.getFirst_name() + " " + adminUser.getLast_name() : "Admin User"; 

    // IMPORTANT → declare all lists so JSP compiler will not cry 
    ArrayList<Customer> latestCust = (ArrayList<Customer>) request.getAttribute("latestCustomers"); 
    ArrayList<Account> latestAcc = (ArrayList<Account>) request.getAttribute("latestAccounts"); 
    ArrayList<Transaction> latestTx = (ArrayList<Transaction>) request.getAttribute("latestTransactions"); 
    ArrayList<Account> latestBlocked = (ArrayList<Account>) request.getAttribute("latestBlocked"); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - NexusBank</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

    <style>
        /* --- Global Styles & Variables (REFINED) --- */
        :root {
            --primary-color: #007bff; /* Blue */
            --secondary-color: #343a40; /* Dark Grey/Black */
            --background-light: #f4f7f9; /* Soft Light Blue-Grey */
            --surface-light: #ffffff;
            --border-color: #e9ecef;
            --text-light: #6c757d; /* Muted text */
            --shadow-light: rgba(0, 0, 0, 0.08);
            --shadow-medium: rgba(0, 0, 0, 0.15);

            /* ADDED FOR NEW UI */
            --sidebar-dark: #2c3e50; /* Deep Navy Blue */
            --text-sidebar: #ecf0f1; /* Off-white text */

            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --risk-color: #e67e22;
            --system-color: #17a2b8;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background-light);
            color: var(--secondary-color);
            line-height: 1.6;
            font-size: 15px;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* --- Layout: Grid Container --- */
        .dashboard-container {
            display: grid;
            grid-template-columns: 240px 1fr;
            height: 100vh;
            overflow: hidden;
        }

        /* --- Sidebar Styling --- */
        .sidebar {
            background-color: var(--surface-light);
            border-right: 1px solid var(--border-color);
            padding: 30px 0;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px var(--shadow-light);
            overflow-y: auto;
        }

        .logo-area {
            display: flex;
            align-items: center;
            padding: 0 25px 40px;
            font-size: 1.5em;
            font-weight: 700;
            color: var(--primary-color);
        }

        .logo-area i {
            margin-right: 12px;
        }

        .sidebar-nav ul {
            list-style: none;
        }

        .nav-item {
            margin-bottom: 4px;
        }

        .nav-item a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: var(--secondary-color);
            font-weight: 500;
            border-radius: 8px;
            margin: 0 15px;
            transition: .2s;
        }

        .nav-item a i {
            margin-right: 15px;
            font-size: 18px;
            color: var(--text-light);
        }

        .nav-item.pending a { color: var(--warning-color); }
        .nav-item.danger a { color: var(--danger-color); }

        .nav-item:hover a,
        .nav-item.active a {
            background-color: var(--primary-color);
            color: white !important;
            box-shadow: 0 4px 8px rgba(0,123,255,0.3);
        }

        .nav-item:hover a i,
        .nav-item.active a i {
            color: white !important;
        }

        .nav-item.separator {
            height: 1px;
            background-color: var(--border-color);
            margin: 20px 25px;
        }

        .badge {
            background-color: var(--primary-color);
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: .75em;
            margin-left: auto;
        }

        .nav-item.pending .badge { background-color: var(--warning-color); }
        .nav-item.danger .badge { background-color: var(--danger-color); }

        /* --- Main Content --- */
        .main-content {
            display: flex;
            flex-direction: column;
            padding: 40px;
            overflow-y: auto;
        }

        .main-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }

        .header-title h1 {
            font-size: 2em;
            font-weight: 700;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 8px 15px;
            border-radius: 8px;
            background: var(--surface-light);
            box-shadow: 0 2px 5px var(--shadow-light);
        }

        .profile-icon {
            font-size: 1.6em;
            color: var(--primary-color);
        }

        /* Stats */
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px,1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .stat-card {
            padding: 30px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 20px;
            background: var(--surface-light);
            box-shadow: 0 5px 20px var(--shadow-light);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px var(--shadow-medium);
        }

        .card-icon {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8em;
            border-radius: 50%;
        }

        .card-icon.primary { background: rgba(0,123,255,0.1); color: var(--primary-color); }
        .card-icon.warning { background: rgba(255,193,7,0.1); color: var(--warning-color); }
        .card-icon.danger  { background: rgba(220,53,69,0.1); color: var(--danger-color); }
        .card-icon.success { background: rgba(40,167,69,0.1); color: var(--success-color); }

        .card-info .card-label {
            color: var(--text-light);
            font-size: 0.95em;
        }

        .card-info .card-value {
            font-size: 2.2em;
        }

        /* Recent Activity */
        .activity-columns {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px,1fr));
            gap: 30px;
        }

        .activity-box {
            background: var(--surface-light);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 16px var(--shadow-light);
        }

        .activity-box h3 {
            font-size: 1.25em;
            color: var(--primary-color);
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 10px;
            margin-bottom: 15px;
        }

        .activity-list {
            list-style: none;
        }

        .activity-list li {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px dashed var(--border-color);
            font-size: 0.9em;
        }

        .activity-list li:last-child {
            border-bottom: none;
        }

        .txn-type.DEBIT { color: var(--danger-color); }
        .txn-type.CREDIT { color: var(--success-color); }

        .placeholder-content {
            text-align: center;
            color: var(--text-light);
            padding: 10px 0;
        }
    </style>
</head>

<body>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="logo-area">
                <i class="fas fa-university"></i>&nbsp;NexusAdmin
            </div>

            <nav class="sidebar-nav">
                <ul>
                    <li class="nav-item active"><a href="<%=request.getContextPath()%>/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a></li>
                    <li class="nav-item"><a href="<%=request.getContextPath()%>/admin/customers"><i class="fas fa-users"></i> Customers</a></li>
                    <li class="nav-item"><a href="<%=request.getContextPath()%>/admin/accounts"><i class="fas fa-wallet"></i> Accounts</a></li>
                    <li class="nav-item"><a href="<%=request.getContextPath()%>/admin/transactions"><i class="fas fa-exchange-alt"></i> Transactions</a></li>

                    <li class="nav-item separator"></li>

                    <li class="nav-item pending"><a href="<%=request.getContextPath()%>/admin/pending-customers"><i class="fas fa-user-check"></i> Cust. Approval <span class="badge"><%= pendingCustomers %></span></a></li>

                    <li class="nav-item pending"><a href="<%=request.getContextPath()%>/admin/pending-accounts"><i class="fas fa-clipboard-check"></i> Acc. Approval <span class="badge"><%= pendingAccounts %></span></a></li>

                    <li class="nav-item danger"><a href="<%=request.getContextPath()%>/admin/blocked-customers"><i class="fas fa-user-slash"></i> Blocked Customers <span class="badge"><%= blockedCustomers %></span></a></li>

                    <li class="nav-item danger"><a href="<%=request.getContextPath()%>/admin/blocked"><i class="fas fa-ban"></i> Blocked Accounts <span class="badge"><%= blockedAccounts %></span></a></li>

                    <li class="nav-item separator" style="margin-top:30px;"></li>

                    <li class="nav-item"><a href="<%=request.getContextPath()%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>

                </ul>
            </nav>
        </aside>

        <main class="main-content">
            <header class="main-header">
                <div class="header-title">
                    <h1><i class="fas fa-chart-line" style="color: var(--primary-color);"></i> Admin Dashboard</h1>
                </div>

                <div class="user-profile">
                    <i class="fas fa-user-circle profile-icon"></i>
                    <span>Hello, <%= adminName.split(" ")[0] %></span>
                </div>
            </header>

            <section class="stats-overview">

                <div class="stat-card">
                    <div class="card-icon primary"><i class="fas fa-user-plus"></i></div>
                    <div class="card-info">
                        <div class="card-label">Pending Customers</div>
                        <div class="card-value"><%= pendingCustomers %></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon warning"><i class="fas fa-clipboard-list"></i></div>
                    <div class="card-info">
                        <div class="card-label">Pending Accounts</div>
                        <div class="card-value"><%= pendingAccounts %></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon danger"><i class="fas fa-lock"></i></div>
                    <div class="card-info">
                        <div class="card-label">Blocked Customers</div>
                        <div class="card-value"><%= blockedCustomers %></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon danger"><i class="fas fa-lock"></i></div>
                    <div class="card-info">
                        <div class="card-label">Blocked Accounts</div>
                        <div class="card-value"><%= blockedAccounts %></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon success"><i class="fas fa-hand-holding-usd"></i></div>
                    <div class="card-info">
                        <div class="card-label">Transactions Today</div>
                        <div class="card-value"><%= todayTransactions %></div>
                    </div>
                </div>

            </section>

            <section class="recent-activity-section">

                <div class="activity-columns">

                    <div class="activity-box">
                        <h3><i class="fas fa-users"></i> Latest Customers</h3>
                        <ul class="activity-list">
                            <% if (latestCust != null && !latestCust.isEmpty()) {
                                for (Customer c : latestCust) { %>
                                <li>
                                    <span><%= c.getFirst_name() + " " + c.getLast_name() %></span>
                                    <span><%= c.getDate() %></span>
                                </li>
                            <% }} else { %>
                                <p class="placeholder-content">No recent customers found.</p>
                            <% } %>
                        </ul>
                    </div>

                    <div class="activity-box">
                        <h3><i class="fas fa-wallet"></i> Latest Accounts</h3>
                        <ul class="activity-list">
                            <% if (latestAcc != null && !latestAcc.isEmpty()) {
                                for (Account a : latestAcc) { %>
                                <li>
                                    <span>Acc: **<%= a.getAccount_number() %>**</span>
                                    <span><%= a.getDate() %></span>
                                </li>
                            <% }} else { %>
                                <p class="placeholder-content">No recent accounts found.</p>
                            <% } %>
                        </ul>
                    </div>

                    <div class="activity-box">
                        <h3><i class="fas fa-exchange-alt"></i> Latest Transactions</h3>
                        <ul class="activity-list">
                            <% if (latestTx != null && !latestTx.isEmpty()) {
                                for (Transaction t : latestTx) { %>
                                <li>
                                    <span>
                                        <span class="txn-type <%= t.getTran_type().toUpperCase() %>"><%= t.getTran_type().toUpperCase() %></span>
                                        **₹<%= String.format("%.2f", t.getAmount()) %>**
                                    </span>
                                    <span><%= t.getDate() %></span>
                                </li>
                            <% }} else { %>
                                <p class="placeholder-content">No recent transactions found.</p>
                            <% } %>
                        </ul>
                    </div>

                </div>
            </section>

        </main>
    </div>

</body>
</html>