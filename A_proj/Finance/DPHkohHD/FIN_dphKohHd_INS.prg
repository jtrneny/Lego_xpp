#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "adsdbe.ch"
#include "dbstruct.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


// popis v GROUPS(FAKVYSHD:10:FAKVYSIT:1:STRZERO(FAKVYSHD->nCISFAK):DPH2015_FAV()) //
#xtranslate  _mFILE  =>  pA\[ 1\]        //_ základní soubor       _
#xtranslate  _mTAG   =>  Val(pA\[ 2\])   //_                 tag   _
#xtranslate  _sFILE  =>  pA\[ 3\]        //_ spojený soubor        _
#xtranslate  _sTAG   =>  Val(pA\[ 4\])   //_                 tag   _
#xtranslate  _sSCOPE =>  pA\[ 5\]        //_                 scope _
#xtranslate  _mFUNC  =>  pA\[ 6\]        //_ funkce pro zpracování _
#xtranslate  _oPROC  =>  pA\[ 7\]        //_ objekt pro procento   _
#xtranslate  _oTHERM =>  pA\[ 8\]        //_ objekt pro teplomìr   _
#xtranslate  _oSTATE =>  pA\[ 9\]        //_ stav zpracování       _

*
static  hd_File, it_File
static  nprocDan_1, nprocDan_2, nprocDan_3
static  cDenikFAPR                                       // ucetdohd - daòové doklady fakprihd (zz) ucetDohd.cdenik_Par
static  cDENIKFAVY                                       // ucetdohd - daòové doklady fakvyshd (zz) ucetDohd.cdenik_Par
static  nsuma_Dan, pa_oddilRadek


static function FIN_dphKohHD_obd(nrok, is_PO_and_Qdph )
  local  aCOMBO_val := {}, nin

  fOrdRec({'UCETSYS,3'})
  ucetSys ->( dbSetScope( SCOPE_BOTH, 'F' +strZero(nrok,4)), dbGoTop() )

  do while .not. ucetSys->( eof())
    nin := if( is_PO_and_Qdph, 0, ascan( aCOMBO_val, { |x| x[1] = ucetSys->cobdobiDan } ) )

    if nin = 0
      aadd( aCOMBO_val,  { ucetSys->cobdobiDan + '_' +ucetSys->cobdobi          , ;
                           ' ' +left(ucetsys->cobdobiDan,3) +strZero(ucetsys->nrok,4) +' _ obdÚèetní _ ' +left(ucetSys->cobdobi,3) +strZero(ucetSys->nrok,4) , ;
                           { ucetSys->(recNo()) }                               , ;
                           ucetSys->cobdobi                                     , ;
                           left(ucetSys->cobdobi,3) +strZero(ucetSys->nrok,4)   , 0, date()  } )
    endif

    ucetSys->( dbskip())
  enddo

  fOrdRec()
return aCOMBO_val


**
** CLASS for FIN_dphKohHd_INS **************************************************
CLASS FIN_dphKohHd_INS FROM drgUsrClass
EXPORTED:
  var     zprac, dotaz
  var     cobdobi_inf, ctypKONTHL, cidVYZVY, crychODPOV

  method  init, destroy, drgDialogStart, comboBoxInit, comboItemSelected
  method  dph_Insert


  inline method drgDialogEnd(drgDialog)
    dphKoh_iW ->(dbclosearea())
    if( select('dphKohHdW') <> 0, dphKohHdW ->(dbclosearea()), nil )

    ::drgUsrClass:destroy()
  return

HIDDEN:
  var     msg, dm
  var     aEDITs, nrok, nobdobi, obdobiDan, obdobiUc, aobdobi, showDialog
  var     cmb_nastaveni, acmb_values, cmb_typkonthl
  var     is_PO_and_Qdph               // Právnická osoba Ètvrtletní hlášení DPH, ale KOHL každý mìsíc
ENDCLASS


