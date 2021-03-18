#include "Common.ch"
#include "service.ch"

#include "..\Asystem++\Asystem++.ch"

#include "dll.ch"

#xtranslate  .dplatnyOd     =>  \[ 1\]
#xtranslate  .dplatnyDo     =>  \[ 2\]
#xtranslate  .njd_tskBegin  =>  \[ 3\]
#xtranslate  .njd_tskDenBeg =>  \[ 4\]
#xtranslate  .njd_tskDenEnd =>  \[ 5\]
#xtranslate  .ctypObject    =>  \[ 6\]
#xtranslate  .cprgObject    =>  \[ 7\]
#xtranslate  .ntypRun       =>  \[ 8\]
#xtranslate  .nperRun       =>  \[ 9\]
#xtranslate  .pa_mDatkom_us =>  \[10\]
#xtranslate  .is_tskRun     =>  \[11\]
#xtranslate  .dtskBegin     =>  \[12\]
#xtranslate  .ctskBegin     =>  \[13\]
#xtranslate  .dtskDenBeg    =>  \[14\]
#xtranslate  .ctskDenBeg    =>  \[15\]
#xtranslate  .dtskDenEnd    =>  \[16\]
#xtranslate  .ctskDenEnd    =>  \[17\]
#xtranslate  .nPerioda      =>  \[18\]
#xtranslate  .nSID          =>  \[19\]

#ifndef  ESC
#define ESC        Chr(27)
#endif

#ifndef  CRLF
#define CRLF       Chr(13) + Chr(10)
#endif

#ifndef  TAB
#define TAB        Chr(09)
#endif


// #ifdef __WIN32__
/*
 * these defines must be equal to the defines of the Win32-SDK
 */
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

// pokud úloha bìží a z nìjakých dùvodù nebyla ukonèena, nemá cenu ji startovat znovu
// ale jak se mùže stát, že nebyla ukonèena
// pro FCE_... - no tohle nevím, asi se to nìkde kouslo, co s tím
// pro FRM_... - si nechal otevøené okno a asi v nìm pracuje


*
** Entry point of application
PROCEDURE Main()
  public syApa := 'V73ra5-xWdeYa46í8øK2'
  public drgDBMS, oSession_sys, oSession_data, oSession_free

  Aservice():start()

RETURN


*
**** základní tøída pro spuštìní služby ****************************************
CLASS Aservice From ServiceApp
  EXPORTED:
    CLASS METHOD main
    *
    ** Entry point for service stop request
    INLINE CLASS METHOD stop()

//      dbCloseAll()

//      if( isObject(oSession_sys) , oSession_sys:disconnect() , nil )
//      if( isObject(oSession_free), oSession_free:disconnect(), nil )
//      if( isObject(oSession_data), oSession_data:disconnect(), nil )

      ::terminated  := .T.

    return self

  HIDDEN:
    CLASS VAR lRunning
    class var pa_Task_list, is_createTask, ddate_Mod, ctime_Mod, terminated
    class var nusrIdDB, cdevice

