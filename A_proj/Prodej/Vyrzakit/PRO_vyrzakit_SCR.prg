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


#define m_files  { 'vyrzak', 'vyrzakit', 'explsthd', 'explstit' }


*
** CLASS for PRO_vyrzakit_SCR **************************************************
CLASS PRO_vyrzakit_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked
  method  postValidate, postLastField
  method  pro_explsthd_scr, pro_explsthd_sel, pro_explsthd_ins, pro_explsthd_del
  method  vyr_vyrzak_scr

  * položky - bro
  inline access assign method is_expList() var is_expList
    return if( .not. empty(vyrzakit->ncisloEL), MIS_ICON_OK, 0)

  inline access assign method firmaDOP() var firmaDOP
    explsthd->(dbseek(vyrzakit->ncisloEL,,'EXPLSTHD01'))
    return explsthd->cnazevDOP

  inline access assign method datExpedice() var datExpedice
    explsthd->(dbseek(vyrzakit->ncisloEL,,'EXPLSTHD01'))
    return explsthd->dexpedice

  inline access assign method datNakladky() var datNakladky
    explsthd->(dbseek(vyrzakit->ncisloEL,,'EXPLSTHD01'))
    return explsthd->dnakladky


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local lastDrg := ::df:oLastDrg

    ::dc:isChild := (lastDrg = ::a_obrow[2])

    do case
    case nEvent = xbeP_Keyboard .and. .not. ::dc:isChild
      if mp1 = xbeK_ALT_P
        ::cmp_odvedZaka()
        return .t.
      endif

    case(lastDrg = ::a_obrow[2] .or. lastDrg:className() = 'drgGet')
      do case
      case nEvent = drgEVENT_DELETE
        ::pro_explsthd_del()
        return .t.

      case nEvent = xbeP_Keyboard .and. lastDrg:className() = 'drgGet'
        if mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
          ::df:olastdrg   := ::obro_exi
          ::df:nlastdrgix := ::nbro_exi
          ::df:olastdrg:setFocus()
          ::restColor()
          PostAppEvent(xbeBRW_ItemMarked,,,::obro_exi:oxbp)
          ::obro_exi:oxbp:refreshCurrent():hilite()
          return .t.
        endif

      otherwise
        return ::handleEvent(nEvent,mp1,mp2,oXbp)
      endcase

    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, drgPush_del, drgPush_ins, a_obrow, obro_exi, nbro_exi
  method  postDelete

  *
  ** pomocný pøepoèet **
  inline method cmp_odvedZaka()
    local  recNo := vyrzakit->(recNo()), odvedZaka
    local  o_da  := ::a_obrow[1]:oxbp

    vyrzakit->(dbGoTop())
    do while .not. vyrzakit->(eof())
      o_da:SetPointer(, XBPSTATIC_SYSICON_WAIT,XBPWINDOW_POINTERTYPE_SYSPOINTER)
      if vyrzakit->(sx_rLock())
        value := vyrzakit->dodvedZaka

        vyrzakit->nrokODV   := year(value)
        vyrzakit->nmesicODV := month(value)
        vyrzakit->ntydenODV := mh_weekOfYear(value)

        vyrzakit->(dbUnlock(), dbCommit())
      endif
      vyrzakit->(dbskip())
    enddo

    vyrzakit->(dbGoTo(recNo))

    o_da:SetPointer(, XBPSTATIC_SYSICON_DEFAULT )
  return .t.

ENDCLASS


METHOD PRO_vyrzakit_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * základní soubory
  ::openfiles(m_files)
RETURN self


