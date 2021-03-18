#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

/*
#xtranslate  _mFILE  =>  pA\[ 1\]        //_ základní soubor       _

#xtransalte adrgPushButton
#xtransalte POS
#xtransalte FONT
#xtransalte GRADIENT_CLR
#xtransalte dDatum
#xtransalte listitkj.nnhNAopesk
#xtransalte dspohyby.ncasCelCPD cond [nsumVyr = 1]
#xtransalte dsPohyby.ncasCelCPD cond [nnapPrer in {1,2,3} ]
*/


*
*
** CLASS DOH_dochazkadny_IN *******************************************************
CLASS DOH_dochazkadny_IN FROM drgUsrClass
EXPORTED:
  var     rok, obdobi, rokobdobi
  var     stavem
  var     tyd1, tyd2, tyd3, tyd4, tyd5, tyd6
  var     firstatrr

  var     quickFilter
  var     sel_Item, cur_Value, sel_Filtrs

  method  Init
  method  InFocus
  method  drgDialogStart, drgDialogEnd
  *
  method  preValidGet
  method  posValidGet
  method  ebro_saveEditRow
  method  ebro_afterAppend
  method  postDelete


  inline access assign method doch_ZaDen() var doch_ZaDen
    return 'Docházka za den - ' +if( isNull(::dsel_Days), '', dtoc(::dsel_Days) )


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  olastDrg := ::df:oLastDrg, oxbp_Day, oxbp_nextDay
    local  oxbp_Bro, nclr := GraMakeRGBColor( {234, 255, 213 } )
    local  inFile

/*
    if ( ::nsum_casCELcpd <> ::oThread:nsum_casCELcpd ) .or. ;
       ( ::nsum_nhNAopesk <> ::oThread:nsum_nhNAopesk )

      oxbp_Day := ::oxbp_selDay
      if( npos := ascan( ::pa_Days, { |i| i[1]:oxbp = oxbp_Day } ) ) <> 0
        ::pbtn_denClick(oxbp_Day,npos)
      endif
      ::nsum_casCELcpd := ::oThread:nsum_casCELcpd
      ::nsum_nhNAopesk := ::oThread:nsum_nhNAopesk
    endif
*/

    do case
    case( nevent = xbeM_LbDown )
      do case
      case (oxbp:className() = 'XbpImageButton')
        if( npos := ascan( ::pa_Days, { |i| i[1]:oxbp = oxbp } ) ) <> 0

          if ::oxpbStatic_Days:setColorBG() = GRA_CLR_BACKGROUND
            ::oxpbStatic_Days:setColorBG( ::nactive_Clr )
          endif
          if( 'browse' $ lower(olastDrg:className()), ::dc:sp_resetActiveArea( olastDrg, .f., .f.), nil )

          ::pbtn_denClick(oxbp,npos)
        endif

      case (oxbp:className() = 'XbpCellGroup')

        if ::oxpbStatic_Days:setColorBG() <> GRA_CLR_BACKGROUND
          ::oxpbStatic_Days:setColorBG( GRA_CLR_BACKGROUND )
        endif

        oxbp_Bro := oxbp:parent:cargo

        for ncol := 1 to oxbp_Bro:colCount step 1
          ocol := oxbp_Bro:getColumn(ncol):dataArea
          ocol:setColorBG( ::nactive_Clr )
        next
      endCase

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

    case nEvent = drgEVENT_DELETE
      inFile := lower(::dc:oaBrowse:cfile)

      if inFile = 'dspohybya' .and. .not. (inFile)->(eof())
        if drgIsYesNo( 'Zrušit položku pohybu docházky  ? ' )
          ::postDelete()
        endif
      endif
      return .t.


    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
*       ::setSysFilter()
       ::obdobi := uctOBDOBI:DOH:NOBDOBI
       return .t.
    otherwise
      return .f.
    endcase
  return .f.


  inline method itemMarked()
    local  mdatum := tminfSumW->_mdatum
    local  pa     := ::pa_Days

//    aeval( pa, {|x| if( dtos(x[5]) $ mdatum, x[10]:show(), x[10]:hide() ) } )
    aeval( pa, {|x| if( x[1]:isEdit .and. dtos(x[5]) $ mdatum, x[10]:show(), x[10]:hide() ) } )
  return self


  inline method createContext()
    local  pa := ::a_popUp, opopup
    local  x, aPos, aSize

    opopup         := XbpImageMenu( ::drgDialog:dialog ):new()
    opopup:barText := 'docházka'
    opopup:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                       , ;
                       de_BrowseContext(self,x,pA[x]), ;
                                                     , ;
                       XBPMENUBAR_MIA_OWNERDRAW        }, ;
                       if( x = ::quickFilter, 500, 0)     )
    next

