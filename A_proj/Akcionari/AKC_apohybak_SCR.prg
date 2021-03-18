#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  APOHYBAK_SCR
** CLASS AKC_pohybak_SCR ******************************************************
CLASS AKC_apohybak_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  Init
  method  drgDialogStart
  METHOD  EventHandled
  METHOD  itemMarked

  * browColumn
  * BRo - AKCIE
  inline access assign method nazevAkc() var nazevAkc      // název typu akcie c_typAkc
    c_typAkc->( dbseek( upper(akcie->cZkrTypAkc),,'C_TYPAKC01'))
    return c_typAkc->cnazevAkc

  inline access assign method zpusNab() var zpusNab
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(akcie->cserCISakc)

    apohybAk->( dbseek( cky,,'ApohybAK03'))
    return upper(apohybAk->czkrTYPpoh)

ENDCLASS


*
********************************************************************************
METHOD AKC_apohybak_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
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


METHOD AKC_apohybak_SCR:init(parent)
  local ctmpW  := drgINI:dir_USERfitm +userWorkDir() +'\akcie_w'

  ::drgUsrClass:init(parent)

  drgDBMS:open('akcionar')   // akcionáø
  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
  drgDBMS:open('c_psc'   )   // poštovní smìrovací èísla


  drgDBMS:open('akcionar',,,,,'akcionar_S')   // pùvodní majitel akcie /akcionar/
  drgDBMS:open('c_typAr' ,,,,,'c_typAr_S' )   // typ akcionáøe
  drgDBMS:open('c_oblasA',,,,,'c_oblasa_S')   // typ akcionáøe
  drgDBMS:open('c_psc'   ,,,,,'c_psc_S'   )   // poštovní smìrovací èísla


  drgDBMS:open('apohybAk')   // pohyb akcií
RETURN self


method AKC_apohybak_SCR:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


METHOD AKC_apohybak_SCR:itemMarked(arowCol,unil,oxbp)

  akcionar  ->( dbseek( apohybak->nAKCIONAR   ,,'ID'        ))
  c_typAr   ->( dbseek( akcionar->cZkrTypAr   ,,'C_TYPAR01' ))
  c_oblasA  ->( dbseek( akcionar->czkrOblast  ,,'C_OBLASA01'))
  c_psc     ->( dbseek( akcionar->cpsc        ,,'C_PSC1'    ))

  akcionar_S->( dbseek( apohybak->crodCISakc  ,,'Akcionar01'))
  c_typAr_S ->( dbseek( akcionar_S->cZkrTypAr ,,'C_TYPAR01' ))
  c_oblasA_S->( dbseek( akcionar_S->czkrOblast,,'C_OBLASA01'))
  c_psc_S   ->( dbseek( akcionar_S->cpsc      ,,'C_PSC1'    ))
RETURN self


*  SCR APOHYBAK_AR dle akcionáøù
** CLASS AKC_apohybak_AR_SCR ***************************************************
CLASS AKC_apohybak_AR_SCR FROM drgUsrClass, quickFiltrs
  exported:

  method  init
  method  drgDialogStart
  method  itemMarked


  inline method drgDialogEnd(drgDialog)
  return self
ENDCLASS


method AKC_apohybak_AR_SCR:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_psc'   )   // poštovní smìrovací èísla
  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
return self


method AKC_apohybak_AR_SCR:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


method AKC_apohybak_AR_SCR:itemMarked(arowCol,unil,oxbp)
  local  crodCISakc := akcionar->crodCISakc
  local  cf := "crodCISakc = '%%'", filter
  *
*  local  nAKCIONAR := isNull(akcionar->sID, 0 )
*  local  cf := "nAKCIONAR = %%", filter

  c_typAr ->( dbseek( akcionar->cZkrTypAr ,,'C_TYPAR01' ))
  c_oblasA->( dbseek( akcionar->czkrOblast,,'C_OBLASA01'))
  c_psc   ->( dbseek( akcionar->cpsc      ,,'C_PSC1'    ))

*  filter := format( cf, {nAKCIONAR} )
  filter := format( cf, {crodCISakc} )
  apohybak->( ads_setAof(filter), dbgoTop())
RETURN self



