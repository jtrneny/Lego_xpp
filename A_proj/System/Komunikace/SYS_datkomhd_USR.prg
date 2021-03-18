#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "dll.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"

#include "..\Asystem++\Asystem++.ch"
*
#include "..\A_main\WinApi_.ch"

#pragma Library( "ASINet10.lib" )
#pragma Library( "XppUI2.LIB"   )


#xTranslate  .cFtpServer  =>  \[ 1,2\]
#xTranslate  .cUsername   =>  \[ 2,2\]
#xTranslate  .cPassword   =>  \[ 3,2\]


*
** CLASS for SYS_datkomhd_usr *************************************************
CLASS SYS_datkomhd_usr FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogStart
  method  preValidate

  var     msg, dm, dc, df, brow
  var     aitw, relDef, m_file, popUp, a_files
  var     m_datKom_us
  *
  method  itemMarked
  *
  method  sel_dialog, save_datkom
  method  ebro_saveEditRow


  * BRO column indikuje pro nastavení datové komunikace
  inline access assign method is_obdDatKom() var is_obdDatKom
    local  retVal := 0, isOk, recNo
    local  pa     := ::pa_isOk_datkom

    do case
    case datkomusw->(eof())
      retVal := 0
    case datkomusw->isEdit
      retVal := if( empty(datkomusw->cvalue), 6002, MIS_ICON_OK )
    otherWise
      retVal := MIS_NO_RUN
    endcase

    recNo := datkomusw->(recNo())
    isOk  := if( retVal = MIS_ICON_OK .or. retVal = MIS_NO_RUN, .t., .f. )
    if ascan( pa, { |x| x[1] = recNo }) = 0
      aadd( pa, { recNo, isOk })
    endif

    return retVal


    inline method eventHandled(nEvent, mp1, mp2, oXbp)
      local  pa := ::pa_isOk_datkom, isOk := .t.

      if .not. ::inTest
        aeval( pa, {|x| if( x[2], nil , isOk := .f. ) })
        if( isOk, ::obtn_save_datkom:oXbp:enable() , ;
                  ::obtn_save_datkom:oXbp:disable()  )
      endif
    return .f.

HIDDEN:
  method  readSections, getItemsFromSection
  var     oini, oini_set, inTest, obtn_save_datkom, pa_isOk_datkom
  var     tmp_Dir, csection, cfiltr, mDefin_kom
  var     pa_FTP_user
ENDCLASS


method sys_datkomhd_usr:init(parent)
  local  cSection := '', cfiltr := "upper(csection) = '%%'"

  ::drgUsrClass:init(parent)

  ::pa_isOk_datkom := {}
  ::tmp_Dir        := drgINI:dir_USERfitm +userWorkDir() +'\'
  ::cfiltr         := ''
  ::mDefin_kom     := ''
  ::pa_FTP_user    := { { 'ftpUserServer', '' }, ;
                        { 'ftpUserName'  , '' }, ;
                        { 'ftpUserPassw' , '' }  }

  if isObject( parent:parent:udcp)
    if isMemberVar( parent:parent:udcp, 'csection')
      cSection := upper(parent:parent:udcp:csection)
    endif

    if isMemberVar( parent:parent:udcp, 'mdefin_kom')
      ::mDefin_kom := parent:parent:udcp:mDefin_kom
    endif
  endif

  if .not. empty(cSection)
    ::cfiltr := format( cfiltr, { cSection })
  endif

  ** nastavení datové komunikace USR
  drgDBMS:open('DATKOMusw',.T.,.T.,drgINI:dir_USERfitm); ZAP
return self


