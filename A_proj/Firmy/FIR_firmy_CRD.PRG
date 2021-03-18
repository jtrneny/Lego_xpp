#include "common.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
#include "class.ch"
#include "asxml.ch"
*
#include "adsdbe.ch'
*
#include "drg.ch"
#include "DRGres.Ch'
#include "..\Asystem++\Asystem++.ch"

#pragma library("asxml10.lib")
#pragma library("ot4xb.lib"  )


  *  1 - Základní údaje   - FIRMYw     -  culice
  *  2 - Bankovní úèty    - FIRMYUCw   -  BRO
  *  3 - Dodavatel        - FIRMYFIw   -  cuct_dod
  *  4 - Odbìratel        - FIRMYFIw   -  cuct_odb
  *  5 - Podr_úèty        - C_PODRUCw  -  BRO
  *  6 - Skupiny          - FIRMYVAw   -  BRO
  *      7 - Fakt_Adresa    - FIRMYSKw  - 1:1
  *      8 - Dod_Adresa                 - 1:N  duplicita
  *      9 - Dopravce                   - 1:N  duplicita
  *     10 - Odbìratelé                 - 1:N  duplicita
  *     11 - Dodavatelé                 - 1:N  duplicita
  *     12 - Kor_Adresa                 - 1:1
  * 13 - Poznámky       - FIRMYw


