********************************************************************************
* HIM_MAJOBD_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "GRA.Ch"

********************************************************************************
* HIM_MAJOBD_SCR ... Stavy karet v období
********************************************************************************
CLASS HIM_MAJOBD_SCR FROM drgUsrClass, HIM_Main
EXPORTED:
  VAR     isHIM, cTask, nObdobiFLT
  METHOD  Init, Destroy, ItemMarked, drgDialogStart
  METHOD  comboBoxInit, comboItemSelected
  METHOD  Maj_info

HIDDEN
  VAR     mainBro
ENDCLASS

*
********************************************************************************
METHOD HIM_MAJOBD_SCR:init(parent, cTask)
  ::drgUsrClass:init(parent)
  *
  DEFAULT cTASK TO 'HIM'
  ::isHIM  := ( cTASK = 'HIM')
  ::cTask  := cTask
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  *
  ::nObdobiFLT := 1
  *
  drgDBMS:open('OBDOBIw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

RETURN self

*******************************************************************************
METHOD HIM_MAJOBD_SCR:destroy()

  ::drgUsrClass:destroy()
  ::cTask := ::isHIM := ::nObdobiFlt := ::mainBro :=  Nil
RETURN self
*
********************************************************************************
METHOD HIM_MAJOBD_SCR:drgDialogStart( drgDialog )
  *
  ::mainBro := drgDialog:odBrowse[1]
  OBDOBIw->( dbGoBottom())
  SetAppFocus(drgDialog:odBrowse[2]:oXbp)
RETURN self

*
********************************************************************************
METHOD HIM_MAJOBD_SCR:ItemMarked()
  Local  cScope := StrZero( OBDOBIw->nROK, 4) + StrZero(OBDOBIw->nObdobi, 2)

  ( ::fiMAJOBD)->( mh_SetScope( cScope))
RETURN SELF

********************************************************************************
method HIM_MAJOBD_SCR:comboBoxInit(drgComboBox)
  Local aCombo, nRok, nObd, oMoment

   oMoment := SYS_MOMENT()
  * Soubor OBDOBIw se naplní existujícími obdobími z MAJOBD ( MAJZOBD)
  ( ::fiMAJOBD)->( AdsSetOrder(1), dbGoTOP())
  nRok   := ( ::fiMAJOBD)->nRok
  nObd   := ( ::fiMAJOBD)->nObdobi
  aCombo := { { 1, 'Všechny roky' }}
  * naplníme položky comba a soubor OBDOBIw
  DO WHILE !( ::fiMAJOBD)->( EOF())
    IF nRok = ( ::fiMAJOBD)->nRok
      IF nObd <> ( ::fiMAJOBD)->nObdobi
        OBDOBIw->( dbAppend())
        OBDOBIw->nRok    := nRok
        OBDOBIw->nObdobi := nObd
        *
        nObd  := ( ::fiMAJOBD)->nObdobi
      ENDIF
    ELSE
      aAdd( aCombo, { nRok, 'ROK_' + Str( nRok,4) })
      OBDOBIw->( dbAppend())
      OBDOBIw->nRok    := nRok
      OBDOBIw->nObdobi := nObd
      *
      nRok  := ( ::fiMAJOBD)->nRok
      nObd  := ( ::fiMAJOBD)->nObdobi
    ENDIF
    ( ::fiMAJOBD)->( dbSkip())
  ENDDO
  *
  OBDOBIw->( dbAppend())
  OBDOBIw->nRok    := nRok
  OBDOBIw->nObdobi := nObd
  *
  nPOS := ASCAN( aCombo,{|X| Str(nRok) $ 'X'} )
  IF nPos = 0
    aAdd( aCombo, { nRok, 'ROK_' + Str( nRok,4) })
  ENDIF
  *
  ( ::fiMAJOBD)->( dbGoTOP())
  *
  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( acombo,,, {|aX,aY| aX[2] > aY[2] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  *
  oMoment:destroy()
RETURN self

********************************************************************************
METHOD HIM_MAJOBD_SCR:comboItemSelected( Combo)
  Local Filter

  ::nObdobiFLT := Combo:value
  *
  Do Case
  Case Combo:value = 1                         // Všechny roky
    IF( EMPTY(OBDOBIw->(ads_getAof())), NIL, OBDOBIw->(ads_clearAof(),dbGoTop()) )

  OtherWise                                    // Vybraný rok
    Filter := "nRok = %%"
    Filter := Format( Filter, { Combo:value })
    OBDOBIw->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.

********************************************************************************
METHOD HIM_MAJOBD_SCR:MAJ_Info()
  LOCAL oDialog, cKEY

  drgDBMS:open( ::fiMAJ)
  cKEY :=  IF( ::isHIM, StrZero( (::fiMajOBD)->nTypMaj,3), StrZero( (::fiMajOBD)->nUcetSkup,3) ) + ;
                        StrZero( (::fiMajOBD)->nInvCis, 15)

  ( ::fiMAJ)->( dbSEEK( cKEY,, AdsCtag(1)))
  HIM_MAJ_INFO( ::drgDialog)
RETURN self