/*
    *  A++_service_112801_LOCAL - vzor
    inline class method connect_to_dataSource(cserviceName, dirRoot)
      local  cadd_file, cConnect, lok := .f.
      local  iniFile
      local  pa

      pa         := listAsArray( cserviceName,'_' )
      ::nusrIdDB := 0
      ::cdevice  := ''

      if len(pa) = 4
        if( len(pa[3]) = 6, ::nusrIdDB := val(pa[3]), nil )
        ::cdevice := allTrim(pa[4])
      endif

      if ( ::nusrIdDB <> 0 .and. .not. empty(::cdevice) )
        * 1 - DBD
        iniFile := dirRoot + 'Asystem++.ini'
        drgReadINI( iniFile)   // A++_service.ini
        dclDefaultInitVars()

        drgRef  := drgRef():new()
        drgDBMS := drgDBMS():new()
        drgDBMS:loadDBD()

        * connect to the ADS server systémová èást
        cConnect      := "DBE=ADSDBE;SERVER="  +AllTrim(drgINI:dir_SYSTEM) +";"
        osession_Sys  := dacSession():New( cConnect)

        dbUseArea(.t., oSession_sys, drgINI:dir_SYSTEM +'licAsys',, .T.)
        licAsys->( AX_SetPass(syApa))

        nusrIdDB := ::nusrIdDB

        if licAsys->( dblocate( { || licAsys->nusrIdDB = nusrIdDB } ))

          drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim(licAsys->cdataDir) +'\Data'
          drgINI:add_FILE := 'A++_' +strZero(licAsys->nUsrIdDB,6) +'.add'

          * connect to the ADS server datová èást
          cadd_File     := drgINI:dir_DATA +'\' + drgINI:add0,_FILE
          cConnect      := "DBE=ADSDBE;SERVER="  + cadd_File +";ADS_COMPRESS_ALWAYS;"
          oSession_data := dacSession():New( cConnect)

          * connect to the ADS server uživatelská èást
          cConnect      := "DBE=ADSDBE;SERVER="  +AllTrim(drgINI:dir_WORK) +";ADS_LOCAL_SERVER" +";"
          oSession_free := dacSession():New( cConnect)

          if oSession_data:isConnected() .and. oSession_free:isConnected() .and. isObject(drgDBMS)
            lok := .t.
          endif
        endif
      else
        lok := .f.
      endif
    return lok
*/

    inline class method create_pa_Task_list()
      local cf := "(nstateTsk = 2 .and. cdevice = '%%' .and. lAktivni)"
      local filtr
      local nden
      *
      local ntypRun
      local dtskBegin  , ctskBegin  , njd_tskBegin
      local dtskDenBeg , ctskDenBeg , njd_tskDenBeg
      local dtskDenEnd , ctskDenEnd , njd_tskDenEnd
      local dplatnyOd  , dplatnyDo
      local ctypObject , cprgObject, nperRun, nPerioda, nSID
      local pa_mDatkom_us
      local is_tskRun
      local typReRun
      local pa

      ::pa_Task_list := {}

      filtr := format( cf, { ::cdevice })
      usersTsk->( ads_setAof(filtr), dbgoTop() )

      do while .not. usersTsk->( eof())
        dplatnyOd     := if( empty(usersTsk->dplatnyOd)    , date()   , usersTsk->dplatnyOd )
        dplatnyDo     := usersTsk->dplatnyDo

        dtskBegin     := if( empty(usersTsk->dtskBegin)    , date()   , usersTsk->dtskBegin )
        ctskBegin     := if( secs(usersTsk->ctskBegin) = 0 , time()   , usersTsk->ctskBegin )

        if dtskBegin < date()
          dtskBegin := date()
          ctskBegin := time()
        elseif dtskBegin = date()
          if( secs(ctskBegin) < secs(time()), ctskBegin := time(), nil )
        endif

        njd_tskBegin  := ::julianDate_Time(dtskBegin, ctskBegin)

        ctskDenBeg    := if( secs(userstsk->ctskDenBeg) = 0, '00:00:01', usersTsk->ctskBegin )     //userstsk->ctskDenBeg) úprava JT
        ctskDenEnd    := if( secs(userstsk->ctskDenEnd) = 0, '23:59:59', userstsk->ctskDenEnd)
        dtskDenBeg    := dtskBegin
        dtskDenEnd    := dtskBegin
        njd_tskDenBeg := ::julianDate_Time(dtskBegin, ctskDenBeg)
        njd_tskDenEnd := ::julianDate_Time(dtskBegin, ctskDenEnd)

        ctypObject    := AllTrim(usersTsk->ctypObject)
        cprgObject    := usersTsk->cprgObject
        ntypRun       := usersTsk->ntypRun
        nperRun       := usersTsk->nperRun
        nperioda      := usersTsk->nperioda
        nSID          := usersTsk->sid

        pa_mDatkom_us := if( empty(usersTsk->mDatkom_us), {}, listAsArray( memoTran( usersTsk->mDatkom_us,,''),';') )
        is_tskRun     := .f.
        *
        do case
        case ntypRun = 1 .or. ntypRun = 2
          pa := { dplatnyOd   , dplatnyDo                   , ;
                  njd_tskBegin, njd_tskDenBeg, njd_tskDenEnd, ;
                  ctypObject  , cprgObject   , ntypRun      , nperRun     , pa_mDatkom_us, is_tskRun, ;
                  dtskBegin   , ctskBegin    , dtskDenBeg   , ctskDenBeg  ,  ;
                  dtskDenEnd  , ctskDenEnd   , nPerioda     , nSID   }
          aadd( ::pa_Task_list, pa )

        case ntypRun = 3
          for nden := 1 to 7 step 1
            if usersTsk->( fieldGet( usersTsk->( fieldPos( 'lden' +str(nden,1)))))

              do while nden <> DoW(dtskBegin)
                dtskBegin += 1
              enddo

              njd_tskBegin  := ::julianDate_Time(dtskBegin, ctskBegin)
              njd_tskDenBeg := ::julianDate_Time(dtskBegin, ctskDenBeg)
              njd_tskDenEnd := ::julianDate_Time(dtskBegin, ctskDenEnd)
              dtskDenBeg    := dtskBegin
              dtskDenEnd    := dtskBegin

              pa := { dplatnyOd   , dplatnyDo                   , ;
                      njd_tskBegin, njd_tskDenBeg, njd_tskDenEnd, ;
                      ctypObject  , cprgObject   , ntypRun      , nperRun     , pa_mDatkom_us, is_tskRun, ;
                      dtskBegin   , ctskBegin    , dtskDenBeg   , ctskDenBeg  ,  ;
                      dtskDenEnd  , ctskDenEnd   , nPerioda     , nSID   }
              aadd( ::pa_Task_list, pa )

            endif
          next
        endcase

        typReRun := if( ::is_createTask, 2, 1)
        modi_logTask( pa, typReRun)

        usersTsk->( dbskip())
      enddo
      usersTsk->( ads_clearAof())

    return self


    inline class method julianDate_Time(dDate,cTime)
      local a,b,c,e,f, njdn, njd

      local nRok, nMes, nDen
      local nHod, nMin, nSec
      local ndeciMals := Set( _SET_DECIMALS, 5 )

      default dDate to Date(), cTime to Time()

      ( nRok := year(dDate),              nMes := month(dDate),              nDen := day(dDate)               )
      ( nHod := Val( SubStr( ctime,1,2)), nMin := Val( SubStr( ctime,4,2)),  nSec := Val( SubStr( ctime,7,2)) )

      ( a := Int(nRok/100)            , ;
        b := A/4                      , ;
        c := 2-a+b                    , ;
        e := Int(365.25 * (nRok+4716)), ;
        f := Int(30.6001* (nMes+1))     )

      njdn := c +nDen +e +f -1524.5
