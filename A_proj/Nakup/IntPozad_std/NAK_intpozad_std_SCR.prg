#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for NAK_intpozad_std_SCR *********************************************
CLASS NAK_intpozad_std_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart  // , itemMarked, postDelete
*  method  nak_objvyshd_vykr

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
*      ::postDelete()
      return .t.
    endcase
    return .f.

  * intPozad položky - BRo
  inline access assign method bmp_stavDokl() var bmp_stavDokl
    local  stavDokl := intPozad->cstavDokl
    local  retVal   := 0

    retVal := if( stavDokl = 'U', MIS_ICON_OK   , ;
               if( stavDokl = 'R', 510          , ;
                if( stavDokl = 'K', MIS_BOOKOPEN, ;
                 if( stavDokl = 'O', MIS_BOOK   , ;
                  if( stavDokl = 'S', MIS_NO_RUN, 0 )))))

    return retVal

  inline access assign method typSklPol() var typSklPol
    local  pa     := ::pa_typSklPol
    local  npos, retVal := ''

    if .not. intPozad->(eof())
      if( npos := ascan( pa, {|x| x[1] = allTrim(intPozad->ctypSklPol)} ) ) <> 0
        retVal := pa[npos,2]
      endif
    endif
    return retVal


  inline access assign method nazev_firmy() var nazev_firmy
    firmy ->(dbseek(intpozad->ncisfirmy,,'FIRMY1'))
    return firmy->cnazev


HIDDEN:
* sys
  var  msg, dm

* virtuální
  var  pa_typSklPol

  var  oDBro_main
  var  tabnum, brow

ENDCLASS


method NAK_intpozad_std_SCR:init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('cenZboz' )
  drgDBMS:open('dodZboz' )
  drgDBMS:open('firmy'   )
  drgDBMS:open('vyrzakit')
  drgDBMS:open('osoby'   )
  drgDBMS:open('c_dph'   )
  drgDBMS:open('intPozad',,,,,'int_Pozad' )
  *
  drgDBMS:open('vazSpoje')
  drgDBMS:open('spojeni')
return self



method NAK_intpozad_std_SCR:drgDialogStart(drgDialog)
  local  pa, pb, pa_typSklPol := {}
  local  odesc, pa_it := {}, pa_quick := {{ 'Kompletní seznam       ', ''                 }, ;
                                          { 'Není objednáno         ', 'cstavDokl <> "O"' }  }

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager

  ::brow       := drgDialog:dialogCtrl:oBrowse
  ::oDBro_main := ::brow[1]

  * typ položky
  if isObject( odesc := drgRef:getRef( 'TYPSKLPOL' ))
    pa := listAsArray( odesc:values )

    aeval( pa, {|x| ( pb := listAsArray(x, ':'), aadd( pa_typSklPol, {allTrim(pb[1]), pb[2]} ) ) } )
  endif
  ::pa_typSklPol := aclone(pa_typSklPol)

  * quick stav dokladu
  if isObject( odesc := drgRef:getRef( 'cstavdokl' ))
    pa := listAsArray( odesc:values )

    aeval( pa, {|x| ( pb := listAsArray(x, ':'), aadd( pa_it, {allTrim(pb[1]) +' ', pb[2]} ) ) } )
  endif
  aeval( pa_it, { |x| aadd( pa_quick, { x[2], 'cstavDokl = "' +x[1] +'"' } ) })
  ::quickFiltrs:init( self, pa_quick, 'int_požadavky' )

  ::oDBro_main:oXbp:refreshAll()
return

/*
method NAK_objvyshd_SCR:itemMarked()
  local  mky := upper(objvyshd->ccisobj)
  local  sub := {'objvysit', 'pvpitem'  }
  local  ord := {'OBJVYSI2', 'PVPITEM14'}
  *
  (sub[::tabnum])->(AdsSetOrder(ord[::tabnum]),dbsetscope(SCOPE_BOTH,mky),dbgotop())
**  ::brow[::tabnum +1]:oxbp:refreshAll()
return self


method NAK_objvyshd_SCR:postDelete()
  local  nsel, nodel := .f.

  if objvyshd->ndoklad <> 0
    nsel := ConfirmBox( ,'Požadujete zrušit objednávku vystavenou _' +objvyshd->ccisOBJ +'_', ;
                         'Zrušení objednávky vystavené ...' , ;
                          XBPMB_YESNO                       , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      nak_objvyshd_cpy(self)
      nodel := .not. nak_objvyshd_del(self)
      *
      objvyshdw->(dbclosearea())
       objvysitw->(dbclosearea())
        objvy_itw->(dbclosearea())
         vztahobjw->(dbclosearea())
          vztahob_w->(dbclosearea())
    else
      nodel := .f.
    endif
  endif

  if nodel
    ConfirmBox( ,'Objednávku vystavenou _' +objvyshd->ccisOBJ +'_' +' nelze zrušit ...', ;
                 'Zrušení objednávky vystavené ...' , ;
                 XBPMB_CANCEL                       , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::itemMarked()
  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


method  NAK_objvyshd_SCR:nak_objvyshd_vykr()
  local  cMess := 'Promiòte prosím, ' +CRLF
  local  cTitl := 'Vykrytí objednávky '
  local  nsel
  *
  local  arSelect := ::oDBro_main:arSelect
  local  lsel     := ( len( ::oDBro_main:arSelect) <> 0 )
  local  cdoklad  := '', x
  *
  local cStatement, oStatement
  local stmt := "update objVysIT set nmnozPLdod = nmnozOBdod, " + ;
                                    "nmnoz_fakt = nmnozOBdod, " + ;
                                    "nstav_fakt = 2,"           + ;
                                    "ddatRvykr  = curdate() "   + ;
                        "where ndoklad in ( %cdoklad );"        + ;
                "update objVysHD set nmnozPLdod = nmnozOBdod, " + ;
                                    "ddatRvykr  = curdate() "   + ;
                        "where ndoklad in ( %cdoklad );"

  cMess += 'požadujete ruèní vykrytí ' +if( lsel, 'objednávek ', 'objednávky') +CRLF

   nsel := ConfirmBox( ,cMess +chr(13) +chr(10), ;
                         cTitl                  , ;
                         XBPMB_YESNO            , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

  if nsel = XBPMB_RET_YES

    do case
    case len( arSelect) <> 0
      fordRec( {'objVysHD' } )

      for x := 1 to len( arSelect) step 1
        objVysHD->( dbgoTo( arSelect[x]))
        cdoklad += strTran( str(objVysHD->ndoklad), ' ', '') +','
      next
      fordRec()
      cdoklad := left( cdoklad, len( cdoklad) -1)

    otherwise
      cdoklad := strTran( str(objVyshd->ndoklad), ' ', '')
    endcase

    cStatement := strTran( stmt, '%cdoklad', cdoklad )
    oStatement := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
*      return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif

    if lsel
      ::oDBro_main:arSelect := {}
      ::oDBro_main:oxbp:refreshAll()
    else
      ::oDBro_main:oxbp:refreshCurrent()
    endif

    ::itemMarked()
  endif
return
*/
