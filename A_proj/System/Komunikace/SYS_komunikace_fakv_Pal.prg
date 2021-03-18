#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "dmlb.ch"
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"
#include "Fileio.ch"
#include "class.ch"

#include "Deldbe.ch"
#include "Sdfdbe.ch"
#include "DbStruct.ch"
#include "Directry.ch"

#include "Gra.ch"

#include "..\A_main\WinApi_.ch"

#include "activex.ch"
#include "excel.ch"

#include "XbZ_Zip.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )


// Import paleèek - REJTAR
function DIST000064( oxbp ) // oxbp = drgDialog
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  * pro excel
  local  oExcel, oBook, oSheet
  local  cCisZakImp, aImpKusov
  local  nRow, nCol, contRows
  local  nvicekusov
  local  newrec
  local  countrec
  *
  local  odialog, nexit := drgEVENT_QUIT

  odialog := drgDialog():new('SYS_komunikace_fakv_Pal', oxbp)
  odialog:create(,,.T.)

  odialog:destroy()
  odialog := Nil
return(NIL)

*
*************** FIN_fakvyshd_imp_pal ******************************************
CLASS SYS_komunikace_fakv_Pal FROM drgUsrClass
exported:
  var     datZprac, workDir, stavZprac
  method  zpracuj_Palecka, uloz_Palecka

  inline method init(parent)

    ::drgUsrClass:init(parent)

    ::datZprac  := date()
    ::workDir   := odata_datKom:PathImport

    drgDBMS:open( 'firmy'    )
    drgDBMS:open( 'firmyFi'  )
    drgDBMS:open( 'fakvyshd' )
    drgDBMS:open( 'fakvysit' )
    drgDBMS:open( 'c_vykDph' )
    drgDBMS:open( 'ucetpol'  )
    *
    ** pro kontrolu duplicity
    drgDBMS:open( 'fakvyshd',,,,,'fakVysh_d' )


    drgDBMS:open('c_bankUc')
    if( .not. c_bankuc->(dbseek(.t.,,'bankuc2')), c_bankuc->(dbgotop()),nil)

    ** tmp **
    drgDBMS:open('fakVysHDw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
    drgDBMS:open('fakVysITw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
    drgDBMS:open('vykDph_iw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  return self

  inline method drgDialogStart(drgDialog)
    local x, pA, members  := drgDialog:oForm:aMembers

    ::msg           := drgDialog:oMessageBar             // messageBar
    ::dm            := drgDialog:dataManager             // dataMabanager
    ::dc            := drgDialog:dialogCtrl              // dataCtrl
    ::df            := drgDialog:oForm                   // form
    ::ab            := drgDialog:oActionBar:members      // actionBar
    *
    ::xbp_therm     := drgDialog:oMessageBar:msgStatus

    ::aEdits        := {}
    ::pa_pushButton := {}

    for x := 1 to LEN(members) step 1
     if  members[x]:ClassName() = 'drgPushButton'
       aadd( ::pa_pushButton, members[x] )
     endif

     if .not. Empty(members[x]:groups)
       pA  := ListAsArray(members[x]:groups,':')
       nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

       if(nIn <> 0, ::aEDITs[nIn,8] := members[x], ;
                    AAdd(::aEDITs, { pA[1], pA[2], pA[3], pA[4], pA[5], pA[6], members[x], NIL }))
      endif
    next
  return self

  inline method drgDialogEnd(drgDialog)
    ::msg   := ;
    ::dm    := ;
    ::dc    := ;
    ::df    := NIL

    fakVysHDw->( dbcloseArea())
    fakVysITw->( dbcloseArea())
    if( select( 'HL') <> 0, HL->(dbcloseArea()), nil )
    if( select( 'PO') <> 0, PO->(dbcloseArea()), nil )
  return self

  inline method sel_workDir()
    local  oXbp    := ::dm:has('M->workDir'):oDrg:oXbp
    local  in_Dir, cc := 'Vyberte prosím adresáø pro import ...'
    *
    local  old_Dir := ::workDir

    in_Dir := BrowseForFolder( , cc, BIF_USENEWUI, old_Dir )

    if .not. empty(in_Dir)
      ::workDir := in_Dir +'\'
      ::dm:set( 'M->workDir', ::workDir )
    endif
  return .t.

  inline method zpracuj_Palecka_inTrans()

    aeval( ::pa_pushButton, { |o| o:oxbp:disable() } )
    oSession_data:beginTransaction()

    BEGIN SEQUENCE
      ::zpracuj_Palecka()
      oSession_data:commitTransaction()

    RECOVER USING oError
      oSession_data:rollbackTransaction()
    END SEQUENCE

    _clearEventLoop(.t.)
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      return .f.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE .or. ;
           nEvent = drgEVENT_SAVE        )
      return .t.

    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, ab, xbp_therm, pa_pushButton
* datové
  var     aEdits, cfilter

  inline method recToArr(calias)
    local  nFCount := ( cAlias) ->(fCount()), nField
    local  axRecArr := {}

    for nField := 1 to nFCount step 1
      aAdd( axRecArr, ( cAlias) ->( fieldGet( nField)))
    Next
    return axRecArr

  inline method arrToRec( aArray, calias)
    local  nFCount := ( cAlias)->( FCount()), nField

    for nField := 1 To nFCount step 1
      (cAlias)-> ( FieldPut( nField, aArray[ nField] ))
    next
    return nil

ENDCLASS


method SYS_komunikace_fakv_Pal:zpracuj_Palecka()
  local  cvst  , cfileinHL, cfileinPO, ax_fakVysITw
  local  cisFak, nintCount, nsum_Priplatek
  * pro teplomìry
  local  oxbp, nrecCnt, nkeyCnt, nkeyNo, nSize, nHight

  ::datZprac  := ::dm:get('M->datZprac')
  ::workDir   := retDir( ::dm:get('M->workDir' ))

  cvst        :=  Right  ( Str( Year ( ::datZprac)),2) + ;
                  StrZero(      Month( ::datZprac), 2) + ;
                  StrZero(      Day  ( ::datZprac), 2)
  cfileinHL   := allTrim( ::workDir) +'HL' +cvst
  cfileinPO   := allTrim( ::workDir) +'Po' +cvst

  if file( cfileinHL +'.dbf') .and. file( cfileinPO +'.dbf')
    dbuseArea( .t., 'FOXCDX', cfileinHL, 'HL',, .f.)
    dbuseArea( .t., 'FOXCDX', cfileinPO, 'PO',, .f.)

    oxbp    := ::aedits[1,8]:oxbp
    nSize   := oxbp:currentSize()[1]
    nHight  := oxbp:currentSize()[2] -2
    *
    ** je domìnka, že po importu ze strany PALEÈKA zùstanou soubory otevøené
    ** pak to zhavaruje na    -->  nrecCnt := HL->(lastRec())
    if .not. ( used('HL') .and. used('PO') )

      fin_info_box('Nelze importovat data ...',XBPMB_CRITICAL)

      PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
      return self
    endif

    nrecCnt := HL->(lastRec())
    nkeyCnt := nrecCnt
    nkeyNo  := 1

    * naèteme data do TMT
    do while .not. HL->(eof())
      cisFak := val( strTran( HL->CFAKT, '/', ''))

      if .not. fakVysh_d->( dbseek( cisFak,, 'FODBHD1'))

        HL_to_fakVysHDw()

        nintCount      := 1
        nsum_Priplatek := 0

        PO->( dbgoTop()                                                         , ;
              dbeval( { || ( PO_to_fakVysITw( nintCount )  , ;
                             nintCount      := nintCount +1, ;
                             nsum_Priplatek += (PO ->PRIPLATEK * PO ->MNOZ) )  }, ;
                      { || HL->CFAKT = PO->CFAKT } ), ;
              dbgoTop()  )

        *
        ** pøíplatek za recyklaci
        if nsum_Priplatek <> 0
           ax_fakVysITw := ::recToArr( 'fakVysITw' )

           fakVysITw->( dbAppend())
           ::arrToRec( ax_fakVysITw, 'fakVysITw' )

           fakVysITw ->nintCount   := nintCount
           fakVysITw ->cSklPol     := ''
           fakVysITw ->cNazZbo     := 'RECYKLACE'
           fakVysITw ->nCeJPrZBZ   := nsum_Priplatek
           fakVysITw ->nCeJPrKBZ   := nsum_Priplatek
           fakVysITw ->nCeJPrKDZ   := fakVysITw ->nCeJPrKBZ +( fakVysITw ->nCeJPrKBZ * ( fakVysITw->nprocDph/100))
           fakVysITw ->nCeCPrZBZ   := nsum_Priplatek
           fakVysITw ->nCeCPrKBZ   := nsum_Priplatek
           fakVysITw ->nCeCPrKDZ   := fakVysITw ->nCeJPrKDZ
           fakVysITw ->nCenJedZak  := fakVysITw ->nCeJPrZBZ
           fakVysITw ->nCenJedZaD  := fakVysITw ->nCeJPrKDZ
           fakVysITw ->nCenZakCel  := fakVysITw ->nCeCPrKBZ
           fakVysITw ->nCenZakCeD  := fakVysITw ->nCeCPrKDZ
           fakVysITw ->nCenZakCel  := fakVysITw ->nCeCPrKBZ
           fakVysITw ->nCenZakCeD  := fakVysITw ->nCeCPrKDZ
           fakVysITw ->nSazDan     := fakVysITw ->nCeCPrKDZ -fakVysITw ->nCeCPrZBZ
           fakVysITw ->nFaktMnoz   := 1
           fakVysITw ->cZkratJedn  := 'x'
           fakVysITw ->nProcSlev   := 0
           fakVysITw ->nHodnSlev   := 0
           fakVysITw ->nCenaZakl   := fakVysITw ->nCeCPrKBZ
           fakVysITw ->nCenaZakC   := fakVysITw ->nCeCPrZBZ
           fakVysITw ->nCelkSlev   := 0
           fakVysITw ->cUcet       := "604150"
        endif

        * zpracujem naètená data vèetnì vykDPH_I a likvidace
        ::uloz_Palecka(nkeycnt,nkeyno)
      endif


      HL->( dbSkip())
      nkeyNo++

      if( HL->(eof()), nkeyno := nkeyCnt, nil )
      fin_bilancew_pb(oxbp,nkeycnt,nkeyno,nsize,nhight)
    enddo
  endif

  sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
return self


method SYS_komunikace_fakv_Pal:uloz_Palecka(nkeycnt,nkeyno)
  * pro teplomìry
  local  oxbp, nSize, nHight
  local  uctLikvidace

  oxbp    := ::aedits[2,8]:oxbp
  nSize   := oxbp:currentSize()[1]
  nHight  := oxbp:currentSize()[2] -2

  if fakVysHDw ->ctypDoklad = 'FIN_FAKVB'
    *
    ** výkaz DPH
    fin_vykdph_cpy( 'fakVysHDw', {1,2} )

    * implicitnì ØV -> 1
    if fakVysHDw->nzaklDan_1 <> 0
      if vykdph_iw->( dbseek( 2,,'VYKDPH_5'))
        vykdph_iw->nzakld_dph := fakVysHDw->nzaklDan_1
        vykdph_iw->nsazba_dph := fakVysHDw->nsazDan_1
      endif
    endif

    * implicitnì Øv -> 2
    if fakVysHDw->nzaklDan_2 <> 0
      if vykdph_iw->( dbseek( 1,,'VYKDPH_5'))
        vykdph_iw->nzakld_dph := fakVysHDw->nzaklDan_2
        vykdph_iw->nsazba_dph := fakVysHDw->nsazDan_2
      endif
    endif

  else
    *
    ** výkaz DPH
    fin_vykdph_cpy( 'fakVysHDw', {20} )

    if vykdph_iw->( dbseek( 20,,'VYKDPH_5'))
      vykdph_iw->nzakld_dph := fakVysHDw ->ncenZakCel
    endif
  endif

  fin_vykdph_rlo( 'fakVysHDw' )
  uctLikv := UCT_likvidace():new(upper(fakvyshdw->culoha) +upper(fakvyshdw->ctypdoklad),.T.)

*
  mh_copyfld('fakvyshdw','fakvyshd', .t., .f.)
  fakVysITw->(dbgoTop()                                                  , ;
              dbeval( { || mh_copyfld('fakVysITw','fakvysit',.t., .f.) } ) )

  fin_vykdph_wrt(NIL,.f.,'FAKVYSHD')
  uctLikv:ucetpol_wrt()

  fakvyshd->(dbunlock(), dbcommit())
  fakvysit->(dbunlock(), dbcommit())
  vykdph_i->(dbunlock(), dbcommit())
  ucetpol ->(dbunlock(), dbcommit())
*

  fin_bilancew_pb(oxbp,nkeycnt,nkeyno+1,nsize,nhight, GRA_CLR_RED)
   fakVysHDw->(dbzap())
    fakVysITw->(dbzap())
     vykDph_Iw->(dbzap())
return self


static function HL_to_fakVysHDw()
  local cx         := str( year( HL ->ODESLANI ))
  local cisFak     := val( strTran( HL ->CFAKT, '/', ''))
  *
  local zahranicni := HL->zahranicni

  fakVysHDw->(dbAppend())
  fakVysHDw ->culoha     := 'F'
  fakVysHDw ->ctask      := 'FIN'
  fakVysHDw ->ctypDoklad := if( zahranicni, 'FIN_FAKVE', 'FIN_FAKVB')
  fakVysHDw ->ctypPohybu := if( zahranicni, 'FAKVEU'   , 'FAKVBEZ'  )
  fakVysHDw ->cobdobi    := strZero( month( HL ->ODESLANI),2)+"/" +Right( cX, 2)
  fakVysHDw ->nrok       := year ( HL ->ODESLANI )
  fakVysHDw ->nobdobi    := month( HL ->ODESLANI )
  fakVysHDw ->ndoklad    := cisFak
  fakVysHDw ->ncisFak    := cisFak
  fakVysHDw ->cvarSym    := allTrim( StrTran(HL ->CFAKT,'/',''))
  fakVysHDw ->cobdobiDan := fakVysHDw ->cobdobi
  fakVysHDw ->czkrTypFak := if( zahranicni, 'FAKE'     , 'FAKVB'    )
  fakVysHDw ->czkrTypUhr := if( HL ->TYP_UHRADY = 'H', 'Hotovì', ;
                              if( HL ->TYP_UHRADY = 'P', 'PøevP', ;
                                if( HL ->TYP_UHRADY = 'S', 'Složen', 'VèasPl' )))
  fakVysHDw ->nprocDan_1 := 15
  fakVysHDw ->nsazDan_1  := HL ->SUMAD5
  fakVysHDw ->nprocDan_2 := 21
  fakVysHDw ->nzaklDan_2 := HL ->SUMA            // problematické místo pro daò
  fakVysHDw ->nsazDan_2  := HL ->SUMAD23
  fakVysHDw ->ncenZakCel := HL ->SUMAC
  fakVysHDw ->nCENfakCEL := HL ->SUMAC
  fakVysHDw ->nCENfazCEL := HL ->SUMAC
  fakVysHDw ->nCenDanCel := HL ->SUMA
  fakVysHDw ->nZustPoZao := HL ->SUMAC - ( HL ->SUMA +HL ->SUMAD23)
  fakVysHDw ->nKodZaokr  := 32                    ///!!!
  fakVysHDw ->nKodZaokrD := 0                     ///!!!
  fakVysHDw ->cZkratMeny := sysConfig( "Finance:cZaklMena")
  fakVysHDw ->nCenZahCel := HL ->SUMAC
  fakVysHDw ->cZkratMenZ := fakVysHDw ->cZkratMeny
  fakVysHDw ->nKurZahMen := 1
  fakVysHDw ->nMnozPrep  := 1
  fakVysHDw ->nKonstSymb := Val( Left( HL ->KONST, 4))
  fakVysHDw ->nCisFirmy  := HL ->CIS
  fakVysHDw ->cNazev     := HL ->ADR1
  fakVysHDw ->cNazev2    := HL ->JMENOD
  fakVysHDw ->nIco       := Val( Left(HL ->ICOO,8))

  if .not. empty(HL->DICO)
    fakVysHDw ->cDic       := HL ->DICO
    fakvysHDw->cdanDoklad  := str( cisFak )
  else
    if fakVysHDw ->nCENfakCEL >= 10000 .and. fakVysHDw ->nIco > 0
      fakVysHDw ->cDic      := 'CZxxxxxxxx'
      fakvysHDw->cdanDoklad := str( cisFak )
    else
      fakVysHDw ->cDic      := ''
      fakvysHDw->cdanDoklad := ''
    endif
  endif

  fakVysHDw ->cUlice     := HL ->ADR2
  fakVysHDw ->cSidlo     := HL ->ADR3
  fakVysHDw ->cPsc       := HL ->PSCO
  fakVysHDw ->nCisFirDOA := HL ->CIS
  fakVysHDw ->cNazevDOA  := HL ->ADR1
  fakVysHDw ->cUliceDOA  := HL ->ADR2
  fakVysHDw ->cSidloDOA  := HL ->ADR3
  fakVysHDw ->cPscDOA    := HL ->PSCO
  fakVysHDw ->cPrijemce1 := HL ->PRIJEMCE
  fakVysHDw ->cPrijemce2 := HL ->KPRIJEMC
  fakVysHDw ->cZkrZpuDop := HL ->DOPRAVA
  fakVysHDw ->dSplatFak  := HL ->SPLAT
  fakVysHDw ->dVystFak   := HL ->ODESLANI
  fakVysHDw ->dPovinFak  := HL ->POVIN
  if( HL ->VYTISTENO, fakVysHDw ->dDatTisk := Date(), NIL)
  fakVysHDw ->cBank_Uct  := c_bankUc ->cBank_Uct
  fakVysHDw ->cCisObj    := HL ->OBJ
  fakVysHDw ->nCisUzv    := -1
  fakVysHDw ->nProcSlev  := HL ->RABAT * (-1)
  fakVysHDw ->nProcSlFaO := HL ->RABDL * (-1)
  fakVysHDw ->nHodnSlev  := HL ->SUMAS * (-1)
  fakVysHDw ->nCenaZakl  := HL ->SUMA  + fakVysHDw ->nHodnSlev
  fakVysHDw ->cDenik     := sysConfig( "Finance:cDenikFaVy")
  fakVysHDw ->cUcet_Uct  := IF( HL ->DRUH == 3, "324000", if( zahranicni, "311200", "311000"))
  fakVysHDw ->cZkratStat := sysConfig( "System:cZaklStat")
  fakVysHDw ->nFinTyp    := if( HL ->DRUH == 3, 2, 1)
  fakVysHDw->cVYPsazDAN  := sysConfig( "Finance:cVYPsazDPH")


  if .not. firmy->(dbseek( fakVysHDw->ncisFirmy,, 'FIRMY1'))
    firmy ->( dbAppend())
    firmy ->nCisFirmy    := HL ->CIS
    firmy ->cNazev       := HL ->ADR1
    firmy ->nIco         := Val( Left(HL ->ICOO,8))
    firmy ->cDic         := HL ->DICO
    firmy ->cUlice       := HL ->ADR2
    firmy ->cSidlo       := HL ->ADR3
    firmy ->cPsc         := HL ->PSCO
    firmy ->cZkratStat   := SysConfig( "System:cZaklStat")

    firmyFi ->( dbAppend())
    firmyFi ->nCisFirmy  := Firmy ->nCisFirmy
  endif
return .t.


static function PO_to_fakVysITw( nintCount )
  local  procDph := PO ->( fieldGet( 7 ))

  mh_copyFld( 'fakVysHDw', 'fakVysITw', .t. )

  fakVysITw->nintCount    := nintCount
  fakVysITw ->cSklPol     := PO ->KOD
  fakVysITw ->cNazZbo     := PO ->DODAVKA
  fakVysITw ->nCeJPrZBZ   := PO ->CENAJE
  fakVysITw ->nCeJPrKDZ   := fakVysITw ->nCeJPrKBZ +(fakVysITw->nCeJPrKBZ * (procDph/100))
  fakVysITw ->nCeCPrZBZ   := PO ->KCSZ
  fakVysITw ->nCeCPrKBZ   := PO ->KCSCEL_R
  fakVysITw ->nCeCPrKDZ   := PO ->KCSC
  fakVysITw ->nCenJedZak  := fakVysITw ->nCeJPrZBZ
  fakVysITw ->nCenJedZaD  := fakVysITw ->nCeJPrKDZ
  fakVysITw ->nCenZakCel  := fakVysITw ->nCeCPrKBZ
  fakVysITw ->nCenZakCeD  := fakVysITw ->nCeCPrKDZ
  fakVysITw ->nCenZahCel  := 0
  fakVysITw ->nSazDan     := PO ->KCSD
  fakVysITw ->nFaktMnoz   := PO ->MNOZ
  fakVysITw ->cZkratJedn  := PO ->JEDNMN
  fakVysITw ->nKlicDph    := if( procDph = 21,10, 9)
  fakVysITw ->nProcDPH    := procDph
  fakVysITw ->nNAPOCET    := if( procDph = 21, 2, 1)
  fakVysITw ->nNullDPH    := 0
  fakVysITw ->nTypPrep    := 0
  fakVysITw ->nRadVykDph  := if( procDph = 21, 1, 2)
  fakVysITw->lSLUZBA      := .F.
  fakVysITw ->nProcSlev   := PO ->SKLAD
  fakVysITw ->nHodnSlev   := PO ->CENAJE * ( fakVysITw ->nProcSlev/100)
  fakVysITw ->nCenaZakl   := fakVysITw ->nCeCPrKBZ
  fakVysITw ->nCenaZakC   := fakVysITw ->nCeCPrZBZ
  fakVysITw ->nCelkSlev   := PO ->KCSZ -PO ->KCSCEL_R
  fakVysITw ->cUcet       := "604100"
  fakVysITw ->cDenik      := "O"
  fakVysITw ->nKoefMn     := 1
  fakVysITw ->nFaktMnKOE  := 1
return .t.


static function fin_bilancew_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight,ncolor)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()

  default ncolor to GRA_CLR_PALEGRAY

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  GraGradient( ops                 , ;
               { newPos+1,2 }      , ;
               { { nsize, nhight }}, ;
               {ncolor,0,0}, GRA_GRADIENT_HORIZONTAL)

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.