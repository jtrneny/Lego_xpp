#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
#include "common.ch"
#include "drg.ch"
#include "CLASS.CH"

#include "..\Asystem++\Asystem++.ch"
#include "..\Mzdy\Kmenove\MZD_kmenove_.ch"


*
** CLASS MZD_kmenove_IN ********************************************************
CLASS MZD_kmenove_IN
EXPORTED:
  var    msg, dm, dc, df, ab
  var    tabNum, ontabSelect, pao_brow
  var    state, oactive_Brow, pa_focusOnEdit, paoB_editParent
  *
  var    pa_vazRecs, valSel

  *      definované výkonné bloky pro ins, a pøebírání do msPrc_moW v metodì SEL
  var    b_INSERT
  var    b_OSOBY_MSPRC_MOW
  var    b_MSPRC_MO_MSPRC_MOW
  var    b_MSPRC_MO_MSPRC_MOW_Pv
  var    b_MSPRC_MOW_PRSMLDOH
  var    b_MSPRC_MOW_MSOSB_MO


  inline method comboBoxInit(drgComboBox)
    local  acombo_val := {}, ky, block := { || .t. }, onSort := 2
    *
    local  cisFirmy, pohZavFir, textFakt

    do case
    case( 'cpohzavfir' $ lower(drgComboBox:name) )
      acombo_val := { { '          ', '                          ' } }
      trvZavhd->( dbgotop())

      do while .not. trvZavhd ->(eof())
        c_typPoh->( dbseek( upper(trvZavhd->culoha)     + ;
                            upper(trvZavhd->ctypDoklad) + ;
                            upper(trvZavhd->ctypPohybu),,'C_TYPPOH05'))

        if c_typPoh->ntrZaDoSrz = 1
          cisFirmy  := trvZavhd->ncisFirmy

          pohZavFir := trvZavhd ->ctyppohybu +if( cisFirmy <> 0, strZero(cisFirmy,5)       , '     ' )
          textFakt  := trvZavhd ->ctextfakt  +if( cisFirmy <> 0, ' [' +str(cisFirmy,5) +']', ''      )

          aadd( acombo_val, { pohZavFir              , ;
                              textfakt               } )
        endif
        trvZavhd->(dbskip())
      endDo

      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * musíme nastavit startovací hodnotu *
      drgComboBox:value := drgComboBox:ovar:value
    endcase
    return self


  inline method comboItemSelected(drgComboBox,isMarked)
    local  cname := lower( drgParseSecond(drgComboBox:name,'>'))
    local  value := drgComboBox:Value
    *
    do case
    case( 'cpohzavfir' $ cname )
      trvZavHd->( dbseek( upper(value),,'TRVZAVHD02'))
      ::dm:set( 'M->cnazFirmy', trvZavHd->cnazev )
    endcase
    return self


  inline method restColor()
    local  members := ::df:aMembers
    local  brow, nin, npos := 0
    *
    local  pao_brow := ::pao_brow, tabNum := ::tabNum

    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.


  inline method setFocus_onTab( refreshAll )
    local  nIn, zkr_skup, cky, brow
    *
    local  pao_brow := ::pao_brow, tabNum := ::tabNum
    local  drgVar   := ::pa_focusOnEdit[::tabNum]

    default refreshAll to .f.

    if( nIn := ascan(pao_brow, {|x| x[3] = tabNum })) <> 0
      ::df:olastdrg   := ::pao_brow[nIn,2]
      ::df:nlastdrgix := ::pao_brow[nIn,1]
      ::dm:drgDialog:lastXbpInFocus := ::pao_brow[nIn,2]:oxbp

      ::dc:oaBrowse := ::pao_brow[nIn,2]
      brow := ::dc:oaBrowse:oXbp
      ::dm:refresh()

      if( isObject(drgVar), ;
          ( drgVar:odrg:isEdit           := .f., ;
            drgVar:odrg:pushGet:disabled := .t., ;
            drgVar:odrg:oxbp:disable()           ), nil )

      if( refreshAll, ( brow:refreshAll(), ::restColor(), setAppFocus(brow) ), nil )
    endif
    return .t.


  inline method postValidate_onTabs(m_file)
    local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
    local  drgVar
    *
    begin sequence
      for x := 1 to size step 1
        file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

        if file = m_file .and. values[x,2]:odrg:isEdit

          drgVar := values[x,2]

          if .not. ::postValidate(drgVar, .t.)

            ::df:olastdrg   := values[x,2]:odrg
            ::df:nlastdrgix := x
            ::df:olastdrg:setFocus()
            return .f.
    break
          endif
        endif
      next
    end sequence
    return .t.

  inline method save_onTabs( cfile )
    local  pa
    local  npor    := (cfile)->( Ads_getLastAutoinc()) +1
    local  lnewRec := ((cfile)->(eof()) .or. ::state = 2)
    local  cky

    do case
    case( cfile = 'mssrz_mow' )
      * nový záznam
      if( lnewRec, mh_copyFld( 'msprc_mow', 'mssrz_mow', .t. ), nil )
      ::dm:save()
      if( lnewRec, (cfile)->_nrecor := 0, nil )

      c_srazky->( dbseek( upper( (cfile)->czkrSrazky),,'C_SRAZKY01'))

      (cfile)->nprednPohl := if( (cfile)->lPrednPohl, 1, 2)
      (cfile)->ntypSrz    := c_srazky->ntypSrz
      (cfile)->ctypSrz    := c_srazky->ctypSrz

      cky := upper(msSrz_mow->cpohZavFir)

      if trvZavHd->( dbseek( cky,,'TRVZAVHD02'))
      else
        cky := left( cky, 10) +'00000'
        trvZavHd->( dbseek( cky,,'TRVZAVHD02'))
      endif

      (cfile)->ctypPohZav := trvZavhd ->ctyppohybu
      (cfile)->ncisFirmy  := trvZavhd ->ncisFirmy
      (cfile)->ntrvZavHd  := isNull( trvZavHd ->sID, 0)

      * pro generování pøíkazu k úhradì
      (cfile)->cZkratStat := SysConfig( 'System:cZkrStaOrg' )
      (cfile)->czkratMeny := SysConfig( 'Finance:cZaklMENA' )
      (cfile)->czkratMenZ := SysConfig( 'Finance:cZaklMENA' )
      (cfile)->nMNOZPREP  := 1
      (cfile)->nKURZAHMEN := 1

      * cucet
      if .not. empty( (cfile)->cuceti +(cfile)->ckodBanky )
        (cfile)->cucet := allTrim((cfile)->cuceti ) +'/' +allTrim((cfile)->ckodBanky )
      endif

      * poøadí uplatnìní srážky
      (cfile)->nporadi := (cfile)->nporUplSrz
      ::msSrz_moW_poradiSrazky()

    case( cfile = 'vazosobyw' )
      pa := ::pa_vazRecs[1]

      * nový záznam
      if lnewRec
        mh_copyFld( 'osoby_Rp', 'vazOsobyW', .t. )

       (cfile)->nOSOBY    := isNull( osoby_Rp->sID, 0)  /// ::valSel
       (cfile)->ncisosoby := osoby_Rp->ncisOsoby
       aadd( pa, osoby_Rp->(recNo()) )
      endif
      (cfile)->ddatNaroz  := ::dm:get( cfile +'->ddatNaroz' )
      (cfile)->crodCisOsb := ::dm:get( cfile +'->crodCisOsb')
      (cfile)->ctypRodPri := ::dm:get( cfile +'->ctypRodPri')
      (cfile)->lsleOdpDan := ::dm:get( cfile +'->lsleOdpDan')

   case( cfile = 'duchodyw'  )
     if( lnewRec, ((cfile)->(dbappend()),(cfile)->nporDuchod  := npor), nil )

     (cfile)->ckmenStrPr := msPrc_moW->ckmenStrPr
     (cfile)->crodCisPra := msPrc_moW->crodCisPra
     (cfile)->cpracovnik := msPrc_moW->cpracovnik
     (cfile)->cnazDuchod := c_duchod ->cnazDuchod
     (cfile)->cnazev     := firmy    ->cnazev
