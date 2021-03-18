#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
*
#include "..\Asystem++\Asystem++.ch"


*
*************** MZD_nem_prilzad ***********************************************
CLASS MZD_prehlpojsoc_CRDw FROM drgUsrClass
exported:
  var     task
  method  init, drgDialogStart, drgDialogEnd
  method  zpracuj_podklady
*  method  postValidate


  inline method postValidate(drgVar)
    if( drgVar:changed(), drgVar:save(), nil )
    return .t.

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE  )
      return .t.

    case ( nEvent = drgEVENT_SAVE        )
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      return .t.

    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, ab, oabro, xbp_therm, cparm
* datové
  var     culoha, nrok, nobdobi, pa_obdZpr, radek


ENDCLASS


method MZD_prehlpojsoc_CRDw:init(parent)
  local  task := 'mzd'

  ::drgUsrClass:init(parent)
  ::cParm    := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm    := Left( ::cParm,1)
  ::radek    := 0

  ::oabro    := parent:parent:odBrowse[1]

  drgDBMS:open('osoby' )

  drgDBMS:open('MZDYHD',,,,,'mzdyhda')
  drgDBMS:open('mzdzavhd',,,,,'mzdzavhda')
  drgDBMS:open('trvzavhd',,,,,'trvzavhda')
  drgDBMS:open('firmy',,,,,'firmya')
  drgDBMS:open('c_okresy')
  drgDBMS:open('c_bankuc')
  *
  drgDBMS:open('tmprposow',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  if select( 'mzdZavhd') <> 0
    mzdZavhda->( dbgoto( mzdZavhd->( recNo()) ))
  endif

return self


method MZD_prehlpojsoc_CRDw:drgDialogStart(drgDialog)

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  ::ab         := drgDialog:oActionBar:members      // actionBar
//  ::oabro      := drgDialog:dialogCtrl:obrowse
  *
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  ::zpracuj_podklady()


  setAppFocus( ::oabro:oxbp )
  ::dm:refresh()

//  ::setFilter()
return self


method MZD_prehlpojsoc_CRDw:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

return self



method MZD_prehlpojsoc_CRDw:zpracuj_podklady()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  nod, ndo
  local  filtrs
  *
  local  cky, ncisRadku := 1, ncisListu := 1
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2]
  local  celkem    := 0
  local  xx, yy
  local  aSoc
  local  rokObd    := mzdZavhda->nrokObd
  *

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení', nSize, nHight)

////   pøednastavení první strany pøílohy
  mh_copyFld( 'mzdzavhda', 'tmprposow', .t., .t. )

  tmprposow->cnazevzame := AllTrim(SysConfig('System:cPodnik'))
  tmprposow->cico       := myFirmaAtr('cico')  //AllTrim(Str(SysConfig('System:nIco')))
  tmprposow->cUlice     := AllTrim(SysConfig('System:cUliceOrg'))
  tmprposow->cCisPopis  := AllTrim(SysConfig('System:cCisPopOrg'))
  tmprposow->cUlicCiPop := AllTrim(SysConfig('System:cUlice'))
  tmprposow->cMisto     := AllTrim(SysConfig('System:cSidlo'))
  tmprposow->cPsc       := AllTrim(StrTran( SysConfig('System:cPSC'),' ',''))
  tmprposow->cZkratStat := AllTrim(SysConfig('System:cZaklStat'))


  if trvzavhda->( dbseek( 'MGENODVSOC',,'TRVZAVHD01'))
    tmprposow->cVarSymSoc := trvzavhda->cvarsym
*    tmprposow->cNazMisSoc := trvzavhda->cnazev

    if firmya->( dbseek( trvzavhda->ncisfirmy,,'FIRMY01'))
      if c_okresy->( dbseek( Upper(firmya->cokres),,'C_OKRES1'))
        tmprposow->nKodOkrSoc := c_okresy->nKodOkrSoc
        tmprposow->cNazMisSoc := c_okresy->cNaz_Okres
      endif
    endif
  endif

  tmprposow->dPlatAkce := Date()
  tmprposow->cUcet     := if( c_bankuc->(dbSeek(.t.,,'BANKUC2')), c_bankuc->cbank_uct,'')

//  if users->( dbSeek( Upper(user),,'USERS01'))
    if osoby->( dbSeek( logCisOsoby,,'OSOBY01' ))
      tmprposow->cJmenoOsob := osoby->cJmenoOsob
      tmprposow->cPrijOsob  := osoby->cPrijOsob
    endif
//  endif

  tmprposow->cTelefon   := AllTrim(SysConfig('System:cTelefon'))
  tmprposow->cEmail     := AllTrim(SysConfig('System:cEmail'))
  tmprposow->dDatZprac  := Date()
  *
  ** vazba na MzdoveZavazky\MZD_Zavazky_.prg musíme nastavi a zhodit filtr na mzdyHda
  filtrs := Format("nROKOBD = %%", {rokObd})
  mzdyhda ->( ads_setAof(filtrs), dbGoTop())
  aSoc := retvalSoc()
  mzdyhda ->( ads_clearAof())

  tmprposow->nTypSazby  := aSoc[10]  //   1 - 25%, 2 - 26%

  tmprposow->nVymZaklZa := aSoc[1] - aSoc[3]
  tmprposow->nUhrnPojZa := aSoc[2] - aSoc[4]
  tmprposow->nVymZaklDS := aSoc[3]
  tmprposow->nUhrnPojDS := aSoc[4]

  if rokobd >= 202006 .and. rokobd <= 202008
    tmprposow->nVymZakl := aSoc[5] - aSoc[14]
  else
    tmprposow->nVymZakl := aSoc[5]
  endif

  tmprposow->nUhrnPoj   := aSoc[6]
  tmprposow->nPojistne  := aSoc[2] + aSoc[6]
  tmprposow->nZucNahMzd := aSoc[7]
  tmprposow->nZucNahMz2 := aSoc[8]
  tmprposow->nRoPoNaMzd := aSoc[9]
  tmprposow->nZaklSlePo := aSoc[14]

  if aSoc[14] <> 0
     tmprposow->nSnizVymZa := 1
  endif

  tmprposow->(dbcommit())
  tmprposow->(dbGoTop())

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení - dokonèeno', nSize, nHight)
**  Sleep(150)
**  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.