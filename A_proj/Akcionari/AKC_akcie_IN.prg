#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "Gra.ch"
#include "xbp.ch"

#include "drg.ch"
#include "DRGres.Ch'
//
#include "..\Asystem++\Asystem++.ch"


#xtranslate  .AKCIONAR      =>  \[ 1\]
#xtranslate  .rec_AKCIONAR  =>  \[ 2\]
#xtranslate  .rec_AKCIE     =>  \[ 3\]
#xtranslate  .hodnotaAk     =>  \[ 4\]
#xtranslate  .pa_APOHYBAK   =>  \[ 5\]
#xtranslate  .main_AKCIE    =>  \[ 6\]


*
** CLASS for AKC_akcier_IN *****************************************************
CLASS AKC_akcie_IN FROM drgUsrClass
EXPORTED:
  method  init, drgDialogStart
  method  comboBoxInit, comboItemSelected
  method  preValidate, postValidate

  method  akcionar_sel

  var     d_bro
  var     hd_file, it_file


  inline method eBro_saveEditRow(o_eBro)
    local  nAKCIONAR := ::dm:get('apohybakW->nAKCIONAR') // nový majitel akcie
    local  nPOH_sign := ::dm:get('apohybakW->nPOH_sign') // +-1 - modifikujeme nzmHODakc  výpoèet nhodnotaAkc -nzmHODakc = nzakHODakc

    *
    ** pùvodní akcionáø vlastník akcie
    apohybakW->ndoklad    := apohybak->(lastRec()) +1

    apohybakW->cjmenoAkci := akcionar->cjmenoAkci
    apohybakW->czkrTYPar  := akcionar->czkrTYPar
    apohybakW->crodCISakc := akcionar->crodCISakc
    apohybakW->czkrTYPakc := akcieW  ->czkrTYPakc
    apohybakW->cserCISakc := akcieW  ->cserCISakc
    *
    ** nový akcionáø vlastník akcie
    akcionar_G->( dbseek( nAKCIONAR,, 'ID'))

    apohybakW->cjmenoNew  := ::dm:get( 'apohybakW->cjmenoNew' )
    apohybakW->czkrTYParn := akcionar_G->czkrTYPar
    apohybakW->czkrTYPnew := akcieW  ->czkrTYPakc
    apohybakW->cserCISnew := akcieW  ->cserCISakc
    apohybakW->nhodnotOld := akcieW->nzakHODakc

    apohybakW->nPOH_sign  := nPOH_sign
    apohybakW->nAKCIONAR  := nAKCIONAR
    apohybakW->nAKCIONARp := akcionar->sID
    apohybakW->nAKCIE     := akcieW->_nsidOr

    ::sumColumn()

    o_eBro:enabled_insCykl := .f.
  return .t.
  *
  ** body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  value, nin, ocolumn
*    LOCAL dc := ::drgDialog:dialogCtrl

    do case
    case ( nevent = drgEVENT_DELETE )
      if .not. apohybakW->( eof())

        value := ::dm:get('apohybakW->czkrTYPpoh')
        nin   := AScan(::aCOMBO_val, {|X| X[1] = value })

        if drgIsYesNo( 'Zrušit položku pohybu_ ' + allTrim(::aCOMBO_val[nin,2]) +' _ ;;    '  +allTrim(apohybakW->cjmenoNew) +' / ' +allTrim(str(apohybakW->nhodnotaAk,13,2)) +' CZK' )
          if( apohybakW->_nrecOr = 0, apohybakW->( dbdelete()), apohybakW->_delRec := '9' )

          ::oEBro_apohybakW:oxbp:goTop()
          ::oEBro_apohybakW:oxbp:refreshAll()

          ::sumColumn()

          * pošlem zprávu pro nastavení rámeèku na první sloupec ... cZkrTypAkc
          ocolumn := ::oEBro_apohybakW:getColumn_byName( 'akcieW->cZkrTypPoh' )
          postAppEvent(xbeBRW_ItemMarked, 1, 1, oColumn:dataArea)
        endif
      endif
      return .t.

