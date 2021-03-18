#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
//
#include "drgRes.ch"
#include "..\FINANCE\FIN_finance.ch"


#define m_files  { 'typdokl'   ,'c_typoh'                        , ;
                   'c_bankuc'  ,'c_uctosn' ,'c_meny'  ,'c_staty' , ;
                   'kurzit'    ,'fakprihd' ,'fakvyshd','ucetpol' , ;
                   'firmy'                                       , ;
                   'banvyph_im','banvypi_im','datkomhd'            }


*  BANKOVNÍ VÝPISY _ FIN_banvyphd_in_bav ***************************************
CLASS FIN_banvyphd_in_ban FROM FIN_ban_vzz_pok_IN
EXPORTED:
  METHOD  init
ENDCLASS

METHOD FIN_banvyphd_in_ban:init(parent)
    parent:formName  := 'FIN_ban_vzz_IN'
    parent:initParam := 'FIN_ban_vzz_pok_IN'

  ::drgUsrClass:init(parent)
  ::FIN_ban_vzz_pok_in:init(parent,'ban')
RETURN self


*  VZÁJEMNÉ ZÁPOÈTY _ FIN_banvyphd_in_vzz **************************************
CLASS FIN_banvyphd_in_vzz FROM FIN_ban_vzz_pok_in
EXPORTED:
  METHOD  init
ENDCLASS

METHOD FIN_banvyphd_in_vzz:init(parent)
  parent:formName  := 'FIN_ban_vzz_IN'
  parent:initParam := 'FIN_ban_vzz_pok_IN'

  ::drgUsrClass:init(parent)
  ::FIN_ban_vzz_pok_in:init(parent,'vzz')
RETURN self


*  ÚHDADY ÚÈETNÍM DOKLADEM _ FIN_banvyphd_scr_uhr ******************************
CLASS FIN_banvyphd_in_uhr FROM FIN_ban_vzz_pok_in
EXPORTED:
  METHOD  init
ENDCLASS

METHOD FIN_banvyphd_in_uhr:init(parent)
  parent:formName  := 'FIN_ban_vzz_IN'
  parent:initParam := 'FIN_ban_vzz_pok_IN'

  ::drgUsrClass:init(parent)
  ::FIN_ban_vzz_pok_in:init(parent,'uhr')
RETURN self


*  POLOŽKY POKLADNÍHO DOKLADU _ FIN_pokladit_in ********************************
CLASS FIN_banvyphd_in_pok FROM FIN_ban_vzz_pok_in
EXPORTED:
  METHOD  init
ENDCLASS

METHOD FIN_banvyphd_in_pok:init(parent)
  parent:formName  := 'FIN_pokladit_IN'
  parent:initParam := 'FIN_ban_vzz_pok_IN'

  ::drgUsrClass:init(parent)
  ::FIN_ban_vzz_pok_in:init(parent,'pok')
RETURN self


*
** CLASS for FIN_banvyphd_IN ban/vzz/uhr/pok ***********************************
STATIC CLASS FIN_ban_vzz_pok_IN FROM drgUsrClass, FIN_finance_IN, FIN_ban_vzz_pok
  exported:
  var     lNEWrec, rozPo, typ_dokl, is_ban, hd_file, it_file, aval_krp
  var     ain_file, varSym, cmb_typDokl, zaklMena
  *
  method  init, postValidate, overPostLastField
  method  comboItemSelected
  METHOD  postSave, postAppend, postDelete
  METHOD  drgDialogInit, drgDialogStart, drgDialogEnd

  * sel
  method  likpol_krp, showGroup

  * import
  method  postLastField, postLastField_mh, import_bavy, import_bavy_mh

  *
  ** pokud je pøi naètení nespárovaný varSym je potøeba indikovat zmìnu
  inline method postEdit()
    if (::it_file)->nerr_imp <> 0
      ::varSym:initValue := ''
    endif
  return self

  inline method postEscape()
    if .not. (::typ_dokl $ 'pok')
      if .not. empty( (::hd_file)->cfile_imp)
        if ::lNEWrec .and. ::nLockH_im <> 0
          banvyph_im->(dbRlock())
          banvyph_im->nstav_imp := 0
          banvyph_im->( dbUnlock(), dbCommit())
          banvypi_im->( dbUnlock(), dbCommit())
        endif
      endif
    endif
  return .t.


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local file_iv := alltrim(::dm:has(::it_file +'->cfile_iv'):value)
    local lastXbpInFocus

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)

      if( .not. empty(file_iv), (file_iv)->(dbgoto((::it_file)->ndoklad_iv)),nil)
      ::state    := if( (::it_file)->(eof()), 2, 0)
      ::aval_krp := {}

      if ::state <> 2
        if (::it_file)->nerr_imp <> 0
          (::varSym:odrg:isEdit := .T., ::varSym:odrg:oxbp:enable())
          (::cisFak:odrg:isEdit := .T., ::cisFak:odrg:oxbp:enable())

        else
          (::varSym:odrg:isEdit := .F., ::varSym:odrg:oxbp:disable())
          if Empty((::it_file)->cvarsym)
            (::cisFak:odrg:isEdit := .T., ::cisFak:odrg:oxbp:enable())
          else
            (::cisFak:odrg:isEdit := .F., ::cisFak:odrg:oxbp:disable())
          endif
        endif
      endif

    case ( nevent = xbeP_Close   )
      ::postEscape()

    otherwise
      if(nevent = drgEVENT_EDIT .or. nevent = drgEVENT_APPEND, ::aval_krp := {}, nil)

      return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .F.

 HIDDEN:
   VAR     paGroups, title, cisFak, nLockH_im, anLockI_im
   method  postValidateForm, open_in
ENDCLASS


method FIN_ban_vzz_pok_IN:init(parent,typ_dokl)
  local  x, pA  := {'...itw->ncenzakcel', '...itw->nuhrcelfak', ;
                    '...itw->ncenzahcel', '...itw->nuhrcelfaz'  }
  *
  for x := 1 to len(pa)
    pa[x] := StrTran(pa[x], '...', if(typ_dokl $ 'ban,vzz,uhr', 'banvyp', 'poklad'))
  next
  *
  if( typ_dokl $ 'ban,vzz,uhr', (::hd_file := 'banvyphdw', ::it_file := 'banvypitw'), ;
                                (::hd_file := 'pokladhdw', ::it_file := 'pokladitw')  )

  * vstupní soubory pro kontrolu na csymol
  ::ain_file := {{'fakprihd', 0, 0, 1,  9, SysConfig('FINANCE:cDENIKFAPR'), 'FPRIHD23' }, ;
                 {'fakvyshd', 0, 0, 2, 10, SysConfig('FINANCE:cDENIKFAVY'), 'FODBHD29' }  }
  *
  ::rozPo      := 0
  ::typ_dokl   := typ_dokl
  ::is_ban     := (typ_dokl = 'ban')
  ::lNEWrec    := .not. (parent:cargo = drgEVENT_EDIT)
  ::zaklMena   := SysConfig('Finance:cZaklMena')
  ::paGroups   := AClone(pa)
  ::aval_krp   := {}
  *
  ::nLockH_im  := 0
  ::anLockI_im := {}

  * základní soubory
  ::openfiles(m_files)

  * banka/vzájemné zápoèty
  drgDBMS:open('BANVYPHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('BANVYPITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  * u pokladny musí být soubory otevøeny na fin_pokladhd_in
  if .not. Used('POKLADHDw')
    drgDBMS:open('POKLADHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  endif
  if .not. Used('POKLADITw')
    drgDBMS:open('POKLADITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  endif

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, ::it_file, .t., .f.)  ;  (::it_file) ->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name,'banpok_w', .t., .t.)  ;  banpok_w ->(AdsSetOrder(1))

  ::FIN_ban_vzz_pok:init(self)

  if( typ_dokl $ 'ban,vzz,uhr', FIN_banvyp_cpy(self,typ_dokl), NIL)

  (::it_file) ->(Flock())
  ::FIN_ban_vzz_pok:map()
return self


method FIN_ban_vzz_pok_IN:drgDialogInit(drgDialog)
  local  apos, asize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog
  *
  local  members   := drgDialog:formObject:members, odrg, yPos

  for x := 1 to len(members) step 1
    if members[x]:className() = '_drgText' .and. .not. IsNull(members[x]:groups)
      odrg := members[x]
      if left(odrg:groups,3) = 'uhr'
        if ::typ_dokl = 'uhr'
          yPos := val(subStr(odrg:groups,at(':',odrg:groups)+1))
          odrg:cPos[2] := yPos
        endif
        odrg:groups := NIL
      endif
    endif
  next

  if ::typ_dokl $ 'pok'
//    XbpDialog:titleBar := .F.
    apos := drgDialog:parent:dialog:currentPos()
    drgDialog:usrPos := {aPos[1]+5,aPos[2]+28}
  endif

  ::title := if(::typ_dokl $ 'ban', ' bankovního výpisu'    , ;
             if(::typ_dokl $ 'vzz', ' vzájemného zápoètu'   , ;
             if(::typ_dokl $ 'uhr', ' úhrad faktur dokladem', ' úhrad faktur pokladnou')))

  drgDialog:formHeader:title += ::title +' ...'
RETURN


METHOD FIN_ban_vzz_pok_IN:drgDialogStart(drgDialog)
  local que_del := ' ' +::title, members, odrg

 * likvidace bankovní výpisy/vzájemné zápoèty/ úhrady pokladnou nemají RVDPH *
  ::FIN_finance_in:init(self,::typ_dokl,::it_file +'->cVARSYM',que_del,.t.)
  ::FIN_ban_vzz_pok:init(self)
  *
  if( ::typ_dokl $ 'pok')
    ::msg   := drgDialog:parent:udcp:msg
    members := ::df:amembers

    for x := 1 TO LEN(members) step 1
      odrg := members[x]

      if((odrg:className() = 'drgStatic') .or. ;
         (odrg:className() = 'drgText' .and. odrg:obord:type = 1), ;
         odrg:oxbp:setcolorbg(GraMakeRGBColor( {196, 196, 255} )), nil)
    next
  endif

  *
  ::drgVar_file_imp := ::dm:get(::hd_file +'->cfile_imp', .F.)
  ::cpath_imp       := ''
  ::cfile_imp       := ''

  *
  ::varSym          := ::dm:get(::it_file +'->cvarsym'  , .F.)
  ::cisFak          := ::dm:get(::it_file +'->ncisfak'  , .F.)

  if ::typ_dokl $ 'ban,vzz,uhr'
    ::cmb_typDokl := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  endif
  *
  ::import_bavy_mh()
  ::showGroup()
  ::sumColumn()
  ::dm:refresh()
 RETURN self


METHOD FIN_ban_vzz_pok_IN:drgDialogEnd(drgDialog)
  banvyphdw ->(DbCloseArea())
   banvypitw ->(DbCloseArea())
    banpok_w  ->(DbCloseArea())
     if( select( 'banvyph_iw' ) <> 0, banvyph_iw->( dbCloseArea()), nil )
      if( select( 'banvypi_iw' ) <> 0, banvypi_iw->( dbCloseArea()), nil )
RETURN


method FIN_ban_vzz_pok_IN:comboItemSelected(drgCombo,mp2,o)
  local  value, cKy

  if isobject(drgCombo)
    value := drgCombo:Value

    do case
    case 'cobdobi' = lower(right(drgCombo:name,7))
      ::cobdobi(drgCombo)

    case 'czkratmeny' $ lower(drgCombo:name)
      kurzit->(mh_seek(upper(value),2,,.t.))

      kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(value)))
      cKy := upper(value) +dtos((::hd_file)->ddatPoriz)
      kurzit->(dbSeek(cKy, .T.))
      If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

      (::hd_file)->czkratmeny := value
      (::hd_file)->nkurzahmen := kurzit->nkurzstred
      (::hd_file)->nmnozprep  := kurzit->nmnozprep

      kurzit->(dbclearScope())
      ::showGroup()
      ::refresh(drgCombo)
    endcase
  endif
return self


METHOD FIN_ban_vzz_pok_IN:postValidate(drgVar)
  local  value := drgVar:get(), ovar
  local  name  := lower(drgVar:name), file
  local  ok    := .T., changed := drgVAR:changed(), subtxt
  local  nevent := mp1 := mp2 := nil, isF4 := .F., npos
  *
  local  uhrcel, likpol

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  * po F4 nesedí nìkdy nLastDrgIx, pak to chybnì odskoèí
  if(name = 'banvyphdw->cucet_uct')
    npos := AScan(::df:aMembers,drgVar:odrg)
    if( npos <> ::df:nLastDrgIx, ::df:nLastDrgIx := npos, nil)
  endif


  do case
  * hlavièka dokladu
  case(name = 'banvyphdw->cbank_uct')
    ok := ::FIN_ban_vzz_pok:cbank_uct_vld()
    if( ok, ::import_bavy_mh(), nil )

  case(name = 'banvyphdw->nico'     )
    ok := ::FIN_ban_vzz_pok:firmyico_sel()

  case(name = 'banvyphdw->ddatporiz' .or. name = 'banvyphdw->ddatpovyp')
    if (name = 'banvyphdw->ddatporiz') .and. Empty(value)
      ::msg:writeMessage('Datum výpisu je povinný údaj ...',DRG_MSG_ERROR)
      ok := .F.
    else
      if StrZero(banvyphdw->nobdobi,2) +'/' +Str(banvyphdw->nrok,4) <> StrZero(Month(value),2) +'/' +Str( Year( value),4)
        subtxt := if(name = 'banvyphdw->ddatporiz', 'výpisu','stavu úètu')
        fin_info_box('Datum ' +subtxt +' nesouhlasí s obdobím dokladu...')
