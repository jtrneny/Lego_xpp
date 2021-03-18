**
**  Remarks
**  FPriUh_CPY() ->  FIN_prikuhhd_cpy()
**  FPriUh_INS() ->  FIN_prikuhhd_ins()
**  FPriUh_WRT() ->  FIN_prikuhhd_wrt()



#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"


FUNCTION FIN_prikuhhd_cpy(oDialog)
  LOCAL  nCENZAKCEL := 0, zkrMeny
  LOCAL  cKy, cisFak_OR
  *
  local  zaklMena     := SysConfig('Finance:cZaklMena')

  ** tmp soubory **
  drgDBMS:open('PRIKUHHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PRIKUHITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF .not. oDialog:lNEWrec
    mh_copyfld('PRIKUHHD', 'PRIKUHHDw', .t., .t.)

    prikuhit->(dbgoTop())

    DO WHILE !PRIKUHIT ->(Eof())

      mh_COPYFLD('PRIKUHIT', 'PRIKUHITw', .t., .t.)
      nCENZAKCEL += PRIKUHIT ->nPRIUHRCEL

      cisFak_OR := 0
            cKy := Upper(PRIKUHIT ->cDENIK) +StrZero(PRIKUHIT ->nCISFAK,10)

      if prikUhHD->csubTask = 'MZD'
        if( mzdZavHD ->(DbSeek(cKy,,'MZDZAVHD12')), cisFak_OR := mzdZavHD->( recNo()), nil )
      else
        FAKPRIHD ->(DbSeek(cKy,,'FPRIHD15'))
        cisFak_OR := fakPriHD->( recNo())
      endif

      PRIKUHITw ->nCISFAK_OR := cisFak_OR
      PRIKUHITw ->nPRIUHR_OR := PRIKUHIT ->nPRIUHRCEL

      PRIKUHIT ->(DbSkip())
    ENDDO
    PRIKUHHDw ->nCENZAKCEL := nCENZAKCEL
    C_BANKUC ->( mh_SEEK( PRIKUHHDw ->cBANK_UCT, 1, .T.))
  ELSE

    drgDBMS:open( 'prikUhhd',,,,,'prik_Uhhd')
    prik_Uhhd->(ordSetFocus('FDODHD1'), dbgoBottom())
*    fOrdRec({'prikuhhd,1'})
*    prikuhhd->(dbGoBottom())

    * najdeme pøednastavený úèet úhrady
    if( c_bankUc->( dbseek( .T.,, 'BANKUC2')), nil, c_bankUc->( dbgoTop()) )

    if .not. Equal( zaklMena, c_bankUc->czkratMeny)
      prikUhHdw->ctypDoklad := 'FIN_PRUHZA'
      prikUhHdw->ctypPohybu := 'PRIUHRZAH'
    else
*      c_bankUc->( ads_setAof( c_bankUc_AOF), dbgotop())
    endif

    mh_COPYFLD('C_BANKUC', 'PRIKUHHDw',.t., .f.)

     ( PRIKUHHDw ->cULOHA     := 'F'                  , ;
       PrikUhHDW ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI, ;
       PrikUhHDW ->nROK       := uctOBDOBI:FIN:NROK   , ;
       PrikUhHDW ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI, ;
       PRIKUHHDw ->nDOKLAD    := prik_Uhhd->nDOKLAD +1, ;
       PRIKUHHDw ->cZKRATMENZ := zaklMena             , ;
       PRIKUHHDw ->nKURZAHMEN := 1                    , ;
       PRIKUHHDw ->nMNOZPREP  := 1                    , ;
       PRIKUHHDw ->dPORIZPRI  := Date()               , ;
       PRIKUHHDw ->dPRIKUHR   := Date()                 )

       PRIKUHHDw ->czkratMenU := c_bankUc->czkratMeny

       if .not. Equal( zaklMena, c_bankUc->czkratMenY )
         zkrMeny := upper( c_bankUc->czkratMenY)

         kurzit->(AdsSetOrder(2), dbsetscope(SCOPE_BOTH,zkrMeny))
         cky := zkrMeny +dtos(PRIKUHHDw->dporizPri)

         kurzit->(dbseek(cky,.t.))
         if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)
         PRIKUHHDw ->czkratMenZ := zkrMeny
         PRIKUHHDw ->nmnozPrep  := kurzit->nmnozprep
         PRIKUHHDw ->nkurZahMen := kurzit->nkurzstred
       endif

    fakPrihd->( dbseek( 0,, AdsCTag(1) ))
*    fOrdRec()
  ENDIF
RETURN(Nil)