*  SCR APOHYBAK_AR dle akcií
** CLASS AKC_apohybak_AK_SCR ***************************************************
CLASS AKC_apohybak_AK_SCR FROM drgUsrClass, quickFiltrs
  exported:

  method  init
  method  drgDialogStart
  method  itemMarked

 * browColumn
  * BRo - AKCIE
  inline access assign method nazevAkc() var nazevAkc      // název typu akcie c_typAkc
    c_typAkc->( dbseek( upper(akcie->cZkrTypAkc),,'C_TYPAKC01'))
    return c_typAkc->cnazevAkc

  inline access assign method zpusNab() var zpusNab
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(akcie->cserCISakc)

    apohybAk->( dbseek( cky,,'ApohybAK03'))
    return upper(apohybAk->czkrTYPpoh)


 * akcionar
  inline access assign method hodnotaAk() var hodnotaAk     // hodnota rozdìlené akcie
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(AKCIEsW->cserCISakc)

    akcie_p->( dbseek( cky,, 'AKCIE07'))
    return akcie_p->nhodnotaAk

  inline access assign method zpusNab_AR() var zpusNab_AR
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(AKCIEsW->cserCISakc)

    apohybAk->( dbseek( cky,,'ApohybAK03'))
    return upper(apohybAk->czkrTYPpoh)


  inline method drgDialogEnd(drgDialog)
  return self

ENDCLASS


method AKC_apohybak_AK_SCR:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_psc'   )   // poštovní smìrovací èísla
  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
  drgDBMS:open('c_typAkc')   // typ akcií

  drgDBMS:open('akcionar')   // akcionáø
  drgDBMS:open('apohybAk')   // pohyb akcií

  *
  ** souètový soubor akcií za cserCISakc ... npocAkci, maofAkci
  drgDBMS:open('akcie',,,,,'akcie_p')
  akcie_p->( ordSetFocus('Akcie03'), dbgoTop())

  drgDBMS:open('AKCIEsw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  do while .not. akcie_p->(eof())
    serCISakc := upper(akcie_p->cserCISakc)

    if .not. AKCIEsw->( dbseek( serCisAkc,,'Akcie02'))
      mh_copyFld('akcie_p', 'AKCIEsw', .t. )
      AKCIEsw->npocAkci := 1
      AKCIEsw->nAKCIE   := akcie_p->sID
      AKCIEsw->maofAkci := 'sID=' +alltrim( str( akcie_p->nAKCIONAR))
    else
      AKCIEsw->nhodnotaAk += akcie_p->nhodnotaAk
      AKCIEsw->npocAkci   += 1
      AKCIEsw->maofAkci   += ' or sID=' +alltrim( str( akcie_p->nAKCIONAR))
    endif

    akcie_p->( dbskip())
  enddo
return self


method AKC_apohybak_AK_SCR:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


method AKC_apohybak_AK_SCR:itemMarked(arowCol,unil,oxbp)
  local  nAKCIE := AKCIEsw->nAKCIE
  local  cf    := "nAKCIE = %%"   , filter
  local                             filter_ar := allTrim(AKCIEsw->maofAkci)

  c_typAr ->( dbseek( akcionar->cZkrTypAr ,,'C_TYPAR01' ))
  c_oblasA->( dbseek( akcionar->czkrOblast,,'C_OBLASA01'))
  c_psc   ->( dbseek( akcionar->cpsc      ,, 'C_PSC1'   ))

  filter := format( cf, {nAKCIE} )
  apohybak->( ads_setAof(filter), dbgoTop())

  akcionar->( ads_setAof(filter_ar), dbgoTop())
RETURN self



*  SCR APOHYBAK_AKP dle akcií - položkovì
** CLASS AKC_apohybak_AKP_SCR **************************************************
CLASS AKC_apohybak_AKP_SCR FROM drgUsrClass
  exported:

  * browColumn
  * BRo - AKCIE
  inline access assign method nazevAkc() var nazevAkc      // název typu akcie c_typAkc
    c_typAkc->( dbseek( upper(akcie->cZkrTypAkc),,'C_TYPAKC01'))
    return c_typAkc->cnazevAkc

  inline access assign method zpusNab() var zpusNab
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(akcie->cserCISakc)

    apohybAk_S->( dbseek( cky,,'ApohybAK03'))
    return upper(apohybAk_S->czkrTYPpoh)

  * body of class
  inline method init(parent)
    ::drgUsrClass:init(parent)

    drgDBMS:open('c_psc'   )   // poštovní smìrovací èísla
    drgDBMS:open('c_typAr' )   // typ akcionáøe
    drgDBMS:open('c_oblasA')   // typ akcionáøe
    drgDBMS:open('c_typAkc')   // typ akcií

    drgDBMS:open('akcionar')
    drgDBMS:open('apohybAk',,,,,'apohybAk_S') // for Bro column
  return self


  inline method itemMarked()
    local  cf := "cserCISakc = '%%'", cf_apohAk

    cf_apohybAk := format( cf, {AKCIE->cserCISakc} )
    apohybak->( ads_setAof(cf_apohybAk), dbgoTop())
  return self

ENDCLASS