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

#include "Asystem++.ch"
#include "ASYSTEM++_setup"

#include "ace.ch"



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
      ( ::pb_nextButtonClick:enable() , ::pb_nextButtonClick:oText:enable()  ), ;
      ( ::pb_nextButtonClick:disable(), ::pb_nextButtonClick:oText:disable() )  )
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
      ( ::pb_nextButtonClick:enable() , ::pb_nextButtonClick:oText:enable()  ), ;
      ( ::pb_nextButtonClick:disable(), ::pb_nextButtonClick:oText:disable() )  )
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
    local  oXbp_text  := ::OtabPage4_text:oXbp, cc
    *
    local  cdirADD    := ::VtabPage4_rootDirDB       + ;
                         'Data\'                     + ;
                         allTrim(licasysw->cdataDir) + ;
                         '\Data\'
    local  cfileADD   := 'A++_' +strZero(licasysw->nusrIdDB,6) +'.add'


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


    cConnect      := "DBE=ADSDBE;SERVER=" +cdirADD +cfileADD +";UID=ADSSYS"
    oSession_data := dacSession():New(cConnect)

    * check if we are connected to the ADS data-server
    if .not. ( oSession_data:isConnected() )
      drgMsgBox(drgNLS:msg('Nelze se pøipojit na >DATOVÝ<  server ADS !!!'))
    else

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

      * vrátíme to
      ::othread:setInterval( NIL )
      ::othread:synchronize( 0 )

      oXbp_therm:configure()
      oXbp_text:configure()
    endif
  return .t.
  *
  *
  ** 5  volba cílové složky KLIENTA - Instalace/ reInstalace
  var VtabPage5_rootDirKL

  inline method installKL()
    local  cbinn_Azf   := curDir() + '\' +'A++_Binn.azf'
    local  cbinn_Dir   := ::VtabPage5_rootDirKL +'Binn'
    *
    local  csystem_Azf := curDir() + '\' +'A++_System.azf'
    local  csystem_Dir := ::VtabPage5_rootDirKL +'System'
    local  ozip

    * klient
    if file( cbinn_Azf ) .and. file( ::VtabPage5_rootDirKL, 'D' )
      createDir(cbinn_Dir)

      ozip := XbZLibZip():New( cbinn_Azf, XBZ_OPEN_READ)
      ozip:Extract( cbinn_Dir, '*.*', .t., XBZ_OVERWRITE_ALL )
      ozip:close()
    endif

    * system
    if file( csystem_Azf ) .and. file( ::VtabPage5_rootDirKL, 'D' )
      createDir(csystem_Dir)

      ozip := XbZLibZip():New( csystem_Azf, XBZ_OPEN_READ)
      ozip:Extract( csystem_Dir, '*.*', .t., XBZ_OVERWRITE_ALL )
      ozip:close()
    endif
  return nil
  *
  *
  ** 6 volba cílové složky RUNTIME - Instalace / reInstalace
  var VtabPage6_rootDirDLL

  inline method installDLL()
    local  cruntime_Azf := curDir() + '\' +'A++_Runtime.azf'
    local  cruntime_Dir := ::VtabPage6_rootDirDLL
    local  ozip

    if file( cruntime_Azf ) .and. file( ::VtabPage6_rootDirDLL, 'D' )
      createDir(cruntime_Dir)

      ozip := XbZLibZip():New( cruntime_Azf, XBZ_OPEN_READ)
      ozip:Extract( cruntime_Dir, '*.*', .t., XBZ_OVERWRITE_ALL )
      ozip:close()
    endif
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
          ( ::pb_nextButtonClick:enable() , ::pb_nextButtonClick:oText:enable()  ), ;
          ( ::pb_nextButtonClick:disable(), ::pb_nextButtonClick:oText:disable() )  )

      case tabNum = 3
        if( ::VtabPage3_chBox1 .or. ::VtabPage3_chBox2 )
          ( ::pb_nextButtonClick:enable() , ::pb_nextButtonClick:oText:enable()  )
        else
          ::pb_nextButtonClick:disabled := .F.
          ( ::pb_nextButtonClick:disable(), ::pb_nextButtonClick:oText:disable() )
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
        ( ::pb_nextButtonClick:enable() , ::pb_nextButtonClick:oText:enable()  )

      case tabNum = 2
        if( ::VtabPage2_rButton = 'S', ;
          ( ::pb_nextButtonClick:enable() , ::pb_nextButtonClick:oText:enable()  ), ;
          ( ::pb_nextButtonClick:disable(), ::pb_nextButtonClick:oText:disable() )  )

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
  var     pb_prevButtonClick, pb_nextButtonClick, pb_installDB, pb_installKL, pb_installDLL
  *
  var     abitMaps


  inline method set_val( cvarName, xVal )
    local cname   := strTran( cvarName, 'M->', '' )

    self:&cname := xVal
    ::dm:set( cvarName, xVal )
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
  ::VtabPage6_rootDirDLL := ''

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
      DRGTEXT INTO drgFC CAPTION 'Instalace databáze' CPOS 1,.3 BGND 1 FONT 5
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


    DRGSTATIC INTO drgFC FPOS 3,13.1 SIZE 61, 0.8
      oDrg:ctype  := XBPSTATIC_TEXT_CENTER
      oDrg:groups := 'OtabPage4_text'
    DRGEND INTO drgFC

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start  '           ;
                  EVENT 'installDB' SIZE 12,1.1 POS 65, 13.5 ;
                  ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3

  DRGEND INTO drgFC
