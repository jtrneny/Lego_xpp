/*******************************************************************************NEW
  SKL_POHYBY_MAIN.PRG
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\SKLADY\SKL_Sklady.ch"

STATIC   s_mainSklad
STATIC   s_mainPohyb

********************************************************************************
*
********************************************************************************
CLASS SKL_POHYBY_Main

EXPORTED:
  * cfg
  VAR     cfg_cCisSklad, cfg_lPovinSym, cfg_lFakParSym, cfg_lRangePVP, cfg_nTypCisRad,;
          cfg_nTypNabPol, cfg_cDenik, cfg_lCisObjVys
  VAR     newHD, mainSklad, mainPohyb, nKarta, cCrd, HD, IT
  VAR     nMnozPrDod
  VAR     nCelkDokl, nCelkDoklZM, nRozPrijZM, nCelkPCB, nCelkPCS, cIsZahr
  VAR     cNazPol1, cNazPol2, cNazPol3, cNazPol4, cNazPol5, cNazPol6

  METHOD  Init, Destroy, drgDialogStart, drgDialogInit
  *
  METHOD  setMainItems, SelectCard
  METHOD  DokladCelkem, CisDoklad_skl  //, Skl_AllOK
  METHOD  Likvidace


ENDCLASS

********************************************************************************
METHOD SKL_POHYBY_Main:init(parent)
  local odecs, len_cnazPol3

* cfg
  ::cfg_lPovinSym  := SysConfig( 'Finance:lPovinSym')
  ::cfg_lFakParSym := SysConfig( 'Sklady:lFakParSym')
  ::cfg_lRangePVP  := SysConfig( 'Sklady:lRangePVP' )
  ::cfg_nTypCisRad := SysConfig( 'Sklady:nTypCisRad')
  ::cfg_cCisSklad  := SysConfig( 'Sklady:cCisSklad' )
  ::cfg_cDenik     := SysConfig( 'Sklady:cDenik'    )
  ::cfg_lCisObjVys := SysCONFIG( 'Sklady:lCisObjVys')
*
  drgDBMS:open('C_SKLADY')

  ::mainSklad  := IsNULL( s_mainSklad, If( Empty( ::cfg_cCisSklad), C_Sklady->cCisSklad,;
                                                                    ::cfg_cCisSklad     ))
  ::mainPohyb  := IsNULL( s_mainPohyb, '0' )
  ::nKarta     := 0
  ::newHD      := .F.
  ::HD         := 'PVPHEADw'
  ::IT         := 'PVPITEMww'
  ::cIsZahr    := ' '
  *
  ::nMnozPrDod  := 0.00
  ::nCelkDokl   := 0.00
  ::nCelkDoklZM := 0.00
  ::nRozPrijZM  := 0.00
  ::nCelkPCB    := 0.00
  ::nCelkPCS    := 0.00
  *
  ** bude se m�nit cnazPol3 z C8 -> C36
  odesc := drgDBMS:getFieldDesc('pvpitem', 'cnazPol3')
  len_cnazPol3 := odesc:len

  ::cNazPol1 := ::cNazPol2 := ::cNazPol3 := ::cNazPol4 := ::cNazPol5 := ::cNazPol6 := SPACE(8)
  ::cnazPol3 := space(len_cnazPol3)
*

RETURN self

********************************************************************************
METHOD SKL_POHYBY_Main:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  XbpDialog:titleBar := .F.
RETURN

********************************************************************************
METHOD SKL_POHYBY_Main:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
RETURN self

********************************************************************************
METHOD SKL_POHYBY_Main:setMainItems()
  s_mainSklad := ::mainSklad
  s_mainPohyb := ::mainPohyb
RETURN self

/*
   SKL_PRI100             P��jem - jin� p��jem               * 0000           00 *
   SKL_PRI102             Produkce v�robku                   * 0A02           0A *
-  SKL_PRI103             V�robn� produkce                   * 1012           10 *
-  SKL_PRI104             V�robn� produkce - na zak�zku        1012           10
   SKL_PRI110             P��jem - vazba na dodavatele       * 0100 010A      01 *
   SKL_PRI111             P��jem z prodejn� ceny - mar�e     * 0101           01
   SKL_PRI116             P��jem z prodejn� ceny - rabat     * 0106           01
   SKL_PRI117             Skladov� p��jem v r�zn� m�n�       * 1107           11 *
   SKL_PRI120             P��jem bez vazby na dodavatele     * 2100 2200   21 22 *
   SKL_PRI130             P��jem - nevyfakturovan�           * 0300           03 *
   SKL_PRI142             P��jem s variabiln�m symbolem      * 4102 4202   41 42 *

   SKL_STA100             Nastaven� po��te�n�ch stav�

   SKL_VYD203             V�dej - jin� v�dej                 * 0A03           0A
   SKL_VYD204             V�dej - spot�eba                   * 0A04           0A
   SKL_VYD205             V�dej do DIM                       * 0A05           0A
   SKL_VYD244             V�dej s variabiln�m symbolem       * 4304           43 *
   SKL_VYD253             V�dej s tvorbou DLV                * 0503           05 *
   SKL_VYD255             Generovan� v�dej                     0503           05
   SKL_VYD263             V�dej - prodej bez odb�ratele      * 0603           06 *
   SKL_VYD274             V�dej na zak�zku-��danky mate.     * 0704           07 *
-  SKL_VYD293             V�dej - prodej na zak�zku          * 0903           09 *
   SKL_VYD283             V�dej - prodej p�es reg.poklad     * 0909           09
   SKL_VYD299             V�dej - storno

   SKL_PRE305             Automatick� p�evod mezi sklady     * 8051           80 *

   SKL_CEN400             P�ecen�n�                          * 0400           04 *
*/