*    oPopup:disableItem(::popState)

    aPos    := ::pb_context:oXbp:currentPos()
    aSize   := ::pb_context:oXbp:currentSize()
    opopup:popup( ::pb_context:oxbp:parent, { apos[1] -21, apos[2] } )
  return self


  inline method fromContext(aorder,p_popUp, lin_Start)
    local  npos, oxbp_selDay := ::oxbp_selDay

    default lin_Start to .f.

    ::pb_context:oxbp:setCaption( allTrim( p_popUp[1]))
    ::pb_context:oxbp:SetGradientColors( p_popUp[3]   )

    ::popState := aorder

    ** ? oznaèil si pøednastavený quickFilter, pokud ne je to jen pøepnutí
    if AppKeyState( xbeK_CTRL ) = APPKEY_DOWN
      ::quickFilter := if( ::quickFilter = aorder, 0, aorder )
    endif

*    if .not. lin_Start
      ::pb_context:oxbp:setImage( if( ::quickFilter = aorder, ::oico_isQuick, ::oico_noQuick ))

      if( npos := ascan( ::pa_Days, { |i| i[1]:oxbp = oxbp_selDay } ) ) <> 0
        ::pbtn_denClick( oxbp_selDay, npos)
      endif
*    endif
  return self

***
  inline method modify_pa_Days(nState)  // 0 - init  1 - execute
    local  pa := ::pa_Days, nden
    local  nsum_casCELcpd := 0, nsum_nhNAopesk := 0
    local  oxbp_Day, npos

    if nState = 0
      ::nsum_casCELcpd := 0
      ::nsum_nhNAopesk := 0

      drgDBMS:open( 'dsPohyby',,,,, 'dsPohyby_x')
      drgDBMS:open( 'c_prerus',,,,, 'c_prerus_x')
      drgDBMS:open( 'listit'  ,,,,, 'listit_x'  )

      dsPohyby_x->( ads_setaof(::cflt_dsPohyby), dbgoTop() )
      listit_x  ->( ads_setaof(::cflt_listit)  , dbgoTop() )
    else
      dsPohyby_x->( dbgoTop(), dbEval( { || nsum_casCELcpd += dsPohyby_x->ncasCELcpd } ))
      listit_x  ->( dbgoTop(), dbEval( { || nsum_nhNAopesk += listit_x  ->nnhNAopesk } ))
    endif

    if nState = 1 .and. (::nsum_casCELcpd + ::nsum_nhNAopesk) = (nsum_casCELcpd + nsum_nhNAopesk )
      return self
    endif

    dsPohyby_x->( dbgoTop())
    aeval( pa, { |x| ( x[7] := 0, x[8] := 0 ) } )

    do while .not. dsPohyby_x->( eof())
      if( nden := DaY( dsPohyby_x->dDatum)) <> 0
        if c_prerus_x->( dbseek( dsPohyby_x->nkodPrer,,'C_PRERUS03' ))

          if ( c_prerus_x->nnapPrer = 1 .or. c_prerus_x->nnapPrer = 2 .or. c_prerus_x->nnapPrer = 3 )
            pa[ nden + ::nden_Beg, 7] += dsPohyby_x->ncasCELcpd
          endif

          if ( c_prerus_x->nsumVyr = 1 )
            pa[ nden + ::nden_Beg, 8] += dsPohyby_x->ncasCELcpd
          endif
        endif
      endif
      ::nsum_casCELcpd += dsPohyby_x->ncasCELcpd
      dsPohyby_x->( dbskip())
    enddo

    listit_x->( dbgoTop())
    aeval( pa, { |x| x[6] := 0 } )

    do while .not. listit_x->( eof())
      if( nden := DaY( listit_x->dvyhotSkut)) <> 0
        pa[ nden + ::nden_Beg, 6] += listit_x->nnhNAopesk
      endif
      listit_x->( dbskip())
      ::nsum_nhNAopesk += listit_x->nnhNAopesk
    enddo

    if nState = 1
      postAppEvent(xbeM_LbDown, mh_GetAbsPos(::oxbp_selDay),,::oxbp_selDay)
      ::nsum_casCELcpd := nsum_casCELcpd
      ::nsum_nhNAopesk := nsum_nhNAopesk
    endif
  return self



hidden:
  var  brow, dm, dc, df, msg
  var  oxbp_selDay, oico_noQuick, oico_isQuick
  var  pb_context, a_popUp, popState
  var  pa_Days, nhodDenF, dsel_Days
  var  oldGet
  var  preValid
  *
  var  oxpbStatic_Days, nactive_Clr
  var  oEBro_dsPohybyA, oDBro_listit, oDBro_tmINFsumW
  var  lfirst
  *
  var  nden_Beg, cflt_dsPohyby, cflt_listit
  var  othread
  var  nsum_casCELcpd, nsum_nhNAopesk


  inline method refresh(drgVar)
    LOCAL  nIn, nFs, odrg
    LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
    //
    LOCAL  dc       := ::drgDialog:dialogCtrl
    LOCAL  dbArea   := ALIAS(dc:dbArea)

* 1- kotrola jen pro datové objekty aktuální DB
* 2- kominace refresh tj. znovunaètení dat
*  - mìl by probìhnout refresh od aktuálního prvku dolù

