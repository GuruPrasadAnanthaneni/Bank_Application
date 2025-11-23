package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dao.TransactionDAO;
import in.ps.bankapp.dao.TransactionDAOImp;

import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Customer;
import in.ps.bankapp.dto.Transaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminViewAccountsDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // ADMIN CHECK
        Customer admin = (Customer) session.getAttribute("customer");
        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        try {
            int accId = Integer.parseInt(req.getParameter("accId"));

            // === GET ACCOUNT DETAILS ===
            AccountDAO adao = new AccountDAOImp();
            Account account = adao.getAccount(accId);

            if (account == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/accounts");
                return;
            }

            // === GET CUSTOMER DETAILS ===
            CustomerDAO cdao = new CustomerDAOImp();
            Customer customer = cdao.getCustomer(account.getCustomer_id());

            // === GET TRANSACTION DETAILS ===
            TransactionDAO tdao = new TransactionDAOImp();
            ArrayList<Transaction> txnList =
                    tdao.getTransactionsByCustomerId(account.getCustomer_id());

            // SET ATTRIBUTES
            req.setAttribute("account", account);
            req.setAttribute("customer", customer);
            req.setAttribute("txnList", txnList);

            req.getRequestDispatcher("/AdminViewAccountsDetails.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/accounts");
        }
    }
}
