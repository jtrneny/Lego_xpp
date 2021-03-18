********************************************************************************
* ZVI_zsbPohybyIT_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*===============================================================================
FUNCTION ZVI_zsbPohybyIT_1()
RETURN AllTrim( STR( ZvZmenITw->( RecNO()))) + '.'

********************************************************************************
CLASS ZVI_zsbZvZmenIT_Scr FROM drgUsrClass

EXPORTED:
  VAR     lNewRec, nKarta
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart
  METHOD  PostValidate, EventHandled
  METHOD  OnSave, ebro_beforeAppend, ebro_afterAppend
HIDDEN
  VAR     parentDlg
  VAR     dm, dc, prevdm
ENDCLASS

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::parentDlg := parent:parentDialog:cargo
  ::nKarta := ::parentDlg:Udcp:nKarta
  ::prevdm := ::parentDlg:dataManager
  *
  ::lNewRec := .F. // .T. 14.6.11
  *
  drgDBMS:open( 'ZvZmenITw' ,.T.,.T.,drgINI:dir_USERfitm)   // ; ZAP
  *
  IF ZvZmenITw->nDoklad <> ::prevdm:get('ZvZmenHDw->nDoklad')
    ZvZmenITw->( dbZAP())
  ENDIF
  *
  drgDBMS:open( 'ZVIRATA',,,,,'ZVIRATAa')
  drgDBMS:open( 'MAJZ'   ,,,,,'MAJZa'   )
  *
*  _clearEventLoop(.t.) // 14.6.11
RETURN self

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   // .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
    IF ZvZmenITw->(LastRec()) = ::drgDialog:parentDialog:cargo:dataManager:get( 'ZvZmenHDw->nKusyZv')
       drgMsgBox(drgNLS:msg( 'Nelze poøídit více kusù'))
       RETURN .T.
    ENDIF
    ::lNewRec := .T.
    ZvZmenITw->( dbGoTO(-1) )
    ::dm:refresh()
*    ::drgDialog:oForm:setNextFocus( 'ZvZmenITw->cZvireZem',, .t. )
    ::drgDialog:oForm:setNextFocus( 'ZvZmenITw->nInvCis',, .t. )
    ::dm:set('ZvZmenITw->cZvireZem' , 'CZ' )
    ::dm:set('ZvZmenITw->cMatkaZem' , 'CZ' )
    IF ::nKarta <> 610
      ::dm:set('ZvZmenITw->dNarozZvir', ::prevdm:get('ZvZmenHDw->dDatZmZV') )
    ENDIF

  CASE  nEvent = drgEVENT_EDIT
    ::lNewRec := .F.
    ::drgDialog:oForm:setNextFocus( 'ZvZmenITw->cZvireZem',, .t. )
* 30.8.2011
  CASE  nEvent = drgEVENT_SAVE
*    ::OnSave( .F.,  ::lNewREC )
    RETURN .T.
*/
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
          oXbp:setColorBG( oXbp:cargo:clrFocus )
        ENDIF
        *
        SetAppFocus(::dc:oaBrowse:oXbp)
        ::dm:refresh()
        ::dc:isAppend := .F.
        RETURN .T.
      ELSE    // IF mp1 == xbeK_ENTER //.and. oXbp:ClassName() = 'XbpBrowse'
        RETURN .F.
      ENDIF

  CASE nEvent = xbeM_LbClick
    IF oXbp:ClassName() = 'XbpGet'
      ::lNewRec := .F.
    ENDIF
    RETURN .F.

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
  XbpDialog:titleBar := .T.
  drgDialog:formHeader:title := 'Individuální evidence'
*    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
  aPos := mh_GetAbsPosDlg( drgDialog:parentDialog,drgDialog:dataAreaSize)
  drgDialog:usrPos := {aPos[1] + 240, aPos[2] + 100}
*  XbpDialog:setFrameState( XBPDLG_FRAMESTAT_MAXIMIZED)
RETURN

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:drgDialogStart(drgDialog)
  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  * Porod umožnit editovat jen u DP narození ( tj. karta 431)
  IsEditGET( {'ZvZmenITw->nPorod' }, ::drgDialog, ::nKarta = 431 )
