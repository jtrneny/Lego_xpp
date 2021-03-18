#include "Common.ch"
#include "gra.ch"
#include "ads.ch"
#include "adsdbe.ch"
#include "dbstruct.ch'
//
// #include "asystem++.ch'
#include "..\Asystem++\Asystem++.ch"


static cdirW
static nlenS, nnazPol, paSR, paSRS
static ltyp_NVv, pAUTO_vy


*
********** VÝPOÈET dokadù SPRÁVNÍ REŽIE ****************************************
function UCT_autom_sr(xbp_therm)
  local  x, ckeyS  := 'strZero(nrok,4) +strZero(nobdobi,2)'
  local     ckeyV  := 'uckum_w->' +autom_hd->cnazPolx, lok, cvalV, cc, cky
  local     cnaklS := ' .not. Empty(ucetkum->' +autom_hd->cnazPolx +')'
  *
  local  lROZP___CO, lROZP__KAM, lROZP__AUT
   *
  local  recCnt, keyCnt, keyNo := 1

  cdirW     := AUTUc_dirW()
  ltyp_NVv  := AUTUc_typNVv()
  paAUTO_vy := AUTUC_typV()

  ** vazba na výrobu
  drgDBMS:open('vyrzak')  ;  vyrzak->(ordSetFocus( AdsCtag( 7 )))
  drgDBMS:open('kalkul')  ;  kalkul->(ordSetFocus( AdsCtag( 3 )))

  autom_sr_tmp()     // pomocný soubor
  autom_sr_for()     // filtr pro ucetkum dle nastavení

  for x := 1 to nnazPol step 1
    ckeyS += ' +upper(cnazPol' +str(x,1) +')'
  next
  DbSelectArea('uckum_w')
  INDEX ON &(ckeyS) TO (cdirW +'uckum_w')

  *
  recCnt := ucetkum->( ads_getKeyCount(ADS_RESPECTFILTERS)) * 2
  keyCnt := recCnt / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)

  do while .not. ucetkum->(eof())
    aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt)

    lok := if(ltyp_nvv, DBGetVal(cnaklS),.t.)

    if(lok, AUTUc_cpy('ucetkum','uckum_w',.t.), nil)
    ucetkum->(dbskip())
    keyNo++
  enddo

  ** zpracováni **
  uckum_w->(dbGoTop())
  ckeyS := uckum_w->(sx_keyData())

  AUTUc_cpy('uckum_w', 'testa', .t.)
  do while .not. uckum_w->(eof())
    aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt)

    if ckeyS = uckum_w->(sx_keyData())
      autom_sr_cmp()
    else
      AUTUc_cpy('uckum_w', 'testa', .t.)
      ckeyS := uckum_w->(sx_keyData())
      autom_sr_cmp()
    endif
    uckum_w->(dbSkip())
    keyNo++
  enddo

  testa->(dbGoTop())
  cnaklS := 'upper(testA->' +autom_hd->cnazPolx +')'

  do while .not. testA->(eof())
    if ltyp_NVv
      if vyrzak->(dbSeek( DBGetVal( cnaklS)))
        cc  := strZero(testA->nrok,4) +strZero(testA->nobdobi,2)
        cky := right  (vyrzak->(sx_KeyData()), 6 )
        testA->lROZP_SR := ( cky == '000000' .or. ( cky >= cc ))
      else
        testA->lROZP_SR := .f.
      endif
    else
      testA->lROZP_SR := .T.
    endif

    for x := 1 To len(paSRS) Step 1
      if Eval(paSRS[x,3]) .or. Eval(paSRS[x,7])
        lROZP___CO := Eval(paSRS[x,4])
        lROZP__KAM := .F.
        lROZP__AUT := Eval(paSRS[x,4])

        If ltyp_NVv
          lROZP__KAM := (testA->lROZP_SR .and.       vyrzak->ctypZAK <> 'R')
          lROZP__KAM := (lROZP__KAM      .and. .not. Eval(paSRS[x,7])      )
        else
          lROZP__KAM := Eval(paSRS[x,5])
        endif

        if ( lROZP___CO .or. lROZP__KAM )
          if .not. testR ->( dbSeek( left( testA->(sx_KeyData()),6) +strZero(x,2)))
             AUTUc_CPY( 'testA', 'testR', .t.)
             testR->nAUTOM_IT := x
          endif
          If( lROZP___CO, testR->nROZP___CO  += ( testA->nNAKL_SR -testA->nVYNO_SR), NIL )
          If( lROZP__KAM, testR->nROZP__KAM  += testA->nZAKL_SR, Nil )
          If( lROZP__AUT, testR ->nROZP__AUT += testA->nREZI_SR, NIL )
        EndIf
      EndIf
    Next
    testA->(dbSkip())
  EndDo

  testA   ->(dbGoTop())
  ucetkum ->(Ads_clearAof(),DbGoTop())

  autom_sr_gen()

  ** konec
  testA->(OrdListClear(), dbUnlock(), dbcloseArea())
  testR->(OrdListClear(), dbUnlock(), dbcloseArea())
