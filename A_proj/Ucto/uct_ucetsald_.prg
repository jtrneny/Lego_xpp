#include "appevent.ch"
#include "Common.ch"
#include "xbp.ch'
*
#include "drg.ch"
#include "DRGres.Ch'
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define  _TSK_deniky { { SYSCONFIG('UCTO:cDENIKUCDO'   ), 'UÈTO    _úèetní doklad ' }, ;
                       { SYSCONFIG('FINANCE:cDENIKFAPR'), 'FINANCE _závazky       ' }, ;
                       { SYSCONFIG('FINANCE:cDENIKFAVY'), 'FINANCE _pohledávky    ' }, ;
                       { SYSCONFIG('FINANCE:cDENIKBAVY'), 'FINANCE _banka         ' }, ;
                       { SYSCONFIG('FINANCE:cDenikFIPO'), 'FINANCE _pokladna      ' }, ;
                       { SYSCONFIG('FINANCE:cDenikFIDO'), 'FINANCE _úèetní dolad  ' }, ;
                       { SYSCONFIG('SKLADY:cDenik'     ), 'SKLADY  _pohyby        ' }, ;
                       { SYSCONFIG('MZDY:cDENIKMZDY'   ), 'MZDY    _hrubé mzdy    ' }, ;
                       { SYSCONFIG('MZDY:cDENIKMZDN'   ), 'MZDY    _hrubé mzdy    ' }, ;
                       { SYSCONFIG('MZDY:cDENIKMZDS'   ), 'MZDY    _srážky        ' }, ;
                       { SYSCONFIG('IM:cDENIKIM'       ), 'IM      _pohyby        ' }, ;
                       { SYSCONFIG('ZVIRATA:cDENIKZVZ' ), 'ZVÍØATA _zásoby        ' }, ;
                       { SYSCONFIG('ZVIRATA:cDENIKZV'  ), 'ZVÍØATA _základní stádo' }  }

// XTRANSLATE //
#xtranslate  .nKCMD   => \[3\]
#xtranslate  .nKCDAL  => \[4\]
#xtranslate  .nROK    => \[5\]
#xtranslate  .nOBDOBI => \[6\]

// STATIC   //
STATIC paAKT_ob


*
** CLASS for FRM UCT_ucetsald_CRD **********************************************
CLASS UCT_ucetsald_CRD FROM drgUsrClass
EXPORTED:
  var     aktivniObd, nastaveni
  VAR     nState       // 0 - inBrowse  1 - inEdit  2 - inAppend

  method  init, comboBoxInit, drgDialogStart, itemMarked, comboItemSelected
  METHOD  eventHandled

  method  preValidate, postValidate, postLastField

  * bro - ucetsalk
  inline access assign method isClose_Salk() var isClose_Salk
    return if(ucetsalk->lIsClose, DRG_ICON_SELECTT, DRG_ICON_SELECTF)

  inline access assign method inUcetpol_Salk() var inUcetpol_Salk
    local  cKy := strZero(ucetsalk->nrok,4 ) +strZero(ucetsalk->nobdobi,2) + ;
                  upper  (ucetsalk->cucetMd) +upper  (ucetsalk->csymbol)
    *
    return if( ucetpol ->(dbSeek(cKy,, AdsCtag(13) )), DRG_ICON_SELECTT, DRG_ICON_SELECTF)

  inline access assign method nazUct_Salk() var nazUct_Salk
     c_uctosn->(ordSetFocus('UCTOSN1'), dbSeek(upper(ucetsalk->cucetMd)))
     return c_uctosn->cnaz_uct

  * bro - ucetsald
  inline access assign method inUcetpol_Sald() var inUcetpol_Sald
    local  cKy := strZero(ucetsald->nrok,4 ) +strZero(ucetsald->nobdobi,2)  + ;
                  upper  (ucetsald->cdenik ) +strZero(ucetsald->ndoklad,10) + ;
                  upper  (ucetsald->cucetMd) +upper  (ucetsald->csymbol)
    *
    return if( ucetpol ->(dbSeek(cKy,, AdsCtag(9) )), DRG_ICON_SELECTT, DRG_ICON_SELECTF)

  inline access assign method obd_Sald() var obd_Sald
    return str(ucetsald->nobdobi,2) +'/' +str(ucetsald->nrok,4)

