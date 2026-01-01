<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
import="in.ps.bankapp.dto.*"
import="in.ps.bankapp.dao.*"
import="java.util.*"
%>

<%
    // --- BACKEND LOGIC (Unchanged) ---

    Customer cust = (Customer) session.getAttribute("customer");

    if (cust == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }

    AccountDAO adao = new AccountDAOImp();
    ArrayList<Account> accounts = adao.getAccountByCustomerId(cust.getCid());

    int totalAccounts = accounts.size();

    double totalBalance = 0;
    for (Account a : accounts) {
        totalBalance += a.getBalance();
    }

    TransactionDAO tdao = new TransactionDAOImp();
    ArrayList<Transaction> lastFive = tdao.getLastFiveTransactions(cust.getCid());
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard | NexusBank</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<style>
:root {
    --brand-dark: #0a2540;
    --brand-primary: #0052cc;
    --brand-accent: #00d4ff;
    --bg-body: #f4f7fa;
    --bg-card: #ffffff;
    --text-main: #32325d;
    --text-muted: #8898aa;
    --success: #2dce89;
    --danger: #f5365c;
    --warning: #fb6340;
    --shadow-card: 0 4px 20px rgba(0, 0, 0, 0.05);
    --shadow-hover: 0 10px 25px rgba(50, 50, 93, 0.1);
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

/* --- SIDEBAR --- */
.sidebar {
    width: var(--sidebar-width);
    background: var(--brand-dark);
    color: white;
    display: flex;
    flex-direction: column;
    transition: all 0.3s ease;
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
    letter-spacing: 0.5px;
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

.nav-link i {
    margin-right: 15px;
    width: 20px;
    text-align: center;
    font-size: 1.1rem;
}

.nav-link:hover {
    background: rgba(255,255,255, 0.05);
    color: white;
}

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
    position: relative;
}

.header-flex {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 40px;
}

.welcome-text h1 {
    font-size: 1.8rem;
    color: var(--brand-dark);
    font-weight: 700;
    margin-bottom: 5px;
}

.welcome-text p { color: var(--text-muted); font-size: 0.95rem; }

.profile-pill {
    background: white;
    padding: 8px 20px;
    border-radius: 50px;
    display: flex;
    align-items: center;
    gap: 12px;
    box-shadow: var(--shadow-card);
    font-weight: 600;
    font-size: 0.9rem;
    color: var(--brand-dark);
}

.profile-pill i { font-size: 1.5rem; color: var(--brand-primary); }

/* Stats Grid */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 25px;
    margin-bottom: 40px;
}

.stat-card {
    background: var(--bg-card);
    padding: 25px;
    border-radius: 16px;
    box-shadow: var(--shadow-card);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    position: relative;
    overflow: hidden;
    border: 1px solid rgba(0,0,0,0.02);
}

.stat-card:hover {
    transform: translateY(-5px);
    box-shadow: var(--shadow-hover);
}

.stat-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.3rem;
    margin-bottom: 15px;
}

.card-blue .stat-icon { background: rgba(0, 82, 204, 0.1); color: var(--brand-primary); }
.card-green .stat-icon { background: rgba(45, 206, 137, 0.1); color: var(--success); }
.card-purple .stat-icon { background: rgba(89, 45, 206, 0.1); color: #5e72e4; }
.card-orange .stat-icon { background: rgba(251, 99, 64, 0.1); color: var(--warning); }

.stat-title {
    color: var(--text-muted);
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 8px;
}

.stat-value {
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--brand-dark);
    display: flex;
    align-items: center;
    gap: 10px;
}

/* Recent Activity */
.table-section {
    background: white;
    border-radius: 16px;
    box-shadow: var(--shadow-card);
    padding: 30px;
}

.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}

.section-header h2 {
    font-size: 1.25rem;
    color: var(--brand-dark);
}

.view-all {
    font-size: 0.9rem;
    color: var(--brand-primary);
    text-decoration: none;
    font-weight: 600;
}

.view-all:hover { text-decoration: underline; }

.transaction-list { list-style: none; }

.transaction-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 18px 0;
    border-bottom: 1px solid #edf2f7;
}

.transaction-item:last-child { border-bottom: none; }

.t-left { display: flex; align-items: center; gap: 15px; }

