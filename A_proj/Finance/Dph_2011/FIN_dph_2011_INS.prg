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


// popis v GROUPS(FAKVYSHD:10:FAKVYSIT:1:STRZERO(FAKVYSHD->nCISFAK):DPH2011_FAV()) //
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
static  nr_051pz
// od 1.4.2011 do tìchto øádkù jsou souèovány øádky kde
// npreDanPov = 1
static  sum_nR043z, sum_nR043d, sum_nR043r
static  sum_nR044z, sum_nR044d, sum_nR044r


**
** CLASS for FIN_dph_2011_INS **************************************************
CLASS FIN_dph_2011_INS FROM drgUsrClass
EXPORTED:
  var     zprac, dotaz

  method  init, destroy, drgDialogStart, comboBoxInit, comboItemSelected
  method  dph_Insert

HIDDEN:
  var     aEDITs, nrok, obdobidan, aobdobi, showDialog
ENDCLASS


METHOD FIN_dph_2011_INS:init(parent)
  ::drgUsrClass:init(parent)

  ::zprac      := 0
  ::dotaz      := 'Zpracovat daòovou uzávìrku za období _ '
  ::nrok       := parent:parent:udcp:nrok
  ::showDialog := .t.

  * SYS
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('C_VYKDPH')

  * DATA
  drgDBMS:open('PRIJATPL')
  drgDBMS:open('USKUTPL' )
  drgDBMS:open('VYKDPH_I')

  * TMP
  drgDBMS:open('DPH2011s',.T.,.T.,drgINI:dir_USERfitm); ZAP
  DPH2011s ->(DbAppend())
RETURN self


METHOD FIN_dph_2011_INS:destroy()
  ::drgUsrClass:destroy()

  ::zprac     := ;
  ::dotaz     := ;
  ::aEDITs    := ;
  ::nrok      := ;
  ::obdobidan := ;
  ::aobdobi   := NIL

  DPH2011s ->(DbCloseArea())
RETURN

METHOD FIN_dph_2011_INS:drgDialogStart(drgDialog)
  LOCAL x, pA, members  := drgDialog:oForm:aMembers

  ::aEdits   := {}

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

  pa := ::aEDITs
  aeval( pa, { |i| i[9]:oxbp:hide() } )

 if .not. ::showDialog
    ConfirmBox( ,'Je mì líto, ale nelze spustil tuto nabídku, nejsou splnìny podmínky pro zpracování ...', ;
                 'Nelze zpracovat požadavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif
RETURN ::showDialog


METHOD FIN_dph_2011_INS:comboBoxInit(drgComboBox)
  LOCAL  aCOMBO_val := FIN_dph_2011_obd(::nrok, .T.)

  if len(aCOMBO_val) = 0
    aadd(aCOMBO_val, {'', '', 0})
    ::showDialog := .f.
  endif

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] < aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  ::obdobidan := aCOMBO_val[1,1]
  ::aobdobi   := aCOMBO_val[1,3]
  drgComboBox:value := ::obdobidan
RETURN SELF


METHOD FIN_dph_2011_INS:comboItemSelected(mp1, mp2, o)
  LOCAL  pA := mp1:values

  IF ::obdobidan <> mp1:value
    ::obdobidan := mp1:value
    ::aobdobi   := pA[AScan(pA, { |X| X[1] = mp1:value }),3]
  ENDIF
RETURN .T.


