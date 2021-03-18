#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
*
#include "..\Asystem++\Asystem++.ch"

#define _EVDW_roz_pl_j { {  '1', 'gram'    }, { '1a', 'gram'     }, ;
                         {  '3', ''        }, { '3a', ''         }, ;
                         {  '4', ''        }, { '4a', ''         }, ;
                         {  '5', 'kilogram'}, { '6' , ''         }, ;
                         {  '7', ''        }, { '11', 'kusy'     }, ;
                         { '12', 'tuna'    }, { '13', 'kilogram' }, ;
                         { '14', 'kusy'    }, { '15', 'kusy'     }, ;
                         { '16', 'kusy'    }, { '17', 'kusy'     }, ;
                         { '18', ''        }, { '19', ''         }, ;
                         { '20', ''        }, { '21', ''         }  }


*
*************** FIN_vykdph_evdw ***********************************************
CLASS FIN_vykdph_evdw FROM drgUsrClass
exported:
  var     task
  method  init, itemMarked, drgDialogStart, drgDialogEnd
  method  comboBoxInit, comboItemSelected
  method  zpracuj_podklady
  method  modify_dphevdw

  * bro col for ucetsys
  ** 1
  inline access assign method setfor_sw     var setfor_sw

    if AScan( ::pa_obdZpr, ucetsys->cobdobi ) <> 0
      return 6001
    endif
    return 0

  ** 2
  inline access assign method aktobd_sw()   var aktobd_sw
    return ( if( ucetsys ->laktObd, 300, 0))
  ** 3
  inline access assign method zavrenD_sw()  var zavrenD_sw
    return( if( ucetsys ->lzavrenD, 300, 0))
  ** 4
  inline access assign method obdDan_sw     var obdDan_sw
    return ucetsys->cobdobiDan
  ** 5
  inline access assign method obdUc_sw      var obdUc_sw
    return str( ucetsys->nObdobi, 2) + '/' +str( ucetsys->nRok, 4)
  ** 6
  inline access assign method obdOtevrel_sw var obdOtevrel_sw
    return dtoc( ucetsys->dotvDat) +'     ' +ucetsys->cotvKdo
  ** 7
  inline access assign method obdUctoval_sw var obdUctoval_sw
    return dtoc( ucetsys->ductDat) +'     ' +ucetsys->cuctKdo
  ** 8
  inline access assign method obdZavrel_sw  var obdZavrel_sw
    return dtoc( ucetsys->duzvDat) +'     ' +ucetsys->cuzvKdo

  **
  inline method post_bro_colourCode()
    return ::set_obdZpr()

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      return .f.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE .or. ;
           nEvent = drgEVENT_SAVE        )
      return .t.

    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, ab, oabro, xbp_therm, cparm
* datové
  var     culoha, nrok, nobdobi, pa_obdZpr, radek

  method  set_obdZpr

   * filtr
  inline method setFilter()
    local m_filter := "culoha = '%%' .and. nrok = %% .and. lzavrenD", filter, x

    if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)

    filter := format(m_filter,{::culoha,::nrok})
    ucetsys ->(ads_setaof(filter),dbgotop())
/*
    for x := 2 to ::nobdobi step 1
      if .not. (ucetsys->nobdobi = ::nobdobi)
        ::oabro[1]:oxbp:down()
      endif
    next
*/
    ::oabro[1]:oxbp:forceStable()
    ::oabro[1]:oxbp:refreshAll()
    ::dm:refresh()

    PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
    SetAppFocus(::oabro[1]:oXbp)
    return self

  * je aktivni BROw ?
  inline method inBrow()
    return (SetAppFocus():className() = 'XbpBrowse')

ENDCLASS


