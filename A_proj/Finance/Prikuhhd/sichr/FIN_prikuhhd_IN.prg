#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"

**
** CLASS for FIN_prikuhhd_IN ***************************************************
CLASS FIN_prikuhhd_IN FROM drgUsrClass, FIN_finance_IN
exported:
  var     UHR_zavazku, lNEWrec, in_initParent   // c_bankUc_AOF
  var     dm, state                             // 0 - inBrowse  1 - inEdit  2 - inAppend
  var     pa_vazRecs, cfiltr_fp_sel

  * grafické statiky pro informaci o chybì u zahranièního pøíkazu k úhrade
  * OK - 101 ERR - 170 pro tuzemský 0
  var     o_ucet_info, o_nazev_info, o_bank_Naz_info
  *
  ** pro omezení nabídky pro pøíkazy FIN/MZD
  var     cblock


  method  init, destroy
  method  drgDialogStart, postValidate, postLastField, postSave, comboItemSelected, checkItemSelected

  method  fin_c_bankuc_sel, fin_prikuhit_fp_sel

  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1019
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    return self

  inline method prikuhhd_in_pzo()
    if( (::it_file)->(eof()), ::state := 2, nil )

    if ::o_prikuhhd_IN_pzo = NIL
      ::o_prikuhhd_IN_pzo := drgDialog():new('FIN_prikuhhd_IN_pzo', ::drgDialog)
      ::o_prikuhhd_IN_pzo:create(,,.T.)
    else
      ::o_prikuhhd_IN_pzo:quickShow(.t.)
    endif
    return self

  * indikace ba BROcol jen pro zahranièní pøíkaz
  * OK - 101 ERR - 170 pro tuzemský 0
  inline access assign method prikuhit_state_PZO() var prikuhit_state_PZO
    local retVal   := 0
    local isPzo_Ok := .t.

    if ::iszah_PrUhr()
      if .not. (::it_file)->(eof())
        isPzo_Ok := ( .not. empty(prikUhitw->cnazev)     .and. ;
                      .not. empty(prikUhitw->culice)     .and. ;
                      .not. empty(prikUhitw->cpsc)       .and. ;
                      .not. empty(prikUhitw->csidlo)     .and. ;
                      .not. empty(prikUhitw->czkratStat) .and. ;
                      .not. empty(prikUhitw->cucet)      .and. ;
                      .not. empty(prikUhitw->ciban)      .and. ;
                      .not. empty(prikUhitw->cbic)       .and. ;
                      .not. empty(prikUhitw->cbank_Naz)  .and. ;
                      .not. empty(prikUhitw->cbank_Uli)  .and. ;
                      .not. empty(prikUhitw->cbank_Psc)  .and. ;
                      .not. empty(prikUhitw->cbank_Sid)  .and. ;
                      .not. empty(prikUhitw->cbank_Sta)        )

        retval := if( isPzo_ok, 101, 170)
      endif
    endif
    return retVal

  inline access assign method prikuhit_fp_zby_fak() var prikuhit_fp_zby_fak
    local priUhrCel :=  if( isObject(::dm), ::dm:get( 'prikuhitw->npriuhrcel'), 0)
    local retVal    := 0

    retVal := (fakprihd->ncenZahCel -fakprihd->nuhrCelFaz) -priUhrCel
    return if( ::uhr_zavazku, retVal, 0)

  inline access assign method prikuhit_fp_zby() var prikuhit_fp_zby
    local priuhrPri := if( isObject(::dm), ::dm:get( 'prikuhitw->npriuhrpri'), 0)
    local retVal    := 0

    retVal := ((fakprihd->ncenZahCel -fakprihd->nuhrCelFaz) * ::nkoe_prFa() ) -priUhrPri
    return if( ::uhr_zavazku, retVal, 0)

  *
  ** EVENT *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs, isEof := prikuhitw->(eof()), cky

    do case
    case(nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::state :=  0

      fakPriHd->( dbseek( prikuhitW->ncisFak,, 'FPRIHD1'))
      if(isEof,::dm:set('prikuhitw->duhrbandne',::dm:get('prikuhhdw->dprikuhr')), nil)
      if(isEof, ::showGroup(.f.,.t.), ::showGroup())
      ::state_PZO()
      return .f.

    CASE nEvent = drgEVENT_APPEND

      ::dm:refreshAndSetEmpty( 'prikuhitw'  )

      ::o_nazev_info:oxbp:setCaption( 0 )
      ::o_ucet_info:oxbp:setCaption( 0 )
      ::o_bank_Naz_info:oxbp:setCaption( 0 )

      ::dm:set( 'prikuhitw->duhrbandne' ,::dm:get('prikuhhdw->dprikuhr'))
      ::dm:set( 'M->prikuhit_fp_zby_fak', 0)
      ::dm:set( 'M->prikuhit_fp_zby'    , 0)
      ::drgDialog:oForm:setNextFocus('m->uhr_zavazku',, .t.)
      ::state := 2
      ::showGroup(.F.,.T.)
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT
      ::state := 1
      ::drgDialog:oForm:setNextFocus('prikuhitw->ncisfak',, .T. )
      RETURN .T.

    case(nEvent = drgEVENT_DELETE)
      if drgIsYesNo(drgNLS:msg('Zrušit položku pøíkazu _ [&] _ ', prikuhhdw->ndoklad))
        if((::it_file)->_nrecor = 0, (::it_file)->(dbdelete()), (::it_file)->_delrec := '9')

        ::brow:panHome()
        ::brow:refreshAll()
        ::sumcolumn(7)
        ::dm:refresh()
      endif
      return .t.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()
      ::showGroup()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse')
        ::postLastField()
        ::o_prikuhhd_IN_pzo := NIL
      else
        ::postSave()
        if( .not. ::lNewrec, PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
      endif
      return .t.

    CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
          oXbp:setColorBG( oXbp:cargo:clrFocus )
        ENDIF

        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
        IF(::state = 2, ::brow:goTop():refreshAll(), ::brow:refreshCurrent())
        ::dm:refresh()

        ::UHR_zavazku        := If( PRIKUHITw ->cDENIK = '  ', .F., .T.)
        ::ischanged_dprikUhr := .f.
        ::setFocus()
        ::showGroup()
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

 HIDDEN:
  METHOD  showGroup, itSave, copyfldto_w
  VAR     panGroup, msg, df, brow, hd_file, it_file, ischanged_dprikUhr
  var     zaklMena, zaklStat
  var     o_priUhrCel          , o_priUhrPri
  var     o_prikuhit_fp_zby_fak, o_prikuhit_fp_zby
  var     o_prikuhhd_IN_pzo
  *
  var     o_nazev, o_ucet, o_bank_Naz
  *
  inline method state_PZO()
    local isOk := .t.

    if ::iszah_PrUhr()
      if ::state = 2 .or. (::it_file)->(eof())
        * pøíjemce
        isOk := ( .not. empty(::o_nazev:value)      .and. ;
                  .not. empty(fakPrihd->cULICE)     .and. ;
                  .not. empty(fakPrihd->CPSC)       .and. ;
                  .not. empty(fakPrihd->CSIDLO)     .and. ;
                  .not. empty(fakPrihd->CZKRATSTAT)       )
        ::o_nazev_info:oxbp:setCaption( if( isOk, 101, 170))

        * Ve prospìch úètu
        firmyUc->( dbseek( upper(::o_ucet:value),,'FIRMYUC2'  ))
        isOk := ( .not. empty(::o_ucet:value)       .and. ;
                  .not. empty(firmyUc->cIBAN)             )
        ::o_ucet_info:oxbp:setCaption( if( isOk, 101, 170))

        * Banka pøíjemce
        isOk := ( .not. empty(firmyUc->cBIC)        .and. ;
                  .not. empty(::o_bank_naz:value)   .and. ;
                  .not. empty(firmyUc->CBANK_ULI)   .and. ;
                  .not. empty(firmyUc->CBANK_PSC)   .and. ;
                  .not. empty(firmyUc->CBANK_SID)   .and. ;
                  .not. empty(firmyUc->cBANK_STA)         )
        ::o_bank_Naz_info:oxbp:setCaption( if( isOk, 101, 170))

      else
        * pro item marked
        * pøíjemce
        isOk := ( .not. empty(prikUhitw->cnazev)    .and. ;
                  .not. empty(prikUhitw->culice)    .and. ;
                  .not. empty(prikUhitw->cpsc)      .and. ;
                  .not. empty(prikUhitw->csidlo)    .and. ;
                  .not. empty(prikUhitw->czkratStat)      )
        ::o_nazev_info:oxbp:setCaption( if( isOk, 101, 170))

        * Ve prospìch úètu
        isOk := ( .not. empty(prikUhitw->cucet)     .and. ;
                  .not. empty(prikUhitw->ciban)           )
        ::o_ucet_info:oxbp:setCaption( if( isOk, 101, 170))

        * Banka pøíjemce
        isOk := ( .not. empty(prikUhitw->cbic)      .and. ;
                  .not. empty(prikUhitw->cbank_Naz) .and. ;
                  .not. empty(prikUhitw->cbank_Uli) .and. ;
                  .not. empty(prikUhitw->cbank_Psc) .and. ;
                  .not. empty(prikUhitw->cbank_Sid) .and. ;
                  .not. empty(prikUhitw->cbank_Sta)       )
        ::o_bank_Naz_info:oxbp:setCaption( if( isOk, 101, 170))
      endif
    endif
    return self


  inline method iszah_PrUhr()
    return (prikUhHdw->ctypDoklad = 'FIN_PRUHZA')

  inline method istuz_UcPr()
    return Equal( ::zaklMena, prikuhhdw ->czkratMenU)

  inline method istuz_UcFa()
    return Equal( ::zaklMena, fakPriHD  ->czkratMenZ )

  * pomocná metoda pro získání koeficientu pro pøepoèet faktury kurzem
  inline method nkoe_prFa()
    local  nkoe, ndecimals
    local  ncisFak :=  if( isObject(::dm), ::dm:get( 'prikuhitw->ncisFak'), 0)

    fakPriHd->( dbseek( ncisFak,, 'FPRIHD1'))

    * koeficienty pro pøepoèet kurem na 3 DM
    ndeciMals := Set( _SET_DECIMALS, 3 )

    do case
    case prikuhhdw->czkratMenU = fakprihd->czkratMenZ
      nkoe := 1
    case ::istuz_UcPr() .and. .not. ::istuz_UcFa()       // pøíkaz v tuzemské mìnì - faktura v zahranicní
      kurzit->( dbseek( upper( fakPriHD->czkratMenZ),,'KURZIT9'))
      nkoe := kurzit->nkurzStred/ kurzit->nmnozPrep

    case .not. ::istuz_UcPr() .and. ::istuz_UcFa()       // pøíkaz v zahranicní mene - faktura v tuzemské
      nkoe := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen

    case .not. ::istuz_UcPr() .and. .not. ::istuz_UcFa() // pøíkaz v zahranicní mene - faktura zahranicní
      kurzit->( dbseek( upper( fakpriHD->czkratMenZ),,'KURZIT9'))
      nkoe := (kurzit->nkurzStred/ kurzit->nmnozPrep) / (prikUhHDw->nkurZahMen/ prikUhHDw->nmnozPrep)
    endcase
    Set( _SET_DECIMALS, ndeciMals)

    return nkoe

  * suma
  inline method sumColumn(column)
    local  priUhrCel := 0
    local  sumCol := ::brow:getColumn(column)

    prikuhi_w->(dbgotop(),dbeval({ || priUhrCel += prikuhi_w->npriuhrcel }))

    sumCol:Footing:hide()
    sumCol:Footing:setCell(1,str(priUhrCel))
    sumCol:Footing:show()

    prikuhhdw->ncenzakcel := priUhrCel
    ::dm:set('prikuhhdw->ncenzakcel',priUhrCel)
  return priUhrCel

  *
  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  *
  inline method setfocus(state)
    local  members := ::df:aMembers, pos, bro

    ::state := isnull(state,0)

    do case
    case(::state = 2)
      PostAppEvent(drgEVENT_APPEND,,,::brow)
      SetAppFocus(::brow)
    otherwise
      bro := ::brow:cargo
      pos := ascan(members,{|X| (x = bro)})
      ::df:olastdrg   := ::brow:cargo
      ::df:nlastdrgix := pos
      ::df:olastdrg:setFocus()
      if isobject(::brow)
        PostAppEvent(xbeBRW_ItemMarked,,,::brow)
        ::brow:refreshCurrent():hilite()
      endif
    endcase
  return .t.
ENDCLASS


METHOD FIN_prikuhhd_IN:init(parent)
  LOCAL  nKy := 0, file_name
//  local  cf  := "upper(czkratMenY) = '%%'"

  ::drgUsrClass:init(parent)
  *
  (::hd_file     := 'prikuhhdw', ::it_file := 'prikuhitw')
   ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)

  * pøidán nový parametr FIN_fltpruhr
  ::cblock := ''

  if isCharacter( c_FIN_fltpruhr := sysConfig('finance:cfltpruhr'))
    c_FIN_fltpruhr := upper( c_FIN_fltpruhr )

    do case
    case at( 'FIN', c_FIN_fltpruhr ) <> 0 .and. at( 'MZD', c_FIN_fltpruhr ) <> 0
      ** ALL **
    case at( 'FIN', c_FIN_fltpruhr ) <> 0
      ::cblock := ("lower(c_typpoh->csubtask) <> 'mzd'")
    case at( 'MZD', c_FIN_fltpruhr ) <> 0
      ::cblock := ("lower(c_typpoh->csubtask) = 'mzd'")
    endcase
  endif


  ::ischanged_dprikUhr := .f.
  ::UHR_zavazku        := .T.
  ::state              :=  0
  ::panGroup           := .T.
  ::zaklMena           := SysConfig('Finance:cZaklMena')
  ::zaklStat           := SysConfig('SYSTEM:cZaklStat')
//  ::c_bankUc_AOF := format( cf, { upper(::zaklMena) })

  // SYS
  drgDBMS:open('C_BANKUC')
  drgDBMS:open('C_TYPUHR')
  drgDBMS:open('FAKPRIHD')
  drgDBMS:open('kurzit'  )
  drgDBMS:open('firmyUc')

  FIN_prikuhhd_cpy(self)

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'prikuhi_w', .t., .t.) ; prikuhi_w ->(AdsSetOrder(1))
RETURN self


