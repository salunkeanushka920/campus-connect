import java.sql.*;

public class CheckDerby {
    public static void main(String[] args) throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection c = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_connect", "app", "app");
        
        System.out.println("=== ADMINS COLUMNS & DATA ===");
        Statement s = c.createStatement();
        ResultSet rs = s.executeQuery("SELECT * FROM admins");
        ResultSetMetaData md = rs.getMetaData();
        int cols = md.getColumnCount();
        for (int i = 1; i <= cols; i++) {
            System.out.print(md.getColumnName(i) + "\t");
        }
        System.out.println();
        while (rs.next()) {
            for (int i = 1; i <= cols; i++) {
                System.out.print(rs.getString(i) + "\t");
            }
            System.out.println();
        }
        rs.close();
        s.close();

        System.out.println("\n=== COMPLAINTS TABLE ===");
        Statement s4 = c.createStatement();
        ResultSet crs = s4.executeQuery("SELECT complaint_id, roll_number, subject, status, priority, admin_remarks FROM complaints");
        while (crs.next()) {
            System.out.println("Complaint ID : " + crs.getString(1));
            System.out.println("Roll Number  : " + crs.getString(2));
            System.out.println("Subject      : " + crs.getString(3));
            System.out.println("Status       : " + crs.getString(4));
            System.out.println("Priority     : " + crs.getString(5));
            System.out.println("Admin Remarks: " + crs.getString(6));
            System.out.println("----------------------------------------");
        }
        crs.close();
        s4.close();

        c.close();
    }
}
