README.TXT               Example AEP Written in VO                      Ver 1.1
==========               =========================                      =======

This example demonstrates how to write an Advantage Extended Procedure
(AEP) in VO. It is intended to show only the very basic aspects of AEP
programming.


Contents:
==========
1. General Information
2. Example Requirements
3. Running the Example
4. Known Issues


1. General Information
======================
This example shows how to write a simple AEP with input and output parameters.
It does not however demonstrate how to maintain state information via the
startup and shutdown functionality. The Delphi and Visual Basic AEP tutorials
in the Advantage help documentation do implement this and can be used as a
reference.


2. Example Requirements
=======================
This example AEP was written for use with Advantage 7.0 and newer. This
is due to the fact that it uses the AEP interface 2 introduced in version
7.0 of Advantage. Interface 1 is still supported, but considered obsolete.
This example requires both the Advantage Client Engine and the Advantage
CA-Visual Objects RDDs installed to work. To execute the stored procedure,
an Advantage enabled application is required. This can be done easily via the
Advantage Data Architect Native SQL utility (see Running the Example below).
Otherwise, a stand alone application would need to connect to ADS and execute
the procedure programmatically.

Because the AEP itself is a Visual Objects DLL, it requires the VO runtime
DLLs as well as the Advantage ADT RDD (ADSADT.RDD). Specifically, it requires
CAVO2RDD.DLL, CAVORT20.dll, and VO27SYS.DLL from the Cavo26\Bin directory if
compiled with VO 2.6 (VO27RDD.DLL, VO27RUN.DLL, and VO27SYS.DLL from Cavo27\bin
if compiled with VO 2.7). Also, ADSADT.RDD must be the version built for the
appropriate version of VO (2.5/2.6 or 2.7). These DLLs and the RDD must be in
the same directory as the application which calls the AEP, or in the
application's path for use with local server. For remote server, these DLLs and
the ADSADT.RDD must be in the Advantage server install directory. The AEP
(ADS_AEP.AEP) must be in the directory specified by the data dictionary (the
same directory as the .ADD file in the example.add data dictionary).

NOTE: If the AEP source code is modified such that it requires more VO DLLs,
they also must be in the directories specified above. The DLLs required by
the VO AEP can be easily seen by running a dependency utility such as
depends.exe (Dependency Walker) from Microsoft.


3. Running the Example
======================
The simplest way to run the example is to use the provided AEP_Tester
application. This sample application (source included) shows how to connect to
an Advantage Server, create an SQL statement, and execute an SQL query. Simply
provide the path to the example.add and connection type and press the Execute
button. The result of the query should be displayed in the Result textbox. Any
errors that may occur will be displayed via a message box.

Another easy way to run the example is to open up Advantage Data Architect
(ARC) and use the Native SQL Utility (in the Tools menu, or Ctrl-Q). Using the
Native SQL Utility, connect to the provided Advantage Data Dictionary
(example.add) as ADSSYS, with no password (be sure to select Dictionary above
the connection path textbox). Then in the query text window, type:

EXECUTE PROCEDURE MyAEP( 1, 2 )

Pressing the Execute button will send the command to the server for execution.
The query should return with the sum of the two parameters, in this case 3.


4. Known Issues
===============
Currently AEPs written in VO have shown not to be thread safe. Multiple
applications executing the same AEP tend to destroy each other's work areas. To
avoid this issue, the AEP example included in this package uses a critical
section to gaurantee only one application may execute the AEP at a time. This
reduces the AEP to a single threaded module, but ensures it operates properly.