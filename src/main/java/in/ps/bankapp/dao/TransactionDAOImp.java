package in.ps.bankapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import in.ps.bankapp.Connection.Connect;
//import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Transaction;

public class TransactionDAOImp implements TransactionDAO{

	private Connection con;

	public TransactionDAOImp() {
		this.con = Connect.getCon();
	}

	@Override
	public boolean insertTransaction(Transaction t) {

		String query = "insert into transactions values(0,?,?,?,?,?,?,sysdate())";

		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setLong(1, t.getTransaction_id());
			ps.setLong(2, t.getSender_acc());
			ps.setLong(3, t.getReciever_acc());
			ps.setDouble(4, t.getAmount());
			ps.setString(5, t.getTran_type());
			ps.setDouble(6, t.getBalance());


			i = ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(i>0) {
			return true;
		}else {
			return false;
		}
	}

	@Override
	public boolean updateTransaction(Transaction t) {

		String query = "update transactions set TRANSACTION_ID=?,SENDER_ACC=?,RECIEVER_ACC=?,AMOUNT=?,TRAN_TYPE=?,BALANCE=? where ID=?";
		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setLong(1, t.getTransaction_id());
			ps.setLong(2, t.getSender_acc());
			ps.setLong(3, t.getReciever_acc());
			ps.setDouble(4, t.getAmount());
			ps.setString(5, t.getTran_type());
			ps.setDouble(6, t.getBalance());
			ps.setInt(7, t.getId());

			i = ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(i>0) {
			return true;
		}else {
			return false;
		}


	}

	@Override
	public boolean deleteTransaction(int id) {

		String query = "delete from transactions id=?";
		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(i>0) {
			return true;
		}
		else {
			return false;
		}
	}

