#include "common.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "appevent.ch"
#include "gra.ch"


*
*****************************************************************
CLASS MZD_duchody_CRD FROM drgUsrClass
EXPORTED:
  METHOD  Init
  METHOD  drgDialogInit
  METHOD  drgDialogStart
  METHOD  Destroy
  METHOD  postValidate
  METHOD  onSave
  METHOD  GetInitValues
  METHOD  postLastField

  METHOD  itemSelected


  inline method ebro_saveEditRow( o_EBro )
    local  ordRec, recNo, nporDuchod := o_EBro:odata:nporDuchod
    local  ok := .f.

    if o_ebro:isAppend
      duchodyW->ckmenStrPr := MSPRC_MOw->ckmenStrPr
      duchodyW->nosCisPrac := MSPRC_MOw->nosCisPrac
      duchodyW->crodCisPra := MSPRC_MOw->crodCisPra
      duchodyW->cpracovnik := MSPRC_MOw->cpracovnik

      duchodyW->cnazDuchod := c_duchod->cnazDuchod
      duchodyW->cpopisDuch := c_duchod->cnazDuchod

      duchodyW->cTmKmStrPr := TMPkmenSTR( MSPRC_MOw->cKmenStrPr)

      do case
      case o_EBro:isAddData ;  duchodyW->nporDuchod := nporDuchod +1
      otherWise             ;  ok := ::porDuchod_and_aktiv(nporDuchod,o_EBro)
      endcase
    endif

    if( .not. ok, ::porDuchod_and_aktiv( ,o_EBro), nil )
  return .t.
  *
  ** zmìna poøadí a aktivní položky
  inline method porDuchod_and_aktiv(nporDuchod, o_Ebro)
    local ordRec, recNo, laktiv
    local refreshAll := .f.

    default nporDuchod to 0

     recNo := duchodyW->(recNo())
    ordRec := fordRec({'duchodyW'})
    laktiv := duchodyW->laktiv

    if( nporDuchod = 0, nil, duchodyW->nporDuchod := nporDuchod )
    duchodyW->(ordSetFocus(0),dbgoTop())

    do while .not. duchodyW->(eof())
      if nporDuchod <> 0
        if duchodyW->nporDuchod >= nporDuchod .and. duchodyW->(recNo()) <> recNo
          duchodyW->nporDuchod := duchodyW->nporDuchod +1
          refreshAll := .t.
        endif
      endif

      if laktiv
        if duchodyW->laktiv .and. laktiv .and. duchodyW->(recNo()) <> recNo
          duchodyW->laktiv := .f.
          refreshAll       := .t.
        endif
      endif

      duchodyW->(dbskip())
    enddo

    fordRec()

    if refreshAll
*      (o_EBro:oxbp:lockUpdate(.t.), o_EBro:oxbp:refreshAll(), o_EBro:oxbp:lockUpdate(.f.) )
      o_EBro:oxbp:refreshAll()
    endif
  return .t.

  inline method save_marked()
    postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc     := ::drgDialog:dialogCtrl
    LOCAL  dbArea := ALIAS(SELECT(dc:dbArea))


    DO CASE
    CASE (nEvent = drgEVENT_EXIT)
    CASE (nEvent = xbeBRW_ItemMarked)
*      IF ::dm:changed()
*        IF drgIsYESNO(drgNLS:msg('Data has been changed.;; Save changes?'))
*          ::dm:save()
*        ENDIF
*      ENDif
*      ::dm:refresh()
//      ::msg:WriteMessage(,0)
      ::nState := 0
