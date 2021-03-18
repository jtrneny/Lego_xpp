#include "Common.ch"
#include "gra.ch"
#include "ads.ch"
#include "adsdbe.ch"
#include "dbstruct.ch'
//
// #include "asystem++.ch'
#include "..\Asystem++\Asystem++.ch"


static cdirW
static nlenS, nnazPol, paVR, paVRS
static ltyp_NVv, pAUTO_vy
static nlen_cnazPolX


*
********** VÝPOÈET dokadù VÝROBNÍ REŽIE ****************************************
function UCT_autom_vr(xbp_therm)
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
  drgDBMS:open('vyrzak')  ;  vyrzak->(ordSetFocus( AdsCtag( 7 )))
  drgDBMS:open('kalkul')  ;  kalkul->(ordSetFocus( AdsCTag( 3 )))

  autom_vr_tmp()     // pomocný soubor
  autom_vr_for()     // filtr pro ucetkum dle nastavení

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
      autom_vr_cmp()
    else
      AUTUc_cpy('uckum_w', 'testa', .t.)
      ckeyS := uckum_w->(sx_keyData())
      autom_vr_cmp()
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
        testA->lROZP_VR := ( cky == '000000' .or. ( cky >= cc ))
      else
        testA->lROZP_VR := .f.
      endif
    else
      testA->lROZP_VR := .T.
    endif

    for x := 1 To len(paVRS) Step 1
      if Eval( paVRS[x,3])
        lROZP___CO := Eval( paVRS[x,4])
        lROZP__KAM := .F.
        lROZP__AUT := ( testR->cnazPol1 = testA->cnazPol1)

        If ltyp_NVv
          lROZP__KAM := ( testA->lROZP_VR .and. vyrzak->ctypZAK <> 'R')
        else
          lROZP__KAM := Eval( paVRS[x,5])
        endif

        if ( lROZP___CO .or. lROZP__KAM )
          if .not. testR ->( dbSeek( left( testA->(sx_KeyData()), 14) +strZero(x,2)))
             AUTUc_CPY( 'testA', 'testR', .t.)
             testR->nAUTOM_IT := x
          endif
          If( lROZP___CO, testR->nROZP___CO  += ( testA->nNAKL_VR -testA->nVYNO_VR), NIL )
          If( lROZP__KAM, testR->nROZP__KAM  += testA->nZAKL_VR, Nil )
          If( lROZP__AUT, testR ->nROZP__AUT += testA->nREZI_VR, NIL )
        EndIf
      EndIf
    Next
    testA->(dbSkip())
  EndDo

  testA   ->(dbGoTop())
  ucetkum ->(Ads_clearAof(),DbGoTop())

  autom_vr_gen()

  ** konec
  testA->(OrdListClear(), dbUnlock(), dbcloseArea())
  testR->(OrdListClear(), dbUnlock(), dbcloseArea())
return nil


* založení pomocných souboru
static function autom_vr_tmp()
  local x, ckeyS, cnazPol
  local astrU   := { { 'nROK'             , 'I',              2, 0 }, ;
                     { 'nOBDOBI'          , 'I',              2, 0 }, ;
                     { 'cOBDOBI'          , 'C',              5, 0 }, ;
                     { 'cNAZPOL1'         , 'C',              8, 0 }, ;
                     { AUTOM_HD ->cNAZPOLx, 'C',  nlen_cnazPolX, 0 }, ;
                     { 'nREZI_VR'         , 'F',              8, 2 }, ;
                     { 'nNAKL_VR'         , 'F',              8, 2 }, ;
                     { 'nVYNO_VR'         , 'F',              8, 2 }, ;
                     { 'nZAKL_VR'         , 'F',              8, 2 }, ;
                     { 'nROZP_VR'         , 'F',              8, 2 }, ;
                     { 'lROZP_VR'         , 'L',              1, 0 }  }
  local astruR := {  { 'nROK'             , 'I',              2, 0 }, ;
                     { 'nOBDOBI'          , 'I',              2, 0 }, ;
                     { 'cOBDOBI'          , 'C',              5, 0 }, ;
                     { 'cNAZPOL1'         , 'C',              8, 0 }, ;
                     { 'nAUTOM_IT'        , 'I',              2, 0 }, ;
                     { 'nROZP___CO'       , 'F',              8, 2 }, ;
                     { 'nROZP__KAM'       , 'F',              8, 2 }, ;
                     { 'nROZP__AUT'       , 'F',              8, 2 }  }

  nnazPol := val( right( autom_hd->cnazPolx, 1))
  nlenS   := 6 +( 8 * nNAZpol)

  for x := 2 to nnazPol -1 step 1
    cnazPol := 'cNAZPOL' +STR(x,1)
    AAdd( aSTRU, { cnazPol, 'C', AUTUc_Ns(cnazPol) , 0 } )
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

  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2) +upper(cnazPol1) +strZero(nautom_IT,2)'
  INDEX ON &(ckeyS) TO (cdirW +'testR')
  testR->(Flock())
return nil


