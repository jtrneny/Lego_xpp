/*==============================================================================
  VYR_RozpracCMP.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#DEFINE  vyrROZPRAC      1    // Nedokonèená ( rozpracovaná) výroba
#DEFINE  vyrDOKONC       2    // Dokonèená  výroba
#DEFINE  vyrKALKZAK      3    // Všechny zakázky (nedokonèená + dokonèená)

* Aktualizace výroby: Nedokonèené (ROZPRAC), dokonèené (DOKONC), celé (KALKZAK)
********************************************************************************
CLASS VYR_VYROBA_AKT FROM drgUsrClass
EXPORTED:
  VAR     cFILE

  METHOD  Init, Destroy, getForm, itemMarked, drgDialogStart
  METHOD  btn_Vypocet

ENDCLASS

********************************************************************************
METHOD VYR_VYROBA_AKT:init(parent)
  ::drgUsrClass:init(parent)
  ::cFILE  := ALLTRIM( drgParseSecond( parent:initParam, ',' ))

  drgDBMS:open(::cFILE)

RETURN self
*
********************************************************************************
METHOD VYR_VYROBA_AKT:drgDialogStart(drgDialog)
*  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  (::cFILE)->( AdsSetOrder( 2))
RETURN self
*
********************************************************************************
METHOD VYR_VYROBA_AKT:ItemMarked()
  Local cScope := Upper(VYRZAK->cCisZakaz) + StrZERO( YEAR( DATE()), 4) + StrZERO( MONTH( DATE()), 2)

  ( ::cFILE)->( mh_SetSCOPE( cScope ))
RETURN self

********************************************************************************
METHOD VYR_VYROBA_AKT:destroy()
  ::drgUsrClass:destroy()
  ::cFILE      :=  NIL
RETURN self

********************************************************************************
METHOD VYR_VYROBA_AKT:getForm()
  LOCAL oDrg, drgFC
  LOCAL cTitle := IF( ::cFILE = 'ROZPRAC', 'VÝPOÈET nedokonèené výroby',;
                  IF( ::cFILE = 'DOKONC' , 'VÝPOÈET dokonèené výroby',;
                  IF( ::cFILE = 'KALKZAK', 'VÝPOÈET všech zakázek', '' )))

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100, 25 DTYPE '10' TITLE cTitle             ;
                                             FILE ::cFILE             ;
                                             GUILOOK 'Message:y,Action:y,IconBar:y:drgStdBrowseIconBar'

  odrg:tskObdobi := 'VYR'

  DRGACTION INTO drgFC CAPTION 'info ~Zakázka'      EVENT 'VYR_VYRZAK_INFO' TIPTEXT 'Informaèní karta vyrobní zakázky '
  IF ::cFILE = 'ROZPRAC'
    DRGACTION INTO drgFC CAPTION '~Výpoèet ned.'    EVENT 'btn_Vypocet' TIPTEXT 'Výpoèet nedokonèené výroby'
  ELSEIF ::cFILE = 'DOKONC'
    DRGACTION INTO drgFC CAPTION '~Výpoèet dokonè.' EVENT 'btn_Vypocet' TIPTEXT 'Výpoèet dokonèené výroby'
  ELSEIF ::cFILE = 'KALKZAK'
    DRGACTION INTO drgFC CAPTION '~Výpoèet vše'     EVENT 'btn_Vypocet' TIPTEXT 'Výpoèet veškeré výroby'
  ENDIF

  DRGDBROWSE INTO drgFC SIZE 100,21 FILE 'VYRZAK';
                        FIELDS 'cCisZakaz,' + ;
                               'cNazevZak1::40,' + ;
                               'cVyrPol,'       + ;
                               'nVarCis '       ;
                        INDEXORD 1 SCROLL 'ny' CURSORMODE 3 PP 7  POPUPMENU 'y'  ;
                        ITEMMARKED 'ItemMarked'

  DRGSTATIC INTO drgFC FPOS 0.2,21.2 SIZE 99.6,3.7 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
    DRGTEXT INTO drgFC CAPTION 'Stav ke dni'  CPOS  2, .2 CLEN 12
    DRGTEXT INTO drgFC NAME dDatZprac         CPOS  2,1.2 CLEN 10 BGND 13 FONT 5 CTYPE 2

    DRGTEXT INTO drgFC CAPTION 'Pøímý materiál'  CPOS  34, .2 CLEN 12
    DRGTEXT INTO drgFC CAPTION 'Pøímé mzdy'      CPOS  53, .2 CLEN 10
    DRGTEXT INTO drgFC CAPTION 'Kooperace'       CPOS  71, .2 CLEN 10
    DRGTEXT INTO drgFC CAPTION 'Výrobní režie'   CPOS  86, .2 CLEN 10
    DRGTEXT INTO drgFC CAPTION 'PLÁN'            CPOS  15,1.2 CLEN 12 FONT 7
    DRGTEXT INTO drgFC CAPTION 'SKUTEÈNOST'      CPOS  15,2.2 CLEN 14 FONT 7

    DRGTEXT INTO drgFC NAME nPlPrMatZ            CPOS  30,1.2 CLEN 15 BGND 13 FONT 7 CTYPE 2
    DRGTEXT INTO drgFC NAME nPlPrMzdZ            CPOS  47,1.2 CLEN 15 BGND 13 FONT 7 CTYPE 2
    DRGTEXT INTO drgFC NAME nPlPrKooZ            CPOS  64,1.2 CLEN 15 BGND 13 FONT 7 CTYPE 2
    DRGTEXT INTO drgFC NAME nPlRezieZ            CPOS  81,1.2 CLEN 15 BGND 13 FONT 7 CTYPE 2

    DRGTEXT INTO drgFC NAME nSkPrMatZ            CPOS  30,2.2 CLEN 15 BGND 13 FONT 7 CTYPE 2
    DRGTEXT INTO drgFC NAME nSkPrMzdZ            CPOS  47,2.2 CLEN 15 BGND 13 FONT 7 CTYPE 2
    DRGTEXT INTO drgFC NAME nSkPrKooZ            CPOS  64,2.2 CLEN 15 BGND 13 FONT 7 CTYPE 2
    DRGTEXT INTO drgFC NAME nSkRezieZ            CPOS  81,2.2 CLEN 15 BGND 13 FONT 7 CTYPE 2

  DRGEND  INTO drgFC
RETURN drgFC

********************************************************************************
METHOD VYR_VYROBA_AKT:btn_Vypocet()
  LOCAL oDialog, nExit

  ( ::cFILE)->( mh_ClrSCOPE())
  *
  DRGDIALOG FORM 'VYR_VYROBA_CRD' PARENT ::drgDialog  MODAL DESTROY ;
                                  EXITSTATE nExit
   *
   ::itemMarked()
RETURN self


********************************************************************************
*
********************************************************************************
CLASS VYR_VYROBA_CRD  FROM drgUsrClass
EXPORTED:
  VAR     cFILE, nVyroba, cVyroba
  * Config
  VAR     nPrMZDY, nFaktMN, acDenikNE, nVypREZ, nHodSazZAM, cDenikSKL, nKoef, nZpFaktMn
  VAR     nPrMatKal, nKalkNED, nVyrobREZ, nSkCFakZak
  * Parametry výpoètu
  VAR     cZnak, nObdobi, nRok, lVypocetPlanu, nTypRezie
  * Vars_cmp
  VAR     nMnFAKT, nMnFAKTo, nMnFAKTr, nMnFAKTall
  VAR     nNmNaOpeSK, nSkPrMzdZ, nSkPrMzUkZ, nSkOstPrMz, nSkNminVSE
  VAR     nSkPrMzdZP, nSkPrMzUZP, nSkOstPrMP
  VAR     nCenCelOBD, nCenCelALL

  METHOD  Init, Destroy, drgDialogStart, EventHandled, getForm
  METHOD  PostValidate
  METHOD  btn_StartVypocet, MaterCOND

HIDDEN:
  VAR     dm, msg
  VAR     nPlPrMatZ, nPlPrMzdZ, nPlPrKooZ, nPlHodinZ
  VAR     nKcMDKsr, nKcDALKsr, nKcMDObrO, nKcDALObrO
  *
  METHOD  Aktualizace, VyrobaNED, VyrobaDOK
  METHOD  prevObdobi, MnozOdved
  METHOD  PLAN_cmp, PlanPrMat
  METHOD  SkutPrMat, SkutListIT, SkutREZIE, KurzSTRED
  METHOD  DoUcetKum, UcetKum_NED, UctKumCOND
  METHOD  UcetPOL_NED, UctoCOND
  METHOD  CenZakCel, SkutReDok
ENDCLASS

********************************************************************************
METHOD VYR_VYROBA_CRD:init(parent)

 ::drgUsrClass:init(parent)
  ::cFILE      := parent:parent:dbName
  * Config
  ::nPrMatKAL  := SysCONFIG( 'Vyroba:nPrMatKal' )
  ::nPrMZDY    := SysCONFIG( 'Vyroba:nPrMzdaKal')
  ::nFaktMN    := SysCONFIG( 'Vyroba:nFaktMnoz' )
  ::acDenikNE  := ListAsArray( ALLTRIM( SysCONFIG( 'Vyroba:cDenikNE')))
  ::nVypREZ    := SysCONFIG( 'Vyroba:nVypREZIE')
  ::nHodSazZAM := SysCONFIG( 'Vyroba:nHodSazZam')
  ::cDenikSKL  := UPPER( ALLTRIM( SysCONFIG( 'Sklady:cDenik')))
  ::nZpFaktMn  := SysCONFIG( 'Vyroba:nZpFaktMn' )
  ::nKalkNED   := SysCONFIG( 'Vyroba:nKalkNED')
  ::nVyrobREZ  := SysCONFIG( 'Vyroba:nVyrobREZ')
  ::nSkCFakZak := SysCONFIG( 'Vyroba:nSkCFakZak')
  *
  ::cZnak         := '<='
  ::nObdobi       := MONTH( Date())
  ::nRok          := YEAR( Date())
  ::lVypocetPlanu := .T.
  ::nTypRezie     := 1     // 1 = Vypoètená, 2 = Nastavená

  ::nKOEF      := SysCONFIG( 'Vyroba:nSazbaPOJ', mh_FirstODate( ::nrok, ::nobdobi)) / 100

  *
  drgDBMS:open( 'KALKUL'   )
  drgDBMS:open( 'OdvZAK'   )
  drgDBMS:open( 'FAKVYSHD' )
  drgDBMS:open( 'FAKVYSIT' )
  drgDBMS:open( 'FAKVNPIT' )
  drgDBMS:open( 'CENZBOZ'  )
  drgDBMS:open( 'OBJITEM'  )  ; ObjITEM->( AdsSetOrder( 9))
  drgDBMS:open( 'OPERACE'  )
  drgDBMS:open( 'ListHD'   )  ; ListHD->( AdsSetOrder( 7))
  drgDBMS:open( 'ListIT'   )  ; ListIT->( AdsSetOrder( 8))
  drgDBMS:open( 'PVPITEM'  )
  drgDBMS:open( 'UCETPOL'  )  ; UcetPOL->( AdsSetOrder( 11))
  drgDBMS:open( 'UCETPOLA' )  ; UcetPOLA->( AdsSetOrder( 11))
  drgDBMS:open( 'DRUHYMZD' )  ; DruhyMZD->( AdsSetOrder( 1))
  drgDBMS:open( 'KURZIT'   )  ; KURZIT->( AdsSetOrder( 2))
  drgDBMS:open( 'FIXNAKL'  )  ; FIXNAKL->( AdsSetOrder( 1))
  drgDBMS:open( 'MSPRC_MO' )  ; MSPRC_MO->( AdsSetOrder( 1))
  drgDBMS:open( 'OSOBY' )     ; OSOBY->( AdsSetOrder( 1))
  drgDBMS:open( 'UcetKUM'  )  ; UcetKUM->( AdsSetOrder( 6))

  drgDBMS:open('rozprac',,,,,'rozpraca')

RETURN self

********************************************************************************
METHOD VYR_VYROBA_CRD:drgDialogStart(drgDialog)
*  ::dc := drgDialog:dialogCtrl
  ::dm  := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  (::cFILE)->( AdsSetOrder( 2))
RETURN self

*
********************************************************************************
METHOD VYR_VYROBA_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
**    ::OnSave()
     PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_VYROBA_CRD:destroy()

  ::cFILE      := ::nVyroba     := ::cVyroba     :=                                  ;
  ::nPrMZDY    := ::nFaktMN     := ::acDenikNE   := ::nVypREZ    :=                  ;
  ::nHodSazZAM := ::cDenikSKL   := ::nKOEF       := ::nZpFaktMn  :=                  ;
  ::nKalkNED   := ::nVyrobREZ   := ::nSkCFakZak  :=                                  ;
  ::nMnFAKT    := ::nMnFAKTo    := ::nMnFAKTr    := ::nMnFAKTall :=                  ;
  ::nPlPrMzdZ  := ::nPlPrKooZ   := ::nPlHodinZ   :=                                  ;
  ::nNmNaOpeSK := ::nSkPrMzdZ   := ::nSkPrMzUkZ  := ::nSkOstPrMz := ::nSkNminVSE :=  ;
  ::nCenCelOBD := ::nCenCelALL  :=                                                   ;
  ::nSkPrMzdZP := ::nSkPrMzUZP  := nSkOstPrMP :=                                  ;
   NIL
  *
  ::cZnak  := ::nObdobi := ::nRok  := ::lVypocetPlanu := ::nTypRezie := NIL
RETURN self

*
********************************************************************************
METHOD VYR_VYROBA_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  cNAMe := UPPER(oVar:name), cField := drgParseSecond(cName, '>')
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  /*
  DO CASE
  CASE cField $ Upper('nRokVyp,nObdMes,nPorKalDen')
*     If lValid
      If ( xVar <= 0)
        drgMsgBox(drgNLS:msg( oVar:ref:caption + ': ... údaj musí být kladný !'))
        oVar:recall()
        lOK := .F.
      EndIf
*    Endif
  ENDCASE
  */
