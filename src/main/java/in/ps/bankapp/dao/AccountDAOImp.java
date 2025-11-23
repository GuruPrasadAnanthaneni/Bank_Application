package in.ps.bankapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import in.ps.bankapp.Connection.Connect;
import in.ps.bankapp.dto.Account;


public class AccountDAOImp implements AccountDAO{

	private Connection con;

	public AccountDAOImp() {
		this.con = Connect.getCon();
	}

	@Override
	public boolean insertAccount(Account a) {
		String query = "insert into accounts values(0,?,?,?,?,sysdate(),?)";
		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setLong(1, a.getAccount_number());
			ps.setInt(2, a.getCustomer_id());
			ps.setString(3, a.getAccount_type());
			ps.setDouble(4, a.getBalance());
			ps.setString(5, a.getStatus());
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
	public boolean updateAccount(Account a) {
		String query = "update accounts set ACC_NO=?,CID=?,ACC_TYPE=?,BALANCE=?,status=? where ACC_ID=?";
		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setLong(1, a.getAccount_number());
			ps.setInt(2, a.getCustomer_id());
			ps.setString(3, a.getAccount_type());
			ps.setDouble(4, a.getBalance());
			ps.setString(5, a.getStatus());
			ps.setInt(6, a.getAccount_id());

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
	public boolean deleteAccount(int acc_id) {

		String query = "delete from accounts where acc_id=?";
		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, acc_id);

			i = ps.executeUpdate();
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
	public Account getAccount(int acc_id) {
		String query = "select * from accounts where acc_id=?";
		Account a = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, acc_id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				a = new Account();
				a.setAccount_id(rs.getInt("ACC_ID"));
				a.setAccount_number(rs.getLong("ACC_NO"));
				a.setCustomer_id(rs.getInt("CID"));
				a.setAccount_type(rs.getString("ACC_TYPE"));
				a.setBalance(rs.getDouble("BALANCE"));
				a.setDate(rs.getString("DATE"));
				a.setStatus(rs.getString("status"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return a;
	}

	@Override
	public ArrayList<Account> getAccountByCustomerId(int cid) {
		String query = "select * from accounts where cid=?";
		ArrayList<Account> list = new ArrayList<>();
		Account a = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, cid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				a = new Account();
				a.setAccount_id(rs.getInt("ACC_ID"));
				a.setAccount_number(rs.getLong("ACC_NO"));
				a.setCustomer_id(rs.getInt("CID"));
				a.setAccount_type(rs.getString("ACC_TYPE"));
				a.setBalance(rs.getDouble("BALANCE"));
				a.setDate(rs.getString("DATE"));
				a.setStatus(rs.getString("status"));
				list.add(a);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public ArrayList<Account> getAccount() {
		String query = "select * from accounts where cid!=1";
		ArrayList<Account> list = new ArrayList<>();
		Account a = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				a = new Account();
				a.setAccount_id(rs.getInt("ACC_ID"));
				a.setAccount_number(rs.getLong("ACC_NO"));
				a.setCustomer_id(rs.getInt("CID"));
				a.setAccount_type(rs.getString("ACC_TYPE"));
				a.setBalance(rs.getDouble("BALANCE"));
				a.setDate(rs.getString("DATE"));
				a.setStatus(rs.getString("status"));
				list.add(a);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public Account getAccount(Long acc_no) {

		String query = "select * from accounts where acc_no=? and status='Active'";
		Account a = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setLong(1, acc_no);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				a = new Account();
				a.setAccount_id(rs.getInt("ACC_ID"));
				a.setAccount_number(rs.getLong("ACC_NO"));
				a.setCustomer_id(rs.getInt("CID"));
				a.setAccount_type(rs.getString("ACC_TYPE"));
				a.setBalance(rs.getDouble("BALANCE"));
				a.setDate(rs.getString("DATE"));
				a.setStatus(rs.getString("status"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return a;
	}

	@Override
	public ArrayList<Account> getPendingAccounts() {
	    ArrayList<Account> list = new ArrayList<>();

	    try {
	        String sql = "SELECT * FROM accounts WHERE status = 'Pending'";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Account a = new Account();
	            a.setAccount_id(rs.getInt("ACC_ID"));
				a.setAccount_number(rs.getLong("ACC_NO"));
				a.setCustomer_id(rs.getInt("CID"));
				a.setAccount_type(rs.getString("ACC_TYPE"));
				a.setBalance(rs.getDouble("BALANCE"));
				a.setDate(rs.getString("DATE"));
				a.setStatus(rs.getString("status"));

	            list.add(a);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	@Override
	public ArrayList<Account> getBlockedAccounts() {

	    ArrayList<Account> list = new ArrayList<>();

	    try {
	        String sql = "SELECT * FROM accounts WHERE status = 'Inactive'";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Account a = new Account();
	            a.setAccount_id(rs.getInt("ACC_ID"));
	            a.setAccount_number(rs.getLong("ACC_NO"));
	            a.setCustomer_id(rs.getInt("CID"));
	            a.setAccount_type(rs.getString("ACC_TYPE"));
	            a.setBalance(rs.getDouble("BALANCE"));
	            a.setDate(rs.getString("DATE"));
	            a.setStatus(rs.getString("status"));

	            list.add(a);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	@Override
	public int getPendingAccountsCount() {
	    int count = 0;
	    try {
	        String sql = "SELECT COUNT(*) FROM accounts WHERE status='Pending'";
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
	public int getBlockedAccountsCount() {
	    int count = 0;
	    try {
	        String sql = "SELECT COUNT(*) FROM accounts WHERE status='Blocked'";
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
	public ArrayList<Account> getLatestAccounts() {
	    ArrayList<Account> list = new ArrayList<>();
	    try {
	        String sql = "SELECT * FROM accounts ORDER BY ACC_ID DESC LIMIT 5";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Account a = new Account();
	            a.setAccount_id(rs.getInt("ACC_ID"));
	            a.setAccount_number(rs.getLong("ACC_NO"));
	            a.setCustomer_id(rs.getInt("CID"));
	            a.setAccount_type(rs.getString("ACC_TYPE"));
	            a.setBalance(rs.getDouble("BALANCE"));
	            a.setDate(rs.getString("DATE"));
	            a.setStatus(rs.getString("status"));
	            list.add(a);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	@Override
	public ArrayList<Account> getLatestBlockedAccounts() {
	    ArrayList<Account> list = new ArrayList<>();
	    try {
	        String sql = "SELECT * FROM accounts WHERE status='Blocked' ORDER BY ACC_ID DESC LIMIT 5";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Account a = new Account();
	            a.setAccount_id(rs.getInt("ACC_ID"));
	            a.setAccount_number(rs.getLong("ACC_NO"));
	            a.setCustomer_id(rs.getInt("CID"));
	            a.setAccount_type(rs.getString("ACC_TYPE"));
	            a.setBalance(rs.getDouble("BALANCE"));
	            a.setDate(rs.getString("DATE"));
	            a.setStatus(rs.getString("status"));
	            list.add(a);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	@Override
	public boolean approveAccount(int accId) {
	    String sql = "UPDATE accounts SET status = 'Active' WHERE ACC_ID = ?";
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, accId);
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}


	@Override
	public boolean rejectAccount(int accId) {
	    String sql = "DELETE FROM accounts WHERE ACC_ID = ?";
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, accId);
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}


}
