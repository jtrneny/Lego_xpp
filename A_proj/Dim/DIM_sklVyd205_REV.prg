#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  Sklady vydej do DIMu kontrola - 205
** CLASS DIM_sklVyd205_REV *****************************************************
CLASS DIM_sklVyd205_REV FROM drgUsrClass  // , quickFiltrs
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

** ok
  inline access assign method nazSkMis var nazSkMis
    c_skumis->( dbseek( upper( msdim->cklicSkMis),,'C_1'))
    return c_skumis->cnazSkMis

  inline access assign method nazOdpMis var nazOdpMis
    c_odpmis->( dbseek( upper( msdim->cklicOdMis),,'C_1'))
    return c_odpmis->cnazOdpMis


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
METHOD DIM_sklVyd205_REV:eventHandled(nEvent, mp1, mp2, oXbp)
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



METHOD DIM_sklVyd205_REV:init(parent)
  local  cky_msDIm, cky_cenZboz

  ::drgUsrClass:init(parent)

  drgDBMS:open('MSDIM'   )
  drgDBMS:open('ELNARDIM')
  drgDBMS:open('ZMENYDIM')
  drgDBMS:open('C_TYPHOD')
  drgDBMS:open('C_SKUMIS')
  drgDBMS:open('C_ODPMIS')

  drgDBMS:open('cenZboz')
  drgDBMS:open('pvpItem')

  drgDBMS:open('msDimW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  pvpItem->( ads_setAof("ctypDoklad = 'SKL_VYD205'"), dbgoTop())

  do while .not. pvpItem->(eof())
    cky_msDIm   := upper(pvpitem->cklicSKmis) +upper(pvpitem->cklicODmis) +strZero(pvpitem->ninvCISdim,6)
    cky_cenZboz := upper(pvpitem->ccisSklad)  +upper(pvpitem->csklPol)

    if .not. msDim->( dbSeek( cky_msDIm,, 'DIM11' ))
       cenZboz->( dbseek( cky_cenZboz,,'CENIK03') )

       mh_copyFld('pvpitem', 'msDImW', .t. )
         msDImW->ntypDim    := 1
         msDImW->cnazevDim  := cenZboz->cnazZbo
         msDImW->ddatZARdim := pvpitem->dpohPVP
         msDImW->npocKUSdim := pvpitem->nmnozPRdod
         msDImW->czkratJedn := cenZboz->czkratJedn
         msDImW->ncisloPvp  := pvpitem->ndoklad
         msDImW->ncenJEDdim := cenZboz->ncenaSzbo
         msDImW->ncenCELdim := cenZboz->ncenaSzbo * pvpitem->nmnozPRdod
    endif

    pvpitem->( dbskip())
  enddo

  pvpItem->( ads_clearAof(), dbgoTop())
  msDImW->( dbgoTop())
RETURN self


method DIM_sklVyd205_REV:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

//  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


METHOD DIM_sklVyd205_REV:itemMarked()
*  local  filter := allTrim(AKCIEsw->maofAkci)
  *
*  local  cf := "cserCISakc = '%%'", cf_apohAk
  *
//  c_typAr ->( dbseek( akcionar->cZkrTypAr ,,'C_TYPAR01' ))
//  c_oblasA->( dbseek( akcionar->czkrOblast,,'C_OBLASA01'))
//  c_psc   ->( dbseek( akcionar->cpsc      ,, 'C_PSC1'   ))

*  filter := format( cf, {nAKCIONAR} )
*  akcie->( ads_setAof(filter), dbgoTop())
//  akcionar->( ads_setAof(filter), dbgoTop())

//  cf_apohybAk := format( cf, {AKCIEsw->cserCISakc} )
//  apohybak->( ads_setAof(cf_apohybAk), dbgoTop())
RETURN self

