#include "Common.ch"
#include "dmlb.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"

#include "..\Asystem++\Asystem++.ch"
#include "..\A_main\WinApi_.ch"
*
**
#include 'bap.ch'
#include 'ot4xb.ch'
#include "dll.ch"

#define NULL            0

#define SHELL_OPEN      "open"
#define SHELL_PRINT     "print"
#define SHELL_EXPLORE   "explore"
#define SHELL_FIND      "find"

#define SW_NORMAL       1
#define SW_SHOW         5


#pragma library( "ot4xb.lib"   )
#pragma library( "ascom10.lib" )
#PRAGMA LIBRARY( "XPPUI2.LIB"  )


DLLFUNCTION ShellExecuteExA( lpbi )              USING STDCALL FROM SHELL32.DLL


*  DOKUMENT - VAZDOKUM
** CLASS SYS_VazDokum_SCR ******************************************************
CLASS SYS_VazDokum_SCR FROM drgUsrClass
EXPORTED:
  VAR     mainFILE, titleText, TYPvyberu

  METHOD  Init, getForm, drgDialogStart, itemMarked
  METHOD  attachDokum, attachSlozku, showContensFolder

  * metody pro Action
  method  sys_dokument_in
  *
  ** bro column na vazDokum
  inline access assign method is_existFile() var is_existFile
    local  retVal := 0, csoubor := ' '

    if dokument->(dbseek( vazDokum->dokument,,'ID'))
      csoubor := allTrim(dokument->csoubor)
      retVal  := if( file(csoubor), MIS_ICON_OK,  MIS_ICON_ERR)
    endif
    return csoubor

  inline access assign method dokument_IDdokum()  var dokument_IDdokum
    dokument->(dbseek( vazDokum->dokument,,'ID'))
    return dokument->cIDdokum

  inline access assign method dokument_zkrDokum() var dokument_zkrDokum
    dokument->(dbseek( vazDokum->dokument,,'ID'))
    return dokument->czkrDokum

  inline access assign method dokument_nazDokum() var dokument_nazDokum
    dokument->(dbseek( vazDokum->dokument,,'ID'))
    return dokument->cnazDokum

  inline access assign method dokument_soubor()   var dokument_soubor
    dokument->(dbseek( vazDokum->dokument,,'ID'))
    return dokument->csoubor

  inline access assign method dokument_adesar()   var dokument_adresar
    dokument->(dbseek( vazDokum->dokument,,'ID'))
    return dokument->madresar


  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    return self

  inline method drgDialogEnd(drgDialog)
    vazDokum->(ads_clearAof(), dbgoTop())
    return self

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    Local  dc := ::drgDialog:dialogCtrl, xval
    local  members

    do case
    case( nevent = xbeP_Selected )
      do case
      case( oXbp:cargo:ClassName() = 'drgRadioButton')
        members := oxbp:cargo:members
        aeval( members, {|o| o:setData( (o = oxbp) ) })

        ::TYPvyberu := if( oxbp:caption = 'dokument', 'D', 'S' )
        if( ::TYPvyberu = 'D', ::attachDokum(), ::attachSlozku() )
      endcase

    case nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
      if( ::TYPvyberu = 'D', ::attachDokum(), ::attachSlozku() )
//      ::vazDokum_act()

    case nEvent = drgEVENT_EDIT

      if empty( ::dokument_nazDokum )                                // složka
        ::showContensFolder( allTrim(::dokument_soubor))
      else                                                           // dokument
        ShellExecute(NIL, SHELL_OPEN, allTrim(::dokument_soubor) )
      endif

    CASE nEvent = drgEVENT_DELETE
      if( .not. vazDokum->(eof()), ::postDelete(), nil )
//      ::vazDokum_act()
      Return .T.

    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
  ENDCASE
  RETURN .F.