**        ::msg:writeMessage('Datum ' +subtxt +' nesouhlasí s obdobím dokladu...',DRG_MSG_WARNING)
      endif
    endif

    if(name = 'banvyphdw->ddatporiz' .and. ok)
      ovar := ::dm:has('banvyphdw->ddatzust')
      ovar:set(value)
      ovar:value := ovar:prevValue := value
    endif

  case(name = 'banvyphdw->ndoklad')
    file := ::open_in('banvyphd','banvyphd_e')

    if     Empty(value)
      ::msg:writeMessage('Èíslo dokladu je povinný údaj ...',DRG_MSG_ERROR)
      ok := .F.
    elseif (file) ->(DbSeek(Upper(banvyphdw->cdenik) +StrZero(value,10),, AdsCtag(12) ))
      ::msg:writeMessage('Duplicitní èíslo dokladu ...',DRG_MSG_ERROR)
      ok := .F.
    endif

  case(name $ 'banvyphdw->nkurzahmen,banvyphdw->nmnozprep')
    if empty(value)
      ::msg:writeMessage('Kurz a množství pøepoètu jsou povinné údaje ...',DRG_MSG_ERROR)
      ok := .F.
    endif

  * položky dokladu
  case(name = ::it_file +'->cvarsym')
    ok := ::FIN_ban_vzz_pok:cvarsym_vld()

    * pokud je vyplnìn v_symbol - zakážeme zmìnu ncisFak
    if ok .and. .not. empty(value)
      (::cisFak:odrg:isEdit := .F., ::cisFak:odrg:oxbp:disable())
    else
      (::cisFak:odrg:isEdit := .T., ::cisFak:odrg:oxbp:enable())
    endif

    * pro prázdný v_symbol pøehodíme typ na -
    if ok .and. ::state = 2 .and. empty(value)
      ::dm:set(::it_file +'->ntypObratu',2)
    endif

  case(name = ::it_file +'->cucet_uct')
    if .not. empty(value)
      if empty(::dm:get(::it_file +'->cvarSym'))
        ::dm:set(::it_file +'->ctext',it_ucet->cnaz_Uct)
      endif
    endif

  case(name $ 'banvypitw->ncenzakcel,banvypitw->ncenzahcel' .and. changed)
    uhrcel := ::dm:has('banvypitw->nuhrcelfak')
    likpol := ::dm:has('banvypitw->nlikpolbav')

    * pouze pøi poplatku
    if empty(::dm:get('banvypitw->cvarsym'))
      if ::istuz()
        if( value <> uhrcel:value .or. likpol:value = 0 )
          if( .not. empty(::dm:get('banvypitw->cvarsym')), uhrcel:set(value), uhrcel:set(0))
          likpol:set(value)
        elseif .not. Equal(::dm:get('banvyphdw->czkratmeny'),::dm:get('banvypitw->czkratmenf'))
          likpol:set(value)
        endif
      endif
    endif

  case(name = 'banvypitw->nuhrcelfak' .and. changed)
    if ::istuz()
      ::dm:set('banvypitw->nlikpolbav', value)
    endif
  endcase

  if name $ 'banvyphdw->cbank_uct,banvyphdw->ddatporiz' .and. ok .and. changed
    FIN_banvyp_kurz()
    ::dm:set('banvyphdw->nkurzahmen',banvyphdw->nkurzahmen)
    ::dm:set('banvyphdw->nmnozprep' ,banvyphdw->nmnozprep )
  endif

  if(name = ::it_file +'->cnazpol6')
     if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
       ::postLastField()
     endif
   endif

  if('banvyphdw' $ name .and. ok, drgVAR:save(),nil)
  if changed .and. ok
    ::dm:refresh()
  endif
