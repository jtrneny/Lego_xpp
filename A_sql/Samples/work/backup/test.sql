CREATE TABLE audit ( 
      TableName Char( 25 ),
      Type Char( 10 ),
      Entry_Date_Time TimeStamp,
      User_Name Char( 15 ),
      Changes Memo) IN DATABASE;
EXECUTE PROCEDURE sp_ModifyTableProperty( 'audit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'auditfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'audit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'auditfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'audit', 
   'Table_Memo_Block_Size', 
   '512', 'APPEND_FAIL', 'auditfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'audit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'auditfail');