method FIN_dph_2011_INS:dph_Insert()
  local x, pa, oXbp, nreccnt, nkeycnt, nkeyno, prc, ostate
  *
  local  cc    := left( ::obdobiDan,2) +'/' +str(::nrok,4)
  local  ctext := 'Zpracování daòové uzávìrky období _ ' +cc +' _' +CRLF + ;
                  'Závazky, zpracováno %FAKPRIHD záznamù'          +CRLF + ;
                  'Pohledávky, zpracováno %FAKVYSHD záznamù'       +CRLF + ;
                  'Pokladna, zpracováno %POKLADHD záznamù'         +CRLF + ;
                  'Úèetní doklady, zpracováno %UCETDOHD záznamù'   +CRLF + ;
                  'Kasa, zpracováno %POKLHD záznamù'               +CRLF + ;
                  'Daòové období _' +cc+ '_ %zavrend'

  nr_051pz   := 0
  sum_nR043z := sum_nR043d := sum_nR043r := 0
  sum_nR044z := sum_nR044d := sum_nR044r := 0

  if ucetsys ->(sx_RLock(::aobdobi)) .and. prijatpl->(flock()) .and. uskutpl->(flock())

    ucetsys ->(dbgoto(::aobdobi[1]))
    vykdph_i->(dbseek(::obdobiDan,,'VYKDPH_3'))
    D2011_def()

    for x := 1 to len(::aedits) step 1
      pa      := ::aedits[x]
      oxbp    := _oTHERM:oxbp
      ostate  := _oSTATE:oxbp
      nreccnt := 0

      drgDBMS:open(_mFILE) ; (_mFILE) ->(AdsSetOrder(_mTAG))
      if( .not. empty(_sfile), (drgDBms:open(_sfile),(_sfile)->(AdsSetOrder(_stag))), nil)

      (_mfile)->(dbsetscope(SCOPE_BOTH,::obdobidan), ;
                 dbgotop()                         , ;
                 dbeval({||nreccnt++})             , ;
                 dbgotop()                           )

      nkeycnt := nreccnt // / round(oxbp:currentSize()[1]/(drgINI:fontH -6),0)
      nkeyno  := 1

      DO WHILE .not. (_mFILE) ->(Eof())
        prc := fin_dph_2011_pb(oxbp,nkeycnt,nkeyno,nreccnt)
        _oPROC:oxbp:setcaption(prc)

        if .not. empty(_sFILE)
           if( select(_sFILE) = 0, drgDBms:open(_sFILE), nil)
           (_sFILE)->(AdsSetOrder(_sTAG)               , ;
                      dbsetscope(SCOPE_BOTH,&(_sSCOPE)), ;
                      dbgotop()                          )
        endif

        EVAL( COMPILE(_mFUNC))
        if( .not. empty(_sFILE), (_sFILE)->(dbclearscope()), nil)

        (_mFILE) ->(DbSkip())
        nkeyno++
      ENDDO

      ostate:show()
      ctext := strTran( ctext, '%' +_mFILE, str(nreccnt,10))

      (_mfile) ->(dbclearscope())

      dph2011s->(dbCommit())
    NEXT

    D2011_cmp(::aobdobi)

    ctext := strTran( ctext, '%zavrend', if( .not. ucetsys->lzavrend, 'OTEVØENO', 'UZAVØENO') )
    mh_wrtZmena( 'ucetSys',,, ctext )

     UCETSYS ->( DbUnLock())
      PRIJATPL ->( DbUnLock())
       USKUTPL  ->( DbUnLock())

    sleep(150)
    PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
  endif
return .t.



**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
STATIC FUNCTION D2011_rvs(nRV,nTYP)
  local  cC := '.T.'
  local  aX :=  ;
{ 'DPH2011s ->nR.z  := DPH2011s ->nR.z   +VYKDPH_I ->nZAKLD_dph, ' + ;
  'DPH2011s ->nR.d  := DPH2011s ->nR.d   +VYKDPH_I ->nSAZBA_dph'                               , ;
  'DPH2011s ->nR.p  := DPH2011s ->nR.p   +VYKDPH_I ->nZAKLD_dph'                               , ;
  'DPH2011s ->nR.z  := DPH2011s ->nR.z   +VYKDPH_I ->nZAKLD_dph, ' + ;
  'DPH2011s ->nR.d  := DPH2011s ->nR.d   +(VYKDPH_I ->nSAZBA_dph -VYKDPH_I ->nKRACE_nar), ' + ;
  'DPH2011s ->nR.r  := DPH2011s ->nR.r   +VYKDPH_I ->nKRACE_nar'                            , ;
  'DPH2011s ->nR.p  := DPH2011s ->nR.p   +VYKDPH_I ->nZAKLD_dph'                                 }

  *
  ** pøenesená daòová povinnost od 1.4.2011

// 28.7.2011
  if vykdph_i ->lpreDanPov .and. vykdph_i ->npreDanPov = 0
    if      vykdph_i->ntyp_Dph = 2          // základní sazba do 43
      sum_nR043z += VYKDPH_I ->nZAKLD_dph
      sum_nR043d += VYKDPH_I ->nSAZBA_dph
*      sum_nR043r += VYKDPH_I ->nKRACE_nar

    elseif  vykdph_i->ntyp_Dph = 1          // snížená  sazba do 44
      sum_nR044z += VYKDPH_I ->nZAKLD_dph
      sum_nR044d += VYKDPH_I ->nSAZBA_dph
*      sum_nR044r += VYKDPH_I ->nKRACE_nar

    endif
  endif


  if vykdph_i ->npreDanPov = 1
    if      vykdph_i->ntyp_Dph = 2          // základní sazba do 43
*      sum_nR043z += VYKDPH_I ->nZAKLD_dph
*      sum_nR043d += VYKDPH_I ->nSAZBA_dph
      sum_nR043r += VYKDPH_I ->nKRACE_nar

    elseif  vykdph_i->ntyp_Dph = 1          // snížená  sazba do 44
*      sum_nR044z += VYKDPH_I ->nZAKLD_dph
*      sum_nR044d += VYKDPH_I ->nSAZBA_dph
      sum_nR044r += VYKDPH_I ->nKRACE_nar

    endif
  endif


  do case
