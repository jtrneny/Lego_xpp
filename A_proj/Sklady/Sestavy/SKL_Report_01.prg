#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\SKLADY\SKL_Sklady.ch"

* Vytváøí podkladový soubor VYBRZASw pro tiskové sestavy
* nVar = 1 : Pohyby vybraných zásob
* nVar = 2 : Souèty pohybù vybraných zásob
* nVar = 3 : Spotøeba krmiv dle druhù zvíøat
* nVar = 4 : Spotøeba krmiv dle stájí
* nVar = 5 : Spotøeba PHM - støedisková
*===============================================================================
FUNCTION SKL_rep_01( nVar)
  Local oDialog, oParent, cVar

  Default nVar To 1

  oParent := XbpDialog():new( AppDesktop(), , {10, 10}, {10, 10},,.F.)
  oParent:taskList := .F.
  oParent:create()
  *
  cVar := Str(nVar)
  DRGDIALOG FORM 'SKL_report_01,'+ cVar PARENT oParent MODAL DESTROY
  *
  ( oParent:Destroy(), oParent := Nil )
RETURN NIL

*
********************************************************************************
CLASS SKL_Report_01 FROM drgUsrClass

EXPORTED:
  VAR     cObdobi, cSklPol_Od, cSklPol_Do, cPohyb_Od, cPohyb_Do,;
          cVykon_Od, cVykon_Do, cStred_Od, cStred_Do,;
          cStaj_Od, cStaj_Do, cStroj_Od, cStroj_Do
  VAR     cAction, nVar, parent
  METHOD  Init, Destroy, drgDialogStart, postvalidate, START
  METHOD  TypPohybu_sel, NAZPOLn_SEL, CENZBOZ_SEL


HIDDEN
  VAR     dm, df, aReport
  METHOD  VybrZASOBY, SpotrKRMIVA_1, SpotrKRMIVA_2 , SpotrPHM

ENDCLASS

********************************************************************************
METHOD SKL_Report_01:init(parent)
  Local aFormName := {'Skl_report_01', 'Skl_report_01', 'SKL_report_03',;
                      'Skl_report_04', 'Skl_report_05', 'Skl_report_06'}
  ::drgUsrClass:init(parent)
  *
  ::aReport    := { "Pohyby vybraných zásob",;
                    "Souèty pohybù vybraných zásob",;
                    "Spotøeba krmiv dle druhù zvíøat",;
                    "Spotøeba krmiv dle stájí",;
                    "Spotøeba PHM - støedisková" }
  ::nVar       := VAL( ALLTRIM( drgParseSecond( parent:initParam, ',')))
  ::cAction    := ::aReport[ ::nVar]
  ::parent     := parent:drgDialog
  ::parent:formName := upper( aFormName[ ::nVar])
  *
  ::cObdobi    := SPACE( 5)
  ::cSklPol_Od := SPACE(15)
  ::cSklPol_Do := SPACE(15)
  ::cPohyb_Od  := SPACE(10)
  ::cPohyb_Do  := SPACE(10)
  ::cVykon_Od  := SPACE( 8)
  ::cVykon_Do  := SPACE( 8)
  ::cStred_Od  := SPACE( 8)
  ::cStred_Do  := SPACE( 8)
  ::cStaj_Od   := SPACE( 8)
  ::cStaj_Do   := SPACE( 8)
  ::cStroj_Od  := SPACE( 8)
  ::cStroj_Do  := SPACE( 8)
  *
  drgDBMS:open( 'C_TYPPOH' )
  drgDBMS:open( 'CENZBOZ'  )
  drgDBMS:open( 'CNAZPOL1' )
  drgDBMS:open( 'CNAZPOL2' )
  drgDBMS:open( 'CNAZPOL4' )
  drgDBMS:open( 'CNAZPOL5' )

RETURN self

********************************************************************************
METHOD SKL_Report_01:drgDialogStart(drgDialog)
  *
  ::dm := drgDialog:dataManager
  ::df := drgDialog:oForm
RETURN self

********************************************************************************
METHOD SKL_Report_01:destroy()
  ::drgUsrClass:destroy()
  ::cAction := ::cObdobi := ::cSklPol_Od := ::cSklPol_Od := ;
  Nil
RETURN self

