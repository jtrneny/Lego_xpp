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

#include "Asystem++.ch"
#include "Asystem++_distrib.ch"

#include "..\A_main\ace.ch"


CLASS AsystemLogin FROM drgUsrClass
EXPORTED:
  VAR     usrPswd
  VAR     usrPgm
  VAR     isUSERs
  VAR     klient

  METHOD  init
  METHOD  getForm
  METHOD  drgDialogInit, drgDialogStart
  METHOD  postValidate
  METHOD  destroy

  method  rootDirDB
  *
  * 1
  * z�kladn� okno  - prom�nn�
  inline access assign method VtabPage1_mle1() var VtabPage1_mle1
    return tabPage_1_mle1


  inline access assign method VtabPage1_mle2() var VtabPage1_mle2
    return tabPage_1_mle2
  *
  * 2
  * licen�n� ujedn�n�
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
  var VtabPage3_rButton, VtabPage3_chBox1, VtabPage3_chBox2

  inline method MtabPage3_rButton(oXbp)
    local  members := oXbp:cargo:members, npos
    local  isSet   := .f.

    aeval( members, { |o| if( o:getData(), isSet := .t., nil ) } )
    if( .not. isSet, oXbp:setData(.t.), nil )

    npos := ascan( members, oxbp)

    if( oXbp:getData(), ::VtabPage3_rButton := oxbp:cargo:values[npos,1], nil )
  return self

  inline method MtabPage3_chBox( oxbp )
    do case
    case oXbp:cargo:name = 'M->VtabPage3_chBox1' ; ::VtabPage3_chBox1 := oXbp:getData()
    case oXbp:cargo:name = 'M->VtabPage3_chBox2' ; ::VtabPage3_chBox2 := oXbp:getData()
    endcase

    if( ::VtabPage3_chBox1 .or. ::VtabPage3_chBox2, ;
      ( ::pb_nextButtonClick:enable() , ::pb_nextButtonClick:oText:enable()  ), ;
      ( ::pb_nextButtonClick:disable(), ::pb_nextButtonClick:oText:disable() )  )
  return self
  *
  *
  ** 4   volba c�lov� slo�ky DB - Intalace/ reInstalace
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
    local  oThread
    local  oXbp_therm := ::OtabPage4_therm:oXbp
    local  oXbp_text  := ::OtabPage4_text:oXbp, cc
    *
    local  cdirADD    := ::VtabPage4_rootDirDB       + ;
                         'Data\'                     + ;
                         allTrim(licasysw->cdataDir) + ;
                         '\Data\'
    local  cfileADD   := 'A++_' +strZero(licasysw->nusrIdDB,6) +'.add'


    * instalace nov� DB, pak u� je to stejn�
    if ::VtabPage3_rButton = 'S' .and. licasysw->phConnect = 0
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
      drgMsgBox(drgNLS:msg('Nelze se p�ipojit na >DATOV�<  server ADS !!!'))

    else

      oThread := Thread():new()
      oThread:setInterval( 20 )
      oThread:start( "setup_work_animate", oXbp_therm,::abitMaps )

      cc := if( ::VtabPage3_rButton = 'S', 'Instalace DB_ ', 'ReInstalace DB_ ')
      cc += strZero(licasysw->nusrIdDB,6) +' ,' +left(licasysw->cnazFirmy, 40)
      setup_work_textinfo(oXbp_text, cc )

      get_system_data()
      check_dbd_data( oXbp_text )

      * konec Instalace / ReInstalace DB
      s_tables  ->( dbCloseArea())
      s_columns ->( dbCloseArea())
      s_indexes ->( dbCloseArea())

      * vr�t�me to
      oThread:setInterval( NIL )
      oThread:synchronize( 0 )
      oThread := nil

      oXbp_therm:configure()
      oXbp_text:configure()
    endif
  return .t.
  *
  *
  ** 5  volba c�lov� slo�ky KLIENTA - Instalace/ reInstalace
  var VtabPage5_rootDirKL


  inline method nextButtonClick()
    local  tabNum   := ::tabNum +1
    local  oLastDrg := ::df:oLastDrg, postBlock

    if tabNum <= 5
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


    if isobject(::opsw)
      if ::opsw:odrg:oXbp:xbpSle:changed
        new_val := alltrim(::opsw:odrg:oXbp:xbpSle:getdata())
        ::opsw:set(new_val)
      endif
    endif
    return .f.

hidden:
  var     opsw
  var     tabNum
  var     dm, dc, df
  var     pb_prevButtonClick, pb_nextButtonClick, pb_installDB
  *
  var     abitMaps

ENDCLASS


METHOD AsystemLogin:init(parent)
  local  x, nPHASe := MIS_PHASE1  // MIS_WORM_PHASE1

  ::drgUsrClass:init(parent)