RETURN lOK

* Tlaèítko - Spustit výpoèet výroby
********************************************************************************
METHOD VYR_VYROBA_CRD:btn_StartVypocet()
  ::Aktualizace()
RETURN self

** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:Aktualizace()
  Local cTag, cScope
  Local cMsg := drgNLS:msg('MOMENT PROSÍM ...')
  Local nRec := VyrZAK->( RecNO()), nRecCount

  ::dm:save()
  *
  ::msg:writeMessage( ,0)
  * Kontrola, zda bylo zpracováno pøedchozí období, jen upozornit
  ::prevOBDOBI()
  *
  IF drgIsYesNo(drgNLS:msg( ::cVyroba + ' - spustit výpoèet ?' ))
    ::nKOEF      := SysCONFIG( 'Vyroba:nSazbaPOJ', mh_FirstODate( ::nrok, ::nobdobi)) / 100
    *
    cSCOPE := StrZERO( ::nROK, 4) + StrZERO( ::nOBDOBI, 2)
    cTag := ( ::cFILE)->( AdsSetOrder( 1))
    ( ::cFILE)->( mh_SetScope( cSCOPE))
    ( ::cFILE)->( dbEVAL( {|| ;
                   IF( (::cFILE)->cZaObdobi == ::cZNAK .AND. (::cFILE)->( SX_RLock()) ,;
                       ( (::cFILE)->dZapis := CTOD( '  .  .  '), (::cFILE)->( dbUnlock()) ), NIL) }))
    ( ::cFILE)->( mh_ClrScope(), AdsSetOrder( cTag) )
    *
    nRecCount := VyrZAK->( LastREC())
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg(  ::cVyroba + ' - probíhá výpoèet ... ', 'VYRZAK'), nRecCount  )
    *
    VyrZAK->( dbGoTOP())
    DO WHILE !VyrZAK->( EOF())

      IF ::nVyroba = vyrROZPRAC  ;  ::VyrobaNED()
      ELSE                       ;  Kalkul->( AdsSetOrder( 3))
                                    ::VyrobaDOK()
      ENDIF

      VyrZAK->( dbSKIP())
      drgServiceThread:progressInc()
    ENDDO

    drgServiceThread:progressEnd()
    cMsg := drgNLS:msg( ::cVyroba + ' - výpoèet ukonèen ...' )
    ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
    *
    (::cFILE)->( dbCommit())
  ENDIF
  *
  * Které nebyly aktualizovány ... zrušit
  cSCOPE := StrZERO( ::nROK, 4) + StrZERO( ::nOBDOBI, 2)
  cTag := ( ::cFILE)->( AdsSetOrder( 1))
  ( ::cFILE)->( mh_SetScope( cSCOPE),;
                dbEVAL( {|| ;
                IF( ( ::cFILE)->cZaObdobi == ::cZNAK .AND. EMPTY( ( ::cFILE)->dZapis), DelREC( ::cFILE), NIL) }))
  ( ::cFILE)->( mh_ClrScope(), AdsSetOrder( cTag) )

  VyrZAK->( dbGoTO(nREC))

RETURN self

