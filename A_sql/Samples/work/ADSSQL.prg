/*

AdsStatement() is used in this sample program to accept a SQL
statement and create a SQL cursor that can be navigated with
standard DBE navigation methods, like dbSkip(), dbGotop(),
@ DCBROWSE, etc.  This uses a new feature of Xbase++ 1.9 that
really simplifies the process of using SQL queries in an Xbase++
application.  Nothing else is needed except the ADSDBE and
Xbase++ 1.9.

Currently, there is a limitation in Xbase++ 1.9 that requires
use of an ADS data-dictionary (*.ADD) file.

A dictionary file can be easily created using the Advantage
Architect by adding existing DBF/CDX files.

*/


#INCLUDE "dcdialog.CH"
#INCLUDE "adsdbe.CH"
#INCLUDE "appevent.CH"

#define ADS_NTX                  1
#define ADS_CDX                  2
#define ADS_ADT                  3

FUNCTION Main( cIndexMode )

LOCAL GetList[0], GetOptions, cAlias1, cServer, cDataPath, ;
      oSession, oTab1, oTab2, oTab3, oBrowse1, oBrowse2, oBrowse3, oBrowse4, ;
      cStatement1, oStatement1, cAlias2, cStatement2, oStatement2

cServer := '.\data\samples.add'
cDataPath := '.\data\'
SET DEFAULT TO (cDataPath)

AX_AxsLocking(.t.)

oSession := AdsSession( cServer )

USE XTEST
USE CUSTOMER NEW

@ 0,0 DCTABPAGE oTab1 CAPTION 'Normal Use' SIZE 90, 24 TABWIDTH 20
@ 0,0 DCTABPAGE oTab2 CAPTION 'SQL Use (XTest)' RELATIVE oTab1
@ 0,0 DCTABPAGE oTab3 CAPTION 'SQL Use (Invoice)' RELATIVE oTab2

* ------ Tab Page 1 ------

@ 2,2 DCSAY 'This is a browse of XTEST with a normal USE (ISAM)' SAYSIZE 0 ;
      PARENT oTab1

@ 3,2 DCBROWSE oBrowse1 ALIAS 'XTEST' SIZE 86,8 ;
      PRESENTATION DC_BrowPres() PARENT oTab1

DCBROWSECOL FIELD XTEST->areacode HEADER 'Area Code' WIDTH 10 ;
      PARENT oBrowse1

DCBROWSECOL FIELD XTEST->exchange HEADER 'Exchange' WIDTH 10 ;
      PARENT oBrowse1

DCBROWSECOL FIELD XTEST->number HEADER 'Number' WIDTH 10 ;
      PARENT oBrowse1

@ 12,2 DCSAY 'This is a browse of CUSTOMER with a normal USE (ISAM)' SAYSIZE 0 ;
      PARENT oTab1

@ 13,2 DCBROWSE oBrowse2 ALIAS 'CUSTOMER' SIZE 86,10 ;
      PRESENTATION DC_BrowPres() PARENT oTab1 ;
      HEADLINES 2

DCBROWSECOL FIELD CUSTOMER->cust_nmbr HEADER 'Cust;Nmbr' WIDTH 10 ;
      PARENT oBrowse2 SORT {||CUSTOMER->(OrdSetFocus('CUST_NMBR'))}

DCBROWSECOL FIELD CUSTOMER->cust_code HEADER 'Cust;Code' WIDTH 10 ;
      PARENT oBrowse2 SORT {||CUSTOMER->(OrdSetFocus('CUST_CODE'))}

DCBROWSECOL FIELD CUSTOMER->bill_name HEADER 'Billing Name' WIDTH 15 ;
      PARENT oBrowse2

DCBROWSECOL FIELD CUSTOMER->bill_city HEADER 'Billing City' WIDTH 15 ;
      PARENT oBrowse2

TEXT INTO cStatement1 WRAP
SELECT AreaCode AS Area, Exchange AS Exch, Number AS Numb
FROM XTEST WHERE AreaCode = '100'
ENDTEXT

SELECT 0
oStatement1 := AdsStatement():New(cStatement1,oSession)
IF oStatement1:LastError > 0
  RETURN .f.
ENDIF
cAlias1 := oStatement1:Execute('PHONE')
IF Empty(cAlias1)
  RETURN .f.
ENDIF

TEXT INTO cStatement2 WRAP
SELECT
Invoice.Inv_nmbr as Invoice,
Invoice.Balance as Balance,
Customer.Bill_name as Customer,
Customer.Phone as Phone
FROM Invoice
LEFT OUTER JOIN Customer ON invoice.cust_nmbr = Customer.cust_nmbr
WHERE Invoice.Balance > 0
ENDTEXT

SELECT 0
oStatement2 := AdsStatement():New(cStatement2,oSession)
IF oStatement2:LastError > 0
  RETURN .f.
ENDIF
cAlias2 := oStatement2:Execute('INVOICES')
IF Empty(cAlias2)
  RETURN .f.
ENDIF

* ------ Tab Page 2 ------

@ 2,2 DCSAY 'This is a browse of XTEST using a SQL Statement:' SAYSIZE 0 ;
      PARENT oTab2