* 1 - I Zdanitelné plnìní
  case( nRv >=  1 .and. nRV <= 13 )
    cC := STRTRAN(aX[1], '.', strZero(nRV,3))

  case( nRv  = 101)
    cC       := STRTRAN(aX[1], '.', '001')
    nr_051pz += +VYKDPH_I ->nZAKLD_dph

  case( nRv  = 102)
    cC       := STRTRAN(aX[1], '.', '002')
    nr_051pz += +VYKDPH_I ->nZAKLD_dph

  case( nRv = 107)                              // 7 a 42
    cC       := STRTRAN(aX[1], '.', '007') +',' +STRTRAN(aX[1],'.', '042')

  case( nRv = 108)                              // 8 - 43
    cC       := STRTRAN(aX[1], '.', '008') +',' +STRTRAN(aX[1],'.', '042')


* 2 - II Ostatní plnìní s místem plnìní mimo tutemsko ...
  case( nRv >= 20 .and. nRV <= 26 )
    cC := STRTRAN(aX[2], '.', strZero(nRV,3))

  case( nRv >= 220 .and. nRv <= 226)            // pomocne RV 220..225 -> 22..25
    cRv      := '0' +right( str( nRv,3), 2)
    cC       := STRTRAN(aX[2], '.', cRv)
    nr_051pz += VYKDPH_I ->nZAKLD_dph

* 3 - III Doplòující údaje
  case( nRv = 30 )
    cC := 'DPH2011s ->nR030p := DPH2011s ->nR030p +VYKDPH_I ->nZAKLD_dph'

  case( nRv = 31 )
    cC := 'DPH2011s ->nR031p := DPH2011s ->nR031p +VYKDPH_I ->nZAKLD_dph'

  case( nRv = 32 )
    cC := 'DPH2011s ->nR032p := DPH2011s ->nR032p +VYKDPH_I ->nZAKLD_dph'

  case( nRv = 33 )
    cC := 'DPH2011s ->nR033d := DPH2011s ->nR033d +VYKDPH_I ->nSAZBA_dph'

  case( nRv = 34 )
    cC := 'DPH2011s ->nR034d := DPH2011s ->nR034d +VYKDPH_I ->nSAZBA_dph'

* 4 - IV Doplòující údaje
  case( nRv >= 40 .and. nRV <= 47 )
    cC := STRTRAN(aX[3], '.', strZero(nRV,3))

  case( nRv = 400)                              // 40 a 47
    cC := STRTRAN(aX[3], '.', '040') +',' +STRTRAN(aX[3],'.', '047')

  case( nRv = 410)                              // 41 a 47
    cC := STRTRAN(aX[3], '.', '041') +',' +STRTRAN(aX[3],'.', '047')

* 5 - V Krácení nároku na odpoèet danì
  case( nRv  = 50 )
    cC := STRTRAN(aX[4], '.', strZero(nRV,3))

  case( nRv = 500 )                             // 50 a 51b
    cC := 'DPH2011s ->nR050p := DPH2011s ->nR050p +VYKDPH_I ->nZAKLD_dph, ' + ;
          'DPH2011s ->nR051b := DPH2011s ->nR051b +VYKDPH_I ->nZAKLD_dph'

// INSOLVENCE
  case( nRv = 133 )
    cC := 'DPH2011s ->nR001d := DPH2011s ->nR001d -VYKDPH_I ->nSAZBA_dph, ' + ;
          'DPH2011s ->nR033d := DPH2011s ->nR033d +VYKDPH_I ->nSAZBA_dph'

  case( nRv = 233 )
    cC := 'DPH2011s ->nR002d := DPH2011s ->nR002d -VYKDPH_I ->nSAZBA_dph, ' + ;
          'DPH2011s ->nR033d := DPH2011s ->nR033d +VYKDPH_I ->nSAZBA_dph'

  case( nRv = 134 )
    cC := 'DPH2011s ->nR001d := DPH2011s ->nR001d +VYKDPH_I ->nSAZBA_dph, ' + ;
          'DPH2011s ->nR034d := DPH2011s ->nR034d +VYKDPH_I ->nSAZBA_dph'

  case( nRv = 234 )
    cC := 'DPH2011s ->nR002d := DPH2011s ->nR002d +VYKDPH_I ->nSAZBA_dph, ' + ;
          'DPH2011s ->nR034d := DPH2011s ->nR034d +VYKDPH_I ->nSAZBA_dph'

  endcase
RETURN(cC)