METHOD SKL_POHYBY_Main:selectCard()
  Local  cCRD, aEDT

  DO CASE
    * P��jmy
    CASE ::nKarta = 100  ; ::cCRD := '0000'   // P��jem - jin� p��jem
    CASE ::nKarta = 102  ; ::cCRD := '0A02'   // Produkce
    CASE ::nKarta = 103  ; ::cCRD := '1012'   // V�robn� produkce
    CASE ::nKarta = 104  ; ::cCRD := '1012'   // V�robn� produkce
/* POZN.  u karty 104 lze editovat vnitrocenu, u karty 103 nelze
          v HLA kart� se edituje ( vyb�r�) zak�zka !
*/
    * P��jem - vazba na dodavatele
    CASE ::nKarta = 110  ; ::cCrd := IIF( ::cfg_lCisObjVys, '0100', '010A')
         * '0100' v polo�kov� kart� se edituje ��s.obj.vystaven�
         * '010A' v polo�kov� kart� se NEedituje ��s.obj.vystaven� (ani nezobrazuje)
    * P��jem - bez vazby na dodavatele
    CASE ::nKarta = 120  ; ::cCrd := IIF( ::cfg_lFakParSym, '2100', '2200' )
                        //; cCRD := '0200'
    CASE ::nKarta = 111  ; ::cCRD := '0101'   // P��jem z prodejn� ceny - mar�e
    CASE ::nKarta = 116  ; ::cCRD := '0106'   // P��jem z prodejn� ceny - rabat
    CASE ::nKarta = 117  ; ::cCRD := '1107'   // P��jem v zahr. m�n�
    CASE ::nKarta = 130  ; ::cCRD := '0300'   // P��jem - nevyfakturov�no
    CASE ::nKarta = 142  // ; cCRD := '0402'   // P��jem - s variabiln�m symbolem
         ::cCrd := IIF( ::cfg_lFakParSym, '4102', '4202' )

    * V�deje
    CASE ::nKarta = 203  ; ::cCRD := '0A03'   // '0003'   // Jin� v�dej
    CASE ::nKarta = 204  ; ::cCRD := '0A04'   // '0004'   // Spot�eba
    CASE ::nKarta = 244  ; ::cCrd := '4304'   //; cCRD := '0404'   // NN  V�dej s V-Symbolem

    CASE ::nKarta = 274  ; ::cCRD := '0704'   // Spot�eba na zak�zku
    CASE ::nKarta = 205  ; ::cCRD := '0A05'   // '0005'   // V�dej do DKP     DOSUD NENI
    CASE ::nKarta = 206  ; ::cCRD := '0A61 '  // '0061'   // Spot�eba s vazbou na cKlicOdpMi  DOSUD NENI
    CASE ::nKarta = 253  ; ::cCRD := '0503'   // Prodej na fakturu ( DL)
    CASE ::nKarta = 255  ; ::cCRD := '0503'   // Prodej z fakturace - 2.3.2007
    CASE ::nKarta = 263  ; ::cCRD := '0603'   // Jednoduch� prodej