**     ::dm:save()
     ::save_x(cfile)

   endcase
   return .t.

  inline method save_x(cfiles)
    local  x, drgVar, cfile
    local  vars := ::dm:vars

     for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
      cfile := lower(drgParse(drgVar:name,'-'))

      if( cfile $ lower(cfiles) ) .and. isblock(drgvar:block)
        if ( eval(drgvar:block) <> drgVar:value )
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next
    return self


  inline method start_SEL_inThread(cformName)
    local  oThread
    local  nevent, mp1 := NIL, mp2 := NIL, oXbp := NIL

    oThread := drgDialogThread():new()
    oThread:start( ,cformName, ::dm:drgDialog, .t.)

    do while .not. ( nEvent = drgDIALOG_END )
      nEvent := AppEvent( ,,,0 )
    endDo
    return

  inline method relForText( all_onTab)
    local  cfile := ''
    local  drgvar   := ::dm:has('vazOsobyW->ncisOsoby')
    *
    default all_onTab to .f.
    *
    do case
    case ::tabNum = TAB_rodPrislusnici
      osoby_Rp  ->( dbseek( vazOsobyW->nOSOBY   ,, 'ID'         ))
      c_psc_2   ->( dbseek( osoby_Rp->cpsc      ,, 'C_PSC1'     ))
      c_staty_2 ->( dbseek( osoby_Rp->czkratStat,, 'C_STATY1'   ))
      cfile := 'vazOsobyW,osoby_Rp,c_psc_2,c_staty_2'
    endCase

    if( .not. empty(cfile), ::refreshGroup( cfile,,, all_onTab ), nil )
    return self


  inline method refreshGroup(cfiles, drgVar, nextFocus, all_onTab)
    local  nin, ovar, new_val, dbarea, ok
    local  cfile
    local  vars := ::dm:vars
    *
    local  xValue
    local  pa    := listAsArray( lower(cfiles))

    default nextFocus to .f., all_onTab to .f.

    for nIn := 1 TO vars:size() step 1
      oVar  := vars:getNth(nIn)
      cfile := lower(drgParse(oVar:name,'-'))

      if( ascan( pa, cfile) <> 0) .and. isblock(ovar:block) .and. if( ::state = 2 .or. all_onTab, .t., oVar:rOnly)
        new_val := eval(ovar:block)

        if ::state = 2 .and. isNull(drgvar)
          type   := valType( new_val )
          xvalue := if( type = 'C' .or. type = 'M', space( len( ovar:value)), ;
                     if( type = 'D', ctod('')                               , ;
                      if( type = 'L', .f.                                   , ;
                       if( type = 'N', 0, nil                                 ))))

          if type = 'N'
            if (npos := at('.', new_val := str( new_val ))) <> 0
              xValue := val( '0.' +replicate( '0', len(new_val) - npos))
            endif
          endif

          new_val := xValue
        endif

        ovar:set(new_val)
        ovar:initValue := ovar:prevValue := ovar:value
      endif
    next

    * naplníme prázdnou hodnotu první prvek na kartì pro vstup pri INS
    if ::state = 2 .and. isNull(drgvar)
      drgVar  := ::pa_focusOnEdit[::tabNum]
      new_Val := if( ::tabNum = TAB_rodPrislusnici, 0, '' )

      if isObject(drgVar)
        drgVar:set(new_Val)
        drgVar:initValue := drgVar:prevValue := drgVar:value
      endif
    endif

    if nextFocus
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
    endif
    return .t.


  inline method MZD_copy_tomsPrc( cansWer_SEL )
    local  pa         := { 'cprijOsob', 'cjmenoOsob', 'crozlJmena' }
    local  pa_vazRecs := ::pa_vazRecs
    *
    local  cky        := strZero(osoby->noscisPrac,5)

    do case
    * 01 z osob nový zamìstnanec
    case( canswer_SEL = '01' )
      mh_copyFld('osoby', 'msPrc_moW')
      msPrc_moW->nOSOBY := isNull( osoby->sID, 0)

      mh_copyFld('osoby', 'osobyW',, .t. )
      aadd( pa_vazRecs[1], osoby->(recNo()) )

      MZD_kmenove_cpy( self, .t. )

      eval( ::b_OSOBY_MSPRC_MOW )

      msPrc_moC->( ordsetFocus('MSPRMO09'), dbgoBottom())
      ::dm:set( "msPrc_moW->noscisPrac", msPrc_moC->noscisPrac +1)
      msPrc_moW->nporPraVzt := 1

    * 11 z msPrc_moC bez kopie pøedchozího Pv
    * 12 z msPrc_moC   s kopií pøedchozího Pv
    * 13 z msPrc_moC     nové  oscisPrac   Pv = 1
    case( canswer_SEL = '11' .or. ;
          canswer_SEL = '12' .or. ;
          canswer_SEL = '13'      )

      msPrc_moC->( ordSetFocus( 'MSPRMO15')    , ;
                   dbsetScope( SCOPE_BOTH, cky), ;
                   dbgoBottom()                  )

      mh_copyFld( 'msPrc_moC', 'msPrc_moW' )
      msPrc_moC->(dbclearScope())

      mh_copyFld('osoby', 'osobyW',, .t. )
      aadd( pa_vazRecs[1], osoby->(recNo()) )

      MZD_kmenove_cpy( self, .t., .not. msPrc_moC->lstavem )

      if canswer_SEL = '11'
        eval( ::b_MSPRC_MO_MSPRC_MOW )
      else
        eval( ::b_MSPRC_MO_MSPRC_MOW_Pv )
      endif

      if canswer_SEL = '13'
        msPrc_moC->( ordsetFocus('MSPRMO09'), dbgoBottom())
        ::dm:set( "msPrc_moW->noscisPrac", msPrc_moC->noscisPrac +1)
        msPrc_moW->nporPraVzt := 1
      else
        msPrc_moW->nporPraVzt := msPrc_moC->nporPraVzt +1
      endif
    endcase

    ** all
    ::dm:save()
    setAppFocus( ::pao_brow[1,2]:oxbp )
    ::dm:refresh()

    for x := 1 to len(pa) step 1
      drgvar := ::dm:has('msPrc_moW->' +pa[x])

      drgVar:odrg:isEdit := .f.
      drgVar:odrg:oXbp:disable()
    next

    ::df:setNextFocus( 'msPrc_moW->ctitulPred',, .T. )
    return .t.


