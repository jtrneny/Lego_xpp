#include "Appevent.ch"
#include "Common.ch"
#include "Directry.ch"
#include "dll.ch"
#include "dbstruct.ch"
#include "Font.ch"
#include "Gra.ch"
#include "Xbp.ch"

#include "drg.ch"
#include "drgRes.ch"

#include "XbZ_Zip.ch"

#include "..\Asystem++\Asystem++.ch"
#include "..\Asystem++\ASYSTEM++_setup.ch"

#include "..\A_main\ace.ch"
#include "..\A_main\WinApi_.ch"



CLASS AsystemLogin FROM drgUsrClass
EXPORTED:
  VAR     klient

  METHOD  init
  METHOD  getForm
  METHOD  drgDialogInit, drgDialogStart
  METHOD  postValidate
  METHOD  destroy

  method  rootDirDB, getLicasys, rootDirKL, rootDirDLL
  *
  * 1
  * základní okno  - promìnné
  inline access assign method VtabPage1_mle1() var VtabPage1_mle1
    return tabPage_1_mle1

  inline access assign method VtabPage1_mle2() var VtabPage1_mle2
    return tabPage_1_mle2
  *
  * 2
  * licenèní ujednání
  inline access assign method VtabPage2_mle() var VtabPage2_mle
    return tabPage_2_mle1

  var VtabPage2_rButton

  inline method MtabPage2_rButton(oXbp)
    local  members := oXbp:cargo:members, npos
    local  isSet   := .f.

    aeval( members, { |o| if( o:getData(), isSet := .t., nil ) } )
    if( .not. isSet, oXbp:setData(.t.), nil )

    npos := ascan( members, oxbp)

    if( oXbp:getData(), ::VtabPage2_rButton := oxbp:cargo:values[npos,1], nil )

    if( ::VtabPage2_rButton = 'S', ;
        ::pb_nextButtonClick:enable(), ::pb_nextButtonClick:disable() )
  return self
  *
  * 3
  * typ instalce
  var  VtabPage3_rButton
  var  VtabPage3_getLicasys
  var  VtabPage3_chBox1, VtabPage3_chBox2, VtabPage3_chBox3

  inline method MtabPage3_rButton(oXbp)
    local  members := oXbp:cargo:members, npos
    local  isSet   := .f.
    local  caption

    aeval( members, { |o| if( o:getData(), isSet := .t., nil ) } )
    if( .not. isSet, oXbp:setData(.t.), nil )

    npos := ascan( members, oxbp)

    if oXbp:getData()
      ::VtabPage3_rButton := oxbp:cargo:values[npos,1]

      ::set_val( 'M->VtabPage3_getLicasys' , ''  )
      ::set_val( 'M->VtabPage3_chBox1'     , .f. )
      ::set_val( 'M->VtabPage3_chBox2'     , .f. )
      ::set_val( 'M->VtabPage3_chBox3'     , .f. )

      if Select('licasys') <> 0
        licasys-> (dbcloseArea())
        licasysw->(dbZap())
        ::OtabPage4_broLicasys:oxbp:refreshAll()
      endif

      caption := if( npos = 3, '~ReInstalace', '~Instalace' )

     ::pb_installDB:oxbp:setCaption( caption )
     ::pb_installKL:oxbp:setCaption( caption )
     ::pb_installDLL:oxbp:setCaption(caption )

      if npos = 3
        ::set_val( 'M->VtabPage3_chBox1', .t. )
        ::set_val( 'M->VtabPage3_chBox2', .t. )
      endif
    endif
  return self

  inline method MtabPage3_chBox( oxbp )
    local sel_Licasys := file(::VtabPage3_getLicasys)

    do case
    case oXbp:cargo:name = 'M->VtabPage3_chBox1' ; ::VtabPage3_chBox1 := oXbp:getData()
    case oXbp:cargo:name = 'M->VtabPage3_chBox2' ; ::VtabPage3_chBox2 := oXbp:getData()
    case oXbp:cargo:name = 'M->VtabPage3_chBox3' ; ::VtabPage3_chBox3 := oXbp:getData()
    endcase

    ::set_val( oXbp:cargo:name, oXbp:getData() )

    if( sel_Licasys .and. (::VtabPage3_chBox1 .or. ::VtabPage3_chBox2 .or. ::VtabPage3_chBox3), ;
      ::pb_nextButtonClick:enable(), ::pb_nextButtonClick:disable() )

  return self
  *
  *
  ** 4   volba cílové složky DB - Intalace/ reInstalace
  var  VtabPage4_rootDirDB, OtabPage4_broLicasys, OtabPage4_therm, OtabPage4_text

  inline access assign method is_existDB() var is_existDB
    local  retVal := 0, cdataADD

    if .not. licasysw->(eof())
      retVal := if( licasysw->phConnect = 0, MIS_NO_RUN, MIS_ICON_OK )
    endif
    return retVal

  inline access assign method is_colSep() var is_colSep
    return 0

  inline method installDB()
    local  cval       := ::VtabPage3_rButton
    local  oXbp_therm := ::OtabPage4_therm:oXbp
    local  oXbp_text  := ::OtabPage4_text:oXbp
    local          cc := if( right( ::VtabPage4_rootDirDB,1) = '\', '', '\' )
    *
    local  cdirADD    := ::VtabPage4_rootDirDB +cc   + ;
                         'Data\'                     + ;
                         allTrim(licasysw->cdataDir) + ;
                         '\Data\'
    local  cfileADD   := 'A++_' +strZero(licasysw->nusrIdDB,6) +'.add'
    *
    local  phConnect  := licasysw->phConnect
    local  nver_MAJOR := val( left  ( SpecialBuild, at( '.', SpecialBuild) -1))
    local  nver_MINOR := val( substr( SpecialBuild, at( '.', SpecialBuild) +1))
     *
    local cStatement, oStatement
    local stmt_disableTriggers := "EXECUTE PROCEDURE sp_DisableTriggers( NULL, NULL, FALSE, 0 );"
    local stmt_enableTriggers  := "EXECUTE PROCEDURE sp_EnableTriggers( NULL, NULL, FALSE, 0 );"


    ::pb_setState( .t., ::pb_installDB )

    * pokud reinstaluje stejnou verzi radìji se zeptáme
    if (nver_MAJOR = licasysw->nmajor_ADD) .and. (nver_MINOR = licasysw->nminor_ADD )
      nsel := ConfirmBox( ,'Databáze již byla aktualizována, opravdu spustit Reinstalaci _', ;
                         'Verze databáze jsou shodné ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

      if nsel = XBPMB_RET_NO
        ::pb_setState( .f., ::pb_installDB )
        return .t.
      endif
    endif

    * instalace nové DB, pak už je to stejné
    if licasysw->phConnect = 0 .and. ( cval = 'D' .or. cval = 'I' )
       MyCreateDir( cdirADD )

       phConnect :=  AdsDDCreate( cdirADD +cfileADD )
                     AdsDDSetDatabaseProperty( phConnect                    , ;
                                               ADS_DD_ENCRYPT_TABLE_PASSWORD, ;
                                               syApa                        , ;
                                                                              )
       AdsDisconnect( phConnect )
    endif

    cConnect      := "DBE=ADSDBE;SERVER=" +cdirADD +cfileADD +";"+AllTrim(drgINI:ads_SERVER_TYPE)+";UID=ADSSYS"
//    drgDump(cConnect)
    oSession_data := dacSession():New(cConnect)


    * check if we are connected to the ADS data-server
    if .not. ( oSession_data:isConnected() )
      drgMsgBox(drgNLS:msg('Nelze se pøipojit na >DATOVÝ<  server ADS !!!'))
    else
      phConnect := oSession_data:getConnectionHandle()

      * ovìøíme jestli je tam nìkdo pøipojen, 1 - zanmená že jsem tam sám
      if get_table_users( allTrim(isNull(licasysw->tablePath,'')) +cfileADD ) > 1
        cc := '( ' +allTrim( upper( licasysw->cnazFirPri ))  +'_ ' +cfileADD +' )'
        ConfirmBox( ,'K databázi ' +cc +' jsou pøipojeni uživatlé, nelze spustit ReInstalaci _' , ;
                     'Nelze spustit reinstalaci ... ' , ;
                     XBPMB_OK                         , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

        ::pb_setState( .f., ::pb_installDB )
        return .t.
      else
        * vystavíme zámek na ADD
        AdsDDSetDatabaseProperty( phConnect, ADS_DD_LOGINS_DISABLED, 1, 2 )
      endif
      *
      ** musíme vypnout trigry
      oStatement := AdsStatement():New(stmt_disableTriggers,oSession_data)
      if oStatement:LastError > 0
*         return .f.
      else
        oStatement:Execute( 'test', .f. )
      endif

      ::othread:setInterval( 20 )
      ::othread:start( "setup_work_animate", oXbp_therm,::abitMaps )

      cc := if( ::VtabPage3_rButton = 'R', 'ReInstalace DB_ ', 'Instalace DB_ ')
      cc += strZero(licasysw->nusrIdDB,6) +' ,' +left(licasysw->cnazFirmy, 40)
      setup_work_textinfo(oXbp_text, cc )

      get_system_data()

      check_dbd_data( oXbp_text )

      * konec Instalace / ReInstalace DB
      s_tables  ->( dbCloseArea())
      s_columns ->( dbCloseArea())
      s_indexes ->( dbCloseArea())

      * zapíšeme major a minor verzi do DD
      AdsDDSetDatabaseProperty( phConnect, ADS_DD_VERSION_MAJOR, nver_MAJOR, 2 )
      AdsDDSetDatabaseProperty( phConnect, ADS_DD_VERSION_MINOR, nver_MINOR, 2 )

      * instalace distribuèních souborù
      if( .not. empty(cdistrib_Dir), ::installDB_distrib(), nil )

      * alikace opravných SQL scriptù
      ::installDB_sql( val (strTran( str(nver_Major) +str(nver_Minor), ' ', '')) )

      * zrušíme BAK soubory, mùže jich tam být dost
      aeval( directory( cdirADD + '*.bak' ), { |afile| ferase( cdirAdd + afile[1] ) })

      * vrátíme to
      ::othread:setInterval( NIL )
      ::othread:synchronize( 0 )

      oXbp_therm:configure()
      oXbp_text:configure()

      licasysw->cversionDB := SpecialBuild
      ::OtabPage4_broLicasys:oxbp:refreshCurrent()

      *
      ** musíme zapnout trigry
      oStatement := AdsStatement():New(stmt_enableTriggers,oSession_data)
      if oStatement:LastError > 0
*         return .f.
      else
        oStatement:Execute( 'test', .f. )
     endif

      * zhodíme zámek na ADD
      AdsDDSetDatabaseProperty( phConnect, ADS_DD_LOGINS_DISABLED, 0, 2 )
      AdsDisconnect( phConnect )
    endif


    ::pb_setState( .f., ::pb_installDB )
  return .t.

  inline method installDB_distrib()
    local  x, cc, odbd, fileData, fileDist, ctagDist, npos, tagKey, xkey
    local  adir := Directory( cdistrib_Dir +'*.ADT')
    *
    local  isEmpty

    * musíme nastavit public
    usrIdDB := licasysw->nusrIdDB

    for x := 1 to len( adir) step 1
      cc       := adir[x, F_NAME]
      *
      fileData := subStr( cc, 1, at( '.' , cc) -1 )
      fileDist := cdistrib_Dir +adir[x, F_NAME]
      isEmpty  := .f.

      if isObject( odbd := drgDBMS:getDBD( fileData ))     // existuje
        if .not. empty( ctagDist := odbd:distrib )         // je distribuèní

          npos     := ascan(  odbd:indexDef, { |x| x:cName = ctagDist } )
          tagKey   := odbd:indexDef[npos]:cIndexKey

          drgDBMS:open( fileData, .t., ,,, 'aliasData' )
          isEmpty := ( aliasData->(lastRec()) = 0 )

          DbUseArea( .t., oSession_free, fileDist, 'aliasDist', .f.)

          do while .not. aliasDist->( eof())
            xkey     := aliasDist ->( DBGetVal(tagKey) )
            ndistrib := aliasDist ->ndistrib

            if aliasData ->( dbseek( xkey,, ctagDist ) )

              do case
              case( ndistrib = 1 )                          // pøepisuje vždy
                mh_copyFld_no_user( 'aliasDist',  'aliasData'     )
*                mh_copyFld( 'aliasDist',  'aliasData'     )
              case( ndistrib = 2 )                          // nic
              case( ndistrib = 3 )                          // zrušit
                aliasData ->(dbdelete())
              case( ndistrib = 4 )                          // nic
              endcase

            else

              do case
              case( ndistrib = 1 )                          // pøidá záznam vždy
                mh_copyFld( 'aliasDist', 'aliasData', .t. )
              case( ndistrib = 2 )                          // pøidá záznam vždy
                mh_copyFld( 'aliasDist', 'aliasData', .t. )
              case( ndistrib = 3 )                          // nic
              case( ndistrib = 4 .and. isEmpty )            // pøidá se jen pokud tabulka pøi oevøení byla prázdná
                mh_copyFld( 'aliasDist', 'aliasData', .t. )
              endcase

            endif

            aliasDist->(dbskip())
          enddo

           aliasDist ->(dbCloseArea())
           aliasData ->(dbCloseArea())
        endif
      endif
    next
  return .t.

  inline method installDB_sql( nverzeDBFi_dd )
    local  pa := {}, x, sName, nresult, cc, nverzeDBfi
    local  cStatement, oStatement
    *
    local  oXbp_text  := ::OtabPage4_text:oXbp
    local  cfiltr     := "ctypObject = 'SQL_INS' .or.  " + ;
                         "ctypObject = 'SQL_PROC' .or. " + ;
                         "ctypObject = 'SQL_TRIG' .or. " + ;
                         "ctypObject = 'SQL_FUNC'"

    drgDBMS:open( 'asystem', .t. )
    asystem->( ordSetFocus( 'ASYSTEM10' ))

    drgDBMS:open( 'asyssql', .t. )

    asystem ->( Ads_setAOF( cfiltr), dbgoTop() )

    do while .not. asystem->(eof())
      nverzeDBFi := isNull( asystem->nverzeDBFi, 0 )

      if( nverzeDBFi <> 0 .and. nverzeDBFi <= nverzeDBFi_dd )
        if .not. asyssql->( dbseek( upper( asystem->cidObject),, 'ASYSSQL04'))
          aadd( pa, asystem->(recNo()) )
        endif
      endif
      asystem->( dbskip())
    enddo

    for x := 1 to len( pa) step 1
      asystem->( dbgoto( pa[x] ))

      drgDump( asystem->cidobject)

      cc := left( asystem->cnameObj, 65 )
      setup_work_textinfo(oXbp_text, cc )

      sName      := drgINI:dir_USERfitm +userWorkDir() +'\' +asystem->cidObject +'.sql'
      memoWrit(sName, asystem->mobject)
      cStatement := memoRead( sName )
      oStatement := AdsStatement():New(cStatement,oSession_data)

      if oStatement:LastError > 0
        return .f.
      endif
      oStatement:Execute( 'test', .f. )

      nresult := Ads_GetRecordCount( , oStatement:HANDLE )
      setup_work_textinfo(oXbp_text, cc  +'ok (' +str(nresult) +')')
      sleep( 20 )

      oStatement:alias := ''
      oStatement:Close()

      mh_copyFld( 'asystem', 'asyssql', .t. )
      ferase( sName )
    next

    asystem->( dbcloseArea())
    asyssql->( dbcloseArea())
  return .t.
  *
  *
  ** 5  volba cílové složky KLIENTA - Instalace/ reInstalace
  var VtabPage5_rootDirKL, OtabPage5_therm, OtabPage5_text

  inline method installKL()
    local  oXbp_therm := ::OtabPage5_therm:oXbp
    local  oXbp_text  := ::OtabPage5_text:oXbp
    *
    local  cbinn_Azf   := ccurrent_Dir +'A++_Binn.azf'
    local  cbinn_Dir   := ::VtabPage5_rootDirKL +'\Binn'
    *
    local  csystem_Azf := ccurrent_Dir +'A++_System.azf'
    local  csystem_Ini := ::VtabPage5_rootDirKL +'\System'
    local  csystem_Dir := ::VtabPage5_rootDirKL +'\System\Resource'
    local  cuser_Dir   := ::VtabPage5_rootDirKL +'\Users'
    local  cAdsServer
    local  ozip, cc
    *
    local  cdir_Data   := ::VtabPage5_rootDirKL +'\Data'

    ::pb_setState( .t., ::pb_installKL )

    ::othread:setInterval( 20 )
    ::othread:start( "setup_work_animate", oXbp_therm,::abitMaps )

    cAdsServer := Chr(39) +'ADS_LOCAL_SERVER' +Chr(39)

    cc := if( ::VtabPage3_rButton = 'R', 'ReInstalace KLIENTA_ ', 'Instalace KLIENTA_ ')
    cc += 'Asystem++ '
    setup_work_textinfo(oXbp_text, cc )

    * klient
    if file( cbinn_Azf ) .and. file( ::VtabPage5_rootDirKL, 'D' )
      createDir(cbinn_Dir)

      ozip := XbZLibZip():New( cbinn_Azf, XBZ_OPEN_READ)
      ozip:Extract( cbinn_Dir, '*.*', .t., XBZ_OVERWRITE_ALL )
      ozip:close()

      * musíme založit INI soubor pokud není
      if .not. file( cbinn_Dir +'\Asystem++.ini' )
        cc := '[Section]'                           +CRLF + ;
              'isdataTypeDBF      := .F.'           +CRLF + ;
              '  '                                  +CRLF + ;
              '//  ADS type server - ADS_LOCAL_SERVER,ADS_REMOTE_SERVER,ADS_AIS_SERVER' +CRLF + ;
              'drgINI:ads_SERVER_TYPE := ' +cAdsServer +CRLF + ;
              '  '                                  +CRLF + ;
              'drgINI:dir_DATA    := ' +cdir_Data   +CRLF + ;
              'drgINI:dir_SYSTEM  := ' +csystem_Ini +CRLF + ;
              'drgINI:dir_USER    := ' +cuser_Dir   +CRLF + CRLF

        memoWrit( cbinn_Dir +'\Asystem++.ini', cc )
      endif
    endif

    * system
    if file( csystem_Azf )           // .and. file( ::VtabPage5_rootDirKL, 'D' )
      createDir(csystem_Dir)

      ozip := XbZLibZip():New( csystem_Azf, XBZ_OPEN_READ)
      ozip:Extract( csystem_Dir, '*.*', .t., XBZ_OVERWRITE_ALL )
      ozip:close()
    endif

    * vrátíme to
    ::othread:setInterval( NIL )
    ::othread:synchronize( 0 )

    oXbp_therm:configure()
    oXbp_text:configure()

    ::pb_setState( .f., ::pb_installKL )
  return nil
  *
  *
  ** 6 volba cílové složky RUNTIME - Instalace / reInstalace
  var VtabPage6_rootDirDLL, OtabPage6_therm, OtabPage6_text

  inline method installDLL()
    local  oXbp_therm := ::OtabPage6_therm:oXbp
    local  oXbp_text  := ::OtabPage6_text:oXbp
    *
    local  cruntime_Azf := ccurrent_Dir +'A++_Runtime.azf'
    local  cruntime_Dir := ::VtabPage6_rootDirDLL
    local  ozip, cc

    ::pb_setState( .t., ::pb_installDLL )

    ::othread:setInterval( 20 )
    ::othread:start( "setup_work_animate", oXbp_therm,::abitMaps )

    cc := if( ::VtabPage3_rButton = 'R', 'ReInstalace KNIHOVNY_ ', 'Instalace KNIHOVNY_ ')
    cc += 'Asystem++ '
    setup_work_textinfo(oXbp_text, cc )

    if file( cruntime_Azf )         // .and. file( ::VtabPage6_rootDirDLL, 'D' )
      createDir(cruntime_Dir)

      ozip := XbZLibZip():New( cruntime_Azf, XBZ_OPEN_READ)
      ozip:Extract( cruntime_Dir, '*.*', .t., XBZ_OVERWRITE_ALL )
      ozip:close()
    endif

    * vrátíme to
    ::othread:setInterval( NIL )
    ::othread:synchronize( 0 )

    oXbp_therm:configure()
    oXbp_text:configure()

    ::pb_setState( .f., ::pb_installDLL )
  return nil


  inline method nextButtonClick()
    local  tabNum   := ::tabNum +1
    local  oLastDrg := ::df:oLastDrg, postBlock

    if tabNum <= 6
      if oLastDrg:name = 'M->VtabPage4_rootDirDB'
        postBlock          := oLastDrg:postBlock
        oLastDrg:postBlock := NIL
      endif

      ::df:tabPageManager:toFront(tabNum)
      ::df:tabPageManager:showPage(tabNum)

      ::tabNum := tabNum
      ::pb_prevButtonClick:oxbp:show()

      do case
      case tabNum = 2
        if( ::VtabPage2_rButton = 'S', ;
            ::pb_nextButtonClick:enable(), ::pb_nextButtonClick:disable() )

      case tabNum = 3
        if( ::VtabPage3_chBox1 .or. ::VtabPage3_chBox2 )
          ::pb_nextButtonClick:enable()

        else
          ::pb_nextButtonClick:disabled := .F.
          ::pb_nextButtonClick:disable()

        endif

      case tabNum = 4
        if .not. empty( ::VtabPage4_rootDirDB )
          PostAppEvent(xbeBRW_ItemMarked,,,::OtabPage4_broLicasys:oxbp)
        endif
      endcase

      if oLastDrg:name = 'M->VtabPage4_rootDirDB'
        oLastDrg:postBlock := postBlock
      endif

    endif
  return self

  inline method prevButtonClick()
    local tabNum   := ::tabNum -1
    local oLastDrg := ::df:oLastDrg, postBlock

    if tabNum > 0
      if oLastDrg:name = 'M->VtabPage4_rootDirDB'
        postBlock          := oLastDrg:postBlock
        oLastDrg:postBlock := NIL
      endif

      ::df:tabPageManager:toFront(tabNum)
      ::df:tabPageManager:showPage(tabNum)

      ::tabNum := tabNum

      do case
      case tabNum = 1
        ::pb_prevButtonClick:oxbp:hide()
        ::pb_nextButtonClick:enable()

      case tabNum = 2
        if( ::VtabPage2_rButton = 'S', ;
          ::pb_nextButtonClick:enable(), ::pb_nextButtonClick:disable() )

      endcase

      if oLastDrg:name = 'M->VtabPage4_rootDirDB'
        oLastDrg:postBlock := postBlock
      endif

    endif
  return self

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  new_val, drgVar

    do case
    case( nevent = xbeP_Selected )
      do case
      case( oXbp:cargo:ClassName() = 'drgRadioButton')
        do case
        case oXbp:cargo:name = 'M->VtabPage2_rButton' ; ::MtabPage2_rButton( oxbp )
        case oXbp:cargo:name = 'M->VtabPage3_rButton' ; ::MtabPage3_rButton( oxbp )
        endcase

      case( oXbp:cargo:ClassName() = 'drgCheckBox'  )
        ::MtabPage3_chBox( oxbp )

      endcase

    case(nevent = xbeBRW_ItemMarked)
      do case
      case ::tabNum = 4
        drgVar := ::dm:has('M->VtabPage4_rootDirDB')
        if .not. ::postValidate( drgVar )
          ::df:setNextFocus('M->VtabPage4_rootDirDB',,.t.)
          return .t.
        endif
      endcase
    endcase
  return .f.

hidden:
  var     tabNum
  var     dm, dc, df, othread
  var     pb_prevButtonClick, pb_nextButtonClick, pb_stopButtonClick
  var     pb_installDB, pb_installKL, pb_installDLL
  *
  var     abitMaps


  inline method set_val( cvarName, xVal )
    local cname   := strTran( cvarName, 'M->', '' )

    self:&cname := xVal
    ::dm:set( cvarName, xVal )
  return self

  inline method pb_setState( lDisable, pb_action )

    if lDisable
        pb_action:disable()
      ::pb_prevButtonClick:disable()
      ::pb_nextButtonClick:disable()
      ::pb_stopButtonClick:disable()

    else
        pb_action:enable()
      ::pb_prevButtonClick:enable()
      ::pb_nextButtonClick:enable()
      ::pb_stopButtonClick:enable()

    endif
  return self
ENDCLASS


METHOD AsystemLogin:init(parent)
  local  x, nPHASe := MIS_PHASE1  // MIS_WORM_PHASE1

  ::drgUsrClass:init(parent)

  ::VtabPage2_rButton    := 'N'
  *
  ::VtabPage3_rButton    := 'D'
  ::VtabPage3_getLicasys := ''
  ::VtabPage3_chBox1     := .F.
  ::VtabPage3_chBox2     := .F.
  ::VtabPage3_chBox3     := .F.
  *
  ::VtabPage4_rootDirDB  := ''
  *
  ::VtabPage5_rootDirKL  := ''
  *
  ::VtabPage6_rootDirDLL := 'C:\Program Files\Asystem++\Binn\Runtime'

  *
  ** nachystáme si èervíka v pro samostatné vlákno
  ::abitMaps            := { 0, 0, {nil,nil,nil} }

  for x := 1 to 3 step 1
    ::abitMaps[3,x] := XbpBitmap():new():create()
    ::abitMaps[3,x]:load( ,nPHASe )
    nPHASe++
  next

  * hidden
  ::tabNum      := 1
  ::klient      := .f.

  drgDBMS:open('licasysw' ,.T., .T., drgINI:dir_USERfitm )
RETURN self


METHOD AsystemLogin:getForm()
  local  cVALS := ''
  LOCAL  drgFC, oDrg, cParm
  LOCAL  nEvent, mp1 := NIL, mp2 := NIL, oXbp, lExit, aPos, aWinPos
  LOCAL  oDlg, oID, oPW, drawingArea, aSize

  drgFC  := drgFormContainer():new()


  DRGFORM INTO drgFC SIZE 80,17 DTYPE '10' TITLE 'Prùvodce instalaci - Asystem++' ;
                                           POST  'postValidate'                   ;
                                           GUILOOK 'ALL:Y BORDER:Y ACTION:Y'

*
* 1
* základní okno
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC CAPTION '2' FPOS 0,1 SIZE 150,200 STYPE XBPSTATIC_TYPE_BITMAP

    DRGMLE M->VtabPage1_mle1  INTO drgFC FPOS 22, 0 SIZE 58, 4 SCROLL 'N'
    oDRG:groups := 'M'

    DRGMLE M->VtabPage1_mle2  INTO drgFC FPOS 22, 4 SIZE 58, 10.8 SCROLL 'N'

    DRGPUSHBUTTON INTO drgFC CAPTION '' EVENT '' SIZE 0,0 POS 0,0
  DRGEND INTO drgFC
*
* 2
* licenèní ujednání
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Licenèní ujedání' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Prosím pøeètìt si tyto dùležité informace pøedtím, než budete' CPOS 2,1.2 BGND 1
      DRGTEXT INTO drgFC CAPTION 'pokraèovat.' CPOS 2,2 BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Prosím pøeètìt si toto Licenèní ujednání. Musíte souhlasit s podmínkami' CPOS 2,3.5 BGND 1
    DRGTEXT INTO drgFC CAPTION 'tohoto ujednání, aby mohl instalaèní proces pokraèovat.' CPOS 2,4.3 BGND 1

    DRGMLE M->VtabPage2_mle INTO drgFC FPOS 2,5.5 SIZE 76,6 SCROLL 'NY'

    DRGRADIOBUTTON M->VtabPage2_rButton INTO drgFC FPOS 2,12 SIZE 40,3 PP 2 ;
                   POST   'postValidate'                                        ;
                   VALUES 'S:Souhlasím s podmínkamo Licenèního ujednání,'     + ;
                          'N:Nesouhlasím s podmínkami Licenèního ujednání'

  DRGEND INTO drgFC
*
* 3
* typ instalce
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0

    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Typ instalace' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Jakou instalaci chcete provést ?'            CPOS 2,1.2 BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Vyberte typ instalace produktu, ' CPOS 2,3.5 BGND 1

    DRGRADIOBUTTON M->VtabPage3_rButton INTO drgFC FPOS 4,4.7 SIZE 40,3 PP 2 ;
                   VALUES 'D: Instalace >DEMO< verze poduktu,'  + ;
                          'I: Instalace produktu,'  + ;
                          'R: Reinstalace již existující verze'

    DRGSTATIC INTO drgFC FPOS .5,5.5 SIZE 79.5,3 STYPE XBPSTATIC_TYPE_RECESSEDLINE
    oDrg:ctype := 1

    DRGTEXT INTO drgFC CAPTION 'licenèní soubor ' CPOS 2,8.7 BGND 1

    DRGGET  M->VtabPage3_getLicasys INTO drgFC FPOS 4,9.7 FLEN 70 POST 'postValidate'
    oDrg:push  := 'getLicasys'

    DRGSTATIC INTO drgFC FPOS .5,8.5 SIZE 79.5,3 STYPE XBPSTATIC_TYPE_RECESSEDLINE
    oDrg:ctype := 1

    DRGTEXT INTO drgFC CAPTION 'a upøesnìte prosím vlastní typ instalace.' CPOS 2,11.7 BGND 1
    DRGCHECKBOX M->VtabPage3_chBox1 INTO drgFC FPOS  4.5, 12.7 FLEN 14.5 VALUES 'T:    databáze   >,F:    databáze   >'
    DRGCHECKBOX M->VtabPage3_chBox2 INTO drgFC FPOS 33  , 12.7 FLEN 14.5 VALUES 'T:    klient         >,F:    klient         >'
    DRGCHECKBOX M->VtabPage3_chBox3 INTO drgFC FPOS 61.5, 12.7 FLEN 14.5 VALUES 'T:    knihovny    >,F:    knihovny    >'
  DRGEND INTO drgFC
*
*
** 4   volba cílové složky DB - Intalace/ reInstalace
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Instalace databáze ver. ' +SpecialBuild CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Kam má být DB Asystem++ nainstalována ?' CPOS 2,1.2   BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Zvolte složku, do které má být DB Asystem++ nainstalována, a klepnìte Další.' CPOS 2,3.5 BGND 1 CLEN 70

    * dir_DATA
    DRGGET     M->VtabPage4_rootDirDB INTO drgFC FPOS 3,4.7 FLEN 73 POST 'postValidate'
    oDrg:push := 'rootDirDB'

    DRGDBROWSE INTO drgFC FPOS 3,6 SIZE 73.9, 5.7 FILE 'licasysw' ;
      FIELDS 'M->is_existDB::2.6::2,'     + ;
             'M->is_colSep: :0.1::2,'     + ;
             'nusrIDDB:DB:6,'             + ;
             'cnazFirPri:Název firmy:30,' + ;
             'cversionDB:verzeDB:10,'     + ;
             'cico:ièo,'                  + ;
             'cdic:diè'                     ;
      SCROLL 'ny' CURSORMODE 3 PP 7 GUILOOK 'sizecols:n,headmove:n'

    DRGSTATIC INTO drgFC FPOS 3,11.8 SIZE 73.9, 0.82
      oDrg:groups := 'OtabPage4_therm'
    DRGEND INTO drgFC


    DRGSTATIC INTO drgFC FPOS 3,13.1 SIZE 60, 0.8
      oDrg:ctype  := XBPSTATIC_TEXT_CENTER
      oDrg:groups := 'OtabPage4_text'
    DRGEND INTO drgFC

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start    '         ;
                  EVENT 'installDB' SIZE 13,1.1 POS 64, 13.5 ;
                  ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3

  DRGEND INTO drgFC
*
*
** 5  volba cílové složky KLIENTA - Instalace/ reInstalace
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Instalace klienta' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Kam má být KLIENT Asystem++ nainstalován ?' CPOS 2,1.2   BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Zvolte složku, do které má být KLIENT Asystem++ nainstalována, a klepnìte Další.' CPOS 2,3.5 BGND 1 CLEN 70

    * dir_DATA
    DRGGET  M->VtabPage5_rootDirKL INTO drgFC FPOS 3,4.7 FLEN 73 POST 'postValidate'
    oDrg:push := 'rootDirKL'

    DRGMLE M->VtabPage2_mle INTO drgFC FPOS 3,6 SIZE 73.9,5.7 SCROLL 'NY'  // PP 2

    DRGSTATIC INTO drgFC FPOS 3,11.8 SIZE 73.9, 0.82
      oDrg:groups := 'OtabPage5_therm'
    DRGEND INTO drgFC

    DRGSTATIC INTO drgFC FPOS 3,13.1 SIZE 60, 0.8
      oDrg:ctype  := XBPSTATIC_TEXT_CENTER
      oDrg:groups := 'OtabPage5_text'
    DRGEND INTO drgFC

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start    '         ;
                  EVENT 'installKL' SIZE 13,1.1 POS 64, 13.5 ;
                  ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3
  DRGEND INTO drgFC
*
*
** 6 volba cílové složky RUNTIME - Instalace / reInstalace
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Instalace knihoven' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Kam mají být KNIHOVNY Asystem++ nainstalovány ?' CPOS 2,1.2   BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Zvolte složku, do které mají být KNIHOVNY Asystem++ nainstalovány, a klepnìte Další.' CPOS 2,3.5 BGND 1 CLEN 70

    * dir_DATA
    DRGGET  M->VtabPage6_rootDirDLL INTO drgFC FPOS 3,4.7 FLEN 73 POST 'postValidate'
    oDrg:push := 'rootDirDLL'

    DRGMLE M->VtabPage2_mle INTO drgFC FPOS 3,6 SIZE 73.9,5.7 SCROLL 'NY'  // PP 2

    DRGSTATIC INTO drgFC FPOS 3,11.8 SIZE 73.9, 0.82
      oDrg:groups := 'OtabPage6_therm'
    DRGEND INTO drgFC

    DRGSTATIC INTO drgFC FPOS 3,13.1 SIZE 60, 0.8
      oDrg:ctype  := XBPSTATIC_TEXT_CENTER
      oDrg:groups := 'OtabPage6_text'
    DRGEND INTO drgFC

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start    '          ;
                  EVENT 'installDLL' SIZE 13,1.1 POS 64, 13.5 ;
                  ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3
  DRGEND INTO drgFC


  DRGPUSHBUTTON INTO drgFC CAPTION '< Zpìt '                     ;
                EVENT 'prevButtonClick' SIZE 13,1.1 POS 36, 15.5 ;
                ICON1 119 ICON2 0 ATYPE 3

  DRGPUSHBUTTON INTO drgFC CAPTION ' Další >'                     ;
                EVENT 'nextButtonClick' SIZE 13,1.1 POS 50, 15.5 ;
                ICON1 118 ICON2 0 ATYPE 3

  DRGPUSHBUTTON INTO drgFC CAPTION '  ~Storno'                    ;
                EVENT drgEVENT_QUIT     SIZE 13,1.1 POS 64, 15.5 ;
                ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC


method AsystemLogin:drgDialogInit(drgDialog)
**  drgDialog:dialog:AlwaysOnTop := .T.
return self


method AsystemLogin:drgDialogStart(drgDialog)
  local  drgPush, drgMle, drgStatic
  local  members := drgDialog:oForm:aMembers
  *
  ::dm        := drgDialog:dataManager
  ::dc        := drgDialog:dialogCtrl
  ::df        := drgDialog:oForm

  ::othread   := Thread():new()

  for x := 1 to len(members) step 1
    do case
    case ( members[x]:ClassName() = 'drgPushButton' )
      if isCharacter( members[x]:event )
        do case
        case ( members[x]:event = 'prevButtonClick' ) ; ::pb_prevButtonClick := members[x]
        case ( members[x]:event = 'nextButtonClick' ) ; ::pb_nextButtonClick := members[x]
        case ( members[x]:event = 'installDB'       ) ; ::pb_installDB       := members[x]
        case ( members[x]:event = 'installKL'       ) ; ::pb_installKL       := members[x]
        case ( members[x]:event = 'installDLL'      ) ; ::pb_installDLL      := members[x]
        endcase
      elseif isNumber( members[x]:event )
        if members[x]:event = drgEVENT_QUIT
          ::pb_stopButtonClick := members[x]
        endif
      endif

    case ( members[x]:ClassName() = 'drgMle'        )
      drgMle := members[x]

      drgMle:oxbp:editable := .f.
      drgMle:isEdit        := .f.

      if drgMle:groups = 'M'
        drgMle:oxbp:setFontCompoundName("11.Arial Bold Italic")
      else
        drgMle:oXbp:setColorBG( graMakeRGBColor( {220, 220, 250} ))
      endif

    case ( members[x]:ClassName() = 'drgStatic'     )
      do case
      case ( members[x]:groups = 'OtabPage4_therm' ) ; ::OtabPage4_therm := members[x]
      case ( members[x]:groups = 'OtabPage4_text'  ) ; ::OtabPage4_text  := members[x]

      case ( members[x]:groups = 'OtabPage5_therm' ) ; ::OtabPage5_therm := members[x]
      case ( members[x]:groups = 'OtabPage5_text'  ) ; ::OtabPage5_text  := members[x]

      case ( members[x]:groups = 'OtabPage6_therm' ) ; ::OtabPage6_therm := members[x]
      case ( members[x]:groups = 'OtabPage6_text'  ) ; ::OtabPage6_text  := members[x]
      endcase

    endcase
  next

  ::OtabPage4_broLicasys := ::dc:oBrowse[1]
  ::pb_prevButtonClick:oxbp:hide()
  *
**  ( ::pb_installDB:disable(), ::pb_installDB:oText:disable() )
RETURN self


method AsystemLogin:getLicasys()
  local cval      := ::VtabPage3_rButton
  local csel_Mask := 'licasys' +if( cval = 'D', '___9999', ;
                                if( cval = 'I', '_*'     , '' ))
  local in_Dir, oXbp := ::dm:has('M->VtabPage3_getLicasys'):oDrg:oXbp
  local cc

  in_Dir := selFILE( csel_Mask                           , ;
                    'ADT'                                , ;
                                                         , ;
                    'Vyberte prosim licencní soubor ...' , ;
                    {{"Licencni soubory (*.ADT)", csel_Mask +'.ADT'}}, .t., .f., .f.)

  if .not. empty(in_Dir)
    ::VtabPage3_getLicasys := in_Dir
    ::dm:set( 'M->VtabPage3_getLicasys', ::VtabPage3_getLicasys )

    * pøednastvíme cílovou složku DB a cílovou složku KLIENTA
    * pro D_emo / I_nstalace je default C:\Asystem++
    if cval = 'R'
      cc := subStr( in_Dir, 1, rat( '\', in_Dir) -1 )
      cc := subStr( cc    , 1, rat( '\', cc    ) -1 )
    else
      cc := 'C:\Asystem++'
    endif

    ::VtabPage4_rootDirDB := cc
    ::dm:set( 'M->VtabPage4_rootDirDB', ::VtabPage4_rootDirDB )
    ::postValidate( ::dm:has( 'M->VtabPage4_rootDirDB' ) )

    ::VtabPage5_rootDirKL := cc
    ::dm:set( 'M->VtabPage5_rootDirKL', ::VtabPage5_rootDirKL )
  endif

  if .not. empty(in_Dir)
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp)
    PostAppEvent(xbeBRW_ItemMarked,,,::OtabPage4_broLicasys:oxbp)
  endif
return .t.


method AsystemLogin:rootDirDB()
  local  oXbp    := ::dm:has('M->VtabPage4_rootDirDB'):oDrg:oXbp
  local  in_Dir, cc := 'Kam má být DB Asystem++ nainstalována ?'
  *
  local  old_Dir := ::VtabPage4_rootDirDB

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )

  if .not. empty(in_Dir)
    ::VtabPage4_rootDirDB := in_Dir +'\'
    ::dm:set( 'M->VtabPage4_rootDirDB', ::VtabPage4_rootDirDB )
  endif

/*
Start verze - instalace produktu
M->VtabPage3_rButton = 'S'
  - založit adresáøe Binn , Data , System , System\Resource , Users
  - M->VtabPage4_rootDirDB +'System\'   ... tam se musí nakopírovat dirtibuèní licasys.adt

Aktualizace již existující instalace
M->VtabPage3_rButton = 'A'
  - M->VtabPage4_rootDirDB +Bin\        ... tam musí býy Asystem++.ini
  - M->VtabPage4_rootDirDB +'System\'   ... tam musí být licasys.adt
*/

  if .not. empty(in_Dir)
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp)

    * zmìnil umístìní DB
    if upper( allTrim(in_Dir)) <> upper( allTrim( old_Dir))
      if Select('licasys') <> 0
        licasys-> (dbcloseArea())
        licasysw->(dbZap())
        ::OtabPage4_broLicasys:oxbp:refreshAll()
      endif
    endif
  endif
return .t.


method AsystemLogin:rootDirKL()
  local  oXbp   := ::dm:has('M->VtabPage5_rootDirKL'):oDrg:oXbp
  local  in_Dir, cc := 'Kam má být KLIENT Asystem++ nainstalován ?'

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )

  if .not. empty(in_Dir)
    ::VtabPage5_rootDirKL := in_Dir
    ::dm:set( 'M->VtabPage5_rootDirKL', ::VtabPage5_rootDirKL )
  endif

  if( .not. empty(in_Dir), PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp), nil )
return .t.


method AsystemLogin:rootDirDLL()
  local  oXbp   := ::dm:has('M->VtabPage6_rootDirDLL'):oDrg:oXbp
  local  in_Dir, cc := 'Kam mají být KNIHOVNY Asystem++ nainstalovány ?'

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )

  if .not. empty(in_Dir)
    ::VtabPage6_rootDirDLL := in_Dir
    ::dm:set( 'M->VtabPage6_rootDirDLL', ::VtabPage6_rootDirDLL )
  endif

  if( .not. empty(in_Dir), PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp), nil )
