#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"


function pocetHlasu_cmp( hodnotaVh, pocetAkci )
  local  pocetHlas := 0, typVYPhla, dlelitel

  drgDBMS:open( 'c_typvyphl' )

  if c_typvyphl->( dbseek( '1',, 'C_TYPVYP03'))
    typVYPhla := c_typvyphl->ntypVYPhla
    delitel   := c_typvyphl->ndelitel

    do case
    case ( typVYPhla = 1 )
      pocetHlas := int( hodnotaVh / delitel )

    case ( typVYPhla = 2 )
      pocetHlas := int( pocetAkci / delitel )

    case ( typVYPhla = 3 )
      pocetHlas := min( int( hodnotaVh / delitel ), 5 )

    endcase
  endif
return pocetHlas


**
** CLASS for AKC_c_typvyphl ****************************************************
CLASS c_typvyphl FROM drgUsrClass
EXPORTED:
  var     lnewRec, it_file
  method  drgDialogStart
  method  postValidate


  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::lnewRec := .f.
    ::it_file := 'c_mince'

    * základní soubory
**    ::openfiles(m_files)

     * pro kontrolu
     drgDBMS:open('c_mince',,,,,'c_mince_v')
  return self


  inline method drgDialogInit(drgDialog)

    drgDialog:dialog:drawingArea:bitmap  := 1017
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return


  inline method eBro_beforSaveEditRow(o_eBro)
    local laktivni := ::dm:get('c_typvyphl->laktivni')
    local ndelitel := ::dm:get('c_typvyphl->ndelitel')
    *
    local oStatement, cStatement := 'update c_typvyphl set laktivni = .f.'


    if laktivni <> c_typvyphl->laktivni
      oStatement := AdsStatement():New(cStatement,oSession_data)

      if oStatement:LastError > 0
*        return .f.
      else
        oStatement:Execute( 'test', .f. )
      endif

      oStatement:Close()

      ::brow:refreshAll()
    endif
    return .t.


  inline method eBro_saveEditRow(o_eBro)

    o_eBro:enabled_insCykl := .f.
    return .t.


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local lastDrg := ::df:oLastDrg

/*
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
*/
    return .f.

HIDDEN:
* sys
  var     msg, dm, dc, df

  var     brow
  var     a_obrow, obro_c_mince , nbro_c_mince
  var              oget_nazMince, nget_nazMince
ENDCLASS



method c_typvyphl:drgDialogStart(drgDialog)
  local members := drgDialog:oForm:aMembers, x

*  ::fin_finance_in:init(drgDialog,'poh','c_mince->cnazMince',' položku v seznamu mincí')

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataManager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

   for x := 1 TO LEN(members) step 1
     if( members[x]:ClassName() = 'drgEBrowse')
       if lower(members[x]:cfile) = 'c_typvyphl'

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


method c_typvyphl:postValidate(drgVar)
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