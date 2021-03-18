#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"


function uct_uctdokhd_cpy(oDialog)
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec), typ_zz, cf
  *
  local  cky := upper(uctdokhd->cdenik) +strZero(uctdokhd->ndoklad,10)

  ** tmp soubory **
  drgDBMS:open('UCTDOKHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('UCTDOKITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  If .not. lNEWrec
    mh_COPYFLD('UCTDOKHD','UCTDOKHDw', .t., .t.)

    IF UCETSYS ->( DBSeek( 'F' +UCTDOKHD ->cOBDOBI,,  AdsCtag(2) ))
      UCTDOKHDw ->nROK    := UCETSYS ->nROK
      UCTDOKHDw ->nOBDOBI := UCETSYS ->nOBDOBI
    ENDIF

    UCTDOKIT ->(ordsetfocus( AdsCtag( 1 )),dbsetscope(SCOPE_BOTH,cky),dbgotop())

    DO WHILE !UCTDOKIT ->( Eof())
      mh_COPYFLD('UCTDOKIT', 'UCTDOKITw', .t., .t.)
      UCTDOKITw ->cOBDOBI    := UCTDOKHDw ->cOBDOBI
      UCTDOKITw ->nROK       := UCTDOKHDw ->nROK
      UCTDOKITw ->nOBDOBI    := UCTDOKHDw ->nOBDOBI
      UCTDOKITw ->cOBDOBIDAN := UCTDOKHDw ->cOBDOBIDAN
      UCTDOKITw ->nDOKLADORG := UCTDOKIT ->( RecNo())

      UCTDOKIT ->(DbSkip())
    ENDDO
  else

    UCTDOKHDw ->( DbAppend())

    if isobject(oDialog)                          .and. ;
       oDialog:drgDialog:cargo = drgEVENT_APPEND2 .and. ;
       .not. uctDokhd->(eof())

      oDialog:lok_append2 := lok_append2 := .t.
      mh_copyFld('uctDokHd','uctDokHdW', .f., .f.)

      ( uctdokhdw ->cULOHA     := "U"                            , ;
        uctdokhdw ->dPORIZDOK  := Date()                         , ;
        uctdokhdw ->cOBDOBI    := uctOBDOBI:UCT:COBDOBI          , ;
        uctdokhdw ->nROK       := uctOBDOBI:UCT:NROK             , ;
        uctdokhdw ->nOBDOBI    := uctOBDOBI:UCT:NOBDOBI          , ;
        uctdokhdw ->cOBDOBIDAN := uctOBDOBI:UCT:COBDOBIDAN       , ;
        uctdokhdw ->cZKRATMENY := SysConfig( 'Finance:cZaklMena'), ;
        uctdokhdw ->nDOKLAD    := FIN_range_key('UCTDOKHD')[2]   , ;
        uctdokhdw ->cDENIK     := SysConfig( 'UCTO:cDENIKucdo')    )


      uctDokit ->(ordSetFocus( AdsCtag( 1 )),dbSetScope(SCOPE_BOTH,cky),dbgotop())
      do while .not. uctDokit ->( Eof())
        mh_copyFld('uctDokit', 'uctDokitw', .t., .f.)
        uctDokitw ->cOBDOBI    := uctDokHdW ->cOBDOBI
        uctDokitw ->nROK       := uctDokHdW ->nROK
        uctDokitw ->nOBDOBI    := uctDokHdW ->nOBDOBI
        uctDokitw ->cOBDOBIDAN := uctDokHdW ->cOBDOBIDAN
        uctDokitw ->nDOKLADORG := 0

        uctDokit ->(DbSkip())
      endDo


    else
      uctdokhdw ->cULOHA     := "U"
      uctdokhdw ->dPORIZDOK  := Date()
      uctdokhdw ->cOBDOBI    := uctOBDOBI:UCT:COBDOBI
      uctdokhdw ->nROK       := uctOBDOBI:UCT:NROK
      uctdokhdw ->nOBDOBI    := uctOBDOBI:UCT:NOBDOBI
      uctdokhdw ->cOBDOBIDAN := uctOBDOBI:UCT:COBDOBIDAN
      uctdokhdw ->cZKRATMENY := SysConfig( 'Finance:cZaklMena')
      uctdokhdw ->nDOKLAD    := FIN_range_key('UCTDOKHD')[2]
      uctdokhdw ->cDENIK     := SysConfig( 'UCTO:cDENIKucdo')
      uctdokhdw ->cTYPOBRATU := 'MD'
      uctdokhdw ->nTYPOBRATU := 1
    endif
  endIf
return nil


*
** uložení úèetního dokladu **
function UCT_uctdokhd_wrt(oDialog)
  local  anDoi   := {}, lDoi := .t., mainOk := .t., nrecor
  local  uctLikv

  * pøedkonatce
  uctdokitw->(flock())
  uctdokitW->(dbEval( {|| uctdokitW->ddatPoriz := uctdokhdW->dporizDok }), dbGoTop())
  uctdokhdw->(dbcommit())
  uctLikv := UCT_likvidace():new(upper(uctdokhdw->culoha) +upper(uctdokhdw->ctypdoklad),.T.)

  uctdokitw->(ordsetfocus(0)    , ;
              dbgotop()         , ;
              dbeval({|| if(uctdokitw->_nrecor <> 0, aadd(anDoi,uctdokitw->_nrecor), nil) }))

  if .not. odialog:lnewRec
    uctdokhd->(dbgoto(uctdokhdw->_nrecor))
    mainOk := uctdokhd->(sx_rlock())                    .and. ;
              uctdokit->(sx_rlock(anDoi))               .and. ;
              ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo))
  endif

  if mainOk
    mh_copyfld('uctdokhdw','uctdokhd',odialog:lnewRec, .f.)
    uctdokitw->(dbgotop())

    do while .not. uctdokitw->(eof())
      uctdokitW->ddatPoriz  := uctdokhdW->dporizDok
      uctdokitW->cobdobi    := uctdokhdW->cobdobi
      uctdokitW->nrok       := uctdokhdW->nrok
      uctdokitW->nobdobi    := uctdokhdW->nobdobi
      uctdokitW->cobdobiDan := uctdokhdW->cobdobiDan

      if((nrecor := uctdokitw->_nrecor) = 0, nil, uctdokit->(dbgoto(nrecor)))
      if   uctdokitw->_delrec = '9'
        if( nrecor = 0, nil, uctdokit->(dbdelete()))
      else
        mh_copyfld('uctdokitw','uctdokit',(nrecor=0), .f.)
        uctdokit->ndoklad := uctdokhd->ndoklad
      endif

      uctdokitw->(dbskip())
    enddo

    uctLikv:ucetpol_wrt()
  else
    drgMsg(drgNLS:msg('Nelze modifikovat ÚÈETNÍ DOKLAD, blokováno uživatelem ...'),,::drgDialog)
  endif

  uctdokhd->(dbunlock(), dbcommit())
   uctdokit->(dbunlock(), dbcommit())
    ucetpol ->(dbunlock(), dbcommit())
