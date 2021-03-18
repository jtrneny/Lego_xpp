#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "dll.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"

#include "service.ch"
#include "os.ch"
#include "simpleio.ch"

#include 'ot4xb.ch'
#include "..\Asystem++\Asystem++.ch"
#include "..\A_main\WinApi_.ch"

#pragma Library( "ASINet10.lib" )
#pragma Library( "XppUI2.LIB"   )



CLASS Logger
  EXPORTED:
    INLINE METHOD write( cMsg )
      MsgBox( cMsg )
  RETURN SELF
ENDCLASS


*
** CLASS for SYS_asysSrvc_in ***************************************************
CLASS SYS_asysSrvc_in FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogStart

  var     msg, dm, dc, df, brow
  var     aitw, relDef, m_file, popUp
  var     m_datKom_us
  var     oLog, oCtrl
  var     cUserSRV, cPassSRV

  *
  method  postValidate, itemMarked, sel_dialog, sel_path
  method  instSRV, startSRV, stopSRV, uninstalSRV, removeSRV
  method  stavSRV

   inline method ebro_afterAppend(o_eBro)
     ::dm:set( 'asysSrvc->cuser'    , usrName                                 )
     ::dm:set( 'asysSrvc->cmachine' , netName()                               )
     ::dm:set( 'asysSrvc->cservice' , 'A++_service_' +strZero(usrIDdb,6) +'_' )
   return .t.

   inline method ebro_saveEditRow(o_ebro)
     local cpathINS

     if .not. empty( AllTrim(SysConfig('System:cPathInst')))
       cpathINST := RetDir( AllTrim(SysConfig('System:cPathInst')))
     else

       cpathINST := RetDir( StrTran( AppName(.t.), 'Asystem++.exe', ''))
     endif
     asysSrvc->cuser     := ::dm:get( 'asysSrvc->cuser'   )
     asysSrvc->cpath     := ::dm:get( 'asysSrvc->cpath'   )
     asysSrvc->cservice  := ::dm:get( 'asysSrvc->cservice')

     if file( cpathINST +'A++_service_manager.exe')
       COPY FILE ( cpathINST +'A++_service_manager.exe') TO ( RetDir(asysSrvc->cpath) + 'A++_service_manager.exe')
     else
       ::msg:writeMessage('Pozor soubor [A++_service_manager.exe] neexistuje - služba nemusí být korektnì nainstalována ...', DRG_MSG_ERROR )
     endif

     if file( cpathINST +'A++_service_task.exe')
       COPY FILE ( cpathINST +'A++_service_task.exe')    TO ( RetDir(asysSrvc->cpath) + 'A++_service_task.exe')
     else
       ::msg:writeMessage('Pozor soubor [A++_service_task.exe] neexistuje - služba nemusí být korektnì nainstalována ...', DRG_MSG_ERROR )
     endif

     if file( cpathINST +'Asystem_1.dll')
       COPY FILE ( cpathINST +'Asystem_1.dll')           TO ( RetDir(asysSrvc->cpath) + 'Asystem_1.dll')
     else
       ::msg:writeMessage('Pozor soubor [Asystem_1.dll] neexistuje - služba nemusí být korektnì nainstalována ...', DRG_MSG_ERROR )
     endif

     if file( cpathINST +'Asystem++.ini')
       COPY FILE ( cpathINST +'Asystem++.ini')           TO ( RetDir(asysSrvc->cpath) + 'Asystem++.ini')
     else
       ::msg:writeMessage('Pozor soubor [Asystem++.ini] neexistuje - služba nemusí být korektnì nainstalována ...', DRG_MSG_ERROR )
     endif

     ::oCtrl:addController( AllTrim(asysSrvc->cservice),                       ;
                            AllTrim(asysSrvc->cservice),                       ;
                            RetDir(asysSrvc->cpath) + "A++_service_task.exe", ;
                           ::cUserSRV, ::cPassSRV,  /*parameter*/ ,  ;
                           ::oLog )
   return .t.


  * BRO column indikuje stav spuštìné služby A++_service_XXXXXX
    inline access assign method dwCurrentState() var dwCurrentState
//      return 0

      local  retVal := 0, isOk, recNo
      local  pa     := ::pa_isOk_datkom
      local  oSt

      oSt := ::oCtrl:getUpdatedControl( AllTrim(asysSrvc->cservice ))
//      cMessage := "Stav : " + oSt:currentState

