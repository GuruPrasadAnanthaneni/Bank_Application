package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminEditAccountsDetailsServlet extends HttpServlet {

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

        int accId = Integer.parseInt(req.getParameter("accId"));

        AccountDAO adao = new AccountDAOImp();
        Account a = adao.getAccount(accId);

        req.setAttribute("acc", a);
        req.getRequestDispatcher("/AdminEditAccountDetails.jsp").forward(req, resp);

    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int accId = Integer.parseInt(req.getParameter("accId"));
        long accNo = Long.parseLong(req.getParameter("accNo"));
        int cid = Integer.parseInt(req.getParameter("cid"));
        String type = req.getParameter("type");
        double balance = Double.parseDouble(req.getParameter("balance"));
        String status = req.getParameter("status");

        Account a = new Account();
        a.setAccount_id(accId);
        a.setAccount_number(accNo);
        a.setCustomer_id(cid);
        a.setAccount_type(type);
        a.setBalance(balance);
        a.setStatus(status);

        AccountDAO adao = new AccountDAOImp();
        adao.updateAccount(a);

        resp.sendRedirect(req.getContextPath() + "/admin/accounts");
    }
}
