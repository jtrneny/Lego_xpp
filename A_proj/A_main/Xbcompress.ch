/*****************************
* Source : XbZ_Zip.ch
* System : <unkown>
* Author : Andreas Gehrs-Pahl
* Created: 12/22/2004
*
* Purpose: Header File for Programs that use the XbZLibZip Class from XbZLib.dll
* ----------------------------
* History:
* ----------------------------
*    12/22/2004       AGP - Created
*    06/15/2005       AGP - Updated length of XBZ_NEXT_LOG_LINE define constant for Version 1.4 LogWriter Class
*    08/04/2005       AGP - Added XBZ_USER_ABORT define constant (as a pseudo Error Code)
*****************************/

#ifndef __XBZ_ZIP__

#define __XBZ_ZIP__

************************************************************************
* Open Mode Defines for :New()/:Open() Methods ==> saved in :nOpenMode *
************************************************************************
#define XBZ_OPEN_FAILED			 0	// No Zip File Open
#define XBZ_OPEN_CREATE			 1	// Create (Created) New Zip File (and Delete Existing)
#define XBZ_OPEN_UPDATE			 2	// Open (Opened) Existing Zip File for Updates (if Existing)
#define XBZ_OPEN_READ			 3	// Open (Opened) for Read-Only Access (if Existing)
#define XBZ_OPEN_TEST			 4	// Open (Opened) for Test-Only (and Read-Only) Access (if Existing)

************************************************************************
* Status Code Defines for :Test()/:Fix() Methods ==> saved in :nStatus *
************************************************************************
#define XBZ_FILE_OK			 0	// All Entries in Zip File are OK
#define XBZ_FILE_NO_DIR			 1	// No Central Directory Found
#define XBZ_FILE_NO_ENTRIES		 2	// No Entries found in Zip File
#define XBZ_FILE_CORRUPT		 3	// Corrupt Entries found in Zip File

***************************************************************************
* Status/Error/Corruption Codes for individual (File) Entries in Zip File *
* Returned by :TestEntry()/:FixEntry() Methods ==> saved in :aFStatus     *
***************************************************************************
#define XBZ_ENTRY_OK			 0	// Local Record and Data are OK
#define XBZ_CRC_WRONG			 1	// CRC of Data is wrong
#define XBZ_NO_CDREC			 2	// Could not Find Central Directory Record
#define XBZ_NO_LFDREC			 3	// Could not Find Local File Record (and Data)
#define XBZ_VER_DIFF			 4	// Version Flag of Local and Central Header are different
#define XBZ_GPFLAG_DIFF			 5	// GPFlag of Local and Central Header are different
#define XBZ_METHOD_DIFF			 6	// Compression Method of Local and Central Header are different
#define XBZ_FTIME_DIFF			 7	// File Time of Local and Central Header are different
#define XBZ_CRC_DIFF			 8	// CRC of Local and Central Header are different
#define XBZ_CSIZE_DIFF			 9	// Compressed-Size of Local and Central Header are different
#define XBZ_OSIZE_DIFF			10	// Original (Un-Compressed)-Size of Local and Central Header are different
#define XBZ_FNLEN_DIFF			11	// File Name Length of Local and Central Header are different
#define XBZ_FNAME_DIFF			12	// File Name of Local and Central Header are different

#define XBZ_MAX_ERROR_CODES		12	// Number of different Error Codes Supported for Zip File Entries

*************************************************************
* Cance/Quit Defines for :AddDir() and :CancelAdd() Methods *
*************************************************************
#define XBZ_DONT_QUIT			 0	// Don't Quit Adding of Files
#define XBZ_QUIT_CURRENT		 1	// Quit Adding Files of current Directory (Level)
#define XBZ_QUIT_ALL			 2	// Quit Adding Files completely

**************************************************************
* Overwrite Defines for :Extract() and :ExtractAll() Methods *
**************************************************************
#define XBZ_OVERWRITE_NEVER		 0	// Never overwrite/replace existing Files.
#define XBZ_OVERWRITE_OLDER		 1	// Overwrite/replace only Older Files.
#define XBZ_OVERWRITE_ALL		 2	// Always overwrite/replace existing Files.