* pøednastavení
*
* ctypKONTHL - B  øádné           , za období není žádné KOHL
*              O  øádné opravné   , je B a date() <= 25.mm.yyyy
*              N  následné        , je B a date() >  25.mm.yyyy
*              E  následné opravné, otherWise
*
METHOD FIN_dphKohHd_INS:init(parent)
  local  aCOMBO_val, cf := "nrok = %% .and. nobdobi = %%", filter, ncnt_idHlaseni
  *
  local  typDANsub := SysConfig('System:cTYPDANSUB')  //  P _ právnická osoba
  local  typVYKdph := sysconfig('FINANCE:nTypVykDPH') //  1 - mìsíèní DPH, 3 - ètvrtletní DPH

  ::drgUsrClass:init(parent)

  ::zprac          := 0
  ::dotaz          := 'Zpracovat daòovou uzávìrku za období _ '
  ::nrok           := parent:parent:udcp:nrok
  *
  ::nobdobi        := uctOBDOBI:FIN:NOBDOBI
  ::showDialog     := .t.
  ::is_PO_and_Qdph := ( upper(typDANsub) = 'P' .and. typVYKdph = 3 )

  ::cobdobi_inf    := ''
  ::ctypKONTHL     := 'B'
  ::cidVYZVY       := ''
  ::crychODPOV     := ''

  * STATIC - sichr
  nprocDan_1       := 15
  nprocDan_2       := 21
  nprocDan_3       := 10
  cDenikFAPR       := SysConfig( 'Finance:cDenikFAPR' )    // ucetdohd - daòové doklady fakprihd (zz) ucetDohd.cdenik_Par
  cDENIKFAVY       := SYSCONFIG( 'FINANCE:cDENIKFAVY' )    // ucetdohd - daòové doklady fakvyshd (zz) ucetDohd.cdenik_Par

  pa_oddilRadek    := { {'A.1', 1, 1 }, {'A.2', 1, 2 }, {'A.3', 1, 3 }, {'A.4', 1, 4 }, {'A.5', 1, 7 }, {'A5i', 1,17 }, ;
                        {'B.1', 1, 5 }, {'B.2', 1, 6 }, {'B.3', 1, 8 }, {'B3i', 1,18 }                                  }

  * SYS
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('C_VYKDPH')

  * DATA
  drgDBMS:open('VYKDPH_I')
  drgDBMS:open('FIRMY'   )

  * TMP
  drgDBMS:open('dphKoh_iW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  * pøednastavíme  B, O, N, E
  aCOMBO_val := FIN_dphKohHD_obd( ::nrok, ::is_PO_and_Qdph )
  ::aobdobi  := aCOMBO_val[1,3]
  ucetsys ->(dbgoto(::aobdobi[1]))

  drgDBMS:open('dphKohHd',,,,,'dphKohHdW')
  *
  ** bacha
  cf_rok := "nrok = %%"
  filter := format( cf_rok, { ::nrok } )
  dphKohHdW->( ads_setAof( filter ), dbgoTop())
  do while .not.  dphKohHdW->( eof())
    nin := ascan( aCOMBO_val, {|x| x[4] = dphKohHdW->cobdobiDan })
    if nin <> 0
      aCOMBO_val[nin,6] += 1
      aCOMBO_val[nin,7] := ctod( '25' +subStr( dtoc(dphKohHdW->dsesDne), 3 ))
    endif
    dphKohHdW->( dbSkip())
  enddo
  dphKohHdW->( ads_clearAof())
  *
  ** období pro zpracování
  nin := ascan(aCOMBO_val, {|x| x[6] = 0 } )
  if nin <> 0
    ::aobdobi := aCOMBO_val[nin,3]
    ucetsys ->(dbgoto(::aobdobi[1]))
    ncnt_idHlaseni := 1
  endif

  ::acmb_values := aCOMBO_val

  do case
  case( ncnt_idHlaseni = 1 )  ; ::ctypKONTHL := 'B'
  case( day(date())   <= 25)  ; ::ctypKONTHL := 'O'
  case( day(date())   >  25)  ; ::ctypKONTHL := 'N'
  otherWise                   ; ::ctypKONTHL := 'E'
  endcase
RETURN self


METHOD FIN_dphKohHd_INS:destroy()
  ::drgUsrClass:destroy()

  ::zprac       := ;
  ::dotaz       := ;
  ::aEDITs      := ;
  ::nrok        := ;
  ::cobdobi_inf := ;
  ::obdobiDan   := ;
  ::obdobiUc    := ;
  ::aobdobi     := NIL
RETURN


METHOD FIN_dphKohHd_INS:drgDialogStart(drgDialog)
  LOCAL  x, pA, members  := drgDialog:oForm:aMembers

  ::aEdits   := {}
  ::msg      := drgDialog:oMessageBar            // messageBar
  ::dm       := drgDialog:dataManager            // dataManager

  FOR x := 1 TO LEN(members)
    IF .not. Empty(members[x]:groups)
      pA  := ListAsArray(members[x]:groups,':')
      nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

      if nin <> 0
        if isNumber(members[x]:oxbp:caption)
          ::aEDITs[nIn,9] := members[x]
        else
          ::aEDITs[nIn,8] := members[x]
        endif
      else
         AAdd(::aEDITs, { pA[1], pA[2], pA[3], pA[4], pA[5], pA[6], members[x], NIL, NIL } )
      endif
    ENDIF
  NEXT

 ::cmb_nastaveni       := ::dm:has('M->FIN_dphKohHd_INS:NASTAVENI'):odrg
 ::cmb_typkonthl       := ::dm:has('M->ctypKontHL'):odrg

 ::cmb_nastaveni:value := (ucetSys->cobdobiDan + '_' +ucetSys->cobdobi)
 ::comboItemSelected(::cmb_nastaveni)
 ::cmb_nastaveni:refresh()

 pa := ::aEDITs
 aeval( pa, { |i| i[9]:oxbp:hide() } )

 if .not. ::showDialog
    ConfirmBox( ,'Je mì líto, ale nelze spustil tuto nabídku, nejsou splnìny podmínky pro zpracování ...', ;
                 'Nelze zpracovat požadavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif
RETURN ::showDialog


METHOD FIN_dphKohHd_INS:comboBoxInit(drgComboBox)
  local  cname := drgParseSecond(drgComboBox:name,'>')
  local  aCOMBO_val

  do case
  case ('NASTAVENI' $ cname )
    aCOMBO_val := ::acmb_values // FIN_dphKohHD_obd( ::nrok, ::is_PO_and_Qdph )

    if len(aCOMBO_val) = 0
      aadd(aCOMBO_val, {'', '', 0})
      ::showDialog := .f.
    endif

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] < aY[1] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    ::obdobiDan   := left( aCOMBO_val[1, 1], 5)
    ::aobdobi     := aCOMBO_val[1, 3]
    ::obdobiUc    := aCOMBO_val[1, 4]
    ::cobdobi_inf := aCOMBO_val[1, 5]

    drgComboBox:value := ::obdobidan
  endcase
RETURN SELF


METHOD FIN_dphKohHd_INS:comboItemSelected(drgComboBox, mp2, o)
  local  cname := drgParseSecond(drgComboBox:name,'>')
  LOCAL     pA := drgComboBox:values, nin
  *
  do case
  case ('NASTAVENI' $ cname )
    nin := ascan( pa, { |x| x[1] = drgComboBox:value } )

    ::obdobiUc    := pa[nin, 4]
    ::cobdobi_inf := pa[nin, 5]
    ::dm:set('M->cobdobi_inf', ::cobdobi_inf )

    ::obdobidan := left( drgComboBox:value, 5 )
    ::aobdobi   := pA[AScan(pA, { |X| X[1] = drgComboBox:value }),3]

    if pa[nin,6] <> 0  // kontrolní hlášení za období již existuje
      ::ctypKONTHL := if( date() <= pa[nin,7], 'O', 'N' )
    else
      ::ctypKONTHL          := 'B'
    endif

    ::cmb_typkonthl:value := ::ctypKONTHL
    ::cmb_typkonthl:refresh()
  endcase
RETURN .T.


method FIN_dphKohHd_INS:dph_Insert()
  local  x, pa, oXbp, nreccnt, nitCnt, nkeycnt, nkeyno, prc, ostate
  local  coddilKohl
  local  oxpb_termCmp := ::msg:msgStatus
  *
  local  isOk
  local  cc    := left( ::obdobiDan,2) +'/' +str(::nrok,4)
  local  ctext := 'Zpracování kontrolního hlášení DPH období _ ' +cc +' _' +CRLF + ;
                  'Závazky, zpracováno %FAKPRIHD záznamù'          +CRLF + ;
                  'Pohledávky, zpracováno %FAKVYSHD záznamù'       +CRLF + ;
                  'Pokladna, zpracováno %POKLADHD záznamù'         +CRLF + ;
                  'Úèetní doklady, zpracováno %UCETDOHD záznamù'   +CRLF + ;
                  'Kasa, zpracováno %POKLHD záznamù'               +CRLF + ;
                  'Daòové období _' +cc+ '_ %zavrend'


  ::ctypKONTHL := ::dm:get('M->ctypKONTHL')
  ::cidVYZVY   := ::dm:get('M->cidVYZVY'  )
  ::crychODPOV := ::dm:get('M->crychODPOV')

  if .t.  // ucetsys ->(sx_RLock(::aobdobi))

    ucetsys ->(dbgoto(::aobdobi[1]))
    vykdph_i->(dbseek(::obdobiDan,,'VYKDPH_3'))

    for x := 1 to len(::aedits) step 1
      pa      := ::aedits[x]
      oxbp    := _oTHERM:oxbp
      ostate  := _oSTATE:oxbp
      nreccnt := 0
      nitcnt  := 0

      drgDBMS:open(_mFILE) ; (_mFILE) ->(AdsSetOrder(_mTAG))
      if( .not. empty(_sfile), (drgDBms:open(_sfile),(_sfile)->(AdsSetOrder(_stag))), nil)

      (_mfile)->(dbsetscope(SCOPE_BOTH,::obdobidan), ;
                 dbgotop()                         , ;
                 dbeval({||nreccnt++})             , ;
                 dbgotop()                           )

      nkeycnt := nreccnt
      nkeyno  := 1

      DO WHILE .not. (_mFILE) ->(Eof())
        hd_file := _mfile
        it_file := ''

        prc := fin_dph_2015_pb(oxbp,nkeycnt,nkeyno,nreccnt)
        _oPROC:oxbp:setcaption(prc)

        if .not. empty(_sFILE)
          it_file := _sFile
          nitcnt  := 0

          if( select(_sFILE) = 0, drgDBms:open(_sFILE), nil)

          (_sFILE)->(AdsSetOrder(_sTAG)               , ;
                     dbsetscope(SCOPE_BOTH,&(_sSCOPE)), ;
                     dbeval({|| nitcnt++})            , ;
                     dbgotop()                          )

          * nemáme položky, musím zpracovat vykDph_i
          if nitcnt = 0
            it_file := ''
          else
            if( isNull( (_sFILE)->sID, 0) = 0 .or. (_sFILE)->( eof()), it_file := '', nil )
          endif
        endif

        * Právnická osoba Ètvrtletní hlášení DPH, ale KOHL každý mìsíc
        if ::is_PO_and_Qdph
          isOk := (hd_file)->cobdobi = ::obdobiUc
        else
          isOk := .t.
        endif

        if( isOk, EVAL( COMPILE(_mFUNC)), nil )
        if( .not. empty(_sFILE), (_sFILE)->(dbclearscope(), dbgoTop()), nil)

        (_mFILE) ->(DbSkip())
        nkeyno++
      ENDDO

      ostate:show()
      ctext := strTran( ctext, '%' +_mFILE, str(nreccnt,10))

      (_mfile) ->(dbclearscope())
    NEXT

    *
    ** pro tisk je potøeba doplnit oddíly, která nemají položky, prázdným záznamem
    for x := 1 to len(pa_oddilRadek) step 1
      coddilKohl := pa_oddilRadek[x,1]

      if coddilKohl = 'A5i' .or. coddilKohl = 'B3i'
      * nic
      else
        if .not. dphKoh_iW->( dbseek( upper(coddilKohl),, 'dphKoh_C'))

          dphKoh_iW->( dbappend())
          *
          ** TAG default value
          dphKoh_iW->coddilKohl := coddilKohl
          dphKoh_iW->cdic       := ''
          dphKoh_iW->cdenik     := ''
          dphKoh_iW->ndoklad    := 0
          dphKoh_iW->cdanDoklad := ''
          dphKoh_iW->dvystFak   := ctod('  .  .  ')
          dphKoh_iW->ctypPreDan := ''

          dphKoh_iW->culoha     := 'F'
          dphKoh_iW->ctask      := 'FIN'
          dphKoh_iW->nradek     := 0
          dphKoh_iW->ntmpSort   := pa_oddilRadek[x,3]
        endif
      endif
    next

    *
    ** uložení a nápoèty do hlavièky
    dphKoh_def( self )

    dphKoh_iW->( ordSetFocus('dphKoh_C'), dbgoTop())

    nreccnt := dphKoh_iW->( lastRec())
    nkeycnt := nrecCnt
    nkeyno  := 1


    do while .not. dphKoh_iW->( eof())
      dphKoh_iW->cidHlaseni := dphKohHd ->cidHlaseni
      dphKoh_iW->ndphKohlHD := isNull(dphKohHd ->sid, 0)

      coddilKohl := dphKoh_iW->coddilKohl

      prc := fin_dph_2015_pb(oxpb_termCmp,nkeycnt,nkeyno,nreccnt)

      do case
      case ( coddilKohl = 'A.2' )
        dphKohhd->nSumDaP313 += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_2 +dphKoh_iW->nZaklDan_3 )

      case ( coddilKohl = 'A.4' .or. coddilKohl = 'A.5' )
        dphKohhd->nSumDaP01  +=   dphKoh_iW->nZaklDan_2
        dphKohhd->nSumDaP02  += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_3 )

      case ( coddilKohl = 'B.2' .or. coddilKohl = 'B.3' )
        dphKohhd->nSumDaP40  +=   dphKoh_iW->nZaklDan_2
        dphKohhd->nSumDaP41  += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_3 )

      case ( coddilKohl = 'A.1' )
        dphKohhd->nSumDaP25  += dphKoh_iW->nzakld_Dph

      case ( coddilKohl = 'B.1' )
        dphKohhd->nSumDaP10  +=   dphKoh_iW->nZaklDan_2
        dphKohhd->nSumDaP11  += ( dphKoh_iW->nZaklDan_1 +dphKoh_iW->nZaklDan_3 )

      endcase

      dphKohIT->( dbappend())
      mh_copyFld( 'dphKoh_iW', 'dphKohIT', .f., .f. )
      dphKohit->( dbcommit())

      dphKoh_iW->( dbskip())
      nkeyno++
    enddo

    dphKohhd->(dbunlock(), dbcommit())
    dphKohit->(dbunlock(), dbcommit())

