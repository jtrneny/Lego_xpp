#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "dll.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"
#include "Directry.ch"
#include "XbZ_Zip.ch"
#include "XbFTP.ch"


#include "..\Asystem++\Asystem++.ch"
#include "..\A_main\WinApi_.ch"

#pragma Library( "XppUI2.LIB"  )
#pragma Library( "ASINet10.lib")
#pragma Library( "XbZlib.lib"  )
//#pragma Library("XbFtp.Lib")


*
** spoleèné funce a tøídy pro KOMUNIKACI - pøesunuto do DLL
*
** pùvodní umístìní SYS_komunikace_VYR.prg
Function FileInDirs( path,file,tmpw)
  local  adir, afile, atmp
  local  n := 0
  local  csel

  DEFAULT tmpw TO .F.

  adir := afile := atmp := {}
  adir := dir1( path)

  for n:= 1 to Len( aDir)
    atmp := Directory( aDir[n] +AllTrim(file))
    aEval( atmp, { |X| AAdd( afile, {X[1],aDir[n]})})
  next

  if tmpw
    drgDBMS:open('filew',.t.,.t.,drgINI:dir_USERfitm,,,.t.) ; ZAP
    filew->( OrdSetFocus('FILEw05'))

    for n := 1 to Len( afile)
      csel := Upper( Left( afile[n,1],1))

      if ( csel = 'Z' .or. csel = 'S' .or. csel = 'K') .and.                        ;
          SubStr( afile[n,1],7,1) = '-'
        filew ->( dbAppend())
        filew ->file      :=  Left( afile[n,1], RAt('.',afile[n,1])-1 )
        filew ->path      :=  afile[n,2]
        filew ->ext       :=  SubStr(afile[n,1], RAt('.',afile[n,1])+1 )
        filew ->file_ext  :=  afile[n,1]
        filew ->path_file :=  afile[n,2]+afile[n,1]
        filew ->select    :=  1
      endif
    next
  endif
return( afile)


