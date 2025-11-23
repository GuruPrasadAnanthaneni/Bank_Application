package in.ps.bankapp.dto;

public class Customer {

	private int cid;
	private String first_name;
	private String last_name;
	private long phone;
	private String mail;
	private int password;
	private String date;
	private String Status;

	public int getCid() {
		return cid;
	}
	public void setCid(int cid) {
		this.cid = cid;
	}
	public String getFirst_name() {
		return first_name;
	}
	public void setFirst_name(String first_name) {
		this.first_name = first_name;
	}
	public String getLast_name() {
		return last_name;
	}
	public void setLast_name(String last_name) {
		this.last_name = last_name;
	}
	public long getPhone() {
		return phone;
	}
	public void setPhone(long phone) {
		this.phone = phone;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public int getPassword() {
		return password;
	}
	public void setPassword(int password) {
		this.password = password;
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

	public Customer() {
		// TODO Auto-generated constructor stub
	}

	public Customer(int cid, String first_name, String last_name, long phone, String mail, int password,
			String date) {
		super();
		this.cid = cid;
		this.first_name = first_name;
		this.last_name = last_name;
		this.phone = phone;
		this.mail = mail;
		this.password = password;
		this.date = date;
	}
	@Override
	public String toString() {
		return "Customer [cid=" + cid + ", first_name=" + first_name + ", last_name=" + last_name + ", phone=" + phone
				+ ", mail=" + mail + ", date=" + date + "]";
	}






}
