#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
*********OBECNÁ FUNKCE PRO UCETNI OBDOBI****************************************
Function UCT_ucetsys_BC(nCOLUMn)
  Local  cRETval := ''

  DO CASE
  CASE nCOLUMn == 0 ;  RETURN(If(UCETSYS ->lAKTOBD, 172, 173))
  CASE nCOLUMn == 1 ;  return(if(ucetsys ->lzavren, 302,   0))
  CASE nCOLUMn == 2 ;  cRETval := STR (UCETSYS ->NROK,4)  +'/'     +STR(UCETSYS ->NOBDOBI,2)
  CASE nCOLUMn == 3 ;  cRETval := DTOC(UCETSYS ->DOTVDAT) +'     ' +    UCETSYS ->COTVKDO
  CASE nCOLUMn == 4 ;  cRETval := DTOC(UCETSYS ->DUCTDAT) +'     ' +    UCETSYS ->CUCTKDO
  CASE nCOLUMn == 5 ;  cRETval := DTOC(UCETSYS ->DAKTDAT) +'     ' +    UCETSYS ->CAKTKDO
  CASE nCOLUMn == 6 ;  cRETval := DTOC(UCETSYS ->DUZVDAT) +'     ' +    UCETSYS ->CUZVKDO
  EndCase
RETURN(cRETval)


*
*************** UCT_ucetsys ****************************************************
CLASS UCT_ucetsys FROM drgUsrClass
exported:
  var     task, o_obdobi, o_rok, e_lobdUser
  method  init, drgDialogStart, drgDialogEnd
  method  comboBoxInit, comboItemSelected, postLastField, switch
  *
  method  checkItemSelected

  inline access assign method sysObdobi()  var sysObdobi
    return ( if( ucetsys ->laktObd, 427, 0))

  inline access assign method usrObdobi()  var usrObdobi
    local cky := upper(ucetsys->culoha)    + ;
                 strZero( ucetsys->nrok,4) + ;
                 strZero(ucetsys->nobdobi,2)
    local pa := ::a_mobdUser, npos

    if ( npos := ascan( pa, { |it| upper(it[2]) = cky } )) <> 0
// JS      if( ucetsys ->laktObd, npos := 0, nil )
    endif
    return if( npos <> 0, 427, 0 )

  inline access assign method zavren()     var zavren
    return ( if( ucetsys ->lzavren, 302, 0 ))

  inline access assign method aktuc_Ks()    var aktuc_Ks
    local  cky       := 'U' +strZero( ucetSys->nrok,4) +strZero( ucetSys->nobdobi,2)
    local  naktUc_Ks, retVal := 0

    ucetSys_U->( dbseek( cky,,'UCETSYS3'))
    naktUc_Ks := ucetSys_U->naktUc_Ks

    retVal    := if( naktUc_Ks = 0, 0, if( naktUc_Ks = 1, 316, 300 ))
    return retVal

  inline access assign method rokObdobi()  var rokObdobi
    return str( ucetsys->nrok,4) +'/' +str( ucetsys->nobdobi,2)

  inline access assign method otevrelKdo() var otevrelKdo
    return dtoc( ucetsys->dotvDat) +'     ' +    ucetsys->cotvKdo

  inline access assign method uctovalKdo() var uctovalKdo
    return dtoc( ucetsys->ductDat) +'     ' +    ucetsys->cuctKdo

  inline access assign method uzavrelKdo() var uzavrelKdo
    return dtoc( ucetsys->duzvDat) +'     ' +    ucetsys->cuzvKdo

  ** pro e_usrObdobi
  inline access assign method e_usrObdobi()  var e_usrObdobi
    local cky := upper(ucetsys->culoha)    + ;
                 strZero( ucetsys->nrok,4) + ;
                 strZero(ucetsys->nobdobi,2)
    local pa := ::a_mobdUser, npos

    if ( npos := ascan( pa, { |it| upper(it[2]) = cky } )) <> 0
