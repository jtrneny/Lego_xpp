#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "Gra.ch"
#include "xbp.ch"

#include "drg.ch"
#include "DRGres.Ch'
//
#include "..\Asystem++\Asystem++.ch"

*
** pvpHead
*  class skl_typPoh_sel c_typPoh
********************************************************************************
CLASS SKL_typPoh_SEL FROM drgUsrClass
EXPORTED:
  METHOD  drgDialogStart, tabSelect, getFORM

  inline method init( parent)
    ::drgUsrClass:init(parent)
    *
    ::m_udcp    := parent:parent:udcp
    ::tabNum    := pvpHeadW ->ntypPvp
    ::typPohybu := pvpHeadW ->ctypPohybu
  return self

  inline access assign method is_stornoDok() var is_stornoDok
    return if( c_typPoh->nstornoDok = 1, 300, 0 )

  inline access assign method skl_karta() var skl_karta
    return val ( right( allTrim(c_typPoh->ctypDoklad), 3))


  inline method drgDialogInit(drgDialog)
*    drgDialog:dialog:drawingArea:bitmap  := 1016
*    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
    OTHERWISE
      RETURN  .F.
    ENDCASE
  return .t.

  inline method itemMarked()
    local typDoklad := allTrim(c_typPoh->ctypDoklad)
    local typPohybu := left(typDoklad,7)

    if ::oDBro:oxbp:currentState() = 1 .and. isMethod( ::m_udcp, 'sel_typPohybu')

      if .not. empty(c_typPoh->ctypPohybu)
        ::m_udcp:sel_typPohybu()
      else
        c_typPoh->( dbgoTop())
        ::oDBro:oxbp:refreshAll()
        ::oDBro:oseek:setData('')

        ::m_udcp:sel_typPohybu()
      endif
    endif
  return self

  inline method destroy()
    ::drgUsrClass:destroy()
    c_typPoh->( ads_clearAof())
  return self

HIDDEN:
  var     m_udcp
  VAR     tabNum, typPohybu
  var     df, tabPageManager, oDBro

  inline method setFilter( nPohyb)
    local Filter

    Do case
    Case nPohyb = 1     // pouze pøíjmové pohyby
      Filter := FORMAT( "Left( Right( Alltrim( cTypDoklad),3), 1) $ '%%' .and. cUloha = 'S'" , {'14'} )

    Case nPohyb = 2     // pouze výdajové pohyby
      Filter := FORMAT( "Left( Right( AllTrim( cTypDoklad),3), 1) = '%%'.and. cUloha = 'S' .and. left(ctypPohybu,1) > '1'" , {'2'} )

    Case nPohyb = 3     // pouze pøevodní pohyby
      Filter := FORMAT( "Left( Right( AllTrim( cTypDoklad),3), 1) = '%%'.and. cUloha = 'S' .and. left(ctypPohybu,1) > '5'" , {'3'} )

    EndCase

    * musíme vylouèit tyto pohyby SKL_VYD255
    filter += " .and. .not. ( ctypdoklad = 'SKL_STA100' .or. ctypDoklad = 'SKL_VYD255' .or. ctypDoklad = 'SKL_VYD283' .or. ctypDoklad = 'SKL_VYD299' )"

    c_typPoh->( ads_setAof( filter ), dbgoTop() )
  return .t.

ENDCLASS


METHOD SKL_TypPoh_SEL:drgDialogStart(drgDialog)
  Local oBro := ::drgDialog:dialogCtrl:oBrowse[1], oColumn, x, n

  ::df             := drgDialog:oForm                    // form
  ::tabPageManager := drgDialog:oForm:tabPageManager     // tabPageManager
  ::oDBro          := ::drgDialog:dialogCtrl:oBrowse[1]

  FOR n := 1 To len(::drgDialog:dialogCtrl:oBrowse) step 1
    oBro := ::drgDialog:dialogCtrl:oBrowse[n]
    FOR x := 1 TO oBro:oXbp:colcount
      ocolumn := oBro:oXbp:getColumn(x)
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := GraMakeRGBColor( {255, 255, 200} )
      ocolumn:configure()
    NEXT
    oBro:oXbp:refreshAll()
  NEXT
  *
  ::tabPageManager:showPage( ::TABnum, .t. )
*  ::tabSelect( , ::tabNUM)
RETURN self


