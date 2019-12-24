/* This is MergeSorter.java, which sorts data using linked lists, by criteria 
 *provided by the user.Created by Naval Handa, on 24.02.2013, Emirates 
 *International School Meadows.Made on a Sony Vaio E-Series (VPCEB46FG) 
 *using JCreator. */

import java.io.*;

class MergeSorter {
	Node head; //Stores the head of the current list.
	int positionOfAspect; /*This helps the program to decide what field are the 
	records being sorted by.*/
	int typeOfAspect; /*The type of the field the records are being sorted by: 
	String=1; Int=2; Double=3.*/
	int ascendingOrDescending; /*The desired order of the sort: 
	Ascending=1; Descending=2.*/
	int personalOrPerformanceData; /*Whether records are being sorted by 
	personal or performance dat. Personal data=1; Performance data=2.*/
	
	/*This is the contructor of the class and instantiates head and the 
	 *4 variables necessary to sort the data.*/
	MergeSorter(int positionOfAspect, int typeOfAspect, int personalOrPerformanceData, int ascendingOrDescending) {
		head=null;
		this.positionOfAspect = positionOfAspect;
		this.typeOfAspect = typeOfAspect;
		this.personalOrPerformanceData = personalOrPerformanceData;
		this.ascendingOrDescending = ascendingOrDescending;
	}
	
	/*The method that is called by studentFile to perform the sort. 
	 *This method simply acts as a 'large' method that simply calls all the 
	 *individual methods needed to perform the sort.*/
	void sort() throws IOException{
		createLinkedList(); /*Create a linked list with all the data from the 
		studentFile.*/
		
		populateData(); /*Populate either the intData/doubleData/stringData 
		field of each node with the data that the records are being sorted by. */
		
		append(mergeSort(head)); /*mergeSort(head) merge sorts the list, 
		and append assigns this new list to head.*/
		
		if (ascendingOrDescending==1)
			display(); //Display in ascending order.
		else if (ascendingOrDescending==2)
			displayBackwards();	//Display in descending order.
	}
	
	
	/*Reads the studentFile.dat and adds every record to the linked list 
	 *as a Node object.*/
	void createLinkedList() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int count = countRecords(); //Number of student records.
		
