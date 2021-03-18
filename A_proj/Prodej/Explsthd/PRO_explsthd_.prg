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

    explstit->(dbgotop())
    do while .not. explstit->(eof())
      mh_copyFld('explstit','explstitW',.t.,.t.)
      *
      explstitW->nfaktm_org := explstit->nfaktMnoz
      explstit->(dbSkip())
    enddo
    explstit->(dbgotop())

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


function pro_explsthd_wrt( odialog )
  local  mainOk := .t., lnewrec := odialog:lnewrec, nrecor, ky
  local  anExi := {}, anCen := {}, anDoi := {}, anObj := {}, anVyr := {}
  *
  local  ndoklad

  explstitw->(AdsSetOrder(0), ;
              dbgotop()     , ;
              dbeval({|| pro_explsthd_rlo( anExi, anDoi, anObj, anVyr ) }))

  if .not. lnewrec
    explsthd->(dbgoto(explsthdw->_nrecor))
    mainOk := (explsthd->(sx_rlock())      .and.  ;
               explstit->(sx_rlock(anExi)) .and.  ;
               dodlstit->(sx_rlock(anDoi)) .and.  ;
               objitem ->(sx_rlock(anObj)) .and.  ;
               vyrzakit->(sx_rlock(anVyr))        )
  else
    mainOk := (dodlstit->(sx_rlock(anDoi)) .and.  ;
               objitem ->(sx_rlock(anObj)) .and.  ;
               vyrzakit->(sx_rlock(anVyr))        )
  endif


  if mainOk
    *
    ** zkotrolujeme možnou duplicitu dokladu
    if lnewRec
      fOrdRec( {'explsthd'} )
      if explsthd->(dbseek( explsthdw->ndoklad,, 'EXPLSTHD01' ))
        explsthdw->ndoklad := fin_range_key('EXPLSTHD')[2]
      endif
      fOrdRec()
    endif

    if(explsthdw->_delrec <> '9', mh_copyfld('explsthdw','explsthd',lnewRec, .f.), nil)
    explstitw->(dbgotop())

    do while .not. explstitw->(eof())
      if((nrecor := explstitw->_nrecor) = 0, nil, explstit->(dbgoto(nrecor)))

      if   explstitw->_delrec = '9'
        if( nrecor = 0, nil, explstit->(dbdelete()))
      else
        mh_copyfld('explstitw','explstit',(nrecor=0), .f.)
        if( lnewRec, explstit->ndoklad := explsthd->ndoklad, nil )
      endif

      if( .not. empty(explstitw->ncislodl   ), pro_explsthd_dol(), ;
        if( .not. empty(explstitw->ccislobint), pro_explsthd_obj(), ;
         if( .not. empty(explstitw->cciszakazi), pro_explsthd_vyr(), nil )))

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
     dodlstit->(dbunlock(), dbcommit())
      objitem ->(dbunlock(), dbcommit())
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


static function pro_explsthd_rlo(anExi, anDoi, anObj, anVyr)
  local  cislodl   := explstitw->ncislodl  , ncountdl := explstitw->ncountdl
  local  cislObint := explstitw->ccislObint, npolobj  := explstitw->ncislPolob
  local  cisZakazI := explstitw->cciszakazI

  aadd(anExi,explstitw->_nrecor)

  if     .not. empty(cislodl)
    if(dodlstit->(dbseek(strzero(cislodl,10) +strzero(ncountdl,5),,'DODLIT5')), ;
      (explstitw->nrecs_iv := dodlstit->(recno()), aadd(anDoi, dodlstit->(recno()))), nil)

  elseif .not. empty(cislObint)
    if(objitem ->(dbseek(upper(cislObint) +strZero(npolobj,5),,'OBJITEM2')), ;
      (explstitw->nrecs_iv := objitem ->(recNo()), aadd(anObj, objitem ->(recNo()))), nil )

  elseif .not. empty(cisZakazI)
    if(vyrzakit->(dbseek(cisZakazI   ,,'ZAKIT_4')), ;
      (explstitw->nrecs_iv := vyrzakit->(recno()), aadd(anVyr, vyrzakit->(recno()))), nil)

  endif
return nil

*
** položka z dodlstit
static function pro_explsthd_dol()
  dodlstit->(dbgoto(expltitw->nrecs_iv))

  if explstitw->_delrec = '9'
    dodlstit->nmnoz_exlv -= explstitw->nfaktm_org
  else
    dodlstit->nmnoz_exlv += (explstitw->nfaktmnoz -explstitw->nfaktm_org)
  endif

  dodlstit->nstav_exlv := if(dodlstit->nmnoz_exlv = 0                  , 0, ;
                          if(dodlstit->nmnoz_exlv = dodlstit->nfaktMnoz, 2, 1))
return nil

*
** položka z objitem
static function pro_explsthd_obj()
  objitem ->(dbgoto(explstitw->nrecs_iv))

  if explstitw->_delrec = '9'
    objitem->nmnoz_exlv -= fakvysitw->nfaktm_org
  else
    objitem->nmnoz_exlv += (explstitw->nfaktmnoz -explstitw->nfaktm_org)
  endif

  objitem->nstav_exlv := if(objitem->nmnoz_exlv = 0                  , 0, ;
                         if(objitem->nmnoz_exlv = objitem->nmnozObOdb, 2, 1))

return nil

*
** položka z vyrzak
static function pro_explsthd_vyr()
  vyrzakit->(dbgoto(explstitw->nrecs_iv))

  if explstitw->_delrec = '9'
    vyrzakit->nmnoz_exlv -= explstitw->nfaktm_org
    vyrzakit->ncisloel   := 0
  else
    vyrzakit->nmnoz_exlv += (explstitw->nfaktmnoz -explstitw->nfaktm_org)
    vyrzakit->ncisloel   := explsthdw->ndoklad
  endif

  vyrzakit->nstav_exlv := if(vyrzakit->nmnoz_exlv = 0                   , 0, ;
                          if(vyrzakit->nmnoz_exlv = vyrzakit->nmnozPlano, 2, 1))
  vyrzakit->ddat_exlv  := if(vyrzakit->nstav_exlv = 0                      , ;
                             ctod( '  .  .  '), explsthdw->dvystFak           )
  *
  if vyrzak->( dbseek( upper(vyrzakit->ccisZakaz),, 'VYRZAK1' ))
    if( vyrzak->( dbRlock()), vyrzak->ddat_exlv := explsthdw->dvystFak, nil )
    vyrzak->( dbUnlock(), dbcommit())
  endif
return nil

