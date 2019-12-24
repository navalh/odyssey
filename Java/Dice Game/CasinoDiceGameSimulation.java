/*This program, CasinoDiceGameSimulation.java, was written by Naval Handa, Emirates International School Meadows, on 1.03.13.
It was written using JCreator and runs a simulation of the 'casino model' of the dice game.*/

import java.util.Scanner;

class CasinoDiceGameSimulation {
	static int casinoDiceRolls; //How many rolls the casino has (y).
	static int playerDiceRolls; //How many rolls the players have (x).
	static int numberOfPlayers; //Number of players playing the dice game.
	
	static int originalCasinoMoney; //Amount of money the casino starts out with.
	static int originalPlayerMoney; //Amount of money the players start out with.
	static int casinoMoney; //Current money the casino has.
	static int playerMoney[]; //Current money the players have.
	static double expectedCasinoMoney; //Amount of money casino is expected to have at the end.
	static double expectedPlayerMoney; //Amount of money the player(s) are expected to have at the end.
	
	static int casinoWinCounter=0; //How many games the casino has won.
	static int casinoLossCounter=0; //How many games the casino has lost.
	static int playerWinCounter[]; //How many games the players have won.
	static int playerLossCounter[]; //How many games the players have lost.
	
	static int playerBetValue; //This is 'a'.
	static int casinoPayoutValue; //This is just 'b': how much profit the player gets.
	static int numberOfGames; //Number of games or rounds to be played.
	static double expectedCasinoProfitPerGame; //This is 'c'.
	
	public static void main (String args[]) {
		userInput(); //Input all the variables needed for the simualtion.
		
		double pA = (double)annNumerator(playerDiceRolls,casinoDiceRolls)/denominator(playerDiceRolls,casinoDiceRolls);
		double pB = 1 - pA;
		expectedCasinoProfitPerGame = (double)((double)playerBetValue*pB - (double)casinoPayoutValue*pA); //Calculating c using the formula.
		double expectedCasinoProfit = numberOfGames*numberOfPlayers*expectedCasinoProfitPerGame;
		expectedCasinoMoney = originalCasinoMoney + expectedCasinoProfit;
		double expectedPlayerLoss = expectedCasinoProfit/numberOfPlayers;
		expectedPlayerMoney =originalPlayerMoney-expectedPlayerLoss;
		
		for (int a=0; a<numberOfGames; a++) {
			int[] casinoRolls = new int[casinoDiceRolls]; /*This array will temporarily store all the rolls done by the casino.
			For example, if the casino has 3 rolls, and rolls a 4,5,6, this array will store 4,5,6. */
			
			int[][] playerRolls = new int [numberOfPlayers][playerDiceRolls];/*This is a 2D array that will temporarily store 
		    all the rolls done by all of the players, just like casinoRolls[].*/
		    
			int casinoHighest = 0; /*This variable will store the highest roll of the casino. For example, if the casino rolls
			4,5,6, then this variable will store 6, because that is the dice roll that the casino will use to compete against all 
			the other players. */
			
			int playerHighest[] = new int [numberOfPlayers]; /*This array will store the highest roll of all the players,
			just like casinoHighest.*/ 
			
			//This loops rolls all the dice rolls the casino has, then assigns the highest roll to casinoHighest.
			for (int i=0; i<casinoDiceRolls; i++) {
				casinoRolls[i] = rollDice();
				if (casinoRolls[i]>casinoHighest)
					casinoHighest = casinoRolls[i];
			}
			
			//This loops rolls all the dice rolls the players, then assigns the highest roll to playerHighest[].
			for (int i=0; i<numberOfPlayers; i++) {
				for (int j=0; j<playerDiceRolls; j++) {
					playerRolls[i][j] = rollDice();
					if (playerRolls[i][j]>playerHighest[i])
						playerHighest[i] = playerRolls[i][j];
				}
			}
			
			//This loop then compares casinoHighest to playerHighest[]. 
			for (int i=0; i<numberOfPlayers; i++) {
				//If the casino has the bigger roll, then they win a game, player loses a game.
				//The casino earns 'a' while the player loses 'a'.
				if (casinoHighest>=playerHighest[i]) {
					casinoWinCounter++;
					playerLossCounter[i]++;
					casinoMoney = casinoMoney + playerBetValue;
					playerMoney[i] = playerMoney[i] - playerBetValue;
				}
				
				//If the casino has the smaller roll, then they lose a game, the player wins a game.
				//The casino loses 'b' while the player earns 'b'.
				else {
					casinoLossCounter++;
					playerWinCounter[i]++;
					casinoMoney = casinoMoney - casinoPayoutValue;
					playerMoney[i] = playerMoney[i] + casinoPayoutValue;
				}
			}			
		}
		System.out.println("\n\nAfter running the simulation, the values of all the variables are:\n");
		displayAll();
	}
	
