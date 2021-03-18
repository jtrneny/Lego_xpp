#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys', 'rozbpz_h', 'rozbpz_i' }


function FIN_rozbpz_BC(nCOLUMn)
  local  xRETval := ''

  do case
  * rozbpz_h
  case(nCOLUMn = 11)  ;  xRETval := if(rozbpz_h->lset_Roz, 172, 0)

  * rozbpz_i
  case(nCOLUMn = 21)  ;  xRETval := if(rozbpz_i->lset_Roz, 172, 0)
  case(nCOLUMn = 22)  ;  xRETval := 'SPLATNOST -> '
  case(nCOLUMn = 24)  ;  xRETval := if(empty(rozbpz_i->crel_1), '   ', str(rozbpz_i->nval_1))
  case(nCOLUMn = 25)  ;  xRETval := if(empty(rozbpz_i->crel_1), '   ', ;
                                    if(rozbpz_i->nval_1 < 10, 'dne','dnù'))
  case(nCOLUMn = 27)  ;  xRETval := if(empty(rozbpz_i->crel_2), '   ', str(rozbpz_i->nval_2))
  case(nCOLUMn = 28)  ;  xRETval := if(empty(rozbpz_i->crel_2), '   ', 'dnù'                )

  endCase
return xRETval


**
** CLASS for FIN_rozbpz_h *****************************************************
CLASS FIN_rozbpz_h FROM drgUsrClass, FIN_finance_IN
EXPORTED:
  var     lnewRec, hd_file, it_file, datRozb, k_datRozb, obdRozb, k_obdRozb
  method  init, drgDialogStart
  method  itemMarked, postAppend, postValidate, postLastField
  method  comboBoxInit, comboItemSelected
  *
  method  sys_tiskform_crd

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local lastDrg := ::df:oLastDrg

    do case
     case (nEvent = xbeBRW_ItemMarked)
       ::msg:editState:caption := 0
       ::msg:WriteMessage(,0)
       ::state   := 0
       if lastDrg:className() = 'drgDBrowse'
         ::brow    := lastDrg:oxbp
         ::one_edt := if(lower(::brow:cargo:cfile) = ::hd_file,'rozbpz_h->cnaz_Roz','rozbpz_i->crel_1')
       endif

       if rozbpz_i->crel_1 = 'od ' ; ::dnu:show()
                                     ::rel_2:oDrg:oxbp:show()
                                     (::val_2:oDrg:isEdit := .t., ::val_2:oDrg:oxbp:show())
       else                        ; ::dnu:hide()
                                     ::rel_2:oDrg:oxbp:hide()
                                     (::val_2:oDrg:isEdit := .f., ::val_2:oDrg:oxbp:hide())
       endif

       return .f.

    case(nevent = xbeP_Selected)
     if oxbp:cargo:ovar:value
       oxbp:setData(.t.)
       return .t.
     else
       ::postValidate(oXbp:cargo:oVar,.T.)
       return .f.
     endif

    case(nevent = drgEVENT_DELETE)
      ::fin_rozbpz_h_del()
      return .t.

    case(nevent = drgEVENT_PRINT)
      ::sys_tiskform_crd()
      return .t.

    otherwise
      return ::handleEvent(nEvent,mp1,mp2,oXbp)
    endcase

    return .f.

HIDDEN:
  var     a_obrow, obro_rozh, nbro_rozh, obro_rozi, nbro_rozi
  var     rel_2, val_2, dnu
  var     cmb_obdRozb
  var     startOk
  method  fin_rozbpz_h_del, fin_rozbpz_h_gen
ENDCLASS


method FIN_rozbpz_h:init(parent)
  local cKy := upper(uctOBDOBI:FIN:CULOHA) +strZero(uctOBDOBI:FIN:NROK,4)

  ::drgUsrClass:init(parent)

  (::hd_file  := 'rozbpz_h',::it_file  := 'rozbpz_i')
  ::lnewRec   := .f.
  ::datRozb   := date()
  ::k_datRozb := .t.
  ::startOk   := .t.

  ::obdRozb   := '' // left(obdReport,2) +'/' +right(obdReport,2)  /// uctOBDOBI:FIN:COBDOBI
  ::k_obdRozb := .f.

  * základní soubory
  ::openfiles(m_files)

  * pomocný soubor
  drgDBMS:open('rozbpz_h',,,,,'rozbpz_m')

  if .not. ucetsys ->( dbseek( cky,, 'UCETSYS3'))
    ConfirmBox( ,'Nemáte nastaveny základní paremetry úlohy, nelze zpracovat požadavek !', ;
                 'Kontaktujte prosím distributora ...'            , ;
                  XBPMB_OK                                        , ;
                  XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE      )
    ::startOk := .f.
    return .f.
  endif
