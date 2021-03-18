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


// popis v GROUPS(FAKVYSHD:10:FAKVYSIT:1:STRZERO(FAKVYSHD->nCISFAK):DPH2004_FAV()) //
#xtranslate  _mFILE  =>  pA\[ 1\]        //_ základní soubor       _
#xtranslate  _mTAG   =>  Val(pA\[ 2\])   //_                 tag   _
#xtranslate  _sFILE  =>  pA\[ 3\]        //_ spojený soubor        _
#xtranslate  _sTAG   =>  Val(pA\[ 4\])   //_                 tag   _
#xtranslate  _sSCOPE =>  pA\[ 5\]        //_                 scope _
#xtranslate  _mFUNC  =>  pA\[ 6\]        //_ funkce pro zpracování _
#xtranslate  _oPROC  =>  pA\[ 7\]        //_ objekt pro procento   _
#xtranslate  _oTHERM =>  pA\[ 8\]        //_ objekt pro teplomìr   _



**
** CLASS for FIN_dph_2004_INS **************************************************
CLASS FIN_dph_2004_INS FROM drgUsrClass
EXPORTED:
  var     zprac, dotaz

  method  init, destroy, drgDialogStart, comboBoxInit, comboItemSelected
  method  dph_Insert

HIDDEN:
  var     aEDITs, nrok, obdobidan, aobdobi, showDialog
ENDCLASS


METHOD FIN_dph_2004_INS:init(parent)
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
  drgDBMS:open('DPH2004s',.T.,.T.,drgINI:dir_USERfitm); ZAP
  DPH2004s ->(DbAppend())
RETURN self


METHOD FIN_dph_2004_INS:destroy()
  ::drgUsrClass:destroy()

  ::zprac     := ;
  ::dotaz     := ;
  ::aEDITs    := ;
  ::nrok      := ;
  ::obdobidan := ;
  ::aobdobi   := NIL

  DPH2004s ->(DbCloseArea())
RETURN

