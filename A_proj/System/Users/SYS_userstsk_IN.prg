#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "dll.ch"
#include "dmlb.ch"

#include 'ot4xb.ch'

#include "..\Asystem++\Asystem++.ch"
#include "..\A_main\WinApi_.ch"

#include "service.ch"


*
** vazba asystem->nrunTask                            -> usersTsk->nstateTsk
*        1 - úloha  spouštìná na Asystem++            ->         ->1
*        2 - služba spouštìná na A++_service_task     ->         ->2
*        3 - úloha na Asystem++ i na A++_service_task ->         ->1 i 2
**
*

#define SC_MANAGER_ENUMERATE_SERVICE  0x0004
#define SC_ENUM_PROCESS_INFO          0
#define SERVICE_DRIVER                0x0000000B
#define SERVICE_WIN32                 0x00000030
#define SERVICE_ACTIVE                0x00000001
#define ERROR_MORE_DATA               234


static function setCursorPos( nX, nY)
  DllCall( "user32.dll", DLL_STDCALL, "SetCursorPos", nX, nY)
return nil

static function getWindowPos(o)
   LOCAL nLeft       := 0
   LOCAL nTop        := 0
   LOCAL nRight      := 0
   LOCAL nBottom     := 0
   LOCAL cBuffer     := Space(16)
   LOCAL aObjPosXY   := {nil,nil}

   DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", o:GetHwnd(), @cBuffer)

   nLeft    := Bin2U(substr(cBuffer,  1, 4))
   nTop     := Bin2U(substr(cBuffer,  5, 4))
   nRight   := Bin2U(substr(cBuffer,  9, 4))
   nBottom  := Bin2U(substr(cBuffer, 13, 4))

   aObjPosXY[1]  := nLeft
   aObjPosXY[2]  := nTop
RETURN(aObjPosXY)


//
function aGetActiveServices(lpMachineName)
*   local hSc :=  @advapi32:OpenSCManagerA( '\\MISSSW-SERVER01', 0, SC_MANAGER_ENUMERATE_SERVICE)
*   local hSc :=  @advapi32:OpenSCManagerA( 0, 0, SC_MANAGER_ENUMERATE_SERVICE)
   local hSc
   local lResult
   local pData,cbData
   local nRH      := 0  // Resume Handle
   local cbNeeded := 0
   local nSvcCnt  := 0
   local lLoop    := .T.
   local aSvc     := {}
   local n,ns

   default lpMachineName to 0

   if( nGetDriveType(lpMachineName) = DRIVE_FIXED, lpMachineName := 0, nil )

   hSc :=  @advapi32:OpenSCManagerA( lpMachineName, 0, SC_MANAGER_ENUMERATE_SERVICE)

   if( hSc == 0 )
      return {}
   end


   cbData := 0x10000
   pData  := _xgrab(cbData)

   while lLoop
      nSvcCnt  := 0
      lResult := ( @advapi32:EnumServicesStatusExA( hSc,SC_ENUM_PROCESS_INFO,;
                   nOr(SERVICE_DRIVER,SERVICE_WIN32),SERVICE_ACTIVE,pData,cbData,;
                   @cbNeeded,@nSvcCnt,@nRH,0) != 0 )

      lLoop := (nFpGetLastError() == ERROR_MORE_DATA)

      if( lResult .or. lLoop )
         ns := 0
         for n := 1 to nSvcCnt
            aadd( aSvc , PeekDWord(pData,@ns, 11) )
            aSvc[-1][1] := PeekStr(aSvc[-1][1],,-1)
            aSvc[-1][2] := PeekStr(aSvc[-1][2],,-1)
         next
      end

      if lLoop .and. ( cbNeeded > cbData )
          _xfree( pData ); cbData := cbNeeded ; pData  := _xgrab(cbData)
      end
   end

   _xfree( pData )
   @advapi32:CloseServiceHandle(hSc)
return aSvc

function cGetComputerName() // ... NetName() like the CAToolsIII
   local cn := ChrR(0,256)
   local cb := 255

   @kernel32:GetComputerNameA(@cn,@cb)
