#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"
#include "dbstruct.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
** hurá
** greatest common divisor (GCD) Nejvìtší spoleèný dìlitel
function GCD( num1,num2)
  local Remainder := 1

  while ( num2 != 0 )
    Remainder := num1 % num2
         num1 := num2
         num2 := Remainder
  end
return num1

** least common multiple (LCM)  Nejmenší spoleèný násobek
** vzorec je LCM(n1,n2) = n1 * n2 / GCD( n1,n2)
function LCM(a,b)
return ( a * b )/GCD(a,b)

function LCM_a( pa )
  local  numbers

  for x := 1 to len(pa) step 1
    if x < len(pa)
      numbers := pa[x+1] := LCM( pa[x], pa[x+1] )
    endif
  next
return numbers



*  POZEMKY
** CLASS HIM_pozemky_SCR ********************************************************
CLASS HIM_pozemky_SCR FROM drgUsrClass  // , quickFiltrs
EXPORTED:
  METHOD  eventHandled
  METHOD  itemMarked


  inline method init(parent)
    ::drgUsrClass:init(parent)

    drgDBMS:open('pozemky' )   // pozemky hlavièky
    drgDBMS:open('pozemkit')   // pozemky položky
    drgDBMS:open('maj')        // him
    drgDBMS:open('c_katast')   // katastry nemovitostí
  return self


  inline method drgDialogStart(drgDialog)
    local  x, abMembers

    ::dc        := drgDialog:dialogCtrl              // dataCtrl
    ::df        := drgDialog:oForm                   // form
    ::msg       := drgDialog:oMessageBar             // messageBar

    abMembers   := drgDialog:oActionBar:Members

    for x := 1 to len(abMembers) step 1
      if isCharacter(abMembers[x]:event)
        do case
        case abMembers[x]:event $ 'HIM_pozemky_prevPoz' ; ::obtn_HIM_pozemky_prevPoz := abMembers[x]
        endcase
      endif
    next
  return self


  inline method him_pozemkit_vypCen(drgDialog)
    local  odialog, nexi

    oDialog := drgDialog():new('HIM_pozemkit_vypCen',drgDialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    ::itemMarked()
  return self


  inline method him_pozemky_prevPoz(drgDialog)
    local  odialog, nexi

    _clearEventLoop()
    postAppEvent(drgEVENT_EDIT,,,drgDialog:dialog)

    oDialog := drgDialog():new('HIM_pozemky_prevPoz',drgDialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    ::itemMarked()
  return self

HIDDEN:
  VAR     dc, df, msg
  var     obtn_HIM_pozemky_prevPoz

  inline method postDelete()
    local  sid    := isNull(pozemky->sid,0)
    local  cc     := padc( str(pozemky->ninvCis,10) +' _ ' +pozemky->cku_kod +' _ ' +str(pozemky->nlistVlast,8) +' _ '+pozemky->cparcCis, 40 )
    *
    local  ctitle := 'Zrušení pozemku v evidenci ...'
    local  cinfo  := 'Promiòte prosím,'                                       +CRLF + ;
                     'požadujete zrušit pozemek v evidenci majetku ...' +CRLF +CRLF + ;
                      '[ ' +allTrim(cc) +' ]'
    *
    local  cStatement, oStatement
    local  stmt := "delete from pozemky  where sID = %sid;"    + ;
                   "delete from pozemkit where nPOZEMKY = %sid;"

    if sid <> 0
      nsel :=  ConfirmBox( , cinfo      , ;
                             ctitle     , ;
                             XBPMB_YESNO, ;
                             XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

      if nsel = XBPMB_RET_YES

        cinfo := 'Promiòte prosím,'                                               +CRLF + ;
                 'p.' +logOsoba                                                   +CRLF + ;
                 'OPRAVDU požadujete zrušit pozemek v evidenci majetku ...' +CRLF +CRLF + ;
                 '[ ' +allTrim(cc) +' ]'

        nsel := ConfirmBox( , cinfo    , ;
                              ctitle   , ;
                              XBPMB_YESNO                            , ;
                              XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )


        if nsel = XBPMB_RET_YES
          cStatement := strTran( stmt, '%sid', allTrim(str(sid)) )
          oStatement := AdsStatement():New(cStatement,oSession_data)

          if oStatement:LastError > 0
            *  return .f.
          else
            oStatement:Execute( 'test', .f. )
            oStatement:Close()
          endif
          pozemky->(dbskip())
        endif
      endif

      pozemky ->(dbcommit(), dbunlock())
      pozemkit->(dbcommit(), dbunlock())

      ::drgDialog:dialogCtrl:refreshPostDel()
    endif
  return .t.

  inline method info_in_msgStatus()
    local  msgStatus := ::msg:msgStatus, picStatus := ::msg:picStatus
    local  ncolor, cinfo, oPs
    *
    local  curSize  := msgStatus:currentSize()
    local  paColors := { { graMakeRGBColor( {  0, 183, 183} ), graMakeRGBColor( {174, 255, 255} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {251,  51,  40} ), graMakeRGBColor( {254, 183, 173} ) }  }
    *
    local  cmainTask := 'hihi all'  // ::show_mainTask()

    msgStatus:setCaption( '' )
    picStatus:hide()

    if .not. empty(cmainTask)
      ncolor := 2
      cinfo  := cmainTask

      oPs := msgStatus:lockPS()
      GraGradient( oPs, {  0, 0 }    , ;
                        { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )
      graStringAT( oPs, { 20, 4 }, cinfo )
      msgStatus:unlockPS()

      picStatus:setCaption(DRG_ICON_MSGWARN)
      picStatus:show()
    endif
  return

ENDCLASS


*
********************************************************************************
METHOD HIM_pozemky_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
*  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
*    ::itemSelected()

  case  nEvent = drgEVENT_DELETE
    ::postDelete()
    return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.


METHOD HIM_pozemky_SCR:itemMarked()
  local  nPOZEMKY := isNull(pozemky->sID, 0 )
  local  cf := "nPOZEMKY = %%", filter
  local  cpodil := allTrim(pozemky->cpodil)


  filter := format( cf, {nPOZEMKY} )
  pozemkit->( ads_setAof(filter), dbgoTop())
  *
//  ::info_in_msgStatus()

  if cpodil = '1' .or. cpodil = '1/1'
    ::obtn_HIM_pozemky_prevPoz:oxbp:enable()
  else
    ::obtn_HIM_pozemky_prevPoz:oxbp:disable()
  endif

RETURN self





*
** CLASS for HIM_pozemky_CRD ***************************************************
CLASS HIM_pozemky_CRD FROM drgUsrClass
exported:
  var     lNEWrec
  method  init, drgDialogStart
  method  preValidate, postValidate

  * pozemky
  inline access assign method nazevMaj() var nazevMaj      // název majeku
    majSW->( dbseek( pozemkyW->ninvCis,,'MAJ02'))
    return majSW->cnazev

  inline method ebro_afterAppendBlankRec(o_eBro)
    ::copyfldto_w(::hd_file,::it_file)
    pozemkitW->cNazPozem := c_pozem->cNazDruPoz
  return self

  inline method eBro_saveEditRow(o_eBro)
    ::sumColumn()
    o_eBro:enabled_insCykl := .f.
  return .t.

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  lastDrg := ::df:oLastDrg, value
    local  sid := isNull( pozemkitW->sid, 0 ), cc, nsel
    local  ctitle := 'Zrušení položky pozemku v evidenci ...'
    local  cinfo  := 'Promiòte prosím,'                                       +CRLF + ;
                     'požadujete zrušit položku pozemku v evidenci ...' +CRLF +CRLF

    * My
    * myší se snaží dostat na BROw položky, je potøeba zkotrolovat hlavièku
    if nevent = xbeM_LbClick
      if( oxbp:className() = 'XbpCellGroup' .and. sid = 0 .and. .not. ::is_pozemkyWOk )
        ::df:setNextFocus( if( isObject(::olastOK_drg), ::olastOK_drg, ::one_Edit),, .T. )
        return .t.
      endif
    endif


    do case
    case ( nevent = drgEVENT_DELETE )
      if sid <> 0

        cinfo += '[ ' +allTrim( pozemkyW->cku_kod +' _ ' +str(pozemkyW->nlistVlast,8) +' _ '+pozemkyW->cparcCis, 40 ) +' ]'

        nsel :=  ConfirmBox( , cinfo       , ;
                               ctitle      , ;
                               XBPMB_YESNO , ;
                               XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

        if nsel = XBPMB_RET_YES
          if( pozemkitW->_nrecOr = 0, pozemkitW->( dbdelete()), pozemkitW->_delRec := '9' )

          ::oEBro_pozemkitW:oxbp:goTop()
          ::oEBro_pozemkitW:oxbp:refreshAll()

          ::sumColumn()

          * pošlem zprávu pro nastavení rámeèku na první sloupec ... cPodil
          ocolumn := ::oEBro_pozemkitW:getColumn_byName( 'pozemkitW->cpodil' )
          postAppEvent(xbeBRW_ItemMarked, 1, 1, oColumn:dataArea)
        endif
      endif
      return .t.


    case nEvent = xbeP_Keyboard
      if lastDrg:className() = 'drgGet'

        do case
        case(lower(lastDrg:name) = 'pozemkitw->cpodil')

          value := oxbp:value
          do case
          case(       empty(value) .and. chr(mp1) $ '123456789' )
            return .f.
          case( .not. empty(value) .and. chr(mp1) $ '0123456789/' )
            if ( chr(mp1) = '/' .and. at('/', value) <> 0 )
               postAppEvent(xbeP_Keyboard,xbeK_RIGHT,,oxbp)
               return .t.
             else
               return .f.
            endif
          endCase
        endCase

      endif
    endcase
  return .f.


  inline method onSave(lOk,isAppend,oDialog)
    local  anPozit := {}
    local  mainOk  := .t., nrecOr

    pozemkitW->( adsSetOrder(0), dbgoTop()                                , ;
                 dbeval( { || aadd( anPozit, pozemkitW->_nrecOr ) } ), dbgoTop() )

    if .not. ::lnewRec
      pozemky->( dbgoTo( pozemkyW->_nrecOr))
      mainOk := mainOk                        .and. ;
                pozemky->(sx_rLock())         .and. ;
                pozemkit->(sx_rLock(anPozit))
    endif

    if mainOk
      mh_copyFld( 'pozemkyW', 'pozemky', ::lnewRec, .f. )

      do while .not. pozemkitW->( eof())

        if((nrecOr := pozemkitW->_nrecor) = 0, nil, pozemkit->(dbgoto(nrecor)))

        if pozemkitW->_delRec = '9'
          if( nrecOr <> 0, pozemkit->( dbdelete()), nil )
        else

          pozemkitW->nPOZEMKY  := pozemky->sID
          mh_copyFld('pozemkitW', 'pozemkit', (nrecOr=0), .f. )
        endif

        pozemkitW->( dbskip())
      endDo

    else
      drgMsgBox(drgNLS:msg('Nelze modifikovat POZEMKY, blokováno uživatelem ...'))
    endif

    pozemky ->(dbunlock(),dbcommit())
    pozemkit->(dbunlock(),dbcommit())
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  return mainOk


hidden:
* sys
  var     msg, dm, dc, df, brow
  var     one_Edit, is_pozemkyWOk, nsum_podVym_M2, pa_podilVym
  var     hd_file, it_file, oEBro_pozemkitW, olastOk_drg

  * pozemkyW -> pozemkitW
  inline method copyfldto_w(from_db,to_db,app_db)
    local  npos, xval, afrom := (from_db)->(dbstruct()), x
    *
    local  citem

    if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
    for x := 1 to len(afrom) step 1
      citem := to_Db +'->' +(to_Db)->(fieldName(x))

      if .not. (lower(afrom[x,DBS_NAME]) $ 'ninvcis,ncenapoz,ndannabpoz,ncenasdana,_nrecor,_delrec')
        xval := (from_db)->(fieldget(x))
        npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

        if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
      endif
    next
  return nil

  * My
  * postValidateForm
  inline method postValidateForm(m_file)
    local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
    local  drgVar
    *
    begin sequence
      for x := 1 to size step 1
        file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

        if file = m_file .and. values[x,2]:odrg:isEdit
          drgVar := values[x,2]
          isOk    := isNull(drgVar:odrg:postValidOk, .f. )

          if isOk
          else
            if .not. ::postValidate(drgVar)

              ::df:olastdrg   := values[x,2]:odrg
              ::df:nlastdrgix := x
              ::df:olastdrg:setFocus()
              return .f.
    break
            else
              drgVar:odrg:postValidOk := .t.
            endif
          endif
        endif
      next
    end sequence
  return .t.
  *
  * suma
  inline method sumColumn()
    local  recNo    := pozemkitW->( recNo())
    local  pa       := { {'npodVym_m2', 0}, {'ncenaPoz', 0}, {'ndanNabPoz', 0}, {'ncenaSDaNa', 0 } }
    local  oBrow    := ::oEBro_pozemkitW:oxbp, x, npos, value
    local  ardef    := ::oEBro_pozemkitW:ardef
    *
    local  pa_podil := ::pa_podilVym := {}

    pozemkitW->( dbeval( { || ( aadd( pa_podil, { pozemkitW->sid                                                           , ;
                                                  if( empty(pozemkitW->cpodil), '1/1', strTran(pozemkitW->cpodil,' ', '') ), ;
                                                  pozemkitW->npodVym_m2 } )   , ;
                                pa[1,2] += pozemkitW->npodVym_m2              , ;
                                pa[2,2] += pozemkitW->ncenaPoz                , ;
                                pa[3,2] += pozemkitW->ndanNabPoz              , ;
                                pa[4,2] += pozemkitW->ncenaSDaNa  ) } ))


    * modifikace pozemkyW.cpodil, nprocVym, sum(npodVym_m2, ncenaPoz, ndanNabPoz, ncenaSDan)
    pozemkyW->cpodil     := if( len(pa_podil) = 1, pa_podil[1,2], ::sum_podil(pa_podil) )
    pozemkyW->nprocVym   := ( pa[1,2] / pozemkyW->nvymera_m2) * 100
    pozemkyW->npodVym_m2 := pa[1,2]
    pozemkyW->ncenaPoz   := pa[2,2]
    pozemkyW->ndanNabPoz := pa[3,2]
    pozemkyW->ncenaSDaNa := pa[4,2]

    ::nsum_podVym_M2     := pa[1,2]

    for x := 1 to len(pa) step 1
      if ( npos := ascan( ardef, { |ait| lower(pa[x,1]) $ lower( ait[2]) })) <> 0
        value := str(pa[x,2])

        if oBrow:getColumn(npos):Footing:getCell(1) <> value
          oBrow:getColumn(npos):Footing:hide()
          oBrow:getColumn(npos):Footing:setCell(1, value)
          oBrow:getColumn(npos):Footing:show()
        endif
      endif
    next

    pozemkitW->( dbgoTo(recNo))
  return self


  inline method sum_podil(pa_podil)
    local  x, pa, pa_n := {}, pa_jmen := {}
    local  nsp_cit := 0, nsp_jmen := 1
    local  csum_podil := '1/1'

    for x := 1 to len(pa_podil) step 1
      pa := asize( listAsArray( pa_podil[x,2], '/'), 2 )
      aeval( pa, {|x,n| pa[n] := if( isNull(x), 1, val(x) ) })

      aadd( pa_n   , pa    )
      aadd( pa_jmen, pa[2] )
    next

    * spoleèný jmenovatel
    for x := 1 to len(pa_jmen) step 1
      if x < len(pa_jmen)
        nsp_jmen := pa_jmen[x+1] := LCM( pa_jmen[x], pa_jmen[x+1] )
      endif
    next

    aeval( pa_n, { |x,n| nsp_cit += ( nsp_jmen / x[2]) * x[1] } )

    * ještì pokrátit pokud to jde
    if (nx := GCD(nsp_cit,nsp_jmen)) <> 0
      nsp_cit  := nsp_cit  / nx
      nsp_jmen := nsp_jmen / nx
    endif
    csum_podil := allTrim( str(nsp_cit,3,0)) +'/' +allTrim( str(nsp_jmen,3,0))
  return csum_podil


  inline method restColor()
    local  members := ::df:aMembers

    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
  return .t.

ENDCLASS


method HIM_pozemky_CRD:init(parent)
  local file_name

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('maj')
  drgDBMS:open('maj',,,,,'majSW')
  drgDBMS:open('c_listvl')
  *
  (::hd_file      := 'pozemkyW', ::it_file := 'pozemkitW')
   ::lNEWrec      := .not. (parent:cargo = drgEVENT_EDIT)
  *
  ::one_Edit      := 'pozemkyW->ninvCis'
  ::is_pozemkyWOk := .t.
  ::pa_podilVym   := {}

  him_pozemky_cpy(self)
return self


method HIM_pozemky_CRD:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  local  acolors  := MIS_COLORS, pa_groups, nin

  ::msg             := drgDialog:oMessageBar             // messageBar
  ::dm              := drgDialog:dataManager             // dataManager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form
  ::oEBro_pozemkitW := ::dc:oBrowse[1]
  *
*  ::msg:can_writeMessage := .f.
*  ::msg:msgStatus:paint  := { |aRect| ::info_in_msgStatus(aRect) }
  *
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
*      ::sta_activeBro := odrg
    endif
  next
  *
  isEditGET( { 'pozemkyW->npodVym_M2' , ;
               'pozemkyW->ncenaPoz'   , ;
               'pozemkyW->ndanNabPoz' , ;
               'pozemkyW->ncenaSDaNa'   }, drgDialog, .f. )

  ::sumColumn()

  if( ::lnewRec, ::is_pozemkyWOk := .f., ::df:setNextFocus( ::oEBro_pozemkitW ) )
return self


method HIM_pozemky_CRD:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  file  := drgParse(name,'-')
  *
  local  filter, cky
  local  sid := isNull( pozemkitW->sid, 0 ), lok := .t.

  * My
  * myší se snaží dostat na položky, je potøeba zkotrolovat hlavièku
  if ( file = ::it_file .and. sid = 0 .and. .not. ::is_pozemkyWOk )
    lok := ::postValidateForm(::hd_file)

    if( lok, (::restColor(), ::df:setNextFocus(::one_Edit,, .T. )), nil )
    ::is_pozemkyWOk := lok
  endif

  if( lok, ::olastOK_drg := drgVar:odrg, nil )

  if ( lok .and. file = ::it_file )
    do case
    case(name = ::it_file +'->ninvcis' .and. empty(value) )
      ::dm:set('pozemkitW->ninvCis'  , pozemkyW->ninvCis  )

    case( name = ::it_file +'->cpodil' .and. empty(value) )
      ::dm:set('pozemkitW->cnazPozem', c_pozem->cNazDruPoz)
      ::dm:set('pozemkitW->mpoznamka', c_listvl->cnazevlv )
    endCase

    _clearEventLoop()
  endif
return lok


METHOD HIM_pozemky_CRD:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  local  npos, n_Cit, n_Jmen, npodVym_m2
  local  o_podVym_M2, o_CenaPoz, o_DanNabPoz, o_CenaSDaNa
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  cf := "cku_Kod = '%%'", filter
  local  cinfo_podil := 'Promiòte prosím,'                                            +CRLF + ;
                        'vypoètený podíl výmìry je vìtší než celková výmìra pozemku,' +CRLF + ;
                        'provádím korekci podílu výmìry ...'
  *
  local  cinfo_m2    := 'Promiòte prosím,'                                             +CRLF + ;
                        'souèet podílù výmìry je vìtší než celková výmìra pozemku ...' +CRLF +CRLF
  *
  local  pa_podil := ::pa_podilVym, nin_pa_podil, csum_podil, nsum_Cit, nsum_Jmen, nsum_podVym_M2 := 0
  local  isAppend, n_sid
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)
  *
  if( ::df:in_postvalidateForm .and. (file = ::hd_file), file := '', nil )

  do case

  * kontroly na hlavièce pozemky
  case( file = ::hd_file )
    do case
    case( name = ::hd_file +'->ninvcis' )
      if value <> 0
        if .not. majSW->( dbSeek( value,,'MAJ02'))
          drgMsgBox(drgNLS:msg('Zadané inventární èíslo neexistuje !!!'), XBPMB_CRITICAL )
          ok := .f.
        endif
      endif
      ::dm:set( 'M->nazevMaj', majSW->cnazev )

    case( name = ::hd_file +'->cku_kod'    )
      (::hd_file)->cku_Nazev := c_katast->cku_Nazev

      filter := format(cf, {value} )
      c_listvl->( ads_setAof(filter), dbgoTop() )

    case( name = ::hd_file +'->nlistvlast' )
    case( name = ::hd_file +'->cparccis'   )
      if empty(value)
        drgMsgBox(drgNLS:msg('Èíslo parcely je povinný údaj !!!'), XBPMB_CRITICAL )
        ok := .f.
      endif
    case( name = ::hd_file +'->nvymera_m2' )
      if empty(value)
        drgMsgBox(drgNLS:msg('Výmìra pozemku je povinný údaj !!!'), XBPMB_CRITICAL )
        ok := .f.
      endif

    endcase

  * kontroly na položce pozemkyit
  case( file = ::it_file )
    o_podVym_M2 := ::dm:has( ::it_file +'->npodVym_M2' )
    o_CenaPoz   := ::dm:has( ::it_file +'->nCenaPoz'   )
    o_DanNabPoz := ::dm:has( ::it_file +'->nDanNabPoz' )
    o_CenaSDaNa := ::dm:has( ::it_file +'->nCenaSDaNa' )
    isAppend    := ( ::oEBro_pozemkitW:state = 2 .or. (::it_file)->(eof()))

    do case
    case( name = ::it_file +'->ninvcis' )
      if value <> 0
        if .not. majSW->( dbSeek( value,,'MAJ02'))
          drgMsgBox(drgNLS:msg('Zadané inventární èíslo neexistuje !!!'), XBPMB_CRITICAL )
          ok := .f.
        endif
      endif

    case( name = ::it_file +'->cpodil' )
      ** povinný údaj
      ** mùže být ve tvaru NN/NN nebo N,ale pak N musí být jen (1)
      ** vypoètený npodVym_M2 + suma(pozemkitW.npodVym_M2) <= nvymera_M2
      do case
      case empty(value)
        fin_info_box('Podíl výmìry je povinný údaj ...',XBPMB_CRITICAL )
        ok := .f.
      otherWise

        if ( npos := at( '/', value)) <> 0   // ve tvaru NN/NN
          n_Cit  := val( left  ( value, npos-1))
          n_Jmen := val( substr( value, npos+1))
        else
          n_Cit  := val( value )
          n_Jmen := 1
        endif

        if n_Cit / n_Jmen > 1
          fin_info_box('Podíl výmìry je vìtší než _1_ ...', XBPMB_CRITICAL )
          return .f.
        endif
        *
        **
        n_sid := if( isAppend, 0, pozemkitW->sid )
        if ( npos := ascan( pa_podil, { |ait| ait[1] = n_sid } )) = 0
          aadd( pa_podil, { n_sid, allTrim(value), -0 } )
          nin_pa_podil := len(pa_podil)
        else
          pa_podil[npos,2] := allTrim(value)
          nin_pa_podil     := npos
        endif

        csum_podil := if( len(pa_podil) = 1, pa_podil[1,2], ::sum_podil(pa_podil) )

        if ( npos := at( '/', csum_podil)) <> 0   // ve tvaru NN/NN
          nsum_Cit  := val( left  ( csum_podil, npos-1))
          nsum_Jmen := val( substr( csum_podil, npos+1))
        else
          nsum_Cit  := val( csum_podil )
          nsum_Jmen := 1
        endif

        if nsum_Cit / nsum_Jmen > 1
          fin_info_box('Celkový podíl výmìry je vìtší než _1_ ...', XBPMB_CRITICAL )
          return .f.
        endif
        **
        *
        npodVym_M2 := (pozemkyW->nvymera_M2 / n_Jmen) * n_Cit
        aeval( pa_podil, { |ait| nsum_podVym_m2 += if( ait[1] = n_sid, 0, ait[3] ) } )

        if round(nsum_podVym_m2 +npodVym_M2, 2) > pozemkyW->nvymera_M2
          fin_info_box( cinfo_podil )
          npodVym_M2 := pozemkyW->nvymera_M2 -nsum_podVym_M2
        endif

        pa_podil[nin_pa_podil, 3] := npodVym_M2
        ::dm:set( 'pozemkitW->npodVym_M2', npodVym_M2 )
      endCase

    case( name = ::it_file +'->npodVym_m2' )
      n_sid := if( isAppend, 0, pozemkitW->sid )
      aeval( pa_podil, { |ait| nsum_podVym_m2 += if( ait[1] = n_sid, 0, ait[3] ) } )

      if round(nsum_podVym_m2 +value, 2) > pozemkyW->nvymera_M2
        cinfo_m2 += '      ' +str( round(nsum_podVym_m2 +value, 2)) +'     > ' +str(pozemkyW->nvymera_M2)
        fin_info_box( cinfo_m2, XBPMB_CRITICAL )
        return .f.
      endif

    case( name = ::it_file +'->ndruhpozem' )
      c_pozem->( dbseek(value,, 'C_POZEM1' ))
      ::dm:set( 'pozemkitw->cnazPozem', c_pozem->cnazDruPoz )

    case( name = ::it_file +'->ncenapoz'   )
      o_CenaSDaNa:set( value +o_DanNabPoz:value )

    case( name = ::it_file +'->ndannabpoz' )     // ncenasdana asi nic
      o_CenaSDaNa:set( o_CenaPoz:value +value )

    endcase
  endcase

  * na pozemky ukládme vždy
  if('pozemkyw' $ name .and. ok, drgVAR:save(),nil)
RETURN ok


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
static function him_pozemky_cpy(oDialog)
  local  lnewRec := if( isNull(oDialog), .f., oDialog:lnewRec )

  ** tmp soubory **
  drgDBMS:open('POZEMKYw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('POZEMKITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  if lnewRec
    POZEMKYw->( dbappend())
  else
    mh_copyFld( 'POZEMKY', 'POZEMKYw', .t., .t. )
    POZEMKIT->( dbeval( { || mh_copyFld( 'POZEMKIT', 'POZEMKITw', .t., .t. ) } ))
  endif
return nil