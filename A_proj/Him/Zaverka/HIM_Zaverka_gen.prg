********************************************************************************
* HIM_Zaverka.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch"
#include "XBP.Ch"
#include "dmlb.ch"
#include "..\HIM\HIM_Him.ch"
#include "..\A_main\ace.ch"

# Define   START_UZV  1
# Define   END_UZV    2

# Define   FILES_arch_HIM    { 'Maj', 'UMaj', 'DMaj', 'ZMajU', 'ZMajN', 'SumMaj', 'MajObd' }

# Define   FILES_arch_ZVI    { 'MajZ', 'UMajZ', 'DMajZ', 'ZMajUZ', 'ZMajNZ', 'SumMajZ', 'MajZObd',;
                               'ZvKarty' , 'ZvKartyZ' , 'ZvZmenHD' ,;
                               'ZvZmenIT', 'ZvKarOBD' , 'ZvZmObd'  , 'KategZvi',;
                               'Zvirata' , 'RegZviPr' }

********************************************************************************
* HIM_ZAVERKA ... Generování roèní daòové a úèetní závìrky
********************************************************************************
CLASS HIM_ZAVERKA_gen  FROM drgUsrClass, HIM_Main
EXPORTED:
  VAR     cTASK, lDouctovat, HimPohyby
  VAR     parent, nRoundOdpi, nROK, nObdobi, cErrorLog
  *
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart
  METHOD  StartZAVERKA, ArchBeforeUZV, RestFromArch, RestUcetPol

HIDDEN
  VAR     msg, dm
  METHOD  RokUZV, StavPOC, PocetMES, Zaverka, delVYRAZEN
  METHOD  GenDmaj, NewDanODPIS
  METHOD  GenUmaj, NewUctODPIS

ENDCLASS

