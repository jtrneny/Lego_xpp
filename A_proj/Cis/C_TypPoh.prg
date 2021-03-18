********************************************************************************
* C_TYPPOH.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "GRA.Ch"

********************************************************************************
* C_TYPPOH ... Èíselník typù pohybù
********************************************************************************
CLASS C_TYPPOH FROM drgUsrClass
EXPORTED:
  VAR     nTaskFLT
  METHOD  Init, Destroy, ItemMarked, drgDialogStart
  METHOD  comboBoxInit, comboItemSelected
  METHOD  C_TYPPOH_CRD_cpy
  **
  ** EVENT *********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs
    LOCAL  msg      := ::drgDialog:oMessageBar

    DO CASE
//    CASE (nEvent = xbeBRW_ItemMarked)
//      IF(IsObject(::drgGet), NIL, msg:WriteMessage(,0))
//      ::nState := 0
//      ::drgDialog:dialogCtrl:isAppend := (::nState = 2)
//      RETURN .F.

    case nEvent = drgEVENT_APPEND2
//      if cfile = 'c_typpoh'  //.and. (cfile)->npoluctpr <> 0
        ::C_TYPPOH_CRD_cpy()
//        ucetPrit->( dbcommit(), dbunlock())
//        ::oabro[2]:oxbp:goBottom():refreshAll()
//      endif

  * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
      ::setSysFilter()
      return .t.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.



HIDDEN
  VAR     mainBro
ENDCLASS



********************************************************************************
METHOD C_TYPPOH:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::nTaskFLT := 1
  *
  drgDBMS:open('c_Task'  )
  drgDBMS:open('c_TypDok')
  drgDBMS:open('c_TypPoh')
  drgDBMS:open('TypDokl' )
  drgDBMS:open('c_TypPoh',,,,,'c_typpoha' )
  *
RETURN self

*******************************************************************************
METHOD C_TYPPOH:destroy()

  ::drgUsrClass:destroy()
  ::nTaskFlt := ::mainBro :=  Nil
RETURN self

********************************************************************************
METHOD C_TYPPOH:drgDialogStart( drgDialog )
  *
  ::mainBro := drgDialog:odBrowse[1]
RETURN self

********************************************************************************
METHOD C_TYPPOH:ItemMarked()
RETURN SELF

