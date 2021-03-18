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
** CLASS for PRO_objhead_SCR **************************************************
CLASS PRO_objhead_SCR FROM drgUsrClass
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked, postDelete
  method  pro_objhead_vykr

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

  * objhead
  inline access assign method stav_objhead() var stav_objhead
    local retVal := 0
    local doklad := strZero(objhead->ndoklad,10)
    *
    local s_0    := objit_sth->(dbseek(doklad +'0'))
    local s_1    := objit_sth->(dbseek(doklad +'1'))
    local s_2    := objit_sth->(dbseek(doklad +'2'))

    do case
    case( .not. s_1 .and. .not. s_2)            ;  retVal := 0
    case( .not. s_0 .and. .not. s_1) .and. s_2  ;  retVal := 302
    otherwise                                   ;  retVal := 303
    endcase
    return retVal

/*
    do case
    case(objhead->nmnozplodb = 0                   )  ;  retVal := 301
    case(objhead->nmnozplodb >= objhead->nmnozobodb)  ;  retVal := 302
    case(objhead->nmnozplodb <  objhead->nmnozobodb)  ;  retVal := 303
    endcase
    return retVal
*/

  * objitem
  inline access assign method stav_objitem() var stav_objitem
    local retVal := 0
    *
    local stav_fakt := objitem->nstav_fakt

    do case
    case( stav_fakt = 1 )  ;  retVal := 303
    case( stav_fakt = 2 )  ;  retVal := 302
    endcase
    return retVal

/*
    do case
    case(objitem->nmnozplodb = 0                   )  ;  retVal := 301
    case(objitem->nmnozplodb >= objitem->nmnozobodb)  ;  retVal := 302
    case(objitem->nmnozplodb <  objitem->nmnozobodb)  ;  retVal := 303
    endcase
    return retVal
*/

  * fakvysit
  inline access assign method stav_fakvysit() var stav_fakvysit
    local retVal := 0

    if fakvyshd->(dbseek(fakvysit->ncisfak,,'FODBHD1'))
      do case
      case(fakvyshd->nuhrcelfak = 0                    )  ;  retVal := 301
      case(fakvyshd->nuhrcelfak >= fakvyshd->ncenzakcel)  ;  retVal := H_big
      case(fakvyshd->nuhrcelfak <  fakvyshd->ncenzakcel)  ;  retVal := H_low
      endcase
    endif
    return retVal

  inline access assign method datvys_fakvysit() var datvys_fakvysit

    fakvyshd->(dbseek(fakvysit->ncisfak,,'FODBHD1'))
    return fakvyshd->dvystFak

  * objzak
  inline access assign method stav_objzak_naz() var stav_objzak_naz
    vyrzak->(dbseek(upper(objzak->cciszakaz),,'VYRZAK1'))
    return vyrzak->cnazevzak1

  inline access assign method stav_objzak_plm() var stav_objzak_plm
    return vyrzak->nmnozplano

HIDDEN:
  var tabnum, brow

ENDCLASS


method PRO_objhead_SCR:init(parent)
  local  pa_initParam
  local  filter := "nextObj = 1", cfilter

  ::drgUsrClass:init(parent)
  *
  ::tabnum  := 1
  ::lnewRec := .f.
  *
  drgDBMS:open('objhead' )
  drgDBMS:open('objitem' )

  drgDBMS:open('objitem',,,,,'objit_sth')   // pro stav na objhead
  objit_sth->(AdsSetOrder('OBJITE24'))

  drgDBMS:open('cenzboz' )
  drgDBMS:open('fakvyshd')
  drgDBMS:open('fakvysit')
  drgDBMS:open('dodsltit')
  drgDBMS:open('objzak'  )
  drgDBMS:open('vyrzak'  )
  drgDBMS:open('c_staty' )
  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    cfilter := '(' +filter + ' .and. ' +pa_initParam[2] +')'
  else
    cfilter := filter
  endif

  ::drgDialog:set_prg_filter( cfilter, 'objhead')
return self


method PRO_objhead_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
return


method PRO_objhead_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
return .t.


method PRO_objhead_SCR:itemMarked()
  local  mky := upper(objhead->ccislobint)
  local  sub := {'objitem' ,'fakvysit' ,'dodlstit', 'objzak' }
  local  ord := {'OBJITEM2','FVYSIT2'  ,'DODLIT2' , 'OBJZAK1'}
  *
  local  ab  := ::drgDialog:oActionBar:members, ev, om, x, ok := (::stav_objhead <> 302)
  *
  for x := 1 to len(ab) step 1
    ev := Lower(ab[x]:event)
    om := ab[x]:parent:aMenu

    ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
    ab[x]:oXbp:configure()
    if(ok, ab[x]:enable()  , ab[x]:disable())
    if(ok, om:enableItem(x), om:disableItem(x))
  next

  (sub[::tabnum])->(AdsSetOrder(ord[::tabnum]),dbsetscope(SCOPE_BOTH,mky),dbgotop())
  ::brow[::tabnum +1]:oxbp:refreshAll()
return self


method PRO_objhead_SCR:postDelete()
  local  nsel, nodel := .f.

  if objhead->ndoklad <> 0
    nsel := ConfirmBox( ,'Požadujete zrušit objednávku pøijatou _' +objhead->ccislObInt +'_', ;
                         'Zrušení objednávky pøijaté ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      pro_objhead_cpy(self)
      nodel := .not. pro_objhead_del(self)
      *
      objheadw->(dbclosearea())
       objitemw->(dbclosearea())
        objit_iw->(dbclosearea())
    else
      nodel := .f.
    endif
  endif

  if nodel
    ConfirmBox( ,'Objednávku pøijatou _' +objhead->ccislObInt +'_' +' nelze zrušit ...', ;
                 'Zrušení objednávky vystavené ...' , ;
                 XBPMB_CANCEL                       , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

**  ::drgDialog:dialogCtrl:refreshPostDel()
  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return .not. nodel


method  PRO_objhead_SCR:pro_objhead_vykr()
  local  anObj := {}

  FORDrec({'objitem'})

  objitem->( dbeval( {|| aadd( anObj, objitem->(recNo())) }), dbgoTop())

  if objhead->(sx_rLock()) .and. objitem->(sx_rLock(anObj))
   if drgIsYesNo( drgNLS:msg('Opravdu požadujete ruèní vykrytí objednávky ?') )

     do while .not. objitem ->(eof())
       objitem->nmnozPLodb := objitem->nmnozOBodb
       objitem->nmnoz_fakt := objitem->nmnozOBodb
       objitem->nstav_fakt := 2

       objitem->nmnoz_fakv := objitem->nmnozOBodb
       objitem->nstav_fakv := 2

       objitem->ddatRvykr  := date()

       objitem->(dbskip())
     enddo
     objhead->nmnozPLodb := objhead->nmnozOBodb
     objhead->ddatRvykr  := date()

   endif
  endif

  objhead->(dbunlock(), dbcommit())
   objitem ->(dbunlock(), dbcommit())
    FORDrec()

  ::brow[1]:oxbp:refreshCurrent()
  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return