METHOD FIN_prikuhhd_IN:destroy()
  ::drgUsrClass:destroy()

  ::UHR_zavazku := ;
  ::lNEWrec     := ;
  ::state       := ;
  ::panGroup    := ;
  ::msg         := ;
  ::dm          := ;
  ::brow        := NIL

  prikuhhdw->(dbCloseArea())
  prikuhitw->(dbCloseArea())
  prikuhi_w->(dbCloseArea())
RETURN


METHOD FIN_prikuhhd_IN:drgDialogStart(drgDialog)
  local x, members  := drgDialog:oForm:aMembers, ocolumn
  local groups, name
  local pa_groups, nin
  local acolors  := MIS_COLORS

  ::msg := drgDialog:oMessageBar
  ::dm  := drgDialog:dataManager
  ::df  := drgDialog:oForm

  ::o_priUhrCel           := ::dm:has('prikuhitw->npriUhrCel' )
  ::o_prikuhit_fp_zby_fak := ::dm:has('M->prikuhit_fp_zby_fak')

  ::o_priUhrPri           := ::dm:has('prikuhitw->npriUhrPri' )
  ::o_prikuhit_fp_zby     := ::dm:has('M->prikuhit_fp_zby'    )

  ::o_nazev               := ::dm:has('prikuhItw->cnazev'     )
  ::o_ucet                := ::dm:has('prikuhItw->cucet'      )
  ::o_bank_Naz            := ::dm:has('prikuhItw->cBank_naz'  )

  * pøi opravì pøíkazu jsou automaticky zablokované
  * czkratMenu, nkurZahMen, nmnozPrep

  * prvky které budeme dynamicky blokovat
  o_dprikUhr              := ::dm:has('prikuhHdw->dprikuhr'   )
  o_zkratMnenU            := ::dm:has('prikuhHdw->czkratMenu' )
  o_kurZahMen             := ::dm:has('prikuhHdw->nkurZahMen' )
  o_mnozPrep              := ::dm:has('prikuhHtw->nmnozPrep'  )

  begin sequence
  for x := 1 TO len(members) step 1

    groups := if( isMemberVar(members[x],'groups'), isnull(members[x]:groups,''), '')
    name   := if( ismemberVar(members[x],'name'  ), isnull(members[x]:name  ,''), '')

    do case
    case left(groups,3) = 'BAU'
      if 'SETFONT' $ groups
        pa_groups := ListAsArray( groups)
        nin       := ascan(pa_groups,'SETFONT')

        members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          members[x]:oXbp:setColorFG(GRA_CLR_BLACK)
        endif
      endif

    case isMemberVar(self, groups)
      self:&groups := members[x]

    endCase

    if 'browse' $ lower(members[x]:className())
      ::brow := members[x]:oxbp
  break
    endif
  next
  endsequence

  if .not. ::lNEWrec
    drgDialog:oForm:nextFocus := x
  else
    ::comboItemSelected(::dm:has('prikuhhdw->ctyppohybu'):oDrg)
  endif

  for x := 1 to ::brow:colCount step 1
    ocolumn := ::brow:getColumn(x)

    ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
    ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
    ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
    ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
    ocolumn:configure()
  next
  ::brow:configure():refreshAll()

  *
  ::sumColumn(7)
  ::dm:refresh()