*
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:VyrobaNED()
  LOCAL aDAY := {31,28,31,30,31,30,31,31,30,31,30,31,29}
  Local nStep := 0, anVAL, nHOD, anMNOZ
  Local lExist, lOK, lOkDate
  Local cKEY, cLastDateM  //- poslední datum v mìsíci
  Local nMnozOdved

  IF VyrZAK->cIntID <> 'O' .AND. VyrZAK->cIntID <> 'E' .AND. ALLTRIM( UPPER( VyrZAK->cTypZAK)) <> 'R'
    * Nejdou tam Opravy, Emise, Režijní zakázky
    cLastDateM := StrZERO( aDAY[ ::nObdobi], 2) + '.' + ;
                  StrZERO( ::nOBDOBI,2) + '.' +  RIGHT( STR( ::nROK), 2)
    lOkDate := ( VyrZAK->dZAPIS <= CTOD( cLastDateM ) )

    IF ( VyrZAK->nROK == 0 .AND. VyrZAK->nOBDOBI == 0 ) .OR. ;
       ( VyrZAK->nROK > ::nROK .AND. lOKDate )  .OR. ;
       ( VyrZAK->nROK == ::nROK .AND. VyrZAK->nOBDOBI > ::nOBDOBI .AND. lOkDate )

      /*
      InfoZAK()
      nSTEP := IF( nSTEP >= 10, 1, nSTEP+1)
      IF nSTEP == 1
         nEndTIME := TimeToSEC( TIME())
         @ 14, 55 SAY SecToTIME( nEndTIME - nBegTIME) Color 'w+/w'
      ENDIF
      */
      cKey   := Upper( VyrZAK->cCisZakaz) + StrZERO( ::nROK, 4) + StrZERO( ::nOBDOBI, 2) + ;
                Upper(::cZNAK)
      lExist := RozPrac->( dbSEEK( cKey,, 'ROZPRA2'))
      lOK    := If( !lExist, AddREC( 'Rozprac'), ReplREC( 'Rozprac'))
      If lOK
        Rozprac->cCisZakaz  := VyrZAK->cCisZakaz
        Rozprac->cCisZakazI := VyrZAK->cCisZakaz
        Rozprac->dDatZprac  := DATE()
        Rozprac->nROK       := ::nROK
        Rozprac->nOBDOBI    := ::nOBDOBI
        Rozprac->cZaObdobi  := Upper(::cZNAK)
        Rozprac->cObdobi    := StrZERO( ::nOBDOBI, 2) + '/' + RIGHT( STR( ::nROK, 4), 2)
        Rozprac->cNazPOL1   := VyrZAK->cNazPOL1
        Rozprac->cNazPOL2   := VyrZAK->cNazPOL2
        Rozprac->cNazPOL3   := VyrZAK->cNazPOL3
        Rozprac->cNazPOL4   := VyrZAK->cNazPOL4
        ::MnozODVED()
        Rozprac->nMnozOdved := ::nMnFAKT    //  anMNOZ[ 1]  // Množství do daného období, tj. <=
        Rozprac->nMnozOdvO  := ::nMnFAKTo   //  anMNOZ[ 3]  // Množství za dané období, tj. =
        Rozprac->nMnozOdvR  := ::nMnFAKTr   //  anMNOZ[ 4]  // Množství do daného období v rámci roku, tj. <=
        nMnozOdved := IIF( ::nZpFaktMn == 1, Rozprac->nMnozOdved,;
                                             Rozprac->nMnozOdvR )

        IF ::lVypocetPlanu    //cPLAN == 'ANO'
           ::PLAN_cmp()
           Rozprac->nPlPrMatZ := ::PlanPrMat()
//           drgDump(Rozprac->cciszakaz + ' - ' + str( ::nPlPrMzdZ))
           Rozprac->nPlPrMzdZ := ::nPlPrMzdZ  // ::PlanPrMzd()
           Rozprac->nPlPrKooZ := ::nPlPrKooZ  //::PlanPrKOO()
           Rozprac->nPlHodinZ := ::nPlHodinZ  //::PlanNH()
//          Rozprac->nPlRezieZ :=  ???  Zat¡m NIC
        ENDIF
        // Najde kalkulaci
        IF !Kalkul->( dbSEEK( Upper( VyrZAK->cCisZakaz) + Upper('NED'),, 'KALKUL3' ))
           cKEY := Upper( EMPTY_ZAKAZ + VyrZAK->cVyrPol) + StrZERO( VyrZAK->nVarCis, 4) + Upper( 'NED')
           Kalkul->( dbSEEK( cKey,, 'KALKUL2'))     // SX_WildSEEK( cKEY))
        ENDIF

        Rozprac->nSkPrMatZ  := ::SkutPrMat()
        Rozprac->nSkPrMatZp := ::SkutPrMat( , YES)   // ... s prirazkou
        *
        ::SkutLISTIT()
        nHOD  := ( ::nNmNaOpeSK / 60) - (( nMnozOdved * ( Kalkul->nCenMzdVdp + Kalkul->nCenSluzbp)) / ::nHodSazZAM)
        Rozprac->nSkHodinZ  := MAX( 0, nHOD )  // IF( nHOD < 0, 0, nHOD )
        Rozprac->nSkPrMzdZ  := ::nSkPrMzdZ    //anVAL[ 2]
        Rozprac->nSkPrMzdZP := ::nSkPrMzdZP    //anVAL[ 2]
        Rozprac->nSkPrMzUkZ := ::nSkPrMzUkZ   // anVAL[ 3]
        Rozprac->nSkPrMzUZP := ::nSkPrMzUZP   // anVAL[ 3]
        Rozprac->nSkOstPrMz := ::nSkOstPrMz   // anVAL[ 4]
        Rozprac->nSkOstPrMP := ::nSkOstPrMP   // anVAL[ 4]
        Rozprac->nSkHodinVS := ( ::nSkNminVSE / 60 )     // ( anVAL[ 5] / 60)
        Rozprac->nSkOstPrNa := ::nKOEF * ( Rozprac->nSkPrMzdZ + Rozprac->nSkPrMzUkZ)
        *
        Rozprac->nSkPrKooZ  := ::UcetPOL_NED( 'cUctKoop1', YES, 'UCETPOL' )
        Rozprac->nSkPrKooZ2 := ::UcetPOL_NED( 'cUctKoop2', YES, 'UCETPOL' )
        *
        ::SkutREZIE()  // Naplní: nSkRezieZ, nFaVyrRezZ
        *
        Rozprac->nFaPrMatZ  := nMnozOdved * Kalkul->nCenMatMjP
        Rozprac->nFaPrMzdZ  := nMnozOdved * Kalkul->nCenMzdVdP
        Rozprac->nFaOstPrNa := ::nKOEF * Rozprac->nFaPrMzdZ
        Rozprac->nFaPrKooZ  := nMnozOdved * ( Kalkul->nCenEnergP + ;
                                              Kalkul->nCenMajetP + Kalkul->nCenSluzbP )
        Rozprac->nKurzStred := ::KurzStred()
        Rozprac->nZmenaSNV  := ::UcetPOL_NED( 'cUctZmeSNV', NO, 'UCETPOLA', 'DAL' )
        Rozprac->cZapis     := SysCONFIG( 'System:cUserABB')
        Rozprac->dZapis     := DATE()
        *
        mh_WRTzmena( 'Rozprac', !lExist )
        *
        ::DoUcetKUM( 'ROZPRAC')
        *
        Rozprac->( dbUnlock())
      ENDIF
    ENDIF
  ENDIF


RETURN self

*
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:VyrobaDOK()
  LOCAL aDAY := {31,28,31,30,31,30,31,31,30,31,30,31,29}
  Local nStep := 0, anVAL, anFaVy, nHOD, anCenZakCEL
  Local lExist, lOK, lZakUZV, lZakCFA, lZak3, lZak4, lOkDate
  Local cKEY, nSkRezieZ, nObdHLP
  Local cLastDateM  //- posledn¡ datum v mØs¡ci

  anFaVy  := ::MnozODVED()  // [ 1]... Mn. fakt. do dan‚ho obdob¡, tj. <=
                            // [ 2]... Mn. fakt. za vçechna obdob¡
                            // [ 3]... Mn. fakt. za dan‚ obdob¡, tj. =
                            // [ 4]... Mn. fakt. do dan‚ho obdob¡ v r8mci roku, tj. <=

  anCenZakCEL := ::CenZakCEL()

  * Zakáz byla již uzavøena
  lZakUZV := ( VyrZAK->nROK == ::nROK .AND. VyrZAK->nOBDOBI == ::nOBDOBI )
  * Zakázka nebyla uzavøena, ale bylo na ni fakturováno
  lZakCFA := ( VyrZAK->nROK == 0 .AND. VyrZAK->nOBDOBI == 0 .AND. ::nMnFAKT > 0 ) .OR. ;
             ( VyrZAK->nROK == ::nROK .AND. VyrZAK->nOBDOBI > ::nOBDOBI .AND. ::nMnFAKT > 0 ) .OR. ;
             ( VyrZAK->nROK > ::nROK .AND. ::nMnFAKT > 0 )
  *
  lZak3   := (( VyrZAK->nROK < ::nROK .AND. VyrZAK->nRok > 0 )  .OR. ;
             ( VyrZAK->nROK == ::nROK .AND. VyrZAK->nOBDOBI < ::nOBDOBI )) .AND. ::nCenCelOBD <> 0

  IF ::cFILE == 'DOKONC'
    lZak4 := NO
  ELSEIF ::cFILE == 'KALKZAK'
    lZak4 := NO
    IF VyrZAK->cIntID <> 'O' .AND. VyrZAK->cIntID <> 'E' .AND. ALLTRIM( UPPER( VyrZAK->cTypZAK)) <> 'R'
      * Nejdou tam Opravy, Emise, Režijní zakázky
      cLastDateM := StrZERO( aDAY[ ::nObdobi], 2) + '.' + ;
                    StrZERO( ::nOBDOBI,2) + '.' +  RIGHT( STR( ::nROK), 2)
      lOkDate := ( VyrZAK->dZAPIS < CTOD( cLastDateM ) )

      IF ( VyrZAK->nROK == 0 .AND. VyrZAK->nOBDOBI == 0 ) .OR. ;
         ( VyrZAK->nROK > ::nROK .AND. lOkDate ) .OR. ;
         ( VyrZAK->nROK == ::nROK .AND. VyrZAK->nOBDOBI > ::nOBDOBI .AND. lOkDate )
        lZak4 := YES
      ENDIF
    ENDIF
  ENDIF

    IF lZakUZV .OR. lZakCFA .OR. lZak3 .OR. lZak4
      cKey   := Upper( VyrZAK->cCisZakaz) + StrZERO( ::nROK, 4) + StrZERO( ::nOBDOBI, 2) + ;
                Upper( ::cZNAK)
      lExist := ( ::cFILE)->( dbSEEK( cKey,, AdsCtag(2)))
      lOK    := If( !lExist, AddREC( ::cFILE), ReplREC( ::cFILE))
      IF lOK
        ( ::cFILE)->cCisZakaz  := VyrZAK->cCisZakaz
