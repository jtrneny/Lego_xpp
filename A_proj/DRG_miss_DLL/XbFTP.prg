/*
   Author: Phil Ide

   Special thanks to:
      Mike Grace for finding most of the bugs
      John Caswell for finding another bug
      John Caswell for supplying the sendCommand method to send
           arbitrary commands to the server.

*/
#include "appevent.ch"
#include "common.ch"
#include "dll.ch"
#include "directry.ch"
#include "fileio.ch"
#include "XbFTP.ch"

#ifndef CRLF
  #define CRLF Chr(13)+Chr(10)
#endif


CLASS XbFTP
   HIDDEN:
      VAR win32_find_data_FileNameOffset
      VAR hFind
      VAR pData
      VAR systemtime

      METHOD iOpen
      METHOD iClose
      METHOD win32_find_data
      METHOD fileTime
      METHOD w32_systemtime

      METHOD findFirst
      METHOD findNext
      METHOD fdata

      METHOD ftpOpenFile
      METHOD ftpCloseFile
      METHOD inetWriteFile
      METHOD inetReadFile

   PROTECTED:
      VAR connHandle
      VAR ftpHandle

   EXPORTED:
      VAR address
      VAR userid
      VAR password
      VAR port
      VAR proxy
      VAR openType
      VAR error
      VAR libdll


      METHOD init
      METHOD destroy
      METHOD open
      METHOD close

      METHOD getCurrentDirectory
      METHOD setCurrentDirectory

      METHOD createDirectory
      METHOD deleteDirectory

      METHOD deleteFile
      METHOD renameFile

      METHOD getFile
      METHOD putFile

      METHOD directory

      METHOD sendCommand(cCommand)

      SYNC METHOD sendFile
      SYNC METHOD recvFile

ENDCLASS

METHOD XbFTP:init( cAddress, cUserId, cPassword, cProxy, nPort, nOpenType )
   local i

   ::address    := cAddress
   ::userId     := cUserId
   ::password   := cPassword
   ::proxy      := cProxy
   ::port       := nPort
   ::openType   := nOpenType
   ::pData      := ::win32_find_data()
   ::systemtime := ::w32_systemtime()
   ::libdll     := "wininet.dll"
//   ::libdll     := "c:\Windows\System32\wininet.dll"


   default ::port     to 21
   default ::proxy    to ''
   default ::openType to 0

   if !(::address == NIL)
      i := at('ftp://',lower(::address))
      if i > 0
         i := 7
      else
         i := 1
      endif
      i := at(':',::address,i)
      if i > 0
         if nPort == NIL
            ::port := val(substr(::address,i+1))
         endif
         ::address := left(::address,i-1)
      endif
      if (i := at('://',::address)) > 0
         ::address := substr(::address,i+3)
      endif
   endif
   return (self)

METHOD XbFTP:iOpen()
   STATIC cTpl
   local cUserAgent := "XbFTP"
   local nProxyMode
   local nHnd
   local lRet := FALSE

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll, DLL_STDCALL,"InternetOpenA")
   endif

//   nProxyMode := 1+iif(Empty(::proxy),2,0)

   nHnd := DllExecuteCall( cTpl, cUserAgent, ::openType, ::proxy, "", 1 )
//   nHnd := DllExecuteCall( cTpl, cUserAgent, nProxyMode, ::proxy, "", 1 )
   if nHnd <> 0
      ::connHandle := nHnd
      lRet := TRUE
   else
      ::error := XBFTP_ERR_ICONN_FAIL
   endif
   return lRet

METHOD XbFTP:iClose()
   STATIC cTpl

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"InternetCloseHandle")
   endif

   DllExecuteCall( cTpl, ::connHandle )
   ::connhandle := NIL
   return (self)

