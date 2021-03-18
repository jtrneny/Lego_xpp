README.TXT	  Trigger Notification Demo		12 JAN 2005
==========	=================================	===========

This example demonstrates the use of Advantage Triggers to copy
data changes to a duplicate table on another server.  

Contents:
==========
1. General Information
2. Version Information
3. Known Issues


1. General Information
======================
This example uses a trigger to copy record changes to a backup
server.  

To run the example, extract all the files into one folder.  Open
the BackupTrig.dpr and modify the connect path in code (this was
hard-coded for this simple example).  The following is the line
to modify.

 oConnBackup.ConnectPath := '\\server\c$\data';

The data directory should contain a copy of a free (non-Data 
Dictionary bound) table that you wish to duplicate.  To use a
Data Dictionary bound table, modify that ConnectPath to reference
the dictionary file.

The customers.add (username: adsys password: [blank]) has the 
appropriate triggers registered under the customers table.  To
activate the trigger, open the customers table and make a 
modification using the Advantage Data Architect.

This example was featured in the "Simple and Useful Triggers" online
seminar that can be viewed at

http://resolution.extendedsystems.com/ADS/News+-+Events/Online+Seminar+Archives.htm

For additional information on creating and debugging triggers, so 
the trigger tutorial in the Advantage Help file.


2. Version Information
======================

This demo application was written in Delphi 7 using the Advantage 7.1 
tDataset decendant.  

This demo uses functionality introduced in version 7.0 of Advantage.  You
must use version 7.0 or newer to use this example.

See the Advantage Help file for addition information about creating triggers.


3.  Known Issues
================
This is for example purposes only.  Note: there may be performance issues because
each trigger execution makes a connection to a second machine.  The trigger dll
can be modified to cache connections and table opens.  