*        ( ::cFILE)->cCisZakazI := VyrZAK->cCisZakaz
        ( ::cFILE)->dDatZprac  := DATE()
        ( ::cFILE)->nROK       := ::nROK
        ( ::cFILE)->nOBDOBI    := ::nOBDOBI
        ( ::cFILE)->cZaObdobi  := UPPER( ::cZNAK)
        ( ::cFILE)->cNazPOL1   := VyrZAK->cNazPOL1
        ( ::cFILE)->cNazPOL2   := VyrZAK->cNazPOL2
        ( ::cFILE)->cNazPOL3   := VyrZAK->cNazPOL3
        ( ::cFILE)->cNazPOL4   := VyrZAK->cNazPOL4
        ( ::cFILE)->cVyrPOL    := VyrZAK->cVyrPOL
        ( ::cFILE)->nCisFirmy  := VyrZAK->nCisFirmy
        ( ::cFILE)->nMnozOdved := ::nMnFAKT   // anFaVy[ 1]  // Mn. fakt. do dan‚ho obdob¡, tj. <=
        ( ::cFILE)->nMnozOdvO  := ::nMnFAKTo  // anFaVy[ 3]  // Mn. fakt. za dan‚ obdob¡, tj. =

        ::PLAN_cmp()
        ( ::cFILE)->nPlPrMatZ := ::PlanPrMat()
        ( ::cFILE)->nPlPrMzdZ := ::nPlPrMzdZ
        ( ::cFILE)->nPlPrKooZ := ::nPlPrKooZ
        ( ::cFILE)->nPlHodinZ := ::nPlHodinZ
//          ( cALIAS)->nPlRezieZ :=  ???  Zat¡m NIC

        cKEY := Upper( VyrZAK->cCisZakaz) + Upper( 'NED')
        Kalkul->( dbSEEK( cKEY))
        *
        ::SkutLISTIT()
        ( ::cFILE)->nSkPrMzUkZ := ::nSkPrMzUkZ // anVAL[ 3]

        IF lZakUZV .OR. lZak3 .OR. lZak4   // 3.6.2003
           ( ::cFILE)->nSkHodinZ  := ( ::nNmNaOpeSK / 60 )    // ( anVAL[ 1] / 60 )
           ( ::cFILE)->nSkHodinVS := ( ::nSkNminVSE / 60 )    // ( anVAL[ 5] / 60 )
           ( ::cFILE)->nSkPrMatZ  := ::SkutPrMat()
           ( ::cFILE)->nSkPrMatZp := ::SkutPrMat( , YES)   // ... s prirazkou
           ( ::cFILE)->nSkPrMatZH := ::SkutPrMat( NO)
           ( ::cFILE)->nSkPrMzdZ  := ::nSkPrMzdZ           // anVAL[ 2]
           ( ::cFILE)->nSkPrMzdZP := ::nSkPrMzdZP          // anVAL[ 2]
           ( ::cFILE)->nSkOstPrMz := ::nSkOstPrMz          // anVAL[ 4]
           ( ::cFILE)->nSkOstPrMP := ::nSkOstPrMP          // anVAL[ 4]
           ( ::cFILE)->nSkOstPrNa := ::nKOEF * ( ( ::cFILE)->nSkPrMzdZ + ( ::cFILE)->nSkPrMzUkZ)

           ( ::cFILE)->nSkPrKooZ  := ::UcetPOL_NED( 'cUctKoop1', YES, 'UCETPOL' )
           ( ::cFILE)->nSkPrKooZ2 := ::UcetPOL_NED( 'cUctKoop2', YES, 'UCETPOL' )

        ELSEIF lZakCFA .OR. lZak4  // 3.6.2003
           nHOD := ( ::cFILE)->nMnozOdved * ( ( Kalkul->nCenMzdVdp + Kalkul->nCenSluzbp) / ::nHodSazZAM )
           ( ::cFILE)->nSkHodinZ :=  MAX( 0, nHOD)  // IF( nHOD < 0, 0, nHOD )
           * ::nSkCFakZak ... skuteèné náklady èásteènì fakturovaných zakázek
           IF ::nSkCFakZak == 1      // ... dle skuteèných nákladù
              ( ::cFILE)->nSkPrMatZ  := ::SkutPrMat()
              ( ::cFILE)->nSkPrMatZp := ::SkutPrMat( , YES)   // ... s pøirážkou
              ( ::cFILE)->nSkPrMatZH := ::SkutPrMat( NO)
              ( ::cFILE)->nSkPrMzdZ  := ::nSkPrMzdZ   // anVAL[ 2]
              ( ::cFILE)->nSkPrMzdZP := ::nSkPrMzdZP  // anVAL[ 2]
              ( ::cFILE)->nSkOstPrMz := ::nSkOstPrMz  // anVAL[ 4]
              ( ::cFILE)->nSkOstPrMP := ::nSkOstPrMP  // anVAL[ 4]
              ( ::cFILE)->nSkOstPrNa := ::nKOEF * ( ( ::cFILE)->nSkPrMzdZ + ( ::cFILE)->nSkPrMzUkZ)

              ( ::cFILE)->nSkPrKooZ  := ::UcetPOL_NED( 'cUctKoop1', YES, 'UCETPOL' )
              ( ::cFILE)->nSkPrKooZ2 := ::UcetPOL_NED( 'cUctKoop2', YES, 'UCETPOL' )

           ELSE                      // ... dle plánové kalkulace
              ( ::cFILE)->nSkPrMatZ  := ( ::cFILE)->nMnozOdved * Kalkul->nCenMatMjP
              ( ::cFILE)->nSkPrMzdZ  := ( ::cFILE)->nMnozOdved * Kalkul->nCenMzdVdP
              ( ::cFILE)->nSkOstPrMz := ( ::cFILE)->nMnozOdved * Kalkul->nCenSluzbP
              ( ::cFILE)->nSkOstPrNa := ( ::cFILE)->nMnozOdved * Kalkul->nCenOstatP
              ( ::cFILE)->nSkPrKooZ  := ( ::cFILE)->nMnozOdved * Kalkul->nCenEnergP
              ( ::cFILE)->nSkPrKooZ2 := ( ::cFILE)->nMnozOdved * Kalkul->nCenMajetP
           ENDIF
        ENDIF
*       ( ::cFILE)->nSkRezieZ := ???    Zat¡m NIC
*       ::nVypREZ =  1 ... z režijních sazeb ( % z FixNAKL )  ... zatím NE
*                    2 ... z úèetních položek ( sumace pøísl. úètù z UcetPOL )
*                    3 ... ze sazeb pracovišt ( jen výrobní režie)
        * Nastavení FixNAKL
        cKEY := STRZERO( ( ::cFILE)->nROK, 4) + Upper( ( ::cFILE)->cNazPOL1) + ;
                STRZERO( ( ::cFILE)->nOBDOBI, 2) + Upper( ( ::cFILE)->cNazPOL2)
        FixNAKL->( dbSEEK( cKEY))
        IF ! ( lExist := FixNakl->( dbSEEK( cKey)) )
          cKEY := LEFT( cKEY, 14 )
          IF ! ( lExist := FixNakl->( dbSEEK( cKey)) )
            nObdHLP := ( ::cFILE)->nObdobi
            DO WHILE !lExist .AND. nObdHLP >= 0
              nObdHLP := nObdHLP - 1
              cKEY := STRZERO( ( ::cFILE)->nROK, 4) + Upper( ( ::cFILE)->cNazPOL1) + ;
                      STRZERO( nObdHLP, 2)
              lExist := FixNAKL->( dbSEEK( cKey))
            ENDDO
          ENDIF
        ENDIF
        *
        nSkRezieZ := ::SkutReDOK( SysCONFIG( 'Vyroba:nOdbytREZ') )
        nSkRezieZ := ( nSkRezieZ / 100 ) * FixNAKL->nOdbytReVy
        ( ::cFILE)->nOdbytReZ  := IIF( ::nVypREZ == 1, nSkRezieZ,;
                                  IIF( ::nVypREZ == 2, ::UcetPOL_NED( 'cUctOdbREZ', NO, 'UCETPOLA' ),;
                                  IIF( ::nVypREZ == 3, ( ::cFILE)->nOdbytReZ, 0 )))

        nSkRezieZ := ::SkutReDOK( SysCONFIG( 'Vyroba:nVyrobREZ') )
        nSkRezieZ := ( nSkRezieZ / 100 ) * FixNAKL->nVyrobReVy
        ( ::cFILE)->nVyrobReZ  := IIF( ::nVypREZ == 1, nSkRezieZ ,;
                                  IIF( ::nVypREZ == 2, ::UcetPOL_NED( 'cUctVyrREZ', NO, 'UCETPOLA' ),;
                                  IIF( ::nVypREZ == 3, VYR_vREZ_Skut(), 0 )))

        nSkRezieZ := ::SkutReDOK( SysCONFIG( 'Vyroba:nZasobREZ') )
        nSkRezieZ := ( nSkRezieZ / 100 ) * FixNAKL->nZasobReVy
        ( ::cFILE)->nZasobReZ  := IIF( ::nVypREZ == 1, nSkRezieZ,;
                                  IIF( ::nVypREZ == 2, ::UcetPOL_NED( 'cUctZasREZ', NO, 'UCETPOLA' ),;
                                  IIF( ::nVypREZ == 3, ( ::cFILE)->nZasobReZ , 0 )))

        nSkRezieZ := ::SkutReDOK( SysCONFIG( 'Vyroba:nSpravREZ') )
        nSkRezieZ := ( nSkRezieZ / 100 ) * FixNAKL->nSpravReVy
        ( ::cFILE)->nSpravReZ  := IIF( ::nVypREZ == 1, nSkRezieZ,;
                                  IIF( ::nVypREZ == 2, ::UcetPOL_NED( 'cUctSprREZ', NO, 'UCETPOLA' ),;
                                  IIF( ::nVypREZ == 3, ( ::cFILE)->nSpravReZ , 0 )))

        ( ::cFILE)->nZmenaSNV  := ::UcetPOL_NED( 'cUctZmeSNV', NO, 'UCETPOLA', 'DAL' )

        ( ::cFILE)->nCenZakCEL := ::nCenCelALL  // anCenZakCEL[ 2]
        ( ::cFILE)->nKurzStred := ::KurzStred()
        ( ::cFILE)->cZapis     := SysCONFIG( 'System:cUserABB')
        ( ::cFILE)->dZapis     := DATE()
        *
        mh_WRTzmena( ::cFILE, !lExist)
        *
        ::DoUcetKUM( ::cFILE)
        *
        ( ::cFILE)->( dbUnlock())
      ENDIF
    ENDIF
