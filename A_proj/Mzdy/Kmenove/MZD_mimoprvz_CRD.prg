#include "common.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "appevent.ch"
#include "gra.ch"


*
*****************************************************************
CLASS MZD_mimoprvz_CRD FROM drgUsrClass
EXPORTED:
  METHOD  Init
  METHOD  drgDialogInit
  METHOD  drgDialogStart
  METHOD  Destroy
  METHOD  postValidate
  METHOD  onSave
  METHOD  postLastField

  inline method ebro_saveEditRow( o_EBro )
    local  ordRec, recNo, nporMiPVzt := o_EBro:odata:nporMiPVzt
    local  ok := .f.

    if o_ebro:isAppend
      mimPrvzW->ckmenStrPr := MSPRC_MOw->ckmenStrPr
      mimPrvzW->nosCisPrac := MSPRC_MOw->nosCisPrac
      mimPrvzW->nporPraVzt := MSPRC_MOw->nporPraVzt
      mimPrvzW->crodCisPra := MSPRC_MOw->crodCisPra
      mimPrvzW->cpracovnik := MSPRC_MOw->cpracovnik

      mimPrvzW->cnazMimPrv := c_mimprv->cnazMimPrv
      mimPrvzW->cpopisMiPv := c_mimprv->cnazMimPrv

      mimPrvzW->cTmKmStrPr := TMPkmenSTR( MSPRC_MOw->cKmenStrPr)

      do case
      case o_EBro:isAddData  ;  mimPrvzW->nporMiPVzt := nporMiPVzt +1
      otherWise              ;  ok := ::porMimPvzt_and_aktiv(nporMiPVzt,o_EBro)
      endcase
    endif

    if( .not. ok, ::porMimPvzt_and_aktiv( ,o_EBro), nil )
  return .t.
  *
  ** zmìna poøadí a aktivní položky
  inline method porMimPvzt_and_aktiv(nporMiPVzt, o_Ebro)
    local ordRec, recNo, laktiv
    local refreshAll := .f.

    default nporMiPVzt to 0

     recNo := mimPrvzW->(recNo())
    ordRec := fordRec({'mimPrvzW'})
    laktiv := mimPrvzW->laktiv

    if( nporMiPVzt = 0, nil, mimPrvzW->nporMiPVzt := nporMiPVzt )
    mimPrvzW->(ordSetFocus(0),dbgoTop())

    do while .not. mimPrvzW->(eof())
      if nporMiPVzt <> 0
        if mimPrvzW->nporMiPVzt >= nporMiPVzt .and. mimPrvzW->(recNo()) <> recNo
          mimPrvzW->nporMiPVzt := mimPrvzW->nporMiPVzt +1
          refreshAll := .t.
        endif
      endif

      if laktiv
        if mimPrvzW->laktiv .and. laktiv .and. mimPrvzW->(recNo()) <> recNo
          mimPrvzW->laktiv := .f.
          refreshAll       := .t.
        endif
      endif

      mimPrvzW->(dbskip())
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
      ::drgDialog:oForm:setNextFocus('MIMPRVZw->nMimoPrVzt',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_APPEND
      nRECs := MIMPRVZw->( RecNo())
               MIMPRVZw->( DbGoTo(0))
               ::dm:refresh()

               MIMPRVZw->( DbGoTo(nRECs))

      ::nState := 2
      ::drgDialog:oForm:setNextFocus('MIMPRVZw->nMimoPrVzt',, .T. )
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

*        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
*        IF(::nState = 2, ::bro:oXbp:GoTop():refreshAll(), ::bro:refresh())
*        ::dm:refresh()
*        RETURN .T.
*      ELSE

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
METHOD MZD_mimoprvz_CRD:init(parent)
  LOCAL nEvent,mp1,mp2,oXbp
  LOCAL cKEYs  := ' '
  LOCAL lDOPLN := .T.
  LOCAL lGENrec
  LOCAL x

  ::drgUsrClass:init(parent)
  ::lNEWrec  := .T.
  ::drgGet   := NIL

  drgDBMS:open('MIMPRVZw'  ,.T.,.T.,drgINI:dir_USERfitm)

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))
  IF parent:cargo = drgEVENT_EDIT
    cKy     := STRZERO(MSPRC_MOw->nRok,4) +STRZERO(MSPRC_MOw->nObdobi,2)           ;
                +STRZERO(MSPRC_MOw->nOsCisPrac,5) +STRZERO(MSPRC_MOw->nPorPraVzt,3)
    ::lNEWrec := .F.
  ENDIF