return nil


* založení pomocných souboru
static function autom_sr_tmp()
  local x, ckeyS
  local astrU   := { { 'nROK'             , 'I',  2, 0 }, ;
                     { 'nOBDOBI'          , 'I',  2, 0 }, ;
                     { 'cOBDOBI'          , 'C',  5, 0 }, ;
                     { 'cNAZPOL1'         , 'C',  8, 0 }, ;
                     { AUTOM_HD ->cNAZPOLx, 'C',  8, 0 }, ;
                     { 'nREZI_SR'         , 'F',  8, 2 }, ;
                     { 'nNAKL_SR'         , 'F',  8, 2 }, ;
                     { 'nVYNO_SR'         , 'F',  8, 2 }, ;
                     { 'nZAKL_SR'         , 'F',  8, 2 }, ;
                     { 'nROZP_SR'         , 'F',  8, 2 }, ;
                     { 'lROZP_SR'         , 'L',  1, 0 }  }
  local astruR := {  { 'nROK'             , 'I',  2, 0 }, ;
                     { 'nOBDOBI'          , 'I',  2, 0 }, ;
                     { 'cOBDOBI'          , 'C',  5, 0 }, ;
                     { 'cNAZPOL1'         , 'C',  8, 0 }, ;
                     { 'nAUTOM_IT'        , 'I',  2, 0 }, ;
                     { 'nROZP___CO'       , 'F',  8, 2 }, ;
                     { 'nROZP__KAM'       , 'F',  8, 2 }, ;
                     { 'nROZP__AUT'       , 'F',  8, 2 }  }

  nnazPol := val( right( autom_hd->cnazPolx, 1))
  nlenS   := 6 +( 8 * nNAZpol)

  for x := 2 to nnazPol -1 step 1
    AAdd( aSTRU, { 'cNAZPOL' +STR(x,1), 'C', 8, 0 } )
  next

  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2)'

  for n := 1 to nNAZpol step 1
    ckeyS += ' +upper(cnazpol' +str(n,1) +')'
  next

  **
  FErase(cdirW +'testa.adi')
  FErase(cdirW +'testa.adt')

  DbCreate(cdirW +'testa', aSTRu, oSession_free)
  DbUseArea(.t., oSession_free, cdirW +'testa',,.f.,.f.)
  DbSelectArea('testa')
  INDEX ON &(ckeyS) TO (cdirW +'testa')

  **
  FErase(cdirW +'testr.adi')
  FErase(cdirW +'testr.adt')

  DbCreate(cdirW +'testr', astruR, oSession_free)
  DbUseArea(.t., oSession_free, cdirW +'testR',,.f.,.f.)
  DbSelectArea('testR')

*-  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2) +upper(cnazPol1) +strZero(nautom_IT,2)'
  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2) +strZero(nautom_IT,2)'
  INDEX ON &(ckeyS) TO (cdirW +'testR')
  testR->(Flock())
return nil