********************************************************************************
METHOD HIM_ZAVERKA_gen:init(parent, cTASK)
  Local cKEY

  DEFAULT cTASK TO 'HIM'
  ::drgUsrClass:init(parent)
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  ::parent          := parent:drgDialog
  ::cTASK           := cTASK
  * Stejný FRM je použit pro HIM a ZVI
  ::parent:formName := 'HIM_ZAVERKA_gen'
  *
  ::nROK       := uctOBDOBI:&(::cTask):nRok
  ::nObdobi    := LastOBDOBI( IF( cTASK = 'HIM', 'I', 'Z'), 3 )
  *
  ::lDouctovat := .F.
  ::nRoundOdpi := SysConfig( IF( ::isHIM, 'Im','Zvirata') + ':nRoundOdpi')
  ::cErrorLog  := ''
  *
  drgDBMS:open( 'c_DanSkp' )
  drgDBMS:open( ::fiUMAJ   )
  drgDBMS:open( ::fiDMAJ   )
  drgDBMS:open( ::fiRokUZV )
  drgDBMS:open( ::fiZMAJUw ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP

RETURN self

********************************************************************************
METHOD HIM_ZAVERKA_gen:drgDialogInit(drgDialog)
  drgDialog:formHeader:title := ::cTASK + ' - ' + drgDialog:formHeader:title
RETURN

********************************************************************************
METHOD HIM_ZAVERKA_gen:drgDialogStart(drgDialog)
  ::dm := drgDialog:dataManager
RETURN

* Výpoèet
********************************************************************************
METHOD HIM_ZAVERKA_gen:StartZAVERKA()
  Local lOK, lUzv, nChoice

  *
  lUzv := (::fiRokUZV)->( dbSeek( ::nROK,, AdsCtag(1) ))
  If lUzv
    nChoice := AlertBOX( , "Uzávìrka roku [ " + STR( ::nROK, 4) + " ] již byla provedena !" ,;
                          { "~Opakovat uzávìrku", "~Návrat" }  ,;
                          XBPSTATIC_SYSICON_ICONQUESTION,;
                          'Zvolte možnost'    )

    If nChoice == 1
      nChoice := AlertBOX( , "Opakování uzávìrky znamená, že budou nejprve obnoveny ;" +;
                             "datové soubory, které se podílejí na uzávìrce, do stavu ;"+;
                             "pøed roèní uzávìrkou.                                   ;"+;
                             "Pak bude možné roèní uzávìrku opakovat !",;
                            { "~Opakovat uzávìrku", "~Návrat" }  ,;
                            XBPSTATIC_SYSICON_ICONQUESTION,;
                            'Opakovaná uzávìrka roku [ ' + STR( ::nROK, 4) + ' ]'    )
       If nChoice == 1
          ::RestFromARCH()
       Else
         RETURN NIL
       Endif
    Else
      RETURN NIL
    Endif
  EndIf
  *
  IF drgIsYESNO(drgNLS:msg( 'Provést daòovou a úèetní uzávìrku roku  [ & ]  ?' , ::nROK ) )
    *
    drgDBMS:open( ::fiMAJ   )
    drgDBMS:open( ::fiZMAJU )
    drgDBMS:open( ::fiZMAJN )
    drgDBMS:open( ::fiSUMMAJ)
    drgDBMS:open( ::fiUMAJ  )
    drgDBMS:open( ::fiDMAJ  )
    drgDBMS:open( ::fiMajObd)
    * Pokud se nepovede archivace, nepovolit roèní uzávìrku
    IF .not. ( lOK := ::ArchBeforeUzv() )
      RETURN NIL
    ENDIF
    *
    oSession_data:beginTransaction()
    BEGIN SEQUENCE
      ::Zaverka()
      oSession_data:commitTransaction()

    RECOVER USING oError
*      lok := .f.
      oSession_data:rollbackTransaction()

    END SEQUENCE
    (::fiMAJ)->( dbUnlock())
    *
*    ::Zaverka()
    *
  Endif

RETURN Nil

**Hidden************************************************************************
METHOD HIM_ZAVERKA_gen:ZAVERKA()
  Local nRecM, cTagM, nRecCount, cMsg
  Local nVsCenDRPS, nVsCenURPS
  *
  (::fiSUMMAJ)->( AdsSetOrder( 2))
  nRecCount := dbCount( ::fiMAJ)
  nRecM := (::fiMAJ)->( RecNo())
  cTagM := (::fiMAJ)->( AdsSetOrder( 0))

  *  Pøed uzávìrkou odložíme MAJ do MAJOBD, resp. MAJZ do MAJZOBD.
  /* To se týká 12. mìsíce, který musíme odložit nyní. Pøed založením ledna nového
     roku je již pozdì, nebo v souborech MAJ (MAJZ) jsou po uzávìrce vypoèteny
     odpisy pro další mìsíc, tedy pro leden.
     Pro všechny ostatní mìsíce toto odložení probìhne pøi založení nového období,
     viz. HIM_preAppendObdobi()
  */
  HIM_MajObd( ::nRok, ::nObdobi, ::cTask)
  *
  ( ::fiMAJ)->( AdsSetOrder( 0))

  IF lLocked := (::fiMAJ)->( FLock())
    *
    ::HimPohyby        := HIM_Pohyby_Crd():new( ::parent, ::cTask)
    ::HimPohyby:nKarta := 205
    *
    (::fiMAJ)->( dbGoTop())
    * Založí se záznam do RokUzv a nahodí se indikace spuštìní uzávìrky
    IF( lOK := ::RokUzv( START_UZV))
      cMsg := 'Probíhá závìrka roku '
      ::msg:WriteMessage( drgNLS:msg(cMsg))

      cMsg += ' [' + STR(::nROK,4 ) + ' ] ...'
      drgServiceThread:progressStart(drgNLS:msg( cMsg, ::fiMAJ), nRecCount )

      DO WHILE ! (::fiMAJ)->( EOF())

        nVsCenDRPS := ::StavPoc( ::fiDMAJ)
        nVsCenURPS := ::StavPoc( ::fiUMAJ)
        *
        If AddRec( ::fiDMAJ) .and. AddRec( ::fiUMAJ)
          ::GenDmaj( nVsCenDRPS)    // Generuje záznam do DMaj pro uzavíraný rok
          ::GenUmaj( nVsCenURPS)    // Generuje záznam do UMaj pro uzavíraný rok
          If (::fiMAJ)->nZnAkt == VYRAZEN .and. (::fiMAJ)->nZnAktD == VYRAZEN

            (::fiMAJ)->( dbDelete())
          **  ::DelVYRAZEN()
          ElseIf (::fiMAJ)->nOdpiSk = 8 //- 25.1.06
            ::NewUctOdpis()             // Výpoèet úèetních odpisù pro nový rok
            ::NewDanOdpis()             // Výpoèet daòových odpisù pro nový rok
          Else
            ::NewDanOdpis()             // Výpoèet daòových pro nový rok
            ::NewUctOdpis()             // Výpoèet úèetních odpisù pro nový rok
          EndIf
          (::fiDMAJ)->( dbUnlock())
          (::fiUMAJ)->( dbUnlock())
        EndIf
        *
        (::fiMAJ)->( dbSkip())
        drgServiceThread:progressInc()

      ENDDO
      drgServiceThread:progressEnd()
      *  V souboru RokUzv se aktualizují údaje o dokonèení uzávìrky
      ::RokUzv( END_UZV )
      *
      ::msg:WriteMessage( drgNLS:msg('Roèní závìrka byla dokonèena ...'), DRG_MSG_WARNING )
      cMsg := 'Roèní závìrka za rok [ & ] byla dokonèena !'
      drgMsgBox(drgNLS:msg( cMsg, ::nROK ), XBPMB_INFORMATION )
      ::msg:WriteMessage(,0)
      *
    EndIf
*    (::fiMAJ)->( dbUnlock())     //  køièí v transakci- 14.7.11
  Else
    drgMsgBox(drgNLS:msg('Roèní závìrka neprobìhla - soubor majetku je blokován jiným uživatelem ...'))
  EndIf
**    (::fiMAJ)->( AdsSetOrder( cTagM), dbGoTo( nRecM))
  (::fiMAJ)->( AdsSetOrder( cTagM), dbGoTop())

RETURN Nil

********************************************************************************
METHOD HIM_ZAVERKA_gen:destroy()
  *
  (::fiZMajUw)->( dbCloseArea())
  *
  ::cTASK    := ::isHIM   := ::fiMAJ  := ::fiZMAJU  := ::fiCIS :=  ;
  ::fiSUMMAJ := ::fiUMAJ  := ::fiDMAJ := ::fiRokUZV := ;
  ::nROK     := ::nObdobi := ::parent := ::lDouctovat := ::HimPohyby := ::cErrorLog := ;
   Nil
RETURN self

* Aktualizace záznamu o prùbìhu roèní uzávìrky
** HIDDEN **********************************************************************
METHOD HIM_ZAVERKA_gen:RokUZV( nMOD)
  Local  lExist, lOK

  If nMOD == START_UZV
     If( lExist := (::fiRokUZV)->( dbSeek( ::nROK)))
       DelRec( ::fiRokUZV)
     EndIf
     If ( lOK :=  AddRec( ::fiRokUZV))
       (::fiRokUZV)->nRokUzv    := ::nROK
       (::fiRokUZV)->dDateStart := DATE()
       (::fiRokUZV)->cTimeStart := TIME()
       (::fiRokUZV)->lUzvRun    := YES
       (::fiRokUZV)->cUserAbb   := SysConfig( 'System:cUserAbb')
       mh_WrtZmena( ::fiRokUZV, .t.)
     Else
      drgMsgBox(drgNLS:msg('Roèní uzávìrka neprobìhla !!!;;'+;
                           'Soubor roèních uzávìrek je blokován jiným uživatelem ...'))
     Endif

  ElseIf nMOD == END_UZV
     (::fiRokUZV)->dDateEnd   := DATE()
     (::fiRokUZV)->cTimeEnd   := TIME()
     (::fiRokUZV)->lUzvRun    := NO
     (::fiRokUZV)->lUzvOk     := YES
     *
     ::cErrorLog := IF( EMPTY( ::cErrorLog), 'Nebyly zjištìny žádné chyby ...',;
                                             'Zjištìné chyby pøi uzávìrce' + CRLF + CRLF + ::cErrorLog )

     (::fiRokUZV)->mErrorLog  := ::cErrorLog
     *
     (::fiRokUZV)->( dbUnlock())
     ::parent:dataManager:has('M->cErrorLog'):set( ::cErrorLog)
  Endif
Return( lOK)

* Zjistí poè.vstupní cenu úèetní (daòovou)
* 1.uzávìrka ze souboru SumMAJ, další uzv. z UMAJ (DMAJ)
** HIDDEN **********************************************************************
METHOD HIM_ZAVERKA_gen:StavPOC( cAlias)
  Local nRetVal, nCount, nRec := ( cAlias)->( RecNo())
  Local cScope := IF( ::isHIM, StrZero( (::fiMAJ)->nTypMaj, 3)   + StrZero( (::fiMAJ)->nInvCis, 15),;
                               StrZero( (::fiMAJ)->nUcetSkup, 3) + StrZero( (::fiMAJ)->nInvCis, 15) )

  ( cAlias)->( AdsSetOrder(1), mh_SetSCOPE( cScope))
  nCount := dbCount( cAlias)
  IF nCount > 0     // Majetek prochází 2. nebo vyšší roèní uzávìrkou
    ( cAlias)->( dbGoBottom())
     nRetVal := IIf( cAlias == ::fiDMAJ, (::fiDMAJ)->nVsCenDRKS,;
                IIf( cAlias == ::fiUMAJ, (::fiUMAJ)->nVsCenURKS, 0 ) )
    ( cAlias)->( mh_ClrSCOPE())

  ELSE              // Majetek prochází 1. roèní uzávìrkou
    ( cAlias)->( mh_ClrSCOPE())
    ( ::fiSUMMAJ)->( mh_SetSCOPE( cScope))
    ( ::fiSUMMAJ)->( dbGoTop())
      nRetVal := IIf( cAlias == ::fiDMAJ, ( ::fiSUMMAJ)->nVsCenDPS,;
                 IIf( cAlias == ::fiUMAJ, ( ::fiSUMMAJ)->nVsCenUPS, 0 ) )
    ( ::fiSUMMAJ)->( mh_ClrSCOPE())
  ENDIF
 ( cAlias)->( dbGoTo( nRec))
RETURN( nRetVal)

*  Generuje záznam do DMAJ pøi roèní daòové uzávìrce
** HIDDEN **********************************************************************
METHOD HIM_ZAVERKA_gen:GenDmaj( nVsCenDRPS)
  Local nZustCenaD := (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan

  (::fiDMAJ)->nInvCis    := (::fiMAJ)->nInvCis
  IF   ::isHIM   ;  (::fiDMAJ)->nTypMaj    := (::fiMAJ)->nTypMaj
  ELSE           ;  (::fiDMAJ)->nUcetSkup  := (::fiMAJ)->nUcetSkup
                    (::fiDMAJ)->cUcetSkup  := (::fiMAJ)->cUcetSkup
  ENDIF
  (::fiDMAJ)->nTypDOdpi  := (::fiMAJ)->nTypDOdpi
  (::fiDMAJ)->cTypSKP    := (::fiMAJ)->cTypSKP
  (::fiDMAJ)->nRokOdpisu := ::nROK
  (::fiDMAJ)->cOdpiSkD   := (::fiMAJ)->cOdpiSkD
  (::fiDMAJ)->nOdpiSkD   := (::fiMAJ)->nOdpiSkD
  (::fiDMAJ)->nCenaPorD  := (::fiMAJ)->nCenaPorD
  (::fiDMAJ)->nDotaceDAN := (::fiMAJ)->nDotaceDAN
  (::fiDMAJ)->nVsCenDRPS := nVsCenDRPS
  (::fiDMAJ)->nOprDanRPS := (::fiMAJ)->nOprDanPS
  (::fiDMAJ)->nZuCenDRPS := (::fiDMAJ)->nVsCenDRPS - (::fiDMAJ)->nOprDanRPS
  (::fiDMAJ)->nProcDanOd := (::fiMAJ)->nProcDanOd
  (::fiDMAJ)->nDanOdpRok := (::fiMAJ)->nDanOdpRok
  (::fiDMAJ)->nVsCenDRKS := (::fiMAJ)->nCenaVstD
  (::fiDMAJ)->nOprDanRKS := (::fiMAJ)->nOprDan + ;
        If( nZustCenaD >= (::fiMAJ)->nDanOdpRok, (::fiMAJ)->nDanOdpRok, nZustCenaD )
  (::fiDMAJ)->nZuCenDRKS := (::fiDMAJ)->nVsCenDRKS - (::fiDMAJ)->nOprDanRKS
  mh_WrtZmena( ::fiDMAJ, .T.)
Return Nil

* Výpoèet daòových odpisù pro nový rok
** HIDDEN **********************************************************************
METHOD HIM_ZAVERKA_gen:NewDanOdpis()
  Local nDanOdpRok := 0, nRocniSazba := 0
  Local nZustCenaD := (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan
  *
  local  nDOMes, npocMesDO
  local  nDOMes_12, npocMes_12, nDOMes_24, npocMes_24

  /* Daòová skupina 1A ( resp. 7 ) se mìní na daò.skupinu 2  // od r. 2008
  IF (::fiMAJ)->nOdpiSk = 7
    (::fiMAJ)->nOdpiSk := 2
    (::fiMAJ)->cOdpiSk := '2   '
  ENDIF
  */

  IF (::fiMAJ)->nZnAktD == AKTIVNI

    c_DanSkp->( dbSeek( Upper( (::fiMAJ)->cOdpiSkD),,'C_DANSKP1'))

  //  Maj->nRokyDanOd += 1   7.11.2000
    (::fiMAJ)->nRokyDanOd += If( (::fiMAJ)->nOprDan >= (::fiMAJ)->nCenaVstD, 0, 1 )  // 7.11.2000 - JaCHv
    (::fiMAJ)->nRokZvDanO += If( Empty( (::fiMAJ)->cObdZvys), 0, 1)
    (::fiMAJ)->nOprDanPS  += If( nZustCenaD >= (::fiMAJ)->nDanOdpRok, (::fiMAJ)->nDanOdpRok,;
                                                                       nZustCenaD      )
    (::fiMAJ)->nOprDan    += If( nZustCenaD >= (::fiMAJ)->nDanOdpRok, (::fiMAJ)->nDanOdpRok,;
                                                                       nZustCenaD      )
    (::fiMAJ)->nZnAktD    := If( (::fiMAJ)->nCenaVstD == (::fiMAJ)->nOprDan, ODEPSAN, (::fiMAJ)->nZnAktD )
    (::fiMAJ)->nZnAkt     := If( (::fiMAJ)->nCenaVstU == (::fiMAJ)->nOprUct, ODEPSAN, (::fiMAJ)->nZnAkt  )

    If (::fiMAJ)->nZnAkt == ODEPSAN
      (::fiMAJ)->nOprUctPS  := (::fiMAJ)->nOprUct
      (::fiMAJ)->nUctOdpRok := 0
      (::fiMAJ)->nUctOdpMes := 0
      (::fiMAJ)->nProcUctOd := 0
    ENDIF
    *
    If (::fiMAJ)->nZnAktD <> ODEPSAN  .or. ;
       ( (::fiMAJ)->nZnAktD == ODEPSAN .and. (::fiMAJ)->nCenaVstD > (::fiMAJ)->nOprDan )

  **    IF !(::fiMAJ)->lHmotnyIM  // (::fiMAJ)->nOdpiSkD == 8    //- 25.1.06
      IF (::fiMAJ)->nOdpiSkD = 8    //- 25.1.06
        nDanOdpRok := (::fiMAJ)->nUctOdpMes * 12

      ELSEIF (::fiMAJ)->cOdpiSkD = '1M'   // 1M = 12 mìsícù    nOdpiSkD = 7
        nDanOdpRok := mh_RoundNumb(( (::fiMAJ)->nCenaVstD / (::fiMAJ)->nRokyOdpiD ), ::nRoundOdpi) * 12

* NEw JS
      elseIf (::fiMAJ)->cOdpiSkD = '1M1'  // 1M1 = 12 mìsícù  nOdpiSkD = 15
        nDOMes    := mh_RoundNumb( ((::fiMAJ)->nCenaVstD / 12), ::nRoundOdpi )
        nPocMesDO := (::fiMAJ)->nPocMesDO

        if nPocMesDO < 12
           nDanOdpRok := nDOMes * nPocMesDO
        else
           ndanOdpRok := nZustCenaD
        endif

      ELSEIF (::fiMAJ)->cOdpiSkD = '2M'   // 2M = 24 mesicu   nOdpiSkD = 9
        IF MAJ->nPocMesDO < 12
           nDanOdpRok := ( mh_RoundNumb((( (::fiMAJ)->nCenaVstD * 0.6) / 12), ::nRoundOdpi) * ( 12 - (::fiMAJ)->nPocMesDO)) +;
                         ( mh_RoundNumb((( (::fiMAJ)->nCenaVstD * 0.4) / 12), ::nRoundOdpi) * (::fiMAJ)->nPocMesDO)
        ELSE
           nDanOdpRok := mh_RoundNumb((( (::fiMAJ)->nCenaVstD * 0.4) / 12), ::nRoundOdpi) * ( 24 - (::fiMAJ)->nPocMesDO)
        ENDIF

* NEw JS
      elseif (::fiMAJ)->cOdpiSkD = '2M2'   // 2M2 - 24 mesicu  nOdpiSkD = 14
        nDOMes_12  := mh_RoundNumb( (((::fiMAJ)->nCenaVstD * 0.6) / 12), ::nRoundOdpi )
        nDOMes_24  := mh_RoundNumb( (((::fiMAJ)->nCenaVstD * 0.4) / 12), ::nRoundOdpi )
        nPocMesDO  := (::fiMAJ)->nPocMesDO

        do case
        case nPocMesDO <= 12                         // 1-12 60%
          nDanOdpRok := nDOMes_12 * nPocMesDO

        case nPocMesDO > 12 .and. nPocMesDO < 24    // 1-12 60%  + 13-24 40%
          npocMes_12 := ( 24 - nPocMesDO )
          nDanOdpRok := nDOMes_12 * npocMes_12

          npocMes_24 := ( nPocMesDO - npocMes_12 )
          nDanOdpRok += nDOMes_24 * npocMes_24
        otherwise                                    // 13-24 40%

          ndanOdpRok := nZustCenaD
        endCase

      ELSEIF (::fiMAJ)->nOdpiSkD >= 10 .and. (::fiMAJ)->nOdpiSkD <= 13     // nehmotny na mìsíce
        nDanOdpRok := mh_RoundNumb(( (::fiMAJ)->nCenaVstD / (::fiMAJ)->nMesOdpiD ), ::nRoundOdpi) * 12

      ELSEIF (::fiMAJ)->nOdpiSkD >= 14     // hmotny na mìsíce  28.7.2011
        nDanOdpRok := mh_RoundNumb(( (::fiMAJ)->nCenaVstD / (::fiMAJ)->nMesOdpiD ), ::nRoundOdpi) * 12

      ELSE
        Do Case
          Case (::fiMAJ)->nTypDOdpi == DO_ROVNOMERNY  //1
            nRocniSazba := HIM_ProcRDO( (::fiMAJ)->cObdZar   ,;
                                        (::fiMAJ)->cOdpiSkD  ,;
                                        (::fiMAJ)->nUplProc  ,;
                                        (::fiMAJ)->nRokyDanOd,;
                                        ::cTASK  )   // 1.11.2005
            nDanOdpRok  := ( (::fiMAJ)->nCenaVstD * nRocniSazba ) / 100

          Case (::fiMAJ)->nTypDOdpi == DO_ZRYCHLENY .and. Empty( (::fiMAJ)->cObdZvys)
            nDanOdpRok :=  2 * ( (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan ) / ;
                              ( c_DanSkp->nZrDalsi - (::fiMAJ)->nRokyDanOd )

          Case (::fiMAJ)->nTypDOdpi == DO_ZRYCHLENY .and. !Empty( (::fiMAJ)->cObdZvys)
            nDanOdpRok :=  2 * ( (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan ) / ;
                              ( c_DanSkp->nZrZvCena - (::fiMAJ)->nRokZvDanO )
        EndCase
      ENDIF
    EndIf
    * new
    IF (::fiMAJ)->nOprDanPS > (::fiMAJ)->nCenaVstD
      ::cErrorLog += IF( ::isHIM, 'Typ maj. ' + Str( (::fiMAJ)->nTypMaj, 3 ),;
                                  'Úèet.sk. ' + (::fiMAJ)-> cUcetSkup ) + ;
                     ' Inv.èís. ' + Str( (::fiMAJ)->nInvCis, 15 ) + ;
                     ' - Poè.stav oprávek daò. je vìtší než vstupní cena daòová' + CRLF
      RETURN NIL
    ENDIF
    * endnew
    If nDanOdpRok > ( (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDanPS)
       (::fiMAJ)->nDanOdpRok := mh_RoundNumb( (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDanPS, ::nRoundOdpi )
    Else
       (::fiMAJ)->nDanOdpRok := mh_RoundNumb( nDanOdpRok, ::nRoundOdpi )
    EndIf
    (::fiMAJ)->nProcDanOd := ValToPerc( (::fiMAJ)->nCenaVstD, (::fiMAJ)->nDanOdpRok )

  ENDIF

Return Nil

*  Generuje záznam do UMAJ pøi roèní daòové uzávìrce
** HIDDEN **********************************************************************
METHOD HIM_ZAVERKA_gen:GenUmaj( nVsCenURPS)

  (::fiUMAJ)->nInvCis    := (::fiMAJ)->nInvCis
  IF   ::isHIM   ;  (::fiUMAJ)->nTypMaj    := (::fiMAJ)->nTypMaj
  ELSE           ;  (::fiUMAJ)->nUcetSkup  := (::fiMAJ)->nUcetSkup
                    (::fiUMAJ)->cUcetSkup  := (::fiMAJ)->cUcetSkup
  ENDIF
  (::fiUMAJ)->nTypUOdpi  := (::fiMAJ)->nTypDOdpi
  (::fiUMAJ)->cTypSKP    := (::fiMAJ)->cTypSKP
  (::fiUMAJ)->nRokOdpisu := ::nROK
  (::fiUMAJ)->cOdpiSk    := (::fiMAJ)->cOdpiSk
  (::fiUMAJ)->nOdpiSk    := (::fiMAJ)->nOdpiSk
  (::fiUMAJ)->nCenaPorU  := (::fiMAJ)->nCenaPorU
  (::fiUMAJ)->nDotaceUCT := (::fiMAJ)->nDotaceUCT
  (::fiUMAJ)->nVsCenURPS := nVsCenURPS
  (::fiUMAJ)->nOprUctRPS := (::fiMAJ)->nOprUctPS
  (::fiUMAJ)->nZuCenURPS := (::fiUMAJ)->nVsCenURPS - (::fiUMAJ)->nOprUctRPS
  (::fiUMAJ)->nProcUctOd := (::fiMAJ)->nProcUctOd
  (::fiUMAJ)->nUctOdpRok := (::fiMAJ)->nUctOdpRok
  (::fiUMAJ)->nVsCenURKS := (::fiMAJ)->nCenaVstU
  (::fiUMAJ)->nOprUctRKS := (::fiMAJ)->nOprUct
  (::fiUMAJ)->nZuCenURKS := (::fiUMAJ)->nVsCenURKS - (::fiUMAJ)->nOprUctRKS
   mh_WrtZmena( ::fiUMAJ, .T.)
Return Nil

* Výpoèet úèetních odpisù pro nový rok
** HIDDEN **********************************************************************
METHOD HIM_ZAVERKA_gen:NewUctOdpis()
  Local nRozdil := 0, nUctOdpRok, nUctOdpMes, nZCucetni, nPocetMES

  * 20.2.2014
  if (::fiMAJ)->nznAkt = ODEPSAN .and. ( (::fiMAJ)->nCenaVstU = (::fiMAJ)->nOprUct )
    (::fiMAJ)->nOprUctPS  := (::fiMAJ)->nOprUct
    (::fiMAJ)->nUctOdpRok := 0
    (::fiMAJ)->nUctOdpMes := 0
    (::fiMAJ)->nProcUctOd := 0
    Return Nil
  endif

  IF (::fiMAJ)->nZnAkt == AKTIVNI      // 1.11.2005
    If ::lDouctovat
      * zaúètování pøípadného rozdílu do výše plánu
      nRozdil := (::fiMAJ)->nUctOdpRok - ( (::fiMAJ)->nOprUct - (::fiMAJ)->nOprUctPS)
      If nRozdil <> 0
        If AddRec( ::fiZMAJUw)
          (::fiZMAJUw)->nDrPohyb   := IF( ::isHIM, DOUCTOVANI_ODPISU_HIM,;
                                                   DOUCTOVANI_ODPISU_ZS )   // = 97 , 197
          (::fiZMAJUw)->nZmenOprU  := nRozdil
**          (::fiZMAJUw)->nTypPohyb  := If( nRozdil > 0, 1, -1 )
*          ZmajU_Modi( K_INS, DOUCTOVANI_ODPISU, PorZmeny(),, nRozdil )
          ::HimPohyby:ZmajU_Modi( xbeK_INS, .F. )
          (::fiZMAJUw)->( dbUnlock())
        EndIf
        * SumMaj.Dbf,  UcetPol.Dbf   ??
        (::fiMAJ)->nOprUct  += nRozdil
        *
        (::fiUMAJ)->nOprUctRKS := (::fiMAJ)->nOprUct
        (::fiUMAJ)->nZuCenURKS := (::fiUMAJ)->nVsCenURKS - (::fiUMAJ)->nOprUctRKS
      Endif
    EndIf
    ** new 19.3.2012
    (::fiMAJ)->nZnAkt := If( (::fiMAJ)->nCenaVstU == (::fiMAJ)->nOprUct, ODEPSAN, (::fiMAJ)->nZnAkt  )

    If (::fiMAJ)->nZnAkt == ODEPSAN
      (::fiMAJ)->nOprUctPS  := (::fiMAJ)->nOprUct
      (::fiMAJ)->nUctOdpRok := 0
      (::fiMAJ)->nUctOdpMes := 0
      (::fiMAJ)->nProcUctOd := 0
      Return Nil
    ENDIF
    ** new
    (::fiMAJ)->nOprUctPS := (::fiMAJ)->nOprUct

    * new
    IF (::fiMAJ)->nOprUctPS > (::fiMAJ)->nCenaVstU
    ::cErrorLog += IF( ::isHIM, 'Typ maj. ' + Str( (::fiMAJ)->nTypMaj, 3 ),;
                                'Úèet.sk. ' + (::fiMAJ)-> cUcetSkup ) + ;
                   ' Inv.èís. ' + Str( (::fiMAJ)->nInvCis, 15 ) + ;
                   ' - Poè.stav oprávek úèet. je vìtší než vstupní cena úèetní' + CRLF
      RETURN NIL
    ENDIF
    * endnew
    * Výpoèet úèetních odpisù pro nový rok  ... NEW 10.10.2008
*    nPocetMES := (::fiMAJ)->nPocMesOdp   // ::PocetMES()

    * nPocetMES = poèet mìsícù, které zbývá odepsat
    nPocetMES := (::fiMAJ)->nRokyOdpiU * 12 - (::fiMAJ)->nPocMesUO   // (::fiMAJ)->nPocMesOdp
    nPocetMES := IF( nPocetMES > 12, 12, nPocetMES )
    *
    c_UcetSkp->( dbSeek( Upper((::fiMAJ)->cOdpiSk),, 'C_UCETSKP1'))

    Do Case
      Case (::fiMAJ)->nTypUOdpi == UO_ROVNOMERNY //  = 1
        /*  zaloha 1.6.2011
        //- 25.1.06, 20.11.09
        IF (::fiMAJ)->nOdpiSk = 8 .or. (::fiMAJ)->cOdpiSk = '1M'
          nUctOdpMes := (::fiMAJ)->nCenaVstU / (::fiMAJ)->nRokyOdpiU
        ELSEIF (::fiMAJ)->cOdpiSk = '2M'
          nUctOdpMes := (::fiMAJ)->nCenaVstU / (::fiMAJ)->nRokyOdpiU
        ELSE
          nUctOdpMes := ( (::fiMAJ)->nCenaVstU / ( (::fiMAJ)->nRokyOdpiU * 12) )
        ENDIF
        nUctOdpRok := nUctOdpMes * 12
        */

**        nUctOdpRok := ( (::fiMAJ)->nCenaVstU / 100 * C_UcetSkp->nRoDalsi)
**        nUctOdpMes := nUctOdpRok / 12

        ** Jana CH. 19.7.11
        nUctOdpRok := ( (::fiMAJ)->nCenaVstU / 100 * C_UcetSkp->nRoDalsi)
        nUctOdpMes := mh_RoundNumb( nUctOdpRok / 12, ::nRoundOdpi )
        nUctOdpRok := nUctOdpMes * 12

      Case (::fiMAJ)->nTypUOdpi == UO_ROVENDANOVEMU  // = 3
        IF (::fiMAJ)->nDanOdpRok > 0
          nUctOdpRok := (::fiMAJ)->nDanOdpRok
          nUctOdpMes := nUctOdpRok / 12
        ELSE
          nUctOdpRok := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
          nUctOdpMes := nUctOdpRok / 12
        ENDIF
    EndCase

    nZCucetni := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
    If nZCucetni <= nUctOdpMes
      (::fiMAJ)->nUctOdpRok := nZCucetni
      (::fiMAJ)->nUctOdpMes := nZCucetni
    ElseIf  nZCucetni < nUctOdpRok
      (::fiMAJ)->nUctOdpRok := nZCucetni
**23.6.11      (::fiMAJ)->nUctOdpMes := mh_RoundNumb( (::fiMAJ)->nUctOdpRok / nPocetMES, ::nRoundOdpi )
      (::fiMAJ)->nUctOdpMes := mh_RoundNumb( (::fiMAJ)->nUctOdpMes, ::nRoundOdpi )
    Else
      (::fiMAJ)->nUctOdpRok := nUctOdpRok
      (::fiMAJ)->nUctOdpMes := mh_RoundNumb( nUctOdpMes, ::nRoundOdpi)
    EndIf
    (::fiMAJ)->nProcUctOd := ValToPerc( (::fiMAJ)->nCenaVstU, (::fiMAJ)->nUctOdpRok )
  ENDIF

/***
    If nTypUOdpi == UO_ROVNOMERNY     //  1 = rovnomìrný
      If nTypVypUO = UO_VYPOCET_PLNY
        * odepisuje se již v mìsíci zaøazení
        nUORok := ( nCenaVstU / 100 * C_UcetSkp->nRoPrvni)
        nUOMes := nUORok / ( 13 - nAktMes )
      ELSEIF nTypVypUO = UO_VYPOCET_ZKRACENY
        * odepisuje se od následujícího mìsíce po zaøazení
        nUOMes := (( nCenaVstU / 100 * C_UcetSkp->nRoPrvni) / 12 )
        nUORok := If( nAktMes = 12 .and. !::lRocniUZV .and. ::lNewRec, 0, nUOMes * ( 12 - nAktMes) )
      ENDIF
**      nUORok := If( nAktMes = 12 .and. !::lRocniUZV .and. ::lNewRec, 0, nUOMes * ( 12 - nAktMes) )
      ::dm:set( ::fiMAJw + '->nUctOdpMes', nUOMes )
      ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok := HIM_RocniOdpis( nUORok, nZCU, nRoundAlgor))
      ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) )
    EndIF
    If nTypUOdpi == UO_ROVENDANOVEMU    // 3 = roven daòovému
**20.8.      ::dm:set( ::fiMAJw + '->nRokyOdpiU', C_DanSkp->nRokyOdpis )
**      ::dm:set( ::fiMAJw + '->nProcUctOd', ::dm:get( ::fiMAJw + '->nProcDanOd' ) )
      nUORok := ::dm:get( ::fiMAJw + '->nDanOdpRok')
      nUOMes := If( nAktMes = 12 .and. !lRocniUZV .and. ::lNewRec, 0,;
                    mh_RoundNumb( nUORok / nPocetMes, nRoundAlgor) )
      nUORok := If( nAktMes == 12, nUORok, nUOMes * nPocetMes )
      ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok )
      ::dm:set( ::fiMAJw + '->nUctOdpMes', nUOMes )
      ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) ) // new
    EndIf
***/

Return Nil

* Výpoèet poètu mìsíèních odpisù pro daný rok ( !!!) - Novou položku do MAJ - nPocMesUO ( pùvodnì nPocMesOdp)
** HIDDEN **********************************************************************
METHOD HIM_ZAVERKA_gen:PocetMES()
  Local nPocetMES
*  Local nRokAKT := VAL( cAktROK)
  Local nRokZAR := VAL( mh_GETcRok4( (::fiMAJ)->cObdZar))
  Local nMesZAR := VAL( LEFT( (::fiMAJ)->cObdZar, 2))
  Local nMesOdpCEL := (::fiMAJ)->nRokyOdpiU * 12
  Local nMesOdpAKT := ( ::nROK - nRokZAR) * 12 + ( 12 - nMesZAR)
**  Local nMesOdpAKT := (::fiMAJ)->nPocMesUO

  nPocetMES := nMesOdpCEL - nMesOdpAKT
  nPocetMES := IF( nPocetMES >= 12, 12, nPocetMES)

RETURN nPocetMES

* Archivace datových souborù pøed spuštìním roèní uzávìrky
********************************************************************************
METHOD HIM_ZAVERKA_gen:ArchBeforeUZV()
  Local lOK := .T., n, cx
  Local cDirSource := drgINI:dir_DATA
  Local cDirTarget := drgINI:dir_DATA + 'ARCHIV\'
  Local acFILE, cFile, cMsg, oMoment, hObj, cOutFile
  Local cTmDir, cTmFile

  ::msg := ::drgDialog:oMessageBar
  cMsg := drgNLS:msg('Probíhá archivace dat pøed uzávìrkou ...')
  ::msg:writeMessage( cMsg)  //, DRG_MSG_WARNING)
  *
  acFILE := IF( ::cTASK = 'HIM', FILES_arch_HIM, FILES_arch_ZVI )
  *
  CreateDIR( cDirTarget)
  CreateDIR( cDirTarget += ::cTASK + '\')
  CreateDIR( cDirTarget += 'UZV_' + STR( ::nROK,4) + '\' )

  oMoment := SYS_MOMENT( 'Probíhá archivace dat pøed uzávìrkou')

  if At('\\',drgINI:dir_DATA) > 0
    if ( npos := At(':',drgINI:dir_DATA)) > 0
      cx :=  SubStr( drgINI:dir_DATA, 1, npos-1)
      if ( npos := At('\', drgINI:dir_DATA, npos)) > 0
        cTmDir := cx + SubStr( drgINI:dir_DATA, npos)
      endif
    endif
  endif


  FOR n := 1 TO  LEN( acFILE)
    *
    cFile := acFILE[ n]
    drgDBMS:open( cFile)
    cOutFile := cDirTarget + cFile
*    COPY TO ( cOutFile )
    _AdsExport( cOutFile)

    lok := if( File(cOutFile +'.adt'), lok , .f. )

// ne JS 18.2.2019    lOK := IF( FILE( cTmDir + cFile + '.adt' ), lOK, .F. )

  NEXT

// tvrdá úprava JT   17.6.2019
  lOK := .t.

  oMoment:destroy()
  *
  IF lOK
    cMsg := drgNLS:msg('Archivace dat probìhla ÚSPÌŠNÌ ...')
    ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
    ::msg:WriteMessage( ,0)

  ELSE
    drgMsgBox(drgNLS:msg('Roèní uzávìrku nelze povolit,;' + ;
                         'nebo odložení dat pøed uzávìrkou probìhlo NEÚSPÌŠNÌ !' ))
  ENDIF

RETURN lOK

* Obnova datovýhc souborù z archivu pøed spuštìním roèní uzávìrky
********************************************************************************
METHOD HIM_ZAVERKA_gen:RestFromArch()
  Local lOK := .T., n
  Local cDirSource := drgINI:dir_DATA + 'ARCHIV\' + ::cTASK + '\UZV_' + STR( ::nROK,4) + '\'
  Local cDirTarget := drgINI:dir_DATA
  Local acFILE, cFile, cMsg, oMoment

  acFILE := IF( ::cTASK = 'HIM', FILES_arch_HIM, FILES_arch_ZVI )
  * Zjistíme zda všechny obnovované soubory existují v archivu
  FOR n := 1 TO  LEN( acFILE)
    lOK := IF( FILE( cDirSource + acFILE[ n] + '.ADT' ), lOK, .F. )
  NEXT
  *
  IF lOK
    ::msg := ::drgDialog:oMessageBar
    cMsg := drgNLS:msg('Probíhá obnova dat pøed opakovanou uzávìrkou ...')
    ::msg:writeMessage( cMsg)  //, DRG_MSG_WARNING)

     oMoment := SYS_MOMENT()
    * Aktualizace UcetPol
    ::RestUcetPol()
    /*
**   drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim( LICASYS->cDataDir) +'\Data\'
    FOR n := 1 TO  LEN( acFILE)
      cFile := acFILE[ n]
      drgDBMS:open( cFile)
      ( cFile)->( dbCloseArea())
    NEXT

    drgINI:dir_DATA += 'ARCHIV\' + ::cTASK + '\UZV_' + STR( ::nROK,4) + '\'
    FOR n := 1 TO  LEN( acFILE)
      cFile := acFILE[ n]
      drgDBMS:open( cFile)
      FERASE( cDirTarget + cFile + '.ADT')
      FERASE( cDirTarget + cFile + '.ADM')
      FERASE( cDirTarget + cFile + '.ADI')
      ( cFile)->( AdsConvertTable( cDirTarget + cFile,,3))
    NEXT
      */
      *
    FOR n := 1 TO  LEN( acFILE)
      COPY FILE ( cDirSource + acFILE[ n] + '.ADT') TO ( cDirTarget + acFILE[ n] + '.ADT' )
      COPY FILE ( cDirSource + acFILE[ n] + '.ADM') TO ( cDirTarget + acFILE[ n] + '.ADM' )
*      COPY FILE ( cDirSource + acFILE[ n] + '.ADI') TO ( cDirTarget + acFILE[ n] + '.ADI' )
      */
    NEXT
    * Aktualizace RokUzv(Z)
    IF (::fiRokUZV)->( dbSeek( ::nROK,, AdsCtag(1) ))
        If (::fiRokUZV)->( sx_RLock())
          (::fiRokUZV)->( DbDelete(), DbUnlock() )
        ENDIF
    ENDIF
    *
    oMoment:destroy()
    cMsg := drgNLS:msg('Obnova dat z archivace probìhla ÚSPÌŠNÌ ...')
    ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
    ::msg:WriteMessage( ,0)
    drgMsgBox(drgNLS:msg('Byl obnoven stav pøed roèní uzávìrkou !', XBPMB_INFORMATION))

  ELSE
    drgMsgBox(drgNLS:msg('Nejsou vytvoøeny podmínky pro obnovu dat z archivu !', XBPMB_INFORMATION))
  ENDIF

RETURN lOK

* Obnova UcetPol = zrušení zaúètování rozdílù oproti plánu
********************************************************************************
METHOD HIM_ZAVERKA_gen:RestUcetPol()
  Local nKarta := 205        //doúètování úè. odpisu pøi roèní uzávìrce
  Local cKey

  drgDBMS:open( ::fiZMAJU )
  drgDBMS:open( 'UcetPOL' )
  ( ::fiZMAJU)->( AdsSetOrder(2), mh_SetScope( nKarta))
  Do While !( ::fiZMAJU)->( Eof())
    cKey := Upper( (::fiZMAJU)->cDenik) + StrZero( (::fiZMAJU)->nDoklad, 10) + ;
            StrZero( (::fiZMAJU)->nOrdItem, 5)
    Do While UcetPol->( dbSeek( cKey,,'UCETPOL1'))
       DelRec( 'UcetPol')
    EndDo
    (::fiZMAJU)->( dbSkip())
  EndDo
  (::fiZMAJU)->( mh_ClrScope())

RETURN

* Zruší vyøazený majetek vèetnì pøísl. souborù - v roèní uzávìrce
********************************************************************************
METHOD HIM_ZAVERKA_gen:delVYRAZEN()
  Local aFILES := { ::fiZMAJU, ::fiZMAJN, ::fiMAJ_ps, ::fiUMAJ, ::fiDMAJ }
  Local aTAGs  := {         1,         1,          1,        1,        1 }
  Local aOldTAGs := {,,,,,}, aRECs := { {},{},{},{},{},{} }
  Local lZMAJU, lZMAJN, lMAJ_ps, lUMAJ, lDMAJ, lUCETPOL, lDel := .F.
  Local x, cScope

  cScope := IF( ::isHIM, StrZero( (::fiMaj)->nTypMaj,3), StrZero( (::fiMaj)->nUcetSkup,3) ) + ;
                         StrZero( (::fiMaj)->nInvCis,15)
  FOR x := 1 TO LEN( aFILES)
    drgDBMS:open( aFILEs[x])
    aOldTAGs[x] := ( aFILEs[x])->( AdsSetOrder( aTAGs[x]))
    ( aFILEs[x])->( Ads_SetScope(SCOPE_TOP   , cScope), ;
                    Ads_SetScope(SCOPE_BOTTOM, cScope), DbGoTop() )

    ( aFILEs[x])->( dbEVAL( {|| AADD( aRECs[x], ( aFILEs[x])->( RecNO()) )}))

    ( aFILEs[x])->( Ads_ClearScope(SCOPE_TOP)   , ;
                    Ads_ClearScope(SCOPE_BOTTOM), DbGoTop() )
    ( aFILEs[x])->( AdsSetOrder( aOldTAGs[x]))
  NEXT
  lZMAJU  := IF( LEN( aRECs[1]) = 0, .T., (::fiZMAJU)->( sx_RLock( aRECs[1])))
  lZMAJN  := IF( LEN( aRECs[2]) = 0, .T., (::fiZMAJN)->( sx_RLock( aRECs[2])))
  lMAJ_ps := IF( LEN( aRECs[3]) = 0, .T., (::fiMAJ_ps)->( sx_RLock( aRECs[3])))
  lUMAJ   := IF( LEN( aRECs[4]) = 0, .T., (::fiUMAJ)->( sx_RLock( aRECs[4])))
  lDMAJ   := IF( LEN( aRECs[5]) = 0, .T., (::fiDMAJ)->( sx_RLock( aRECs[5])))

  lDel    := ( lZMAJU .and. lZMAJN .and. lMAJ_ps .and. lUMAJ .and. lDMAJ )

  IF lDel
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
     (fiMAJ)->( dbDelete())   //, dbUnlock())
     lDel := .T.
  ENDIF

RETURN self



// ne JS 18.2.2019    lOK := IF( FILE( cTmDir + cFile + '.adt' ), lOK, .F. )

//    DrgDump( cTmDir + cFile + '.adt' + ' ->  ' + if( lOK,'ANO','NE'))

    */
    /*
    cFile := acFILE[ n]
    hObj := (cFile)->( DbInfo(ADSDBO_TABLE_HANDLE) )
    AdsCopyTable( hObj, , cDirTarget + cFile )
    hObj := (cFile)->( OrdInfo(ADSORD_INDEX_HANDLE) )
    AdsCopyTable( hObj, , cDirTarget + cFile )
    */

   /* new
    cFile := acFILE[ n]
    drgDBMS:open( cFile)
    ( cFile)->( AdsConvertTable( cDirTarget + cFile,,ADS_ADT))

    lOK := IF( FILE( cDirTarget + cFile + '.adt' ), lOK, .F. )
   * end new
   */

  /*  OLD_VER
    IF FILE( cDirSource + acFILE[ n] + '.ADT' )
      COPY FILE ( cDirSource + acFILE[ n] + '.ADT') TO ( cDirTarget + acFILE[ n] + '.ADT' )
      lOK := IF( FILE( cDirTarget + acFILE[ n] + '.ADT' ), lOK, .F. )
    ELSE
      lOK := .F.
    ENDIF
    IF FILE( cDirSource + acFILE[ n] + '.ADM' )
      COPY FILE ( cDirSource + acFILE[ n] + '.ADM') TO ( cDirTarget + acFILE[ n] + '.ADM' )
      lOK := IF( FILE( cDirTarget + acFILE[ n] + '.ADM' ), lOK, .F. )
    ENDIF
    IF FILE( cDirSource + acFILE[ n] + '.ADI' )
      COPY FILE ( cDirSource + acFILE[ n] + '.ADI') TO ( cDirTarget + acFILE[ n] + '.ADI' )
      lOK := IF( FILE( cDirTarget + acFILE[ n] + '.ADI' ), lOK, .F. )
    ENDIF
  */