** Typ evidenèního vztahu - ntypPraVzt - MZD_mimoprvz_CRD
  inline method MZD_mimoprvz_CRD()
    local  oDialog, nexit, nmimoPrVzt := 0
    *
    local  odrg := ::dm:has('msprc_moW->nmimoPrVzt'):odrg

    DRGDIALOG FORM 'MZD_mimoprvz_CRD' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

    if mimPrvzW->( dbLocate( { || mimPrvzW->lAktiv } ))
      nmimoPrVzt := mimPrvzW->nmimoPrVzt
    endif
    ::dm:set( 'msprc_moW->nmimoPrVzt', nmimoPrVzt )

    postAppEvent(xbeP_Keyboard, xbeK_RETURN,,odrg:oXbp)
    return self

** Typ dùchodu            - ntypDuchod - MZD_duchody_CRD
  inline method MZD_duchody_CRD()
    local  oDialog, nexit, ntypDuchod := 0
    *
    local  odrg := ::dm:has('msprc_moW->ntypDuchod'):odrg

    DRGDIALOG FORM 'MZD_duchody_CRD' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

    if duchodyW->( dbLocate( { || duchodyW->laktiv } ))
      ntypDuchod := duchodyW->ntypDuchod
    endif
    ::dm:set( 'msprc_moW->ntypDuchod', ntypDuchod )

    postAppEvent(xbeP_Keyboard, xbeK_RETURN,,odrg:oXbp)
    return self

