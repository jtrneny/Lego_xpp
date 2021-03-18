#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for NAK_objvyshd_SCR **************************************************
CLASS NAK_objvyshd_SCR FROM drgUsrClass
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked, postDelete
  method  nak_objvyshd_vykr
  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

  * objvyshd
  inline access assign method stav_objvyshd() var stav_objvyshd
    local retVal := 0

    do case
    case(objvyshd->nmnozobdod = 0                    )  ;  retVal := 302
    case(objvyshd->nmnozpldod = 0                    )  ;  retVal :=   0
    case(objvyshd->nmnozpldod >= objvyshd->nmnozobdod)  ;  retVal := 302
    case(objvyshd->nmnozpldod <  objvyshd->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal

  inline access assign method datum_tisku() var datum_tisku
    return if( empty( objVyshd->ddatTisk), 0, 553 )

  inline access assign method datum_emailu() var datum_emailu
    return  if( empty( isNull(objVyshd->ddatEmail,'')), 0, 553 )

  inline access assign method nazev_firmy() var nazev_firmy
    firmy ->(dbseek(objvyshd->ncisfirmy,,'FIRMY1'))
    return firmy->cnazev

  * objvysit
  inline access assign method stav_objvysit() var stav_objvysit
    local retVal := 0

    do case
    case(objvysit->nmnozobdod = 0                    )  ;  retVal := 302
    case(objvysit->nmnozpldod = 0                    )  ;  retVal :=   0
    case(objvysit->nmnozpldod >= objvysit->nmnozobdod)  ;  retVal := 302
    case(objvysit->nmnozpldod <  objvysit->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal

HIDDEN:
  var oDBro_main
  var tabnum, brow

ENDCLASS


method NAK_objvyshd_SCR:init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)
  *
  ::lnewRec := .f.
  ::tabnum  := 1
  *
  drgDBMS:open('objvyshd')
  drgDBMS:open('objvysit')
  drgDBMS:open('vztahobj')
  drgDBMS:open('objitem' )
  drgDBMS:open('pvpitem' )
  drgDBMS:open('cenzboz' )
  drgDBMS:open('firmy'   )

  * vazba na intPozad,
  * pokud by byl filtrovaný musím ji uvolnit pro ukládání vazby
  drgDBMS:open('intPozad',,,,,'int_Pozad' )

  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'objvyshd')
  endif
return self


method NAK_objvyshd_SCR:drgDialogStart(drgDialog)
  ::brow       := drgDialog:dialogCtrl:oBrowse
  ::oDBro_main := ::brow[1]
return


method NAK_objvyshd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()

  ::brow[::tabnum +1]:oxbp:refreshAll()
return .t.


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


/*
method  NAK_objvyshd_SCR:nak_objvyshd_vykr()
  local  anObj := {}

  FORDrec({'objvysit'})

  objvysit->( dbeval( {|| aadd( anObj, objvysit->(recNo())) }), dbgoTop())

  if objvyshd->(sx_rLock()) .and. objvysit->(sx_rLock(anObj))
   if drgIsYesNo( drgNLS:msg('Opravdu požadujete ruèní vykrytí objednávky ?') )

     do while .not. objvysit ->(eof())
       objvysit->nmnozPLdod := objvysit->nmnozOBdod
       objvysit->nmnoz_fakt := objvysit->nmnozOBdod
       objvysit->nstav_fakt := 2

//       objvysit->nmnoz _fakv:= objvysit->nmnozOBdod
//       objvysit->nstav_fakv := 2

       objvysit->ddatRvykr  := date()

       objvysit->(dbskip())
     enddo
     objvyshd->nmnozPLdod := objvyshd->nmnozOBdod
     objvyshd->ddatRvykr  := date()

   endif
  endif

  objvyshd->(dbunlock(), dbcommit())
   objvysit ->(dbunlock(), dbcommit())
    FORDrec()

  ::brow[1]:oxbp:refreshCurrent()
  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return

*/