// JS      if( ucetsys ->laktObd, npos := 0, nil )
    endif
    return ( npos <> 0 )

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local task := ::task, cc, isAppend := .f., block, lOK := .T.
    local obro := ::oabro[1]:oxbp
    *
    local cky

    do case
    case (nEvent = xbeBRW_ItemMarked)
      if ::isStart
        obro:forceStable()
        obro:refreshAll()
        obro:ItemLbDown( ::rowPos, 1 ):refreshCurrent()
        ::isStart := .f.
        return .t.
      endif

      ::o_obdobi:odrg:oxbp:disable()
      ::o_rok:odrg:oxbp:disable()

      if( ::sysObdobi = 427, ::o_sysObdobi:odrg:oxbp:disable(), ;
                             ::o_sysObdobi:odrg:oxbp:enable()   )

      ::msg:WriteMessage(,0)
      return .f.

    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      ::setAktObd()
      return .t.

    case (nEvent = drgEVENT_APPEND)
      ::old_nrok := ::o_rok:value

      ::postAppend()

      c_task->(dbseek(upper(::task),,'C_TASK01'))
      cc := str(::o_obdobi:value,2) +'/' +str(::o_rok:value,4)

      * možnost zadání období za splnìní prevalidaèní podmínky
      if( isMethod(::udcp,'preAppendObdobi'))
        lOK := ::udcp:postAppendObdobi()
      elseif( isFunction( task + '_preAppendObdobi' ))
        block := &('{|a, b, c| ' + task + '_preAppendObdobi(a, b, c) }')
        lOK := EVAL( block, ::drgDialog)
      endif
      if !lOK
         return .t.
      endif
      *
      if .not. ::can_Append_or_Delete_Obdobi(1)
        return .t.
      endif

      if drgIsYESNO('Založit nové úèetní období ...' +chr(13) +chr(10)+'>' +cc +'< pro úlohu >' +alltrim(c_task->cnazulohy) +'< ?')
        ::postSave()
        *
        ::rowPos := ucetSys->( Ads_GetKeyCount(1))
        obro:forceStable()
        obro:ItemLbDown( ::rowPos, 1 ):refreshCurrent()
        ::dm:refresh()
        *
        if( isMethod(::udcp,'postAppendObdobi'))
           ::udcp:postAppendObdobi()
        elseif( isFunction( task + '_postAppendObdobi' ))
          block := &('{|a, b, c| ' + task + '_postAppendObdobi(a, b, c) }')
          EVAL( block, ::drgDialog)
        endif
        *
        uctOBDOBI_LAST:&task:get()
        ::newObd_forUCTO()
        *
      endif

      if( ucetErr ->( DbLocked()), ucetErr ->( DbUnlock()), nil )
      if( ucetErri->( DbLocked()), ucetErri->( DbUnlock()), nil )

      ::oabro[1]:oxbp:refreshAll()
      ::dm:refresh()
      PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
      SetAppFocus(::oabro[1]:oXbp)

      _clearEventLoop(.t.)
      return .t.

     case (nEvent = drgEVENT_DELETE .or. nEvent = drgEVENT_EDIT)

       * pouze v úloze MZDY zkusíme rušit - ale musí být splnìno hodnì podmínek
       if nEvent = drgEVENT_DELETE
          cky  := 'U' +strZero( ucetSys->nrok,4) +strZero( ucetSys->nobdobi,2)
          ucetSys_U->( dbseek( cky,,'UCETSYS3'))

          if ucetSys->culoha  = 'M' .and. ::can_Append_or_Delete_Obdobi(-1)

             if( isFunction( 'MZD_postDeleteObdobi' ))
               ucetSys->( dbUnlock(), dbCommit())

               block := &('{|a, b, c| ' + 'MZD_postDeleteObdobi(a, b, c) }')
               EVAL( block, ::drgDialog)

               ::oabro[1]:oxbp:refreshAll()

               * zrušil 1. období nového roku, vracíme se o ROK-1
               if isNull( ucetSys->sid, 0) = 0
                 ::nrok := ::nrok-1
                 ::comboBoxInit(::ocmb_m_nRok)

                 ::ocmb_m_nRok:value := 0
                 ::ocmb_m_nRok:refresh( ::nrok )

                 ::setFilter()
               else
                 ::dm:refresh()
                 PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
                 SetAppFocus(::oabro[1]:oXbp)
               endif
             endif

             if( ucetErr ->( DbLocked()), ucetErr ->( DbUnlock()), nil )
             if( ucetErri->( DbLocked()), ucetErri->( DbUnlock()), nil )

          endif
       endif

       if nEvent = drgEVENT_EDIT
         if ucetsys->nrok <> 0 .and. ucetsys->nobdobi <> 0
           uctOBDOBI:&task:get()
           PostAppEvent(xbeP_Close, nEvent,,oXbp)
         endif
       endif
       return .t.

     case (nEvent = drgEVENT_SAVE)