return TrimZ(cn)
//



*  Konfigurace - Naplánované úlohy
** CLASS for SYS_userstsk_IN ******************************************************
CLASS SYS_userstsk_IN FROM drgUsrClass
EXPORTED:
  *
  ** název promìnné pro sekci komunikace + vazba na okolí pøi volání ASys_Komunik(typ,::drgdialog)
  var     csection, mDefin_kom, odata, tmp_Dir

  METHOD  itemMarked
  METHOD  init, drgDialogStart, postValidate
  METHOD  comboBoxInit, comboItemSelected
  METHOD  onSave
  METHOD  deleteTSK
  *
  METHOD  sel_datkomhd_usr, set_asysSrvc_in

  inline method set_lisAktivni()
    local oicon   := XbpIcon():new():create()

    if usersTsk->( sx_Rlock()) .and. AsysSem->(sx_Rlock())
      usersTsk->lAktivni := .not. userstsk->lAktivni
      usersTsk->( dbUnlock(), dbcommit())

      AsysSem->nstate    := 2
      AsysSem->ddate_Mod := date()
      AsysSem->ctime_Mod := time()
      AsysSem->( dbunlock(), dbCommit())

      oicon:load( NIL, if( usersTsk->lAktivni, MIS_ICON_CHECK, 0 ))
      ::obtn_set_lisAktivni:oxbp:setImage( oicon )

      PostAppEvent(xbeBRW_ItemMarked,,, ::brow:oXbp)
    endif
    return self


  inline method radioItemSelected(drgRadio)
    local  cname    := lower( drgParseSecond(drgRadio:name,'>') )
    local  runTask  := asystem->nrunTask
    local  stateTsk := drgRadio:value

    do case
    case ( cname = 'ntyprun' )
      ::showGroup()

    case ( cname = 'nstateTsk')
      do case
      case runTask = 1  ;  drgRadio:refresh( 1 )
      case runTask = 2  ;  drgRadio:refresh( 2 )
      endcase

    endcase
  return self
  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    local  lastDrg := ::df:oLastDrg, isBlocked := .f.
    local  apos_cmb, asize_cmb, apos

    DO CASE
    case nevent = xbeBRW_ItemMarked
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0

      if(isobject(::brow), ::brow:oxbp:hilite(), nil)
      ::enableOrDisable_Action()
      ::restColor()
      return .F.

    CASE nEvent = drgEVENT_EDIT
      if .not. usersTsk->( eof())
        ::state := 1
        ::brow:oxbp:refreshCurrent():DeHilite()
        ::df:setNextFocus( 'usersTsk->ctypTask', .t., .t. )
      endif
      return .t.

    CASE nEvent = drgEVENT_DELETE
*      ::deleteFRM()
      Return .T.

    CASE nEvent = drgEVENT_APPEND
      ::state := 2
      ::dm:refreshAndSetEmpty( 'usersTsk' )
      ::brow:oxbp:refreshCurrent():DeHilite()

      ::dm:set( 'usersTsk->ntypRun'  , 1      )
      ::dm:set( 'usersTsk->nstateTsk', 1      )
      ::dm:set( 'userstsk->dtskBegin', date() )
      ::dm:set( 'userstsk->ctskBegin', time() )
      ::df:setNextFocus( 'usersTsk->ctypTask', .t., .t. )

      ::showGroup()

      apos_cmb  := getWindowPos( ::ocmb_typTask:oxbp )
      asize_cmb := ::ocmb_typTask:oxbp:currentSize()
      apos     := { apos_cmb[1] +asize_cmb[1]/2, apos_cmb[2] +10 }

      setCursorPos( apos[1], apos[2] )
      return .t.

    CASE nEvent = drgEVENT_APPEND2
      Return .T.

    CASE nEvent = xbeP_Keyboard
      * blokování položek - pouze výbìr na F4,nebo BUTTOn
      if lastDrg:className() = 'drgGet'
        do case
        case(lower(lastDrg:name) = 'userstsk->cnameobj')  ;  isBlocked := .t.
        endcase

        if isBlocked .and. (mp1 >= 32 .and. mp1 <= 255)
          return .t.
        endif
      endif

      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        ::state := 0
        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
          oXbp:setColorBG( oXbp:cargo:clrFocus )
        ENDIF

        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
        IF(::state = 2, ::brow:oXbp:GoTop():refreshAll(), ::brow:refresh())
 **       ::enable_or_disable_GETs()
        ::dm:refresh()
