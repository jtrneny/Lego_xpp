#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
#include "Fileio.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for FIN_c_bankuc ******************************************************
CLASS SKL_servisCtrlPrep_IN FROM drgUsrClass, drgServiceThread
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  postValidate
  method  start
  method  ctrlPomoc,ctrlPrePosNakC

  var  obdobi, fileexp
  var  ctrlPomoc
  var  ctrlPrePosNakC
/*
  * bro col for c_bankuc
  inline access assign method isMain_uc() var isMain_uc
    return if( c_bankuc->lisMain, 300, 0)


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])
        return .t.
      endif

    endcase
  return .f.
*/

HIDDEN:
  var    msg, dm, dc, df
  *
ENDCLASS


method SKL_servisCtrlPrep_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)

// ::obdobi := '  /  '
// ::fileexp := Padr( AllTrim(SysCONFIG('System:cPathExp'))+'\FakVysH.DBf', 100)

  ::ctrlPomoc        := .f.
  ::ctrlPrePosNakC   := .f.

//  drgDBMS:open('FakVysHD')
//  drgDBMS:open('FakVysHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP

return self


method SKL_servisCtrlPrep_IN:drgDialogInit(drgDialog)

return self


method SKL_servisCtrlPrep_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method SKL_servisCtrlPrep_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  ::dataManager:save()
  ::dataManager:refresh()

return .t.


method SKL_servisCtrlPrep_IN:postLastField(drgVar)
return .t.


method SKL_servisCtrlPrep_IN:start(drgVar)
  local  lok, cx

  lok := ::ctrlPomoc

  if( ::ctrlPomoc,      ::ctrlPomoc(), nil)
  if( ::ctrlPrePosNakC, ::ctrlPrePosNakC(), nil)

  if( lok, drgMsgBox( "Pøepoèty byly dokonèeny"), nil)

return .t.



