#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
#include "dmlb.ch"
//
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for AKC_akcionar_IN ***************************************************
CLASS AKC_akcionar_IN FROM drgUsrClass
exported:
  var     lNEWrec, cmb_typPoh
  method  init, drgDialogStart, drgDialogEnd
  method  postValidate, overPostLastField, postLastField, postSave
  method  firmyico_sel
  *
  var     lok_append2

  *
  ** BRo_2  - > akcieW
  inline access assign method nazevAkc() var nazevAkc      // název typu akcie c_typAkc
    c_typAkc->( dbseek( upper(akciew->cZkrTypAkc),,'C_TYPAKC01'))
    return c_typAkc->cnazevAkc


 ** pro EBro
  inline method eBro_saveEditRow(o_eBro)
    ::sumColumn()
    o_eBro:enabled_insCykl := .f.
    return .t.

  inline method postAppend()
    ( ::oget_zkrTypAkc:isEdit := .t., ::oget_zkrTypAkc:oxbp:enable() )
    ( ::oget_serCisAkc:isEdit := .t., ::oget_serCisAkc:oxbp:enable() )
    return .t.

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case ( nevent = drgEVENT_DELETE )
     if .not. akcieW->( eof())
        if drgIsYesNo( 'Zrušit položku akcie_ ' +allTrim(akcieW->cserCISakc) +' / ' +allTrim(str(akcieW->nhodnotaAk,13,2)) +' CZK' )
          if( akcieW->_nrecOr = 0, akcieW->( dbdelete()), akcieW->_delRec := '9' )

          ::oEBro_akcieW:oxbp:goTop()
          ::oEBro_akcieW:oxbp:refreshAll()

          ::sumColumn()

          * pošlem zprávu pro nastavení rámeèku na první sloupec ... cZkrTypAkc
          ocolumn := ::oEBro_akcieW:getColumn_byName( 'akcieW->cZkrTypAkc' )
          postAppEvent(xbeBRW_ItemMarked, 1, 1, oColumn:dataArea)
        endif
      endif
      return .t.

    otherWise
      return .f.
    endcase
  return .f.


  inline method onSave(lOk,isAppend,oDialog)
    local  anAkc  := {}
    local  mainOk := .t., nrecOr

    akcieW->( adsSetOrder(0), dbgoTop()                                , ;
              dbeval( { || aadd( anAkc, akcieW->_nrecOr ) } ), dbgoTop() )

    if .not. ::lnewRec
      akcionar->( dbgoTo( akcionarW->_nrecOr))
      mainOk := mainOk                     .and. ;
                akcionar->(sx_rLock())     .and. ;
                akcie   ->(sx_rLock(anAkc))
    endif

    if mainOk
      mh_copyFld( 'akcionarW', 'akcionar', ::lnewRec, .f. )

      do while .not. akcieW->( eof())

        if((nrecOr := akcieW->_nrecor) = 0, nil, akcie->(dbgoto(nrecor)))

        if akcieW->_delRec = '9'
          if( nrecOr <> 0, akcie->( dbdelete()), nil )
        else
          akcieW->cjmenoAkci := akcionar->cjmenoAkci
          akcieW->czkrTYPar  := akcionar->czkrTYPar
          akcieW->crodCISakc := akcionar->crodCISakc
          akcieW->nzakHODakc := akcieW  ->nhodnotaAk

          akcieW->nAKCIONAR  := akcionar->sID
          mh_copyFld('akcieW', 'akcie', (nrecOr=0), .f. )
        endif

        akcieW->( dbskip())
      endDo

    else
      drgMsgBox(drgNLS:msg('Nelze modifikovat AKCIONÁØE, blokováno uživatelem ...'))
    endif

    akcionar->(dbunlock(),dbcommit())
     akcie->(dbunlock(),dbcommit())

    akcieW->( dbgoTop())
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  return mainOk


