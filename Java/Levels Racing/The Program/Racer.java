/* This is Racer.java, which inherits the members of the Student class, and is 
 *for those Students who belond to a team. Created by Naval Handa, on 24.02.2013, 
 *Emirates International School Meadows. Made on a Sony Vaio E-Series (VPCEB46FG) 
 *using JCreator. */

class Racer extends Student {
	private String teamName; /*The team the Student belongs to. Since every 
	student is not in a team, inheritance is used.*/
	
	//Constructor of the Racer class.
	Racer (int id, String name, int racingLevel, String teamName) {
		super(id, name, racingLevel); /*Invoking the contructor of the 
		Student class.*/
		this.teamName = teamName;
	}
	
	//Default constructor when no parameter is passed from the calling method.
	Racer() { 
		super();
	}
	/*Get and set methods for the teamName variable. The get method returns a 
	 *String type and has no parameters. */
	String getTeamName() {
		return teamName;
	}
	//The set method returns no data and has a parameter of String type.
	void setTeamName(String teamName) {
		this.teamName = teamName;
	}
	
	/*The Racer class' method to display data. It overrides the 
	 *displayRecordAllData() of Student class, demonstrating an example of 
	 *polymorphism. */
	void displayRecordAllData() {
		System.out.printf("%-4d%-18s%-15d%-20s\n\n", getId(), getName(), getRacingLevel(), getTeamName());
	}
}
