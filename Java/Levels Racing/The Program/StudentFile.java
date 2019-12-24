/* This is StudentFile.java, which handles the operations performed with 
 *the studentFile.dat, such as creating and editing new student records. 
 *Created by Naval Handa, on 24.02.2013, Emirates International School 
 *Meadows. Made on a Sony Vaio E-Series (VPCEB46FG) using JCreator. */

import java.util.Scanner;
import java.io.*;

class StudentFile {
	/*Displays a lot of all the students in the studentFile. */
	void produceListAllStudents() throws IOException {
		int personalOrPerformanceData; /*Whether the user wishes to display 
		personal or performance data. '1' represents the former, while '2' 
		represents the latter. */
		System.out.println("Would you like to view personal data (1) or performance data (2)?");
		Validator validator = new Validator();
		personalOrPerformanceData = validator.getAndValidateInt(1,2);
		System.out.println();
		if (personalOrPerformanceData==1)
			displayAllRecordsPersonalData();
		else if (personalOrPerformanceData==2)
			displayAllRecordsPerformanceData();
			
		System.out.println("\nThe list has now been produced.");	
	}
	
	/*Displays a list of the best students in the studentFile, defined as 
	 *those who have a racing level of more than 5. */
	void produceListBestStudents() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int count = countRecords(); /*Number of records (all the students) in 
		the studentFile. */
		System.out.printf("%-4s%-18s%-5s%-15s%-12s%-12s%-12s\n\n", "ID", "Student Name", "Age", "Racing Level", "Avg. 400m", "Avg. 800m", "Avg. 1000m");
		
