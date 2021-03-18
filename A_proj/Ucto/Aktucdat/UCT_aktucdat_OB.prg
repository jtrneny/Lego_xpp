#include "Common.ch"
#include "gra.ch"
#include "adsdbe.ch"
#include "dbstruct.ch'
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"



static  naktuc_cnt, p_kum, p_kumk, p_kumu, p_pocs
static  block_Ns, pa_Ns
static     it_Ns := "{...->cnazPol1,...->cnazPol2,...->cnazPol3," + ;
                    "...->cnazPol4,...->cnazPol5,...->cnazPol6}"

*
** AKTUALIZACE zùstatkù a OBratù na úètech z automatù po vr/sr/zr **************
procedure UCT_aktucdat_OB_vszR(xbp_therm)
  local nrecCnt, nkeyCnt, nkeyNo
  *
  local lisPOCs := .f., ckeyS

  nRecCNT := UCETKUMw ->(LastRec())
  nKeyCNT := nRecCNT / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)
  nKeyNO  := 1

  ucetkumw->(dbcommit(), dbgotop())

  if ucetkum->(flock()) .and. ucetkumk->(flock()) .and. ucetkumu->(flock())
    do while .not. ucetkumw->(eof())
      aktucdat_pb(xbp_therm, nKeyCNT, nKeyNO, nRecCNT)

      ckeyS := ucetkumw->ckey

      if .not. ucetkum->(dbseek(ckeyS,,'UCETK_01'))
        ucetkum->(dbAppend())

        ucetkum->cOBDOBI     := UCETSYS ->cOBDOBI
        ucetkum->nROK        := UCETSYS ->nROK
        ucetkum->nOBDOBI     := UCETSYS ->nOBDOBI
        ucetkum->cUCETMD     := Substr(ckeyS,  7, 6)
        ucetkum->cUCETTR     := SubStr(ckeyS,  7, 1)
        ucetkum->cUCETSK     := SubStr(ckeyS,  7, 2)
        ucetkum->cUCETSY     := SubStr(ckeyS,  7, 3)

        pa_Ns                := bin2Var( ucetKumw->pa_Ns)
        ucetkum->cnazPol1    := pa_Ns[1]
        ucetkum->cnazPol2    := pa_Ns[2]
        ucetkum->cnazPol3    := pa_Ns[3]
        ucetkum->cnazPol4    := pa_Ns[4]
        ucetkum->cnazPol5    := pa_Ns[5]
        ucetkum->cnazPol6    := pa_Ns[6]

        ucetkum->nKcMDobrO   := ucetkumW ->nKcMDobrO
        ucetkum->nKcDALobrO  := ucetkumW ->nKcDALobrO
        ucetkum ->naktUc_CNT := naktUc_cnt +1
      else
        ucetkum->nKcMDobrO   += ucetkumW ->nKcMDobrO
        ucetkum->nKcDALobrO  += ucetkumW ->nKcDALobrO
        ucetkum ->naktUc_CNT := naktUc_cnt +1
      endif

      aktucdat_vp(lisPOCs,.t.,.f.)

      ucetkumw->(dbskip())
      nkeyNo++
    enddo
  endif
return