METHOD XbFTP:Open( InternFlagPassive)
   STATIC cTpl
   local nHnd
   local lRet := FALSE
   local nflagPassive

   default InternFlagPassive to '0'

   nflagPassive := Val(InternFlagPassive)

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"InternetConnectA")
   endif

   if ::iOpen()
      do case
      case nflagPassive = 0
        nHnd := DllExecuteCall( cTpl, ::connHandle, ::address, ::port, ::userId, ::password, INTERNET_SERVICE_FTP, 0, 0 )

      case nflagPassive = 1
        nHnd := DllExecuteCall( cTpl, ::connHandle, ::address, ::port, ::userId, ::password, INTERNET_SERVICE_FTP, INTERNET_FLAG_PASSIVE, 0 )

      endcase

      if nHnd <> 0
         ::ftpHandle := nHnd
         lRet := TRUE
      else
         ::error := XBFTP_ERR_FTPCONN_FAIL
      endif
   endif
   return lRet

METHOD XbFTP:close(nHnd)
   STATIC cTpl
   local nIHnd

   nIHnd := nHnd
   default nIHnd to ::ftpHandle

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"InternetCloseHandle")
   endif

   DllExecuteCall( cTpl, nIHnd )
   if nHnd == NIL
      ::ftpHandle := NIL
      ::iClose()
   endif
   return (self)

METHOD XbFTP:destroy()
   if !(::ftpHandle == NIL)
      ::close()
   endif
   if !(::connHandle == NIL)
      ::iClose()
   endif
   return (self)

METHOD XbFTP:win32_find_data()
   local cRet := ''

   cRet += l2bin(0)
   cRet += ::fileTime()
   cRet += ::fileTime()
   cRet += ::fileTime()
   cRet += l2bin(0)
   cRet += l2bin(0)
   cRet += l2bin(0)
   cRet += l2bin(0)

   ::win32_find_data_FileNameOffset := len(cRet)+1

   cRet += Replicate( Chr(0), MAX_PATH )
   cRet += Replicate( Chr(0), 14 )
   return cRet

METHOD XbFTP:fileTime()
   return l2bin(0)+l2bin(0)

METHOD XbFTP:w32_systemtime()
   return replicate(chr(0),16)

METHOD XbFTP:fdata()
   STATIC cTpl
   local aFile := Array(FTP_FSTRU_MAX)
   local cCreation
   local i
   local cData
   local clpSystemTime
   local cDbg := ''


   if cTpl == NIL
      cTplA := DllprepareCall("kernel32.dll",DLL_STDCALL,"LocalFileTimeToFileTime")
      cTplB := DllprepareCall("kernel32.dll",DLL_STDCALL,"FileTimeToSystemTime")
   endif

   aFile[FTP_FSTRU_NAME]   := SubStr(::pData,::win32_find_data_FileNameOffset,MAX_PATH)
   i := at(chr(0),aFile[FTP_FSTRU_NAME])
   if i > 0
      aFile[FTP_FSTRU_NAME] := left(aFile[FTP_FSTRU_NAME],i-1)
   endif

   aFile[FTP_FSTRU_SIZE]   := bin2l(substr(::pData,33,4)+substr(::pData,29,4))
   aFile[FTP_FSTRU_ATTR]   := Bin2l(left(::pData,4))

