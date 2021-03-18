////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  FIN_main_.PRG                                                             //
//                                                                            //
//  Copyright:                                                                //
//                                                                            //
//  Contents:                                                                 //
//  Implementation of MAIN_key  -> FIN_main_KEY for FINANCE                   //
//                                                                            //
//  Remarks:                                                                  //
//  MAIN_INF     ->  FIN_main_INF                                             //
//  mRANGE_key   ->  FIN_range_KEY                                            //
//  mRANGE_usr   ->  FIN_range_USR (s)                                        //
//  VLD_OBDUc    ->  FIN_VLDOBDUC                                             //
//  VLD_OBDFa    ->  FIN_VLDOBDDA                                             //
//  MAIN_cmdph   ->  FIN_CMDPH     (c)                                        //
//  MAIN_FLTS    ->  FIN_main_FLTS                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "Font.ch"
#include "appevent.ch"
#include "drg.ch"
#include "gra.ch"

#include "class.ch"
//
#include "DRGres.Ch'
#include "..\FINANCE\FIN_finance.ch"

/*
  XBP_TIPDEFAULT *)    Default tip window for displaying uncategorized text
  XBP_TIPINFO          Tip window for displaying informational text, contains information icon
  XBP_TIPWARNING       Tip window for displaying warning messages, contains warning icon
  XBP_TIPERROR         Tip window for displaying error messages, contains error icon
  XBP_TIPINFOLARGE     Same as XBP_TIPINFO, but contains larger icon

  XBP_TIPWARNINGLARGE  Same as XBP_TIPWARNING, but contains larger icon
  XBP_TIPERRORLARGE
*/


*
**
procedure fin_info_box(cMsg,iconType)
  local  o_xbp := setAppFocus(), cTitle, ntype
  *
  local  nEvent := mp1 := mp2 := oXbp := nil

  default iconType to XBPMB_WARNING

  nEvent := LastAppEvent( @mp1,@mp2,@oXbp)

  do case
  case(iconType = XBPMB_WARNING)
    ( cTitle := drgNLS:msg("Warning!"), Tone(500,3))
  case(iconType = XBPMB_CRITICAL)
    (cTitle := drgNLS:msg("Error!")   , Tone(150,3))
  otherwise
    (cTitle := drgNLS:msg("Message!") , Tone(500,3))
  endcase

  cMsg := strTran(cMsg,';',CRLF)

*  if o_xbp:className() = 'XbpGet' .and. IsThemeActive(.T.) = .T.
*    ntype := if( iconType = XBPMB_WARNING, XBP_TIPWARNING, ;
*              if( iconType = XBPMB_CRITICAL, XBP_TIPERROR, XBP_TIPINFO ))
*
*    o_xbp:showBalloonTip( nType, cTitle, cMsg )
*  else
    ConfirmBox( , cMsg , cTitle, XBPMB_OK , iconType + XBPMB_APPMODAL + XBPMB_MOVEABLE )
*  endif

  _clearEventLoop(.t.)

*-  SetAppFocus(oXbp)
return


* klasika - klíè - kontrola na duplicitu
*                        x
*                        x      x               x
* dodací listy pøijaté
*                        x                               x
function fin_range_key(cFILE, nKEYm, lALT_dwn, msg, lis_prijDok)
  local  nposIn, nIn, nTAGm, nSTART, nKONEC, cfile_W
  local  cKy, cD, cS, cK, s_filter, r_filter, m_filter, nlast
  local  lDONE := .T., lNEWs := .T., lLOCKs := .T., lSPECs := .F.
  local  pSA
  local  psDEr, axDEr := _FIN_range
  local  typCisRad := SYSCONFIG('SKLADY:NTYPCISRAD')
  *
  local  ldoklad_Exists := .f., recCnt := 0
  local  cInfo          := 'Promiòte prosím,' +CRLF,ckeym
  *
  local  nevent := mp1 := mp2 := oxbp := nil
  local  nkey_inLoop, pa_doklad

  default lALT_dwn    to .f. , ;
          lis_prijDok to .f.

  *-  drgEVENT_APPEND   --- klasika INS
  *-  drgEVENT_SAVE     --- uložení dokladu + NOVÝ v cyklu
  nevent  := LastAppEvent(@mp1,@mp2,@oxbp)


  if(select('fin_range') <> 0, fin_range->(dbclosearea()), nil)

  nposIn := ascan ( axDEr, { |X| upper(X[1]) == upper(cFILE) } )
  psDEr  := aclone( axDEr[nposIn] )

  if(nIn := at(':', cFILE)) <> 0
    (cFILE := left(cFILE, nIn -1), lSPECs := .T. )
  EndIf

  nTAGm   := psDEr.TAGm
  nSTART  := DBGetVal( psDEr.CFGm)[ 1]
  nKONEC  := DBGetVal( psDEr.CFGm)[ 2]
  cfile_W := psDEr.FILEw

  drgDBMS:open(cfile,,,,,'fin_range')
  fin_range->(AdsSetOrder(ntagm))

  do case
  case lSPECs
    cd       := upper(DBGetVal(psDEr.DENIKr))
    s_filter := format("(cdenik = '%%')",{cd})

  case len(psDEr) = 10
    s_filter := psDEr.KEYp

  case len(psDEr) = 11
    cd       := DBGetVal(psDEr.DENIKr)
    s_filter := format(psDEr.KEYex,{cd})
  endcase

  do case
  case lower(cfile) = 'pvphead'
    if     typCisRad = 1 .or. typCisRad = 3               //--èíselné øady v rámci celé firmy
      pa_doklad := fin_range_pvpFir(lis_prijDok, typCisRad)
    elseif typCisRad = 2                                  //--èíselné øady v rámci skladù
      pa_doklad := fin_range_skl(lis_prijDok)
    endif

    nkeyM := pa_doklad[1]
    ( (cfile_W)->nrange_beg := pa_doklad[2], (cfile_W)->nrange_end := pa_doklad[3] )

    fin_range->(dbclosearea())
    return( {lDONe, val( str(nKEYm, 10)) } )

  otherwise

    r_filter := format(psDEr.KEYm +' >= %% .and. ' +psDEr.KEYm +' <= %%',{nstart,nkonec})
    m_filter := if( isNull(s_filter), r_filter, s_filter +' .and. (' +r_filter +')')

    fin_range->(ads_setAof(m_filter), dbgotop())

    if isNumber(nkeym)
      ldoklad_Exists := fin_range->(dbseek(nkeym))
    endif

  endCase


  do case
  case lALT_dwn                                           //--nabídka dìr v dokladech

  case( lower(cFile) = 'pvphead' .and. typCisRad = 2)     //--èíselné øady v rámci skladù

  case IsNIL(nKEYm) .or. IsCHARACTER(nKEYm)               //--návrh klíèe
    if(ischaracter(nkeym),nil,fin_range->(dbgobottom()))
    nkeym := fin_range->(sx_keydata()) +1
    *
    ** klíè ve smyèce poøízení dokladu
