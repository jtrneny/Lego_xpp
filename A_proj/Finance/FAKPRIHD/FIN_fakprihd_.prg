#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"


FUNCTION FIN_fakprihd_cpy(oDialog)
  LOCAL  nKy := FAKPRIHD ->nCISFAK, doklad
  *
  LOCAL  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)

  ** tmp soubory **
  drgDBMS:open('FAKPRIHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('fakpriITw',.T.,.T.,drgINI:dir_USERfitm); ZAP  
  drgDBMS:open('PARPRZALw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  If .not. lNEWrec
    mh_COPYFLD('FAKPRIHD','FAKPRIHDw',.t., .t.)

    FORDREC( {'PARPRZAL,1'} )
    PARPRZAL ->( DbSetScope(SCOPE_BOTH,nKy)                                   , ;
                 DbGoTop()                                                    , ;
                 DbEval( { || mh_COPYFLD('PARPRZAL', 'PARPRZALw', .t., .t.) }), ;
                 DbClearScope()                                                 )
    FORDREC()
  ELSE
    FAKPRIHDw ->( DbAppend())
    doklad := FIN_RANGE_KEY('FAKPRIHD')[2]

    ( FAKPRIHDw ->cUloha     := "F"                             , ;
      FAKPRIHDw ->dPORIZFAK  := Date()                          , ;
      FAKPRIHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI           , ;
      FAKPRIHDw ->nROK       := uctOBDOBI:FIN:NROK              , ;
      FAKPRIHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI           , ;
      FAKPRIHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN        , ;
      FAKPRIHDw ->nFINTYP    := 1                               , ;
      FAKPRIHDw ->nCISFAK    := doklad                          , ;
      FAKPRIHDw ->cZKRATMENY := SysConfig( 'Finance:cZaklMENA' ), ;
      FAKPRIHDw ->cZKRATMENZ := SysConfig( 'Finance:cZaklMENA' ), ;
      FAKPRIHDw ->dVYSTFAK   := Date()                          , ;
      FAKPRIHDw ->cDENIK     := SysConfig( 'Finance:cDenikFAPR'), ;
      FAKPRIHDw ->cDENIK_puc := SysConfig( 'Finance:cDENIKpuc' ), ;
      FAKPRIHDw ->dVYSTFAKDO := Date()                          , ;
      FAKPRIHDw ->nMNOZPREP  := 1                               , ;
      FAKPRIHDw ->nKURZAHMEN := 1                               , ;
      FAKPRIHDw ->nPROCDAN_1 := SeekSazDPH(1)                   , ;
      FAKPRIHDw ->nPROCDAN_2 := SeekSazDPH(2)                   , ;
      FAKPRIHDw ->nKURZAHMED := 1                               , ;
      FAKPRIHDw ->nMNOZPREP  := 1                               , ;
      FAKPRIHDw ->nMNOZPRED  := 1                               , ;
      FAKPRIHDw ->nDOKLAD    := doklad                            )

      fakprihdw->ctyppohybu  := sysconfig('finance:ctyppohFAP')

    IF( C_BANKUC ->( mh_SEEK( .T., 2, .T.)), Nil, C_BANKUC ->( DBGoTop()) )
    FAKPRIHDw ->cBANK_UCT := C_BANKUC ->cBANK_UCT
  ENDIF
   *
  fakprihdw->lno_indph := .not. fakprihdw->lno_indph

  FIN_vykdph_cpy('FAKPRIHDw')
  FIN_parzalfak_vykdph_cpy( 'fakprihdw' )
RETURN NIL


*
** uložení závazku v transakci *************************************************
function fin_fakprihd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := fin_fakprihd_wrt(oDialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


*
** uložení závazku *************************************************************
static function FIN_fakprihd_wrt(oDialog)
  local  nPARZALFAK, nCISFAK, nRECs
  local  anPaz := {}, lPaz := .t.         //__PÁROVANÉ ZÁLOHY VAZBY   __________
  local  anRvz := {}, lRvz := .t.         //__ØÁDKY vÝKAZU DPH PAR_ZAL__________
  local  anFaz := {}, lFaz := .t.         //__PÁROVANÉ ZÁLOHY HLAVIÈKY__________

  LOCAL  lDONe := .T., zaklMena := SysConfig('Finance:cZaklMENA')
  *
  local  uctLikv

  parprzalw->(flock())
  fin_fakprihd_puc(FAKPRIHDw ->nFINTYP,'FAKPRIHDw')
  fin_fakprihd_parprzal(anPaz,anRvz,anFaz)

  uctLikv  := UCT_likvidace():new(upper(fakprihdw->culoha) +upper(fakprihdw->ctypdoklad),.T.)
  *
  lPaz := parprzal->(sx_rlock(anPaz))
  lFaz := fakprihd->(sx_rlock(anFaz))

  If( oDialog:lNEWrec, FAKPRIHD ->(DbAppend()), FAKPRIHD ->( DbGoTo(FAKPRIHDw ->_nRECOR)))


  IF FAKPRIHD ->(sx_RLock())                    .and. ;
     lPaz                                       .and. ;
     lFaz                                       .and. ;
     UCETPOL ->(sx_Rlock(uctLikv:ucetpol_rlo )) .and. ;
     fin_vykdph_rlo('FAKPRIHDw')

    *
    fakprihdw->lno_indph := .not. fakprihdw->lno_indph

    if(fakprihdw->_delrec <> '9', mh_copyfld('FAKPRIHDw', 'FAKPRIHD',, .f.), nil)

    nRECs   := FAKPRIHD ->( RecNo())
    nCISFAK := FAKPRIHD ->nCISFAK
    FAKPRIHD ->nDOKLAD := nCISFAK

    * u bìžných zálohových v tuzemské mìnì editujeme nCENZAHCEL musíme naplnit nCENZAKCEL
    * u celních
    do case
    case( fakprihd->nfinTyp = 2 )
      fakprihd->ncenZakCel := fakprihd->ncenZahCel
    case( fakprihd->nfinTyp = 3 .and. (fakprihd->czkratMenZ = zaklMena))
      fakprihd->ncenZakCel := fakprihd->ncenZahCel
    endcase

    FAKPRIHD ->nCENFAKCEL := FAKPRIHD ->nCENZAKCEL +FAKPRIHD ->nPARZALFAK
    FAKPRIHD ->nCENFAZCEL := FAKPRIHD ->nCENZAHCEL +FAKPRIHD ->nPARZAHFAK
    FAKPRIHD  ->( DbCommit())

    fakprihd->(sx_rlock(anFaz))

    do while .not. parprzalw->(eof())
      parprzal->(dbgoto(parprzalw->_nrecor))
      fakprihd->(dbgoto(parprzalw->nrecfaz))

      if parprzalw->_delrec = '9'
        fakprihd->nparzalfak -= parprzal->nparzalfak
        fakprihd->nparzahfak -= parprzal->nparzahfak
        parprzal->(dbDelete())
      else
        if(parprzalw->nparzahfak <> 0, fin_fakprihd_puc(5,'parprzalw'), nil)

        fakprihd->nparzalfak += (parprzalw->nparZalFak - parprzal->nparZalFak)
        fakprihd->nparzahfak += (parprzalw->nparZahFak - parprzal->nparZahFak)

        fakprihd->dparZalFak := date()
        mh_COPYFLD('parprzalw','parprzal',(parprzalw->_nrecor = 0), .f.)

        parprzal->ncisFak  := ncisFak
        parprzal->nrecFaZ  := parprzal->nrecPar := 0
      endif
      parprzalw->(dbSkip())
    enddo

    *
    fakprihd->(dbGoTo(nrecs))

    if(fakprihdw->_delrec = '9')  ;  uctLikv:ucetpol_del()
                                     fin_vykdph_wrt(NIL,.t.,'FAKPRIHD')
                                     fakprihd->(dbdelete())
    else                          ;  fin_vykdph_wrt(NIL,.f.,'FAKPRIHD')
                                     uctLikv:ucetpol_wrt()
    endif
  ELSE
    drgMsgBox(drgNLS:msg('Nelze modifikovat FAKTURU vystavenou, blokováno uživatelem !!!'))
    lDONe := .F.
  ENDIF

  fakprihd->(dbunlock(),dbcommit())
    parprzal->(dbunlock(),dbcommit())
     ucetpol->(dbunlock(),dbcommit())
RETURN lDONe


STATIC FUNCTION FIN_fakprihd_puc(nFINTYP,cFILE_ou)
  Local  cKy

  DEFAULT nFINTYP TO FAKPRIHDw ->nFINTYP
  drgDBMS:open('C_PODRUC')

  IF(nFINTYP = 4 .or. nFINTYP = 5)               // FAKPZAH, FAKPZAHZAL //
    cKy := StrZero(FAKPRIHDw ->nCISFIRMY,5) +Upper(FAKPRIHDw ->cZKRATMENZ)

    IF C_PODRUC ->(DbSeek(cKy,,'C_PODR2'))               // FIRMY->C_MENY->C_PODRUC
    ELSE
      cKy := Upper(FAKPRIHDw ->cZKRATMENZ)
      IF C_PODRUC ->(DbSeek(cKy,,'C_PODR1'))             // C_MENY->C_PODRUC
      ELSE
        cKy := '00000' +'   '
        IF C_PODRUC ->(DbSeek(cKy,,'C_PODR2'))           // ZAKLADNI
        ENDIF
      ENDIF
    ENDIF

    IF(nFINTYP = 4)                              // FAKPZAH
      (cFILE_ou) ->cUCET_pucR := C_PODRUC ->cUCTZ_puh
      (cFILE_ou) ->cUCET_pucS := C_PODRUC ->cUCTZ_puhS
    ELSE
      (cFILE_ou) ->cUCET_pucR := C_PODRUC ->cUCTZ_puz
      (cFILE_ou) ->cUCET_pucS := C_PODRUC ->cUCTZ_puzS
    ENDIF
  ENDIF
RETURN NIL

*
**                                    parprzal, vykdph_i, fakprihd
static function fin_fakprihd_parprzal(anPaz   ,anRvz    ,anFaz)
  local  filter, cisZalFak

  parprzalw->(AdsSetOrder(0), dbGoTop())

  do while .not. parprzalw->(eof())
    vykdph_pw->(dbgotop())
    cisZalFak := parprzalw->nciszalfak

    if parprzalw->_delrec = '9'
      if parprzalw->_nrecor = 0
         parprzalw->(dbDelete())

         vykdph_pw->(dbEval({|| vykdph_pw->(dbDelete())}       , ;
                            {|| vykdph_pw->ncisFak = cisZalFak}) )

      else
        aadd(anPaz,parprzalw->_nrecor)

        fakprihd->(dbSeek(cisZalFak,,'FPRIHD1'))
        parprzalw->nrecFaz := fakprihd->(recno())
        aadd(anFaz,fakprihd->(recno()))
        vykdph_pw->(dbEval({|| AAdd(anRvz,vykdph_pw->nrecvyk) }, ;
                           {|| vykdph_pw->ncisFak = cisZalFak})  )


*-        vykdph_pw->(dbEval({|| (aadd(anRvz,vykdph_pw->nrecvyk), vykdph_pw->(dbDelete())) }, ;
*-                           {|| vykdph_pw->ncisFak = cisZalFak}) )

      endif
    else
      aadd(anPaz,parprzalw->_nrecor)

      fakprihd->(dbSeek(cisZalFak,,'FPRIHD1'))
      parprzalw->nrecFaz := fakprihd->(recno())
      aadd(anFaz,fakprihd->(recno()))

      vykdph_pw->(dbEval({|| aadd(anRvz,vykdph_pw->nrecvyk)}, ;
                         {|| vykdph_pw->ncisFak = cisZalFak}) )
    endif

    parprzalw->(dbSkip())
  enddo

  vykdph_pw->(dbgotop()                                                 , ;
              fin_fakprihd_daz()                                        , ;
              dbeval({ || mh_copyfld('vykdph_pw','vykdph_iw',.t., .f.) }) )
  vykdph_iw->(flock(), dbCommit())
  parprzalw->(dbGoTop())
return nil


*
** zrušení faktury pøijaté
function fin_fakprihd_del(odialog)
  local  mainOk

  fakprihdw->_delrec := '9'
  parprzalw->(parprzalw->(AdsSetOrder(0),dbgotop()), dbeval({|| parprzalw->_delrec := '9'}))
  mainOk := fin_fakprihd_wrt_inTrans(odialog)
return mainOk



static function fin_fakprihd_daz()
  local  nZAKLdan_1 := nSAZdan_1 := nZAKLdan_2 := nSAZdan_2 := 0

  do while .not. vykdph_pw->(eof())
    do case
    case vykdph_pw->ntyp_dph = 1
      nZAKLdan_1 += vykdph_pw->nZAKLD_dph
      nSAZdan_1  += vykdph_pw->nSAZBA_dph

    case vykdph_pw->ntyp_dph = 2
      nZAKLdan_2 += vykdph_pw->nZAKLD_dph
      nSAZdan_2  += vykdph_pw ->nSAZBA_dph
    endcase

    vykdph_pw->(dbskip())
  enddo

  fakprihdw->nZAKLdaz_1 := nZAKLdan_1
  fakprihdw->nSAZdaz_1  := nSAZdan_1
  fakprihdw->nZAKLdaz_2 := nZAKLdan_2
  fakprihdw->nSAZdaz_2  := nSAZdan_2

  vykdph_pw->(dbgotop())
return nil