#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'c_meny', 'c_staty', 'kurzhd', 'kurzit' }
#define LF       Chr(10)

*
** vazba na položky kurzovního lístku CNB
#xtranslate .zeme     =>  \[ 1\]
#xtranslate .mena     =>  \[ 2\]
#xtranslate .mnozstvi =>  \[ 3\]
#xtranslate .kod      =>  \[ 4\]
#xtranslate .kurz     =>  \[ 5\]



**
** CLASS for FIN_kurzhd ********************************************************
CLASS FIN_kurzhd FROM drgUsrClass, FIN_finance_IN
EXPORTED:
  var     lnewRec, it_file
  method  init, drgDialogStart
  method  itemMarked, postValidate, postLastField

  method  get_kurzCNB_web

  inline method ebro_afterAppend(o_eBro)
    ::dm:set( 'kurzIT->ddatPlatn', date() )
    ::dm:set( 'kurzIT->nmnozPrep', c_meny->nmnozPrep )
    return .t.

  inline method eBro_saveEditRow(o_eBro)
    local  datPlatn  := ::dm:get(::it_file +'->ddatPlatn')

    (::it_file)->nDENkurz   := day      (datPlatn)
    (::it_file)->nTYDkurz   := Week     (datPlatn)
    (::it_file)->nMESkurz   := Month    (datPlatn)
    (::it_file)->nKVAkurz   := Quarter  (datPlatn)
    (::it_file)->nPOLkurz   := if( Month(datPlatn) <= 6, 1, 2 )
    (::it_file)->nrokKurz   := Year     (datPlatn)
    (::it_file)->cmesKurz   := cMonth   (datPlatn)

    (::it_file)->czkratMeny := c_meny->czkratMeny
    (::it_file)->nmnozPrep  := c_meny->nmnozPrep
    return .t.


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local lastDrg := ::df:oLastDrg

    ::dc:isChild := (lastDrg = ::a_obrow[2])

    do case
    case(lastDrg = ::a_obrow[2] .or. lastDrg:className() = 'drgGet')
      do case
      case nEvent = drgEVENT_DELETE
        ::fin_kurzhd_del()
        return .t.

      case nEvent = xbeP_Keyboard .and. lastDrg:className() = 'drgGet'
        if mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
          ::df:olastdrg   := ::obro_kurzi
          ::df:nlastdrgix := ::nbro_kurzi
          ::df:olastdrg:setFocus()
          ::restColor()
          PostAppEvent(xbeBRW_ItemMarked,,,::obro_kurzi:oxbp)
          ::obro_kurzi:oxbp:refreshCurrent():hilite()
          return .t.
        endif
      endcase

    case nEvent = drgEVENT_DELETE
      return .t.
    endcase
    return .f.

HIDDEN:
  var     a_obrow, obro_kurzi, nbro_kurzi
  method  fin_kurzhd_del
ENDCLASS


method FIN_kurzhd:init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::it_file := 'kurzit'

  * základní soubory
  ::openfiles(m_files)

  * pro aktualizaci kurzu z WEBu CNB
  drgDBMS:open( 'c_meny' ,,,,, 'c_menyW' )
  drgDBMS:open( 'kurzit' ,,,,, 'kurzitW' )
return self


method FIN_kurzhd:drgDialogStart(drgDialog)
  local members := drgDialog:oForm:aMembers, x

  ::fin_finance_in:init(drgDialog,'poh','kurzit->ddatPlatn',' položku kurzovního lístku')

   for x := 1 TO LEN(members) step 1
     if( members[x]:ClassName() = 'drgEBrowse')
       if lower(members[x]:cfile) = 'kurzit'
         ::obro_kurzi := members[x]
         ::nbro_kurzi := x
       endif
     endif
   next

  ::a_obrow := drgDialog:odbrowse
  ::brow    := ::obro_kurzi:oxbp
return self


method FIN_kurzhd:itemMarked()
  c_staty ->(dbSeek(upper(c_meny->czkratMeny),,'C_STATY3'))
  kurzit  ->(dbSetScope(SCOPE_BOTH, upper(c_meny->czkratMeny)),dbGoTop())
return self


method FIN_kurzhd:postValidate(drgVar)
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
  case(name = 'kurzit->ddatplatn' )
    if( empty(value), ( ok := .F., drgMsgBOX( 'DATUM platnosti je povinný údaj ...' )), NIL )

  case(name = 'kurzit->nkurzstred')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
    endif
  endcase
return ok