********************************************************************************
METHOD  SKL_Report_01:Start()
  Local oMoment

  ::dm:save()
  *
  IF drgIsYesNo(drgNLS:msg( 'Požadujete spustit zpracování ?' ))
    oMoment := SYS_MOMENT( 'Generuji soubor pro požadovanou sestavu ...')
    *
    drgDBMS:open( 'VYBRZASw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
    *
    Do Case
    Case ::nVar = 1  //  Pohyby vybraných zásob
      ::VybrZASOBY()
    Case ::nVar = 2  //  Souèty pohybù vybraných zásob
      ::VybrZASOBY()
    Case ::nVar = 3  //  Spotøeba krmiv dle druhù zvíøa
      ::SpotrKRMIVA_1()
    Case ::nVar = 4  //  Spotøeba krmiv dle stájí
      ::SpotrKRMIVA_2()
    Case ::nVar = 5  //  Spotøeba PHM - støedisková
      ::SpotrPHM()
    Endcase
    *
    oMoment:destroy()

    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  ENDIF
RETURN NIL

********************************************************************************
METHOD SKL_Report_01:postValidate( oVar)
  Local lOK := .T., Ret
  Local value := oVar:value, name := drgParseSecond( lower(oVar:name), '>')
  Local changed := oVar:changed(), cKey

    Do Case
    Case ( name $ 'cpohyb_od,cpohyb_do' )
      lOk := ::TypPohybu_sel()
    Case ( name $ 'cstred_od,cstred_do,cvykon_od,cvykon_do,cstaj_od, cstaj_do,cstroj_od, cstroj_do' )
      lOK := ::NAZPOLn_sel()
*    Case ( name $ 'csklpol_od,csklpol_do' )
*      lOK := ::CENZBOZ_SEL()
    EndCase
RETURN lOK

********************************************************************************
METHOD  SKL_Report_01:VybrZasoby()
  Local cFilter, cFlt_Od, cFlt_Do, cKey
  Local aPohyby, aRadek := {0, 0, 0, 0, 0, 0 }
  Local aX, npA, npANew, x , nObdobi, nRok, nCount := 0

*  drgDBMS:open( 'CenZBOZ',,,,, 'CENZBOZa')
  drgDBMS:open( 'CenZBOZ')
  drgDBMS:open( 'PVPITEM',,,,, 'PVPITEMa')
  drgDBMS:open( 'CenZBOZ',,,,, 'CENZBOZw')
  CENZBOZw->( OrdSetFOCUS('CENIK01'))

  cFilter := "( Rtrim( cSklPol) >= '%%' .and. Rtrim( cSklPol) <= '%%' ) .and. laktivni"
  cFilter := Format( cFilter, { Rtrim(::cSklPol_Od), Rtrim(::cSklPol_Do) })
  CENZBOZ->( mh_SetFilter( cFilter))
  *
*    cFilter := "cObdPoh <= '%%' .and. Right(cObdPoh,2) = '%%'"

  cFilter := "Val(Left(cObdPoh,2)) <= %% .and. Right(cObdPoh,2) = '%%'"
  cFilter := Format( cFilter, { Val(Left(::cObdobi, 2)), Right(::cObdobi,2)})
  PVPITEMa->( mh_ClrFilter(), mh_SetFilter( cFilter))
  PVPITEMa->( OrdSetFocus('PVPITEM01'))

  CENZBOZ->( dbGoTOP())

  DO WHILE !CENZBOZ->( EOF())
    *
    cKey := Upper( CENZBOZ->cCisSklad) + Upper( CENZBOZ->cSklPol)
    PVPITEMa->( mh_SetScope( cKey))

    aPohyby := {}
    *
    Do While !PVPITEMa->( Eof())
      npA := ASCAN( aPohyby, { |aX| aX[1] == PVPITEMa->cTypPohybu})
      *
      If npA = 0
        aX := Aclone(aRadek)
        AADD(aPohyby, aX)
        npANew := Len(aPohyby)
        aPohyby[npANew, 1] := PVPITEMa->cTypPohybu
        aPohyby[npANew, 6] := PVPITEMa->nTypPoh
        If ::cObdobi = PVPITEMa->cObdPoh
           aPohyby[npANew, 2] := PVPITEMa->nMnozPrDod
           aPohyby[npANew, 3] := PVPITEMa->nCenaCelk
        Endif
        aPohyby[npANew, 4] := PVPITEMa->nMnozPrDod
        aPohyby[npANew, 5] := PVPITEMa->nCenaCelk

      ElseIf npA <> 0
      *
        If ::cObdobi = PVPITEMa->cObdPoh
           aPohyby[npA, 2] += PVPITEMa->nMnozPrDod
           aPohyby[npA, 3] += PVPITEMa->nCenaCelk
        Endif
        aPohyby[npA, 4] += PVPITEMa->nMnozPrDod
        aPohyby[npA, 5] += PVPITEMa->nCenaCelk
      EndIf
      PVPITEMa->( dbSkip())
    EndDo
    *
    nObdobi := Val( Left(::cObdobi, 2))
    nRok    := 2000 + Val( Right(::cObdobi, 2))
    *
    * Poèátení stav skl.pol na poè.roku
    aPocStav := PocStavCEN( CENZBOZ->cSklPol)
    * Stav skl.pol na poè. a konci obdobi
    StavCENzaOBD( nObdobi, nRok)
    PVPKUMULw->( dbGoBottom())
    nMnPSOBD   := PVPKUMULw->nMnozPoc
    nCePSOBD   := PVPKUMULw->nCenaPoc
    nMnKSOBD   := PVPKUMULw->nMnozKon
    nCeKSOBD   := PVPKUMULw->nCenaKon
    *
    if len( aPohyby) = 0
      * v daném období nebyl žádný pohyb, ale záznam se musí vygenerovat
      mh_copyfld( 'CENZBOZ', 'VYBRZASw', .T. )
      VYBRZASw->cObdPoh    := ::cObdobi
      VYBRZASw->nObdobi    := nObdobi
      VYBRZASw->nRok       := nRok
      VYBRZASw->nMnPOCS    := aPocStav[ 1]
      VYBRZASw->nCePOCS    := aPocStav[ 2]
      VYBRZASw->nMnPSOBD   := nMnPSOBD
      VYBRZASw->nCePSOBD   := nCePSOBD
      VYBRZASw->nMnKSOBD   := nMnKSOBD
      VYBRZASw->nCeKSOBD   := nCeKSOBD

    else
      * v období byly pohyby, pro každý se vygeneruje jeden kumulativní záznam
      for x := 1 to len( aPohyby)
        mh_copyfld( 'CENZBOZ', 'VYBRZASw', .T. )
        VYBRZASw->cTypPohybu := aPohyby[ x, 1]
        VYBRZASw->nTypPoh    := aPohyby[ x, 6]
        VYBRZASw->cObdPoh    := ::cObdobi
        VYBRZASw->nObdobi    := nObdobi
        VYBRZASw->nRok       := nRok
        VYBRZASw->nMnZaObd   := aPohyby[ x, 2]
        VYBRZASw->nCeZaObd   := aPohyby[ x, 3]
        VYBRZASw->nMnOdPOC   := aPohyby[ x, 4]
        VYBRZASw->nCeOdPOC   := aPohyby[ x, 5]
        VYBRZASw->nMnPOCS    := aPocStav[ 1]
        VYBRZASw->nCePOCS    := aPocStav[ 2]
        VYBRZASw->nMnPSOBD   := nMnPSOBD
        VYBRZASw->nCePSOBD   := nCePSOBD
        VYBRZASw->nMnKSOBD   := nMnKSOBD
        VYBRZASw->nCeKSOBD   := nCeKSOBD
      next
    endif
    *
    nCount++
    CENZBOZ->( dbSKIP())
    PVPITEMa->( mh_ClrScope())

  EndDo
  CENZBOZ->( mh_ClrFilter())

RETURN Nil

********************************************************************************
METHOD  SKL_Report_01:SpotrKRMIVA_1()
  Local cFilter, indexkey := "Upper( cNazPol2 ) + Upper( cSklPol)"
  Local cOldVykon, cOldSklPol, aPohyby
  *
  drgDBMS:open( 'PVPITEM',,,,, 'PVPITEMa')
  PVPITEMa->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'PVPIT_1', 'PVPIT_1',  indexKey ))
  PVPITEMa->(AdsSetOrder('PVPIT_1'))
  *
  cFilter := "cObdPoh <= '%%' .and. Right(cObdPoh,2) = '%%' .and. " +;
             "Val(Alltrim(cTypPohybu)) >= %% .and. " +;
             "Val(Alltrim(cTypPohybu)) <= %% .and. " +;
             "cNazPol2 >= '%%' .and. cNazPol2 <= '%%' .and. " +;
             "cSklPol >= '%%' .and. cSklPol <= '%%'"

  cFilter := Format( cFilter, { ::cObdobi, Right(::cObdobi,2),;
                                Val(::cPohyb_Od), Val(::cPohyb_Do),;
                                Rtrim(::cVykon_Od), Rtrim(::cVykon_Do),;
                                Rtrim(::cSklPol_Od), Rtrim(::cSklPol_Do) })
  PVPITEMa->( mh_SetFilter( cFilter), dbGoTop())
  cOldVykon  := PVPITEMa->cNazPol2
  cOldSklPol := PVPITEMa->cSklPol
  aPohyby := {  0, 0, 0, 0 }

  Do While !PVPITEMa->( Eof())

    if cOldVykon = PVPITEMa->cNazPol2 .and. cOldSklPol = PVPITEMa->cSklPol
       aPohyby[1] += If(::cObdobi = PVPITEMa->cObdPoh, PVPITEMa->nMnozPrDod, 0)
       aPohyby[2] += If(::cObdobi = PVPITEMa->cObdPoh, PVPITEMa->nCenaCelk, 0)
       aPohyby[3] += PVPITEMa->nMnozPrDod
       aPohyby[4] += PVPITEMa->nCenaCelk
     else
       *
       CENZBOZ->( dbSeek( Upper( cOldSklPol),, 'CENIK01'))
       CNAZPOL2->( dbSeek( Upper( cOldVykon),, 'CNAZPOL1'))
       cOldVykon  := PVPITEMa->cNazPol2
       cOldSklPol := PVPITEMa->cSklPol
       PVPITEMa->( dbSkip(-1))
       *
       mh_copyfld( 'PVPITEMa', 'VYBRZASw', .T. )
       VYBRZASw->cObdPoh    := ::cObdobi
       VYBRZASw->nObdobi    := Val( Left(::cObdobi, 2))
       VYBRZASw->nRok       := 2000 + Val( Right(::cObdobi, 2))
       VYBRZASw->nMnZaObd   := aPohyby[ 1]
       VYBRZASw->nCeZaObd   := aPohyby[ 2]
       VYBRZASw->nMnOdPOC   := aPohyby[ 3]
       VYBRZASw->nCeOdPOC   := aPohyby[ 4]
       aPohyby := {  0, 0, 0, 0 }
       *
     endif

     PVPITEMa->( dbSkip())
   Enddo
   *
   PVPITEMa->( dbGoBottom())
   CENZBOZ->( dbSeek( Upper( cOldSklPol),, 'CENIK01'))
   CNAZPOL2->( dbSeek( Upper( cOldVykon),, 'CNAZPOL1'))

   mh_copyfld( 'PVPITEMa', 'VYBRZASw', .T. )
   VYBRZASw->cObdPoh    := ::cObdobi
   VYBRZASw->nObdobi    := Val( Left(::cObdobi, 2))
   VYBRZASw->nRok       := 2000 + Val( Right(::cObdobi, 2))
   VYBRZASw->nMnZaObd   := aPohyby[ 1]
   VYBRZASw->nCeZaObd   := aPohyby[ 2]
   VYBRZASw->nMnOdPOC   := aPohyby[ 3]
   VYBRZASw->nCeOdPOC   := aPohyby[ 4]
   *
   PVPITEMa->(dbCloseArea())

