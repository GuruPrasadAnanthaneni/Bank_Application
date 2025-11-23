<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.*"
         import="in.ps.bankapp.dto.Customer"
         import="in.ps.bankapp.dto.Account"
%>

<%
    Customer cust = (Customer) session.getAttribute("customer");
    
    // Safety check for accounts list to avoid null pointer exceptions
    ArrayList<Account> accounts = (ArrayList<Account>) request.getAttribute("accountsList");
    if(accounts == null) { accounts = new ArrayList<Account>(); }

    if (cust == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Accounts | NexusBank</title>

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
        --warning-bg: #fff3cd;
        --warning-text: #fb6340;
        
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

    /* --- SIDEBAR (Matches Dashboard) --- */
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

    .page-header {
        margin-bottom: 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .page-header h1 {
        font-size: 1.8rem;
        color: var(--brand-dark);
        font-weight: 700;
    }

    .page-header p {
        color: var(--text-muted);
        font-size: 0.95rem;
    }
    
    .add-btn {
        background: var(--brand-primary);
        color: white;
        padding: 10px 20px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.9rem;
        box-shadow: 0 4px 6px rgba(0, 82, 204, 0.2);
        transition: transform 0.2s;
    }
    .add-btn:hover { transform: translateY(-2px); }

    /* --- MODERN TABLE STYLING --- */
    .table-container {
        width: 100%;
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: separate; 
        border-spacing: 0 15px; /* Creates space between rows */
    }

    thead th {
        color: var(--text-muted);
        font-size: 0.85rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 0 25px;
        text-align: left;
    }

    tbody tr {
        background: var(--bg-card);
        box-shadow: var(--shadow-card);
        transition: transform 0.2s, box-shadow 0.2s;
        border-radius: 12px;
    }

    tbody tr:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-hover);
    }

    /* Rounded corners for the row */
    tbody td:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
    tbody td:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }

    td {
        padding: 20px 25px;
        color: var(--brand-dark);
        font-size: 0.95rem;
        vertical-align: middle;
    }

    /* Column Specifics */
    .col-id { font-weight: 600; color: var(--brand-primary); }
    
    .col-acc {
        font-family: 'Poppins', sans-serif; /* Keep sans-serif, clearer than monospace */
        font-weight: 600;
        letter-spacing: 1px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .eye-icon {
        cursor: pointer;
        color: var(--text-muted);
        font-size: 0.9rem;
        transition: color 0.2s;
    }
    .eye-icon:hover { color: var(--brand-primary); }

    .col-balance {
        font-weight: 700;
        font-size: 1.1rem;
        color: var(--brand-dark);
    }

    /* Status Pills */
    .status-badge {
        padding: 6px 14px;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .status-active { background: var(--success-bg); color: var(--success-text); }
    .status-inactive { background: var(--danger-bg); color: var(--danger-text); }
    .status-pending { background: var(--warning-bg); color: var(--warning-text); }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 50px;
        background: white;
        border-radius: 16px;
        box-shadow: var(--shadow-card);
    }
    .empty-state i { font-size: 3rem; color: #e0e6ed; margin-bottom: 15px; }
    .empty-state p { color: var(--text-muted); }

    @media (max-width: 768px) {
        .dashboard-layout { flex-direction: column; height: auto; }
        .sidebar { width: 100%; height: auto; }
        .nav-menu { display: flex; overflow-x: auto; padding-bottom: 10px; }
        .nav-item { margin-right: 10px; margin-bottom: 0; }
        .nav-link { white-space: nowrap; font-size: 0.8rem; }
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
            <li class="nav-item active">
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

        <div class="page-header">
            <div>
                <h1>My Accounts</h1>
                <p>Manage your linked accounts for <b><%= cust.getFirst_name() %></b>.</p>
            </div>
            <a href="<%=request.getContextPath()%>/customer/create-account" class="add-btn">
                <i class="fas fa-plus"></i> New Account
            </a>
        </div>

        <div class="table-container">
            <% if (accounts == null || accounts.isEmpty()) { %>
                
                <div class="empty-state">
                    <i class="fas fa-folder-open"></i>
                    <h3>No Accounts Found</h3>
                    <p>You haven't opened any accounts with NexusBank yet.</p>
                </div>

            <% } else { %>
            
            <table>
                <thead>
                    <tr>
                        <th width="10%">ID</th>
                        <th width="25%">Account Number</th>
                        <th width="15%">Type</th>
                        <th width="20%">Balance</th>
                        <th width="15%">Status</th>
                        <th width="15%">Date Opened</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    for (Account a : accounts) {
                        String st = a.getStatus();
                        String cssClass = "status-pending";
                        if (st.equalsIgnoreCase("Active")) cssClass = "status-active";
                        else if (st.equalsIgnoreCase("Inactive")) cssClass = "status-inactive";

                        String fullAcc = String.valueOf(a.getAccount_number());
                        String maskedAcc;
                        if (fullAcc.length() > 4) {
                            maskedAcc = "**** **** " + fullAcc.substring(fullAcc.length() - 4);
                        } else {
                            maskedAcc = fullAcc;
                        }
                %>

                <tr>
                    <td class="col-id">#<%= a.getAccount_id() %></td>

                    <td>
                        <div class="col-acc">
                            <span class="acc-val" data-full="<%= fullAcc %>"><%= maskedAcc %></span>
                            <i class="fas fa-eye-slash eye-icon toggle-eye"></i>
                        </div>
                    </td>

                    <td><%= a.getAccount_type() %></td>

                    <td class="col-balance">₹ <%= String.format("%.2f", a.getBalance()) %></td>

                    <td><span class="status-badge <%= cssClass %>"><%= st %></span></td>

                    <td style="color: var(--text-muted); font-size: 0.9rem;"><%= a.getDate() %></td>
                </tr>

                <% } %>
                </tbody>
            </table>
            
            <% } %>
        </div>

    </main>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".toggle-eye").forEach(icon => {
        icon.addEventListener("click", () => {
            const span = icon.previousElementSibling;
            const full = span.getAttribute("data-full");
            const masked = full.length > 4 ? "**** **** " + full.substring(full.length - 4) : full;

            if (span.textContent.trim() === masked.trim()) {
                // Show Full
                span.textContent = full;
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            } else {
                // Mask It
                span.textContent = masked;
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            }
        });
    });
});
</script>

</body>
</html>