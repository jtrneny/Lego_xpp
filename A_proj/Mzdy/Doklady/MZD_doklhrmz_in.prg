#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dmlb.ch"
#include "dbstruct.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

* pozor
* _in by mìla být tøída pro definici obecných metod, které by byly použity
*     ve všech tøídách - mh, ms, mn
*     je otázka, jesti mají nìco spoleèného ?
*
* prakticky by mìly existovat 3 prg podle definovaných deníkù v CFG
* MH - metody a funkce pro hrubé mzdy
* MS -                 pro srážky
* MN -                 pro nemocenky


function fDatPor()  ;   return mzdDavHDw->dDatPoriz

*
** CLASS MZD_doklhrmz_in ********************************************************
CLASS  MZD_doklhrmz_in
EXPORTED:
  var     hd_file, it_file
  var     state                                    // 0 - inBrowse  1 - inEdit  2 - inAppend
  var     msg, dm, dc, df, ab, brow
  var     m_parent
  *
  **      promìné pro obecné použití *
  var     it_dnyDoklad, it_druhMzdy, it_sazbaDokl, it_hodDoklad, it_mnPDoklad, it_mzda, it_premie

  *
  **      neviditelné položky pro výpoèty
  var     it_hrubaMzd
  var     it_dnyFondKD, it_dnyFondPD, it_dnyDovol
  var     it_hodFondKD, it_hodFondPD, it_hodPresc, it_hodPrescS, it_hodPripl


  method  aktFndNem, aktFndDny, aktFndHod
  method  aktFnd_DnyHod
  method  fSAZBA, VypHrMz
  method  VypocHm, VypocPremie
  *
  method  itSave

  inline method init(parent)
    local drgDialog := parent:drgDialog

    ::msg      := drgDialog:oMessageBar             // messageBar
    ::dm       := drgDialog:dataManager             // dataMabanager
    ::dc       := drgDialog:dialogCtrl              // dataCtrl
    ::df       := drgDialog:oForm                   // form
    ::m_parent := drgDialog

    * pøí opravì se pozicujeme vžda na 1.BROw pokud je na FRM a má data *
    members  := ::df:aMembers
    BEGIN SEQUENCE
      for x := 1 to LEN(members) step 1
        if lower(members[x]:ClassName()) $ 'drgbrowse,drgdbrowse,drgebrowse'
          ::brow  := members[x]:oXbp
          in_file := members[x]:cfile
    BREAK
        endif
      next
    ENDSEQUENCE

    if IsObject(::brow) .and. (in_file) ->(LastRec()) <> 0
      ::df:nextFocus := x
    endif

    * neviditelné pomocné položky
    ::it_hrubaMzd  := ::dm:has(::it_file +'->nhrubaMzd'  )

    ::it_dnyFondKD := ::dm:has(::it_file +'->ndnyFondKD' )
    ::it_dnyFondPD := ::dm:has(::it_file +'->ndnyFondPD' )
    ::it_dnyDovol  := ::dm:has(::it_file +'->ndnyDovol'  )

    ::it_hodFondKD := ::dm:has(::it_file +'->nhodFondKD' )
    ::it_hodFondPD := ::dm:has(::it_file +'->nhodFondPD' )
    ::it_hodPresc  := ::dm:has(::it_file +'->nhodPresc'  )
    ::it_hodPrescS := ::dm:has(::it_file +'->nhodPrescS' )
    ::it_hodPripl  := ::dm:has(::it_file +'->nhodPripl'  )

    * položky z dokladu
    ::it_dnyDoklad := ::dm:has(::it_file +'->ndnyDoklad' )
    ::it_druhMzdy  := ::dm:has(::it_file +'->ndruhMzdy'  )
    ::it_sazbaDokl := ::dm:has(::it_file +'->nsazbaDokl' )
    ::it_hodDoklad := ::dm:has(::it_file +'->nhodDoklad' )
    ::it_mnPDoklad := ::dm:has(::it_file +'->nmnPDoklad' )
    ::it_mzda      := ::dm:has(::it_file +'->nmzda'      )
    ::it_premie    := ::dm:has(::it_file +'->npremie'    )
  return self

  *
  **
  inline method createContext(mp1,mp2,obj)
    local omenu := XbpImageMenu():new( obj )

    omenu:create()
    omenu:addItem({ 'Nastavení sloupcù'         , ;
                  {|| ::mzdDavit_BroCol() }     , ;
                                                , ;
                  XBPMENUBAR_MIA_OWNERDRAW        })
    omenu:popup(obj,mp1)
    return self

  inline method mzdDavit_BroCol()
    local odialog

    odialog := drgDialog():new('MZD_mzdDavit_broCol', ::m_parent)
    oDialog:cargo_usr :=  ::brow:cargo
    odialog:create(,,.T.)
    return self


  inline method handleEvent(nEvent, mp1, mp2, oXbp)
    local  ocolumn, rowPos, colPos, citem, ctype, cval, xVal

    do case
    case nevent = xbeM_RbDown .and. setAppFocus():className() = 'xbpBrowse'
      ::createContext(mp1,mp2,oxbp )

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgdrowse,drgebrowse') .and. isobject(::brow)
        ok := if(isMethod(self,'overPostLastField'), ::overPostLastField(), .t.)

        if(IsMethod(self, 'postLastField') .and. ok, ::postLastField(), Nil)
      else
        if isMethod(self,'postSave')
          if mzd_postSave()
             ::postSave()
          else
             PostAppEvent(xbeP_Close,,,::m_parent:dialog)
          endif
          return .t.
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif

    case(nEvent = drgEVENT_DELETE)
      if drgIsYesNo(drgNLS:msg('Zrušit položku dokladu _ [&] _ ', (::it_file)->ndoklad))

        * hrubá mzda deník MH
        if (::hd_file)->cdenik = 'MH'

          * pro automaticky generované prémie k základní mzdì
          if mzdDavitS->( dbseek( (::it_file)->nordItem +9,,'MZDDAVITs02'))
            if(mzdDavitS->_nrecor = 0, mzdDavitS->(dbdelete()), mzdDavitS->_delrec := '9')
          endif

          * musíme zabezpeèit automatiký pøepoèet
          if( (::it_file)->nautoGen = 0, ::doklhrmz_aut_modify(.t., .t.), nil )
        endif

        if((::it_file)->_nrecor = 0, (::it_file)->(dbdelete()), (::it_file)->_delrec := '9')
        (::it_file)->(dbcommit())

        mzd_mzddavhd_cmp()

        ::brow:panHome():refreshAll()
        ::dm:refresh()

        setAppFocus( ::brow )
      endif
      return .t.

   case nEvent = xbeP_Keyboard
     *
     * podivná úprava pro klávesu + pøevezme hodnotu z horního øádku
     if chr(mp1) = '+' .and. oxbp:className() = 'XbpGet' .and. ::brow:rowPos <> 1
       ocolumn := ::brow:getColumn( ::brow:colPos )
       rowPos  := ::brow:rowPos -1
       colPos  := ::brow:colPos

       if len( ::brow:cargo:ardef) >= colPos
         citem :=          ocolumn:defColum[2]
         ctype := valType( ocolumn:defColum[7]:oVar:value )
         cval  := ::brow:getColumn( colPos ):getRow( rowPos )

         if isNull( cval )
           cVal := if( ctype == 'L', .f.                 , ;
                    if( ctype == 'D', cToD( '  .  .  ' ) , ;
                     if( ctype == 'N', '0', ''         ) ) )

         endif

         xVal := if( ctype == 'L', If( cval, '.T.', '.F.' ) , ;
                  if( ctype == 'D', cToD( cval )            , ;
                   if( ctype == 'N', val( strTran(cval, ',', '.')), cval    ) ) )
         ::dm:set( citem, xVal )

         PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,oXbp)
         return .t.
       endif
     endif


     if mp1 = xbeK_ESC .and. .not. isWorkVersion
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

   endcase
  return .f.


  inline method openfiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(x)                                                                        , ;
         if(isnull(ordno), nil, (file)->(AdsSetOrder(ordno)))                                     })
    return nil


  inline method reOpen_mzdDavitw( refreshAll )
    local  odrg_hd := ::dm:has( ::hd_file +'->ndnyFondKD' )

    default refreshAll to .f.
    mzdDavitW->( dbeval( { || mzdDavitw->(dbDelete()) } ))

    if refreshAll
      mzd_mzddavhd_cmp()
      ::refresh( odrg_hd )
      ::brow:refreshAll()
    endif
    return self


  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  inline method modi_memvar(o,on_off)
    if ismembervar(o,'groups') .and. .not. empty(o:groups)
      if(on_off, o:oxbp:show(), o:oxbp:hide())
      if( ismembervar(o,'obord') .and. isobject(o:obord))
        if(on_off, o:obord:show(), o:obord:hide())
      endif

      if( ismembervar(o,'pushGet') .and. isobject(o:pushGet))
         if(on_off, o:pushGet:oxbp:show(), o:pushGet:oxbp:hide())
      endif
    endif
  return nil

  *
  ** kontola položky dokladu hrubých mezd (cdenik = 'MH') na vazební èíselník c_naklst
  inline method c_naklst_vld(drgVar_nazPol1)
    local  oDialog, nExit := drgEVENT_QUIT
    local  x, cvalue := ''
    local  ok := .f., showDlg := .f.

    for x := 1 to 6 step 1
      cvalue += upper(::dm:get( ::it_file +'->cnazPol' +str(x,1)))
    next

    do case
    case empty(cvalue)
      ok      := .t.
    otherwise
      ok      := c_naklSt->(dbseek(cvalue,,'C_NAKLST1'))
      showDlg := .not. ok
    endcase

    if showDlg
      DRGDIALOG FORM 'c_naklst_sel' PARENT ::dm:drgDialog MODAL           ;
                                                          DESTROY         ;
                                                          EXITSTATE nExit ;
                                                          CARGO drgVar_nazPol1

      if nexit != drgEVENT_QUIT .or. ok
        for x := 1 to 6 step 1
          ::dm:set(::it_file + '->cnazPol' +str(x,1), DBGetVal('c_naklSt->cnazPol' +str(x,1)))
        next
        postAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar_nazPol1:odrg:oxbp)
        ok := .t.
      else
        ::df:setNextFocus(::it_file +'->cnazPol1',,.t.)
      endif
    endif
  return ok
