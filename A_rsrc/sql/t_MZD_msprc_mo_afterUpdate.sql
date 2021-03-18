ALTER TRIGGER t_MZD_msprc_mo_afterUpdate
   ON msprc_mo
   AFTER 
   UPDATE 
BEGIN 
declare allColumns Cursor;
declare fieldName  Char( 25);
declare @stmt      Char(255);
declare snewVal Char(500), soldVal Char(500);

Open allColumns as select * from system.columns 
                   where parent = 'msprc_mo' and Field_Type <> 5 and 
				         not ( lower(Name) = 'dvznikzazn' or lower(Name) = 'dzmenazazn' );
						 
						 
while fetch allColumns do
  fieldName = allColumns.Name;

  @stmt     = 'SELECT n.' +fieldName + ' newVal,'
              +      'o.' +fieldName + ' oldVal '
              + 'INTO #MyTrigTable '
              + 'FROM __new n, __old o';

  EXECUTE IMMEDIATE @stmt;

  snewVal = convert( ( SELECT newVal FROM #myTrigTable), SQL_CHAR);
  soldVal = convert( ( SELECT oldVal FROM #myTrigTable), SQL_CHAR);

  IF snewVal <> soldVal THEN
    INSERT INTO AsysAudit ( ctask, ctable, id, cfield, moldValue, mnewValue, tvznikZazn )
           SELECT           'MZD'                      , 
                            'MSPRC_MO'                 , 
                            sid                        , 
                            subString(fieldName, 1, 10), 
                            soldVal                    ,
                            snewVal                    ,
                            Now()
           FROM  __new;
  END;

  DROP TABLE #myTrigTable;
End While;
CLOSE AllColumns;

END 
   PRIORITY 1;