RETURN ok


method fin_ban_vzz_pok_in:overPostLastField()
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1' )
  local  ucet      := ::dm:get(::it_file +'->cucet_uct'), o_ucet
  local  ok

  if empty(ucet)
    o_ucet := ::dm:has(::it_file +'->cucet_uct')
    o_ucet:odrg:setFocus()
    ::msg:writeMessage('Úèet(SuAu) na položce je povinný údaj ...',DRG_MSG_ERROR)
    _clearEventLoop(.t.)
    return .f.
  endif

  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok


method FIN_ban_vzz_pok_IN:postLastField(drgVar)
  local  isChanged := ::dm:changed(), file_iv := alltrim(::dm:has(::it_file +'->cfile_iv'):value)
  local  panGroup, pa, x, ait, name, file
  *
  local  pos     := (::it_file)->(fieldpos('ncenzak_or')), cenzak_or
  local  zkrMeny := if(lower(::hd_file) = 'banvyphdw', (::hd_file)->czkratMeny, (::hd_file)->czkratMenz)

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  cenzak_or := if( pos <> 0, (::it_file)->(fieldget(pos)), 0)
                       *
                       if(.not. empty(file_iv), ::copyfldto_w(file_iv,::it_file),nil)
                       ::copyfldto_w(::hd_file,::it_file)

                       if(pos <> 0, (::it_file)->ncenzak_or := cenzak_or, nil)
                       (::it_file)->nkurzrozdf := 0
                       (::it_file)->nuhrcelfaz := 0
                       (::it_file)->nintcount  := ::ordItem()+1
    endif
    *
    panGroup := if(::typ_dokl = 'ban', '1', ;
                if(::typ_dokl = 'vzz', '2', if(::typ_dokl = 'uhr', '3', '0')))
    ::itSave(panGroup)

    * spoleèná metoda pro ukádání položky
    *
    ::postLastField_mh( file_iv )
    (::it_file)->nerr_imp := 0

    if ::state = 2
      ::brow:gobottom()
      ::brow:refreshAll()
    else
      ::brow:refreshCurrent()
    endif
  endif

  ::aval_krp := {}
  ::setfocus(::state)
  ::FIN_ban_vzz_pok:map(.t.)
return .t.

*
** spoleèná metoda pro ulkádání položky volaná z postLastField / import_bavy
method fin_ban_vzz_pok_IN:postLastField_mh( file_iv )
  local  pa
  *
  local  zkrMeny := if(lower(::hd_file) = 'banvyphdw', (::hd_file)->czkratMeny, (::hd_file)->czkratMenz)

  if .not. empty(file_iv)
    (::it_file)->cdenik_par := (file_iv)->cdenik
    (::it_file)->cfile_iv   := file_iv
    (::it_file)->ndoklad_iv := (file_iv)->(recno())
  endif

  * úhrada dobropisu banka / pokladna
  if ::it_file = 'banvypitw'
    if ((::it_file)->nuhrcelfak < 0 .and. (::it_file)->nlikpolbav < 0)
      (::it_file)->nlikpolbav := (::it_file)->nlikpolbav *(-1)
    endif
  else
    if ((::it_file)->nuhrcelfak < 0 .and. (::it_file)->nlikpolpok < 0)
      (::it_file)->nlikpolpok := (::it_file)->nlikpolpok *(-1)
    endif
  endif

  * krp
  pa := if( isArray(::aval_krp), ::aval_krp, {})
  pa := if( len(pa) = 0        , nil       , pa)

  if isarray(pa)
    for x := 1 to len(pa) step 1
      ait   := pa[x]
      file  := left  (ait[1], at('->',ait[1]) -1)
      name  := substr(ait[1], at('->',ait[1]) +2)

      if ::it_file = file
        pos := (file)->(fieldpos(name))

        * likvidace je vždy kladná
        if( name $ 'nlikpolbav,nlikpolpok', ait[4] := abs(ait[4]), nil)

        if(pos <> 0, (file)->(fieldput(pos,ait[4])), nil)
      endif
    next
  else
    * u tuzemské úhrady pokud neprojede pøes KR/KP je hodnota = 0
    if (::zaklMena = zkrMeny) .and. (::zaklMena = (::it_file)->czkratmenf)
      (::it_file)->nuhrCelFaz := (::it_file)->nuhrcelfak
    endif
  endif

  * nápoèet nprijem, nvydej, nprijemZ, nvzdejZ *
  (::it_file)->nprijem := (::it_file)->nprijemz := ;
  (::it_file)->nvydej  := (::it_file)->nvydejz  := 0
  *
  if (::it_file)->ntypobratu = 1  ;  (::it_file)->nprijem  := abs((::it_file)->ncenzakcel)
                                     (::it_file)->nprijemz := abs((::it_file)->ncenzahcel)
  else                            ;  (::it_file)->nvydej   := abs((::it_file)->ncenzakcel)
                                     (::it_file)->nvydejz  := abs((::it_file)->ncenzahcel)
  endif
