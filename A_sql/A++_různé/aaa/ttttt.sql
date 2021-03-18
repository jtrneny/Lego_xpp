CREATE TABLE majz_ ( 
      NINVCIS Numeric( 11 ,0 ),
      NZVIRKAT Integer,
      LHMOTNYIM Logical,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CTYPSKP Char( 15 ),
      NODPISKD Short,
      CODPISKD Char( 4 ),
      NODPISK Short,
      NROKYODPID Short,
      NMESODPID Short,
      NTYPDODPI Short,
      NTYPUODPI Short,
      NROKYODPIU Short,
      CNAZEV Char( 30 ),
      NMESODPIUZ Short,
      NTYPVYPUO Short,
      NTROBOR Integer,
      NZNAKT Integer,
      NDOKLAD Numeric( 11 ,0 ),
      NZNAKTD Short,
      NDRPOHYB Integer,
      DDATPOR Date,
      CTYPPOHYBU Char( 10 ),
      DDATZAR Date,
      COBDZAR Char( 5 ),
      DDATVYRAZ Date,
      COBDVYRAZ Char( 5 ),
      DDATZVYS Date,
      COBDZVYS Char( 5 ),
      NROKYDANOD Short,
      NROKZVDANO Short,
      NKUSY Short,
      NMNOZSTVI Numeric( 10 ,2 ),
      CZKRATJEDN Char( 3 ),
      NCENAVSTU Numeric( 14 ,2 ),
      NCENAVSTD Numeric( 14 ,2 ),
      NOPRUCT Numeric( 14 ,2 ),
      NOPRDAN Numeric( 14 ,2 ),
      NOPRUCTPS Numeric( 14 ,2 ),
      NOPRDANPS Numeric( 14 ,2 ),
      NPROCDANOD Numeric( 7 ,2 ),
      NDOTACEUCT Numeric( 14 ,2 ),
      NDOTACEDAN Numeric( 14 ,2 ),
      NCENAPORU Numeric( 14 ,2 ),
      NCENAPORD Numeric( 14 ,2 ),
      NDANODPROK Numeric( 12 ,2 ),
      NPROCUCTOD Numeric( 7 ,2 ),
      NUCTODPROK Numeric( 12 ,2 ),
      NUCTODPMES Numeric( 10 ,2 ),
      NPOCMESUO Short,
      NPOCMESDO Short,
      NUPLPROC Numeric( 6 ,2 ),
      NUPLHODN Numeric( 11 ,2 ),
      NROKUPL Short,
      CKLICODMIS Char( 8 ),
      COBDPOSODP Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MPOPIS Memo,
      NDOKLPREV Integer,
      CODPISK Char( 4 ),
      CVARSYM Char( 15 ),
      NCISFAK Numeric( 11 ,0 ),
      NZPUODPIS Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      sID AutoInc) IN DATABASE;
EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_01',
   'STRZERO(NUCETSKUP,3) + STRZERO( NINVCIS,10)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_02',
   'NINVCIS',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_03',
   'UPPER( CNAZEV)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_04',
   'UPPER( CTYPSKP) + STRZERO(NUCETSKUP,3)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_09',
   'NTYPUODPI',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_10',
   'NROKYODPIU',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_11',
   'NDOKLPREV',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_05',
   'STRZERO(NODPISKD,2) + STRZERO( NINVCIS,10)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_06',
   'STRZERO(NODPISKD,2) + STRZERO( NUCETSKUP,3)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_07',
   'STRZERO(NODPISKD,2) + UPPER( CTYPSKP)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'MAJZ_08',
   'UPPER( CTYPSKP) + STRZERO(NODPISKD,2)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_',
   'majz_.adi',
   'ID',
   'sID',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz_', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz_', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz_', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz_', 
   'Table_Trans_Free', 
   'False', 'APPEND_FAIL', 'majzfail');

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NINVCIS', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NZVIRKAT', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'LHMOTNYIM', 'Field_Default_Value', 
      'NO', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NUCETSKUP', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CUCETSKUP', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CTYPSKP', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NODPISKD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CODPISKD', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NODPISK', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NROKYODPID', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NMESODPID', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NTYPDODPI', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NTYPUODPI', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NROKYODPIU', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CNAZEV', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NMESODPIUZ', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NTYPVYPUO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NTROBOR', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NZNAKT', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NDOKLAD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NZNAKTD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NDRPOHYB', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'DDATPOR', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CTYPPOHYBU', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'DDATZAR', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'COBDZAR', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'DDATVYRAZ', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'COBDVYRAZ', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'DDATZVYS', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'COBDZVYS', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NROKYDANOD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NROKZVDANO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NKUSY', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NMNOZSTVI', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CZKRATJEDN', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NCENAVSTU', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NCENAVSTD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NOPRUCT', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NOPRDAN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NOPRUCTPS', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NOPRDANPS', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NPROCDANOD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NDOTACEUCT', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NDOTACEDAN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NCENAPORU', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NCENAPORD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NDANODPROK', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NPROCUCTOD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NUCTODPROK', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NUCTODPMES', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NPOCMESUO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NPOCMESDO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NUPLPROC', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NUPLHODN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NROKUPL', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CKLICODMIS', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'COBDPOSODP', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CNAZPOL1', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CNAZPOL2', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_',
       'CNAZPOL3', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CNAZPOL4', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CNAZPOL5', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CNAZPOL6', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NDOKLPREV', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CODPISK', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'CVARSYM', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NCISFAK', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'NZPUODPIS', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'DVZNIKZAZN', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'majz_', 
      'DZMENAZAZN', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'majzfail' ); 