*        ::showGroup()
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.
  *
  inline method modi_memvar(o,on_off)

    if ismembervar(o,'groups') .and. .not. empty(o:groups)
      if(on_off, o:oxbp:show(), o:oxbp:hide())
      if( ismembervar(o,'obord') .and. isobject(o:obord))
        if(on_off, o:obord:show(), o:obord:hide())
      endif

      if( ismembervar(o, 'oVar') .and. isobject(o:oVar))
         o:isEdit := on_off
       endif

      if( ismembervar(o,'pushGet') .and. isobject(o:pushGet))
         if(on_off, o:pushGet:oxbp:show(), o:pushGet:oxbp:hide())
      endif
    endif
    return nil
  *
  inline method sys_asystem_sel(parent)
    local oDialog, nExit
    local cfilter := "nrunTask = 1 .or. nrunTask = 2 .or. nrunTask = 3"

    asystem->( ads_setAof( cfilter ), dbgoTop() )

    DRGDIALOG FORM 'SYS_asystem_TSK_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

    asystem->( ads_clearAof() )

   if nExit != drgEVENT_QUIT
     ::dm:set( 'usersTsk->cnameObj'  , asystem->cnameObj  )
     ::dm:set( 'usersTsk->cidObject' , asystem->cidObject )
     ::dm:set( 'usersTsk->ctypObject', asystem->ctypObject)
     ::dm:set( 'usersTsk->czkrObject', asystem->czkrObject)
     ::dm:set( 'usersTsk->cprgObject', asystem->cprgObject)

     ::dm:set( 'usersTsk->cnameTask', asystem->cnameObj   )
     ::dm:set( 'usersTsk->nstateTsk', if(asystem->nrunTask = 2, 2, 1) )

   endif
   return (nExit != drgEVENT_QUIT)

