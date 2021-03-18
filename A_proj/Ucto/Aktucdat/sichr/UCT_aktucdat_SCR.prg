#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "adsdbe.ch"
#include "dmlb.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"
#include "..\UCTO\AKTUCDAT\UCT_aktucdat_.CH"


#define m_files  { 'ucetsys,3', 'c_naklst', 'c_uctosn', 'c_task,3'                        , ;
                   'ucetuzv'  , 'autom_hd', 'autom_it', 'uceterr' , 'uceterri'            , ;
                   'ucetpol'  , 'ucetpola', 'ucetpocs', 'ucetkum' , 'ucetkumk', 'ucetkumu', ;
                   'ucetsald' , 'ucetsalk'                                                , ;
                   'vyrzak,7' , 'kalkul,3'                                                  }



STATIC nOBD_ODn, nSKIP


function UCT_aktucdat_BC(nCOLUMn)
  local  nRETval := 0

  do case
  case nCOLUMn = 0  ;  nRETval := If( UCETSYS ->cOBDOBI = uctOBDOBI:UCT:COBDOBI, 300, 0 )
  case nCOLUMn = 1  ;  nRETval := If( UCETERR ->( mh_SEEK( UCETSYS ->cOBDOBI, 1, .T. )), 301, ;
                                  if( ucetuzv->lzavren, 607, If( UCETSYS ->lZAVREN, 302, 0 )) )

  case ncolumn = 2
    do case
    case(ucetsys->naktuc_ks = 1)  ;  nretVal := 316
    case(ucetsys->naktuc_ks = 2)  ;  nretVal := 300
    endcase
    if(UCETSYS ->nAKTUC_Ks == 2, nSKIP++, NIL )

  case ncolumn = 3
    nretVal := if(ucetsys->lcontr_off, MIS_ICON_ERR, 0)
  ENDCASE
RETURN(nRETVAL)


