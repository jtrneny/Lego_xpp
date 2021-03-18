#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


#define m_KyMonth  "strZero(PHMVYDstro->nRok,4) +strZero(PHMVYDstro->nMesic,2) +upper(PHMVYDstro->cStroj)"
#define m_KyYear   "strZero(PHMVYDstro->nRok,4) +upper(PHMVYDstro->cStroj)"


**
** CLASS for SKL_phm_vydDen_SCR *********************************************
CLASS SKL_phm_vydDen_SCR FROM drgUsrClass
EXPORTED:
  var     rok, obdobi, rokobdobi
  var     nazMes, tyd1, tyd2, tyd3, tyd4, tyd5, tyd6, firstAtrr

  var     oinf
  method  init, drgDialogStart, eventHandled
  method  postValidate
  method  tabSelect, itemMarked


  inline access assign method spoRMes_BC() var spoMes_BC
    local  cky := DBGetVal( m_KyMonth ), nspoMes := 0

     denStroj_S->( ordSetFocus('PHMSTRO_05')                      , ;
                   dbsetScope( SCOPE_BOTH, cKy)                   , ;
                   dbeval( { || nspoMes += denStroj_S->nspoDen } ), ;
                   dbclearScope()                                   )
   return nspoMes


  inline access assign method spoRok_BC() var spoRok_BC
    local  cky := DBGetVal( m_KyYear ), nspoRok := 0

     denStroj_S->( ordSetFocus('PHMSTRO_03')                      , ;
                   dbsetScope( SCOPE_BOTH, cKy)                   , ;
                   dbeval( { || nspoRok += denStroj_S->nspoDen } ), ;
                   dbclearScope()                                   )
  return nspoRok

  *
  **
  inline method pbtn_gradientColors(oxbp, x_newGrad)
    local x_oldGrad := oxbp:GradientColors
    local lok := .t.

    do case
    case isNull(x_oldGrad)
    case isNumber(x_oldGrad)
    case isArray(x_oldGrad) .and. isArray(x_newGrad)
      lok := ( (x_oldGrad[1] +x_oldGrad[2]) <> (x_newGrad[1] +x_newGrad[2]) )
    endcase

    if( lok, oxbp:SetGradientColors( x_newGrad), nil )
  return self


  inline method pbtn_denClick(oxbp,npos)
    local nden    := val( oxbp:caption)
    local pa_Days := ::pa_Days, x
    local cky, pa, x_color := ::a_popUp[::popState,3]
    local a_color := { 0, 5 }                        // barva pro aktivní button
    local oxbp_pb, old_font, onew_font
    *
    local s_Date  := dtos( pa_Days[npos,5] )
    local c_Date  := dtoc( pa_Days[npos,5] )
    local cf      := "ddatPoh = '%%'", filter


    for x := 1 to len(pa_Days) step 1

      pa_Days[x,10]:hide()

      if pa_Days[x,1]:isEdit
        oxbp_pb   := pa_Days[x,1]:oxbp
        oold_font := oxbp_pb:setFont()
        onew_font := if( isObject(pa_Days[x,3]), pa_Days[x,3], drgPP:getFont(1))

        if( oold_font <> onew_Font, oxbp_pb:setFont(onew_font), nil )

        if isArray(pa_Days[x,4])
          ::pbtn_gradientColors(oxbp_pb,pa_Days[x,4])
        else
          pa_Days[x,1]:oxbp:SetGradientColors( 0 )
        endif

        * indikace > pokud je výdej
        if( denStroj_S->( dbseek( dtos(pa_Days[x,5]),,'PHMstro_04')), pa_Days[x,10]:show(), pa_Days[x,10]:hide() )


        if ( isDate( pa_Days[x,5] ) .and. ::popState <> 1 )

           pa := { (pa_Days[x,7] - ::nhodDenF), (pa_Days[x,8] - pa_Days[x,6]) }

           * zatím SO/NE a SV - pokud nemá nic z docházky
           if( pa_Days[x,9] = 0 .and. pa_Days[x,7] = 0, pa[1] := 0, nil )