return self


method fin_ban_vzz_pok_IN:import_bavy()
  local  odialog, nexit
  *
  local  drgVar    := ::dm:has('banvyphdw->cfile_imp' )
  local  o_varSym  := ::dm:has('banvypitw->cvarSym'   )
  local  cbank_uce
  *
  local  nintCount := 0
  *
  local  ain_file  := AClone(::ain_file), varSym, file_iv, cntDokl, ctag
  local  zkratMenZ, zkratMenY
  *
  local  chfilter   := "nrok_vyp = %% .and. cbank_uce = '%%' .and. nstav_imp = 0", cfilter

  ASys_Komunik( , self)

  cfilter := format( chFilter, { (::hd_file)->nrok, (::hd_file)->cbank_uce })
  banvyph_im ->( Ads_setAOF( cfilter), dbgoTop())

  odialog := drgDialog():new('FIN_banvyphd_IMP', ::drgDialog)
  odialog:create(,,.T.)
  nexit := oDialog:exitState

  *
  ** nìco si vybral tak to holt zkusíme naèíst
  if nexit != drgEVENT_QUIT
    ::state = 1

    banvyph_im->(dbRlock())
    ::nLockH_im           := banvyph_im->(recNo())
    banvyph_im->nstav_imp := 1

    ::copyfldto_w('banvyph_im', 'banvyphdw' )
    ::refresh(drgVar,.f.)

    banvypi_im->(dbgoTop())
    do while .not. banvypi_im->(eof())
      if ( banvyph_im->nrok_vyp  = banvypi_im->nrok_vyp  .and. ;
           banvyph_im->cbank_uce = banvypi_im->cbank_uce .and. ;
           banvyph_im->ncisPoVyp = banvypi_im->ncisPoVyp       )

        aadd( ::anLockI_im, banvypi_im->(recNo()) )

        (::it_file)->(dbAppend())

        varSym  := banvypi_im ->cvarSymBan
        file_iv := ''

        *
        ** pojedeme je na jednu stranu podle ntypObratu 1 - fakprihd, 2 - fakvyshd

        AEval(ain_file, {|x| ( cntDokl := 0   , ;
                               ctag    := x[7], ;
                               (x[1])->(AdsSetOrder(ctag)            , ;
                                        DbSetScope(SCOPE_BOTH,varSym), ;
                                        DbGoTop()                    , ;
                                        DbEval({|| cntDokl++})       , ;
                                        dbclearscope()               ) , ;
                               x[2] := cntDokl                           ) } )

        cntDokl := (ain_file[1,2] +ain_file[2,2])

        if cntDokl = 1
          file_iv := ain_file[if(ain_file[1,2] <> 0,1,2),1]
          ctag    := ain_file[if(ain_file[1,2] <> 0,1,2),7]
          (file_iv)->(dbseek(varSym,, AdsCtag( ctag ) ))
        endif

        ::copyfldto_w(::hd_file    , ::it_file )

        if .not. empty(file_iv)
          zkratMenZ := (file_iv) ->cZKRATMENZ
          zkratMenY := (file_iv) ->cZKRATMENY

          ::copyfldto_w(file_iv,::it_file)
          (::it_file)->czkratMenF := if( .not. empty(zkratMenZ), zkratMenZ, zkratMenY )
          (::it_file)->cdenik_par := (file_iv)->cdenik
          (::it_file)->cfile_iv   := file_iv
          (::it_file)->ndoklad_iv := (file_iv)->(recno())
        else
          (::it_file)->cucet_uct  := ''
          (::it_file)->nerr_imp   := 1
        endif

        ::copyfldto_w( 'banvypi_im', ::it_file )

        (::it_file)->czkratmenu := (::hd_file)->czkratmeny
        (::it_file)->cdenik     := (::hd_file)->cdenik
        (::it_file)->nintcount  := nintCount

        * spoleèná metoda pro ukládání položky
        *
        ::postLastField_mh( file_iv )

        nintCount++

        ::brow:cursorMode := XBPBRW_CURSOR_NONE
        ::brow:gobottom()
        ::brow:refreshAll()

        ::refresh(o_varSym, .f.)

      endif
      banvypi_im->(dbskip())

    enddo

    ::FIN_ban_vzz_pok:map(.t.)

    ::brow:cursorMode := XBPBRW_CURSOR_ROW
    ::brow:goTop():refreshAll()
    ::refresh(o_varSym, .f.)
    ::setfocus()
  endif

  banvyph_im ->( Ads_clearAOF())