//      njd  := njdn + ((3600*nHod + 60*nMin+ nsec) / 43200)
      njd  := njdn + ( Round((nHod-12/24),6) + Round( nMin/1440, 6)  + Round( nsec/86400,6))

      Set( _SET_DECIMALS, ndeciMals)
    return nJd


ENDCLASS

*
** Entry point of service start
CLASS METHOD Aservice:main(aparam)
  local x, paTask, njd_Current
  local oThread, is_tskRun
  local nusrIdDBtm

   local  cadd_file, cConnect, lok := .f.
   local  pa
   local  iniFile
   local  nn, mm

   local  cKeyName, cService, cPath

//  if .not. ::connect_to_dataSource(aparam[1],aparam[2])
//    return self
//  endif

     cKeyName := "System\ControlSet001\Services\" + aparam[1]
     cService := QueryRegistrySRV( HKEY_LOCAL_MACHINE, cKeyName, "ImagePath")
     cPath    := StrTran(cService,'A++_service_task.exe','')

      pa         := listAsArray( aparam[1],'_' )
      ::nusrIdDB := 0
      ::cdevice  := ''

      if len(pa) = 4
        if( len(pa[3]) = 6, ::nusrIdDB := val(pa[3]), nil )
        ::cdevice := allTrim(pa[4])
      endif

      if ( ::nusrIdDB <> 0 .and. .not. empty(::cdevice) )
        * 1 - DBD
        iniFile := retDir( cPath) +'Asystem++.ini'
        drgReadINI( iniFile)   // A++_service.ini
        dclDefaultInitVars()

        drgRef  := drgRef():new()
        drgDBMS := drgDBMS():new()

        drgDBMS:loadDBD()

        * connect to the ADS server systémová èást
        cConnect      := "DBE=ADSDBE;SERVER="  +AllTrim(drgINI:dir_SYSTEM) +";"+AllTrim(drgINI:ads_SERVER_TYPE )+";"
        osession_Sys  := dacSession():New( cConnect)

        dbUseArea(.t., oSession_sys, drgINI:dir_SYSTEM +'licAsys',, .T.)
        licAsys->( AX_SetPass(syApa))

        nusrIdDBtm := ::nusrIdDB
        licAsys->( dblocate( { || licAsys->nusrIdDB = nusrIdDBtm } ))

        if licAsys->( dblocate( { || licAsys->nusrIdDB = nusrIdDBtm } ))

          drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim(licAsys->cdataDir) +'\Data'
          drgINI:add_FILE := 'A++_' +strZero(licAsys->nUsrIdDB,6) +'.add'

          * connect to the ADS server datová èást
          cadd_File     := drgINI:dir_DATA +'\' + drgINI:add_FILE

          cConnect      := "DBE=ADSDBE;SERVER=" + cadd_File +";ADS_COMPRESS_ALWAYS;" +AllTrim(drgINI:ads_SERVER_TYPE)+";"
          oSession_data := dacSession():New( cConnect)

          * connect to the ADS server uživatelská èást
          cConnect      := "DBE=ADSDBE;SERVER="  +AllTrim(drgINI:dir_WORK) +";ADS_LOCAL_SERVER" +";"
          oSession_free := dacSession():New( cConnect)

          if oSession_data:isConnected() .and. oSession_free:isConnected() .and. isObject(drgDBMS)
            lok := .t.
          endif
        endif
      else
        return self
      endif

  ::pa_Task_list  := {}
  ::is_createTask := .f.
  ::terminated    := .f.

  drgDBMS:open( 'AsysSem'  )
  if .not. AsysSem->( dbseek( 'USERSTSK  ',,'AsysSem_1'))
    AsysSem->( dbappend())
    AsysSem->cfile     := 'USERSTSK'
    AsysSem->nstate    := 0
    AsysSem->ddate_Mod := date()
    AsysSem->ctime_Mod := time()
    AsysSem->( dbunlock(), dbCommit())
  endif

  ::ddate_Mod := AsysSem->ddate_Mod
  ::ctime_Mod := AsysSem->ctime_Mod

  drgDBMS:open( 'usersTsk' )

  *
  ** hlavní smyèka zpacování úloh
  do while .not. ::terminated
      if( .not. ::terminated, sleep(5), nil )
      *
      ** musíme refrešnout datový buffer, jinak nepoznáme zmìnu
      AsysSem->( DbSkip(0))
      if ( ::ddate_Mod <> AsysSem->ddate_Mod .or. ::ctime_Mod <> AsysSem->ctime_Mod ) .or. .not. ::is_createTask
        ::ddate_Mod := AsysSem->ddate_Mod
        ::ctime_Mod := AsysSem->ctime_Mod

        ::create_pa_Task_list()
        ::is_createTask := .t.
      endif

      njd_Current := ::julianDate_Time()
      is_tskRun   := .f.

      for x := 1 to len(::pa_Task_list) step 1

        paTask := ::pa_Task_list[x]

        * platnost od - do
        if( (paTask.dplatnyOd <= date()) .and. (empty(paTask.dplatnyDo) .or. (paTask.dplatnyDo >= date())) )

          * datum a èas spuštìní
          if ( (paTask.njd_tskBegin <= njd_Current) .and. if( paTask.ntypRun = 1, .t., ( paTask.njd_tskDenBeg <= njd_Current .and. paTask.njd_tskDenEnd >= njd_Current ) ) )
            modi_logTask( paTask, 3)