*
** CLASS for UCT_aktucdat_SCR **************************************************
CLASS UCT_aktucdat_SCR FROM drgUsrClass, UCT_aktucdat_BR
EXPORTED:
  var     oTREe, cobd_psn, c_treeItem, n_treeItems, n_treeItem
  method  init, treeViewInit, drgDialogStart, pushButtonClick, errsButtonClick
  method  comboBoxInit, comboItemSelected
  method  postValidate
  method  tabSelect
  *
  method  itemMarked_W

  *
  ** timeStamp
  inline access assign method tUzavreni() var tUzavreni
    local  cc := ucetuzv->tUzavreni
    return if( .not. empty(cc), cc, space(20))

  inline access assign method tZruseni() var tZruseni
    local  cc := ucetuzv->tZruseni
    return if( .not. empty(cc), cc, space(20))


  inline method pushOpenUzavRok()
    local l_uceUz
    *
    local  cInfo      := 'Promiòte prosím,' +CRLF + ;
                         'opravdu nelze zrušit roèní uzávìrku ...' +CRLF +CRLF

    if ucetuzv->lzavren
      *
      ** 1 - flock na ucetuzv
      l_uceUz := ucetuzv->(flock())

      if l_uceUz
        ucetuzv->lzavren  := .f.
        ucetuzv->ntypUZVR := 0
        ucetuzv->(ads_SetTimeStamp( 'tZruseni'  ))

      else
        cInfo += If( .not. l_uceUz, ;
                     '- nelze zamnkout základní tabulku ucetuzv       ...' +CRLF, '' )

        fin_info_box( cInfo, XBPMB_CRITICAL )
      endif

      ucetuzv->(dbunlock())
      ::dm:refresh()
    endif
  return .t.


  inline method  pushUctoUzavRok()
    local  nlastObdUz := sysConfig('ucto:nlastObdUz' )
    local  pa_aktUc   := {}, l_aktUc := .t.
    local  pa_autIt   := {}, l_autIt := .t.
    local  pa_sysUu   := {}, l_sysUu := .t.
    local  pa_sysUo   := {}
    local                    l_uceUz := .t.
    local  cf         := 'nRok = %% .and. nObdobi = %% .and. ntyp_aut = 1', filter
    *
    local  avykNv, nit,pa
    local  cInfo      := 'Promiòte prosím,' +CRLF + ;
                         'opravdu nelze zpracovat roèní uzávìrku ...' +CRLF +CRLF
    local  oxbp_therm := ::drgDialog:oMessageBar:msgStatus
    *
    **testy pro povolenení Roèní uzávìrky
    *
    * 1 - sysConfigg('ucto:nlastObdUz' ) - v rámci ::nrok uzavøená obdobi až do ...
    fordRec( {'ucetsys'} )
    ucetsys->( dbgotop(), ;
               dbeval( { || aadd( pa_aktUc, (ucetsys->naktuc_ks = 2)) }, ;
                       { || ucetsys->nobdobi <= nlastObdUz            }  ))
    aeval( pa_aktUc, { |x| if( x, nil, l_aktUc := .f. ) })
    fordRec()
    *
    * 2 - pro UCETUZV->nVytPSNV = 1 /zemìdìlci/
    **    projít autom_it pro podmnínku
    **    'nRok = %% .and. nObdobi = %% .and. ntyp_aut = 1' lukonceno == .t.
    if ucetuzv->nvytPSNV = 1
      filter := format( cf, { ::nrok, nlastObdUz })
      autom_it->( ads_setAof( filter), dbgoTop())

      do while .not. autom_it->(eof())
        avykNv := mh_Token(autom_it->cmrozp_co, ',')

        for nit := 1 to len(avykNv) step 1
          pa := if( at( '..', avyknv[nit]) > 0, mh_Token(avyknv[nit], '..')  ;
                    , {avykNv[nit],avykNv[nit]})

          if .not. (pa[1] >= '400' .and. pa[2] <= '699')
            aadd( pa_autIt, autom_it->lukonceno )
          endif
        next

        autom_it->(dbskip())
      enddo
      autom_it->(ads_clearAof())

      aeval( pa_autIt, { |x| if( x, nil, l_autIt := .f. ) })
    endif
    *
    ** 3 - zamknout ucetsys pro ::nrok a všechny úlohy
    cf     := 'nRok = %%'
    filter := format( cf, {::nrok})
    ucetsys_u->(ads_setAof(filter), ;
                dbgotop()         , ;
                dbeval( {|| ( aadd( pa_sysUu, ucetsys_u->(recNo()) ), ;
                              aadd( pa_sysUo, ucetsys_u->lzavren )    ) } ))
    l_sysUu := ucetsys_u->( sx_Rlock( pa_sysUu))
               ucetsys_u->( dbgotop())
    *
    ** 4 - flock na ucetuzv
    l_uceUz := ucetuzv->(flock())


    if l_aktUc .and. l_autIt .and. l_sysUu .and. l_uceUz

      ucetsys_u->(dbeval( {|| ucetsys_u->lzavren := .t. } ), ;
                  dbcommit()                                 )

      if uctoUzav_inTran( oxbp_therm, ::nrok )
        ucetuzv->lZavren    := (ucetuzv->ntypuzvr = 1)
        ucetuzv->cuserAbbUz := usrName
        ucetuzv->(ads_SetTimeStamp( 'tUzavreni' ))

      else
        aeval( pa_sysUu, { |x,m| ( ucetsys_u->(dbgoTo(x))           , ;
                                   ucetsys_u->lzavren := pa_sysUo[m]  ) } )
        ucetsys_u->( dbUnlock(), dbCommit())

        ucetuzv->lZavren := .f.
      endif

      ucetsys_u->(dbUnlock())
      ucetuzv->(dbunlock())

    else
      cInfo += If( .not. l_aktUc, ;
                   '- není provedena aktualizace za všechna období  ...' +CRLF, '' )
      cInfo += If( .not. l_autIt, ;
                   '- není uzavøena nedokonèená výroba              ...' +CRLF, '' )
      cInfo += If( .not. l_sysUu, ;
                   '- nelze zamnkout záznamy pro nastavení uzávìrky ...' +CRLF, '' )
      cInfo += If( .not. l_uceUz, ;
                   '- nelze zamnkout základní tabulku ucetuzv       ...' +CRLF, '' )

      fin_info_box( cInfo, XBPMB_CRITICAL )
    endif
  return .t.


  * bro col for ucetsys_W
  inline access assign method zavren_W() var zavren_W
    local  obd := upper(ucetsys_W->cobdobi)
    return if( uceterr->(dbSeek(obd,, AdsCtag(1) )), 301, if(ucetsys_W->lzavren, 302, 0))

  inline access assign method aktuc_ksW() var akuc_ksW
    local aktUc := ucetsys->naktuc_ks
    return if( aktUc = 1, 316, if( aktUc = 2, 300, 0))

  inline access assign method zavrel_kdoW() var zavrel_kdoW
    return dtoc(ucetsys_W->duzvDat) +'     ' +ucetsys_W->cuzvKdo

  inline access assign method nazUlohy_W() var nazUlohy_W
    c_task ->(dbSeek( upper(ucetsys_W->culoha),, AdsCtag(3) ))
    return c_task->cnazUlohy

  inline access assign method nazuct_MOK() var nazuct_MOK
    return rz_uctMOK->cnaz_Uct

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  nin

    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.

    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      if(::tabNum = 2, if( ucetuzv->lzavren, nil, ::setZavren_W()), nil)
      return .t.

    case(nevent = xbeBRW_ItemMarked)
      if ::isStart
        ::obro:gotop():forceStable()

        for nin := 1 to nSKIP ; ::obro:down() ; NEXT
        ::obro:forceStable()

        ::isStart := .f.
      endif
      if( ::obro:forceStable(), ::itemMarked(), nil)
    endcase
  return .f.