/*
           if     ::popState = 2  // kontrola docházky proti fondu pracovní doby
             if( pa[1] <> 0, ::pbtn_gradientColors(oxbp_pb,x_color), nil )

           elseif ::popState = 3  // kontrola docházky proti výrobe
             if( pa[2] <> 0, ::pbtn_gradientColors(oxbp_pb,x_color), nil )

           elseif ::popState = 4  // kontrola docházky proti fondu pracovní doby a proti výrobe
             if     pa[1] <> 0 .and. pa[2] <> 0
               ::pbtn_gradientColors(oxbp_pb,x_color)

             elseif pa[1] <> 0
               ::pbtn_gradientColors(oxbp_pb,::a_popUp[2,3])

             elseif pa[2] <> 0
               ::pbtn_gradientColors(oxbp_pb,::a_popUp[3,3])

             endif
           endif
*/

        endif
      endif
    next

    ::oxbp_selDay := pa_Days[npos,1]:oxbp
    ::dsel_Days   := pa_Days[npos,5]

    oxbp:setFont(drgPP:getFont(5) )

    if isArray(oxbp:GradientColors)
      ( a_color := aclone(oxbp:GradientColors), a_color[2] := 5)
    endif
    oxbp:SetGradientColors( a_color )

    ::df:olastdrg   := pa_Days[npos,1]
    ::df:nlastdrgix := pa_Days[npos,2]
    ::df:olastdrg:setFocus()

    filter := format( cf, {c_Date} )
    PHMVYDstro->( ads_setAof( filter), dbgoTop())
    PHMVYDstoj->( ads_setAof( filter), dbgoTop())

    ::dc:oBrowse[1]:oxbp:refreshAll()
    ::dc:oBrowse[2]:oxbp:refreshAll()

    postAppEvent( xbeBRW_ItemMarked,,,::dc:oBrowse[2]:oxbp )
  return self


  inline method EBro_saveEditRow(o_eBro)
    local npos, oxbp_selDay := ::oxbp_selDay
    local cStatement, oStatement, csid_VYDstoj
    local stmt := "update phmVYDstoj set phmVYDstoj.nvydej    =                       ( select sum(nspoDen) from phmVYDstro where nVYDSTOJ = phmVYDstoj.sid), " + ;
                                        "phmVYDstoj.naktStav  = phmVYDstoj.npocStav - ( select sum(nspoDen) from phmVYDstro where nVYDSTOJ = phmVYDstoj.sid)  "                                                 + ;
                  "where phmVYDstoj.sid in(%sid_VYDstoj);"


    if (::it_file)->nRok = 0  // nová položka výdeje
      (::it_file)->ddatPoh   := ::dsel_Days
      (::it_file)->nRok      := ::rok
      (::it_file)->nMesic    := ::obdobi
      (::it_file)->nVYDSTOJ  := phmVYDstoj->sid
    endif

    (::it_file)->cnazStoj  := ::otxt_nazStoj:value
    (::it_file)->cnazStroj := ::otxt_nazStroj:value
    phmVYDstro->(dbcommit())
    *
    if( npos := ascan( ::pa_Days, { |i| i[1]:oxbp = oxbp_selDay } ) ) <> 0
      ::pa_Days[npos,10]:show()
    endif
    *
    csid_VYDstoj := strTran( str(phmVYDstoj->sid), ' ', '' )
    cStatement   := strTran(       stmt, '%sid_VYDstoj', csid_VYDstoj )
    oStatement   := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
*        return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif

    phmVYDstoj->(dbcommit())
    ::oDBro_vydStoj:oxbp:refreshCurrent()
  return .t.