method FIN_kurzhd:postLastField()
  local  isChanged := ::dm:changed()
  local  datPlatn  := ::dm:get(::it_file +'->ddatPlatn')
  *
  local  mesKurz   := month(datPlatn)

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), replrec(::it_file))
    if( ::state = 2, mh_copyFld('c_meny', ::it_file,, .f.), nil)

    (::it_file)->nDENkurz := day          (datPlatn)
    (::it_file)->nTYDkurz := mh_WeekOfYear(datPlatn)
    (::it_file)->nMESkurz := mesKurz
    (::it_file)->nKVAkurz := round(mesKurz/3,0)
    (::it_file)->nPOLkurz := round(mesKurz/2,0)
    (::it_file)->nrokKurz := Year  (datPlatn)
    (::it_file)->cmesKurz := cMonth(datPlatn)

    ::itsave()

    if .not. kurzhd->(dbSeek(dtos(datPlatn),,'KURZHD1'))
      if(addrec('kurzhd'), (kurzit->(dbCommit()), mh_copyFld('kurzit','kurzhd',, .f.)), nil)
    endif
  endif

  ::df:olastdrg   := ::obro_kurzi
  ::df:nlastdrgix := ::nbro_kurzi
  ::df:olastdrg:setFocus()
  PostAppEvent(xbeBRW_ItemMarked,,,::a_obrow[1]:oxbp)

  kurzhd->(dbUnlock(), dbCommit())
   kurzit->(dbUnlock(), dbCommit())
    ::dm:refresh()
return .t.


method FIN_kurzhd:get_kurzCNB_web()
  local  ccnbHost := "http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt"  // ?date=29.03.2017"
*                    (bez parametru, pouze pro aktuální devizové kurzy)
  local  ckurz_UTF8, ckurz_ANSI, pa, x, pa_kurz
  local  ddayKurzu
  local  c_zeme, c_mena, n_mnozstvi, c_kod, n_kurz
  local  omoment

  omoment    := sys_moment("=== AKTUALIZUJI KURZOVNÍ LÍSTEK ===" )
  ckurz_UTF8 := loadFromUrl(ccnbHost)

  // sránka nenalezena, není pøipojení k internetu
  if isCharacter(ckurz_UTF8) .and. left(ckurz_UTF8,15) <> '<!DOCTYPE html>'

    ckurz_ANSI := CUTF8TOANSI(ckurz_UTF8)
    pa         := listAsArray(ckurz_ANSI, LF)
    ddayKurzu  := ctod( left(pa[1],10 ))

    for x := 3 to len(pa) step 1
      if len(pa_kurz := listAsArray( pa[x], '|')) = 5

        c_zeme     :=              pa_kurz.zeme
        c_mena     :=              pa_kurz.mena
        n_mnozstvi := val(         pa_kurz.mnozstvi)
        c_kod      := upper(       pa_kurz.kod)
        n_kurz     := val(strTran( pa_kurz.kurz, ',', '.'))

        if c_menyW->( dbseek( c_kod,,'C_MENY1'))
          if .not. kurzitW->( dbseek( c_kod +dtos(ddayKurzu),,'KURZIT2'))

            kurzitW->( dbappend())

            ( kurzitW->ddatPlatn  := ddayKurzu                         , ;
              kurzitW->nDENkurz   := Day    (ddayKurzu)                , ;
              kurzitW->nTYDkurz   := Week   (ddayKurzu)                , ;
              kurzitW->nMESkurz   := Month  (ddayKurzu)                , ;
              kurzitW->nKVAkurz   := Quarter(ddayKurzu)                , ;
              kurzitW->nPOLkurz   := if( Month( ddayKurzu) <= 6, 1, 2 ), ;
              kurzitW->nrokKurz   := Year   (ddayKurzu)                , ;
              kurzitW->cmesKurz   := cMonth (ddayKurzu)                , ;
              kurzitW->czkratMeny := c_kod                             , ;
              kurzitW->nmnozPrep  := n_mnozstvi                        , ;
              kurzitW->nkurzStred := n_kurz                            , ;
              kurzitW->nkurzNakup := n_kurz                            , ;
              kurzitW->nkurzProde := n_kurz                            , ;
              kurzitW->dvznikZazn := date()                              )

            kurzitW->( dbunlock(), dbcommit())
          endif
        endif
      endif
    next
  endif

  omoment:destroy()
return .t.