HIDDEN:
  VAR     nrok, members, isStart, obro, aobd, ok_groups, err_groups, tabNum
  VAR     msg, dm, dc, df

  method  itemMarked, postDelete, selObdobi
  method  setZavren_W

  inline method openfiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(file)                                                                        , ;
         if(isnull(ordno), nil, (file)->(AdsSetOrder(ordno)))                                        })
  return nil

  * filtr
  inline method setFilter()
    local  m_filter := "culoha = 'U' .and. nrok = %%", filter, x
    *
    local  obro_2 := ::drgDialog:dialogCtrl:oBrowse[2]:oXbp

    if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)

    filter := format(m_filter,{::nrok})
    ucetsys ->(ads_setaof(filter),dbgotop())

    do while .not. ucetsys->(eof())
      if( ucetsys->naktUc_Ks = 2, ::obro:down(), nil)
      ucetsys->(dbskip())
    enddo

    ucetsys->(dbgoTop())
    ::obro:forceStable()
    ::obro:refreshAll()

    obro_2:forceStable()
    obro_2:refreshAll()

    PostAppEvent(xbeBRW_ItemMarked,,,::obro)
    SetAppFocus(::obro)
    return self


  inline method aktucdatW_add(pA,ctre)
    local  cc

    aktucdatw->(dbAppend())

    aktucdatw->ctext   := ctre + .text
    aktucdatw->cgroup  := .group
    aktucdatw->lroot   := .root
    aktucdatw->lsets   := .sets
    aktucdatw->cmethod := .methods
    aktucdatw->nset_2  := 1

    if .methods = 'verify'
      if isMemberVar( self, .conds)
        cc := .conds

        aktucdatw->mconds := var2Bin(self:&cc)
      endif
    endif
  return nil


  inline method aktucdatW_set()
    local  x, cc := 'nobd_'

    aktucdatW->(dbGoTop())

    do while .not. aktucdatW->(eof())
      aktucdatW->nset_2 := 1
      aktucdatW->isLast := .f.

      for x := 1 to 12 step 1
        DBPutVal('aktucdatW->nob_' +strZero(x,2), 0)
      next

      aktucdatW->(dbSkip())
    enddo
  return nil

  * na záložce roèní uzávìrka test na založení ucetuzv
  inline method is_UcetOk(cucet)
    local ucet_Ok := ''

    if .not. empty(cucet)
      ucet_Ok := if( c_uctosn->(dbseek( upper(cucet))), upper(cucet), '' )
    endif
    return ucet_Ok


  inline method onTabSelect_uzvRok()
    local  cuzav_ROK
    local  cucet_OK, cucet_PS, cucet_UK, cucet_VU, cucet_NV
    *
    local  pa

    if .not. ucetuzv->( dbseek( ::nrok,,'UZAVER2'))
      ucetuzv->(dbAppend())
      ucetuzv->nrokUZV := ::nrok
      *
      ** levá strana karty
      if isCharacter( cuzav_ROK := sysConfig('ucto:cuzav_ROK'))
        pa := asize( listAsArray( strTran(cuzav_ROK,' ', '')), 5)
        aeval( pa, {|x,n| pa[n] := isNull(x,'0') })

        ucetuzv->nTypUZV  := val(pa[1])
        ucetuzv->nDoplnPS := val(pa[2])
        ucetuzv->nVytPSNV := val(pa[3])
        ucetuzv->nTypVNPU := val(pa[4])
        ucetuzv->nTypUZVR := val(pa[5])
      endif

      c_uctosn->(ordSetFocus('UCTOSN1'))
      *
      ** pravá starna karty úèty pro ...
      if isCharacter( cucet_OK  := sysConfig('ucto:cucet_OK' ))
        pa := asize( listAsArray( strTran(cucet_OK,' ', '')), 2)
        aeval( pa, {|x,n| pa[n] := isNull(x,'') })

        ucetuzv->cucet_MOK := ::is_UcetOk(pa[1])
        ucetuzv->cucet_DOK := ::is_UcetOk(pa[2])
      endif

      if isCharacter(cucet_PS  := sysConfig('ucto:cucet_PS' ))
        pa := asize( listAsArray( strTran(cucet_PS,' ', '')), 2)
        aeval( pa, {|x,n| pa[n] := isNull(x,'') })

        ucetuzv->cucet_MPS := ::is_UcetOk(pa[1])
        ucetuzv->cucet_DPS := ::is_UcetOk(pa[2])
      endif

      if isCharacter(cucet_UK  := sysConfig('ucto:cucet_UK' ))
        pa := asize( listAsArray( strTran(cucet_UK,' ', '')), 2)
        aeval( pa, {|x,n| pa[n] := isNull(x,'') })

        ucetuzv->cucet_MUK := ::is_UcetOk(pa[1])
        ucetuzv->cucet_DUK := ::is_UcetOk(pa[2])
      endif

      if isCharacter(cucet_VU  := sysConfig('ucto:cucet_VU' ))
        pa := asize( listAsArray( strTran(cucet_VU,' ', '')), 2)
        aeval( pa, {|x,n| pa[n] := isNull(x,'') })

        ucetuzv->cucet_MVU := ::is_UcetOk(pa[1])
        ucetuzv->cucet_DVU := ::is_UcetOk(pa[2])
      endif

      if isCharacter(cucet_NV  := sysConfig('ucto:cucet_NV' ))
        pa := asize( listAsArray( strTran(cucet_NV,' ', '')), 2)
        aeval( pa, {|x,n| pa[n] := isNull(x,'') })

        ucetuzv->cucet_MNV := ::is_UcetOk(pa[1])
        ucetuzv->cucet_DNV := ::is_UcetOk(pa[2])
      endif

      ucetuzv->(dbcommit())
    endif
  return nil