method FIN_vykdph_evdw:init(parent)
  local  task := 'fin'

  ::drgUsrClass:init(parent)
  ::cParm    := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm    := Left( ::cParm,1)
  ::radek    := 0

  drgDBMS:open('c_task' )
  drgDBMS:open('ucetsys')
  drgDBMS:open('ucetsys',,,,,'ucetsys_w')
  *
  drgDBMS:open('firmy'   )
  drgDBMS:open('c_staty' )
  drgDBMS:open('fakvyshd')
  drgDBMS:open('fakvysit')

  drgDBMS:open('fakprihd')
  drgDBMS:open('fakpriit')
  drgDBMS:open('pvpitem' )

  drgDBMS:open('cenzboz' )

  * holt jedeme znovu
  if select('dphewdw') <> 0
    vykdph_sw->(dbclosearea())
    FErase( drgINI:dir_USERfitm +'dphevdw.adt')
    FErase( drgINI:dir_USERfitm +'dphevdw.adi')
  endif

  drgDBMS:open('dphevdw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  ::task      := task
  ::nobdobi   := 0
  ::pa_obdZpr := {}

  if isobject(uctOBDOBI:&task)
    ::culoha  := uctOBDOBI:&task:culoha
    ::nrok    := uctOBDOBI:&task:nrok
    ::nobdobi := uctOBDOBI:&task:nobdobi
  endif

  c_task->(dbseek(upper(task),,'C_TASK01'))
  if(empty(::culoha), ::culoha := c_task->culoha, nil)
  if(empty(::nrok)  , ::nrok   := Year(date())  , nil)
return self


method FIN_vykdph_evdw:drgDialogStart(drgDialog)

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  ::ab         := drgDialog:oActionBar:members      // actionBar
  ::oabro      := drgDialog:dialogCtrl:obrowse
  *
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  ::setFilter()
return self


method FIN_vykdph_evdw:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

  ucetsys->(ads_clearaof())
return self


method FIN_vykdph_evdw:comboBoxInit(drgComboBox)
  local  acombo_val := {}

  if ('NROK'   $ drgComboBox:name)
    drgComboBox:value := ::nrok
    ucetsys_w ->(ads_clearaof()  , ;
                 dbgotop()       , ;
                 dbeval( { ||      ;
                 if( ascan(acombo_val,{|X| x[1] == ucetsys_w->nrok}) = 0 , ;
                     aadd(acombo_val,{ucetsys_w->nrok,'ROK _ ' +strzero(ucetsys_w->nrok,4)}), nil ) }))
    if empty(acombo_val)
      aadd(acombo_val, {::nrok-1, 'ROK _ ' +strzero(::nrok-1,4)})
      aadd(acombo_val, {::nrok  , 'ROK _ ' +strzero(::nrok  ,4)})
    endif

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endif
return self


method FIN_vykdph_evdw:comboItemSelected(mp1, mp2, o)
  ::pa_obdZpr := {}
  ::nrok      := mp1:value
  ::setFilter()
return .t.


method FIN_vykdph_evdw:itemMarked(arowco,unil,oxbp)
  local  ky, rest := ''
  *
  local  x, ev, om, ok := ( len( ::pa_obdZpr) <> 0 )

  BEGIN SEQUENCE
    for x := 1 to len(::ab) step 1
      ev := Lower(::ab[x]:event)
      om := ::ab[x]:parent:aMenu

      if ev $ 'zpracuj_podklady'
        ::ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
        ::ab[x]:oXbp:configure()
        if(ok, ::ab[x]:enable(), ::ab[x]:disable())

  BREAK
      endif
    next
  END SEQUENCE
return self


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method FIN_vykdph_evdw:set_obdZpr()
  local npos, pa := ::pa_obdZpr

  if( npos := AScan( pa, ucetsys->cobdobi )) = 0
    AAdd( pa, ucetsys->cobdobi )
  else
    ARemove( pa, npos )
  endif

  ::oabro[1]:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
return .t.


method fin_vykdph_evdw:zpracuj_podklady()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  cf  := ".not. empty(cdic) .and. ", cfilter
  local  cf_pvp, cfilter_pvp
  *
  local  cky, ncisRadku := 1, ncisListu := 1
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2]
  local  celkem    := 0
  local  mnozstvi  := 0
  *
  local  typPREdan, kod_pred_p, roz_pl_j


  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení', nSize, nHight)

  if sysconfig('FINANCE:nTypVykDPH') = 1                             // mìsíèní    plátci
    cc := replicate( "cobdobiDan = '%%' .or. ", len( pa) )
  else                                                               // ètvrtletní plátci
    cc := replicate( "cobdobi = '%%' .or. ", len( pa) )
  endif

  cf      += "(" +substr( cc, 1, len(cc) -6) +")"
  cfilter := format( cf, pa )


  do case
  case ::cparm = 'D'
    *
    ** FAKVYSHD - faktury vystavené
    fakvyshd->( Ads_setAOF(cfilter), dbgoTop() )
    fakvysit->( AdsSetOrder( 'FVYSIT13') )

    do while .not. fakvyshd->(eof())
      fakvysit->( DbSetScope(SCOPE_BOTH, fakvyshd->ncisFak), dbgoTop())
      pa_napocet := {}

      do while .not. fakvysit->(eof())
        if fakvysit->ntyppredan <> 0

          mnozstvi  := fakvysit->nfaktMnoz
          typPREdan := allTrim(fakvysit->ctypPREdan)

          do case
          case typPREdan = '1'  ;  kod_pred_p := '1'
                                   roz_pl_j   := 'gram'
          case typPREdan = '2'  ;  kod_pred_p := '2'
                                   roz_pl_j   := 'kusy'
          case typPREdan = '4'  ;  kod_pred_p := '4'
                                   roz_pl_j   := ''
          case typPREdan = '5'  ;  kod_pred_p := '5'
                                   roz_pl_j   := 'kilogram'
          case typPREdan = '11' ;  kod_pred_p := '11'
                                   roz_pl_j   := 'kusy'
          case typPREdan = '12' ;  kod_pred_p := '12'
                                   roz_pl_j   := 'tuna'
            if Upper(fakvysit->cZkratJedn) <> 'T'
              do case
              case Upper(fakvysit->cZkratJedn) = 'Q'
                mnozstvi := Round( mnozstvi / 10, 2)
              case Upper(fakvysit->cZkratJedn) = 'KG'
                mnozstvi := Round( mnozstvi / 1000, 2)
              endcase
            endif

            if Empty(fakvysit->csklpol)
               mnozstvi := 0
            endif

          case typPREdan = '13' ;  kod_pred_p := '13'
                                   roz_pl_j   := 'kilogram'
          case typPREdan = '14' ;  kod_pred_p := '14'
                                   roz_pl_j   := 'kusy'
          case typPREdan = '15' ;  kod_pred_p := '15'
                                   roz_pl_j   := 'kusy'
          case typPREdan = '16' ;  kod_pred_p := '16'
                                   roz_pl_j   := 'kusy'
          case typPREdan = '17' ;  kod_pred_p := '17'
                                   roz_pl_j   := 'kusy'
          endcase

          if( npos := AScan( pa_napocet, {|p| p[1] = kod_pred_p} )) = 0
            aadd( pa_napocet, { kod_pred_p, roz_pl_j, mnozstvi, fakvysit->ncenZakCel } )
          else
            pa_napocet[npos,3] += mnozstvi
            pa_napocet[npos,4] += fakvysit->ncenZakCel
          endif