HIDDEN:
   var  brow, dm, dc, df, msg
   var  hd_file, it_file, oDBro_vydStoj, oEBro_vydStro

   var  oxpbStatic_Days, nactive_Clr
   var  pa_Days, nden_Beg, oxbp_selDay, dsel_Days, oxbp_firstDay
   var  otxt_nazStoj, otxt_nazStroj

   var  popState, a_popUp
   VAR  tabnum

   method  refresh_SCR


   inline method set_rowPos_VYDstoj(nsel_stojan)
     local  rowPos      := 1
     local  npocStav    := 0
     *
     ** nenašel stojan, bacha itemMarked
     if .not. phmVYDstoj->( dbseek( nsel_stojan,, 'PHMstoj_02'))

       if nsel_stojan <> 0
         mh_copyFld( 'stojany', 'phmVYDstoj', .t. )

         phmVYDstoj->ddatPoh  := ::dsel_Days
         phmVYDstoj->nRok     := ::rok
         phmVYDstoj->nMesic   := ::obdobi
         phmVYDstoj->npocStav := ::cmp_pocStav()   // npocStav

         phmVYDstoj->( dbunlock(), dbCommit())
       endif
     endif

     phmVYDstoj->( dbgoTop())

     BEGIN SEQUENCE
      do while .not. phmVYDstoj ->(eof())
       if phmVYDstoj->nstojan = nsel_stojan
     BREAK
       else
         rowPos++
       endif

       phmVYDstoj->( dbskip())
       endDo
     END SEQUENCE

     phmVYDstoj->( dbgoTop())

     ::oDBro_vydStoj:oxbp:forceStable()
     ::oDBro_vydStoj:oxbp:refreshAll()
     ::oDBro_vydStoj:oxbp:ItemLbDown( rowPos, 1 ):refreshCurrent()

**     postAppEvent( xbeBRW_ItemMarked,,,::dc:oBrowse[2]:oxbp )
**     setAppFocus(::oEBro_vydStro:oxbp)
   return self


   inline method cmp_pocStav()
     local  cKy_cenZboz := upper(stojany->ccisSklad) +upper(stojany->csklPol)
     local  cf := "nrok = %% and nstojan = %% and ndoklad = 0", filter
     local  nmnozSzbo, sum_spoDen := 0

     cenZboz->( dbseek( cKy_cenZboz,,'CENIK03'))
     nmnozSzbo := cenZboz->nmnozSzbo

     filter := format( cf, { ::rok, stojany->nstojan })
     denStroj_S->( ads_setAof(filter)                                , ;
                   dbgoTop()                                         , ;
                   dbeval( { || sum_spoDen += denStroj_S->nspoDen } ), ;
                   ads_clearAof()                                      )

   return nmnozSzbo -sum_spoDen

ENDCLASS


method SKL_phm_vydDen_SCR:init(parent)

  ::drgUsrClass:init(parent)

  (::hd_file     := 'PHMVYDstoj', ::it_file := 'PHMVYDstro')

  ::rok       := uctOBDOBI:SKL:NROK
  ::obdobi    := uctOBDOBI:SKL:NOBDOBI
  ::rokobdobi := uctOBDOBI:SKL:NROKOBD
  ::popState  := 1
  ::a_popUp   := { { 'Kontroly vypnuty                         ' , 0,                                      }, ;
                   { 'Kontrola na fond pracDoby                ' , 1, { GraMakeRGBColor({ 24,180,244}), 0} }, ;
                   { 'Kontrola na mzdové lístky                ' , 2, { GraMakeRGBColor({255,130,192}), 0} }, ;
                   { 'Kontrola na fond pracDoby a mzdové lístky' , 3, { GraMakeRGBColor({ 24,180,244}), GraMakeRGBColor({255,130,192}) } } }
  ::nactive_Clr := GraMakeRGBColor( {245, 239, 207 } )


  ( ::nazMes := ::tyd1 := ::tyd2 := ::tyd3 := ::tyd4 := ::tyd5 :=::tyd6 := '' ) //  název mìsíce + '1..6. týden'

  drgDBMS:open('kalendar')
  drgDBMS:open('kalendar'  ,,,,,'kalendarA' ) // __?__

  drgDBMS:open('cenZboz')