//    nFs := AScan(vars:values, {|X| X[1] = Lower(drgVar:Name) })

    for nIn := 1 to vars:size() step 1
      oVar := vars:getNth(nIn)

      if isBlock( ovar:block )
        xVal := eval( ovar:Block )

        if ovar:value <> xVal
          ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    NEXT
  RETURN .T.


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
    local odrg    := ::dm:has('tmcelsumw->nhoddenF')
    local s_Date  := dtos( pa_Days[npos,5] )

    for x := 1 to len(pa_Days) step 1
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

        if ( isDate( pa_Days[x,5] ) .and. ::popState <> 1 )

           pa := { (pa_Days[x,7] - ::nhodDenF), (pa_Days[x,8] - pa_Days[x,6]) }

           * zatím SO/NE a SV - pokud nemá nic z docházky
           if( pa_Days[x,9] = 0 .and. pa_Days[x,7] = 0, pa[1] := 0, nil )

           if     ::popState = 2  // kontrola docházky proti fondu pracovní doby
             if( pa[1] <> 0, ::pbtn_gradientColors(oxbp_pb,x_color), nil )

           elseif ::popState = 3  // kontrola docházky proti výrobì
             if( pa[2] <> 0, ::pbtn_gradientColors(oxbp_pb,x_color), nil )

           elseif ::popState = 4  // kontrola docházky proti fondu pracovní doby a proti výrobì
             if     pa[1] <> 0 .and. pa[2] <> 0
               ::pbtn_gradientColors(oxbp_pb,x_color)

             elseif pa[1] <> 0
               ::pbtn_gradientColors(oxbp_pb,::a_popUp[2,3])

             elseif pa[2] <> 0
               ::pbtn_gradientColors(oxbp_pb,::a_popUp[3,3])

             endif
           endif
        endif

      endif
    next

    ::oxbp_selDay := pa_Days[npos,1]:oxbp
    ::dsel_Days   := pa_Days[npos,5]

    oxbp:setFont(drgPP:getFont(5) )
**    oxbp:SetGradientColors( {0,5} )

    if isArray(oxbp:GradientColors)
      ( a_color := aclone(oxbp:GradientColors), a_color[2] := 5)
    endif
    oxbp:SetGradientColors( a_color )

    ::df:olastdrg   := pa_Days[npos,1]
    ::df:nlastdrgix := pa_Days[npos,2]
    ::df:olastdrg:setFocus()

    cky := StrZero(osoby->ncisOsoby,6) + StrZero(::rok,4) + StrZero(::obdobi,2) +StrZero( nden,2)
    dsPohybyA->( ordSetFocus( 'DSPOHY21' )    , ;
                 dbsetScope( SCOPE_BOTH, cky ), ;
                 dbgoTop()                      )

    cky := StrZero(osoby->ncisOsoby,6) +s_Date
    listit->( ordSetFocus( 'LISTI23' )     , ;
              dbsetScope( SCOPE_BOTH, cky ), ;
              dbgoTop()                      )

    kalendard->( dbSeek( s_Date,,'KALENDAR01'))

    ::dc:oBrowse[1]:oxbp:refreshAll()
    ::dc:oBrowse[2]:oxbp:refreshAll()

    DOCH_sum( OSOBY->nCisOsoby, ::rok, ::obdobi, pa_Days[npos,5] )
    ::dc:oBrowse[3]:oxbp:refreshAll()
    postAppEvent( xbeBRW_ItemMarked,,,::dc:oBrowse[3]:oxbp )

    ::refresh( odrg )
  return self

endclass


METHOD DOH_dochazkadny_IN:Init(parent)
  LOCAL  nROK, nOBDOBI, cFiltr
  LOCAL  cX, cc
  local  atrr
  local  tmTyden := 0
  local  file_name
  *
  local  aFond
  local  ndnyPrcTyd := sysConfig('mzdy:ndnyPrcTyd')
  local  ndelPrcTyd := sysConfig('mzdy:ndelPrcTyd')

