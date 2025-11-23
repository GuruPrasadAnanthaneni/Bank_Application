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

public class App {
	static CustomerDAO cdao=new CustomerDAOImp();
	static AccountDAO adao=new AccountDAOImp();
	static TransactionDAO tdao=new TransactionDAOImp();
	static Scanner sc=new Scanner(System.in);

	public static void options(Customer c) {

		int choice=0;
		do {
			System.out.println("1. View Accounts");
			System.out.println("2. Check Balance");
			System.out.println("3. Deposit");
			System.out.println("4. Transfer Amount");
			System.out.println("5. View Passbook");
			//System.out.println("6. Add Fund for FD");
			System.out.println("6. Exit");
			choice=sc.nextInt();

			switch(choice) {
				case 1 : ArrayList<Account> list = adao.getAccountByCustomerId(c.getCid());
					for(Account a : list) {
						System.out.println("Account number : "+a.getAccount_number());
						System.out.println("Account Type : "+a.getAccount_type());
						System.out.println("Balance : "+a.getBalance());
						System.out.println("Status : "+a.getStatus());
						System.out.println("- - - - - - - - - - - - - -");
					}
				break;

				case 2 : ArrayList<Account> bal_list = adao.getAccountByCustomerId(c.getCid());
				for(Account a : bal_list) {
					System.out.println("Account number : "+a.getAccount_number());
					System.out.println("Account Type : "+a.getAccount_type());
					System.out.println("Balance : "+a.getBalance());
					System.out.println("Status : "+a.getStatus());
					System.out.println("- - - - - - - - - - - - - -");
				}
					System.out.print("Enter account number: ");
				    long accNo = sc.nextLong();
				    Account acc = adao.getAccount(accNo);
				    if(acc != null) {
						System.out.println("Balance: " + acc.getBalance());
					} else {
						System.out.println("Account not found!");
					}
				break;


				case 3 : ArrayList<Account> acc_list = adao.getAccountByCustomerId(c.getCid());
					for(Account a : acc_list) {
						System.out.println("Account number : "+a.getAccount_number());
						System.out.println("Account Type : "+a.getAccount_type());
						System.out.println("Balance : "+a.getBalance());
						System.out.println("Status : "+a.getStatus());
						System.out.println("- - - - - - - - - - - - - -");
					}
					System.out.print("Enter the Account number: ");
				    long acc_no = sc.nextLong();
				    Account a = adao.getAccount(acc_no);
				    if(a!=null) {
				    	System.out.println("Enter the amount to deposited: ");
				    	double amount = sc.nextDouble();
				    	a.setBalance(a.getBalance()+amount);
				    	boolean res = adao.updateAccount(a);
				    	if(res) {
				    		Transaction t = new Transaction();
				    		t.setTransaction_id(TransactionID.generateTransactionID());
				    		t.setSender_acc(a.getAccount_number());
				    		t.setReciever_acc(a.getAccount_number());
				    		t.setAmount(amount);
				    		t.setTran_type("SELF");
				    		t.setBalance(a.getBalance());
				    		boolean status = tdao.insertTransaction(t);
				    		if(status) {
				    			System.out.println("Amount of Rs."+amount+"/- has been deposited to "+a.getAccount_number());
				    		}
				    		else {
				    			System.out.println("Failed to deposit the amount");
				    		}
				    	}
				    	else {
				    		System.out.println("Account ststus is pending! Wait for admin to approve!");
				    	}
				    }
				break;

				case 4 : ArrayList<Account> transfer_list = adao.getAccountByCustomerId(c.getCid());
				for(Account ac : transfer_list) {
					System.out.println("Account number : "+ac.getAccount_number());
					System.out.println("Account Type : "+ac.getAccount_type());
					System.out.println("Balance : "+ac.getBalance());
					System.out.println("Status : "+ac.getStatus());
					System.out.println("- - - - - - - - - - - - - -");
				}
				System.out.print("Enter the Account number: ");
			    long sender_acc_no = sc.nextLong();
			    Account sender_acc = adao.getAccount(sender_acc_no);
			    System.out.println("Enter the reciver account number:");
			    long receiver_acc_no = sc.nextLong();
			    Account rec_acc = adao.getAccount(receiver_acc_no);
			    System.out.println("Enter the amount to be transfered:");
			    double transfer_amount = sc.nextDouble();
			    System.out.println("Enter the pin:");
			    int pin = sc.nextInt();

			    if(pin==c.getPassword() && sender_acc_no!=receiver_acc_no && sender_acc.getBalance() > transfer_amount && transfer_amount > 0) {
			    	sender_acc.setBalance(sender_acc.getBalance()-transfer_amount);
			    	rec_acc.setBalance(rec_acc.getBalance()+transfer_amount);
			    	boolean status1 = adao.updateAccount(sender_acc);
			    	boolean status2 = adao.updateAccount(rec_acc);
			    	if(status1 && status2) {
			    		long transactionID = TransactionID.generateTransactionID();
			    		Transaction t1 = new Transaction();
			    		Transaction t2 = new Transaction();
			    		t1.setTransaction_id(transactionID);
			    		t1.setSender_acc(sender_acc_no);
			    		t1.setReciever_acc(receiver_acc_no);
			    		t1.setAmount(transfer_amount);
			    		t1.setTran_type("DEBIT");
			    		t1.setBalance(sender_acc.getBalance());

			    		t2.setTransaction_id(transactionID);
			    		t2.setSender_acc(receiver_acc_no);
			    		t2.setReciever_acc(sender_acc_no);
			    		t2.setAmount(transfer_amount);
			    		t2.setTran_type("CREDIT");
			    		t2.setBalance(sender_acc.getBalance());

			    		boolean tr_status1 = tdao.insertTransaction(t1);
			    		boolean tr_status2 = tdao.insertTransaction(t2);

			    		if(tr_status1 && tr_status2) {
			    			System.out.println("Amount of Rs."+transfer_amount+"/- has been sent to "+receiver_acc_no);
			    		}
			    		else {
			    			System.out.println("Transaction Failed");
			    		}
			    	}
			    	else {
			    		System.out.println("Transaction Failed");
			    	}
			    }
			    else {
			    	System.out.println("Transaction Failed");
			    }
				break;

//				case 6 :
//				break;

				case 5 : ArrayList<Account> accounts_list = adao.getAccountByCustomerId(c.getCid());
				for(Account info : accounts_list) {
					System.out.println("Account number : "+info.getAccount_number());
					System.out.println("Account Type : "+info.getAccount_type());
					System.out.println("Balance : "+info.getBalance());
					System.out.println("Status : "+info.getStatus());
					System.out.println("- - - - - - - - - - - - - -");
				}
				System.out.print("Enter the Account number: ");
			    long info_acc = sc.nextLong();
			    ArrayList<Transaction> passbook = tdao.getTransactionByCustomerAccno(info_acc);
			    for(Transaction t : passbook) {
			    	System.out.println("Transaction ID : "+t.getTransaction_id());
			    	System.out.println("Date and Time : "+t.getDate());
			    	System.out.println("Amount : "+t.getAmount());
			    	if(t.getTran_type().equals("CREDIT")) {
			    		System.out.println("From : "+t.getReciever_acc());
			    		System.out.println("To : "+t.getSender_acc());
			    	}
			    	else {
			    		System.out.println("From : "+t.getSender_acc());
			    		System.out.println("To : "+t.getReciever_acc());
			    	}
			    	System.out.println("Transaction Type : "+t.getTran_type());
			    	System.out.println("Current Balance : "+t.getBalance());
			    	System.out.println("= = = = = = = = = = = = = = = = = = =");
			    }
				break;

				case 6 :
					System.out.println("Going back to main menu");
				break;

				default :
					System.out.println("Invalid choice. Please enter the right one");

			}

		}while(choice!=6);
	}
}
