#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
*
#include "..\Asystem++\Asystem++.ch"


#xTranslate _cRx_Kod    => &(pa\[1 \])
#xTranslate _lRx_MR     => &(pa\[2 \])
#xTranslate _cRx_Od     => &(pa\[3 \])
#xTranslate _cRx_Do     => &(pa\[4 \])
#xTranslate _nRx_Dny    => &(pa\[5 \])
#xTranslate _cRx_Dny    => &(pa\[6 \])

// 7 ... 18 _cRx_Obd 01 ... 12

#xTranslate _cRx_Rok    => &(pa\[19 \])
#xTranslate _nRx_VylDob => &(pa\[20 \])
#xTranslate _cRx_VylDob => &(pa\[21 \])
#xTranslate _nRx_VymZak => &(pa\[22 \])
#xTranslate _cRx_VymZak => &(pa\[23 \])
#xTranslate _nRx_DobOde => &(pa\[24 \])
#xTranslate _cRx_DobOde => &(pa\[25 \])


*
*************** MZD_mzeldphd_CRD ***********************************************
CLASS MZD_mzeldphd_CRD FROM drgUsrClass
exported:
  var     task
  method  init, drgDialogStart, drgDialogEnd
  method  generuj_eldp

  inline access assign method obdobi_ELDP() var obdobi_ELDP
    return if( ::lnewRec, str(::obdobi,2) +'/' +str(::rok,4), ;
                          str(mzEldpHd->nobdobi,2) +'/' +str(mzEldpHd->nrok,4) )


  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1019
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    RETURN self

  inline method postValidate(drgVar)
    if( drgVar:changed(), drgVar:save(), nil )
    return .t.

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case ( nEvent = drgEVENT_SAVE )
      ::cmp_mzeldphd()

      if mzEldphdw->_nrecOr <> 0
        if mzEldphd->(dbRlock())
          mh_copyFld( 'mzeldphdw', 'mzEldpHd' )
        endif
      else
        mh_copyFld( 'mzeldphdw', 'mzEldpHd', .t. )
      endif
      mzEldpHd->( dbunlock(), dbCommit())
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      return .t.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE .or. ;
           nEvent = drgEVENT_SAVE        )
      return .t.

    endcase
  return .f.

hidden:
  method  gen_mzeldphd, cmp_mzeldphd
* sys
  var     msg, dm, dc, df, ab, oabro, xbp_therm, cparm
  var     oBtn_mzd_generuj_eldp
  var     cx_rows, cx_fields
* datové
  var     culoha, nrok, nobdobi, pa_obdZpr, radek
  var     lnewRec, rok, obdobi
ENDCLASS