hidden:
* sys
  var     msg, dm, dc, df, brow
  var     hd_file, it_file, oEBro_akcieW

  var     aEdits, panGroup, members, nazuc_hd, nazuc_it
  var     rozMd


  * suma
  inline method sumColumn()
    local  recNo     := akcieW->( recNo())
    local  pocetAkci := 0, hodnotaAk := 0, hodnotaVh := 0
    local  sumCol

    akcieW->( dbeval( { || ( c_typakc->( dbseek( akcieW->czkrTypAkc,,'C_TYPAKC01'))            , ;
                             pocetAkci++                                                       , ;
                             hodnotaAk += if( c_typakc->nzusobNapo = 0, akcieW->nhodnotaAk, 0 ), ;
                             hodnotaVh += if( c_typakc->lzapocDOvh    , akcieW->nhodnotaAk, 0 )  ) }))


    * modifikace akcionarW.npocetAkcii, nhodnaotaAk, nhodnotaVh, npocetHlas
    akcionarW->npocetAkci := pocetAkci
    akcionarW->nhodnotaAk := hodnotaAk
    akcionarW->nhodnotaVh := hodnotaVh
    akcionarW->npocetHlas := pocetHlasu_cmp( hodnotaVh, pocetAkci )

    ::dm:set( 'akcionarW->npocetAkci',             pocetAkci )
    ::dm:set( 'akcionarW->nhodnotaAk',             hodnotaAk )
    ::dm:set( 'akcionarW->npocetHlas', akcionarW->npocetHlas )

    sumCol := ::oEBro_akcieW:getColumn_byName( 'akcieW->nhodnotaAk' )

    sumCol:Footing:setCell(1, hodnotaAk )
    sumCol:footing:invalidateRect()
    sumCol:Footing:show()

    akcieW->( dbgoTo(recNo))
  return self
ENDCLASS


method AKC_akcionar_IN:init(parent)
  local file_name

  ::drgUsrClass:init(parent)
  *
  (::hd_file     := 'akcionarw', ::it_file := 'akciew')
   ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)
   ::lok_append2 := .f.
  *
  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
  drgDBMS:open('c_typAkc')   // typ akcií
  *
  AKC_akcionar_cpy(self)
return self


method AKC_akcionar_IN:drgDialogStart(drgDialog)
  local x

  ::msg           := drgDialog:oMessageBar             // messageBar
  ::dm            := drgDialog:dataManager             // dataManager
  ::dc            := drgDialog:dialogCtrl              // dataCtrl
  ::df            := drgDialog:oForm                   // form

  ::oEBro_akcieW  := ::dc:oBrowse[1]

  ::aEdits   := {}
  ::panGroup := '1'
  ::members  := drgDialog:oForm:aMembers

  for x := 1 to LEN(::members) step 1
    if ::members[x]:ClassName() = 'drgStatic' .and. .not.Empty(::members[x]:groups)
      AAdd(::aEdits, { ::members[x]:groups, x })
    endif
  next
  *
  ::sumColumn()

  if( ::lnewRec, nil, ::df:setNextFocus( ::oEBro_akcieW ) )
return self



METHOD AKC_akcionar_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  recNo  := akcionar->( recNo())


  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  do case

  * kontroly na hlavièce akcionar
  case( file = ::hd_file )
    do case
    case( name = ::hd_file +'->cjmenoakci' )
      ** povinný údaj
      if empty(value)
        ::msg:writeMessage('Jméno akcionáøe je povinný údaj ...',DRG_MSG_WARNING)
        ok := .f.
      endif

    case( name = ::hd_file +'->crodcisakc' )
      ** povinné/ kontrola správnosti, picture
      ** kontrola na duplicitu akcionar.crodcisakc
      if empty(value)
        ::msg:writeMessage('Rodné èíslo akcionáøe je povinný údaj ...',DRG_MSG_WARNING)
        ok := .f.
      else
        if akcionar->( dbseek(value,,'AKCIONAR01'))
          ::msg:writeMessage('Rodné èíslo akcionáøe již v seznamu akcionáøù exituje ...',DRG_MSG_WARNING)
          ok := .f.
        endif
      endif
    endcase

  * kontroly na položce akcie
  case( file = ::it_file )
    do case
    case( name = ::it_file +'->czkrtypakc' )
      c_typAkc->( dbseek(value,, 'C_TYPAKC01' ))
      ::dm:set( 'M->nazevAkc', c_typAkc->cnazevAkc )

    case( name = ::it_file +'->csercisakc' .and. changed )
      ** povinný údaj
      ** kontrola na duplicitu akcie / akcieW
      if empty(value)
        ::msg:writeMessage('Sérové èíslo akcie je povinný údaj ...',DRG_MSG_WARNING)
        ok := .f.
      else
        if akcie->( dbseek(value,,'AKCIE03'))
          ::msg:writeMessage('Sérové èíslo akcie již v seznamu akcí exituje ...',DRG_MSG_WARNING)
          ok := .f.
        endif
      endif
    endcase

  endcase

  * na akcionar ukládme vždy
  if('akcionarw' $ name .and. ok, drgVAR:save(),nil)