/*
      do case
      case asysSrvc->(eof())
        retVal := 0
      case datkomusw->isEdit
        retVal := if( empty(datkomusw->cvalue), 6002, MIS_ICON_OK )
      otherWise
        retVal := MIS_NO_RUN
      endcase
*/
      do case
      case asysSrvc->(eof())
        retVal := 0
      case oSt:currentState = 'SERVICE_RUNNING'
        retVal :=  MIS_ICON_OK
      case oSt:currentState = 'SERVICE_STOPPED'
        retVal := MIS_NO_RUN
      otherWise
        retVal := 6002
      endcase

//      recNo := datkomusw->(recNo())
//      isOk  := if( retVal = MIS_ICON_OK .or. retVal = MIS_NO_RUN, .t., .f. )
//      if ascan( pa, { |x| x[1] = recNo }) = 0
//        aadd( pa, { recNo, isOk })
//      endif
    return retVal


    inline method eventHandled(nEvent, mp1, mp2, oXbp)
      local  pa := ::pa_isOk_datkom, isOk := .t.

      do case
      case (nEvent = xbeBRW_ItemMarked)
        ::msg:WriteMessage(,0)
        return .f.
      endCase

      if .not. ::inTest
        aeval( pa, {|x| if( x[2], nil , isOk := .f. ) })
        if( isOk, ::obtn_save_datkom:oXbp:enable() , ;
                  ::obtn_save_datkom:oXbp:disable()  )
      endif
    return .f.

HIDDEN:
  var     o_EBrowse
  var     inTest, obtn_save_datkom, pa_isOk_datkom
ENDCLASS


method sys_asysSrvc_in:init(parent)
  ::drgUsrClass:init(parent)

   drgDBMS:open('asysSrvc')
//   drgDBMS:open('asysSrvc',,,,,'asysSrvc_A')
  ::pa_isOk_datkom := {}

  ::oLog  := Logger():new()
  ::oCtrl := ServiceController()
  ::cUserSRV := ''
  ::cPassSRV := ''

  asysSrvc->( dbGoTop())
  do while .not. asysSrvc->( Eof())
    ::oCtrl:addController( AllTrim(asysSrvc->cservice),                      ;
                           AllTrim(asysSrvc->cservice),                      ;
                           RetDir(asysSrvc->cpath) + "A++_service_task.exe", ;
                           ::cUserSRV, ::cPassSRV,  /*parameter*/ ,  ;
                           ::oLog )
    asysSrvc->( dbSkip())
  enddo
  asysSrvc->( dbGoTop())


return self


method sys_asysSrvc_in:getForm()
  local  _drgEBrowse
  local  oDrg, drgFC := drgFormContainer():new()

  ::inTest := (::drgDialog:parent:formName == "drgMenu")

  DRGFORM INTO drgFC SIZE 100,12 DTYPE '10' TITLE 'Nastavení spouštìných služeb A++_service_' +strZero(usrIDdb,6) +' ...' ;
                                            GUILOOK 'Menu:Y,Border:Y,Action:Y,ICONBAR:Y' ;
                                            POST    'postValidate'

*                                            GUILOOK 'All:N,Border:Y,Message:Y,Action:Y'                                            ;

     DRGAction INTO drgFC CAPTION '~Instalace'      EVENT 'instSRV'      TIPTEXT 'Instalace služby A++_service_task pro pøíslušnou databázi - A++_service_' +strZero(usrIDdb,6) +'_LOCAL'
     DRGAction INTO drgFC CAPTION '~Start'          EVENT 'startSRV'     TIPTEXT 'Spuštìní služby A++_service_' +strZero(usrIDdb,6) +'_LOCAL'
     DRGAction INTO drgFC CAPTION 's~Top'           EVENT 'stopSRV'      TIPTEXT 'Zastavení služby A++_service_' +strZero(usrIDdb,6) +'_LOCAL'
     DRGAction INTO drgFC CAPTION '~OdInstal'       EVENT 'uninstalSRV'  TIPTEXT 'Odinstalování služby A++_service_' +strZero(usrIDdb,6) +'_LOCAL ze seznamu služeb'
     DRGAction INTO drgFC CAPTION '~Zruš'           EVENT 'removeSRV'    TIPTEXT 'Zrušení služby A++_service_' +strZero(usrIDdb,6) +'_LOCAL ze seznamu služeb'
     DRGAction INTO drgFC CAPTION '~Stav'           EVENT 'stavSRV'    TIPTEXT 'Zrušení služby A++_service_' +strZero(usrIDdb,6) +'_LOCAL ze seznamu služeb'