METHOD SKL_TypPoh_SEL:tabSelect( tabPage, tabNumber)
  Local Filter

  ::tabNUM := tabNumber
  ::setFilter( ::tabNUM)
  *
  ::df:olastdrg   := ::oDBro
  ::df:olastdrg:setFocus()
  SetAppFocus( ::oDBro:oxbp)

  if .not. c_typPoh->( dbseek( ::typPohybu,,'C_TYPPOH09'))
    c_typPoh->(dbgoTop())
  endif

  ::oDBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::oDBro:oxbp)
RETURN .T.


method SKL_typpoh_SEL:getForm()
  Local  oDrg, drgFC

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 57,17 DTYPE '10' TITLE 'Výbìr pohybu ..... ' ;
                                           GUILOOK 'All:N,Border:Y'

  DRGTEXT INTO drgFC CAPTION 'Vyber typ požadovaného dokladu ... ' CPOS 0,16 CLEN 57 PP 2 BGND 15

  DRGTABPAGE INTO drgFC CAPTION 'Pøíjem' OFFSET  1,82 SIZE 57,1.2 PRE 'tabSelect'
    DRGPUSHBUTTON INTO drgFC POS 0,0 SIZE 0,0
  DRGEND INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Výdej'  OFFSET 16,68 SIZE 57,1.2 PRE 'tabSelect'
    DRGPUSHBUTTON INTO drgFC POS 0,0 SIZE 0,0
  DRGEND INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Pøevod' OFFSET 31,53 SIZE 57,1.2 PRE 'tabSelect'
    DRGPUSHBUTTON INTO drgFC POS 0,0 SIZE 0,0
  DRGEND INTO drgFC

  DRGDBROWSE INTO drgFC  SIZE 57,14.8 FPOS 0,1.2 FILE 'C_TypPOH' INDEXORD 7 ;
             FIELDS 'cTypDoklad:typDokl,'        + ;
                    'cTypPohybu:pohyb:7,'        + ;
                    'M->skl_karta:karta:4,'      + ;
                    'M->is_stornoDok:st:2.6::2,' + ;
                    'cNazTypPoh:název pohybu:31'   ;
             SCROLL 'ny' CURSORMODE 3 PP 7 ITEMMARKED 'itemMarked' POPUPMENU 'yy'

RETURN drgFC




*
*  class skl_vyrZakit_sel   vyrZakit
*                                        skl_pohybyit(prg):skl_vyrZakit_sel (m)
********************************************************************************
CLASS SKL_vyrZakit_SEL FROM drgUsrClass
EXPORTED:
  VAR     lDataFilter, mainBro

  * struktura pole
  * { recno()  ,curr_curr_mnozDokl1/pocPol, curr_mnozPrDod/pocPol,
  *             curr_celkItem/pocPol      , curr_celkDokl/pocPol , ccisZakazi }
  var     pa_mnozDokl1

  method init, getForm, drgDialogInit, drgDialogStart

  *
  ** bro column_1 - bude/ nebude  pøenesena do položek dokladu
  inline access assign method vyrZakitw_isOk() var vyrZakitw_isOk
    local  recNo := vyrZakitw->( recNo())
    if isObject( ::d_Bro)
      pa := ::d_Bro:arSelect

      return if( ascan( pa, recNo) <> 0 .or. ::d_Bro:is_selAllRec, 6001, 0)
    endif
    return 0

  ** bro column_4 - rozpoèítané množství nmnozDokl1 do položky dokladu
  inline access assign method mnozDokl1() var mnozDokl1
    local  npos, recNo := vyrZakitw->( recNo())
    local  pa_mnoz := ::pa_mnozDokl1

    if ( npos := ascan( pa_mnoz, { |x| x[1] = recNo })) <> 0
      return pa_mnoz[ npos,2]
    endif
    return 0

  ** bro column_5 - rozpoèítané množství nmnozPrDod do položky dokladu
  inline access assign method mnozPrDod() var mnozPrDod
    local  npos, recNo := vyrZakitw->( recNo())
    local  pa_mnoz := ::pa_mnozDokl1

    if ( npos := ascan( pa_mnoz, { |x| x[1] = recNo })) <> 0
      return pa_mnoz[ npos,3]
    endif
    return 0


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    if ::d_Bro:is_selAllRec <> ::is_selAllRec
      ::is_selAllRec := ::d_Bro:is_selAllRec

      ::post_bro_colourCode(::is_selAllRec)
    endif

    DO CASE
    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      ::recordSelected()

    CASE nEvent = drgEVENT_APPEND
