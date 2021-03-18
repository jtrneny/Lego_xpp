#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dmlb.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for PRO_objhead_SCR **************************************************
CLASS PRO_objhead_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked, postDelete

  * fakturace objednáky
  method  objhead_to_fakvyshd_in

  * new - možnost opravy dokladu z pro_objitem_scr
  var     isparent_mainScr


  inline method pro_objhead_vykr()
    local cfile := lower( ::dc:oaBrowse:cfile)

    do case
    case cfile = 'objhead'  ;  ::pro_objhead_vykr_hd()
    case cfile = 'objitem'  ;  ::pro_objhead_vykr_it()
    endcase
    return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

  * komunikace objhead
  inline access assign method stav_komunik() var stav_komunik
    local retVal := 0
    local stav_komu := objhead->nstav_komu

    do case
    case( stav_komu = 1 )  ;  retVal := 516  // <-
    case( stav_komu = 2 )  ;  retVal := 515  // ->
    case( stav_komu = 5 )  ;  retVal := 601  // MIS_UNDO
    endcase
    return retVal

  * objhead
  inline access assign method stav_objhead() var stav_objhead
    local retVal := 0
    local doklad := strZero(objhead->ndoklad,10)
    *
    local s_0    := objit_sth->(dbseek(doklad +'0'))
    local s_1    := objit_sth->(dbseek(doklad +'1'))
    local s_2    := objit_sth->(dbseek(doklad +'2'))

    do case
    case( .not. s_1 .and. .not. s_2)            ;  retVal := 0
    case( .not. s_0 .and. .not. s_1) .and. s_2  ;  retVal := 302 // MIS_BOOK
    otherwise                                   ;  retVal := 303 // MIS_BOOKOPEN
    endcase
    return retVal

  * objitem
  inline access assign method stav_fakt() var stav_fakt
    local retVal := 0
    local stav_fakt := objitem->nstav_fakt

    do case
    case( stav_fakt = 1 )  ;  retVal := 303
    case( stav_fakt = 2 )  ;  retVal := 302
    otherWise
      if upper(objitem->cpolCen) = 'C'
        cenZboz->( dbSeek( upper(objitem->ccisSklad) +upper(objitem->csklPol),, 'CENIK03'))
        retVal := if( cenZboz->nmnozDzbo >= objitem->nmnozOBodb, 0, 301 )
      endif
    endcase
    return retVal


  inline access assign method stav_Svyd() var stav_Svyd
    local retVal := 0
    local stav_Svyd := objitem->nstav_Svyd

    do case
    case( stav_Svyd = 1 )                     ;  retVal := 555  // m_Zluta.bmp
    case( stav_Svyd = 2 .or. stav_Svyd = 3 )  ;  retVal := 556  // m_Zelena.bmp
    endcase
    return retVal

  * fakvysit
  inline access assign method stav_fakvysit() var stav_fakvysit
    local retVal := 0

    if fakvyshd->(dbseek(fakvysit->ncisfak,,'FODBHD1'))
      do case
      case(fakvyshd->nuhrcelfak = 0                    )  ;  retVal := 301    // MIS_ICON_ERR
      case(fakvyshd->nuhrcelfak >= fakvyshd->ncenzakcel)  ;  retVal := H_big
      case(fakvyshd->nuhrcelfak <  fakvyshd->ncenzakcel)  ;  retVal := H_low
      endcase
    endif
    return retVal

  inline access assign method datvys_fakvysit() var datvys_fakvysit

    fakvyshd->(dbseek(fakvysit->ncisfak,,'FODBHD1'))
    return fakvyshd->dvystFak

  * objzak
  inline access assign method stav_objzak_naz() var stav_objzak_naz
    vyrzak->(dbseek(upper(objzak->cciszakaz),,'VYRZAK1'))
    return vyrzak->cnazevzak1

  inline access assign method stav_objzak_plm() var stav_objzak_plm
    return vyrzak->nmnozplano

