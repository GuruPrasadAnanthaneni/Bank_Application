package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dto.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminPendingAccountApprovalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // ADMIN CHECK (cid = 1)
        in.ps.bankapp.dto.Customer admin =
                (in.ps.bankapp.dto.Customer) session.getAttribute("customer");

        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // FETCH PENDING ACCOUNTS
        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> list = adao.getPendingAccounts();

        req.setAttribute("pendingAccounts", list);

        // FORWARD
        req.getRequestDispatcher("/PendingAccountApproval.jsp")
                .forward(req, resp);
    }
}
