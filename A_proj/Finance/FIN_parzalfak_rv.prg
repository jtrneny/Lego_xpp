#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dmlb.ch"
#include "CLASS.CH"
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"

#pragma Library( "XppUI2.LIB" )

#define     GetDBVal(c)   Eval( &("{||" + c + "}"))
#xtranslate IsDrgGet(<o>) => IF( IsNull(<o>)  , NIL, ;
                             IF( IsObject(<o>), IF( <o>:className() = 'drgGet', <o>, NIL ), NIL))



procedure FIN_parzalfak_vykdph_cpy( mFile )
  local  cky := upper( (mFile) ->cdenik) +strzero( (mFile) ->ncisfak,10)
  local  pky
  local  file_name, pFile

  *
  drgDBMS:open('VYKDPH_I')
  drgDBMS:open('ucetdohd')

  if(select('vykdph_pw') <> 0, vykdph_pw->(dbclosearea()), nil)
  if(select('vykdph_ps') <> 0, vykdph_ps->(dbclosearea()), nil )

  drgDBMS:open('vykdph_pw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  * ps je pro souètování *
  file_name := vykdph_pw ->( DBInfo(DBO_FILENAME))
               vykdph_pw ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'vykdph_pw', .t., .f.) ; vykdph_pw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'vykdph_ps', .t., .t.)
  * ps

  vykdph_i->(AdsSetOrder(1), dbsetscope(SCOPE_BOTH,cky), dbgoTop())
  do while .not. vykdph_i->(eof())
    if .not. empty(vykdph_i->ncisfak)
      mh_copyFld('vykdph_i','vykdph_pw',.t., .t.)

      ucetdohd->(dbseek(upper(vykdph_i->cdenik_par) +strzero(vykdph_i->ncisFak,10),,'UCETDH_7'))
      vykdph_pw->cucetu_dok := ucetdohd->cucet_uct
      vykdph_pw->cZkratMenF := ucetdohd->cZkratMenF
      vykdph_pw->nKurzMenU  := CoalesceEmpty(ucetdohd->nKurzMenU,1)
      vykdph_pw->nMnozPreU  := CoalesceEmpty(ucetdohd->nMnozPreU,1)

      vykdph_pw->nrecVyk := vykdph_i->(recno())
    endif
    vykdph_i->(dbSkip())
  enddo

  *
  * nìkteré položky z DD nepøevzal, nebo jsou nové ?
  pFile := if( lower(mFile) = 'fakprihdw', 'parprzalw', 'fakvysitw' )

  (pFile) ->( dbgoTop())

  do while .not. (pFile) ->( eof())
    cky :=  upper( (mFile) ->cdenik) +strzero( (pFile) ->ncisZalFak,10)
    vykdph_i->(AdsSetOrder('VYKDPH_5'), dbsetscope(SCOPE_BOTH,cky), dbgotop())

    do while .not. vykdph_i ->( eof())
       pky := strZero(vykdph_i->ndoklad_or,10) +strZero(vykdph_i->noddil_DPH,2) +strZero(vykdph_i->nradek_DPH,3)
       if  .not. vykdph_pw->(dbSeek(pky,,'VYKDPH_7'))
         mh_copyFld('vykdph_i','vykdph_pw',.t., .t.)
         *
         vykdph_pw->ndoklad    := (mFile)->ncisFak
         vykdph_pw->cdenik     := (mFile)->cdenik
         vykdph_pw->cobdobi    := (mFile)->cobdobi
         vykdph_pw->nrok       := (mFile)->nrok
         vykdph_pw->nobdobi    := (mFile)->nobdobi
         vykdph_pw->cobdobiDan := (mFile)->cobdobiDan
         vykdph_pw->nzakld_zal := 0                      // vykdph_pw->nzakld_or
         vykdph_pw->nsazba_zal := 0                      // vykdph_pw->nsazba_or
         *
         ucetdohd->(dbseek(upper(vykdph_i->cdenik_par) +strzero(vykdph_i->ncisFak,10),,'UCETDH_7'))
         vykdph_pw->cucetu_dok := ucetdohd->cucet_uct
         *
         vykdph_pw->nUhrCelFAK := ucetdohd->nUhrCelFAK
         vykdph_pw->nUhrCelFAZ := ucetdohd->nUhrCelFAZ
         vykdph_pw->cZkratMenF := ucetdohd->cZkratMenF
         vykdph_pw->nKurzMenU  := CoalesceEmpty(ucetdohd->nKurzMenU,1)
         vykdph_pw->nMnozPreU  := CoalesceEmpty(ucetdohd->nMnozPreU,1)
         vykdph_pw->cky_pz     := cky_pz
         *
         vykdph_pw->nzakld_dph := vykdph_pw->nzakld_zal * (-1)
         vykdph_pw->nsazba_dph := vykdph_pw->nsazba_zal * (-1)
         vykdph_pw->lis_zal    := .t.
         vykdph_pw->nporadi    := 1

         vykdph_pw->nrecVyk    := 0   // vykdph_i->(recno())
      endif

      vykdph_i->(dbSkip())
    enddo

    (pFile)->(dbSkip())
  enddo

  (pFile) ->( dbgoTop())