static function D2011_def()                        //__PØEDNASAVENÍ DPH_2011 ___
  local          cC := SysConfig( 'SYSTEM:cZastupce'), ac
  local  ntypvykDph := sysconfig( 'FINANCE:nTypVykDPH')

  drgDBMS:open('dph_2011',,,,,'dph_2011w')
  dph_2011w->(AdsSetOrder('DPHDATA1'),dbgobottom())

  aC := { DPH_2011w ->cFinURAD      , ;
          DPH_2011w ->cRC           , ;
          DPH_2011w ->cPD           , ;
          DPH_2011w ->cIO           , ;
          DPH_2011w ->cSK           , ;
          DPH_2011w ->cND           , ;
          DPH_2011w ->cNU           , ;
          DPH_2011w ->cFyzOsPRIJ    , ;
          DPH_2011w ->cFyzOsJMEN    , ;
          DPH_2011w ->cCP           , ;
          DPH_2011w ->cCINNOST1     , ;
          DPH_2011w ->cOdpOsPOST      }

  dph_2011w->(dbclosearea())

  DPH_2011 ->( DbAppend(), RLock())
     DPH_2011 ->cUloha     := 'F'
     DPH_2011 ->cFinURAD   := aC[ 1]
     DPH_2011 ->cDIC       := SysConfig( 'SYSTEM:cDIC')
     DPH_2011 ->cRC        := aC[ 2]

     if ntypVykDph = 1
       DPH_2011 ->nM         := UcetSYS ->nObdobi
     else
       DPH_2011 ->nQ         := mh_CTVRTzOBDn(ucetsys->nobdobi)
     endif

     DPH_2011 ->nRok       := UcetSYS ->nRok
     DPH_2011 ->nOBDOBI    := ucetsys->nobdobi
     DPH_2011 ->nMOD       := UCETSYS ->nOBDOBI
     DPH_2011 ->nMDO       := UCETSYS ->nOBDOBI
     DPH_2011 ->cPD        := aC[ 3]
     DPH_2011 ->cIO        := aC[ 4]
     DPH_2011 ->cSK        := aC[ 5]
     DPH_2011 ->cND        := aC[ 6]
     DPH_2011 ->cNU        := ''    // :='X'  oprava JT 25.2.2014    //    aC[ 7]
     DPH_2011 ->cPraOsNAZ  := SysConfig( 'SYSTEM:cPodnik')
     DPH_2011 ->cPraOsDOP  := SysConfig( 'SYSTEM:cPodnik2')
     DPH_2011 ->cFyzOsPRIJ := SysConfig( 'SYSTEM:cFyzOsPRIJ' )
     DPH_2011 ->cFyzOsJMEN := SysConfig( 'SYSTEM:cFyzOsJMEN' )
     DPH_2011 ->cSIDLO     := SysConfig( 'SYSTEM:cSidlo')
     DPH_2011 ->cPSC       := AllTrim(StrTran(SysConfig( 'SYSTEM:cPSC'  ),' ',''))
     DPH_2011 ->cULICE     := SysConfig( 'SYSTEM:cUliceORG' )     //    SysConfig( 'SYSTEM:cUlice')
     DPH_2011 ->cCP        := SysConfig( 'SYSTEM:ccisPopORG')     //    aC[10]
     DPH_2011 ->cMAIL      := SysConfig( 'SYSTEM:cPathEmail')
     DPH_2011 ->cSTAT      := 'Èeská Republika'                   //    SysConfig( 'SYSTEM:cStat'     )
     DPH_2011 ->cCINNOST1  := SysConfig( 'SYSTEM:cCinnost1' )     //    aC[11]
     DPH_2011 ->cOdpOsPRIJ := SysConfig( 'SYSTEM:cOdpOsPrij' )    //    SubStr( cC, 1, At( ' ', cC) -1 )
     DPH_2011 ->cOdpOsJMEN := SysConfig( 'SYSTEM:cOdpOsJmen' )    //    SubStr( cC, At( ' ', cC) +1    )
     DPH_2011 ->cOdpOsPOST := SysConfig( 'SYSTEM:cOdpOsPost' )    //    aC[12]
     DPH_2011 ->dSesDNE    := Date()
     DPH_2011 ->cSesJMENO  := logOsoba
     DPH_2011 ->cSesTELEF  := AllTrim(Left( SysConfig( 'SYSTEM:cTelefon'), 17))
     DPH_2011 ->cObdobiDAN := UcetSYS ->cObdobiDAN
     DPH_2011 ->ndat_Od    := vykdph_i->ndat_Od
     *
     DPH_2011 ->cRP        := 'X'
return nil