*/
RETURN self

** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:prevOBDOBI()
  Local cKEY := IF( ::nOBDOBI = 1 , STRZERO( ::nROK-1, 4) + '12' ,;
                IF( ::nOBDOBI > 1 , STRZERO( ::nROK  , 4) + STRZERO( ::nOBDOBI - 1, 2 ), '' ))

  IF ! ( ::cFILE)->( dbSEEK( cKEY,, AdsCtag(1) ))
    drgMsgBox(drgNLS:msg( 'Nebylo zpracováno pøedchozí období !'))
  ENDIF
RETURN self


** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:MnozODVED()
  Local nCenZakCEL := 0, nRokODV, nObdODV, N
  Local cIT, acIT := { 'FAKVYSIT', 'FAKVNPIT' }

  ::nMnFAKT    := 0    // mn. fakturované do daného období, tzn. <=
  ::nMnFAKTo   := 0    // mn. fakturované za dané období, tzn. =
  ::nMnFAKTr   := 0    // mn. fakturované do daného období v rámci roku, tzn. <=
  ::nMnFAKTall := 0    // mn. fakturované vše

  IF ::nFaktMN == 1       // Z odvádìní zakázek
    OdvZAK->( AdsSetOrder( 1),;
              mh_SetScope( Upper( VyrZAK->cCisZakaz)) )

      DO WHILE !OdvZAK->( EOF())
        IF !EMPTY( OdvZAK->dDatumODV)
           nRokODV := YEAR( OdvZAK->dDatumODV )
           nObdODV := MONTH( OdvZAK->dDatumODV )
           IF ::cZNAK == '<='
              IF nRokODV < ::nROK .OR. ( nRokODV == ::nROK .AND. nObdODV <= ::nOBDOBI)
                 ::nMnFAKT += OdvZAK->nMnozOdved
              ENDIF
              IF ( nRokODV == ::nROK .AND. nObdODV == ::nOBDOBI)
                 ::nMnFAKTo += OdvZAK->nMnozOdved
              ENDIF
           ELSEIF ::cZNAK == '= '
              IF ( nRokODV == ::nROK .AND. nObdODV == ::nOBDOBI)
                 ::nMnFAKT  += OdvZAK->nMnozOdved
                 ::nMnFAKTo += OdvZAK->nMnozOdved
              ENDIF
           ENDIF
           ::nMnFAKTall += OdvZAK->nMnozOdved
        ENDIF
        OdvZAK->( dbSKIP())
      ENDDO
    OdvZAK->( mh_ClrSCOPE())

  ELSEIF ::nFaktMN == 2          // Z faktur vystavených
    FakVysIT->( AdsSetOrder( 10))
    FakVNPIT->( AdsSetOrder(  6))

    FOR N := 1 TO LEN( acIT)
      cIT := acIT[ N]
      ( cIT)->( mh_SetScope( Upper( VyrZAK->cCisZakaz) ))

      DO WHILE !( cIT)->( EOF())
        FakVysHD->( dbSEEK( ( cIT)->nCisFak,, 'FODBHD1'))
        IF FakVysHD->nFinTyp <> 2 .AND. FakVysHD->nFinTyp <> 4 // nezahrnovat zálohové fakt.
          IF ::cZNAK == '<='
            IF ( cIT)->nRok < ::nROK .OR. ;
              ( ( cIT)->nRok == ::nROK .AND. ( cIT)->nObdobi <= ::nOBDOBI)
              ::nMnFAKT += ( cIT)->nFaktMnoz
            ENDIF
            IF ( ( cIT)->nRok == ::nROK .AND. ( cIT)->nObdobi == ::nOBDOBI)
              ::nMnFAKTo += ( cIT)->nFaktMnoz
            ENDIF
            IF ( ( cIT)->nRok == ::nROK .AND. ( cIT)->nObdobi <= ::nOBDOBI)
              ::nMnFAKTr += ( cIT)->nFaktMnoz
            ENDIF
          ELSEIF ::cZNAK == '= '
            IF ( ( cIT)->nRok == ::nROK .AND. ( cIT)->nObdobi == ::nOBDOBI)
              ::nMnFAKT  += ( cIT)->nFaktMnoz
              ::nMnFAKTo += ( cIT)->nFaktMnoz
            ENDIF
          ENDIF
          ::nMnFAKTall += ( cIT)->nFaktMnoz
//          nCenZakCEL += FakVysIT->nCenZakCEL
        ENDIF
        ( cIT)->( dbSKIP())
      ENDDO
      ( cIT)->( mh_ClrScope())
    NEXT

  ENDIF
RETURN NIL  //  ( { nMnFAKT, nMnFAKTall, nMnFAKTo, nMnFAKTr } )


* Pøímý materiál PLÁN ... nad ObjItem
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:PlanPrMat()
  Local nSuma := 0, cKey

  ObjITEM->( mh_SetSCOPE( Upper( VyrZak->cCisZakaz)))
  DO WHILE !ObjItem->( EOF())
    IF ObjItem->nKcsBDObj <> 0
      nSuma += ObjItem->nKcsBDObj
    ELSE
      cKey := Upper( ObjItem->cCisSklad) + Upper( ObjItem->cSklPol)
      CenZboz->( dbSEEK(  cKey,, 'CENIK03'))
      nSuma += ObjItem->nMnozObOdb * CenZboz->nCenasZBO
    ENDIF
    ObjItem->( dbSKIP())
  ENDDO
  ObjITEM->( mh_ClrSCOPE())
Return( nSuma)

* Nad ListHD vysouètuje hodnoty plánu - pøímé mzdy, kooperace, hodiny
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:PLAN_cmp()

  ::nPlPrMzdZ := ::nPlPrKooZ := ::nPlHodinZ := 0
  *
  ListHD->( mh_SetScope( Upper( VyrZak->cCisZakaz)))
  DO WHILE !ListHD->( EOF())
    IF Operace->( dbSEEK( Upper( ListHD->cOznOper),, 'OPER1') ) .AND. UPPER( Operace->cTypOper) == 'KOO'
      ::nPlPrKooZ += ListHD->nKcNaOpePl
    ENDIF
    ::nPlPrMzdZ += ListHD->nKcNaOpePl
    ::nPlHodinZ += ListHD->nNhNaOpePl
    *
    ListHD->( dbSKIP())
  ENDDO
  ListHD->( mh_ClrScope())
Return NIL

* Pøímý materiál SKUTEEÈNOST ... nad PVPItem nebo UCETPOL
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:SkutPrMat( lCZK, lPrirazka)
  Local nSuma := 0, nAREA := SELECT(), nPrirazka
  Local cSCOPE

  DEFAULT lCZK TO YES, lPrirazka TO NO
  IF ::nPrMatKAL == 1   //  Ze skladových dokladù - PVPITEM
    cSCOPE := Upper( VyrZAK->cCisZakaz) + StrZERO( -1, 2)
    ( dbSelectAREA( 'PVPItem'), AdsSetOrder( 9) )
    PVPITEM->( mh_SetSCOPE( cSCOPE ))
    IF lPrirazka              // zapocitat prirazku
      DO WHILE !EOF()
        IF ::MaterCOND( lCZK)
          nPrirazka := VYR_PrirazkaCMP( PVPItem->nCenaCELK)
          nSuma += PVPItem->nCenaCELK + nPrirazka
        ENDIF
        dbSkip()
      ENDDO
    ELSE                     // bez prirazky
      SUM PVPItem->nCenaCelk TO nSuma FOR  {|| ::MaterCOND( lCZK) }
    ENDIF
    //--
    PVPItem->( mh_ClrScope())

  ELSEIF ::nPrMatKAL == 2   // Z úèetních položek - UCETPOL
    IF lCZK
      nSUMA := ::UcetPOL_NED( 'cUctMatCZK', NO, 'UCETPOL' )
    ELSE
      nSUMA := ::UcetPOL_NED( 'cUctMatZM', NO, 'UCETPOL' )   // 26.5.2003
    ENDIF
  ENDIF
  dbSelectAREA( nArea)