//  ::VtabPage2_rButton   := 'N'
  *
//  ::VtabPage3_rButton   := 'S'
//  ::VtabPage3_chBox1    := .F.
//  ::VtabPage3_chBox2    := .F.
  *
//  ::VtabPage4_rootDirDB := ''
  *
//  ::VtabPage5_rootDirKL := ''

  *
  ** nachyst�me si �erv�ka v pro samostatn� vl�kno
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


  DRGFORM INTO drgFC SIZE 80,17 DTYPE '10' TITLE 'Sestaven� distribu�n� verze - Asystem++' ;
                                           POST  'postValidate'                   ;
                                           GUILOOK 'ALL:Y BORDER:Y ACTION:Y'

/*

*
* 1
* z�kladn� okno
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC CAPTION '2' FPOS 0,1 SIZE 150,200 STYPE XBPSTATIC_TYPE_BITMAP

    DRGMLE M->VtabPage1_mle1  INTO drgFC FPOS 22, 0 SIZE 58, 4 SCROLL 'N'
    oDRG:groups := 'M'

    DRGMLE M->VtabPage1_mle2  INTO drgFC FPOS 22, 4 SIZE 58, 10.8 SCROLL 'N'

    DRGPUSHBUTTON INTO drgFC CAPTION '' EVENT '' SIZE 0,0 POS 0,0
  DRGEND INTO drgFC
*
* 2
* licen�n� ujedn�n�
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Licen�n� ujed�n�' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Pros�m p�e�t�t si tyto d�le�it� informace p�edt�m, ne� budete' CPOS 2,1.2 BGND 1
      DRGTEXT INTO drgFC CAPTION 'pokra�ovat.' CPOS 2,2 BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Pros�m p�e�t�t si toto Licen�n� ujedn�n�. Mus�te souhlasit s podm�nkami' CPOS 2,3.5 BGND 1
    DRGTEXT INTO drgFC CAPTION 'tohoto ujedn�n�, aby mohl instala�n� proces pokra�ovat.' CPOS 2,4.3 BGND 1

    DRGMLE M->VtabPage2_mle INTO drgFC FPOS 2,5.5 SIZE 76,6 SCROLL 'NY'

    DRGRADIOBUTTON M->VtabPage2_rButton INTO drgFC FPOS 2,12 SIZE 40,3 PP 2 ;
                   POST   'postValidate'                                        ;
                   VALUES 'S:Souhlas�m s podm�nkamo Licen�n�ho ujedn�n�,'     + ;
                          'N:Nesouhlas�m s podm�nkami Licen�n�ho ujedn�n�'

  DRGEND INTO drgFC
*
* 3
* typ instalce
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0

    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Typ instalace' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Jakou instalaci chcete prov�st ?'            CPOS 2,1.2 BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Vyberte typ instalace produktu ' CPOS 2,3.5 BGND 1

    DRGRADIOBUTTON M->VtabPage3_rButton INTO drgFC FPOS 4,4.7 SIZE 40,3 PP 2 ;
                   VALUES 'S:Start verze - instalace produktu,'  + ;
                          'A:Aktualizace ji� existuj�c� instalace'

    DRGSTATIC INTO drgFC FPOS .5,4.5 SIZE 79.5,3 STYPE XBPSTATIC_TYPE_RECESSEDLINE
    oDrg:ctype := 1

    DRGTEXT INTO drgFC CAPTION 'a up�esn�te pros�m vlastn� typ instalace.' CPOS 2,8 BGND 1
    DRGCHECKBOX M->VtabPage3_chBox1 INTO drgFC FPOS  4.5,  9 FLEN 14.5 VALUES 'T:����datab�ze���>,F:����datab�ze���>'
    DRGCHECKBOX M->VtabPage3_chBox2 INTO drgFC FPOS  4.5, 10 FLEN 14.5 VALUES 'T:����klient���������>,F:����klient���������>'
  DRGEND INTO drgFC
*
*
** 4   volba c�lov� slo�ky DB - Intalace/ reInstalace
  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 80,3.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Instalace datab�ze' CPOS 1,.3 BGND 1 FONT 5
      DRGTEXT INTO drgFC CAPTION 'Kam m� b�t DB Asystem++ nainstalov�na ?' CPOS 2,1.2   BGND 1
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Zvolte slo�ku, do kter� m� b�t DB Asystem++ nainstalov�na, a klepn�te Dal��.' CPOS 2,3.5 BGND 1 CLEN 70

    * dir_DATA
    DRGGET     M->VtabPage4_rootDirDB INTO drgFC FPOS 3,4.7 FLEN 73 POST 'postValidate'
    oDrg:push := 'rootDirDB'

    DRGDBROWSE INTO drgFC FPOS 3,6 SIZE 73.9, 5.7 FILE 'licasysw' ;
      FIELDS 'M->is_existDB::2.6::2,'     + ;
             'M->is_colSep:�:0.1::2,'     + ;
             'nusrIDDB:DB:6,'             + ;
             'cnazFirPri:N�zev firmy:30,' + ;
             'cversionDB:verzeDB:10,'     + ;
             'cico:i�o,'                  + ;
             'cdic:di�'                     ;
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
*/
*
*
** 5  volba c�lov� slo�ky KLIENTA - Instalace/ reInstalace
//  DRGTABPAGE INTO drgFC CAPTION '' FPOS 0,0 SIZE 80,15  OFFSET 1,82 TABHEIGHT 0
    DRGSTATIC INTO drgFC FPOS 0.5,0 SIZE 79.0,15.1 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 'Sestaven� distribu�n� verze' CPOS 1,.3 BGND 1 FONT 5
