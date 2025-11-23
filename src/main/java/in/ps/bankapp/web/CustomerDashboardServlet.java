package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.*;
import in.ps.bankapp.dto.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CustomerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // login check
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        Customer cust = (Customer) session.getAttribute("customer");

        // Fetch accounts
        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> accounts = adao.getAccountByCustomerId(cust.getCid());
        req.setAttribute("accounts", accounts);

        // Fetch last 5 transactions
        TransactionDAO tdao = new TransactionDAOImp();
        ArrayList<Transaction> lastFive = tdao.getLastFiveTransactions(cust.getCid());
        req.setAttribute("lastFiveTransactions", lastFive);

        req.getRequestDispatcher("/CustomerDashboard.jsp").forward(req, resp);
    }
}
