package in.ps.bankapp.dao;

import java.util.ArrayList;

import in.ps.bankapp.dto.Transaction;

public interface TransactionDAO {

	public boolean insertTransaction(Transaction t);
	//insert into trancation values (0,?,?,?,?,?,?,sysdate());

	public boolean updateTransaction(Transaction t);
	//update transaction set transaction_id=?, sender_acc=?,reciver_acc=?,amount=?;

	public boolean deleteTransaction(int id);
	//delete from transaction where id=?;

	public Transaction getTransaction(Long id);
	//select * from transaction where id=?;

	public ArrayList<Transaction> getTransactionByCustomerAccno(long acc_no);
	//select * from transaction where  sender_acc=?;

	public ArrayList<Transaction> getTransaction();
	//select * from transaction;

	public int getTodayTransactionCount();

	public ArrayList<Transaction> getLatestTransactions();

	public ArrayList<Transaction> getTodayTransactions();
	
	public ArrayList<Transaction> getLastFiveTransactions(int cid);
	
	public ArrayList<Transaction> getTransactionsByCustomerId(int cid);

}