RETURN Nil

********************************************************************************
METHOD  SKL_Report_01:SpotrKRMIVA_2()
  Local cFilter
  Local indexkey := "Upper( cNazPol1) + Upper( cNazPol4) + Upper( cNazPol2) + Upper( cSklPol)"
  Local cOldStred, cOldStaj, cOldVykon, cOldSklPol, aPohyby
  *
  drgDBMS:open( 'PVPITEM',,,,, 'PVPITEMa')
  PVPITEMa->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'PVPIT_2', 'PVPIT_2',  indexKey ))
  PVPITEMa->(AdsSetOrder('PVPIT_2'))
  *
  cFilter := "cObdPoh <= '%%' .and. Right(cObdPoh,2) = '%%' .and. " +;
             "Val(Alltrim(cTypPohybu)) >= %% .and. " +;
             "Val(Alltrim(cTypPohybu)) <= %% .and. " +;
             "cNazPol1 >= '%%' .and. cNazPol1 <= '%%' .and. " +;
             "cNazPol4 >= '%%' .and. cNazPol4 <= '%%' .and. " +;
             "cNazPol2 >= '%%' .and. cNazPol2 <= '%%' .and. " +;
             "cSklPol >= '%%' .and. cSklPol <= '%%'"

  cFilter := Format( cFilter, { ::cObdobi, Right(::cObdobi,2),;
                                Val(::cPohyb_Od), Val(::cPohyb_Do),;
                                Rtrim(::cStred_Od), Rtrim(::cStred_Do),;
                                Rtrim(::cStaj_Od) , Rtrim(::cStaj_Do),;
                                Rtrim(::cVykon_Od), Rtrim(::cVykon_Do),;
                                Rtrim(::cSklPol_Od), Rtrim(::cSklPol_Do) })
  PVPITEMa->( mh_SetFilter( cFilter), dbGoTop())

  cOldStred  := PVPITEMa->cNazPol1
  cOldStaj   := PVPITEMa->cNazPol4
  cOldVykon  := PVPITEMa->cNazPol2
  cOldSklPol := PVPITEMa->cSklPol
  aPohyby := {  0, 0, 0, 0 }

  Do While !PVPITEMa->( Eof())

    if cOldStred = PVPITEMa->cNazPol1 .and. cOldStaj = PVPITEMa->cNazPol4 .and. ;
       cOldVykon = PVPITEMa->cNazPol2 .and. cOldSklPol = PVPITEMa->cSklPol
       aPohyby[1] += If(::cObdobi = PVPITEMa->cObdPoh, PVPITEMa->nMnozPrDod, 0)
       aPohyby[2] += If(::cObdobi = PVPITEMa->cObdPoh, PVPITEMa->nCenaCelk, 0)
       aPohyby[3] += PVPITEMa->nMnozPrDod
       aPohyby[4] += PVPITEMa->nCenaCelk
    else
       *
       CNAZPOL1->( dbSeek( Upper( cOldStred),, 'CNAZPOL1'))
       CNAZPOL4->( dbSeek( Upper( cOldStaj) ,, 'CNAZPOL1'))
       CNAZPOL2->( dbSeek( Upper( cOldVykon),, 'CNAZPOL1'))
       CENZBOZ->( dbSeek( Upper( cOldSklPol),, 'CENIK01'))
       cOldStred := PVPITEMa->cNazPol1
       cOldStaj  := PVPITEMa->cNazPol4
       cOldVykon := PVPITEMa->cNazPol2
       cOldSklPol := PVPITEMa->cSklPol
       PVPITEMa->( dbSkip(-1))
       *
       mh_copyfld( 'PVPITEMa', 'VYBRZASw', .T. )
       VYBRZASw->cObdPoh    := ::cObdobi
       VYBRZASw->nObdobi    := Val( Left(::cObdobi, 2))
       VYBRZASw->nRok       := 2000 + Val( Right(::cObdobi, 2))
       VYBRZASw->nMnZaObd   := aPohyby[ 1]
       VYBRZASw->nCeZaObd   := aPohyby[ 2]
       VYBRZASw->nMnOdPOC   := aPohyby[ 3]
       VYBRZASw->nCeOdPOC   := aPohyby[ 4]
       aPohyby := {  0, 0, 0, 0 }
     endif

     PVPITEMa->( dbSkip())
   Enddo
   *
   PVPITEMa->( dbGoBottom())
   CNAZPOL1->( dbSeek( Upper( cOldStred),, 'CNAZPOL1'))
   CNAZPOL4->( dbSeek( Upper( cOldStaj) ,, 'CNAZPOL1'))
   CNAZPOL2->( dbSeek( Upper( cOldVykon),, 'CNAZPOL1'))
   CENZBOZ->( dbSeek( Upper( cOldSklPol),, 'CENIK01'))

   mh_copyfld( 'PVPITEMa', 'VYBRZASw', .T. )
   VYBRZASw->cObdPoh    := ::cObdobi
   VYBRZASw->nObdobi    := Val( Left(::cObdobi, 2))
   VYBRZASw->nRok       := 2000 + Val( Right(::cObdobi, 2))
   VYBRZASw->nMnZaObd   := aPohyby[ 1]
   VYBRZASw->nCeZaObd   := aPohyby[ 2]
   VYBRZASw->nMnOdPOC   := aPohyby[ 3]
   VYBRZASw->nCeOdPOC   := aPohyby[ 4]
   *
   PVPITEMa->(dbCloseArea())