.t-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.icon-debit { background: #ffebee; color: var(--danger); }
.icon-credit { background: #e8f5e9; color: var(--success); }

.t-info h4 { font-size: 0.95rem; color: var(--brand-dark); }
.t-info span { font-size: 0.8rem; color: var(--text-muted); }

.t-amount {
    font-weight: 700;
    font-size: 1rem;
}

.text-success { color: var(--success); }
.text-danger { color: var(--danger); }
</style>
</head>

<body>

<div class="dashboard-layout">

<aside class="sidebar">
    <div class="brand-logo">
        <i class="fas fa-cube"></i> NexusBank
    </div>

    <ul class="nav-menu">
        <li class="nav-item active">
            <a href="<%=request.getContextPath()%>/customer/dashboard" class="nav-link">
                <i class="fas fa-chart-pie"></i> Dashboard
            </a>
        </li>

        <li class="nav-item">
            <a href="<%=request.getContextPath()%>/customer/accounts" class="nav-link">
                <i class="fas fa-wallet"></i> My Accounts
            </a>
        </li>

        <li class="nav-item">
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

<div class="header-flex">
    <div class="welcome-text">
        <h1>Hello, <%= cust.getFirst_name() %></h1>
        <p>Here's your financial overview for today.</p>
    </div>

    <div class="profile-pill">
        <span><%= cust.getMail() %></span>
        <i class="fas fa-user-circle"></i>
    </div>
</div>

<section class="stats-grid">

    <div class="stat-card card-blue">
        <div class="stat-icon"><i class="fas fa-layer-group"></i></div>
        <div class="stat-title">Total Accounts</div>
        <div class="stat-value"><%= totalAccounts %></div>
    </div>

    <div class="stat-card card-green">
        <div class="stat-icon"><i class="fas fa-coins"></i></div>
        <div class="stat-title">Total Balance</div>
        <div class="stat-value">
            <span id="balanceHidden">₹ ••••••</span>
            <span id="balanceText" style="display:none;">₹ <%= String.format("%.2f", totalBalance) %></span>
            <i id="toggleEye" class="fas fa-eye-slash eye-btn" onclick="toggleBalance()" style="font-size: 0.6em; margin-left: 10px;"></i>
        </div>
    </div>

    <div class="stat-card card-purple">
        <div class="stat-icon"><i class="fas fa-fingerprint"></i></div>
        <div class="stat-title">Customer ID</div>
        <div class="stat-value" style="font-size: 1.4rem;"><%= cust.getCid() %></div>
    </div>

    <div class="stat-card card-orange">
        <div class="stat-icon"><i class="fas fa-user-shield"></i></div>
        <div class="stat-title">Account Status</div>
        <div class="stat-value" style="font-size: 1.4rem;"><%= cust.getStatus() %></div>
    </div>

</section>

<section class="table-section">
<div class="section-header">
    <h2>Recent Activity</h2>
    <a href="<%=request.getContextPath()%>/customer/passbook" class="view-all">View All <i class="fas fa-arrow-right"></i></a>
</div>

<ul class="transaction-list">

<% if (lastFive == null || lastFive.size() == 0) { %>
    <li class="transaction-item">
        <span style="color: var(--text-muted); width: 100%; text-align: center; padding: 20px;">No recent transactions found.</span>
    </li>
<% } else {
    for (Transaction t : lastFive) {

        boolean isDebit = t.getTran_type().equalsIgnoreCase("DEBIT");
%>

<li class="transaction-item">
    <div class="t-left">
        <div class="t-icon <%= isDebit ? "icon-debit" : "icon-credit" %>">
            <i class="fas <%= isDebit ? "fa-arrow-up" : "fa-arrow-down" %>"></i>
        </div>
        <div class="t-info">
            <h4><%= isDebit ? "Transfer to " + t.getReciever_acc() : "Received from " + t.getSender_acc() %></h4>
            <span><%= t.getDate() %></span>
        </div>
    </div>

    <div class="t-amount <%= isDebit ? "text-danger" : "text-success" %>">
        <%= isDebit ? "-" : "+" %> ₹ <%= String.format("%.2f", t.getAmount()) %>
    </div>
</li>

<% }} %>

</ul>
</section>

</main>
</div>

<script>
function toggleBalance() {
    let balanceText = document.getElementById("balanceText");
    let balanceHidden = document.getElementById("balanceHidden");
    let eye = document.getElementById("toggleEye");

    if (balanceText.style.display === "none") {
        balanceText.style.display = "inline";
        balanceHidden.style.display = "none";
        eye.classList.remove("fa-eye-slash");
        eye.classList.add("fa-eye");
    } else {
        balanceText.style.display = "none";
        balanceHidden.style.display = "inline";
        eye.classList.remove("fa-eye");
        eye.classList.add("fa-eye-slash");
    }
}
</script>

</body>
</html>