RETURN self

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:PostValidate(oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lOK := .T., lExist, lValid := lChanged .or. ::lNewRec
  LOCAL cName := oVar:Name, cKey
  Local nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)

  DO CASE
  CASE cName = 'ZvZmenITw->nInvCis'
    IF lValid
      IF ( lOK := ControlDUE( oVar) )
         * U výdeje se kontroluje existence zvíøete v organizaèní jednotce
         If C_TypPoh->nTypPohyb = -1 .AND. Upper( ZvKarty->cTypEvid) = 'I'
            cKey := Upper( ZvKarty->cNazPol1) + Upper( ZvKarty->cNazPol4) + ;
                    StrZero( ZvKarty->nZvirKat, 6) + StrZero( xVar, 15) + '1'
            IF !( lOK := ZVIRATAa->( dbSEEK( cKey,, 'ZVIRATA09')) )
              drgMsgBox(drgNLS:msg( 'Inventární èíslo [ & ] neexistuje !', xVar))
              RETURN .F.
            ENDIF
            //-
            If lOK   //- U pøevodu kontrola pøíjmové èásti
              nPos := ASCAN( { 600, 610, 620 }, C_TypPoh->nKarta )
              IF nPos > 0   // pøíjmy u pøevodu
                cKey := Upper( ::prevdm:get( 'ZvZmenHDw->cNazPol1_n')) + ;
                        Upper( ::prevdm:get( 'ZvZmenHDw->cNazPol4_n')) + ;
                        StrZero( ::prevdm:get( 'ZvZmenHDw->nZvirKat_n'), 6) + ;
                        StrZero( xVar, 15) + '1'
                IF( lOK := ZVIRATAa->( dbSeek( cKey,,'ZVIRATA09'))  )
                  lOK := NO
                  drgMsgBox(drgNLS:msg( 'Duplicitní položka: Støedisko + Stáj + Kategorie + Inv.èíslo !'))
                ELSE
                  lOK := YES
                ENDIF
              ENDIF
            ENDIF
            *
            IF lOK
              cKEY := StrZero( xVar, 15) + space(8)
              lOK := ZVIRATAa->( dbSEEK( cKey,,'ZVIRATA05'))
              IF !lOK .OR. ZVIRATAa->nKusy = 0
                lOK := NO
                drgMsgBox(drgNLS:msg( 'Inventární èíslo [ & ] NENALEZENO !', xVar ))
              ELSE
                lOK := YES
                ::dm:set( 'ZvZmenITw->cPlemeno'  , ZVIRATAa->cPlemeno)
                ::dm:set( 'ZvZmenITw->nInvCisMat', ZVIRATAa->nInvCisMat)
                ::dm:set( 'ZvZmenITw->nPohlavi'  , ZVIRATAa->nPohlavi)   // new 18.10.2010
              ENDIF
            ENDIF
            *
         EndIf
         * U pøíjmu se kontroluje duplicita v organizaèní jednotce
         IF C_TypPoh->nTypPohyb == 1 .AND. Upper( ZvKarty->cTypEvid) == 'I'
            cKey := Upper( ZvKarty->cNazPol1) + Upper( ZvKarty->cNazPol4) + ;
                    StrZero( ZvKarty->nZvirKat, 6) + StrZero( xVar) + '1'
            IF( lOK := ZVIRATAa->( dbSeek( cKey,,'ZVIRATA09'))  )
              lOK := NO
              drgMsgBox(drgNLS:msg( 'Duplicitní položka: Støedisko + Stáj + Kategorie + Inv.èíslo !'))
            ELSE
              lOK := YES
            ENDIF
         ENDIF
         * Kus nesmí být v dokladu uveden vícekrát

         If lOK .and. ::lNewRec
           lExist := .F.
           nRec := ZvZmenITw->( RecNO())
           ZvZmenITw->( dbEval( {|| lExist := IF( lExist, lExist, ( ZvZmenITw->nInvCis = xVar) ) } ))
           ZvZmenITw->( dbGoTO( nRec))
           IF lExist
              drgMsgBox(drgNLS:msg( 'Inventární èíslo [ & ] již bylo poøízeno !', xVar))
              lOK := .F.
           ENDIF

           cKey := StrZero( ZvKarty->nZvirKat, 6) + StrZero( xVar, 15)
           If ZVIRATAa->( dbSeek( cKey,,'ZVIRATA02'))
             ::dm:set( 'ZvZmenITw->nInvCisMat', ZVIRATAa->nInvCisMat)
             ::dm:set( 'ZvZmenITw->nPohlavi'  , ZVIRATAa->nPohlavi)
             ::dm:set( 'ZvZmenITw->dNarozZvir', ZVIRATAa->dNarozZvir)
           Else
             ::dm:set( 'ZvZmenITw->nInvCisMat', 0)
           Endif
         Endif
         * Pøi pøevodu do zákl. stáda nesmí kus již existovat v MAJZ
         If lOK .and. ::nKARTA == 610
  *         cKey := StrZero( ZvZmenHDw->nUcetSkupN, 3) + StrZero( xVar, 10)
           cKey := StrZero( KategZvi->nUcetSkup, 3) + StrZero( xVar, 15)
           If ( lOK := MAJZa->( dbSeek( cKey,, 'MAJZ_01')) )
             drgMsgBox(drgNLS:msg( 'Inventární èíslo [ & ] již v základním stádu existuje !', xVar))
           EndIf
           lOK := !lOK
         Endif
      ENDIF
    ENDIF

  CASE cName = 'ZvZmenITw->cPlemeno'

    * U skotu je plemeno povinné, u prasat ne
    IF ( Upper( ZvKARTY->cTypZVR) = 'S')
      IF Empty( xVar)
        PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
        lOk := .f.
      ENDIF
    ENDIF

  CASE cName = 'ZvZmenITw->nInvCisMat'
    * Validovat pouze u narození zvíøete
    IF ::nKARTA == 431
      IF ( lOK := ControlDUE( oVar) )
        If !( lOK := ZVIRATAa->( dbSeek( xVar,, 'ZVIRATA03')) )
          drgMsgBox(drgNLS:msg( 'Inventární èíslo matky [ & ] nenalezeno !', xVar ))
        Endif
      ENDIF
    ENDIF
    *
    If( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN .and. lOK)
      PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
    EndIf
    *
  ENDCASE