RETURN self


method FIN_prikuhhd_IN:comboItemSelected(drgComboBox,mp2,o)
  local  name  := lower(drgComboBox:name)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin,pa

  * FIN_PRUHTU  FIN_PRUHZA
  * ciddatkome  ciddatkoze

  do case
  case(name = ::hd_file +'->ctyppohybu')
    nin := ascan(values,{|x| x[1] = value })
     pa := listasarray(values[nin,4])

    (::hd_file)->ctypdoklad := values[nin,3]
    (::hd_file)->ctyppohybu := values[nin,1]
    *
    (::hd_file)->ctask      := values[nin,5]
    (::hd_file)->csubTask   := values[nin,6]

  case(name = ::hd_file +'->czkratmenu' )
    if drgComboBox:ovar:itemChanged()
      PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgComboBox:oxbp)
    endif
  endcase
return .t.


METHOD FIN_prikuhhd_IN:CheckItemSelected(drgVar)
  ::showGroup(.F.,drgVar:value)

  ::dm:set( 'prikuhitW->czkratMenZ', (::hd_file)->czkratMenU )
  ::dm:set( 'prikuhitW->czkratMenU', (::hd_file)->czkratMenU )
RETURN self


method FIN_prikuhhd_in:postValidate(drgVar)
  LOCAL  value := drgVar:get()
  LOCAL  name  := lower(drgVar:name)
  LOCAL  ok    := .t., zbyUhr, changed := drgVAR:Changed()
  local  ndeciMals, nkoe  := 1
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  * koeficienty pro pøepoèet kurem na 3 DM
  ndeciMals := Set( _SET_DECIMALS, 3 )

  * ?? obecná položka pøíkazu k úhradì
  if .not. ::uhr_zavazku
     nkoe := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen
  else
    do case
    case prikuhhdw->czkratMenU = fakprihd->czkratMenZ
      nkoe := 1
    case ::istuz_UcPr() .and. .not. ::istuz_UcFa()       // pøíkaz v tuzemské mìnì - faktura v zahranicní
      kurzit->( dbseek( upper( fakPriHD->czkratMenZ),,'KURZIT9'))
      nkoe := kurzit->nkurzStred/ kurzit->nmnozPrep

    case .not. ::istuz_UcPr() .and. ::istuz_UcFa()       // pøíkaz v zahranicní mene - faktura v tuzemské
      nkoe := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen

    case .not. ::istuz_UcPr() .and. .not. ::istuz_UcFa() // pøíkaz v zahranicní mene - faktura zahranicní
      kurzit->( dbseek( upper( fakpriHD->czkratMenZ),,'KURZIT9'))
      nkoe := (kurzit->nkurzStred/ kurzit->nmnozPrep) / (prikUhHDw->nkurZahMen/ prikUhHDw->nmnozPrep)
    endcase
  endif
  Set( _SET_DECIMALS, ndeciMals)


  do case
  case (name = 'prikuhhdw->dprikuhr')
    ok := .not. empty(value)

    * neexistují položky
    if (::it_file)->(eof())
      if( ok := (ok .and. value >= date()))
        eval(drgVar:block,drgVar:value)
        ::dm:set( 'prikuhItw->duhrbandne', value)
      endif

    * existují položky, ale pro tuzemskou mìnu umožníme zmìnit datum
    else

      do case
      case changed
        if ::istuz_UcPr()
          if( ok := ( .not. empty(value) .and. value >= date()))
            ::ischanged_dprikUhr := .t.
            ::dm:set( 'prikuhItw->duhrbandne', value)
          endif
        else
          ok := if( changed, .f., .t.)
        endif
      endcase
    endif

  case (name = 'prikuhhdw->cbank_uct' )
    ok := ::FIN_C_BANKUC_SEL()

  case (name = 'prikuhhdw->czkratmenu')
    if( changed, ::fin_kurzit(drgvar,(::hd_file)->dporizPri), nil )

  case (name = 'prikuhitw->ncisfak'  )
    if ::dm:get('m->uhr_zavazku')
      ok := if( changed .or. empty(value) , ::FIN_prikuhit_fp_SEL(), .t.)
    endif

    if Empty(value)
      ::msg:writeMessage('Èíslo -FAKTURY- je párovací symbol SALDA ...',DRG_MSG_WARNING)
    endif

  case (name = 'prikuhitw->duhrbandne')
    ok := ( .not. Empty(value) .and. value >= ::dm:get('prikuhhdw->dprikuhr') )

  case (name = 'prikuhitw->cucet'    )
    ok := .not. Empty(value)

  case (name = 'prikuhitw->npriuhrcel')
    ok := (value > 0)
    if ok .and. ::uhr_zavazku
      ok := ( FIN_prikuhit_fp_ZBY() >= 0 )
    endif
    ::o_priUhrPri:set( value * nkoe )

  case (name = 'prikuhitw->npriuhrpri')
    ::o_priUhrCel:set( value / nkoe )

  endcase

  if( .not. ok, ::msg:writeMessage('Chybná hodnota údaje ...',DRG_MSG_WARNING), nil)

  if ::uhr_zavazku .and. ::dm:get( 'prikuhitW->ncisFak' ) <> 0
    ::o_prikuhit_fp_zby_fak:set( ::prikuhit_fp_zby_fak )
    ::o_prikuhit_fp_zby:set( ::prikuhit_fp_zby )
  endif

  if(name = ::it_file +'->nprioriuhr' .and. ok )
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      ::postLastField()
    endif
  endif