/*
   // sort out CreationDate date
   cData := SubStr(::pData,5,8)
   clpSystemTime := ::w32_systemtime()
   DLLExecuteCall( cTplA, @cData, @clpSystemTime)
   ::systemtime := ::w32_systemtime()
   DLLExecuteCall( cTplB, @clpSystemTime, @::systemtime)
   cYear  := StrZero(bin2i(SubStr(::systemTime,1,2)),4)
   cMonth := StrZero(bin2i(SubStr(::systemTime,3,2)),2)
   cDay   := StrZero(bin2i(SubStr(::systemTime,7,2)),2)
   aFile[FTP_FSTRU_CRDATE]  := stod(cYear+cMonth+cDay)
   aFile[FTP_FSTRU_CRTIME]  := StrZero(bin2i(SubStr(::systemTime,9,2)),2)+':'+;
                           StrZero(bin2i(SubStr(::systemTime,11,2)),2)+':'+;
                           StrZero(bin2i(SubStr(::systemTime,13,2)),2)
   cDbg += ::systemTime


   // sort out LastAccessDate date
   cData := SubStr(::pData,13,8)
   clpSystemTime := ::w32_systemtime()
   DLLExecuteCall( cTplA, @cData, @clpSystemTime)
   ::systemtime := ::w32_systemtime()
   DLLExecuteCall( cTplB, @clpSystemTime, @::systemtime)
   cYear  := StrZero(bin2w(SubStr(::systemTime,1,2)),4)
   cMonth := StrZero(bin2w(SubStr(::systemTime,3,2)),2)
   cDay   := StrZero(bin2w(SubStr(::systemTime,7,2)),2)
   aFile[FTP_FSTRU_LADATE]  := stod(cYear+cMonth+cDay)
   aFile[FTP_FSTRU_LATIME]  := StrZero(bin2i(SubStr(::systemTime,9,2)),2)+':'+;
                           StrZero(bin2i(SubStr(::systemTime,11,2)),2)+':'+;
                           StrZero(bin2i(SubStr(::systemTime,13,2)),2)
   cDbg += ::systemTime
*/
   // sort out lastWrite date
   cData := SubStr(::pData,21,8)
   clpSystemTime := ::w32_systemtime()

/*
   DLLExecuteCall( cTplA, @cData, @clpSystemTime)
   ::systemtime := ::w32_systemtime()
   DLLExecuteCall( cTplB, @clpSystemTime, @::systemtime)
*/
   DLLExecuteCall( cTplB, @cData, @::systemtime)

   cYear  := StrZero(bin2i(SubStr(::systemTime,1,2)),4)
   cMonth := StrZero(bin2i(SubStr(::systemTime,3,2)),2)
   cDay   := StrZero(bin2i(SubStr(::systemTime,7,2)),2)
   aFile[FTP_FSTRU_LWDATE]  := stod(cYear+cMonth+cDay)
   aFile[FTP_FSTRU_LWTIME]  := StrZero(bin2i(SubStr(::systemTime,9,2)),2)+':'+;
                           StrZero(bin2i(SubStr(::systemTime,11,2)),2)+':'+;
                           StrZero(bin2i(SubStr(::systemTime,13,2)),2)
   return aFile

METHOD XbFTP:getCurrentDirectory()
   STATIC cTpl
   local cDir := Replicate( Chr(0), MAX_PATH )

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpGetCurrentDirectoryA")
   endif

   DllExecuteCall( cTpl, ::ftpHandle, @cDir, l2bin(MAX_PATH) )
   return (cDir)

METHOD XbFTP:setCurrentDirectory(cDirectry)
   STATIC cTpl
   local cDir := left(cDirectry + Replicate( Chr(0), MAX_PATH ), MAX_PATH )
   local lOk

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpSetCurrentDirectoryA")
   endif

   lOk := DllExecuteCall( cTpl, ::ftpHandle, cDir ) > 0
   return (lOk)

METHOD XbFTP:createDirectory(cDirectry)
   STATIC cTpl
   local lOk := FALSE

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpCreateDirectoryA")
   endif

   if !Empty(cDirectry)
      cDirectry := cDirectry+Chr(0)
      lOk := DllExecuteCall( cTpl, ::ftpHandle, cDirectry ) > 0
   endif

   return (lOk)

METHOD XbFTP:deleteDirectory(cDirectry)
   STATIC cTpl
   local lOk := FALSE

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpRemoveDirectoryA")
   endif

   if !Empty(cDirectry)
      cDirectry := cDirectry+Chr(0)
      lOk := DllExecuteCall( cTpl, ::ftpHandle, cDirectry ) > 0
   endif

   return (lOk)

METHOD XbFTP:deleteFile(cFile)
   STATIC cTpl
   local lOk := FALSE

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpDeleteFileA")
   endif

   if !Empty(cFile)
      cFile := cFile+Chr(0)
      lOk := DllExecuteCall( cTpl, ::ftpHandle, cFile ) > 0
   endif

   return (lOk)