HIDDEN:
  VAR     state      // 0 - inBrowse  1 - inEdit  2 - inAppend
  VAR     msg, dm, df, ab, brow, nbro_Focus, pa_GETs
  var     ocmb_typTask, ocmb_machine
  var     orb_typRun, orb_stateTsk
  var     orb_typRun_service, orb_typRun_service_caption
  *
  var     obtn_sel_datkomhd_usr, obtn_set_asysSrvc, obtn_set_lisAktivni, obtn_info_stavUlohy
  VAR     defOpr
  var     paGroups, pa_typRun

  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
  return


  inline method showGroup()
    local  members   := ::df:aMembers
    *
    local  paGroups  := ::paGroups, npos
    local  pa_typRun := ::pa_typRun
    local  typRun    := ::orb_typRun:value

    npos := ascan( pa_typRun, { |x| x[1] = typRun } )

    aeval(members,{|o| ::modi_memvar(o,.f.)})    // off
    if npos <> 0
      members := pa_typRun[npos,3]
      aeval(members,{|o| ::modi_memvar(o,.t.)}) // on
    endif
  return nil


  inline method enable_or_disable_GETs()
    local  isEdit := ( .not. usersTsk->( eof()) .or. ::state = 2 )
    local  pa     := ::pa_GETs, x

    for x := 1 to len(pa) step 1
      pa[x,1]:isEdit := isEdit

      if pa[x,1]:className() = 'drgRadioButton'
        aeval( pa[x,1]:members, { |o| if( isEdit, o:enable(), o:disable() ) } )
      else
        if( isEdit, pa[x,1]:oxbp:enable(), pa[x,1]:oxbp:disable() )
      endif
    next
  return self


  inline method enableOrDisable_Action()
    local mDefin_kom
    local oicon_datkomHd := XbpIcon():new():create()
    local oicon_asysSrvc := XbpIcon():new():create()
    local obitMap := XbpBitMap():new():create()
    local c_caption, pa_gradient

    asystem ->( dbseek( usersTsk->cidObject,,'ASYSTEM04' ))
    datkomHd->( dbseek( asystem->cidDatKom ,,'DATKOMH01' ))

    mDefin_kom := datKomhd->mdefin_kom

    if isObject(::obtn_sel_datkomhd_usr) .and. ;
       isObject(::obtn_set_asysSrvc    ) .and. ;
       isObject(::obtn_set_lisAktivni  ) .and. ;
       isObject(::obtn_info_stavUlohy  )

      if empty(mDefin_kom)
        oicon_datkomHd:load( nil, gDRG_ICON_QUIT)

        ::obtn_sel_datkomhd_usr:disable()
        ::obtn_sel_datkomhd_usr:oxbp:setImage( oicon_datkomHd )
        ::obtn_sel_datkomhd_usr:oxbp:hide()

        ::obtn_set_lisAktivni:oxbp:enable()
      else
        if( empty(usersTsk->mDefin_kom), ::obtn_set_lisAktivni:oxbp:disable(), ;
                                         ::obtn_set_lisAktivni:oxbp:enable()   )

        oicon_datkomHd:load( NIL, if( empty(usersTsk->mDefin_kom), MIS_ICON_ATTENTION, MIS_ICON_CHECK ))

        ::obtn_sel_datkomhd_usr:oxbp:show()
        ::obtn_sel_datkomhd_usr:enable()
        ::obtn_sel_datkomhd_usr:oxbp:setImage( oicon_datkomHd )
      endif

      * BUTT služby
      oicon_asysSrvc:load( NIL, if( asysSrvc->(eof()), MIS_ICON_ATTENTION, MIS_ICON_CHECK ))
      ::obtn_set_asysSrvc:oxbp:setImage( oicon_asysSrvc )

      * RADIO A++_service
      ::orb_typRun_service:setCaption( ::orb_typRun_service_caption +'_' +allTrim(usersTsk->cdevice) )

      do case
      case empty(usersTsk->mDefin_kom) .and. .not. empty(mDefin_kom)
        pa_gradient := { 0, 7 }
        c_caption   := 'úlohu nelze aktivovat, nutno nastavit parametry'

      otherwise
        if usersTsk->lAktivni
          pa_gradient := { 0, 5 }
          c_caption   := 'úloha je aktivní'
        else
          pa_gradient := { 0, 3 }
          c_caption   := 'úloha není aktivní'
        endif
      endcase
      ::obtn_info_stavUlohy:oxbp:setFont(drgPP:getFont(7))
      ::obtn_info_stavUlohy:oxbp:gradientColors := pa_gradient
      ::obtn_info_stavUlohy:oxbp:setCaption( c_caption )

      obitMap:load( ,if( usersTsk->laktivni, MIS_CHECK_BMP, MIS_NO_RUN ))
      obitmap:TransparentClr := obitmap:GetDefaultBGColor()

      ::obtn_set_lisAktivni:oxbp:setImage( obitMap )
    endif
  return self


  inline method new_cisTask()
    local  new_ncisTask
    local  typTask := ::ocmb_typTask:value
    local  cfiltr

    cfiltr := Format("ctypTask = '%%'", {typTask})
    usersTsk_A->( ordSetFocus('USERSTSK01'), ads_setAof(cfiltr), dbgoBottom() )
    new_ncisTask := usersTsk_A->ncisTask +1

    usersTsk_A->( ads_clearAof())
  return new_ncisTask

ENDCLASS