*
** AKTUALIZACE zùstatkù a OBratù na úètech z automatù vr/sr/zr/nv **************
procedure UCT_aktucdat_OBa(xbp_therm)
  local nrecCnt, nkeyCnt, nkeyNo
  *
  local lisPOCs := .f., ckeyS
  local ckeyY  := strZero(ucetsys->nrok,4) +strZero(ucetsys->nobdobi,2) +'Y', nsel
  local filtr  := "nrok = %% .and. nobdobi = %% .and. left(cdenik,1) = 'Y'", filtrs

  *
  ** zahrnout skuteèné náklady na stroje do zpracování
  if ucetpola->(dbseek( ckeyY,,'UCETPO09'))
    if ucetpola->(flock())
      nsel := ConfirmBox( ,'Zahrnout skuteèné náklady na stroje do zpracování ?' , ;
                           'Skuteèné náklady na stoje ...'                       , ;
                            XBPMB_YESNO                                          , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

      * naèteme ?? pro zpracování do ucetkumw
      filtrs := format(filtr, {ucetsys->nrok, ucetsys->nobdobi})
      ucetpola->(ads_setAof(filtrs), AdsSetOrder('UCETPO07'), dbgotop() )

      if nsel = XBPMB_RET_YES
        UCT_aktucdat_OBy(xbp_therm)
      else
        * zrušíme v ucetpola
        ucetpola->(dbgotop()                             , ;
                   dbeval( { || ucetpola->(dbdelete()) }   ) )

        ucetpola->(dbunlock(), ads_clearAof())
      endif
    endif
  endif

  *
  ** uložení do ucetkum, ucetkumk,. ucetkumu
  p_kum      := {}
  p_kumk     := {}
  p_pocs     := {}

  nRecCNT := UCETKUMw ->(LastRec())
  nKeyCNT := nRecCNT / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)
  nKeyNO  := 1

  ucetkumw->(dbcommit(), dbgotop())

  if ucetkum->(flock()) .and. ucetkumk->(flock()) .and. ucetkumu->(flock())
    do while .not. ucetkumw->(eof())
      aktucdat_pb(xbp_therm, nKeyCNT, nKeyNO, nRecCNT)

      ckeyS := ucetkumw->ckey

      if .not. ucetkum->(dbseek(ckeyS,,'UCETK_01'))
        ucetkum->(dbAppend())

        ucetkum->cOBDOBI     := UCETSYS ->cOBDOBI
        ucetkum->nROK        := UCETSYS ->nROK
        ucetkum->nOBDOBI     := UCETSYS ->nOBDOBI
        ucetkum->cUCETMD     := Substr(ckeyS,  7, 6)
        ucetkum->cUCETTR     := SubStr(ckeyS,  7, 1)
        ucetkum->cUCETSK     := SubStr(ckeyS,  7, 2)
        ucetkum->cUCETSY     := SubStr(ckeyS,  7, 3)
        
        pa_Ns                := bin2Var( ucetKumw->pa_Ns)
        ucetkum->cnazPol1    := pa_Ns[1]
        ucetkum->cnazPol2    := pa_Ns[2]
        ucetkum->cnazPol3    := pa_Ns[3]
        ucetkum->cnazPol4    := pa_Ns[4]
        ucetkum->cnazPol5    := pa_Ns[5]
        ucetkum->cnazPol6    := pa_Ns[6]

        ucetkum->nKcMDobrO   := ucetkumW ->nKcMDobrO
        ucetkum->nKcDALobrO  := ucetkumW ->nKcDALobrO
        ucetkum ->naktUc_CNT := naktUc_cnt +1
      else
        ucetkum->nKcMDobrO   += ucetkumW ->nKcMDobrO
        ucetkum->nKcDALobrO  += ucetkumW ->nKcDALobrO
        ucetkum ->naktUc_CNT := naktUc_cnt +1
      endif

      aktucdat_vp(lisPOCs,.t.,.f.)

      if( .not. ucetkumK->(dbSeek(ckeyS,,'UCETK_01')), ucetkumK->(dbAppend()), nil)
      db_to_db('ucetkum', 'ucetkumK')

      ucetkumw->(dbskip())
      nkeyNo++
    enddo
  endif
return