return ok


method FIN_prikuhhd_in:postLastField(drgVar)
  local  isChanged := .t., recNo, duhrBanDne// ::dm:changed()
  local  cisfak_or := ::dm:has('prikuhitw->ncisfak_or'):value
  local  iszav     := .not. empty(::dm:get('prikuhitw->cdenik'))
  *
  local  o_drgVar
  local  npos, cbank_uce, cbanis

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  if iszav
                          ::copyfldto_w('fakprihd',::it_file)
                          (::it_file)->ncisfak_or := cisfak_or
                       endif
                       ::copyfldto_w(::hd_file,::it_file,,.f.)
    endif

    if isObject(::o_prikuhhd_IN_pzo)
      ::itSave( ,::o_prikuhhd_IN_pzo:UDCP:dm )
    else
      * pøíjemce
      prikUhItW->cNazev     := ::o_nazev:value
      prikUhItW->cULICE     := fakPrihd->cULICE
      prikUhItW->CPSC       := fakPrihd->CPSC
      prikUhItW->CSIDLO     := fakPrihd->CSIDLO
      prikUhItW->CZKRATSTAT := fakPrihd->CZKRATSTAT
      prikUhItW->cDIC       := fakPrihd->cDIC

      * Ve prospìch úètu
      firmyUc->( dbseek( upper(::o_ucet:value),,'FIRMYUC2'  ))
      prikUhItW->cUCET      := ::o_ucet:value
      prikUhItW->cIBAN      := firmyUc->cIBAN

      * Banka pøíjemce
      prikUhItW->cBIC       := firmyUc->cBIC
      prikUhItW->cBANK_NAZ  := ::o_bank_naz:value
      prikUhItW->CBANK_ULI  := firmyUc->CBANK_ULI
      prikUhItW->CBANK_PSC  := firmyUc->CBANK_PSC
      prikUhItW->CBANK_SID  := firmyUc->CBANK_SID
      prikUhItW->cBANK_STA  := firmyUc->cBANK_STA
    endif

    * dulicitnní údaje + cbank_uce
    prikuhitw->cbank_uct := prikuhitw->cucet
    if ( npos := rat( '/',  prikuhitw->cbank_Uct)) <> 0
      cbank_uce := strTran( allTrim( subStr( prikuhitw->cbank_uct,      1, npos-1)), '-', '')
      cbanis    := allTrim( subStr( prikuhitw->cbank_uct, npos+1         ))

      prikuhitw->cbank_uce := padL( cbank_uce, 16, '0')
      prikuhitw->cbanis    := cbanis
    endif


    ::itsave()
    if( .not. iszav, (::it_file)->ncenzakcel := (::it_file)->npriuhrcel, nil)

    if ::ischanged_dprikUhr
      prikuhhdw->dprikUhr := ::dm:get( 'prikuhhdw->dprikUhr', .t.)
      duhrBanDne          := prikuhitw->duhrBanDne

      (::it_file)->(flock())

      recNo := prikuhitw->(recNo())
      prikuhitw->(dbgotop(),dbeval({ || prikuhitw->duhrBanDne := prikuhhdw->dprikUhr }))
      prikuhitw->(dbgoTo( recNo))

      if prikuhhdw->dprikUhr <> duhrBanDne
        prikuhitw->duhrBanDne := duhrBanDne
      endif
    endif

    if( ::state = 2, ::brow:gobottom():refreshAll(), ;
      if( ::ischanged_dprikUhr, ::brow:refreshAll(), ::brow:refreshCurrent()) )

    (::it_file)->(flock())
  endif

  ::ischanged_dprikUhr := .f.
  o_drgVar             := ::dm:get('m->uhr_zavazku',.f.)
  ::uhr_zavazku        := .t.
  o_drgVar:initValue   := o_drgVar:value := o_drgVar:prevValue := ::uhr_zavazku

  ::setfocus(::state)
  ::sumColumn(7)
  ::dm:refresh()
