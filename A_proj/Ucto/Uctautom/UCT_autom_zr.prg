#include "Common.ch"
#include "gra.ch"
#include "ads.ch"
#include "adsdbe.ch"
#include "dbstruct.ch'
//
// #include "asystem++.ch'
#include "..\Asystem++\Asystem++.ch"


static cdirW
static nlenS, nnazPol, paZR, paZRS
static ltyp_NVv, pAUTO_vy
static nlen_cnazPolX


*
********** VÝPOÈET dokadù ZÁSOBOVÉ REŽIE ***************************************
function UCT_autom_zr(xbp_therm)
  local  x, ckeyS  := 'strZero(nrok,4) +strZero(nobdobi,2)'
  local     ckeyV  := 'ucetkum->' +autom_hd->cnazPolx, lok, cvalV, cc, cky
  local     cnaklS := ' .not. Empty(ucetkum->' +autom_hd->cnazPolx +')'
  *
  local  lROZP___CO, lROZP__KAM, lROZP__AUT
  *
  local  recCnt, keyCnt, keyNo := 1

  cdirW         := AUTUc_dirW()
  nlen_cnazPolX := AUTUc_Ns(AUTOM_HD ->cNAZPOLx)

  ltyp_NVv      := AUTUc_typNVv()
  paAUTO_vy     := AUTUC_typV()

  ** vazba na výrobu
  drgDBMS:open('vyrzak')  ;  vyrzak->(ordSetFocus( AdsCTag( 7 )))
  drgDBMS:open('kalkul')  ;  kalkul->(ordSetFocus( AdsCtag( 3 )))

  autom_zr_tmp()     // pomocný soubor
  autom_zr_for()     // filtr pro ucetkum dle nastavení

  if ltyp_NVv
    ckeyS += ' +upper(cnazPol1) +upper(cnazPol2) +upper(cnazPol3)'  //*- +upper(cucetMd)'
  else
    ckeyS += ' +upper(cnazPo1) +upper(' +autom_hd->cnazPolx +')'    //*- +upper(cucetMd)'
  endif
  DbSelectArea('uckum_w')
  INDEX ON &(ckeyS) TO (cdirW +'uckum_w')

  *
  recCnt := ucetkum->( ads_getKeyCount(ADS_RESPECTFILTERS)) * 2
  keyCnt := recCnt / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)

  do while .not. ucetkum->(eof())
    aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt)

    AUTUc_cpy('ucetkum','uckum_w',.t.)
    ucetkum->(dbskip())
    keyNo++
  enddo

  ** zpracování **
  uckum_w->(dbGoTop())
  ckeyS := uckum_w->(sx_KeyData())

  AUTUc_cpy('uckum_w', 'testa', .t.)
  do while .not. uckum_w->(eof())
    aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt)

    if ckeyS = uckum_w->(sx_keyData())
      autom_zr_cmp()
    else
      AUTUc_cpy('uckum_w', 'testa', .t.)
      ckeyS := uckum_w->(sx_keyData())
      autom_zr_cmp()
    endif
    uckum_w->(dbSkip())
    keyNo++
  enddo

  testA->(dbGoTop())
  cnaklS := 'upper(testA->' +autom_hd->cnazPolx +')'

  do while .not. testa->(eof())
    if ltyp_NVv
      if vyrzak->(dbSeek( DBGetVal( cnaklS)))
        cc  := strZero(testA->nrok,4) +strZero(testA->nobdobi,2)
        cky := right  (vyrzak->(sx_KeyData()), 6 )
        testA->lROZP_ZR := ( cky == '000000' .or. ( cky >= cc ))
      else
        testA->lROZP_ZR := .f.
      endif
    else
      testA->lROZP_ZR := .T.
    endif

    for x := 1 To len(paZRS) Step 1
      if Eval( paZRS[x,3]) .or. Eval( paZRS[x,7])
        lROZP___CO := Eval( paZRS[x,4])
        lROZP__KAM := .F.
        lROZP__AUT := Eval( paZRS[x,4])

        If ltyp_NVv
          lROZP__KAM := ( testA->lROZP_ZR .and. vyrzak->ctypZAK <> 'R' )
          lROZP__KAM := ( lROZP__KAM      .and. .not. Eval( paZRS[x,7]))
        else
          lROZP__KAM := Eval( paZRS[x,5]) .and. .not. Eval( paZRS[x,7])
        endif

        if ( lROZP___CO .or. lROZP__KAM )
          if .not. testR ->( dbSeek( left( testA->(sx_KeyData()), 6) +strZero(x,2)))
             AUTUc_CPY( 'testA', 'testR', .t.)
             testR->nAUTOM_IT := x
          endif
          If( lROZP___CO, testR->nROZP___CO += ( testA->nNAKL_ZR -testA->nVYNO_ZR), NIL )
          If( lROZP__KAM, testR->nROZP__KAM += testA->nZAKL_ZR, Nil )
          If( lROZP__AUT, testR->nROZP__AUT += testA->nREZI_ZR, NIL )
        EndIf
      EndIf
    Next
    testA->(dbSkip())
  enddo

  testA   ->(dbGoTop())
  ucetkum ->(Ads_clearAof(),DbGoTop())

  autom_zr_gen()

  ** konec
  testA->(OrdListClear(), dbUnlock(), dbcloseArea())
  testR->(OrdListClear(), dbUnlock(), dbcloseArea())
