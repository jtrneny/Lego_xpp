#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "XBP.Ch"
#include "gra.ch"
#include "dll.ch"

#include "DRGres.Ch'
#include "..\Asystem++\Asystem++.ch"


class quickFiltrs
  exported:

  var     quickFilter
  var     sel_Item, sel_Filtrs

  var     oico_noQuick, oico_isQuick
  var     pb_context, a_popUp, barText, popState

  var     drgDialog, q_oBrowse, q_cFile


  inline method init( parent, a_popUp, barText )
     local  x, amembers := parent:drgDialog:oForm:aMembers
     *
     local  sel_Filtrs  := ::sel_Filtrs, in_file

     for x := 1 to len( amembers) step 1
       if  amembers[x]:ClassName() = 'drgPushButton'
         if( amembers[x]:event = 'createContext', ::pb_context := amembers[x], nil )
       endif
     next

     ::quickFilter :=  0

     *
     ** k inicialozaci prom�nn�ch sel%item a sel_Filtrs m��e doj�t v drgScrPos:getPos,
     ** pokud si u�ivatel quick p�ednastavil
     if( isNull( ::sel_Item  ), ::sel_Item   :=  '', nil )
     if( isNull( ::sel_Filtrs), ::sel_Filtrs :=  {}, nil )

*     ::sel_Item    :=  ''
*     ::sel_Filtrs  :=  {}
     ::a_popUp     :=  a_popUp
     ::barText     :=  isNull(barText, '' )
     ::popState    :=  1

     ::drgDialog   := parent:drgDialog

     ::q_oBrowse   := ::drgDialog:odBrowse[1]
     ::q_cFile     := ::q_oBrowse:cFile

     ::oico_noQuick := XbpIcon():new():create()
     ::oico_isQuick := XbpIcon():new():create()
     ::oico_isQuick:load( NIL, 101 )

     if isObject( ::pb_context )
       ::pb_context:oxbp:setImage( ::oico_noQuick )
     endif
     *
     ** quickFiltrs na dialogu
     ** { { 'msprc_mo,   { 'Pracovn�ci ve stavu    ', 'nstavem = 1' } }
     if .not. empty( sel_Filtrs )
       in_file    := lower(::q_cFile)

       if( nfile := ascan( sel_Filtrs, {|x| lower(x[1]) = in_file} )) <> 0
         if ( nitem := ascan( a_popUp, {|x| x[2] = sel_Filtrs[nfile,2,2]} )) <> 0
           ::quickFilter := nitem
           ::fromContext(nitem, sel_Filtrs[nfile,2], .t.)
         endif
       endif
     endif

   return self


  inline method createContext(a,b,c,d)
    local  csubmenu, opopup
    *
    local  pa      := ::a_popUp
    local  aPos    := ::pb_context:oXbp:currentPos()
    local  aSize   := ::pb_context:oXbp:currentSize()

    opopup         := XbpImageMenu( ::drgDialog:dialog ):new()
    opopup:barText := ::barText
    opopup:create()

    for x := 1 to len(pa) step 1
      if empty( pa[x,1] )
        opopup:addItem({ NIL                           , ;
                         NIL                           , ;
                         XBPMENUBAR_MIS_SEPARATOR      , ;
                         XBPMENUBAR_MIA_OWNERDRAW        } )

      else
        opopup:addItem( {pa[x,1]                       , ;
                         de_BrowseContext(self,x,pA[x]), ;
                                                       , ;
                         XBPMENUBAR_MIA_OWNERDRAW        }, ;
                         if( x = ::quickFilter, 500, 0)     )
     endif
    next


*   tady se mus� zjistit kdo je parentem a upravit aPos
    if ::pb_context:oxbp:parent:StyleClass = 'Button'
//      aPos[2] := ::pb_context:oXbp:parent:currentPos()[2] +aSize[2]
    endif

    opopup:popup( ::pb_context:oxbp:parent, apos )

//    opopup:popup( ::drgDialog:dialog, aPos )
  return self


  inline method fromContext(aorder, p_popUp, in_Start)
    local  d_obro     := ::q_oBrowse
    local  in_file    := lower(::q_cFile)
    local  filter     := p_popUp[2]
    *
    local  oIcon      := XbpIcon():new():create()
    local  sel_Filtrs := ::sel_Filtrs, a_popup := ::a_popup

    default in_Start   to .f.

    ::popState := aorder
    *
    ** ? ozna�il si p�ednastaven� quickFilter, pokud ne je to jen p�epnut�
    if AppKeyState( xbeK_CTRL ) = APPKEY_DOWN
      ::quickFilter := if( ::quickFilter = aorder, 0, aorder )
    endif

    ::pb_context:oxbp:setImage( if( ::quickFilter = aorder, ::oico_isQuick, ::oico_noQuick ))
    ::pb_context:oxbp:setCaption( allTrim( p_popUp[1]))
    ::pb_context:oxbp:setFont(drgPP:getFont(5))
    ::pb_context:oxbp:setColorFG(GRA_CLR_RED)

    ::quick_setFilter(filter, 'apu')

    if .not. in_Start

      * ulo��me si to
      if empty( sel_Filtrs)
        aadd( sel_Filtrs, { in_File, a_popUp[aorder] } )

      else
        if( nfile := ascan( sel_Filtrs, {|x| x[1] = in_File } )) = 0
          aadd( sel_Filtrs, { in_File, a_popUp[aorder] } )

        else
          sel_Filtrs[nfile,2] := a_popUp[aorder]

        endif
      endif

    endif
  return self


  inline method quick_setFilter(filter, capu)
    local  d_obro      := ::q_oBrowse
    local  in_file     := lower(::q_cFile)
    *
    local  ft_APU_cond, filtrs := ''

    default filter to '', ;
            capu   to 'apu'

    ft_APU_cond := ::drgDialog:get_APU_filter( in_file, capu)
           capu := lower(capu)

    * USR
    * 1 - zm�na na quickFiltr  -  pot�ebujeme apu - p�id�v�me q
    if 'u' $ capu
      if empty( ft_APU_cond )
        filtrs := if( .not. empty(filter), '(' +filter +')', '' )
      else
        filtrs := '(' +ft_APU_cond +')' +if( .not. empty(filter), ' .and. (' +filter +')', '' )
      endif
    endif

    ** QUICK
    *  2 - zm�na na programov�m filtru - pot�ebujeme apug
    if 'q' $ capu
      filtrs := ft_APU_cond
    endif

    if( empty( filtrs), (in_file)->(ads_clearAof()), (in_file)->(ads_setAof(filtrs)) )
    (in_file) ->(dbgotop())

    * ru��me ozna�en�
    d_obro:arselect := {}
    d_obro:oxbp:refreshAll()
    setAppFocus( d_obro:oxbp )

    postAppEvent( xbeBRW_ItemMarked,,, d_obro:oxbp)
  return self


  inline method quickFilterEnd(drgDialog)
    local  sel_Filtrs := ::sel_Filtrs
    local  in_file    := lower(::q_cFile)
    local  a_popup    := ::a_popup

    default ::sel_Filtrs to {}

    * ulo��me si jen pokud si n�co ozna�il
    if ::quickFilter <> 0
      if empty( sel_Filtrs)
        aadd( ::sel_Filtrs, { in_File, a_popUp[::quickFilter] } )

      else
        if( nfile := ascan( sel_Filtrs, {|x| x[1] = in_File } )) = 0
          aadd( ::sel_Filtrs, { in_File, a_popUp[::quickFilter] } )

        else
          ::sel_Filtrs[nfile,2] := a_popUp[::quickFilter]

        endif
      endif
    else
      if( nfile := ascan( sel_Filtrs, {|x| x[1] = in_File } )) <> 0
        aRemove( ::sel_Filtrs, nfile )
      endif
    endif
  return

endClass