*  drgDBMS:open('c_drPohy')
*  drgDBMS:open('pvpitem')
*  pvpitem->( ordSetFocus('PVPITEM16'))  // UPPER (CCISSKLAD) + UPPER (CSKLPOL) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)
*  drgDBMS:open('cenZb_ps')


  drgDBMS:open('PHMVYDstoj',,,,,'denStoj_S' )
  drgDBMS:open('PHMVYDstro',,,,,'denStroj_S')
  *
  * TMP soubory *
  drgDBMS:open('mesicw'    ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  ::tabnum   := 1
return self


method SKL_phm_vydDen_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers, x
  local  nden, d_Den, oxbp_firstDay
  local  pa_days, tipText, cevent
  local  pb      := { GraMakeRGBColor({255, 255,   0}), GraMakeRGBColor({255, 255, 210}) }
  local  pa      := { GraMakeRGBColor({ 78, 154, 125}), GraMakeRGBColor({157, 206, 188}) }
  *
  local  odrg, groups

  ::brow     := drgDialog:dialogCtrl:oBrowse
  ::dm       := drgDialog:dataManager             // dataMananager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // dialogForm
  ::msg      := drgDialog:oMessageBar             // messageBar

  ::oDBro_vydStoj := ::dc:oBrowse[1]
  ::oEBro_vydStro := ::dc:oBrowse[2]

  ::otxt_nazStoj  := ::dm:has('PHMVYDstro->cnazStoj' )
  ::otxt_nazStroj := ::dm:has('PHMVYDstro->cnazStroj')

  ::nactive_Clr := GraMakeRGBColor( {245, 239, 207 } )
  ::pa_Days     := pa_Days := {}
  ::nden_Beg    := 0

  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)

    if members[x]:ClassName() = "drgPushButton"
      tipText := isNull( members[x]:tipText, '' )
      cevent  := isNull( members[x]:event  , '' )

      do case
      case tipText = 'DAY'
        apos  := members[x]:oxbp:currentPos()
        obord := members[x]:oxbp:parent
        oinfo := XbpStatic():new(obord,,{apos[1]-11,apos[2]+4},{10,10} ,, .f.)
        oinfo:type    := XBPSTATIC_TYPE_ICON // XBPSTATIC_TYPE_RECESSEDBOX
        oinfo:caption := 462                 // 'green >'
        oinfo:create()

        members[x]:oxbp:toolTipText := ''

        // drgPushButton, POS, FONT, GRADIENT_CLR, dDatum, listit.nnhNAopesk, dspohyby.ncasCelCPD cond [nsumVyr = 1], dsPohyby.ncasCelCPD cond [nnapPrer in {1,2,3} ], kalendar.ndenPracov
        aadd( pa_days, { members[x], x, 0, 0, nil, 0, 0, 0, 0, oinfo } )

      case cevent = 'createContext'
        ::pb_context := members[x]

      endcase
    endif
**
    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      ::oxpbStatic_Days := members[x]:oxbp
*      members[x]:oxbp:setColorBG( GRA_CLR_BACKGROUND ) // GraMakeRGBColor( {245, 239, 207 } ) )
      ::oxpbStatic_Days:setColorBG( ::nactive_Clr )
    endif
**
  next
  *
  ** obecná procedura pøi pøepnutí období
  ::refresh_SCR()

  isEditGet( {'m->tyd1','m->tyd2','m->tyd3','m->tyd4','m->tyd5','m->tyd6'}, drgDialog, .F. )
return self



method SKL_phm_vydDen_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  local  olastDrg := ::df:oLastDrg, oxbp_Day, oxbp_nextDay
*  local  dc  := ::drgDialog:dialogCtrl
*  local  msg := ::drgDialog:oMessageBar

  do case
  case( nevent = xbeM_LbDown )
    do case
    case (oxbp:className() = 'XbpImageButton')
      if( npos := ascan( ::pa_Days, { |i| i[1]:oxbp = oxbp } ) ) <> 0

        if ::oxpbStatic_Days:setColorBG() = GRA_CLR_BACKGROUND
          ::oxpbStatic_Days:setColorBG( ::nactive_Clr )
        endif