//  isWorkVersion := .f.

  ::drgUsrClass:init(parent)

  aFond := { ndnyPrcTyd, ndelPrcTyd, round( ndelPrcTyd/ndnyPrcTyd,2 ) }
  aFond := fPracDOBA( osoby->cdelkprDOB)

  ::quickFilter := 0
  ::sel_Item    := ''
  ::cur_Value   := ''
  ::sel_Filtrs  := {}
  ::preValid    := .t.
  ::lfirst      := .t.

  ::oico_noQuick := XbpIcon():new():create()
  ::oico_isQuick := XbpIcon():new():create()
  ::oico_isQuick:load( NIL, 101 )

  ::nhodDenF := aFond[3]
  ::popState := 1
  ::a_popUp  := { { 'Kontroly vypnuty                         ' , 0,                                      }, ;
                  { 'Kontrola na fond pracDoby                ' , 1, { GraMakeRGBColor({ 24,180,244}), 0} }, ;
                  { 'Kontrola na mzdové lístky                ' , 2, { GraMakeRGBColor({255,130,192}), 0} }, ;
                  { 'Kontrola na fond pracDoby a mzdové lístky' , 3, { GraMakeRGBColor({ 24,180,244}), GraMakeRGBColor({255,130,192}) } } }


  ::rok       := uctOBDOBI:DOH:NROK
  ::obdobi    := uctOBDOBI:DOH:NOBDOBI
  ::rokobdobi := uctOBDOBI:DOH:NROKOBD
  ::stavem    := '1'
  ::tyd1 := ''  //  '1. týden'
  ::tyd2 := ''  //  '2. týden'
  ::tyd3 := ''  //  '3. týden'
  ::tyd4 := ''  //  '4. týden'
  ::tyd5 := ''  //  '5. týden'
  ::tyd6 := ''  //  '6. týden'

  ::oldGet := ''

  ** ?? **
  drgDBMS:open('dspohyby',,,,, 'dsPohybyS')
  drgDBMS:open('c_prerus',,,,, 'c_prerusS')
  drgDBMS:open('c_prerus',,,,, 'c_prerusA')
  drgDBMS:open('c_prerus',,,,, 'c_prerusB')
  drgDBMS:open('c_prerus',,,,, 'c_prerusE')
  drgDBMS:open('kalendar',,,,, 'kalendarS')
  drgDBMS:open('listit'  ,,,,, 'listitS'  )

  drgDBMS:open('CNAZPOL4')
  drgDBMS:open('MSPRC_MO')
  drgDBMS:open('OSOBY',,,,,'osobya')
  drgDBMS:open('c_pracdo')
  drgDBMS:open('c_prerva',,,,,'c_prervaa')
  drgDBMS:open('c_pracsm',,,,,'c_pracsma')
  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('kalendar',,,,,'kalendara')
  drgDBMS:open('kalendar',,,,,'kalendard')
  drgDBMS:open('dspohyby',,,,,'dspohybya')

  drgDBMS:open('listit')
  drgDBMS:open('listit',,,,,'listitv')
  drgDBMS:open('c_infsum')

  ** ?? **
  drgDBMS:open( 'dsPohyby',,,,, 'dsPohyby_x')
  drgDBMS:open( 'c_prerus',,,,, 'c_prerus_x')
  drgDBMS:open( 'listit'  ,,,,, 'listit_x'  )

  * TMP soubory *
  drgDBMS:open('mesicw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('tminfsumw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  tminfsumw->( ADSSetOrder( 'TMInfSUMw1'))


  cfiltr := Format("nRokObd= %%", {::rokobdobi})
  kalendara->(ads_setaof(cfiltr), dbGoTop())
  kalendara->( dbGoTop())

  mesicw->( dbAppend())
  do while .not. kalendara->( Eof())
    atrr := 'd' +Str(kalendara->ntydvmespo,1) +Str(kalendara->ndenvtydpo,1)
    mesicw->&atrr := kalendara->nden
    atrr := 'c' + atrr
    mesicw->&atrr := StrZero( kalendara->nden,2)
    if( kalendara->nden = 1, ::firstatrr := atrr, nil)

    if kalendara->ntyden < tmTyden
      tmTyden := 0
    endif

    do case
    case kalendara->ntyden > tmTyden .and. empty(::tyd1)
      ::tyd1  := '   ' +StrZero(kalendara->ntyden, 2) + '. týden'
      tmTyden := kalendara->ntyden
    case kalendara->ntyden > tmTyden .and. empty(::tyd2)
      ::tyd2  := '   ' +StrZero(kalendara->ntyden, 2) + '. týden'
      tmTyden := kalendara->ntyden
    case kalendara->ntyden > tmTyden .and. empty(::tyd3)
      ::tyd3  := '   ' +StrZero(kalendara->ntyden, 2) + '. týden'
      tmTyden := kalendara->ntyden
    case kalendara->ntyden > tmTyden .and. empty(::tyd4)
      ::tyd4  := '   ' +StrZero(kalendara->ntyden, 2) + '. týden'
      tmTyden := kalendara->ntyden
    case kalendara->ntyden > tmTyden .and. empty(::tyd5)
      ::tyd5  := '   ' +StrZero(kalendara->ntyden, 2) + '. týden'
      tmTyden := kalendara->ntyden
    case kalendara->ntyden > tmTyden .and. empty(::tyd6)
      ::tyd6  := '   ' +StrZero(kalendara->ntyden, 2) + '. týden'
      tmTyden := kalendara->ntyden
    endcase

    kalendara->(dbSkip())
  enddo
  mesicw->( dbCommit())
  kalendara->( dbGoTop())

  osobya ->( dbSeek( Osoby->sid,,'ID'))
  c_pracsma ->( dbSeek( Upper( osobya->cTypSmeny),,'C_PRACSM01'))

  c_infsum->( dbEVAL( { || mh_copyFld('c_infsum', 'tminfsumw', .T., .t.) } ))
  tminfsumw->( dbGoTOP())
  *
  *
  cky := StrZero(osoby->ncisOsoby,6) + StrZero(::rok,4) + StrZero(::obdobi,2) +'01'
  dsPohybyA->( ordSetFocus( 'DSPOHY21' )    , ;
               dbsetScope( SCOPE_BOTH, cky ), ;
               dbgoTop()                      )

  cky := StrZero(osoby->ncisOsoby,6) +DtoS( dspohybyA->dDatum)
  listit->( ordSetFocus( 'LISTI23' )     , ;
            dbsetScope( SCOPE_BOTH, cky ), ;
            dbgoTop()                      )

  kalendard->( dbSeek( Dtos(dspohybyA->ddatum),,'KALENDAR01'))
RETURN self


METHOD DOH_dochazkadny_IN:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD DOH_dochazkadny_IN:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers, x
  local  nden, d_Den, oxbp_firstDay
  local  pa_days, tipText, cevent
  local  pb      := { GraMakeRGBColor({255, 255,   0}), GraMakeRGBColor({255, 255, 210}) }
  local  pa      := { GraMakeRGBColor({ 78, 154, 125}), GraMakeRGBColor({157, 206, 188}) }
  *
  local  odrg, groups
  *
  local  sel_Filtrs := {}
  local  sel_Item   := ''
  local  dialogName := upper(drgDialog:formName)
  local  cparent    := if(isNull(drgDialog:parent), '', drgDialog:parent:formName)
  local  ky         := upper(padr(usrName,10)) +upper(padr(cparent,50)) +upper(padr(dialogName,50))
  local  aorder, ocolumn
  *
  * pro vlákno
  local  cfirst_Day, clast_Day


  ::brow     := drgDialog:dialogCtrl:oBrowse
  ::dm       := drgDialog:dataManager             // dataMananager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // dialogForm
  ::msg      := drgDialog:oMessageBar             // messageBar


  ::pa_Days  := pa_Days := {}
  ::nden_Beg := 0

  ::nactive_Clr         := GraMakeRGBColor( {245, 239, 207 } )
  ::oEBro_dsPohybyA     := ::dc:oBrowse[1]
  ::oDBro_listit        := ::dc:oBrowse[2]
  ::oDBro_tmINFsumW     := ::dc:oBrowse[3]

  if asysini->(dbseek( ky +'DSPOHYBYA ',, 'ASYSINI02'))
    if .not. empty( asysini->sel_Filtrs)
      if isArray(sel_Filtrs:= bin2Var( asysini->sel_Filtrs ) )
        if( len(sel_Filtrs) <> 0, sel_item := sel_Filtrs[1,2,1], nil )
      endif
    endif
  endif

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
        oinfo:caption := 462                 // '>'
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

  for x := 1 to 42 step 1
    nden  := mesicW->( fieldGet(x))

    if nden = 0
      pa_days[x,1]:isEdit := .f.
      pa_days[x,1]:oxbp:hide()
    else
      d_Den := str(::rok,4) +strZero(::obdobi,2) +strZero(nden,2)
      kalendar->( dbseek( d_Den,, 'KALENDAR01'))

      pa_days[x,9] := kalendar->ndenPracov

      if isNull(oxbp_firstDay)
        oxbp_firstDay := pa_days[x,1]:oxbp
        ::nden_Beg    := x -1
        ::dsel_Days   := kalendar->dDatum
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


  if empty(::tyd5)
    ::dm:has( 'm->tyd5'):odrg:isEdit := .f.
    ::dm:has( 'm->tyd5'):odrg:oxbp:Hide()
  endif

  if empty(::tyd6)
    ::dm:has( 'm->tyd6'):odrg:isEdit := .f.
    ::dm:has( 'm->tyd6'):odrg:oxbp:Hide()
  endif

  drgDialog:set_uct_ucetsys_inlib()

  ::oxbp_selDay := oxbp_firstDay

  if (aorder := ascan( ::a_popUp, { |x| x[1] = sel_item } )) <> 0
    ::fromContext( aorder, ::a_popUp[aorder], .t.)
    ::quickFilter := aorder
  endif

  ::pb_context:oxbp:setImage( if( ::quickFilter <> 0, ::oico_isQuick, ::oico_noQuick ))
  *
  **
  cfirst_Day    := '01.' +strZero(::obdobi,2) +'.' +str(::rok,4)
  clast_Day     := dtoC( EoM( ctoD(cfirst_Day)))
  ::cflt_listit   := format( "ncisOsoby = %% and ( dvyhotSkut >= '%%' and dvyhotSkut <= '%%') and not lnoexpmzd", { osoby->ncisOsoby, cfirst_Day, clast_Day } )
  ::cflt_dsPohyby := format( "ncisOsoby = %% and nrok = %% and nmesic = %%"                   , { osoby->ncisOsoby, ::rok     , ::obdobi  } )

***  ::modify_pa_Days()
  * úprava pro dspohybyA nsayCRD
  for x := 1 to ::oEBro_dsPohybyA:oxbp:colCount step 1
    ocolumn := ::oEBro_dsPohybyA:oxbp:getColumn(x)
    ocolumn:colorBlock := &( '{|a,b,c| DOH_dochazkadny_in_colorBlock( a, b, c ) }' )
  next

  ::oThread := doh_sumListit():new( ::pa_Days, ::cflt_dsPohyby , ::cflt_listit, ::nden_Beg, self )
  ::oThread:start()

  ::pbtn_denClick(oxbp_firstDay, ::nden_Beg+1 )
  setAppFocus(oxbp_firstDay)
RETURN self


function DOH_dochazkadny_in_colorBlock( a, b, c )
  local useVisualStyle := if( isMemvar( 'visualStyle'), visualStyle, .f. )
  *
  local aCOL_ok := { , }
  local aCOL_er := { GraMakeRGBColor({255,128,128}), }

  if useVisualStyle .and. IsThemeActive(.T.)
    if dspohybyA->nsayCrd = 2
      return { , GraMakeRGBColor( {255, 128, 128 } ) }
    else
      return aCOL_ok
    endif
  else
    return if( dspohybyA->nsayCrd = 2, aCOL_er, aCOL_ok )
  endif
return aCol_ok



METHOD DOH_dochazkadny_IN:preValidGet(drgVar)
/*
  if ::prevalid
    ::dm:set('dspohybya->cCasBeg', '00:00')
    ::dm:set('dspohybya->cCasEnd', '00:00')
    ::prevalid := .f.
  endif
*/
RETURN .t.



METHOD DOH_dochazkadny_IN:posValidGet(drgVar)
  local lOK := .T. , nRecNo
  local xVal := drgVar:get(), cName := drgVar:Name
  local cKey, nPos, nVal, cKy
  local lChanged := drgVar:changed()
  local nEvent := mp1 := mp2 := nil
  local xden, n
  local lprepocet := .f.
  local avars
  local casBeg, casEnd, nCasCel
  local aCAScel

  drgVar:odrg:oxbp:Editable := .t.
  drgVar:odrg:oxbp:setColorBG( GRA_CLR_WHITE)
  drgVar:odrg:oxbp:setColorFG( GRA_CLR_BLACK)

  ::oldGet := ''

  do case
  case cname = 'dspohybya->cKodPrer'
    if lchanged
      if c_prerusB->( dbSeek( Upper( xVal,,'C_PRERUS03')))
        ::dm:set('dspohybya->nKodPrer', c_prerusB->nKodPrer)
        do case
        case ( c_prerusB->nMaskInp = 2 .and. Empty( ::dm:get('dspohybya->cKodPrerE')))
          if c_pracsma->( dbSeek( osoby->ctypsmeny,,'C_PRACSM01'))
            ::dm:set( 'dspohybya->ccasbeg', c_pracsma->cransmezac)
            ::dm:set( 'dspohybya->ccasend', c_pracsma->cransmekon)

//          dspohybyw->ccasbeg := c_pracsm->cransmezac
//          dspohybyw->ccasend := c_pracsm->cransmekon
          endif

        case ( c_prerusB->nMaskInp = 3 .and. Empty( ::dm:get('dspohybya->cKodPrerE')))
          cky := 'DOH' + xVal + '1'
          if c_prervaa->( dbSeek( cky,,'C_PRERVA10'))
            ::dm:set( 'dspohybya->ckodprere', c_prervaa->ckodprere)
            c_prerusE->( dbSeek( 'DOH'+Upper( c_prervaa->ckodprere),,'C_PRERUS05'))
            ::dm:set( 'dspohybya->nkodprere', c_prerusE->nkodprer)
          endif

        case ( c_prerusB->nMaskInp = 4 .and. Empty( ::dm:get('dspohybya->cKodPrerE')))
          cky := 'DOH' + xVal + '1'
          if c_prervaa->( dbSeek( cky,,'C_PRERVA10'))
            ::dm:set( 'dspohybya->ckodprere', c_prervaa->ckodprere)
            c_prerusE->( dbSeek( 'DOH'+Upper( c_prervaa->ckodprere),,'C_PRERUS05'))
            ::dm:set( 'dspohybya->nkodprere', c_prerusE->nkodprer)
          endif
          if c_pracsma->( dbSeek( osoby->ctypsmeny,,'C_PRACSM01'))
            ::dm:set( 'dspohybya->ccasbeg', c_pracsma->cransmezac)
            ::dm:set( 'dspohybya->ccasend', c_pracsma->cransmekon)

//          dspohybyw->ccasbeg := c_pracsm->cransmezac
//          dspohybyw->ccasend := c_pracsm->cransmekon
          endif
        endcase
      endif

      lprepocet := .t.
    endif

  case cname = 'dspohybya->cCasBeg'
    if lchanged
      ::dm:set('dspohybya->nCasBeg', TimeToSec(xVal)/3600)
      lprepocet := .t.
    endif

  case cname = 'dspohybya->cKodPrerE'
    if lchanged
      if c_prerusE->( dbSeek( Upper( xVal,,'C_PRERUS03')))
        ::dm:set('dspohybya->nKodPrerE', c_prerusB->nKodPrer)
//        ::dm:set('dspohybya->cCasEnd', '00:00')
      endif
      lprepocet := .t.
    endif

  case cname = 'dspohybya->cCasEnd'
    if lchanged
      ::dm:set('dspohybya->nCasEnd', TimeToSec(xVal)/3600)
      lprepocet := .t.
    endif

  case cname = 'dspohybya->cCasCel'
    if lchanged
      lprepocet := .t.
    endif

  case cname = 'dspohybya->nCasCel'
    if lchanged
      lprepocet := .t.
    endif
//  case cname = 'dspohybyA->nCasCel'
  endcase

  if lprepocet
    casBeg := ::dm:get('dspohybya->nCasBeg')
    casEnd := ::dm:get('dspohybya->nCasEnd')

    if ( casBeg <> 0 .and. casEnd <> 0) .or.           ;
           ( casBeg <> 0 .and. xVal = "24:00") .or.    ;
              ( casEnd <> 0 .and. xVal = "24:00")

//      nCAScel := DOCH_cas( casBeg, casEnd, ::dm:get('dspohybya->cCasBeg'), ::dm:get('dspohybya->cCasEnd'))
      aCAScel := DOCH_cas( casBeg, casEnd, ::dm:get('dspohybya->cCasBeg'), ::dm:get('dspohybya->cCasEnd'))

//      ::dm:set('dspohybya->nCasCel', nCAScel)
//      ::dm:set('dspohybya->cCasCel', StrTran( StrTran( Str( nCAScel, 5, 2), ' ', '0'), '.', ':') )

      ::dm:set('dspohybya->nCasCel', aCAScel[2])
      ::dm:set('dspohybya->cCasCel', aCAScel[1])

      c_prerusB->( dbSeek( Upper( ::dm:get('dspohybya->cKodPrer'),,'C_PRERUS03')))
      ::dm:set('dspohybya->nCasBegPD', mh_RoundNumb( casBeg, c_prerusB->nKODzaokr))

      c_prerusE->( dbSeek( Upper( ::dm:get('dspohybya->cKodPrerE'),,'C_PRERUS03')))
      ::dm:set('dspohybya->nCasEndPD', mh_RoundNumb( casEnd, c_prerusE->nKODzaokr))
    endif

//       MODIpohyby( lNEW, cTYP, nDEN, cCAS, filedsp)
//    DOCH_sum( osoby->ncisosoby,,, ::dsel_Days )
  endif

RETURN .t.


method DOH_dochazkadny_IN:ebro_afterAppend(o_EBro)

  ::dm:set('dspohybya->cCasBeg', '00:00')
  ::dm:set('dspohybya->cCasEnd', '00:00')

return .t.



method DOH_dochazkadny_IN:ebro_saveEditRow(o_EBro)
  local cKeys
  local xScope   := dspohybyA->( dbScope(SCOPE_BOTH))
  local cordName := dspohybyA->( OrdSetFocus())
  local recNo    := dspohybyA->( recNo())
  *

  if dspohybya->ncisosoby = 0
    mh_copyFld('osobya', 'dspohybya', .f., .t.)
  endif

  dspohybya->nrok      := uctOBDOBI:DOH:NROK
  dspohybya->cobdobi   := uctOBDOBI:DOH:COBDOBI
  dspohybya->nobdobi   := uctOBDOBI:DOH:NOBDOBI
  dspohybya->nmesic    := uctOBDOBI:DOH:NOBDOBI
  dspohybya->nden      := Day( ::dsel_Days)

  dspohybya->nKodPrer  := ::dm:get('dspohybya->nKodPrer')
  dspohybya->nKodPrerE := ::dm:get('dspohybya->nKodPrerE')

  dspohybya->nKodZaokr  := c_prerusB->nKODzaokr
  dspohybya->nKodZaokrE := c_prerusE->nKODzaokr

  dspohybya->nCasBeg   := ::dm:get('dspohybya->nCasBeg')
  dspohybya->nCasEnd   := ::dm:get('dspohybya->nCasEnd')
  dspohybya->nCasBegPD := ::dm:get('dspohybya->nCasBegPD')
  dspohybya->nCasEndPD := ::dm:get('dspohybya->nCasEndPD')

  dspohybya->ddatum    := ::dsel_Days
  dspohybya->czkrdne   := Left( CdoW( ::dsel_Days), 2)
  dspohybya->nNAPpreR  := c_prerusB->nNAPpreR
  dspohybya->lIsManual := .T.

  dspohybya->nNapPrer   := c_prerusB->nNapPrer
  dspohybya->nSaySCR    := c_prerusB->nSaySCR
  dspohybya->nSayCRD    := c_prerusB->nSayCRD
  dspohybya->nSayPRN    := c_prerusB->nSayPRN
  dspohybya->nPritPrac  := c_prerusB->nPritPrac
  dspohybya->cRoObCpPPv := StrZero( dspohybya->nrok, 4) + ;
                            StrZero( dspohybya->nobdobi, 2) + ;
                              StrZero( dspohybya->noscisprac, 5) + ;
                                StrZero( dspohybya->nporpravzt, 3)



//  WRT_zmena( 'dspohybya', .F. )
  cKeys := Upper( dspohybya->cIdOsKarty) + ;
             StrZero( dspohybya->nrok, 4) + ;
              StrZero( dspohybya->nmesic, 2) + ;
               StrZero( dspohybya->nden, 2)


  MODICasy(cKeys, 4, 'dspohybya')                          // IMP_TERM.prg

  // nìco zanuluje tyto položky, zøejmì MODIcasy, ale to je na dlouhé hledání
  dspohybyA->( OrdSetFocus( cordName ), dbgoTo(recNo))

  if dspohybya->( dbRlock())
    dspohybya->nden    := Day( ::dsel_Days)
    dspohybya->ddatum  := ::dsel_Days
    dspohybya->czkrdne := Left( CdoW( ::dsel_Days), 2)

    dspohybya->( dbUnlock())
  endif

  DOCH_sum( dspohybya->nCisOsoby, ::rok, ::obdobi, ::dsel_Days )
  dspohybyA->( OrdSetFocus( cordName ), dbgoTo(recNo))


*  ::dc:oBrowse[1]:oxbp:forceStable()
*  ::dc:oBrowse[1]:oxbp:refreshAll()

  ::dc:oBrowse[3]:oxbp:refreshAll()

*  ::refresh( odrg )
*  o_EBro:oxbp:refreshAll()
return .t.


method DOH_dochazkadny_IN:postDelete()
  local cKeys
  local xScope   := dspohybyA->( dbScope(SCOPE_BOTH))
  local cordName := dspohybyA->( OrdSetFocus())

  cKeys := Upper( dspohybya->cIdOsKarty) + ;
            StrZero( dspohybya->nrok, 4) + ;
             StrZero( dspohybya->nmesic, 2) + ;
              StrZero( dspohybya->nden, 2)

  if dspohybya->( dbRlock())
    dspohybya->( dbDelete())
    dspohybya->( dbUnlock())

* ??     MODICasy(cKeys, 4, 'dspohybya')                          // IMP_TERM.prg
    dspohybyA->( OrdSetFocus( cordName ))

    DOCH_sum( osobya->nCisOsoby, ::rok, ::obdobi, ::dsel_Days )

    dspohybya->( dbGoTop())
    ::dc:oBrowse[1]:oxbp:refreshAll()

    ::oEBro_dsPohybyA:oxbp:up():forceStable()
    ::oEBro_dsPohybyA:oxbp:refreshAll()
    ::dc:oBrowse[3]:oxbp:refreshAll()
  endif

return .t.


method DOH_dochazkadny_IN:drgDialogEnd()
  local  sel_Filtrs := ::sel_Filtrs, a_popUp := ::a_popUp

  if ::quickFilter <> 0
    aadd( sel_Filtrs, { 'M', a_popUp[::quickFilter] } )
  endif

  dspohybyA->(dbclosearea())
  dspohybyS->(dbclosearea())
  kalendarA->(ads_clearAof())

  sel_Filtrs := {}

  ::oThread:setInterval(nil)
  ::oThread:synchronize(0)
  ::oThread := nil

  ::drgUsrClass:destroy()
RETURN self


static class doh_sumListit from Thread
exported:
  var           cflt_dsPohyby,           nsum_casCELcpd
  var  pa_Days, cflt_listit  , nden_Beg, nsum_nhNAopesk
  var  oDialog

  inline method init(pa_Days, cflt_dsPohyby ,cflt_listit, nden_Beg, oDialog)
    ::thread:init()
    ::setInterval(300)

    ::cflt_dsPohyby  := cflt_dsPohyby
    ::nsum_casCELcpd := 0

    ::pa_Days        := pa_Days
    ::cflt_listit    := cflt_listit
    ::nden_Beg       := nden_Beg
    ::nsum_nhNAopesk := 0

    ::oDialog        := oDialog

    ::oDialog:modify_pa_Days(0)
  return self

PROTECTED:
  METHOD  atStart, execute, atEnd
ENDCLASS


method doh_sumListit:atStart()

  drgDBMS:open( 'dsPohyby',,,,, 'dsPohyby_x')
  drgDBMS:open( 'c_prerus',,,,, 'c_prerus_x')
  drgDBMS:open( 'listit'  ,,,,, 'listit_x'  )

  dsPohyby_x->( ads_setaof(::cflt_dsPohyby), dbgoTop() )
  listit_x  ->( ads_setaof(::cflt_listit)  , dbgoTop() )
return self

method doh_sumListit:execute()
  ::oDialog:modify_pa_Days(1)
return self

method doh_sumListit:atEnd()
  dsPohyby_x->( ads_clearAof(), dbcloseArea())
  listit_x  ->( ads_clearAof(), dbcloseArea())
return self