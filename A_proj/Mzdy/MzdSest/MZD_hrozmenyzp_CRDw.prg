#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
*
#include "..\Asystem++\Asystem++.ch"


*
*************** MZD_nem_prilzad ***********************************************
CLASS MZD_hrozmenyzp_CRDw FROM drgUsrClass
exported:
  var     task
  method  init, drgDialogStart, drgDialogEnd
  method  zpracuj_podklady
  method  postValidate


//  inline method postValidate(drgVar)
//    if( drgVar:changed(), drgVar:save(), nil )
//    return .t.

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


method MZD_hrozmenyzp_CRDw:init(parent)
  local  task := 'mzd'

  ::drgUsrClass:init(parent)
  ::cParm    := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm    := Left( ::cParm,1)
  ::radek    := 0

  ::oabro    := parent:parent:odBrowse[1]

  drgDBMS:open('msprc_mo')
  drgDBMS:open('osoby'   )

  drgDBMS:open('trvzavhd')
  drgDBMS:open('firmy')
  drgDBMS:open('c_okresy')
  drgDBMS:open('c_pracvz')
  drgDBMS:open('c_prvzdc')
  drgDBMS:open('c_duchod')
  *
  drgDBMS:open('tmhrozzpw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
return self


method MZD_hrozmenyzp_CRDw:drgDialogStart(drgDialog)

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

method MZD_hrozmenyzp_CRDw:postValidate(drgVar)
  local  value      := drgVar:get()
  local  name       := Lower(drgVar:name)
  local  field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  lOk := .t.

  if(lOk, eval(drgVar:block,drgVar:value), nil)

//  inline method postValidate(drgVar)
//    if( drgVar:changed(), drgVar:save(), nil )
//    return .t.

  if drgVar:changed()

    do case
    case( name = 'tmhlassow->nKodOkrSoc' )
      tmhlassow->cNazMisSoc
//      if empty( value )
//        ::msg:writeMessage('Variabilní symbol je povinný údaj ...',DRG_MSG_ERROR)
//        lOk := .F.
//      endif

//    case( name = 'druhymzdw->nprnapnaho' )
//      if lOk .and. ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
//        ::onSave()
//      endif

    endcase

    drgVar:save()

  endif
return lOk




method MZD_hrozmenyzp_CRDw:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

return self



method MZD_hrozmenyzp_CRDw:zpracuj_podklady()
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
  *

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení', nSize, nHight)

////   pøednastavení první strany pøílohy
//  msprc_mo_a->( dbseek( mzddavhd->croobcpppv,,'MSPRMO17'))
  mh_copyFld( 'msprc_mo', 'tmhlassow', .t., .t. )

  do case
  case .not. Empty( msprc_mo->dDatVyst)
    tmhlassow->nTypAkce := 2
  case .not. Empty( msprc_mo->dDatNast)  //.and. Month( msprc_mo->dDatNast)>=
    tmhlassow->nTypAkce := 1
  otherwise
    tmhlassow->nTypAkce := 3
  endcase

  tmhlassow->dplatakce  := Date()
  tmhlassow->ddatzprac  := Date()

  tmhlassow->cnazevzame := AllTrim(SysConfig('System:cPodnik'))
  tmhlassow->cico       := AllTrim(Str(SysConfig('System:nIco')))
  tmhlassow->cZkratStaV := AllTrim(SysConfig('System:cZaklStat'))


  if trvzavhd->( dbseek( 'MGENODVSOC',,'TRVZAVHD01'))
    tmhlassow->cVarSymSoc := trvzavhd->cvarsym
*    tmhlassow->cNazMisSoc := trvzavhd->cnazev

    if firmy->( dbseek( trvzavhd->ncisfirmy,,'FIRMY01'))
      if c_okresy->( dbseek( Upper(firmy->cokres),,'C_OKRES1'))
        tmhlassow->nKodOkrSoc := c_okresy->nKodOkrSoc
        tmhlassow->cNazMisSoc := c_okresy->cNaz_Okres
      endif
    endif
  endif

  if c_pracvz->( dbseek( msprc_mo->ntyppravzt,,'C_PRACVZ01'))
    if c_prvzdc->( dbseek( c_pracvz->cTypPPVReg,,'C_PRVZDC01'))
      tmhlassow->cTypPPVReg := c_prvzdc->cTypPPVReg
      tmhlassow->cNazDruCin := c_prvzdc->cNazDruCin
    endif
  endif

  if osoby->( dbseek( msprc_mo->nOSOBY,,'ID'))
    tmhlassow->ctitul      := AllTrim(osoby->cTitulPred) +AllTrim(osoby->cTitulZa)
    tmhlassow->cJmenoRod   := osoby->cJmenoRod
    tmhlassow->cUlice      := osoby->cUlice
    tmhlassow->cCisPopis   := osoby->cCisPopis
*    tmhlassow->cUlicCiPop  := osoby->cUlicCiPop
    tmhlassow->cMisto      := osoby->cMisto
    tmhlassow->cPsc        := osoby->cPsc
    tmhlassow->cZkratStat  := osoby->cZkratStat
    tmhlassow->npohlavi    := if( osoby->nmuz=1,1,if(osoby->nzena=1,2,0))
    tmhlassow->ddatnaroz   := osoby->ddatnaroz
    tmhlassow->cMistoNar   := osoby->cMistoNar
    tmhlassow->cZkrStatPr  := osoby->cZkrStaPri
    tmhlassow->cPosta      := Left(osoby->cMisto,5)

    if tmhlassow->nTypAkce = 1
      tmhlassow->cUliceK    := tmhlassow->cUlice
      tmhlassow->cCisPopisK := tmhlassow->cCisPopis
*      tmhlassow->cUlicCiPoK :=
      tmhlassow->cMistoK    := tmhlassow->cMisto
      tmhlassow->cPscK      := tmhlassow->cPsc
      tmhlassow->cZkratStaK := tmhlassow->cZkratStat
      tmhlassow->cPostaK    := tmhlassow->cPosta
    endif
  endif

*  tmhlassow->dRozhObdOd := mh_FirstODate( mzdyhd_a->nrok, mzdyhd_a->nobdobi)
  npos := 1

////   pøednastavení druhé strany pøílohy

  if msprc_mo->ntypduchod > 0
    if c_duchod->( dbseek( msprc_mo->ntypduchod,,'C_DUCHOD01'))
      tmhlassow->cDuchod := c_duchod->cNazDuchod
    endif
    tmhlassow->lDuchod := .t.
  endif

  if osoby->( dbSeek( users->ncisosoby,,'OSOBY01' ))
    tmhlassow->cOsoba := osoby->cOsoba
  endif
//  endif

  tmhlassow->cTelefon   := AllTrim(SysConfig('System:cTelefon'))
  tmhlassow->dDatZprac  := Date()

  tmhlassow->(dbcommit())
  tmhlassow->(dbGoTop())

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení - dokonèeno', nSize, nHight)
**  Sleep(150)
**  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.