static function UCT_aktucdat_OBy(xbp_therm)
  LOCAL  nKCMD, nKCDAL, nMNOZNAT, nMNOZNAT2
  LOCAL  cKEYs
  *
  ** aktualizuje ucetkumw z ucetpola pro deník Y?
  cKEYs    := UCETPOLa ->(&(IndexKey()))
  block_Ns := COMPILE( strTran( it_Ns, '...', 'ucetpola' ) )
     pa_Ns := EVAL(block_Ns)

  ( nKCMD := nKCDAL := nMNOZNAT := nMNOZNAT2 := 0 )

  do while .not. UCETPOLa ->( EOF())
    If cKEYs == UCETPOLa ->(&(IndexKey()))
      nKCMD     += UCETPOLa ->nKcMD
      nKCDAL    += UCETPOLa ->nKcDAL
      nMNOZNAT  += UCETPOLa ->nMNOZNAT
      nMNOZNAT2 += UCETPOLa ->nMNOZNAT2
    Else
      IF UCETKUMw ->( DBSeek(cKEYs))
        UCETKUMw ->nKCMDOBRO  := nKCMD
        UCETKUMw ->nKCDALOBRO := nKCDAL
        UCETKUMw ->nMNOZNAT   := nMNOZNAT
        UCETKUMw ->nMNOZNAT2  := nMNOZNAT2
      ELSE
        UCETKUMw ->( DbAppend())
        UCETKUMw ->cKEy       := cKEYs

        UCETKUMw ->nKCMDOBRO  := nKCMD
        UCETKUMw ->nKCDALOBRO := nKCDAL
        UCETKUMw ->nMNOZNAT   := nMNOZNAT
        UCETKUMw ->nMNOZNAT2  := nMNOZNAT2

        UCETKUMw ->pa_Ns      := var2Bin( pa_Ns )
      ENDIF

      cKEYs     := UCETPOLa ->(&(IndexKey()))
      pa_Ns     := EVAL(block_Ns)

      nKCMD     := UCETPOLa ->nKcMD
      nKCDAL    := UCETPOLa ->nKcDAL
      nMNOZNAT  := UCETPOLa ->nMNOZNAT
      nMNOZNAT2 := UCETPOLa ->nMNOZNAT2
    EndIf
    UCETPOLa ->( DbSkip())
  ENDDO

  ** poslední nápoèet
  if UCETKUMw ->( DBSeek(cKEYs))
    UCETKUMw ->nKCMDOBRO  := nKCMD
    UCETKUMw ->nKCDALOBRO := nKCDAL
    UCETKUMw ->nMNOZNAT   := nMNOZNAT
    UCETKUMw ->nMNOZNAT2  := nMNOZNAT2
  else
    UCETKUMw ->( DbAppend())
    UCETKUMw ->cKEy       := cKEYs

    UCETKUMw ->nKCMDOBRO  := nKCMD
    UCETKUMw ->nKCDALOBRO := nKCDAL
    UCETKUMw ->nMNOZNAT   := nMNOZNAT
    UCETKUMw ->nMNOZNAT2  := nMNOZNAT2

    UCETKUMw ->pa_Ns      := var2Bin( pa_Ns )
  endif
Return( nil)


