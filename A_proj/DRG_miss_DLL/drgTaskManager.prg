#include "appevent.ch"
#include "Common.ch"
#include "directry.ch"
#include "dll.ch"
#include "dmlb.ch"
#include "thread.ch"
*
#include "..\Asystem++\Asystem++.ch"


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


// pokud úloha bìží a z nìjakých dùvodù nebyla ukonèena, nemá cenu ji startovat znovu
// ale jak se mùže stát, že nebyla ukonèena
// pro FCE_... - no tohle nevím, asi se to nìkde kouslo, co s tím
// pro FRM_... - si nechal otevøené okno a asi v nìm pracuje


class drgTaskManager from Thread
EXPORTED:

  var pa_Task_list
  var odrgMenu, is_menuActive, is_createTask
  var ddate_Mod, ctime_Mod
  var terminated

  inline method terminate()
    ::terminated := .t.
  return

  inline method atStart()
    ::setInterval( 100 )

    ::pa_Task_list  := {}
    ::is_menuActive := .f.
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
  return self


  inline method execute()
    local nEvent, oXbp, mp1, mp2
    local x, paTask, njd_Current
    local oThread, is_tskRun

    do while .not. ::terminated
      do while (nEvent := AppEvent(@mp1, @mp2, @oXbp, 1) ) != xbe_None .and. .not. ::terminated
        if nEvent = xbeP_Close .or. ::terminated
          ::setInterval( NIL )
          RETURN
        endif

        oXbp:handleEvent( nEvent, mp1, mp2 )
      enddo

      if( .not. ::terminated, sleep(5), nil )

      if ::is_menuActive
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

              is_tskRun   := .t.

              do case
              case paTask.ctypObject = 'FCE_KOM'
                oThread := drgTaskThread():new()
                oThread:paTask := paTask
                oThread:start()

              case paTask.ctypObject = 'FRM_SCR' .or. paTask.ctypObject = 'FRM_SCR_IN'
                oThread := drgDialogThread():new()
                oThread:start( , paTask.cprgObject, ::odrgMenu )
              endcase

              * spustili jsme úlohu
              if is_tskRun
                paTask.njd_tskBegin  := paTask.njd_tskBegin +paTask.nperRun
                if paTask.ntypRun <> 1
                  paTask.njd_tskDenBeg := paTask.njd_tskDenBeg +paTask.nperRun
                  paTask.njd_tskDenEnd := paTask.njd_tskDenEnd +paTask.nperRun
                endif
              endif

            endif
          endif
        next
      endif
    enddo

    AsysSem ->(dbclosearea())
    usersTsk->(dbCloseArea())
    ::setInterval( NIL )
   return

   inline method atEnd()
     ::pa_Task_list := ;
     ::ddate_Mod    := ;
     ::ctime_Mod    := nil
   return

HIDDEN:

  inline method create_pa_Task_list()
    local filtr := format("cUser = '%%' .and. nstateTsk = 1 .and. lAktivni", { usrName })
    local nden
    *
    local ntypRun
    local dtskBegTm  , ctskBegTm
    local dtskBegin  , ctskBegin,  njd_tskBegin
    local ctskDenBeg , ctskDenEnd, njd_tskDenBeg, njd_tskDenEnd
    local dplatnyOd  , dplatnyDo
    local ctypObject , cprgObject, nperRun, nPerioda, nSID
    local pa_mDatkom_us
    local is_tskRun
    local typReRun   , firstRun

    ::pa_Task_list := {}
      firstRun     := 0    // první spuštìní 0 - okamžitì, 1 - dle zadaného intervalu


    usersTsk->( ads_setAof(filtr), dbgoTop() )

    do while .not. usersTsk->( eof())
      dplatnyOd  := if( empty(usersTsk->dplatnyOd)    , date()   , usersTsk->dplatnyOd )
      dplatnyDo  := usersTsk->dplatnyDo

      dtskBegin  := if( empty(usersTsk->dtskBegin)    , date()   , usersTsk->dtskBegin )
      ctskBegin  := if( secs(usersTsk->ctskBegin) = 0 , time()   , usersTsk->ctskBegin )
      ctskBegTm  := AllTrim( ctskBegin)
      firstRun   := usersTsk->nfirstRun

      if dtskBegin <= date()
        dtskBegin := date()
        if firstRun = 1
          ctskBegTm := AllTrim( time())
          if usersTsk->ntypRun = 1
            ctskBegin := ctskBegTm
          endif
        else
          if ctskBegin < time()
            dtskBegin++
          endif
        endif
      endif

      njd_tskBegin  := ::julianDate_Time(dtskBegin, ctskBegin)

      ctskDenBeg    := if( secs(userstsk->ctskDenBeg) = 0, '00:00:01', userstsk->ctskDenBeg)
      ctskDenEnd    := if( secs(userstsk->ctskDenEnd) = 0, '23:59:59', userstsk->ctskDenEnd)
      dtskDenBeg    := dtskBegin
      dtskDenEnd    := dtskBegin
      njd_tskDenBeg := ::julianDate_Time(dtskBegin, ctskDenBeg)
      njd_tskDenEnd := ::julianDate_Time(dtskBegin, ctskDenEnd)

      ctypObject    := usersTsk->ctypObject
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
        aadd( ::pa_Task_list, { dplatnyOd   , dplatnyDo                   , ;
                                njd_tskBegin, njd_tskDenBeg, njd_tskDenEnd, ;
                                ctypObject  , cprgObject   , ntypRun      , nperRun     , pa_mDatkom_us, is_tskRun, ;
                                dtskBegin   , ctskBegin    , dtskDenBeg   , ctskDenBeg  , ;
                                dtskDenEnd  , ctskDenEnd   , nPerioda     , nSID          } )

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

            aadd( ::pa_Task_list, { dplatnyOd   , dplatnyDo                   , ;
                                    njd_tskBegin, njd_tskDenBeg, njd_tskDenEnd, ;
                                    ctypObject  , cprgObject   , ntypRun      , nperRun     , pa_mDatkom_us, is_tskRun, ;
                                    dtskBegin   , ctskBegin    , dtskDenBeg   , ctskDenBeg  , ;
                                    dtskDenEnd  , ctskDenEnd   , nPerioda     , nSID          } )


          endif
        next
      endcase

      typReRun := if( ::is_createTask, 2, 1)
      usersTsk->( dbskip())
    enddo
    usersTsk->( ads_clearAof())
    return self


  inline method julianDate_Time(dDate,cTime)
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
    njd  := njdn + ((3600*nHod + 60*nMin+ nsec) / 86400)

    Set( _SET_DECIMALS, ndeciMals)
  return nJd

ENDCLASS



class drgTaskThread from Thread
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