/*
    if nevent = drgEVENT_SAVE
      nkey_inLoop := DBGetVal(cfile +'->' +psDEr.KEYm) +1

      do while fin_range->(dbseek(nkey_inLoop))
        nkey_inLoop++
      enddo

      * nenanašel požadovaný klíè a je v rozsahu nstart ... nkonec
      if ( fin_range->(eof()) .and. (nkey_inLoop >= nstart) .and. (nkey_inLoop <= nkonec) )
        return({.t., val(str(nkey_inLoop,10)) })
      endif
    endif
*/

    *
    ** divná klasika kontroly
    do case
    case(nkeym < nstart)
      if fin_range->(eof())
        nKEYm := nStart
      else
        nKEYm := nstart
        do while fin_range->(dbseek(nkeym))
          nKEYm++
        enddo
      endif
    endcase

/*
    *
    ** tady to musím ještì zkotrolovat stejnì jak pøi kontrole duplicity
    fin_range->( ads_clearAOF())

    ckeym := allTrim(str(nkeym))

    if ldoklad_Exists
      * duplicitní èíslo dokladu
      ldone  := .f.
      cInfo  += 'doklad èíslo ( ' +ckeym +' ) v souboru <' ;
                 +psDEr.TEXTm + '> již existuje ...'
    endif

    if .not. ( nkeym >= nstart.and. nkeym <= nkonec )
      * poøizuje doklad mimo èíselnou øadu
      ldone := .f.
      cInfo += if( ldoklad_Exists, CRLF, '' ) + ;
               'Vaše èíselná øada je < ' +allTrim( str( nstart)) +'...' + ;
                                         allTrim( str( nkonec)) +' >'   + ;
                                         CRLF +CRLF                     + ;
               'èíslo dokladu ( ' +ckeym +' ) nesplòuje Vámi nastavené podmínky ...'
    endif

    if .not. ldone
      fin_info_box( cInfo, XBPMB_CRITICAL )
      nkeym := 0
    endif
*/

  case IsNUMBER(nKEYm)                                   //--kontrola klíèe
    ckeym := allTrim(str(nkeym))

    if ldoklad_Exists
      * duplicitní èíslo dokladu
      ldone  := .f.
      cInfo  += 'doklad èíslo ( ' +ckeym +' ) v souboru <' ;
                 +psDEr.TEXTm + '> již existuje ...'
    endif

    if .not. ( nkeym >= nstart.and. nkeym <= nkonec )
      * poøizuje doklad mimo èíselnou øadu
      ldone := .f.
      cInfo += if( ldoklad_Exists, CRLF, '' ) + ;
               'Vaše èíselná øada je < ' +allTrim( str( nstart)) +'...' + ;
                                         allTrim( str( nkonec)) +' >'   + ;
                                         CRLF +CRLF                     + ;
               'èíslo dokladu ( ' +ckeym +' ) nesplòuje Vámi nastavené podmínky ...'
    endif

    if .not. ldone
      fin_info_box( cInfo, XBPMB_CRITICAL )
    endif
  endcase

  fin_range->(dbclosearea())
return( {lDONe, val( str(nKEYm, 10)) } )


*
** èíselné øady pro PVPHEAD v rámci celé firmy
static function fin_range_pvpFir(lis_prijDok, typCisRad)
  local  nkeyM, nStart := 0, nKonec := 0
  *
  local  lrangePVP   := SysConfig( 'Sklady:lRangePVP' )
  local  paRangeVyd  := if( typCisRad = 1, SysConfig( 'Sklady:nRangeVyde'), SysConfig('Sklady:nRangeVyPr') )
  local  paRangePrij := SysConfig( 'Sklady:nRangePrij')

  local  ctop, cbot

  if lrangePVP
    nstart := if( lis_prijDok, paRangePrij[1], paRangeVyd[1] )
    nkonec := if( lis_prijDok, paRangePrij[2], paRangeVyd[2] )

    fin_range->(AdsSetOrder('PVPHEAD07'))
    ctop := '2' +strZero(nStart,10)
    cbot := '2' +strZero(nKonec,10)

    fin_range->( ads_setScope(SCOPE_TOP, cTop), ads_setScope(SCOPE_BOTTOM, cBot))
  else
    nstart := paRangePrij[1]
    nkonec := paRangePrij[2]

    fin_range->(AdsSetOrder('PVPHEAD01'))
    ctop := strZero(nStart,10)
    cbot := strZero(nKonec,10)

    fin_range->( ads_setScope(SCOPE_TOP, cTop), ads_setScope(SCOPE_BOTTOM, cBot))
  endif

  fin_range->( dbgoBottom())
  *
  ** nejsou poøízeny žádné doklady, bereme poèáteèní hodnotu rozsahu
  if fin_range->ndoklad = 0
    nkeyM := nstart
  else
    nkeyM := fin_range->ndoklad + 1
  endif

  fin_range->(ads_clearScope(SCOPE_TOP), ads_clearScope(SCOPE_BOTTOM), dbgoTop() )
