ALTER TRIGGER t_OSB_osoby_afterInsert
   ON osoby
   AFTER 
   INSERT 
BEGIN
 UPDATE osoby SET tvznikZazn = Date(), tvznikZazn = Now()  ;

END 
   PRIORITY 1;