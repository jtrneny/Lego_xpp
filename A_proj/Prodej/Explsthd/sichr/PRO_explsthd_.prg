#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



function pro_explsthd_cpy(oDialog)
  local  nKy := explsthd->ndoklad
  *
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)

  ** tmp **
  drgDBMS:open('explsthdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('explstitw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  if .not. lNEWrec
    mh_copyfld('explsthd', 'explsthdw', .t., .t.)

    explstit->(dbgotop(), dbeval({|| mh_copyfld('explstit','explstitw', .t., .t.)}))
  else
    explsthdw->(dbappend())
    if( .not. c_bankuc->(dbseek(.t.,,'bankuc2')), c_bankuc->(dbgotop()),nil)

    ( explsthdw ->cULOHA     := "E"                                     , ;
      explsthdw ->cOBDOBI    := uctOBDOBI:SKL:COBDOBI                   , ;
      explsthdw ->nROK       := uctOBDOBI:SKL:NROK                      , ;
      explsthdw ->nOBDOBI    := uctOBDOBI:SKL:NOBDOBI                   , ;
      explsthdw ->cOBDOBIDAN := uctOBDOBI:SKL:COBDOBIDAN                , ;
      explsthdw ->nKODZAOKRD := SYSCONFIG('FINANCE:nROUNDDPH')          , ;
      explsthdw ->cZKRATMENY := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
      explsthdw ->dSPLATFAK  := DATE() +SYSCONFIG( 'FINANCE:nSPLATNOST'), ;
      explsthdw ->dVYSTFAK   := DATE()                                  , ;
      explsthdw ->ccasNaklad := '00000000'                              , ;
      explsthdw ->dPOVINFAK  := DATE()                                  , ;
      explsthdw ->cBANK_UCT  := C_BANKUC ->cBANK_UCT                    , ;
      explsthdw ->cDENIK     := SYSCONFIG('FINANCE:cDENIKFAVY')         , ;
      explsthdw ->nKURZAHMEN := 1                                       , ;
      explsthdw ->nMNOZPREP  := 1                                       , ;
      explsthdw ->cJMENOVYS  := usrName                                 , ;
      explsthdw ->ndoklad    := fin_range_key('EXPLSTHD')[2]            , ;
      explsthdw ->cZKRATMENZ := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
      explsthdw ->cVYPSAZDAN := SYSCONFIG('FINANCE:cVYPSAZDPH')           )
  endif
return nil


function pro_explsthd_wrt(odialog)
  local  mainOk := .t., nrecor, ky
  local  anExi := {}, anCen := {}, anDoi := {}, anObi := {}, anVyi := {}

  explstitw->(AdsSetOrder(0),dbgotop())

  do while .not. explstitw->(eof())
    pro_explsthd_rlo(anExi,anVyi)
    explstitw->(dbskip())
  enddo

  mainOk := vyrzakit->(sx_rlock(anVyi))

  if .not. odialog:lnewRec
    explsthd->(dbgoto(explsthdw->_nrecor))
    mainOk := mainOk                      .and. ;
              explsthd->(sx_rlock())      .and. ;
              explstit->(sx_rlock(anExi))
  endif

  if mainOk
    if(explsthdw->_delrec <> '9', mh_copyfld('explsthdw','explsthd',odialog:lnewRec, .f.), nil)
    explstitw->(dbgotop())

    do while .not. explstitw->(eof())

      if((nrecor := explstitw->_nrecor) = 0, nil, explstit->(dbgoto(nrecor)))
      if   explstitw->_delrec = '9'
        if( nrecor = 0, nil, explstit->(dbdelete()))
      else
        mh_copyfld('explstitw','explstit',(nrecor=0), .f.)
      endif

      pro_explsthd_mod(explstitw->_delrec = '9')
      explstitw->(dbskip())
    enddo

    if(explsthdw->_delrec = '9')   ;  explsthd->(dbdelete())
    else
    endif
  else
    drgMsg(drgNLS:msg('Nelze modifikovat EXPEDIÈNÍ LIST, blokováno uživatelem ...'),,odialog:drgDialog)
  endif

  explsthd->(dbunlock(),dbcommit())
   explstit->(dbunlock(),dbcommit())
    vyrzakit->(dbunlock(),dbcommit())
return mainOk


*
** zrušení expedièního listu **
function pro_explsthd_del(odialog)
  local  mainOk

  explsthdw->_delrec := '9'
  explstitw->(AdsSetOrder(0),dbgotop(),dbeval({|| explstitw->_delrec := '9'}))
  mainOk := pro_explsthd_wrt(odialog)
return mainOk


static function pro_explsthd_rlo(anExi,anVyi)
  local  ciszakazI  := explstitw->cciszakazI

  aadd(anExi,explstitw->_nrecor)

  if .not. empty(ciszakazI)
    vyrzakit->(dbseek(upper(ciszakazI),,'ZAKIT_4'))
    explstitw->nrecs_iv := vyrzakit->(recno())
    aadd(anVyi,vyrzakit->(recno()))
  endif
return nil


static function pro_explsthd_mod(isDel)
  local  ciszakazI  := explstitw->cciszakazI

  if .not. empty(ciszakazI)
    vyrzakit->(dbgoTo(explstitw->nrecs_iv))
    vyrzakit->ncisloEL := if(isDel, 0, explsthdw->ndoklad)
  endif
return nil
