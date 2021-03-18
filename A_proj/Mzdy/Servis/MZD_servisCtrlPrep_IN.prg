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
CLASS MZD_servisCtrlPrep_IN FROM drgUsrClass, drgServiceThread
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  postValidate
  method  start
  method  ctrlMhNem
  method  ctrlMhHodUP
  method  ctrlPrepocCM
  method  ctrlMzdaVRoce
  method  ctrlDovVObd
  method  ctrlPrepMzdyHD
  method  ctrlPrepOdpoc
  method  ctrlPrepMsOsb
  method  ctrlPrepMzdNem

  var  obdobi, fileexp
  var  ctrlNem, ctrlHodUP, ctrlPrepCM, ctrlMzdaVRoce, ctrldovVObd, ctrlPrepMzdyHD
  var  ctrlPrepOdpoc, ctrlPrepMsOsb, ctrlPrepMzdNem

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


method MZD_servisCtrlPrep_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)

// ::obdobi := '  /  '
// ::fileexp := Padr( AllTrim(SysCONFIG('System:cPathExp'))+'\FakVysH.DBf', 100)

  ::ctrlNem        := .f.
  ::ctrlHodUP      := .f.
  ::ctrlPrepCM     := .f.
  ::ctrlMzdaVRoce  := .f.
  ::ctrldovVObd    := .f.
  ::ctrlPrepMzdyHD := .f.
  ::ctrlPrepOdpoc  := .f.
  ::ctrlPrepMsOsb  := .f.
  ::ctrlPrepMzdNem := .f.

//  drgDBMS:open('FakVysHD')
//  drgDBMS:open('FakVysHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP

return self


method MZD_servisCtrlPrep_IN:drgDialogInit(drgDialog)

return self


method MZD_servisCtrlPrep_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method MZD_servisCtrlPrep_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  ::dataManager:save()
  ::dataManager:refresh()

return .t.


method MZD_servisCtrlPrep_IN:postLastField(drgVar)
return .t.


method MZD_servisCtrlPrep_IN:start(drgVar)
  local  lok, cx

  lok := ::ctrlNem

  if( ::ctrlNem,        ::ctrlMhNem(), nil)
  if( ::ctrlHodUP,      ::ctrlMhHodUP(), nil)
  if( ::ctrlPrepCM,     ::ctrlPrepocCM(), nil)
  if( ::ctrlMzdaVRoce,  ::ctrlMzdaVRoce(), nil)
  if( ::ctrldovVobd,    ::ctrldovVObd(), nil)
  if( ::ctrlPrepMzdyHD, ::ctrlPrepMzdyHD(), nil)
  if( ::ctrlPrepOdpoc,  ::ctrlPrepOdpoc(), nil)
  if( ::ctrlPrepMsOsb,  ::ctrlPrepMsOsb(), nil)
  if( ::ctrlPrepMzdNem, ::ctrlPrepMzdNem(), nil)

  if( lok, drgMsgBox( "Pøepoèty byly dokonèeny"), nil)

return .t.