@ 1.9, DCGUI_COL + 10 DCPUSHBUTTON CAPTION 'Export to Excel' SIZE 20,1 ;
      ACTION {|c|c:=DC_Path(AppName(.t.))+'XTEST.XLS', ;
                 (cAlias1)->(DC_WorkArea2Excel(c,,,,,.f.)), ;
                 DC_SpawnUrl(c)} PARENT oTab2

@ 3,2 DCMULTILINE cStatement1 SIZE 86,2.5 NOHSCROLL FONT '8.Lucida Console' ;
      PARENT oTab2

@ 6,2 DCBROWSE oBrowse3 ALIAS cAlias1 SIZE 86,17 ;
      PRESENTATION DC_BrowPres() EDIT xbeBRW_ItemSelected PARENT oTab2

DCBROWSECOL FIELD (cAlias1)->Area HEADER 'Area Code' WIDTH 10 ;
      PARENT oBrowse3

DCBROWSECOL FIELD (cAlias1)->Exch HEADER 'Exchange' WIDTH 10 ;
      PARENT oBrowse3

DCBROWSECOL FIELD (cAlias1)->Numb HEADER 'Number' WIDTH 10 ;
      PARENT oBrowse3

* ------- Tab Page 3 ---------

@ 2,2 DCSAY 'This is a browse of INVOICES using a SQL Statement:' SAYSIZE 0 ;
      PARENT oTab3

@ 1.9, DCGUI_COL + 10 DCPUSHBUTTON CAPTION 'Export to Excel' SIZE 20,1 ;
      ACTION {|c|c:=DC_Path(AppName(.t.))+'INVOICES.XLS', ;
                 (cAlias2)->(DC_WorkArea2Excel(c)), ;
                 DC_SpawnUrl(c)} PARENT oTab3

@ 3,2 DCMULTILINE cStatement2 SIZE 86,5.5 NOHSCROLL FONT '8.Lucida Console' ;
      PARENT oTab3

@ 9,2 DCBROWSE oBrowse4 ALIAS cAlias2 SIZE 86,14 ;
      PRESENTATION DC_BrowPres() EDIT xbeBRW_ItemSelected PARENT oTab3 ;
      HEADLINES 2

DCBROWSECOL FIELD (cAlias2)->Invoice HEADER 'Invoice;Number' WIDTH 10 ;
      PARENT oBrowse4

DCBROWSECOL FIELD (cAlias2)->Balance HEADER 'Balance' WIDTH 10 ;
      PARENT oBrowse4

DCBROWSECOL FIELD (cAlias2)->Customer HEADER 'Customer Name' WIDTH 20 ;
      PARENT oBrowse4

DCBROWSECOL FIELD (cAlias2)->Phone HEADER 'Phone Number' WIDTH 15 ;
      PARENT oBrowse4

@ 24,0 DCPUSHBUTTON CAPTION 'Exit' SIZE 9,1.2 ;
      ACTION {||DC_ReadGuiEvent(DCGUI_EXIT_OK,GetList)}

@ DCGUI_ROW, DCGUI_COL + 10 DCPUSHBUTTON CAPTION 'SQL Query' SIZE 9,1.2 ;
      ACTION {||Thread():new():start({||SQLQuery(cServer,cDataPath)})}

DCGETOPTIONS NORESIZE

DCREAD GUI ;
   FIT ;
   TITLE 'ADS SQL Test'

oStatement1:close()
oStatement2:close()
oSession:disConnect()

RETURN nil

* ------------------

STATIC FUNCTION SQLQuery(cServer,cDataPath)

LOCAL oSession := DC_AdsSession( cServer )

DC_AdsSQLQuery(cServer,,,cDataPath)

oSession:disConnect()

RETURN nil

* ---------------

PROC appsys
RETURN

* ---------------

PROC dbesys

LOCAL i, aDbeList := DbeList(), cDbeList := '', cDbe := dbeSetDefault(), ;
      bErrorBlock := ErrorBlock({|e|Break(e)})

IF Valtype(aDbeList) = 'A'
  FOR i := 1 TO Len(aDbeList)
    cDbeList += aDbeList[i,1] + ','
  NEXT
ENDIF

aDbeList := cDbeList

BEGIN SEQUENCE
IF !('DBFDBE'$aDbeList) .AND. !DbeLoad( "DBFDBE",.T.)
   DC_WinAlert( "Database-Engine DBFDBE not loaded" )
ENDIF
END SEQUENCE
BEGIN SEQUENCE
IF !('NTXDBE'$aDbeList) .AND. !DbeLoad( "NTXDBE",.T.)
   DC_WinAlert( "Database-Engine NTXDBE not loaded"  )
ENDIF
END SEQUENCE
BEGIN SEQUENCE
IF !('DBFNTX'$aDbeList) .AND. !DbeBuild( "DBFNTX", "DBFDBE", "NTXDBE" )
   DC_WinAlert( "DBFNTX Database-Engine, Could not build engine" )
ENDIF
END SEQUENCE

IF ! DbeLoad( "ADSDBE" )
  MsgBox( "Unable to load ADSDBE", "ADS Server")
  QUIT
ENDIF

dbeSetDefault('ADSDBE')
DbeInfo( COMPONENT_DATA, ADSDBE_TBL_MODE, ADSDBE_CDX )
DbeInfo( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_CDX )
DbeInfo( COMPONENT_DATA, ADSDBE_LOCK_MODE, ADSDBE_COMPATIBLE_LOCKING  )

ErrorBlock(bErrorBlock)

RETURN






