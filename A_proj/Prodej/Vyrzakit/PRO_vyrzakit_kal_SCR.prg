#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "gra.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'kalendar', 'vyrzak', 'vyrzakit', 'explsthd', 'explstit' }


*
** CLASS for PRO_vyrzakit_kal_SCR *********************************************
CLASS PRO_vyrzakit_kal_scr FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, itemMarked
  method  pro_explsthd_scr

  * položky - bro
  inline access assign method mnozPlano() var mnozPlano
    local val := 0
    vyrzai_s->(::s_scope(), dbeval({|| val += vyrzai_s->nmnozPlano}))
    return val

  inline access assign method cenaCelk() var cenaCelk
    local val := 0
    vyrzai_s->(::s_scope(), dbeval({|| val += vyrzai_s->ncenaCelk}))
    return val

 inline access assign method cenCelTuz() var cenCelTuz
    local val := 0
    vyrzai_s->(::s_scope(), dbeval({|| val += vyrzai_s->ncenCelTuz}))
    return val


  inline access assign method is_expList() var is_expList
    return if( .not. empty(vyrzakit->ncisloEL), MIS_ICON_OK, 0)

  inline access assign method firmaDOP() var firmaDOP
    return explsthd->cnazevDOP

  inline access assign method datExpedice() var datExpedice
    return explsthd->dexpedice

  inline access assign method datNakladky() var datNakladky
    return explsthd->dnakladky


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
       return .t.
    endcase
    return .f.

hidden:
  var   neco

  inline method s_scope()
    local ky := strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)

    vyrzai_s->(AdsSetOrder('ZAKIT_6'),dbsetScope(SCOPE_BOTH,ky),dbgotop())
  return nil
ENDCLASS


method PRO_vyrzakit_kal_scr:Init(parent)
  local  cky := 'strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)'
  local  bky := COMPILE(cky)

  ::drgUsrClass:init(parent)

  ::lnewRec := .f.

  * základní soubory
  ::openfiles(m_files)
  explstit->(dbSetRelation('explsthd',{|| explstit->ndoklad}, 'explstit->ndoklad','EXPLSTHD01'))

  * pomocný soubor pro souèty
  if(select('vyrzai_s') = 0, drgDBMS:open('vyrzakit',,,,,'vyrzai_s'), nil)
  vyrzai_s->(AdsSetOrder('ZAKIT_6'))
return self


method PRO_vyrzakit_kal_scr:drgDialogStart(drgDialog)
return


method PRO_vyrzakit_kal_scr:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''

  if isobject(oxbp)
    ky    := strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)
    vyrzakit->(AdsSetOrder('ZAKIT_6'),dbsetScope(SCOPE_BOTH,ky),dbgotop())
  endif

  vyrzak  ->(dbseek(upper(vyrzakit->ccisZakaz,,'VYRZAK1')))
return self


method pro_vyrzakit_kal_scr:pro_explsthd_scr(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT

  DRGDIALOG FORM 'PRO_EXPLSTHD_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
return

