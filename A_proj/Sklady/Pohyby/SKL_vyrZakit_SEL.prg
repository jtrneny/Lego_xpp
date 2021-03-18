#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"


*
** CLASS FOR SKL_vyrZakit_SEL **************************************************
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