*    CASE nKarta = 283  ; cCRD := '0803'   // Prodej za hotov� -- �loha PRODEJ
    CASE ::nKarta = 293  ; ::cCRD := '0903'   // Prodej na zak�zku
    CASE ::nKarta = 299  ; ::cCRD := '0909'   // Oprava prodeje
    * P�evody
*    CASE ::nKarta = 305  ; ::cCRD := '0051'   //  Automatick� p�evod mezi sklady  6.10.06
    CASE ::nKarta = 305  ; ::cCRD := '8051'   //  Automatick� p�evod mezi sklady  6.10.06
    * P�ecen�n�
    CASE ::nKarta = 400  ; ::cCRD := '0400'   // NN  P�ecen�n�
    OTHERWISE
      ::cCRD := '0000'
  ENDCASE

RETURN self

********************************************************************************
METHOD SKL_Pohyby_Main:DokladCELKEM( lReplace)
  Local  nOldArea, nOldRec, nCount := 0, nPos
*  Local  nOldArea := Select(), nOldRec := (::IT)->( RecNo()),  nPos
  Local  aKARTY := { 100,102,103,104,142,203,204,205,206,244,253,263,274,283,293,117,110,120,130 }

  DEFAULT lReplace  To .T.

  ::IT := Coalesce( ::IT, 'PVPITEMww')
  ::HD := Coalesce( ::HD, 'PVPHEADw')
  nOldArea := Select()
  nOldRec := (::IT)->( RecNo())

  IF( nPos := ASCAN( aKARTY, (::HD)->nKARTA)) > 0
*  IF PVPHEAD->nKarta <> 305
    dbSelectArea( ::IT )
    (::IT)->( dbGoTop())
*    ( ::nCelkDokl := 0.00, ::nCelkDoklZM := 0.00, ::nCelkPCB := 0.00, ::nCelkPCS := 0.00 )
    ::nMnozPrDod  := 0.00
    ::nCelkDokl   := 0.00
    ::nCelkDoklZM := 0.00
    ::nCelkPCB    := 0.00
    ::nCelkPCS    := 0.00

    (::IT)->( dbEval( { || nCount++,;
                           ::nMnozPrDod  += (::IT)->nMnozPrDod ,;
                           ::nCelkDokl   += (::IT)->nCenaCelk  ,;
                           ::nCelkDoklZM += (::IT)->nCenCelkZM ,;
                           ::nCelkPCB    += (::IT)->nCenapZBO  * (::IT)->nMnozPrKOE,;
                           ::nCelkPCS    += (::IT)->nCenapDZBO * (::IT)->nMnozPrKOE } ) )
    ::nRozPrijZM :=  (::HD)->nCenDokZM + (::HD)->nNutneVNZM - ::nCelkDoklZM

    If lReplace
     IF( nPos := ASCAN( { 110,117,120,130}, (::HD)->nKARTA)) = 0
        If ReplRec( ::HD)
          (::HD)->nCenaDokl := ::nCelkDokl
          (::HD)->( dbUnlock())
        EndIf
      EndIF
    EndIf
    *
    (::IT)->( dbGoTo( nOldRec))
    dbSelectArea( nOldArea)
  ENDIF
RETURN self