static function autom_vr_for()                     //  PODMÍNKA INDEXOVÁNÍ
  Local  cC, cvyrP := '', cvyrM := '', cvyrC := '', cvyrN := '', cvyrE := '', cvyrS := '', cvyr
  Local  cCONDs
  *
  local  pa, n, x, sign, filter, cnaklS, npos, nposS

  paVR  := {}
  paVRS := {}

  aADD( paVR, { AUTOM_HD->cREZIUc_VR, '', '', '' })
  aADD( paVR, { AUTOM_HD->cNAKLUc_VR, '', '', '' })
  aADD( paVR, { AUTOM_HD->cVYNOUc_VR, '', '', '' })
  aADD( paVR, { AUTOM_HD->cZAKLUc_VR, '', '', '' })
  aADD( paVR, { AUTOM_HD->cROZPUc_VR, '', '', '' })

  for n := 1 To len(paVR) step 1
    paVR[n,2] := If( AT( 'M', paVR[ N, 1]) <> 0, 'M', 'D' )
    cvyrN     := ''
    cvyrM     := ''
    cCONDs    := STRTRAN( paVR[ N, 1], 'M', ',')
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

    paVR[N,3] := '(' +subStr(cvyrN,7) +')' +if( Empty(cvyrM), '', ' .and. !(' +substr(cvyrM,7) +')')
  next

  AEval(paVR, {|x,m| paVR[m,4] := COMPILE(x[3]) })

  cvyrC  := '(' +subStr(cvyrP,7) +')'
  cvyrP  := ''
  cnaklS := 'testa->' +autom_hd->cnazPolx

  autom_it->(DbGoTop())

  do while .not. autom_it->(eof())
    cvyrN := 'testa->cnazPol1 >= "' +autom_it->cnazPol_OD +'" .and. ' + ;
             'testa->cnazPol1 <= "' +autom_it->cnazPol_DO +'"'

    AAdd( paVRS, { autom_it->cmrozp_CO  , ;
                   autom_it->cmrozp_KAM , ;
                   COMPILE( cvyrN)      , ;
                   'B_co'               , ;
                   'B_kam'              , ;
                   autom_it->( recNo()) } )


    for n := 1 to 2 step 1
      ccondS := Atail(paVRS)[n] +','
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
      Atail(paVRS)[n+3] := COMPILE(subStr(cvyrM,7))
    next

    cvyrP += ' .or. (cnazPol1 >= "' +autom_it->cnazPol_OD +'" .and. cnazPol1 <= "' +autom_it->cnazPol_DO + '")'
    autom_it->(dbSkip())
  enddo

  filter := "(strZero(nrok,4) = '" +strZero(autom_hd->nrok,4) +"'" + ;
            " .and. strZero(nobdobi,2) = '" +strZero(autom_hd->nobdobi,2) +"')"

  filter += ' .and. ('+ cvyrC +') .and. (' +substr(cvyrP,7) +')'
  ucetkum->(Ads_setAof(filter),DbGoTop())
return nil



static function autom_vr_cmp()                    //__ NÁPOÈET dle NASTAVENÍ ___
  Local  nMD  := DBGetVal( paAUTO_VY[1] )
  Local  nDAL := DBGetVal( paAUTO_VY[2] )

  dbSelectArea('uckum_w')

  If( EVAL( paVR[ 1, 4]), ;                                //__REŽIE____________
      testA->nREZI_VR += If( paVR[ 1, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paVR[ 2, 4]), ;                                //__NÁKLADY__________
      testA->nNAKL_VR += If( paVR[ 2, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paVR[ 3, 4]), ;                               //__VÝNOSY____________
      testA->nVYNO_VR += If( paVR[ 3, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paVR[ 4, 4]), ;                                //__ZÁKLAD_NÁKL______
      testA->nZAKL_VR += If( paVR[ 4, 2] = 'M', nMD, nDAL), NIL )
  If( EVAL( paVR[ 5, 4]), ;                               //__ROZPOUŠTÌNÍ_______
      testA->nROZP_VR += If( paVR[ 5, 2] = 'M', nMD, nDAL), NIL )
return nil


Static Function autom_vr_gen()                     //__GENEROVÁNÍ dokladù VR____
  local  nHODN_1, nKOEF_1, nKCMD, nPOSm
  local  cKEy
//
  local  lAUTO_obr := SYSCONFIG( 'UCTO:lAUTO_obr')

  SET( _SET_DECIMALS, 15)

  do while .not. testA->(eof())

    for nposM := 1 to len( paVRS) step 1
      If( EVAL( paVRS[nposM,3]) .and. EVAL( paVRS[nposM,5]) .and. testA->lROZP_VR )
        autom_it->( dbGoTo( paVRS[nposM,6]))
        ckey := left( testA->(sx_KeyData()), 14)
        testR->(dbSeek( ckey +strZero( nposM,2)))

        If lAUTO_obr   // mesicni
          nHODN_1 := testR->nROZP___CO - testR ->nROZP__AUT
        Else           // rocni
          nHODN_1 := testR->nROZP___CO
        EndIf

        nKOEF_1 := nHODN_1            / TESTR ->nROZP__KAM
        nKCMD   := ROUND( testA->nZAKL_VR * nKOEF_1, 2 )

        If lAUTO_obr   // mesicni
        Else           // rocni
          nKcMD -= testA->nROZP_VR
        EndIf

        if( nkcMd <> 0, AUTUc_dok(nkcMd,nposM), NIL )
        testA->(dbDelete())
      EndIf
    Next
    testA->(dbSkip())
  EndDo
  SET( _SET_DECIMALS, 2)
return nil