METHOD PRO_vyrzakit_SCR:drgDialogStart(drgDialog)
  local members := drgDialog:oForm:aMembers, x

  ::fin_finance_in:init(drgDialog,'poh','explstit->ndoklad',' položku expedièního listu')

  for x := 1 TO LEN(members) step 1
    if( members[x]:ClassName() = 'drgPushButton')
      do case
      case(members[x]:event = 'pro_explsthd_del')
        ::drgPush_del        := members[x]
        ::drgPush_del:isEdit := .f.

      case(members[x]:event = 'pro_explsthd_ins')
        ::drgPush_ins        := members[x]
        ::drgPush_ins:isEdit := .f.
      endcase

    elseif( members[x]:ClassName() = 'drgDBrowse')
      if lower(members[x]:cfile) = 'explstit'
        ::obro_exi := members[x]
        ::nbro_exi := x
      endif
    endif
  next

  ::a_obrow := drgDialog:odbrowse
  ::brow    := ::a_obrow[2]:oxbp
RETURN


METHOD PRO_vyrzakit_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
RETURN .T.


method pro_vyrzakit_scr:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''

  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'vyrzakit','ab',if(cfile = 'explstit','b', ''))

    if( 'a' $ rest)
      ky := vyrzakit->ncisloEL
      explsthd->(dbSeek(ky,,'EXPLSTHD01'))

      ky := upper(vyrzakit->ccisZakazI)
      explstit->(AdsSetOrder('EXPLSTIT03'), dbsetScope(SCOPE_BOTH,ky),dbgotop())
    endif

    if (rest = 'b')
    endif
  endif

  vyrzak  ->(dbseek(upper(vyrzakit->ccisZakaz,,'VYRZAK1')))
*-  if( vyrzakit->ncisloEL = 0, ::drgPush:oxbp:hide(), ::drgPush:oxbp:show())
return self


method pro_vyrzakit_scr:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case(name = 'explstit->ndoklad' .and. mp1 = xbeK_RETURN)
    ok := ::pro_explsthd_sel()

  case(name = 'explstit->nfaktmnoz')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
    endif
  endcase
return ok


method pro_vyrzakit_scr:postLastField()
  local  dokladEL, ky, mainOk

  dokladEL := if(explstit->(eof()) .or. ::state = 2, 0, explstit->ndoklad)

  if dokladEL <> 0
    ky := strZero(vyrzakit->ncisloEL,10) +upper(vyrzakit->ccisZakazI)
    explstit->(dbseek(ky,,'EXPLSTIT02'))

    mainOk := vyrzakit->(sx_rLock()) .and. explstit->(sx_rlock())
  else
    mainOk := vyrzakit->(sx_rLock())
  endif

  if mainOk
    if dokladEL = 0
      mh_copyFld('explsthd','explstit', .t., .f.)
      mh_copyFld('vyrzakit','explstit',, .f.)
      *
      explstit->cnazev  := vyrzakit->cnazFirmy
      explstit->cnazZbo := vyrzakit->cnazevZak1
    else
      explstit->ndoklad := explsthd->ndoklad
    endif

    explstit->nfaktmnoz := ::dm:get('explstit->nfaktmnoz')

    explstit->(dbCommit())
    vyrzakit->ncisloEL  := ::dm:get('explstit->ndoklad')
  endif

  ::df:olastdrg   := ::obro_exi
  ::df:nlastdrgix := ::nbro_exi
  ::df:olastdrg:setFocus()
  PostAppEvent(xbeBRW_ItemMarked,,,::a_obrow[1]:oxbp)

  vyrzakit->(dbUnlock(), dbCommit())
   explstit->(dbUnlock(), dbCommit())
    ::dm:refresh()
return .t.


method pro_vyrzakit_scr:pro_explsthd_ins(drgDialog)
  ::df:olastdrg   := ::obro_exi
  ::df:nlastdrgix := ::nbro_exi
  ::df:olastdrg:setFocus()
  PostAppEvent(drgEVENT_APPEND,,,::a_obrow[2]:oxbp)
return self


