#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
*
**
#include "..\FINANCE\FIN_finance.ch"


#define  m_files   { 'c_uctosn', 'c_staty'                        , ;
                     'dodlstit', 'vyrzak'  , 'vyrzakit', 'cenzboz', ;
                     'fakprihd', 'fakvyshd'                         }


*
** CLASS for FIN_dphkohhd_IN ***************************************************
CLASS FIN_dphkohhd_IN FROM drgUsrClass, FIN_finance_IN  // , FIN_fakturovat_z_vld, FIN_pro_fakdol
  exported:
  var     hd_file, it_file, lnewREC

  var     rozPo, typ_dokl, is_ban, aval_krp
  var     in_file, ain_file, varSym

  METHOD  init, preValidate, postValidate, postLastField, postValidateForm
  METHOD  overPostLastField, postSave, postAppend, postDelete
  METHOD  drgDialogInit, drgDialogStart, drgDialogEnd
  *
  method  osb_osoby_sel

  * hd
  inline access assign method obdobiDan() var obdobiDan
    return left( (::hd_file)->cobdobiDan, 3) +str( (::hd_file)->nrok,4)

  * it ?
  inline access assign method cnaz_uct_hd()  var cnaz_uct_hd
    c_uctosn->( DbSeek(if(isnull(::nazuc_hd),'',::nazuc_hd:value)))
    return c_uctosn->cnaz_uct
  *
  inline access assign method cnaz_uct_it()  var cnaz_uct_it
    c_uctosn->( DbSeek(if(isnull(::nazuc_it),'',::nazuc_it:value)))
    return c_uctosn->cnaz_uct

  inline access assign method dod_cenzakcel var dod_cenzakcel
    return if(fakvnpitw->nsubcount = 0, fakvnpitw->ncenzakcel, 0)

  inline access assign method odb_cenzakcel var odb_cenzakcel
    return if(fakvnpitw->nsubcount = 0, 0, fakvnpitw->ncenzakcel)

  inline access assign method in_file(m_file)
    local pos

    if ::state = 2
      if pcount() == 1
        ::in_file := m_file
      else
        ::in_file := if( Empty(::varSym:get()), '', ::in_file)
      endif
    else
      if(pos := AScan(::ain_file,{|x| x[6] = (::it_file)->cdenik_par})) <> 0
        ::in_file := ::ain_file[pos,1]
      endif
    endif
  return ::in_file

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  myEv := {drgEVENT_APPEND,drgEVENT_EDIT,drgEVENT_SAVE,drgEVENT_EXIT,drgEVENT_DELETE}
    local  file_Name, olastDrg := ::df:olastDrg
    local  rowPos, lrefresh := .f., sid := isNull( (::it_file)->sid, 0 )


     if ascan(myEv,nevent) <> 0
      if lower( olastDrg:className()) $ 'drgbrowse,drgdbrowse'
        file_name := ::it_file
      else
        file_name := lower( isNull(drgparse(oLastDrg:name,'-'), ::it_file ))
      endif
    endif


    do case
    case (nEvent = xbeBRW_ItemMarked)
      rowPos   := if( isArray(mp1), mp1[1], mp1 )
      lrefresh := ( ::state <> 0 )

      ::msg:WriteMessage(,0)
      ::state := 0

      if sid <> 0 .and. rowPos = ::brow:rowPos
        * hd

        * it
        if(ismethod(self, 'postItemMarked'), ::postItemMarked(), Nil)
        ::restColor()
      endif
      return .f.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if( file_Name = ::hd_file )
        if isMethod(self,'postSave')
          if ::postSave()
             PostAppEvent(xbeP_Close, nEvent,,oXbp)
          endif
          return .t.
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif


      if .not. (lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse') .and. isobject(::brow)
        ok := if(isMethod(self,'overPostLastField'), ::overPostLastField(), .t.)

        if(IsMethod(self, 'postLastField') .and. ok, ::postLastField(), Nil)
      else
        if isMethod(self,'postSave')
          if ::postSave()
             PostAppEvent(xbeP_Close, nEvent,,oXbp)
          endif
          return .t.
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif

    otherwise
      return ::handleEvent(nevent,mp1,mp2,oxbp)
    endcase
  return .F.

  inline method showGroup()
    return .t.

 HIDDEN:
  *
  *  na IT bacha tohle jsou objekty drgVar
  var     ozaklD_dph, ozaklDan_3, osazDan_3, ozaklDan_1, osazDan_1, ozaklDan_2, osazDan_2
  var     pa_Parent

  var     members_inf

  VAR     roundDph, zaklMena
  var     paGroups, title, cisFak


  inline method sumColumn()
    local  coddilKohl

    ( (::hd_file)->nSumDaP01 := (::hd_file)->nSumDaP02  := (::hd_file)->nSumDaP40 := ;
      (::hd_file)->nSumDaP41 := (::hd_file)->nSumDaP25  := (::hd_file)->nSumDaP10 := ;
      (::hd_file)->nSumDaP11 := (::hd_file)->nSumDaP313 := 0                         )

    dphKoh_iw->( dbgotop())

    do while .not. dphKoh_iw->( eof())
      coddilKohl := dphKoh_iW->coddilKohl

      do case
      case ( coddilKohl = 'A.2' )
        (::hd_file)->nSumDaP313 += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_2 +dphKoh_iW->nZaklDan_3 )

      case ( coddilKohl = 'A.4' .or. coddilKohl = 'A.5' )
        (::hd_file)->nSumDaP01  +=   dphKoh_iW->nZaklDan_2
        (::hd_file)->nSumDaP02  += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_3 )

      case ( coddilKohl = 'B.2' .or. coddilKohl = 'B.3' )
        (::hd_file)->nSumDaP40  +=   dphKoh_iW->nZaklDan_2
        (::hd_file)->nSumDaP41  += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_3 )

      case ( coddilKohl = 'A.1' )
        (::hd_file)->nSumDaP25  += dphKoh_iW->nzakld_Dph

      case ( coddilKohl = 'B.1' )
        (::hd_file)->nSumDaP10  +=   dphKoh_iW->nZaklDan_2
        (::hd_file)->nSumDaP11  += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_3 )

      endcase

      dphKoh_iw->( dbskip())
    enddo

/*

    local  recNo         := fakvnpitW->( recNo())
    local  dod_cenZakCel := 0
    local  sumCol

    fakvnpitW->( dbeval( { || dod_cenZakCel += fakvnpitW->ncenzakcel } ), ;
                 dbgoTo( recNo )                                      )

    fakVnphdW->ncenZakCel := dod_cenZakCel
    ::dm:set('fakVnphdW->ncenZakCel', dod_cenZakCel)

    sumCol         := ::brow:cargo:getColumn_byName( 'M->dod_cenZakCel' )

    sumCol:Footing:setCell(1, dod_cenZakCel )
    sumCol:footing:invalidateRect()
    sumCol:Footing:show()
*/
  return self

ENDCLASS


METHOD FIN_dphkohhd_IN:init(parent)
  ::drgUsrClass:init(parent)
  *
  (::hd_file := 'dphKohHDw', ::it_file := 'dphKohITw')

/*
  ::pa_Parent := { { 'D' , 'FIN_fakprihd_IT_IN', {'fakPrihd', 'fakpriit'            }             }, ;
                   { 'O' , 'FIN_fakvyshd_IN'   , {'fakvyshd', 'fakvysit'            }             }, ;
                   { 'V' , 'FIN_ucetdohd_IN'   , {'ucetdohd', 'ucetdoit'            }             }, ;
                   { 'VD', 'FIN_ucetdohdzz_IN' , {'ucetdohd', 'ucetdoit', 'fakPrihd'}, 'FPRIHD15' }, ;
                   { 'VO', 'FIN_ucetdohdzz_IN' , {'ucetdohd', 'ucetdoit', 'fakVyshd'}, 'FODBHD17' }, ;
                   { 'P' , 'FIN_pokladhd_IN'   , {'pokladhd', 'pokladit'            }                }  }

  ::pa_Parent[1,1] := SysConfig( 'Finance:cDenikFAPR' )    // fakprihd
  ::pa_Parent[2,1] := SYSCONFIG( 'FINANCE:cDENIKFAVY' )    // fakvyshd
  ::pa_Parent[3,1] := SysConfig( 'Finance:cDenikFIDO' )    // ucetdohd - všeobecný doklad
  ::pa_Parent[4,1] := SysConfig( 'Finance:cDENIKfdpz' )    // ucetdohd - daòové doklady fakprihd (zz)
  ::pa_Parent[5,1] := SysConfig( 'Finance:cDENIKfdvz' )    // ucetdohd - daòové doklady fakvyshd (zz)
  ::pa_Parent[6,1] := SysConfig( 'Finance:cDenikFIPO' )    // pokladhd
*/

  * vstupní soubory pro kontrolu na csymol
  ::ain_file := {{'fakprihd', 0, 0, 1,  9, SysConfig('FINANCE:cDENIKFAPR')}, ;
                 {'fakvyshd', 0, 0, 2, 10, SysConfig('FINANCE:cDENIKFAVY')}  }

  *
  ::rozPo    := 0
  ::typ_dokl := 'vnp_f'
  ::is_ban   := .f.
  ::lNEWrec  := .not. (parent:cargo = drgEVENT_EDIT)

  * základní soubory
  ::openfiles(m_files)

  * pøednastavení z CFG
  ::roundDph  := SysConfig('Finance:nRoundDph')
  ::zaklMena  := SysConfig('Finance:cZaklMena')

  FIN_dphkohhd_cpy(self)

  c_staty->( dbseek( upper((::hd_file)->cstat),,'C_STATY1') )

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file) ->(OrdSetFocus(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'dphKoh_iW', .t., .t.) ; dphKoh_iw ->(OrdSetFocus(1))
RETURN self


METHOD FIN_dphkohhd_IN:drgDialogInit(drgDialog)
RETURN


METHOD FIN_dphkohhd_IN:drgDialogStart(drgDialog)
  local que_del := ' kontrolního hlášení_DPH'
  *
  local  members  := drgDialog:oForm:aMembers, aedits := {}
  local  x, odrg, groups, name, tipText


  FOR x := 1 TO LEN(members)
    odrg    := members[x]

    IF members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        members[x]:oXbp:setFontCompoundName(ListAsArray(members[x]:groups)[2])
      endif
    ENDIF

    if odrg:ClassName() =  'drgTabPage'
      if odrg:tabNumber = 2
        odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
      endif
    endif

*    if .not. empty(tipText)
*      aadd( ::pa_onCards, odrg )
*    endif
  NEXT

  ::members_inf := {}

  * likvidace bankovní výpisy/vzájemné zápoèty/ úhrady pokladnou/ vnitro_podnikové fakttury nemají RVDPH *
  ::FIN_finance_in:init(drgDialog,::typ_dokl,::it_file +'->coddilKohl',que_del)

  *
  ::ozaklD_dph := ::dm:get(::it_file +'->nzaklD_dph', .F.)
  ::ozaklDan_3 := ::dm:get(::it_file +'->nzaklDan_3', .F.)
  ::osazDan_3  := ::dm:get(::it_file +'->nsazDan_3' , .F.)
  ::ozaklDan_1 := ::dm:get(::it_file +'->nzaklDan_1', .F.)
  ::osazDan_1  := ::dm:get(::it_file +'->nsazDan_1' , .F.)
  ::ozaklDan_2 := ::dm:get(::it_file +'->nzaklDan_2', .F.)
  ::osazDan_2  := ::dm:get(::it_file +'->nsazDan_2' , .F.)

  ::sumColumn()
  ::df:setNextFocus( 'dphKohHDw->ddatmDuvod',,.t.)
RETURN self


METHOD FIN_dphkohhd_IN:drgDialogEnd(drgDialog)

  dphKohHDw ->(dbclosearea())
  dphkohITw ->(dbclosearea())
  dphKoh_iW ->(dbclosearea())

  ::drgUsrClass:destroy()

  _clearEventLoop(.t.)
RETURN


method FIN_dphkohhd_IN:preValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .t.

  do case
  * konroly na hlavièce
  case(file = ::hd_file )

  * zpracování na položce
  case(file = ::it_file )
    if( ::lnewRec, ok := ::postValidateForm(::hd_file), nil )
  endcase
return ok


METHOD FIN_dphkohhd_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
*
  local  file   := drgParse(name,'-')
  LOCAL  ok     := .T., changed := drgVAR:changed(), subtxt
  local  it_sel := 'fakvnpitW->ncislodl,fakvnpitW->cciszakazi,fakvnpitW->csklpol'
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case(file = ::hd_file )

    * konroly na hlavièce
    do case
    case(name = ::hd_file +'->ncisfak')
       m_file := upper(left(::hd_file, len(::hd_file)-1))
       (aX := fin_range_key(m_file,value,,::msg), ok := aX[1])
       if( ok .and. ::lVSYMBOL)
         (::hd_file)->cvarsym := alltrim(str(value))
         ::dm:has(::hd_file +'->cvarsym'):set(alltrim(str(value)))
       endif

    case(name = ::hd_file +'->cvarsym'   )

    case(name = ::hd_file +'->dvystfak'  )
      if empty(value)
        drgMsgBOX( 'Datum vystavení faktury je povinný údaj ...' )
        ok := .f.
      else
        if StrZero(fakvnphdW->nobdobi,2) +'/' +Str(fakvnphdW->nrok) <> StrZero(Month(value),2) +'/' +Str( Year( value),4)
          ::msg:writeMessage('Datum vystavení faktury, nesouhlasí s obdobím dokladu...',DRG_MSG_INFO)
        endif
      endif

    case(name = ::hd_file +'->cnazpol1'  )
      ok := dod_stred->( dbseek( upper(value),,'CNAZPOL1') )

    case(name = ::hd_file +'->cnazpol1o' )
      ok := odb_stred->( dbseek( upper(value),,'CNAZPOL1') )

    endcase

  case(file = ::it_file )

    * kontroly a zpracování na položce
    do case
    case(field_name = 'nzakldan_1' .and. changed)
      ::osazDan_1:set( mh_RoundNumb( (value/100) * (::hd_file)->nprocdan_1, ::roundDph ) )

    case(field_name = 'nzakldan_2' .and. changed)
      ::osazDan_2:set( mh_RoundNumb( (value/100) * (::hd_file)->nprocdan_2, ::roundDph ) )

    case(field_name = 'nzakldan_3' .and. changed)
      ::osazDan_3:set( mh_RoundNumb( (value/100) * (::hd_file)->nprocdan_3, ::roundDph ) )
    endcase



    do case
    case(name $ it_sel .and. changed)
      ok := ::fakturovat_z_sel(drgVar:drgDialog)

    case( name = ::it_file +'->nfaktmnoz' )

    case( name = ::it_file +'->ncenazakl' )
      nfaktmnoz := ::dm:has(::it_file +'->nFAKTMNOZ' )
      ::dm:set( ::it_file +'->ncenZakCel', nfaktmnoz:value * value )

    case(name = ::it_file +'->cnazpol6')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    endcase
  endcase

  if(file = ::hd_file .and. ok)
    eval(drgVar:block,drgVar:value)
    drgVar:initValue := drgVar:value
  endif

  if changed .and. ok
    ::dm:refresh()
  endif
RETURN ok


method FIN_dphkohhd_IN:osb_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::dm:drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
    (::hd_file)->cjmenoVys := osoby->cosoba
    ::dm:set(::hd_file +'->cjmenoVys',osoby->cosoba)
  endif
return (nexit != drgEVENT_QUIT)



method FIN_dphkohhd_IN:overPostLastField()
*  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1' )
*  local  ucet      := ::dm:get(::it_file +'->cucet'    )
  local  ok  := .t.

*  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok


METHOD FIN_dphkohhd_IN:postLastField(drgVar)
  local  ok

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if .t. // ::postValidateForm(::it_file)
    if ::state = 2
      mh_copyfld(::hd_file, ::it_file, .t., .f.)

*      (::it_file)->nintcount := ::ordItem()+1
    endif

    ::itSave()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())

    ::sumColumn()
    ::setfocus(::state)
    ::dm:refresh()
  endif
RETURN .t.


method FIN_dphkohhd_IN:postAppend()
RETURN .T.


method FIN_dphkohhd_IN:postDelete()
  ::sumColumn()
  ::brow:refreshAll()
return .t.


method FIN_dphkohhd_IN:postSave()
  local  ok

   if( ok := FIN_dphkohhd_wrt_inTrans(self) )
     PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
   endif
return ok


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method FIN_dphkohhd_IN:postValidateForm(m_file)
  local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
  local  drgVar
  *
  begin sequence
    for x := 1 to size step 1
      file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

      if file = m_file .and. values[x,2]:odrg:isEdit

        drgVar := values[x,2]

        if .not. ::postValidate(drgVar)

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