*  Duplicita ��sla dokladu
********************************************************************************
METHOD SKL_Pohyby_Main:CisDoklad_skl( nDoklad, lMsgDouble)
  Local lRetVal, nRange, nStart, nKonec, Key, nTag
  Local cTypPohyb := LEFT( ALLTRIM( STR( ::nKarta)), 1 )

  DEFAULT lMsgDouble TO .T.

  DO CASE
  CASE ::cfg_nTypCisRad = 1 .or. ::cfg_nTypCisRad = 3     // ��s.�ady doklad� v r�mci cel� firmy
    If ::cfg_lRangePVP
       nRange := IIF( cTypPohyb == PRIJEM, SysConfig( 'Sklady:nRangePrij'),;
                 IIF( cTypPohyb == VYDEJ , SysConfig( 'Sklady:nRangeVyde'),;
                 IIF( cTypPohyb == PREVOD, SysConfig( 'Sklady:nRangePrev'),;
                 IIF( cTypPohyb == PRECEN, SysConfig( 'Sklady:nRangePrij'), Nil ))))
       nTag := 7
       Key  := If( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nDoklad,10)
    Else
       nRange := SysConfig( 'Sklady:nRangePrij')
       nTag   := 1
       Key    := nDoklad
    EndIf
    ( nStart := nRange[1], nKonec := nRange[2] )

  CASE ::cfg_nTypCisRad = 2      // ��s.�ady doklad� v r�mci sklad�
    IF C_Sklady->( dbSEEK( Upper( ::mainSklad),, 'C_SKLAD1'))
      IF C_Sklady->lRangePVP
        nStart := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemOd ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejOd  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodOd ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemOd , Nil ))))

        nKonec := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemDo ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejDo  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodDo ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemDo , Nil ))))
        nTag := 17
        Key  := Upper(::mainSKLAD) + If( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nDoklad,10)
      ELSE
        nStart := C_Sklady->nPrijemOd
        nKonec := C_Sklady->nPrijemDo
        nTag   := 16
        Key    := Upper(::mainSklad) + StrZero( nDoklad,10)
      ENDIF
    ENDIF
  ENDCASE
  *
  If nDoklad < nStart .or. nDoklad > nKonec
    MsgBOX( '��slo dokladu je mimo rozsah povolen� ��seln� �ady !' )
    lRetVal := .f.
  Else
    drgDBMS:open('PVPHEAD',,,,, 'PVPHEADa')
    lRetVal := PVPHEADa->( dbSeek( Key,, AdsCtag(nTag)))
    PVPHEADa->( dbCloseArea())
*    IF( lRetVal, MsgBOX( 'Zad�no duplicitn� ��slo dokladu !' ), nil )
    IF( lRetVal, IF( lMsgDouble, MsgBOX( 'Zad�no duplicitn� ��slo dokladu !' ), nil), nil )
    lRetVal := !lRetVal
  EndIf
RETURN lRetVal

* Podm�nky pro pr�ci s dokladem
*****************************************************************
FUNCTION SKL_AllOK( lNewDokl, lMessage, cHD, cIT)
*SKL_AllOK( lNewDokl, lMessage, o, cAlias)
*METHOD SKL_Pohyby_Main:SKL_AllOK( lNewDokl, lMessage, o, cAlias)
  Local cObd,  lOk := .F.

  DEFAULT lNewDokl TO .F., lMessage TO .T., cHD TO 'PVPHEAD', cIT TO 'PVPITEM'
*  If o = nil
*    o := ::drgDialog:odBrowse[2]:oXbp
*  EndIf

  IF lNewDokl
    *  Nov� doklad
    cObd := uctObdobi:SKL:cOBDOBI  // IF( cHD = 'PVPHEAD', uctObdobi:SKL:cOBDOBI, PVPHead->cObdPoh )
    IF !ObdobiUZV( cObd, 'U', lMessage)        // obdob� nen� ��etn� uzav�eno v ��ETNICTV�
      IF !ObdobiUZV( cObd, 'S', lMessage)      // obdob� nen� ��etn� uzav�eno v �loze SKLADY
        lOK := .T.
      ENDIF
    ENDIF

  ELSE
    * Oprava a ru�en� dokladu
    IF !ObdobiUZV( (cHD)->cObdPoh, 'U', lMessage)        // obdob� nen� ��etn� uzav�eno v ��ETNICTV�
      IF !ObdobiUZV( (cHD)->cObdPoh, 'S', lMessage)      // obdob� nen� ��etn� uzav�eno v �loze SKLADY
