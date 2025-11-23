package in.ps.bankapp.dao;

import java.util.ArrayList;

import in.ps.bankapp.dto.Customer;

public interface CustomerDAO {

	public boolean insertCustomer(Customer c);
	public boolean updateCustomer(Customer c);
	public boolean deleteCustomer(int cid);
	public Customer  getCustomer(String mail,int Password);
	public ArrayList<Customer> getCustomer();
	public Customer getCustomer(String mail);
	public Customer getCustomer(int cid);
	public ArrayList<Customer> getPendingCustomers();
	public int getPendingCustomersCount();
	public ArrayList<Customer> getLatestCustomers();
	public boolean approveCustomer(int cid);
	public boolean rejectCustomer(int cid);
	public boolean toggleBlockCustomer (int cid, String newStatus);
	public ArrayList<Customer> getBlockedCustomers();

}
