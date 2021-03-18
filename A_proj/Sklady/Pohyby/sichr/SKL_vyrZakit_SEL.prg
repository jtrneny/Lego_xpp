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

  method init, getForm, drgDialogInit, drgDialogStart

  *
  ** bro column_1 - základní položka
  inline access assign method vyrZakitw_isMain() var vyrZakitw_isMain
    local  recNo   := vyrZakitw->( recNo())
    local  pa_mnoz := ::pa_mnozDokl1, npos

    if ( npos := ascan( pa_mnoz, { |x| x[1] = recNo })) <> 0
      if pa_mnoz[npos,3]
        return MIS_ICON_OK
      endif
    endif
    return 0

  ** bro column_2 - bude/ nebude  pøenesena do položek dokladu
  inline access assign method vyrZakitw_isOk() var vyrZakitw_isOk
    local  recNo := vyrZakitw->( recNo())
    if isObject( ::d_Bro)
      pa := ::d_Bro:arSelect

***     if( len(pa) = 0, aadd( pa, ::curr_vyrZakitw), nil )
      return if( ascan( pa, recNo) <> 0 .or. ::d_Bro:is_selAllRec, 6001, 0)
    endif
    return 0

  ** bro column_5 - rozpoèítané množství do položky dokladu
  inline access assign method mnozDokl1() var mnozDokl1
    local  npos, recNo := vyrZakitw->( recNo())
    local  pa_mnoz := ::pa_mnozDokl1

    if ( npos := ascan( pa_mnoz, { |x| x[1] = recNo })) <> 0
      return pa_mnoz[ npos,2]
    endif
    return 0


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    if ::d_Bro:is_selAllRec <> ::is_selAllRec
      ::is_selAllRec := ::d_Bro:is_selAllRec

      if( .not. ::is_selAllRec, aadd( ::d_Bro:arSelect, ::curr_vyrZakitw), nil )
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
    local  curr_vyrZakitw := ::curr_vyrZakitw

    if isLogical(is_selAllRec)
      do case
      case is_selAllRec
        pa_mnoz := ::pa_mnozDokl1 := {}
*        aadd( pa_mnoz, { ::curr_vyrZakitw, 0, .t. } )

        vyrZakitW->( dbeval( { || aadd(pa_mnoz, { vyrZakitw->( recNo()), 0, .f. }) }, ;
                             { || vyrZakitW->( recNo()) <> curr_vyrZakitw          } ), ;
                     dbgoTo( recNo)                                                     )
      otherwise
        pa_mnoz := ::pa_mnozDokl1 := {}
        aadd( pa_mnoz, { ::curr_vyrZakitw, ::curr_mnozDokl1, .t. } )
      endcase
    else
      if ::vyrZakitw_isMain = 0
        npos := ascan( pa_mnoz, { |x| x[1] = recNo } )

        do case
        case npos  = 0        // oznaèil položku pro rozpad množství
          aadd( pa_mnoz, { recNo, 0, .f. } )
        case npos <> 0        // zrušil rozpad množství
          ARemove( pa_mnoz, npos )
        endcase
      endif
    endif

    aeval( pa_mnoz, { |x| x[2] := curr_mnozDokl1/ len(pa_mnoz) })
    ::sumColumn()
    ::d_Bro:oxbp:refreshAll()

    return if( vyrZakitw->(recNo()) = ::curr_vyrZakitw, 0, 1 )

  inline method mark_doklad()
    postAppEvent( xbeP_Keyboard, xbeK_CTRL_ENTER,,::d_bro:oXbp)
    return self

  inline method save_marked()
    postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    return self

HIDDEN:
  VAR     in_file, d_Bro, arSelect, pb_mark_doklad, pb_save_marked
  var     curr_vyrZakitw, curr_mnozDokl1
  var     pa_mnozDokl1
  var     is_selAllRec
  var     m_dm, drgGet

  * suma
  inline method sumColumn()
    local  mnozDok1 := 0
    local  sumCol   := ::d_Bro:getColumn_byName('M->mnozDokl1')
    local  pa_mnoz  := ::pa_mnozDokl1

    aeval( pa_mnoz, { |x| mnozDok1 += x[2] })

    sumCol:Footing:hide()
    sumCol:Footing:setCell(1, transForm(mnozDok1, '999999999.9999'))
    sumCol:Footing:show()
  return self


  inline method RecordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    return self