method MZD_mzeldphd_CRD:init(parent)
  local  task := 'mzd'

  ::drgUsrClass:init(parent)

  ::lnewRec   := ( parent:cargo = drgEVENT_APPEND )
  ::rok       := uctOBDOBI:MZD:NROK
  ::obdobi    := uctOBDOBI:MZD:NOBDOBI

  ::cParm     := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm     := Left( ::cParm,1)
  ::radek     := 0
  ::cx_rows   :=  'cR._Kod   , lR._MR     , cR._Od     , cR._Do    ,'                         + ;
                  'nR._Dny   , cR._Dny    , '                                                 + ;
                  'cR._Obd01 , cR._Obd02  , cR._Obd03  , cR._Obd04 , cR._Obd05 , cR._Obd06, ' + ;
                  'cR._Obd07 , cR._Obd08  , cR._Obd09  , cR._Obd10 , cR._Obd11 , cR._Obd12, ' + ;
                  'cR._Rok   , '                                                              + ;
                  'nR._VylDob, cR._VylDob , '                                                 + ;
                  'nR._VymZak, cR._VymZak , '                                                 + ;
                  'nR._DobOde, cR._DobOde '

  ::cx_fields   := strTran( ::cx_rows, ' ', '')

  if isArray(parent:parent:odBrowse)
    if( len(parent:parent:odBrowse)) >= 1
      ::oabro := parent:parent:odBrowse[1]
    endif
  endif


  drgDBMS:open('msprc_mo')
  drgDBMS:open('osoby'   )
  drgDBMS:open('trvzavhd')
  drgDBMS:open('firmy'   )

  drgDBMS:open('mzdyHd'  )
  drgDBMS:open('mzdyIt'  )

  drgDBMS:open('c_okresy')
  drgDBMS:open('c_pracvz')
  drgDBMS:open('c_prvzdc')
  drgDBMS:open('c_duchod')
  drgDBMS:open('c_psc',,,,,'c_psca')
  *
  drgDBMS:open('mzeldphdw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
return self


method MZD_mzeldphd_CRD:drgDialogStart(drgDialog)

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
//   ::ab         := drgDialog:oActionBar:members      // actionBar
//  ::oabro      := drgDialog:dialogCtrl:obrowse
  *
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  if ::lnewRec
    ::generuj_eldp()
  else
    mh_copyFld( 'mzEldpHd', 'mzEldpHdw',.t., .t.)
  endif
/*
  if msPrc_mo->lgenerELDP
    if .not. mzEldpHd->( eof())
      mh_copyFld( 'mzEldpHd', 'mzEldpHdw',.t., .t.)
    else
      ::generuj_eldp()
    endif
  endif
*/
  if( isObject( ::oabro), setAppFocus( ::oabro:oxbp ), nil )
  ::dm:refresh()
return self


method MZD_mzeldphd_CRD:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

return self



method MZD_mzeldphd_CRD:generuj_eldp()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  nod, ndo
  local  filtrs
  *
  local  cky, ncisRadku := 1, ncisListu := 1
//  local  nSize     := ::xbp_therm:currentSize()[1]
//  local  nHight    := ::xbp_therm:currentSize()[2]
  local  celkem    := 0
  local  xx, yy
  *

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení', nSize, nHight)


  mh_copyFld( 'msprc_mo', 'mzeldphdw', .t. )

  mzeldphdw->nmsprc_mo  := isNull( msprc_mo->sid, 0)
*  mzeldphdw->dOprELDP   := Date()
  mzeldphdw->crok       := Str(mzeldphdw->nrok,4,0)
  mzeldphdw->dDatVyhoEL := Date()
  mzeldphdw->cTypELDP   := if( Empty( msPrc_mo->dDatVyst), "01", "02")

  mzeldphdw->cpodnik     := AllTrim(SysConfig('System:cPodnik'))
  mzeldphdw->culiceorg   := AllTrim(SysConfig('System:cUliceOrg'))
  mzeldphdw->ccispoporg  := AllTrim(SysConfig('System:cCisPopOrg'))
  mzeldphdw->cmistoorg   := AllTrim(SysConfig('System:cSidlo'))
  mzeldphdw->cpscorg     := AllTrim(SysConfig('System:cPsc'))
  mzeldphdw->nicoorg     := SysConfig('System:nIco')

  if trvzavhd->( dbseek( 'MGENODVSOC',,'TRVZAVHD01'))
    mzeldphdw->cVarSym    := trvzavhd->cvarsym
    mzeldphdw->cNazMisSoc := trvzavhd->cnazev

    if firmy->( dbseek( trvzavhd->ncisfirmy,,'FIRMY01'))
      if c_okresy->( dbseek( Upper(firmy->cokres),,'C_OKRES1'))
        mzeldphdw->nKodOkrSoc := c_okresy->nKodOkrSoc
      endif
    endif
  endif

*  if c_pracvz->( dbseek( msprc_mo->ntyppravzt,,'C_PRACVZ01'))
*    if c_prvzdc->( dbseek( c_pracvz->cTypPPVReg,,'C_PRVZDC01'))
*      mzeldphdw->cTypPPVReg := c_prvzdc->cTypPPVReg
*      mzeldphdw->cNazDruCin := c_prvzdc->cNazDruCin
*    endif
*  endif

  if osoby->( dbseek( msprc_mo->nOSOBY,,'ID'))
    mzeldphdw->ctitulprac  := AllTrim(osoby->cTitulPred) +AllTrim(osoby->cTitulZa)
    mzeldphdw->cJmenoRod   := osoby->cJmenoRod
    mzeldphdw->cUlice      := osoby->cUlice
    mzeldphdw->cCisPopis   := osoby->cCisPopis
*    tmhlassow->cUlicCiPop  := osoby->cUlicCiPop
    mzeldphdw->cMisto      := osoby->cMisto
    mzeldphdw->cPsc        := osoby->cPsc
    mzeldphdw->cZkratStat  := osoby->cZkratStat

    if c_psca->( dbseek( Upper(osoby->cPsc),,'C_PSC1'))
      mzeldphdw->cposta := Left( AllTrim( StrTran( Upper( c_psca->cMisto),' ','')),5)
    else
      mzeldphdw->cposta := Left(osoby->cMisto,5)
    endif

    mzeldphdw->cZkratNar   := osoby->cZkratNar
    mzeldphdw->cZkrStaPri  := osoby->cZkrStaPri

    if .not. Empty( msprc_mo->cSocPojCP)
      mzeldphdw->cRodCisPrE  := AllTrim(StrTran( StrTran(msprc_mo->cSocPojCP,'-',''),'/',''))
    else
      mzeldphdw->cRodCisPrE  := AllTrim(StrTran( StrTran(osoby->cRodCisOsb,'-',''),'/',''))
    endif

    mzeldphdw->dDatNaroz   := osoby->dDatNaroz
    mzeldphdw->cMistoNar   := osoby->cMistoNar
    mzeldphdw->cZkrStatNa  := osoby->cZkrStatNa
  endif


*  tmhlassow->dRozhObdOd := mh_FirstODate( mzdyhd_a->nrok, mzdyhd_a->nobdobi)
  npos := 1
  ::gen_mzeldphd()


////   pøednastavení druhé strany pøílohy

*  if msprc_mo->ntypduchod > 0
*    if c_duchod->( dbseek( msprc_mo->ntypduchod,,'C_DUCHOD01'))
*      mzeldphdw->cDuchod := c_duchod->cNazDuchod
*    endif
*    mzeldphdw->lDuchod := .t.
*  endif

  mzeldphdw->(dbcommit())

**  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro EVD hlášení - dokonèeno', nSize, nHight)
**  Sleep(150)
**  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.


method MZD_mzeldphd_CRD:gen_mzeldphd()
  local cKOD, cKOD3, cX, cY
  local nstep, nX, nY
  local dzac, czac
  local dkon, ckon

  local aval := fTESTmzdy()
  local pa, aX

  pa := listAsArray( strTran( ::cx_fields, '.', '1'))

   DO CASE
   CASE msPrc_mo ->nTypPraVzt == 6  ; cKOD := "A"  // dohoda o provedení práce
   CASE msPrc_mo ->nTypZamVzt == 2  ; cKOD := "1"  // èlen dru§stva
   CASE msPrc_mo ->nTypZamVzt == 3  ; cKOD := "S"  // spoleŸník s.r.o.
   CASE msPrc_mo ->nTypZamVzt == 9  ; cKOD := "L"  // domácký pracovník
   CASE msPrc_mo ->nTypZamVzt == 15 ; cKOD := "R"  // jednatel s.r.o.
   CASE msPrc_mo ->nTypZamVzt == 14 ; cKOD := "R"  // komanditista
   CASE msPrc_mo ->nTypZamVzt == 16 ; cKOD := "K"  // dobrovolný pracovník peèovatelské služby
   CASE msPrc_mo ->nTypZamVzt == 13 ; cKOD := "N"  // zamìstnanec na nepravidelnou výpomoc
   OTHERWISE                        ; cKOD := "1"  // zamìstnanec
   ENDCASE

   DO CASE
   CASE msPrc_mo ->lStatuZast
     cKOD3 := "S"
   CASE msPrc_mo ->nTypZamVzt == 98
     cKOD3 := "T"
   OTHERWISE
     cKOD3 := "+"
   ENDCASE

   if aval[19]
     dZac := if( msPrc_mo->ddatNast < mh_firstODate( msPrc_mo->nrok, 1), ;
                  mh_firstODate( msPrc_mo->nrok,1), msPrc_mo->ddatNast)
     cZac := Str( Day( dZac), 2) +"." +Str( Month( dZac), 2) +"."

     dKon := if( empty( msPrc_mo->ddatVyst), mh_lastODate( msPrc_mo->nrok, 12), ;
                 if( msPrc_mo->ddatVyst < mh_lastODate( msPrc_mo->nrok, 12)   , ;
                     msPrc_mo->ddatVyst, mh_lastODate( msPrc_mo->nrok, 12))     )
     cKon := Str( Day( dKon), 2) +"."  +Str( Month( dKon), 2) +"."

     mzelDphdw->_cRx_Kod := cKOD +IF( aval[21], "D", "+") +cKOD3
     mzelDphdw->_lRx_MR  := msPrc_mo->lzamMalRoz
     mzelDphdw->_cRx_Od  := padc( strTran( cZac, ' ', ''), 6)
     mzelDphdw->_cRx_Do  := padc( strTran( cKon, ' ', ''), 6)
     mzelDphdw->_nRx_Dny := ( dKon - dZac) + 1

     if aval[18]
       mzelDphdw->_cRx_Rok := 'X'
       mzelDphdw->_nRx_Dny := 0
     else
       for nstep := 1 to 12 step 1
         if aval[nstep]
           do case
           case nstep = month( dZac )
             nX := ( Day( mh_lastODate( msPrc_mo->nrok, nstep)) -day(dZac)) +1
           case nstep = month( dKon )
             nX := day( dKon)
           otherwise
             nX := day( mh_lastODate( msPrc_mo->nrok, nstep))
           endcase

           mzelDphdw->&(pa[nstep +6]) := 'X'
           mzelDphdw->_nRx_Dny        -= nX
         endif
       next
     endif

     aX := fVYLdoba()
     nX := 0

     if .not. empty( ax[1] )
       for nstep := 1 to len( ax[1]) step 1
         if ax[1, nstep, 1] = 'M'
           mzelDphdw->cVCM1_Druh := aX[1,nstep,1]
           mzelDphdw->cVCM1_Od   := aX[1,nstep,2]
           mzelDphdw->cVCM1_Do   := aX[1,nstep,3]
         endif
         nX += aX[1,nstep,4]
       next
     endif
     mzelDphdw->_nRx_VylDob := if( nX -aval[23] > 0, if( nX -aval[23] > 999, 999, nx -aval[23]), 0 )
     mzelDphdw->_nRx_VymZak := aval[17]


     * 2 øádek
     pa := listAsArray( strTran( ::cx_fields, '.', '2'))
     if .not. empty( ax[2])
       mzelDphdw->_cRx_Kod    := cKOD + aX[2,1,1]+ cKOD3
//       mzelDphdw->_cRx_Kod    := cKOD + aX[2,n,1]+ cKOD3
       mzelDphdw->_cRx_Od     := ax[2,1,2]
       mzelDphdw->_cRx_Do     := ax[2,1,3]
       mzelDphdw->_cRx_Dny    := Str( if( ax[2,1,4] >0, if( ax[2,1,4] >999, 999, ax[2,1,4]), 0))
       mzelDphdw->_nRx_VylDob := if( ax[2,1,4] >0, if( ax[2,1,4] >999, 999, ax[2,1,4]), 0)

       if ax[2,1,1] = 'M'
         mzelDphdw->cVCM2_Druh := aX[2,1,1]
         mzelDphdw->cVCM2_Od   := aX[2,2,2]
         mzelDphdw->cVCM2_Do   := aX[2,3,3]
       endif
     endif

     * 3 øádek
     pa := listAsArray( strTran( ::cx_fields, '.', '3'))
     if aval[20] <> 0
       mzelDphdw->_cRx_Kod     := cKOD +"P" +cKOD3
       mzelDphdw->_nRx_VymZak := aval[20]
     endif

     ::cmp_mzeldphd()
   endif

return .t.


method MZD_mzeldphd_CRD:cmp_mzeldphd()
  local         cX, cY
  local  nstep, nX, nY
  local  pa

  mzelDphdw->ncelVylDob := mzelDphdw->nR1_VylDob + ;
                           mzelDphdw->nR2_VylDob + ;
                           mzelDphdw->nR3_VylDob
  mzelDphdw->ncelVymZak := mzelDphdw->nR1_VymZak + ;
                           mzelDphdw->nR2_VymZak + ;
                           mzelDphdw->nR3_VymZak
  mzelDphdw->ncelDobOde := mzelDphdw->nR1_DobOde + ;
                           mzelDphdw->nR2_DobOde + ;
                           mzelDphdw->nR3_DobOde

  * konec
  for nstep := 1 to 3 step 1
    nX := nY := 0
    cY := ''
    pa := listAsArray( strTran( ::cx_fields, '.', str(nstep,1)))

    mzelDphdw->_cRx_Dny    := if( mzelDphdw->_nRx_Dny    <>0, padR( str( mzelDphdw->_nRx_Dny   ,4), 4), '')
// ?    mzelDphdw->_cRx_Rok    := str( mzelDphdw->nrok, 4)
    mzelDphdw->_cRx_VylDob := if( mzelDphdw->_nRx_VylDob <>0, padR( str( mzelDphdw->_nRx_VylDob,3), 3), '')

    if mzelDphdw->_nRx_VymZak <> 0
      cX := padR( str( mzelDphdw->_nRx_VymZak, 10), 10)
      cY := subStr(cX, 2, 3) +' ' +subStr(cX, 5, 3) +' '+ subStr( cX, 8, 3)
    endif

    mzelDphdw->_cRx_VymZak := padR( cY, 12)
    mzelDphdw->_cRx_DobOde := if( mzelDphdw->_nRx_DobOde <>0, padR( str( mzelDphdw->_nRx_DobOde, 3), 3), '')
  next

  cX := cY := ''
  mzelDphdw->ccelVylDob := if( mzelDphdw->ncelVylDob <>0, padR( str( mzelDphdw->ncelVylDob, 5), 5), '')

  if mzelDphdw->ncelVymZak <> 0
    cX := padR( str( mzelDphdw->ncelVymZak, 12), 12)
    cY := subStr( cX, 4, 3) +' ' +subStr( cX, 7, 3) +' ' +subStr( cX, 10, 3)
  endif

  mzelDphdw->ccelVymZak := padR( cY, 12)
  mzelDphdw->ccelDobOde := if( mzelDphdw->ncelDobOde <>0, padR( str( mzelDphdw->ncelDobOde, 5), 5), '')
return self


static function fTESTmzdy()
  LOCAL  aRET :={ .F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F., ;
                  0,"",0,0,0,.F.,.F.,0, .F.,0,0}  // zák.soc.poj.,
  LOCAL  nX
  LOCAL  lMimoPV
  *
  local  cky := strZero( msPrc_mo->nrok,4)        + ;
                strZero( msPrc_mo->nosCisPrac, 5) + ;
                strZero( msPrc_mo->nporPraVzt, 3)

  mzdyHd->( ordSetFocus( 'MZDYHD06' ), dbSetScope( SCOPE_BOTH, cky), DbGoTop())

  do while .not. mzdyHd->( eof())
    lMimoPV := .F.

    if .not. empty( msPrc_mo->ddatVyst)
      do case
      case year( msPrc_mo->ddatVyst) < mzdyHd->nrok
        lMimoPV := .T.

      case year( msPrc_mo->ddatVyst) = mzdyHd->nrok
        if month( msPrc_mo->ddatVyst) < mzdyHd->nobdobi
          lMimoPV := .T.
        endif
      endcase
    endif

    if msPrc_mo->lstavem
      nX := mzdyHd->ndnyFondPD - mzdyHd->ndnyNeodPD
      aRET[mzdyHd->nobdobi] := ( mzdyHd->nZaklSocPo = 0 .and. nX <= 0 .and. mzdyHd->nHodNemoc = 0 .and. mzdyHd->nDnyNemoKD = 0 )
    endif

    aRET[13] :=        mzdyHd->nrok
    aRET[14] := right( mzdyHd->cobdobi, 2)
    aRET[15] +=        mzdyHd->nFondKDDn
    aRET[16] +=        mzdyHd->nDnyNemoKD
    aRET[17] += if( .not. lMimoPV, mzdyHd->nZaklSocPo, 0)
    aRET[19] := .t.
    aRET[20] += if(       lMimoPV, mzdyHd->nZaklSocPo, 0)
    aRET[21] := if( mzdyHd->ntypDuchod >= 1 .and. mzdyHd->ntypDuchod <= 4, .t., .f.)
    aRET[22] += mzdyHd->ndnyVylocD

    if ( mzdyHd->nfondKDDn = mzdyHd->ndnyVylocD .and. mzdyHd->nzaklSocPo > 0 )
      aRET[23] += mzdyHd->nDnyVylDOD
    endif

    mzdyHd ->( dbSkip())
  enddo

  mzdyHd->( dbclearScope())

  *
  aRET[18] := aRET[1] .AND. aRET[2] .AND. aRET[3] .AND. aRET[4]             ;
              .AND. aRET[5] .AND. aRET[6] .AND. aRET[7] .AND. aRET[8]       ;
                .AND. aRET[9] .AND. aRET[10] .AND. aRET[11] .AND. aRET[12]

  IF aRET[16] = 0 .AND. aRET[17] = 0 .AND. aRET[20] = 0                     ;
      .AND. !( aRET[1] .OR. aRET[2] .OR. aRET[3] .OR. aRET[4] .OR. aRET[5]  ;
               .OR. aRET[6] .OR. aRET[7] .OR. aRET[8] .OR. aRET[9]          ;
                .OR. aRET[10] .OR. aRET[11] .OR. aRET[12])
     aRET[19] := .F.
  ENDIF

  IF aRET[18]
    aRET[1] := aRET[2] := aRET[3] := aRET[4] := aRET[5] := aRET[6] :=       ;
    aRET[7] := aRET[8] := aRET[9] := aRET[10] := aRET[11] := aRET[12] := .F.
  ENDIF
return aRET


static function fVYLdoba()
  local  aRET := {}
  local  avylD := {}, avylDO := {}

  local  noldPoradi := 0, nvylD := 0, nX
  local  cX1n, cX2n, cX3n, cX1, cX2, cX3
  local  lOCHRdob   := .F.
  local  dzacN, dkonN, dzacO, dkonO
  *
  local  cf := "nrok = %% .and. nosCisPrac = %% .and. nporPraVzt = %% .and. cdenik = 'MN'"
  local  cfiltr

  cfiltr := format( cf, {msPrc_mo->nrok,msPrc_mo->nosCisPrac,msPrc_mo->nporPraVzt})
  mzdyIt->( ads_setAof( cfiltr ), dbgoTop() )


  do while .not. mzdyIt->( eof())
    if mzdyIt->nDnyVylocD <> 0
      if noldPoradi <> mzdyIt->nPoradi
        dzacN := mzdyIt ->ddatumOd
        dkonN := if( mzdyIt->nDnyVylDOD = 0, mzdyIt->ddatumDo, mzdyIt->ddatumDo -mzdyIt->ndnyVylDOD)
        nvylD := mzdyIt->ndnyVylocD

        do case
        case mzdyIt->ndruhMzdy = 414 .or. mzdyIt->ndruhMzdy = 415
          cX1n := "R"
        case mzdyIt->ndruhMzdy = 421
          cX1n := "M"
        otherwise
          cX1n := "N"
        endcase

      else
        dkonN := if( mzdyIt->ndnyVylDOD = 0, mzdyIt->ddatumDo, mzdyIt->ddatumDo -mzdyIt->ndnyVylDOD)
        nvylD += mzdyIt->ndnyVylocD
      endif
    endif

    if mzdyIt->ndnyVylDOD <> 0
      if noldPoradi <> mzdyIt->nPoradi .or. empty( dZacO )
        dzacO := if( mzdyIt->ndnyVylocD = 0, mzdyIt->ddatumOd, mzdyIt->ddatumOd +mzdyIt->ndnyVylocD)
        dkonO := mzdyIt->ddatumDo

        do case
        case mzdyIt->ndruhMzdy = 414 .or. mzdyIt->ndruhMzdy = 415
          cX1 := "R"
        case mzdyIt ->nDruhMzdy = 421
          cX1 := "M"
        otherwise
          cX1 := "N"
        endcase

        lOCHRdob := .T.
        nX := mzdyIt->ndnyVylDOD

      else
        dkonO := mzdyIt->ddatumDo
        nX    += mzdyIt->ndnyVylDOD
      endif
    endif
    noldPoradi := mzdyIt->nPoradi
    mzdyIt->( dbSkip())

//    if .not. mzdyIt->( eof())
      if ( noldPoradi <> mzdyIt->nPoradi .and. nvylD <> 0) .or.      ;
            ( mzdyIt->( eof()) .and. nvylD <> 0)
        cX2n := str( day( dzacN)) +"." +str( month( dzacN)) +"."
        cX3n := str( Day( dkonN)) +"." +str( month( dkonN)) +"."
        cX2n := PADC( StrTran( cX2n," ",""), 6)
        cX3n := PADC( StrTran( cX3n," ",""), 6)
        AAdd( aVylD, { cX1n,cX2n,cX3n,nVylD})
      endif

      if ( noldPoradi <> mzdyIt->nPoradi .and. lOCHRdob )  .or.      ;
            ( mzdyIt->( eof()) .and. lOCHRdob)
        lOCHRdob   := .F.
        cX2 := Str( Day( dZacO)) +"." +Str( Month( dZacO)) +"."
        cX3 := Str( Day( dKonO)) +"." +Str( Month( dKonO)) +"."
        cX2 := PADC( StrTran( cX2," ",""), 6)
        cX3 := PADC( StrTran( cX3," ",""), 6)
        AAdd( aVylDO, { cX1,cX2,cX3,nX})
      endif
//    endif
  enddo

  AAdd( aRET, aVylD)
  AAdd( aRET, aVylDO)
  mzdyIt->( ads_clearAof())
return aRET