return { nkeyM, nStart, nKonec }


*
** èíselné øady pro PVPHEAD v rámci skladù
static function fin_range_skl(lis_prijDok)
  local  nkeym, nStart := 0, nKonec := 0
  *
  local  csklad := upper(pvpheadW->ccisSklad), ctop, cbot
  local  typPoh := if( lis_prijDok, '1', '2' )

  drgDBMS:open('c_sklady')

  if c_sklady->(dbSeek(csklad,,'C_SKLAD1'))
    nStart := if( lis_prijDok, c_sklady->nprijemOd, c_sklady->nvydejOd )
    nKonec := if( lis_prijDok, c_dakldy->nprijemDo, c_sklady->nvydejDo )

    if c_sklady->lrangePVP
      fin_range->(AdsSetOrder('PVPHEAD17'))
      ctop := csklad +typPoh +strZero(nStart,10)
      cbot := csklad +typPoh +strZero(nKonec,10)

      fin_range->( ads_setScope(SCOPE_TOP, cTop), ads_setScope(SCOPE_BOTTOM, cBot))
    else
      fin_range->(AdsSetOrder('PVPHEAD16'))
      ctop := csklad +strZero(nStart,10)
      cbot := csklad +strZero(nKonec,10)

      fin_range->( ads_setScope(SCOPE_TOP, cTop), ads_setScope(SCOPE_BOTTOM, cBot))
    endif
  endif

  fin_range->( dbgoBottom())
  *
  ** nejsou poøízeny žádné doklady, bereme poèáteèní hodnotu rozsahu
  if fin_range->ndoklad = 0
    nkeyM := nstart
  else
    nkeyM := fin_range->ndoklad + 1
  endif

  fin_range->(ads_clearScope(SCOPE_TOP), ads_clearScope(SCOPE_BOTTOM), dbgoTop() )
return { nkeyM, nStart, nKonec }


*
Function FIN_range_K( cFILE, nKEYm, lALT_dwn, msg)
  Local  nRECo, nTAGo, nTAGm, nSTART, nKONEC, nREC_hd, nREC_it, nIn
  Local  cKy, cD, cS, cK, filter
  Local  lDONE := .T., lNEWs := .T., lLOCKs := .T., lSPECs := .F.
  Local  pSA
  LOCAL  psDEr, axDEr := _FIN_range
  *
  local  nevent := mp1 := mp2 := nil

  nevent  := LastAppEvent(@mp1,@mp2)
*-  drgEVENT_APPEND   --- klasika INS
*-  drgEVENT_SAVE     --- uložení dokladu + NOVÝ v cyklu


  DEFAULT lALT_dwn To .F.   // , nKEYw TO 0

  if(select('fin_range') <> 0, fin_range->(dbclosearea()), nil)

  nPOSIn  := aSCAN ( axDEr, { |X| X[1] == cFILE } )
  psDEr   := aCLONE( axDEr[ nPOSIn] )

  If (nIn := AT(':', cFILE)) <> 0
    ( cFILE := LEFT(cFILE, nIn -1), lSPECs := .T. )
  EndIf

  drgDBMS:open(cfile,,,,,'fin_range')

  nTAGm   := psDEr.TAGm
  nSTART  := DBGetVal( psDEr.CFGm)[ 1]
  nKONEC  := DBGetVal( psDEr.CFGm)[ 2]

  cKy     := FIN_range_USR(nSTART, nKONEC)
  nREC_hd := RANGE_HD ->( RECNO())
  nREC_it := RANGE_IT ->( RECNO())
  paDOu   := {}

  Do While lLOCKs
    If( RANGE_HD ->( SX_RLOCK(nREC_hd)), lLOCKs := .F., NIL )
  EndDo

  RANGE_IT ->( DbSetScope(SCOPE_BOTH,cKy), ;
               dbGOTOP()                 , ;
               dbEVAL( { || If( RANGE_IT ->(RECNO()) <> nREC_it .and. RANGE_IT ->(sx_ISLOCKED())            , ;
                                aADD( paDOu, RANGE_IT ->nUSER_dok )   , NIL ) }), ;
               DbClearScope()            , ;
               dbGOTO(nREC_it)             )

  fin_range->(AdsSetOrder(ntagm))
  *
  **
  if nevent = drgEVENT_SAVE
    nkeym := DBGetVal(psDEr.FILEm  +'->' +psDEr.KEYm) +1
    if .not. fin_range->(dbseek(nkeym))
      return({.t., val(str(nkeym,10)) })
    else
      nkeym := nil
    endif
  endif


  do case
  case lSPECs
    cd := UPPER(DBGetVal(psDEr.DENIKr))
    fin_range->(dbsetfilter(COMPILE(format("(cdenik = '%%')",{cd}))), dbgotop())

  case len(psDEr) = 10
    fin_range->(dbsetfilter(COMPILE(psDEr.KEYp)), dbgotop())

  case len(psDEr) = 11
    cd     := DBGetVal(psDEr.DENIKr)
    filter := format(psDEr.KEYex,{cd})
    fin_range->(dbsetfilter(COMPILE(filter)), dbgotop())
  endcase

  fin_range->(dbsetscope(SCOPE_TOP, nstart), dbsetscope(SCOPE_BOTTOM, nkonec))

  Do Case
  Case lALT_dwn                                  //--NABÍDKA DÌR v DOKLADECH----