STATIC FUNCTION D2011_cmp(aobdobi)               //__VÝPOÈET DPH_2011 __________
   Local  n, nKey, nKOEF := SYSCONFIG('FINANCE:nKOEvykDPH')
   Local           nPRC  := SYSCONFIG('FINANCE:nPRCvykDPH')
   Local  cC
   Local  xVAL, axFROM := DPH2011s ->(DbStruct()), nCMP

   if( .not. isNumber( nPRC ), nPRC := 100, Nil )

   nPRC  := if( nPRC  >=   95, 100, nPRC  )
   nKOEF := If( nKOEF >= 0.95,   1, nKOEF )

  ** PRVKY(s) PØESUNEME DO VÝKAZU **
  AEval( axFROM, { |X,M| ;
       ( xVal := ROUND(DPH2011s ->( FieldGet( M)) +.49,0)       , ;
         n    := DPH_2011 ->( FieldPos( X[ DBS_NAME]))          , ;
         If( n <> 0, DPH_2011 ->( FieldPut( n,  xVal)), Nil ) ) } )

   ** KONEÈNÁ ÚPRAVA KOEFICIENTEM
   *
   ** úprava výpoètu platná od 1.4.2011
   if DPH_2011 ->ndat_Od = 20110401
// 22.6.2011     DPH_2011 ->nR043z +=  round( sum_nR043z + .49, 0)

     DPH_2011 ->nR043z += ( DPH_2011 ->nR003z +DPH_2011 ->nR005z + ;
                            DPH_2011 ->nR007z +DPH_2011 ->nR009z + ;
                            DPH_2011 ->nR010z +DPH_2011 ->nR012z   )

// 22.7.2011
     DPH_2011 ->nR043z -=  round( sum_nR043z + .49, 0)

   else
     DPH_2011 ->nR043z := ( DPH_2011 ->nR003z +DPH_2011 ->nR005z + ;
                            DPH_2011 ->nR007z +DPH_2011 ->nR009z + ;
                            DPH_2011 ->nR010z +DPH_2011 ->nR012z   )
   endif
   DPH_2011 ->nR043z -= DPH_2011 ->nR042z
   *
   ** úprava výpoètu platná od 1.4.2011
   if DPH_2011 ->ndat_Od = 20110401
// 22.6.2011     DPH_2011 ->nR043d += round( sum_nR043d + .49, 0)

     DPH_2011 ->nR043d += ( DPH_2011 ->nR003d +DPH_2011 ->nR005d + ;
                            DPH_2011 ->nR007d +DPH_2011 ->nR009d + ;
                            DPH_2011 ->nR010d +DPH_2011 ->nR012d   )

// 22.7.2011
     DPH_2011 ->nR043d -= round( sum_nR043d + .49, 0)

     DPH_2011 ->nR043r += round( sum_nR043r + .49, 0)

   else
     DPH_2011 ->nR043d := ( DPH_2011 ->nR003d +DPH_2011 ->nR005d + ;
                            DPH_2011 ->nR007d +DPH_2011 ->nR009d + ;
                            DPH_2011 ->nR010d +DPH_2011 ->nR012d   )
   endif
   DPH_2011 ->nR043d -= DPH_2011 ->nR042d
   *
   ** úprava výpoètu platná od 1.4.2011
   if DPH_2011 ->ndat_Od = 20110401
// 22.6.2011     DPH_2011 ->nR044z += round( sum_nR044z + .49, 0)

     DPH_2011 ->nR044z += ( DPH_2011 ->nR004z +DPH_2011 ->nR006z + ;
                            DPH_2011 ->nR008z +DPH_2011 ->nR011z + ;
                            DPH_2011 ->nR013z                      )

// 28.7.2011
     DPH_2011 ->nR044z -= round( sum_nR044z + .49, 0)

  else
     DPH_2011 ->nR044z := ( DPH_2011 ->nR004z +DPH_2011 ->nR006z + ;
                            DPH_2011 ->nR008z +DPH_2011 ->nR011z + ;
                            DPH_2011 ->nR013z                      )
   endif
   *
   ** úprava výpoètu platná od 1.4.2011
   if DPH_2011 ->ndat_Od = 20110401
// 22.6.2011     DPH_2011 ->nR044d += round( sum_nR044d + .49, 0)

     DPH_2011 ->nR044d += ( DPH_2011 ->nR004d +DPH_2011 ->nR006d + ;
                            DPH_2011 ->nR008d +DPH_2011 ->nR011d + ;
                            DPH_2011 ->nR013d  )