//              drgDump( "Spuštìní úlohy aktuální èas - " + Str(njd_Current))
//              drgDump( patask)
//              drgDump( "==========================================================================")
            is_tskRun   := .t.
            do case
            case paTask.ctypObject = 'FCE_KOM'
              oThread := AserviceThread():new()
              oThread:paTask := paTask
              oThread:start()

            case paTask.ctypObject = 'FRM_SCR' .or. paTask.ctypObject = 'FRM_SCR_IN'
  *           oThread := drgDialogThread():new()
  *           oThread:start( , paTask.cprgObject, ::odrgMenu )
            endcase

            * spustili jsme úlohu
            if is_tskRun
              nn := timeSec( paTask.ctskBegin)
              mm := nn + paTask.nperioda
              if mm >= 86400
                nn := mm - 86400
                paTask.ctskBegin := secTime( nn)
                paTask.dtskBegin := paTask.dtskBegin + 1
              else
                paTask.ctskBegin := secTime( mm)
              endif

              paTask.njd_tskBegin  := ::julianDate_Time(paTask.dtskBegin, paTask.ctskBegin)
              if paTask.ntypRun <> 1
                paTask.dtskDenBeg    := paTask.dtskDenBeg + 1
                paTask.njd_tskDenBeg := ::julianDate_Time(paTask.dtskDenBeg, paTask.ctskDenBeg)

                paTask.dtskDenEnd    := paTask.dtskDenEnd + 1
                paTask.njd_tskDenEnd := ::julianDate_Time(paTask.dtskDenEnd, paTask.ctskDenEnd)

                paTask.njd_tskBegin  := paTask.njd_tskDenBeg