**    mRANGE_dwn(cFILE,pSA,@nKEYm)
**    If( IsNIL(nKEYm), nKEYm := RANGE_IT ->nUSER_dok, NIL )

  Case IsNIL(nKEYm) .or. IsCHARACTER(nKEYm)      //--NÁVRH KLÍÈE            ----
    if(ischaracter(nkeym),nil,fin_range->(dbgobottom()))
    nkeym := fin_range->(sx_keydata()) +1
    If( nKEYm < nSTART, nKEYm := nSTART, NIL )

    do While lNEWs
      if fin_range->(dbseek(nkeym)) .or. ascan(padou,nkeym) <> 0
        nKEYm++
        lNEWs := ( nKEYm < RANGE_HD ->nKONEC_dok )
      Else
        lNEWs := .F.
      EndIf
    EndDo

    RANGE_IT ->nUSER_dok := 0
**    FIN_RANGE_IT ->lUSER_dok := mRANGE_tst(@nKEYm)
    If( RANGE_IT ->lUSER_dok, RANGE_IT ->nUSER_dok := nKEYm, NIL )

  Case IsNUMBER( nKEYm)                          //--KONTROLA KLÍÈE         ----
    if fin_range->(dbseek(nkeym))
      ldone := .f.
      if isobject(msg)
        msg:writeMessage('Duplicitní èíslo dokladu nelze použít ...',DRG_MSG_ERROR)
      endif
    endif


**    If mRANGE_tst(@nKEYm)
**       ( FIN_RANGE_IT ->nUSER_dok := nKEYm, lDONe := .T. )
**    Else
**      ( nKEYm := FIN_RANGE_IT ->nUSER_dok, lDONe := If( nKEYw > 0, .F., .T. ) )
**    EndIf
  EndCase

  RANGE_IT ->(dbunlock(),DbCommit())
  RANGE_HD ->(DbUnlock(nREC_hd))

  fin_range->(dbclosearea())
Return( { lDONE, VAL( STR( nKEYm, 10)) } )


Static Function FIN_range_USR(nSTART,nKONEC)
  Local  cRANGE_itm := CONFIG ->cITEM
  Local  cRANGE_val := CONFIG ->cVALUE
  Local  cUSER_abb  := SYSCONFIG('SYSTEM:cUSERabb')
  Local  cUSER_nam  := SYSCONFIG('SYSTEM:cUSERnam')
  Local  cKy        := UPPER(cRANGE_itm) +STRZERO(nSTART,10) +STRZERO(nKONEC,10)

  If !RANGE_HD ->( DbSeek( cKy ))
    RANGE_HD ->( DbAppend(), sx_RLOCK())

    RANGE_HD ->cRANGE_itm := cRANGE_itm
    RANGE_HD ->cRANGE_val := cRANGE_val
    RANGE_HD ->nSTART_dok := nSTART
    RANGE_HD ->nKONEC_dok := nKONEC

    RANGE_HD ->( DbCommit(), DbUnlock())
  EndIf

  If !RANGE_IT ->( DbSeek( cKy +UPPER(cUSER_abb) ))
    RANGE_IT ->( DbAppend(), sx_RLOCK())

    RANGE_IT ->cRANGE_itm := cRANGE_itm
    RANGE_IT ->cUSER_abb  := PADR(cUSER_abb,10)
    RANGE_IT ->cUSER_nam  := cUSER_nam
    RANGE_IT ->nSTART_dok := nSTART
    RANGE_IT ->nKONEC_dok := nKONEC

    RANGE_IT ->( DbCommit(), DbUnlock())
  EndIf
  RANGE_IT ->( sx_RLOCK())
Return( cKy )


Function FIN_VLDOBDUC(xVAL)                 //--VALIDACE ÚÈETNÍHO OBDOBÍ--------
  LOCAL  lOK := .T.

  IF !UCETSYS ->( mh_SEEK( 'F' +xVAL, 2, .T.))
    IF !Empty( StrTRAN( xVAL, '/', ''))
      ( lOK := .F., drgMsgBOX('Úèetní období neexistuje...'))
    ENDIF
  ELSEIF UCETSYS ->lZAVREN
    ( lOK := .F., drgMsgBOX('Úèetní období je uzavøeno ...'))
  ENDIF
Return(lOK)


Function FIN_VLDOBDDA(xVAL)                 //--VALIDACE DAÒOVÉHO OBDOBÍ--------
  Local  lOK := .T.

  If EMPTY( STRTRAN( xVAL, '/', '' ))
    ( lOK := .F., drgMsgBOX( 'DAÒNOVÉ období je povinný údaj ...'))
  ElseIf DPHDATA  ->( mh_SEEK( xVAL, 1, .T.)) .or. ;
         DPH_2001 ->( mh_SEEK( xVAL, 1, .T.)) .or. ;
         DPH_2004 ->( mh_SEEK( xVAL, 1, .T.))
    ( lOK := .F., drgMsgBOX( 'DAÒOVÉ období je uzavøeno ...' ))
  EndIf
Return(lOK)


FUNCTION FIN_main_FLTS(setFlts)                 //-- NASTAVENÍ PODMÍNKY PØI UKLÁDÁNÍ TMP POLOŽEK
  Local  file  := ALIAS( Select()), cFLTs
  LOCAL  filtr := "cULOHA = '!'"

  if setFlts
    (file) ->(Ads_SetAOF(filtr), DbGoTop())
  else
    (file) ->(Ads_ClearAOF())
  endif
Return( Nil)


