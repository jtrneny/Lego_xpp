#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "Gra.ch"
//
#include "..\Asystem++\Asystem++.ch"


#define d_popup    'Kompletní ceník zboží            ,' + ;
                   'Zboží k objednání                ,' + ;
                   'Zboží k dodavateli               ,' + ;
                   'Zboží k dodavateli a k objednámí ,' + ;
                   'Zboží pod minStavem              ,' + ;
                   'Zboží pod minStavem  k dodaveteli,' + ;
                   'Zboží k objedání k hlDodavateli   '



*   CENÍK ZBOŽÍ pro OBJEDNÁVKY PØIJATÉ
**  CLASS for PRO_objhead_cen_sel *********************************************
CLASS PRO_objhead_cen_sel FROM drgUsrClass
exported:
  method  init, getForm, drgDialogStart, drgDialogEnd
  method  itemMarked, eventHandled
  method  createContext, fromContext
  method  postValidate
  *
  var     m_udcp
  var     smallBasket_ncenaZakl , smallBasket_nhodnSlev, smallBasket_nprocSlev
  var     smallBasket_ncenaDlOdb, smallBasket_nmnozObOdb

  * cenzboz - ceníková/neceníková položka
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method lastProdCena() var lastProdCena
    local cky := strZero(objheadw->ncisFirmy,  5) + ;
                 upper(cenzboz->ccisSklad       ) + ;
                 upper(cenzboz->csklPol         )

    objit_lpc ->(dbseek( cky,, 'OBJITE26'))
  return objit_lpc->ncenaDLODB

  inline access assign method lasthodnSlev() var lasthodnSlev
    local cky := strZero(objheadw->ncisFirmy,  5) + ;
                 upper(cenzboz->ccisSklad       ) + ;
                 upper(cenzboz->csklPol         )

    objit_lpc ->(dbseek( cky,, 'OBJITE26'))
  return objit_lpc->nhodnSlev

  inline access assign method lastprocSlev() var lastprocSlev
    local cky := strZero(objheadw->ncisFirmy,  5) + ;
                 upper(cenzboz->ccisSklad       ) + ;
                 upper(cenzboz->csklPol         )

    objit_lpc ->(dbseek( cky,, 'OBJITE26'))
  return objit_lpc->nprocSlev

  *
  ** smallBasket
  inline method smallBasket()
    local  state_y
    local  oIcon := XbpIcon():new():create()

    if isObject(::pb_smallBasket)

      ::smallBasket_State := .not. ::smallBasket_State
      state_y := if( ::smallBasket_State, DRG_ICON_APPEND2, gDRG_ICON_APPEND2 )
      oicon:load( NIL, state_y)

      ::pb_smallBasket:oxbp:setImage( oicon )
      ::enable_or_disable_Gets()
      ::set_focus_dBro()
    endif
  return .t.

