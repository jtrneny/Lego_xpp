CREATE TABLE zmajuz_ ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CDENIK Char( 2 ),
      NDOKLAD Numeric( 11 ,0 ),
      NORDITEM Integer,
      NINVCIS Numeric( 11 ,0 ),
      CNAZEV Char( 30 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NDRPOHYB Integer,
      NKARTA Short,
      NTYPPOHYB Short,
      DDATZMENY Date,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NPORZMENY Integer,
      NCISLODL Numeric( 11 ,0 ),
      NCISFAK Numeric( 11 ,0 ),
      CVARSYM Char( 15 ),
      NKUSY Short,
      NMNOZSTVI Numeric( 10 ,2 ),
      CZKRATJEDN Char( 3 ),
      NCENAVSTU Numeric( 14 ,2 ),
      NOPRUCT Numeric( 14 ,2 ),
      NZUSTCENAU Numeric( 14 ,2 ),
      NUCTODPMES Numeric( 10 ,2 ),
      NZMENVSTCU Numeric( 14 ,2 ),
      NZMENOPRU Numeric( 14 ,2 ),
      NZMENVSTCD Numeric( 14 ,2 ),
      NZMENOPRD Numeric( 14 ,2 ),
      CUSERABB Char( 8 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NCENAPORUO Numeric( 14 ,2 ),
      NCENAPORDO Numeric( 14 ,2 ),
      NDOTACEUO Numeric( 14 ,2 ),
      NDOTACEDO Numeric( 14 ,2 ),
      NCENAVSTUO Numeric( 14 ,2 ),
      NCENAVSTDO Numeric( 14 ,2 ),
      NOPRUCTO Numeric( 14 ,2 ),
      NOPRDANO Numeric( 14 ,2 ),
      NPROCDANOO Numeric( 7 ,2 ),
      NDANODPRO Numeric( 12 ,2 ),
      NPROCUCTOO Numeric( 7 ,2 ),
      NUCTODPRO Numeric( 12 ,2 ),
      NUCTODPMO Numeric( 10 ,2 ),
      NZNAKTO Short,
      NZNAKTDO Short,
      COBDZVYSO Char( 5 ),
      NLIKCELDOK Numeric( 14 ,2 ),
      CNAZPOL1_N Char( 8 ),
      CNAZPOL4_N Char( 8 ),
      NZVIRKAT_N Integer,
      NDOKL183 Integer,
      NCENAPORUN Numeric( 14 ,2 ),
      NCENAPORDN Numeric( 14 ,2 ),
      NDOTACEUN Numeric( 14 ,2 ),
      NDOTACEDN Numeric( 14 ,2 ),
      NCENAVSTUN Numeric( 14 ,2 ),
      NCENAVSTDN Numeric( 14 ,2 ),
      NOPRUCTN Numeric( 14 ,2 ),
      NOPRDANN Numeric( 14 ,2 ),
      NPROCDANON Numeric( 7 ,2 ),
      NDANODPRN Numeric( 12 ,2 ),
      NPROCUCTON Numeric( 7 ,2 ),
      NUCTODPRN Numeric( 12 ,2 ),
      NUCTODPMN Numeric( 10 ,2 ),
      NZNAKTN Short,
      NZNAKTDN Short,
      COBDZVYSN Char( 5 ),
      NKLIKVID Numeric( 14 ,2 ),
      NZLIKVID Numeric( 14 ,2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      sID AutoInc) IN DATABASE;
EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ1',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ2',
   'UPPER(COBDOBI)+STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ3',
   'STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ4',
   'UPPER(CDENIK)+ STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ5',
   'NKARTA',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ6',
   'STRZERO(NROK,4) + STRZERO(NOBDOBI,2) + STRZERO(NDRPOHYB,5)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ7',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NDRPOHYB,5)',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ8',
   'NDOKLAD',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ZMAJUZ9',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+ STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   10,
   512,
   '' ); 


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz_',
   'zmajuz_.adi',
   'ID',
   'sID',
   '',
   2,
   512,
   '' ); 


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajuz_', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmajuzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajuz_', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmajuzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajuz_', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmajuzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajuz_', 
   'Table_Trans_Free', 
   'False', 'APPEND_FAIL', 'zmajuzfail');

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CULOHA', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CTYPDOKLAD', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CTYPPOHYBU', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CDENIK', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDOKLAD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NORDITEM', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NINVCIS', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZEV', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NUCETSKUP', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CUCETSKUP', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDRPOHYB', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NKARTA', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NTYPPOHYB', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'DDATZMENY', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'COBDOBI', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NROK', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NOBDOBI', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NPORZMENY', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCISLODL', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCISFAK', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CVARSYM', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NKUSY', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NMNOZSTVI', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CZKRATJEDN', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAVSTU', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NOPRUCT', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZUSTCENAU', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NUCTODPMES', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZMENVSTCU', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZMENOPRU', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZMENVSTCD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZMENOPRD', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CUSERABB', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL1', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL2', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL3', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL4', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL5', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL6', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAPORUO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAPORDO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDOTACEUO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDOTACEDO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAVSTUO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAVSTDO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NOPRUCTO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NOPRDANO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NPROCDANOO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDANODPRO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NPROCUCTOO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NUCTODPRO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NUCTODPMO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZNAKTO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZNAKTDO', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'COBDZVYSO', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NLIKCELDOK', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL1_N', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'CNAZPOL4_N', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZVIRKAT_N', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDOKL183', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAPORUN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAPORDN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDOTACEUN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDOTACEDN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAVSTUN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NCENAVSTDN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NOPRUCTN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NOPRDANN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NPROCDANON', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NDANODPRN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NPROCUCTON', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NUCTODPRN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NUCTODPMN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZNAKTN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZNAKTDN', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'COBDZVYSN', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NKLIKVID', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'NZLIKVID', 'Field_Default_Value', 
      '0', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'DVZNIKZAZN', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

EXECUTE PROCEDURE sp_ModifyFieldProperty ( 'zmajuz_', 
      'DZMENAZAZN', 'Field_Default_Value', 
      ' ', 'APPEND_FAIL', 'zmajuzfail' ); 