ENDCLASS


METHOD UCT_aktucdat_SCR:Init(parent)
  LOCAL filtr

  ::drgUsrClass:init(parent)

  nSKIP     := 0
  ::nrok    := uctOBDOBI:UCT:NROK
  ::isStart := .t.
  ::tabNum  := 1

  filtr := Format("cULOHA = '%%' .and. nROK = %%", {'U', ::NROK})

  ::openfiles(m_files)
  drgDBMS:open('ucetsys',,,,,'ucetsys_w')
  drgDBMS:open('ucetsys',,,,,'ucetsys_u')  // pro roèní uzávìrku

  * tmp
  drgDBMS:open('AKTUCDATw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('UCETERRw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('UC_ERRs'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('UCETPOLs' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  uceterrW->(dbAppend())

  ucetsys->(dbseek('U' +strZero(::nrok,4),.t.,'UCETSYS3'))
  ::cobd_psn := strZero(ucetsys->nrok,4) +strZero(ucetsys->nobdobi,2)

  UCETSYS ->( ads_setAof( filtr))
  If( UCETSYS ->( Ads_Locate("nAKTUc_Ks = 1")), nOBD_ODn := UCETSYS ->nOBDOBI, ;
                                                nOBD_ODn := 999                )

  ucetuzv->( dbseek( ::nrok,, 'UZAVER2'))
  UCETSYS ->( DbGoTop())
RETURN self


method UCT_aktucdat_SCR:drgDialogStart(drgDialog)
  local  x, pa_groups, nin
  *
  local  acolors  := MIS_COLORS

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::members := drgDialog:oForm:aMembers
  ::obro    := drgDialog:dialogCtrl:oBrowse[1]:oXbp
  drgDialog:oForm:nextFocus := 5
  *
  for x := 1 to len(::members) step 1
    if ::members[x]:ClassName() = 'drgStatic' .and. .not.Empty(::members[x]:groups)
      if     ::members[x]:groups = 'OK'
        ::ok_groups  := ::members[x]:oxbp
      elseif ::members[x]:groups = 'ERR'
        ::err_groups := ::members[x]:oxbp
      endif

    elseif ::members[x]:ClassName() = 'drgText' .and. .not.Empty(::members[x]:groups)
       pa_groups := ListAsArray(::members[x]:groups)
       nin       := ascan(pa_groups,'SETFONT')

       ::members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

       if 'GRA_CLR' $ atail(pa_groups)
         if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
           ::members[x]:oXbp:setColorFG(acolors[nin,2])
         endif
       else
         ::members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
       endif
    endif
  next

  uceterr->(dbGoTop())
  if( uceterr->(eof()), ::err_groups:hide(), ::ok_groups:hide())

  ::UCT_aktucdat_BR:init()
  ::treeViewInit()
  *
  ::setFilter()
return self


method UCT_aktucdat_SCR:comboBoxInit(drgComboBox)
  local  acombo_val := {}

  do case
  case ('NROK'   $ drgComboBox:name)
    drgComboBox:value := ::nrok
    ucetsys_w ->(dbgotop()       , ;
                 dbeval( { ||      ;
                 if( ascan(acombo_val,{|X| x[1] == ucetsys_w->nrok}) = 0 , ;
                     aadd(acombo_val,{ucetsys_w->nrok,'ROK _ ' +strzero(ucetsys_w->nrok,4)}), nil ) }))
    if empty(acombo_val)
      aadd(acombo_val, {::nrok-1, 'ROK _ ' +strzero(::nrok-1,4)})
      aadd(acombo_val, {::nrok  , 'ROK _ ' +strzero(::nrok  ,4)})
    endif

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endcase
return self


method UCT_aktucdat_SCR:comboItemSelected(drgComboBox, mp2, o)
  local  obro

  do case
  case( 'NROK' $ drgComboBox:name )

    if ::nrok <> drgComboBox:value
      ::nrok := drgComboBox:value
      ::setFilter()
      *
      aktucdatw->(dbzap())
      ::UCT_aktucdat_BR:init()
      ::treeViewInit()
      *
      ** na záložce Uzávìrka roèní zmìnil rok
      if ::tabNum = 3
        ::onTabSelect_uzvRok()

        obro := ::drgDialog:dialogCtrl:oBrowse[1]:oXbp
        SetAppFocus(obro)

        ::dm:refresh()
      endif

      * zmìnil rok - musíme zmìnit i období pro poèáteèní stavy
      ucetsys->(dbseek('U' +strZero(::nrok,4),.t.,'UCETSYS3'))
      ::cobd_psn := strZero(ucetsys->nrok,4) +strZero(ucetsys->nobdobi,2)
    endif

  otherwise
    *
    ** pošleme ho na další prvek
    if drgComboBox:ovar:itemChanged()
      PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgComboBox:oxbp)
    endif
   endCase
return .t.


method UCT_aktucdat_SCR:tabSelect(oTabPage,tabnum)
  local  obro := ::drgDialog:dialogCtrl:oBrowse[tabNum]:oXbp

  ::tabnum := tabnum

  do case
  case tabNum = 1
    obro:refreshAll()

  case tabNum = 2
    obro:goTop():refreshAll()

  case tabNum = 3
    ::onTabSelect_uzvRok()
    SetAppFocus(obro)

    ::dm:refresh()
  endCase

  if tabNum = 1 .or. tabNum = 2
    PostAppEvent(xbeBRW_ItemMarked,,,obro)
    SetAppFocus(obro)
  endif
return .t.


method UCT_aktucdat_SCR:postValidate(drgVar)
  local  value   := drgVar:get()
  local  name    := lower(drgVar:name)
  local  cfile   := drgParse(name,'-')
  local  changed := drgVAR:itemChanged()

  do case
  case( cfile = 'ucetuzv' )
    if changed .and. ucetuzv->(dbrlock())
      eval(drgVar:block,drgVar:value)
      drgVar:initValue := drgVar:value
    endif
    ucetuzv->(dbunlock())
  endcase
return .t.


method UCT_aktucdat_SCR:treeViewInit(drgObj)
  local  p_m, ps_1, ps_2, ps_3
  local  n_m, ns_1, ns_2, ns_3
  local  oROTitm

  if isObject(drgObj)
    ::oTree := drgObj:oxbp

  else
    p_m := ::UCT_aktucdat_br:TREEs

    for n_m := 1 to len(p_m) step 1

      if isArray(ps_1 := p_m[n_m,6])
        for ns_1 := 1 to len(ps_1) step 1
          ::aktucdatw_add(ps_1[ns_1], '|____')

          if isArray(ps_2 := ps_1[ns_1,6])
            for ns_2 := 1 to len(ps_2) step 1
              ::aktucdatw_add(ps_2[ns_2],'.  |___')


              if isArray(ps_3 := ps_2[ns_2,6])
                for ns_3 := 1 to len(ps_3) step 1
                 ::aktucdatw_add(ps_3[ns_3], '.     |___')

                next
              endif
            next
          endif
        next
      endif
    next
  endif
return self


method UCT_aktucdat_scr:pushButtonClick()
  local  nI, filter, treeItems := 0
  local  odialog, nexit
  *
  local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)

  nI := if( oxbp:cargo:icon1 = 119, 1, if( oxbp:cargo:icon1 = 118, 2, 3))

  if len(::cargo:aOBD_akt) = 0
    ConfirmBox( ,'Období ' +ucetsys->cobdobi +' je již aktualizované nelze zpracovat ...', ;
                 'Nelze aktualizovat již aktualizované období ...' , ;
                 XBPMB_CANCEL                                      , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  else
    ::aktucdatW_set()
    ::c_treeItem := oxbp:cargo:caption
    ::n_treeItem := nI

    if nI >= 2
      pS := ::CARGO:aOBD_AKT

      ::c_treeItem += ' za období  [' +substr(pS[1],5,2) +'/' +subStr(pS[1],1,4)
      if(nS := len(pS)) > 1
        ::c_treeItem += ' .. ' +substr(pS[nS],5,2) +'/' +subStr(pS[nS],1,4)
      endif
      ::c_treeItem += ']'
    endif

    filter := format("subStr(cgroup,1,1) = '%%'",{str(nI,1)})
    aktucdatw->(ads_setAof(filter), dbEval({|| treeItems++}) )

    aktucdatw->(dbgoBottom())
    aktucdatw->isLast := .t.
    aktucdatw->(dbGoTop())

    ::n_treeItems := treeItems
    DRGDIALOG FORM 'UCT_aktucdat_kon_akt' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

    ::obro:refreshAll()
    uceterr->(dbGoTop())
    if( uceterr->(eof()), nil, (::err_groups:show(), ::ok_groups:hide()))

  endif
return .t.


method UCT_aktucdat_scr:errsButtonClick()
  local  odialog, nexit
  local  nI, xbp_therm := ::drgDialog:oMessageBar:msgStatus
  local  recCnt := 0, keyCnt, keyNo := 1
  *
  local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)

  nI := if( oxbp:cargo:icon1 = 119, 1, 2)

  do case
  case(nI = 1)                                   //_ zobrazení chyb
    DRGDIALOG FORM 'UCT_uceterr_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  case(nI = 2)                                   //_ zrušení chyb
    if uceterr->(flock()) .and. uceterri->(flock())
      uceterr ->(dbGoTop(), dbEval({|| recCnt++ }))
      uceterri->(dbGoTop(), dbEval({|| recCnt++ }))

      recCnt += aktucdatW->(lastRec())
      keyCnt := recCnt / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)

      uceterr ->(dbGoTop())
      do while .not. uceterr->(eof())
        aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt,.t.)
        uceterr->(dbDelete())

        keyNo++
        uceterr->(dbSkip())
      enddo

      uceterri->(dbGoTop())
      do while .not. uceterri->(eof())
        aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt,.t.)
        uceterri->(dbDelete())

        keyNo++
        uceterri->(dbSkip())
      enddo

      aktucdatW->(dbGoTop())
      do while .not. aktucdatW->(eof())
        aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt,.t.)
        for nIn := 1 to 12 step 1
          DBPutVal('aktucdatw->nob_' +strZero(nIn,2), 0)
        next
        aktucdatW->(dbSkip())
      enddo

      ::obro:refreshAll()
      ::ok_groups:show()
      ::err_groups:hide()
    endif

    xbp_therm:configure()
    uceterr->(dbUnlock())
    uceterri->(dbUnlock())
  endcase