HIDDEN:
  var  dc, dm, ab
  var  oDBro_main
  var  tabnum, brow, obtn_objhead_to

  method  pro_objhead_vykr_hd, pro_objhead_vykr_it
  method  pro_objhead_new_kom

ENDCLASS


method PRO_objhead_SCR:init(parent)
  local  pa_initParam
  local  filter := "nextObj = 1", cfilter

  ::drgUsrClass:init(parent)
  *
  ::tabnum           := 1
  ::lnewRec          := .f.
  ::isparent_mainScr := .t.
  *
  drgDBMS:open('objhead' )
  drgDBMS:open('objitem' )

  drgDBMS:open('objitem',,,,,'objit_sth')   // pro stav na objhead
  objit_sth->(AdsSetOrder('OBJITE24'))

  drgDBMS:open('cenzboz' )
  drgDBMS:open('fakvyshd')
  drgDBMS:open('fakvysit')
  drgDBMS:open('dodsltit')
  drgDBMS:open('objzak'  )
  drgDBMS:open('vyrzak'  )
  drgDBMS:open('c_staty' )
  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    cfilter := '(' +filter + ' .and. ' +pa_initParam[2] +')'
  else
    cfilter := filter
  endif

  ::drgDialog:set_prg_filter( cfilter, 'objhead')
return self


method PRO_objhead_SCR:drgDialogStart(drgDialog)
  local  odesc, x
  local  pa_it := {}, pa_quick := {{ 'Kompletní seznam       ', ''                 } }

  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::dm         := drgDialog:dataManager             // dataManager
  ::ab         := drgDialog:oActionBar:members      // actionBar

  ::brow       := drgDialog:dialogCtrl:oBrowse
  ::oDBro_main := ::brow[1]

  for x := 1 to len(::ab) step 1
    do case
    case ::ab[x]:event = 'objhead_to_fakvyshd_in'  ; ::obtn_objhead_to := ::ab[x]
    endcase
  next

  * quick stav dokladu
  if isObject( odesc := drgRef:getRef( 'nstav_objp' ))
    pa := listAsArray( odesc:values )

    aeval( pa, {|x| ( pb := listAsArray(x, ':'), aadd( pa_it, {allTrim(pb[1]) +' ', pb[2]} ) ) } )
  endif
  aeval( pa_it, { |x| aadd( pa_quick, { x[2], format( 'nstav_objp = %%', {val(x[1])} ) } ) })
  ::quickFiltrs:init( self, pa_quick, 'stav_objedn' )

return


method PRO_objhead_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
return .t.


method PRO_objhead_SCR:itemMarked()
  local  mky     := upper(objhead->ccislobint)
  local  msth_Ky := strZero(objhead->ndoklad,10)
  *
  local  ev, x, ok := (::stav_objhead <> 302)
  local  doklad := strZero(objhead->ndoklad,10), isOk := .t., nBeg
  *
  objitem ->( ordSetFocus('OBJITEM2'), dbsetScope( SCOPE_BOTH, mky), DbGoTop())
  fakvysit->( ordSetFocus('FVYSIT2') , dbsetScope( SCOPE_BOTH, mky), DbGoTop())
  dodlstit->( ordSetFocus('DODLIT2') , dbsetScope( SCOPE_BOTH, mky), DbGoTop())
  objzak  ->( ordSetFocus('OBJZAK1') , dbsetScope( SCOPE_BOTH, mky), DbGoTop())


  for x := 1 to len(::ab) step 1
    ev := lower( isNull( ::ab[x]:event, ''))

    if ev $ 'pro_objhead_vykr,objhead_to_fakvyshd_in,pro_objhead_new_kom'
      do case
      case ( ev = 'pro_objhead_vykr' )
        if(ok, ::ab[x]:oxbp:enable(), ::ab[x]:oxbp:disable())

      case ( ev = 'objhead_to_fakvyshd_in' )
        if(ok, ::ab[x]:oxbp:enable(), ::ab[x]:oxbp:disable())

      case ( ev = 'pro_objhead_new_kom' )
        if(::stav_komunik = 2, ::ab[x]:oxbp:enable(), ::ab[x]:oxbp:disable())

      endcase
    endif
  next

  // Ok snad jde pustit do faktury, ale musí splnit další podmínky
  if (::stav_objhead = 0)
    objit_sth->( dbsetScope( SCOPE_BOTH, msth_Ky), DbGoTop() )
    objit_sth->( dbeval( { || ( cenZboz->( dbSeek( upper(objit_sth->ccisSklad) +upper(objit_sth->csklPol),, 'CENIK03')), ;
                                isOk := isOk .and. ( objit_sth->nmnozOBodb <> 0 .and. ;
                                                     objit_sth->nstav_Fakt =  0 .and. ;
                                                     objit_sth->nstav_Svyd =  0 .and. ;
                                                     if( upper(objit_sth->cpolCen) = 'C', cenZboz->nmnozDzbo >= objit_sth->nmnozOBodb, .t. ) ) ) } ) )
    objit_sth->( dbClearScope() )
    if( isOk, ::oBtn_objhead_to:oxbp:enable(), ::oBtn_objhead_to:oxbp:disable() )
  endif


