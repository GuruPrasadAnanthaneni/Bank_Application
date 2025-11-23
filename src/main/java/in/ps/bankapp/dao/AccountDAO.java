package in.ps.bankapp.dao;

import java.util.ArrayList;

import in.ps.bankapp.dto.Account;

public interface AccountDAO {

	public boolean insertAccount(Account a);
	//insert into account values(0,?,?,?,?,sysdate());

	public boolean updateAccount(Account a);
	//update account set acc_type=?,balance=? whre acc_id=?;

	public boolean deleteAccount(int acc_id);
	//delete from account where acc_id=?;

	public Account getAccount(int acc_id);
	//select*from account where acc_id=?;

	public ArrayList<Account> getAccountByCustomerId(int cid);
	//select * from account where cid=?;

	public ArrayList<Account> getAccount();
	//select * from account;

	public Account getAccount(Long acc_no);
	//select*from account where acc_no=?;

	public ArrayList<Account> getPendingAccounts();

	public ArrayList<Account> getBlockedAccounts();

	public int getPendingAccountsCount();

	public int getBlockedAccountsCount();

	public ArrayList<Account> getLatestAccounts();

	public ArrayList<Account> getLatestBlockedAccounts();
	
	public boolean approveAccount(int accId);
	
	public boolean rejectAccount(int accId);


}