**
** CLASS for FIN_datainfo ******************************************************
CLASS FIN_datainfo
EXPORTED:
  var    psa, cfile
  method init

  *
  * externí faktury vystavené, naètené z paleèka
  inline access assign method extdoklad() var extdoklad
    local  cfile := lower(::cfile), retVal := 0

    if cfile = 'fakvyshd'
      retVal := if( (cfile)->ncisUzv = -1, 6002, 0 )   // 555 m_Zluta.bmp 6002 msgAttention.bmp
    endif
    return retVal

  *
  * stav EET pro pokladhd / poklhd
  * 555  m_Zluta.bmp
  * 556  m_zelena.bmp
  * 558  m_cervena.bmp
  inline access assign method stavEet() var stavEet
    local  cfile := lower(::cfile), retVal := 0
    local  cfik, cbkp

    if ( cfile = 'pokladhd' .or. cfile = 'poklhd' )
      if (cfile)->npokladEet = 1
        cfik := (cfile)->cfik
        cbkp := (cfile)->cbkp

        do case
        case                         .not. empty(cfik)  ;  retVal := 556
        case .not. empty(cbkp) .and.       empty(cfik)  ;  retVal := 555
        case       empty(cbkp) .and.       empty(cfik)  ;  retVal := 558
        endcase
      endif
    endif
    return retVal


  * H_big       , H_low        -  úhrada BANKOU                    320 / 321
  * H_big_zelena, H_low_zelena -  úhrada pokladnou, je   to FA-Eet 566 / 567
  * H_big_zluta , H_low_zluta  -  úhrada pokladnou, není to FA-Eet 568 / 569

  * m_zluta  - lze úhradit pokladnou, není to FA-Eet 555
  * m_zelena - lze úhradit pokladnou, je   to FA-Eet 556
  *
  * stav položky pro úhradu jen u FAKVYSHD
  inline access assign method hrazeno_scrFAKV() var hrazeno_scrFAKV
    local  pCEL := DBGetVal(::pSA.pCEL)
    local  pUHR := DBGetVal(::pSA.pUHR)
    local  isHotov, is_pokladEet := .f., isin_pokladit
    local  xretVal      := 0

    if(select('pokladit') = 0, drgDBms:open('pokladit'), nil)
    if(select('c_typUhr') = 0, drgDBms:open('c_typUhr'), nil)

    c_typUhr->( dbseek( upper((::cfile)->czkrTYPuhr),,'TYPUHR1'))

    isHotov       := ( c_typUhr->lisHotov  .and. .not. c_typUhr->lisInkaso .and. .not. c_typUhr->lisregPok )
    is_pokladEet  := ( (::cfile)->npokladEet = 1 )
    isin_pokladit := pokladit->( dbseek( (::cfile)->sid,, 'FAKVYSHD'))

    do case
    case ( pCEL = 0 .and. pUHR = 0 )
      xretVal := 0

    case ( pUHR = 0                )
      xretVal := if( .not. isHotov, 0, if( is_pokladEet, 556, 555))

    case ( pCEL = pUHR             )
      xretVal := if( .not. isHotov, H_big, if( is_pokladEet .and. isin_pokladit, 566, 568))

    case ( pCEL <> pUHR            )
      xretVal := if( .not. isHotov, H_low, if( is_pokladEet .and. isin_pokladit, 567, 569))
    endcase
  return xretVal

  *
  inline access assign method hrazeno(in_canBe_Del) var hrazeno
    local  pCEL := DBGetVal(::pSA.pCEL)
    local  pUHR := DBGetVal(::pSA.pUHR)

    default in_canBe_Del to .f.

    if in_canBe_Del
      if ( pCEL = 0 .and. pUHR = 0 )
        return 0
      endif
    endif
    return if( pCEL == pUHR , H_big, If( pUHR  == 0, 0, H_low ) )

  *
  inline access assign method prikazy() var prikazy
    local  pCEL  := DBGetVal(::pSA.pCEL)
    local  pPRIK := DBGetVal(::pSA.pPRIK)
  return if( pCEL == 0 .or. pPRIK == 0, 0, If( pCEL == pPRIK, P_big, P_low ))

  *
  inline access assign method danuzav() var danuzav
    local  pDUZ := DBGetVal(::pSA.pDUZ), retVal := 0

    if(select('dph_2004') = 0, drgDBms:open('dph_2004'), nil)
    if(select('dph_2009') = 0, drgDBms:open('dph_2009'), nil)
    if(select('dph_2011') = 0, drgDBms:open('dph_2011'), nil)
    if(select('dph_2015') = 0, drgDBms:open('dph_2015'), nil)

    retVal := if(dph_2004->(dbseek(pDUZ,,'DPHDATA')) .or. ;
                 dph_2009->(dbseek(pDUZ,,'DPHDATA')) .or. ;
                 dph_2011->(dbseek(pDUZ,,'DPHDATA')) .or. ;
                 dph_2015->(dbseek(pDUZ,,'DPHDATA')),D_big, 0)

  return retVal

  *
  inline access assign method likvidace() var likvidace
    local klikv := (::cfile)->nklikvid
    local zlikv := (::cfile)->nzlikvid
    local  pKEY := DBGetVal(::pSA.pKEY), ckeyP
    *
    local retVal := 0

    if(select('fin_ucetp') = 0, drgDBMS:open('ucetpol',,,,,'fin_ucetp'), nil )

    if isnumber(DBGetVal(::pSA.pLIK))
      do case
      case(klikv =  0 .and. zlikv = 0)
        ckeyp := upper((::cfile)->cdenik) +strzero(pKEY,10)
        retVal := if( fin_ucetp->(dbSeek(ckeyP,,'UCETPOL1')), L_big, 0)
      case(klikv <> 0 .and. zlikv = 0)
      otherwise
        retval := if(klikv = zlikv, L_big, L_low)
      endcase