//      DRGTEXT INTO drgFC CAPTION 'Kam m� b�t KLIENT Asystem++ nainstalov�na ?' CPOS 2,1.2   BGND 1
//    DRGEND INTO drgFC

//    DRGTEXT INTO drgFC CAPTION 'Zvolte slo�ku, do kter� m� b�t KLIENT Asystem++ nainstalov�na, a klepn�te Dal��.' CPOS 2,3.5 BGND 1 CLEN 70

    * dir_DATA
//    DRGGET  M->VtabPage5_rootDirKL INTO drgFC FPOS 4,4.7 FLEN 70 POST 'postValidate'
//    oDrg:push := 'in_Dir'

//    DRGMLE M->VtabPage2_mle INTO drgFC FPOS 4,6 SIZE 71,5.7 SCROLL 'NY'  // PP 2
  DRGEND INTO drgFC


  DRGPUSHBUTTON INTO drgFC CAPTION 'Start >'                     ;
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

  for x := 1 to len(members) step 1
    do case
    case ( members[x]:ClassName() = 'drgPushButton' )
      if isCharacter( members[x]:event )
        do case
        case ( members[x]:event = 'prevButtonClick' ) ; ::pb_prevButtonClick := members[x]
        case ( members[x]:event = 'nextButtonClick' ) ; ::pb_nextButtonClick := members[x]
        case ( members[x]:event = 'installDB'       ) ; ::pb_installDB       := members[x]
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

//  ::OtabPage4_broLicasys := ::dc:oBrowse[1]
  ::pb_prevButtonClick:oxbp:hide()
  *
**  ( ::pb_installDB:disable(), ::pb_installDB:oText:disable() )
RETURN self


method AsystemLogin:rootDirDB()
  local in_Dir := selFILE( 'Asysytem++_DB', , , , , .t. )
  local oXbp   := ::dm:has('M->VtabPage4_rootDirDB'):oDrg:oXbp

  if .not. empty(in_Dir)
    ::VtabPage4_rootDirDB := strTran( in_Dir, 'Asysytem++_DB.', '' )
    ::dm:set( 'M->VtabPage4_rootDirDB', ::VtabPage4_rootDirDB )
  endif

/*
Start verze - instalace produktu
M->VtabPage3_rButton = 'S'
  - zalo�it adres��e Binn , Data , System , System\Resource , Users
  - M->VtabPage4_rootDirDB +'System\'   ... tam se mus� nakop�rovat dirtibu�n� licasys.adt

Aktualizace ji� existuj�c� instalace
M->VtabPage3_rButton = 'A'
  - M->VtabPage4_rootDirDB +Bin\        ... tam mus� b�y Asystem++.ini
  - M->VtabPage4_rootDirDB +'System\'   ... tam mus� b�t licasys.adt
*/

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
    case ::VtabPage3_rButton = 'S'
    case ::VtabPage3_rButton = 'A'
      lOk := lOk .and. file( ::VtabPage4_rootDirDB +'Binn\Asystem++.ini'  )
      lOk := lOk .and. file( ::VtabPage4_rootDirDB +'System\licasys.adt' )
    endcase


    if lOk .and. ( Select('licasys') = 0 )
      dbUseArea(.t., oSession_free, ::VtabPage4_rootDirDB +'System\licasys.adt',, .T.)
      licasys->( AX_SetPass(syApa))

      do while .not. licasys->(eof())

        cdataADD := ::VtabPage4_rootDirDB       + ;
                    'Data\'                     + ;
                    allTrim(licasys->cdataDir)  + ;
                    '\Data\'                    + ;
                    'A++_' +strZero(licasys->nusrIdDB,6) +'.add'

        lis_Ok := if( ::VtabPage3_rButton = 'S', .not. file ( cdataADD ), file ( cdataADD ) )

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
  ::usrPswd  := ;
  ::usrPgm   := ;
  NIL
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