*    case nEvent = drgEVENT_EDIT
*      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
*    case nEvent = drgEVENT_EXIT
*      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    otherwise
      return .f.
    endCase
  return .t.


  inline method onSave(lOk,isAppend,oDialog)
    local  anAr    := {}, anAkc := {}
    local  pa_list := {}, nin, x, pa, y, pAp, cky
    local  serCISakc := upper(akcieW->cserCISakc)
    local  mainOk  := .t.

    * zámek pro parenta akcionare a akcii
    aadd( anAr , akcionarW->_nrecOr )
    aadd( anAkc, akcieW   ->_nrecOr )

    apohybakW->( dbgoTop())
    aadd( pa_list, { akcionarW->_nsidOr, akcionarW->_nrecOr, akcieW->_nrecOr, akcieW->nzakHODakc, {}, 1 } )

    do while .not. apohybakW->( eof())
      nAKCIONAR := apohybakW->nAKCIONAR

      nin := ascan( pa_list, {|a| a[1] = nAKCIONAR } )

      if nin <> 0
        pa_list[nin,4] += if( pa_list[nin,6] = 0, apohybakW->nhodnotaAk, 0 )
        aadd( pa_list[nin,5], apohybakW->( recNo()) )
      else
        ** nový akcionáø vlastník akcie
        akcionar_G->( dbseek( nAKCIONAR,, 'ID'))
        aadd( anAr, akcionar_G->( recNo()) )

        aadd( pa_list, { apohybakW->nAKCIONAR, akcionar_G->(recNo()), 0, apohybakW->nhodnotaAk, { apohybakW->( recNo()) }, 0 } )

        ** akcionáø akcii již vlastní, musí dojít k její modifikaci
        cky := strZero(nAKCIONAR,10,0) +upper(akcieW->cserCISakc)

        if akcie_G->( dbseek( cky,,'AKCIE07'))
          aadd( anAkc, akcie_G->( recNo()) )
          pa := atail(pa_list)
          pa[3] := akcie_G->( recNo())
          pa[4] += akcie_G->nhodnotaAk
        endif
      endif

      apohybakW->( dbskip())
    enddo

    *
    ** ukládáme akcionar/ akcie/ apohybak
    mainOk := mainOk                       .and. ;
              akcionar_G->(sx_rLock(anAr)) .and. ;
              akcie_G   ->(sx_rLock(anAkc))

    if mainOk
      for x := 1 to len(pa_list) step 1
        pa := pa_list[x]

        akcionar_G->( dbgoto( pa.rec_AKCIONAR))

        if pa.rec_AKCIE <> 0
          akcie_G->( dbgoTo( pa.rec_AKCIE ))

          if pa.main_AKCIE = 1
            akcieW->nhodnotaAk := akcieW->nzakHODakc
          else
            akcieW->nhodnotaAk := pa.hodnotaAk
            akcieW->nzakHODakc := pa.hodnotaAk
          endif

        else
          mh_copyFld( 'akcionar_G', 'akcieW' )
          akcieW->nhodnotaAk := pa.hodnotaAk
          akcieW->nzakHODakc := pa.hodnotaAk
          akcieW->nAKCIONAR  := akcionar_G->sID

*         AKCIEsw->nhodnotaAk += akcieW->nhodnotaAk
          if select('AKCIEws') <> 0
            AKCIEsw->npocAkci   += 1
            AKCIEsw->maofAkci   += if( empty(AKCIEsw->maofAkci), '', ' or ') +'sID=' +alltrim( str( akcieW->nAKCIONAR))
          endif
        endif

        mh_copyFld( 'akcieW', 'akcie_G', (pa.rec_AKCIE = 0))

        pAp := pa.pa_APOHYBAK
        for y := 1 to len(pAp) step 1
          apohybakW->( dbgoTo(pAp[y]))
          mh_copyFld('apohybakW', 'apohybak', .t. )
        next

        ::modi_AKCIONAR()
      next

      if select('AKCIEws') <> 0
        AKCIEsw->nhodnotaAk := 0
        akcie_G->( ordSetFocus('AKCIE03'), dbsetScope( SCOPE_BOTH, serCISakc), dbgoTop(), ;
                   dbeval( { || AKCIEsw->nhodnotaAk += akcie_G->nhodnotaAk } )          , ;
                   dbclearScope()                                                         )
      endif

    else
      drgMsgBox(drgNLS:msg('Nelze modifikovat zmìny AKCIONÁØE, blokováno uživatelem ...'))
    endif

    akcionar_G->(dbunlock(),dbcommit())
      akcie_G  ->(dbunlock(),dbcommit())
        apohybak->(dbunlock(),dbcommit())

    apohybakW->( dbgoTop())

    if mainOk
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)
    endif
  return mainOk


  inline method drgDialogInit(drgDialog)
  return self


  inline method drgDialogEnd( drgDialog)
  return

