#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Appedit.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

/*
fakprihd
  ::typ_lik := 'ucd'
  ::typ_zz  := 'zav'

 inline access assign method is_danDokUsed() var is_danDokUsed
    local  cKy := upper(fakprihd->cdenik) +strZero(fakprihd->ncisFak,10) +strZero(ucetdohd->ndoklad)
    return if( ucetdohd->ndoklad <> 0 .and. vykdph_i->(dbSeek(cKy,,'VYKDPH_6')), MIS_NO_RUN, 0)


fakvyshd
  ::typ_lik := 'ucd'
  ::typ_zz  := 'poh'

 inline access assign method is_danDokUsed() var is_danDokUsed
   local  cKy := upper(fakvyshd->cdenik) +strZero(fakvyshd->ncisFak,10) +strZero(ucetdohd->ndoklad)
   return if( ucetdohd->ndoklad <> 0 .and. vykdph_i->(dbSeek(cKy,,'VYKDPH_6')), MIS_NO_RUN, 0)

*/


*
** CLASS for FIN_dphkohhd_SCR **************************************************
CLASS FIN_dphKohHd_SCR FROM drgUsrClass
EXPORTED:
  method  init, destroy, drgDialogStart, comboBoxInit, comboItemSelected
  method  tabSelect, itemMarked
  *
  ** RUN METHOD
  method  dph_Insert, dph_Delete, dph_Edit
  var     nrok, nobdobi
  *
  ** pro daòové doklady fakprihd/fakvyshd (zz)
  var     typ_lik, typ_zz, is_danDokUsed

  *
  ** dphKohHd
  inline access assign method isruc_Oprava() var isruc_Oprava
    return if( dphKohHd->lrucOprava, 555, 0 )     // 558 - èervená

  *
  ** dphKohit
  inline access assign method isedit_Parent() var isedit_Parent
    return if( dphKohit->ndoklad <> 0, MIS_EDIT, 0 )

  **
  ** EVENT *********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs, cfiltr

    do case
    case(nevent = drgEVENT_OBDOBICHANGED)
      ::setSysFilter()
      return .t.

    case nEvent = xbeBRW_ItemMarked
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)

      if( dphKohit->ndoklad <> 0, ::obtn_koh_vykDph_in:oxbp:enable(), ::obtn_koh_vykDph_in:oxbp:disable() )
      return .f.

    CASE nEvent = drgEVENT_APPEND
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT
      if( dphKohit->ndoklad <> 0, ::edit_Parent(), nil )
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      RETURN .T.

    CASE nEvent = drgEVENT_SAVE
       RETURN .T.

    CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

  *
  ** oprava oddílu kontrolního hlášení ve vykDph_i
  inline method koh_vykDph_in(drgDialog)
    local  odialog, nexit
    *
    local  hd_file
    local  cdenik    := dphKohit->cdenik
    local  npos, cclass
    local  pa_Parent := ::pa_Parent

    if ( npos := ascan(pa_parent, { |x| x[1] = cdenik }) ) <> 0
      ::openFiles( pa_parent[npos,3] )

      hd_file := pa_parent[npos,3,1]

      if (hd_file)->( dbseek( dphKohit->nSIDmain,,'ID'))

        ::typ_lik := if( cdenik = 'D', 'zav', ;
                       if( cdenik = 'O', 'poh', ;
                         if( cdenik = 'V' .or. cdenik = 'VO' .or. cdenik = 'VD', 'ucd', ;
                           if( cdenik = 'P', 'pok', '' ) ) ) )

        odialog       := drgDialog():new('fin_koh_vykDph_in', ::drgDialog)
        odialog:create(,,.T.)
      endif
    endif
  return self