return


*
** CLASS for FIN_parzalfak_vykdph_IN ********************************************
CLASS FIN_parzalfak_vykdph_IN FROM drgUsrClass
exported:
  var     kuplatneni    , uplatneno    , zaklMena
  var     kuplatneni_zFA, uplatneno_zFA, uhrCelFak
  var     kuplat_v_cm, uplat_v_cm
  *
  var     mainFile

  method  init, drgDialogInit, drgDialogStart, drgDialogEnd, postLastField, fin_cmdph
  method  postValidate

  inline method eBro_saveEditRow(o_eBro)
    ::sumColumn()
    return .t.

  inline access assign method preDanPov() var preDanPov
    return if( vykDph_Pw->lpreDanPov, MIS_CHECK_BMP, 0)


  inline access assign method cradek_dph() var cradek_dph
    local  cky := strZero(vykdph_pw ->noddil_dph,2) + ;
                  strZero(vykdph_pw ->nradek_dph,3) + ;
                  strZero(vykdph_pw ->ndat_od,8)

    c_vykdph->(dbSeek(cky,,'VYKDPH4'))
  return(c_vykDph->cradek_say)
  *
  ** event *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nEvent = xbeBRW_ItemMarked)
      ::sumColumn()
      return .f.

    case(nevent = drgEVENT_EXIT .or. nevent = drgEVENT_QUIT)
      vykdph_pw->(dbcommit())
      vykdph_pw->(dbgotop(), dbeval( {|| ( vykdph_pw->nzakld_dph := vykdph_pw->nzakld_zal *(-1), ;
                                           vykdph_pw->nsazba_dph := vykdph_pw->nsazba_zal *(-1)  ) }))
      return .f.

    otherwise
      return .f.

    endcase
  return .t.

