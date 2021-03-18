DROP TRIGGER AuditTrail_AfterUpdate;


  
/*
*  Trigger for creating an Audit Trail. 
*/     
CREATE TRIGGER AuditTrail_AfterUpdate
   ON customers
   AFTER 
   UPDATE 
   FUNCTION AuditTrail
   IN LIBRARY [..\delphi\audit_trail\AuditTrig.dll]
   PRIORITY 1;   

