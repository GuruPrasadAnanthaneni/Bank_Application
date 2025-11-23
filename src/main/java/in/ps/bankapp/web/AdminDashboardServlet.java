package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dao.TransactionDAO;
import in.ps.bankapp.dao.TransactionDAOImp;
import in.ps.bankapp.dto.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // ADMIN CHECK (CID = 1)
        Customer admin = (Customer) session.getAttribute("customer");

        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        CustomerDAO cdao = new CustomerDAOImp();
        AccountDAO adao = new AccountDAOImp();
        TransactionDAO tdao = new TransactionDAOImp();

        // COUNTERS (CORRECTED)
        req.setAttribute("pendingCustomers", cdao.getPendingCustomers().size());
        req.setAttribute("pendingAccounts", adao.getPendingAccounts().size());
        req.setAttribute("blockedAccounts", adao.getBlockedAccounts().size());

        // ❗ MISSING EARLIER — FIXED NOW
        req.setAttribute("blockedCustomers", cdao.getBlockedCustomers().size());

        // today transactions (ONLY once)
        req.setAttribute("todayTransactions", tdao.getTodayTransactions().size());

        // LATEST LISTS
        req.setAttribute("latestCustomers", cdao.getLatestCustomers());
        req.setAttribute("latestAccounts", adao.getLatestAccounts());
        req.setAttribute("latestTransactions", tdao.getLatestTransactions());
        req.setAttribute("latestBlocked", adao.getLatestBlockedAccounts());

        req.getRequestDispatcher("/AdminDashboard.jsp")
                .forward(req, resp);
    }
}