*/

*    ctext := strTran( ctext, '%zavrend', if( .not. ucetsys->lzavrend, 'OTEVØENO', 'UZAVØENO') )
*    mh_wrtZmena( 'ucetSys',,, ctext )

*     UCETSYS ->( DbUnLock())

**    sleep(150)
    PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
  endif
return .t.



*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
**
static function dphKoh_def(odialog)                        //__PØEDNASAVENÍ dpKoh_2016
  local          cC := SysConfig( 'SYSTEM:cZastupce'), ac
  local  ntypvykDph := sysconfig( 'FINANCE:nTypVykDPH')
  local  cf := "nrok = %% .and. nobdobi = %%", filter, ncnt_idHlaseni := 1

  drgDBMS:open('dphKohHd',,,,,'dphKohHdW')
  dphKohHdW->(AdsSetOrder('DPHDATA'),dbgobottom())

  aC := { dphKohHdW ->cFinURAD      , ;
          dphKohHdW ->cRC           , ;
          dphKohHdW ->cPD           , ;
          dphKohHdW ->cIO           , ;
          dphKohHdW ->cSK           , ;
          dphKohHdW ->cND           , ;
          dphKohHdW ->cNU           , ;
          dphKohHdW ->cFyzOsPRIJ    , ;
          dphKohHdW ->cFyzOsJMEN    , ;
          dphKohHdW ->cCP           , ;
          dphKohHdW ->cCINNOST1     , ;
          dphKohHdW ->cOdpOsPOST      }

  filter := format( cf, { UcetSYS->nRok, ucetsys->nobdobi } )
  dphKohHdW->( ads_setAof( filter ), dbgoTop())
  ncnt_idHlaseni := dphKohHdW->( Ads_GetRecordCount()) +1

  dphKohHdW->(dbclosearea())

  dphKohHd ->( DbAppend(), RLock())
     dphKohHd ->cUloha     := 'F'
     dphKohHd ->cidHlaseni := strZero(ucetSys->nrokObd,6) +'.' +allTrim( str(ncnt_idHlaseni))

     dphKohHd ->cFinURAD   := aC[ 1]
     dphKohHd ->cDIC       := SysConfig( 'SYSTEM:cDIC' )
     dphKohHd ->cRC        := aC[ 2]

     dphKohHd ->ctypKONTHL := odialog:ctypKONTHL
     do case
     case ( odialog:ctypKONTHL = 'B' )    // B:øádné
       dphKohHd ->cRP := 'x'

     case ( odialog:ctypKONTHL = 'O' )    // O:øádné opravné
       dphKohHd ->cRP := 'x'
       dphKohHd ->cOP := 'x'

     case ( odialog:ctypKONTHL = 'N' )    // N:následné
       dphKohHd ->cRP := 'x'
       dphKohHd ->cDP := 'x'

     case ( odialog:ctypKONTHL = 'E' )    // E:následné opravné
       dphKohHd ->cDP := 'x'
       dphKohHd ->cOP := 'x'
     endcase

     dphKohHd ->cidVYZVY   := odialog:cidVYZVY
     dphKohHd ->crychODPOV := odialog:crychODPOV


     if ntypVykDph = 1
       dphKohHd ->nM         := UcetSYS ->nObdobi
     else
       dphKohHd ->nQ         := mh_CTVRTzOBDn(ucetsys->nobdobi)
     endif

     dphKohHd->nPROCdan_1  := nPROCdan_1
     dphKohHd->nPROCdan_2  := nPROCdan_2
     dphKohHd->nPROCdan_3  := nPROCdan_3

     dphKohHd->nPracUFO    := SysConfig( 'SYSTEM:nFINURAD')
     dphKohHd->nUFO        := SysConfig( 'SYSTEM:nFINURKRAJ')
     dphKohHd->cTypDanSub  := SysConfig( 'SYSTEM:cTYPDANSUB')

     dphKohHd ->nRok       := UcetSYS ->nRok
     dphKohHd ->nOBDOBI    := ucetsys ->nobdobi
     dphKohHd ->dOD        := ctod(' .  .  ')
     dphKohHd ->dDO        := ctod(' .  .  ')
     dphKohHd ->cPD        := aC[ 3]
     dphKohHd ->cIO        := aC[ 4]
     dphKohHd ->cSK        := aC[ 5]
     dphKohHd ->cND        := aC[ 6]
     dphKohHd ->cNU        := ''    // :='X'  oprava JT 25.2.2014
     dphKohHd ->cPraOsNAZ  := SysConfig( 'SYSTEM:cPodnik')
     dphKohHd ->cPraOsDOP  := SysConfig( 'SYSTEM:cPodnik2')
     dphKohHd ->cFyzOsPRIJ := SysConfig( 'SYSTEM:cFyzOsPRIJ' )
     dphKohHd ->cFyzOsJMEN := SysConfig( 'SYSTEM:cFyzOsJMEN' )
     dphKohHd ->cSIDLO     := SysConfig( 'SYSTEM:cSidlo')
     dphKohHd ->cPSC       := AllTrim(StrTran(SysConfig( 'SYSTEM:cPSC'  ),' ',''))
     dphKohHd ->cULICE     := SysConfig( 'SYSTEM:cUliceORG' )
     dphKohHd ->cCP        := SysConfig( 'SYSTEM:ccisPopORG')
     dphKohHd ->cTELEFON   := AllTrim(Left( SysConfig( 'SYSTEM:cTelefon'), 17))
     dphKohHd ->cMAIL      := SysConfig( 'SYSTEM:cPathEmail')
     dphKohHd ->cSTAT      := AllTrim( SysConfig( 'FINANCE:cZkrStatKH'))
     dphKohHd ->cCINNOST1  := SysConfig( 'SYSTEM:cCinnost1'  )
     dphKohHd ->cOdpOsPRIJ := SysConfig( 'SYSTEM:cOdpOsPrij' )
     dphKohHd ->cOdpOsJMEN := SysConfig( 'SYSTEM:cOdpOsJmen' )
     dphKohHd ->cOdpOsPOST := SysConfig( 'SYSTEM:cOdpOsPost' )
     dphKohHd ->dSesDNE    := Date()
     dphKohHd ->cSesJMENO  := logOsoba
     dphKohHd ->cSesTELEF  := AllTrim(Left( SysConfig( 'SYSTEM:cTelefon'), 17))
     dphKohHd ->cObdobiDAN := UcetSYS ->cObdobiDAN
     dphKohHd ->cIdDatSchr := AllTrim( SysConfig( 'FINANCE:cIDDatShKH'))
     *
     dphKohHd ->cRP        := 'X'
