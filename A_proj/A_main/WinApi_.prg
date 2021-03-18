#include "dmlb.ch"
#include "dac.ch"
#include "dll.ch"
*
#include "directry.ch"

#include 'bap.ch'
#include "..\A_main\WinApi_.ch"


#define CSIDL_APPDATA             0x001a    && Soukromá datová oblast
#define NULL                      0


#pragma Library( "Adac20b.lib" )
#pragma Library( "AdsUtil.lib" )

#define HKEY_CLASSES_ROOT           2147483648
#define HKEY_CURRENT_USER           2147483649
#define HKEY_LOCAL_MACHINE          2147483650
#define HKEY_USERS                  2147483651

#define KEY_QUERY_VALUE         1
#define KEY_SET_VALUE           2
#define KEY_CREATE_SUB_KEY      4
#define KEY_ENUMERATE_SUB_KEYS  8
#define KEY_NOTIFY              16
#define KEY_CREATE_LINK         32


DLLFUNCTION RegOpenKeyExA(nHkeyClass, cKeyName, reserved, access, @nKeyHandle);
                USING STDCALL FROM ADVAPI32.DLL
DLLFUNCTION RegQueryValueExA(nKeyHandle, cEntry, reserved, @valueType, @cName,@nSize);
                USING STDCALL FROM ADVAPI32.DLL
DLLFUNCTION RegCloseKey( nKeyHandle );
                USING STDCALL FROM ADVAPI32.DLL


DLLFUNCTION IsZoomed(hwnd)                             USING STDCALL FROM USER32.DLL
DLLFUNCTION IsIconic(hwnd)                             USING STDCALL FROM USER32.DLL
DLLFUNCTION ShowWindow(hwnd,nCmdShow)                  USING STDCALL FROM USER32.DLL
DLLFUNCTION GetSystemMetrics(nVal)                     USING STDCALL FROM USER32.DLL
DLLFUNCTION GetCurrentProcessId()                      USING STDCALL FROM KERNEL32.DLL

DLLFUNCTION SHBrowseForFolder( lpbi )                  USING STDCALL FROM SHELL32.DLL
DLLFUNCTION SHGetPathFromIDList(pidl,@pszPath)         USING STDCALL FROM SHELL32.DLL
DLLFUNCTION CoTaskMemFree(pv)                          USING STDCALL FROM OLE32.DLL
DLLFUNCTION SendMessageA( nhwnd,nwMsg,nwParam,lParam ) USING STDCALL FROM USER32.DLL

DLLFUNCTION GetPrivateProfileStringA(ASection, AKey, ADefault, @ABuffer, ALength, AFileName) using stdcall from "kernel32.dll"

DLLFUNCTION ExtractAssociatedIconA(hInst,lpIconPath,@lpiIcon) USING STDCALL FROM SHELL32.DLL
*
** volání api, pak ale nevím co s tou ikonou ...
** nicon := ExtractAssociatedIconA(SetAppWindow():getHWND(), allTrim(cfile), 1)

DLLFUNCTION SHCreateDirectoryExA( hwnd, pszPath, psa )                       USING STDCALL FROM SHELL32.DLL
DLLFUNCTION CreateDirectoryA( lpPathName, lpSecurityAttributes )             USING STDCALL FROM KERNEL32.DLL
DLLFUNCTION OpenSCManagerA( lpMachineName, lpDatabaseName, dwDesiredAccess)  USING STDCALL FROM ADVAPI32.DLL


*
**
DLLFUNCTION GetDriveTypeA(lpRootPathName) USING STDCALL FROM KERNEL32.DLL

function GetLogicalDriveStrings()
  local  nBufferLength := 512, lpBuffer := space(1024)

  DllCall( "Kernel32", DLL_STDCALL, "GetLogicalDriveStringsA", 1024, @lpBuffer )
  lpBuffer := substr(lpBuffer,1,len(trim(lpBuffer))-1)
return lpBuffer

/*
function GetVolumeInformation(cdriveName)
  LOCAL  cRoot    := "C:\"        //-- LPCTSTR lpRootPathName,
  LOCAL  cName    := SPACE(200)   //-- LPTSTR  lpVolumeNameBuffer,
  LOCAL  iSize    := 0            //-- DWORD   nVolumeNameSize,
  LOCAL  cID      := SPACE(200)   //-- LPDWORD lpVolumeSerialNumber,
  LOCAL  cMax     := SPACE(200)   //-- LPDWORD lpMaximumComponentLength,
  LOCAL  cFlag    := SPACE(200)   //-- LPDWORD lpFileSystemFlags,
  LOCAL  cBuffer  := SPACE(200)   //-- LPTSTR  lpFileSystemNameBuffer,
  LOCAL  iFAT     := 0            //-- DWORD   nFileSystemNameSize

  iReturn := DllCall("KERNEL32.DLL", DLL_STDCALL,"GetVolumeInformationA",;
                     "C:\", @cName, @iSize, @cID, @cMax, @cFlag, @cBuffer, @iFAT)
return cID
*/

**
*


function winapi_getUserPrivatePath()
  local  szPath := space(512), appPath

  DllCall( "shell32", DLL_STDCALL, "SHGetFolderPathA", nil, CSIDL_APPDATA, nil, 0, @szPath)
  appPath := substr(szPath,1,len(trim(szPath))-1)
