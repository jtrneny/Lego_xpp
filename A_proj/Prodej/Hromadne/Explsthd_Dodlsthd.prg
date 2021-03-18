#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


static anExpI, anDodH, anDodI


CLASS explst_dodlst
EXPORTED:
  method processed

  inline method init
    if( select('dodlsthdw') <> 0, dodlsthdw->(dbcloseArea()), nil)
    if( select('dodlstitw') <> 0, dodlstitw->(dbcloseArea()), nil)
    *
    drgDBMS:open('dodlsthdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('dodlstitw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    anExpi := {}
    anDodh := {}
    anDodi := {}
  return self

HIDDEN:
  var     anExpI, anDodH, anDodI
  method  locks, dodlst_hdw, dodlst_itw
ENDCLASS


method explst_dodlst:processed()
  local mainOk := ::locks(), doklad := 1, intCount := 1

  if mainOk
    explstit->(dbgoTop())

    do while .not. explstit->(eof())
      vyrzakit->(dbseek(upper(explstit->ccisZakazI),,'ZAKIT_4'))

      if .not. dodlsthdw->(dbSeek(explstit->ncisFirmy,,'DODLSHD_1'))
        intCount := 1
        ::dodlst_hdw()

        dodlsthdw->ndoklad := doklad
        doklad++
      endif

      ::dodlst_itw()
      dodlstitw->ndoklad   := dodlsthdw->ndoklad
      dodlstitw->nintCount := intCount
      intCount++
      explstit->(dbSkip())
    enddo
  endif
  **
  *
  dodlsthdW->(dbcommit())
  dodlstitW->(dbcommit())
  *
  **
  dodlsthdw->(dbgoTop())
  do while .not. dodlsthdw->(eof())
    doklad := fin_range_key('DODLSTHD')[2]

    dodlstitw->(AdsSetOrder('DODLSIT_3')                 , ;
                dbsetscope(SCOPE_BOTH,dodlsthdw->ndoklad), ;
                dbgotop()                                , ;
                pro_ap_modihd('DODLSTHDW')                 )

    mh_copyFld('dodlsthdw','dodlsthd',.t., .f.)
    dodlsthd->ndoklad := doklad
    dodlsthd->(dbcommit())

    do while .not. dodlstitw->(eof())
      mh_copyFld('dodlstitw','dodlstit',.t., .f.)
      dodlstit->ndoklad := doklad

      dodlstitw->(dbSkip())
    enddo

    dodlsthdw->(dbskip())
  enddo

  explsthd->(dbunlock(), dbcommit())
   explstit->(dbunlock(), dbcommit())
    dodlsthd->(dbunlock(), dbcommit())
     dodlstit->(dbunlock(), dbcommit())
      dodlsthdw->(dbcloseArea())
       dodlstitw->(dbcloseArea())
return .t.


method explst_dodlst:locks()
  local  ky, ok

  explstit->(dbgotop())
  do while .not. explstit->(eof())
    aadd(anExpI, explstit->(recNo()))

    if dodlsthd->(dbseek(explstit->ncisloDL,,'DODLHD1'))
      aadd(anDodH,dodlsthd->(recno()))

      ky := strzero(dodlsthd->ndoklad,10)
      dodlstit->(AdsSetOrder('DODLIT5')                        , ;
                 dbsetscope(SCOPE_BOTH,ky)                     , ;
                 dbgotop()                                     , ;
                 dbeval({|| aadd(anDodI,dodlstit->(recNo())) }), ;
                 dbclearScope()                                  )
    endif

    explstit->(dbskip())
  enddo

  ok := ( explsthd->(sx_rlock())       .and. ;
          explstit->(sx_rlock(anExpI)) .and. ;
          dodlsthd->(sx_rlock(anDodH)) .and. ;
          dodlstit->(sx_rlock(anDodI))       )
return ok


method explst_dodlst:dodlst_hdw()

  firmy->( dbSeek(vyrzakit->ncisFirmy,,'FIRMY1'))

  mh_copyFld('explsthd','dodlsthdw',.t., .f.)

  dodlsthdw ->nROK       := uctOBDOBI:SKL:NROK
  dodlsthdw ->nOBDOBI    := uctOBDOBI:SKL:NOBDOBI
  dodlsthdw ->cOBDOBI    := uctOBDOBI:SKL:COBDOBI
//    dodlsthdw ->cOBDOBIDAN := uctOBDOBI:SKL:COBDOBIDAN

  dodlsthdw->ctypDoklad := 'PRO_DLSKL'
  dodlsthdw->ctypPohybu := 'DLSKLVYDEJ'
  dodlsthdw->czkrTypFak := 'DODLS'
  dodlsthdw->nprocDan_1 := seekSazDPH(1)
  dodlsthdw->nprocDan_2 := SeekSazDPH(2)
  dodlsthdw->ncisFirmy  := vyrzakit->ncisFirmy
  dodlsthdw->cnazev     := vyrzakit->cnazFirmy
  dodlsthdw->czkratStat := firmy   ->czkratStat
  dodlsthdw->cnazev2    := ''
  dodlsthdw->nico       := vyrzakit->nico
  dodlsthdw->cdic       := vyrzakit->cdic
  dodlsthdw->culice     := vyrzakit->culice
  dodlsthdw->csidlo     := vyrzakit->csidlo
  dodlsthdw->cpsc       := vyrzakit->cpsc
  dodlsthdw->ncisFirDOA := vyrzakit->ncisFirDOA
  dodlsthdw->cnazevDOA  := vyrzakit->cnazevDOA
  dodlsthdw->culiceDOA  := vyrzakit->culiceDOA
  dodlsthdw->csidloDOA  := vyrzakit->csidloDOA
  dodlsthdw->cpscDOA    := vyrzakit->cpscDOA
  dodlsthdw->ncisloEL   := explsthd->ndoklad
return .t.


method  explst_dodlst:dodlst_itw()
  local nfaktmnoz, nprocdph  , ncejprzbz, nhodnslev, nprocslev, ;
        ncejprkbz, ncejprkdz , ncecprzbz, ;
        ncelkslev, ncecprkbz , ncecprkdz, ;
        njeddan  , nvypsazdan

  mh_copyFld('explstit','dodlstitw',.t., .f.)

  drgDBms:open('vyrpol')  ;  vyrpol->(dbseek(vyrzakit->(sx_keydata()),,'VYRPOL1'))
  drgDBms:open('c_dph')   ;  c_dph->(dbseek(vyrzakit->nklicDph,,'C_DPH1'))

  dodlstitw->czkrTypFak := 'DODLS'
  dodlstitw->nrok       := dodlsthdw->nrok
  dodlstitw->nobdobi    := dodlsthdw->nobdobi
  dodlstitw->cobdobi    := dodlsthdw->cobdobi
  dodlstitw->cnazZbo    := vyrzakit->cnazevZak1
  dodlstitw->nfaktmnoz  := vyrzakit->nmnozplano
  dodlstitw->czkratjedn := vyrzakit->czkratjedn
  *
  dodlstitw->ncejPrZBZ  := vyrzakit->ncenaMJ
  dodlstitw->ncenaZAKL  := vyrzakit->ncenaMJ
  dodlstitw->ncejPrKBZ  := vyrzakit->ncenaMJ
  *
  dodlstitw->nprocDPH   := c_dph   ->nprocDPH
  dodlstitw->cucet      := vyrzakit->cucetTrzeb
  dodlstitw->ncisloEL   := explsthd->ndoklad
  dodlstitw->npolEL     := explstit->nintCount
  *
  ** výpoèet položky
  nfaktmnoz  := dodlstitw->nFAKTMNOZ
  nprocdph   := dodlstitw->nPROCDPH
  * 1
  ncejprzbz  := dodlstitw->nCEJPRZBZ
  nhodnslev  := dodlstitw->nHODNSLEV
  nprocslev  := dodlstitw->nPROCSLEV
  ncejprkbz  := dodlstitw->nCEJPRKBZ
  ncejprkdz  := dodlstitw->nCEJPRKDZ
  * 2
  ncecprzbz  := dodlstitw->nCECPRZBZ
  ncelkslev  := dodlstitw->nCELKSLEV
  ncecprkbz  := dodlstitw->nCECPRKBZ
  ncecprkdz  := dodlstitw->nCECPRKDZ
  *
  njeddan    := dodlstitw->njeddan
  nvypsazdan := dodlstitw->nvypsazdan

  * 1
  if nvypsazdan = 0
    dodlstitw->ncejprkdz := ncejprkbz + (ncejprkbz * nprocdph/100)
  else
    dodlstitw->ncejprkdz := (ncejprkbz + njeddan)
  endif

  * 2
  dodlstitw->ncecprzbz := (ncejprkbz * nfaktmnoz)
  dodlstitw->ncelkslev := (nhodnslev * nfaktmnoz)
  dodlstitw->ncecprkbz := (ncejprkbz * nfaktmnoz)
  dodlstitw->ncecprkdz := (dodlstitw->ncejprkdz * nfaktmnoz)
return .t.