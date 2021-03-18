#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


#include "..\Asystem++\Asystem++.ch"


*  SPOJENI
** CLASS KAN_spojeni_CRD *******************************************************
CLASS KAN_spojeni_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart

  METHOD  postValidate
  METHOD  postAppend
  METHOD  onSave
  METHOD  destroy

  inline access assign method caption_adrElSpoj() var caption_adrElSpoj
    c_typSpo->(dbseek( upper( spojeniW->ctypSpoj),,'C_TYPSPO01'))
    return left(c_typSpo->cnazTyp, 17)

HIDDEN:
  var lnewRec
  var  msg, dm, dc, df, ab

  inline method enable_or_disable_items()
    local typSpoj := upper(spojeniW->ctypSpoj)

    local  x, oDrg, groups, vars := ::dm:vars

    groups := if( typSpoj = 'ADR', 'ADR', 'NO_ADR' )

    for x := 1 to vars:size() step 1
      oDrg  := vars:getNth( x ):oDrg

      if oDrg:className() = 'drgGet' .and. .not. empty( oDrg:groups )
        if oDrg:groups = groups
          ( oDrg:isEdit := .t., oDrg:oXbp:enable()  )
        else
          ( oDrg:isEdit := .f., oDrg:oXbp:disable() )
        endif
      endif
    next
    return self

ENDCLASS


METHOD KAN_spojeni_CRD:init(parent)

  ::drgUsrClass:init(parent)

  * pokud to volám ze SEL dialogù
  drgDBMS:open('spojeni' )

  * karta spojení volaná pro opravu z ... vodevšad 2 parametr je recNo()
  if len(pa_initParam := listAsArray(parent:initParam)) = 2
    parent:cargo := drgEVENT_EDIT
    spojeni->(dbgoTo( val( pa_initParam[2] )))
  endif

  ::lnewRec := .not. (parent:cargo = drgEVENT_EDIT)
  if( spojeni->(eof()), ::lnewRec := .t., nil )

  drgDBMS:open('c_typSpo')

  * TMP soubory
  drgDBMS:open('spojeniW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  spojeniW->(dbAppend())
  spojeniW->ncisSpoj := spojeni->( Ads_GetKeyCount()) +1

  if .not. ::lnewRec
    mh_copyFld( 'spojeni', 'spojeniW' )
  endif
RETURN self


METHOD KAN_spojeni_CRD:drgDialogStart(drgDialog)
  local  amembers := drgDialog:oForm:amembers, x
  *
  local  acolors  := MIS_COLORS
  *
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  *

  for x := 1 to len(amembers) step 1
    * font a barva u textù
    if  aMembers[x]:ClassName() = 'drgText' .and. .not. empty(aMembers[x]:groups)
      if 'SETFONT' $ aMembers[x]:groups
        pa_groups := ListAsArray(aMembers[x]:groups)
        nin       := ascan(pa_groups,'SETFONT')

        aMembers[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            aMembers[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          aMembers[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endif
  next

  if( .not. ::lnewRec, ::enable_or_disable_items(), nil )
RETURN self


METHOD KAN_spojeni_CRD:postAppend()
  LOCAL  cX

  cX := Lower(::cALIASw +'->nitem')
  if ::dataManager:get(cX) = 0
    ::dataManager:set(cX, ::item)
  endif
RETURN .T.


METHOD KAN_spojeni_CRD:postValidate(drgVar)
  local  value    := drgVar:get()
  local  name     := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  lOk := .t.

  if(lOk, eval(drgVar:block,drgVar:value), nil)

  if name = 'spojeniw->czkrspoj'
     spojeniW->ctypSpoj := c_spojen->ctypSpoj
     if empty(spojeniW->cnazSpoj)
       spojeniW->cnazSpoj := c_typSpo->infoText
       ::dm:set('spojeniW->cnazSpoj', c_typSpo->infoText)
     endif

     * podle ctypSpoj povolíme, nebo bloknem editaci
     :: enable_or_disable_items()

     ::dm:refresh()
  endif
RETURN lOK


METHOD KAN_spojeni_CRD:onSave(lIsCheck,lIsAppend)

  c_spojen->( dbseek( spojeniW->czkrSpoj,,'C_SPOJEN01'))

  spojeniW->ctypSpoj   := c_spojen->ctypSpoj
  spojeniW->cUlicCiPop := allTrim(spojeniW->culice) + spojeniW->ccisPopis
  spojeniW->mAdrPoSpoj := spojeniW->cUlicCiPop                             +CRLF + ;
                          spojeniW->cPsc       +' ' + spojeniW->cmisto     +CRLF + ;
                          spojeniW->cZkratStat +' ' + c_staty ->cnazevStat

  if ::lNEWrec
    spojeniW->ncisSpoj := spojeni->( Ads_GetKeyCount()) +1
    mh_copyFld( 'spojeniW', 'spojeni', .t.)

  else
    if spojeni->( sx_Rlock())
      mh_copyFld( 'spojeniW', 'spojeni')

      spojeni->(dbUnlock())
    endif
  endif

  spojeni->( dbcommit())
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .t.


METHOD KAN_spojeni_CRD:destroy()
 ::drgUsrClass:destroy()

RETURN SELF