********************************************************************************
**                                            2 ...    KONTROLA_OBRATY_SALDO
**                                            4 ...             OBRATY_SALDO
** AKTUALIZACE zùstatkù a OBratù na úètech *************************************
procedure uct_aktucdat_ob(cobd_akt, cobd_psn, xbp_therm)
  LOCAL  nRecCNT, nKeyCNT, nKeyNO, nSTEPs
  LOCAL  nKCMD, nKCDAL, nMNOZNAT, nMNOZNAT2
  LOCAL  cOBD_min, cKEYs
  //
  LOCAL  lIsPOCs := .F., x, rec, pos

  drgDBMS:open('UCETKUMw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  cOBD_min := LEFT( cOBD_akt, 4) +STRZERO( VAL( RIGHT( cOBD_akt, 2)) -1, 2)

  // NAPOZICUJEME UCETSYS //
  UCETSYS ->( DbSeek( 'U' +cOBD_akt))
  *
  p_kum      := {}
  p_kumk     := {}
  p_kumu     := {}
  p_pocs     := {}
  naktuc_cnt := UCETSYS ->nAKTUC_CNT +1

  aktucdat_ini(cobd_akt,cobd_psn)

  lIsPOCs  := (cobd_akt = cobd_psn)                            //_ poèáteèní stavy úètù
  nrecCnt  := uct_setScope('ucetpol',7,cobd_akt)               //_ omezíme ucetpol na aktuální období
  nrecCnt  += uct_setScope('ucetkum','UCETK_01',cobd_min)      //_ naètení ucetkum-1 nebo ucetpocs

  nKeyCNT  := nRecCNT / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)
  nKeyNO   := 1
  block_Ns := COMPILE( strTran( it_Ns, '...', 'ucetkum' ) )

  ** naètení ucetkum -1 nebo ucetpocs
  do while .not. UCETKUM ->(EOF())
    aktucdat_PB(xbp_therm,nKeyCNT,nKeyNO, nRecCNT)
    UCETKUMw ->( DbAppend())
      pa_Ns                 := EVAL(block_Ns)

      UCETKUMw ->cKEy       := cOBD_akt +SubStr(UCETKUM ->(&(IndexKey())),7)

      UCETKUMw ->nKCMDPSO   := UCETKUM ->nKCMDKSR
      UCETKUMw ->nKCDALPSO  := UCETKUM ->nKCDALKSR
      UCETKUMw ->nKCMDOBRR  := UCETKUM ->nKCMDOBRR
      UCETKUMw ->nKCDALOBRR := UCETKUM ->nKCDALOBRR
      UCETKUMw ->nKCMDPSR   := UCETKUM ->nKCMDPSR
      UCETKUMw ->nKCDALPSR  := UCETKUM ->nKCDALPSR
      UCETKUMw ->nMNOZNATR  := UCETKUM ->nMNOZNATR
      UCETKUMw ->nMNOZNAT2R := UCETKUM ->nMNOZNAT2R

      UCETKUMw ->pa_Ns      := var2Bin( pa_Ns )

    UCETKUM ->( DbSkip())
    nKeyNO++
  enddo
  uct_clearScope('ucetkum')

  ** aktualizaye ucetkumw z ucetpol
  cKEYs    := UCETPOL ->(&(IndexKey()))
  block_Ns := COMPILE( strTran( it_Ns, '...', 'ucetpol' ) )
     pa_Ns := EVAL(block_Ns)

  ( nKCMD := nKCDAL := nMNOZNAT := nMNOZNAT2 := 0 )

  do while .not. UCETPOL ->( EOF())
    aktucdat_PB(xbp_therm,nKeyCNT,nKeyNO, nRecCNT)
    If cKEYs == UCETPOL ->(&(IndexKey()))
      nKCMD     += UCETPOL ->nKcMD
      nKCDAL    += UCETPOL ->nKcDAL
      nMNOZNAT  += UCETPOL ->nMNOZNAT
      nMNOZNAT2 += UCETPOL ->nMNOZNAT2
    Else
      IF UCETKUMw ->( DBSeek(cKEYs))
        UCETKUMw ->nKCMDOBRO  := nKCMD
        UCETKUMw ->nKCDALOBRO := nKCDAL
        UCETKUMw ->nMNOZNAT   := nMNOZNAT
        UCETKUMw ->nMNOZNAT2  := nMNOZNAT2
      ELSE
        UCETKUMw ->( DbAppend())
        UCETKUMw ->cKEy       := cKEYs

        UCETKUMw ->nKCMDOBRO  := nKCMD
        UCETKUMw ->nKCDALOBRO := nKCDAL
        UCETKUMw ->nMNOZNAT   := nMNOZNAT
        UCETKUMw ->nMNOZNAT2  := nMNOZNAT2

        UCETKUMw ->pa_Ns      := var2Bin( pa_Ns )
      ENDIF

      cKEYs     := UCETPOL ->(&(IndexKey()))
      pa_Ns     := EVAL(block_Ns)

      nKCMD     := UCETPOL ->nKcMD
      nKCDAL    := UCETPOL ->nKcDAL
      nMNOZNAT  := UCETPOL ->nMNOZNAT
      nMNOZNAT2 := UCETPOL ->nMNOZNAT2
    EndIf
    UCETPOL ->( DbSkip())
    nKeyNO++
  ENDDO

  ** poslední nápoèet
  if UCETKUMw ->( DBSeek(cKEYs))
    UCETKUMw ->nKCMDOBRO  := nKCMD
    UCETKUMw ->nKCDALOBRO := nKCDAL
    UCETKUMw ->nMNOZNAT   := nMNOZNAT
    UCETKUMw ->nMNOZNAT2  := nMNOZNAT2
  else
    UCETKUMw ->( DbAppend())
    UCETKUMw ->cKEy       := cKEYs

    UCETKUMw ->nKCMDOBRO  := nKCMD
    UCETKUMw ->nKCDALOBRO := nKCDAL
    UCETKUMw ->nMNOZNAT   := nMNOZNAT
    UCETKUMw ->nMNOZNAT2  := nMNOZNAT2

    UCETKUMw ->pa_Ns      := var2Bin( pa_Ns )
  endif

  xbp_therm:configure()

  ** uložení do ucetkum, ucetkumk,. ucetkumu
  nRecCNT := UCETKUMw ->(LastRec())
  nKeyCNT := nRecCNT / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)
  nKeyNO  := 1

  ucetkumw->(dbcommit(), dbgotop())

  if ucetkum->(flock()) .and. ucetkumk->(flock()) .and. ucetkumu->(flock())
    do while .not. ucetkumw->(eof())
      aktucdat_pb(xbp_therm, nKeyCNT, nKeyNO, nRecCNT)

      aktucdat_sek('ucetkum' ,ucetkumw->ckey, .f.)
      aktucdat_vp(lIsPOCs,.f.,.t.)                                                // pøepoèti UCETKUM
      *
      aktucdat_sek('ucetkumk',ucetkumw->ckey, .f.)

      ucetkumw->(dbskip())
      nkeyNo++
    enddo
  endif

  ** dojedeme ucetpocs pokud jde o období poèáteèního stavu
  if lIsPOCs .and. len(p_pocs) <> 0
    ucetkumw->(dbZap())

    for x := 1 to len(p_pocs) step 1
      ucetpocs->(dbgoto(p_pocs[x]))
      ckeys := cobd_akt +subStr(ucetpocs->(sx_keyData()),5)

      if( .not. ucetkum->(dbseek(ckeys)), ucetkum->(dbAppend()), nil)

      rec := ucetkum->(recno())
      if((pos := ascan(p_kum, rec)) <> 0, (adel(p_kum,pos), asize(p_kum, len(p_kum)-1)), nil)

      db_to_db('ucetpocs','ucetkum')
      ( ucetkum->nrok       := ucetsys->nrok                , ;
        ucetkum->nobdobi    := ucetsys->nobdobi             , ;
        ucetkum->cobdobi    := ucetsys->cobdobi             , ;
        ucetkum->cucettr    := substr(ucetpocs->cucetmd,1,1), ;
        ucetkum->cucetsk    := substr(ucetpocs->cucetmd,1,2), ;
        ucetkum->cucetsy    := substr(ucetpocs->cucetmd,1,3), ;
        ucetkum->nkcMdObrO  := 0                            , ;
        ucetkum->nkcDalObrO := 0                            , ;
        ucetkum->nmnozNat   := 0                            , ;
        ucetkum->nmnozNat2  := 0                              )

      aktucdat_vp(.t.,.f.,.f.)
      *
      ckeys := ucetkum->(sx_keyData(1))
      aktucdat_sek('ucetkumk',ckeys)
    next
  endif

  aeval(p_kum , {|x| ucetkum ->(dbgoto(x),dbdelete())})
   aeval(p_kumk, {|x| ucetkumk->(dbgoto(x),dbdelete())})

  ucetsys->(dbRlock())
  ucetsys->naktuc_ks  := 2
  ucetsys->naktuc_cnt := naktuc_cnt
  ucetsys->caktkdo    := logOsoba
  ucetsys->daktdat    := date()
  ucetsys->(dbUnlock())

  ucetpocs->(dbClearScope())
   ucetkum->(dbCommit(),dbUnlock())
    ucetkumk->(dbCommit(),dbUnlock())
     ucetkumu->(dbCommit(),dbUnlock())