Function Dir1( path)
  local  adir, afile, atmp
  local  n

  adir := afile := atmp := {}

  AAdd(afile, path)
  adir := Directory( path,'D')

  for n := 1 to len( adir)
    if adir[n,5] = 'D' .and. Left(adir[n,1],1) <> '.'
      atmp  := Dir2( path +adir[n,1]+'\')
      aEval(atmp,{|X| AAdd( afile,X)})
    endif
  next
return( afile)


Function Dir2( path)
  local  adir, afile, atmp
  local  n

  adir := afile := atmp := {}

  AAdd(afile, path)
  adir := Directory( path,'D')

  for n := 1 to len( adir)
    if adir[n,5] = 'D' .and. Left(adir[n,1],1) <> '.'
      atmp  := Dir1( path +adir[n,1]+'\')
      aEval(atmp,{|X| AAdd( afile,X)})
    endif
  next
return( afile)

*
** pùvodní umítnìní SYS_komunikace_.prg
/*
PathExport=C:\A_work\
ftpUserServer=www.agrikol.cz
ftpUserName=importagrikol
ftpUserPassw=lsfjTzi2Hpasw
ftpUserDir=Import\
*/


*  METHODS:
*        :init( cAddress, cUserId, cPassword, cProxy, nPort )
*        :Open()
*        :close()                - this also accepts a parameter - do not use it!
*                                  the parameter is entirely for internal use only
*        :destroy()              - a convenient way to properly close a connection
*        :getCurrentDirectory()
*        :setCurrentDirectory(cDirectry)
*        :createDirectory(cDirectry)
*        :deleteDirectory(cDirectry)
*        :deleteFile(cFile)
*        :renameFile(cFile, cNewName)
*        :getFile(cRemoteFile, cLocalFile, lOverWrite, fAttr, nTransferMode)
*        :putFile(cLocalFile, cRemoteFile, nTransferMode)
*        :directory(lSorted, cSpec)


* parametr ftpCom...  nová funkce
*   file
*   nopenType    -   INTERNET_OPEN_TYPE_PRECONFIG                         0
*                                      _DIRECT                            1
*                                      _PROXY                             3
*                                      _PRECONFIG_WITH_NO_AUTOPROXY       4


function ftpCom( file, ntyp, lview, odata_datKom, nopenType )
  local  oFTP
  local  ftpFile, ftpFileName
  local  cdir
  local  lok := .t.

  default ntyp to 0, lview to .f.

  if isObject( odata_datKom )
    oFTP := XbFTP():new( odata_datKom:ftpUserServer, odata_datKom:ftpUserName, odata_datKom:ftpUserPassw)
    if oFTP:open(odata_datKom:InternFlagPassive)

      ftpFile     := subStr(file, rat( '\', file) +1)
      ftpFileName := if( empty(odata_datKom:ftpUserDir), '', odata_datKom:ftpUserDir) +ftpFile

      do case
      case( ntyp = 1 .or. ntyp = 5 )              // export
        if file( file )
          if .not. Empty(odata_datKom:ftpUserDir)
            cdir := StrTran(odata_datKom:ftpUserDir,'\','/')
            if rat( '/', cdir) = 1
               cdir := SubStr( cdir, rat( '/', cdir) +1)
            endif
            lok := oFTP:setCurrentDirectory(cdir)
          endif
          lok := oFTP:putFile( file,ftpFileName)
        endif

      case ntyp = 2                              // import
        file := cdirW+'\'+file
        oFtp:getFile( cFileName, file )

      case ntyp = 3                              // delete on FTP
        oFTP:deleteFile( cFileName )

      case ntyp = 4                              // file on FTP exist
//        cContents := oFTP:get( cFileName )
//        lok := .not.Empty(cContents)
      endcase

      oFTP:close()
//      DrgDump( "disconnect  ----  " + "OK" + "  ---- cas -->  " + time())
    endif
  endif

return lok


function ftpComOK( lview, odata_datKom, nopenType )
  local  oFTP
  local  ftpFile, ftpFileName
  local  lok := .f.

  default lview to .f.

  if isObject( odata_datKom )
    oFTP := XbFTP():new( odata_datKom:ftpUserServer, odata_datKom:ftpUserName, odata_datKom:ftpUserPassw )
    lok := oFTP:open(odata_datKom:InternFlagPassive)
  endif

return( lok)


function ftpComSend( fileIN, fileOUT, lview, odata_datKom, nopenType )
  local  oFTP
  local  ftpFile, ftpFileName
  local  cdir
  local  lok := .f.

  default fileOUT to ''
  default lview   to .f.

  if isObject( odata_datKom )
    oFTP := XbFTP():new( odata_datKom:ftpUserServer, odata_datKom:ftpUserName, odata_datKom:ftpUserPassw )
    if oFTP:open(odata_datKom:InternFlagPassive)
      if Empty(fileOUT)
        ftpFile     := SubStr(fileIN, rat( '\', fileIN) +1)
//        ftpFileName := if( empty(odata_datKom:ftpUserDir), '', odata_datKom:ftpUserDir) +ftpFile
      else
        ftpFile := fileOUT
      endif

      if File( fileIN )
        if .not. Empty(odata_datKom:ftpUserDir)
          cdir := StrTran(odata_datKom:ftpUserDir,'\','/')
          if rat( '/', cdir) = len( cdir)
            cdir := SubStr( cdir, 1, rat( '/', cdir) -1)
          endif
          if at( '/', cdir) = 1
            cdir := SubStr( cdir, 2)
          endif

          lok := oFTP:setCurrentDirectory(cdir)
        endif
        lok := oFTP:putFile( fileIN, ftpFile)
      endif

     oFTP:close()
    endif
  endif

return lok

function ftpComDown( fileIN, fileOUT, lview, odata_datKom, nopenType )
  local  oFTP
  local  ftpFile, ftpFileName
  local  cdir
  local  lok := .f.

  default lview   to .f.
  default fileOUT to ''


  if isObject( odata_datKom )
    oFTP := XbFTP():new( odata_datKom:ftpUserServer, odata_datKom:ftpUserName, odata_datKom:ftpUserPassw )

    if oFTP:open(odata_datKom:InternFlagPassive)

      ftpFile     := subStr(file, rat( '\', fileIN) +1)
      ftpFileName := if( empty(odata_datKom:ftpUserDir), '', odata_datKom:ftpUserDir) +ftpFile

      if Empty( fileOUT)
        file := cdirW+'\'+fileIN
      else
        file := fileOUT
      endif

      oFtp:getFile( cFileName, file )

      oFTP:close()
    endif
  endif

return lok




/*
function ftpCom( file, ntyp, lview, odata_datKom )    // old
  local  oFTP
  local  ftpFile, ftpFileName

  default ntyp to 0, lview to .f.

  if isObject( odata_datKom )
    oFTP := FTPClient():new( odata_datKom:ftpUserServer, odata_datKom:ftpUserName, odata_datKom:ftpUserPassw )

    if oFTP:connect()

      ftpFile     := subStr(file, rat( '\', file) +1)
      ftpFileName := if( empty(odata_datKom:ftpUserDir), '', odata_datKom:ftpUserDir) +ftpFile

      do case
      case( ntyp = 1 .or. ntyp = 5 )              // export
        if file( file )
          cContents := memoRead( file )
//          DrgDump( "file       ----  " + file + "  ---- cas -->  " + time())
//          DrgDump( "ftpFileName ---  " + ftpFileName + "  ---- cas -->  " + time())
//          DrgDump( "cContents  ----  " + cContents + "  ---- cas -->  " + time())

          oFTP:put( ftpFileName, cContents )
//          DrgDump( "put  ----  " + "OK" + "  ---- cas -->  " + time())
        endif

      case ntyp = 2                              // import
        cContents := oFtp:get( cFileName )
        Memowrit( cdirW+'\'+file, cContents)

      case ntyp = 3                              // delete on FTP
        oFTP:delete( cFileName )

      case ntyp = 4                              // file on FTP exist
        cContents := oFTP:get( cFileName )
        lok := .not.Empty(cContents)
      endcase

      oFTP:disconnect()
//      DrgDump( "disconnect  ----  " + "OK" + "  ---- cas -->  " + time())
    endif
  endif
return .t.

*/


** ORIG **
FUNCTION x_ftpCom( file, ntyp)
  local cFtpServer
  local cUserName  := "apodpora"
  local cPassword  := "A++_sw1228"
  local oFtp, cContents, cdirW, lok
  local lenBuff := 40960, buffer := space(lenBuff)
  local ftpDir, ftpFile
//  local cFtpServer := "90.182.133.97"
//  local cFtpServer := "192.168.101.213"

  default ntyp to 0

  lok        := .t.
  cdirW      := drgINI:dir_USERfitm +userWorkDir()
  cFtpServer := AllTrim(SysConfig('System:cFtpAdrKom'))
//  ftpDir     :=
  ftpFile    := SubStr(file, rat( '\', file) +1)

  if ntyp = 5
    sName      := cdirW +'\' +datkomhd->cid
    sNameExt   := '.csv'  //    isNull( FileExt(), '.csv' )
    if( .not. Empty(datkomhd->mDefin_kom), MemoWrit(sName +sNameExt, datkomhd->mDefin_kom), nil)
    buffer := space(lenBuff)

* naèteme ze sekece UsedIdentifiers Fields, pro vlastní TISK pøedáme jen tyto položky *
    GetPrivateProfileStringA('Ftp', 'Server', '',   @buffer, lenBuff,  sName +sNameExt)
    cftpserver := substr(buffer,1,len(trim(buffer))-1)
    GetPrivateProfileStringA('Ftp', 'UserName', '', @buffer, lenBuff,  sName +sNameExt)
    cusername  := substr(buffer,1,len(trim(buffer))-1)
    GetPrivateProfileStringA('Ftp', 'Password', '', @buffer, lenBuff,  sName +sNameExt)
    cpassword  := substr(buffer,1,len(trim(buffer))-1)
  endif

  oFtp := FTPClient():new( cFtpServer, cUserName, cPassWord )

  if .not. oFtp:connect()
    lok := .f.
    if ntyp <> 0
       drgMsgBox(drgNLS:msg('Nelze se pøipojit na FTP server podpory...'))
    endif
//    return
  else
    do case
    case ntyp = 1 .or. ntyp = 5
//      if File( cdirW+'\'+file)
      if File( file)
        cContents := Memoread( file )
        oFtp:put( ftpFile, cContents )
      endif

    case ntyp = 2
      cContents := oFtp:get( file )
      Memowrit( cdirW+'\'+file, cContents)

    case ntyp = 3
      oFtp:delete( file )

    case ntyp = 4
      cContents := oFtp:get( file )
      lok := .not.Empty(cContents)

    endcase

    oFtp:disconnect()

  endif
return( lok)


function delFileCom( afile)
  local filew, cdirW, n, m
  local aext := { 'adt', 'adm', 'adi'}

  cdirW  := drgINI:dir_USERfitm +userWorkDir()

  for  n := 1 to Len( afile)
    for m := 1 to Len( aext)
      filew := AllTrim(afile[n,2]+ '.'+ aext[m])
      if File( cdirW+'\'+filew)
        FErase( cdirW+'\'+filew)
      endif
    next
  next
return( nil)


function clsFileCom( afile)
  local inp, out, n

  for n:= 1 to len(afile)
    inp := afile[n,1]
    out := afile[n,2]
    (inp)->(dbCloseArea())
    (out)->(dbCloseArea())
  next
return( nil)


FUNCTION zipCom( afile, out, sel)
  local ozip, file, fileAzf, cdirW, n, m
  local aext := { 'adt', 'adm', 'adi'}

  default sel to .t.

  cdirW  := drgINI:dir_USERfitm +userWorkDir()
  if sel
    fileAzf := selFILE( out, 'Azf',,'Výbìr souboru pro export',{{"AZF soubory", "*.AZF"}})
  else
    fileAzf := cdirW +'\' +out+ '.Azf'
  endif

  ozip := XbZLibZip():New( fileAzf)

  for  n := 1 to Len( afile)
    for m := 1 to Len( aext)
      file := AllTrim(afile[n,2]+ '.'+ aext[m])
      if File( cdirW+'\'+file)
        ozip:AddFile( file, cdirW)
      endif
    next
  next

  ozip:Close()
RETURN( nil)


FUNCTION unzipCom( input, sel)
  local ozip, fileAzf, cdirW

  default sel to .t.

  cdirW  := drgINI:dir_USERfitm +userWorkDir()
  if sel
    fileAzf := selFILE( input, 'Azf',,'Vyber souboru pro import',{{"AZF soubory", "*.AZF"}})
  else
    fileAzf := cdirW +'\' +input+ '.Azf'
  endif


  ozip := XbZLibZip():New( fileAzf, XBZ_OPEN_READ)
  ozip:Extract( cdirW, '*.*', .t., XBZ_OVERWRITE_ALL )
  ozip:close()
return( nil)