HIDDEN:

  method  fNULUJ, OuVAL
ENDCLASS


method MZD_doklhrmz_in:aktFndNem( nvykazN_KD, nvykazN_PD, isin_aut )
  local  nFondKD     := nFondPD     := 0
  local  nhod_FondKD := nhod_FondPD := 0

  default isin_aut to .f.

  DO CASE
  CASE DruhyMZD ->nNapocHM == 0 .OR. DruhyMZD ->nNapocHM == 2         ;
       .OR. DruhyMZD ->nNapocHM == 4 .OR. DruhyMZD ->nNapocHM == 5    ;
        .OR. DruhyMZD ->nNapocHM == 7

    nFondKD := nvykazN_KD
    nFondPD := nvykazN_PD
  CASE DruhyMZD ->nNapocHM == 8
    nFondKD := nvykazN_KD
  ENDCASE

  if isin_aut
    mzddavITw->nDnyFondKD := nFondKD
    mzddavITw->nDnyFondPD := nFondPD
  else
    ::dm:set('mzddavITw->nDnyFondKD', nFondKD     )
    ::dm:set('mzddavITw->nDnyFondPD', nFondPD     )
  endif

  IF DruhyMZD ->nNapocHM = 0 .OR. DruhyMZD ->nNapocHM = 3        ;
     .OR. DruhyMZD ->nNapocHM = 4 .OR. DruhyMZD ->nNapocHM = 6   ;
      .OR. DruhyMZD ->nNapocHM = 7

    nhod_FondKD := nFondKD * fPracDOBA()[3]
    nhod_FondPD := nFondPD * fPracDOBA()[3]

    if isin_aut
      mzddavITw->nHodFondKD := nhod_FondKD
      mzddavITw->nHodFondPD := nhod_FondPD
    else
      ::dm:set('mzddavITw->nHodFondKD', nhod_FondKD )
      ::dm:set('mzddavITw->nHodFondPD', nhod_FondPD )
    endif
  endif
