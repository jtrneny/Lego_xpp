**
**  Remarks
**  BanVyp_MAP() ->  FIN_poklad_map()
**  BanVyp_DoV() ->  FIN_poklad_dov()
**


#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"


FUNCTION FIN_ucetdohd_cpy(oDialog)
  local  lNEWrec     := If( IsNull(oDialog), .F., oDialog:lNEWrec), typ_zz, cf
  local  lok_append2 := .f.
  *
  local  cky := Upper(UCETDOHD ->cDENIK) +StrZero(UCETDOHD ->nDOKLAD,10)

  ** tmp soubory **
  drgDBMS:open('UCETDOHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('UCETDOITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  If .not. lNEWrec
    mh_COPYFLD( 'UCETDOHD', 'UCETDOHDw', .t., .t.)

    IF UCETSYS ->( DBSeek( 'F' +UCETDOHD ->cOBDOBI,, 'UCETSYS2'))
      UCETDOHDw ->nROK    := UCETSYS ->nROK
      UCETDOHDw ->nOBDOBI := UCETSYS ->nOBDOBI
    ENDIF

    UCETDOIT ->(AdsSetOrder(1),dbsetscope(SCOPE_BOTH,cky),dbgotop())

    DO WHILE !UCETDOIT ->( Eof())
      mh_COPYFLD('UCETDOIT', 'UCETDOITw', .t., .t.)
      UCETDOITw ->cOBDOBI    := UCETDOHDw ->cOBDOBI
      UCETDOITw ->nROK       := UCETDOHDw ->nROK
      UCETDOITw ->nOBDOBI    := UCETDOHDw ->nOBDOBI
      UCETDOITw ->cOBDOBIDAN := UCETDOHDw ->cOBDOBIDAN
      UCETDOITw ->nDOKLADORG := UCETDOIT ->( RecNo())

      UCETDOIT ->(DbSkip())
    ENDDO
  ELSE
    UCETDOHDw ->( DbAppend())

    IF IsMemberVar( oDialog, 'typ_zz')
      cf := IF( oDialog:typ_zz = 'zav', 'fakprihd', 'fakvyshd')
    ENDIF

    if isobject(oDialog)                          .and. ;
       oDialog:drgDialog:cargo = drgEVENT_APPEND2 .and. ;
       .not. ucetDohd->(eof())                    .and. ;
       empty( cf )

       oDialog:lok_append2 := lok_append2 := .t.
       mh_copyFld( 'ucetDohd', 'ucetDohdW', .f., .f. )

       ( UCETDOHDw ->cULOHA     := "F"                            , ;
         UCETDOHDw ->dPORIZDOK  := Date()                         , ;
         UCETDOHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI          , ;
         UCETDOHDw ->nROK       := uctOBDOBI:FIN:NROK             , ;
         UCETDOHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI          , ;
         UCETDOHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN       , ;
         UCETDOHDw ->cZKRATMENY := SysConfig( 'Finance:cZaklMena'), ;
         UCETDOHDw ->cUCTDPH_1  := SysConfig( 'Ucto:cUCETDPH1')   , ;
         UCETDOHDw ->cUCTDPH_2  := SysConfig( 'Ucto:cUCETDPH2')   , ;
         UCETDOHDw ->dVYSTDOK   := Date()                         , ;
         UCETDOHDw ->nPROCDAN_1 := SeekSazDPH(1)                  , ;
         UCETDOHDw ->nPROCDAN_2 := SeekSazDPH(2)                  , ;
         UCETDOHDw ->nDOKLAD    := FIN_range_key('UCETDOHD:vd')[2]  )

       if UCETSYS ->( DBSeek( 'F' +UCETDOHD ->cOBDOBI,, 'UCETSYS2'))
         UCETDOHDw ->nROK    := UCETSYS ->nROK
         UCETDOHDw ->nOBDOBI := UCETSYS ->nOBDOBI
       endif
       *
       ** musí se zanulovat
       ucetDohdW ->ddatTisk   := ctod('  .  .  ')

       ucetDoit ->( AdsSetOrder(1),dbsetscope(SCOPE_BOTH,cky),dbgotop())
       do while .not. ucetDoit->( Eof())
         mh_COPYFLD('UCETDOIT', 'UCETDOITw', .t., .f.)
         ucetDoitW ->cOBDOBI    := UCETDOHDw ->cOBDOBI
         ucetDoitW ->nROK       := UCETDOHDw ->nROK
         ucetDoitW ->nOBDOBI    := UCETDOHDw ->nOBDOBI
         ucetDoitW ->cOBDOBIDAN := UCETDOHDw ->cOBDOBIDAN
         ucetDoitW ->nDOKLADORG := 0

         ucetDoit ->(DbSkip())
      endDo

    else

      UCETDOHDw ->cULOHA     := "F"
      UCETDOHDw ->dPORIZDOK  := Date()
      UCETDOHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI
      UCETDOHDw ->nROK       := uctOBDOBI:FIN:NROK
      UCETDOHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI
      UCETDOHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN
      UCETDOHDw ->cZKRATMENY := SysConfig( 'Finance:cZaklMena')
      UCETDOHDw ->cUCTDPH_1  := SysConfig( 'Ucto:cUCETDPH1')
      UCETDOHDw ->cUCTDPH_2  := SysConfig( 'Ucto:cUCETDPH2')
      UCETDOHDw ->dVYSTDOK   := Date()
      UCETDOHDw ->nPROCDAN_1 := SeekSazDPH(1)
      UCETDOHDw ->nPROCDAN_2 := SeekSazDPH(2)
      UCETDOHDw ->nPROCDAN_3 := SeekSazDPH(3)

      * daòové doklady fakprihd/fakvyshd (zz)
      IF ischaracter(cf)
        UCETDOHDw ->nCISFAK    := (cf) ->nCISFAK
        ucetDohdW ->cdic       := (cf) ->cdic
        UCETDOHDw ->nCISFIRMY  := (cf) ->nCISFIRMY
        UCETDOHDw ->cVARSYM    := (cf) ->cVARSYM
        UCETDOHDw ->cDENIK_PAR := (cf) ->cDENIK
        IF cf = 'fakprihd'
          UCETDOHDw ->cTYPOBRATU := 'DAL'
          UCETDOHDw ->nTYPOBRATU := 2
          UCETDOHDw ->cDENIK     := SysConfig( 'Finance:cDENIKfdpz')
          UCETDOHDw ->nDOKLAD    := FIN_range_key('UCETDOHD:pz')[2]
          ucetdohdw ->_denik     := 'pz'
        ELSE
          UCETDOHDw ->cTYPOBRATU := 'MD'
          UCETDOHDw ->nTYPOBRATU := 1
          UCETDOHDw ->cDENIK     := SysConfig( 'Finance:cDENIKfdvz')
          UCETDOHDw ->nDOKLAD    := FIN_range_key('UCETDOHD:vz')[2]
          ucetDohdW ->cdanDoklad := allTrim(str( ucetDohdW->ndoklad))
          ucetdohdw ->_denik     := 'vz'
        ENDIF
        UCETDOHDw ->cUCET_UCT  := (cf) ->cUCET_UCT
        UCETDOHDw ->cTEXTDOK   := 'Pøijatá platba za ZalFal_' +StrTran(Str((cf) ->nCISFAK), ' ', '')
      ELSE
        UCETDOHDw ->cTYPOBRATU := 'MD'
        UCETDOHDw ->nTYPOBRATU := 1
        UCETDOHDw ->cDENIK     := SysConfig( 'Finance:cDenikFIDO')
        UCETDOHDw ->nDOKLAD    := FIN_range_key('UCETDOHD:vd')[2]
        ucetdohdw ->_denik     := 'vd'
      ENDIF
    endif
  ENDIF

  FIN_vykdph_cpy('UCETDOHDw')
RETURN(Nil)


*
** uložení úèetního dokladu **
FUNCTION FIN_ucetdohd_wrt(oDialog)
  local  anDoi   := {}, lDoi := .t., mainOk := .t., nrecor
  local  uctLikv

  if( odialog:lnewRec,fin_ucetdohd_typ(odialog:cmb_typPoh),nil)

  * pøedkonatce
  ucetdoitw->(flock())
  ucetdoitW->(dbEval( {|| ucetdoitW->ddatPoriz := ucetdohdW->dporizDok }), dbGoTop())
  uctLikv := UCT_likvidace():new(upper(ucetdohdw->culoha) +upper(ucetdohdw->ctypdoklad),.T.)

  ucetdoitw->(AdsSetOrder(0)    , ;
              dbgotop()         , ;
              dbeval({|| if(ucetdoitw->_nrecor <> 0, aadd(anDoi,ucetdoitw->_nrecor), nil) }))

  if .not. odialog:lnewRec
    ucetdohd->(dbgoto(ucetdohdw->_nrecor))
    mainOk := ucetdohd->(sx_rlock())                    .and. ;
              ucetdoit->(sx_rlock(anDoi))               .and. ;
              ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo))
  endif

  if mainOk .and. fin_vykdph_rlo('ucetdohdw')
    mh_copyfld('ucetdohdw','ucetdohd',odialog:lnewRec, .f.)
    ucetdoitw->(dbgotop())

    do while .not. ucetdoitw->(eof())
      ucetdoitW->ddatPoriz  := ucetdohdW->dporizDok
      ucetdoitW->cobdobi    := ucetdohdW->cobdobi
      ucetdoitW->nrok       := ucetdohdW->nrok
      ucetdoitW->nobdobi    := ucetdohdW->nobdobi
      ucetdoitW->cobdobiDan := ucetdohdW->cobdobiDan

      if((nrecor := ucetdoitw->_nrecor) = 0, nil, ucetdoit->(dbgoto(nrecor)))
      if   ucetdoitw->_delrec = '9'
        if( nrecor = 0, nil, ucetdoit->(dbdelete()))
      else
        mh_copyfld('ucetdoitw','ucetdoit',(nrecor=0), .f.)
        ucetdoit->ndoklad := ucetdohd->ndoklad
      endif

      ucetdoitw->(dbskip())
    enddo

    fin_vykdph_wrt(NIL,.f.,'UCETDOHD')
    uctLikv:ucetpol_wrt()
  else
    drgMsg(drgNLS:msg('Nelze modifikovat ÚÈETNÍ DOKLAD, blokováno uživatelem ...'),,oDialog)
  endif

  ucetdohd->(dbunlock(), dbcommit())
   ucetdoit->(dbunlock(), dbcommit())
    vykdph_i->(dbunlock(), dbcommit())
     ucetpol ->(dbunlock(), dbcommit())
