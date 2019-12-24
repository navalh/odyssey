class ProbabilityTableHelperCalculator {
	public static void main (String args[]) {
		for (int i=1; i<6; i++) {
			for (int j=1; j<6; j++) {
				int bobNumerator = bobNumerator(j, i);
				int annNumerator = annNumerator (j, i);
				int denominator = denominator(j, i);
				
				System.out.println("If x = " +j +" and y = " +i +":");
				System.out.println("P(A) = " +annNumerator +"/" +denominator +" and P(B) = " +bobNumerator +"/" +denominator +"\n\n");
			}
		}
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