*****************************************************************************
* Defines for Compression Ratios (2, 3, 4, 5, 6, 7, and 8 are also allowed) *
* Can also be set in :New() and :Open() Methods ==> saved in :Compression   *
* The original ZLib Defines were prefixed only with "Z_" instead of "XBZ_"  *
*****************************************************************************
#define XBZ_DEFAULT_COMPRESSION		 -1	// Default Compression (equivalent to about 6)
#define XBZ_NO_COMPRESSION		  0	// No Compression (Store)
#define XBZ_BEST_SPEED			  1	// Best Speed, Lowest Compression
#define XBZ_BEST_COMPRESSION		  9	// Best Compression, Slowest Speed

*********************************************************************
* Compression Method Defines (only Store and Deflate are supported) *
*********************************************************************
#define XBZ_COMP_STORE			 0	// Stored (no compression)
#define XBZ_COMP_SHRUNK			 1	// Shrunk (not supported)
#define XBZ_COMP_REDUCED1		 2	// Reduced with Compression Factor 1 (not supported)
#define XBZ_COMP_REDUCED2		 3	// Reduced with Compression Factor 2 (not supported)
#define XBZ_COMP_REDUCED3		 4	// Reduced with Compression Factor 3 (not supported)
#define XBZ_COMP_REDUCED4		 5	// Reduced with Compression Factor 4 (not supported)
#define XBZ_COMP_IMPLODED		 6	// Imploded (not supported)
#define XBZ_COMP_TOKENIZED		 7	// Reserved for Tokenized (not supported)
#define XBZ_COMP_DEFLATED		 8	// Deflated
#define XBZ_COMP_DEFLATE64		 9	// Enhanced Deflate64(tm) Deflated (not supported)
#define XBZ_COMP_PKDCL			10	// PKWare Data Compression Library Imploding (not supported)

#define XBZ_COMP_TEXT			{"Stored",;
					 "Shrunk",;
					 "Reduced1",;
					 "Reduced2",;
					 "Reduced3",;
					 "Reduced4",;
					 "Imploded",;
					 "Tokenized",;
					 "Deflated",;
					 "Deflate64",;
					 "PKWare DCL"}

****************************************************************************
* Error Codes for ZLib Compress(), Compress2(), and UnCompress() Functions *
* The original ZLib Defines were prefixed only with "Z_" instead of "XBZ_" *
****************************************************************************
#define XBZ_OK				  0	// No Error: Successfull
#define XBZ_STREAM_END			  1	// No Error: Stream Ended
#define XBZ_NEED_DICT			  2	// No Error: Dictionary required
#define XBZ_ERRNO			(-1)	// Error: Non-ZLib (OS) Error was raised
#define XBZ_STREAM_ERROR		(-2)	// Error: Compression Level Parameter invalid
#define XBZ_DATA_ERROR			(-3)	// Error: Input Data corrupted
#define XBZ_MEM_ERROR			(-4)	// Error: Not enough Memory to complete operation
#define XBZ_BUF_ERROR			(-5)	// Error: Output Buffer too small
#define XBZ_VERSION_ERROR		(-6)	// Error: ZLib Version does not match

**********************************************************************
* The following is not a real Error Code, but can be used in calling *
* programs to indicate that the process didn't conclude normally     *
**********************************************************************
#define XBZ_USER_ABORT			(-9)	// User Aborted Operation

********************
* Log File Defines *
********************
#define XBZ_NEXT_LOG_LINE		chr(13) + chr(10) + Space(24)	// Offset for Date/Time Stamp

*************************
* Some Pseudo Functions *
*************************
#xtranslate OClone(<o>) => Bin2Var(Var2Bin(<o>))

#endif		// __XBZ_ZIP__