*        if( 'browse' $ lower(olastDrg:className()), ::dc:sp_resetActiveArea( olastDrg, .f., .f.), nil )

        ::pbtn_denClick(oxbp,npos)
      endif
      return .f.
    endcase

  case nEvent = xbeP_Keyboard
    if oxbp:className() = 'XbpImageButton' .or. olastDrg:className() = 'drgPushButton'

       oxbp_Day := if( oxbp:className() <> 'XbpImageButton', olastDrg:oxbp, oxbp )

       if( npos := ascan( ::pa_Days, { |i| i[1]:oxbp = oxbp_Day } ) ) <> 0
         do case
         case mp1 = xbeK_UP
           if npos -7 > 0
             if ::pa_Days[npos-7,1]:isEdit
               oxbp_nextDay := ::pa_Days[npos-7,1]:oxbp
             endif
           endif

         case mp1 = xbeK_DOWN
           if len(::pa_Days) >= npos +7
             if ::pa_Days[npos+7,1]:isEdit
               oxbp_nextDay := ::pa_Days[npos+7,1]:oxbp
             endif
           endif

         case mp1 = xbeK_LEFT
           if npos -1 > 0
             if ::pa_Days[npos-1,1]:isEdit
               oxbp_nextDay := ::pa_Days[npos-1,1]:oxbp
             endif
           endif

          case mp1 = xbeK_RIGHT
            if len(::pa_Days) >= npos +1
              if ::pa_Days[npos+1,1]:isEdit
                oxbp_nextDay := ::pa_Days[npos+1,1]:oxbp
              endif
            endif
          endcase

          if isObject(oxbp_nextDay)
            postAppEvent(xbeM_LbDown, mh_GetAbsPos(oxbp_nextDay),,oxbp_nextDay)
            setAppFocus(oxbp_nextDay)
          endif
       endif
    endif

  case( nEvent = drgEVENT_OBDOBICHANGED )
    ::rok       := uctOBDOBI:SKL:NROK
    ::obdobi    := uctOBDOBI:SKL:NOBDOBI
    ::rokobdobi := uctOBDOBI:SKL:NROKOBD

    ::refresh_SCR()

  case(nEvent = xbeBRW_ItemMarked)
    ::msg:WriteMessage(,0)
    return .f.

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
    return .t.

  CASE nEvent = drgEVENT_FORMDRAWN
     return .T.

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .F.


method SKL_phm_vydDen_SCR:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)
  *
  if( ::df:in_postvalidateForm .and. (file = ::hd_file), file := '', nil )

  do case
  case( name = ::it_file +'->nstojan' )
    ::otxt_nazStoj:set(stojany->cnazStoj)
    *
    ** potøebujeme najít stojan, pokud neexistuje založit
    ::set_rowPos_VYDstoj(value)

  case( name = ::it_file +'->cstroj' )
    ::otxt_nazStroj:set(stroje->cnazStroj)
  endcase
return .t.


method SKL_phm_vydDen_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


method SKL_phm_vydDen_SCR:itemMarked(arowco,unil,oxbp)
  local cfile, ky, rest := ''

  if isobject(oxbp)
    if( lower(oxbp:cargo:cfile) = 'phmvydstro')
      ::set_rowPos_VYDstoj(phmVYDstro->nstojan)
      ::df:setNextFocus(::oEBro_vydStro,,.t.)   // vot problema
    endif
/*
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'phmvydden', 'ab',if(cfile = 'phmvydstoj','b', ''))

    if( 'a' $ rest)
      ky := phmVYDden->ndoklad
      phmVYDstoj->(AdsSetOrder('PHMSTOJ_01'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    endif

    if ('b' $ rest)
      ky := strzero(phmVYDstoj->ndoklad,10) +strzero(phmVYDstoj->nstojan,5)
*      phmVYDstro->(AdsSetOrder('PHMstro_01'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    endif

*    c_typpoh->(dbseek(upper(pokladhd->culoha) +upper(pokladhd->ctypdoklad) +upper(pokladhd->ctyppohybu),,'C_TYPPOH05'))
*    drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
*/
  endif
return self


