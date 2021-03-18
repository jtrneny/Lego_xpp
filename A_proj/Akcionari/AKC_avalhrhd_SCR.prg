#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  AVALHRHD
** CLASS AKC_avalhrhd_SCR *****************************************************
CLASS AKC_avalhrhd_SCR FROM drgUsrClass, quickFiltrs
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


  inline method mleinit(odrg)
    local  omle := oDrg:oXbp
    omle:format := 3
*    omle:setWrap(.t.)
   return self

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

  inline method tabSelect( otabPage, tabNum )

    if( tabNum = 3, ::dm:refresh(), nil )
  return .t.

hidden:
* sys
  var     msg, dm, dc, df, brow

ENDCLASS


*
********************************************************************************
METHOD AKC_avalhrhd_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
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


METHOD AKC_avalhrhd_SCR:init(parent)
  local ctmpW  := drgINI:dir_USERfitm +userWorkDir() +'\akcie_w'

  ::drgUsrClass:init(parent)

  drgDBMS:open('OSOBY')

  drgDBMS:open('c_psc'   )   // poštovní smìrovací èísla

  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
  drgDBMS:open('c_typAkc')   // typ akcií

  drgDBMS:open('akcionar')   // akcionáø
  drgDBMS:open('apohybAk')   // pohyb akcií

RETURN self


method AKC_avalhrhd_SCR:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataManager
  ::dc  := drgDialog:dialogCtrl              // dataCtrl
  ::df  := drgDialog:oForm                   // form
return self


METHOD AKC_avalhrhd_SCR:itemMarked(arowCol,unil,oxbp)
  local  porVALhro := avalhrhd->nporVALhro
  local  cf := "nPORVALHRO = %%", filter

  if isObject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    if cfile = 'avalhrit'
    else
     filter := format( cf, {porVALhro} )
     avalhrit->( ads_setAof(filter), dbgoTop())
    endif
  endif

  akcionar->( dbseek( avalhrit->nAKCIONAR,, 'ID'))

  c_typAr ->( dbseek( akcionar->cZkrTypAr ,,'C_TYPAR01' ))
  c_oblasA->( dbseek( akcionar->czkrOblast,,'C_OBLASA01'))
  c_psc   ->( dbseek( akcionar->cpsc      ,, 'C_PSC1'   ))
RETURN self


*  SCR AVALHRHD dle akcionáøù
** CLASS AKC_avalhrhd_AR_SCR ***************************************************
CLASS AKC_avalhrhd_AR_SCR FROM drgUsrClass, quickFiltrs
  exported:

  method  init
  method  drgDialogStart
  method  itemMarked


  inline method drgDialogEnd(drgDialog)
    avalhrit->(dbClearRelation())
  return self

ENDCLASS


method AKC_avalhrhd_AR_SCR:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_psc'   )   // poštovní smìrovací èísla
  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe

  drgDBMS:open('avalhrit')
  drgDBMS:open('avalhrhd')

  avalhrhd->( ordSetFocus('Avakhrhd01'))
  avalhrit->(dbSetRelation('avalhrhd', _EarlyBoundCodeblock({|| avalhrit->nporVALhro }), "avalhrit->nporVALhro)",,, .F.))
return self


method AKC_avalhrhd_AR_SCR:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


method AKC_avalhrhd_AR_SCR:itemMarked(arowCol,unil,oxbp)
  local  nAKCIONAR := isNull(akcionar->sID, 0 )
  local  cf := "nAKCIONAR = %%", filter

  c_typAr ->( dbseek( akcionar->cZkrTypAr ,,'C_TYPAR01' ))
  c_oblasA->( dbseek( akcionar->czkrOblast,,'C_OBLASA01'))
  c_psc   ->( dbseek( akcionar->cpsc      ,, 'C_PSC1'   ))

  filter := format( cf, {nAKCIONAR} )
  avalhrit->( ads_setAof(filter), dbgoTop())
RETURN self