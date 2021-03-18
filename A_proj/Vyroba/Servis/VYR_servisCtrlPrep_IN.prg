#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for FIN_c_bankuc ******************************************************
CLASS VYR_servisCtrlPrep_IN FROM drgUsrClass, drgServiceThread
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  postValidate
  method  start
  method  ctrlPrepMzLi
  method  ctrlKonTarLi

  var  obdobi, fileexp
  var  ctrlPrepMzLi
  var  ctrlKonTarLi
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


method VYR_servisCtrlPrep_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)

// ::obdobi := '  /  '
// ::fileexp := Padr( AllTrim(SysCONFIG('System:cPathExp'))+'\FakVysH.DBf', 100)

  ::ctrlPrepMzLi  := .f.
  ::ctrlKonTarLi  := .f.

//  drgDBMS:open('FakVysHD')
//  drgDBMS:open('FakVysHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP

return self


method VYR_servisCtrlPrep_IN:drgDialogInit(drgDialog)

return self


method VYR_servisCtrlPrep_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method VYR_servisCtrlPrep_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  ::dataManager:save()
  ::dataManager:refresh()

return .t.


method VYR_servisCtrlPrep_IN:postLastField(drgVar)
return .t.


method VYR_servisCtrlPrep_IN:start(drgVar)
  local  lok, cx

  lok := ::ctrlPrepMzLi
  lok := ::ctrlKonTarLi

  if( ::ctrlPrepMzLi,      ::ctrlPrepMzLi(), nil)
  if( ::ctrlKonTarLi,      ::ctrlKonTarLi(), nil)

  if( lok, drgMsgBox( "Pøepoèty byly dokonèeny"), nil)

return .t.

method VYR_servisCtrlPrep_IN:ctrlPrepMzLi(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok,cobd
  local  procprem, premie, zaklad
  local  ntarif
  LOCAL  SKL,DIS

  local  cc
  local  lrozd

///   agrikol vynulování 30
  cobd := uctOBDOBI:VYR:COBDOBI
//  cobd := '02/17'

  drgDBMS:open( 'listit')
  drgDBMS:open( 'osoby')
  drgDBMS:open( 'msprc_mo')
  drgDBMS:open( 'osoby',,,,,'OSOBY_S')
//  drgDBMS:open( 'vyrpol',,,,,'vyrpola')

  cfiltr := Format("cobdobi= '%%'", {cobd})
  listit->(ads_setaof(cfiltr), dbGoTop())

  drgMsgBox( "Start pøepoètu")
  do while .not. listit->( Eof())
    ntarif := 0

    cc := 'Klíè: ' + StrZero(listit->noscisprac,5) + '-'+StrZero(listit->nporpravzt,3) + ' '
    lrozd := .f.

    do case
    case listit->nporpravzt > 0
      if msprc_mo->( dbseek( StrZero(listit->nrok,4) +              ;
                            StrZero(listit->nobdobi,2) +         ;
                             StrZero(listit->noscisprac,5) +     ;
                              StrZero(listit->nporpravzt,3),,'MSPRMO01'))

        nTarif := fSazTar( listit->dVyhotSkut )[1]
      endif

    case listit->nporpravzt = 0
      if OSOBY_S->( dbseek( listit->ncisosoby,, 'Osoby01'))
        nTarif := fSazTar( listit->dVyhotSkut, 'OSOBY_S')[1]
      endif

    endcase

    cc += 'Sazba new/old: '+ Str(nTarif,8,2) + '/' + Str(listit->ntarsazhod,8,2)


    if Round(nTarif,4) <> Round(listit->ntarsazhod,4) .and. ntarif <> 0
      lrozd := .t.
      if listit->(dbRlock())
        listit->ntarsazhod := nTarif
        listit->(dbUnlock())
      endif
    endif

    zaklad := listit->nnhnaopesk * listit->ntarsazhod
    if osoby->( dbSeek(listit->ncisosoby,,'OSOBY01'))

      procprem := fSazZam('PRCPREHLCI',listit->dVyhotSKUT,'listit')
      premie :=  zaklad * (procprem / 100)

      if Round((zaklad + premie),4) <> Round(listit->nkcnaopesk,4)
        cc += '  Mzda new/old: '+ Str(zaklad + premie,8,2) + '/' + Str(listit->nkcnaopesk,8,2)
        lrozd := .t.
      endif

      if listit->(RLock())
        listit->nsazprepr  := procprem
        listit->nkcnaopesk := zaklad + premie
        listit->(dbUnLock())
      endif
    endif

    if lrozd
      drgDump(cc + CRLF)
    endif

    listit->( dbSkip())
  enddo
  drgMsgBox( "Konec pøepoètu")


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


method VYR_servisCtrlPrep_IN:ctrlKonTarLi(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok,cobd
  local  nprocprem
  local  ntarif
  LOCAL  SKL,DIS

  local  cc
  local  lrozd

  cobd := uctOBDOBI:VYR:COBDOBI
  cc   := ''

  drgDBMS:open( 'listit')
  drgDBMS:open( 'osoby')
  drgDBMS:open( 'msprc_mo')
  drgDBMS:open( 'osoby',,,,,'OSOBY_S')
//  drgDBMS:open( 'vyrpol',,,,,'vyrpola')

  cfiltr := Format("cobdobi= '%%'", {cobd})
  listit->(ads_setaof(cfiltr), dbGoTop())
  lrozd := .f.


  drgMsgBox( "Start kontroly")

  do while .not. listit->( Eof())
    ntarif    := 0
    nprocprem := 0
    do case
    case listit->nporpravzt > 0
      if msprc_mo->( dbseek( StrZero(listit->nrok,4) +              ;
                            StrZero(listit->nobdobi,2) +         ;
                             StrZero(listit->noscisprac,5) +     ;
                              StrZero(listit->nporpravzt,3),,'MSPRMO01'))

        nTarif    := fSazTar( listit->dVyhotSkut )[1]
        nProcPrem := fSazZam('PRCPREHLCI',listit->dVyhotSKUT,'listit')
      endif

    case listit->nporpravzt = 0
      if listit->noscisprac=9491
        ddd := 1
      endif

      if OSOBY_S->( dbseek( listit->ncisosoby,, 'Osoby01'))
        nTarif := fSazTar( listit->dVyhotSkut, 'OSOBY_S' )[1]
      endif

    endcase

    if ( Round(nTarif,4) <> Round(listit->ntarsazhod,4) .and. ntarif <> 0 ) .or. ;
          (Round(nProcPrem,4) <> Round(listit->nsazprepr,4))

      cc += 'Pracovník: ' + Str(listit->noscisprac) +    ;
             'È.lístku: ' + Str(listit->nporcislis) +    ;
              'Sazba tar/lís: '+ Str(nTarif,8,2) + '/' + Str(listit->ntarsazhod,8,2) + ;
               'Prémie saz/lís: '+ Str(nProcPrem,8,2) + '/' + Str(listit->nsazprepr,8,2) + CRLF


      lrozd := .t.

    endif

    listit->( dbSkip())
  enddo

  if lrozd
    drgDump(cc)
    drgMsgBox( cc )
  endif

  drgMsgBox( "Konec kontroly")


return .t.