// 28.7.2011
     DPH_2011 ->nR044d -= round( sum_nR044d + .49, 0)

     DPH_2011 ->nR044r += round( sum_nR044r + .49, 0)

   else
     DPH_2011 ->nR044d := ( DPH_2011 ->nR004d +DPH_2011 ->nR006d + ;
                            DPH_2011 ->nR008d +DPH_2011 ->nR011d + ;
                            DPH_2011 ->nR013d  )
   endif

   DPH_2011 ->nR046d := ( DPH_2011 ->nR040d +DPH_2011 ->nR041d + ;
                          DPH_2011 ->nR042d +DPH_2011 ->nR043d + ;
                          DPH_2011 ->nR044d +DPH_2011 ->nR045d   )

   DPH_2011 ->nR046r := ( DPH_2011 ->nR040r +DPH_2011 ->nR041r + ;
                          DPH_2011 ->nR042r +DPH_2011 ->nR043r + ;
                          DPH_2011 ->nR044r +DPH_2011 ->nR045r   )

   DPH_2011 ->nR051s :=   nr_051pz

   *
   ** úprava koeficinetu platná od 1.4.2011
   if DPH_2011 ->ndat_Od = 20110401
     DPH_2011 ->nR052k := nPRC
     DPH_2011 ->nR052o := ( DPH_2011 ->nR046r * DPH_2011 ->nR052k/100)
   else
     DPH_2011 ->nR052k := nKOEF
     DPH_2011 ->nR052o := ( DPH_2011 ->nR046r * DPH_2011 ->nR052k)
   endif

   nCMP :=              ( DPH_2011 ->nR001z +DPH_2011 ->nR002z + ;
                          DPH_2011 ->nR020p +DPH_2011 ->nR021p + ;
                          DPH_2011 ->nR022p +DPH_2011 ->nR023p + ;
                          DPH_2011 ->nR024p +DPH_2011 ->nR025p + ;
                          DPH_2011 ->nR030p ) - DPH_2011 ->nR051s

   DPH_2011 ->nR053k := 0 // ( nCMP / nCMP +DPH_2011 ->nR050p +DPH_2011 ->nR051b)

   DPH_2011 ->nR053o := 0 // ( DPH_2011 ->nR051s -DPH_2011 ->nR052o) / (DPH_2011 ->nR047r * DPH_2011 ->nR053k)

   DPH_2011 ->nR062d := ( DPH_2011 ->nR001d +DPH_2011 ->nR002d + ;
                          DPH_2011 ->nR003d +DPH_2011 ->nR004d + ;
                          DPH_2011 ->nR005d +DPH_2011 ->nR006d + ;
                          DPH_2011 ->nR007d +DPH_2011 ->nR008d + ;
                          DPH_2011 ->nR009d +DPH_2011 ->nR010d + ;
                          DPH_2011 ->nR011d +DPH_2011 ->nR012d + ;
                          DPH_2011 ->nR013d) - DPH_2011 ->nR061d

   DPH_2011 ->nR063o := ( DPH_2011 ->nR046d +DPH_2011 ->nR052o + ;
                          DPH_2011 ->nR053o +DPH_2011 ->nR060o   )

   DPH_2011 ->nR064d := ( DPH_2011 ->nR062d -DPH_2011 ->nR063o)

   if (DPH_2011 ->nR063o -DPH_2011 ->nR062d) > 0
     DPH_2011 ->nR064d := 0
     DPH_2011 ->nR065o := ( DPH_2011 ->nR063o -DPH_2011 ->nR062d)
   else
     DPH_2011 ->nR065o := 0
   endif

   DPH_2011 ->nR066d := 0

   * A/N - existuje/ neexistuje daònová povinnost,
//   DPH_2011 ->cNU    := if( DPH_2011->nR065d > 0, 'A', 'N' )

   ** MODIFIKACE UCETSYS
   FOR n := 1 To LEN(aobdobi) STEP 1
     UCETSYS ->( DbGoTo(aobdobi[n]))
     UCETSYS ->cUZVKDOD := SysConfig( 'SYSTEM:cUSERABB')
     UCETSYS ->dUZVDATD := Date()
     UCETSYS ->cUZVCASD := Time()
     UCETSYS ->lZAVREND := .T.
   NEXT
RETURN NIL


STATIC FUNCTION D2011_sco(cFILE)                 //__SCOPE FOR VYKDPH_I_________
  LOCAL  cKy

  IF IsNIL(cFILE)
    VYKDPH_I ->( DbClearScope(), DbGoTop() )
  ELSE
    cKy := Upper( DBGetVal( cFILE +'->cDENIK' )) +StrZero( DBGetVal( cFILE +'->nDOKLAD'),10)
    VYKDPH_I ->( DbSetScope(SCOPE_BOTH,cKy), DbGoTop() )
  ENDIF
RETURN NIL