*     DRGTEXT INTO drgFC NAME datkomhd->cnazDatKom  CPOS 0.5,0.1 CLEN 69 BGND 12 FONT 5
     DRGEBROWSE INTO drgFC FPOS 0.02,1.2 SIZE 99,9 FILE 'asysSrvc'  ;
                SCROLL 'ny' CURSORMODE 3 PP 7                       ;
                GUILOOK 'sizecols:n,headmove:n,ins:y,del:n,enter:y'

       _drgEBrowse := oDrg

       DRGTEXT INTO drgFC NAME M->dwCurrentState     CLEN  2  CAPTION ''
       oDrg:isbit_map := .t.

       DRGTEXT INTO drgFC NAME asysSrvc->cuser                 CLEN 10  CAPTION  'definoval'
       DRGGET      asysSrvc->cpath          INTO drgFC         CLEN 35  FCAPTION 'cesta kde je služba umístìna' PUSH 'sel_path'
       DRGGET      asysSrvc->cmachine       INTO drgFC         CLEN 35  FCAPTION 'zaøízení kde je služba spuštìna' // PUSH 'sel_Dialog'
       DRGCOMBOBOX asysSrvc->ctypmachin     INTO drgFC                  FCAPTION 'typ zaøízení'     ;
            VALUES 'LOC:lokální,SRV:server'
       DRGTEXT INTO drgFC NAME asysSrvc->cservice              CLEN 35  CAPTION  'název služby'
       DRGMLE  asysSrvc->mpopis             INTO drgFC         CLEN 15  FCAPTION 'popis'


       _drgEBrowse:createColumn(drgFC)
     DRGEND INTO drgFC

     DRGSTATIC INTO drgFC FPOS 0.2,10.1 SIZE 99.8,1.4 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'nn'
       odrg:ctype := 2

       DRGPUSHBUTTON INTO drgFC CAPTION '~Ok'    ;
                     POS 78,0.1                  ;
                     SIZE 10,1                   ;
                     ATYPE 3                     ;
                     ICON1 101                   ;
                     ICON2 201                   ;
                     EVENT 'save_datkom' TIPTEXT 'Ulož nastavení komunikace'

       DRGPUSHBUTTON INTO drgFC CAPTION 'Storno' ;
                     POS 89,0.1                  ;
                     SIZE 10,1                   ;
                     ATYPE 3                     ;
                     ICON1 102                   ;
                     ICON2 202                   ;
                     EVENT drgEVENT_QUIT TIPTEXT 'Ukonèi dialog ...'
     DRGEND INTO drgFC


return drgFc


method sys_asysSrvc_in:drgDialogStart(drgDialog)
  local  members    := drgDialog:oForm:aMembers
  local  x

  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dm        := drgDialog:dataManager             // dataMabanager
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::df        := drgDialog:oForm                   // form
*  ::udcp     := drgDialog:udcp                    // udcp
  *
*  ::m_parent := parent

  ::o_EBrowse := drgDialog:dialogCtrl:obrowse[1]

  for x := 1 TO LEN(members) step 1
    if members[x]:ClassName() = 'drgPushButton'
      if( ischaracter(members[x]:event), ::obtn_save_datkom := members[x], nil)
    endif
  next

*  ::drgPush:oXbp:setFont(drgPP:getFont(5))
*  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

  ::pa_isOk_datkom := {}

return self


method sys_asysSrvc_in:postValidate(drgVar)
  local  name    := Lower(drgVar:name), value := allTrim(drgVar:get()), changed := drgVAR:changed()
  local  x_value := allTrim(value)
  local  lok     := .t.
  local  aSvc
  local  ardef   := ::o_EBrowse:ardef
  local  n_driveType, c_device, c_service

  do case
  case( name = 'asyssrvc->cmachine' )
    do case
    case empty(value)
      ::msg:writeMessage( 'Zaøízení kde je služba spuštena, je povinný údaj ...', DRG_MSG_ERROR)
      lok := .f.

    case asysSrvc->( dbseek( upper( value),,'ASYSSRVC02'))
      ::msg:writeMessage('Vámi zdaném zaøízení _' +x_value +'_ již existuje v seznamu aktivních služeb ...', DRG_MSG_ERROR )
      lok := .f.

    otherwise
      ::msg:writeMessage( 'Momet prosím, testuji stav zadaného zaøízení ...', DRG_MSG_INFO )
      aSvc := aGetActiveServices(value)

      if len(aSvc) = 0
        ::msg:writeMessage('Na Vámi zdaném zaøízení _' +x_value +'_ nelze spuštìt služby ...', DRG_MSG_ERROR )
        lok := .f.
      else
        sleep(20)
        ::msg:WriteMessage(,0)
      endif
    endcase

    if lok
      n_driveType := nGetDriveType(value)
      c_device    := ''

      do case
      case ( n_driveType = DRIVE_FIXED  )
        c_device := 'LOCAL'                                                     // Lokální zaøízení, hard disk, flash,disk ...
      case ( n_driveType = DRIVE_NO_ROOT_DIR .or. n_driveType = DRIVE_REMOTE )
        c_device := if( left(value,2) = '\\', subStr(value,3), value )          //  Síové zaøízení ... UNC
      endcase

      c_service := ::dm:get( 'asysSrvc->cservice' )
      c_service := subStr( c_service,1,rat('_', c_service )) +c_device
      ::dm:set( 'asysSrvc->cservice', c_service )

      npos := ascan(ardef, {|a| a.drgEdit = drgVar:odrg })
      if( npos <> 0, ::o_EBrowse:oxbp:colPos := npos, nil )
    endif

  endcase