RETURN Nil

********************************************************************************
METHOD  SKL_Report_01:SpotrPHM()
  Local cFilter
  Local indexkey := "Upper( cNazPol1) + Upper( cNazPol5) + Upper( cNazPol2) + Upper( cSklPol)"
  Local cOldStred, cOldStaj, cOldVykon, cOldSklPol, aPohyby
  Local nObdobi, nRok, nObdobiMR, nRokMr, cObdobiMR
  *
  nObdobi   := Val( Left(::cObdobi, 2))
  nRok      := 2000 + Val( Right(::cObdobi, 2))
*  nObdobiMR := nObdobi
  nRokMR    := nRok -1
  cObdobiMR := Left( ::cObdobi, 3) + StrZero( Val( Right( ::cObdobi,2)) -1, 2)
  *
  drgDBMS:open( 'PVPITEM',,,,, 'PVPITEMa')
  PVPITEMa->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'PVPIT_3', 'PVPIT_3',  indexKey ))
  PVPITEMa->(AdsSetOrder('PVPIT_3'))
  *
  cFilter := "(( cObdPoh <= '%%' .and. Right(cObdPoh,2) = '%%' ) .or.  " +;
             "( cObdPoh <= '%%' .and. Right(cObdPoh,2) = '%%' )) .and. " +;
             "Val(Alltrim(cTypPohybu)) >= %% .and. " +;
             "Val(Alltrim(cTypPohybu)) <= %% .and. " +;
             "cNazPol1 >= '%%' .and. cNazPol1 <= '%%' .and. " +;
             "cNazPol5 >= '%%' .and. cNazPol5 <= '%%' .and. " +;
             "cNazPol2 >= '%%' .and. cNazPol2 <= '%%' .and. " +;
             "cSklPol >= '%%' .and. cSklPol <= '%%'"

  cFilter := Format( cFilter, { ::cObdobi, Right(::cObdobi,2),;
                                cObdobiMR, Right(cObdobiMR,2),;
                                Val(::cPohyb_Od), Val(::cPohyb_Do),;
                                Rtrim(::cStred_Od), Rtrim(::cStred_Do),;
                                Rtrim(::cStroj_Od), Rtrim(::cStroj_Do),;
                                Rtrim(::cVykon_Od), Rtrim(::cVykon_Do),;
                                Rtrim(::cSklPol_Od), Rtrim(::cSklPol_Do) })
  /*
  cFilter := "cObdPoh <= '%%' .and. Right(cObdPoh,2) = '%%' .and. " +;
             "Val(Alltrim(cTypPohybu)) >= %% .and. " +;
             "Val(Alltrim(cTypPohybu)) <= %% .and. " +;
             "cNazPol1 >= '%%' .and. cNazPol1 <= '%%' .and. " +;
             "cNazPol5 >= '%%' .and. cNazPol5 <= '%%' .and. " +;
             "cNazPol2 >= '%%' .and. cNazPol2 <= '%%' .and. " +;
             "cSklPol >= '%%' .and. cSklPol <= '%%'"

  cFilter := Format( cFilter, { ::cObdobi, Right(::cObdobi,2),;
                                Val(::cPohyb_Od), Val(::cPohyb_Do),;
                                Rtrim(::cStred_Od), Rtrim(::cStred_Do),;
                                Rtrim(::cStroj_Od) , Rtrim(::cStroj_Do),;
                                Rtrim(::cVykon_Od), Rtrim(::cVykon_Do),;
                                Rtrim(::cSklPol_Od), Rtrim(::cSklPol_Do) })
  */
  PVPITEMa->( mh_SetFilter( cFilter), dbGoTop())

