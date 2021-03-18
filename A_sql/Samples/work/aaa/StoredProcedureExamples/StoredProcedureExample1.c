/*
 * This example provides the easiest possible stored procedure DLL.  It uses
 * message boxes to demonstrate when the functions are being called.  Note that
 * when this is run from the Advantage Database Server on NT, this may not
 * display the message boxes.  The DLL is running within the context of the
 * Advantage Database Server, which is a NT Service.  NT Services may not
 * interact with the desktop.
 */

#include <windows.h>
#include <stdio.h>
#include <crtdbg.h>

#include "examples.h"

BOOL APIENTRY DllMain( HANDLE h,
                       DWORD  dwProcessState,
                       LPVOID lpVoid
                     )
{
   // the constant DATA_DIRECTORY must end in a backslash
   _ASSERT( DATA_DIRECTORY[ strlen( DATA_DIRECTORY ) - 1 ] == '\\' );

   switch ( dwProcessState )
      {
      case DLL_PROCESS_ATTACH:
         MessageBox( 0, "Hello from StoredProcedureExample1 -- in DLL_PROCESS_ATTACH", "Example",
                     MB_OK | MB_SYSTEMMODAL | MB_SERVICE_NOTIFICATION );
         break;

      case DLL_THREAD_ATTACH:
         MessageBox( 0, "Hello from StoredProcedureExample1 -- in DLL_THREAD_ATTACH", "Example",
                     MB_OK | MB_SYSTEMMODAL | MB_SERVICE_NOTIFICATION );
         break;

      case DLL_THREAD_DETACH:
         MessageBox( 0, "Hello from StoredProcedureExample1 -- in DLL_THREAD_DETACH", "Example",
                     MB_OK | MB_SYSTEMMODAL | MB_SERVICE_NOTIFICATION );
         break;

      case DLL_PROCESS_DETACH:
         MessageBox( 0, "Hello from StoredProcedureExample1 -- in DLL_PROCESS_DETACH", "Example",
                     MB_OK | MB_SYSTEMMODAL | MB_SERVICE_NOTIFICATION );
         break;
      }
   return TRUE;
}


// This is an example of an exported function.
UNSIGNED32 _declspec( dllexport ) WINAPI Example1StoredProc
(
   UNSIGNED32  ulConnectionID, // (I) value used to associate a user/connection
                               //     and can be used to track the state
   UNSIGNED8   *pucUserName,   // (I) the user name who invoked this procedure
   UNSIGNED8   *pucPassword,   // (I) the user's password in encrypted form
   UNSIGNED8   *pucProcName,   // (I) the stored procedure name
   UNSIGNED32  ulRecNum,       // (I) reserved for triggers
   UNSIGNED8   *pucTable1,     // (I) table one.  For Stored Proc this table
                               //     contains all input parameters.  For
                               //     triggers, it contains the original field
                               //     values if the trigger is an OnUpdate or
                               //     OnDelete
   UNSIGNED8   *pucTable2      // (I) table two.  For Stored Proc this table
                               //     is empty and the users function will
                               //     optionally add rows to it as output.
                               //     For triggers, it contains the new field
                               //     values if the trigger is an OnUpdate or
                               //     OnInsert
)
{
   MessageBox( 0, "Hello from Example1StoredProc", "Example",
               MB_OK | MB_SYSTEMMODAL | MB_SERVICE_NOTIFICATION );

   // return a code to the user.  This code would be interpreted as an error
   return 12345;
}