/*
                nn := timeSec( paTask.ctskDenBeg)
                mm := nn + paTask.nperioda
                if mm >= 86400
                  nn := mm - 86400
                  paTask.ctskDenBeg := secTime( nn)
                  paTask.dtskDenBeg := paTask.dtskDenBeg + 1
                else
                  paTask.ctskDenBeg := secTime( mm)
                endif
                paTask.njd_tskDenBeg  := ::julianDate_Time(paTask.dtskDenBeg, paTask.ctskDenBeg)

                nn := timeSec( paTask.ctskDenEnd)
                mm := nn + paTask.nperioda
                if mm >= 86400
                  nn := mm - 86400
                  paTask.ctskDenEnd := secTime( nn)
                  paTask.dtskDenEnd := paTask.dtskDenEnd + 1
                else
                  paTask.ctskDenEnd := secTime( mm)
                endif
                paTask.njd_tskDenEnd  := ::julianDate_Time(paTask.dtskDenEnd, paTask.ctskDenEnd)
//                paTask.njd_tskDenBeg := paTask.njd_tskDenBeg +paTask.nperRun
//                paTask.njd_tskDenEnd := paTask.njd_tskDenEnd +paTask.nperRun
*/

              endif
              modi_logTask( paTask, 4)

            endif
          endif
        endif
      next
  enddo
RETURN self


class AserviceThread from Thread
EXPORTED:
  var paTask, bBlock, odata_datKom

  inline method atStart()
  return self

  inline method execute()
    local  cprgObject    := ::paTask.cprgObject
    local  pa_mDatkom_us := ::paTask.pa_mDatkom_us
    local  cID_datKom    := allTrim(str(GetCurrentProcessID())) +allTrim(str(threadID()))

    local  x, pa, pa_items := {}, pa_data := {}, oClass
    local  bSaveErrorBlock := ErrorBlock( {|e| Break(e)} )
    *
    **
    for x := 1 to len(pa_mDatkom_us) step 1
      pa := listAsArray( pa_mDatkom_us[x], '=' )

      if len(pa) = 2
        aadd( pa_items, pa[1] )
        aadd( pa_data , pa[2] )
      endif
    next

    oClass         := RecordSet():createClass( "selectkom_thr_" +cID_datKom, pa_items )
    ::odata_datKom := oClass:new( { ARRAY(LEN(pa_items)) } )

    for x := 1 to len(pa_data) step 1
      ::odata_datKom:putVar( x, pa_data[x] )
    next

    ::bBlock := COMPILE( cprgObject )

    BEGIN SEQUENCE
      eval( ::bBlock )
      *
      ** chybièka se vloudila
    RECOVER using oError
      drgDump( 'Chyba pøi spuštìní úlohy ' +cprgObject )
    END SEQUENCE

    ErrorBlock(bSaveErrorBlock)
  return


  inline method atEnd()
    ::bBlock       := ;
    ::odata_datKom := NIL
  return