RETURN


*
** výpoèet stavu položky *******************************************************
static procedure aktucdat_VP( lIsPOCs, lIsAUTO, ldel_pocs)
  local  nKcMD, nKcDAL
  local  pa   := p_pocs, rec
  local  ckey := strzero(ucetkum->nrok,4) +                                    + ;
                 upper(ucetkum->cUCETMD +                                      + ;
                       ucetkum->cnazpol1 +ucetkum->cnazpol2 +ucetkum->cnazpol3 + ;
                       ucetkum->cnazpol4 +ucetkum->cnazpol5 +ucetkum->cnazpol6)


  If     lIsPOCs  ;  if ucetpocs->(dbseek(ckey))
                       if ldel_pocs
                         rec := ucetpocs->(recno())
                         if((pos := ascan(pa, rec)) <> 0, (adel(pa,pos), asize(pa, len(pa)-1)), nil)
                       endif
                     endif

                     UcetKUM ->nKcMDpsO  := UcetPOCS ->nKcMDpsR
                     UcetKUM ->nKcDALpsO := UcetPOCS ->nKcDALpsR
                     UcetKUM ->nKcMDpsR  := UcetPOCS ->nKcMDpsR
                     UcetKUM ->nKcDALpsR := UcetPOCS ->nKcDALpsR
  ElseIf lIsAUTO  ;  nKcMD               := ucetkumW ->nkcMDobrO
                     nKcDAL              := ucetkumW ->nkcDALobrO
  Else            ;  UcetKUM ->nKcMDpsO  := UcetKUMw ->nKCMDPSO
                     UcetKUM ->nKcDALpsO := UcetKUMw ->nKCDALPSO
                     UcetKUM ->nKcMDpsR  := UcetKUMw ->nKcMDpsR
                     UcetKUM ->nKcDALpsR := UcetKUMw ->nKcDALpsR
  EndIf

  If     lIsPOCs
    UCETKUM ->nKCMDobrR  := UCETKUM ->nKCMDobrO
    UCETKUM ->nKCDALobrR := UCETKUM ->nKCDALobrO
  ElseIf lIsAUTO
    UCETKUM ->nKCMDobrR  += nKcMD
    UCETKUM ->nKCDALobrR += nKcDAL
  Else
    UCETKUM ->nKCMDobrR  := UcetKUMw ->nKCMDobrR  +UCETKUM ->nKCMDobrO
    UCETKUM ->nKCDALobrR := UcetKUMw ->nKCDALobrR +UCETKUM ->nKCDALobrO
  EndIf

  UcetKUM ->nMNOZnatR  := UcetKUMw ->nMNOZnatR  +UcetKUM ->nMNOZnat
  UcetKUM ->nMNOZnat2R := UcetKUMw ->nMNOZnat2R +UcetKUM ->nMNOZnat2

  nKcMD  := UcetKUM ->nKcMDpsR  +UcetKUM ->nKcMDobrR
  nKcDAL := UcetKUM ->nKcDALpsR +UcetKUM ->nKcDALobrR

  UcetKUM ->nKcMDksR := UcetKUM ->nKcDALksR := 0

  C_UCTOSN ->( dbSEEK( UPPER( UCETKUM ->cUCETMD)))

  Do Case
  Case( C_UCTOSn ->cZustUCT == 'M' ) ; UcetKUM ->nKcMDksR  := nKcMD  -nKcDAL
  Case( C_UCTOSn ->cZustUCT == 'D' ) ; UcetKUM ->nKcDALksR := nKcDAL -nKcMD
  OtherWise
  If     nKcMD > nKcDAL  ;  UcetKUM ->nKcMDksR  := nKcMD  -nKcDAL
  ElseIf nKcMD < nKcDAL  ;  UcetKUM ->nKcDALksR := nKcDAL -nKcMD
  EndIf
  EndCase
