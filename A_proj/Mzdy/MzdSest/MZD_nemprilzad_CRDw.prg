#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
*
#include "..\Asystem++\Asystem++.ch"


*
*************** MZD_nem_prilzad ***********************************************
CLASS MZD_nemprilzad_CRDw FROM drgUsrClass
exported:
  var     task
  method  init, drgDialogStart, drgDialogEnd
  method  postValidate
  method  zpracuj_podklady

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE  )
      return .t.

    case ( nEvent = drgEVENT_SAVE   .or. ;
           nEvent = drgEVENT_QUIT    )
      tmprinemw->nZapPrijCe := tmprinemw->nZapPrij01+tmprinemw->nZapPrij02+tmprinemw->nZapPrij03+   ;
                               tmprinemw->nZapPrij04+tmprinemw->nZapPrij05+tmprinemw->nZapPrij06+   ;
                               tmprinemw->nZapPrij07+tmprinemw->nZapPrij08+tmprinemw->nZapPrij09+   ;
                               tmprinemw->nZapPrij10+tmprinemw->nZapPrij11+tmprinemw->nZapPrij12

      tmprinemw->nVylDobaCe := tmprinemw->nVylDoba01+tmprinemw->nVylDoba02+tmprinemw->nVylDoba03+   ;
                               tmprinemw->nVylDoba04+tmprinemw->nVylDoba05+tmprinemw->nVylDoba06+   ;
                               tmprinemw->nVylDoba07+tmprinemw->nVylDoba08+tmprinemw->nVylDoba09+   ;
                               tmprinemw->nVylDoba10+tmprinemw->nVylDoba11+tmprinemw->nVylDoba12

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


method MZD_nemprilzad_CRDw:init(parent)
  local  task := 'mzd'

  ::drgUsrClass:init(parent)
  ::cParm    := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm    := Left( ::cParm,1)
  ::radek    := 0

  ::oabro    := parent:parent:odBrowse[1]

  drgDBMS:open('osoby' )

  drgDBMS:open('msprc_mo',,,,,'msprc_mo_a')
  drgDBMS:open('msvprum',,,,,'msvprum_a')
  drgDBMS:open('mzdyhd',,,,,'mzdyhd_a')
  drgDBMS:open('mzddavhd')
  drgDBMS:open('mzddavit')

  drgDBMS:open('trvzavhd')
  drgDBMS:open('firmy')
  drgDBMS:open('c_okresy')
  drgDBMS:open('c_pracvz')
  drgDBMS:open('c_prvzdc')
  drgDBMS:open('c_duchod')

// toto by mìlo pøijít ven - doèasné øešení - nevím proè MZDDAVHD neodkazuje na
// doklad na kterém stojím
  if mzddavit->ndoklad <> 0
    mzddavhd->( dbSeek(mzddavit->ndoklad,,'MZDDAVHD11'))
  endif
////

  *
  drgDBMS:open('tmprinemw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
return self


method MZD_nemprilzad_CRDw:drgDialogStart(drgDialog)

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

method MZD_nemprilzad_CRDw:postValidate(drgVar)
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
    case( name = 'tmprinemw->nKodOkrSoc' )
      tmprinemw->cNazMisSoc

//    case( name = 'tmprinemw->nKodOkrSoc' )
//      tmprinemw->cNazMisSoc
//      if empty( value )
//        ::msg:writeMessage('Variabilní symbol je povinný údaj ...',DRG_MSG_ERROR)
//        lOk := .F.
//      endif

//    case( name = 'druhymzdw->nprnapnaho' )
//      if lOk .and. ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
//        ::onSave()
//      endif

    endcase
  endif

  drgVar:save()

return lOk



method MZD_nemprilzad_CRDw:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

return self



method MZD_nemprilzad_CRDw:zpracuj_podklady()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  nod, ndo
  local  nrokna, nobdna
  local  nrokod, nobdod
  local  nrokdo, nobddo
  local  filtrs, nzarokobd
  local  n, m, obd
  local  npocet
  local  minR, dlastObd
  *
  local  cky, ncisRadku := 1, ncisListu := 1
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2]
  local  celkem    := 0
  local  xx, yy
  local  tmOd, tm
  local  dalsi := .t.
  local  neZpet := .f.
  *

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení', nSize, nHight)