HIDDEN:
  var    msg, dm, dc, df

  VAR    typ, subTitle
  VAR    obrow, inEdit, aEdits, editPos, drgGet, roundDph, lNEWrec
  *
  * sumColum
  inline method sumColumn(inStartDialog)
    local  x, value, npos
    local  zakld_or := sazba_or := zakld_zal := sazba_zal := 0
    *
    local  koeF := 1, kuplat_v_cm := uplat_v_cm := 0
    local  uhrCelFak  := (::mainFile)->nuhrcelFak
    local  parZalFak  := (::mainFile)->nparZalFak
    *
    local  pa     := { {'nzakld_or',0}, {'nsazba_or',0}, {'nzakld_zal',0}, {'nsazba_zal',0} }
    local  ardef  := ::obrow:cargo:ardef

    default inStartDialog to .f.

    vykdph_ps->(dbgotop())
    do while .not. vykdph_ps->(eof())
      if vykdph_pw->ncisfak = vykdph_ps->ncisfak

        zakld_or    += vykdph_ps->nzakld_or
        sazba_or    += vykdph_ps->nsazba_or
        zakld_zal   += vykdph_ps->nzakld_zal
        sazba_zal   += vykdph_ps->nsazba_zal
        *
        koeF        := (vykdph_pw->nkurzMENU / vykdph_pw->nmnozPREU )
        kuplat_v_cm += (vykdph_ps->nzakld_or  +vykdph_ps->nsazba_or ) / koeF
        uplat_v_cm  += (vykdph_ps->nzakld_zal +vykdph_ps->nsazba_zal) / koeF
      endif
      vykdph_ps->(dbskip())
    enddo

    ( pa[1,2] := zakld_or, pa[2,2] := sazba_or, pa[3,2] := zakld_zal, pa[4,2] := sazba_zal )

    for x := 1 to len(pa) step 1
      if ( npos := ascan( ardef, { |ait| pa[x,1] $ lower( ait[2]) })) <> 0
        value := str(pa[x,2])

        if ::obrow:getColumn(npos):Footing:getCell(1) <> value
          ::obrow:getColumn(npos):Footing:hide()
          ::obrow:getColumn(npos):Footing:setCell(1, value)
          ::obrow:getColumn(npos):Footing:show()
        endif
      endif
    next

    ::kuplatneni     := (zakld_or  +sazba_or )
    ::uplatneno      := (zakld_zal +sazba_zal)
    *
    if inStartDialog
      if ::lNEWrec
        * nový doklad ??
        kparZDokl := uhrCelFak - parZalFak
      else
        * oprava již uloženého dokladu
        kparZDokl := ( uhrCelFak - parZalFak ) + ::uplatneno
      endif

     ::kuplatneni_zFA := if(    kparZDokl > ::kuplatneni,  kparZDokl - ::kuplatneni, 0 )
**      ::kuplatneni_zFA := if(   uhrCelFak > ::kuplatneni,   uhrCelFak - ::kuplatneni, 0 )
      ::uplatneno_zFA  := if( ::uhrCelFak > ::uplatneno , ::uhrCelFak - ::uplatneno , 0 )
    endif
    *
    ::kuplat_v_cm    := kuplat_v_cm  + ( ::kuplatneni_zFA / koeF )
    ::uplat_v_cm     := uplat_v_cm   + ( ::uplatneno_zFA  / koeF )
  return zakld_zal+sazba_zal


  inline method setBroFocus()
    local  members := ::df:aMembers, brow := ::obrow:cargo, pos

    pos  := ascan(members,{|X| (x = brow)})
    ::df:olastdrg   := brow
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()
    *
    ::dc:oabrowse := brow
    PostAppEvent(xbeBRW_ItemMarked ,,,brow:oxbp)
  return .t.
ENDCLASS


/*
kolik mì zbývá k párování je uhrCelFak - parZalFak
ale - jsou tu dvì podmníky

1 - poøizuji nebo opravuji novou položku
2 -               opravuji       položku, ale ta už vytvoøila vazby a odeèet

tady je ještì další prùšvich -- chce párovat postupnì na víc položkách stejnou fakturu !!!
*/

method FIN_parzalfak_vykdph_IN:init(parent)
  LOCAL  nEvent,mp1,mp2,oXbp
  local  cisZalFak, main_cargo, _nrecor

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)