*       if IsObject(oXbp) .and. oXbp:className() = 'XbpGet'
*         oXbp:SetColorBG(oXbp:cargo:clrFocus)
*        endif
*
*        if(oxbp:classname() <> 'XbpBrowse')  ;  ::postSave()
*        else                                 ;  PostAppEvent(xbeP_Close, nEvent,,oXbp)
*        endif
        return .t.

     case (nEvent = xbeP_Keyboard)

       if AppKeyState(xbeK_ALT) = 1 .and. chr(mp1) = 'U' .and. ::usrObdobi = 0
         ::setUsrObd()
         PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
         return .t.
       endif

       if AppKeyState(xbeK_ALT) = 1 .and. chr(mp1) = 'S' .and. ::sysObdobi = 0
         ::setAktObd()
         PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
         return .t.
       endif

       if( mp1 = xbeK_CTRL_ENTER, ::setAktObd(), nil)

       if mp1 == xbeK_ESC .and. .not. ::inBrow()
         if IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
           oXbp:setColorBG( oXbp:cargo:clrFocus )
         endif

         SetAppFocus(::oabro[1]:oxbp)
         PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
         ::dm:refresh()
         return .t.
       else
         return .f.
       endif

    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, oabro, udcp
* datové
  var     culoha, nrok, nobdobi, old_nrok
  var     isStart, rowPos, nrok_inInit
  var     o_usrObdobi, o_sysObdobi, ocmb_m_nRok
  var     a_mobdUser
  var     c_laktObd              // laktObd = .t.

  method  setAktObd, setUsrObd, postAppend, postSave

   * filtr
  inline method setFilter()
    local m_filter := "culoha = '%%' .and. nrok = %%", filter, x
    local lok := .t.

    if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)

    filter := format(m_filter,{::culoha,::nrok})
    ucetsys ->(ads_setaof(filter),dbgotop())

    if ucetsys->( dbSeek( ::culoha +'1',, 'UCETSYS4'))
      ::c_laktObd := upper(ucetsys->culoha)    + ;
                     strZero( ucetsys->nrok,4) + ;
                     strZero(ucetsys->nobdobi,2)
    else
      ucetsys ->( dbgotop())

      ::c_laktObd := upper(ucetsys->culoha)    + ;
                     strZero( ucetsys->nrok,4) + ;
                     strZero(ucetsys->nobdobi,2)
    endif
    ucetsys ->( dbgotop())

    ::rowPos  := 1
    ::isStart := .t.
    do while .not. ucetsys->laktObd .and. .not. ucetSys->(eof())
      ::rowPos++
      ucetSys->(dbskip())
    enddo
    *
    ** nenašel pøednastavné co vèil
    if ucetSys->(eof())
      do case
      case ::nrok = ::nrok_inInit ; ::rowPos := 1
      case ::nrok > ::nrok_inInit ; ::rowPos := 1
      case ::nrok < ::nrok_inInit ; ::rowPos := ucetSys->( Ads_GetKeyCount(1))
      endcase
    endif

    ucetsys ->( dbgotop())

    ::oabro[1]:oxbp:forceStable()
    ::oabro[1]:oxbp:refreshAll()
    ::oabro[1]:oxbp:ItemLbDown( ::rowPos, 1 ):refreshCurrent()

    PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
    SetAppFocus(::oabro[1]:oXbp)
    ::dm:refresh()

    return self

  * je aktivni BROw ?
  inline method inBrow()
    return (SetAppFocus():className() = 'XbpBrowse')


  * lze založit/ zrušit  období ?  1 - append, -1 - delete
  inline method can_Append_or_Delete_Obdobi(nstate)
    local  cky_U := 'U' +strZero(::o_rok:value,4) +strZero(::o_obdobi:value,2)
    local  cky_M
    local  rok  := ucetSys->nrok, obdobi := ucetSys->nobdobi
    local  llastObd, lopenObd, lno_aktUcDat, lpredObd, lmzdZav
    *
    local  odialog, pa_cargo_usr := { nstate }
    *
    ** cfg parametr c pole oddìlené , 1. parametr 0/1 váže na mzdZavHD.nexiPriUhr
    local  ckontrMzd  := sysConfig( 'mzdy:ckontrMzd' )
    local  cexiPriUhr := '1'

    c_task->(dbseek(upper(::task),,'C_TASK01'))
    pa_cargo_usr := { nstate,  alltrim(c_task->cnazulohy) }

    ucetSys_U->( dbseek( cky_U,,'UCETSYS3'))

    llastObd     := ( ucetSys->nrok = uctOBDOBI_LAST:MZD:nrok .and. ucetSys->nobdobi = uctOBDOBI_LAST:MZD:nobdobi )
    lopenObd     := .not. ucetSys_U->lzavren
