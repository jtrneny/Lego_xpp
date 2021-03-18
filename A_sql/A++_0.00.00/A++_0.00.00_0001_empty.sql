CREATE DATABASE "A++_000000" ENCRYPT False;
EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Version_Major',
        '0'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Version_Minor',
        '1'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Default_Table_Path',
        '.\'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Temp_Table_Path',
        '.\'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Log_In_Required',
        'False'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Verify_Access_Rights',
        'False'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Encrypt_Table_Password',
        'V73ra5-xWdeYa46í8øK2'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Encrypt_New_Table',
        'False'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Enable_Internet',
        'False'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Internet_Security_Level',
        '2'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Max_Failed_Attempts',
        '5'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Logins_Disabled',
        'False'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Logins_Disabled_Msg',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Comment',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'User_Defined_Prop',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'FTS_Delimiters',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'FTS_Noise_Words',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'FTS_Drop_Chars',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'FTS_Conditional_Chars',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Encrypt_Indexes',
        'False'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Query_Log_Table',
        ''
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Encrypt_Communication',
        'False'
      );

EXECUTE PROCEDURE
   sp_ModifyDatabase
      (
        'Disable_DLL_Caching',
        'False'
      );

CREATE TABLE asysact ( 
      CUSER Char( 10 ),
      CGROUP Char( 10 ),
      CIDOBJECT Char( 10 ),
      COPRAVNENI Char( 10 ),
      LDISTRIB Logical,
      LDEALER Logical,
      LBEGACT Logical,
      LENDACT Logical,
      LNEWACT Logical,
      LDELACT Logical,
      LMODACT Logical,
      LSAVACT Logical,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'ASYSACT01',
   'UPPER(CIDOBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'ASYSACT02',
   'UPPER(CUSER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'ASYSACT03',
   'UPPER(CGROUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'ASYSACT04',
   'UPPER(CIDOBJECT)+UPPER(CUSER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'ASYSACT05',
   'UPPER(CIDOBJECT)+UPPER(CGROUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'ASYSACT06',
   'UPPER(CUSER)+UPPER(CIDOBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'ASYSACT07',
   'UPPER(CGROUP)+UPPER(CIDOBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysact',
   'asysact.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysact', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'asysactfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysact', 
   'Table_Encryption', 
   'True', 'APPEND_FAIL', 'asysactfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysact', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'asysactfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysact', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'asysactfail');

CREATE TABLE asysini ( 
      CUSER Char( 10 ),
      CPARENT Char( 50 ),
      CZKROBJECT Char( 50 ),
      CFILE Char( 10 ),
      MBROWSE Memo,
      CTYPOBJECT Char( 10 ),
      CTASK Char( 3 ),
      DDAT_FRM Date,
      CCAS_FRM Char( 8 ),
      ACT_FILTRS Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'asysini',
   'asysini.adi',
   'ASYSINI01',
   'UPPER(CUSER)+UPPER(CPARENT)+UPPER(CZKROBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysini',
   'asysini.adi',
   'ASYSINI02',
   'UPPER(CUSER)+UPPER(CPARENT)+UPPER(CZKROBJECT) +UPPER(CFILE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysini',
   'asysini.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysini', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'asysinifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysini', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'asysinifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysini', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'asysinifail');

CREATE TABLE asysprhd ( 
      NIDPRIPOM Double( 0 ),
      CIDPRIPOM Char( 16 ),
      NORDITEM Integer,
      CVERZE Char( 15 ),
      CTASK Char( 3 ),
      CTYPPRIPOM Char( 10 ),
      NPRIPRIPOM Short,
      NSTAPRIPOM Short,
      CUSER Char( 10 ),
      COSOBA Char( 30 ),
      DZACPRIPOM Date,
      DKONPRIPOM Date,
      CPRIPOMINK Char( 50 ),
      MPRIPOMINK Memo,
      CUSRVYJADR Char( 10 ),
      COSOVYJADR Char( 30 ),
      DPOZVYJADR Date,
      DZACVYJADR Date,
      DKONVYJADR Date,
      DVYJADRENI Date,
      MVYJADRENI Memo,
      CUSRRESENI Char( 10 ),
      COSORESENI Char( 30 ),
      CVERRESENI Char( 15 ),
      DPOZRESENI Date,
      DZACRESENI Date,
      DKONRESENI Date,
      MRESENI Memo,
      CUSRTEST Char( 10 ),
      COSOTEST Char( 30 ),
      CVERTEST Char( 15 ),
      DPOZTEST Date,
      DZACTEST Date,
      DKONTEST Date,
      MTEST Memo,
      NRECFILTRS Short,
      NIDUZIVSW Integer,
      NUSRIDDB Integer,
      CNAZFIRMY Char( 100 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD01',
   'UPPER(CIDPRIPOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD02',
   'NIDPRIPOM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD03',
   'UPPER(CTASK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD04',
   'NRECFILTRS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprhd',
   'asysprhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysprhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'asysprhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysprhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'asysprhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysprhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'asysprhdfail');

CREATE TABLE asysprit ( 
      NIDPRIPOM Double( 0 ),
      CIDPRIPOM Char( 16 ),
      NORDITEM Integer,
      CVERZE Char( 15 ),
      CTASK Char( 3 ),
      CTYPPRIPOM Char( 10 ),
      NPRIPRIPOM Short,
      NSTAPRIPOM Short,
      CUSER Char( 10 ),
      COSOBA Char( 30 ),
      DZACPRIPOM Date,
      DKONPRIPOM Date,
      CPRIPOMINK Char( 50 ),
      MPRIPOMINK Memo,
      CUSRVYJADR Char( 10 ),
      COSOVYJADR Char( 30 ),
      DPOZVYJADR Date,
      DZACVYJADR Date,
      DKONVYJADR Date,
      DVYJADRENI Date,
      MVYJADRENI Memo,
      CUSRRESENI Char( 10 ),
      COSORESENI Char( 30 ),
      CVERRESENI Char( 15 ),
      DPOZRESENI Date,
      DZACRESENI Date,
      DKONRESENI Date,
      MRESENI Memo,
      CUSRTEST Char( 10 ),
      COSOTEST Char( 30 ),
      CVERTEST Char( 15 ),
      DPOZTEST Date,
      DZACTEST Date,
      DKONTEST Date,
      MTEST Memo,
      NRECFILTRS Short,
      NIDUZIVSW Integer,
      NUSRIDDB Integer,
      CNAZFIRMY Char( 100 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprit',
   'asysprit.adi',
   'ASYSPRIT01',
   'UPPER(CIDPRIPOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprit',
   'asysprit.adi',
   'ASYSPRIT02',
   'NIDPRIPOM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprit',
   'asysprit.adi',
   'ASYSPRIT03',
   'UPPER(CTASK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysprit',
   'asysprit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysprit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'asyspritfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysprit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'asyspritfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysprit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'asyspritfail');

CREATE TABLE asystem ( 
      CIDOBJECT Char( 10 ),
      CTYPOBJECT Char( 10 ),
      CZKROBJECT Char( 25 ),
      CNAMEOBJ Char( 100 ),
      CCAPTION Char( 50 ),
      CPRGOBJECT Char( 150 ),
      MOBJECT Memo,
      MBROWSE Memo,
      MPOPISOBJ Memo,
      CTASK Char( 3 ),
      CUSER Char( 10 ),
      MMETODIKA Memo,
      NSYSACT Short,
      LOBDREPORT Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM01',
   'UPPER(CZKROBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM02',
   'UPPER(CUSER)+UPPER(CZKROBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM03',
   'UPPER(CTYPOBJECT)+UPPER(CZKROBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM04',
   'UPPER(CIDOBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM05',
   'UPPER(CNAMEOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM06',
   'UPPER(CTASK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM07',
   'UPPER(CPRGOBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'ASYSTEM08',
   'NSYSACT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asystem',
   'asystem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'asystem', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'asystemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asystem', 
   'Table_Encryption', 
   'True', 'APPEND_FAIL', 'asystemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asystem', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'asystemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asystem', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'asystemfail');

CREATE TABLE asysver ( 
      CVERZE Char( 15 ),
      NVERZE Double( 0 ),
      DPLANVER Date,
      DVZNIKVER Date,
      DSTAZVER Date,
      CUSRINSVER Date,
      DINSTALVER Date,
      MPOPISPLAN Memo,
      MPOPISVER Memo,
      NTYPVER Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'asysver',
   'asysver.adi',
   'ASYSVER01',
   'UPPER(CVERZE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysver',
   'asysver.adi',
   'ASYSVER02',
   'NVERZE',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysver',
   'asysver.adi',
   'ASYSVER03',
   'NTYPVER',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysver',
   'asysver.adi',
   'ASYSVER04',
   'DTOS(DPLANVER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysver',
   'asysver.adi',
   'ASYSVER05',
   'DTOS(DVZNIKVER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'asysver',
   'asysver.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysver', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'asysverfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysver', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'asysverfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'asysver', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'asysverfail');

CREATE TABLE atribop ( 
      CTYPOPER Char( 3 ),
      CATRIBOPER Char( 4 ),
      CPOZNAMKA Char( 30 ),
      CZMENA Char( 8 ),
      DZMENA Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'atribop',
   'atribop.adi',
   'ATRIBOP1',
   'UPPER(CTYPOPER) +UPPER(CATRIBOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'atribop',
   'atribop.adi',
   'ATRIBOP2',
   'UPPER(CATRIBOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'atribop',
   'atribop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'atribop', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'atribopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'atribop', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'atribopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'atribop', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'atribopfail');

CREATE TABLE autom_hd ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NTYP_AUT Short,
      NSUB_AUT Short,
      CNAZ_AUT Char( 25 ),
      LSET_AUT Logical,
      CNAZPOL Char( 10 ),
      CNAZPOLX Char( 8 ),
      LTYP_NV Logical,
      CNAKLUC_NV Char( 250 ),
      CPRODUC_NV Char( 250 ),
      CUCTYUC_NV Char( 250 ),
      CREZIUC_VR Char( 250 ),
      CNAKLUC_VR Char( 250 ),
      CVYNOUC_VR Char( 250 ),
      CZAKLUC_VR Char( 250 ),
      CROZPUC_VR Char( 250 ),
      CREZIUC_SR Char( 250 ),
      CNAKLUC_SR Char( 250 ),
      CVYNOUC_SR Char( 250 ),
      CZAKLUC_SR Char( 250 ),
      CROZPUC_SR Char( 250 ),
      CREZIUC_ZR Char( 250 ),
      CNAKLUC_ZR Char( 250 ),
      CVYNOUC_ZR Char( 250 ),
      CZAKLUC_ZR Char( 250 ),
      CROZPUC_ZR Char( 250 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'autom_hd',
   'autom_hd.adi',
   'AUTOHD01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTYP_AUT,1) +STRZERO(NSUB_AUT,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'autom_hd',
   'autom_hd.adi',
   'AUTOHD02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTYP_AUT,1) +IF (LSET_AUT, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'autom_hd',
   'autom_hd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'autom_hd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'autom_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'autom_hd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'autom_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'autom_hd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'autom_hdfail');

CREATE TABLE autom_it ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NTYP_AUT Short,
      NSUB_AUT Short,
      CNAZPOL_OD Char( 8 ),
      CNAZPOL_DO Char( 8 ),
      CMROZP_CO Char( 250 ),
      CMROZP_KAM Char( 250 ),
      CUCET_MD Char( 6 ),
      CUCET_DAL Char( 6 ),
      CROZP__STR Char( 8 ),
      CROZP___CO Char( 8 ),
      LUKONCENO Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'autom_it',
   'autom_it.adi',
   'AUTOIT01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTYP_AUT,1) +STRZERO(NSUB_AUT,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'autom_it',
   'autom_it.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'autom_it', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'autom_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'autom_it', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'autom_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'autom_it', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'autom_itfail');

CREATE TABLE banky_abo ( 
      CKODBAN_CR Char( 4 ),
      CCISPOB_KM Char( 3 ),
      CCISKLI_KM Char( 10 ),
      CNAZKLI_KM Char( 20 ),
      CZKRKLI_KM Char( 4 ),
      NCISSTA_KM Integer,
      CPEVKOD_KM Char( 6 ),
      CNAZTAB_KM Char( 40 ),
      CPATEXP_KM Char( 150 ),
      CPATIMP_KM Char( 150 ),
      CNEXRUN_KM Char( 150 ),
      NFILEOD_KM Short,
      NFILEDO_KM Short,
      CTYPMED_KM Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'banky_abo',
   'banky_abo.adi',
   'BANABO01',
   'UPPER(CKODBAN_CR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banky_abo',
   'banky_abo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'banky_abo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'banky_abofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banky_abo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'banky_abofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banky_abo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'banky_abofail');

CREATE TABLE banky_cr ( 
      CKODBAN_CR Char( 4 ),
      CNAZBAN_CR Char( 100 ),
      LISSET_ABO Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'banky_cr',
   'banky_cr.adi',
   'BANNYCR1',
   'UPPER(CKODBAN_CR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banky_cr',
   'banky_cr.adi',
   'BANKYCR2',
   'UPPER(CNAZBAN_CR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banky_cr',
   'banky_cr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'banky_cr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'banky_crfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banky_cr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'banky_crfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banky_cr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'banky_crfail');

CREATE TABLE banvyphd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      COBDOBIDAN Char( 5 ),
      CZKRATMENY Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      DDATPORIZ Date,
      CBANK_UCT Char( 25 ),
      CBANK_NAZ Char( 25 ),
      NCISPOVYP Integer,
      NPOCPOLOZ Short,
      DDATPOVYP Date,
      NPOSZUST Double( 2 ),
      NPRIJEM Double( 2 ),
      NVYDEJ Double( 2 ),
      NZUSTATEK Double( 2 ),
      DDATZUST Date,
      NPRIJEMZ Double( 2 ),
      NVYDEJZ Double( 2 ),
      NKURZROZS Double( 2 ),
      NPOPLOSTS Double( 2 ),
      DDATTISK Date,
      CUCET_UCT Char( 6 ),
      CPRIZLIKV Char( 1 ),
      DPOSLIKVYP Date,
      NLIKCELPRI Double( 2 ),
      NLIKCELVYD Double( 2 ),
      NCISUZV Short,
      DDATUZV Date,
      CDENIK Char( 2 ),
      CDENIK_PUC Char( 2 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CNAZPOL1U Char( 8 ),
      CNAZPOL2U Char( 8 ),
      CNAZPOL3U Char( 8 ),
      CNAZPOL4U Char( 8 ),
      CNAZPOL5U Char( 8 ),
      CNAZPOL6U Char( 8 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_1',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_2',
   'UPPER(CBANK_UCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_3',
   'NCISPOVYP',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_4',
   'STRZERO(NDOKLAD,10) +UPPER(CBANK_UCT) +STRZERO(NCISPOVYP,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_5',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_6',
   'UPPER(CBANK_UCT) +STRZERO(NCISPOVYP,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_7',
   'UPPER(CBANK_UCT) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_8',
   'STRZERO(NROK,4)  +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_9',
   'UPPER(CBANK_UCT) +STRZERO(NROK,4) +STRZERO(NCISPOVYP,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP10',
   'UPPER(CDENIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP11',
   'STRZERO(NICO,8)  +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP12',
   'UPPER(CDENIK)    +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP13',
   'STRZERO(NROK,4)  +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvyphd',
   'banvyphd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'banvyphd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'banvyphdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banvyphd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'banvyphdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banvyphd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'banvyphdfail');

CREATE TABLE banvypit ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CTYPOBRATU Char( 3 ),
      NTYPOBRATU Short,
      CZKRTYPFAK Char( 5 ),
      DDATUHRADY Date,
      NINTCOUNT Integer,
      NSUBCOUNT Short,
      NSUBCOUNTS Short,
      COBDOBIDAN Char( 5 ),
      CTEXT Char( 30 ),
      NPRIJEM Double( 2 ),
      NVYDEJ Double( 2 ),
      NPRIJEMZ Double( 2 ),
      NVYDEJZ Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NLIKPOLBAV Double( 2 ),
      NCENZAHCEL Double( 2 ),
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      CZKRATMENB Char( 3 ),
      NKURZMENB Double( 8 ),
      NMNOZPREB Integer,
      DDATPORIZ Date,
      DSPLATFAK Date,
      CDOPLNTXT Char( 50 ),
      NUHRBANFAK Double( 2 ),
      NUHRBANFAZ Double( 2 ),
      CZKRATMENU Char( 3 ),
      NKURZMENU Double( 8 ),
      NMNOZPREU Integer,
      CZKRATMENK Char( 3 ),
      NKURZMENK Double( 8 ),
      CZKRATMENF Char( 3 ),
      NKURZMENF Double( 8 ),
      NMNOZPREF Integer,
      NCENZAKCEF Double( 2 ),
      NKURZROZDF Double( 2 ),
      CUCET_UCTK Char( 6 ),
      CTEXTK Char( 30 ),
      CNAZPOL1K Char( 8 ),
      CNAZPOL2K Char( 8 ),
      CNAZPOL3K Char( 8 ),
      CNAZPOL4K Char( 8 ),
      CNAZPOL5K Char( 8 ),
      CNAZPOL6K Char( 8 ),
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CUCET_UCT Char( 6 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      CDENIK Char( 2 ),
      CDENIK_PAR Char( 2 ),
      NDOKLAD_OR Double( 0 ),
      NCENZAK_OR Double( 2 ),
      NCENZAH_OR Double( 2 ),
      NKURZRO_OR Double( 2 ),
      NDOKLAD_IV Double( 0 ),
      CTREE_VIEW Char( 4 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_1',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5) +UPPER(CDENIK_PAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_2',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_3',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_4',
   'UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_5',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10) +DTOS (DDATUHRADY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_6',
   'UPPER(CDENIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_7',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'banvypit',
   'banvypit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'banvypit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'banvypitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banvypit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'banvypitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'banvypit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'banvypitfail');

CREATE TABLE barcod ( 
      NCISLPOH Integer,
      NCARKKOD Double( 0 ),
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CNAZZBO Char( 30 ),
      NZBOZIKAT Short,
      NKLICDPH Short,
      NMNOZPRDOD Double( 4 ),
      NMNOZSZBO Double( 4 ),
      NMNOZDZBO Double( 4 ),
      NCENAPZBO Double( 2 ),
      NCENAMZBO Double( 2 ),
      NCENASZBO Double( 2 ),
      CPOLCEN Char( 1 ),
      LLIKVID Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'barcod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'barcodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'barcod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'barcodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'barcod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'barcodfail');

CREATE TABLE bilance ( 
      CULOHA Char( 1 ),
      DPORIZFAK Date,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      CTEXTFAKT Char( 40 ),
      NKLICDPH Short,
      NOSVODDAN Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 18 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CUCET Char( 25 ),
      DVYSTFAKDO Date,
      DSPLATFAK Date,
      DVYSTFAK Date,
      DDATTISK Date,
      NPRIUHRCEL Double( 2 ),
      DDATPRIUHR Date,
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      NKURZROZDF Double( 2 ),
      DPOSUHRFAK Date,
      NPARZALFAK Double( 2 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      CBANK_UCT Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NCISDOBFAK Double( 0 ),
      DPOSLIKFAK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELFAK Double( 2 ),
      NCISUZV Short,
      DDATUZV Date,
      CDENIK Char( 2 ),
      CUCET_UCT Char( 6 ),
      CCISOBJ Char( 15 ),
      CJMENOPREV Char( 25 ),
      DDATPREVZ Date,
      DDATVRATIL Date,
      CZKRPRODEJ Char( 4 ),
      LDOVOZ Logical,
      NCELZAKL_1 Double( 2 ),
      NCELCLO_1 Double( 2 ),
      NCELSPD_1 Double( 2 ),
      NCELZAKL_2 Double( 2 ),
      NCELCLO_2 Double( 2 ),
      NCELSPD_2 Double( 2 ),
      NFINTYP Short,
      NDOKLAD Double( 0 ),
      MPOPISFAK Memo,
      NDNY_PREKS Integer,
      XULOHA Char( 1 ),
      XCISFAK Double( 0 ),
      XVARSYM Char( 15 ),
      XOBDOBI Char( 5 ),
      XROK Short,
      XNOBDOBI Short,
      XOBDOBIDAN Char( 5 ),
      XZKRTYPFAK Char( 5 ),
      XZKRTYPUHR Char( 5 ),
      XOSVODDAN Double( 2 ),
      XZAKLDAN_1 Double( 2 ),
      XSAZDAN_1 Double( 2 ),
      XZAKLDAN_2 Double( 2 ),
      XSAZDAN_2 Double( 2 ),
      XCENZAKCEL Double( 2 ),
      XCENDANCEL Double( 2 ),
      XZUSTPOZAO Double( 2 ),
      XKODZAOKR Short,
      XKODZAOKRD Short,
      XZKRATMENY Char( 3 ),
      XCENZAHCEL Double( 2 ),
      XZKRATMENZ Char( 3 ),
      XKURZAHMEN Double( 8 ),
      XMNOZPREP Integer,
      XKONSTSYMB Short,
      XSPECSYMB Char( 20 ),
      XCISFIRMY Integer,
      XNAZEV Char( 25 ),
      XNAZEV2 Char( 25 ),
      XICO Integer,
      XDIC Char( 16 ),
      XULICE Char( 25 ),
      XSIDLO Char( 25 ),
      XPSC Char( 6 ),
      XUCET Char( 25 ),
      XCISFIRDOA Integer,
      XNAZEVDOA Char( 25 ),
      XNAZEVDOA2 Char( 25 ),
      XULICEDOA Char( 25 ),
      XSIDLODOA Char( 25 ),
      XPSCDOA Char( 6 ),
      XPRIJEMCE1 Char( 15 ),
      XPRIJEMCE2 Char( 15 ),
      XZKRZPUDOP Char( 15 ),
      XSPLATFAK Date,
      XVYSTFAK Date,
      XPOVINFAK Date,
      XDATTISK Date,
      XPRIZLIKV Char( 1 ),
      XLIKCELFAK Double( 2 ),
      XPOSLIKFAK Date,
      XUHRCELFAK Double( 2 ),
      XUHRCELFAZ Double( 2 ),
      XKURZROZDF Double( 2 ),
      XPOSUHRFAK Date,
      XPARZALFAK Double( 2 ),
      XPARZAHFAK Double( 2 ),
      XDPARZALFA Date,
      XBANK_UCT Char( 25 ),
      XVNBAN_UCT Char( 25 ),
      XCISPENFAK Double( 0 ),
      XDATPENFAK Date,
      XPEN_ODB Double( 2 ),
      XCISUPOMIN Double( 0 ),
      XUPOMINKY Date,
      XCISDOBFAK Double( 0 ),
      XHLASFAK Logical,
      XCISOBJ Char( 15 ),
      XCISLOBINT Char( 15 ),
      XCISFAK_OR Double( 0 ),
      XTYPFAK_OR Char( 5 ),
      XCISUZV Short,
      XDATUZV Date,
      XTYPSLEVY Short,
      XPROCSLEV Double( 2 ),
      XPROCSLFAO Double( 1 ),
      XPROCSLHOT Double( 1 ),
      XHODNSLEV Double( 2 ),
      XCENAZAKL Double( 2 ),
      XKASA Short,
      XZKRPRODEJ Char( 4 ),
      XDENIK Char( 2 ),
      XUCET_UCT Char( 6 ),
      XZKRATSTAT Char( 3 ),
      XFINTYP Short,
      XKLICOBL Short,
      XDOKLAD Double( 0 ),
      XJMENOVYS Char( 25 ),
      XPOPISFAK Memo,
      XDOLFAKCIS Memo,
      XDNY_PREKS Integer,
      LIND_ZAP Logical,
      NPOR_ZAP Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'bilance',
   'bilance.adi',
   'BILNAN01',
   'STRZERO(NICO,8) +STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'bilance',
   'bilance.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'bilance', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'bilancefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'bilance', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'bilancefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'bilance', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'bilancefail');

CREATE TABLE c_aktiv ( 
      NZNAKAKT Short,
      CPOPISAKT Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_aktiv',
   'c_aktiv.adi',
   'C_AKTIV1',
   'NZNAKAKT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_aktiv',
   'c_aktiv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_aktiv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_aktivfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_aktiv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_aktivfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_aktiv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_aktivfail');

CREATE TABLE c_aktivd ( 
      NZNAKAKTD Short,
      CPOPISAKT Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_aktivd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_aktivdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_aktivd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_aktivdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_aktivd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_aktivdfail');

CREATE TABLE c_algrez ( 
      NALGREZIE Short,
      CPOPISALG Char( 60 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_algrez',
   'c_algrez.adi',
   'C_ALGREZ1',
   'NALGREZIE',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_algrez',
   'c_algrez.adi',
   'C_ALGREZ2',
   'UPPER(CPOPISALG)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_algrez',
   'c_algrez.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_algrez', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_algrezfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_algrez', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_algrezfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_algrez', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_algrezfail');

CREATE TABLE c_atrib ( 
      CATRIBOPER Char( 4 ),
      CPOPISATR Char( 30 ),
      CZKRATJEDN Char( 3 ),
      CKODATR Char( 2 ),
      CZMENA Char( 8 ),
      DZMENA Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_atrib',
   'c_atrib.adi',
   'C_ATRIB1',
   'UPPER(CATRIBOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_atrib',
   'c_atrib.adi',
   'C_ATRIB2',
   'UPPER(CPOPISATR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_atrib',
   'c_atrib.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_atrib', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_atribfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_atrib', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_atribfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_atrib', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_atribfail');

CREATE TABLE c_bankuc ( 
      CBANK_UCT Char( 25 ),
      CBANK_NAZ Char( 25 ),
      CZKRATMENY Char( 3 ),
      CBANK_POB Char( 20 ),
      CBANK_PSC Char( 6 ),
      CBANK_SID Char( 25 ),
      CBANK_ULI Char( 25 ),
      CBANK_TEL Char( 17 ),
      CBANK_FAX Char( 17 ),
      CBANK_MOD Char( 17 ),
      CBANKODPO Char( 25 ),
      CNAZ_UCT Char( 25 ),
      CUCET_UCT Char( 6 ),
      NCISPOVYP Integer,
      DDATPOVYP Date,
      NPOSZUST Double( 2 ),
      NPOCPOLPRI Short,
      CVNBAN_UCT Char( 25 ),
      LISMAIN Logical,
      LISTUZ_UC Logical,
      CIBAN Char( 24 ),
      CBIC Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bankuc',
   'c_bankuc.adi',
   'BANKUC1',
   'UPPER(CBANK_UCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bankuc',
   'c_bankuc.adi',
   'BANKUC2',
   'LISMAIN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bankuc',
   'c_bankuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bankuc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_bankucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bankuc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_bankucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bankuc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_bankucfail');

CREATE TABLE c_banky ( 
      CKODBANKY Char( 4 ),
      CNAZBANKY Char( 100 ),
      NKODBANKY Short,
      CZKRATSTAT Char( 3 ),
      CBANIS Char( 4 ),
      CSWIFT Char( 20 ),
      CKODBANZN Char( 4 ),
      LAKTIVUCAS Logical,
      DPLATNYOD Date,
      DPLATNYDO Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_banky',
   'c_banky.adi',
   'C_BANKY01',
   'UPPER(CKODBANKY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_banky',
   'c_banky.adi',
   'C_BANKY02',
   'UPPER(CNAZBANKY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_banky',
   'c_banky.adi',
   'C_BANKY03',
   'NKODBANKY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_banky',
   'c_banky.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_banky', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_bankyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_banky', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_bankyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_banky', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_bankyfail');

CREATE TABLE c_bankyc ( 
      CKODBANKY Char( 4 ),
      CNAZBANKY Char( 100 ),
      NKODBANKY Short,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bankyc',
   'c_bankyc.adi',
   'C_BANK01',
   'UPPER(CKODBANKY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bankyc',
   'c_bankyc.adi',
   'C_BANK02',
   'UPPER(CNAZBANKY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bankyc',
   'c_bankyc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bankyc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_bankycfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bankyc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_bankycfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bankyc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_bankycfail');

CREATE TABLE c_bcd ( 
      NCARKKOD Double( 0 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bcd',
   'c_bcd.adi',
   'C_BCD1',
   'NCARKKOD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_bcd',
   'c_bcd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bcd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_bcdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bcd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_bcdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_bcd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_bcdfail');

CREATE TABLE c_carkod ( 
      CZKRCARKOD Char( 8 ),
      CNAZCARKOD Char( 50 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_carkod',
   'c_carkod.adi',
   'C_CARK1',
   'UPPER (CZKRCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_carkod',
   'c_carkod.adi',
   'C_CARK2',
   'UPPER (CNAZCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_carkod',
   'c_carkod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_carkod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_carkodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_carkod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_carkodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_carkod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_carkodfail');

CREATE TABLE c_celsaz ( 
      CDANPZBO Char( 15 ),
      CNAZDANP Char( 50 ),
      CKODINTR Char( 3 ),
      MNAZEVZCSP Memo,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_celsaz',
   'c_celsaz.adi',
   'C_JCD1',
   'UPPER(CDANPZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_celsaz',
   'c_celsaz.adi',
   'C_JCD2',
   'UPPER(CNAZDANP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_celsaz',
   'c_celsaz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_celsaz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_celsazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_celsaz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_celsazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_celsaz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_celsazfail');

CREATE TABLE c_dalpro ( 
      NDALMERMES Short,
      CDALSIPROH Char( 10 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dalpro',
   'c_dalpro.adi',
   'C_DALPR1',
   'NDALMERMES',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dalpro',
   'c_dalpro.adi',
   'C_DALPR2',
   'UPPER(CDALSIPROH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dalpro', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_dalprofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dalpro', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_dalprofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dalpro', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_dalprofail');

CREATE TABLE c_danskp ( 
      CODPISK Char( 4 ),
      NODPISK Short,
      NROKYODPIS Short,
      NROPRVNI Double( 2 ),
      NRODALSI Double( 2 ),
      NROZVCENA Double( 2 ),
      NZRPRVNI Double( 2 ),
      NZRDALSI Double( 2 ),
      NZRZVCENA Double( 2 ),
      NROPRVNI10 Double( 2 ),
      NRODALSI10 Double( 2 ),
      NROZVCEN10 Double( 2 ),
      NROPRVNI15 Double( 2 ),
      NRODALSI15 Double( 2 ),
      NROZVCEN15 Double( 2 ),
      NROPRVNI20 Double( 2 ),
      NRODALSI20 Double( 2 ),
      NROZVCEN20 Double( 2 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_danskp',
   'c_danskp.adi',
   'C_DANSKP1',
   'UPPER( CODPISK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_danskp',
   'c_danskp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_danskp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_danskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_danskp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_danskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_danskp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_danskpfail');

CREATE TABLE c_dodavk ( 
      CTYPDODAVK Char( 10 ),
      CNAZDODAVK Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dodavk',
   'c_dodavk.adi',
   'C_DODAVK01',
   'UPPER(CTYPDODAVK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dodavk',
   'c_dodavk.adi',
   'C_DODAVK02',
   'UPPER(CNAZDODAVK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dodavk',
   'c_dodavk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dodavk', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_dodavkfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dodavk', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_dodavkfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dodavk', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_dodavkfail');

CREATE TABLE c_dodpod ( 
      CTYPDODPOD Char( 10 ),
      CNAZDODPOD Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dodpod',
   'c_dodpod.adi',
   'C_DODPOD01',
   'UPPER(CTYPDODPOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dodpod',
   'c_dodpod.adi',
   'C_DODPOD02',
   'UPPER(CNAZDODPOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dodpod',
   'c_dodpod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dodpod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_dodpodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dodpod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_dodpodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dodpod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_dodpodfail');

CREATE TABLE c_dokume ( 
      CTYPDOKUM Char( 10 ),
      CZKRDOKUM Char( 10 ),
      CNAZDOKUM Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dokume',
   'c_dokume.adi',
   'C_DOKUME01',
   'UPPER(CZKRDOKUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dokume',
   'c_dokume.adi',
   'C_DOKUME02',
   'UPPER(CTYPDOKUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dokume',
   'c_dokume.adi',
   'C_DOKUME03',
   'UPPER(CNAZDOKUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dokume',
   'c_dokume.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dokume', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_dokumefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dokume', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_dokumefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dokume', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_dokumefail');

CREATE TABLE c_dph ( 
      NKLICDPH Short,
      NPROCDPH Double( 2 ),
      CTEXTDPH Char( 25 ),
      NNULLDPH Short,
      DDATPLAT Date,
      NNAPOCET Short,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dph',
   'c_dph.adi',
   'C_DPH1',
   'NKLICDPH',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dph',
   'c_dph.adi',
   'C_DPH2',
   'NPROCDPH',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dph',
   'c_dph.adi',
   'C_DPH3',
   'STRZERO(NNAPOCET,2) +DTOS (DDATPLAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_dph',
   'c_dph.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dph', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_dphfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dph', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_dphfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_dph', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_dphfail');

CREATE TABLE c_drpohi ( 
      NDRPOHYB Integer,
      CNAZEVPOH Char( 25 ),
      NKARTA Short,
      NTYPPOHYB Short,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohi',
   'c_drpohi.adi',
   'C_DRPOH1',
   'NDRPOHYB',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohi',
   'c_drpohi.adi',
   'C_DRPOH2',
   'UPPER(CNAZEVPOH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohi',
   'c_drpohi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_drpohifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_drpohifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_drpohifail');

CREATE TABLE c_drpohp ( 
      NDRPOHYBP Integer,
      CNAZEVPOH Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohp',
   'c_drpohp.adi',
   'DRPOHP1',
   'NDRPOHYBP',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohp',
   'c_drpohp.adi',
   'DRPOHP2',
   'UPPER(CNAZEVPOH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohp',
   'c_drpohp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_drpohpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_drpohpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_drpohpfail');

CREATE TABLE c_drpohy ( 
      NCISLPOH Integer,
      CNAZEVPOH Char( 25 ),
      NKARTA Short,
      CTYPDOKL Char( 2 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohy',
   'c_drpohy.adi',
   'C_DRPOH1',
   'NCISLPOH',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohy',
   'c_drpohy.adi',
   'C_DRPOH2',
   'UPPER( CNAZEVPOH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohy',
   'c_drpohy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_drpohyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_drpohyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_drpohyfail');

CREATE TABLE c_drpohz ( 
      NDRPOHYB Integer,
      CNAZEVPOH Char( 25 ),
      NKARTA Short,
      LPRODUKCE Logical,
      NTYPPOHYB Short,
      NDRPOHPL1 Short,
      NDRPOHPL2 Short,
      NDRPOHPLPR Short,
      NPODM Short,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohz',
   'c_drpohz.adi',
   'DRPOHZ1',
   'NDRPOHYB',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohz',
   'c_drpohz.adi',
   'DRPOHZ2',
   'UPPER(CNAZEVPOH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drpohz',
   'c_drpohz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_drpohzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_drpohzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drpohz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_drpohzfail');

CREATE TABLE c_drvlst ( 
      NKODDRVLAS Short,
      CPOPISVLAS Char( 30 ),
      CSTATKODZA Char( 6 ),
      MPOPISDRVL Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drvlst',
   'c_drvlst.adi',
   'C_DRVLS1',
   'NKODDRVLAS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drvlst',
   'c_drvlst.adi',
   'C_DRVLS2',
   'UPPER(CPOPISVLAS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_drvlst',
   'c_drvlst.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drvlst', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_drvlstfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drvlst', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_drvlstfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_drvlst', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_drvlstfail');

CREATE TABLE c_duchod ( 
      NTYPDUCHOD Short,
      CNAZDUCHOD Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_duchod',
   'c_duchod.adi',
   'DUCHOD01',
   'NTYPDUCHOD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_duchod',
   'c_duchod.adi',
   'DUCHOD02',
   'UPPER(CNAZDUCHOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_duchod',
   'c_duchod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_duchod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_duchodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_duchod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_duchodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_duchod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_duchodfail');

CREATE TABLE c_expml ( 
      NROK Short,
      NPRUCHOD Short,
      CDENIK Char( 2 ),
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      NPROC Double( 2 ),
      CTEXT Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_expml',
   'c_expml.adi',
   'EXPML1',
   'STRZERO(NROK,4) +STRZERO(NPRUCHOD,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_expml', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_expmlfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_expml', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_expmlfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_expml', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_expmlfail');

CREATE TABLE c_farmy ( 
      NFARMA Double( 0 ),
      CNAZEVFAR Char( 25 ),
      CKODHOSP Char( 4 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_farmy',
   'c_farmy.adi',
   'FARMY_1',
   'NFARMA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_farmy',
   'c_farmy.adi',
   'FARMY_2',
   'UPPER(CNAZEVFAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_farmy',
   'c_farmy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_farmy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_farmyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_farmy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_farmyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_farmy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_farmyfail');

CREATE TABLE c_farmyv ( 
      CNAZPOL4 Char( 8 ),
      NFARMA Double( 0 ),
      NOBEC Integer,
      NFARMAPUV Double( 0 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_farmyv',
   'c_farmyv.adi',
   'FARMYV_1',
   'UPPER(CNAZPOL4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_farmyv',
   'c_farmyv.adi',
   'FARMYV_2',
   'NFARMA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_farmyv',
   'c_farmyv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_farmyv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_farmyvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_farmyv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_farmyvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_farmyv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_farmyvfail');

CREATE TABLE c_firmysk ( 
      CZKR_SKUP Char( 3 ),
      CNAZ_SKUP Char( 30 ),
      CSKUP_ODB Char( 2 ),
      CSKUP_DOD Char( 2 ),
      CSKUP_FAA Char( 2 ),
      CSKUP_DOP Char( 2 ),
      CSKUP_DOA Char( 2 ),
      CPOVOL_SKU Char( 100 ),
      CPOVOL_VAZ Char( 100 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_firmysk',
   'c_firmysk.adi',
   'C_FIRMSK01',
   'UPPER(CZKR_SKUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_firmysk',
   'c_firmysk.adi',
   'C_FIRMSK02',
   'UPPER(CNAZ_SKUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_firmysk',
   'c_firmysk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_firmysk', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_firmyskfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_firmysk', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_firmyskfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_firmysk', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_firmyskfail');

CREATE TABLE c_funcpr ( 
      CFUNPRA Char( 8 ),
      CNAZFUNCPR Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_funcpr',
   'c_funcpr.adi',
   'C_FUNC01',
   'UPPER(CFUNPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_funcpr',
   'c_funcpr.adi',
   'C_FUNC02',
   'UPPER(CNAZFUNCPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_funcpr',
   'c_funcpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_funcpr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_funcprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_funcpr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_funcprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_funcpr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_funcprfail');

CREATE TABLE c_grupuc ( 
      CUCET Char( 6 ),
      CNAZ_UCT Char( 30 ),
      CUCETMD Char( 6 ),
      LNAKLSTR Logical,
      CZUSTUCT Char( 1 ),
      LVYNOSUCT Logical,
      LNAKLUCT Logical,
      LAKTIVUCT Logical,
      LPASIVUCT Logical,
      LZAVERUCT Logical,
      LPODRZUCT Logical,
      LPODR_UCZ Logical,
      LNATURUCT Logical,
      LSALDOUCT Logical,
      LFINUCT Logical,
      LDANUCT Logical,
      LMIMORUCT Logical,
      LSYNTUCT Logical,
      CSKUPUCT Char( 90 ),
      MPOZ_UCT Memo,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo,
      CUCETSK Char( 2 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC1',
   'UPPER(CUCETSK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC3',
   'UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_grupuc',
   'c_grupuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_grupuc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_grupucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_grupuc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_grupucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_grupuc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_grupucfail');

CREATE TABLE c_jednot ( 
      CZKRATJEDN Char( 3 ),
      CNAZJEDNOT Char( 40 ),
      CZKRMEZOZN Char( 3 ),
      CSTATKODZA Char( 6 ),
      MNAZEVJEDP Memo,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_jednot',
   'c_jednot.adi',
   'C_JEDNOT1',
   'UPPER(CZKRATJEDN)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_jednot',
   'c_jednot.adi',
   'C_JEDNOT2',
   'UPPER(CNAZJEDNOT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_jednot',
   'c_jednot.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_jednot', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_jednotfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_jednot', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_jednotfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_jednot', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_jednotfail');

CREATE TABLE c_katzbo ( 
      NZBOZIKAT Short,
      CNAZEVKAT Char( 20 ),
      NPRIRAZKA Double( 2 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_katzbo',
   'c_katzbo.adi',
   'C_KATZB1',
   'NZBOZIKAT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_katzbo',
   'c_katzbo.adi',
   'C_KATZB2',
   'UPPER( CNAZEVKAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_katzbo',
   'c_katzbo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_katzbo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_katzbofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_katzbo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_katzbofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_katzbo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_katzbofail');

CREATE TABLE c_klassd ( 
      CKODKLAS Char( 9 ),
      CNAZEVKLAS Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_klassd',
   'c_klassd.adi',
   'C_KLASSD1',
   'UPPER(CKODKLAS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_klassd',
   'c_klassd.adi',
   'C_KLASSD2',
   'UPPER(CNAZEVKLAS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_klassd',
   'c_klassd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_klassd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_klassdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_klassd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_klassdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_klassd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_klassdfail');

CREATE TABLE c_klazam ( 
      NKLASZAM Integer,
      CNAZKLASZA Char( 30 ),
      CPOPISKLZA Char( 90 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_klazam',
   'c_klazam.adi',
   'KLASZA01',
   'NKLASZAM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_klazam',
   'c_klazam.adi',
   'KLASZA02',
   'UPPER(CNAZKLASZA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_klazam',
   'c_klazam.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_klazam', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_klazamfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_klazam', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_klazamfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_klazam', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_klazamfail');

CREATE TABLE c_koddop ( 
      NKOD_DOP Short,
      CNAZEV_DOP Char( 32 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koddop',
   'c_koddop.adi',
   'C_KDOP_1',
   'NKOD_DOP',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koddop',
   'c_koddop.adi',
   'C_KDOP_2',
   'UPPER(CNAZEV_DOP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koddop',
   'c_koddop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koddop', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_koddopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koddop', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_koddopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koddop', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_koddopfail');

CREATE TABLE c_koef ( 
      CPOPISKOEF Char( 30 ),
      NKOEFPREP Double( 6 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koef',
   'c_koef.adi',
   'KOEF1',
   'UPPER(CPOPISKOEF)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koef',
   'c_koef.adi',
   'KOEF2',
   'NKOEFPREP',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koef',
   'c_koef.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koef', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_koeffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koef', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_koeffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koef', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_koeffail');

CREATE TABLE c_koefmn ( 
      NKOEFMN Double( 6 ),
      CZKRATJEDN Char( 3 ),
      CPOPISKOEF Char( 30 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koefmn',
   'c_koefmn.adi',
   'C_KOEMN01',
   'NKOEFMN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koefmn',
   'c_koefmn.adi',
   'C_KOEMN02',
   'UPPER( CPOPISKOEF)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_koefmn',
   'c_koefmn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koefmn', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_koefmnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koefmn', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_koefmnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_koefmn', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_koefmnfail');

CREATE TABLE c_konsym ( 
      NKONSTSYMB Short,
      CPOPISKS Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_konsym',
   'c_konsym.adi',
   'KONSYM1',
   'NKONSTSYMB',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_konsym',
   'c_konsym.adi',
   'KONSYM2',
   'UPPER(CPOPISKS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_konsym',
   'c_konsym.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_konsym', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_konsymfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_konsym', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_konsymfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_konsym', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_konsymfail');

CREATE TABLE c_kraje ( 
      CKRAJ Char( 10 ),
      CNAZ_KRAJE Char( 32 ),
      CZKR_KRAJE Char( 1 ),
      CCZ_NUTSKR Char( 5 ),
      CSTATKODZA Char( 6 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_kraje',
   'c_kraje.adi',
   'C_KRAJ_1',
   'UPPER(CKRAJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_kraje',
   'c_kraje.adi',
   'C_KRAJ_2',
   'UPPER(CNAZ_KRAJE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_kraje',
   'c_kraje.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_kraje', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_krajefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_kraje', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_krajefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_kraje', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_krajefail');

CREATE TABLE c_lekari ( 
      CZKRATLEKA Char( 8 ),
      CNAZEVLEKA Char( 30 ),
      CODBORNLEK Char( 30 ),
      CULICE Char( 25 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NCISFIRMY Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_lekari',
   'c_lekari.adi',
   'CLEKAR01',
   'UPPER(CZKRATLEKA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_lekari',
   'c_lekari.adi',
   'CLEKAR02',
   'UPPER(CNAZEVLEKA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_lekari',
   'c_lekari.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_lekari', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_lekarifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_lekari', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_lekarifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_lekari', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_lekarifail');

CREATE TABLE c_lekpro ( 
      CZKRATKA Char( 8 ),
      CNAZEV Char( 30 ),
      NPERIOOPAK Integer,
      CZKRATJEDN Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_lekpro',
   'c_lekpro.adi',
   'CLEKPR01',
   'UPPER(CZKRATKA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_lekpro',
   'c_lekpro.adi',
   'CLEKPR02',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_lekpro',
   'c_lekpro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_lekpro', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_lekprofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_lekpro', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_lekprofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_lekpro', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_lekprofail');

CREATE TABLE c_maj ( 
      NINVCIS Integer,
      NINVCISDIM Integer,
      CDRUHMAJ Char( 2 ),
      CTYPMAJ Char( 2 ),
      CNAZEVMAJ Char( 30 ),
      NZIVOTNH Double( 3 ),
      CPOUZMAJ Char( 25 ),
      CZKRATJEDN Char( 3 ),
      MPOPISMAJ Memo,
      MNAVODPOUZ Memo,
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      CCELEK Char( 15 ),
      CVYKRES Char( 20 ),
      CUMISTENI Char( 25 ),
      NTYPMAJ Short,
      CVYRCISIM Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ1',
   'UPPER(CDRUHMAJ) +STRZERO(NINVCIS,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ2',
   'UPPER(CDRUHMAJ) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ3',
   'UPPER(CDRUHMAJ) +UPPER(CNAZEVMAJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ4',
   'NINVCIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ5',
   'NINVCISDIM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ6',
   'UPPER(CNAZEVMAJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_maj',
   'c_maj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_maj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_majfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_maj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_majfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_maj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_majfail');

CREATE TABLE c_meny ( 
      CZKRATMENY Char( 3 ),
      CNAZMENY Char( 25 ),
      NMNOZPREP Integer,
      CSTATKODZA Char( 6 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_meny',
   'c_meny.adi',
   'C_MENY1',
   'UPPER (CZKRATMENY)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_meny',
   'c_meny.adi',
   'C_MENY2',
   'UPPER (CNAZMENY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_meny',
   'c_meny.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_meny', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_menyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_meny', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_menyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_meny', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_menyfail');

CREATE TABLE c_mimprv ( 
      NMIMOPRVZT Short,
      CNAZMIMPRV Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_mimprv',
   'c_mimprv.adi',
   'MIPRVZ01',
   'NMIMOPRVZT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_mimprv',
   'c_mimprv.adi',
   'MIPRVZ02',
   'UPPER(CNAZMIMPRV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_mimprv',
   'c_mimprv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mimprv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_mimprvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mimprv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_mimprvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mimprv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_mimprvfail');

CREATE TABLE c_mince ( 
      CZKRATMENY Char( 3 ),
      CNAZMINCE Char( 25 ),
      NHODMINCE Integer,
      CZKRMINCE Char( 3 ),
      NVALMINCE Double( 3 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_mince',
   'c_mince.adi',
   'C_MINC1',
   'UPPER(CZKRATMENY) +STRZERO(NVALMINCE,11)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_mince',
   'c_mince.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mince', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_mincefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mince', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_mincefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mince', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_mincefail');

CREATE TABLE c_mzdpol ( 
      NPORADI Short,
      CNAZEVPOLE Char( 25 ),
      CZKRATPOLE Char( 8 ),
      LVYBERPOLE Logical,
      CNAZEVPROM Char( 10 ),
      CPICTURE Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_mzdpol',
   'c_mzdpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mzdpol', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_mzdpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mzdpol', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_mzdpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_mzdpol', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_mzdpolfail');

CREATE TABLE c_naklst ( 
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_naklst',
   'c_naklst.adi',
   'C_NAKLST1',
   'UPPER(CNAZPOL1)+UPPER(CNAZPOL2)+UPPER(CNAZPOL3)+UPPER(CNAZPOL4)+UPPER(CNAZPOL5)+UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_naklst',
   'c_naklst.adi',
   'C_NAKLST2',
   'NKLICNS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_naklst',
   'c_naklst.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_naklst', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_naklstfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_naklst', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_naklstfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_naklst', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_naklstfail');

CREATE TABLE c_nakstr ( 
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      LREZVYROB Logical,
      LREZSPRAV Logical,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nakstr',
   'c_nakstr.adi',
   'NAKSTR01',
   'UPPER(CNAZPOL1) +IF (LREZVYROB, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nakstr',
   'c_nakstr.adi',
   'NAKSTR02',
   'LREZSPRAV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nakstr',
   'c_nakstr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nakstr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_nakstrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nakstr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_nakstrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nakstr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_nakstrfail');

CREATE TABLE c_napdmz ( 
      NDRUHMZDY Short,
      DNY Char( 30 ),
      HODINY Char( 30 ),
      HRUBA_MZDA Char( 30 ),
      S_532A Char( 12 ),
      S_532C Char( 12 ),
      S_532E Char( 12 ),
      S_537A Char( 10 ),
      S_537B Char( 10 ),
      S_537C Char( 10 ),
      P_KCSNEMOC Short,
      P_KCSPRACP Short,
      P_KCSPOHSL Short,
      P_KCSHOPRP Short,
      P_KCSPRESC Short,
      P_HODPRPRA Short,
      P_DNYODPDN Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_napdmz',
   'c_napdmz.adi',
   'C_NAPDMZ01',
   'NDRUHMZDY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_napdmz',
   'c_napdmz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_napdmz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_napdmzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_napdmz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_napdmzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_napdmz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_napdmzfail');

CREATE TABLE c_narod ( 
      CZKRATNAR Char( 15 ),
      CNAZNAROD Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_narod',
   'c_narod.adi',
   'NARODN01',
   'UPPER(CZKRATNAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_narod',
   'c_narod.adi',
   'NARODN02',
   'UPPER(CNAZNAROD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_narod',
   'c_narod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_narod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_narodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_narod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_narodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_narod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_narodfail');

CREATE TABLE c_nazrml ( 
      ML_RAD Char( 3 ),
      NAME_RAD Char( 23 ),
      NRADMZDLIS Short,
      CNAZRADMZL Char( 30 ),
      NTYPRADMZL Short,
      CTYPVALUER Char( 1 ),
      CKMENVALUE Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML01',
   'UPPER(ML_RAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML02',
   'UPPER(NAME_RAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML03',
   'NRADMZDLIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML04',
   'NTYPRADMZL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazrml',
   'c_nazrml.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazrml', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_nazrmlfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazrml', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_nazrmlfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazrml', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_nazrmlfail');

CREATE TABLE c_nazrvp ( 
      NPORADI Short,
      CNAZ_VP1 Char( 17 ),
      NTYP_VP1 Short,
      CRZN_VP1 Char( 4 ),
      CNAZ_VP2 Char( 17 ),
      NTYP_VP2 Short,
      CRZN_VP2 Char( 4 ),
      CNAZ_VP3 Char( 17 ),
      NTYP_VP3 Short,
      CRZN_VP3 Char( 4 ),
      CNAZ_VP4 Char( 17 ),
      NTYP_VP4 Short,
      CRZN_VP4 Char( 4 ),
      CRZ_VP Char( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazrvp',
   'c_nazrvp.adi',
   'C_NAZRVP01',
   'NPORADI',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazrvp',
   'c_nazrvp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazrvp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_nazrvpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazrvp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_nazrvpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazrvp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_nazrvpfail');

CREATE TABLE c_nazzbo ( 
      NZBOZIKAT Short,
      CNAZEVNAZ Char( 30 ),
      NKLICNAZ Integer,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'C_NAZZB1',
   'UPPER(CNAZEVNAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'C_NAZZB2',
   'NKLICNAZ',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'C_NAZZB3',
   'NZBOZIKAT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazzbo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_nazzbofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazzbo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_nazzbofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nazzbo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_nazzbofail');

CREATE TABLE c_nemgen ( 
      DM Short,
      KOD Short,
      VETA Short,
      DMGEN Short,
      DNY Short,
      HOD Short,
      KCS Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nemgen',
   'c_nemgen.adi',
   'C_NEMGEN01',
   'STRZERO(DM,4) +STRZERO(KOD,2) +STRZERO(VETA,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nemgen',
   'c_nemgen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nemgen', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_nemgenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nemgen', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_nemgenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nemgen', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_nemgenfail');

CREATE TABLE c_nzmatr ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      NKEYMATR Short,
      CNAZMATR Char( 20 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nzmatr',
   'c_nzmatr.adi',
   'C_NZMATR01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NKEYMATR,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nzmatr',
   'c_nzmatr.adi',
   'C_NZMATR02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CNAZMATR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_nzmatr',
   'c_nzmatr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nzmatr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_nzmatrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nzmatr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_nzmatrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_nzmatr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_nzmatrfail');

CREATE TABLE c_object ( 
      CTYPOBJECT Char( 10 ),
      CNAZTYPOBJ Char( 100 ),
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_object',
   'c_object.adi',
   'C_OBJECT01',
   'UPPER(CTYPOBJECT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_object',
   'c_object.adi',
   'C_OBJECT02',
   'UPPER(CNAZTYPOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_object',
   'c_object.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_object', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_objectfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_object', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_objectfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_object', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_objectfail');

CREATE TABLE c_oblast ( 
      NKLICOBL Short,
      CNAZEVOBL Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_oblast',
   'c_oblast.adi',
   'C_OBL1',
   'NKLICOBL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_oblast',
   'c_oblast.adi',
   'C_OBL2',
   'UPPER(CNAZEVOBL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_oblast',
   'c_oblast.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_oblast', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_oblastfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_oblast', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_oblastfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_oblast', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_oblastfail');

CREATE TABLE c_obvzth ( 
      CZKRATOBVZ Char( 2 ),
      CNAZOBVZTH Char( 15 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_obvzth',
   'c_obvzth.adi',
   'C_OBVZT1',
   'UPPER(CZKRATOBVZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_obvzth',
   'c_obvzth.adi',
   'C_OBVZT2',
   'UPPER(CNAZOBVZTH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_obvzth', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_obvzthfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_obvzth', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_obvzthfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_obvzth', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_obvzthfail');

CREATE TABLE c_odpmis ( 
      CKLICODMIS Char( 8 ),
      CNAZODPMIS Char( 25 ),
      NOSCISPRAC Integer,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpmis',
   'c_odpmis.adi',
   'C_1',
   'UPPER(CKLICODMIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpmis',
   'c_odpmis.adi',
   'C_2',
   'UPPER(CNAZODPMIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpmis',
   'c_odpmis.adi',
   'C_3',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpmis',
   'c_odpmis.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_odpmis', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_odpmisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_odpmis', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_odpmisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_odpmis', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_odpmisfail');

CREATE TABLE c_odpoc ( 
      NPORODPPOL Short,
      CTYPODPPOL Char( 4 ),
      CNAZODPPOL Char( 30 ),
      DPLATNOD Date,
      DPLATNDO Date,
      NODPOCOBD Integer,
      NODPOCROK Integer,
      NDANULOBD Integer,
      NDANULROK Integer,
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      LAKTMESODP Logical,
      LODPOCET Logical,
      LDANULEVA Logical,
      NDRUHMZDY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC01',
   'NPORODPPOL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC02',
   'UPPER(CTYPODPPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC03',
   'STRZERO(NROK,4) +STRZERO(NPORODPPOL,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC04',
   'STRZERO(NROK,4) +UPPER(CTYPODPPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_odpoc',
   'c_odpoc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_odpoc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_odpocfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_odpoc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_odpocfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_odpoc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_odpocfail');

CREATE TABLE c_ogamo ( 
      NCISLPOH Integer,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ogamo',
   'c_ogamo.adi',
   'C_OGAMO1',
   'NCISLPOH',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ogamo',
   'c_ogamo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ogamo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_ogamofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ogamo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_ogamofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ogamo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_ogamofail');

CREATE TABLE c_okresy ( 
      COKRES Char( 10 ),
      CNAZ_OKRES Char( 32 ),
      CZKR_OKRES Char( 2 ),
      CCZ_NUTSOK Char( 6 ),
      CSTATKODZA Char( 6 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_okresy',
   'c_okresy.adi',
   'C_OKRES1',
   'UPPER(COKRES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_okresy',
   'c_okresy.adi',
   'C_OKRES2',
   'UPPER(CNAZ_OKRES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_okresy',
   'c_okresy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_okresy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_okresyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_okresy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_okresyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_okresy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_okresyfail');

CREATE TABLE c_opacim ( 
      CCISEMISTA Char( 10 ),
      DDATZKOPAC Date,
      CTYPOPACIM Char( 40 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_opacim',
   'c_opacim.adi',
   'C_OPACI1',
   'DTOS ( DDATZKOPAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opacim', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_opacimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opacim', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_opacimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opacim', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_opacimfail');

CREATE TABLE c_oprakt ( 
      NKODOPRAKT Short,
      CNAZOPRAKT Char( 35 ),
      CKODPRER Char( 3 ),
      ACKODPRER Memo,
      NKODPRER Short,
      ANKODPRER Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_oprakt',
   'c_oprakt.adi',
   'INFSUM01',
   'NKODOPRAKT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_oprakt',
   'c_oprakt.adi',
   'INFSUM02',
   'UPPER(CNAZOPRAKT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_oprakt',
   'c_oprakt.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_oprakt', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_opraktfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_oprakt', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_opraktfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_oprakt', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_opraktfail');

CREATE TABLE c_opravn ( 
      COPRAVNENI Char( 10 ),
      CNAZOPRAVN Char( 100 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      MBLOCK Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_opravn',
   'c_opravn.adi',
   'C_OPRAVN01',
   'UPPER(COPRAVNENI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_opravn',
   'c_opravn.adi',
   'C_OPRAVN02',
   'UPPER(CNAZOPRAVN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_opravn',
   'c_opravn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opravn', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_opravnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opravn', 
   'Table_Encryption', 
   'True', 'APPEND_FAIL', 'c_opravnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opravn', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_opravnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opravn', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_opravnfail');

CREATE TABLE c_opravy ( 
      NDRUHOPRAV Short,
      CNAZEVDRUH Char( 20 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_opravy',
   'c_opravy.adi',
   'C_DRUHO1',
   'NDRUHOPRAV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_opravy',
   'c_opravy.adi',
   'C_DRUHO2',
   'UPPER(CNAZEVDRUH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opravy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_opravyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opravy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_opravyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_opravy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_opravyfail');

CREATE TABLE c_parame ( 
      CSKUPPAR Char( 4 ),
      CPARAMETR Char( 8 ),
      CNAZPARAME Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_parame',
   'c_parame.adi',
   'C_PARAME01',
   'UPPER(CPARAMETR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_parame',
   'c_parame.adi',
   'C_PARAME02',
   'UPPER(CNAZPARAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_parame',
   'c_parame.adi',
   'C_PARAME03',
   'UPPER(CSKUPPAR) +UPPER(CPARAMETR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_parame',
   'c_parame.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_parame', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_paramefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_parame', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_paramefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_parame', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_paramefail');

CREATE TABLE c_parsku ( 
      CSKUPPAR Short,
      CNAZSKUPPA Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_parsku',
   'c_parsku.adi',
   'C_PARSKU01',
   'CSKUPPAR',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_parsku',
   'c_parsku.adi',
   'C_PARSKU02',
   'UPPER(CNAZSKUPPA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_parsku',
   'c_parsku.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_parsku', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_parskufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_parsku', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_parskufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_parsku', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_parskufail');

CREATE TABLE c_plemen ( 
      CPLEMENO Char( 2 ),
      CNAZPLEMEN Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_plemen',
   'c_plemen.adi',
   'C_PLEMEN1',
   'UPPER(CPLEMENO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_plemen',
   'c_plemen.adi',
   'C_PLEMEN2',
   'UPPER(CNAZPLEMEN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_plemen',
   'c_plemen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_plemen', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_plemenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_plemen', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_plemenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_plemen', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_plemenfail');

CREATE TABLE c_podruc ( 
      CZKRATMENY Char( 3 ),
      NCISFIRMY Integer,
      CUCTZ_PUH Char( 6 ),
      CUCTZ_PUHS Char( 6 ),
      CUCTZ_PUZ Char( 6 ),
      CUCTZ_PUZS Char( 6 ),
      CUCTP_PUH Char( 6 ),
      CUCTP_PUHS Char( 6 ),
      CUCTP_PUZ Char( 6 ),
      CUCTP_PUZS Char( 6 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_podruc',
   'c_podruc.adi',
   'C_PODR1',
   'UPPER(CZKRATMENY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_podruc',
   'c_podruc.adi',
   'C_PODR2',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRATMENY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_podruc',
   'c_podruc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_podruc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_podrucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_podruc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_podrucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_podruc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_podrucfail');

CREATE TABLE c_pojust ( 
      CZKRPOJIST Char( 3 ),
      CNAZPOJIST Char( 30 ),
      CZKRATKAPO Char( 10 ),
      CZKRROZLTP Char( 2 ),
      CTYPABO Char( 6 ),
      CIDKODUPOJ Char( 10 ),
      NCISFIRMY Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pojust',
   'c_pojust.adi',
   'C_POJUST01',
   'UPPER(CZKRPOJIST)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pojust',
   'c_pojust.adi',
   'C_POJUST02',
   'UPPER(CNAZPOJIST)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pojust',
   'c_pojust.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pojust', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pojustfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pojust', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pojustfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pojust', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pojustfail');

CREATE TABLE c_polrvp ( 
      CRZ_VP Char( 4 ),
      NFIELD_VP Short,
      NTYPNAP Short,
      NDRUHMZDY Short,
      CDRUHMZDY Char( 20 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_polrvp',
   'c_polrvp.adi',
   'C_POLRVP01',
   'UPPER(CRZ_VP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_polrvp',
   'c_polrvp.adi',
   'C_POLRVP02',
   'STRZERO(NTYPNAP,1) +STRZERO(NFIELD_VP,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_polrvp',
   'c_polrvp.adi',
   'C_POLRVP03',
   'NDRUHMZDY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_polrvp',
   'c_polrvp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_polrvp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_polrvpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_polrvp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_polrvpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_polrvp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_polrvpfail');

CREATE TABLE c_pracdo ( 
      CDELKPRDOB Char( 20 ),
      CNAZDELPRD Char( 30 ),
      NDNYTYDEN Double( 2 ),
      NHODTYDEN Double( 2 ),
      NHODDEN Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracdo',
   'c_pracdo.adi',
   'DELPRD01',
   'UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracdo',
   'c_pracdo.adi',
   'DELPRD02',
   'UPPER(CNAZDELPRD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracdo',
   'c_pracdo.adi',
   'DELPRD03',
   'NHODTYDEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracdo',
   'c_pracdo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracdo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pracdofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracdo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pracdofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracdo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pracdofail');

CREATE TABLE c_pracov ( 
      COZNPRAC Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CSTRED Char( 8 ),
      CNAZEVPRAC Char( 30 ),
      NVICESTROJ Double( 2 ),
      NKOEFVIOB Double( 3 ),
      NVICEOBSLU Double( 2 ),
      NKOEFVIST Double( 3 ),
      NKOEFSMCAS Double( 3 ),
      NDRUHMZDY Short,
      NPOCPRAC Short,
      CTYPPROFES Char( 2 ),
      LVYKNORMA Logical,
      CPRACZAR Char( 8 ),
      CTYPPRACOV Char( 6 ),
      NTRANMNOZ Double( 3 ),
      CTYPKALEND Char( 10 ),
      MPOPISPRAC Memo,
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NSAZBASTRO Double( 3 ),
      NPORADI Short,
      COZNPRACN Char( 8 ),
      NKOEFPREP Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC1',
   'UPPER(COZNPRAC) +UPPER(CNAZEVPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC2',
   'UPPER(CNAZEVPRAC) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC3',
   'UPPER(COZNPRAC) +UPPER(CSTRED) +UPPER(CNAZEVPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC4',
   'UPPER(COZNPRACN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracov',
   'c_pracov.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracov', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pracovfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracov', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pracovfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracov', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pracovfail');

CREATE TABLE c_pracsm ( 
      CTYPSMENY Char( 15 ),
      CNAZSMENY Char( 35 ),
      CRANSMEZAC Char( 5 ),
      CRANSMEKON Char( 5 ),
      CRANSMEDEL Char( 5 ),
      LRANPRUZNA Logical,
      CODPSMEZAC Char( 5 ),
      CODPSMEKON Char( 5 ),
      CODPSMEDEL Char( 5 ),
      LODPPRUZNA Logical,
      CNOCSMEZAC Char( 5 ),
      CNOCSMEKON Char( 5 ),
      CNOCSMEDEL Char( 5 ),
      LNOCPRUZNA Logical,
      NTYPPRUZNA Short,
      NPRESCAS Double( 2 ),
      NPRESZACAS Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracsm',
   'c_pracsm.adi',
   'PRACSM_1',
   'UPPER(CTYPSMENY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracsm',
   'c_pracsm.adi',
   'PRACSM_2',
   'UPPER(CNAZSMENY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracsm',
   'c_pracsm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracsm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pracsmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracsm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pracsmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracsm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pracsmfail');

CREATE TABLE c_pracvz ( 
      NTYPPRAVZT Short,
      CNAZPRAVZT Char( 30 ),
      LMIMOPRVZT Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracvz',
   'c_pracvz.adi',
   'PRACVZ01',
   'NTYPPRAVZT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracvz',
   'c_pracvz.adi',
   'PRACVZ02',
   'UPPER(CNAZPRAVZT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracvz',
   'c_pracvz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracvz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pracvzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracvz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pracvzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracvz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pracvzfail');

CREATE TABLE c_pracza ( 
      CPRACZAR Char( 8 ),
      CNAZPRACZA Char( 30 ),
      NKLASZAM Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracza',
   'c_pracza.adi',
   'PRAZAR01',
   'UPPER(CPRACZAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracza',
   'c_pracza.adi',
   'PRAZAR02',
   'UPPER(CNAZPRACZA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pracza',
   'c_pracza.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracza', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_praczafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracza', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_praczafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pracza', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_praczafail');

CREATE TABLE c_pravfo ( 
      NKODPRFORM Short,
      CPOPISPRFO Char( 30 ),
      CSTATKODZA Char( 6 ),
      MPOPISPRFO Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pravfo',
   'c_pravfo.adi',
   'C_PRFOR1',
   'NKODPRFORM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pravfo',
   'c_pravfo.adi',
   'C_PRFOR2',
   'UPPER(CPOPISPRFO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pravfo',
   'c_pravfo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pravfo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pravfofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pravfo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pravfofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pravfo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pravfofail');

CREATE TABLE c_prepmj ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NPOCVYCHMJ Double( 3 ),
      CVYCHOZIMJ Char( 3 ),
      NPOCCILMJ Double( 3 ),
      CCILOVAMJ Char( 3 ),
      NKOEFPRVC Double( 6 ),
      MPOZNAMKA Memo,
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prepmj',
   'c_prepmj.adi',
   'C_PREPMJ01',
   'UPPER(CVYCHOZIMJ)+ UPPER(CCILOVAMJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prepmj',
   'c_prepmj.adi',
   'C_PREPMJ02',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + UPPER(CVYCHOZIMJ)+ UPPER(CCILOVAMJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prepmj',
   'c_prepmj.adi',
   'C_PREPMJ03',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + UPPER(CCILOVAMJ)+ UPPER(CVYCHOZIMJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prepmj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_prepmjfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prepmj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_prepmjfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prepmj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_prepmjfail');

CREATE TABLE c_prerus ( 
      CKODPRER Char( 3 ),
      NKODPRER Short,
      CNAZPRER Char( 25 ),
      NNAPPRER Short,
      NMASKINP Short,
      NMASKOUT Short,
      NSAYSCR Short,
      NSAYCRD Short,
      LINFSUM Logical,
      CTYPPRER Char( 15 ),
      LISEDIT Logical,
      LISPOVOL Logical,
      NCSPOVOL Double( 2 ),
      NKODZAOKR Short,
      NSUMFOND Short,
      NSUMVYR Short,
      LPRESTAVKA Logical,
      NPRITPRAC Short,
      NDRUHMZDY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prerus',
   'c_prerus.adi',
   'PRER1',
   'UPPER(CKODPRER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prerus',
   'c_prerus.adi',
   'PRER2',
   'UPPER(CNAZPRER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prerus',
   'c_prerus.adi',
   'PRER3',
   'NKODPRER',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prerus',
   'c_prerus.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prerus', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_prerusfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prerus', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_prerusfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prerus', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_prerusfail');

CREATE TABLE c_pripl ( 
      CKODPRIPL Char( 2 ),
      NHODPRIPL Double( 2 ),
      CNAZPRIPL Char( 30 ),
      NDRUHMZDY Short,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pripl',
   'c_pripl.adi',
   'C_PRIPL1',
   'UPPER(CKODPRIPL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pripl',
   'c_pripl.adi',
   'C_PRIPL2',
   'STRZERO(NDRUHMZDY,4) +UPPER(CKODPRIPL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pripl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_priplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pripl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_priplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pripl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_priplfail');

CREATE TABLE c_pripom ( 
      CTYPPRIPOM Char( 10 ),
      CNAZPRIPOM Char( 100 ),
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pripom',
   'c_pripom.adi',
   'C_PRIPOM01',
   'UPPER(CTYPPRIPOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pripom',
   'c_pripom.adi',
   'C_PRIPOM02',
   'UPPER(CNAZPRIPOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_pripom',
   'c_pripom.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pripom', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pripomfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pripom', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pripomfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_pripom', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pripomfail');

CREATE TABLE c_prodej ( 
      CZKRPRODEJ Char( 4 ),
      CNAZPRODEJ Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prodej',
   'c_prodej.adi',
   'PRODEJ1',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prodej',
   'c_prodej.adi',
   'PRODEJ2',
   'UPPER(CNAZPRODEJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_prodej',
   'c_prodej.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prodej', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_prodejfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prodej', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_prodejfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_prodej', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_prodejfail');

CREATE TABLE c_psc ( 
      CPSC Char( 6 ),
      CMISTO Char( 40 ),
      CPOSTA Char( 40 ),
      CCZ_NUTSOK Char( 6 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_psc',
   'c_psc.adi',
   'C_PSC1',
   'UPPER(CPSC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_psc',
   'c_psc.adi',
   'C_PSC2',
   'UPPER(CMISTO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_psc',
   'c_psc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_psc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_pscfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_psc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_pscfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_psc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_pscfail');

CREATE TABLE c_rodsta ( 
      CZKRRODSTV Char( 8 ),
      CNAZRODSTV Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_rodsta',
   'c_rodsta.adi',
   'ZKRRODST',
   'UPPER(CZKRRODSTV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_rodsta',
   'c_rodsta.adi',
   'NAZRODST',
   'UPPER(CNAZRODSTV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_rodsta',
   'c_rodsta.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_rodsta', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_rodstafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_rodsta', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_rodstafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_rodsta', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_rodstafail');

CREATE TABLE c_sklady ( 
      CCISSKLAD Char( 8 ),
      CNAZSKLAD Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NPRIRAZKA Double( 2 ),
      LRANGEPVP Logical,
      NPRIJEMOD Double( 0 ),
      NPRIJEMDO Double( 0 ),
      NVYDEJOD Double( 0 ),
      NVYDEJDO Double( 0 ),
      NPREVODOD Double( 0 ),
      NPREVODDO Double( 0 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_sklady',
   'c_sklady.adi',
   'C_SKLAD1',
   'UPPER( CCISSKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_sklady',
   'c_sklady.adi',
   'C_SKLAD2',
   'UPPER( CNAZSKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_sklady',
   'c_sklady.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_sklady', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_skladyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_sklady', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_skladyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_sklady', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_skladyfail');

CREATE TABLE c_skolen ( 
      CZKRATKA Char( 8 ),
      CNAZEV Char( 30 ),
      NDELKASKOL Integer,
      CZKRATJED2 Char( 3 ),
      NPERIOOPAK Integer,
      CZKRATJEDN Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skolen',
   'c_skolen.adi',
   'CSKOLE01',
   'UPPER(CZKRATKA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skolen',
   'c_skolen.adi',
   'CSKOLE02',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skolen',
   'c_skolen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skolen', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_skolenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skolen', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_skolenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skolen', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_skolenfail');

CREATE TABLE c_skolit ( 
      CZKRATSKOL Char( 8 ),
      CNAZEVSKOL Char( 30 ),
      CULICE Char( 25 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NCISFIRMY Integer,
      CLEKTOR Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skolit',
   'c_skolit.adi',
   'CSKOLI01',
   'UPPER(CZKRATSKOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skolit',
   'c_skolit.adi',
   'CSKOLI02',
   'UPPER(CNAZEVSKOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skolit',
   'c_skolit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skolit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_skolitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skolit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_skolitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skolit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_skolitfail');

CREATE TABLE c_skoluk ( 
      CZKRATKAUK Char( 8 ),
      CNAZEV Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skoluk',
   'c_skoluk.adi',
   'CUKOSK01',
   'UPPER(CZKRATKAUK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skoluk',
   'c_skoluk.adi',
   'CUKOSK02',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skoluk',
   'c_skoluk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skoluk', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_skolukfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skoluk', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_skolukfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skoluk', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_skolukfail');

CREATE TABLE c_skumis ( 
      CKLICSKMIS Char( 8 ),
      CNAZSKMIS Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skumis',
   'c_skumis.adi',
   'C_1',
   'UPPER(CKLICSKMIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skumis',
   'c_skumis.adi',
   'C_2',
   'UPPER(CNAZSKMIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skumis',
   'c_skumis.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skumis', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_skumisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skumis', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_skumisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skumis', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_skumisfail');

CREATE TABLE c_skupol ( 
      CSKUPOL Char( 12 ),
      CNAZSKUPOL Char( 20 ),
      CKODPRG Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skupol',
   'c_skupol.adi',
   'SKUPOL1',
   'UPPER(CSKUPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skupol',
   'c_skupol.adi',
   'SKUPOL2',
   'UPPER(CNAZSKUPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skupol',
   'c_skupol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skupol', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_skupolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skupol', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_skupolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skupol', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_skupolfail');

CREATE TABLE c_skupuc ( 
      CSKUPUCT Char( 6 ),
      CNAZSKUPUC Char( 30 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skupuc',
   'c_skupuc.adi',
   'SKUPUC_1',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skupuc',
   'c_skupuc.adi',
   'SKUPUC_2',
   'UPPER(CNAZSKUPUC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_skupuc',
   'c_skupuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skupuc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_skupucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skupuc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_skupucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_skupuc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_skupucfail');

CREATE TABLE c_spojen ( 
      CTYPSPOJ Char( 10 ),
      CZKRSPOJ Char( 10 ),
      CNAZSPOJ Char( 50 ),
      CADRELSPOJ Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_spojen',
   'c_spojen.adi',
   'C_SPOJEN01',
   'UPPER(CZKRSPOJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_spojen',
   'c_spojen.adi',
   'C_SPOJEN02',
   'UPPER(CTYPSPOJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_spojen',
   'c_spojen.adi',
   'C_SPOJEN03',
   'UPPER(CNAZSPOJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_spojen',
   'c_spojen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_spojen', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_spojenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_spojen', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_spojenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_spojen', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_spojenfail');

CREATE TABLE c_srazky ( 
      CZKRSRAZKY Char( 8 ),
      CNAZSRAZKY Char( 25 ),
      LPREDNPOHL Logical,
      CTYPSRZ Char( 4 ),
      NTYPSRZ Short,
      NDRUHMZDY Short,
      NDRUHMZDY2 Short,
      NDRUHMZDY3 Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_srazky',
   'c_srazky.adi',
   'C_SRAZKY01',
   'UPPER(CZKRSRAZKY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_srazky',
   'c_srazky.adi',
   'C_SRAZKY02',
   'UPPER(CNAZSRAZKY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_srazky',
   'c_srazky.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_srazky', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_srazkyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_srazky', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_srazkyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_srazky', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_srazkyfail');

CREATE TABLE c_stapri ( 
      NSTAPRIPOM Short,
      CNAZSTAPRI Char( 100 ),
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stapri',
   'c_stapri.adi',
   'C_STAPRI01',
   'NSTAPRIPOM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stapri',
   'c_stapri.adi',
   'C_STAPRI02',
   'UPPER(CNAZSTAPRI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stapri',
   'c_stapri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stapri', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_staprifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stapri', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_staprifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stapri', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_staprifail');

CREATE TABLE c_stares ( 
      CTYPSTARES Char( 10 ),
      CZKRSTARES Char( 10 ),
      CNAZSTARES Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stares',
   'c_stares.adi',
   'C_STARES01',
   'UPPER(CZKRSTARES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stares',
   'c_stares.adi',
   'C_STARES02',
   'UPPER(CTYPSTARES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stares',
   'c_stares.adi',
   'C_STARES03',
   'UPPER(CNAZSTARES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stares',
   'c_stares.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stares', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_staresfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stares', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_staresfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stares', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_staresfail');

CREATE TABLE c_statpr ( 
      CZKRSTAPRI Char( 25 ),
      CNAZSTAPRI Char( 30 ),
      CZKRATSTAT Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_statpr',
   'c_statpr.adi',
   'STAPRI01',
   'UPPER(CZKRSTAPRI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_statpr',
   'c_statpr.adi',
   'STAPRI02',
   'UPPER(CNAZSTAPRI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_statpr',
   'c_statpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_statpr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_statprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_statpr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_statprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_statpr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_statprfail');

CREATE TABLE c_staty ( 
      CZKRATSTAT Char( 3 ),
      CZKRATMENY Char( 3 ),
      CNAZEVSTAT Char( 25 ),
      CZKRATSTA2 Char( 2 ),
      CNAZSTAMEZ Char( 60 ),
      CSTATKODZA Char( 6 ),
      CNUMKODSTA Char( 3 ),
      MNAZEVSTAP Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_staty',
   'c_staty.adi',
   'C_STATY1',
   'UPPER(CZKRATSTAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_staty',
   'c_staty.adi',
   'C_STATY2',
   'UPPER(CNAZEVSTAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_staty',
   'c_staty.adi',
   'C_STATY3',
   'UPPER(CZKRATMENY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_staty',
   'c_staty.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_staty', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_statyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_staty', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_statyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_staty', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_statyfail');

CREATE TABLE c_stred ( 
      CSTRED Char( 8 ),
      CNAZSTR Char( 20 ),
      CTYPSTR Char( 10 ),
      CNAZPOL1 Char( 8 ),
      CSUBJE Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stred',
   'c_stred.adi',
   'STRED1',
   'UPPER(CSTRED)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stred',
   'c_stred.adi',
   'STRED2',
   'UPPER(CNAZSTR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stred',
   'c_stred.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stred', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_stredfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stred', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_stredfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stred', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_stredfail');

CREATE TABLE c_streod ( 
      NCISFIRMY Integer,
      CSTRED_ODB Char( 8 ),
      CNAZEV Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_streod',
   'c_streod.adi',
   'C_STRE1',
   'STRZERO(NCISFIRMY,5) +UPPER(CSTRED_ODB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_streod',
   'c_streod.adi',
   'C_STRE2',
   'STRZERO(NCISFIRMY,5) +UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_streod',
   'c_streod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_streod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_streodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_streod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_streodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_streod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_streodfail');

CREATE TABLE c_strjod ( 
      NCISFIRMY Integer,
      CSTROJ_ODB Char( 8 ),
      CNAZEV Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_strjod',
   'c_strjod.adi',
   'C_STRE1',
   'STRZERO(NCISFIRMY,5) +UPPER(CSTROJ_ODB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_strjod',
   'c_strjod.adi',
   'C_STRE2',
   'STRZERO(NCISFIRMY,5) +UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_strjod',
   'c_strjod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_strjod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_strjodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_strjod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_strjodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_strjod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_strjodfail');

CREATE TABLE c_stroje ( 
      NTYPSTROJE Short,
      CNAZEVTYPU Char( 15 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stroje',
   'c_stroje.adi',
   'C_STROJ1',
   'NTYPSTROJE',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_stroje',
   'c_stroje.adi',
   'C_STROJ2',
   'UPPER(CNAZEVTYPU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stroje', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_strojefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stroje', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_strojefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_stroje', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_strojefail');

CREATE TABLE c_svatky ( 
      DDATUM Date,
      CNAZEV Char( 25 ),
      NROK Short,
      NMESIC Short,
      NDEN Short,
      LSVATEK Logical,
      LVOLDEN Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_svatky',
   'c_svatky.adi',
   'C_SVATKY01',
   'DTOS ( DDATUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_svatky',
   'c_svatky.adi',
   'C_SVATKY02',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_svatky',
   'c_svatky.adi',
   'C_SVATKY03',
   'STRZERO(NROK,4) +STRZERO(NMESIC,2) +STRZERO(NDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_svatky',
   'c_svatky.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_svatky', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_svatkyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_svatky', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_svatkyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_svatky', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_svatkyfail');

CREATE TABLE c_syntuc ( 
      CUCET Char( 6 ),
      CNAZ_UCT Char( 30 ),
      CUCETMD Char( 6 ),
      LNAKLSTR Logical,
      CZUSTUCT Char( 1 ),
      LVYNOSUCT Logical,
      LNAKLUCT Logical,
      LAKTIVUCT Logical,
      LPASIVUCT Logical,
      LZAVERUCT Logical,
      LPODRZUCT Logical,
      LPODR_UCZ Logical,
      LNATURUCT Logical,
      LSALDOUCT Logical,
      LFINUCT Logical,
      LDANUCT Logical,
      LMIMORUCT Logical,
      LSYNTUCT Logical,
      CSKUPUCT Char( 90 ),
      MPOZ_UCT Memo,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo,
      CUCETSY Char( 3 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC1',
   'UPPER(CUCETSY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC3',
   'UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_syntuc',
   'c_syntuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_syntuc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_syntucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_syntuc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_syntucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_syntuc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_syntucfail');

CREATE TABLE c_tarif ( 
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      NHODINSAZ Double( 3 ),
      NHODINNAV Double( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tarif',
   'c_tarif.adi',
   'C_TARIF1',
   'UPPER(CTARIFSTUP) +UPPER(CTARIFTRID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tarif',
   'c_tarif.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarif', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_tariffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarif', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_tariffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarif', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_tariffail');

CREATE TABLE c_tarify ( 
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      CDELKPRDOB Char( 15 ),
      DPLATTAROD Date,
      NTARSAZHOD Double( 3 ),
      NTARSAZMES Double( 3 ),
      NHODSAZFIR Double( 3 ),
      NMESSAZFIR Double( 3 ),
      LAKTTARIF Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tarify',
   'c_tarify.adi',
   'C_TARIFY01',
   'UPPER(CTARIFSTUP) +UPPER(CTARIFTRID) +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tarify',
   'c_tarify.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarify', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_tarifyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarify', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_tarifyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarify', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_tarifyfail');

CREATE TABLE c_tarstu ( 
      CTARIFSTUP Char( 8 ),
      CNAZTARSTU Char( 35 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tarstu',
   'c_tarstu.adi',
   'C_TARSTU01',
   'UPPER(CTARIFSTUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tarstu',
   'c_tarstu.adi',
   'C_TARSTU02',
   'UPPER(CNAZTARSTU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tarstu',
   'c_tarstu.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarstu', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_tarstufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarstu', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_tarstufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tarstu', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_tarstufail');

CREATE TABLE c_tartri ( 
      CTARIFTRID Char( 8 ),
      CNAZTARTRI Char( 35 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tartri',
   'c_tartri.adi',
   'C_TARTRI01',
   'UPPER(CTARIFTRID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tartri',
   'c_tartri.adi',
   'C_TARTRI02',
   'UPPER(CNAZTARTRI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tartri',
   'c_tartri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tartri', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_tartrifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tartri', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_tartrifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tartri', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_tartrifail');

CREATE TABLE c_task ( 
      CTASK Char( 3 ),
      CNAZULOHY Char( 50 ),
      CULOHA Char( 1 ),
      LUCTUJ Logical,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_task',
   'c_task.adi',
   'C_TASK01',
   'UPPER(CTASK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_task',
   'c_task.adi',
   'C_TASK02',
   'UPPER(CNAZULOHY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_task',
   'c_task.adi',
   'C_TASK03',
   'UPPER(CULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_task',
   'c_task.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_task', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_taskfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_task', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_taskfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_task', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_taskfail');

CREATE TABLE c_termin ( 
      NPORTERMIN Short,
      CNAZTERMIN Char( 30 ),
      LAKTIVNI Logical,
      CADRTERM Char( 10 ),
      CSNTERM Char( 10 ),
      MINITPOPIS Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_termin',
   'c_termin.adi',
   'TERMIN01',
   'NPORTERMIN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_termin',
   'c_termin.adi',
   'TERMIN02',
   'UPPER(CNAZTERMIN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_termin',
   'c_termin.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_termin', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_terminfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_termin', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_terminfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_termin', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_terminfail');

CREATE TABLE c_titpr ( 
      CTITULPRED Char( 20 ),
      CNAZTITPR Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_titpr',
   'c_titpr.adi',
   'C_TITPR01',
   'UPPER(CTITULPRED)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_titpr',
   'c_titpr.adi',
   'C_TITPR02',
   'UPPER(CNAZTITPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_titpr',
   'c_titpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_titpr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_titprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_titpr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_titprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_titpr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_titprfail');

CREATE TABLE c_titza ( 
      CTITULZA Char( 20 ),
      CNAZTITZA Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_titza',
   'c_titza.adi',
   'C_TITZA01',
   'UPPER(CTITULZA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_titza',
   'c_titza.adi',
   'C_TITZA02',
   'UPPER(CNAZTITZA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_titza',
   'c_titza.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_titza', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_titzafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_titza', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_titzafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_titza', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_titzafail');

CREATE TABLE c_trasy ( 
      CCISTRASY Char( 10 ),
      CNAZTRASY Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_trasy',
   'c_trasy.adi',
   'TRASY1',
   'UPPER(CCISTRASY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_trasy',
   'c_trasy.adi',
   'TRASY2',
   'UPPER(CNAZTRASY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_trasy',
   'c_trasy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_trasy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_trasyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_trasy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_trasyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_trasy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_trasyfail');

CREATE TABLE c_triduc ( 
      CUCET Char( 6 ),
      CNAZ_UCT Char( 30 ),
      CUCETMD Char( 6 ),
      LNAKLSTR Logical,
      CZUSTUCT Char( 1 ),
      LVYNOSUCT Logical,
      LNAKLUCT Logical,
      LAKTIVUCT Logical,
      LPASIVUCT Logical,
      LZAVERUCT Logical,
      LPODRZUCT Logical,
      LPODR_UCZ Logical,
      LNATURUCT Logical,
      LSALDOUCT Logical,
      LFINUCT Logical,
      LDANUCT Logical,
      LMIMORUCT Logical,
      LSYNTUCT Logical,
      CSKUPUCT Char( 90 ),
      MPOZ_UCT Memo,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo,
      CUCETTR Char( 1 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC1',
   'UPPER(CUCETTR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC3',
   'UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_triduc',
   'c_triduc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_triduc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_triducfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_triduc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_triducfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_triduc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_triducfail');

CREATE TABLE c_typabo ( 
      CTYPABO Char( 6 ),
      CPOPISABO Char( 30 ),
      NKODBANKY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typabo',
   'c_typabo.adi',
   'TYPABO01',
   'UPPER(CTYPABO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typabo',
   'c_typabo.adi',
   'TYPABO02',
   'UPPER(CPOPISABO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typabo',
   'c_typabo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typabo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typabofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typabo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typabofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typabo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typabofail');

CREATE TABLE c_typblo ( 
      CTYPBLOKAC Char( 6 ),
      CPOPISTYPU Char( 30 ),
      CKODBLOKAC Char( 3 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typblo',
   'c_typblo.adi',
   'C_TYPBL0',
   'UPPER(CTYPBLOKAC) +UPPER(CPOPISTYPU) +UPPER(CKODBLOKAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typblo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typblofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typblo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typblofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typblo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typblofail');

CREATE TABLE c_typcen ( 
      CTYPSKLCEN Char( 3 ),
      CNAZEVCENY Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typcen',
   'c_typcen.adi',
   'C_TYPCE1',
   'UPPER(CTYPSKLCEN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typcen',
   'c_typcen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typcen', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typcenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typcen', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typcenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typcen', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typcenfail');

CREATE TABLE c_typdan ( 
      NTYPDANE Short,
      CNAZTYPDAN Char( 30 ),
      CVYUZULOHD Char( 30 ),
      NPROCDAN Double( 2 ),
      DDATPLATOD Date,
      CPOPISDAN Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdan',
   'c_typdan.adi',
   'C_TYPDAN01',
   'NTYPDANE',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdan',
   'c_typdan.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdan', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typdanfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdan', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typdanfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdan', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typdanfail');

CREATE TABLE c_typdim ( 
      NTYPDIM Short,
      CNAZTYPDIM Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdim',
   'c_typdim.adi',
   'C_1',
   'NTYPDIM',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdim',
   'c_typdim.adi',
   'C_2',
   'UPPER(CNAZTYPDIM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdim',
   'c_typdim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdim', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typdimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdim', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typdimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdim', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typdimfail');

CREATE TABLE c_typdkm ( 
      CTYPDOKUM Char( 10 ),
      CNAZTYP Char( 50 ),
      CTYPEDIT Char( 10 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdkm',
   'c_typdkm.adi',
   'C_TYPDKM01',
   'UPPER(CTYPDOKUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdkm',
   'c_typdkm.adi',
   'C_TYPDKM02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdkm',
   'c_typdkm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdkm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typdkmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdkm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typdkmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdkm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typdkmfail');

CREATE TABLE c_typdmz ( 
      CTYPDMZ Char( 4 ),
      CNAZTYPDMZ Char( 30 ),
      CTYPNAPHOC Char( 2 ),
      CTYPNAPMZC Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdmz',
   'c_typdmz.adi',
   'C_TYPDMZ01',
   'UPPER(CTYPDMZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdmz',
   'c_typdmz.adi',
   'C_TYPDMZ02',
   'UPPER(CNAZTYPDMZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdmz',
   'c_typdmz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdmz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typdmzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdmz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typdmzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdmz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typdmzfail');

CREATE TABLE c_typdok ( 
      CTASK Char( 3 ),
      CPODULOHA Char( 15 ),
      CTYPDOKLAD Char( 10 ),
      CNAZTYPDOK Char( 30 ),
      CULOHA Char( 1 ),
      MPOPITYPDO Memo,
      DPLATNYOD Date,
      DPLATNYDO Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdok',
   'c_typdok.adi',
   'C_TYPDOK01',
   'UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typdok',
   'c_typdok.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdok', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typdokfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdok', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typdokfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typdok', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typdokfail');

CREATE TABLE c_typfak ( 
      CZKRTYPFAK Char( 5 ),
      CPOPISFAK Char( 25 ),
      NFINTYP Short,
      LTEXTFAKT Logical,
      NKONSTSYMB Short,
      CZKRTYPUHR Char( 5 ),
      CCRDMAIN Char( 12 ),
      CCRDNAME Char( 12 ),
      LISPARFAK Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typfak',
   'c_typfak.adi',
   'TYPFAK1',
   'UPPER(CZKRTYPFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typfak',
   'c_typfak.adi',
   'TYPFAK2',
   'UPPER(CPOPISFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typfak',
   'c_typfak.adi',
   'TYPFAK3',
   'STRZERO(NFINTYP,1) +UPPER(CPOPISFAK) +IF (LISPARFAK, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typfak',
   'c_typfak.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typfak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typfakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typfak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typfakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typfak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typfakfail');

CREATE TABLE c_typfo ( 
      NKODFYZOSB Char( 3 ),
      CPOPISFYOS Char( 30 ),
      CSTATKODZA Char( 6 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typfo',
   'c_typfo.adi',
   'C_FYZOS1',
   'UPPER(NKODFYZOSB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typfo',
   'c_typfo.adi',
   'C_FYZOS2',
   'UPPER(CPOPISFYOS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typfo',
   'c_typfo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typfo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typfofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typfo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typfofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typfo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typfofail');

CREATE TABLE c_typhod ( 
      CTYPHODNOC Char( 2 ),
      CNAZTYPHOD Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typhod',
   'c_typhod.adi',
   'C_1',
   'UPPER(CTYPHODNOC)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typhod',
   'c_typhod.adi',
   'C_2',
   'UPPER(CNAZTYPHOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typhod',
   'c_typhod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typhod', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typhodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typhod', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typhodfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typhod', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typhodfail');

CREATE TABLE c_typkai ( 
      NKARTA Short,
      CPOPISKAR Char( 30 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkai',
   'c_typkai.adi',
   'C_TYPKAI1',
   'NKARTA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkai',
   'c_typkai.adi',
   'C_TYPKAI2',
   'UPPER(CPOPISKAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkai',
   'c_typkai.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkai', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typkaifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkai', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typkaifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkai', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typkaifail');

CREATE TABLE c_typkar ( 
      NKARTA Short,
      CPOPISKAR Char( 30 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkar',
   'c_typkar.adi',
   'TYPKAR1',
   'NKARTA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkar',
   'c_typkar.adi',
   'TYPKAR2',
   'UPPER( CPOPISKAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkar',
   'c_typkar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkar', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typkarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkar', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typkarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkar', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typkarfail');

CREATE TABLE c_typkaz ( 
      NKARTA Short,
      CPOPISKAR Char( 30 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkaz',
   'c_typkaz.adi',
   'C_TYPKAZ1',
   'NKARTA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkaz',
   'c_typkaz.adi',
   'C_TYPKAZ2',
   'UPPER(CPOPISKAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typkaz',
   'c_typkaz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkaz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typkazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkaz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typkazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typkaz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typkazfail');

CREATE TABLE c_typlis ( 
      CTYPLISTKU Char( 3 ),
      CPOPISTYPU Char( 30 ),
      CKODLISTKU Char( 3 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typlis',
   'c_typlis.adi',
   'C_TYPLI1',
   'UPPER(CTYPLISTKU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typlis', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typlisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typlis', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typlisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typlis', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typlisfail');

CREATE TABLE c_typmaj ( 
      NTYPMAJ Short,
      CNAZTYPU Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmaj',
   'c_typmaj.adi',
   'C_TYPMAJ1',
   'NTYPMAJ',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmaj',
   'c_typmaj.adi',
   'C_TYPMAJ2',
   'UPPER(CNAZTYPU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmaj',
   'c_typmaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmaj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typmajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmaj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typmajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmaj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typmajfail');

CREATE TABLE c_typmat ( 
      CTYPMAT Char( 3 ),
      CNAZTYPMAT Char( 30 ),
      CKODPRG Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmat',
   'c_typmat.adi',
   'TYPMAT1',
   'UPPER(CTYPMAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmat',
   'c_typmat.adi',
   'TYPMAT2',
   'UPPER(CNAZTYPMAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmat',
   'c_typmat.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmat', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typmatfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmat', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typmatfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmat', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typmatfail');

CREATE TABLE c_typmer ( 
      CTYPMERENI Char( 2 ),
      CNAZTYPMER Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmer',
   'c_typmer.adi',
   'C_1',
   'UPPER(CTYPMERENI)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmer',
   'c_typmer.adi',
   'C_2',
   'UPPER(CNAZTYPMER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typmer',
   'c_typmer.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmer', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typmerfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmer', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typmerfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typmer', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typmerfail');

CREATE TABLE c_typop ( 
      CTYPOPER Char( 3 ),
      CPOPISOPER Char( 30 ),
      CKODOPER Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typop',
   'c_typop.adi',
   'TYPOPER1',
   'UPPER(CTYPOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typop',
   'c_typop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typop', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typop', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typop', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typopfail');

CREATE TABLE c_typpoh ( 
      CULOHA Char( 1 ),
      CPODULOHA Char( 15 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CSUBPOHYB Char( 11 ),
      CNAZTYPPOH Char( 30 ),
      CRADDPH Char( 30 ),
      CRADDPH091 Char( 30 ),
      CTASK Char( 3 ),
      CSUBTASK Char( 3 ),
      CTYPKURZU Char( 3 ),
      LNAKLSTR Logical,
      MPOPITYPPO Memo,
      DPLATNYOD Date,
      DPLATNYDO Date,
      NKARTA Short,
      LPRODUKCE Logical,
      NTYPPOHYB Short,
      NDRPOHPL1 Short,
      NDRPOHPL2 Short,
      NDRPOHPLPR Short,
      NPODM Short,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH01',
   'UPPER(CULOHA)+UPPER(CPODULOHA)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH02',
   'UPPER(CULOHA)+UPPER(CPODULOHA) +UPPER(CTYPPOHYBU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH03',
   'UPPER(CTYPPOHYBU)+UPPER(CULOHA)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH04',
   'UPPER(CTASK)+UPPER(CPODULOHA)+UPPER(CTYPPOHYBU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH05',
   'UPPER(CULOHA)+UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH06',
   'UPPER(CULOHA)+UPPER(CTYPPOHYBU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpoh',
   'c_typpoh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typpoh', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typpohfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typpoh', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typpohfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typpoh', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typpohfail');

CREATE TABLE c_typpol ( 
      CTYPPOL Char( 3 ),
      CNAZTYPPOL Char( 20 ),
      CKODPRG Char( 2 ),
      LFINAL Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpol',
   'c_typpol.adi',
   'TYPPOL1',
   'UPPER(CTYPPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpol',
   'c_typpol.adi',
   'TYPPOL2',
   'UPPER(CNAZTYPPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typpol',
   'c_typpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typpol', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typpol', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typpol', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typpolfail');

CREATE TABLE c_typses ( 
      CTYPSESTAV Char( 2 ),
      CNAZTYPSES Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typses',
   'c_typses.adi',
   'C_1',
   'UPPER(CTYPSESTAV)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typses',
   'c_typses.adi',
   'C_2',
   'UPPER(CNAZTYPSES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typses',
   'c_typses.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typses', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typsesfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typses', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typsesfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typses', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typsesfail');

CREATE TABLE c_typskp ( 
      CTYPSKP Char( 15 ),
      CNAZTYPSKP Char( 25 ),
      NODPISK Short,
      CODPISK Char( 4 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typskp',
   'c_typskp.adi',
   'C_SKP1',
   'UPPER(CTYPSKP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typskp',
   'c_typskp.adi',
   'C_SKP2',
   'UPPER(CNAZTYPSKP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typskp',
   'c_typskp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typskp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typskp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typskp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typskpfail');

CREATE TABLE c_typspo ( 
      CTYPSPOJ Char( 10 ),
      CNAZTYP Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typspo',
   'c_typspo.adi',
   'C_TYPSPO01',
   'UPPER(CTYPSPOJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typspo',
   'c_typspo.adi',
   'C_TYPSPO02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typspo',
   'c_typspo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typspo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typspofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typspo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typspofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typspo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typspofail');

CREATE TABLE c_typsrz ( 
      CTYPSRZ Char( 4 ),
      CNAZTYPSRZ Char( 30 ),
      NTYPSRZ Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typsrz',
   'c_typsrz.adi',
   'C_TYPSRZ01',
   'UPPER(CTYPSRZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typsrz',
   'c_typsrz.adi',
   'C_TYPSRZ02',
   'UPPER(CNAZTYPSRZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typsrz',
   'c_typsrz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typsrz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typsrzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typsrz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typsrzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typsrz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typsrzfail');

CREATE TABLE c_typtrp ( 
      CZKRTRVPLA Char( 5 ),
      CNAZTYPTRP Char( 30 ),
      CZKRROZLTP Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typtrp',
   'c_typtrp.adi',
   'C_TYPTRP01',
   'UPPER(CZKRTRVPLA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typtrp',
   'c_typtrp.adi',
   'C_TYPTRP02',
   'UPPER(CNAZTYPTRP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typtrp',
   'c_typtrp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typtrp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typtrpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typtrp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typtrpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typtrp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typtrpfail');

CREATE TABLE c_typuct ( 
      CULOHA Char( 1 ),
      CTYPUCT Char( 2 ),
      CPOPISUCT Char( 25 ),
      MPOPISUCT Memo,
      CTEXTUCT Char( 80 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typuct',
   'c_typuct.adi',
   'TYPUCT1',
   'UPPER(CULOHA) +UPPER(CTYPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typuct',
   'c_typuct.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typuct', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typuctfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typuct', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typuctfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typuct', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typuctfail');

CREATE TABLE c_typuhr ( 
      CZKRTYPUHR Char( 5 ),
      CPOPISUHR Char( 20 ),
      NKODZAOKR Short,
      LISINKASO Logical,
      LISHOTOV Logical,
      LISREGPOK Logical,
      LISREGDEF Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typuhr',
   'c_typuhr.adi',
   'TYPUHR1',
   'UPPER(CZKRTYPUHR)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typuhr',
   'c_typuhr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typuhr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typuhrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typuhr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typuhrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typuhr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typuhrfail');

CREATE TABLE c_typukl ( 
      CTYPUKOLU Char( 10 ),
      CNAZTYP Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typukl',
   'c_typukl.adi',
   'C_TYPUKL01',
   'UPPER(CTYPUKOLU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typukl',
   'c_typukl.adi',
   'C_TYPUKL02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typukl',
   'c_typukl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typukl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typuklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typukl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typuklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typukl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typuklfail');

CREATE TABLE c_typvys ( 
      CTYPVYS Char( 4 ),
      CNAZTYPVYS Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typvys',
   'c_typvys.adi',
   'C_TYPVYS01',
   'UPPER(CTYPVYS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typvys',
   'c_typvys.adi',
   'C_TYPVYS02',
   'UPPER(CNAZTYPVYS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typvys',
   'c_typvys.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typvys', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typvysfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typvys', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typvysfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typvys', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typvysfail');

CREATE TABLE c_typzak ( 
      CTYPZAK Char( 2 ),
      CNAZEV Char( 20 ),
      NPOLZAK Short,
      LPOLZAK Logical,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_typzak',
   'c_typzak.adi',
   'C_TYPZAK1',
   'UPPER(CTYPZAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_typzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_typzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_typzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_typzakfail');

CREATE TABLE c_tystre ( 
      CTYPSTARES Char( 10 ),
      CNAZTYP Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tystre',
   'c_tystre.adi',
   'C_TYSTRE01',
   'UPPER(CTYPSTARES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tystre',
   'c_tystre.adi',
   'C_TYSTRE02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_tystre',
   'c_tystre.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tystre', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_tystrefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tystre', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_tystrefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_tystre', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_tystrefail');

CREATE TABLE c_ucetskp ( 
      CODPISK Char( 4 ),
      NODPISK Short,
      NROKYODPIS Short,
      NROPRVNI Double( 2 ),
      NRODALSI Double( 2 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ucetskp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_ucetskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ucetskp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_ucetskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ucetskp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_ucetskpfail');

CREATE TABLE c_uctden ( 
      CDENIK Char( 2 ),
      CNAZDENIK Char( 50 ),
      CTASK Char( 3 ),
      CULOHA Char( 1 ),
      CITEM Char( 10 ),
      LUCTUJ Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctden',
   'c_uctden.adi',
   'C_UCTDEN01',
   'UPPER(CDENIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctden',
   'c_uctden.adi',
   'C_UCTDEN02',
   'UPPER(CNAZDENIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctden',
   'c_uctden.adi',
   'C_UCTDEN03',
   'UPPER(CTASK)+UPPER(CDENIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctden',
   'c_uctden.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctden', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_uctdenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctden', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_uctdenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctden', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_uctdenfail');

CREATE TABLE c_uctosn ( 
      CUCET Char( 6 ),
      CNAZ_UCT Char( 30 ),
      CUCETMD Char( 6 ),
      LNAKLSTR Logical,
      CZUSTUCT Char( 1 ),
      LVYNOSUCT Logical,
      LNAKLUCT Logical,
      LAKTIVUCT Logical,
      LPASIVUCT Logical,
      LZAVERUCT Logical,
      LPODRZUCT Logical,
      LPODR_UCZ Logical,
      LNATURUCT Logical,
      LSALDOUCT Logical,
      LFINUCT Logical,
      LDANUCT Logical,
      LMIMORUCT Logical,
      LSYNTUCT Logical,
      CSKUPUCT Char( 90 ),
      MPOZ_UCT Memo,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN1',
   'UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN3',
   'UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctosn',
   'c_uctosn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctosn', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_uctosnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctosn', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_uctosnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctosn', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_uctosnfail');

CREATE TABLE c_uctskl ( 
      NCISLPOH Integer,
      NUCETSK_OD Short,
      NUCETSK_DO Short,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CUCETMD Char( 6 ),
      CTYPUCTMD Char( 2 ),
      CUCETDAL Char( 6 ),
      CTYPUCTDAL Char( 2 ),
      CPODUCT Char( 30 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskl',
   'c_uctskl.adi',
   'UCTSKL1',
   'STRZERO(NCISLPOH,5) +STRZERO(NUCETSK_OD,3) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskl',
   'c_uctskl.adi',
   'UCTSKL2',
   'NCISLPOH',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskl',
   'c_uctskl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_uctsklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_uctsklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_uctsklfail');

CREATE TABLE c_uctskp ( 
      NUCETSKUP Short,
      CNAZUCTSK Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskp',
   'c_uctskp.adi',
   'C_USKUP1',
   'NUCETSKUP',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskp',
   'c_uctskp.adi',
   'C_USKUP2',
   'UPPER (CNAZUCTSK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskp',
   'c_uctskp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_uctskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_uctskpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_uctskpfail');

CREATE TABLE c_uctskz ( 
      NUCETSKUP Short,
      CNAZUCTSK Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskz',
   'c_uctskz.adi',
   'C_UCTSKZ1',
   'NUCETSKUP',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskz',
   'c_uctskz.adi',
   'C_UCTSKZ2',
   'UPPER(CNAZUCTSK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uctskz',
   'c_uctskz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_uctskzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_uctskzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uctskz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_uctskzfail');

CREATE TABLE c_ukoly ( 
      CTYPUKOLU Char( 10 ),
      CZKRUKOLU Char( 10 ),
      CNAZUKOLU Char( 50 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ukoly',
   'c_ukoly.adi',
   'C_UKOLY01',
   'UPPER(CZKRUKOLU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ukoly',
   'c_ukoly.adi',
   'C_UKOLY02',
   'UPPER(CTYPUKOLU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ukoly',
   'c_ukoly.adi',
   'C_UKOLY03',
   'UPPER(CNAZUKOLU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ukoly',
   'c_ukoly.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ukoly', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_ukolyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ukoly', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_ukolyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ukoly', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_ukolyfail');

CREATE TABLE c_ukonpv ( 
      NTYPUKOPRV Short,
      CNAZUKOPRV Char( 40 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ukonpv',
   'c_ukonpv.adi',
   'UKPRVZ01',
   'NTYPUKOPRV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ukonpv',
   'c_ukonpv.adi',
   'UKPRVZ02',
   'UPPER(CNAZUKOPRV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ukonpv',
   'c_ukonpv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ukonpv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_ukonpvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ukonpv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_ukonpvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ukonpv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_ukonpvfail');

CREATE TABLE c_ulozmi ( 
      CCISSKLAD Char( 8 ),
      CULOZZBO Char( 8 ),
      CNAZEVMIST Char( 25 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'C_ULOZM1',
   'UPPER(CCISSKLAD)+ UPPER (CULOZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'C_ULOZM2',
   'UPPER(CULOZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'C_ULOZM3',
   'UPPER (CNAZEVMIST)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ulozmi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_ulozmifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ulozmi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_ulozmifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_ulozmi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_ulozmifail');

CREATE TABLE c_uzvzth ( 
      CZKRATUZVZ Char( 3 ),
      CNAZUZVZTH Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uzvzth',
   'c_uzvzth.adi',
   'C_UZVZT1',
   'UPPER(CZKRATUZVZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uzvzth',
   'c_uzvzth.adi',
   'C_UZVZT2',
   'UPPER(CNAZUZVZTH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_uzvzth',
   'c_uzvzth.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uzvzth', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_uzvzthfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uzvzth', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_uzvzthfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_uzvzth', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_uzvzthfail');

CREATE TABLE c_vbanuc ( 
      CVNBAN_UCT Char( 25 ),
      CUCET_NAZ Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vbanuc',
   'c_vbanuc.adi',
   'BANKUC1',
   'UPPER(CVNBAN_UCT)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vbanuc',
   'c_vbanuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vbanuc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vbanucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vbanuc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vbanucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vbanuc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vbanucfail');

CREATE TABLE c_vniuct ( 
      CNAZPOL2 Char( 8 ),
      CTYPZAK Char( 2 ),
      CUCETVNITR Char( 6 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vniuct',
   'c_vniuct.adi',
   'VNIUCT1',
   'UPPER(CNAZPOL2) +UPPER(CTYPZAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vniuct',
   'c_vniuct.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vniuct', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vniuctfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vniuct', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vniuctfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vniuct', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vniuctfail');

CREATE TABLE c_vnmzuc ( 
      NUCETMZDY Short,
      CNAZEVMZUC Char( 30 ),
      CTYPVNUCTO Char( 8 ),
      CUCETNAK1 Char( 6 ),
      CUCETVYN1 Char( 6 ),
      NSAZBAVNU1 Double( 2 ),
      NSAZBAPRAC Double( 2 ),
      NSAZBASTRO Double( 2 ),
      NTYPVYPOC1 Short,
      NTYPNULOV1 Short,
      LOPRAVNAK1 Logical,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CUCETNAK2 Char( 6 ),
      CUCETVYN2 Char( 6 ),
      NSAZBAVNU2 Double( 2 ),
      NTYPVYPOC2 Short,
      NTYPNULOV2 Short,
      LOPRAVNAK2 Logical,
      CNAZPOL1_2 Char( 8 ),
      CNAZPOL2_2 Char( 8 ),
      CNAZPOL3_2 Char( 8 ),
      CNAZPOL4_2 Char( 8 ),
      CNAZPOL5_2 Char( 8 ),
      CNAZPOL6_2 Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vnmzuc',
   'c_vnmzuc.adi',
   'C_VNMZUC01',
   'NUCETMZDY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vnmzuc',
   'c_vnmzuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vnmzuc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vnmzucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vnmzuc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vnmzucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vnmzuc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vnmzucfail');

CREATE TABLE c_vnsast ( 
      CCISSTROJE Char( 8 ),
      CNAZEVSTRO Char( 30 ),
      CKMENSTRST Char( 8 ),
      CUCETNAK1 Char( 6 ),
      CUCETVYN1 Char( 6 ),
      NSAZBAVNU1 Double( 2 ),
      NTYPVYPOC1 Short,
      NTYPNULOV1 Short,
      NSAZBAVNU2 Double( 2 ),
      NTYPVYPOC2 Short,
      NTYPNULOV2 Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vnsast',
   'c_vnsast.adi',
   'C_VNSAST01',
   'UPPER(CCISSTROJE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vnsast',
   'c_vnsast.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vnsast', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vnsastfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vnsast', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vnsastfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vnsast', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vnsastfail');

CREATE TABLE c_vozdr ( 
      CVOZDRUH Char( 10 ),
      CNAZVOZDR Char( 20 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vozdr',
   'c_vozdr.adi',
   'C_VOZDR1',
   'UPPER(CVOZDRUH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vozdr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vozdrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vozdr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vozdrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vozdr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vozdrfail');

CREATE TABLE c_vozkat ( 
      CVOZKATEG Char( 10 ),
      CNAZVOZKAT Char( 20 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vozkat',
   'c_vozkat.adi',
   'C_VOZKA1',
   'UPPER(CVOZKATEG)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vozkat', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vozkatfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vozkat', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vozkatfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vozkat', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vozkatfail');

CREATE TABLE c_voztyp ( 
      CVOZTYP Char( 15 ),
      CNAZVOZTYP Char( 20 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_voztyp',
   'c_voztyp.adi',
   'C_VOZT1',
   'UPPER(CVOZTYP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_voztyp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_voztypfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_voztyp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_voztypfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_voztyp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_voztypfail');

CREATE TABLE c_vycnsh ( 
      NTYP_VYCNS Short,
      CNAZPOLVYC Char( 8 ),
      CNAZPOLNAZ Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vycnsh',
   'c_vycnsh.adi',
   'VYCNSH01',
   'STRZERO(NTYP_VYCNS,1) +UPPER(CNAZPOLVYC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vycnsh',
   'c_vycnsh.adi',
   'VYCNSH02',
   'STRZERO(NTYP_VYCNS,1) +UPPER(CNAZPOLNAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vycnsh',
   'c_vycnsh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vycnsh', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vycnshfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vycnsh', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vycnshfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vycnsh', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vycnshfail');

CREATE TABLE c_vycnsi ( 
      NTYP_VYCNS Short,
      CNAZPOLVYC Char( 8 ),
      CNAZPOLX Char( 8 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vycnsi',
   'c_vycnsi.adi',
   'VYCNSI01',
   'STRZERO(NTYP_VYCNS,1) +UPPER(CNAZPOLVYC) +UPPER(CNAZPOLX)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vycnsi',
   'c_vycnsi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vycnsi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vycnsifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vycnsi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vycnsifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vycnsi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vycnsifail');

CREATE TABLE c_vykazm ( 
      NDRUHMZDY Short,
      CVYK1_HOD Char( 10 ),
      CVYK1_DNY Char( 10 ),
      CVYK1_KC Char( 20 ),
      CVYK2_HOD Char( 10 ),
      CVYK2_DNY Char( 10 ),
      CVYK2_KC Char( 20 ),
      CVYK3_HOD Char( 10 ),
      CVYK3_DNY Char( 10 ),
      CVYK3_KC Char( 20 ),
      CVYK4_HOD Char( 10 ),
      CVYK4_DNY Char( 10 ),
      CVYK4_KC Char( 20 ),
      CVYK5_HOD Char( 10 ),
      CVYK5_DNY Char( 10 ),
      CVYK5_KC Char( 20 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykazm',
   'c_vykazm.adi',
   'C_VYKAZM01',
   'NDRUHMZDY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykazm',
   'c_vykazm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykazm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vykazmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykazm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vykazmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykazm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vykazmfail');

CREATE TABLE c_vykazy ( 
      NVYKAZ Short,
      CNAZRADEK Char( 30 ),
      CVYBKATEG Char( 60 ),
      CVYBPOHYB Char( 60 ),
      NTYPNAPOC Short,
      CPROMRADEK Char( 10 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykazy',
   'c_vykazy.adi',
   'C_VYKAZY1',
   'STRZERO( NVYKAZ, 3) + UPPER( CPROMRADEK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykazy',
   'c_vykazy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykazy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vykazyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykazy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vykazyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykazy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vykazyfail');

CREATE TABLE c_vykdph ( 
      LSETS__DPH Logical,
      NODDIL_DPH Short,
      CODDIL_DPH Char( 42 ),
      NRADEK_DPH Short,
      CRADEK_DPH Char( 42 ),
      NNAPOCET Short,
      CUCETU_DPH Char( 6 ),
      CZUSTUCT Char( 1 ),
      NDAT_OD Integer,
      NRADEK_VAZ Short,
      CRADEK_SAY Char( 22 ),
      CMASKA_DPH Char( 3 ),
      FAKPRIHD Char( 10 ),
      FAKPRIHDTU Char( 10 ),
      FAKVYSIT Char( 10 ),
      FAKVYSHDTU Char( 10 ),
      POKLADHD Char( 10 ),
      POKLADHDTU Char( 10 ),
      UCETDOHD Char( 10 ),
      UCETDOHDTU Char( 10 ),
      POKLIT Char( 10 ),
      POKLHDTU Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH1',
   'STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH2',
   'LSETS__DPH',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH3',
   'STRZERO(NRADEK_VAZ,3) +STRZERO(NRADEK_DPH,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH4',
   'STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3) +STRZERO(NDAT_OD,8)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykdph',
   'c_vykdph.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykdph', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vykdphfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykdph', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vykdphfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykdph', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vykdphfail');

CREATE TABLE c_vykrad ( 
      NRADEKVYK Short,
      CNAZRAVYK1 Char( 25 ),
      CNAZRAVYK2 Char( 25 ),
      CNAZRAVYK3 Char( 25 ),
      CNAZRAVYK4 Char( 25 ),
      CNAZRAVYK5 Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykrad',
   'c_vykrad.adi',
   'C_VYKRAD01',
   'NRADEKVYK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vykrad',
   'c_vykrad.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykrad', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vykradfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykrad', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vykradfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vykrad', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vykradfail');

CREATE TABLE c_vyplmi ( 
      CVYPLMIST Char( 8 ),
      CNAZVYPLMI Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vyplmi',
   'c_vyplmi.adi',
   'C_VYPLMI01',
   'UPPER(CVYPLMIST)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vyplmi',
   'c_vyplmi.adi',
   'C_VYPLMI02',
   'UPPER(CNAZVYPLMI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vyplmi',
   'c_vyplmi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vyplmi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vyplmifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vyplmi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vyplmifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vyplmi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vyplmifail');

CREATE TABLE c_vzdel ( 
      CZKRVZDEL Char( 8 ),
      CNAZVZDELA Char( 30 ),
      CTYPVZDSCP Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vzdel',
   'c_vzdel.adi',
   'VZDELA01',
   'UPPER(CZKRVZDEL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vzdel',
   'c_vzdel.adi',
   'VZDELA02',
   'UPPER(CNAZVZDELA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vzdel',
   'c_vzdel.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vzdel', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vzdelfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vzdel', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vzdelfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vzdel', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vzdelfail');

CREATE TABLE c_vzdeuk ( 
      CZKRUKOVZD Char( 8 ),
      CNAZUKOVZD Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vzdeuk',
   'c_vzdeuk.adi',
   'UKOVZD01',
   'UPPER(CZKRUKOVZD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vzdeuk',
   'c_vzdeuk.adi',
   'UKOVZD02',
   'UPPER(CNAZUKOVZD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_vzdeuk',
   'c_vzdeuk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vzdeuk', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_vzdeukfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vzdeuk', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_vzdeukfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_vzdeuk', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_vzdeukfail');

CREATE TABLE c_zamest ( 
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 35 ),
      LOPRAVEMIS Logical,
      CCISOSVEDC Char( 10 ),
      CNAZPOL1 Char( 8 ),
      LPRI_ZAL Logical,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zamest',
   'c_zamest.adi',
   'ZAMEST1',
   'NOSCISPRAC',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zamest',
   'c_zamest.adi',
   'ZAMEST2',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zamest',
   'c_zamest.adi',
   'ZAMEST3',
   'IF (LPRI_ZAL, ''1'', ''0'') +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zamest',
   'c_zamest.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zamest', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_zamestfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zamest', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_zamestfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zamest', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_zamestfail');

CREATE TABLE c_zamevz ( 
      NTYPZAMVZT Short,
      CNAZZAMVZT Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zamevz',
   'c_zamevz.adi',
   'ZAMVZT01',
   'NTYPZAMVZT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zamevz',
   'c_zamevz.adi',
   'ZAMVZT02',
   'UPPER(CNAZZAMVZT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zamevz',
   'c_zamevz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zamevz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_zamevzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zamevz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_zamevzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zamevz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_zamevzfail');

CREATE TABLE c_zaokr ( 
      NKODZAOKR Short,
      CPOPISZAOK Char( 30 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zaokr',
   'c_zaokr.adi',
   'C_ZAOKR1',
   'NKODZAOKR',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zaokr',
   'c_zaokr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zaokr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_zaokrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zaokr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_zaokrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zaokr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_zaokrfail');

CREATE TABLE c_zdrpoj ( 
      NZDRPOJIS Short,
      CNAZZDRPOJ Char( 30 ),
      CZKRZDRPOJ Char( 10 ),
      NKEYPOJIS Short,
      NCISFIRMY Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'ZDRPOJ01',
   'NZDRPOJIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'ZDRPOJ02',
   'UPPER(CZKRZDRPOJ) +UPPER(CNAZZDRPOJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'ZDRPOJ03',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zdrpoj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_zdrpojfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zdrpoj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_zdrpojfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zdrpoj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_zdrpojfail');

CREATE TABLE c_zpudop ( 
      CZKRZPUDOP Char( 15 ),
      CPOPISDOP Char( 30 ),
      NKOD_DOP Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zpudop',
   'c_zpudop.adi',
   'TYPUHR1',
   'UPPER(CZKRZPUDOP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zpudop',
   'c_zpudop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zpudop', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_zpudopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zpudop', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_zpudopfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zpudop', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_zpudopfail');

CREATE TABLE c_zpusrz ( 
      CZPUSSRAZ Char( 6 ),
      CPOPISZPSR Char( 30 ),
      LOBDOBI Logical,
      LCTVRTLETI Logical,
      LPOLOLETI Logical,
      LROK Logical,
      NOBDSRZ Short,
      NDENSRZ Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zpusrz',
   'c_zpusrz.adi',
   'ZPUSRZ01',
   'UPPER(CZPUSSRAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zpusrz',
   'c_zpusrz.adi',
   'ZPUSRZ02',
   'UPPER(CPOPISZPSR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'c_zpusrz',
   'c_zpusrz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zpusrz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'c_zpusrzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zpusrz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'c_zpusrzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'c_zpusrz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'c_zpusrzfail');

CREATE TABLE cenprodc ( 
      NKLICCENZB Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NZBOZIKAT Short,
      CNAZZBO Char( 50 ),
      NCENCNZBO Double( 2 ),
      NCENAPZBO Double( 2 ),
      NCENAMZBO Double( 2 ),
      NPROCMARZ Double( 2 ),
      NCENAP1ZBO Double( 2 ),
      NPROCMARZ1 Double( 2 ),
      NCENAP2ZBO Double( 2 ),
      NPROCMARZ2 Double( 2 ),
      NCENAP3ZBO Double( 2 ),
      NPROCMARZ3 Double( 2 ),
      NCENAP4ZBO Double( 2 ),
      NPROCMARZ4 Double( 2 ),
      DDATAKT Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'cenprodc',
   'cenprodc.adi',
   'CENPROD1',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenprodc',
   'cenprodc.adi',
   'CENPROD2',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenprodc',
   'cenprodc.adi',
   'CENPROD3',
   'UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenprodc',
   'cenprodc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenprodc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cenprodcfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenprodc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cenprodcfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenprodc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cenprodcfail');

CREATE TABLE cenzb_in ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      DDATINVEN Date,
      CNAZZBO Char( 50 ),
      NZBOZIKAT Short,
      NUCETSKUP Short,
      NCENASZBO Double( 2 ),
      NCENACZBO Double( 2 ),
      NMNOZSZBO Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_in',
   'cenzb_in.adi',
   'CENINV01',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATINVEN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_in',
   'cenzb_in.adi',
   'CENINV02',
   'DTOS (DDATINVEN) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_in',
   'cenzb_in.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_in', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cenzb_infail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_in', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cenzb_infail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_in', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cenzb_infail');

CREATE TABLE cenzb_ns ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CNAZZBO Char( 50 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CUCET Char( 6 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_ns',
   'cenzb_ns.adi',
   'CENZBNS1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_ns',
   'cenzb_ns.adi',
   'CENZBNS2',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_ns',
   'cenzb_ns.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_ns', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cenzb_nsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_ns', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cenzb_nsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_ns', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cenzb_nsfail');

CREATE TABLE cenzb_ps ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NROK Short,
      NZBOZIKAT Short,
      NUCETSKUP Short,
      NCENASZBO Double( 2 ),
      NCENAPOC Double( 2 ),
      NMNOZPOC Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_ps',
   'cenzb_ps.adi',
   'CENPS01',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_ps',
   'cenzb_ps.adi',
   'CENPS02',
   'STRZERO(NROK,4) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzb_ps',
   'cenzb_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_ps', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cenzb_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_ps', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cenzb_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzb_ps', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cenzb_psfail');

CREATE TABLE cenzboz ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NKLICNAZ Integer,
      NZBOZIKAT Short,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CNAZZBO Char( 50 ),
      CNAZZBO2 Char( 30 ),
      CTYPSKLPOL Char( 2 ),
      CKATCZBO Char( 15 ),
      CJKPOV Char( 15 ),
      CDANPZBO Char( 15 ),
      CZKRATJEDN Char( 3 ),
      NKLICDPH Short,
      NCENANZBO Double( 2 ),
      NCENCNZBO Double( 2 ),
      NCENAKURZ Double( 2 ),
      CZKRATMENY Char( 3 ),
      CZAHRMENA Char( 3 ),
      NCENAPZBO Double( 2 ),
      NCENAMZBO Double( 2 ),
      NCENASZBO Double( 4 ),
      NCENACZBO Double( 2 ),
      NCENASVZM Double( 2 ),
      NCENAVNI Double( 2 ),
      NCENAPOC Double( 2 ),
      NMNOZPOC Double( 4 ),
      NMNOZSZBO Double( 4 ),
      NMNOZKZBO Double( 4 ),
      NMNOZOZBO Double( 4 ),
      NMNOZRZBO Double( 4 ),
      NMNOZRSES Double( 4 ),
      NMNOZDZBO Double( 4 ),
      NMNOZNZBO Double( 4 ),
      NMAXZBO Double( 4 ),
      NMINZBO Double( 4 ),
      DDATPZBO Date,
      NRECNAB Integer,
      NRECZBO Integer,
      CZKRCARKOD Char( 15 ),
      NCARKKOD Double( 0 ),
      NTYPGENBCD Short,
      CCARKOD Char( 128 ),
      NCENPOL Short,
      CBAL Char( 15 ),
      NBALKS Double( 2 ),
      CCENSES Char( 1 ),
      NPRISRAZBO Double( 2 ),
      CULOZZBO Char( 8 ),
      LVICECENP Logical,
      CTYPSKLCEN Char( 3 ),
      CPOLCEN Char( 1 ),
      CVYRCIS Char( 1 ),
      CKATALCIS Char( 1 ),
      CVYROBCE Char( 25 ),
      CJAKOST Char( 10 ),
      MPOZZBO Memo,
      NULOZCELK Double( 4 ),
      CTYPSKP Char( 15 ),
      NKOEFMN Double( 6 ),
      NPRIRAZKA Double( 2 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      NNADMNOZZD Short,
      NMNOZWORK Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK01',
   'UPPER( CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK02',
   'UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK03',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) +STRZERO(NKLICNAZ,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK04',
   'UPPER(CCISSKLAD) + UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK05',
   'STRZERO(NZBOZIKAT,4) + UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK06',
   'STRZERO(NKLICNAZ,5) + UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK07',
   'UPPER(CCISSKLAD) +STRZERO(NZBOZIKAT,4) + UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK08',
   'NCARKKOD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK09',
   'NMNOZKZBO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK10',
   'STRZERO(NUCETSKUP,3) + UPPER(CCISSKLAD) + UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK11',
   'UPPER(CKATCZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK12',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK13',
   'UPPER(CSKLPOL) + UPPER(CCISSKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK14',
   'UPPER(CZKRCARKOD) + UPPER(CCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cenzboz',
   'cenzboz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzboz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cenzbozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzboz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cenzbozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cenzboz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cenzbozfail');

CREATE TABLE cinfsum ( 
      CKODSUMRAD Char( 10 ),
      CNAZSUMRAD Char( 25 ),
      NPORADI Short,
      LACTIVE Logical,
      LSUMHOD Logical,
      LSUMDNY Logical,
      CKODPRER Char( 3 ),
      ACKODPRER Memo,
      NKODPRER Short,
      ANKODPRER Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'cinfsum',
   'cinfsum.adi',
   'INFSUM01',
   'UPPER(CKODSUMRAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cinfsum',
   'cinfsum.adi',
   'INFSUM02',
   'UPPER(CNAZSUMRAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cinfsum',
   'cinfsum.adi',
   'INFSUM03',
   'NPORADI',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cinfsum',
   'cinfsum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cinfsum', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cinfsumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cinfsum', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cinfsumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cinfsum', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cinfsumfail');

CREATE TABLE cnazpol1 ( 
      CNAZPOL1 Char( 8 ),
      CNAZEV Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol1',
   'cnazpol1.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol1',
   'cnazpol1.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol1',
   'cnazpol1.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol1', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cnazpol1fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol1', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cnazpol1fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol1', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cnazpol1fail');

CREATE TABLE cnazpol2 ( 
      CNAZPOL2 Char( 8 ),
      CNAZEV Char( 25 ),
      CUCETTRZEB Char( 6 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol2',
   'cnazpol2.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL2 )',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol2',
   'cnazpol2.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol2',
   'cnazpol2.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol2', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cnazpol2fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol2', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cnazpol2fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol2', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cnazpol2fail');

CREATE TABLE cnazpol3 ( 
      CNAZPOL3 Char( 8 ),
      CNAZEV Char( 25 ),
      NPLANMATER Double( 2 ),
      NPLANMZDY Double( 2 ),
      NPLANREZIE Double( 2 ),
      NPLANCENA Double( 2 ),
      NSKUTMATER Double( 2 ),
      NSKUTMZDY Double( 2 ),
      NSKUTREZIE Double( 2 ),
      NSKUTCENA Double( 2 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol3',
   'cnazpol3.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL3)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol3',
   'cnazpol3.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol3',
   'cnazpol3.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol3', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cnazpol3fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol3', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cnazpol3fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol3', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cnazpol3fail');

CREATE TABLE cnazpol4 ( 
      CNAZPOL4 Char( 8 ),
      CNAZEV Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol4',
   'cnazpol4.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL4)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol4',
   'cnazpol4.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol4',
   'cnazpol4.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol4', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cnazpol4fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol4', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cnazpol4fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol4', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cnazpol4fail');

CREATE TABLE cnazpol5 ( 
      CNAZPOL5 Char( 8 ),
      CNAZEV Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol5',
   'cnazpol5.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL5)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol5',
   'cnazpol5.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol5',
   'cnazpol5.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol5', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cnazpol5fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol5', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cnazpol5fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol5', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cnazpol5fail');

CREATE TABLE cnazpol6 ( 
      CNAZPOL6 Char( 8 ),
      CNAZEV Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol6',
   'cnazpol6.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL6)',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol6',
   'cnazpol6.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'cnazpol6',
   'cnazpol6.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol6', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'cnazpol6fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol6', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'cnazpol6fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'cnazpol6', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'cnazpol6fail');

CREATE TABLE config ( 
      CITEM Char( 10 ),
      CTYP Char( 1 ),
      CNAME Char( 30 ),
      CVALUE Char( 25 ),
      LRANGE Logical,
      CPICTURE Char( 25 ),
      CTASK Char( 8 ),
      LMANAGER Logical,
      NFORGS Short,
      NSKLADY Short,
      NODBYT Short,
      NFINANCE Short,
      NPOKLADNA Short,
      NDIM Short,
      NIM Short,
      NZVIRATA Short,
      NUCTO Short,
      NZAKAZKY Short,
      NMZDY Short,
      NBCD Short,
      NEVIDSW Short,
      NPRODEJCI Short,
      NTPV Short,
      NRV Short,
      NPRODEJ Short,
      NPERSONAL Short,
      NDOCHAZKA Short,
      NLISTKY Short,
      NFIRMY Short,
      NEVIDAS Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_01',
   'UPPER( CTASK + ":" + CITEM )',
   '',
   3,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_02',
   'UPPER( CTASK )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_03',
   'STR( NFORGS, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_04',
   'STR( NSKLADY, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_05',
   'STR( NODBYT, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_06',
   'STR( NFINANCE, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_07',
   'STR( NPOKLADNA, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_08',
   'STR( NDIM, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_09',
   'STR( NIM, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_10',
   'STR( NZVIRATA, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_11',
   'STR( NUCTO, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_12',
   'STR( NZAKAZKY, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_13',
   'STR( NMZDY, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_14',
   'STR( NBCD, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_15',
   'STR( NEVIDSW, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_16',
   'STR( NPRODEJCI, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_17',
   'STR( NTPV, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_18',
   'STR( NRV, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_19',
   'STR( NPRODEJ, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_20',
   'STR( NPERSONAL, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_21',
   'STR( NDOCHAZKA, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'CONFIG_22',
   'STR( NEVIDAS, 1 )',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'config',
   'config.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'config', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'configfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'config', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'configfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'config', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'configfail');

CREATE TABLE confighd ( 
      CTASK Char( 10 ),
      CITEM Char( 10 ),
      CTYP Char( 1 ),
      CNAME Char( 30 ),
      CVALUE Char( 99 ),
      LRANGE Logical,
      CPICTURE Char( 99 ),
      DPLATN_OD Date,
      DPLATN_DO Date,
      NZPUSKONFI Short,
      NPRINT Short,
      MMETODIKA Memo,
      CTASKTM Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'confighd',
   'confighd.adi',
   'CONFIGHD01',
   'UPPER(CTASK)+UPPER(CITEM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'confighd',
   'confighd.adi',
   'CONFIGHD02',
   'UPPER(CITEM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'confighd',
   'confighd.adi',
   'CONFIGHD03',
   'NPRINT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'confighd',
   'confighd.adi',
   'CONFIGHD04',
   'UPPER(CTASKTM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'confighd',
   'confighd.adi',
   'CONFIGHD05',
   'UPPER(CNAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'confighd',
   'confighd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'confighd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'confighdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'confighd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'confighdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'confighd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'confighdfail');

CREATE TABLE configit ( 
      CTASK Char( 10 ),
      CITEM Char( 10 ),
      CTYP Char( 1 ),
      CNAME Char( 30 ),
      CVALUE Char( 99 ),
      LRANGE Logical,
      CPICTURE Char( 99 ),
      DPLATN_OD Date,
      DPLATN_DO Date,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'configit',
   'configit.adi',
   'CONFIGIT01',
   'UPPER(CTASK)+UPPER(CITEM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configit',
   'configit.adi',
   'CONFIGIT02',
   'UPPER(CITEM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configit',
   'configit.adi',
   'CONFIGIT03',
   'UPPER(CNAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configit',
   'configit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'configit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'configitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'configit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'configitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'configit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'configitfail');

CREATE TABLE configus ( 
      CUSER Char( 10 ),
      CTASK Char( 10 ),
      CITEM Char( 10 ),
      CTYP Char( 1 ),
      CNAME Char( 30 ),
      CVALUE Char( 99 ),
      LRANGE Logical,
      CPICTURE Char( 99 ),
      DPLATN_OD Date,
      DPLATN_DO Date,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'configus',
   'configus.adi',
   'CONFIGUS01',
   'UPPER(CTASK)+UPPER(CITEM)+UPPER(CUSER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configus',
   'configus.adi',
   'CONFIGUS02',
   'UPPER(CITEM)+UPPER(CTASK)+UPPER(CUSER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configus',
   'configus.adi',
   'CONFIGUS03',
   'UPPER(CITEM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configus',
   'configus.adi',
   'CONFIGUS04',
   'UPPER(CUSER)+UPPER(CTASK)+UPPER(CITEM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configus',
   'configus.adi',
   'CONFIGUS05',
   'UPPER(CNAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'configus',
   'configus.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'configus', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'configusfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'configus', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'configusfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'configus', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'configusfail');

CREATE TABLE datkomhd ( 
      CID Char( 4 ),
      NID Integer,
      CIDDATKOM Char( 10 ),
      CTASK Char( 3 ),
      CTYPDATKOM Char( 1 ),
      CZKRDATKOM Char( 10 ),
      CNAZDATKOM Char( 50 ),
      CUSER Char( 10 ),
      CMAINFILE Char( 10 ),
      NCNTDATKOM Double( 0 ),
      MBLOK Memo,
      NBLOK_DEF Short,
      MPROTOKOL Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH01',
   'UPPER(CIDDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH02',
   'UPPER(CZKRDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH03',
   'UPPER(CNAZDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH04',
   'UPPER(CMAINFILE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH05',
   'UPPER(CTYPDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH06',
   'NID',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH07',
   'UPPER(CNAZDATKOM)+UPPER(CIDDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH08',
   'NBLOK_DEF',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomhd',
   'datkomhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'datkomhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'datkomhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'datkomhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'datkomhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'datkomhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'datkomhdfail');

CREATE TABLE datkomit ( 
      CID Char( 4 ),
      NID Integer,
      CIDDATKOM Char( 10 ),
      CTASK Char( 3 ),
      CTYPDATKOM Char( 1 ),
      CZKRDATKOM Char( 10 ),
      CNAZDATKOM Char( 50 ),
      CUSER Char( 10 ),
      CMAINFILE Char( 10 ),
      NCNTDATKOM Double( 0 ),
      MBLOK Memo,
      NBLOK_DEF Short,
      MPROTOKOL Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo,
      NORDITEM Char( 1 ),
      CIDDATKOMH Char( 1 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomit',
   'datkomit.adi',
   'DATKOMI01',
   'UPPER(CIDDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomit',
   'datkomit.adi',
   'DATKOMI02',
   'UPPER(CZKRDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomit',
   'datkomit.adi',
   'DATKOMI03',
   'UPPER(CNAZDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'datkomit',
   'datkomit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'datkomit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'datkomitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'datkomit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'datkomitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'datkomit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'datkomitfail');

CREATE TABLE defvykhd ( 
      CID Char( 4 ),
      NID Integer,
      CIDVYKAZU Char( 10 ),
      CTASK Char( 3 ),
      CULOHA Char( 1 ),
      CTYPVYKAZU Char( 15 ),
      CNAZVYKAZU Char( 50 ),
      CTYPNAPVYB Char( 15 ),
      CTYPNAPVYE Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykhd',
   'defvykhd.adi',
   'DEFVYKHD01',
   'UPPER(CTYPVYKAZU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykhd',
   'defvykhd.adi',
   'DEFVYKHD02',
   'UPPER(CNAZVYKAZU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykhd',
   'defvykhd.adi',
   'DEFVYKHD03',
   'UPPER(CIDVYKAZU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykhd',
   'defvykhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvykhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'defvykhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvykhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'defvykhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvykhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'defvykhdfail');

CREATE TABLE defvykit ( 
      CIDVYKAZU Char( 10 ),
      CTASK Char( 3 ),
      CULOHA Char( 1 ),
      CTYPVYKAZU Char( 15 ),
      NRADEKVYK Short,
      CSKURADVYK Char( 10 ),
      CNAZRADVYK Char( 50 ),
      NSLOUPVYK Short,
      CSLOUPVYK Char( 2 ),
      CNAZSLOVYK Char( 50 ),
      CSKUPINA1 Char( 3 ),
      CSKUPINA2 Char( 3 ),
      CSKUPINA3 Char( 3 ),
      MVYBER Memo,
      MVYRAZ Memo,
      CTEXTRADEK Char( 80 ),
      CTEXTSLOUP Char( 80 ),
      CTYPNAPVYK Char( 15 ),
      CTYPKUMVYK Char( 2 ),
      NKODZAOKR Short,
      NTYPTISKU Short,
      CTEXTTM1 Char( 30 ),
      CTEXTTM2 Char( 30 ),
      CTEXTTM3 Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT01',
   'UPPER(CTYPVYKAZU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT02',
   'UPPER(CTASK)+UPPER(CTYPVYKAZU)+UPPER(CSKUPINA1)+UPPER(CSKUPINA2)+UPPER(CSKUPINA3)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT03',
   'UPPER(CTYPVYKAZU)+UPPER(CNAZRADVYK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT04',
   'UPPER(CTYPVYKAZU)+UPPER(CTYPKUMVYK)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT05',
   'UPPER(CTYPVYKAZU)+STRZERO(NSLOUPVYK,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT06',
   'UPPER(CTYPVYKAZU)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT07',
   'UPPER(CTASK)+UPPER(CTYPVYKAZU)+UPPER(CSKUPINA1)+UPPER(CSKUPINA2)+UPPER(CSKUPINA3)+STRZERO(NRADEKVYK,4)+STRZERO(NSLOUPVYK,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvykit',
   'defvykit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvykit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'defvykitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvykit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'defvykitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvykit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'defvykitfail');

CREATE TABLE defvyksy ( 
      CTASK Char( 3 ),
      CULOHA Char( 1 ),
      CTYPNAPVYK Char( 15 ),
      CNAZNAPVYK Char( 50 ),
      CTYPPOUNAP Char( 1 ),
      CMAINFILE Char( 10 ),
      CMAINFIELD Char( 10 ),
      CMAINVYBER Char( 25 ),
      CGRPVYBER Char( 50 ),
      MBLOCK Memo,
      MPODMINKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'defvyksy',
   'defvyksy.adi',
   'DEFVYKSY01',
   'UPPER(CTYPNAPVYK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvyksy',
   'defvyksy.adi',
   'DEFVYKSY02',
   'UPPER(CNAZNAPVYK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'defvyksy',
   'defvyksy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvyksy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'defvyksyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvyksy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'defvyksyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'defvyksy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'defvyksyfail');

CREATE TABLE dmaj ( 
      NINVCIS Double( 0 ),
      NTYPMAJ Short,
      NROKODPISU Short,
      NODPISK Short,
      NVSCENDRPS Double( 2 ),
      NOPRDANRPS Double( 2 ),
      NZUCENDRPS Double( 2 ),
      NTYPDODPI Short,
      CTYPSKP Char( 15 ),
      NPROCDANOD Double( 2 ),
      NDANODPROK Double( 2 ),
      NOPRDANRKS Double( 2 ),
      NZUCENDRKS Double( 2 ),
      NVSCENDRKS Double( 2 ),
      CODPISK Char( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'dmaj',
   'dmaj.adi',
   'DMAJ_1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dmaj',
   'dmaj.adi',
   'DMAJ_2',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dmaj',
   'dmaj.adi',
   'DMAJ_3',
   'STRZERO(NROKODPISU,4) + STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dmaj',
   'dmaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dmaj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dmajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dmaj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dmajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dmaj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dmajfail');

CREATE TABLE dmajz ( 
      NINVCIS Double( 0 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NROKODPISU Short,
      NODPISK Short,
      NVSCENDRPS Double( 2 ),
      NOPRDANRPS Double( 2 ),
      NZUCENDRPS Double( 2 ),
      NTYPDODPI Short,
      CTYPSKP Char( 15 ),
      NPROCDANOD Double( 2 ),
      NDANODPROK Double( 2 ),
      NOPRDANRKS Double( 2 ),
      NZUCENDRKS Double( 2 ),
      NVSCENDRKS Double( 2 ),
      CODPISK Char( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'dmajz',
   'dmajz.adi',
   'DMAJZ_1',
   'STRZERO(NUCETSKUP,3)+ STRZERO(NINVCIS,10) + STRZERO(NROKODPISU,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dmajz',
   'dmajz.adi',
   'DMAJZ_2',
   'STRZERO(NUCETSKUP,3)+ STRZERO(NINVCIS,10) + STRZERO(NROKODPISU,4)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dmajz',
   'dmajz.adi',
   'DMAJZ_3',
   'STRZERO(NROKODPISU,4) + STRZERO(NUCETSKUP,3)+ STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dmajz',
   'dmajz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dmajz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dmajzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dmajz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dmajzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dmajz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dmajzfail');

CREATE TABLE docipodm ( 
      NCISDODAVK Double( 0 ),
      COZNDODAVK Char( 25 ),
      CNAZDODAVK Char( 50 ),
      CZKRZPUDOP Char( 15 ),
      NCISFIRPRP Integer,
      CNAZFIRPRP Char( 50 ),
      NCISOSOPRP Integer,
      CJMEOSOPRP Char( 50 ),
      NCISFIRNAK Integer,
      CNAZFIRNAK Char( 50 ),
      NCISOSONAK Integer,
      CJMEOSONAK Char( 50 ),
      DDATNAK Date,
      CCASNAK Char( 8 ),
      NCISFIRVYK Integer,
      CNAZFIRVYK Char( 50 ),
      NCISOSOVYK Integer,
      CJMEOSOVYK Char( 50 ),
      DDATVYK Date,
      CCASVYK Char( 8 ),
      CTYPDOPPRO Char( 10 ),
      CNAZDOPPRO Char( 50 ),
      CZKNDOPPRO Char( 15 ),
      CPZZDOPPRO Char( 20 ),
      NCISOSODOP Integer,
      CJMEOSODOP Char( 50 ),
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'docipodm',
   'docipodm.adi',
   'DOCIPODM01',
   'NCISDODAVK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'docipodm',
   'docipodm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'docipodm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'docipodmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'docipodm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'docipodmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'docipodm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'docipodmfail');

CREATE TABLE dodlsthd ( 
      CULOHA Char( 1 ),
      CTASK Char( 3 ),
      CSUBTASK Char( 3 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCISLOEL Double( 0 ),
      NCISLOPVP Double( 0 ),
      CVARSYM Char( 15 ),
      COBDOBIDAN Char( 5 ),
      CSTADOKLAD Char( 10 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      NOSVODDAN Double( 2 ),
      NPROCDAN_1 Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAR_1 Double( 2 ),
      NSAZDAR_1 Double( 2 ),
      NZAKLDAZ_1 Double( 2 ),
      NSAZDAZ_1 Double( 2 ),
      NPROCDAN_2 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NZAKLDAR_2 Double( 2 ),
      NSAZDAR_2 Double( 2 ),
      NZAKLDAZ_2 Double( 2 ),
      NSAZDAZ_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENFAKCEL Double( 2 ),
      NCENFAZCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CUCET Char( 25 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 60 ),
      CPRIJEMCE2 Char( 60 ),
      CZKRZPUDOP Char( 15 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOVINFAK Date,
      DDATTISK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELFAK Double( 2 ),
      DPOSLIKFAK Date,
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      NKURZROZDF Double( 2 ),
      DPOSUHRFAK Date,
      NPARZALFAK Double( 2 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      CBANK_UCT Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NCISPENFAK Double( 0 ),
      DDATPENFAK Date,
      NPEN_ODB Double( 2 ),
      NVYPPENODB Double( 2 ),
      NCISUPOMIN Double( 0 ),
      DUPOMINKY Date,
      NCISDOBFAK Double( 0 ),
      LHLASFAK Logical,
      CCISOBJ Char( 30 ),
      CCISLOBINT Char( 30 ),
      NCISFAK_OR Double( 0 ),
      CTYPFAK_OR Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLHOT Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CDENIK Char( 2 ),
      CUCET_UCT Char( 6 ),
      CDENIK_PUC Char( 2 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      CUCET_DAZ Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NFINTYP Short,
      NKLICOBL Short,
      NDOKLAD_DL Double( 0 ),
      NDOKLAD_PV Integer,
      CJMENOVYS Char( 25 ),
      COBDOBIO Char( 5 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      MPOPISFAK Memo,
      LNO_INDPH Logical,
      MDOLFAKCIS Memo,
      LISZAHR Logical,
      NFAKDOLCIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CTYPZAK Char( 2 ),
      CSTRED_ODB Char( 8 ),
      CSTROJ_ODB Char( 8 ),
      NPORCISLIS Double( 0 ),
      NOSCISPRAC Integer,
      CSPZ Char( 15 ),
      VLEKSPZ Char( 15 ),
      CJMENORID Char( 25 ),
      CCISLOOP Char( 15 ),
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      CVYPSAZDAN Char( 8 ),
      CISZAL_FAK Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD1',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD2',
   'UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD3',
   'UPPER(CCISLOBINT) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD4',
   'STRZERO(NCISFIRMY,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD5',
   'UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD6',
   'UPPER(CZKRTYPFAK) +UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFIRMY,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD8',
   'STRZERO(NCISFIRMY) +UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD9',
   'STRZERO(NKASA,3) +DTOS (DVYSTFAK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD10',
   'UPPER(CULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD11',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD12',
   'UPPER(CNAZEV) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlsthd',
   'dodlsthd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodlsthd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dodlsthdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodlsthd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dodlsthdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodlsthd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dodlsthdfail');

CREATE TABLE dodlstit ( 
      CULOHA Char( 1 ),
      NCISFIRMY Integer,
      NCISFIRDOA Integer,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCOUNTDL Integer,
      NCISLOEL Double( 0 ),
      NPOLEL Integer,
      NCISLOPVP Double( 0 ),
      CZKRTYPFAK Char( 5 ),
      NINTCOUNT Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CTYPSKLPOL Char( 2 ),
      CPOLCEN Char( 1 ),
      CNAZZBO Char( 50 ),
      CUCETSKUP Char( 10 ),
      NCENJEDZAK Double( 4 ),
      NCENJEDZAD Double( 4 ),
      NCENZAKCEL Double( 2 ),
      NCENZAKCED Double( 2 ),
      NCENZAHCEL Double( 2 ),
      NJEDDAN Double( 2 ),
      NSAZDAN Double( 2 ),
      NFAKTMNOZ Double( 4 ),
      CZKRATJEDN Char( 3 ),
      NFAKTMNO2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      NKLICDPH Short,
      NPROCDPH Double( 2 ),
      NNAPOCET Short,
      NNULLDPH Short,
      NKODPLNENI Short,
      NTYPPREP Short,
      NVYPSAZDAN Short,
      NRADVYKDPH Short,
      CDOPLNTXT Char( 50 ),
      CCISOBJ Char( 15 ),
      CCISLOBINT Char( 30 ),
      NCISLOOBJP Double( 0 ),
      NCISLPOLOB Integer,
      NMNOZREODB Double( 2 ),
      NCISPENFAK Double( 0 ),
      NCELPENFAK Double( 2 ),
      NCENPENCEL Double( 2 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOSUHRFAK Date,
      NUHRCELFAZ Double( 2 ),
      NPEN_ODB Double( 2 ),
      NCISFAK_OR Double( 0 ),
      CZKRTYP_OR Char( 5 ),
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLMN Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NCENAZAKC Double( 2 ),
      NCELKSLEV Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CUCET Char( 6 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      NDOKLADORG Double( 0 ),
      NUCETSKUP Short,
      NZBOZIKAT Short,
      NPODILPROD Double( 2 ),
      CDENIK Char( 2 ),
      NCISZALFAK Double( 0 ),
      NISPARZAL Short,
      NRECFAZ Double( 0 ),
      NRECPAR Double( 0 ),
      NRECDOL Double( 0 ),
      NRECPEN Double( 0 ),
      NRECVYR Double( 0 ),
      NRECOBJ Double( 0 ),
      NKLICOBL Short,
      NCENASZBO Double( 4 ),
      NMNOZSZBO Double( 2 ),
      NCENACZBO Double( 2 ),
      MPOZZBO Memo,
      NFAKTM_ORG Double( 2 ),
      NORDIT_PVP Integer,
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CSKP Char( 15 ),
      CDANPZBO Char( 15 ),
      NIND_CEO Short,
      LIND_MOD Logical,
      NCISLOKUSU Integer,
      MDOLCIS Memo,
      AULOZENI Memo,
      CTYPSKP Char( 15 ),
      NKOEFMN Double( 2 ),
      NFAKTMNKOE Double( 4 ),
      NCEJPRZBZ Double( 4 ),
      NCEJPRKBZ Double( 4 ),
      NCEJPRKDZ Double( 4 ),
      NCEJPRZDZ Double( 4 ),
      NCECPRZBZ Double( 2 ),
      NCECPRKBZ Double( 2 ),
      NCECPRKDZ Double( 2 ),
      NHMOTNOSTJ Double( 4 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEMJ Double( 4 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      LSLUZBA Logical,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      NCISVYSFAK Double( 0 ),
      DVYKLADKY Date,
      CCASVYKLAD Char( 8 ),
      CFILE_IV Char( 10 ),
      NMNOZ_FAKT Double( 4 ),
      NSTAV_FAKT Short,
      NMNOZ_DLVY Double( 4 ),
      NMNOZ_OBJP Double( 4 ),
      NMNOZ_EXPL Double( 4 ),
      NMNOZ_ZAK Double( 4 ),
      NMNOZZDOK Double( 4 ),
      MAPOLSEST Memo,
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT1',
   'STRZERO(NDOKLAD,10) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT3',
   'UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT4',
   'UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT5',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT6',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISVYSFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT7',
   'STRZERO(NCISLOEL,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT8',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT9',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT10',
   'NSTAV_FAKT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodlstit',
   'dodlstit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodlstit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dodlstitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodlstit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dodlstitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodlstit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dodlstitfail');

CREATE TABLE dodterm ( 
      NORDITEM Integer,
      NCISFIRMY Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CZKRCARKOD Char( 8 ),
      CCARKOD Char( 128 ),
      NUSRIDDBTE Integer,
      LINCENZBOZ Logical,
      CTYPHEXBCD Char( 20 ),
      CSOURCEBCD Char( 20 ),
      CTIMEBCD Char( 20 ),
      NLENBCD Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'dodterm',
   'dodterm.adi',
   'DODTERM01',
   'UPPER(CZKRCARKOD) + UPPER(CCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodterm',
   'dodterm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodterm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dodtermfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodterm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dodtermfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodterm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dodtermfail');

CREATE TABLE dodzboz ( 
      NKLICNAZ Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CKATCZBO Char( 15 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      NCENANZBO Double( 4 ),
      NCENAOZBO Double( 4 ),
      NCENPOL Short,
      DDATPNAK Date,
      NMINOBMNOZ Double( 4 ),
      NMINEXMNOZ Double( 4 ),
      CNAZDOD1 Char( 30 ),
      CNAZDOD2 Char( 30 ),
      NCENNAKZM Double( 4 ),
      CZKRATMENY Char( 3 ),
      NDODLHUTA Integer,
      MPOZDOD Memo,
      LHLAVNIDOD Logical,
      CZKRATJEDN Char( 3 ),
      CZKRCARKOD Char( 15 ),
      CCARKOD Char( 128 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV1',
   'NKLICNAZ',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV2',
   'STRZERO(NCISFIRMY,5) +STRZERO(NKLICNAZ,5) +STRZERO(NCENAOZBO,13)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV3',
   'UPPER(CSKLPOL) +IF (LHLAVNIDOD, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV4',
   'STRZERO(NCISFIRMY,5) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV5',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV6',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CZKRATMENY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV7',
   'LHLAVNIDOD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV8',
   'UPPER(CZKRCARKOD) + UPPER(CCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dodzboz',
   'dodzboz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodzboz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dodzbozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodzboz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dodzbozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dodzboz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dodzbozfail');

CREATE TABLE dokladyhd ( 
      CTASK Char( 3 ),
      CSUBTASK Char( 3 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      CDOKLAD Char( 20 ),
      CVARSYM Char( 15 ),
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZFIR Char( 50 ),
      CNAZ2FIR Char( 25 ),
      NICOFIR Integer,
      CDICFIR Char( 16 ),
      CULICEFIR Char( 25 ),
      CMESTOFIR Char( 18 ),
      CPSCFIR Char( 6 ),
      CZKRSTFIR Char( 3 ),
      NCISFIR2 Integer,
      CNAZFIR2 Char( 50 ),
      CNAZ2FIR2 Char( 25 ),
      CULICEFIR2 Char( 25 ),
      CMESTOFIR2 Char( 25 ),
      CPSCFIR2 Char( 6 ),
      CZKRSTFIR2 Char( 3 ),
      NCISFIR3 Integer,
      CNAZFIR3 Char( 50 ),
      CNAZ2FIR3 Char( 25 ),
      CULICEFIR3 Char( 25 ),
      CMESTOFIR3 Char( 25 ),
      CPSCFIR3 Char( 6 ),
      CZKRSTFIR3 Char( 3 ),
      CPRIJEMCE1 Char( 60 ),
      CPRIJEMCE2 Char( 60 ),
      CZKRZPUDOP Char( 15 ),
      CZKRTYPUHR Char( 5 ),
      DVYSTDOK Date,
      DUZPDOK Date,
      DSPLATDOK Date,
      DDATTISK Date,
      CCISFAK Char( 20 ),
      CCISDL Char( 20 ),
      CCISPVP Char( 20 ),
      CCISZAKAZ Char( 30 ),
      NCISOSOBY Integer,
      NOSCISPRAC Integer,
      NOBSAH Double( 6 ),
      CZKRATJEDS Char( 3 ),
      NHMOTNOST Double( 6 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 6 ),
      CZKRATJEDO Char( 3 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokladyhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dokladyhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokladyhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dokladyhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokladyhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dokladyhdfail');

CREATE TABLE doklisoz ( 
      DENIK Char( 1 ),
      MESIC Char( 2 ),
      DOKLAD Char( 6 ),
      POLOZKA Short,
      UCET Char( 6 ),
      STREDISKO Char( 6 ),
      VYKON Char( 3 ),
      STROJ Char( 6 ),
      POZEMEK Char( 6 ),
      KORESP Char( 8 ),
      SYMBOL Char( 11 ),
      M_KCS Double( 2 ),
      D_KCS Double( 2 ),
      TEXT Char( 18 ),
      BU_ZNAK Char( 4 ),
      DATUM Date,
      DOKLADPK Char( 6 ),
      DAT_POR Date,
      OSOBA Char( 2 ),
      ROK Char( 1 ),
      DEKADA Char( 1 ),
      OPER Char( 1 ),
      OPER1 Char( 1 ),
      OPER2 Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'doklisoz',
   'doklisoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'doklisoz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'doklisozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'doklisoz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'doklisozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'doklisoz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'doklisozfail');

CREATE TABLE dokonc ( 
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      NROK Short,
      NOBDOBI Short,
      CZAOBDOBI Char( 2 ),
      NMNOZODVED Double( 2 ),
      NMNOZODVO Double( 2 ),
      DDATZPRAC Date,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NPLPRMATZ Double( 2 ),
      NPLHODINZ Double( 2 ),
      NPLPRMZDZ Double( 2 ),
      NPLPRKOOZ Double( 2 ),
      NPLREZIEZ Double( 2 ),
      NSKPRMATZ Double( 2 ),
      NSKPRMATZP Double( 2 ),
      NSKHODINZ Double( 2 ),
      NSKHODINVS Double( 2 ),
      NSKPRMZDZ Double( 2 ),
      NSKPRMZUKZ Double( 2 ),
      NSKOSTPRNA Double( 2 ),
      NSKOSTPRMZ Double( 2 ),
      NSKPRKOOZ Double( 2 ),
      NSKPRKOOZ2 Double( 2 ),
      NSKREZIEZ Double( 2 ),
      NODBYTREZ Double( 2 ),
      NODBYTREPR Double( 3 ),
      NVYROBREZ Double( 2 ),
      NVYROBREPR Double( 3 ),
      NZASOBREZ Double( 2 ),
      NZASOBREPR Double( 3 ),
      NSPRAVREZ Double( 2 ),
      NSPRAVREPR Double( 3 ),
      NCENZAKCEL Double( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CVYRPOL Char( 15 ),
      NCISFIRMY Integer,
      NSKPRMATZH Double( 2 ),
      NZMENASNV Double( 2 ),
      NKURZSTRED Double( 8 ),
      NMATZM_U Double( 2 ),
      NMATCZK_U Double( 2 ),
      NMZDY_U Double( 2 ),
      NKOOP1_U Double( 2 ),
      NKOOP2_U Double( 2 ),
      NVYRREZ_U Double( 2 ),
      NZASREZ_U Double( 2 ),
      NODBREZ_U Double( 2 ),
      NSPRREZ_U Double( 2 ),
      NNABEHNV Double( 2 ),
      NOSTPRMZ_U Double( 2 ),
      NP_ODBREZ Double( 2 ),
      NU_ODBREZ Double( 2 ),
      NP_ZASREZ Double( 2 ),
      NU_ZASREZ Double( 2 ),
      NP_SPRREZ Double( 2 ),
      NU_SPRREZ Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'dokonc',
   'dokonc.adi',
   'DOKONC1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dokonc',
   'dokonc.adi',
   'DOKONC2',
   'UPPER(CCISZAKAZ) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZAOBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokonc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dokoncfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokonc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dokoncfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokonc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dokoncfail');

CREATE TABLE dokument ( 
      NCISDOKUM Double( 0 ),
      COZNDOKUM Char( 10 ),
      NIDDOKUM Double( 0 ),
      CIDDOKUM Char( 16 ),
      NORDITEM Integer,
      CZKRDOKUM Char( 10 ),
      CNAZDOKUM Char( 50 ),
      CSOUBOR Char( 50 ),
      MADRESAR Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dokument',
   'dokument.adi',
   'DOKUMEN01',
   'NCISDOKUM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dokument',
   'dokument.adi',
   'DOKUMEN02',
   'NIDDOKUM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dokument',
   'dokument.adi',
   'DOKUMEN03',
   'UPPER(CIDDOKUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dokument',
   'dokument.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokument', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dokumentfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokument', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dokumentfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dokument', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dokumentfail');

CREATE TABLE dph09 ( 
      LSETS__DPH Logical,
      NODDIL_DPH Short,
      CODDIL_DPH Char( 42 ),
      NRADEK_DPH Short,
      CRADEK_DPH Char( 42 ),
      NNAPOCET Short,
      CUCETU_DPH Char( 6 ),
      CZUSTUCT Char( 1 ),
      NDAT_OD Integer,
      NRADEK_VAZ Short,
      CRADEK_SAY Char( 22 ),
      CMASKA_DPH Char( 3 ),
      FAKPRIHD Char( 10 ),
      FAKPRIHDTU Char( 10 ),
      FAKVYSIT Char( 10 ),
      FAKVYSHDTU Char( 10 ),
      POKLADHD Char( 10 ),
      POKLADHDTU Char( 10 ),
      UCETDOHD Char( 10 ),
      UCETDOHDTU Char( 10 ),
      POKLIT Char( 10 ),
      POKLHDTU Char( 10 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph09', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dph09fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph09', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dph09fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph09', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dph09fail');

CREATE TABLE dph_2001 ( 
      CULOHA Char( 1 ),
      COBDOBIDAN Char( 5 ),
      NOBDOBI Short,
      CFINURAD Char( 25 ),
      CDIC Char( 16 ),
      CRP Char( 1 ),
      COP Char( 1 ),
      CDP Char( 1 ),
      DDATMDUVOD Date,
      NM Short,
      NQ Short,
      NROK Short,
      CPRAOSNAZ Char( 37 ),
      CPRAOSDOP Char( 26 ),
      CPRAOSDO_3 Char( 12 ),
      CFYZOSPRIJ Char( 21 ),
      CFYZOSJMEN Char( 12 ),
      CTITUL Char( 4 ),
      CADRESA Char( 40 ),
      CCINNOST1 Char( 40 ),
      CCINNOST2 Char( 40 ),
      CEA Char( 1 ),
      CEN Char( 1 ),
      CNE Char( 1 ),
      NR201Z Double( 0 ),
      NR201D Double( 0 ),
      NR202Z Double( 0 ),
      NR202D Double( 0 ),
      NR203Z Double( 0 ),
      NR203D Double( 0 ),
      NR204D Double( 0 ),
      NR210D Double( 0 ),
      NR301D Double( 0 ),
      NR302Z Double( 0 ),
      NR302D Double( 0 ),
      NR303Z Double( 0 ),
      NR303D Double( 0 ),
      NR304Z Double( 0 ),
      NR304D Double( 0 ),
      NR305Z Double( 0 ),
      NR305D Double( 0 ),
      NR310D Double( 0 ),
      NR321D Double( 0 ),
      NR322Z Double( 0 ),
      NR322D Double( 0 ),
      NR323Z Double( 0 ),
      NR323D Double( 0 ),
      NR324Z Double( 0 ),
      NR324D Double( 0 ),
      NR325Z Double( 0 ),
      NR325D Double( 0 ),
      NR331D Double( 0 ),
      NR332Z Double( 0 ),
      NR332D Double( 0 ),
      NR333Z Double( 0 ),
      NR333D Double( 0 ),
      NR334Z Double( 0 ),
      NR334D Double( 0 ),
      NR335Z Double( 0 ),
      NR335D Double( 0 ),
      NR340D Double( 0 ),
      NR360K Double( 4 ),
      NR360D Double( 0 ),
      NR400Z Double( 0 ),
      NR410Z Double( 0 ),
      NR411Z Double( 0 ),
      NR420Z Double( 0 ),
      NR430Z Double( 0 ),
      NR444Z Double( 0 ),
      NR444DV Double( 0 ),
      NR445Z Double( 0 ),
      NR445DV Double( 0 ),
      NR450Z Double( 0 ),
      NR450D Double( 0 ),
      NR451Z Double( 0 ),
      NR451DV Double( 0 ),
      NR534Z Double( 0 ),
      NR534DV Double( 0 ),
      NR535Z Double( 0 ),
      NR535DV Double( 0 ),
      NR651D Double( 0 ),
      NR652DV Double( 0 ),
      NR753DV Double( 0 ),
      NR754D Double( 0 ),
      NR780DV Double( 0 ),
      CODPOSPRIJ Char( 25 ),
      CODPOSJMEN Char( 14 ),
      CODPOSPOST Char( 65 ),
      DSESDNE Date,
      CDIGITPODP Char( 25 ),
      CSESJMENO Char( 25 ),
      CSESTELEF Char( 15 ),
      NPRIPLNENI Double( 0 ),
      NUSKPLNENI Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2001',
   'dph_2001.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2001',
   'dph_2001.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2001',
   'dph_2001.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2001', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dph_2001fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2001', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dph_2001fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2001', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dph_2001fail');

CREATE TABLE dph_2004 ( 
      CULOHA Char( 1 ),
      COBDOBIDAN Char( 5 ),
      NOBDOBI Short,
      CFINURAD Char( 25 ),
      CDIC Char( 16 ),
      CRP Char( 1 ),
      COP Char( 1 ),
      CDP Char( 1 ),
      DDATMDUVOD Date,
      NM Short,
      NQ Short,
      NROK Short,
      CPD Char( 1 ),
      CIO Char( 1 ),
      CND Char( 1 ),
      CDZ Char( 1 ),
      CDICDZ Char( 16 ),
      CPRAOSNAZ Char( 37 ),
      CPRAOSDOP Char( 26 ),
      CPRAOSDO_3 Char( 12 ),
      CFYZOSPRIJ Char( 21 ),
      CFYZOSJMEN Char( 12 ),
      CTITUL Char( 4 ),
      CADRESA Char( 40 ),
      CSIDLO Char( 20 ),
      CPSC Char( 5 ),
      CTELEFON Char( 17 ),
      CULICE Char( 25 ),
      CFAX Char( 17 ),
      COKRES Char( 10 ),
      CKRAJ Char( 30 ),
      CZKRATSTAT Char( 3 ),
      CSTAT Char( 30 ),
      CCINNOST1 Char( 40 ),
      CCINNOST2 Char( 40 ),
      CEA Char( 1 ),
      CEN Char( 1 ),
      CNE Char( 1 ),
      NR210Z Double( 0 ),
      NR210D Double( 0 ),
      NR215Z Double( 0 ),
      NR215D Double( 0 ),
      NR220Z Double( 0 ),
      NR220D Double( 0 ),
      NR225Z Double( 0 ),
      NR225D Double( 0 ),
      NR230Z Double( 0 ),
      NR230D Double( 0 ),
      NR235Z Double( 0 ),
      NR235D Double( 0 ),
      NR240Z Double( 0 ),
      NR240D Double( 0 ),
      NR245Z Double( 0 ),
      NR245D Double( 0 ),
      NR250Z Double( 0 ),
      NR250D Double( 0 ),
      NR255Z Double( 0 ),
      NR255D Double( 0 ),
      NR260Z Double( 0 ),
      NR260D Double( 0 ),
      NR265Z Double( 0 ),
      NR265D Double( 0 ),
      NR270Z Double( 0 ),
      NR270D Double( 0 ),
      NR275Z Double( 0 ),
      NR275D Double( 0 ),
      NR310Z Double( 0 ),
      NR310D Double( 0 ),
      NR310R Double( 0 ),
      NR315Z Double( 0 ),
      NR315D Double( 0 ),
      NR315R Double( 0 ),
      NR320Z Double( 0 ),
      NR320D Double( 0 ),
      NR320R Double( 0 ),
      NR325Z Double( 0 ),
      NR325D Double( 0 ),
      NR325R Double( 0 ),
      NR330Z Double( 0 ),
      NR330D Double( 0 ),
      NR330R Double( 0 ),
      NR335Z Double( 0 ),
      NR335D Double( 0 ),
      NR335R Double( 0 ),
      NR340Z Double( 0 ),
      NR340D Double( 0 ),
      NR340R Double( 0 ),
      NR345Z Double( 0 ),
      NR345D Double( 0 ),
      NR345R Double( 0 ),
      NR350Z Double( 0 ),
      NR350D Double( 0 ),
      NR350R Double( 0 ),
      NR355Z Double( 0 ),
      NR355D Double( 0 ),
      NR355R Double( 0 ),
      NR360Z Double( 0 ),
      NR360D Double( 0 ),
      NR360R Double( 0 ),
      NR365Z Double( 0 ),
      NR365D Double( 0 ),
      NR365R Double( 0 ),
      NR370D Double( 0 ),
      NR370R Double( 0 ),
      NR380R Double( 0 ),
      NR390D Double( 0 ),
      NR410P Double( 0 ),
      NR420P Double( 0 ),
      NR425P Double( 0 ),
      NR430P Double( 0 ),
      NR440P Double( 0 ),
      NR510P Double( 0 ),
      NR520P Double( 0 ),
      NR530P Double( 0 ),
      NR540P Double( 0 ),
      NR550K Double( 0 ),
      NR550O Double( 0 ),
      NR560K Double( 0 ),
      NR560O Double( 0 ),
      NR570O Double( 0 ),
      NR580O Double( 0 ),
      NR600D Double( 0 ),
      NR710D Double( 0 ),
      NR730D Double( 0 ),
      NR750O Double( 0 ),
      NR753D Double( 0 ),
      NR754O Double( 0 ),
      NR780D Double( 0 ),
      NR810H Double( 0 ),
      NR815H Double( 0 ),
      CODPOSPRIJ Char( 25 ),
      CODPOSJMEN Char( 14 ),
      CODPOSPOST Char( 65 ),
      DSESDNE Date,
      CDIGITPODP Char( 25 ),
      CSESJMENO Char( 25 ),
      CSESTELEF Char( 20 ),
      NPRIPLNENI Double( 0 ),
      NUSKPLNENI Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2004',
   'dph_2004.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2004',
   'dph_2004.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2004',
   'dph_2004.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2004', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dph_2004fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2004', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dph_2004fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2004', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dph_2004fail');

CREATE TABLE dph_2009 ( 
      CULOHA Char( 1 ),
      COBDOBIDAN Char( 5 ),
      NOBDOBI Short,
      CFINURAD Char( 25 ),
      CDIC Char( 16 ),
      CRC Char( 16 ),
      CRP Char( 1 ),
      COP Char( 1 ),
      CDP Char( 1 ),
      DDATMDUVOD Date,
      NM Short,
      NQ Short,
      NROK Short,
      NMOD Short,
      NMDO Short,
      CPD Char( 1 ),
      CIO Char( 1 ),
      CSK Char( 1 ),
      CND Char( 1 ),
      CNU Char( 1 ),
      CZO Char( 1 ),
      CPRAOSNAZ Char( 37 ),
      CPRAOSDOP Char( 26 ),
      CPRAOSDO_3 Char( 12 ),
      CFYZOSPRIJ Char( 21 ),
      CFYZOSJMEN Char( 12 ),
      CTITUL Char( 4 ),
      CSIDLO Char( 20 ),
      CPSC Char( 5 ),
      CTELEFON Char( 17 ),
      CULICE Char( 25 ),
      CCP Char( 10 ),
      CMAIL Char( 40 ),
      CSTAT Char( 16 ),
      CCINNOST1 Char( 40 ),
      CODPOSPRIJ Char( 25 ),
      CODPOSJMEN Char( 14 ),
      CODPOSPOST Char( 65 ),
      DSESDNE Date,
      CSESJMENO Char( 25 ),
      CSESTELEF Char( 15 ),
      NPRIPLNENI Double( 0 ),
      NUSKPLNENI Double( 0 ),
      NR001Z Double( 0 ),
      NR001D Double( 0 ),
      NR002Z Double( 0 ),
      NR002D Double( 0 ),
      NR003Z Double( 0 ),
      NR003D Double( 0 ),
      NR004Z Double( 0 ),
      NR004D Double( 0 ),
      NR005Z Double( 0 ),
      NR005D Double( 0 ),
      NR006Z Double( 0 ),
      NR006D Double( 0 ),
      NR007Z Double( 0 ),
      NR007D Double( 0 ),
      NR008Z Double( 0 ),
      NR008D Double( 0 ),
      NR009Z Double( 0 ),
      NR009D Double( 0 ),
      NR010Z Double( 0 ),
      NR010D Double( 0 ),
      NR011Z Double( 0 ),
      NR011D Double( 0 ),
      NR012Z Double( 0 ),
      NR012D Double( 0 ),
      NR020P Double( 0 ),
      NR021P Double( 0 ),
      NR022P Double( 0 ),
      NR023P Double( 0 ),
      NR024P Double( 0 ),
      NR025P Double( 0 ),
      NR030P Double( 0 ),
      NR030D Double( 0 ),
      NR040Z Double( 0 ),
      NR040D Double( 0 ),
      NR040R Double( 0 ),
      NR041Z Double( 0 ),
      NR041D Double( 0 ),
      NR041R Double( 0 ),
      NR042Z Double( 0 ),
      NR042D Double( 0 ),
      NR042R Double( 0 ),
      NR043Z Double( 0 ),
      NR043D Double( 0 ),
      NR043R Double( 0 ),
      NR044Z Double( 0 ),
      NR044D Double( 0 ),
      NR044R Double( 0 ),
      NR045Z Double( 0 ),
      NR045D Double( 0 ),
      NR045R Double( 0 ),
      NR046D Double( 0 ),
      NR046R Double( 0 ),
      NR047D Double( 0 ),
      NR047R Double( 0 ),
      NR048Z Double( 0 ),
      NR048D Double( 0 ),
      NR048R Double( 0 ),
      NR050P Double( 0 ),
      NR051S Double( 0 ),
      NR051B Double( 0 ),
      NR052K Double( 2 ),
      NR052O Double( 0 ),
      NR053K Double( 2 ),
      NR053O Double( 0 ),
      NR060O Double( 0 ),
      NR061O Double( 0 ),
      NR062D Double( 0 ),
      NR063D Double( 0 ),
      NR064O Double( 0 ),
      NR065D Double( 0 ),
      NR066O Double( 0 ),
      NR067D Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2009',
   'dph_2009.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2009',
   'dph_2009.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dph_2009',
   'dph_2009.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2009', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dph_2009fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2009', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dph_2009fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dph_2009', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dph_2009fail');

CREATE TABLE dphdata ( 
      CULOHA Char( 1 ),
      COBDOBIDAN Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CFINURAD Char( 25 ),
      CDIC Char( 16 ),
      NM Short,
      NQ Short,
      CFYZOSJMEN Char( 15 ),
      CFYZOSPRIJ Char( 25 ),
      CPRAOSNAZ Char( 25 ),
      CPRAOSDOP Char( 15 ),
      CADRESA Char( 66 ),
      CODPOSJMEN Char( 14 ),
      CODPOSPRIJ Char( 25 ),
      CODPOSPOST Char( 65 ),
      DSESDNE Date,
      NRAD01 Short,
      NRAD02 Double( 0 ),
      NRAD11 Double( 0 ),
      NRAD12 Double( 0 ),
      NRAD13 Double( 0 ),
      NRAD14 Double( 0 ),
      NRAD15 Double( 0 ),
      NRAD16 Double( 0 ),
      NRAD17 Double( 0 ),
      NRAD18 Double( 0 ),
      NRAD19 Double( 0 ),
      NRAD20 Double( 0 ),
      NRAD31 Double( 0 ),
      NRAD32 Double( 0 ),
      NRAD32A Double( 0 ),
      NRAD33 Double( 0 ),
      NRAD34 Double( 0 ),
      NRAD35 Double( 0 ),
      NRAD35A Double( 0 ),
      NRAD36 Double( 0 ),
      NRAD36A Double( 0 ),
      NRAD37 Double( 0 ),
      NRAD37A Double( 0 ),
      NRAD38 Double( 0 ),
      NRAD38A Double( 0 ),
      NRAD41 Double( 0 ),
      NRAD42 Double( 0 ),
      NRAD51 Double( 0 ),
      NRAD52 Double( 0 ),
      NRAD53 Double( 0 ),
      NRAD54 Double( 0 ),
      CSESJMENO Char( 25 ),
      CSESTELEF Char( 15 ),
      NPRIPLNENI Double( 0 ),
      NUSKPLNENI Double( 0 ),
      NRAD02S Double( 2 ),
      NRAD11S Double( 2 ),
      NRAD12S Double( 2 ),
      NRAD13S Double( 2 ),
      NRAD14S Double( 2 ),
      NRAD15S Double( 2 ),
      NRAD16S Double( 2 ),
      NRAD17S Double( 2 ),
      NRAD18S Double( 2 ),
      NRAD19S Double( 2 ),
      NRAD20S Double( 2 ),
      NRAD31S Double( 2 ),
      NRAD32S Double( 2 ),
      NRAD32SA Double( 2 ),
      NRAD33S Double( 2 ),
      NRAD34S Double( 2 ),
      NRAD35S Double( 2 ),
      NRAD35SA Double( 2 ),
      NRAD36S Double( 2 ),
      NRAD36SA Double( 2 ),
      NRAD37S Double( 2 ),
      NRAD37SA Double( 2 ),
      NRAD38S Double( 2 ),
      NRAD38SA Double( 2 ),
      NRAD41S Double( 2 ),
      NRAD42S Double( 2 ),
      NRAD51S Double( 2 ),
      NRAD52S Double( 2 ),
      NRAD53S Double( 2 ),
      NRAD54S Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dphdata',
   'dphdata.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dphdata',
   'dphdata.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dphdata',
   'dphdata.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dphdata', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dphdatafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dphdata', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dphdatafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dphdata', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dphdatafail');

CREATE TABLE druhymzd ( 
      NDRUHMZDY Short,
      CNAZEVDMZ Char( 30 ),
      CNAZEV2DMZ Char( 30 ),
      CZKRATDMZ Char( 8 ),
      CTYPDMZ Char( 4 ),
      LUCTUJ Logical,
      LVYPOCHM Logical,
      LHODZDNU Logical,
      NTYPDOVOL Short,
      NAUTVYPHM Short,
      NNULVYPHM Short,
      NSAZBAVYHM Short,
      NTYPVYPHM Short,
      NNAPOCHM Short,
      NNAPOCPRHM Short,
      NNAPOCHVPR Short,
      NRIDZNAK_1 Short,
      NRIDZNAK_2 Short,
      CRZN1_VYHM Char( 21 ),
      CRZN2_VYHM Char( 21 ),
      CRZN3_VYHM Char( 21 ),
      CRZN4_VYHM Char( 21 ),
      NKOE1_VYHM Double( 2 ),
      NKOE2_VYHM Double( 2 ),
      NKOE3_VYHM Double( 2 ),
      NKOE4_VYHM Double( 2 ),
      NKOEFPREHM Double( 2 ),
      NDRUHMZPRE Short,
      NTYPVYPPRE Short,
      NKODZAOKR Short,
      CZKRTRVPLA Char( 5 ),
      NNAPOCETCM Short,
      NTYPDANE Short,
      LSOCPOJIS Logical,
      LZDRPOJIS Logical,
      LHRUBAMZDA Logical,
      LDANZAKLAD Logical,
      LZAKSRAZKY Logical,
      LVYPOCCM Logical,
      LODBORY Logical,
      LVYLOUDOBA Logical,
      LVYLODOBOD Logical,
      LNAPEVIDLI Logical,
      RZ_DNY Short,
      RZ_HOD Short,
      RZ_KCS Short,
      DNY Char( 30 ),
      HODINY Char( 30 ),
      HRUBA_MZDA Char( 30 ),
      P_KCSNEMOC Short,
      P_KCSPRACP Short,
      P_KCSPOHSL Short,
      P_KCSHOPRP Short,
      P_KCSPRESC Short,
      P_HODPRPRA Short,
      P_DNYODPDN Short,
      LNAPPRCELO Logical,
      NALGCELODM Short,
      NPOCMESPR Short,
      CPOLVYPLPA Char( 4 ),
      LPLANDLESK Logical,
      LDMZDONOR Logical,
      LNMDLEHD Logical,
      CDRMZDISO Char( 2 ),
      LVYROBKS Logical,
      LHOTOVKS Logical,
      LHOTOVKC Logical,
      LHOTOVNH Logical,
      LNESUMHMSE Logical,
      MZAUCTDMZD Memo,
      MPOPISDMZD Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'druhymzd',
   'druhymzd.adi',
   'DRMZDY1',
   'NDRUHMZDY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'druhymzd',
   'druhymzd.adi',
   'DRMZDY2',
   'UPPER(CNAZEVDMZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'druhymzd',
   'druhymzd.adi',
   'DRMZDY3',
   'NTYPDOVOL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'druhymzd',
   'druhymzd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'druhymzd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'druhymzdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'druhymzd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'druhymzdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'druhymzd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'druhymzdfail');

CREATE TABLE dspohyby ( 
      NOSCISPRAC Integer,
      CKMENSTRPR Char( 8 ),
      CIDOSKARTY Char( 25 ),
      CRODCISPRA Char( 13 ),
      DDATUM Date,
      COBDOBI Char( 5 ),
      NOBDOBI Short,
      NROK Short,
      NMESIC Short,
      NDEN Short,
      CZKRDNE Char( 2 ),
      DDATUMPL Date,
      CKODPRER Char( 3 ),
      NKODPRER Short,
      CKODPRERE Char( 3 ),
      NKODPRERE Short,
      CCASBEG Char( 5 ),
      NCASBEG Double( 2 ),
      CCASEND Char( 5 ),
      NCASEND Double( 2 ),
      CCASCEL Char( 5 ),
      NCASCEL Double( 2 ),
      NCASBEGPD Double( 2 ),
      NCASENDPD Double( 2 ),
      NCASENDSM Double( 2 ),
      NCASCELPD Double( 2 ),
      NCASCELCPD Double( 2 ),
      NCASPRESTA Double( 2 ),
      NCASPRESCA Double( 2 ),
      NCASNOCPRI Double( 2 ),
      NROZDCASDE Double( 2 ),
      CADRTERM Char( 10 ),
      CADRTERME Char( 10 ),
      CSNTERM Char( 10 ),
      CSNTERME Char( 10 ),
      LISMANUAL Logical,
      LISAUTEND Logical,
      NGENREC Short,
      NNAPPRER Short,
      NSAYSCR Short,
      NSAYCRD Short,
      NPRITPRAC Short,
      NCASTMP Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +UPPER(CKODPRER)       +STRZERO(NCASBEG,5,2) +STRZERO(NCASEND,5,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +UPPER(CKODPRERE)      +STRZERO(NCASEND,5,2) +STRZERO(NCASBEG,5,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY03',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUM)     +UPPER(CCASEND)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY04',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUMPL)   +UPPER(CCASEND)        +UPPER(CKODPRER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY05',
   'STRZERO(NROK,4)       +STRZERO(NMESIC,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY06',
   'UPPER(CIDOSKARTY)     +UPPER(CKODPRER)   +STRZERO(NCASEND,5,2)  +STRZERO(NROK,4)    +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY07',
   'UPPER(CIDOSKARTY)     +UPPER(CKODPRERE)  +STRZERO(NCASBEG,5,2)  +STRZERO(NROK,4)    +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY08',
   'UPPER(CIDOSKARTY)     +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +STRZERO(NCASTMP,5,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NSAYSCR,2) +STRZERO(NDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY10',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +STRZERO(NSAYCRD,2)    +UPPER(CKODPRER)      +STRZERO(NCASBEG,5,2) +STRZERO(NCASEND,5,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY11',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUM)     +UPPER(CKODPRER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY12',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUM)     +STRZERO(NPRITPRAC,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY13',
   'STRZERO(NOSCISPRAC,5) +UPPER(CKODPRER)   +DTOS (DDATUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'dspohyby',
   'dspohyby.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'dspohyby', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'dspohybyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dspohyby', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'dspohybyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'dspohyby', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'dspohybyfail');

CREATE TABLE duchody ( 
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CRODCISPRA Char( 13 ),
      CPRACOVNIK Char( 50 ),
      NPORDUCHOD Short,
      NTYPDUCHOD Short,
      CNAZDUCHOD Char( 25 ),
      CPOPISDUCH Char( 40 ),
      DPRIZNDUOD Date,
      DPRIZNDUDO Date,
      DNARDUCHOD Date,
      DNARDUCHDO Date,
      NHODNDUCHO Double( 2 ),
      LAKTIV Logical,
      NCISFIRMY Integer,
      CNAZEV Char( 25 ),
      CULICE Char( 25 ),
      CSIDLO Char( 20 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'duchody',
   'duchody.adi',
   'DUCHD_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'duchody',
   'duchody.adi',
   'DUCHD_02',
   'UPPER(CRODCISPRA) +IF (LAKTIV, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'duchody',
   'duchody.adi',
   'DUCHO_03',
   'UPPER(CRODCISPRA) +STRZERO(NTYPDUCHOD,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'duchody',
   'duchody.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'duchody', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'duchodyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'duchody', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'duchodyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'duchody', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'duchodyfail');

CREATE TABLE elnardim ( 
      NINVCISDIM Integer,
      CVYROBCE Char( 30 ),
      NROKVYR Short,
      CKATEGPOUZ Char( 15 ),
      CTYPOZNAC Char( 20 ),
      CIDCISLO Char( 8 ),
      NNAPETI Double( 2 ),
      NPROUD Double( 2 ),
      NPRIKON Double( 2 ),
      CTRIDAOCHR Char( 10 ),
      DDATPOSKON Date,
      DDATDALKON Date,
      CCELKHODNO Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'elnardim',
   'elnardim.adi',
   'DIM1',
   'NINVCISDIM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'elnardim',
   'elnardim.adi',
   'DIM2',
   'UPPER(CVYROBCE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'elnardim',
   'elnardim.adi',
   'DIM3',
   'UPPER(CIDCISLO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'elnardim',
   'elnardim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'elnardim', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'elnardimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'elnardim', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'elnardimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'elnardim', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'elnardimfail');

CREATE TABLE errkar ( 
      DDATKONTR Date,
      DAUTKONDEN Date,
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NMNPOCKAR Double( 2 ),
      NMNPRIJEM Double( 2 ),
      NMNVYDEJ Double( 2 ),
      NMNKONCMP Double( 2 ),
      NMNKONKAR Double( 2 ),
      NMNROZDIL Double( 2 ),
      NKSPOCKAR Double( 0 ),
      NKSPRIJEM Double( 0 ),
      NKSVYDEJ Double( 0 ),
      NKSKONCMP Double( 0 ),
      NKSKONKAR Double( 0 ),
      NKSROZDIL Double( 0 ),
      NCEPOCKAR Double( 2 ),
      NCEPRIJEM Double( 2 ),
      NCEVYDEJ Double( 2 ),
      NCEKONCMP Double( 2 ),
      NCEKONKAR Double( 2 ),
      NCEROZDIL Double( 2 ),
      NKDPOCKAR Double( 0 ),
      NKDPRIJEM Double( 0 ),
      NKDVYDEJ Double( 0 ),
      NKDKONCMP Double( 0 ),
      NKDKONKAR Double( 0 ),
      NKDROZDIL Double( 0 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'errkar',
   'errkar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkar', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'errkarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkar', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'errkarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkar', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'errkarfail');

CREATE TABLE errkarob ( 
      DDATKONTR Date,
      DAUTKONDEN Date,
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NMNOZPOC Double( 2 ),
      NMNOZPOCN Double( 2 ),
      NMNOZPOCR Double( 2 ),
      NKUSYPOC Double( 0 ),
      NKUSYPOCN Double( 0 ),
      NKUSYPOCR Double( 0 ),
      NCENAPOC Double( 2 ),
      NCENAPOCN Double( 2 ),
      NCENAPOCR Double( 2 ),
      NKDPOC Double( 0 ),
      NKDPOCN Double( 0 ),
      NKDPOCR Double( 0 ),
      NMNOZKON Double( 2 ),
      NMNOZKONN Double( 2 ),
      NMNOZKONR Double( 2 ),
      NKUSYKON Double( 0 ),
      NKUSYKONN Double( 0 ),
      NKUSYKONR Double( 0 ),
      NCENAKON Double( 2 ),
      NCENAKONN Double( 2 ),
      NCENAKONR Double( 2 ),
      NKDKON Double( 0 ),
      NKDKONN Double( 0 ),
      NKDKONR Double( 0 ),
      NMNOZPRIJ Double( 2 ),
      NMNOZPRIJN Double( 2 ),
      NMNOZPRIJR Double( 2 ),
      NKUSYPRIJ Double( 0 ),
      NKUSYPRIJN Double( 0 ),
      NKUSYPRIJR Double( 0 ),
      NCENAPRIJ Double( 2 ),
      NCENAPRIJN Double( 2 ),
      NCENAPRIJR Double( 2 ),
      NKDPRIJ Double( 0 ),
      NKDPRIJN Double( 0 ),
      NKDPRIJR Double( 0 ),
      NMNOZVYDEJ Double( 2 ),
      NMNOZVYDEN Double( 2 ),
      NMNOZVYDER Double( 2 ),
      NKUSYVYDEJ Double( 0 ),
      NKUSYVYDEN Double( 0 ),
      NKUSYVYDER Double( 0 ),
      NCENAVYDEJ Double( 2 ),
      NCENAVYDEN Double( 2 ),
      NCENAVYDER Double( 2 ),
      NKDVYDEJ Double( 0 ),
      NKDVYDEN Double( 0 ),
      NKDVYDER Double( 0 ),
      NPRUMCENA Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'errkarob',
   'errkarob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkarob', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'errkarobfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkarob', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'errkarobfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkarob', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'errkarobfail');

CREATE TABLE errkumul ( 
      DDATKONTR Date,
      DAUTKONDEN Date,
      COBDPOH Char( 5 ),
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NPORADI Short,
      NMNOZPOC Double( 2 ),
      NMNOZPOCN Double( 2 ),
      NMNOZPOCR Double( 2 ),
      NCENAPOC Double( 2 ),
      NCENAPOCN Double( 2 ),
      NCENAPOCR Double( 2 ),
      NMNOZKON Double( 2 ),
      NMNOZKONN Double( 2 ),
      NMNOZKONR Double( 2 ),
      NCENAKON Double( 2 ),
      NCENAKONN Double( 2 ),
      NCENAKONR Double( 2 ),
      NMNOZPRIJ Double( 2 ),
      NMNOZPRIJN Double( 2 ),
      NMNOZPRIJR Double( 2 ),
      NCENAPRIJ Double( 2 ),
      NCENAPRIJN Double( 2 ),
      NCENAPRIJR Double( 2 ),
      NMNOZVYDEJ Double( 2 ),
      NMNOZVYDEN Double( 2 ),
      NMNOZVYDER Double( 2 ),
      NCENAVYDEJ Double( 2 ),
      NCENAVYDEN Double( 2 ),
      NCENAVYDER Double( 2 ),
      CDATPOSAKT Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'errkumul',
   'errkumul.adi',
   'ERRKUM1',
   'DTOS (DDATKONTR) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'errkumul',
   'errkumul.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkumul', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'errkumulfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkumul', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'errkumulfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errkumul', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'errkumulfail');

CREATE TABLE errmnoz ( 
      DDATKONTR Date,
      DAUTKONDEN Date,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NMNOZR_O Double( 4 ),
      NMNOZR_N Double( 4 ),
      NMNOZK_O Double( 4 ),
      NMNOZK_N Double( 4 ),
      NMNOZO_O Double( 4 ),
      NMNOZO_N Double( 4 ),
      NMNOZD_O Double( 4 ),
      NMNOZD_N Double( 4 ),
      NMNOZV_O Double( 4 ),
      NMNOZV_N Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'errmnoz',
   'errmnoz.adi',
   'ERRMNOZ1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'errmnoz',
   'errmnoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'errmnoz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'errmnozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errmnoz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'errmnozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errmnoz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'errmnozfail');

CREATE TABLE errstav ( 
      DDATKONTR Date,
      DAUTKONDEN Date,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NMNROZDIL Double( 4 ),
      NCEROZDIL Double( 4 ),
      NMNPOCCMP Double( 4 ),
      NMNPRCMP Double( 4 ),
      NMNVYCMP Double( 4 ),
      NMNKONCMP Double( 4 ),
      NCEPOCCMP Double( 4 ),
      NCEPRCMP Double( 4 ),
      NCEVYCMP Double( 4 ),
      NCEKONCMP Double( 4 ),
      NMNPOCCEN Double( 4 ),
      NMNKONCEN Double( 4 ),
      NCEPOCCEN Double( 4 ),
      NCEKONCEN Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'errstav',
   'errstav.adi',
   'ERRSTAV1',
   'DTOS (DDATKONTR) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'errstav',
   'errstav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'errstav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'errstavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errstav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'errstavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errstav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'errstavfail');

CREATE TABLE errzmobd ( 
      DDATKONTR Date,
      DAUTKONDEN Date,
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NDRPOHYB Integer,
      NKARTA Short,
      NTYPPOHYB Short,
      CNAZPOL2 Char( 8 ),
      NKUSYZV Double( 0 ),
      NMNOZSZV Double( 2 ),
      NKD Double( 0 ),
      NCENACZV Double( 2 ),
      NCENAPCEZV Double( 2 ),
      NCENAMCEZV Double( 2 ),
      NKUSYZVOR Double( 0 ),
      NMNOZSZVOR Double( 2 ),
      NKDOR Double( 0 ),
      NCENACZVOR Double( 2 ),
      NCENAPCEOR Double( 2 ),
      NCENAMCEOR Double( 2 ),
      NKUSYN Double( 0 ),
      NMNOZSN Double( 2 ),
      NKDN Double( 0 ),
      NCENACN Double( 2 ),
      NCENAPCEN Double( 2 ),
      NCENAMCEN Double( 2 ),
      NKUSYORN Double( 0 ),
      NMNOZSORN Double( 2 ),
      NKDORN Double( 0 ),
      NCENACORN Double( 2 ),
      NCENPCEORN Double( 2 ),
      NCENMCEORN Double( 2 ),
      NKUSYR Double( 0 ),
      NMNOZSR Double( 2 ),
      NKDR Double( 0 ),
      NCENACR Double( 2 ),
      NCENAPCER Double( 2 ),
      NCENAMCER Double( 2 ),
      NKUSYORR Double( 0 ),
      NMNOZSORR Double( 2 ),
      NKDORR Double( 0 ),
      NCENACORR Double( 2 ),
      NCENPCEORR Double( 2 ),
      NCENMCEORR Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'errzmobd',
   'errzmobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'errzmobd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'errzmobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errzmobd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'errzmobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'errzmobd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'errzmobdfail');

CREATE TABLE evlidp04 ( 
      CRODCISPRA Char( 13 ),
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      NDOKLAD Double( 0 ),
      NPOREVIDLI Short,
      CPRACOVNIK Char( 50 ),
      NROK Short,
      CROK Char( 4 ),
      CTYPELDP Char( 2 ),
      DOPRELDP Date,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      CTITULPRAC Char( 15 ),
      CJMENOROD Char( 25 ),
      CULICE Char( 50 ),
      CMISTO Char( 50 ),
      CCISPOPIS Char( 10 ),
      CPSC Char( 10 ),
      CPOSTA Char( 5 ),
      CZKRATSTAT Char( 3 ),
      CZKRATNAR Char( 15 ),
      CZKRSTAPRI Char( 25 ),
      CRODCISPRE Char( 12 ),
      DDATNAROZ Date,
      CMISTONAR Char( 30 ),
      CZKRSTATNA Char( 3 ),
      CR1_KOD Char( 3 ),
      CR1_OD Char( 6 ),
      CR1_DO Char( 6 ),
      NR1_DNY Short,
      CR1_DNY Char( 4 ),
      CR1_OBD01 Char( 1 ),
      CR1_OBD02 Char( 1 ),
      CR1_OBD03 Char( 1 ),
      CR1_OBD04 Char( 1 ),
      CR1_OBD05 Char( 1 ),
      CR1_OBD06 Char( 1 ),
      CR1_OBD07 Char( 1 ),
      CR1_OBD08 Char( 1 ),
      CR1_OBD09 Char( 1 ),
      CR1_OBD10 Char( 1 ),
      CR1_OBD11 Char( 1 ),
      CR1_OBD12 Char( 1 ),
      CR1_ROK Char( 1 ),
      NR1_VYLDOB Short,
      CR1_VYLDOB Char( 3 ),
      NR1_VYMZAK Double( 0 ),
      CR1_VYMZAK Char( 12 ),
      NR1_DOBODE Short,
      CR1_DOBODE Char( 3 ),
      CR1_ZNEPL Char( 1 ),
      CR2_KOD Char( 3 ),
      CR2_OD Char( 6 ),
      CR2_DO Char( 6 ),
      NR2_DNY Short,
      CR2_DNY Char( 4 ),
      CR2_OBD01 Char( 1 ),
      CR2_OBD02 Char( 1 ),
      CR2_OBD03 Char( 1 ),
      CR2_OBD04 Char( 1 ),
      CR2_OBD05 Char( 1 ),
      CR2_OBD06 Char( 1 ),
      CR2_OBD07 Char( 1 ),
      CR2_OBD08 Char( 1 ),
      CR2_OBD09 Char( 1 ),
      CR2_OBD10 Char( 1 ),
      CR2_OBD11 Char( 1 ),
      CR2_OBD12 Char( 1 ),
      CR2_ROK Char( 1 ),
      NR2_VYLDOB Short,
      CR2_VYLDOB Char( 3 ),
      NR2_VYMZAK Double( 0 ),
      CR2_VYMZAK Char( 12 ),
      NR2_DOBODE Short,
      CR2_DOBODE Char( 3 ),
      CR2_ZNEPL Char( 1 ),
      CR3_KOD Char( 3 ),
      CR3_OD Char( 6 ),
      CR3_DO Char( 6 ),
      NR3_DNY Short,
      CR3_DNY Char( 4 ),
      CR3_OBD01 Char( 1 ),
      CR3_OBD02 Char( 1 ),
      CR3_OBD03 Char( 1 ),
      CR3_OBD04 Char( 1 ),
      CR3_OBD05 Char( 1 ),
      CR3_OBD06 Char( 1 ),
      CR3_OBD07 Char( 1 ),
      CR3_OBD08 Char( 1 ),
      CR3_OBD09 Char( 1 ),
      CR3_OBD10 Char( 1 ),
      CR3_OBD11 Char( 1 ),
      CR3_OBD12 Char( 1 ),
      CR3_ROK Char( 1 ),
      NR3_VYLDOB Short,
      CR3_VYLDOB Char( 3 ),
      NR3_VYMZAK Double( 0 ),
      CR3_VYMZAK Char( 12 ),
      NR3_DOBODE Short,
      CR3_DOBODE Char( 3 ),
      CR3_ZNEPL Char( 1 ),
      CVCM1_DRUH Char( 2 ),
      CVCM1_OD Char( 6 ),
      CVCM1_DO Char( 6 ),
      CVCM2_DRUH Char( 2 ),
      CVCM2_OD Char( 6 ),
      CVCM2_DO Char( 6 ),
      NCELVYLDOB Integer,
      CCELVYLDOB Char( 5 ),
      NCELVYMZAK Double( 0 ),
      CCELVYMZAK Char( 12 ),
      NCELDOBODE Integer,
      CCELDOBODE Char( 5 ),
      CPODNIK Char( 50 ),
      CULICEORG Char( 50 ),
      CMISTOORG Char( 50 ),
      CCISPOPORG Char( 10 ),
      CPSCORG Char( 10 ),
      NICOORG Double( 0 ),
      CVARSYM Char( 15 ),
      DDATNAST Date,
      DDATVYST Date,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      DDATVYHOEL Date,
      DODESELSSZ Date,
      DDATTISK Date,
      LRUCZMENA Logical,
      CPOZNAMKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_02',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_03',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_04',
   'STRZERO(NROK,4) +UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_05',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidp04',
   'evlidp04.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'evlidp04', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'evlidp04fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'evlidp04', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'evlidp04fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'evlidp04', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'evlidp04fail');

CREATE TABLE evlidupi ( 
      CRODCISPRA Char( 13 ),
      NPORPRAVZT Short,
      NITPOPRVZT Short,
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NPOREVIDLI Short,
      CPRACOVNIK Char( 50 ),
      NROK Short,
      CZNAKVYLRA Char( 1 ),
      CZAPOCROK Char( 2 ),
      NZAPOCDNY Short,
      CMESIC01 Char( 1 ),
      CMESIC02 Char( 1 ),
      CMESIC03 Char( 1 ),
      CMESIC04 Char( 1 ),
      CMESIC05 Char( 1 ),
      CMESIC06 Char( 1 ),
      CMESIC07 Char( 1 ),
      CMESIC08 Char( 1 ),
      CMESIC09 Char( 1 ),
      CMESIC10 Char( 1 ),
      CMESIC11 Char( 1 ),
      CMESIC12 Char( 1 ),
      CMESIC1_12 Char( 1 ),
      NVYLDOBDNY Short,
      NZAPOCPRIJ Integer,
      NDOBODPDOV Short,
      LRUCZMENA Logical,
      CPOZNAMKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_01',
   'UPPER(CRODCISPRA) +STRZERO(NDOKLAD,10) +STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_02',
   'UPPER(CRODCISPRA) +STRZERO(NPOREVIDLI,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_03',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_04',
   'UPPER(CRODCISPRA) +STRZERO(NDOKLAD,10) +STRZERO(NITPOPRVZT,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_05',
   'UPPER(CRODCISPRA) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidupi',
   'evlidupi.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'evlidupi',
   'evlidupi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'evlidupi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'evlidupifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'evlidupi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'evlidupifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'evlidupi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'evlidupifail');

CREATE TABLE expdathd ( 
      CID Char( 4 ),
      NID Integer,
      CIDEXPDATH Char( 10 ),
      CTASK Char( 3 ),
      CZKREXPORT Char( 10 ),
      CNAZEXPORT Char( 50 ),
      MBLOK Memo,
      MPROTOKOL Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_ModifyTableProperty( 'expdathd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'expdathdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'expdathd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'expdathdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'expdathd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'expdathdfail');

CREATE TABLE explsthd ( 
      CULOHA Char( 1 ),
      CTASK Char( 3 ),
      CSUBTASK Char( 3 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCISLOEL Double( 0 ),
      NCISLOPVP Double( 0 ),
      CVARSYM Char( 15 ),
      COBDOBIDAN Char( 5 ),
      CSTADOKLAD Char( 10 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      NOSVODDAN Double( 2 ),
      NPROCDAN_1 Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAR_1 Double( 2 ),
      NSAZDAR_1 Double( 2 ),
      NZAKLDAZ_1 Double( 2 ),
      NSAZDAZ_1 Double( 2 ),
      NPROCDAN_2 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NZAKLDAR_2 Double( 2 ),
      NSAZDAR_2 Double( 2 ),
      NZAKLDAZ_2 Double( 2 ),
      NSAZDAZ_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENFAKCEL Double( 2 ),
      NCENFAZCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CUCET Char( 25 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 60 ),
      CPRIJEMCE2 Char( 60 ),
      CZKRZPUDOP Char( 15 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOVINFAK Date,
      DDATTISK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELFAK Double( 2 ),
      DPOSLIKFAK Date,
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      NKURZROZDF Double( 2 ),
      DPOSUHRFAK Date,
      NPARZALFAK Double( 2 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      CBANK_UCT Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NCISPENFAK Double( 0 ),
      DDATPENFAK Date,
      NPEN_ODB Double( 2 ),
      NVYPPENODB Double( 2 ),
      NCISUPOMIN Double( 0 ),
      DUPOMINKY Date,
      NCISDOBFAK Double( 0 ),
      LHLASFAK Logical,
      CCISOBJ Char( 30 ),
      CCISLOBINT Char( 30 ),
      NCISFAK_OR Double( 0 ),
      CTYPFAK_OR Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLHOT Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CDENIK Char( 2 ),
      CUCET_UCT Char( 6 ),
      CDENIK_PUC Char( 2 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      CUCET_DAZ Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NFINTYP Short,
      NKLICOBL Short,
      NDOKLAD_DL Double( 0 ),
      NDOKLAD_PV Integer,
      CJMENOVYS Char( 25 ),
      COBDOBIO Char( 5 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      MPOPISFAK Memo,
      LNO_INDPH Logical,
      MDOLFAKCIS Memo,
      LISZAHR Logical,
      NFAKDOLCIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CTYPZAK Char( 2 ),
      CSTRED_ODB Char( 8 ),
      CSTROJ_ODB Char( 8 ),
      NPORCISLIS Double( 0 ),
      NOSCISPRAC Integer,
      CSPZ Char( 15 ),
      VLEKSPZ Char( 15 ),
      CJMENORID Char( 25 ),
      CCISLOOP Char( 15 ),
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      CVYPSAZDAN Char( 8 ),
      CISZAL_FAK Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo,
      NICODOA Integer,
      CDICDOA Char( 16 ),
      NCISFIRDOP Integer,
      CNAZEVDOP Char( 50 ),
      CNAZEVDOP2 Char( 25 ),
      NICODOP Integer,
      CDICDOP Char( 16 ),
      CULICEDOP Char( 25 ),
      CSIDLODOP Char( 25 ),
      CPSCDOP Char( 6 ),
      DEXPEDICE Date,
      DNAKLADKY Date,
      CCASNAKLAD Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'explsthd',
   'explsthd.adi',
   'EXPLSTHD01',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'explsthd',
   'explsthd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'explsthd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'explsthdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'explsthd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'explsthdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'explsthd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'explsthdfail');

CREATE TABLE explstit ( 
      CULOHA Char( 1 ),
      NCISFIRMY Integer,
      NCISFIRDOA Integer,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCOUNTDL Integer,
      NCISLOEL Double( 0 ),
      NPOLEL Integer,
      NCISLOPVP Double( 0 ),
      CZKRTYPFAK Char( 5 ),
      NINTCOUNT Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CTYPSKLPOL Char( 2 ),
      CPOLCEN Char( 1 ),
      CNAZZBO Char( 50 ),
      CUCETSKUP Char( 10 ),
      NCENJEDZAK Double( 4 ),
      NCENJEDZAD Double( 4 ),
      NCENZAKCEL Double( 2 ),
      NCENZAKCED Double( 2 ),
      NCENZAHCEL Double( 2 ),
      NJEDDAN Double( 2 ),
      NSAZDAN Double( 2 ),
      NFAKTMNOZ Double( 4 ),
      CZKRATJEDN Char( 3 ),
      NFAKTMNO2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      NKLICDPH Short,
      NPROCDPH Double( 2 ),
      NNAPOCET Short,
      NNULLDPH Short,
      NKODPLNENI Short,
      NTYPPREP Short,
      NVYPSAZDAN Short,
      NRADVYKDPH Short,
      CDOPLNTXT Char( 50 ),
      CCISOBJ Char( 15 ),
      CCISLOBINT Char( 30 ),
      NCISLOOBJP Double( 0 ),
      NCISLPOLOB Integer,
      NMNOZREODB Double( 2 ),
      NCISPENFAK Double( 0 ),
      NCELPENFAK Double( 2 ),
      NCENPENCEL Double( 2 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOSUHRFAK Date,
      NUHRCELFAZ Double( 2 ),
      NPEN_ODB Double( 2 ),
      NCISFAK_OR Double( 0 ),
      CZKRTYP_OR Char( 5 ),
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLMN Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NCENAZAKC Double( 2 ),
      NCELKSLEV Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CUCET Char( 6 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      NDOKLADORG Double( 0 ),
      NUCETSKUP Short,
      NZBOZIKAT Short,
      NPODILPROD Double( 2 ),
      CDENIK Char( 2 ),
      NCISZALFAK Double( 0 ),
      NISPARZAL Short,
      NRECFAZ Double( 0 ),
      NRECPAR Double( 0 ),
      NRECDOL Double( 0 ),
      NRECPEN Double( 0 ),
      NRECVYR Double( 0 ),
      NRECOBJ Double( 0 ),
      NKLICOBL Short,
      NCENASZBO Double( 4 ),
      NMNOZSZBO Double( 2 ),
      NCENACZBO Double( 2 ),
      MPOZZBO Memo,
      NFAKTM_ORG Double( 2 ),
      NORDIT_PVP Integer,
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CSKP Char( 15 ),
      CDANPZBO Char( 15 ),
      NIND_CEO Short,
      LIND_MOD Logical,
      NCISLOKUSU Integer,
      MDOLCIS Memo,
      AULOZENI Memo,
      CTYPSKP Char( 15 ),
      NKOEFMN Double( 2 ),
      NFAKTMNKOE Double( 4 ),
      NCEJPRZBZ Double( 4 ),
      NCEJPRKBZ Double( 4 ),
      NCEJPRKDZ Double( 4 ),
      NCEJPRZDZ Double( 4 ),
      NCECPRZBZ Double( 2 ),
      NCECPRKBZ Double( 2 ),
      NCECPRKDZ Double( 2 ),
      NHMOTNOSTJ Double( 4 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEMJ Double( 4 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      LSLUZBA Logical,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      NCISVYSFAK Double( 0 ),
      DVYKLADKY Date,
      CCASVYKLAD Char( 8 ),
      CFILE_IV Char( 10 ),
      NMNOZ_FAKT Double( 4 ),
      NSTAV_FAKT Short,
      NMNOZ_DLVY Double( 4 ),
      NMNOZ_OBJP Double( 4 ),
      NMNOZ_EXPL Double( 4 ),
      NMNOZ_ZAK Double( 4 ),
      NMNOZZDOK Double( 4 ),
      MAPOLSEST Memo,
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      NICODOA Integer,
      CDICDOA Char( 16 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      DNAKLADKY Date,
      CCASNAKLAD Char( 8 ),
      NTYPPRILOH Short);
EXECUTE PROCEDURE sp_CreateIndex( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT01',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT02',
   'STRZERO(NDOKLAD,10) +UPPER(CCISZAKAZI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT03',
   'UPPER(CCISZAKAZI)   +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT04',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'explstit',
   'explstit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'explstit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'explstitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'explstit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'explstitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'explstit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'explstitfail');

CREATE TABLE exportd ( 
      CIDEXPORTD Char( 10 ),
      CTASK Char( 3 ),
      CZKREXPORT Char( 10 ),
      CNAZEXPORT Char( 50 ),
      MBLOK Memo,
      MPROTOKOL Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_ModifyTableProperty( 'exportd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'exportdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'exportd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'exportdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'exportd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'exportdfail');

CREATE TABLE fakprihd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      DPORIZFAK Date,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      CTEXTFAKT Char( 40 ),
      NKLICDPH Short,
      NOSVODDAN Double( 2 ),
      NPROCDAN_1 Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAZ_1 Double( 2 ),
      NSAZDAZ_1 Double( 2 ),
      NPROCDAN_2 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NZAKLDAZ_2 Double( 2 ),
      NSAZDAZ_2 Double( 2 ),
      NSUMADAN Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENFAKCEL Double( 2 ),
      NCENFAZCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NKURZAHMED Double( 8 ),
      NMNOZPRED Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 18 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CUCET Char( 25 ),
      DVYSTFAKDO Date,
      DSPLATFAK Date,
      DVYSTFAK Date,
      DDATTISK Date,
      NPRIUHRCEL Double( 2 ),
      DDATPRIUHR Date,
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      NKURZROZDF Double( 2 ),
      DPOSUHRFAK Date,
      NPARZALFAK Double( 2 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      CBANK_UCT Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NCISDOBFAK Double( 0 ),
      DPOSLIKFAK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELFAK Double( 2 ),
      NCISUZV Short,
      DDATUZV Date,
      CDENIK Char( 2 ),
      CUCET_UCT Char( 6 ),
      CDENIK_PUC Char( 2 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      CUCET_DAZ Char( 6 ),
      CCISOBJ Char( 15 ),
      CJMENOPREV Char( 25 ),
      DDATPREVZ Date,
      DDATVRATIL Date,
      CZKRPRODEJ Char( 4 ),
      LDOVOZ Logical,
      NCELZAKL_1 Double( 2 ),
      NCELCLO_1 Double( 2 ),
      NCELSPD_1 Double( 2 ),
      NCELDAL_1 Double( 2 ),
      NCELZAKL_2 Double( 2 ),
      NCELCLO_2 Double( 2 ),
      NCELSPD_2 Double( 2 ),
      NCELDAL_2 Double( 2 ),
      NFINTYP Short,
      NDOKLAD Double( 0 ),
      NNULLDPH Short,
      CINT_OZN Char( 2 ),
      MPOPISFAK Memo,
      LNO_INDPH Logical,
      CISZAL_FAK Char( 1 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD3',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD4',
   'UPPER(CSIDLO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD5',
   'NICO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD6',
   'DTOS ( DSPLATFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD8',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD9',
   'NCENZAKCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD10',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRTYPFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD11',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD12',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD13',
   'UPPER(CTEXTFAKT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD14',
   'STRZERO(NCISFIRMY,5) +STRZERO(NFINTYP,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD15',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD16',
   'NCENZAHCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD17',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD18',
   'STRZERO(NICO,8) +STRZERO(NROK,4) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD19',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD20',
   'UPPER(CISZAL_FAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD21',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD22',
   'UPPER(CNAZEV) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakprihd',
   'fakprihd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakprihd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'fakprihdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakprihd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'fakprihdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakprihd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'fakprihdfail');

CREATE TABLE fakvnphd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CTEXTFAKT Char( 40 ),
      NCENZAKCEL Double( 2 ),
      CZKRATMENY Char( 3 ),
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      CUCET Char( 25 ),
      DVYSTFAK Date,
      DDATTISK Date,
      NLIKCELFAK Double( 2 ),
      DPOSLIKFAK Date,
      CVNBAN_UCT Char( 25 ),
      NCISFAK_OR Double( 0 ),
      CTYPFAK_OR Char( 5 ),
      NCENAZAKL Double( 2 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      CJMENOVYS Char( 25 ),
      MPOPISFAK Memo,
      CNAZPOL1 Char( 8 ),
      CNAZPOL1O Char( 8 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD2',
   'UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD3',
   'DTOS (DVYSTFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHH4',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD5',
   'NCENZAKCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD6',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD8',
   'UPPER(CNAZPOL1) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD9',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnphd',
   'fakvnphd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvnphd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'fakvnphdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvnphd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'fakvnphdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvnphd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'fakvnphdfail');

CREATE TABLE fakvnpit ( 
      CULOHA Char( 1 ),
      NCISFAK Double( 0 ),
      NINTCOUNT Integer,
      NSUBCOUNT Short,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      CNAZZBO Char( 50 ),
      NCENJEDZAK Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENAZAKL Double( 2 ),
      NFAKTMNOZ Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NFAKTMNO2 Double( 2 ),
      CZKRATJED2 Char( 3 ),
      CDOPLNTXT Char( 50 ),
      NCISFAK_OR Double( 0 ),
      CZKRTYP_OR Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CUCET_UCT Char( 6 ),
      CUCET Char( 6 ),
      NCENZAKLIK Double( 2 ),
      NCISLODL Double( 0 ),
      NCOUNTDL Integer,
      NDOKLADORG Double( 0 ),
      NUCETSKUP Short,
      NZBOZIKAT Short,
      CDENIK Char( 2 ),
      NRECDOL Double( 0 ),
      NRECVYR Double( 0 ),
      NCENASZBO Double( 2 ),
      MPOZZBO Memo,
      NFAKTM_ORG Double( 2 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CSKP Char( 15 ),
      NCISLOKUSU Integer,
      CTYPSKP Char( 15 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT1',
   'STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT2',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT3',
   'STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5) +STRZERO(NSUBCOUNT,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT4',
   'UPPER(CNAZPOL3) +STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT5',
   'UPPER(CNAZPOL1) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT6',
   'UPPER(CCISZAKAZ) +STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvnpit',
   'fakvnpit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvnpit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'fakvnpitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvnpit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'fakvnpitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvnpit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'fakvnpitfail');

CREATE TABLE fakvyshd ( 
      CULOHA Char( 1 ),
      CTASK Char( 3 ),
      CSUBTASK Char( 3 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCISLOEL Double( 0 ),
      NCISLOPVP Double( 0 ),
      CVARSYM Char( 15 ),
      COBDOBIDAN Char( 5 ),
      CSTADOKLAD Char( 10 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      NOSVODDAN Double( 2 ),
      NPROCDAN_1 Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAR_1 Double( 2 ),
      NSAZDAR_1 Double( 2 ),
      NZAKLDAZ_1 Double( 2 ),
      NSAZDAZ_1 Double( 2 ),
      NPROCDAN_2 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NZAKLDAR_2 Double( 2 ),
      NSAZDAR_2 Double( 2 ),
      NZAKLDAZ_2 Double( 2 ),
      NSAZDAZ_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENFAKCEL Double( 2 ),
      NCENFAZCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CUCET Char( 25 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 60 ),
      CPRIJEMCE2 Char( 60 ),
      CZKRZPUDOP Char( 15 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOVINFAK Date,
      DDATTISK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELFAK Double( 2 ),
      DPOSLIKFAK Date,
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      NKURZROZDF Double( 2 ),
      DPOSUHRFAK Date,
      NPARZALFAK Double( 2 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      CBANK_UCT Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NCISPENFAK Double( 0 ),
      DDATPENFAK Date,
      NPEN_ODB Double( 2 ),
      NVYPPENODB Double( 2 ),
      NCISUPOMIN Double( 0 ),
      DUPOMINKY Date,
      NCISDOBFAK Double( 0 ),
      LHLASFAK Logical,
      CCISOBJ Char( 30 ),
      CCISLOBINT Char( 30 ),
      NCISFAK_OR Double( 0 ),
      CTYPFAK_OR Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLHOT Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CDENIK Char( 2 ),
      CUCET_UCT Char( 6 ),
      CDENIK_PUC Char( 2 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      CUCET_DAZ Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NFINTYP Short,
      NKLICOBL Short,
      NDOKLAD_DL Double( 0 ),
      NDOKLAD_PV Integer,
      CJMENOVYS Char( 25 ),
      COBDOBIO Char( 5 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      MPOPISFAK Memo,
      LNO_INDPH Logical,
      MDOLFAKCIS Memo,
      LISZAHR Logical,
      NFAKDOLCIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CTYPZAK Char( 2 ),
      CSTRED_ODB Char( 8 ),
      CSTROJ_ODB Char( 8 ),
      NPORCISLIS Double( 0 ),
      NOSCISPRAC Integer,
      CSPZ Char( 15 ),
      VLEKSPZ Char( 15 ),
      CJMENORID Char( 25 ),
      CCISLOOP Char( 15 ),
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      CVYPSAZDAN Char( 8 ),
      CISZAL_FAK Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD3',
   'UPPER(CCISLOBINT) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD4',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD5',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD6',
   'UPPER(CZKRTYPFAK) +UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFIRMY,5) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD8',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRTYPFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD9',
   'STRZERO(NKASA,3) +DTOS (DVYSTFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD10',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD11',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD12',
   'NICO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD13',
   'DTOS ( DSPLATFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD14',
   'NCENZAKCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD15',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD16',
   'STRZERO(NCISFIRMY,5) +STRZERO(NFINTYP,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD17',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD18',
   'NCENZAHCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD19',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD20',
   'UPPER(CULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD21',
   'STRZERO(NICO,8) +STRZERO(NROK,4) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD22',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD23',
   'UPPER(CISZAL_FAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD24',
   'DTOS ( DVYSTFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD25',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD26',
   'NCISFIRDOA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD27',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD28',
   'UPPER(CNAZEV) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvyshd',
   'fakvyshd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvyshd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'fakvyshdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvyshd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'fakvyshdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvyshd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'fakvyshdfail');

CREATE TABLE fakvysit ( 
      CULOHA Char( 1 ),
      NCISFIRMY Integer,
      NCISFIRDOA Integer,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCOUNTDL Integer,
      NCISLOEL Double( 0 ),
      NPOLEL Integer,
      NCISLOPVP Double( 0 ),
      CZKRTYPFAK Char( 5 ),
      NINTCOUNT Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CTYPSKLPOL Char( 2 ),
      CPOLCEN Char( 1 ),
      CNAZZBO Char( 50 ),
      CUCETSKUP Char( 10 ),
      NCENJEDZAK Double( 4 ),
      NCENJEDZAD Double( 4 ),
      NCENZAKCEL Double( 2 ),
      NCENZAKCED Double( 2 ),
      NCENZAHCEL Double( 2 ),
      NJEDDAN Double( 2 ),
      NSAZDAN Double( 2 ),
      NFAKTMNOZ Double( 4 ),
      CZKRATJEDN Char( 3 ),
      NFAKTMNO2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      NKLICDPH Short,
      NPROCDPH Double( 2 ),
      NNAPOCET Short,
      NNULLDPH Short,
      NKODPLNENI Short,
      NTYPPREP Short,
      NVYPSAZDAN Short,
      NRADVYKDPH Short,
      CDOPLNTXT Char( 50 ),
      CCISOBJ Char( 15 ),
      CCISLOBINT Char( 30 ),
      NCISLOOBJP Double( 0 ),
      NCISLPOLOB Integer,
      NMNOZREODB Double( 2 ),
      NCISPENFAK Double( 0 ),
      NCELPENFAK Double( 2 ),
      NCENPENCEL Double( 2 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOSUHRFAK Date,
      NUHRCELFAZ Double( 2 ),
      NPEN_ODB Double( 2 ),
      NCISFAK_OR Double( 0 ),
      CZKRTYP_OR Char( 5 ),
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLMN Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NCENAZAKC Double( 2 ),
      NCELKSLEV Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CUCET Char( 6 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      NDOKLADORG Double( 0 ),
      NUCETSKUP Short,
      NZBOZIKAT Short,
      NPODILPROD Double( 2 ),
      CDENIK Char( 2 ),
      NCISZALFAK Double( 0 ),
      NISPARZAL Short,
      NRECFAZ Double( 0 ),
      NRECPAR Double( 0 ),
      NRECDOL Double( 0 ),
      NRECPEN Double( 0 ),
      NRECVYR Double( 0 ),
      NRECOBJ Double( 0 ),
      NKLICOBL Short,
      NCENASZBO Double( 4 ),
      NMNOZSZBO Double( 2 ),
      NCENACZBO Double( 2 ),
      MPOZZBO Memo,
      NFAKTM_ORG Double( 2 ),
      NORDIT_PVP Integer,
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CSKP Char( 15 ),
      CDANPZBO Char( 15 ),
      NIND_CEO Short,
      LIND_MOD Logical,
      NCISLOKUSU Integer,
      MDOLCIS Memo,
      AULOZENI Memo,
      CTYPSKP Char( 15 ),
      NKOEFMN Double( 2 ),
      NFAKTMNKOE Double( 4 ),
      NCEJPRZBZ Double( 4 ),
      NCEJPRKBZ Double( 4 ),
      NCEJPRKDZ Double( 4 ),
      NCEJPRZDZ Double( 4 ),
      NCECPRZBZ Double( 2 ),
      NCECPRKBZ Double( 2 ),
      NCECPRKDZ Double( 2 ),
      NHMOTNOSTJ Double( 4 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEMJ Double( 4 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      LSLUZBA Logical,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      NCISVYSFAK Double( 0 ),
      DVYKLADKY Date,
      CCASVYKLAD Char( 8 ),
      CFILE_IV Char( 10 ),
      NMNOZ_FAKT Double( 4 ),
      NSTAV_FAKT Short,
      NMNOZ_DLVY Double( 4 ),
      NMNOZ_OBJP Double( 4 ),
      NMNOZ_EXPL Double( 4 ),
      NMNOZ_ZAK Double( 4 ),
      NMNOZZDOK Double( 4 ),
      MAPOLSEST Memo,
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT1',
   'STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT3',
   'UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT4',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT5',
   'UPPER(CNAZPOL3) +STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT6',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT7',
   'UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT8',
   'STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT9',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT10',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT11',
   'STRZERO(NCISLODL,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT12',
   'UPPER(CCISZAKAZI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT13',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fakvysit',
   'fakvysit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvysit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'fakvysitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvysit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'fakvysitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fakvysit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'fakvysitfail');

CREATE TABLE filtrs ( 
      CTYPFILTRS Char( 4 ),
      NCISFILTRS Integer,
      NOPTLEVEL Short,
      CFLTNAME Char( 50 ),
      CIDFILTERS Char( 10 ),
      CUSER Char( 10 ),
      CTASK Char( 3 ),
      CMAINFILE Char( 10 ),
      MFILTERS Memo,
      MDATA Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS01',
   'UPPER(CIDFILTERS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS02',
   'UPPER(CFLTNAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS03',
   'UPPER(CTASK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS04',
   'UPPER(CUSER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS05',
   'UPPER(CMAINFILE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS06',
   'UPPER(CTYPFILTRS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS07',
   'NCISFILTRS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'FILTRS08',
   'UPPER(CFLTNAME)+UPPER(CIDFILTERS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'filtrs',
   'filtrs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'filtrs', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'filtrsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'filtrs', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'filtrsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'filtrs', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'filtrsfail');

CREATE TABLE finpren ( 
      NWKSTATION Short,
      COBDOBI Char( 5 ),
      NCOUNPREN Short,
      NTYPEPREN Short,
      DDATEPREN Date,
      CTIMEPREN Char( 8 ),
      CUSERPREN Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'finpren',
   'finpren.adi',
   'FINPREN1',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'finpren',
   'finpren.adi',
   'FINPREN2',
   'STRZERO(NWKSTATION,3) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'finpren',
   'finpren.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'finpren', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'finprenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'finpren', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'finprenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'finpren', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'finprenfail');

CREATE TABLE firmy ( 
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 50 ),
      NICO Integer,
      CDIC Char( 16 ),
      CDIC_OLD Char( 16 ),
      CVAT_ID Char( 16 ),
      CULICE Char( 25 ),
      CCISPOPIS Char( 10 ),
      CULICCIPOP Char( 35 ),
      CPOBOX Char( 20 ),
      CSIDLO Char( 20 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CCINNOST Char( 15 ),
      CZASTUPCE Char( 25 ),
      CZARAZENI Char( 25 ),
      CTELEFON Char( 17 ),
      CFAX Char( 17 ),
      NCISODE Integer,
      CZASTOBCH Char( 25 ),
      CTELEFON2 Char( 17 ),
      CMODEMBBS Char( 17 ),
      CMOBILTEL Char( 17 ),
      CEMAILTEL Char( 65 ),
      COBVZTH Char( 90 ),
      CUZVZTH Char( 90 ),
      NKLICOBL Integer,
      NMNOZNEODB Double( 2 ),
      NMNOZNEDOD Double( 2 ),
      CZKRPRODEJ Char( 4 ),
      NCISREG Double( 0 ),
      DREGDPH_OD Date,
      DREGDPH_DO Date,
      CKRAJ Char( 10 ),
      COKRES Char( 10 ),
      CVYPSAZDAN Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY1',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY3',
   'UPPER(CSIDLO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY4',
   'UPPER(CPSC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY5',
   'NMNOZNEODB',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY6',
   'NICO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY7',
   'STRZERO(NKLICOBL,8) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY8',
   'UPPER(CDIC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'FIRMY9',
   'UPPER(CZKRATSTAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmy',
   'firmy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'firmyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'firmyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'firmyfail');

CREATE TABLE firmybcd ( 
      NCISFIRMY Integer,
      CZKRCARKOD Char( 8 ),
      CCARKOD Char( 25 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD01',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD02',
   'UPPER(CZKRCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD03',
   'UPPER(CCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD04',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRCARKOD) +UPPER(CCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmybcd',
   'firmybcd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmybcd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'firmybcdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmybcd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'firmybcdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmybcd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'firmybcdfail');

CREATE TABLE firmyda ( 
      NCISFIRMY Integer,
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CCINNOST Char( 15 ),
      CPSCDOA Char( 6 ),
      CSIDLODOA Char( 20 ),
      CULICEDOA Char( 25 ),
      CTELDOA Char( 17 ),
      CFAXDOA Char( 17 ),
      CMODDOA Char( 17 ),
      CZASTDOA Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyda',
   'firmyda.adi',
   'FIRMYDA1',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyda',
   'firmyda.adi',
   'FIRMYDA2',
   'STRZERO(NCISFIRMY,5) +UPPER(CNAZEVDOA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyda',
   'firmyda.adi',
   'FIRMYDA3',
   'NCISFIRDOA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyda',
   'firmyda.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyda', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'firmydafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyda', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'firmydafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyda', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'firmydafail');

CREATE TABLE firmyfi ( 
      NCISFIRMY Integer,
      CUCT_DOD Char( 6 ),
      CUCT_FPZ Char( 6 ),
      NSPLATNDOD Integer,
      CSPECSYMBO Char( 20 ),
      NKONSTSYMD Short,
      NPEN_DOD Double( 2 ),
      CZKRTYPUHR Char( 5 ),
      NSKNDNYDOD Integer,
      NSKNPRCDOD Double( 2 ),
      NUVERDNY Integer,
      NLIMZAV Double( 2 ),
      NSUMZAV Double( 2 ),
      NSUMZAVCEL Double( 2 ),
      DDATPOSZAV Date,
      CZKRZPUDOP Char( 15 ),
      CUCT_ODB Char( 6 ),
      CUCT_FVZ Char( 6 ),
      NSPLATNOST Integer,
      NPEN_ODB Double( 2 ),
      CSPECSYMOD Char( 20 ),
      NKONSTSYMB Short,
      CZKRTYPUOD Char( 5 ),
      NSKNDNYODB Integer,
      NSKNPRCODB Double( 2 ),
      NUVERDNYOD Integer,
      NLIMPOH Double( 2 ),
      NSUMPOH Double( 2 ),
      NSUMPOHCEL Double( 2 ),
      DDATPOSPOH Date,
      CZKRZPUDOD Char( 15 ),
      CZKRPRODEJ Char( 4 ),
      CPRACDOBA1 Char( 25 ),
      CPRACDOBA2 Char( 25 ),
      CBANK_UCOD Char( 25 ),
      CZKRMENYOD Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyfi',
   'firmyfi.adi',
   'FIRMYFI1',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyfi',
   'firmyfi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyfi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'firmyfifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyfi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'firmyfifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyfi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'firmyfifail');

CREATE TABLE firmysk ( 
      NCISFIRMY Integer,
      CZKR_SKUP Char( 3 ),
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'firmysk',
   'firmysk.adi',
   'FIRMYSK01',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmysk',
   'firmysk.adi',
   'FIRMYSK02',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKR_SKUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmysk',
   'firmysk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmysk', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'firmyskfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmysk', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'firmyskfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmysk', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'firmyskfail');

CREATE TABLE firmyuc ( 
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      NICO Integer,
      CDIC Char( 16 ),
      CUCET Char( 25 ),
      CBANK_NAZ Char( 25 ),
      CBANK_POB Char( 20 ),
      CBANK_PSC Char( 6 ),
      CBANK_SID Char( 25 ),
      CBANK_ULI Char( 25 ),
      CBANK_TEL Char( 17 ),
      CBANK_FAX Char( 17 ),
      CBANK_MOD Char( 17 ),
      CBANKODPO Char( 25 ),
      CSPECSYMB Char( 20 ),
      CUCET_UCT Char( 6 ),
      CIBAN Char( 24 ),
      CBIC Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC1',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC2',
   'UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC3',
   'UPPER(CBANK_NAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC4',
   'STRZERO(NCISFIRMY,5) +UPPER(CBANK_NAZ) +UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC5',
   'STRZERO(NCISFIRMY,5) +UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC6',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC7',
   'NICO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC8',
   'UPPER(CDIC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyuc',
   'firmyuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyuc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'firmyucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyuc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'firmyucfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyuc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'firmyucfail');

CREATE TABLE firmyva ( 
      NCISFIRMY Integer,
      CZKR_SK Char( 3 ),
      NCISFIRVA Integer,
      CZKR_SKVA Char( 3 ),
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyva',
   'firmyva.adi',
   'FIRMYVA01',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyva',
   'firmyva.adi',
   'FIRMYVA02',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKR_SK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyva',
   'firmyva.adi',
   'FIRMYVA03',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKR_SK) +UPPER(CZKR_SKVA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'firmyva',
   'firmyva.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyva', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'firmyvafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyva', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'firmyvafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'firmyva', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'firmyvafail');

CREATE TABLE fixnakl ( 
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      NROKVYP Short,
      NOBDMES Short,
      NODBYTREVY Double( 3 ),
      NODBYTRENA Double( 3 ),
      NZASOBREVY Double( 3 ),
      NZASOBRENA Double( 3 ),
      NVYROBREVY Double( 3 ),
      NVYROBRENA Double( 3 ),
      NSPRAVREVY Double( 3 ),
      NSPRAVRENA Double( 3 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'fixnakl',
   'fixnakl.adi',
   'FIXNAK1',
   'STRZERO(NROKVYP,4) +UPPER(CNAZPOL1) +STRZERO(NOBDMES,2) +UPPER(CNAZPOL2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fixnakl',
   'fixnakl.adi',
   'FIXNAK2',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fixnakl',
   'fixnakl.adi',
   'FIXNAK3',
   'UPPER(CNAZPOL1) +STRZERO(NROKVYP,4) +STRZERO(NOBDMES,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fixnakl',
   'fixnakl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'fixnakl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'fixnaklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fixnakl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'fixnaklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fixnakl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'fixnaklfail');

CREATE TABLE fltusers ( 
      CFLTNAME Char( 50 ),
      CUSER Char( 10 ),
      CCALLFORM Char( 50 ),
      CIDFILTERS Char( 10 ),
      CIDFORMS Char( 10 ),
      CMAINFILE Char( 10 ),
      LSELECT Logical,
      LBEGADMIN Logical,
      LBEGUSERS Logical,
      LFILTRYES Logical,
      MFILTERS Memo,
      MFILTERS_U Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS01',
   'UPPER(CUSER)+UPPER(CCALLFORM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS02',
   'UPPER(CFLTNAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS03',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDFILTERS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS04',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDFORMS)+UPPER(CIDFILTERS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS05',
   'UPPER(CIDFILTERS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'fltusers',
   'fltusers.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'fltusers', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'fltusersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fltusers', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'fltusersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'fltusers', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'fltusersfail');

CREATE TABLE forms ( 
      CTYPFORMS Char( 4 ),
      NCISFORMS Integer,
      CFORMNAME Char( 50 ),
      CIDFORMS Char( 10 ),
      CIDFILTERS Char( 10 ),
      LISFORM Logical,
      NTYPPROJ_L Short,
      NTYPPRINT Short,
      NTYPZPR Short,
      CUSER Char( 10 ),
      CGROUP Char( 10 ),
      CTASK Char( 3 ),
      CMAINFILE Char( 10 ),
      MFORMS_LL Memo,
      NFORMS_LL Short,
      MDATA_LL Memo,
      MTISK_LL Memo,
      MBLOCKFRM Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS01',
   'UPPER(CIDFORMS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS02',
   'UPPER(CFORMNAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS03',
   'UPPER(CTASK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS04',
   'UPPER(CUSER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS05',
   'UPPER(CMAINFILE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS06',
   'UPPER(CTYPFORMS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS07',
   'NCISFORMS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS08',
   'UPPER(CFORMNAME)+UPPER(CIDFORMS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'FORMS09',
   'NFORMS_LL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'forms',
   'forms.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'forms', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'formsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'forms', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'formsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'forms', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'formsfail');

CREATE TABLE frmusers ( 
      CFORMNAME Char( 50 ),
      CUSER Char( 10 ),
      CCALLFORM Char( 50 ),
      CIDFORMS Char( 10 ),
      CIDFILTERS Char( 10 ),
      MTISK Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS01',
   'UPPER(CUSER)+UPPER(CCALLFORM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS02',
   'UPPER(CFORMNAME)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS03',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDFORMS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS04',
   'UPPER(CIDFORMS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'frmusers',
   'frmusers.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'frmusers', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'frmusersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'frmusers', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'frmusersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'frmusers', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'frmusersfail');

CREATE TABLE hodatrib ( 
      COZNOPER Char( 10 ),
      CATRIBOPER Char( 4 ),
      CHODNATRC Char( 15 ),
      NHODNATRN Double( 4 ),
      MPOZNAMKA Memo,
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'hodatrib',
   'hodatrib.adi',
   'HODATR1',
   'UPPER(COZNOPER) +UPPER(CATRIBOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'hodatrib',
   'hodatrib.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'hodatrib', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'hodatribfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'hodatrib', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'hodatribfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'hodatrib', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'hodatribfail');

CREATE TABLE ikusov ( 
      CVYRPOL Char( 15 ),
      CCISZAKAZ Char( 30 ),
      CVYSPOL Char( 15 ),
      CNIZPOL Char( 15 ),
      NNIZVAR Short,
      CSKLPOL Char( 15 ),
      NPOZICE Short,
      NVARPOZ Short,
      NCIMNO Double( 6 ),
      NSPMNO Double( 6 ),
      CSTAV Char( 1 ),
      CTYPPOL Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV1',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NPOZICE,3) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV2',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL) +STRZERO(NNIZVAR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV4',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusov',
   'ikusov.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ikusov', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ikusovfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ikusov', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ikusovfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ikusov', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ikusovfail');

CREATE TABLE ikusovs ( 
      CVYRPOL Char( 15 ),
      CCISZAKAZ Char( 30 ),
      CVYSPOL Char( 15 ),
      CNIZPOL Char( 15 ),
      NNIZVAR Short,
      CSKLPOL Char( 15 ),
      NPOZICE Short,
      NVARPOZ Short,
      NCIMNO Double( 6 ),
      NSPMNO Double( 6 ),
      CSTAV Char( 1 ),
      CTYPPOL Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS1',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NPOZICE,3) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS2',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL) +STRZERO(NNIZVAR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS4',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ikusovs',
   'ikusovs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ikusovs', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ikusovsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ikusovs', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ikusovsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ikusovs', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ikusovsfail');

CREATE TABLE impdathd ( 
      CID Char( 4 ),
      NID Integer,
      CIDIMPDATH Char( 10 ),
      CTASK Char( 3 ),
      CZKRIMPORT Char( 10 ),
      CNAZIMPORT Char( 50 ),
      MBLOK Memo,
      MPROTOKOL Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_ModifyTableProperty( 'impdathd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'impdathdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'impdathd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'impdathdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'impdathd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'impdathdfail');

CREATE TABLE importd ( 
      CIDIMPORTD Char( 10 ),
      CTASK Char( 3 ),
      CZKRIMPORT Char( 10 ),
      CNAZIMPORT Char( 50 ),
      MBLOK Memo,
      MPROTOKOL Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_ModifyTableProperty( 'importd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'importdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'importd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'importdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'importd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'importdfail');

CREATE TABLE infnap ( 
      SOUBOR Char( 8 ),
      NROK Short,
      MESICE Char( 12 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'infnap',
   'infnap.adi',
   'INFNAP01',
   'UPPER(SOUBOR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'infnap',
   'infnap.adi',
   'INFNAP02',
   'STRZERO(NROK,4) +UPPER(SOUBOR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'infnap',
   'infnap.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'infnap', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'infnapfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'infnap', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'infnapfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'infnap', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'infnapfail');

CREATE TABLE kalendar ( 
      DDATUM Date,
      NDEN Short,
      NTYDEN Short,
      NMESIC Short,
      NROK Short,
      NPOLOLETI Short,
      NCTVRTLETI Short,
      CNAZDNE Char( 10 ),
      CNAZMES Char( 10 ),
      CZKRNAZDNE Char( 2 ),
      CSVATJMENO Char( 20 ),
      CTYPDNE Char( 3 ),
      DPLATN_OD Date,
      DPLATN_DO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'kalendar',
   'kalendar.adi',
   'KALENDAR01',
   'DTOS(DDATUM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalendar',
   'kalendar.adi',
   'KALENDAR02',
   'STRZERO(NROK,4) +STRZERO(NTYDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalendar',
   'kalendar.adi',
   'KALENDAR03',
   'STRZERO(NROK,4) +STRZERO(NMESIC,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalendar',
   'kalendar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalendar', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kalendarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalendar', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kalendarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalendar', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kalendarfail');

CREATE TABLE kalkmzd ( 
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      COZNPRAC Char( 8 ),
      CTYPOPER Char( 3 ),
      COZNOPER Char( 10 ),
      NPRIPRCAS Double( 3 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRKC Double( 3 ),
      NKUSOVKC Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkmzd',
   'kalkmzd.adi',
   'KALKMZD1',
   'UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkmzd',
   'kalkmzd.adi',
   'KALKMZD2',
   'UPPER(CVYRPOL) +UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkmzd',
   'kalkmzd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkmzd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kalkmzdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkmzd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kalkmzdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkmzd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kalkmzdfail');

CREATE TABLE kalkul ( 
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CTYPKALK Char( 3 ),
      CZKRATMENY Char( 3 ),
      NTYPREZIE Short,
      DDATAKTUAL Date,
      NROKVYP Short,
      NOBDMES Short,
      NPORKALDEN Short,
      NMNOZDAVKY Double( 2 ),
      CDRUHCENY Char( 2 ),
      NCENMATZMP Double( 2 ),
      NCENMATZMS Double( 2 ),
      NCENMATMJP Double( 2 ),
      NCENMATMJS Double( 2 ),
      NCENMZDVDP Double( 2 ),
      NCENMZDVDS Double( 2 ),
      NCENOSTATP Double( 2 ),
      NCENOSTATS Double( 2 ),
      NCENSLUZBP Double( 2 ),
      NCENSLUZBS Double( 2 ),
      NCENENERGP Double( 2 ),
      NCENENERGS Double( 2 ),
      NCENMAJETP Double( 2 ),
      NCENMAJETS Double( 2 ),
      NREZODBYTP Double( 2 ),
      NREZODBYTS Double( 2 ),
      NALGODBYT Short,
      NREZVYROBP Double( 2 ),
      NREZVYROBS Double( 2 ),
      NALGVYROB Short,
      NREZZASOBP Double( 2 ),
      NREZZASOBS Double( 2 ),
      NALGZASOB Short,
      NREZSPRAVP Double( 2 ),
      NREZSPRAVS Double( 2 ),
      NALGSPRAV Short,
      NCENKALKP Double( 2 ),
      NCENKALKS Double( 2 ),
      NZISKPROCP Double( 2 ),
      NZISKP Double( 2 ),
      NZISKS Double( 2 ),
      NCENPRODP Double( 2 ),
      NCENPRODS Double( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      CNAZPOL1 Char( 8 ),
      NPRIPRCAS Double( 4 ),
      NKUSOVCAS Double( 4 ),
      NSTAVKALK Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkul',
   'kalkul.adi',
   'KALKUL1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +STRZERO(NROKVYP,4) +STRZERO(NOBDMES,2) +DTOS(DDATAKTUAL) +STRZERO(NPORKALDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkul',
   'kalkul.adi',
   'KALKUL2',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +UPPER(CTYPKALK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkul',
   'kalkul.adi',
   'KALKUL3',
   'UPPER(CCISZAKAZ) +UPPER(CTYPKALK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkul',
   'kalkul.adi',
   'KALKUL4',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)+STRZERO(NSTAVKALK,2) +STRZERO(NROKVYP,4) +STRZERO(NOBDMES,2) +DTOS(DDATAKTUAL) +STRZERO(NPORKALDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkul',
   'kalkul.adi',
   'KALKUL5',
   'UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +UPPER(CTYPKALK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkul',
   'kalkul.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkul', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kalkulfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkul', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kalkulfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkul', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kalkulfail');

CREATE TABLE kalkzak ( 
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      NROK Short,
      NOBDOBI Short,
      CZAOBDOBI Char( 2 ),
      NMNOZODVED Double( 2 ),
      NMNOZODVO Double( 2 ),
      DDATZPRAC Date,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NPLPRMATZ Double( 2 ),
      NPLHODINZ Double( 2 ),
      NPLPRMZDZ Double( 2 ),
      NPLPRKOOZ Double( 2 ),
      NPLREZIEZ Double( 2 ),
      NSKPRMATZ Double( 2 ),
      NSKPRMATZP Double( 2 ),
      NSKHODINZ Double( 2 ),
      NSKHODINVS Double( 2 ),
      NSKPRMZDZ Double( 2 ),
      NSKPRMZUKZ Double( 2 ),
      NSKOSTPRNA Double( 2 ),
      NSKOSTPRMZ Double( 2 ),
      NSKPRKOOZ Double( 2 ),
      NSKPRKOOZ2 Double( 2 ),
      NSKREZIEZ Double( 2 ),
      NODBYTREZ Double( 2 ),
      NODBYTREPR Double( 3 ),
      NVYROBREZ Double( 2 ),
      NVYROBREPR Double( 3 ),
      NZASOBREZ Double( 2 ),
      NZASOBREPR Double( 3 ),
      NSPRAVREZ Double( 2 ),
      NSPRAVREPR Double( 3 ),
      NCENZAKCEL Double( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CVYRPOL Char( 15 ),
      NCISFIRMY Integer,
      NSKPRMATZH Double( 2 ),
      NZMENASNV Double( 2 ),
      NKURZSTRED Double( 8 ),
      NMATZM_U Double( 2 ),
      NMATCZK_U Double( 2 ),
      NMZDY_U Double( 2 ),
      NKOOP1_U Double( 2 ),
      NKOOP2_U Double( 2 ),
      NVYRREZ_U Double( 2 ),
      NZASREZ_U Double( 2 ),
      NODBREZ_U Double( 2 ),
      NSPRREZ_U Double( 2 ),
      NNABEHNV Double( 2 ),
      NOSTPRMZ_U Double( 2 ),
      NP_ODBREZ Double( 2 ),
      NU_ODBREZ Double( 2 ),
      NP_ZASREZ Double( 2 ),
      NU_ZASREZ Double( 2 ),
      NP_SPRREZ Double( 2 ),
      NU_SPRREZ Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkzak',
   'kalkzak.adi',
   'KALKZAK1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkzak',
   'kalkzak.adi',
   'KALKZAK2',
   'UPPER(CCISZAKAZ) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZAOBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kalkzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kalkzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kalkzakfail');

CREATE TABLE kalkzem ( 
      COZNAC Char( 1 ),
      CNAZPOL2 Char( 8 ),
      CNAZEV Char( 25 ),
      NPRIMNAKL Double( 2 ),
      NSPOVLVYR Double( 2 ),
      NVNNAKPOCI Double( 2 ),
      NVYRREZIE Double( 2 ),
      NVYRNAKL Double( 2 ),
      NODPVEDLVY Double( 2 ),
      NNAKBEZCDR Double( 2 ),
      NCELDRUREZ Double( 2 ),
      NNAKSCDR Double( 2 ),
      NVYROBAMN Double( 2 ),
      NNAKJEDBEC Double( 2 ),
      NNAKJEDSC Double( 2 ),
      CPRIMNAKL Char( 10 ),
      CSPOVLVYR Char( 10 ),
      CVNNAKPOCI Char( 10 ),
      CVYRREZIE Char( 10 ),
      CVYRNAKL Char( 10 ),
      CODPVEDLVY Char( 10 ),
      CNAKBEZCDR Char( 10 ),
      CCELDRUREZ Char( 10 ),
      CNAKSCDR Char( 10 ),
      CVYROBAMN Char( 10 ),
      CNAKJEDBEC Char( 10 ),
      CNAKJEDSC Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'kalkzem',
   'kalkzem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkzem', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kalkzemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkzem', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kalkzemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kalkzem', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kalkzemfail');

CREATE TABLE kapl_den ( 
      DVYHOTPLAN Date,
      NTYDKAPBLO Short,
      NOBDOBI Short,
      NROKVYTVOR Short,
      CPRACZAR Char( 8 ),
      CSTRED Char( 8 ),
      NPRACODOBA Double( 2 ),
      NPOCETLIDI Double( 2 ),
      NKAPACNHOD Double( 2 ),
      NBLOKACENH Double( 2 ),
      NVOLNAKAPA Double( 2 ),
      CPOZNAMKA Char( 40 ),
      DZMENA Date,
      CZMENA Char( 8 ),
      NPOCSMEN Double( 2 ),
      CCISPLAN Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_1',
   'DTOS (DVYHOTPLAN) + UPPER(CPRACZAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_2',
   'DTOS (DVYHOTPLAN) + UPPER(CSTRED) + UPPER(CPRACZAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_3',
   'UPPER(CPRACZAR) + DTOS(DVYHOTPLAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_4',
   'STRZERO(NTYDKAPBLO,2) + UPPER(CPRACZAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_5',
   'UPPER(CPRACZAR) + STRZERO(NTYDKAPBLO,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_6',
   'UPPER(CPRACZAR) + UPPER(CCISPLAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapl_den', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kapl_denfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapl_den', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kapl_denfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapl_den', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kapl_denfail');

CREATE TABLE kapp_den ( 
      DVYHOTPLAN Date,
      NTYDKAPBLO Short,
      NOBDOBI Short,
      NROKVYTVOR Short,
      COZNPRAC Char( 8 ),
      CSTRED Char( 8 ),
      NPRACODOBA Double( 2 ),
      NPOCETSTRO Double( 2 ),
      NKAPACNHOD Double( 2 ),
      NBLOKACENH Double( 2 ),
      NVOLNAKAPA Double( 2 ),
      CPOZNAMKA Char( 40 ),
      DZMENA Date,
      CZMENA Char( 8 ),
      NPOCSMEN Double( 2 ),
      CCISPLAN Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_1',
   'DTOS (DVYHOTPLAN) + UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_2',
   'DTOS (DVYHOTPLAN) + UPPER(CSTRED) + UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_3',
   'UPPER(COZNPRAC) + DTOS(DVYHOTPLAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_4',
   'STRZERO(NTYDKAPBLO,2) + UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_5',
   'UPPER(COZNPRAC) + STRZERO(NTYDKAPBLO,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_6',
   'UPPER(COZNPRAC) + UPPER(CCISPLAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapp_den', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kapp_denfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapp_den', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kapp_denfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapp_den', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kapp_denfail');

CREATE TABLE kapp_tyd ( 
      CVYROBSTRE Char( 8 ),
      COZNPRAC Char( 8 ),
      NROKKAPBLO Short,
      NTYDKAPBLO Short,
      NCELLIDKAP Double( 3 ),
      NCELSTRKAP Double( 3 ),
      NBLOLIDSKU Double( 3 ),
      NBLOSTRSKU Double( 3 ),
      NBLOLIDPLA Double( 3 ),
      NBLOSTRPLA Double( 3 ),
      NBLOLINMAN Double( 3 ),
      NBLOSTRMAN Double( 3 ),
      NVOLLIDKAP Double( 3 ),
      NVOLSTRKAP Double( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_tyd',
   'kapp_tyd.adi',
   'KAPPTY_1',
   'UPPER(CVYROBSTRE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_tyd',
   'kapp_tyd.adi',
   'KAPPTY_2',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kapp_tyd',
   'kapp_tyd.adi',
   'KAPPTY_3',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC) +STRZERO(NROKKAPBLO,4) +STRZERO(NTYDKAPBLO,2) +STRZERO(NVOLSTRKAP,9)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapp_tyd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kapp_tydfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapp_tyd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kapp_tydfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kapp_tyd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kapp_tydfail');

CREATE TABLE kaps_tyd ( 
      CVYROBSTRE Char( 8 ),
      NROKKAPBLO Short,
      NTYDKAPBLO Short,
      NCELLIDKAP Double( 3 ),
      NCELSTRKAP Double( 3 ),
      NBLOLIDSKU Double( 3 ),
      NBLOSTRSKU Double( 3 ),
      NBLOLIDPLA Double( 3 ),
      NBLOSTRPLA Double( 3 ),
      NBLOLINMAN Double( 3 ),
      NBLOSTRMAN Double( 3 ),
      NVOLLIDKAP Double( 3 ),
      NVOLSTRKAP Double( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kaps_tyd',
   'kaps_tyd.adi',
   'KAPSTY_1',
   'UPPER(CVYROBSTRE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kaps_tyd',
   'kaps_tyd.adi',
   'KAPSTY_2',
   'UPPER(CVYROBSTRE) +STRZERO(NTYDKAPBLO,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kaps_tyd',
   'kaps_tyd.adi',
   'KAPSTY_3',
   'UPPER(CVYROBSTRE) +STRZERO(NTYDKAPBLO,2) +STRZERO(NVOLLIDKAP,9)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kaps_tyd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kaps_tydfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kaps_tyd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kaps_tydfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kaps_tyd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kaps_tydfail');

CREATE TABLE kategzvi ( 
      NZVIRKAT Integer,
      CNAZEVKAT Char( 20 ),
      NPOHLAVI Short,
      CNAZPOL2 Char( 8 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CDANPZBO Char( 15 ),
      CTYPSKP Char( 15 ),
      NCENAV1ZV Double( 2 ),
      NCENAV2ZV Double( 2 ),
      LVZRUST Logical,
      NZVIRKATPR Integer,
      CNAZPOL2PR Char( 8 ),
      NTYPVYPCEL Short,
      CTYPEVID Char( 1 ),
      CTYPVYPCEN Char( 3 ),
      NODPISK Short,
      NTYPDODPI Short,
      NTYPUODPI Short,
      NROKYODPIU Short,
      NUPLPROC Double( 2 ),
      CODPISK Char( 4 ),
      NUCETSKUPP Short,
      NKCPREVTOP Double( 2 ),
      NKCPREVBOT Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kategzvi',
   'kategzvi.adi',
   'KATEGZVI_1',
   'NZVIRKAT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kategzvi',
   'kategzvi.adi',
   'KATEGZVI_2',
   'UPPER(CNAZEVKAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kategzvi',
   'kategzvi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kategzvi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kategzvifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kategzvi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kategzvifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kategzvi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kategzvifail');

CREATE TABLE komusers ( 
      CNAZDATKOM Char( 50 ),
      CUSER Char( 10 ),
      CCALLFORM Char( 50 ),
      CIDDATKOM Char( 10 ),
      CIDFILTERS Char( 10 ),
      MDATCOM Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'komusers',
   'komusers.adi',
   'KOMUSERS01',
   'UPPER(CUSER)+UPPER(CCALLFORM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'komusers',
   'komusers.adi',
   'KOMUSERS02',
   'UPPER(CNAZDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'komusers',
   'komusers.adi',
   'KOMUSERS03',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'komusers',
   'komusers.adi',
   'KOMUSERS04',
   'UPPER(CIDDATKOM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'komusers',
   'komusers.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'komusers', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'komusersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'komusers', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'komusersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'komusers', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'komusersfail');

CREATE TABLE kurzhd ( 
      DDATPLATN Date,
      NDENKURZ Short,
      NTYDKURZ Short,
      NMESKURZ Short,
      NKVAKURZ Short,
      NPOLKURZ Short,
      NROKKURZ Short,
      CMESKURZ Char( 12 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzhd',
   'kurzhd.adi',
   'KURZHD1',
   'DTOS ( DDATPLATN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzhd',
   'kurzhd.adi',
   'KURZHD2',
   'STRZERO(NDENKURZ,2) +UPPER(CMESKURZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzhd',
   'kurzhd.adi',
   'KURZHD3',
   'UPPER(CMESKURZ) +STRZERO(NDENKURZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzhd',
   'kurzhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kurzhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kurzhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kurzhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kurzhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kurzhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kurzhdfail');

CREATE TABLE kurzit ( 
      DDATPLATN Date,
      NDENKURZ Short,
      NTYDKURZ Short,
      NMESKURZ Short,
      NKVAKURZ Short,
      NPOLKURZ Short,
      NROKKURZ Short,
      CMESKURZ Char( 12 ),
      CZKRATMENY Char( 3 ),
      NMNOZPREP Integer,
      NKURZSTRED Double( 8 ),
      NKURZNAKUP Double( 8 ),
      NKURZPRODE Double( 8 ),
      NINTCOUNT Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT1',
   'DTOS (DDATPLATN) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT2',
   'UPPER(CZKRATMENY) +DTOS (DDATPLATN) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT3',
   'UPPER(CZKRATMENY) +STRZERO(NDENKURZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT4',
   'UPPER(CZKRATMENY) +STRZERO(NTYDKURZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT5',
   'UPPER(CZKRATMENY) +STRZERO(NMESKURZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT6',
   'UPPER(CZKRATMENY) +STRZERO(NKVAKURZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT7',
   'UPPER(CZKRATMENY) +STRZERO(NPOLKURZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'KURZIT8',
   'UPPER(CZKRATMENY) +STRZERO(NROKKURZ,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kurzit',
   'kurzit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kurzit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kurzitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kurzit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kurzitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kurzit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kurzitfail');

CREATE TABLE kusov ( 
      CSUBJE Char( 2 ),
      CCISZAKAZ Char( 30 ),
      CVYSPOL Char( 15 ),
      CNIZPOL Char( 15 ),
      NNIZVAR Short,
      CSKLPOL Char( 15 ),
      NPOZICE Short,
      NVARPOZ Short,
      DPLAOD Date,
      DPLADO Date,
      NCIMNO Double( 6 ),
      NSPMNO Double( 6 ),
      CZKRATJEDN Char( 3 ),
      CMJTPV Char( 3 ),
      CMJSPO Char( 3 ),
      CKODPOZ Char( 3 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      NROZMA Double( 3 ),
      NROZMB Double( 3 ),
      NKUSROZ Double( 3 ),
      NKUSPOD Integer,
      NNAVYSPRC Double( 2 ),
      CSTAV Char( 1 ),
      DZAPIS Date,
      CZAPIS Char( 8 ),
      DZMENAT Date,
      CZMENAT Char( 8 ),
      DZMENAK Date,
      CZMENAK Char( 8 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CTEXT1 Char( 50 ),
      CTEXT2 Char( 50 ),
      NMNZADVAVP Double( 2 ),
      MKUSOV Memo,
      NPRIDUP Short,
      NHRHM Double( 4 ),
      NCIHM Double( 4 ),
      CINDEXPOZ Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV1',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NPOZICE,3) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV2',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL) +STRZERO(NNIZVAR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV4',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV5',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV6',
   'UPPER(CNIZPOL) +UPPER(CVYSPOL) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV7',
   'UPPER(CSKLPOL) +UPPER(CVYSPOL) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV8',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3) +STRZERO(NCISOPER,4) +STRZERO(NPOZICE,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'KUSOV9',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kusov',
   'kusov.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kusov', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kusovfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kusov', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kusovfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kusov', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kusovfail');

CREATE TABLE kustree ( 
      CTREETEXT Char( 70 ),
      CTYPPOL Char( 3 ),
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CVARPOP Char( 20 ),
      CSKLPOL Char( 15 ),
      LNAKPOL Logical,
      CNAZEV Char( 30 ),
      CZKRATJEDN Char( 3 ),
      CMJTPV Char( 3 ),
      CMJSPO Char( 3 ),
      CVYSPOL Char( 15 ),
      NVYSVAR Short,
      CVYSVARPOP Char( 20 ),
      CNAZEVVYS Char( 30 ),
      NVYRST Short,
      NPOZICE Short,
      NVARPOZ Short,
      CSUBJE Char( 2 ),
      CSTAV Char( 1 ),
      CTREEKEY Char( 25 ),
      LROZPAD Logical,
      NERRKOD Short,
      CERRTXT Char( 40 ),
      NSPMNO Double( 6 ),
      NSPMNONAS Double( 6 ),
      NCIMNO Double( 6 ),
      NCIMNONAS Double( 6 ),
      CZKRATMENY Char( 3 ),
      NCENACELK Double( 2 ),
      NCENACELK2 Double( 2 ),
      NCENACELK3 Double( 2 ),
      NCENACELK4 Double( 2 ),
      NCENACELK5 Double( 2 ),
      CTYPMAT Char( 3 ),
      NPRIPRCAS Double( 3 ),
      NPRIPRKC Double( 2 ),
      NKUSOVCAS Double( 4 ),
      NKUSOVKC Double( 2 ),
      LZAPUSTIT Logical,
      NKUSYPAS Short,
      NSTRIZPL Short,
      NMNZADVA Double( 4 ),
      NMNZADVAVP Double( 4 ),
      CSTRED Char( 8 ),
      CTYPSTR Char( 10 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      NKOEFPREP Double( 6 ),
      CCISSKLAD Char( 8 ),
      NEKDAV Double( 2 ),
      NUCETSKUP Short,
      LZAPUSTENO Logical,
      CFINPOL Char( 15 ),
      CNAZEVFIN Char( 30 ),
      NZBOZIKAT Short,
      NVYRREZIE Double( 2 ),
      CKODPOZ Char( 3 ),
      NVAHA Double( 6 ),
      NPLOCHA Double( 6 ),
      NVAHAFIN Double( 6 ),
      NPLOCHAFIN Double( 6 ),
      NKUSROZ Double( 3 ),
      CTEXT1 Char( 50 ),
      CTEXT2 Char( 50 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'TREE1',
   'CTREEKEY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'TREE2',
   'IF (LNAKPOL, ''1'', ''0'') +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'TREE3',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVYSVAR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'TREE4',
   'CTREEKEY +UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'TREE5',
   'CTREEKEY +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'TREE6',
   'UPPER(CVYRPOL) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'TREE7',
   'UPPER(CSKLPOL) + CTREEKEY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustree',
   'kustree.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kustree', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kustreefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kustree', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kustreefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kustree', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kustreefail');

CREATE TABLE kustreem ( 
      COZNOPER Char( 10 ),
      CTYPPOL Char( 3 ),
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CVARPOP Char( 20 ),
      CSKLPOL Char( 15 ),
      LNAKPOL Logical,
      CNAZEV Char( 30 ),
      CZKRATJEDN Char( 3 ),
      CVYSPOL Char( 15 ),
      NVYSVAR Short,
      CVYSVARPOP Char( 20 ),
      CNAZEVVYS Char( 30 ),
      NVYRST Short,
      NPOZICE Short,
      NVARPOZ Short,
      CSUBJE Char( 2 ),
      CSTAV Char( 1 ),
      CTREEKEY Char( 25 ),
      LROZPAD Logical,
      NERRKOD Short,
      CERRTXT Char( 40 ),
      NSPMNO Double( 6 ),
      NSPMNONAS Double( 6 ),
      NCIMNONAS Double( 6 ),
      CZKRATMENY Char( 3 ),
      NCENACELK Double( 2 ),
      NCENACELK2 Double( 2 ),
      NCENACELK3 Double( 2 ),
      NCENACELK4 Double( 2 ),
      NCENACELK5 Double( 2 ),
      CTYPMAT Char( 3 ),
      NPRIPRCAS Double( 3 ),
      NPRIPRKC Double( 2 ),
      NKUSOVCAS Double( 4 ),
      NKUSOVKC Double( 2 ),
      LZAPUSTIT Logical,
      NKUSYPAS Short,
      NSTRIZPL Short,
      NMNZADVA Double( 4 ),
      NMNZADVAVP Double( 4 ),
      CSTRED Char( 8 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      CCISSKLAD Char( 8 ),
      NEKDAV Double( 2 ),
      NUCETSKUP Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'kustreem',
   'kustreem.adi',
   'TREEM1',
   'CTREEKEY +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'kustreem',
   'kustreem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'kustreem', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'kustreemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kustreem', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'kustreemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'kustreem', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'kustreemfail');

CREATE TABLE lekprohl ( 
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CRODCISPRA Char( 13 ),
      CPRACOVNIK Char( 43 ),
      NPORADI Short,
      CZKRATKA Char( 8 ),
      NPERIOOPAK Integer,
      CZKRATJEDN Char( 3 ),
      DPOSLLEKPR Date,
      DDALSLEKPR Date,
      CZKRATLEKA Char( 8 ),
      CNAZEVLEKA Char( 30 ),
      CODBORNLEK Char( 30 ),
      CULICE Char( 25 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NCISFIRMY Integer,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_02',
   'UPPER(CRODCISPRA) +STRZERO(NPORADI,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_03',
   'UPPER(CRODCISPRA) +UPPER(CZKRATKA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_05',
   'UPPER(CRODCISPRA) +DTOS (DDALSLEKPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'lekprohl',
   'lekprohl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'lekprohl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'lekprohlfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'lekprohl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'lekprohlfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'lekprohl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'lekprohlfail');

CREATE TABLE licasys ( 
      CNAZFIRMY Char( 100 ),
      CNAZFIRPRI Char( 30 ),
      CZKRNAZEV Char( 10 ),
      CULICE Char( 30 ),
      CCISPOPIS Char( 15 ),
      CPSC Char( 6 ),
      CMISTO Char( 50 ),
      CZKRSTAT Char( 3 ),
      CICO Char( 15 ),
      CDIC Char( 20 ),
      NIDUZIVSW Integer,
      NUSRIDDB Integer,
      CLICENCE Char( 25 ),
      DPLATLICOD Date,
      DPLATLICDO Date,
      CDATADIR Char( 25 ),
      NCISFIRMY Integer,
      NSYSLOCK Short,
      NSYCHECKDB Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_ModifyTableProperty( 'licasys', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'licasysfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'licasys', 
   'Table_Encryption', 
   'True', 'APPEND_FAIL', 'licasysfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'licasys', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'licasysfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'licasys', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'licasysfail');

CREATE TABLE licence ( 
      CNAZFIRMY Char( 100 ),
      CNAZFIRPRI Char( 30 ),
      CZKRNAZEV Char( 10 ),
      CULICE Char( 30 ),
      CCISPOPIS Char( 15 ),
      CPSC Char( 6 ),
      CMISTO Char( 50 ),
      CZKRSTAT Char( 3 ),
      CICO Char( 15 ),
      CDIC Char( 20 ),
      NIDUZIVSW Integer,
      NUSRIDDB Integer,
      CLICENCE Char( 25 ),
      DPLATLICOD Date,
      DPLATLICDO Date,
      CDATADIR Char( 25 ),
      NCISFIRMY Integer,
      NSYSLOCK Short,
      NSYCHECKDB Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'licence',
   'licence.adi',
   'LICENCE01',
   'NIDUZIVSW',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'licence',
   'licence.adi',
   'LICENCE02',
   'NUSRIDDB',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'licence',
   'licence.adi',
   'LICENCE03',
   'UPPER(CNAZFIRMY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'licence',
   'licence.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'licence', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'licencefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'licence', 
   'Table_Encryption', 
   'True', 'APPEND_FAIL', 'licencefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'licence', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'licencefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'licence', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'licencefail');

CREATE TABLE list_dav ( 
      NDOKLAD Double( 0 ),
      NDAVKA Double( 0 ),
      DDATPORDAV Date,
      NOSCISPRAC Integer,
      NTARSAZHOD Double( 3 ),
      CSTRED Char( 8 ),
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'list_dav',
   'list_dav.adi',
   'LISTDAV_01',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'list_dav',
   'list_dav.adi',
   'LISTDAV_02',
   'STRZERO( NOSCISPRAC, 5) + STRZERO( NDOKLAD, 10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'list_dav',
   'list_dav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'list_dav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'list_davfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'list_dav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'list_davfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'list_dav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'list_davfail');

CREATE TABLE listhd ( 
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CNAZEV Char( 30 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      MTEXTOPER Memo,
      CTYPOPER Char( 3 ),
      CNAZOPER Char( 30 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      CKVALNORM Char( 2 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      DVYHOTPLAN Date,
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      CMATERPOZA Char( 2 ),
      CZAPKAPAC Char( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NCISLOKUSU Integer,
      NPORADI Short,
      NPOCCEZAPZ Short,
      CULOHA Char( 1 ),
      LUZV Logical,
      CVYROBCISL Char( 40 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD8',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd',
   'listhd.adi',
   'LISTHD9',
   'UPPER(CCISZAKAZI) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listhdfail');

CREATE TABLE listhd2 ( 
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CNAZEV Char( 30 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      MTEXTOPER Memo,
      CTYPOPER Char( 3 ),
      CNAZOPER Char( 30 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      CKVALNORM Char( 2 ),
      NKUSOVCAS Double( 3 ),
      NPRIPRCAS Double( 2 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      DVYHOTPLAN Date,
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      CMATERPOZA Char( 2 ),
      CZAPKAPAC Char( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NCISLOKUSU Integer,
      NPORADI Short,
      NPOCCEZAPZ Short,
      CULOHA Char( 1 ),
      LUZV Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd2',
   'listhd2.adi',
   'LISTHD8',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd2', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listhd2fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd2', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listhd2fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd2', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listhd2fail');

CREATE TABLE listhd_1 ( 
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CNAZEV Char( 30 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      MTEXTOPER Memo,
      CTYPOPER Char( 3 ),
      CNAZOPER Char( 30 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      CKVALNORM Char( 2 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      DVYHOTPLAN Date,
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      CMATERPOZA Char( 2 ),
      CZAPKAPAC Char( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NCISLOKUSU Integer,
      NPORADI Short,
      NPOCCEZAPZ Short,
      CULOHA Char( 1 ),
      LUZV Logical,
      CTEXTOPER Char( 80 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD8',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd_1', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listhd_1fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd_1', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listhd_1fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhd_1', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listhd_1fail');

CREATE TABLE listhdnv ( 
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CNAZEV Char( 30 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      MTEXTOPER Memo,
      CTYPOPER Char( 3 ),
      CNAZOPER Char( 30 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      CKVALNORM Char( 2 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      DVYHOTPLAN Date,
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      CMATERPOZA Char( 2 ),
      CZAPKAPAC Char( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NCISLOKUSU Integer,
      NPORADI Short,
      NPOCCEZAPZ Short,
      CULOHA Char( 1 ),
      LUZV Logical,
      CTEXTOPER Char( 80 ),
      NMATERNV Double( 2 ),
      NMZDYNV Double( 2 ),
      NKOOPERNV Double( 2 ),
      NMNOZNV Double( 2 ),
      DDATUMNV Date,
      NMATERNVMJ Double( 4 ),
      NMZDYNVMJ Double( 4 ),
      NKOONVMJ Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listhdnv',
   'listhdnv.adi',
   'LISTHD1',
   'DTOS (DDATUMNV) +UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhdnv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listhdnvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhdnv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listhdnvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listhdnv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listhdnvfail');

CREATE TABLE listit ( 
      NPORCISLIS Double( 0 ),
      NROKVYTVOR Short,
      CTYPLISTKU Char( 3 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      COZNOPER Char( 10 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      NDRUHMZDY Short,
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      NKCOPEPREM Double( 2 ),
      NMZDAZAKUS Double( 4 ),
      CSMENA Char( 4 ),
      DDATMOZNY Date,
      DDATNUTNY Date,
      DVYHOTPLAN Date,
      DVYHOTSKUT Date,
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NOSCISPRAC Integer,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      DKONTROLA Date,
      NKDOKONTRO Integer,
      NKUSYKONTR Double( 3 ),
      NKUSYVADNE Double( 3 ),
      CSTAVLISTK Char( 2 ),
      CDRUHLISTK Char( 2 ),
      NTYDKAPBLO Short,
      CSKLPOL Char( 15 ),
      CKODPRIPL Char( 2 ),
      NKCOPEPRIP Double( 2 ),
      NCISLOKUSU Integer,
      DPRENOS Date,
      CPRENOS Char( 8 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      MTEXTML Memo,
      CULOHA Char( 1 ),
      NORDITEM Integer,
      NTARSAZHOD Double( 3 ),
      NDAVKA Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT2',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT3',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTPLAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT4',
   'UPPER(CPRIJPRAC) +UPPER(CJMENOPRAC) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT5',
   'DTOS (DVYHOTPLAN) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT6',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT7',
   'UPPER(COBDOBI) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT8',
   'UPPER(CCISZAKAZ) +UPPER(CNAZPOL1) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTIT9',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTSKUT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTI10',
   'STRZERO(NOSCISPRAC,5) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTI11',
   'UPPER(COBDOBI) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTI12',
   'DTOS ( DVYHOTSKUT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTI13',
   'UPPER(CVYRPOL) +STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'LISTI14',
   'NDAVKA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit',
   'listit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listitfail');

CREATE TABLE listit2 ( 
      NPORCISLIS Double( 0 ),
      NROKVYTVOR Short,
      CTYPLISTKU Char( 3 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      COZNOPER Char( 10 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      NDRUHMZDY Short,
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      NKCOPEPREM Double( 2 ),
      NMZDAZAKUS Double( 4 ),
      CSMENA Char( 4 ),
      DDATMOZNY Date,
      DDATNUTNY Date,
      DVYHOTPLAN Date,
      DVYHOTSKUT Date,
      COBDOBI Char( 5 ),
      NOSCISPRAC Integer,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      DKONTROLA Date,
      NKDOKONTRO Integer,
      NKUSYKONTR Double( 3 ),
      NKUSYVADNE Double( 3 ),
      CSTAVLISTK Char( 2 ),
      CDRUHLISTK Char( 2 ),
      NTYDKAPBLO Short,
      CSKLPOL Char( 15 ),
      CKODPRIPL Char( 2 ),
      NKCOPEPRIP Double( 2 ),
      NCISLOKUSU Integer,
      DPRENOS Date,
      CPRENOS Char( 8 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      MTEXTML Memo,
      CULOHA Char( 1 ),
      NORDITEM Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT2',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT3',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTPLAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT4',
   'UPPER(CPRIJPRAC) +UPPER(CJMENOPRAC) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT5',
   'DTOS (DVYHOTPLAN) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT6',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT7',
   'UPPER(COBDOBI) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT8',
   'UPPER(CCISZAKAZ) +UPPER(CNAZPOL1) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTIT9',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTSKUT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTI10',
   'STRZERO(NOSCISPRAC,5) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTI11',
   'UPPER(COBDOBI) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listit2',
   'listit2.adi',
   'LISTI12',
   'DTOS ( DVYHOTSKUT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit2', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listit2fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit2', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listit2fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit2', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listit2fail');

CREATE TABLE listit_1 ( 
      NPORCISLIS Double( 0 ),
      NROKVYTVOR Short,
      CTYPLISTKU Char( 3 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      COZNOPER Char( 10 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      NDRUHMZDY Short,
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      NKCOPEPREM Double( 2 ),
      NMZDAZAKUS Double( 4 ),
      CSMENA Char( 4 ),
      DDATMOZNY Date,
      DDATNUTNY Date,
      DVYHOTPLAN Date,
      DVYHOTSKUT Date,
      COBDOBI Char( 5 ),
      NOSCISPRAC Integer,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      DKONTROLA Date,
      NKDOKONTRO Integer,
      NKUSYKONTR Double( 3 ),
      NKUSYVADNE Double( 3 ),
      CSTAVLISTK Char( 2 ),
      CDRUHLISTK Char( 2 ),
      NTYDKAPBLO Short,
      CSKLPOL Char( 15 ),
      CKODPRIPL Char( 2 ),
      NKCOPEPRIP Double( 2 ),
      NCISLOKUSU Integer,
      DPRENOS Date,
      CPRENOS Char( 8 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      MTEXTML Memo,
      DDATOD Date,
      DDATDO Date,
      NPLNENINOR Double( 3 ),
      NHODPRUMER Double( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listit_1',
   'listit_1.adi',
   'LISTIT1',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit_1', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listit_1fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit_1', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listit_1fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listit_1', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listit_1fail');

CREATE TABLE listkap ( 
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CNAZEV Char( 30 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      MTEXTOPER Memo,
      CTYPOPER Char( 3 ),
      CNAZOPER Char( 25 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      CKVALNORM Char( 2 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      DVYHOTPLAN Date,
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      CMATERPOZA Char( 2 ),
      CZAPKAPAC Char( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NCISLOKUSU Integer,
      NTYDKAPBLO Short,
      DDATPLAN Date,
      CTEXT1 Char( 30 ),
      CTEXT2 Char( 30 ),
      CTEXT3 Char( 30 ),
      CFINPOL Char( 15 ),
      NFINVAR Short,
      CCISPLAN Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'listkap',
   'listkap.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listkap',
   'listkap.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listkap',
   'listkap.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listkap',
   'listkap.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listkap',
   'listkap.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listkap',
   'listkap.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'listkap',
   'listkap.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'listkap', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'listkapfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listkap', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'listkapfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'listkap', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'listkapfail');

CREATE TABLE m_dav ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NEXTFAKTUR Short,
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NDRUHMZDY Short,
      NPREMIE Short,
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NSAZBADOKL Double( 2 ),
      NHRUBAMZD Double( 2 ),
      NMZDA Double( 2 ),
      NZAKLSOCPO Double( 2 ),
      NZAKLZDRPO Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NDNYDOVOL Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NSAZBAVNU1 Double( 2 ),
      NMNOZSVNU1 Double( 2 ),
      NSAZBAVNU2 Double( 2 ),
      NMNOZSVNU2 Double( 2 ),
      NPORADI Integer,
      DDATUMOD Date,
      DDATUMDO Date,
      NZDRPOJIS Short,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      NTMPNUM1 Double( 2 ),
      NTMPNUM2 Double( 2 ),
      NTMPNUM3 Double( 4 ),
      NTMPNUM4 Double( 4 ),
      LRUCPORIZ Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV9',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV11',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +IF (LRUCPORIZ, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'M_DAV13',
   'STRZERO(NROK,4) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav',
   'm_dav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_dav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_davfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_dav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_davfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_dav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_davfail');

CREATE TABLE m_dav10 ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      JM Char( 20 ),
      FAKTURACE Short,
      PROFESE Short,
      NPORPRAVZT Short,
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MJ Short,
      C_PRACE Short,
      PHM Short,
      ZN Short,
      DNY Double( 1 ),
      NDRUHMZDY Short,
      SAZBA Double( 2 ),
      HODINY Double( 2 ),
      MNOZ_PRACE Double( 2 ),
      NPREMIE Short,
      HRUBA_MZDA Double( 2 ),
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NSAZBADOKL Double( 2 ),
      NHRUBAMZD Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NSAZBAVNU1 Double( 2 ),
      NMNOZSVNU1 Double( 2 ),
      NSAZBAVNU2 Double( 2 ),
      NMNOZSVNU2 Double( 2 ),
      NPORADI Integer,
      DDATUMOD Date,
      DDATUMDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_dav10', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_dav10fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_dav10', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_dav10fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_dav10', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_dav10fail');

CREATE TABLE m_davhd ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NEXTFAKTUR Short,
      NHRUBAMZD Double( 2 ),
      NMZDA Double( 2 ),
      NZAKLSOCPO Double( 2 ),
      NZAKLZDRPO Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NDNYDOVOL Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      NZDRPOJIS Short,
      CTMKMSTRPR Char( 8 ),
      LRUCPORIZ Logical,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +IF (LRUCPORIZ, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davhd',
   'm_davhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_davhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_davhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_davhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_davhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_davhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_davhdfail');

CREATE TABLE m_daviso ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NDOKLAD Integer,
      NORDITEM Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      JM Char( 20 ),
      FAKTURACE Short,
      PROFESE Short,
      NPORPRAVZT Short,
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 15 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MJ Short,
      C_PRACE Short,
      PHM Short,
      ZN Short,
      DNY Double( 1 ),
      NDRUHMZDY Short,
      SAZBA Double( 2 ),
      HODINY Double( 2 ),
      MNOZ_PRACE Double( 2 ),
      NPREMIE Short,
      HRUBA_MZDA Double( 2 ),
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NSAZBADOKL Double( 2 ),
      NHRUBAMZD Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NSAZBAVNU1 Double( 2 ),
      NMNOZSVNU1 Double( 2 ),
      NSAZBAVNU2 Double( 2 ),
      NMNOZSVNU2 Double( 2 ),
      NPORADI Integer,
      DDATUMOD Date,
      DDATUMDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_daviso', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_davisofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_daviso', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_davisofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_daviso', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_davisofail');

CREATE TABLE m_davit ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NEXTFAKTUR Short,
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NDRUHMZDY Short,
      NPREMIE Short,
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NSAZBADOKL Double( 2 ),
      NHRUBAMZD Double( 2 ),
      NMZDA Double( 2 ),
      NZAKLSOCPO Double( 2 ),
      NZAKLZDRPO Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NDNYDOVOL Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NSAZBAVNU1 Double( 2 ),
      NMNOZSVNU1 Double( 2 ),
      NSAZBAVNU2 Double( 2 ),
      NMNOZSVNU2 Double( 2 ),
      NPORADI Integer,
      DDATUMOD Date,
      DDATUMDO Date,
      NZDRPOJIS Short,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      NTMPNUM1 Double( 2 ),
      NTMPNUM2 Double( 2 ),
      NTMPNUM3 Double( 4 ),
      NTMPNUM4 Double( 4 ),
      LRUCPORIZ Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT11',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +IF (LRUCPORIZ, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT13',
   'STRZERO(NROK,4) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_davit',
   'm_davit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_davit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_davitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_davit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_davitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_davit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_davitfail');

CREATE TABLE m_nem ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NPORADI Integer,
      NDOKLAD Integer,
      NORDITEM Integer,
      DDATPORIZ Date,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      NDRUHMZDY Short,
      DVYKAZN_OD Date,
      DVYKAZN_DO Date,
      NVYKAZN_HO Double( 2 ),
      NVYKAZN_KD Double( 2 ),
      NVYKAZN_PD Double( 2 ),
      NVYKAZN_VD Double( 2 ),
      NNEMOCCELK Integer,
      DPROPLNSOD Date,
      DPROPLNSDO Date,
      NPROPLNSHO Double( 2 ),
      NPROPLNSKD Double( 2 ),
      NPROPLNSPD Double( 2 ),
      NPROPLNSVD Double( 2 ),
      NSAZDENNIN Short,
      NNEMOCNISA Integer,
      NDMZNENISA Short,
      DPROPLVKOD Date,
      DPROPLVKDO Date,
      NPROPLVKKD Double( 2 ),
      NPROPLVKPD Double( 2 ),
      NPROPLVKVD Double( 2 ),
      NSAZDENVKN Short,
      NNEMOCVKSA Integer,
      NDMZNEVKSA Short,
      DPROPLVSOD Date,
      DPROPLVSDO Date,
      NPROPLVSKD Double( 2 ),
      NPROPLVSPD Double( 2 ),
      NPROPLVSVD Double( 2 ),
      NSAZDENVYN Short,
      NNEMOCVYSA Integer,
      NDMZNEVYSA Short,
      NHODFONDPD Double( 2 ),
      NDVZNEMOC Double( 2 ),
      NDNYNIZSAZ Short,
      NDNYKRASAZ Short,
      LNOVYPRIP Logical,
      NNOVYPRIP Short,
      LRUCPORIZ Logical,
      CTMKMSTRPR Char( 8 ),
      NTMPORSORT Integer,
      NTMOBDSORT Integer,
      NDNYVYLOCD Integer,
      NDNYVYLDOD Integer,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM2',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM3',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM5',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM6',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM7',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM8',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NTMOBDSORT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'M_NEM9',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)+STRZERO(NPORADI,6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nem',
   'm_nem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nem', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_nemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nem', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_nemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nem', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_nemfail');

CREATE TABLE m_nemhd ( 
      CULOHA Char( 1 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NPORADI Integer,
      DDATPORIZ Date,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      DDATUMOD Date,
      DDATUMDO Date,
      NVYKAZN_HO Double( 2 ),
      NVYKAZN_KD Double( 2 ),
      NVYKAZN_PD Double( 2 ),
      NVYKAZN_VD Double( 2 ),
      NNEMOCCELK Integer,
      CSTAVOTEVN Char( 1 ),
      NDVZNEMOC Double( 2 ),
      NDNYNIZSAZ Short,
      NDNYKRASAZ Short,
      NDENVZHRUN Double( 2 ),
      NDENVZCISN Double( 2 ),
      NDENVZCIKN Double( 2 ),
      NSAZDENNIN Short,
      NSAZDENVYN Short,
      NSAZDENVKN Short,
      CTMKMSTRPR Char( 8 ),
      NTMPORSORT Integer,
      NTMROKZPRA Short,
      NDNYVYLOCD Integer,
      NDNYVYLDOD Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD02',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD04',
   'STRZERO(NTMROKZPRA,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemhd',
   'm_nemhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_nemhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_nemhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_nemhdfail');

CREATE TABLE m_nemit ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NPORADI Integer,
      NDOKLAD Integer,
      NORDITEM Integer,
      DDATPORIZ Date,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      NDRUHMZDY Short,
      DVYKAZN_OD Date,
      DVYKAZN_DO Date,
      NVYKAZN_HO Double( 2 ),
      NVYKAZN_KD Double( 2 ),
      NVYKAZN_PD Double( 2 ),
      NVYKAZN_VD Double( 2 ),
      NNEMOCCELK Integer,
      DPROPLNSOD Date,
      DPROPLNSDO Date,
      NPROPLNSHO Double( 2 ),
      NPROPLNSKD Double( 2 ),
      NPROPLNSPD Double( 2 ),
      NPROPLNSVD Double( 2 ),
      NSAZDENNIN Short,
      NNEMOCNISA Integer,
      NDMZNENISA Short,
      DPROPLVKOD Date,
      DPROPLVKDO Date,
      NPROPLVKKD Double( 2 ),
      NPROPLVKPD Double( 2 ),
      NPROPLVKVD Double( 2 ),
      NSAZDENVKN Short,
      NNEMOCVKSA Integer,
      NDMZNEVKSA Short,
      DPROPLVSOD Date,
      DPROPLVSDO Date,
      NPROPLVSKD Double( 2 ),
      NPROPLVSPD Double( 2 ),
      NPROPLVSVD Double( 2 ),
      NSAZDENVYN Short,
      NNEMOCVYSA Integer,
      NDMZNEVYSA Short,
      NHODFONDPD Double( 2 ),
      NDVZNEMOC Double( 2 ),
      NDNYNIZSAZ Short,
      NDNYKRASAZ Short,
      LNOVYPRIP Logical,
      NNOVYPRIP Short,
      LRUCPORIZ Logical,
      CTMKMSTRPR Char( 8 ),
      NTMPORSORT Integer,
      NTMOBDSORT Integer,
      NDNYVYLOCD Integer,
      NDNYVYLDOD Integer,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT03',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT05',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT07',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT08',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NTMOBDSORT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT09',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)+STRZERO(NPORADI,6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemit',
   'm_nemit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_nemitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_nemitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_nemitfail');

CREATE TABLE m_nemoc ( 
      CULOHA Char( 1 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NPORADI Integer,
      DDATPORIZ Date,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      DDATUMOD Date,
      DDATUMDO Date,
      NVYKAZN_HO Double( 2 ),
      NVYKAZN_KD Double( 2 ),
      NVYKAZN_PD Double( 2 ),
      NVYKAZN_VD Double( 2 ),
      NNEMOCCELK Integer,
      CSTAVOTEVN Char( 1 ),
      NDVZNEMOC Double( 2 ),
      NDNYNIZSAZ Short,
      NDNYKRASAZ Short,
      NDENVZHRUN Double( 2 ),
      NDENVZCISN Double( 2 ),
      NDENVZCIKN Double( 2 ),
      NSAZDENNIN Short,
      NSAZDENVYN Short,
      NSAZDENVKN Short,
      CTMKMSTRPR Char( 8 ),
      NTMPORSORT Integer,
      NTMROKZPRA Short,
      NDNYVYLOCD Integer,
      NDNYVYLDOD Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC2',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC3',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC4',
   'STRZERO(NTMROKZPRA,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_nemoc',
   'm_nemoc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemoc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_nemocfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemoc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_nemocfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_nemoc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_nemocfail');

CREATE TABLE m_srz ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DDATPORIZ Date,
      CPRACOVNIK Char( 30 ),
      NOSCISPRAC Integer,
      CNAZPOL1 Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      NPORADI Integer,
      NPORUPLSRZ Short,
      CZKRSRAZKY Char( 8 ),
      LPREDNPOHL Logical,
      NPREDNPOHL Short,
      CTYPSRZ Char( 4 ),
      NTYPSRZ Short,
      CPOPSRAZKY Char( 30 ),
      NTYPCASTKA Short,
      NSPLATKA Double( 2 ),
      NMZDA Double( 2 ),
      NSRAZKMZD Double( 2 ),
      NCELKEM Double( 2 ),
      NSPLACENO Double( 2 ),
      NZUSTATEK Double( 2 ),
      NNEDOPLAT Double( 2 ),
      DDATDORVYK Date,
      DDATZUSTAT Date,
      DDATODSPL Date,
      DDATDOSPL Date,
      CUCETI Char( 20 ),
      CUCET Char( 25 ),
      CKODBANKY Char( 4 ),
      CVARSYM Char( 15 ),
      CSPECSYMB Char( 20 ),
      NKONSTSYMB Short,
      CBANK_UCT Char( 25 ),
      CBANK_UCTI Char( 20 ),
      CBANK_KOD Char( 4 ),
      CTYPABO Char( 6 ),
      CZPUSSRAZ Char( 6 ),
      CZKRTYPZAV Char( 5 ),
      NDRUHMZDY Short,
      NDRUHMZDY2 Short,
      NDRUHMZDY3 Short,
      CUCET_UCT Char( 6 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      NTMPORSORT Integer,
      NTMOBDSORT Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_srz',
   'm_srz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_srz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_srzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_srz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_srzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_srz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_srzfail');

CREATE TABLE m_tmp ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NDOKLAD Integer,
      NORDITEM Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NEXTFAKTUR Short,
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZKRATJEDN Char( 3 ),
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NDRUHMZDY Short,
      NSAZBADOKL Double( 2 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NPREMIE Short,
      NHRUBAMZD Double( 2 ),
      NMZDA Double( 2 ),
      CMSM_ORG Char( 29 ),
      CMSM_NEW Char( 29 ),
      CMSM_NAZR Char( 12 ),
      NKEYMATR Short,
      LULOZDATA Logical,
      CNAZMATR Char( 20 ),
      LNEWRADPRE Logical,
      LRADMATR Logical,
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NDNYDOVOL Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      NZDRPOJIS Short,
      CTMKMSTRPR Char( 8 ),
      LRUCPORIZ Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_tmp',
   'm_tmp.adi',
   'M_TMP1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_tmp',
   'm_tmp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_tmp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_tmpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_tmp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_tmpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_tmp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_tmpfail');

CREATE TABLE m_zmdav ( 
      NRECZM Integer,
      LNEWREC Logical,
      NFILZM Short,
      NFILOLD Double( 2 ),
      NFILNEW Double( 2 ),
      CFILOLD Char( 50 ),
      CFILNEW Char( 50 ),
      DFILOLD Date,
      DFILNEW Date,
      CTYPFIL Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'm_zmdav',
   'm_zmdav.adi',
   'ZMTMP_01',
   'STRZERO(NRECZM,6) +STRZERO(NFILZM,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'm_zmdav',
   'm_zmdav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_zmdav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'm_zmdavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_zmdav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'm_zmdavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'm_zmdav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'm_zmdavfail');

CREATE TABLE maj ( 
      NINVCIS Double( 0 ),
      NTYPMAJ Short,
      CTYPSKP Char( 15 ),
      NODPISK Short,
      NTYPDODPI Short,
      NTYPUODPI Short,
      NROKYODPIU Short,
      CNAZEV Char( 30 ),
      NTROBOR Integer,
      NZNAKT Short,
      NDOKLAD Double( 0 ),
      NDRPOHYB Integer,
      DDATPOR Date,
      DDATZAR Date,
      COBDZAR Char( 5 ),
      DDATVYRAZ Date,
      COBDVYRAZ Char( 5 ),
      DDATZVYS Date,
      COBDZVYS Char( 5 ),
      NROKYDANOD Short,
      NROKZVDANO Short,
      NKUSY Short,
      NMNOZSTVI Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCENAVSTU Double( 2 ),
      NCENAVSTD Double( 2 ),
      NOPRUCT Double( 2 ),
      NOPRDAN Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NOPRDANPS Double( 2 ),
      NPROCDANOD Double( 2 ),
      NDANODPROK Double( 2 ),
      NPROCUCTOD Double( 2 ),
      NUCTODPROK Double( 2 ),
      NUCTODPMES Double( 2 ),
      NPOCMESODP Short,
      NUPLPROC Double( 2 ),
      NUPLHODN Double( 2 ),
      NROKUPL Short,
      CKLICODMIS Char( 8 ),
      CKLICSKMIS Char( 8 ),
      CVYRCISIM Char( 25 ),
      DDATREVIM Date,
      COBDPOSODP Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MPOPIS Memo,
      CKODKLAS Char( 9 ),
      CCELEK Char( 15 ),
      CVYKRES Char( 20 ),
      CUMISTENI Char( 25 ),
      CODPISK Char( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ01',
   'STRZERO( NTYPMAJ,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ02',
   'NINVCIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ03',
   'UPPER( CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ04',
   'UPPER( CTYPSKP) + STRZERO( NTYPMAJ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ05',
   'STRZERO( NODPISK,1) + STRZERO( NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ06',
   'STRZERO( NODPISK,1) + STRZERO( NTYPMAJ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ07',
   'STRZERO( NODPISK,1) + UPPER( CTYPSKP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ08',
   'UPPER( CTYPSKP) + STRZERO( NODPISK,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ09',
   'NTYPUODPI',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ10',
   'NROKYODPIU',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ11',
   'UPPER( CNAZPOL5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'MAJ12',
   'UPPER( CCELEK) +UPPER( CVYKRES)+ UPPER( CUMISTENI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj',
   'maj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'maj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'maj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'maj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majfail');

CREATE TABLE maj_ps ( 
      NINVCIS Double( 0 ),
      NTYPMAJ Short,
      NROK Short,
      NVSCENDPS Double( 2 ),
      NVSCENUPS Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NZUCENUPS Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'maj_ps',
   'maj_ps.adi',
   'MAJ_PS_01',
   'STRZERO(NTYPMAJ,3) + STRZERO(NINVCIS,10) + STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj_ps',
   'maj_ps.adi',
   'MAJ_PS_02',
   'STRZERO(NROK,4) + STRZERO(NTYPMAJ,3) + STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'maj_ps',
   'maj_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'maj_ps', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'maj_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'maj_ps', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'maj_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'maj_ps', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'maj_psfail');

CREATE TABLE majobd ( 
      COBDPOH Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NINVCIS Double( 0 ),
      NTYPMAJ Short,
      CTYPSKP Char( 15 ),
      NODPISK Short,
      NTYPDODPI Short,
      NTYPUODPI Short,
      NROKYODPIU Short,
      CNAZEV Char( 30 ),
      NTROBOR Integer,
      NZNAKT Short,
      NDOKLAD Double( 0 ),
      NDRPOHYB Integer,
      DDATPOR Date,
      DDATZAR Date,
      COBDZAR Char( 5 ),
      DDATVYRAZ Date,
      COBDVYRAZ Char( 5 ),
      DDATZVYS Date,
      COBDZVYS Char( 5 ),
      NROKYDANOD Short,
      NROKZVDANO Short,
      NKUSY Short,
      NCENAVSTU Double( 2 ),
      NCENAVSTD Double( 2 ),
      NOPRUCT Double( 2 ),
      NOPRDAN Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NOPRDANPS Double( 2 ),
      NPROCDANOD Double( 2 ),
      NDANODPROK Double( 2 ),
      NPROCUCTOD Double( 2 ),
      NUCTODPROK Double( 2 ),
      NUCTODPMES Double( 2 ),
      NUPLPROC Double( 2 ),
      NUPLHODN Double( 2 ),
      NROKUPL Short,
      CKLICODMIS Char( 8 ),
      CKLICSKMIS Char( 8 ),
      CVYRCISIM Char( 25 ),
      DDATREVIM Date,
      COBDPOSODP Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MPOPIS Memo,
      CCELEK Char( 15 ),
      CVYKRES Char( 20 ),
      CUMISTENI Char( 25 ),
      CODPISK Char( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'majobd',
   'majobd.adi',
   'MAJOBD_1',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majobd',
   'majobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'majobd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majobd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majobd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majobdfail');

CREATE TABLE majoper ( 
      CVYRPOL Char( 15 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      NINVCIS Integer,
      CDRUHMAJ Char( 2 ),
      NMNOZMAJ Double( 3 ),
      NCASNORMAJ Double( 3 ),
      CKODCASMAJ Char( 2 ),
      CKODKOECAS Char( 2 ),
      CKODKOEMNO Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'majoper',
   'majoper.adi',
   'MAJOPER1',
   'UPPER(COZNOPER) +STRZERO(NINVCIS,6) +UPPER(CDRUHMAJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majoper',
   'majoper.adi',
   'MAJOPER2',
   'UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3) +STRZERO(NINVCIS,6) +UPPER(CDRUHMAJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majoper',
   'majoper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'majoper', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majoperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majoper', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majoperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majoper', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majoperfail');

CREATE TABLE majopw ( 
      NINVCIS Integer,
      CDRUHMAJ Char( 2 ),
      CTYPMAJ Char( 2 ),
      CNAZEVMAJ Char( 30 ),
      NMNOZMAJ Double( 3 ),
      CZKRATJEDN Char( 3 ),
      NCASNORMA Double( 4 ),
      NHODNOTAKC Double( 4 ),
      COZNOPER Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'majopw', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majopwfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majopw', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majopwfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majopw', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majopwfail');

CREATE TABLE majz ( 
      NINVCIS Double( 0 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CTYPSKP Char( 15 ),
      NODPISK Short,
      NTYPDODPI Short,
      NTYPUODPI Short,
      NROKYODPIU Short,
      CNAZEV Char( 30 ),
      NTROBOR Integer,
      NZNAKT Integer,
      NDOKLAD Double( 0 ),
      NDRPOHYB Integer,
      DDATPOR Date,
      DDATZAR Date,
      COBDZAR Char( 5 ),
      DDATVYRAZ Date,
      COBDVYRAZ Char( 5 ),
      DDATZVYS Date,
      COBDZVYS Char( 5 ),
      NROKYDANOD Short,
      NROKZVDANO Short,
      NKUSY Short,
      NMNOZSTVI Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCENAVSTU Double( 2 ),
      NCENAVSTD Double( 2 ),
      NOPRUCT Double( 2 ),
      NOPRDAN Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NOPRDANPS Double( 2 ),
      NPROCDANOD Double( 2 ),
      NDANODPROK Double( 2 ),
      NPROCUCTOD Double( 2 ),
      NUCTODPROK Double( 2 ),
      NUCTODPMES Double( 2 ),
      NPOCMESODP Short,
      NUPLPROC Double( 2 ),
      NUPLHODN Double( 2 ),
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
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_01',
   'STRZERO(NUCETSKUP,3) + STRZERO( NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_02',
   'NINVCIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_03',
   'UPPER( CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_04',
   'UPPER( CTYPSKP) + STRZERO(NUCETSKUP,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_05',
   'STRZERO(NODPISK,1) + STRZERO( NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_06',
   'STRZERO(NODPISK,1) + STRZERO( NUCETSKUP,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_07',
   'STRZERO(NODPISK,1) + UPPER( CTYPSKP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_08',
   'UPPER( CTYPSKP) + STRZERO(NODPISK,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_09',
   'NTYPUODPI',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_10',
   'NROKYODPIU',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'MAJZ_11',
   'NDOKLPREV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz',
   'majz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majzfail');

CREATE TABLE majz_ps ( 
      NINVCIS Double( 0 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NROK Short,
      NVSCENDPS Double( 2 ),
      NVSCENUPS Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NZUCENUPS Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'majz_ps',
   'majz_ps.adi',
   'MAJZ_PS_01',
   'STRZERO(NUCETSKUP,3) + STRZERO(NINVCIS,10) + STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz_ps',
   'majz_ps.adi',
   'MAJZ_PS_02',
   'STRZERO(NROK,4) + STRZERO(NUCETSKUP,3) + STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majz_ps',
   'majz_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz_ps', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majz_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz_ps', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majz_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majz_ps', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majz_psfail');

CREATE TABLE majzobd ( 
      COBDPOH Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NINVCIS Double( 0 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CTYPSKP Char( 15 ),
      NODPISK Short,
      NTYPDODPI Short,
      NTYPUODPI Short,
      NROKYODPIU Short,
      CNAZEV Char( 30 ),
      NTROBOR Integer,
      NZNAKT Short,
      NDOKLAD Double( 0 ),
      NDRPOHYB Integer,
      DDATPOR Date,
      DDATZAR Date,
      COBDZAR Char( 5 ),
      DDATVYRAZ Date,
      COBDVYRAZ Char( 5 ),
      DDATZVYS Date,
      COBDZVYS Char( 5 ),
      NROKYDANOD Short,
      NROKZVDANO Short,
      NKUSY Short,
      NCENAVSTU Double( 2 ),
      NCENAVSTD Double( 2 ),
      NOPRUCT Double( 2 ),
      NOPRDAN Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NOPRDANPS Double( 2 ),
      NPROCDANOD Double( 2 ),
      NDANODPROK Double( 2 ),
      NPROCUCTOD Double( 2 ),
      NUCTODPROK Double( 2 ),
      NUCTODPMES Double( 2 ),
      NUPLPROC Double( 2 ),
      NUPLHODN Double( 2 ),
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
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'majzobd',
   'majzobd.adi',
   'MAJZOBD_1',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'majzobd',
   'majzobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'majzobd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'majzobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majzobd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'majzobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'majzobd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'majzobdfail');

CREATE TABLE manblopr ( 
      CVYROBSTRE Char( 8 ),
      COZNPRAC Char( 8 ),
      NDENMANBLO Date,
      NBLOKHODIN Double( 3 ),
      CTYPBLOKAC Char( 6 ),
      CVYRZAK Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'manblopr',
   'manblopr.adi',
   'MANBLO_0',
   'UPPER(CVYROBSTRE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'manblopr',
   'manblopr.adi',
   'MANBLO_1',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'manblopr',
   'manblopr.adi',
   'MANBLO_2',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC) +DTOS(NDENMANBLO) +STRZERO(NBLOKHODIN,9)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'manblopr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'manbloprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'manblopr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'manbloprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'manblopr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'manbloprfail');

CREATE TABLE matrtmp ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      NKEYMATR Short,
      NRADMATR Short,
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZKRATJEDN Char( 3 ),
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NDRUHMZDY Short,
      NSAZBADOKL Double( 2 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NPREMIE Short,
      CMSM_ORG Char( 29 ),
      CMSM_NEW Char( 29 ),
      CMSM_NAZR Char( 12 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'matrtmp',
   'matrtmp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'matrtmp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'matrtmpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'matrtmp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'matrtmpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'matrtmp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'matrtmpfail');

CREATE TABLE mimprvz ( 
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CRODCISPRA Char( 13 ),
      CPRACOVNIK Char( 50 ),
      NPORMIPVZT Short,
      NMIMOPRVZT Short,
      CNAZMIMPRV Char( 25 ),
      CPOPISMIPV Char( 40 ),
      DMIMPRVZOD Date,
      DMIMPRVZDO Date,
      LAKTIV Logical,
      LGENMZDDOK Logical,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_02',
   'UPPER(CRODCISPRA) +IF (LAKTIV, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_03',
   'UPPER(CRODCISPRA) +STRZERO(NMIMOPRVZT,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_04',
   'UPPER(CRODCISPRA) +STRZERO(NMIMOPRVZT,2) +DTOS (DMIMPRVZOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mimprvz',
   'mimprvz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mimprvz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mimprvzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mimprvz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mimprvzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mimprvz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mimprvzfail');

CREATE TABLE msdim ( 
      CKLICSKMIS Char( 8 ),
      CKLICODMIS Char( 8 ),
      NINVCISDIM Integer,
      CNAZEVDIM Char( 30 ),
      NTYPDIM Short,
      CTYPSKP Char( 15 ),
      NZIVOTDIM Short,
      DDATZARDIM Date,
      DDATPOHDIM Date,
      NCISFAK Double( 0 ),
      NPOCKUSDIM Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCENJEDDIM Double( 2 ),
      NCENCELDIM Double( 2 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CVYRCISDIM Char( 25 ),
      DDATREVDIM Date,
      DDATVYRDIM Date,
      MPOZNDIM Memo,
      LEVIDELNAR Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM1',
   'NINVCISDIM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM2',
   'UPPER(CNAZEVDIM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM3',
   'STRZERO(NTYPDIM,3) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM4',
   'STRZERO(NTYPDIM,3) +UPPER(CNAZEVDIM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM5',
   'UPPER(CKLICODMIS) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM6',
   'UPPER(CKLICODMIS) +UPPER(CNAZEVDIM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM7',
   'UPPER(CKLICODMIS) +STRZERO(NTYPDIM,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM8',
   'STRZERO(NTYPDIM,3) +UPPER(CKLICODMIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM9',
   'DTOS ( DDATZARDIM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM10',
   'DTOS ( DDATPOHDIM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM11',
   'UPPER(CKLICSKMIS) +UPPER(CKLICODMIS) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'DIM12',
   'STRZERO(NINVCISDIM,6) +STRZERO(NPOCKUSDIM,11,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msdim',
   'msdim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'msdim', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'msdimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msdim', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'msdimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msdim', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'msdimfail');

CREATE TABLE msmatr ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      NKEYMATR Short,
      NRADMATR Short,
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZKRATJEDN Char( 3 ),
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NDRUHMZDY Short,
      NSAZBADOKL Double( 2 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NPREMIE Short,
      CMSM_ORG Char( 29 ),
      CMSM_NEW Char( 29 ),
      CMSM_NAZR Char( 12 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'msmatr',
   'msmatr.adi',
   'MSMATR1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NKEYMATR,2) +STRZERO(NRADMATR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msmatr',
   'msmatr.adi',
   'MSMATR2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NKEYMATR,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msmatr',
   'msmatr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'msmatr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'msmatrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msmatr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'msmatrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msmatr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'msmatrfail');

CREATE TABLE msodppol ( 
      NROK Short,
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 35 ),
      NPORPRAVZT Short,
      NPORODPPOL Short,
      CTYPODPPOL Char( 4 ),
      CNAZODPPOL Char( 30 ),
      DPLATNOD Date,
      DPLATNDO Date,
      COBDOD Char( 5 ),
      COBDDO Char( 5 ),
      NODPOCOBD Integer,
      NODPOCROK Integer,
      NDANULOBD Integer,
      NDANULROK Integer,
      CRODCISRP Char( 13 ),
      NRODPRISL Short,
      LAKTIV Logical,
      LAKTMESODP Logical,
      LODPOCET Logical,
      LDANULEVA Logical,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORODPPOL,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +UPPER(CTYPODPPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +UPPER(CRODCISRP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP04',
   'UPPER(CRODCISRP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP05',
   'UPPER(CRODCISRP) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORODPPOL,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP07',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'MSODPP08',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +UPPER(CTYPODPPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msodppol',
   'msodppol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'msodppol', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'msodppolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msodppol', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'msodppolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msodppol', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'msodppolfail');

CREATE TABLE msprc_md ( 
      CKMENSTRPR Char( 8 ),
      CNAZPOL1 Char( 8 ),
      NOSCISPRAC Integer,
      NCISOSOBY Integer,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      CPRACOVNIK Char( 50 ),
      CTITULPRAC Char( 15 ),
      CRODCISPRA Char( 13 ),
      NMUZ Short,
      NZENA Short,
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      DDATVZNPRV Date,
      DDATNAST Date,
      DDATVYST Date,
      DDATPREDVY Date,
      NTYPUKOPRV Short,
      NPORVEDCIN Short,
      NTYPVEDCIN Short,
      DDATVZNVEC Date,
      DDATNASTVC Date,
      DDATVYSTVC Date,
      DDATPREDVC Date,
      NTYPUKOVEC Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CFUNPRA Char( 8 ),
      CNAZPOL4 Char( 8 ),
      LSTAVEM Logical,
      LAUTOSZ400 Logical,
      LTISKKONTR Logical,
      LODBORAR Logical,
      LPRUKAZZPS Logical,
      CTYPSMENY Char( 15 ),
      CDELKPRDOB Char( 20 ),
      DPLATTAROD Date,
      CTYPTARPOU Char( 8 ),
      CTYPTARMZD Char( 8 ),
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      NTARSAZHOD Double( 3 ),
      NTARSAZMES Double( 3 ),
      DPLATSAZOD Date,
      NSAZPREPR Double( 3 ),
      NSAZOSOOH Double( 3 ),
      NHODPOVPRE Double( 2 ),
      CIDOSKARTY Char( 25 ),
      NDOVBEZZUS Double( 2 ),
      NDOVMINZUS Double( 2 ),
      NDOVZUSTAT Double( 2 ),
      NDODZUSTAT Double( 2 ),
      NDOVZUSTCE Double( 2 ),
      NHODPRUMPP Double( 2 ),
      NDENPRUMPP Double( 2 ),
      LEXPORT Logical,
      LIMPORTDOC Logical,
      CPASSWORD Char( 5 ),
      NTMDATVYST Integer,
      CTMKMSTRPR Char( 8 ),
      NWKSTATION Short,
      MPOZNANKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO01',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO04',
   'UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO05',
   'UPPER(CIDOSKARTY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO06',
   'UPPER(CPASSWORD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO07',
   'STRZERO(NTMDATVYST,8) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO08',
   'UPPER(CKMENSTRPR) +STRZERO(NTMDATVYST,8)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_md',
   'msprc_md.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_md', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'msprc_mdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_md', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'msprc_mdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_md', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'msprc_mdfail');

CREATE TABLE msprc_mo ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NCTVRTLETI Short,
      CNAZPOL1 Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NCISOSOBY Integer,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      CPRACOVNIK Char( 50 ),
      CTITULPRAC Char( 15 ),
      CRODCISPRA Char( 13 ),
      CRODCISPRN Char( 10 ),
      NRODCISPRA Double( 0 ),
      NMUZ Short,
      NZENA Short,
      CDRUPRAVZT Char( 8 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      CVZNPRAVZT Char( 10 ),
      NTYPZAMVZT Short,
      DDATVZNPRV Date,
      DDATNAST Date,
      DDATVYST Date,
      DDATPREDVY Date,
      NTYPUKOPRV Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CFUNPRA Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CVYPLMIST Char( 8 ),
      LSTAVEM Logical,
      LSOCPOJIS Logical,
      LZDRPOJIS Logical,
      NZDRPOJIS Short,
      LZDRPOJDOP Logical,
      NZDRPOJDOP Short,
      LZPRACCM Logical,
      NPORMIPVZT Short,
      NMIMOPRVZT Short,
      DODMIPRVZT Date,
      DDOMIPRVZT Date,
      NTYPDUCHOD Short,
      LDANPROHL Logical,
      LAUTOMZDA Logical,
      LVYPCISMZD Logical,
      NTYPVYPOCM Short,
      LAUTOSZ400 Logical,
      LTISKKONTR Logical,
      LZAOKRNA10 Logical,
      NZAOKRNA10 Short,
      LEXPORT Logical,
      LIMPORTDOC Logical,
      LODBORAR Logical,
      LPRUKAZZPS Logical,
      CPRUKAZZPS Char( 8 ),
      LAUTOVYPCM Logical,
      LAUTOVYPHM Logical,
      LAUTOVYPPR Logical,
      LTISKMZDLI Logical,
      LVYRADANO Logical,
      LGENERELDP Logical,
      LSTATUZAST Logical,
      NODPOCOBD Integer,
      NODPOCROK Integer,
      NDANULOBD Integer,
      NDANULROK Integer,
      CTYPSMENY Char( 15 ),
      CDELKPRDOB Char( 20 ),
      DPLATTAROD Date,
      CTYPTARPOU Char( 8 ),
      CTYPTARMZD Char( 8 ),
      CTARIFTRID Char( 8 ),
      CTARIFSTUP Char( 8 ),
      NTARSAZHOD Double( 3 ),
      NTARSAZMES Double( 3 ),
      DPLATSAZOD Date,
      NSAZPREPR Double( 3 ),
      NSAZOSOOH Double( 3 ),
      NSAZPODHVP Double( 3 ),
      NHODPOVPRE Double( 2 ),
      NDOVBEZNAR Double( 2 ),
      NDOVBEZCEO Double( 2 ),
      NDOVBEZCER Double( 2 ),
      NDOVBEZZUS Double( 2 ),
      NDOVMINNAR Double( 2 ),
      NDOVMINCEO Double( 2 ),
      NDOVMINCER Double( 2 ),
      NDOVMINZUS Double( 2 ),
      NDOVZUSTAT Double( 2 ),
      NDODBEZNAR Double( 2 ),
      NDODBEZCEO Double( 2 ),
      NDODBEZCER Double( 2 ),
      NDODBEZZUS Double( 2 ),
      NDODMINNAR Double( 2 ),
      NDODMINCEO Double( 2 ),
      NDODMINCER Double( 2 ),
      NDODMINZUS Double( 2 ),
      NDODZUSTAT Double( 2 ),
      NDOVZUSTCE Double( 2 ),
      NALGCELODM Short,
      NPOCMESPR Short,
      CCTVRTLRIM Char( 2 ),
      CCTRVTLRIP Char( 2 ),
      NHODPRUMPP Double( 2 ),
      NDENPRUMPP Double( 2 ),
      NDENVZHRUN Double( 2 ),
      NDENVZCISN Double( 2 ),
      NDENVZCIKN Double( 2 ),
      NSAZDENNIN Short,
      NSAZDENVYN Short,
      NSAZDENVKN Short,
      NFYZSTAVOB Short,
      NFYZSTAVKO Short,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NVEKZAMEST Short,
      NOBDNARZAM Short,
      NTMDATVYST Integer,
      NTMOZPRHMZ Integer,
      NTMOZPRCMZ Integer,
      CTMKMSTRPR Char( 8 ),
      NWKSTATION Short,
      MPOZNAMKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO05',
   'UPPER(CKMENSTRPR) +UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO06',
   'DTOS( DDATVZNPRV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO07',
   'DTOS( DDATVYST)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTMDATVYST,8)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO09',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO10',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mo',
   'msprc_mo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_mo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'msprc_mofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_mo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'msprc_mofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_mo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'msprc_mofail');

CREATE TABLE msprc_mz ( 
      CNAZPOL1 Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NCISOSOBY Integer,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      CPRACOVNIK Char( 50 ),
      CTITULPRAC Char( 15 ),
      CRODCISPRA Char( 13 ),
      CRODCISPRN Char( 10 ),
      NRODCISPRA Double( 0 ),
      NMUZ Short,
      NZENA Short,
      CDRUPRAVZT Char( 8 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      CVZNPRAVZT Char( 10 ),
      NTYPZAMVZT Short,
      DDATVZNPRV Date,
      DDATNAST Date,
      DDATVYST Date,
      DDATPREDVY Date,
      NTYPUKOPRV Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CFUNPRA Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CVYPLMIST Char( 8 ),
      LSTAVEM Logical,
      LSOCPOJIS Logical,
      LZDRPOJIS Logical,
      NZDRPOJIS Short,
      LZDRPOJDOP Logical,
      NZDRPOJDOP Short,
      LZPRACCM Logical,
      NPORMIPVZT Short,
      NMIMOPRVZT Short,
      DODMIPRVZT Date,
      DDOMIPRVZT Date,
      NTYPDUCHOD Short,
      LDANPROHL Logical,
      LAUTOMZDA Logical,
      LVYPCISMZD Logical,
      NTYPVYPOCM Short,
      LAUTOSZ400 Logical,
      LTISKKONTR Logical,
      LZAOKRNA10 Logical,
      NZAOKRNA10 Short,
      LEXPORT Logical,
      LIMPORTDOC Logical,
      LODBORAR Logical,
      LPRUKAZZPS Logical,
      CPRUKAZZPS Char( 8 ),
      LAUTOVYPCM Logical,
      LAUTOVYPHM Logical,
      LAUTOVYPPR Logical,
      LTISKMZDLI Logical,
      LVYRADANO Logical,
      LGENERELDP Logical,
      LSTATUZAST Logical,
      NODPOCOBD Integer,
      NODPOCROK Integer,
      NDANULOBD Integer,
      NDANULROK Integer,
      CTYPSMENY Char( 15 ),
      CDELKPRDOB Char( 20 ),
      DPLATTAROD Date,
      CTYPTARPOU Char( 8 ),
      CTYPTARMZD Char( 8 ),
      CTARIFTRID Char( 8 ),
      CTARIFSTUP Char( 8 ),
      NTARSAZHOD Double( 3 ),
      NTARSAZMES Double( 3 ),
      DPLATSAZOD Date,
      NSAZPREPR Double( 3 ),
      NSAZOSOOH Double( 3 ),
      NSAZPODHVP Double( 3 ),
      NHODPOVPRE Double( 2 ),
      NDOVBEZNAR Double( 2 ),
      NDOVBEZCEO Double( 2 ),
      NDOVBEZCER Double( 2 ),
      NDOVBEZZUS Double( 2 ),
      NDOVMINNAR Double( 2 ),
      NDOVMINCEO Double( 2 ),
      NDOVMINCER Double( 2 ),
      NDOVMINZUS Double( 2 ),
      NDOVZUSTAT Double( 2 ),
      NDODBEZNAR Double( 2 ),
      NDODBEZCEO Double( 2 ),
      NDODBEZCER Double( 2 ),
      NDODBEZZUS Double( 2 ),
      NDODMINNAR Double( 2 ),
      NDODMINCEO Double( 2 ),
      NDODMINCER Double( 2 ),
      NDODMINZUS Double( 2 ),
      NDODZUSTAT Double( 2 ),
      NDOVZUSTCE Double( 2 ),
      NALGCELODM Short,
      NPOCMESPR Short,
      CCTVRTLRIM Char( 2 ),
      CCTRVTLRIP Char( 2 ),
      NHODPRUMPP Double( 2 ),
      NDENPRUMPP Double( 2 ),
      NDENVZHRUN Double( 2 ),
      NDENVZCISN Double( 2 ),
      NDENVZCIKN Double( 2 ),
      NSAZDENNIN Short,
      NSAZDENVYN Short,
      NSAZDENVKN Short,
      NPROCPREM Double( 2 ),
      NHODPRUMER Double( 3 ),
      NFYZSTAVOB Short,
      NFYZSTAVKO Short,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NVEKZAMEST Short,
      NOBDNARZAM Short,
      NTMDATVYST Integer,
      NTMOZPRHMZ Integer,
      NTMOZPRCMZ Integer,
      CTMKMSTRPR Char( 8 ),
      NWKSTATION Short,
      MPOZNAMKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ01',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ04',
   'UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ05',
   'UPPER(CKMENSTRPR) +UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ07',
   'UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ08',
   'UPPER(CVYPLMIST) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ09',
   'UPPER(CRODCISPRA) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ10',
   'IF (LSTAVEM, ''1'', ''0'') +UPPER(CTYPTARPOU) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ11',
   'DTOS ( DDATVZNPRV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ12',
   'DTOS ( DDATVYST)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ13',
   'NTMDATVYST',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ14',
   'NWKSTATION',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msprc_mz',
   'msprc_mz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_mz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'msprc_mzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_mz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'msprc_mzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msprc_mz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'msprc_mzfail');

CREATE TABLE mssazzam ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CDELKPRDOB Char( 20 ),
      DPLATSAZOD Date,
      DPLATSAZDO Date,
      NSAZPREPR Double( 3 ),
      NSAZOSOOH Double( 3 ),
      NSAZPODHVP Double( 3 ),
      NHODPOVPRE Double( 2 ),
      LAKTSAZBA Logical,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDELKPRDOB) +DTOS (DPLATSAZOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDELKPRDOB) +IF (LAKTSAZBA, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +DTOS (DPLATSAZOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM05',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +IF (LAKTSAZBA, ''1'', ''0'') +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssazzam',
   'mssazzam.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssazzam', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mssazzamfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssazzam', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mssazzamfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssazzam', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mssazzamfail');

CREATE TABLE mssrz_mo ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CPRACOVNIK Char( 30 ),
      CRODCISPRA Char( 13 ),
      NOSCISPRAC Integer,
      CKMENSTRPR Char( 8 ),
      NPORPRAVZT Short,
      NPORADI Integer,
      NPORUPLSRZ Short,
      CZKRSRAZKY Char( 8 ),
      LAKTIVSRZ Logical,
      LPREDNPOHL Logical,
      NPREDNPOHL Short,
      CTYPSRZ Char( 4 ),
      NTYPSRZ Short,
      CPOPSRAZKY Char( 30 ),
      NTYPCASTKA Short,
      NSPLATKA Double( 2 ),
      NCELKEM Double( 2 ),
      NSPLACENO Double( 2 ),
      NZUSTATEK Double( 2 ),
      NNEDOPLAT Double( 2 ),
      DDATDORVYK Date,
      DDATZUSTAT Date,
      DDATODSPL Date,
      DDATDOSPL Date,
      CUCETI Char( 20 ),
      CUCET Char( 25 ),
      CKODBANKY Char( 4 ),
      CVARSYM Char( 15 ),
      CSPECSYMB Char( 20 ),
      NKONSTSYMB Short,
      CBANK_UCT Char( 25 ),
      CBANK_UCTI Char( 20 ),
      CBANK_KOD Char( 4 ),
      CTYPABO Char( 6 ),
      CZPUSSRAZ Char( 6 ),
      CZKRTYPZAV Char( 5 ),
      NDRUHMZDY Short,
      NDRUHMZDY2 Short,
      NDRUHMZDY3 Short,
      CUCET_UCT Char( 6 ),
      NTMPIT Short,
      CTMKMSTRPR Char( 8 ),
      MPOZNANKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_02',
   'UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_03',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPSRZ,2) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_07',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_08',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssrz_mo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mssrz_mofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssrz_mo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mssrz_mofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssrz_mo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mssrz_mofail');

CREATE TABLE mssrz_mz ( 
      CPRACOVNIK Char( 30 ),
      CRODCISPRA Char( 13 ),
      NOSCISPRAC Integer,
      CKMENSTRPR Char( 8 ),
      NPORPRAVZT Short,
      NPORADI Integer,
      NPORUPLSRZ Short,
      CZKRSRAZKY Char( 8 ),
      LAKTIVSRZ Logical,
      LPREDNPOHL Logical,
      NPREDNPOHL Short,
      CTYPSRZ Char( 4 ),
      NTYPSRZ Short,
      CPOPSRAZKY Char( 30 ),
      NTYPCASTKA Short,
      NSPLATKA Double( 2 ),
      NCELKEM Double( 2 ),
      NSPLACENO Double( 2 ),
      NZUSTATEK Double( 2 ),
      NNEDOPLAT Double( 2 ),
      DDATDORVYK Date,
      DDATZUSTAT Date,
      DDATODSPL Date,
      DDATDOSPL Date,
      CUCETI Char( 20 ),
      CUCET Char( 25 ),
      CKODBANKY Char( 4 ),
      CVARSYM Char( 15 ),
      CSPECSYMB Char( 20 ),
      NKONSTSYMB Short,
      CBANK_UCT Char( 25 ),
      CBANK_UCTI Char( 20 ),
      CBANK_KOD Char( 4 ),
      CTYPABO Char( 6 ),
      CZPUSSRAZ Char( 6 ),
      CZKRTYPZAV Char( 5 ),
      NDRUHMZDY Short,
      NDRUHMZDY2 Short,
      NDRUHMZDY3 Short,
      CUCET_UCT Char( 6 ),
      NTMPIT Short,
      CTMKMSTRPR Char( 8 ),
      MPOZNANKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_02',
   'UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_05',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPSRZ,2) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_07',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_08',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CZKRSRAZKY) +IF (LAKTIVSRZ, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssrz_mz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mssrz_mzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssrz_mz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mssrz_mzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mssrz_mz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mssrz_mzfail');

CREATE TABLE mstarhro ( 
      CTARIFTRID Char( 8 ),
      CTARIFSTUP Char( 8 ),
      CDELKPRDOB Char( 20 ),
      DPLATTAROD Date,
      DPLATTARDO Date,
      NTARSAZHOD Double( 3 ),
      NTARSAZMES Double( 3 ),
      LAKTTARIF Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR1',
   'UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR2',
   'UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +DTOS (DPLATTAROD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR3',
   'UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +IF (LAKTTARIF, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR4',
   'IF (LAKTTARIF, ''1'', ''0'') +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarhro',
   'mstarhro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mstarhro', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mstarhrofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mstarhro', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mstarhrofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mstarhro', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mstarhrofail');

CREATE TABLE mstarind ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CMZDKATPRA Char( 8 ),
      CTYPTARPOU Char( 8 ),
      CTARIFTRID Char( 8 ),
      CTARIFSTUP Char( 8 ),
      CDELKPRDOB Char( 20 ),
      DPLATTAROD Date,
      DPLATTARDO Date,
      NTARSAZHOD Double( 3 ),
      NTARSAZMES Double( 3 ),
      LAKTTARIF Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +DTOS (DPLATTAROD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN3',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +IF (LAKTTARIF, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN4',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +DTOS (DPLATTAROD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN5',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +IF (LAKTTARIF, ''1'', ''0'') +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTYPTARPOU) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +DTOS (DPLATTAROD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mstarind',
   'mstarind.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mstarind', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mstarindfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mstarind', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mstarindfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mstarind', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mstarindfail');

CREATE TABLE msvprum ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NCTVRTLETI Short,
      CCTVRTLRIM Char( 3 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      CVYBOBD_P Char( 24 ),
      CVYBOBD_N Char( 24 ),
      CDELKPRDOB Char( 15 ),
      NDELKPDOBY Double( 2 ),
      NALGCELODM Short,
      NPOCMESPR Short,
      NKCSNEMOC Double( 2 ),
      NKCSDAN_NP Double( 2 ),
      NDODPRA_NP Integer,
      NHODPRA_NP Double( 1 ),
      NKCSPRACP Double( 2 ),
      NDODPRA_PP Integer,
      NHODPRA_PP Double( 1 ),
      NDFONDU_PP Integer,
      NHFONDU_PP Double( 1 ),
      NKCSODMEN Double( 2 ),
      NDODPRA_OO Integer,
      NHODPRA_OO Double( 1 ),
      NDFONDU_OO Integer,
      NHFONDU_OO Double( 1 ),
      NV_NEMOC Double( 2 ),
      NS_NEMOC Double( 2 ),
      NREZIM Short,
      DDATNAST Date,
      DDATVYST Date,
      NKDSKUT Integer,
      NDNY_PP01 Double( 2 ),
      NHOD_PP01 Double( 2 ),
      NKC_PP01 Double( 2 ),
      NDNY_PP02 Double( 2 ),
      NHOD_PP02 Double( 2 ),
      NKC_PP02 Double( 2 ),
      NDNY_PP03 Double( 2 ),
      NHOD_PP03 Double( 2 ),
      NKC_PP03 Double( 2 ),
      NDNY_PPSUM Double( 2 ),
      NHOD_PPSUM Double( 2 ),
      NKC_PPSUM Double( 2 ),
      NHOD_PRESC Double( 2 ),
      NKC_ODMCEL Double( 2 ),
      NKC_ODMROZ Double( 2 ),
      NKC_ODMCIS Double( 2 ),
      NHODPRUMPP Double( 2 ),
      NDENPRUMPP Double( 2 ),
      NKD_NM01 Integer,
      NKDO_NM01 Integer,
      NKC_NM01 Double( 2 ),
      NKD_NM02 Integer,
      NKDO_NM02 Integer,
      NKC_NM02 Double( 2 ),
      NKD_NM03 Integer,
      NKDO_NM03 Integer,
      NKC_NM03 Double( 2 ),
      NKD_NMSUM Integer,
      NKDO_NMSUM Integer,
      NKC_NMSUM Double( 2 ),
      NDENVZHRUN Double( 2 ),
      NDENVZCISN Double( 2 ),
      NDENVZCIKN Double( 2 ),
      NSAZDENNIN Short,
      NSAZDENVYN Short,
      NSAZDENVKN Short,
      NPRUMESMZH Double( 2 ),
      NPRUMESMZC Double( 2 ),
      NDANULEVA Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_01',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msvprum',
   'msvprum.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'msvprum',
   'msvprum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'msvprum', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'msvprumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msvprum', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'msvprumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'msvprum', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'msvprumfail');

CREATE TABLE mzdlisth ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CKMENSTRPR Char( 8 ),
      NROK Short,
      NOBDOBI Short,
      CZPROBDOBI Char( 12 ),
      MPORPRAVZT Memo,
      MODPOCPOL Memo,
      MTYPDUCHOD Memo,
      MRODPRISL Memo,
      MVYUCTNEMD Memo,
      MMIMPRCVZT Memo,
      CPRACTMSOR Char( 25 ),
      NTMPPORADI Integer,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH02',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH03',
   'STRZERO(NROK,4) +UPPER(CPRACTMSOR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH04',
   'STRZERO(NROK,4) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH05',
   'STRZERO(NROK,4) +UPPER(CKMENSTRPR) +UPPER(CPRACTMSOR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH07',
   'STRZERO(NROK,4) +UPPER(CPRACTMSOR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH08',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisth',
   'mzdlisth.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdlisth', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzdlisthfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdlisth', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzdlisthfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdlisth', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzdlisthfail');

CREATE TABLE mzdlisti ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CKMENSTRPR Char( 8 ),
      NROK Short,
      NTYPRADMZL Short,
      NRADMZDLIS Short,
      NOBDOBI_01 Double( 2 ),
      COBDOBI_01 Char( 10 ),
      NOBDOBI_02 Double( 2 ),
      COBDOBI_02 Char( 10 ),
      NOBDOBI_03 Double( 2 ),
      COBDOBI_03 Char( 10 ),
      NOBDOBI_04 Double( 2 ),
      COBDOBI_04 Char( 10 ),
      NOBDOBI_05 Double( 2 ),
      COBDOBI_05 Char( 10 ),
      NOBDOBI_06 Double( 2 ),
      COBDOBI_06 Char( 10 ),
      NOBDOBI_07 Double( 2 ),
      COBDOBI_07 Char( 10 ),
      NOBDOBI_08 Double( 2 ),
      COBDOBI_08 Char( 10 ),
      NOBDOBI_09 Double( 2 ),
      COBDOBI_09 Char( 10 ),
      NOBDOBI_10 Double( 2 ),
      COBDOBI_10 Char( 10 ),
      NOBDOBI_11 Double( 2 ),
      COBDOBI_11 Char( 10 ),
      NOBDOBI_12 Double( 2 ),
      COBDOBI_12 Char( 10 ),
      NCELKEMROK Double( 2 ),
      CCELKEMROK Char( 10 ),
      CPRACTMSOR Char( 25 ),
      NPORDUCHOD Short,
      CRODCISRP Char( 13 ),
      CTYPRODPRI Char( 4 ),
      NFOOT Short,
      CTYPVALUER Char( 1 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI3',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NFOOT,1) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI4',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI5',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI6',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NFOOT,1) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI7',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NFOOT,1) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdlisti',
   'mzdlisti.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdlisti', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzdlistifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdlisti', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzdlistifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdlisti', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzdlistifail');

CREATE TABLE mzdmz_ob ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CKMENSTRPR Char( 8 ),
      NDRUHMZDY Short,
      NDNYDOKLAD Double( 1 ),
      NHODDOKLAD Double( 2 ),
      NMZDA Double( 2 ),
      NDNYDOKLZA Double( 1 ),
      NHODDOKLZA Double( 2 ),
      NMZDAZA Double( 2 ),
      MUCTOVZA Memo,
      NDNYDOKLCS Double( 1 ),
      NHODDOKLCS Double( 2 ),
      NMZDACS Double( 2 ),
      MUCTOVCS Memo,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'MZMZO_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'MZMZO_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdmz_ob', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzdmz_obfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdmz_ob', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzdmz_obfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdmz_ob', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzdmz_obfail');

CREATE TABLE mzdpren ( 
      NWKSTATION Short,
      COBDOBI Char( 5 ),
      NCOUNPREN Short,
      NTYPEPREN Short,
      DDATEPREN Date,
      CTIMEPREN Char( 8 ),
      CUSERPREN Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdpren',
   'mzdpren.adi',
   'MZDPREN1',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdpren',
   'mzdpren.adi',
   'MZDPREN2',
   'STRZERO(NWKSTATION,3) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdpren',
   'mzdpren.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdpren', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzdprenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdpren', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzdprenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdpren', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzdprenfail');

CREATE TABLE mzdy ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DDATPORIZ Date,
      NDRUHMZDY Short,
      NDNYDOKLAD Double( 1 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NSAZBADOKL Double( 2 ),
      NMZDA Double( 2 ),
      NZAKLSOCPO Double( 2 ),
      NZAKLZDRPO Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NLIKCELDOK Double( 2 ),
      NZDRPOJIS Short,
      NMIMOPRVZT Short,
      NTYPDUCHOD Short,
      CVARSYM Char( 15 ),
      NPORADI Integer,
      DDATUMOD Date,
      DDATUMDO Date,
      NDNYVYLOCD Double( 2 ),
      NDNYVYLDOD Double( 2 ),
      NDNYDOVOL Double( 2 ),
      CZKRTYPZAV Char( 5 ),
      CPOLVYPLPA Char( 4 ),
      CVYPLMIST Char( 8 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      NTMPNUM1 Double( 2 ),
      NTMPNUM2 Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_05',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_06',
   'UPPER(CDENIK) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +STRZERO(NTYPZAMVZT,2) +STRZERO(NZDRPOJIS,3) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_10',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_11',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_13',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_14',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +UPPER(CDENIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_15',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_16',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_17',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'MZDY_18',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy',
   'mzdy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzdyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzdyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzdyfail');

CREATE TABLE mzdy_obd ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NCTVRTLETI Short,
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CDRUPRAVZT Char( 8 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      CVZNPRAVZT Char( 10 ),
      NTYPZAMVZT Short,
      NMIMOPRVZT Short,
      CPRACOVNIK Char( 30 ),
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      NTYPDUCHOD Short,
      NZDRPOJIS Short,
      CDELKPRDOB Char( 20 ),
      CPRUKAZZPS Char( 8 ),
      DPOSLZPRAM Date,
      CPOSLZPRAM Char( 8 ),
      NMZDZAKLAD Double( 2 ),
      NMZDPRIPL Double( 2 ),
      NMZDODMENY Double( 2 ),
      NMZDNAHRAD Double( 2 ),
      NMZDOSTATN Double( 2 ),
      NHRUBAMZDA Double( 2 ),
      NZAKLSOCPO Double( 2 ),
      NODVOSOCPC Double( 2 ),
      NODVOSOCPO Double( 2 ),
      NODVOSOCPZ Double( 2 ),
      NZAKLZDRPO Double( 2 ),
      NODVOZDRPC Double( 2 ),
      NODVOZDRPO Double( 2 ),
      NODVOZDRPZ Double( 2 ),
      NDANZAKLMZ Double( 2 ),
      NDANZAKLSP Double( 2 ),
      NNEZDCASZD Integer,
      NDANULEVAC Integer,
      NZDANMZDAP Double( 2 ),
      NSRAZKODAN Double( 2 ),
      NZALOHODAN Double( 2 ),
      NDANCELKEM Double( 2 ),
      NCISTPRIJE Double( 2 ),
      NNEMOCCELK Double( 2 ),
      NSRAZKCELK Double( 2 ),
      NCASTKVYPL Double( 2 ),
      NFONDKDDN Double( 1 ),
      NFONDPDDN Double( 1 ),
      NFONDPDSDN Double( 1 ),
      NDNYFONDKD Double( 1 ),
      NDNYFONDPD Double( 1 ),
      NDNYODPRPD Double( 1 ),
      NDNYNAHRPD Double( 1 ),
      NDNYSVATPD Double( 1 ),
      NDNYNEODPD Double( 1 ),
      NDNYVOSONE Double( 1 ),
      NDNYVNSONE Double( 1 ),
      NDNYNEMOKD Double( 1 ),
      NDNYVYLOCD Double( 2 ),
      NDNYVYLDOD Double( 2 ),
      NFONDPDHO Double( 2 ),
      NFONDPDSHO Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODFONDUP Double( 2 ),
      NHODODPRAC Double( 2 ),
      NHODNAHRAD Double( 2 ),
      NHODSVATKY Double( 2 ),
      NHODNEODPR Double( 2 ),
      NHODVOSONE Double( 2 ),
      NHODVNSONE Double( 2 ),
      NHODNEMOC Double( 2 ),
      NHODNEMZAK Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NLIKCELDOK Double( 2 ),
      NFYZSTAVOB Integer,
      NFYZSTAVKO Integer,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NPREVPZAFY Short,
      NPREVPZAPR Double( 2 ),
      NTMEVPZAPR Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      MPOZNAMKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_03',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_04',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NZDRPOJIS,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy_obd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzdy_obdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy_obd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzdy_obdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy_obd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzdy_obdfail');

CREATE TABLE mzdy_srz ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      CPRACOVNIK Char( 30 ),
      CRODCISPRA Char( 13 ),
      NOSCISPRAC Integer,
      CNAZPOL1 Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NPORPRAVZT Short,
      NPORADI Integer,
      NPORUPLSRZ Short,
      CZKRSRAZKY Char( 8 ),
      LPREDNPOHL Logical,
      CTYPSRZ Char( 4 ),
      NTYPSRZ Short,
      NSPLATKA Double( 2 ),
      CUCETI Char( 20 ),
      CUCET Char( 25 ),
      CKODBANKY Char( 4 ),
      CVARSYM Char( 15 ),
      CSPECSYMB Char( 20 ),
      NKONSTSYMB Short,
      CBANK_UCT Char( 25 ),
      CBANK_UCTI Char( 20 ),
      CBANK_KOD Char( 4 ),
      CTYPABO Char( 6 ),
      CZPUSSRAZ Char( 6 ),
      CZKRTYPZAV Char( 5 ),
      NDRUHMZDY Short,
      NDRUHMZDY2 Short,
      NDRUHMZDY3 Short,
      CUCET_UCT Char( 6 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'MZDYS_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'MZDYS_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'MZDYS_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy_srz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzdy_srzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy_srz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzdy_srzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzdy_srz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzdy_srzfail');

CREATE TABLE mzkum_ro ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      NPORPRAVZT Short,
      CNAZPOL1 Char( 8 ),
      CKMENSTRPR Char( 8 ),
      CPRACZAR Char( 8 ),
      CMZDKATPRA Char( 8 ),
      CTMKMSTRPR Char( 8 ),
      M100 Double( 1 ),
      M101 Double( 1 ),
      M102 Double( 1 ),
      M103 Double( 1 ),
      M104 Double( 1 ),
      M105 Double( 1 ),
      M106 Double( 1 ),
      M107 Double( 1 ),
      M108 Double( 1 ),
      M109 Double( 1 ),
      M110 Double( 1 ),
      M111 Double( 1 ),
      M112 Double( 2 ),
      M113 Double( 2 ),
      M114 Double( 2 ),
      M115 Double( 2 ),
      M116 Double( 2 ),
      M117 Double( 2 ),
      M118 Double( 2 ),
      M119 Double( 2 ),
      M120 Double( 2 ),
      M121 Double( 2 ),
      M122 Double( 2 ),
      M123 Double( 2 ),
      M124 Double( 2 ),
      M125 Double( 2 ),
      M126 Double( 2 ),
      M127 Double( 2 ),
      M128 Double( 2 ),
      M129 Double( 2 ),
      M130 Double( 2 ),
      M131 Double( 2 ),
      M132 Double( 2 ),
      M133 Double( 2 ),
      M134 Double( 2 ),
      M135 Double( 2 ),
      M136 Double( 2 ),
      M137 Double( 2 ),
      M138 Double( 2 ),
      M139 Double( 2 ),
      M140 Double( 2 ),
      M141 Double( 2 ),
      M142 Double( 2 ),
      M143 Double( 2 ),
      M144 Double( 2 ),
      M145 Double( 2 ),
      M148 Double( 2 ),
      M149 Double( 2 ),
      M150 Double( 2 ),
      M152 Double( 2 ),
      M153 Double( 2 ),
      M155 Double( 2 ),
      M156 Double( 2 ),
      M158 Double( 2 ),
      M159 Double( 2 ),
      M160 Double( 2 ),
      M161 Double( 2 ),
      M162 Double( 2 ),
      M163 Double( 2 ),
      M164 Double( 2 ),
      M165 Double( 2 ),
      M166 Double( 2 ),
      M167 Double( 2 ),
      M168 Double( 2 ),
      M169 Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'KUMRO_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'KUMRO_02',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'KUMRO_03',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzkum_ro', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzkum_rofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzkum_ro', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzkum_rofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzkum_ro', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzkum_rofail');

CREATE TABLE mzpod_ob ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NCTVRTLETI Short,
      LAKTSTAV Logical,
      DPOSLZPRAM Date,
      CPOSLZPRAM Char( 8 ),
      NMZDZAKLAD Double( 2 ),
      NMZDPRIPL Double( 2 ),
      NMZDODMENY Double( 2 ),
      NMZDNAHRAD Double( 2 ),
      NMZDOSTATN Double( 2 ),
      NHRUBAMZDA Double( 2 ),
      NZAKLSOCPO Double( 2 ),
      NODVOSOCPC Double( 2 ),
      NODVOSOCPO Double( 2 ),
      NODVOSOCPZ Double( 2 ),
      NZAKLZDRPO Double( 2 ),
      NODVOZDRPC Double( 2 ),
      NODVOZDRPO Double( 2 ),
      NODVOZDRPZ Double( 2 ),
      NDANZAKLMZ Double( 2 ),
      NDANZAKLSP Double( 2 ),
      NNEZDCASZD Double( 0 ),
      NDANULEVAC Double( 0 ),
      NZDANMZDAP Double( 2 ),
      NSRAZKODAN Double( 2 ),
      NZALOHODAN Double( 2 ),
      NDANCELKEM Double( 2 ),
      NCISTPRIJE Double( 2 ),
      NNEMOCCELK Double( 2 ),
      NSRAZKCELK Double( 2 ),
      NCASTKVYPL Double( 2 ),
      NFONDKDDN Double( 2 ),
      NFONDPDDN Double( 2 ),
      NFONDPDSDN Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NDNYODPRPD Double( 1 ),
      NDNYNAHRPD Double( 1 ),
      NDNYSVATPD Double( 1 ),
      NDNYNEODPD Double( 1 ),
      NDNYVOSONE Double( 1 ),
      NDNYNEMOKD Double( 2 ),
      NDNYVYLOCD Double( 2 ),
      NDNYVYLDOD Double( 2 ),
      NFONDPDHO Double( 2 ),
      NFONDPDSHO Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODFONDUP Double( 2 ),
      NHODODPRAC Double( 2 ),
      NHODNAHRAD Double( 2 ),
      NHODSVATKY Double( 2 ),
      NHODNEODPR Double( 2 ),
      NHODVOSONE Double( 2 ),
      NHODNEMOC Double( 2 ),
      NHODNEMZAK Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NLIKCELDOK Double( 2 ),
      NFYZSTAVOB Short,
      NFYZSTAVKO Short,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NPREVPZAFY Short,
      NPREVPZAPR Double( 2 ),
      NTMEVPZAPR Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'MZPOO_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'MZPOO_02',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzpod_ob', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzpod_obfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzpod_ob', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzpod_obfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzpod_ob', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzpod_obfail');

CREATE TABLE mzstr_ob ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NCTVRTLETI Short,
      LAKTSTAV Logical,
      CKMENSTRPR Char( 8 ),
      DPOSLZPRAM Date,
      CPOSLZPRAM Char( 8 ),
      NMZDZAKLAD Double( 2 ),
      NMZDPRIPL Double( 2 ),
      NMZDODMENY Double( 2 ),
      NMZDNAHRAD Double( 2 ),
      NMZDOSTATN Double( 2 ),
      NHRUBAMZDA Double( 2 ),
      NZAKLSOCPO Double( 2 ),
      NODVOSOCPC Double( 2 ),
      NODVOSOCPO Double( 2 ),
      NODVOSOCPZ Double( 2 ),
      NZAKLZDRPO Double( 2 ),
      NODVOZDRPC Double( 2 ),
      NODVOZDRPO Double( 2 ),
      NODVOZDRPZ Double( 2 ),
      NDANZAKLMZ Double( 2 ),
      NDANZAKLSP Double( 2 ),
      NNEZDCASZD Double( 0 ),
      NDANULEVAC Double( 0 ),
      NZDANMZDAP Double( 2 ),
      NSRAZKODAN Double( 2 ),
      NZALOHODAN Double( 2 ),
      NDANCELKEM Double( 2 ),
      NCISTPRIJE Double( 2 ),
      NNEMOCCELK Double( 2 ),
      NSRAZKCELK Double( 2 ),
      NCASTKVYPL Double( 2 ),
      NFONDKDDN Double( 2 ),
      NFONDPDDN Double( 2 ),
      NFONDPDSDN Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NDNYODPRPD Double( 1 ),
      NDNYNAHRPD Double( 1 ),
      NDNYSVATPD Double( 1 ),
      NDNYNEODPD Double( 1 ),
      NDNYVOSONE Double( 1 ),
      NDNYNEMOKD Double( 2 ),
      NDNYVYLOCD Double( 2 ),
      NDNYVYLDOD Double( 2 ),
      NFONDPDHO Double( 2 ),
      NFONDPDSHO Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODFONDUP Double( 2 ),
      NHODODPRAC Double( 2 ),
      NHODNAHRAD Double( 2 ),
      NHODSVATKY Double( 2 ),
      NHODNEODPR Double( 2 ),
      NHODVOSONE Double( 2 ),
      NHODNEMOC Double( 2 ),
      NHODNEMZAK Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NLIKCELDOK Double( 2 ),
      NFYZSTAVOB Short,
      NFYZSTAVKO Short,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NPREVPZAFY Short,
      NPREVPZAPR Double( 2 ),
      NTMEVPZAPR Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'MZDY_01',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'MZDY_02',
   'STRZERO(NROK,4)+STRZERO(NCTVRTLETI,1) +UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'MZDY_03',
   'UPPER(CKMENSTRPR) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzstr_ob', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzstr_obfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzstr_ob', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzstr_obfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzstr_ob', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzstr_obfail');

CREATE TABLE mzvykpot ( 
      CISPRAC Char( 5 ),
      RADML Char( 3 ),
      M01 Double( 2 ),
      M02 Double( 2 ),
      M03 Double( 2 ),
      M04 Double( 2 ),
      M05 Double( 2 ),
      M06 Double( 2 ),
      M07 Double( 2 ),
      M08 Double( 2 ),
      M09 Double( 2 ),
      M10 Double( 2 ),
      M11 Double( 2 ),
      M12 Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'mzvykpot',
   'mzvykpot.adi',
   'MZDLIST1',
   'UPPER(CISPRAC) +UPPER(RADML)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'mzvykpot',
   'mzvykpot.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzvykpot', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'mzvykpotfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzvykpot', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'mzvykpotfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'mzvykpot', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'mzvykpotfail');

CREATE TABLE nakpol ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CNAZTPV Char( 30 ),
      CDINOR Char( 15 ),
      CCSNRO Char( 10 ),
      CZKRATJEDN Char( 3 ),
      CMJTPV Char( 3 ),
      CMJSPO Char( 3 ),
      NKOEFPREP Double( 6 ),
      NVAHAMJ Double( 5 ),
      CTYPMAT Char( 3 ),
      CKODTPV Char( 2 ),
      CKODREZSKL Char( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      CROZMER1 Char( 20 ),
      NKOEFNATER Double( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'nakpol',
   'nakpol.adi',
   'NAKPOL1',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'nakpol',
   'nakpol.adi',
   'NAKPOL2',
   'UPPER(CNAZTPV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'nakpol',
   'nakpol.adi',
   'NAKPOL3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'nakpol',
   'nakpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'nakpol', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'nakpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'nakpol', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'nakpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'nakpol', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'nakpolfail');

CREATE TABLE namzvyit ( 
      CTYPVYKAZU Char( 10 ),
      NRADEKVYK Short,
      CNAZRADVYK Char( 10 ),
      NSLOUPVYK Short,
      CNAZSLOVYK Char( 10 ),
      NTYPPLNENI Short,
      CVYBERDMZ Char( 80 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'namzvyit',
   'namzvyit.adi',
   'NAMZVYI_01',
   'UPPER(CTYPVYKAZU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'namzvyit',
   'namzvyit.adi',
   'NAMZVYI_02',
   'UPPER(CTYPVYKAZU)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'namzvyit',
   'namzvyit.adi',
   'NAMZVYI_03',
   'UPPER(CTYPVYKAZU)+UPPER(CNAZRADVYK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'namzvyit',
   'namzvyit.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'namzvyit',
   'namzvyit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'namzvyit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'namzvyitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'namzvyit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'namzvyitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'namzvyit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'namzvyitfail');

CREATE TABLE o_uctosn ( 
      CUCET Char( 6 ),
      NUCET Integer,
      CNAZ_UCT Char( 30 ),
      CUCETTR Char( 1 ),
      NUCETTR Short,
      CUCETSK Char( 2 ),
      NUCETSK Short,
      CUCETSY Char( 3 ),
      NUCETSY Short,
      LNAKLSTR Logical,
      CZUSTUCT Char( 1 ),
      LVYNOSUCT Logical,
      LNAKLUCT Logical,
      LAKTIVUCT Logical,
      LPASIVUCT Logical,
      LZAVERUCT Logical,
      LPODRZUCT Logical,
      LNATURUCT Logical,
      LSALDOUCT Logical,
      LFINUCT Logical,
      LDANUCT Logical,
      LMIMORUCT Logical,
      LSYNTUCT Logical,
      CSKUPUCT Char( 90 ),
      MPOZ_UCT Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'o_uctosn',
   'o_uctosn.adi',
   'OUCOS_01',
   'UPPER(CUCET)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'o_uctosn',
   'o_uctosn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'o_uctosn', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'o_uctosnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'o_uctosn', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'o_uctosnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'o_uctosn', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'o_uctosnfail');

CREATE TABLE obdobiw ( 
      NROK Short,
      NOBDOBI Short);
EXECUTE PROCEDURE sp_CreateIndex( 
   'obdobiw',
   'obdobiw.adi',
   'OBDOBIW_1',
   'STRZERO(NROK, 4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'obdobiw',
   'obdobiw.adi',
   'OBDOBIW_2',
   'NOBDOBI',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'obdobiw', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'obdobiwfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'obdobiw', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'obdobiwfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'obdobiw', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'obdobiwfail');

CREATE TABLE obj_exp ( 
      NCISFIRMY Integer,
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CCISZAKAZ Double( 0 ),
      CNAZZBO Char( 50 ),
      CSKLPOL Char( 15 ),
      NMNOZOBODB Double( 2 ),
      DDATDOODB Date,
      NKCSBDOBJ Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCELKSLEV Double( 2 ),
      NMNOBTYD01 Double( 2 ),
      NMNOBTYD02 Double( 2 ),
      NMNOBTYD03 Double( 2 ),
      NMNOBTYD04 Double( 2 ),
      NMNOBTYD05 Double( 2 ),
      NMNOBTYD06 Double( 2 ),
      NMNOBTYD07 Double( 2 ),
      NMNOBTYD08 Double( 2 ),
      NMNOBTYD09 Double( 2 ),
      NMNOBTYD10 Double( 2 ),
      NMNOBTYD11 Double( 2 ),
      NMNOBTYD12 Double( 2 ),
      NMNOBTYD13 Double( 2 ),
      NMNOBTYD14 Double( 2 ),
      NMNOBTYD15 Double( 2 ),
      NMNOBTYD16 Double( 2 ),
      NMNOBTYD17 Double( 2 ),
      NMNOBTYD18 Double( 2 ),
      NMNOBTYD19 Double( 2 ),
      NMNOBTYD20 Double( 2 ),
      NMNOBTYD21 Double( 2 ),
      NMNOBTYD22 Double( 2 ),
      NMNOBTYD23 Double( 2 ),
      NMNOBTYD24 Double( 2 ),
      NMNOBTYD25 Double( 2 ),
      NMNOBTYD26 Double( 2 ),
      NMNOBTYD27 Double( 2 ),
      NMNOBTYD28 Double( 2 ),
      NMNOBTYD29 Double( 2 ),
      NMNOBTYD30 Double( 2 ),
      NMNOBTYD31 Double( 2 ),
      NMNOBTYD32 Double( 2 ),
      NMNOBTYD33 Double( 2 ),
      NMNOBTYD34 Double( 2 ),
      NMNOBTYD35 Double( 2 ),
      NMNOBTYD36 Double( 2 ),
      NMNOBTYD37 Double( 2 ),
      NMNOBTYD38 Double( 2 ),
      NMNOBTYD39 Double( 2 ),
      NMNOBTYD40 Double( 2 ),
      NMNOBTYD41 Double( 2 ),
      NMNOBTYD42 Double( 2 ),
      NMNOBTYD43 Double( 2 ),
      NMNOBTYD44 Double( 2 ),
      NMNOBTYD45 Double( 2 ),
      NMNOBTYD46 Double( 2 ),
      NMNOBTYD47 Double( 2 ),
      NMNOBTYD48 Double( 2 ),
      NMNOBTYD49 Double( 2 ),
      NMNOBTYD50 Double( 2 ),
      NMNOBTYD51 Double( 2 ),
      NMNOBTYD52 Double( 2 ),
      NMNOBTYD53 Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'obj_exp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'obj_expfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'obj_exp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'obj_expfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'obj_exp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'obj_expfail');

CREATE TABLE objhead ( 
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CUCET Char( 25 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 15 ),
      CPRIJEMCE2 Char( 15 ),
      CCINNOST Char( 15 ),
      CZKRATSTAT Char( 3 ),
      NCISLOBINT Integer,
      CCISLOBINT Char( 30 ),
      CCISOBJ Char( 15 ),
      DDATOBJ Date,
      DDATDOODB Date,
      CZKRTYPUHR Char( 5 ),
      CZKRZPUDOP Char( 15 ),
      CZKRATMENY Char( 3 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      CMISTOOBJ Char( 25 ),
      NPOCPOLOBJ Short,
      NKCSBDOBJ Double( 2 ),
      NKCSZDOBJ Double( 2 ),
      NKCSZDOBJZ Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NCISDEALER Integer,
      CNAZDEALER Char( 15 ),
      CNAZPRACOV Char( 15 ),
      CINTPRACOV Char( 25 ),
      LPOTVRZOBJ Logical,
      NKCSUHROBJ Double( 2 ),
      DDATUHROBJ Date,
      NCISODE Integer,
      CPOKROBJ Char( 1 ),
      NMNOZOBODB Double( 2 ),
      NMNOZPOODB Double( 2 ),
      NMNOZNEODB Double( 2 ),
      NMNOZPLODB Double( 2 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 1 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLHOT Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NKLICOBL Short,
      CZKRPRODEJ Char( 4 ),
      MPOZNOBJ Memo,
      CCISZAKAZ Char( 30 ),
      DDATODVVYR Date,
      NROK_OBJ Short,
      NPOR_OBJ Integer,
      NEXTOBJ Short,
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      NCISDODAVK Double( 0 ),
      DDATRVYKR Date,
      NHMOTNOST Double( 4 ),
      NOBJEM Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD0',
   'UPPER(CCISLOBINT) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD1',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD2',
   'DTOS ( DDATOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD3',
   'DTOS ( DDATDOODB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD4',
   'STRZERO(NROK_OBJ,4) +STRZERO(NPOR_OBJ,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD5',
   'STRZERO(NPOR_OBJ,5) +STRZERO(NROK_OBJ,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD6',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD7',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD8',
   'NICO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD9',
   'UPPER(CSIDLO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD10',
   'UPPER(CSIDLODOA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD11',
   'UPPER(CNAZPRACOV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD12',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD13',
   'NEXTOBJ',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'OBJHEAD14',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objhead',
   'objhead.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objhead', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objheadfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objhead', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objheadfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objhead', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objheadfail');

CREATE TABLE objit_02 ( 
      NCISFIRMY Integer,
      CCINNOST Char( 15 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CNAZZBO Char( 50 ),
      NKLICNAZ Integer,
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      NZBOZIKAT Short,
      NKLICDPH Short,
      CCISLVPINT Char( 10 ),
      DDATVPINT Date,
      LVICEVPINT Logical,
      NMNOZVPINT Double( 2 ),
      NCENAPRINT Double( 2 ),
      CCISSKLAD Char( 8 ),
      CCISLOBDOD Char( 15 ),
      DDATOBDOD Date,
      NMNOZOBDOD Double( 2 ),
      NMNOZPODOD Double( 2 ),
      DDATPODOD Date,
      NMNOZKODOD Double( 2 ),
      NCENNAODOD Double( 2 ),
      NCENPRODOD Double( 2 ),
      DDATPRDOD Date,
      NCENNAPDOD Double( 2 ),
      NMNOZPRDOD Double( 2 ),
      NMNOZOBODB Double( 2 ),
      NMNOZPOODB Double( 2 ),
      NMNOZPDODB Double( 2 ),
      CMNOZPOODB Char( 1 ),
      NMNOZNEODB Double( 2 ),
      DDATREODB Date,
      DDATDOODB Date,
      NMNOZREODB Double( 2 ),
      NMNOZPLODB Double( 2 ),
      NKCSBDOBJ Double( 2 ),
      NKCSZDOBJ Double( 2 ),
      NCENADLODB Double( 2 ),
      NINTINDOBJ Short,
      CCISZAKAZ Char( 30 ),
      CZKRATJEDN Char( 3 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 1 ),
      NPROCSLFAO Double( 1 ),
      LPROCSLFAO Logical,
      NPROCSLHOT Double( 1 ),
      NPROCSLMNO Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NCELKSLEV Double( 2 ),
      NKLICOBL Short,
      CZKRPRODEJ Char( 4 ),
      NPODILPROD Double( 2 ),
      NMNPOTVYR Double( 2 ),
      NMNPUSVYR Double( 2 ),
      DPUSVYR Date,
      NMNPRIVYR Double( 2 ),
      DPRIVYR Date,
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CSTRED Char( 8 ),
      NRAVYSKA Double( 3 ),
      NRBSIRKA Double( 3 ),
      LPOZVYROBA Logical,
      NMNKALKUL Double( 2 ),
      NDELKA Double( 2 ),
      NPOCET Double( 2 ),
      NPOZICE Short,
      NMNNAKUS Double( 3 ),
      CTEXT1 Char( 30 ),
      CTEXT2 Char( 30 ),
      NROKRV Short,
      NPOLOBJRV Double( 0 ),
      DDATODVVYR Date,
      CPOPPOLOBJ Char( 30 ),
      NUCETSKUP Short,
      AULOZENI Memo,
      DREZERV Date,
      CREZERV Char( 8 ),
      NNAVYSPRC Double( 2 ),
      NKUSROZ Double( 3 ),
      NCISOPER Short,
      NMNVOLVYRO Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'objit_02',
   'objit_02.adi',
   'OBJ02_1',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_02', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objit_02fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_02', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objit_02fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_02', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objit_02fail');

CREATE TABLE objit_03 ( 
      NCISFIRMY Integer,
      CCINNOST Char( 15 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CNAZZBO Char( 50 ),
      NKLICNAZ Integer,
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      NZBOZIKAT Short,
      NKLICDPH Short,
      CCISLVPINT Char( 10 ),
      DDATVPINT Date,
      LVICEVPINT Logical,
      NMNOZVPINT Double( 2 ),
      NCENAPRINT Double( 2 ),
      CCISSKLAD Char( 8 ),
      CCISLOBDOD Char( 15 ),
      DDATOBDOD Date,
      NMNOZOBDOD Double( 2 ),
      NMNOZPODOD Double( 2 ),
      DDATPODOD Date,
      NMNOZKODOD Double( 2 ),
      NCENNAODOD Double( 2 ),
      NCENPRODOD Double( 2 ),
      DDATPRDOD Date,
      NCENNAPDOD Double( 2 ),
      NMNOZPRDOD Double( 2 ),
      NMNOZOBODB Double( 2 ),
      NMNOZPOODB Double( 2 ),
      NMNOZPDODB Double( 2 ),
      CMNOZPOODB Char( 1 ),
      NMNOZNEODB Double( 2 ),
      DDATREODB Date,
      DDATDOODB Date,
      NMNOZREODB Double( 2 ),
      NMNOZPLODB Double( 2 ),
      NKCSBDOBJ Double( 2 ),
      NKCSZDOBJ Double( 2 ),
      NCENADLODB Double( 2 ),
      NINTINDOBJ Short,
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CZKRATJEDN Char( 3 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 1 ),
      NPROCSLFAO Double( 1 ),
      LPROCSLFAO Logical,
      NPROCSLHOT Double( 1 ),
      NPROCSLMNO Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NCELKSLEV Double( 2 ),
      NKLICOBL Short,
      CZKRPRODEJ Char( 4 ),
      NPODILPROD Double( 2 ),
      NMNPOTVYR Double( 2 ),
      NMNPUSVYR Double( 2 ),
      DPUSVYR Date,
      NMNPRIVYR Double( 2 ),
      DPRIVYR Date,
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CSTRED Char( 8 ),
      NRAVYSKA Double( 3 ),
      NRBSIRKA Double( 3 ),
      LPOZVYROBA Logical,
      NMNKALKUL Double( 2 ),
      NDELKA Double( 2 ),
      NPOCET Double( 2 ),
      NPOZICE Short,
      NMNNAKUS Double( 3 ),
      CTEXT1 Char( 30 ),
      CTEXT2 Char( 30 ),
      NROKRV Short,
      NPOLOBJRV Double( 0 ),
      DDATODVVYR Date,
      CPOPPOLOBJ Char( 30 ),
      NUCETSKUP Short,
      AULOZENI Memo,
      DREZERV Date,
      CREZERV Char( 8 ),
      NNAVYSPRC Double( 2 ),
      NKUSROZ Double( 3 ),
      NCISOPER Short,
      NMNOZPOZAD Double( 2 ),
      NMNOZSZBO Double( 2 ),
      NMNOZOZBO Double( 2 ),
      NMNPOZKUMU Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'objit_03',
   'objit_03.adi',
   'OBJIT1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATDOODB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_03', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objit_03fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_03', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objit_03fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_03', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objit_03fail');

CREATE TABLE objit_at ( 
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CNAZZBO Char( 50 ),
      CSKLPOL Char( 15 ),
      CCISSKLAD Char( 8 ),
      NMNOZOBDOD Double( 2 ),
      NMNOZOBDOR Double( 2 ),
      NMNOZKODOD Double( 2 ),
      NMNOZOBSKL Double( 2 ),
      NMNOZZUOBJ Double( 2 ),
      DDATREODB Date,
      DDATDOODB Date,
      NOBJIT_OR Double( 0 ),
      NVZTAH_OR Double( 0 ),
      CCISZAKAZ Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'objit_at',
   'objit_at.adi',
   'OBJITAT0',
   'DTOS(DDATREODB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objit_at',
   'objit_at.adi',
   'OBJITAT1',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objit_at',
   'objit_at.adi',
   'OBJITAT2',
   'UPPER(CCISLOBINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objit_at',
   'objit_at.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_at', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objit_atfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_at', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objit_atfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objit_at', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objit_atfail');

CREATE TABLE objitem ( 
      NDOKLAD Double( 0 ),
      NEXTOBJ Short,
      NCISFIRMY Integer,
      CCINNOST Char( 15 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CNAZZBO Char( 50 ),
      NKLICNAZ Integer,
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      NZBOZIKAT Short,
      NKLICDPH Short,
      CCISLVPINT Char( 10 ),
      DDATVPINT Date,
      LVICEVPINT Logical,
      NMNOZVPINT Double( 2 ),
      NCENAPRINT Double( 2 ),
      CCISSKLAD Char( 8 ),
      CCISLOBDOD Char( 15 ),
      DDATOBDOD Date,
      NMNOZOBDOD Double( 2 ),
      NMNOZPODOD Double( 2 ),
      DDATPODOD Date,
      NMNOZKODOD Double( 2 ),
      NCENNAODOD Double( 2 ),
      NCENPRODOD Double( 2 ),
      DDATPRDOD Date,
      NCENNAPDOD Double( 2 ),
      NMNOZPRDOD Double( 2 ),
      NMNOZOBODB Double( 2 ),
      NMNOZPOODB Double( 2 ),
      NMNOZPDODB Double( 2 ),
      CMNOZPOODB Char( 1 ),
      NMNOZNEODB Double( 2 ),
      DDATREODB Date,
      DDATDOODB Date,
      NMNOZREODB Double( 2 ),
      NMNOZPLODB Double( 2 ),
      NKCSBDOBJ Double( 2 ),
      NKCSZDOBJ Double( 2 ),
      NCENADLODB Double( 2 ),
      NINTINDOBJ Short,
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      NCISLPOLZA Integer,
      CZKRATJEDN Char( 3 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 4 ),
      NPROCSLFAO Double( 4 ),
      LPROCSLFAO Logical,
      NPROCSLHOT Double( 4 ),
      NPROCSLMNO Double( 4 ),
      NHODNSLEV Double( 4 ),
      NCENAZAKL Double( 2 ),
      NCELKSLEV Double( 4 ),
      NKLICOBL Short,
      CZKRPRODEJ Char( 4 ),
      NPODILPROD Double( 2 ),
      NMNPOTVYR Double( 2 ),
      NMNPUSVYR Double( 2 ),
      DPUSVYR Date,
      NMNPRIVYR Double( 2 ),
      DPRIVYR Date,
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CSTRED Char( 8 ),
      NRAVYSKA Double( 3 ),
      NRBSIRKA Double( 3 ),
      LPOZVYROBA Logical,
      NMNKALKUL Double( 2 ),
      NDELKA Double( 2 ),
      NPOCET Double( 2 ),
      NPOZICE Short,
      NMNNAKUS Double( 3 ),
      CTEXT1 Char( 30 ),
      CTEXT2 Char( 30 ),
      NROKRV Short,
      NPOLOBJRV Double( 0 ),
      DDATODVVYR Date,
      CPOPPOLOBJ Char( 30 ),
      NUCETSKUP Short,
      AULOZENI Memo,
      DREZERV Date,
      CREZERV Char( 8 ),
      NNAVYSPRC Double( 2 ),
      NKUSROZ Double( 3 ),
      NCISOPER Short,
      NPOCCEZAPZ Short,
      CKODPOZ Char( 3 ),
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      NCISDODAVK Double( 0 ),
      NMNOZSZBO Double( 2 ),
      NMNOZKZBO Double( 2 ),
      NMNOZOZBO Double( 2 ),
      NMNOZRZBO Double( 2 ),
      NMNOZDZBO Double( 2 ),
      NCISVYSFAK Double( 0 ),
      CDOPLNTXT Char( 50 ),
      NMNOZ_FAKT Double( 4 ),
      NSTAV_FAKT Short,
      NMNOZ_DLVY Double( 4 ),
      NMNOZ_OBJP Double( 4 ),
      NMNOZ_EXPL Double( 4 ),
      NMNOZ_ZAK Double( 4 ),
      DDATRVYKR Date,
      NHMOTNOSTJ Double( 4 ),
      NOBJEMJ Double( 4 ),
      NHMOTNOST Double( 4 ),
      NOBJEM Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM0',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM1',
   'UPPER(CSKLPOL) +UPPER(CCISLOBINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATREODB) +UPPER(CCISLOBINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM4',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATOBDOD) +UPPER(CCISLOBINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM5',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM6',
   'NMNOZVPINT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM7',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CVYRPOL) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM8',
   'UPPER(CCISZAKAZ) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITEM9',
   'UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE10',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE11',
   'STRZERO(NROKRV,4) +STRZERO(NPOLOBJRV,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE12',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE13',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE14',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +STRZERO(NUCETSKUP,3) +UPPER(CVYRPOL) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE15',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CCISSKLAD) +UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE16',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE17',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISZAKAZI) +STRZERO(NCISLPOLZA,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE18',
   'UPPER(CCISZAKAZI) +STRZERO(NCISLPOLZA,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE19',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE20',
   'STRZERO(NZBOZIKAT,4) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE21',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE22',
   'UPPER(CCISLOBINT) +STRZERO(NZBOZIKAT,4) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE23',
   'NSTAV_FAKT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'OBJITE24',
   'STRZERO(NDOKLAD,10) +STRZERO(NSTAV_FAKT,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objitem',
   'objitem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objitem', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objitemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objitem', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objitemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objitem', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objitemfail');

CREATE TABLE objvyshd ( 
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CUCET Char( 25 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 15 ),
      CPRIJEMCE2 Char( 15 ),
      CCINNOST Char( 15 ),
      CZKRATSTAT Char( 3 ),
      CCISOBJ Char( 15 ),
      NCISOBJ Integer,
      DDATOBJ Date,
      DDATTISK Date,
      CZKRTYPUHR Char( 5 ),
      CZKRZPUDOP Char( 10 ),
      CMISTOOBJ Char( 25 ),
      NPOCPOLOBJ Integer,
      NMNOZOBDOD Double( 2 ),
      NMNOZPODOD Double( 2 ),
      NMNOZPLDOD Double( 2 ),
      NKCBDOBJ Double( 2 ),
      NKCZDOBJ Double( 2 ),
      NKCZDOBJZ Double( 2 ),
      NCISDEALER Integer,
      CNAZDEALER Char( 15 ),
      CNAZPRACOV Char( 25 ),
      CINTPRACOV Char( 25 ),
      LPOTVRZOBJ Logical,
      NKCUHROBJ Double( 2 ),
      DDATUHROBJ Date,
      CPOKROBJ Char( 1 ),
      CZAKOBJINT Char( 15 ),
      DTERMDOD Date,
      CZKRATMENY Char( 3 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      MPOZNOBJ Memo,
      NROK_OBJ Short,
      NPOR_OBJ Integer,
      NHMOTNOST Double( 4 ),
      NOBJEM Double( 4 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH1',
   'UPPER(CCISOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH2',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH3',
   'DTOS ( DDATOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH4',
   'STRZERO(NROK_OBJ,4) +STRZERO(NPOR_OBJ,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH5',
   'UPPER(CZAKOBJINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH6',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH7',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objvyshd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objvyshdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objvyshd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objvyshdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objvyshd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objvyshdfail');

CREATE TABLE objvysit ( 
      NDOKLAD Double( 0 ),
      NCISFIRMY Integer,
      CCISOBJ Char( 15 ),
      CCISSKLAD Char( 8 ),
      CPOLCEN Char( 1 ),
      NINTCOUNT Integer,
      CNAZZBO Char( 50 ),
      CSKLPOL Char( 15 ),
      NZBOZIKAT Short,
      CKATCZBO Char( 15 ),
      CJAKOST Char( 10 ),
      NKLICDPH Short,
      CZKRATJEDN Char( 3 ),
      CZKRATMENY Char( 3 ),
      DDATOBDOD Date,
      NMNOZOBDOD Double( 2 ),
      NMNOZPODOD Double( 2 ),
      NMNOZPLDOD Double( 2 ),
      NMNOZOBODB Double( 2 ),
      NMNOZOBSKL Double( 2 ),
      NKCBDOBJ Double( 2 ),
      NKCZDOBJ Double( 2 ),
      DDATPODOD Date,
      NCENNAODOD Double( 4 ),
      NCENPRODOD Double( 2 ),
      DDATPRDOD Date,
      NCENNAPDOD Double( 2 ),
      NMNOZPRDOD Double( 2 ),
      NMNOZPOODB Double( 2 ),
      CMNOZPOODB Char( 1 ),
      CCISLDLODB Char( 10 ),
      DDATDLODB Date,
      CCISFAODB Char( 10 ),
      DDATFAODB Date,
      LVICFAODB Logical,
      NMNOZFAODB Double( 2 ),
      NMNOZ_FAKT Double( 4 ),
      NSTAV_FAKT Short,
      NINTINDOBJ Short,
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      DTERMDOD Date,
      NHMOTNOSTJ Double( 4 ),
      NOBJEMJ Double( 4 ),
      NHMOTNOST Double( 4 ),
      NOBJEM Double( 4 ),
      CDOPLNTXT Char( 100 ),
      MPOZNOBJ Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI1',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISOBJ) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI2',
   'UPPER(CCISOBJ) +STRZERO(NCISFIRMY,5) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI3',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI4',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI5',
   'UPPER(CCISOBJ) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI6',
   'UPPER(CCISZAKAZI) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI7',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI8',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objvysit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objvysitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objvysit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objvysitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objvysit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objvysitfail');

CREATE TABLE objzak ( 
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      NMNPOTVYRZ Double( 2 ),
      DTERMPOVYR Date,
      NMNOZDODVY Double( 2 ),
      CCISZAKAZ Char( 30 ),
      MPOZNOBZAK Memo,
      CSTAVVAZBY Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'objzak',
   'objzak.adi',
   'OBJZAK1',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5) +DTOS (DTERMPOVYR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objzak',
   'objzak.adi',
   'OBJZAK2',
   'UPPER(CCISZAKAZ) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objzak',
   'objzak.adi',
   'OBJZAK3',
   'DTOS (DTERMPOVYR) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objzak',
   'objzak.adi',
   'OBJZAK4',
   'DTOS(DTERMPOVYR) +UPPER(CCISZAKAZ) +STRZERO(NMNPOTVYRZ,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objzakfail');

CREATE TABLE objzakr ( 
      CCISZAKAZ Char( 30 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      DDATODVVYR Date,
      NMNPOTVYRZ Double( 4 ),
      NMNOZVPINT Double( 4 ),
      NMNOZDODVY Double( 4 ),
      NMNPRIJATO Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'objzakr',
   'objzakr.adi',
   'OBJZAR1',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'objzakr',
   'objzakr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'objzakr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'objzakrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objzakr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'objzakrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'objzakr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'objzakrfail');

CREATE TABLE odesnhe ( 
      NCISFIRMY Integer,
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NCISODES Integer,
      CNAZODES Char( 15 ),
      DDATODES Date,
      NOSVODDAN Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CNAZPRACOV Char( 15 ),
      CZKRPRACOV Char( 3 ),
      MPOZNODES Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnhe',
   'odesnhe.adi',
   'ODESNHE0',
   'UPPER(CNAZODES) +STRZERO(NCISFIRMY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnhe',
   'odesnhe.adi',
   'ODESNHE1',
   'STRZERO(NCISFIRMY) +UPPER(CNAZODES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnhe',
   'odesnhe.adi',
   'ODESNHE2',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnhe',
   'odesnhe.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnhe', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'odesnhefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnhe', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'odesnhefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnhe', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'odesnhefail');

CREATE TABLE odesnit ( 
      NCISFIRMY Integer,
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      CZKRATJEDN Char( 3 ),
      NCISODES Integer,
      NPORODES Short,
      NITMODES Integer,
      DDATODES Date,
      CNAZZBO Char( 50 ),
      NKLICNAZ Integer,
      NZBOZIKAT Short,
      NMNOZNODES Double( 2 ),
      NCENJEDNAK Double( 2 ),
      NCENJEDZAK Double( 2 ),
      NCENJEDZAD Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENZAKCED Double( 2 ),
      NKLICDPH Short,
      NRECNAB Integer,
      NRECZBO Integer,
      MPOZNODES Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT0',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +STRZERO(NPORODES) +STRZERO(NITMODES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT1',
   'UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT2',
   'NCISODES',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT3',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT4',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +STRZERO(NZBOZIKAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT5',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT6',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnit',
   'odesnit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'odesnitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'odesnitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'odesnitfail');

CREATE TABLE odesnro ( 
      NCISFIRMY Integer,
      NCISODES Integer,
      NPORODES Short,
      NOSVODDAN Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CPOPIS Char( 40 ),
      MPOZNODES Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnro',
   'odesnro.adi',
   'ODESNRO0',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +STRZERO(NPORODES)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnro',
   'odesnro.adi',
   'ODESNRO1',
   'NPORODES',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odesnro',
   'odesnro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnro', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'odesnrofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnro', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'odesnrofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odesnro', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'odesnrofail');

CREATE TABLE odvsoz ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CPRACOVNIK Char( 30 ),
      CPRACZAR Char( 8 ),
      NZAKLSOCZ Double( 2 ),
      NODVSOCZ Double( 2 ),
      NZAKLZDRZ Double( 2 ),
      NODVZDRZ Double( 2 ),
      NZAKLSOCP Double( 2 ),
      NZAKLZDRP Double( 2 ),
      NODVSOCP Double( 2 ),
      NODVZDRP Double( 2 ),
      NCISPRIJ Double( 2 ),
      NZAKLSOCR Double( 2 ),
      NZAKLZDRR Double( 2 ),
      NODVSOCR Double( 2 ),
      NODVZDRR Double( 2 ),
      NZDRPOJIS Short,
      NRODCIPRAC Double( 0 ),
      NKALDNY Double( 1 ),
      NKALDNYNV Double( 1 ),
      NKALDNYABS Double( 1 ),
      NKALDNYDOZ Short,
      NKALDNYODK Short,
      NNEMDNY Double( 1 ),
      NHRUBA_MZD Double( 2 ),
      NZAKLCELS Double( 2 ),
      NODVCELS Double( 2 ),
      NODVORGS Double( 2 ),
      NODVPOJS Double( 2 ),
      NZAKLCELZ Double( 2 ),
      NODVCELZ Double( 2 ),
      NODVORGZ Double( 2 ),
      NODVPOJZ Double( 2 ),
      NPENZPODU Double( 2 ),
      CJMENOTRID Char( 35 ),
      NZENA Short,
      NMUZ Short,
      NDRUHCINS Short,
      CZKRTYPZAV Char( 5 ),
      DDATVYPL Date,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'odvsoz',
   'odvsoz.adi',
   'ODVSZ_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odvsoz',
   'odvsoz.adi',
   'ODVSZ_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odvsoz',
   'odvsoz.adi',
   'ODVSZ_03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odvsoz',
   'odvsoz.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odvsoz',
   'odvsoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'odvsoz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'odvsozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odvsoz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'odvsozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odvsoz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'odvsozfail');

CREATE TABLE odvzak ( 
      CCISZAKAZ Char( 30 ),
      NCISLOKUSU Integer,
      DDATUMODV Date,
      CCASODV Char( 8 ),
      NMNOZODVED Double( 2 ),
      NMNOZFAKT Double( 2 ),
      CSTAVZAKAZ Char( 2 ),
      CVYROBCISL Char( 40 ),
      CTEXT Char( 40 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'odvzak',
   'odvzak.adi',
   'ODVZAK1',
   'UPPER(CCISZAKAZ) +STRZERO(NCISLOKUSU,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'odvzak',
   'odvzak.adi',
   'ODVZAK2',
   'UPPER(CCISZAKAZ) +DTOS (DDATUMODV) +UPPER(CCASODV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'odvzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'odvzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odvzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'odvzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'odvzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'odvzakfail');

CREATE TABLE operace ( 
      COZNOPER Char( 10 ),
      CTYPOPER Char( 3 ),
      CNAZOPER Char( 30 ),
      CNAZPOL6 Char( 8 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      NDRUHMZDY Short,
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      CKVALNORM Char( 2 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NKOEFSMCAS Double( 3 ),
      NKOEFVIST Double( 3 ),
      NKOEFVIOB Double( 3 ),
      MTEXTOPER Memo,
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      LVYKAZML Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'operace',
   'operace.adi',
   'OPER1',
   'UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'operace',
   'operace.adi',
   'OPER2',
   'UPPER(CTARIFSTUP) +UPPER(CTARIFTRID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'operace',
   'operace.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'operace', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'operacefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'operace', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'operacefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'operace', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'operacefail');

CREATE TABLE opertree ( 
      CTREETEXT Char( 70 ),
      CTYPPOL Char( 3 ),
      CCISZAKAZ Char( 30 ),
      CFINVYR Char( 15 ),
      NFINVAR Short,
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CVARPOP Char( 20 ),
      CSKLPOL Char( 15 ),
      CNAZZBO Char( 50 ),
      CNAZEV Char( 30 ),
      CZKRATJEDN Char( 3 ),
      CVYSPOL Char( 15 ),
      NVYSVAR Short,
      CVYSVARPOP Char( 20 ),
      CNAZEVVYS Char( 30 ),
      CNIZPOL Char( 15 ),
      NNIZVAR Short,
      CNAZEVNIZ Char( 30 ),
      NSPMNONANI Double( 6 ),
      NVYRST Short,
      NPOZICE Short,
      NVARPOZ Short,
      CTREEKEY Char( 25 ),
      NSPMNO Double( 6 ),
      NSPMNONAS Double( 6 ),
      NCIMNO Double( 6 ),
      NCIMNONAS Double( 6 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      NKUSOVCAS Double( 4 ),
      NCELKKUSCA Double( 4 ),
      NKCNAOPER Double( 3 ),
      NKCNAKOOP Double( 3 ),
      CNAZOPER Char( 25 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CTEXT1 Char( 40 ),
      CTEXT2 Char( 40 ),
      CTEXT3 Char( 40 ),
      LNAKPOL Logical,
      NTRANMNOZ Double( 3 ),
      MTEXTOPER Memo,
      NPRIPRCAS Double( 2 ),
      NKOEFKUSCA Double( 4 ),
      NSPMNOZAK Double( 6 ),
      NMNSKJEZAK Double( 6 ),
      NPOCRADKU Short,
      CPLUS Char( 1 ),
      NNHCELK Double( 3 ),
      NKCCELK Double( 3 ),
      CVYSSIPOL Char( 15 ),
      NVYSSIVAR Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'opertree',
   'opertree.adi',
   'OPTREE1',
   'CTREEKEY +UPPER(CVYRPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'opertree',
   'opertree.adi',
   'OPTREE2',
   'UPPER(CNAZZBO) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'opertree',
   'opertree.adi',
   'OPTREE3',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVYSVAR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'opertree',
   'opertree.adi',
   'OPTREE4',
   'CTREEKEY +UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'opertree',
   'opertree.adi',
   'OPTREE5',
   'UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'opertree',
   'opertree.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'opertree', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'opertreefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'opertree', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'opertreefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'opertree', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'opertreefail');

CREATE TABLE opistxt ( 
      NRADEK Integer,
      CTEXT Char( 100 ),
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'opistxt',
   'opistxt.adi',
   'OPISTXT_01',
   'NRADEK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'opistxt',
   'opistxt.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'opistxt', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'opistxtfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'opistxt', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'opistxtfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'opistxt', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'opistxtfail');

CREATE TABLE osoby ( 
      NCISOSOBY Integer,
      NOSCISPRAC Integer,
      CPRIJOSOB Char( 20 ),
      CJMENOOSOB Char( 15 ),
      COSOBA Char( 50 ),
      CTITULPRED Char( 15 ),
      CTITULZA Char( 15 ),
      CJMENOROD Char( 25 ),
      CULICE Char( 25 ),
      CCISPOPIS Char( 10 ),
      CULICCIPOP Char( 35 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CZKRATNAR Char( 15 ),
      CZKRSTAPRI Char( 25 ),
      DDATNAROZ Date,
      CRODCISOSB Char( 13 ),
      CPOHLAVI Char( 4 ),
      NMUZ Short,
      NZENA Short,
      CTELEFON Char( 20 ),
      CEMAIL Char( 50 ),
      CFUNPRA Char( 8 ),
      LPRI_ZAL Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'osoby',
   'osoby.adi',
   'OSOBY01',
   'NCISOSOBY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'osoby',
   'osoby.adi',
   'OSOBY02',
   'UPPER(COSOBA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'osoby',
   'osoby.adi',
   'OSOBY03',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'osoby',
   'osoby.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'osoby', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'osobyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'osoby', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'osobyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'osoby', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'osobyfail');

CREATE TABLE parprzal ( 
      CULOHA Char( 1 ),
      NCISFAK Double( 0 ),
      NORDITEM Integer,
      CTEXTFAKT Char( 33 ),
      NCISZALFAK Double( 0 ),
      CVARZALFAK Char( 15 ),
      CUCTZALFAK Char( 6 ),
      NCENZALFAK Double( 2 ),
      NCENZAHFAK Double( 2 ),
      NUHRZALFAK Double( 2 ),
      NUHRZAHFAK Double( 2 ),
      DUHRZALFAK Date,
      NPARZALFAK Double( 2 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      NRECPAR Double( 0 ),
      NRECFAZ Double( 0 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'parprzal',
   'parprzal.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'parprzal',
   'parprzal.adi',
   'FODBHD2',
   'NCISZALFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'parprzal',
   'parprzal.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'parprzal', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'parprzalfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'parprzal', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'parprzalfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'parprzal', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'parprzalfail');

CREATE TABLE parvyzal ( 
      NCISFAK Double( 0 ),
      NCISZALFAK Double( 0 ),
      NCENZALFAK Double( 2 ),
      NCENZAHFAK Double( 2 ),
      NUHRZALFAK Double( 2 ),
      NUHRZAHFAK Double( 2 ),
      DUHRZALFAK Date,
      NPARZALFAK Double( 2 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'parvyzal',
   'parvyzal.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'parvyzal',
   'parvyzal.adi',
   'FODBHD2',
   'NCISZALFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'parvyzal',
   'parvyzal.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'parvyzal', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'parvyzalfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'parvyzal', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'parvyzalfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'parvyzal', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'parvyzalfail');

CREATE TABLE parzak ( 
      CATRIB Char( 20 ),
      CATRIBNAZ Char( 30 ),
      MPOZNAMKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'parzak',
   'parzak.adi',
   'PARZAK_1',
   'UPPER(CATRIB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'parzak',
   'parzak.adi',
   'PARZAK_2',
   'UPPER(CATRIBNAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'parzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'parzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'parzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'parzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'parzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'parzakfail');

CREATE TABLE persitem ( 
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CRODCISPRA Char( 13 ),
      CPRACOVNIK Char( 43 ),
      NORDITEM Integer,
      DDATPREDKO Date,
      COBLASTTYP Char( 1 ),
      NPORADI Short,
      CZKRATKA Char( 8 ),
      DDATUSKUKO Date,
      DDATUKONCE Date,
      CZKRATKAUK Char( 8 ),
      NDELKA Integer,
      CZKRATJED2 Char( 3 ),
      NCISFIRMY Integer,
      CNAZEV Char( 35 ),
      CZKRAT Char( 10 ),
      CULICE Char( 25 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CPROVEDLOS Char( 30 ),
      CKONTAKTOS Char( 30 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      CCISOSVEDC Char( 15 ),
      NORDITEMTM Integer,
      CTMKMSTRPR Char( 8 ),
      LUSKUTECN Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_02',
   'UPPER(CRODCISPRA) +STRZERO(NORDITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_03',
   'UPPER(CRODCISPRA) +STRZERO(NORDITEMTM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_05',
   'UPPER(CRODCISPRA) +UPPER(COBLASTTYP) +STRZERO(NPORADI,3) +DTOS (DDATPREDKO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_06',
   'NORDITEM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_07',
   'NORDITEMTM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_08',
   'UPPER(CRODCISPRA) +STRZERO(NORDITEMTM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_09',
   'DTOS ( DDATPREDKO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_10',
   'IF (LUSKUTECN, ''1'', ''0'') +UPPER(CRODCISPRA) +STRZERO(NORDITEMTM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'PERSI_11',
   'IF (LUSKUTECN, ''1'', ''0'') +DTOS (DDATPREDKO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'persitem',
   'persitem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'persitem', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'persitemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'persitem', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'persitemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'persitem', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'persitemfail');

CREATE TABLE personal ( 
      CNAZPOL1 Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      NCISOSOBY Integer,
      CPRIJPRAC Char( 20 ),
      CJMENOPRAC Char( 15 ),
      CPRACOVNIK Char( 50 ),
      CTITULPRAC Char( 15 ),
      CJMENOROD Char( 25 ),
      CULICE Char( 25 ),
      CCISPOPIS Char( 10 ),
      CULICCIPOP Char( 35 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CPREULICE Char( 25 ),
      CPRECISPOP Char( 10 ),
      CPREULICPO Char( 35 ),
      CPREMISTO Char( 25 ),
      CPREPSC Char( 6 ),
      CZKRSTATPR Char( 3 ),
      CZKRATNAR Char( 15 ),
      CZKRSTAPRI Char( 25 ),
      CRODCISPRA Char( 13 ),
      CRODCISPRN Char( 10 ),
      DDATNAROZ Date,
      CMISTONAR Char( 30 ),
      CZKRSTATNA Char( 3 ),
      CCISLOOP Char( 15 ),
      CCISLOPASU Char( 15 ),
      CPOHLAVI Char( 4 ),
      NMUZ Short,
      NZENA Short,
      CZKRRODSTV Char( 8 ),
      CZKRMANSTV Char( 8 ),
      CZKRVZDEL Char( 8 ),
      CTELPRIV Char( 15 ),
      CTELZAMES Char( 15 ),
      CTELMOBIL Char( 15 ),
      CEMAIL Char( 25 ),
      CIDOSKARTY Char( 25 ),
      NPOCLPRAXE Integer,
      NKLASZAM Integer,
      LEVIDDIM Logical,
      LVEDPRAC Logical,
      NTYPDUCHOD Short,
      CDRUPRAVZT Char( 8 ),
      CVZNPRAVZT Char( 10 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      DDATVZNPRV Date,
      DDATNAST Date,
      DDATVYST Date,
      DDATPREDVY Date,
      NTYPUKOPRV Short,
      NPORVEDCIN Short,
      NTYPVEDCIN Short,
      DDATVZNVEC Date,
      DDATNASTVC Date,
      DDATVYSTVC Date,
      DDATPREDVC Date,
      NTYPUKOVEC Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CFUNPRA Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CVYPLMIST Char( 8 ),
      LSTAVEM Logical,
      LODBORAR Logical,
      LPRUKAZZPS Logical,
      CPRUKAZZPS Char( 8 ),
      CTMKMSTRPR Char( 8 ),
      NVEVIDENCI Short,
      LEXISTSKOL Logical,
      LEXISTVZDE Logical,
      LEXISTLEPR Logical,
      CPOZNAMKA1 Memo,
      CPOZNAMKA2 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'personal',
   'personal.adi',
   'PERSO_01',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'personal',
   'personal.adi',
   'PERSO_02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'personal',
   'personal.adi',
   'PERSO_03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'personal',
   'personal.adi',
   'PERSO_04',
   'UPPER(CIDOSKARTY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'personal',
   'personal.adi',
   'PERSO_05',
   'UPPER(CKMENSTRPR) +UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'personal',
   'personal.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'personal', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'personalfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'personal', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'personalfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'personal', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'personalfail');

CREATE TABLE pln_objs ( 
      NCISFIRMY Integer,
      CCISOBJ Char( 15 ),
      CCISSKLAD Char( 8 ),
      CPOLCEN Char( 1 ),
      NINTCOUNT Integer,
      CNAZZBO Char( 50 ),
      CSKLPOL Char( 15 ),
      NZBOZIKAT Short,
      CKATCZBO Char( 15 ),
      NKLICDPH Short,
      CZKRATJEDN Char( 3 ),
      CZKRATMENY Char( 3 ),
      DDATOBDOD Date,
      NMNOZOBDOD Double( 2 ),
      NMNOZPODOD Double( 2 ),
      NMNOZPLDOD Double( 2 ),
      NMNOZOBODB Double( 2 ),
      NMNOZOBSKL Double( 2 ),
      NKCBDOBJ Double( 2 ),
      NKCZDOBJ Double( 2 ),
      DDATPODOD Date,
      NCENNAODOD Double( 4 ),
      NCENPRODOD Double( 2 ),
      DDATPRDOD Date,
      NCENNAPDOD Double( 2 ),
      NMNOZPRDOD Double( 2 ),
      NMNOZPOODB Double( 2 ),
      CMNOZPOODB Char( 1 ),
      CCISLDLODB Char( 10 ),
      DDATDLODB Date,
      CCISFAODB Char( 10 ),
      DDATFAODB Date,
      LVICFAODB Logical,
      NMNOZFAODB Double( 2 ),
      NINTINDOBJ Short,
      DTERMDOD Date,
      MPOZNOBJ Memo,
      NORDITEM Integer,
      NMNOZVYDOB Double( 2 ),
      CZAKOBJINT Char( 15 ),
      CCISZAKAZ Char( 15 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pln_objs',
   'pln_objs.adi',
   'PLNOBJ1',
   'STRZERO(NCISFIRMY) +UPPER(CCISOBJ) +STRZERO(NINTCOUNT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pln_objs', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pln_objsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pln_objs', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pln_objsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pln_objs', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pln_objsfail');

CREATE TABLE pln_objv ( 
      NCISFIRMY Integer,
      CCISOBJ Char( 15 ),
      CCISSKLAD Char( 8 ),
      CPOLCEN Char( 1 ),
      NINTCOUNT Integer,
      CNAZZBO Char( 50 ),
      CSKLPOL Char( 15 ),
      NZBOZIKAT Short,
      CKATCZBO Char( 15 ),
      NKLICDPH Short,
      CZKRATJEDN Char( 3 ),
      CZKRATMENY Char( 3 ),
      DDATOBDOD Date,
      NMNOZOBDOD Double( 2 ),
      NMNOZPODOD Double( 2 ),
      NMNOZPLDOD Double( 2 ),
      NMNOZOBODB Double( 2 ),
      NMNOZOBSKL Double( 2 ),
      NKCBDOBJ Double( 2 ),
      NKCZDOBJ Double( 2 ),
      DDATPODOD Date,
      NCENNAODOD Double( 4 ),
      NCENPRODOD Double( 2 ),
      DDATPRDOD Date,
      NCENNAPDOD Double( 2 ),
      NMNOZPRDOD Double( 2 ),
      NMNOZPOODB Double( 2 ),
      CMNOZPOODB Char( 1 ),
      CCISLDLODB Char( 10 ),
      DDATDLODB Date,
      CCISFAODB Char( 10 ),
      DDATFAODB Date,
      LVICFAODB Logical,
      NMNOZFAODB Double( 2 ),
      NINTINDOBJ Short,
      DTERMDOD Date,
      MPOZNOBJ Memo,
      NORDITEM Integer,
      NMNOZVYDOB Double( 2 ),
      CZAKOBJINT Char( 15 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pln_objv',
   'pln_objv.adi',
   'PLNOBJ1',
   'STRZERO(NCISFIRMY) +UPPER(CCISOBJ) +STRZERO(NINTCOUNT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pln_objv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pln_objvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pln_objv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pln_objvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pln_objv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pln_objvfail');

CREATE TABLE podfakhd ( 
      CULOHA Char( 1 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      COBDOBI Char( 5 ),
      COBDOBIDAN Char( 5 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      NOSVODDAN Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 3 ),
      NMNOZPREP Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 25 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CUCET Char( 25 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 25 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 15 ),
      CPRIJEMCE2 Char( 15 ),
      CZKRZPUDOP Char( 15 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOVINFAK Date,
      DDATTISK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELFAK Double( 2 ),
      DPOSLIKFAK Date,
      NUHRCELFAK Double( 2 ),
      DPOSUHRFAK Date,
      NPARZALFAK Double( 2 ),
      DPARZALFAK Date,
      CBANK_UCT Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NCISPENFAK Double( 0 ),
      DDATPENFAK Date,
      NPEN_ODB Double( 2 ),
      NCISUPOMIN Double( 0 ),
      DUPOMINKY Date,
      NCISDOBFAK Double( 0 ),
      LHLASFAK Logical,
      CCISLOBINT Char( 30 ),
      NCISFAK_OR Double( 0 ),
      CTYPFAK_OR Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLHOT Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CDENIK Char( 2 ),
      CUCET_UCT Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NFINTYP Short,
      NKLICOBL Short,
      NDOKLAD Double( 0 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD3',
   'UPPER(CCISLOBINT) +STRZERO(NCISFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD4',
   'STRZERO(NCISFIRMY) +STRZERO(NCISFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD5',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD6',
   'UPPER(CZKRTYPFAK) +UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFIRMY) +STRZERO(NCISFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD8',
   'STRZERO(NCISFIRMY) +UPPER(CZKRTYPFAK) +STRZERO(NCISFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD9',
   'STRZERO(NKASA) +DTOS (DVYSTFAK) +STRZERO(NCISFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD10',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD11',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD12',
   'NICO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD13',
   'DTOS ( DSPLATFAK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD14',
   'NCENZAKCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD15',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD16',
   'STRZERO(NCISFIRMY) +STRZERO(NFINTYP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD17',
   'UPPER(CDENIK) +STRZERO(NDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'podfakhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'podfakhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'podfakhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'podfakhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'podfakhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'podfakhdfail');

CREATE TABLE podfakit ( 
      CULOHA Char( 1 ),
      NCISFIRMY Integer,
      NCISFIRDOA Integer,
      NCISFAK Double( 0 ),
      CZKRTYPFAK Char( 5 ),
      NINTCOUNT Integer,
      COBDOBI Char( 5 ),
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      CNAZZBO Char( 30 ),
      NCENJEDZAK Double( 2 ),
      NCENJEDZAD Double( 4 ),
      NCENZAKCEL Double( 2 ),
      NCENZAKCED Double( 2 ),
      NCENZAHCEL Double( 2 ),
      NSAZDAN Double( 2 ),
      NFAKTMNOZ Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NKLICDPH Short,
      NPROCDPH Double( 2 ),
      NNULLDPH Short,
      NTYPPREP Short,
      NRADVYKDPH Short,
      CDOPLNTXT Char( 50 ),
      CCISOBJ Char( 10 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      NCISPENFAK Integer,
      NCENPENCEL Double( 2 ),
      DSPLATFAK Date,
      DPOSUHRFAK Date,
      NPEN_ODB Double( 2 ),
      NCISFAK_OR Integer,
      CZKRTYP_OR Char( 5 ),
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLMN Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NCENAZAKC Double( 2 ),
      NCELKSLEV Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CUCET Char( 6 ),
      NCISLODL Integer,
      NCOUNTDL Integer,
      NDOKLADORG Double( 0 ),
      NUCETSKUP Short,
      NZBOZIKAT Short,
      NPODILPROD Double( 2 ),
      CDENIK Char( 2 ),
      NCISZALFAK Double( 0 ),
      NRECFAZ Double( 0 ),
      NRECPAR Double( 0 ),
      NRECDOL Double( 0 ),
      NRECPEN Double( 0 ),
      NKLICOBL Short,
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT1',
   'STRZERO(NCISFAK) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT3',
   'UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT4',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK) +STRZERO(NINTCOUNT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT5',
   'UPPER(CNAZPOL3) +STRZERO(NCISFAK) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT6',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'podfakit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'podfakitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'podfakit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'podfakitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'podfakit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'podfakitfail');

CREATE TABLE pokin_hd ( 
      NPOKLADNA Short,
      CZKRATMENY Char( 3 ),
      DDAT_INV Date,
      NCNT_INV Short,
      CCAS_INV Char( 8 ),
      NAKTSTAV Double( 2 ),
      DDATTISK Date,
      CJMENOPRED Char( 25 ),
      CJMENOPREV Char( 25 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokin_hd',
   'pokin_hd.adi',
   'POKIN_01',
   'STRZERO(NPOKLADNA,3) +DTOS (DDAT_INV) +STRZERO(NCNT_INV,2) +UPPER(CCAS_INV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokin_hd',
   'pokin_hd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokin_hd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokin_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokin_hd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokin_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokin_hd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokin_hdfail');

CREATE TABLE pokin_it ( 
      NPOKLADNA Short,
      DDAT_INV Date,
      NCNT_INV Short,
      CZKRATMENY Char( 3 ),
      CNAZMINCE Char( 25 ),
      NHODMINCE Integer,
      CZKRMINCE Char( 3 ),
      NVALMINCE Double( 3 ),
      NPOC_MINCE Short,
      NCEL_MINCE Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokin_it',
   'pokin_it.adi',
   'POKIN_01',
   'STRZERO(NPOKLADNA,3) +DTOS(DDAT_INV) +STRZERO(NCNT_INV,2) +STRZERO(NVALMINCE,11,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokin_it',
   'pokin_it.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokin_it', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokin_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokin_it', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokin_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokin_it', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokin_itfail');

CREATE TABLE pokl_lik ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NORDUCTO Short,
      NSUBUCTO Short,
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 2 ),
      NKLICNS Integer,
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      CTYP_R Char( 3 ),
      NMNOZNAT Double( 2 ),
      CZKRATJEDN Char( 3 ),
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 25 ),
      CUZAVRENI Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOHA Char( 1 ),
      NDOKLADORG Double( 0 ),
      NMAINITEM Integer,
      NRECITEM Integer,
      CPRIZLIKV Char( 1 ),
      NMNOZNAT2 Double( 2 ),
      CZKRATJED2 Char( 3 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      NPOKLADNA Short,
      CNAZPOKLAD Char( 25 ),
      NPOCSTAV Double( 2 ),
      NPRIJEM Double( 2 ),
      NVYDEJ Double( 2 ),
      NAKTSTAV Double( 2 ),
      NPRIJEMZ Double( 2 ),
      NVYDEJZ Double( 2 ),
      NKURZROZS Double( 2 ),
      DPORIZDOK Date,
      CTYPDOK Char( 6 ),
      NTYPDOK Short,
      NTYPSIG Short,
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 40 ),
      NNULLDPH Short,
      NOSVODDAN Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      CTEXTCELK Char( 70 ),
      NKURZAHMEN Double( 6 ),
      NMNOZPREP Integer,
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 18 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      DSPLATDOK Date,
      DVYSTDOK Date,
      DDATTISK Date,
      CVNBAN_UCT Char( 25 ),
      NLIKCELDOK Double( 2 ),
      DPOSLIKDOK Date,
      CUCET_UCT Char( 6 ),
      CJMENOSCHV Char( 25 ),
      NOSCISPRAC Integer,
      CJMENOPRIJ Char( 25 ),
      CJMENOPOKL Char( 25 ),
      CJMENOUSER Char( 25 ),
      CDENIK Char( 2 ),
      NCENZAK_OR Double( 2 ),
      NCENZAH_OR Double( 2 ),
      NCENCEL_HD Double( 2 ),
      NCENZAH_HD Double( 2 ),
      NCENCEL_IT Double( 2 ),
      NCENZAH_IT Double( 2 ),
      NRABATCEL Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL1',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL4',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,2) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL5',
   'UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokl_lik',
   'pokl_lik.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokl_lik', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokl_likfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokl_lik', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokl_likfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokl_lik', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokl_likfail');

CREATE TABLE pokladhd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      NPOKLADNA Short,
      CNAZPOKLAD Char( 25 ),
      NPOCSTAV Double( 2 ),
      NPRIJEM Double( 2 ),
      NVYDEJ Double( 2 ),
      NAKTSTAV Double( 2 ),
      NPRIJEMZ Double( 2 ),
      NVYDEJZ Double( 2 ),
      NKURZROZS Double( 2 ),
      NDOKLAD Double( 0 ),
      DPORIZDOK Date,
      CTYPDOK Char( 6 ),
      NTYPDOK Short,
      NTYPSIG Short,
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 60 ),
      NOSVODDAN Double( 2 ),
      NPROCDAN_1 Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NPROCDAN_2 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      CTEXTCELK Char( 70 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 18 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      DSPLATDOK Date,
      DVYSTDOK Date,
      DDATTISK Date,
      CVNBAN_UCT Char( 25 ),
      NLIKCELDOK Double( 2 ),
      DPOSLIKDOK Date,
      CUCET_UCT Char( 6 ),
      CJMENOSCHV Char( 25 ),
      NCISOSOBY Integer,
      NOSCISPRAC Integer,
      CJMENOPRIJ Char( 25 ),
      CJMENOPOKL Char( 25 ),
      CJMENOUSER Char( 25 ),
      CDENIK Char( 2 ),
      CDENIK_PUC Char( 2 ),
      NCENZAK_OR Double( 2 ),
      NCENZAH_OR Double( 2 ),
      NCENCEL_HD Double( 2 ),
      NCENZAH_HD Double( 2 ),
      NCENCEL_IT Double( 2 ),
      NCENZAH_IT Double( 2 ),
      NRABATCEL Double( 2 ),
      LZUC_ZAL Logical,
      NOSCISP_OR Integer,
      NNULLDPH Short,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH1',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH2',
   'STRZERO(NPOKLADNA,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH3',
   'STRZERO(NCISFIRMY,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH4',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH5',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH6',
   'UPPER(CTEXTDOK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH7',
   'NCENZAKCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH8',
   'STRZERO(NPOKLADNA,3) +DTOS (DPORIZDOK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH9',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD10',
   'STRZERO(NPOKLADNA,3) +STRZERO(NOSCISPRAC,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD11',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD12',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD13',
   'UPPER(CJMENOPRIJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladhd',
   'pokladhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokladhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokladhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokladhdfail');

CREATE TABLE pokladit ( 
      CULOHA Char( 1 ),
      NDOKLAD Double( 0 ),
      NPOKLADNA Short,
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CTYPOBRATU Char( 3 ),
      NTYPOBRATU Short,
      CZKRTYPFAK Char( 5 ),
      DDATUHRADY Date,
      NINTCOUNT Integer,
      NSUBCOUNT Short,
      NSUBCOUNTS Short,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CTEXT Char( 30 ),
      NPRIJEM Double( 2 ),
      NVYDEJ Double( 2 ),
      NPRIJEMZ Double( 2 ),
      NVYDEJZ Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NLIKPOLPOK Double( 2 ),
      NCENZAHCEL Double( 2 ),
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      CZKRATMENM Char( 3 ),
      NKURZMENM Double( 8 ),
      NMNOZPREM Integer,
      DDATPORIZ Date,
      DSPLATFAK Date,
      CDOPLNTXT Char( 50 ),
      NUHRPOKFAK Double( 2 ),
      NUHRPOKFAZ Double( 2 ),
      CZKRATMENU Char( 3 ),
      NKURZMENU Double( 8 ),
      NMNOZPREU Integer,
      CZKRATMENK Char( 3 ),
      NKURZMENK Double( 8 ),
      CZKRATMENF Char( 3 ),
      NKURZMENF Double( 8 ),
      NMNOZPREF Integer,
      NCENZAKCEF Double( 2 ),
      NKURZROZDF Double( 2 ),
      CUCET_UCTK Char( 6 ),
      CTEXTK Char( 30 ),
      CNAZPOL1K Char( 8 ),
      CNAZPOL2K Char( 8 ),
      CNAZPOL3K Char( 8 ),
      CNAZPOL4K Char( 8 ),
      CNAZPOL5K Char( 8 ),
      CNAZPOL6K Char( 8 ),
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CUCET_UCT Char( 6 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      CDENIK Char( 2 ),
      CDENIK_PAR Char( 2 ),
      NDOKLAD_OR Double( 0 ),
      NCENZAK_OR Double( 2 ),
      NCENZAH_OR Double( 2 ),
      NKURZRO_OR Double( 2 ),
      NDOKLAD_IV Double( 0 ),
      CTREE_VIEW Char( 4 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_1',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5) +UPPER(CDENIK_PAR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_2',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_3',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_4',
   'UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladit',
   'pokladit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokladitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokladitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokladitfail');

CREATE TABLE pokladks ( 
      NPOKLADNA Short,
      DPORIZDOK Date,
      NPOCSTAV Double( 2 ),
      NPRIJEM Double( 2 ),
      NVYDEJ Double( 2 ),
      NAKTSTAV Double( 2 ),
      NPOCST_TUZ Double( 2 ),
      NPRI_TUZ Double( 2 ),
      NVYD_TUZ Double( 2 ),
      NAKTST_TUZ Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladks',
   'pokladks.adi',
   'POKLADK1',
   'STRZERO(NPOKLADNA,3) +DTOS(DPORIZDOK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladks',
   'pokladks.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladks', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokladksfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladks', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokladksfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladks', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokladksfail');

CREATE TABLE pokladms ( 
      NPOKLADNA Short,
      CNAZPOKLAD Char( 25 ),
      CZKRATMENY Char( 3 ),
      DPOCSTAV Date,
      NPOCSTAV Double( 2 ),
      DPOSPRIJEM Date,
      NPOSPRIJEM Double( 2 ),
      DPOSVYDEJ Date,
      NPOSVYDEJ Double( 2 ),
      NAKTSTAV Double( 2 ),
      CVNBAN_UCT Char( 25 ),
      CUCET_UCT Char( 6 ),
      CJMENOPOKL Char( 25 ),
      LISTUZ_UC Logical,
      NPOCST_TUZ Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladms',
   'pokladms.adi',
   'POKLADM1',
   'NPOKLADNA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladms',
   'pokladms.adi',
   'POKLADM2',
   'UPPER(CNAZPOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokladms',
   'pokladms.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladms', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokladmsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladms', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokladmsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokladms', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokladmsfail');

CREATE TABLE poklhd ( 
      CULOHA Char( 1 ),
      CTASK Char( 3 ),
      CSUBTASK Char( 3 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCISLOEL Double( 0 ),
      NCISLOPVP Double( 0 ),
      CVARSYM Char( 15 ),
      COBDOBIDAN Char( 5 ),
      CSTADOKLAD Char( 10 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      NOSVODDAN Double( 2 ),
      NPROCDAN_1 Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAR_1 Double( 2 ),
      NSAZDAR_1 Double( 2 ),
      NZAKLDAZ_1 Double( 2 ),
      NSAZDAZ_1 Double( 2 ),
      NPROCDAN_2 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NZAKLDAR_2 Double( 2 ),
      NSAZDAR_2 Double( 2 ),
      NZAKLDAZ_2 Double( 2 ),
      NSAZDAZ_2 Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NCENFAKCEL Double( 2 ),
      NCENFAZCEL Double( 2 ),
      NCENDANCEL Double( 2 ),
      NZUSTPOZAO Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CUCET Char( 25 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 60 ),
      CPRIJEMCE2 Char( 60 ),
      CZKRZPUDOP Char( 15 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOVINFAK Date,
      DDATTISK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELFAK Double( 2 ),
      DPOSLIKFAK Date,
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      NKURZROZDF Double( 2 ),
      DPOSUHRFAK Date,
      NPARZALFAK Double( 2 ),
      NPARZAHFAK Double( 2 ),
      DPARZALFAK Date,
      CBANK_UCT Char( 25 ),
      CVNBAN_UCT Char( 25 ),
      NCISPENFAK Double( 0 ),
      DDATPENFAK Date,
      NPEN_ODB Double( 2 ),
      NVYPPENODB Double( 2 ),
      NCISUPOMIN Double( 0 ),
      DUPOMINKY Date,
      NCISDOBFAK Double( 0 ),
      LHLASFAK Logical,
      CCISOBJ Char( 30 ),
      CCISLOBINT Char( 30 ),
      NCISFAK_OR Double( 0 ),
      CTYPFAK_OR Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLHOT Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CDENIK Char( 2 ),
      CUCET_UCT Char( 6 ),
      CDENIK_PUC Char( 2 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      CUCET_DAZ Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NFINTYP Short,
      NKLICOBL Short,
      NDOKLAD_DL Double( 0 ),
      NDOKLAD_PV Integer,
      CJMENOVYS Char( 25 ),
      COBDOBIO Char( 5 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      MPOPISFAK Memo,
      LNO_INDPH Logical,
      MDOLFAKCIS Memo,
      LISZAHR Logical,
      NFAKDOLCIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CTYPZAK Char( 2 ),
      CSTRED_ODB Char( 8 ),
      CSTROJ_ODB Char( 8 ),
      NPORCISLIS Double( 0 ),
      NOSCISPRAC Integer,
      CSPZ Char( 15 ),
      VLEKSPZ Char( 15 ),
      CJMENORID Char( 25 ),
      CCISLOOP Char( 15 ),
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      CVYPSAZDAN Char( 8 ),
      CISZAL_FAK Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo,
      NZAPLACENO Double( 2 ),
      NVRACENO Double( 2 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'poklhd',
   'poklhd.adi',
   'POKLHD1',
   'STRZERO(NKASA,3) +DTOS(DVYSTFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklhd',
   'poklhd.adi',
   'POKLHD2',
   'STRZERO(NKASA,3) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklhd',
   'poklhd.adi',
   'POKLHD3',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklhd',
   'poklhd.adi',
   'POKLHD4',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklhd',
   'poklhd.adi',
   'POKLHD5',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklhd',
   'poklhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'poklhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'poklhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poklhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'poklhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poklhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'poklhdfail');

CREATE TABLE poklit ( 
      CULOHA Char( 1 ),
      NCISFIRMY Integer,
      NCISFIRDOA Integer,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NDOKLAD Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      NCOUNTDL Integer,
      NCISLOEL Double( 0 ),
      NPOLEL Integer,
      NCISLOPVP Double( 0 ),
      CZKRTYPFAK Char( 5 ),
      NINTCOUNT Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CTYPSKLPOL Char( 2 ),
      CPOLCEN Char( 1 ),
      CNAZZBO Char( 50 ),
      CUCETSKUP Char( 10 ),
      NCENJEDZAK Double( 4 ),
      NCENJEDZAD Double( 4 ),
      NCENZAKCEL Double( 2 ),
      NCENZAKCED Double( 2 ),
      NCENZAHCEL Double( 2 ),
      NJEDDAN Double( 2 ),
      NSAZDAN Double( 2 ),
      NFAKTMNOZ Double( 4 ),
      CZKRATJEDN Char( 3 ),
      NFAKTMNO2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      NKLICDPH Short,
      NPROCDPH Double( 2 ),
      NNAPOCET Short,
      NNULLDPH Short,
      NKODPLNENI Short,
      NTYPPREP Short,
      NVYPSAZDAN Short,
      NRADVYKDPH Short,
      CDOPLNTXT Char( 50 ),
      CCISOBJ Char( 15 ),
      CCISLOBINT Char( 30 ),
      NCISLOOBJP Double( 0 ),
      NCISLPOLOB Integer,
      NMNOZREODB Double( 2 ),
      NCISPENFAK Double( 0 ),
      NCELPENFAK Double( 2 ),
      NCENPENCEL Double( 2 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOSUHRFAK Date,
      NUHRCELFAZ Double( 2 ),
      NPEN_ODB Double( 2 ),
      NCISFAK_OR Double( 0 ),
      CZKRTYP_OR Char( 5 ),
      NKLICNS Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 2 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLMN Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      NCENAZAKC Double( 2 ),
      NCELKSLEV Double( 2 ),
      NKASA Short,
      CZKRPRODEJ Char( 4 ),
      CUCET Char( 6 ),
      CUCET_PUCR Char( 6 ),
      CUCET_PUCS Char( 6 ),
      NDOKLADORG Double( 0 ),
      NUCETSKUP Short,
      NZBOZIKAT Short,
      NPODILPROD Double( 2 ),
      CDENIK Char( 2 ),
      NCISZALFAK Double( 0 ),
      NISPARZAL Short,
      NRECFAZ Double( 0 ),
      NRECPAR Double( 0 ),
      NRECDOL Double( 0 ),
      NRECPEN Double( 0 ),
      NRECVYR Double( 0 ),
      NRECOBJ Double( 0 ),
      NKLICOBL Short,
      NCENASZBO Double( 4 ),
      NMNOZSZBO Double( 2 ),
      NCENACZBO Double( 2 ),
      MPOZZBO Memo,
      NFAKTM_ORG Double( 2 ),
      NORDIT_PVP Integer,
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CSKP Char( 15 ),
      CDANPZBO Char( 15 ),
      NIND_CEO Short,
      LIND_MOD Logical,
      NCISLOKUSU Integer,
      MDOLCIS Memo,
      AULOZENI Memo,
      CTYPSKP Char( 15 ),
      NKOEFMN Double( 2 ),
      NFAKTMNKOE Double( 4 ),
      NCEJPRZBZ Double( 4 ),
      NCEJPRKBZ Double( 4 ),
      NCEJPRKDZ Double( 4 ),
      NCEJPRZDZ Double( 4 ),
      NCECPRZBZ Double( 2 ),
      NCECPRKBZ Double( 2 ),
      NCECPRKDZ Double( 2 ),
      NHMOTNOSTJ Double( 4 ),
      NHMOTNOST Double( 4 ),
      CZKRATJEDH Char( 3 ),
      NOBJEMJ Double( 4 ),
      NOBJEM Double( 4 ),
      CZKRATJEDO Char( 3 ),
      LSLUZBA Logical,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      NCISVYSFAK Double( 0 ),
      DVYKLADKY Date,
      CCASVYKLAD Char( 8 ),
      CFILE_IV Char( 10 ),
      NMNOZ_FAKT Double( 4 ),
      NSTAV_FAKT Short,
      NMNOZ_DLVY Double( 4 ),
      NMNOZ_OBJP Double( 4 ),
      NMNOZ_EXPL Double( 4 ),
      NMNOZ_ZAK Double( 4 ),
      NMNOZZDOK Double( 4 ),
      MAPOLSEST Memo,
      CCISTRASYP Char( 10 ),
      CCISTRASYS Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'poklit',
   'poklit.adi',
   'POKLIT1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklit',
   'poklit.adi',
   'POKLIT2',
   'STRZERO(NKASA,3) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklit',
   'poklit.adi',
   'POKLIT3',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poklit',
   'poklit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'poklit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'poklitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poklit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'poklitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poklit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'poklitfail');

CREATE TABLE pokza_za ( 
      NPOKLADNA Short,
      NCISOSOBY Integer,
      NOSCISPRAC Integer,
      NPRIJ_ZAL Double( 2 ),
      NZUCT_ZAL Double( 2 ),
      NVRAC_ZAL Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'pokza_za',
   'pokza_za.adi',
   'POKIN_01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPOKLADNA,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokza_za',
   'pokza_za.adi',
   'POKIN_02',
   'STRZERO(NCISOSOBY,6) +STRZERO(NPOKLADNA,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pokza_za',
   'pokza_za.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokza_za', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pokza_zafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokza_za', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pokza_zafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pokza_za', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pokza_zafail');

CREATE TABLE polnabp ( 
      NCISFIRMY Integer,
      NCISNAB Integer,
      NPORNAB Integer,
      DDATNAB Date,
      CNAZEVNAZ Char( 30 ),
      NZBOZIKAT Short,
      NKLICNAZ Integer,
      NCENANAB Double( 2 ),
      NCENAKNAB Double( 2 ),
      NCENAZNAB Double( 2 ),
      LCENADNAB Logical,
      CKATCNAB Char( 9 ),
      NKLICDPH Short,
      MPOPISNAB Memo,
      CZKRATMENY Char( 3 ),
      CKURZMENY Char( 3 ),
      CZKRATJEDN Char( 3 ),
      NMNOZNAB Double( 2 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'polnabp',
   'polnabp.adi',
   'POLNABP1',
   'NZBOZIKAT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polnabp',
   'polnabp.adi',
   'POLNABP2',
   'UPPER(CNAZEVNAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polnabp',
   'polnabp.adi',
   'POLNABP3',
   'UPPER(CNAZEVNAZ) +STRZERO(NCISFIRMY,5) +STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polnabp',
   'polnabp.adi',
   'POLNABP4',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polnabp',
   'polnabp.adi',
   'POLNABP5',
   'NCISNAB',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polnabp',
   'polnabp.adi',
   'POLNABP6',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISNAB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'polnabp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'polnabpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polnabp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'polnabpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polnabp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'polnabpfail');

CREATE TABLE polop_02 ( 
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      NKUSOVCAS Double( 4 ),
      NKOEFKUSCA Double( 4 ),
      NCELKKUSCA Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NKOEFMNOST Double( 4 ),
      NKOEFMNOPR Double( 4 ),
      NKOEFMNONA Double( 4 ),
      NKCNAOPER Double( 3 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      NZAPUSTENO Short,
      CTEXT1 Char( 40 ),
      CTEXT2 Char( 40 ),
      CTEXT3 Char( 40 ),
      LTRANMNOZ Logical,
      MPOLOPER Memo,
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      NDRUHMZDY Short,
      CTARIFSTUP Char( 8 ),
      CTARIFTRID Char( 8 ),
      CNAZEV Char( 30 ),
      NMNZADVA Double( 4 ),
      NMNZADVK Double( 4 ),
      NRECPOLOP Double( 0 ),
      NPOCCEZAPZ Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'polop_02',
   'polop_02.adi',
   'POL02_1',
   'UPPER(CSTRED) +UPPER(COZNPRAC) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polop_02',
   'polop_02.adi',
   'POL02_2',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polop_02',
   'polop_02.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'polop_02', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'polop_02fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polop_02', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'polop_02fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polop_02', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'polop_02fail');

CREATE TABLE poloper ( 
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      NKUSOVCAS Double( 4 ),
      NKOEFKUSCA Double( 4 ),
      NCELKKUSCA Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NKOEFMNOST Double( 4 ),
      NKOEFMNOPR Double( 4 ),
      NKOEFMNONA Double( 4 ),
      NKCNAOPER Double( 3 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      NZAPUSTENO Short,
      CTEXT1 Char( 40 ),
      CTEXT2 Char( 40 ),
      CTEXT3 Char( 40 ),
      LTRANMNOZ Logical,
      MPOLOPER Memo,
      NPOCCEZAPZ Short,
      NMNZADVK Double( 4 ),
      COZNPRACN Char( 8 ),
      NPOZICE Short,
      CVYROBCISL Char( 40 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER2',
   'UPPER(COZNOPER) +UPPER(CVYRPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER3',
   'NPORCISLIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER4',
   'NZAPUSTENO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER5',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER6',
   'UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER7',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVAROPER,3) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'POLOPER8',
   'UPPER(CCISZAKAZI) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloper',
   'poloper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'poloper', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'poloperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poloper', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'poloperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poloper', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'poloperfail');

CREATE TABLE poloperz ( 
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      NKUSOVCAS Double( 4 ),
      NKOEFKUSCA Double( 4 ),
      NCELKKUSCA Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NKOEFMNOST Double( 4 ),
      NKOEFMNOPR Double( 4 ),
      NKOEFMNONA Double( 4 ),
      NKCNAOPER Double( 3 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      NZAPUSTENO Short,
      CTEXT1 Char( 40 ),
      CTEXT2 Char( 40 ),
      CTEXT3 Char( 40 ),
      LTRANMNOZ Logical,
      MPOLOPER Memo,
      NPOCCEZAPZ Short,
      NMNZADVK Double( 4 ),
      COZNPRACN Char( 8 ),
      NPOZICE Short,
      COZNPRAC Char( 8 ),
      CIDVAZBY Char( 12 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_2',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_3',
   'UPPER(CCISZAKAZ) +STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12) +STRZERO(NPOZICE,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_4',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2) +UPPER(CVYRPOL) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_5',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2) +UPPER(CVYRPOL) +STRZERO(NPOZICE,3) +STRZERO(NCISOPER,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_6',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2) +STRZERO(NPORCISLIS,12)+UPPER(COZNPRACN)+UPPER(CVYRPOL) +STRZERO(NPOZICE,3) +STRZERO(NCISOPER,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_7',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2)+STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)+UPPER(COZNPRAC)+UPPER(COZNPRACN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'poloperz',
   'poloperz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'poloperz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'poloperzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poloperz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'poloperzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'poloperz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'poloperzfail');

CREATE TABLE polsestc ( 
      NRECCEN Integer,
      CNAZEVPOL Char( 25 ),
      NCENAPOL Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'polsestc',
   'polsestc.adi',
   'POLSESTC',
   'NRECCEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polsestc',
   'polsestc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'polsestc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'polsestcfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polsestc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'polsestcfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polsestc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'polsestcfail');

CREATE TABLE polsestn ( 
      NRECNAB Integer,
      CNAZEVPOL Char( 25 ),
      NCENAPOL Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'polsestn',
   'polsestn.adi',
   'POLSESTN',
   'NRECNAB',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'polsestn',
   'polsestn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'polsestn', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'polsestnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polsestn', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'polsestnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'polsestn', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'polsestnfail');

CREATE TABLE popisdim ( 
      NINVCISDIM Integer,
      CPOPIS0DIM Char( 30 ),
      CPOPIS1DIM Char( 30 ),
      CPOPIS2DIM Char( 30 ),
      CPOPIS3DIM Char( 30 ),
      CPOPIS4DIM Char( 30 ),
      CPOPIS5DIM Char( 20 ),
      CPOPIS6DIM Char( 20 ),
      CPOPIS7DIM Char( 20 ),
      CPOPIS8DIM Char( 20 ),
      CPOPIS9DIM Char( 20 ),
      NPOPIS0DIM Double( 0 ),
      NPOPIS1DIM Double( 0 ),
      NPOPIS2DIM Double( 0 ),
      NPOPIS3DIM Double( 0 ),
      NPOPIS4DIM Double( 0 ),
      NPOPIS5DIM Double( 2 ),
      NPOPIS6DIM Double( 2 ),
      NPOPIS7DIM Double( 2 ),
      NPOPIS8DIM Double( 2 ),
      NPOPIS9DIM Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'popisdim',
   'popisdim.adi',
   'DIM_P1',
   'NINVCISDIM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'popisdim',
   'popisdim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'popisdim', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'popisdimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'popisdim', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'popisdimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'popisdim', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'popisdimfail');

CREATE TABLE ppoper ( 
      COZNOPER Char( 10 ),
      COZNPRPO Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'ppoper',
   'ppoper.adi',
   'PPOPER1',
   'UPPER(COZNOPER) +UPPER(COZNPRPO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ppoper',
   'ppoper.adi',
   'PPOPER2',
   'UPPER(COZNPRPO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ppoper',
   'ppoper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ppoper', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ppoperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ppoper', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ppoperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ppoper', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ppoperfail');

CREATE TABLE pracpost ( 
      COZNPRPO Char( 8 ),
      CTYPPRPO Char( 2 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CNAZPRPO Char( 30 ),
      MTEXTPRPO Memo,
      CSTAVPRPO Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pracpost',
   'pracpost.adi',
   'PRACPO1',
   'UPPER(COZNPRPO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pracpost',
   'pracpost.adi',
   'PRACPO2',
   'UPPER(CNAZPRPO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pracpost',
   'pracpost.adi',
   'PRACPO3',
   'UPPER(CSTRED) +UPPER(COZNPRPO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pracpost',
   'pracpost.adi',
   'PRACPO4',
   'UPPER(COZNPRAC) +UPPER(COZNPRPO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pracpost',
   'pracpost.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pracpost', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pracpostfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pracpost', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pracpostfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pracpost', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pracpostfail');

CREATE TABLE pracvaz ( 
      CIDVAZBY Char( 12 ),
      NPORADI Short,
      CCISZAKAZ Char( 30 ),
      NPOCCEZAPZ Short,
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      COZNPRAC Char( 8 ),
      COZNPRACN Char( 8 ),
      NSUMNHPLAN Double( 4 ),
      NSUMNHSKUT Double( 4 ),
      DDATPLAN Date,
      DDATVYKAZ Date,
      LVYKAZANO Logical,
      LVYKZPLAN Logical,
      CPLANOVANO Char( 1 ),
      NKCNAOPER Double( 3 ),
      CPOPVAZBY Char( 50 ),
      MPOPVAZBY Memo,
      LVSCHM Logical,
      DDATVSCHM Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pracvaz',
   'pracvaz.adi',
   'PRVAZ_1',
   'UPPER(COZNPRAC) + DTOS(DDATPLAN) + STRZERO( NPORADI, 3)',
   'EMPTY(CPLANOVANO)',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pracvaz',
   'pracvaz.adi',
   'PRVAZ_2',
   'UPPER(CIDVAZBY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pracvaz',
   'pracvaz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pracvaz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pracvazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pracvaz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pracvazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pracvaz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pracvazfail');

CREATE TABLE prenterm ( 
      NROK Short,
      NMESIC Short,
      NDEN Short,
      DDATUM Date,
      CCAS Char( 8 ),
      CTYPPREN Char( 3 ),
      CADRTERM Char( 10 ),
      CSNTERM Char( 10 ),
      NRECTERM Integer,
      NZPUPREN Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'prenterm',
   'prenterm.adi',
   'PRENOS1',
   'STRZERO(NROK,4) +STRZERO(NMESIC,2) +STRZERO(NDEN,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prenterm',
   'prenterm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prenterm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prentermfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prenterm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prentermfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prenterm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prentermfail');

CREATE TABLE prepprc ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CKMENSTRPR Char( 8 ),
      CPRACZAR Char( 8 ),
      CDELKPRDOB Char( 20 ),
      NSOUBPRAPO Short,
      NPROF1 Short,
      CPROF1 Char( 1 ),
      NPROF23 Short,
      CPROF23 Char( 2 ),
      CVEDCIN Char( 1 ),
      NFONDPDHO Double( 2 ),
      NFONDPDTHO Double( 2 ),
      NKALDNYODP Integer,
      NPRCDNYODP Integer,
      NKALHODODP Double( 2 ),
      NPRCHODODP Double( 2 ),
      NODPH_7 Double( 2 ),
      NODPD_5 Double( 2 ),
      NKALDNY Double( 1 ),
      NKALHOD Double( 1 ),
      NPRADNY Double( 1 ),
      NPRAHOD Double( 2 ),
      NFONDPD Double( 2 ),
      NFONDPH Double( 2 ),
      CFONDPD Char( 4 ),
      CFONDPH Char( 6 ),
      NPREPPRADN Double( 2 ),
      NPREPPRAHO Double( 2 ),
      NFYZIPRADN Double( 2 ),
      NFYZIPRAHO Double( 2 ),
      NPREVPZAFY Integer,
      NPREVPZAPR Double( 2 ),
      NTMEVPZAPR Double( 2 ),
      NFYZSTAVOB Short,
      NFYZSTAVKO Short,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NONEITEM Short,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'prepprc',
   'prepprc.adi',
   'PREPP_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NPROF1,1) +STRZERO(NPROF23,2) +UPPER(CFONDPD) +UPPER(CVEDCIN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prepprc',
   'prepprc.adi',
   'PREPP_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NPROF23,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prepprc',
   'prepprc.adi',
   'PREPP_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +UPPER(CPRACZAR) +UPPER(CDELKPRDOB) +STRZERO(NSOUBPRAPO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prepprc',
   'prepprc.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prepprc',
   'prepprc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prepprc', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prepprcfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prepprc', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prepprcfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prepprc', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prepprcfail');

CREATE TABLE prijatpl ( 
      DPORIZFAK Date,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      CZKRTYPFAK Char( 5 ),
      NKLICDPH Short,
      NOSVODDAN Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAZ_1 Double( 2 ),
      NSAZDAZ_1 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NZAKLDAZ_2 Double( 2 ),
      NSAZDAZ_2 Double( 2 ),
      NZAKLDAN1D Double( 2 ),
      NSAZDAN1D Double( 2 ),
      NZAKLDAN2D Double( 2 ),
      NSAZDAN2D Double( 2 ),
      NCENZAKCEL Double( 2 ),
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 3 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      NCISUZV Short,
      DDATUZV Date,
      CDENIK Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_1',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_2',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_3',
   'UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_4',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prijatpl',
   'prijatpl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prijatpl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prijatplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prijatpl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prijatplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prijatpl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prijatplfail');

CREATE TABLE prikuhhd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      DPORIZPRI Date,
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NCENZAKCEL Double( 2 ),
      NZBYPRIUHR Double( 2 ),
      CZKRATMENY Char( 3 ),
      NKONSTSYMB Short,
      DPRIKUHR Date,
      DDATTISK Date,
      CBANK_UCT Char( 25 ),
      CBANK_NAZ Char( 25 ),
      CBANK_POB Char( 20 ),
      CBANK_PSC Char( 6 ),
      CBANK_SID Char( 25 ),
      CBANK_ULI Char( 25 ),
      CIBAN Char( 24 ),
      CBIC Char( 8 ),
      CKODBAN_CR Char( 4 ),
      DDATE_EXP Date,
      NFILE_EXP Short,
      CFILE_EXP Char( 12 ),
      NODES_EXP Integer,
      NITMS_EXP Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD1',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD2',
   'UPPER(CKODBAN_CR) +DTOS (DDATE_EXP) +STRZERO(NFILE_EXP,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD3',
   'DTOS (DPRIKUHR) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD4',
   'UPPER(CULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhhd',
   'prikuhhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prikuhhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prikuhhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prikuhhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prikuhhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prikuhhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prikuhhdfail');

CREATE TABLE prikuhit ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DPORIZPRI Date,
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      CZKRTYPFAK Char( 5 ),
      CZKRTYPUHR Char( 5 ),
      NCENZAKCEL Double( 2 ),
      NPRIUHRCEL Double( 2 ),
      NUHRCELFAK Double( 2 ),
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 6 ),
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CUCET Char( 25 ),
      DSPLATFAK Date,
      DPOSUHRFAK Date,
      DUHRBANDNE Date,
      CIBAN Char( 24 ),
      CBIC Char( 8 ),
      CNCC Char( 25 ),
      CBANK_NAZ Char( 25 ),
      CBANK_UCT Char( 25 ),
      CUCET_UCT Char( 6 ),
      CBANK_PSC Char( 6 ),
      CBANK_SID Char( 25 ),
      CBANK_ULI Char( 25 ),
      CBANK_STA Char( 3 ),
      CPOPLATUHR Char( 3 ),
      CPOPLATUCT Char( 25 ),
      NPRIORIUHR Short,
      CPOPIS1UHR Char( 100 ),
      CPOPIS2UHR Char( 100 ),
      CPOPIS3UHR Char( 100 ),
      CZKROZNAM1 Char( 10 ),
      COZNAMENI1 Char( 50 ),
      CZKROZNAM2 Char( 10 ),
      COZNAMENI2 Char( 50 ),
      CZKROZNAM3 Char( 10 ),
      COZNAMENI3 Char( 50 ),
      CZKROZNAM4 Char( 10 ),
      COZNAMENI4 Char( 50 ),
      CJMENOPREV Char( 25 ),
      DDATPREVZ Date,
      DDATVRATIL Date,
      CZKRPRODEJ Char( 4 ),
      NCISFAK_OR Double( 0 ),
      NPRIUHR_OR Double( 2 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CZKRTYPZAV Char( 5 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD1',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD3',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD4',
   'UPPER(CSIDLO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD5',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD6',
   'UPPER(CULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZKRTYPZAV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prikuhit',
   'prikuhit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prikuhit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prikuhitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prikuhit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prikuhitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prikuhit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prikuhitfail');

CREATE TABLE prmat ( 
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      DDATAKTUAL Date,
      NPORKALDEN Short,
      CSKLPOL Char( 15 ),
      NSPMNOMJ Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCENKALKMJ Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'prmat',
   'prmat.adi',
   'PRMAT_1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +DTOS (DDATAKTUAL) +STRZERO(NPORKALDEN,2) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prmat',
   'prmat.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prmat', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prmatfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prmat', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prmatfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prmat', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prmatfail');

CREATE TABLE prmzdy ( 
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      DDATAKTUAL Date,
      NPORKALDEN Short,
      CVYRPOLKAL Char( 15 ),
      COZNOPER Char( 10 ),
      NPRIPRCAS Double( 3 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRKC Double( 2 ),
      NKUSOVKC Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'prmzdy',
   'prmzdy.adi',
   'PRMZDY1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +DTOS (DDATAKTUAL) +STRZERO(NPORKALDEN,2) +UPPER(CVYRPOLKAL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prmzdy',
   'prmzdy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prmzdy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prmzdyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prmzdy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prmzdyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prmzdy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prmzdyfail');

CREATE TABLE procenfi ( 
      NTYPPROCEN Integer,
      NCISPROCEN Double( 0 ),
      NCISFIRMY Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'procenfi',
   'procenfi.adi',
   'PROCENHFI1',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenfi',
   'procenfi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenfi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'procenfifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenfi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'procenfifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenfi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'procenfifail');

CREATE TABLE procenhd ( 
      NTYPPROCEN Integer,
      NCISPROCEN Double( 0 ),
      NCISFIRMY Integer,
      COZNPROCEN Char( 15 ),
      CNAZPROCEN Char( 50 ),
      LHLAPROCEN Logical,
      LPROCENZBO Logical,
      CZKRATMENY Char( 3 ),
      CZKRTYPUHR Char( 5 ),
      NTYPHODN Short,
      DPLATNYOD Date,
      DPLATNYDO Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD01',
   'NCISPROCEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD02',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD03',
   'UPPER(COZNPROCEN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD04',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenhd',
   'procenhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'procenhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'procenhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'procenhdfail');

CREATE TABLE procenho ( 
      NTYPPROCEN Integer,
      NCISPROCEN Double( 0 ),
      NPOLPROCEN Integer,
      LHLAPROCEN Logical,
      NCISFIRMY Integer,
      NZBOZIKAT Short,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NCENAPZBO Double( 2 ),
      CZKRTYPUHR Char( 5 ),
      CZKRATMENY Char( 3 ),
      NTYPHODN Short,
      NHODNOTA Double( 4 ),
      NPROCENTO Double( 4 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      CINUNIQID Char( 26 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO01',
   'NTYPPROCEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO02',
   'NCISPROCEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO03',
   'NPOLPROCEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO04',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISFIRMY,5)+UPPER(CCISSKLAD)+UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO05',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISFIRMY,5)+STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO06',
   'STRZERO(NTYPPROCEN,5)+UPPER(CCISSKLAD)+UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO07',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO08',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NPOLPROCEN,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO09',
   'UPPER(CCISSKLAD)+UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'PROCENHO10',
   'NZBOZIKAT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenho',
   'procenho.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenho', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'procenhofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenho', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'procenhofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenho', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'procenhofail');

CREATE TABLE procenit ( 
      NTYPPROCEN Integer,
      NCISPROCEN Double( 0 ),
      NPOLPROCEN Integer,
      NCISFIRMY Integer,
      COZNPROCEN Char( 15 ),
      NZBOZIKAT Short,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CNAZZBO Char( 50 ),
      CZKRTYPUHR Char( 5 ),
      NTYPHODN Short,
      CINUNIQID Char( 26 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'PROCENIT01',
   'NTYPPROCEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'PROCENIT02',
   'NCISPROCEN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'PROCENIT03',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NPOLPROCEN,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'PROCENIT04',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'PROCENIT05',
   'NZBOZIKAT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'PROCENIT06',
   'UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'procenit',
   'procenit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'procenitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'procenitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'procenit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'procenitfail');

CREATE TABLE prsmldoh ( 
      NROK Short,
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      CRODCISPRA Char( 13 ),
      CDRUPRAVZT Char( 8 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      CVZNPRAVZT Char( 10 ),
      NTYPZAMVZT Short,
      DDATVZNPRV Date,
      DDATNAST Date,
      DDATVYST Date,
      DDATPREDVY Date,
      NTYPUKOPRV Short,
      CPRACZAR Char( 8 ),
      CFUNPRA Char( 20 ),
      NZAPROK_ZA Short,
      NZAPDNU_ZA Short,
      NVYLDOB_ZA Short,
      NVYMZAK_ZA Double( 0 ),
      NODEDOB_ZA Short,
      NZAPROK_KO Short,
      NZAPDNU_KO Short,
      NVYLDOB_KO Short,
      NVYMZAK_KO Double( 0 ),
      NODEDOB_KO Short,
      MPRACSML Memo,
      MPRACDOH Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML01',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML02',
   'UPPER(CRODCISPRA) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML03',
   'UPPER(CRODCISPRA) +DTOS (DDATVZNPRV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML05',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML06',
   'STRZERO(NROK,4) +UPPER(CRODCISPRA) +DTOS (DDATVZNPRV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'prsmldoh',
   'prsmldoh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'prsmldoh', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'prsmldohfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prsmldoh', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'prsmldohfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'prsmldoh', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'prsmldohfail');

CREATE TABLE pvphead ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NTYPPVP Short,
      NDOKLAD Double( 0 ),
      DDATPVP Date,
      COBDPOH Char( 5 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NCISLPOH Integer,
      NKARTA Short,
      NTYPPOH Short,
      CCISSKLAD Char( 8 ),
      NCISFIRMY Integer,
      CNAZFIRMY Char( 50 ),
      CCISLOBINT Char( 30 ),
      NCISLODL Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLOPVP Double( 0 ),
      DDATTISK Date,
      NCENADOKL Double( 2 ),
      NNUTNEVN Double( 2 ),
      DDATLIKV Date,
      CSKLADKAM Char( 8 ),
      NCISPRENOS Short,
      NCISSTANIC Short,
      CVARSYM Char( 15 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 1 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLHOT Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCENAZAKL Double( 2 ),
      CZKRPRODEJ Char( 4 ),
      CDENIK Char( 2 ),
      NKLICOBL Short,
      NLIKCELDOK Double( 2 ),
      NROZPRIJ Double( 2 ),
      CZAHRMENA Char( 3 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NCENDOKZM Double( 2 ),
      NNUTNEVNZM Double( 4 ),
      CCISZAKAZ Char( 30 ),
      NPRENIFT Short,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD01',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD02',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD03',
   'UPPER (CCISSKLAD) + STRZERO(NCISLPOH,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD04',
   'STRZERO(NCISLPOH,5) + UPPER (CCISSKLAD) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD05',
   'UPPER (COBDPOH)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD06',
   'DTOS( DDATPVP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD07',
   'STRZERO(NTYPPOH,1) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD09',
   'NPRENIFT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD10',
   'NCISLODL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD11',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD12',
   'UPPER (CNAZFIRMY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD13',
   'STRZERO(NTYPPOH,1) + STRZERO(NCISFIRMY,5) + STRZERO(NCISLODL,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD14',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD15',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD16',
   'UPPER (CCISSKLAD)+ STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD17',
   'UPPER (CCISSKLAD)+ STRZERO(NTYPPOH,1) + STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD18',
   'STRZERO(NROK,4) +UPPER(CTYPPOHYBU) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvphead',
   'pvphead.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvphead', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pvpheadfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvphead', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pvpheadfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvphead', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pvpheadfail');

CREATE TABLE pvpitem ( 
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NTYPPVP Short,
      NDOKLAD Double( 0 ),
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      NORDITEM Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      DDATPVP Date,
      CCASPVP Char( 8 ),
      COBDPOH Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NTYPPOH Short,
      NCISLPOH Integer,
      NKLICNAZ Integer,
      CNAZZBO Char( 50 ),
      NZBOZIKAT Short,
      NKLICNS Integer,
      NCENNAPDOD Double( 4 ),
      NCENADOKL1 Double( 4 ),
      NMNOZDOKL1 Double( 4 ),
      CMJDOKL1 Char( 3 ),
      NMNOZPRDOD Double( 4 ),
      NCENACELK Double( 2 ),
      NCENAPZBO Double( 2 ),
      NCENAPDZBO Double( 2 ),
      NKLICDPH Short,
      CZKRATJEDN Char( 3 ),
      CZKRATMENY Char( 3 ),
      NMNOZSZBO Double( 4 ),
      NCENACZBO Double( 2 ),
      CCISOBJ Char( 15 ),
      NINTCOUNT Integer,
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      NMNOZPOODB Double( 4 ),
      NMNOZREODB Double( 4 ),
      NMNOZVYOBJ Double( 4 ),
      NMNOZKOBJE Double( 4 ),
      NMNOZZOBJE Double( 4 ),
      NMNOZVYOBV Double( 4 ),
      NMNOZVPINT Double( 4 ),
      NCISLOPVP Double( 0 ),
      NCISFAK Double( 0 ),
      NCISLODL Double( 0 ),
      CSKLADKAM Char( 8 ),
      CSKLPOLKAM Char( 15 ),
      NORDITKAM Integer,
      NUCETSKKAM Short,
      CUCETSKKAM Char( 10 ),
      NDOKLADV Integer,
      CUCTOVANO Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NTYPSLEVY Short,
      NPROCSLEV Double( 1 ),
      NPROCSLFAO Double( 1 ),
      NPROCSLMN Double( 1 ),
      NHODNSLEV Double( 2 ),
      NCELKSLEV Double( 2 ),
      NCENAZAKL Double( 4 ),
      LOGAMOPREN Logical,
      CULOHA Char( 1 ),
      CZKRPRODEJ Char( 4 ),
      NPODILPROD Double( 2 ),
      CDENIK Char( 2 ),
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CKODTPV Char( 2 ),
      NKLICOBL Short,
      CZAHRMENA Char( 3 ),
      NCENNADOZM Double( 4 ),
      NCENCELKZM Double( 2 ),
      CKLICODMIS Char( 8 ),
      NINVCISDIM Integer,
      AULOZENI Memo,
      CTYPSKP Char( 15 ),
      NKOEFMN Double( 6 ),
      NMNOZPRKOE Double( 4 ),
      NCEJPRZBZ Double( 2 ),
      NCEJPRKBZ Double( 2 ),
      NCEJPRKDZ Double( 2 ),
      NCECPRZBZ Double( 2 ),
      NCECPRKBZ Double( 2 ),
      NCECPRKDZ Double( 2 ),
      NHMOTNOST Double( 4 ),
      NOBJEM Double( 4 ),
      COBDOBI Char( 5 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      NROZDILPOH Double( 2 ),
      NCISFIRMY Integer,
      CTEXT Char( 30 ),
      NUSRIDDBTE Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM01',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM02',
   'UPPER (CCISSKLAD) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM03',
   'UPPER (CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM04',
   'NDOKLADV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM05',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM06',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM07',
   'UPPER (CCISLOBINT) +STRZERO(NTYPPOH,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM08',
   'UPPER (CNAZPOL3) +STRZERO(NTYPPOH,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM09',
   'UPPER (CCISZAKAZ) +STRZERO(NTYPPOH,2) + UPPER (CCISSKLAD) + UPPER (CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM10',
   'UPPER (CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM11',
   'STRZERO(NTYPPOH,2) + UPPER (CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM13',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NCISLPOH,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM14',
   'UPPER (CCISOBJ) + UPPER (CCISSKLAD) + UPPER (CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM15',
   'STRZERO(NDOKLAD,10) + UPPER(CUCTOVANO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM16',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM17',
   'NCISLODL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM18',
   'STRZERO(NCISFAK,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM19',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM20',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM21',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL) + STRZERO(NTYPPOH,2) + STRZERO( RECNO(),10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM22',
   'UPPER (CCISZAKAZI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM23',
   'STRZERO(NCISFIRMY,5) + UPPER(CCISSKLAD) + UPPER(CSKLPOL) + STRZERO(NTYPPOH,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM24',
   'STRZERO(NCISLODL,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM25',
   'UPPER(CVYRPOL) + STRZERO(NVARCIS, 3) + STRZERO(NTYPPOH, 2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM26',
   'UPPER (CCISSKLAD) +STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM27',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + DTOS(DDATPVP) + UPPER(CCASPVP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM28',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + DTOS(DDATPVP) + UPPER(CCASPVP)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM29',
   'STRZERO(NROK,4) +UPPER(CTYPPOHYBU) +STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpitem',
   'pvpitem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpitem', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pvpitemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpitem', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pvpitemfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpitem', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pvpitemfail');

CREATE TABLE pvpkumul ( 
      COBDPOH Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      NUCETSKUP Short,
      NZBOZIKAT Short,
      DDATPVP Date,
      NMNOZPOC Double( 4 ),
      NCENAPOC Double( 2 ),
      NMNOZKON Double( 4 ),
      NCENAKON Double( 2 ),
      NMNOZPRIJ Double( 4 ),
      NCENAPRIJ Double( 2 ),
      NMNOZVYDEJ Double( 4 ),
      NCENAVYDEJ Double( 2 ),
      NPORADI Short,
      CDATPOSAKT Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpkumul',
   'pvpkumul.adi',
   'PVPKUM1',
   'UPPER(COBDPOH) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpkumul',
   'pvpkumul.adi',
   'PVPKUM2',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpkumul',
   'pvpkumul.adi',
   'PVPKUM3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpkumul',
   'pvpkumul.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpkumul', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pvpkumulfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpkumul', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pvpkumulfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpkumul', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pvpkumulfail');

CREATE TABLE pvpterm ( 
      CTYPPOHYBU Char( 10 ),
      NTYPPVP Short,
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CZKRCARKOD Char( 8 ),
      CCARKOD Char( 128 ),
      CNAZZBO Char( 30 ),
      NZBOZIKAT Short,
      NCENADOKL1 Double( 4 ),
      NMNOZDOKL1 Double( 4 ),
      CMJDOKL1 Char( 3 ),
      NCENADOKL Double( 2 ),
      NCENAPZBO Double( 2 ),
      NCENAMZBO Double( 2 ),
      NCENASZBO Double( 2 ),
      CPOLCEN Char( 1 ),
      NCARKKOD Double( 0 ),
      CSTREDISKO Char( 8 ),
      CVYROBEK Char( 8 ),
      CZAKAZKA Char( 8 ),
      CVYRMISTO Char( 8 ),
      CSTROJ Char( 8 ),
      COPERACE Char( 8 ),
      NCISFIRMY Integer,
      NCISLODL Double( 0 ),
      NCISFAK Double( 0 ),
      NMNOZ_PLN Double( 4 ),
      NSTAV_PLN Short,
      NUSRIDDBTE Integer,
      LINCENZBOZ Logical,
      CTYPHEXBCD Char( 20 ),
      CSOURCEBCD Char( 20 ),
      CTIMEBCD Char( 20 ),
      NLENBCD Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM01',
   'UPPER(CCISSKLAD) + STRZERO( NTYPPVP, 1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM02',
   'UPPER(CNAZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM03',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM04',
   'UPPER(CCARKOD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpterm',
   'pvpterm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpterm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pvptermfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpterm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pvptermfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpterm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pvptermfail');

CREATE TABLE pvpuloz ( 
      NDOKLAD Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NORDITEM Integer,
      CULOZZBO Char( 8 ),
      NULOZMNOZ Double( 4 ),
      NTYPPOH Short,
      NCISLPOH Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpuloz',
   'pvpuloz.adi',
   'PVPULOZ1',
   'STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5) +UPPER(CULOZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpuloz',
   'pvpuloz.adi',
   'PVPULOZ2',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CULOZZBO) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpuloz',
   'pvpuloz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpuloz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pvpulozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpuloz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pvpulozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpuloz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pvpulozfail');

CREATE TABLE pvpzak ( 
      NDOKLAD Integer,
      NORDITEM Integer,
      CCISZAKAZ Char( 30 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      NMNPRIJATO Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpzak',
   'pvpzak.adi',
   'PVPZAK1',
   'STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'pvpzak',
   'pvpzak.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'pvpzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'pvpzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'pvpzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'pvpzakfail');

CREATE TABLE range_hd ( 
      CRANGE_ITM Char( 10 ),
      CRANGE_VAL Char( 25 ),
      NSTART_DOK Double( 0 ),
      NKONEC_DOK Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'range_hd',
   'range_hd.adi',
   'RANGE_1',
   'UPPER(CRANGE_ITM) +STRZERO(NSTART_DOK,10) +STRZERO(NKONEC_DOK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'range_hd',
   'range_hd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'range_hd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'range_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'range_hd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'range_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'range_hd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'range_hdfail');

CREATE TABLE range_it ( 
      CRANGE_ITM Char( 10 ),
      CUSER_ABB Char( 8 ),
      CUSER_NAM Char( 25 ),
      NSTART_DOK Double( 0 ),
      NKONEC_DOK Double( 0 ),
      NUSER_DOK Double( 0 ),
      LUSER_DOK Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'range_it',
   'range_it.adi',
   'RANGE_1',
   'UPPER(CRANGE_ITM) +STRZERO(NSTART_DOK,10) +STRZERO(NKONEC_DOK,10) +UPPER(CUSER_ABB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'range_it',
   'range_it.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'range_it', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'range_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'range_it', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'range_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'range_it', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'range_itfail');

CREATE TABLE reghlzme ( 
      NROK Short,
      NOBDOBI Short,
      NKUSY Integer,
      NKUSYPOCST Integer,
      NKUSYKONST Integer,
      NKUSYMINOB Integer,
      CFARMA Char( 10 ),
      CKODHOSP Char( 4 ),
      NDRPOHYBP Short,
      CFARMAZMN Char( 10 ),
      CZVIREZEM Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'reghlzme',
   'reghlzme.adi',
   'REGHL_01',
   'UPPER( CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'reghlzme',
   'reghlzme.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'reghlzme', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'reghlzmefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'reghlzme', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'reghlzmefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'reghlzme', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'reghlzmefail');

CREATE TABLE regzvipr ( 
      CTYPEVID Char( 1 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CDANPZBO Char( 15 ),
      CTYPSKP Char( 15 ),
      DDATPORKAR Date,
      NCENAZV Double( 2 ),
      NKUSY Integer,
      NKUSYPOCST Integer,
      NKUSYKONST Integer,
      DDATPZV Date,
      CNAZPOL2 Char( 8 ),
      CPLEMENO Char( 2 ),
      NFARMA Double( 0 ),
      CFARMA Char( 10 ),
      CFARMAKRJ Char( 2 ),
      CFARMAPOD Char( 6 ),
      CFARMASTJ Char( 2 ),
      CKODHOSP Char( 4 ),
      NDRPOHYB Integer,
      NDRPOHYBP Integer,
      CFARMAZMN Char( 10 ),
      CFARZMNKRJ Char( 2 ),
      CFARZMNPOD Char( 6 ),
      CFARZMNSTJ Char( 2 ),
      CFARMAODK Char( 10 ),
      CFARODKKRJ Char( 2 ),
      CFARODKPOD Char( 6 ),
      CFARODKSTJ Char( 2 ),
      CZVIREZEM Char( 3 ),
      CFARMAKAM Char( 10 ),
      CFARKAMKRJ Char( 2 ),
      CFARKAMPOD Char( 6 ),
      CFARKAMSTJ Char( 2 ),
      NPORCISLIS Double( 0 ),
      NPORCISRAD Short,
      CTEXT1 Char( 30 ),
      CTEXT2 Char( 30 ),
      MPOPIS Memo,
      DDATKDYODK Date,
      DDATKDYKAM Date,
      NTYPPOHYB Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_01',
   'UPPER(CFARMA) + STRZERO(NPORCISLIS, 10) + STRZERO(NPORCISRAD,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_02',
   'STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_03',
   'UPPER(CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2) + STRZERO( NTYPPOHYB, 2) + STRZERO( NDRPOHYBP, 5) + UPPER(CFARMAZMN) + UPPER(CZVIREZEM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_04',
   'UPPER(CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2) + STRZERO(NPORCISLIS, 10) + STRZERO(NPORCISRAD,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'regzvipr',
   'regzvipr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'regzvipr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'regzviprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'regzvipr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'regzviprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'regzvipr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'regzviprfail');

CREATE TABLE rodprisl ( 
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      CRODCISPRA Char( 13 ),
      CPRIJMENRP Char( 20 ),
      CJMENORP Char( 15 ),
      CRODPRISL Char( 50 ),
      NRODPRISL Short,
      CTYPRODPRI Char( 4 ),
      CRODCISRP Char( 13 ),
      CTITULRP Char( 15 ),
      CJMENRODRP Char( 25 ),
      CULICE Char( 25 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CPREULICE Char( 25 ),
      CPREMISTO Char( 25 ),
      CPREPSC Char( 6 ),
      CZKRSTATPR Char( 3 ),
      CZKRATNAR Char( 15 ),
      DDATNAROZ Date,
      CMISTONAR Char( 30 ),
      CZKRSTATNA Char( 3 ),
      CZKRSTAPRI Char( 25 ),
      CCISLOOP Char( 15 ),
      CCISLOPASU Char( 15 ),
      CPOHLAVI Char( 3 ),
      NMUZ Short,
      NZENA Short,
      CZKRRODSTV Char( 8 ),
      CZKRMANSTV Char( 8 ),
      CZKRVZDEL Char( 8 ),
      CTELPRIV Char( 15 ),
      CTELZAMES Char( 15 ),
      CTELMOBIL Char( 15 ),
      CEMAIL Char( 25 ),
      MPOZNAMKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_01',
   'UPPER(CRODCISPRA) +STRZERO(NRODPRISL,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_02',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_03',
   'STRZERO(NOSCISPRAC,5) +UPPER(CTYPRODPRI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_04',
   'UPPER(CRODCISPRA) +UPPER(CTYPRODPRI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_05',
   'UPPER(CRODCISRP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rodprisl',
   'rodprisl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'rodprisl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'rodprislfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rodprisl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'rodprislfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rodprisl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'rodprislfail');

CREATE TABLE rok2005 ( 
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NDOKLADUSR Double( 0 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NDRPOHYB Integer,
      NKARTA Short,
      NTYPPOHYB Short,
      NDRPOHPRIR Integer,
      CZKRATJEDN Char( 3 ),
      NKLICDPH Short,
      CTYPVYPCEN Char( 3 ),
      NTYPVYPCEL Short,
      CZKRATMENY Char( 3 ),
      DDATPORIZ Date,
      DDATZMZV Date,
      NCISLODL Double( 0 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      NCENASZV Double( 4 ),
      NKUSYZV Double( 0 ),
      NMNOZSZV Double( 2 ),
      NKD Double( 0 ),
      NKDHLP Double( 0 ),
      NCENACZV Double( 2 ),
      NCENAPZV Double( 2 ),
      NCENAMZV Double( 2 ),
      NCENAPCEZV Double( 2 ),
      NCENAMCEZV Double( 2 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL1_N Char( 8 ),
      CNAZPOL4_N Char( 8 ),
      NZVIRKAT_N Integer,
      NUCETSKUPN Short,
      CUCETSKUPN Char( 10 ),
      CNAZPOL2_N Char( 8 ),
      NCISFIRMY Integer,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CULOHA Char( 1 ),
      NPORZMENY Integer,
      NLIKCELDOK Double( 2 ),
      LPRODUKCE Logical,
      NDRPOHYBP Integer,
      LZMENAZAKL Logical,
      CTYPZVR Char( 1 ),
      CFARMA Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'rok2005',
   'rok2005.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'rok2005', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'rok2005fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rok2005', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'rok2005fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rok2005', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'rok2005fail');

CREATE TABLE rokuzv ( 
      NROKUZV Short,
      DDATESTART Date,
      CTIMESTART Char( 8 ),
      DDATEEND Date,
      CTIMEEND Char( 8 ),
      LUZVRUN Logical,
      LUZVOK Logical,
      CUSERABB Char( 8 ),
      MERRORLOG Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'rokuzv',
   'rokuzv.adi',
   'ROKUZV_1',
   'NROKUZV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rokuzv',
   'rokuzv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'rokuzv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'rokuzvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rokuzv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'rokuzvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rokuzv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'rokuzvfail');

CREATE TABLE rokuzvz ( 
      NROKUZV Short,
      DDATESTART Date,
      CTIMESTART Char( 8 ),
      DDATEEND Date,
      CTIMEEND Char( 8 ),
      LUZVRUN Logical,
      LUZVOK Logical,
      CUSERABB Char( 8 ),
      MERRORLOG Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'rokuzvz',
   'rokuzvz.adi',
   'ROKUZVZ_1',
   'NROKUZV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rokuzvz',
   'rokuzvz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'rokuzvz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'rokuzvzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rokuzvz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'rokuzvzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rokuzvz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'rokuzvzfail');

CREATE TABLE rozbpz_h ( 
      NTYP_ROZ Short,
      CNAZ_ROZ Char( 25 ),
      LSET_ROZ Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'rozbpz_h',
   'rozbpz_h.adi',
   'C_ROZB01',
   'NTYP_ROZ',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rozbpz_h',
   'rozbpz_h.adi',
   'C_ROZB02',
   'LSET_ROZ',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rozbpz_h',
   'rozbpz_h.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozbpz_h', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'rozbpz_hfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozbpz_h', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'rozbpz_hfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozbpz_h', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'rozbpz_hfail');

CREATE TABLE rozbpz_i ( 
      NTYP_ROZ Short,
      LSET_ROZ Logical,
      CREL_1 Char( 3 ),
      NVAL_1 Short,
      CREL_2 Char( 2 ),
      NVAL_2 Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'rozbpz_i',
   'rozbpz_i.adi',
   'C_ROZB01',
   'STRZERO(NTYP_ROZ,3) +STRZERO(NVAL_1,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rozbpz_i',
   'rozbpz_i.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozbpz_i', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'rozbpz_ifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozbpz_i', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'rozbpz_ifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozbpz_i', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'rozbpz_ifail');

CREATE TABLE rozprac ( 
      CCISZAKAZ Char( 30 ),
      CCISZAKAZI Char( 36 ),
      NROK Short,
      NOBDOBI Short,
      CZAOBDOBI Char( 2 ),
      COBDOBI Char( 5 ),
      NMNOZODVED Double( 2 ),
      NMNOZODVO Double( 2 ),
      NMNOZODVR Double( 2 ),
      DDATZPRAC Date,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NPLPRMATZ Double( 2 ),
      NPLHODINZ Double( 2 ),
      NPLPRMZDZ Double( 2 ),
      NPLPRKOOZ Double( 2 ),
      NPLREZIEZ Double( 2 ),
      NSKPRMATZ Double( 2 ),
      NSKPRMATZP Double( 2 ),
      NSKHODINZ Double( 2 ),
      NSKHODINVS Double( 2 ),
      NSKPRMZDZ Double( 2 ),
      NSKPRMZUKZ Double( 2 ),
      NSKOSTPRNA Double( 2 ),
      NSKOSTPRMZ Double( 2 ),
      NSKPRKOOZ Double( 2 ),
      NSKPRKOOZ2 Double( 2 ),
      NSKREZIEZ Double( 2 ),
      NFAPRMATZ Double( 2 ),
      NFAPRMZDZ Double( 2 ),
      NFAOSTPRNA Double( 2 ),
      NFAPRKOOZ Double( 2 ),
      NFAVYRREZZ Double( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      NKURZSTRED Double( 8 ),
      NZMENASNV Double( 2 ),
      NMATZM_U Double( 2 ),
      NMATCZK_U Double( 2 ),
      NMZDY_U Double( 2 ),
      NKOOP1_U Double( 2 ),
      NKOOP2_U Double( 2 ),
      NVYRREZ_U Double( 2 ),
      NZASREZ_U Double( 2 ),
      NODBREZ_U Double( 2 ),
      NSPRREZ_U Double( 2 ),
      NNABEHNV Double( 2 ),
      NOSTPRMZ_U Double( 2 ),
      NP_MATCZK Double( 2 ),
      NU_MATCZK Double( 2 ),
      NP_MZDY Double( 2 ),
      NU_MZDY Double( 2 ),
      NP_OSTPRMZ Double( 2 ),
      NU_OSTPRMZ Double( 2 ),
      NP_KOOP1 Double( 2 ),
      NU_KOOP1 Double( 2 ),
      NP_KOOP2 Double( 2 ),
      NU_KOOP2 Double( 2 ),
      NP_VYRREZ Double( 2 ),
      NU_VYRREZ Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'rozprac',
   'rozprac.adi',
   'ROZPRA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'rozprac',
   'rozprac.adi',
   'ROZPRA2',
   'UPPER(CCISZAKAZ) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZAOBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozprac', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'rozpracfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozprac', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'rozpracfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'rozprac', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'rozpracfail');

CREATE TABLE seznabp ( 
      NCISFIRMY Integer,
      NCISNAB Integer,
      DDATNAB Date,
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'seznabp',
   'seznabp.adi',
   'SEZNABP1',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISNAB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'seznabp',
   'seznabp.adi',
   'SEZNABP2',
   'NCISNAB',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'seznabp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'seznabpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'seznabp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'seznabpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'seznabp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'seznabpfail');

CREATE TABLE sklpren ( 
      NCISPRENOS Short,
      COBDPRENOS Char( 5 ),
      NCISSTANIC Short,
      CTYPPRENOS Char( 8 ),
      DDATPRENOS Date,
      CCASPRENOS Char( 8 ),
      CUZVPRENOS Char( 6 ),
      DDATZRUSEN Date,
      CCASZRUSEN Char( 8 ),
      CUZVZRUSEN Char( 6 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'sklpren',
   'sklpren.adi',
   'SKLPREN1',
   'UPPER(CTYPPRENOS) +STRZERO(NCISSTANIC,3) +STRZERO(NCISPRENOS,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'sklpren',
   'sklpren.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'sklpren', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'sklprenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'sklpren', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'sklprenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'sklpren', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'sklprenfail');

CREATE TABLE skoleni ( 
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CRODCISPRA Char( 13 ),
      CPRACOVNIK Char( 43 ),
      NPORADI Short,
      CZKRATKA Char( 8 ),
      CCISPRUKAZ Char( 20 ),
      LPERIOOPAK Logical,
      NDELKASKOL Integer,
      CZKRATJED2 Char( 3 ),
      NPERIOOPAK Integer,
      CZKRATJEDN Char( 3 ),
      DPOSLSKOLE Date,
      DDALSSKOLE Date,
      CZKRATKAUK Char( 8 ),
      NCISFIRMY Integer,
      CZKRATSKOL Char( 8 ),
      CNAZEVSKOL Char( 35 ),
      CULICE Char( 25 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      CLEKTOR Char( 30 ),
      CNORMA1 Char( 15 ),
      CNORMA2 Char( 15 ),
      CNORMA3 Char( 15 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_02',
   'UPPER(CRODCISPRA) +STRZERO(NPORADI,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_03',
   'UPPER(CRODCISPRA) +UPPER(CZKRATKA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_05',
   'UPPER(CRODCISPRA) +DTOS (DDALSSKOLE)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'skoleni',
   'skoleni.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'skoleni', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'skolenifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'skoleni', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'skolenifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'skoleni', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'skolenifail');

CREATE TABLE slevycen ( 
      NCISFIRMY Integer,
      NZBOZIKAT Short,
      CSKLPOL Char( 15 ),
      NTYPSLEVY Short,
      NPROCZAKL Double( 4 ),
      NPROCHOTOV Double( 1 ),
      CZKRTYPUHR Char( 5 ),
      NHODNOTA1 Double( 4 ),
      NPROCSL1 Double( 1 ),
      NHODNOTA2 Double( 4 ),
      NPROCSL2 Double( 1 ),
      NHODNOTA3 Double( 4 ),
      NPROCSL3 Double( 1 ),
      NHODNOTA4 Double( 4 ),
      NPROCSL4 Double( 1 ),
      NHODNOTA5 Double( 4 ),
      NPROCSL5 Double( 1 ),
      CTYPSLEVY Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC01',
   'STRZERO(NCISFIRMY,5) +STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC02',
   'UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC03',
   'STRZERO(NZBOZIKAT,4) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC04',
   'UPPER(CTYPSLEVY) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC05',
   'UPPER(CTYPSLEVY) +STRZERO(NCISFIRMY,5) +STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC06',
   'UPPER(CTYPSLEVY) +STRZERO(NCISFIRMY,5) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC07',
   'UPPER(CTYPSLEVY) +STRZERO(NZBOZIKAT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC08',
   'UPPER(CTYPSLEVY) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slevycen',
   'slevycen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'slevycen', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'slevycenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'slevycen', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'slevycenfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'slevycen', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'slevycenfail');

CREATE TABLE slzmzdy ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CSESTAVA Char( 4 ),
      CKMENSTRPR Char( 8 ),
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NPROFESE Short,
      CPROFESE Char( 3 ),
      CPROF23 Char( 2 ),
      CPROF1 Char( 1 ),
      MESIC Char( 2 ),
      SL01 Double( 2 ),
      SL02 Double( 2 ),
      SL03 Double( 2 ),
      SL04 Double( 2 ),
      SL05 Double( 2 ),
      SL06 Double( 2 ),
      SL07 Double( 2 ),
      SL08 Double( 2 ),
      SL09 Double( 2 ),
      SL10 Double( 2 ),
      SL11 Double( 2 ),
      SL12 Double( 2 ),
      SL13 Double( 2 ),
      SL14 Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'slzmzdy',
   'slzmzdy.adi',
   'SLMZD_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CSESTAVA) +STRZERO(NPROFESE,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slzmzdy',
   'slzmzdy.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'slzmzdy',
   'slzmzdy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'slzmzdy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'slzmzdyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'slzmzdy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'slzmzdyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'slzmzdy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'slzmzdyfail');

CREATE TABLE spojeni ( 
      NCISSPOJ Double( 0 ),
      CTYPSPOJ Char( 10 ),
      CZKRSPOJ Char( 10 ),
      CNAZSPOJ Char( 50 ),
      CADRELSPOJ Char( 50 ),
      MUSRELSPOJ Memo,
      CULICE Char( 25 ),
      CCISPOPIS Char( 10 ),
      CULICCIPOP Char( 35 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      MADRPOSPOJ Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'spojeni',
   'spojeni.adi',
   'SPOJENI01',
   'NCISSPOJ',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'spojeni',
   'spojeni.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'spojeni', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'spojenifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'spojeni', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'spojenifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'spojeni', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'spojenifail');

CREATE TABLE summaj ( 
      NINVCIS Double( 0 ),
      NTYPMAJ Short,
      NZNAKT Short,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NVSCENDPS Double( 2 ),
      NVSCENUPS Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NZUCENUPS Double( 2 ),
      NUCTODPMES Double( 2 ),
      NZMVSTCMIN Double( 2 ),
      NZMOPRMIN Double( 2 ),
      NZMZCMIN Double( 2 ),
      NZMVSTCKLA Double( 2 ),
      NZMOPRKLA Double( 2 ),
      NVSCENUKS Double( 2 ),
      NOPRUCTKS Double( 2 ),
      NZUCENUKS Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'summaj',
   'summaj.adi',
   'SUMMAJ_1',
   'UPPER(COBDOBI)+STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'summaj',
   'summaj.adi',
   'SUMMAJ_2',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROK,4)+STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'summaj',
   'summaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'summaj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'summajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'summaj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'summajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'summaj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'summajfail');

CREATE TABLE summajz ( 
      NINVCIS Double( 0 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NZNAKT Short,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NVSCENDPS Double( 2 ),
      NVSCENUPS Double( 2 ),
      NOPRUCTPS Double( 2 ),
      NZUCENUPS Double( 2 ),
      NUCTODPMES Double( 2 ),
      NZMVSTCMIN Double( 2 ),
      NZMOPRMIN Double( 2 ),
      NZMZCMIN Double( 2 ),
      NZMVSTCKLA Double( 2 ),
      NZMOPRKLA Double( 2 ),
      NVSCENUKS Double( 2 ),
      NOPRUCTKS Double( 2 ),
      NZUCENUKS Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'summajz',
   'summajz.adi',
   'SUMMAJZ_1',
   'UPPER(COBDOBI)+STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'summajz',
   'summajz.adi',
   'SUMMAJZ_2',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NROK,4)+STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'summajz',
   'summajz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'summajz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'summajzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'summajz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'summajzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'summajz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'summajzfail');

CREATE TABLE sumpvpit ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      NCISLPOH Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NOBDPOH Integer,
      COBDPOH Char( 5 ),
      NCENNAPDOD Double( 2 ),
      NMNOZPRDOD Double( 4 ),
      NCENACELK Double( 2 ),
      NCENAPZBO Double( 2 ),
      NCENAPDZBO Double( 2 ),
      NCENNAPPR Double( 2 ),
      NMNOZPRPR Double( 4 ),
      NCENACEPR Double( 2 ),
      NCENAPZPR Double( 2 ),
      NCENAPDPR Double( 2 ),
      CZKRATJEDN Char( 3 ),
      CZKRATMENY Char( 3 ),
      NUCETSKUP Short,
      MPODMINKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'sumpvpit',
   'sumpvpit.adi',
   'SUM1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NCISLPOH,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'sumpvpit',
   'sumpvpit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'sumpvpit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'sumpvpitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'sumpvpit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'sumpvpitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'sumpvpit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'sumpvpitfail');

CREATE TABLE t_lstzak ( 
      CCISZAKAZ Char( 30 ),
      DDATUMOD Date,
      DDATUMDO Date,
      COZNPRAC Char( 8 ),
      COZNOPER Char( 10 ),
      NMNOZPLANO Double( 2 ),
      NMNOZODVED Double( 2 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   't_lstzak',
   't_lstzak.adi',
   'LSTZAK1',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 't_lstzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 't_lstzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_lstzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 't_lstzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_lstzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 't_lstzakfail');

CREATE TABLE t_ustevi ( 
      CDRUHZV Char( 1 ),
      CFARMAODK Char( 10 ),
      CFARODKKRJ Char( 2 ),
      CFARODKPOD Char( 6 ),
      CFARODKSTJ Char( 2 ),
      CINVCIS Char( 10 ),
      CINVCISPOR Char( 6 ),
      CINVCISOKR Char( 3 ),
      CDRPOHYBP Char( 2 ),
      DDATZMZV Date,
      CDATZMZVDD Char( 2 ),
      CDATZMZVMM Char( 2 ),
      CDATZMZVRR Char( 2 ),
      CTMODKKAMM Char( 14 ),
      CTM1_KRJ Char( 2 ),
      CTM2_POD Char( 6 ),
      CTM3_STJ Char( 2 ),
      CTEXT Char( 30 ),
      DDATVYTVOR Date,
      CDATVYTDD Char( 2 ),
      CDATVYTMM Char( 2 ),
      CDATVYTRR Char( 2 ),
      CSTAT Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   't_ustevi',
   't_ustevi.adi',
   'T_USTEV_01',
   'UPPER( CDRUHZV) + UPPER(CFARMAODK) + DTOS( DDATZMZV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_ustevi',
   't_ustevi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 't_ustevi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 't_ustevifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_ustevi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 't_ustevifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_ustevi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 't_ustevifail');

CREATE TABLE t_vpobj ( 
      CCISZAKAZ Char( 30 ),
      CCISLOOBJ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      NKUSYCELK Double( 2 ),
      NCISOP_01 Short,
      NNHOPE_01 Double( 4 ),
      COZNPR_01 Char( 8 ),
      CPRACZ_01 Char( 8 ),
      NCISOP_02 Short,
      NNHOPE_02 Double( 4 ),
      COZNPR_02 Char( 8 ),
      CPRACZ_02 Char( 8 ),
      NCISOP_03 Short,
      NNHOPE_03 Double( 4 ),
      COZNPR_03 Char( 8 ),
      CPRACZ_03 Char( 8 ),
      NCISOP_04 Short,
      NNHOPE_04 Double( 4 ),
      COZNPR_04 Char( 8 ),
      CPRACZ_04 Char( 8 ),
      NCISOP_05 Short,
      NNHOPE_05 Double( 4 ),
      COZNPR_05 Char( 8 ),
      CPRACZ_05 Char( 8 ),
      NCISOP_06 Short,
      NNHOPE_06 Double( 4 ),
      COZNPR_06 Char( 8 ),
      CPRACZ_06 Char( 8 ),
      NCISOP_07 Short,
      NNHOPE_07 Double( 4 ),
      COZNPR_07 Char( 8 ),
      CPRACZ_07 Char( 8 ),
      NCISOP_08 Short,
      NNHOPE_08 Double( 4 ),
      COZNPR_08 Char( 8 ),
      CPRACZ_08 Char( 8 ),
      NCISOP_09 Short,
      NNHOPE_09 Double( 4 ),
      COZNPR_09 Char( 8 ),
      CPRACZ_09 Char( 8 ),
      NCISOP_10 Short,
      NNHOPE_10 Double( 4 ),
      COZNPR_10 Char( 8 ),
      CPRACZ_10 Char( 8 ),
      NCISOP_11 Short,
      NNHOPE_11 Double( 4 ),
      COZNPR_11 Char( 8 ),
      CPRACZ_11 Char( 8 ),
      NCISOP_12 Short,
      NNHOPE_12 Double( 4 ),
      COZNPR_12 Char( 8 ),
      CPRACZ_12 Char( 8 ),
      NCISOP_13 Short,
      NNHOPE_13 Double( 4 ),
      COZNPR_13 Char( 8 ),
      CPRACZ_13 Char( 8 ),
      NCISOP_14 Short,
      NNHOPE_14 Double( 4 ),
      COZNPR_14 Char( 8 ),
      CPRACZ_14 Char( 8 ),
      NCISOP_15 Short,
      NNHOPE_15 Double( 4 ),
      COZNPR_15 Char( 8 ),
      CPRACZ_15 Char( 8 ),
      NCISOP_16 Short,
      NNHOPE_16 Double( 4 ),
      COZNPR_16 Char( 8 ),
      CPRACZ_16 Char( 8 ),
      NCISOP_17 Short,
      NNHOPE_17 Double( 4 ),
      COZNPR_17 Char( 8 ),
      CPRACZ_17 Char( 8 ),
      NCISOP_18 Short,
      NNHOPE_18 Double( 4 ),
      COZNPR_18 Char( 8 ),
      CPRACZ_18 Char( 8 ),
      NCISOP_19 Short,
      NNHOPE_19 Double( 4 ),
      COZNPR_19 Char( 8 ),
      CPRACZ_19 Char( 8 ),
      NCISOP_20 Short,
      NNHOPE_20 Double( 4 ),
      COZNPR_20 Char( 8 ),
      CPRACZ_20 Char( 8 ),
      NCISOP_21 Short,
      NNHOPE_21 Double( 4 ),
      COZNPR_21 Char( 8 ),
      CPRACZ_21 Char( 8 ),
      NCISOP_22 Short,
      NNHOPE_22 Double( 4 ),
      COZNPR_22 Char( 8 ),
      CPRACZ_22 Char( 8 ),
      NCISOP_23 Short,
      NNHOPE_23 Double( 4 ),
      COZNPR_23 Char( 8 ),
      CPRACZ_23 Char( 8 ),
      NCISOP_24 Short,
      NNHOPE_24 Double( 4 ),
      COZNPR_24 Char( 8 ),
      CPRACZ_24 Char( 8 ),
      NCISOP_25 Short,
      NNHOPE_25 Double( 4 ),
      COZNPR_25 Char( 8 ),
      CPRACZ_25 Char( 8 ),
      NCISOP_26 Short,
      NNHOPE_26 Double( 4 ),
      COZNPR_26 Char( 8 ),
      CPRACZ_26 Char( 8 ),
      NCISOP_27 Short,
      NNHOPE_27 Double( 4 ),
      COZNPR_27 Char( 8 ),
      CPRACZ_27 Char( 8 ),
      NCISOP_28 Short,
      NNHOPE_28 Double( 4 ),
      COZNPR_28 Char( 8 ),
      CPRACZ_28 Char( 8 ),
      NCISOP_29 Short,
      NNHOPE_29 Double( 4 ),
      COZNPR_29 Char( 8 ),
      CPRACZ_29 Char( 8 ),
      NCISOP_30 Short,
      NNHOPE_30 Double( 4 ),
      COZNPR_30 Char( 8 ),
      CPRACZ_30 Char( 8 ),
      NNHOPE_CEL Double( 4 ),
      CHOTOV_01 Char( 1 ),
      CHOTOV_02 Char( 1 ),
      CHOTOV_03 Char( 1 ),
      CHOTOV_04 Char( 1 ),
      CHOTOV_05 Char( 1 ),
      CHOTOV_06 Char( 1 ),
      CHOTOV_07 Char( 1 ),
      CHOTOV_08 Char( 1 ),
      CHOTOV_09 Char( 1 ),
      CHOTOV_10 Char( 1 ),
      CHOTOV_11 Char( 1 ),
      CHOTOV_12 Char( 1 ),
      CHOTOV_13 Char( 1 ),
      CHOTOV_14 Char( 1 ),
      CHOTOV_15 Char( 1 ),
      CHOTOV_16 Char( 1 ),
      CHOTOV_17 Char( 1 ),
      CHOTOV_18 Char( 1 ),
      CHOTOV_19 Char( 1 ),
      CHOTOV_20 Char( 1 ),
      CHOTOV_21 Char( 1 ),
      CHOTOV_22 Char( 1 ),
      CHOTOV_23 Char( 1 ),
      CHOTOV_24 Char( 1 ),
      CHOTOV_25 Char( 1 ),
      CHOTOV_26 Char( 1 ),
      CHOTOV_27 Char( 1 ),
      CHOTOV_28 Char( 1 ),
      CHOTOV_29 Char( 1 ),
      CHOTOV_30 Char( 1 ),
      NOSCISPRAC Integer,
      NCISOPER Short,
      DVYHOTSKUT Date,
      CZAPIS Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   't_vpobj',
   't_vpobj.adi',
   'R06_01',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_vpobj',
   't_vpobj.adi',
   'R07_02',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 't_vpobj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 't_vpobjfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_vpobj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 't_vpobjfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_vpobj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 't_vpobjfail');

CREATE TABLE t_zaspra ( 
      NROKVYTVOR Short,
      NPORCISLIS Double( 0 ),
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CNAZEV Char( 30 ),
      NCISOPER Short,
      NUKONOPER Short,
      NVAROPER Short,
      COZNOPER Char( 10 ),
      MTEXTOPER Memo,
      CTYPOPER Char( 3 ),
      CNAZOPER Char( 25 ),
      CSTRED Char( 8 ),
      COZNPRAC Char( 8 ),
      CPRACZAR Char( 8 ),
      CKVALNORM Char( 2 ),
      NKUSOVCAS Double( 4 ),
      NPRIPRCAS Double( 2 ),
      NNHNAOPEPL Double( 4 ),
      NNHNAOPESK Double( 4 ),
      NNMNAOPEPL Double( 3 ),
      NNMNAOPESK Double( 3 ),
      NKCNAOPEPL Double( 3 ),
      NKCNAOPESK Double( 3 ),
      DVYHOTPLAN Date,
      NKUSYCELK Double( 2 ),
      NKUSYHOTOV Double( 2 ),
      CMATERPOZA Char( 2 ),
      CZAPKAPAC Char( 2 ),
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NCISLOKUSU Integer,
      DDATVYR Date,
      CCISPLAN Char( 15 ),
      DDATVYROD Date,
      DDATVYRDO Date,
      CCISPLANOD Char( 15 ),
      CCISPLANDO Char( 15 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD2',
   'STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 't_zaspra', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 't_zasprafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_zaspra', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 't_zasprafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 't_zaspra', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 't_zasprafail');

CREATE TABLE tm_vekka ( 
      CRODCISPRA Char( 13 ),
      MPORPRAVZT Memo,
      MODPOCPOL Memo,
      MTYPDUCHOD Memo,
      MRODPRISL Memo,
      MVYUCTNEMD Memo,
      CKMENSTRPR Char( 8 ),
      CTMKMSTRPR Char( 8 ),
      CPRACZAR Char( 8 ),
      NKAT30MUZI Short,
      NKAT30ZENY Short,
      NKAT30VEK Short,
      NKAT40MUZI Short,
      NKAT40ZENY Short,
      NKAT40VEK Short,
      NKAT50MUZI Short,
      NKAT50ZENY Short,
      NKAT50VEK Short,
      NKAT57MUZI Short,
      NKAT57ZENY Short,
      NKAT57VEK Short,
      NKAT62MUZI Short,
      NKAT62ZENY Short,
      NKAT62VEK Short,
      NKAT63MUZI Short,
      NKAT63ZENY Short,
      NKAT63VEK Short,
      NVEKPRACOV Short,
      NTMPITSUM Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tm_vekka',
   'tm_vekka.adi',
   'TMPMZLH1',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tm_vekka',
   'tm_vekka.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tm_vekka', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tm_vekkafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tm_vekka', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tm_vekkafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tm_vekka', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tm_vekkafail');

CREATE TABLE tmp_cmzd ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      CPRACZAR Char( 8 ),
      NPRIJEMCEL Double( 2 ),
      NNEMOCCEL Double( 2 ),
      NHRUBAMZDA Double( 2 ),
      NSOCPOJZAM Double( 2 ),
      NZDRPOJZAM Double( 2 ),
      NDANCELKEM Double( 2 ),
      NFYZSTAVOB Short,
      NFYZSTAVKO Short,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NPOCETTMP Short,
      NPRUMESMZH Double( 2 ),
      NPRUMESMZC Double( 2 ),
      MVYUCTNEMD Memo,
      MSRAZKPRAC Memo,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_cmzd',
   'tmp_cmzd.adi',
   'TMPCMZ01',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_cmzd',
   'tmp_cmzd.adi',
   'TMPCMZ02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_cmzd',
   'tmp_cmzd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_cmzd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_cmzdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_cmzd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_cmzdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_cmzd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_cmzdfail');

CREATE TABLE tmp_mzlh ( 
      NOSCISPRAC Integer,
      MPORPRAVZT Memo,
      MODPOCPOL Memo,
      MTYPDUCHOD Memo,
      MRODPRISL Memo,
      MVYUCTNEMD Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_mzlh',
   'tmp_mzlh.adi',
   'TMPMZLH1',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_mzlh',
   'tmp_mzlh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_mzlh', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_mzlhfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_mzlh', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_mzlhfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_mzlh', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_mzlhfail');

CREATE TABLE tmp_mzli ( 
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CKMENSTRPR Char( 8 ),
      NROK Short,
      NTYPRADMZL Short,
      NRADMZDLIS Short,
      NOBDOBI_01 Double( 2 ),
      COBDOBI_01 Char( 10 ),
      NOBDOBI_02 Double( 2 ),
      COBDOBI_02 Char( 10 ),
      NOBDOBI_03 Double( 2 ),
      COBDOBI_03 Char( 10 ),
      NOBDOBI_04 Double( 2 ),
      COBDOBI_04 Char( 10 ),
      NOBDOBI_05 Double( 2 ),
      COBDOBI_05 Char( 10 ),
      NOBDOBI_06 Double( 2 ),
      COBDOBI_06 Char( 10 ),
      NOBDOBI_07 Double( 2 ),
      COBDOBI_07 Char( 10 ),
      NOBDOBI_08 Double( 2 ),
      COBDOBI_08 Char( 10 ),
      NOBDOBI_09 Double( 2 ),
      COBDOBI_09 Char( 10 ),
      NOBDOBI_10 Double( 2 ),
      COBDOBI_10 Char( 10 ),
      NOBDOBI_11 Double( 2 ),
      COBDOBI_11 Char( 10 ),
      NOBDOBI_12 Double( 2 ),
      COBDOBI_12 Char( 10 ),
      NCELKEMROK Double( 2 ),
      CCELKEMROK Char( 10 ),
      CPRACTMSOR Char( 25 ),
      NPORDUCHOD Short,
      CRODCISRP Char( 13 ),
      CTYPRODPRI Char( 4 ),
      NFOOT Short,
      CTYPVALUER Char( 1 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'TMPMZLI1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'TMPMZLI2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'TMPMZLI3',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NFOOT,1) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_mzli', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_mzlifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_mzli', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_mzlifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_mzli', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_mzlifail');

CREATE TABLE tmp_nemr ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      CPRACZAR Char( 8 ),
      NDOKLAD Double( 0 ),
      NDRUHMZDY Short,
      NMUZ Short,
      NZENA Short,
      NNEMOC Double( 2 ),
      NPRACURAZ Double( 2 ),
      NOCR Double( 2 ),
      NPENPOMMAT Double( 2 ),
      NNARDITETE Double( 2 ),
      NPOHREB Double( 2 ),
      NDOPRLAZNE Double( 2 ),
      NVYROVPRIS Double( 2 ),
      NMATPRID Double( 2 ),
      NPOCDNUNEM Double( 2 ),
      NPOCDNUOCR Double( 2 ),
      NPOCPRIPPM Double( 2 ),
      NPOCPRIVPM Double( 2 ),
      NNEMOCTMP1 Double( 2 ),
      NNEMOCTMP2 Double( 2 ),
      NNEMOCTMP3 Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_nemr',
   'tmp_nemr.adi',
   'TMPNEMR1',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_nemr',
   'tmp_nemr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_nemr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_nemrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_nemr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_nemrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_nemr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_nemrfail');

CREATE TABLE tmp_ppri ( 
      NROK Short,
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      CRODCISPRA Char( 13 ),
      CPRACZAR Char( 8 ),
      CZUCTOBD Char( 40 ),
      NPRIJEMCEL Double( 2 ),
      NPOJISTCEL Double( 2 ),
      NZAKLADDAN Double( 2 ),
      NZALOHADAN Double( 2 ),
      NSLEVADAN Double( 2 ),
      NBONUSDAN Double( 2 ),
      MODPOCPOLI Memo,
      MODPOCPOLD Memo,
      MODPOCPOLS Memo,
      MODPOCPOLU Memo,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_ppri',
   'tmp_ppri.adi',
   'TMPPRICE',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_ppri',
   'tmp_ppri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_ppri', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_pprifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_ppri', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_pprifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_ppri', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_pprifail');

CREATE TABLE tmp_prpr ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CKMENSTRPR Char( 8 ),
      CDELKPRDOB Char( 20 ),
      CPRACZAR Char( 8 ),
      NKALDNYODP Integer,
      NKALHODODP Double( 2 ),
      NHODFONDUP Double( 2 ),
      NPREPPRADN Double( 2 ),
      NPREPPRAHO Double( 2 ),
      NFYZIPRADN Double( 2 ),
      NFYZIPRAHO Double( 2 ),
      NFYZSTAVOB Short,
      NFYZSTAVKO Short,
      NFYZSTAVPR Double( 2 ),
      NPRESTAVPR Double( 2 ),
      NONEITEM Short,
      NPRUMPRSTP Short,
      NPOVPODVPR Short,
      NPREPSTZPS Double( 2 ),
      NODEBVYZPS Double( 2 ),
      NCELKPLPOV Short,
      NODVSTROZA Short,
      NVYSEODVOS Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_prpr',
   'tmp_prpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_prpr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_prprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_prpr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_prprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_prpr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_prprfail');

CREATE TABLE tmp_term ( 
      CTYPPRER Char( 1 ),
      CROK Char( 4 ),
      NROK Short,
      CMESIC Char( 2 ),
      NMESIC Short,
      CDEN Char( 2 ),
      NDEN Short,
      CCAS Char( 5 ),
      CDENVTYDNU Char( 1 ),
      CIDOSKARTY Char( 3 ),
      CADRTERM Char( 4 ),
      CSNTERM Char( 6 ),
      DDATUM Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_term',
   'tmp_term.adi',
   'TMPTER01',
   'UPPER(CIDOSKARTY) +DTOS (DDATUM) +UPPER(CCAS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_term',
   'tmp_term.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_term', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_termfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_term', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_termfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_term', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_termfail');

CREATE TABLE tmp_uctp ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NORDUCTO Short,
      NSUBUCTO Short,
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 2 ),
      NKLICNS Integer,
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      CTYP_R Char( 3 ),
      NMNOZNAT Double( 2 ),
      CZKRATJEDN Char( 3 ),
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 25 ),
      CUZAVRENI Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOHA Char( 1 ),
      NDOKLADORG Double( 0 ),
      NMAINITEM Integer,
      NRECITEM Integer,
      CPRIZLIKV Char( 1 ),
      NMNOZNAT2 Double( 2 ),
      CZKRATJED2 Char( 3 ),
      CTMKMSTRPR Char( 8 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      NPODR_UCT Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO11',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_uctp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_uctpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_uctp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_uctpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_uctp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_uctpfail');

CREATE TABLE tmp_vykz ( 
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 35 ),
      NPOHLAVI Short,
      CPOHLAVI Char( 4 ),
      NPRACZARAZ Short,
      CPRACZARAZ Char( 25 ),
      NPRACZARVY Short,
      CPRACZARVY Char( 25 ),
      CVZDELANI Char( 20 ),
      NVEK Short,
      NKATEGVEK Short,
      CKATEGVEK Char( 5 ),
      NHODFONDPD Double( 2 ),
      NKATODPHOD Short,
      CKATODPHOD Char( 20 ),
      NTMPITEM Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmp_vykz',
   'tmp_vykz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_vykz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmp_vykzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_vykz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmp_vykzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmp_vykz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmp_vykzfail');

CREATE TABLE tmpdav ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      NPORPRAVZT Short,
      NTYPPRAVZT Short,
      NTYPZAMVZT Short,
      NCLENSPOL Short,
      CMZDKATPRA Char( 8 ),
      CPRACZAR Char( 8 ),
      CPRACZARDO Char( 8 ),
      NEXTFAKTUR Short,
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZKRATJEDN Char( 3 ),
      NCISPRACE Short,
      NSPOTRPHM Double( 2 ),
      CZKRNORMY Char( 4 ),
      NDNYDOKLAD Double( 1 ),
      NDRUHMZDY Short,
      NSAZBADOKL Double( 2 ),
      NHODDOKLAD Double( 2 ),
      NMNPDOKLAD Double( 2 ),
      NPREMIE Short,
      NHRUBAMZD Double( 2 ),
      NDNYFONDKD Double( 2 ),
      NDNYFONDPD Double( 2 ),
      NDNYDOVOL Double( 2 ),
      NHODFONDKD Double( 2 ),
      NHODFONDPD Double( 2 ),
      NHODPRESC Double( 2 ),
      NHODPRESCS Double( 2 ),
      NHODPRIPL Double( 2 ),
      NPRUMCP Double( 2 ),
      NPRUMSP Double( 2 ),
      NPRUMPO Double( 2 ),
      NPRUMMZDCP Double( 2 ),
      NPRUMMZDSP Double( 2 ),
      NPRUMMZDPO Double( 2 ),
      NHODFONPDK Double( 2 ),
      NHODNAHRVO Double( 2 ),
      NHODNEMPRC Double( 2 ),
      NDNYNEMPRC Double( 2 ),
      NDNYNEMKAL Double( 2 ),
      NOPRACHOD Double( 2 ),
      NOPRACDNY Double( 2 ),
      NMZDAZAODH Double( 2 ),
      NPRESCASKC Double( 2 ),
      NDOVOLHOD Double( 2 ),
      NDOVOLKC Double( 2 ),
      NOSTNAHRHO Double( 2 ),
      NOSTNAHRKC Double( 2 ),
      NPRIPLATKC Double( 2 ),
      NHRUBAMZKC Double( 2 ),
      NPORADI Integer,
      DDATUMOD Date,
      DDATUMDO Date,
      NDNYVYLOCD Double( 2 ),
      NDNYVYLDOD Double( 2 ),
      NZDRPOJIS Short,
      CTMKMSTRPR Char( 8 ),
      NTMPNUM1 Double( 2 ),
      NTMPNUM2 Double( 2 ),
      NTMPPREMIE Double( 2 ),
      LRUCPORIZ Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV8',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpdav',
   'tmpdav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpdav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmpdavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpdav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmpdavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpdav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmpdavfail');

CREATE TABLE tmpprecs ( 
      CTYPTRANS Char( 2 ),
      NCASTKA Integer,
      CCASTKA Char( 15 ),
      CDATTRANS Char( 6 ),
      CKODBAN Char( 7 ),
      CPREDCI Char( 6 ),
      CUCET Char( 10 ),
      CSPECSYM Char( 10 ),
      CKONSYM Char( 4 ),
      CTEXT Char( 17 ),
      CVARSYM1 Char( 10 ),
      CVARSYM2 Char( 10 ),
      CSPECSYM2 Char( 10 ),
      NPODNIK Integer,
      NTYPUCTU Short,
      NOP_CS Short,
      NOU_CS Short,
      NTYPTRANS Short,
      NCISLOUCSK Short,
      NSPECSYMB Double( 0 ),
      NTYPAGENDY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpprecs',
   'tmpprecs.adi',
   'TMPCS_01',
   'STRZERO(NPODNIK, 5) +STRZERO(NTYPUCTU,2) +STRZERO(NOP_CS,3) +STRZERO(NOU_CS,3) +STRZERO(NTYPTRANS,2) +STRZERO(NTYPAGENDY,2) +STRZERO(NCISLOUCSK,2) +UPPER(CSPECSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpprecs',
   'tmpprecs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprecs', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmpprecsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprecs', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmpprecsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprecs', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmpprecsfail');

CREATE TABLE tmpprefo ( 
      NPORCISLO Integer,
      CTYPTRANS Char( 2 ),
      CDATTRANS Char( 6 ),
      CKODBANVL Char( 4 ),
      CKODBANPR Char( 4 ),
      NCASTKA Integer,
      CCASTKA Char( 15 ),
      CDATSPLAT Char( 6 ),
      CKONSYM Char( 10 ),
      CVARSYMKRE Char( 10 ),
      CSPECSYMKR Char( 10 ),
      CPREDCIVL Char( 6 ),
      CUCETVL Char( 10 ),
      CPREDCIPR Char( 6 ),
      CUCETPR Char( 10 ),
      CKREDINF Char( 140 ),
      CNAZUCTVL Char( 20 ),
      CNAZUCTPR Char( 20 ),
      CVARSYMDEB Char( 10 ),
      CSPECSYMDE Char( 10 ),
      CDEBETINF Char( 140 ),
      CBANKINF Char( 140 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpprefo',
   'tmpprefo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprefo', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmpprefofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprefo', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmpprefofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprefo', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmpprefofail');

CREATE TABLE tmpprekb ( 
      CTYPTRANS Char( 2 ),
      NCASTKA Integer,
      CCASTKA Char( 15 ),
      CDATTRANS Char( 6 ),
      CKODBAN Char( 7 ),
      CPREDCI Char( 6 ),
      CUCET Char( 17 ),
      CSPECSYM Char( 10 ),
      CKONSYM Char( 4 ),
      CTEXT Char( 17 ),
      CVARSYM1 Char( 10 ),
      CVARSYM2 Char( 10 ),
      CSPECSYM2 Char( 10 ),
      NPODNIK Integer,
      NOP_CS Short,
      NOU_CS Short,
      NTYPTRANS Short,
      NCISLOUCSK Short,
      NSPECSYMB Double( 0 ),
      NTYPAGENDY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpprekb',
   'tmpprekb.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprekb', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmpprekbfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprekb', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmpprekbfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpprekb', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmpprekbfail');

CREATE TABLE tmpsumko ( 
      NOSCISPRAC Integer,
      CKMENSTRPR Char( 8 ),
      COBDOBI Char( 5 ),
      NOBDOBI Short,
      NROK Short,
      NFONDPDHO Double( 2 ),
      NFONDPDDN Double( 2 ),
      NFONDSVHO Double( 2 ),
      NFONDSVDN Double( 2 ),
      NFONDPSHO Double( 2 ),
      NFONDPSDN Double( 2 ),
      NODPRACOHO Double( 2 ),
      NODPRACODN Double( 2 ),
      NDOVOLENHO Double( 2 ),
      NDOVOLENDN Double( 2 ),
      NSVATKYHO Double( 2 ),
      NSVATKYDN Double( 2 ),
      NNEMOCENHO Double( 2 ),
      NNEMOCENDN Double( 2 ),
      NNEPLVOLHO Double( 2 ),
      NNEPLVOLDN Double( 2 ),
      NOCRHO Double( 2 ),
      NOCRDN Double( 2 ),
      NNAHZMZDHO Double( 2 ),
      NNAHZMZDDN Double( 2 ),
      NREFUMZDHO Double( 2 ),
      NREFUMZDDN Double( 2 ),
      NOSTNAHRHO Double( 2 ),
      NOSTNAHRDN Double( 2 ),
      NABSENCEHO Double( 2 ),
      NABSENCEDN Double( 2 ),
      NPRESC25HO Double( 2 ),
      NPRESC50HO Double( 2 ),
      NSVATPRIHO Double( 2 ),
      NNOCNPRIHO Double( 2 ),
      NODMENYHO Double( 2 ),
      NVYROBAHO Double( 2 ),
      NVYROBADN Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpsumko',
   'tmpsumko.adi',
   'TSUMKO01',
   'NOSCISPRAC',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpsumko',
   'tmpsumko.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpsumko', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmpsumkofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpsumko', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmpsumkofail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpsumko', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmpsumkofail');

CREATE TABLE tmpvyupr ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      NPORPRAVZT Short,
      CPRACZAR Char( 8 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      DDATPORIZ Date,
      CKMENSTRST Char( 8 ),
      CKMENSTR Char( 8 ),
      NCISPRACE Short,
      NUCETMZDY Short,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NDRUHMZDY Short,
      CZKRATJEDN Char( 3 ),
      CUCETNAK Char( 6 ),
      CUCETVYN Char( 6 ),
      NSAZBAVNU Double( 2 ),
      NCELKEMVNU Double( 2 ),
      NMNOZSVNU Double( 2 ),
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpvyupr',
   'tmpvyupr.adi',
   'TMVYU_01',
   'STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tmpvyupr',
   'tmpvyupr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpvyupr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tmpvyuprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpvyupr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tmpvyuprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tmpvyupr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tmpvyuprfail');

CREATE TABLE tpv_r02 ( 
      NKEY Short,
      MHEAD Memo,
      MLINE Memo,
      MMEMO1 Memo,
      MMEMO2 Memo,
      CCISSKLAD Char( 8 ),
      NUCETSKUP Short,
      CCISZAKAZ Char( 30 ),
      CVYSPOL Char( 15 ),
      NVYSVAR Short,
      NMNFINAL Double( 3 ),
      MHEADHD Memo,
      MSKLAD Memo,
      MTEXT1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'tpv_r02',
   'tpv_r02.adi',
   'TPV2_1',
   'STRZERO(NKEY,1) +UPPER(CCISSKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'tpv_r02',
   'tpv_r02.adi',
   'TPV2_2',
   'STRZERO(NKEY,1) +STRZERO(NUCETSKUP,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'tpv_r02', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'tpv_r02fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tpv_r02', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'tpv_r02fail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'tpv_r02', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'tpv_r02fail');

CREATE TABLE trvalzav ( 
      CZKRTYPZAV Char( 5 ),
      CNAZEVZAV Char( 30 ),
      CZKRTYPUHR Char( 5 ),
      CBANK_UCT Char( 25 ),
      CUCET Char( 25 ),
      CVARSYM Char( 15 ),
      NKONSTSYMB Integer,
      CSPECSYMB Char( 20 ),
      DSPLATZAV Date,
      CULOHA Char( 1 ),
      LKMENSRZ Logical,
      LCASTUHRAD Logical,
      CZPUSSRAZ Char( 6 ),
      MPOPISZAV Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'trvalzav',
   'trvalzav.adi',
   'TRVZAV01',
   'UPPER(CZKRTYPZAV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'trvalzav',
   'trvalzav.adi',
   'TRVZAV02',
   'UPPER(CNAZEVZAV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'trvalzav',
   'trvalzav.adi',
   'TRVZAV03',
   'UPPER(CBANK_UCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'trvalzav',
   'trvalzav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'trvalzav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'trvalzavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'trvalzav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'trvalzavfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'trvalzav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'trvalzavfail');

CREATE TABLE typdokl ( 
      CTASK Char( 3 ),
      CULOHA Char( 1 ),
      CPODULOHA Char( 15 ),
      CTYPDOKLAD Char( 10 ),
      CNAZTYPDOK Char( 30 ),
      CTYPCRD Char( 20 ),
      CFILEDRUHY Char( 10 ),
      CMAINFILE Char( 10 ),
      CZUSTUCT Char( 1 ),
      DPLATNYOD Date,
      DPLATNYDO Date,
      MMACRO Memo,
      MCONDUCTO Memo,
      MPOPISDOKL Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL01',
   'UPPER(CULOHA)+UPPER(CPODULOHA) +UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL02',
   'UPPER(CULOHA)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL03',
   'UPPER(CTYPDOKLAD)+UPPER(CULOHA)+UPPER(CPODULOHA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL04',
   'UPPER(CTASK)+UPPER(CPODULOHA) +UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL05',
   'UPPER(CTASK)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL06',
   'UPPER(CTYPDOKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'typdokl',
   'typdokl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'typdokl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'typdoklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'typdokl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'typdoklfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'typdokl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'typdoklfail');

CREATE TABLE ucetdohd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      DPORIZDOK Date,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CVARSYM Char( 15 ),
      CTYPOBRATU Char( 3 ),
      NTYPOBRATU Short,
      CTEXTDOK Char( 40 ),
      NKLICDPH Short,
      NOSVODDAN Double( 2 ),
      NPROCDAN_1 Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      CUCTDPH_1 Char( 6 ),
      NPROCDAN_2 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      CUCTDPH_2 Char( 6 ),
      NCENZAKCEL Double( 2 ),
      NKODZAOKR Short,
      NKODZAOKRD Short,
      CZKRATMENY Char( 3 ),
      DSPLATDOK Date,
      DVYSTDOK Date,
      DDATTISK Date,
      DPOSLIKDOK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELDOK Double( 2 ),
      NCISUZV Short,
      DDATUZV Date,
      CUCET_UCT Char( 6 ),
      CDENIK Char( 2 ),
      NNULLDPH Short,
      CDENIK_PAR Char( 2 ),
      NCISFAK Double( 0 ),
      NCISFIRMY Integer,
      CKEYS_PZ Char( 19 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      NUHRCELFAK Double( 2 ),
      NUHRCELFAZ Double( 2 ),
      CZKRATMENF Char( 3 ),
      NKURZMENU Double( 8 ),
      NMNOZPREU Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_1',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_2',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_3',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_6',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_7',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdohd',
   'ucetdohd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetdohd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetdohdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetdohd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetdohdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetdohd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetdohdfail');

CREATE TABLE ucetdoit ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NORDUCTO Short,
      NSUBUCTO Short,
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 2 ),
      NKLICNS Integer,
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      CTYP_R Char( 3 ),
      NMNOZNAT Double( 4 ),
      CZKRATJEDN Char( 3 ),
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 50 ),
      CUZAVRENI Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOHA Char( 1 ),
      NDOKLADORG Double( 0 ),
      NMAINITEM Double( 0 ),
      NRECITEM Double( 0 ),
      CPRIZLIKV Char( 1 ),
      NMNOZNAT2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      CUSERABB Char( 8 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,2) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetdoit',
   'ucetdoit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetdoit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetdoitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetdoit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetdoitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetdoit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetdoitfail');

CREATE TABLE uceterr ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CTASKS Char( 15 ),
      CDENIK Char( 2 ),
      CDENIK_CFG Char( 19 ),
      NDOKLAD Double( 0 ),
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 25 ),
      CTEXTERRS Char( 25 ),
      NCENZAKCEL Double( 2 ),
      NLIKCELDOK Double( 2 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DDATTISK Date,
      DDATUZV Date,
      CERR Char( 7 ),
      LISEXT Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterr',
   'uceterr.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterr',
   'uceterr.adi',
   'UZAVER_2',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterr',
   'uceterr.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterr',
   'uceterr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uceterr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uceterrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uceterr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uceterrfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uceterr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uceterrfail');

CREATE TABLE uceterri ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NORDUCTO Short,
      NSUBUCTO Short,
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 2 ),
      NKLICNS Integer,
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      CTYP_R Char( 3 ),
      NMNOZNAT Double( 4 ),
      CZKRATJEDN Char( 3 ),
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 25 ),
      CUZAVRENI Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOHA Char( 1 ),
      NDOKLADORG Double( 0 ),
      NMAINITEM Integer,
      NRECITEM Integer,
      CPRIZLIKV Char( 1 ),
      NMNOZNAT2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      MPOPISERR Memo,
      CERR Char( 7 ),
      CUSERABB_ Char( 8 ),
      DDATZMENY_ Date,
      CCASZMENY_ Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,2) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uceterri',
   'uceterri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uceterri', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uceterrifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uceterri', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uceterrifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uceterri', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uceterrifail');

CREATE TABLE ucetkum ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CUCETMD Char( 6 ),
      CUCETTR Char( 1 ),
      CUCETSK Char( 2 ),
      CUCETSY Char( 3 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NKCMDPSO Double( 2 ),
      NKCDALPSO Double( 2 ),
      NKCMDOBRO Double( 2 ),
      NKCDALOBRO Double( 2 ),
      NKCMDPSR Double( 2 ),
      NKCDALPSR Double( 2 ),
      NKCMDOBRR Double( 2 ),
      NKCDALOBRR Double( 2 ),
      NKCMDKSR Double( 2 ),
      NKCDALKSR Double( 2 ),
      NMNOZNAT Double( 4 ),
      NMNOZNAT2 Double( 4 ),
      NMNOZNATR Double( 2 ),
      NMNOZNAT2R Double( 2 ),
      NAKTUC_CNT Short,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_02',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_03',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_04',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_07',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_08',
   'UPPER(CNAZPOL2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_09',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_10',
   'UPPER(CNAZPOL4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_11',
   'UPPER(CNAZPOL5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_12',
   'UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkum',
   'ucetkum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkum', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetkumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkum', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetkumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkum', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetkumfail');

CREATE TABLE ucetkumk ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CUCETMD Char( 6 ),
      CUCETTR Char( 1 ),
      CUCETSK Char( 2 ),
      CUCETSY Char( 3 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NKCMDPSO Double( 2 ),
      NKCDALPSO Double( 2 ),
      NKCMDOBRO Double( 2 ),
      NKCDALOBRO Double( 2 ),
      NKCMDPSR Double( 2 ),
      NKCDALPSR Double( 2 ),
      NKCMDOBRR Double( 2 ),
      NKCDALOBRR Double( 2 ),
      NKCMDKSR Double( 2 ),
      NKCDALKSR Double( 2 ),
      NMNOZNAT Double( 2 ),
      NMNOZNAT2 Double( 2 ),
      NMNOZNATR Double( 4 ),
      NMNOZNAT2R Double( 4 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_02',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_03',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_04',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumk',
   'ucetkumk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkumk', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetkumkfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkumk', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetkumkfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkumk', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetkumkfail');

CREATE TABLE ucetkumu ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CUCETMD Char( 6 ),
      CUCETTR Char( 1 ),
      CUCETSK Char( 2 ),
      CUCETSY Char( 3 ),
      NKCMDPSO Double( 2 ),
      NKCDALPSO Double( 2 ),
      NKCMDOBRO Double( 2 ),
      NKCDALOBRO Double( 2 ),
      NKCMDPSR Double( 2 ),
      NKCDALPSR Double( 2 ),
      NKCMDOBRR Double( 2 ),
      NKCDALOBRR Double( 2 ),
      NKCMDKSR Double( 2 ),
      NKCDALKSR Double( 2 ),
      NKCMDKSRD Double( 2 ),
      NKCDALKSRD Double( 2 ),
      NMNOZNAT Double( 4 ),
      NMNOZNAT2 Double( 4 ),
      NMNOZNATR Double( 2 ),
      NMNOZNAT2R Double( 2 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumu',
   'ucetkumu.adi',
   'UCETK_01',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumu',
   'ucetkumu.adi',
   'UCETK_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetkumu',
   'ucetkumu.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkumu', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetkumufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkumu', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetkumufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetkumu', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetkumufail');

CREATE TABLE ucetplah ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CUCETMD Char( 6 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NPOCOBD_PL Short,
      NPLANZAOBD Double( 2 ),
      NPLANKOBD Double( 2 ),
      NPLANROK Double( 2 ),
      NPLAN_POL Double( 2 ),
      NPLAN_CTV Double( 2 ),
      NMNOZNAT Double( 4 ),
      NMNOZNAT2 Double( 4 ),
      NPLANZAOOR Double( 2 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetplah',
   'ucetplah.adi',
   'UCETPL01',
   'STRZERO(NROK,4) +UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetplah',
   'ucetplah.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetplah', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetplahfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetplah', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetplahfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetplah', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetplahfail');

CREATE TABLE ucetplan ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CUCETMD Char( 6 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NPLANZAOBD Double( 2 ),
      NPLANKOBD Double( 2 ),
      NPLANROK Double( 2 ),
      NPLAN_POL Double( 2 ),
      NPLAN_CTV Double( 2 ),
      NMNOZNAT Double( 4 ),
      NMNOZNAT2 Double( 4 ),
      NPLANZAOOR Double( 2 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetplan',
   'ucetplan.adi',
   'UCETPL01',
   'STRZERO(NROK,4) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetplan',
   'ucetplan.adi',
   'UCETPL02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetplan',
   'ucetplan.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetplan', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetplanfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetplan', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetplanfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetplan', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetplanfail');

CREATE TABLE ucetpocs ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CUCETMD Char( 6 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NKCMDPSR Double( 2 ),
      NKCDALPSR Double( 2 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpocs',
   'ucetpocs.adi',
   'POCSTU01',
   'STRZERO(NROK,4) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpocs',
   'ucetpocs.adi',
   'POCSTU02',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpocs',
   'ucetpocs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpocs', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetpocsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpocs', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetpocsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpocs', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetpocsfail');

CREATE TABLE ucetpol ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NPOLUCTPR Short,
      NORDUCTO Short,
      NSUBUCTO Short,
      CUCETSKUP Char( 10 ),
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 10 ),
      NKLICNS Integer,
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      CTYP_R Char( 3 ),
      NMNOZNAT Double( 4 ),
      CZKRATJEDN Char( 3 ),
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 50 ),
      CUZAVRENI Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLADORG Double( 0 ),
      NMAINITEM Integer,
      NRECITEM Integer,
      CPRIZLIKV Char( 1 ),
      NMNOZNAT2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      NPODR_UCT Short,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL6',
   'UPPER(CULOHA +COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO11',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO13',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO14',
   'UPPER(CDENIK) +UPPER(CTYPPOHYBU) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO15',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpol',
   'ucetpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpol', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpol', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpol', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetpolfail');

CREATE TABLE ucetpola ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NORDUCTO Short,
      NSUBUCTO Short,
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 2 ),
      NKLICNS Integer,
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      CTYP_R Char( 3 ),
      NMNOZNAT Double( 4 ),
      CZKRATJEDN Char( 3 ),
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 25 ),
      CUZAVRENI Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOHA Char( 1 ),
      NDOKLADORG Double( 0 ),
      NMAINITEM Integer,
      NRECITEM Integer,
      CPRIZLIKV Char( 1 ),
      NMNOZNAT2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO11',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpola',
   'ucetpola.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpola', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetpolafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpola', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetpolafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpola', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetpolafail');

CREATE TABLE ucetpre ( 
      CULOHA Char( 1 ),
      NDRPOHYB Integer,
      NOD Integer,
      NDO Integer,
      CUCTO1 Char( 8 ),
      CUCTO2 Char( 15 ),
      CUCETMD Char( 6 ),
      CTYPUCTMD Char( 2 ),
      CUCETDAL Char( 6 ),
      CTYPUCTDAL Char( 2 ),
      MPODUCT Memo,
      MTXTUCT Memo,
      LHEAD Logical);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpre',
   'ucetpre.adi',
   'UCTSKL1',
   'UPPER(CULOHA) +STRZERO(NDRPOHYB,5) +STRZERO(NOD,5) +UPPER(CUCTO1) +UPPER(CUCTO2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpre',
   'ucetpre.adi',
   'UCTSKL2',
   'UPPER(CULOHA) +IF (LHEAD, ''1'', ''0'') +STRZERO(NDRPOHYB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpre', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetprefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpre', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetprefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpre', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetprefail');

CREATE TABLE ucetpreh ( 
      CKEYUCT Char( 5 ),
      NOD Integer,
      NDO Integer,
      CMAINFILE Char( 10 ),
      CUCTO1 Char( 8 ),
      CUCTO2 Char( 15 ),
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 2 ),
      LHEAD Logical,
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MPODUCT Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpreh',
   'ucetpreh.adi',
   'UCETPR1',
   'UPPER(CKEYUCT) +UPPER(CTYPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpreh',
   'ucetpreh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpreh', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetprehfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpreh', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetprehfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpreh', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetprehfail');

CREATE TABLE ucetpres ( 
      CTYPUCT Char( 2 ),
      NFINTYP Short,
      CPOPISUCT Char( 25 ),
      LISHEAD Logical,
      APOPISUCT Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpres',
   'ucetpres.adi',
   'TYPUCT1',
   'UPPER(CTYPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpres',
   'ucetpres.adi',
   'TYPUCT2',
   'STRZERO(NFINTYP) +UPPER(CTYPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetpres',
   'ucetpres.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpres', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetpresfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpres', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetpresfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetpres', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetpresfail');

CREATE TABLE ucetprhd ( 
      CTASK Char( 3 ),
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CUCETSKUP Char( 10 ),
      CNAZUCPRED Char( 30 ),
      DPLATNYOD Date,
      MPODMINKA Memo,
      MKLIKVID Memo,
      MZLIKVID Memo,
      MPOPISUCPR Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprhd',
   'ucetprhd.adi',
   'UCETPRHD01',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprhd',
   'ucetprhd.adi',
   'UCETPRHD02',
   'UPPER(CULOHA +CTYPPOHYBU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprhd',
   'ucetprhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetprhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetprhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetprhdfail');

CREATE TABLE ucetprit ( 
      CTASK Char( 3 ),
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CMAINFILE Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CUCETSKUP Char( 10 ),
      CNAZUCPRED Char( 30 ),
      DPLATNYOD Date,
      NPOLUCTPR Short,
      NSUBPOLUC Short,
      CTYPUCT Char( 10 ),
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      MPODMINKA Memo,
      MKLIKVID Memo,
      MZLIKVID Memo,
      LWRTRECHD Logical,
      MPOPISUCPR Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT01',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU) +UPPER(CUCETSKUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT02',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU) +UPPER(CUCETSKUP) +STRZERO(NPOLUCTPR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT03',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU) +STRZERO(NPOLUCTPR,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT04',
   'UPPER(CULOHA +CTYPPOHYBU+CUCETSKUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprit',
   'ucetprit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetpritfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetpritfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetpritfail');

CREATE TABLE ucetprsy ( 
      CTYPUCT Char( 10 ),
      CMAINFILE Char( 10 ),
      CNAZTYPUCT Char( 30 ),
      DPLATNYOD Date,
      MUCTUJ_MD Memo,
      MUCTUJ_DAL Memo,
      MPODMINKA Memo,
      MPOPISUCT Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprsy',
   'ucetprsy.adi',
   'UCETPRSY01',
   'UPPER(CTYPUCT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetprsy',
   'ucetprsy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprsy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetprsyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprsy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetprsyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetprsy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetprsyfail');

CREATE TABLE ucetsald ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      CUCETMD Char( 6 ),
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      LZPAROVANO Logical,
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 25 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CULOHA Char( 1 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSLAD03',
   'UPPER(CUCETMD) +UPPER(CSYMBOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD04',
   'UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD05',
   'UPPER(CTEXT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD06',
   'UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD09',
   'UPPER(CUCETMD) +UPPER(CSYMBOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsald',
   'ucetsald.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsald', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetsaldfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsald', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetsaldfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsald', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetsaldfail');

CREATE TABLE ucetsalk ( 
      NROK Short,
      NOBDOBI Short,
      CUCETMD Char( 6 ),
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      LISCLOSE Logical,
      CTEXT Char( 25 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD01',
   'UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD02',
   'LISCLOSE',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD03',
   'UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD04',
   'UPPER(CTEXT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD05',
   'UPPER(CUCETMD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +IF (LISCLOSE, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD08',
   'UPPER(CUCETMD) +UPPER(CSYMBOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsalk',
   'ucetsalk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsalk', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetsalkfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsalk', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetsalkfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsalk', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetsalkfail');

CREATE TABLE ucetsys ( 
      CULOHA Char( 1 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      COBDOBIDAN Char( 5 ),
      LAKTOBD Logical,
      CUCTKDO Char( 8 ),
      DUCTDAT Date,
      CUCTCAS Char( 8 ),
      COTVKDO Char( 8 ),
      DOTVDAT Date,
      COTVCAS Char( 8 ),
      CUZAVROBD Char( 23 ),
      CUZVKDO Char( 8 ),
      DUZVDAT Date,
      CUZVCAS Char( 8 ),
      LZAVREN Logical,
      CUZAVROBDD Char( 23 ),
      COTVKDOD Char( 8 ),
      DOTVDATD Date,
      COTVCASD Char( 8 ),
      CUZVKDOD Char( 8 ),
      DUZVDATD Date,
      CUZVCASD Char( 8 ),
      LZAVREND Logical,
      DAUTKONDEN Date,
      LCONTR_OFF Logical,
      NAKTUC_KS Short,
      NAKTUC_CNT Short,
      CAKTKDO Char( 8 ),
      DAKTDAT Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS1',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS2',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS3',
   'UPPER(CULOHA) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NAKTUC_KS,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS4',
   'UPPER(CULOHA) +IF (LAKTOBD, ''1'', ''0'')',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetsys',
   'ucetsys.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsys', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetsysfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsys', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetsysfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetsys', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetsysfail');

CREATE TABLE ucetuzv ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      NCISUZV Short,
      CUZAVRENI Char( 1 ),
      DDATUZV Date,
      CCASZAHUZV Char( 8 ),
      CCASUKOUZV Char( 8 ),
      CUSERABBUZ Char( 8 ),
      DDATPRENUZ Date,
      DDATZRUSUZ Date,
      CCASZAHZRU Char( 8 ),
      CCASUKOZRU Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetuzv',
   'ucetuzv.adi',
   'UZAVER1',
   'UPPER(CULOHA) +UPPER(COBDOBI) +STRZERO(NCISUZV,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ucetuzv',
   'ucetuzv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetuzv', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucetuzvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetuzv', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucetuzvfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucetuzv', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucetuzvfail');

CREATE TABLE ucprsy ( 
      CTYPUCT Char( 10 ),
      CMAINFILE Char( 10 ),
      CNAZTYPUCT Char( 30 ),
      DPLATNYOD Date,
      MUCTUJ_MD Memo,
      MUCTUJ_DAL Memo,
      MPODMINKA Memo,
      MPOPISUCT Memo,
      MUSERZMENY Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucprsy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ucprsyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucprsy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ucprsyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ucprsy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ucprsyfail');

CREATE TABLE uctdokhd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      NDOKLAD Double( 0 ),
      DPORIZDOK Date,
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      COBDOBIDAN Char( 5 ),
      CVARSYM Char( 15 ),
      CTYPOBRATU Char( 3 ),
      NTYPOBRATU Short,
      CTEXTDOK Char( 40 ),
      NCENZAKCEL Double( 2 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NKODZAOKR Short,
      CZKRATMENY Char( 3 ),
      DSPLATDOK Date,
      DVYSTDOK Date,
      DDATTISK Date,
      DPOSLIKDOK Date,
      CPRIZLIKV Char( 1 ),
      NLIKCELDOK Double( 2 ),
      NCISUZV Short,
      DDATUZV Date,
      CUCET_UCT Char( 6 ),
      CDENIK Char( 2 ),
      NCNTITEM Integer,
      NPODR_UCT Short,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      MPOPIS_UCT Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_1',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_2',
   'UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_3',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_6',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokhd',
   'uctdokhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uctdokhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uctdokhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uctdokhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uctdokhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uctdokhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uctdokhdfail');

CREATE TABLE uctdokit ( 
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NORDUCTO Short,
      NSUBUCTO Short,
      CUCETMD Char( 6 ),
      CUCETDAL Char( 6 ),
      CTYPUCT Char( 2 ),
      NKLICNS Integer,
      CSYMBOL Char( 15 ),
      NKCMD Double( 2 ),
      NKCDAL Double( 2 ),
      CTYP_R Char( 3 ),
      NMNOZNAT Double( 4 ),
      CZKRATJEDN Char( 3 ),
      DDATSPLAT Date,
      DDATPORIZ Date,
      CTEXT Char( 50 ),
      CUZAVRENI Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOHA Char( 1 ),
      NDOKLADORG Double( 0 ),
      NMAINITEM Double( 0 ),
      NRECITEM Double( 0 ),
      CPRIZLIKV Char( 1 ),
      NMNOZNAT2 Double( 4 ),
      CZKRATJED2 Char( 3 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      NPODR_UCT Short,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uctdokit',
   'uctdokit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uctdokit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uctdokitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uctdokit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uctdokitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uctdokit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uctdokitfail');

CREATE TABLE ukoly ( 
      NCISUKOLU Double( 0 ),
      COZNUKOLU Char( 10 ),
      CZKRUKOLU Char( 10 ),
      CNAZUKOLU Char( 50 ),
      MPOPISUKOL Memo,
      CZKRSTARES Char( 10 ),
      DZACUKOLU Date,
      DKONUKOLU Date,
      DPLZACUKOL Date,
      DPLKONUKOL Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'ukoly',
   'ukoly.adi',
   'UKOLY01',
   'NCISUKOLU',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ukoly',
   'ukoly.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ukoly', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ukolyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ukoly', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ukolyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ukoly', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ukolyfail');

CREATE TABLE ulozeni ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CULOZZBO Char( 8 ),
      NPOCSTAV Double( 2 ),
      NULOZMNOZ Double( 2 ),
      NULOZCELK Double( 2 ),
      CPOZNAMKA Char( 30 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'ulozeni',
   'ulozeni.adi',
   'ULOZE1',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + UPPER(CULOZZBO)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ulozeni',
   'ulozeni.adi',
   'ULOZE2',
   'UPPER(CULOZZBO) + UPPER(CSKLPOL) + UPPER(CCISSKLAD)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ulozeni',
   'ulozeni.adi',
   'ULOZE3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CULOZZBO) +STRZERO(NULOZCELK,11)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'ulozeni',
   'ulozeni.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'ulozeni', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'ulozenifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ulozeni', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'ulozenifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'ulozeni', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'ulozenifail');

CREATE TABLE umaj ( 
      NINVCIS Double( 0 ),
      NTYPMAJ Short,
      NROKODPISU Short,
      NODPISK Short,
      NVSCENURPS Double( 2 ),
      NOPRUCTRPS Double( 2 ),
      NZUCENURPS Double( 2 ),
      NTYPUODPI Short,
      CTYPSKP Char( 15 ),
      NPROCUCTOD Double( 2 ),
      NUCTODPROK Double( 2 ),
      NOPRUCTRKS Double( 2 ),
      NZUCENURKS Double( 2 ),
      NVSCENURKS Double( 2 ),
      CODPISK Char( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'umaj',
   'umaj.adi',
   'UMAJ_1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'umaj',
   'umaj.adi',
   'UMAJ_2',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'umaj',
   'umaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'umaj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'umajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'umaj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'umajfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'umaj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'umajfail');

CREATE TABLE umajz ( 
      NINVCIS Double( 0 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NROKODPISU Short,
      NODPISK Short,
      NVSCENURPS Double( 2 ),
      NOPRUCTRPS Double( 2 ),
      NZUCENURPS Double( 2 ),
      NTYPUODPI Short,
      CTYPSKP Char( 15 ),
      NPROCUCTOD Double( 2 ),
      NUCTODPROK Double( 2 ),
      NOPRUCTRKS Double( 2 ),
      NZUCENURKS Double( 2 ),
      NVSCENURKS Double( 2 ),
      CODPISK Char( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'umajz',
   'umajz.adi',
   'UMAJZ_1',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'umajz',
   'umajz.adi',
   'UMAJZ_2',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'umajz',
   'umajz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'umajz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'umajzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'umajz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'umajzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'umajz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'umajzfail');

CREATE TABLE upominhd ( 
      CULOHA Char( 1 ),
      NCISUPOMIN Double( 0 ),
      DUPOMINKY Date,
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      CNAZEV2 Char( 25 ),
      NICO Integer,
      CDIC Char( 16 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CNAZEVDOA2 Char( 25 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      CPRIJEMCE1 Char( 15 ),
      CPRIJEMCE2 Char( 15 ),
      NCENZAKCEL Double( 2 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENY Char( 3 ),
      NKURZAHMEN Double( 3 ),
      NMNOZPREP Integer,
      DDATTISK Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD1',
   'NCISUPOMIN',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD2',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISUPOMIN,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD3',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD4',
   'NICO',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD5',
   'NCENZAKCEL',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'upominhd',
   'upominhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'upominhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'upominhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'upominhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'upominhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'upominhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'upominhdfail');

CREATE TABLE upominit ( 
      CULOHA Char( 1 ),
      NCISUPOMIN Double( 0 ),
      NINTCOUNT Integer,
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      COBDOBI Char( 5 ),
      COBDOBIDAN Char( 5 ),
      NCENZAKCEL Double( 2 ),
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 3 ),
      NMNOZPREP Integer,
      NKONSTSYMB Short,
      CSPECSYMB Char( 20 ),
      NCISFIRMY Integer,
      NCISFIRDOA Integer,
      CNAZEV Char( 50 ),
      DSPLATFAK Date,
      DVYSTFAK Date,
      DPOVINFAK Date,
      DDATTISK Date,
      NUHRCELFAK Double( 2 ),
      DPOSUHRFAK Date,
      NDNYPREK Short,
      NPOCUPOFAK Double( 0 ),
      NCENUPOCEL Double( 2 ),
      CDOPLNTXT Char( 50 ),
      NDOKLADORG Double( 0 ),
      NFAKVYSORG Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'upominit',
   'upominit.adi',
   'UPOMIT1',
   'STRZERO(NCISUPOMIN,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'upominit',
   'upominit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'upominit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'upominitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'upominit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'upominitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'upominit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'upominitfail');

CREATE TABLE users ( 
      CUSER Char( 10 ),
      CPRIHLJMEN Char( 20 ),
      COSOBA Char( 50 ),
      NCISOSOBY Integer,
      CGROUP Char( 10 ),
      COPRAVNENI Char( 10 ),
      DPRIHLUSER Date,
      CPRIHLUSER Char( 8 ),
      NSYSFLT Short,
      DPLATN_OD Date,
      DPLATN_DO Date,
      CPASSWORD Char( 10 ),
      CEMAILWEB Char( 100 ),
      NWEBUSER Short,
      MMENUUSER Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'users',
   'users.adi',
   'USERS01',
   'UPPER(CUSER)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'users',
   'users.adi',
   'USERS02',
   'NCISOSOBY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'users',
   'users.adi',
   'USERS03',
   'UPPER(CPRIHLJMEN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'users',
   'users.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'users', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'usersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'users', 
   'Table_Encryption', 
   'True', 'APPEND_FAIL', 'usersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'users', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'usersfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'users', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'usersfail');

CREATE TABLE usersgrp ( 
      CGROUP Char( 10 ),
      CNAMEGROUP Char( 30 ),
      COPRAVNENI Char( 10 ),
      DPLATN_OD Date,
      DPLATN_DO Date,
      CPASSWORD Char( 10 ),
      MMENUGROUP Memo,
      MMETODIKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'usersgrp',
   'usersgrp.adi',
   'USERSGRP01',
   'UPPER(CGROUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'usersgrp',
   'usersgrp.adi',
   'USERSGRP02',
   'UPPER(CNAMEGROUP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'usersgrp',
   'usersgrp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'usersgrp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'usersgrpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'usersgrp', 
   'Table_Encryption', 
   'True', 'APPEND_FAIL', 'usersgrpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'usersgrp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'usersgrpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'usersgrp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'usersgrpfail');

CREATE TABLE uskutpl ( 
      DPORIZFAK Date,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      CZKRTYPFAK Char( 5 ),
      NKLICDPH Short,
      NOSVODDAN Double( 2 ),
      NZAKLDAN_1 Double( 2 ),
      NSAZDAN_1 Double( 2 ),
      NZAKLDAZ_1 Double( 2 ),
      NSAZDAZ_1 Double( 2 ),
      NZAKLDAN_2 Double( 2 ),
      NSAZDAN_2 Double( 2 ),
      NZAKLDAZ_2 Double( 2 ),
      NSAZDAZ_2 Double( 2 ),
      NNULLDPH_1 Double( 2 ),
      NNULLDPH_2 Double( 2 ),
      NNULLDPH_3 Double( 2 ),
      NVYVOZZBOZ Double( 2 ),
      NVYVOZZBN Double( 2 ),
      NVYVOZSLUZ Double( 2 ),
      NVYVOZPREP Double( 2 ),
      NCENZAKCEL Double( 2 ),
      CZKRATMENY Char( 3 ),
      NCENZAHCEL Double( 2 ),
      CZKRATMENZ Char( 3 ),
      NKURZAHMEN Double( 3 ),
      NCISFIRMY Integer,
      CNAZEV Char( 50 ),
      NCISUZV Short,
      DDATUZV Date,
      CDENIK Char( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_1',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_2',
   'NCISFAK',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_3',
   'UPPER(CVARSYM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_4',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uskutpl',
   'uskutpl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uskutpl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uskutplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uskutpl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uskutplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uskutpl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uskutplfail');

CREATE TABLE usrtypoh ( 
      CUSER Char( 10 ),
      CTASK Char( 1 ),
      CTYPPOHYBU Char( 10 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'usrtypoh',
   'usrtypoh.adi',
   'USRTYPOH01',
   'UPPER(CUSER)+UPPER(CTASK)+UPPER(CTYPPOHYBU)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'usrtypoh',
   'usrtypoh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'usrtypoh', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'usrtypohfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'usrtypoh', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'usrtypohfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'usrtypoh', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'usrtypohfail');

CREATE TABLE uzaverrd ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      CDENIK Char( 2 ),
      CDENIK_CFG Char( 10 ),
      NDOKLAD Double( 0 ),
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 25 ),
      CTEXTERRS Char( 25 ),
      NCENZAKCEL Double( 2 ),
      NLIKCELDOK Double( 2 ),
      DDATTISK Date,
      DDATUZV Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrd',
   'uzaverrd.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrd',
   'uzaverrd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzaverrdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzaverrdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzaverrdfail');

CREATE TABLE uzaverrm ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      CDENIK Char( 2 ),
      CDENIK_CFG Char( 10 ),
      NDOKLAD Integer,
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 25 ),
      CTEXTERRS Char( 25 ),
      NCENZAKCEL Double( 2 ),
      NLIKCELDOK Double( 2 ),
      DDATTISK Date,
      DDATUZV Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrm',
   'uzaverrm.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrm',
   'uzaverrm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrm', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzaverrmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrm', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzaverrmfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrm', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzaverrmfail');

CREATE TABLE uzaverrsf ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      CDENIK Char( 2 ),
      CDENIK_CFG Char( 10 ),
      NDOKLAD Double( 0 ),
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 25 ),
      CTEXTERRS Char( 25 ),
      NCENZAKCEL Double( 2 ),
      NLIKCELDOK Double( 2 ),
      DDATTISK Date,
      DDATUZV Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrsf',
   'uzaverrsf.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrsf',
   'uzaverrsf.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrsf', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzaverrsffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrsf', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzaverrsffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrsf', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzaverrsffail');

CREATE TABLE uzaverrss ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      CDENIK Char( 2 ),
      CDENIK_CFG Char( 10 ),
      NDOKLAD Integer,
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 25 ),
      CTEXTERRS Char( 25 ),
      NCENZAKCEL Double( 2 ),
      NLIKCELDOK Double( 2 ),
      DDATTISK Date,
      DDATUZV Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrss',
   'uzaverrss.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzaverrss',
   'uzaverrss.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrss', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzaverrssfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrss', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzaverrssfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzaverrss', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzaverrssfail');

CREATE TABLE uzavisoz ( 
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      COBDOBI Char( 5 ),
      NCISUZAV Short,
      DDATUZAV Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzavisoz',
   'uzavisoz.adi',
   'UZAVER1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzavisoz',
   'uzavisoz.adi',
   'UZAVER2',
   'UPPER(COBDOBI) +STRZERO(NCISUZAV,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzavisoz',
   'uzavisoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzavisoz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzavisozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzavisoz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzavisozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzavisoz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzavisozfail');

CREATE TABLE uzvdofa ( 
      NCISUZV Short,
      DDATUZV Date,
      DDATPRENUZ Date,
      DDATZRUSUZ Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvdofa',
   'uzvdofa.adi',
   'UZAVER1',
   'NCISUZV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvdofa',
   'uzvdofa.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvdofa', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzvdofafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvdofa', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzvdofafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvdofa', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzvdofafail');

CREATE TABLE uzverrsi ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      CDENIK Char( 2 ),
      CDENIK_CFG Char( 10 ),
      NDOKLAD Integer,
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 25 ),
      CTEXTERRS Char( 25 ),
      NCENZAKCEL Double( 2 ),
      NLIKCELDOK Double( 2 ),
      DDATTISK Date,
      DDATUZV Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzverrsi',
   'uzverrsi.adi',
   'UZVERRSI_1',
   'UPPER(COBDOBI)+UPPER(CDENIK)+STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzverrsi',
   'uzverrsi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzverrsi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzverrsifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzverrsi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzverrsifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzverrsi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzverrsifail');

CREATE TABLE uzverrsz ( 
      CULOHA Char( 1 ),
      COBDOBI Char( 5 ),
      CDENIK Char( 2 ),
      CDENIK_CFG Char( 10 ),
      NDOKLAD Integer,
      CVARSYM Char( 15 ),
      CTEXTDOK Char( 25 ),
      CTEXTERRS Char( 25 ),
      NCENZAKCEL Double( 2 ),
      NLIKCELDOK Double( 2 ),
      DDATTISK Date,
      DDATUZV Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzverrsz',
   'uzverrsz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzverrsz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzverrszfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzverrsz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzverrszfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzverrsz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzverrszfail');

CREATE TABLE uzvisoz ( 
      COBDOBI Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      DDATPRENUZ Date,
      DDATZRUSUZ Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvisoz',
   'uzvisoz.adi',
   'UZAVER1',
   'UPPER(COBDOBI) +STRZERO(NCISUZV,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvisoz',
   'uzvisoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisoz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzvisozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisoz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzvisozfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisoz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzvisozfail');

CREATE TABLE uzvisozf ( 
      COBDOBI Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      DDATPRENUZ Date,
      DDATZRUSUZ Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvisozf',
   'uzvisozf.adi',
   'UZAVER1',
   'UPPER(COBDOBI) +STRZERO(NCISUZV,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvisozf',
   'uzvisozf.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozf', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzvisozffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozf', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzvisozffail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozf', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzvisozffail');

CREATE TABLE uzvisozi ( 
      COBDOBI Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      DDATPRENUZ Date,
      DDATZRUSUZ Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvisozi',
   'uzvisozi.adi',
   'UZVHIM_1',
   'UPPER(COBDOBI)+STRZERO(NCISUZV,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvisozi',
   'uzvisozi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozi', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzvisozifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozi', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzvisozifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozi', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzvisozifail');

CREATE TABLE uzvisozz ( 
      COBDOBI Char( 5 ),
      NCISUZV Short,
      DDATUZV Date,
      DDATPRENUZ Date,
      DDATZRUSUZ Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'uzvisozz',
   'uzvisozz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'uzvisozzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'uzvisozzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'uzvisozz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'uzvisozzfail');

CREATE TABLE vazdokum ( 
      CINUNIQID Char( 26 ),
      NITEM Integer,
      COUUNIQID Char( 26 ),
      CRLUNIQID Char( 26 ),
      CIDDOKUM Char( 16 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vazdokum',
   'vazdokum.adi',
   'INUNIQID',
   'UPPER(CINUNIQID) + UPPER(COUUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazdokum',
   'vazdokum.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazdokum',
   'vazdokum.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) + STRZERO(NITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazdokum',
   'vazdokum.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazdokum',
   'vazdokum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazdokum', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vazdokumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazdokum', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vazdokumfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazdokum', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vazdokumfail');

CREATE TABLE vazfirmy ( 
      CINUNIQID Char( 26 ),
      NITEM Integer,
      COUUNIQID Char( 26 ),
      CRLUNIQID Char( 26 ),
      CFUNPRA Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vazfirmy',
   'vazfirmy.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazfirmy',
   'vazfirmy.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazfirmy',
   'vazfirmy.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazfirmy',
   'vazfirmy.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazfirmy',
   'vazfirmy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazfirmy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vazfirmyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazfirmy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vazfirmyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazfirmy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vazfirmyfail');

CREATE TABLE vazoprav ( 
      CINUNIQID Char( 26 ),
      NITEM Integer,
      COUUNIQID Char( 26 ),
      CRLUNIQID Char( 26 ),
      COPRAVNENI Char( 10 ),
      NSYSFLT Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vazoprav',
   'vazoprav.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazoprav',
   'vazoprav.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazoprav',
   'vazoprav.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazoprav',
   'vazoprav.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazoprav',
   'vazoprav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazoprav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vazopravfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazoprav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vazopravfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazoprav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vazopravfail');

CREATE TABLE vazosoby ( 
      CINUNIQID Char( 26 ),
      NITEM Integer,
      COUUNIQID Char( 26 ),
      CRLUNIQID Char( 26 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vazosoby',
   'vazosoby.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazosoby',
   'vazosoby.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazosoby',
   'vazosoby.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazosoby',
   'vazosoby.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazosoby',
   'vazosoby.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazosoby', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vazosobyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazosoby', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vazosobyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazosoby', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vazosobyfail');

CREATE TABLE vazspoje ( 
      CINUNIQID Char( 26 ),
      NITEM Integer,
      COUUNIQID Char( 26 ),
      CRLUNIQID Char( 26 ),
      LHLAVVAZBA Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vazspoje',
   'vazspoje.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazspoje',
   'vazspoje.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazspoje',
   'vazspoje.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazspoje',
   'vazspoje.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazspoje',
   'vazspoje.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazspoje', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vazspojefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazspoje', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vazspojefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazspoje', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vazspojefail');

CREATE TABLE vazukoly ( 
      CINUNIQID Char( 26 ),
      NITEM Integer,
      COUUNIQID Char( 26 ),
      CRLUNIQID Char( 26 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vazukoly',
   'vazukoly.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazukoly',
   'vazukoly.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazukoly',
   'vazukoly.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazukoly',
   'vazukoly.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vazukoly',
   'vazukoly.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazukoly', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vazukolyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazukoly', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vazukolyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vazukoly', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vazukolyfail');

CREATE TABLE vykdph_i ( 
      CULOHA Char( 1 ),
      NDOKLAD Double( 0 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBIDAN Char( 5 ),
      NTYP_DPH Short,
      NODDIL_DPH Short,
      NRADEK_DPH Short,
      NZAKLD_DPH Double( 2 ),
      NSAZBA_DPH Double( 2 ),
      NKRACE_NAR Double( 2 ),
      CUCETU_DPH Char( 6 ),
      CUCETU_DOK Char( 6 ),
      CZUSTUCT Char( 1 ),
      NDAT_OD Integer,
      CDENIK Char( 2 ),
      CDENIK_PAR Char( 2 ),
      NCISFAK Double( 0 ),
      NZAKLD_ZAL Double( 2 ),
      NSAZBA_ZAL Double( 2 ),
      LIS_ZAL Logical,
      CDENIK_OR Char( 2 ),
      NDOKLAD_OR Double( 0 ),
      NZAKLD_OR Double( 2 ),
      NSAZBA_OR Double( 2 ),
      NGEN_DOKL Short,
      FAKPRIHD Char( 10 ),
      FAKVYSIT Char( 10 ),
      POKLADHD Char( 10 ),
      UCETDOHD Char( 10 ),
      POKLIT Char( 10 ),
      NRECVYK Double( 0 ),
      CTYPUCT Char( 4 ),
      NPORADI Short,
      NPROCDPH Double( 2 ),
      LSLUZBA Logical,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3) +STRZERO(NPORADI,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_2',
   'UPPER(COBDOBIDAN) +UPPER(CDENIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_3',
   'UPPER(COBDOBIDAN) +STRZERO(NGEN_DOKL,1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_5',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_6',
   'UPPER(CDENIK) +STRZERO(NCISFAK,10) +STRZERO(NDOKLAD_OR,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vykdph_i',
   'vykdph_i.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vykdph_i', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vykdph_ifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vykdph_i', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vykdph_ifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vykdph_i', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vykdph_ifail');

CREATE TABLE vykresy ( 
      CSUBJE Char( 2 ),
      NPORVYK Integer,
      CCISVYK Char( 26 ),
      CMODVYK Char( 3 ),
      CNAZVYK Char( 20 ),
      CTYPVYK Char( 2 ),
      CAUTOR Char( 20 ),
      CSTRED Char( 8 ),
      LVYHISO Logical,
      CVYPUJKDO Char( 8 ),
      DVYPUJDAT Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vykresy',
   'vykresy.adi',
   'VYKRES1',
   'UPPER(CCISVYK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vykresy',
   'vykresy.adi',
   'VYKRES2',
   'STRZERO(NPORVYK,8)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vykresy', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vykresyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vykresy', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vykresyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vykresy', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vykresyfail');

CREATE TABLE vypl ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NOSCISPRAC Integer,
      NPORPRAVZT Short,
      CPRACOVNIK Char( 50 ),
      CPRACZAR Char( 8 ),
      NSAZDENNIN Short,
      NSAZDENVKN Short,
      NSAZDENVYN Short,
      CKMESTRPR Short,
      CVYPLMIST Char( 8 ),
      CTMKMSTRPR Char( 8 ),
      NKUMMZDA Integer,
      NDOVMINR Double( 1 ),
      NDOVAKTR Double( 1 ),
      NHODPRNAHR Double( 2 ),
      NDENPRNAHR Integer,
      NSAZBAHOD Double( 2 ),
      NSAZBAMES Integer,
      V0011 Double( 2 ),
      V0012 Double( 2 ),
      V0013 Double( 2 ),
      V0014 Double( 2 ),
      V0021 Double( 2 ),
      V0022 Double( 2 ),
      V0023 Double( 2 ),
      V0024 Double( 2 ),
      V0031 Double( 2 ),
      V0032 Double( 2 ),
      V0033 Double( 2 ),
      V0034 Double( 2 ),
      V0041 Double( 2 ),
      V0042 Double( 2 ),
      V0043 Double( 2 ),
      V0044 Double( 2 ),
      V0051 Double( 2 ),
      V0052 Double( 2 ),
      V0053 Double( 2 ),
      V0054 Double( 2 ),
      V0061 Double( 2 ),
      V0062 Double( 2 ),
      V0063 Double( 2 ),
      V0064 Double( 2 ),
      V0071 Double( 2 ),
      V0072 Double( 2 ),
      V0073 Double( 2 ),
      V0074 Double( 2 ),
      V0081 Double( 2 ),
      V0082 Double( 2 ),
      V0083 Double( 2 ),
      V0084 Double( 2 ),
      V0091 Double( 2 ),
      V0092 Double( 2 ),
      V0093 Double( 2 ),
      V0094 Double( 2 ),
      V0101 Double( 2 ),
      V0102 Double( 2 ),
      V0103 Double( 2 ),
      V0104 Double( 2 ),
      V0111 Double( 2 ),
      V0112 Double( 2 ),
      V0113 Double( 2 ),
      V0114 Double( 2 ),
      V0121 Double( 2 ),
      V0122 Double( 2 ),
      V0123 Double( 2 ),
      V0124 Double( 2 ),
      V0131 Double( 2 ),
      V0132 Double( 2 ),
      V0133 Double( 2 ),
      V0134 Double( 2 ),
      V0141 Double( 2 ),
      V0142 Double( 2 ),
      V0143 Double( 2 ),
      V0144 Double( 2 ),
      V0151 Double( 2 ),
      V0152 Double( 2 ),
      V0153 Double( 2 ),
      V0154 Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'VYPL_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'VYPL_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'VYPL_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CVYPLMIST) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'VYPL_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'VYPL_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'VYPL_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'VYPL_07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CVYPLMIST) +UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vypl',
   'vypl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vypl', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vypl', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyplfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vypl', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyplfail');

CREATE TABLE vyrcis ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CVYROBCIS Char( 20 ),
      NORDITEM Short,
      NMNOZPOC Double( 4 ),
      NMNOZ Double( 4 ),
      NMNOZV Double( 4 ),
      NZUST Double( 4 ),
      NMNOZP Double( 4 ),
      NZARUKA Short,
      CVADY Char( 15 ),
      NDOKLAD Double( 0 ),
      DDATPRIJEM Date,
      NDOKLADV Double( 0 ),
      DDATPRODEJ Date,
      CPOPIS1 Char( 10 ),
      CPOPIS2 Char( 10 ),
      CPOPIS3 Char( 10 ),
      CPOPIS4 Char( 10 ),
      CPOPIS5 Char( 10 ),
      NVALUE1 Double( 0 ),
      NVALUE2 Double( 0 ),
      NVALUE3 Double( 4 ),
      NVALUE4 Double( 4 ),
      MORDITEM Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CVYROBCIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC2',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLAD,10) +UPPER(CVYROBCIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLADV,10) +UPPER(CVYROBCIS)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC4',
   'NDOKLADV',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC5',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC6',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLADV,10) +STRZERO(NORDITEM,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC7',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC8',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NORDITEM,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrcis',
   'vyrcis.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrcis', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyrcisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrcis', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyrcisfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrcis', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyrcisfail');

CREATE TABLE vyrpol ( 
      CSUBJE Char( 2 ),
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      CVARPOP Char( 20 ),
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CNAZPOL2 Char( 8 ),
      CTYPPOL Char( 3 ),
      CSKUPOL Char( 12 ),
      CNAZEV Char( 30 ),
      CZKRATJEDN Char( 3 ),
      CSTRVYR Char( 8 ),
      CSTRODV Char( 8 ),
      CCISVYK Char( 26 ),
      NEKDAV Double( 2 ),
      NCISHM Double( 3 ),
      CSTAV Char( 1 ),
      CSTAVRV Char( 1 ),
      NKUSYPAS Short,
      NSTRIZPL Short,
      NMNZADVA Double( 4 ),
      NMNZADVK Double( 4 ),
      CVYSPOL Char( 15 ),
      CNIZPOL Char( 15 ),
      MPOPISVP Memo,
      CZMENAK Char( 8 ),
      DZMENAK Date,
      CZMENAT Char( 8 ),
      DZMENAT Date,
      CZAPIS Char( 8 ),
      DZAPIS Date,
      NSTAVKALK Short,
      LEXISTKUS Logical,
      LEXISTOPE Logical,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL3',
   'UPPER(CCISVYK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL4',
   'UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL5',
   'UPPER(CCISZAKAZ) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL6',
   'UPPER(CSKLPOL) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL7',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL8',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL9',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpol',
   'vyrpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrpol', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyrpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrpol', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyrpolfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrpol', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyrpolfail');

CREATE TABLE vyrpoldt ( 
      CSUBJE Char( 2 ),
      CCISZAKAZ Char( 30 ),
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      NINDZM Short,
      NTVACI Integer,
      CVYKODB Char( 17 ),
      CCISKUS Char( 17 ),
      CCISTEP Char( 17 ),
      CTYPSKP Char( 15 ),
      CJAKOST Char( 10 ),
      NPRUDO Short,
      CTYPVYR Char( 5 ),
      NROZMA Double( 3 ),
      NROZMB Double( 3 ),
      NROZMC Double( 3 ),
      CPROVE Char( 4 ),
      CTOLER Char( 6 ),
      NPROCNESH Double( 2 ),
      CINZMEN Char( 2 ),
      DPLADOD Date,
      DPLADDO Date,
      CSTREDPRVO Char( 8 ),
      NPRUMDAV Short,
      NCELPOCOP Short,
      CPRIZNAK Char( 1 ),
      NROZPRAC Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpoldt',
   'vyrpoldt.adi',
   'VYRDT1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrpoldt',
   'vyrpoldt.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrpoldt', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyrpoldtfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrpoldt', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyrpoldtfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrpoldt', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyrpoldtfail');

CREATE TABLE vyrzak ( 
      CSUBJEKT Char( 2 ),
      CCISZAKAZ Char( 30 ),
      CNAZEVZAK1 Char( 70 ),
      CVYROBCISL Char( 40 ),
      CCISLOOBJ Char( 50 ),
      CTYPZAK Char( 2 ),
      NPOLZAK Short,
      LPOLZAK Logical,
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      DZPRADOKPL Date,
      DZPRADOKSK Date,
      DODVEDZAKA Date,
      DZACATPRAC Date,
      DDODDILMON Date,
      DMOZODVZAK Date,
      DSKUODVZAK Date,
      DPREDVYKR Date,
      DOBDOKKONP Date,
      DOBDOKKONS Date,
      DUZAVZAKA Date,
      NMNOZPLANO Double( 2 ),
      NMNOZZADAN Double( 2 ),
      NMNOZVYROB Double( 2 ),
      NMNOZODVED Double( 2 ),
      NMNOZDODDL Double( 2 ),
      NMNOZFAKT Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NPLANPRUZA Double( 2 ),
      CPRIORZAKA Char( 2 ),
      CSTAVZAKAZ Char( 2 ),
      CSTAVKAPZA Char( 2 ),
      CSTAVMATZA Char( 2 ),
      NPOCCEZAPZ Short,
      NPOCNEZAPZ Short,
      NPOCCEODMA Short,
      NPOCNEODMA Short,
      NCISFIRMY Integer,
      CNAZFIRMY Char( 50 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      NICO Integer,
      CDIC Char( 16 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CSKP Char( 15 ),
      NKLICDPH Short,
      CZKRTYPUHR Char( 5 ),
      CTYPCENY Char( 1 ),
      NCENAMJ Double( 2 ),
      NCENACELK Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NZALOHA Double( 2 ),
      CZKRATMENY Char( 3 ),
      CVYBAVA Char( 70 ),
      CKONSTRUKT Char( 30 ),
      CSTRED Char( 8 ),
      NCISOSZAL Integer,
      CJMEOSZAL Char( 25 ),
      NCISOSODP Integer,
      CJMEOSODP Char( 25 ),
      CCISPLAN Char( 15 ),
      MPOPISZAK Memo,
      MPOPISZAK2 Memo,
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NSTAVFAKT Short,
      CINTID Char( 1 ),
      NCISLOKUSU Integer,
      CUCETTRZEB Char( 6 ),
      CUCETVNITR Char( 6 ),
      NCISFAK Double( 0 ),
      NROK Short,
      NOBDOBI Short,
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZKRZPUDOP Char( 15 ),
      CMISTOOBJ Char( 50 ),
      NPRIRAZKA Double( 2 ),
      CSTRED_ODB Char( 8 ),
      CSTROJ_ODB Char( 8 ),
      CZKRATMENZ Char( 3 ),
      CDANPZBO Char( 15 ),
      NHMOTNOST Double( 2 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 2 ),
      CZKRATJEDO Char( 3 ),
      NROZM_VYS Double( 2 ),
      NROZM_SIR Double( 2 ),
      NROZM_DEL Double( 2 ),
      CROZM_MJ Char( 3 ),
      CBARVA Char( 15 ),
      CBARVA_2 Char( 15 ),
      NCISDODAVK Double( 0 ),
      CTYPDODAVK Char( 10 ),
      CTYPDODPOD Char( 10 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      DDATVYKLAD Date,
      CCASVYKLAD Char( 8 ),
      NCENAPREPR Double( 2 ),
      NCENAPROD Double( 2 ),
      CKATOZNODB Char( 15 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NCENCELTUZ Double( 2 ),
      NROKODV Short,
      NMESICODV Short,
      NTYDENODV Short,
      LEXISTITM Logical,
      LEXISTKUS Logical,
      LEXISTOPE Logical,
      CSTAVZAKUZ Char( 2 ),
      DZNOVUOTVZ Date,
      NMNOZ_FAKT Double( 4 ),
      NMNOZ_DLVY Double( 4 ),
      NMNOZ_OBJP Double( 4 ),
      NMNOZ_EXPL Double( 4 ),
      NMNOZ_ZAK Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK2',
   'UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +DTOS (DODVEDZAKA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK3',
   'UPPER(CNAZEVZAK1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK4',
   'STRZERO(NCISFIRMY,5) +STRZERO(NSTAVFAKT,1) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK5',
   'UPPER(CSTAVZAKAZ) +UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK6',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK7',
   'UPPER(CNAZPOL3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK8',
   'UPPER(CCISLOOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK9',
   'UPPER(CNAZFIRMY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrzak', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyrzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrzak', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyrzakfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrzak', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyrzakfail');

CREATE TABLE vyrzakit ( 
      CSUBJEKT Char( 2 ),
      CCISZAKAZ Char( 30 ),
      CNAZEVZAK1 Char( 70 ),
      CVYROBCISL Char( 40 ),
      CCISLOOBJ Char( 50 ),
      CTYPZAK Char( 2 ),
      NPOLZAK Short,
      LPOLZAK Logical,
      CVYRPOL Char( 15 ),
      NVARCIS Short,
      DZPRADOKPL Date,
      DZPRADOKSK Date,
      DODVEDZAKA Date,
      DZACATPRAC Date,
      DDODDILMON Date,
      DMOZODVZAK Date,
      DSKUODVZAK Date,
      DPREDVYKR Date,
      DOBDOKKONP Date,
      DOBDOKKONS Date,
      DUZAVZAKA Date,
      NMNOZPLANO Double( 2 ),
      NMNOZZADAN Double( 2 ),
      NMNOZVYROB Double( 2 ),
      NMNOZODVED Double( 2 ),
      NMNOZDODDL Double( 2 ),
      NMNOZFAKT Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NPLANPRUZA Double( 2 ),
      CPRIORZAKA Char( 2 ),
      CSTAVZAKAZ Char( 2 ),
      CSTAVKAPZA Char( 2 ),
      CSTAVMATZA Char( 2 ),
      NPOCCEZAPZ Short,
      NPOCNEZAPZ Short,
      NPOCCEODMA Short,
      NPOCNEODMA Short,
      NCISFIRMY Integer,
      CNAZFIRMY Char( 50 ),
      CULICE Char( 25 ),
      CSIDLO Char( 25 ),
      CPSC Char( 6 ),
      NICO Integer,
      CDIC Char( 16 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CSKP Char( 15 ),
      NKLICDPH Short,
      CZKRTYPUHR Char( 5 ),
      CTYPCENY Char( 1 ),
      NCENAMJ Double( 2 ),
      NCENACELK Double( 2 ),
      NCENZAKCEL Double( 2 ),
      NZALOHA Double( 2 ),
      CZKRATMENY Char( 3 ),
      CVYBAVA Char( 70 ),
      CKONSTRUKT Char( 30 ),
      CSTRED Char( 8 ),
      NCISOSZAL Integer,
      CJMEOSZAL Char( 25 ),
      NCISOSODP Integer,
      CJMEOSODP Char( 25 ),
      CCISPLAN Char( 15 ),
      MPOPISZAK Memo,
      MPOPISZAK2 Memo,
      CZAPIS Char( 8 ),
      DZAPIS Date,
      CZMENA Char( 8 ),
      DZMENA Date,
      NSTAVFAKT Short,
      CINTID Char( 1 ),
      NCISLOKUSU Integer,
      CUCETTRZEB Char( 6 ),
      CUCETVNITR Char( 6 ),
      NCISFAK Double( 0 ),
      NROK Short,
      NOBDOBI Short,
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      CZKRZPUDOP Char( 15 ),
      CMISTOOBJ Char( 50 ),
      NPRIRAZKA Double( 2 ),
      CSTRED_ODB Char( 8 ),
      CSTROJ_ODB Char( 8 ),
      CZKRATMENZ Char( 3 ),
      CDANPZBO Char( 15 ),
      NHMOTNOST Double( 2 ),
      CZKRATJEDH Char( 3 ),
      NOBJEM Double( 2 ),
      CZKRATJEDO Char( 3 ),
      NROZM_VYS Double( 2 ),
      NROZM_SIR Double( 2 ),
      NROZM_DEL Double( 2 ),
      CROZM_MJ Char( 3 ),
      CBARVA Char( 15 ),
      CBARVA_2 Char( 15 ),
      NCISDODAVK Double( 0 ),
      CTYPDODAVK Char( 10 ),
      CTYPDODPOD Char( 10 ),
      NCISFIRDOA Integer,
      CNAZEVDOA Char( 50 ),
      CULICEDOA Char( 25 ),
      CSIDLODOA Char( 25 ),
      CPSCDOA Char( 6 ),
      DDATVYKLAD Date,
      CCASVYKLAD Char( 8 ),
      NCENAPREPR Double( 2 ),
      NCENAPROD Double( 2 ),
      CKATOZNODB Char( 15 ),
      NKURZAHMEN Double( 8 ),
      NMNOZPREP Integer,
      NCENCELTUZ Double( 2 ),
      NROKODV Short,
      NMESICODV Short,
      NTYDENODV Short,
      LEXISTITM Logical,
      LEXISTKUS Logical,
      LEXISTOPE Logical,
      CSTAVZAKUZ Char( 2 ),
      DZNOVUOTVZ Date,
      NMNOZ_FAKT Double( 4 ),
      NMNOZ_DLVY Double( 4 ),
      NMNOZ_OBJP Double( 4 ),
      NMNOZ_EXPL Double( 4 ),
      NMNOZ_ZAK Double( 4 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ),
      CCISZAKAZI Char( 36 ),
      NORDITEM Integer,
      NVAHAPRED Double( 2 ),
      CMJVAHAP Char( 3 ),
      NVAHASKUT Double( 2 ),
      CMJVAHAS Char( 3 ),
      NCISLOEL Double( 0 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_1',
   'UPPER(CCISZAKAZ) + STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_2',
   'UPPER(CVYROBCISL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_3',
   'DTOS(DMOZODVZAK) +STRZERO(NCISLOEL,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_4',
   'UPPER(CCISZAKAZI)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_5',
   'DTOS(DMOZODVZAK) +STRZERO(NCISLOEL,10) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_6',
   'STRZERO(NROKODV,4) +STRZERO(NTYDENODV,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_7',
   'NCISFIRMY',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_8',
   'NSTAVFAKT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrzakit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyrzakitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrzakit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyrzakitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyrzakit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyrzakitfail');

CREATE TABLE vyucdane ( 
      NROK Short,
      CNAZPOL1 Char( 8 ),
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CJMENOPRAC Char( 30 ),
      CRODCISPRA Char( 13 ),
      CBYDLISTE Char( 40 ),
      CPSC Char( 6 ),
      NDZD_ZAMES Integer,
      NDZD_PLATA Integer,
      NDZD_PLATB Integer,
      NDZD_PLATC Integer,
      NDZD_PLATD Integer,
      NDZD_PLATE Integer,
      NDZD_CELK Integer,
      NNEZ_PRAC Integer,
      NNEZ_DETI Integer,
      NNEZ_MANZ Integer,
      NNEZ_CASIN Integer,
      NNEZ_PLNIN Integer,
      NNEZ_ZTP Integer,
      NNEZ_STUD Integer,
      NNEZ_DARY Integer,
      NNEZ_UVER Integer,
      NNEZ_PENPR Integer,
      NNEZ_SOZIP Integer,
      NNEZ_CLPOO Integer,
      NNEZ_CELK Integer,
      NZAKLDANE Integer,
      NVYPOCDAN Integer,
      NUSZ_ZAMES Integer,
      NUSZ_PLATA Integer,
      NUSZ_PLATB Integer,
      NUSZ_PLATC Integer,
      NUSZ_PLATD Integer,
      NUSZ_PLATE Integer,
      NUSZ_CELK Integer,
      CPREPNEDOP Char( 10 ),
      NPREPNEDOP Integer,
      CTMKMSTRPR Char( 8 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vyucdane',
   'vyucdane.adi',
   'VYUCDA01',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyucdane',
   'vyucdane.adi',
   'VYUCDA02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyucdane',
   'vyucdane.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyucdane', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyucdanefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyucdane', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyucdanefail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyucdane', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyucdanefail');

CREATE TABLE vyucdani ( 
      NROK Short,
      NOBDOBI Short,
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 30 ),
      NUZD_ZAMES Integer,
      NPOJ_ZAMES Integer,
      NDZD_ZAMES Integer,
      NNEZ_PRAC Integer,
      NNEZ_DETI Integer,
      NNEZ_CASIN Integer,
      NNEZ_PLNIN Integer,
      NNEZ_ZTP Integer,
      NNEZ_STUD Integer,
      NNEZ_UVER Integer,
      NNEZ_CELK Integer,
      NZDA_MZDA Integer,
      NUSZ_ZAMES Integer,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vyucdani',
   'vyucdani.adi',
   'VYUCDA01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyucdani',
   'vyucdani.adi',
   'VYUCDA02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vyucdani',
   'vyucdani.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyucdani', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vyucdanifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyucdani', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vyucdanifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vyucdani', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vyucdanifail');

CREATE TABLE vzdelani ( 
      CKMENSTRPR Char( 8 ),
      NOSCISPRAC Integer,
      CRODCISPRA Char( 13 ),
      CPRACOVNIK Char( 43 ),
      NPORADI Short,
      CZKRUKOVZD Char( 8 ),
      CZKRVZDEL Char( 8 ),
      COBORVZDEL Char( 50 ),
      NPOCLETSTU Integer,
      DZACSTUDIA Date,
      DKONSTUDIA Char( 8 ),
      CNAZEVSKOL Char( 35 ),
      CZKRATSKOL Char( 10 ),
      CULICE Char( 25 ),
      CMISTO Char( 25 ),
      CPSC Char( 6 ),
      CZKRATSTAT Char( 3 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_02',
   'UPPER(CRODCISPRA) +STRZERO(NPORADI,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_03',
   'UPPER(CRODCISPRA) +UPPER(CZKRVZDEL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vzdelani',
   'vzdelani.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vzdelani', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vzdelanifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vzdelani', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vzdelanifail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vzdelani', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vzdelanifail');

CREATE TABLE vzobjpvp ( 
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CCISOBJ Char( 15 ),
      NINTCOUNT Integer,
      NDOKLAD Integer,
      NORDITEM Integer,
      NMNOZOBJED Double( 4 ),
      NMNOZKOBJE Double( 4 ),
      NMNOZZOBJE Double( 4 ),
      NCENAPRIJM Double( 2 ),
      DDATPVP Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'OBJPVP1',
   'UPPER(CCISOBJ) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5) +UPPER(CCISLOBINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'OBJPVP2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'OBJPVP3',
   'UPPER(CCISOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vzobjpvp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vzobjpvpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vzobjpvp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vzobjpvpfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vzobjpvp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vzobjpvpfail');

CREATE TABLE vztahobj ( 
      NCISFIRMY Integer,
      CCISLOBINT Char( 30 ),
      NCISLPOLOB Integer,
      CCISSKLAD Char( 8 ),
      CSKLPOL Char( 15 ),
      CPOLCEN Char( 1 ),
      CCISOBJ Char( 15 ),
      NINTCOUNT Integer,
      DDATOBJ Date,
      NMNOZOBDOD Double( 2 ),
      NMNOZOBSKL Double( 2 ),
      CCISZAKAZ Char( 30 ),
      CUSRZMENYR Char( 8 ),
      DDATZMENYR Date,
      CCASZMENYR Char( 8 ),
      CUSRVZNIKR Char( 8 ),
      DDATVZNIKR Date,
      CCASVZNIKR Char( 8 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB2',
   'UPPER(CCISLOBINT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB3',
   'UPPER(CCISOBJ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB4',
   'UPPER(CCISOBJ) +UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB5',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB6',
   'UPPER(CCISOBJ) +UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB) +STRZERO(NINTCOUNT)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'vztahobj', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'vztahobjfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vztahobj', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'vztahobjfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'vztahobj', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'vztahobjfail');

CREATE TABLE watch_hd ( 
      CFILE_HD Char( 10 ),
      CUSER Char( 10 ),
      CPROCES Char( 10 ),
      CTHREAD Char( 10 ),
      NDOKL_INS Double( 0 ),
      CDOKL_ID Char( 10 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'watch_hd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'watch_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'watch_hd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'watch_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'watch_hd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'watch_hdfail');

CREATE TABLE watch_it ( 
      CDOKL_ID Char( 10 ),
      NRECS_ID Double( 0 ),
      NVAL Double( 4 ),
      CFILE_IV Char( 10 ),
      NRECS_IV Double( 0 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'watch_it', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'watch_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'watch_it', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'watch_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'watch_it', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'watch_itfail');

CREATE TABLE watchdog ( 
      NUSERS Double( 0 ),
      CTIME Char( 8 ),
      NTHREAD Double( 0 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'watchdog', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'watchdogfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'watchdog', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'watchdogfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'watchdog', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'watchdogfail');

CREATE TABLE wds ( 
      NUSERS Double( 0 ),
      NSECONDS Double( 2 ));
EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'wdsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'wdsfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'wdsfail');

CREATE TABLE wds_hd ( 
      WDS_KEY Char( 40 ),
      CFILE_HD Char( 10 ),
      CUSER Char( 10 ),
      CPROCES Char( 10 ),
      CTHREAD Char( 10 ),
      NDOKL_INS Double( 0 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'wds_hd',
   'wds_hd.adi',
   'WDS_HD_1',
   'UPPER(WDS_KEY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds_hd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'wds_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds_hd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'wds_hdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds_hd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'wds_hdfail');

CREATE TABLE wds_it ( 
      WDS_KEY Char( 40 ),
      CFILE_IV Char( 10 ),
      NRECS_IV Double( 0 ),
      NVAL Double( 4 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'wds_it',
   'wds_it.adi',
   'WDS_IT_1',
   'UPPER(WDS_KEY)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'wds_it',
   'wds_it.adi',
   'WDS_IT_2',
   'UPPER(WDS_KEY) +UPPER(CFILE_IV) +STRZERO(NRECS_IV,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds_it', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'wds_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds_it', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'wds_itfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'wds_it', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'wds_itfail');

CREATE TABLE zakapar ( 
      CCISZAKAZ Char( 30 ),
      NCISATRIBZ Integer,
      CATRIB Char( 20 ),
      CHODNATRC Char( 40 ),
      NHODNATRN Double( 4 ),
      MPOZNAMKA Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zakapar',
   'zakapar.adi',
   'ZAKAPA_1',
   'UPPER(CCISZAKAZ) +STRZERO(NCISATRIBZ,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zakapar',
   'zakapar.adi',
   'ZAKAPA_2',
   'UPPER(CATRIB) + UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakapar', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zakaparfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakapar', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zakaparfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakapar', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zakaparfail');

CREATE TABLE zakapprn ( 
      CCISZAKAZ Char( 30 ),
      NCISATRIB1 Integer,
      CATRIB1 Char( 20 ),
      CHODNATR1 Char( 40 ),
      NCISATRIB2 Integer,
      CATRIB2 Char( 20 ),
      CHODNATR2 Char( 40 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zakapprn',
   'zakapprn.adi',
   'ZAKAPA1',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakapprn', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zakapprnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakapprn', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zakapprnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakapprn', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zakapprnfail');

CREATE TABLE zakoprav ( 
      CCISZAKAZ Char( 30 ),
      CCISREKPRO Char( 30 ),
      DDATPREOPR Date,
      NDRUHOPRAV Short,
      NTYPSTROJE Short,
      CSPZ Char( 10 ),
      NSTAVTACHO Integer,
      NSTAVPHM Double( 2 ),
      LOBSFRIDEX Logical,
      CPREDDOOPR Char( 20 ),
      NOSPROVOPR Integer,
      CPROVEDOPR Char( 35 ),
      NOSPREVZAL Integer,
      CPREVZOPR Char( 35 ),
      MROZSAHOPR Memo,
      MROZSIROPR Memo,
      MPOZNAMKA Memo,
      CCISPROTME Char( 15 ),
      NROKPROTME Short,
      CCISMOTORU Char( 20 ),
      CTYPMOTORU Char( 9 ),
      CCISPODVOZ Char( 20 ),
      NOSCISPRAC Integer,
      LSPLEMINOR Logical,
      NDALMERMES Short,
      DDATDALMER Date,
      LNOVAPRUKA Logical,
      CCISPRUKAZ Char( 24 ),
      CVOZIDLO Char( 30 ),
      NKORSOUABS Double( 2 ),
      NDOVHODKOU Double( 2 ),
      CSTAVSACSO Char( 10 ),
      CSTAVVYFSO Char( 10 ),
      CSTAVPALSO Char( 10 ),
      NPREDSTAPR Integer,
      NPREDSTANA Integer,
      CVOLOTACPR Char( 11 ),
      NVOLOTACNA Integer,
      CPREOTACPR Char( 11 ),
      NPREOTACNA Integer,
      NCISZAZKOU Double( 0 ),
      NNAMHODKOU Double( 2 ),
      NOSPREDEMI Integer,
      CPREDALEMI Char( 35 ),
      CPREVZALZA Char( 20 ),
      MZJISTZAVA Memo,
      DDATZKOPAC Date,
      NCISFAK Integer,
      NCITACEMI Short,
      NCITACNAL Short,
      NCITACOSV Short,
      NROKVYROBY Short,
      CVOZTYP Char( 15 ),
      CVOZDRUH Char( 10 ),
      CVOZKATEG Char( 10 ),
      CTYPEMISYS Char( 8 ),
      NKOURMER1 Double( 2 ),
      NKOURMER2 Double( 2 ),
      NKOURMER3 Double( 2 ),
      NKOURMER4 Double( 2 ),
      CKONTROLZN Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zakoprav',
   'zakoprav.adi',
   'ZAKOPR1',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zakoprav',
   'zakoprav.adi',
   'ZAKOPR2',
   'DTOS ( DDATZKOPAC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zakoprav',
   'zakoprav.adi',
   'ZAKOPR3',
   'NROKPROTME',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakoprav', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zakopravfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakoprav', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zakopravfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zakoprav', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zakopravfail');

CREATE TABLE zamezd ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CKMENSTRPR Char( 8 ),
      CL Char( 1 ),
      NDRUHMZDY Short,
      MESIC Char( 2 ),
      DN Double( 1 ),
      HO Double( 2 ),
      HM Double( 2 ),
      ZD Short,
      CTMKMSTRPR Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_01',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(ZD,3)+UPPER(CL)+STRZERO(NDRUHMZDY,4)+UPPER(CKMENSTRPR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_02',
   'STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_03',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_04',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+UPPER(CKMENSTRPR)+STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zamezd',
   'zamezd.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zamezd',
   'zamezd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zamezd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zamezdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zamezd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zamezdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zamezd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zamezdfail');

CREATE TABLE zamrodpr ( 
      NOSCISPRAC Integer,
      CPRACOVNIK Char( 50 ),
      CRODCISPRA Char( 13 ),
      CPRIJMENRP Char( 20 ),
      CJMENORP Char( 15 ),
      CRODPRISL Char( 50 ),
      NRODPRISL Short,
      CTYPRODPRI Char( 4 ),
      CRODCISRP Char( 13 ),
      CJMENRODRP Char( 25 ),
      MPOZNAMKA1 Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zamrodpr',
   'zamrodpr.adi',
   'ZAROP_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zamrodpr',
   'zamrodpr.adi',
   'ZAROP_02',
   'UPPER(CRODCISRP)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zamrodpr',
   'zamrodpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zamrodpr', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zamrodprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zamrodpr', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zamrodprfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zamrodpr', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zamrodprfail');

CREATE TABLE zmajn ( 
      NCISZMENY Integer,
      NINVCIS Double( 0 ),
      NTYPMAJ Short,
      CPOPISZME Char( 20 ),
      CPOLEZME Char( 10 ),
      CNAZPOLZME Char( 30 ),
      COLDHODN Char( 30 ),
      CNEWHODN Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajn',
   'zmajn.adi',
   'ZMAJN1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NCISZMENY,8)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajn',
   'zmajn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajn', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmajnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajn', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmajnfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajn', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmajnfail');

CREATE TABLE zmajnz ( 
      NCISZMENY Integer,
      NINVCIS Double( 0 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CPOPISZME Char( 20 ),
      CPOLEZME Char( 10 ),
      CNAZPOLZME Char( 30 ),
      COLDHODN Char( 30 ),
      CNEWHODN Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajnz',
   'zmajnz.adi',
   'ZMAJNZ1',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NCISZMENY,8)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajnz',
   'zmajnz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajnz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmajnzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajnz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmajnzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajnz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmajnzfail');

CREATE TABLE zmaju ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NINVCIS Double( 0 ),
      CNAZEV Char( 30 ),
      NTYPMAJ Short,
      CUCETSKUP Char( 10 ),
      NDRPOHYB Integer,
      NKARTA Short,
      NTYPPOHYB Short,
      DDATZMENY Date,
      COBDOBI Char( 5 ),
      NROK Short,
      NOBDOBI Short,
      NPORZMENY Integer,
      NCISLODL Double( 0 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      NKUSY Short,
      NMNOZSTVI Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCENAVSTU Double( 2 ),
      NOPRUCT Double( 2 ),
      NZUSTCENAU Double( 2 ),
      NUCTODPMES Double( 2 ),
      NZMENVSTCU Double( 2 ),
      NZMENOPRU Double( 2 ),
      NZMENVSTCD Double( 2 ),
      NZMENOPRD Double( 2 ),
      CUSERABB Char( 8 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NCENAVSTUO Double( 2 ),
      NCENAVSTDO Double( 2 ),
      NOPRUCTO Double( 2 ),
      NOPRDANO Double( 2 ),
      NPROCDANOO Double( 2 ),
      NDANODPRO Double( 2 ),
      NPROCUCTOO Double( 2 ),
      NUCTODPRO Double( 2 ),
      NUCTODPMO Double( 2 ),
      NZNAKTO Short,
      COBDZVYSO Char( 5 ),
      NLIKCELDOK Double( 2 ),
      NCENAVSTUN Double( 2 ),
      NCENAVSTDN Double( 2 ),
      NOPRUCTN Double( 2 ),
      NOPRDANN Double( 2 ),
      NPROCDANON Double( 2 ),
      NDANODPRN Double( 2 ),
      NPROCUCTON Double( 2 ),
      NUCTODPRN Double( 2 ),
      NUCTODPMN Double( 2 ),
      NZNAKTN Short,
      COBDZVYSN Char( 5 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU2',
   'UPPER(COBDOBI)+STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU3',
   'STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU4',
   'UPPER(CDENIK)+ STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU5',
   'NKARTA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU6',
   'STRZERO(NROK,4) + STRZERO(NOBDOBI,2) + STRZERO(NDRPOHYB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU7',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU8',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+ STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmaju',
   'zmaju.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmaju', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmajufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmaju', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmajufail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmaju', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmajufail');

CREATE TABLE zmajuz ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CDENIK Char( 2 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      NINVCIS Double( 0 ),
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
      NCISLODL Double( 0 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      NKUSY Short,
      NMNOZSTVI Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCENAVSTU Double( 2 ),
      NOPRUCT Double( 2 ),
      NZUSTCENAU Double( 2 ),
      NUCTODPMES Double( 2 ),
      NZMENVSTCU Double( 2 ),
      NZMENOPRU Double( 2 ),
      NZMENVSTCD Double( 2 ),
      NZMENOPRD Double( 2 ),
      CUSERABB Char( 8 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL3 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      CNAZPOL5 Char( 8 ),
      CNAZPOL6 Char( 8 ),
      NCENAVSTUO Double( 2 ),
      NCENAVSTDO Double( 2 ),
      NOPRUCTO Double( 2 ),
      NOPRDANO Double( 2 ),
      NPROCDANOO Double( 2 ),
      NDANODPRO Double( 2 ),
      NPROCUCTOO Double( 2 ),
      NUCTODPRO Double( 2 ),
      NUCTODPMO Double( 2 ),
      NZNAKTO Short,
      COBDZVYSO Char( 5 ),
      NLIKCELDOK Double( 2 ),
      CNAZPOL1_N Char( 8 ),
      CNAZPOL4_N Char( 8 ),
      NZVIRKAT_N Integer,
      NDOKL183 Integer,
      NCENAVSTUN Double( 2 ),
      NCENAVSTDN Double( 2 ),
      NOPRUCTN Double( 2 ),
      NOPRDANN Double( 2 ),
      NPROCDANON Double( 2 ),
      NDANODPRN Double( 2 ),
      NPROCUCTON Double( 2 ),
      NUCTODPRN Double( 2 ),
      NUCTODPMN Double( 2 ),
      NZNAKTN Short,
      COBDZVYSN Char( 5 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ1',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ2',
   'UPPER(COBDOBI)+STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ3',
   'STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ4',
   'UPPER(CDENIK)+ STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ5',
   'NKARTA',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ6',
   'STRZERO(NROK,4) + STRZERO(NOBDOBI,2) + STRZERO(NDRPOHYB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ7',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NDRPOHYB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ8',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ9',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+ STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmajuz',
   'zmajuz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajuz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmajuzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajuz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmajuzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmajuz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmajuzfail');

CREATE TABLE zmeelnar ( 
      NINVCISDIM Integer,
      NCISKONTR Integer,
      CSESTAVA Char( 2 ),
      NDELKAVM Double( 2 ),
      CSITPRIVOD Char( 4 ),
      NODPORVOD Double( 2 ),
      NZAKLIZOL Double( 2 ),
      NPRIDIZOL Double( 2 ),
      NZESIIZOL Double( 2 ),
      DDATPOSKON Date,
      DDATDALKON Date,
      COPRAVIL Char( 8 ),
      CMETODAMER Char( 2 ),
      NPROUDMA Short,
      CPOPISKON1 Char( 60 ),
      CPOPISKON2 Char( 60 ),
      CPOPISKON3 Char( 60 ),
      CCELKHODNO Char( 2 ),
      MDALSIPOP Memo,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmeelnar',
   'zmeelnar.adi',
   'C_ZMDIM1',
   'STRZERO(NINVCISDIM,6) +DTOS (DDATPOSKON)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmeelnar',
   'zmeelnar.adi',
   'C_ZMDIM2',
   'STRZERO(NINVCISDIM,6) +STRZERO(NCISKONTR)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmeelnar',
   'zmeelnar.adi',
   'C_ZMDIM3',
   'NCISKONTR',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmeelnar',
   'zmeelnar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmeelnar', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmeelnarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmeelnar', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmeelnarfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmeelnar', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmeelnarfail');

CREATE TABLE zmenydim ( 
      NINVCISDIM Integer,
      CKLICSKMIS Char( 8 ),
      CKLICODMIS Char( 8 ),
      CPOPZMDIM Char( 10 ),
      CFLDPOLDIM Char( 10 ),
      CBROPOLDIM Char( 30 ),
      COLDVAL Char( 30 ),
      CNEWVAL Char( 30 ),
      DDATZMDIM Date,
      CCASZMDIM Char( 8 ),
      CUSERABB Char( 8 ),
      NCISZMDIM Double( 0 ),
      NPOH_DIM Short,
      LPOH_DIM Logical,
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NPOCKUSDIM Double( 2 ),
      CZKRATJEDN Char( 3 ),
      NCENJEDDIM Double( 2 ),
      NCENCELDIM Double( 2 ),
      NPOH_SIGN Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM1',
   'STRZERO(NINVCISDIM,6) +DTOS (DDATZMDIM) +UPPER(CCASZMDIM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM2',
   'STRZERO(NINVCISDIM,6) +STRZERO(NCISZMDIM,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM3',
   'STRZERO(NINVCISDIM,6) +STRZERO(NPOH_DIM,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM4',
   'STRZERO(NINVCISDIM,6) +UPPER(CKLICSKMIS) +UPPER(CKLICODMIS) +IF (LPOH_DIM, ''1'', ''0'') +STRZERO(NCISZMDIM,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM5',
   'NCISZMDIM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM6',
   'LPOH_DIM',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydim',
   'zmenydim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenydim', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmenydimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenydim', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmenydimfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenydim', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmenydimfail');

CREATE TABLE zmenydmz ( 
      NDRUHMZDY Short,
      CPOPISZMEN Char( 20 ),
      CFIELDPOLE Char( 10 ),
      CBROWSEPOL Char( 30 ),
      COLDVALUE Char( 30 ),
      CNEWVALUE Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      NCISZMENY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenydmz',
   'zmenydmz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenydmz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmenydmzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenydmz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmenydmzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenydmz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmenydmzfail');

CREATE TABLE zmenymsp ( 
      NOSCISPRAC Integer,
      CPOPISZMEN Char( 20 ),
      CFIELDPOLE Char( 10 ),
      CBROWSEPOL Char( 30 ),
      COLDVALUE Char( 30 ),
      CNEWVALUE Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      NCISZMENY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenymsp',
   'zmenymsp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenymsp', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmenymspfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenymsp', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmenymspfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenymsp', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmenymspfail');

CREATE TABLE zmenyper ( 
      NOSCISPRAC Integer,
      CPOPISZMEN Char( 20 ),
      CFIELDPOLE Char( 10 ),
      CBROWSEPOL Char( 30 ),
      COLDVALUE Char( 30 ),
      CNEWVALUE Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      NCISZMENY Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenyper',
   'zmenyper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenyper', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmenyperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenyper', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmenyperfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenyper', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmenyperfail');

CREATE TABLE zmenysrz ( 
      NOSCISPRAC Integer,
      CPOPISZMEN Char( 20 ),
      CFIELDPOLE Char( 10 ),
      CBROWSEPOL Char( 30 ),
      COLDVALUE Char( 30 ),
      CNEWVALUE Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      NCISZMENY Short,
      NPORADISRZ Short,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MPOZNAMKA Memo,
      CUNIQIDREC Char( 26 ),
      MUSERZMENR Memo);
EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenysrz',
   'zmenysrz.adi',
   'OSCISPOR',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORADISRZ,3)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zmenysrz',
   'zmenysrz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenysrz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zmenysrzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenysrz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zmenysrzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zmenysrz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zmenysrzfail');

CREATE TABLE zvirata ( 
      CTYPEVID Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NINVCIS Double( 0 ),
      NINVCISMAT Double( 0 ),
      CNAZEV Char( 30 ),
      DNAROZZVIR Date,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CDANPZBO Char( 15 ),
      CTYPSKP Char( 15 ),
      DDATPORKAR Date,
      NCENAZV Double( 2 ),
      NKUSY Short,
      DDATPZV Date,
      NROK Short,
      NOBDOBI Short,
      CNAZPOL2 Char( 8 ),
      NPOHLAVI Short,
      CPOHLAVI Char( 1 ),
      CPLEMENO Char( 2 ),
      NFARMA Double( 0 ),
      CFARMA Char( 10 ),
      CFARMAKRJ Char( 2 ),
      CFARMAPOD Char( 6 ),
      CFARMASTJ Char( 2 ),
      CFARMAODK Char( 10 ),
      CFARODKKRJ Char( 2 ),
      CFARODKPOD Char( 6 ),
      CFARODKSTJ Char( 2 ),
      CZVIREZEM Char( 2 ),
      CFARMAKAM Char( 10 ),
      CFARKAMKRJ Char( 2 ),
      CFARKAMPOD Char( 6 ),
      CFARKAMSTJ Char( 2 ),
      CMATKAZEM Char( 2 ),
      NPORCISLIS Double( 0 ),
      NPORCISRAD Short,
      CTEXT1 Char( 30 ),
      CTEXT2 Char( 30 ),
      MPOPIS Memo,
      DDATKDYODK Date,
      DDATKDYKAM Date,
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS, 10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA02',
   'STRZERO(NZVIRKAT, 6) +STRZERO(NINVCIS, 10) +DTOS (DDATKDYKAM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA03',
   'NINVCIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA04',
   'UPPER(CFARMA) + STRZERO(NPORCISLIS,10) +STRZERO( NPORCISRAD, 2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA05',
   'STRZERO( NINVCIS, 10) + DTOS(DDATKDYKAM)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA06',
   'STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)+ UPPER(CFARMA) + DTOS( DDATPZV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA07',
   'UPPER(CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)+ STRZERO(NPORCISLIS,10) +STRZERO( NPORCISRAD, 2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA08',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NINVCIS, 10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA09',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS, 10) + STRZERO(NKUSY, 1)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirata',
   'zvirata.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvirata', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zviratafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvirata', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zviratafail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvirata', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zviratafail');

CREATE TABLE zvirataz ( 
      NCISZMENY Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NINVCIS Double( 0 ),
      CPOPISZME Char( 20 ),
      CPOLEZME Char( 10 ),
      CNAZPOLZME Char( 30 ),
      COLDHODN Char( 30 ),
      CNEWHODN Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvirataz',
   'zvirataz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvirataz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zviratazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvirataz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zviratazfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvirataz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zviratazfail');

CREATE TABLE zvkarobd ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      DDATPZV Date,
      NKUSYPOC Double( 0 ),
      NMNOZPOC Double( 2 ),
      NCENAPOC Double( 2 ),
      NKDPOC Double( 0 ),
      NKUSYKON Double( 0 ),
      NMNOZKON Double( 2 ),
      NCENAKON Double( 2 ),
      NKDKON Double( 0 ),
      NKUSYPRIJ Double( 0 ),
      NMNOZPRIJ Double( 2 ),
      NCENAPRIJ Double( 2 ),
      NKDPRIJ Double( 0 ),
      NKUSYVYDEJ Double( 0 ),
      NMNOZVYDEJ Double( 2 ),
      NCENAVYDEJ Double( 2 ),
      NKDVYDEJ Double( 0 ),
      NKUSYROZ Double( 0 ),
      NMNOZROZ Double( 2 ),
      NCENAROZ Double( 2 ),
      NKDROZ Double( 0 ),
      NPRUMCENA Double( 4 ),
      NKUSYPR Double( 0 ),
      NMNOZPR Double( 2 ),
      NCENAPR Double( 2 ),
      NKUSYPROR Double( 0 ),
      NMNOZPROR Double( 2 ),
      NCENAPROR Double( 2 ),
      CTYPZVR Char( 1 ),
      CFARMA Char( 10 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD02',
   'UPPER(COBDOBI) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD03',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD04',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2) + UPPER(CTYPZVR) + UPPER(CFARMA)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarobd',
   'zvkarobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarobd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvkarobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarobd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvkarobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarobd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvkarobdfail');

CREATE TABLE zvkarty ( 
      CTYPEVID Char( 1 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      CNAZPOL2 Char( 8 ),
      CNAZEV Char( 30 ),
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      CDANPZBO Char( 15 ),
      CTYPSKP Char( 15 ),
      DDATPORKAR Date,
      CZKRATJEDN Char( 3 ),
      NKLICDPH Short,
      CTYPVYPCEN Char( 3 ),
      CZKRATMENY Char( 3 ),
      NCENANZV Double( 2 ),
      NCENCNZV Double( 2 ),
      NCENAV1ZV Double( 2 ),
      NCENAV2ZV Double( 2 ),
      NCENASZV Double( 4 ),
      NCENACZV Double( 2 ),
      NCENAPZV Double( 2 ),
      NCENAMZV Double( 2 ),
      NMNOZSZV Double( 4 ),
      NKUSYZV Double( 0 ),
      NKD Double( 0 ),
      NCENAPOCZV Double( 2 ),
      NMNOZPOCZV Double( 4 ),
      NKUSYPOCZV Double( 0 ),
      NKDPOCZV Double( 0 ),
      DDATPZV Date,
      NZVIRKATPR Integer,
      CNAZPOL2PR Char( 8 ),
      CPLEMENO Char( 1 ),
      MPOPIS Memo,
      CTYPZVR Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty',
   'zvkarty.adi',
   'ZVKARTY_01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty',
   'zvkarty.adi',
   'ZVKARTY_02',
   'UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty',
   'zvkarty.adi',
   'ZVKARTY_03',
   'NZVIRKAT',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty',
   'zvkarty.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarty', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvkartyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarty', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvkartyfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarty', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvkartyfail');

CREATE TABLE zvkarty_ps ( 
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NROK Short,
      NCENAPOCZV Double( 2 ),
      NMNOZPOCZV Double( 4 ),
      NKUSYPOCZV Double( 0 ),
      NKDPOCZV Double( 0 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'ZVKARPS_01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NROK,4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'ZVKARPS_02',
   'STRZERO(NROK,4) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'ZVKARPS_03',
   'STRZERO(NROK,4) + STRZERO(NZVIRKAT,6) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarty_ps', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvkarty_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarty_ps', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvkarty_psfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkarty_ps', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvkarty_psfail');

CREATE TABLE zvkartyz ( 
      NCISZMENY Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NINVCIS Double( 0 ),
      CPOPISZME Char( 20 ),
      CPOLEZME Char( 10 ),
      CNAZPOLZME Char( 30 ),
      COLDHODN Char( 30 ),
      CNEWHODN Char( 30 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CUSERABB Char( 8 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkartyz',
   'zvkartyz.adi',
   'ZVKARTYZ01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkartyz',
   'zvkartyz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkartyz', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvkartyzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkartyz', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvkartyzfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkartyz', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvkartyzfail');

CREATE TABLE zvkatobd ( 
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NKUSYPOC Double( 0 ),
      NMNOZPOC Double( 2 ),
      NCENAPOC Double( 2 ),
      NKDPOC Double( 0 ),
      NKUSYKON Double( 0 ),
      NMNOZKON Double( 2 ),
      NCENAKON Double( 2 ),
      NKDKON Double( 0 ),
      NKUSYPRIJ Double( 0 ),
      NMNOZPRIJ Double( 2 ),
      NCENAPRIJ Double( 2 ),
      NKDPRIJ Double( 0 ),
      NKUSYVYDEJ Double( 0 ),
      NMNOZVYDEJ Double( 2 ),
      NCENAVYDEJ Double( 2 ),
      NKDVYDEJ Double( 0 ),
      NKUSYROZ Double( 0 ),
      NMNOZROZ Double( 2 ),
      NCENAROZ Double( 2 ),
      NKDROZ Double( 0 ),
      NPRUMCENA Double( 4 ),
      NKUSYPR Double( 0 ),
      NMNOZPR Double( 2 ),
      NCENAPR Double( 2 ),
      NKUSYPROR Double( 0 ),
      NMNOZPROR Double( 2 ),
      NCENAPROR Double( 2 ),
      NCENACELK Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkatobd',
   'zvkatobd.adi',
   'ZVKATOBD01',
   'STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkatobd',
   'zvkatobd.adi',
   'ZVKATOBD02',
   'UPPER(COBDOBI) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkatobd',
   'zvkatobd.adi',
   'ZVKATOBD03',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvkatobd',
   'zvkatobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkatobd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvkatobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkatobd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvkatobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvkatobd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvkatobdfail');

CREATE TABLE zvzmenhd ( 
      CULOHA Char( 1 ),
      CTYPDOKLAD Char( 10 ),
      CTYPPOHYBU Char( 10 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NDOKLADUSR Double( 0 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NDRPOHYB Integer,
      NKARTA Short,
      NTYPPOHYB Short,
      NDRPOHPRIR Integer,
      CZKRATJEDN Char( 3 ),
      NKLICDPH Short,
      CTYPVYPCEN Char( 3 ),
      NTYPVYPCEL Short,
      CZKRATMENY Char( 3 ),
      DDATPORIZ Date,
      DDATZMZV Date,
      NCISLODL Double( 0 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      NCENASZV Double( 4 ),
      NKUSYZV Double( 0 ),
      NMNOZSZV Double( 4 ),
      NKD Double( 0 ),
      NKDHLP Double( 0 ),
      NCENACZV Double( 2 ),
      NCENAPZV Double( 2 ),
      NCENAMZV Double( 2 ),
      NCENAPCEZV Double( 2 ),
      NCENAMCEZV Double( 2 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL1_N Char( 8 ),
      CNAZPOL4_N Char( 8 ),
      NZVIRKAT_N Integer,
      NUCETSKUPN Short,
      CUCETSKUPN Char( 10 ),
      CNAZPOL2_N Char( 8 ),
      NCISFIRMY Integer,
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      NPORZMENY Integer,
      NLIKCELDOK Double( 2 ),
      LPRODUKCE Logical,
      NDRPOHYBP Integer,
      LZMENAZAKL Logical,
      CTYPZVR Char( 1 ),
      CFARMA Char( 10 ),
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NORDITEM,5) + STRZERO(NPORZMENY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD02',
   'UPPER(COBDOBI) +UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD03',
   'STRZERO(NDOKLAD,10) + STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD04',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NPORZMENY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD05',
   'NDOKLADUSR',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD06',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD07',
   'STRZERO(NROK,4)+ UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NDRPOHYB,5) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD08',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2)+ STRZERO(NDOKLAD,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD09',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)+ IF(LZMENAZAKL, ''1'', ''0'') + STRZERO(NORDITEM,5) + STRZERO(NPORZMENY,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD10',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2)+ UPPER(CTYPZVR) + UPPER(CFARMA) + DTOS(DDATZMZV)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD11',
   'NDOKLAD',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD12',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)+ DTOS(DDATPORIZ)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD13',
   'STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD14',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)+ STRZERO(NDOKLAD,10)',
   '',
   10,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmenhd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvzmenhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmenhd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvzmenhdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmenhd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvzmenhdfail');

CREATE TABLE zvzmenit ( 
      CULOHA Char( 1 ),
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      NDOKLAD Double( 0 ),
      NORDITEM Integer,
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NINVCIS Double( 0 ),
      NINVCISMAT Double( 0 ),
      NPOHLAVI Short,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NDRPOHYB Integer,
      NKARTA Short,
      NTYPPOHYB Short,
      DDATPORIZ Date,
      DDATZMZV Date,
      NCISLODL Double( 0 ),
      NCISFAK Double( 0 ),
      CVARSYM Char( 15 ),
      NCENASZV Double( 4 ),
      NKUSYZV Double( 0 ),
      NMNOZSZV Double( 2 ),
      NCENACZV Double( 2 ),
      NCENAPZV Double( 2 ),
      NCENAMZV Double( 2 ),
      NCENAPCEZV Double( 2 ),
      NCENAMCEZV Double( 2 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL1_N Char( 8 ),
      CNAZPOL4_N Char( 8 ),
      NZVIRKAT_N Integer,
      NUCETSKUPN Short,
      CUCETSKUPN Char( 10 ),
      CNAZPOL2_N Char( 8 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      NDRPOHYBP Integer,
      NCISREG Double( 0 ),
      NFARMAODK Double( 0 ),
      NFARMAKAM Double( 0 ),
      DNAROZZVIR Date,
      CZVIREZEM Char( 2 ),
      CMATKAZEM Char( 2 ),
      CPLEMENO Char( 2 ),
      NFARMA Double( 0 ),
      NPORCISLIS Double( 0 ),
      NPORCISRAD Short,
      DDATEXPPL Date,
      NKLIKVID Double( 2 ),
      NZLIKVID Double( 2 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS,10)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT02',
   'STRZERO(NDOKLAD,10) + STRZERO(NORDITEM,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT03',
   'NINVCIS',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT04',
   'STRZERO(NFARMA,10) +   STRZERO(NPORCISLIS,10) + STRZERO(NPORCISRAD,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmenit',
   'zvzmenit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmenit', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvzmenitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmenit', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvzmenitfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmenit', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvzmenitfail');

CREATE TABLE zvzmobd ( 
      CDENIK Char( 2 ),
      NROK Short,
      NOBDOBI Short,
      COBDOBI Char( 5 ),
      CNAZPOL1 Char( 8 ),
      CNAZPOL4 Char( 8 ),
      NZVIRKAT Integer,
      NUCETSKUP Short,
      CUCETSKUP Char( 10 ),
      NDRPOHYB Integer,
      NKARTA Short,
      NTYPPOHYB Short,
      NKUSYZV Double( 0 ),
      NMNOZSZV Double( 2 ),
      NKD Double( 0 ),
      NCENACZV Double( 2 ),
      NCENAPCEZV Double( 2 ),
      NCENAMCEZV Double( 2 ),
      NKUSYZVOR Double( 0 ),
      NMNOZSZVOR Double( 2 ),
      NKDOR Double( 0 ),
      NCENACZVOR Double( 2 ),
      NCENAPCEOR Double( 2 ),
      NCENAMCEOR Double( 2 ),
      CNAZPOL2 Char( 8 ),
      CNAZPOL1_N Char( 8 ),
      CNAZPOL4_N Char( 8 ),
      NZVIRKAT_N Integer,
      NUCETSKUPN Short,
      CUCETSKUPN Char( 10 ),
      CNAZPOL2_N Char( 8 ),
      CUSERABB Char( 8 ),
      DDATZMENY Date,
      CCASZMENY Char( 8 ),
      CULOHA Char( 1 ),
      DVZNIKZAZN Date,
      DZMENAZAZN Date,
      MUSERZMENR Memo,
      CUNIQIDREC Char( 26 ));
EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmobd',
   'zvzmobd.adi',
   'ZVZMOBD_01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT, 6) + STRZERO(NDRPOHYB,5) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmobd',
   'zvzmobd.adi',
   'ZVZMOBD_02',
   'STRZERO(NROK,4) + STRZERO(NOBDOBI,2) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT, 6) + STRZERO(NDRPOHYB,5)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmobd',
   'zvzmobd.adi',
   'ZVZMOBD_03',
   'STRZERO(NROK,4) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT, 6) + STRZERO(NDRPOHYB,5) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_CreateIndex( 
   'zvzmobd',
   'zvzmobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512 );


EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmobd', 
   'Table_Auto_Create', 
   'False', 'APPEND_FAIL', 'zvzmobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmobd', 
   'Table_Permission_Level', 
   '2', 'APPEND_FAIL', 'zvzmobdfail');

EXECUTE PROCEDURE sp_ModifyTableProperty( 'zvzmobd', 
   'Triggers_Disabled', 
   'False', 'APPEND_FAIL', 'zvzmobdfail');