static function autom_sr_for()                     //  PODMÍNKA INDEXOVÁNÍ
  Local  cC, cvyrP := '', cvyrM := '', cvyrC := '', cvyrN := '', cvyrE := '', cvyrS := '', cvyr
  Local  cCONDs
  *
  local  pa, n, x, sign, filter, cnaklS, npos, nposS

  paSR  := {}
  paSRS := {}

  aADD( paSR, { AUTOM_HD->cREZIUc_SR, '', '', '' })
  aADD( paSR, { AUTOM_HD->cNAKLUc_SR, '', '', '' })
  aADD( paSR, { AUTOM_HD->cVYNOUc_SR, '', '', '' })
  aADD( paSR, { AUTOM_HD->cZAKLUc_SR, '', '', '' })
  aADD( paSR, { AUTOM_HD->cROZPUc_SR, '', '', '' })

  for n := 1 To len(paSR) step 1
    paSR[n,2] := If( AT( 'M', paSR[ N, 1]) <> 0, 'M', 'D' )
    cvyrN     := ''
    cvyrM     := ''
    cCONDs    := STRTRAN( paSR[ N, 1], 'M', ',')
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

    paSR[N,3] := '(' +subStr(cvyrN,7) +')' +if( Empty(cvyrM), '', ' .and. !(' +substr(cvyrM,7) +')')
  next

  AEval(paSR, {|x,m| paSR[m,4] := COMPILE(x[3]) })

  cvyrC  := '(' +subStr(cvyrP,7) +')'
  cnaklS := 'testa->' +autom_hd->cnazPolx
  cvyrP  := ''
  cvyrE  := ''

  autom_it->(DbGoTop())

  do while .not. autom_it->(eof())
    cvyrN := 'testa->cnazPol1 >= "' +autom_it->cnazPol_OD +'" .and. ' + ;
             'testa->cnazPol1 <= "' +autom_it->cnazPol_DO +'"'
    cvyrS := 'testA->cnazPol1  = "' +autom_it->cROZP__STR +'"'

    AAdd( paSRS, { autom_it->crozp___CO , ;
                   autom_it->cmrozp_KAM , ;
                   COMPILE( cvyrN)      , ;
                   'B_co'               , ;
                   'B_kam'              , ;
                   autom_it->( recNo()) , ;
                   COMPILE(cvyrS)         } )

   cvyrE += " .or. (cnazPol1 = '" +autom_it->cROZP__STR +"')"

   for n := 1 to 2 step 1
     ccondS := Atail(paSRS)[n] +','
     cvyrM  := ''

     do while (npos := At(',', ccondS)) <> 0
       cc := subStr(ccondS, 1, npos-1)
       if (nposS := At('..', cc)) <> 0
         cvyrM += ' .or. ( ' +cnaklS +' >= "' +padR( substr( cc, 1, nposS-1), 8) + ;
                  '" .and. ' +cnaklS +' <= "' +padR( substr( cc,    nposS+2), 8) +'")'
       else
         cvyrM += ' .or. ' +cnaklS +' = "' +padR( cc, 8) +'"'
       endif
       ccondS := subStr(ccondS, npos+1)
     enddo
     Atail(paSRS)[n+3] := COMPILE(subStr(cvyrM,7))
    next

    cvyrP += ' .or. (cnazPol1 >= "' +autom_it->cnazPol_OD +'" .and. cnazPol1 <= "' +autom_it->cnazPol_DO + '")'
    autom_it->(DbSkip())
  enddo

  filter := "(strZero(nrok,4) = '" +strZero(autom_hd->nrok,4) +"'" + ;
            " .and. strZero(nobdobi,2) = '" +strZero(autom_hd->nobdobi,2) +"')"

  filter += ' .and. ('+ cvyrC +') .and. (' +substr(cvyrP,7) +' .or. (' +substr(cvyrE,7) +'))'
  ucetkum->(Ads_setAof(filter),DbGoTop())
return nil



static function autom_sr_cmp()                    //__ NÁPOÈET dle NASTAVENÍ ___
  Local  nMD  := DBGetVal( paAUTO_VY[1] )
  Local  nDAL := DBGetVal( paAUTO_VY[2] )

  dbSelectArea('uckum_w')

  If( EVAL( paSR[ 1, 4]), ;                                //__REŽIE____________
      testA->nREZI_SR += If( paSR[ 1, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paSR[ 2, 4]), ;                                //__NÁKLADY__________
      testA->nNAKL_SR += If( paSR[ 2, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paSR[ 3, 4]), ;                               //__VÝNOSY____________
      testA->nVYNO_SR += If( paSR[ 3, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paSR[ 4, 4]), ;                                //__ZÁKLAD_NÁKL______
      testA->nZAKL_SR += If( paSR[ 4, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paSR[ 5, 4]), ;                               //__ROZPOUŠTÌNÍ_______
      testA->nROZP_SR += If( paSR[ 5, 2] = 'M', nMD, nDAL), NIL )
return nil


static function autom_sr_gen()                     //__GENEROVÁNÍ dokladù SR____
  local  nHODN_1, nKOEF_1, nKCMD, nPOSm
  local  cKEy
//
  local  lAUTO_obr := SYSCONFIG( 'UCTO:lAUTO_obr')

  do while .not. testA->(eof())

    for nposM := 1 To len(paSRS) step 1
      if( EVAL( paSRS[nposM,3]) .and. EVAL( paSRS[nposM,5]) .and. testA->lROZP_SR )
        autom_it->(dbGoTo( paSRS[nposM,6]))
        ckey := left( testA->(sx_KeyData()), 6 )
        testR ->(dbSeek( ckey +strZero(nposM,2)))

        If lAUTO_obr   // mesicni
          nHODN_1 := testR->nROZP___CO - testR->nROZP__AUT
        Else           // rocni
          nHODN_1 := testR->nROZP___CO
        EndIf

        nKOEF_1 := nHODN_1            / TESTR ->nROZP__KAM
        nKCMD   := ROUND( testA->nZAKL_SR * nKOEF_1, 2 )

        If lAUTO_obr   // mesicni
        Else           // rocni
          nKcMD -= testA->nROZP_SR
        EndIf

        if( nkcMd <> 0, AUTUc_dok(nkcMd, nposM), NIL )
        testA->(dbDelete())
      EndIf
    Next
    testA->(dbSKip())
  EndDo
return nil