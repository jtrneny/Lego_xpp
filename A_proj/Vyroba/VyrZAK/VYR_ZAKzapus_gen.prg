/*==============================================================================
  VYR_ZAKzapus_gen.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  MAT_ObjHEAD          ObjHeadACT         ZakZAP.Prg
  Polotovar()          Polotovar()        ZakZAP.Prg
  KusTreeAKT()         KusTreeAKT()       ZakZAP.Prg
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

* Èíslo vlastní firmy
//# Define    MyFIRMA      1

* Zpùsob generování materiálových požadavkù
# Define    KUMULbez        1    // Nekumulovat
# Define    KUMULpol        2    // Kumulovat za skl. položku
# Define    KUMULpolpoz     3    // Kumulovat za skl. položku + kód pozice

# DEFINE    REZER_STD       1    // Rezervaèní mechanismus standartní
# DEFINE    REZER_2         2    // Rezervaèní mechanismus  2

Static snMnZapus, snPORADI, slZakItZAP
Static snGenMatPoz

Static aA
Static cTypStrFIN

* Vrátí zapouštìné množství
*=======================================================================
FUNCTION GetMNZAPUS()
  DEFAULT snMnZapus To 0
RETURN( snMnZapus)

********************************************************************************
*
********************************************************************************
CLASS VYR_ZAKzapus  FROM drgUsrClass

EXPORTED:
  VAR     cFileZAP     // Zapouštìný soubor
  VAR     lRozpadK, lRozpadT, cRozpadK, cRozpadT
  VAR     nZpusobZAP, nTypZAP
  VAR     nMnZapus, nObj, nMZD
  VAR     INFO_zapus
  VAR     cSklPol

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  CheckItemSelected
  METHOD  ZAK_zapustit
  METHOD  Zapustit_POPOL, Zapustit_DILPR()

  METHOD  GenPODKLAD, GenMATERIAL, GenLISTKY

  ACCESS ASSIGN METHOD INFO_zapus

HIDDEN:

  VAR     dm
  var     ndoklad_OBJHEAD
  var     orb_zpusobZap, orb_typZap

  METHOD  WhatSTAV, VyrPol_exists
  METHOD  MAT_ObjHEAD, Polotovar, KusTreeAKT
  METHOD  GEN_ListHDIT

ENDCLASS

*
********************************************************************************
METHOD VYR_ZAKzapus:init(parent)
  Local  xCfg
  Local  nMyFIR
  local  nrangeZadM := SysConfig('Vyroba:nrangeZadM') , nstart, nkonec


  ::drgUsrClass:init(parent)

  drgDBMS:open('CenZboz' )
  drgDBMS:open('PVPItem' )
  drgDBMS:open('NakPol'  )
  drgDBMS:open('Kusov'   )
  drgDBMS:open('PolOPER' )
  drgDBMS:open('OPERACE' )
  drgDBMS:open('VyrPol'  )
  drgDBMS:open('VyrPolDT')
  drgDBMS:open('ObjHEAD' )
  drgDBMS:open('ObjITEM' )
  drgDBMS:open('ListHD'  )
  drgDBMS:open('ListIT'  )
  drgDBMS:open('C_Tarif' )
  drgDBMS:open('VyrZakIT')

//  # Define    MyFIRMA      nMyFIR

*  slZakItZAP := VyrZAK->nPolZAK = 2  // je zapouštìna položka zakázky
  ::cFileZAP := ALLTRIM( drgParseSecond( parent:initParam, ',' ))    //IT
  slZakItZAP := ( ::cFileZAP = 'VyrZakIT' )   // je zapouštìna položka zakázky
*  ::lRozpadK := ::lRozpadT := NO
  ::lRozpadK := SysCONFIG( 'Vyroba:lKrozZapus')
  ::lRozpadT := SysCONFIG( 'Vyroba:lTrozZapus')
  ::cRozpadK := ::cRozpadT := ''

  ::nZpusobZAP := if( isArray( xCfg := SysCONFIG( 'Vyroba:nSetZpuZap')) .or. xCfg = 0, 3, xCfg )
  ::nTypZAP    := if( isArray( xCfg := SysCONFIG( 'Vyroba:nSetTypZap')) .or. xCfg = 0, 1, xCfg )

  ::nMnZapus   := IF( slZakItZAP, VyrZAKIT->nMnozPlano - VyrZAKIT->nMnozZadan, VyrZAK->nMnozPlano - VyrZAK->nMnozZadan)
  ::nOBJ := ::nMzd := 0

  if( vyrZak->nautoPlan = 1, ::nMnZapus := VyrZAK->nmnozPlano, nil )

  *
  **
  nstart     := nrangeZadM[1]
  nkonec     := nrangeZadM[2]

  drgDBMS:open('objhead',,,,,'objhd_iw' )
  objhd_iw->(ordSetFocus( "OBJHEAD7" ))

  cfiltr := format( "nextObj = 0 and ( ndoklad >= %% and ndoklad <= %% )", { nstart, nkonec } )
  objhd_iw->( ads_setAof( cfiltr ), dbgoBottom() )

  ::ndoklad_OBJHEAD := objhd_iw->ndoklad +1
  objhd_iw->( dbcloseArea())

*  VyrPOL->( DbSetRelation( 'VyrZAK', { || VyrPOL->cCisZakaz },'VyrPOL->cCisZakaz'))
  drgDBMS:open('KusTREE'  ,.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('KUSOVw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLDTw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('POLOPERw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

RETURN self

*
********************************************************************************
METHOD VYR_ZAKzapus:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members
  LOCAL  aInfo    := { 'cCisZakaz', 'cNazevZAK1'}
  *
  local  x, amembers  := drgDialog:oForm:aMembers
  local  odrg, className

  ::dm := drgDialog:dataManager

  for x := 1 TO LEN(amembers) step 1
    odrg      := amembers[x]
    className := amembers[x]:className()

    do case
    case ( className = 'drgRadioButton' )
      if   lower(odrg:name) = 'm->nzpusobzap'
        ::orb_zpusobZap := odrg
        ::orb_zpusobZap:refresh()

       elseif lower(odrg:name) = 'm->ntypzap'
         ::orb_typZap := odrg
         ::orb_typZap:refresh()
       endif
    endcase
  next

  AEVAL( aInfo,;
   {|c| drgDialog:dataManager:has( IF( drgParse( c,'-') = c, 'VYRZAKIT->'+ c, c) ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {221, 221, 221} )) })
  *
  drgDialog:oForm:setNextFocus( 'M->nMnZapus',, .t.)
  if  vyrZak->nautoPlan = 1
     ::nMnZapus := 1
     isEditGet( {'M->nMnZapus' }, drgDialog, .f. )
   endif

* STATICs
  snGenMatPoz := 1
*
  ::INFO_zapus := ''
RETURN self


* Rozbìhový mechanismus zapouštìní. =>  Stisk tlaèítka Zapustit
********************************************************************************
METHOD VYR_ZAKzapus:ZAK_zapustit()
  LOCAL oDialog, cMsg
  Local lOK, lErrK := NO, lErrT := NO, alZAPUS, aZakIT := {}
  Local nRozpad := 0, nRec


  snMnZapus := if( vyrZak->nautoPlan = 1, 1, ::nMnZapus )


BEGIN SEQUENCE

  ::nZpusobZAP := ::dm:has( 'M->nZpusobZAP'):Value := ::dm:has( 'M->nZpusobZAP'):oDrg:Value
  ::nTypZAP    := ::dm:has( 'M->nTypZAP'   ):Value := ::dm:has( 'M->nTypZAP'   ):oDrg:Value

  ::dm:save()
  ::INFO_zapus := ''
  * Vyhodnocení stavu zakázky
  If !( lOK := ::WhatSTAV() )
BREAK
  EndIf
  * Kontrola na existenci vyr.položek pøi zapouštìní vícepoložkové zakázky - 12.9.2007
  IF !( lOK := ::VyrPOL_Exists() )
BREAK
  ENDIF
  *
  * Kontrolní rozpady - KONSTR. i TECHNOL.
  IF ( ::lRozpadK := SysCONFIG( 'Vyroba:lKrozZapus'))
    cMsg := 'KONTROLNÍ ROZPAD;;Nyní bude spuštìn konstrukèní kontrolní rozpad !'
    drgMsgBox(drgNLS:msg( cMsg ))
*=    ::KusBrow_rozpad(1)
    lErrK := YES
*=    lErrK := KusBrow( 1)  // konstrukèní¡
     ::cRozpadK := IF( lErrK, 'Chyba !', 'OK')
  ELSE
    ::cRozpadK := 'Bez kontroly'
  ENDIF

  IF ( ::lRozpadT := SysCONFIG( 'Vyroba:lTrozZapus'))
    cMsg := 'KONTROLNÍ ROZPAD;;Nyní bude spuštìn technologický kontrolní rozpad !'
    drgMsgBox(drgNLS:msg( cMsg ))
*=    ::KusBrow_rozpad(2)
*=     lErrT := KusBrow( 2)  // technologický
     lErrT := YES
    ::cRozpadT := IF( lErrT, 'Chyba !', 'OK')
  ELSE
    ::cRozpadT := 'Bez kontroly'
  ENDIF

  IF ::lRozpadK .OR. ::lRozpadT
    IF lErrK .or. lErrT
      cMsg := 'V kontrolních rozpadech byly zjištìny chyby !;;' + ;
              'Chcete pøesto pokraèovat v zapouštìní zakázky ?'
      IF .not. drgIsYesNo(drgNLS:msg( cMsg ))
BREAK
       ENDIF
    ELSE
      drgMsgBox(drgNLS:msg( 'Kontrolní rozpady probìhly OK ...' ))
    ENDIF
  ENDIF

  snMnZapus := if( vyrZak->nautoPlan = 1, 1, ::nMnZapus )

  ::INFO_zapus := drgNLS:msg( 'Probíhá kusovníkový rozpad zapouštìné zakázky')
  DO CASE
    CASE ::nTypZAP == typZAP_KOMPL    // 1 ... kompletní
      IF VyrZAK->nPolZAK <> 2            //! VyrZAK->lPolZAK    // ALLTRIM( UPPER(VyrZAK->cTypZak)) <> 'EK'
        IF ( !::lRozpadK .AND. !::lRozpadT , GenTreeFILE( 0), NIL )
        ::KusTreeAKT()
      ENDIF

    CASE ::nTypZAP == typZAP_DILCI    // 2 ... dílèí
*      KusBrow( 3 )     // ->            ::Zapustit_DILCI()
      ::KusTreeAKT()
    CASE ::nTypZAP == typZAP_POPOL    // 3 ... po položkách
      ::Zapustit_POPOL()
      ::KusTreeAKT()
      nRozpad := 4
    CASE ::nTypZAP == typZAP_POSKU    // 4 ... po skupinách
*      KusBrow( 5 )     // ->            ::Zapustit_POSKU()
      nRozpad := 5
    CASE ::nTypZAP == typZAP_DILPR    // 5 ...dle dílen a pracovišt
      ::Zapustit_DILPR()  //    KusBrow( 6)
      nRozpad := 6
    OTHERWISE
      lOK := NO
*      AEVAL( alZAPUS, {|X| lOK := IF( X, X, lOK) })
*      BOX_ALERT( cEM, IF( lOK, 'ZapuçtØn¡ zak zky bylo pýeruçeno u§ivatelem !',;
*                              'Nen¡ nastaven typ zapuçtØn¡ zak zky !' ), acWAIT)
BREAK
  ENDCASE
  * Generování výrobních podkladù
  Do Case
    Case lErrK .and. lErrT
      cMsg   := 'Byly zjištìny nedostatky pøi konstrukèním i technologickém rozpadu !;' + ;
                'Mzdové lístky a požadavky na materiál nebudou korektní !'
    Case lErrK
      cMsg   := 'Byly zjištìny nedostatky pøi konstrukèním rozpadu !;' + ;
                'Požadavky na materiál nebudou vygenerovány korektnì !'
    Case lErrT
      cMsg   := 'Byly zjištìny nedostatky pøi technologickém rozpadu !;' + ;
                'Mzdové lístky nebudou vygenerovány korektnì !'
    OtherWise
      cMsg   := 'Pøi zapouštìní zakázky nebyly zjištìny žádné nedostatky !'
  EndCase
  cMsg += ';;Skuteènì provést generování výrobních podkladù ?'
  *
  If drgIsYesNo(drgNLS:msg( cMsg ))

     ::nOBJ := ::nMZD := 0
     IF ( VyrZAK->nPolZAK = 2)  // VyrZAK->lPolZAK   // ALLTRIM( UPPER(VyrZAK->cTypZak)) = 'EK'
       ** Zapuštìní položkové zakázky z obrazovky VYRZAKIT ( 1 nebo více oznaèených )
       IF ::cFileZAP = 'VyrZakIT'  //
         ::INFO_zapus := drgNLS:msg( 'Probíhá zapouštìní zakázky')
         *
         // aZakIT := ::drgDialog:parent:odbrowse[1]:arSelect
         IF( LEN( aZakIT) = 0, AADD( aZakIT, VyrZakIT->( RecNO()) ), NIL )

         FOR n := 1 TO LEN( aZakIT)
           VyrZakIT->( dbGoTO( aZakIT[ n]))
           cKey := Upper( VyrZakIT->cCisZakaz) + Upper( VyrZakIT->cVyrPol) + ;
                   StrZERO( VyrZakIT->nOrdItem, 3)
           VyrPOL->( dbSEEK( cKEY ,,'VYRPOL1'))
           *
           snMnZapus := 1     // zapustit 1 kus - KOVAR
           GenTreeFILE( 0)
           ** ::KusTreeAKT() // neaktulizuj nMnZadVA, implicitnì rozpad na 1 kus
           *
           ::GenPodklad()
           *
         NEXT
       ** Zapuštìní položkové zakázky z obrazovky VYRZAK ( všechny položky)
       ELSE
         nRec := VyrZakIT->( RecNo())
         ::INFO_zapus := drgNLS:msg( 'Probíhá zapouštìní zakázky')
**         Filter := FORMAT("(VyrZakIT->cCisZakaz = '%%')",{ VyrZAK->cCisZakaz } )
         Filter := FORMAT("cCisZakaz = '%%'",{ VyrZAK->cCisZakaz } )
         VyrZakIT->( mh_SetFilter( Filter))

         DO WHILE !VyrZakIT->( EOF())
           cKey := Upper( VyrZakIT->cCisZakaz) + Upper( VyrZakIT->cVyrPol) + ;
                   StrZERO( VyrZakIT->nOrdItem, 3)
           VyrPOL->( dbSEEK( cKEY ,,'VYRPOL1'))
           *
           snMnZapus := 1     // zapustit 1 kus - KOVAR
           GenTreeFILE( 0)
           ** ::KusTreeAKT() // neaktulizuj nMnZadVA, implicitnì rozpad na 1 kus
           *
           ::GenPodklad()
           *
           VyrZakIT->( dbSkip())
         ENDDO
         VyrZakIT->( mh_ClrFilter())
         VyrZakIT->( dbGoTO( nRec))
       ENDIF
*       ::INFO_zapus := drgNLS:msg( 'Zakázka  [ & ]  byla zapuštìna do výroby !', VyrZAK->cCisZakaz)

     ** Zapuštìní NEpoložkové zakázky z obrazovky VYRZAK
     ELSE
       /* Pùvodnì */
       VYR_VyrKusAKT( typZAP_POPOL)     //  VYR_Zapus_POPOL.prg  VyrKusAKT( nRozpad)
       ::GenPodklad()                   //  GenPODKLAD( nZpusob, nTyp )
     ENDIF
  *     SayZAPUST()
       *
       ::dm:set('M->nMZD'    , ::nMZD)
       ::dm:set('M->nOBJ'    , ::nOBJ)
       ::dm:set('M->cRozpadK', ::cRozpadK)
       ::dm:set('M->cRozpadT', ::cRozpadT)
       ::dm:refresh()
       *
       ::INFO_zapus := drgNLS:msg( 'Zakázka  [ & ]  byla zapuštìna do výroby !', VyrZAK->cCisZakaz)