RETURN lOK

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:ebro_beforeAppend()

  IF ZvZmenITw->(LastRec()) = ::drgDialog:parentDialog:cargo:dataManager:get( 'ZvZmenHDw->nKusyZv')
     drgMsgBox(drgNLS:msg( 'Nelze poøídit více kusù'))
     RETURN .F.
  ENDIF
  ::lNewRec := .T.
Return .T.

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:ebro_afterAppend( ebro)
  ::dm:set('ZvZmenITw->cZvireZem' , 'CZ' )
  ::dm:set('ZvZmenITw->cMatkaZem' , 'CZ' )
  IF ::nKarta <> 610
    ::dm:set('ZvZmenITw->dNarozZvir', ::prevdm:get('ZvZmenHDw->dDatZmZV') )
  ENDIF
  *
*  ::drgDialog:oForm:setNextFocus( 'ZvZmenITw->nInvCis',, .t. )
RETURN self

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:OnSave(isBefore, isAppend)

  IF ::drgDialog:dialogCtrl:isReadOnly
    RETURN .T.
  ENDIF
  *
  IF ( lOK := if( ::lNewREC, AddREC('ZvZmenITw'), ReplREC('ZvZmenITw')) )
    ::dm:save()
    ZvZmenITw->nDoklad := ::prevdm:get('ZvZmenHDw->nDoklad')
    ZvZmenITw->( dbUnlock())
    ::dc:oaBrowse:refresh()
    SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
    ::dm:refresh()
    ::lNewREC :=  .F.
  ENDIF

RETURN self

********************************************************************************
METHOD ZVI_zsbZvZmenIT_Scr:destroy()

  ::drgUsrClass:destroy()
  ::lNewREC := ::nKarta :=  ;
  ::parentDlg := ::dm := ::dc := ::prevdm := ;
   Nil
RETURN self