return .t.


method uct_aktucdat_scr:itemMarked()
  local nrecNo := ucetsys->(recNo()), cc, ok := .t.
  local cky    := substr(ucetsys->(sx_keyData()),2,6)

  ::cargo:aobd_akt := {}

  //---------- POLE OBDOBÍ pro AKTUALIZACI -------------------------------------
  ucetsys->(dbgotop())
  do while ok
    cc := substr(ucetsys->(sx_keyData()),2,6)
    if ucetsys->naktuc_ks <> 2
      if cc >= ::cargo:cobd_odn .and. cc <= ::cargo:cobd_don
        aadd(::cargo:aobd_akt,cc)
      endif
    endif
    ucetsys->(dbskip())
    ok := if( ucetsys->(eof()) .or. cc >= cky   , .f., .t.)
  enddo
  ucetsys->(dbgoto(nrecNo))
return


method uct_aktucdat_scr:postDelete()
  local  bc_2 := uct_aktucdat_bc(1)   // 301-err  302-uzavøeno
  local  bc_3 := uct_aktucdat_bc(2)   // 300-aktuc_ks -> 2
  local  nsel, ctx, sta := 0, osel, pa
  *
  local  nrecNo := ucetsys->(recNo())

  do case
  case(bc_2 = 301)  ;  (ctx := ' _CHYBY_ '      , sta := 0)
  case(bc_2 = 302)  ;  (ctx := ' _UZÁVÌRKU_ '   , sta := 2)
  case(bc_3 = 300)  ;  (ctx := ' _AKTUALIZACI_ ', sta := 3)
  endcase

  if sta <> 0
    osel := padc(::selObdobi(sta),80)
    nsel := ConfirmBox( ,'Požadujete zrušit' +ctx +'úèetních knih za období' +CRLF +osel, ;
                         'Zmìna aktualizace úèetních knih ...'                          , ;
                          XBPMB_YESNO                                                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE                  , ;
                          XBPMB_DEFBUTTON2                                                )

    if nsel = XBPMB_RET_YES
      if ucetsys->(sx_rlock(::aobd))
        aeval( ::aobd, { |X| ;
             ( ucetsys->(dbgoto(X)), ucetsys->nAKTUc_Ks := 1, ucetsys->lZAVREN := .f. )})
        ucetsys->(dbgoto(nrecNo), dbunlock(), dbcommit())
        ::obro:refreshAll()
        ::itemMarked()
      endif
    endif
  endif