RETURN( nSuma)

*
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:MaterCond( lCZK)
  Local lOK

  IF ::cZNAK == '<='
    lOK := ( PVPITEM->nROK < ::nROK .OR. ( PVPITEM->nROK == ::nROK .AND. PVPITEM->nOBDOBI <= ::nOBDOBI) ) .AND. ;
             IF( lCZK, VYR_IsCZK( PVPITEM->cZkratMENY), !VYR_IsCZK( PVPItem->cZkratMENY) )
  ELSEIF ::cZNAK == '= '
    lOK := PVPITEM->nROK == ::nROK .AND. PVPITEM->nOBDOBI == ::nOBDOBI .AND. ;
           IF( lCZK, VYR_IsCZK( PVPITEM->cZkratMENY), !VYR_IsCZK( PVPItem->cZkratMENY) )
  ENDIF
RETURN lOK


* Výpoèet skut. kalkulací z UCETPOL / UCETPOLA
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:UcetPOL_NED( cUctyCFG, lDenSKL, cALIAS, cMD_DAL )
  Local cUcty := ALLTRIM( SysCONFIG( 'Vyroba:' + cUctyCFG))
  Local aUcty := ListAsARRAY( cUcty)
  Local nKc := 0, lOK

  Default cMD_DAL TO 'MD'
  dbSelectAREA( cALIAS)
 (cALIAS)->( mh_SetScope( Upper( VyrZAK->cNazPOL3) ))
  /*
  IF cMD_DAL == 'MD'
     SUM ( cALIAS)->nKcMD TO nKc FOR {|| ::UctoCOND( aUcty, lDenSKL, cALIAS, cMD_DAL) }
  ELSEIF cMD_DAL == 'DAL'
     SUM ( cALIAS)->nKcDAL TO nKc FOR {|| ::UctoCOND( aUcty, lDenSKL, cALIAS, cMD_DAL) }
  ENDIF
  */
  DO WHILE !( cALIAS)->( EOF())
    IF ( lOK := ::UctoCOND( aUcty, lDenSKL, cALIAS, cMD_DAL) )
      nKC += if( cMD_DAL == 'MD' , ( cALIAS)->nKcMD,;
             if( cMD_DAL == 'DAL', ( cALIAS)->nKcDAL, 0 ))
    ENDIF
    (cALIAS)->( dbSKIP())
  ENDDO

 (cALIAS)->( mh_ClrScope())

RETURN nKc


** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:UctoCOND( aUcty, lDenSKL, cALIAS, cMD_DAL )
  Local lOK := NO
  Local lDenikOK, cUCET

  SET EXACT ON
  lDenikOK := IF( lDenSKL, UPPER( ALLTRIM( ( cALIAS)->cDenik)) <> ::cDenikSKL, YES)

  IF lDenikOK     // Vylouèí deník SKLADU ... je-li požadavek
    AEVAL( ::acDenikNE, {|X| ;
           lDenikOK := IF( X <> ALLTRIM( UPPER( ( cALIAS)->cDenik)), lDenikOK, NO) } )
    IF lDenikOK   // Vylouèí deníky nastavené v CFG ... vždy
      cUCET := IIF( cMD_DAL == 'MD' , ( cALIAS)->cUcetMD ,;
               IIF( cMD_DAL == 'DAL', ( cALIAS)->cUcetDAL, '' ) )
      //-
      IF ::cZNAK == '<='
        IF ( cALIAS)->nROK < ::nROK  .OR. ;
           ( ( cALIAS)->nROK == ::nROK .AND. ( cALIAS)->nOBDOBI <= ::nOBDOBI )
          AEVAL( aUcty, {|X| lOK := IF( LIKE( X, cUCET), YES, lOK) })
        ENDIF
      ELSEIF ::cZNAK == '= '
        IF ( ( cALIAS)->nROK == ::nROK .AND. ( cALIAS)->nOBDOBI == ::nOBDOBI )
          AEVAL( aUcty, {|X| lOK := IF( LIKE( X, cUCET), YES, lOK) })
        ENDIF
      ENDIF

    ENDIF
  ENDIF
  SET EXACT OFF
RETURN lOK


* SkuteÈnost z ListIT
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:SkutLISTIT()

  Local nRokML, nObdML
  Local anVAL := { 0, 0, 0, 0 }
  Local nX
//  Local nNmNaOpeSK := 0, nSkPrMzdZ := 0, nSkPrMzUkZ := 0, nSkOstPrMz := 0
  Local nKcNaOpeSK := 0, nKcOpePREM := 0, nKcOpePRIP := 0 //, nSUMA, nSkNminVSE := 0
  Local nOsPrMzdy  := SysConfig( 'Vyroba:nOsPrMzKal')
  Local cStrMzdy   := SysConfig( 'Vyroba:cStrMzdy'), aStrMzdy
  Local cStrOsMzdy := SysConfig( 'Vyroba:cStrOsMzdy'), aStrOsMzdy
  Local lOK, lStrOK := NO   //... Støediska pro výpoèet pøímých mezd
  Local lStrOKos := NO      //... Støediska pro výpoèet ost.pøímých mezd
  Local nKoefPoj := 0

  SET DECIMALS TO 4
  SET FIXED ON


  ::nNmNaOpeSK := ::nSkPrMzdZ   := ::nSkPrMzUkZ  := ::nSkOstPrMz := ::nSkNminVSE := 0
  ::nSkPrMzdZP := ::nSkPrMzUZP := ::nSkOstPrMP := 0

  * Výèet støedisek pro výpoèet pøímých mezd ..
  IF !IsNIL( cStrMzdy )
    aStrMzdy := ListAsARRAY( ALLTRIM( cStrMzdy) )
  ENDIF
  * Výèet støedisek pro výpoèet ostatních pøímých mezd
  IF !IsNIL( cStrOsMzdy )
    aStrOsMzdy := ListAsARRAY( ALLTRIM( cStrOsMzdy) )
  ENDIF

  *
  ( dbSelectAREA( 'ListIT'), AdsSetOrder( 8) )
  ListIT->( mh_SetScope( Upper( VyrZak->cCisZakaz)))

  DO WHILE !ListIT->( EOF())
    DRUHYMZD->( dbSEEK( StrZero(ListIT->nRok,4)+                       ;
                        StrZero(ListIT->nObdobi,2)+                    ;
                        StrZero(ListIT->nDruhMzdy,4),, 'DRUHYMZD04'))
    MSPRC_MO->( dbSEEK( StrZero(ListIT->nRok,4)+                       ;
                        StrZero(ListIT->nObdobi,2)+                    ;
                        StrZero(ListIT->nOsCisPrac,5)+                 ;
                        StrZero(ListIT->nPorPraVzt,3),, 'MSPRMO01'))
    *

    if .not. Empty(ListIT->dVyhotSkut)
      nRokML := YEAR( ListIT->dVyhotSkut)
      nObdML := MONTH( ListIT->dVyhotSkut)
      IF ::cZNAK == '<='
        lOK := ( nRokML < ::nROK .OR. ( nRokML == ::nROK .AND. nObdML <= ::nOBDOBI )  )
      ELSEIF ::cZNAK == '= '
        lOK := ( nRokML == ::nROK .AND. nObdML == ::nOBDOBI )
      ENDIF

      nKoefPoj := SysCONFIG( 'Vyroba:nSazbaPOJ', mh_FirstODate( nRokML, nObdML)  )
      nKoefPoj :=  nKoefPoj / 100
     *
      IF lOK
         lStrOK := IIF( ::nPrMzdy == 1,     YES,;
                   IIF( ::nPrMzdy == 2, ListIT->cNazPOL1 == VyrZAK->cNazPOL1,;
                   IIF( ::nPrMzdy == 3, VYR_VycetSTR( aStrMzdy), NO  ) ))
         lStrOKos := IIF( ::nPrMzdy == 1,     NO,;
                     IIF( ::nPrMzdy == 2, ListIT->cNazPol1 <> VyrZAK->cNazPOL1,;
                     IIF( ::nPrMzdy == 3, VYR_VycetSTR( aStrOsMzdy), NO  ) ))
        IF lStrOK
          ::nNmNaOpeSK += ListIT->nNmNaOpeSK    // Skuteèný èas ... pro støediska dle CFG
        ENDIF
        ::nSkNminVSE += ListIT->nNmNaOpeSK      // Skuteèný èas ... všechno
        IF DruhyMzd->cTypDMZ  <> 'UKOL'
          IF lStrOK
            ::nSkPrMzdZ  += ListIT->nKcNaOpeSk + ListIT->nKcOpePREM + ListIT->nKcOpePRIP
            ::nSkPrMzdZP += (ListIT->nKcNaOpeSk + ListIT->nKcOpePREM + ListIT->nKcOpePRIP) * nKoefPoj
          ENDIF
        ELSEIF DruhyMzd->cTypDMZ  == 'UKOL'
          IF lStrOK
            ::nSkPrMzUkZ += ListIT->nKcNaOpeSk + ListIT->nKcOpePREM + ListIT->nKcOpePRIP
            ::nSkPrMzUZP += (ListIT->nKcNaOpeSk + ListIT->nKcOpePREM + ListIT->nKcOpePRIP) * nKoefPoj
          ENDIF
        ENDIF
        * Výpoèet ostatních pøímých mezd
        IF ::nPrMZDY == 1
          ::nSkOstPrMz += 0
        ELSEIF !lStrOK
          IF nOsPrMzdy == 2  // dle sazeb pracovníka
            nX := ListIT->nNhNaOpeSK * ( fSazTar( ListIT->dVyhotSkut)[1] * ( fSazZam('PRCPREHLCI',ListIT->dVyhotSkut) / 100 + 1))
            ::nSkOstPrMz += nX
            ::nSkOstPrMP += nX * nKoefPoj

