/*==============================================================================
  VYR_KalkTHN_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  VYR_CenaCELKEM()     CenaCELKEM()       Kalkul.prg
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch"
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_KalkTHN_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy
  METHOD  VYR_KALK_THN          // Kalkulace materiálu

  inline method itemMarked()
*    ::info_in_msgStatus()
  return self

ENDCLASS

********************************************************************************
METHOD VYR_KalkTHN_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD VYR_KalkTHN_SCR:destroy()
  ::drgUsrClass:destroy()
RETURN self

/* ACTION - Detail VYRPOL
********************************************************************************
METHOD VYR_KalkTHN_SCR:VYR_VYRPOL_DET()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VYRPOL_CRD' PARENT ::drgDialog CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Vyrábìná položka - INFO') MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self
*/

* ACTION - Kalkulace materiálu
********************************************************************************
METHOD VYR_KalkTHN_SCR:VYR_Kalk_THN()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_Kalk_THN' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self

********************************************************************************
*
********************************************************************************
CLASS VYR_Kalk_THN FROM drgUsrClass
EXPORTED:
  VAR     nSumaKALK

  METHOD  Init, Destroy, drgDialogStart, TabSelect
  * Action
  METHOD  DETAIL_material         // Detail materiálu

HIDDEN
  VAR  dm, dc
ENDCLASS

*
********************************************************************************
METHOD VYR_Kalk_THN:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('CenProdC')
  drgDBMS:open('Kusov'   )
  drgDBMS:open('NakPOL'  )
  drgDBMS:open('KusTREE',.T.,.T.,drgINI:dir_USERfitm);  ZAP
  KusTREE->( DbSetRelation( 'NakPOL', {|| Upper(KusTREE->cSklPol) },'Upper(KusTREE->cSklPol)'))

  ::nSumaKALK := 0
RETURN self

*
********************************************************************************
METHOD VYR_Kalk_THN:drgDialogStart(drgDialog)

  ::dm  := ::drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  *
  ColorOfTEXT( ::dc:members[1]:aMembers )
  *
  GenTreeFILE( ROZPAD_NENI)
  ::nSumaKALK  := VYR_CenaCELKEM(3)
  KusTree->( dbGoTOP() )
  /*
  dbSelectArea( 'KusTree')
  KusTree->( AdsSetOrder(2), mh_SetScope( '1' ) )
  */

RETURN self

*
********************************************************************************
METHOD VYR_Kalk_THN:tabSelect( tabPage, tabNumber)

  ::dc:oBrowse[ tabNumber]:oXbp:refreshAll()
  ::dm:refresh()

RETURN .T.

*
********************************************************************************
METHOD VYR_Kalk_THN:destroy()
  ::drgUsrClass:destroy()

  ::nSumaKALK  := ;
                  NIL
RETURN self

* ACTION - Detail materiálu
********************************************************************************
METHOD VYR_Kalk_THN:DETAIL_material()
LOCAL oDialog, nRecNO := CENZBOZ->( RecNO())

  IF CENZBOZ->( dbSEEK( Upper(KusTREE->cCisSklad) + Upper(KusTREE->cSklPOL),, 'CENIK03'))
    SKL_CENZBOZ_INFO( ::drgDialog)
  ELSE
    drgMsgBox(drgNLS:msg( 'Karta materiálu nebyla v ceníku nalezena !'))
  ENDIF
  CENZBOZ->(dbGoTO( nRecNO))
RETURN self

* sloupce v browse ... vyr_Kalk_Thn.frm
*===============================================================================
FUNCTION VYR_Thn_bc2( nCOL)
  Local nRET := 0, nKoefPrep
  * záložka: dle MJ ve skladu
*  nKoefPrep := PrepocetMJ( nPocVychMJ, cVychoziMJ, cCilovaMJ, cFromFILE )
  nKoefPrep := KoefPrVC_MJ( KusTree->cMJTpv, KusTree->cZkratJedn, "KusTree" )
  IF nCOL = 1  ;  nRET := KusTree->nSpMnoNas * nKoefPrep ; ENDIF      // KusTree->nSpMnoNas * 3 ; ENDIF
  IF nCOL = 2  ;  nRET := KusTree->nCenaCelk * nKoefPrep ; ENDIF

  /*
  IF nCOL = 1  ;  nRET := KusTree->nSpMnoNas * NakPol->nKoefPrep ; ENDIF      // KusTree->nSpMnoNas * 3 ; ENDIF
  IF nCOL = 2  ;  nRET := KusTree->nCenaCelk * NakPol->nKoefPrep ; ENDIF
  */
