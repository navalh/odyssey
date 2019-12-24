import java.io.*;

class ZTestWriter {
	public static void main (String args[]) throws IOException {
		RandomAccessFile ratesFile = new RandomAccessFile ("ratesFile.dat","rw");
		ratesFile.setLength(0);
		ratesFile.writeInt(50);
		ratesFile.writeInt(75);
		ratesFile.writeInt(100);
		FixedLengthStringIO.writeFixedLengthString("HamelinDrive123", 15, ratesFile);
		ratesFile.close();	
		
		RandomAccessFile pastLapsFile = new RandomAccessFile ("pastLapsFile.dat","rw");
		pastLapsFile.setLength(0);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(1);
		pastLapsFile.writeDouble(25.23);
		pastLapsFile.writeDouble(44.51);
		pastLapsFile.writeDouble(53.22);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(2);
		pastLapsFile.writeDouble(26.62);
		pastLapsFile.writeDouble(46.21);
		pastLapsFile.writeDouble(51.63);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(3);
		pastLapsFile.writeDouble(27.20);
		pastLapsFile.writeDouble(42.84);
		pastLapsFile.writeDouble(51.62);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(4);
		pastLapsFile.writeDouble(26.27);
		pastLapsFile.writeDouble(45.90);
		pastLapsFile.writeDouble(54.53);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(5);
		pastLapsFile.writeDouble(25.87);
		pastLapsFile.writeDouble(44.51);
		pastLapsFile.writeDouble(53.22);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(6);
		pastLapsFile.writeDouble(29.73);
		pastLapsFile.writeDouble(42.83);
		pastLapsFile.writeDouble(55.62);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(7);
		pastLapsFile.writeDouble(28.73);
		pastLapsFile.writeDouble(42.71);
		pastLapsFile.writeDouble(54.25);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(8);
		pastLapsFile.writeDouble(27.84);
		pastLapsFile.writeDouble(42.76);
		pastLapsFile.writeDouble(56.99);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(9);
		pastLapsFile.writeDouble(26.72);
		pastLapsFile.writeDouble(43.53);
		pastLapsFile.writeDouble(55.83);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(10);
		pastLapsFile.writeDouble(27.13);
		pastLapsFile.writeDouble(43.12);
		pastLapsFile.writeDouble(53.12);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(11);
		pastLapsFile.writeDouble(25.62);
		pastLapsFile.writeDouble(43.71);
		pastLapsFile.writeDouble(53.53);
		
		pastLapsFile.writeInt(1);
		pastLapsFile.writeInt(12);
		pastLapsFile.writeDouble(28.34);
		pastLapsFile.writeDouble(47.21);
		pastLapsFile.writeDouble(52.94);
	}
}