return mainOk


*
**
function uct_uctdokhd_typ(drgComboBox)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin, pa

  nin := ascan(values,{|x| x[1] = value })
   pa := listasarray(values[nin,4])

  uctdokhdw->ctypdoklad := values[nin,3]
  uctdokhdw->ctyppohybu := values[nin,1]
  uctdokhdw->ntypobratu := val(pa[2])
  uctdokhdw->ctypobratu := pa[1]
  uctdokhdw->(dbcommit())
return nil


*
** zrušení úèetního dokladu **
function uct_uctdokhd_del()
  local  anDoi   := {}, lDoi := .t., mainOk := .t., nrecor
  local  uctLikv

  * pøedkonatce
  uctLikv := UCT_likvidace():new(upper(uctdokhdw->culoha) +upper(uctdokhdw->ctypdoklad),.T.)

  uctdokitw->(ordsetfocus(0)    , ;
              dbgotop()         , ;
              dbeval({|| if(uctdokitw->_nrecor <> 0, aadd(anDoi,uctdokitw->_nrecor), nil) }))

  uctdokhd->(dbgoto(uctdokhdw->_nrecor))
  mainOk := uctdokhd->(sx_rlock())                    .and. ;
            uctdokit->(sx_rlock(anDoi))               .and. ;
            ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo))

  if mainOk
    uctdokitw->(dbgotop())

    do while .not. uctdokitw->(eof())
      nrecor := uctdokitw->_nrecor
      uctdokit->(dbgoto(nrecor),dbdelete())

      uctdokitw->(dbskip())
    enddo

    uctLikv:ucetpol_del()
    uctdokhd->(dbdelete())
  endif

  uctdokhd->(dbunlock(), dbcommit())
   uctdokit->(dbunlock(), dbcommit())
    ucetpol ->(dbunlock(), dbcommit())
return mainOk