/*******************************************************************************
  HIM_MAJ.PRG
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"
#include "..\HIM\HIM_HIM.ch"


* Zrušení karty HIM + ZVI
*===============================================================================
FUNCTION HIM_MAJ_del( oDlg)
  Local fiMAJ := oDlg:dataManager:drgDialog:dbName
  Local isHIM := ( fiMAJ = 'MAJ')
  Local cTASK   := IF( isHIM, 'HIM', 'ZVI')
  Local fiZmaju  := 'ZMAJU'  + IF( isHIM, '','Z' )
  Local fiZmajn  := 'ZMAJN'  + IF( isHIM, '','Z' )
  Local fiMaj_ps := 'MAJ' + IF( isHIM, '','Z' ) + '_PS'
  LOCAL aFILEs := { fiZMAJU, fiZMAJN, fiMAJ_ps }, x, n
  LOCAL aTAGs  := { 1, 1, 1}, aOldTAGs := {,,}, aRECs := { {},{},{} }
  LOCAL lZMAJU, lZMAJN, lMAJ_ps, lDel := .F.
  LOCAL cMsg := 'Zrušit kartu investièního majetku ?'
  Local cAktOBD := uctOBDOBI:&(cTask):cObdobi
  *
  local  cobdZar      := (fiMAJ)->cobdZar
  local  nrok_zar     := year(ctod('01.' +left(cobdZar,2) +'.' +right(cobdZar,2)))
  local  nrokObd_last := ( uctOBDOBI_LAST:&ctask:nrok *100) +uctOBDOBI_LAST:&ctask:nobdobi
  local  nrokObd_zar  := ( nrok_zar *100) +val(left(cobdZar,2))


  IF ! Empty( (fiMaj)->cObdPosOdp) .and. ( cAktObd <> (fiMaj)->cObdZar)
    cMsg := 'NELZE ZRUŠIT !;;Investièní majetek < & - & >;'+;
                            'nelze zrušit, nebo ji došlo k úèetnímu odpisu  (1)!'
    drgMsgBox(drgNLS:msg( cMsg, (fiMAJ)->nInvCis, (fiMAJ)->cNazev))
    RETURN lDel
  ENDIF

  lDel :=  (  Empty( (fiMaj)->cObdPosOdp) .and. nrokObd_zar = nrokObd_last ) .or. ;
           ( !Empty( (fiMaj)->cObdPosOdp) .and. ( (fiMaj)->cObdPosOdp = (fiMaj)->cObdZar) .and.  (fiMaj)->nTypVypUO = 1 )

  if ! lDel
    cMsg := 'NELZE ZRUŠIT !;;Investièní majetek < & - & >;'+;
                            'nelze zrušit, nebo ji došlo k úèetnímu odpisu (2)!'
    drgMsgBox(drgNLS:msg( cMsg, (fiMAJ)->nInvCis, (fiMAJ)->cNazev))
    RETURN .f.

  ENDIF

*  IF Empty( (fiMaj)->cObdPosOdp)
    IF drgIsYesNo(drgNLS:msg( cMsg ))
      cScope := IF( isHIM, StrZero( (fiMaj)->nTypMaj,3), StrZero( (fiMaj)->nUcetSkup,3) ) + ;
                           StrZero( (fiMaj)->nInvCis,15)
      FOR x := 1 TO LEN( aFILES)
        IF( Used( aFILEs[x]), NIL, drgDBMS:open( aFILEs[x]))
        aOldTAGs[x] := ( aFILEs[x])->( AdsSetOrder( aTAGs[x]))
        ( aFILEs[x])->( Ads_SetScope(SCOPE_TOP   , cScope), ;
                        Ads_SetScope(SCOPE_BOTTOM, cScope), DbGoTop() )

        ( aFILEs[x])->( dbEVAL( {|| AADD( aRECs[x], ( aFILEs[x])->( RecNO()) )}))

        ( aFILEs[x])->( Ads_ClearScope(SCOPE_TOP)   , ;
                        Ads_ClearScope(SCOPE_BOTTOM), DbGoTop() )
        ( aFILEs[x])->( AdsSetOrder( aOldTAGs[x]))
      NEXT
      lZMAJU  := IF( LEN( aRECs[1]) = 0, .T., (fiZMAJU)->( sx_RLock( aRECs[1])))
      lZMAJN  := IF( LEN( aRECs[2]) = 0, .T., (fiZMAJN)->( sx_RLock( aRECs[2])))
      lMAJ_ps := IF( LEN( aRECs[3]) = 0, .T., (fiMAJ_ps)->( sx_RLock( aRECs[3])))

      IF (fiMAJ)->( sx_RLock()) .and. lZMAJU .and. lZMAJN .and. lMAJ_ps
         FOR x := 1 TO LEN( aRECs)
           IF x = 1    // ZMAJU ... zruší i zaúètování
             AEval( aRECs[x], {|nREC| ( aFILEs[x])->(dbGoTo(nREC)),;
                                      HIM_UcetPOL_DEL( cTASK)     ,;
                                      ( aFILEs[x])->(dbDelete())  } )
           ELSE
             AEval( aRECs[x], {|nREC| ( aFILEs[x])->(DbGoTo(nREC), dbDelete()) } )
             ( aFILEs[x])->( dbUnlock())
           ENDIF
         NEXT
         (fiMAJ)->( dbDelete(), dbUnlock())
         lDel := .T.
      ELSE
        drgMsgBox(drgNLS:msg('MAJETEK se nepodaøilo zrušit,;'+;
                             'nebo související záznamy jsou blokovány jinım uivatelem !!!'))
      ENDIF
    ENDIF

*  ELSE
*    cMsg := 'NELZE ZRUŠIT !;;Investièní majetek < & - & >;'+;
*                            'nelze zrušit, nebo ji došlo k úèetnímu odpisu (3)!'
*    drgMsgBox(drgNLS:msg( cMsg, (fiMAJ)->nInvCis, (fiMAJ)->cNazev))
*  ENDIF

RETURN lDEL

* Generuje úèetní zmìny
*===============================================================================
FUNCTION HIM_ZMajU_IM( lNewREC, isHIM)
  Local  fiMAJ   := If( isHIM, 'Maj', 'MajZ')
  Local  fiZmajU := 'ZMAJU'  + IF( isHIM,  '','Z' )
  Local  lWrite, lOK, cKey, cErr := '???'
  Local  cTask := IF( isHIM, 'HIM', 'ZVI' ), uctLikv
  Local  cUserAbb := SYSCONFIG( 'SYSTEM:cUSERABB' ), cScope, aScope, nRec, nCount
  Local  cDenik   := IF( isHIM, PadR( SysConfig( 'Im:cDenikIm'     ), 2 ),;
                                PadR( SysConfig( 'Zvirata:cDenikZv'), 2 ))

  drgDBMS:open( 'C_TypPoh',,,,,'C_TypPoha')
  *
  If( !lNewRec, (fiZmaju)->( dbGoBottom()), Nil )
  *
  lWrite := If( lNewRec, AddRec( fiZmajU), ReplRec( fiZmajU))
  If lWrite
     mh_COPYFLD( fiMAJ, fiZmajU )
     *
     cKEY := IF( isHIM, I_DOKLADY, Z_DOKLADY) + (fiMAJ)->cTypPohybu
     lOK := C_TypPoha->( dbSEEK( cKEY,, 'C_TYPPOH02'))
     (fiZmaju)->cTypDoklad := IF( lOK, C_TypPoha->cTypDoklad, cErr )
     (fiZmaju)->cTypPohybu := IF( lOK, C_TypPoha->cTypPohybu, cErr )
     *
     (fiZmaju)->nOrdItem   := If( lNewRec, HIM_OrdItem( (fiZmaju)->nDoklad, isHIM), (fiZmaju)->nOrdItem )
     (fiZmaju)->nKarta     := VAL( RIGHT( ALLTRIM(C_TypPoha->cTypDoklad),3))   // (fiCIS)->nKarta
     (fiZmaju)->nTypPohyb  := C_TypPoha->nTypPohyb   // (fiCIS)->nTypPohyb
     (fiZmaju)->dDatZmeny  := (fiMAJ)->dDatZar
     (fiZmaju)->cObdobi    := (fiMAJ)->cObdZar
     (fiZmaju)->nRok       := year ( (fiMAJ)->dDatZar )
     (fiZmaju)->nObdobi    := month( (fiMAJ)->dDatZar )

*     (fiZmaju)->nRok       := uctOBDOBI:&cTask:nROK    // GetROK()
*     (fiZmaju)->nObdobi    := uctOBDOBI:&cTask:nObdobi // GetOBD()

     (fiZmaju)->nPorZmeny  := Val( Right( (fiMAJ)->cObdZar, 2) + ;
                               Left( (fiMAJ)->cObdZar, 2)  + '99' )
     (fiZmaju)->nZustCenaU := (fiMAJ)->nCenaVstU - (fiMAJ)->nOprUct
     (fiZmaju)->cUserAbb   := cUserAbb
     (fiZmaju)->cUloha     := IF( isHIM, 'I', 'Z' )
     (fiZmaju)->cDenik     := cDenik
     (fiZmaju)->cUcetSkup := IF( isHIM, ALLTRIM( STR( (fiMAJ)->nTypMaj  )),;
                                        ALLTRIM( STR( (fiMAJ)->nUcetSkup)))
* ???     NsToZmaju()
     (fiZMAJU)->cNazPol1   := (fiMAJ)->cNazPol1
     (fiZMAJU)->cNazPol2   := (fiMAJ)->cNazPol2
     (fiZMAJU)->cNazPol3   := (fiMAJ)->cNazPol3
     (fiZMAJU)->cNazPol4   := (fiMAJ)->cNazPol4
     (fiZMAJU)->cNazPol5   := (fiMAJ)->cNazPol5
     (fiZMAJU)->cNazPol6   := (fiMAJ)->cNazPol6

     (fiZmaju)->( dbCommit(),  dbUnlock())
     *
     HIM_SumMaj_IM( lNewREC, isHIM)
     *
     (fiZmaju)->( dbRLock())
     uctLikv := UCT_likvidace():New(Upper( (fiZmaju)->cUloha) + Upper( (fiZmaju)->cTypDoklad),.T.)
     *
     HIM_LikCelDok( isHIM)
     (fiZmaju)->( dbUnlock())
  EndIf

RETURN .T.

* Generuje sumaèní záznamy
*-------------------------------------------------------------------------------
STATIC FUNCTION HIM_SumMAJ_IM( lNewREC, isHIM)
  Local  fiMAJ    := If( isHIM, 'Maj'   , 'MajZ')
  Local  fiSumMAJ := If( isHIM, 'SumMaj', 'SumMajZ')
*  Local  nLen     := (fiMAJ)->(FieldInfo( (fiMAJ)->(FieldPos('nInvCis')),FLD_LEN))
  ** !!! Maj ->nInvCis ... nLen = 6
  **     MajZ->nInvCis ... nLen = 10

  drgDBMS:open( fiSumMAJ)
  If !lNewRec
    cKey := IF( isHIM, StrZero( (fiMaj)->nTypMaj,3), StrZero( (fiMaj)->nUcetSkup,3) ) + ;
                       StrZero( (fiMaj)->nInvCis, 15)
    (fiSumMaj)->( dbSeek( cKey))
  EndIF

  lWrite := If( lNewRec, AddRec( fiSumMAJ), ReplRec( fiSumMAJ) )
  If lWrite
    HIM_SumMaj_Add( isHIM )
    (fiSumMAJ)->nRok    := VAL( mh_GETcRok4( (fiMaj)->cObdZar))
    (fiSumMAJ)->nObdobi := VAL( LEFT( (fiMaj)->cObdZar, 2))
    (fiSumMAJ)->( dbUnlock())
  Endif

RETURN Nil

*
*-------------------------------------------------------------------------------
FUNCTION HIM_SumMaj_Add( isHIM)
  Local  fiMAJ    := If( isHIM, 'Maj'   , 'MajZ')
  Local  fiSumMAJ := If( isHIM, 'SumMaj', 'SumMajZ')

  (fiSumMaj)->nInvCis   := (fiMaj)->nInvCis
  IF isHIM
    (fiSumMaj)->nTypMaj   := (fiMaj)->nTypMaj
  ELSE
    (fiSumMaj)->nUcetSkup := (fiMaj)->nUcetSkup
  ENDIF
  (fiSumMaj)->nZnAkt    := (fiMaj)->nZnAkt
  (fiSumMaj)->cObdobi   := (fiMaj)->cObdZar
  (fiSumMaj)->nVsCenDPS := (fiMaj)->nCenaVstD
  (fiSumMaj)->nVsCenUPS := (fiMaj)->nCenaVstU
  (fiSumMaj)->nOprUctPS := (fiMaj)->nOprUctPS
  (fiSumMaj)->nZuCenUPS := (fiMaj)->nCenaVstU - (fiMaj)->nOprUctPS
  (fiSumMaj)->nVsCenUKS := (fiSumMaj)->nVsCenUPS - (fiSumMaj)->nZmVstCMin ;
                            + (fiSumMaj)->nZmVstCKla
  (fiSumMaj)->nOprUctKS := (fiSumMaj)->nOprUctPS - (fiSumMaj)->nZmOprMin  ;
                            + (fiSumMaj)->nZmOprKla
  (fiSumMaj)->nZuCenUKS := (fiSumMaj)->nVsCenUKS - (fiSumMaj)->nOprUctKS
RETURN Nil

* Aktualizace zlikvidované èástky zmìnového dokladu + UcetSys
*-------------------------------------------------------------------------------
FUNCTION HIM_LikCelDok( isHIM)
  Local  fiZmajU := IF( isHIM, 'ZMAJU', 'ZMAJUZ' )
  Local  cKey := IF( isHIM, 'I','Z') + (fiZMajU)->cObdobi
  Local nLikCelDok := CmpLikDok( isHIM), nRec

  If nLikCelDok <> 0  // .and. ReplRec( 'ZMajU')
     (fiZMajU)->nLikCelDok := nLikCelDok
     drgDBMS:open('UcetSYS' )
     nRec := UcetSys->( RecNO())
     UcetSys->( dbSeek( Upper( cKey),,'UCETSYS2'))
     If ReplRec( 'UcetSys')  ;  UcetSys->cUctKdo := SysConfig( 'System:cUserAbb')
                                UcetSys->dUctDat := Date()
                                UcetSys->cUctCas := Time()
       UcetSys->( dbUnlock())
     Endif
     UcetSys->( dbGoTO( nREC))
*     DCrUnlock( 'ZMajU')
  Endif
Return Nil

* Celkem zlikvidovanÁ  èástka pohyb. dokladu - vıpoèet
*-------------------------------------------------------------------------------
STATIC FUNCTION CmpLikDok( isHIM)
 Local  fiZmajU := IF( isHIM, 'ZMAJU', 'ZMAJUZ' )
  Local nLikCelDok := 0, nPos
  Local anOrdItem := {}, acNaturUct := { '20', '21', '22', '23', '24', '25' }
  Local cDenik    := If( isHIM, PadR( SysConfig( 'Im:cDenikIm'     ), 2 ),;
                                PadR( SysConfig( 'Zvirata:cDenikZv'), 2 ) )
  Local cKey := cDenik + StrZero( (fiZMajU)->nDoklad, 10)

  FOrdRec( { 'UcetPol, 1'} )
  UcetPOL->( mh_SetScope( Upper( cKey)) )
  Do While !UcetPol->( Eof())
    If UcetPol->nOrdUcto == 1     // Strana MD
       nPos := ASCAN( anOrdItem, UcetPol->nOrdItem)
       If nPos == 0               // Poloka dokladu dosud nezahrnuta do souètu
          nPos := ASCAN( acNaturUct, UcetPol->cTypUct)
          If nPos == 0            // Nejedná se o naturální úètování
             aAdd( anOrdItem, UcetPol->nOrdItem)
             nLikCelDok += UcetPol->nKcMD
          Endif
       EndIf
    Endif
    UcetPol->( dbSkip())
  EndDo
  UcetPOL->( mh_ClrScope())
  FOrdRec()
Return( nLikCelDok)