return


static function aktucdat_ini(cobd_akt,cobd_psn)

  ucetkum ->(AdsSetOrder('UCETK_01')                        , ;
             dbsetScope(SCOPE_BOTH, cobd_akt)               , ;
             dbgotop()                                      , ;
             dbeval({|| aadd(p_kum, ucetkum->(recno())) })  , ;
             dbclearscope()                                   )

  ucetkumk->(AdsSetOrder('UCETK_01')                        , ;
             dbsetScope(SCOPE_BOTH, cobd_akt)               , ;
             dbgotop()                                      , ;
             dbeval({|| aadd(p_kumk, ucetkumk->(recno())) }), ;
             dbclearscope()                                   )

  ucetkumu->(AdsSetOrder('UCETK_02')                        , ;
             dbsetScope(SCOPE_BOTH, cobd_akt)               , ;
             dbgotop()                                      , ;
             dbeval({|| aadd(p_kumu, ucetkumu->(recno())) }), ;
             dbclearscope()                                   )

  ucetpocs->(AdsSetOrder('POCSTU01')                        , ;
             dbSetScope(SCOPE_BOTH, left(cobd_psn,4))       , ;
             dbgotop()                                      , ;
             dbeval({|| aadd(p_pocs, ucetpocs->(recno())) })  )

return nil