*
** CLASS FOR FIR_firmy_CRD *****************************************************
CLASS FIR_firmy_CRD FROM drgUsrClass, SYS_ARES_forAll
EXPORTED:
  method  init, drgDialogStart, postValidate, postSave, drgDialogEnd
  method  itemMarked
  method  postValidateForm
  *
  method  fir_firmy_sel
  method  ebro_beforeAppend, ebro_saveEditRow
  *
  var     lnewRec, hd_file

  *
  ** firmyucW
  inline access assign method is_aktivni() var is_aktivni
    return if( firmyucW->(eof()), 0, if( firmyucW->lAktivni, MIS_ICON_OK, MIS_NO_RUN ))

  inline access assign method setSkup() var setSkup
    return if(firmySKw->_setsku, MIS_ICON_OK, 0)

  inline access assign method cnaz_Skup() var cnaz_Skup
     c_firmySk->(dbSeek( upper(firmySKw->czkr_Skup)))
     return c_firmySk->cnaz_Skup
  *
  ** firmyVAw
  inline access assign method nazev_vaw() var nazev_vaw
    if firmy_vaw->ncisFirmy <> firmyVAw->ncisFirVa
      firmy_vaw->(dbseek( firmyVAw->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->cnazev

  inline access assign method ico_vaw() var ico_vaw
    if firmy_vaw->ncisFirmy <> firmyVAw->ncisFirVa
      firmy_vaw->(dbseek( firmyVAw->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->nico

  inline access assign method dic_vaw() var dic_vaw
    if firmy_vaw->ncisFirmy <> firmyVAw->ncisFirVa
      firmy_vaw->(dbseek( firmyVAw->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->cdic

  inline access assign method psc_vaw() var psc_vaw
    if firmy_vaw->ncisFirmy <> firmyVAw->ncisFirVa
      firmy_vaw->(dbseek( firmyVAw->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->cpsc

  inline access assign method sidlo_vaw() var sidlo_vaw
    if firmy_vaw->ncisFirmy <> firmyVAw->ncisFirVa
      firmy_vaw->(dbseek( firmyVAw->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->csidlo

  inline access assign method ulice_vaw() var ulice_vaw
    if firmy_vaw->ncisFirmy <> firmyVAw->ncisFirVa
      firmy_vaw->(dbseek( firmyVAw->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->culice


  inline method tabSelect(oTabPage,tabNum)
    local pt := ::pa_otp

    if .not. empty(otabPage:subs)
      aeval(pt, { |x| x[3]:oxbp:setColorFG(GRA_CLR_BLACK) })
    endif

    ::tabSet := .t.
    ::tabNum := otabPage:tabNumber
  return .t.

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl, cfile
    local  nin, drgVar

    do case
    case ::tabSet
      ::setFocus_onTab()
      return .t.

    case(nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_EDIT)
      do case
      case( ::tabNum = 2 )                       // firmyUCw
        if(nEvent = drgEVENT_APPEND .or. firmyucW->( eof()), ::firmyuc_new(), nil)
        ::df:setNextFocus('firmyUCw->cucet',,.t.)
        return .t.

      case( ::tabNum = 5 )                       // c_podrucw
        ::df:setNextFocus('c_podrucw->cuctz_puh',, .t.)
        return .t.
      endcase

    case(nEvent = drgEVENT_DELETE)
      cfile := lower(::dctrl:oaBrowse:cfile)

      if( cfile = 'firmyucw' .or. cfile = 'c_podrucw' .or. cfile = 'firmyvaw')
        ::postDelete()
      endif
      return .t.

    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      if( ::tabNum = 6, ::firmysk_set(), nil)
      return .t.

    case (nevent = drgEVENT_EXIT .or. nevent = drgEVENT_SAVE)
      do case
      case(::tabNum = 2 .and. oXbp:className() <> 'XbpBrowse')
        ::firmyuc_save()
        return .t.

      case(::tabNum = 5 .and. oXbp:className() <> 'XbpBrowse')
        ::setFocus_onTab()

      otherwise
        if ::postSave()
          PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
        endif

      endcase

    case nEvent = xbeP_Keyboard
      if( mp1 = xbeK_ALT_ENTER .and. ::tabNum = 6, ::firmysk_set(), nil)

      if mp1 == xbeK_ESC
        do case
        case(::tabNum = 2 .or. ::tabNum = 5) .and. oXbp:ClassName() <> 'XbpBrowse'
          ::restColor()
          ::setFocus_onTab()
          return .t.

        otherwise
          if( ::postEscape(), PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp), nil)

        endcase
        return .t.
      endif
      RETURN .F.

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.


HIDDEN:
  var     dm, df, dctrl, msg
  var     ofirmyUCw, ofirmyFIw, oc_podrucw, oskupiny_txt
  var     tabNum, tabSet, pao_brow, pa_ares, is_activeAres
  *
  var     oskupina_txt, pa_otp, cisFirVA, rec_in_doa
  method  save_firmyVA


  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  inline method setFocus_onTab()
    local  brow, nin, npos := 0
    *
    local  pao_brow := ::pao_brow, tabNum := ::tabNum, pt := ::pa_otp
    local  zkr_skup, cky

    nIn := ascan(pao_brow, {|x| x[3] = tabNum })

    do case
    case(::tabNum =  1)  ;  ::df:setNextFocus('firmyw->culice'      ,, .t.)
    case(::tabNum =  3)  ;  ::df:setNextFocus('firmyFIw->cuct_dod'  ,, .t.)
    case(::tabNum =  4)  ;  ::df:setNextFocus('firmyFIw->cuct_odb'  ,, .t.)
    case(::tabNum = 13)  ;  ::df:setNextFocus('firmyw->mpoznamka'   ,, .t.)
    otherwise
      if(npos := ascan(pt, {|x| x[2] = tabNum })) <> 0
         cky := strZero(firmyW->ncisFirmy,5) +upper(firmySKw->czkr_skup) +pt[npos,1]
         firmyVAw->(dbsetscope(SCOPE_BOTH, cky), dbgotop())

         nin := ascan(pao_brow, {|x| x[3] = 60 })
      endif
    endcase

    if nin <> 0
      ::df:olastdrg   := ::pao_brow[nIn,2]
      ::df:nlastdrgix := ::pao_brow[nIn,1]
      ::df:olastdrg:setFocus()

      ::dctrl:oaBrowse := ::pao_brow[nIn,2]
      brow := ::dctrl:oaBrowse:oXbp
      ::dm:refresh()

      if npos <> 0
        brow:refreshAll()
        brow:panHome()
      else
        PostAppEvent(xbeBRW_ItemMarked,,,brow)
        brow:refreshCurrent():hilite()
      endif
    endif

    ::tabSet := .f.
  return .t.

  inline method postDelete()
    local  cMess  := 'Požadujete zrušit ', cTitle, nsel
    local  o_dbro := ::dctrl:oaBrowse
    local  cfile  := lower(o_dbro:cfile)
    *
    local  zkr_skVA, ok := .t., modDel

    do case
    case(cfile = 'firmyucw' )
      ok     :=  .not. firmyucw->(eof())
      how    := 1
      cMess  += 'bankovní úèet_' +allTrim(firmyucw->cucet) +'_'
      cTitle := 'Zrušení bankovního úètu ...'

    case(cfile = 'c_podrucw')
      ok     := .not. empty(c_podrucw->cuctZ_PUH +c_podrucw->cuctZ_PUHS + ;
                            c_podrucw->cuctZ_PUZ +c_podrucw->cuctZ_PUZS + ;
                            c_podrucw->cuctP_PUH +c_podrucw->cuctP_PUHS + ;
                            c_podrucw->cuctP_PUZ +c_podrucw->cuctP_PUZS   )
      how    := 2
      cMess  += 'podrozvahové úèty pro_' +c_podrucw->czkratMeny +'_'
      cTitle := 'Zrušení podrozvahových úètù ...'

    otherwise
      ok       :=  .not. firmyvaw->(eof())
      how      := 1
      zkr_skVA := ::df:tabPageManager:active:subs
      cMess    += 'vazbu [ ' +firmyskw->czkr_skup +' -> ' +zkr_skVA +'] _'
      cTitle   := 'Zrušení vazby ...'

    endcase

    *
    **
    if ok
      nsel := ConfirmBox( ,cMess, cTitle,  XBPMB_YESNO                 , ;
                           XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                           XBPMB_DEFBUTTON2                              )

      if nsel = XBPMB_RET_YES
        if( how = 1, (cfile)->_delrec := '9', mh_blankRec('c_podrucw',2))

        o_dbro:oxbp:gotop():refreshAll()
        ::dm:refresh()
      endif
    endif
  return .t.


  inline method postEscape()
    local nsel

    nsel := confirmBox(,'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                        'Data nebudou uložena ...'                     , ;
                         XBPMB_YESNO                                   , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                         XBPMB_DEFBUTTON2                                )
    return (nsel = XBPMB_RET_YES)


  inline method firmyuc_new()
    local pa := ::ofirmyucw, x, odrg, typ, val

    for x := 1 to len(pa) step 1
      odrg := pa[x]
      typ  := valtype(odrg:ovar:value)
      val  := if(typ = 'L', .f., if(typ = 'D', ctod('  .  .  '), if(typ = 'N', 0, '')))

      odrg:ovar:initValue := odrg:ovar:prevValue := val
      odrg:ovar:set(val)
    next
    ::dm:set('firmyucw->lAktivni', .t.)
    ::dm:set('firmyucw->_newrec' ,   1)
  return self

  inline method firmyuc_save()
    local pa := ::ofirmyucw, x, odrg, typ, val

    if( ::dm:get('firmyucw->_newrec') = 1, firmyucw->(dbappend()), nil)
    aeval(pa, {|x| if(x:className() $ 'drgGet,drgCheckBox', eval(x:ovar:block,x:ovar:value), nil)})
    ::setFocus_onTab()
  return

  inline method firmysk_set()
    local  czkr_skup := firmySKw->czkr_skup
    local  cis_xxx   := 'nis_' +alltrim(czkr_skup)

    firmySKw->_setsku := .not. firmySKw->_setsku
    ::pao_brow[3,2]:refresh(.f.)

    if ( npos := firmyW->(fieldPos( cis_xxx ))) <> 0
      firmyW->( fieldPut( npos, if( firmySKw->_setsku, 1, 0)) )
    endif
  return

  inline method firmyDAw_modi()
    firmyda->(dbgoTo(::rec_in_doa))

    if firmyda->(dbrlock())
      firmyDA->cnazevDOA  := firmyw->cnazev
      firmyDA->cnazevDOA2 := firmyw->cnazev2
      firmyDA->ccinnost   := firmyw->ccinnost
      firmyDA->cpscDOA    := firmyw->cpsc
      firmyDA->csidloDOA  := firmyw->csidlo
      firmyDA->culiceDOA  := firmyw->culice
      firmyDA->ctelDOA    := firmyw->ctelefon
      firmyDA->cfaxDOA    := firmyw->cfax
      firmyDA->cmodDOA    := firmyw->cmodembbs
      firmyDA->czastDOA   := firmyw->czastobch

      firmyda->(dbcommit(), dbUnlock())
    endif
  return self

ENDCLASS


method FIR_firmy_CRD:init(parent)
  local   cKy := ' ', pa_ares
  *
  ::drgUsrClass:init(parent)

  * pokud to volám ze SEL dialogù
  drgDBMS:open('firmy')

  * karta firmy volaná pro opravu z ... vodevšad 2 parametr je recNo()
  if len(pa_initParam := listAsArray(parent:initParam)) = 2
    parent:cargo := drgEVENT_EDIT
    firmy->(dbgoTo( val( pa_initParam[2] )))
  endif

  ::lnewRec    := .t.
  ::hd_file    := 'firmyW'

  ::ofirmyUCw  := {}
  ::ofirmyFIw  := {}
  ::oc_podrucw := {}
  ::tabNum     := 1
  ::tabSet     := .f.
  ::pao_brow   := {}
  ::pa_otp     := {}
  ::rec_in_doa := 0

  IF parent:cargo = drgEVENT_EDIT
    cKy       := strZero(firmy->ncisFirmy,5)
    ::lnewRec := .f.
  ENDIF

  ** vyøešíme ares
  ::is_activeAres := SYS_ares_Test()

  drgDBMS:open('c_ares')
  ::pa_ares := pa_ares := {}
  *  3-odpovedAres, 4- odrGet, 5-oxbpStaic, 6-c_ares->mpoznamka
  c_ares->( dbEval( { || aadd( pa_ares, { allTrim(c_ares->ctag_Name), allTrim(c_ares->cfield), '' , , ,c_ares->mares_Miss } ) } ))
  ** pro ares

  ** vyøešíme podrozvahu
  drgDBMS:open('c_meny')
  drgDBMS:open('c_podruc')
  c_podruc->(AdsSetOrder(2))
  drgDBMS:open('c_podrucw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  c_podruc ->( DbSetScope(SCOPE_BOTH, cKy)                                  , ;
               dbgoTop()                                                    , ;
               DBEval( { || mh_COPYFLD('c_podruc', 'c_podrucw', .t., .t.) } ) )

  c_meny   ->( DBEval( { || IF( c_podrucw ->( dbSeek(upper(c_meny->czkratMeny))), ;
                                NIL, ;
                                mh_copyFld('c_meny', 'c_podrucw', .t., .f.)        ) }))

  drgDBMS:open('firmy',,,,,'firmy_vld')

  ** vyøešíme skupiny **
  drgDBMS:open('c_firmysk')
  drgDBMS:open('firmySK'  )
  drgDBMS:open('firmySKw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('firmy',,,,,'firmy_skv')

  drgDBMS:open('firmyVA')
  drgDBMS:open('firmyVAw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('firmy',,,,,'firmy_vaw')

  firmysk  ->(AdsSetOrder('FIRMYSK01'), dbsetScope(SCOPE_BOTH,val(cky)), dbgoTop())
  do while .not. firmysk->(eof())
    mh_COPYFLD('firmySK', 'firmySKw', .t., .t.)
    firmySKw->_setsku := .t.
    firmySK->(dbSkip())
  enddo

  c_firmysk->(AdsSetOrder('C_FIRMSK01'), dbgoTop(), ;
              DbEval( { || if(firmySKw->( dbSeek(upper(c_firmysk->czkr_Skup))), ;
                           nil                                                , ;
                           mh_copyFld('c_firmysk', 'firmySKw', .t., .f.)        ) }))

  firmyVA ->( AdsSetOrder('FIRMYVA02'), DbSetScope(SCOPE_BOTH, cKy)       , ;
              dbgoTop()                                                   , ;
              DBEval( { || mh_COPYFLD('firmyVA', 'firmyVAw', .t., .t.) } )  )

  * vazba
  firmyva ->(AdsSetOrder('FIRMYVA01'),dbclearScope())
  firmyvaw->(dbgotop())
  do while .not. firmyvaw->(eof())
    if firmyva->(dbseek(firmyvaw->ncisFirVa,,'FIRMYVA01'))
      firmyvaw->_nrecorva := firmyva->(recNo())
    endif
    firmyvaw->(dbskip())
  enddo

  ** TMP soubory
  drgDBMS:open('firmyw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('firmyFIw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('firmyUCw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('firmyDAw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  if ::lnewRec
    firmyw  ->(dbAppend())
    firmyFIw->(dbAppend())
    firmyDAw->(dbAppend())

      firmy_vld->( ordSetFocus('FIRMY1'), DbGoBottom())
      firmyw ->ncisFirmy := firmy_vld->ncisFirmy +1
  else
    mh_copyFld('firmy'  , 'firmyw'  , .t., .t.)

    firmyuc->( DbEval({ || mh_copyFld('firmyuc', 'firmyUCw', .t., .t.) }))
    mh_copyFld('firmyfi', 'firmyFIw', .t., .t.)

    fordRec( {'firmyda,1'} )
    firmyda->(dbsetScope(SCOPE_BOTH, firmy->ncisFirmy)                   , ;
              dbgotop()                                                  , ;
              dbeval( { || mh_copyFld('firmyda', 'firmydaW', .t., .t.) }), ;
              dbclearscope()                                               )
    fordRec()

    * firma mùže být sama DOA
    if firmyda->(dbseek(firmy->ncisFirmy,,'FIRMYDA3'))
      ::rec_in_doa := firmyda->(recNo())
    endif
  endif
  c_podrucw ->(dbSetRelation('c_meny', _EarlyBoundCodeblock({|| upper(c_podrucw ->czkratMeny)}), "upper(c_podrucw ->czkratMeny)",,, .F.))
return self


method FIR_firmy_CRD:drgDialogStart(drgDialog)
  local  members, x, odrg, name
  *
  local  apos, asize, obord, oinfo

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::df       := drgDialog:oForm                   // form
  ::dctrl    := drgDialog:dialogCtrl              // dialogCtrl
  *
  ::cisFirVA := ::dm:get('firmyVAw->ncisfirva' , .F.)

  odrg       := ::dm:get('firmyW->ncisFirmy'   , .f.)
  odrg:odrg:isEdit := ::lnewRec

  members    := ::df:tabPageManager:members

  * propojka pro ARES
  ::sys_ARES_forAll:init(drgDialog)

  for x := 1 to len(members) step 1
    if .not. empty(members[x]:subs)
      aadd(::pa_otp, { members[x]:subs, members[x]:tabNumber, members[x] })
    endif
  next

  members := ::df:amembers

  for x := 1 TO LEN(members) step 1
    odrg := members[x]
    if ismembervar(odrg,'name')
      name := lower(isnull(odrg:name,''))
      do case
      case('firmyucw'  $ name)  ;  AAdd(::ofirmyUCw ,odrg)
      case('firmyfiw'  $ name)  ;  AAdd(::ofirmyFIw ,odrg)
      case('c_podrucw' $ name)  ;  AAdd(::oc_podrucw,odrg)
      endcase
    endif

    if ismembervar(odrg,'groups')
     if( odrg:groups = 'TEXT-6' , ::oskupina_txt := odrg, nil)
    endif

    if lower(members[x]:ClassName()) $ 'drgdbrowse,drgebrowse'
      AAdd(::pao_brow, {x,members[x],val(members[x]:groups)})
    endif
  next

return


method FIR_firmy_crd:postValidate(drgVar, lis_formValidate)
  local  name     := lower(drgVar:name)
  local  file     := drgParse(name,'-')
  local  value    := drgVar:get()
  local  changed  := drgVAR:Changed(), ok := .t., ncnt_IDc := 0, ok_IDc := .t.
  *
  local  nevent := mp1 := mp2 := nil

  default lis_formValidate to .f.

  if( lis_formValidate, changed := .t., nil )

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  if(isNumber(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  * nìkdo zadává stejné èíslo firmy
  * nìkdo chtìl upozornit na duplicitní IÈo a DIèo
  do case
  case( name = 'firmyw->nico'        .and. changed )
    if .not. empty(value)
      if( ::lnewRec, ok := ::firmy_takeAres(), nil )

      fordRec( {'firmy_vld,6'} )

      firmy_vld->( dbSetScope( SCOPE_BOTH, value ), ;
                   dbgotop()                      , ;
                   dbeval({|| ncnt_IDc++ })       , ;
                   dbclearscope()                   )

      fordRec()

      ok_IDc := if( ::lnewRec, (ncnt_IDc = 0), ;
                 if(value = firmy->nico, .t., (ncnt_IDc = 0) ) )

      if( ok_IDc, nil, fin_info_box('Duplicitní IÈO v seznamu firem...' ) )

      firmyw->cico := strZero(value,8)
    endif

  case( name = 'firmyw->cdic'        .and. changed )
    if .not. empty(value)
      fordRec( {'firmy_vld,8'} )

      firmy->( dbSetScope( SCOPE_BOTH, upper(value) ), ;
               dbgotop()                             , ;
               dbeval({|| ncnt_IDc++ })              , ;
               dbclearscope()                          )

      fordRec()

      ok_IDc := if( ::lnewRec, (ncnt_IDc = 0), ;
                  if(value = firmy->cdic, .t., (ncnt_IDc = 0) ) )

      if( ok_IDc, nil, fin_info_box('Duplicitní DIÈ v seznamu firem...' ) )
    endif

    case( name = 'firmyw->ncisfirmy' )
      if empty(value) .or. firmy_vld->(dbseek( value,,'FIRMY1'))
        ok := .f.
        fin_info_box('Prázdné, nebo duplicitní èíslo FIRMY nelze povolit ...' )
      endif
  endcase

  if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
    do case
    case( name = 'firmyvaw->ncisfirva' .and. changed )
      ok := ::fir_firmy_sel()

    case( name = 'firmyucw->cucet_uct' .or. name = 'c_podrucw->cuctp_puzs')
       _clearEventLoop(.t.)
       if(::tabNum = 2, ::firmyuc_save(), ::setFocus_onTab())
    endcase
  endif

  * ukládáme na každém prvku s vyjímkou souboru firmyUCw
  if file = 'firmyw' .or. file = 'firmyfiw' .or. file = 'firmydaw' .or. file = 'c_podrucw'
    eval(drgVar:block,drgVar:value)
    drgVar:initValue := drgVar:value

    if( name = 'firmyfiw->czkrprodej', firmyw->czkrprodej := drgVar:value, nil )
  endif

return ok


method fir_firmy_crd:itemMarked(a,b,obro)
  local  pt       := ::pa_otp, npos := 0, x
  local  zkr_skup := upper(firmySKw->czkr_skup)
  *
  local  cky, nin, pao_brow := ::pao_brow

  ::oskupina_txt:oxbp:setCaption(::cnaz_Skup +' -> ')

  aeval(pt, { |x| ( x[3]:oxbp:enable()                 , ;
                    x[3]:oxbp:minimize()               , ;
                    x[3]:oxbp:setColorFG(GRA_CLR_BLACK), ;
                    x[3]:oxbp:invalidateRect()           ) })

  begin sequence
    for x := 1 to len(pt) step 1
      if (npos := ascan( pt, {|x| x[1] = zkr_skup} )) <> 0
        pt[npos,3]:oxbp:disable()
  break
      endif
    next
  endsequence
  *
  npos := if( npos = 0, 1, if(npos = 1, 2, 1))
  pt[npos,3]:oxbp:maximize()
  pt[npos,3]:oxbp:setColorFG(GRA_CLR_BLUE)
  pt[npos,3]:oxbp:invalidateRect()
  *
  ::df:tabPageManager:active         := pt[npos,3]
  ::df:tabPageManager:active:is_show := .t.
  *
  cky := strZero(firmyW->ncisFirmy,5) +zkr_skup +pt[npos,1]
  firmyVAw->(dbsetscope(SCOPE_BOTH, cky), dbgotop())
  *
  if( ::setSkup = 0, ::oskupina_txt:oxbp:disable(), ::oskupina_txt:oxbp:enable())
return .t.


method fir_firmy_crd:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok := .t., copy := .f.
  local  zkr_skup := upper(firmySKw->czkr_skup)
  local  zkr_skVA := ::df:tabPageManager:active:subs
  *
  local  cky := strZero(firmyW->ncisFirmy,5) +zkr_skup +zkr_skVA

  fordRec({'firmy,1','firmyVAw,3'})

  ok := firmy->(dbseek(::cisFirVA:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if ok
    if firmyVAw->(dbseek(cky+strZero(firmy->ncisfirmy,5),,'FIRMYVA04'))
      ** duplicitní vazba
      ::msg:writeMessage('Nelze zadat duplicitní vazbu v seznamu ...',DRG_MSG_ERROR)
      sleep(20)
      ::msg:writeMessage(,0)

      ok := .f.
    endif
  endif

  if((ok .and. ::cisFirVA:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirVA:set(firmy->ncisfirmy)
*---    PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
  endif

  fordRec()
return (nexit != drgEVENT_QUIT) .or. ok


method fir_firmy_crd:ebro_beforeAppend(o_ebro)
  local  zkr_skVA := ::df:tabPageManager:active:subs
  local  ok := .t.

  if zkr_skVA = 'FAA' .or. zkr_skVA = 'KOA'
    ok := (firmyVAw->ncisFirmy = 0)
  endif
return ok


method fir_firmy_crd:ebro_saveEditRow(o_ebro)
  local zkr_skVA := ::df:tabPageManager:active:subs

  firmyVAw->ncisFirmy := firmyw->ncisFirmy
  firmyVAw->czkr_sk   := firmySKw->czkr_skup
  firmyVAw->czkr_skVA := zkr_skVA

  * založíme si DOA ??
  if o_ebro:state = 2 .and. zkr_skVA = 'DOA'
    firmyDAw ->(dbappend())
    firmy_vaw->(dbseek(firmyVAw->ncisFirVa,, AdsCtag(1) ))

    firmyDAw->ncisFirmy  := firmyw   ->ncisFirmy
    firmyDAw->ncisFirDOA := firmyVAw ->ncisFirVA
    firmyDAw->cnazevDOA  := firmy_vaw->cnazev
    firmyDAw->cnazevDOA2 := firmy_vaw->cnazev2
    firmyDAw->ccinnost   := firmy_vaw->ccinnost
    firmyDAw->cpscDOA    := firmy_vaw->cpsc
    firmyDAw->csidloDOA  := firmy_vaw->csidlo
    firmyDAw->culiceDOA  := firmy_vaw->culice
    firmyDAw->ctelDOA    := firmy_vaw->ctelefon
    firmyDAw->cfaxDOA    := firmy_vaw->cfax
    firmyDAw->cmodDOA    := firmy_vaw->cmodembbs
    firmyDAw->czastDOA   := firmy_vaw->czastobch
  endif
return


/*
 zámky  firmy    1
        firmyuc  n
        firmyfi  1  -  pokud nìco obsahuje - neukládat pokud je prázdný resp. zrušit
        firmyda  1  -  pokud nìco obsahuje - neukládat pokud je prázdný resp. zrušit
        firmysk  n  -  pokud nìco obsahuje - neukládat pokud je prázdný resp. zrušit
        firmyva  n  -  pokud nìco obsahuje - neukládat pokud je prázdný resp. zrušit
                    -  obrácená vazba
        c_podruc n
*/
method FIR_firmy_crd:postSave()
  local  ok  := .t., x, y, cfile_M, cfile_W, isEmpty, val, nIn
  local  paF := { { 'firmy'    , {}, nil                 }, ;
                  { 'firmyfi'  , {}, nil                 }, ;
                  { 'firmyuc'  , {}, ::ofirmyUCw         }, ;
                  { 'firmyda'  , {}, nil                 }, ;
                  { 'c_podruc' , {}, ::oc_podrucw        }, ;
                  { 'firmysk'  , {}, 'firmySKw->_setsku' }, ;
                  { 'firmyva'  , {}, nil                 }  }
  local  nrecor
  local  lAktivni

  *
  ** potøebujeme otestovat duplicity - ncisFirmy, nico, cdic
  if .not. ::postValidateForm()
    return .f.
  endif


  firmyucw->(AdsSetOrder(0))
  firmyvaw->(dbClearScope(), AdsSetOrder(0))

  * pøi opravì firmy pokud je DOA - musíme zmodifikovat
  if( .not. ::lnewRec .and. ::rec_in_doa <> 0, ::firmyDAw_modi(), nil)


  * zámky
  for x := 1 to len(paF) step 1
    cfile_M := paF[x,1]
    cfile_W := cfile_M +'w'
    paLock  := paF[x,2]
    paObj   := paF[x,3]

    (cfile_W)->(dbgoTop())

    do while .not. (cfile_W)->(eof())
      if((cfile_W)->_nrecor <> 0, AAdd(paLock, (cfile_W)->_nrecor), nil)

      if cfile_M = 'firmyva'
        if((cfile_W)->_nrecorva <> 0, AAdd(paLock, (cfile_W)->_nrecorva), nil)
      endif

      if isArray(paObj) .or. isCharacter(paObj)
        isEmpty := .t.
        if isArray(paObj)
          AEval(paObj,{|x| isEmpty := (isEmpty .and. empty( eval(x:ovar:block))) })
        else
          isEmpty := (isEmpty .and. .not. DBGetVal(paObj))
        endif

        if( isEmpty, (cfile_W)->_delrec := '9', nil)
      endif
      (cfile_W)->(dbSkip())
    enddo

    ok := (ok .and. (cfile_M)->(sx_RLock(paLock)))
  next

  * ukládáme
  if ok
    for x := 1 to len(paF) step 1
      cfile_M := paF[x,1]
      cfile_W := cfile_M +'w'
      paLock  := paF[x,2]

      (cfile_W)->(dbgoTop())

      do while .not. (cfile_W)->(eof())
        if (cfile_W)->_delrec <> '9'

          if((nrecor := (cfile_W)->_nrecor) = 0, nil, (cfile_M)->(dbgoto(nrecor)))
          if   (cfile_W)->_delrec = '9'  ;  (cfile_M)->(dbdelete())
          else
            if cfile_M = 'firmyva'
              ::save_firmyVA(paLock)
            else
              lAktivni := if( cfile_M = 'firmyuc', (cfile_W)->lAktivni, .f.)

              mh_copyFld(cfile_W,cfile_M,((cfile_W)->_nrecor = 0))
              if( x <> 1, mh_copyFld('firmy', cfile_M), nil)

              if( cfile_M = 'firmyuc', (cfile_M)->lAktivni := lAktivni, nil )
            endif

            if(nIn := AScan(paLock, nrecor)) <> 0
              (adel(paLock,nIn), asize(paLock, len(paLock) -1))
            endif
          endif
        endif


        (cfile_W)->(dbSkip())
      enddo

      AEval(paLock, {|recs| (cfile_M)->(dbgoTo(recs), dbDelete()) })
    next
  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat FIRMY, blokováno uživatelem !!!'))
  endif

  AEval( paF, { |x| (x[1])->(dbUnlock(),dbCommit()) })
return ok


method fir_firmy_crd:postValidateForm()
  local  x, drgVar
  *
  local  nstart := if( ::lnewRec, 1, 2 )
  local  pa     := { { ::dm:get('firmyw->ncisFirmy' , .F.), 'firmyw->ncisFirmy' }  }
*                     { ::dm:get('firmyw->nico'      , .F.), 'firmyw->nico'      }, ;
*                     { ::dm:get('firmyw->cdic'      , .F.), 'firmyw->cdic'      }  }

  begin sequence
    for x := nstart to len(pa) step 1
      drgVar := pa[x,1]

      if .not. ::postValidate(drgVar, .t.)
        ::df:setNextFocus( pa[x,2],, .t.)
        return .f.
  break
      endif
    next
  end sequence
return .t.


method fir_firmy_crd:save_firmyVA(paLock)
  local  dbApp  := (firmyVAw->_nrecor = 0)
  local  nrecor := firmyvaw->_nrecorva
  local  cisFirmy, zkr_sk, cisFirVA, zkr_skVA
  local  cis_xxx, npos

  mh_copyFld('firmyvaw', 'firmyva', dbApp)

  cisFirmy := firmyVAw->ncisFirVA
  zkr_sk   := firmyVAw->czkr_skVA
  cisFirVA := firmyVAw->ncisFirmy
  zkr_skVA := firmyVAw->czkr_sk

  if( dbApp, firmyva->(dbappend()), firmyva->(dbgoTo(firmyvaw->_nrecorva)) )

  firmyva->ncisFirmy := cisFirmy
  firmyva->czkr_sk   := zkr_sk
  firmyva->ncisFirVA := cisFirVA
  firmyva->czkr_skVa := zkr_skVA

  if(nin := AScan(paLock, nrecor)) <> 0
    (adel(paLock,nIn), asize(paLock, len(paLock) -1))
  endif

  if .not. firmysk->(dbseek( strZero(firmyva->ncisFirmy,5) +upper(firmyva->czkr_sk),,'FIRMYSK02'))
    firmysk->(dbappend())

    firmysk->ncisFirmy := firmyva->ncisFirmy
    firmysk->czkr_skup := firmyva->czkr_sk
    firmysk->(dbcommit())
  endif
  *
  **
  if firmy_vaw->( dbseek( cisFirmy,,'FIRMY1'))
    if firmy_vaw->( sx_Rlock())
      cis_xxx   := 'nis_' +alltrim(zkr_sk)

      if ( npos := firmy_vaw->(fieldPos( cis_xxx ))) <> 0
        firmy_vaw->( fieldPut( npos, 1) )
        firmy_vaw->( dbunlock(), dbcommit() )
      endif
    endif
  endif
return


method FIR_firmy_crd:drgDialogEnd()
  ::drgUsrClass:destroy()

  ::lnewRec    := ;
  ::dm         := ;
  ::df         := ;
  ::dctrl      := ;
  ::ofirmyUCw  := ;
  ::ofirmyFIw  := ;
  ::oc_podrucw := ;
  ::tabNum     := ;
  ::tabSet     := ;
  ::pao_brow   := NIL

  c_podrucw ->(DbClearRelation())

  firmyw   ->(DbCloseArea())
  firmyFIw ->(DbCloseArea())
  firmyUCw ->(DbCloseArea())
  firmyDAw ->(DbCloseArea())
  firmySKw ->(DbCloseArea())
  firmyVAw ->(DbCloseArea())
return self