#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  AKCIE
** CLASS AKC_akcie_SCR ********************************************************
CLASS AKC_akcie_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  Init
  method  drgDialogStart
  METHOD  EventHandled
  METHOD  itemMarked

  * browColumn
  inline access assign method is_isZAM() var is_isZAM      // ? je v msPrc_mo
    return if( osoby->nis_ZAM = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isPER() var is_isPER      // ? je v personal
    return if( osoby->nis_PER = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isDOH() var is_isDOH      // ? je v dsPohyby
    return if( osoby->nis_DOH = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isRPR() var is_isRPR      // ? je v rodPrisl
    return if( osoby->nis_RPR = 1, MIS_ICON_OK, 0 )

  * akcie
  inline access assign method nazevAkc() var nazevAkc      // název typu akcie c_typAkc
    c_typAkc->( dbseek( upper(akcieSw->cZkrTypAkc),,'C_TYPAKC01'))
    return c_typAkc->cnazevAkc

  * akcionar
  inline access assign method hodnotaAk() var hodnotaAk     // hodnota rozdìlené akcie
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(AKCIEsW->cserCISakc)

    akcie_p->( dbseek( cky,, 'AKCIE07'))
    return akcie_p->nhodnotaAk

  inline access assign method zpusNab() var zpusNab
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(AKCIEsW->cserCISakc)

    apohybAk->( dbseek( cky,,'ApohybAK03'))
    return upper(apohybAk->czkrTYPpoh)


******
  inline  method osb_osoby_nova(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


  inline method osb_osoby_oprava(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.
ENDCLASS


*
********************************************************************************
METHOD AKC_akcie_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
*  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
*    ::itemSelected()

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


METHOD AKC_akcie_SCR:init(parent)
  local  serCISakc

  ::drgUsrClass:init(parent)

  drgDBMS:open('OSOBY')

  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
  drgDBMS:open('c_typAkc')   // typ akcií

  drgDBMS:open('apohybAk')   // pohyb akcií


  ** souètový soubor akcií za cserCISakc ... npocAkci, maofAkci
  drgDBMS:open('akcie',,,,,'akcie_p')
  akcie_p->( ordSetFocus('Akcie03'), dbgoTop())

  drgDBMS:open('AKCIEsw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  do while .not. akcie_p->(eof())
    serCISakc := upper(akcie_p->cserCISakc)

    if .not. AKCIEsw->( dbseek( serCisAkc,,'AKCIEsw02'))
      mh_copyFld('akcie_p', 'AKCIEsw', .t. )
      AKCIEsw->npocAkci := 1
      AKCIEsw->maofAkci := 'sID=' +alltrim( str( akcie_p->nAKCIONAR))
    else
      AKCIEsw->nhodnotaAk += akcie_p->nhodnotaAk
      AKCIEsw->npocAkci   += 1
      AKCIEsw->maofAkci   += ' or sID=' +alltrim( str( akcie_p->nAKCIONAR))
    endif

    akcie_p->( dbskip())
  enddo

   ** tmp soubory pro test AKC_akcie_IN **
  drgDBMS:open('AKCIONARw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('AKCIEw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP

RETURN self


method AKC_akcie_SCR:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


METHOD AKC_akcie_SCR:itemMarked()
  local  filter := allTrim(AKCIEsw->maofAkci)
*
  local  cf := "cserCISakc = '%%'", cf_apohAk
  *
//  local  nAKCIE  := isNull(akcie->sID, 0 )
//  local  cf := "nAKCIONAR = %%", filter := allTrim(AKCIEsw->maofAkci)

  c_typAr ->( dbseek( akcionar->cZkrTypAr ,,'C_TYPAR01' ))
  c_oblasA->( dbseek( akcionar->czkrOblast,,'C_OBLASA01'))
  c_psc   ->( dbseek( akcionar->cpsc      ,, 'C_PSC1'   ))

*  filter := format( cf, {nAKCIONAR} )
*  akcie->( ads_setAof(filter), dbgoTop())
  akcionar->( ads_setAof(filter), dbgoTop())

  cf_apohybAk := format( cf, {AKCIEsw->cserCISakc} )
  apohybak->( ads_setAof(cf_apohybAk), dbgoTop())
RETURN self


*METHOD AKC_akcionar_SCR:itemSelected()
*  DRGDIALOG FORM 'FIR_FIRMY_SCR' PARENT ::drgDialog DESTROY
*  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
*RETURN self