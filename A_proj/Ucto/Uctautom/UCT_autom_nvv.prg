#include "Common.ch"
#include "gra.ch"
#include "ads.ch"
#include "adsdbe.ch"
#include "dbstruct.ch'
//
#include "..\Asystem++\Asystem++.ch"


static cdirW
static nlenS, nnazPol, paNV
static nlen_cnazPolX


*
********** VÝPOÈET dokadù NEDOKONÈENÉ VÝROBY (VÝROBNÍ) ************************
function UCT_autom_nvv(xbp_therm)
  local  x, ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2)'
  local     ckeyV := 'ucetkum->' +autom_hd->cnazPolx, lok, cvalV
  local    cnaklS := 'testa->'   +autom_hd->cnazPolx, ckyS
  *
  local  recCnt, keyCnt, keyNo := 1

  cdirW         := AUTUc_dirW()
  nlen_cnazPolX := AUTUc_Ns(AUTOM_HD ->cNAZPOLx)

  ** vazba na výrobu
  drgDBMS:open('vyrzak')  ;  vyrzak->(ordSetFocus( AdsCtag( 7 )))
  drgDBMS:open('kalkul')  ;  kalkul->(ordSetFocus( AdsCtag( 3 )))

  autom_nvv_tmp()     // pomocný soubor
  autom_nvv_for()     // filtr pro ucetkum dle nastavení

  for x := 1 to nnazPol step 1
    ckeyS += ' +upper(cnazPol' +str(x,1) +')'
  next
  DbSelectArea('uckum_w')
  INDEX ON &(ckeyS) TO (cdirW +'uckum_w')

  recCnt := ucetkum->( ads_getKeyCount(ADS_RESPECTFILTERS)) * 2
  keyCnt := recCnt / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)

  do while .not. ucetkum->(eof())
    aktucdat_PB(xbp_therm,keyCnt,keyNo,recCnt)

    cvalV := upper(DBGetVal(ckeyV))

    lOk := ( vyrzak->(dbSeek(cvalV)) .and. vyrzak->cintid  <> 'E')
    lOk := ( lok                     .and. vyrzak->cintid  <> 'O')
    lOk := ( lok                     .and. vyrzak->ctypZak <> 'R')

    if lOk
      AUTUc_cpy('ucetkum','uckum_w',.t.)
      uckum_w->ctyp := if(Eval(paNV[1,4]), '1', if(Eval(paNV[2,4]), '2', if(Eval(paNV[3,4]), '3', ' ' )))
    endif
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
      autom_nvv_cmp()
    else
      ckyS := upper(DBGetVal(cnaklS)) +space(22) +'NED'
      kalkul ->(dbSeek(ckyS))
      testA  ->nprod_NV  += testA->nmnoz_NV * kalkul->ncenKalkP
      testA  ->ncenKalkP := kalkul->ncenKalkP

      AUTUc_cpy('uckum_w', 'testa', .t.)
      ckeyS := uckum_w->(sx_keyData())
      autom_nvv_cmp()
    endif
    uckum_w->(dbSkip())
    keyNo++
  enddo

  testa   ->(dbGoTop())
  autom_it->(dbGoTop())
  ucetkum ->(Ads_clearAof(),DbGoTop())

  autom_nvv_gen()

  ** konec
  testa->(OrdListClear(), dbUnlock(), dbcloseArea())
return nil


* založení pomocných souboru
static function autom_nvv_tmp()
  local x, ckeyS, cnazPol
  local astrU   := { { 'nROK'             , 'I',              2, 0 }, ;
                     { 'nOBDOBI'          , 'I',              2, 0 }, ;
                     { 'cOBDOBI'          , 'C',              5, 0 }, ;
                     { 'cNAZPOL1'         , 'C',              8, 0 }, ;
                     { AUTOM_HD ->cNAZPOLx, 'C',  nlen_cnazPolX, 0 }, ;
                     { 'nNAKL_NV'         , 'F',              8, 2 }, ;
                     { 'nPROD_NV'         , 'F',              8, 2 }, ;
                     { 'nUCTY_NV'         , 'F',              8, 2 }, ;
                     { 'nMNOZ_NV'         , 'F',              8, 2 }, ;
                     { 'nCENkalkP'        , 'F',              8, 2 }  }

  nnazPol := val( right( autom_hd->cnazPolx, 1))
  nlenS   := 6 +( 8 * nNAZpol)

  for x := 2 to nnazPol -1 step 1
    cnazPol := 'cNAZPOL' +STR(x,1)
    AAdd( aSTRU, { cnazPol, 'C', AUTUc_Ns(cnazPol) , 0 } )
  next

  ckeyS := 'strZero(nrok,4) +strZero(nobdobi,2) +upper(cnazpol1) +upper(cnazpol2) +upper(cnazpol3)'

  FErase(cdirW +'testa.adi')
  FErase(cdirW +'testa.adt')

  DbCreate(cdirW +'testa', aSTRu, oSession_free)
  DbUseArea(.t., oSession_free, cdirW +'testa',,.t.,.f.)
  DbSelectArea('testa')
  INDEX ON &(ckeyS) TO (cdirW +'testa')

  testa->(flock())
return nil