	//This method randomly returns a number between 1-6, just like a simulated dice roll.
	public static int rollDice () {
		int roll = (int)((Math.random()*6)+1);
		return roll;
	}
	
	public static void userInput() {
		Scanner input = new Scanner(System.in);
		System.out.println("Please enter the number of dice rolls the casino will have:");
		casinoDiceRolls = input.nextInt();
		System.out.println("Please enter the number of dice rolls the player will have:");
		playerDiceRolls = input.nextInt();
		System.out.println("Please enter the number of players in the game:");
		numberOfPlayers = input.nextInt();
		System.out.println("Please enter the amount of money the casino starts with:");
		originalCasinoMoney = input.nextInt();
		casinoMoney = originalCasinoMoney;
		System.out.println("Please enter the amount of money the player(s) start with:");
		originalPlayerMoney = input.nextInt();
		playerMoney = new int[numberOfPlayers];
		for (int i=0;i<playerMoney.length; i++)
			playerMoney[i]=originalPlayerMoney;
		playerWinCounter = new int[numberOfPlayers];
		playerLossCounter = new int[numberOfPlayers];	
		System.out.println("Please enter the amount of money the player(s) bet:");
		playerBetValue = input.nextInt();
		System.out.println("Please enter the amount of money the casino loses when the player wins (the player's profit):");
		casinoPayoutValue = input.nextInt();
		System.out.println("Please enter the number of games the Casino/Players will play:");
		numberOfGames = input.nextInt();
	}
	
	public static void displayAll() {
		System.out.println("Number of Dice Rolls Casino Has (y): " +casinoDiceRolls);
		System.out.println("Number of Dice Rolls Player(s) Have (x): " +playerDiceRolls);
		System.out.println("Number of Players in the Dice Game (Np): " +numberOfPlayers);
		System.out.println("Number of Games played (Ng): " +numberOfGames);
		System.out.println("Amount of Money a Player bets (a): " +playerBetValue);	
		System.out.println("Amount of Money the Casino gives as the Player's reward (b): " +casinoPayoutValue);
		System.out.println("Amount of profit the Casino should earn per game (c): " +expectedCasinoProfitPerGame +"\n");
		
		
		System.out.println("Original Money the Casino Had: " +originalCasinoMoney);
		System.out.println("Expected Money the Casino Should have: " +expectedCasinoMoney);
		System.out.println("Current Money the Casino Has: " +casinoMoney);	
		System.out.println("Amount of bets the Casino won: " +casinoWinCounter);
		System.out.println("Amount of bets the Casino lost: " +casinoLossCounter+"\n");
		
		System.out.println("Original Money the Player(s) Had: " +originalPlayerMoney);
		System.out.println("Expected Money the player(s) should have: " +expectedPlayerMoney);
		
		for (int i=0;i<numberOfPlayers; i++) {
			System.out.println("Current Money the Player " +(i+1) +" Has: " +playerMoney[i]);
			System.out.println("Amount of bets Player " +(i+1) +" has won: " +playerWinCounter[i]);
			System.out.println("Amount of bets Player " +(i+1) +" has lost: " +playerLossCounter[i]);
		}
		System.out.println();
	}
	
	public static int annNumerator (int x, int y) {
		int sum = ((int)Math.pow(1,y)*(int)Math.pow(2,x) + (int)Math.pow(2,y)*(int)Math.pow(3,x) + (int)Math.pow(3,y)*(int)Math.pow(4,x) + (int)Math.pow(4,y)*(int)Math.pow(5,x) + (int)Math.pow(5,y)*(int)Math.pow(6,x));
		sum = sum - ((int)Math.pow(1,x+y) + (int)Math.pow(2,x+y) + (int)Math.pow(3,x+y) + (int)Math.pow(4,x+y) + (int)Math.pow(5,x+y));
		return sum;
	}
	
	public static int bobNumerator (int x, int y) {
		int sum = denominator(x,y) - annNumerator(x,y);
		return sum;
	}
	
	public static int denominator (int x, int y) {
		int sum = (int)Math.pow(6,x+y);
		return sum;
	}
}