*     drgMsgBox(drgNLS:msg( 'Zakázka < & > byla zapuštìna do výroby !', VyrZAK->cCisZakaz ))
  Else
     ::INFO_zapus := drgNLS:msg('Zapouštìní zakázky  [ & ]  bylo pøerušeno uživatelem !', VyrZAK->cCisZakaz )
*     drgMsgBox(drgNLS:msg( 'Zapouštìní zakázky < & > bylo pøerušeno uživatelem !', VyrZAK->cCisZakaz ))
  EndIf

ENDSEQUENCE

RETURN self

*  Generování výrobních podkladù : Materiál a Mzdové lístky
********************************************************************************
METHOD VYR_ZAKzapus:GenPODKLAD()
  Local cTag1 := ListHD->( AdsSetOrder( 1)), cSklPol
  Local nCount := 1, nRecCount, nMnozZadan, nMnozPlano, n, n1, n2, n3, n4
  Local lOK
  Local cClr := "n/gr+*, w+/b*, gr+*/b+"
*  Local cMSG := IF( nTyp == 4, 'Prob¡h  generov n¡ materi lovìch po§adavk… ...',;
*                               'Prob¡h  generov n¡ vìrobn¡ch podklad… ...'      )
  /*
  IF nTYP == 5
    CreateTMP( 'PolOP_02', 'PolOP_02', NO)
    AdsSetOrder( 2)
  ENDIF
  */
  IF ::nTypZAP == typZAP_DILPR
     drgDBMS:open('PolOP_02',.T.,.T.,drgINI:dir_USERfitm); dbZAP()
  ENDIF

  aA := {}