return .t.


method FIN_prikuhhd_in:itSave(panGroup, dm)
  local  x, ok := .t., ok_it, drgVar

  default dm to ::dm

  for x := 1 to dm:vars:size() step 1
    drgVar := dm:vars:getNth(x)
    if ISCHARACTER(panGroup)
      ok := (empty(drgVar:odrg:groups) .or. drgVar:odrg:groups = panGroup)
    endif

    * musí to být jen prikuhitw
    ok_it := ( at(::it_file, lower(drgVar:name)) <> 0 )

    if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok_it .and. ok
      if eval(drgvar:block) <> drgVar:value
        eval(drgVar:block,drgVar:value)
      endif
      drgVar:initValue := drgVar:value
    endif
  next
return self


method FIN_prikuhhd_in:postSave()
  local file_name, ok := FIN_prikuhhd_wrt(self)

  if(ok .and. ::lnewRec)

    (::it_file)->(DbCloseArea())
    prikuhi_w  ->(DbCloseArea())

    fin_prikuhhd_cpy(self)

    file_name := (::it_file)->( DBInfo(DBO_FILENAME))
                 (::it_file)->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'prikuhi_w', .t., .t.) ; prikuhi_w ->(AdsSetOrder(1))

    ::df:setNextFocus('prikuhhdw->dprikuhr',,.t.)
    ::brow:refreshAll()
    ::dm:refresh()
    ::sumColumn(7)
  elseif(ok .and. .not. ::lnewRec)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


method FIN_prikuhhd_in:copyfldto_w(from_db,to_db,app_db)
  local npos, xval, afrom := (from_db)->(dbstruct()), x

  if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
  for x := 1 to len(afrom) step 1
    if .not. (lower(afrom[x,DBS_NAME]) $ '_nrecor,_delrec')
      xval := (from_db)->(fieldget(x))
      npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

      if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
    endif
  next
return nil

*
** SELL METHOD *****************************************************************
method fin_prikuhhd_in:fin_c_bankuc_sel(drgDialog)
  local oDialog, nExit
  //
  local drgVar  := ::dm:get('prikuhhdw->cbank_uct' , .f.)
  local banNaz  := ::dm:get('prikuhhdw->cbanK_naz' , .f.)
  local zkrMenZ := ::dm:get('prikuhhdw->czkratMenZ', .f.)
  local value   := drgVar:get()
  local ok      := (.not. Empty(value) .and. C_BANKUC ->(DbSeek(value)))
  //
  local zkrMeny, cky, kurZahMen := 1, mnozPrep := 1

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIN_C_BANKUC_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit

    if nExit != drgEVENT_QUIT
      mh_copyfld('c_bankuc', 'prikuhhdw',,.f.)
      banNaz:set(c_bankuc->cBank_naz)

      if .not. Equal( SysConfig('Finance:cZaklMENA'), c_bankUc->czkratMenY )
        zkrMeny := upper( c_bankUc->czkratMenY)

        kurzit->(AdsSetOrder(2), dbsetscope(SCOPE_BOTH,zkrMeny))
        cky := zkrMeny +dtos(PRIKUHHDw->dporizPri)

        kurzit->(dbseek(cky,.t.))
        if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)
        kurZahMen := kurzit->nkurzstred
        mnozPrep  := kurzit->nmnozprep
        kurzit->(dbclearscope())
      endif

      prikuhhdW ->ckodBan_cr := c_bankuc ->cBanis
*      prikuhhdW ->cBanis     := c_bankuc ->cBanis

      ::dm:set( 'c_bankUc->nposZust'   , c_bankUc->nposZust  )
      ::dm:set( 'c_bankUc->czkratMenY' , c_bankUc->czkratMenY)

      ::dm:set( 'prikuhhdw->czkratMenU', c_bankUc->czkratMenY)
        prikuhhdw->czkratMenU := c_bankUc->czkratMenY

      ::dm:set( 'prikuhhdw->nkurZahMen', kurZahMen           )
        prikuhhdw->nkurZahMen := kurZahMen

      ::dm:set( 'prikuhhdw->nmnozPrep' , mnozPrep            )
        prikuhhdw->nmnozPrep  := mnozPrep

      ::refresh( ::hd_file,, ::dm:vars )
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
    ENDIF
  ENDIF
RETURN (nExit != drgEVENT_QUIT) .or. ok


METHOD FIN_prikuhhd_IN:FIN_prikuhit_fp_SEL(drgDialog)
  local  oDialog, nExit, oBROw := ::drgDialog:dialogCtrl:oaBrowse
  local  drgVar := ::dm:get('prikuhitw->ncisfak',.f.)
  local  value  := drgVar:get()
  local  lOk    := .not. empty(value)
  //
  LOCAL  ZBY_uhradit, x, arSelect := {}
  local  pa := {}

  ::cfiltr_fp_sel := if( ::iszah_PrUhr(), ;
                         format( "upper(czkratStat) <> '%%'", { upper(::zaklStat) }), ;
                         format( "upper(czkratStat) =  '%%'", { upper(::zaklStat) })  )
  ::pa_vazRecs    := pa
  prikuhi_w->( dbeval( { || aadd( pa, prikuhi_w->ncisfak_or) }, ;
                       { || prikuhi_w->ncisfak_or <> 0       }) )

  if .not. empty(pa)
    fakPriHD->( ads_setAof('.T.'))
    fakPriHD->( ads_customizeAOF( pa, 3))
  endif

  lok := ( lok .and. FIN_prikuhit_fv_SEEK(value) )
  lok := ( lok .and. if( ::iszah_PrUhr(), .not. Equal( ::zaklStat, fakprihd->czkratStat), ;
                                                Equal( ::zaklStat, fakprihd->czkratStat)  ))

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIN_prikuhit_fp_SEL' PARENT ::drgDialog MODAL EXITSTATE nExit

    arSelect := oDialog:UDCP:d_bro:arSELECT
    oDialog:destroy(.T.)
    oDialog  := NIL
  endif

  IF nExit != drgEVENT_QUIT .or. (lOk .and. drgVar:changed())
    if len( arSelect) > 0
      for x := 1 to len( arSelect) step 1
        fakprihd->( dbgoTo( arSelect[x] ))

        ZBY_uhradit := FIN_prikuhit_fp_ZBY()

        prikuhit_SET_data( ::dm, ZBY_uhradit )
        ::postLastField()
      next
    ELSE                                                                        //edituje dál
      IF ( ZBY_uhradit := FIN_prikuhit_fp_ZBY()) > 0

        prikuhit_SET_data( ::dm, ZBY_uhradit )
      ELSE
        ::msg:writeMessage('Na fakturu již byl vystaven pøíkaz k úhradì ...',DRG_MSG_WARNING)
      ENDIF
    ENDIF

    ::state_PZO()
  ENDIF

  if( .not. empty(pa), fakPriHD->(ads_clearAof()), nil)
