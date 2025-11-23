package in.ps.bankapp.test;

import java.util.Scanner;

//import in.ps.bankapp.dao.AccountDAO;
//import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;

public class Login {

	public static void login() {

		Scanner sc = new Scanner (System.in);
		System.out.println("<-- LOGIN PAGE-->");
		System.out.println("Enter the Mail ID:");
		String mail = sc.next();
		System.out.println("Enter the PIN:");
		int pin = sc.nextInt();
		//JDBC
		CustomerDAO cdao = new CustomerDAOImp();
		//AccountDAO adao = new AccountDAOImp();

		Customer c = cdao.getCustomer(mail, pin);
//		System.out.println(c.toString());

		// if the user provides the exact mail and pin, his account will be
		//fetched and stored inside the customer object.
		if(c!=null) { //login success
			System.out.println("Login Successful");
			if(c.getCid()==1) {//1 means we treat it as admin account
				System.out.println("Welcome admin!");
				Admin.admin(c);
			}
			else {
				System.out.println("Welcome "+c.getFirst_name());
				App.options(c);
			}
		}
		else {
			System.out.println("Failed to login!");
		}
	}

}
