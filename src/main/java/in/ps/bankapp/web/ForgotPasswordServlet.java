package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String mail = req.getParameter("mail");
        String pin = req.getParameter("pin");
        String confirm = req.getParameter("confirmpin");

        CustomerDAO cdao = new CustomerDAOImp();
        Customer c = cdao.getCustomer(mail);

        // Email check
        if (c == null) {
            req.setAttribute("error", "Email not registered!");
            req.setAttribute("emailValue", mail);
            req.getRequestDispatcher("ForgotPassword.jsp").forward(req, resp);
            return;
        }

        // PIN matching
        if (!pin.equals(confirm)) {
            req.setAttribute("error", "PIN and Confirm PIN do not match!");
            req.setAttribute("emailValue", mail);
            req.getRequestDispatcher("ForgotPassword.jsp").forward(req, resp);
            return;
        }

        // Update DB
        c.setPassword(Integer.parseInt(pin));
        cdao.updateCustomer(c);

        req.setAttribute("success", "PIN updated successfully! Please login.");
        req.getRequestDispatcher("ForgotPassword.jsp").forward(req, resp);
    }
}