RETURN (nExit != drgEVENT_QUIT)


static function prikuhit_SET_data( dm, ZBY_uhradit )

  firmyUc->( dbseek( upper( fakprihd->cucet),,'FIRMYUC2'))

  dm:set('prikuhitw->ncisfak'   , FAKPRIHD ->nCISFAK    )
  dm:set('prikuhitw->ctextPol'  , FAKPRIHD ->cNAZEV     )
  dm:set('prikuhitw->cnazev'    , FAKPRIHD ->cNAZEV     )
  dm:set('prikuhitw->cucet'     , FAKPRIHD ->cucet      )
  dm:set('prikuhitw->cvarsym'   , FAKPRIHD ->cVARSYM    )
  dm:set('prikuhitw->nkonstsymb', FAKPRIHD ->nKONSTSYMB )
  dm:set('prikuhitw->cspecsymb' , FAKPRIHD ->cSPECSYMB  )
  dm:set('prikuhitw->ncenzakcel', FAKPRIHD ->nCENZAKCEL )

  * z fakprihd
  dm:set('prikuhitw->czkratMenZ', FAKPRIHD ->czkratMenZ     )
  dm:set('prikuhitw->npriuhrcel', FIN_prikuhit_fp_ZBY_FAK() )

  * z prikuhhdw
  dm:set('prikuhitw->czkratMenU', prikUhHdw ->czkratMenU)
  dm:set('prikuhitw->npriuhrpri', ZBY_uhradit           )

  dm:set('prikUhitw->cbank_naz' , firmyUc->cbank_naz    )
  dm:set('prikuhitw->ncisfak_or', fakprihd->(recno())   )
  dm:set('prikuhitw->cobdobi'   , fakprihd->cobdobi     )
  dm:set('prikuhitw->nrok'      , fakprihd->nrok        )
  dm:set('prikuhitw->nobdobi'   , fakprihd->nobdobi     )
  dm:set('prikuhitw->cdenik'    , fakprihd->cdenik      )
return .t.


**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_prikuhhd_IN:showGroup(inGrid,inCheck)
  LOCAL  nIn, NoEdit := GraMakeRGBColor( {221, 221, 221} )
  LOCAL  pA  := {'m->uhr_zavazku'       , 'prikuhitw->ncisfak'   , 'prikuhitw->cvarsym'  , ;
                 'prikuhitw->nkonstsymb', 'prikuhitw->cspecsymb'  }
  LOCAL  drgVar, dm := ::dataManager, UHR_zavazku

  DEFAULT inGrid TO .T.

  ::UHR_zavazku := IF(inGrid, If( PRIKUHITw ->cDENIK = '  ', .F., .T.), IsNull(inCheck,.F.))

  FOR nIn := 1 TO LEN(pA)
    drgVar := dm:has(pA[nIn]):oDrg

    DO CASE
    CASE drgVar:ClassName() = 'drgGet'
      UHR_zavazku := IF(inGrid, ::UHR_zavazku, IF(nIn = 2, .F., inCheck))
      drgVar:isEdit := .not. UHR_zavazku
      drgVar:oXbp:setColorBG(IF( drgVar:isEdit, drgVar:clrFocus, NoEdit))

      IF IsObject(drgVar:pushGet) .and. nIn = 2
        IF inGrid
          IF( .not. ::UHR_zavazku, drgVar:pushGet:oXbp:hide(), drgVar:pushGet:oXbp:show())
        ELSE
          IF( inCheck, drgVar:pushGet:oXbp:show(), drgVar:pushGet:oXbp:hide())
        ENDIF
      ENDIF
    CASE drgVar:ClassName() = 'drgCheckBox'
      IF( inGrid, (drgVar:isEdit := .F., drgVar:oXbp:disable()), ;
                  (drgVar:isEdit := .T., drgVar:refresh(inCheck), drgVar:oXbp:enable())   )
    ENDCASE
  NEXT
RETURN self


static function FIN_prikuhit_fv_SEEK(value)
  local  ok := .f.

  if fakprihd->(dbSeek(value,,'FPRIHD1'))
    ok :=             FIN_prikuhit_fp_ZBY() > 0
    ok := ( ok .and. (FIN_prikuhit_fp_BC(0) = 0))
  endif
return ok


**
** CLASS for FIN_prikuhit_fp_SEL ***********************************************
**
*
FUNCTION FIN_prikuhit_fp_BC(nCOLUMn)
  LOCAL  nCEN    := FAKPRIHD ->nCENZAKCEL, nUHR, nZBY
  LOCAL  xRETval := 0

  DO CASE
  CASE( nCOLUMn = 0)                                       // x - . inkaso
    c_typuhr->( dbSeek( upper( fakprihd->czkrTypUhr )))
    xRETval := if( c_typuhr->lIsInkaso, MIS_ICON_ERR, 0)

  CASE( nCOLUMn = 1)                                       // H - h -  uhrazeno
    ncen := fakprihd->ncenZahCel
    nuhr := fakprihd->nuhrCelFaz
    xRETval := IF(nUHR = 0, 0, IF(nUHR < nCEN, H_low, IF(nUHR = nCEN, H_big, MIS_ICON_ERR)))

  CASE( nCOLUMn = 2 )                                      // P - p -  pøíkazy
    nZBY    := FIN_prikuhit_fp_ZBY()
    nuhr    := fakprihd->npriuhrCel
    xRETval := IF(nZBY = 0, P_big, IF(nZBY < nuhr, P_low, 0))

  CASE( nCOLUMn = 7 )                                      // zbývá uhradit v mìnì PRIKAZU
    xRETval := FIN_prikuhit_fp_ZBY()

  CASE( nCOLUMN = 8 )                                      // zbývá uhradit v mìnì FAKTURY
    xRETval := FIN_prikuhit_fp_ZBY_FAK()

  ENDCASE
RETURN xRETval


