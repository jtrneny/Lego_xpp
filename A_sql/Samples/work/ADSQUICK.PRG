/*
This program is here to demonstrate how easy
it is to add Advantage Server to an existing
application.

If you comment out #INCLUDE "DBESYS.PRG", the
application will use the default DBFNTX
driver to open the databases, otherwise it
will use the ADSDBE driver and the options
setup in DBESYS.PRG.
*/

#INCLUDE "DBESYS.PRG"

FUNCTION Main()

SET DEFAULT TO .\DATA

USE CUSTOMER
Browse()

USE INVOICE
Browse()

USE XTEST
Browse()

RETURN nil