	@Override
	public Transaction getTransaction(Long id) {
		String query = "select * from transactions where id=?";
		Transaction t = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setLong(1, id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				t = new Transaction();
				t.setId(rs.getInt("ID"));
				t.setTransaction_id(rs.getLong("TRANSACTION_ID"));
				t.setSender_acc(rs.getLong("SENDER_ACC"));
				t.setReciever_acc(rs.getLong("RECIEVER_ACC"));
				t.setAmount(rs.getDouble("AMOUNT"));
				t.setTran_type(rs.getString("TRAN_TYPE"));
				t.setBalance(rs.getDouble("BALANCE"));
				t.setDate(rs.getString("DATE"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return t;
	}

	@Override
	public ArrayList<Transaction> getTransactionByCustomerAccno(long acc_no) {
		String query = "select * from transactions where sender_acc=?";
		ArrayList<Transaction> list = new ArrayList<>();
		Transaction t = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setLong(1, acc_no);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				t = new Transaction();
				t.setId(rs.getInt("ID"));
				t.setTransaction_id(rs.getLong("TRANSACTION_ID"));
				t.setSender_acc(rs.getLong("SENDER_ACC"));
				t.setReciever_acc(rs.getLong("RECIEVER_ACC"));
				t.setAmount(rs.getDouble("AMOUNT"));
				t.setTran_type(rs.getString("TRAN_TYPE"));
				t.setBalance(rs.getDouble("BALANCE"));
				t.setDate(rs.getString("DATE"));
				list.add(t);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public ArrayList<Transaction> getTransaction() {
		String query = "select * from transactions";
		ArrayList<Transaction> list = new ArrayList<>();
		Transaction t = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				t = new Transaction();
				t.setId(rs.getInt("ID"));
				t.setTransaction_id(rs.getLong("TRANSACTION_ID"));
				t.setSender_acc(rs.getLong("SENDER_ACC"));
				t.setReciever_acc(rs.getLong("RECIEVER_ACC"));
				t.setAmount(rs.getDouble("AMOUNT"));
				t.setTran_type(rs.getString("TRAN_TYPE"));
				t.setBalance(rs.getDouble("BALANCE"));
				t.setDate(rs.getString("DATE"));
				list.add(t);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public int getTodayTransactionCount() {
	    int count = 0;
	    try {
	        String sql = "SELECT COUNT(*) FROM transactions WHERE DATE(date)=CURDATE()";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
				count = rs.getInt(1);
			}
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return count;
	}

	@Override
	public ArrayList<Transaction> getLatestTransactions() {

	    ArrayList<Transaction> list = new ArrayList<>();

	    String sql = "SELECT * FROM transactions ORDER BY ID DESC LIMIT 5";

	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Transaction t = new Transaction();

	            t.setId(rs.getInt("ID"));
				t.setTransaction_id(rs.getLong("TRANSACTION_ID"));
				t.setSender_acc(rs.getLong("SENDER_ACC"));
				t.setReciever_acc(rs.getLong("RECIEVER_ACC"));
				t.setAmount(rs.getDouble("AMOUNT"));
				t.setTran_type(rs.getString("TRAN_TYPE"));
				t.setBalance(rs.getDouble("BALANCE"));
				t.setDate(rs.getString("DATE"));
	            list.add(t);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return list;
	}


	@Override
	public ArrayList<Transaction> getTodayTransactions() {

	    ArrayList<Transaction> list = new ArrayList<>();

	    String sql = "SELECT * FROM transactions "
	               + "WHERE DATE(date) = CURDATE() "
	               + "ORDER BY date DESC";

	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Transaction t = new Transaction();

	            t.setId(rs.getInt("ID"));
				t.setTransaction_id(rs.getLong("TRANSACTION_ID"));
				t.setSender_acc(rs.getLong("SENDER_ACC"));
				t.setReciever_acc(rs.getLong("RECIEVER_ACC"));
				t.setAmount(rs.getDouble("AMOUNT"));
				t.setTran_type(rs.getString("TRAN_TYPE"));
				t.setBalance(rs.getDouble("BALANCE"));
				t.setDate(rs.getString("DATE"));

	            list.add(t);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	public ArrayList<Transaction> getLastFiveTransactions(int cid) {
	    ArrayList<Transaction> list = new ArrayList<>();

	    try {
	        String sql =
	            "SELECT t.* FROM transactions t " +
	            "JOIN accounts a ON t.SENDER_ACC = a.acc_no OR t.RECIEVER_ACC = a.acc_no " +
	            "WHERE a.cid = ? " +
	            "ORDER BY t.ID DESC LIMIT 5";

	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, cid);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Transaction t = new Transaction();

	            t.setId(rs.getInt("ID"));
	            t.setTransaction_id(rs.getLong("TRANSACTION_ID"));
	            t.setSender_acc(rs.getLong("SENDER_ACC"));
	            t.setReciever_acc(rs.getLong("RECIEVER_ACC"));
	            t.setAmount(rs.getDouble("AMOUNT"));
	            t.setTran_type(rs.getString("TRAN_TYPE"));
	            t.setBalance(rs.getDouble("BALANCE"));
	            t.setDate(rs.getString("DATE"));

	            list.add(t);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	@Override
	public ArrayList<Transaction> getTransactionsByCustomerId(int cid) {
	    ArrayList<Transaction> list = new ArrayList<>();

	    String sql = "SELECT t.* FROM transactions t "
	               + "JOIN accounts a ON t.SENDER_ACC = a.acc_no OR t.RECIEVER_ACC = a.acc_no "
	               + "WHERE a.cid = ? "
	               + "ORDER BY t.ID DESC";

	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, cid);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Transaction t = new Transaction();
	            t.setId(rs.getInt("ID"));
	            t.setTransaction_id(rs.getLong("TRANSACTION_ID"));
	            t.setSender_acc(rs.getLong("SENDER_ACC"));
	            t.setReciever_acc(rs.getLong("RECIEVER_ACC"));
	            t.setAmount(rs.getDouble("AMOUNT"));
	            t.setTran_type(rs.getString("TRAN_TYPE"));
	            t.setBalance(rs.getDouble("BALANCE"));
	            t.setDate(rs.getString("DATE"));
	            list.add(t);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}


}