////   pøednastavení první strany pøílohy
  msprc_mo_a->( dbseek( mzddavhd->croobcpppv,,'MSPRMO17'))
  mh_copyFld( 'msprc_mo_a', 'tmprinemw', .t., .t. )

  if trvzavhd->( dbseek( 'MGENODVSOC',,'TRVZAVHD01'))
    tmprinemw->cVarSymSoc := trvzavhd->cvarsym
*    tmprinemw->cNazMisSoc := trvzavhd->cnazev

    if firmy->( dbseek( trvzavhd->ncisfirmy,,'FIRMY01'))
      if c_okresy->( dbseek( Upper(firmy->cokres),,'C_OKRES1'))
        tmprinemw->nKodOkrSoc := c_okresy->nKodOkrSoc

        tmprinemw->cNazMisSoc := c_okresy->cNaz_Okres
      endif
    endif
  endif

  tmprinemw->cNazevZame := AllTrim( SysConfig( "System:cPodnik" ))
  tmprinemw->cIco       := AllTrim( Str( SysConfig( "System:nICO" )))
  tmprinemw->cTelefon   := AllTrim( SysConfig( "System:cTelefon" ))
  tmprinemw->cEmail     := AllTrim( SysConfig( "System:cEmail" ))
  tmprinemw->cMisto     := AllTrim( SysConfig( "System:cSidlo" ))

  do case
  case mzddavhd->ctyppohybu = 'NEMPPM'      ;  tmprinemw->lPenPomMat := .t.
  case mzddavhd->ctyppohybu = 'NEMVPTM'     ;  tmprinemw->lVyrPriTeh := .t.
  case mzddavhd->ctyppohybu = 'NEMOTCPOPE'  ;  tmprinemw->lOtcovska  := .t.
  case mzddavhd->ctyppohybu = 'NEMOCR'      ;  tmprinemw->cCisRozOcr := StrTran(mzddavhd->cCisRozNem,' ','')
  case mzddavhd->ctyppohybu = 'NEMDLOSET'   ;  tmprinemw->cCisRozDlP := StrTran(mzddavhd->cCisRozNem,' ','')
  otherwise                                 ;  tmprinemw->cCisRozNem := StrTran(mzddavhd->cCisRozNem,' ','')
  endcase

  if c_pracvz->( dbseek( msprc_mo_a->ntyppravzt,,'C_PRACVZ01'))
    if c_prvzdc->( dbseek( c_pracvz->cTypPPVReg,,'C_PRVZDC01'))
      tmprinemw->cTypPPVReg := c_prvzdc->cTypPPVReg
      tmprinemw->cNazDruCin := c_prvzdc->cNazDruCin
    endif
  endif

  nrokna := Year( msprc_mo_a->ddatnast)
  nobdna := Month( msprc_mo_a->ddatnast)
  nrokod := Year( mzddavhd->dDatumOd)
  nobdod := Month( mzddavhd->dDatumOd)

  if (nrokna = nrokod)
    if (nobdna = nobdod)
      if ( mzddavhd->dDatumOd - msprc_mo_a->ddatnast ) > 7
        tmprinemw->dRozhObdOd := msprc_mo_a->ddatnast
        nobdod := nobdod + 1
        nobddo := Month( mzddavhd->dDatumOd)
      else

      endif
    else
      nrokod := Year( msprc_mo_a->ddatnast)
      nobdod := Month( msprc_mo_a->ddatnast)
      tmprinemw->dRozhObdOd := msprc_mo_a->ddatnast