return lok


method sys_asysSrvc_in:itemMarked(a,b,c)

  ::pa_isOk_datkom := {}
  ::readSections()
return self


* zatím podporujeme SEL_DIR  ... výbìr adresáøe
*                   SEL_FILE ... výbìr souboru
method sys_asysSrvc_in:sel_dialog()
  local  in_Dir, cc := 'Výbìr jednotky služby A++_service ...'
  local  pa

  in_Dir := BrowseForFolder( , cc, BIF_RETURNONLYFSDIRS )

  if .not. empty(in_Dir)
    pa := listAsArray( in_Dir, '\' )

    if left( in_Dir, 2 ) = '\\'
      cdrive := left( in_Dir, 2) +pa[3]
    else
      cdrive := in_Dir
    endif

*    datkomusw->cvalue := in_Dir
*    PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE,'0',::drgDialog:lastXbpInFocus)
//    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,::drgDialog:lastXbpInFocus)
  endif
return .t.


* zatím podporujeme SEL_DIR  ... výbìr adresáøe
*                   SEL_FILE ... výbìr souboru
method sys_asysSrvc_in:sel_path()
  local  in_Dir, cc := 'Výbìr cesty kde bude umístnìna služba A++_service ...'
  local  pa
  local  aFilter := { {"A++ Service install", "A++*.EXE;ASYSTEM++.INI"}}


//  in_Dir := BrowseForFolder( , cc, BIF_RETURNONLYFSDIRS )



  in_Dir := BrowseForFolder( , cc, BIF_RETURNONLYFSDIRS )
  ::dm:set( 'asysSrvc->cpath'   , in_Dir                )
//  in_Dir := seldir(aFilter,,,,,.f.)

*    datkomusw->cvalue := in_Dir
*    PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE,'0',::drgDialog:lastXbpInFocus)
//    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,::drgDialog:lastXbpInFocus)

return .t.


method sys_asysSrvc_in:instSRV()
  local cMessage
  local lOk

  lOk := ::oCtrl:install( AllTrim(asysSrvc->cservice))
  cMessage := if( lOk, "služba byla nainstalována...", "služba nebyla nainstalována..." )
  MsgBox( cMessage )

return .t.


method sys_asysSrvc_in:startSRV()
  local cMessage
  local lOk
  local cServiceName

  lOk := ::oCtrl:start( AllTrim(asysSrvc->cservice ))
  cMessage := if( lOk, "služba byla spuštìna...", "služba nebyla spuštìna..." )
  MsgBox( cMessage )

return .t.


method sys_asysSrvc_in:stopSRV()
  local cMessage
  local lOk
  local cServiceName

  lOk := ::oCtrl:stop( AllTrim(asysSrvc->cservice ))
  cMessage := if( lOk, "služba byla zastavena...", "služba nebyla zastavena..." )
  MsgBox( cMessage )

return .t.


method sys_asysSrvc_in:uninstalSRV()
  local cMessage
  local lOk
  local cServiceName

  lOk := ::oCtrl:uninstall( AllTrim(asysSrvc->cservice ))
  cMessage := if( lOk, "služba byla odinstalována...", "služba nebyla odinstalována..." )
  MsgBox( cMessage )

return .t.


method sys_asysSrvc_in:removeSRV()
  local cMessage
  local lOk
  local cServiceName

  lOk := ::oCtrl:removeByName( AllTrim(asysSrvc->cservice ))
  cMessage := if( lOk, "služba byla odstranìna...", "služba nebyla odstranìna..." )
  MsgBox( cMessage )

return .t.

method sys_asysSrvc_in:stavSRV()
  local cMessage
  local lOk
  local cServiceName
  local oSt

  oSt := ::oCtrl:getUpdatedControl( AllTrim(asysSrvc->cservice ))
  cMessage := "Stav : " + oSt:currentState
  MsgBox( cMessage )

return .t.