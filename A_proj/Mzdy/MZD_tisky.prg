#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"

#include "..\LL_miss\cmbtll11.ch"
#include "Xbp.ch"
#include "dll.ch"


//-----+ FI_fakprihd_SCR +-------------------------------------------------------
CLASS MZD_tisky_CRD FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
//  METHOD  ItemMarked
//  METHOD  ItemSelected
//  METHOD  InFocus
//  METHOD  CardOfKmenMzd
//  METHOD  drgDialogStart
  METHOD NewFrm
  METHOD EditFrm
  METHOD StartTisk

/*
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT   ;   ::CardOfKmenMzd()
    CASE nEvent = xbeP_Keyboard
      Do Case
      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.
*/
ENDCLASS

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_tisky_CRD:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MZDY')
  drgDBMS:open('M_DAV')
  drgDBMS:open('MSPRC_MO')

  MZDY->( DbSetRelation( 'DRUHYMZD',  { || MZDY->nDruhMzdy },  'MZDY->nDruhMzdy'))

//    MZD_MsPrc_MO->( DbSetRelation( 'PER_PRSMLDOH', { || Upper(MZD_MsPrc_MO->cRodCisPra)}, 'Upper(MZD_MsPrc_MO->cRodCisPra)',"PrcSml02",,.T.))

//  drgDBMS:open('SKL_PVPHEAD')
//  SKL_PVPHEAD->( DbSetRelation( 'SKL_CDRPOHY', { || SKL_PVPHEAD->nCislPoh },'SKL_PVPHEAD->nCislPoh'))
//  SKL_PVPITEM->( DbSetRelation( 'CIS_CDPH', { || SKL_PVPITEM->nKlicDPH },'SKL_PVPITEM->nKlicDPH'))

//  ::KUHRADE_vzm := 0
RETURN self


METHOD MZD_tisky_CRD:NewFrm()
  DefineListLayout( .T.)
RETURN .T.


METHOD MZD_tisky_CRD:EditFrm()
  DefineListLayout()
RETURN .T.

METHOD MZD_tisky_CRD:StartTisk()
  PrintList()
RETURN .T.



// D:   Ab hier beginnen List & Label spezifische Design- und
//     Druckroutinen
// US: List & Label specific print and design routines start
//     here


//-------------------------------------------------------------------
PROCEDURE DefineListLayout( lNEW)
//-------------------------------------------------------------------

  LOCAL aField, aType, aLen, aDec, sName

  DEFAULT lNEW TO .F.

//    dbSelectArea( "MSPRC_MO")

    //D:   Arrays um Felderinfo zu speichern
    //US: storage arrays for field info
//    aField := Array( FCount() )
//    aType  := Array( FCount() )
//    aLen   := Array( FCount() )
//    aDec   := Array( FCount() )
    sname  := replicate(chr(0),255)
//    sname  := "Test.lst"


    //D:   Felderinfo aus der Datenbank lesen
    //US: Read field info from database
//    AFields( aField, aType, aLen, aDec )
    LL11ModuleInit()

//    LlJobOpen(nLanguage)
    //D:   List & Label Job oeffnen und handle holen
    //US: open List & Label job, retrieve job handle
    hJob := LlJobOpen(11)

//    cTblName := "MSPRC_MZ"


        //D:   Mehrfache Tabellenzeilendefinitionen ermoeglichen
        //US: Enable multiple table lines
        LlSetOption(hJob, LL_OPTION_MULTIPLETABLELINES, 1)

    //D:   Dateiauswahldialog oeffnen
    //US: call file open dialog
   IF lNEW
     nRet:= LlCreateSketch(hJob, LL_PROJECT_LIST, @sName)
   ELSE
     nRet:=LlSelectFileDlgTitleEx(hJob, SetAppWindow():getHWND(),;
                "Select File", ;
                        LL_PROJECT_LIST, @sName, 255)
   ENDIF

//        LlSelectFileDlgTitleEx(hLlJob, hWnd, pszTitle, nObjType, pszObjName, nBufSize, pReserved)


    if nRet != LL_ERR_USER_ABORTED

            //D:   DLL-internen Felderpuffer loeschen
            //US: clear DLL-internal field buffer

      LlDefineFieldStart(hJob)
      LlDbAddTable(hJob, "", 0)

      dbSelectArea("M_DAV")
      dbGoTop()
      aField := Array( FCount() )
      aType  := Array( FCount() )
      aLen   := Array( FCount() )
      aDec   := Array( FCount() )
      AFields( aField, aType, aLen, aDec )
      LlDbAddTable(hJob, "M_DAV", 0)