method sys_datkomhd_usr:getForm()
  local  _drgEBrowse
  local  oDrg, drgFC := drgFormContainer():new()

  ::inTest := (::drgDialog:parent:formName == "drgMenu")

  if ::inTest
    DRGFORM INTO drgFC SIZE 100,25 DTYPE '10'                     ;
                       TITLE 'Seznam definovaných komunikací ...' ;
                       GUILOOK 'Action:Y,IconBar:Y,Border:Y'      ;
                       PRE  'preValidate'

    DRGDBROWSE INTO drgFC FPOS 0.5,0.1 SIZE 110,15 FILE 'DATKOMHD'     ;
        FIELDS 'cnazdatkom:Název dat_kom:60,'                        + ;
               'cTASK:úloha:10,'                                     + ;
               'cmainfile:hlavní soubor:10,'                         + ;
               'ciddatkom:ID_datkom:17'                                ;
        SCROLL 'yy' CURSORMODE 3 PP 7 ITEMMARKED 'ItemMarked' POPUPMENU 'y'

    DRGTEXT INTO drgFC CAPTION 'Definice komunikace ...'  CPOS 0.5,15.2 CLEN 42 BGND 13 FONT 5
    DRGMLE datkomhd->mDEFIN_KOM INTO drgFC FPOS 0.5,16.2 SIZE 42,8.6 PP 2

    * EBrowse
    DRGTEXT INTO drgFC CAPTION 'Nastavení datové komunikace ...'  CPOS 44,15.2 CLEN 55 BGND 13 FONT 5
    DRGEBROWSE INTO drgFC FPOS 43,16.2 SIZE 56,8.6 FILE 'DATKOMusw'  ;
               SCROLL 'ny' CURSORMODE 3 PP 7                         ;
               GUILOOK 'sizecols:n,headmove:n,ins:n,del:n,enter:y'

      _drgEBrowse := oDrg

      DRGTEXT INTO drgFC NAME M->is_obdDatKom       CLEN  2  CAPTION ''
      oDrg:isbit_map := .t.

      DRGTEXT INTO drgFC NAME datkomusw->cname  CPOS 2,0 CLEN 12  CAPTION 'název'
      DRGGET  datkomusw->cvalue INTO drgFC      FPOS 1,0 CLEN 38 FCAPTION 'hodnota' PUSH 'sel_Dialog'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

  else
    DRGFORM INTO drgFC SIZE 70,12 DTYPE '10' TITLE 'Nastavení datové komunikace ...' ;
                                             GUILOOK 'All:N,Border:Y'                ;
                                             PRE  'preValidate'

    DRGTEXT INTO drgFC NAME datkomhd->cnazDatKom  CPOS 0.5,0.1 CLEN 69 BGND 12 FONT 5
    DRGEBROWSE INTO drgFC FPOS 0.02,1.2 SIZE 69,8.6 FILE 'DATKOMusw'  ;
               SCROLL 'ny' CURSORMODE 3 PP 7                          ;
               GUILOOK 'sizecols:n,headmove:n,ins:n,del:n,enter:y'

      _drgEBrowse := oDrg

      DRGTEXT INTO drgFC NAME M->is_obdDatKom       CLEN  2  CAPTION ''
      oDrg:isbit_map := .t.

      DRGTEXT INTO drgFC NAME datkomusw->cname  CPOS 2,0 CLEN 12  CAPTION 'název'
      DRGGET  datkomusw->cvalue INTO drgFC      FPOS 1,0 CLEN 51 FCAPTION 'hodnota' PUSH 'sel_Dialog'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

    DRGPUSHBUTTON INTO drgFC CAPTION '~Ok'    ;
                  POS 46,10.5                 ;
                  SIZE 10,1                   ;
                  ATYPE 3                     ;
                  ICON1 101                   ;
                  ICON2 201                   ;
                  EVENT 'save_datkom' TIPTEXT 'Ulož nastavení komunikace'

    DRGPUSHBUTTON INTO drgFC CAPTION 'Storno' ;
                  POS 58,10.5                 ;
                  SIZE 10,1                   ;
                  ATYPE 3                     ;
                  ICON1 102                   ;
                  ICON2 202                   ;
                  EVENT drgEVENT_QUIT TIPTEXT 'Ukonèi dialog ...'
 endif
return drgFc


method sys_datkomhd_usr:drgDialogStart(drgDialog)
  local  members    := drgDialog:oForm:aMembers
  local  x

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
*  ::udcp     := drgDialog:udcp                    // udcp
  *