static function aktucdat_sek(cfile,ckey)
  local  pa := if(cfile = 'ucetkum',p_kum,p_kumk), rec, pos
  *

  if (cfile)->(dbseek(ckey))
    rec := (cfile)->(recno())
    if((pos := ascan(pa, rec)) <> 0, (adel(pa,pos), asize(pa, len(pa)-1)), nil)

    if(cfile = 'ucetkumk')
      db_to_db('ucetkum',cfile)
    else
      (cfile)->nKCMDOBRO  := UCETKUMw ->nKCMDOBRO
      (cfile)->nKCDALOBRO := UCETKUMw ->nKCDALOBRO
      (cfile)->nMNOZNAT   := UCETKUMw ->nMNOZNAT
      (cfile)->nMNOZNAT2  := UCETKUMw ->nMNOZNAT2
      (cfile)->nAKTUC_CNT := nAKTUC_CNT
    endif
  else
    (cfile)->( DbAppend())

    if(cfile = 'ucetkumk')
       db_to_db('ucetkum',cfile)
    else
      (cfile)->cOBDOBI    := UCETSYS ->cOBDOBI
      (cfile)->nROK       := UCETSYS ->nROK
      (cfile)->nOBDOBI    := UCETSYS ->nOBDOBI
      (cfile)->cUCETMD    := Substr(ckey,  7, 6)
      (cfile)->cUCETTR    := SubStr(ckey,  7, 1)
      (cfile)->cUCETSK    := SubStr(ckey,  7, 2)
      (cfile)->cUCETSY    := SubStr(ckey,  7, 3)
      /*
      (cfile)->cNAZPOL1   := SubStr(ckey, 13, 8)
      (cfile)->cNAZPOL2   := SubStr(ckey, 21, 8)
      (cfile)->cNAZPOL3   := SubStr(ckey, 29, 8)
      (cfile)->cNAZPOL4   := SubStr(ckey, 37, 8)
      (cfile)->cNAZPOL5   := SubStr(ckey, 45, 8)
      (cfile)->cNAZPOL6   := SubStr(ckey, 53, 8)
      */
      pa_Ns               := bin2Var( ucetKumw->pa_Ns)
      (cfile)->cNAZPOL1   := pa_Ns[1]
      (cfile)->cNAZPOL2   := pa_Ns[2]
      (cfile)->cNAZPOL3   := pa_Ns[3]
      (cfile)->cNAZPOL4   := pa_Ns[4]
      (cfile)->cNAZPOL5   := pa_Ns[5]
      (cfile)->cNAZPOL6   := pa_Ns[6]
      *
      (cfile)->NKCMDPSO   := UCETKUMw ->nKCMDPSO
      (cfile)->NKCDALPSO  := UCETKUMw ->nKCDALPSO
      (cfile)->nKCMDOBRO  := UCETKUMw ->nKCMDOBRO
      (cfile)->nKCDALOBRO := UCETKUMw ->nKCDALOBRO
      (cfile)->nKCMDOBRR  := UCETKUMw ->nKCMDOBRR
      (cfile)->nKCDALOBRR := UCETKUMw ->nKCDALOBRR
      (cfile)->nMNOZNAT   := UCETKUMw ->nMNOZNAT
      (cfile)->nMNOZNAT2  := UCETKUMw ->nMNOZNAT2
      (cfile)->nMNOZNATR  := UCETKUMw ->nMNOZNATR
      (cfile)->nMNOZNAT2R := UCETKUMw ->nMNOZNAT2R
      (cfile)->nAKTUC_CNT := nAKTUC_CNT
    endif
 endif
return nil


