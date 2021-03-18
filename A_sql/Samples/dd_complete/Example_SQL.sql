/* Example SQL Statements used with the Advantage Data Dictionary session */

/*  Executing an AEP - The following statement executes a stored procedure that
  *  generates a new invoice number for the specified customer */
EXECUTE PROCEDURE NewInvoice( 11350,  23)

/* Using dictionary links -  The following statement joins the customer tables 
  * from two different dictionaries together 		 	   	   				   				*/
SELECT 
	   'ABC' as Dictionary, [Customer ID], [Last Name], [First Name], 
       Address, City, State, [Zip Code], [Phone Number] 
FROM 
	 customer
UNION
SELECT 
	   'DEF' as Dictionary, CustNo, [Last Name], [First Name], 
       Addr1 as Address, City, State, Zip, Phone as "Phone Number" 
FROM 
	 DEF.customer
ORDER BY [Last Name]

/* Permissions - After enabling Check User Rights ADSUSER cannot view any
  * tables in the database.  Use the following statement before adding ADSUSER
  * to the FullControl Group.  */
SELECT * FROM Customer

/* Using System Tables - System tables are used to veiw database schema.
  * you must be logged in as ADSSYS to access all the system tables */
-- Get a list of tables in the database
SELECT * FROM system.tables
-- Get a list of users
SELECT * FROM system.users
-- Get a list of views
SELECT * FROM system.views

/* Using System Procedures - System procedures are a set of pre-defined
  * stored procedures on the server that modify database properties */
-- Changing the ADSSYS password
EXECUTE PROCEDURE sp_ModifyUserProperty( 'ADSSYS',  
		'USER_PASSWORD', 'password' )
-- Enabling internet access for ADSUSER
Select * from system.users
EXECUTE PROCEDURE sp_ModifyUserProperty( 'ADSUSER', 
       'ENABLE_INTERNET', 'TRUE' )
-- Changing the dictionary description
EXECUTE PROCEDURE sp_ModifyDatabase( 'COMMENT', 
 		'This is the finished version of the database used in the Advantage Data Dictionary session' )
		