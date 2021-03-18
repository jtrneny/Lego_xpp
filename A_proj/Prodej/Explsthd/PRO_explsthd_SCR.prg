#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"


#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys'                                              , ;
                   'c_dph' , 'c_typpoh'                                   , ;
                   'firmy' , 'dodlsthd', 'dodlstit', 'objitem', 'vyrzakit'  }


*
** CLASS for PRO_explsthd_SCR **************************************************
CLASS PRO_explsthd_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked
  method  explst_dodlst, fin_dodlsthd

  * položky - bro
  * explsthd
  inline access assign method isgen_dodList() var isgen_dodList
    local cKy  := strZero(explsthd->ndoklad,10)
    return if( dodlst_iG ->(dbSeek(cKy,,'DODLIT7')), MIS_ICON_OK, 0)

  * explstit
  inline access assign method is_vyrZakit() var is_vyrZakit
    return if( .not. empty(explstit->ccisZakazI), MIS_ICON_OK, 0)

  inline access assign method is_dodList() var is_dodList
    return if( .not. empty(explstit->ncisloDL), MIS_ICON_OK, 0)

  inline access assign method firmaODB() var firmaODB
    local retVal := ''

    if .not. empty(explstit->ncisFirmy)
      retVal := str(explstit->ncisFirmy) +' _' +left(explstit->cnazev,25)
    endif
  return retVal

  inline access assign method firmaDOA() var firmaDOA
    local retVal := ''

    if .not. empty(explstit->ncisFirDOA)
      retVal :=  str(explstit->ncisFirDOA) +' _' +left(explstit->cnazevDOA,25)
    endif
   return retVal

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow, ab
  method  postDelete
ENDCLASS


METHOD PRO_explsthd_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * základní soubory
  ::openfiles(m_files)

  drgDBMS:open('dodlstit',,,,,'dodlst_iG')


*** likvidace
*  ::FIN_finance_in:typ_lik := 'poh'
RETURN self


METHOD PRO_explsthd_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
  ::ab      := drgDialog:oActionBar:members    // actionBar

*-  dodlsthd->(dbgobottom())
RETURN


METHOD PRO_explsthd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
RETURN .T.


method pro_explsthd_scr:itemMarked(arowco,unil,oxbp,lin_genDL)
  local  ky, rest := ''
  *
  local  x, ev, om, ok    := (::isgen_dodList = 0), ok_dl

  default lin_genDL to .f.

  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    ky    := explsthd->ndoklad

    explstit->(AdsSetOrder('EXPLSTIT01'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    dodlstit->(AdsSetOrder('DODLIT7'   ),dbsetscope(SCOPE_BOTH,strZero(ky,10)),dbgotop())
 endif

 ok_dl := .not. dodlstit->(eof())

 for x := 1 to len(::ab) step 1
   ev := Lower(::ab[x]:event)
   om := ::ab[x]:parent:aMenu

   if     ev $ 'explst_dodlst'
     *
     ** volání z metody explst_dodlst()
     if( lin_genDL, ok := .f., nil )

     ::ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
     ::ab[x]:oXbp:configure()
     if(ok, ::ab[x]:oxbp:enable(), ::ab[x]:oxbp:disable())

   elseif ev $ 'fin_dodlsthd'
     ::ab[x]:oXbp:setColorFG(If(ok_dl, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
     ::ab[x]:oXbp:configure()
     if(ok_dl, ::ab[x]:oxbp:enable(), ::ab[x]:oxbp:disable())
   endif
 next

return self


method pro_explsthd_scr:postDelete()
  local  nsel, nodel := .f.

  if dodlstit->ndoklad = 0
    nsel := ConfirmBox( ,'Požadujete zrušit expedièní list _' +alltrim(str(explsthd->ndoklad)) +'_', ;
                         'Zrušení expedièního listu dokladu ...' , ;
                          XBPMB_YESNO                            , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES

      pro_explsthd_cpy(self)
      nodel := .not. pro_explsthd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Expedièní list _' +alltrim(str(explsthd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení expedièního listu ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


method pro_explsthd_scr:explst_dodlst()
  local  nsel, o, oxbp := ::drgDialog:oMessageBar:msgStatus
  local  ctext

  nsel := ConfirmBox( ,'Požadujete vytvoøit dodací list(y) k expediènímu listu _' +alltrim(str(explsthd->ndoklad)) +'_', ;
                       'Generování dodacího listu ...' , ;
                        XBPMB_YESNO                    , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES
    ::itemMarked(,,,.t.)

    show_in_msgStatus(oxbp, 'Vytváøím dodací list(y) k expediènímu listu _' +alltrim(str(explsthd->ndoklad)) )
      o := explst_dodlst():new()
      o:processed()
    show_in_msgStatus(oxbp,'Zpracování dodacího listu(ù) bylo dokonèeno ...' )
    tone(500,16)
    sleep(50)
  endif

  oxbp:setCaption('')
  ::itemMarked( ,,::brow[1]:oxbp)
  ::brow[3]:oxbp:goTop():refreshAll()
return self


method pro_explsthd_scr:fin_dodlsthd(drgDialog)
  local  odialog, nexit
  *
  local  recNo := dodlstit->( recNo())
  local  cc    := '', m_filter

  dodlstit->( dbeval( { || cc += "ndoklad = " +str( dodlstit->ndoklad) +" .or. " }) )
  if( .not. empty(cc), m_filter := "(" +left( cc, len(cc) -6) +")", nil )

  if .not. empty( m_filter)
    if(select('dodlsthd') = 0, drgDBMS:open('dodlsthd'), nil)
    dodlsthd->(ads_setAof(m_filter), dbgotop())

    oDialog := drgDialog():new('fin_fakvyshd_dodlsthd',drgDialog)
    odialog:create(,,.T.)

    dodlsthd->(ads_clearAof())

    odialog:destroy()
    odialog := nil
  endif

  ::itemMarked()
return



static function show_in_msgStatus(oxbp,ctext)
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  nSize   := oxbp:currentSize()[1]
  local  nHight  := oxbp:currentSize()[2] -2

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{nsize,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  GraStringAt( oPS, {30, 6}, ctext)
  oXbp:unlockPS(oPS)
return .t.