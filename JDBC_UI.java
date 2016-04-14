import java.sql.*;
import java.util.Date;
import java.util.Calendar;
import java.util.InputMismatchException;
import java.util.Scanner;


public class JDBC_UI
{
    public static void main (String[] args) throws SQLException
    {
		// Unique table names.  Either the user supplies a unique identifier as a command line argument, or the program makes one up.
		String tableName = "";
	        int sqlCode=0;      // Variable to hold SQLCODE
	        String sqlState="00000";  // Variable to hold SQLSTATE
	
		if ( args.length > 0 )
		{
		    tableName += args [ 0 ] ;
		}
		else {
		    tableName += "example3.tbl";
		}
	
		// Register the driver.  You must register the driver before you can use it.
	    try {
		    DriverManager.registerDriver(new com.ibm.db2.jcc.DB2Driver());
	    	Class.forName("com.ibm.db2.jcc.DB2Driver");
		} 
	    catch (Exception cnfe){
		    System.out.println("Class not found");
	        }
	
		// This is the url you must use for DB2.
		//Note: This url may not valid now !
		String url = "jdbc:db2://db2:50000/cs421";
		Connection con = DriverManager.getConnection (url,"cs421g41","ebpophajca");
		Statement statement = con.createStatement();
	    
		//START
		Statement stmt = con.createStatement();
		Statement stmt2 = con.createStatement();
		Scanner in = new Scanner(System.in);
		int choice = 0;
		ResultSet rs;
		String eid,name,last,mn,dob,gen,cn,cit,post,count,pn,doe,type,dep,tmps1,tmps2,tmps3,tmps4,tmps5,sqlString, emerg;
		int bih, tmpi1,tmpi2,tmpi3,tmpi4,tmpi5,counter;
		float tmpf1,tmpf2,tmpf3,tmpf4,tmpf5;
		double with_increase;
		boolean flag1 = true ;
		boolean flag2 = true ;
		sqlString = "default";
		
		while (choice != 8)
		{	//MENU
			System.out.println("\n\n");
			System.out.println("Please choose one of the following options to continue: ");
			System.out.println("1. Find all doctors in a specific city");
			System.out.println("2. Add an employee to the hospital database");
			System.out.println("3. Find all employees who have been in contact with a specific patient");
			System.out.println("4. Give a 10% bonus to all docotrs with mortality rate below a certain number");
			System.out.println("5. Update the contact information of a patient");
			System.out.println("6. Compute total medication cost per patient since a given date");
			System.out.println("7. Timer on Query: SELECT pName, pLast, phone_number FROM patient WHERE patient.pID NOT IN (SELECT pID FROM Stays WHERE out_date IS NULL) AND UCASE(patient.city) = 'LAVAL' AND patient.blood_type LIKE 'O_'");
			System.out.println("8. Quit");
			
			try{
				choice = in.nextInt();
			}
			catch (InputMismatchException e) 
			{
				System.out.println("this isnt even a number !!");
				choice = 0;
				in.next();
			}
			
			
			
			
			if (choice < 1 || choice > 8)
			{
				System.out.println("The choice you made is not valid, please read above and select a valid number");
			}
			
			else if (choice == 1)
			{
				System.out.println("Which city would you like to search for doctors in ?");
				PreparedStatement preCity = con.prepareStatement("SELECT sName, sLast, level FROM Doctors,Staff WHERE Doctors.eid = staff.eid AND UCASE(city) = ?");
				String city = in.next().toUpperCase();
				preCity.setString(1, city);
				try
				{
					rs = preCity.executeQuery();
					while (rs.next())
					{
						System.out.println("Dr. "+rs.getString(1)+" "+rs.getString(2)+ " is part of our "+rs.getString(3)+" doctors and lives in "+ city);
					}
				}
				catch(SQLException e)
				{
					System.out.println(e.getMessage()+"   "+e.getErrorCode());
				}
				
			}
			
			
			else if (choice == 2)
			{	
				
				System.out.println("Congratulations you have hired a new employee, please enter all necessary information in the order they are demanded");
				System.out.println("eID");
				eid =in.next().toUpperCase();
				//eid can not exist in table already, as long as the eid has a duplicate, a new one will be demanded
				
				while(flag1)
				{
					try
					{
						rs = stmt.executeQuery("SELECT eid FROM staff");
						flag1=false;
						while (rs.next())
						{
							if (rs.getString(1).equalsIgnoreCase(eid)){System.out.println("this eid already exists please choose an other"); flag1=true; break;}
						}
						if (flag1){eid =in.next();}
					}
					catch(SQLException e)
					{
						System.out.println(e.getMessage()+"   "+e.getErrorCode());
						flag1=false;
						choice=99;
						break;
						
					}
				}
				flag1=true; // reset for next use
				if (choice==99){continue;}
				
				
				// Some restrictions on people
				System.out.println("is the employee a doctor or nurse ??");
				type = in.next(); 
				while (!(type.equalsIgnoreCase("nurse") || type.equalsIgnoreCase("doctor")))
				{
					System.out.println("the type of employee given does not exist for this command, please input the correct type");
					type = in.next();
				}
				
				// DOCTORS----------------------------------------------
				if (type.equalsIgnoreCase("doctor"))
				{
					//level NOT NULL, number_of_patient_visits INT, mortality_rate DECIMAL(5, 4)  , annual_salary DECIMAL(16,2), area_of_research VARCHAR(80), in_department CHAR(5) NOT NULL, since DATE
					System.out.println("level (permanent, R1, R2...)");
					tmps1 = in.next();
					System.out.println("number_of_patient_visits, integer");
					tmpi1= in.nextInt();
					System.out.println("mortality_rate, decimal");
					tmpf1= in.nextFloat();
					
					//DO NOT accept high mortality rates
					while (tmpf1 > 0.6)
					{
						System.out.println("Unfortunately we do not hire doctors with higher mortality rates than 2 anymore, are you sure you have entered the correct value (yes/no)?");
						tmps2= in.next();
						if (tmps2.equalsIgnoreCase("yes"))
						{
							System.out.println("sry, byebye");
							choice=99;
							break;
						}
						else if (tmps2.equalsIgnoreCase("no"))
						{
							System.out.println("enter mortality rate again");
							tmpf1= in.nextFloat();
						}
						
					}
					//breaks if was doctor and high mortality rate back to staff info
					if (choice==99){continue;}
					
					System.out.println("annual_salary, decimal");
					tmpf2= in.nextFloat();
					System.out.println("area_of_research");
					tmps3= in.next();
					System.out.println("in department ?");
					dep= in.next().toUpperCase();
					//dep must be an existing department
					//rs = stmt.executeQuery("SELECT did FROM departments");
					while(flag1)
					{
						try
						{
							rs = stmt.executeQuery("SELECT did FROM departments");
							while (rs.next())
							{
								if (rs.getString(1).equalsIgnoreCase(dep)){flag1=false; break;}
							}
							if (flag1){System.out.println("the department given does not exist, try again"); dep =in.next();}
						}
						catch(SQLException e)
						{
							System.out.println(e.getMessage()+"   "+e.getErrorCode());
							flag1=false;
							choice = 99;
							break;
							
						}
					}
					flag1=true; // reset for next use
					if (choice==99){continue;}
					System.out.println("since? in the form YYYY-MM-DD");
					tmps4= in.next();
					//sqlString = "INSERT INTO Doctors VALUES('"+eid+"','"+tmps1+"',"+tmpi1+","+tmpf1+","+tmpf2+",'"+tmps3+"','"+dep+"','"+tmps4+"')";
					sqlString = "INSERT INTO Doctors VALUES('"+eid+"','"+tmps1+"',"+tmpi1+","+tmpf1+","+tmpf2+",'"+tmps3+"','"+dep+"','"+tmps4+"')";
				}
				
				//NURSES ------------------------------------------------------
				else if (type.equalsIgnoreCase("nurse"))
				{
					// prescription_authorisation CHAR(1) NOT NULL, hourly_salary DECIMAL(16,2), in_department CHAR(5) NOT NULL, since DATE
					System.out.println("hourly_salary, decimal");
					tmpf2= in.nextFloat();
					System.out.println("prescription authorization (Y/N)");
					tmps3= in.next();
					System.out.println("in department ?");
					dep= in.next().toUpperCase();
					//dep must be an existing department
					
					while(flag1)
					{
						try
						{
							rs = stmt.executeQuery("SELECT did FROM departments");
							while (rs.next())
							{
								if (rs.getString(1).equalsIgnoreCase(dep)){flag1=false; break;}
							}
							if (flag1){System.out.println("the department given does not exist"); dep =in.next();}
						}
						catch(SQLException e)
						{
							System.out.println(e.getMessage()+"   "+e.getErrorCode());
							flag1=false;
							choice = 99;
							break;
						}
					}
					flag1=true; // reset for next use
					if (choice==99){continue;}
					
					System.out.println("since ? in the form YYYY-MM-DD");
					tmps4= in.next();
					
					//sqlString = "INSERT INTO Nurses VALUES('"+eid+"','"+tmps3+"',"+tmpf2+",'"+dep+"','"+tmps4+"')";
					sqlString = "INSERT INTO Nurses VALUES('"+eid+"','"+tmps3+"',"+tmpf2+",'"+dep+"','"+tmps4+"')";
				}
				
				//all info for staff table
				System.out.println("Name");
				name =in.next();
				System.out.println("Last Name");
				last =in.next();
				System.out.println("medicare number");
				mn=in.next();
				//medicare number can not exist in table already, as long as the mn has a duplicate, a new one will be demanded
				
				while(flag1)
				{
					try
					{
						rs = stmt.executeQuery("SELECT medicare_number FROM staff");
						flag1=false;
						while (rs.next())
						{
							if (rs.getString(1).equalsIgnoreCase(mn)){System.out.println("this medicarenumber already exists please choose an other"); flag1=true; break;}
						}
						if (flag1){mn =in.next();}
					}
					catch(SQLException e)
					{
						System.out.println(e.getMessage()+"   "+e.getErrorCode());
						flag1=false;
						choice = 99;
						break;
					}
				}
				
				flag1=true; // reset for next use
				if (choice==99){continue;}
				
				System.out.println("date of birth in the form YYYY-MM-DD");
				dob=in.next();
				System.out.println("gender (M/F)");
				gen=in.next();
				System.out.println("civicNumber");
				cn=in.next();
				System.out.println("city");
				cit=in.next();
				System.out.println("postalCode");
				post=in.next();
				System.out.println("country");
				count=in.next();
				System.out.println("phone_number");
				pn=in.next();
				System.out.println("date_of_employement in form YYYY-MM-DD");
				doe=in.next();
				System.out.println("biweekly_hours, integer");
				bih=in.nextInt();
				
	//			if (flag2) {sqlString = "INSERT INTO Doctors VALUES('"+eid+"','"+tmps1+"',"+tmpi1+","+tmpf1+","+tmpf2+",'"+tmps3+"','"+dep+"','"+tmps4+"')";}
	//			else{sqlString = "INSERT INTO Nurses VALUES('"+eid+"','"+tmps3+"',"+tmpf2+",'"+dep+"','"+tmps4+"')";}
				try
				{
					stmt.executeUpdate("INSERT INTO staff VALUES ('"+eid+"','"+name+"','"+last+"','"+mn+"','"+dob+"','"+gen+"','"+cn+"','"+cit+"','"+post+"','"+count+"','"+pn+"','"+doe+"',"+bih+")");
				}
				catch(SQLException e)
				{
					System.out.println(e.getMessage()+"   "+e.getErrorCode());
					continue;
				}
				try
				{
					stmt.executeUpdate(sqlString);
				}
				catch(SQLException e)
				{
					stmt.executeUpdate("delete from staff where eid = '"+eid+"'");
					System.out.println(e.getMessage()+"   "+e.getErrorCode());
				}
				
			}
			
			else if (choice == 3)
			{
				System.out.println("Please enter the Patient id or type \"NAME\" to search by first or last name");
				tmps1 = in.next();
				
				while(flag2)
				{
					
					if (tmps1.equalsIgnoreCase("NAME")) 
					{
						PreparedStatement preName = con.prepareStatement("SELECT pName, pLast, pID FROM Patient WHERE pName = ? OR pLast =?");
						System.out.println("Enter first name OR last name of the patient");
						tmps2=in.next();
	
						preName.setString(1, tmps2);
						preName.setString(2, tmps2);
						
						try
						{
							rs = preName.executeQuery();
							System.out.format("\n%20s%20s%15s\n\n","First name", "Last name", "ID");
							while(rs.next())
							{
								System.out.format("%20s%20s%15s\n",rs.getString(1),rs.getString(2),rs.getString(3));
							}
							System.out.println("Please enter the Patient id or type \"NAME\" to search by first or last name");
							tmps1 = in.next();
						}
						catch(SQLException e)
						{
							System.out.println(e.getMessage()+"   "+e.getErrorCode());
							flag2=false;
							break;
						}
						
					}
					// check in IDs
					else
					{
						try
						{
							rs = stmt.executeQuery("SELECT pid FROM patient");
							while(rs.next())
							{
								if(rs.getString(1).equalsIgnoreCase(tmps1)) {flag2=false; break;}
							}
							if(flag2)
							{
								System.out.println("The ID you have entered is not valid, you can find a Patient ID by typing \"NAME\" when asked for the ID");
								System.out.println("Please enter the Patient id or type \"NAME\" to search by first or last name");
								tmps1 = in.next();
							}
						}
						catch(SQLException e)
						{
							System.out.println(e.getMessage()+"   "+e.getErrorCode());
							flag2=false;
							break;
						}
						
	
					}
					
				}
				flag2=true; // reset flag
				
				try
				{
					rs=stmt.executeQuery("SELECT eid, sName, sLast FROM staff WHERE staff.eid in (SELECT L.eid FROM (SELECT eid,sid FROM cared_for UNION SELECT eid,sid FROM watched_over) AS L WHERE L.sid IN (SELECT sid from stays where pid = '"+tmps1+"'))");
					
					System.out.format("\n%20s%20s%20s\n\n","Employee ID","First name", "Last name");
					while(rs.next())
					{
						System.out.format("%20s%20s%20s\n",rs.getString(1),rs.getString(2),rs.getString(3));
					}
				}
				catch(SQLException e)
				{
					System.out.println(e.getMessage()+"   "+e.getErrorCode());
				}
			}
			
			else if (choice == 4)
			{
				flag2 = true;
				Double mrate=0.0;
				while(flag2){
					System.out.println("Please enter the mortality rate below which all Doctors will get a 10% raise, as a decimal:");
					mrate = in.nextDouble();
					if (mrate<0){
						System.out.println("Sorry, but the mortality rate must be positive!");
						continue;
					}
					flag2 = false;
					break;
				}
				try
				{
					PreparedStatement giveRaise = con.prepareStatement("SELECT eid, annual_salary FROM doctors WHERE mortality_rate < ?");
					giveRaise.setString(1,""+mrate);
					//rs = stmt.executeQuery("SELECT eid, annual_salary FROM doctors WHERE mortality_rate < ?");
					rs = giveRaise.executeQuery();
					while(rs.next())
					{
						tmps1=rs.getString(1);
						with_increase = rs.getDouble(2) * 1.1;
						stmt2.executeUpdate("UPDATE doctors SET annual_salary = "+ with_increase + " WHERE eid = '"+tmps1+"'");
						System.out.println("Doctor with employee ID '"+tmps1+"' got a 10% raise");
					}
				}
				catch(SQLException e)
				{
					System.out.println(e.getMessage()+"   "+e.getErrorCode());
				}
			}
			


			else if (choice == 5)
			{
				
				tmps1 = "";
				

				while(flag1)
				{
					System.out.println("Please enter the Patient id or type \"medicare\" to search by medicare number");
					tmps1 = in.next();
					

					if (tmps1.equalsIgnoreCase("medicare"))
					{
						// get pid
						while(flag2) 
						{
							System.out.println("Enter the medicare number of the patient");
							tmps2=in.next();

							rs = stmt.executeQuery("SELECT pID, medicare_number FROM Patient");
							while(rs.next())
							{
								if(rs.getString(2).equalsIgnoreCase(tmps2)) 
								{
									tmps1 = rs.getString(1);
									flag2=false;
									break;
								}
							}
							if (flag2) 
							{
								// reset curser
								System.out.println("Error: paitent with the given medicare number does not exist. Please try again.");
							}
						}
						flag2 = true;
						break;
					}
					


					// search by pid
					else 
					{
						rs = stmt.executeQuery("SELECT pID FROM Patient");
						while(rs.next())
						{
							if(rs.getString(1).equalsIgnoreCase(tmps1)) 
							{
								flag1=false;
								break;
							}
						}

						if (flag1) 
						{
							 // reset curser
							System.out.println("Error: paitent with the given pid does not exist. Please try again.");
							continue;
						}
						
						
					}
				}
				flag1 = true;

				// pid found, update info
				System.out.println("Please enter the new contact information in the order they are demanded.");
				System.out.println("civicNumber");
				cn=in.next();
				System.out.println("city");
				cit=in.next();
				System.out.println("postalCode");
				post=in.next();
				System.out.println("country");
				count=in.next();
				System.out.println("phone_number");
				pn=in.next();
				System.out.println("emergency_contact");
				emerg=in.next();
				
				

				try
				{
					stmt.executeUpdate("UPDATE Patient SET civicNumber='"+cn+"', city='"+cit+"', postalCode='"+post+"', country='"+count+"', phone_number='"+pn+"', emergency_contact='"+emerg+"' WHERE pID='"+tmps1+"'");

				}
				catch(SQLException e)
				{
					System.err.println("msg: " + e.getMessage() + " " + "code: " + e.getErrorCode() + "state: " + e.getSQLState());
				}

				System.out.println("Update finished.");
			}
			



			else if (choice == 6)
			{

				System.out.println("Please enter a date in the form YYYY-MM-DD");
				tmps1 = in.next();
				
				try
				{
					rs = stmt.executeQuery("SELECT patient.pID, pName, pLast, SUM(dose_g * duration_days * frequency_perday) AS Total_due FROM table (SELECT Stays.sID, pID, dose_g, duration_days, frequency_perday FROM Stays, Administered WHERE stays.sID = Administered.sID AND (out_date > '"+tmps1+"' OR out_date IS NULL)) as PT_2015 , patient WHERE PT_2015.pID = patient.pID GROUP BY pName, pLast, patient.pID");

					System.out.format("\n%20s%20s%20s%20s\n\n","Patient ID","First name", "Last name", "Total Due");
					while(rs.next())
					{
						System.out.format("%20s%20s%20s%20f\n",rs.getString(1),rs.getString(2),rs.getString(3), rs.getFloat("Total_due"));
					}

				}
				catch(SQLException e)
				{
					System.err.println("msg: " + e.getMessage() + " " + "code: " + e.getErrorCode() + "state: " + e.getSQLState());
				}

			}
			



			else if (choice == 7)
			{

				tmps1 = "SELECT pName, pLast, phone_number FROM patient WHERE patient.pID NOT IN (SELECT pID FROM Stays WHERE out_date IS NULL) AND UCASE(patient.city) = 'LAVAL' AND patient.blood_type LIKE 'O_'"; 
				timeMeasure(con, stmt, tmps1, "patient", "city", "blood_type", tmps1);
			}
			
			
			else if (choice == 8){
			    stmt.close();
			    return;
			}
		}    
		stmt.close();
	}
    
    public static void timeMeasure(Connection con, Statement stmt, String sql, String tablename, String att1, String att2, String att3) throws SQLException
    {
    	long pre,post;
    	ResultSet rs;
    	
    	
    	pre = System.currentTimeMillis();
    	for (int i=0; i<200;i++){
    	rs = stmt.executeQuery(sql);
    	}
    	post = System.currentTimeMillis();
    	System.out.println("time required by the query WITHOUT the index: " + ((post-pre)));
    	
    	
//    	stmt.executeUpdate("CREATE INDEX i1 ON"+tablename+" ("+att1+","+att2+","+att3+")");
    	stmt.executeUpdate("CREATE INDEX i1 ON "+tablename+" ("+att1+","+att2+")");
    	
    	
    	pre = System.currentTimeMillis();
    	for (int i=0; i<200;i++){
    	rs = stmt.executeQuery(sql);
    	}
    	post = System.currentTimeMillis();
    	
    	System.out.println("time required by the query WITH the index: " + ((post-pre)));
    	
    	//Remove index after
    	stmt.executeUpdate("DROP INDEX i1");

    	
    }
}