RETURN ok


method AKC_akcionar_IN:firmyico_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, copy := .F.
  *
  local drgVar := ::dm:has('ucetDohdW->cdic')
  local value  := upper(drgVar:get())
  local lOk    := firmy ->(dbseek(value,,'FIRMY8')) .and. .not. empty(value)

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIR_FIRMYICO_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit
  ENDIF

  if (lOk .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
    mh_copyfld('firmy','ucetDohdW',,.f.)

    drgVar:set(firmy->cdic)
    drgvar:value = drgvar:initValue := drgvar:prevValue := firmy->cdic
  endif
return (nExit != drgEVENT_QUIT) .or. lOk


method AKC_akcionar_IN:overPostLastField()
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1')
  local  ucet      := ::dm:get(::it_file +'->cucetDal'   )
  local  ok

  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok


METHOD AKC_akcionar_IN:postLastField(drgVar)
  local  isChanged := ::dm:changed()

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
// JS    if(::state = 2, mh_copyfld(::hd_file,::it_file,, .f., .f.), nil)
    if(::state = 2, ::copyfldto_w(::hd_file,::it_file), nil )

    (::it_file)->(flock())
    ::dm:save()

    if ::state = 2
      UCETDOITw ->cUCETMD   := UCETDOHDw ->cUCET_UCT
      UCETDOITw ->cTYP_R    := UCETDOHDw ->cTYPOBRATU
      UcetDOITw ->nORDITEM  := ::ordItem() +1
      UcetDOITw ->nORDUCTO  := 1

      fin_ucetdohd_typ(::cmb_typPoh)
      ::brow:gobottom()
      ::brow:refreshAll()
    else
      ::brow:refreshCurrent()
    endif
  endif

  ::setfocus(::state)
  ::sumColumn(5)
  ::dm:refresh()
RETURN .T.


method AKC_akcionar_IN:postSave()
  local  ok := .t., file_name

  if ::rozMd <> 0
    fin_info_box('Nelze uložit nevyrovnaný doklad !')
    ok := .f.
  else
    ok := FIN_ucetdohd_wrt(self)
  endif

  if(ok .and. ::new_Dok .and. ::lok_append2, ::new_Dok := .f., nil )

  if(ok .and. ::new_dok)

    (::it_file)->(DbCloseArea())
    ucetdoi_w ->(DbCloseArea())

    FIN_ucetdohd_cpy(self)

    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'ucetdoi_w', .t., .t.) ; ucetdoi_w  ->(AdsSetOrder(1))

    ::df:setNextFocus('ucetdohdw->ctypdoklad',,.t.)
    ::brow:refreshAll()
    ::dm:refresh()
    ::sumColumn(5)
  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


method AKC_akcionar_IN:drgDialogEnd(drgDialog)
*  (::it_file)->(DbCloseArea())
*  ucetdoi_w ->(DbCloseArea())
return


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
static function akc_akcionar_cpy(oDialog)
  local  lnewRec := if( isNull(oDialog), .f., oDialog:lnewRec )

  ** tmp soubory **
  drgDBMS:open('AKCIONARw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('AKCIEw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  if lnewRec
    AKCIONARw->( dbappend())
  else
    mh_copyFld( 'AKCIONAR', 'AKCIONARw', .t., .t. )
    akcie->( dbeval( { || mh_copyFld( 'AKCIE', 'AKCIEw', .t., .t. ) } ))
  endif
return nil