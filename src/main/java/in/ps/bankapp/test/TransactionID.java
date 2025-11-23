package in.ps.bankapp.test;

import java.util.Random;

public class TransactionID {

	public static long generateTransactionID() {
		Random rd = new Random();
		long value = rd.nextLong();
		//System.out.println(value);
		if(value<0) {
			value = value*-1;
		}
		//System.out.println(value);
		return value;
	}
}