return self

* po uložení záznamu aktualizujeme FOND dny/ hod
method MZD_doklhrmz_in:aktFnd_DnyHod()
  druhyMzd->(dbseek( (::it_file)->ndruhMzdy,, 'DRUHYMZD01'))

  ::aktFndDny( (::it_file)->ndnyDoklad, .t. )
  ::aktFndHod( (::it_file)->nhodDoklad, .t. )

return .t.


method MZD_doklhrmz_in:aktFndDny( dnyDoklad, isin_aut )
  local  nFondKD := nFondPD := nDovol := 0
  local  ndelkPDhod

  default isin_aut to .f.

  DO CASE
  CASE DruhyMZD ->nNapocHM == 0 .OR. DruhyMZD ->nNapocHM == 2         ;
       .OR. DruhyMZD ->nNapocHM == 4 .OR. DruhyMZD ->nNapocHM == 5    ;
        .OR. DruhyMZD ->nNapocHM == 7

    if DruhyMzd->nNapocFPD = 1
      nFondKD := nFondPD := dnyDoklad
    endif

  CASE DruhyMZD ->nNapocHM == 8
    nFondKD := dnyDoklad

  ENDCASE

  IF DruhyMZD ->nTypDovol <> 0
    nDovol := dnyDoklad
**    TestDovol( cALIAS, nDovol, ( cAlias) ->nDnyDovol)
  ENDIF

  if isin_aut
    mzddavITw->nDnyFondKD :=  nFondKD
    mzddavITw->nDnyFondPD :=  nFondPD
    mzddavITw->nDnyDovol  :=  nDovol

  else
    ::dm:set('mzddavITw->nDnyFondKD', nFondKD )
    ::dm:set('mzddavITw->nDnyFondPD', nFondPD )
    ::dm:set('mzddavITw->nDnyDovol' , nDovol  )

    if druhyMzd->lhodZdnu
      ndelkPDhod := FpracDoba( msPrc_mo->cDelkPrDob)[3]
      ::dm:set( 'mzdDavITw->->nhoddoklad', dnyDoklad *ndelkPDhod )
    endif
  endif
