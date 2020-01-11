/*
This program can be used to calculate mixed Nash equilibrium strategies for non-zero sum games with two players. It was used throughout the essay to ensure all the calculations were accurate.
Data must be entered in a matrix in the form (In arrays in Java, row and column numbers start from 0 and not 1):
	Player 2 Strategy 1 (Played n2 times) (Column 1)	Player 2 Strategy 2 (Played 1-n2 times)(Column 2)

Player 1 Strategy 1 (Played n1 times)(Row 1)	payoff[0][0], payoff[0][1]	payoff[0][2], payoff[0][3]
Player 1 Strategy 2 (Played 1-n1 times)(Row 2)	payoff[1][0], payoff[1][1]	payoff[1][2], payoff[1][3]
           
*/

import java.util.Scanner;

class MixedNash {
	public static void main (String args[]) {
		double payoff[][]= new double[2][4];
		Scanner input = new Scanner (System.in);
		
		for (int i=0; i<payoff.length; i++) {
			for (int j=0; j<payoff[i].length; j++) {
				System.out.println("Please enter the payoff of row " +(i+1) +" and column " +(j+1));
				payoff[i][j]=input.nextDouble();
			}
		}
/*
The formula for n1 is equating player 2's expected values: payoff[0][1]*x + payoff[1][1](1-x) = payoff[0][3]*x + payoff[1][3]*(1-x)
Expanding this: [0][1]x + [1][1] - [1][1]x = [0][3]x + [1][3] - [1][3]x (Omitting the word 'payoff' for brevity)
Taking the x to one side: [0][1]x - [1][1]x - [0][3]x + [1][3]x = [1][3] - [1][1]
Factorising the x term: x ([0][1] - [1][1] - [0][3] + [1][3]) = [1][3] - [1][1]
 Dividing both sides: x = ([1][3] - [1][1])/([0][1] - [1][1] - [0][3] + [1][3])
*/
		double n1 = (double)(payoff[1][3]-payoff[1][1])/(payoff[0][1]-payoff[1][1]-payoff[0][3]+payoff[1][3]);
		double n2 = (double)(payoff[1][2]-payoff[0][2])/(payoff[0][0]-payoff[0][2]-payoff[1][0]+payoff[1][2]);
		
		System.out.println("\nThe first player should do the first strategy " +(double)n1 + " of the time.");
		System.out.println("And do the second strategy " +(double)(1-n1) + " of the time.\n");
		
		System.out.println("The second player should do the first strategy " +(double)n2 + " of the time.");
		System.out.println("And do the second strategy " +(double)(1-n2) + " of the time.\n");
		
		double expectedValuePlayer1 = (double)(n1*n2*payoff[0][0])+(n1*(1-n2)*payoff[0][2])+((1-n1)*n2*payoff[1][0])+((1-n1)*(1-n2)*payoff[1][2]);
		double expectedValuePlayer2 = (double)(n1*n2*payoff[0][1])+(n1*(1-n2)*payoff[0][3])+((1-n1)*n2*payoff[1][1])+((1-n1)*(1-n2)*payoff[1][3]);
		
		System.out.println("The first player's expected value is " +expectedValuePlayer1 +"\n");
		System.out.println("The second player's expected value is " +expectedValuePlayer2 +"\n");
	}
}	