*  nRok    := Val( "20" + Right( ::cObdobi, 2))
*  nRokMin := nRok - 1
*  cObdMin := Left( ::cObdobi, 3) + StrZero( Val( Right( ::cObdobi,2)) -1, 2)
  *
  cOldStred  := PVPITEMa->cNazPol1
  cOldStroj  := PVPITEMa->cNazPol5
  cOldVykon  := PVPITEMa->cNazPol2
  cOldSklPol := PVPITEMa->cSklPol
  aPohyby := {  0, 0, 0, 0, 0, 0, 0, 0 }

  Do While !PVPITEMa->( Eof())

    IF cOldStred = PVPITEMa->cNazPol1 .and. cOldStroj = PVPITEMa->cNazPol5 .and. ;
       cOldVykon = PVPITEMa->cNazPol2 .and. cOldSklPol = PVPITEMa->cSklPol

       IF PVPITEMa->nRok = nRok
         aPohyby[1] += If(::cObdobi = PVPITEMa->cObdPoh, PVPITEMa->nMnozPrDod, 0)
         aPohyby[2] += If(::cObdobi = PVPITEMa->cObdPoh, PVPITEMa->nCenaCelk, 0)
         aPohyby[3] += PVPITEMa->nMnozPrDod
         aPohyby[4] += PVPITEMa->nCenaCelk
       ENDIF

       IF PVPITEMa->nRok = nRokMR
         aPohyby[5] += If( cObdobiMR = PVPITEMa->cObdPoh, PVPITEMa->nMnozPrDod, 0)
         aPohyby[6] += If( cObdobiMR = PVPITEMa->cObdPoh, PVPITEMa->nCenaCelk, 0)
         aPohyby[7] += PVPITEMa->nMnozPrDod
         aPohyby[8] += PVPITEMa->nCenaCelk
       ENDIF

    ELSE
       *
       CNAZPOL1->( dbSeek( Upper( cOldStred),, 'CNAZPOL1'))
       CNAZPOL5->( dbSeek( Upper( cOldStroj),, 'CNAZPOL1'))
       CNAZPOL2->( dbSeek( Upper( cOldVykon),, 'CNAZPOL1'))
       CENZBOZ->( dbSeek( Upper( cOldSklPol),, 'CENIK01'))
       cOldStred  := PVPITEMa->cNazPol1
       cOldStroj  := PVPITEMa->cNazPol5
       cOldVykon  := PVPITEMa->cNazPol2
       cOldSklPol := PVPITEMa->cSklPol
       PVPITEMa->( dbSkip(-1))
       *
       mh_copyfld( 'PVPITEMa', 'VYBRZASw', .T. )
       VYBRZASw->cObdPoh    := ::cObdobi
       VYBRZASw->nObdobi    := nObdobi       // Val( Left(::cObdobi, 2))
       VYBRZASw->nRok       := nRok          //2000 + Val( Right(::cObdobi, 2))
       VYBRZASw->nMnZaObd   := aPohyby[ 1]
       VYBRZASw->nCeZaObd   := aPohyby[ 2]
       VYBRZASw->nMnOdPOC   := aPohyby[ 3]
       VYBRZASw->nCeOdPOC   := aPohyby[ 4]
       VYBRZASw->nMnZaObdMR := aPohyby[ 5]
       VYBRZASw->nCeZaObdMR := aPohyby[ 6]
       VYBRZASw->nMnOdPOCMR := aPohyby[ 7]
       VYBRZASw->nCeOdPOCMR := aPohyby[ 8]

       aPohyby := {  0, 0, 0, 0, 0, 0, 0, 0 }
     endif

     PVPITEMa->( dbSkip())
   Enddo
   *
   PVPITEMa->( dbGoBottom())
   CNAZPOL1->( dbSeek( Upper( cOldStred),, 'CNAZPOL1'))
   CNAZPOL5->( dbSeek( Upper( cOldStroj),, 'CNAZPOL1'))
   CNAZPOL2->( dbSeek( Upper( cOldVykon),, 'CNAZPOL1'))
   CENZBOZ->( dbSeek( Upper( cOldSklPol),, 'CENIK01'))

   mh_copyfld( 'PVPITEMa', 'VYBRZASw', .T. )
   VYBRZASw->cObdPoh    := ::cObdobi
   VYBRZASw->nObdobi    := Val( Left(::cObdobi, 2))
   VYBRZASw->nRok       := 2000 + Val( Right(::cObdobi, 2))
   VYBRZASw->nMnZaObd   := aPohyby[ 1]
   VYBRZASw->nCeZaObd   := aPohyby[ 2]
   VYBRZASw->nMnOdPOC   := aPohyby[ 3]
   VYBRZASw->nCeOdPOC   := aPohyby[ 4]
   VYBRZASw->nMnZaObdMR := aPohyby[ 5]
   VYBRZASw->nCeZaObdMR := aPohyby[ 6]
   VYBRZASw->nMnOdPOCMR := aPohyby[ 7]
   VYBRZASw->nCeOdPOCMR := aPohyby[ 8]
   *
   PVPITEMa->(dbCloseArea())