static function autom_nvv_for()                     //  PODMÍNKA INDEXOVÁNÍ
  Local  cC, cvyrP := '', cvyrM := '', cvyrC := '', cvyrN := '', cvyr
  Local  cCONDs
  *
  local  pa, n, x, sign, filter

  paNV := {}

  aADD( paNV, { AUTOM_HD->cNAKLUc_NV, '', '', '' })
  aADD( paNV, { AUTOM_HD->cPRODUc_NV, '', '', '' })
  aADD( paNV, { AUTOM_HD->cUCTYUc_NV, '', '', '' })

  for n := 1 To len(paNV) step 1
    paNV[n,2] := If( AT( 'M', paNV[ N, 1]) <> 0, 'M', 'D' )
    cVYRn     := ''
    cCONDs    := STRTRAN( paNV[ N, 1], 'M', ',')
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

    paNV[N,3] := '(' +subStr(cvyrN,7) +')'
  next

  AEval(paNV, {|x,m| paNV[m,4] := COMPILE(x[3]) })

  cvyrC := '(' +subStr(cvyrP,7) +')' +if( Empty(cvyrM), '', ' .and. !(' +substr(cvyrM,7) +')')
  cvyrP := ''

  autom_it->(DbGoTop())

  do while .not. autom_it->(eof())
    if autom_it->cnazPol_OD = autom_it->cnazPol_DO
      cvyrP += " .or. (cnazPol1 = '" +autom_it->cnazPol_OD +"')"
    else
      cvyrP += " .or. (cnazPol1 >= '" +autom_it->cnazPol_OD + ;
               "' .and. cnazPol1 <= '" +autom_it->cnazPol_DO + "')"
    EndIf
    autom_it->(DbSkip())
  enddo


  filter := "(strZero(nrok,4) = '" +strZero(autom_hd->nrok,4) +"'" + ;
            " .and. strZero(nobdobi,2) = '" +strZero(autom_hd->nobdobi,2) +"')"

  filter += ' .and. ('+ cvyrC +') .and. (' +substr(cvyrP,7) +')'

  ucetkum->(Ads_setAof(filter),DbGoTop())
return nil


static function autom_nvv_cmp()                     //  NÁPOÈET dle NASTAVENÍ
  local  nval, ntyp := val(uckum_w->ctyp)

  nval := if(paNV[ntyp,2] = 'M', ( uckum_w->nKcMDksR  -uckum_w ->nKcDALksR), ;
                                 ( uckum_w->nKcDALksR -uckum_w ->nKcMDksR )  )

  if     nTYP == 1  ;  TESTa ->nNAKL_NV += nVAL            //  NÁKLADY
  elseIf nTYP == 2                                         //  PRODUKCE
    if( Eval(paNV[2,4]), TESTa ->nMNOZ_NV += uckum_w->nMnozNatR, nil)
  else              ;  TESTa ->nUCTY_NV += nVAL            //  NEDOKOÈENÁ
  endIf
return  nil


static function autom_nvv_gen()                   // GENEROVÁNÍ DOKLAD§U NVv
  local  nposM, nposS, nucty_NV, nkcMD
  local  cnaklS := 'testa->' +autom_hd->cnazPolx
  local  ccondS, cvyrP, cc, cky
  local  pacondS := {}
  local  ldone

  autom_it->(dbGoTop())
  do while .not. autom_it->(eof())
    ccondS := autom_it->cmrozp_CO +','
    cvyrP  := ''
    do while (nposM := at(',', ccondS)) <> 0
      cc := subStr(ccondS,1,nposM-1)
      if (nposS := at('..',cc)) <> 0
        cvyrP += ' .or. ( ' +cnaklS +' >= "' +padR(subStr(cc,1,nposS-1), nlen_cnazPolX) + ;
                 '" .and. ' +cnaklS +' <= "' +padR(SUBSTR(cc,  nposS+2), nlen_cnazPolX) + '")'
      else
        cvyrP += ' .or. ' +cnaklS +' = "' +padR(cc,nlen_cnazPolX) +'"'
      endif
      ccondS := subStr(ccondS,nposM+1)
    enddo
    ckeyS := 'testa->cnazPol1 >= "' +autom_it->cnazPol_OD +'" .and. ' + ;
             'testa->cnazPol1 <= "' +autom_it->cnazPol_DO +'"'
    AAdd( pacondS, { COMPILE(ckeyS), COMPILE(subStr(cvyrP,7)), autom_it->(recNo()) })

    autom_it->(dbSkip())
  enddo

  autom_it->(dbGoTop())
  testa->( DbSetRelation('vyrzak', {|| upper(testa->cnazPol3) }))

  do while .not. testa->(eof())
    if( .not. vyrzak->(found()), nil, nil)
    cc  := strZero(testa->nrok,4) +strZero(testa->nobdobi,2)
    cky := right(vyrzak->(sx_KeyData()),6)

    for nposM := 1 to len(pacondS) step 1
      ldone := ( cky == '000000' .or.  ( cky >= cc )           )
      ldone := ( ldone           .and. vyrzak->cintID  <> 'E'  )
      ldone := ( ldone           .and. vyrzak->cintID  <> 'O'  )
      ldone := ( ldone           .and. vyrzak->ctypZAK <> 'R'  )
      ldone := ( ldone           .and. EVAL( pacondS[nposM, 1]))

      if ldone
        autom_it->( dbGoTo(pacondS[nposM,3]))
        nucty_NV := testa->nucty_NV
        nkcMD    := 0

        do case
*-        case( autom_it->lukonceno)
        case( vyrzak->nrok = testa->nrok .and. vyrzak->nobdobi = testa->nobdobi )
          nkcMD := nucty_NV *( -1)
        case( testa->nnakl_NV -testa->nprod_NV ) <= 0
          nkcMD := nucty_NV *( -1)
        otherWise
          nkcMD := (testa->nnakl_NV -testa->nprod_NV ) -nucty_NV
        endCase

        if( round(nkcMd, 2) <> 0, AUTUc_dok( nkcMd, nposM), NIL )
        testa->(DbDelete())
      endIf
    next
    testa->(dbSkip())
  enddo
  testa->(DbClearRel())
return nil