STATIC FUNCTION D2011_rvw(cH,cI)                 //__FAKVYSIT - POKLIT _________
  Local  aIT := ;                               // ³POKLIT   RV_DPH ³
  { COMPILE( 'VYKDPH_I ->cULOHA     := ' +cH +' ->cULOHA'    ) , ;
    COMPILE( 'VYKDPH_I ->nDOKLAD    := ' +cH +' ->nCISFAK'   ) , ;
    COMPILE( 'VYKDPH_I ->cOBDOBI    := ' +cH +' ->cOBDOBI '  ) , ;
    COMPILE( 'VYKDPH_I ->nROK       := ' +cH +' ->nROK'      ) , ;
    COMPILE( 'VYKDPH_I ->nOBDOBI    := ' +cH +' ->nOBDOBI'   ) , ;
    COMPILE( 'VYKDPH_I ->cOBDOBIdan := ' +cH +' ->cOBDOBIdan') , ;
    COMPILE( 'VYKDPH_I ->nTYP_dph   := C_VYKDPH ->nNAPOCET'  ) , ;
    COMPILE( 'VYKDPH_I ->nODDIL_dph := C_VYKDPH ->nODDIL_dph') , ;
    COMPILE( 'VYKDPH_I ->nRADEK_dph := C_VYKDPH ->nRADEK_dph') , ;
    COMPILE( 'VYKDPH_I ->nZAKLD_dph := ' +cI +' ->nCENZAKCEL') , ;
    COMPILE( 'VYKDPH_I ->nSAZBA_dph := ' +cI +' ->nSAZDAN'   ) , ;
    COMPILE( 'VYKDPH_I ->cUCETU_dph := C_VYKDPH ->cUCETU_dph') , ;
    COMPILE( 'VYKDPH_I ->nDAT_od    := C_VYKDPH ->nDAT_od'   ) , ;
    COMPILE( 'VYKDPH_I ->cDENIK     := ' +cH +' ->cDENIK'    ) , ;
    COMPILE( 'VYKDPH_I ->FAKPRIHD   := C_VYKDPH ->FAKPRIHD'  ) , ;
    COMPILE( 'VYKDPH_I ->POKLADHD   := C_VYKDPH ->POKLADHD'  ) , ;
    COMPILE( 'VYKDPH_I ->UCETDOHD   := C_VYKDPH ->UCETDOHD'  ) , ;
    COMPILE( 'VYKDPH_I ->nPROCdph   := ' +cI +' ->nPROCDPH'  ) , ;
    COMPILE( 'VYKDPH_I ->nGEN_dokl  := 9'                    )   }

    if c_vykdph->(dbSeek( strZero((cI)->nradVykDph) +'20110101'))
      ( VYKDPH_I ->( dbAPPEND()), aEVAL( aIT, { |X| EVAL(X) }) )
    EndIf
RETURN NIL


**
** ZPRACOVÁNÍ vstupních DAT ****************************************************
FUNCTION D2011_fap()                          //__FAKTURY PØIJATÉ_______________
  If (FAKPRIHD ->nFINtyp == 1 .or. FAKPRIHD ->nFINtyp == 2 .or. FAKPRIHD ->nFINtyp == 6) .and. !FAKPRIHD ->lNo_InDPH
    mh_COPYFLD( 'FAKPRIHD', 'PRIJATPL', .t., .f.)
    PRIJATPL ->dDATUZV := DATE()

    D2011_sco( 'FAKPRIHD' )

    Do While !VYKDPH_I ->( EOF())
      cVAL := D2011_rvs(VYKDPH_I ->nRADEK_dph,1)
      EVAL( COMPILE( cVAL ))

      VYKDPH_I ->( dbSKIP())
    EndDo

    D2011_sco()

    ** PØEHOZENÍ NÁPOÈTU CELNÍ FAKTURY **
    If FakPriHD ->nFinTYP == 2
      PRIJATPL ->nZaklDAN1D := PRIJATPL ->nZaklDAN_1
      PRIJATPL ->nSazDAN1D  := PRIJATPL ->nSazDAN_1
      PRIJATPL ->nZaklDAN2D := PRIJATPL ->nZaklDAN_2
      PRIJATPL ->nSazDAN2D  := PRIJATPL ->nSazDAN_2

      PRIJATPL ->nZaklDAN_1 := 0
      PRIJATPL ->nSazDAN_1  := 0
      PRIJATPL ->nZaklDAN_2 := 0
      PRIJATPL ->nSazDAN_2  := 0
    EndIf
  EndIf
RETURN NIL


function D2011_fav()                          //__FAKTURY VYSTAVENÉ ____________

  if (FAKVYSHD ->nFINtyp <> 2 .and. FAKVYSHD ->nFINtyp <> 4) .and. !FAKVYSHD ->lNo_InDPH
    mh_COPYFLD( 'FAKVYSHD', 'USKUTPL', .t., .f.)
    USKUTPL ->dDATUZV := Date()

    D2011_sco( 'FAKVYSHD' )

    do while .not. vykdph_i->(eof())
      cVAL := D2011_rvs(vykdph_i->nradek_dph,1)
      EVAL( COMPILE( cVAL ))

      *
      ** vývoz zboží §66 - ostatní plnìní osvobozeno od danì **
      if (vykdph_i->nradek_dph = 22 .or. vykdph_i->nradek_dph = 25)
        if( vykdph_i->nradek_dph = 22, uskutpl->nvyvozzboz += vykdph_i->nzakld_dph, ;
                                       uskutpl->nvyvozsluz += vykdph_i->nzakld_dph  )
      endif

      vykdph_i->(dbSkip())
    enddo

    D2011_sco()
  endif