ENDCLASS




PROCEDURE dclUsrPublicVars()
  local oinfo, cbuild

  PUBLIC myCompanyName    := 'MISS Software, s.r.o.'
  PUBLIC myCompanyAdress1 := 'Mlýnská 1228'
  PUBLIC myCompanyAdress2 := 'Uherské Hradištì'
  PUBLIC myNumber         := 100
  PUBLIC myDate           := STOD('20050901')
  PUBLIC isDemoVersion    := .T.
  PUBLIC isWorkVersion    := .F.
  PUBLIC isdeSysLock      := .F.
  PUBLIC isRestFRM        := .T.
  PUBLIC isDataTypeDBF    := .F.
  PUBLIC syCheckDB        := 0
  PUBLIC recFirma         := 0
  PUBLIC obdReport        := ''

  PUBLIC obdKeyML         := ''

//  PUBLIC verzeAsys        := ''  //LoadResource(1, XPP_MOD_EXE, RES_VERSION)
//  PUBLIC verzeAsys        := LoadResource(1, XPP_MOD_EXE, RES_VERSION)
  PUBLIC usrName          := ''   // zkratka uživatele
  PUBLIC usrOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
  PUBLIC logFirma         := ''   // pøihlašovací jméno firmy
  PUBLIC logUser          := ''   // pøihlašovací jméno uživatele
  PUBLIC logOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
  PUBLIC logCisOsoby      := 0    // osobní èíslo pøihlášené osoby - uživatele
  PUBLIC syOpravneni      := ''

  PUBLIC SpecialBuild     := ''
  PUBLIC typPanel         := ''

// nastavení pro users.ini
  PUBLIC visualStyle      := .f.


//  oinfo  := TFileVersionInfo():New( AppName(.f.) )
//  cbuild := oinfo:QueryValue(1,"SpecialBuild")
//  oinfo:destroy()

//  verzeAsys[3,2] := Padl(AllTrim(verzeAsys[3,2]),13,'0')
//  verzeAsys[8,2] := Padl(AllTrim(verzeAsys[8,2]), 8,'0')

//  SpecialBuild := if( .not. empty(cbuild), Padl(AllTrim(Left(cbuild,7)), 7, '0' ), '00.0000' )
////  SpecialBuild := Padl(AllTrim( SpecialBuild), 8, '0' )
////  SpecialBuild := strTran( SpecialBuild, chr(0), '' )

  PUBLIC timeBegin     := '00:00:00'
  PUBLIC timeEnd       := '00:00:00'
  PUBLIC timeCyklus    := 700

  PUBLIC ftpUserServer := ''
  PUBLIC ftpUserName   := ''
  PUBLIC ftpUserPassw  := ''
  PUBLIC ftpUserDir    := ''

return


FUNCTION ListAsArray( cList, cDelimiter )
  LOCAL nPos
  LOCAL aList := {}

  DEFAULT cDelimiter To ','
  Do While (nPos := aT( cDelimiter, cList)) != 0
    aAdd( aList, SubStr( cList, 1, nPos - 1))
    cList := SubStr( cList, nPos +Len( cDelimiter) )
  EndDo
  aAdd(aList, cList)
RETURN( aList)