method SKL_servisCtrlPrep_IN:ctrlPomoc(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  nProc, ndph
  local  rok
  LOCAL  SKL,DIS

///   agrikol vynulování 30


  drgDBMS:open( 'cenzboz')
  drgDBMS:open( 'cenprodc')

  cfiltr := Format("ccissklad = '%%'", {'2'})
  cenzboz->(ads_setaof(cfiltr), dbGoTop())

  drgMsgBox( "Start pøepoètu")

  do while .not. cenzboz->( Eof())
    if cenzboz->nzbozikat = 9 .or. cenzboz->nzbozikat = 11 .or. cenzboz->nzbozikat = 12 .or. ;
        cenzboz->nzbozikat = 14 .or. cenzboz->nzbozikat = 15 .or. cenzboz->nzbozikat = 17 .or. ;
         cenzboz->nzbozikat = 23 .or. cenzboz->nzbozikat = 33 .or. cenzboz->nzbozikat = 37 .or. ;
          cenzboz->nzbozikat = 38 .or. cenzboz->nzbozikat = 41 .or. cenzboz->nzbozikat = 42 .or. ;
            cenzboz->nzbozikat = 45 .or. cenzboz->nzbozikat = 52 .or. cenzboz->nzbozikat = 54 .or. ;
             cenzboz->nzbozikat = 58 .or. cenzboz->nzbozikat = 68 .or. cenzboz->nzbozikat = 71 .or. ;
              cenzboz->nzbozikat = 78 .or. cenzboz->nzbozikat = 82 .or. cenzboz->nzbozikat = 89 .or. ;
               cenzboz->nzbozikat = 90 .or. cenzboz->nzbozikat = 96 .or. cenzboz->nzbozikat = 97 .or. ;
                cenzboz->nzbozikat = 100
      nproc := 0.1
    else
      nproc := 0.05
    endif

    if cenzboz->( dbRlock())
      cenzboz->ncenapzbo := cenzboz->ncenapzbo + (cenzboz->ncenapzbo*nproc)

      do case
      case cenzboz->ncenapzbo > 0 .and. cenzboz->ncenapzbo < 10
        cenzboz->ncenapzbo := Mh_RoundNumb(cenzboz->ncenapzbo,12)
      case cenzboz->ncenapzbo >= 10 .and. cenzboz->ncenapzbo < 1000
        cenzboz->ncenapzbo := Mh_RoundNumb(cenzboz->ncenapzbo,22)
      otherwise
        cenzboz->ncenapzbo := Mh_RoundNumb(cenzboz->ncenapzbo,32)
      endcase

      ndph :=  if( cenzboz->nklicdph = 10, 21, 15)

      cenzboz->ncenamzbo := cenzboz->ncenapzbo * ( 1+ ndph /100)
    endif

    key := Upper(cenzboz->ccissklad) + Upper(cenzboz->csklpol)
    if cenprodc->( dbSeek( key,,'CENPROD1'))
      if cenprodc->( dbRlock())
        cenprodc->ncenapzbo := cenzboz->ncenapzbo
        cenprodc->ncenamzbo := cenzboz->ncenamzbo
        cenprodc->( dbUnlock())
      endif
    endif

    cenzboz->( dbSkip())
  enddo

  drgMsgBox( "Konec pøepoètu")





/*
method SKL_servisCtrlPrep_IN:ctrlPomoc(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok
  LOCAL  SKL,DIS

///   agrikol vynulování 30

  rok := 2015

  drgDBMS:open( 'pvpitem',,,,,'pvpitema')
  drgDBMS:open( 'pvpitem',,,,,'pvpitemb')
  drgDBMS:open( 'cenzboz')

  cfiltr := Format("ctyppohybu = '%%' and cobdobi = '09/16'", {'17'})
  pvpitema->(ads_setaof(cfiltr), dbGoTop())

  drgMsgBox( "Start pøepoètu")

  do while .not. pvpitema->( Eof())
    key := Upper(pvpitema->ccissklad) + Upper(pvpitema->csklpol)
    if cenzboz->( dbSeek( key,,'CENIK03'))
      if cenzboz->( dbRlock()) .and. pvpitema->nmnozprdod <> 0
        cenzboz->nmnozszbo := pvpitema->nmnozprdod
        cenzboz->nmnozdzbo := pvpitema->nmnozprdod
        cenzboz->ncenaszbo := cenzboz->ncenaczbo/pvpitema->nmnozprdod
        cenzboz->( dbUnlock())
      endif
    endif
    pvpitema->( dbSkip())
  enddo

  drgMsgBox( "Konec pøepoètu")
*/



/*
method SKL_servisCtrlPrep_IN:ctrlPomoc(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  nHandle,cBuffer
  LOCAL  SKL,DIS
  local  csourcefile
  local  aline, afile
  local  nX

///   agrikol vynulování 30

  drgDBMS:open( 'c_recpop')

  drgMsgBox( "Start pøepoètu")

  csourcefile := "c:\ALASKA\XPPW32\Projects\Test6\rema.txt"
  nHandle  := FOpen( csourcefile, FO_READ )
  cBuffer  := FReadStr(nHandle,1280)

  aline := {}
  afile := {}

/*
  do while .not. Empty(cBuffer)        //cBuffer <> ''
    do while ( n := At( CRLF, cBuffer)) > 0
      line := SubStr( cBuffer,1,n-1)
      cBuffer := SubStr( cBuffer,n+2)
    enddo
    cBuffer := cBuffer +FReadStr(nHandle, 128)  // result: 4
  enddo
*/

/*
      do while .not. Empty(cBuffer)        //cBuffer <> ''
        do while ( n := At( CRLF, cBuffer)) > 0
          line := SubStr( cBuffer,1,n-1)
          aline  := ListAsArray( line,';')
          if len( aline) = 12
            AAdd( afile, aline)
            uu := len( afile)
          else
            nX := Len( afile)
            aFile[nX,12] := aFile[nX,12] + aline[1]
          endif
          cBuffer := SubStr( cBuffer,n+2)
        enddo
        cBuffer := cBuffer +FReadStr(nHandle, 1280)  // result: 4
      enddo

  FClose( nHandle)

  drgMsgBox( "Konec pøepoètu")


*/


/*
  rok := uctOBDOBI:SKL:NROK

  drgDBMS:open( 'cenzboz',,,,,'cenzboz2')
  drgDBMS:open( 'cenzboz',,,,,'cenzboz30')

  cfiltr := Format("ccissklad= '%%'", {'30'})
  cenzboz30->(ads_setaof(cfiltr), dbGoTop())

  drgMsgBox( "Start pøepoètu")

  do while .not. cenzboz30->( Eof())
    if cenzboz30->nmnozszbo > 0
      key := Upper('2       ') + Upper(cenzboz30->csklpol)
      if cenzboz2->( dbSeek( key,,'CENIK12'))
        SKL := cenzboz30->nmnozszbo
        DIS := cenzboz30->nmnozdzbo
        CEN := cenzboz30->ncenaczbo
        if cenzboz2->( dbRlock())
          cenzboz2->nmnozszbo += SKL
          cenzboz2->nmnozdzbo += DIS
          cenzboz2->ncenaczbo += CEN
          cenzboz2->ncenaszbo := cenzboz2->ncenaczbo / cenzboz2->nmnozszbo
          cenzboz2->( dbUnlock())
        endif
        if cenzboz30->( dbRlock())
          cenzboz30->nmnozszbo -= SKL
          cenzboz30->nmnozdzbo -= DIS
          cenzboz30->ncenaczbo := 0
          cenzboz30->( dbUnlock())
        endif
      endif
    endif
    cenzboz30->( dbSkip())
  enddo

  drgMsgBox( "Konec pøepoètu")

*/

//  drgDBMS:open('DRUHYMZD')
*  drgDBMS:open('MZDDAVIT',,,,,'mzddavitd')


//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

/*
  drgServiceThread:new()
  cFiltr := Format("nROK = %% and cdenik = '%%'", { rok,"MN"})
  mzddavitd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzddavitd->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet dnù nemoci ... ', 'MZDDAVITD'), recFlt )

  do while .not. mzddavitd->(Eof())
    if mzddavitd->( dbRlock())
      mzddavitd->ndnyfondkd := mzddavitd->nVykazN_KD
      mzddavitd->ndnyfondpd := mzddavitd->nVykazN_PD
      if mzddavitd->ndnyvyldod > 0
        mzddavitd->ndnyvyldod := mzddavitd->nVykazN_KD
      else
        mzddavitd->nDnyVylocD := mzddavitd->nVykazN_KD
      endif
      if msprc_mod->( dbSeek( mzddavitd->croobcpppv,,'MSPRMO17'))
        mzddavitd->nVykazN_ho := mzddavitd->nVykazN_PD *fPracDOBA( msprc_mod->cDelkPrDob)[3]
        mzddavitd->nhodfondpd := mzddavitd->nVykazN_PD *fPracDOBA( msprc_mod->cDelkPrDob)[3]
      endif

      mzddavitd->( dbUnlock())
    endif
    drgServiceThread:progressInc()
    mzddavitd->(dbSkip())
  enddo

  mzddavitd->( ads_ClearAof())

  drgServiceThread:progressEnd()

  mzdyhdd->(dbCloseArea())
  mzdyitd->(dbCloseArea())
*/

return .t.


// Pøepoèet poslední nákupní ceny u dodavatele zboží z pøíjemky pøípadnì objednávky vystavené

method SKL_servisCtrlPrep_IN:ctrlPrePosNakC(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr, ckey
  local  rok


//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open( 'pvpitem',,,,,'pvpitema')
  drgDBMS:open( 'objvysit',,,,,'objvysita')
  drgDBMS:open( 'dodzboz',,,,,'dodzboza')
  drgDBMS:open( 'cenzboz')

  drgServiceThread:new()

  recFlt := dodzboza->( LastRec())

  drgServiceThread:progressStart(drgNLS:msg('Pøepoèet poslední nákupní ceny ... ', 'dodzboz'), recFlt )

  dodzboza->(dbGoTop())
  do while .not. dodzboza->(Eof())

    ckey := STRZERO(dodzboza->NCISFIRMY,5)+UPPER(dodzboza->CCISSKLAD)+UPPER(dodzboza->CSKLPOL)+'01'

    if pvpitema->( dbSeek(ckey,,'PVPITEM23',.t.))
      if dodzboza->( dbRlock())
        dodzboza->ncenanzbo := pvpitema->ncennapdod
        dodzboza->ncennakzm := pvpitema->ncennadozm
        dodzboza->ddatpnak  := pvpitema->ddatpvp
        dodzboza->(dbUnlock())
      endif
    endif

    ckey := STRZERO(dodzboza->NCISFIRMY,5)+UPPER(dodzboza->CCISSKLAD)+UPPER(dodzboza->CSKLPOL)
    if objvysita->( dbSeek(ckey,,'OBJVYSI9',.t.))
      if dodzboza->( dbRlock())
        dodzboza->ncenaozbo := objvysita->ncennaodod
        dodzboza->(dbUnlock())
      endif
    endif

    drgServiceThread:progressInc()
    dodzboza->( dbSkip())
  enddo

  drgServiceThread:progressEnd()

return( .t.)