METHOD XbFTP:renameFile(cFile, cNewName)
   STATIC cTpl
   local lOk := FALSE

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpRenameFileA")
   endif

   if !Empty(cFile) .and. !Empty(cNewName)
      cFile := cFile+Chr(0)
      cNewName := cNewName+Chr(0)

      lOk := DllExecuteCall( cTpl, ::ftpHandle, cFile, cNewName ) > 0
   endif

   return (lOk)


METHOD XbFTP:getFile(cRemoteFile, cLocalFile, lOverWrite, fAttr, nTransferMode)
   STATIC cTpl

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpGetFileA")
   endif

   if !Empty(cRemoteFile) .and. !Empty(cLocalFile)
      cRemoteFile := cRemoteFile+Chr(0)
      cLocalFile := cLocalFile+Chr(0)

      default nTransferMode to FTP_TRANSFER_TYPE_UNKNOWN,;
              fAttr to 0,;
              lOverWrite to TRUE

      lOk := DllExecuteCall( cTpl, ::ftpHandle, cRemoteFile, cLocalFile, !lOverWrite, fAttr, nTransferMode, 0 ) > 0
   endif
   return lOk

METHOD XbFTP:putFile(cLocalFile, cRemoteFile, nTransferMode)
   STATIC cTpl

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpPutFileA")
   endif

   if !Empty(cRemoteFile) .and. !Empty(cLocalFile)
      cRemoteFile := cRemoteFile+Chr(0)
      cLocalFile := cLocalFile+Chr(0)

      default nTransferMode to FTP_TRANSFER_TYPE_UNKNOWN

      lOk := DllExecuteCall( cTpl, ::ftpHandle, cLocalFile, cRemoteFile, nTransferMode, 0 ) > 0
   endif
   return lOk


METHOD XbFTP:findFirst(cSpec)
   STATIC cTpl

   default cSpec to "*.*"

   if !Right(cSpec,1) == Chr(0)
      cSpec += Chr(0)
   endif

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpFindFirstFileA")
   endif
   ::pData := ::win32_find_data()
   ::hFind := DLLExecuteCall( cTpl, ::ftpHandle, cSpec, @::pData, 0, 0 )
   return ::hFind <> 0

METHOD XbFTP:findNext()
   STATIC cTpl
   local nOk := 0

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"InternetFindNextFileA")
   endif

   ::pData := ::win32_find_data()
   nOk := DLLExecuteCall( cTpl, ::hFind, @::pData )
   return nOk <> 0

METHOD XbFTP:directory(lSorted, cSpec)
   local aFList := {}

   default lSorted to TRUE,;
           cSpec to "*.*"

   if ::findFirst(cSpec)
      aadd(aFList, ::fdata())
      while ::findNext()
         aadd(aFList, ::fdata())
      enddo
      ::close(::hFind)
      if lSorted
         ASort(aFList,,, {|a,b| iif( a[3] == b[3], a[1] < b[1], a[3] < b[3] ) })
      endif
   endif
   return aFList

METHOD XbFTP:sendCommand(cCommand)
   STATIC cTpl
   local lOk := FALSE
   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpCommandA")
   endif
   if !Empty(cCommand)
      cCommand := cCommand+Chr(0)
      lOk := DllExecuteCall( cTpl, ::ftpHandle, FALSE, FTP_TRANSFER_TYPE_ASCII, cCommand, 0 ) > 0
   endif
   return (lOk)