//      LlDefineFieldStart(hJob)
      DefineData(.T., aField, aType, aLen, aDec)

      dbSelectArea("MSPRC_MO")
      dbGoTop()
      aField := Array( FCount() )
      aType  := Array( FCount() )
      aLen   := Array( FCount() )
      aDec   := Array( FCount() )
      AFields( aField, aType, aLen, aDec )
      LlDbAddTable(hJob, "MSPRC_MO", 0)
//      LlDefineFieldStart(hJob)
      DefineData(.T., aField, aType, aLen, aDec)

        // D:   Designer aufrufen
        // US: start designer
      LlSetPrinterDefaultsDir(hJob, MyGetTempPath())
      LlDefineLayout(hJob, SetAppWindow():GetHWND(),;
             "Designer", LL_PROJECT_LIST, sName)
    endif

        // D:   List & Label-Job beenden
        // US: Close List & Label job
    LlJobClose(hJob)
    LL11ModuleExit()

RETURN


//-------------------------------------------------------------------
PROCEDURE PrintList()
//-------------------------------------------------------------------

    LOCAL aField, aType, aLen, aDec, sName

    //D:   Arrays um Felderinfo zu speichern
    //US: storage arrays for field info
    aField := Array( FCount() )
    aType  := Array( FCount() )
    aLen   := Array( FCount() )
    aDec   := Array( FCount() )

    sName:=Replicate(chr(0),255)

    GO TOP

        //D:   Felderinfo aus der Datenbank lesen
        //US: Read field info from database
    AFields( aField, aType, aLen, aDec )
        LL11ModuleInit()

        //D:   List & Label Job oeffnen und handle holen
        //US: open List & Label job, retrieve job handle
    hJob := LlJobOpen(-1)

        //D:   Mehrfache Tabellenzeilendefinitionen ermoeglichen
        //US: Enable multiple table lines
        LlSetOption(hJob, LL_OPTION_MULTIPLETABLELINES, 1)

    //D:   Dateiauswahldialog oeffnen
    //US: call file open dialog
        nRet:=LlSelectFileDlgTitleEx(hJob, SetAppWindow():getHWND(),;
                "Select File", ;
                        LL_PROJECT_LIST, @sName, 255)


    if nRet != LL_ERR_USER_ABORTED

    nCount := RECCOUNT()
    nAkt := 0

        //D:   DLL-internen Felderpuffer loeschen
        //US: clear DLL-internal field buffer
        LlDefineFieldStart(hJob)

        // D:   Felder definieren
    // US: Define Fields
    DefineData(.T., aField, aType, aLen, aDec)

        // D:   List & Label Druckjob starten
        // US: start List & Label print job
    LlSetPrinterDefaultsDir(hJob, MyGetTempPath())
    nRet := LlPrintWithBoxStart(hJob,                ;
                     LL_PROJECT_LIST,                ;
                     sName,                        ;
                     LL_PRINT_PREVIEW,                ;
                     LL_BOXTYPE_NORMALWAIT,        ;
                     SetAppWindow():GetHWND(),        ;
                     "Preview")

    LlPreviewSetTempPath(hJob, MyGetTempPath())

    // D:   Kopfzeile der ersten Seite drucken
        // US: Print header for first page
    nRet := LlPrint(hJob)

        //D:   aeussere Schleife: Wiederholung fuer jede Seite
        //US: outer loop: repeat for each page
    do while (nCount > 0) .AND. (nRet = 0) .AND. (!EOF())

               //D:   innere Schleife: Wiederholung fuer jeden Datensatz
                //US: inner loop: repeat for each record
                do while (nCount>0) .AND. (nRet = 0) .AND. (!EOF())

                        //D:   Felder definieren
                        //US: define fields
                DefineData(.T., aField, aType, aLen, aDec)

                        //D:   Tabellenzeile ausdrucken
                        //US: print table line
                      nRet:=LlPrintFields(hJob)

                        //D:   zum naechsten Datensatz wechseln
                    //US: move to next record
                        DBSkip(1)
                nAkt := nAkt + 1

                        //D:   Fortschrittsanzeige aktualisieren
                        //US: update meter info
                LlPrintSetBoxText(hJob, "Printing", ( (100*nAkt)/nCount ))
            end do

                //D:   wenn Seitenumbruch, dann neue Kopfzeile drucken und
                //    alte Daten wiederholen
                //US: on pagebreak print new header and repeat last data
                do while nRet=LL_WRN_REPEAT_DATA
                    LlPrint(hJob)
                        nRet:=LlPrintFields(hJob)
                end do
    END DO

        //D:   Drucke Fusszeile der letzten Seite
        //US: print footer of last page
    nRet:=LlPrintFieldsEnd(hJob)

    //D:   Seitenumbruch fuer letzte Fusszeile, wenn noetig
    //US: Page break for last footer, if necessary
    do while nRet=LL_WRN_REPEAT_DATA
            nRet:=LlPrintFieldsEnd(hJob)
    end do

        //D:   List & Label Druckjob abschliessen
        //US: end List & Label print job
    LlPrintEnd(hJob, 0)

        //D:   Vorschau anzeigen, wenn keine Fehler
        //US: display preview if no error occurred
    if nRet = 0
        LlPreviewDisplay(hJob, sName, myGetTempPath(), SetAppWindow():GetHWND())

        //D:   temporaere Vorschaudatei loeschen
                //US: delete temporary preview files
        LlPreviewDeleteFiles(hJob, sName, MyGetTempPath())
    endif

    endif //LL_ERR_USER_ABORTED

        // D:   List & Label-Job beenden
        // US: Close List & Label job
    LlJobClose(hJob)
    LL11ModuleExit()