return .t.


method MZD_doklhrmz_in:aktFndHod( hodDoklad, isin_aut )
  local  nFondKD := nFondPD := nPresc := nPrescS := nPripl  := 0

  default isin_aut to .f.

  IF DruhyMZD ->nNapocHM == 0 .OR. DruhyMZD ->nNapocHM == 3        ;
     .OR. DruhyMZD ->nNapocHM == 4 .OR. DruhyMZD ->nNapocHM == 6   ;
      .OR. DruhyMZD ->nNapocHM == 7

    if DruhyMzd->nNapocFPD = 1
      nFondKD := nFondPD := hodDoklad
    endif
  ENDIF

  nPresc  := IF( DruhyMZD->cTypDMZ == "PRES", hodDoklad, 0)
  nPrescS := IF( DruhyMZD->cTypDMZ == "PREP", hodDoklad, 0)
  nPripl  := IF( DruhyMZD->cTypDMZ == "PRIP", hodDoklad, 0)

  if isin_aut
    mzddavITw->nHodFondKD := nFondKD
    mzddavITw->nHodFondPD := nFondPD
    mzddavITw->nHodPresc  := nPresc
    mzddavITw->nHodPrescS := nPrescS
    mzddavITw->nHodPripl  := nPripl

  else
    ::dm:set('mzddavITw->nHodFondKD', nFondKD )
    ::dm:set('mzddavITw->nHodFondPD', nFondPD )
    ::dm:set('mzddavITw->nHodPresc' , nPresc  )
    ::dm:set('mzddavITw->nHodPrescS', nPrescS )
    ::dm:set('mzddavITw->nHodPripl' , nPripl  )
  endif
return .t.


method MZD_doklhrmz_in:VypHrMz( isin_aut )
  local  anSazby
  local  it_druhMzdy  := ::dm:has(::it_file +'->ndruhMzdy'  )
  local  druhMzdy

  default isin_aut to .f.

  druhMzdy := if( isin_aut, (::it_file)->ndruhMzdy, it_druhMzdy:value )

  druhyMzd->(dbseek( druhMzdy,, 'DRUHYMZD01'))

  ::fNULUJ( isin_aut )
  anSazby := ::fSAZBA( isin_aut )

  ::VypocHm( anSazby, isin_aut )
return anSazby[1]

