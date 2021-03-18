#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
*
#include "..\Asystem++\Asystem++.ch"


*
** CLASS MZD_mzvyucdane_CRD ****************************************************
CLASS MZD_mzvyucdane_CRD FROM drgUsrClass
exported:
  var     task
  method  init, drgDialogStart, drgDialogEnd
  method  generuj_vypdan


  inline method drgDialogInit(drgDialog)
//    drgDialog:dialog:drawingArea:bitmap  := 1019
//    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    RETURN self

  inline method postValidate(drgVar)
    if( drgVar:changed(), drgVar:save(), nil )
    MZD_mzvyucdane_CRD_dyn()
    ::refresh(drgVar)
    return .t.

  inline method mzd_vyucDane_plat()
    local odialog

    odialog := drgDialog():new( 'mzd_vyucDane_plat', ::drgDialog)
    odialog:create(,,.T.)
    odialog:destroy()
    odialog := nil
  return self
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case ( nEvent = drgEVENT_SAVE )
/*
      if vyucDanew->nMZDDAVHD <> 0
        mzdDavhd->( dbseek( vyucDanew->nMZDDAVHD,, 'ID'))

        cinfo := 'Promiòte prosím,'                    +CRLF + ;
                 'roèní zúètování danì nelze uložit, ' +CRLF + ;
                 'byl již vygenerován mzdový doklad [ ' +allTrim( str( mzdDavhd->ndoklad)) +' ]' + ' pro zpracování ...' +CRLF +CRLF

        ConfirmBox( , cinfo                                           , ;
                     'Nelze uložit záznam roèního zúètování danì ...' , ;
                      XBPMB_OK                                        , ;
                      XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE      )
        _clearEventLoop(.t.)
*/

      if ::can_save_doklad()
        ::cmp_mzvyucdane()

        if vyucdanew->_nrecOr <> 0
          if vyucdane->(dbRlock())
            mh_copyFld( 'vyucdanew', 'vyucdane' )
          endif
        else
          mh_copyFld( 'vyucdanew', 'vyucdane', .t. )
        endif
        vyucDane->( dbunlock(), dbCommit())
        vyucDani->( dbunlock(), dbCommit())
      endif

      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      return .t.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE .or. ;
           nEvent = drgEVENT_SAVE        )
      return .t.

    endcase
  return .f.

hidden:
  method  gen_mzvyucdane, cmp_mzvyucdane
* sys
  var     msg, dm, dc, df, ab, oabro, xbp_therm, cparm
  var     oBtn_mzd_generuj_vypdan, oBtn_save
  var     cx_rows, cx_fields
* datové
  var     culoha, rok, nobdobi, pa_obdZpr, radek


  inline method refresh(drgVar)
    LOCAL  nIn, nFs, odrg
    LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
    //
    LOCAL  dc       := ::drgDialog:dialogCtrl
    LOCAL  dbArea   := ALIAS(dc:dbArea)

* 1- kotrola jen pro datové objekty aktuální DB
* 2- kominace refresh tj. znovunaètení dat
*  - mìl by probìhnout refresh od aktuálního prvku dolù

//    nFs := AScan(vars:values, {|X| X[1] = Lower(drgVar:Name) })

    for nIn := 1 to vars:size() step 1
      oVar := vars:getNth(nIn)

      if isBlock( ovar:block )
        xVal := eval( ovar:Block )

        if ovar:value <> xVal
          ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    NEXT
  RETURN .T.


  inline method can_save_doklad()
    local  nrok    := uctOBDOBI_LAST:MZD:NROK
    local  nobdobi := uctOBDOBI_LAST:MZD:NOBDOBI
    local  mzd_is_close, mzd_is_dokl := 0, isOk := .t.
    local  cinfo   := 'Promiòte prosím,'                    +CRLF + ;
                      'roèní zúètování danì nelze uložit, ' +CRLF

     mzd_is_close := mzdZavHD->( dbseek( strZero(nrok,4) +strZero(nobdobi,2) +'1',,'MZDZAVHD13'))

     if isNull( vyucDane->sID, 0) <> 0
       mzdDavitS->( ordSetFocus('VYUCDANE')                            , ;
                    dbsetScope(SCOPE_BOTH, isNull( vyucDane->sID, 0))              , ;
                    dbGoTop()                                          , ;
                    dbeval( { || mzd_is_dokl := mzdDavitS->ndoklad }   , ;
                            { || mzdDavitS->nrok = nrok .and. mzdDavitS->nobdobi = nobdobi } ), ;
                    dbclearScope()                                       )
     endif

     do case
     case mzd_is_close
       isOk  := .f.
       cinfo += 'období úlohy mzdy [' +str(nobdobi,2) +'/' +str(nrok,4) +' ] je již uzavøeno ...' +CRLF +CRLF

     case mzd_is_dokl <> 0
       isOk  := .f.
       cinfo += 'pro období úlohy mzdy [' +str(nobdobi,2) +'/' +str(nrok,4) +' ] ' +CRLF + ;
                'byl již vygenerován mzdový doklad [ ' +allTrim( str( mzd_is_dokl)) +' ] pro zpracování ...' +CRLF +CRLF
     endcase

     if mzd_is_close .or. mzd_is_dokl <> 0
       ConfirmBox( , cinfo                                           , ;
                    'Nelze uložit záznam roèního zúètování danì ...' , ;
                     XBPMB_OK                                        , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE      )
       _clearEventLoop(.t.)
     endif
  return isOk

