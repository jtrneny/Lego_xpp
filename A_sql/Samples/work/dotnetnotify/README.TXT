README.TXT	  Trigger Notification Demo		12 JAN 2005
==========	=================================	===========

This example demonstrates the use of Advantage Triggers to implement
client notification.

Contents:
==========
1. General Information
2. Version Information
3. Known Issues


1. General Information
======================
This example uses a trigger to notify the client of changes to the
database.  The trigger code is contained in trig_functions.vb and uses a 
UDPClient to send messages to the client (see clientApp folder).

To run the example, extract all the files from the zip file.  Modify
the data path in the clientApp to connect to the customers.add (login: adssys 
Password: [blank]).  Run the ClientApp.exe

To register the trigger, use "regasm" to register the trigger on the server.
Then, open the customer table with the Advantage Data Architect (ARC) and 
post the record.  The trigger will send a UDP broadcast on the network with
the changed record information.


2. Version Information
======================

This demo application was written in Microsoft Visual Studio.NET 2003.  The
Advantage .NET Data Provider must be installed for the client application.  
This demo uses functionality introduced in version 7.1 of Advantage.  You
must use version 7.1 or newer to use this example.

See the Advantage Help file for addition information about creating triggers.

Also, the example was demonstrated in the Advantage Online Seminar Seminar
titled "Simple and Useful Triggers"  It can be downloaded from 
WWW.ADVANTAGEDATABASE.COM.


3.  Known Issues
================
This is for example purposes only.  Additional error-checking and threading may
be required for full functionality.