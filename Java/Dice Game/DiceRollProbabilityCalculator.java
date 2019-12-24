/*This program, DiceRollProbabilityCalculator.java, was written by Naval Handa, Emirates International School Meadows, on 28.02.13.
It was written using JCreator and calculates the probability of both Ann and Bob winning, given the values of x and y (how many dice rolls 
they each have, respectively).*/

import java.util.Scanner;

class DiceRollProbabilityCalculator {
	//Limitation of program: Only capable of up to 7+1 dice rolls, or 4+5 dice rolls, i.e. denominator can only be up to 6^9. 
	
	static int annProbabilityNumerator; //Will contain the numerator of the probability that Ann wins the particular case of the dice game.
	static int bobProbabilityNumerator;//Will contain the numerator of the probability that Bob wins the particular case of the dice game.
	static int probabilityDenominator;//Will contain the denominator of the probability that Ann or Bob wins the particular case of the dice game.
	//This value will always be 6^(x+y).
	
	static int annDiceRolls; //Number of dice rolls that Ann has in this particular case of the dice game.
	static int bobDiceRolls; //Number of dice rolls that Bob has in this particular case of the dice game.
	
	static int[] annPermutations; //This array will contain all of Ann's outcomes. 
			//For example, if Ann has 2 dice rolls, she will have 6 X 6 = 36 dice rolls, which will also be the length of this array.
			//After the program populates this array with every outcome, it will then replace every outcome with the highest number that Ann rolled.
			//So, for example, if the array had stored the outcomes 11, 23, 61, 15: these would be replaced by 1, 3, 6 and 5 respectively.
	static int[] bobPermutations; //This array will contain all of Bob's outcomes.
	
	static int currentAnnDivision; //Used to help populate the annPermutations array that stores all her outcomes.
	static int currentBobDivision; //Used to help populate the bobPermutations array that stores all his outcomes.
	
	static boolean continueLoop = true; //A variable used to help continue the program for ease of use.
	