return .t.



method AsystemLogin:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := drgVar:name
  local  lOk    := .t., changed := drgVar:changed()
  *
  local  odrg
  local  cdataADD, phConnect, lis_ok, cc, tablePath


  do case
  case ( name = 'M->VtabPage3_getLicasys')
    if ::VtabPage3_chBox1 .or. ::VtabPage3_chBox2 .or. ::VtabPage3_chBox3
      ::pb_nextButtonClick:enable()

    endif

    if Select('licasys') <> 0
      licasys-> (dbcloseArea())
      licasysw->(dbZap())
      ::OtabPage4_broLicasys:oxbp:refreshAll()

      _clearEventLoop(.t.)
    endif

  case ( name = 'M->VtabPage4_rootDirDB' )
    lOk := .not. empty( value )

    do case
    case ::VtabPage3_rButton = 'I'
    case ::VtabPage3_rButton = 'R'
*      lOk := lOk .and. file( ::VtabPage4_rootDirDB +'Binn\Asystem++.ini'  )
*      lOk := lOk .and. file( ::VtabPage4_rootDirDB +'System\licasys.adt' )
    endcase


    if lOk  .and. ( Select('licasys') = 0 )
      dbUseArea(.t., oSession_free, ::VtabPage3_getLicasys, 'licasys', .t.)
      licasys->( AX_SetPass(syApa))

      do while .not. licasys->(eof())
              cc := if( right( ::VtabPage4_rootDirDB,1) = '\', '', '\' )

        cdataADD := ::VtabPage4_rootDirDB +cc                    + ;
                    'Data\'                                      + ;
                    allTrim(licasys->cdataDir)                   + ;
                    '\Data\'                                     + ;
                    'A++_' +strZero(licasys->nusrIdDB,6) +'.add'

**        drgDump(cdataADD)

        lis_Ok := if( ::VtabPage3_rButton = 'R', file ( cdataADD ), .not. file ( cdataADD ) )

        if lis_Ok
          setup_copy_from_to('licasys', 'licasysw', .t.)
          *
          licasysw->phConnect  := 0
          licasysw->cversionDB := ''

          cdataADD := ::VtabPage4_rootDirDB +cc   + ;
                      'Data\'                     + ;
                      allTrim(licasysw->cdataDir) + ;
                      '\Data\'                    + ;
                      'A++_' +strZero(licasysw->nusrIdDB,6) +'.add'

          if file ( cdataADD )
            phConnect := AdsConnect60( cdataADD, 1 )
            verMajor  := AdsDDGetDatabaseProperty( phConnect, ADS_DD_VERSION_MAJOR, 0, 2 )
            verMinor  := AdsDDGetDatabaseProperty( phConnect, ADS_DD_VERSION_MINOR, 0, 2 )

            licasysw->phConnect  := phConnect
            licasysw->cversionDB := strTran( str(verMajor) +'.' +str(verMinor), ' ', '')

            tablePath := space(512)
            AdsDDGetDatabaseProperty( phConnect,ADS_DD_DEFAULT_TABLE_PATH, @tablePath, 512 )

            licasysw->tablePath  := strTran( tablePath, chr(0), '' )

            licasysw->nmajor_ADD := verMajor
            licasysw->nminor_ADD := verMinor

            AdsDisconnect( phConnect )
          endif
        endif

        licasys->(dbskip())
      enddo

      licasysw->(dbgotop())
      ::OtabPage4_broLicasys:oxbp:refreshAll()

      _clearEventLoop( .t. )
    endif
  endcase
return lOk


METHOD AsystemLogin:destroy()
  ::drgUsrClass:destroy()

  ::klient             := ;
  ::tabNum             := ;
  ::dm                 := ;
  ::dc                 := ;
  ::df                 := ;
  ::othread            := ;
  ::pb_prevButtonClick := ;
  ::pb_nextButtonClick := ;
  ::pb_installDB       := ;
  ::abitMaps           := nil

  drgServiceThread:setActiveThread(0)
RETURN NIL

*
** pro reinstalaci zavedana konvence
** na datové promìnné xxxxxx_USER se distribuènì nikdy nepøepisuje
static function mh_copyFld_no_user(cDBFrom,cDBTo, lDBApp, IsMain, aLock, Uniq)
  Local  nPOs, nUni, azamky, xVal, cItem
  Local  aFrom := (cDBFrom) ->( dbStruct())
  *
  local  x, a_noCpy := {'cuniqidrec', 'muserzmenr', 'sid' }

  Default lDBApp To .F., IsMain TO .F., Uniq  TO .T.

  if ldbapp
    if .not. (cdbto)->(DbLocked())
      azamky := (cdbto)->(DbRLockList())

      (cdbto)->(DbAppend())
      aadd(azamky, (cdbto)->(recno()))
      (cdbto)->(sx_rlock(azamky))
    else
      (cdbto)->(DbAppend())
    endif
  endif

  for x := 1 to len(aFrom) step 1
    cItem := aFrom[x,DBS_NAME]

    if( AScan(a_noCpy,lower(cItem)) = 0 .and. at( '_user', lower(cItem)) = 0 )
      if(nPos := (cDBTo)->( FieldPos( aFrom[x,DBS_NAME]))) <> 0
        if .not. isNull(xVal := (cDBFrom) ->( FieldGet(x)))
          (cDBTo) ->( FieldPut( nPos, xVal))
        endif
      endif
    endif
  next
  *
  ** zavedena konvence u TMP položka _nrecor pro zámky pøi ukládání //
  IF IsMain .and. (nPOs := (cDBTo) ->(FieldPos('_nrecor'))) <> 0 .and. !(cDBFrom) ->(EOF())
    (cDBTo) ->(FieldPut(nPOs, (cDBFrom) ->(RecNo())))
    IF(IsARRAY(aLock), AAdd(aLock,(cDBFrom) ->(RecNo())),NIL)
  ENDIF
  *
  ** zavenena konvence u TMP položka _nsidor - vazba na sID u základního souboru
  if ( npos := (cDBTo)->( FieldPos( '_nsidor'))) <> 0 .and. !(cDBFrom) ->(EOF())
    if (cDBFrom)->( FieldPos( 'sid' )) <> 0
      (cDBTo) ->( FieldPut( npos, (cDBFrom)->sID ))
    endif
  endif

  mh_WRTzmena( cDBTo, lDBApp)
Return( Nil)

*
**
static function setup_copy_from_to(cDBfrom, cDBto, lDBappend)
  local aFrom := ( cDBFrom) ->( dbStruct())

  default lDBappend to .f.

  if( lDBappend, (cDBto)->(dbAppend()), nil )

  aEval( aFrom, { |X,M| ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                          nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                          If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )
return nil


procedure setup_work_animate(xbp_therm,abitMaps, xbp_text,cinfoText)
  local  aRect, oPS, nXD, nYD

  xbp_therm:setCaption('')

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  nXD     := abitMaps[2]
  nYD     := 1

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


function setup_work_textinfo(oXbp,ctext)
  local  oPS, oFont, aAttr, nSize := oxbp:currentSize()[1]

  oXbp:setCaption( '' )

  if .not. empty(oPS := oXbp:lockPS())
    oFont := XbpFont():new():create( "8.Arial CE" )
    aAttr := ARRAY( GRA_AS_COUNT )

    GraSetFont( oPS, oFont )

    aAttr [ GRA_AS_COLOR     ] := GRA_CLR_BLUE
    GraSetAttrString( oPS, aAttr )

    GraStringAt( oPS, {20, 5}, ctext)

    oXbp:unlockPS(oPS)
  endif
return .t.