return nil


* založení pomocných souboru
static function autom_zr_tmp()
  local x, ckeyS, cnazPol
  local astrU   := { { 'nROK'             , 'I',              2, 0 }, ;
                     { 'nOBDOBI'          , 'I',              2, 0 }, ;
                     { 'cOBDOBI'          , 'C',              5, 0 }, ;
                     { 'cNAZPOL1'         , 'C',              8, 0 }, ;
                     { AUTOM_HD ->cNAZPOLx, 'C',  nlen_cnazPolX, 0 }, ;
                     { 'nREZI_ZR'         , 'F',              8, 2 }, ;
                     { 'nNAKL_ZR'         , 'F',              8, 2 }, ;
                     { 'nVYNO_ZR'         , 'F',              8, 2 }, ;
                     { 'nZAKL_ZR'         , 'F',              8, 2 }, ;
                     { 'nROZP_ZR'         , 'F',              8, 2 }, ;
                     { 'lROZP_ZR'         , 'L',              1, 0 }  }
  local astruR := {  { 'nROK'             , 'I',              2, 0 }, ;
                     { 'nOBDOBI'          , 'I',              2, 0 }, ;
                     { 'cOBDOBI'          , 'C',              5, 0 }, ;
                     { 'cNAZPOL1'         , 'C',              8, 0 }, ;
                     { 'nAUTOM_IT'        , 'F',              2, 0 }, ;
                     { 'nROZP___CO'       , 'F',              8, 2 }, ;
                     { 'nROZP__KAM'       , 'F',              8, 2 }, ;
                     { 'nROZP__AUT'       , 'F',              8, 2 }  }

  nnazPol := val( right( autom_hd->cnazPolx, 1))
  nlenS   := 6 +( 8 * nNAZpol)

  for x := 2 to nnazPol -1 step 1
    cnazPol := 'cNAZPOL' +STR(x,1)
    AAdd( aSTRU, { cnazPol, 'C', AUTUc_Ns(cnazPol) , 0 } )
  next

  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2) +upper(cnazPol1)'
  ckeyS += if(ltyp_NVv, ' +upper(cnazPol2) +upper(cnazPol3)', ' +upper(' +autom_hd->cnazPolx +')')

  FErase(cdirW +'testA.adi')
  FErase(cdirW +'testA.adt')

  DbCreate(cdirW +'testA', aSTRu, oSession_free)
  DbUseArea(.t., oSession_free, cdirW +'testA',,.f.,.f.)
  DbSelectArea('testa')
  INDEX ON &(ckeyS) TO (cdirW +'testA')

   **
  FErase(cdirW +'testR.adi')
  FErase(cdirW +'testR.adt')

  DbCreate(cdirW +'testR', astruR, oSession_free)
  DbUseArea(.t., oSession_free, cdirW +'testR',,.f.,.f.)
  DbSelectArea('testR')