HIDDEN:
  var  msg, dm, dc, df, m_DBrow
  var  oEBro_apohybakW, oGet_rodCISnew
  var  aCOMBO_val

  *    objitem ven
  var  o_dBro, state, sta_activeBro


  inline method set_focus_dBro()
    local  o_dBro  := ::o_dBro
    local  members := ::df:aMembers, pos

    pos := ascan(members,{|X| (x = o_dBro )})
    ::df:olastdrg   := ::o_dBro
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()

    setAppFocus( ::o_dBro:oxbp )
  return self

  inline method sumColumn()
    local  recNo    := apohybakW->( recNo())
    local  zmHODakc := 0

    apohybakW->( dbeval( { || zmHODakc += ( apohybakW->nPOH_sign * apohybakW->nhodnotaAk ) } ))

    akcieW->nzmHODakc  := zmHODakc
    akcieW->nzakHODakc := akcieW->nhodnotaAk + zmHODakc
    ::dm:refresh()

    apohybakW->( dbgoto(recNo))
  return self


  inline method modi_AKCIONAR()
    local  nAKCIONAR, pocetAkci, hodnotaAk, hodnotaVh
    local  cf := "nAKCIONAR = %%", filter

    nAKCIONAR := isNull(akcionar_G->sID, 0)
    pocetAkci := hodnotaAk := hodnotaVh := 0

    filter := format(cf, {nAKCIONAR} )
    akcie_G->( ads_setAof(filter), ;
               dbgoTop()         , ;
               dbeval( { || ( c_typakc->( dbseek( akcie_G->czkrTypAkc,,'C_TYPAKC01'))            , ;
                              pocetAkci++                                                        , ;
                              hodnotaAk += if( c_typakc->nzusobNapo = 0, akcie_G->nhodnotaAk, 0 ), ;
                              hodnotaVh += if( c_typakc->lzapocDOvh    , akcie_G->nhodnotaAk, 0 )  ) } ), ;
               ads_clearAof()                                                                             )


    * modifikace akcionar.npocetAkcii, nhodnaotaAk, nhodnotaVh, npocetHlas
    akcionar_G->npocetAkci := pocetAkci
    akcionar_G->nhodnotaAk := hodnotaAk
    akcionar_G->nhodnotaVh := hodnotaVh
    akcionar_G->npocetHlas := pocetHlasu_cmp( hodnotaVh, pocetAkci )
*    akcionar_G->( dbcommit())
  return self

ENDCLASS


method akc_akcie_in:init(parent)
  ::drgUsrClass:init(parent)

  ( ::hd_file  := 'akciew', ::it_file  := 'apohybakw' )

  ::m_DBrow := parent:parent:udcp:drgDialog:odBrowse[1]

  drgDBMS:open('c_typAkc')                    // typ akcií
  drgDBMS:open('akcionar',,,,,'akcionar_S')   // child of akcionar for search dialog
  *
  * za seznamu pro pøevod, prodej, darování, dìdictví vylouèíme sami sebe
  akcionar_S->( ads_setAof('.T.'))
  akcionar_S->( ads_customizeAOF( { akcionar->(recNo()) }, 3))

  drgDBMS:open('akcionar',,,,,'akcionar_G')   // child of akcionar for onSave
  drgDBMS:open('akcie'   ,,,,,'akcie_G'   )   // child of akcionar for onSave

  ** tmp soubory **
  drgDBMS:open('AKCIONARw',.T.,.T.,drgINI:dir_USERfitm); ZAP  // oblast 1
  drgDBMS:open('AKCIEw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP  // oblast 2
  drgDBMS:open('APOHYBAKw',.T.,.T.,drgINI:dir_USERfitm); ZAP  // oblast 3

  mh_copyFld( 'AKCIONAR', 'AKCIONARw', .t., .t. )
    akcionarW->nhodnAK_or := akcionar->nhodnotaAK
    akcionarW->nhodnVH_or := akcionar->nhodnotaVH

    c_typakc->( dbseek( akcie_P->czkrTypAkc,,'C_TYPAKC01'))
    akcionarW->nzusobNapo := c_typakc->nzusobNapo
    akcionarW->lzapocDOvh := c_typakc->lzapocDOvh

  mh_copyFld( 'akcie_p' , 'akcieW'   , .t., .t. )
return self


method akc_akcie_in:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  local  acolors  := MIS_COLORS, pa_groups, nin
  *
  ::msg             := drgDialog:oMessageBar             // messageBar
  ::dm              := drgDialog:dataManager             // dataMananager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form

  ::oEBro_apohybakW := ::dc:oBrowse[1]

  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)


    if odrg:className() = 'drgText' .and. .not. empty(groups)
      pa_groups := ListAsArray(groups)

      * XBPSTATIC_TYPE_RAISEDBOX           12
      * XBPSTATIC_TYPE_RECESSEDBOX         13

      if odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13
        odrg:oxbp:setColorBG(GRA_CLR_BACKGROUND)
      endif

      if ( nin := ascan(pa_groups,'SETFONT') ) <> 0
        odrg:oXbp:setFontCompoundName(pa_groups[nin+1])
      endif

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
          odrg:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        if isMemberVar(odrg, 'oBord') .and. ( odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13)
          odrg:oXbp:setColorFG(GRA_CLR_BLUE)
        else
          odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN)
        endif
      endif

