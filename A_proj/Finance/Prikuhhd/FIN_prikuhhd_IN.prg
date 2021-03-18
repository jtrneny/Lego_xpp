#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
//
#include "..\Asystem++\Asystem++.ch"
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
  var     cblock                               // pro omezení nabídky pro pøíkazy FIN/MZD
  var     in_file                              // vstupní soubor dle ctypPohybu - fakprihd/ mzdzavhd

  method  init, destroy
  method  drgDialogStart, postValidate, postLastField, postSave, checkItemSelected
  method  comboBoxInit, comboItemSelected

  method  fin_c_bankuc_sel, fin_prikuhit_fp_sel, fir_firmyUc_prik_sel


  inline method isfin_PrUhr()
    return ( ::in_file = 'fakprihd' )

  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1019
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    return self

  inline method prikuhhd_in_pzo()

    if ::iszah_PrUhr()
      if( (::it_file)->(eof()), ::state := 2, nil )

      if ::o_prikuhhd_IN_pzo = NIL
        ::o_prikuhhd_IN_pzo := drgDialog():new('FIN_prikuhhd_IN_pzo', ::drgDialog)
        ::o_prikuhhd_IN_pzo:create(,,.T.)
      else
        ::o_prikuhhd_IN_pzo:quickShow(.t.)
      endif
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

  inline access assign method obdobi_fin_mzd()
    return if( ::isfin_PrUhr(), 'OBD_fin', 'OBD_mzd' )

  inline access assign method prikuhit_fp_mz()
    return if( ::isfin_PrUhr(), 'èísloFaktury', 'èísloMzdZávazku' )


  inline access assign method prikuhit_fp_zby_fak() var prikuhit_fp_zby_fak
    local priUhrCel :=  if( isObject(::dm), ::dm:get( 'prikuhitw->npriuhrcel'), 0)
    local retVal    := 0

    retVal := ( (::in_file)->ncenZahCel - (::in_file)->nuhrCelFaz ) -priUhrCel
    return if( ::uhr_zavazku, retVal, 0)

  inline access assign method prikuhit_fp_zby() var prikuhit_fp_zby
    local priuhrPri := if( isObject(::dm), ::dm:get( 'prikuhitw->npriuhrpri'), 0)
    local retVal    := 0

    retVal := (( (::in_file)->ncenZahCel - (::in_file)->nuhrCelFaz ) * ::nkoe_prFa() ) -priUhrPri
    return if( ::uhr_zavazku, retVal, 0)

  *
  ** EVENT *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs, isEof := prikuhitw->(eof()), cky
    local  nsel

    if ::lnewRec
      if isNull( prikUhitw->sid,0) = 0
        ( ::cmb_typPohybu:isEdit := .t., ::cmb_typPohybu:oxbp:enable() )
      else
        ( ::cmb_typPohybu:isEdit := .f., ::cmb_typPohybu:oxbp:disable())
      endif
    endif

    do case
    case(nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::state :=  0

      (::in_file)->( dbseek( prikuhitW->ncisFak,, AdsCTag(1) ))
      if( isEof,::dm:set('prikuhitw->duhrbandne',::dm:get('prikuhhdw->dprikuhr')), nil)
      if( isEof, ::showGroup(.f.,.t.), ::showGroup())
      ::state_PZO()
      ::enable_or_disable_cucet()

      return .f.

    CASE nEvent = drgEVENT_APPEND

      ::dm:refreshAndSetEmpty( 'prikuhitw'  )

      ( ::oget_ucet:isEdit := .t., ::oget_ucet:oxbp:enable() )

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
       if mp1 = xbeK_ESC // .and. .not. isWorkVersion
         nsel := confirmBox(,'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                             'Data nebudou uložena ...'                     , ;
                              XBPMB_YESNO                                   , ;
                              XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                              XBPMB_DEFBUTTON2                                )

         if (nsel = XBPMB_RET_YES)
           if( isMethod(self,'postEscape'), ::postEscape(), nil)
           _clearEventLoop(.t.)

             if isObject(::dm)
               postAppEvent(xbeP_Close,,,::dm:drgDialog:dialog)
             endif
           return .f.
         else
           return .t.
         endif
       endif

       return .f.
     ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

 HIDDEN:
  METHOD  showGroup, itSave, copyfldto_w
  VAR     panGroup, msg, df, brow, hd_file, it_file, ischanged_dprikUhr
  var     zaklMena, zaklStat   , ctypUhr_for_PRIK
  var     o_priUhrCel          , o_priUhrPri
  var     o_prikuhit_fp_zby_fak, o_prikuhit_fp_zby
  var     o_prikuhhd_IN_pzo
  *
  var     o_nazev, o_ucet, o_bank_Naz
  var     cmb_typPohybu, ocmb_Obdobi, ovar_cisFirmy, oget_ucet, acombo_fin, acombo_mzd
  *
  **
  inline method enable_or_disable_cucet()
    local  is_Mzdy   := ( upper(prikuhhdw->csubTask) = 'MZD' )
    local  ncisFirmy, ncnt := 0
    local  lok       := .t.

*    if prikUhitW->sid <> 0
      if ::uhr_zavazku
        if is_Mzdy
          lok := .f.
        else
          ncisFirmy := ::ovar_cisFirmy:value
          firmyUc->( ordSetFocus('FIRMYUC1')           , ;
                     dbsetScope(SCOPE_BOTH, ncisFirmy ), ;
                     dbgoTop()                         , ;
                     dbeval( { || ncnt += 1 } )        , ;
                     dbclearScope()                      )

          lok := ( ncnt > 1 )
        endif

      else
        lok := .t.
      endif
*    endif

     ::oget_ucet:isEdit := lok
     if( lok, ::oget_ucet:oxbp:enable(), ::oget_ucet:oxbp:disable() )
  return self


  inline method state_PZO()
    local isOk := .t.

    if ::iszah_PrUhr()
      ::o_nazev:odrg:pushGet:oXbp:show()
      ::o_bank_Naz:odrg:pushGet:oXbp:show()

      if ::state = 2 .or. (::it_file)->(eof())
        * pøíjemce
        isOk := ( .not. empty( ::o_nazev:value         ) .and. ;
                  .not. empty( (::in_file)->cULICE     ) .and. ;
                  .not. empty( (::in_file)->CPSC       ) .and. ;
                  .not. empty( (::in_file)->CSIDLO     ) .and. ;
                  .not. empty( (::in_file)->CZKRATSTAT )       )
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
    else

      ::o_nazev:odrg:pushGet:oXbp:hide()
      ::o_bank_Naz:odrg:pushGet:oXbp:hide()
    endif
    return self


  inline method iszah_PrUhr()
    return (prikUhHdw->ctypDoklad = 'FIN_PRUHZA')

  inline method istuz_UcPr()
    return Equal( ::zaklMena, prikuhhdw ->czkratMenU)

  inline method istuz_UcFa()
    return Equal( ::zaklMena, (::in_file)->czkratMenZ )

  * pomocná metoda pro získání koeficientu pro pøepoèet faktury kurzem
  inline method nkoe_prFa()
    local  nkoe, ndecimals
    local  ncisFak := if( isObject(::dm), ::dm:get( 'prikuhitw->ncisFak'), 0)

    (::in_file)->( dbseek( ncisFak,, AdsCTag(1)) )

    * koeficienty pro pøepoèet kurem na 3 DM
    ndeciMals := Set( _SET_DECIMALS, 3 )

    do case
    case prikuhhdw->czkratMenU = (::in_file)->czkratMenZ
      nkoe := 1
    case ::istuz_UcPr() .and. .not. ::istuz_UcFa()       // pøíkaz v tuzemské mìnì - faktura v zahranicní
      kurzit->( dbseek( upper( (::in_file)->czkratMenZ),,'KURZIT9'))
      nkoe := kurzit->nkurzStred/ kurzit->nmnozPrep

    case .not. ::istuz_UcPr() .and. ::istuz_UcFa()       // pøíkaz v zahranicní mene - faktura v tuzemské
      nkoe := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen

    case .not. ::istuz_UcPr() .and. .not. ::istuz_UcFa() // pøíkaz v zahranicní mene - faktura zahranicní
      kurzit->( dbseek( upper( (::in_file)->czkratMenZ),,'KURZIT9'))
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
  local  ctypUhr := ''

  ::drgUsrClass:init(parent)
  *
  ( ::hd_file := 'prikuhhdw', ::it_file := 'prikuhitw', ::in_file := 'fakprihd' )
    ::lNEWrec := .not. (parent:cargo = drgEVENT_EDIT)

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
  ::ctypUhr_for_PRIK   := ""

  // SYS
  drgDBMS:open('C_BANKUC')
  drgDBMS:open('C_TYPUHR')
  drgDBMS:open('FAKPRIHD')
  drgDBMS:open('MZDZAVHD')
  drgDBMS:open('kurzit'  )

  drgDBMS:open('firmy'   )
  drgDBMS:open('firmyUc' )
  drgDBMS:open('ucetsys' )

  * pro pøíkazy k úhradì musíme vybrat z c_typUhr not lisInkaso and not lisHotov
  **
  c_typUhr->( dbeval( { || ctypUhr += c_typUhr->czkrTYPuhr +',' }, ;
                      { || .not. c_typUhr->lisInkaso .and. .not. c_typUhr->lisHotov } ))
  if len(ctypUhr) <> 0
    ctypUhr := left(ctypUhr, len(ctypUhr) -1 )
    ctypUhr += "'"

    ::ctypUhr_for_PRIK := " .and. czkrTYPuhr $ '" +ctypUhr
  endif

  * pro combo možnost pøepnutí na období kde je nìco potøeba hradit
  drgDBMS:open( 'fakPrihd',,,,,'fakPri_Cx')
  drgDBMS:open( 'mzdZavHD',,,,,'mzdZav_Cx')

  FIN_prikuhhd_cpy(self)
  *
  ** pøi opravì musíme pøehodit vstupní soubor dle typu pøíkazu
  ::in_file := if( upper((::hd_file)->csubTask) = 'MZD', 'mzdzavhd', 'fakprihd' )

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

  ::cmb_typPohybu         := ::dm:has('prikuhHdw->ctyppohybu' ):odrg
  ::ocmb_Obdobi           := ::dm:has('prikuhHdw->cobdobi'    )

  ::o_priUhrCel           := ::dm:has('prikuhitw->npriUhrCel' )
  ::o_prikuhit_fp_zby_fak := ::dm:has('M->prikuhit_fp_zby_fak')

  ::o_priUhrPri           := ::dm:has('prikuhitw->npriUhrPri' )
  ::o_prikuhit_fp_zby     := ::dm:has('M->prikuhit_fp_zby'    )

  ::o_ucet                := ::dm:has('prikuhItw->cucet'      )
  ::o_nazev               := ::dm:has('prikuhItw->cnazev'     ) // Pøíjemce
  ::o_bank_Naz            := ::dm:has('prikuhItw->cBank_naz'  ) // Název banky

  * specielní položky pro kortolu editace položky cucet
  ::ovar_cisFirmy         := ::dm:has('prikuhItw->ncisFirmy'  )  // drgVar
  ::oget_ucet             := ::dm:has('prikuhItw->cucet'      ):odrg

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
  ::enable_or_disable_cucet()
  ::sumColumn(7)
  ::dm:refresh()
RETURN self


method FIN_prikuhhd_IN:comboBoxInit(drgComboBox)
  local  cname := lower( drgParseSecond(drgComboBox:name,'>'))
  local  acombo_val
  local  acombo_fin, acombo_mzd


  do case
  case cname = 'cobdobi'

    ::acombo_fin := acombo_fin := {}
    ::acombo_mzd := acombo_mzd := {}
    *
    ** jako první, musíme pøidat aktální obdbí FIN a MZD
    aadd( acombo_fin, { uctOBDOBI:FIN:COBDOBI                                                , ;
                        strZero(uctOBDOBI:FIN:NOBDOBI,2) +'/' +StrZero( uctOBDOBI:FIN:NROK,4), ;
                        strZero(uctOBDOBI:FIN:NROK,4) +StrZero( uctOBDOBI:FIN:NOBDOBI,2)     , ;
                        uctOBDOBI:FIN:NROK                                                   , ;
                        uctOBDOBI:FIN:NOBDOBI                                                  } )

    aadd( acombo_mzd, { uctOBDOBI:MZD:COBDOBI                                                , ;
                        strZero(uctOBDOBI:MZD:NOBDOBI,2) +'/' +StrZero( uctOBDOBI:MZD:NROK,4), ;
                        strZero(uctOBDOBI:MZD:NROK,4) +StrZero( uctOBDOBI:MZD:NOBDOBI,2)     , ;
                        uctOBDOBI:MZD:NROK                                                   , ;
                        uctOBDOBI:MZD:NOBDOBI                                                  } )


    fakPri_Cx->( ads_setAof( '(ncenZahCel >npriUhrCel) .and. (ncenZahCel - nuhrCelFaz) <> 0' ) )
    fakPri_Cx->( dbeval( { || ;
      if( ascan( acombo_fin, { |x| x[1] = fakPri_Cx->cobdobi }) = 0, ;
          aadd ( acombo_fin, { fakPri_Cx->cobdobi                                            , ;
                               StrZero(fakPri_Cx->nobdobi,2) +'/' +StrZero(fakPri_Cx->nrok,4), ;
                               StrZero(fakPri_Cx->nrok,4) +StrZero(fakPri_Cx->nobdobi,2)     , ;
                               fakPri_Cx->nrok                                               , ;
                               fakPri_Cx->nobdobi  }), nil  ) } ) )

    mzdZav_Cx->( ads_setAof( '(ncenZahCel >npriUhrCel) .and. (ncenZahCel - nuhrCelFaz) <> 0' ) )
    mzdZav_Cx->( dbeval( { || ;
      if( ascan( acombo_mzd, { |x| x[1] = mzdZav_Cx->cobdobi }) = 0, ;
          aadd ( acombo_mzd, { mzdZav_Cx->cobdobi                                            , ;
                               StrZero(mzdZav_Cx->nobdobi,2) +'/' +StrZero(mzdZav_Cx->nrok,4), ;
                               StrZero(mzdZav_Cx->nrok,4) +StrZero(mzdZav_Cx->nobdobi,2)     , ;
                               mzdZav_Cx->nrok                                               , ;
                               mzdZav_Cx->nobdobi  }), nil  ) } ) )

    acombo_val := if( ::isfin_PrUhr(), acombo_fin, acombo_mzd )

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[3] < aY[3] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    if empty(prikUhhdw->cobdobi)
      (::hd_file) ->cobdobi  := acombo_val[1,1]
      (::hd_file) ->nrok     := acombo_val[1,4]
      (::hd_file) ->nobdobi  := acombo_val[1,5]
    endif
    drgComboBox:value := drgComboBox:ovar:value := prikUhhdw->cobdobi

  otherwise

    ::fin_finance_in:comboBoxInit(drgComboBox)
  endcase
return self


method FIN_prikuhhd_IN:comboItemSelected(drgComboBox,mp2,o)
  local  name  := lower(drgComboBox:name)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin,pa
  local  drgCombo_obd := ::ocmb_Obdobi:odrg, acombo_val

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

    ::in_file               := if( upper(values[nin,6]) = 'MZD', 'mzdzavhd', 'fakprihd'    )
    ::dm:set( 'M->prikuhit_fp_mz', if( ::isfin_PrUhr(), 'èísloFaktury', 'èísloMzdZávazku' ))
    ::dm:set( 'M->obdobi_fin_mzd', if( ::isfin_PrUhr(), 'OBD_fin'     , 'OBD_mzd'         ))

    if ::isfin_PrUhr()
      (::hd_file) ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI
      (::hd_file) ->nROK       := uctOBDOBI:FIN:NROK
      (::hd_file) ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI
    else
      (::hd_file) ->cOBDOBI    := uctOBDOBI:MZD:COBDOBI
      (::hd_file) ->nROK       := uctOBDOBI:MZD:NROK
      (::hd_file) ->nOBDOBI    := uctOBDOBI:MZD:NOBDOBI
    endif

    acombo_val := if( ::isfin_PrUhr(), ::acombo_fin, ::acombo_mzd )

    drgCombo_obd:oXbp:clear()
    drgCombo_obd:values := ASort( acombo_val,,, {|aX,aY| aX[3] < aY[3] } )
    aeval(drgCombo_obd:values, { |a| drgCombo_obd:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgCombo_obd:value := ''
    drgCombo_obd:refresh(prikUhhdw->cobdobi)

  case(name = ::hd_file +'->cobdobi' )
    if drgComboBox:ovar:itemChanged()
      nin := ascan(values,{|x| x[1] = value })

      (::hd_file) ->cobdobi  := values[nin,1]
      (::hd_file) ->nrok     := values[nin,4]
      (::hd_file) ->nobdobi  := values[nin,5]

      PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgComboBox:oxbp)
    endif

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
    case prikuhhdw->czkratMenU = (::in_file)->czkratMenZ
      nkoe := 1
    case ::istuz_UcPr() .and. .not. ::istuz_UcFa()       // pøíkaz v tuzemské mìnì - faktura v zahranicní
      kurzit->( dbseek( upper( (::in_file)->czkratMenZ),,'KURZIT9'))
      nkoe := kurzit->nkurzStred/ kurzit->nmnozPrep

    case .not. ::istuz_UcPr() .and. ::istuz_UcFa()       // pøíkaz v zahranicní mene - faktura v tuzemské
      nkoe := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen

    case .not. ::istuz_UcPr() .and. .not. ::istuz_UcFa() // pøíkaz v zahranicní mene - faktura zahranicní
      kurzit->( dbseek( upper( (::in_file)->czkratMenZ),,'KURZIT9'))
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
    if ::uhr_zavazku
      ok := ::fir_firmyUc_prik_sel()
    else
      ok := .not. Empty(value)
    endif

  case (name = 'prikuhitw->npriuhrcel')
    ok := (value > 0)
    if ok .and. ::uhr_zavazku
      ok := if( ::isfin_PrUhr(), ( FIN_prikuhit_fp_ZBY() >= 0 ), ( FIN_prikuhit_mz_ZBY() >= 0 ) )
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
                          ::copyfldto_w( ::in_file, ::it_file)
                          (::it_file)->ncisfak_or := cisfak_or
                       endif
                       ::copyfldto_w(::hd_file,::it_file,,.f.)
    endif

    if isObject(::o_prikuhhd_IN_pzo)
      ::itSave( ,::o_prikuhhd_IN_pzo:UDCP:dm )
      ::o_prikuhhd_IN_pzo := NIL
    else
      * pøíjemce
      prikUhItW->cNazev     := ::o_nazev:value
      prikUhItW->cULICE     := (::in_file)->cULICE
      prikUhItW->CPSC       := (::in_file)->CPSC
      prikUhItW->CSIDLO     := (::in_file)->CSIDLO
      prikUhItW->CZKRATSTAT := (::in_file)->CZKRATSTAT
      prikUhItW->cDIC       := (::in_file)->cDIC

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
  local file_name, value := ::cmb_typPohybu:value

  ok := FIN_prikuhhd_wrt(self)

  if(ok .and. ::lnewRec)

    (::it_file)->(DbCloseArea())
    prikuhi_w  ->(DbCloseArea())

    fin_prikuhhd_cpy(self)

    file_name := (::it_file)->( DBInfo(DBO_FILENAME))
                 (::it_file)->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'prikuhi_w', .t., .t.) ; prikuhi_w ->(AdsSetOrder(1))

    ::cmb_typPohybu:value := value
    ::comboItemSelected(::cmb_typPohybu)

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
  local  isfin_PrUhr := ::isfin_PrUhr()

  ::cfiltr_fp_sel := if( ::iszah_PrUhr(), ;
                         format( "upper(czkratStat) <> '%%'", { upper(::zaklStat) }), ;
                         format( "upper(czkratStat) =  '%%'", { upper(::zaklStat) })  )

  ::cfiltr_fp_sel += ::ctypUhr_for_PRIK
  ::pa_vazRecs    := pa

  prikuhi_w->( dbeval( { || aadd( pa, prikuhi_w->ncisfak_or) }, ;
                       { || prikuhi_w->ncisfak_or <> 0       }) )

  if .not. empty(pa)
    (::in_file)->( ads_setAof('.T.'))
    (::in_file)->( ads_customizeAOF( pa, 3))
  endif

  lok := ( lok .and. FIN_prikuhit_fv_SEEK( value, isfin_PrUhr, ::in_file ) )
  lok := ( lok .and. if( ::iszah_PrUhr(), .not. Equal( ::zaklStat, (::in_file)->czkratStat), ;
                                                Equal( ::zaklStat, (::in_file)->czkratStat)  ))

  if( .not. empty(pa), (::in_file)->(ads_customizeAOF( pa, 1)), nil)


  IF IsObject(drgDialog) .or. .not. lOk
    if isfin_PrUhr
      DRGDIALOG FORM 'FIN_prikuhit_fp_SEL' PARENT ::drgDialog MODAL EXITSTATE nExit
    else
      DRGDIALOG FORM 'FIN_prikuhit_mz_SEL' PARENT ::drgDialog MODAL EXITSTATE nExit
    endif

    arSelect := oDialog:UDCP:d_bro:arSELECT
    oDialog:destroy(.T.)
    oDialog  := NIL
  endif

  IF nExit != drgEVENT_QUIT .or. (lOk .and. drgVar:changed())
    if len( arSelect) > 0
      for x := 1 to len( arSelect) step 1
        (::in_file)->( dbgoTo( arSelect[x] ))

        ZBY_uhradit := if( isfin_PrUhr, FIN_prikuhit_fp_ZBY(), FIN_prikuhit_mz_ZBY() )

        prikuhit_SET_data( ::dm, ZBY_uhradit, isfin_PrUhr, ::in_file )
        ::postLastField()
      next
    ELSE                                                                        //edituje dál
      ZBY_uhradit := if( isfin_PrUhr, FIN_prikuhit_fp_ZBY(), FIN_prikuhit_mz_ZBY() )

      IF ( ZBY_uhradit > 0 )

        prikuhit_SET_data( ::dm, ZBY_uhradit, isfin_PrUhr, ::in_file )
      ELSE
        ::msg:writeMessage('Na fakturu již byl vystaven pøíkaz k úhradì ...',DRG_MSG_WARNING)
      ENDIF
    ENDIF

    ::state_PZO()
    ::enable_or_disable_cucet()
  ENDIF

  if( .not. empty(pa), (::in_file)->(ads_clearAof()), nil)
RETURN (nExit != drgEVENT_QUIT)


static function prikuhit_SET_data( dm, ZBY_uhradit, isfin_PrUhr, in_file )

  firmyUc->( dbseek( upper( (in_file)->cucet),,'FIRMYUC2'))

  dm:set('prikuhitw->ncisfak'   , (in_file) ->nCISFAK     )
  dm:set('prikuhitw->ctextPol'  , (in_file) ->cNAZEV      )
  dm:set('prikuhitw->cnazev'    , (in_file) ->cNAZEV      )
  dm:set('prikuhitw->cucet'     , (in_file) ->cucet       )
  dm:set('prikuhitw->cvarsym'   , (in_file) ->cVARSYM     )
  dm:set('prikuhitw->nkonstsymb', (in_file) ->nKONSTSYMB  )
  dm:set('prikuhitw->cspecsymb' , (in_file) ->cSPECSYMB   )
  dm:set('prikuhitw->ncenzakcel', (in_file) ->nCENZAKCEL  )

  * z fakprihd
  dm:set('prikuhitw->czkratMenZ', (in_file) ->czkratMenZ  )
  dm:set('prikuhitw->npriuhrcel', if( isfin_PrUhr, FIN_prikuhit_fp_ZBY_FAK(), FIN_prikuhit_mz_ZBY_FAK() ) )

  * z prikuhhdw
  dm:set('prikuhitw->czkratMenU', prikUhHdw ->czkratMenU  )
  dm:set('prikuhitw->npriuhrpri', ZBY_uhradit             )

  dm:set('prikUhitw->cbank_naz' , firmyUc->cbank_naz      )
  dm:set('prikuhitw->ncisfak_or', (in_file)->(recno())    )
  dm:set('prikuhitw->cobdobi'   , (in_file)->cobdobi      )
  dm:set('prikuhitw->nrok'      , (in_file)->nrok         )
  dm:set('prikuhitw->nobdobi'   , (in_file)->nobdobi      )
  dm:set('prikuhitw->cdenik'    , (in_file)->cdenik       )

  dm:set('prikuhitw->ncisFirmy' , (in_file)->ncisFirmy    )
return .t.


method FIN_prikuhhd_IN:fir_firmyUc_prik_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, pa_cargo_usr
  local  lok := .f., cky := strZero(::ovar_cisFirmy:value,5) +upper(::o_ucet:value)

  lok := firmyUc->( dbseek( cky,,'FIRMYUC5'))

  if isObject(drgDialog) .or. .not. lok
    odialog           := drgDialog():new('fir_firmyUc_prik_sel',::drgDialog)
    odialog:cargo_Usr := ::ovar_cisFirmy:value
    odialog:create(,,.T.)
  endif

  if (lok .and. ::o_ucet:itemChanged())
  elseif nexit = drgEVENT_SAVE
    lok := .t.
  endif

  if lok
    ::o_ucet:set( firmyUc->cucet)
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,, ::oget_ucet:oxbp )
  endif