*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method MZD_doklhrmz_in:VypocHm( anSazby, isin_aut )
  local  nKoef    := if( druhyMzd->nDruhMzdy < 400, sysConfig( 'Mzdy:nKoefHm'), 1)
  local  nSazba   := anSazby[3]
  local  typVypHm := druhyMzd->ntypVypHm
  local  it_hodDoklad, it_mnPDoklad, it_dnyDoklad
  *
  local  nHMzda   := 0

  default isin_aut to .f.

  if isin_aut
    it_hodDoklad := (::it_file)->nhodDoklad
    it_mnPDoklad := (::it_file)->nmnPDoklad
    it_dnyDoklad := (::it_file)->ndnyDoklad
  else
    it_hodDoklad := ::dm:get( ::it_file +'->nhodDoklad' )
    it_mnPDoklad := ::dm:get( ::it_file +'->nmnPDoklad' )
    it_dnyDoklad := ::dm:get( ::it_file +'->ndnyDoklad' )
  endif

  do case
  case ( typVypHm = 1 )
    nHMzda := Round( it_hodDoklad * nSazba * nKoef, 2)

  case ( typVypHm = 2 )
    nHMzda := Round( it_mnPDoklad  * nSazba * nKoef, 2)

  case ( typVypHm = 3 )
    nHMzda := Round( it_dnyDoklad  * nSazba * nKoef, 2)

  case ( typVypHm = 4 )
    nHMzda := Round(                 nSazba * nKoef, 2)

  case ( typVypHm = 5 )
    nHMzda := Round( Round(druhyMzd->nKoe1_VyHm * nSazba, 2) * nKoef, 2)

  case ( typVypHm = 6 )
    nHMzda := Round( it_dnyDoklad  * nSazba * nKoef, 2)

  endcase

  nHMzda := if( Abs( anSazby[1] - nHMzda) < 1.00, anSazby[1], nHMzda)
  nHMzda := Mh_RoundNumb( nHMzda, druhyMzd->nKodZaokr)

  * pro nemocenky
  if (::hd_file)->cdenik = 'MN'

    ::dm:set( ::it_file +'->nMzda'     , if( typVypHm = 6, 0, nHMzda) )
    ::dm:set( ::it_file +'->nhrubaMzd' , if( typVypHm = 6, 0, nHMzda) )
    ::dm:set( ::it_file +'->nnemocCelk', nHMzda)

    if isin_aut
      (::it_file)->nmzda      := if( typVypHm = 6, 0, nHMzda)
      (::it_file)->nhrubaMzd  := if( typVypHm = 6, 0, nHMzda)
      (::it_file)->nnemocCelk := nHMzda
    endif

  else
    ::dm:set( ::it_file +'->nMzda'    , nHMzda)
    ::dm:set( ::it_file +'->nhrubaMzd', nHMzda)

    if isin_aut
      (::it_file)->nMzda     := nHMzda
      (::it_file)->nhrubaMzd := nHMzda
    endif
  endif
return self


method MZD_doklhrmz_in:VypocPremie( isok_socPojis, isok_zdrPojis )
  local  typVypPre := druhyMzd->ntypVypPre
  local  kodZaokr  := druhyMzd->nKodZaokr
  local  nasobek   := 1
  local  ordItem   := (::it_file)->nordItem
  *
  local  it_premMzd, it_hrubaMzd, it_sazbaDok, it_premie

  * pro jistotu, pøi opravì starých dokladù
  druhyMzd  ->(dbseek((::it_file)->ndruhMzdy ,, 'DRUHYMZD01'))
  if (::it_file)->ndruhMzPre = 0 .and. druhyMzd->ndruhMzPre <> 0
    (::it_file)->ndruhMzPre := druhyMzd->ndruhMzPre
  endif

  druhyMzd_p->(dbseek((::it_file)->ndruhMzPre,, 'DRUHYMZD01'))

  it_premMzd   := 0
  it_hrubaMzd  := ::dm:get(::it_file +'->nhrubaMzd'  )
  it_sazbaDokl := ::dm:get(::it_file +'->nsazbaDokl' )
  it_premie    := ::dm:get(::it_file +'->npremie'    )

  do case
  case ( typVypPre = 1 )               // 1 - procento z hrubé mzdy
    it_premMzd := round( it_hrubaMzd * it_premie/100, 2)
       nasobek := 1

  case ( typVypPre = 2 )               // 2 - procento ze základní sazby * dny
    it_premMzd := round( it_sazbaDokl * it_premie/100, 2)
       nasobek := ::dm:get(::it_file +'->ndnyDoklad' )

  case ( typVypPre = 3 )               // 3 - procento ze základní sazby * hodiny
    it_premMzd := round( it_sazbaDokl * it_premie/100, 2)
       nasobek := ::dm:get(::it_file +'->nhodDoklad' )

  case ( typVypPre = 4 )               // 4 - procento ze základní sazby * množství
    it_premMzd := round( it_sazbaDokl * it_premie/100, 2)
       nasobek := ::dm:gets(::it_file +'->nmnPDoklad' )
  endcase

  (::it_file)->npremMzd := mh_roundNumb( it_premMzd * nasobek, kodZaokr )

  *
  ** oprava/ založení generované prémie
  if mzdDavitS->( dbseek( ordItem +9,,'MZDDAVITs02'))

    * k položce    existovala generovaná prémie, musíme ji modifikovat
    mzdDavitS->nsazbaDokl := mzdDavitS->nmzda := mzdDavitS->nhrubaMzd := (::it_file)->npremMzd

  else

    * k položce NE existovala generovaná prémie, musíme ji založit pokud je <> 0
    if (::it_file)->npremMzd <> 0 .and. (::it_file)->ndruhMzPre <> 0
      ::copyfldto_w( 'mzdDavitW', 'mzdDavitS', .t.)

      mzdDavitS->ndruhMzdy  := (::it_file)->ndruhMzPre
      mzdDavitS->cucetskup  := allTrim( str( mzdDavitS->ndruhMzdy))
      mzdDavitS->nordItem   := ordItem +9
      mzdDavitS->nsazbaDokl := mzdDavitS->nmzda := mzdDavitS->nhrubaMzd := (::it_file)->npremMzd

      mzdDavitS->nautoGen   := 2

      mzdDavitS->_nrecOr    := 0

      mzdDavitS->ndnyDoklad := ;
      mzdDavitS->nmnPDoklad := ;
      mzdDavitS->nhodDoklad := ;
      mzdDavitS->nDnyFondKD := ;
      mzdDavitS->nDnyFondPD := ;
      mzdDavitS->nDnyDovol  := ;
      mzdDavitS->nHodFondKD := ;
      mzdDavitS->nHodFondPD := ;
      mzdDavitS->nHodPresc  := ;
      mzdDavitS->nHodPrescS := ;
      mzdDavitS->nHodPripl  := ;
      mzdDavitS->npremie    := ;
      mzdDavitS->ndruhMzPre := 0
      *
      ** musíme doplnit vazbu mzdDavitW - > mzdDavitS
      mzdDavitW->_nsidPrem := isNull( mzdDavitS->sid, 0)
    endif
  endif

  mzdDavitS->nzaklSocPo := if( druhyMzd_p->lsocPojis .and. isok_socPojis, mzdDavitS->nHrubaMZD, 0)
  mzdDavitS->nzaklZdrPo := if( druhyMzd_p->lzdrPojis .and. isok_zdrPojis, mzdDavitS->nHrubaMZD, 0)