RETURN mainOk


*
**
function fin_ucetdohd_typ(drgComboBox)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin, pa

  nin := ascan(values,{|x| x[1] = value })
   pa := listasarray(values[nin,4])

  ucetdohdw->ctypdoklad := values[nin,3]
  ucetdohdw->ctyppohybu := values[nin,1]
  ucetdohdw->ntypobratu := val(pa[2])
  ucetdohdw->ctypobratu := pa[1]
  ucetdohdw->(dbcommit())
return nil


*
** zrušení úèetního dokladu **
function fin_ucetdohd_del()
  local  anDoi   := {}, lDoi := .t., mainOk := .t., nrecor
  local  uctLikv

  * pøedkonatce
  uctLikv := UCT_likvidace():new(upper(ucetdohdw->culoha) +upper(ucetdohdw->ctypdoklad),.T.)

  ucetdoitw->(AdsSetOrder(0)    , ;
              dbgotop()         , ;
              dbeval({|| if(ucetdoitw->_nrecor <> 0, aadd(anDoi,ucetdoitw->_nrecor), nil) }))

  ucetdohd->(dbgoto(ucetdohdw->_nrecor))
  mainOk := ucetdohd->(sx_rlock())                    .and. ;
            ucetdoit->(sx_rlock(anDoi))               .and. ;
            ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo))

  if mainOk .and. fin_vykdph_rlo('ucetdohdw')
    ucetdoitw->(dbgotop())

    do while .not. ucetdoitw->(eof())
      nrecor := ucetdoitw->_nrecor
      ucetdoit->(dbgoto(nrecor),dbdelete())

      ucetdoitw->(dbskip())
    enddo

    fin_vykdph_wrt(NIL,.t.,'UCETDOHD')
    uctLikv:ucetpol_del()
    ucetdohd->(dbdelete())
  endif

  ucetdohd->(dbunlock(), dbcommit())
   ucetdoit->(dbunlock(), dbcommit())
    vykdph_i->(dbunlock(), dbcommit())
     ucetpol ->(dbunlock(), dbcommit())
RETURN mainOk