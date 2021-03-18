CREATE TABLE pvp_item ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CTYPDOKLAD Char( 10 ),
      NTYPPOH Short,
      NDOKLAD Numeric( 11 ,0 ),
      NORDITEM Integer,
      NMNOZPRD_O Numeric( 16 ,4 ),
      NMNOZPRD_N Numeric( 16 ,4 ),
      NMNOZDZBO Numeric( 16 ,4 ),
      NMNOZSZBO Numeric( 16 ,4 ),
      NTYPZMENY Integer,
      CTYPRECORD Char( 1 ),
      sID AutoInc,
      iZMENA ModTime) IN DATABASE;

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvp_item', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pvp_itemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvp_item', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pvp_itemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvp_item', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pvp_itemfail');

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'pvp_item', 
      'NORDITEM', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'pvp_itemfail' ); 

