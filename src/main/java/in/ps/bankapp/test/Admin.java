package in.ps.bankapp.test;

import java.util.ArrayList;
import java.util.Scanner;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dao.TransactionDAO;
import in.ps.bankapp.dao.TransactionDAOImp;
import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Customer;
import in.ps.bankapp.dto.Transaction;

public class Admin {
	 static AccountDAO adao=new AccountDAOImp();
	 static CustomerDAO cdao=new CustomerDAOImp();
	 static TransactionDAO tdao=new TransactionDAOImp();
	 static Scanner sc=new Scanner(System.in);
	public static void admin(Customer c) {

		int choice=0;
		do {
			System.out.println("1. Approve Customer");
			System.out.println("2. Approve Account");
			System.out.println("3. View all Customers ");
			System.out.println("4. View all Accounts");
			System.out.println("5. View all Transactions");
			System.out.println("6. Block User/Delete Customer");
			System.out.println("7. Block Account");
			System.out.println("8. Delete Account");
			System.out.println("9. My Account");
			System.out.println("10. Back to main menu");

			choice=sc.nextInt();
			switch(choice) {

			case 1: Customer cu=Admin.customerInfo();
				System.out.println("1. Approve the account");
			    System.out.println("2. Reject the Account");
			    int i=0;
			    i=sc.nextInt();
			    String status=Admin.statusUpdate(i);
			    cu.setStatus(status);
			    boolean res=cdao.updateCustomer(cu);
			    	if(res) {
			        	System.out.println("Status Update successful");
			        }
			        else {
			        	System.out.println("Failed to update status");
			        }
			    break;

			case 2 : Account a = Admin.accountInfo();
				System.out.println("1. Approve the account");
				System.out.println("2. Reject the account");
				int j = 0;
				j = sc.nextInt();
				String stat = Admin.statusUpdate(j);
				a.setStatus(stat);
				boolean acc_res = adao.updateAccount(a);
					if(acc_res) {
						System.out.println("Account update successful");
					}
					else {
						System.out.println("Failed to update account");
					}
				break;

			case 3: Customer ct = Admin.customerInfo();
				if(ct!=null) {
					System.out.println("Customer ID : "+ct.getCid());
					System.out.println("Customer Fname : "+ct.getFirst_name());
				}
				break;

			case 4 : Account acc = Admin.accountInfo();
				if(acc!=null) {
					System.out.println("Account ID : " + acc.getAccount_id());
					System.out.println("Account Number : " + acc.getAccount_number());
					System.out.println("Account Holder ID : " + acc.getCustomer_id());
					System.out.println("Balance : " + acc.getBalance());
					System.out.println("- - - - - - - - - - - - - - -");
				}
				break;

			case 5 : Transaction trn = Admin.transactionInfo();
				if(trn!=null) {
					System.out.println("Transactions ID:"+trn.getTransaction_id());
					System.out.println("Transactions Type:"+trn.getTran_type());
					System.out.println("Sender acc : "+trn.getSender_acc());
//					System.out.println("Status : "+trn.getStatus());
					System.out.println("Balance : " + trn.getBalance());
					System.out.println("- - - - - - - - - - - - - - -");
				}
				break;

			case 6 : Customer inactive = Admin.customerInfo();
				if(inactive != null) {
					inactive.setStatus("Inactive");
					boolean inactive_status = cdao.updateCustomer(inactive);
					if(inactive_status) {
						System.out.println("Customer account blocked");
					}
					else {
						System.out.println("Failed to block");
					}
				}
				else {
					System.out.println("No customer found!");
				}
				break;

			case 7 : Account acc_inactive = Admin.accountInfo();

				if(acc_inactive != null) {
					acc_inactive.setStatus("Inactive");
					boolean inactive_status = adao.updateAccount(acc_inactive);
					if(inactive_status) {
						System.out.println("Account blocked");
					}
					else {
						System.out.println("Failed to block");
					}
				}
				else {
					System.out.println("No account found!");
				}

				break;

			case 8 : Account acc_delete = Admin.accountInfo();
				if(acc_delete != null) {
					//acc_delete.setStatus("Deleted");
					boolean del_status = adao.deleteAccount(acc_delete.getAccount_id());
					if(del_status) {
						System.out.println("Account deleted");
					}
					else {
						System.out.println("Failed to delete");
					}
				}
				else {
					System.out.println("No account found!");
				}

				break;

			case 9 : App.options(c);

				break;

			case 10 :
				System.out.println("Going back to main menu...!");
				break;

			default :
				System.out.println("Invalid response! Choose it again");
			}
		}while(choice!=10);
	}


	public static Customer customerInfo() {
		ArrayList<Customer> customers=cdao.getCustomer();
		for(Customer c:customers) {
			System.out.println("Customer ID:"+c.getCid());
			System.out.println("Customer First Name:"+c.getFirst_name());
			System.out.println("Status : "+c.getStatus());
			System.out.println("- - - - - - - - - - - - - - -");
		}

		System.out.println("Enter the ID:");
		int cid=sc.nextInt();
		Customer c=cdao.getCustomer(cid);
		return c;
	}

	public static Account accountInfo() {
		ArrayList<Account> accounts=adao.getAccount();
		for(Account a:accounts) {
			System.out.println("Account ID:"+a.getAccount_id());
			System.out.println("Account Number:"+a.getAccount_number());
			System.out.println("Customer ID : "+a.getCustomer_id());
			System.out.println("Status : "+a.getStatus());
		}

		System.out.println("Enter the Account ID:");
		int acc_id=sc.nextInt();
		Account a=adao.getAccount(acc_id);
		return a;
	}

	public static Transaction transactionInfo() {
		ArrayList<Transaction> transactions=tdao.getTransaction();
		for(Transaction t:transactions) {
			System.out.println("Transactions ID:"+t.getTransaction_id());
			System.out.println("Transactions Type:"+t.getTran_type());
			System.out.println("Sender acc : "+t.getSender_acc());
			System.out.println("Balance : " + t.getBalance());
			//System.out.println("Status : "+t.getStatus());
		}

		System.out.println("Enter the Transaction ID:");
		Long id=sc.nextLong();
		Transaction t=tdao.getTransaction(id);
		return t;
	}

	public static String statusUpdate(int choice) {
		String status=null;
		if(choice==1) {
			status="Active";
			System.out.println("Status approved");
		}
		else if(choice==2) {
			status="Inactive";
			System.out.println("Status rejected");
		}
		else {
			System.out.println("Invalid choice!");
			status="Pending";
		}
		return status;
	}
}