*-  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2) +upper(cnazPol1) +strZero(nautom_IT,2)'
  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2) +strZero(nautom_IT,2)'
  INDEX ON &(ckeyS) TO (cdirW +'testR')
return nil



static function autom_zr_for()                     //  PODMÍNKA INDEXOVÁNÍ
  Local  cC, cvyrP := '', cvyrM := '', cvyrC := '', cvyrN := '', cvyrE := '', cvyrS := '', cvyr
  Local  cCONDs
  *
  local  pa, n, x, sign, filter, cnaklS, npos, nposS

  paZR  := {}
  paZRS := {}

  aADD( paZR, { AUTOM_HD->cREZIUc_ZR, '', '', '' })
  aADD( paZR, { AUTOM_HD->cNAKLUc_ZR, '', '', '' })
  aADD( paZR, { AUTOM_HD->cVYNOUc_ZR, '', '', '' })
  aADD( paZR, { AUTOM_HD->cZAKLUc_ZR, '', '', '' })
  aADD( paZR, { AUTOM_HD->cROZPUc_ZR, '', '', '' })

  for n := 1 To len(paZR) step 1
    paZR[n,2] := If( AT( 'M', paZR[ N, 1]) <> 0, 'M', 'D' )
    cvyrN     := ''
    cvyrM     := ''
    cCONDs    := STRTRAN( paZR[ N, 1], 'M', ',')
    cCONDs    := STRTRAN( cCONDs     , 'D', ',')

    pa := listAsArray(cCONDs)
    for x := 1 to len(pa) step 1
      if .not. empty(cc := pa[x])
        sign := '+'
        if left(cc,1) $ '+,-'
          sign := left(cc,1)
          cc   := subStr(cc,2)
        endif

        if     sign = '+'
           cvyr  := " .or. left(cucetMd," +str(len(cc),len(cc)) +") = '" +cc +"'"
           cvyrP += cvyr
           cvyrN += cvyr
        else
           cvyrM += " .or. left(cucetMd," +str(len(cc),len(cc)) +") = '" +cc +"'"
        endif
      endif
    next

    paZR[N,3] := '(' +subStr(cvyrN,7) +')' +if( Empty(cvyrM), '', ' .and. !(' +substr(cvyrM,7) +')')
  next

  AEval(paZR, {|x,m| paZR[m,4] := COMPILE(x[3]) })

  cvyrC  := '(' +subStr(cvyrP,7) +')'
  cvyrE := ''
  cvyrP := ''
  cnaklS := 'testa->' +autom_hd->cnazPolx

  autom_it->(DbGoTop())

  do while .not. autom_it->(eof())
    cvyrN := 'testa->cnazPol1 >= "' +autom_it->cnazPol_OD +'" .and. ' + ;
             'testa->cnazPol1 <= "' +autom_it->cnazPol_DO +'"'
    cvyrS := 'testa->cnazPol1  = "' +autom_it->crozp__STR +'"'

    AAdd( paZRS, { autom_it->crozp___CO , ;
                   autom_it->cmrozp_KAM , ;
                   COMPILE( cvyrN)      , ;
                   'B_co'               , ;
                   'B_kam'              , ;
                   autom_it->( recNo()) , ;
                   COMPILE( cvyrS)      } )

    cvyrE += ' .or. (cnazPol1 = "' +autom_it->crozp__STR +'" )'

    for n := 1 to 2 step 1
      ccondS := Atail(paZRS)[n] +','
      cvyrM  := ''

      do while (npos := At(',', ccondS)) <> 0
        cc := subStr(ccondS, 1, npos-1)
        if (nposS := At('..', cc)) <> 0
          cvyrM += ' .or. ( ' +cnaklS +' >= "' +padR( substr( cc, 1, nposS-1), nlen_cnazPolX) + ;
                   '" .and. ' +cnaklS +' <= "' +padR( substr( cc,    nposS+2), nlen_cnazPolX) +'")'
        else
          cvyrM += ' .or. ' +cnaklS +' = "' +padR( cc, nlen_cnazPolX) +'"'
        endif
        ccondS := subStr(ccondS, npos+1)
      enddo
      Atail(paZRs)[n+3] := COMPILE(subStr(cvyrM,7))
    next

    cvyrP += ' .or. (cnazPol1 >= "' +autom_it->cnazPol_OD +'" .and. cnazPol1 <= "' +autom_it->cnazPol_DO + '")'
    autom_it->(dbSkip())
  enddo

  filter := "(strZero(nrok,4) = '" +strZero(autom_hd->nrok,4) +"'" + ;
            " .and. strZero(nobdobi,2) = '" +strZero(autom_hd->nobdobi,2) +"')"

  filter += ' .and. ('+ cvyrC +') .and. (' +substr(cvyrP,7) +' .or. (' +substr(cvyrE,7) +'))'
  ucetkum->(Ads_setAof(filter),DbGoTop())