********************************************************************************
method C_TYPPOH:comboBoxInit(drgComboBox)
  Local aCombo, nTask, cTask, cNazTask, n
  *
  C_Task->( AdsSetOrder(1), dbGoTOP())
  aCombo := { { 1, '    Všechny úlohy' }}
  n := 1
  * naplníme položky comba
  DO WHILE !C_Task->( EOF())
    n++
    aAdd( aCombo, { n, C_Task->cTask + '_' + LEFT( C_Task->cNazUlohy, 25) })
    c_Task->( dbSkip())
  ENDDO
  c_Task->( dbGoTOP())
  *
  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( acombo,,, {|aX,aY| aX[2] < aY[2] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

RETURN self

********************************************************************************
METHOD C_TYPPOH:comboItemSelected( Combo)
  Local Filter

  ::nTaskFLT := Combo:value
  *
  Do Case
  Case Combo:value = 1                     // Všechny úlohy
    IF( EMPTY(C_TypPoh->(ads_getAof())), NIL, C_TypPoh->(ads_clearAof(),dbGoTop()) )

  OtherWise                                // Vybraná úloha
    Filter := "cTask = '%%'"
    Filter := Format( Filter, { LEFT( Combo:values[ ::nTaskFLT, 2], 3) })
    c_TypPoh->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  SetAppFocus(::mainBro:oxbp)
RETURN .T.


method C_TYPPOH:C_TYPPOH_CRD_cpy( drgDialog)

  DRGDIALOG FORM 'C_TYPPOH_CRD' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND2

return


********************************************************************************
* C_TYPPOH_CRD ... Karta typu pohybu
********************************************************************************
CLASS C_TYPPOH_crd FROM drgUsrClass
EXPORTED:
  VAR     lNewRec, lApp2
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, postValidate
  METHOD  eventHandled, onSave

HIDDEN
  VAR     dm, dc, df
  METHOD  showItem
ENDCLASS

********************************************************************************
METHOD C_TYPPOH_CRD:init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open( 'C_TypPOHw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP


  ::lApp2   :=  ( parent:cargo = drgEVENT_APPEND2)
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  *
  do case
  case ::lApp2
    mh_CopyFld('C_TypPOH', 'C_TypPOHw', .T.)
    C_TypPOHw->ctyppohybu := ''
    ::lNewREC := .t.

  case ::lNewREC
    C_TypPOHw->( dbAppend())

  otherwise
    mh_CopyFld('C_TypPOH', 'C_TypPOHw', .T.)
  endcase

RETURN self

********************************************************************************
METHOD C_TYPPOH_CRD:drgDialogInit(drgDialog)
RETURN self

********************************************************************************
METHOD C_TYPPOH_CRD:drgDialogStart(drgDialog)
  *
  ::dm        := drgDialog:dataManager
  ::dc        := drgDialog:dialogCtrl
  ::df        := drgDialog:oForm
  *
  ::showItem()
RETURN self

*******************************************************************************
METHOD C_TYPPOH_CRD:destroy()
  *
  ::drgUsrClass:destroy()
  ::lNewRec := Nil
RETURN self

********************************************************************************
METHOD C_TYPPOH_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE  nEvent = drgEVENT_SAVE
     PostAppEvent(xbeP_Close,drgEVENT_EXIT,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD C_TYPPOH_CRD:PostValidate( oVar)
  LOCAL xVar := oVar:get()
  LOCAL cName := UPPER(oVar:name) , cField := Lower(drgParseSecond( cName, '>'))
  LOCAL lChanged := oVar:changed(), lValid := ( ::lNewREC .or. lChanged )
  LOCAL lOK := .T.

  DO CASE
  CASE cField $ 'ctyppohybu,ctask'
    IF lValid
      lOK := ControlDUE( oVar)
      if( cField = 'ctask', ::showItem(), nil )
    ENDIF

  ENDCASE

RETURN lOK

********************************************************************************
METHOD C_TYPPOH_CRD:OnSAVE( isBefore, isAppend )

  IF ! ::dc:isReadOnly
    ::dm:save()
    IF( ::lNewREC, C_TypPOH->( DbAppend()), Nil )
    IF C_TypPOH->(sx_RLock())
       mh_COPYFLD( 'C_TypPOHw', 'C_TypPOH' )
    ENDIF
  ENDIF
RETURN .T.

********************************************************************************
METHOD C_TYPPOH_CRD:showItem()
  Local cTask     := Lower( ::dm:get('C_TypPOHw->cTask'))
  local cpodUloha := lower( ::dm:get('c_typpohW->cpodUloha'))

  *
  IsEditGET( {'C_TypPOHw->nKarta'     }, ::drgDialog, cTask $ 'skl,him,zvi' )

  IsEditGET( {'C_TypPOHw->npredCenZb', ;
              'C_TypPOHw->nstornoDok'  }, ::drgDialog, cTask = 'skl'       )

  IsEditGET( {'C_TypPOHw->lProdukce'   ,;
              'C_TypPOHw->nDrPohPL1'   ,;
              'C_TypPOHw->nDrPohPL2'   ,;
              'C_TypPOHw->nDrPohPLpr'  ,;
              'C_TypPOHw->nPodm'      }, ::drgDialog, cTask = 'zvi' )

* jen pro pohledavky, lye nastavit cvypSAZdan
  IsEditGET( {'C_TypPOHw->cVYPsazDAN' }, ::drgDialog, ( cTask = 'fin' .and. cpodUloha = 'pohledavky') )

RETURN self

********************************************************************************
* Dialog pro výbìr POHYBU
********************************************************************************
CLASS C_TypPoh_SEL FROM drgUsrClass
EXPORTED:
  METHOD  Init, Destroy, EventHandled, getFORM
ENDCLASS

********************************************************************************
METHOD C_TypPoh_SEL:init( parent)
  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD C_TypPoh_SEL:destroy()
  ::drgUsrClass:destroy()
RETURN self

********************************************************************************
METHOD C_TypPoh_SEL:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
  OTHERWISE
    RETURN  .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD C_TypPoh_SEL:getForm()
  Local  oDrg, drgFC

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 70,17 DTYPE '10' TITLE 'Výbìr pohybu ..... ' ;
                                           GUILOOK 'All:N,Border:Y'
  DRGTEXT INTO drgFC CAPTION 'Vyber typ požadovaného dokladu ... ' CPOS 0,16 CLEN 70 PP 2 BGND 15

  DRGDBROWSE INTO drgFC  SIZE 70,14.8 FPOS 0,0 FILE 'C_TypPOH' INDEXORD 2 ;
    FIELDS 'cTypPohybu:Pohyb, cNazTypPoh:Název pohybu:40, cTypDoklad:Typ dokladu, cUloha' ;
    SCROLL 'ny' CURSORMODE 3 PP 7

RETURN drgFC