*  ::nOBJ := ::nMZD := 0
  dbSelectAREA( 'KusTREE')
  ( AdsSetOrder( 1), nRecCount := LastREC(), dbGoTOP() )
  cTypStrFIN := KusTREE->cTypSTR   // Typ støediska u finálu

  IF ( lOK := VyrZak->( RLock()) )   //  ReplRec( 'VyrZak'))
    IF ( ::nTypZAP < 4 .OR. ::nZpusobZAP == zpuZAP_MAT     .OR. ;
                            ::nZpusobZAP == zpuZAP_MATLIS )
      // Pokud nTyp = 4 a nZpusob = 2 ( pouze ML), není tøeba tento cyklus !!!
*      BOX_THERMO( 1, nCount, nRecCount, '( Okam§ik pros¡m ... )', cMSG, cClr, 9 )

      ::MAT_ObjHead( 1)

      snPORADI := 999
      DO WHILE !KusTREE->( Eof())
        IF KusTree->lZapustit
          ** MATERIÁL - generují se záznamy do ObjITEM
          IF ::nZpusobZAP == zpuZAP_MAT .or. ::nZpusobZAP == zpuZAP_MATLIS   // ... byl zvolen materiál nebo obojí

            ::Polotovar()

            IF KusTree->lNakPol              // ... jde o nakupovanou položku
              IF     snGenMatPoz == KUMULpol     ;   GenArray( 1)
              ELSEIF snGenMatPoz == KUMULpolpoz  ;   GenArrPolPoz( 1)
              ELSE                               ;   ::GenMATERIAL()
              ENDIF
            ENDIF

          ENDIF

          ** MZDOVÉ LÍSTKY - generují se záznamy do ListHD, ListIT
          IF ::nZpusobZAP == zpuZAP_LIS .or. ::nZpusobZAP == zpuZAP_MATLIS   //... lístky nebo obojí
            IF KusTREE->lZapustit            // !!! opìtovný test, pokud se pro typ zapouštìní po položkách
                                               //     zmìnila položka lZapustit
              IF !KusTree->lNakPol             //... jde o vyrábìnou položku
                KusTree->( dbSkip())
                ::cSklPol := If( KusTree->lNakPol, KusTree->cSklPol, Space( 15))
                KusTree->( dbSkip( -1))
                ::GenLISTKY( cSklPol)
              ENDIF
            ENDIF
          Endif
           //
        Endif

        ( KusTree->( dbSkip()), nCount++ )
      ENDDO

      IF snGenMatPoz == KUMULpol  // .OR. snGenMatPoz == KUMULpolpoz
         GenArray( 2)
         For n := 1 To Len( aA)
           ::GenMATERIAL( aA[ n, 1], aA[ n, 3], aA [ n, 4], aA[ n, 2] )
         Next
      ENDIF
      IF snGenMatPoz == KUMULpolpoz  // .OR. snGenMatPoz == KUMULpolpoz
         GenArrPolPoz( 2)
         For n := 1 To Len( aA)
           ::GenMATERIAL( aA[ n, 1], aA[ n, 3], aA [ n, 4], aA[ n, 2] )
         Next
      ENDIF

      ::MAT_ObjHead( 0)

    ENDIF

    ** Zapouštìní po skupinách ... STS Prunéøov
    IF ::nTypZAP = typZAP_POSKU   // nTyp == 4
      /*
      KusOpBrow( nTyp)
      GenMZDLIST()
      */
    ENDIF
    ** Zapouštìní po dílnách + pracovištì ... Bluetech Pacov
    IF ::nTypZAP = typZAP_DILPR    // nTyp == 5
      IF ::nZpusobZAP == zpuZAP_LIS .or. ::nZpusobZAP == zpuZAP_MATLIS
        PolOP_02->( dbCommit(), dbGoTOP(), AdsSetOrder( 1) )
        ::nMZD := VYR_GenLISTKY_DILPR()   // GenLISTKY_5()
        VYR_GenPracVaz()
      EndIF
    ENDIF

    // Aktualizace VyrZak po zapuštìní
    // If( nMZD > 0 .OR. nOBJ > 0)
        nMnozZadan := VyrZak->nMnozZadan + snMnZapus
        nMnozPlano := VyrZak->nMnozPlano // + VyrZak->nMnozNavys - VyrZak->nMnozStorn
        VyrZak->nMnozZadan := MIN( nMnozZadan, nMnozPlano )
    // EndIf
    VyrZak->cStavZakaz := ;
      IF( ::nTypZAP == 2 .or. ::nZpusobZAP == 1 .or. ::nZpusobZAP == 2,;
          Alltrim( Str( MAX( VAL( '5'), Val( VyrZak->cStavZakaz)))),;
      IF( ::nTypZAP == 1 .or. ::nTypZAP == 3 .or. ::nTypZAP == 4 .or. ::nTypZAP == 5, '6', '' ) )

    VyrZak->cStavMatZa := ;
      If( ::nTypZAP == 1 .and. ::nOBJ > 0, '2',;
      IF( ::nTypZAP == 2 .and. ::nOBJ > 0, Alltrim( Str( MAX( VAL( '1'), Val( VyrZak->cStavMatZa)))),;
      IF( ::nOBJ == 0, Alltrim( Str( MAX( VAL( '0'), Val( VyrZak->cStavMatZa)))), '' )))

    n1 := If( ( ::nTypZAP == 1 .OR. ::nTypZAP == 3 .OR. ::nTypZAP == 4 .OR. ::nTypZAP == 5 ) .AND. ;
              ( ::nOBJ > 0 .OR. ::nMZD > 0), 1, 0 )
    VyrZak->nPocCeZapZ += n1

    n2 := If( ::nTypZAP == 2 .AND. ( ::nOBJ > 0 .OR. ::nMZD > 0), 1, 0 )
    VyrZak->nPocNeZapZ += n2

    n3 := If( ( ::nZpusobZAP == 1 .OR. ::nZpusobZAP == 3) .AND. ;
              ( ::nTypZAP == 1 .OR. ::nTypZAP == 3 .OR. ::nTypZAP == 4) .AND. ;
                ::nOBJ > 0, 1, 0)
    VyrZak->nPocCeOdMa += n3

    n4 := If( ( ::nZpusobZAP == 1 .OR. ::nZpusobZAP == 3) .AND. ::nTypZAP == 2 .AND. ::nOBJ > 0, 1, 0)
    VyrZak->nPocNeOdMa += n4
    *
    IF VyrZakIT->( RLock())
      VyrZakIT->nMnozZadan := MIN( VyrZakIT->nMnozZadan + snMnZapus, VyrZakIT->nMnozPlano )
      VyrZakIT->cStavZakaz := VyrZak->cStavZakaz
      VyrZakIT->cStavMatZa := VyrZak->cStavMatZa
      VyrZakIT->nPocCeZapZ += n1
      VyrZakIT->nPocNeZapZ += n2
      VyrZakIT->nPocCeOdMa += n3
      VyrZakIT->nPocNeOdMa += n4
      VyrZAKIT->( dbUnlock())
    ENDIF
    *
    VyrZAK->( dbUnlock(), dbCommit(), dbSkip(0) )     // DCrUnlock( 'VyrZak')
    ListHD->( AdsSetOrder( cTag1))
  ELSE
    drgMsgBox(drgNLS:msg('Zakázku nelze zapustit, nebo je blokována jiným uživatelem !'),, ::drgDialog:dialog)
  ENDIF
  dbCommitAll()

RETURN self

*
********************************************************************************
METHOD VYR_ZAKzapus:CheckItemSelected( CheckBox)
  Local name := drgParseSecond( CheckBox:oVar:Name,'>')

  self:&Name := CheckBox:Value
RETURN self

