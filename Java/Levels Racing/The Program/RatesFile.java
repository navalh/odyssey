/* This is RatesFile.java, which handles the operations on ratesFile.dat, 
 *such as checking the fees status of students. Created by Naval Handa, on 
 *24.02.2013, Emirates International School Meadows. Made on a Sony Vaio 
 *E-Series (VPCEB46FG) using JCreator. */

import java.io.*;

class RatesFile {
	
	//Produces a list of overdue students.
	void produceListOverdueStudents() throws IOException {
		displayOverdueStudents();
		System.out.println("\nThe list has now been produced.");
	}
	
	//This helper method displays overdue students.
	void displayOverdueStudents() throws IOException {
		RandomAccessFile ratesFile = new RandomAccessFile ("ratesFile.dat","rw");
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		ratesFile.seek(0);
		int childRate = ratesFile.readInt();
		ratesFile.seek(4);
		int teenagerRate = ratesFile.readInt();
		ratesFile.seek(8);
		int adultRate = ratesFile.readInt();
		/*Reading the current rates being charged per class for children, 
		 *teenagers and adults.*/
		
		System.out.printf("%-4s%-18s%-12s%-9s%-10s%-10s%-5s\n\n", "ID", "Student Name", "Group Name", "Classes", "Fees Due", "Fees Paid", "Overdue Amount");
		
		int classesTotal=0; /*Total classes taught so far to all the students 
		who classify as 'overdue'.*/
		int feesDueTotal=0; //Total fees due from 'overdue' students.
		int feesPaidTotal=0; //Total fees paid by 'overdue' students.
		int overdueTotal=0; //Total amount overdue from 'overdue' students.
		//These variables have to be initiated, and so a reasonable value is 0.
		
		int count = countRecords();//These are the number of student records.
		
		for (int record=0; record<count; record++) {
			Student student = new Student();
			studentFile.seek(record*128+0); 
			student.setId(studentFile.readInt()); 
			studentFile.seek(record*128+4);
			student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
			studentFile.seek(record*128+92);
			student.setGroupName(FixedLengthStringIO.readFixedLengthString(2, studentFile));
			studentFile.seek(record*128+88);
			student.setClassesTaught(studentFile.readInt());
			//Create a student object and enter various data straightaway. 
			
			int feesDue = student.getClassesTaught();
			String ageGroup = (student.getGroupName()).substring(0,1);
			if (ageGroup.equals("C")) 
				feesDue = feesDue*childRate;
			else if (ageGroup.equals("T")) 
				feesDue = feesDue*teenagerRate;	
			if (ageGroup.equals("A")) 
				feesDue = feesDue*adultRate;
			//Calculations to calculate feesDue.	
			
			studentFile.seek(record*128+96);
			student.setFeesPaid(studentFile.readInt()); 
			
			int overdueAmount = feesDue - student.getFeesPaid();
			
			//Only execute if the student is an 'overdue' student. 
			if (overdueAmount>0) {
				System.out.printf("%-4d%-18s%-12s%-9d%-10d%-10d%-5d\n\n", student.getId(), student.getName(), student.getGroupName(), student.getClassesTaught(), feesDue, student.getFeesPaid(), overdueAmount);
				classesTotal = classesTotal + student.getClassesTaught();
				feesDueTotal = feesDueTotal + feesDue;
				feesPaidTotal = feesPaidTotal + student.getFeesPaid();
				overdueTotal = overdueTotal + overdueAmount;
			}
		}
		System.out.printf("%-34s%-9d%-10d%-10d%-5d\n\n", "Total:", classesTotal, feesDueTotal, feesPaidTotal, overdueTotal);
		System.out.println("*Note: Negative overdue indicates the student has paid in advance for classes.\n");
	}
	
