package in.ps.bankapp.dto;

public class Transaction {

	private int id;
	private long transaction_id;
	private long sender_acc;
	private long reciever_acc;
	private double amount;
	private String tran_type;
	private double balance;
	private String date;
	private String status;

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public long getTransaction_id() {
		return transaction_id;
	}
	public void setTransaction_id(long transaction_id) {
		this.transaction_id = transaction_id;
	}
	public long getSender_acc() {
		return sender_acc;
	}
	public void setSender_acc(long sender_acc) {
		this.sender_acc = sender_acc;
	}
	public long getReciever_acc() {
		return reciever_acc;
	}
	public void setReciever_acc(long reciever_acc) {
		this.reciever_acc = reciever_acc;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public String getTran_type() {
		return tran_type;
	}
	public void setTran_type(String tran_type) {
		this.tran_type = tran_type;
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
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatus() {
		return status;
	}

	public Transaction() {
		// TODO Auto-generated constructor stub
	}

	public Transaction(int id, long transaction_id, long sender_acc, long reciever_acc, double amount, String tran_type,
			double balance, String date) {

		this.id = id;
		this.transaction_id = transaction_id;
		this.sender_acc = sender_acc;
		this.reciever_acc = reciever_acc;
		this.amount = amount;
		this.tran_type = tran_type;
		this.balance = balance;
		this.date = date;
	}
	@Override
	public String toString() {
		return "Transaction [id=" + id + ", transaction_id=" + transaction_id + ", sender_acc=" + sender_acc
				+ ", reciever_acc=" + reciever_acc + ", amount=" + amount + ", tran_type=" + tran_type + ", balance="
				+ balance + ", date=" + date + "]";
	}





}