//    nobddo := nobdod -1
      nrokdo := Year( mzddavhd->dDatumOd)
      nobddo := Month( mzddavhd->dDatumOd) - 1
//      tmprinemw->dRozhObdOd := mh_FirstODate( nrokod-1, nobdod)
    endif
  else
    nobddo := nobdod -1

    if  (mzddavhd->dDatumOd - msprc_mo_a->ddatnast) > 365
      tmprinemw->dRozhObdOd := mh_FirstODate( nrokod-1, nobdod)
    else
      tmprinemw->dRozhObdOd := msprc_mo_a->ddatnast
      nobdod :=  Month( msprc_mo_a->ddatnast)
    endif

//    if nobdod > Month( msprc_mo_a->ddatnast)
//    else
//    endif

  endif

//  if mprinemw->dRozhObdOd < msprc_mo_a->ddatnast
//    nobdod := Month( msprc_mo_a->ddatnast)
//    tmprinemw->dRozhObdOd := msprc_mo_a->ddatnast
//  endif

  if nobdod > nobddo
    npocet := (12 - nobdod + 1) + nobddo
    minR := 1
  else
    npocet := nobddo - nobdod + 1
    minR := 0
  endif

  nod  := ( ( nrokod-minR)*100) + nobdod
  ndo  := ( nrokod*100) + nobddo

  m   := 0
  obd := nobdod+m

  for n := 1 to npocet
    if obd < 12 .and. dalsi
      obd := nobdod+m
      nzarokobd := ((nrokod-minR )*100) + obd
    else
      if  obd = 12  .and. dalsi
        nzarokobd := ((nrokod-minR )*100) + obd
      else
        obd := m
        nzarokobd := ( nrokod *100)    + obd
      endif
    endif

    if obd = 12 .and. dalsi
      m      := 0
      dalsi  := .f.
    endif

    cx := 'cKalMeRo'+StrZero( n, 2)
    tmprinemw->&cx := Right( Str(nzarokobd,6),2) + '/' + Left(Str(nzarokobd,6),4)

    filtrs := Format("noscisprac = %% .and. nporpravzt = %% .and. nrokobd = %%",     ;
                       {mzddavhd->noscisprac,mzddavhd->nporpravzt, nzarokobd})

    ** MZDYHD - vypoètené èisté mzdy
    mzdyhd_a->( Ads_setAOF(filtrs), dbgoTop() )

    if mzdyhd_a->( Ads_GetKeyCount(1)) > 0
      cx := 'nZapPrij'+StrZero( n, 2)
      tmprinemw->&cx := mzdyhd_a->nZaklSocPo
      cx := 'nVylDoba'+StrZero( n, 2)
      tmprinemw->&cx := mzdyhd_a->nDnyVylocD + mzdyhd_a->nDnyVylDOD
    else

    endif

    tmprinemw->nZapPrijCe += mzdyhd_a->nZaklSocPo
    tmprinemw->nVylDobaCe += mzdyhd_a->nDnyVylDZN

    mzdyhd_a->( ads_clearAof())
    m++
  next

  nobddo :=  Val(Right( Str(nzarokobd,6),2))
  nrokdo :=  Val(Left(Str(nzarokobd,6),4))
  tmprinemw->dRozhObdDo := mh_LastODate( nrokdo, nobddo)

  if tmprinemw->dRozhObdDo < msprc_mo_a->ddatnast
    dlastObd := mh_LastODate( Year( msprc_mo_a->ddatnast), Month( msprc_mo_a->ddatnast))
    tmprinemw->dRozhObdDo := dlastObd
    if tmprinemw->nZapPrijCe = 0
      if msvprum_a->( dbseek( msprc_mo_a->croobcpppv,,'PRUMV_06'))
        tmprinemw->nPravdPrij = msvprum_a->nPruMesMzH
      endif
    endif
  endif