return self


method FIN_rozbpz_h:drgDialogStart(drgDialog)
  local members := drgDialog:oForm:aMembers, x

  ::fin_finance_in:init(drgDialog,'roz','rozbpz_h->cnaz_Roz',' nastavení rozboru')
  ::in_scr := .t.

  for x := 1 TO LEN(members) step 1
    do case
    case( members[x]:ClassName() = 'drgDBrowse')
      if lower(members[x]:cfile) = ::hd_file
        ::obro_rozh := members[x]
        ::nbro_rozh := x
      elseif lower(members[x]:cfile) = ::it_file
        ::obro_rozi := members[x]
        ::nbro_rozi := x
      endif

    case( members[x]:ClassName() = 'drgText'   )
      if( members[x]:groups = 'DNU', ::dnu := members[x]:oxbp, nil)

    endcase
  next

  ::a_obrow := drgDialog:odbrowse

  ::rel_2       := ::dm:has(::it_file +'->crel_2')
  ::val_2       := ::dm:has(::it_file +'->nval_2')
  ::cmb_obdRozb := ::dm:has('M->obdRozb'):odrg
return ::startOk  // self


method FIN_rozbpz_h:itemMarked(arowco,unil,oxbp)
  local cfile, cky := strZero(rozbpz_h->ntyp_Roz,3)

  if isObject(oxbp)
    cfile := lower(oxbp:cargo:cfile)

    if( cfile = ::hd_file, rozbpz_i->(dbSetScope(SCOPE_BOTH, cky),dbGoTop()), nil)
  endif
return self


method FIN_rozbpz_h:postAppend()
  ::dm:set('rozbpz_h->lset_Roz', .t.)
  ::dm:set('rozbpz_i->crel_1'  ,'od')
  ::dm:set('rozbpz_i->nval_1'  ,  0 )
  ::dm:set('rozbpz_i->crel_2'  ,'do')
  ::dm:set('rozbpz_i->nval_2'  ,  0 )
  ::dm:set('rozbpz_i->lset_Roz', .t.)

  ::dnu:show()
  ::rel_2:oDrg:oxbp:show()
  (::val_2:oDrg:isEdit := .t., ::val_2:oDrg:oxbp:show())
return .t.


method FIN_rozbpz_h:postValidate(drgVar,lSelected)
  local  value  := drgVar:get(), lvalue
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  default lSelected TO .f.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  if lSelected
    if('m->k_datrozb' = name .or. 'm->k_obdrozb' = name)
      lvalue := .not. drgVar:value
      ::dm:set('m->k_datrozb',.f.)
      ::dm:set('m->k_obdrozb',.f.)

      drgVar:set(lvalue)
    endif
  else

    do case
    case(name = 'rozbpz_h->cnaz_Roz' )
      if empty(value)
        ::msg:writeMessage('Název rozboru je povinný údaj ...',DRG_MSG_EROR)
        ok := .f.
      endif

    case(name = 'rozbpz_i->lset_Roz')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif
    endcase
  endif
return ok