*  (sub[::tabnum])->(AdsSetOrder(ord[::tabnum]),dbsetscope(SCOPE_BOTH,mky),dbgotop())
  ::brow[::tabnum +1]:oxbp:refreshAll()
return self


method PRO_objhead_SCR:postDelete()
  local  nsel, nodel := .f.

  if objhead->ndoklad <> 0
    nsel := ConfirmBox( ,'Požadujete zrušit objednávku pøijatou _' +objhead->ccislObInt +'_', ;
                         'Zrušení objednávky pøijaté ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      pro_objhead_cpy(self)
      nodel := .not. pro_objhead_del(self)
      *
      objheadw->(dbclosearea())
       objitemw->(dbclosearea())
        objit_iw->(dbclosearea())
    else
      nodel := .f.
    endif
  endif

  if nodel
    ConfirmBox( ,'Objednávku pøijatou _' +objhead->ccislObInt +'_' +' nelze zrušit ...', ;
                 'Zrušení objednávky vystavené ...' , ;
                 XBPMB_CANCEL                       , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
**  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return .not. nodel


method  PRO_objhead_SCR:pro_objhead_vykr_hd()
  local  cMess := 'Promiòte prosím, ' +CRLF
  local  cTitl := 'Vykrytí objednávky '
  local  nsel
  *
  local  arSelect := ::oDBro_main:arSelect
  local  lsel     := ( len( ::oDBro_main:arSelect) <> 0 )
  local  cdoklad  := '', x
  *
  local cStatement, oStatement
  local stmt := "update objItem set nmnozPLodb = nmnozOBodb, " + ;
                                   "nmnoz_fakt = nmnozOBodb, " + ;
                                   "nstav_fakt = 2,"           + ;
                                   "nmnoz_fakv = nmnozOBodb, " + ;
                                   "nstav_fakv = 2,"           + ;
                                   "ddatRvykr  = curdate(), "  + ;
                                   "nmnoz_Svyd = nmnozOBodb, " + ;
                                   "nstav_Svyd = 2 "           + ;
                        "where ndoklad in ( %cdoklad );"       + ;
                "update objHead set nmnozPLodb = nmnozOBodb, " + ;
                                   "ddatRvykr  = curdate() "   + ;
                        "where ndoklad in ( %cdoklad );"

  cMess += 'požadujete ruèní vykrytí ' +if( lsel, 'objednávek ', 'objednávky') +CRLF

   nsel := ConfirmBox( ,cMess +chr(13) +chr(10), ;
                         cTitl                  , ;
                         XBPMB_YESNO            , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

  if nsel = XBPMB_RET_YES

    do case
    case len( arSelect) <> 0
      fordRec( {'objHead' } )

      for x := 1 to len( arSelect) step 1
        objHead->( dbgoTo( arSelect[x]))
        cdoklad += strTran( str(objHead->ndoklad), ' ', '') +','
      next
      fordRec()
      cdoklad := left( cdoklad, len( cdoklad) -1)

    otherwise
      cdoklad := strTran( str(objHead->ndoklad), ' ', '')
    endcase

    cStatement := strTran( stmt, '%cdoklad', cdoklad )
    oStatement := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
*      return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif

    if lsel
      ::oDBro_main:arSelect := {}
      ::oDBro_main:oxbp:refreshAll()
    else
      ::oDBro_main:oxbp:refreshCurrent()
    endif

    ::itemMarked()
  endif
return


method  PRO_objhead_SCR:pro_objhead_vykr_it()
  local  nazFirmy  := left( objhead->cnazev,25)
  local  nazZbo    := left( objitem->cnazZbo,25)
  local  mnozOBodb := strTran( str(objitem->nmnozOBodb),' ', '')
  *
  local  nsel

  if objhead->(sx_rLock()) .and. objitem->( sx_rLock())
    nsel := confirmBox(, 'Dobrý den p. ' +logOsoba +CRLF +                                    ;
                         'opravdu požadujete provést vykrytí položky objednávky ...' +CRLF + ;
                         '     pro          ...   ' +nazFirmy                        +CRLF + ;
                         '     zboží       ...   ' +nazZbo                           +CRLF + ;
                         '     množství ...   '   +mnozOBodb                               , ;
                         'Vykrytí položky objednávky ...'                                  , ;
                         XBPMB_YESNO                                                       , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)


    if nsel = XBPMB_RET_YES
      objitem->nmnozPLodb := objitem->nmnozOBodb
      objitem->nmnoz_fakt := objitem->nmnozOBodb
      objitem->nstav_fakt := 2
      objitem->nmnoz_fakv := objitem->nmnozOBodb
      objitem->nstav_fakv := 2
      objitem->ddatRvykr  := date()

      objitem->nmnoz_Svyd := objitem->nmnozPlOdb
      objitem->nstav_Svyd := 2

      objhead->nmnozPLodb += objitem->nmnozOBodb
      if( objhead->nmnozOBodb = objhead->nmnozPLodb, objhead->ddatRvykr := date(), nil )

      ::brow[2]:oxbp:refreshCurrent()
      ::oDBro_main:oxbp:refreshCurrent()

      ::itemMarked()
    endif

    objhead->(dbunlock(), dbcommit())
    objitem->(dbunlock(), dbcommit())
  endif
return self


method  PRO_objhead_SCR:pro_objhead_new_kom()
  local  nsel

  if objhead->(sx_rLock()) .and. objitem->( sx_rLock())
    nsel := confirmBox(, 'Dobrý den p. ' +logOsoba +CRLF +                                    ;
                         'opravdu požadujete znovu odeslat objednávky ...' +CRLF +            ;
                         'Nové odeslání celé objednávky ...'                                  , ;
                         XBPMB_YESNO                                                       , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)


    if nsel = XBPMB_RET_YES
      objhead->nStav_Komu := 5
 //     if( objhead->nmnozOBodb = objhead->nmnozPLodb, objhead->ddatRvykr := date(), nil )

      ::brow[2]:oxbp:refreshCurrent()
      ::oDBro_main:oxbp:refreshCurrent()

      ::itemMarked()
    endif

    objhead->(dbunlock(), dbcommit())
    objitem->(dbunlock(), dbcommit())
  endif
return self


method PRO_objhead_SCR:objhead_to_fakvyshd_in(drgDialog)
  local  o_fin_fakVyshd_in, o_udcp, o_dm
  local  iz_file := 'objitem', hd_file, it_file
  local  fak_cisFirmy, fak_cislOBint, fak_faktMnoz
  local  pa_Recs := {}, x, file_name

  local  last_Cargo := drgDialog:cargo
  local  inEdit     := If( IsNull(drgDialog:cargo), .F., .T.)
  *
  local  mky := upper(objhead->ccislobint)


  * asi by se mìlo zjistit jestli už existuje FA
  ::lNEWrec   := .t.
  ::drgDialog := ::dm:drgDialog

  o_fin_fakVyshd_in := drgDialog():new('FIN_fakVyshd_IN',drgDialog)
  o_fin_fakVyshd_in:cargo_Usr := 'EXT_FAK'
  o_fin_fakVyshd_in:create( ,, .t. )

  o_udcp  := o_fin_fakVyshd_in:udcp
  hd_file := o_udcp:hd_file
  it_file := o_udcp:it_file
  o_udcp:lnewrec := .t.
  **
  *
  file_name := (it_file) ->( DBInfo(DBO_FILENAME))
               (it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name,  it_file , .t., .f.)   ; (it_file)->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'fakvysi_w', .t., .t.) ; fakvysi_w  ->(AdsSetOrder(1))
  *
  ** hlavièka, musíme vynut uložení jak zmìnu
  fak_cisFirmy         := o_udcp:dm:has(hd_file +'->ncisFirmy')
  fak_cisFirmy:value   := objhead->ncisFirmy
  o_udcp:df:olastDrg   := fak_cisFirmy:odrg

  o_udcp:fin_firmy_sel()
  *
  ** položky
  fak_cislOBint := o_udcp:dm:has(it_file +'->ccislOBint')
  fak_faktMnoz  := o_udcp:dm:has(it_file +'->nfaktMnoz')

*  objitem->( AdsSetOrder('OBJITEM2'),dbsetscope(SCOPE_BOTH,upper(objhead->ccislobint) ),dbgotop())
  objitem->( dbeval( { || aadd( pa_Recs, objitem->( recNo()) ) } ) )

  for x := 1 to len(pa_Recs) step 1
    objitem->( dbgoTo( pa_Recs[x]) )
    *
    ** vot problema, po uložení položky získá focus BRO,
    ** pak blbne s vyèítáním položek initValue a value pøestaví ...
    *
    setAppFocus( fak_cislOBint:odrg:oxbp )

    o_udcp:takeValue(it_file, iz_file, 4, o_udcp )
    o_udcp:postValidate(fak_faktMnoz)

    o_udcp:wds_watch_mnoz( .t., x )
    o_udcp:postLastField()
  next
  *
  ** trošku doplníme hlavièku
  fakvyshdW->nkonstSymb := 8
  fakVyshdW->czkrZPUdop := objhead->czkrZPUdop
  fakVyshdW->czkrtypuhr := objhead->czkrtypuhr
  *
  ** je potøeba pøezobrazit typ položek, jinak to zblbne
  fakVyshdW->( dbcommit())
  fakVysitW->( dbcommit(), dbgoTop())

  o_udcp:brow:goTop():refreshAll()
  o_udcp:showGroup()
  _clearEventLoop(.t.)


*  setAppFocus(o_udcp:brow)
***  o_udcp:refresh('fakvysitW',, o_udcp:dm:vars)
*  PostAppEvent(xbeBRW_ItemMarked,,,o_udcp:brow)

  * kráva jedna chce pøidávat položku z jiné objednávky pro stejnou firmu
  objitem->( dbClearScope() )

  o_fin_fakVyshd_in:quickShow(.t.,.t.)
  o_udcp:wds_disconnect()

  * kráva jedna chce pøidávat položku z jiné objednávky pro stejnou firmu
  objitem ->( ordSetFocus('OBJITEM2'), dbsetScope( SCOPE_BOTH, mky), DbGoTop() )

  if( select('fakvyshdw') <> 0, fakvyshdw->(dbclosearea()), nil )
  if( select('fakvysitw') <> 0, fakvysitw->(dbclosearea()), nil )
  if( select('fakvysi_w') <> 0, fakvysi_w->(dbclosearea()), nil )
  *
  if( select('dodlsthdw') <> 0, dodlsthdw->(dbclosearea()), nil )
  if( select('dodlstitw') <> 0, dodlstitw->(dbclosearea()), nil )

  ::drgDialog:dialogCtrl:refreshPostDel()

*  if  .not. inedit
*    PostAppEvent(xbeBRW_ItemMarked,,,drgDialog:dialogCtrl:oaBrowse:oXbp)
*  endif
return self