//      ::showGroup()
      RETURN .F.

    CASE nEvent = drgEVENT_EDIT
      ::nState := 1
      ::drgDialog:oForm:setNextFocus('DUCHODYw->nMimoPrVzt',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_APPEND
      nRECs := DUCHODYw->( RecNo())
               DUCHODYw->( DbGoTo(0))
               ::dm:refresh()

               DUCHODYw->( DbGoTo(nRECs))

      ::nState := 2
      ::drgDialog:oForm:setNextFocus('DUCHODYw->nMimoPrVzt',, .T. )
      RETURN .T.


    CASE nEvent = drgEVENT_DELETE
      IF ALIAS(SELECT(dc:dbArea)) = 'W_PODRUC'                                  // not for C_PODRUCw
        IF drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?') )
           // smazat a refresch
//           mh_BLANKREC('W_PODRUC',2)
           PostAppEvent(drgEVENT_ACTION,drgEVENT_REFRESH,'1',oXbp)
         ENDIF
       RETURN .T.
      ENDIF

*    CASE nEvent = xbeP_Keyboard
*      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
//        ::drgDialog:oForm:setNextFocus(1,, .T. )
//         RETURN .T.
*        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
*          oXbp:setColorBG( oXbp:cargo:clrFocus )
*        ENDIF
*
*        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
*        IF(::nState = 2, ::bro:oXbp:GoTop():refreshAll(), ::bro:refresh())
*        ::dm:refresh()
*        RETURN .T.
*      ELSE
*
*        RETURN .F.
*      ENDIF

    case( nevent = xbeP_Keyboard )
      if mp1 = xbeK_ALT_P
        postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        return .t.
      endif
      return .f.

    CASE (nEvent = drgEVENT_QUIT)
//      ::drgDialog:dataManager:save()

//      ReSUModpocty()
      RETURN .F.
    OTHERWISE
//      ::drgDialog:dataManager:save()
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
 VAR   lNEWrec
 VAR   drgGet
 VAR   nState      // 0 - inBrowse  1 - inEdit  2 - inAppend
 VAR   msg, dm, bro


ENDCLASS

*
*****************************************************************
METHOD MZD_duchody_CRD:init(parent)
  LOCAL nEvent,mp1,mp2,oXbp
  LOCAL cKEYs  := ' '
  LOCAL lDOPLN := .T.
  LOCAL lGENrec
  LOCAL x

  ::drgUsrClass:init(parent)
  ::lNEWrec  := .T.
  ::drgGet   := NIL

  drgDBMS:open('DUCHODYw'  ,.T.,.T.,drgINI:dir_USERfitm)

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))
  IF parent:cargo = drgEVENT_EDIT
    cKy     := STRZERO(MSPRC_MOw->nRok,4) +STRZERO(MSPRC_MOw->nObdobi,2)           ;
                +STRZERO(MSPRC_MOw->nOsCisPrac,5) +STRZERO(MSPRC_MOw->nPorPraVzt,3)
    ::lNEWrec := .F.
  ENDIF

RETURN self



METHOD MZD_duchody_CRD:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  drgDialog:hasIconArea   := .F.
*  drgDialog:hasActionArea := .F.
*  drgDialog:hasMsgArea    := .F.
*  drgDialog:hasMenuArea   := .F.
*  drgDialog:hasBorder     := .F.
*  XbpDialog:titleBar      := .F.


  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN


METHOD MZD_duchody_CRD:drgDialogStart(drgDialog)
 LOCAL x, members  := drgDialog:oForm:aMembers

  ::msg := drgDialog:oMessageBar
  ::dm  := drgDialog:dataManager

  BEGIN SEQUENCE
    FOR x := 1 TO LEN(members)
      IF members[x]:ClassName() = 'drgBrowse'
        ::bro := members[x]
  BREAK
      ENDIF
    NEXT
  ENDSEQUENCE

*  IF( .not.  DUCHODYw->( Eof()), drgDialog:oForm:nextFocus := x, NIL )
*  ::dm:refresh()
//  DUCHODYw->( AdsSetOrder( 3))
//  DUCHODYw->( dbGoTop())

RETURN self

METHOD MZD_duchody_CRD:itemSelected(drgCheckBox)
 &(drgCheckBox:name) := drgCheckBox:Value
// ::drgDialog:dataManager:save()
 DUCHODYw->( dbCommit())
 ::drgDialog:dialogCtrl:obrowse[1]:refresh(.T.)
 ::drgDialog:dataManager:refresh(.T.)
RETURN

*
*****************************************************************
METHOD MZD_duchody_CRD:postValidate(drgVar)
  LOCAL cName    := lower( drgVar:Name)
  LOCAL xVar     := drgVar:get()
  Local lNewRec  := ::drgDialog:dialogCtrl:isAppend
  Local lChanged := drgVar:changed()
  Local dm       := ::drgDialog:dataManager
  Local aValues  := dm:vars:values
  LOCAL lRefreshALL := .T.

// kotroly a výpoèty
// nastavení doprovodných textù u nejednoznaèných položek

  do case
  case( cname = 'duchodyw->ntypduchod' )
    ::dm:set('duchodyW->cnazDuchod', c_duchod->cnazDuchod )

  endcase

  IF lNewRec .OR. lChanged
    DO CASE
    CASE cName = 'DUCHODYw->lAktiv'
    CASE cName = Upper('DUCHODYw->dMimPrVzOd')