		for (int record=0; record<count; record++) {
			Student student = new Student();
			studentFile.seek(record*128+0); 
			student.setId(studentFile.readInt()); 
			studentFile.seek(record*128+4);
			student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
			studentFile.seek(record*128+40);
			student.setAge(studentFile.readInt());
			studentFile.seek(record*128+100);
			student.setRacingLevel(studentFile.readInt()); 
			studentFile.seek(record*128+104);
			student.setAverage400(studentFile.readDouble()); 
			studentFile.seek(record*128+112);
			student.setAverage800(studentFile.readDouble());
			studentFile.seek(record*128+120);
			student.setAverage1000(studentFile.readDouble());
			
			/*If the student qualifies as a 'best' student, display 
			 *his performance data. */
			if (student.getRacingLevel()>5) 
				student.displayRecordPerformanceData();
		}
		studentFile.close();
	}
	
	/*Displays a list of the worst students in the studentFile, defined 
	 *as those who have a racing level of 5 or less. Follows the same 
	 *logic as the above method, with a different if condition. */
	void produceListStudentsNotPerforming() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int count = countRecords(); /*Number of records (all the students) in 
		the studentFile. */
		System.out.printf("%-4s%-18s%-5s%-15s%-12s%-12s%-12s\n\n", "ID", "Student Name", "Age", "Racing Level", "Avg. 400m", "Avg. 800m", "Avg. 1000m");
		
		for (int record=0; record<count; record++) {
			Student student = new Student();
			studentFile.seek(record*128+0); 
			student.setId(studentFile.readInt()); 
			studentFile.seek(record*128+4);
			student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
			studentFile.seek(record*128+40);
			student.setAge(studentFile.readInt());
			studentFile.seek(record*128+100);
			student.setRacingLevel(studentFile.readInt()); 
			studentFile.seek(record*128+104);
			student.setAverage400(studentFile.readDouble()); 
			studentFile.seek(record*128+112);
			student.setAverage800(studentFile.readDouble());
			studentFile.seek(record*128+120);
			student.setAverage1000(studentFile.readDouble());
			
			if (student.getRacingLevel()<=5) 
				student.displayRecordPerformanceData();
		}
		studentFile.close();
	}
	
	/*This method allows the user to update classes taught and new lap 
	 *times of a group (class) that he has just taught. */
	void updateClassesAndTimes() throws IOException {
		try{
			RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
			Scanner input = new Scanner (System.in);
			System.out.println("Which one of your groups did you just teach?\n");
			studentFile.seek(92); 
			String groupList = FixedLengthStringIO.readFixedLengthString(2, studentFile); 
			/*This variable will eventually contain all the group names that 
			 *exist in studentFile, concatenated into one string. Will be used 
			 *to help display the students according to group name. */
			 
			int count = countRecords(); /*Number of records (all the students) 
			in the studentFile. */
			
			for (int i=0; i<count; i++) {
				studentFile.seek(i*128+92);
				String thisGroup = FixedLengthStringIO.readFixedLengthString(2, studentFile); 
				/*The group name of the current student. */
				boolean doesThisGroupExistInGroupList = false; 
				/*Whether 'thisGroup' is already in the 'groupList' string. */
				
				/*This loop checks if 'thisGroup' is in 'groupList'. If not, 
				 *the if condition concatenates 'thisGroup' to 'groupList'. */
				for (int j=0; j<(groupList.length())/2; j++) {
					if (thisGroup.equals(groupList.substring(j*2, (j*2)+2)))
						doesThisGroupExistInGroupList = true;
				}
				if (!doesThisGroupExistInGroupList)
					groupList = groupList.concat(thisGroup);
			}
			
			/*This loop goes through each group name in the groupList string, 
			 *and displays the students in that group. */
			for (int i=0; i<(groupList.length())/2; i++) {
				String currentGroup = groupList.substring(i*2, (i*2)+2);
				System.out.print("Group " +currentGroup +"? ( ");
				
				for (int j=0; j<count; j++) {
					studentFile.seek(j*128+92);
					if (currentGroup.equals(FixedLengthStringIO.readFixedLengthString(2, studentFile))) {
						studentFile.seek(j*128+4);
						System.out.print((FixedLengthStringIO.readFixedLengthString(18, studentFile)).trim()+"; ");
					}	
				}
				System.out.print(")\n\n");	
			}
			
			System.out.println("Please enter the name of the group that you've taught:");
			String desiredGroupName = input.nextLine();  /*The user-input name 
			of the group he has taught (and wishes to update). */
			
			boolean desiredGroupNameIsValid = false; /*Whether or not the 
			entered group name exists in the studentFile. */
			
			/*Validates the entered group name to ensure it starts with the 
			 *character "A", "C" or "T". */
			while (!desiredGroupNameIsValid) {
				String desiredGroupNameSubstring = desiredGroupName.substring(0,1);
				if (!(desiredGroupNameSubstring.equals("A")||desiredGroupNameSubstring.equals("C")||desiredGroupNameSubstring.equals("T"))) {
					System.out.println("Sorry, that group name does not exist. Please enter the group name again:");
					desiredGroupName = input.nextLine();
				}
				else 
					desiredGroupNameIsValid=true;
			}
			
			/*This loop goes through all the records in the studentFile, 
			 *and updates the classes taught (adds 1) of those student who 
			 *belong to the specified group. */
			for (int i=0; i<count; i++) {
				studentFile.seek(i*128+92);
				if (desiredGroupName.equals(FixedLengthStringIO.readFixedLengthString(2, studentFile))) {
					studentFile.seek(i*128+88);
					int updatedClassesTaught = (studentFile.readInt()) + 1;
					studentFile.seek(i*128+88);
					studentFile.writeInt(updatedClassesTaught);
				}	
			}
			System.out.println("The students of group " +desiredGroupName +" have been taught one more class.\n");
			System.out.println("Which lap times did you record: 400m (1), 800m (2) or/and 1000m (3)?");
			System.out.println("For example, if both 400m and 800m were recorded then please enter 12.");
			Validator validator = new Validator();
			int desiredLapTimes = validator.getAndValidateInt(1, 321); 
			/*The lap times the user wishes to enter. For example, 
			 *23 would represent that both 800m and 1000m lap 
			 *times were recorded. */
			
			boolean update400 = false; /*Whether or not to update the 400m 
			lap times of the students who belong to the desired group */
			boolean update800 = false; /*Whether or not to update the 800m 
			lap times. */
			boolean update1000 = false; /*Whether or not to update the 1000m 
			lap	times. */
			
			/*This loop calculates which lap times are to be updated. */
			while (desiredLapTimes>0) {
				int desiredTime = desiredLapTimes%10;
				if (desiredTime==1)
					update400 = true;
				else if (desiredTime==2)
					update800 = true;	
				else if (desiredTime==3)
					update1000 = true;	
				desiredLapTimes = desiredLapTimes/10;	
			}
			
			/*If the 400m lap times are to be updated of those students: */
			if (update400) {
				for (int i=0; i<count; i++) {
					studentFile.seek(i*128+92);
					if (desiredGroupName.equals(FixedLengthStringIO.readFixedLengthString(2, studentFile))) {
						studentFile.seek(i*128+4);
						System.out.println("\nEnter " +(FixedLengthStringIO.readFixedLengthString(18, studentFile)).trim()+ "'s 400m lap time:");
						double currentLapTime = validator.getAndValidateDouble(1,60); 
						/*The user-entered lap time that the student has 
						 *achieved in the class that was just taught. */
						 
						studentFile.seek(i*128+104);
						double previousAverageLapTime = studentFile.readDouble(); 
						/*The previous average 400m lap time of the student. */
						
						double newAverageLapTime; /*The new average lap time of 
						the student. */
						
						/*If the student has set a 400m lap time for the 
						 *first time. */
						if (previousAverageLapTime==0.0) 
							newAverageLapTime = currentLapTime;
							
						/*The 'newAverageLapTime' is not exactly an 
						 *average: the new lap time is 'weighted' more 
						 *because it is a more recent indicator of a student's 
						 *performance. Hence, the 'average'-ing formula used 
						 *was: (Old Average + New Lap Time)/2. */	
						else 
							newAverageLapTime = (currentLapTime + previousAverageLapTime)/2;
						studentFile.seek(i*128+104);	
						studentFile.writeDouble(newAverageLapTime);
					}	
				}
			}
			
			/*If the 800m lap times are to be updated of those students. 
			 *Follows the same logic as the above if 
			 *condition [if (update400)]. */
			if (update800) {
				for (int i=0; i<count; i++) {
					studentFile.seek(i*128+92);
					if (desiredGroupName.equals(FixedLengthStringIO.readFixedLengthString(2, studentFile))) {
						studentFile.seek(i*128+4);
						System.out.println("\nEnter " +(FixedLengthStringIO.readFixedLengthString(18, studentFile)).trim()+ "'s 800m lap time:");
						double currentLapTime = validator.getAndValidateDouble(1,80);
						studentFile.seek(i*128+112);
						double previousAverageLapTime = studentFile.readDouble();
						double newAverageLapTime;
						if (previousAverageLapTime==0.0)
							newAverageLapTime = currentLapTime;
						else 
							newAverageLapTime = (currentLapTime + previousAverageLapTime)/2;
						studentFile.seek(i*128+112);	
						studentFile.writeDouble(newAverageLapTime);
					}	
				}
			}
			
			/*If the 1000m lap times are to be updated of those students. 
			 *Follows the same logic as the above if condition 
			 *[if (update400)]. */ 
			if (update1000) {
				for (int i=0; i<count; i++) {
					studentFile.seek(i*128+92);
					if (desiredGroupName.equals(FixedLengthStringIO.readFixedLengthString(2, studentFile))) {
						studentFile.seek(i*128+4);
						System.out.println("\nEnter " +(FixedLengthStringIO.readFixedLengthString(18, studentFile)).trim()+ "'s 1000m lap time:");
						double currentLapTime = validator.getAndValidateDouble(1,100);
						studentFile.seek(i*128+120);
						double previousAverageLapTime = studentFile.readDouble();
						double newAverageLapTime;
						if (previousAverageLapTime==0.0)
							newAverageLapTime = currentLapTime;
						else 
							newAverageLapTime = (currentLapTime + previousAverageLapTime)/2;
						studentFile.seek(i*128+120);	
						studentFile.writeDouble(newAverageLapTime);
					}	
				}
			}
			
			/*This method updates the racing level of the students in the 
			 *desired group (in both the studentFile and teamFile). */
			for (int i=0; i<count; i++) {
				studentFile.seek(i*128+92);
				if (desiredGroupName.equals(FixedLengthStringIO.readFixedLengthString(2, studentFile))) {
					Student student = new Student();
					studentFile.seek(i*128+104);
					student.setAverage400(studentFile.readDouble()); 
					studentFile.seek(i*128+112);
					student.setAverage800(studentFile.readDouble());
					studentFile.seek(i*128+120);
					student.setAverage1000(studentFile.readDouble());
					int updatedRacingLevel = calculateRacingLevel(student); 
					/*The method calculates the racing level from the given 
					 *data, and assigns the value to updatedRacingLevel. */
					
					studentFile.seek(i*128+100);
					studentFile.writeInt(updatedRacingLevel);
					
					studentFile.seek(i*128+0);
					int currentId = studentFile.readInt(); /*The ID of the 
					student whose racing level has just been updated. Used to 
					help find the student record in the teamFile 
					(if it exists).*/
					RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
					for (int j=0; j<countTeamRecords(); j++) {
						teamFile.seek(j*84+0);
						/*If the student record was found. */
						if (teamFile.readInt()==currentId) {
							teamFile.seek(j*84+40);
							teamFile.writeInt(updatedRacingLevel);
						}
					}
					teamFile.close();
				}	
			}	
			studentFile.close();
			System.out.println("\n\nLap times and racing levels have now been updated.");
			System.out.println("Press 1 to update another group or press 2 to exit to the main menu.");
			int menu = validator.getAndValidateInt(1,2);
			if (menu==1)
				updateClassesAndTimes();
		}
		catch (EOFException e) {
			System.out.println("The file has unexpectedly reached its end. Please try again.");
		}
		catch (FileNotFoundException e) {
			System.out.println("The requested file cannot be found. Please try again.");
		}
		catch (IOException e) {
			System.out.println("An unexpected I/O error has occured. Please try again.\nThe exact reason for this is: " + e.getMessage());
		}
	}
	/*Returns the racing level of a student for a class taught, based on the 
	 *average 400, 800 and 1000m times the student had set that class. */
	int calculateRacingLevel (Student student) {
		try {
			int racingLevel400=0;
			int racingLevel800=0;
			int racingLevel1000=0;
			
			if (student.getAverage400()>0) {
				/*These limits are preset values that are an indicator for the 
				 *racing level, just like a grade boundary for a particular 
				 *subject in school. */
				if (student.getAverage400()<=22)
					racingLevel400 = 10;
				else if (student.getAverage400()<=23)
					racingLevel400 = 9;	
				else if (student.getAverage400()<=24)
					racingLevel400 = 8;
				else if (student.getAverage400()<=25)
					racingLevel400 = 7;
				else if (student.getAverage400()<=26)
					racingLevel400 = 6;
				else if (student.getAverage400()<=27)
					racingLevel400 = 5;
				else if (student.getAverage400()<=28)
					racingLevel400 = 4;
				else if (student.getAverage400()<=29)
					racingLevel400 = 3;
				else if (student.getAverage400()<=30)
					racingLevel400 = 2;
				else if (student.getAverage400()>30)
					racingLevel400 = 1;
			}
			else
				racingLevel400=0;
			
			if (student.getAverage800()>0) {
				if (student.getAverage800()<=40)
					racingLevel800 = 10;
				else if (student.getAverage800()<=41)
					racingLevel800 = 9;	
				else if (student.getAverage800()<=42)
					racingLevel800 = 8;
				else if (student.getAverage800()<=43)
					racingLevel800 = 7;
				else if (student.getAverage800()<=44)
					racingLevel800 = 6;
				else if (student.getAverage800()<=45)
					racingLevel800 = 5;
				else if (student.getAverage800()<=46)
					racingLevel800 = 4;
				else if (student.getAverage800()<=47)
					racingLevel800 = 3;
				else if (student.getAverage800()<=48)
					racingLevel800 = 2;
				else if (student.getAverage800()>48)
					racingLevel800 = 1;
			}
			else
				racingLevel800=0;	
			
			if (student.getAverage1000()>0) {
				if (student.getAverage1000()<=48)
					racingLevel1000 = 10;
				else if (student.getAverage1000()<=49)
					racingLevel1000 = 9;	
				else if (student.getAverage1000()<=50)
					racingLevel1000 = 8;
				else if (student.getAverage1000()<=51)
					racingLevel1000 = 7;
				else if (student.getAverage1000()<=52)
					racingLevel1000 = 6;
				else if (student.getAverage1000()<=53)
					racingLevel1000 = 5;
				else if (student.getAverage1000()<=54)
					racingLevel1000 = 4;
				else if (student.getAverage1000()<=55)
					racingLevel1000 = 3;
				else if (student.getAverage1000()<=56)
					racingLevel1000 = 2;
				else if (student.getAverage1000()>56)
					racingLevel1000 = 1;
			}
			else
				racingLevel1000=0;
			
			int averager = 3;
			if (racingLevel400==0)
				averager--;
			if (racingLevel800==0)
				averager--;
			if (racingLevel1000==0)
				averager--;		
			int averageRacingLevel = (racingLevel400 +racingLevel800 +racingLevel1000)/averager;
			return averageRacingLevel;
		}
		catch (ArithmeticException e) {
			System.out.println("Sorry, a calculation involving division by 0 occured. Please try again.");
			return 0;
		}					
	}
	
	/*This method allows the user to delete a desried student record. */
	void deleteStudent() throws IOException {
		try {
			RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
			displayAllRecordsPersonalData();
			
			int count = countRecords(); /*Number of records (all the students) 
			in the studentFile. */
			boolean recordFound = false; /*Whether or not the desired student 
			record has been found. */
			int record; /*The record number of the student to be deleted, 
			which is not necessarily the same as the desiredId. */
			int copyOfDesiredId=0; /*This variable will store a copy of 
			desiredId, which will be needed later. */
			
			System.out.println("What is the ID of the record you would like to delete?");
			Validator validator = new Validator();
			int desiredId = validator.getAndValidateInt(1,getLastStudentRecordId()); 
			/*The user-input ID number of the student he would like to 
			 *delete. */
			
			/*This loop ensures that the desiredId record exists, and then 
			 *confirms with the user whether or not to delete this student 
			 *record. */
			for (record=0; !recordFound; record++) {
				studentFile.seek(record*128+0);
				if (desiredId == studentFile.readInt()) {
					recordFound = true;
					System.out.println("\nWould you like to delete this record?\n");
					displayRecordAllData(record);
					System.out.println("If you want to delete this student, enter -1.");
					System.out.println("Otherwise, re-enter the ID of the student you would like to delete:");
					copyOfDesiredId = desiredId;
					desiredId = validator.getAndValidateInt(-1,getLastStudentRecordId());
					if (desiredId!=-1) {
						recordFound=false;
						record=0;
					}
				}
				if (!recordFound && (record+1)==count) {
					System.out.println("Sorry, that ID number does not exist in the file. Please try again.");
					desiredId = validator.getAndValidateInt(1,getLastStudentRecordId());
					record=0;
				}
			}
			
			Student student = new Student(); /*Create a Student object to 
			help store the data to be shuffled. */
			
			/*This loop reads the data of the next record, and replaces the 
			 *data of the previous record with this data, effectively 
			 *'shuffling' the records in the studentFile and hence 
			 *overwritting/deleting the previous record. */
			for (int i=record; i<count; i++) { 
				studentFile.seek(i*128+0);
				student.setId(studentFile.readInt());
				studentFile.seek((i-1)*128+0);
				studentFile.writeInt(student.getId());
				
				studentFile.seek(i*128+4);
				student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
				studentFile.seek((i-1)*128+4);
				FixedLengthStringIO.writeFixedLengthString (student.getName(), 18, studentFile);
				
				studentFile.seek(i*128+40);
				student.setAge(studentFile.readInt());
				studentFile.seek((i-1)*128+40);
				studentFile.writeInt(student.getAge());
				
				studentFile.seek(i*128+44);
				student.setAddress(FixedLengthStringIO.readFixedLengthString(22, studentFile));
				studentFile.seek((i-1)*128+44);
				FixedLengthStringIO.writeFixedLengthString (student.getAddress(), 22, studentFile);
				
				studentFile.seek(i*128+88);
				student.setClassesTaught(studentFile.readInt());
				studentFile.seek((i-1)*128+88);
				studentFile.writeInt(student.getClassesTaught());
				
				studentFile.seek(i*128+92);
				student.setGroupName(FixedLengthStringIO.readFixedLengthString(2, studentFile));
				studentFile.seek((i-1)*128+92);
				FixedLengthStringIO.writeFixedLengthString (student.getGroupName(), 2, studentFile);
				
				studentFile.seek(i*128+96);
				student.setFeesPaid(studentFile.readInt());
				studentFile.seek((i-1)*128+96);
				studentFile.writeInt(student.getFeesPaid());
				
				studentFile.seek(i*128+100);
				student.setRacingLevel(studentFile.readInt());
				studentFile.seek((i-1)*128+100);
				studentFile.writeInt(student.getRacingLevel());
				
				studentFile.seek(i*128+104);
				student.setAverage400(studentFile.readDouble());
				studentFile.seek((i-1)*128+104);
				studentFile.writeDouble(student.getAverage400());
				
				studentFile.seek(i*128+112);
				student.setAverage800(studentFile.readDouble());
				studentFile.seek((i-1)*128+112);
				studentFile.writeDouble(student.getAverage800());
				
				studentFile.seek(i*128+120);
				student.setAverage1000(studentFile.readDouble());
				studentFile.seek((i-1)*128+120);
				studentFile.writeDouble(student.getAverage1000());
			}
			studentFile.setLength(studentFile.length()-128); /*Reduce the 
			length of the studentFile by one record because there is now 
			an extra space. */
			System.out.println("\nHere is the edited file after deleting Record No. " +record +":\n");
			displayAllRecordsPersonalData();
			studentFile.close();
			
			RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
			int teamCount = countTeamRecords(); /*Number of records 
			(all the racers) in the teamFile. */
			boolean teamRecordFound = false; /*Whether this deleted 
			student was found in the teamFile as well. */
			
			/*This loop searches the teamFile for the student that was 
			 *deleted. If it is found, the following records are 
			 *shuffled back one and the file length is reduced by 
			 *one record size. */
			for (record=0; !teamRecordFound&&record<teamCount; record++) {
				teamFile.seek(record*84+0);
				if (copyOfDesiredId==teamFile.readInt()) {
					teamRecordFound=true;
					Racer racer = new Racer();
					for (int i=record+1; i<teamCount; i++) { 
						teamFile.seek(i*84+0);
						racer.setId(teamFile.readInt());
						teamFile.seek((i-1)*84+0);
						teamFile.writeInt(racer.getId());
						
						teamFile.seek(i*84+4);
						racer.setName(FixedLengthStringIO.readFixedLengthString(18, teamFile));
						teamFile.seek((i-1)*84+4);
						FixedLengthStringIO.writeFixedLengthString (racer.getName(), 18, teamFile);
						
						teamFile.seek(i*84+40);
						racer.setRacingLevel(teamFile.readInt());
						teamFile.seek((i-1)*84+40);
						teamFile.writeInt(racer.getRacingLevel());
						
						teamFile.seek(i*84+44);
						racer.setTeamName(FixedLengthStringIO.readFixedLengthString(20, teamFile));
						teamFile.seek((i-1)*84+44);
						FixedLengthStringIO.writeFixedLengthString (racer.getTeamName(), 20, teamFile);
					}
					teamFile.setLength(teamFile.length()-84);
					System.out.println("The student also existed in the Team file: he or she has been deleted from there as well.");
					teamFile.close();
				}
			}
			System.out.println("Press 1 to delete another student or press 2 to exit to the main menu.");
			int menu = validator.getAndValidateInt(1,2);
			if (menu==1)
				deleteStudent();
		}
		catch (EOFException e) {
			System.out.println("The file has unexpectedly reached its end. Please try again.");
		}
		catch (FileNotFoundException e) {
			System.out.println("The requested file cannot be found. Please try again.");
		}
		catch (IOException e) {
			System.out.println("An unexpected I/O error has occured. Please try again.\nThe exact reason for this is: " + e.getMessage());
		}
	}
	
	/*This methods counts the current number of records in the teamFile.dat, 
	 *and returns this value to the calling method.*/
	int countTeamRecords() throws IOException {
		RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
		int records = (int)(teamFile.length()/84);
		teamFile.close();
		return records;
	}
	
	/*This method searches the studentFile for a student based on criteria 
	 *chosen by the user. */
	void searchStudent() throws IOException {
		
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int count = countRecords(); /*Number of records (all the students) 
		in the studentFile. */
		boolean recordFound = false; /*Whether the desired student 
		(or students) have been found. */
		Student student = new Student(); /*Creating a Student object 
		that will store the data. */
		
		System.out.println("What would you like to base your search on?");
		System.out.println("1) ID\n2) Student Name\n3) Age\n4) Classes Taught\n5) Group Name\n6) Racing Level");
		Scanner input = new Scanner(System.in);
		Validator validator = new Validator();
		int userFieldChoice = validator.getAndValidateInt(1,6); 
		/*What criteria the user would like to search by, where ID=1, 
		 *Name=2, Age=3, Classes Taught=4, Group Name=5 and Racing Level=6. */
		
		/*If the user wishes to search by ID Number: */
		if (userFieldChoice==1) {
			System.out.println("Enter the ID of the student you would like to search for:");
			
			int desiredId = validator.getAndValidateInt(1,getLastStudentRecordId()); 
			/*The user-input ID number of the student the user would like to 
			 *search for. */
			 
			student.setId(desiredId);
			int record; /*The record number of the desired student to be 
			found. */
			
			for (record=0; !recordFound&&record<count; record++) {
				studentFile.seek(record*128+0);
				if (student.getId()==studentFile.readInt()) {
					recordFound=true;
					displayRecordAllData(record);
				}
			}
			if (!recordFound) 
				System.out.println("Sorry, that ID number does not exist in the file. Please try again.");
		}
		
		/*If the user wishes to search by name of the student- either 
		 *first or full name. */
		else if (userFieldChoice==2) {
			System.out.println("Enter the name (whether first or full) of the student(s) you would like to search for:");
			
			String desiredName = input.nextLine(); /*The user-input student 
			name to be found in the studentFile. */
			int desiredNameLength = desiredName.length(); /*The length of 
			the user-input string, to help determine how many characters 
			should be compared. */
			student.setName(desiredName);
			
			String substringOfName; /*This will store the part of the 
			file-read name that is being compared. For example, if 
			"Samuel" is entered by the user, then only the first 6 
			characters of every string in the name field of each record 
			will be read and compared with. */
			
			int record; /*The record number of the desired student(s) to 
			be found. */
			
			for (record=0; record<count; record++) {
				studentFile.seek(record*128+4);
				substringOfName = (FixedLengthStringIO.readFixedLengthString(18, studentFile)).substring(0,desiredNameLength); /*Get the substring of the name read from the file, based on desiredNameLength. */
				
				if ((student.getName()).equals(substringOfName)) {
					/*Print this one-off statement if this was the first 
					 *student to be found with the desired name. */
					if (!recordFound)
						System.out.println("Here is/are the desired student(s):\n");
					recordFound=true;
					displayRecordAllData(record);
				}
			}
			if (!recordFound) 
				System.out.println("Sorry, no student has that name (first or full). Please try again.");
		}
		
		/*If the user wishes to search by age of the student. Follows similar 
		 *logic to the previous two if statements for userFieldChoice. */
		else if (userFieldChoice==3) {
			System.out.println("Enter the age of the student(s) you would like to search for:");
			int desiredAge = validator.getAndValidateInt(1,100);
			student.setAge(desiredAge);
			int record;
			
			for (record=0; record<count; record++) {
				studentFile.seek(record*128+44);
				if (student.getAge()==studentFile.readInt()) {
					if (!recordFound)
						System.out.println("Here is/are the desired student(s):\n");
					recordFound=true;
					displayRecordAllData(record);
				}
			}
			if (!recordFound) 
				System.out.println("Sorry, no student has that age. Please try again.");
		}
		
		/*If the user wishes to search by classes taught of the student. 
		 *Follows similar logic to the first two if statements for 
		 *userFieldChoice. */
		else if (userFieldChoice==4) {
			System.out.println("Enter the classes taught of the student(s) you would like to search for:");
			int desiredClassesTaught = validator.getAndValidateInt(0,100);
			student.setClassesTaught(desiredClassesTaught);
			int record;
			
			for (record=0; record<count; record++) {
				studentFile.seek(record*128+88);
				if (student.getClassesTaught()==studentFile.readInt()) {
					if (!recordFound)
						System.out.println("Here is/are the desired student(s):\n");
					recordFound=true;
					displayRecordAllData(record);
				}
			}
			if (!recordFound) 
				System.out.println("Sorry, no student has those number of classes taught. Please try again.");
		}
		
		/*If the user wishes to search by group name of the student. 
		 *Follows similar logic to the first two if statements for 
		 *userFieldChoice. */
		else if (userFieldChoice==5) {
			System.out.println("Enter the group name of the student(s) you would like to search for:");
			String desiredGroupName = input.nextLine(); 
			student.setGroupName(desiredGroupName);
			int record;
			
			for (record=0; record<count; record++) {
				studentFile.seek(record*128+92);
				if ((student.getGroupName()).equals(FixedLengthStringIO.readFixedLengthString(2, studentFile))) {
					if (!recordFound)
						System.out.println("Here is/are the desired student(s):\n");
					recordFound=true;
					displayRecordAllData(record);
				}
			}
			if (!recordFound) 
				System.out.println("Sorry, no student belongs to that group. Please try again.");
		}
		
		/*If the user wishes to search by racing level of the student. 
		 *Follows similar logic to the first two if statements for 
		 *userFieldChoice. */
		else if (userFieldChoice==6) {
			System.out.println("Enter the racing level of the student(s) you would like to search for:");
			int desiredRacingLevel = validator.getAndValidateInt(1,10);
			student.setRacingLevel(desiredRacingLevel);
			int record;
			
			for (record=0; record<count; record++) {
				studentFile.seek(record*128+100);
				if (student.getRacingLevel()==studentFile.readInt()) {
					if (!recordFound)
						System.out.println("Here is/are the desired student(s):\n");
					recordFound=true;
					displayRecordAllData(record);
				}
			}
			if (!recordFound) 
				System.out.println("Sorry, no student has those number of classes taught. Please try again.");
		}
		
		studentFile.close();
		System.out.println("\nPress 1 to search for another student or press 2 to exit to the main menu.");
		int menu = validator.getAndValidateInt(1,2);
		if (menu==1)
			searchStudent();
	}
	
	/*This method enables the user to sort the data in the studentFile 
	 *based on his specified criteria. Acceps the user-input of some 
	 *important values, then calls the MergeSorter.class to handle the rest. */
	void sortStudents() throws IOException {
		Validator validator = new Validator();
		int personalOrPerformanceData; /*Whether the user wants to view 
		personal (1) or performance (2) data. */
		System.out.println("Would you like to view personal data (1) or performance data (2)?");
		personalOrPerformanceData = validator.getAndValidateInt(1,2);
		System.out.println();
		if (personalOrPerformanceData==1)
			displayAllRecordsPersonalData();
		else if (personalOrPerformanceData==2)
			displayAllRecordsPerformanceData();
			
		System.out.println("Enter the Column number and order (ascending [1] or descending [2]) together, of the field you would like to sort by. "
		+ "For example, enter 12 to sort by name in descending order. Note: Columns start from Name because data is already sorted by ID.");
		int userAspectChoice = validator.getAndValidateInt(11,62); /*The value 
		of the column (aspect/field) and ascending(1)/descending(2) the user 
		would like to sort by. */
		System.out.println();
		
		int columnNumber = userAspectChoice/10; /*What field the user would 
		like to sort by. Can be a number from 1-6.*/
		
		int ascendingOrDescending = userAspectChoice%10;/*Whether the user 
		would like to sort in ascending (1) or descending order (2).  */
		
		int positionOfAspect = positionOfAspect(personalOrPerformanceData, columnNumber); 
		/*Using the previous two values, the actual file position of the field 
		 *to be sorted by is calculated and assigned to this variable. */
		 
		int typeOfAspect = typeOfAspect(personalOrPerformanceData, columnNumber); 
		/*Whether the field being sorted by is String (1), int (2) 
		 *or double (3).*/
		
		MergeSorter sorter = new MergeSorter(positionOfAspect, typeOfAspect, personalOrPerformanceData, ascendingOrDescending); 
		/*Creates a new MergeSorter object, passing these 4 values. */
		sorter.sort(); /*Calls the sort() method of MergeSorter to do the 
		rest, now that the user has input the necessary data. */
		System.out.println("\nPress 1 to sort again or press 2 to exit to the main menu.");
		int menu = validator.getAndValidateInt(1,2);
		if (menu==1)
			sortStudents();	
	}
	
	/*This method allows the user to edit a field of any desired student 
	 *record in studentFile. */
	void editStudent() throws IOException {
		try {
			RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
			Scanner input = new Scanner(System.in);
			Validator validator = new Validator();
			int personalOrPerformanceData;/*Whether the user would like to view 
			and edit personal (1) or performance (2) data. */
			System.out.println("Would you like to edit personal data (1) or performance data (2)?");
			personalOrPerformanceData = validator.getAndValidateInt(1,2);
			System.out.println();
			if (personalOrPerformanceData==1)
				displayAllRecordsPersonalData();
			else if (personalOrPerformanceData==2)
				displayAllRecordsPerformanceData();
			
			boolean recordFound = false; /*Whether or not the desired record 
			the user wants to edit has been found. */
			int record=-1; /*The number of the student record to be found. 
			Has to be initialised */
			int positionOfAspect=-1; /*The value of the actual file position 
			of the field to be edited. */
			int typeOfAspect=-1; /*The value of the actual file position of 
			the field to be edited. */
			int lengthOfAspect=-1; /*Whether the field being edited is of 
			String (1), int (2) or double (3) type. */
			int userAspectChoice; /*The value the user will be prompted to 
			enter. */
			
			/*This loop will continue to prompt the user for an input until a
			 * desired record has been found. */
			while (!recordFound) {
				System.out.println("Enter the ID and Column number together, of the field you would like to edit. "
				+ "For example, enter 152 to edit the second column (Age) of the record with ID 15. Note: Columns start from Name because ID cannot be edited.");
				userAspectChoice = validator.getAndValidateInt(11,(getLastStudentRecordId())*10+6); 
				/*The reason for the range of validation is: lower limit of 
				 *what the user could enter is ID 1 and Field 1 (Name). 
				 *This represents an input of 11. For Upper Limit, suppose 
				 *the last ID in the file is 120. Therefore, the highest 
				 *value can be 120x, where x can be 1, 2, 3, 4, 5 or 6. 
				 *So upper limit is 1206, or 120*10 + 6. */
				
				int desiredId = userAspectChoice/10; /*The user-input ID 
				number of the student to be edited.*/
				int columnNumber = userAspectChoice%10; /*Represents the 
				field to be edited.*/
				
				positionOfAspect = positionOfAspect(personalOrPerformanceData, columnNumber);
				typeOfAspect = typeOfAspect(personalOrPerformanceData, columnNumber);
				/*If the field is of String type, find how much the field 
				 *length is:*/
				if (typeOfAspect==1) 
					lengthOfAspect = lengthOfAspect(columnNumber);
					
				int i; /*A traverser variable for the file. Needs to be 
				declared outside the loop because it will be used later to 
				assign a value to 'record'.*/	
				
				/*This loop traverses studentFile until the desired student 
				 *is found.*/
				for (i=0; i<countRecords()&&!recordFound; i++) {
					studentFile.seek(i*128+0);
					if (desiredId == studentFile.readInt())
						recordFound= true;
				}
				/*If the record was found, assign the value of i-1 as the 
				 *record number for 'record'.*/
				if (recordFound)
					record = i-1;	
				else
					System.out.println("Sorry, that ID number does not exist in the file. Please try again.");	
			}
			
			System.out.println("Please enter the new data:");
			/*If the data to be edited is of String type.*/
			if (typeOfAspect==1) {
				String newData = new String(); /*The new String data to be 
				provided by the user.*/
				newData = input.nextLine();
				studentFile.seek(record*128 + positionOfAspect);
				FixedLengthStringIO.writeFixedLengthString (newData, lengthOfAspect, studentFile); 
				/*Write the new data in the desired location.*/
			}
			
			else if (typeOfAspect==2) {
				int newData = input.nextInt(); /*The new int data to be 
				provided by the user.*/
				studentFile.seek(record*128 + positionOfAspect);
				studentFile.writeInt(newData);
			}
			
			else if (typeOfAspect==3) {
				double newData = input.nextDouble(); /*The new double data to 
				be provided by the user.*/
				studentFile.seek(record*128 + positionOfAspect);
				studentFile.writeDouble(newData);
			}
			displayRecordAllData(record); /*Display the edited record as it 
			exists now in the fiel..*/
			studentFile.close();
			
			System.out.println("\nPress 1 to edit another student's record or press 2 to exit to the main menu.");
			int menu = validator.getAndValidateInt(1,2);
			if (menu==1)
				editStudent();
		}
		catch (EOFException e) {
			System.out.println("The file has unexpectedly reached its end. Please try again.");
		}
		catch (FileNotFoundException e) {
			System.out.println("The requested file cannot be found. Please try again.");
		}
		catch (IOException e) {
			System.out.println("An unexpected I/O error has occured. Please try again.\nThe exact reason for this is: " + e.getMessage());
		}
	}
	
	/*This method returns the value of the actual file position of the field 
	 *to be edited/sorted. Depends on what column number the user 
	 *picked (and whether he was looking at personal or performance data).*/
	int positionOfAspect(int personalOrPerformanceData, int columnNumber) {
		int positionOfAspect=0;
		if (personalOrPerformanceData==1) {
			if (columnNumber==1) 
				positionOfAspect=4;
			else if (columnNumber==2)
				positionOfAspect=40;
			else if (columnNumber==3)
				positionOfAspect=44;
			else if(columnNumber==4)
				positionOfAspect=88;
			else if(columnNumber==5)		
				positionOfAspect=92;
			else if(columnNumber==6)
				positionOfAspect=96;			
		}
		
		else if (personalOrPerformanceData==2) {
			if (columnNumber==1) 
				positionOfAspect=4;
			else if (columnNumber==2)
				positionOfAspect=40;
			else if (columnNumber==3)
				positionOfAspect=100;
			else if(columnNumber==4)
				positionOfAspect=104;
			else if(columnNumber==5)		
				positionOfAspect=112;
			else if(columnNumber==6)
				positionOfAspect=120;
		}
		return positionOfAspect;
	}
	
	/*This method returns the type of the field being edited/sorted, where 
	 *String=1, int=2 and double=3. */
	int typeOfAspect(int personalOrPerformanceData, int columnNumber) {
		int typeOfAspect=0;
		if (personalOrPerformanceData==1) {
			if(columnNumber==1||columnNumber==3||columnNumber==5)	
				typeOfAspect=1; //String
			else if (columnNumber==2||columnNumber==4||columnNumber==6)
				typeOfAspect=2; //int
		}
		
		else if (personalOrPerformanceData==2) {
			if (columnNumber==1)	
				typeOfAspect=1; //String
			else if (columnNumber==2||columnNumber==3)
				typeOfAspect=2; //int
			else if(columnNumber==4||columnNumber==5||columnNumber==6)
				typeOfAspect=3; //double	
		}
		return typeOfAspect;
	}
	
	/*Returns the length of the String being edited, necessary when 
	 *reading/writing Strings to studentFile. */
	int lengthOfAspect(int columnNumber) {
		int lengthOfAspect=0;
		if (columnNumber==1)
			lengthOfAspect=18;
		else if (columnNumber==3)
			lengthOfAspect=22;
		else if (columnNumber==5)
			lengthOfAspect=2;
					
		return lengthOfAspect;
	}
	
	/*This method allows the user to add a new student record to 
	 *studentFile. */
	void newStudent() throws IOException {
		try {
			RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
			String name = new String(); /*The user-input name of the 
			new student. */
			int age; /*The user-input age of the new student. */
			String address; /*The user-input address of the new student. */
			int perceivedRacingLevel; /*The user-input perceived racing level 
			of the new student. */
		
			int count = countRecords(); /*The number of records 
			(all the students) in the studentFile. */
			
			Scanner input = new Scanner (System.in);
			Validator validator = new Validator();
			System.out.println("Please enter the student's name:");
			name = input.nextLine();
			System.out.println("\nPlease enter the student's age:");
			age = validator.getAndValidateInt(1,100); /*A reasonable upper 
			limit for age is 100 years old. */
			System.out.println("\nPlease enter the student's address:");
			address = input.nextLine();
			System.out.println("\nPlease enter the student's perceived racing level:");
			perceivedRacingLevel = validator.getAndValidateInt(1,10); 	
			Student student = new Student (name, age, address, perceivedRacingLevel); 
			/*Create a new Student object with all the user-input data.. */
			
			studentFile.seek(count*128+0); /*Using the seek() method, go to 
			'count'*128 because count-1 represents the last record in the file, 
			so this new record would have a record number of 'count'. */
			
			studentFile.writeInt(getLastStudentRecordId()+1); /*Write the ID 
			number of the student as the last ID of a record in the 
			studentFile+1. */
			studentFile.seek(count*128+4);
			FixedLengthStringIO.writeFixedLengthString (student.getName(), 18, studentFile);
			studentFile.seek(count*128+40);
			studentFile.writeInt (student.getAge());
			studentFile.seek(count*128+44);
			FixedLengthStringIO.writeFixedLengthString (student.getAddress(), 22, studentFile);
			studentFile.seek(count*128+88);
			studentFile.writeInt(0); /*Classes taught is initially 0.*/
			String whichGroup = groupDecider(age); /*This method generates a 
			group (eg- T1, T2, C1) to put the new student in, and returns 
			this String to whichGroup.*/
			
			studentFile.seek(count*128+92);
			FixedLengthStringIO.writeFixedLengthString (whichGroup, 2, studentFile);
			studentFile.seek(count*128+96);
			studentFile.writeInt(0); /*Fees paid is initially 0.*/
			studentFile.seek(count*128+100);
			studentFile.writeInt(student.getRacingLevel());
			studentFile.seek(count*128+104);
			studentFile.writeDouble(0); /*Average lap time is initially 0.*/
			studentFile.seek(count*128+112);
			studentFile.writeDouble(0); /*Average lap time is initially 0.*/
			studentFile.seek(count*128+120);
			studentFile.writeDouble(0); /*Average lap time is initially 0.*/
			
			System.out.println("\nYour student record has been created:\n");
			displayRecordAllData(count);/*Display newly made student record. */
			studentFile.close();
			System.out.println("\nPress 1 to create another student record or press 2 to exit to the main menu.");
			int menu = validator.getAndValidateInt(1,2);
			if (menu==1)
				newStudent();
		}
		catch (FileNotFoundException e) {
			System.out.println("The requested file cannot be found. Please try again.");
		}
		catch (IOException e) {
			System.out.println("An unexpected I/O error has occured. Please try again.\nThe exact reason for this is: " + e.getMessage());
		}	
	}
	
	/*Returns a string which is the groupName that a particular age belongs to. 
	 *Automatically assigns a non-full group (which does not have more than 10 
	 *people already).*/
	String groupDecider(int age) throws IOException {
		String groupName = new String(); /*The new automatically-generated 
		groupName to be returned.*/
		
		/*Assigning the right age group (C, T or A), but the first group 
		 *(which may be full in reality).*/
		if (age<13) 
			groupName="C1";
		else if (age<18) 
			groupName="T1";
		else 
			groupName="A1";
			
		boolean isThereSpace = false; /*Whether or not there is space in 
		the currently assigned group.*/
		
		int groupNumber = 1; /*The group number that is currently assigned 
		(so C2 would mean groupNumber =2). */
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		
		/*This loop checks if there is space in the currently assigned group. 
		 *If not, the groupNumber is incremented and the loop is executed 
		 *again till a group with space is found.*/
		while (!isThereSpace) {
			
			int count = 0; /*The number of students in the currently 
			assigned group.*/
			
			for (int i=0; i<countRecords(); i++) {
				studentFile.seek(i*128+92);
				if ((FixedLengthStringIO.readFixedLengthString(2, studentFile)).equals(groupName)) 
					count++;
			}
			
			/*If the currently assigned group is full.*/
			if (count>10) {
				groupNumber++;
				groupName = groupName.substring(0,1);
				groupName = groupName.concat(Integer.toString(groupNumber)); 
				/*Concatenate the new groupNumber to the groupName.*/
			}
			else
				isThereSpace = true;
		}	
		
		studentFile.close();
		return groupName;		
	}
	
	//Returns the ID of the last student record in the studentFile.
	int getLastStudentRecordId() throws IOException {
		int lastStudentId; /*The ID number of the last student record.*/
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int studentCount = countRecords(); /*The number of records (all the 
		students) in the studentFile.*/
		studentFile.seek((studentCount-1)*128+0);
		lastStudentId = studentFile.readInt();
		return lastStudentId;
	}
	
	/*Returns the ID of the last racer record in the teamFile. 
	 *Follows the same logic as the above method. */
	int getLastTeamRecordId() throws IOException {
		int lastTeamId;
		RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
		int teamCount = countTeamRecords();
		teamFile.seek((teamCount-1)*84+0);
		lastTeamId = teamFile.readInt();
		return lastTeamId;
	}
	
	/*This methods counts the current number of records in the 
	 *studentFile.dat, and returns this value to the calling method.*/
	int countRecords() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int records = (int)(studentFile.length()/128); /*Number of 
		records in the studentFile.*/
		studentFile.close();
		return records;
	}
	
	/*Displays the personal data of all the records in the studentFile.*/
	void displayAllRecordsPersonalData() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int count = countRecords(); /*The number of records (all the students) 
		in the studentFile.*/
		System.out.printf("%-4s%-18s%-5s%-22s%-9s%-12s%-5s\n\n", "ID", "Student Name", "Age", "Address","Classes", "Group Name", "Fees Paid");
		
		/*This loop stores the data of an individual record in a Student 
		 *object, then displays it using the in-build method in Student that is 
		 *displayRecordPersonalData(). */
		for (int record=0; record<count; record++) {
			Student student = new Student();
			studentFile.seek(record*128+0); 
			student.setId(studentFile.readInt()); 
			studentFile.seek(record*128+4);
			student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
			studentFile.seek(record*128+40);
			student.setAge(studentFile.readInt());
			studentFile.seek(record*128+44);
			student.setAddress(FixedLengthStringIO.readFixedLengthString(22, studentFile));
			studentFile.seek(record*128+88);
			student.setClassesTaught(studentFile.readInt()); 
			studentFile.seek(record*128+92);
			student.setGroupName(FixedLengthStringIO.readFixedLengthString(2, studentFile));
			studentFile.seek(record*128+96);
			student.setFeesPaid(studentFile.readInt()); 
			
			student.displayRecordPersonalData();
		}
		studentFile.close();
	}
	
	/*Displays the performance data of all the records in the studentFile.*/
	void displayAllRecordsPerformanceData() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int count = countRecords();
		System.out.printf("%-4s%-18s%-5s%-15s%-12s%-12s%-12s\n\n", "ID", "Student Name", "Age", "Racing Level", "Avg. 400m", "Avg. 800m", "Avg. 1000m");
		
		for (int record=0; record<count; record++) {
			Student student = new Student();
			studentFile.seek(record*128+0); 
			student.setId(studentFile.readInt()); 
			studentFile.seek(record*128+4);
			student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
			studentFile.seek(record*128+40);
			student.setAge(studentFile.readInt());
			studentFile.seek(record*128+100);
			student.setRacingLevel(studentFile.readInt()); 
			studentFile.seek(record*128+104);
			student.setAverage400(studentFile.readDouble()); 
			studentFile.seek(record*128+112);
			student.setAverage800(studentFile.readDouble());
			studentFile.seek(record*128+120);
			student.setAverage1000(studentFile.readDouble());
			
			student.displayRecordPerformanceData();
		}
		studentFile.close();
	}
	
	/*Displays all the data of a chosen record in the studentFile.*/
	void displayRecordAllData(int record) throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		Student student = new Student();
		
		studentFile.seek(record*128+0); 
		student.setId(studentFile.readInt()); 
		studentFile.seek(record*128+4);
		student.setName(FixedLengthStringIO.readFixedLengthString(18, studentFile));
		studentFile.seek(record*128+40);
		student.setAge(studentFile.readInt());
		studentFile.seek(record*128+44);
		student.setAddress(FixedLengthStringIO.readFixedLengthString(22, studentFile));
		studentFile.seek(record*128+88);
		student.setClassesTaught(studentFile.readInt()); 
		studentFile.seek(record*128+92);
		student.setGroupName(FixedLengthStringIO.readFixedLengthString(2, studentFile));
		studentFile.seek(record*128+96);
		student.setFeesPaid(studentFile.readInt()); 
		studentFile.seek(record*128+100);
		student.setRacingLevel(studentFile.readInt()); 
		studentFile.seek(record*128+104);
		student.setAverage400(studentFile.readDouble()); 
		studentFile.seek(record*128+112);
		student.setAverage800(studentFile.readDouble());
		studentFile.seek(record*128+120);
		student.setAverage1000(studentFile.readDouble());
		
		student.displayRecordAllData();
		studentFile.close();
	}
}