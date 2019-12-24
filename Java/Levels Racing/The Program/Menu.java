/* This is Menu.java, which acts as the menu of the program. It is the only 
 *class that is not instantiated. Created by Naval Handa, on 24.02.2013, 
 *Emirates International School Meadows. Made on a Sony Vaio E-Series 
 *(VPCEB46FG) using JCreator. */

import java.util.Scanner;
import java.io.*;

class Menu {
	//The main method of the entire LevelsRacing program.
	public static void main (String args[]) throws IOException {
		System.out.println("\n\t\t\t\tLevels Racing\n");
		line();
		boolean continueLoop = password(); /*The password() method is called, 
		and it returns either a true or false, depending on whether the password 
		entered was correct within the given number of tries. */
		line();
		
		//If password is correct:
		if (continueLoop) {
			System.out.println("\tWelcome, Mr Hayfield, to the Levels Racing computer system.\n");
			int menu = -1; /*This variable indicates the choice of the user 
			throughout this particular module. All desired menu choices will be 
			stored here. -1 is the sentinel value for the menu variable, to 
			indicate that the program should be terminated. */
			
			displayMainMenu(); /*Display the choices of the main menu. This was 
			put in its own separate method to avoid repetition.*/
			
			Validator validator = new Validator();
			menu = validator.getAndValidateInt(1,6); /*Get an input from the 
			user to activate one of the main menu choices. The method 
			getAndValidateInt() is used throughout the program to accept input 
			of integer type.*/
			
			line();
			
			/*One of the 6 first menu choices will continue to be executed in 
			 *this loop until the user enters option 6 to exit the program.*/
			while (menu>=0&&menu<=6) {
				
				//Sub-menu 1.
				if (menu==1) {
					StudentFile studentFile = new StudentFile();
					System.out.println("1) Access student details:\n");
					System.out.println("1) Create a new student record.\n2) Edit student details.\n3) Sort students.\n4) Search for a particular student.\n5) Delete a student.\n6) View and edit teams.\n7) Exit sub-menu.");
					line();
			        menu = validator.getAndValidateInt(1,7);
			        line(); 

			        if (menu==1) {    	
			        	System.out.println("1) Create a new student record:\n");
			        	studentFile.newStudent(); /*A new student will be created. 
			        	If the user wants to run the method again, this is 
			        	handled through recursion in the newStudent() method. */
			        	
			        	line();
			        	menu=0; /*Menu is set to 0, which indicates to the 
			        	program that the main menu should be displayed again.*/
			        }
				        
				    else if (menu==2) {
				    	System.out.println("2) Edit student details:\n");
				    	studentFile.editStudent();
				    	line();
				    	menu=0;
				    }
						
					else if (menu==3) {
						System.out.println("3) Sort students:\n");
				    	studentFile.sortStudents();
				    	line();
				    	menu=0;
					}
						
					else if (menu==4) {
						System.out.println("4) Search for a particular student:\n");
						studentFile.searchStudent();
						line();
						menu=0;
					}
					
					else if (menu==5) {
						System.out.println("5) Delete a student:\n");
						studentFile.deleteStudent();
						line();
						menu=0;
					}
	
					else if (menu==6) {
						System.out.println("6) View and edit teams:\n");
						TeamFile teamFile = new TeamFile();
						teamFile.editTeams();
						line();
						menu=0;
					}
						               
					else if (menu==7) /*If the user wants to exit sub-menu 1, 
					then simply set menu to 0 to display the main menu again.*/
						menu=0;	  
				}
				
				//Sub-menu 2.
				else if (menu==2) {
					RatesFile ratesFile = new RatesFile();
					System.out.println("2) Check Fees Payment Details:\n");
					ratesFile.checkFeesStatus();
					line();
					menu=0;
				}                                
				
				//Sub-menu 3.
				else if (menu==3) {
					StudentFile studentFile = new StudentFile();
					System.out.println("3) Update classes taught and student lap times:\n");
					studentFile.updateClassesAndTimes();
					line();
					menu=0;
				}
				
				//Sub-menu 4.
				else if (menu==4) {
					TeamFile teamFile = new TeamFile();
					PastLapsFile pastLapsFile = new PastLapsFile();
					System.out.println("4) Student performance and team selection:\n");
					System.out.println("1) Generate performance graphs for students.\n2) Compare students' lap times with records and history.\n3) Pick teams for competition.\n4) Exit sub-menu.");
					line();
			        menu = validator.getAndValidateInt(1,4);
			        line();
			        if (menu==1) {
				        System.out.println("1) Generate performance graphs for students:\n");
			        	pastLapsFile.generatePerformanceGraph();
			        	line();
			        	menu=0;	
			        }

				    else if (menu==2) {
				    	System.out.println("2) Compare students' lap times with records and history:\n");
			        	pastLapsFile.compareLapTimes();
			        	line();
			        	menu=0;
				    }

					else if (menu==3) {
						System.out.println("3) Pick Teams for Competition:\n");
			        	teamFile.pickTeams();
			        	line();
			        	menu=0;
					}
					
					else if (menu==4)
						menu=0; 
				}
				
				//Sub-menu 5.
				else if (menu==5) {
					StudentFile studentFile = new StudentFile();
					TeamFile teamFile = new TeamFile();
					RatesFile ratesFile = new RatesFile();
					System.out.println("5) Produce Lists:\n");
					System.out.println("1) All students currently in the course.\n2) Current teams.\n3) Students who have overdue fees.\n4) Best students.\n5) Students not performing.\n6) Exit sub-menu.");
					line();
			        menu = validator.getAndValidateInt(1,6);
			        line(); 
					
					if (menu==1) {    	
			        	System.out.println("1) All students currently in the course:\n");
			        	studentFile.produceListAllStudents();
			        	line();
			        	menu=0;
			        }
				        
				    else if (menu==2) {
				    	System.out.println("2) Current teams:\n");
				    	teamFile.produceListCurrentTeams();
				    	line();
				    	menu=0;
				    }
						
					else if (menu==3) {
						System.out.println("3) Students who have overdue fees:\n");
				    	ratesFile.produceListOverdueStudents();
				    	line();
				    	menu=0;
					}
						
					else if (menu==4) {
						System.out.println("4) Best students:\n");
						studentFile.produceListBestStudents();
						line();
						menu=0;
					}
					
					else if (menu==5) {
						System.out.println("5) Students not performing:\n");
						studentFile.produceListStudentsNotPerforming();
						line();
						menu=0;
					}          
					
					else if (menu==6)
						menu=0;	 
				} 
				
				//Sub-menu 6 which exits the program.
				else if (menu==6) 
					menu=-1;
				
				
				/*After every method, menu is set to 0 to indicate that the 
				 *main menu should be displayed, and that the user should enter
				 * a number between 1-6 to enter one of the 6 sub-menus.*/
				else if (menu==0) {
					displayMainMenu();
					menu = validator.getAndValidateInt(1,6); 
					line();
				}	
			}
			//After exiting the main while loop by setting menu=-1.
			System.out.println("The program has now been exited and you have been logged out. Thank you.");
			line();
		}
		
		//If password is not correct:
		else {
			System.out.println("Sorry, try again tomorrow. You have been locked out of the system.");
			line();
		}
	}
	
