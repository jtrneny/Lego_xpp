#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'c_meny', 'c_mince', 'c_staty' }


**
** CLASS for FIN_c_meny_mince *************************************************
CLASS FIN_c_meny_mince FROM drgUsrClass, FIN_finance_IN
EXPORTED:
  var     lnewRec, it_file
  method  drgDialogStart
  method  itemMarked, postValidate


  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::lnewRec := .f.
    ::it_file := 'c_mince'

    * základní soubory
    ::openfiles(m_files)

     * pro kontrolu
     drgDBMS:open('c_mince',,,,,'c_mince_v')
  return self


  inline method drgDialogInit(drgDialog)

    drgDialog:dialog:drawingArea:bitmap  := 1017
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return


  inline method ebro_afterAppend(o_eBro)
    ::dm:set( 'c_mince->czkrMince', c_meny->czkratMeny )

    ::df:olastdrg   := ::oget_nazMince
    ::df:nlastdrgix := ::nget_nazMince
    ::df:olastdrg:setFocus()
    return .t.

  inline method eBro_saveEditRow(o_eBro)

    (::it_file)->czkratMeny := c_meny->czkratMeny
    return .t.


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local lastDrg := ::df:oLastDrg

    ::dc:isChild := (lastDrg = ::a_obrow[2])

    do case
    case(lastDrg = ::a_obrow[2] .or. lastDrg:className() = 'drgGet')
      do case
      case nEvent = drgEVENT_DELETE
        ::fin_c_mince_del()
        return .t.

      case nEvent = xbeP_Keyboard .and. lastDrg:className() = 'drgGet'
        if mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
          ::df:olastdrg   := ::obro_c_mince
          ::df:nlastdrgix := ::nbro_c_mince
          ::df:olastdrg:setFocus()
          ::restColor()
          PostAppEvent(xbeBRW_ItemMarked,,,::obro_c_mince:oxbp)
          ::obro_c_mince:oxbp:refreshCurrent():hilite()
          return .t.
        endif
      endcase

    case nEvent = drgEVENT_DELETE
      return .t.
    endcase
    return .f.

HIDDEN:
  var     a_obrow, obro_c_mince , nbro_c_mince
  var              oget_nazMince, nget_nazMince
  method  fin_c_mince_del
ENDCLASS



method FIN_c_meny_mince:drgDialogStart(drgDialog)
  local members := drgDialog:oForm:aMembers, x

  ::fin_finance_in:init(drgDialog,'poh','c_mince->cnazMince',' položku v seznamu mincí')

   for x := 1 TO LEN(members) step 1
     if( members[x]:ClassName() = 'drgEBrowse')
       if lower(members[x]:cfile) = 'c_mince'

         ::obro_c_mince := members[x]
         ::nbro_c_mince := x
       endif
     endif

     if( members[x]:ClassName() = 'drgGet')
       if lower(members[x]:name) = 'c_mince->cnazmince'
         ::oget_nazMince := members[x]
         ::nget_nazMince := x
       endif
     endif
   next

  ::a_obrow := drgDialog:odbrowse
  ::brow    := ::obro_c_mince:oxbp
return self


method FIN_c_meny_mince:itemMarked()

  c_staty ->( dbSeek(upper(c_meny->czkratMeny),,'C_STATY3'))
  c_mince ->( dbSetScope(SCOPE_BOTH, upper(c_meny->czkratMeny)),dbGoTop())
return self


method FIN_c_meny_mince:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := lower( drgParseSecond(name,'>'))
  local  ok     := .T., changed := drgVAR:changed()
  local  cmsg
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case( item = 'cnazmince' .or. item = 'nhodmince' .or. item = 'czkrmince' .or. item = 'nvalmince' )

    if empty(value)
      cmsg := if( item = 'cnazmince', 'Název ', ;
               if( item = 'nhodmince', 'Typ '   , ;
                if( item = 'czkrmince', 'Zkratka ', 'Hodnodta ') ) )

      fin_info_box( cmsg +'mince, je povinný údaj ...',  XBPMB_CRITICAL)
      ok := .f.
    endif

  endCase
return ok


method FIN_c_meny_mince:fin_c_mince_del()
  local  nsel, nodel := .f.
  local  ky :=  '        ' +allTrim(str(c_mince->nhodMince)) +'/' +c_mince->czkrMince +'   ' +c_mince->cNazMince

  if .not. empty(c_mince->czkratMeny)
    nsel := ConfirmBox( ,'Požadujete zrušit položku bankovky/mince ...' +CRLF +CRLF +ky, ;
                         'Zrušení položky bankovky/mince ...' , ;
                          XBPMB_YESNO                            , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      if( c_mince->(sx_rLock()), c_mince->(dbdelete(), dbUnLock()), nodel := .t.)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Položku bankovky/mince ...' +CRLF +CRLF +ky +' nelze zrušit ...', ;
                 'Zrušení položky bankovky/mince ...' , ;
                 XBPMB_CANCEL                         , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel