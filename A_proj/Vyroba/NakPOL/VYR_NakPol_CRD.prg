/*==============================================================================
  VYR_NakPol_CRD.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  NakPol_OnDELETE      DelNakPol          NakPol.Prg

==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
*****************************************************************
*
*****************************************************************
CLASS VYR_NakPol_CRD FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, EventHandled, drgDialogStart
  METHOD  PostValidate
  METHOD  OnSave, Jednot_sel

HIDDEN:
  VAR   dm, lNewREC

ENDCLASS

********************************************************************************
*
********************************************************************************
METHOD VYR_NakPol_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)

  drgDBMS:open('CENZBOZ'  ) ; AdsSetOrder(3)
  drgDBMS:open('VYRPOL'   )
  drgDBMS:open('C_SKLADY' )
  drgDBMS:open('C_JEDNOT' )
  drgDBMS:open('C_KOEF'   )
  drgDBMS:open('C_TYPMAT' )

  drgDBMS:open('NAKPOLw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  NAKPOLw->( DbSetRelation( 'C_SKLADY', { || Upper(NAKPOLw->cCisSklad) },'Upper(NAKPOLw->cCisSklad)' ))
  NAKPOLw->( DbSetRelation( 'C_TYPMAT', { || Upper(NAKPOLw->cTypMat) }  ,'Upper(NAKPOLw->cTypMat)'   ))
  mh_COPYFLD('NAKPOL', 'NAKPOLw', .T.)

RETURN self

METHOD VYR_NakPol_CRD:drgDialogStart(drgDialog)
  ::dm := drgDialog:dataManager
RETURN self

*
********************************************************************************
METHOD VYR_NakPol_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    ::OnSave()
     PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

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

********************************************************************************
METHOD VYR_NakPol_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  cNAMe := UPPER(oVar:name)
  LOCAL  nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)
  DO CASE
  CASE cName = 'NakPOLw->cMjTpv' .or. cName = 'NakPOLw->cMjSpo'
    IF lOK := ControlDUE( oVar)
      IF lChanged
        lOK := ::JEDNOT_SEL(, cName)
      ENDIF
    ENDIF
  ENDCASE

RETURN lOK

*
********************************************************************************
METHOD VYR_NakPol_CRD:OnSave()

  IF NakPOL->( RLock())
     ::drgDialog:DataManager:save()
     mh_COPYFLD( 'NAKPOLw', 'NAKPOL', .F.)
     NazevMODI()
     * mh_WRTzmena( 'NAKPOL', .F.)
     NakPOL->( dbUnlock())
     ::drgDialog:parent:dialogCtrl:browserefresh()
   ELSE
     drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
   ENDIF
RETURN .t.

*
********************************************************************************
METHOD VYR_NakPol_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC := ::dm     :=   Nil
RETURN self

********************************************************************************
METHOD VYR_NakPol_CRD:jednot_sel( oDlg, cName)
  LOCAL cHelp := IF( IsNULL( oDlg), '', oDlg:lastXbpInFocus:cargo:name )
  LOCAL cItem := Coalesce( cName, cHelp )
  Local cMJ :=  Upper(::dm:get( cItem))
  Local ret, lOK := C_jednot->( dbSEEK( cMJ,, 'C_JEDNOT1'))
  Local aREC := {}

  IF IsObject( oDlg) .or. !lOK
    * Pokud poøizuje cMjTpv, cMjSpo, èíselník jednotek musí být omezen jen
    * na skladovou MJ a již definované vztahy !
    aREC := CiloveMJ( 'NakPOL' )
    mh_RyoFILTER( aREC, 'C_JEDNOT')
    *
    ret := drgCallSearch( ::drgDialog, 'C_JEDNOT', cMJ, '1' )
    IF  ( lOK := (ret <> nil ))
      ::dm:set( cItem, ret)
    ENDIF
    *
    C_Jednot->( ads_ClearAOF())
    *
  ENDIF
RETURN lOK


* Pøi zmìnì názvu v NakPOL aktualizuje i CENZBOZ, VYRPOL a NAKPOL
*===============================================================================
STATIC FUNCTION NazevMODI()
  Local cSklPOL := NakPOL->cSklPOL, cNazTPV := NakPOL->cNazTPV, cTAG
  Local nREC := NakPOL->( RecNO())

  * CenZBOZ
  cTAG := CenZBOZ->( AdsSetOrder( 1))
  CenZBOZ->( mh_SetScope( Upper( cSklPol) ) )

  DO WHILE !CenZBOZ->( EOF())
    IF CenZBOZ->cNazZBO <> NakPOL->cNazTPV  .or. ;
       CenZBOZ->cZkratJedn <> NakPOL->cZkratJedn .or. ;
       CenZBOZ->cTypSklPol <> NakPOL->cKodTpv
      IF CenZBOZ->( RLOCK())
         CenZBOZ->cNazZBO    := NakPOL->cNazTPV
* !!!         CenZBOZ->cZkratJedn := NakPOL->cZkratJedn
         CenZBOZ->cTypSklPol := NakPOL->cKodTpv
         CenZBOZ->( dbUNLOCK())
      ENDIF
    ENDIF
    CenZBOZ->( dbSKIP())
  ENDDO
  CenZBOZ->( mh_ClrScope(), AdsSetOrder( cTAG))

  * VyrPOL
  cTAG := VyrPOL->( AdsSetOrder( 6))
  VyrPOL->( mh_SetScope( Upper( cSklPol) ) )
  DO WHILE !VyrPOL->( EOF())
    IF VyrPOL->cNazev <> NakPOL->cNazTPV
      IF VyrPOL->( RLOCK())
         VyrPOL->cNazev := NakPOL->cNazTPV
         VyrPOL->( dbUNLOCK())
      ENDIF
    ENDIF
    VyrPOL->( dbSKIP())
  ENDDO
  VyrPOL->( mh_ClrScope(), AdsSetOrder( cTAG))

  * NakPOL
  cTAG := NakPOL->( AdsSetOrder( 1))
  NakPOL->( mh_SetScope( Upper( cSklPol) ) )
  DO WHILE !NakPOL->( EOF())
    IF NakPOL->( RecNO()) <> nREC
       IF NakPOL->cNazTPV <> cNazTPV
          IF NakPOL->( RLOCK())
             NakPOL->cNazTPV := cNazTPV
             NakPOL->( dbUNLOCK())
          ENDIF
       ENDIF
    ENDIF
    NakPOL->( dbSKIP())
  ENDDO
  NakPOL->( mh_ClrScope(), AdsSetOrder( cTAG), dbGoTO( nREC) )
RETURN NIL

*  Zrušení skladové položky nakupované
*===============================================================================
FUNCTION NakPOL_OnDelete()
  Local lOK, nRec := Kusov->( RecNo())
  Local cTag := Kusov->( AdsSetOrder( 3))

*  drgMsgBox(drgNLS:msg('NakPOL_OnDelete() ... '))

  IF( lOK := Kusov->( dbSeek( Upper( NakPol->cSklPol))) )
    drgMsgBox(drgNLS:msg( ;
     'NELZE ZRUŠIT ;' +;
     'Skladová položka < & > je obsažena v kusovníku jako nižší položka !', NakPol->cSklPOL), XBPMB_CRITICAL )
    Kusov->( AdsSetOrder( cTag), dbGoTo( nRec) )
    RETURN NIL
  ENDIF

  IF drgIsYesNO(drgNLS:msg('Skuteènì zrušit skladovou položku < & > ?', NakPOL->cSklPOL ))
*    DelREC( 'CenZBOZ')   //.. CenZBOZ napozicovanì ze screenu ( scope)
*    Zrušení CENZBOZ ??? prokonzultovat- co všechny vazby, které se obsluhují pøi rušení ceníku
*
    DelREC( 'NakPol')
  ENDIF
  Kusov->( AdsSetOrder( cTag), dbGoTo( nRec) )
RETURN Nil