*
** pøevzetí vybraných položek do pøíkazu k úhradì v cyklu **********************
FUNCTION FIN_prikuhhd_ins()
  LOCAL  cKy := Upper( FAKPRIHD ->cDENIK) +StrZero( FAKPRIHD ->nCISFAK,10)
  LOCAL  isPrikaz, ZBY_uhradit := FIN_prikuhit_fp_ZBY()

  Set( _SET_DELETED, .F. )
  isPRIKAZ := PRIKUHITw ->(DbSeek(cKy,,'PRIKUHIT_2'))
  Set( _SET_DELETED, .T.)

  IF .not. isPrikaz
    mh_COPYFLD('FAKPRIHD', 'PRIKUHITw', .t., .f.)
    PRIKUHITw ->nDOKLAD    := 0
    PRIKUHITw ->nPRIUHRCEL := ZBY_uhradit
    PRIKUHITw ->dPORIZPRI  := Date()
    PRIKUHITw ->dUHRBANDNE := PRIKUHHDw ->dPRIKUHR
    PRIKUHITw ->nCISFAK_OR := FAKPRIHD  ->( RecNo())
    PRIKUHHDw ->nCENZAKCEL += ZBY_uhradit
  ELSE
    IF(PRIKUHITw ->(Deleted()), PRIKUHITw ->(DbRecall()), NIL)
  ENDIF
RETURN(Nil)


function FIN_prikuhhd_wrt(odialog)
  local  anDoi := {}, anFap := {}, maiOk := .f., nrecor
  local  npos, ckodban_cr
  local  in_file := if( upper(prikuhhdw->csubTask) = 'MZD', 'mzdzavhd', 'fakprihd' )
  local  ctext

  drgDBMS:open('banky_cr')

  prikuhitw->(AdsSetOrder(0), ;
              dbgotop()     , ;
              dbeval( {|| (if(prikuhitw->_nrecor   <>0, aadd(anDoi,prikuhitw->_nrecor   ), nil), ;
                           if(prikuhitw->ncisfak_or<>0, aadd(anFap,prikuhitw->ncisfak_or), nil)  ) }))

  if odialog:lnewRec
    prik_Uhhd->(ordSetFocus('FDODHD1'), dbgoBottom())
    prikUhHDw->nDoklad := prik_Uhhd->nDoklad +1
    prikuhhd->(dbappend())
  endif

  mainOk := prikuhhd ->(sx_rlock())      .and. ;
            prikuhit ->(sx_rlock(anDoi)) .and. ;
            (in_file)->(sx_rlock(anFap))

  if mainOk
    mh_copyfld('prikuhhdw','prikuhhd',,.f.)
    prikuhitw->(dbgotop())

    if(npos := rat('/', prikuhhd->cbank_uct)) <> 0
                 ckodban_cr := alltrim( substr( prikuhhd ->cbank_uct, npos +1))
      prikuhhd ->ckodban_cr := padr( ckodban_cr, 4)
    endif

    do while .not. prikuhitw->(eof())
      if((nrecor := prikuhitw->_nrecor) = 0, nil, prikuhit->(dbgoto(nrecor)))
      if  prikuhitw->_delrec = '9'
        if( nrecor = 0, nil, prikuhit->(dbdelete()))
      else
        mh_copyfld('prikuhitw','prikuhit',(nrecor=0),,.f.)
        prikuhit->ndoklad   := prikuhhd->ndoklad
// NE        prikuhit->cbank_uct := prikuhhd->cbank_uct
      endif

      if prikuhitw->ncisfak_or <> 0
        (in_file)->(dbgoto(prikuhitw->ncisfak_or))
        if prikuhitw->_delrec = '9'
          (in_file)->npriuhrcel -= prikuhitw->npriuhrcel
        else
          (in_file)->npriuhrcel += (prikuhitw->npriuhrcel -prikuhitw->npriuhr_or)
        endif

        *
        ** je potøeba uložit zmìnu bankovního úètu - tvrdí, že se jim mìní sám
        if  (in_file)->cucet <> prikuhit->cucet
          ctext   := 'old_cucet = ' +(in_file)->cucet +' -> new_cucet = ' +prikuhit->cucet
          mh_wrtZmena( in_file,,, ctext )
        endif

        (in_file)->ddatpriuhr := if( (in_file)->npriuhrcel = 0, ctod('  .  .  '), prikuhit->dporizpri)
        (in_file)->cucet      := prikuhit->cucet
        (in_file)->nexiPriUhr := if( (in_file)->npriuhrcel = 0, 0, 1 )
      endif

      prikuhitw->(dbskip())
    enddo

    if( mainOk .and. prikuhhdw->_delrec = '9')
      prikuhhd->(dbgoto(prikuhhdw->_nrecor),dbdelete())
    endif
  else
    drgMsg(drgNLS:msg('Nelze modifikovat PØÍKAZ k ÚHRADADÌ, blokováno uživatelem ...'),,oDialog)
  endif

  prikuhhd->(dbunlock(), dbcommit())
   prikuhit->(dbunlock(), dbcommit())
    (in_file)->(dbunlock(), dbcommit())
return mainOk


*
** zrušení pøíkazu k úhradì
function fin_prikuhhd_del(odialog)
  local  mainOk

  prikuhhdw->_delrec := '9'
  prikuhitw->(AdsSetOrder(0),dbgotop(),dbeval({|| prikuhitw->_delrec := '9'}))
  mainOk := fin_prikuhhd_wrt(odialog)
return mainOk