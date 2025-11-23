package in.ps.bankapp.web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;

public class AdminRejectCustomerServlet extends HttpServlet {

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
        if (((in.ps.bankapp.dto.Customer) session.getAttribute("customer")).getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        int cid = Integer.parseInt(req.getParameter("cid"));

        CustomerDAO dao = new CustomerDAOImp();
        boolean status = dao.rejectCustomer(cid);

        if (status) {
            resp.sendRedirect(req.getContextPath() + "/admin/pending-customers?success=rejected");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/pending-customers?error=db");
        }
    }
}