//////////////////////////////////////////////////////////////
// upload a file to a remote location.
// returns status information during upload
// process through the callback function.
//
// Callback receives these values:
//    lStatus       - TRUE if OK
//                    FALSE on error (operation aborted)
//    nPacketSent   - Number of bytes just sent
//    nTotalSent    - Total number of bytes transmitted
//    nPercent      - Percentage completed
//    nCurTransRate - Transfer rate of last packet
//    nOvrTransRate - Overall (avergae) Transfer Rate
//    nCurETA       - ETA at current transfer rate as Time() string
//    nTotETA       - ETA at average transfer rate as Time() string
//    lFinished     - Process has terminated (see lStatus for error code)
//
// The callback function can interrupt file transfer
// by issuing a Break() or BREAK call.
//
// Example callback function:
//
//METHOD myStatusDialog:txCallBack( a )
//   do case
//      // if the upload has terminated...
//      case a.Finished
//         if a.Status == FTRANS_FILE_FAIL_NONE
//            msgBox("Ok")
//         elseif a.Status == FTRANS_FILE_FAIL_ABORT
//            msgBox("Aborted by User/Application")
//         else
//            msgBox("Upload Error")
//         endif
//
//      // no errors, transfer still in progress
//      case a.Status == FTRANS_FILE_FAIL_NONE
//         // display results
//         ::UpdateStatusDisplay(a)
//
//      // an error has ocurred
//      otherwise
//         do case
//            case IsLocalFile(a) .and. a.ReTry > 2 // abort after 3 tries
//               break()
//
//            case IsRemoteFile(a) // allow max retries but display errors
//               ::UpdateStatusDisplay(a)
//
//         endcase
//   endcase
//   return Nil
//
// For best results, the FTP routines and callback should be
// in different threads, and the callback in GUI applications is
// best delivered as a method of a dialog displaying status info.
//
// Example call:
//
//  oFtp:sendFile( "read.me", "read.me", {|a| oDlg:txCallback(a) } )
//
// If the FTP routines and display window are in different threads,
// you can install the window as the callback routine by passing the
// callback routine like this:
//
//  oFtp:sendFile( "read.me", "read.me", {|a| PostAppEvent(xbeP_XbFtp_Event, a, NIL, oDlg) } )
//
// This will cause the xbeP_XbFtp_Event event to be posted to the window, irrespective of
// which thread it is in.
// This would be handled by the thread's event loop in the normal way, and the window need
// only have an overloaded event handler:
//
// METHOD myDialog:handleEvent( nEvent, mp1, mp2 )
//    if nEvent == xbeP_XbFtp_Event
//       ::updateStatus(mp1)
//    else
//       ::XbpDialog:handleEvent( nEvent, mp1, mp2 )
//    endif
//    return self
//
METHOD XbFTP:sendFile( cLocalFile, cRemoteFile, bCallBack, nReTries )
   local nIn  := FOpen( cLocalFile, FO_READ )
   local nOut
   local cBuff
   local nEnd
   local nRead
   local nRemRead := 0
   local oXbp
   local iSecs

   // timers
   local nTotTime
   local nCurTime

   local aDbg := Array(6)

   STRUCTURE _StructCallBack aCB

   DEFAULT nReTries TO 3

   if Valtype(bCallBack) == 'O' .and. bCallBack:isDerivedFrom('XbpPartHandler')
      oXbp := bCallBack
      bCallBack := {|a| PostAppEvent( xbeP_XbFtp, a, NIL, oXbp ) }
   endif

   aCB.Status        := FTRANS_FILE_FAIL_GENERIC
   aCB.PacketSent    := 0
   aCB.TotalSent     := 0
   aCB.Percent       := 0.00
   aCB.CurTransRate  := 0
   aCB.CurETA        := Secs2Time(0)
   aCB.TotETA        := Secs2Time(0)
   aCB.ReTry         := 0
   aCB.Finished      := TRUE

   if nIn == 0
      aCB.Status := FTRANS_FILE_LOCAL + FTRANS_FILE_FAIL_OPEN
   else
      nOut := ::ftpOpenFile( cRemoteFile, GENERIC_WRITE )
      if nOut == 0
         aCB.Status := FTRANS_FILE_REMOTE + FTRANS_FILE_FAIL_CREATE
      else
         aCB.Status   := FTRANS_FILE_FAIL_NONE
         aCB.Finished := FALSE

         BEGIN SEQUENCE

            CALLBACK bCallBack WITH aCB

            nEnd := FetchFileSize(nIn)

            nTotTime := Seconds()

            While FilePos(nOut) <= nEnd
               nCurTime := Seconds()

               cBuff := Space(FTRANS_BUFF_SIZE)

               // READ local
               aCB.ReTry := 0
               While aCB.ReTry < nReTries
                  if (nRead := FRead( nIn, @cBuff, FTRANS_BUFF_SIZE )) == 0
                     aCB.ReTry++
                     aCB.Status := FTRANS_FILE_LOCAL + FTRANS_FILE_FAIL_READ
                     CALLBACK bCallBack WITH aCB
                     sleep(10)
                  else
                     aCB.ReTry := 0
                     aCB.Status := FTRANS_FILE_FAIL_NONE
                     EXIT
                  endif
               Enddo
               if aCB.Status <> FTRANS_FILE_FAIL_NONE
                  EXIT
               endif

               // WRITE remote
               aCB.ReTry := 0
               While aCB.ReTry < nReTries
                  iSecs := Seconds()
                  if !::inetWriteFile( nOut, cBuff, nRead, @nRemRead )
                     aCB.ReTry++
                     aCB.Status := FTRANS_FILE_REMOTE + FTRANS_FILE_FAIL_WRITE
                     CALLBACK bCallBack WITH aCB
                     sleep(10)
                  else

                     aCB.ReTry := 0
                     aCB.Status       := FTRANS_FILE_FAIL_NONE
                     aCB.PacketSent   := nRemRead
                     aCB.TotalSent    += nRemRead
                     aCB.Percent      := aCB.TotalSent/(nEnd/100)
                     aCB.CurTransRate := (aCB.TotalSent)/(Seconds()-iSecs) // Kb/s
                     aCB.OvrTransRate := (aCB.TotalSent)/(Seconds()-nTotTime) // Kb/s
                     aCB.CurETA       := Secs2Time((nEnd - aCB.TotalSent)/(aCB.CurTransRate))
                     aCB.TotETA       := Secs2Time((nEnd - aCB.TotalSent)/(aCB.OvrTransRate))

                     CALLBACK bCallBack WITH aCB
                     EXIT
                  Endif
               Enddo
            Enddo
         RECOVER
            aCB.Status := FTRANS_FILE_FAIL_ABORT

         END SEQUENCE
         ::ftpCloseFile(nOut)

         aCB.Finished := TRUE
         CALLBACK bCallBack WITH aCB
      endif
      FClose(nIn)
   endif
   return self

