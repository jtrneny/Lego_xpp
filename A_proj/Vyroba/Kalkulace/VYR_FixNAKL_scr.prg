 /*==============================================================================
  VYR_FixNAKL_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_FixNAKL_SCR FROM drgUsrClass
EXPORTED:
  VAR     cNazRezie1, cNazRezie2, cNazRezie3, cNazRezie4

  METHOD  Init, drgDialogStart, Destroy
ENDCLASS

********************************************************************************
METHOD VYR_FixNAKL_SCR:Init(parent)
  ::drgUsrClass:init(parent)
  * CFG
  ::cNazRezie1  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie1')), 'Odbytová režie'  )
  ::cNazRezie2  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie2')), 'Výrobní režie'   )
  ::cNazRezie3  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie3')), 'Zásobovací režie')
  ::cNazRezie4  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie4')), 'Správní režie'   )
  *
  drgDBMS:open('cNazPol1' )
  drgDBMS:open('cNazPol2' )
RETURN self

********************************************************************************
METHOD VYR_FixNAKL_SCR:drgDialogStart(drgDialog)
  FixNAKL->( DbSetRelation( 'cNazPol1', {|| Upper(FixNAKL->cNazPol1) },'Upper(FixNAKL->cNazPol1)'))
  FixNAKL->( DbSetRelation( 'cNazPol2', {|| Upper(FixNAKL->cNazPol2) },'Upper(FixNAKL->cNazPol2)'))
RETURN self

********************************************************************************
METHOD VYR_FixNAKL_SCR:destroy()
  ::drgUsrClass:destroy()
  ::cNazRezie1 := ::cNazRezie2 := ::cNazRezie3 := ::cNazRezie4 := Nil
RETURN self

********************************************************************************
*
********************************************************************************
CLASS VYR_FixNAKL_CRD FROM drgUsrClass,VYR_FixNAKL_SCR

EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled, PostValidate, Destroy
HIDDEN
  VAR     lNewREC, dm, dc
ENDCLASS

********************************************************************************
METHOD VYR_FixNAKL_CRD:Init(parent)

  ::drgUsrClass:init(parent)
  ::VYR_FixNAKL_scr:init(parent)
  ::lNewREC := ( parent:cargo = drgEVENT_APPEND)
  *
  drgDBMS:open('FixNAKLw',.T.,.T.,drgINI:dir_USERfitm);  ZAP
  IF ::lNewREC  ;  FixNAKLw->(dbAppend())
                   FixNAKLw->nRokVyp := YEAR( Date())
  ELSE          ;  mh_COPYFLD('FixNAKL', 'FixNAKLw', .T.)
  ENDIF
RETURN self

*
********************************************************************************
METHOD VYR_FixNAKL_CRD:drgDialogStart(drgDialog)
  Local isReadOnly //:= drgParseSecond( drgDialog:InitParam)
  Local aInitParam :=  ListAsArray( drgDialog:InitParam, ',' ), aSetGet, lNewSet

  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl

  IF LEN( aInitParam) > 1
    isReadOnly := aInitParam[2]
    isReadOnly := &isReadOnly
    drgDialog:SetReadOnly( isReadOnly)
  ENDIF
  IF LEN( aInitParam) > 2
    aInitParam[3] :=  STRTRAN( aInitParam[3], ';', ',' )
    aSetGET := aInitParam[3]
    aSetGET := &aSetGET
    ::dm:set( 'FIXNAKLw->nRokVyp' , aSetGET[ 1] )
    ::dm:set( 'FIXNAKLw->cNazPol1', aSetGET[ 2] )
    ::dm:set( 'FIXNAKLw->nObdMes' , aSetGET[ 3] )
    ::dm:set( 'FIXNAKLw->cNazPol2', aSetGET[ 4] )
  ENDIF
  lNewSet := ! IsNil( aSetGET)

  IsEditGET( {'FixNAKLw->nRokVyp'   ,;
              'FixNAKLw->cNazPol1'  ,;
              'FixNAKLw->nObdMes'   ,;
              'FixNAKLw->cNazPol2'} ,  drgDialog, ::lNewRec .and. !lNewSet )

  /*
  isReadOnly := IF( EMPTY( isReadOnly), .F., &isReadOnly )
  drgDialog:SetReadOnly( isReadOnly)
  /*
  IF UPPER( drgDialog:parent:formName) $ 'VYR_KALKUL_CRD'
    drgDialog:SetReadOnly( .T.)
  ENDIF
  */
RETURN self

*
********************************************************************************
METHOD VYR_FixNAKL_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    IF ! ::drgDialog:dialogCtrl:isReadOnly
      ::dm:save()
      IF FixNAKL->(sx_RLock())
        mh_COPYFLD('FixNAKLw', 'FixNAKL', ::lNewREC )
        * mh_WRTzmena( 'FIXNAKL', ::lNewREC)
        FixNAKL->( dbUnlock())
      ELSE
        drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
      ENDIF
    ENDIF
    PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
    ::drgDialog:parent:dialogCtrl:browserefresh()

  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_FixNAKL_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
  LOCAL  cNAMe := UPPER(oVar:name)
  LOCAL  cKey, nREC, nObd

  DO CASE
  CASE cName = 'FIXNAKLw->nRokVyp'
    lOK := ControlDUE( oVar)

  CASE cName = 'FIXNAKLw->cNazPol1'
*    IF( lOK := ControlDUE( oVar) )
      IF lValid
        nRec := FixNakl->( RecNo())
        cKey := StrZERO( ::dm:get('FIXNAKLw->nRokVyp' ), 4) + ;
                UPPER( ::dm:get('FIXNAKLw->cNazPol1' ))
        FIXNAKL->( mh_SetSCOPE( cKey), dbGoBottom() )
          nObd := FixNakl->nObdMes + 1
        FIXNAKL->( mh_ClrSCOPE(), dbGoTo( nRec) ) // *?*
        ::dm:set( 'FIXNAKLw->nObdMes', nObd )
      ENDIF
*    ENDIF

  CASE cName = 'FIXNAKLw->cNazPol2'
    IF lValid
      cKey := StrZERO( ::dm:get('FIXNAKLw->nRokVyp' ), 4) + ;
              UPPER( ::dm:get('FIXNAKLw->cNazPol1' )) + ;
              StrZERO( ::dm:get('FIXNAKLw->nObdMes'), 2) + UPPER( xVar)
      nRec := FIXNAKL->( RecNo())
      IF ( lOK := FIXNAKL->( dbSeek( cKey)) )
        cMsg := 'DUPLICITA !;; Duplicitní záznam pro daný klíè !'
        drgMsgBox(drgNLS:msg( cMsg))
      ENDIF
      FIXNAKL->( dbGoTo( nRec))
      lOK := !lOK
      IF( lOK, ::dm:set( 'FIXNAKLw->cNazPol2', xVar ), NIL )
    ENDIF

  ENDCASE
RETURN lOK

*
********************************************************************************
METHOD VYR_FixNAKL_CRD:destroy()
  ::drgUsrClass:destroy()

  ::lNewREC := ::dm  := ::dc := ;
   NIL
RETURN self