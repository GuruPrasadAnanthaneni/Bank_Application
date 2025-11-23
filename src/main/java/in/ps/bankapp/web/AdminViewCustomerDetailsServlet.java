package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.TransactionDAO;
import in.ps.bankapp.dao.TransactionDAOImp;

import in.ps.bankapp.dto.Customer;
import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Transaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminViewCustomerDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        Customer admin = (Customer) session.getAttribute("customer");

        // ADMIN CHECK 
        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // Get customer id from parameter
        String cidParam = req.getParameter("cid");
        if (cidParam == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }

        int cid = Integer.parseInt(cidParam);

        // DAO Objects
        CustomerDAO cdao = new CustomerDAOImp();
        AccountDAO adao = new AccountDAOImp();
        TransactionDAO tdao = new TransactionDAOImp();

        // Get customer details
        Customer cust = cdao.getCustomer(cid);

        if (cust == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }

        // Get all accounts of this customer
        ArrayList<Account> accounts = adao.getAccountByCustomerId(cid);

        // Get all transactions of this customer
        ArrayList<Transaction> transactions = tdao.getTransactionsByCustomerId(cid);

        // Set attributes for JSP
        req.setAttribute("customer", cust);
        req.setAttribute("accounts", accounts);
        req.setAttribute("transactions", transactions);

        // Forward to JSP
        req.getRequestDispatcher("/AdminViewCustomerDetails.jsp")
           .forward(req, resp);
    }
}