return self


method FIN_ban_vzz_pok_IN:import_bavy_mh( neco )
  local  cIdDatKom := upper( (::hd_file) ->cIdDatKomI )
  *
  local  sName     := drgINI:dir_USERfitm, lenBuff, buffer, afiles := {}
  local  xkey      := strZero((::hd_file)->nrok,4) +upper( (::hd_file)->cbank_uce)

  if ::is_ban

   *  1. - zkusíme najít nastavení pro import
   if datkomhd->(dbseek( cIdDatKom,, 'DATKOMH01'))

     sName   := drgINI:dir_USERfitm +cIdDatKom
     lenBuff := 1024
     buffer  := space(lenBuff)

     memoWrit(sName, datkomhd->mDefin_kom)

     GetPrivateProfileStringA('Import', 'pathImport', '', @buffer, lenBuff, sName)
     ::cpath_imp := substr(buffer,1,len(trim(buffer))-1)

     GetPrivateProfileStringA('Import', 'fileImport', '', @buffer, lenBuff, sName)
     ::cfile_imp := substr(buffer,1,len(trim(buffer))-1)

     afiles := Directory( ::cpath_imp + ::cfile_imp )
   endif

   if ( len( afiles ) <> 0 .or. banvyph_im->( dbseek( xkey,,'BANIMPH_1')))
     (::drgVar_file_imp:odrg:isEdit := .T., ::drgVar_file_imp:odrg:oxbp:enable())
   else
     (::drgVar_file_imp:odrg:isEdit := .F., ::drgVar_file_imp:odrg:oxbp:disable())
   endif

  endif
return self



METHOD FIN_ban_vzz_pok_IN:postAppend()
  (::varSym:odrg:isEdit := .T., ::varSym:odrg:oxbp:enable())
  (::cisFak:odrg:isEdit := .T., ::cisFak:odrg:oxbp:enable())

  if ::it_file = 'banvypitw'
    ::dm:set((::it_file) +'->ddatUhrady', (::hd_file)->ddatPoriz)
*-    ::dm:set((::it_file) +'->ctext'     , (::it_file)->ctext    )
  endif
RETURN .T.


method FIN_ban_vzz_pok_IN:postSave()
  local  ok := .t.
  local  pa := ::anLockI_im

  if .not. (::typ_dokl $ 'pok')
    if .not. empty( (::hd_file)->cfile_imp)

      if ::lNEWrec
        if banvypi_im->(sx_rlock( pa )) .and. banvyph_im ->(dbRlock())
          ::nLockH_im := 0
          banvyph_im ->( dbDelete())
          aeval( pa, { |x| banvypi_im->( dbGoTo(x), dbDelete()) })
        endif
        banvyph_im->( dbUnlock(), dbCommit())
        banvypi_im->( dbUnlock(), dbCommit())
      endif

      if (::it_file)->( ads_locate( "nerr_imp <> 0" ))
        (::hd_file)->nerr_imp := (::it_file)->nerr_imp
      endif
    endif

    ok := FIN_banvyp_wrt(self)
  endIf

//  ok := if( .not. (::typ_dokl $ 'pok'), FIN_banvyp_wrt(self), .t.)

  * zatím pak šmykca
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