return nil


*
** ZPRACOVÁNÍ vstupních DAT ****************************************************
**  ncenFakCel
FUNCTION dphKoh_fap()                          //__FAKTURY PØIJATÉ______________

  If (FAKPRIHD ->nFINtyp == 1 .or. FAKPRIHD ->nFINtyp == 2 .or. FAKPRIHD ->nFINtyp == 6) .and. !FAKPRIHD ->lNo_InDPH
    dphKoh_sco( 'FAKPRIHD' )

    nsuma_Dan := abs(fakPrihd->ncenZAKcel)

    Do While !VYKDPH_I ->( EOF())
      dphKoh_rvs( FakPriHd->dvystFak )
      *
      vykdph_i->(dbSkip())
    EndDo

    dphKoh_sco()
  EndIf
RETURN NIL


function dphKoh_fav()                          //__FAKTURY VYSTAVENÉ ___________
  local nsuma_Daz := (fakVyshd->nZAKLdaz_1 +fakVyshd->nSAZdaz_1 + ;
                      fakVyshd->nZAKLdaz_2 +fakVyshd->nSAZdaz_2 + ;
                      fakVyshd->nZAKLdaz_3 +fakVyshd->nSAZdaz_3   )

  if (FAKVYSHD ->nFINtyp <> 2 .and. FAKVYSHD ->nFINtyp <> 4) .and. !FAKVYSHD ->lNo_InDPH
    dphKoh_sco( 'FAKVYSHD' )

    nsuma_Dan := abs(fakVyshd->ncenZAKcel)

    if fakVyshd->nparZALfak <> 0
      nsuma_Dan := abs( if( nsuma_Daz = 0, fakVyshd->ncenFAKcel, fakVyshd->ncenZAKcel ))
    endif


    do while .not. vykdph_i->(eof())
      dphKoh_rvs( FakVysHd->dpovinFak )
      *
      vykdph_i->(dbSkip())
    enddo

    dphKoh_sco()
  endif
