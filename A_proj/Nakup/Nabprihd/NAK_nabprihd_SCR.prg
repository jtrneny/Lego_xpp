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
** CLASS for PRO_nabprihd_SCR **************************************************
CLASS NAK_nabprihd_SCR FROM drgUsrClass
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked, postDelete
  method  pro_nabvyshd_vykr

  * bro nabvyshd
  inline access assign method nazFirmy() var nazFirmy
    local  ky := nabprihd ->ncisfirmy
    firmy->(dbseek(ky,,'FIRMY1'))
    return firmy->cnazev

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

  * nabvyshd
  inline access assign method stav_nabvyshd() var stav_nabvyshd
    local retVal := 0
    local doklad := strZero(nabvyshd->ndoklad,10)
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
    case(nabvyshd->nmnozplodb = 0                   )  ;  retVal := 301
    case(nabvyshd->nmnozplodb >= nabvyshd->nmnozobodb)  ;  retVal := 302
    case(nabvyshd->nmnozplodb <  nabvyshd->nmnozobodb)  ;  retVal := 303
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


method NAK_nabprihd_SCR:init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)
  *
  ::tabnum  := 1
  ::lnewRec := .f.
  *
  drgDBMS:open( 'firmy',,,, .t. )
  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'nabvyshd')
  endif
return self


method NAK_nabprihd_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
return


method NAK_nabprihd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
return .t.


method NAK_nabprihd_SCR:itemMarked()
  local mky := nabprihd->ndoklad

  nabpriit->( AdsSetOrder( 'NABPRII8' ), dbsetScope( SCOPE_BOTH,mky),dbgotop())
return self


method NAK_nabprihd_SCR:postDelete()
  local  nsel, nodel := .f.
  *
  local  cdoklad := allTrim(str(nabprihd->ndoklad))

  if nabprihd->ndoklad <> 0
    nsel := ConfirmBox( ,'Požadujete zrušit nabídku pøijatou _' +cdoklad +'_', ;
                         'Zrušení nabídky pøijaté ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

   if nsel = XBPMB_RET_YES
     nak_nabprihd_cpy(self)
     nodel := .not. nak_nabprihd_del(self)
     *
     nabprihdw->( dbCloseArea())
     nabpriitw->( dbCloseArea())
   else
     nodel := .f.
   endif
 endif


  if nodel
    ConfirmBox( ,'Nababídku pøijatou _' +cdoklad +'_' +' nelze zrušit ...', ;
                 'Zrušení nabídky pøijaté ...' , ;
                 XBPMB_CANCEL                       , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return .not. nodel


method NAK_nabprihd_SCR:pro_nabvyshd_vykr()
  local  anObj := {}

  FORDrec({'objitem'})

  objitem->( dbeval( {|| aadd( anObj, objitem->(recNo())) }), dbgoTop())

  if nabvyshd->(sx_rLock()) .and. objitem->(sx_rLock(anObj))
   if drgIsYesNo( drgNLS:msg('Opravdu požadujete ruèní vykrytí objednávky ?') )

     do while .not. objitem ->(eof())
       objitem->nmnozPLodb := objitem->nmnozOBodb
       objitem->nmnoz_fakt := objitem->nmnozOBodb
       objitem->nstav_fakt := 2
       objitem->ddatRvykr  := date()

       objitem->(dbskip())
     enddo
     nabvyshd->nmnozPLodb := nabvyshd->nmnozOBodb
     nabvyshd->ddatRvykr  := date()

   endif
  endif

  nabvyshd->(dbunlock(), dbcommit())
   objitem ->(dbunlock(), dbcommit())
    FORDrec()

  ::brow[1]:oxbp:refreshCurrent()
  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return