static function db_to_db(cDBfrom,cDBto)
  local aFrom := ( cDBFrom) ->( dbStruct())

  aEval( aFrom, { |X,M| ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                          nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                          If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )
return nil


*
**
function uct_aktucdat_kumU(cobd_akt, xbp_therm)
  local  nrecCnt, nkeyCnt, nkeyNo
  local  pa := p_kumu, rec, pos := 0, ckey := '', ckeyS
  *
  local  isOk := .f., nkcMd, nkcDal

  nrecCnt := uct_setScope('ucetkum','UCETK_01',cobd_akt)

  nKeyCNT := nRecCNT / Round(xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)
  nKeyNO  := 1

  if  ucetkumu->(flock())
    isOk := .t.
    do while .not. ucetkum->(eof())
      aktucdat_pb(xbp_therm, nKeyCNT, nKeyNO, nRecCNT)

      ckeyS := left( ucetkum->( sx_keyData()), 12)

      if ucetkumu->(dbseek(ckeyS))
        rec := ucetkumu->(recno())
        if((pos := ascan(pa, rec)) <> 0, (adel(pa,pos), asize(pa, len(pa)-1)), nil)
      else
        ucetkumu->(dbappend())
        pos := 1
      endif

      if(pos <> 0, db_to_db('ucetkum','ucetkumu'), nil)

      if ckey = left(ucetkum->( sx_keyData()), 12)
        ucetkumU ->nKcMDpsO   += ucetkum ->nKcMDpsO
        ucetkumU ->nKcDALpsO  += ucetkum ->nKcDALpsO

        ucetkumU ->nKcMDobrO  += ucetkum ->nKcMDobrO
        ucetkumU ->nKcDALobrO += ucetkum ->nKcDALobrO

        ucetkumU ->nKcMDpsR   += ucetkum ->nKcMDpsR
        ucetkumU ->nKcDALpsR  += ucetkum ->nKcDALpsR

        ucetkumU ->nkcMDobrR  += ucetkum ->nKcMDobrR
        ucetkumU ->nkcDALobrR += ucetkum ->nKcDALobrR

        ucetkumu ->nKcMDksR   += ucetkum ->nKcMDksR
        ucetkumu ->nKcDALksR  += ucetkum ->nKcDALksR

        UCETKUMU ->nMnozNat   += UCETKUM ->nMnozNat
        UCETKUMU ->nMnozNat2  += UCETKUM ->nMnozNat2
        UCETKUMU ->nMNOZnatR  += UCETKUM ->nMNOZnatR
        UCETKUMU ->nMNOZnat2R += UCETKUM ->nMNOZnat2R
      else
        db_to_db('ucetkum','ucetkumu')

        ckey := left( ucetkum->( sx_keyData()), 12)
      endif

      ucetkum->(dbskip())
      nkeyNo++
    enddo
  endif

  aeval(p_kumu, {|x| ucetkumu->(dbgoto(x),dbdelete())})

  *
  ** dopoèet nové položky
  if isOk
    ucetkumU->(dbGoTop())
    do while .not. ucetkumU->(eof())
      nkcmd  := ucetkumU->nkcMDpsR  +ucetkumU->nkcMDobrR
      nKcdal := ucetkumU->nkcDALpsR +ucetkumU->nkcDALobrR

      ucetkumU->nkcMDksRD := ucetkumu->nkcDALksRD := 0

      c_uctosn->( dbSeek(Upper(ucetkumu->cucetmd)))

      do case
      case( c_uctosn ->czustUCT == 'M' ) ; ucetkumU ->nkcMDksRD  := nkcMd  -nkcDal
      case( c_uctosn ->czustUCT == 'D' ) ; ucetkumU ->nkcDALksRD := nkcDal -nkcMd
      otherwise
        if     nkcMd > nkcDal  ;  ucetkumU->nkcMDksRD  := nkcMd  -nkcDal
        elseif nkcMd < nkcDal  ;  ucetkumU->nkcDALksRD := nkcDal -nkcMd
        endif
      EndCase
      ucetkumU->(dbSkip())
    enddo
  endif

  uct_clearScope('ucetkum')
  ucetkumu->(dbCommit(),dbUnlock())
  xbp_therm:configure()
return .t.


/*

 nkcmd  := ucetkumu->nKcMDpsR  +ucetkumu->nKcMDobrR
  nKcdal := ucetkumu->nKcDALpsR +ucetkumu->nKcDALobrR

  ucetkumu->nKcMDksR := ucetkumu->nKcDALksR := 0

  c_uctosn->( dbSeek(Upper(ucetkumu->cucetmd)))

  do case
  case( C_UCTOSn ->cZustUCT == 'M' ) ; UcetKUMU ->nKcMDksR  := nKcMD  -nKcDAL
  case( C_UCTOSn ->cZustUCT == 'D' ) ; UcetKUMU ->nKcDALksR := nKcDAL -nKcMD
  otherwise
    if     nKcMD > nKcDAL  ;  UcetKUMU ->nKcMDksR  := nKcMD  -nKcDAL
    elseif nKcMD < nKcDAL  ;  UcetKUMU ->nKcDALksR := nKcDAL -nKcMD
    endif
  EndCase


*/