hidden:
  method  relFiltrs
  var     dm, df, in_file, drgVar, drgPush, popState
  var     nrok

  method  procentoSlevy
  var     hd_file, it_file

  *       cenZboz/nabVysit  objVysitW
  var     o_dBro          , o_dBro_basketW

  var     o_parent_udcp , o_parent_dm, o_parent_dBro
  var     pb_smallBasket, smallBasket_State, smallBasket_Gets

  *
  ** smallBasket
  inline method enable_or_disable_Gets()
    local pa := ::smallBasket_Gets, x, odrg

    if ::in_file = 'cenzboz'
      for x := 1 to len( pa) step 1
        odrg        := ::dm:has(pa[x]):odrg
        odrg:IsEdit := ::smallBasket_State
        if( ::smallBasket_State, odrg:oxbp:enable(), odrg:oxbp:disable() )
      next
    endif
  return self

  inline method set_focus_dBro()
    local  o_dBro  := ::o_dBro
    local  members := ::df:aMembers, pos

    pos := ascan(members,{|X| (x = o_dBro )})
    ::df:olastdrg   := ::o_dBro
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()

    setAppFocus( ::o_dBro:oxbp )
    postAppEvent( xbeBRW_ItemMarked,,, ::o_dBro:oxbp)
  return self


  inline method save_to_basketW()
    local file_iv := 'cenZboz'

    ::o_parent_udcp:takeValue( file_iv, 2)
    ::o_parent_udcp:copyfldto_w(   file_iv, ::it_file, .t.)
    ::o_parent_udcp:copyfldto_w( ::hd_file, ::it_file     )

    (::it_file)->ncislPolOb := ::o_parent_udcp:ordItem() +1

    ::itSave_to_basketW( ::o_parent_udcp:dm )

    * výpoèet nKcBdObj / nkcZdObj
    c_dph  ->( dbseek( (::it_file)->nklicDph,,'C_DPH1'))

    (::it_file)->ncenaZakl  := ::dm:get( 'M->smallBasket_ncenaZakl'  )
    (::it_file)->nhodnSlev  := ::dm:get( 'M->smallBasket_nhodnSlev'  )
    (::it_file)->nprocSlev  := ::dm:get( 'M->smallBasket_nprocSlev'  )
    (::it_file)->ncenaDlOdb := ::dm:get( 'M->smallBasket_ncenaDlOdb' )
    (::it_file)->nmnozObOdb := ::dm:get( 'M->smallBasket_nmnozObOdb' )

    (::it_file)->nkcsBdObj  := (::it_file)->nmnozObOdb  * (::it_file)->ncenaDlOdb
    (::it_file)->nkcsZdObj  := (::it_file)->nkcsBdObj    + int((::it_file)->nkcsBdObj * c_dph->nprocDph/100)

    (::it_file)->ncelkSlev  := ((::it_file)->nhodnSlev  * (::it_file)->nmnozObOdb)
    (::it_file)->nhmotnost  := ((::it_file)->nmnozObDod * (::it_file)->nhmotnostJ)
    (::it_file)->nobjem     := ((::it_file)->nmnozObDod * (::it_file)->nobjemJ   )

    (::it_file)->_nbasket   := 1
    (::it_file)->(dbcommit())

    pro_objhdead_cmp()
    ::o_dBro_basketW:oxbp:goBottom():refreshall()

    ::set_focus_dBro()
  return self

  inline method itSave_to_basketW( dm )
    local  x, ok := .t., vars := dm:vars, drgVar, ok_it

    for x := 1 to dm:vars:size() step 1
      drgVar := dm:vars:getNth(x)

      * musí to být jen objvyshdw, objvysitw
      ok_it := ( at( 'objheadw', lower(drgVar:name)) <> 0 .or. ;
                 at( 'objitemw', lower(drgVar:name)) <> 0      )

      if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok_it
        if (eval(drgvar:block) <> drgVar:value)
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next
  return self
ENDCLASS


method PRO_objhead_cen_sel:eventHandled(nEvent, mp1, mp2, oXbp)
  local  oDialog, nExit

  do case
   case nEvent = drgEVENT_EDIT .and. ::smallBasket_State
    ::df:setNextFocus('M->smallBasket_nmnozObOdb',,.t.)
    return .t.

  case nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    cenzboz->(ads_clearAof())
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

  case nEvent = drgEVENT_APPEND
    DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
    oXbp:refreshAll()

  case nEvent = drgEVENT_FORMDRAWN
     Return .T.

  case nEvent = xbeP_Keyboard
    do case
    case mp1 = xbeK_ESC
      if oXbp:className() = 'xbpGet'
        ::set_focus_dBro()
      else
        PostAppEvent(xbeP_Close,,, oXbp)
        ::o_parent_dm:refreshAndSetEmpty( 'objitemW' )
      endif

    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.