METHOD FIN_dph_2004_INS:drgDialogStart(drgDialog)
 LOCAL x, pA, members  := drgDialog:oForm:aMembers

 ::aEdits   := {}

 FOR x := 1 TO LEN(members)
   IF .not. Empty(members[x]:groups)
     pA  := ListAsArray(members[x]:groups,':')
     nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

     IF(nIn <> 0, ::aEDITs[nIn,8] := members[x], ;
                  AAdd(::aEDITs, { pA[1], pA[2], pA[3], pA[4], pA[5], pA[6], members[x], NIL }))
   ENDIF
 NEXT

 if .not. ::showDialog
    ConfirmBox( ,'Je mì líto, ale nelze spustil tuto nabídku, nejsou splnìny podmínky pro zpracování ...', ;
                 'Nelze zpracovat požadavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif
RETURN ::showDialog


METHOD FIN_dph_2004_INS:comboBoxInit(drgComboBox)
  LOCAL  aCOMBO_val := FIN_dph_2004_obd(::nrok, .T.)

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


METHOD FIN_dph_2004_INS:comboItemSelected(mp1, mp2, o)
  LOCAL  pA := mp1:values

  IF ::obdobidan <> mp1:value
    ::obdobidan := mp1:value
    ::aobdobi   := pA[AScan(pA, { |X| X[1] = mp1:value }),3]
  ENDIF
RETURN .T.


method FIN_dph_2004_INS:dph_Insert()
  local x, pa, oXbp, nreccnt, nkeycnt, nkeyno, prc


  if ucetsys ->(sx_RLock(::aobdobi)) .and. prijatpl->(flock()) .and. uskutpl->(flock())

    ucetsys ->(dbgoto(::aobdobi[1]))
    D2004_def()

    for x := 1 to len(::aedits) step 1
      pa      := ::aedits[x]
      oxbp    := _oTHERM:oxbp
      nreccnt := 0

      drgDBMS:open(_mFILE) ; (_mFILE) ->(AdsSetOrder(_mTAG))
      if( .not. empty(_sfile), (drgDBms:open(_sfile),(_sfile)->(AdsSetOrder(_stag))), nil)

      (_mfile)->(dbsetscope(SCOPE_BOTH,::obdobidan), ;
                 dbgotop()                         , ;
                 dbeval({||nreccnt++})             , ;
                 dbgotop()                           )

      nkeycnt := nreccnt / round(oxbp:currentSize()[1]/(drgINI:fontH -6),0)
      nkeyno  := 1

      DO WHILE .not. (_mFILE) ->(Eof())
        prc := fin_dph_2004_pb(oxbp,nkeycnt,nkeyno,nreccnt)
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
      (_mfile) ->(dbclearscope())

      dph2004s->(dbCommit())
    NEXT

    D2004_cmp(::aobdobi)
     UCETSYS ->( DbUnLock())
      PRIJATPL ->( DbUnLock())
       USKUTPL  ->( DbUnLock())

    sleep(150)
    PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
  endif
return .t.



**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
STATIC FUNCTION D2004_rvs(nRV,nTYP)
  LOCAL  cC := '.T.'
  LOCAL  aX := { ;
{ 'DPH2004s ->nR.z   := DPH2004s ->nR.z   +VYKDPH_I ->nZAKLD_dph, ' + ;
  'DPH2004s ->nR.d   := DPH2004s ->nR.d   +(VYKDPH_I ->nSAZBA_dph -VYKDPH_I ->nKRACE_nar), ' + ;
  'DPH2004s ->nR520p := DPH2004s ->nR520p +VYKDPH_I ->nZAKLD_dph'     , ;
  'DPH2004s ->nR.z   := DPH2004s ->nR.z   +VYKDPH_I ->nZAKLD_dph, ' + ;
  'DPH2004s ->nR.d   := DPH2004s ->nR.d   +(VYKDPH_I ->nSAZBA_dph -VYKDPH_I ->nKRACE_nar)' , ;
  'DPH2004s ->nR.z   := DPH2004s ->nR.z   +VYKDPH_I ->nZAKLD_dph, ' + ;
  'DPH2004s ->nR.d   := DPH2004s ->nR.d   +(VYKDPH_I ->nSAZBA_dph -VYKDPH_I ->nKRACE_nar), ' + ;
  'DPH2004s ->nR.r   := DPH2004s ->nR.r   +VYKDPH_I ->nKRACE_nar'     , ;
  'DPH2004s ->nR.p   := DPH2004s ->nR.p   +VYKDPH_I ->nZAKLD_dph'     }, ;
{ 'DPH2004s ->nR.z   := DPH2004s ->nR.z   +FAKVYSIT ->nCENzakCEL, ' + ;
  'DPH2004s ->nR.d   := DPH2004s ->nR.d   +FAKVYSIT ->nSAZdan, '    + ;
  'DPH2004s ->nR520p := DPH2004s ->nR520p +FAKVYSIT ->nCENzakCEL'     , ;
  'DPH2004s ->nR.z   := DPH2004s ->nR.z   +FAKVYSIT ->nCENzakCEL, ' + ;
  'DPH2004s ->nR.d   := DPH2004s ->nR.d   +FAKVYSIT ->nSAZdan'        , ;
  'DPH2004s ->nR.p   := DPH2004s ->nR.p   +FAKVYSIT ->nCENzakCEL'     , ;
  'DPH2004s ->nR.p   := DPH2004s ->nR.p   +FAKVYSIT ->nCENzakCEL'     }, ;
{ 'DPH2004s ->nR.z   := DPH2004s ->nR.z   +POKLIT   ->nCENzakCEL, ' + ;
  'DPH2004s ->nR.d   := DPH2004s ->nR.d   +POKLIT   ->nSAZdan, '    + ;
  'DPH2004s ->nR520p := DPH2004s ->nR520p +POKLIT   ->nCENzakCEL'     , ;
  'DPH2004s ->nR.z   := DPH2004s ->nR.z   +POKLIT   ->nCENzakCEL, ' + ;
  'DPH2004s ->nR.d   := DPH2004s ->nR.d   +POKLIT   ->nSAZdan'        , ;
  'DPH2004s ->nR.p   := DPH2004s ->nR.p   +POKLIT   ->nCENzakCEL'     } }

  If nRV > 100                      //____pomocné RV do 100 nejdou do výkazu____
    DO CASE
    CASE( nRV == 211 .or.  nRV == 216 )
      cC := STRTRAN(aX[nTYP,1], '.', STR(nRV -1,3))
    CASE( nRV >= 210 .and. nRV <= 275 )
      cC := STRTRAN(aX[nTYP,2], '.', STR(nRV,3))
    CASE( nRV >= 310 .and. nRV <= 365 )
      cC := STRTRAN(aX[nTYP,3], '.', STR(nRV,3))
    CASE( nRV >= 410 .and. nRV <= 440 )
      cC := STRTRAN(aX[nTYP,4], '.', STR(nRV,3))
    CASE( nRV == 510 )  .or. ( nRV == 530 )
      cC := STRTRAN(aX[nTYP,If(nTYP == 1, 4, 3)], '.', STR(nRV,3))
    CASE( nRV == 531 )
      cC := 'DPH2004s ->nR530p := DPH2004s ->nR530p +FAKVYSIT ->nCENzakCEL, ' + ;
            'DPH2004s ->nR540p := DPH2004s ->nR540p +FAKVYSIT ->nCENzakCEL'
    CASE( nRV == 810 )
      cC := 'DPH2004s ->nR810h := DPH2004s ->nR810h +VYKDPH_I ->nZAKLD_dph'
    CASE( nRV == 815 )
      cC := 'DPH2004s ->nR815h := DPH2004s ->nR815h +FAKVYSIT ->nCENzakCEL'
    ENDCASE
  ENDIF
RETURN(cC)


static function D2004_def()                        //__PØEDNASAVENÍ DPH_2004 ___
  local  cC := SysConfig( 'SYSTEM:cZastupce'), ac

  drgDBMS:open('dph_2004',,,,,'dph_2004w')
  dph_2004w->(AdsSetOrder('DPHDATA1'),dbgobottom())

  aC := { DPH_2004w->cFinURAD                         , ;
          DPH_2004w->cFyzOsJMEN, DPH_2004w->cFyzOsPRIJ, ;
          DPH_2004w->cOdpOsPOST                         }

  dph_2004w->(dbclosearea())


  DPH_2004 ->( DbAppend(), RLock())
    DPH_2004 ->cUloha     := 'F'
    DPH_2004 ->cObdobiDAN := ucetsys->cobdobidan
    DPH_2004 ->cFinURAD   := SysConfig( 'SYSTEM:cFINURAD')           // aC[ 1]
    DPH_2004 ->cDIC       := SysConfig( 'SYSTEM:cDIC')
    DPH_2004 ->nM         := ucetsys->nobdobi
    DPH_2004 ->nQ         := mh_CTVRTzOBDn(ucetsys->nobdobi)
    DPH_2004 ->nRok       := ucetsys->nrok
    DPH_2004 ->nOBDOBI    := ucetsys->nobdobi
    DPH_2004 ->cFyzOsJMEN := SysConfig( 'SYSTEM:cFYZOSPRIJ')         // aC[ 2]
    DPH_2004 ->cFyzOsPRIJ := SysConfig( 'SYSTEM:cFYZOSJMEN')         // aC[ 3]
    DPH_2004 ->cTitul     := SysConfig( 'SYSTEM:cFYZOSTIT' )
    DPH_2004 ->cPraOsNAZ  := SysConfig( 'SYSTEM:cPodnik')
    DPH_2004 ->cPraOsDOP  := SysConfig( 'SYSTEM:cPodnik2')
    DPH_2004 ->cAdresa    := SysConfig( 'SYSTEM:cSidlo') +', ' + ;
                             SysConfig( 'SYSTEM:cUlice') +', ' + ;
                             SysConfig( 'SYSTEM:cPSC'  )
    DPH_2004 ->cOdpOsPRIJ := SysConfig( 'SYSTEM:cODPOSPRIJ')         // SubStr( cC, 1, At( ' ', cC) -1 )
    DPH_2004 ->cOdpOsJMEN := SysConfig( 'SYSTEM:cODPOSJMEN')         // SubStr( cC, At( ' ', cC) +1    )
    DPH_2004 ->cOdpOsPOST := SysConfig( 'SYSTEM:cODPOSPOST')         // aC[ 4]
    DPH_2004 ->dSesDNE    := Date()
    DPH_2004 ->cSesJMENO  := logOsoba
    DPH_2004 ->cSesTELEF  := Left( SysConfig( 'SYSTEM:cTelefon'), 15)
    *
    DPH_2004 ->cKraj      := SysConfig( 'SYSTEM:cKRAJ'    )
    DPH_2004 ->cCinnost1  := SysConfig( 'SYSTEM:cCINNOST1')

*-    DPH_2004 ->cZaklStat  := SYSCONFIG('SYSTEM:cZaklStat')
return nil


STATIC FUNCTION D2004_cmp(aobdobi)               //__VÝPOÈET DPH_2004 __________
   Local  n, nKey, nKOEF := SYSCONFIG('FINANCE:nKOEvykDPH')
   Local  cC
   Local  xVAL, axFROM := DPH2004s ->(DbStruct())

   nKOEF := If( nKOEF >= 0.95, 1, nKOEF )

  ** PRVKY(s) PØESUNEME DO VÝKAZU **
  AEval( axFROM, { |X,M| ;
       ( xVal := ROUND(DPH2004s ->( FieldGet( M)) +.49,0)       , ;
         n    := DPH_2004 ->( FieldPos( X[ DBS_NAME]))          , ;
         If( n <> 0, DPH_2004 ->( FieldPut( n,  xVal)), Nil ) ) } )

   ** KONEÈNÁ ÚPRAVA KOEFICIENTEM **
   DPH_2004 ->nR380r := ( DPH_2004 ->nR310r + DPH_2004 ->nR315r + ;
                          DPH_2004 ->nR320r + DPH_2004 ->nR325r + ;
                          DPH_2004 ->nR330r + DPH_2004 ->nR335r + ;
                          DPH_2004 ->nR340r + DPH_2004 ->nR345r + ;
                          DPH_2004 ->nR350r + DPH_2004 ->nR355r + ;
                          DPH_2004 ->nR360r + DPH_2004 ->nR365r + ;
                          DPH_2004 ->nR370r )
   DPH_2004 ->nR390d := ( DPH_2004 ->nR310d + DPH_2004 ->nR315d + ;
                          DPH_2004 ->nR320d + DPH_2004 ->nR325d + ;
                          DPH_2004 ->nR330d + DPH_2004 ->nR335d + ;
                          DPH_2004 ->nR340d + DPH_2004 ->nR345d + ;
                          DPH_2004 ->nR350d + DPH_2004 ->nR355d + ;
                          DPH_2004 ->nR360d + DPH_2004 ->nR365d + ;
                          DPH_2004 ->nR370d )
   DPH_2004 ->nR510p += ( DPH_2004 ->nR210z + DPH_2004 ->nR215z + ;
                          DPH_2004 ->nR410p + DPH_2004 ->nR420p + ;
                          DPH_2004 ->nR425p + DPH_2004 ->nR430p + ;
                          DPH_2004 ->nR440p )
   DPH_2004 ->nR550k := nKOEF
   DPH_2004 ->nR550o := ROUND((DPH_2004 ->nR380r *nKOEF) +.49,0)
   DPH_2004 ->nR730d := ( DPH_2004 ->nR210d + DPH_2004 ->nR215d + ;
                          DPH_2004 ->nR220d + DPH_2004 ->nR225d + ;
                          DPH_2004 ->nR230d + DPH_2004 ->nR235d + ;
                          DPH_2004 ->nR240d + DPH_2004 ->nR245d + ;
                          DPH_2004 ->nR250d + DPH_2004 ->nR255d + ;
                          DPH_2004 ->nR260d + DPH_2004 ->nR265d + ;
                          DPH_2004 ->nR270d + DPH_2004 ->nR275d + ;
                          DPH_2004 ->nR710d ) - DPH_2004 ->nR600d
   DPH_2004 ->nR750o := ( DPH_2004 ->nR390d + DPH_2004 ->nR550o + ;
                          DPH_2004 ->nR560o + DPH_2004 ->nR570o + ;
                          DPH_2004 ->nR580o )
   DPH_2004 ->nR753d := ( DPH_2004 ->nR730d - DPH_2004 ->nR750o )
   DPH_2004 ->nR754o := ( DPH_2004 ->nR750o - DPH_2004 ->nR730d )

   If( DPH_2004 ->nR753d > 0, NIL, DPH_2004 ->nR753d := 0 )
   If( DPH_2004 ->nR754o > 0, NIL, DPH_2004 ->nR754o := 0 )

   DPH_2004 ->nR780d := ( DPH_2004 ->nR730d - DPH_2004 ->nR750o )

    ** MODIFIKACE UCETSYS **
   FOR n := 1 To LEN(aobdobi) STEP 1
     UCETSYS ->( DbGoTo(aobdobi[n]))
     UCETSYS ->cUZVKDOD := SysConfig( 'SYSTEM:cUSERABB')
     UCETSYS ->dUZVDATD := Date()
     UCETSYS ->cUZVCASD := Time()
     UCETSYS ->lZAVREND := .T.
   NEXT
RETURN NIL


STATIC FUNCTION D2004_sco(cFILE)                 //__SCOPE FOR VYKDPH_I_________
  LOCAL  cKy

  IF IsNIL(cFILE)
    VYKDPH_I ->( DbClearScope(), DbGoTop() )
  ELSE
    cKy := Upper( DBGetVal( cFILE +'->cDENIK' )) +StrZero( DBGetVal( cFILE +'->nDOKLAD'),10)
    VYKDPH_I ->( DbSetScope(SCOPE_BOTH,cKy), DbGoTop() )
  ENDIF
RETURN NIL


STATIC FUNCTION D2004_rvw(cH,cI)                 //__FAKVYSIT - POKLIT _________
  LOCAL  aIT := { COMPILE( 'VYKDPH_I ->cULOHA     := ' +cH +' ->cULOHA'    ) , ;
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


  IF C_VYKDPH->( Ads_Locate( FORMAT("nRADEK_DPH = %%",{(cI) ->nRADVYKDPH})))
    VYKDPH_I ->( DbAppend())
    AEval( aIT, { |X| Eval(X)})
  ENDIF
RETURN NIL


**
** ZPRACOVÁNÍ vstupních DAT ****************************************************
FUNCTION D2004_fap()                          //__FAKTURY PØIJATÉ_______________
  If FAKPRIHD ->nFINtyp == 1 .or. FAKPRIHD ->nFINtyp == 2 .or. FAKPRIHD ->nFINtyp == 6 .and. !FAKPRIHD ->lNo_InDPH
    mh_COPYFLD( 'FAKPRIHD', 'PRIJATPL', .t., .f.)
    PRIJATPL ->dDATUZV := DATE()

    D2004_sco( 'FAKPRIHD' )

    Do While !VYKDPH_I ->( EOF())
      cVAL := D2004_rvs(VYKDPH_I ->nRADEK_dph,1)
      EVAL( COMPILE( cVAL ))

      VYKDPH_I ->( dbSKIP())
    EndDo

    D2004_sco()

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


function D2004_fav()                          //__FAKTURY VYSTAVENÉ ____________

  if FAKVYSHD ->nFINtyp <> 2 .and. FAKVYSHD ->nFINtyp <> 4 .and. !FAKVYSHD ->lNo_InDPH
    mh_COPYFLD( 'FAKVYSHD', 'USKUTPL', .t., .f.)
    USKUTPL ->dDATUZV := Date()

    D2004_sco( 'FAKVYSHD' )

    do while .not. vykdph_i->(eof())
      cVAL := D2004_rvs(vykdph_i->nradek_dph,1)
      EVAL( COMPILE( cVAL ))

      *
      ** vývoz zboží §66 - ostatní plnìní osvobozeno od danì **
      if (vykdph_i->nradek_dph = 430 .or. vykdph_i->nradek_dph = 440)
        if( vykdph_i->lsluzba, uskutpl->nvyvozzboz += vykdph_i->nzakld_dph, ;
                               uskutpl->nvyvozsluz += vykdph_i->nzakld_dph  )
      endif

      vykdph_i->(dbSkip())
    enddo

    D2004_sco()
  endif
return nil


FUNCTION D2004_pof()                          //__ POKLADNA FINANCE ____________
  LOCAL lDONe := .F.

  IF (POKLADHD ->nZAKLdan_1 +POKLADHD ->nZAKLdan_2 +POKLADHD ->nOSVODDAN) <> 0

    D2004_sco( 'POKLADHD' )
    DO WHILE .not. VYKDPH_I ->( Eof())
      IF( VYKDPH_I ->nRADEK_dph > 100, lDONe := .T., NIL )
      cVAL  := D2004_rvs(VYKDPH_I ->nRADEK_dph,1)
      EVAL( COMPILE( cVAL ))

      VYKDPH_I ->( DbSkip())
    EndDo

    D2004_sco()

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


FUNCTION D2004_ucd()                          //__ ÚÈETNÍ DOKLAD _______________
  IF ( UCETDOHD ->nZAKLdan_1 +UCETDOHD ->nSAZdan_1 + ;
       UCETDOHD ->nZAKLdan_2 +UCETDOHD ->nSAZdan_2 + ;
       UCETDOHD ->nOSVodDAN  +UCETDOHD ->nNULLdph ) <> 0

    D2004_sco( 'UCETDOHD' )
    DO WHILE .not. VYKDPH_I ->( EOF())
      cVAL := D2004_rvs(VYKDPH_I ->nRADEK_dph,1)
      EVAL( COMPILE( cVAL ))

      VYKDPH_I ->( DbSkip())
    ENDDO
    D2004_sco()

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



function D2004_pop()                          //__ POKLADNA PRODEJ _____________

  IF SysConfig('FINANCE:lKASADPHex')

    mh_COPYFLD( 'POKLHD', 'USKUTPL', .t., .f.)
    USKUTPL ->dPORIZFAK := POKLHD ->dVYSTfak
    USKUTPL ->dDATUZV := Date()

    D2004_sco( 'POKLHD' )

    do while .not. vykdph_i->(eof())
      cVAL := D2004_rvs(vykdph_i->nradek_dph,1)
      EVAL( COMPILE( cVAL ))

      *
      ** vývoz zboží §66 - ostatní plnìní osvobozeno od danì **
      if (vykdph_i->nradek_dph = 430 .or. vykdph_i->nradek_dph = 440)
        if( vykdph_i->lsluzba, uskutpl->nvyvozzboz += vykdph_i->nzakld_dph, ;
                               uskutpl->nvyvozsluz += vykdph_i->nzakld_dph  )
      endif

      vykdph_i->(dbSkip())
    enddo

    D2004_sco()
  endif
return nil