method MZD_servisCtrlPrep_IN:ctrlMhNem(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok


//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')
  drgDBMS:open('MZDYIT',,,,,'mzdyitd')
  drgDBMS:open('MSPRC_MO',,,,,'msprc_mod')
  drgDBMS:open('MZDDAVIT',,,,,'mzddavitd')

  rok := uctOBDOBI:MZD:NROK

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()


///  oprava sts

  cFiltr := Format("nROK = %% ", { rok})
  mzdyhdd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzdyhdd->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet dnù nemoci ... ', 'MZDDAVITD'), recFlt )

  do while .not. mzdyhdd->(Eof())
    if mzdyhdd->( dbRlock())
      mzdyhdd->nDnyVylocD := 0

      cFiltr := Format("nROK = %% .and. nDOKLAD = %%", { mzdyhdd->nRok, mzdyhdd->nDoklad})
      mzdyitd->( ads_setAof( cFiltr), dbgoTop())
       do while .not. mzdyitd->(Eof())
         if mzdyitd->ndruhmzdy >= 400 .and. mzdyitd->ndruhmzdy <= 499
           if mzdyitd->( dbRlock())
             mzdyitd->nDnyVylocD := mzdyitd->ndnyfondkd
           endif
//           mzdyhdd->ndnynahrPN += mzdyitd->ndnydoklad
//           mzdyhdd->nDnyNemoKD += mzdyitd->ndnyfondkd
//           mzdyhdd->nDnyNemoPD += mzdyitd->ndnyfondpd
           mzdyhdd->nDnyVylocD += mzdyitd->nDnyVylocD
         endif
//         mzdyhdd->nHodFondPD += mzdyitd->nhodfondpd
         mzdyitd->( dbSkip())
       enddo

       mzdyitd->( ads_ClearAof())
       mzdyitd->( dbUnlock())
       mzdyhdd->( dbUnlock())
    endif

    drgServiceThread:progressInc()
    mzdyhdd->( dbSkip())
  enddo




/*


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

  cFiltr := Format("nROK = %% and nporadi <> %% and ndruhmzdy >= %% and ndruhmzdy <= %%", { rok,0,400,499})
  mzdyitd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzdyitd->( Ads_GetRecordCount())

  drgServiceThread:new()

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet dnù nemoci ... ', 'MZDYITD'), recFlt )

  do while .not. mzdyitd->(Eof())
//           mzdyhdd->ndnynahrPN += mzdyitd->ndnydoklad
//
//  lok := .f.
//  if mzdyitd->nMZDDAVIT <> 0
//    if mzddavitd->( dbSeek( mzdyitd->nmzddavit,,'ID'))
//      if mzdyitd->( dbRlock())
//        lok := .t.
//      endif
//    endif
//  else
//     cFiltr := Format("croobcpppv = '%%' and nporadi = %% and ndruhmzdy = %%", { mzdyitd->croobcpppv,mzdyitd->nporadi,mzdyitd->ndruhmzdy})
      mzddavitd->( ads_setAof( cFiltr), dbgoTop())
      if mzddavitd->( Ads_GetRecordCount()) > 0
        if mzdyitd->( dbRlock())
          lok := .t.
          mzdyitd->cdenik     := mzddavitd->cdenik
          mzdyitd->ndokladorg := mzddavitd->ndoklad
          mzdyitd->nMZDDAVIT  := isNull( mzddavitd->sid, 0)

          mzdyitd->nMZDDAVIT := isNull( mzddavitd->sid, 0)
        endif
      endif
//    endif
    if lok
      mzdyitd->dDatumOD   := mzddavitd->dDatumOD
      mzdyitd->dDatumDO   := mzddavitd->dDatumDO
      mzdyitd->ndnyfondkd := mzddavitd->nVykazN_KD
      mzdyitd->ndnyfondpd := mzddavitd->nVykazN_PD
      if mzddavitd->ndnyvyldod > 0
        mzdyitd->ndnyvyldod := mzddavitd->nVykazN_KD
      else
        mzdyitd->nDnyVylocD := mzddavitd->nVykazN_KD
      endif
      mzdyitd->nhodfondpd := mzddavitd->nvykazn_ho

      mzdyitd->( dbUnlock())
    endif
    drgServiceThread:progressInc()
    mzdyitd->( dbSkip())
  enddo
  mzdyitd->( ads_ClearAof())

  drgServiceThread:progressEnd()

  cFiltr := Format("nROK = %%", { rok})

  mzdyhdd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzdyhdd->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet dnù nemoci ... ', 'MZDYHDD'), recFlt )

  do while .not. mzdyhdd->(Eof())
    if mzdyhdd->( dbRlock())
      mzdyhdd->ndnynahrPN := 0
      mzdyhdd->nDnyNemoKD := 0
      mzdyhdd->nDnyNemoPD := 0
      mzdyhdd->nDnyVylocD := 0
      mzdyhdd->nHodFondPD := 0

      cFiltr := Format("nROK = %% .and. nDOKLAD = %%", { mzdyhdd->nRok, mzdyhdd->nDoklad})
      mzdyitd->( ads_setAof( cFiltr), dbgoTop())
       do while .not. mzdyitd->(Eof())

         if mzdyitd->ndruhmzdy = 127
           if mzdyitd->( dbRlock())
             mzdyitd->nHodFondPD := 0
             mzdyitd->nDnyVylocD := 0
             mzdyitd->( dbUnLock())
           endif
         end

         if ( mzdyitd->ndruhmzdy >= 190 .and. mzdyitd->ndruhmzdy <= 193 ) .or.   ;
               ( mzdyitd->ndruhmzdy >= 196 .and. mzdyitd->ndruhmzdy <= 198 )
           if mzdyitd->( dbRlock())
             mzdyitd->nHodFondPD := 0
             mzdyitd->nDnyVylocD := 0
             mzdyitd->( dbUnLock())
           endif
         end

         if mzdyitd->ndruhmzdy >= 400 .and. mzdyitd->ndruhmzdy <= 499
           if mzdyitd->( dbRlock())
             mzdyitd->nDnyVylocD := mzdyitd->ndnyfondkd
           endif
           mzdyhdd->ndnynahrPN += mzdyitd->ndnydoklad
           mzdyhdd->nDnyNemoKD += mzdyitd->ndnyfondkd
           mzdyhdd->nDnyNemoPD += mzdyitd->ndnyfondpd
           mzdyhdd->nDnyVylocD += mzdyitd->nDnyVylocD
         endif
         mzdyhdd->nHodFondPD += mzdyitd->nhodfondpd
         mzdyitd->( dbSkip())
       enddo

       mzdyitd->( ads_ClearAof())
       mzdyitd->( dbUnlock())
       mzdyhdd->( dbUnlock())
    endif

    drgServiceThread:progressInc()
    mzdyhdd->( dbSkip())
  enddo
*/




  mzdyhdd->(dbCloseArea())
  mzdyitd->(dbCloseArea())

  drgServiceThread:progressEnd()

return .t.


method MZD_servisCtrlPrep_IN:ctrlMhHodUP(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok
  local  dnast, dvyst
  local  nsvatek


//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MSPRC_MO',,,,,'msprc_moc')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')
  drgDBMS:open('MZDYIT',,,,,'mzdyitd')
  drgDBMS:open('MZDDAVIT',,,,,'mzddavitd')

  rok := uctOBDOBI:MZD:NROK

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()
  cFiltr := Format("nROK = %% and cdenik = '%%'", { rok,"MN"})
  mzddavitd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzddavitd->( Ads_GetRecordCount())

  cFiltr := Format("nROK = %%", { rok})

  mzdyhdd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzdyhdd->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet dnù pro ÚP ... ', 'MZDYHDD'), recFlt )

  cFiltr := Format("nRok = %% and ( nDruhMzdy = 115 or nDruhMzdy = 150 or (nDruhMzdy >= 300 and nDruhMzdy <= 399) or (nDruhMzdy >= 500 and nDruhMzdy <= 999))", { rok})
  mzdyitd->( ads_setAof( cFiltr), dbgoTop())
   do while .not. mzdyitd->(Eof())
     if mzdyitd->( dbRlock())
       mzdyitd->nDnyDoklad := if( mzdyitd->ndruhmzdy <> 115, 0, mzdyitd->nDnyDoklad)
       mzdyitd->nDnyFondKD := 0
       mzdyitd->nDnyFondPD := 0
       mzdyitd->nHodFondKD := 0
       mzdyitd->nHodFondPD := 0
     endif
     mzdyitd->( dbSkip())
   enddo
  mzdyitd->( ads_ClearAof())

  cFiltr := Format("nRok = %% and nhoddoklad <> nhodfondpd and ((ndruhmzdy < 130 and ndruhmzdy <> 115) or (ndruhmzdy >= 170 and ndruhmzdy <= 188))", { rok})
  mzdyitd->( ads_setAof( cFiltr), dbgoTop())
   do while .not. mzdyitd->(Eof())
     if mzdyitd->( dbRlock())
       mzdyitd->nDnyFondKD := mzdyitd->nDnyDoklad
       mzdyitd->nDnyFondPD := mzdyitd->nDnyDoklad
       mzdyitd->nHodFondKD := mzdyitd->nHodDoklad
       mzdyitd->nHodFondPD := mzdyitd->nHodDoklad
     endif
     mzdyitd->( dbSkip())
   enddo
  mzdyitd->( ads_ClearAof())

  cFiltr := Format("nRok = %% and ndruhmzdy = 127", { rok})
  mzdyitd->( ads_setAof( cFiltr), dbgoTop())
   do while .not. mzdyitd->(Eof())
     if mzdyitd->( dbRlock())
       mzdyitd->nDnyFondKD := 0
       mzdyitd->nDnyFondPD := 0
       mzdyitd->nHodFondKD := 0
       mzdyitd->nHodFondPD := 0
     endif
     mzdyitd->( dbSkip())
   enddo
  mzdyitd->( ads_ClearAof())

  cFiltr := Format("nRok = %% and cdenik = 'MN' and nhodfondpd = 0 and mzdyitd->ndruhmzdy <> 194 and mzdyitd->ndruhmzdy <> 195 and mzdyitd->ndruhmzdy <> 421 and mzdyitd->ndruhmzdy <> 426", { rok})
  mzdyitd->( ads_setAof( cFiltr), dbgoTop())
   do while .not. mzdyitd->(Eof())
     if msprc_moC->( dbSeek( mzdyitd->cRoObCpPPV,,'MSPRMO17'))
       if mzdyitd->( dbRlock())
         mzdyitd->nHodFondPD := mzdyitd->nDnyFondPD * fPracDOBA( msprc_moC->cDelkPrDob)[3]
         mzdyitd->( dbUnlock())
       endif
     endif
     mzdyitd->( dbSkip())
   enddo
  mzdyitd->( ads_ClearAof())


  do while .not. mzdyhdd->(Eof())
//    if mzdyhdd->nHodFondUP = 0
  // naplnìní kalendáøního a pracovního fondu ve dnech

    dnast := mh_FirstODate( mzdyhdd->nRok, mzdyhdd->nObdobi)
    dvyst := mh_LastODate( mzdyhdd->nRok, mzdyhdd->nObdobi)


//    if mzdyhdd->nFondKDDn = 0 .or. mzdyhdd->nFondPDDn = 0 .or. mzdyhdd->nFondPDsDn = 0   ;
//       .or. mzdyhdd->nFondPDsHo = 0 .or. mzdyhdd->nFondPDHo = 0 .or. mzdyhdd->cobdobi = '04/17'


      if msprc_moC->( dbSeek( mzdyhdd->cRoObCpPPV,,'MSPRMO17'))

        if msprc_moC->ddatnast <= mh_LastODate( msprc_moC->nRok, msprc_moC->nObdobi)
          dnast := mh_FirstODate( msprc_moC->nRok, msprc_moC->nObdobi)
          if Year( msprc_moC->dDatNast) = msprc_moC->nRok                          ;
               .and. Month( msprc_moC->dDatNast) = msprc_moC->nObdobi
            dnast := msprc_moC->dDatNast
          endif
        endif

        if msprc_moC->ddatvyst >= mh_FirstODate( msprc_moC->nRok, msprc_moC->nObdobi) ;
               .or. Empty( msprc_moC->ddatvyst)
          dvyst := mh_LastODate( msprc_moC->nRok, msprc_moC->nObdobi)
          if Year( msprc_moC->ddatvyst) = msprc_moC->nRok                          ;
               .and. Month( msprc_moC->dDatVyst) = msprc_moC->nObdobi
            dvyst := msprc_moC->dDatVyst
          endif
        endif

        // úprava pro rok 2017
//        if mzdyhdd->cobdobi = '04/17'
//          if ( empty(dvyst) .or. IsNull(dvyst))
//            dvyst := mh_LastODate( msprc_moC->nRok, msprc_moC->nObdobi)
//          endif
//        endif

        if !Empty( dnast) .and. !Empty( dvyst)
          if mzdyhdd->( dbRlock())
            mzdyhdd->nFondKDDn  := D_DnyOdDo(dnast,dvyst,"KALE", 'msprc_moC')
            mzdyhdd->nFondPDDn  := D_DnyOdDo(dnast,dvyst,"PRAC", 'msprc_moC')
            mzdyhdd->nFondPDsDn := D_DnyOdDo(dnast,dvyst,"PRAC", 'msprc_moC') +D_DnyOdDo(dnast,dvyst,"SVAT", 'msprc_moC')

            mzdyhdd->nFondPDHo  := mzdyhdd->nFondPDDn  * fPracDOBA( msprc_moC->cDelkPrDob)[3]
            mzdyhdd->nFondPDSHo := mzdyhdd->nFondPDsDn * fPracDOBA( msprc_moC->cDelkPrDob)[3]
            mzdyhdd->( dbUnlock())
            mzdyhdd->( dbCommit())
          endif
        endif
      endif
//    endif

      if mzdyhdd->( dbRlock())
        mzdyhdd->nHodFondUP := 0
        nsvatek := mzdyhdd->nFondPDSHo - mzdyhdd->nFondPDHo
        cFiltr := Format("cRoObCpPPV = '%%' and nHodFondPD <> 0", { mzdyhdd->cRoObCpPPV})
        mzdyitd->( ads_setAof( cFiltr), dbgoTop())
         do while .not. mzdyitd->(Eof())
           if mzdyitd->ndruhmzdy <> 189 .and. mzdyitd->ndruhmzdy <> 194 .and. mzdyitd->ndruhmzdy <> 195 .and. ;
                mzdyitd->ndruhmzdy <> 421 .and. mzdyitd->ndruhmzdy <> 426 .and. mzdyitd->ndruhmzdy <> 417 .and. mzdyitd->ndruhmzdy <> 427
             if mzdyitd->( dbRlock())
               mzdyhdd->nHodFondUP += mzdyitd->nHodFondPD
             endif
           endif
           mzdyitd->( dbSkip())
         enddo

//         if nsvatek > 0 .and. mzdyhdd->noscisprac < 6839 .and. mzdyhdd->noscisprac > 6845
         if nsvatek > 0 .and. mzdyhdd->cdelkprdob <> '7.50h/d=>5d=37.50h'
           mzdyhdd->nHodFondUP -= nsvatek
         endif

         if mzdyhdd->nHodFondUP < 0
           mzdyhdd->nHodFondUP := 0
         endif

        mzdyitd->( ads_ClearAof())
        mzdyhdd->( dbUnlock())
      endif
//    endif

    drgServiceThread:progressInc()
    mzdyhdd->( dbSkip())
  enddo

  mzdyhdd->(dbCloseArea())
  mzdyitd->(dbCloseArea())

  drgServiceThread:progressEnd()

return .t.



method MZD_servisCtrlPrep_IN:ctrlPrepocCM(drgVar)
  local  lok, cx
  local  recFlt
  local  key
  local  cFiltr
  local  rok, obdobi
  local  dnast, dvyst


//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('DRUHYMZD',,,,,'druhymzda')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')
  drgDBMS:open('MZDYIT',,,,,'mzdyitd')

  obdobi :=  uctOBDOBI:MZD:COBDOBI

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()
  cFiltr := Format("cOBDOBI = '%%'", { obdobi})
  mzdyhdd->( ads_setAof( cFiltr), dbgoTop())
   recFlt := mzdyhdd->( Ads_GetRecordCount())
//   key    := Upper( mzdyhdd->croobcpppv) + StrZero( mzdyhdd->ndruhmzdy, 4)
   drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet èisté mzdy ... ', 'MZDYHDD'), recFlt )

   do while .not. mzdyhdd->( eof())
     if mzdyhdd->( dbRlock())
       mzdyhdd->nCistPriDB := mzdyhdd->nHrubaMzda -                             ;
                              ( mzdyhdd->nOdvoSocPZ +                          ;
                                 mzdyhdd->nOdvoZdrPZ +                         ;
                                  mzdyhdd->nDanCelkem )

       mzdyhdd->nCistPrije := mzdyhdd->nHrubaMzda -                             ;
                                ( mzdyhdd->nOdvoSocPZ +                          ;
                                   mzdyhdd->nOdvoZdrPZ +                         ;
                                    mzdyhdd->nDanCelkem +mzdyhdd->nDanBonusC)

       if mzdyhdd->nCistPriDB <> 0
         if mzdyitd->( dbSeek( Upper( mzdyhdd->croobcpppv) + '0945',,'MZDYIT08'))
           if mzdyitd->( dbRlock())
             mzdyitd->nmzda := mzdyhdd->nCistPriDB
             mzdyitd->( dbUnLock())
           endif
         else
           GenMzdIT( 945,mzdyhdd->nCistPriDB)
         endif
         mzdyitd->( dbUnlock())
       endif

       if mzdyhdd->nCistPrije <> 0
         if mzdyitd->( dbSeek( Upper( mzdyhdd->croobcpppv) + '0940',,'MZDYIT08'))
           if mzdyitd->( dbRlock())
             mzdyitd->nmzda := mzdyhdd->nCistPrije
             mzdyitd->( dbUnLock())
           endif
         else
           GenMzdIT( 940,mzdyhdd->nCistPriDB)
         endif
         mzdyitd->( dbUnlock())
       endif
     endif

/*
   cFiltr := Format("cRoObCpPPV = '%%' and ( nDruhMzdy = 900 or (nDruhMzdy >= 500 and nDruhMzdy <= 519)       ;
                        or (nDruhMzdy >= 530 and nDruhMzdy <= 535) or (nDruhMzdy >= 586 and nDruhMzdy <= 589))", { mzdyhdd->croobcpppv})
   mzdyitd->( ads_setAof( cFiltr), dbgoTop())
    do while .not. mzdyitd->(Eof())
      do case
      if mzdyitd->ndruhmzdy = 900
        mzdyhdw->nCistPriDB += mzdyitd->nmzda
      else
        if mzdyitd->ndruhmzdy = 900
          mzdyhdw->nCistPriDB -= mzdyitd->nmzda
      endif
      mzdyitd->( dbSkip())
    enddo


    if mzdyitd->( dbRlock())


    mzdyitd->( ads_ClearAof())
*/
    mzdyhdd->( dbUnlock())
    drgServiceThread:progressInc()
    mzdyhdd->( dbSkip())
  enddo

  mzdyhdd->(dbCloseArea())
  mzdyitd->(dbCloseArea())

  drgServiceThread:progressEnd()

return .t.


static function GenMzdIT( druhMzdy,mzda)
    local  b_mblock
    local  table
    local  key

     table := 'mzdyhdd'

     key   := StrZero( (table)->nrok,4) +StrZero( (table)->nobdobi,2) +StrZero(druhmzdy,4)
     druhymzda ->( dbSeek( key,,'DRUHYMZD04' ))

     Mh_CopyFld( 'mzdyhdd', 'mzdyitd', .t.)

     mzdyitd->ctypdoklad  := 'MZD_GENCM'
     mzdyitd->ctyppohybu  := 'GENMZDA'
     mzdyitd->cdenik      := 'MC'
     mzdyitd->ndruhmzdy   := druhmzdy
     mzdyitd->cucetskup   := AllTrim( Str(druhmzdy))
//     mzdyitw->nDnyDoklad  := gen_parW->nDnyDoklad
//     mzdyitw->nHodDoklad  := gen_parW->nHodDoklad
//     mzdyitw->nMnPDoklad  := gen_parW->nMnPDoklad
//     mzdyitw->nSazbaDokl  := gen_parW->nSazbaDokl
     mzdyitd->nMzda       := mzda

//     mzdyitd->nZaklSocPo  := gen_parW->nZaklSocPo
//     mzdyitd->nZaklZdrPo  := gen_parW->nZaklZdrPo

     mzdyitd->cTypPohZAV  := druhymzda->cTypPohZAV
     mzdyitd->ccpppv      := mzdyhdd->ccpppv
     mzdyitd->cPolVyplPa  := druhymzda->cPolVyplPa
//     mzdyitd->cVyplMist   := msprc_moc->cVyplMist

//     gen_parW->nDruhMzdy  := gen_parW->nDnyDoklad  := gen_parW->nHodDoklad :=  ;
//     gen_parW->nMnPDoklad := gen_parW-> nSazbaDokl := gen_parW->nMzda :=       ;
//    gen_parW->nZaklSocPo := gen_parW->nZaklZdrPo  := 0


return .t.


method MZD_servisCtrlPrep_IN:ctrlMzdaVRoce(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok, cobdobi
  local  dnast, dvyst
  local  nsvatek
  local  lstavtmp


//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MSPRC_MO',,,,,'msprc_moc')
  drgDBMS:open('MSPRC_MO',,,,,'msprc_mom')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')

  cobdobi := uctOBDOBI:MZD:COBDOBI
  rok := uctOBDOBI:MZD:NROK

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()
  cFiltr := Format("cOBDOBI = '%%'", {cOBDOBI})
  msprc_moc->( ads_setAof( cFiltr), dbgoTop())
  recFlt := msprc_moc->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet stavem a vyplacené mzdy v roce ... ', 'MSPRC_MOC'), recFlt )

  do while .not. msprc_moc->(eof())
    if msprc_moc->( RLock())
      msPrc_moc->lStavem := if( empty( msPrc_moc->ddatVyst), .t.                      ;
                                , if( year( msPrc_moc->ddatVyst) > msPrc_moc->nRok, .t.          ;
                                 , if( month( msPrc_moc->ddatVyst) >= msPrc_moc->nObdobi .AND.      ;
                                    year ( msPrc_moc->ddatVyst)  = msPrc_moc->nRok, .t., .f.)))
      msPrc_moc->nStavem := if( msPrc_moc->lStavem, 1, 0)

      msprc_moc->lmzdavroce := mzdyhdd ->( dbSeek(STRZERO(msprc_moc->nRok,4) +STRZERO(msprc_moc->nOsCisPrac,5) +STRZERO(msprc_moc->nPorPraVzt,3) ,,'MZDYHD06'))

      lstavtmp := .f.
      cFiltr := Format("nROK = %% and nRokObd <= %% and cCpPPV = '%%'", {msprc_moc->nrok, msprc_moc->nrokobd-1, msprc_moc->cCpPPV})
      msprc_mom->( ads_setAof( cFiltr), dbgoTop())
       do while .not. msprc_mom->( eof()) .and. .not. lstavtmp
         lstavtmp := if( empty( msPrc_mom->ddatVyst), .t.                      ;
                            , if( year( msPrc_mom->ddatVyst) > msPrc_mom->nRok, .t.        ;
                             , if( month( msPrc_mom->ddatVyst) >= msPrc_mom->nObdobi .AND. ;
                                    year ( msPrc_mom->ddatVyst)  = msPrc_mom->nRok, .t., .f.)))
         msprc_mom->( dbSkip())
       enddo
      msprc_mom->( ads_clearAof( cFiltr))

      msPrc_moc->lStavRok := if( msPrc_moc->lStavem .or. lstavtmp, .t., .f.)
      msPrc_moc->nStavRok := if( msPrc_moc->lStavRok, 1, 0)

      msprc_moc->( dbUnLock())
    endif
    drgServiceThread:progressInc()
    msprc_moc->( dbSkip())
  enddo

  mzdyhdd->( dbCloseArea())
  msprc_moc->( dbCloseArea())

  drgServiceThread:progressEnd()

return .t.



method MZD_servisCtrlPrep_IN:ctrlDovVObd(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok, cobdobi
  local  dnast, dvyst
  local  nsvatek

  local  cf := "nrok = %% .and. nobdobi <= %% .and. noscisprac = %% .and. nporpravzt = %%"
  local  dovBez := 0, dovMin := 0
  local  cerBez := 0, cerMin := 0
  local  cky

//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MSPRC_MO',,,,,'msprc_moc')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdw')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdc')

  cobdobi := uctOBDOBI:MZD:COBDOBI
  rok := uctOBDOBI:MZD:NROK

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()
  cFiltr := Format("cOBDOBI = '%%'", {cOBDOBI})
  msprc_moc->( ads_setAof( cFiltr), dbgoTop())
  recFlt := msprc_moc->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet dovolené v období ... ', 'MSPRC_MOC'), recFlt )

  do while .not. msprc_moc->(eof())
    if msprc_moc->( RLock())
      mzdyhdw->( dbSeek( msprc_moc->croobcpppv,,'MZDYHD08'))
      *
      if mzdyhdw->nobdobi > 1
        cfiltr := Format( cf, { mzdyhdw->nrok, mzdyhdw->nobdobi-1, mzdyhdw->noscisprac, mzdyhdw->nporpravzt })
        mzdyhdC->( ads_setaof(cfiltr), dbGoTop())
        mzdyhdC->( dbeval( { || (dovBez += mzdyhdC->nDnyDovBPD, dovMin += mzdyhdC->nDnyDovMPD)} ))
      endif

      msprc_moC->nDovMinCeO := 0
      msprc_moC->nDovMinCer := 0
      msprc_moC->nDovMinZus := msprc_moC->nDovMinNar

      msprc_moC->nDovBezCeO := 0
      msprc_moC->nDovBezCer := 0
      msprc_moC->nDovBezZus := msprc_moC->nDovBezNar

      if ( dovMin + mzdyhdw->nDnyDovMPD) = 0
        if (dovBez + mzdyhdw->nDnyDovBPD) <= msprc_moC->nDovMinNar
          msprc_moC->nDovMinCeO := mzdyhdw->nDnyDovBPD
          msprc_moC->nDovMinCer := dovBez + mzdyhdw->nDnyDovBPD
          msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer
        else
          if dovBez <= msprc_moC->nDovMinNar .and. dovBez <> 0
            msprc_moC->nDovMinCeO := mzdyhdw->nDnyDovBPD - ((dovBez + mzdyhdw->nDnyDovBPD) - msprc_moC->nDovMinNar)
            msprc_moC->nDovMinCer := dovBez + msprc_moC->nDovMinCeO
            msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer

            msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD - msprc_moC->nDovMinCeO
            msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO
            msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR
          else
            if dovBez > 0 .and. msprc_moC->nDovMinNar = 0
              msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD
              msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO + dovBez
              msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR
            else
              msprc_moC->nDovMinCeR := msprc_moC->nDovMinNar
              msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCeR

              msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD
              msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO + (dovBez - msprc_moC->nDovMinNar)
              msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR
            endif
          endif
        endif
      else
        if mzdyhdw->nDnyDovMPD <> 0 .or. dovMin <> 0
          msprc_moC->nDovMinCeO := mzdyhdw->nDnyDovMPD
          msprc_moC->nDovMinCer := dovMin + msprc_moC->nDovMinCeO
          msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer
        endif

        if mzdyhdw->nDnyDovBPD <> 0 .or. dovBez <> 0
          msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD
          msprc_moC->nDovBezCer := dovBez + msprc_moC->nDovBezCeO
          msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCer
        endif
      endif

      msprc_moC->nDovZustat := msprc_moC->nDovBezZus +msprc_moC->nDovMinZus
      msprc_moC->nDoDZustat := msprc_moC->nDoDBezZus +msprc_moC->nDoDMinZus

      msprc_moC->nDovNaroCe := msprc_moC->nDovMinNar+msprc_moC->nDovBezNar      ;
                                +msprc_moC->nDoDMinNar+msprc_moC->nDoDBezNar

      msprc_moC->nDovCerOCe := msprc_moC->nDovMinCeO+msprc_moC->nDovBezCeO      ;
                                +msprc_moC->nDoDMinCeO+msprc_moC->nDoDBezCeO

      msprc_moC->nDovCerRCe := msprc_moC->nDovMinCeR+msprc_moC->nDovBezCeR      ;
                                +msprc_moC->nDoDMinCeR+msprc_moC->nDoDBezCeR

      msprc_moC->nDovZustCe := msprc_moC->nDovMinZus +msprc_moC->nDovBezZus     ;
                                +msprc_moC->nDoDMinZus +msprc_moC->nDoDBezZus

      msprc_moc->( dbUnLock())
    endif
    drgServiceThread:progressInc()
    msprc_moc->( dbSkip())
  enddo

  mzdyhdw->( dbCloseArea())
  mzdyhdc->( dbCloseArea())
  msprc_moc->( dbCloseArea())

  drgServiceThread:progressEnd()

return .t.



method MZD_servisCtrlPrep_IN:ctrlPrepMzdyHD(drgVar)
  local  lok, cx, n, m
  local  recFlt
  local  key
  local  cFiltr, cFiltrDMZ
  local  rok, obdobi
  local  dnast, dvyst
  local  aprepAtr

//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('DRUHYMZD',,,,,'druhymzda')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')
  drgDBMS:open('MZDYIT',,,,,'mzdyitd')

  obdobi :=  uctOBDOBI:MZD:COBDOBI
//  aprepAtr := {'nhrubamzda'}
  aprepAtr := {'ndnyfondkd','ndnyfondpd','ndnyodprpd','nhodfondkd','nhodfondpd','nhododprac'}

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()
  cFiltr := Format("cOBDOBI = '%%'", { obdobi})
  mzdyhdd->( ads_setAof( cFiltr), dbgoTop())
  druhymzda->( ads_setAof( cFiltr), dbgoTop())

   recFlt := mzdyhdd->( Ads_GetRecordCount())
//   key    := Upper( mzdyhdd->croobcpppv) + StrZero( mzdyhdd->ndruhmzdy, 4)
   drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet atributù ve MZDYHD ... ', 'MZDYHDD'), recFlt )

   do while .not. mzdyhdd->( eof())
     for n := 1 to len( aprepAtr)
       cx := aprepAtr[n]
       cFiltrDMZ := napocDMZpro( cx, .t. )[1]
       cFiltr := "cRoObCpPPV =" + "'" + mzdyhdd->cRoObCpPPV + "' .and. " + cFiltrDMZ
       mzdyitd->( ads_setAof( cFiltr), dbgoTop())
        if mzdyhdd->( dbRlock())
          mzdyhdd->&cx := 0
          do while .not. mzdyitd->( eof())
//            mzdyhdd->(cx) += mzdyitd->nmzda
            m := at('dny', cx )
            if m > 0
              mzdyhdd->&cx += mzdyitd->ndnyfondpd
            else
              mzdyhdd->&cx += mzdyitd->nhodfondpd
            endif
            mzdyitd->( dbSkip())
          enddo
          mzdyhdd->(dbUnLock())
        endif
       mzdyitd->( ads_clearAof())
     next

    drgServiceThread:progressInc()
    mzdyhdd->( dbSkip())
  enddo

  mzdyhdd->(dbCloseArea())
  mzdyitd->(dbCloseArea())
  druhymzda->(dbCloseArea())

  drgServiceThread:progressEnd()

return .t.



method MZD_servisCtrlPrep_IN:ctrlPrepOdpoc(drgVar)
  local  lok, cx, n, m
  local  recFlt
  local  key
  local  cFiltr, cFiltrDMZ
  local  rok
  local  dnast, dvyst
  local  npor, osorp, oscisprac


//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('msodppol',,,,,'msodppola')

  rok :=  uctOBDOBI:MZD:NROK
//  aprepAtr := {'nhrubamzda'}

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()
  cFiltr := Format("nROK = %% and Left(ctypodppol,3) = 'DIT'", { rok })
  msodppola->( ads_setAof( cFiltr), dbgoTop())
  msodppola->( OrdSetFOCUS( 'MSODPP11'))

   recFlt := msodppola->( Ads_GetRecordCount())
//   key    := Upper( mzdyhdd->croobcpppv) + StrZero( mzdyhdd->ndruhmzdy, 4)
   drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet poøadí pro odpoèty ... ', 'MSODPPOLA'), recFlt )

   npor      := 1
   osorp     := msodppola->ncisosorp
   oscisprac := msodppola->noscisprac

   do while .not. msodppola->( eof())
     if msodppola->ncisosorp = osorp
     else
       npor  += 1
       osorp := msodppola->ncisosorp
     endif

     if msodppola->noscisprac <> oscisprac
       oscisprac := msodppola->noscisprac
       npor  := 1
     endif

     if msodppola->( dbRlock())
       msodppola->nporadi := npor
       msodppola->(dbUnlock())
     endif

     drgServiceThread:progressInc()
     msodppola->( dbSkip())
   enddo

  msodppola->(dbCloseArea())

  drgServiceThread:progressEnd()

return .t.



function napocDMZpro( atributMzHD, filtr)
  local admz := {}
  local aret := {}
  local n

  default filtr to .f.

  druhymzda->( dbGoTop())
  do while .not. druhymzda->( eof())
    if at( Upper(atributMzHD), Upper(druhymzda->mdefNap)) > 0
      aadd(admz, druhymzda->ndruhmzdy)
    endif
    druhymzda->( dbSkip())
  enddo

  if filtr
    aadd(aret, '(' )
    for n := 1 to len(admz)
      aret[1] += 'ndruhmzdy = ' + Str(admz[n]) + if( n = len(admz), ')', ' .or. ')
    next
  else
    aret := admz
  endif

return( aRET)


method MZD_servisCtrlPrep_IN:ctrlPrepMsOsb(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok


//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MSPRC_MO',,,,,'msprc_mod')
  drgDBMS:open('MSOSB_MO',,,,,'msosb_mod')

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()

///  oprava sts

  cFiltr := Format("nMsOsb_MO = %% ", { 0 })
  msprc_mod->( ads_setAof( cFiltr), dbgoTop())
  recFlt := msprc_mod->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Doplnìní do MSOSB_MO z MSPRC_MO - chybìjící záznamy ... ', 'MZDDAVITD'), recFlt )

  do while .not. msprc_mod->(Eof())
    mh_copyfld('msprc_mod','msosb_mod',.t.)

    msosb_mod->croobcp := StrZero(msosb_mod->nrok,4) +       ;
                           StrZero(msosb_mod->nobdobi,2) +   ;
                            StrZero(msosb_mod->noscisprac,5)

    if msprc_mod->( dbRlock())
      msprc_mod->nmsosb_mo := msosb_mod->sid
      msprc_mod->(dbUnlock())
    endif

    drgServiceThread:progressInc()
    msprc_mod->( dbSkip())
  enddo

  drgServiceThread:progressEnd()

return( .t.)


method MZD_servisCtrlPrep_IN:ctrlPrepMzdNem(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok
  local  ckey
  local  nsid

//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('c_typpoh',,,,,'c_typpohd')
  drgDBMS:open('mzdnemoc',,,,,'mzdnemocd')
  drgDBMS:open('druhymzd',,,,,'druhymzdd')
  drgDBMS:open('mzddavit',,,,,'mzddavitd')
  drgDBMS:open('mzddavhd',,,,,'mzddavhdd')

//  nrok=2013 and nporadi<>0 and ndruhmzdy >= 400 and ndruhmzdy <= 499

  drgServiceThread:new()

///  oprava sts

  INDEX ON (StrZero(mzddavhdd->noscisprac,5)+StrZero(mzddavhdd->nporpravzt,3)+StrZero(mzddavhdd->nporadi,6)+StrZero(mzddavhdd->nrokobd,6)) TO (drgINI:dir_USERfitm +'mzdtmid') DESCENDING
  cFiltr := Format("nPoradi <> %% ", { 0 })
  mzddavhdd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzddavhdd->( Ads_GetRecordCount())

//  mzddavhdd->( OrdSetFocus( ))

  drgServiceThread:progressStart(drgNLS:msg('Uprav poslední záznamy - nemocenky ... ', 'MZDDAVITD'), recFlt )

  do while .not. mzddavhdd->( Eof())
    if mzddavhdd->( dbRlock())
      mzddavhdd->nlastnem := 0
      mzddavhdd->(dbUnlock())
    endif
    mzddavhdd->( dbSkip())
  enddo

  mzddavhdd->(dbGoTop())
  ckey := ''
  do while .not. mzddavhdd->( Eof())
    if ckey <> (StrZero(mzddavhdd->noscisprac,5)+StrZero(mzddavhdd->nporpravzt,3)+StrZero(mzddavhdd->nporadi,6))
      if mzddavhdd->( dbRlock())
        mzddavhdd->nlastnem := 1
        mzddavhdd->(dbUnlock())
      endif

      ckey := StrZero(mzddavhdd->noscisprac,5)+StrZero(mzddavhdd->nporpravzt,3)+StrZero(mzddavhdd->nporadi,6)
    endif
    mzddavhdd->( dbSkip())
  enddo

  drgServiceThread:new()

  mzddavhdd->( dbClearIndex())

  drgServiceThread:progressStart(drgNLS:msg('Vytváøí záznamy pro celkový pohled na nemocenky ... ', 'mzdnemocd'), recFlt )

  mzdnemocd->( dbGoTop())
  do while .not. mzdnemocd->(Eof())
    if mzdnemocd->( dbRlock())
      mzdnemocd->( dbDelete())
      mzdnemocd->(dbUnlock())
    endif
    mzdnemocd->( dbSkip())
  enddo

  cFiltr := Format("nPoradi <> %% and nlastnem = 1", { 0 })
  mzddavhdd->( ads_setAof( cFiltr), dbgoTop())
  recFlt := mzddavhdd->( Ads_GetRecordCount())

  do while .not. mzddavhdd->(Eof())
    mh_copyfld('mzddavhdd','mzdnemocd',.t.)

    ckey := UPPER(mzdnemocd->cULOHA)+UPPER(mzdnemocd->CTYPDOKLAD) +UPPER(mzdnemocd->CTYPPOHYBU)
    if c_typpohd->( dbSeek( ckey,,'C_TYPPOH05'))
      mzdnemocd->cnazev := c_typpohd->CNAZTYPPOH
    endif

    if mzddavhdd->( dbRlock())
      mzddavhdd->nmzdnemoc := mzdnemocd->sid

      cFiltr := Format("nrok = %% and nobdobi = %% and cdenik = '%%' and ndoklad = %%", { mzddavhdd->nrok, mzddavhdd->nobdobi,'MN',mzddavhdd->ndoklad })
      mzddavitd->( ads_setAof( cFiltr), dbgoTop())

      do while .not. mzddavitd->(Eof())
        if mzddavitd->( dbRlock())
          mzddavitd->nmzdnemoc := mzdnemocd->sid
          mzddavitd->(dbUnlock())
        endif
        mzddavitd->( dbSkip())
      enddo
      mzddavhdd->(dbUnlock())
    endif

    drgServiceThread:progressInc()
    mzddavhdd->( dbSkip())
  enddo

  drgServiceThread:progressEnd()

return( .t.)