method PRO_objhead_cen_sel:init(parent)
  local  odrg := parent:parent:lastXbpInFocus:cargo
  *
  local  items

  ::drgUsrClass:init(parent)

  ::o_parent_udcp := parent:parent:udcp
  ::o_parent_dm   := parent:parent:dataManager
  ::o_parent_dBro := parent:parent:odBrowse[1]

  ::m_udcp   := parent:parent:udcp
  ::drgVar   := setAppFocus():cargo
  ::popState := 1
  ::nrok     := uctObdobi:SKL:nROK

  drgDBMS:open('objitem',,,,,'objit_lpc')
  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('CENZB_ps')
  drgDBMS:open('C_SKLADY')

  * pro smallBasket
  ::hd_file               := ::o_parent_udcp:hd_file
  ::it_file               := ::o_parent_udcp:it_file
  ::smallBasket_Gets       := { 'M->smallBasket_ncenaZakl', 'M->smallBasket_nhodnSlev' , ;
                                'M->smallBasket_nprocSlev', 'M->smallBasket_nmnozObOdb'  }
  ::smallBasket_ncenaZakl  := 0.00
  ::smallBasket_nhodnSlev  := 0.00
  ::smallBasket_nprocSlev  := 0.00
  ::smallBasket_ncenaDlOdb := 0.00
  ::smallBasket_nmnozObOdb := 0.00

  drgDBMS:open('C_DPH'   )
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))

  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))

  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))
  *
  items      := Lower(drgParseSecond(odrg:name,'>'))
  ::in_file  := if( items = 'csklpol', 'cenzboz', 'nabvysit')
//  ::popState := 1
//  ::parent   := parent:parent:udcp
return self


method PRO_objhead_cen_sel:drgDialogStart(drgDialog)
  local  aMembers  := drgDialog:oForm:aMembers
  local  showDlg  := .T., file_iv, varSym, tagNo, pa
  *
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize
  local  pa_grous, nin, acolors := MIS_COLORS
  *
  **
  ::dm     := drgDialog:dataManager
  ::df     := drgDialog:oForm                     // form
  ::o_dBro := drgDialog:odBrowse[1]
  *
  for x := 1 TO LEN(aMembers) step 1
    if aMembers[x]:ClassName() = 'drgPushButton'
      ::drgPush := aMembers[x]
*      if( aMembers[x]:event = 'createContext', ::pb_context     := aMembers[x], nil )
      if( aMembers[x]:event = 'smallBasket'  , ::pb_smallBasket := aMembers[x], nil )
    endif

    if aMembers[x]:ClassName() = 'drgText' .and. .not.Empty(aMembers[x]:groups)
      pa_groups := ListAsArray(aMembers[x]:groups)
      nin       := ascan(pa_groups,'SETFONT')

      aMembers[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
           aMembers[x]:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        aMembers[x]:oXbp:setColorFG(GRA_CLR_BLACK)
      endif
    endif
  next

*  ::drgPush:oXbp:setFont(drgPP:getFont(5))
*  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
  *
  ** smallBasket
  ::o_dBro_basketW    := drgDialog:odBrowse[ if( ::in_file = 'cenzboz', 2, 1 )]
  ::smallBasket_State := .f.
  ::enable_or_disable_Gets()
return self


method PRO_objhead_cen_sel:drgDialogEnd(drgDialog)

  if ::in_file = 'cenzboz'
    if ::smallBasket_State .and. .not.(::it_file)->( eof())
      postAppEvent(xbeP_Keyboard,xbeK_ESC,,::o_parent_dm:drgDialog:lastXbpInFocus )
    endif

    objitemW->( ordSetFocus( 'OBJITEM_1' ))
    ::o_parent_dBro:oxbp:goBottom():refreshall()
  endif
return self


method PRO_objhead_cen_sel:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil
  local  n_hodnSlev

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case( name = 'M->smallBasket_ncenaZakl' .and. changed )
    ::smallBasket_ncenaZakl := value
    ::smallBasket_nhodnSlev := (( value * ::smallBasket_nprocSlev) / 100 )
    ::dm:set( 'M->smallBasket_nhodnSlev' , ::smallBasket_nhodnSlev )

  case(name = 'M->smallBasket_nhodnSlev' .and. changed)
    ::smallBasket_nhodnSlev := value

    if ( ::smallBasket_nprocSlev := (( value / ::smallBasket_ncenaZakl ) * 100 )) >99.9
      ::smallBasket_nhodnSlev := 0.00
      ::smallBasket_nprocSlev := 0.00
    endif
    ::dm:set( 'M->smallBasket_nhodnSlev' , ::smallBasket_nhodnSlev )
    ::dm:set( 'M->smallBasket_nprocSlev' , ::smallBasket_nprocSlev )

  case(name = 'M->smallBasket_nprocSlev' .and. changed)
    ::smallBasket_nprocSlev := value
    ::smallBasket_nhodnSlev := (( ::smallBasket_ncenaZakl * ::smallBasket_nprocSlev ) / 100 )
    ::dm:set( 'M->smallBasket_nhodnSlev' , ::smallBasket_nhodnSlev )

  case( name = 'M->smallBasket_nmnozObOdb' )
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN )
      if( value <> 0, ::save_to_basketW(), ::set_focus_dBro())
    endif
  endCase

  * výpocet ncenaDlOdb
  ::smallBasket_ncenaDlOdb := round( ::smallBasket_ncenaZakl - ;
                                   ( ::smallBasket_ncenaZakl * ::smallBasket_nprocSlev ) / 100, 2 )
  ::dm:set( 'M->smallBasket_ncenaDlOdb', ::smallBasket_ncenaDlOdb )
