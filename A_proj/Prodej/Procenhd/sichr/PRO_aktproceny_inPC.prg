#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch'
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
//
#include "..\FINANCE\FIN_finance.ch"


#define m_files  { 'c_sklady' , 'c_dph'   , ;
                   'firmy'                , ;
                   'cenzboz'  , 'cenprodc', 'procenho' }


static function PRO_momentProsim( cText)
  Local oDlg, oDraw, oStatic

  oDlg          := XbpDialog():new()
  oDlg:title    := "... MOMENT PROSÍM ..."
  oDlg:create( ,, {400,400}, {300,80} )

  oDraw := oDlg:drawingArea
  oDraw:setColorBG(GraMakeRGBColor( {255 ,255, 200} ))      // GRA_CLR_GREEN)
  oDraw:setColorFG(GRA_CLR_BLACK)

  oStatic := XbpStatic():new(oDraw ,, {1, 20}, {299,20} )
  oStatic:autosize := .T.
  oStatic:type     := XBPSTATIC_TYPE_TEXT
  oStatic:options  := XBPSTATIC_TEXT_CENTER
  oStatic:caption  := PADC( Coalesce( cText, '... PROBÍHÁ ZPRACOVÁNÍ ...'), 75 )
  oStatic:create()
RETURN oDlg


*
** CLASS for PRO_aktproceny_inPC **********************************************
CLASS PRO_aktproceny_inPC FROM drgUsrClass, FIN_finance_IN
exported:
  *
  VAR     uctLikv, hd_file, it_file
  method  init, drgDialogStart, drgDialogEnd, postValidate

  * info
  var     nazTypPoh, celDoklad

  * sel
  method  pro_firmy_sel

  * cmp prodejní ceny
  method  pro_aktproceny_gen

  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    return self

  *
  inline access assign method nazFirmy() var nazFirmy
    firmy->(dbseek( AktProcH->ncisFirmy,,'FIRMY1'))
    return firmy->cnazev

  inline access assign method nazSkladu() var nazSkladu
    c_sklady->(dbseek( upper( AktProcH->ccisSklad),, 'C_SKLAD1' ))
    return c_sklady->cnazSklad

  inline method stableBlock( o_Bro, isAppend )
    local  filter, m_filter  := "ccisSklad = '%%'"
    local          ccisSklad := (::hd_file)->ccissklad

    default isAppend to .f.
    if( isAppend, ccisSklad := '', nil )

    filter := format( m_filter, { ccisSklad })
    cenZboz->( ads_setAof(filter), dbgoTop())
    ::oabro[2]:oxbp:refreshAll()
    return self

/*
  inline method stableBlock( o_Bro, isAppend )
    local  filter, m_filter  := "ncisFirmy = %%"
    local          ncisFirmy := (::hd_file)->ncisFirmy

    default isAppend to .f.
    if( isAppend, ncisFirmy := 0, nil )

    filter := format( m_filter, { ncisFirmy })
    (::it_file)->( ads_setAof(filter), dbgoTop())
    ::oabro[2]:oxbp:refreshAll()
    return self
*/

  inline method ebro_afterAppend(o_eBro)
    if .not. empty(::prednSklad)
      c_sklady->( dbseek( ::prednSklad,, 'C_SKLAD1' ))

      ::dm:set(::hd_file +'->ccisSklad', c_sklady->ccisSklad)
      ::dm:set('M->nazSkladu'          , c_sklady->cnazSklad)
    endif

    ::oabro[1]:recPosFocus := 0
    ::stableBlock( ,.t. )
  return .t.

  **
  *
  inline access assign method procDph() var procDph
    c_dph->(dbseek(cenZboz->nklicDph,,'C_DPH1'))
    return c_dph->nprocDph

  inline access assign method procento() var procento
    return ::get_procSlevy()

  inline access assign method nCeJPrZBZ() var nCeJPrZBZ  // záklCenaBDane
    return cenProdc->ncenapZbo                           // koncCenaBDane
    var nCeJPrKBZ

  inline access assign method nCeJPrZDZ() var nCeJPrZDZ  // záklCenaSDaní
    return cenProdc->ncenapZbo +(cenProdc->ncenapZbo * ::procDph) /100
    var nCeJPrKDZ                                        // koncCenaSDaní
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent =  drgEVENT_DELETE
      if( ::dc:oaBrowse = ::oabro[1], ::posDelete(), nil )
      return .t.
    endcase
  return .f.

