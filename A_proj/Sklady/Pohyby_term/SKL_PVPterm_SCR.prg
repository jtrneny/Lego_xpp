
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "SDFDBE.Ch"
#include "..\SKLADY\SKL_Sklady.ch"


*   Obecná tøída pro indikaci stavu externího pohybu pvpTerm
*
**  CLASS for SKL_pvpTerm_info *************************************************
class skl_pvpTerm_info
EXPORTED:

  inline method init()
    drgDBMS:open( 'cenZboz',,,,, 'cenZbozA' )
    drgDBMS:open( 'dodZboz',,,,, 'dodZbozA' )
    return self

  * T_ terminál, K_ kardex, E_ eCompany, P_ KPK
  inline access assign method typImportu() var typImportu
    local  nicon      := 0
    local  ctypImport := upper(pvpTerm->ctypImport)

    nicon := if( ctypImport = 'T', 553, ;
              if( ctypImport = 'K', 557, ;
               if( ctypImport = 'E', 559, ;
                if( ctypImport = 'P', 560, 0 ))))
    return nicon

  inline access assign method incenZboz() var incenZboz
    local  lok     := .f.
    local  cky_ssp := upper( pvpTerm->ccisSklad)  +upper( pvpTerm->csklPol)
    local  cky_ck  := upper( pvpTerm->czkrCarKod) +upper( pvpTerm->ccarKod)

    if( select('cenZbozA') = 0, drgDBMS:open( 'cenZboz',,,,, 'cenZbozA' ), nil )
    if( select('dodZbozA') = 0, drgDBMS:open( 'dodZboz',,,,, 'dodZbozA' ), nil )

    if empty(pvpTerm->ccarKod)
      lok := cenZbozA->( dbseek( cky_ssp,,'CENIK03' ))
    else

      if dodZbozA->( dbseek( cky_ck,,'DODAV8' ))
        cky_ssp := upper( dodZbozA->ccisSklad) +upper( dodZbozA->csklPol)
        lok     := cenZbozA->( dbseek( cky_ssp,,'CENIK03' ))
      else
        lok     := cenZbozA->( dbseek( cky_ssp,,'CENIK03' ))
      endif
    endif
    return if( lok, 0, MIS_ICON_ERR )

  inline access assign method termERRs() var termERRS
    return if( empty(pvpTerm->ctermERRs), 0, MIS_EXCL_ERR )

  inline access assign method typPvp() var typPvp
    local  pa_typPvp := { MIS_PLUS, MIS_MINUS, MIS_UNDO }
    local  ntypPvp   := pvpTerm->ntypPvp
    return if( ntypPvp > 0, pa_typPvp[ntypPvp], 0 )

  inline access assign method c_typPvp() var c_typPvp
    local  pa_typPVP := { 'pøíjem', 'výdej', 'pøevod'}, cTypPVP
    return if( pvpTerm->ntypPVP > 0, pa_typPVP[ pvpTerm->ntypPVP ], space(6) )

  inline access assign method c_stav_Pln() var c_stav_Pln
    local  nmnozDokl1  := pvpTerm->nmnozDokl1
    local  nmnoz_Pln   := pvpTerm->nmnoz_Pln
    return if( nmnoz_Pln = 0, 'nepøebráno', ;
            if( nmnozDokl1 = nmnoz_Pln, 'plnì pøebráno', 'èásteènì pøebráno' ))

endclass



*   Oprava externího pohybu pvpTerm
*
**  CLASS for SKL_pvpTerm_SCR **************************************************
CLASS SKL_PVPterm_SCR FROM drgUsrClass
EXPORTED:
  var     oinf
  VAR     nDataFilter, cFiImport, mainBro

  METHOD  Init, drgDialogStart, EventHandled, ItemMarked
  METHOD  ComboItemSelected
  METHOD  Import_toPVPterm, Create_txt, InCenZboz_akt, RefreshDATA