return .t.


method PRO_objhead_cen_sel:itemMarked(aRowCol,unil,oXbp)
  local  m_file
  local  n_cenaZakl, n_hodnSlev, n_procSlev, n_cenaDlOdb

  if isObject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    if m_file = 'cenzboz'
      n_cenaZakl  := cenZboz->ncenaPZbo
      n_procSlev  := ::procentoSlevy()
      n_hodnSlev  := ( n_cenaZakl * n_procSlev) / 100
      n_cenaDlOdb := round( n_cenaZakl -( n_cenaZakl * n_procSlev)/100,2 )

     ::smallBasket_ncenaZakl  := n_cenaZakl
     ::smallBasket_nhodnSlev  := n_hodnSlev
     ::smallBasket_nprocSlev  := n_procSlev
     ::smallBasket_ncenaDlOdb := n_cenaDlOdb

     ::dm:set( 'M->smallBasket_ncenaZakl' , n_cenaZakl  )
     ::dm:set( 'M->smallBasket_nhodnSlev' , n_hodnSlev  )
     ::dm:set( 'M->smallBasket_nprocSlev' , n_procSlev  )
     ::dm:set( 'M->smallBasket_ncenaDlOdb', n_cenaDlodb )

*       smallBasket_nmnozObOdb
    endif
  endif
return self

*
**
method pro_objhead_cen_sel:procentoSlevy()
  local filtr, m_filtr, nProcento := 0
  *
  local  cisFirmy := objheadW->ncisFirmy, zkrTypUhr := objheadW->czkrtypuhr, datObj   := objheadW->ddatObj
  local  cisSklad := cenZboz->ccisSklad , sklPol    := cenZboz->csklPOl    , zboziKat := cenZboz->nzboziKat

  local m_cky    := upper(cisSklad) +upper(sklPol)

  filtr := "ntypProCen = 1 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %% .or. czkrTypUhr = '%%')"

  m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat, zkrTypUhr})

  proCenho->(ads_setAof(m_filtr),dbgoTop())
  cenProdc->(dbseek( m_cky,,'CENPROD1'))


  if .not. procenho->(eof())
    procenho->(dbsetFilter( { || is_datumOk(datObj) }))

    do case
    case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
      nProcento := procenho->nprocento
    case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
      nProcento := procenho->nprocento
    endcase
  endif