method pro_vyrzakit_scr:pro_explsthd_del(drgDialog)
  if  vyrzakit->(sx_rLock()) .and. explstit->(sx_rlock())
    vyrzakit->ncisloEL := 0
    explstit->(dbDelete())

    ::df:olastdrg   := ::obro_exi
    ::df:nlastdrgix := ::nbro_exi
    ::df:olastdrg:setFocus()
    ::a_obrow[1]:oxbp:refreshCurrent()
    PostAppEvent(xbeBRW_ItemMarked,,,::a_obrow[1]:oxbp)
  endif

  vyrzakit->(dbUnlock(), dbCommit())
   explstit->(dbUnlock(), dbCommit())
return self


method pro_vyrzakit_scr:pro_explsthd_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f., ky
  *
  local  drgVar  := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  value   := drgVar:get()
  local  cisloEL := vyrzakit->ncisloEL

  ok := explsthd->(dbseek(value,,'EXPLSTHD01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'PRO_EXPLSTHD_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if (nexit != drgEVENT_QUIT)
    if cisloEL <> 0
      ky := strZero(vyrzakit->ncisloEL,10) +upper(vyrzakit->ccisZakazI)
      explstit->(dbseek(ky,,'EXPLSTIT02'))

      copy := vyrzakit->(sx_rLock()) .and. explstit->(sx_rlock())
    else
      copy := vyrzakit->(sx_rLock())
    endif
  endif

  if copy
    ::dm:set('explstit->ndoklad'  ,explsthd->ndoklad)
    ::dm:set('explstit->nfaktMnoz',vyrzakit->nmnozPlano)
  endif

  if(ok .or. copy, ::df:setNextFocus(1,.t.,.t.), nil)
return (nexit != drgEVENT_QUIT) .or. ok


method pro_vyrzakit_scr:pro_explsthd_scr(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT

  DRGDIALOG FORM 'PRO_EXPLSTHD_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
return


method pro_vyrzakit_scr:vyr_vyrzak_scr(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT

  DRGDIALOG FORM 'VYR_VYRZAK_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
return


method pro_vyrzakit_scr:postDelete()
  local  nsel, nodel := .f.
/*
** zatím nevíme **
  if dodlsthd->ncisfak = 0
    nsel := ConfirmBox( ,'Požadujete zrušit dodací list _' +alltrim(str(dodlsthd->ndoklad)) +'_', ;
                         'Zrušení dodacího listu dokladu ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      drgDBMS:open('pvphead',,,,,'pvp_head')
      drgDBMS:open('pvpitem',,,,,'pvp_item')

      pro_dodlsthd_cpy(self)
      nodel := .not. pro_dodlsthd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Dodací list _' +alltrim(str(dodlsthd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení dodacího listu ...' , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
*/
return .not. nodel


*
** CLASS for pro_explsthd_sel *************************************************
CLASS pro_explsthd_sel FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
  local dc := ::drgDialog:dialogCtrl

  do case
  case(nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT)
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  case(nEvent = drgEVENT_APPEND   )
  case(nEvent = drgEVENT_FORMDRAWN)
    return .T.

  case(nEvent = xbeP_Keyboard)
    do case
    case(mp1 = xbeK_ESC)
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.

hidden:
  var  drgGet
ENDCLASS


method pro_explsthd_sel:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::drgUsrClass:init(parent)
return self


method pro_explsthd_sel:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 90,10 DTYPE '10' TITLE 'Výbìr expedièního listu (výrobní zakázka) ...' ;
                                           FILE  'explsthd'                                      ;
                                           GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC SIZE 90,9.8                        ;
                        FIELDS 'ndoklad:expList,'        + ;
                               'dExpedice:datExpedice,'  + ;
                               'dNakladky:datNakl,'      + ;
                               'ccasNaklad:èasNakl,'     + ;
                               'ncisFirDOP:dopravce,'    + ;
                               'cnazevDOP:název dopravce'  ;
                        CURSORMODE 3 INDEXORD 1 SCROLL 'ny' PP 7
return drgFC


method pro_explsthd_sel:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*-  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]-25}
  endif
return