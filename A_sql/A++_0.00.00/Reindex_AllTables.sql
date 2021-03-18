CREATE PROCEDURE 
     sp_PackAllTables
   ( 
      TableName Char ( 255 ) OUTPUT,
      PackResult Char ( 10 ) OUTPUT
   ) 
   BEGIN 
       
DECLARE allTables CURSOR; 
DECLARE strSQL CHAR(250); 

OPEN allTables AS SELECT * FROM system.tables; //Open cursor with all tables. 

WHILE FETCH allTables DO
  TRY 

    strSQL = 'EXECUTE PROCEDURE sp_PackTable( ''' + trim(allTables.Name) + ''' ) '; 
    EXECUTE IMMEDIATE strSQL; 
    INSERT INTO __output Values(allTables.Name, 'Success'); 
    CATCH ALL 
    INSERT INTO __output Values(allTables.Name, 'Failure'); 
    CONTINUE; 
  END TRY; 
END WHILE; 
CLOSE allTables; 

END;