return nProcento

static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok
**
*

method PRO_objhead_cen_sel:createContext()
  LOCAL cSubMenu, oPopup, aPos, aSize, x, pa, nIn
  *
  local popUp := d_popup

  pA       := ListAsArray(popup)
  cSubMenu := drgNLS:msg(popUp)
  oPopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 TO LEN(pA) step 1
    oPopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  oPopup:disableItem(::popState)

  aPos    := ::drgPush:oXbp:currentPos()
  oPopup:popup(::drgDialog:dialog, aPos)
return self


method PRO_objhead_cen_sel:fromContext(aOrder, nMENU)
  local  obro := ::drgDialog:odbrowse[1]
  *
  local  crels := 'strZero(objvyshdw->ncisFirmy) +upper(cenzboz->ccisSklad) +upper(cenZboz ->csklPol)'
  local  filter, ex_filtr := "(cpolcen = 'C' .or. cpolCen = 'E')", ex_cond

  ::popState := aOrder
  ::drgPush:oxbp:setCaption(nMENU)

  do case
  case(aOrder = 1)                  ;  cenzboz->(ads_clearAof(), dbgoTop())
  case(aOrder = 2)                  ;  filter = ex_filtr + " .and. nmnozKZbo <> 0"
  case(aOrder = 3)
    filter  := ex_filtr
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 4)
    filter  := ex_filtr +" .and. nmnozKZbo <> 0"
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 5)
    filter := ex_filtr +" .and. nmnozSZbo < nminZbo"

  case(aOrder = 6)
    filter  := ex_filtr +" .and. nmnozSZbo < nminZbo"
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 7)
    filter  := ex_filtr +" .and. nmnozKZbo > 0"
    ex_cond := 'dodzboz->lhlavniDod'
  endcase

  if .not. isnull(filter)
    cenzboz->(ads_setAof(filter), dbgoTop())
    if .not. isnull(ex_cond)
      dodzboz->(AdsSetOrder('DODAV6'))
      cenzboz->(dbsetRelation('dodzboz', COMPILE(crels), crels ), dbskip(0))
      ::relFiltrs('cenzboz',ex_cond)
    endif
  endif
  obro:oxbp:refreshAll()
return self


method PRO_objhead_cen_sel:relfiltrs(mfile, ex_cond)
  local  pa := {}, filter := ''


  do while .not. (mfile)->(eof())
    if( DBGetVal(ex_cond), aadd(pa,(mfile)->(recno())), nil)

    (mfile)->(dbskip())
  enddo

  (mfile)->(ads_clearaof(), dbgotop())

  aeval(pa,{|x| filter += 'recno() = ' +str(x) +' .or. '})
  filter := left(filter, len(filter)-6)
  if( empty(filter), filter := 'recno() = 0', nil)

  (mfile)->(dbclearRelation(), ads_setaof(filter), dbgotop())
return self