/*
  do case
  case( ::typ_dokl $ 'ban,vzz')
    ok := fin_banvyp_wrt(self)

    if(ok .and. ::new_dok)
      banvyphdw->(dbclosearea())
      banvypitw->(dbclosearea())
      if(select('banpok_w') = 0,nil,banpok_w->(dbclosearea()))

      fin_banvyp_cpy(self)

      ::fin_ban_vzz_pok:map()
      ::fin_finance_in:refresh('banvyphdw',,::dm:vars)
      ::dm:refresh()
      *
      ::df:setNextFocus(::hd_file +if(::typ_dokl $ 'ncispovyp','nico'),,.t.)
      ::comboItemSelected()

    elseif(ok .and. .not. ::new_dok)
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    endif

  otherwise
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endcase
*/
return ok


METHOD FIN_ban_vzz_pok_IN:postDelete()
  ::FIN_ban_vzz_pok:map(.t.)
RETURN .T.



* poøízení K-urzovního R-odílu/ P-oplatku u položky nlikpolbav/nlikpolpok ******
METHOD FIN_ban_vzz_pok_IN:likpol_krp()
  LOCAL odialog, nexit
  *
  local ind_krp := 0
  local pa      := {}, values, size
  *
  local zkratmenf := ::dm:get(::it_file +'->czkratmenf')
  local   varsym  := ::dm:get(::it_file +'->cvarsym'   )


  if ::istuz
    if Equal(zkratmenf,::zaklMena)
    else
      ind_krp := 1
    endif
  else
    ind_krp := if(Empty(varsym), 2, 1)
  endif

  if ind_krp <> 0
    odialog := drgDialog():new(if(ind_krp = 1,'FIN_ban_vzz_pok_kr','FIN_ban_vzz_pok_p'),::drgDialog)
    odialog:create(,,.T.)
    nexit := odialog:exitState

    * uložíme si data
    values := odialog:dataManager:vars:values
      size := odialog:dataManager:vars:size()

    aeval(values,{|x| aadd(pa,{x[1],x[2]:initValue,x[2]:prevValue,x[2]:value,})},1,size)
    ::aval_krp := aclone(pa)

    *
    odialog:destroy(.T.)
    odialog := NIL
  endif
RETURN .T.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_ban_vzz_pok_IN:showGroup()
  local  x, lok, drgVar
  local  members := ::df:aMembers, panGroup
  *
  * editace/zobrazení pro typ úètu/ typ zápoètu - tuzemský/zahranièní
  *                     {'...itw->ncenzakcel', '...itw->nuhrcelfak', ;
  *                      '...itw->ncenzahcel', '...itw->nuhrcelfaz'  }
  for x := 1 TO len(::paGroups) step 1
    drgVar := ::dm:has(::paGroups[x]):oDrg
    lok := if( ::istuz, (x=1 .or. x=2), (x=3 .or. x=4))
    drgVar:isEdit := lOk
    if lOk  ;  (drgVar:oxbp:enable() ,drgVar:oXbp:show())
    else    ;  (drgVar:oxbp:disable(),drgVar:oXbp:hide())
    endif
  next

  if ::typ_dokl $ 'ban,vzz,uhr'
    panGroup := if(::typ_dokl = 'ban','1',if(::typ_dokl = 'vzz', '2', '3'))
    for x := 1 TO LEN(members) step 1
      if IsMemberVar(members[x],'groups') .and. .not. Empty(members[x]:groups)
        if .not. (panGroup $ members[x]:groups)
          members[x]:oXbp:hide()
          if( members[x]:IsDerivedFrom('drgObject'), members[x]:isEdit := .F., NIL)
        else
          members[x]:oXbp:show()
          if members[x]:IsDerivedFrom('drgObject')
            members[x]:isEdit := if(::lNEWrec, .T., members[x]:isedit_inrev)
          endif
        endif
      endif
    next
  endif
RETURN self


METHOD FIN_ban_vzz_pok_IN:postValidateForm()
  local x, members := ::df:aMembers
  *
  for x := 1 to Len(members) step 1
    if members[x]:IsDerivedFrom('drgObject') .and. members[x]:isEdit
      if !( members[x]:postValidate() )
        members[x]:setFocus()
        RETURN .F.
      endif
    endif
  next
RETURN .T.


method FIN_ban_vzz_pok_IN:open_in(file,alias)
  local file_name

  if select(alias) = 0
    file_name := (file) ->( DBInfo(DBO_FILENAME))
    DbUseArea(.t., oSession_data, file_name, alias, .t., .t.)
    (alias) ->(AdsSetOrder(1))
  endif
return alias