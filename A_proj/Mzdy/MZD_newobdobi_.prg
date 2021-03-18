#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch'
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"



function MZD_postDeleteObdobi( odlg )
  local  cc    := strZero(ucetSys->nobdobi,2) +'/' +strZero( ucetSys->nrok,4), nsel
  local  cinfo := 'Promiòte prosím,' +CRLF + ;
                  'požadujete zrušit obdobi [ ' +cc +' ]' + ' pro úlohu MZDY ?' +CRLF +CRLF

  local  xbp_therm, infObd
  local  cStatement, oStatement
  local  stmt

  stmt  := "delete from msPrc_mo where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from msSrz_mo where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from druhyMzd where nrok = %yyyy and nobdobi = %mm and ndistrib = 0 ; " + ;
           "delete from c_nempas where nrok = %yyyy and nobdobi = %mm and ndistrib = 0 ; " + ;
           "delete from msvPrum  where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from mzdDavhd where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from mzdDavit where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from mzdyhd   where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from mzdyit   where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from msOsb_mo where nrok = %yyyy and nobdobi = %mm ; "                  + ;
           "delete from ucetPol  where nrok = %yyyy and nobdobi = %mm and culoha = 'M' ;"  + ;
           "delete from ucetSys  where nrok = %yyyy and nobdobi = %mm and culoha = 'M'"    + ;
           if( Left(cc,2) = '01'," ; delete from msodppol where nrok = %yyyy" , "" )

  stmt_vyucDane := ;
    "update vyucDane set nMZDDAVHD = 0, nMZDDAVIT = 0 " + ;
    "where vyucDane.sid IN "                            + ;
    "(select mzdDavhd.nVYUCDANE FROM mzdDavhd where mzdDavhd.nrok = %yyyy and mzdDavhd.nobdobi = %mm)"


  cinfo += 'budou zrušeny záznamy v souborech '                  +CRLF
  cinfo += '      matrièní soubor pracovníkù, srážky,'           +CRLF
  cinfo += '      druhy mezd, prùmìry, doklady, èisté mzdy ... ' +CRLF


  nsel := ConfirmBox( , cinfo, ;
                       'Zrušení mzdového období ' +cc +' ...' , ;
                        XBPMB_YESNO                           , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

  if nsel = XBPMB_RET_YES
    cinfo := 'Promiòte prosím,' +CRLF + ;
             'opravdu požadujete zrušit obdobi [ ' +cc +' ]' + ' pro úlohu MZDY ?' +CRLF +CRLF

    nsel := ConfirmBox( , cinfo, ;
                          'Zrušení mzdového období ' +cc +' ...' , ;
                          XBPMB_YESNO                            , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

    if nsel = XBPMB_RET_YES
      xbp_therm := odlg:oMessageBar:msgStatus
      infObd    := strZero( ucetSys->nobdobi,2) +'/' +strZero( ucetSys->nrok,4)
      cinfo     := '... probíhá zrušení období [ ' + infObd +' ] úlohy MZDY ...'
      mzd_obdobinew_info( xbp_therm, cinfo)
      *
      ** odpojení vazeb na vyucDane
      cStatement := strTran( stmt_vyucDane, '%yyyy', str(ucetSys->nrok   ) )
      cStatement := strTran( cStatement   , '%mm'  , str(ucetSys->nobdobi) )

      oStatement := AdsStatement():New(cStatement, oSession_data)
      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
      endif
      *
      ** no a zbytek
      cStatement := strTran( stmt      , '%yyyy', str(ucetSys->nrok   ) )
      cStatement := strTran( cStatement, '%mm'  , str(ucetSys->nobdobi) )

      oStatement := AdsStatement():New(cStatement, oSession_data)
      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
      endif

      xbp_therm:setCaption( '  ' )
    endif
  endif
return .t.



function MZD_postAppendObdobi( oDlg)
  local o
  local recNo := ucetSys->(recNo())
  local cky   := upper(uctOBDOBI:MZD:culoha) +strZero(uctOBDOBI:MZD:NROK,4) +strZero( uctOBDOBI:MZD:NOBDOBI,2)

  * pro výpoèet prùmìrù musíme pracovat s novým obdobím
  uctOBDOBI:MZD:get()

  o := mzdOBDOBInew():new( odlg )
  o:processed()
  o:destroy()
  o := nil

  * vrátíme období na pùvodní
  ucetSys->( dbseek( cky,,,'UCETSYS3'))
  uctOBDOBI:MZD:get()
  ucetSys->( dbgoto( recNo))
return .t.


*
*********OBECNÁ TØÍDA PRO ZALOŽENÍ NOVÉHO OBDOBI PRO MZDY***********************
CLASS mzdOBDOBInew
  EXPORTED:
    METHOD  init, processed
    METHOD  destroy

    METHOD  new_msprc_ob
    METHOD  new_mssrz_ob
    METHOD  new_msodppol
    METHOD  new_druhymzd
    METHOD  new_prumery
    METHOD  new_c_nemPas
    METHOD  new_nemoc_hd
    METHOD  new_msOsb_mo


  HIDDEN:
    var     newRok, newMes, newObd, infObd
    var     rok, mes
    var     filtr
    var     xbp_therm
    var     rokUzv
ENDCLASS


method mzdOBDOBInew:init( oDlg)
  local cinfo

  ::newRok := oDlg:udcp:o_Rok:value
  ::newMes := oDlg:udcp:o_Obdobi:value
  ::newObd := StrZero(::newMes,2) +"/" +Right( StrZero(::newRok,4),2)
  ::infObd := StrZero(::newMes,2) +"/" +StrZero(::newRok,4)
  *
  ::rok    := if( ::newMes = 1, ::newRok-1, ::newRok   )
  ::mes    := if( ::newMes = 1,         12, ::newMes -1)
  *
  ::rokUzv := ::newMes = 1
  *
  ::xbp_therm := odlg:oMessageBar:msgStatus
  cinfo := '... probíhá pøíprava pro založení období [ ' + ::infObd +' ] úlohy MZDY ...'
  mzd_obdobinew_info( ::xbp_therm, cinfo)

  drgDBMS:open('msprc_mo')
  drgDBMS:open('msprc_mo',,,,,'msprc_mox')

  drgDBMS:open('mssrz_mo')
  drgDBMS:open('mssrz_mo',,,,,'mssrz_mox')

  drgDBMS:open('druhymzd')
  drgDBMS:open('druhymzd',,,,,'druhymzdx')

  drgDBMS:open('msvprum')
  drgDBMS:open('msvprum' ,,,,,'msvprumx' )

  drgDBMS:open('mzddavhd')
  drgDBMS:open('mzddavhd',,,,,'mzddavhdx')

  drgDBMS:open('c_nemPas')
  drgDBMS:open('c_nemPas',,,,,'c_nemPasx')

  if ::rokUzv
    drgDBMS:open('msodppol')
    drgDBMS:open('msodppol',,,,,'msodppolx')
    drgDBMS:open('c_odpoc')
  endif

  drgDBMS:open('msOsb_mo')
  drgDBMS:open('msOsb_mo',,,,,'msOsb_moX')

  drgDBMS:open('osoby')
//  drgDBMS:open('osoby',,,,,'osobyX')


  drgDBMS:open('c_pracDo')

  ::filtr     := Format("nROKOBD = %%", {(::rok*100)+::mes})

  msprc_mox ->( ads_setaof(::filtr), dbGoTop())
  mssrz_mox ->( ads_setaof(::filtr), dbGoTop())
  druhymzdx ->( ads_setaof(::filtr), dbGoTop())
  c_nemPasx ->( ads_setaof(::filtr), dbGoTop())
  msOsb_mox ->( ads_setaof(::filtr), dbGoTop())

  ::filtr     := Format("nROKOBD = %% .and. cDENIK = 'MN'", {(::rok*100)+::mes})

  mzddavhdx ->( ads_setaof(::filtr), dbGoTop())
return self


method mzdOBDOBInew:processed()
  local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread
  local     xbp_therm := ::xbp_therm
  *
  local       acolors := GRA_FILTER_OPTLEVEL, npos, oicon, oxbp, size, cinfo
  *
  local cStatement, oStatement
  local stmt_disableTriggers := "EXECUTE PROCEDURE sp_DisableTriggers( NULL, NULL, FALSE, 0 );"
  local stmt_enableTriggers  := "EXECUTE PROCEDURE sp_EnableTriggers( NULL, NULL, FALSE, 0 );"
  *
  ** musíme vypnout trigry
  oStatement := AdsStatement():New(stmt_disableTriggers,oSession_data)
  if oStatement:LastError > 0
*         return .f.
  else
    oStatement:Execute( 'test', .f. )
    oStatement:Close()
  endif
  *
  ** nachystáme si èervíka v samostatném vláknì
  for i := 1 to 4 step 1
    aBitMaps[3,i] := XbpBitmap():new():create()
    aBitMaps[3,i]:load( ,nPHASe )
    aBitMaps[3,i]:transparentClr := aBitMaps[3,i]:GetDefaultBGColor()
    nPHASe++
  next

  oThread := Thread():new()
  oThread:setInterval( 8 )
  oThread:start( "mzd_obdobinew_animate", xbp_therm, aBitMaps)

  oSession_data:beginTransaction()
  BEGIN SEQUENCE
    ::new_msprc_ob()       // msPrc_mo
    ::new_mssrz_ob()       // msSrz_mo
    ::new_druhymzd()       // druhyMzd
    ::new_prumery()        // msvPrum
    ::new_c_nemPas()       // c_nemPas
    ::new_nemoc_hd()       // mzdDavhd - pro pokraèování nemoci
    ::new_msOsb_mo()       // msOsb_mo
    oSession_data:commitTransaction()

  RECOVER USING oError
    oSession_data:rollbackTransaction()

    * musíme zrušit obdbobí pro mzdy - padlo to
    ucetSys->( dbdelete(), dbcommit() )
  END SEQUENCE

  * vrátíme to
  oThread:setInterval( NIL )
  oThread:synchronize( 0 )
  oThread := nil
  xbp_therm:setCaption( '  ' )
  *
  ** musíme zapnout trigry
  oStatement := AdsStatement():New(stmt_enableTriggers,oSession_data)
  if oStatement:LastError > 0
*         return .f.
  else
    oStatement:Execute( 'test', .f. )
    oStatement:Close()
  endif
return self


method mzdOBDOBInew:destroy()
  msprc_mox ->( dbCloseArea())
   mssrz_mox ->( dbCloseArea())
    druhymzdx ->( dbCloseArea())
     msvprumx  ->( dbCloseArea())
      mzddavhdx ->( dbCloseArea())
       c_nemPasx ->( dbCloseArea())
        msOsb_mox ->( dbCloseArea())
return self


method mzdOBDOBInew:new_msprc_ob( oDlg)
  local  dx, cx01, cx31
  local  ntm, nx
  local  nPDhod, nPDdny

  ::xbp_therm:cargo := '... zakládám kmenové údaje pro [ ' + ::infObd + ' ] ...'
  msprc_mox->( dbGoTop())

  do while .not. msprc_mox->( eof())
    db_to_db( 'msprc_mox','msprc_mo' )

    msprc_mo->nrok       := ::newRok
    msprc_mo->nobdobi    := ::newMes
    msprc_mo->cobdobi    := ::newObd
    msprc_mo->nrokobd    := (::newRok*100) +::newMes
    msprc_mo->cRoObCpPPv := StrZero(msprc_mo->nrokobd,6)+StrZero(msprc_mo->noscisprac,5) +;
                             +StrZero(msprc_mo->nporpravzt,3)
    msprc_mo->cRoCpPPv   := StrZero(msprc_mo->nrok,4)+StrZero(msprc_mo->noscisprac,5) +;
                             +StrZero(msprc_mo->nporpravzt,3)
    msprc_mo->cCpPPv     := StrZero(msprc_mo->noscisprac,5) +StrZero(msprc_mo->nporpravzt,3)
    msprc_mo->nDokladCM  := Val( SubStr(msprc_mo->cRoObCpPPv,3,9) + Right(msprc_mo->cRoObCpPPv,1))

    msPrc_mo->lStavem    := if( empty( msPrc_mo->ddatVyst), .t.                      ;
                            , if( year( msPrc_mo->ddatVyst) > ::newRok, .t.          ;
                             , if( month( msPrc_mo->ddatVyst) >= ::newMes .AND.      ;
                                   year ( msPrc_mo->ddatVyst)  = ::newRok, .t., .f.)))
    msPrc_mo->nStavem    := if( msPrc_mo->lStavem, 1, 0)

    if( ::rokUzv, msPrc_mo->lStavRok := .f., nil)
    msPrc_mo->lStavRok   := if( msPrc_mo->lStavem .and. .not. msPrc_mo->lStavRok,    ;
                                 msPrc_mo->lStavem, msPrc_mo->lStavRok)
    msPrc_mo->nStavRok    := if( msPrc_mo->lStavRok, 1, 0)

    msprc_mo->nrokobdsta := (msprc_mo->nrokobd*10) +msPrc_mo->nStavem
    msprc_mo->nctvrtleti := mh_CTVRTzOBDn( msprc_mo->nobdobi)

    msprc_mo->nDovMinCeO := 0
    msprc_mo->nDovBezCeO := 0

*    msPrc_mo->lzdrPojis  := ( msPrc_mo->lStavem .and. c_pracvz->lzdrPojis )
*    msPrc_mo->lsocPojis  := ( msPrc_mo->lStavem .and. c_pracvz->lSocPojis )


// otevøení nového roku
    if ::rokUzv
      if msprc_mox->nTypPraVzt <> 5 .and. msprc_mox ->nTypPraVzt <> 6      ;
                 .and. Empty( msprc_mox->dDatVyst)
        if Empty( msprc_mox->dDatPredVy) .or. Year( msprc_mox->dDatPredVy) < ::newRok
          msprc_mo->nDovBezNar := SysConfig( "Mzdy:nNarDovol")
        elseif Year( msprc_mox->dDatPredVy) = ::newRok
          dx   := msprc_mox->dDatVyst
          cx01 := "01.01." +StrZero( ::newRok,4)
          cx31 := "31.12." +StrZero( ::newRok,4)
          if dX >= CtoD( cx01)
            ntm := D_DnyOdDo( CtoD(cx01), CtoD( cx31), "PRAC")
            nX  := D_DnyOdDo( CtoD(cx01), dX         , "PRAC")
            nX  := ( nX * 4)/ 52.143
            msprc_mo->nDovBezNar := MH_RoundNumb( nX, 222)
          endif
        endif
        msprc_mo->nDovBezCer := 0
        msprc_mo->nDovBezZus := msprc_mo->nDovBezNar

        msprc_mo->nDovMinNar := msprc_mox ->nDovBezZus
        msprc_mo->nDovMinCer := 0
        msprc_mo->nDovMinZus := msprc_mo->nDovMinNar

        msprc_mo->nDovZustat := msprc_mo->nDovBezZus +msprc_mo->nDovMinZus

        msprc_mo->nDoDBezNar := SysConfig( "Mzdy:nNarDovolD")
        msprc_mo->nDoDBezCer := 0
        msprc_mo->nDoDBezZus := msprc_mo->nDoDBezNar

        msprc_mo->nDoDMinNar := msprc_mox ->nDoDBezZus
        msprc_mo->nDoDMinCer := 0
        msprc_mo->nDoDMinZus := msprc_mo->nDoDMinNar

        msprc_mo->nDoDZustat := msprc_mo->nDoDBezZus +msprc_mo->nDoDMinZus

        msprc_mo->nDovNaroCe := msprc_mo->nDovBezNar +msprc_mo->nDovMinNar + msprc_mo->nDoDBezNar
        msprc_mo->nDovZustCe := msprc_mo->nDovZustat +msprc_mo->nDoDZustat

        msprc_mo->nDovMinCeO := 0
        msprc_mo->nDovBezCeO := 0
        msprc_mo->nDovCerOCe := 0
        msprc_mo->nDovCerRCe := 0
        msprc_mo->nDovPrlOCe := 0
        msprc_mo->nDovPrlRCe := 0

// ------------------------   pro rok 2021   ---  dál se musí upravit

        nPDhod := if( c_pracdo->( dbseek( Upper(msprc_mo->cdelkprdob),,,'C_PRACDO01')), c_pracdo->nHodDen, 0)
        nPDdny := if( c_pracdo->( dbseek( Upper(msprc_mo->cdelkprdob),,,'C_PRACDO01')), c_pracdo->nDnyTyden, 0)

        msprc_mo->nTDoBezNar := if(nPDdny > 0, msprc_mo->nDovBezNar/nPDdny,0)

        msprc_mo->nHDoBezNar := msprc_mo->nDovBezNar * nPDhod
        msprc_mo->nHDoBezCer := 0
        msprc_mo->nHDoBezZus := msprc_mo->nDovBezNar * nPDhod

        msprc_mo->nHDoMinNar := msprc_mox->nDovBezZus * nPDhod
        msprc_mo->nHDoMinCer := 0
        msprc_mo->nHDoMinZus := msprc_mo->nDovMinNar * nPDhod

        msprc_mo->nHDoZustat := msprc_mo->nHDoBezZus +msprc_mo->nHDoMinZus

        msprc_mo->nHDDBezNar := SysConfig( "Mzdy:nNarDovolD")
        msprc_mo->nHDDBezCer := 0
        msprc_mo->nHDDBezZus := msprc_mo->nDoDBezNar

        msprc_mo->nHDDMinNar := msprc_mox ->nDoDBezZus
        msprc_mo->nHDDMinCer := 0
        msprc_mo->nHDDMinZus := msprc_mo->nDoDMinNar

        msprc_mo->nHDDZustat := msprc_mo->nHDDBezZus +msprc_mo->nHDDMinZus

        msprc_mo->nHDoNaroCe := msprc_mo->nHDoBezNar +msprc_mo->nHDoMinNar + msprc_mo->nHDDBezNar
        msprc_mo->nHDoZustCe := msprc_mo->nHDoZustat +msprc_mo->nHDDZustat

        msprc_mo->nHDoMinCeO := 0
        msprc_mo->nHDoBezCeO := 0
        msprc_mo->nHDoCerOCe := 0
        msprc_mo->nHDoCerRCe := 0
        msprc_mo->nHDoPrlOCe := 0
        msprc_mo->nHDoPrlRCe := 0

      endif

      ::new_msodppol()
    endif
    msPrc_mo->( dbunlock())
    msprc_mox ->( dbSkip())
  enddo

*  msPrc_mo->( dbunlock(), dbcommit() )
  msPrc_mo->( dbcommit() )
return self



method mzdOBDOBInew:new_msodppol(oDlg)
  local  nCelkOdOBD, nCelkOdROK
  local  nCelkUlOBD, nCelkUlROK
  local  filter
  local  odpPOLtm
  local  ndite

  nCelkOdOBD := nCelkOdROK := nCelkUlOBD := nCelkUlROK := 0
  ndite := 1

  if Empty( msprc_mox->dDatVyst) .or. Year( msprc_mox->dDatVyst) = ::newRok
    filter := Format("cRoCpPPv = '%%'", {msprc_mo->cRoCpPPv})
    msodppol->( ads_setaof(filter), dbGoTop())
    do while .not. msodppol->( Eof())
      if msodppol->( dbRlock())
        msodppol->( dbDelete())
      endif
      msodppol->( dbSkip())
    enddo
    ( msodppol->( dbUnlock()), msodppol->( ads_ClearAof()))

    filter := Format("cRoCpPPv = '%%'", {msprc_mox->cRoCpPPv})
    msodppolx->( ads_setaof(filter), dbGoTop())

    do while .not.msodppolx->( Eof())
      odpPOLtm := Upper( msodppolx->cTypOdpPol)
      if odpPOLtm = 'DITE'
        odpPOLtm := 'DIT' +if( ndite < 3, Str(ndite,1), '3')
        ndite++
      endif

      if c_odpoc ->( dbSeek( StrZero(::newRok,4) +odpPOLtm,,'C_ODPOC04')) .and. ;
          ( Empty( msodppolx->dPlatnDo) .or. Year( msodppolx->dPlatnDo) = ::newRok)
  *      mh_CopyFLD( 'MsOdpPol', 'MsOdpPoP', .T.)
        db_to_db( 'msodppolx','msodppol' )

        msodppol->nROK       := c_odpoc->nROK
        msodppol->cPracovnik := msprc_mox->cPracovnik
        msodppol->cOsoba     := msprc_mox->cOsoba
        msodppol->cjmenoRozl := msprc_mox->cjmenoRozl

        msodppol->cTypOdpPol := c_odpoc->cTypOdpPol
        msodppol->cNazOdpPol := c_odpoc->cNazOdpPol
        msodppol->cObdOd     := "01/" +SubStr( msprc_mo->cobdobi, 4, 2)
        msodppol->cObdDo     := "12/" +SubStr( msprc_mo->cobdobi, 4, 2)

        msodppol ->lAktiv     := .T.
        msodppol->nOdpocOBD  := c_odpoc->nOdpocOBD
        msodppol->nOdpocROK  := c_odpoc->nOdpocROK
        msodppol->nDanUlOBD  := c_odpoc->nDanUlOBD
        msodppol->nDanUlROK  := c_odpoc->nDanUlROK

        msodppol->lOdpocet   := c_odpoc->lOdpocet
        msodppol->lDanUleva  := c_odpoc->lDanUleva

        msodppol->cRoCpPPv   := StrZero(msodppol->nROK,4) +          ;
                                 StrZero(msodppol->nOsCisPrac,5) +   ;
                                  StrZero(msodppol->nPorPraVzt,3)

        nCelkOdOBD += msodppol->nOdpocOBD
        nCelkOdROK += msodppol->nOdpocROK
        nCelkUlOBD += msodppol->nDanUlOBD
        nCelkUlROK += msodppol->nDanUlROK
      endif
      msodppolx->( dbSkip())
    enddo

    ( msodppol->( dbUnlock()), msodppolx->( ads_ClearAof()))

    msprc_mo->nOdpocOBD := nCelkOdOBD
    msprc_mo->nOdpocROK := nCelkOdROK
    msprc_mo->nDanUlOBD := nCelkUlOBD
    msprc_mo->nDanUlROK := nCelkUlROK
  endif

return self



method mzdOBDOBInew:new_mssrz_ob(oDlg)

  ::xbp_therm:cargo :=  '... zakládám srážky pro [ ' + ::infObd + ' ] ...'
  mssrz_mox->( dbGoTop())

  do while .not. mssrz_mox->( eof())
    db_to_db( 'mssrz_mox','mssrz_mo' )

    mssrz_mo->nrok       := ::newRok
    mssrz_mo->nobdobi    := ::newMes
    mssrz_mo->cobdobi    := ::newObd
    mssrz_mo->nrokobd    := (::newRok*100) +::newMes
    mssrz_mo->cRoObCpPPv := StrZero(mssrz_mo->nrokobd,6)     ;
                            +StrZero(mssrz_mo->noscisprac,5) ;
                             +StrZero(mssrz_mo->nporpravzt,3)

    if msprc_mo->(dbSeek( mssrz_mo->cRoObCpPPv,,'MSPRMO17'))
      mssrz_mo->nrokobdsta := msprc_mo->nrokobdsta
      mssrz_mo->nmsprc_mo  := isNull( msprc_mo->sid, 0)
    endif
    mssrz_mox ->( dbSkip())
  enddo

   msSrz_mo->( dbunlock(), dbcommit() )
return self


method mzdOBDOBInew:new_druhymzd(oDlg)
  local cky := strZero(::newRok,4) +strZero(::newMes,2)

  ::xbp_therm :cargo := '... zakládám druhy mezd pro [ ' + ::infObd + ' ] ...'
  druhymzdx->( dbGoTop())

  do while .not. druhymzdx->( eof())
    do case
    case .not. druhyMzd->( dbseek( cky +strZero(druhyMzdx->ndruhMzdy,4),,'DRUHYMZD04'))

      db_to_db( 'druhymzdx','druhymzd' )

      druhymzd->nrok    := ::newRok
      druhymzd->nobdobi := ::newMes
      druhymzd->cobdobi := ::newObd
      druhymzd->nrokobd := ( ::newRok*100) +::newMes

    otherWise
      * distribuce pøedbìhla založení období
      if druhyMzdX->ndistrib <> 1 .and. druhyMzd->( sx_RLock())
        db_to_db( 'druhymzdx','druhymzd', .f. )

        druhymzd->nrok    := ::newRok
        druhymzd->nobdobi := ::newMes
        druhymzd->cobdobi := ::newObd
        druhymzd->nrokobd := ( ::newRok*100) +::newMes

        druhyMzd->( dbUnlock())
      endif
    endcase

    druhymzdx ->( dbSkip())
  enddo

  druhyMzd->( dbunlock(), dbcommit() )
return self


method mzdOBDOBInew:new_c_nemPas(oDlg)
  local cky := strZero(::newRok,4) +strZero(::newMes,2)

  ::xbp_therm :cargo := '... zakládám èíselník nemocenských pásem pro [ ' + ::infObd + ' ] ...'
  c_nemPasx->( dbGoTop())

  do while .not. c_nemPasx->( eof())
    if .not. c_nemPas->( dbseek( cky +upper(c_nemPasx->ctypPohybu) +strZero(c_nemPasx->npasmo,3),,'C_NEMPAS02'))

      db_to_db( 'c_nemPasx','c_nemPas' )

      c_nemPas->nrok    := ::newRok
      c_nemPas->nobdobi := ::newMes
      c_nemPas->cobdobi := ::newObd
      c_nemPas->nrokobd := ( ::newRok*100) +::newMes
    endif

    c_nemPasx ->( dbSkip())
  enddo

  c_nemPas->( dbunlock(), dbcommit() )
return self


// vypoèítá prùmìry pro nové období
method mzdOBDOBInew:new_prumery(oDlg)
  local  key     := StrZero(::newRok,4) +StrZero(::newMes,2)
  local  cfilter := msPrc_mo->( ads_getAof())
  local  recNo   := msPrc_mo->( recNo())
  local  cky_Old

  ::xbp_therm:cargo :=  '... poèítám prùmìry pro nové období [ ' + ::infObd + ' ] ...'

  * musíme shodit filtr
  if( .not. empty(cfilter), msPrc_mo->(Ads_clearAOF(), dbgotop()), nil )

  msprc_mox ->( dbgoTop())
  do while .not. msprc_mox->( eof())

    if msPrc_mox->lAutoVypPr
      msPrc_mo->( dbseek( key +strZero( msPrc_mox->nosCisPrac,5) +strZero( msPrc_mox->nporPraVzt,3),,'MSPRMO01'))

      ::xbp_therm:cargo :=  '... poèítám prùmìry pro nové období [ ' + ::infObd + ' ] ' + ;
                             allTrim(msPrc_mo->cjmenoRozl) +' ...'

      * pokud nebyly žádné podklady pro výpoèet prùmìru,
      * vezmeme prùmer z pøedchozího období, pokud existuje
      if .not. fVYPprumer( .t.,,, key,,,1 )
        cky_Old := strZero(::rok,4) +strZero(::mes,2) + ;
                   strZero( msPrc_mox->nosCisPrac,5) +strZero( msPrc_mox->nporPraVzt,3)

  /*       úprava JT 3.8.2015  zabudováno pøímo do výpoètu
        if msvprumx->( dbseek( cky_Old,,'PRUMV_03'))
          db_to_db( 'msvprumx','msvprum' )

          msvprum->nrok       := ::newRok
          msvprum->nobdobi    := ::newMes
          msvprum->cobdobi    := ::newObd
          msvprum->nrokobd    := (::newRok*100) +::newMes
          msvprum->cRoObCpPPv := strZero(msvprum->nrokobd,6)   + ;
                                 strZero(msvprum->noscisprac,5)+ ;
                                 strZero(msvprum->nporpravzt,3)
          msvprum->nmsprc_mo  := msprc_mo->sid

          msvprum->( dbunlock(), dbcommit())
        endif
  */

      endif
    endif

    msprc_mox ->( dbSkip())
  enddo

  msvPrum->( dbunlock(), dbCommit() )

  * musíme nahodit filtr
  if( .not. empty(cfilter), msPrc_mo->(Ads_setAOF(cfilter), dbgoto(recNo)), nil )
return self


// vytvoøí hlavièky pokraèujících nemocenek
method mzdOBDOBInew:new_nemoc_hd(oDlg)
  local  key

  ::xbp_therm:cargo :=  '... generuji doklady pro pokraèující nemoci [ ' + ::infObd + ' ] ...'

  mzddavhdx->( dbGoTop())

  do while .not. mzddavhdx->( eof())
    if Empty( mzddavhdx->dDatumDO)
      db_to_db( 'mzddavhdx','mzddavhd' )

      mzddavhd->nrok     := ::newRok
      mzddavhd->nobdobi  := ::newMes
      mzddavhd->cobdobi  := ::newObd
      mzddavhd->nrokobd  := ( ::newRok*100) +::newMes
      mzddavhd->ndoklad  := fin_range_key('MZDDAVHD:MN')[2]
      mzddavhd->nautoGen := 1

      mzddavhd->croobcpppv := StrZero(::newRok,4)+StrZero(::newMes,2)+     ;
                               StrZero(mzddavhd->noscisprac,5)+            ;
                                 StrZero(mzddavhd->nporpravzt,3)
      mzddavhd->crocpppv   := StrZero(::newRok,4)+                        ;
                               StrZero(mzddavhd->noscisprac,5)+            ;
                                 StrZero(mzddavhd->nporpravzt,3)
      mzddavhd->ccpppv   :=   StrZero(mzddavhd->noscisprac,5)+            ;
                                 StrZero(mzddavhd->nporpravzt,3)

      if msprc_mo->(dbSeek( mzddavhd->cRoObCpPPv,,'MSPRMO17'))
        mzddavhd->nmsprc_mo  := isNull( msprc_mo->sid, 0)
      endif

    endif
    mzddavhdx ->( dbSkip())
  enddo

  mzddavhd->( dbunlock(), dbcommit() )
return self


method mzdOBDOBInew:new_msOsb_mo(oDlg)
  local  key, nstavem := 0

  ::xbp_therm:cargo :=  '... zakládám osobní údaje pracovníkù pro [ ' + ::infObd + ' ] ...'
  msOsb_mox->( dbgoTop())

   do while .not. msOsb_mox->( eof())
    db_to_db( 'msOsb_mox','msOsb_mo' )

    msOsb_mo ->nrok       := ::newRok
    msOsb_mo ->nobdobi    := ::newMes
    msOsb_mo ->cobdobi    := ::newObd
    msOsb_mo ->nrokobd    := (::newRok*100) +::newMes
    msOsb_mo ->nctvrtleti := mh_CTVRTzOBDn( msOsb_mo->nobdobi)
//    msOsb_mo ->nrokObdSta
    msOsb_mo ->croObCp     := StrZero(msOsb_mo->nrokobd,6) +StrZero(msOsb_mo->noscisprac,5)
    msOsb_mo ->croCp       := StrZero(msOsb_mo->nrok,4)    +StrZero(msOsb_mo->nOsCisPrac,5)

    fordRec( { 'msPrc_mo' } )
      msPrc_mo->( ordSetFocus( 'MSPRMO26' )                  , ;
                  dbsetScope(SCOPE_BOTH, msOsb_mo ->croObCp ), ;
                  dbgoTop()                                  , ;
                  dbeval({ || nstavem += msPrc_mo->nStavem })  )

      msOsb_mo ->nStavem := if( nstavem <> 0,  1,   0  )
      msOsb_mo ->lStavem := if( nstavem <> 0, .t., .f. )
    fordRec()

    msOsb_mo ->nrokObdSta := (msOsb_mo->nrokobd * 10) +if( nstavem <> 0, 1, 0 )
/*
    if osoby->( dbSeek(msOsb_mo->ncisosoby,,'OSOBY01'))
      if osoby->( dbRlock())
        if nstavem = 0 .and. osoby->nis_DOH <> 0
          osoby->nis_DOH := 0
          AktSkupOSB( osoby->ncisosoby, 'DOH', 'DEL')
        endif
        if nstavem = 0 .and. osoby->nis_VYR <> 0
          osoby->nis_VYR := 0
          AktSkupOSB( osoby->ncisosoby, 'VYR', 'DEL')
        endif
        osoby ->nStavem := if( nstavem <> 0,  1,   0  )
        osoby ->lStavem := if( nstavem <> 0, .t., .f. )
      endif
    endif
*/
    msOsb_mox ->( dbSkip())
  enddo

   msOsb_mo->( dbunlock(), dbcommit())
   Osoby->( dbunlock(), dbcommit())

return self


*
** tato procedura je použita pøi inicializaci založení období a pøi rušení obdobi
static procedure mzd_obdobinew_info( xbp_therm, cinfo)
  local  GradientColors := GRA_FILTER_OPTLEVEL[3,2]
  local  oPs, oFont     := XbpFont():new():create( "9.Arial CE" )
  local  nSize   := xbp_therm:currentSize()[1]
  local  nHight  := xbp_therm:currentSize()[2]
  *
  oPS   := xbp_therm:lockPS()
  GraGradient( ops            , ;
             {0,0}           , ;
             {{nsize,nHight}}, ;
             GradientColors, GRA_GRADIENT_HORIZONTAL)

  GraSetFont ( oPS, oFont )
  GraStringAt( ops, {(nSize/2) -(len(cinfo) *oFont:width)/2,3}, cinfo )

  xbp_therm:unlockPS( oPS )
return


procedure mzd_obdobinew_animate(xbp_therm,aBitMaps)
  local  aRect, oPS, nXD, nYD
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  local  oFont          := XbpFont():new():create( "9.Arial CE" )
  *
  local  nSize   := xbp_therm:currentSize()[1]
  local  nHight  := xbp_therm:currentSize()[2]
  local  cinfo   := if( isNull( xbp_therm:cargo), '', xbp_therm:cargo)

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  GraGradient( ops            , ;
              {0,0}           , ;
              {{nsize,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  GraSetColor( oPS, GRA_CLR_BLUE )
  GraSetFont ( oPS, oFont )
  GraStringAt( ops, {(nSize/2) -(len(cinfo) *oFont:width)/2,3}, cinfo )

  nXD     := abitMaps[2]
  nYD     := 0

  aBitMaps[1] ++
  if aBitMaps[1] > len(aBitMaps[3])
    aBitMaps[1] := 1
  endif

  aBitMaps[ 3, aBitMaps[1] ]:draw( oPS, {nXD,nYD} )
  xbp_therm:unlockPS( oPS )

  if abitMaps[2] +10 > aRect[1]
    abitMaps[2] := 0
  else
    abitMaps[2] := abitMaps[2] +10
  endif
return


static function db_to_db(cDBfrom,cDBto, lDBapp )
  local aFrom := ( cDBFrom) ->( dbStruct())

  Default lDBapp to .t.

  if( lDBapp, (cDBto)->(dbappend()), nil )
  aEval( aFrom, { |X,M| ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                          nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                          If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )
return nil