*        IF PrijemOK( o, lMessage)
        IF Prijem_isOK( cHD, cIT, .t., .f.)
          lOk := .T.
        ENDIF
      ENDIF
    ENDIF
  ENDIF

  IF !lOK .and. lMessage
    drgMsgBox(drgNLS:msg('Nejsou spln�ny podm�nky pro pr�ci s dokladem !'),XBPMB_CRITICAL  )
  ENDIF
RETURN lOK

METHOD SKL_POHYBY_Main:Likvidace()
* IsUctovano( 1; 'PVPITEM'):L:3::2,;
RETURN

********************************************************************************
METHOD SKL_POHYBY_Main:destroy()
  *
  ::cfg_lPovinSym := ::cfg_lFakParSym := ::cfg_lRangePVP := ::cfg_nTypCisRad := ;
  ::cfg_cCisSklad := ::cfg_nTypNabPol := ::cfg_cDenik := ;
  ::newHD := ::mainSklad := ::mainPohyb := ::nKarta := ::cIsZahr := ;
  ::nMnozPrDod := ::nCelkDokl := ::nCelkDoklZM := ::nRozPrijZM := ::nCelkPCB :=  ::nCelkPCS := ;
  ::cNazPol1 := ::cNazPol2 := ::cNazPol3 := ::cNazPol4 := ::cNazPol5 := ::cNazPol6 := ;
  ::HD := ::IT := ;
  NIL
RETURN self


* Zjist� nov� ��slo dokladu pro dan� typ pohybu( PVP) a sklad
*==============================================================================
FUNCTION NewDoklad_skl( nKARTA, cSklad)
  *
  Local nNewDokl := 0, lStart
  Local nRange, nStart, nKonec, cTop, cBot
  Local cTypPohyb := LEFT( ALLTRIM( STR( nKarta)), 1 )
  Local nTypCisRad := SysConfig( 'Sklady:nTypCisRad')
  Local lRangePVP  := SysConfig( 'Sklady:lRangePVP' )

  if(select('skl_range') <> 0, skl_range->(dbclosearea()), nil)
  drgDBMS:open('pvphead',,,,, 'skl_range')

  DO CASE
  CASE nTypCisRad = 1 .or. nTypCisRad = 3     // ��s.�ady doklad� v r�mci cel� firmy
    IF lRangePVP
      nRange  := IIf( cTypPohyb == PRIJEM, SysConfig( 'Sklady:nRangePrij'),;
                 IIF( cTypPohyb == VYDEJ , SysConfig( 'Sklady:nRangeVyde'),;
                 IIf( cTypPohyb == PREVOD, SysConfig( 'Sklady:nRangePrev'),;
                 IIf( cTypPohyb == PRECEN, SysConfig( 'Sklady:nRangePrij'), Nil ))))
      skl_range->( AdsSetOrder( 7))
      cTop := IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nRange[ 1], 10 )
      cBot := IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nRange[ 2], 10 )
      skl_range->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                   Ads_SetScope( SCOPE_BOTTOM, cBot ))

    ELSE
      nRange  := SysConfig( 'Sklady:nRangePrij')
      skl_range->( AdsSetOrder( 1))
      skl_range->( Ads_SetScope( SCOPE_TOP   , nRange[ 1]),;
                   Ads_SetScope( SCOPE_BOTTOM, nRange[ 2]) )
    ENDIF
    nStart  := Val( Str( nRange[ 1], 10 ))
    nKonec  := Val( Str( nRange[ 2], 10 ))
  //
  CASE nTypCisRad = 2      // ��s.�ady doklad� v r�mci sklad�
    IF C_Sklady->( dbSEEK( Upper( cSklad),, 'C_SKLAD1'))
      IF C_Sklady->lRangePVP
        nStart := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemOd ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejOd  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodOd ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemOd , Nil ))))

        nKonec := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemDo ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejDo  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodDo ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemDo , Nil ))))

        skl_range->( AdsSetOrder( 17))
        cTop := Upper(cSklad) + IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nStart, 10 )
        cBot := Upper(cSklad) + IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nKonec, 10 )
        skl_range->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                     Ads_SetScope( SCOPE_BOTTOM, cBot ))
      ELSE
        nStart := C_Sklady->nPrijemOd
        nKonec := C_Sklady->nPrijemDo
        skl_range->( AdsSetOrder( 16))
        cTop := Upper(cSklad) + StrZero( nStart, 10 )
        cBot := Upper(cSklad) + StrZero( nKonec, 10 )
        skl_range->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                     Ads_SetScope( SCOPE_BOTTOM, cBot ))
      ENDIF

    ENDIF
  ENDCASE

  skl_range->( dbGoTop())
  lStart := ( skl_range->nDoklad == 0 )
  skl_range->( dbGoBottom())    // !!!!
  nNewDokl := If( lStart, nStart, skl_range->nDoklad + 1 )
  *
  skl_range->( dbCloseArea())