return .t.


method uct_aktucdat_scr:selObdobi(sta)
  local nrecNo := ucetsys->(recNo()), selObdobi := ''

  ::aobd := {}

  do while .not. ucetsys->(eof())
    do case
    case(sta = 3 .and. ucetsys->naktuc_ks = 2)
      selObdobi += ucetsys->cobdobi +','
      aadd(::aobd,ucetsys->(recno()))
    endcase

    ucetsys->(dbskip())
  enddo
  selObdobi := substr(selObdobi,1,len(selObdobi)-1)

  ucetsys->(dbgoto(nrecNo))
return selObdobi


*
** metody pro záložku 2 - uzávìrka
method uct_aktucdat_scr:itemMarked_W()
  local  obro   := ::drgDialog:dialogCtrl:oBrowse[3]:oXbp
  local  m_filter := "cobdobi = '%%' .and. culoha <> 'U'", filter

  if ::tabNum = 2

    filter := format(m_filter,{ucetsys->cobdobi})
    ucetsys_W->(ads_setAof(filter), dbGoTop())

    obro:refreshAll()
  endif
return self

method uct_aktucdat_scr:setZavren_W()
  local  obro  := ::drgDialog:dialogCtrl:oaBrowse
  local  cfile := lower(obro:cfile)
  *
  local  ok, recNo := ucetsys_W->(recNo()), anTsk := {}, nlevl

  if ucetsys->naktuc_ks = 2
    do case
    case( cfile = 'ucetsys'  )
      ucetsys_W->( dbEval( {|| AAdd(anTsk, ucetsys_W->(recNo())) } ))
      ok    := ucetsys->(sx_rLock()) .and. ucetsys_W->(sx_rLock(anTsk))
      nlevl := 1
    case( cfile = 'ucetsys_w')
      ok    := (cfile)->(sx_rLock())
      nlevl := 2
    endcase

    if ok
      do case
      case( nlevl = 1 )
        ucetsys->lzavren := .not. ucetsys->lzavren

        if ucetsys->lzavren
          ucetsys_W->(dbEval( {|| ucetsys_W->lzavren := ucetsys->lzavren } ))
        endif

        ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshCurrent()

        ucetsys_W->(dbgoTop())
        ::drgDialog:dialogCtrl:oBrowse[3]:oXbp:refreshAll()
      case( nlevl = 2 )

        if .not. ucetsys->lzavren
          ucetsys_W->lzavren := .not. ucetsys_W->lzavren
          ::drgDialog:dialogCtrl:oBrowse[3]:oXbp:refreshCurrent()
        endif
      endcase
    endif

    ucetsys->(dbCommit(), dbUnlock())
    ucetsys_W->(dbCommit(), dbUnlock())
  endif
