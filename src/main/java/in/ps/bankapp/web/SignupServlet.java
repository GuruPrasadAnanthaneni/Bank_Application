package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fname = req.getParameter("fname");
        String lname = req.getParameter("lname");
        String phone = req.getParameter("pho");
        String mail = req.getParameter("mail");
        String pin = req.getParameter("pin");
        String confirmPin = req.getParameter("confirmpin");

        // Store entered values so JSP can display again
        req.setAttribute("fname", fname);
        req.setAttribute("lname", lname);
        req.setAttribute("phone", phone);
        req.setAttribute("mail", mail);

        // PIN MATCH VALIDATION
        if (!pin.equals(confirmPin)) {
            req.setAttribute("error", "PIN and Confirm PIN do not match!");
            req.getRequestDispatcher("SignUp.jsp").forward(req, resp);
            return;
        }

        CustomerDAO cdao = new CustomerDAOImp();

        // EMAIL EXISTS?
        Customer emailCheck = cdao.getCustomer(mail);
        if (emailCheck != null) {
            req.setAttribute("error", "Email already registered!");
            req.getRequestDispatcher("SignUp.jsp").forward(req, resp);
            return;
        }

        // PHONE EXISTS?
        for (Customer cus : cdao.getCustomer()) {
            if (String.valueOf(cus.getPhone()).equals(phone)) {
                req.setAttribute("error", "Phone number already exists!");
                req.getRequestDispatcher("SignUp.jsp").forward(req, resp);
                return;
            }
        }

        // CREATE NEW CUSTOMER
        Customer c = new Customer();
        c.setFirst_name(fname);
        c.setLast_name(lname);
        c.setPhone(Long.parseLong(phone));
        c.setMail(mail);
        c.setPassword(Integer.parseInt(pin));
        c.setStatus("Pending");


        boolean inserted = cdao.insertCustomer(c);

        if (inserted) {
            req.setAttribute("success", "Account created successfully! Please login.");
            req.getRequestDispatcher("SignUp.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Something went wrong. Try again!");
            req.getRequestDispatcher("SignUp.jsp").forward(req, resp);
        }
    }
}