return lok



**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_prikuhhd_IN:showGroup(inGrid,inCheck)
  LOCAL  nIn, NoEdit := GraMakeRGBColor( {221, 221, 221} )
  LOCAL  pA  := {'m->uhr_zavazku'                                , ;
                 'prikuhitw->ncisfak'   , 'prikuhitw->cucet'     , ;
                 'prikuhitw->cvarsym'   , 'prikuhitw->nkonstsymb', 'prikuhitw->cspecsymb'  }
  LOCAL  drgVar, dm := ::dataManager, UHR_zavazku

  DEFAULT inGrid TO .T.

  ::UHR_zavazku := IF(inGrid, If( PRIKUHITw ->cDENIK = '  ', .F., .T.), IsNull(inCheck,.F.))

  FOR nIn := 1 TO LEN(pA)
    drgVar := dm:has(pA[nIn]):oDrg

    DO CASE
    CASE drgVar:ClassName() = 'drgGet'
      UHR_zavazku := IF(inGrid, ::UHR_zavazku, IF((nIn = 2 .or. nIn = 3), .F., inCheck))
      drgVar:isEdit := .not. UHR_zavazku
      drgVar:oXbp:setColorBG(IF( drgVar:isEdit, drgVar:clrFocus, NoEdit))

      if nIn = 3
        if( drgVar:isEdit, drgVar:oXbp:enable(), drgVar:oXbp:disable() )
      endif

      IF IsObject(drgVar:pushGet) .and. ( nIn = 2 .or. nIn = 3 )
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