Return( Val( Str( nNewDokl, 10)) )

*===============================================================================
FUNCTION DokladHasItem( newHD, cFile, Dialog )
  Local nRecNo := (cFile)->( RecNo()), n := 0
  *
  IF newHD
    (cFile)->( dbEval( {|| n++ }, {|| (cFile)->nDoklad <> 0 .and. (cFile)->_delRec <> '9'}))
    (cFile)->( dbGoTo( nRecNo))
    IsEditGET( { 'M->mainSklad', 'M->mainPohyb', 'PVPHEADw->ncisFirmy' }, Dialog, n = 0 )
  ENDIF
  *
RETURN NIL

*===============================================================================
FUNCTION ObdobiUZV( cObd, cTask, lMessage )
  Local lOK := .F., cKey := cTask + cObd
  Local cNazevTask := IF( cTask = 'U', '��TO'    ,;
                      IF( cTask = 'S', 'SKLADY'  ,;
                      IF( cTask = 'I', 'MAJETEK' ,;
                      IF( cTask = 'Z', 'ZV��ATA' , ''))))

  DEFAULT lMessage TO .T.
  drgDBMS:open('UCETSYS',,,,, 'UCETSYSw' )
  IF UCETSYSw->( dbSeek( Upper( cKey),,'UCETSYS2'))
    IF lOK := UCETSYSw->lZavren
      IF lMessage
        drgMsgBOX( drgNLS:msg( '��etn� obdob�  [ & ] ji� bylo v �loze ' + cNazevTask + ' uzav�eno ...', cObd ))
      ENDIF
    ENDIF
  ENDIF
  UCETSYSw->( dbCloseArea())
RETURN( lOK)

*  Kontrola na minim�ln� skladovou z�sobu
*===============================================================================
FUNCTION TestMin( nVal)
*===============================================================================
  Local nMnozs := CenZboz->nMnozsZBO - nVal

  If CenZboz->nMinZbo > 0 .and. nMnozs < CenZboz->nMinZbo
    drgMsgBox(drgNLS:msg( ;
      'Jste  p o d  limitn�m stavem z�sob !;' + ;
      ' minim�lni stav = & ;' + ;
      ' aktu�ln� stav  = & ', CenZboz->nMinZbo, nMnozs ), XBPMB_WARNING )
  Endif
Return nil

*  Kontrola na maxim�ln� skladovou z�sobu
*===============================================================================
FUNCTION TestMax( nVal)
*===============================================================================
  Local nMnozs := CenZboz->nMnozsZBO + nVal

  If CenZboz->nMaxZbo > 0 .and. nMnozs > CenZboz->nMaxZbo
    drgMsgBox(drgNLS:msg( ;
      'Jste  n a d  limitn�m stavem z�sob !;' + ;
      ' maxim�ln� stav = & ;' + ;
      ' aktu�ln� stav  = & ', CenZboz->nMaxZbo, nMnozs ), XBPMB_WARNING )
  Endif