**  Odpoèitatelné položky - nOdpocObd  - MZD_odpocpol_CRD
  inline method MZD_odpocpol_CRD()
    local oDialog, nexit
    *
    local  odrg := ::dm:has('msprc_mow->nodpocobd'):odrg

    MZD_msOdppol_cpy( .t. )

    DRGDIALOG FORM 'MZD_odpocpol_CRD' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

    ::dm:set( 'msprc_mow->nodpocobd', msprc_mow->nodpocobd )
    ::dm:set( 'msprc_mow->nodpocrok', msprc_mow->nodpocrok )
    ::dm:set( 'msprc_mow->ndanulobd', msprc_mow->ndanulobd )
    ::dm:set( 'msprc_mow->ndanulrok', msprc_mow->ndanulrok )
    return self

*
** TAB - 3  metody a promìnné pro práci s msSsrz_moW (srážky)
  var    pa_mssrz_Cards

  inline method msSrz_moW_modiCards( typSrz, is_inPostValidate )
    local  o_porUplsrz := ::dm:has( 'mssrz_moW->nporUplsrz'):odrg
    local  o_zkrSrazky := ::dm:has( 'mssrz_moW->czkrSrazky'):odrg
    local  pa          := ::pa_mssrz_Cards

    default typSrz            to ::dm:get( 'mssrz_moW->ctypSrz'   ), ;
            is_inPostValidate to .f.

    if isNull( pa )
      pa := { ::dm:has( 'mssrz_moW->ntypCastka' ):odrg, ::dm:has( 'mssrz_moW->nsplatka' ):odrg, ;
              ::dm:has( 'mssrz_moW->ncelkem'    ):odrg, ::dm:has( 'mssrz_moW->nnedoplat'):odrg, ;
              ::dm:has( 'mssrz_moW->nsplaceno'  ):odrg, ::dm:has( 'mssrz_moW->nzustatek'):odrg  }
    endif

    do case
    case      typSrz = 'SR00'    // Pøevod mzdy na úèet
      aeval( pa, { |x| ( x:isEdit := .f., x:oxbp:disable() ) })

    case      typSrz = 'SRUV'    // Ostatní pùjèky, Pùjèka z FKSP ...
      aeval( pa, { |x| ( x:isEdit := .t., x:oxbp:enable() ) })

    otherwise                    // SROB  Exekuce, Ostatní srážky ze mzdy, Pojištìní u pojišov.úst. ...
                                 // SROD  Srážka pro odborovou org.
                                 // SRPP  Penz.pøipoj. - organizace, Životní poj. -organizace

      aeval( pa, { |x| ( x:isEdit := .f., x:oxbp:disable() ) }, 2)
      ( pa[1]:isEdit := .t., pa[1]:oxbp:enable() )
      ( pa[2]:isEdit := .t., pa[2]:oxbp:enable() )
    endCase

    if( .not. empty(typSrz), ( o_zkrSrazky:isEdit := .f., o_zkrSrazky:oxbp:disable()), ;
                             ( o_zkrSrazky:isEdit := .t., o_zkrSrazky:oxbp:enable() )  )

    if( pa[1]:isEdit       , ( o_porUplsrz:isEdit := .t., o_porUplsrz:oxbp:enable() ), ;
                             ( o_porUplsrz:isEdit := .f., o_porUplsrz:oxbp:disable())  )

    * v INS povolíme editaci zkrSrazky
    if ::state = 2
      ( o_zkrSrazky:isEdit := .t., o_zkrSrazky:oxbp:enable())
      *
      ** poednastavíme
      ::dm:set( 'mssrz_moW->laktivSrz', .t.)
      ::dm:set( 'mssrz_moW->ddatOdSpl', mh_firstOdate( msprc_moW->nrok, msprc_moW->nobdobi) )
    endif

    if( ::state = 2 .or. is_inPostValidate, ::msSrz_moW_poradiSrazky( typSrz ), nil )
  return .t.


  inline method msSrz_moW_poradiSrazky( typSrz )
    local  nporadi := 0, nporUplSrz := 0, ncnt := 0
    local  recNo   := mssrz_mow->( recNo())
    * nporadi
    * nporUplSrz
    * pokud je typSrz NIL jedná se o uložení, musíme zkotrolovat nporUplSrz
    *                                         a nastavit hodnotu nporadí

    Fordrec( {'mssrz_mow'} )

    if isCharacter( typSrz )

      mssrz_mow->(dbgotop()                                           , ;
                  dbeval( { || nporUplSrz := mssrz_mow->nporUplSrz }  , ;
                          { || mssrz_mow->nporUplsrz <> 90         } )  )

      nporUplSrz := if( typSrz = 'SR00', 90, nporUplSrz +1 )
      ::dm:set( 'mssrz_mow->nporUplSrz', nporUplSrz )

    else
      nporUplSrz := mssrz_mow->nporUplSrz

      mssrz_mow->( ordsetFocus( 'MsSrzW04')     , ;
                   dbgoBottom()                 , ;
                   nporadi := mssrz_mow->nporadi, ;
                   dbgoTo( recNo)                 )

      nporadi++
      if( mssrz_mow->nporadi = 0, mssrz_mow->nporadi := nporadi, nil )

      * pøeèíslováváme mimo 90
      mssrz_mow->( dbeval ( { || ncnt++ }, { || mssrz_mow->nporUplSrz = nporUplSrz } ))

      if ncnt > 1
        mssrz_mow->( dbgoTo( recNo), dbskip())

        do while .not.  mssrz_mow->( eof())
          mssrz_mow->nporUplSrz := min( mssrz_mow->nporUplSrz +1, 90)
          mssrz_mow->( dbskip())
        enddo
      endif
    endif

    Fordrec()
  return .t.


  inline method msSrz_moW_save()
    if mssrz_moW->(eof()) .or. ::state = 2
      mh_copyFld( 'msprc_mow', 'mssrz_mow', .t. )
    endif