method SYS_userstsk_IN:init(parent)
  ::drgUsrClass:init(parent)

  set path to '\\MISSSW-SERVER01'
    oCtrl := ServiceController()
    pa := oCtrl:queryAllServiceNames()
  set path to

  drgDBMS:open('usersTsk')
  drgDBMS:open('usersTsk',,,,,'usersTsk_A')

  drgDBMS:open('users'    )
  drgDBMS:open('asystem'  )
  drgDBMS:open('AsysSem'  )
  AsysSem->( dbseek( 'USERSTSK  ',,'AsysSem_1'))

  drgDBMS:open('datkomHd' )
  drgDBMS:open('C_OPRAVN' )

  drgDBMS:open('asysSrvc' )
  drgDBMS:open('usrTsLog')

  ::defOpr  := defaultDisUsr('UsersTsk','CID')
  ::tmp_Dir := drgINI:dir_USERfitm +userWorkDir() +'\'
RETURN self


method SYS_userstsk_IN:drgDialogStart(drgDialog)
  local  x, members  := drgDialog:oForm:aMembers
  local  odrg, className, groups, pa, npos,ev, caption
  *
  ::msg          := drgDialog:oMessageBar             // messageBar
  ::dm           := drgDialog:dataManager             // dataManager
  ::df           := drgDialog:oForm                   // form
  ::ab           := drgDialog:oActionBar:members      // actionBar

  ::pa_GETs      := {}
  pa             := ::pa_typRun  := { { 1, 'PER', {}}, { 2, 'DEN', {}}, { 3, 'TYD', {}}, { 4, 'MES', {}}, { 5, 'KAL', {}} }

  ::ocmb_typTask := ::dm:has('usersTsk->ctypTask' ):odrg
  ::orb_typRun   := ::dm:has('usersTsk->ntypRun'  ):odrg
  ::orb_stateTsk := ::dm:has('usersTsk->nstateTsk'):odrg
  ::ocmb_machine := ::dm:has('usersTsk->cmachine' ):odrg

  for x := 1 TO LEN(members) step 1
    odrg      := members[x]
    className := members[x]:className()
    groups := if( ismembervar(odrg, 'groups'), isnull(members[x]:groups,''), '')

    do case
    case members[x]:ClassName() = 'drgDBrowse'
      ::brow       := members[x]
      ::nbro_Focus := x
    case isMemberVar(members[x], 'isEdit')
      if( members[x]:isEdit, aadd( ::pa_GETs, { members[x], x } ), nil )
    endcase

    if( className = 'drgPushButton' .and. odrg:event = 'info_stavUlohy' )
      ::obtn_info_stavUlohy        := oDrg
      ::obtn_info_stavUlohy:isEdit := .f.
      ::obtn_info_stavUlohy:oxbp:disable()
    endif

    if( className = 'drgRadioButton' .and. lower(odrg:name) = 'userstsk->nstatetsk' )
      ::orb_typRun_service         := odrg:members[2]
      ::orb_typRun_service_caption := ::orb_typRun_service:caption + '_' +strZero(usrIDdb,6)
      ::orb_typRun_service:setCaption( ::orb_typRun_service_caption )
    endif

    if( npos := ascan( pa, { |x| x[2] = groups })) <> 0
      aadd(::pa_typRun[npos,3], odrg )
    endif
  next

  for x := 1 to len(::ab) step 1
    ev := lower( isNull( ::ab[x]:event, ''))
    do case
    case  ev = 'sel_datkomhd_usr' ; ::obtn_sel_datkomhd_usr := ::ab[x]
    case  ev = 'set_asysSrvc_in'  ; ::obtn_set_asysSrvc     := ::ab[x]
    case  ev = 'set_lisAktivni'   ; ::obtn_set_lisAktivni   := ::ab[x]
    endCase
  next

  ::orb_typRun:value := ::orb_stateTsk:value := 0
  ::showGroup()

RETURN self