METHOD XbFTP:recvFile( cRemoteFile, cLocalFile, bCallBack, nRetries )
   local nIn  := FCreate( cLocalFile )
   local nOut
   local cBuff
   local nEnd
   local nRead
   local nRemRead := 0
   local oXbp
   local i
   local a := ::directory(FALSE,cRemoteFile)
   local iSecs

   // timers
   local nTotTime
   local nCurTime

   STRUCTURE _StructCallBack aCB

   DEFAULT nReTries TO 3

   if Valtype(bCallBack) == 'O' .and. bCallBack:isDerivedFrom('XbpPartHandler')
      oXbp := bCallBack
      bCallBack := {|a| PostAppEvent( xbeP_XbFtp, a, NIL, oXbp ) }
   endif

   aCB.Status        := FTRANS_FILE_FAIL_GENERIC
   aCB.PacketSent    := 0
   aCB.TotalSent     := 0
   aCB.Percent       := 0.00
   aCB.CurTransRate  := 0
   aCB.CurETA        := Secs2Time(0)
   aCB.TotETA        := Secs2Time(0)
   aCB.ReTry         := 0
   aCB.Finished      := TRUE

   if nIn == 0
      aCB.Status := FTRANS_FILE_LOCAL + FTRANS_FILE_FAIL_OPEN
   else
      nOut := ::ftpOpenFile( cRemoteFile, GENERIC_READ )
      if nOut == 0
         aCB.Status := FTRANS_FILE_REMOTE + FTRANS_FILE_FAIL_CREATE
      else
         aCB.Status   := FTRANS_FILE_FAIL_NONE
         aCB.Finished := FALSE

         BEGIN SEQUENCE

            CALLBACK bCallBack WITH aCB

            nEnd := a[1][FTP_FSTRU_SIZE]

            nTotTime := Seconds()

            While aCB.TotalSent < nEnd
               nCurTime := Seconds()

               cBuff := Space(FTRANS_BUFF_SIZE)

               // READ local
               aCB.ReTry := 0
               While aCB.ReTry < nReTries
                  if !::inetReadFile( nOut, @cBuff, FTRANS_BUFF_SIZE, @nRemRead )
                     aCB.ReTry++
                     aCB.Status := FTRANS_FILE_REMOTE + FTRANS_FILE_FAIL_READ
                     CALLBACK bCallBack WITH aCB
                     sleep(10)
                  else
                     aCB.ReTry := 0
                     aCB.Status := FTRANS_FILE_FAIL_NONE
                     EXIT
                  endif
               Enddo
               if aCB.Status <> FTRANS_FILE_FAIL_NONE
                  EXIT
               endif

               // WRITE local
               aCB.ReTry := 0
               While aCB.ReTry < nReTries
                  iSecs := Seconds()
                  if (i := FWrite( nIn, cBuff, nRemRead )) < nRemRead
                     // rewind
                     FSeek( nOut, FS_RELATIVE, i )
                     aCB.ReTry++
                     aCB.Status := FTRANS_FILE_LOCAL + FTRANS_FILE_FAIL_WRITE
                     CALLBACK bCallBack WITH aCB
                     sleep(10)
                  else
                     aCB.ReTry := 0
                     aCB.Status       := FTRANS_FILE_FAIL_NONE
                     aCB.PacketSent   := nRemRead
                     aCB.TotalSent    += nRemRead
                     aCB.Percent      := aCB.TotalSent/(nEnd/100)
                     aCB.CurTransRate := (aCB.TotalSent)/(Seconds()-iSecs) // Kb/s
                     aCB.OvrTransRate := (aCB.TotalSent)/(Seconds()-nTotTime) // Kb/s
                     aCB.CurETA       := Secs2Time((nEnd - aCB.TotalSent)/(aCB.CurTransRate))
                     aCB.TotETA       := Secs2Time((nEnd - aCB.TotalSent)/(aCB.OvrTransRate))

                     CALLBACK bCallBack WITH aCB
                     EXIT
                  Endif
               Enddo
            Enddo
         RECOVER
            aCB.Status := FTRANS_FILE_FAIL_ABORT

         END SEQUENCE
         ::ftpCloseFile(nOut)

         aCB.Finished := TRUE
         CALLBACK bCallBack WITH aCB
      endif
      FClose(nIn)
   endif
   return self

