
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "SDFDBE.Ch"
#include "..\SKLADY\SKL_Sklady.ch"


********************************************************************************
*
********************************************************************************
CLASS SKL_PVPterm_IN FROM drgUsrClass
EXPORTED:

  inline access assign method typImportu()    var ctypImportu
    return PVPterm->cTypImport

* Indikace, že nasnímaná položka existuje/neexistuje v ceníku
  inline access assign method inCenZboz()     var cinCenZboz
    return if( PVPterm->lInCenZboz, "A", "N")

* Indikace, že nasnímaná položka obsahuje chyby
  inline access assign method Errors()     var cErrors
    return if( EMPTY(PVPterm->cTermERRs), " ", "E")

* Textová indikace typu pohybu
  inline access assign method TypPVP()     var cTypPVP
    local acTypPVP := { 'pøíjem', 'výdej', 'pøevod'}, cTypPVP

    cTypPVP := if( PVPTerm->nTypPVP > 0, acTypPVP[ PVPTerm->nTypPVP ], '' )
    return cTypPVP


* Textová indikace stavu plnìní( pøevzetí)                       =
* PVPTerm->nStav_PLN = 0   ... nepøebráno
*                    = 1   ... èásteènì pøebráno
*                    = 2   ... plnì pøebráno
  inline access assign method Stav_PLN()     var cStav_PLN
    local acStav := {'neplnìno', 'èásteènì', 'plnì'}, cStav

    return acStav[ PVPTerm->nStav_PLN + 1 ]


  VAR     nDataFilter, cFiImport, mainBro

  METHOD  Init, drgDialogStart, EventHandled, ItemMarked
  METHOD  ComboItemSelected
  METHOD  Import_toPVPterm, Create_txt, InCenZboz_akt, RefreshDATA
HIDDEN:
  METHOD  FilterOn_PVPterm
ENDCLASS

********************************************************************************
METHOD SKL_PVPterm_IN:Init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('CenZboz'  )
  *
  ::cFiImport     := 'TT' //'PVPterm'
  ::nDataFilter   := 0    //0 = Všechny pohyby, 1 = pøíjmy, 2 = výdeje, 3 = pøevody
RETURN self

********************************************************************************
METHOD SKL_PVPterm_IN:drgDialogStart(drgDialog)

   ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
   ::mainBro := drgDialog:odBrowse[1]
   *
   ::FilterOn_PVPterm( .t.)
   InCenZboz_akt()
   *
RETURN self

********************************************************************************
METHOD SKL_PVPterm_IN:comboItemSelected( Combo)
  *
  ::nDataFilter := Combo:value
  ::FilterOn_PVPterm( .f.)
  *
RETURN .T.

********************************************************************************
METHOD SKL_PVPterm_IN:FilterOn_PVPterm( lSetTypPVP )
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
METHOD SKL_PVPterm_IN:eventHandled(nEvent, mp1, mp2, oXbp)

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
METHOD SKL_PVPterm_IN:ItemMarked()
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
METHOD SKL_PVPterm_IN:Import_toPVPterm()

  Import_toPVPterm()
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)

RETURN SELF

* Aktualizace  PVPterm->lInCenZboz, pokud byla skl.položka do ceníku doplnìna
********************************************************************************
METHOD SKL_PVPterm_IN:InCenZboz_akt()

  InCenZboz_akt()

RETURN SELF

* Aktualizece - refreš dat
********************************************************************************
METHOD SKL_PVPTERM_IN:RefreshDATA()
  *
  InCenZboz_akt()
  Check_TermERRs()
  ::mainBro:oXbp:refreshAll()
RETURN self

********************************************************************************
METHOD SKL_PVPterm_IN:Create_txt()
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