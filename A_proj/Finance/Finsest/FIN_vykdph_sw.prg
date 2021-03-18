#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
*************** FIN_vykdph_sw **************************************************
CLASS FIN_vykdph_sw FROM drgUsrClass
exported:
  var     task
  method  init, itemMarked, drgDialogStart, drgDialogEnd
  method  comboBoxInit, comboItemSelected
  method  zpracuj_podklady

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
  var     msg, dm, dc, df, ab, oabro, xbp_therm
* datové
  var     culoha, nrok, nobdobi, pa_obdZpr

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


method FIN_vykdph_sw:init(parent)
  local  task := 'fin'

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_task' )
  drgDBMS:open('ucetsys')
  drgDBMS:open('ucetsys',,,,,'ucetsys_w')
  *
  drgDBMS:open('firmy'   )
  drgDBMS:open('c_staty' )
  drgDBMS:open('fakvyshd')
  drgDBMS:open('fakvysit')

  * holt jedeme znovu
  if select('vykdph_sw') <> 0
    vykdph_sw->(dbclosearea())
    FErase( drgINI:dir_USERfitm +'vykdph_sw.adt')
    FErase( drgINI:dir_USERfitm +'vykdph_sw.adi')
  endif

  drgDBMS:open('vykdph_sw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

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


method FIN_vykdph_sw:drgDialogStart(drgDialog)

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


method FIN_vykdph_sw:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

  ucetsys->(ads_clearaof())
return self


method FIN_vykdph_sw:comboBoxInit(drgComboBox)
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


method FIN_vykdph_sw:comboItemSelected(mp1, mp2, o)
  ::pa_obdZpr := {}
  ::nrok      := mp1:value
  ::setFilter()
return .t.


method FIN_vykdph_sw:itemMarked(arowco,unil,oxbp)
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
method FIN_vykdph_sw:set_obdZpr()
  local npos, pa := ::pa_obdZpr

  if( npos := AScan( pa, ucetsys->cobdobi )) = 0
    AAdd( pa, ucetsys->cobdobi )
  else
    ARemove( pa, npos )
  endif

  ::oabro[1]:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
return .t.


method fin_vykdph_sw:zpracuj_podklady()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  cf  := ".not. empty(cdic) .and. ", cfilter
  *
  local  cky, ncisRadku := 1, ncisListu := 1
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2] // -2


  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro souhrnné hlášení', nSize, nHight)

  if sysconfig('FINANCE:nTypVykDPH') = 1                             // mìsíèní    plátci
    cc := replicate( "cobdobiDan = '%%' .or. ", len( pa) )
  else                                                               // ètvrtletní plátci
    cc := replicate( "cobdobi = '%%' .or. ", len( pa) )
  endif

  cf      += "(" +substr( cc, 1, len(cc) -6) +")"
  cfilter := format( cf, pa )

  fakvyshd->( Ads_setAOF(cfilter), dbgoTop() )
  fakvysit->( AdsSetOrder( 'FVYSIT13') )


  do while .not. fakvyshd->(eof())
    fakvysit->( DbSetScope(SCOPE_BOTH, fakvyshd->ncisFak), dbgoTop())
    pa_napocet := {}

    do while .not. fakvysit->(eof())
      if fakvysit->nkodPlneni <> 0
        if( npos := AScan( pa_napocet, {|p| p[1] = fakvysit->nkodPlneni} )) = 0
          AAdd( pa_napocet, { fakvysit->nkodPlneni, fakvysit->ncenZakCel })
        else
          pa_napocet[npos,2] += fakvysit->ncenZakCel
        endif
      endif
      fakvysit->(dbskip())
    enddo


    * pokud nìco naèetl holt to musíme uložit
    for x := 1 to len( pa_napocet ) step 1
      cky := upper( fakvyshd->cdic) +strZero( pa_napocet[x,1], 2 )

      if vykdph_sw->( dbseek( cky ))
        vykdph_sw->ncount     += 1
        vykdph_sw->ncenZakCel += pa_napocet[x,2]
      else
        vykdph_sw->(dbAppend())

        * z fakvyshd
        vykdph_sw->cobdobiDan := fakvyshd->cobdobiDan
        vykdph_sw->cobdobiDan := fakvyshd->cobdobiDan
        vykdph_sw->nrokDan    := 2000+Val(Right(fakvyshd->cobdobiDan,2))
        vykdph_sw->nCisFirmy  := fakvyshd->nCisFirmy
        vykdph_sw->cDic       := fakvyshd->cDic
        vykdph_sw->cZkratStat := fakvyshd->cZkratStat

        * z c_staty
        c_staty->( dbseek( upper(fakvyshd->cZkratStat),,'C_STATY1' ) )
        vykdph_sw->cZkratSta2  := c_staty->cZkratSta2

        * z firmy
        firmy->( dbseek( fakvyshd->ncisFirmy,,'FIRMY1') )
        vykdph_sw->cVAT_VIES  := firmy->cVAT_VIES

        * z nápoètu favysit
        vykdph_sw->nKodPlneni := pa_napocet[x,1]        // MY     kod 0...4  0 - nebereme
        vykdph_sw->nKodPl_FIN := pa_napocet[x,1] - 1    // FIN má kod 0...3
        vykdph_sw->nCount     := 1
        vykdph_sw->nCenZakCel := pa_napocet[x,2]
        vykdph_sw->nCisRadku  := ncisRadku
        vykdph_sw->nCisListu  := ncisListu

        *
        ncisRadku             += 1

        if ncisRadku = 21
          ncisRadku := 1
          ncisListu += 1
        endif

      endif
    next

    fakvyshd->(dbskip())
  enddo

  vykdph_sw ->(dbgotop())

  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro souhrnné hlášení - dokonèeno', nSize, nHight)
  Sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.