/*
//  ndo  := ( if( nobdod = 1, nrokod-1, nrokod)*100) +if( nobdod=1, 12, nobdod-1)
//  tm   := ( nrokod-1)*100)

  tmOd := mh_FirstODate( nrokod-1, nobdod)
  if tmOd < msprc_mo_a->dDatNast
    nod := ( Year( msprc_mo_a->dDatNast)*100) + Month( msprc_mo_a->dDatNast)

    nrokod := Year( msprc_mo_a->dDatNast)
    nobdod := Month( msprc_mo_a->dDatNast)
  else
    nrokod := nrokod-1
  endif

  tmprinemw->dRozhObdOd := mh_FirstODate( nrokod, nobdod)

  filtrs := Format("noscisprac = %% .and. nporpravzt = %% .and. nrokobd >= %% .and. nrokobd <= %%",     ;
                     {mzddavhd->noscisprac,mzddavhd->nporpravzt, nod,ndo})

    ** MZDYHD - vypoètené èisté mzdy
  mzdyhd_a->( Ads_setAOF(filtrs), dbgoTop() )
  mzdyhd_a->( AdsSetOrder( 'MZDYHD07') )

//  tmprinemw->dRozhObdOd := mh_FirstODate( mzdyhd_a->nrok, mzdyhd_a->nobdobi)
  npos := 1
  do while .not. mzdyhd_a->(eof())
    pa_napocet := {}

    cx := 'cKalMeRo'+StrZero( npos, 2)
    tmprinemw->&cx := StrZero(mzdyhd_a->nobdobi,2) + '/' + StrZero(mzdyhd_a->nrok,4)
    cx := 'nZapPrij'+StrZero( npos, 2)
    tmprinemw->&cx := mzdyhd_a->nZaklSocPo
    cx := 'nVylDoba'+StrZero( npos, 2)
    tmprinemw->&cx := mzdyhd_a->nDnyVylocD + mzdyhd_a->nDnyVylDOD

    tmprinemw->dRozhObdDo := mh_LastODate( mzdyhd_a->nrok, mzdyhd_a->nobdobi)
    tmprinemw->nZapPrijCe += mzdyhd_a->nZaklSocPo
    tmprinemw->nVylDobaCe += mzdyhd_a->nDnyVylocD + mzdyhd_a->nDnyVylDOD
    npos++
    mzdyhd_a->(dbskip())
  enddo
*/
////   pøednastavení druhé strany pøílohy
  do while .not. mzddavit->( Eof())
    celkem += mzddavit->nProplN_Ho
    mzddavit->( dbSkip())
  enddo

  mzddavit->( dbGoTop())
  if celkem > 0
    tmprinemw->lPracNem   := .t.
    tmprinemw->nDelkSmDeN := fpracdoba(msprc_mo_a->cdelkprdob)[3]
    tmprinemw->nOdpHodNem := tmprinemw->nDelkSmDeN - celkem
  endif

  if msprc_mo_a->ntypduchod > 0
    if c_duchod->( dbseek( msprc_mo_a->ntypduchod,,'C_DUCHOD01'))
      tmprinemw->cTypDucReg := c_duchod->cTypDucReg
    endif
    tmprinemw->lDuchod := .t.
  endif

  if msprc_mo_a->lstudent
    xx := CtoD( '01.07.'+StrZero(mzddavhd->nrok))
    yy := CtoD( '31.08.'+StrZero(mzddavhd->nrok))
    tmprinemw->lObdPrazd := (msprc_mo_a->ddatnast >= xx .and. msprc_mo_a->ddatvyst <= yy)
    tmprinemw->lStudent  := .t.
  endif

  if osoby->( dbSeek( logCisOsoby,,'OSOBY01' ))
    tmprinemw->cOsoba     := osoby->cOsoba
  endif

  tmprinemw->dDatZprac := Date()

  tmprinemw->(dbcommit())
  tmprinemw->(dbGoTop())

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení - dokonèeno', nSize, nHight)
**  Sleep(150)
**  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.