*      ::recordEdit()

    CASE nEvent = drgEVENT_FORMDRAWN
       Return .T.

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

  inline method post_bro_colourCode(is_selAllRec)
    local  npos, recNo := vyrZakitw->(recNo())
    local  pa_sel         := ::arSelect
    local  pa_mnoz        := ::pa_mnozDokl1
    local  curr_mnozDokl1 := ::curr_mnozDokl1
    local  curr_mnozPrDod := ::curr_mnozPrDod
    local  curr_celkItem  := ::curr_celkItem
    local  curr_celkDokl  := ::curr_celkDokl

    if isLogical(is_selAllRec)
      do case
      case is_selAllRec
        pa_mnoz := ::pa_mnozDokl1 := {}
        vyrZakitW->( dbeval( { || aadd(pa_mnoz, { vyrZakitw->( recNo()), 0, 0, 0, 0, vyrZakitw->ccisZakazi }) } ), ;
                     dbgoTo( recNo)                                                                                )

      otherwise
        pa_mnoz := ::pa_mnozDokl1 := {}

      endcase
    else
      npos := ascan( pa_mnoz, { |x| x[1] = recNo } )

      do case
      case npos  = 0        // oznaèil položku pro rozpad množství
        aadd( pa_mnoz, { recNo, 0, 0, 0, 0, vyrZakitw->ccisZakazi } )
      case npos <> 0        // zrušil rozpad množství
        ARemove( pa_mnoz, npos )
      endcase
    endif

    aeval( pa_mnoz, { |x| ( x[2] := curr_mnozDokl1/ len(pa_mnoz), ;
                            x[3] := curr_mnozPrDod/ len(pa_mnoz), ;
                            x[4] := curr_celkItem / len(pa_mnoz), ;
                            x[5] := curr_celkDokl / len(pa_mnoz)  ) } )
    ::sumColumn()
    ::d_Bro:oxbp:refreshAll()
    setAppFocus(::d_Bro:oxbp)
    return 1

  inline method mark_doklad()
    postAppEvent( xbeP_Keyboard, xbeK_CTRL_ENTER,,::d_bro:oXbp)
    return self

  inline method save_marked()
    postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    return self

HIDDEN:
  VAR     in_file, d_Bro, arSelect, pb_mark_doklad, pb_save_marked
  *
  ** tohle získáme z parenta
  var     curr_mnozDokl1, curr_mjDokl1, curr_mnozPrDod, curr_celkItem, curr_celkDokl
  var     is_selAllRec
  **
  *
  var     m_dm, drgGet

  * suma
  inline method sumColumn()
    local  mnozDok1  := mnozPrDod := 0
    local  sumCol
    local  pa_column := { ::d_Bro:getColumn_byName('M->mnozDokl1'), ::d_Bro:getColumn_byName('M->mnozPrDod') }
    local  pa_mnoz   := ::pa_mnozDokl1

    aeval( pa_mnoz, { |x| ( mnozDok1 += x[2], mnozPrDod += x[3] ) })

    for x := 1 to len( pa_column) step 1
      sumCol := pa_column[x]

      sumCol:Footing:hide()
      sumCol:Footing:setCell(1, transForm( if( x = 1, mnozDok1, mnozPrDod), '999999999.9999'))
      sumCol:Footing:show()
    next

    if( mnozDok1 <> 0, ::pb_save_marked:enable(), ::pb_save_marked:disable() )
  return self


  inline method RecordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    return self
ENDCLASS


method skl_vyrZakit_sel:init(parent)
  local  nEvent := mp1 := mp2 := oXbp := nil
  local  m_dm
  *
  local  chFilter := "ccisZakaz = '%%' .and. (.not. lzavren .or. isnull(lzavren))", cfilter

  ::drgUsrClass:init(parent)

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, nil )

  ::m_dm           := parent:parent:dataManager
  ::curr_mnozDokl1 := ::m_dm:get('pvpitemww->nmnozDokl1')
  ::curr_mjDokl1   := ::m_dm:get('pvpitemww->cmjDokl1'  )
  ::curr_mnozPrDod := ::m_dm:get('pvpitemww->nmnozPrDod')
  ::curr_celkItem  := ::m_dm:get('M->ncelkItem'         )
  ::curr_celkDokl  := ::m_dm:get('M->ncelkDokl'         )

  ::pa_mnozDokl1   := aclone( parent:parent:udcp:pa_mnozDokl1 )