HIDDEN:
  var   brow, msg, dm, dc, df, ab, showDialog
  var   obtn_dph_Delete, obtn_dph_Edit, obtn_koh_vykDph_in
  var   coddil
  var   o_drgTabs, pa_Parent


  inline method openFiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(x)                                                                        , ;
         if(isnull(ordno), nil, (file)->(AdsSetOrder(ordno)))                                     })
    return nil


  inline method setSysFilter( ini )
    local rok, obdobi
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    rok    := uctOBDOBI:FIN:NROK
    obdobi := uctOBDOBI:FIN:NOBDOBI
    cfiltr := Format("nROK = %% .and. nOBDOBI = %%", {rok,obdobi} )

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'dphKohHd')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('dphKohHd', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'dphKohHd')

      dphKohHd->( ads_setaof(filtrs), dbGoTop())
      ::brow:oxbp:refreshAll()
      ::itemMarked()
    endif
  return self

  *
  ** oprava primárního dokladu
  inline method edit_Parent()
    local  oDialog, nExit

    local  hd_file
    local  cdenik    := dphKohit->cdenik
    local  npos, cclass
    local  pa_Parent := ::pa_Parent

    if ( npos := ascan(pa_parent, { |x| x[1] = cdenik }) ) <> 0
      ::openFiles( pa_parent[npos,3] )

      hd_file := pa_parent[npos,3,1]

      if (hd_file)->( dbseek( dphKohit->nSIDmain,,'ID'))
        cclass  := pa_parent[npos,2]

        if .not. ::is_danDoklad(pa_Parent[npos])
          return self
        endif

        oDialog := drgDialog():new( cClass, ::drgDialog)
        oDialog:cargo := drgEVENT_EDIT
        oDialog:create(,,.T.)

        oDialog:destroy(.T.)
        oDialog := NIL
      endif
    endif
  return self

  inline method is_danDoklad(pa_itParent)
    local  lok     := .t.
    local  hd_file := pa_itParent[3,1]
    local  hd_file_zz, c_tag_zz, cky

    if len(pa_itParent) = 4
      hd_file_zz := pa_itParent[3,3]
        c_tag_zz := pa_itParent[4]
             cky := upper((hd_file)->cdenik_Par) +strZero((hd_file)->ncisFak, 10)

      if (hd_file_zz)->( dbseek( cky,, c_tag_zz))
        ::typ_lik := 'ucd'
        ::typ_zz  := if( hd_file_zz = 'fakPrihd', 'zav', 'poh' )

        cky += strZero((hd_file)->ndoklad)
        ::is_danDokUsed := if( vykdph_i->(dbSeek(cky,,'VYKDPH_6')), MIS_NO_RUN, 0)
      else
        lok := .f.
      endif
    endif
  return lok

ENDCLASS


METHOD FIN_dphKohHd_SCR:init(parent)
  local  cfiltr

  ::drgUsrClass:init(parent)

  ::nrok       := uctOBDOBI:FIN:NROK
  ::nobdobi    := uctOBDOBI:FIN:NOBDOBI

  ::coddil     := 'A.1'
  ::showDialog := .t.

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

  drgDBMS:open( 'UCETSYS' )
  drgDBMS:open( 'vykDph_i')

  * programový filtr
  * ::setSysFilter(.t.)
RETURN self


METHOD FIN_dphKohHD_SCR:destroy()
  ::drgUsrClass:destroy()

  ::nrok        := NIL

  if(select('dphKohHd') <> 0, dphKohHd ->(Ads_ClearAOF()), nil)
RETURN


METHOD FIN_dphKohHd_SCR:comboBoxInit(drgComboBox)
  LOCAL  nIn
  LOCAL  aROK_zpr   := {}
  LOCAL  aCOMBO_val := {}

  FOrdRec({'UCETSYS,3'})
  UCETSYS ->( DbSetScope( SCOPE_BOTH, 'F'), ;
              DbGoTop()                   , ;
              DbEval( { || If( aSCAN(aCOMBO_val, { |X| X[1] == UCETSYS ->nROK }) == 0, ;
                               AAdd( aCOMBO_val,{ UCETSYS ->NROK, 'ROK _ ' +STRZERO( UCETSYS ->nROK,4) }), ;
                               NIL ) }, { || ucetsys->nrok > 2010 }) )
  FOrdRec()

  * není založené období
  if len(aCOMBO_val) = 0
    aadd(aCOMBO_val, { 0, '' })
    ::showDialog := .f.
  endif

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] < aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  drgComboBox:value := ::nrok
RETURN SELF