hidden:
  VAR     prednSklad
  var     cisFirmy, cisSklad, oabro
  method  cmp_pc

  inline method get_procSlevy()
    local filtr, m_filtr, procento := 0  //100
    *
    local cisFirmy := (::hd_file)->ncisFirmy
    local dDatum   := (::hd_file)->dDatum
    *
    local cisSklad := cenZboz->ccisSklad, sklPol := cenZboz->csklPol, zboziKat := cenZboz->nzboziKat
    *
    local m_cky    := upper(cisSklad) +upper(sklPol)

    filtr := "ntypProCen = 1 .and. "                                  + ;
             "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
             "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %%)"

    m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat})

    procenho->(ads_setAof(m_filtr),dbgoTop())

    if .not. procenho->(eof())
      if .not. empty(dDatum)
        procenho->(dbsetFilter( { || is_datumOk(dDatum) }), dbgoTop())
      else
        procenho->(dbsetFilter( { || is_datumEmty()     }), dbgoTop())
      endif

      do case
      case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
         procento := procenho->nprocento

      case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
         procento := procenho->nprocento

      endcase
    endif

    ::nCeJPrKBZ := cenprodc->ncenaPzbo -(cenprodc->ncenaPzbo * procento/100 )
    ::nCeJPrKDZ := ::nCeJPrKBZ +(::nCeJPrKBZ * ::procDph) /100
    return procento

  inline method posDelete()
    local  cInfo    := 'Promiòte prosím,' +CRLF, paButon, nsel
    local  del_head := .f.
    local  aButton  := {  { '~Nastavení a položky', '~Pouze položky', '~Ne' }, ;
                          { '~Nastavení'                            , '~Ne' }  }

    cInfo := 'Promiòte prosím,'                              +';' + ;
             'požadujete zrušit nastavení prodejního ceníku' +';' + ;
             'pro firmu ... '                                +';' + ;
             '<' +str( (::hd_file)->ncisFirmy) +'_' +left(::nazFirmy,25) +'>'

    do case
    case( .not. (::hd_file)->(eof()) .and. .not. (::it_file)->(eof()) )
      paButton := aButton[1]
    case( .not. (::hd_file)->(eof())                                  )
      paButton := aButton[2]
    endcase

    if isArray(paButton)
      nsel        := alertBox( ::drgDialog:dialog, cInfo                 , ;
                                 paButton, XBPSTATIC_SYSICON_ICONQUESTION, ;
                                'Zvolte možnost ...'                       )
      do case
      case( nsel <> 0 .and. nsel <> len(paButton) )
        del_head := (nsel = 1)
        oMoment  := PRO_momentProsim( '... ruším nastavení dle Vašeho požadavku ...' )

        (::it_file)->( dbgotop(), ;
                       dbeval( { || if( sx_rLock(), dbdelete(), nil ) } ))
        if del_head
          if( (::hd_file)->( sx_rLock()), (::hd_file)->(dbdelete()), nil )
        endif

        oMoment:destroy()

        ::oabro[1]:oxbp:refreshAll()
      endcase
    endif
  return self
ENDCLASS


method PRO_aktproceny_inPC:init(parent)

  ::drgUsrClass:init(parent)
  *
  (::hd_file   := 'AktProcH', ::it_file := 'AktProcI')
  ::prednSklad := sysConfig('Prodej:cPriSklPro')

  * základní soubory
  ::openfiles(m_files)

  cenZboz->( dbsetRelation( 'cenProdc', { || upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol) }, ;
                                            'upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)' , ;
                                            'CENPROD1'                                             ))
return self


METHOD PRO_aktproceny_inPC:drgDialogStart(drgDialog)
  local  obro_2, xbp_obro_2

  ::FIN_finance_in:init(self,'procen')

  ::cisFirmy  := ::dm:get(::hd_file +'->ncisfirmy' , .f.)
  ::cisSklad  := ::dm:get(::hd_file +'->ccisSklad' , .f.)
  ::oabro     := ::dc:oBrowse

      obro_2  := ::oabro[2]
  xbp_obro_2  := ::oabro[2]:oXbp
  xbp_obro_2:itemRbDown := { |mp1,mp2,obj| obro_2:createContext(mp1,mp2,obj) }
RETURN self


method PRO_aktproceny_inPC:drgDialogEnd(drgDialog)
//  (::it_file)->(DbCloseArea())
//  (::hd_file)->(DbCloseArea())
return