*
*
** 5  volba cílové složky KLIENTA - Instalace/ reInstalace
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Instalace klienta' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Kam má být KLIENT Asystem++ nainstalována ?' CPOS 2,1.2   BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Zvolte složku, do které má být KLIENT Asystem++ nainstalována, a klepnìte Další.' CPOS 2,3.5 BGND 1 CLEN 70

    * dir_DATA
    DRGGET  M->VtabPage5_rootDirKL INTO drgFC FPOS 4,4.7 FLEN 70 POST 'postValidate'
    oDrg:push := 'rootDirKL'

    DRGMLE M->VtabPage2_mle INTO drgFC FPOS 4,6 SIZE 71,5.7 SCROLL 'NY'  // PP 2

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start  '           ;
                  EVENT 'installKL' SIZE 12,1.1 POS 63, 13.5 ;
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
    DRGGET  M->VtabPage6_rootDirDLL INTO drgFC FPOS 4,4.7 FLEN 70 POST 'postValidate'
    oDrg:push := 'rootDirDLL'

    DRGMLE M->VtabPage2_mle INTO drgFC FPOS 4,6 SIZE 71,5.7 SCROLL 'NY'  // PP 2

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start  '           ;
                  EVENT 'installDLL' SIZE 12,1.1 POS 63, 13.5 ;
                  ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3
  DRGEND INTO drgFC


  DRGPUSHBUTTON INTO drgFC CAPTION '< Zpìt '                     ;
                EVENT 'prevButtonClick' SIZE 12,1.1 POS 39, 15.5 ;
                ICON1 119 ICON2 0 ATYPE 3

  DRGPUSHBUTTON INTO drgFC CAPTION 'Další >'                     ;
                EVENT 'nextButtonClick' SIZE 12,1.1 POS 52, 15.5 ;
                ICON1 118 ICON2 0 ATYPE 3

  DRGPUSHBUTTON INTO drgFC CAPTION ' ~Storno'                    ;
                EVENT drgEVENT_QUIT     SIZE 12,1.1 POS 65, 15.5 ;
                ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC


method AsystemLogin:drgDialogInit(drgDialog)
**  drgDialog:dialog:AlwaysOnTop := .T.
return self


method AsystemLogin:drgDialogStart(drgDialog)
  local  drgPush, drgMle, drgStatic
  local  members := drgDialog:oForm:aMembers

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

  in_Dir := selFILE( csel_Mask                           , ;
                    'ADT'                                , ;
                                                         , ;
                    'Vyberte prosim licencní soubor ...' , ;
                    {{"Licencni soubory (*.ADT)", csel_Mask +'.ADT'}}, ,.t., .f.)

  if .not. empty(in_Dir)
    ::VtabPage3_getLicasys := in_Dir
    ::dm:set( 'M->VtabPage3_getLicasys', ::VtabPage3_getLicasys )
  endif

  if( .not. empty(in_Dir), PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp), nil )
return .t.


method AsystemLogin:rootDirDB()
  local in_Dir := selFILE( 'Asysytem++_DB', , , , , .t., , .f. )
  local oXbp   := ::dm:has('M->VtabPage4_rootDirDB'):oDrg:oXbp

  if .not. empty(in_Dir)
    ::VtabPage4_rootDirDB := strTran( in_Dir, 'Asysytem++_DB.', '' )
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

  if( .not. empty(in_Dir), PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp), nil )
return .t.


method AsystemLogin:rootDirKL()
  local in_Dir := selFILE( 'Asysytem++_KL', , , , , .t., , .f. )
  local oXbp   := ::dm:has('M->VtabPage5_rootDirKL'):oDrg:oXbp

  if .not. empty(in_Dir)
    ::VtabPage5_rootDirKL := strTran( in_Dir, 'Asysytem++_KL.', '' )
    ::dm:set( 'M->VtabPage5_rootDirKL', ::VtabPage5_rootDirKL )
  endif

  if( .not. empty(in_Dir), PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp), nil )
return .t.


method AsystemLogin:rootDirDLL()
  local in_Dir := selFILE( 'Asysytem++_DLL', , , , , .t., , .f. )
  local oXbp   := ::dm:has('M->VtabPage6_rootDirDLL'):oDrg:oXbp

  if .not. empty(in_Dir)
    ::VtabPage6_rootDirDLL := strTran( in_Dir, 'Asysytem++_DLL.', '' )
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
  local  cdataADD, phConnect, lis_ok


  do case
  case ( name = 'M->VtabPage4_rootDirDB' )
    lOk := .not. empty( value )

    do case
    case ::VtabPage3_rButton = 'I'
    case ::VtabPage3_rButton = 'R'
*      lOk := lOk .and. file( ::VtabPage4_rootDirDB +'Binn\Asystem++.ini'  )
*      lOk := lOk .and. file( ::VtabPage4_rootDirDB +'System\licasys.adt' )
    endcase


    if lOk .and. ( Select('licasys') = 0 )
      dbUseArea(.t., oSession_free, ::VtabPage3_getLicasys, 'licasys', .t.)
      licasys->( AX_SetPass(syApa))

      do while .not. licasys->(eof())

        cdataADD := ::VtabPage4_rootDirDB       + ;
                    'Data\'                     + ;
                    allTrim(licasys->cdataDir)  + ;
                    '\Data\'                    + ;
                    'A++_' +strZero(licasys->nusrIdDB,6) +'.add'

        lis_Ok := if( ::VtabPage3_rButton = 'R', file ( cdataADD ), .not. file ( cdataADD ) )

        if lis_Ok
          setup_copy_from_to('licasys', 'licasysw', .t.)
          *
          licasysw->phConnect  := 0
          licasysw->cversionDB := ''

          cdataADD := ::VtabPage4_rootDirDB       + ;
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

            AdsDisconnect( phConnect )
          endif
        endif

        licasys->(dbskip())
      enddo

      licasysw->(dbgotop())
      ::OtabPage4_broLicasys:oxbp:refreshAll()

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
RETURN NIL


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