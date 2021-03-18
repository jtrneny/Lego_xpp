/*==============================================================================
  ZVI_KategZvi_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
*
********************************************************************************
CLASS ZVI_KategZvi_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, drgDialogStart, EventHandled

ENDCLASS

********************************************************************************
METHOD ZVI_KategZvi_SCR:Init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('C_UctSkZ' )
RETURN self

********************************************************************************
METHOD ZVI_KategZvi_SCR:drgDialogStart(drgDialog)
  KategZVI->( DbSetRelation( 'C_UctSkZ' , {|| KategZVI->nUcetSkup } ,'KategZVI->nUcetSkup'))
RETURN self

********************************************************************************
METHOD ZVI_KategZvi_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      *
      IF drgIsYESNO(drgNLS:msg( 'Zrušit kategorii zvíøete [ & ] - &  ?' , KategZVI->nZvirKAT, KategZVI->cNazevKAT ) )
        If KategZVI->( sx_RLock())
          KategZVI->( DbDelete(), DbUnlock() )
          oXbp:cargo:refresh()
        ENDIF
      ENDIF
      *
    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.


********************************************************************************
*
********************************************************************************
CLASS ZVI_KategZvi_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC

  METHOD  Init, Destroy, drgDialogStart, EventHandled
  METHOD  PostValidate, tabSelect, comboBoxInit
  METHOD  OnSave

HIDDEN
  VAR     dm, dc, tabNum, broZvKarty
  METHOD  sumColumn
ENDCLASS

********************************************************************************
METHOD ZVI_KategZvi_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  *
  drgDBMS:open('C_DanSkp'  )
  drgDBMS:open('C_UcetSkp' )
  drgDBMS:open('cNazPOL4'  )
  drgDBMS:open('C_Aktiv'   )
  drgDBMS:open('C_AktivD'  )
  drgDBMS:open('KategZVIw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  IF ::lNewREC
    KategZVIw->(dbAppend())
    KategZVIw->cTypVypCEN := 'PRU'
    KategZVIw->nPohlavi   := 1
    KategZVIw->cTypEvid   := 'I'
    KategZVIw->nTypVypCEL := 1
  ELSE
    mh_COPYFLD('KategZVI', 'KategZVIw', .T.)
  ENDIF

RETURN self

********************************************************************************
METHOD ZVI_KategZvi_CRD:drgDialogStart(drgDialog)

  ::dm         := ::drgDialog:dataManager
  ::dc         := drgDialog:dialogCtrl
  ::broZvKarty := ::dc:oBrowse[1]:oXbp
  *
  ZvKarty->( DbSetRelation( 'cNazPOL4'  , {|| ZvKarty->cNazPol4 }   ,'ZvKarty->cNazPol4'))
  IF ( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )
RETURN self

********************************************************************************
METHOD ZVI_KategZvi_CRD:tabSelect( tabPage, tabNumber)

  IF tabNumber = 2
    IF( ::lNewREC, ::OnSave( .F., ::lNewREC ), NIL )
    ZvKarty->( mh_SetScope( KategZVI->nZvirKat))
    ::drgDialog:dialogCtrl:oaBrowse:refresh()
    ::sumColumn()
  ENDIF
  ::tabNUM := tabNumber
RETURN .T.

********************************************************************************
METHOD ZVI_KategZvi_CRD:comboBoxInit(drgComboBox)
  LOCAL  cNAME := drgParse(drgComboBox:name), aCombo := {}
  Local  cAlias := IF( cName = 'KategZVIw->nZnAkt', 'C_Aktiv', 'C_AktivD')
  Local  nRec
  *
  DO CASE
  CASE cName = 'KategZVIw->nZnAkt' .or. cName = 'KategZVIw->nZnAktD'
    IF cAlias = 'c_Aktiv'
      nRec := (cAlias)->( RecNo())
      (cAlias)->( dbEVAL( {|| AADD( aCombo, { (cAlias)->nZnakAkt, alltrim( str((cAlias)->nZnakAkt) + ' - ' + (cAlias)->cPopisAkt)} ) }))
      (cAlias)->( dbGoTO( nRec))
    ELSEIF cAlias = 'c_AktivD'
      nRec := (cAlias)->( RecNo())
      (cAlias)->( dbEVAL( {|| AADD( aCombo, { (cAlias)->nZnakAktD, alltrim( str((cAlias)->nZnakAktD) + ' - ' + (cAlias)->cPopisAkt)} ) }))
      (cAlias)->( dbGoTO( nRec))
    ENDIF
    IF LEN( aCombo) <> 0
      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCombo,,, {|aX,aY| aX[1] < aY[1] } )
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2])})
      drgComboBox:value := IF( cAlias = 'c_Aktiv', KategZVIw->nZnAkt, KategZVIw->nZnAktD )
    ENDIF
  ENDCASE
  *
RETURN self

********************************************************************************
METHOD ZVI_KategZvi_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

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
METHOD ZVI_KategZvi_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cNAMe := UPPER(oVar:name), nRec, cMsg

  IF lValid
    DO CASE
    CASE cName = 'KategZVIw->nZvirKAT'
      IF( lOK := ControlDUE( oVar) )
        nRec := KategZVI->( RecNo())
        IF ( lOK := KategZVI->( dbSeek( xVar)) )
          cMsg := 'DUPLICITA !;; Kategorie s tímto oznaèením již existuje !'
          drgMsgBox(drgNLS:msg( cMsg,, ::drgDialog:dialog))
        ENDIF
        KategZVI->( dbGoTo( nRec))
        lOK := !lOK
        IF( lOK, ::dm:set( 'KategZVIw->nZvirKAT', xVar ), NIL )
      ENDIF

    CASE cName = 'KategZVIw->cTypEvid' .or. cName = 'KategZVIw->cTypVypCEL' .or. ;
         cName = 'KategZVIw->cNazPol2' .or. cName = 'KategZVIw->cTypVypCen'
      lOK := ControlDUE( oVar)

    CASE cName = 'KategZVIw->nUcetSkup'
      lOK := ControlDUE( oVar,.F.)
    ENDCASE
  ENDIF

RETURN lOK

*******************************************************************************
METHOD ZVI_KategZvi_CRD:OnSave(lIsCheck,lIsAppend,drgDialog)
  LOCAL nREC

    IF ! ::drgDialog:dialogCtrl:isReadOnly
*      ::dm:save()
      ::drgDialog:dataManager:save()
      IF( ::lNewREC, KategZvi->( DbAppend()), Nil )
      IF KategZvi->(sx_RLock())
         mh_COPYFLD('KategZVIw', 'KategZVI' )
         IF C_DanSkp->( dbSeek( upper( KategZVI->cOdpiSkD),, 'C_DANSKP1'))
           KategZVI->nOdpiSkD := C_DanSkp->nOdpiSkD
         ENDIF
         IF C_UcetSkp->( dbSeek( upper( KategZVI->cOdpiSk),, 'C_UCETSKP1'))
           KategZVI->nOdpiSk := C_UcetSkp->nOdpiSk
         ENDIF

         KategZVI->( dbUnlock())
      ENDIF
    ENDIF

RETURN .T.

** HIDDEN **********************************************************************
METHOD ZVI_KategZvi_CRD:sumColumn()
  LOCAL nRec := ZvKarty->( RecNo())
  Local nMnozsZV := 0.0000, nKusyZv := 0, nCenacZV := 0.00, nPos
  Local aItems, x

  ZvKarty->( dbGoTOP(),;
             dbEVAL( {|| nMnozsZV += ZvKarty->nMnozsZV ,;
                         nKusyZV  += ZvKarty->nKusyZV  ,;
                         nCenacZV += ZvKarty->nCenacZV }),;
             dbGoTO( nRec) )
  aItems := { {'ZvKarty->nMnozsZV', nMnozsZV } ,;
              {'ZvKarty->nKusyZV' , nKusyZV  } ,;
              {'ZvKarty->nCenacZV', nCenacZV } }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( ::dc:oBrowse[1]:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      ::broZvKarty:getColumn( nPos):Footing:hide()
      ::broZvKarty:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      ::broZvKarty:getColumn( nPos):Footing:show()
    ENDIF
  NEXT

  ::dm:refresh()
RETURN self

********************************************************************************
METHOD ZVI_KategZvi_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC := ::dm := ::dc := ::broZvKarty :=  Nil
  KategZVIw->( dbCloseArea())
  ZvKarty->( mh_ClrScope())
RETURN self

********************************************************************************
* Dialog pro výbìr KATEGORIE
********************************************************************************
CLASS KategZvi_SEL FROM drgUsrClass
EXPORTED:
  METHOD  Init, Destroy, EventHandled, getFORM
ENDCLASS

********************************************************************************
METHOD KategZvi_SEL:init( parent)
  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD KategZvi_SEL:destroy()
  ::drgUsrClass:destroy()
RETURN self

********************************************************************************
METHOD KategZvi_SEL:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
  OTHERWISE
    RETURN  .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD KategZvi_SEL:getForm()
  Local  oDrg, drgFC

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 70,17 DTYPE '10' TITLE 'Výbìr kategorie zvíøete ..... ' ;
                                           GUILOOK 'All:N,Border:Y'
*  DRGTEXT INTO drgFC CAPTION 'Vyber typ požadovaného dokladu ... ' CPOS 0,16 CLEN 70 PP 2 BGND 15

  DRGDBROWSE INTO drgFC  SIZE 70,14.8 FPOS 0,0 FILE 'KategZvi' INDEXORD 2 ;
    FIELDS 'nZvirKat:Kategorie, cNazevKat:Název kategorie:40' ;
    SCROLL 'ny' CURSORMODE 3 PP 7

RETURN drgFC