HIDDEN
  var     curr_DBro, lcanshow_Dlg
  var     cmain_file, cmain_sid, ctask_fromDbd

  inline method vazDokum_act()
    local  ab     := ::drgDialog:oActionBar:members      // actionBar
    local  x, ev, om, ok

    for x := 1 to LEN(ab) step 1
      ev := Lower(ab[x]:event)
      om := ab[x]:parent:aMenu

      if ev $ 'sys_dokument_in'
        do case
        case ( ev = 'sys_dokument_in'     )
          ok := .not. vazDokum->( eof())
        endcase

        ab[x]:disabled := .not. ok

        if(ok, ab[x]:oxbp:enable(), ab[x]:oxbp:disable() )
      endif
    next
    return self


  inline method postDelete()
    local  cMess := 'Promiòte prosím, ' +CRLF
    local  cTitl := 'Odpojit dokument '
    local  nsel

    cMess += 'požadujete zrušit pøipojený dokument ' +CRLF + ;
             '_ ' +allTrim( ::dokument_nazDokum) +' _'

    nsel := ConfirmBox( ,cMess +chr(13) +chr(10), ;
                         cTitl                  , ;
                         XBPMB_YESNO            , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

    if nsel = XBPMB_RET_YES

      if vazDokum->(sx_rLock())
        vazDokum->(dbdelete())

        ::curr_DBro:oXbp:refreshAll()

        if vazDokum->( eof())
          ::curr_DBro:oxbp:up():forceStable()
          ::curr_DBro:oxbp:refreshAll()
        endif

      else

        ConfirmBox( ,'Pøipojený dokumen nelze zrušit,' +CRLF +;
                     'blokován jiným uživatelem ...', ;
                     'Odpojení dokumenu ...' , ;
                     XBPMB_CANCEL                  , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
      endif
    endif
    return self

ENDCLASS


method SYS_VazDokum_SCR:init(parent)
  local cfiltr

  ::drgUsrClass:init(parent)

  drgDBMS:open('dokument')
  drgDBMS:open('vazdokum')
  drgDBMS:open('vazdokum',,,,,'vazDokumA')
  *
  ** pro práci s TMP soubory pøi poøízení a optavì dat
  if select( 'vazDokumW' ) = 0
    drgDBMS:open( 'vazDokumW', .T., .T., drgINI:dir_USERfitm ); ZAP
  endif

  ::mainFile     := ''
  ::lcanshow_Dlg := .f.

  if parent:parent:lastXbpInFocus:className() = 'XbpBrowse'
    ::mainFile := parent:parent:lastXbpInFocus:cargo:cFile
  else
    ::mainFile := if( parent:parent:dbName = 'M', '', parent:parent:dbName )
  endif

  if .not. empty( ::mainFile)
    odbd           := drgDBMS:getDBD(::mainFILE)

    ::lcanshow_Dlg := .not. (::mainFile)->( eof())

    ::cmain_file   := upper( padR( allTrim( ::mainFILE),10))
    ::cmain_sid    := strZero( isNull( (::mainFILE)->sID, 0), 10)

    * programový filtr
    cfiltr := Format( "ctable = '%%'", { ::cmain_file + ::cmain_sid })
    ::drgDialog:set_prg_filter( cfiltr, 'vazDokum')
  endif
return self


method SYS_VazDokum_SCR:getForm()
  local drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 80,20 DTYPE '10' TITLE 'Pøehled pøipojených dokumentù' ;
                                 GUILOOK 'Message:Y,Action:y,IconBar:Y'

/*
  DRGDBROWSE INTO drgFC FPOS 0,1.4 SIZE 110,17.7 FILE 'vazDokum'   ;
             FIELDS 'M->is_existFile::3.6::6,'                   + ;
                    'M->dokument_IDdokum:idetifikace:14,'        + ;
                    'M->dokument_zkrDokum:zkratka:10,'           + ;
                    'M->dokument_nazDokum:název dokumenu:30,'    + ;
                    'M->dokument_soubor:soubor:50,'              + ;
                    'M->dokument_adresar:20'                       ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 7  POPUPMENU 'yy' RESIZE 'ny'
*/

  DRGDBROWSE INTO drgFC FPOS 0,1.4 SIZE 80,17.7 FILE 'vazDokum'    ;
             FIELDS 'M->is_existFile::3.6::6,'                   + ;
                    'vazDokum->cdokument:dokument/ složka:30,'    + ;
                    'M->dokument_soubor:umístìní:50,'            + ;
                    'M->dokument_IDdokum:idetifikace:14,'        + ;
                    'M->dokument_zkrDokum:zkratka:10'              ;
             ITEMMARKED 'itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7  POPUPMENU 'yy' RESIZE 'ny'


  DRGSTATIC INTO drgFC FPOS 0.2,0.1 SIZE 109.6,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC NAME M->titleText CPOS 20,0.1 CLEN 80
  DRGEND  INTO drgFC

//  DRGAction INTO drgFC CAPTION '~Dokument' EVENT 'sys_dokument_in' TIPTEXT 'Údaje o evidovaném dokumentu'// ICON1 101 ICON2 201 ATYPE 3

  DRGTEXT INTO drgFC CAPTION 'Pøipojit ...' CPOS 0,16 CLEN 12 BGND 9
  DRGRadioButton M->TYPvyberu INTO drgFC FPOS -.4,17.5 SIZE 18,3 ;
                   VALUES 'D:dokument,'  + ;
                          'S:složku   '

return drgFC


method SYS_VazDokum_SCR:drgDialogStart(drgDialog)
  local  members, x
  local  paiconBar
  local  odbd := drgDBMS:getDBD(::mainFILE)

  * musí existovat soubor a obsahuje data
  *
  if .not. empty( ::mainFile) .and. ::lcanshow_Dlg

    isShared := (::mainFile)->( DbInfo( DBO_SHARED ) )

    ::titleText     := Upper( allTrim( odbd:description)) + ' - pøipojené dokumenty '
    ::ctask_fromDbd := odbd:task
    ::curr_DBro     := drgDialog:odBrowse[1]
    *
    * Formuláø "Pøipojené dokumenty" nesmí volat sám sebe => ikona nepøístupná
    paiconBar := drgDialog:oIconBar:members
    For x := 1 To Len( paiconBar) step 1
      If paiconBar[x]:event = misEVENT_DOCUMENTS
        paiconBar[ x]:disabled := .t.

        paiconbar[x]:oXbp:Enabled := .f.
        paiconbar[x]:oXbp:Visible := .f.
      EndIf
    Next
    *
    ** typ výbìru D_okument, S_ložku
    ::TYPvyberu := 'D'
    members     := drgDialog:oForm:aMembers

    members[4]:oxbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
    members[4]:oBord:setParent(drgDialog:oActionBar:oBord)

    for x := 1 to len(members[5]:members) step 1
      oxbp := members[5]:members[x]

      if( x = 1, oxbp:setData(.T.), nil )

      oxbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
      oxbp:parent:setParent(drgDialog:oActionBar:oBord)
    next
  endif
return if( empty( ::mainFile), .f., .t. )


method SYS_vazDokum_SCR:itemMarked()

  dokument->(dbseek( vazDokum->dokument,,'ID'))
  drgMsg(drgNLS:msg( dokument->madresar),DRG_MSG_INFO,::drgDialog)
**  drgMsg(drgNLS:msg( dokument->cnazDokum),DRG_MSG_INFO,::drgDialog)
  ::vazDokum_act()
return self


method SYS_VazDokum_SCR:attachDokum( Dialog)
  local  arrExt := {}
  local  cfile
  local  key, recNo, usrfile, typeID := 'USER'
  *
  local  lpiIcon := 0

  AAdd( arrExt, { ConvToOemCP( 'Všechny dokumenty ')+'(*.*)',  '*.*'})

  if .not. empty(cfile := selFile(,,,,arrExt))
    if .not. dokument->( dbSeek( Upper(cfile),,'DOKUMEN04' ))
      dokument->( dbAppend())

      dokument->cid       := typeID
      dokument->ciddokum  := newIDdokum(typeID)
      dokument->nid       := Val( SubStr(dokument->ciddokum,5))
      dokument->cnazdokum := parsefilename(cfile,1)
      dokument->cTypEDIT  := parsefilename(cfile,2)
      dokument->madresar  := parsefilename(cfile,3)
      dokument->csoubor   := cfile
      dokument->ctask     := ::ctask_fromDbd

      dokument->( dbCommit())
    endif

    key   := ::cmain_file + ::cmain_sid +strZero( isNull( dokument->sID, 0),10)
    recNo := vazDokum->(recNo())

    if .not. vazDOkum->( dbSeek( key,,'VazDokum01'))
      vazDokum->( dbAppend())

      vazDokum->ctable    := ::cmain_file + ::cmain_sid
      vazDokum->cdokument := dokument->cnazdokum
      vazDokum->dokument  := isNull( dokument->sID, 0)
      vazDokum->( dbCommit())
    else

**      vazDokum->(dbgoto( recNo))
    endif

    ::curr_DBro:oxbp:refreshAll()
  endif
return .t.


method SYS_VazDokum_SCR:attachSlozku( Dialog)
  local  key, recNo
  local  in_Dir, typeID := 'USER'
  local  cc := 'Vyberte prosím složku s dokumenty ...'
  *

  if .not. empty( in_Dir := BrowseForFolder( , cc, BIF_USENEWUI ))
    if .not. dokument->( dbSeek( Upper(in_Dir),,'DOKUMEN04' ))
      dokument->( dbAppend())

      dokument->cid       := typeID
      dokument->ciddokum  := newIDdokum(typeID)
      dokument->nid       := Val( SubStr(dokument->ciddokum,5))
      dokument->madresar  := in_Dir
      dokument->csoubor   := in_Dir
      dokument->ctask     := ::ctask_fromDbd

      dokument->( dbCommit())
    endif

    key   := ::cmain_file + ::cmain_sid +strZero( isNull( dokument->sID, 0),10)
    recNo := vazDokum->(recNo())

    if .not. vazDOkum->( dbSeek( key,,'VazDokum01'))
      vazDokum->( dbAppend())

      vazDokum->ctable    := ::cmain_file + ::cmain_sid
      vazDokum->cdokument := in_Dir
      vazDokum->dokument  := isNull( dokument->sID, 0)
      vazDokum->( dbCommit())
    else

**      vazDokum->(dbgoto( recNo))
    endif

    ::curr_DBro:oxbp:refreshAll()

  endif
return .t.


method SYS_vazDokum_SCR:showContensFolder( cDirectory )
  local  arrExt := {}
  local  cfile, in_Dir := cDirectory +if( right(cDirectory,1) = '\', '', '\')

  AAdd( arrExt, { ConvToOemCP( 'Všechny dokumenty ')+'(*.*)',  '*.*'})

  if .not. empty(cfile := selFile(,, in_Dir,,arrExt ))
    ShellExecute(NIL, SHELL_OPEN, allTrim(cfile) )
  endif
return .t.

*
**  metody pro volání výkonných obrazovek
method SYS_vazDokum_SCR:sys_dokument_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area

    DRGDIALOG FORM 'SYS_dokument_IN' PARENT ::drgDialog CARGO drgEVENT_EDIT MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area

  ::curr_DBro:oxbp:refreshCurrent()
return self


/*
HINSTANCE ShellExecute(
  _In_opt_  HWND hwnd,
  _In_opt_  LPCTSTR lpOperation,
  _In_      LPCTSTR lpFile,
  _In_opt_  LPCTSTR lpParameters,
  _In_opt_  LPCTSTR lpDirectory,
  _In_      INT nShowCmd
);
*/


static function ShellExecute(nWhnd, cMode, cFile, cPara, cDir, nShow )
  Local cBin := DllPrepareCall( "SHELL32.DLL", DLL_STDCALL, "ShellExecuteA")
  Local nErg

  SET DEFAULT to nWhnd to AppDesktop():GetHWnd()
  SET DEFAULT to cMode to SHELL_OPEN
  SET DEFAULT to nShow to SW_NORMAL

  cPara := iif( empty(cPara), cPara := 0, '"' + cPara +'"')
  iif( empty(cDir), cDir:=0, )
  nErg        := DllExecuteCall(cBin, nWhnd, @cMode, @cFile, @cPara, @cDir, nShow)

  * není asociace
  if nErg <= 32
**    ShellExecuteEx( AppDesktop():GetHWnd(), cFile )

    nWhnd := SetAppWindow():getHWND() // AppDesktop():GetHWnd()
    cMode := 'openas'  // SHELL_EXPLORE
**    cfile := parseFilename( cfile, 3) +'\'
*    nErg  := DllExecuteCall(cBin, nWhnd, @cMode, @cFile, @cPara, @cDir, nShow)
  endif

return ( IIF( nErg <= 32, .F., .T.))


static function ShellExecuteEx( hWnd, lpFile )
  local o_shellExecuteInfo

  o_shellExecuteInfo := LPSHELLEXECUTEINFO():new()
    o_shellExecuteInfo:cbSize       := o_shellExecuteInfo:_sizeof_()
    o_shellExecuteInfo:fMask        := NULL
    o_shellExecuteInfo:hwnd         := NULL
    o_shellExecuteInfo:lpVerb       := "openas"
    o_shellExecuteInfo:lpFile       := "g:\Lego_XPP\Work\SYS_users_SEL.FRM"  // lpFile
    o_shellExecuteInfo:lpParameters := ""
    o_shellExecuteInfo:lpDirectory  := ""
    o_shellExecuteInfo:nShow        := 1
    o_shellExecuteInfo:hInstApp     := NULL

*    o_shellExecuteInfo:cbSize := 512
*    o_shellExecuteInfo:hwnd   := hWnd
*    o_shellExecuteInfo:lpVerb := "openas"
*    o_shellExecuteInfo:lpFile := "g:\Lego_XPP\Work\SYS_users_SEL.FRM"   // lpFile
*    o_shellExecuteInfo:nShow  := 1

  xx := @SHELL32:ShellExecuteExA( o_shellExecuteInfo )
return .t.


BEGIN STRUCTURE LPSHELLEXECUTEINFO
   MEMBER DWORD  cbSize
   MEMBER ULONG  fMask
   MEMBER HWND   hwnd
   MEMBER LPSTR  lpVerb
   MEMBER LPSTR  lpFile
   MEMBER LPSTR  lpParameters
   MEMBER LPSTR  lpDirectory
   MEMBER INT    nShow
   MEMBER INT    hInstApp
   MEMBER DWORD  lpIDList
   MEMBER LPSTR  lpClass
   MEMBER DWORD  hkeyClass
   MEMBER DWORD  dwHotKey
   MEMBER HANDLE hIcon
   MEMBER HANDLE hProcess
END STRUCTURE