method FIN_rozbpz_h:comboBoxInit(drgCombo)
  local  cname := drgParseSecond(drgCombo:name,'>')
  local  cKy, acombo_val := {}

  if .not. ::startOk
    retur self
  endif


  if lower(cname) = 'obdrozb'
    cKy := upper(uctOBDOBI:FIN:CULOHA)    // +strZero(uctOBDOBI:FIN:NROK,4)

    ucetsys->(AdsSetOrder('UCETSYS3'), dbsetScope(SCOPE_BOTH, cKy), dbgoTop())
    ucetsys->(dbEval( {|| aAdd(acombo_val, ;
                         { ucetsys->cobdobi                                          , ;
                           strZero(ucetsys->nobdobi,2) +'/' +strZero(ucetsys->nrok,4), ;
                           strZero(ucetsys->nrok,4) +strZero(ucetsys->nobdobi,2)       } )} ))


    drgCombo:oXbp:clear()
    drgCombo:values := ASort( acombo_val,,, {|aX,aY| aX[3] < aY[3] } )
    aeval(drgCombo:values, { |a| drgCombo:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    ::obdRozb   := uctOBDOBI:FIN:COBDOBI  //  acombo_val[1,1]
    drgCombo:refresh( ::obdRozb )
    drgCombo:value := drgCombo:ovar:value
  endif
return self


method FIN_rozbpz_h:comboItemSelected(mp1,mp2,o)

  if mp1:value = 'od ' ; ::dnu:show()
                         ::rel_2:oDrg:oxbp:show()
                         (::val_2:oDrg:isEdit := .t., ::val_2:oDrg:oxbp:show())
  else                 ; ::dnu:hide()
                         ::rel_2:oDrg:oxbp:hide()
                         (::val_2:oDrg:isEdit := .f., ::val_2:oDrg:oxbp:hide())
  endif
return self


method FIN_rozbpz_h:postLastField()
  local  isChanged := ::dm:changed()
  local  mainOk    := .f.
  *
  local  in_h      := (lower(::brow:cargo:cfile) = ::hd_file)
  local  state     := ''

  * ukládáme na posledním PRVKU *
  if ::state = 2
    state := if(in_h, 'aa', if((::hd_file)->(eof()), 'aa', 'ra'))
  else
    do case
    case(rozbpz_h->(eof()) .and. rozbpz_i->(eof()))  ; state := 'aa'
    case                         rozbpz_i->(eof())   ; state := 'ra'
    otherwise                                        ; state := 'rr'
    endcase
  endif

  do case
  case(state = 'aa')  ;  mainOk := (addrec (::hd_file) .and. addrec (::it_file))
  case(state = 'ra')  ;  mainOk := (replrec(::hd_file) .and. addrec (::it_file))
  case(state = 'rr')  ;  mainOk := (replrec(::hd_file) .and. replrec(::it_file))
  endcase

  if isChanged .and. mainOk
    if (::hd_file)->ntyp_Roz = 0
      rozbpz_m->(AdsSetOrder(1),dbgoBottom())
      (::hd_file)->ntyp_Roz := rozbpz_m->ntyp_Roz +1
    endif

    mh_copyFld('rozbpz_h','rozbpz_i',, .f.)
    ::itsave()
  endif

  ::setFocus()
  PostAppEvent(xbeBRW_ItemMarked,,,::brow)

  rozbpz_h->(dbUnlock(), dbCommit())
   rozbpz_i->(dbUnlock(), dbCommit())
    ::dm:refresh()
return .t.


method FIN_rozbpz_h:fin_rozbpz_h_del()
  local  nsel, nodel := .f., ok, recNo := rozbpz_i->(recNo())
  local  in_h        := (lower(::brow:cargo:cfile) = ::hd_file)
  *
  local  cMess := 'Požadujete zrušit '
  local  cTitl := 'Zrušení '
  local  ky    :=  padc(alltrim(rozbpz_h->cnaz_Roz),50), pa := {}

  if in_h
    ok := .not. rozbpz_h->(eof())
    (cMess += 'nastavený rozbor ...', cTitl += 'rozboru ...'        )
  else
    ok := .not. rozbpz_i->(eof())
    (cMess += 'položku rozboru ...' , cTitl += 'položky rozboru ...')
  endif

  if ok
    nsel := ConfirmBox( ,cMess +chr(13) +chr(10) +ky, ;
                         cTitl                      , ;
                         XBPMB_YESNO                , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

    if nsel = XBPMB_RET_YES
      if in_h  ; rozbpz_i->(dbgoTop()                                  , ;
                            dbeval({ || aadd(pa,rozbpz_i->(recNo())) }), ;
                            dbgoTo(recNo())                              )
        if(rozbpz_h->(sx_rLock()) .and. rozbpz_i->(sx_rLock(pa)))
          rozbpz_i->(dbgoTop(), dbeval({ || rozbpz_i->(dbDelete()) }))
          rozbpz_h->(dbDelete())
        else
          nodel := .t.
        endif
       else
         if( rozbpz_i->(sx_rLock()), rozbpz_i->(dbdelete(), dbUnLock()), nodel := .t.)
      endif
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Nastavený rozbor ...' +chr(13) +chr(10) +ky +' nelze zrušit ...', ;
                 'Zrušení nastaveného rozboru ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel

*
** zpracování požadavku a spuštìní dialogu sys_tiskform_crd
method FIN_rozbpz_h:sys_tiskform_crd()
  local  oDialog, nExit
  *
  local  formName := ::drgDialog:formName

  if(select('rozbpzw') <> 0, rozbpzw->(dbclosearea()), nil)
  ::fin_rozbpz_h_gen()

  ::drgDialog:formName := 'drgMenu'

  oDialog := drgDialog():new('sys_tiskform_crd,fin_rozbpz_lst',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  oDialog:destroy(.T.)
  oDialog := NIL

  ::drgDialog:formName := formName
return self


method FIN_rozbpz_h:fin_rozbpz_h_gen()
  local  nD, cI, cC, ndny_p, nlast_Day, dlast_Day, x, y, pa, obdobi
  local  axConds := {}, npos
  *
  local  acFILEm := {'fakvyshd','fakprihd'}
  local  acFILEs := {'banvypit','pokladit'}
  local  cfile_m, cfile_s, lisZal, nuhrCelFak, ncenZakCel, lDone, rozbor_K, cKy, uhr_Fak, uhr_Faz

  rozbpz_i->(dbgoTop())

  do while .not. rozbpz_i->(eof())
    if rozbpz_i->lset_roz
      nD := 0
      cI := rozbpz_i->crel_1  +' ' +str(rozbpz_i->nval_1) +' ' +'dnù ' + ;
            rozbpz_i->crel_2  +' ' + ;
            if(rozbpz_i->nval_2 = 0, '', ' ' +str(rozbpz_i->nval_2) +' ' +'dnù' )

      do case
      case(rozbpz_i->crel_1 = 'do ')
        cC := 'ndny_p <= val("' +str(rozbpz_i->nval_1) +'")'

      case(rozbpz_i->crel_1 = 'od ')
        cC := 'val("' +str(rozbpz_i->nval_1) +'") <= ndny_p .and. ' + ;
              'ndny_p <= val("' +str(rozbpz_i->nval_2) +'")'

      case(rozbpz_i->crel_1 = 'nad')
        nD := 1
        cC := 'ndny_p >= val("' +str(rozbpz_i->nval_1 +1) +'")'
      endcase

      ndny_p := max(rozbpz_i->nval_1 +nD, rozbpz_i->nval_2 +nD )
      aAdd( axConds, { ndny_p, &( '{ |X,N,nDNY_P|' +cC +'}' ) , cI } )
    endif

    rozbpz_i->(dbskip())
  enddo

  *
  **
  drgDBMS:open('rozbpzw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  drgDbms:open('fakvyshd')  ;  fakvyshd->(AdsSetOrder(1))
  drgDbms:open('fakprihd')  ;  fakprihd->(AdsSetOrder(1))
  drgDbms:open('banvypit')  ;  banvypit->(AdsSetOrder(2))
  drgDbms:open('pokladit')  ;  pokladit->(AdsSetOrder(2))
  *
  ** rozbor k datu / pro zadané obdobi
  if  ::dm:get('M->k_datRozb')
    rozbor_K  := 1
    dlast_Day := ::dm:get('M->datRozb')
  else
    rozbor_K  := 2
    obdobi    := ::dm:get('M->obdRozb')
    pa        := ::cmb_obdRozb:values
    cC        := pa[aScan(pa, { |X| X[1] = obdobi }),2]
    cC        := strTran(cC,'/','.')
    *
    nlast_Day := mh_LastDayOM(ctod( '01.' +cC))
    dlast_Day := ctod( strZero(nlast_Day,2) +'.' +cC)
  endif

  *
  ** jedeme zpracování podladù pro tisk
  drgServiceThread:progressStart(drgNLS:msg('Rozbory pohledávek a závazkù ... ', 'ROZBPZW'), ;
                                             fakvyshd->(lastRec()) +fakprihd->(lastRec())    )


  for x := 1 to len(acFILEm) step 1
    (cfile_m := acFILEm[x], (cfile_m)->( dbgoTop()))

    do while .not. (cfile_m)->(eof())
      ndny_p := dlast_Day - (cfile_m)->dsplatFak
      nPos   := 0
      aEval( axConds, { |X,N| If( eval( X[2], X, N, ndny_p ), nPos := N, NIL ) })

      if nPos <> 0
        if     Equal( cfile_m, 'FAKPRIHD' )
          lisZAL := ( FakPriHD ->nFinTYP == 3 .or. FakPriHD ->nFinTYP == 5 )
        elseif Equal( cfile_m, 'FAKVYSHD' )
          lisZAL := ( FakVysHD ->nFinTYP == 2 .or. FakVysHD ->nFinTYP == 4 )
        else
          lisZAL := .F.
        endif

        nuhrCelFak := (cfile_m)->nuhrCelFak
        ncenZakCel := (cfile_m)->ncenZakCel

        if nuhrCelFak < 0 .and. ncenZakCel < 0       // DOBOPISY
          nuhrCelFak := abs(nuhrCelFak)
          ncenZakCel := abs(ncenZakCel)
        endif

        lDone := .f.

        if rozbor_K = 1                              // rozbor k datu
          lDone := (cfile_m)->dsplatFak <= dlast_Day
        else                                         // rozbor k období
          do case
          case (cfile_m)->nrok < year(dlast_Day)
            lDone := .t.
          case (cfile_m)->nrok = year(dlast_Day) .and. (cfile_m)->nobdobi <= month(dlast_Day)
            lDOne := .t.
          endcase
        endif

        if .not. lisZal .and. lDone
          if     (cfile_m)->nuhrCelFak = 0
            mh_copyFld(cfile_m, 'rozbpzw', .t.)
            if( cfile_m = 'fakvyshd', rozbpzw->dvystFak := (cfile_m)->dpovinFak, nil)

            rozbpzw->dporizFak := dlast_Day
            rozbpzw->nmnozPrep := axCONDs[nPos,1]
            rozbpzw->cnazev2   := axCONDs[nPos,3]
            rozbpzw->ctextFakt := 'Celkem neuhrazené ' +if(x =1, 'pohledávky', 'závazky')

          elseif (cfile_m)->dposUhrFak > dlast_Day .or. nuhrCelFak <> ncenZakCel
            mh_copyFld(cfile_m, 'rozbpzw', .t.)
            if( cfile_m = 'fakvyshd', rozbpzw->dvystFak := (cfile_m)->dpovinFak, nil)

            rozbpzw->dporizFak := dlast_Day
            rozbpzw->nmnozPrep := axCONDs[nPos,1]
            rozbpzw->cnazev2   := axCONDs[nPos,3]
            rozbpzw->ctextFakt := 'Celkem neuhrazené ' +if(x =1, 'pohledávky', 'závazky')

            cKy := upper((cfile_m)->cdenik) +strZero((cfile_m)->ncisFak,10)

            for y := 1 to len(acFILEs) step 1
               cfile_s := acFILEs[y]
               (cfile_s)->(dbsetScope(SCOPE_BOTH,cKy),dbgoTop())

               do while .not. (cfile_s)->(eof())
                 if (cfile_s)->ddatUhrady > dlast_Day

                   uhr_Fak := (cfile_s)->nuhrCelFak
                   uhr_Faz := (cfile_s)->nuhrCelFaz

/*
                   if (cfile_s)->nuhrCelFaz <> 0
                     uhr_Fak := ((cfile_s)->nuhrCelFaz * (cfile_s)->nkurzMenf) / (cfile_s)->nmnozPref
                   else
                     uhr_Fak := (cfile_s)->nuhrCelFak
                   endif
*/

                   if (cfile_m = 'fakprihd' .and. (cfile_s)->nvydej  <> 0) .or. ;
                      (cfile_m = 'fakvyshd' .and. (cfile_s)->nprijem <> 0)
                     rozbpzw->nuhrCelFak -= uhr_Fak
                     rozbpzw->nuhrCelFaz -= uhr_Faz

                   else
                     rozbpzw->nuhrCelFak -= uhr_Fak
                     rozbpzw->nuhrCelFaz -= uhr_Faz
                   endif
                 endif

                 (cfile_s)->(dbSkip())
               enddo

               (cfile_s)->(dbclearScope())
             next

          endif
        endif
      endif

      drgServiceThread:progressInc()
      (cfile_m) ->(dbskip())
    enddo
  next

  drgServiceThread:progressEnd()
  rozbpzw->(dbCommit(), dbgotop())
return self