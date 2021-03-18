#include "Common.ch"
#include "dll.ch"
#include "drg.ch"
#include "xbp.ch"
#include "gra.ch"
#include "ads.ch"
#include "foxdbe.ch"
#include "adsdbe.ch"
#include "Appevent.ch"
#include "simpleio.ch"

#include "Font.ch"

#include "service.ch"


#define VALID_DATE   '20100331'
#define xbeP_Eval    xbeP_User + 1

// #define CRLF         Chr(13) + Chr(10)


**************************************************************************
* Here is where everything starts. Every XBase++ has to have one (and one only) \
* Main procedure defined. Main procedure is the program entry point.
**************************************************************************
PROCEDURE Main()
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
  *
  LOCAL   menuDialog, oDialog, oDlg
  LOCAL   cSaveFile, ar[10]
  local   cConnect
  *
  public  oSession_free, oSession_data


  oDlg := XbpDialog():new( AppDesktop(), , {10, 10}, {10, 10},,.F.)
  oDlg:taskList := .F.
  oDlg:create()


  *
  drgReadINI('Asystem++.ini')
  *
  drgLog    := drgLog():new()
  drgScrPos := drgScrPos():new()

  dclDefaultInitVars()

  drgRef := drgRef():new()
  *
  * Uncomment for (eg. Slovenian) localized DRG messages. Original DRG messages are all english (EN).
  drgINI:nlsDRGLoc := 'CZ'

  * Uncomment for multilingual user application written in English.
  drgINI:nlsAPPorg := 'CZ'
  drgINI:nlsAPPLoc := 'CZ'
  drgNLS    := drgNLS():new()
  drgNLS:readMsgFile('drgMSG',.T.)
  drgNLS:readMSGFile('appMSG',.F.)

  * connect to the ADS free-server                drgINI:dir_DATA
  cConnect      := "DBE=ADSDBE;SERVER="  +AllTrim(drgINI:dir_USER) +";ADS_LOCAL_SERVER"
  oSession_free := dacSession():New( cConnect)

  * check if we are connected to the ADS free-server
  if .not. ( oSession_free:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na >FREE< server ADS !!!'))
    QUIT
  endif

  * connect to the ADS data-server
  cConnect      := "DBE=ADSDBE;SERVER=" +drgINI:dir_DATAroot +drgINI:add_FILE +";UID=ADSSYS"
  oSession_data := dacSession():New(cConnect)

  * check if we are connected to the ADS data-server
  if .not. ( oSession_data:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na >DATOVÝ<  server ADS !!!'))
    QUIT
  endif

//  DRGDIALOG FORM 'AsystemLogin' PARENT oDlg EXITSTATE nExit MODAL DESTROY
//  QUIT

***************************
   ncnt     := 0

   oParent  := AppDesktop()
   aPos     := {483,314}
   aSize    := {600,400}
   lVisible := .F.
   *
   aPP      := {}
   AAdd ( aPP, { XBP_PP_COMPOUNDNAME, "8.Arial" } )

   oDlg := XbpDialog():new( oParent, , aPos, aSize, aPP, lVisible)
   oDlg:taskList := .f.
   oDlg:title    := 'Reinstalace A++ '
   oDlg:create()

   oMle := XbpMLE():new( oDlg:drawingArea, , {28,28}, {540,312}, { { XBP_PP_BGCLR, XBPSYSCLR_ENTRYFIELD } } )
   oMle:tabStop := .t.
   oMle:setFontCompoundName( FONT_HELV_MEDIUM )

   oMle:create()

   oDlg:show()

   SetAppWindow( oDlg )
   SetAppFocus( oDlg )

   oThread := Thread():new()
   oThread:start( "ExecuteAnimation", oMle )

   nEvent := xbe_None
   DO WHILE nEvent <> xbeP_Close
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      oXbp:handleEvent( nEvent, mp1, mp2 )
   ENDDO
   QUIT


   // Event loop
   nEvent := 0
   DO WHILE .t.   // nEvent <> xbeP_Close
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      oXbp:HandleEvent( nEvent, mp1, mp2 )


      do case
      case( ncnt = 0 )
        cdata := 'Naètení systémových tabulek ...' + CRLF
        oMLE:setData( cdata )

        drgDBMS := drgDBMS():new()
        drgDBMS:loadDBD()
        ncnt++

      case( ncnt = 1 )
        cdata += 'Naètení ADT systémových tabulek ...' + CRLF
        oMLE:setData( cdata )

        get_system_data()
        ncnt++

      case( ncnt = 2 )
        cdata += 'Kontrola datovových souborù ...' +CRLF
        oMLE:setData( cdata )

        check_dbd_data( oMLE )
        ncnt++

      case( ncnt = 3 )
        oMLE:setData( oMLE:getData() + CRLF +'Reintalace A++ dokonèena ...' +CRLF )

        ncnt++

        Tone( 400, 9 )
        Sleep( 500 )
        QUIT

      endcase
   ENDDO
***************************
*

  oDlg := XbpDialog():new( AppDesktop(), , {10, 10}, {10, 10},,.F.)
  oDlg:taskList := .F.
  oDlg:create()

  DRGDIALOG FORM 'AsystemLogin' PARENT oDlg EXITSTATE nExit MODAL DESTROY
  QUIT
RETURN



function ExecuteAnimation( oMle )
  local cdata := 'Naètení systémových tabulek ...' + CRLF

  oMLE:setData( cdata )
  drgDBMS := drgDBMS():new()
  drgDBMS:loadDBD()


  cdata += 'Naètení ADT systémových tabulek ...' + CRLF
  oMLE:setData( cdata )
  get_system_data()

  cdata += 'Kontrola datovových souborù ...' +CRLF
  oMLE:setData( cdata )
  check_dbd_data( oMLE )

  oMLE:setData( oMLE:getData() + CRLF +'Reintalace A++ dokonèena ...' +CRLF )
return nil


***
CLASS MyService From ServiceApp
  EXPORTED:
    CLASS METHOD main
    CLASS METHOD stop
  HIDDEN:
    CLASS VAR lRunning
ENDCLASS

// Entry point of service
CLASS METHOD MyService:main()
  ::lRunning := .T.

  DO WHILE ::lRunning
    Tone( 400, 9 )
    Sleep( 50 )
  ENDDO
RETURN self

// Entry point for stop request
CLASS METHOD MyService:stop()
  ::lRunning := .F.
RETURN self





**************************************************************************
* FUNCTION to check password enetered
**************************************************************************
FUNCTION checkPswdFunction(fir, usr, pwd)
* Dummy check. It is up to you how to implement this
RETURN LOWER(ALLTRIM(usr)) == LOWER(ALLTRIM(pwd))



**************************************************************************
* Declaration of PUBLIC visible variables with initial values set.
**************************************************************************
PROCEDURE dclUsrPublicVars()
PUBLIC myCompanyName    := 'MISS Software, s.r.o.'
PUBLIC myCompanyAdress1 := 'Mlýnská 1228'
PUBLIC myCompanyAdress2 := 'Uherské Hradištì'
PUBLIC myNumber         := 100
PUBLIC myDate           := STOD('20050901')
PUBLIC isDemoVersion    := .T.
PUBLIC isWorkVersion    := .F.
PUBLIC isdeSysLock      := .F.
PUBLIC isRestFRM        := .T.
PUBLIC isDataTypeDBF    := .T.
PUBLIC syCheckDB        := 0
PUBLIC recFirma         := 0
PUBLIC obdReport        := ''

PUBLIC verzeAsys        := LoadResource(1, XPP_MOD_EXE, RES_VERSION)
PUBLIC usrName          := ''   // zkratka uživatele
PUBLIC usrOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
PUBLIC logFirma         := ''   // pøihlašovací jméno firmy
PUBLIC logUser          := ''   // pøihlašovací jméno uživatele
PUBLIC logOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
PUBLIC syOpravneni      := ''
RETURN


PROCEDURE dclDefaultInitVars()
  local  npos

  if isWorkVersion
    *
    ** úprava dir_DATA
    npos := rat('\', drgINI:dir_DATA)
    drgINI:add_FILE  := subStr(drgINI:dir_DATA, npos +1)
    drgINI:dir_DATA  := subStr(drgINI:dir_DATA, 1      , npos)
  else
    drgINI:dir_SYSTEM   += IF( Right( AllTrim(drgINI:dir_SYSTEM),1)=="\", "", "\")
    drgINI:dir_DATA     += IF( Right( AllTrim(drgINI:dir_DATA),1)=="\",   "", "\")
    drgINI:dir_USER     += IF( Right( AllTrim(drgINI:dir_USER),1)=="\",   "", "\")
  endif

  if( empty(drgINI:dir_DATAroot), drgINI:dir_DATAroot := drgINI:dir_DATA, nil)

// nastavení default hodnoty
  IF( Empty(drgINI:dir_USERfi)                                     ;
        , drgINI:dir_USERfi   := drgChkDirName( drgINI:dir_USER), NIL)
  IF( Empty(drgINI:dir_USERfitm)                                   ;
        , drgINI:dir_USERfitm := drgChkDirName( drgINI:dir_USERfi) + 'TMP\', NIL)
  IF( Empty(drgINI:dir_RSRC)                                       ;
        , drgINI:dir_RSRC     := drgChkDirName( drgINI:dir_SYSTEM) + 'RESOURCE\RSRC\', NIL)
  IF( Empty(drgINI:dir_WORK)                                       ;
        , drgINI:dir_WORK     := drgChkDirName( drgINI:dir_USERfi) , NIL)
RETURN


PROCEDURE ModiFirmaCFG()
  local n
  LOCAL cX
  LOCAL modiARR := { {'CPODNIK',    'CNAZFIRMY'}        ;
                    ,{'CULICEORG',  'CULICE'}           ;
                    ,{'CCISPOPORG', 'CCISPOPIS'}        ;
                    ,{'CULICE',     'CULICE'}           ;
                    ,{'CPSC',       'CPSC'}             ;
                    ,{'CSIDLO',     'CMISTO'}           ;
                    ,{'CZKRSTAORG', 'CZKRSTAT'}         ;
                    ,{'CZKRNAZPOD', 'CZKRNAZEV'}        ;
                    ,{'NICO',       'CICO'}             ;
                    ,{'CDIC',       'CDIC'}}


  drgDBMS:open('CONFIGHD')

  for n := 1 to Len( modiARR)
    CONFIGHD->(DbLocate({|| AllTrim(Upper(CONFIGHD->cItem)) == modiARR[n,1]}))
    CONFIGHD->(dbRlock())
    do case
    case modiARR[n,1] == 'CULICE'
      CONFIGHD->cValue := AllTrim(LicAsys->CULICE) + ' '+AllTrim(LicAsys->CCISPOPIS)
      myCompanyAdress1 := CONFIGHD->cValue
    otherwise
      CONFIGHD->cValue := &('LicAsys->' +modiARR[n,2])
    endcase
  next

  myCompanyName    := LicAsys->CNAZFIRMY
  myCompanyAdress2 := LicAsys->CMISTO
  CONFIGHD->( dbUnlock())

RETURN