return self


method skl_vyrZakit_sel:getForm()
  local  oDrg, drgFC
  local  cHead := allTrim(vyrZak->ccisZakaz) +' ... ' +allTrim(vyrZak->cnazevZak1) + ;
                  '   množSpotøeby => ' +allTrim( str(::curr_mnozDokl1)) +' ' +::curr_mjDokl1

  local  cFoot := '[ ' +allTrim(cenZboz->ccisSklad) +'/'    ;
                       +allTrim(cenZboz->csklPol)   +' ] _' ;
                       +allTrim(cenZboz->cnazZbo)   +       ;
                       '   k dispozici '            +       ;
                       str(cenZboz->nmnozDZbo)      +       ;
                       ' ' +cenZboz->cZkratJedn

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 87,15.2 DTYPE '10' TITLE 'Výdej na položky zakázky ...' ;
                                             GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 87,13 FILE 'vyrZakitw'     ;
    FIELDS 'M->vyrZakitw_isOk::2.7::2,'                          + ;
           'ccisZakazi:výrÈíslo:20,'                             + ;
           'cnazevZak1:název zakázky:31,'                        + ;
           'M->mnozDokl1:množSpoø:15:999999999.9999,'            + ;
           'M->mnozPrDod:množSpoø_pøep:15:999999999.9999'          ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y' FOOTER 'y'

  DRGTEXT       INTO drgFC CAPTION cFoot CPOS 0,14 CLEN 87 FONT 2 BGND 12 CTYPE 1

  DRGSTATIC INTO drgFC FPOS 0.2,0.1 SIZE 119.6,1.2 STYPE 1 RESIZE 'nn'
    DRGTEXT       INTO drgFC CAPTION cHead CPOS 0,0 CLEN 81 FONT 5 BGND 12 CTYPE 1

    DRGPUSHBUTTON INTO drgFC POS 81,0 SIZE 3,1.1 ATYPE 1                 ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...' ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK

    DRGPUSHBUTTON INTO drgFC POS 84,0 SIZE 3,1.1 ATYPE 1                       ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...' ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS

  DRGEND INTO drgFC
return drgFC


method skl_vyrZakit_sel:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

**  XbpDialog:titleBar := .F.
  drgDialog:dialog:drawingArea:bitmap  := 1016 // 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  ENDIF
return self


method skl_vyrZakit_sel:drgDialogStart( drgDialog )
  local  x, members := drgDialog:oForm:aMembers, odrg
  local  pa_mnoz    := ::pa_mnozDokl1, npos

  ::d_Bro        := drgDialog:dialogCtrl:obrowse[1]
  ::is_selAllRec := ::d_Bro:is_selAllRec := ( len(pa_mnoz) = vyrZakitw->( recCount()) )
  ::arSelect     := ::d_Bro:arSelect

  if .not. ::is_selAllRec
    for x := 1 to len (pa_mnoz) step 1 ; aadd( ::arSelect, pa_mnoz[x,1] ) ;  next
  endif

  for x := 1 to len(members) step 1
    odrg := members[x]

    do case
    case  odrg:ClassName() = 'drgPushButton'
      do case
      case odrg:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
      case odrg:event = 'save_marked'    ;  ::pb_save_marked := members[x]
      endcase

    case odrg:ClassName() = 'drgText'
      odrg:oxbp:setcolorbg( GraMakeRGBColor( {196, 196, 255} ))

    endcase
  next

  ::sumColumn()
return self

*
*  class skl_pvpitem_sel   pvpitem
*                          sel - pro storno položky dokladu
********************************************************************************
CLASS SKL_pvpitem_SEL FROM drgUsrClass
EXPORTED:

  inline method init( parent )

    ::drgUsrClass:init(parent)

    drgDBMS:open( 'pvpitem',,,,,'pvpitem_ss')
  return self

endClass