method sys_usersTsk_in:comboBoxInit(drgComboBox)
  local  cname := lower( drgParseSecond(drgComboBox:name,'>') )
  local  acombo_val := {}, npos
  local  defOpr     := ::defOpr, pa, pi
  *
  local  c_machine, n_driveType, c_device

  do case
  case ( cname = 'ctyptask' )
    pa := listAsArray( defOpr, ',' )
    for x := 1 to len(pa) step 1
      pi := listAsArray( pa[x], ':' )
      aadd( acombo_Val, { pi[1], pi[2] } )
    next

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  case ( cname = 'cuser' )
    users->( dbeval( { || aadd( acombo_Val, { users->cuser, if( empty(users->cosoba), 'Administráror A++', users->cosoba ) } ) } ))

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value := logUser

  case ( cname = 'cmachine' )
    aadd( acombo_Val, { space(50), 'Zaøízení pro spuštení služby není definováno...' } )

    asysSrvc->( dbgoTop())
    do while .not. asysSrvc->( eof())
      c_machine   := allTrim( asysSrvc->cmachine )
      n_driveType := nGetDriveType(c_machine)
      c_device    := ''

      do case
      case ( n_driveType = DRIVE_FIXED  )
        c_device := 'LOCAL'                                                        // Lokální zaøízení, hard disk, flash,disk ...
      case ( n_driveType = DRIVE_NO_ROOT_DIR .or. n_driveType = DRIVE_REMOTE )
        c_device := if( left(c_machine,2) = '\\', subStr(c_machine,3), c_machine ) //  Síové zaøízení ... UNC
      endcase

      aadd( acombo_Val, { asysSrvc->cmachine, c_machine, c_device } )
      asysSrvc->( dbskip())
    enddo
    asysSrvc->( dbgoTop())

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  endcase
return self


method sys_usersTsk_in:comboItemSelected(drgComboBox)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  cname := lower(drgComboBox:name)

  do case
  case(cname = 'userstsk->cmachine' )
    if( nIn := ascan(values, {|X| X[1] = value })) <> 0
      ::dm:set( 'usersTsk->cdevice', values[nIn,3] )
    endif
  endcase
return self


method sys_usersTsk_in:itemMarked()
  local cfiltr

  if usersTsk->( RecCount()) <> 0
    asystem ->( dbseek( usersTsk->cidObject,,'ASYSTEM04' ))
    datkomHd->( dbseek( asystem->cidDatKom ,,'DATKOMH01' ))

    cfiltr := Format("nusersTsk = %%", {usersTsk->sid})
    usrTsLog->( ADS_SetAOF( cfiltr))

    ::dm:refresh()
    ::showGroup()
  endif

return self


method sys_usersTsk_in:postValidate(drgVar,lSelected, oxbp)
  Local  lOk  := .T., lValue, c_fileW
  *
  local  value      := drgvar:value      , ;
         name       := Lower(drgVar:name), ;
         field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  odrg, members, npos
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  default lSelected TO .F.

  do case
  case( field_name = 'cnameobj' )
    if( empty(value), lok := ::sys_asystem_sel(self), nil )

  case( field_name = 'nstatetsk' )
    lok := ( value <= asystem->nrunTask )

  endcase
return lOk


method SYS_userstsk_IN:deleteTSK
  local ok := .f.

*   ok := if( At('DIST', ::defOpr) > 0, .t., (forms->ctypforms = 'USER') )

   if ok
*     if forms->( dbRlock())
*       if drgIsYESNO(drgNLS:msg('Opravdu požadujete zrušit vybranou sestavu ?'))
*         forms->( dbDelete())
*         ::dctrl:oBrowse[1]:refresh(.T.)
*         ::verifyActions()
*         ::dctrl:oBrowse[2]:refresh(.T.)
*         ::dctrl:oBrowse[3]:refresh(.T.)
*       endif
*       forms->( dbUnlock())
*     endif
   else
     drgNLS:msg('Nemáte oprávnìní rušit !!!')
   endif
return


