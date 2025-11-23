package in.ps.bankapp.test;

import java.util.Scanner;

import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;
public class Password {

	public static void forgot() {
		Scanner sc = new Scanner(System.in);
		System.out.println("Enter the Mail ID:");
		String mail= sc.next();
		CustomerDAO cdao = new CustomerDAOImp();
		Customer c = cdao.getCustomer(mail);
		if(c!=null) {
			System.out.println("Set a new Pin:");
			int pin = sc.nextInt();
			System.out.println("Confirm the pin:");
			int confirm = sc.nextInt();
			if(pin == confirm) {
				c.setPassword(pin);
				boolean res = cdao.updateCustomer(c);
				if(res) {
					System.out.println("Password updated");
				}
				else {
					System.out.println("Failed to update password");
				}
			}
			else {
				System.out.println("Pin mismatch");
			}
		}
		else {
			System.out.println("Customer doesnot exists!");
		}
	}
}