ENDCLASS


method MZD_mzvyucdane_CRD:init(parent)
  local  task := 'mzd'

  ::drgUsrClass:init(parent)
  ::cParm     := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm     := Left( ::cParm,1)

  if isArray(parent:parent:odBrowse)
    if( len(parent:parent:odBrowse)) >= 1
      ::oabro := parent:parent:odBrowse[1]
    endif
  endif

  ::rok := uctOBDOBI:MZD:NROK

  drgDBMS:open('msprc_mo')
  drgDBMS:open('osoby'   )
  drgDBMS:open('msodppol'   )

  drgDBMS:open('mzdyHd'  )
  drgDBMS:open('mzdyIt'  )

  drgDBMS:open( 'vyucdane' )
  drgDBMS:open( 'vyucdani' )
  drgDBMS:open( 'mzdDavhd' )
  drgDBMS:open( 'mzdDavit',,,,,'mzdDavitS')
  *
  drgDBMS:open('mzdZavhd')
  *
  drgDBMS:open('vyucdanew',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('vyucdaniw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
return self


method MZD_mzvyucdane_CRD:drgDialogStart(drgDialog)
  local  members := drgDialog:oActionBar:members, x, className

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  *
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgPushButton'
      if     isCharacter( members[x]:event )
        if( lower(members[x]:event) = 'mzd_generuj_vypdan', ::oBtn_mzd_generuj_vypdan := members[x], nil )
      elseif isNumber( members[x]:event )
        if( members[x]:event = drgEVENT_SAVE              , ::oBtn_save               := members[x], nil )
      endif
    endcase
  next

  isEditGet( { 'vyucDanew->nDZD_Celk' , 'vyucDanew->nNEZ_celk' , 'vyucDanew->nZaklDane' , ;
               'vyucDanew->nVypocDan' , 'vyucDanew->nSLD_celk' , 'vyucDanew->nDSL_celk' , ;
               'vyucDanew->nPrepNedop', 'vyucDanew->nDZB_Zames', 'vyucDanew->nZDS_dan'  , ;
               'vyucDanew->nZDS_Rozd' , 'vyucDanew->nMDB_rozd' , 'vyucDanew->nKVR_danBo', ;
               'vyucDanew->nDoplZu31a', 'vyucDanew->nDoplZu31b'                           }, drgDialog, .f. )

  if msPrc_mo->lDanVypoc
    if .not. vyucdane->( eof())
      mh_copyFld( 'vyucdane', 'vyucdanew',.t., .t.)
    else
      ::generuj_vypdan()
    endif
  endif

  if vyucDanew->nMZDDAVHD <> 0
    ::oBtn_mzd_generuj_vypdan:disable()
    ::oBtn_save:disable()
  endif

  ::refresh()
return self


method MZD_mzvyucdane_CRD:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

  mzdDavitS->(dbcloseArea())
return self


method MZD_mzvyucdane_CRD:generuj_vypdan()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  nod, ndo, ok
  local  filtrs
  *
  local  cky, ncisRadku := 1, ncisListu := 1
  local  celkem    := 0
  local  xx, yy
*
  local  cf := "nrok = %% .and. nosCisPrac = %%"
  local  cfiltr

  *
  ok := .t.
  mh_copyFld( 'msprc_mo', 'vyucdanew', .t. )

    vyucDanew->nmsPrc_mo  := isNull( msPrc_mo->sID, 0)
    vyucDanew->nMSOSB_MO  := msPrc_mo->nMSOSB_MO

//  vyucdanew->nrok       := ::rok
//  vyucdanew->crodcispra := osoby->crodcisosb

  ::gen_mzvyucdane()

  vyucDanew->(dbcommit())

//   uložíme podklady vyucdanI

  cfiltr := format( cf, {vyucdanew->nrok,vyucdanew->nosCisPrac})
  vyucdani->( ads_setAof( cfiltr ), dbgoTop() )
  vyucdani->( dbEval( {|| if( dbRlock(), dbDelete(), ok := .f.)}))
  vyucdani->( dbUnlock())
  if ok
    vyucdaniw->( dbGoTop())
    vyucdaniw->( dbEval( {|| mh_copyFld( 'vyucdaniw', 'vyucdani', .t. )}))
  endif

*                Personal ->( dbSeek( Cs_Upper( MsPrc_Mz ->cRodCisPra)))
*                VyucDANE ->( dbAppend(), Sx_RLock())
*
*                VyucDANE ->nROK       := ACT_OBDyn()
*                VyucDANE ->cKmenStrPr := MsPrc_Mz ->cKmenStrPr
*                VyucDANE ->cNazPol1   := MsPrc_Mz ->cKmenStrPr
*                VyucDANE ->nOsCisPrac := MsPrc_Mz ->nOsCisPrac
*                VyucDANE ->cJmenoPrac := Personal ->cPracovnik

*                VyucDANE ->cRodCisPra := MsPrc_Mz ->cRodCisPra
*                VyucDANE ->cBydliste  := Alltrim( Personal ->cUlice) + ", "  ;
*                                          + Alltrim( Personal ->cMisto)
*                VyucDANE ->cPSC       := Personal ->cPSC


return .t.


method MZD_mzvyucdane_CRD:gen_mzvyucdane()
  local cKOD, cKOD3, cX, cY
  local nstep, nX, nY
  local dzac, czac
  local dkon, ckon
  local anVyuDAN, anVyuDANi
  local xKEYn

  anVyuDAN  := {{0,0,0,0,0},{0,0,0,0,0},0,0,0,0,0,0,0,0                    ;
               ,{0,0,0,0,0},0,0,{0,0,0,0,0}}
  nX        := 0
  xKEYn     := StrZero(vyucdanew->noscisprac,5) +StrZero(vyucdanew->nrok,4)

  if( msodppol ->( dbSeek( xKEYn +Upper( "ZAKL"),,'MSODPP08')),         ;
                             anVyuDAN[ 3] += MsOdpPol ->ndanULrok, 0)     // daòová úleva
  if( msodppol ->( dbSeek( xKEYn +Upper( "MANZ"),,'MSODPP08')),         ;
                             anVyuDAN[ 4] += MsOdpPol ->nOdpocRok, 0)     // odpoŸet na man§elku(a)

  osoby->( dbseek( msPrc_mo->ncisOsoby,,'OSOBY01'))
  vyucdanew->cUlice     := osoby->cUlice
  vyucdanew->cCisPopis  := osoby->cCisPopis
  vyucdanew->culicCiPop := osoby->culicCiPop
  vyucdanew->cmisto     := osoby->cmisto
  vyucdanew->cpsc       := osoby->cpsc
  vyucdanew->cZkratStat := osoby->cZkratStat
//  vyucdanew->cPosta     := osoby->cPosta

  for n := 1 to 12
    anVyuDANi := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    xKEYit := StrZero( vyucdanew->nrok,4) +StrZero( n, 2) +StrZero( vyucdanew->nOsCisPrac, 5)

    mh_copyFld( 'msprc_mo', 'vyucdaniw', .t. )
    vyucdaniw->nrok       := ::rok
    vyucdaniw->nobdobi    := n

    mzdyit ->(ordSetFocus('MZDYIT08'), dbsetscope(SCOPE_BOTH, xKEYit), DbGoTop() )

     do while .not. mzdyit ->( Eof())
       do case
       case mzdyit->nDruhMzdy = 901 .or. mzdyit->nDruhMzdy = 902  ;
            .or.( mzdyit->nDruhMzdy >= 914 .AND. mzdyit->nDruhMzdy <= 917)
         anVyuDANi[ 1] += mzdyit->nMzda      // zdanit pøíjem

       case ( mzdyit->nDruhMzdy >= 704 .and. mzdyit->nDruhMzdy <= 709)  ;
            .or. Mzdyit->nDruhMzdy = 718  // .OR. Mzdy ->nDruhMzdy = 719    // .OR. Mzdy ->nDruhMzdy = 586  ;
//                                                      .OR. Mzdy ->nDruhMzdy = 587
         anVyuDANi[ 2] += mzdyit->nMzda      // soc a zdravotní pojištìní

       case mzdyit->nDruhMzdy = 972
         anVyuDANi[ 3] += mzdyit ->nMzda      // odpoèet na pracovníka

       case mzdyit->nDruhMzdy = 960
         anVyuDANi[ 4] += mzdyit->nMzda      // odpoèet na dìti

       case mzdyit->nDruhMzdy = 975 .and.      ;
             ( MsPrc_Mo ->nTypDuchod = 7 .or. MsPrc_Mo ->nTypDuchod = 13 .or. MsPrc_Mo ->nTypDuchod = 14)
         anVyuDANi[ 5] += mzdyit->nMzda      // odpoèet na èásteènou inval.

       case mzdyit->ndruhMzdy = 975 .and.      ;
             ( MsPrc_Mo ->nTypDuchod = 5 .or. MsPrc_Mo ->nTypDuchod = 15)
         anVyuDANi[ 6] += mzdyit->nMzda      // odpoèet na plnou inval.

       case mzdyit->nDruhMzdy = 975 .and.      ;
             ( MsPrc_Mo ->nTypDuchod = 6 .or. ( MsPrc_Mo ->nTypDuchod = 15 .and. MsPrc_Mo ->lPrukazZPS))
         anVyuDANi[ 7] += mzdyit->nMzda      // odpoèet na ZTP-P

       case mzdyit->nDruhMzdy = 974
         anVyuDANi[ 8] += mzdyit->nMzda      // odpoèet na studenta

       case mzdyit->nDruhMzdy = 936
         anVyuDANi[ 9] += mzdyit->nMzda      // odpoèet na úrok

       case mzdyit->nDruhMzdy = 501 .or. mzdyit->nDruhMzdy = 502              ;
             .or. mzdyit->nDruhMzdy = 503 .or. mzdyit->nDruhMzdy = 530         ;
              .or.( mzdyit->nDruhMzdy >= 514 .and. mzdyit->nDruhMzdy <= 517)   ;
               .or.( mzdyit->nDruhMzdy >= 532 .and. mzdyit->nDruhMzdy <= 535)
         anVyuDANi[ 10] += mzdyit->nMzda      // sražená daò
         if mzdyit ->nDruhMzdy = 530
           anVyuDANi[ 12] += ( mzdyit->nMzda * -1)  // sražená  sleva na dani
         endif

       case mzdyit->nDruhMzdy = 970
         do case
         case mzdyit->nrok = 2016      // zmìna sazby pro rok 2016
           if mzdyit->nobdobi < 5
             do case
             case mzdyit->nMzda = 1317  ;   anVyuDANi[ 11] += 1417
             case mzdyit->nMzda = 1417  ;   anVyuDANi[ 11] += 1717
             otherwise                  ;   anVyuDANi[ 11] += mzdyit->nMzda
             endcase
           else
             anVyuDANi[ 11] += mzdyit->nMzda
           endif

         case mzdyit->nrok = 2017      // zmìna sazby pro rok 2017
           if mzdyit->nobdobi < 7
             do case
             case mzdyit->nMzda = 1417  ;   anVyuDANi[ 11] += 1617
             case mzdyit->nMzda = 1717  ;   anVyuDANi[ 11] += 2017
             otherwise                  ;   anVyuDANi[ 11] += mzdyit->nMzda
             endcase
           else
             anVyuDANi[ 11] += mzdyit->nMzda
           endif
         otherwise
           anVyuDANi[ 11] += mzdyit->nMzda      // sleva na dani za dítì nárok
         endcase

       case mzdyit->nDruhMzdy = 531
         anVyuDANi[ 13] += ( mzdyit->nMzda * -1)       // sražený bonus

       endcase

       mzdyit->( dbSkip())
     enddo
    mzdyit->( dbClearScope())

    vyucdaniw ->nUZD_Zames := anVyuDANi[ 1]      // úhrn zdanitelného pøíjmu
    vyucdaniw ->nPOJ_Zames := anVyuDANi[ 2]      // pojištìní
    vyucdaniw ->nNEZ_Prac  := anVyuDANi[ 3]      // odpoèet za zamìstnance
    vyucdaniw ->nNEZ_Deti  := anVyuDANi[ 4]      // odpoèet za dìti
    vyucdaniw ->nNEZ_CasIn := anVyuDANi[ 5]      // odpoèet èásteèná invalidita
    vyucdaniw ->nNEZ_PlnIn := anVyuDANi[ 6]      // odpoèet plná invalidita
    vyucdaniw ->nNEZ_ZTP   := anVyuDANi[ 7]      // odpoèet držitel ZTP-P
    vyucdaniw ->nNEZ_Stud  := anVyuDANi[ 8]      // odpoèet na studenta
    vyucdaniw ->nNEZ_Uver  := anVyuDANi[ 9]      // odpoèet na úroky z úvìru
    vyucdaniw ->nUSZ_Zames := anVyuDANi[10]     // celkem daò
    vyucdaniw ->nDZN_Zames := anVyuDANi[11]     // nárok na slevu
    vyucdaniw ->nDZS_Zames := anVyuDANi[12]     // sleva na dani
    vyucdaniw ->nMDB_Vypl  := anVyuDANi[13]     // daòový bonus
    vyucdaniw ->nDZD_Zames := anVyuDANi[ 1] + anVyuDANi[ 2]
    vyucdaniw ->nNEZ_Celk  := anVyuDANi[ 9]
    vyucdaniw ->nZDA_Mzda  := vyucdaniw ->nDZD_Zames - vyucdaniw ->nNEZ_Celk

    anVyuDAN[ 1,1] += anVyuDANi[ 1]      // úhrn zdanitelného pøíjmu
    anVyuDAN[ 2,1] += anVyuDANi[ 2]      // pojištìní
*    anVyuDAN[ 3]   += anVyuDANi[ 3]      // odpoèet za zamìstnance
    anVyuDAN[ 6]   += anVyuDANi[ 5]      // odpoèet èásteèná invalidita
    anVyuDAN[ 7]   += anVyuDANi[ 6]      // odpoèet plná invalidita
    anVyuDAN[ 8]   += anVyuDANi[ 7]      // odpoèet držitel ZTP-P
    anVyuDAN[ 9]   += anVyuDANi[ 8]      // odpoèet na studenta
    anVyuDAN[10]   += anVyuDANi[ 9]      // odpoèet na úroky z úvìru
    anVyuDAN[11,1] += anVyuDANi[10]      // celkem daò
    anVyuDAN[12]   += anVyuDANi[11]      // nárok na slevu
    anVyuDAN[13]   += anVyuDANi[12]      // daòové zvýhodnìní - sleva na dani
    anVyuDAN[14,1] += anVyuDANi[13]      // daòový bonus

    vyucdaniw->(dbcommit())

  next

*  1
  vyucdanew ->nUPR_Zames := anVyuDAN[ 1,1]
  vyucdanew ->nUPR_PlatA := vyucdanew ->nUPR_Zames
  vyucdanew ->nUPR_Celk  := vyucdanew ->nUPR_PlatA + vyucdanew ->nUPR_PlatB ;
                             + vyucdanew ->nUPR_PlatC + vyucdanew ->nUPR_PlatD ;
                               + vyucdanew ->nUPR_PlatE
*  2
  vyucdanew ->nPOJ_Zames := anVyuDAN[ 2,1]
  vyucdanew ->nPOJ_PlatA := vyucdanew ->nPOJ_Zames
  vyucdanew ->nPOJ_Celk  := vyucdanew ->nPOJ_PlatA + vyucdanew ->nPOJ_PlatB    ;
                             + vyucdanew ->nPOJ_PlatC + vyucdanew ->nPOJ_PlatD ;
                               + vyucdanew ->nPOJ_PlatE
*  3 noEdit
  vyucdanew ->nDZD_Zames := vyucdanew ->nUPR_Zames + vyucdanew ->nPOJ_Zames
  vyucdanew ->nDZD_PlatA := vyucdanew ->nUPR_PlatA + vyucdanew ->nPOJ_PlatA
  vyucdanew ->nDZD_PlatB := vyucdanew ->nUPR_PlatB + vyucdanew ->nPOJ_PlatB
  vyucdanew ->nDZD_PlatC := vyucdanew ->nUPR_PlatC + vyucdanew ->nPOJ_PlatC
  vyucdanew ->nDZD_PlatD := vyucdanew ->nUPR_PlatD + vyucdanew ->nPOJ_PlatD
  vyucdanew ->nDZD_PlatE := vyucdanew ->nUPR_PlatE + vyucdanew ->nPOJ_PlatE

  vyucdanew ->nDZD_Celk  := vyucdanew ->nDZD_PlatA + vyucdanew ->nDZD_PlatB ;
                             + vyucdanew ->nDZD_PlatC + vyucdanew ->nDZD_PlatD ;
                               + vyucdanew ->nDZD_PlatE
*  4 nNEZ_dary
*  5
  vyucdanew ->nNEZ_Uver  := anVyuDAN[10]
*  6 nNEZ_penPr
*  7 nNEZ_soZip
*  8 nNEZ_clPOO
*  9 nNEZ_ZkVzd
* 10 noEdit  10 := 4 +5 +6 +7 +8 +9
  vyucdanew ->nNEZ_Celk  := vyucdanew ->nNEZ_Uver +vyucdanew ->nNEZ_Dary
* 11 noEdit  11 := 3 -10
  vyucdanew ->nZaklDane  := Mh_RoundNumb( vyucDanew->nDZD_Celk -vyucDanew->nNEZ_Celk, 53)
* 12 noEdit  12 Fce
  vyucdanew ->nVypocDan  := fDanVypRO( vyucdanew->nZaklDane)
* 13
  vyucdanew ->nNEZ_Prac  := anVyuDAN[ 3]
* 14
  vyucdanew ->nNEZ_Manz  := anVyuDAN[ 4]
* 15
  vyucdanew ->nNEZ_CasIn := anVyuDAN[ 6]
* 16
  vyucdanew ->nNEZ_PlnIn := anVyuDAN[ 7]
* 17
  vyucdanew ->nNEZ_ZTP   := anVyuDAN[ 8]
* 18
  vyucdanew ->nNEZ_Stud  := anVyuDAN[ 9]
* ??
  vyucdanew ->nNEZ_Deti  := anVyuDAN[ 5]
* 19 noEdit  19 := 13 +14 +15 +16 +17 +18
  vyucdanew ->nSLD_Celk  := vyucdanew ->nNEZ_Prac +vyucdanew ->nNEZ_Manz      ;
                              +vyucdanew ->nNEZ_CasIn +vyucdanew ->nNEZ_PlnIn  ;
                                 +vyucdanew ->nNEZ_ZTP +vyucdanew ->nNEZ_Stud

  vyucdanew ->nDSL_Celk  := vyucdanew ->nVypocDan - vyucdanew->nSLD_Celk
  vyucdanew ->nUSZ_Zames := anVyuDAN[ 11, 1]
  vyucdanew ->nUSZ_PlatA := vyucdanew ->nUSZ_Zames
  vyucdanew ->nUSZ_Celk  := vyucdanew ->nUSZ_PlatA + vyucdanew ->nUSZ_PlatB    ;
                               + vyucdanew ->nUSZ_PlatC + vyucdanew ->nUSZ_PlatD ;
                                   + vyucdanew ->nUSZ_PlatE
  if anVyuDAN[12] = 0
    vyucdanew ->nPrepNedop := vyucdanew ->nUSZ_Celk - vyucdanew->nDSL_Celk
    vyucdanew ->cPrepNedop := IF( vyucdanew ->nPrepNedop > 0, "PØEPLATEK ", ;
                                              "NEDOPLATEK")
  else
    vyucdanew ->nDZN_Zames := anVyuDAN[12]        // nárok na slevu
    if vyucdanew->nDSL_Celk > vyucdanew ->nDZN_Zames
      vyucdanew ->nDZS_Zames := vyucdanew ->nDZN_Zames
    else
      vyucdanew ->nDZS_Zames := vyucdanew->nDSL_Celk
    endif
    vyucdanew ->nDZB_Zames := vyucdanew ->nDZN_Zames - vyucdanew ->nDZS_Zames
    do case
    case vyucdanew ->nDZB_Zames > 60300
      vyucdanew ->nDZB_Zames := 60300      // daòový bonus
    case vyucdanew ->nDZB_Zames < 100
      vyucdanew ->nDZB_Zames := 0          // daòový bonus
    endcase

    vyucdanew ->nDZS_PlatA := vyucdanew ->nDZS_Zames        // uskuteènìná sleva
    vyucdanew ->nDZS_Celk  := vyucdanew ->nDZS_Zames        // uskuteènìná sleva
    vyucdanew ->nZDS_Dan   := vyucdanew->nDSL_Celk - vyucdanew ->nDZS_Celk
    vyucdanew ->nZDS_Rozd  := vyucdanew ->nUSZ_Celk - vyucdanew ->nZDS_Dan
    vyucdanew ->nMDB_Zames := anVyuDAN[14, 1]
    vyucdanew ->nMDB_PlatA := anVyuDAN[14, 1]
    vyucdanew ->nMDB_Celk  := vyucdanew ->nMDB_PlatA +vyucdanew ->nMDB_PlatB   ;
                               +vyucdanew ->nMDB_PlatC +vyucdanew ->nMDB_PlatD ;
                                 +vyucdanew ->nMDB_PlatE
    vyucdanew ->nMDB_Rozd  := vyucdanew ->nDZB_Zames - vyucdanew ->nMDB_Celk
    vyucdanew ->nKVR_DanBo := vyucdanew ->nZDS_Rozd + vyucdanew ->nMDB_Rozd
    vyucdanew ->cKVR_DanBo := IF( vyucdanew ->nKVR_DanBo > 0, "Doplatek ze zúètování" ;
                                                , "Nedoplatek ze zúètování" )
    vyucdanew ->nDoplZu31a := vyucdanew ->nZDS_Rozd
    vyucdanew ->nDoplZu31b := vyucdanew ->nMDB_Rozd
  endif

  MZD_mzvyucdane_CRD_dyn()
return .t.


method MZD_mzvyucdane_CRD:cmp_mzvyucdane()
  local         cX, cY
  local  nstep, nX, nY
  local  pa

return self

/*
UZD  =  UPR
*/

static function MZD_mzvyucdane_CRD_dyn()
  local  ndanZakl := 0, ndanVyp := 0, ndanTmp := 0, ndanSle := 0
  local  nprepNed := 0, n31a    := 0, n31b    := 0

  vyucDanew->nZDS_Dan   := 0   // 26
  vyucDanew->nZDS_Rozd  := 0   // 27
  vyucDanew->cKVR_DanBo := ''
  vyucDanew->nMDB_Rozd  := 0   // 29
  vyucDanew->nKVR_DanBo := 0   // 30

*  3 := 1 + 2
  vyucDanew->nDZD_Celk := vyucDanew->nUPR_Celk  +vyucDanew->nPOJ_Celk
* 10 := 4 + 5 + 6 + 7 +8 +9
  vyucDanew->nNEZ_Celk := vyucDanew->nNEZ_Dary  +vyucDanew->nNEZ_Uver  + ;
                          vyucDanew->nNEZ_PenPr +vyucDanew->nNEZ_SoZiP + ;
                          vyucDanew->nNEZ_ClPOO +vyucDanew->nNEZ_ZkVzd
* 11
  ndanZakl := mh_roundNumb(vyucDanew->nDZD_Celk -vyucDanew->nNEZ_Celk,53)
  vyucDanew->nZaklDane := ndanZakl
* 12
  ndanVyp := fDanVypRO( ndanZakl )
  vyucDanew->nVypocDan := ndanVyp
* 19 := 13 +14 +15 +16 +17 +18
  vyucDanew->nSLD_Celk := vyucDanew->nNEZ_Prac  +vyucDanew->nNEZ_Manz  + ;
                          vyucDanew->nNEZ_CasIn +vyucDanew->nNEZ_PlnIn + ;
                          vyucDanew->nNEZ_ZTP   +vyucDanew->nNEZ_Stud  + ;
                          vyucDanew->nNEZ_UmDit
* 20
  ndanTmp := vyucDanew->nSLD_Celk
  ndanSle := ndanVyp - ndanTmp
  ndanSle := if( ndanSle < 0, 0, ndanSle)
  vyucDanew->nDSL_Celk := ndanSle

* 23
  if vyucDanew->nDZN_Zames > 0
    if vyucDanew->nDSL_Celk > vyucDanew->nDZN_Zames
      vyucDanew->nDZS_Zames := vyucDanew->nDZN_Zames
    else
      vyucDanew->nDZS_Zames := vyucDanew->nDSL_Celk
    endif
    * 25 := 23 -24
    vyucDanew->nDZB_Zames := vyucDanew->nDZN_Zames -vyucDanew->nDZS_Zames
    if( vyucDanew->nDZB_Zames > 0, testDanBo(0), nil )
    * 26 := 20 -24
    vyucDanew->nZDS_Dan := vyucDanew->nDSL_Celk -vyucDanew->nDZS_Zames
    * 27 := 21 -26
    n31a := vyucDanew->nUSZ_Celk -vyucDanew->nZDS_Dan
    vyucDanew->nZDS_Rozd := n31a
    * 29 := 25 -28
    n31b := vyucDanew->nDZB_Zames -vyucDanew->nMDB_Celk
    vyucDanew->nMDB_Rozd := n31b
    * 30 := 27 +29
    nprepNed := vyucDanew->nZDS_Rozd +vyucDanew->nMDB_Rozd
    vyucDanew->cKVR_DanBo := if( nprepNed > 0, 'Doplatek ze zúètování ', ;
                             if( nprepNed < 0, 'Nedolatek ze zúètování', '' ))
    vyucDanew->nKVR_DanBo := nprepNed

    vyucDanew->cPrepNedop := ''
    vyucDanew->nPrepNedop := 0

    n31a := if( n31a > 0, n31a, 0)
    n31b := if( n31b > 0, n31b, 0)
  else
    * 22 := 21 -20
    nprepNed := vyucDanew->nUSZ_Celk -vyucDanew->nDSL_Celk
    vyucDanew->cPrepNedop := if( nprepNed > 0, 'PØEPLATEK', ;
                             if( nprepNed < 0, 'NEDOPLATEK', '' ))
    vyucDanew->nPrepNedop := nprepNed

    n31a := 0
    n31b := 0
  endif

  vyucDanew->nDoplZu31a := n31a
  vyucDanew->nDoplZu31b := n31b
  *
  vyucDanew->( dbcommit())
return .t.


static function testDanBo()
return .t.


*
*
** CLASS for mzd_vyucDane_plat *************************************************
CLASS mzd_vyucDane_plat FROM drgUsrClass
EXPORTED:
  var  dataVal, sumVal

  inline method init(parent)
    local  nEvent,mp1,mp2,oXbp
    local  pa, ctyp := 'UPR', x

    ::headTitle := ''
    ::dataVal   := 0
    ::sumVal    := 0
    pa          := ::pa_items  := { { '', 'vyucDanew->n..._platA' }, { '', 'vyucDanew->n..._platB' }, ;
                                    { '', 'vyucDanew->n..._platC' }, { '', 'vyucDanew->n..._platD' }, ;
                                    { '', 'vyucDanew->n..._platE' }  }

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if IsOBJECT(oXbp:cargo)
      ::drgGet := oXbp:cargo
        ctyp := ::drgGet:groups

        odesc := drgDBMS:getFieldDesc(::drgGet:name)
        ::headTitle := odesc:desc
    endif

    for x := 1 to len(pa) step 1
      pa[x,2] := strTran( pa[x,2], '...', ctyp )

      if isObject( odesc := drgDBMS:getFieldDesc(pa[x,2]) )
        pa[x,1] := odesc:desc
      endif

      ::sumVal += DBGetVal(pa[x,2])
    next

    ::drgUsrClass:init(parent)
  return self

  inline method drgDialogInit(drgDialog)
    local  aPos, aSize
    local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

    XbpDialog:titleBar := .F.

    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

    if IsObject(::drgGet)
      aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
      drgDialog:usrPos := {aPos[1],aPos[2]-25}
    endif
  return

  inline method drgDialogStart(drgDialog)
    ::dm       := drgDialog:dataManager             // dataManager
  return self

  inline method getForm()
    local   oDrg, drgFC := drgFormContainer():new()
    local   pa          := ::pa_items, x
    local   nX := 2, nY := .5

    DRGFORM INTO drgFC SIZE 50,9 DTYPE '10' TITLE ::headTitle +'...' ;
                                            FILE  'vyucDanew'        ;
                                            GUILOOK 'All:N,Border:Y' ;
                                            POST 'postValidate'

    for x := 1 to len(pa) step 1
      DRGTEXT           INTO drgFC CAPTION pa[x,1] CPOS nX    , nY CLEN 30
      DRGGET M->dataVal INTO drgFC                 FPOS nX +32, nY FLEN 10
        odrg:name := pa[x,2]

      nY += 1
    next

    DRGSTATIC INTO drgFC FPOS .2,nY +.2 SIZE 50,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
      DRGTEXT          INTO drgFC CAPTION ::headTitle CPOS  2, .2 CLEN 30 FONT 5
      DRGGET M->sumVal INTO drgFC                     FPOS 34, .1 FLEN 10
      odrg:rOnly        := .t.
      odrg:isedit_inRev := .f.
    DRGEND  INTO drgFC

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Ok'    ;
                             POS 22,nY +2        ;
                             SIZE 13,1.1         ;
                             ATYPE 3             ;
                             ICON1 429           ;
                             ICON2 430           ;
                             EVENT 'save_plat' TIPTEXT 'Ulož nastavené údaje do zpracování ...'

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Storno' ;
                             POS 36,nY +2         ;
                             SIZE 13,1.1          ;
                             ATYPE 3              ;
                             ICON1 102            ;
                             ICON2 202            ;
                             EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'

  return drgFC
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case(nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT)
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    case(nEvent = drgEVENT_APPEND   )
    case(nEvent = drgEVENT_FORMDRAWN)
      return .T.

    case(nEvent = xbeP_Keyboard)
      do case
      case(mp1 = xbeK_ESC)
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .t.

  inline method postValidate(drgVar)
    local  members, x, odrg
    local  o_sumVal

    if drgVar:changed()
      ::sumVal := 0
      o_sumVal := ::dm:has('M->sumVal')
      o_sumVal:set(::sumVal)

      members := ::drgDialog:oForm:aMembers

      for x := 1 to len(members) step 1
        odrg := members[x]
        if( lower( odrg:className()) = 'drgget' .and. odrg:isEdit, ::sumVal += odrg:ovar:value, nil )
      next

      o_sumVal:set(::sumVal)
    endif
  return .t.


  inline method save_plat()

    ::dm:save()

    if isObject(::drgGet)
      ::drgGet:ovar:save()
      ::drgGet:ovar:set(::sumVal)
    endif
    postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return

hidden:
  var  dm, members
  var  drgGet, headTitle, pa_items
ENDCLASS