HIDDEN:
  method  showGroup, ucetsald_wrt, ucetsald_akt, ucetsald_del
  var     aEdits, members, filtr, paSal_DK, paObd_UCT

  var     msg, dm, dc, df, oabro

  * filtr
  inline method setFilter()
    local filter := format(::filtr, {left(::aktivniObd,4),right(::aktivniObd,2)})

    ::obdobi_uct()

    filter += if( ::nastaveni = '0', ' .and. !lIsClose', ;
              if( ::nastaveni = '1', ' .and.  lIsClose', ''))

    ucetsalk->(ads_setAof(filter))  // , dbgoTop())

    ::oabro[1]:oxbp:refreshAll()
    ::dc:oaBrowse := ::oaBro[1]
    *
    PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
    SetAppFocus(::oabro[1]:oXbp)
    return self

  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  * opravovat, pøidávat a rušit lze jen v nastavení KOMLETNÍ SALDO
  inline method beforeModi()
    local nsel, ok := .t.
/*
    if ::nastaveni <> '2'
      nsel := ConfirmBox( ,'Modifikovat saldo lze pouze v nastavení [ KOMPETNÍ SALDO ], pøepnout nastavení ?', ;
                           'Pøepnout nastavení salda ...' , ;
                            XBPMB_YESNO                   , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE)

      if(ok := (nsel = XBPMB_RET_YES))
        ::nastaveni := '2'
        ::dm:set('m->uct_ucetsald_crd:nastaveni',::nastaveni)
        ::setFilter()
      endif
    endif
*/
  return ok

  * zmìna období naplníme data pro modifikaci K
  inline method obdobi_uct()
    local  pa := {}, cky, nrok_Ak := uctOBDOBI:UCT:NROK
    *
    ucetsys->( dbSetScope( SCOPE_BOTH, 'U' +str(nrok_Ak,4)), dbgoTop())

    do while .not. ucetsys->(eof())
      cky     := strZero(ucetsys->nrok,4) +strZero(ucetsys->nobdobi,2)
      if ucetsalkW->(dbseek(cky,,'UCSALD06'))
        AAdd( pa, { strZero(ucetsys->nrok,4) +strzero(ucetsys->nobdobi,2), ;
                    'Saldo k období _ ' +str(ucetsys->nobdobi,2) +'/' +str(ucetsys->nrok,4), ;
                    0                , ;
                    0                , ;
                    ucetsys->nrok    , ;
                    ucetsys->nobdobi   })
      endif
      ucetsys->(dbskip())
    enddo

    ::paObd_UCT := aclone(pa)
    
    ucetsys->( dbClearScope())
  return nil

ENDCLASS


method UCT_ucetsald_CRD:init(parent)
  ::drgUsrClass:init(parent)

  ::aktivniObd := strZero(uctOBDOBI:UCT:NROK,4) +strZero(uctOBDOBI:UCT:NOBDOBI,2)
  ::nastaveni  := '0'

  ::aEdits     := {}
  ::filtr      := "nROK = %% .and. nOBDOBI = %%"
  ::nState     := 0

  drgDBMS:open('ucetsalk')
  drgDBMS:open('ucetsalk',,,,,'ucetsalkw')
  drgDBMS:open('ucetsald')
  drgDBMS:open('ucetsald',,,,,'ucetsaldw')
  *
  drgDBMS:open('c_uctosn')
  drgDBMS:open('ucetpol' )
  drgDBMS:open('ucetsys' ) ; ucetsys->(ordSetFocus( AdsCtag( 3 )))
return self


method UCT_ucetsald_CRD:comboBoxInit(drgComboBox)
  local  name       := lower(drgComboBox:name)
  local  acombo_val := {}
  *
  if 'denik' $ name
    acombo_val := _TSK_deniky

    drgComboBox:oXbp:clear()
    drgComboBox:values := acombo_val
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endif
RETURN SELF