#ifndef __DLLFUNCTION_EXTENSION__
   #define __DLLFUNCTION_EXTENSION__

   // The enhanced DLLFUNCTION command allows you to give
   // an external function any name you like.
   // e.g. you can call a function named "Fred" as "Harry":
   // DLLFUNCTION ShellExec(hWnd,cOp,cFile,cParms,cDir,nShowCmd) ;
   //             ALIAS ShellExecuteA USING STDCALL FROM Shell32.dll
   //
   // Then in your code:
   //    ShellExec(hWnd,"print","mydoc.doc",NIL,CurDir(),SW_HIDE)
   //    /* calls Shell32.dll:ShellExecuteA() */
   //
   // Also, you can attach an expression to the call, which is evaluated
   // against the return value.  This will force a logical value to
   // be returned.  As an example:
   //
   // DLLFUNCTION Harry(nParm) ALIAS Fred USING STDCALL
   //      FROM MyDll.dll RESULT == 4
   //
   // The expression is evaluated replacing RESULT with the return value
   // of the call.  Note that you cannot modify the RESULT value in the
   // expression (that is, you can supply the operand and the rval only).
   // for example, this is illegal:
   //
   //     .... LTrim(RESULT) == "Fred"
   //
   // To perform this test you would have to do this:
   //     .... RESULT == 
   //
   // An extension of this is the AS BOOL keyphrase:
   // DLLFUNCTION Harry(nParm) ALIAS Fred USING STDCALL FROM MyDll.dll AS BOOL
   //
   // This forces a return value of TRUE if the result is non-zero.
   //
   // Note also that this extended version of the command does not unload
   // the DLL, and creates a calling template on first use.  This optimises
   // subsequent calls.
   //
   // If you need to force an unload of the dll, just call DllUnload() as
   // normal.

   // DLLFUNCTION command enhanced
   #command  DLLFUNCTION <Func>([<x,...>]) ALIAS <cAlias>;
                   USING <sys:CDECL,OSAPI,STDCALL,SYSTEM> ;
                    FROM <(Dll)> AS BOOL ;
          => ;
             DLLFUNCTION <Func>([<x>]) ALIAS <cAlias> ;
                   USING <sys> ;
                    FROM <(Dll)> RESULT <> 0


   #command  DLLFUNCTION <Func>([<x,...>]) ALIAS <cAlias>;
                   USING <sys:CDECL,OSAPI,STDCALL,SYSTEM> ;
                    FROM <(Dll)> [RESULT <*c2bExpr*>] ;
          => ;
                FUNCTION <Func>([<x>]);;
                   static cTpl;;
                   static bExpr := {|x| x};;
                   LOCAL nDll:=DllLoad(<(Dll)>);;
                   local xRet;;
                   if cTpl == NIL;;
                      cTpl := DllprepareCall(<(Dll)>,__Sys(<sys>),<(cAlias)>);;
                     [bExpr := {|x| x <c2bExpr>}];;
                   endif;;
                   xRet := DLLExecuteCall( cTpl [,<x>] );;
                   RETURN EVal(bExpr,xRet)



   #command  DLLFUNCTION <Func>([<x,...>]) ALIAS <cAlias>;
                   USING <sys:CDECL,OSAPI,STDCALL,SYSTEM> ;
                    FROM <(Dll)> ;
          => ;
                FUNCTION <Func>([<x>]);;
                   STATIC cTpl;;
                   LOCAL nDll:=DllLoad(<(Dll)>);;
                   LOCAL xRet;;
                   if cTpl == NIL;;
                      cTpl := DllprepareCall(<(Dll)>,__Sys(<sys>),<(cAlias)>);;
                   endif;;
                   xRet := DLLExecuteCall( cTpl [,<x>] );;
                   RETURN xRet

   // the 'standard' Xbase++ version (optimised)
   #command  DLLFUNCTION <Func>([<x,...>]);
                   USING <sys:CDECL,OSAPI,STDCALL,SYSTEM> ;
                    FROM <(Dll)> ;
          => ;
                FUNCTION <Func>([<x>]);;
                   STATIC cTpl;;
                   LOCAL nDll:=DllLoad(<(Dll)>);;
                   LOCAL xRet;;
                   if cTpl == NIL;;
                      cTpl := DllprepareCall(<(Dll)>,__Sys(<sys>),<(Func)>);;
                   endif;;
                   xRet := DLLExecuteCall( cTpl [,<x>] );;
                   RETURN xRet

#endif