Return NIL

* Kl�� oblasti pro danou FIRMU
*****************************************************************
Function KlicOblasti( nCisFirmy)
  Local nKlicObl

  FOrdRec( { 'Firmy, 1' } )
  Firmy->( dbSeek( nCisFirmy))
  nKlicObl := Firmy->nKlicObl
  FOrdRec()
Return( nKlicObl)

* Ru�� za��tov�n� polo�ky (hlavi�ky)  skl. dokladu
*===============================================================================
FUNCTION SKL_UcetPOL_DEL( lRozPRIJ)
  LOCAL cDenik := PadR( SysConfig( 'Sklady:cDenik'), 2 )
  Local cMainKEY := Upper(cDenik ) + StrZero( PVPHead->nDoklad, 10)

  DEFAULT lRozPRIJ    TO  .F.

  IF lRozPRIJ
    DelUcetPol( cMainKey + '00000')    // za��tov�n� rozd�lu p�i p��jmu
  ELSE
    DelUcetPol( cMainKey + StrZero( PVPItem->nOrdItem, 5) )     // polo�ka skladov�ho dokladu
    If PVPHead->nKarta == 305
      DelUcetPol( cMainKey +  StrZero( PVPItem->nOrdItKAM, 5) ) // ru�� DP=40 p�i p�evodech
    Endif
  ENDIF
RETURN nil

*
*-------------------------------------------------------------------------------
STATIC FUNCTION DelUcetPol( cKey)
  Do while UcetPol->( dbSeek( cKey,,'UCETPOL1'))
    DelRec( 'UcetPol')
  EndDo
RETURN Nil

*
********************************************************************************
FUNCTION SetPohyby( nKarta)
  lPovinSym  := SysConfig( 'Finance:lPovinSym')
  lFakParSym := SysConfig( 'Sklady:lFakParSym')
  lRangePVP  := SysConfig( 'Sklady:lRangePVP' )
  nTypCisRad := SysConfig( 'Sklady:nTypCisRad')
*  cTypPohyb  := LEFT( STR( nKarta), 1 )
RETURN NIL

* Kontrola na nove cislo dokladu pred zapisem
********************************************************************************
FUNCTION SKL_NewDoklad( nKARTA, cSklad)
  Local nNewDokl
  Local xOldTop := PVPHead->( dbScope( SCOPE_TOP))
  Local xOldBot := PVPHead->( dbScope( SCOPE_BOTTOM))
  Local cFilter := PVPHEAD->( Ads_GetAOF()) // dbFILTER())
  Local nRecNo  := PVPHead->( RecNo())
  Local lStart, lUseEmpty := .F.
  Local nRange, nStart, nKonec, cTop, cBot, nTOP, nBOT
*  Local
  cTypPohyb  := LEFT( ALLTRIM( STR( nKarta)), 1 )