	public static void main (String args[]) {
		while (continueLoop) {
			Scanner input = new Scanner (System.in);
			System.out.println("\nEnter the number of dice rolls Ann has:");
			annDiceRolls = input.nextInt();
			System.out.println("Enter the number of dice rolls Bob has:");
			bobDiceRolls = input.nextInt();
			
			annPermutations = new int[(int)Math.pow(6,annDiceRolls)]; 
			bobPermutations = new int[(int)Math.pow(6, bobDiceRolls)]; 
			
			currentAnnDivision = (annPermutations.length);
			currentBobDivision = (bobPermutations.length);	
			
			
			//The following series of four nested loops populates the annPermutations array with every possible outcome, 
			//depending on how many dice rolls Ann has. In essence, this is what happens:
			//The outermost loop executes as many times as Ann rolls her dice. 
			
			//The easier explanation follows if we consider the case when Ann rolls twice.
			//The length of the array will be 36. The outermost loop will run twice.
			//In the first run of the outermost loop, currentAnnDivision is 6. So the array will be 'imagined' as up split up int 6 equal parts, or blocks.
			//So there are now 6 blocks, each of which are 6 units long. 
			//The loop will fill every block with 10, 20, 30... till 60, each of which it will do 6 times.
			//It can be considered as if there is a 'superblock' made of 6 blocks, hence with a size of 36, that the loop fills with 10-60.
			//So, after the execution of the first loop, the array looks like:
			//10,10,10,10,10,10, 20,20,20,20,20,20, 30,30,30,30,30,30, 40,40,40,40,40,40,40, 50,50,50,50,50,50, 60,60,60,60,60,60.
			//The second time the loop runs, the array will be split into 36 equal blocks, each 1 unit long.
			//Hence currentAnnDivision is 1.
			//The 'superblock' is 6 blocks, and so in this case will be 6 units long.
			//It will then fill 1-6 in each superblock, and repeat this process 6 times.
			//The array will now be:
			//11,12,13,14,15,16, 21,22,23,24,25,26, 31,32,33,34,35,36, 41,42,43,44,45,46, 51,52,53,54,55,56, 61,62,63,64,65,66.
			//Hence the array now contains all of Ann's outcomes when she rolls twice.
			
			
			//Consider the case when she rolls thrice. Beware that this is much more complicated to explain, but essentially the same process is followed.
			//In this case, the length of the array will be 216.
			//In the first run of the outermost loop, currentAnnDivision will be 36. So the array will 'split' up the array into 6 blocks, each with a size of 36.
			//Hence the 'superblock' is currently 216 units big.
			//In each of these '36' sized blocks, the array will be filled with 100, 100, 100... 36 times, then it will 
			//be filled with 200, 200, 200... 36 times.
			//So after the first loop, the array will look like:
			//100,100,100...(36 100s), 200, 200...(36 200s), 300... (36 300s), 400... (36 400s), 500... (36 500s), 600...(36 600s)
			//In the second run, it will consider each of these '36' blocks as its own superblock, and apply the same process.
			//currentAnnDivision becomes 6, so there are now 36 '6' sized blocks the loop is considering.
			//It will add 10 6 times, 20 6 times, 30 6 times, and so on.
			//So those 36 100s will now look like:
			//110, 110, 110.... (6 110s), 120, 120, 120 (6 120s)..., 130, 130 (6 130s)... until 160, 160, 160 (6 160s).
			//Then it will do this to the 200s, then the 300s, and so on.
			//The third and last execution of the outer loop will consider each member of the array now.
			//The size of the superblock is 6, so it will add 1-6 to every superblock. Since there are now 36 superblocks,
			//It will do this process 36 times.
			//currentAnnDivision becomes 1. So, it will add 1 once, 2 once, 3 once... till 6, and then repeat this process 36 times.
			//So, the array will now have 111, 112, 113, 114, 115, 116, 121, 122, etc.
			//Every outcome has now been generated in the array.
			
			for (int a=0; a<annDiceRolls; a++) { 
				currentAnnDivision = (int)(currentAnnDivision)/6;
				for (int h=0; h<(int)Math.pow(6,a); h++) {
					for (int i=0; i<6; i++) {
						for (int j=0; j<currentAnnDivision; j++) 
							annPermutations[(h*(int)Math.pow(6,annDiceRolls-a))+(i*currentAnnDivision)+j] += (i+1)*((int)Math.pow(10, annDiceRolls-(a+1)));
					}
				}
			}
			
			//This loop populates the bobPermutations array with all of his outcomes, depending on how many times he rolls his die.
			for (int a=0; a<bobDiceRolls; a++) {
				currentBobDivision = (int)(currentBobDivision)/6;
				for (int h=0; h<(int)Math.pow(6,a); h++) {
					for (int i=0; i<6; i++) {
						for (int j=0; j<currentBobDivision; j++) 
							bobPermutations[(h*(int)Math.pow(6,bobDiceRolls-a))+(i*currentBobDivision)+j] += (i+1)*((int)Math.pow(10, bobDiceRolls-(a+1)));
					}
				}
			}
			
			System.out.println("\nThe list of Ann's various outcomes is:");
			display(annPermutations);
			System.out.println("\n\nThe list of Bob's various outcomes is:");
			display(bobPermutations);
			
			//This loop considers every entry in the annPermutations array, and replaces it with the highest roll.
			//For example, when Ann rolls thirce, this array will have 111, 112, 113, 114, 115, 116, 121....
			//This will be replaced with 1, 2, 3, 4, 5, 6, 2 respectively.
			for (int i=0; i<annPermutations.length; i++) {
				int[] permutations = new int[annDiceRolls];
				for (int j=0; j<annDiceRolls; j++) {
					permutations[j] = annPermutations[i]%10;
					annPermutations[i] = annPermutations[i]/10;
				}

				int highest=permutations[0];
				for (int k=1; k<permutations.length; k++) {
					if (permutations[k]>highest) 
						highest = permutations[k];
				}
				annPermutations[i] = highest;	
			}
			
			//This loop applies the same process to the bobPermutations array.
			for (int i=0; i<bobPermutations.length; i++) {
				int[] permutations = new int[bobDiceRolls];
				for (int j=0; j<bobDiceRolls; j++) {
					permutations[j] = bobPermutations[i]%10;
					bobPermutations[i] = bobPermutations[i]/10;
				}
				
				int highest=permutations[0];
				for (int k=1; k<permutations.length; k++) {
					if (permutations[k]>highest) 
						highest = permutations[k];
				}
				bobPermutations[i] = highest;	
			}
			
			System.out.println("\n\nThe list of highest values for Ann's every outcome is:");
			display(annPermutations);
			System.out.println("\n\nThe list of highest values for Bob's every outcome is:");
			display(bobPermutations);
			
			//This array will store all the outcomes of Bob and Ann compared against each other, to see who wins.
			//Ann winning will be represented by a 0, and Bob winning will be represented by a 1.
			//The resulting 2D array (similar to a matrix) will resemble the tables made in Microsoft Excel earlier.
			int comparisonArray[][] = new int[annPermutations.length][bobPermutations.length];
			
			
			//This loop compares Bob and Ann's rolls to assign 0s and 1s to every outcome.
			for (int i=0; i<annPermutations.length; i++) {
				for (int j=0; j<bobPermutations.length; j++) {
					if (annPermutations[i]<=bobPermutations[j]) 
						comparisonArray[i][j] = 1;				
				}
			}
			
			System.out.println("\n\nThe table of total outcomes, where 0 is Ann winning and 1 is Bob winning:");
		display(comparisonArray);
			
			annProbabilityNumerator=0; 
			bobProbabilityNumerator=0;
			probabilityDenominator= (annPermutations.length)*(bobPermutations.length);
			
			
			//This loop combes through the comparisonArray, and adds up all the 1s, just like the SUM function in Excel.
			for (int i=0; i<annPermutations.length; i++) {
				for (int j=0; j<bobPermutations.length; j++) {
					if (comparisonArray[i][j] == 1) 
						bobProbabilityNumerator++;				
				}
			}
			annProbabilityNumerator = probabilityDenominator-bobProbabilityNumerator;
			
			System.out.println("\n\nThe probability of Ann winning with " +annDiceRolls +" rolls is " +annProbabilityNumerator+"/"+probabilityDenominator);
			System.out.println("The probability of Bob winning with " +bobDiceRolls +" rolls is " +bobProbabilityNumerator+"/"+probabilityDenominator);
			
			System.out.println("\nEnter 1 to continue the program or 2 to exit: ");
			int menu = input.nextInt();
			if (menu==2)
				continueLoop = false;
		}
	}
	
	public static void display(int[] array) {
		System.out.println();
		for (int i=0; i<array.length;i++) {
			System.out.print("{" + array[i] +"}; ");
		}
	}
	
	public static void display(int[][] array) {
		System.out.println();
		for (int i=0; i<array.length;i++) {
			for (int j=0; j<array[i].length;j++) {
				System.out.print(array[i][j] +" ");
			}
			System.out.println();
		}
	}
}