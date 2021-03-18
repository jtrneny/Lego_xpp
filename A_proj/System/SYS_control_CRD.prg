#include "appevent.ch"

#include "bap.ch"

#include "Common.ch"
#include "directry.ch"
#include "dac.ch"
#include "dmlb.ch"
#include "font.ch"
#include "gra.ch"
#include "xbp.ch"
#include "drg.ch"

#include "ads.ch"
#include "adsdbe.ch"

#include "drgRes.ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"
#include "..\A_main\ace.ch"
#include "..\A_main\WinApi_.ch"

#pragma Library( "ASINet10.lib" )

static xbp_therm, nindexCnt


CLASS SYS_control_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart
  METHOD  getForm
  METHOD  destroy
  *
  method  start_reindex
  method  exportTab, reinstallDB, runSQL_script
  method  testXX

  inline access assign method is_FExists() var is_FExists
    return if( licasysw->lFExists, MIS_ICON_OK, MIS_ICON_ERR )

  inline access assign method is_colSep() var is_colSep
    return 0

  inline access assign method is_Open() var is_Open
    return if( licasysw->lIsOpen, 1016, 0 )

  inline access assign method is_Distrib() var is_Distrib
    return if( licasysw->isDistrib, D_big, 0 )

  inline access assign method fileName() var fileName
    return if( empty( licasysw->cfileName), '', lower(alltrim(licasysw->cfileName) +'.' +::data_ext ))

  inline access assign method stateAdi() var stateAdi
    return if( licasysw->nstateAdi = 1,  MIS_ICON_OK, 0 )


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  isOk    := .t., cc := ''
    local  ndialog := len(::omenu:dialogList)
    local  nusers  := 1
    local  nselect := len(::dbrow:arSelect)

    * podmínka pro start - zavøené všechny dialogy
    *                    - nevisí tam uživatelé
    *                    - má oznaèený/é záznamy

    if ndialog = 1 .and. nusers = 1 .and. ( nselect <> 0 .or. ::dbrow:is_selAllRec )
      ::Oinfo_text:oxbp:SetCaption( '' )
      ::pb_start_reindex:enable()
    else
      cc := if( ndialog > 1, 'Uzavøete prosím všechny dialogy ...' , ;
             if( nusers > 1, 'K datovému zdroji jsou pøipojeni uživatelé ...', ;
              if( nselect = 0, 'Není vybrán žádný požadavek pro reindexaci ...', '' )))

      ::Oinfo_text:oxbp:SetCaption( cc )
      ::pb_start_reindex:disable()
    endif

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  var     msg, dm, dc, df, brow, dbrow, omenu, hConnect, udcp
  var     pb_start_reindex, Oinfo_text, xbp_therm
  *
  var     osession_Admin, othread
  var     data_ext, index_ext
  var     abitMaps

ENDCLASS


method SYS_control_CRD:init(parent)
  local  nPHASe   := MIS_PHASE1  // MIS_WORM_PHASE1
  local  values   := drgDBMS:dbd:values, cfile, fileName, odbd, x
  *
  local  dir_DATA := drgINI:dir_DATA
  local  afile_Info


  ::data_ext  := DbeInfo( COMPONENT_DATA , DBE_EXTENSION      )
  ::index_ext := DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT   )
  memo_ext    := DbeInfo( COMPONENT_DATA , ADSDBE_MEMOFILE_EXT)

**  get_system_data( 3, 3 )

  odbd := drgDBMS:dbd:getByKey('licasysW')
  odbd:isCrypt := .f.

  drgDBMS:open('licasysw' ,.T., .T., drgINI:dir_USERfitm ) ; ZAP

  for x := 1 to len(values) step 1
    cfile    := lower(values[x,1]) +'.' +lower( ::data_ext )
    fileName := upper(values[x,1])
    odbd     := values[x,2]

    if odbd:lIsCheck .and. .not. ( cfile = 'licasys' +'.' +lower( ::data_ext ))
      afile_Info := Directory( dir_DATA +cfile )
      afile_Info := if( empty(afile_Info), {}, afile_Info[1] )

      licasysw->(dbAppend())
      licasysw->lFExists   := .not. empty( afile_Info )
      licasysw->lIsOpen    := ( select( fileName ) <> 0 )
      licasysw->ctask      := odbd:task
      licasysw->cfileDesc  := odbd:description
      licasysw->cfileName  := fileName
      licasysw->cindexName := fileName + '.' +::index_ext
      licasysw->nfileSize  := if( empty( afile_Info), 0, afile_Info[F_SIZE] )
      licasysw->nindexDef  := len( odbd:indexDef )
      licasysw->isDistrib  := .not. empty( odbd:distrib )