/*
        if cenzboz->( dbseek( upper(fakvysit->ccisSklad) +upper(fakvysit->csklPol),, 'CENIK03'))
          if cenzboz->npreDanPov <> 0

            do case
            case cenzboz->npreDanPov = 1  ;  kod_pred_p := '1'
                                             roz_pl_j   := 'gram'
            case cenzboz->npreDanPov = 2  ;  kod_pred_p := '2'
                                             roz_pl_j   := 'kusy'
            otherwise                     ;  kod_pred_p := cenzboz->cdanPzbo
                                             roz_pl_j   := 'kilogram'
            endcase

            if( npos := AScan( pa_napocet, {|p| p[1] = kod_pred_p} )) = 0
              aadd( pa_napocet, { kod_pred_p, roz_pl_j, fakvysit->nfaktMnoz, fakvysit->nceCPrKBZ } )
            else
              pa_napocet[npos,3] += fakvysit->nfaktMnoz
              pa_napocet[npos,4] += fakvysit->nceCPrKBZ
            endif
          endif
        endif
*/
        endif
        fakvysit->(dbskip())
      enddo

      * pokud nìco naèetl holt to musíme uložit
      ::modify_dphevdw(pa_napocet, 'fakvyshd')

      fakvyshd->(dbskip())
    enddo

  case ::cparm = 'O'
    *
    ** FAKPRIHD - faktury pøijate
    fakprihd->( Ads_setAOF(cfilter), dbgoTop() )
    fakpriit->( AdsSetOrder( 'FAKPRIIT02') )

    do while .not. fakprihd->(eof())
      fakpriit->( DbSetScope(SCOPE_BOTH, fakprihd->ndoklad), dbgoTop())
      pa_napocet := {}

      do while .not. fakpriit->(eof())
        if .not. empty(fakpriit->ctypPREdan)
           typPREdan := allTrim(fakpriit->ctypPREdan)

          do case
          case typpredan = '1'  ;  kod_pred_p := '1'
                                   roz_pl_j   := 'gram'
          case typpredan = '2'  ;  kod_pred_p := '2'
                                   roz_pl_j   := 'kusy'
          case typpredan = '4'  ;  kod_pred_p := '4'
                                   roz_pl_j   := ''
          case typpredan = '5'  ;  kod_pred_p := '5'
                                   roz_pl_j   := 'kilogram'
          case typpredan = '11' ;  kod_pred_p := '11'
                                   roz_pl_j   := 'kusy'
          case typpredan = '12' ;  kod_pred_p := '12'
                                   roz_pl_j   := 'tuna'
          case typpredan = '13' ;  kod_pred_p := '13'
                                   roz_pl_j   := 'kilogram'
          case typpredan = '14' ;  kod_pred_p := '14'
                                   roz_pl_j   := 'kusy'
          case typpredan = '15' ;  kod_pred_p := '15'
                                   roz_pl_j   := 'kusy'
          case typpredan = '16' ;  kod_pred_p := '16'
                                   roz_pl_j   := 'kusy'
          case typpredan = '17' ;  kod_pred_p := '17'
                                   roz_pl_j   := 'kusy'
          endcase

          if( npos := AScan( pa_napocet, {|p| p[1] = kod_pred_p} )) = 0
            aadd( pa_napocet, { kod_pred_p, roz_pl_j, fakpriit->nfaktMnoz, fakpriit->ncenZakCel } )
          else
            pa_napocet[npos,3] += fakpriit->nfaktMnoz
            pa_napocet[npos,4] += fakpriit->ncenZakCel
          endif
        endif
        fakpriit->(dbskip())
      enddo