//            ::nSkOstPrMz += ListIT->nNhNaOpeSK * ;
//                          ( fSazTar( ListIT->dVyhotSkut)[1] * ( fSazZam('PRCPREHLCI',ListIT->dVyhotSkut) / 100 + 1))
          ELSE
            ::nSkOstPrMz += ListIT->nKcNaOpeSk + ListIT->nKcOpePREM + ListIT->nKcOpePRIP
            ::nSkOstPrMP += (ListIT->nKcNaOpeSk + ListIT->nKcOpePREM + ListIT->nKcOpePRIP) * nKoefPoj
          ENDIF
        ENDIF
      ENDIF
    ENDIF
    ListIT->( dbSKIP())
  ENDDO
  ListIT->( mh_ClrScope(), dbGoTOP())
  dbSelectAREA( 'VyrZAK')
*/
RETURN NIL   //( { nNmNaOpeSK, nSkPrMzdZ, nSkPrMzUkZ, nSkOstPrMz, nSkNminVSE } )

*
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:SkutREZIE()
  Local nSkRezieZ := 0
  Local cKEY := STRZERO( Rozprac->nROK,4) + Upper( Rozprac->cNazPOL1) + ;
                STRZERO( Rozprac->nOBDOBI,2) + Upper( Rozprac->cNazPOL2)

  IF ::nKalkNED = 2  // Kalkulace nedokonèené výroby ... Jen s výrobní režií
    DO CASE
      CASE ::nVypREZ == 1    //  z režijních sazeb
        nSkRezieZ := IIF( ::nVyrobREZ == 1, Rozprac->nSkPrMatZ ,;
                     IIF( ::nVyrobREZ == 2, Rozprac->nSkPrMzdZ + Rozprac->nSkPrMzUkZ ,;
                     IIF( ::nVyrobREZ == 3, Rozprac->nSkPrMatZ + Rozprac->nSkPrMzdZ + Rozprac->nSkPrMzUkZ,;
                     IIF( ::nVyrobREZ == 4, Rozprac->nSkPrMzdZ + Rozprac->nSkPrMzUkZ + Rozprac->nSkOstPrMz,;
                     IIF( ::nVyrobREZ == 6, VYR_vREZ_Skut( nVyrobREZ ), 0 )))))
        //  Napozicovat FixNAKL
        IF FixNAKL->( dbSEEK( cKEY))
           nSkRezieZ := ( nSkRezieZ / 100 ) * FixNAKL->nVyrobReVy
        ENDIF
      CASE ::nVypREZ = 2    //  z úèetních položek
        nSkRezieZ := ::UcetPol_NED( 'cUctVyrREZ', NO, 'UCETPOLA')
      CASE ::nVypREZ = 3    //  ze sazeb pracoviš
        nSkRezieZ := VYR_vREZ_Skut()
    ENDCASE
    Rozprac->nSkRezieZ  := nSkRezieZ
    Rozprac->nFaVyrRezZ := Rozprac->nMnozOdved * Kalkul->nRezVyrobP
  ENDIF

RETURN NIL

* Dohledá KURZIT->nKurStred pro VyrZAK->cZkratMENZ
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:KurzSTRED()
  LOCAL aDAY := {31,28,31,30,31,30,31,31,30,31,30,31,29}
  Local nKurzStred := 0
  Local dDATE := CTOD( STRZERO( aDAY[ ::nOBDOBI], 2) + '.' + STRZERO( ::nOBDOBI, 2) + '.' + STR( ::nROK, 4) )
  Local dDatPlatn

  * Od 5.5.2004 byla VyrZAK->cZkratMENY nahrazena VyrZAK->cZkratMENZ
  KurzIT->( mh_SetScope( UPPER( VyrZAK->cZkratMENZ)))

  DO WHILE !KurzIT->( EOF())
    dDatPlatn := CTOD( StrZERO( DAY( KurzIT->dDatPlatn),2) + '.' + ;
                       StrZERO( MONTH( KurzIT->dDatPlatn), 2) + '.' + ;
                       STR( KurzIT->nRokKurz, 4) )
    IF  dDatPlatn > dDATE
      KurzIT->( dbSKIP( -1))
      nKurzSTRED := KurzIT->nKurzSTRED
      EXIT
    ENDIF
    KurzIT->( dbSKIP())
  ENDDO
  IF nKurzSTRED = 0
    KurzIT->( dbGoBottom())
    nKurzSTRED := KurzIT->nKurzSTRED
  ENDIF
  KurzIT->( mh_ClrScope())

RETURN nKurzStred

* Plnìní položek NV  z UcetKUM
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:DoUcetKUM()
**STATIC FUNC DoUcetKUM( cALIAS)
  Local cKey := STRZERO( ::nROK, 4) + STRZERO( ::nOBDOBI, 2) + Upper( VyrZAK->cNazPOL3)
  Local cKeyMin := STRZERO( ::nROK-1, 4) + STRZERO( 12, 2) + Upper( VyrZAK->cNazPOL3)
  Local lRovno := ( ::cZnak == '= '), lRozprac := ( ::cFILE == 'ROZPRAC' )
  Local nMnozODVo := ( ::cFILE)->nMnozODVo


  UcetKUM->( mh_SetSCOPE( cKEY))
  //- Materiál v zahr. mìnì
  ::UcetKUM_NED( 'cUctMatZM')
  ( ::cFILE)->nMatZM_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  //- Materiál v CZK
  ::UcetKUM_NED( 'cUctMatCZK')
  ( ::cFILE)->nMatCZK_U  := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  IF lRozprac
    ( ::cFILE)->nP_MatCZK  := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_MatCZK  := nMnozODVo * KALKUL->nCenMatMjP
  ENDIF
  //- Mzdy
  ::UcetKUM_NED( '', '52*' )
  ( ::cFILE)->nMzdy_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr )
  IF lRozprac
    ( ::cFILE)->nP_Mzdy  := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_Mzdy  := nMnozODVo * KALKUL->nCenMzdVdP
  ENDIF
  //- Ostatní pøímé mzdy
  ::UcetKUM_NED( 'cUctOstPrM')
  ( ::cFILE)->nOstPrMz_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  IF lRozprac
    ( ::cFILE)->nP_OstPrMz := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_OstPrMz := nMnozODVo * KALKUL->nCenSluzbP
  ENDIF
  //- Kooperace 1
  ::UcetKUM_NED( 'cUctKoop1')
  ( ::cFILE)->nKoop1_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  IF lRozprac
    ( ::cFILE)->nP_Koop1  := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_Koop1  := nMnozODVo * KALKUL->nCenEnergP
  ENDIF
  //- Kooperace 2
  ::UcetKUM_NED( 'cUctKoop2')
  ( ::cFILE)->nKoop2_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  IF lRozprac
    ( ::cFILE)->nP_Koop2  := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_Koop2  := nMnozODVo * KALKUL->nCenMajetP
  ENDIF
  //- Zásobovací režie
  ::UcetKUM_NED( 'cUctZasRez')
  ( ::cFILE)->nZasRez_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  IF !lRozprac
    ( ::cFILE)->nP_ZasRez  := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_ZasRez  := nMnozODVo * KALKUL->nRezZasobP
  ENDIF
  //- Odbytová režie
  ::UcetKUM_NED( 'cUctOdbRez')
  ( ::cFILE)->nOdbRez_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  IF !lRozprac
    ( ::cFILE)->nP_OdbRez  := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_OdbRez  := nMnozODVo * KALKUL->nRezOdbytP
  ENDIF
  //- Správní režie
  ::UcetKUM_NED( 'cUctSprRez')
  ( ::cFILE)->nSprRez_U   := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  IF !lRozprac
    ( ::cFILE)->nP_SprRez  := ::nKcMDObrO - ::nKcDALObrO
    ( ::cFILE)->nU_SprRez  := nMnozODVo * KALKUL->nRezSpravP
  ENDIF
  //- Výrobní režie
  ::UcetKUM_NED( 'cUctVyrREZ')
  if lRozprac   //cALIAS == 'ROZPRAC'
    if ::nKalkNED == 2    // Kalkulace ned. vìroby - Jen s vìrobn¡ re§i¡
      ( ::cFILE)->nVyrRez_U  := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
      ( ::cFILE)->nP_VyrRez  := ::nKcMDObrO - ::nKcDALObrO
      ( ::cFILE)->nU_VyrRez  := nMnozODVo * KALKUL->nRezVyrobP

//  úprava JT 5.9.2018
      if rozpraca->( dbSeek( cKeyMin,,'ROZPRA1'))
        ( ::cFILE)->nVyrRez_M := rozpraca->nVyrRez_U
      endif
//

    ELSE
      ( ::cFILE)->nVyrRez_U  := 0
    ENDIF
  ELSE
    ( ::cFILE)->nVyrRez_U  := IIF( lRovno, ::nKcMDObrO - ::nKcDALObrO, ::nKcMDKsr - ::nKcDALKsr)
  ENDIF
  //- Nábìh nedokonèené