METHOD FIN_dphKohHd_SCR:drgDialogStart(drgDialog)
  local x, caption
  *
  local members   := drgDialog:oForm:aMembers
  local obmp_edit := XbpBitMap():new():create()

  ::brow      := drgDialog:dialogCtrl:oBrowse[1]
  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::dm        := drgDialog:dataManager             // dataMananager
  ::df        := drgDialog:oForm                   // form
  ::ab        := drgDialog:oActionBar:members      // actionBar

  ::o_drgTabs := ::df:tabPageManager:members


  dphKohHd ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

  if .not. ::showDialog
    ConfirmBox( ,'Je mì líto, ale nelze spustil tuto nabídku, nejsou splnìny podmínky pro zpracování ...', ;
                 'Nelze zpracovat požadavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  else
    ::brow:oXbp:refreshAll()
  endif

  for x := 1 to len(::o_drgTabs) step 1
    caption := ::o_drgTabs[x]:oxbp:caption
    caption := subStr( caption, at(':', caption) +1 )

    ::o_drgTabs[x]:oxbp:setCaption(caption)
    *
    ** poslední záložka je editaèní - EBro
    if x = len(::o_drgTabs)
       obmp_edit:load( ,315)
       obmp_edit:TransparentClr := obmp_edit:GetDefaultBGColor()

       ::o_drgTabs[x]:oxbp:setImage(obmp_edit)
    endif
  next

  for x := 1 to len(::ab) step 1
    do case
    case ::ab[x]:event = 'dph_Delete'    ;  ::obtn_dph_Delete    := ::ab[x]
    case ::ab[x]:event = 'dph_Edit'      ;  ::obtn_dph_Edit      := ::ab[x]
    case ::ab[x]:event = 'koh_vykDph_in' ;  ::obtn_koh_vykDph_in := ::ab[x]
    endcase
  next

RETURN ::showDialog


METHOD FIN_dphKohHd_SCR:comboItemSelected(mp1, mp2, o)
  Local  dc := ::drgDialog:dialogCtrl

  IF ::nrok <> mp1:value
    ::nrok := mp1:value
    dphKohHd ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

    dc:oaBrowse:refresh(.T.)
    ::drgDialog:dataManager:refresh()

    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD FIN_dphKohHd_SCR:tabSelect(oTabPage,tabnum)

  ::coddil := otabPage:subs
  ::itemMarked()
return .t.


METHOD FIN_dphKohHd_SCR:itemMarked()
  local  sid        := isNull(dphKohhd->sid, 0)
  local  cky        := dphKohHd->cidHlaseni +::coddil
  local  pa_oBrowse := ::dc:oBrowse

  if( sid = 0, ::obtn_dph_Delete:oxbp:disable(), ::obtn_dph_Delete:oxbp:enable() )
  if( sid = 0, ::obtn_dph_Edit:oxbp:disable()  , ::obtn_dph_Edit:oxbp:enable() )

  dphKohit->( dbsetScope(SCOPE_BOTH, cky), dbgoTop())
  aeval( pa_oBrowse, { |o| o:oxbp:refreshAll() }, 2 )

  if( dphKohit->ndoklad <> 0, ::obtn_koh_vykDph_in:oxbp:enable(), ::obtn_koh_vykDph_in:oxbp:disable() )
return self


*
** RUN METHOD
METHOD FIN_dphKohHd_SCR:dph_Insert()
  LOCAL  oDialog, nExit
  local  pa_oBrowse := ::dc:oBrowse

  DRGDIALOG FORM 'FIN_dphKohHD_INS' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::dc:refreshPostDel()
  ::coddil := 'A.1'
  ::itemMarked()
RETURN (nExit != drgEVENT_QUIT)


method FIN_dphkohhd_SCR:dph_Delete()
  local  sid, nsel, nodel := .f.
  local  pa_oBrowse := ::dc:oBrowse
  *
  local  cStatement, oStatement
  local  stmt     := "delete from %file where %c_sid = %sid"
  local  pa_files := { { 'dphKohHd', 'sid' }, { 'dphKohIt', 'ndphKohlHd' } }, x

  if ( sid := dphKohHd->sid ) <> 0

    nsel := ConfirmBox( ,'Požadujete zrušit Kontrolní hlášení o DPH _' +allTrim(dphKohHd->cidHlaseni) +'_' +CRLF +CRLF, ;
                         'Zrušení kontrolního hlášení ...' , ;
                          XBPMB_YESNO                      , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel <> XBPMB_RET_YES
      return .t.
    endif

    for x := 1 to len(pa_files) step 1
      cStatement := strTran( stmt      , '%file' , pa_files[x,1]    )
      cStatement := strTran( cStatement, '%c_sid', pa_files[x,2]    )
      cStatement := strTran( cStatement, '%sid'  , allTrim(str(sid)))

      oStatement := AdsStatement():New(cStatement, oSession_data)

      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
      endif

      oStatement:Close()

      (pa_files[x,1])->(dbUnlock(), dbCommit())
    next

    dphKohhd->(dbskip())

    ::dc:refreshPostDel()
    ::coddil := ''
    ::itemMarked()
  endif
return self


method fin_dphkohhd_scr:dph_Edit()
  LOCAL  oDialog, nExit
  local  pa_oBrowse := ::dc:oBrowse

  odialog := drgDialog():new( 'FIN_dphkohhd_IN', ::drgDialog)
  odialog:cargo := drgEVENT_EDIT

  odialog:create(,,.T.)

  ::dc:refreshPostDel()
  ::coddil := 'A.1'
  ::itemMarked()
return self


**
** CLASS for FIN_dphKohHd_EDT **************************************************
CLASS FIN_dphKohHd_EDT FROM drgUsrClass
EXPORTED:

 method  init, destroy  // , drgDialogStart

 inline access assign method isedit_Parent() var isedit_Parent
   return if( dphKoh_iW->ndoklad <> 0, MIS_EDIT, 0 )

HIDDEN:

  var     msg, dm
ENDCLASS


METHOD FIN_dphKohHd_EDT:init(parent)
  local  cky        := dphKohHd->cidHlaseni

  ::drgUsrClass:init(parent)

  * STATIC
*  pa_oddilRadek := { {'A.1', 1 }, {'A.2', 1 }, {'A.3', 1 }, {'A.4', 1 }, {'A.5', 1 }, {'A5i', 1 }, ;
*                     {'B.1', 1 }, {'B.2', 1 }, {'B.3', 1 }, {'B3i', 1 }                            }

  * SYS
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('C_VYKDPH')

  * DATA
  drgDBMS:open('VYKDPH_I')
  drgDBMS:open('FIRMY'   )

  * TMP
  drgDBMS:open('dphKoh_hW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  mh_copyFld('dphKohhd', 'dphKoh_hW', .t. )

  drgDBMS:open('dphKoh_iW',.T.,.T.,drgINI:dir_USERfitm); ZAP
    dphKohit->( dbsetScope(SCOPE_BOTH, cky), ;
                dbgoTop()                  , ;
                dbeval( { || mh_copyFld('dphKohit', 'dphKoh_iW', .t. ) } ) )
    dphKoh_iW->( dbgoTop())
RETURN self


METHOD FIN_dphKohHd_EDT:destroy()
  ::drgUsrClass:destroy()

RETURN