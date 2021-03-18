DROP TRIGGER Backup_AfterInsert;
DROP TRIGGER Backup_AfterUpdate;
DROP TRIGGER Backup_AfterDelete;


 
/*
*  Trigger for executing inserts, updates and deletes to 
*  another server. 
*/   

CREATE TRIGGER Backup_AfterInsert
   ON customers
   AFTER 
   INSERT 
   FUNCTION Backup
   IN LIBRARY [..\delphi\backup\BackupTrig.dll]
   PRIORITY 1;

  
CREATE TRIGGER backup_AfterUpdate
   ON customers
   AFTER 
   UPDATE 
   FUNCTION Backup
   IN LIBRARY [..\delphi\backup\BackupTrig.dll]
   PRIORITY 1;

CREATE TRIGGER backup_AfterDelete
   ON customers
   AFTER 
   DELETE 
   FUNCTION Backup
   IN LIBRARY [..\delphi\backup\BackupTrig.dll]
   PRIORITY 1;