return appPath


function GetCurrentDirectory()
  local  dwCurDir := 512, szCurDir := space(512), curDir

  DllCall( "kernel32.dll", DLL_STDCALL, "GetCurrentDirectoryA", dwCurDir, @szCurDir )
  curDir := subStr( szCurDir, 1, len( trim( szCurDir)) -1 )
return curDir


/*
function GetFileTime()
  local cCreation := SPACE(8) ;
        cAccess   := SPACE(8) ;
        cWrite    := SPACE(8)
  local aTime     := {}

  if DllCall("kernel32.dll", DLL_STDCALL, 'GetFileTime', nH, @cCreation, @cAccess, @cWrite) # 0
    aadd( aTime, cCreation )
    aadd( aTime, cAccess   )
    aadd( aTime, cWrite    )
  endif
return aTime


FUNCTION         GetFileTime(cFile)
LOCAL cCreation := SPACE(8), cAccess := SPACE(8), cWrite := SPACE(8)
LOCAL nKernel32Dll:=DllLoad("Kernel32.dll")
LOCAL nH := FOPEN(cFile, FO_READ+FO_SHARED )
LOCAL aTime := {}

   If nKernel32Dll > 0 .AND. nH # -1
      IF DllCall(nKernel32Dll, DLL_STDCALL, 'GetFileTime', nH, @cCreation, @cAccess, @cWrite) # 0
         AADD( aTime, cCreation )
         AADD( aTime, cAccess   )
         AADD( aTime, cWrite    )
      ENDIF
      DllUnload(nKernel32Dll)
   EndIf

   IF nH # -1
      FCLOSE(nH)
   ENDIF

Return aTime

*/


FUNCTION BrowseForFolder( oWin, cTitle, nFlags, cTargetDirectory )
  LOCAL hWnd        := IIF(oWIn=NIL,SetAppWindow():getHWND(),oWin:getHWND())
  LOCAL aOFN
  LOCAL cOFN
  LOCAL ret         := ''
  LOCAL nIDL        := 0
  *
**  tady blbne èeština
**  cTitle := ConvToAnsiCP( IIF(cTitle = NIL, '', cTitle)+CHR(0) )

  cTitle := if( cTitle = NIL, '', cTitle ) +CHR(0)
  nFlags := IIF(nFlags=NIL,0,nFlags)

  cFolderName := PADR('',260,CHR(0))

  aOFN := BaInit(8)

  BaStruct(aOFN,hWnd)                                                           // hwndOwner
  BaStruct(aOFN,NULL)                                                           // pidlRoot
  BaStruct(aOFN,@cFolderName)                                                   // lpstrFolder
  BaStruct(aOFN,@cTitle)                                                        // lpstrTitel
  BaStruct(aOFN,nFlags)                                                         // nFlags
  BaStruct(aOFN,BaCallback( "BrowseCallbackProc", BA_CB_GENERIC4))              // CallBackProc
  BaStruct(aOFN,@cTargetDirectory)                                              // lParam
  BaStruct(aOFN,0)                                                              // iImage

  cOFN := BaAccess(aOFN)

  nIDL := SHBrowseForFolder(cOFN)

  IF nIDL > 0
    SHGetPathFromIDList(nIDL,@cFolderName)
    CoTaskMemFree(nIDL)
*    ret := ConvToOEMCP( subStr( cFolderName, 1, at( chr(0), cFolderName) -1 ) )
*    ret := ConvToAnsiCP( subStr( cFolderName, 1, at( chr(0), cFolderName) -1 ) )
    ret := subStr( cFolderName, 1, at( chr(0), cFolderName) -1 )
  ENDIF
RETURN(ret)


FUNCTION BrowseCallbackProc(hwnd, uMsg, lp, pData)
  IF uMsg = BFFM_INITIALIZED
    // sent immediately after initialisation and so we may set the
    // initial selection here
    // wParam = TRUE => lParam is a string and not a PIDL
    SendMessageA(hwnd, BFFM_SETSELECTION, 1, pData)
  ENDIF
RETURN 1


function QueryRegistry(nHKEYHandle, cKeyName, cEntryName)
  local cName := ""
  local nNameSize
  local nKeyHandle
  local nValueType

   nKeyHandle := 0
        /* open the registry key */
   if RegOpenKeyExA(nHKEYHandle, cKeyName,0, KEY_QUERY_VALUE, @nKeyHandle) = 0
     nValueType  := 0
     nNameSize  := 0
     /* retrieve the length of the value */
     RegQueryValueExA(nKeyHandle, cEntryName, 0, @nValueType, 0, @nNameSize)
     if nNameSize > 0
       cName := space( nNameSize-1)
       rc := RegQueryValueExA(nKeyHandle, cEntryName,0, @nValueType, @cName, @nNameSize)
     endif
     RegCloseKey( nKeyHandle)
   endif

return cName


function NetName()
  local nHKey      := HKEY_LOCAL_MACHINE
  local cKeyName   := "System\CurrentControlSet\Control\ComputerName\ComputerName"
  local cEntryName := "ComputerName"

return QueryRegistry(nHKey, cKeyName, cEntryName)
