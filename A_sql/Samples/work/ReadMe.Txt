Included are a set of programs that demonstrate how to use Advantage Server
with Xbase++:

To build the programs run PBUILD PROJECT.

PROJECT.XPJ is a project file that will build the following programs:

1. ADSQUICK.EXE

This is created from ADSQUICK.PRG and DBESYS.PRG.

This will demonstrate how easy it is to add Advantage Server to an existing
application.

If you comment out #INCLUDE "DBESYS.PRG", the application will use the default
DBFNTX driver to open the databases, otherwise it will use the ADSDBE driver
and the options setup in DBESYS.PRG.


2. ADSSQL.EXE

This is created from ADS.PRG, ADSSQL.PRG, DCDIALOG.CH and DCLIPX.LIB.
It also requires the eXpress++ runtime files DCLIP*.DLL.

ADS.PRG contains a complete set of wrappers for all Ads*() functions.
ADSSQL.PRG contains the code for the sample program.  It uses eXpress++
commands (from DCDIALOG.CH) to create the dialog elements.

This will demonstrate how Advantage Server can be used in ISAM mode or SQL
mode to access data.

The connection to the data is via a data-dictionary file: SAMPLES.ADD.  The
data files exist in the .\data subfolder.


3. UPDATE.EXE

This is created from UPDATE.PRG, ADS.PRG, DC*.CH, XBTBASE1.LIB and
DCLIPX.LIB It also requires eXpress++ runtime files DCLIP*.DLL and Alaska
runtime file XbtBase1.Dll. It uses eXpress++ commands (from DC*.CH files) to
create the dialog elements.

This program is used to update the structure of a set of database files and
indexes to exactly match the structure in a data-dictionary (.ADD) file.

This is a much faster and more reliable method of updating structure than the
more common techiques employed in Xbase++ applications because it uses SQL to
perform the updates.

This is accomplished by comparing the structure of the actual databases and
indexes to the structure in the data dictionary and then creating a set of
*.SQL files to execute.  The .SQL files will contain the SQL commands needed
to make all of the changes.


4. DATADICT.EXE

This is created from DATADICT.PRG, PRCHOICE.PRG, ADS.PRG, DC*.CH and
DCLIPX.LIB. It also requires eXpress++ runtime files DCLIP*.DLL.  It uses
eXpress++ commands (from DC*.CH files ) to create the dialog elements.

This program uses opens a data dictionary and provides a treeview of all
tables and views in the dictionary. Right-click a tree item for a menu.

To run the sample enter the following command at a command prompt:

DATADICT /DICT:.\data\samples.add


5. SQLRUN.EXE

This is created from SQLRUN.PRG and DCLIPX.LIB.  It uses the function
DC_AdsSqlQuery() from the eXpress++ library to execute the query and display
the results of the query, therefore it requires eXpress++ runtime files
DCLIP*.DLL.

This program is used to run a *.SQL file.  It does NOT require ADSDBE because
the SQL query is accomplished using the Ads API rather than a work area.

It can connect to a Data Dictionary or a directory of tables.