PROCEDURE dclDefaultInitVars()
  local  npos

  drgINI:dir_SYSTEM   += IF( Right( AllTrim(drgINI:dir_SYSTEM),1)=="\", "", "\")
  drgINI:dir_DATA     += IF( Right( AllTrim(drgINI:dir_DATA),1)=="\",   "", "\")
  drgINI:dir_USER     += IF( Right( AllTrim(drgINI:dir_USER),1)=="\",   "", "\")

  if( empty(drgINI:dir_DATAroot), drgINI:dir_DATAroot := drgINI:dir_DATA, nil)

// nastavení default hodnoty
  IF( Empty(drgINI:dir_USERfi)                                     ;
        , drgINI:dir_USERfi   := drgChkDirName( drgINI:dir_USER), NIL)
  IF( Empty(drgINI:dir_USERfitm)                                   ;
        , drgINI:dir_USERfitm := drgChkDirName( drgINI:dir_USERfi) + 'TMP\', NIL)
  IF( Empty(drgINI:dir_RSRC)                                       ;
        , drgINI:dir_RSRC     := drgChkDirName( drgINI:dir_SYSTEM) + 'RESOURCE\', NIL)
  IF( Empty(drgINI:dir_WORK)                                       ;
        , drgINI:dir_WORK     := drgChkDirName( drgINI:dir_USERfi) , NIL)
RETURN


Function timeSec( ctime)
  local  nsec

  nsec := ( Val( SubStr( ctime,1,2)) * 3600 ) +   ;
            ( Val( SubStr( ctime,4,2)) * 60 ) +   ;
              ( Val( SubStr( ctime,7,2)))

return( nsec)


Function secTime( nsec)
  local  ctime
  local  hod,min
  local  n,m

  hod := min := 0

  if ( n := Int(nsec/3600))  >=  0
    hod  := n
    nsec := nsec - ( n * 3600 )
  endif

  if ( n := Int(nsec/60)) >= 0
    min := n
    nsec := nsec - ( n * 60 )
  endif

  ctime := StrZero(hod,2) +':' +StrZero(min,2) +':' +StrZero(nsec,2)
return( ctime)


function QueryRegistrySRV(nHKEYHandle, cKeyName, cEntryName)
  local cName := ""
  local nNameSize
  local nKeyHandle
  local nValueType

   nKeyHandle := 0
   if RegOpenKeyExA(nHKEYHandle, cKeyName,0, KEY_QUERY_VALUE, @nKeyHandle) = 0
     nValueType  := 0
     nNameSize  := 0
     RegQueryValueExA(nKeyHandle, cEntryName, 0, @nValueType, 0, @nNameSize)
     if nNameSize > 0
       cName := space( nNameSize-1)
       rc := RegQueryValueExA(nKeyHandle, cEntryName,0, @nValueType, @cName, @nNameSize)
     endif
     RegCloseKey( nKeyHandle)
   endif

return cName


function modi_logTask( pa, typ)
  local cX := ''
  local ok

   ok := if( typ >= 3, usersTsk->( dbSeek( pa.nSID,,'ID')), .t.)

   if ok
     if usersTsk->( dbRlock())
       do case
       case typ = 1     // start úlohy
         cX := 'Start úlohy - bude spuštìna      : ' + DtoC(pa.dtskBegin) + ' ' +  pa.ctskBegin + CRLF
         cX := cX + "*********************** START ***********************" + CRLF + CRLF + CRLF
       case typ = 2     // start úlohy
         cX := 'Zmìna úlohy - bude spuštìna  : ' + DtoC(pa.dtskBegin) + ' ' +  pa.ctskBegin + CRLF
         cX := cX + "============= RE-START ============="  + CRLF + CRLF
       case typ = 3
         cX := 'Úloha byla spuštìna                   : ' + DtoC( Date()) + ' ' + Time() + '  [ '+ DtoC(pa.dtskBegin) + ' ' + pa.ctskBegin + '] ' +CRLF
         cX := cX + Replicate("-"       , 54) + CRLF
       case typ = 4
         cX := 'Pøíští spuštìní                              : ' + DtoC(pa.dtskBegin) + ' ' + pa.ctskBegin + CRLF
       endcase

       usersTsk->mLogTask := cX +usersTsk->mLogTask
       usersTsk->( dbunlock(), dbCommit())
     endif
   endif

return nil