/* This is Node.java, which acts as the objects to be linked in the linked 
 *list used to sort in MergeSorter.java. Created by Naval Handa, on 24.02.2013, 
 *Emirates International School Meadows. Made on a Sony Vaio E-Series (VPCEB46FG) 
 *using JCreator. */

class Node {
	/*This is the Node used to create the linked list data structure. The linked 
	 *list will be created by inputting the data from the StudentFile. The linked 
	 *list itself will then be sorted. As a result, the actual .dat file is not 
	 *sorted, and after the sort the data in the file is still unsorted.*/
	private int id;
	private String name;
	private int age;
	private String address;
	private int classesTaught;
	private String groupName;
	private int feesPaid;
	private int racingLevel;
	private double average400;
	private double average800;
	private double average1000; 
	//These variables are common to the Student.java class.
	
	
	/*The get and set methods for these variables, because they have been 
	 *declared as private:*/
	int getId() {
		return id;
	}
	
	void setId(int id) {
		this.id = id;
	}
	
	String getName() {
		return name;
	}
	
	void setName(String name) {
		this.name = name;
	}
	
	int getAge() {
		return age;
	}
	
	void setAge(int age) {
		this.age = age;
	}
	
	String getAddress() {
		return address;
	}
	
	void setAddress(String address) {
		this.address = address;
	}
	
	int getClassesTaught() {
		return classesTaught;
	}
	
	void setClassesTaught(int classesTaught) {
		this.classesTaught = classesTaught;
	}
	
	String getGroupName() {
		return groupName;
	}
	
	void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	
	int getFeesPaid() {
		return feesPaid;
	}
	
	void setFeesPaid(int feesPaid) {
		this.feesPaid = feesPaid;
	}
	
	int getRacingLevel() {
		return racingLevel;
	}
	
	void setRacingLevel(int racingLevel) {
		this.racingLevel = racingLevel;
	}
	
	double getAverage400() {
		return average400;
	}
	
	void setAverage400(double average400) {
		this.average400 = average400;
	}
	
	double getAverage800() {
		return average800;
	}
	
	void setAverage800(double average800) {
		this.average800 = average800;
	}
	
	double getAverage1000() {
		return average1000;
	}
	
	void setAverage1000(double average1000) {
		this.average1000 = average1000;
	}
	
	private String stringData; /*Will contain the field that the records is 
	being sorted by, if it is of String type. */
	private int intData; /*Will contain the field that the records is being 
	sorted by, if it is of int type. */
	private double doubleData; /*Will contain the field that the records is 
	being sorted by, if it is of double type. */
 
	//The get and set methods for these 3 variables.
	String getStringData() {
		return stringData;
	}
	
	void setStringData(String stringData) {
		this.stringData = stringData;
	}
	
	int getIntData() {
		return intData;
	}
	
	void setIntData(int intData) {
		this.intData = intData;
	}
	
	double getDoubleData() {
		return doubleData;
	}
	
	void setDoubleData(double doubleData) {
		this.doubleData = doubleData;
	}	
	
	private Node next; /*This variable contains an object reference to a 
	specified instance of a Node class (a Node object). This can be used to 
	'point' to the next Node in the linked list, in order to 'link' the list. */
	
	Node getNext() {
		return next;
	}
	
	void setNext(Node next) {
		this.next = next;
	}
}