return nil


FUNCTION dphKoh_pof()                          //__ POKLADNA FINANCE ___________

  IF (POKLADHD ->nZAKLdan_1 +POKLADHD ->nZAKLdan_2 +POKLADHD ->nZAKLdan_3 +POKLADHD ->nOSVODDAN) <> 0
    dphKoh_sco( 'POKLADHD' )

    nsuma_Dan := pokladhd->ncenCEL_hd

    DO WHILE .not. VYKDPH_I ->( Eof())
      dphKoh_rvs( PokladHd->dvystDok )
      *
      vykdph_i->(dbSkip())
    EndDo

    dphKoh_sco()
  ENDIF
RETURN NIL


FUNCTION dphKoh_ucd()                          //__ ÚÈETNÍ DOKLAD ______________
  local  cdenik_par := ucetDohd->cdenik_par

  IF ( UCETDOHD ->nZAKLdan_1 +UCETDOHD ->nSAZdan_1 + ;
       UCETDOHD ->nZAKLdan_2 +UCETDOHD ->nSAZdan_2 + ;
       UCETDOHD ->nZAKLdan_3 +UCETDOHD ->nSAZdan_3 + ;
       UCETDOHD ->nOSVodDAN  +UCETDOHD ->nNULLdph ) <> 0

    dphKoh_sco( 'UCETDOHD' )

    * sichr
    nsuma_Dan := 0

    do case
    case empty( cdenik_par )
      nsuma_Dan := ucetDohd->ncenZAKcel

    case ( cdenik_par = cDenikFAPR )          // ucetdohd - daòové doklady fakprihd (zz) ucetDohd.cdenik_Par
      fakPrihd->( dbseek( ucetDohd->ncisFak,, 'FPRIHD1'))
      nsuma_Dan := abs(fakPrihd->ncenZAKcel)

    case ( cdenik_par = cDENIKFAVY )           // ucetdohd - daòové doklady fakvyshd (zz) ucetDohd.cdenik_Par
      fakVyshd->( dbseek( ucetDohd->ncisFak,, 'FODBHD1'))
      nsuma_Dan := abs(fakVyshd->ncenZAKcel)

    endcase


    DO WHILE .not. VYKDPH_I ->( EOF())
      dphKoh_rvs( UcetDoHd->dvystDok )
      *
      vykdph_i->(dbSkip())
    ENDDO

    dphKoh_sco()
  ENDIF