method PRO_aktproceny_inPC:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., nin, isReturn

   * F4
  nevent    := LastAppEvent(@mp1,@mp2)
  isReturn := (nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case( name = ::hd_file +'->ncisfirmy' )
    ok := if( empty(value) .or. changed, ::pro_firmy_sel(), .t. )

  case( name = ::hd_file +'->ccisSklad' )
    ::dm:set('M->nazSkladu', c_sklady->cnazSklad)

  endcase
return ok


method PRO_aktproceny_inPC:pro_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

   if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirmy:set(firmy->ncisfirmy)
    ::dm:set('M->nazFirmy', firmy->cnazev)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method PRO_aktproceny_inPC:pro_aktproceny_gen()
  local  filtr   := "ccisSklad = '%%'"
  local  m_filtr := format( filtr, {(::hd_file)->ccisSklad } )
  *
  *
  local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread
  local     xbp_therm := ::msg:msgStatus
  local  cInfo, nsel

  if (::hd_file)->(eof())
    return .t.
  endif

  cInfo := 'Požadujete zpracovat '                  +CRLF + ;
           'aktuální prodejní ceník pro firmu ... ' +CRLF + ;
           str((::hd_file)->ncisFirmy,5) +'_' +left( ::nazFirmy,25)

  nsel  := confirmBox( , cInfo                                  , ;
                         'Vytvoøit aktuální prodejní ceník ...' , ;
                          XBPMB_YESNO                           , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

  if nsel = XBPMB_RET_NO
    return .t.
  endif
  *
  ** nachystáme si èervíka v samostatném vláknì
  for i := 1 to 4 step 1
    aBitMaps[3,i] := XbpBitmap():new():create()
    aBitMaps[3,i]:load( ,nPHASe )
    aBitMaps[3,i]:TransparentClr := aBitMaps[3,i]:GetDefaultBGColor()
    nPHASe++
  next

  oThread := Thread():new()
  oThread:setInterval( 8 )
  oThread:start( "PRO_aktproceny_inPC_animate", xbp_therm, aBitMaps)

  (::it_file)->( dbgotop(), ;
                 dbeval( { || if( sx_rLock(), dbdelete(), nil ) } ))

  ::oabro[2]:oxbp:goTop():refreshAll()

  cenZboz->(ads_setAof(m_filtr),dbgoTop())

  do while .not. cenZboz->(eof())
    c_dph->(dbseek(cenZboz->nklicDph,,'C_DPH1'))

    (::it_file)->(dbappend())
    (::it_file)->ncisFirmy  := (::hd_file)->ncisFirmy
    (::it_file)->ccisSklad  := cenZboz->ccisSklad
    (::it_file)->csklPol    := cenZboz->csklPol
    (::it_file)->nzboziKat  := cenZboz->nzboziKat
    (::it_file)->cnazZbo    := cenZboz->cnazZbo
    (::it_file)->czkratJedn := cenZboz->czkratJedn
    (::it_file)->nprocDph   := c_dph->nprocDph

    ::cmp_pc()

    cenZboz->(dbskip())
  enddo

  if (::hd_file)->(dbRlock())
    (::hd_file)->ddatzprac := Date()
    (::hd_file)->(dbUnlock())
  endif
  cenZboz->(ads_clearAof())

  * vrátíme to
  oThread:setInterval( NIL )
  oThread:synchronize( 0 )
  oThread := nil

  xbp_therm:setCaption('')

  (::it_file)->(dbgoTop())

  ::oabro[2]:oxbp:refreshAll()
  ::oabro[1]:oxbp:refreshCurrent()
return .t.


procedure PRO_aktproceny_inPC_animate(xbp_therm,aBitMaps)
  local  aRect, oPS, nXD, nYD

  xbp_therm:setCaption('')

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  nXD     := abitMaps[2]
  nYD     := 0

  aBitMaps[1] ++
  if aBitMaps[1] > len(aBitMaps[3])
    aBitMaps[1] := 1
  endif

  aBitMaps[ 3, aBitMaps[1] ]:draw( oPS, {nXD,nYD} )
  xbp_therm:unlockPS( oPS )

  if abitMaps[2] +10 > aRect[1]
    abitMaps[2] := 0
  else
    abitMaps[2] := abitMaps[2] +10
  endif
return



method PRO_aktproceny_inPC:cmp_pc()
  local filtr, m_filtr, procento := 0  //100
  *
  local cisFirmy := (::hd_file)->ncisFirmy
  local dDatum   := (::hd_file)->dDatum
  *
  local cisSklad := cenZboz->ccisSklad, sklPol := cenZboz->csklPol, zboziKat := cenZboz->nzboziKat
  *
  local m_cky    := upper(cisSklad) +upper(sklPol)

  filtr := "ntypProCen = 1 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %%)"

  m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat})

  procenho->(ads_setAof(m_filtr),dbgoTop())
  cenprodc->(dbseek( m_cky,,'CENPROD1'))

  (::it_file)->ncenaPzbo := cenprodc->ncenaPzbo
  (::it_file)->nCeJPrZBZ := cenprodc->ncenaPzbo
  (::it_file)->nCeJPrKBZ := cenprodc->ncenaPzbo
  (::it_file)->nCeJPrZDZ := (::it_file)->nCeJPrZBZ +((::it_file)->nCeJPrZBZ *(::it_file)->nprocDph) /100
  (::it_file)->nCeJPrKDZ := (::it_file)->nCeJPrKBZ +((::it_file)->nCeJPrKBZ *(::it_file)->nprocDph) /100


  if .not. procenho->(eof())
      if .not. empty(dDatum)
        procenho->(dbsetFilter( { || is_datumOk(dDatum) }))
      else
        procenho->(dbsetFilter( { || is_datumEmty()     }))
      endif

    do case
    case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
       procento := procenho->nprocento

    case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
       procento := procenho->nprocento

    endcase

    (::it_file)->nprocento := procento
    (::it_file)->nCeJPrKBZ := cenprodc->ncenaPzbo -(cenprodc->ncenaPzbo * procento/100 )
    (::it_file)->nCeJPrKDZ := (::it_file)->nCeJPrKBZ +((::it_file)->nCeJPrKBZ *(::it_file)->nprocDph) /100
  endif
