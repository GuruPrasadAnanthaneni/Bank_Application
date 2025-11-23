<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="in.ps.bankapp.dto.Account" %>
<%@ page import="in.ps.bankapp.dto.Customer" %>

<%
    // ** LOGIC REMAINS UNCHANGED **
    ArrayList<Account> accounts =
        (ArrayList<Account>) request.getAttribute("pendingAccounts");
    
    // Fetching admin name for consistency, assuming the session customer object is available
    Customer adminUser = (Customer) session.getAttribute("customer");
    String adminFirstName = (adminUser != null) ? adminUser.getFirst_name() : "Admin";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin – Pending Account Approval</title>
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

        * { box-sizing: border-box; margin: 0; padding: 0; }
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
            grid-template-columns: 240px 1fr;
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
        .main-content { padding: 40px; overflow-y: auto; }

        .main-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 30px; padding-bottom: 10px; border-bottom: 1px solid var(--border-color);
        }

        .header-title h1 { font-size: 2em; font-weight: 700; }
        .header-title p { font-size: 1em; color: var(--text-light); }
        
        .user-profile {
            display: flex; align-items: center; gap: 15px;
            color: var(--primary-color); font-weight: 600;
            background: var(--surface-light); padding: 8px 15px;
            border-radius: 8px; box-shadow: 0 2px 5px var(--shadow-light);
        }

        .profile-icon { font-size: 1.6em; color: var(--primary-color); }

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

        table { width: 100%; border-collapse: collapse; font-size: 0.95em; }

        thead { background-color: var(--primary-color); color: white; }
        th { padding: 15px 18px; text-align: left; font-weight: 600; white-space: nowrap; }
        td { padding: 12px 18px; text-align: left; border-bottom: 1px solid var(--border-color); white-space: nowrap; }
        tbody tr:hover { background-color: var(--background-light); }
        tbody tr:last-child td { border-bottom: none; }

        /* --- Action Buttons (Approval Specific) --- */
        .actions { display: flex; gap: 10px; }

        .action-btn {
            padding: 8px 15px; 
            border: none;
            border-radius: 6px; 
            font-size: 0.9em;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s ease;
            text-transform: uppercase;
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .approve {
            background-color: var(--success-color);
            color: white;
        }

        .approve:hover { background-color: #218838; }

        .reject {
            background-color: var(--danger-color);
            color: white;
        }

        .reject:hover { background-color: #c82333; }
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
                    <a href="<%=request.getContextPath()%>/admin/customers"><i class="fas fa-users"></i> Customers</a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/accounts"><i class="fas fa-wallet"></i> Accounts</a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/transactions"><i class="fas fa-exchange-alt"></i> Transactions</a>
                </li>
                
                <li class="nav-item separator"></li>

                <li class="nav-item pending">
                    <a href="<%=request.getContextPath()%>/admin/pending-customers"><i class="fas fa-user-check"></i> Cust. Approval</a>
                </li>

                <li class="nav-item pending active">
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
                    <a href="<%=request.getContextPath()%>/admin/blocked"><i class="fas fa-ban"></i> Blocked Accounts</a>
                </li>
                
                <li class="nav-item separator"></li>

                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </li>
            </ul>
        </nav>
    </aside>


    <main class="main-content">

        <header class="main-header">
            <div class="header-title">
                <h1><i class="fas fa-clipboard-check" style="color: var(--warning-color);"></i> Pending Account Requests</h1>
                <p>Review and process newly created customer account requests.</p>
            </div>
            <div class="user-profile">
                <i class="fas fa-user-circle profile-icon"></i>
                <span>Hello, <%= adminFirstName %></span>
            </div>
        </header>

        <section class="table-card">
            <h2>New Account Requests</h2>

            <table>
                <thead>
                <tr>
                    <th>Account No</th>
                    <th>CID</th>
                    <th>Type</th>
                    <th>Balance</th>
                    <th>Requested On</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <% 
                    // ** LOGIC REMAINS UNCHANGED **
                    if (accounts != null && !accounts.isEmpty()) {
                        for (Account a : accounts) {
                %>

                <tr>
                    <td><%= a.getAccount_number() %></td>
                    <td><%= a.getCustomer_id() %></td>
                    <td><%= a.getAccount_type() %></td>
                    <td>₹ <%= String.format("%.2f", a.getBalance()) %></td>
                    <td><%= a.getDate() %></td>

                    <td>
                        <div class="actions">

                            <a class="action-btn approve"
                               href="<%=request.getContextPath()%>/admin/account/approve?accId=<%=a.getAccount_id()%>"
                               title="Approve Account">
                                <i class="fas fa-check"></i> Approve
                            </a>

                            <a class="action-btn reject"
                               href="<%=request.getContextPath()%>/admin/account/reject?accId=<%=a.getAccount_id()%>"
                               title="Reject Account">
                                <i class="fas fa-times"></i> Reject
                            </a>

                        </div>
                    </td>
                </tr>

                <%  }
                    } else { %>

                <tr>
                    <td colspan="6" style="text-align:center; padding:20px; color: var(--text-light);">
                        <i class="fas fa-info-circle"></i> No pending account creation requests.
                    </td>
                </tr>

                <% } %>

                </tbody>
            </table>

        </section>

    </main>

</div>

</body>
</html>