RETURN NIL


function dphKoh_pop()                          //__ POKLADNA PRODEJ ____________

  IF SysConfig('FINANCE:lKASADPHex')
    dphKoh_sco( 'POKLHD' )

    nsuma_Dan := poklhd->ncenZAKcel

    do while .not. vykdph_i->(eof())
      dphKoh_rvs( PoklHd->dpovinFak )
      *
      vykdph_i->(dbSkip())
    enddo

    dphKoh_sco()
  endif
return nil


static function dphKoh_sco(cfile)
  local  cKy

  nsuma_Dan := 0

  if IsNIL(cfile)
    vykdph_i ->( DbClearScope(), DbGoTop() )
  else
    cKy := Upper( DBGetVal( cFILE +'->cDENIK' )) +StrZero( DBGetVal( cFILE +'->nDOKLAD'),10)
    vykdph_i ->( dbSetScope(SCOPE_BOTH,cKy)                                                , ;
                 dbGoTop()                                                                 , ;
                 dbeval( { || nsuma_Dan += (vykdph_i->nzakld_Dph +vykdph_i->nsazba_Dph) } ), ;
                 dbgoTop()                                                                   )
  endif
return nil

*
** zpracování kontrolního hlášení
**
static function dphKoh_rvs( dvystFak )
  local  cky := strZero(vykDph_i->noddil_Dph,2) +strZero(vykDph_i->nradek_Dph,3) +strZero(vykDph_i->ndat_OD,8)
  local  mky
  local  coddilKohl, pa, x, cc
  *
  local  cdic       := upper( if((hd_file)->(fieldPos('cdic'))       = 0,                           space(16), (hd_file)->cdic       ))
  local  cdenik     := (hd_file)->cdenik
  local  ndoklad    := (hd_file)->ndoklad
  local  cdanDoklad := upper( if((hd_file)->(fieldPos('cdanDoklad')) = 0, allTrim(str((hd_file)->ndoklad,10)), (hd_file)->cdanDoklad ))
  local  ctypPreDan
  local  czaklDan, csazDan
  local  nnapocet

  c_vykDph->( dbseek( cky,,'VYKDPH4'))

  if .not. empty(coddilKohl := vykDph_i->coddilKohl)
    cc := allTrim(coddilKohl)

    do case
    case ( cc = 'A.4' )  ;  nsuma_Dan := 10001
    case ( cc = 'A.5' )  ;  nsuma_Dan := 1
    case ( cc = 'B.2' )  ;  nsuma_Dan := 10001
    case ( cc = 'B.3' )  ;  nsuma_Dan := 1
    endcase

  else
    if empty(coddilKohl := c_vykDph->coddilKohl)
      return .t.
    endif
  endif

  pa := listAsArray( allTrim(coddilKohl))

  for x := 1 to len(pa) step 1
    coddilKohl := upper(pa[x])
           mky := coddilKohl +cdic +padR(cdanDoklad,66)

      nnapocet := vykDph_i->ntyp_Dph
      czaklDan := 'nzaklDan_' +str(nnapocet,1)
      csazDan  := 'nsazDan_'  +str(nnapocet,1)

    * pokud doklad nemá cdic a cdanDoklad jde do sumárních odílù
    do case
    case( coddilKohl = 'A.5' .or. coddilKohl = 'B.3' )
    otherwise
      if( empty(cdic) .and. empty(cdanDoklad) )
        coddilKohl := if( left( upper(pa[x]), 1) = 'A', 'A.5', 'B.3' )
         nsuma_Dan := 1
               mky := coddilKohl +cdic +padR(cdanDoklad,66)
               pa  := { coddilKohl }
      endif
    endcase


    do case
    case ( coddilKohl = 'A.1' )

      if .not. empty(it_file)
        (it_file)->( dbgoTop())

        do while .not. (it_file)->( eof())
          if vykdph_i->nradek_dph = (it_file)->nradVykDph

            if dphKoh_iW->( dbseek( mky +upper( (it_file)->ctypPreDan),, 'dphKoh_C' ))
              dphKoh_iW->nzakld_Dph += (it_file)->ncenZakCel

            else
              aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)

              dphKoh_iW->nzakld_Dph := (it_file)->ncenZakCel
              dphKoh_iW->ctypPreDan := (it_file)->ctypPreDan