return nil



static function autom_zr_cmp()                    //__ NÁPOÈET dle NASTAVENÍ ___
  Local  nMD  := DBGetVal( paAUTO_VY[1] )
  Local  nDAL := DBGetVal( paAUTO_VY[2] )

  dbSelectArea('uckum_w')

  Do Case
  Case UCETKUM ->cUCETmd = '7889'                          //__STS v DEM________
    nMD  := nMD  * 18.00
    nDAL := nDAL * 18.00
  Case UCETKUM ->cUCETmd = '7879'                          //__STS v EU_________
    nMD  := nMD  * 34.00
    nDAL := nDAL * 34.00
  EndCase

  If( EVAL( paZR[ 1, 4]), ;                                //__REŽIE____________
      testA->nREZI_ZR += If( paZR[ 1, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paZR[ 2, 4]), ;                                //__NÁKLADY__________
      testA->nNAKL_ZR += If( paZR[ 2, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paZR[ 3, 4]), ;                                //__VÝNOSY___________
      testA->nVYNO_ZR += If( paZR[ 3, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paZR[ 4, 4]), ;                                //__ZÁKLAD_NÁKL______
      testA->nZAKL_ZR += If( paZR[ 4, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paZR[ 5, 4]), ;                                //__ROZPOUŠTÌNÍ______
      testA->nROZP_ZR += If( paZR[ 5, 2] = 'M', nMD, nDAL), NIL )
return nil


static function autom_zr_gen()                   //__GENEROVÁNÍ dokladù ZR______
  local  nHODN_1, nKOEF_1, nKCMD, nPOSm
  local  cKEy
  *
  local  lAUTO_obr := SYSCONFIG( 'UCTO:lAUTO_obr')

  do while .not. testA->(eof())

    for nposM := 1 To len(paZRS) step 1
      if( EVAL( paZRS[nposM,3]) .and. EVAL( paZRS[nposM,5]) .and. testA->lROZP_ZR )
        autom_it->( dbGOTo( paZRS[nposM,6]))
        ckey := left( testA->(sx_KeyData()), 6 )
        testR->(dbSeek( ckey +strZero(nposM,2)))

        if lAUTO_obr   // mesicni
          nHODN_1 := testR->nROZP___CO - testR->nROZP__AUT
        Else           // rocni
          nHODN_1 := testR->nROZP___CO
        EndIf

        nKOEF_1 := nHODN_1            / TESTR ->nROZP__KAM
        nKCMD   := ROUND( TESTA ->nZAKL_ZR * nKOEF_1, 2 )

        If lAUTO_obr   // mesicni
        Else           // rocni
          nKcMD -= TESTA ->nROZP_ZR
        EndIf

        if( nkcMd <> 0, AUTUc_dok(nkcMd,nposM), NIL )
        testA->(dbDelete())
      EndIf
    Next
    testA->(dbSkip())
  EndDo
Return( Nil)