<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="in.ps.bankapp.dto.Account" %>
<%@ page import="in.ps.bankapp.dto.Customer" %>

<%
    // ** LOGIC REMAINS UNCHANGED **
    Customer adminUser = (Customer) session.getAttribute("customer");

    if (adminUser == null || adminUser.getCid() != 1) {
        response.sendRedirect(request.getContextPath() + "/SignIn.jsp");
        return;
    }

    ArrayList<Account> accounts =
        (ArrayList<Account>) request.getAttribute("accountsList");
    
    String adminFirstName = adminUser.getFirst_name();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin – View Accounts</title>
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

    --success-color: #28a745;
    --warning-color: #ffc107;
    --danger-color: #dc3545;
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

a { text-decoration: none; color: inherit; }

/* --- Layout: Grid Container (Consistent) --- */
.dashboard-container {
    display: grid;
    grid-template-columns: 240px 1fr; /* Narrower sidebar */
    height: 100vh;
    overflow: hidden;
}

/* --- Sidebar Styling (Consistent) --- */
.sidebar {
            background-color: var(--surface-light);
            border-right: 1px solid var(--border-color);
            padding: 30px 0; /* Increased padding */
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px var(--shadow-light);
            overflow-y: auto;
        }

        .logo-area {
            display: flex;
            align-items: center;
            padding: 0 25px 40px;
            font-size: 1.5em; /* Adjusted font size */
            font-weight: 700;
            color: var(--primary-color);
        }

        .logo-area i {
            margin-right: 12px;
            font-size: 1.2em;
        }

        .sidebar-nav ul { list-style: none; }

        .nav-item { margin-bottom: 4px; }

        .nav-item a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: var(--secondary-color);
            font-weight: 500;
            transition: all 0.2s ease-in-out;
            border-radius: 8px; /* Softer edges */
            margin: 0 15px;
        }

        .nav-item a i {
            margin-right: 15px;
            font-size: 18px;
            color: var(--text-light);
        }

        .nav-item.separator {
            height: 1px;
            background-color: var(--border-color);
            margin: 20px 25px;
        }

        .nav-item:hover a,
        .nav-item.active a {
            background-color: var(--primary-color);
            color: white !important;
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        }

        .nav-item:hover a i,
        .nav-item.active a i {
            color: white !important;
        }
        
        /* Highlight specific links */
        .nav-item.pending a { color: var(--warning-color); }
        .nav-item.danger a { color: var(--danger-color); }
        .nav-item.pending a i { color: var(--warning-color); }
        .nav-item.danger a i { color: var(--danger-color); }


/* --- Main content (Consistent) --- */
.main-content {
    display: flex;
    flex-direction: column;
    padding: 40px; /* Increased padding */
    overflow-y: auto;
}

.main-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
}

.header-title h1 {
    font-size: 2em;
    font-weight: 700;
}

.header-title p {
    font-size: 1em;
    color: var(--text-light);
}

.user-profile {
    display: flex;
    align-items: center;
    gap: 15px;
    color: var(--primary-color);
    font-weight: 600;
    background: var(--surface-light);
    padding: 8px 15px;
    border-radius: 8px;
    box-shadow: 0 2px 5px var(--shadow-light);
}

.profile-icon {
    font-size: 1.6em;
    color: var(--primary-color);
}

/* --- Table Card & Table Styles (Enhanced) --- */
.table-card {
    background: var(--surface-light);
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 5px 20px var(--shadow-light);
}

.table-card h2 {
    font-size: 1.5em;
    color: var(--secondary-color);
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
}

.table-wrapper {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.95em;
}

thead {
    background-color: var(--primary-color); /* Primary color header */
    color: white;
}

th {
    padding: 15px 18px; /* Increased padding */
    text-align: left;
    font-weight: 600;
    white-space: nowrap;
}
        
td {
    padding: 12px 18px; /* Adjusted padding */
    text-align: left;
    border-bottom: 1px solid var(--border-color);
    white-space: nowrap;
}

tbody tr:hover {
    background-color: var(--background-light); /* Hover uses background color */
}
        
tbody tr:last-child td {
    border-bottom: none;
}

/* Status Pills (Refined Colors) */
.status-pill {
    padding: 5px 12px; /* Increased size */
    border-radius: 999px;
    font-size: 0.8em;
    font-weight: 600;
    display: inline-block;
}

.status-active { background: rgba(40, 167, 69, 0.15); color: var(--success-color); }
.status-pending { background: rgba(255, 193, 7, 0.15); color: var(--warning-color); }
.status-inactive { background: rgba(220, 53, 69, 0.15); color: var(--danger-color); }

/* Action Buttons (Consistent Look) */
.actions { display: flex; gap: 8px; }

.action-btn {
    border: 1px solid var(--border-color); 
    border-radius: 8px; 
    padding: 8px 12px; 
    font-size: 0.85em; 
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: 0.2s ease;
    background: var(--surface-light);
    color: var(--secondary-color);
}
.action-btn.block {
    background: #fff3cd;        /* Light yellow */
    color: #d39e00;             /* Dark yellow */
}

.action-btn.block i {
    color: #d39e00;
}

.action-btn.block:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px var(--shadow-light);
}

.action-btn i { font-size: 1em; }