		for (int record=0; record<count; record++) {
			Student student = new Student(); /*Creating a new student object 
			to store the data.*/
			
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
			insert(student); /*Passing the student object (reference) that 
			contains the record's fields.*/
		}
		studentFile.close();
	}
	
	/*This methods counts the current number of records in the studentFile.dat, 
	 *and returns this value to the calling method.*/
	int countRecords() throws IOException {
		RandomAccessFile studentFile = new RandomAccessFile ("studentFile.dat","rw");
		int records = (int)(studentFile.length()/128);
		studentFile.close();
		return records;
	}
	
	/*This method inserts a new Node object to the linked list that starts at 
	 *the 'head' member variable of the MergeSorter class.*/
	void insert(Student student) {
		Node newNode = new Node(); //Creating a new Node object.
		newNode.setId(student.getId());
		newNode.setName(student.getName());
		newNode.setAge(student.getAge());
		newNode.setAddress(student.getAddress());
		newNode.setClassesTaught(student.getClassesTaught());
		newNode.setGroupName(student.getGroupName());
		newNode.setFeesPaid(student.getFeesPaid());
		newNode.setRacingLevel(student.getRacingLevel());
		newNode.setAverage400(student.getAverage400());
		newNode.setAverage800(student.getAverage800());
		newNode.setAverage1000(student.getAverage1000());
		//Setting the values from the passed Student object.
		
		//If the list is empty, this Node is the head of the list.
		if (isEmpty())			
			head = newNode;
		/*If not, then traverse the list till the end and make that Node's next 
		 *variable reference this Node object. This effectively 'links' the list.*/
		else {
			Node current = new Node();
			current = head;
			while (current.getNext()!=null) 				
				current = current.getNext();
				
			current.setNext(newNode);
		}		
	}
	
	/*Checks to see if the list has any Node objects in it yet. If it is empty, 
	 *return true, else return false.*/
	boolean isEmpty() {
		if (head==null)
			return true;
		else
			return false;
	}
	
	/*This method goes through every Node object in the linked list, and 
	 *initialises the intData/doubleData/stringData with the desired field to be 
	 *sorted by. For example, if the user wishes to sort by racing level, then 
	 *intData will be initialised for every Node, containing the racing level. 
	 *This approach reduces the amount of code (is efficient), otherwise a 
	 *method would be needed to sort for every different field.*/
	void populateData() {
		int count = size(head); //Number of nodes in the linked list.
		Node current = head; //Start traversing the list from the head.
		
		for (int i=0; i<count; i++) {
			/*positionOfAspect values are determined from studentFile.*/
			if (positionOfAspect==4) 
				current.setStringData(current.getName());
			else if (positionOfAspect==40) 
				current.setIntData(current.getAge());
			else if (positionOfAspect==44)
				current.setStringData(current.getAddress());
			else if (positionOfAspect==88)
				current.setIntData(current.getClassesTaught());
			else if (positionOfAspect==92)
				current.setStringData(current.getGroupName());
			else if (positionOfAspect==96)
				current.setIntData(current.getFeesPaid());		
			else if (positionOfAspect==100)
				current.setIntData(current.getRacingLevel());
			else if (positionOfAspect==104)
				current.setDoubleData(current.getAverage400());
			else if (positionOfAspect==112)
				current.setDoubleData(current.getAverage800());
			else if (positionOfAspect==120)
				current.setDoubleData(current.getAverage1000());	
			
			current = current.getNext(); //Move on to the next node.
		}
	}
	
	//Returns the value of the number of Node objects in the linked list.
	int size(Node head) {
		Node current = new Node();
		current=head; //Start traversing from head.
		int counter;
		for (counter = 1; current.getNext()!=null; counter++)
			current = current.getNext();
		return counter;	
	}
	
	/*This method points the head variable to the list/Node object that is 
	 *passed to it.*/
	void append(Node sortedList) {
		head = sortedList;
	}
	
	/*The first method that is called when the actual sorting process occurs. 
	 *Any list or sub-list can be passed to this method, and it returns a fully 
	 *sorted list. This is taken advantage of by using recursion.	This method 
	 *is closely interlinked to intMerge, doubleMerge and stringMerge.*/
	Node mergeSort(Node listHead) {
		
		/*If the list that was passed to this method has a size of 1 or 0, 
		 *return the list as it is already 'sorted'. This is the base case 
		 *of this recursive method.*/
		if (listHead==null || listHead.getNext()==null)
			return listHead;
			
		int count = size(listHead); /*Count the number of Nodes in the current 
		list that has been passed to this method.*/
		
		Node firstHalf = listHead; /*The first half of this list starts here.*/
		Node secondHalf = new Node(); /*The second half of the list: its 
		reference will be calculated below.*/
		
		Node current = listHead; /*Start at the beginning of the list that 
		was passed.*/
		
		//This loop roughly traverses about half of the currently passed list.
		for (int i=0; i<(count/2 - 1); i++) 
			current = current.getNext();
			
		secondHalf=current.getNext(); /*The beginning of roughly the second half 
		of the list is assigned to secondHalf.*/
		current.setNext(null);/*The reference pointer next between the last Node 
		of firstHalf and first Node of secondHalf must be broken.*/
		
		/*Now that the list has been 'broken' into two halves, these two halves 
		 *are recursively passed back to mergeSort(). These two lists are then 
		 *further broken down into their own sub-lists until the base case is 
		 *reached. Then, either the intMerge, doubleMerge or stringMerge method 
		 *is called, with the broken down lists passed to it. That method 
		 *creates a sorted sublist by 'merging' the two halves in order, and 
		 *returns this list back to this method. */ 
		if (typeOfAspect==1) //If data is of String type.
			return stringMerge(mergeSort(firstHalf), mergeSort(secondHalf));
		else if (typeOfAspect==2) //If data is of int type.
			return intMerge(mergeSort(firstHalf), mergeSort(secondHalf));
		else //If data is of double type.
			return doubleMerge(mergeSort(firstHalf), mergeSort(secondHalf));	
	}
	
	/*Two halves of a list are passed to this method, and this method assembles 
	 *these two halves into a sorted 'whole' list. It then returns this list.*/
	Node stringMerge (Node firstHalf, Node secondHalf) {
		
		Node tempHead = new Node(); /*This node will remain empty throughout 
		the execution of this method. It is the Node that succeeds it, that is 
		returned to the calling method, because that is where the desired sorted 
		list starts from.*/
		
		Node current = tempHead; /*A helper traversal variable that starts at 
		tempHead.*/
		
		/*This loop continues to run till either the entire firstHalf or 
		 *secondHalf list has been traversed/dealt with.*/
		while ((firstHalf != null) && (secondHalf != null)) {
		 	
		 	/*Check if the current firstHalf node has a lower ASCII value 
		 	 *than the current node of secondHalf. If so, assign the firstHalf 
		 	 *Node to the new 'sorted' list being contructed, otherwise assign 
		 	 *the secondHalf node to the new list.*/
		 	if ((firstHalf.getStringData()).compareTo(secondHalf.getStringData())<=0) {
		 		
		 		current.setNext(firstHalf); /*First, set the next Node of the 
		 		sorted list to be the firstHalf Node.*/
		 		
	            current = current.getNext(); /*Move on to the next Node (which 
	            is currently null) of the newly constructed list.*/
	            
	            firstHalf = firstHalf.getNext(); /*Move on to the next Node of 
	            the firstHalf list.*/
	            
	            /*It is important to note that the firstHalf.next reference is 
	             *not yet broken. It will be automatically broken on the next 
	             *iteration of the loop, when current.next 
	             *(which is firstHalf.next) will be assigned to another Node.*/
		 	}         
            else {
            	//The same logic as the if condition, but for secondHalf.
            	current.setNext(secondHalf);
	            current = current.getNext();
	            secondHalf = secondHalf.getNext();
            }
		 }
		 
		 /*When the loop terminates, one of the 'halves' have already been 
		  *merged. So simply attach the remaining part of the other half to 
		  *the list.*/
		 if (firstHalf==null)
			 current.setNext(secondHalf);
		 else 
			 current.setNext(firstHalf);
		 return tempHead.getNext();
	}	
	
	/*Returns a sorted list when passed two halves. Follows the same logic as 
	 *stringMerge but compares for int fields.*/
	Node intMerge (Node firstHalf, Node secondHalf) {
		Node tempHead = new Node();
		Node current = tempHead;
		while ((firstHalf != null) && (secondHalf != null)) {
		 	if (firstHalf.getIntData() <= secondHalf.getIntData()) {
		 		current.setNext(firstHalf);
	            current = current.getNext();
	            firstHalf = firstHalf.getNext();
		 	}         
            else {
            	current.setNext(secondHalf);
	            current = current.getNext();
	            secondHalf = secondHalf.getNext();
            }
		 }
		 
		 if (firstHalf==null)
			 current.setNext(secondHalf);
		 else 
			 current.setNext(firstHalf);
		 return tempHead.getNext();
	}
	
	/*Returns a sorted list when passed two halves. Follows the same logic as 
	 *stringMerge but compares for double fields.*/
	Node doubleMerge (Node firstHalf, Node secondHalf) {
		Node tempHead = new Node();
		Node current = tempHead;
		while ((firstHalf != null) && (secondHalf != null)) {
		 	if (firstHalf.getDoubleData() <= secondHalf.getDoubleData()) {
		 		current.setNext(firstHalf);
	            current = current.getNext();
	            firstHalf = firstHalf.getNext();
		 	}         
            else {
            	current.setNext(secondHalf);
	            current = current.getNext();
	            secondHalf = secondHalf.getNext();
            }
		 }
		 
		 if (firstHalf==null)
			 current.setNext(secondHalf);
		 else 
			 current.setNext(firstHalf);
		 return tempHead.getNext();
	}
	
	//This method displays the sorted list in ascending order.
	void display() {
		Node current = head;
		/*The if statements are whether the user initially requested personal 
		 *or performance data to be displayed.*/
		if (personalOrPerformanceData==1) {
			System.out.printf("%-4s%-18s%-5s%-22s%-9s%-12s%-5s\n\n", "ID", "Student Name", "Age", "Address","Classes", "Group Name", "Fees Paid");
			/*This loop uses a printf command to display the relevant data of the record, then moves on to the next Node in the list.*/
			while (current!=null) {
				System.out.printf("%-4d%-18s%-5d%-22s%-9d%-12s%-5d\n\n", current.getId(), current.getName(), current.getAge(), current.getAddress(), current.getClassesTaught(), current.getGroupName(), current.getFeesPaid());
				current=current.getNext();
			}
		}
		
		else if (personalOrPerformanceData==2) {
			System.out.printf("%-4s%-18s%-5s%-15s%-12s%-12s%-12s\n\n", "ID", "Student Name", "Age", "Racing Level", "Avg. 400m", "Avg. 800m", "Avg. 1000m");
			while (current!=null) {
				System.out.printf("%-4d%-18s%-5d%-15d%2.2f%12.2f%12.2f\n\n", current.getId(), current.getName(), current.getAge(), current.getRacingLevel(), current.getAverage400(), current.getAverage800(), current.getAverage1000());
				current=current.getNext();
			}
		}
	}
	
	//This method displays the sorted list in descending order.
	void displayBackwards() {
		Node current = head;
		Node previous = null;
		/*After executing whichever if condition, the method operates as follows. 
		 *The first loop executes until every Node's data has been displayed. 
		 *It will display the last node in the ascending-ly sorted list, 
		 *then break the next reference of the Node before. The list will 
		 *become one node shorter, and this process is repeated till the 
		 *entire list is broken.	Hence, all the data will be displayed 
		 *in descending order. */
			
		if (personalOrPerformanceData==1) {
			System.out.printf("%-4s%-18s%-5s%-22s%-9s%-12s%-5s\n\n", "ID", "Student Name", "Age", "Address","Classes", "Group Name", "Fees Paid");
			while (head.getNext()!=null) {
				//This loop traverses the list till it reaches its end.
				while (current.getNext()!=null){
					previous = current;
					current = current.getNext();
				}
				//Print the data of the last record.
				System.out.printf("%-4d%-18s%-5d%-22s%-9d%-12s%-5d\n\n", current.getId(), current.getName(), current.getAge(), current.getAddress(), current.getClassesTaught(), current.getGroupName(), current.getFeesPaid());
				
				previous.setNext(null);/*'Break' the next reference of the previous node, so that the 
				 *list is now one Node shorter and the previous node is now the 
				 *last node.*/
				
				current = head;//Start traversing again at the head.
			}
			System.out.printf("%-4d%-18s%-5d%-22s%-9d%-12s%-5d\n\n", current.getId(), current.getName(), current.getAge(), current.getAddress(), current.getClassesTaught(), current.getGroupName(), current.getFeesPaid());
		}
		
		else if (personalOrPerformanceData==2) {
			System.out.printf("%-4s%-18s%-5s%-15s%-12s%-12s%-12s\n\n", "ID", "Student Name", "Age", "Racing Level", "Avg. 400m", "Avg. 800m", "Avg. 1000m");
			while (head.getNext()!=null) {
				while (current.getNext()!=null){
					previous = current;
					current = current.getNext();
				}
				System.out.printf("%-4d%-18s%-5d%-15d%2.2f%12.2f%12.2f\n\n", current.getId(), current.getName(), current.getAge(), current.getRacingLevel(), current.getAverage400(), current.getAverage800(), current.getAverage1000());
				previous.setNext(null);
				current = head;
			}
			System.out.printf("%-4d%-18s%-5d%-15d%2.2f%12.2f%12.2f\n\n", current.getId(), current.getName(), current.getAge(), current.getRacingLevel(), current.getAverage400(), current.getAverage800(), current.getAverage1000());
		}
	}
}