	/*This method returns a true or false value, depending on the correctness of 
	 *the password entered by the user. It does not have any parameters.*/
	public static boolean password() throws IOException {
		RandomAccessFile ratesFile = new RandomAccessFile ("RatesFile.dat","rw");
		ratesFile.seek(12); /*The password of LevelsRacing is stored in the 12th 
		position of the ratesFile for secrecy. */
		
		String realPassword = FixedLengthStringIO.readFixedLengthString(15, ratesFile); 
		/*The password is read and stored in the realPassword variable.
		 *The fixedLengthStringIO is used to read and write data of String type
		 *to the RAF file, throughout the program. It is taken from 
		 *"Introduction to Java Programming" by Y. Daniel Liang.*/
		
		System.out.println("Enter the password of the system:");
		String password = new String(); /*This variable will store the 
		user-input password.*/
		
		Scanner input = new Scanner(System.in);
		password = input.nextLine();
		int tries=4; /*This variable stores the number of tries remaning for the 
		user to enter the correct password.*/
		
		/*This loop will only execute if the password is wrong AND the user 
		 *has tries remaining.*/
		while (!(password.equals(realPassword))&&tries>=1) { 
			System.out.println("You have " +tries+ " more tries.");
			tries--;
			password = input.nextLine();
		}
		
		ratesFile.close();	
		/*True only if the user got the right password within 5 tries.*/
		if (tries>=0&&password.equals(realPassword)) 
			return true;
		else
			return false;
	}
	
	/*Helper method to assist with the layout of the program. Leaves a space and 
	 *draws a line to help separate different sections of the program when 
	 *it is run.*/
	public static void line() {
		System.out.println("\n--------------------------------------------------------------------------------");
	}
	
	//This method displays the options of the main menu.
	public static void displayMainMenu() {
		System.out.println("Main Menu:\n");
		System.out.println("1) Access student details.\n\n2) Check fees payment details.\n\n3) Update classes taught and student lap times.");
		System.out.println("\n4) Student performance and team selection. \n\n5) Produce lists.\n\n6) Exit program.\n\nPlease choose an option from 1-6.");
		line();
	}
}