*-      retval := if((klikv =  0 .and. zlikv = 0) .or. (klikv <> 0 .and. zlikv = 0), 0, ;
*-                  if(klikv = zlikv, L_big, L_low))
    else
      retVal := MIS_ICON_OK
    endif
  return retVal

  *
  inline access assign method ucuzav() var ucuzav
    local  pUUZ := DBGetVal(::pSA.pUUZ)
    local  pKEY := DBGetVal(::pSA.pKEY)
    *
    local  retVal := 0, ckeyp

    if(select('ucetsys' ) = 0, drgDBms:open('ucetsys' ), nil)
    if(select('uzavisoz') = 0, drgDBms:open('uzavisoz'), nil)

    ucetsys->(dbseek('U' +substr(pUUZ,2),,'UCETSYS2'))
    if ucetsys->lzavren ; retVal := U_big
    else
      ckeyp  := upper((::cfile)->cdenik) +strzero(pKEY,10)
      retval := if(uzavisoz->(dbseek(ckeyp)), U_low, 0)

      if(ucetsys->(sx_islocked()), retVal := MIS_ICON_ERR, nil)
    endif

    ucetsys->(dbseek(pUUZ,,'UCETSYS2'))
  return if(ucetsys->lzavren, U_big, retVal)

  *
  inline access assign method tisk() var tisk
    local pTISK := DBGetVal(::psa.pTISK)
   return if(empty(pTISK), 0, T_big)

  *
  inline method canBe_Del()
    local  ok    := .t.
    local  cfile := lower(::cfile), cky

    if cfile = 'fakprihd' .or. cfile = 'fakvyshd'
      if(select('ucetdodh') = 0, drgDBms:open('ucetdohd'), nil)

      cky := upper( (cfile)->cdenik) +strZero( (cfile)->ncisFak,10)
       ok := (    (cfile)->ncisFak <> 0                           .and. ;
               ( ((cfile)->nparZalFak +(cfile)->nparZahFak) = 0 ) .and. ;
                  .not. ucetdohd->( dbseek( cky,,'UCETDH_7'))           )

    endif

    do case
    case(lower(::cfile) = 'fakprihd')
      ok := (ok .and. ::danuzav() = 0 .and. ::ucuzav() = 0 .and. ::prikazy() = 0 .and. ::hrazeno(.t.) = 0)

    case(lower(::cfile) = 'fakvyshd')
      ok := (ok .and. ::danuzav() = 0 .and. ::ucuzav() = 0 .and. ::hrazeno() = 0)

    endcase

    return ok
ENDCLASS


METHOD FIN_datainfo:init(cFILE)
  LOCAL aDEF_INS := _FIN_main
  LOCAL nIn := aScan( aDEF_INS, {|X| X[ 1] == cFILE })

  ::cFILE := cFILE
  ::pSA   := aClone(aDEF_INS[nIn,2])
RETURN self



