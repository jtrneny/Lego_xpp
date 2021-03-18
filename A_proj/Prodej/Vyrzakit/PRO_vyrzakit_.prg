#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
*
#include "..\Asystem++\Asystem++.ch"


function pro_vyrzakit_cpy(oDialog)
  local  lNEWrec   := If( IsNull(oDialog), .F., oDialog:lNEWrec)
  local  typZ_vyrz := sysConfig('Prodej:ctypZ_vyrz')
  local  nazPol_1  := sysConfig('vyroba:cnazPol1'), nazPol1
  local  a_nsVZak  := listAsArray( sysConfig('vyroba:cnstoVZAK'))

  nazPol1 := if( ISCHARACTER(nazPol_1), listAsArray(nazPol_1)[1], '')

  ** tmp **
  drgDBMS:open('vyrzakitw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  if .not. lNEWrec
    mh_copyfld('vyrzakit', 'vyrzakitw', .t., .t.)

    vyrZakpl->( dbseek( upper(vyrZakit->ccisZakazi),,'ZAKPL_1'))
    vyrZakitw->_nrecOr_pl := vyrZakpl->( recNo())

  else
    vyrzakitw->(dbappend())

    if isobject(oDialog) .and. oDialog:drgDialog:cargo = drgEVENT_APPEND2
      mh_copyFld('vyrzakit', 'vyrzakitw',, .t.)

      * nìco pøednastavit/ zanulovat
      vyrzakitw->CCISZAKAZ  := ''
      vyrzakitw->CCISZAKAZI := ''
      vyrzakitw->CVYROBCISL := ''
      vyrzakitw->CVYRPOL    := ''
      vyrzakitw->DODVEDZAKA := ctod('  .  .  ')
      vyrzakitw->DMOZODVZAK := ctod('  .  .  ')
      vyrzakitw->DUZAVZAKA  := ctod('  .  .  ')
      vyrzakitw->DZACATPRAC := ctod('  .  .  ')
      vyrzakitw->DDODDILMON := ctod('  .  .  ')
      vyrzakitw->nMnozZadan := 0
      vyrzakitw->nMnozFakt  := 0
      vyrzakitw->CSTAVZAKAZ := '1'
      vyrzakitw->NPOCCEZAPZ := 0
      vyrzakitw->NROK       := 0
      vyrzakitw->NOBDOBI    := 0
      vyrzakitw->CSTAVZAKUZ := ''
      vyrzakitw->nMnoz_EXLV := 0
      vyrzakitw->nStav_EXLV := 0
      vyrzakitw->dDat_EXLV  := ctod('  .  .  ')
      vyrzakitw->dZapis     := Date()
      vyrzakitw->cpriorZaka := '1 '
      vyrzakitw->cjmeOsZal  := logOsoba
      vyrzakitw->nCisloEL   := 0
      vyrzakitw->nRokOdv    := 0
      vyrzakitw->nMesicOdv  := 0
      vyrzakitw->nTydenOdv  := 0
      vyrzakitw->cCisloObj  := ''
      *
      ** musíme zanulovat vazby
      vyrzakitw->ncisfak    := 0
      vyrzakitw->nmnozfakt  := 0
      vyrZakitw->nmnoz_fakt := 0
      vyrzakitw->nmnoz_fakv := 0

      osoby->( dbseek( logCisOsoby,,'OSOBY01'))
      vyrzakitw->ncisosZal := osoby->ncisOsoby

    else
      c_typzak ->(dbseek(upper(typZ_vyrz),,'C_TYPZAK1'))

      ( vyrzakitw->nvarCis    := 1                             , ;
        vyrzakitw->nmnozPlano := 1                             , ;
        vyrzakitw->dZapis     := date()                        , ;
        vyrzakitw->cpriorZaka := '1 '                          , ;
        vyrzakitw->cstavZakaz := '1 '                          , ;
        vyrzakitw->cjmeOsZal  := logOsoba                      , ;
        vyrzakitw->crozm_Mj   := sysConfig('Prodej:cmjR_vyrz' ), ;
        vyrzakitw->crozmP_Mj  := sysConfig('Prodej:cmjR_vyrz' ), ;
        vyrzakitw->ctypZak    := typZ_vyrz                     , ;
        vyrzakitw->npolZak    := c_typzak->npolZak             , ;
        vyrzakitw->cmjVahaP   := sysConfig('Prodej:cmjH_vyrz' ), ;
        vyrzakitw->cmjVahaS   := sysConfig('Prodej:cmjH_vyrz' ), ;
        vyrzakitw->nkurZahMen := 1                             , ;
        vyrzakitw->nmnozPrep  := 1                             , ;
        vyrzakitw->czkratJedn := 'ks'                          , ;
        vyrzakitw->ctypDodPod := 'CPT'                         , ;
        vyrzakitw->cnazPol1   := a_nsVZak[1]                   , ;
        vyrzakitw->cnazPol2   := a_nsVZak[2]                   , ;
        vyrzakitw->cnazPol3   := a_nsVZak[3]                   , ;
        vyrzakitw->cnazPol4   := a_nsVZak[4]                   , ;
        vyrzakitw->cnazPol5   := a_nsVZak[5]                   , ;
        vyrzakitw->cnazPol6   := a_nsVZak[6]                     )
    endif
  endif
return nil


*
** uložení výrobní zakázky v transakci *****************************************
function pro_vyrzakit_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := pro_vyrzakit_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


static function pro_vyrzakit_wrt(odialog)
  local  mainOk  := .t., isRec_pl := .f.
  local  x, mnozPlano := vyrzakitw->nmnozPlano

  if .not. odialog:lnewRec
    vyrzakit->(dbgoto(vyrzakitw->_nrecor))

    mainOk := vyrzakit->(sx_rlock())

    if( isRec_pl := ( vyrZakitw->_nrecOr_pl <> 0 ))
      vyrZakpl->(dbgoto(vyrZakitw->_nrecOr_pl))

      mainOk := ( mainOk .and. vyrZakpl->(sx_rlock()) )
    endif
  endif

  if mainOk
    do case
    case odialog:lnewRec
      pro_vyrzakitw_ns()
      *
      mh_copyFld('vyrzakitw','vyrzak', .t., .f.)
      *
      **
      c_typzak->(dbseek(upper(vyrzakitw->ctypZak),,'C_TYPZAK1'))
      vyrzakitw->npolZak := c_typzak->npolZak
      **
      *
      do case
      case(c_typzak->npolZak = 2)
        pro_vyrzakitit_gen()

      otherWise
        vyrzakitw->ccisZakazI := allTrim(vyrzakitw->ccisZakaz)
        mh_copyFld('vyrzakitw','vyrzakit', .t., .f.)
      endcase

    case (vyrzakitw->_delrec = '9')
      vyrzakit->(dbdelete())
      if( isRec_pl, vyrZakpl->(dbdelete()), nil )

    otherwise
      mh_copyFld('vyrzakitw','vyrzakit',, .f.)
      if( isRec_pl, mh_copyFld('vyrZakitw','vyrZakpl',, .f.), nil )
    endcase
  else
    drgMsg(drgNLS:msg('Nelze modifikovat VÝROBNÍ ZAKÁZKU, blokováno uživatelem ...'),,odialog:drgDialog)
  endif

  vyrzak->(dbunlock(),dbcommit())
   vyrzakit->(dbunlock(),dbcommit())
    if( isRec_pl, vyrZakpl->(dbunlock(),dbcommit()), nil )
return mainOk


static function pro_vyrzakitit_gen()
  local x
  *
  local mnozPlano := vyrzakitw->nmnozPlano
  local zaloha    := vyrzakitw->nZaloha
  local cenaPrepr := vyrzakitw->ncenaPrepr
  local cenaProd  := vyrzakitw->ncenaProd

  c_dph->(dbSeek(vyrzakitw->nklicDph,,'C_DPH1'))

  for x := 1 to mnozPlano step 1
    vyrzakitw->nordItem   := x
    if mnozPlano = 1
      vyrzakitw->cvyrobCisl := allTrim(vyrzakitw->ccisZakaz) +'/1'
      vyrzakitw->ccisZakazI := allTrim(vyrzakitw->ccisZakaz) +'/1'
    else
      vyrzakitw->cvyrobCisl := allTrim(vyrzakitw->ccisZakaz) +'/' +allTrim( str(x))
      vyrzakitw->ccisZakazI := allTrim(vyrzakitw->ccisZakaz) +'/' +allTrim( str(x))
    endif
    vyrzakitw->nmnozPlano := 1
    vyrzakitw->ncenaCelk  := vyrzakitw->ncenaMj   * vyrzakitw->nmnozPlano
    vyrzakitw->ncenZakCel := vyrzakitw->ncenaCelk * (1 +c_dph->nprocDph/100)
    vyrzakitw->nZaloha    := zaloha    / mnozPlano
    vyrzakitw->ncenaPrepr := cenaPrepr / mnozPlano
    vyrzakitw->ncenaProd  := cenaProd  / mnozPlano

    mh_copyFld('vyrzakitw','vyrzakit', .t., .f.)
    mh_copyFld('vyrzakitw','vyrZakpl', .t., .f.)
  next
return .t.


static function pro_vyrzakitw_ns()
  local  x, cVAL, cITm, cfile := 'cnazPol', cFs
  *
  local  pa := {'', '', '', '', '', ''}, cnaklST := ''

  for x := 1 to 6 step 1
    cITm := 'cnazPol' +str(x,1)
    cVAL := upper(DBGetVal('vyrzakitw->' +cITm))
    cFs  := cfile +str(x,1)

    if .not. empty(cVAL)
      if .not. (cFs)->(dbSeek(cVAL,, AdsCtag(1) ))
        (cFs)->(dbAppend())
        DBPutVal(cFs +'->' +cITm,cVAL)

        if( x = 3, DBPutVal(cFs +'->cNazev', vyrzakitw->cnazevZak1), nil)
        (cFs)->(dbUnlock(), dbCommit())
      endif
    endif

    pa[x]   := cVAL
    cnaklST += cVAL
  next

  if .not. c_naklSt->(dbSeek(cnaklST,,'C_NAKLST1'))
    c_naklSt->(dbAppend())
    c_naklSt->cnazPol1 := pa[1]
    c_naklSt->cnazPol2 := pa[2]
    c_naklSt->cnazPol3 := pa[3]
    c_naklSt->cnazPol4 := pa[4]
    c_naklSt->cnazPol5 := pa[5]
    c_naklSt->cnazPol6 := pa[6]

    c_naklSt->(dbUnlock(), dbCommit())
  endif
return .t.