RETURN nRET

*
*===============================================================================
FUNCTION VYR_CenaCELKEM( nWhat, nDruhCeny)
  Local cCenaCelk, cNazCeny
  Local nCenaCelk, nKoefPREP, nPOS, anCENA  //, nDruhCENY := 1  // DruhCENY()
  Local lDrCenKal :=  SysCONFIG( 'Vyroba:lDrCenKal')

  DEFAULT nWhat TO 1, nDruhCeny TO 1
  DO CASE
  CASE nWhat == 1   // Druh ceny jako string
    nKoefPREP := KusTREE->nKoefPREP
    anCENA    := { KusTREE->nCenaCELK , KusTREE->nCenaCELK2,;
                   KusTREE->nCenaCELK3, KusTREE->nCenaCELK4, KusTREE->nCenaCELK5 }
    IF !lDrCenKal
       nPOS := ASCAN( anCENA, {|X| X <> 0 } )
       nPOS := IF( nPOS == 0, nDruhCENY, nPOS )
    ENDIF

    If IsNil( nDruhCENY)
      nCenaCelk := KusTree->nCenaCelk6 * nKoefPREP
    ElseIf nDruhCeny = 5
       nCenaCelk := anCENA[ nDruhCENY]
    Else
      nCenaCelk := nKoefPREP * IF( lDrCenKAL, anCENA[ nDruhCENY],;
                   IF( anCENA[ nDruhCENY] == 0, anCENA[ nPOS], anCENA[ nDruhCENY] ))
//      cCenaCelk += '-'+ IF( lDrCenKAL, STR( nDruhCENY, 1),;
//                   IF( anCENA[ nDruhCENY] == 0, STR( nPOS, 1), STR( nDruhCENY, 1) ))
    EndIf

    Return( nCenaCelk)

  CASE nWhat == 2   // Název druhu ceny
    If IsNil( nDruhCENY)  ; cNazCeny := ' Nákupní cena'
    ElseIf nDruhCENY == 1 ; cNazCeny := '   Sklad.cena'
    ElseIf nDruhCENY == 2 ; cNazCeny := 'Posl.nák.cena'
    ElseIf nDruhCENY == 3 ; cNazCeny := 'Nák.cen. cena'
    ElseIf nDruhCENY == 4 ; cNazCeny := ' Objedn. cena'
    ElseIf nDruhCENY == 5 ; cNazCeny := 'Nabídková cena'
    Endif
  Return( cNazCeny)

  CASE nWhat == 3   // Suma ceny celkem do patièky
    nCenaCelk := 0
    If IsNil( nDruhCENY)  //  ; SUM KusTree->nCenaCelk6 * KusTREE->nKoefPREP To nCenaCelk
      KusTree->( dbEval( {|| nCenaCelk += KusTree->nCenaCelk6 * KusTREE->nKoefPREP  } ))
    ElseIf nDruhCENY == 1  //; SUM KusTree->nCenaCelk  * KusTREE->nKoefPREP To nCenaCelk
      KusTree->( dbEval( {|| nCenaCelk += KusTree->nCenaCelk  * KusTREE->nKoefPREP  } ))
    ElseIf nDruhCENY == 2 // ; SUM KusTree->nCenaCelk2 * KusTREE->nKoefPREP To nCenaCelk
      KusTree->( dbEval( {|| nCenaCelk += KusTree->nCenaCelk2  * KusTREE->nKoefPREP  } ))
    ElseIf nDruhCENY == 3  // ; SUM KusTree->nCenaCelk3 * KusTREE->nKoefPREP To nCenaCelk
      KusTree->( dbEval( {|| nCenaCelk += KusTree->nCenaCelk3  * KusTREE->nKoefPREP  } ))
    ElseIf nDruhCENY == 4  // ; SUM KusTree->nCenaCelk4 * KusTREE->nKoefPREP To nCenaCelk
      KusTree->( dbEval( {|| nCenaCelk += KusTree->nCenaCelk4  * KusTREE->nKoefPREP  } ))
    ElseIf nDruhCENY == 5  // ; SUM KusTree->nCenaCelk5 * KusTREE->nKoefPREP To nCenaCelk
      KusTree->( dbEval( {|| nCenaCelk += KusTree->nCenaCelk5    } ))
    Endif
    KusTREE->( dbGoTOP())
  Return( nCenaCelk)

ENDCASE
RETURN Nil