function FIN_prikuhit_fp_ZBY_FAK()
  local  cKy := Upper( FAKPRIHD ->cDENIK) +StrZero( FAKPRIHD ->nCISFAK,10)
  local  nkoe, n_cenZahCel, n_uhrCelFaz, n_priUhrCel

  prikUhi_w->( dbseek( cky,, 'PRIKUHIT_2'))
  priUhr     := prikUhi_w->npriUhrCel * if( prikUhi_w->_delrec = '9', +1, 0 )

  n_cenZahCel := fakprihd->ncenZahCel
  n_uhrCelFaz := fakprihd->nuhrCelFaz
  n_priUhrCel := fakprihd->npriUhrCel

  if ( n_priUhrCel - n_uhrCelFaz) <= 0
    return (n_cenZahCel - n_uhrCelFaz) +priUhr
  else
    return ( n_cenZahcel -( n_priUhrCel + n_uhrCelFaz )) +priUhr
  endif
return 0


FUNCTION FIN_prikuhit_fp_ZBY()
  LOCAL  nZBY_uhr, nRECs := PRIKUHITw ->( RecNo())
  LOCAL  cKy  := Upper( FAKPRIHD ->cDENIK) +StrZero( FAKPRIHD ->nCISFAK,10)
  LOCAL  isIn := .f.
  *
  local  nkoe, n_cenZahCel, n_uhrCelFaz, n_priUhrCel
  local  ndeciMals
  local  val := 0
  local  istuz_Zuc, istuz_Zal

  static zaklMena
  if( isNull(zaklMena) , zaklMena  := SysConfig('Finance:cZaklMena'), nil )

  isIn := prikUhi_w->( dbseek( cky,, 'PRIKUHIT_2'))

  istuz_UcPr := Equal( zaklMena, prikuhhdw ->czkratMenU)
  istuz_UcFa := Equal( zaklMena, fakPriHD  ->czkratMenZ )
  priUhr     := prikUhi_w->npriUhrCel * if( prikUhi_w->_delrec = '9', +1, 0 )  // -1

  * shodné mìny pøíkazu i faktury pøijaté
  if prikuhhdw->czkratMenU = fakprihd->czkratMenZ
    n_cenZahCel := fakprihd->ncenZahCel
    n_uhrCelFaz := fakprihd->nuhrCelFaz
    n_priUhrCel := fakprihd->npriUhrCel                 // zahranièní - tuzemská ?

  else
    * ruzné mìny pøíkazu a faktury pøijate

    ndeciMals := Set( _SET_DECIMALS, 3 )

    do case
    case istuz_UcPr .and. .not. istuz_UcFa       // pøíkaz v tuzemské mìnì - faktura v zahranicní
      kurzit->( dbseek( upper( fakPriHD->czkratMenZ),,'KURZIT9'))

      nkoe        := kurzit->nkurzStred/ kurzit->nmnozPrep
      n_cenZahCel := fakPriHD ->ncenZahCel * nkoe
      n_uhrCelFaz := fakPriHD ->nuhrCelFaz * nkoe
      n_priUhrCel := fakprihd ->npriUhrCel * nkoe       // zahranièní - tuzemská ?

    case .not. istuz_UcPr .and. istuz_UcFa       // pøíkaz v zahranicní mene - faktura v tuzemské
      nkoe        := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen
      n_cenZahCel := fakPriHD ->ncenZahCel * nkoe
      n_uhrCelFaz := fakPriHD ->nuhrCelFaz * nkoe
      n_priUhrCel := fakprihd ->npriUhrCel * nkoe       // zahranièní - tuzemská ?

    case .not. istuz_UcPr .and. .not. istuz_UcFa // pøíkaz v zahranicní mene - faktura zahranicní
      kurzit->( dbseek( upper( fakpriHD->czkratMenZ),,'KURZIT9'))

      nkoe        := (kurzit->nkurzStred/ kurzit->nmnozPrep) / (prikUhHDw->nkurZahMen/ prikUhHDw->nmnozPrep)
      n_cenZahCel := fakPriHD ->ncenZahCel * nkoe
      n_uhrCelFaz := fakPriHD ->nuhrCelFaz * nkoe
      n_priUhrCel := fakprihd ->npriUhrCel * nkoe       // zahranièní - tuzemská ?
    endcase

    Set( _SET_DECIMALS, ndeciMals)
  endif

  if ( n_priUhrCel - n_uhrCelFaz) <= 0
    return (n_cenZahCel - n_uhrCelFaz) +priUhr
  else
    return ( n_cenZahcel -( n_priUhrCel + n_uhrCelFaz )) +priUhr
  endif
return 0
*
**


CLASS FIN_prikuhit_fp_SEL FROM drgUsrClass, quickFiltrs_withCustomizeAof
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart, drgDialogEnd
  method  doPrevzit
  *
  var     d_bro, pa_vazRecs, cfiltr_fp_sel
  *
  ** FAKPRIHD stav/ fakturu lze pøevzít do pøíkazu
  ** žlutá BMP indikuje Pøeshranièní platbu
  inline access assign method fakprihd_isOk() var fakprihd_isOk
    c_typuhr->( dbSeek( upper( fakprihd->czkrTypUhr )))
    firmyUc ->( dbseek( upper(fakPriHD->cucet),, 'FIRMYUC2'))
    return if( FIN_prikuhit_fp_ZBY() > 0 .and. .not. c_typuhr->lIsInkaso,  ;
            if( firmyUc->cBANK_sta = fakPriHD->czkratStat, 6001, 6006)  , 0)

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl
    *
    local  cInfo     := 'Promiòte prosím,' +CRLF

    DO CASE
    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      if FIN_prikuhit_fp_BC(0) = 0
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

      else
        cInfo += 'fakura pøijatá ( ' +allTrim( str( fakprihd->ncisFak)) +' )' +CRLF       + ;
                 'je hrazena inkasním pøíkazem ...'                           +CRLF +CRLF + ;
                 '... NELZE PØEVZÍT DO PØÍKAZU K ÚHRADÌ ... '

        fin_info_box( cInfo, XBPMB_CRITICAL )
      endif

    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_FORMDRAWN
       Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      CASE mp1 = xbeK_SPACE
        IF FIN_prikuhit_fp_ZBY() > 0
          RETURN .F.
        ELSE
          RETURN .T.
        ENDIF

      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
    RETURN .T.

    *
    ** oznaèit položku pro pøevzetí, lze jen za splnìní podmínek
    ** je co hradit a není to inkasu uf...
    inline method mark_doklad()
      postAppEvent( xbeP_Keyboard, xbeK_CTRL_ENTER,,::d_bro:oXbp)
      return self // ::post_bro_colourCode()

    inline method save_marked()
      postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