method FIN_kurzhd:fin_kurzhd_del()
  local  nsel, nodel := .f.
  *
  local  ky := '_ ' +kurzit->czkratMeny +' ze dne ' +dtos(kurzit->ddatPlatn) +' _'

  if .not. empty(kurzit->czkratMeny)
    nsel := ConfirmBox( ,'Požadujete zrušit položku kurzovního lístku ...' +chr(13) +chr(10) +ky, ;
                         'Zrušení položky kurzovního lístku ...' , ;
                          XBPMB_YESNO                            , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      if( kurzit->(sx_rLock()), kurzit->(dbdelete(), dbUnLock()), nodel := .t.)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Položku kurzovního lístku ...' +chr(13) +chr(10) +ky +' nelze zrušit ...', ;
                 'Zrušení položky kurzovního lístku ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel

*                               c_staty                                c_meny
* fakvyshd  --  c.ctypPohybu, g.czkratStat, g.dvystFak, g.cbank_uct, c.czkratMenZ
* fakprihd  --  c.ctypPohybu, g.czkratStat, g.dvystFak, g.cbank_uct, c.czkratMenZ
function fin_kurzit_get(drgVar)
  local  changed    := drgVar:itemChanged()
  *
  local  item_name  := lower(drgVar:name)
  local  field_name := lower(drgParseSecond(item_name, '>'))
  local  file_name  := drgParse(item_name,'-')
  *
  local  zaklMena   := SysConfig('Finance:cZaklMena'), lis_zaklMena
  *
  local  it_kurz    := 'ctyppohybu,czkratstat,dvystfak,cbank_uct,czkratmenz'
  local  pa_datDokl := { 'dvystFak', 'dporizDok', 'dporizPri', 'ddatObj', 'ddatOdes' }
  local  ctypKurzu  := 'DEN', ddatDokl := date(), czkratMeny
  local  ctag, cky

  if ( field_name $ it_kurz ) .and. changed
    do case
    case field_name $ 'ctyppohybu'

    case field_name $ 'czkratstat'
      c_staty->(dbseek(upper(drgVar:value),,'C_STATY1'))
      czkratmeny := upper(c_staty->czkratMeny)

    case field_name $ 'dvystfak'
      ddatDokl := drgVar:value

    case field_name $ 'cbank_uct'
      czkratMeny := upper(c_bankuc->czkratmeny)

    case field_name $ 'czkratmenz'
      c_meny->(dbseek(upper(drgVar:value),,'C_MENY1'))
      czkratMeny := upper(c_meny->czkratMeny)
    endCase

    if( npos := (file_name)->( fieldPos('ctypKurzu')) ) <> 0
      ctypKurzu := (file_name)->(fieldGet(npos))
      if( empty(ctypKurzu), ctypKurzu := 'DEN', nil )
    endif

    if( empty(czkratMeny), czkratMeny := (file_name)->czkratMenz, nil )
    if empty(ddatDokl)
      aEval( pa_datDokl, { |x| npos := (file_name)->( fieldPos(x)) } )
      if npos <> 0
        ddatDokl := (file_name)->(fieldGet(npos))
      endif
    endif

    czkratMeny   := upper(czkratMeny)
    lis_zaklMena := Equal( czkratMeny, zaklMena )

    do case
    case ( ctypKurzu = 'DEN' )
      kurzit->( ordSetFocus( 'KURZIT9' ), dbsetscope(SCOPE_BOTH, czkratMeny))

      cky := czkratMeny +dtos(ddatDokl)
      kurzit->(dbseek(cky,.t.))
      if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)

    case ( ctypKurzu = 'TYD' )  ;  ( ctag := 'KURZIT4', cky := czkratMeny +strZero(Week(ddatDokl),2) )
    case ( ctypKurzu = 'MES' )  ;  ( ctag := 'KURZIT5', cky := czkratMeny +strZero(Month(ddatDokl),2) )
    case ( ctypKurzu = 'QVA' )  ;  ( ctag := 'KURZIT6', cky := czkratMeny +strZero(Quarter(ddatDokl),2) )
    case ( ctypKurzu = 'POL' )  ;  ( ctag := 'KURZIT7', cky := czkratMeny +if( Month(ddatDokl) <= 6, '01', '02' ) )
    case ( ctypKurzu = 'ROK' )  ;  ( ctag := 'KURZIT8', cky := czkratMeny + strZero(Year(ddatDokl),4) )
    endcase

    if .not. empty(ctag)
      kurzit->( ordSetFocus(ctag), dbsetscope(SCOPE_BOTH, cky), dbgoTop())
    endif

    (file_name)->czkratmenz := czkratMeny
    (file_name)->nkurzahmen := if(lis_zaklMena, 1, kurzit->nkurzstred )
    (file_name)->nmnozprep  := if(lis_zaklMena, 1, kurzit->nmnozprep  )

    eval(drgVar:block, drgVar:value)
    fin_refresh_get( drgVar )

    kurzit->(dbclearscope())
  endif
return .t.


static function fin_refresh_get(drgVar,nextFocus,vars_)
  local  nin, ovar, vars, new_val, dbArea

  default nextFocus to .f.

  if isobject(drgVar)  ;  dbarea := lower(drgParse(drgVar:name,'-'))
                          vars   := drgVar:drgDialog:dataManager:vars
  else                 ;  dbarea := lower(drgVar)
                          vars   := vars_
  endif

  for nIn := 1 TO vars:size() step 1
    oVar := vars:getNth(nIn)

    if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
      if(new_val := eval(ovar:block)) <> ovar:value
        ovar:set(new_val)
      endif
      ovar:initValue := ovar:prevValue := ovar:value
    endif
  next

  if nextFocus
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
return .t.