HIDDEN:
  METHOD  FilterOn_PVPterm
ENDCLASS

********************************************************************************
METHOD SKL_PVPterm_SCR:Init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open( 'pvpTerm' )
  drgDBMS:open( 'cenZboz' )
  *
  ::oinf := skl_pvpTerm_info():new()
  *
  ::cFiImport     := 'TT' //'PVPterm'
  ::nDataFilter   := 0    //0 = Všechny pohyby, 1 = pøíjmy, 2 = výdeje, 3 = pøevody
RETURN self


method SKL_pvpTerm_SCR:drgDialogStart(drgDialog)

   ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
   ::mainBro := drgDialog:odBrowse[1]
   *
   ::FilterOn_PVPterm( .t.)
   InCenZboz_akt()
   *
RETURN self

********************************************************************************
METHOD SKL_PVPterm_SCR:comboItemSelected( Combo)
  *
  ::nDataFilter := Combo:value
  ::FilterOn_PVPterm( .f.)
  *
RETURN .T.

********************************************************************************
METHOD SKL_PVPterm_SCR:FilterOn_PVPterm( lSetTypPVP )
  Local Filter  := "nStav_PLN <> 2"   // dosud nepøebrané do dokladu

  IF ::drgDialog:parent:formName = 'Skl_PohybyIT'
    Filter  := "nStav_PLN <> 2 .and. cCisSklad =  '" + PVPHeadw->cCisSklad + "'"
    ::nDataFilter := IF( lSetTypPVP, PVPHeadw->nTypPVP, ::nDataFilter )
  ENDIF


  *
  Do Case
  Case ::nDataFilter = 0
    IF( EMPTY(PVPterm->(ads_getAof())), NIL, PVPterm->(ads_clearAof(),dbGoTop()) )
    PVPterm->( mh_SetFilter( Filter))

  OtherWise
    Filter += " .AND. nTypPVP = %%"
    Filter := Format( Filter,{ ::nDataFilter })
    PVPterm->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.