	/*The checkFeesStatus method displays the fees paid and due of all students, 
	 *and can display overdue students.*/
	void checkFeesStatus() throws IOException {
		
		/*The logic that follows is exactly the same for displayOverdueStudents(), 
		 *except that all students are displayed.*/
		RandomAccessFile ratesFile = new RandomAccessFile ("ratesFile.dat","rw");
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		System.out.println("\nThe current rates in use are:");

		ratesFile.seek(0);
		int childRate = ratesFile.readInt();
		ratesFile.seek(4);
		int teenagerRate = ratesFile.readInt();
		ratesFile.seek(8);
		int adultRate = ratesFile.readInt();
		
		System.out.println("Child (Under 13): $" +childRate +" per class.");
		System.out.println("Teenager (13 - 17): $" +teenagerRate +" per class.");
		System.out.println("Adult (Over 18): $" +adultRate +" per class.\n");
		
		System.out.printf("%-4s%-18s%-12s%-9s%-10s%-10s%-5s\n\n", "ID", "Student Name", "Group Name", "Classes", "Fees Due", "Fees Paid", "Overdue Amount");
		System.out.println();
		int count = countRecords();
		int classesTotal=0;
		int feesDueTotal=0;
		int feesPaidTotal=0;
		int overdueTotal=0;
		
		for (int record=0; record<count; record++) {
			Student student = new Student();
			studentFile.seek(record*128+0); 
			student.setId(studentFile.readInt()); 
			studentFile.seek(record*128+4);
			student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
			studentFile.seek(record*128+92);
			student.setGroupName(FixedLengthStringIO.readFixedLengthString(2, studentFile));
			studentFile.seek(record*128+88);
			student.setClassesTaught(studentFile.readInt()); 
			
			int feesDue = student.getClassesTaught();
			String ageGroup = (student.getGroupName()).substring(0,1);
			if (ageGroup.equals("C")) 
				feesDue = feesDue*childRate;
			else if (ageGroup.equals("T")) 
				feesDue = feesDue*teenagerRate;	
			if (ageGroup.equals("A")) 
				feesDue = feesDue*adultRate;
			
			studentFile.seek(record*128+96);
			student.setFeesPaid(studentFile.readInt()); 
			
			int overdueAmount = feesDue - student.getFeesPaid();
			
			System.out.printf("%-4d%-18s%-12s%-9d%-10d%-10d%-5d\n\n", student.getId(), student.getName(), student.getGroupName(), student.getClassesTaught(), feesDue, student.getFeesPaid(), overdueAmount);
			classesTotal = classesTotal + student.getClassesTaught();
			feesDueTotal = feesDueTotal + feesDue;
			feesPaidTotal = feesPaidTotal + student.getFeesPaid();
			overdueTotal = overdueTotal + overdueAmount;
		}
		
		System.out.printf("%-34s%-9d%-10d%-10d%-5d\n\n", "Total:", classesTotal, feesDueTotal, feesPaidTotal, overdueTotal);
		System.out.println("*Note: Negative overdue indicates the student has paid in advance for classes.\n"); 

		Validator validator = new Validator();
		System.out.println("Would you like to produce a list of overdue students (1) or change the current rates you charge for your classes (2)?");
		int choice = validator.getAndValidateInt(1,2);
		System.out.println();
		
		if (choice==1) 
			displayOverdueStudents();
		
		else if (choice==2) {
			System.out.println("\nPlease enter the new Child class rate:");
			childRate = validator.getAndValidateInt(1,1000); 
			System.out.println("Please enter the new Teenager class rate:");
			teenagerRate = validator.getAndValidateInt(1,1000); 
			System.out.println("Please enter the new Adult class rate:");
			adultRate = validator.getAndValidateInt(1,1000); 
			
			ratesFile.seek(0);
			ratesFile.writeInt(childRate);
			ratesFile.seek(4);
			ratesFile.writeInt(teenagerRate);
			ratesFile.seek(8);
			ratesFile.writeInt(adultRate);
			
			System.out.println("The new class rates have now been written.\n");
		}
		
		ratesFile.close();
		studentFile.close();
		System.out.println("\nPress 1 to view fees status again or press 2 to exit to the main menu.");
		int menu = validator.getAndValidateInt(1,2); 
		if (menu==1)
			checkFeesStatus();
	}
	
	/*This methods counts the current number of records in the studentFile.dat, 
	 *and returns this value to the calling method.*/
	int countRecords() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int records = (int)(studentFile.length()/128);
		studentFile.close();
		return records;
	}
}