** ??              dphKoh_iW->nkodPlneni := (it_file)->ntypPreDan
            endif
          endif

          (it_file)->( dbskip())
        enddo
      else
        if dphKoh_iW->( dbseek( mky +upper( vykDph_i->ctypPreDan),, 'dphKoh_C' ))
          dphKoh_iW->nzakld_Dph += vykDph_i->nzakld_Dph

        else
          aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)

          dphKoh_iW->nzakld_Dph := vykDph_i->nzakld_Dph
          dphKoh_iW->ctypPreDan := vykDph_i->ctypPreDan
** ??          dphKoh_iW->nkodPlneni := vykDph_i->ntypPreDan
        endif
      endif

    case ( coddilKohl = 'A.2' )

      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_C' ))
        aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)
      endif

      dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
      dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph

    case ( coddilKohl = 'A.3' )

      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_C' ))
         aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)
       endif

       dphKoh_iW->nosvOdDan  += vykDph_i->nzakld_Dph

    case ( coddilKohl = 'A.4' .and. nsuma_Dan > 10000 )

      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_C' ))
        aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)
      endif

      dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
      dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph

    case ( coddilKohl = 'A.5' .and. nsuma_Dan <= 10000 )
      mky      := coddilKohl

      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_C' ))
         aaddRec_and_doplnFirmu(coddilKohl)
      endif

      dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
      dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph

      * položky
      mky := 'A5i' +upper(cdenik) +strZero(ndoklad,10)
      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_B' ))
         aaddRec_and_doplnFirmu('A5i', cdic, ndoklad, cdanDoklad, dvystFak)
      endif

      dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
      dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph

    case ( coddilKohl = 'B.1' )

      if .not. empty(it_file)
        (it_file)->( dbgoTop())

        do while .not. (it_file)->( eof())
          if vykdph_i->nradek_dph = (it_file)->nradVykDph

            nnapocet := (it_file)->nnapocet
            czaklDan := 'nzaklDan_' +str(nnapocet,1)
            csazDan  := 'nsazDan_'  +str(nnapocet,1)

            if dphKoh_iW->( dbseek( mky +upper( (it_file)->ctypPreDan),, 'dphKoh_C' ) )
              dphKoh_iW->&czaklDan  += (it_file)->ncenZakCel
              dphKoh_iW->&csazDan   += (it_file)->nsazDan

            else
              aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)

              dphKoh_iW->ctypPreDan := (it_file)->ctypPreDan