ENDCLASS


method skl_vyrZakit_sel:init(parent)
  local  nEvent := mp1 := mp2 := oXbp := nil
  local  m_dm
  *
  local  cisZakaz, cnazPol3
  local  chFilter := "ccisZakaz = '%%' .and. (.not. lzavren .or. isnull(lzavren))", cfilter

  ::drgUsrClass:init(parent)

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, nil )
****

  ::m_dm           := parent:parent:dataManager

  ::curr_mnozDokl1 := ::m_dm:get('pvpitemww->nmnozDokl1')   // TT - pak se musí vzít z parenta
  ::pa_mnozDokl1   := {}
  cnazPol3         := ::m_dm:get('pvpitemww->cnazPol3'  )   // TT - pak se musí vzít z parenta - budou zadávat vrcholovou zakázku

  drgDBMS:open('vyrZak'  )
  drgDBMS:open('vyrZakit')

** TT **
  drgDBMS:open('cnazPol3')
  drgDBMS:open('cenZboz' )

  cnazPol3->( dbseek( cnazPol3,,'CNAZPOL1'))
  drgDBMS:open( 'vyrZakitw',.T.,.T.,drgINI:dir_USERfitm) ; vyrZakitw->( dbZAP())
** TT **

  vyrZak  ->( dbseek( cnazPol3->ccisZakaz,,'VYRZAK1'))   // ccisZakaz
  vyrZakit->( dbseek( cnazPol3->cnazPol3 ,,'ZAKIT_4'))   // ccisZakazi

  cfilter   := format( chFilter, { cnazPol3->ccisZakaz })

  vyrZakitw->( dbzap())
  vyrZakit ->( ads_setAof( cfilter), dbgotop())

  do while .not. vyrZakit->( eof())
    mh_copyFld( 'vyrZakit', 'vyrZakitw', .t. )
*    if vyrZakitW->ccisZakazI = cnazPol3
*      ::curr_vyrZakitw := vyrZakitW->( recNo())
*      aadd( ::pa_mnozDokl1, { ::curr_vyrZakitw, ::curr_mnozDokl1, .t. } )
*    endif

    vyrZakit->( dbskip())
  enddo

  vyrZakit->( ads_clearAof())
return self


method skl_vyrZakit_sel:getForm()
  local  oDrg, drgFC
  local  cHead := allTrim(vyrZak->ccisZakaz) +' ... ' +allTrim(vyrZak->cnazevZak1)
  local  cFoot := '[ ' +allTrim(cenZboz->ccisSklad) +'/'    ;
                       +allTrim(cenZboz->csklPol)   +' ] _' ;
                       +allTrim(cenZboz->cnazZbo)   +       ;
                       '   k dispozici '            +       ;
                       str(cenZboz->nmnozDZbo)      +       ;
                       ' ' +cenZboz->cZkratJedn

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 75,15.2 DTYPE '10' TITLE 'Výdej na položky zakázky ...' ;
                                             GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 75,13 FILE 'vyrZakitw'     ;
    FIELDS 'M->vyrZakitw_isMain::2.7::2,'                        + ;
           'M->vyrZakitw_isOk::2.7::2,'                          + ;
           'ccisZakazi:výrÈíslo:20,'                             + ;
           'cnazevZak1:název zakázky:31,'                        + ;
           'M->mnozDokl1:množSpoø:15:999999999.9999'               ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y' FOOTER 'y'

  DRGTEXT       INTO drgFC CAPTION cFoot CPOS 0,14 CLEN 75 FONT 2 BGND 12 CTYPE 1

  DRGSTATIC INTO drgFC FPOS 0.2,0.1 SIZE 119.6,1.2 STYPE 1 RESIZE 'nn'
    DRGTEXT       INTO drgFC CAPTION cHead CPOS 0,0 CLEN 68 FONT 5 BGND 12 CTYPE 1

    DRGPUSHBUTTON INTO drgFC POS 68.5,0 SIZE 3,1.1 ATYPE 1               ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...' ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK

    DRGPUSHBUTTON INTO drgFC POS 71.5,0 SIZE 3,1.1 ATYPE 1                     ;
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
  ::is_selAllRec := ::d_Bro:is_selAllRec
  ::arSelect     := ::d_Bro:arSelect

  aadd( ::arSelect, ::curr_vyrZakitw )

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
*    ::pb_save_marked:disable()
return self