method sys_userstsk_in:sel_datkomhd_usr()
  local  idDatKom
  local  m_datKomhd_Defin_kom, ctypDatKom
  *
  local  oDialog, nExit := drgEVENT_QUIT

  ::csection   := ''   // datkom  E - export, I - import
  ::mDefin_kom := ''

  asystem ->( dbseek( usersTsk->cidObject,,'ASYSTEM04' ))

  if datkomHd->( dbseek( asystem->cidDatKom ,,'DATKOMH01' ))
    ctypDatKom           := upper(datkomhd->ctypDatKom)
    m_datKomhd_Defin_kom := upper(datkomhd->mDefin_kom)

    if     ctypDatKom = 'I'
      ::csection := if( at( '[DATKOMI]', m_datKomhd_Defin_kom) <> 0, 'datkomi', 'import' )
    elseif ctypDatKom = 'E'
      ::csection := if( at( '[DATKOME]', m_datKomhd_Defin_kom) <> 0, 'datkome', 'export' )
    endif

    cc           := strTran( datkomhd->mDefin_kom, 'Users', 'Users_' +::csection )
    ::mDefin_kom += cc +CRLF +CRLF
  endif
  *
  ** pokud adresáø neexistuje musíme ho založit
  myCreateDir( ::tmp_Dir )
    sName  := ::tmp_Dir +datkomhd->cidDatKom +'.usr'
    memoWrit( sName, usersTsk->mDefin_kom )

  oDialog := drgDialog():new('SYS_DATKOMHD_USR', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  if nExit = drgEVENT_SELECT
    if usersTsk->(sx_rLock())
      usersTsk->mDefin_kom := memoRead(sName)
      usersTsk->mdatKom_us := odialog:udcp:m_datKom_us

      usersTsk->( dbUnlock(), dbCommit())
    endif

    ::enableOrDisable_Action()
  endif

  odialog:destroy()
  odialog := nil
return self


method sys_userstsk_in:set_asysSrvc_in()
  local  oDialog, nExit := drgEVENT_QUIT

  oDialog := drgDialog():new('SYS_asysSrvc_IN', ::drgDialog)
  oDialog:create(,,.T.)

  odialog:destroy()
  odialog := nil

  ::comboBoxInit(::ocmb_machine, .t.)
  ::ocmb_machine:value := '???'
  ::ocmb_machine:refresh( usersTsk->cmachine )


  ::enableOrDisable_Action()
return self


method sys_userstsk_in:onSave()
  local lok_Sem := AsysSem->(sx_Rlock()), lok_Tsk := .t.
  local perRun
  local newRec := ( ::state = 2 )
  *
  if( newRec, usersTsk->( dbAppend()), lok_Tsk := usersTsk->(sx_Rlock()) )

  if lok_Sem .and. lok_Tsk
    ::dm:save()

    if newRec
      usersTsk->ncisTask := ::new_cisTask()
      usersTsk->cidTask  := usersTsk->ctypTask + strZero(usersTsk->ncisTask,6)
    endif

    usersTsk->cidObject  := ::dm:get( 'usersTsk->cidObject' )
    usersTsk->ctypObject := ::dm:get( 'usersTsk->ctypObject')
    usersTsk->czkrObject := ::dm:get( 'usersTsk->czkrObject')
    usersTsk->cprgObject := ::dm:get( 'usersTsk->cprgObject')
    usersTsk->cdevice    := ::dm:get( 'usersTsk->cdevice'   )

    do case
    case usersTsk->ntypRun = 1
      usersTsk->nperRun  := ( usersTsk->nPerioda/86400)

    case usersTsk->ntypRun = 2
      usersTsk->nperRun  := 1
      usersTsk->nPerioda := 86400

    case usersTsk->ntypRun = 3
      usersTsk->nperRun  := 7
      usersTsk->nPerioda := 86400
    endcase

    usersTsk->(dbUnlock(), dbcommit())

    AsysSem->nstate    := if( newRec, 1, 2)
    AsysSem->ddate_Mod := date()
    AsysSem->ctime_Mod := time()
    AsysSem->( dbunlock(), dbCommit())

    SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
    if(::state = 2, ::brow:oXbp:refreshAll(), ::brow:refresh())
    ::state := 0
  endif
RETURN .T.