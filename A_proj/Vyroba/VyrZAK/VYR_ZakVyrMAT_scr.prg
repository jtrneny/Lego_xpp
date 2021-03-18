/*==============================================================================
  VYR_VyrZakMAT_scr.PRG
  Materiálové požadavky na zakázku
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
* SCR - Materiálové požadavky na zakázku
********************************************************************************
CLASS VYR_ZakVyrMAT_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  EventHandled
  METHOD  ItemMarked

//  METHOD  ZAK_MATERIAL        //  tl. Materiál
//  METHOD  ZAK_PLANSKUT        //  tl. Plán vs. skut.
//  METHOD  ZAK_MATERIAL_DEL    //  tl. Zrušit materiál

ENDCLASS

*
********************************************************************************
METHOD VYR_ZakVyrMAT_SCR:Init(parent)
  local  cflt_vyrZak := "(cstavZakaz = '5' or cstavZakaz = '6')"
  local  cflt_vyrPol := "nmnZADva <> 0"


  ::drgUsrClass:init(parent)

*  drgDBMS:open('VyrZAK' )

  * new
  drgDBMS:open('vyrZak') ;  vyrZak->( ordSetFocus( 'VYRZAK1' ))
                            vyrZak->( ads_setAof( cflt_vyrZak ), dbgoTop() )
  drgDBMS:open('vyrPol') ;  vyrPol->( ordSetFocus( 'VYRPOL1' ))
                            vyrPol->( ads_setAof( cflt_vyrPol ), dbgoTop() )

RETURN self

*
********************************************************************************
METHOD VYR_ZakVyrMAT_SCR:EventHandled( nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_DELETE
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_ZakVyrMAT_SCR:ItemMarked()
  local  ccisZakaz := upper(vyrZak->ccisZakaz)

  vyrPol->(dbsetscope(SCOPE_BOTH, ccisZakaz),dbgotop())

RETURN SELF


/*
*
********************************************************************************
METHOD VYR_ZakVyrMAT_SCR:ZAK_MATERIAL()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VZakMAT_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
  *
  ObjITEM->( AdsSetOrder(9), dbGoTOP() )
  SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
  ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()
RETURN self

*
********************************************************************************
METHOD VYR_ZakVyrMAT_SCR:ZAK_PLANSKUT()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VZakPLSK_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Zruší všechny materiálové požadavky ( obj.pøijaté) na zakázku
********************************************************************************
METHOD VYR_ZakVyrMAT_SCR:ZAK_MATERIAL_DEL()
  Local nCount := dbCOUNT( 'ObjITEM'), cKEY

  IF nCount == 0
    drgMsgBox(drgNLS:msg( 'Není co rušit - materiálové požadavky neexistují !' ), XBPMB_INFORMATION )
    RETURN NIL
  ENDIF
  *
  IF drgIsYESNO(drgNLS:msg('Zrušit materiálové požadavky na zakázku < & >  ?', VyrZak->cCisZakaz ) )
    IF( Used('ObjHEAD'), NIL, drgDBMS:open('ObjHEAD') )
    ObjITEM->( dbGoTOP())
    DO WHILE !ObjITEM->( EOF())
      VYR_CenZboz_MODI( drgEVENT_DELETE, .T.)
      VYR_Kusov_MODI()
      DelREC( 'ObjITEM')
      ObjITEM->( dbSKIP())
    ENDDO
    *
    cKey := StrZero( 1, 5) + VyrZak->cCisZakaz
    IF ObjHead->( dbSeek( Upper( cKey),, 'OBJHEAD1'))
      DelREC( 'ObjHead')
    EndIF
    *
    SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)   // brow VyrZAK
    ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()   // brow ObjITEM
  ENDIF
RETURN self



* Modifikace ObjHead pøi generování materiálových požadavkù
*===============================================================================
STATIC FUNCTION VYR_ObjHead_Modi()
  Local cKey := StrZero( 1, 5) + VyrZak->cCisZakaz
  Local nRec := ObjItem->( RecNo())
  Local lExist, lOK
  Local aX := { 0, 0, 0, 0, 0 }

 If ObjItem->( RecNo()) <= ObjItem->( LastRec())
   lExist := ObjHead->( dbSeek( Upper( cKey)))
   If ( lOK := If( lExist, ReplRec( 'ObjHead'), AddRec( 'ObjHead')) )
      If !lExist
        // ... dosud neexistuje Hl. obj. pøijaté, založí se.
        ObjHead->nCisFirmy  := 1  // MyFIRMA
        ObjHead->nCislObInt := VYR_NewCisObjHEAD( VyrZak->cCisZakaz)
        ObjHead->cCislObInt := VyrZak->cCisZakaz
        ObjHead->dDatObj    := Date()
        ObjHead->dDatDoOdb  := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        ObjHead->cNazPracov := SysConfig( 'System:cUserAbb')
        ObjHead->cCisZakaz  := VyrZak->cCisZakaz
      Endif
      ObjItem->( dbGoTop())
      ObjItem->( dbEval( {||  aX[ 1] += 1                    ,;
                              aX[ 2] += ObjItem->nKcsBdObj   ,;
                              aX[ 3] += ObjItem->nKcsZdObj   ,;
                              aX[ 4] += ObjItem->nMnozObODB  ,;
                              aX[ 5] += ObjItem->nMnozPoODB   }))
      ObjHead->nPocPolObj := aX[ 1]
      ObjHead->nKcsBdObj  := aX[ 2]
      ObjHead->nKcsZdObj  := aX[ 3]
      ObjHead->nMnozObODB := aX[ 4]
      ObjHead->nMnozPoODB := aX[ 5]
      ObjHead->nCenaZakl  := ObjHead->nKcsBdObj
      ObjItem->( dbGoTo( nRec))
      ObjHead->( dbUnlock())
   Endif
 Endif
Return( Nil)

*/