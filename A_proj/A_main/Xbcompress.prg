#include "Common.ch"
#include "Xbp.ch"
#include "Drg.ch"
#INCLUDE 'DRGRES.ch'
#INCLUDE 'DBSTRUCT.ch'
#include "AppEvent.ch"
#include "Directry.ch"
#include "Xbcompress.ch"
#include "DLL.ch"
#include 'FileIO.ch'
#include "Set.ch"
#include "Inkey.ch"

*****************************************************************
* Funkce realizuje volání procedur na kompresi a dekompresi souborù vèetnì in
* Parametry:
* cMode    - pole filtru pro výbìr souborù napø. {{"DBF Files","*.DBF"},{"ADT Files","*.ADT"}}
*            hodnota mùže být i EMPTY
* cZipFile
* cFileSpec
* cDir
* cSubDir
* cReplace
* Návratová hodnota:
* NIL
****************************************************************

Procedure CompresFile(cMode, cZipFile, cFileSpec, cDir, cSubDir, cReplace)
local  cOpt   := if(cMode    == NIL, ''  ,alltrim(upper(cMode)))
local  cArc   := if(cZipFile == NIL, cOpt, cZipFile)
local  cPath  := if(cDir     == NIL, ".\", cDir)
local  nLevel := if(cSubDir  == NIL, XBZ_DEFAULT_COMPRESSION, val(cSubDir))
local  lSubs  := if(cSubDir  == NIL, .f. , upper(cSubDir)  == 'Y')
local  lRepl  := if(cReplace == NIL, .f. , upper(cReplace) == 'Y')

  if left(cOpt, 1) # '-' .and. left(cOpt, 1) # '/' .or. len(cOpt) < 2
    cOpt := '-L'
  endif
  if cArc == cOpt
    cArc := ''
  endif
  if .not. empty(cArc) .and. lower(right(cArc, 4)) # '.zip'
    if( at( '.', cArc) = 0, cArc += '.zip', nil )
  endif

  do case
  case empty(cArc)    ;  Help()
  case cOpt[2] == 'A' ;  CreateArchive(cArc, cFileSpec, cPath, lSubs, lRepl)
  case cOpt[2] == 'C' ;  SetArchiveComment(cArc, cFileSpec)
  case cOpt[2] == 'D' ;  DeleteFromArchive(cArc, cFileSpec)
  case cOpt[2] == 'E' ;  ExtractArchive(cArc, cFileSpec, cPath, lSubs, cReplace)
  case cOpt[2] == 'F' ;  TestAndFixArchive(cArc)
  case cOpt[2] == 'I' ;  InMemoryCompress(cZipFile)
  case cOpt[2] == 'L' ;  ReadAndShowArchive(cArc, cFileSpec)
  case cOpt[2] == 'T' ;  TestAndShowArchive(cArc)
  case cOpt[2] == 'X' ;  TestArchiveCompression(cArc, cFileSpec, cPath, nLevel)
  otherwise           ;  Help()
  endcase

return


*****************************************************************
* Funkce realizuje nabídku pro výbìr souborù
* Parametry:
* cMode    - pole filtru pro výbìr souborù napø. {{"DBF Files","*.DBF"},{"ADT Files","*.ADT"}}
*            hodnota mùže být i EMPTY
* cZipFile
* cFileSpec
* cDir
* cSubDir
* cReplace
* Návratová hodnota:
* NIL
****************************************************************

Procedure Help()
local  lDone := .f.
local  nPage := 1
local  nKey  := ''

  while .not. lDone
    HelpPages(nPage)
    nKey := Inkey(0)
    do case
    case nKey == asc('1') .or. nKey == K_HOME
      nPage := 1
    case nKey == asc('2')
      nPage := 2
    case nKey == asc('3') .or. nKey == K_END
      nPage := 3
    case nKey == K_SPACE  .or. nKey == K_PGDN .or. nKey == K_DOWN .or. nKey == K_RIGHT .or. nKey == K_ENTER
      lDone := ++nPage > 3
    case nKey == K_BS     .or. nKey == K_PGUP .or. nKey == K_UP   .or. nKey == K_LEFT
      --nPage ; nPage := max(1, nPage)
    case nKey == K_ESC
      lDone := .t.
    endcase
  enddo

return

Procedure HelpPages(nPage)
static  nLastPage := 0

  if nPage # nLastPage
    nLastPage := nPage
    cls
    ? 'XbZLib Version V ' + XbZ_Version() + ' -- ZLib Version V ' + XbZ_ZLibVersion()
    ? 'Usage: TestZLib [-option] cArchive [cFileSpec] [cDir] [Y] [Y]'
    ?
    if nPage == 1
      ? ' Options (Page 1):'
      ? '   -a => Add files and directories to (or update in) .zip archive'
      ? '       TestZLib -a <ArchiveName> [<FileSpec>] [<Directory>] [Y] [Y]'
      ? '         TestZLib -a myArchive *.d?? ..\data Y Y'
      ? '           add all "*.d??" files in directory "..\data" to "myArchive.zip"'
      ? '           (the 1st "Y" means: include also sub-directories, default is "N"o)'
      ? '           (the 2nd "Y" means: save full path in file comment, default is "N"o)'
      ? '           (the zip file will be created, if it does not exist)'
      ?
      ? '   -e => Extract files and directories from .zip archive'
      ? '       TestZLib -e <ArchiveName> [<FileSpec>] [<Directory>] [Y] [X]'
      ? '         TestZLib -e myArchive *.p?? D:\Unzip Y Y'
      ? '           extract all "*.p??" files from "myArchive.zip" into "D:\Unzip\"'
      ? '           (the 1st "Y" means: create all directories, default is "N"o)'
      ? '           (the 2nd "X" means: replace "N"ever, "O"lder (default), "A"ll)'
      ?
      ? '   -d => Delete files and directories from .zip archive'
      ? '       TestZLib -d <ArchiveName> [<FileSpec>]'
      ? '         TestZLib -d myArchive x*.ppo'
      ? '           delete all "x*.ppo" files from "myArchive.zip"'
      ?
      ? 'Next: 2/Space/Enter/Down/Right, Last: 3, End: ESC.'
    elseif nPage == 2
      ? ' Options (Page 2):'
      ? '   -l => List or display contents of .zip archive'
      ? '       TestZLib -l <ArchiveName> [<FileSpec>]'
      ? '         TestZLib -l myArchive *.prg'
      ? '           list all "*.prg" files of "myArchive.zip" in a Browse table'
      ?
      ? '   -t => Test complete .zip archive and display results'
      ? '       TestZLib -t <ArchiveName>'
      ? '         TestZLib -t myArchive'
      ? '           open "myArchive.zip", test it, and show files in a Browse table'
      ?
      ? '   -f => Test and Fix complete .zip archive and display results'
      ? '       TestZLib -f <ArchiveName>'
      ? '         TestZLib -f myArchive'
      ? '           open "myArchive.zip", test and fix it, then show files in table'
      ?
      ? '   -c => Change/Set global zip file Comment of .zip archive'
      ? '       TestZLib -c <ArchiveName> [<Comment>]'
      ? '         TestZLib -c myArchive "This is a marvelous Zip File!"'
      ? '           change the Zip File Comment of "myArchive.zip" to the given text'
      ?
      ? 'Prev: 1/BS/Up/Left, Next: 3/Space/Enter/Down/Right, End: ESC.'
    else
      ? ' Options (Page 3):'
      ? '   -i => In-memory compression of a file to a .cpx file'
      ? '       TestZLib 1 <File>'
      ? '         outputs <cFile> to <cFile.cpx>'
      ?
      ? '   -x => Compress files with levels 1 through 9 to .zip archive'
      ? '       TestZLib -x <ArchiveName> [<FileSpec>] [<Directory>] [N]'
      ? '         TestZLib -x myArchive *.d?? ..\data 3'
      ? '           compress all "*.d??" files with Level 3 to "myArchive.zip"'
      ? '           (the "N" determines the Compression Level 1 - 9: default is 6'
      ? '           (the zip file will be created, if it does not exist)'
      ?
      ?
      ?
      ?
      ?
      ?
      ?
      ?
      ?
      ?
      ? 'First: 1, Prev: 2/BS/Up/Left, End: Space/Enter/Down/Right/ESC.'
    endif
  endif
return

Procedure InMemoryCompress(cFile)
local  nError    := 0
local  nHandle   := 0
local  nFNameLen := RAt('.', cFile)
local  cOriginal := XbZ_FileRead(cFile, @nError)
local  cCompress := XbZ_Compress(@cOriginal, @nError)

  if nFNameLen > 0 .and. nFNameLen > RAt('\', cFile)
    cFile := left(cFile, nFNameLen - 1)
  endif
  cFile += '.cpx'
  if (nHandle := FCreate(cFile)) > 0
    FWrite(nHandle, cCompress)
    FClose(nHandle)
  endif
return


Procedure CreateArchive(cArc, cFSpec, cDir, lSubD, lNote)
local  oDlg := XbpDialog():New():Create(AppDeskTop(), SetAppWindow(), {100, 100}, {500, 400})
local  oXbp := XbpTreeView():New():Create(oDlg:DrawingArea,         , {010, 010}, {480, 350})
local  oZip := XbZLibZip():New()
local  lOK  := .f.

  oDlg:DrawingArea:Resize := {|aOldSize, aNewSize, obj| oXbp:SetSize({aNewSize[1] - 20, aNewSize[2] - 20})}
  oZip:Log:Open(left(cArc, At('.zip', lower(cArc))) + 'log')
  oZip:SetDisplayObject(oXbp)
  oZip:Open(cArc)
  oZip:AddDir(cFSpec, cDir, , lSubD, , lNote)
*        cArc += lSubD                                        // Un-Remark to Create a corrupted Zip File for Testing!
  oZip:Save('This is an archive comment')
  oZip:Log:Close()
  lOk := DisplayList(oZip)
  oZip:Close() ; oXbp:Hide() ; oXbp:Destroy() ; oDlg:Destroy()
  if( .not. lOk, FErase(cArc), nil)

return


Procedure TestArchiveCompression(cArc, cFSpec, cDir, nLevel)
local  oDlg := XbpDialog():New():Create(AppDeskTop(), SetAppWindow(), {100, 100}, {500, 400})
local  oXbp := XbpTreeView():New():Create(oDlg:DrawingArea,         , {010, 010}, {480, 350})
local  oZip := XbZLibZip():New()
local  nCR  := if(nLevel > XBZ_NO_COMPRESSION .and. nLevel <= XBZ_BEST_COMPRESSION, nLevel, XBZ_DEFAULT_COMPRESSION)
local  lOK  := .f.

  oZip:Log:Open(left(cArc, At('.zip', lower(cArc))) + 'log')
  oZip:SetDisplayObject(oXbp)
  oZip:Open(cArc, .t., nCR)
  oZip:AddDir(cFSpec, cDir)
  oZip:Close() ; oXbp:Hide() ; oXbp:Destroy() ; oDlg:Destroy()

return


Procedure ExtractArchive(cArc, cFSpec, cDir, lSubD, cRepl)
local  oDlg := XbpDialog():New():Create(AppDeskTop(), SetAppWindow(), {100, 100}, {500, 200})
local  oXbp := XbpStatic():New():Create(oDlg:DrawingArea,           , {010, 090}, {480, 020})
local  oZip := XbZLibZip():New()
local  nOvr := XBZ_OVERWRITE_OLDER

  if ValType(cRepl) == 'C'
    if left(upper(cRepl), 1) == 'A'
      nOvr := XBZ_OVERWRITE_ALL
    elseif left(upper(cRepl), 1) == 'N'
      nOvr := XBZ_OVERWRITE_NEVER
    endif
  endif
  oZip:Log:Open(left(cArc, At('.zip', lower(cArc))) + 'log')
  oZip:SetDisplayObject(oXbp)
  oZip:Open(cArc, XBZ_OPEN_READ)
  if oZip:IsOpen()
    MsgBox('Number of Files Extracted: ' + alltrim(str(oZip:Extract(cDir, cFSpec, lSubD, nOvr))), 'Extraction of Files Completed!')
    oZip:Close()
  endif
  oXbp:Destroy() ; oDlg:Destroy()
return


Procedure DeleteFromArchive(cArc, cFSpec)
local  oDlg := XbpDialog():New():Create(AppDeskTop(), SetAppWindow(), {100, 100}, {500, 400})
local  oXbp := XbpTreeView():New():Create(oDlg:DrawingArea,         , {010, 010}, {480, 350})
local  oZip := XbZLibZip():New()

  oZip:Log:Open(left(cArc, At('.zip', lower(cArc))) + 'log')
  oZip:Open(cArc)
  oZip:SetDisplayObject(oXbp)
  if oZip:IsOpen(.t.)
    oZip:Delete(cFSpec)
  endif
  oZip:Log:Close()
  DisplayList(oZip)
  oZip:Close() ; oXbp:Hide() ; oXbp:Destroy() ; oDlg:Destroy()
return


Procedure ReadAndShowArchive(cArc, cFSpec)
LOCAL oDlg := XbpDialog():New():Create(AppDeskTop(), SetAppWindow(), {100, 100}, {500, 200})
LOCAL oXbp := XbpStatic():New():Create(oDlg:DrawingArea,           , {010, 090}, {480, 020})
LOCAL oZip := XbZLibZip():New()

  oZip:Log:Open(left(cArc, At('.zip', lower(cArc))) + 'log')
  oZip:SetDisplayObject(oXbp)
  oZip:Open(cArc, XBZ_OPEN_READ)
  oZip:Log:Close()
  DisplayList(oZip, cFSpec)
  oZip:Close() ; oXbp:Destroy() ; oDlg:Destroy()

return


Procedure TestAndShowArchive(cArc)
local  oDlg := XbpDialog():New():Create(AppDeskTop(), SetAppWindow(), {100, 100}, {500, 400})
local  oXbp := XbpMLE():New():Create(oDlg:DrawingArea,              , {010, 010}, {480, 350})
local  oZip := XbZLibZip():New()

  oDlg:DrawingArea:Resize := {|aOldSize, aNewSize, obj| oXbp:SetSize({aNewSize[1] - 20, aNewSize[2] - 20})}
  oXbp:Editable := .f. ; oXbp:Configure()
  oZip:Log:Open(left(cArc, At('.zip', lower(cArc))) + 'log')
  oZip:SetDisplayObject(oXbp)
  oZip:OnCorruption := {|| XBZ_FILE_OK}
  oZip:Open(cArc, XBZ_OPEN_TEST)
  oZip:Log:Close()
  DisplayList(oZip)
  oZip:Close() ; oXbp:Hide() ; oXbp:Destroy() ; oDlg:Destroy()

return


Procedure TestAndFixArchive(cArc)
local  oDlg := XbpDialog():New():Create(AppDeskTop(), SetAppWindow(), {100, 100}, {500, 400})
local  oXbp := XbpTreeView():New():Create(oDlg:DrawingArea,         , {010, 010}, {480, 350})
local  oZip := XbZLibZip():New()

  oDlg:DrawingArea:Resize := {|aOldSize, aNewSize, obj| oXbp:SetSize({aNewSize[1] - 20, aNewSize[2] - 20})}
  oZip:Log:Open(left(cArc, At('.zip', lower(cArc))) + 'log')
  oZip:SetDisplayObject(oXbp)
  oZip:Open(cArc, XBZ_OPEN_TEST)
  oZip:Log:Close()
  DisplayList(oZip)
  oZip:Close() ; oXbp:Hide() ; oXbp:Destroy() ; oDlg:Destroy()

return


Procedure SetArchiveComment(cArc, cComment)
local  cNote := if(empty(cComment), '', cComment)
local  oZip  := XbZLibZip():New(cArc)

  oZip:Close(cNote)

return


Function DisplayList(oZip, cFSpec)

return (.t.)


/*
Function DisplayList(oZip, cFSpec)
LOCAL nEvent, mp1, mp2, oXbp, oBrowse, oZipItem, aTimeDate
LOCAL oDlg        := ZipBrowse():New():Create()
LOCAL oDraw       := oDlg:DrawingArea
LOCAL aSize       := {oDraw:CurrentSize()[1] - 20, oDraw:CurrentSize()[2] - 20}
LOCAL aPos        := {10, 10}
LOCAL aList       := oZip:Directory()
LOCAL aStatus     := oZip:StatusList()
LOCAL aBrowse     := {}
LOCAL aTypes      := XBZ_COMP_TEXT
LOCAL nFile       := 0
LOCAL nCompSize   := 0
LOCAL nUnCompSize := 0

        oDlg:SetTitle(oZip:FileName + ' -- "' + oZip:FileComment + '"')
        oDlg:SetEventMask(3, .t.)

        if len(aList) == 0
                MsgBox('Zip File: "' + oZip:FileName + '" is empty!')
                oDlg:Destroy() ; return (.f.)
        endif

        for nFile := 1 to len(aList)
                oZipItem := aList[nFile]
                if XbZ_WildCardMatch(oZipItem:FileName, cFSpec)
                        aTimeDate   := XbZ_FatTimeDate2DateTime(oZipItem:FileTime)
                        nCompSize   := oZipItem:CompSize
                        nUnCompSize := oZipItem:UnCompSize
                        AAdd(aBrowse, {;
                                oZipItem:FileName,;
                                str(nCompSize, 12),;
                                str(nUnCompSize, 12),;
                                aTypes[oZipItem:CompMethod + 1],;
                                XbZ_Num2Hex(Bin2U(oZipItem:CRC), 8),;
                                DtoC(aTimeDate[1]),;
                                aTimeDate[2],;
                                XbZ_DosAttrib2FileAttrib(oZipItem:ExternalFAttrib, '.'),;
                                str(100 - ((nCompSize / nUnCompSize) * 100), 6) + '%',;
                                XbZ_Num2Binary(aStatus[nFile], XBZ_MAX_ERROR_CODES),;
                                iif(empty(oZipItem:Comment), 'Starts on Disk: ' + str(oZipItem:DiskNumStart + 1, 3) + ' at byte: ' + str(oZipItem:Offset, 12), oZipItem:Comment)})
                endif
        next

        if len(aBrowse) == 0
                MsgBox('Zip File: "' + oZip:FileName + '" does not contain any matching Entries!')
                oDlg:Destroy() ; return (.f.)
        endif

        ASort(aBrowse, , , {|a, b| upper(a[1]) < upper(b[1])})

        oBrowse := MyArrayBrowse():New(oDlg:DrawingArea, , aPos, aSize)
        oBrowse:VScroll := .t.
        oBrowse:HScroll := .t.
        oBrowse:Create()

        oBrowse:SetArray(aBrowse)
        oBrowse:AddColumnBlock( 1, 30, "File Name")
        oBrowse:AddColumnBlock( 2,  8, "Compressed Size")
        oBrowse:AddColumnBlock( 3,  8, "Original Size")
        oBrowse:AddColumnBlock( 4, 12, "Method")
        oBrowse:AddColumnBlock( 5, 12, "CRC32")
        oBrowse:AddColumnBlock( 6, 12, "Date")
        oBrowse:AddColumnBlock( 7, 12, "Time")
        oBrowse:AddColumnBlock( 8, 10, "Attributes")
        oBrowse:AddColumnBlock( 9,  8, "Ratio")
        oBrowse:AddColumnBlock(10, 15, "Status")
        oBrowse:AddColumnBlock(11, 80, "File Comment")
        oBrowse:SetEventMask(3, .t.)

        oDraw:Resize := {|aOldSize, aNewSize, Self| oBrowse:SetSize({aNewSize[1] - 20, aNewSize[2] - 20})}

        oBrowse:Show() ; SetAppFocus(oBrowse)

        while nEvent # xbeP_Close
                nEvent := AppEvent(@mp1, @mp2, @oXbp)
                oXbp:HandleEvent(nEvent, mp1, mp2)
        enddo
return (.t.)
*/