* Zapuštìní zakázky PO POLOŽKÁCH
********************************************************************************
METHOD VYR_ZAKzapus:Zapustit_POPOL()
  LOCAL  oDialog,  nExit

  oDialog := drgDialog():new('VYR_Zapus_PoPol',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
*    ::TreeRebuild()
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
RETURN self

* Zapuštìní zakázky DLE DÍLEN A PRACOVIŠ
********************************************************************************
METHOD VYR_ZAKzapus:Zapustit_DILPR()
  LOCAL  oDialog,  nExit

  oDialog := drgDialog():new('VYR_Zapus_DilPr',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
*    ::TreeRebuild()
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
RETURN self

*
********************************************************************************
METHOD VYR_ZAKzapus:INFO_zapus( cINFO)

  IF Valtype( cINFO ) == "C"
    ::INFO_zapus := cINFO
    ::dm:set('M->INFO_Zapus', ::INFO_zapus)
    ::dm:save()
    ::dm:refresh()
  ENDIF
RETURN  ::INFO_zapus

*
********************************************************************************
METHOD VYR_ZAKzapus:destroy()
  ::drgUsrClass:destroy()
* STATICs
  snGenMatPoz := ;
  NIL
*
  ::cFileZAP   := ;
  ::lRozpadK   := ::lRozpadT := ::cRozpadK := ::cRozpadT := ;
  ::nZpusobZAP := ::nTypZAP  := ::nOBJ := ::nMzd := ;
  ::nMnZapus   := ;
  ::INFO_zapus := ;
  NIL
RETURN self

*** HIDDEN ***

*
* HIDDEN ***********************************************************************
METHOD VYR_ZAKzapus:WhatSTAV()
  Local lOK := YES, lExit := NO
  Local cText, cStav := VyrZak->cStavZakaz, nCho

  DO CASE
    CASE cStav == '0 ' // Storno
         cText := 'Zakázka byla stornována, nelze zapouštìt !'
         lExit := YES
    CASE cStav == '5 ' // èásteènì zapuštìna
         cText := 'Zakázka již byla èásteènì zapuštìna.;' + ;
                  'Opravdu chcete zakázku znovu zapustit ?'
    CASE cStav == '6 ' // Kompletnì zapuštìna
         cText := 'Zakázka již byla kompletnì zapuštìna.;' + ;
                  'Opravdu chcete zakázku znovu zapustit ?'
    CASE cStav == '7 ' // èásteènì odvedena
         cText :=  'Zakázka již byla èásteènì odvedena.;' + ;
                   'Opravdu chcete zakázku znovu zapustit ?'
    CASE cStav == 'P ' // Pøijata do expedice
         cText := 'Zakázka již byla pøijata do expedice, nelze zapouštìt !'
         lExit := YES
    CASE cStav == 'U ' // Ukonèena
         cText := 'Zakázka již byla ukonèena, nelze zapouštìt !'
         lExit := YES
    OTHERWISE          // Dosud nebyla zapuštìna
         cText := 'Opravdu požadujete zapuštìní zakázky ?'
  ENDCASE
  cText := drgNLS:msg( cText)

  IF lExit             // nelze zapouštìt
    drgMsgBox( cText)
    lOK := NO
  ELSE
    * drgIsYESNO( cText)

    nCho := AlertBOX( , cText ,;
                        { "~Ne", "~Ano", "~Zapustit s aktualizací" }  ,;
                        XBPSTATIC_SYSICON_ICONQUESTION,;
                        'Zvolte možnost'    )

    lOK := IF( nCho == 0 .or. nCho == 1, NO, lOK )
    IF nCho == 2       // Zapustit ANO
      IF cStav <> '5 ' .AND. cStav <> '6 ' .AND. cStav <> '7 '
        ::INFO_zapus :=  drgNLS:msg( 'Kontrola kusovníku ...')
        IF ( lOK := VYR_ZakKUSOV() )
          lOK := VYR_VyrPolDT()
        ENDIF
      ENDIF
    ELSEIF nCho == 3   // Zapustit s aktualizací
      ::INFO_zapus :=  drgNLS:msg( 'Kontrola kusovníku ...')
      VYR_KusForRV( VyrZak->cCisZakaz, EMPTY_ZAKAZ, VyrZak->cVyrPol, VyrZak->nVarCis, YES, YES )
      lOK := VYR_VyrPolDT()
    ENDIF
  ENDIF
RETURN( lOK)

* Kontrola na existenci vyr.položek pøi zapouštìní vícepoložkové zakázky
* HIDDEN ***********************************************************************
METHOD VYR_ZAKzapus:VyrPOL_exists()
  Local lOK := .T., lSeek, Filter, cKey, nRec

  IF ( VyrZAK->nPolZAK = 2)
    IF ::cFileZAP = 'VyrZak'  //
       ** Zapuštìní položkové zakázky z obrazovky VYRZAK ( všechny položky)
       nRec := VyrZakIT->( RecNO())
       Filter := FORMAT("cCisZakaz = '%%'",{ VyrZAK->cCisZakaz } )
       VyrZakIT->( mh_SetFilter( Filter))
       DO WHILE !VyrZakIT->( EOF())
         cKey := Upper( VyrZakIT->cCisZakaz) + Upper( VyrZakIT->cVyrPol) + ;
                 StrZERO( VyrZakIT->nOrdItem, 3)
         lSeek := VyrPOL->( dbSEEK( cKEY ,,'VYRPOL1'))
         lOK := IF( lSeek, lOK, .F. )
         *
         VyrZakIT->( dbSkip())
       ENDDO
       VyrZakIT->( mh_ClrFilter())
       VyrZakIT->( dbGoTO( nRec))
    ENDIF
    *
    IF .not.lOK
      cText := drgNLS:msg( 'V položkách výrobní zakázky jsou neexistující vyrábìné položky !;;' + ;
                           'Chcete pokraèovat v zapouštìní ?' )
      lOK := drgIsYESNO( cText)
    ENDIF
    *
  ENDIF

RETURN( lOK)

*********** HIDDEN METHODs *****************************************************

* Modifikace ObjHead pøi generování materiálových požadavkù
* HIDDEN ***********************************************************************
METHOD VYR_ZAKzapus:MAT_ObjHEAD( nAction)
  Local  cKey, lOK, lExist, aX := { 0, 0, 0, 0, 0 }
  Static lNakPol

  Default lNakPol To NO

If ::nZpusobZAP == zpuZAP_MAT .or. ::nZpusobZAP == zpuZAP_MATLIS // Materiál nebo Obojí
  If nAction == 1                 // Založí novou ObjHead, nebo uzamkne existující
     * Zjistí se, zda kusovník obsahuje nìjaké nak.pol. ...
     KusTree->( dbEval( ;
               {|| lNakPol := If( KusTree->lNakPol, KusTree->lNakPol, lNakPol) }))
     KusTree->( dbGoTop())
     * ... pokud ano, ...
     If lNakPol
       cKey := VyrZak->cCisZakaz + StrZero( MyFIRMA, 5)
       lExist := ObjHead->( dbSeek( Upper( cKey)))
       *=
       If ( lOK := If( lExist, ObjHead->( RLock()), ObjHead->( dbAppend(), RLock()) ))
          If !lExist
            // ... a dosud neexistuje Hl. obj. pøijaté, založí se.
//            ObjHead->cUloha     := RIZENI_VYROBY
            ObjHead->nCisFirmy  := MyFIRMA
            ObjHead->cCislObInt := VyrZak->cCisZakaz
            ObjHead->nCislObInt := VYR_NewCisObjHEAD( VyrZak->cCisZakaz)
            ObjHead->dDatObj    := Date()
            ObjHead->dDatDoOdb  := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
            ObjHead->cNazPracov := SysConfig( 'System:cUserAbb')
            ObjHead->cCisZakaz  := VyrZak->cCisZakaz

            ObjHead->ndoklad    := ::ndoklad_OBJHEAD  //newDokladZAD()
            ObjHead->culoha     := 'V'
            ObjHead->ctask      := 'VYR'
            ObjHead->ctypdoklad := 'VYR_ZADMAT'
            ObjHead->ctyppohybu := 'ZADANMAT'

          Endif
       Endif
       *=*
     EndIf

  ElseIf nAction == 0     //Ä Aktualizace ObjHead sumaŸn¡ma hodnotama z ObjItem
     If lNakPol
        cKey :=  StrZero( MyFIRMA, 5) + VyrZak->cCisZakaz
        FOrdRec( { 'ObjItem, 1' })
        ObjITEM->( mh_SetScope( Upper( cKey) ) )
          ObjItem->( dbEval( {||  aX[ 1] += 1                    ,;
                                  aX[ 2] += ObjItem->nKcsBdObj   ,;
                                  aX[ 3] += ObjItem->nKcsZdObj   ,;
                                  aX[ 4] += ObjItem->nMnozObODB  ,;
                                  aX[ 5] += ObjItem->nMnozPoODB   }))
        ObjItem->( mh_ClrScope())
        FOrdRec()
//        ObjHead->nPocPolObj := aX[ 1]
        ObjHead->nKcsBdObj  := aX[ 2]

        ObjHead->nKcsZdObj  := aX[ 3]
        ObjHead->nMnozObODB := aX[ 4]
        ObjHead->nMnozPoODB := aX[ 5]
        ObjHead->nCenaZakl  := ObjHead->nKcsBdObj
        ObjHead->( dbUnlock(), dbCommit(), dbSkip(0) )   // DCrUnlock( 'ObjHead')

     EndIf
  EndIf
EndIf

RETURN self

*
* HIDDEN ***********************************************************************
METHOD VYR_ZAKzapus:Polotovar()
  Local nREC := KusTREE->( RecNO()), nVyrST := KusTREE->nVyrST

  IF ::nTypZAP = typZAP_POPOL    // Zapuštìní po položkách
    IF ( cTypStrFIN == KusTREE->cTypSTR .AND. KusTREE->nMnZadVA == 0 ) .OR. ;
         cTypStrFIN <> KusTREE->cTypSTR

        IF  SysCONFIG( 'Vyroba:lOptimMnoz')
           VYR_SetZAPUSTIT( NO, 1 )
           KusTREE->lNakPOL := YES
        ELSE
           VYR_SetZAPUSTIT( NO, 2 )
        ENDIF
    ELSE
        IF SysCONFIG( 'Vyroba:lOptimMnoz')
        ELSE
           VYR_SetZAPUSTIT( YES, 2 )
        ENDIF
    ENDIF
  ENDIF

RETURN self

* Aktualizace Kustree pøi zapouštìní
* Aktualizuje se množství zadané do výroby KusTree->nMnZadVA
* HIDDEN ***********************************************************************
METHOD VYR_ZAKzapus:KusTreeAKT()
  Local nRec, nMnZadVA, nVyrST
  Local cTag, cKey

  if( vyrZak->nautoPlan = 1, ::nTypZAP := typZAP_KOMPL, nil )

  DO CASE
  * Aktualizuje všechny položky ( kompletní + dílèí rozpad)
  CASE ::nTypZAP == typZAP_KOMPL .or. ;
       ::nTypZAP == typZAP_DILCI
    KusTree->( dbGoTop(),;
               dbEVAL( {|| KusTree->nMnZadVA := KusTree->nSpMnoNas * ::nMnZapus }),;
               dbGoTop())

  * Aktualizuje materiály i vyr.položky ( rozpad po položkách)
  CASE ::nTypZAP == typZAP_POPOL
    KusTree->( dbClearFilter(), dbGoTop() )
    cTag := KusTree->( AdsSetOrder( 1))
    DO While !KusTree->( Eof())
      nRec := KusTree->( RecNo())
      If !KusTree->lNakPol      // ... aktualizují se materiály i vyr.položky,
         cKey := Left( KusTree->cTreeKey, Len( AllTrim( KusTree->cTreeKey))-3 )
         nMnZadVA := KusTree->nMnZadVA
         nVyrSt   := KusTree->nVyrSt
         KusTree->( mh_SetScope( cKey )) // ... které jsou nejbližší nižší k vyrábìné položce
         KusTree->( dbEVAL( {||;
           If( KusTree->lNakPol .and. KusTree->nVyrST == nVyrST+1,;
                         KusTree->nMnZadVA := nMnZadVA * KusTree->nSpMno,;
              If( !KusTree->lNakPol .and. KusTree->nVyrST == nVyrST+1,;
                         KusTree->nMnZadVAvp := nMnZadVA, NIL ) ) }))
         KusTree->( mh_ClrScope(), dbGoTo( nRec) )
      Endif
      KusTree->( dbSkip())
    EndDo
    KusTree->( AdsSetOrder( cTag), dbGoTop() )
  ENDCASE
RETURN self


*============ STATIC FUNCTION ==================================================

* Generuje pole, pokud je konfiguraènì nastaveno kumulovat opakující se
* materiálové požadavky ve strukturovaném kusovníku, za skl. položku.
*===============================================================================
STATIC FUNCTION GenARRAY( nMeth)
  Local nPos, n, m, nMnozKUM := 0, cKEY, aITEMs

  If nMeth == 1
     /* Ukládá výskyt skl.položky ve struktuøe KusTree do pole
       { cSklPol, cKodPoz, { KusTree->( RecNo()), ..., ...  } }
     */
     nPos := aSCAN( aA, {|X| X[ 1] == KusTree->cSklPol } )
     If nPos > 0 ;  aADD( aA[ nPos, 3], KusTree->( RecNo()) )
     Else
       * 1.výskyt položky
       cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
               StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
       Kusov->( dbSeek( cKey))
       aITEMs := { Kusov->cText1, Kusov->cText2 }

       aADD( aA, { KusTree->cSklPol, KusTree->cKodPoz, { KusTree->( RecNo()) }, aITEMs } )
     Endif
  ElseIf nMeth == 2
     /* V poli aA  nahradí subpole èísel záznamù z KusTree vysouètovanou hodnotou nMnozKUM
       { cSklPol, nMnozKum, aITEMs }
     */
     For n := 1 To Len( aA)
        For m := 1 To Len( aA[ n, 3])
          KusTree->( dbGoTo( aA[ n, 3, m]))
          NakPol->( dbSeek( Upper( KusTree->cSklPol)))
          nMnozKUM += KusTree->nSpMnoNas   //  * nMnZapus * ;
                      // If( NakPol->nKoefPrep <> 0, NakPol->nKoefPrep, 1 )
        Next
        aA[ n, 3] := nMnozKUM
        nMnozKUM  := 0
     Next
  Endif
RETURN Nil

* Generuje pole za Skl.pol. + kód pozice
*===============================================================================
STATIC FUNCTION GenArrPolPoz( nMeth)
  Local nPos, n, m, nMnozKUM := 0, cKEY, aITEMs

  IF nMeth == 1
     /* Ukládá  výskyt skl.položky ve struktuøe KusTree do pole
        { cSklPol, cKodPoz, { KusTree->( RecNo()), ..., ...  } }
     */
     nPos := aSCAN( aA, {|X| X[ 1] == KusTree->cSklPol .AND. X[ 2] == KusTREE->cKodPoz } )
     If nPos > 0 ;  aADD( aA[ nPos, 3], KusTree->( RecNo()) )
     Else
       * 1.výskyt položky
       cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
               StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
       Kusov->( dbSeek( cKey))
       aITEMs := { Kusov->cText1, Kusov->cText2 }

       aADD( aA, { KusTree->cSklPol, KusTree->cKodPoz, { KusTree->( RecNo()) }, aITEMs } )
     Endif
  ELSEIF nMeth == 2
     /* V poli aA  nahradí subpole èísel záznamù z KusTree vysouŸtovanou hodnotou nMnozKUM
        { cSklPol, cKodPoz, nMnozKum, aITEMs }
     */
     For n := 1 To Len( aA)
        For m := 1 To Len( aA[ n, 3])
          KusTree->( dbGoTo( aA[ n, 3, m]))
          nMnozKUM += KusTree->nSpMnoNas
        Next
        aA[ n, 3] := nMnozKUM
        nMnozKUM  := 0
     Next
  ENDIF
RETURN Nil

* Generování MATERIÁLových požadavkù
*===============================================================================
** STATIC FUNCTION GenMATERIAL( nTyp, cSklPol, nMnozKUM, aITEMs, cKodPoz)
METHOD VYR_ZAKzapus:GenMATERIAL( cSklPol, nMnozKUM, aITEMs, cKodPoz)

  Local cKey, lOK, lCenZboz, lObjItem, lAppend
  Local nRecTree := KusTree->( RecNo()), nRec, nCislPolOb, nMnoz
  Local nTypREZER := REZER_STD
  // Parametry cSklPol, nMnozKum, aITEMs se uplatòují pouze u cGenMatPoz = KUMUL
  //  aITEMs = { Kusov->cText1, Kusov->cText2 } ... lze rozšíøit

IF snGenMatPoz == KUMULpol .OR. snGenMatPoz == KUMULpolpoz
  * Pro vícenásobný výskyt nakup. položky se generuje jeden kumulovaný záznam v ObjItem
  FOrdRec( { 'CenZboz, 1', 'ObjItem, 2' } )
  cKey     := Upper( cSklPol)
  NakPol->( dbSeek( cKey))
  lCenZboz := CenZboz->( dbSeek( cKey))
  cKey     := Upper( cSklPol) + Upper( VyrZak->cCisZakaz)
  lObjItem := ObjItem->( dbSeek( cKey))
  * Pro nTyp = 5 vždy generovat nové objednávky
  lObjItem := IF( ::nTypZAP == typZAP_DILPR, NO, lObjItem )

  IF lCenZboz        //  skladová položka na skladì existuje ...

    lOK := If( lObjItem, ObjItem->( Sx_RLock()), ObjItem->( dbAppend(), Sx_Rlock()) )

    IF lOK .and. CenZboz->( Sx_RLock())   //--ReplRec( 'CenZboz')
      * Modifikuje soubor ObjItem
      IF !lObjItem  // ... jde o nový požadavek na materiál
        ::nOBJ++
        nCislPolOb := VYR_NewCisObjITEM()
        mh_COPYFLD( 'CENZBOZ', 'OBJITEM')  // PutItem( 'ObjItem', 'CenZboz')
        ObjItem->nCisFirmy  := MyFIRMA
        ObjItem->cCislObInt := VyrZak->cCisZakaz
        ObjItem->nCislPolOb := nCislPolOb
        ObjItem->cSklPol    := cSklPol
        ObjItem->cKodPoz    := cKodPoz
        ObjItem->dDatVpInt  := VyrZak->dZapis
        ObjItem->dDatReOdb  := Date()
        ObjItem->dDatDoOdb  := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        ObjItem->dDatOdvVyr := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        ObjItem->nIntIndOBJ := 0
        ObjItem->cCisZakaz  := VyrZak->cCisZakaz
        *ObjItem->cZkratJEDN := CenZboz->cZkratJEDN
        ObjItem->nRokRV     := YEAR( DATE())
        ObjItem->nPolObjRV  := VYR_PolObjRV()
        ObjItem->cText1     := aITEMs[ 1]   // Kusov->cText1
        ObjItem->cText2     := aITEMs[ 2]   // Kusov->cText2
        ObjItem->nPocCeZapZ := VyrZAK->nPocCeZapZ + 1

        ObjItem->ndoklad    := ObjHead->ndoklad
        ObjItem->culoha     := 'V'
        ObjItem->ctask      := 'VYR'
        ObjItem->ctypdoklad := 'VYR_ZADMAT'
        ObjItem->ctyppohybu := 'ZADANMAT'

        mh_WRTzmena( 'ObjItem', .T.)
      ENDIF
      * Pøed modifikací provede kontrolní pøepoèet CenZboz, analogicky jako
      *   v kontrolním pøepoŸtu ve SKLADECH
      VYR_PrepocetCEN()
      * Rezervace ...
      RezervSKL( nMnozKUM)
      * Výpoèet pøirážky ...  11.1.2002
      ObjItem->nKcsBdObj  +=  VYR_PrirazkaCMP( 'ObjItem->nKcsBdObj' )

      ( CenZboz->( DBUnlock()), ObjItem->( DBUnlock()) )
    ENDIF
  ELSE
    * Co když neexistuje v CenZboz
  ENDIF
  FOrdRec()

ELSEIF snGenMatPoz == KUMULbez

  IF ::nTypZAP = typZAP_POPOL  // Zapuštìní po položkách
    IF  cTypStrFIN == KusTREE->cTypSTR .AND. KusTREE->nMnZadVA <> 0
      nTypREZER := REZER_STD
    ELSEIF ( cTypStrFIN == KusTREE->cTypSTR .AND. KusTREE->nMnZadVA == 0 ) .OR. ;
             cTypStrFIN <> KusTREE->cTypSTR
      nTypREZER := REZER_2
    ENDIF
  ENDIF

  * Pro vícenásobný výskyt nakup. položky se generuje stejný poèet záznamù v ObjItem
  * Napozicování souborù
  cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
           StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
  *
  IF !Kusov->( dbSeek( cKey))
    * 22.7.10
    nTypVar := SysConfig( 'Vyroba:nTypVar')
    nTypVar := If( IsArray( nTypVar), 1, nTypVar )
    *
    IF nTypVar = 1
      cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
               StrZero( KusTree->nPozice, 3) + '001'

      IF Kusov->( dbSeek( cKey))
  *      lAppend := .t.
      ENDIF
    ELSEIF nTypVar = 2
    ENDIF
  ENDIF

  cKey := Upper( KusTree->cSklPol)
  NakPol->( dbSeek( cKey))
  FOrdRec( { 'CenZboz, 1', 'ObjItem, 11' } )
  lCenZboz := CenZboz->( dbSeek( cKey))
  /* IT
  cKey := StrZero( MyFIRMA, 5) + Upper( Kusov->cCislObInt) + ;
          StrZero( Kusov->nCislPolOb, 5)
  lObjItem := IF( EMPTY( Kusov->cCislObInt), NO, ObjItem->( dbSeek( cKey)) )
  */
  *
  cKey := StrZero( MyFIRMA, 5) + Upper( VyrZakIT->cCisZakazI) + ;                 // it
          StrZero( Kusov->nCislPolOb, 5)
  lObjItem := IF( EMPTY( Kusov->cCislObInt), NO, ObjItem->( dbSeek( cKey,, 'OBJITE17')) )  // it
  * Tag 18 = STRZERO(nCisFirmy,5) +UPPER(cCisZakazI) +STRZERO(nCislPolZa,5)

  * Pro nTyp=5 vždy generovat nové obj. ( zapouštìní dle dílen a pracoviš)
  lObjItem := IF( ::nTypZAP == typZAP_DILPR, NO, lObjItem )

  IF lCenZboz        // skladová položka na skladì existuje ...
    lOK := If( lObjItem, ObjItem->( Sx_RLock()), ObjItem->( dbAppend(), Sx_Rlock()) )
    IF lOK .and. CenZboz->( Sx_RLock()) .and. Kusov->( Sx_RLock())
      // Modifikuje soubor ObjItem
      IF !lObjItem    // ... jde o nový požadavek na materiál
        ::nOBJ++
        nCislPolOb := VYR_NewCisObjITEM()
        //*
        mh_COPYFLD( 'CENZBOZ', 'OBJITEM')  // PutItem( 'ObjItem', 'CenZboz')
        ObjItem->nCisFirmy  := MyFIRMA
        ObjItem->cCislObInt := VyrZak->cCisZakaz
        ObjItem->nCislPolOb := nCislPolOb
        ObjItem->cSklPol    := KusTree->cSklPol
        ObjItem->dDatVpInt  := VyrZak->dZapis
        ObjItem->dDatReOdb  := Date()
        ObjItem->dDatDoOdb  := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        ObjItem->dDatOdvVyr := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        ObjItem->nIntIndOBJ := 0
        ObjItem->cCisZakaz  := VyrZak->cCisZakaz
        ObjItem->cCisZakazI := VyrZakIT->cCisZakazI
        ObjItem->nCislPolZa := ObjItem->nCislPolOb
        ObjItem->cZkratJEDN := CenZboz->cZkratJEDN
        ObjItem->cVyrPol    := KusTree->cVysPol
        ObjItem->nVarCis    := IF( VYR_IsVyrZakIT(), VyrZakIT->nOrdItem, KusTree->nVysVar )   // 10.4.2007
        ObjItem->nPozice    := KusTree->nPozice
        ObjItem->nRAvyska   := Kusov->nRozmA
        ObjItem->nRBsirka   := Kusov->nRozmB
        ObjItem->cText1     := Kusov->cText1
        ObjItem->cText2     := Kusov->cText2
        ObjItem->nMnNaKus   := KusTree->nSpMno
        ObjItem->nRokRV     := YEAR( DATE())
        ObjItem->nPolObjRV  := VYR_PolObjRV()
        ObjItem->nNavysPrc  := Kusov->nNavysPrc
        ObjItem->nKusRoz    := Kusov->nKusRoz
        ObjItem->nPocCeZapZ := VyrZAK->nPocCeZapZ + 1
        ObjItem->cKodPoz    := Kusov->cKodPoz

        ObjItem->ndoklad    := ObjHead->ndoklad
        ObjItem->culoha     := 'V'
        ObjItem->ctask      := 'VYR'
        ObjItem->ctypdoklad := 'VYR_ZADMAT'
        ObjItem->ctyppohybu := 'ZADANMAT'

        mh_WRTzmena( 'ObjItem', .T.)
        * Modifikuje záznam v Kusov
        Kusov->cCislObInt   := ObjItem->cCislObInt
        Kusov->nCislPolOb   := IF( Kusov->nCislPolOb = 0, ObjItem->nCislPolOb, Kusov->nCislPolOb)
        ObjItem->nCislPolZa := Kusov->nCislPolOb
        */
      ENDIF
      //*
      ObjItem->nPocet  += ROUND( KusTree->nMnZadVA / KusTree->nSpMno, 0 )
      * Požadující stø. se naplní z vyr.pol. nejbližší vyšší
      nREC := VyrPol->( RecNO())
      cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
              StrZero( KusTree->nVysVar, 3)
      VyrPol->( dbSeek( cKey))
      ObjItem->cStred := VyrPol->cStrVyr
      VyrPol->( dbGoTO( nREC))
      * Pøed modifikací provede kontrolní pøepoèet CenZboz, analogicky jako
      *   v kontrolním pøepoètu ve SKLADECH       16.5.2003
      VYR_PrepocetCEN()
      * REZERVACE ...
      RezervSKL( ,nTypREZER)
      * Výpoèet pøirážky ...
      ObjItem->nKcsBdObj  += VYR_PrirazkaCMP( 'ObjItem->nKcsBdObj' )
      */
      ( CenZboz->( dbUnLock()), ObjItem->( dbUnLock()), Kusov->( dbUnLock()) )
    ENDIF
  ELSE
    // Co když neexistuje v CenZboz
  ENDIF
  FOrdRec()
ENDIF

RETURN NIL

* Rezervace v ceníku a objednávce pøijaté
********************************************************************************
STATIC FUNCTION RezervSKL( nMnozKUM, nTypREZER)
  Local nMnoz, nMnPOTREBY := KusTREE->nSpMnoNAS * snMnZapus, nMnKREZER
  Local nKoefPREP := IF( NakPOL->nKoefPREP <> 0, NakPOL->nKoefPREP, 1 )
  Local nVyrZakBUT := SysCONFIG( 'Vyroba:nVyrZakBut')
  Local lKVyrobe := ALLTRIM( UPPER( NakPOL->cKodTPV)) == 'R'  .OR. ;
                    ALLTRIM( UPPER( NakPOL->cKodTPV)) == 'P'

  DEFAULT nTypREZER TO REZER_STD

  nMnoz := IF( ISNIL( nMnozKUM),  KusTree->nMnZadVA * nKoefPREP   ,;
                                  nMnozKUM * nMnZapus * nKoefPREP  )
  * ZPS Zlín !!!
*  IF nVyrZakBUT == ZPS_ZLIN
    nMnoz := IF( nMnoz > 0 .AND. nMnoz < 0.005, 0.01, nMnoz)
    * Používají tak malé množství, že nám by figurovala jako mn.nulová  25.1.2001
*  ENDIF

  nMnKREZER := nMnPOTREBY - nMnoz

  IF Upper( AllTrim( NakPol->cKodRezSkl)) == 'A'
     IF nTypREZER == REZER_STD
       IF lKVyrobe
         ObjItem->nMnozVpInt += MAX( nMnoz - CenZboz->nMnozDZBO, 0 )
       ELSE
         ObjItem->nMnozKoDod += MAX( nMnoz - CenZboz->nMnozDZBO, 0 )
       ENDIF
       ObjItem->nMnozObOdb += nMnoz
       ObjItem->nMnozPoOdb += nMnoz
       ObjItem->nMnozReOdb += MIN( nMnoz, CenZboz->nMnozDZBO )
       ObjItem->nKcsBdObj  += nMnoz * CenZboz->nCenaSZBO

     ELSEIF nTypREZER == REZER_2     //Ä
       IF CenZboz->nMnozDZBO < nMnKREZER
          nMnKREZER := CenZboz->nMnozDZBO
          nMnoz     := nMnPOTREBY - nMnKREZER
       ENDIF
       IF nMNOZ > 0
         ObjItem->nMnozVpInt += nMnoz
         ObjItem->nMnozObOdb += nMnoz
//         ObjItem->nMnozPoOdb += nMnoz
         ObjItem->nKcsBdObj  += nMnoz * CenZboz->nCenaSZBO
       ENDIF
       nMnKREZER := nMnPOTREBY - nMnoz
       IF nMnKREZER > 0
//         ObjItem->nMnozVpInt += OnlyToZero( nMnoz - CenZboz->nMnozDZBO )
         ObjItem->nMnozObOdb += nMnKREZER
         ObjItem->nMnozPoOdb += nMnKREZER
         ObjItem->nMnozReOdb += nMnKREZER
         ObjItem->nKcsBdObj  += nMnKREZER * CenZboz->nCenaSZBO
       ENDIF
     ENDIF

     * Modifikuje záznam v CenZboz
     IF nTypREZER == REZER_STD
       CenZboz->nMnozRZBO += MIN( nMnoz, CenZboz->nMnozDZBO )
       CenZboz->nMnozRSES += MIN( nMnoz, CenZboz->nMnozDZBO )
       If CenZboz->nMnozDZBO >= nMnoz
          CenZboz->nMnozDZBO -= nMnoz
       Else
          CenZboz->nMnozKZBO += nMnoz - CenZboz->nMnozDZBO
          CenZboz->nMnozDZBO := 0
       ENDIF
     ELSEIF nTypREZER == REZER_2
       CenZboz->nMnozRZBO += nMnKREZER
       CenZboz->nMnozRSES += nMnKREZER
       If CenZboz->nMnozDZBO >= nMnKREZER
          CenZboz->nMnozDZBO -= nMnKREZER
       ELSE
          CenZboz->nMnozDZBO := 0
       ENDIF
     Endif
     //ÄÄ Po modifikaci provede kontroln¡ pýepoŸet CenZboz, analogicky jako
     //   v kontroln¡m pýepoŸtu ve SKLADECH       16.5.2003
//     VYR_PrepocetCEN()
     //- 16.5.2003
  ELSE
     ObjItem->nMnKalkul  += nMnoz
     ObjItem->nMnozObOdb += nMnoz
     ObjItem->nKcsBdObj  += nMnoz * CenZboz->nCenaSZBO
     ObjItem->nMnozNeOdb += nMnoz
  ENDIF

RETURN nil


* Generování MZDOVÝCH LÍSTKÙ
*===============================================================================
*STATIC FUNCTION GenLISTKY( cSklPol)
METHOD VYR_ZAKzapus:GenLISTKY( cSklPol)
  Local cKey, cSCOPE, lOK, lExist, lSEM := YES, lPolOPER := NO, lFIRST := YES
  Local nCfg :=  SysCONFIG( 'Vyroba:nMzdaZaKus')
  Local nRUNs := 0, nHandle, nHLP, nRecAKT, nCisOper, nUkonOper
  Local cICO := STRZERO( SysCONFIG( 'System:nIco'))
  Local cSEMAPH := cICO + '\GenLISTKY' , nMn

IF ::nTypZAP == typZAP_POSKU   //    tj. nRozpad == ROZPAD_POSKU
   // tak opravdu nevím
ELSE
  /*/ Proces "uzamkneme"
  DO WHILE lSEM
    nHandle := NNETSEMOPN( cSEMAPH )
    IF nHandle <> -1
      nRUNs := NNETSEMOPC( nHandle)
      IF( nRUNs > 1, NNETSEMCLO( nHandle), lSEM := NO )
    ENDIF
  ENDDO
  */
  * Pomocná položka do ListHD pro potøeby nìjakého tøídìní ... 10.1.2001
  snPORADI := IF( KusTREE->( RecNO()) == 1, 999, snPORADI - 1 )

  /* Omezení PolOper ke každé vyrábìné položce
  */
  IF ::nTypZAP == typZAP_DILPR
    cScope := Upper( KusTree->cCisZakaz) + ;
              If( KusTree->lNakPol, KusTree->cVysPol, KusTree->cVyrPol )
    ScopeOPER_5( cSCOPE)
    ::GEN_ListHDIT()
    ScopeOPER_5()

  ELSE
    VYR_ScopeOPER( .F.)
    VYR_ScopeOPER()

    ::GEN_ListHDIT()
    VYR_ScopeOPER( .F.)
  ENDIF

ENDIF

RETURN Nil


// generování mzdového lístku pøi zapouštìní
*
** HIDDEN **********************************************************************
METHOD VYR_ZAKzapus:Gen_ListHDIT( nMnZadVA)
  Local cKey, cSCOPE, lOK, lExist, lSEM := YES, lPolOPER := NO, lFIRST := YES
  Local nCfg :=  SysCONFIG( 'Vyroba:nMzdaZaKus')
  /*
  DO CASE
    CASE IsNIL( nMnZadVA)           // Lístky se generují na zapouštìné množství
      nMnZadVA := KusTree->nMnZadVA
    CASE nMnZadVA = 1               // Lístky se generují na 1 kus  ( KOVAR)
      nMnZadVA := KusTree->nMnZadVA / ::nMnZapus
  ENDCASE
  */

  nMnZadVA := KusTree->nMnZadVA
  * Ke každému záznamu v PolOper se generuje záznam v ListHD a ListIT
  PolOper->( dbGoTop())
  nCisOper := PolOPER->nCisOper
  nUkonOper := PolOPER->nUkonOper

  DO WHILE !PolOper->( Eof())
    If ( PolOper->nZapusteno = 0 .or. PolOper->nZapusteno = 2) .and. PolOper->nPorCisLis = 0   // ... dosud nezapuštìno
      IF ::nTypZAP == typZAP_DILPR    // Zapuštìní po dílnách a pracovištích ...10.12.2001
         Operace->( dbSeek( Upper( PolOper->cOznOper)))
         PolOP_02->( dbAPPEND())
         mh_COPYFLD( 'PolOPER', 'PolOP_02')
         PolOP_02->cStred     := Operace->cStred
         PolOP_02->cOznPrac   := Operace->cOznPrac
         PolOP_02->cPracZar   := Operace->cPracZar
         PolOP_02->nDruhMzdy  := Operace->nDruhMzdy
         PolOP_02->cTarifStup := Operace->cTarifStup
         PolOP_02->cTarifTrid := Operace->cTarifTrid
         PolOP_02->nMnZadVA   := KusTREE->nMnZadVA
         PolOP_02->cNazev     := KusTREE->cNazev
         PolOP_02->nRecPolOp  := PolOper->( RecNO())
         mh_WRTzmena( 'PolOP_02', .T. )
      ELSE
        Operace->( dbSeek( Upper( PolOper->cOznOper)))
        cKey := Operace->cTarifStup + Operace->cTarifTrid
        C_Tarif->( dbSeek( Upper( cKey)))
        lPolOPER := YES

        * Naplnìní ListHD
        cKey := StrZero( Year( Date()), 4 ) + StrZero( PolOper->nPorCisLis, 12)
        lExist := ListHD->( dbSeek( Upper( cKey)))
        lOK := If( lExist, ListHD->( Sx_RLock()), ListHD->( dbAppend(), Sx_RLock() ) )
        If lOK
           If !lExist    // ... jde o nový lístek - HLAVIÈKA
              ListHD->nRokVytvor := Year( Date())
              ListHD->cCisZakaz  := KusTree->cCisZakaz
              ListHD->cVyrPol    := KusTree->cVyrPol
              ListHD->nVarCis    := KusTree->nVarCis
              ListHD->cNazev     := KusTree->cNazev
              ListHD->cCisZakazI := PolOPER->cCisZakazI
              ListHD->nCisOper   := PolOper->nCisOper
              ListHD->nUkonOper  := PolOper->nUkonOper
              ListHD->nVarOper   := PolOper->nVarOper
              ListHD->dVyhotPlan := IIf( KusTree->nVyrSt == 1, VyrZak->dOdvedZaka,;
                                    IIF( KusTree->nVyrSt == 2, VyrZak->dDodDilMon,;
                                         VyrZak->dOdvedZaka - VyrZak->nPlanPruZa ))
              ListHD->cMaterPoza := 'N'
              ListHD->cZapKapac  := 'N'
              mh_COPYFLD( 'Operace', 'ListHD')
              ListHD->nKusovCas  := PolOper->nCelkKusCa
              ListHD->nPriprCas  := PolOper->nPriprCas
              ListHD->nPorCisLis := VYR_NewCisLis()
//              ListHD->nPoradi    := nPoradi
              ListHD->cVyrobCisl := PolOper->cVyrobCisl
              ListHD->cText1LHD  := PolOper->cText3              // STS JT 29.2.2016  asi na config
           Endif
           ListHD->nPoradi    := snPoradi
           ListHD->nNmNaOpePl += ( PolOper->nCelkKusCa * nMnZadVA ) + ;
                                 IF( PolOPER->nPorCisLis == 0, ( PolOper->nPriprCas * PolOper->nKoefKusCa ), 0 )
           ListHD->nNhNaOpePl := ListHD->nNmNaOpePl / 60
           nHLP  = IF( PolOPER->nPorCisLis <> 0, 0,;
                       ( ( PolOper->nPriprCas * PolOper->nKoefKusCa ) * ;
                       (( C_Tarif->nHodinSaz + C_Tarif->nHodinNav)/60 )) )
           IF PolOPER->nKcNaOper > 0
             ListHD->nKcNaOpePl += ( PolOper->nKcNaOper * nMnZadVA ) + nHLP
           ELSE
             ListHD->nKcNaOpePl += ( ( PolOper->nCelkKusCa * nMnZadVA ) * ;
                                   (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav )/ 60 ) ) + nHLP
           ENDIF

           ListHD->nKusyCelk  += nMnZadVA  // 8.2  :=  15.5
           mh_WRTzmena( 'ListHD', !lExist ) //  SysFields( 'ListHD', !lExist )
           ListHD->( dbUnlock(), dbCommit(), dbSkip(0) )
        Endif

        * Naplnìní ListIT
        If lOK
           If lExist   // Existuje-li hlavièka, napozicuj položku
              cKey := StrZero( ListHD->nRokVytvor, 4) + StrZero( ListHD->nPorCisLis, 12)
              lExist := ListIT->( dbSeek( cKey))
           Endif
           IF lEXIST
             lOK := NO
           ELSE
             lOK := ListIT->( dbAppend(), Sx_RLock() )
           ENDIF
           IF lOK .AND. PolOPER->( Sx_RLock())    //--ReplREC( 'PolOPER')
              mh_COPYFLD( 'ListHD', 'ListIT')
              If !lExist   // ... jde o nový lístek - PLNÌNÍ
                 ::nMZD++
                 ListIT->cTypListku := 'TP'
                 ListIT->cOznOper   := Operace->cOznOper
                 ListIT->cStred     := Operace->cStred
                 ListIT->cOznPrac   := Operace->cOznPrac
                 ListIT->cPracZar   := Operace->cPracZar
                 ListIT->nDruhMzdy  := Operace->nDruhMzdy
                 ListIT->cTarifStup := Operace->cTarifStup
                 ListIT->cTarifTrid := Operace->cTarifTrid
                 ListIT->cSmena     := '1'
                 ListIT->cStavListk := '1'
                 ListIT->cDruhListk := '1'
                 ListIT->nMzdaZaKus := IF( nCfg == 1, PolOper->nKcNaOper,;
                                           ListIT->nKcNaOpePl / ListIT->nKusyCelk )
                 ListIT->nNhNaOpePl := ListIT->nNmNaOpePl / 60
                 ListIT->cSklPol    := ::cSklPol
                 ListIT->cObdobi    := VYR_WhatOBD( YES)
                 ListIT->cNazPol2   := VyrZAK->cNazPol2
                 * Modifikace PolOper
                 PolOper->nRokVytvor := ListIT->nRokVytvor
                 PolOper->nPorCisLis := ListIT->nPorCisLis
              Endif
              PolOper->nZapusteno := 2
              mh_WRTzmena( 'ListIT', !lExist )   // SysFields( 'ListIT', !lExist )
              ( PolOPER->( dbUnLock()), ListIT->( dbUnLock()) )
           EndIf
        Endif
        //
      ENDIF
    EndIf
    PolOper->( dbSkip())
  EndDo

  snPoradi := IF( lPolOPER, snPoradi, snPoradi + 1 )
RETURN NIL



* Omezení PolOPER pouze pro typ zapuštìní = 5  typZAP_DILPR
*===============================================================================
STATIC FUNCT ScopeOPER_5( cSCOPE)

  IF( IsNIL( cSCOPE), PolOPER->( mh_ClrScope()),;
                      PolOPER->( mh_SetScope( cSCOPE ) ))
RETURN NIL



FUNCTION newDokladZAD()
  local  doklad

  doklad := fin_range_key('OBJHEAD')[2]

RETURN( doklad )