.action-btn.view { background: #e0f2fe; color: #3182ce; }
.action-btn.view i { color: #3182ce; }

.action-btn.edit { background: #e6fffa; color: #2c7a7b; }
.action-btn.edit i { color: #2c7a7b; }

.action-btn.delete { background: #ffebeb; color: #e53e3e; }
.action-btn.delete i { color: #e53e3e; }

.action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px var(--shadow-light);
}

.balance-amount {
    font-weight: 600;
    color: var(--secondary-color);
}
</style>
</head>

<body>

<div class="dashboard-container">

    <aside class="sidebar">
        <div class="logo-area">
            <i class="fas fa-university"></i>
            <span>NexusAdmin</span>
        </div>
        <nav class="sidebar-nav">
            <ul>
            
            	<li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/dashboard">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/customers">
                        <i class="fas fa-users"></i> Customers
                    </a>
                </li>
                <li class="nav-item active">
                    <a href="<%=request.getContextPath()%>/admin/accounts">
                        <i class="fas fa-wallet"></i> Accounts
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/transactions">
                        <i class="fas fa-exchange-alt"></i> Transactions
                    </a>
                </li>

                <li class="nav-item separator"></li>

                <li class="nav-item pending">
                    <a href="<%=request.getContextPath()%>/admin/pending-customers">
                        <i class="fas fa-user-check"></i> Cust. Approval
                    </a>
                </li>
                <li class="nav-item pending">
                    <a href="<%=request.getContextPath()%>/admin/pending-accounts">
                        <i class="fas fa-clipboard-check"></i> Acc. Approval
                    </a>
                </li>
                
                <li class="nav-item danger">
    				<a href="<%=request.getContextPath()%>/admin/blocked-customers">
        				<i class="fas fa-user-slash"></i> Blocked Customers
    				</a>
				</li>
                
                <li class="nav-item danger">
                    <a href="<%=request.getContextPath()%>/admin/blocked">
                        <i class="fas fa-ban"></i> Blocked Accounts
                    </a>
                </li>

                <li class="nav-item separator"></li>

                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">

        <header class="main-header">
            <div class="header-title">
                <h1><i class="fas fa-wallet" style="color: var(--primary-color);"></i> Account Management</h1>
                <p>View and manage all customer accounts across the bank.</p>
            </div>

            <div class="user-profile">
                <i class="fas fa-user-circle profile-icon"></i>
                <span>Hello, <%= adminFirstName %></span>
            </div>
        </header>

        <section class="table-card">
            <h2>Account List</h2>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ACC ID</th>
                            <th>ACC NO</th>
                            <th>CID</th>
                            <th>Type</th>
                            <th>Balance</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                    <%
                        // ** LOGIC REMAINS UNCHANGED **
                        if (accounts != null && !accounts.isEmpty()) {
                            for (Account a : accounts) {

                                String status = a.getStatus();
                                String css = "status-pending";
                                if ("Active".equalsIgnoreCase(status)) css = "status-active";
                                else if ("Inactive".equalsIgnoreCase(status) || "Blocked".equalsIgnoreCase(status)) css = "status-inactive";
                    %>

                        <tr>
                            <td><%= a.getAccount_id() %></td>
                            <td><%= a.getAccount_number() %></td>
                            <td><%= a.getCustomer_id() %></td>
                            <td><%= a.getAccount_type() %></td>
                            <td><span class="balance-amount">₹ <%= String.format("%.2f", a.getBalance()) %></span></td>

                            <td>
                                <span class="status-pill <%= css %>">
                                    <%= status.toUpperCase() %>
                                </span>
                            </td>

                            <td><%= a.getDate() %></td>

                            <td>
				    <div class="actions">
				
				        <!-- VIEW -->
				        <a href="<%=request.getContextPath()%>/admin/view-account-details?accId=<%=a.getAccount_id()%>"
   							class="action-btn view" title="View Details">
    						<i class="fas fa-eye"></i>
						</a>

				
				        <!-- EDIT -->
				        <a href="<%=request.getContextPath()%>/admin/edit-account-details?accId=<%=a.getAccount_id()%>"
   							class="action-btn edit" title="Edit Account">
    						<i class="fas fa-edit"></i>
						</a>


				
				        <!-- BLOCK / UNBLOCK -->
				        <!-- BLOCK / UNBLOCK -->
						<a href="<%=request.getContextPath()%>/admin/accounts/block?accId=<%=a.getAccount_id()%>"
						   class="action-btn block" title="Block / Unblock">
						    <i class="fas fa-user-slash"></i>
						</a>


				
				        <!-- DELETE -->
				        <a href="<%=request.getContextPath()%>/admin/accounts/delete?accId=<%=a.getAccount_id()%>"
   							class="action-btn delete" title="Delete Account"
   							onclick="return confirm('Are you sure you want to delete this account?');">
    						<i class="fas fa-trash"></i>
						</a>

				
				    </div>
				</td>


                        </tr>

                    <%
                            }
                        } else {
                    %>

                        <tr>
                            <td colspan="8" style="text-align:center; padding:20px; color: var(--text-light);">
                                <i class="fas fa-exclamation-circle"></i> No accounts found in the database.
                            </td>
                        </tr>

                    <% } %>
                    </tbody>

                </table>
            </div>

        </section>

    </main>

</div>

</body>
</html>