static function FIN_prikuhit_fv_SEEK( value, isfin_PrUhr, in_file )
  local  ok := .f.

  if (in_file)->(dbSeek(value,, AdsCTag(1)) )
    if isfin_PrUhr
      ok :=             FIN_prikuhit_fp_ZBY() > 0
      ok := ( ok .and. (FIN_prikuhit_fp_BC(0) = 0))
    else
      ok :=             FIN_prikuhit_mz_ZBY() > 0
      ok := ( ok .and. (FIN_prikuhit_mz_BC(0) = 0))
    endif
  endif
return ok

*
** CLASS for fir_firmyUc_prik_sel **********************************************
**           úèty se nabízejí jen pro konkrétní firmu
class fir_firmyUc_prik_sel from drgUsrClass
exported:
  *
  ** bro col
  inline access assign method is_aktivni() var is_aktivni
    return if( firmyuc->lAktivni, MIS_ICON_OK, MIS_NO_RUN )

  *
  **
  inline method init(parent)
    local  nEvent,mp1,mp2,oXbp
    local  cisFirmy := parent:cargo_Usr

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if IsOBJECT(oXbp:cargo)
      ::drgGet := oXbp:cargo
    endif

    firmyUc->( ordSetFocus('FIRMYUC1')          , ;
               dbsetScope(SCOPE_BOTH, cisFirmy ), ;
               dbgoTop()                          )

    firmy->( dbseek( cisFirmy,,'FIRMY1' ))

    ::drgUsrClass:init(parent)
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = drgEVENT_EDIT
      ::itemSelected()
      return .t.
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
    return .f.


  inline method getForm()
    local  oDrg, drgFC := drgFormContainer():new()
    local  cnazev := allTrim(firmy->cnazev)

    DRGFORM INTO drgFC SIZE 53.5,10 DTYPE '10' TITLE 'Výbìr banovního úètu firmy ..... ' ;
                                             GUILOOK 'All:N,Border:Y' BORDER 4

      DRGSTATIC INTO drgFC FPOS .5,0 SIZE 52.3,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
        odrg:ctype := 2

        DRGTEXT INTO drgFC CAPTION 'Výbìr bankovních úètù firmy ... ' CPOS   .5, .1 CLEN 25
        DRGTEXT INTO drgFC CAPTION cnazev                             CPOS 26.5, .1 CLEN 25 FONT 5
      DRGEND  INTO drgFC


      DRGDBROWSE INTO drgFC FPOS -.5,1.3 SIZE 53,7 FILE 'firmyUc' ;
        FIELDS 'M->is_Aktivni:a:2.4::2,'   + ;
               'cucet:èíslo Úètu:25,'      + ;
               'cbank_Naz:název Banky:25'    ;
        SCROLL 'nn' CURSORMODE 3 PP 7POPUPMENU 'n'

      DRGSTATIC INTO drgFC FPOS .2,8.25 SIZE 52.3,1.6 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
        odrg:ctype := 2

        DRGPUSHBUTTON INTO drgFC CAPTION '   ~Ok'    ;
                                 POS 24,.3           ;
                                 SIZE 13,1.1         ;
                                 ATYPE 3             ;
                                 ICON1 429           ;
                                 ICON2 430           ;
                                 EVENT 'itemSelected' TIPTEXT 'Pøevzít úèet do položky dokladu ...'

        DRGPUSHBUTTON INTO drgFC CAPTION '   ~Storno' ;
                                 POS 38,.3            ;
                                 SIZE 13,1.1          ;
                                 ATYPE 3              ;
                                 ICON1 102            ;
                                 ICON2 202            ;
                                 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
      DRGEND  INTO drgFC

   return drgFC


   inline method drgDialogInit(drgDialog)
     local  aPos, nSize
     local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

     XbpDialog:titleBar := .F.
*     drgDialog:dialog:drawingArea:bitmap  := 1016
*     drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

     if isObject(::drgGet)
       nSize := ::drgGet:oxbp:currentSize()[1]
       aPos  := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
       drgDialog:usrPos := {aPos[1] -160,aPos[2]}
     endif
  return self

  inline method itemSelected()
    PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
    return self

  inline method drgDialogEnd(drgDialog)
     firmyUc->( dbClearScope())
  return self

hidden:
  var drgGet

endClass