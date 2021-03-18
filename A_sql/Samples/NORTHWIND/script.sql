
/*************************************************************
 *   Scripting: 
 *
 *
 *
 *************************************************************/
/*----------------------------------- 
  Traditional Script				  
*-----------------------------------*/  
 INSERT INTO shippers( CompanyName, Phone) VALUES ( 'UPS', '(503) 555-9832');
 INSERT INTO shippers( CompanyName, Phone) VALUES ( 'DHL', '(503) 555-9832');
 INSERT INTO shippers( CompanyName, Phone) VALUES ( 'FedEx', '(503) 555-9832');
 SELECT * FROM shippers;
 
 
/*----------------------------------- 
  Variable Declaration
*-----------------------------------*/ 
DECLARE stext char(100);
DECLARE i integer;
 
  i=42;
  stext='hello world';
 
  SELECT i AS i, rtrim(stext) AS stext FROM system.iota;
 
/*----------------------------------- 
 * WHILE/IF 
 *----------------------------------*/
DECLARE iCount Integer;
DECLARE cursor1 CURSOR AS SELECT shipname FROM invoices;

  OPEN cursor1;
  iCount = 0;

  WHILE FETCH cursor1 DO
    IF cursor1.shipname IS NOT NULL THEN
      iCount = iCount + 1;
  ENDIF;
  END WHILE;

  SELECT iCount FROM system.iota;

/*-----------------------------------
 * TRY-CATCH
 *----------------------------------*/
TRY
  CREATE TABLE #tmp(id AUTOINC, lastname CHAR(50)); 
CATCH ALL
  DROP TABLE #tmp;
  CREATE TABLE #tmp(id AUTOINC, lastname CHAR(50)); 
END TRY; 

SELECT * FROM #tmp;


/*-----------------------------------
 * STORED PROCEDURE
 *----------------------------------*/

TRY
DROP PROCEDURE AddRecordToProducts;
CATCH ALL
END TRY;


CREATE PROCEDURE AddRecordToProducts
( productname  CHAR(20), 
  SupplierID SHORT,
  CategoryID SHORT )
BEGIN
   INSERT INTO PRODUCTS( productname, SupplierID, CategoryID ) 
   		  SELECT * FROM __input;
END;

EXECUTE PROCEDURE AddRecordToProducts('Mom''s Mustard', 1, 1)



/*-----------------------------------
 * STORED PROCEDURE: PACK ALL TABLES
 *----------------------------------*/

TRY
  DROP PROCEDURE sp_PackDD;
CATCH ALL
END TRY;

CREATE PROCEDURE sp_PackDD( success Logical OUTPUT, tablename Char(20) OUTPUT) BEGIN 
   DECLARE tname String, tpath String; 
   DECLARE cursor1 Cursor AS SELECT * FROM system.tables; 
   OPEN cursor1; 
   WHILE FETCH cursor1 DO 
      tname = cursor1.Name; 
      tname = RTRIM(tname); 
      TRY 
         EXECUTE PROCEDURE sp_PackTable( tname ); 
         INSERT INTO __output(success, tablename) VALUES(TRUE, tname); 
		 
	--	 insert into __output SELECt * FROM table
      CATCH ALL 
         INSERT INTO __output(success, tablename) VALUES(FALSE, tname); 
      END; 
   END;
   CLOSE cursor1;
END; 

EXECUTE PROCEDURE sp_PackDD();