*      s_indexes->( dbsetscope(SCOPE_BOTH,padr(fileName,20)), ;
*                   dbgotop()                               , ;
*                   dbeval({||licasysw->nindexDat++})       , ;
*                   dbclearScope()                            )

    endif
  next

  *
  ** nachystáme si èervíka v pro samostatné vlákno
  ::abitMaps            := { 0, 0, {nil,nil,nil} }

  for x := 1 to 3 step 1
    ::abitMaps[3,x] := XbpBitmap():new():create()
    ::abitMaps[3,x]:load( ,nPHASe )
    nPHASe++
  next

  ::drgUsrClass:init(parent)

return self


method sys_control_crd:getForm()
  local drgFC, oDrg

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 100,17 DTYPE '10' ;
          TITLE 'Nastavení datové kontroly' ;
          GUILOOK 'All:Y,Action:Y,IconBar:y:drgStdBrowseIconBar'

  DRGAction INTO drgFC CAPTION '~ExportTab'    EVENT 'exportTab'     TIPTEXT 'Export tabulek do zadaného formátu'// ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION '~Reinstall_DB' EVENT 'reinstallDB'   TIPTEXT 'Reinstalace databáze'// ICON1 101 ICON2 201 ATYPE 3
//  DRGAction INTO drgFC CAPTION '~Test' EVENT 'testXX'       TIPTEXT 'Test'// ICON1 101 ICON2 201 ATYPE 3
//  DRGAction INTO drgFC CAPTION '~SQL_script'   EVENT 'runSQL_script' TIPTEXT 'Spuštìní opravných SQL_scriptù'// ICON1 101 ICON2 201 ATYPE 3


  DRGDBROWSE INTO drgFC FPOS .4,.2 SIZE 99.2, 14 FILE 'licasysw' ;
             FIELDS 'M->is_FExists::2.6::2,'        + ;
                    'M->is_colSep: :0.1::2,'        + ;
                    'M->is_Open::2.6::2,'           + ;
                    'M->is_Distrib::2.6::2,'        + ;
                    'ctask:úloha,'                  + ;
                    'cfileDesc:Název souboru:43,'   + ;
                    'M->fileName:tabulka:15,'       + ;
                    'nfileSize:velikost,'           + ;
                    'nindexDef:tagDBD,'             + ;
                    'M->stateAdi::3::2'               ;
              SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y' GUILOOK 'sizecols:n,headmove:n'


  DRGSTATIC INTO drgFC FPOS 3,15 SIZE 61, 1.15 STYPE 8
    oDrg:ctype   := XBPSTATIC_TEXT_CENTER
    odrg:groups  := 'THERM'

    DRGTEXT INTO drgFC CAPTION '' CPOS .2, .05 BGND 1 CLEN(60.75)
    oDrg:groups := 'Oinfo_text'
  DRGEND INTO drgFC


  DRGPUSHBUTTON INTO drgFC CAPTION '    ~Start   '             ;
                EVENT 'start_reindex' SIZE 15,1.2 POS 81, 15.2 ;
                ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3
return drgFC