*  ::m_parent := parent

  for x := 1 TO LEN(members) step 1
    if members[x]:ClassName() = 'drgPushButton'
      if( ischaracter(members[x]:event), ::obtn_save_datkom := members[x], nil)
    endif
  next

*  ::drgPush:oXbp:setFont(drgPP:getFont(5))
*  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

  ::pa_isOk_datkom := {}
  if( .not. ::inTest, ::readSections(), nil )
return self


method sys_datkomhd_usr:itemMarked(a,b,c)

  ::pa_isOk_datkom := {}
  ::readSections()
return self


method sys_datkomhd_usr:readSections()
  local  sName   := ::tmp_Dir +'datkom.ini'
  local  usrName := ::tmp_Dir +datkomhd->cidDatKom +'.usr'
  *
  local  aSections    := {}, x, cSection
  local  mDefin_kom   := if( empty(::mDefin_kom), datkomhd->mDefin_kom, ::mDefin_kom)
  *
  local  cusr_section := ''

  if file( usrName )
    mDefin_kom += CRLF +CRLF
    mDefin_kom += memoRead( usrName )
  endif

  memoWrit( sName, mDefin_kom )

  ::oini := TIniFile():new( sName )
  ::oini:readSections(aSections)

  cusr_section := lower(aSections[1]) +'_usr'
  datkomusw->(dbZap())

  for x := 1 to len( aSections) step 1
    cSection := lower(asections[x])

    if( cSection <> 'users' .and. .not. ('users_' $ cSection) .and. .not. ('_usr'$ cSection) )
      ::getItemsFromSection( aSections[x] )
    endif
  next

  if( .not. empty(::cfiltr), datkomusw->(ads_setAof(::cfiltr)), nil )
  datkomusw->(dbgoTop())
return self


method sys_datkomhd_usr:getItemsFromSection( cSection )
   local i
   local aList := {}, aUser  := {}, pa := {}
   local              pa_usr := {}, pb := {}
   local n, npos, nusr
   local cCaption, xValue

   ::oIni:readSectionValues( 'Users_' +cSection , aUser )
   aeval( aUser, {|s| aadd( pa, listAsArray(s,'=')) })

   ::oini:readSectionValues( cSection +'_usr', pa_usr )
   aeval( pa_usr, {|s| aadd( pb, listAsArray(s,'=')) })

   ::oIni:readSectionValues( cSection, aList )

   for i := 1 to len(aList) step 1
     n = At('=', aList[i])
     cCaption := Left( aList[i], n-1 )
     xValue   := SubStr( aList[i], n+1 )

     npos := ascan( pa, {|s| lower( s[1]) = lower( ccaption) })
     if( nusr := ascan( pb, {|s| lower( s[1]) = lower( ccaption) })) <> 0
       xValue := pb[nusr,2]
     endif

     datkomusw->(dbAppend())
     datkomusw->csection := cSection
     datkomusw->cname    := cCaption
     datkomusw->cvalue   := xValue

     if (npos <> 0)
       datkomusw->isEdit    := .t.
       datkomusw->isSel_dia := (upper( left(pa[npos,2],3)) = 'SEL'    )
       datkomusw->isSel_dir := (upper( left(pa[npos,2],7)) = 'SEL_DIR')
     endif

     if( npos := ascan( ::pa_FTP_user, {|s| lower( s[1]) = lower(cCaption) })) <> 0
       ::pa_FTP_user[npos,2] := allTrim(datkomusw->cvalue)
     endif
   next
return self


method sys_datkomhd_usr:preValidate(drgVar)
  local ok := .f.

  if drgVar:oDrg:className() = 'drgGET'
    if datkomusw->isEdit
      ok := .t.
      if datkomusw->isSel_dia
        drgVar:odrg:pushGet:oxbp:setSize({22,16})
      else
        drgVar:odrg:pushGet:oxbp:setSize({0,0})
      endif
      drgVar:odrg:pushGet:oxbp:configure()
    endif
  endif
return ok