return


/*
method PRO_aktproceny_in:cmp_pc()
  local filtr, m_filtr := '', procento := 0  //100
  *
  local cisFirmy := (::hd_file)->ncisFirmy
  local dDatum   := (::hd_file)->dDatum
  *
  local cisSklad := cenZboz->ccisSklad, sklPol := cenZboz->csklPol, zboziKat := cenZboz->nzboziKat
  *
  local m_cky    := upper(cisSklad) +upper(sklPol)


  cky_1  := '00001' +strZero( cisFir my,5) +upper( cisSklad) +upper( sklPol)
  cky_2  := '00001' +strZero(        0,5) +upper( cisSklad) +upper( sklPol)
  cky_3  := '00001' +strZero( cisFirmy,5) +strZero( zboziKat,3)
  cky_4  := '00001' +strZero(        0,5) +strZero( zboziKat,3)

  do case
  case proCenho->( dbseek( cKy_1,, 'PROCENHO04' ))
    m_filtr := "ntypProCen = 1 .and. "                    + ;
               "ncisFirmy = " +str(cisFirmy) +  " .and. " + ;
               "ccisSklad = '" +cisSklad     + "' .and. " + ;
               "csklPol = '"   +sklPol       + "'"

  case proCenho->( dbseek( cKy_2,, 'PROCENHO04' ))
    m_filtr := "ntypProCen = 1 .and. "                   + ;
               "ncisFirmy = 0 .and. "                    + ;
               "ccisSklad = '" +cisSklad      + "' .and. " + ;
               "csklPol = '"   +sklPol        + "'"

  case proCenho->( dbseek( cKy_3,, 'PROCENHO11' ))
    m_filtr := "ntypProCen = 1 .and. "   + ;
               "ncisFirmy = " +str(cisFirmy) + " .and. nzboziKat = " +str(zboziKat)

  case proCenho->( dbseek( cKy_4,, 'PROCENHO11' ))
    m_filtr := "ntypProCen = 1 .and. "   + ;
               "ncisFirmy = 0 .and. nzboziKat = " +str(zboziKat)
  endcase

  cenprodc->(dbseek( m_cky,,'CENPROD1'))

  (::it_file)->ncenaPzbo := cenprodc->ncenaPzbo
  (::it_file)->nCeJPrZBZ := cenprodc->ncenaPzbo
  (::it_file)->nCeJPrKBZ := cenprodc->ncenaPzbo
  (::it_file)->nCeJPrZDZ := (::it_file)->nCeJPrZBZ +((::it_file)->nCeJPrZBZ *(::it_file)->nprocDph) /100
  (::it_file)->nCeJPrKDZ := (::it_file)->nCeJPrKBZ +((::it_file)->nCeJPrKBZ *(::it_file)->nprocDph) /100


  if .not. empty( m_filtr)
    procenho->(ads_setAof(m_filtr),dbgoTop())

    if .not. procenho->(eof())
      if .not. empty(dDatum)
        procenho->(dbsetFilter( { || is_datumOk(dDatum) }))
      else
        procenho->(dbsetFilter( { || is_datumEmty()     }))
      endif

      do case
      case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
         procento := procenho->nprocento

      case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
         procento := procenho->nprocento

      endcase

      (::it_file)->nprocento := procento
      (::it_file)->nCeJPrKBZ := cenprodc->ncenaPzbo -(cenprodc->ncenaPzbo * procento/100 )
      (::it_file)->nCeJPrKDZ := (::it_file)->nCeJPrKBZ +((::it_file)->nCeJPrKBZ *(::it_file)->nprocDph) /100
    endif

    procenho->(ads_clearAof())
  endif
return

*/

static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok


static function is_datumEmty()
  local  ok :=  empty(procenho->dplatnyOD)
return ok
**
*