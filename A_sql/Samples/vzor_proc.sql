EXECUTE PROCEDURE sp_ModifyTableProperty( 'audit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'auditfail');