method sys_control_crd:drgDialogStart(drgDialog)
  local  x, odrg
  local  members  := drgDialog:oForm:aMembers
  *
  local  cConnect

  if !isWorkVersion
    cConnect := "DBE=ADSDBE;SERVER=" +drgINI:dir_DATA +drgINI:add_FILE +";UID=ADSSYS"
  else
    cConnect := "DBE=ADSDBE;SERVER=" +drgINI:dir_DATAroot +drgINI:add_FILE +";UID=ADSSYS"
  endif

  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dm        := drgDialog:dataManager             // dataMabanager
  ::brow      := drgDialog:dialogCtrl:obrowse[1]:oxbp
  ::dbrow     := drgDialog:dialogCtrl:obrowse[1]
  ::omenu     := drgDialog:parent:UDCP
  ::othread   := Thread():new()

  * connect to the ADS data-server as ADMIN
  ::osession_Admin := dacSession():New(cConnect)

  if .not. ( ::osession_Admin:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na >DATOVÝ<  server ADS !!!'))
    QUIT
  endif

  ::hConnect := ::osession_Admin:getConnectionHandle()

  for x := 1 to len(members) step 1
    odrg := members[x]

    do case
    case ( odrg:ClassName() = 'drgPushButton' )
      if isCharacter( odrg:event )
        if( odrg:event = 'start_reindex', ::pb_start_reindex := odrg, nil )
      endif

   case ( odrg:className() = 'drgStatic' .and. odrg:groups = 'THERM')
      xbp_therm := ::xbp_therm := odrg:oxbp

    case ( odrg:ClassName() = 'drgText'       )
      if odrg:groups = 'Oinfo_text'
        ::Oinfo_text := odrg

        ::Oinfo_text:oxbp:setFontCompoundName( FONT_DEFPROP_SMALL + FONT_STYLE_BOLD )
        ::Oinfo_text:oXbp:setColorFG( GRA_CLR_BLUE )
      endif
    endcase
  next

*
*** only for my
*** testík ***
* #define ADS_DD_TRIG_TABLEID            1400
* #define ADS_DD_TRIG_EVENT_TYPE         1401
* #define ADS_DD_TRIG_TRIGGER_TYPE       1402
* #define ADS_DD_TRIG_CONTAINER_TYPE     1403
* #define ADS_DD_TRIG_CONTAINER          1404
* #define ADS_DD_TRIG_FUNCTION_NAME      1405
* #define ADS_DD_TRIG_PRIORITY           1406
* #define ADS_DD_TRIG_OPTIONS            1407
* #define ADS_DD_TRIG_TABLENAME          1408

/*
  if licasysW->( dbSeek( cfileName,, 'LICASYSW_3'))

  cStatement := "select left(Name,30)       as Name,"      + ;
                        "Trig_TableName     as TableName," + ;
                        "Triggers_Disabled  as Disabled from system.triggers;"
  oStatement := AdsStatement():New(cStatement,oSession_data)


  if oStatement:LastError > 0
    return .f.
  endif
  oStatement:Execute( 's_triggers' )

  cAlias  := oStatement:Alias
  hCursor := oStatement:hCursor

  astru   := {'Name', 'TableName', 'Disabled' }

  do while .not. (cAlias)->( eof())

    for x := 1 to len(astru) step 1
      cfield := astru[x]
      pa     := AdsGetField( hCursor, cfield )

      drgDump( cfield +' . ' +allTrim(pa[1]) )
    next

    (calias)->( dbskip())
  enddo

  oStatement:alias := ''
  oStatement:Close()

*  pucTriggerName := "osoby::t_OSB_osoby_afterUpdate"
*  pvProperty     := space(512)
*  pusPropertyLen := 512

*  xx := adsDDgetTriggerProperty( pucTriggerName, ADS_DD_TRIG_TABLENAME, pvProperty, pusPropertyLen )

**                         msprc_mo::t_MZD_msprc_mo_afterUpdate
*/

return self


method sys_control_crd:start_reindex()
  local  i, aBitMaps := { 0, {nil,nil,nil} }, nPHASe := MIS_PHASE1, ncolPos
  local  isLast := .f., is_arfilter := ::dbrow:arfilter
  local  cfileName, cindexName
  local  ptrCallback
  *
  ** nachystáme si vrtítko
  for i := 1 to 3 step 1
    aBitMaps[2,i] := XbpBitmap():new():create()
    aBitMaps[2,i]:load( ,nPHASe )
    nPHASe++
  next
  *
  ** nachystáme si data
  if .not. is_arfilter .and. .not. ::dbrow:is_selAllRec
    licasysw->(ads_setAof('.F.'))
    licasysw->(ads_customizeAOF(::dbrow:arselect), dbgotop())
  endif

  * pro smyèku
  licasysw->(dbgoBottom())
  licasysw->isLast := .t.

  licasysw->(dbGoTop())
  ::brow:refreshAll()

  ::othread:setInterval( 10 )
  ::othread:start( "uct_aktucdat_animate", ::brow, 10, aBitMaps)

  *
  ptrCallback := BaCallback("AdsCallBack",BA_CB_GENERIC2)
  AdsRegisterCallbackFunction(ptrCallback, 1)

  do while .not. isLast
    isLast := licasysw->isLast

    cfileName  := allTrim( licasysw->cfileName )

    if !isWorkVersion
      cindexName := drgINI:dir_DATA +allTrim( licasysw->cindexName)
    else
      cindexName := drgINI:dir_DATAroot +allTrim( licasysw->cindexName)
    endif

    if licasysw->lFExists
      * podaøilo se nastavit AUTO_CREATE ?
      if AdsDDSetTableProperty( ::hConnect, cfileName, ADS_DD_TABLE_AUTO_CREATE, 1 ) = 0
        if( licasysw->lisOpen, (cfileName)->(dbcloseArea()), nil )

        ferase( cindexName )

        nindexCnt := 0

        dbuseArea( .t., ::osession_Admin, cfileName,, .f.)
        dbCloseArea()

        AdsDDSetTableProperty( ::hConnect, cfileName, ADS_DD_TABLE_AUTO_CREATE, 0 )

        if( licasysw->lisOpen, drgDBMS:open(cfileName), nil )
      endif
    endif

    ::brow:down():refreshAll()
  enddo

  AdsClearCallbackFunction()
  ::xbp_therm:configure()
  ::Oinfo_text:oxbp:configure()

  * vrátíme to
  ::othread:setInterval(NIL)
  ::othread:synchronize( 0 )

  sleep(10)

  licasysw->isLast := .f.
  if( .not. is_arfilter, licasysw->(ads_clearAOF()), nil )

  ::dbrow:arfilter     := .f.
  ::dbrow:arselect     := {}
  ::dbrow:is_selAllRec := .f.
  ::brow:refreshAll()
return


method sys_control_crd:reinstallDB()
  local  ncolPos
  local  isLast := .f., is_arfilter := ::dbrow:arfilter
  local  cfileName, cindexName
  local  oXbp_text  := ::Oinfo_text:oxbp

  ::Oinfo_text:oxbp:SetCaption( '' )
  *
  ** nachystáme si data
  if is_arfilter .or. len(::dbrow:arselect) <> 0
    licasysw->(ads_clearAof(), dbgoTop() )

    ::dbrow:arfilter := .f.
    ::dbrow:arselect := {}
  endif

  * musíme zavøít otevøené soubpry
  licasysw->( dbeval( { || if( licasysw->lisOpen, ;
                               (allTrim(licasysw->cfileName))->(dbcloseArea()), nil ) } ) )

  * pro smyèku
  licasysw->(dbgoBottom())
  licasysw->isLast := .t.

  licasysw->(dbGoTop())
  ::brow:refreshAll()

  ::othread:setInterval( 20 )
  ::othread:start( "sys_control_crd_reinstall_PB", ::Xbp_therm, ::abitMaps )

  get_system_data()
  check_dbd_data( oXbp_text )

  * konec Instalace / ReInstalace DB
  s_tables  ->( dbCloseArea())
  s_columns ->( dbCloseArea())
  s_indexes ->( dbCloseArea())

  * vrátíme to
  ::othread:setInterval( NIL )
  ::othread:synchronize( 0 )

  ::Xbp_therm:configure()
  ::Oinfo_text:oxbp:SetCaption( 'Reinstalace databáze -' +str(usrIdSW,6) +'- dokonèena ...' )

  sleep(10)

  licasysw->isLast := .f.

  * musíme otevøít pùvodnì otevøené soubpry
  licasysw->( dbeval( { || if( licasysw->lisOpen, ;
                               drgDBMS:open(allTrim(licasysw->cfileName)), nil ) } ) )
  licasysW->(dbgotop())

  ::brow:refreshAll()
return .t.


method sys_control_crd:runSQL_script()
  local  cky := 'SQL_'
  local  cStatement, oStatement
  *
  local  cc, pa := {}

/*
  phConnect  := oSession_data:getConnectionHandle()
  verMajor   := AdsDDGetDatabaseProperty( phConnect, ADS_DD_VERSION_MAJOR, 0, 2 )
  verMinor   := AdsDDGetDatabaseProperty( phConnect, ADS_DD_VERSION_MINOR, 0, 2 )

  nverseDBFi := val (strTran( str(verMajor) +str(verMinor), ' ', ''))

  drgDBMS:open( 'asystem' )
  drgDBMS:open( 'asyssql' )

  asystem ->( Ads_setAOF( "ctypObject = 'SQL_INS'"), ;
              ordSetFocus( ... novy tag ... )      , ;
              dbgotop()                              )

  do while .not. asystem->(eof())
    if asystem ->nverzeDBFi <= nverseDBFi
      if .not. asyssql->( dbseek( upper( asystem->cidObject),, 'ASYSSQL04'))
        aadd( pa, asystem->(recNo())
      endif
    endif
   asystem->( dbskip())
  enddo

  for x := 1 to len( pa) step 1
    sName      := drgINI:dir_USERfitm +userWorkDir() +'\' +asystem->cidObject +'.sql'
    memoWrit(sName, asystem->mobject)
    cStatement := memoRead( sName )
    oStatement := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
      return .f.
    endif
    oStatement:Execute( 'test', .f. )

    nresult := Ads_GetRecordCount( , oStatement:HANDLE )

    oStatement:alias := ''
    oStatement:Close()

    ferase( sName )
  next
*/

  * otevøít              ASYSTEM
  * dal by se použít tag ASYSTEM03 - UPPER(CTYPOBJECT) + UPPER(CZKROBJECT)
  * mobject obsahuje SQL script

  * tohle se mì nelíbí je tam potøeba poøadí pro aplikaci nporAktual

  drgDBMS:open( 'asystem' )
  asystem->( dbgoto( 998 ))

*  asystem->( ordSetFocus( 'ASYSTEM03' ), ;
*             dbSetScope(SCOPE_BOTH,cky), ;
*             DbGoTop()                   )


   sName      := drgINI:dir_USERfitm +userWorkDir() +'\' +asystem->cidObject +'.sql'
   memoWrit(sName, asystem->mobject)
   cStatement := memoRead( sName )

**   ferase( sName )

   oStatement := AdsStatement():New(cStatement,oSession_data)

   if oStatement:LastError > 0
     return .f.
   endif
   oStatement:Execute( 'test', .f. )

*   cAlias  := oStatement:Alias
*   hCursor := oStatement:hCursor

   nusers := Ads_GetRecordCount( , oStatement:HANDLE )

   oStatement:alias := ''
   oStatement:Close()

return .t.


method sys_control_crd:ExportTab(drgDialog)
  local cPath, file, in_dir
  local cfilename
  local key
  local vyber
  local allvyber
  local cc := 'Umístnìní exportovaných dat ...'

  vyber     := self:dbrow:arselect
  allvyber  := self:dbrow:is_selAllRec

  cfileName  := allTrim( licasysw->cfileName )
*  file := selFILE( cfileName,'Dbf',,'Výbìr souboru pro export',{{"DBF soubory", "*.DBF"}})

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )
  if .not. empty(in_Dir)
    cpath := in_Dir +if( right( in_Dir, 1) <> '\', '\', '' )
  else
    return .f.
  endif
  cPath := ConvToAnsiCP( cPath )

  do case
  case allvyber
    cc := 'Exportovat všechny tabulky ?'
  case len(vyber) > 0
    cc := 'Exportovat vybrané tabulky ?'
  otherwise
    cc := 'Exportovat tabulku ' + allTrim( licasysw->cfileName )+' ?'
  endcase


  if drgIsYESNO(drgNLS:msg(cc))
    do case
    case allvyber
      licasysw->( dbGoTop())
      do while .not. licasysw->( Eof())
        cfileName  := allTrim( licasysw->cfileName )
        eport_dbf( cpath, cfileName)
        licasysw->( dbSkip())
      enddo

    case len(vyber) > 0
      for n := 1 to len(vyber)
        licasysw->( dbGoTo( vyber[n]))
        cfileName  := allTrim( licasysw->cfileName )
        eport_dbf( cpath, cfileName)
      next

    otherwise
      cfileName  := allTrim( licasysw->cfileName )
      eport_dbf( cpath, cfileName)
    endcase
  endif


RETURN nil


method sys_control_crd:testXX(drgDialog)
  local njd
  local aX

//  njd := val(::testGet)

//  aX :=  mh_FROMJULIANDATE( 2457731.23328 )
//  aX :=  mh_FROMJULIANDATE( 2457502.84381 )

//  njd := 0


RETURN nil



method sys_control_crd:destroy()
  ::drgUsrClass:destroy()

  if( isObject(::osession_Admin), ::osession_Admin:disconnect(), nil )
  ::othread := nil
return nil


*
** callBack function for reindexing
function AdsCallBack(nPct, nID)
  if nid == 1
    if npct == 100
      nindexCnt++
      reindex_PB()
    endif
  endif
return 0


static function reindex_PB()
  LOCAL  oxbp, oPS
  LOCAL  aAttr[GRA_AA_COUNT], aPos := {2,0}
  local  nclrs := GraMakeRGBColor({0, 183, 91})
  local  nstepBy
  *
  LOCAL  prc, nSize, nHight, newPos

  oxbp   := xbp_therm
  nSize  := oxbp:currentSize()[1]
  nHight := oxbp:currentSize()[2] -4

  if !EMPTY(oPS := oXbp:lockPS())
    aAttr [ GRA_AA_COLOR ] := nclrs
    GraSetAttrArea( oPS, aAttr )

    nstepBy := round( nsize / licasysw->nindexDef, 0)
    newPos  := nstepBy * nindexCnt
    GraBox( oPS, {aPos[1],2}, {newPos, nHight}, GRA_OUTLINEFILL )

    if nindexCnt < licasysw->nindexDef
      aAttr [ GRA_AA_COLOR ] := GRA_CLR_BACKGROUND
      GraSetAttrArea( oPS, aAttr )
      GraBox( oPS, {newPos + .1,2}, {nSize -2,nHight}, GRA_FILL)
    endif

    nstepBy := 100 / licasysw->nindexDef
    val     := round(nstepBy * nindexCnt, 0)
    prc := if( val > 100, '100', str(val,3)) +' %'
    GraStringAt( oPS, {(nSize/2) -20,6}, prc)

    oXbp:unlockPS(oPS)
  endif
return prc


procedure sys_control_crd_reinstall_PB(xbp_therm,abitMaps, xbp_text,cinfoText)
  local  aRect, oPS, nXD, nYD
  *
  local  aAttr[GRA_AA_COUNT]
  local  nSize  := xbp_therm:currentSize()[1]
  local  nHight := xbp_therm:currentSize()[2] // -4

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  nXD     := abitMaps[2]
  nYD     := 3

  aAttr [ GRA_AA_COLOR ] := GRA_CLR_BACKGROUND
  GraSetAttrArea( oPS, aAttr )
*  GraBox( oPS, {2,1}, {nSize -4,nHight}, GRA_FILL)

*  GraBox( oPS, {2,1}, {nSize -4,nHight}, GRA_OUTLINE )

  GraBox( oPS, {0,0}, {nSize -1, nHight -1 }, GRA_OUTLINEFILL )

  abitMaps[1] ++
  if abitMaps[1] > len(aBitMaps[3])
    abitMaps[1] := 1
  endif

  abitMaps[ 3, abitMaps[1] ]:draw( oPS, {nXD,nYD} )
  xbp_therm:unlockPS( oPS )

  if abitMaps[2] +10 > aRect[1]
    abitMaps[2] := 0
  else
    abitMaps[2] := abitMaps[2] +10
  endif
return


static function eport_dbf( path, file)
  local newfile

  drgDBMS:open(file)
  newfile := path +file+".dbf"
  (file)->( AdsConvertTable( newfile, 1 ))

return nil