**    (::dm:save(), ::dm:refresh(.T.))

    ::save_onTabs( 'mssrz_mow' )

    * musíme zkotrolovat nporUplSrz
    ::msSrz_moW_poradiSrazky()

**    ::restColor()
    ::setFocus_onTab(.t.)
  return .t.
  **
  *

* TAB  6 - metody a promìnné pro práci vazOsobyW rodinní pøíslušníci
  inline method per_osoby_sel(drgDialog)
    local  odialog, nexit := drgEVENT_QUIT, ok := .f., copy := .f.
    *
    local  drgvar   := ::dm:has('vazOsobyW->ncisOsoby')
    local  cisOsoby := drgVar:odrg:ovar:value
    local  pa       := ::pa_vazRecs[1]
    *
    *
    if   isObject(drgDialog)  ;  ok := .f.
    else
      if osoby->( dbseek( cisOsoby,,,'OSOBY01'))
        ok := ( ascan( pa, osoby->(recNo()) ) = 0 )
*        ok := ( ascan( pa, osoby->ncisOsoby) = 0 )
      endif
    endif

    if .not. ok
      ::start_SEL_inThread('PER_osoby_SEL,1')

      ok := ( drgvar:changed() .and. .not. empty(drgvar:oDrg:cargoGet))
      if( ok, osoby->( ads_clearAof(), dbCommit(), dbskip(0), dbseek(drgvar:oDrg:cargoGet,,'ID')), nil )
    endif

    copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

    if copy
      ::dm:set( "vazOsobyW->ncisOsoby", osoby->ncisOsoby)

      osoby_Rp->(dbseek( osoby->ncisOsoby,,'OSOBY01'))
      ::refreshGroup('vazOsobyW,osoby_Rp', drgVar)

      ::dm:set( "vazOsobyW->ncisOsoby" , osoby_Rp->ncisOsoby )
      ::dm:set( "vazOsobyW->ddatNaroz" , osoby_Rp->ddatNaroz )
      ::dm:set( "vazOsobyW->crodcisOsb", osoby_Rp->crodcisOsb)

      * zabráníme znovu naètení pøi postValiadte
      drgvar:initValue := drgVar:prevValue := drgVar:value := osoby->ncisOsoby
    endif

**    setAppFocus( drgVar:odrg:oxbp )
  return (nexit = drgEVENT_SELECT .or. ok)


  inline method editParent()
    local  oDialog, nExit
   *
    local  pa := {{ ''                , ''                               } , ;
                  { 'OSB_OSOBY_CRD'   , 'vazOsobyW,osoby_Rp', 'osoby_Rp' } , ;
                  { ''                , ''                               } , ;
                  { ''                , ''                               } , ;
                  { ''                , ''                               } , ;
                  { 'OSB_OSOBY_CRD'   , 'vazOsobyW,osoby_Rp', 'osoby_Rp' } , ;
                  { 'PER_skoleni_CRD' , 'vazSkolW,skoleni'  , 'skoleni'  }   }

    local  cformName := pa[::tabNum,1]
    local  cfileMain := pa[::tabNum,3]
    *
    ::start_SEL_inThread( cformName +',' +str((cfileMain)->(recNo())) )

    * refrešneme zmìny, moc nás nezajímá jestli nìjaké udìlal
    (cfileMain)->(dbcommit(), dbskip(0))
    ::setFocus_onTab( .t. )
    ::refreshGroup( pa[::tabNum,2] )
  return self

ENDCLASS