method PRO_objhead_cen_sel:getForm()
  local  odrg, drgFC

   drgFC := drgFormContainer():new()

   do case
   case ::in_file = 'cenzboz'
     * Pøevzít z Ceníku zboží         ->cenzboz

     DRGFORM INTO drgFC SIZE 110,23 DTYPE '10' TITLE 'Ceník zboží - výbìr' ;
                                               POST 'postValidate'         ;
                                               GUILOOK 'Action:y,Message:n,IconBar:y:drgBrowseIconBar,Menu:n'

       DRGACTION INTO drgFC CAPTION 'info ~Ceník' EVENT 'SKL_CENZBOZ_INFO' ;
                                                  TIPTEXT 'Informaèní karta skladové položky'

       DRGSTATIC INTO drgFC FPOS 0,0 SIZE 110,10.8 STYPE 1 RESIZE 'yy'
         DRGDBROWSE INTO drgFC FPOS -.5,-.2 FILE 'CENZBOZ'           ;
           FIELDS 'CCISSKLAD,'                                     + ;
                  'CSKLPOL,'                                       + ;
                  'CNAZZBO::30,'                                   + ;
                  'nZboziKat:Kat.zboží,'                           + ;
                  'M->m_udcp|wds_cenzboz_kDis:množKDisp:13,'       + ;
                  'nMnozSZBO,'                                     + ;
                  'cZkratJedn:MJ,'                                 + ;
                  'nCenaSZBO,'                                     + ;
                  'nCenaPZBO,'                                     + ;
                  'nCenaNZBO,'                                     + ;
                  'M->lastProdCena:Posl.prodejní cena:13,'         + ;
                  'M->lasthodnSlev:sleva:13,'                      + ;
                  'M->lastprocSlev:% slevy:10'                       ;
           CURSORMODE 3 PP 7 INDEXORD 1 POPUPMENU 'yy' RESIZE 'yy' SCROLL 'yy' ITEMMARKED 'itemMarked'
       DRGEND INTO drgFC

*      košík
       DRGSTATIC INTO drgFC FPOS .5,11 SIZE 109,2.3 STYPE 12 RESIZE 'yn'
         odrg:ctype := 2

         DRGPUSHBUTTON INTO drgFC CAPTION '2' POS 103,1.3 SIZE 6,2.3 ;
                                  EVENT 'smallBasket' ICON1 208 ICON2 108 ATYPE 1


         DRGTEXT INTO drgFC CAPTION 'Ceny v'              CPOS  1, 1 CLEN  6
         DRGTEXT INTO drgFC NAME     OBJHEADw->czkratmeny CPOS  8, 1 CLEN  4 FONT 5

         DRGTEXT INTO drgFC CAPTION 'cenaZákladní'        CPOS 17, 0 CLEN 10
         DRGGET  M->smallBasket_ncenaZakl INTO drgFC      FPOS 15, 1 FLEN 13 PICTURE '@N 9999999.99'


         DRGTEXT INTO drgFC CAPTION 'slevaZákladní'       CPOS 35, 0 CLEN 11
         DRGGET  M->smallBasket_nhodnSlev INTO drgFC      FPOS 33, 1 FLEN 13 PICTURE '@N 99999999.9999'

         DRGTEXT INTO drgFC CAPTION '['                   CPOS 48, 0 CLEN 2 CTYPE 2
           odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
         DRGTEXT objitemW->nprocSlFAO INTO drgFC          CPOS 49, 0 CLEN 5 PICTURE '@N 99.9' CTYPE 2

         DRGTEXT INTO drgFC CAPTION '+'                   CPOS 52.3, 0 CLEN 3 CTYPE 2
           odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
         DRGTEXT objitemW->nprocSlHOT INTO drgFC          CPOS 55, 0 CLEN 4 PICTURE '@N 99.9' CTYPE 2

         DRGTEXT INTO drgFC CAPTION '+'                   CPOS 57.3, 0 CLEN 3 CTYPE 2
           odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
         DRGTEXT objitemW->nprocSlMNO INTO drgFC          CPOS 60, 0 CLEN 4 PICTURE '@N 99.9' CTYPE 2
         DRGTEXT INTO drgFC CAPTION ']'                   CPOS 63, 0 CLEN 2 CTYPE 2
           odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'

         DRGGET M->smallBasket_nprocSlev INTO drgFC       FPOS 52, 1 FLEN 9 PICTURE '@N 999.9999'

         DRGTEXT INTO drgFC CAPTION 'prodejní cena'       CPOS 67, 0 CLEN 11 CTYPE 2
         DRGTEXT M->smallBasket_ncenaDlOdb INTO drgFC     CPOS 66, 1 CLEN 13 BGND 13 CTYPE 2

         DRGTEXT INTO drgFC CAPTION 'objednáno'           CPOS 84, 0 CLEN 10 CTYPE 2
         DRGGET  M->smallBasket_nmnozObOdb INTO drgFC     FPOS 82, 1 FLEN 13 PICTURE '@N 9999999.99'
         DRGTEXT cenZboz->czkratJedn  INTO drgFC          CPOS 97, 1 CLEN  4 FONT 5
       DRGEND INTO drgFC