*
*HIDDEN*************************************************************************
*
method SKL_phm_vydDen_SCR:refresh_SCR()
  local  cfiltr, attr, x
  local  pa_tyd   := {}
  local  pa_Days  := ::pa_Days, oxbp_firstDay
  *
  local  pb      := { GraMakeRGBColor({255, 255,   0}), GraMakeRGBColor({255, 255, 210}) }
  local  pa      := { GraMakeRGBColor({ 78, 154, 125}), GraMakeRGBColor({157, 206, 188}) }


  cfiltr := Format("nRokObd= %%", {::rokobdobi})
  kalendarA->(ads_setaof(cfiltr), dbGoTop())
  kalendarA->( dbGoTop())

  mesicW->( dbZap(), dbAppend() )

** mìsíc
  ::nazMes := kalendarA->cnazmes
  ::dm:set( 'M->nazMes', kalendarA->cnazmes )

** týdny
  do while .not. kalendarA->( Eof())
    atrr := 'd' +Str(kalendarA->ntydvmespo,1) +Str(kalendarA->ndenvtydpo,1)
    mesicw->&atrr := kalendarA->nden
    atrr := 'c' + atrr
    mesicw->&atrr := StrZero( kalendarA->nden,2)
    if( kalendarA->nden = 1, ::firstAtrr := atrr, nil)

    if ascan( pa_tyd, kalendarA->ntyden ) = 0
      aadd( pa_tyd, kalendara->ntyden )
    endif

    kalendarA->(dbSkip())
  enddo
  mesicW->( dbCommit())
  kalendarA->( dbGoTop())

  pa_tyd := asize( pa_tyd, 6)

  for x := 1 to len(pa_tyd) step 1
    cc := 'M->tyd' +str(x,1)
    cX := 'tyd' +str(x,1)

    if isNull(pa_tyd[x])
     ::dm:has( cc ):odrg:oxbp:Hide()
   else
     self:&cX := '   ' +strZero(pa_tyd[x], 2) + '. týden'
     ::dm:has( cc ):odrg:oxbp:Show()
     ::dm:set( cc, '   ' +strZero(pa_tyd[x], 2) + '. týden' )
   endif
  next

** dny
  for x := 1 to 42 step 1
    nden  := mesicW->( fieldGet(x))

    if nden = 0
      pa_days[x,1]:isEdit := .f.
      pa_days[x,1]:oxbp:hide()

    else
      pa_days[x,1]:isEdit := .t.
      pa_days[x,1]:oxbp:show()

      d_Den := str(::rok,4) +strZero(::obdobi,2) +strZero(nden,2)
      kalendar->( dbseek( d_Den,, 'KALENDAR01'))

      pa_days[x,9] := kalendar->ndenPracov

      if isNull(::oxbp_firstDay)
        ::oxbp_firstDay := pa_days[x,1]:oxbp
        ::nden_Beg      := x -1
        ::dsel_Days     := kalendar->dDatum
      endif

      pa_days[x,1]:caption := str(nden,2)
      pa_days[x,1]:oxbp:setCaption( str(nden,2))

      pa_days[x,1]:oxbp:toolTipText := dtoc(kalendar->dDatum)

      do case
      case( kalendar->ndenvTydPO = 6 .or. kalendar->ndenvTydPO = 7 )            // Sobota Nedìle
        pa_days[x,1]:oxbp:setFont(drgPP:getFont(5))
        pa_days[x,1]:oxbp:SetGradientColors( pa )

      case( kalendar->ndenSvatek = 1                               )            // Svátek
        pa_days[x,1]:oxbp:setFont(drgPP:getFont(5))
        pa_days[x,1]:oxbp:SetGradientColors( pb )

      endcase
    endif

    pa_days[x,3] := pa_days[x,1]:oxbp:setFont()
    pa_days[x,4] := pa_days[x,1]:oxbp:GradientColors
    pa_days[x,5] := kalendar->dDatum
  next

  ::pbtn_denClick( ::oxbp_firstDay, ::nden_Beg+1 )
  ::df:setNextFocus(::oxbp_firstDay:cargo)
return self