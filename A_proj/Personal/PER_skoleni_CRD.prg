#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"


#include "..\Asystem++\Asystem++.ch"



*  SKOLENI
** CLASS PER_skoleni_CRD *******************************************************
CLASS PER_skoleni_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init, postValidate, onSave, destroy

  inline method drgDialogStart( drgDialog)
   *
   ::msg      := drgDialog:oMessageBar             // messageBar
   ::dm       := drgDialog:dataManager             // dataMabanager
   ::dc       := drgDialog:dialogCtrl              // dataCtrl
   ::df       := drgDialog:oForm                   // form
   *
   return self

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
  VAR   msg, dm, dc, df, ab
  VAR   lnewRec
ENDCLASS


METHOD PER_skoleni_CRD:init(parent)

  ::drgUsrClass:init(parent)

  * pokud to volám ze SEL dialogù
  drgDBMS:open('skoleni')

  * karta lekProhl volaná pro opravu z ... vodevšad 2 parametr je recNo()
  if len(pa_initParam := listAsArray(parent:initParam)) = 2
    parent:cargo := drgEVENT_EDIT
    skoleni->(dbgoTo( val( pa_initParam[2] )))
  endif

  ::lnewRec := .not. (parent:cargo = drgEVENT_EDIT)
  if( skoleni->(eof()), ::lnewRec := .t., nil )

  * TMP soubory
  drgDBMS:open('skoleniW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  skoleniW->(dbAppend())
  skoleniW->nporadi := skoleni->( Ads_GetKeyCount()) +1

  if .not. ::lnewRec
    mh_copyFld( 'skoleni', 'skoleniW' )
  endif
RETURN self


METHOD PER_skoleni_CRD:postValidate(drgVar)
  local  value   := drgVar:get()
  local  name    := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  changed := drgVAR:changed()

  local  lOk := .t.

  do case
  case field_name = 'ncisfirmy' .and. changed
    ::dm:set( 'skoleniW->cnazevSkol', firmy->cnazev )
    mh_copyFld( 'firmy', 'skoleniW' )
    ::dm:refresh()

  case field_name = 'czkratleka'
*    lekProhlW->cnazevLeka := c_lekari->cnazevLeka
*    lekProhlW->codbornLek := c_lekari->codbornLek

*    ::drgDialog:dataManager:set( 'lekProhlW->cnazevLeka', c_lekari->cnazevLeka )
*    ::drgDialog:dataManager:set( 'lekProhlW->codbornLek', c_lekari->codbornLek )
  endcase

  if(lOk, eval(drgVar:block,drgVar:value), nil)
RETURN lOK


METHOD PER_skoleni_CRD:onSave(lIsCheck,lIsAppend)

  if ::lNEWrec
    skoleniW->nporadi := skoleni->( Ads_GetKeyCount()) +1
    mh_copyFld( 'skoleniW', 'skoleni', .t.)

  else
    if skoleni->( sx_Rlock())
      mh_copyFld( 'skoleniW', 'skoleni')

      skoleni->(dbUnlock())
    endif
  endif

  skoleni->( dbcommit())
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .t.


METHOD PER_skoleni_CRD:destroy()
 ::drgUsrClass:destroy()

RETURN SELF