return nil


FUNCTION D2011_pof()                          //__ POKLADNA FINANCE ____________
  LOCAL lDONe := .F.

  IF (POKLADHD ->nZAKLdan_1 +POKLADHD ->nZAKLdan_2 +POKLADHD ->nOSVODDAN) <> 0

    D2011_sco( 'POKLADHD' )
    DO WHILE .not. VYKDPH_I ->( Eof())
     ldone := if( vykdph_i->nradek_dph = 0 .or. vykdph_i->nradek_dph = 100, .f., .t.)

*      IF( VYKDPH_I ->nRADEK_dph > 100, lDONe := .T., NIL )
      cVAL  := D2011_rvs(VYKDPH_I ->nRADEK_dph,1)
      EVAL( COMPILE( cVAL ))

      VYKDPH_I ->( DbSkip())
    EndDo

    D2011_sco()

    IF lDONe
      if pokladhd->ntypDok = 2 .or. pokladhd->ntypDok = 3  //--výdej / zúètZáloh
        mh_COPYFLD( 'POKLADHD', 'PRIJATPL', .t., .f.)
        PRIJATPL ->dPorizfak := POKLADHD ->dPORIZdok
        PRIJATPL ->nCisfak   := POKLADHD ->nDOKLAD
        PRIJATPL ->dDATUZV   := DATE()
      else                                                 //--pøíjem
        mh_COPYFLD( 'POKLADHD', 'USKUTPL', .t., .f.)
        USKUTPL ->dPORIZfak := POKLADHD ->dPORIZdok
        USKUTPL ->nCISfak   := POKLADHD ->nDOKLAD
        USKUTPL ->dDATUZV   := Date()
      endif
    ENDIF
  ENDIF
RETURN NIL


FUNCTION D2011_ucd()                          //__ ÚÈETNÍ DOKLAD _______________
  IF ( UCETDOHD ->nZAKLdan_1 +UCETDOHD ->nSAZdan_1 + ;
       UCETDOHD ->nZAKLdan_2 +UCETDOHD ->nSAZdan_2 + ;
       UCETDOHD ->nOSVodDAN  +UCETDOHD ->nNULLdph ) <> 0

    D2011_sco( 'UCETDOHD' )
    DO WHILE .not. VYKDPH_I ->( EOF())
      cVAL := D2011_rvs(VYKDPH_I ->nRADEK_dph,1)
      EVAL( COMPILE( cVAL ))

      VYKDPH_I ->( DbSkip())
    ENDDO
    D2011_sco()

    IF UCETDOHD ->nTYPobratu == 1                          //__nápoèet pøíjem MD
      mh_COPYFLD( 'UCETDOHD', 'USKUTPL', .t., .f.)
        USKUTPL ->dPORIZfak := UCETDOHD ->dPORIZdok
        USKUTPL ->nCISfak   := UCETDOHD ->nDOKLAD
        USKUTPL ->dDATUZV   := DATE()
    ELSE                                                   //__nápoèet výdej DAL
      mh_COPYFLD( 'UCETDOHD', 'PRIJATPL', .t., .f.)
      PRIJATPL ->dPORIZfak := UCETDOHD ->dPORIZdok
      PRIJATPL ->nCISfak   := UCETDOHD ->nDOKLAD
      PRIJATPL ->dDATUZV   := DATE()
    ENDIF
  ENDIF
RETURN NIL



function D2011_pop()                          //__ POKLADNA PRODEJ _____________

  IF SysConfig('FINANCE:lKASADPHex')

    mh_COPYFLD( 'POKLHD', 'USKUTPL', .t., .f.)
    USKUTPL ->dPORIZFAK := POKLHD ->dVYSTfak
    USKUTPL ->dDATUZV := Date()

    D2011_sco( 'POKLHD' )

    do while .not. vykdph_i->(eof())
      cVAL := D2011_rvs(vykdph_i->nradek_dph,1)
      EVAL( COMPILE( cVAL ))

      *
      ** vývoz zboží §66 - ostatní plnìní osvobozeno od danì **
      if (vykdph_i->nradek_dph = 22 .or. vykdph_i->nradek_dph = 25)
        if( vykdph_i->nradek_dph = 22, uskutpl->nvyvozzboz += vykdph_i->nzakld_dph, ;
                                       uskutpl->nvyvozsluz += vykdph_i->nzakld_dph  )
      endif

      vykdph_i->(dbSkip())
    enddo

    D2011_sco()
  endif
return nil