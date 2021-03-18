/*==============================================================================
  VYR_VyrZakIT_CRD.PRG
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#define  tab_ZAKLADNI     1
#define  tab_DODACI       2
#define  tab_DALSI        3
#define  tab_POPIS        4

********************************************************************************
*
********************************************************************************
CLASS VYR_VyrZakIT_CRD FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy
  METHOD  drgDialogStart, EventHandled, tabSelect, PostValidate
  METHOD  VYR_Firmy_sel, VYR_Osoby_sel

HIDDEN:
  VAR     dc, dm
  VAR     lNewREC, tabNUM, nOrdItem

ENDCLASS

********************************************************************************
METHOD VYR_VyrZakIT_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC  := !( parent:cargo = drgEVENT_EDIT)
  ::tabNUM   := tab_ZAKLADNI
  *
  drgDBMS:open('VYRZAKITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('OSOBY'   )
  drgDBMS:open('VyrPOL' ,,,,, 'VyrPOLa'  )
  *
  ** pozor existují trigry  t_PRO_vyrzakit_afterUpdate / t_PRO_vyrzakit_afterInsert
  ** zatím nejsou zapnuty, na vyrZak je indikace lslePolZak
  ** pokud je zapnuta musíme nahradit trigr t_PRO_vyrzakit_afterInsert
  drgDBMS:open( 'cnazPol3' )

  *
  IF ::lNewREC
    * zjistí nové poøadové èíslo položky nOrdItem
    VyrZakIT->( dbGoBottom())
    ::nOrdItem := VyrZakIT->nOrdItem + 1
    *
    mh_CopyFLD( 'VyrZAK', 'VyrZakITw', .T. )
    VYRZAKITw->nMnozPlano := 1
    VyrZakITw->cVyrobCisl := ALLTRIM( VyrZak->cCisZakaz) + '/' + ALLTRIM( STR( ::nOrdItem))
  ELSE
    mh_COPYFLD('VYRZAKIT', 'VYRZAKITw', .T.)
  ENDIF

RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_CRD:drgDialogStart(drgDialog)
  Local isInfo
  *
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  *
*  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  IsEditGET( {'VyrZAKITw->cNazFirmy', 'VyrZAKITw->cUlice', 'VyrZAKITw->cSidlo' ,;
              'VyrZAKITw->nIco'     , 'VyrZAKITw->cDIC'  ,;
              'VyrZAKITw->cNazevDoA', 'VyrZAKITw->cUliceDoA', 'VyrZAKITw->cSidloDoA'},;
              drgDialog, .F. )

  isINFO := ( 'INFO' $ UPPER( drgDialog:title))
  IF( isINFO, drgDialog:SetReadOnly( .T.), NIL )
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_CRD:EventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK, oDialog, nExit, lCopy := .F., nTypVar

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    ::dm:save()
*    IF VyrZakIT->(sx_RLock())
     lOK := IF( ::lNewREC, AddREC('VyrZakIT'), ReplREC('VyrZakIT') )
     IF lOK
       mh_COPYFLD('VyrZakITw', 'VyrZakIT' )

       if vyrZakitw->lslePolZak .and. .not. cnazPol3->( dbseek( upper( vyrZakitw->ccisZakazI),,'CNAZPOL1'))
         cnazPol3->( dbappend())

         cnazPol3->cnazpol3  := vyrZakitw->ccisZakazI
         cnazPol3->cnazev    := vyrZakitw->cnazevZak1
         cnazPol3->ccisZakaz := vyrZakitw->ccisZakaz

         cnazPol3->( dbunlock(), dbcommit())
       endif


       IF ::lNewRec
         * 22.7.2010
         nTypVar := SysConfig( 'Vyroba:nTypVar')
         nTypVar := If( IsArray( nTypVar), 1, nTypVar )
         *
         VyrZakIT->cCisZakaz  := VyrZak->cCisZakaz
         VYRZAKIT->nOrdItem   := ::nOrdItem
         VyrZakIT->cCisZakazI := ALLTRIM( VyrZakIT->cVyrobCisl)
         * generuje VyrPol v pøíslušné variantì
         cKey := Upper( VyrZAK->cCisZakaz)+ Upper( VyrZAK->cVyrPOL) + STRZERO( ::nOrdItem, 3)

         IF ! VyrPOLa->( dbSEEK( cKEY,,'VYRPOL1'))
           IF nTypVar = 1
             cKey := EMPTY_ZAKAZ + Upper( VyrZAK->cVyrPOL) + '001'  // STRZERO( x, 3)
             IF VyrPOLa->( dbSEEK( cKEY,,'VYRPOL1'))
               lCopy := .T.
             ELSE
               cKey := Upper( VyrZAK->cCisZakaz)+ Upper( VyrZAK->cVyrPOL) + '001'
               IF VyrPOLa->( dbSEEK( cKEY,,'VYRPOL1'))
                  lCopy := .T.
               ENDIF
             ENDIF
           ELSEIF nTypVar = 2
           ENDIF

           IF lCopy
             mh_CopyFLD( 'VyrPOLa', 'VyrPOL', .T.)
             VyrPOL->cCisZakaz := VyrZak->cCisZakaz
             VyrPol->nZakazVP  := VYR_ZakazVP( VyrPol->cCisZakaz)
             VyrPOL->nVarCis   := ::nOrdItem
             VyrPOL->nStavKalk := -1
           ENDIF
         ENDIF
       ENDIF
       VyrZakIT->( dbUnlock())
    ENDIF
    PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
    RETURN .T.

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
METHOD VYR_VyrZakIT_CRD:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber
RETURN .T.

********************************************************************************
METHOD VYR_VyrZakIT_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  cNAMe := UPPER(oVar:name)
  LOCAL  nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)
  DO CASE
  CASE cName = 'VYRZAKITw->cJmeOsZAL' .or. cName = 'VYRZAKITw->cJmeOsODP'     //
    IF ! EMPTY(xVar)
      lOK := ::VYR_Osoby_sel(, cName)
    ENDIF

  CASE cName = 'VYRZAKW->dOdvedZaka'
*      if empty(xVar)
*        ::msg:writeMessage('Datum ovedení požadované je povinný údaj ...',DRG_MSG_WARNING)
*        lOK := .f.
*      else
      if empty(::dm:get('vyrzakw->dmozodvzak'))
        ::dm:set('VyrZakITw->dmozodvzak',xVar)
        VyrZakITw->nrokODV   := year(xVar)
        VyrZakITw->nmesicODV := month(xVar)
        VyrZakITw->ntydenODV := mh_weekOfYear(xVar)
      endif
*      endif

** DODACÍ údaje
  CASE cName = 'VYRZAKITw->nCisFirmy' .or. cName = 'VYRZAKITw->nCisFirDoa'     //
    IF ! EMPTY(xVar)
      lOK := ::VYR_Firmy_sel(, cName)
    ENDIF

  CASE cName = 'VYRZAKITw->NCENAMJ'       // Cena za MJ
   IF lChanged
     ::dm:set( 'VYRZAKITw->NCENACELK' , ::dm:get('VYRZAKITw->NMNOZPLANO') * xVar)
     ::dm:set( 'VYRZAKITw->NCENZAKCEL', ::dm:get('VYRZAKITw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100) )
   ENDIF

  CASE cName = 'VYRZAKITw->NCENACELK' .OR.;    // Celkem bez DPH
       cName = 'VYRZAKITw->NKLICDPH'
    ::dm:set( 'VYRZAKITw->NCENZAKCEL', ::dm:get('VYRZAKITw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100))
  ENDCASE

RETURN lOK

* Výbìr Firmy objednavatele / Dodací adresa
********************************************************************************
METHOD VYR_VyrZakIT_CRD:VYR_FIRMY_SEL( oDlg, cName)
  LOCAL oDialog, nExit, cKey
  LOCAL cHelp := IF( IsNULL( oDlg), '', oDlg:lastXbpInFocus:cargo:name )
  LOCAL cItem := Coalesce( cName, cHelp )
  LOCAL Value := ::dm:get( cItem)
  LOCAL lOK := ( !Empty(value) .and. FIRMY->( dbSEEK( Value,, 'FIRMY1')) )

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( cItem, Firmy->nCisFirmy )
    IF cItem = 'VyrZAKITw->nCisFirmy'
      ::dm:set( 'VYRZAKITw->cNazFirmy', Firmy->cNazev )
      ::dm:set( 'VYRZAKITw->cUlice'   , Firmy->cUlice )
      ::dm:set( 'VYRZAKITw->cSidlo'   , Firmy->cSidlo )
      ::dm:set( 'VYRZAKITw->nIco'     , Firmy->nIco   )
      ::dm:set( 'VYRZAKITw->cDic'     , Firmy->cDic   )
    ELSE
      ::dm:set( 'VYRZAKITw->cNazevDoa', Firmy->cNazev )
      ::dm:set( 'VYRZAKITw->cUliceDoa', Firmy->cUlice )
      ::dm:set( 'VYRZAKITw->cSidloDoa', Firmy->cSidlo )
    ENDIF
    ::dm:refresh()
  ENDIF
RETURN lOK

* Výbìr Osoby do položek: Založila osoba, Zodpovídá osoba
********************************************************************************
METHOD VYR_VyrZakIT_CRD:VYR_OSOBY_SEL( oDlg, cName)
  LOCAL oDialog, nExit, cKey
  LOCAL cHelp := IF( IsNULL( oDlg), '', oDlg:lastXbpInFocus:cargo:name )
  LOCAL cItem := Coalesce( cName, cHelp )
  LOCAL Value := Upper(::dm:get( cItem))
  LOCAL lOK := ( !Empty(value) .and. OSOBY->( dbSEEK( Value,, 'OSOBY02')) )

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'OSB_OSOBY_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                   EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. !lOK )
    lOK := .T.
    ::dm:set( cItem, AllTrim(Osoby->cOsoba ) )
    /*
    ::dm:set( cItem, Osoby->nCisOsoby )
    IF cItem = 'VyrZAKITw->nCisOsZAL'
      ::dm:set( 'VYRZAKITw->cJmeOsZal', AllTrim(Osoby->cOsoba ))
    ELSE
      ::dm:set( 'VYRZAKITw->cJmeOsOdp', AllTrim(Osoby->cOsoba ))
    ENDIF
    */
    ::dm:refresh()
  ENDIF
RETURN lOK

********************************************************************************
METHOD VYR_VyrZakIT_CRD:destroy()
  ::drgUsrClass:destroy()
  ::tabNUM       := NIL
RETURN self