method sys_datkomhd_usr:ebro_saveEditRow(o_ebro)
  local  recNo := datkomusw->(recNo())
  local  cName := datkomusw->cName
  local  pa    := ::pa_isOk_datkom, npos

  if .not. empty( datkomusw->cvalue)
    if (npos := ascan( pa, { |x| x[1] = recNo })) <> 0
      pa[npos,2] := .t.
    endif

    if( npos := ascan( ::pa_FTP_user, {|s| lower( s[1]) = lower(cName) })) <> 0
      ::pa_FTP_user[npos,2] := allTrim(datkomusw->cvalue)
    endif
  endif
return .t.


method sys_datkomhd_usr:save_datkom()
  local  aSections := {}
  local  cc := '', isOk := .f., sName := ::tmp_Dir +datkomhd->cidDatKom +'.usr'
  *
  local  csection
  local  oFTP_user, pa := ::pa_FTP_user, is_FTP_user := .t.
  *
  ** testnem nastavení FTP komunikace
  aeval( pa, {|s| if( empty(s[2]), is_FTP_user := .f., nil ) })

/*
  if is_FTP_user
    oFTP_user := FTPClient():new( pa.cFtpServer, pa.cUsername, pa.cPassword )

    if .not. oFTP_user:Connect()
      drgMsgBox(drgNLS:msg('Nelze se pøipojit na FTP server ' +pa.cFtpServer +' ...'))
    else
      drgMsgBox(drgNLS:msg('Kontrola pøipojení na FTP server ' +pa.cFtpServer +' je OK ...'))
      oFTP_user:disConnect()
    endif

    _clearEventLoop(.t.)
  endif
*/

**
  if is_FTP_user
    oFTP_user := xbFTP():new( pa.cFtpServer, pa.cUsername, pa.cPassword )

    if .not. oFTP_user:Open()
      drgMsgBox(drgNLS:msg('Nelze se pøipojit na FTP server ' +pa.cFtpServer +' ...'))
    else
      drgMsgBox(drgNLS:msg('Kontrola pøipojení na FTP server ' +pa.cFtpServer +' je OK ...'))
*      pA  := oFTP_user:Directory()
*      lok := oFTP_user:getFile( 'import/pricelist.csv', 'c:\A_work\pricelist.csv' )
*      lok := oFTP_user:putFile('c:\A_work\dump.txt', 'import/dump.txt' )
      oFTP_user:Close()
    endif

    _clearEventLoop(.t.)
  endif
**


  FErase( sName )

  ::oini:readSections(aSections)
  ::m_datKom_us := ''

  datkomusw->(ads_clearAof(), dbGoTop())
  csection := datkomusw->csection

  cc := '[' +aSections[1] +'_usr' +']' +CRLF
  cc += if( .not. empty(csection), '[' +alltrim(csection) +'_usr]' +CRLF, '' )

  do while .not. datkomusw->(eof())
    ::m_datKom_us += allTrim(datkomusw->cname) +'=' +allTrim(datkomusw->cvalue) +CRLF

    if datkomusw->isEdit

      if datkomusw->csection <> csection
        cc       += if( .not. empty(datkomusw->csection), '[' +alltrim(datkomusw->csection) +'_usr]' +CRLF, '' )
        csection := datkomusw->csection
      endif

      if datkomusw->isEdit
        cc   += allTrim(datkomusw->cname) +'=' +allTrim(datkomusw->cvalue)

        if datkomusw->isSel_dir
          if right(allTrim(datkomusw->cvalue), 1) <> '\'
            cc += '\'
          endif
        endif

        cc   += CRLF
        isOk := .t.
      endif
    endif
    datkomusw->(dbskip())
  enddo

  if( isOk, memoWrit( sName, cc ), nil )
  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
return .t.


* zatím podporujeme SEL_DIR  ... výbìr adresáøe
*                   SEL_FILE ... výbìr souboru
method sys_datkomhd_usr:sel_dialog()
  local  in_Dir, cc := 'Kam mají být naèená data uložena ?'

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )

  if .not. empty(in_Dir)
    datkomusw->cvalue := in_Dir
    PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE,'0',::drgDialog:lastXbpInFocus)