** ??              dphKoh_iW->nkodPlneni := (it_file)->ntypPreDan

              dphKoh_iW->&czaklDan  := (it_file)->ncenZakCel
              dphKoh_iW->&csazDan   := (it_file)->nsazDan
            endif
          endif

          (it_file)->( dbskip())
        enddo
      else

        if dphKoh_iW->( dbseek( mky +upper( vykDph_i->ctypPreDan),, 'dphKoh_C' ) )
          dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
          dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph

        else
          aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)

          dphKoh_iW->ctypPreDan := vykDph_i->ctypPreDan
** ??          dphKoh_iW->nkodPlneni := vykDph_i->ntypPreDan

          dphKoh_iW->&czaklDan  := vykDph_i->nzakld_Dph
          dphKoh_iW->&csazDan   := vykDph_i->nsazba_Dph
        endif
      endif

    case ( coddilKohl = 'B.2' .and. nsuma_Dan > 10000 )

      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_C' ))
        aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)
      endif

      dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
      dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph

    case ( coddilKohl = 'B.3' .and. nsuma_Dan <= 10000 )
      mky      := coddilKohl

      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_C' ))
         aaddRec_and_doplnFirmu(coddilKohl)
      endif

      dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
      dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph

      * položky
      mky := 'B3i' +upper(cdenik) +strZero(ndoklad,10)
      if .not. dphKoh_iW->( dbseek( mky,, 'dphKoh_B' ))
         aaddRec_and_doplnFirmu('B3i', cdic, ndoklad, cdanDoklad, dvystFak)
      endif

      dphKoh_iW->&czaklDan  += vykDph_i->nzakld_Dph
      dphKoh_iW->&csazDan   += vykDph_i->nsazba_Dph
    endcase

    dphKoh_iW->(dbcommit())
  next
return .t.


static function aaddRec_and_doplnFirmu(coddilKohl, cdic, ndoklad, cdanDoklad, dvystFak)
  local  npos, nradek := 1, ntmpSort := 1

  default cdic to '', ndoklad to 0, cdanDoklad to '', dvystFak to ctod('  .  .  ')


  if( npos := ascan( pa_oddilRadek, { |x| x[1] = coddilKohl } )) <> 0
    nradek   := pa_oddilRadek[npos,2]
    ntmpSort := pa_oddilRadek[npos,3]

    pa_oddilRadek[npos,2] += 1
  endif

  dphKoh_iW->( dbappend())
  *
  ** static
  nPROCdan_1 := (hd_file)->nPROCdan_1
  nPROCdan_2 := (hd_file)->nPROCdan_2
  nPROCdan_3 := (hd_file)->nPROCdan_3

  *
  ** TAG default value
  dphKoh_iW->coddilKohl := coddilKohl
  dphKoh_iW->cdic       := cdic
  dphKoh_iW->cdicZakl   := dicZakl( cdic )
  dphKoh_iW->cDicStaKod := Left( cdic, 2)
  dphKoh_iW->cdenik     := (hd_file)->cdenik
  dphKoh_iW->ndoklad    := ndoklad
  dphKoh_iW->cdanDoklad := cdanDoklad
  dphKoh_iW->dvystFak   := dvystFak
  dphKoh_iW->ctypPreDan := ''

  dphKoh_iW->culoha     := 'F'
  dphKoh_iW->ctask      := 'FIN'
  dphKoh_iW->nradek     := nradek
  dphKoh_iW->ntmpSort   := ntmpSort

  dphKoh_iW->cTABLEmain := upper(hd_file)
  dphKoh_iW->nSIDmain   := isNull( (hd_file)->sID, 0)


  if (hd_file)->(fieldPos('ncisFirmy')) <> 0

    if firmy->( dbseek( (hd_file)->ncisFirmy,,'FIRMY1'))
      dphKoh_iW->nCisFirmy  := firmy->nCisFirmy
      dphKoh_iW->cNazev     := firmy->cNazev
      dphKoh_iW->cNazev2    := firmy->cNazev
      dphKoh_iW->nIco       := firmy->nIco
      dphKoh_iW->cUlice     := firmy->cUlice
      dphKoh_iW->cCisPopis  := firmy->cCisPopis
      dphKoh_iW->cCisOrien  := firmy->cCisOrien
      dphKoh_iW->cUlicCisla := firmy->cUlicCisla
      dphKoh_iW->cObec      := firmy->cObec
      dphKoh_iW->cSidlo     := firmy->cSidlo
      dphKoh_iW->cPsc       := firmy->cPsc

      dphKoh_iW->cadresa    := firmy->csidlo +', ' +firmy->culice +', ' +firmy->cpsc
    endif
  endif
return .t.


static function dicZakl( cdic )
  local x, cc, cdicZakl := ''

  for x := 1 to len(cdic) step 1
          cc := substr( cdic, x, 1)
    cdicZakl += if( val(cc) <> 0 .or. cc = '0', cc, '' )
  next
return cdicZakl