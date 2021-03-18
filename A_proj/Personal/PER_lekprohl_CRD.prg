#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"

#include "..\Asystem++\Asystem++.ch"



*  LEKPROHL
** CLASS PER_lekprohl_CRD ******************************************************
CLASS PER_lekprohl_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init, postValidate, onSave, destroy

/*
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc       := ::drgDialog:dialogCtrl
    LOCAL  dbArea   := ALIAS(SELECT(dc:dbArea))

    DO CASE
    CASE (nEvent = drgEVENT_EXIT)
      // kotrola - uložíme - ven
      IF dc:saveData(.F.)
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      ENDIF

    CASE nEvent = drgEVENT_APPEND
      IF ALIAS(dc:dbArea) = 'W_PODRUC'                                          // not for C_PODRUCw
        PostAppEvent(drgEVENT_ACTION, drgEVENT_EDIT,'2',oXbp)
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_DELETE
      IF ALIAS(SELECT(dc:dbArea)) = 'W_PODRUC'                                  // not for C_PODRUCw
        IF drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?') )
           // smazat a refresch
           PostAppEvent(drgEVENT_ACTION,drgEVENT_REFRESH,'1',oXbp)
         ENDIF
       RETURN .T.
      ENDIF
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.
*/

HIDDEN:
 VAR   lnewRec
ENDCLASS


METHOD PER_lekprohl_CRD:init(parent)

  ::drgUsrClass:init(parent)

  * pokud to volám ze SEL dialogù
  drgDBMS:open('lekProhl')

  * karta lekProhl volaná pro opravu z ... vodevšad 2 parametr je recNo()
  if len(pa_initParam := listAsArray(parent:initParam)) = 2
    parent:cargo := drgEVENT_EDIT
    lekProhl->(dbgoTo( val( pa_initParam[2] )))
  endif

  ::lnewRec := .not. (parent:cargo = drgEVENT_EDIT)
  if( lekprohl->(eof()), ::lnewRec := .t., nil )

  * TMP soubory
  drgDBMS:open('lekProhlW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  lekProhlW->(dbAppend())
  lekProhlW->nporadi := lekprohl->( Ads_GetKeyCount()) +1

  if .not. ::lnewRec
    mh_copyFld( 'lekProhl', 'lekProhlW' )
  endif
RETURN self


METHOD PER_lekprohl_CRD:postValidate(drgVar)
  local  value    := drgVar:get()
  local  name     := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  lOk := .t.

  do case
  case field_name = 'czkratleka'
    lekProhlW->cnazevLeka := c_lekari->cnazevLeka
    lekProhlW->codbornLek := c_lekari->codbornLek

    ::drgDialog:dataManager:set( 'lekProhlW->cnazevLeka', c_lekari->cnazevLeka )
    ::drgDialog:dataManager:set( 'lekProhlW->codbornLek', c_lekari->codbornLek )
  endcase

  if(lOk, eval(drgVar:block,drgVar:value), nil)
RETURN lOK


METHOD PER_lekprohl_CRD:onSave(lIsCheck,lIsAppend)

  if ::lNEWrec
    lekProhlW->nporadi := lekProhl->( Ads_GetKeyCount()) +1
    mh_copyFld( 'lekProhlW', 'lekProhl', .t.)

  else
    if lekProhl->( sx_Rlock())
      mh_copyFld( 'lekProhlW', 'lekProhl')

      lekProhl->(dbUnlock())
    endif
  endif

  lekProhl->( dbcommit())
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .t.


METHOD PER_lekprohl_CRD:destroy()
 ::drgUsrClass:destroy()

RETURN SELF