*
** CLASS for SKL_msDim_pk_SEL ************************************************
** cskladKAM, csklPolKAM        - Pøevod_Kam
*
CLASS SKL_msDim_pk_SEL FROM drgUsrClass
EXPORTED:
  var nazevDIm
  var cisSklad , nazSklad , sklPol   , nazZbo
  var klicSKmis, klicODmis, invCISdim, mnozPRdod
  var nazPol1  , nazPol2  , nazPol3  , nazPol4  , nazPol5, nazPol6

  *
  ** body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_FORMDRAWN
       Return .T.
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
  return .t.


  inline method init(parent)
    local o_incCISdim

    ::drgUsrClass:init(parent)
    drgDBMS:open( 'c_sklady',,,,, 'c_sklady_p' )
    drgDBMS:open( 'elNarDim')
    drgDBMS:open( 'zmenyDim')
    drgDBMS:open( 'c_typHod')

    ::m_udcp        := parent:parent:udcp:hd_udcp
    ::m_dm          := ::m_udcp:dataManager

    ::nazevDIm      := if( parent:cargo <> 0, msDim->cnazevDIm, ::m_dm:get('pvpitemWW->cnazZbo') )

     c_sklady_p->( dbseek( upper( pvpheadW->ccisSklad),,'C_SKLAD1') )
    ::cisSklad      := ::m_dm:get('pvpheadW->ccisSklad'  )
    ::nazSklad      := c_sklady_p->cnazSklad
    ::sklPol        := ::m_dm:get('pvpitemWW->csklPol'   )
    ::nazZbo        := ::m_dm:get('pvpitemWW->cnazZbo'   )

    ::klicSKmis     := ::m_dm:get('pvpitemWW->cklicSKmis')
    ::klicODmis     := ::m_dm:get('pvpitemWW->cklicODmis')

    o_invCISdim     := ::m_dm:has('pvpitemWW->ninvCISdim')
    ::invCISdim     := o_invCISdim:odrg:oxbp:value
    ::mnozPRdod     := ::m_dm:get('pvpitemWW->nmnozPRdod')

    * NS
    ::nazPol1       := ::m_dm:get('pvpitemWW->cnazPol1'  )
    ::nazPol2       := ::m_dm:get('pvpitemWW->cnazPol2'  )
    ::nazPol3       := ::m_dm:get('pvpitemWW->cnazPol3'  )
    ::nazPol4       := ::m_dm:get('pvpitemWW->cnazPol4'  )
    ::nazPol5       := ::m_dm:get('pvpitemWW->cnazPol5'  )
    ::nazPol6       := ::m_dm:get('pvpitemWW->cnazPol6'  )

    ::pa_itemsNew   := { { '...->cklicSKmis', ::klicSKmis                      }, ;
                         { '...->cklicODmis', ::klicODmis                      }, ;
                         { '...->ntypDim'   , 1                                }, ;
                         { '...->ninvCISdim', ::invCISdim                      }, ;
                         { '...->cnazevDim' , cenZboz->cnazZbo                 }, ;
                         { '...->ddatZARdim', date()                           }, ;
                         { '...->npocKUSdim', ::mnozPRdod                      }, ;
                         { '...->czkratJedn', cenZboz->czkratJedn              }, ;
                         { '...->ncisloPvp' , pvpheadW->ndoklad                }, ;
                         { '...->ncenJEDdim', cenZboz->ncenaSzbo               }, ;
                         { '...->ncenCELdim', cenZboz->ncenaSzbo * ::mnozPRdod }, ;
                         { '...->cnazPol1'  , ::nazPol1                        }, ;
                         { '...->cnazPol2'  , ::nazPol2                        }, ;
                         { '...->cnazPol3'  , ::nazPol3                        }, ;
                         { '...->cnazPol4'  , ::nazPol4                        }, ;
                         { '...->cnazPol5'  , ::nazPol5                        }, ;
                         { '...->cnazPol6'  , ::nazPol6                        }  }
  return self


  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oForm:aMembers
    local  x, odrg, groups, name, tipText
    *
    local  acolors  := MIS_COLORS, pa_groups, nin

    ::dm         := drgDialog:dataManager             // dataManager
    ::df         := drgDialog:oForm                   // form

    ::odBro      := ::drgDialog:odBrowse[1]
    ::oxbp_Brow  := ::odBro:oxbp