*  PVPHead->( dbClearScope( SCOPE_TOP), dbClearScope( SCOPE_BOTTOM), dbGoTOP() )
  PVPHead->( mh_ClrFilter())  // dbClearFILTER())

  DO CASE
  CASE nTypCisRad = 1 .or. nTypCisRad = 3     // ��s.�ady doklad� v r�mci cel� firmy
    IF lRangePVP
      nRange  := IIf( cTypPohyb == PRIJEM, SysConfig( 'Sklady:nRangePrij'),;
                 IIF( cTypPohyb == VYDEJ , SysConfig( 'Sklady:nRangeVyde'),;
                 IIf( cTypPohyb == PREVOD, SysConfig( 'Sklady:nRangePrev'),;
                 IIf( cTypPohyb == PRECEN, SysConfig( 'Sklady:nRangePrij'), Nil ))))
      fOrdRec( { 'PVPHead, 7' } )
      cTop := IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nRange[ 1], 10 )
      cBot := IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nRange[ 2], 10 )
      PVPHead->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                 Ads_SetScope( SCOPE_BOTTOM, cBot ))

    ELSE
      nRange  := SysConfig( 'Sklady:nRangePrij')
      fOrdRec( { 'PVPHead, 1' } )
      PVPHead->( Ads_SetScope( SCOPE_TOP   , nRange[ 1]),;
                 Ads_SetScope( SCOPE_BOTTOM, nRange[ 2]) )
    ENDIF
    nStart  := Val( Str( nRange[ 1], 10 ))
    nKonec  := Val( Str( nRange[ 2], 10 ))
  //
  CASE nTypCisRad = 2      // ��s.�ady doklad� v r�mci sklad�
    IF C_Sklady->( dbSEEK( Upper( cSklad),,'C_SKLAD1'))
      IF C_Sklady->lRangePVP
        nStart := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemOd ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejOd  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodOd ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemOd , Nil ))))

        nKonec := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemDo ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejDo  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodDo ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemDo , Nil ))))

        fOrdRec( { 'PVPHead, 17' } )
        cTop := Upper(cSklad) + IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nStart, 10 )
        cBot := Upper(cSklad) + IF( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nKonec, 10 )
        PVPHead->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                   Ads_SetScope( SCOPE_BOTTOM, cBot ))
      ELSE
        nStart := C_Sklady->nPrijemOd
        nKonec := C_Sklady->nPrijemDo
        fOrdRec( { 'PVPHead, 16' } )
        cTop := Upper(cSklad) + StrZero( nStart, 10 )
        cBot := Upper(cSklad) + StrZero( nKonec, 10 )
        PVPHead->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                   Ads_SetScope( SCOPE_BOTTOM, cBot ))
      ENDIF

    ENDIF
  ENDCASE

  PVPHead->( dbGoTop())
  lStart := ( PVPHead->nDoklad == 0 )
  PVPHead->( dbGoBottom())    // !!!!
  nNewDokl := If ( lStart, nStart, PVPHead->nDoklad + 1 )
  *
  PVPHead->( Ads_ClearScope( SCOPE_TOP), Ads_ClearScope( SCOPE_BOTTOM), dbGoTop() )
**  PVPHead->( dbClearScope(), dbGoTop() )
  fOrdRec()
  IF !Empty( cFilter)
    PVPHead->( mh_SetFilter( cFilter, FLT_NO))
  ENDIF

Return( Val( Str( nNewDokl, 10)) )

* V�dejka/P��jemka z CenZboz nebo ObjItem/ObjVystIT
********************************************************************************
FUNCTION AddToPVPItem( cAlias )

  PVPItem->cSklPol    := ( cAlias)->cSklPol
  PVPItem->cNazZBO    := ( cAlias)->cNazZBO
  PVPItem->nKlicDPH   := ( cAlias)->nKlicDPH

  PVPItem->nUcetSkup  := CenZboz->nUcetSkup
  PVPItem->cUcetSkup  := PADR( CenZboz->nUcetSkup, 10)
  PVPItem->cZkratMENY := CenZboz->cZkratMENY
  PVPItem->cZkratJedn := CenZboz->cZkratJedn
  PVPItem->nKlicNAZ   := CenZboz ->nKlicNaz
  PVPItem->nZboziKAT  := CenZboz ->nZboziKAT
  PVPItem->cPolCen    := CenZboz->cPolCen
  PVPItem->cTypSKP    := CenZboz->cTypSKP
  PVPItem->cUctovano  := ' '
  PVPItem->nTypPOH    := IIF( PVPHEAD->nKARTA < 200,  1,;
                         IIF( PVPHEAD->nKARTA < 300, -1,;
                         IIF( PVPHEAD->nKARTA = 400,  1, 0 )))
  PVPItem->cCisZakaz  := IF( PVPItem->nTypPoh = -1, PVPItem->cNazPol3, PVPItem->cCisZakaz )
  PVPItem->cCisZakazI := PVPItem->cCisZakaz
  PVPItem->cCasPVP    := time()
  mh_WRTzmena( 'PVPITEM', .T.,)

RETURN Nil