/*
    do while .not. fakprihd->(eof())
      cf_pvp      := "ncisFak = %% .and. ntypPoh = 1"
      cfilter_pvp := format(cf_pvp, { fakprihd->ncisFak } )

      pvpitem->(ads_setAof(cfilter_pvp), dbgotop() )
      pa_napocet := {}

      do while .not. pvpitem->(eof())
        if cenzboz->( dbseek( upper(pvpitem->ccisSklad) +upper(pvpitem->csklPol),, 'CENIK03'))
          if cenzboz->npreDanPov <> 0

            do case
            case cenzboz->npreDanPov = 1  ;  kod_pred_p := '1'
                                             roz_pl_j   := 'gram'
            case cenzboz->npreDanPov = 2  ;  kod_pred_p := '2'
                                             roz_pl_j   := 'kusy'
            otherwise                     ;  kod_pred_p := cenzboz->cdanPzbo
                                             roz_pl_j   := 'kilogram'
            endcase

            if( npos := AScan( pa_napocet, {|p| p[1] = kod_pred_p} )) = 0
              aadd( pa_napocet, { kod_pred_p, roz_pl_j, pvpitem->nmnozPrDod, pvpitem->ncenaCelk } )
            else
              pa_napocet[npos,3] += pvpitem->nmnozPrDod
              pa_napocet[npos,4] += pvpitem->ncenaCelk
            endif
          endif
        endif
        pvpitem->(dbskip())
      enddo
*/

      * pokud nìco naèetl holt to musíme uložit
      ::modify_dphevdw(pa_napocet, 'fakprihd')

      fakprihd->(dbskip())
    enddo
  endcase

  dphevdw->(dbgotop())
  celkem := 0
  do while .not. dphevdw->(eof())
    celkem += dphevdw->zakl_dane
    dphevdw->( dbskip())
  enddo
  dphevdw->(dbgotop())
  dphevdw->zakl_celk := celkem


  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení - dokonèeno', nSize, nHight)
  Sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.


method fin_vykdph_evdw:modify_dphevdw(pa_napocet, in_file)
  local  x, cky
  *
  local  typ_vypisu

  for x := 1 to len( pa_napocet ) step 1
    if in_file = 'fakvyshd'
      typ_vypisu := 'D'
      d_uskup_pl := fakvyshd->dpovinFak
    else
      typ_vypisu := 'O'
      d_uskup_pl := fakprihd->dvystFak
    endif

    cky := upper(typ_vypisu) +dtos(d_uskup_pl) +upper((in_file)->cdic) +upper( pa_napocet[x,1]) +strzero((in_file)->ndoklad,10)

    if dphevdw->( dbseek( cky))

      dphevdw->roz_pl       += pa_napocet[x,3]
      dphevdw->zakl_dane    += pa_napocet[x,4]
    else
      ::radek++
      dphevdw->(dbappend())

      * z fakvyshd / fakprihd
      dphevdw->typ_vypisu := typ_vypisu
      dphevdw->cobdobiDan := (in_file)->cobdobiDan
      dphevdw->nrokDan    := 2000+Val(Right((in_file)->cobdobiDan,2))
      dphevdw->nobdobiDan := Val(Left((in_file)->cobdobiDan,2))
      dphevdw->ncisFirmy  := (in_file)->ncisFirmy
      dphevdw->cdic       := (in_file)->cdic
      dphevdw->czkratStat := (in_file)->czkratStat
      dphevdw->d_uskut_pl := d_uskup_pl
      dphevdw->dic_dod    := (in_file)->cdic
      dphevdw->ndoklad    := (in_file)->ndoklad
      dphevdw->c_radku    := ::radek
      * z c_staty
      c_staty->( dbseek( upper((in_file)->cZkratStat),,'C_STATY1' ) )
      dphevdw->cZkratSta2  := c_staty->cZkratSta2

      * z firmy
      firmy->( dbseek( (in_file)->ncisFirmy,,'FIRMY1') )
      dphevdw->cVAT_VIES  := firmy->cVAT_VIES

      * z nápoètu favysit / pvpitem
//      dphevdw->c_radku      := 1
      dphevdw->kod_pred_p  := pa_napocet[x,1]
      dphevdw->roz_pl      := pa_napocet[x,3]
      dphevdw->roz_pl_j    := pa_napocet[x,2]
      dphevdw->zakl_dane   := pa_napocet[x,4]
    endif
  next
return self