RETURN Nil

********************************************************************************
METHOD SKL_Report_01:TypPohybu_SEL( oDlg)
  Local oDialog, nExit
  Local name := ::df:olastdrg:name
  Local drgVar := ::dm:get(name, .F.), lastDrg, oVar
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. C_TypPoh->(dbseek(S_DOKLADY + value,,'C_TYPPOH02')))
  *
  If IsObject( oDlg) .or. !ok
     DRGDIALOG FORM 'SKL_TypPoh_Sel' PARENT ::drgDialog MODAL DESTROY EXIT nExit

     IF nExit = drgEVENT_SELECT
       ok := .T.
      ::dm:set( name, C_TypPoh->cTypPohybu )

     ENDIF
  EndIf

RETURN ok

********************************************************************************
METHOD SKL_Report_01:NAZPOLn_SEL( oDlg)
  Local oDialog, nExit
  Local name := drgParseSecond( lower(::df:olastdrg:name), '>')
  Local cfile
  Local drgVar := ::dm:get(name, .F.), ok
  Local value  := drgVar:get()

  Do case
  Case name $ 'cstred_od,cstred_do' ; cfile := 'cNazPOL1'
  Case name $ 'cvykon_od,cvykon_do' ; cfile := 'cNazPOL2'
  Case name $ 'cstaj_od,cstaj_do'   ; cfile := 'cNazPOL4'
  Case name $ 'cstroj_od,cstroj_do' ; cfile := 'cNazPOL5'
  EndCase

  ok := ( Empty(value) .or. ( !Empty(value) .and. (cfile)->(dbSeek( value,,'CNAZPOL1'))))
  *
  If IsObject( oDlg) .or. !ok
     DRGDIALOG FORM cFile PARENT ::drgDialog CARGO drgVar MODAL DESTROY EXIT nExit

     IF nExit = drgEVENT_SELECT
       ok := .T.
      ::dm:set( name, (cfile)->&cfile )

     ENDIF
  EndIf