//    postappevent(drgEVENT_EDIT,,,::d_bro:oxbp)
      return self

    inline method post_bro_colourCode()
      local recNo := (::in_file)->(recNo())  , ;
               pa := aclone(::d_bro:arselect), ;
              nOk := 0                       , in_file, obro, ardef, npos_in, ocol_is

      in_file := ::in_file
      obro    := ::d_bro
      ardef   := obro:ardef

      npos_is := ascan(ardef, {|x| x[2] = 'M->' +in_file +'_isOk' })
      ocol_is := obro:oxbp:getColumn(npos_is)

      if ocol_is:getData() = 6001
        if (npos := ascan(pa, recNo)) = 0
           aadd(pa, recNo)
         else
           Aremove(pa, npos )
         endif

         if( len(pa) = 0, ::pb_save_marked:disable(), ::pb_save_marked:enable())
*         ::d_bro:arselect := pa
*         ::d_bro:oxbp:refreshCurrent()
         nOk := 1
      endif
      return nOk    /// .t.

HIDDEN:
  VAR     drgGet, setVyber
  VAR     in_file, pb_mark_doklad, pb_save_marked
ENDCLASS


METHOD FIN_prikuhit_fp_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  ::cfiltr_fp_sel := ''
  ::pa_vazRecs    := {}

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet        := oXbp:cargo
    ::pa_vazRecs    := parent:parent:udcp:pa_vazRecs
    ::cfiltr_fp_sel := parent:parent:udcp:cfiltr_fp_sel
  ENDIF

  if( .not. empty(::cfiltr_fp_sel), parent:set_prg_filter(::cfiltr_fp_sel, 'fakprihd'), nil )

  ::setVyber := 0
  ::in_file  := 'fakprihd'
  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_prikuhit_fp_SEL:getForm()
  LOCAL  oDrg, drgFC
  local  zkratMenU := prikUhHDw->czkratMenU  // mìna úhrady z c_bankUc


  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 120,12.6 DTYPE '10' TITLE 'Seznam závazkù ...' ;
                                              GUILOOK 'All:N,Border:Y,ACTION:N'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 120,11.4 FILE 'FAKPRIHD'        ;
    FIELDS 'M->fakprihd_isOk::2.7::2,'                                + ;
           'FIN_prikuhit_fp_BC(0)::2.6::2,'                           + ;
           'FIN_prikuhit_fp_BC(1):H:2.6::2,'                          + ;
           'FIN_prikuhit_fp_BC(2):P:2.6::2,'                          + ;
           'dSPLATFAK:datSplatn,'                                     + ;
           'nCISFAK:èísloFaktury:10,'                                 + ;
           'cVARSYM:varSymbol,'                                       + ;
           'cNAZEV:názevFirmy:25,'                                    + ;
           'czkratStat:stát,'                                         + ;
           'ncenZahCel:faktura:13:::1,'                               + ;
           'FIN_prikuhit_fp_BC(8):k úhradì:14:::1,'                   + ;
           'czkratMenZ:v:4,'                                          + ;
           'FIN_prikuhit_fp_BC(7):k úhradì v ' +zkratMenU +':14:::1,' + ;
           'nuhrCelFaZ:uhrazeno'                                        ;
    SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'
  odrg:footer := 'yy'


  DRGPUSHBUTTON INTO drgFC CAPTION '~Kompletní seznam ' POS 75.5,0.2 SIZE 38,1.2 ;
                EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'              ;
                ICON1 101 ICON2 201  ATYPE 3

  DRGPUSHBUTTON INTO drgFC POS 113.5,.2 SIZE 3,1.2 ATYPE 1             ;
                EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...' ;
                ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK

  DRGPUSHBUTTON INTO drgFC POS 116.5,.2 SIZE 3,1.1 ATYPE 1                   ;
                EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...' ;
                ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS

RETURN drgFC


METHOD FIN_prikuhit_fp_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

**  XbpDialog:titleBar := .F.
  drgDialog:dialog:drawingArea:bitmap  := 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  ENDIF
RETURN


method FIN_prikuhit_fp_SEL:drgDialogStart( drgDialog )
  local  x, members  := drgDialog:oForm:aMembers
  local  d_bro       := drgDialog:dialogCtrl:obrowse[1]
  local  ocol, chead := 'k úhradì v ' +prikUhHDw->czkratMenU


  local  pa_quick   := { ;
  { 'Kompletní seznam                     ', ;
    ''                                                                                                          }, ;
  { 'Neuhrazené závazky                   ', ;
    '(ncenZahCel <> 0 .and. nuhrCelFaz = 0) .or. ((ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0)'        }, ;
  { 'Èásteènì uhrazené závazky            ', ;
    '(ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0'                                                      }, ;
  { 'Závazky bez pøíkazu k úhradì         ', ;
    'ncenzahcel <> 0 .and. npriuhrcel = 0 .and. nuhrcelfaz = 0'                                                 }, ;
  { 'Závazky s èásteèným pøíkazem k úhradì', ;
    '(ncenZahCel >npriUhrCel) .and. (ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0 .and. npriUhrCel <> 0' }  }

  ::quickFiltrs_withCustomizeAof:init( self, pa_quick, 'Závazky', ::pa_vazRecs, 2 )
  ::quickFiltrs_withCustomizeAof:pb_context:oxbp:gradientColors := {0,6}

  ::d_bro := d_bro
  *
  ** musíme pøehodit záhlaví sloupce, uložený BRO by mohl mít jiné
  if ::in_file = 'fakprihd'
    begin sequence
      for x := 1 to d_Bro:oxbp:colCount step 1
        ocol := d_Bro:oxbp:getColumn(x)
        if 'fin_prikuhit_fp_bc(7):k úhradì v ' $ lower(ocol:frmColum)
          ocol:heading:setCell( 1, '', XBPCOL_TYPE_TEXT)
          ocol:heading:setCell( 1, chead, XBPCOL_TYPE_TEXT)
    break
        endif
      next
    end sequence
  endif

  for x := 1 to len(members) step 1
    if  members[x]:ClassName() = 'drgPushButton'
      do case
      case members[x]:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
      case members[x]:event = 'save_marked'    ;  ::pb_save_marked := members[x]
      endcase
    endif
  next

  ::pb_save_marked:disable()
return self


method FIN_prikuhit_fp_SEL:drgDialogEnd()
  (::in_file)->(ads_clearAof())
return


METHOD FIN_prikuhit_fp_SEL:doPrevzit()
  LOCAL  pA := ::drgDialog:dialogCtrl:oaBrowse:arSELECT

  IF( Empty(pA), IF(FIN_prikuhit_fp_ZBY() > 0, AAdd(pA,FAKPRIHD ->(RecNo())), NIL ), NIL )
  ::drgDialog:cargo := pA
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN self