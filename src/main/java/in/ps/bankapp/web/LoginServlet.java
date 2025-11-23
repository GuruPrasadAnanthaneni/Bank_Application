package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String mail = req.getParameter("email");
        String pinStr = req.getParameter("pin");

        int pin = Integer.parseInt(pinStr);

        CustomerDAO cdao = new CustomerDAOImp();
        Customer c = cdao.getCustomer(mail, pin);

        if (c != null) {

            HttpSession session = req.getSession();
            session.setAttribute("customer", c);

            // ADMIN LOGIN
            if (c.getCid() == 1) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                return;
            }

            // CUSTOMER LOGIN
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
        }
        else {
            req.setAttribute("error", "Invalid email or PIN!");
            req.setAttribute("emailValue", mail);
            req.getRequestDispatcher("SignIn.jsp").forward(req, resp);
        }
    }
}
