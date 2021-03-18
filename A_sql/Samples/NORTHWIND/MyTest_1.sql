DECLARE strLocal String;
DECLARE str2 String;
DECLARE acVar3 Char(20), dtVal Date;
DECLARE dBirthDate TimeStamp;

strLocal = 'abc';
str2 = strLocal + 'def';
acVar3 = str2 + strLocal;
dBirthDate = ( SELECT BirthDate FROM employees WHERE EmployeeID = 6 );
dtVal      = ( SELECT CONVERT(BirthDate,SQL_DATE) FROM employees WHERE EmployeeID = 3 ); 

str2 = 'x';

*
**
DECLARE iCount Integer;
DECLARE cursor1 CURSOR As select * from test;

OPEN cursor1;

while fetch cursor1 do
  if (cursor1.val = 0) or (cursor1.val > 50) then
    CONTINUE;
  endif;
  
  iCount = 1;
  
  while iCount <= 50 do 
    if cursor1.val * iCount > 50 then
	  LEAVE;
	endif; 
	
    INSERT INTO results VALUES(cursor1.val, iCount, cursor1.val * icount);
	iCount = iCount +1;
  endwhile;
endWhile;
  		
*
**		 
DECLARE bExpeced Logical;
DECLARE strTableName String;
DECLARE cursor1 CURSOR;

strTableName = 'orders';

OPEN cursor1 AS SELECT IIF( count(*) = 18, TRUE, FALSE) goodcnt
                FROM  system.columns
				WHERE parent = strTableName;
				
TRY
  if FETCH cursor1 then
    bExpeced = cursor1.goodcnt; 
  else
    bExpeced = FALSE;
  endif;
FINALLY
  CLOSE cursor1;
ENDTRY;

if bExpeced = FALSE then
  RAISE Unexpeced_Table_Structure( 18, strTableName);
endif;  
  	
  	
	
				

  