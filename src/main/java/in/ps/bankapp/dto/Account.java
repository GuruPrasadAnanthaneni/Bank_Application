package in.ps.bankapp.dto;

public class Account {

	private int Account_id;
	private long Account_number;
	private int customer_id;
	private String Account_type;
	private double balance;
	private String date;
	private String Status;


	public int getAccount_id() {
		return Account_id;
	}
	public void setAccount_id(int account_id) {
		Account_id = account_id;
	}
	public long getAccount_number() {
		return Account_number;
	}
	public void setAccount_number(long account_number) {
		Account_number = account_number;
	}
	public int getCustomer_id() {
		return customer_id;
	}
	public void setCustomer_id(int customer_id) {
		this.customer_id = customer_id;
	}
	public String getAccount_type() {
		return Account_type;
	}
	public void setAccount_type(String account_type) {
		Account_type = account_type;
	}
	public double getBalance() {
		return balance;
	}
	public void setBalance(double balance) {
		this.balance = balance;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}

	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}

	public Account() {
		// TODO Auto-generated constructor stub
	}
	public Account(int account_id, long account_number, int customer_id, String account_type, double balance,
			String date) {

		Account_id = account_id;
		Account_number = account_number;
		this.customer_id = customer_id;
		Account_type = account_type;
		this.balance = balance;
		this.date = date;
	}
	@Override
	public String toString() {
		return "Account [Account_id=" + Account_id + ", Account_number=" + Account_number + ", customer_id="
				+ customer_id + ", Account_type=" + Account_type + ", balance=" + balance + ", date=" + date + "]";
	}





}