* 1 - parent  FIN_parzalfak_vykdph_IN
* 2 - parent  FIN_parprzal            /  FIN_fakvyshd_IN
* 3 - parent  FIN_fakprihd_IN

  * potøebuji si otevøít fakvyshd / fakprihd s jiným ALIAS
  drgDBMS:open( 'fakvyshd',,,,, 'fakvys_rvw' )

  do case
  case( lower(parent:parent:formName) = 'fin_parprzal' )
    *
    *  FAKPRIHD
    *
    cisZalFak   := parent:parent:dataManager:get( 'parprzalw->ncisZalFak' )
    main_cargo  := parent:parent:parent:cargo
        _nrecor := parent:parent:dataManager:get( 'parprzalw->_nrecor'    )

    ::mainFile := 'fakprih_ow'

    (::mainFile) ->( dbseek( cisZalFak,, 'FPRIHD1' ))

   case( lower(parent:parent:formName) = 'fin_fakprihd_it_in' )
     *
     *  FAKPRIHD - IT
     *
     cisZalFak   := parent:parent:dataManager:get( 'fakpriitw->ncisZalFak' )
     main_cargo  := parent:parent:cargo
         _nrecor := parent:parent:dataManager:get( 'fakpriitw->_nrecor'    )

    ::mainFile := 'fakprih_ow'

    (::mainFile) ->( dbseek( cisZalFak,, 'FPRIHD1' ))

   otherWise
     *
     *  FAKVYSHD
     *
     cisZalFak   := parent:parent:dataManager:get( 'fakvysitw->ncisZalFak' )
     main_cargo  := parent:parent:cargo
         _nrecor := parent:parent:dataManager:get( 'fakvysitw->_nrecor'    )

     ::mainFile := 'fakvys_rvw'

     (::mainFile) ->( dbseek( cisZalFak,, 'FODBHD1' ))
   endCase

  * nový doklad žádná vazba na okolí
  if .not. (main_cargo = drgEVENT_EDIT)
    ::lNEWrec := .t.

  * oprava dokladu, ale pololožka mùže byt jak nová / opravovaná
  else
     ::lNEWrec := ( _nrecor = 0 )
  endif

  ::zaklMena      := SysConfig('Finance:cZaklMENA')
  ::drgGet        := IsDrgGet(oXbp:cargo)
  ::typ           := IsNull(parent:parent:UDCP:typ_lik, '')
  ::roundDph      := SysConfig('Finance:nRoundDph')

  * k uplatnìní z faktury tento údaj múže být jak v CZ tak v napø EUR
  * potøebujem vždy pøevzít CZ
  ::uhrCelFak      := parent:cargo_usr
  ::kuplatneni_zFA := 0
  ::uplatneno_zFA  := 0

  ::drgUsrClass:init(parent)
return self


method FIN_parzalfak_vykdph_IN:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  endif
return


method FIN_parzalfak_vykdph_in:drgDialogStart(drgDialog)
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::obrow        := ::dc:obrowse[1]:oxbp
  ::obrow:colPos := 5

  ::sumColumn(.t.)
return self


method FIN_parzalfak_vykdph_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()
  *
  local  odrg, sazba_zal

  do case
  case (name = 'vykdph_pw->nzakld_zal')
    if value <> drgVar:prevValue

      vykdph_pw->(flock())

      sazba_zal := mh_roundnumb((value/100) * vykdph_pw->nprocdph, ::roundDph)

      odrg := ::dm:has('vykdph_pw->nsazba_zal')
      odrg:set(sazba_zal)

      * je to blbec snaží se o pøepoèet pøi uložení - mìl bych to strèit na EBro
      drgVar:prevValue := value
    endif

  case ( name = 'm->uplatneno_zfa' )
    if ::kuplatneni_zFA >= value
      ::uplatneno_zFA := value
    else
      ok := .f.
    endif

    if( ok, ::setBroFocus(), nil )
  endcase
return ok


method FIN_parzalfak_vykdph_in:drgDialogEnd()

  vykdph_pw->(dbcommit(), ;
              dbgotop() , ;
              dbeval( {|| ( vykdph_pw->nzakld_dph := vykdph_pw->nzakld_zal *(-1), ;
                            vykdph_pw->nsazba_dph := vykdph_pw->nsazba_zal *(-1)  ) }))

  vykdph_pw->(dbclearfilter())
return self


method FIN_parzalfak_vykdph_IN:postLastField(drgVar)
  local  name := lower(drgVar:name)

  if (name = 'vykdph_pw->nzakld_zal' .and. drgVar:itemChanged())
     vykdph_pw->nsazba_zal := mh_roundnumb((drgVar:value/100) * vykdph_pw->nprocdph, ::roundDph)
   endif

  ::dataManager:save()
  ::oBROw:refreshCurrent()

**-  ::killRead(.T.)
  ::sumColumn()
return .t.


method FIN_parzalfak_vykdph_IN:FIN_cmdph(drgDialog)
  LOCAL oDialog, nExit, odrg := drgDialog:oform:olastdrg

  DRGDIALOG FORM 'FIN_CMDPH' PARENT drgDialog MODAL DESTROY  EXITSTATE nExit

  if(nExit != drgEVENT_QUIT)
    ::obrow:refreshcurrent()
    postappevent(drgEVENT_EDIT,,,::obrow)
  endif

  ::sumColumn()
RETURN (nExit != drgEVENT_QUIT)