**
** CLASS for FIN_postSave ******************************************************
CLASS FIN_postSave
EXPORTED:
  var    psa, cfile, ok, m_parent, cfile_w
  var    cenZakCel

  inline method init(cfile,parent,lExtControl)
    local  aDEF_INS := _FIN_main
    local  nIn      := aScan( aDEF_INS, {|X| X[ 1] == upper(cfile) }), pa
    *
    local  nsel

    *
    ** expedièní listy jsou napojeny na metody FIN - ale nekontrolují se
    if lower( cfile ) = 'explsthd'
      ::ok := .t.
      return ::ok
    endif


    default lExtControl to .t.

    ::cfile    := cFILE
    ::psa      := aClone(aDEF_INS[nIn,2])
    ::ok       := .t.
    ::m_parent := parent
            pa := ::psa

    aeval(pa, {|x,n| pa[n] := strtran(x,'HD','HDW')})

    *
    ** bankovní výpisy a vnitro_Podnikové faktury se kontrolují jen na úèetní uzávìrku
    *
    if( lower( cfile ) = 'banvyphd' .or. lower(cfile) = 'fakvnphd' )
      ::ok := (::ucuzav()  = 0 )
    else
      ::ok := (::danuzav() = 0 .and. ::ucuzav() = 0)
    endif

    if .not. ::ok
       ConfirmBox( ,'Pracujete v uzavøeném daòovém/úèetním období doklad nelze uložit ...', ;
                    'Nelze uložit doklad ...'     , ;
                    XBPMB_CANCEL                  , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    endif

    *
    ** primární kontrola na odeslananý doklad do EET
    if ::ok .and. ( lower( cfile ) = 'pokladhd' .or. lower(cfile) = 'poklhd' )
      ::cfile_w := lower(::cfile) +'w'

      if .not. empty((::cfile_w)->cbkp)
        if (::cfile_w)->ncenZakCel <> (::cfile)->ncenZakCel
          cenZakCel := str((::cfile)->ncenZakCel) +' <> ' +allTrim(str((::cfile_w)->ncenZakCel))
          ConfirmBox( ,  'Promiòte prosím,'                                         +CRLF + ;
                         'snažíte se modifikovat doklad (odeslaný do evidence EET)' +CRLF + ;
                         'došlo ke zmìnì ceny na dokladu ' +cenZakCel               +CRLF +CRLF + ;
                         '                  ... DOKLAD NELZE ULOŽIT ...'          , ;
                         'Pozor doklad byl odeslaný do evidence EET...'           , ;
                         XBPMB_CANCEL                  , ;
                         XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
          return .f.
        endif
      endif
    endif


    * kotroly pøi ukládání dokladù pro naše milované *
    * u likvidace není extCotrol
    if( ::ok .and. lExtControl, ::extcontrol(), nil)
  return ::ok

  *
  * externí faktury vystavené, naètené z paleèka
  inline access assign method extDoklad() var extDoklad
    local  cfile := lower(::cfile) +'w', retVal := 0

    if cfile = 'fakvyshdw'
      retVal := if( (cfile)->ncisUzv = -1, 6002, 0 )   // 555 m_Zluta.bmp 6002 msgAttention.bmp
    endif
  return retVal

  *
  inline access assign method danUzav() var danUzav
    local  pDUZ, retVal := 0

    if 'cobdobidan' $  lower(::psa.pDUZ)
      pDUZ := DBGetVal(::pSA.pDUZ)

      if(select('dph_2004') = 0, drgDBms:open('dph_2004'), nil)
      if(select('dph_2009') = 0, drgDBms:open('dph_2009'), nil)
      if(select('dph_2011') = 0, drgDBms:open('dph_2011'), nil)
      if(select('dph_2015') = 0, drgDBms:open('dph_2015'), nil)

      retVal := if(dph_2004->(dbseek(pDUZ,,'DPHDATA')) .or. ;
                   dph_2009->(dbseek(pDUZ,,'DPHDATA')) .or. ;
                   dph_2011->(dbseek(pDUZ,,'DPHDATA')) .or. ;
                   dph_2015->(dbseek(pDUZ,,'DPHDATA')),D_big, 0)

    endif
  return retVal

  *
  inline access assign method ucuzav() var ucuzav
    local  pUUZ := DBGetVal(::pSA.pUUZ)
    local  pKEY := DBGetVal(::pSA.pKEY)
    *
    local  retVal := 0, ckeyp

    if(select('ucetsys' ) = 0, drgDBms:open('ucetsys' ), nil)
    if(select('uzavisoz') = 0, drgDBms:open('uzavisoz'), nil)

    ucetsys->(dbseek('U' +substr(pUUZ,2),,'UCETSYS2'))

    if ucetsys->lzavren  ;  retVal := U_big
    else
      ckeyp  := upper((::cfile +'w')->cdenik) +strzero(pKEY,10)
      retval := if(uzavisoz->(dbseek(ckeyp)), U_low, 0)

      if(ucetsys->(sx_islocked()), retVal := MIS_ICON_ERR, nil)
    endif

    ucetsys->(dbseek(pUUZ,,'UCETSYS2'))
  return if(ucetsys->lzavren, U_big, retVal)

  *
  inline access assign method extcontrol() var extControl
     local  nsel, n_rozd

     do case
     case(::cfile = 'fakprihd')
       if fakprihdw->nzustPoZao <> 0
          nsel := ConfirmBox( ,'Požadujete uložit nevyrovanou fakturu ...', ;
                               'Nevyrovnaný doklad ...'      , ;
                               XBPMB_YESNO                    , ;
                               XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
          ::ok :=  (nsel = XBPMB_RET_YES)
        endif

      case(::cfile = 'pokladhd')
        if isMemberVar(::m_parent,'rozdilDokl')
          n_rozd := abs( ::m_parent:rozdilDokl )
          do case
          case pokladhdW->ncenZakCel +pokladhdW->ncenZahCel = 0
            ConfirmBox( ,  'Promiòte prosím,'                                           +CRLF + ;
                           'snažíte se uložit pokladní doklad s NULOVOU hodnotou' +CRLF +CRLF + ;
                         '                     ... NELZE ULOŽIT DOKLAD ...' , ;
                         'Nelze uložit doklad ...'     , ;
                         XBPMB_CANCEL                  , ;
                         XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
            ::ok := .f.

          case n_rozd > 5
            ConfirmBox( ,'Rozdíl na pokladním dokladu je vìtší než povolený' +CRLF + ;
                         '... NELZE uložit doklad ...' , ;
                         'Nelze uložit doklad ...'     , ;
                         XBPMB_CANCEL                  , ;
                         XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
            ::ok := .f.

          case n_rozd > .50 .and. n_rozd < 5
            nsel := ConfirmBox( ,'Požadujete uložit nevyrovaný pokladní doklad ...', ;
                                 'Nevyrovnaný doklad ...'      , ;
                                 XBPMB_YESNO                    , ;
                                 XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
            ::ok :=  (nsel = XBPMB_RET_YES)
          endCase
        endif

      case(::cfile = 'fakvyshd')
        if ::extDoklad() <> 0
          ConfirmBox( ,  'Promiòte prosím,'                                                 +CRLF + ;
                         'snažíte se modifikovat externí doklad (naètený z jiného systému)' +CRLF +CRLF + ;
                         '                     ... NELZE ULOŽIT DOKLAD ...' , ;
                         'Nelze uložit doklad ...'     , ;
                         XBPMB_CANCEL                  , ;
                         XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )


          ::ok := .f.
        else
          ::ok := ::fakvysit()
        endif
      endcase
  return nil


  inline method fakvysit()
    local  cfile_hd  := ::cfile +'w', cfile_it := 'fakvysitw'
    local  dpovinFak := (cfile_hd)->dpovinFak
    local  recNo     := (cfile_it)->( recNo())
    local  nsel,  ok := .t.
    *
    local  pa_vybPre := { '12 ', '13 ', '14 ', '15 ', '16 ', '17 ' }
    local  ctypPreDan, nradVykDph
    local  nsum_preDan := 0, nsum_rad25 := 0
    *
    local  cinfo  := 'Promiòte prosím,'                                            +CRLF +CRLF + ;
                     'Novela zákona o DPH (zákon è.360/2014 Sb.)'                        +CRLF + ;
                     'mimo jiné upravuje rozsah komodit na které se vztahuje'            +CRLF + ;
                     'režim pøenesení daòové povinnosti podle § 92a zákona o DPH.' +CRLF +CRLF
    *
    local  cerrD  := 'celková èástka základu danì veškerého dodávaného vybraného zboží  = '
    local  cerr25 := 'celková èástka základu danì uplatnìné pøenesené daòové povinnosti = '


    if dpovinFak >= ctod( '01.04.15')
      (cfile_it)->( dbgoTop())

      do while .not. (cfile_it)->(eof())
        ctypPreDan := (cfile_it)->ctypPreDan
        nradVykDph := (cfile_it)->nradVykDph

        if( ctypPreDan $ pa_vybPre, nil, ctypPreDan := '' )

        nsum_preDan += if( .not. empty(ctypPreDan)                      , (cfile_it)->ncenZakCel, 0 )
        nsum_rad25  += if( .not. empty(ctypPreDan) .and. nradVykDph = 25, (cfile_it)->ncenZakCel, 0 )

        (cfile_it)->( dbskip())
      enddo

      (cfile_it)->( dbgoTo( recNo))

      do case
      case (nsum_preDan - nsum_rad25) = 0                                       // na dokladu nejsou položky s pøenDaò, nebo je právnì zaøadila do øv. 25
        ok := .t.

      case (nsum_preDan > 100000 ) .and. (nsum_preDan <> nsum_rad25)            // suma základu > 100000 a nezaøadila všechny položky do øv. 25 fatální chyba

        cerrD  += str( nsum_preDan, 10, 2 ) +' Kè' +CRLF
        cerr25 += str( nsum_rad25 , 10, 2 ) +' Kè' +CRLF +CRLF

        ConfirmBox( , cinfo +cerrD +cerr25 +CRLF + '... NELZE uložit doklad ...' , ;
                      'Nelze uložit doklad ...'                                  , ;
                      XBPMB_CANCEL                                               , ;
                      XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

        ok := .f.

      otherwise                                                                 // jen dotaz, jestli souhlasí s uložením dokladu

        cerrD  += str( nsum_preDan, 10, 2 ) +' Kè' +CRLF
        cerr25 += str( nsum_rad25 , 10, 2 ) +' Kè' +CRLF +CRLF

        nsel := ConfirmBox( ,cinfo +cerrD +cerr25                                                 , ;
                             'Na dokladu jsou nezaøazené položky pøenesené daòové povinnosti ...' , ;
                              XBPMB_YESNO                                                         , ;
                              XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
        ok :=  (nsel = XBPMB_RET_YES)

      endcase
    endif

  return ok

ENDCLASS


*
** CLASS for FIN_CMPDPH ********************************************************
CLASS FIN_CMDPH FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, getForm, postLastField
  var     cFILE, cTYPdan, nPROCdan, nZAKLdan

HIDDEN:
  VAR  drgGet, dm, zakl_dph, saz_dph

ENDCLASS


METHOD FIN_CMDPH:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  ::drgUsrClass:init(parent)
  ::dm := parent:parent:dataManager
RETURN self


METHOD FIN_CMDPH:getForm()
  LOCAL drgFC, oDrg

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 40,2 DTYPE '10' TITLE 'Výpoèet základu danì...' GUILOOK 'All:N,Border:Y' BORDER 4
  DRGTEXT INTO drgFC CPOS 1 ,.5  CLEN 10 CAPTION 'Základ s DPH'
  DRGTEXT M->nPROCDAN INTO drgFC CPOS 12,.5 PICTURE '99' CLEN 3 CTYPE 2

  DRGTEXT INTO drgFC CPOS 15,.5  CLEN  3 CAPTION '%'
  DRGGET  M->nZAKLDAN INTO drgFC FPOS 20,.5 FLEN 15 PICTURE '@N 9999999999.99' CTYPE 2 POST 'postLastField'
RETURN drgFC


METHOD FIN_CMDPH:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  ::nPROCDAN := 5  // jen pro sichr
  ::nZAKLDAN := 0

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}

    ::cFILE    := lower(drgParse(::drgGet:name,'-'))
    do case
    case(::cfile = 'vykdph_iw' .or. ::cfile = 'vykdph_pw')
      ::ctypdan  := '1'
      ::nprocdan := DBGetVal(::cfile +'->nprocdph')
      ::zakl_dph := ::cfile +if(::cfile = 'vykdph_iw', '->nzakld_dph', '->nzakld_zal')
      ::saz_dph  := ::cfile +if(::cfile = 'vykdph_iw', '->nsazba_dph', '->nsazba_zal')

    case(::cfile = 'fakvysitw' .or. ::cfile = 'fakpriitw' )
      ::cTYPdan  := '1'
      ::nPROCdan := ::dm:get(::cfile +'->nprocdph')
      ::zakl_dph := ::cfile +'->ncejprzbz'
      ::saz_dph  := ::cfile +'->njeddan'

    otherwise
      ::cTYPdan  := Right(::drgGet:name,1)
      ::nPROCdan := DBGetVal(::cFILE +'->nPROCdan_' +::cTYPdan)
      ::zakl_dph := ::cfile +'->nZAKLdan_' +::cTYPdan
      ::saz_dph  := ::cfile +'->nSAZdan_'  +::cTYPdan
    endcase
  ENDIF
RETURN


METHOD FIN_CMDPH:postLastField(drgVar)
  local  nROUNDdph := SysConfig('Finance:nRoundDph')
  local  koeF, cSAZdan, nSAZdan, ndecimals
  *
  local  ovar

  if drgvar:itemchanged()
    ::nzakldan := drgvar:value

    * od 1.4.2019 koeficient pro zpìtný výpoèet
*****    nkoeF   := 1 +( ::nprocdan/100 )
*****    nSAZdan := ::nzaklDan - ( ::nzaklDan/nkoeF )

    ndeciMals := Set( _SET_DECIMALS, 4 )
    nkoeF     := ::nprocdan / (::nprocdan +100)
    nSAZdan   := Round( ::nzaklDan * nkoeF,2 )
    Set( _SET_DECIMALS, ndeciMals)

***** oprava 26.2.2020
*****    cSAZdan := str( nSAZdan )
*****    nSAZdan := val( subStr( cSAZdan, 1, at( '.', cSAZdan) +2 ))
    *
    *
    ovar := ::dm:has(::zakl_dph)
    ovar:set( ::nzakldan -nsazdan )
    ovar:initValue := ovar:value := ovar:prevValue := ::nzakldan -nsazdan
    *
    if ( ::cfile = 'fakvysitw' .or. ::cfile = 'fakpriitw' )
      ovar:initValue := ovar:value
      ovar := ::dm:has(::cfile +'->nvypsazdan')
      ovar:initValue := ovar:value := ovar:prevValue := 1

      ovar := ::dm:has(::cfile +'->nCEJPRZDZ')
      ovar:set(::nzakldan)
    else
      DBPutVal(::zakl_dph, ::nzakldan -nsazdan )
      DBPutVal( ::saz_dph, nsazdan)
    endif

    ovar := ::dm:has(::saz_dph)
    ovar:set(nsazdan)
    ovar:value := ovar:prevValue := nsazdan
  endif

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN .T.