*      info
       DRGTABPAGE INTO drgFC CAPTION 'Info' FPOS .5,13.6 SIZE 109,9 OFFSET 1,86 PRE 'tabSelect' TABHEIGHT .8
       *   1.ø.
         DRGTEXT INTO drgFC CAPTION 'Sklad. položka'   CPOS  1, 0.2 CLEN 15
         DRGTEXT INTO drgFC NAME CENZBOZ->cSklPol      CPOS  1, 1.2 CLEN 20 BGND 13 PP 2 FONT 5
         DRGTEXT INTO drgFC CAPTION 'Název zboží 2'    CPOS 22, 0.2 CLEN 30
         DRGTEXT INTO drgFC NAME CENZBOZ->cNazZbo2     CPOS 22, 1.2 CLEN 35 BGND 13 PP 2
         DRGTEXT INTO drgFC CAPTION 'Kateg.'           CPOS 58, 0.2 CLEN  6
         DRGTEXT INTO drgFC NAME CENZBOZ->nZboziKat    CPOS 58, 1.2 CLEN  6 BGND 13 PP 2
         DRGTEXT INTO drgFC NAME C_KatZbo->cNazevKat   CPOS 64, 1.2 CLEN 18 BGND 13 PP 2
         DRGTEXT INTO drgFC CAPTION 'Úè.sk.'           CPOS 83, 0.2 CLEN  6
         DRGTEXT INTO drgFC NAME CENZBOZ->nUcetSkup    CPOS 83, 1.2 CLEN  5 BGND 13 PP 2
         DRGTEXT INTO drgFC NAME C_UctSkp->CNAZUCTSK   CPOS 88, 1.2 CLEN 18 BGND 13 PP 2

       * 2.ø.
         DRGTEXT INTO drgFC CAPTION 'Typ ceny'         CPOS  1, 2.4 CLEN  8
         DRGTEXT INTO drgFC NAME CENZBOZ->cTypSklCen   CPOS  1, 3.4 CLEN  8 BGND 13 PP 2
         DRGTEXT INTO drgFC CAPTION 'Skl. cena'        CPOS 11, 2.4 CLEN 13
         DRGTEXT INTO drgFC NAME CENZBOZ->nCenaSZBO    CPOS 11, 3.4 CLEN 13 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC NAME CENZBOZ->cZkratMeny   CPOS 24, 3.4 CLEN  5 BGND 13 PP 2
         DRGTEXT INTO drgFC CAPTION 'Množ. na skladì'  CPOS 31, 2.4 CLEN 13
         DRGTEXT INTO drgFC NAME CENZBOZ->nMnozSZBO    CPOS 31, 3.4 CLEN 13 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC NAME CENZBOZ->cZkratJedn   CPOS 44, 3.4 CLEN  4 BGND 13 PP 2
         DRGTEXT INTO drgFC CAPTION 'Skl. cena CELK'   CPOS 50, 2.4 CLEN 13
         DRGTEXT INTO drgFC NAME CENZBOZ->nCenaCZBO    CPOS 50, 3.4 CLEN 13 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC CAPTION 'Jakost'           CPOS 70, 2.4 CLEN 10
         DRGTEXT INTO drgFC NAME CENZBOZ->cJakost      CPOS 70, 3.4 CLEN 25 BGND 13 PP 2 CTYPE 2

       * 3.ø.
         DRGTEXT INTO drgFC CAPTION 'Mn. k dispozici'  CPOS  1, 4.6 CLEN 12
         DRGTEXT INTO drgFC NAME CENZBOZ->nMnozDZBO    CPOS  1, 5.6 CLEN 12 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC CAPTION 'Mn. rezervované'  CPOS 15, 4.6 CLEN 14
         DRGTEXT INTO drgFC NAME CENZBOZ->nMnozRZBO    CPOS 15, 5.6 CLEN 12 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC CAPTION 'Mn. objednané'    CPOS 29, 4.6 CLEN 12
         DRGTEXT INTO drgFC NAME CENZBOZ->nMnozOZBO    CPOS 29, 5.6 CLEN 12 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC CAPTION 'Mn. k objednání'  CPOS 43, 4.6 CLEN 12
         DRGTEXT INTO drgFC NAME CENZBOZ->nMnozKZBO    CPOS 43, 5.6 CLEN 12 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC CAPTION 'Cena bez danì'    CPOS 64, 4.6 CLEN 12
         DRGTEXT INTO drgFC NAME CENZBOZ->nCenaPZBO    CPOS 64, 5.6 CLEN 12 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC CAPTION 'DPH'              CPOS 77, 4.6 CLEN  5
         DRGTEXT INTO drgFC NAME C_DPH->nProcDph       CPOS 77, 5.6 CLEN  5 BGND 13 PP 2 CTYPE 2
         DRGTEXT INTO drgFC CAPTION '%'                CPOS 82, 5.6 CLEN  2
         DRGTEXT INTO drgFC CAPTION 'Cena s daní'      CPOS 85, 4.6 CLEN 12
         DRGTEXT INTO drgFC NAME CENZBOZ->nCenaMZBO    CPOS 85, 5.6 CLEN 12 BGND 13 PP 2 CTYPE(2)

         DRGPUSHBUTTON INTO drgFC CAPTION '' POS 0,0 SIZE 0,0
       DRGEND INTO drgFC

       DRGTABPAGE INTO drgFC CAPTION 'Košík' FPOS .5,13.6 SIZE 109,9 OFFSET 13,74 PRE 'tabSelect' TABHEIGHT .8
         DRGDBROWSE INTO drgFC FPOS -.5, .2 FILE 'objitemW'          ;
           FIELDS 'ncislPolOb:pol:4,'                              + ;
                  'ccisSklad:sklad:5,'                             + ;
                  'csklPol:sklPoložka,'                            + ;
                  'cnazZbo:název zboží:36,'                        + ;
                  'nmnozobodb:množ_obj,'                           + ;
                  'nmnozpoodb:množ_povr,'                          + ;
                  'nkcsbdobj:cena_bezdanì,'                        + ;
                  'nkcszdobj:cena_sdaní'                             ;
           CURSORMODE 3 PP 9 INDEXORD 4 RESIZE 'yy' SCROLL 'ny'
       DRGEND INTO drgFC

     DRGEND INTO drgFC

   otherwise
     * pøevzít z Nabídek vystavených  ->nabvysit

     DRGFORM INTO drgFC SIZE 110,14 DTYPE '10' TITLE 'Nabídky vystavené - výbìr' ;
                                               GUILOOK 'Action:y,Message:n,IconBar:y:drgBrowseIconBar,Menu:n'

       DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 110,14 FILE 'NABVYSIT' ;
         FIELDS 'cnazOdes:èíslonabídky,'  + ;
                'nintCount:pol,'          + ;
                'ccisSklad:sklad,'        + ;
                'csklpol:sklPol,'         + ;
                'cnazzbo:název zboží:35,' + ;
                'nmnozNOdes:mn_nabízeno,' + ;
                'czkratJedn:mj,'          + ;
                'ncenJedZak:cena/mj,'     + ;
                'ncenZakCed:cenaCelksDPH'   ;
       CURSORMODE 3 PP 7 INDEXORD 9 POPUPMENU 'yy' RESIZE 'x' SCROLL 'yy' ITEMSELECT 'RecordSeect'
     DRGEND INTO drgFC
   endcase
return drgFC