RETURN ok

********************************************************************************
METHOD SKL_Report_01:CENZBOZ_SEL( oDlg)
  Local oDialog, nExit
  Local name := drgParseSecond( lower(::df:olastdrg:name), '>')
  Local cfile
  Local drgVar := ::dm:get(name, .F.), ok
  Local value  := drgVar:get()

  ok := ( Empty(value) .or. ( !Empty(value) .and. CenZboz->( dbSEEK( Value,,'CENIK01')) ))

  IF IsObject( oDlg) .or. !ok
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::drgDialog  MODAL DESTROY EXIT nExit

    IF nExit != drgEVENT_QUIT .or. ok     //nExit = drgEVENT_SELECT
      ok := .T.
      ::dm:set( name, CENZBOZ->CSKLPOL )
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
    ENDIF
  EndIf

RETURN ok
*

* Poè. stav ceníku na poèátku roku
*===============================================================================
STATIC FUNCTION PocStavCEN( cSklPol)
  Local aX := { 0, 0}

  CENZBOZw->( mh_SetScope( Upper(cSklPol)))
  CENZBOZw->( dbEval( { || ( aX[1] += CENZBOZw->nMnozPoc,  ;
                             aX[2] += CENZBOZw->nCenaPoc)}))
  CENZBOZw->( mh_ClrScope())

Return aX

* Poèáteèní a Koncový stav ceníku za období
*===============================================================================
FUNCTION StavCENzaOBD(nObdobi, nRok)
  Local StavyObd

  StavyObd           := SKL_StavyObd_SCR():new()
  StavyObd:nObdPOC   := 1
  StavyObd:nObdKON   := nObdobi
  StavyObd:nRok      := nRok   //  VAL( RIGHT( obdReport, 4))
  StavyObd:oneSklPOL := .T.
  *
  StavyObd:createKUMUL()
  *
RETURN NIL