method UCT_ucetsald_CRD:drgDialogStart(drgDialog)
  local  x, brow, item
  *
  local  it_pov := 'cucetmd,csymbol,cdenik'
  local  pp_nep := drgPP:getPP(drgPP_PP_EDIT1)
  local  pp_pov := drgPP:getPP(drgPP_PP_EDIT2)

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::oabro    := drgDialog:dialogCtrl:obrowse
  ::members  := drgDialog:oForm:aMembers

  for x := 1 to LEN(::members) step 1
    if isMemberVar(::members[x], 'groups') .and. isNull(::members[x]:groups,'') <> ''
      item := lower(drgParseSecond(::members[x]:name,'>'))
      AAdd(::aEdits, {::members[x], if( (item $ it_pov), pp_pov[2,2], pp_nep[2,2]), XBPSYSCLR_3DFACE })
    endif
  next

  * patièky u ucetsald
  brow := ::oaBro[2]:oxbp
  if isobject(brow)
    for x := 1 to brow:colCount step 1
      ocolumn := brow:getColumn(x)

      ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
      ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
      ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
      ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
      ocolumn:configure()
    next
    brow:configure():refreshAll()
  endif

  ::setFilter()
return self


method UCT_ucetsald_CRD:itemMarked()
  local  cKy :=  upper(ucetsalk->cucetMd) +upper(ucetsalk->csymbol)

  if( cKy <> ucetsald->(dbScope(SCOPE_TOP)), ucetsald->(dbSetScope(SCOPE_BOTH, cKy), dbGoTop()), nil)
  ::showGroup()
  ::paSal_DK := { ucetsald->(recNo())              , ucetsalk->(recNo())      , ;
                  ucetsald->csymbol                , ucetsald->(sx_keyData(2)), ;
                  left(ucetsald->(sx_keyData()),21), ucetsald->cucetMd          }
return self


method UCT_ucetsald_CRD:comboItemSelected(mp1, mp2, o)
  local  name    := lower(mp1:name)

  do case
  case 'aktivniobd' $ name
    if(::aktivniObd <> mp1:value, (::aktivniObd := mp1:value, ::setFilter()), nil)

  case 'nastaveni'  $ name
    IF( ::nastaveni <> mp1:value, (::nastaveni  := mp1:value, ::setFilter()), nil)

  endCase
return .t.


method UCT_ucetsald_CRD:eventHandled(nEvent, mp1, mp2, oXbp)
  local  lastDrg := ::df:oLastDrg
  local  currRec

  do case
  case(nEvent = xbeBRW_ItemMarked)
    if(::nState <> 0, (::restColor(),::showGroup()), nil)
    ::nState := 0
    return  .f.

  * zmìna období - budeme reagovat
  case(nevent = drgEVENT_OBDOBICHANGED)
    ::aktivniObd := strZero(uctOBDOBI:UCT:NROK,4) +strZero(uctOBDOBI:UCT:NOBDOBI,2)
    ::setFilter()
    return .t.

  * opravovat lze pouze UCETSALD
  case(nEvent = drgEVENT_EDIT)
    if ::beforeModi()
      if ::dc:oaBrowse <> ::oaBro[2]
        ::dc:oaBrowse := ::oaBro[2]
        ::dc:oaBrowse:oxbp:refreshAll()
        PostAppEvent(xbeBRW_ItemMarked,,,::oabro[2]:oxbp)
      endif

      ::nState := 1
      if oXbp:className() = 'XbpGet'
        ::df:setNextFocus(oXbp:cargo:name,,.t.)
      else
        ::df:setNextFocus('ucetsald->csymbol',, .t. )
      endif
    endif
    return .t.

  * na UCETSALK  zakládáme po uložení UCETSALK + UCETSALD
  * na UCETDALD  zakládáme po uložení            UCETSALD
  case(nEvent = drgEVENT_APPEND)
    if ::beforeModi()

      ::dm:refreshAndSetEmpty( 'ucetsald' )

      ::nState   := 2
      ::showGroup()
      ::df:setNextFocus('ucetsald->cucetmd',, .t. )
    endif
    return .t.

  case(nEvent = drgEVENT_SAVE)
    ::postLastField()
    return .t.

  case(nEvent = drgEVENT_DELETE)
    if ::beforeModi()
      ::ucetsald_del()
    endif
    return .t.

  case(nEvent = xbeP_Keyboard)
    if mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
      ::df:setNextFocus(AScan(::members,::dc:oaBrowse),,.t.)
      PostAppEvent(xbeBRW_ItemMarked,,,::dc:oaBrowse:oxbp)
      return .t.

    else
      return .f.
    endif

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