//      &(drgVar:name) := drgVar:Value
//      DUCHODYw->( dbCommit())

//      ::cNazGenDMZ1  := VratDMZ(xVar)
//      lRefreshALL := .T.
//
    ENDCASE

    dm:refresh(.T.)

  ENDIF

RETURN .T.


*
*****************************************************************
METHOD MZD_duchody_CRD:onSave(lIsCheck,lIsAppend)                        // kotroly a výpoèty po uložení
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  cALIAs   := ALIAS(dc:dbArea)

  IF !lIsCheck

//    IF (cALIAs) ->nCISFIRMY == 0
//      (cALIAs) ->nCISFIRMY := FIRMYw ->nCISFIRMY
//    ENDIF
  ENDIF
RETURN .T.


*
*****************************************************************
METHOD MZD_duchody_CRD:destroy()
//  W_PODRUC ->(DbClearRelation())
RETURN SELF


*
*********FIRMY_FIRMYUC_FIRMYFI_FIRMYDA_CPODRUC**********************************
STATIC FUNCTION MzDuchody_WRT(lNEWrec)
  LOCAL  nCISFIRMY := FIRMYw ->nCISFIRMY
/*
  IF FIRMY_ALL(1)
   IF lNEWrec  ;  FordRec( { 'FIRMY,1' } )
                  nCISFIRMY := FIRMYw ->nCISFIRMY
                  IF FIRMY ->( DbSeek(nCISFIRMY))
                    FIRMY ->( DbGoBottom())
                    nCISFIRMY := FIRMY ->nCISFIRMY +1
                  ENDIF
                  FordRec()
   ENDIF

   FIRMY_ALL(0,nCISFIRMY)
  ELSE
    drgMsgBox(drgNLS:msg('Nelze modifikovat FIRMY, blokováno uživatelem !!!'))
  ENDIF
*/
RETURN .T.


METHOD MZD_duchody_CRD:GetInitValues(oComboBox)
  LOCAL  cTYPfak := ''

//  FIN_CTYPFAK ->( AdsSetOrder(3), ;
//  dbEVAL( {|| If( FIN_CTYPFAK ->nFINTYP == 1, cTYPfak += STR(SET_typ(FIN_CTYPFAK ->cCRDNAME)) +':' +FIN_CTYPFAK ->cPOPISFAK +',', NIL ) } ) )
RETURN( cTYPfak)


METHOD MZD_duchody_CRD:postLastField(drgVar)
  LOCAL  lZMENa := ::dm:changed()

  // ukládáme POKLADMS na posledním PRVKU //
  IF lZMENa
    IF ::nState = 2
      ADDrec('DUCHODYw')
      DUCHODYw->cKmenStrPr := MSPRC_MOw->cKmenStrPr
      DUCHODYw->cRodCisPra := MSPRC_MOw->cRodCisPra
      DUCHODYw->nOsCisPrac := MSPRC_MOw->nOsCisPrac
      DUCHODYw->nPorPraVzt := MSPRC_MOw->nPorPraVzt
      DUCHODYw->cPracovnik := MSPRC_MOw->cPracovnik
      DUCHODYw->cTmKmStrPr := TMPkmenSTR( MSPRC_MOw->cKmenStrPr)
      DUCHODYw->nMimoPrVzt := LastPORADI()
      DUCHODYw->( dbCommit())
    ELSE
      REPLrec('DUCHODYw')
    ENDIF
    ::dm:save()
  ENDIF
  SetAppFocus(::bro:oXbp)
RETURN .T.


FUNCTION AktivDuchod()
RETURN IF(DUCHODYw->lAktiv, DRG_ICON_SELECTT, DRG_ICON_SELECTF)


STATIC FUNCTION LastPORADI()
  LOCAL nOLDtag, nOLDrec
  LOCAL nRET

  nOLDtag := DUCHODYw->( AdsSetOrder(1))
  nOLDrec := DUCHODYw->( Recno())
  DUCHODYw->( dbGoBotTom())
  nRET    := DUCHODYw->nMimoPrVzt + 1
  DUCHODYw->( AdsSetOrder(nOLDtag))
  DUCHODYw->( dbGoTo(nOLDrec))

RETURN( nRET)