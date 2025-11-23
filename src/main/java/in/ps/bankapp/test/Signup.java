package in.ps.bankapp.test;

import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Customer;
public class Signup {
	public static void signup() {
		Scanner sc=new Scanner(System.in);
		CustomerDAO cdao=new CustomerDAOImp();
		AccountDAO adao=new AccountDAOImp();

		//Account Type, the customer need to create
		System.out.println("Enter the type of the account, you would like to create");
		System.out.println("1. SAVINGS");
		System.out.println("2. CURRENT");
		System.out.println("3. FD");
		System.out.println("4. LOAN");
		int choice=0;
		String acc_type=null;
		choice=sc.nextInt();

		while(acc_type==null) {
			switch(choice) {
			case 1: acc_type="SAVINGS";
			break;
			case 2: acc_type="CURRENT";
			break;
			case 3: acc_type="FD";
			break;
			case 4: acc_type="LOAN";
			break;
			default: System.out.println("Invalid choice!");
			break;
			}
		}
		System.out.println(acc_type);

		//Customer info logic

		Customer c=new Customer();
		System.out.println("Enter your First name:");
		c.setFirst_name(sc.next());
		System.out.println("Enter your Last name:");
		c.setLast_name(sc.next());
		System.out.println("Enter your Phone number:");
		c.setPhone(sc.nextLong());
		System.out.println("Enter your Mail ID:");
		c.setMail(sc.next());

		//Checking whether this customer is an existing user or not
		Customer existing=Signup.checkExistingCustomer(c.getMail());

		if(existing!=null) { //--> Already a user
			System.out.println("Your data already exists!");
			System.out.println("Please enter your PIN for further steps:");
			int existing_acc_pin=sc.nextInt();
			if(existing_acc_pin==existing.getPassword()) {
				ArrayList<Account> existing_accounts=adao.getAccountByCustomerId(existing.getCid());

				if(existing_accounts!=null&&!existing_accounts.isEmpty()) {

					boolean accAlreadyExists=false;
					for(Account acc:existing_accounts) {
						String existing_type=acc.getAccount_type();
						System.out.println(acc.getAccount_number());
						System.out.println(existing_type);
						System.out.println("------------");
						if(acc_type.equalsIgnoreCase(existing_type)) {
							accAlreadyExists=true;

							break;
						}
					}
						if(accAlreadyExists) {
							System.out.println("Failed to create account as "+acc_type+" Account is already avaliable");
						}
						else {
							Signup.createAccount(c.getMail(),acc_type);
						}

				}
				else {
					System.out.println("No accounts found!");
					Signup.createAccount(c.getMail(),acc_type);

				}
			}
			else {
				System.out.println("Pin mismatch!");
			}
		}
		else { //New User
			System.out.println("Set your 4 DIGIT PIN:");
			int first_pin=sc.nextInt();
			System.out.println("Confirm the PIN:");
			int sec_pin=sc.nextInt();

			if(first_pin==sec_pin) {
				c.setPassword(sec_pin);
				c.setStatus("Pending");
				boolean customer_res=cdao.insertCustomer(c);
				if(customer_res) {
					Signup.createAccount(c.getMail(),acc_type);
				}
				else {
					System.out.println("Failed to create an account");
				}
			}
			else {
				System.out.println("Pin mismatch");
			}
		}
	}

	//Validation for existing customer / To get Customer Info
	public static Customer checkExistingCustomer(String mail) {
		CustomerDAO cdao=new CustomerDAOImp();
		Customer c=cdao.getCustomer(mail);
		return c;
	}

	//Account creational Logic
	public static void createAccount(String mail,String acc_type) {

		Account a=new Account();
		AccountDAO adao=new AccountDAOImp();
		Random rd=new Random();
		long generated_no=rd.nextLong(100000);
		a.setAccount_number(1100110000+generated_no);
		a.setAccount_type(acc_type);
		a.setBalance(0);

		Customer data=Signup.checkExistingCustomer(mail);
		a.setCustomer_id(data.getCid());
		a.setStatus("Pending");
		boolean acc_res=adao.insertAccount(a);

		if(acc_res) {
			System.out.println("Account creation submitted, waiting for admin approval!");
		}
		else {
			System.out.println("Failed to create the account");
		}
	}
}