RETURN

//-------------------------------------------------------------------
PROCEDURE DefineData(bAsField, aField, aType, aLen, aDec)
//-------------------------------------------------------------------

//D:   Wird vom Programm aufgerufen, um die Daten entsprechend dem
//          neuen Datensatz zu definieren. In bAsField wird festgelegt,
//    ob die Daten als Felder oder als Variable an List & Label
//    uebergeben werden
//US: Is called by the program to define the variables according
//    to the new record. bAsField distinguishes between field and
//    variable declaration to List & Label

LOCAL FldType, FldContent, DateBuffer, lExpr

           //D:   Umwandlung von xbase ++ Feldtypen in List & Label Feldtypen
        //US: convert xbase ++ field types to List & Label field types

    FOR i:=1 to fcount()

    DateBuffer = Replicate(chr(0), 255)

                DO CASE

             CASE aType[i] == "N"
                FldType=LL_NUMERIC
                FldContent=Str( FieldGet(i) )

             CASE aType[i] == "D"
                FldType=LL_DATE

        //D:   In Julianisches Datum konvertieren
        //US: Convert to Julian Date

        //D:   Ausdruck aufbauen
        //US: Create function tree
        lExpr = LlExprParse(hJob,"DateToJulian(DATE("+;
             chr(34)+DTOC(FieldGet (i) )+chr(34)+"))", .F.)

        //D:   Ausdruck auswerten
        //US: Evaluate expression
        LlExprEvaluate(hJob, lExpr, @DateBuffer, 255)

        //D:   Ausdruck wieder freigeben
        //US: Free expression
        LlExprFree(hJob, lExpr)

        FldContent = DateBuffer

             CASE aType[i] == "L"
                FldType=LL_BOOLEAN
                if FieldGet(i) = .F.
                        FldContent="FALSE"
                        else
                        FldContent="TRUE"
                endif

             CASE aType[i] == "C"
                FldType=LL_TEXT
                FldContent=Trim(FieldGet(i))

                // D:   Fuer Artikelnummer: EAN128-Barcode anlegen
                // US: for article number generate EAN128-barcode
                if i=1
          DO CASE

            // D:   Zwischen Feld- und Variablendefinition unterscheiden
            // US: Distinguish between field and variable declaration
            CASE bAsField==.F.
                    LlDefineVariableExt(hJob, "ARTICLENO_EAN128",;
                     Trim(FieldGet(i)), LL_BARCODE_EAN128, 0 )
            CASE bAsField==.T.
            LlDefineFieldExt(hJob, "ARTICLENO_EAN128",;
             Trim(FieldGet(i)), LL_BARCODE_EAN128, 0 )

          END CASE
                endif

            CASE aType[i] == "M"
                FldType=LL_TEXT
                FldContent=FieldGet(i)

                END CASE

                //D:   Daten an List & Label geben
                //US: pass data to List & Label

        DO CASE
            CASE bAsField==.F.
                    LlDefineVariableExt(hJob, aField[i], FldContent, FldType, 0 )
            CASE bAsField==.T.
            LlDefineFieldExt(hJob, aField[i], FldContent, FldType, 0 )
        END CASE

    NEXT I

RETURN


DLLFUNCTION GetTempPathA( buffsize, @buffer ) ;
         USING STDCALL ;
          FROM KERNEL32.DLL


FUNCTION MyGetTempPath()

LOCAL nBuffSize := 261
LOCAL sBuffer := Replicate(chr(0),261)

GetTempPathA(nBuffsize, @sBuffer)

return sBuffer

//////////////////////////////////////////////////////////////////////