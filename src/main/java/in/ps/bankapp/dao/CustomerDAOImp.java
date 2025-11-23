package in.ps.bankapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import in.ps.bankapp.Connection.Connect;
import in.ps.bankapp.dto.Customer;

public class CustomerDAOImp implements CustomerDAO{
	private Connection con;



	public CustomerDAOImp() {
		this.con = Connect.getCon();
	}

	@Override
	public boolean insertCustomer(Customer c) {
		String query = "insert into customers values(0,?,?,?,?,?,sysdate(),?)";
		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, c.getFirst_name());
			ps.setString(2, c.getLast_name());
			ps.setLong(3, c.getPhone());
			ps.setString(4, c.getMail());
			ps.setInt(5, c.getPassword());
			ps.setString(6, c.getStatus());

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
	public boolean updateCustomer(Customer c) {

		String query = "update customers set fname=?,lname=?,phone=?,mail=?,password=?,status=? where cid=?";
		int i=0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, c.getFirst_name());
			ps.setString(2, c.getLast_name());
			ps.setLong(3, c.getPhone());
			ps.setString(4, c.getMail());
			ps.setInt(5, c.getPassword());
			ps.setString(6, c.getStatus());
			ps.setInt(7, c.getCid());

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
	public boolean deleteCustomer(int cid) {

		String query = "DELETE FROM customers WHERE cid=?";
		int i = 0;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, cid);
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
	public Customer getCustomer(String mail, int Password) {
		String query = "select * from customers where mail=? and Password=?";
		Customer c = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, mail);
			ps.setInt(2, Password);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				c = new Customer();
				c.setCid(rs.getInt("cid"));
				c.setFirst_name(rs.getString("Fname"));
				c.setLast_name(rs.getString("Lname"));
				c.setPhone(rs.getLong("Phone"));
				c.setMail(rs.getString("mail"));
				c.setPassword(rs.getInt("password"));
				c.setDate(rs.getString("date"));
				c.setStatus(rs.getString("status"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return c;
	}

	@Override
	public ArrayList<Customer> getCustomer() {
		ArrayList<Customer> list = new ArrayList<>();
		String query = "select * from customers";
		Customer c = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				c = new Customer();
				c.setCid(rs.getInt("cid"));
				c.setFirst_name(rs.getString("Fname"));
				c.setLast_name(rs.getString("Lname"));
				c.setPhone(rs.getLong("Phone"));
				c.setMail(rs.getString("mail"));
				c.setPassword(rs.getInt("password"));
				c.setDate(rs.getString("date"));
				c.setStatus(rs.getString("status"));
				list.add(c);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public Customer getCustomer(String mail) {
		String query = "select * from customers where mail=?";
		Customer c = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, mail);

			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				c = new Customer();
				c.setCid(rs.getInt("cid"));
				c.setFirst_name(rs.getString("Fname"));
				c.setLast_name(rs.getString("Lname"));
				c.setPhone(rs.getLong("Phone"));
				c.setMail(rs.getString("mail"));
				c.setPassword(rs.getInt("password"));
				c.setDate(rs.getString("date"));
				c.setStatus(rs.getString("status"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return c;
	}

	@Override
	public Customer getCustomer(int cid) {
		String query = "select * from customers where cid=?";
		Customer c = null;
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, cid);

			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				c = new Customer();
				c.setCid(rs.getInt("cid"));
				c.setFirst_name(rs.getString("Fname"));
				c.setLast_name(rs.getString("Lname"));
				c.setPhone(rs.getLong("Phone"));
				c.setMail(rs.getString("mail"));
				c.setPassword(rs.getInt("password"));
				c.setDate(rs.getString("date"));
				c.setStatus(rs.getString("status"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return c;
	}

	@Override
	public ArrayList<Customer> getPendingCustomers() {
	    ArrayList<Customer> list = new ArrayList<>();

	    try {
	        String sql = "SELECT * FROM customers WHERE status = 'Pending'";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Customer c = new Customer();
	            c.setCid(rs.getInt("cid"));
				c.setFirst_name(rs.getString("Fname"));
				c.setLast_name(rs.getString("Lname"));
				c.setPhone(rs.getLong("Phone"));
				c.setMail(rs.getString("mail"));
				c.setPassword(rs.getInt("password"));
				c.setDate(rs.getString("date"));
				c.setStatus(rs.getString("status"));
	            list.add(c);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	@Override
	public int getPendingCustomersCount() {
	    int count = 0;
	    try {
	        String sql = "SELECT COUNT(*) FROM customers WHERE status='Pending'";
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
	public ArrayList<Customer> getLatestCustomers() {
	    ArrayList<Customer> list = new ArrayList<>();
	    try {
	        String sql = "SELECT * FROM customers ORDER BY cid DESC LIMIT 5";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Customer c = new Customer();
	            c.setCid(rs.getInt("cid"));
				c.setFirst_name(rs.getString("Fname"));
				c.setLast_name(rs.getString("Lname"));
				c.setPhone(rs.getLong("Phone"));
				c.setMail(rs.getString("mail"));
				c.setPassword(rs.getInt("password"));
				c.setDate(rs.getString("date"));
				c.setStatus(rs.getString("status"));
	            list.add(c);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	@Override
	public boolean approveCustomer(int cid) {
	    String sql = "UPDATE customers SET status = 'ACTIVE' WHERE cid = ?";
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, cid);
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	@Override
	public boolean rejectCustomer(int cid) {
	    String sql = "DELETE FROM customers WHERE cid = ?";
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, cid);
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false; 
	}
	
	@Override
	public boolean toggleBlockCustomer(int cid, String newStatus) {
	    try {
	        String sql = "UPDATE customers SET status=? WHERE cid=?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, newStatus);
	        ps.setInt(2, cid);
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	@Override
	public ArrayList<Customer> getBlockedCustomers() {
	    ArrayList<Customer> list = new ArrayList<>();

	    try {
	        String sql = "SELECT * FROM customers WHERE status = 'BLOCKED'";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Customer c = new Customer();
	            c.setCid(rs.getInt("cid"));
	            c.setFirst_name(rs.getString("Fname"));
	            c.setLast_name(rs.getString("Lname"));
	            c.setPhone(rs.getLong("Phone"));
	            c.setMail(rs.getString("mail"));
	            c.setPassword(rs.getInt("password"));
	            c.setDate(rs.getString("date"));
	            c.setStatus(rs.getString("status"));
	            list.add(c);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return list;
	}

}
