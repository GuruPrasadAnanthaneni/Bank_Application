package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dto.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CustomerCheckBalanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        req.setAttribute("activePage", "checkbalance");
        req.getRequestDispatcher("/CustomerCheckBalance.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        String accNoStr = req.getParameter("accNo");

        AccountDAO adao = new AccountDAOImp();
        Account acc = null;

        try {
            long accNo = Long.parseLong(accNoStr);
            acc = adao.getAccount(accNo);
        } catch (Exception e) {
            req.setAttribute("error", "Invalid account number");
        }

        if (acc == null) {
            req.setAttribute("error", "Account not found or inactive");
        } else {
            req.setAttribute("balanceAccount", acc);
        }

        req.setAttribute("activePage", "checkbalance");
        req.getRequestDispatcher("/CustomerCheckBalance.jsp").forward(req, resp);
    }
}