RETURN self



METHOD MZD_mimoprvz_CRD:drgDialogInit(drgDialog)
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


METHOD MZD_mimoprvz_CRD:drgDialogStart(drgDialog)
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

**  IF( .not.  MIMPRVZw->( Eof()), drgDialog:oForm:nextFocus := x, NIL )
**  ::dm:refresh()
//  MIMPRVZw->( AdsSetOrder( 3))
//  MIMPRVZw->( dbGoTop())

RETURN self


*
*****************************************************************
METHOD MZD_mimoprvz_CRD:postValidate(drgVar)
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
  case( cname = 'mimprvzw->nmimoprvzt' )
    ::dm:set('mimprvzW->cnazMimPrv', c_mimprv->cnazMimPrv )

  endcase

  IF lNewRec .OR. lChanged
    DO CASE
    CASE cName = 'MIMPRVZw->lAktiv'
    CASE cName = Upper('MIMPRVZw->dMimPrVzOd')
//      &(drgVar:name) := drgVar:Value
//      MIMPRVZw->( dbCommit())

//      ::cNazGenDMZ1  := VratDMZ(xVar)
//      lRefreshALL := .T.
//
    ENDCASE

    dm:refresh(.T.)

  ENDIF

RETURN .T.


*
*****************************************************************
METHOD MZD_mimoprvz_CRD:onSave(lIsCheck,lIsAppend)                        // kotroly a výpoèty po uložení
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
METHOD MZD_mimoprvz_CRD:destroy()
//  W_PODRUC ->(DbClearRelation())
RETURN SELF


*
*********FIRMY_FIRMYUC_FIRMYFI_FIRMYDA_CPODRUC**********************************
STATIC FUNCTION MzMimoPrVz_WRT(lNEWrec)
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


METHOD MZD_mimoprvz_CRD:postLastField(drgVar)
  LOCAL  lZMENa := ::dm:changed()

  // ukládáme POKLADMS na posledním PRVKU //
  IF lZMENa
    IF ::nState = 2
      ADDrec('MIMPRVZw')
      MIMPRVZw->cKmenStrPr := MSPRC_MOw->cKmenStrPr
      MIMPRVZw->cRodCisPra := MSPRC_MOw->cRodCisPra
      MIMPRVZw->nOsCisPrac := MSPRC_MOw->nOsCisPrac
      MIMPRVZw->nPorPraVzt := MSPRC_MOw->nPorPraVzt
      MIMPRVZw->cPracovnik := MSPRC_MOw->cPracovnik
      MIMPRVZw->cTmKmStrPr := TMPkmenSTR( MSPRC_MOw->cKmenStrPr)
      MIMPRVZw->nMimoPrVzt := LastPORADI()
      MIMPRVZw->( dbCommit())
    ELSE
      REPLrec('MIMPRVZw')
    ENDIF
    ::dm:save()
  ENDIF
  SetAppFocus(::bro:oXbp)
RETURN .T.


FUNCTION LastPORADI()
  LOCAL nOLDtag, nOLDrec
  LOCAL nRET

  nOLDtag := MIMPRVZw->( AdsSetOrder(1))
  nOLDrec := MIMPRVZw->( Recno())
  MIMPRVZw->( dbGoBotTom())
  nRET    := MIMPRVZw->nMimoPrVzt + 1
  MIMPRVZw->( AdsSetOrder(nOLDtag))
  MIMPRVZw->( dbGoTo(nOLDrec))

RETURN( nRET)