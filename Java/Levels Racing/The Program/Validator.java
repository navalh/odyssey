/* This is Validator.java, which validates both int and double type data 
 *supplied by other classes. Created by Naval Handa, on 24.02.2013, Emirates 
 *International School Meadows. Made on a Sony Vaio E-Series (VPCEB46FG) using 
 *JCreator. */

import java.util.*;
import java.io.*;

class Validator {
	
	/*This method handles the input for all data of int type in the 
	 *LevelsRacing program.*/
	int getAndValidateInt (int lowerLimit, int upperLimit) {
		int userInput=0; /*This variable has to be initiated, 
		so a reasonable value is 0. */
		
		/*It will store the value to be returned to the calling method, that 
		 *is validated for both range and type. Try this block: if the wrong 
		 *type is entered, execute the catch block.*/
		try {
			Scanner input = new Scanner (System.in);
			userInput = input.nextInt();
			
			/*This loops will execute if the data is out of the provided range, 
			 *and will break only when data of the correct range has 
			 *been entered.*/
			while (userInput<lowerLimit || userInput>upperLimit) {
				System.out.println ("\nSorry, please enter an integer between " +lowerLimit +" and " +upperLimit +":");
				userInput = input.nextInt();
			}
		}
		
		/*The catch block executes if the try block fails. It prints an error 
		 *message, and recursively calls the method again. This ensures the 
		 *method will continue to be called until data of the correct type 
		 *is entered. */
		catch (InputMismatchException e) {
			System.out.println ("\nSorry, please enter data of integer type:");
			userInput = getAndValidateInt (lowerLimit, upperLimit);
		}
		
		return userInput; /*Return the userInput that is now both valid in 
		range and type.*/
	}
	
	/*This method follows the same logic as getAndValidateInt(), 
	 *but is for data of double type.*/
	double getAndValidateDouble (double lowerLimit, double upperLimit) {
		double userInput=0;
		try {
			Scanner input = new Scanner (System.in);
			userInput = input.nextDouble();
			while (userInput<lowerLimit || userInput>upperLimit) {
				System.out.println ("\nSorry, please enter an integer between " +lowerLimit +" and " +upperLimit +":");
				userInput = input.nextDouble();
			}
		}
		catch (InputMismatchException e) {
			System.out.println ("\nSorry, please enter data of double type:");
			userInput = getAndValidateDouble (lowerLimit, upperLimit);
		}
		return userInput;
	}
}