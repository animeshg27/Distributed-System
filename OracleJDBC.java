import java.sql.*;
//or you can keep the following instead
//import java.sql.DriverManager;
//import java.sql.Connection;
//import java.sql.SQLException;
 
public class OracleJDBC {
 
	public static void main(String[] args) {
		System.out.println("-------- Oracle JDBC Connection Testing ------");
 
		try {
 
			Class.forName("oracle.jdbc.driver.OracleDriver");
 
		} catch (ClassNotFoundException e) {
 
			System.out.println("Where is your Oracle JDBC Driver?");
			e.printStackTrace();
			return;
 
		}
 
		System.out.println("Oracle JDBC Driver Registered!");
 
		Connection connection = null;
 
		try {
            connection = DriverManager.getConnection("jdbc:oracle:thin:@az6F72ldbp1.az.uta.edu:1523/pcse1p.data.uta.edu", "axg6991", "UTA27072707uta");
		} catch (SQLException e) {
			System.out.println("Connection Failed! Check output console");
			e.printStackTrace();
			return;
 
		}
 
		if (connection != null) {
			System.out.println("You made it, take control of your database now!\n");
		} else {
			System.out.println("Failed to make connection!");
		}

		if(args[0].toLowerCase().equals("r") && args[1] != null) {
			try {
					Statement stmt = connection.createStatement();
					ResultSet rs = stmt.executeQuery("SELECT * FROM " + args[1]);
					ResultSetMetaData rsmd = rs.getMetaData();
					int columnsNumber = rsmd.getColumnCount();
					while (rs.next()) {
						for (int i = 1; i <= columnsNumber; i++) {
							if(i == 1) {
								System.out.print(rs.getString(i));
							}
							else {
								System.out.print("		" + rs.getString(i));
							}
						}
						System.out.println("");
					}
					rs.close();
					stmt.close();
					connection.close();
				}
				catch (SQLException e) {
		
					System.out.println("error in accessing the relation");
					e.printStackTrace();
					return;
				} 
		}
		if(args[0].toLowerCase().equals("b") && args[1].toLowerCase().equals("1") && args[2] != null && args[3] != null) {
			try {
					PreparedStatement stmt = connection.prepareStatement("SELECT R.RETAILER_NAME, TEMP2.SALES FROM (SELECT TEMP.RETAILER_ID, TEMP.SALES, MAX(TEMP.SALES) OVER () AS MAX_SALES FROM (SELECT RETAILER_ID, SUM(AMOUNT) AS SALES FROM Fall22_S001_3_ORDERS WHERE ORDER_DATE BETWEEN ? AND ? GROUP BY RETAILER_ID) TEMP) TEMP2, Fall22_S001_3_RETAILERS R WHERE TEMP2.RETAILER_ID = R.RETAILER_ID AND TEMP2.SALES = TEMP2.MAX_SALES");
					stmt.setString(1, args[2]);
					stmt.setString(2, args[3]);
					ResultSet rs = stmt.executeQuery();
					while (rs.next())
						System.out.println(
							rs.getString("RETAILER_NAME")
							+ "	" + rs.getString("SALES")
						);
					rs.close();
					stmt.close();
					connection.close();
				}
				catch (SQLException e) {
		
					System.out.println("error in accessing the relation");
					e.printStackTrace();
					return;
				} 
		}
		if(args[0].toLowerCase().equals("b") && args[1].toLowerCase().equals("2") && args[2] != null && args[3] != null) {
			try {
					PreparedStatement stmt = connection.prepareStatement("SELECT P.PRODUCT_NAME, TEMP2.UNITS_SOLD FROM (SELECT TEMP.PRODUCT_ID, TEMP.UNITS_SOLD, MAX(TEMP.UNITS_SOLD) OVER () AS MAX_NUM FROM (SELECT CO.PRODUCT_ID, SUM(CO.PRODUCT_QUANTITY) AS UNITS_SOLD FROM Fall22_S001_3_CONTAINS_ORDERS CO, Fall22_S001_3_ORDERS O WHERE CO.ORDER_ID = O.ORDER_ID AND O.ORDER_DATE BETWEEN ? AND ? GROUP BY CO.PRODUCT_ID) TEMP) TEMP2, Fall22_S001_3_PRODUCTS P WHERE TEMP2.PRODUCT_ID = P.PRODUCT_ID AND TEMP2.UNITS_SOLD = TEMP2.MAX_NUM");
					stmt.setString(1, args[2]);
					stmt.setString(2, args[3]);
					ResultSet rs = stmt.executeQuery();
					while (rs.next())
						System.out.println(
							rs.getString("PRODUCT_NAME")
							+ "	" + rs.getString("UNITS_SOLD")
						);
					rs.close();
					stmt.close();
					connection.close();
				}
				catch (SQLException e) {
		
					System.out.println("error in accessing the relation");
					e.printStackTrace();
					return;
				} 
		}
		if(args[0].toLowerCase().equals("d") && args[1] != null && args[2] != null) {
			try {
					PreparedStatement stmt = connection.prepareStatement("delete * from ? where PRODUCT_ID = ?");
					stmt.setString(1, args[1]);
					stmt.setString(2, args[2]);
					ResultSet rs = stmt.executeQuery();
     				System.out.println("SUCCESSFULLY DELETED THE PRODUCT!!");
					rs.close();
					stmt.close();
					connection.close();
				}
				catch (SQLException e) {
		
					System.out.println("Could not delete the table");
					e.printStackTrace();
					return;
		}
			
		}
	}
}