//  ( cALIAS)->nNabehNV  := ???

  UcetKUM->( mh_ClrScope())

RETURN Nil

* Výpoèet skut. kalkulací z UCETKUM
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:UcetKUM_NED( cUctyCFG, cUctyLST, nTypKC )
  Local cUcty, aUcty, nKC := 0

  DEFAULT nTypKC TO 1
  ::nKcMDKsr := ::nKcDALKsr := ::nKcMDObrO := ::nKcDALObrO := 0

  IF !IsNIL( cUctyLST)
    cUcty := cUctyLST   // "natvrdo" zadaný seznam úètù
  ELSE
    cUcty := ALLTRIM( SysCONFIG( 'Vyroba:' + cUctyCFG))   // ALLTRIM( PADR( GetCFG( cUctyCFG), 58))
  ENDIF
  aUcty := ListAsARRAY( cUcty)

  UcetKUM->( dbGoTOP())
  DO WHILE !UcetKUM->( EOF())
    IF  ::UctKumCOND( aUcty)
      ::nKcMDKsr   += UcetKUM->nKcMDKsr
      ::nKcDALKsr  += UcetKUM->nKcDALKsr
      ::nKcMDObrO  += UcetKUM->nKcMDObrO
      ::nKcDALObrO += UcetKUM->nKcDALObrO

    ENDIF
    UcetKUM->( dbSKIP())
  ENDDO
RETURN NIL

** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:UctKumCOND( aUcty )
  Local lOK := NO

  SET EXACT ON
  AEVAL( aUcty, {|X| lOK := IF( LIKE( X, UcetKUM->cUcetMD), YES, lOK) })
//  BOX_ALERT( cEM, 'lOK = ' + IF( lOK, '1', '0')+ ' ... ' + UcetKUM->cUcetMD , acWAIT)
  SET EXACT OFF
RETURN lOK

*
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:CenZakCEL()
  Local cTag, cTagHD, cALIAS, N, nTAG
  Local cUctFak, aUcty, lOK := NO, lFaktOK

  ::nCenCelOBD := ::nCenCelALL := 0
  *
  IF ::nFaktMN == 1   // Z odvádìní zakázek
    ::nCenCelALL := VyrZAK->nCenaCELK
  ELSEIF ::nFaktMN == 2   // Z faktur vystavených FakVysIT + FakVnpIT
    FOR N := 1 TO 2
      cALIAS  := IF( N == 1, 'FakVysIT', 'FakVNPIT')
      nTAG    := IF( N == 1,         5 ,         4 )
      cTag    := ( cALIAS)->( AdsSetOrder( nTAG))
      cTagHD  := IF( N == 1, FakVysHD->( AdsSetOrder( 1)), NIL )
      cUctFak := IF( N == 1, ALLTRIM( SysConfig( 'Vyroba:cUctExtFak')) ,;
                             ALLTRIM( SysConfig( 'Vyroba:cUctIntFak'))  )
      aUcty := ListAsARRAY( cUctFak)
      ( cALIAS)->( mh_SetSCOPE( Upper( VyrZAK->cNazPOL3)))
      DO WHILE !( cALIAS)->( EOF())
         IF N == 1  // pro FakVysIT se vylouŸ¡ z lohov‚ faktury
           FakVysHD->( dbSEEK( FakVysIT->nCisFak))
           lFaktOK := ( FakVysHD->nFinTyp <> 2 .AND. FakVysHD->nFinTyp <> 4 )
         ELSE
           lFaktOK := YES
         ENDIF
         IF lFaktOK
           IF ( ( cALIAS)->nRok == ::nROK .AND. ( cALIAS)->nObdobi == ::nOBDOBI)
            lOK := NO
             AEVAL( aUcty, {|X| lOK := IF( LIKE( X, ( cALIAS)->cUcet), YES, lOK) })
             IF( lOK, ::nCenCelOBD += ( cALIAS)->nCenZakCEL , NIL )
           ENDIF
           IF ::cZNAK == '<='
              IF ( cALIAS)->nRok < ::nROK .OR. ;
                 ( ( cALIAS)->nRok == ::nROK .AND. ( cALIAS)->nObdobi <= ::nOBDOBI)
                lOK := NO
                AEVAL( aUcty, {|X| lOK := IF( LIKE( X, ( cALIAS)->cUcet), YES, lOK) })
                IF( lOK, ::nCenCelALL += ( cALIAS)->nCenZakCEL, NIL )
              ENDIF
           ELSEIF ::cZNAK == '= '
              IF ( ( cALIAS)->nRok == ::nROK .AND. ( cALIAS)->nObdobi == ::nOBDOBI)
              lOK := NO
              AEVAL( aUcty, {|X| lOK := IF( LIKE( X, ( cALIAS)->cUcet), YES, lOK) })
                IF( lOK, ::nCenCelALL += ( cALIAS)->nCenZakCEL, NIL )
              ENDIF
           ENDIF
         ENDIF
         ( cALIAS)->( dbSKIP())
      ENDDO
      ( cALIAS)->( mh_ClrSCOPE(), AdsSetOrder( cTag) )
      IF( N == 1, FakVysHD->( AdsSetOrder( cTagHD)), NIL )
    NEXT
  ENDIF
RETURN NIL   //( { nCenCelOBD, nCenCelALL } )


*STATIC FUNC SkutReDOK( nAlg, cALIAS )
** HIDDEN **********************************************************************
METHOD VYR_VYROBA_CRD:SkutReDOK( nAlg )
  Local nSkRezieZ

  nSkRezieZ := IIF( nAlg == 1, ( ::cFILE)->nSkPrMatZ ,;
               IIF( nAlg == 2, ( ::cFILE)->nSkPrMzdZ + ( ::cFILE)->nSkPrMzUkZ ,;
               IIF( nAlg == 3, ( ::cFILE)->nSkPrMatZ + ( ::cFILE)->nSkPrMzdZ  + ( ::cFILE)->nSkPrMzUkZ,;
               IIF( nAlg == 4, ( ::cFILE)->nSkPrMzdZ + ( ::cFILE)->nSkPrMzUkZ + ( ::cFILE)->nSkOstPrMz,;
               IIF( nAlg == 6, ( ::cFILE)->nSkHodinZ * 100,;
               IIF( nAlg == 7, ( ::cFILE)->nSkOstPrMz, 0 ))))))
  /*  Napozicovat FixNAKL
  IF FixNAKL->( dbSEEK( cKEY))
     nSkRezieZ := ( nSkRezieZ / 100 ) * FixNAKL->nVyrobReVy
  ENDIF
  */
RETURN nSkRezieZ


*
********************************************************************************
METHOD VYR_VYROBA_CRD:getForm()
  LOCAL oDrg, drgFC, cTipText

  IF ::cFILE = 'ROZPRAC'
    ::nVyroba := vyrROZPRAC
    ::cVyroba := 'Nedokonèená  výroba'
  ELSEIF ::cFILE = 'DOKONC'
    ::nVyroba := vyrDOKONC
    ::cVyroba := 'Dokonèená  výroba'
  ELSEIF ::cFILE = 'KALKZAK'
    ::nVyroba := vyrKALKZAK
    ::cVyroba := 'Všechny zakázky'
  ENDIF
  cTipText := ::cVyroba + ' - SPUSTIT VÝPOÈET'

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100, 15 DTYPE '10' TITLE ::cVyroba ;
                                             GUILOOK 'Message:y,Action:y,IconBar:n,Menu:n'

  DRGACTION INTO drgFC CAPTION '~Spustit výpoèet' EVENT 'btn_StartVypocet' TIPTEXT cTipText //'Spustit výpoèet nedokonèené výroby'

  DRGSTATIC INTO drgFC FPOS 0.5, 0.1 SIZE 99.1,1.4 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yn'
    DRGTEXT INTO drgFC CAPTION  ::cVyroba + ' - nastavení parametrù výpoètu'  CPOS  2, .2 CLEN 96 CTYPE 3 FONT 5
  DRGEND  INTO drgFC

  DRGSTATIC INTO drgFC FPOS 0.5, 1.5 SIZE 99, 5 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yn'
    DRGCOMBOBOX M->cZnak  INTO drgFC  FPOS 18, 0.4  FLEN 7 FCAPTION 'Období výpoètu' CPOS 1, 0.4  ;
                VALUES '=:=,<=:<='
    DRGCOMBOBOX M->nObdobi  INTO drgFC  FPOS 26, 0.4  FLEN 13 REF 'Mesice'
    DRGGET      M->nRok     INTO drgFC  FPOS 41, 0.4  FLEN  5
    IF ::cFILE = 'ROZPRAC'
      DRGCOMBOBOX M->lVypocetPlanu  INTO drgFC  FPOS 18, 1.4  FLEN 7 FCAPTION 'Vèetnì výpoètu plánu' CPOS 1, 1.4  REF 'LYESNO'
    ELSE
      DRGCOMBOBOX M->nTypRezie  INTO drgFC  FPOS 18, 1.4  FLEN 15 FCAPTION 'Typ režie'  CPOS 1, 1.4 ;
                  VALUES '1:Vypoètená,2:Nastavená'
    ENDIF
  DRGEND  INTO drgFC

  DRGSTATIC INTO drgFC FPOS 0.5, 6.6 SIZE 99, 8.2 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yn'
  DRGEND  INTO drgFC

RETURN drgFC