method UCT_ucetsald_CRD:preValidate(drgVar)
  local  name   := lower(drgVar:name)
  local  nevent := mp1 := mp2 := nil

  nevent  := LastAppEvent(@mp1,@mp2)

  if nevent = xbeP_SetInputFocus .and. .not. left(name,3) = 'm->'
    PostAppEvent(drgEVENT_EDIT,,,drgVar:oDrg:oXbp)   // ,,,::dc:oaBrowse:oxbp)
    ::nState := 1
  endif
return .t.


METHOD UCT_ucetsald_CRD:postValidate(drgVar)                                     // kotroly a výpoèty
  local  value  := drgVar:get()
  local  name   := lower(drgVAR:name)
  local  ok     := .T., changed := drgVAR:changed()
  local  nevent := mp1 := mp2 := nil, isF4 := .F., nsel
  local  ucetMd
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case('cucetmd' $ name)
  * nesmí být prázdný jen saldokontní

  case('csymbol' $ name)
    ucetMd := ::dm:get('ucetsald->cucetMd')
    if .not. ucetsalkw->(dbSeek( upper(ucetMd) +upper(value),, AdsCtag(1) ))
      nsel := ConfirmBox( ,'Úèet _ '+ ucetMd +' a V_symbol '+ value +' v saldu NEEXISTUJE, založit nový ?', ;
                           'Zaloložení nové položky salda ...', ;
                            XBPMB_YESNO                     , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

      ok := (nsel = XBPMB_RET_YES)
    endif
  endcase


  if( ok .and. name = 'ucetsald->ctext')
     if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
       PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
     endif
  endif
return ok


** ukládáme **
method UCT_ucetsald_CRD:postLastField(drgVar)
  local  lZmena := ::dm:changed(), recNo := ucetsalk->(recNo())

  if lZmena
    if ::ucetsald_wrt()
    else
      drgMsgBox('Nelze uložit zmìny do salda, BLOKOVÁNO uživatelem ...!!!')
    endif
  endif

  ucetsalk ->(dbgoTo(recNo))
  AEval(::oabro, {|x| x:oxbp:refreshAll()})
  ::df:setNextFocus(AScan(::members,::dc:oaBrowse),,.t.)
  PostAppEvent(xbeBRW_ItemMarked,,,::oaBro[1]:oxbp)
return .t.


*
** hidden methods and static functions
method UCT_ucetsald_CRD:showGroup()
  local  x, isEdit := (::nState = 2)

  for x = 1 to len(::aEdits) step 1
    ::aEdits[x,1]:isEdit := isEdit
    ::aEdits[x,1]:oxbp:setColorBG(if(isEdit, ::aEdits[x,2], ::aEdits[x,3]))
  next
return self

*
** zápis do ucetsald, ucetsalk, ucetpol
method UCT_ucetsald_CRD:ucetsald_wrt()
  local  ucetMd  := ::dm:get('ucetsald->cucetMd')
  local  csymbol := ::dm:get('ucetsald->csymbol')
  *
  local  cKy, ok := .t., anUcp := {}, lUcp := .t., lUcp_mod := .t.
  local  lnewRec, recNo := ucetsalk->(recNo())
  local  linSalk

  lnewRec := ::dm:has('ucetsald->cucetMd'):odrg:isEdit
  cKy     := upper(ucetMd) +upper(csymbol)
  linSalk := ucetsalkw->(dbSeek(cKy,, AdsCtag(1) ))          // alias -> ucetsalk

  if .not. lnewRec .and. ::paSal_DK[3] <> csymbol
    ucetpol->(ordSetFocus('UCETPO09')              , ;
              dbsetScope(SCOPE_BOTH, ::paSal_DK[4]), ;
              dbGoTop()                            , ;
              dbEval( {|| AAdd(anUcp, ucetpol->(recNo())) })     )
    if len(anUcp) > 0
      lUcp     := ucetpol->(sx_RLock(anUcp))
      lUcp_mod := lUcp
    endif
  endif

  do case
  case( lnewRec       .and. .not. linSalk)       //-NOVÝ    záznam není v (K,D)-
    ok := (lUcp .and. ADDrec('ucetsald'))
    if ok
      ::dm:save()
      ::ucetsald_akt(cKy)
    endif

  case( lnewRec       .and.       linSalk)       //-NOVÝ    záznam   je v (K, )-
    ok := (lUcp .and. ADDrec('ucetsald') .and. ucetsalk->(sx_RLock()))
    if ok
      ::dm:save()
      ::ucetsald_akt(cKy)
    endif

  case( .not. lnewRec .and. .not. linSalk)       //-OPRAVA  záznam není v (K, )-
    ok := (lUcp .and. ucetsald->(sx_RLock(::paSal_DK[1])) ;
                .and. ucetsalk->(sx_RLock(::paSal_DK[2])) )
    if ok
      ucetsald->(dbGoTo(::paSal_DK[1]))
      ::dm:save()
      ::ucetsald_akt(cKy)
      ::ucetsald_akt(::paSal_DK[5],,.t.)
      if(lUcp_mod, ucetsald_pol(csymbol,anUcp), nil)
    endif

  case( .not. lnewREC .and.       linSalk)       //-OPRAVA  zázman   je v (K, )-
    ok := (lUcp .and. ucetsalk->(sx_RLock())              ;
                .and. ucetsald->(sx_RLock(::paSal_DK[1])) ;
                .and. ucetsalk->(sx_RLock(::paSal_DK[2])) )
    if ok
      ucetsald->(dbGoTo(::paSal_DK[1]))
      ::dm:save()
      ::ucetsald_akt(cKy)
      if(::paSal_DK[3] <> csymbol,::ucetsald_akt(::paSal_DK[5],,.t.), nil)
      if(lUcp_mod                ,  ucetsald_pol(csymbol,anUcp)     , nil)
    endif
  endcase

  ucetsalk->(dbCommit(), dbUnlock())
   ucetsald->(dbCommit(), dbUnlock())
     ucetpol ->(dbCommit(), dbUnlock(), dbClearScope())
return ok

method UCT_ucetsald_CRD:ucetsald_akt(cKey,lDel,lMod)
  local  rok_D, obd_D, obd_Od, obd_Do, nstep, nstart
  local  cKy := strZero(ucetsald->nrok,4) +strZero(ucetsald->nobdobi,2)
  local  pa  := aclone(::paObd_UCT)
  local  anSalk := {}, recNo

  DEFAULT lMod to .f., lDel to .f.

  ucetsald ->(dbCommit())
  ucetsaldw->(ordsetFocus('UCSALD09'), dbsetScope(SCOPE_BOTH, cKey), dbgoTop())

  do while .not. ucetsaldw->(eof())
    rok_D := ucetsaldw->nrok
    obd_D := ucetsaldw->nobdobi

    AEval( pa, { |x| ;
      if( x.nROK > rok_D                         , ;
        ( x.nKCMD += ucetsaldw->nkcMd, x.nKCDAL += ucetsaldw->nkcDal), ;
      If( x.nROK = rok_D .and. x.nOBDOBI >= obd_D, ;
        ( x.nKCMD += ucetsaldw->nkcMd, x.nKCDAL += ucetsaldw->nkcDal), nil )) } )

    ucetsaldw->(dbSkip())
  enddo
  ucetsaldw->(dbClearScope())

  nstart := AScan(pa, {|x| x[1] = cKy})
  if(nstart = 0, nstart := 1, nil)

  obd_Od := left(cKey,21) + pa[nstart ,1]
  obd_Do := left(cKey,21) + pa[len(pa),1]

  ucetsalkw->( ordSetFocus('UCSALD06')         , ;
               dbsetScope(SCOPE_TOP   , obd_Od), ;
               dbsetScope(SCOPE_BOTTOM, obd_Do), ;
               dbgoTop()                       , ;
               DbEval( {|| AAdd(anSalk, ucetsalkw->(recNo())) }) )
  ucetsalkw->(dbClearScope())

  if ucetsalk->(sx_RLock(anSalk))
    for nstep := nstart to len(pa) step 1
      cKy := left(obd_Od,21) +pa[nstep,1]

      if ucetsalkw->(dbSeek(cKy,, AdsCtag(8) ))
        recNo := ucetsalkw->(recNo())
        ucetsalk->(dbGoTo(recNo),sx_RLock())
      else
        mh_copyFld('ucetsald', 'ucetsalk',.t.,.f.)

        if lMod ; ucetsalk->cucetMd := ::paSal_DK[6]
                  ucetsalk->csymbol := ::paSal_DK[3]
        endif
        ucetsalk->nrok    := pa[nstep,5]
        ucetsalk->nobdobi := pa[nstep,6]
      endif

      ** rušíme položku
      If     lDel
        ucetsalk->(dbDelete())
      Else
        ucetsalk->nkcMd    := pa[nstep,3]
        ucetsalk->nkcDal   := pa[nstep,4]
        ucetsalk->lIsClose := (ucetsalk->nkcMd = ucetsalk->nkcDal)
      EndIf
    next
  endif
return .t.


static function ucetsald_pol(csymbol,anUcp)
  local  nstep

  for nstep := 1 to len(anUcp) step 1
    ucetpol->(dbGoTo(anUcp[nstep]))
    ucetpol->csymbol := csymbol
  next
return nil


method UCT_ucetsald_CRD:ucetsald_del()
  local  nsel, nodel := .f., ok := .t., cc, cKy
  local  in_k        := (::dc:oaBrowse = ::oaBro[1])
  local  anSald      := {}, lLock := .t.
  *
  local  cMess := 'Požadujete zrušit '
  local  cTitl := 'Zrušení '
  local  ky    := allTrim(ucetsalk->cucetMd +' / ' +ucetsalk->csymbol) + ;
                  if(in_k, '', ' / ' +strZero(ucetsald->ndoklad,10))

  fordRec({'ucetsald'})
  ucetsald->(dbGoTop()                                                        , ;
             dbEval({ || (ok := ok .and. (::inUcetpol_Sald = DRG_ICON_SELECTF), ;
                          AAdd(anSald, ucetsald->(recNo()))                     ) }) )
  fordRec()

  if in_k
    lLock := (ucetsald->(sx_RLock(anSald)) .and. ucetsalk->(sx_RLock()))
    (cMess += 'aktuálni saldo ...'     , cTitl += 'saldokota ...'        )
  else
    ok    :=  (::inUcetpol_Sald = DRG_ICON_SELECTF)
    lLock := (ucetsald->(sx_RLock())       .and. ucetsalk->(sx_RLock()))
    (cMess += 'položku saldokonta ...' , cTitl += 'položky saldokota ...')
  endif

  if ok .and. lLock
    nsel := ConfirmBox( ,cMess +chr(13) +chr(10) +ky, ;
                         cTitl                      , ;
                         XBPMB_YESNO                , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

   if nsel = XBPMB_RET_YES
     if in_k
       ucetsald->(dbGoTop(), dbEval({|| ucetsald->(dbDelete()) }))
       ucetsalk->(dbDelete())
     else
       cKy := upper(ucetsald->cucetMd) +upper(ucetsald->csymbol)
       ucetsald->(dbDelete())
       ::ucetsald_akt(cKy,,.t.)
     endif
   endif
  else
    nodel := .t.
  endif

  if nodel
    cc := if(lLock, ' má vazbu na likvidaci ', ' blokován uživatelem ') +' ...'
    ConfirmBox( ,'Záznam salda ...' +chr(13) +chr(10) +ky + chr(10) +chr(13) +' nelze zrušit ' +cc, ;
                 cTitl                           , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ucetsalk->(dbUnlock(), dbCommit())
   ucetsald->(dbUnlock(), dbCommit())

   AEval(::oabro, {|x| x:oxbp:refreshAll()})
   ::df:setNextFocus(AScan(::members,::dc:oaBrowse),,.t.)
   PostAppEvent(xbeBRW_ItemMarked,,,::oaBro[1]:oxbp)
return .t.