METHOD XbFtp:ftpOpenFile( cFile, nMode )
   STATIC cTpl
   local nHnd := 0

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"FtpOpenFileA")
   endif
   nHnd := DllExecuteCall( cTpl, ::ftpHandle, cFile, nMode, FTP_TRANSFER_TYPE_BINARY,  0 )
   return (nHnd)

METHOD XbFtp:ftpCloseFile( nHnd )
   return ::close(nHnd)

METHOD XbFtp:inetWriteFile( nOut, cBuff, nRead, nRemRead )
   STATIC cTpl
   local lOk := FALSE

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"InternetWriteFile")
   endif
   lOk := DllExecuteCall( cTpl, nOut, cBuff, nRead, @nRemRead ) > 0
   return (lOk)

METHOD XbFtp:inetReadFile( nOut, cBuff, nRead, nRemRead )
   STATIC cTpl
   local lOk := FALSE

   if cTpl == NIL
      cTpl := DllprepareCall(::libdll,DLL_STDCALL,"InternetReadFile")
   endif
   lOk := DllExecuteCall( cTpl, nOut, @cBuff, nRead, @nRemRead ) > 0
   return (lOk)



STATIC Function Secs2Time(n)
   local nHrs
   local nMins
   local nSecs

   nHrs  := Int(n / 3600) ;   n -= (nHrs*3600)
   nMins := Int(n / 60)   ;   n -= (nMins*60)
   nSecs := Int(n)

   return StrZero(nHrs,2)+':'+StrZero(nMins,2)+':'+StrZero(nSecs,2)