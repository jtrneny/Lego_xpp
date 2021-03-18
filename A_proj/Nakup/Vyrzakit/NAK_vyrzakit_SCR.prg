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


#define m_files  { 'vyrzak', 'vyrzakit', 'explsthd', 'explstit', 'pvpitem' }


*
** CLASS for NAK_vyrzakit_SCR **************************************************
CLASS NAK_vyrzakit_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
//  var     sklVydeje
  method  init, drgDialogStart, tabSelect, itemMarked
  method  pro_explsthd_scr
  method  vyr_vyrzak_scr

  * položky - bro
  inline access assign method is_expList() var is_expList
    return if( .not. empty(vyrzakit->ncisloEL), MIS_ICON_OK, 0)

  inline access assign method firmaDOP() var firmaDOP
    explsthd->(dbseek(explstit->ndoklad,,'EXPLSTHD01'))
    return explsthd->cnazevDOP

  inline access assign method datExpedice() var datExpedice
    explsthd->(dbseek(explstit->ndoklad,,'EXPLSTHD01'))
    return explsthd->dexpedice

  inline access assign method datNakladky() var datNakladky
    explsthd->(dbseek(explstit->ndoklad,,'EXPLSTHD01'))
    return explsthd->dnakladky

  inline access assign method sklVydeje() var sklVydeje
    local retVal := 0.0000

    filtr := Format("ccisZakazI = '%%' and ccisSklad = '%%' and csklPol = '%%' and ntyppohyb = -1", { upper(vyrzakit->ccisZakazI), objvysit->ccissklad, objvysit->csklpol })
    pvpitem->( ads_setaof(filtr), DBGoBotTom(), dbeval({|| retVal += nmnozprdod } ) )

    return retVal


  * objvysit
  inline access assign method stav_objvysit() var stav_objvysit
    local retVal := 0

    do case
    case(objvysit->nmnozpldod = 0                    )  ;  retVal :=   0
    case(objvysit->nmnozpldod >= objvysit->nmnozobdod)  ;  retVal := 302
    case(objvysit->nmnozpldod <  objvysit->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local lastDrg := ::df:oLastDrg

    ::dc:isChild := (lastDrg = ::a_obrow[2])

    do case
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
*-      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, drgPush_del, drgPush_ins, a_obrow, obro_exi, nbro_exi
  method  postDelete
ENDCLASS


METHOD NAK_vyrzakit_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1
//  ::sklVydeje := 0

  * základní soubory
  ::openfiles(m_files)
RETURN self


METHOD NAK_vyrzakit_SCR:drgDialogStart(drgDialog)
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


METHOD NAK_vyrzakit_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
RETURN .T.


method NAK_vyrzakit_scr:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''
  local filtr

  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'vyrzakit','ab',if(cfile = 'explstit','b', ''))

    if( 'a' $ rest)
      ky := upper(vyrzakit->ccisZakazI)
      objvysit->(AdsSetOrder('OBJVYSI6'), dbsetScope(SCOPE_BOTH,ky),dbgotop())
    endif

    if (rest = 'b')
    endif
  endif

  vyrzak->(dbseek(upper(vyrzakit->ccisZakaz,,'VYRZAK1')))
*-  if( vyrzakit->ncisloEL = 0, ::drgPush:oxbp:hide(), ::drgPush:oxbp:show())
return self


method NAK_vyrzakit_scr:pro_explsthd_scr(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT

  DRGDIALOG FORM 'PRO_EXPLSTHD_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
return


method NAK_vyrzakit_scr:vyr_vyrzak_scr(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT

  DRGDIALOG FORM 'VYR_VYRZAK_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
return


method NAK_vyrzakit_scr:postDelete()
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

      NAK_dodlsthd_cpy(self)
      nodel := .not. NAK_dodlsthd_del(self)
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