return self


method MZD_doklhrmz_in:fNULUJ( isin_aut )

  default isin_aut to .f.

   if DruhyMZD->nNulVypHm = 2 .OR. DruhyMZD->nNulVypHm = 4 .OR. DruhyMZD->nNulVypHm = 5
     if( isin_aut, mzddavITw->ndnyDoklad := 0, ::dm:set('mzddavITw->ndnyDoklad', 0) )
   endif

   if DruhyMZD->nNulVypHm = 3 .OR. DruhyMZD->nNulVypHm = 4 .OR. DruhyMZD->nNulVypHm = 6
     if( isin_aut, mzddavITw->nhodDoklad := 0, ::dm:set('mzddavITw->nhodDoklad', 0) )
   endif

   if DruhyMZD->nNulVypHm = 1 .OR. DruhyMZD->nNulVypHm = 5 .OR. DruhyMZD->nNulVypHm = 6
     if( isin_aut, mzddavITw->nsazbaDokl := 0, ::dm:set('mzddavITw->nsazbaDokl', 0) )
     if( isin_aut, mzddavITw->nmzda      := 0, ::dm:set('mzddavITw->nmzda'     , 0) )
   endif

   * hrubá mzda deník MH, pokud k druhu mzdy nelze zadat % prémií, musíme to zanulovat
   if (::hd_file)->cdenik = 'MH' .and. druhyMzd->ndruhMzPre = 0
     if( isin_aut, mzdDavitW->ndruhMzPre := 0, ::dm:set('mzdDavitW->ndruhMzPre', 0) )
     if( isin_aut, mzdDavitW->npremie    := 0, ::dm:set('mzdDavitW->npremie'   , 0) )
   endif
return self


