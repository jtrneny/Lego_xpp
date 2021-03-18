ALTER TRIGGER t_MZD_msprc_mo_afterInsert
   ON msprc_mo
   AFTER 
   INSERT 
BEGIN 
 UPDATE msprc_mo SET tvznikZazn = Date(), tvznikZazn = Now() ;

END 
   PRIORITY 1;