********************************************************************************
METHOD SKL_PVPterm_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_APPEND .or. ;
       nEvent = drgEVENT_APPEND2
      RETURN .T.

  CASE nEvent = drgEVENT_DELETE
    IF drgIsYESNO(drgNLS:msg( 'Požadujete zrušit nasnímanou položku [ ' + PVPterm->cSklPol + ' ] ?' ) )
      IF PVPterm->( RLock())
        PVPterm->( dbDelete(), dbRUnlock())
      ENDIF
      ::mainBro:oxbp:refreshAll()
      PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD SKL_PVPterm_SCR:ItemMarked()
  LOCAL members  := ::drgDialog:oActionBar:Members, x
  *
  CenZboz->( dbSeek( Upper(PVPterm->cCisSklad) + Upper(PVPterm->cSklPol),, 'CENIK03'))
  * založit skl.kartu mùže pouze když neexistuje ( tj. buton je enabled)
  FOR x := 1 TO LEN( Members)
    IF  members[x]:event = 'TERM_CENZBOZ_CRD'
      IF( PVPterm->lInCenZBOZ, members[x]:oXbp:disable(), members[x]:oXbp:enable() )

      members[x]:oXbp:setColorFG( If(  PVPterm->lInCenZBOZ, GraMakeRGBColor({128,128,128}),;
                                                            GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT
RETURN SELF

********************************************************************************
METHOD SKL_PVPterm_SCR:Import_toPVPterm()

  Import_toPVPterm()
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)

RETURN SELF

* Aktualizace  PVPterm->lInCenZboz, pokud byla skl.položka do ceníku doplnìna
********************************************************************************
METHOD SKL_PVPterm_SCR:InCenZboz_akt()

  InCenZboz_akt()

RETURN SELF

* Aktualizece - refreš dat
********************************************************************************
METHOD SKL_PVPTERM_SCR:RefreshDATA()
  *
  InCenZboz_akt()
  Check_TermERRs()
  ::mainBro:oXbp:refreshAll()
RETURN self

********************************************************************************
METHOD SKL_PVPterm_SCR:Create_txt()
  Local  cPath := 'C:\Data\'
  Local  cPathFile := cPath + ::cFiImport + '.txt'

   IF ( lOK := DbeLoad( "SDFDBE" ))

      DbCreate( cPathFile, { {"nTypPVP"    , "N",  1, 0}  ,;
                             {"cCisSklad"  , "C",  8, 0}  ,;
                             {"cSklPol"    , "C", 15, 0}  ,;
                             {"cZkrCarKod" , "C", 15, 0}  ,;
                             {"cCarKod"    , "C",128, 0}  ,;
                             {"cNazZbo"    , "C", 30, 0}  ,;
                             {"nZboziKat"  , "N",  4, 0}  ,;
                             {"nCenaDokl1" , "N", 13, 4}  ,;
                             {"nMnozDokl1" , "N", 15, 4}  ,;
                             {"cMjDokl1"   , "C",  3, 0}  ,;
                             {"nCenaPZBO"  , "N", 11, 2}  ,;
                             {"nCenaMZBO"  , "N", 11, 2}  ,;
                             {"nCenaSZBO"  , "N", 11, 2}  ,;
                             {"cPolCen"    , "C",  1, 0}  ,;
                             {"nCarKod"    , "N", 13, 0}  ,;
                             {"nMnoz_PLN"  , "N", 15, 4}  ,;
                             {"nStav_PLN"  , "N",  1, 0}  ,;
                             {"nUsrIdDbTe" , "N",  6, 0}  ,;
                             {"lInCenZBOZ" , "L",  1, 0}  ,;
                             {"dVznikZazn" , "D",  8, 0}  ,;
                             {"dZmenaZazn" , "D",  8, 0}  ,;
                             {"cUniqIdRec" , "C", 26, 0} },;
                "SDFDBE" )

      USE &cPathFile ALIAS  TT  VIA SDFDBE
      *
      FOR i:=1 TO 5
         DbAppend()
         TT->nTypPVP   := 1
         TT->cCisSklad := '101     '
         TT->cSklPol   := '1110000' + Str(i,1)
      NEXT
      TT->( dbCloseArea())
      DbeUnload( "SDFDBE" )
      *
      drgMsgBox(drgNLS:msg( 'Soubor byl vytvoøen ...'  ))
  EndIf
      */

RETURN Nil


*
********************************************************************************
FUNCTION Import_toPVPterm()
  Local  cPath := 'C:\Data\'      // SysConfig( 'Sklady:')
  lOCAL  cFiImport := 'TT'
  Local  cPathFile                //:= cPath + cFiImport + '.txt'
  Local  lOK, i, cKey, nRecCount, lInCenZboz, aDbe, npos
*
  DEFAULT cFiImport TO 'TT'

  cPathFile := cPath + cFiImport + '.txt'
  IF !File( cPathFile )
    drgMsgBox(drgNLS:msg( 'Nebyla nalezena žádná data ze sbìrného terminálu ...' ))
**    ::Create_txt()
    Return nil
  EndIf
 */

*  IF FILE(cPathFile)
  IF drgIsYESNO(drgNLS:msg( 'Požadujete importovat data ze sbìrného terminálu ?' ) )
    aDBE := dbeList()
    npos := ASCAN( aDBE, {|a| a[1] = "SDFDBE" } )
    lOK := If( npos = 0, DbeLoad( "SDFDBE" ), .T. )
    IF lOK
      USE &( cPathFile )  VIA SDFDBE
    ENDIF
    /*
    IF ( lOK := DbeLoad( "SDFDBE" ))
      USE &( cPathFile )  VIA SDFDBE
    ENDIF
    DbeUnload( "SDFDBE" )
    */
    nRecCount :=  TT->( LastRec())
    TT->( dbGoTop())
    drgDBMS:open('PVPterm'  )

    drgServiceThread:progressStart(drgNLS:msg('Import nasnímaných pohybù' , 'TT'), TT->( LastRec())  )

    DO WHILE ! TT->( eof())
      PVPterm->( dbAppend())
      PVPterm->nTypPVP    := TT->nTypPVP
      PVPterm->cCisSklad  := TT->cCisSklad
      PVPterm->cSklPol    := TT->cSklPol

      lInCenZboz := CenZboz->( dbSeek( Upper(PVPterm->cCisSklad) + Upper(PVPterm->cSklPol),, 'CENIK03'))
      PVPterm->lInCenZboz := lInCenZboz
      PVPterm->cNazZbo    := 'test'   //CenZboz->cNazZbo

      drgServiceThread:progressInc()
      TT->( dbSkip())
    EndDo
    drgServiceThread:progressEnd()

    TT->( dbCloseArea())
    *
*    FERASE( cPath + 'TT.txt')
*    FERASE( cPath + 'TT.sdf')
*    FERASE( cPath + ::cFiImport + '.txt' )
*    FERASE( cPath + ::cFiImport + '.sdf' )
    *
    drgMsgBox(drgNLS:msg( 'Import nasnímaných pohybù byl ukonèen ...'  ))
  ENDIF

RETURN NIL

* Aktualizace  PVPterm->lInCenZboz, pokud byla skl.položka do ceníku doplnìna
********************************************************************************
FUNCTION InCenZboz_akt()

  IF PVPTerm->( FLock())
    drgDBMS:open('CENZBOZ',,,,, 'CenZBOZa' )
    drgDBMS:open('DODZBOZ',,,,, 'DodZBOZa' )
    PVPTerm->( dbGoTop())
    DO WHILE ! PVPterm->( Eof())

*      PVPterm->lInCenZboz := CenZbozw->( dbSeek( Upper(PVPterm->cCisSklad) + Upper(PVPterm->cSklPol),, 3))
      PVPterm->lInCenZboz := InCenZboz_one()
      PVPTerm->( dbSkip())
    ENDDO
    PVPterm->( dbUnlock(), dbGoTop())
    CenZBOZa->( dbCloseArea())
    DodZBOZa->( dbCloseArea())
  ENDIF

RETURN NIL

*===============================================================================
FUNCTION InCenZboz_one( lOpenHlpFiles)
  Local lOK, cKey

  DEFAULT lOpenHlpFiles TO .F.
  *
  IF lOpenHlpFiles
    drgDBMS:open('CENZBOZ',,,,, 'CenZBOZa' )
    drgDBMS:open('DODZBOZ',,,,, 'DodZBOZa' )
  ENDIF
  *
  IF EMPTY( PVPterm->cCarKod )
    cKey := PVPterm->cCisSklad + PVPterm->cSklPol
    lOK := CenZBOZa->( dbSeek( Upper( cKey),, 'CENIK03'))
  ELSE
    lOK  := DodZBOZa->( dbSeek( Upper( PVPterm->cZkrCarKod) + Upper( PVPterm->cCarKod),, 'DODAV8'))
    cKey := If( lOK, DodZBOZa->cCisSklad + DodZboz->cSklPol, cKey )
    IF lOK
      CenZBOZa->( dbSeek( Upper( cKey),, 'CENIK03'))
    ELSE
       lOK := CenZBOZa->( dbSeek( Upper( PVPterm->cZkrCarKod) + Upper( PVPterm->cCarKod),, 'CENIK14'))
       cKey := If( lOK, CenZBOZa->cCisSklad + CenZBOZa->cSklPol, cKey )
       IF lOK
       ELSE
         cKey := PVPterm->cCisSklad + PVPterm->cSklPol
         lOK := CenZBOZa->( dbSeek( Upper( cKey),, 'CENIK03'))
       ENDIF
    ENDIF
  ENDIF
  *
  IF lOpenHlpFiles
    CenZBOZa->( dbCloseArea())
    DodZBOZa->( dbCloseArea())
  ENDIF

RETURN lOK


* Založení skladové položky, která byla nasnímána, ale v ceníku neexistuje
*===============================================================================
FUNCTION TERM_CenZboz_crd( Dialog)
  LOCAL oDialog, nExit, lOK := .F.
  LOCAL aSetCrd := { { 'CenZBOZw->cCisSklad' , PVPterm->cCisSklad  },;
                     { 'CenZBOZw->cSklPol'   , PVPterm->cSklPol    },;
                     { 'CenZBOZw->cNazZbo'   , PVPterm->cNazZbo    },;
                     { 'CenZBOZw->nZboziKat' , PVPterm->nZboziKat  },;
                     { 'CenZBOZw->cZkratJedn', PVPterm->cMjDokl1   },;
                     { 'CenZBOZw->nCenaSZbo' , PVPterm->nCenaSZbo  },;
                     { 'CenZBOZw->cPolCen'   , PVPterm->cPolCen    },;
                     { 'CenZBOZw->dVznikZazn', Date()              },;
                     { 'CenZBOZw->cTypSklPol', 'U '                 }}

  DRGDIALOG FORM 'SKL_CENZBOZ_CRD' PARENT Dialog CARGO drgEVENT_APPEND CARGO_USR aSetCrd ;
                                    MODAL DESTROY EXITSTATE nExit
  IF ( lOK := ( nExit != drgEVENT_QUIT ))
    IF PVPterm->( RLock())
       PVPterm->lInCenZBOZ  := .T.
       PVPterm->cCisSklad   := CenZboz->cCisSklad
       PVPterm->cSklPol     := CenZboz->cSklPol
       PVPterm->cNazZbo     := CenZboz->cNazZbo
       PVPTerm->( dbRUnlock())
       *
*       Dialog:udcp:mainBro:oXbp:refreshCurrent()
       aEval( dialog:odBrowse, {|oB| IF( oB:cFile = 'PVPterm', oB:oxbp:refreshCurrent(), nil) })
     ENDIF
  ENDIF

RETURN lOK



******************************************************************************
    /*
    cDbe := DbeSetDefault()

    IF ( lOK := DbeLoad( "SDFDBE" ))
      Select('PVPterm')
      *
      PVPterm->( dbImport( "C:\Data\aaa.txt" ,;
                           { 'nTypPVP', 'cCisSklad', 'cSklPol' },,,,,,;
                           'SDFDBE',;
                           { {SDFDBE_DECIMAL_TOKEN, ","} } ))
      *
    ENDIF
    */

**     IF ( lOK := DbeLoad( "SDFDBE" ))
      /*
      DbCreate(  cPath, { {"nTypPVP"    , "N",  1, 0}, ;
                          {"cCisSklad"  , "C",  8, 0}, ;
                          {"cSklPol"    , "C", 15, 0}  }, ;
                "SDFDBE" )

      USE &cPath ALIAS  TT  VIA SDFDBE
      *
      FOR i:=1 TO 5
         DbAppend()
         TT->nTypPVP   := 1
         TT->cCisSklad := '101     '
         TT->cSklPol   := '1110000' + Str(i,1)
      NEXT
      */

FUNCTION GenBarCod()
  Local cCarKod := ''
  Local nTypGenBcd := SysConfig('Sklady:nTypGenBCD')

  Do Case
    Case nTypGenBcd = 0
    Case nTypGenBcd = 1   ; cCarKod := GenBCD( 1)
    Case nTypGenBcd = 2
    Case nTypGenBcd = 3

  EndCase

RETURN cCarKod

/* Standartní typ generování BCD
*===============================================================================
FUNCTION GenBCD_01()
  Local cCarKod := AllTrim( Str( VldBarCod()))
RETURN cCarKod

* Typ generování BCD = 2  : kód je vytvoøen ze skladu a skl.položky
*===============================================================================
FUNCTION GenBCD_02( cCisSklad, cSklPol)
  Local cCarKod := PADR( AllTrim(cCisSklad),  8, '0') + ;
                   PADR( AllTrim(cSklPol)  , 15, '0')
RETURN cCarKod

* Typ generování BCD = 3  : kód je vytvoøen ze skl.položky a skladu
*===============================================================================
FUNCTION GenBCD_03( cCisSklad, cSklPol)
  Local cCarKod := PADR( AllTrim(cSklPol)  , 15, '0') + ;
                   PADR( AllTrim(cCisSklad),  8, '0')
RETURN cCarKod
*/

*
*===============================================================================
FUNCTION GenBCD( nTypGenBcd, cCisSklad, cSklPol )
  Local cCarKod := ''

  Do Case
    Case nTypGenBcd = 0
    Case nTypGenBcd = 1
      cCarKod := AllTrim( Str( VldBarCod()))
    Case nTypGenBcd = 2
      cCarKod := PADR( AllTrim(cCisSklad), 8, '0') + PADR( AllTrim(cSklPol) ,15, '0')
    Case nTypGenBcd = 3
      cCarKod := PADR( AllTrim(cSklPol)  ,15, '0') + PADR( AllTrim(cCisSklad),8, '0')
    Case nTypGenBcd = 4
      cCarKod := PADR( AllTrim(cCisSklad), 8 ) + PADR( AllTrim(cSklPol)   ,15 )
    Case nTypGenBcd = 5
      cCarKod := PADR( AllTrim(cSklPol)  ,15 ) + PADR( AllTrim(cCisSklad) , 8 )
  EndCase
RETURN cCarKod


* Indikace, typu importu
*===============================================================================
FUNCTION PVPterm_TypImportu()
  Local nIcon := 0
  do case
  case PVPterm->cTypImport = 'T'  ;  nIcon := 553     // terminál
  case PVPterm->cTypImport = 'K'  ;  nIcon := 557     // kardex
  case PVPterm->cTypImport = 'E'  ;  nIcon := 559    // eCompany
  case PVPterm->cTypImport = 'P'  ;  nIcon := 560    // KPK
  endcase
RETURN nIcon

* Indikace, že nasnímaná položka existuje/neexistuje v ceníku
*===============================================================================
FUNCTION PVPterm_inCenZboz()
  Local nIcon := IF( PVPterm->lInCenZboz, 0, MIS_ICON_ERR )
RETURN nIcon

* Indikace, že nasnímaná položka obsahuje chyby
*===============================================================================
FUNCTION PVPterm_Errors()
  Local nIcon := IF( EMPTY(PVPterm->cTermERRs), 0, MIS_EXCL_ERR )
RETURN nIcon

* Textová indikace typu pohybu
*===============================================================================
FUNCTION PVPterm_TypPVP()
  Local acTypPVP := { 'pøíjem', 'výdej', 'pøevod'}, cTypPVP
  cTypPVP := If( PVPTerm->nTypPVP > 0, acTypPVP[ PVPTerm->nTypPVP ], '' )
RETURN cTypPVP

* Textová indikace stavu plnìní( pøevzetí)                       =
* PVPTerm->nStav_PLN = 0   ... nepøebráno
*                    = 1   ... èásteènì pøebráno
*                    = 2   ... plnì pøebráno
*===============================================================================
FUNCTION PVPterm_Stav_PLN()
  Local acStav := {'nepøebráno', 'èásteènì pøebráno', 'plnì pøebráno'}, cStav
*  cStav := Alltrim( Str( PVPTerm->nStav_PLN)) + ' = ' + acStav[ 1 + PVPTerm->nStav_PLN ]
  cStav := acStav[ PVPTerm->nStav_PLN + 1 ]
RETURN cStav