method MZD_doklhrmz_in:fSAZBA( isin_aut )
  local  nPracDny, nPocSv, nFndHod, nFndHodBSv
  *
  local  nRok    := (::hd_file)->nRok
  local  nObdobi := (::hd_file)->nObdobi
  *
  local  sazbaVyHm, it_dnyDoklad, it_hodDoklad, it_sazbaDokl, it_premie
  local  anSazba := { 0, 0, 0 }

  default isin_aut to .f.

  nPracDny   := F_PracDny( nRok, nObdobi )
  nPocSv     := F_Svatky ( nRok, nObdobi )
  nFndHod    := ( nPracDny +nPocSv) * ;
                  IF( fPracDOBA()[3] <> 0, fPracDOBA()[3]  ;
                  , SysConfig( 'Mzdy:nDelPrcTyd') /SysConfig( 'Mzdy:nDnyPrcTyd'))

  nFndHodBSv := ( nPracDny) * ;
                  IF( fPracDOBA()[3] <> 0, fPracDOBA()[3]  ;
                  , SysConfig( 'Mzdy:nDelPrcTyd') /SysConfig( 'Mzdy:nDnyPrcTyd'))

  if isin_aut
    it_dnyDoklad := (::it_file)->ndnyDoklad
    it_hodDoklad := (::it_file)->nhodDoklad
    it_sazbaDokl := (::it_file)->nsazbaDokl
    it_premie    := (::it_file)->nPremie
  else
    it_dnyDoklad := ::dm:get( ::it_file +'->ndnyDoklad' )
    it_hodDoklad := ::dm:get( ::it_file +'->nhodDoklad' )
    it_sazbaDokl := ::dm:get( ::it_file +'->nsazbaDokl' )
    it_premie    := ::dm:get( ::it_file +'->nPremie'    )
  endif

  anSazba[1] := it_sazbaDokl
  anSazba[2] := it_premie
  anSazba[3] := anSazba[1]

  sazbaVyHm := druhyMzd->nsazbaVyHm

  do case
  case sazbaVyHm = 1
    if it_sazbaDokl = 0
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
      anSazba[3] := anSazba[1]
    endif

  case sazbaVyHm = 2
    anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
    anSazba[3] := anSazba[1]

  case sazbaVyHm = 3
    if it_sazbaDokl = 0
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
      anSazba[3] := anSazba[1]
    endif
    if( it_premie = 0, anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm), nil )

  case sazbaVyHm = 4
    anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
    anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm)
    anSazba[3] := anSazba[1]

  case sazbaVyHm = 5
    if it_sazbaDokl = 0
      anSazba[1] := mh_roundNumb(::OuVAL(druhyMzd->cRZn1_VyHm) *druhyMzd->nKoe1_VyHm, druhyMzd->nZao1_VyHm)