//    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,::drgDialog:lastXbpInFocus)
  endif
return .t.


*
**
class TIniFile
exported:
   var FileName

   method init

   method ReadSections, ReadSection, ReadSectionValues
   method ReadString, ReadInteger, ReadBool
   method WriteString, WriteInteger, WriteBool
   method DeleteKey, EraseSection
endclass

method TIniFile:init(AFileName)
   ::FileName := AFileName
return Self

method TIniFile:ReadSections(ASections)
   local n, Buffer

   Buffer := space(16383)

   GetPrivateProfileSectionNamesA(@Buffer, 16383, ::FileName)

   asize(ASections, 0)
   while( asc(Buffer) <> 0 .and. (n := at(chr(0), Buffer)) > 0 )
      aadd(ASections, left(Buffer, n - 1))
      Buffer := substr(Buffer, n + 1)
   end
return Self

method TIniFile:ReadSection(ASection, AKeys)
   local n, Buffer

   Buffer := space(16383)

   GetPrivateProfileStringA(ASection, 0, '', @Buffer, 16383, ::FileName)

   asize(AKeys, 0)
   while( asc(Buffer) <> 0 .and. (n := at(chr(0), Buffer)) > 0 )
      aadd(AKeys, left(Buffer, n - 1))
      Buffer := substr(Buffer, n + 1)
   end
return Self

method TIniFile:ReadSectionValues(ASection, AValues)
   local n, Buffer

   Buffer := space(16383)

   GetPrivateProfileSectionA(ASection, @Buffer, 16383, ::FileName)

   asize(AValues, 0)
   while( asc(Buffer) <> 0 .and. (n := at(chr(0), Buffer)) > 0 )
      aadd(AValues, left(Buffer, n - 1))
      Buffer := substr(Buffer, n + 1)
   end
return Self

method TIniFile:ReadString(ASection, AKey, ADefault)
   local Buffer

   Buffer := space(256)

   GetPrivateProfileStringA(ASection, AKey, ADefault, @Buffer, 256, ::FileName)
return substr(Buffer,1,len(trim(buffer))-1)  // drop the trailing zero
// return trim(Buffer)

method TIniFile:ReadInteger(ASection, AKey, ADefault)
return GetPrivateProfileIntA(ASection, AKey, ADefault, ::FileName)

method TIniFile:ReadBool(ASection, AKey, ADefault)
return (GetPrivateProfileIntA(ASection, AKey, ADefault, ::FileName) <> 0)

method TIniFile:WriteString(ASection, AKey, AString)
return (WritePrivateProfileStringA(ASection, AKey, AString, ::FileName) <> 0)

method TIniFile:WriteInteger(ASection, AKey, AnInt)
return (WritePrivateProfileStringA(ASection, AKey, ltrim(str(AnInt)), ::FileName) <> 0)

method TIniFile:WriteBool(ASection, AKey, ABool)
return (WritePrivateProfileStringA(ASection, AKey, iif(ABool, '1', '0'), ::FileName) <> 0)

method TIniFile:DeleteKey(ASection, AKey)
   WritePrivateProfileStringA(ASection, AKey, 0, ::FileName)
return Self

method TIniFile:EraseSection(ASection)
   WritePrivateProfileStringA(ASection, 0, 0, ::FileName)
return Self

dllfunction GetPrivateProfileSectionNamesA(@ABuffer, ALength, AFileName) using stdcall from "kernel32.dll"
// dllfunction GetPrivateProfileSectionA(ASection, @ABuffer, ALength, AFileName) using stdcall from "kernel32.dll"
// dllfunction GetPrivateProfileStringA(ASection, AKey, ADefault, @ABuffer, ALength, AFileName) using stdcall from "kernel32.dll"
dllfunction GetPrivateProfileIntA(ASection, AKey, ADefault, AFileName) using stdcall from "kernel32.dll"
dllfunction WritePrivateProfileStringA(ASection, AKey, AString, AFileName) using stdcall from "kernel32.dll"