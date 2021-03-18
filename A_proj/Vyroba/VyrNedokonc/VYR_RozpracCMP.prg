/*==============================================================================
  VYR_RozpracCMP.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#DEFINE  vyrROZPRAC      1    // Nedokonèená ( rozpracovaná) výroba
#DEFINE  vyrDOKONC       2    // Dokonèená  výroba
#DEFINE  vyrKALKZAK      3    // Všechny zakázky (nedokonèená + dokonèená)

* Aktualizace výroby: Nedokonèené (ROZPRAC), dokonèené (DOKONC), celé (KALKZAK)
********************************************************************************
CLASS VYR_VYROBA_AKT FROM drgUsrClass
EXPORTED:
  VAR     nPrMZDY, nFaktMN, acDenikNE, nVypREZ, nHodSazZAM, cDenikSKL, nKoef
  VAR     cRel, nObdobi, nRok, lVypocetPlanu, nTypRezie

  METHOD  Init, Destroy
  METHOD  Aktualizace, VyrobaNED, VyrobaDOK
ENDCLASS

********************************************************************************
METHOD VYR_VYROBA_AKT:init(parent)
  ::drgUsrClass:init(parent)
  * Config
  ::nPrMZDY    := SysCONFIG( 'Vyroba:cPrMzdaKal')
  ::nFaktMN    := SysCONFIG( 'Vyroba:cFaktMnoz' )
  ::acDenikNE  := ListAsArray( ALLTRIM( SysCONFIG( 'Vyroba:cDenikNE')))
  ::nVypREZ    := SysCONFIG( 'Vyroba:cVypREZIE')
  ::nHodSazZAM := SysCONFIG( 'Vyroba:nHodSazZam')
  ::cDenikSKL  := UPPER( ALLTRIM( SysCONFIG( 'Sklady:cDenik')))
  ::nKOEF      := SysCONFIG( 'Vyroba:nSazbaPOJ') / 100
  *
  ::cRel          := '<='
  ::nObdobi       := MONTH( Date())
  ::nRok          := YEAR( Date())
  ::lVypocetPlanu := .T.
  ::nTypRezie     := 1     // 1 = Vypoètená, 2 = Nastavená

RETURN self

********************************************************************************
METHOD VYR_VYROBA_AKT:destroy()
  ::drgUsrClass:destroy()
  *
  ::nPrMZDY    := ::nFaktMN   := ::acDenikNE := ::nVypREZ := ;
  ::nHodSazZAM := ::cDenikSKL := ::nKOEF     :=  NIL
  *
  ::cRel  := ::nObdobi := ::nRok  := ::lVypocetPlanu := ::nTypRezie := NIL

RETURN self

********************************************************************************
METHOD VYR_VYROBA_AKT:Aktualizace( nVyroba)
  Local cTag, lScope
  Local cMsg := drgNLS:msg('MOMENT PROSÍM ...')
  Local nRec := VyrZAK->( RecNO()), nRecCount
  Local aVyroba := { { 'Nedokonèené', 'ROZPRAC' },;
                     { 'Dokonèené'  , 'DOKONC'  },;
                     { 'Celé'       , 'KLAKZAK' } }
  Local cParam := aVyroba[ nVyroba, 1]
  Local cAlias := aVyroba[ nVyroba, 2]

  *
  * Kontrola, zda bylo zpracováno pøedchozí období, jen upozornit
  *

  IF drgIsYesNo(drgNLS:msg( 'Spustit výpoèet ' + cParam + ' výroby ?' ))
**    ::dm:save()
    /*
    */
    nRecCount := VyrZAK->( LastREC())
**    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Probíhá výpoèet výroby ' + cParam + ' ...', 'VYRZAK'), nRecCount  )
    *
    VyrZAK->( dbGoTOP())
    DO WHILE !VyrZAK->( EOF())

     IF nVyroba = vyrROZPRAC  ;  ::VyrobaNED()
     ELSE                     ;  Kalkul->( OrdSetFOCUS( 3))
                                 ::VyrobaDOK( cALIAS)
     ENDIF

      VyrZAK->( dbSKIP())
      drgServiceThread:progressInc()
    ENDDO

    drgServiceThread:progressEnd()
    cMsg := drgNLS:msg('Výpoèet nedokonèené výroby ukonèen ...' )
**    ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
  ENDIF
  *
*  IF( lScope, VyrPOL->( mh_ClrSCOPE()), NIL )
  VyrZAK->( dbGoTO(nREC))

RETURN self

*
********************************************************************************
METHOD VYR_VYROBA_AKT:VyrobaNED()

RETURN self

*
********************************************************************************
METHOD VYR_VYROBA_AKT:VyrobaDOK()

RETURN self


* Screen NEDOKONÈENÉ VÝROBY
********************************************************************************
CLASS VYR_Rozprac_AKT FROM drgUsrClass
EXPORTED:
  METHOD  Init, Destroy
  METHOD  btn_RozpracCMP
ENDCLASS

********************************************************************************
METHOD VYR_Rozprac_AKT:init(parent)
  *
  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD VYR_Rozprac_AKT:destroy()
  ::drgUsrClass:destroy()
RETURN self

********************************************************************************
METHOD VYR_Rozprac_AKT:btn_RozpracCMP()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'VYR_ROZPRACCMP_CRD' PARENT ::drgDialog  MODAL DESTROY ;
                                  EXITSTATE nExit
RETURN self


********************************************************************************
*
********************************************************************************
CLASS VYR_RozpracCMP_CRD FROM VYR_VYROBA_AKT  // drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, drgDialogStart, EventHandled
  METHOD  PostValidate
  METHOD  btn_RozpracCMP

HIDDEN:
  VAR     dm, msg, VyrobaAKT
ENDCLASS

********************************************************************************
METHOD VYR_RozpracCMP_CRD:init(parent)

  ::VyrobaAKT := ::VYR_VYROBA_AKT:init(parent)
RETURN self

********************************************************************************
METHOD VYR_RozpracCMP_CRD:drgDialogStart(drgDialog)
*  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar

RETURN self

*
********************************************************************************
METHOD VYR_RozpracCMP_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
**    ::OnSave()
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

*
********************************************************************************
METHOD VYR_RozpracCMP_CRD:destroy()

  ::VYR_VYROBA_AKT:destroy()
RETURN self

*
********************************************************************************
METHOD VYR_RozpracCMP_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  cNAMe := UPPER(oVar:name), cField := drgParseSecond(cName, '>')
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  /*
  DO CASE
  CASE cField $ Upper('nRokVyp,nObdMes,nPorKalDen')
*     If lValid
      If ( xVar <= 0)
        drgMsgBox(drgNLS:msg( oVar:ref:caption + ': ... údaj musí být kladný !'))
        oVar:recall()
        lOK := .F.
      EndIf
*    Endif
  ENDCASE
  */
RETURN lOK

* Výpoèet nedokonèené výroby
********************************************************************************
METHOD VYR_RozpracCMP_CRD:btn_RozpracCMP()

  ::VyrobaAKT:Aktualizace( 1)
RETURN self

