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

public class AdminToggleAccountBlockServlet extends HttpServlet {

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
        in.ps.bankapp.dto.Customer admin =
                (in.ps.bankapp.dto.Customer) session.getAttribute("customer");

        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // READ ACCOUNT ID
        int accId = Integer.parseInt(req.getParameter("accId"));

        AccountDAO adao = new AccountDAOImp();
        Account acc = adao.getAccount(accId);

        if (acc != null) {

            String currentStatus = acc.getStatus();

            // TOGGLE LOGIC
            if ("Active".equalsIgnoreCase(currentStatus)) {
                acc.setStatus("Inactive"); // BLOCK
            } else {
                acc.setStatus("Active");   // UNBLOCK
            }

            // Update DB
            adao.updateAccount(acc);
        }

        // REDIRECT BACK
        resp.sendRedirect(req.getContextPath() + "/admin/accounts");
    }
}