**    lopenObd     := if( ucetSys_U->lzavren .or. ucetSys_U->naktUc_ks = 2, .f., .t. )
    lno_aktUcDat := ( uceterr->(Flock()) .and. uceterri->(Flock()) )

    do case
    case nstate =  1
     if ucetSys->culoha  = 'M'

       do case
       case .not. drgINI:l_blockObdMzdy  // T - user mzdy, F - admin mzdy - mùže vše -
         lmzdZav := .t.
       otherwise
         cexiPriUhr := if( isCharacter(ckontrMzd), left(ckontrMzd,1), '1'  )

         cky_M      := strZero(uctOBDOBI_LAST:MZD:nrok,4) +strZero(uctOBDOBI_LAST:MZD:nobdobi,2) +if( cexiPriUhr = '0', '', cexiPriUhr )
         lmzdZav    := mzdZavHD->( dbseek( cky_M,,'MZDZAVHD13'))
       endcase

       lok      := lopenObd .and. lno_aktUcDat .and. lmzdZav
       aadd( pa_cargo_usr, { { 2, lopenObd }, { 3, lno_aktUcDat }, { 6, lmzdZav } } )
     else
       lok      := lopenObd .and. lno_aktUcDat
       aadd( pa_cargo_usr, { { 2, lopenObd }, { 3, lno_aktUcDat } } )
     endif

    case nstate = -1
      if ucetSys->culoha  = 'M'
        cky_M    := 'M' +strZero( if( obdobi = 1, rok -1, rok), 4) +strZero( if( obdobi = 1, 12, obdobi-1), 2)
        lpredObd := ucetSys_U->( dbseek( cky_M,,'UCETSYS3'))
        lmzdZav  := .not. mzdZavHD->( dbseek( strZero(rok,4) +strZero(obdobi,2) +'1',,'MZDZAVHD13'))

        lok      := llastObd .and. lopenObd .and. lno_aktUcDat .and. lpredObd .and. lmzdZav
        aadd( pa_cargo_usr, { { 1, llastObd}, { 2, lopenObd }, { 3, lno_aktUcDat }, { 4, lpredObd }, { 5, lmzdZav } } )
      endif
    endcase

    if .not. lok
      odialog           := drgDialog():new('UCT_ucetSys_info',::drgDialog)
      odialog:cargo_Usr := pa_cargo_Usr
      odialog:create(,,.T.)
    endif
  return lok


  * založíme období pro ÚÈTO pokud úloha která založila nové období úètuje + automaty
  inline method newObd_forUCTO()
    local  m_filter := "culoha = 'U' .and. nrok = %% .and. nobdobi <> %%", filter
    local  main_ky

    if c_task->luctuj
      ucetsys_U->(ads_clearaof(),ordSetFocus('UCETSYS1'))

      filter := format(m_filter,{::old_nrok, ucetsys->nobdobi})
      ucetsys_U ->(ads_setaof(filter),dbgoBottom())

      main_ky  := strZero(ucetsys_U->nrok,4) +strZero(ucetsys_U->nobdobi,2)

      drgDBMS:open('autom_hd')
      drgDBMS:open('autom_it')
      drgDBMS:open('autom_hdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
      drgDBMS:open('autom_itw',.T.,.T.,drgINI:dir_USERfitm); ZAP

      drgDBMS:open('autom_hd',,,,,'aut_hdw')
      aut_hdw->(ordSetFocus('AUTOHD01'))

      drgDBMS:open('autom_it',,,,,'aut_itw')
      aut_hdw->(ordSetFocus('AUTOIT01'))

      if .not. aut_hdw->(dbseek( strZero(ucetsys->nrok,4) +strZero(ucetsys->nobdobi,2)))

        aut_hdw ->( dbSetScope(SCOPE_BOTH, main_ky), ;
                    dbgoTop()                      , ;
                    dbEval({|| ( mh_copyFld('aut_hdw','autom_hdw',.t.) , ;
                                 autom_hdw->nrok    := ucetsys->nrok   , ;
                                 autom_hdw->nobdobi := ucetsys->nobdobi, ;
                                 autom_hdw->cobdobi := ucetsys->cobdobi  ) }) )
        autom_hdw ->( dbgoTop()                      , ;
                      dbEval({|| ( mh_copyFld('autom_hdw','autom_hd',.t.) ) }) )


        aut_itw ->( dbSetScope(SCOPE_BOTH, main_ky), ;
                    dbgoTop()                      , ;
                    dbEval({|| ( mh_copyFld('aut_itw','autom_itw',.t.) , ;
                                 autom_itw->nrok    := ucetsys->nrok   , ;
                                 autom_itw->nobdobi := ucetsys->nobdobi, ;
                                 autom_itw->cobdobi := ucetsys->cobdobi  ) }) )
        autom_itw ->( dbgoTop()                      , ;
                      dbEval({|| ( mh_copyFld('autom_itw','autom_it',.t.) ) }) )
      endif

      autom_hd->(dbUnlock(), dbCommit())
       autom_it->(dbUnlock(), dbCommit())
        aut_hdw->(dbCloseArea())
         aut_itw->(dbCloseArea())

      if( upper(::culoha) <> 'U', ::postSave('U'), nil )
    endif
  return

ENDCLASS


method UCT_ucetsys:init(parent)
  local  task := coalesceempty(drgParse(drgParseSecond(parent:initParam)),'uct')

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_task' )
  drgDBMS:open('ucetsys')
  drgDBMS:open('ucetsys',,,,,'ucetsys_w')
  drgDBMS:open('ucetsys',,,,,'ucetsys_U')
  *
  drgDBMS:open('ucetErr' )
  drgDBMS:open('ucetErri')
  *
  drgDBMS:open('mzdZavHD')

  ::task       := task
  ::nobdobi    := 0
  ::isStart    := .t.
  ::a_mobdUser := uctOBDOBI:a_mobdUser // { { 'FIN','F201005', 'UCT', 'U201006' } }
  ::e_lobdUser := .t.

  if isobject(uctOBDOBI:&task)
    ::culoha  := uctOBDOBI:&task:culoha
    ::nrok    := uctOBDOBI:&task:nrok
    ::nobdobi := uctOBDOBI:&task:nobdobi
  endif

  c_task->(dbseek(upper(task),,'C_TASK01'))
  if(empty(::culoha), ::culoha := c_task->culoha, nil)
  if(empty(::nrok)  , ::nrok   := Year(date())  , nil)

  ::nrok_inInit := ::nrok
return self


method UCT_ucetsys:drgDialogStart(drgDialog)
  local  x, arect, apos
  local  members := drgDialog:oForm:aMembers

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::oabro    := drgDialog:dialogCtrl:obrowse
  ::udcp     := drgDialog:parent:udcp

  ::o_obdobi    := ::dm:get('ucetsys->nobdobi', .f.)
  ::o_rok       := ::dm:get('ucetsys->nrok'   , .f.)

  ::o_usrObdobi := ::dm:get('m->e_usrObdobi'  , .f.)
  ::o_sysObdobi := ::dm:get('ucetsys->laktObd', .f.)

  ::ocmb_m_nRok := ::dm:has('m->nRok'):odrg

  ::setFilter()
return self


method UCT_ucetsys:drgDialogEnd(drgDialog)
  local  cky_M, task := ::task
  *
  ** jen pro mzdy, zrušil období, pøepnem ho zpìt, ale dá ESC, x, ALT_F4
  if ucetSys->culoha = 'M'
    cky_M := 'M' +strZero(uctOBDOBI:&task:nrok,4) +strZero(uctOBDOBI:&task:nobdobi,2)

    if .not. ucetSys_U->( dbseek( cky_M,,'UCETSYS3'))
      drgDialog:exitState := drgEVENT_EDIT
      uctOBDOBI:&task:get()
    endif
  endif

  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := ;
  ::udcp  := NIL

  ucetsys->(ads_clearaof())
return self


method UCT_ucetsys:comboBoxInit(drgComboBox)
  local  acombo_val := {}
  local  m_filter   := "culoha = '%%'", filter


  if ('CULOHA' $ drgComboBox:name) .or. ('NROK'   $ drgComboBox:name)
    do case
    case ('CULOHA' $ drgComboBox:name)
      drgComboBox:oxbp:disable()

      drgComboBox:value := ::culoha
      c_task->(dbgotop(), ;
               dbeval({|| aadd(acombo_val,{c_task->culoha,c_task->cnazulohy}) }, ;
                      {|| c_task->luctuj }))

    case ('NROK'   $ drgComboBox:name)
      drgComboBox:value := ::nrok

      filter := format( m_filter,{::culoha} )

      ucetsys_w ->(ads_setAof(filter)  , ;
                   dbgotop()           , ;
                   dbeval( { ||          ;
                   if( ascan(acombo_val,{|X| x[1] == ucetsys_w->nrok}) = 0 , ;
                       aadd(acombo_val,{ucetsys_w->nrok,'ROK _ ' +strzero(ucetsys_w->nrok,4)}), nil ) }))

      if empty(acombo_val)
        aadd(acombo_val, {::nrok-1, 'ROK _ ' +strzero(::nrok-1,4)})
        aadd(acombo_val, {::nrok  , 'ROK _ ' +strzero(::nrok  ,4)})
      endif

      ucetsys_w ->(ads_clearAof())
    endcase

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    if ('NROK' $ drgComboBox:name)
      drgComboBox:value := drgComboBox:ovar:value := ::nrok
    endif
  endif
return self


method UCT_ucetsys:comboItemSelected(mp1, mp2, o)

  if( 'CULOHA' $ mp1:name, ::culoha := mp1:value, ::nrok := mp1:value)
  ::setFilter()
return .t.


method UCT_ucetsys:switch()
  if ucetsys ->(dbrlock())
    ucetsys->lzavren := .not. ucetsys->lzavren

    ucetsys->(dbunlock())
    ::oabro[1]:oxbp:refreshCurrent()
  endif
return .t.


method uct_ucetsys:checkItemSelected(drgCheck)
  local  value := drgCheck:value

  do case
  case lower(drgCheck:name) = 'm->e_usrobdobi'
    ::setUsrObd( value )

  case lower(drgCheck:name) = 'ucetsys->laktObd'
// JS    ::setUsrObd( value )
    ::setAktObd()
  endcase

  PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
  SetAppFocus(::oabro[1]:oXbp)
return .t.


method UCT_ucetsys:postLastField()
  PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
return .t.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method uct_ucetsys:setUsrObd( value )
  local cky := upper(ucetsys->culoha)    + ;
               strZero( ucetsys->nrok,4) + ;
               strZero(ucetsys->nobdobi,2)
  local pa := ::a_mobdUser, npos

  npos := ascan( pa, { |it| upper(it[1]) = upper(::task) }  )

  if( ::usrObdobi = 427, cky := ::c_laktObd, nil )

  if value
    if npos = 0 ; aadd( pa, { ::task, cky } )
    else        ; pa[npos,2] := cky
    endif
  else
    if( npos <> 0, aRemove( pa, npos), nil )
  endif

  ::oabro[1]:oxbp:refreshAll()
return .t.

method UCT_ucetsys:setAktObd()
  local anuc := {}, recNo := ucetsys->(recno())
  local m_filter := "culoha = '%%'", filter

* - pomocný
  if ucetsys->(ads_getRecordCount()) > 1 .or. .not. ucetsys_w->laktobd
    filter := format(m_filter,{::culoha})
    ucetsys_w->(dbclearfilter(),dbsetfilter(COMPILE(filter)),dbgotop())

    anuc := {recNo}
    ucetsys_w->(dbeval({||if(ucetsys_w->laktobd, aadd(anuc,ucetsys_w->(recno())), nil) }))

    if ucetsys->(sx_RLock(anuc))
      aeval(anuc,{|X| (ucetsys->(dbgoto(x)), ucetsys->laktobd := (x == recNo)) })
    endif

    ucetsys ->(dbunlock(),dbgoto(recNo))

    ::c_laktObd := upper(ucetsys->culoha)    + ;
                   strZero( ucetsys->nrok,4) + ;
                   strZero(ucetsys->nobdobi,2)

    ::oabro[1]:oxbp:refreshAll()

    ucetsys_w->(dbclearfilter())
  endif
return .t.


method UCT_ucetsys:postAppend()
  local x, ovar, type, val, file, ok
  local m_filter := "culoha = '%%'", filter, odbobi, rok

* - pomocnný
  filter := format(m_filter,{::culoha})
  ucetsys_w->(dbclearfilter(),dbsetfilter(COMPILE(filter)),ordsetfocus('UCETSYS3'),dbgobottom())
  *
  obdobi := ucetsys_w->nobdobi
     rok := coalesceEmpty(ucetsys_w->nrok,::nrok)

  * new record
  for x := 1 to ::dm:vars:size() step 1
    ok   := .f.
    ovar := ::dm:vars:getNth(x)
    type := valtype(ovar:value)
    file := lower(drgParse(ovar:name,'-'))

    if .not. (lower(ovar:name) $ 'ucetsys->uct_ucetsys:culoha,m->nrok')

      do case
      case(type == 'N')  ;  val := 0
      case(type == 'C')  ;  val := ''
      case(type == 'D')  ;  val := ctod('  .  .  ')
      case(type == 'L')  ;  val := .f.
      endcase

      ovar:set(val)
      ovar:initValue := ovar:prevValue := ovar:value := val
    endif
  next

  * pøednaplníme
  ::dm:set('ucetsys->dotvdat',date())
  ::dm:set('ucetsys->cotvkdo',usrName)

  if obdobi = 12  ;  ::o_obdobi:set(1)
                     ::o_rok:set(rok+1)
  else            ;  ::o_obdobi:set(obdobi+1)
                     ::o_rok:set(rok)
  endif

  ucetsys_w->(dbclearfilter())
return .t.


method UCT_ucetsys:postSave(uloha)
  local  nobdobi := ::o_obdobi:value
  local  nrok    := ::o_rok:value, crok := right(str(nrok,4),2)
  local  culoha  := if( uloha = nil, ::culoha, uloha)
  *
  local  ntypvykDph := sysconfig('FINANCE:nTypVykDPH')
  local  cky        := upper(culoha) +strZero(nrok,4) +strZero(nobdobi,2)
  local  o_cmbnRok  := ::dm:has('m->nrok'):odrg
  local  obro       := ::oabro[1]:oxbp

  ucetsys_w->(dbclearfilter(),dbgotop())

  if .not. empty(nobdobi) .and. .not. empty(nrok)
    if .not. ucetsys_w->(dbSeek(cky,,'UCETSYS3'))
      ucetsys_w->(dbappend())
      ucetsys_w->culoha     := culoha
      ucetsys_w->nrok       := nrok
      ucetsys_w->nobdobi    := nobdobi
      ucetsys_w->nrokObd    := (nrok *100) + nobdobi
      ucetsys_w->cobdobi    := strzero(nobdobi,2) +'/' +crok
      ucetsys_w->cobdobidan := strzero(round(nobdobi/ntypvykDph +ntypvykDph/12,0),2) +'/' +crok
      ucetsys_w->cotvkdo    := usrName
      ucetsys_w->dotvdat    := date()
      ucetsys_w->cotvcas    := time()

      ucetsys_w->( dbUnlock(), dbcommit())

      if nrok <> ::nrok
        ::nrok := nrok
        if ascan( o_cmbnRok:values, {|x| x[1] = nrok }) = 0
          aadd( o_cmbnRok:values, { nrok, 'ROK _ ' +strzero(nrok,4)} )
                o_cmbnRok:oxbp:addItem(   'ROK _ ' +strzero(nrok,4)  )
        endif

        o_cmbnRok:ovar:set( nrok )
        o_cmbnRok:ovar:initValue := o_cmbnRok:ovar:prevValue := o_cmbnRok:ovar:value := nrok
        ::setFilter()
      endif
    endif
  endif
return .t.


*
** CLASS for uct_ucetSys_info
CLASS uct_ucetSys_info FROM drgUsrClass
EXPORTED:
  var  pa_info, headTitle, subTitle, taskName

  inline method init(parent)
    local  pa_cargo_Usr := parent:cargo_Usr
    local  pa_items     := pa_cargo_usr[3]
    local  x, nitem, lvalue
    *
    local  pa_all_info := { '. - lze zrušit pouze poslední otevøené období úlohy mzdy' , ;
                            '. - období musí být úèetnì otevøeno'                      , ;
                            '. - nesmí probíhat úèetní uzávìrka'                       , ;
                            '. - musí existovat pøedchozí období úlohy mzdy'           , ;
                            '. - nesmí existovat vygenerované platby pro mzdy'         , ;
                            '. - nejsou vygenerované platby pro mzdy'                    }

    if pa_cargo_Usr[1] = 1
      ( ::headTitle := 'zakládání', ::subTitle := 'založit' )
    else
      ( ::headTitle := 'rušení'   , ::subTitle := 'zrušit'  )
    endif

    ::taskName := upper(pa_cargo_Usr[2])
    ::pa_info  := {}

    for x := 1 to len(pa_items) step 1
      nitem  := pa_items[x,1]
      lis_Ok := pa_items[x,2]

      aadd( ::pa_info, { pa_all_info[nitem], if(lis_Ok, '427', '102' ) } )
    next

    ::drgUsrClass:init(parent)
  return self


  inline method getForm()
    local oDrg, drgFC := drgFormContainer():new()
    local pa := ::pa_info, x, ny := .3
    *
    local headTitle := ::headTitle
    local subTitle  := 'nelze ' +::subTitle +' období úlohy ' +::taskName

    DRGFORM INTO drgFC SIZE 70,13 DTYPE '10' TITLE 'Chyba pøi ' +::headTitle +' _ období úlohy >' +::taskName +'<...'  ;
                                             GUILOOK 'All:N,Border:Y' BORDER 4


    DRGSTATIC INTO drgFC FPOS .1, .1 SIZE 69.8,12.8 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
      odrg:ctype := 2

      DRGTEXT INTO drgFC CAPTION 'Promiòte prosím,'                       CPOS 10,  .5 CLEN 30 FONT 5
      DRGTEXT INTO drgFC CAPTION subTitle                                 CPOS 10, 1.5 CLEN 40 FONT 5
      DRGTEXT INTO drgFC CAPTION 'nejsou splnìny požadované podmníky ...' CPOS 10, 2.5 CLEN 40 FONT 5

      DRGSTATIC INTO drgFC FPOS 60, 1.5 SIZE 30,30 STYPE 3 CAPTION '425'

      DRGSTATIC INTO drgFC FPOS .8,4.1 SIZE 68,5.5 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
        odrg:ctype := 2

        for x := 1 to len(pa) step 1
          DRGSTATIC INTO drgFC FPOS 3,ny SIZE 25,15 STYPE 3 CAPTION pa[x,2]
          DRGTEXT INTO drgFC CAPTION str(x,1) +pa[x,1] CPOS 10,  ny CLEN 50 FONT 5

          ny++
        next

*        DRGSTATIC INTO drgFC FPOS 3,  .3 SIZE 25,15 STYPE 3 CAPTION '427'
*        DRGTEXT INTO drgFC CAPTION '1. - lze zrušit pouze poslední otevøené období úlohy mzdy' CPOS 10,  .3 CLEN 50 FONT 5


*        DRGSTATIC INTO drgFC FPOS 3, 1.3 SIZE 25,15 STYPE 3 CAPTION '102'
*        DRGTEXT INTO drgFC CAPTION '2. - období musí být úèetnì otevøeno'                      CPOS 10, 1.3 CLEN 40 FONT 5

*        DRGSTATIC INTO drgFC FPOS 3, 2.3 SIZE 25,15 STYPE 3 CAPTION '102'
*        DRGTEXT INTO drgFC CAPTION '3. - nesmí probíhat úèetní uzávìrka'                       CPOS 10, 2.3 CLEN 40 FONT 5

*        DRGSTATIC INTO drgFC FPOS 3, 3.3 SIZE 25,15 STYPE 3 CAPTION '427'
*        DRGTEXT INTO drgFC CAPTION '4. - musí existovat pøedchozí období úlohy mzdy'           CPOS 10, 3.3 CLEN 40 FONT 5

*        DRGSTATIC INTO drgFC FPOS 3, 4.3 SIZE 25,15 STYPE 3 CAPTION '427'
*        DRGTEXT INTO drgFC CAPTION '5. - nesmí existovat vygenerované platby'                  CPOS 10, 4.3 CLEN 40 FONT 5

      DRGEND  INTO drgFC


      DRGPUSHBUTTON INTO drgFC CAPTION '   ~Storno' ;
                               POS 38,11            ;
                               SIZE 30,1.8          ;
                               ATYPE 3              ;
                               ICON1 102            ;
                               ICON2 202            ;
                               EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
    DRGEND  INTO drgFC
  return drgFC


  inline method drgDialogInit(drgDialog)
    LOCAL  aPos, aSize
    LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

    XbpDialog:titleBar := .F.
    drgDialog:dialog:drawingArea:bitmap  := 1016 // 1018
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self

ENDCLASS