*      anSazba[1] := round(::OuVAL(druhyMzd->cRZn1_VyHm) *druhyMzd->nKoe1_VyHm,2)
      anSazba[3] := anSazba[1]
    endif

  case sazbaVyHm = 6
    anSazba[1] := round(::OuVAL(druhyMzd->cRZn1_VyHm) *druhyMzd->nKoe1_VyHm,2)
    anSazba[3] := anSazba[1]

  case sazbaVyHm = 7 .or. sazbaVyHm = 18
    if it_dnyDoklad >= nPracDny + nPocSv
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
      anSazba[3] := anSazba[1]
    else
      anSazba[1] := Round( Round( ::OuVAL(druhyMzd->cRZn1_VyHm) /(nPracDny +nPocSv), 2) *it_dnyDoklad, 2)
      anSazba[3] := anSazba[1]
    endif
    if( it_premie = 0 .and. sazbaVyHm = 18, anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm), nil )

  case sazbaVyHm = 8 .or. sazbaVyHm = 19
    if it_sazbaDokl = 0
      anSazba[1] := Round( ::OuVAL(druhyMzd->cRZn1_VyHm) /(nPracDny +nPocSv), 2) + &(druhyMzd->cRZn2_VyHm)
      anSazba[3] := anSazba[1]
    endif
    if( it_premie = 0 .and. sazbaVyHm = 19, anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm), nil )

  case sazbaVyHm = 9 .or. sazbaVyHm = 20
    if it_sazbaDokl = 0
      anSazba[1] := Round( ::OuVAL(druhyMzd->cRZn1_VyHm) /(nPracDny +nPocSv), 2)
      anSazba[3] := anSazba[1]
    endif
    if( it_premie = 0 .and. sazbaVyHm = 20, anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm), nil )

  case sazbaVyHm = 10 .or. sazbaVyHm = 21
    if it_sazbaDokl = 0
      anSazba[1] := Round( ::OuVAL(druhyMzd->cRZn1_VyHm) /nPracDny + ;
                           ::OuVAL(druhyMzd->cRZn2_VyHm) /nPracDny + ;
                           ::OuVAL(druhyMzd->cRZn3_VyHm), 2)
      anSazba[3] := anSazba[1]
    endif
    if( it_premie = 0 .and. sazbaVyHm = 21, anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm), nil )

  case sazbaVyHm = 11 .or. sazbaVyHm = 22
    do case
    case it_hodDoklad = 0
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
      anSazba[3] := 0

    case it_hodDoklad = nFndHOD
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
      anSazba[3] := anSazba[1]

    otherwise
      anSazba[1] := Round( Round( ::OuVAL( DruhyMZD ->cRZn1_VyHm) /nFndHOD, 2) * it_hodDoklad, 2)
      anSazba[3] := anSazba[1]

    endCase
    if( it_premie = 0 .and. sazbaVyHm = 22, anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm), nil )

  case sazbaVyHm = 12
    if it_sazbaDokl = 0
      anSazba[1] := druhyMzd->nKoe1_VyHm
      anSazba[3] := anSazba[1]
    endif

  case sazbaVyHm = 13
    if it_sazbaDokl = 0
      anSazba[1] := druhyMzd->nKoe1_VyHm
      anSazba[3] := anSazba[1]
    endif

  case sazbaVyHm = 14
    if it_sazbaDokl = 0
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
    endif
    if( anSazba[1] <> 0, anSazba[3] := Round( anSazba[1] /( nPracDny +nPocSv), 2), nil )

  case sazbaVyHm = 15
    if it_sazbaDokl = 0
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
    endif
    if( anSazba[1] <> 0, anSazba[3] := Round( anSazba[1] /nFndHOD, 2), nil )


  case sazbaVyHm = 23
  *
  ** pozor, tento algoritmus výpoètu musí být definován, nelze použít pùvodní

  case sazbaVyHm = 24 .or. sazbaVyHm = 25
    do case
    case it_hodDoklad = 0
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
      anSazba[3] := 0

    case it_hodDoklad = nFndHodBSv
      anSazba[1] := ::OuVAL(druhyMzd->cRZn1_VyHm)
      anSazba[3] := anSazba[1]

    otherwise
      anSazba[1] := Round( Round( ::OuVAL(druhyMzd->cRZn1_VyHm) /nFndHodBSv, 2) * it_hodDoklad, 2)
      anSazba[3] := anSazba[1]

    endCase
    if( it_premie = 0 .and. sazbaVyHm = 25, anSazba[2] := ::OuVAL(druhyMzd->cRZn2_VyHm), nil )

  case sazbaVyHm = 27
    if it_sazbaDokl = 0
      anSazba[1] := Round( ::OuVAL(druhyMzd->cRZn1_VyHm) * druhyMzd->nKoe1_VyHm, 2)
      anSazba[1] := if( anSazba[1] > druhyMzd->nKoe2_VyHm, anSazba[1], druhyMzd->nKoe2_VyHm)
      anSazba[3] := anSazba[1]
    endif

  case sazbaVyHm = 28
    if it_dnyDoklad >= nPracDny + nPocSv
      anSazba[1] := druhyMzd->nKoe1_VyHm
      anSazba[3] := anSazba[1]
    else
      anSazba[1] := Round( Round( druhyMzd->nKoe1_VyHm /(nPracDny +nPocSv), 2) *it_dnyDoklad, 2)
      anSazba[3] := anSazba[1]
    endif

  endcase

  ::dm:set( ::it_file +'->nsazbaDokl', anSazba[1] )
  ::dm:set( ::it_file +'->nPremie'   , anSazba[2] )

  if isin_aut
    (::it_file)->nsazbaDokl := anSazba[1]
    (::it_file)->nPremie    := anSazba[2]
  endif
return anSazba


method MZD_doklhrmz_in:OuVAL(cRZn)
  LOCAL nX, xX, cC
  LOCAL cX, n, i

  cRZn := AllTrim( cRZn)

  IF ( n := AT( "[", cRZn)) <> 0
    i    := Val( SubStr( cRZn, n+1, AT( "]", cRZn) -1))
    cRZn := SubStr( cRZn, 1, n-1)
    xX   := IF( !Empty( cRZn), Eval( COMPILE( cRZn)), 0)
    nX   := IF( IsNum( xX[i]), xX[i], 0)

  ELSE
    nX   := 0
    if .not. empty( cRZn )
      cC := strTran( upper( cRZn), 'MSPRC_MZ', 'MSPRC_MO')

      xX := Eval( COMPILE( cC))
      nX := IF( IsNum( xX), xX, 0)
    endif

*    xX := IF( !Empty( cRZn), Eval( COMPILE( cRZn)), 0)
*    nX := IF( IsNum( xX), xX, 0)
  ENDIF
return(nX)

*
method MZD_doklhrmz_in:itSave(panGroup)
  local  x, ok := .t., vars := ::dm:vars
  local  drgVar, groups

  for x := 1 to ::dm:vars:size() step 1
    drgVar := ::dm:vars:getNth(x)
    groups := isNull( drgVar:odrg:groups, '' )

    if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. (groups = panGroup)
      if (eval(drgvar:block) <> drgVar:value) // .and. .not. drgVar:rOnly
        eval(drgVar:block,drgVar:value)
      endif
      drgVar:initValue := drgVar:value
    endif
  next
return self