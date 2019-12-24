/* This is TeamFile.java, which handles the operations performed with the 
 *teamFile.dat, such as creating a new team. Created by Naval Handa, on 
 *24.02.2013, Emirates International School Meadows. Made on a Sony Vaio 
 *E-Series (VPCEB46FG) using JCreator. */

import java.io.*;
import java.util.Scanner;

class TeamFile {

	//Produces a list of all the students in a team (all the racers).
	void produceListCurrentTeams() throws IOException {
		displayAllTeamRecords();
		System.out.println("\nThe list has now been produced.");
	}
	
	/*This method executes the 'Edit Teams' option of the program, called by the 
	 *Menu class. Allows the user to edit the current teams of Levels Racing.*/
	void editTeams() throws IOException {
		try {
			RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
			RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
			displayAllTeamRecords();/*Display all the records in the teamFile 
			(all the racers) to show the user which records he can edit.*/
			
			Validator validator = new Validator();
			System.out.println("Would you like to delete a student from a team (1) or add a new student to a team (2)?");
			int addOrDelete = validator.getAndValidateInt(1,2);  /*Whether the 
			user wishes to add or delete a student, 
			where Delete = 1 and Add = 2. */
			
			Scanner input = new Scanner (System.in);
			int teamCount = countTeamRecords(); /*The number of racers 
			(the number of records in the teamFile).*/
			
			//If the user wants to delete a student:
			if (addOrDelete==1) {
				System.out.println("\nEnter the ID of the student you would like to delete from a team:");
				int desiredId = validator.getAndValidateInt(1,getLastTeamRecordId()); 
				/*The ID number the user entered of the student he wishes to 
				 *delete.*/
				
				int record; /*The number of the record to be deleted, which can 
				be different to the student's ID number.*/
				
				boolean recordFound = false; /*Whether or not the record has 
				been found yet.*/
				
				/*The loop should keep searching till either the record is found 
				 *or the end of the teamFile is reached.*/
				for (record=0; !recordFound && record<teamCount; record++) {
					teamFile.seek(record*84+0);
					if (desiredId == teamFile.readInt()) 
						recordFound = true;
				}
				/*If the record was found, the 'record' variable is currently 
				 *one ahead of the actual record number. For example, if the 
				 *user wished to delete record number 1 (which is referred to 
				 *in-file as record 0), then 'record' would have a value of 1.*/
				
				if (!recordFound) 
					System.out.println("Sorry, the desired student does not belong to a team.");
				
				else {
					Racer racer = new Racer(); /*Create a Racer object to store 
					all the data that will be shuffled.*/
					
					for (int i=record; i<teamCount; i++) { 
					
						teamFile.seek(i*84+0); /*It seeks the record ahead of 
						t						he one to be deleted (when i=record).*/
						
						racer.setId(teamFile.readInt()); /*Then reads the data 
						of its first field.*/
						
						teamFile.seek((i-1)*84+0); /*Seeks the previous record.*/
						
						teamFile.writeInt(racer.getId()); /*Then replaces that 
						record's data with the new data.*/
						
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
					
					teamFile.setLength(teamFile.length()-84); /*Reduce the file 
					length by one record size.*/
					System.out.println("The desired student has been deleted from the team.");
				}
			}
			
			//If the user wants to add a new record to the teamFile:
			else if (addOrDelete==2) {
				System.out.println("\nEnter the name of the team you would like to add a student to:");
				String desiredTeamName = input.nextLine(); /*The user-input name
				 of the team he would like to add a student to.*/
				System.out.println();
				boolean teamExists = false; /*Whether or not the team exists in 
				the teamFile.*/
				
				int ageLimitOfTeam=0; /*Represents what the age limit of the 
				desired team is. '1' represents an Under 18 team, while '2' is 
				an Adult team.*/
				int studentCount = countRecords(); /*Number of records in 
				the studentFile.*/
				
				/*This loop confirms the team exists and then finds out the age 
				 *group of that team (for validation purposes later).*/
				for (int i=0; !teamExists && i<teamCount; i++) {
					teamFile.seek(i*84+44);
					if (desiredTeamName.equals(FixedLengthStringIO.readFixedLengthString(20, teamFile).trim())) {
						teamExists = true;
						teamFile.seek(i*84+0);
						int idToFindAge = teamFile.readInt(); /*The ID of a 
						Racer that belongs to the team that the user entered. 
						This ID is used to find the racer's record in the 
						studentFile, where his age can be checked to find out 
						the age limit of the team.*/
						
						boolean racerFound = false; /*Whether the racer has 
						been found in the studentFile.*/
						
						for (int j=0; !racerFound; j++) {
							studentFile.seek(j*128+0);
							/*If the ID of the racer matches the student record 
							 *in the file, read that student's age and assign a 
							 *value to the 'ageLimitOfTeam' variable. */
							 
							if (idToFindAge== studentFile.readInt()) {
								racerFound = true;
								studentFile.seek(j*128+40);
								ageLimitOfTeam = studentFile.readInt();
								if (ageLimitOfTeam<18)
									ageLimitOfTeam = 1; /*Signifies an Under 
									18 team.*/
								else if (ageLimitOfTeam>=18)
									ageLimitOfTeam = 2; /*Signifies an Adult 
									team.*/
							}
						}
					}	
				}
				
				if (!teamExists) 
					System.out.println("Sorry, the desired team does not exist.");
				
				else {
					System.out.printf("%-4s%-18s%-5s%-15s%-12s%-12s%-12s\n\n", "ID", "Student Name", "Age", "Racing Level", "Avg. 400m", "Avg. 800m", "Avg. 1000m");
					/*Either of these if-else statements will print a list of 
					 *all the age-suitable possible candidates for the team, 
					 *displayed from the studentFile.*/
					if (ageLimitOfTeam==1) {
						for (int i=0;i<studentCount; i++) {
							studentFile.seek(i*128+40);
							if (studentFile.readInt()<18)
								displayRecordPerformanceData(i);
						}
					}	
					else if (ageLimitOfTeam==2) {
						for (int i=0;i<studentCount; i++) {
							studentFile.seek(i*128+40);
							if (studentFile.readInt()>=18)
								displayRecordPerformanceData(i);
						}
					}
				
					System.out.println("Please enter the ID of the student you would like to add to this team:");
					int desiredId = validator.getAndValidateInt(1, getLastStudentRecordId()); 
					/*The user-input ID number of the student to be added to 
					 *the team. */
					
					
					boolean recordFoundAndValid = false; /*This variable will be 
					true only if the user-input ID (and hence record) passes 
					all the following validation checks. */
					
					int desiredRecord; /*The number of the student record 
					which the user wants to add to the team.*/
					
					/*The following 'block' of code validates "desiredId" to 
					 *ensure it exists, is not assigned to a team, and is of 
					 *the right age.*/
					
					/*This first check is a loop that checks if the desiredId 
					 *exists in studentFile.*/
					for (desiredRecord=0; !recordFoundAndValid && desiredRecord<studentCount; desiredRecord++) {
						studentFile.seek(desiredRecord*128+0);
						if (studentFile.readInt()==desiredId)
							recordFoundAndValid=true;
					}
					desiredRecord--;
					if (!recordFoundAndValid) 
						System.out.println("The desired record could not be found, please enter the ID again:");
					
					/*If the desiredId record exists, the second 'part' of 
					 *this validation process is executed.*/
					else if (recordFoundAndValid) {
						/*This second loop checks to ensure desiredId does not 
						 *already exist in teamFile.*/
						for (int i=0; i<teamCount; i++) {
							teamFile.seek(i*84+0);
							if (desiredId==teamFile.readInt()) {
								System.out.println("Sorry, this student already is assigned to a team.");
								recordFoundAndValid=false;			
							}
						}
						
						/*This third check is a collection of if statements to 
						 *ensure record is of the right age.*/
						studentFile.seek(desiredRecord*128+40);
						if (ageLimitOfTeam==1) {
							if (studentFile.readInt()>=18) { 
								System.out.println("Sorry, this student is 18 years or older.");
								recordFoundAndValid=false;
							}
						}
						else if (ageLimitOfTeam==2){
							if (studentFile.readInt()<18) { 
								System.out.println("Sorry, this student is under 18 years old.");
								recordFoundAndValid=false;
							}
						}
					}		
					
					/*If the desired record has passed all the 
					 *validation tests:*/
					if (recordFoundAndValid) {
						int id = desiredId;
						studentFile.seek(desiredRecord*128+4);
						String name = FixedLengthStringIO.readFixedLengthString(18, studentFile);
						studentFile.seek(desiredRecord*128+100);
						int racingLevel = studentFile.readInt();
						Racer racer = new Racer (id, name, racingLevel, desiredTeamName);
			
						teamFile.seek(teamCount*84+0);
						teamFile.writeInt(racer.getId());
						teamFile.seek(teamCount*84+4);
						FixedLengthStringIO.writeFixedLengthString (racer.getName(), 18, teamFile);
						teamFile.seek(teamCount*84+40);
						teamFile.writeInt (racer.getRacingLevel());
						teamFile.seek(teamCount*84+44);
						FixedLengthStringIO.writeFixedLengthString (racer.getTeamName(), 20, teamFile);
						System.out.println("The student has been successfully added to the " +desiredTeamName +" team.");
					}	
				}
			}
			
			teamFile.close();
			studentFile.close();
			System.out.println("\nPress 1 to edit another team or press 2 to exit to the main menu.");
			int menu = validator.getAndValidateInt(1,2); /*Menu choice of the 
			user, where 1 is to edit another team and 2 is to exit to the main 
			menu. */
			if (menu==1)
				editTeams();
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
	
	void displayAllTeamRecords() throws IOException {
		RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
		int teamCount = countTeamRecords(); /*Number of records (all the racers) 
		in the teamFile.*/
		System.out.printf("%-4s%-18s%-15s%-20s\n\n", "ID", "Student Name", "Racing Level", "Team Name");
		
		for (int record=0; record<teamCount; record++) {
			Racer racer = new Racer(); /*A Racer object will store the data of 
			the record to be displayed.*/
			teamFile.seek(record*84+0); 
			racer.setId(teamFile.readInt()); 
			teamFile.seek(record*84+4);
			racer.setName(FixedLengthStringIO.readFixedLengthString(18, teamFile));
			teamFile.seek(record*84+40);
			racer.setRacingLevel(teamFile.readInt());
			teamFile.seek(record*84+44);
			racer.setTeamName(FixedLengthStringIO.readFixedLengthString(20, teamFile));
			
			racer.displayRecordAllData(); /*The in-built method in the Racer 
			object to display all its data. Overrides the method of the same 
			name in the Student class that the Racer class inherits all its 
			methods from: an example of Polymorphism.*/
		}
		teamFile.close();
	}
	
	void pickTeams() throws IOException {
		Validator validator = new Validator();
		RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		System.out.println ("Enter 1 to make an Under 18 team or 2 to make an Adult team:");
		int desiredAge = validator.getAndValidateInt(1,2); /*What is the age 
		group of the team to be made: 1 represents Under 18, while 2 represents 
		an Adult team. */
		Scanner input = new Scanner (System.in);
		int studentCount = countRecords(); /*Number of records (all the students) 
		in the studentFile.*/
		int teamCount = countTeamRecords(); /*Number of records (all the racers) 
		in the teamFile.*/
		
		System.out.println();
		System.out.printf("%-4s%-18s%-5s%-15s%-12s%-12s%-12s\n\n", "ID", "Student Name", "Age", "Racing Level", "Avg. 400m", "Avg. 800m", "Avg. 1000m");
		//Display all the students within the desired age group.
		if (desiredAge==1) {
			for (int i=0;i<studentCount; i++) {
				studentFile.seek(i*128+40);
				if (studentFile.readInt()<18)
					displayRecordPerformanceData(i);
			}
		}	
		
		else if (desiredAge==2) {
			for (int i=0;i<studentCount; i++) {
				studentFile.seek(i*128+40);
				if (studentFile.readInt()>=18)
					displayRecordPerformanceData(i);
			}
		}
		
		System.out.println("Enter the name of the new team:");
		String teamName = input.nextLine(); /*The user-input name of the new 
		team to be made.*/
		
		System.out.println("\nEnter the ID of the student you would like to include in this team:");
		
		int desiredId = validator.getAndValidateInt(1, getLastStudentRecordId()); 
		/*The ID of the student to be added to the team.*/
		
		boolean recordFoundAndValid=false; /*This variable will be true only 
		if the user-input ID (and hence record) passes all the following 
		validation checks. */
		
		int desiredRecord=-1; /* The number of the student record to be added 
		to the team. Has to be initialised, so a suitable value is -1. */
		
		/*/This while loop keeps executing to add a new student to a team as 
		 *many times as the user desires, until the user enters -1 to break 
		 *the loop.*/
		while (desiredId!=-1) { 
			recordFoundAndValid=false;
			 
			/*This loop validates "desiredId" to ensure it exists, is not 
			 *assigned to a team, and is of the right age. Follows the same 
			 *logic as the 'block' of code that has the same purpose in 
			 *editTeams().*/
			while (!recordFoundAndValid) { 	
				for (desiredRecord=0; !recordFoundAndValid && desiredRecord<studentCount; desiredRecord++) {
					studentFile.seek(desiredRecord*128+0);
					if (studentFile.readInt()==desiredId)
						recordFoundAndValid=true;
				}
				desiredRecord--;
				if (!recordFoundAndValid) {
					System.out.println("The desired record could not be found, please enter the ID again:");
					desiredId = validator.getAndValidateInt(1, getLastStudentRecordId()); 
				}
				
				else if (recordFoundAndValid) {
					for (int i=0; i<teamCount; i++) {
						teamFile.seek(i*84+0);
						if (desiredId==teamFile.readInt()) {
							System.out.println("Sorry, this student already is assigned to a team. Please enter another student ID:");
							recordFoundAndValid=false;
							desiredId = validator.getAndValidateInt(1, getLastStudentRecordId());
						}
					}
					
					studentFile.seek(desiredRecord*128+40);
					if (desiredAge==1) {
						if (studentFile.readInt()>=18) { 
							System.out.println("Sorry, this student is 18 years or older. Please enter another student ID:");
							recordFoundAndValid=false;
							desiredId = validator.getAndValidateInt(1, getLastStudentRecordId());
						}
					}
					else if (desiredAge==2){
						if (studentFile.readInt()<18) { 
							System.out.println("Sorry, this student is under 18 years old. Please enter another student ID:");
							recordFoundAndValid=false;
							desiredId = validator.getAndValidateInt(1, getLastStudentRecordId());
						}
					}
				}		
			}
			
			int id = desiredId;
			studentFile.seek(desiredRecord*128+4);
			String name = FixedLengthStringIO.readFixedLengthString(18, studentFile);
			studentFile.seek(desiredRecord*128+100);
			int racingLevel = studentFile.readInt();
			Racer racer = new Racer (id, name, racingLevel, teamName);
			teamCount = countTeamRecords();

			teamFile.seek(teamCount*84+0);
			teamFile.writeInt(racer.getId());
			teamFile.seek(teamCount*84+4);
			FixedLengthStringIO.writeFixedLengthString (racer.getName(), 18, teamFile);
			teamFile.seek(teamCount*84+40);
			teamFile.writeInt (racer.getRacingLevel());
			teamFile.seek(teamCount*84+44);
			FixedLengthStringIO.writeFixedLengthString (racer.getTeamName(), 20, teamFile);
			
			teamCount = countTeamRecords(); /*Number of records (all the racers) 
			in the teamFile.*/
			System.out.println("\nThe current team is:\n");
			/*Displays all the students currently in the team being made.*/
			for (int i=0; i<teamCount; i++) {
				teamFile.seek(i*84+44);
				if (teamName.equals(FixedLengthStringIO.readFixedLengthString(20, teamFile).trim())) {
					teamFile.seek(i*84+4);
					System.out.println(FixedLengthStringIO.readFixedLengthString(18, teamFile));
				}
			}	
			System.out.println("\nEnter the ID of the student you would like to add to this team, or enter -1 finish making and save this team:");
			desiredId = validator.getAndValidateInt(-1, getLastStudentRecordId());
		}	
		
		teamFile.close();
		studentFile.close();
		System.out.println("\nPress 1 to create another team or press 2 to exit to the main menu.");
		int menu = validator.getAndValidateInt(1,2); 
		if (menu==1)
			pickTeams();
	}
	
	//Returns the ID of the last student record in the studentFile.
	int getLastStudentRecordId() throws IOException {
		int lastStudentId; /*The ID number to be returned, of the last student 
		record. */
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int studentCount = countRecords(); /*Number of records (all the students) 
		in the studentFile.*/
		studentFile.seek((studentCount-1)*128+0); /*(studentCount-1) is used 
		because record numbers start from 0 in the file itself.*/
		lastStudentId = studentFile.readInt();
		return lastStudentId;
	}
	
	/*Returns the ID of the last racer record in the teamFile. Follows the same 
	 *logic as the above method. */
	int getLastTeamRecordId() throws IOException {
		int lastTeamId;
		RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
		int teamCount = countTeamRecords();
		teamFile.seek((teamCount-1)*84+0);
		lastTeamId = teamFile.readInt();
		return lastTeamId;
	}
	
	/*This methods counts the current number of records in the studentFile.dat, 
	 *and returns this value to the calling method.*/
	int countRecords() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int records = (int)(studentFile.length()/128);
		studentFile.close();
		return records;
	}
	
	/*This methods counts the current number of records in the teamFile.dat, 
	 *and returns this value to the calling method.*/
	int countTeamRecords() throws IOException {
		RandomAccessFile teamFile = new RandomAccessFile ("teamFile.dat","rw");
		int records = (int)(teamFile.length()/84);
		teamFile.close();
		return records;
	}
	
	/*Displays the performance data of the passed record number.*/
	void displayRecordPerformanceData(int record) throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
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
		studentFile.close();
	}
}