return self


*
** poèet záznamú pro scope
function uct_setScope(cfile,xtag,xscope)
  local  m_file := alias()

  (cfile)->(AdsSetOrder(xtag)                 , ;
            ads_setScope(SCOPE_TOP   , xscope), ;
            ads_setScope(SCOPE_BOTTOM, xscope), ;
            dbgotop()                           )

  ncnt := (cfile)->(ads_getKeyCount(ADS_RESPECTSCOPES))
return ncnt


function uct_clearScope(cfile)
  (cfile)->( ads_clearScope(SCOPE_TOP), ads_clearScope(SCOPE_BOTTOM), dbGoTop())
return nil

*
** PROGRESS BAR zpracování *****************************************************
function aktucdat_pb(oXbp,nKeyCNT,nKeyNO, nRecCNT, lIsRED)
  LOCAL  oPS
  LOCAL  aAttr[GRA_AA_COUNT], aPos := {2,0}, newPos
  local  nclrs := GraMakeRGBColor({1, 211, 228})
  *
  LOCAL  nCharINF, prc, nSize := oxbp:currentSize()[1], nHight := oxbp:currentSize()[2] -2

  IF !EMPTY(oPS := oXbp:lockPS())
    aAttr [ GRA_AA_COLOR ] := If( IsNULL(lIsRED),nclrs, GRA_CLR_RED )
    GraSetAttrArea( oPS, aAttr )

    ncharInf := int(nkeyNo/ nkeyCnt)
    newPos   := apos[1] +drgINI:fontH -6 +((drgINI:fontH -6) * ncharInf)
    GraBox( oPS, {aPos[1],2}, {newPos, nHight}, GRA_OUTLINEFILL )

    aAttr [ GRA_AA_COLOR ] := GRA_CLR_BACKGROUND
    GraSetAttrArea( oPS, aAttr )
    GraBox( oPS, {newPos + .1,2}, {nSize,nHight}, GRA_FILL)

    val := int((newPos/nSize *100))
    prc := if( val > 100, '100', str(val)) +' %'
    GraStringAt( oPS, {(nSize/2) -20,6}, prc)

    oXbp:unlockPS(oPS)
  ENDIF
RETURN prc


function aktucdat_inf(oXbp,ctext)
  local  oPS, oFont, aAttr, nSize := oxbp:currentSize()[1]

  if .not. empty(oPS := oXbp:lockPS())
    oFont := XbpFont():new():create( "12.Arial CE" )
    aAttr := ARRAY( GRA_AS_COUNT )

    GraSetFont( oPS, oFont )

    aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
    GraSetAttrString( oPS, aAttr )

    GraStringAt( oPS, { 20, 4}, ctext)

    oXbp:unlockPS(oPS)
  endif
return .t.