*      groups      := pa_groups[1]
*      odrg:groups := groups
    endif

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif

    if odrg:ClassName() = 'drgStatic' .and. odrg:oxbp:type = XBPSTATIC_TYPE_ICON
      ::sta_activeBro := odrg
    endif
  next

  ::oGet_rodCISnew := ::dm:has('apohybakW->crodCISnew'):odrg

** nìco ven
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  ::d_Bro  := drgDialog:odBrowse[1]
  ::o_dBro := ::d_Bro

  ::d_Bro:oxbp:refreshAll()

  ::df:setNextFocus( ::oEBro_apohybakW )
return self


*
** OK akcionar
method AKC_akcie_IN:comboBoxInit(drgComboBox)
  ::aCOMBO_val := { { 'Pøev' , 'pøevod akcie         ' , .t. , -1 }, ;
                    { 'Daro' , 'darování akcie       ' , .t. , -1 }, ;
                    { 'Dìdi' , 'vypoøádání dìdictví  ' , .t. , -1 }, ;
                    { 'Prod' , 'prodej akcie         ' , .t. , -1 }, ;
                    { 'Zvýš' , 'zvýšení hodnoty akcie' , .f. , +1 }, ;
                    { 'Sníž' , 'snížení hodnoty akcie' , .f. , -1 }, ;
                    { 'Vyøa' , 'vyøazení akcie       ' , .f. , -1 }, ;
                    { 'Vypl' , 'vyplacení akcie      ' , .f. , -1 }, ;
                    { 'Práv' , 'pøevod práv akcie    ' , .f. , -1 }    }

  drgComboBox:oXbp:clear()
  drgComboBox:values := ::aCOMBO_val
**  drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] < aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
return self


method AKC_akcie_IN:comboItemSelected(drgComboBox,mp2)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nIn
  *
  local  nevent := mp1 := mp2 := nil

  * blbne pøeskok pokud RÈ není editovatelnì
  nevent  := LastAppEvent(@mp1,@mp2)

  nIn         := AScan(values, {|X| X[1] = value })
  isRC_edit   := values[nIn,3]
  isSUM_akcie := values[nIn,4]

  if .not. isRC_edit
    * zmìny nad vlastní akcií, negenerují novou akcii
    ::dm:set('apohybakW->crodCISnew', akcionar->crodCISakc )
    ::dm:set('apohybakW->cjmenoNew' , akcionar->cjmenoAkci )
    ::dm:set('apohybakW->nAKCIONAR' , akcionar->sID        )

    ( ::oGet_rodCISnew:isEdit := .f., ::oGet_rodCISnew:oxbp:disable() )
  else
    ( ::oGet_rodCISnew:isEdit := .t., ::oGet_rodCISnew:oxbp:enable()  )
  endif

  ::dm:set( 'apohybakW->nPOH_sign', values[nIn,4] )
return self


method AKC_akcie_IN:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  ok    := .t.

  do case
  case( name = ::it_file +'->crodcisnew' )
    drgVar:odrg:isEdit := ( value <> akcionar->crodCISakc )
  endcase
return .t.


method AKC_akcie_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

   do case

  * kontroly na hlavièce akcieW
  case( file = ::hd_file )

  * kontroly na položce apohybakW
  case( file = ::it_file )
    do case
    case( name = ::it_file +'->crodcisnew' .and. mp1 = xbeK_RETURN )
      ok := ::akcionar_sel()

    case( name = ::it_file +'->nhodnotaak' )
      ok := ( akcieW->nzakHODakc >= value )

    endcase
  endCase


  * na akcionar ukládme vždy
**  if('apohybakW' $ name .and. ok, drgVAR:save(),nil)
RETURN ok


method AKC_akcie_IN:akcionar_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, copy := .F.
  *
  local drgVar := ::dm:has('apohybakW->crodCISnew')
  local value  := upper(drgVar:get())
  local lOk    := akcionar_S ->(dbseek(value,,'Akcionar01')) .and. .not. empty(value)

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'AKC_AKCIONAR_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit
  ENDIF

  if (lOk .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
    ::dm:set( 'apohybakW->crodCISnew', akcionar_S->crodCISakc )
    ::dm:set( 'apohybakW->cjmenoNew' , akcionar_S->cjmenoAkci )
    ::dm:set( 'apohybakW->nAKCIONAR' , akcionar_S->sID        )
  endif
return (nExit != drgEVENT_QUIT) .or. lOk