//    ::o_skladKAM := ::dm:has( 'M->skladKAM' )

    for x := 1 to len(members) step 1
      odrg    := members[x]
      groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
      groups  := allTrim(groups)
      name    := if( ismemberVar(members[x],'name'    ), isnull(members[x]:name   ,''), '')
      tipText := if( ismemberVar(members[x],'tipText' ), isnull(members[x]:tipText,''), '')
      *
      *
      if odrg:className() = 'drgText' .and. .not. empty(groups)
        pa_groups := ListAsArray(groups)

        * XBPSTATIC_TYPE_RAISEDBOX           12
        * XBPSTATIC_TYPE_RECESSEDBOX         13

        if pa_groups[1] = 'SKL_PRE_MAIN'
          ::odrg_SKL_PRE_MAIN := odrg
          odrg:oxbp:disable()
        endif

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
            odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN) // GRA_CLR_BLUE)
          endif
        endif
      endif

      if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
        odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
      endif

      if odrg:className() = 'drgPushButton'
        do case
        case odrg:event = 'skl_msDim_pk_autoNew'  ;  ::obtn_autoNew := odrg
        case odrg:event = 'skl_msDim_pk_editNew'  ;  ::obtn_editNew := odrg
        endcase
      endif
    next

    if drgDialog:cargo <> 0
      msDim->( dbgoTo( drgDialog:cargo ))
      ::is_msDim_kam( .t.)
    else
      msDim->( dbgoTop())
    endif

    ::df:setNextFocus( ::odBro )
  return self


  inline method skl_msDim_pk_autoNew()
    local  o_dim_msDim_crd, o_dm, o_udcp
    local  nexit, lok := .f.
    *
    local  x, pa := aclone(::pa_itemsNew), cc, drgVar

    o_dim_msDim_crd := drgDialog():new('DIM_msdim_CRD', ::drgDialog)
    o_dim_msDim_crd:create(,,.T.)

    o_udcp  := o_dim_msDim_crd:udcp
    o_dm    := o_dim_msDim_crd:dataManager

    for x := 1 to len(pa) step 1
      cc   := strTran( pa[x,1], '...', 'msDim' )
      drgVar := o_dm:has(cc)

      drgVar:set( pa[x,2] )
      ( drgvar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )
    next

    elNarDim->( dbseek( ::invCISdim,, 'DIM1' ))
    o_dm:refreshAndSetEmpty( 'elNarDim' )

    o_dim_msDim_crd:udcp:onSave( .t., .t., o_dim_msDim_crd )
    o_dim_msDim_crd := nil
    _clearEventLoop(.t.)

    ::oxbp_Brow:refreshAll()

    setAppFocus(::oxbp_Brow)
    postAppEvent(drgEVENT_EDIT,,, ::oxbp_Brow)
  return self


  inline method skl_msDim_pk_editNew()
    local  o_dim_msDim_crd, o_dm, o_udcp
    local  nexit, lok := .f.
    *
    local  x, pa := aclone(::pa_itemsNew), cc, drgVar

    o_dim_msDim_crd := drgDialog():new('DIM_msdim_CRD', ::drgDialog)
    o_dim_msDim_crd:create(,,.T.)

    o_udcp  := o_dim_msDim_crd:udcp
    o_dm    := o_dim_msDim_crd:dataManager

    for x := 1 to len(pa) step 1
      cc   := strTran( pa[x,1], '...', 'msDim' )
      drgVar := o_dm:has(cc)

      drgVar:set( pa[x,2] )
      ( drgvar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )
    next

    elNarDim->( dbseek( ::invCISdim,, 'DIM1' ))
    o_dm:refreshAndSetEmpty( 'elNarDim' )

    o_dm:refresh()
    o_dim_msDim_crd:quickShow(.t.)
    o_dim_msDim_crd := nil
    _clearEventLoop(.t.)

    ::oxbp_Brow:refreshAll()

    if msDim->( dbseek( ::invCISdim,,'DIM1'))
      postAppEvent(drgEVENT_EDIT,,, ::oxbp_Brow)
    endif
  return self

HIDDEN:
  var     m_udcp, m_dm
  var     dc, dm, df, ab, odBro, oxbp_Brow
  var     pa_itemsNew
  var     odrg_SKL_PRE_MAIN
  var     obtn_autoNew, obtn_editNew

  * položka DIMu exituje/ nexituje
  inline method is_msDim_kam(lis_msDim)
    if lis_msDim
      ::odrg_SKL_PRE_MAIN:oxbp:setCaption( '... inventární èíslo DIMu existuje v evidenci na jiném skup/odp místì ...' )
      ::obtn_autoNew:oxbp:disable()
      ::obtn_editNew:oxbp:disable()
    else
      ::odrg_SKL_PRE_MAIN:oxbp:setCaption( '... inventární èíslo DIMu neexistuje v evidenci ...' )
      ::obtn_autoNew:oxbp:enable()
      ::obtn_editNew:oxbp:enable()
    endif
  return self

ENDCLASS