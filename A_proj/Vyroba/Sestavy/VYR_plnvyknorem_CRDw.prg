#include "Common.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
#include "adsdbe.ch"
#include "dmlb.ch"

*
#include "..\Asystem++\Asystem++.ch"


*
*************** MZD_nem_prilzad ***********************************************
CLASS VYR_plnvyknorem_CRDw FROM drgUsrClass
exported:
  var     task
  var     datumOD, datumDO
  var     lcan_continue

  method  init, drgDialogStart, drgDialogEnd
  method  doSuma
  method  zpracuj_podklady


  inline method postValidate(drgVar)
    if( drgVar:changed(), drgVar:save(), nil )
    return .t.

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE  )
      return .t.

   case( nevent = drgEVENT_OBDOBICHANGED )
     ::datumOD  := mh_FirstODate( uctOBDOBI:VYR:NROK, uctOBDOBI:VYR:NOBDOBI)
     ::datumDO  := mh_LastODate( uctOBDOBI:VYR:NROK, uctOBDOBI:VYR:NOBDOBI)

     ::dm:set('M->datumOD', ::datumOD )
     ::dm:set('M->datumDO', ::datumDO )
     return .t.

    case ( nEvent = drgEVENT_SAVE        )
*      ::lcan_continue := .t.
*      ::zpracuj_podklady()

      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      return .t.
    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, ab, oabro, xbp_therm, cparm, obtn_zpracuj
* datové
  var     culoha, nrok, nobdobi, pa_obdZpr, radek
  var     m_filter
ENDCLASS


method VYR_plnvyknorem_CRDw:init(parent)
  local  task := 'vyr'
  local  file_name, lshared

  ::drgUsrClass:init(parent)
  ::cParm         := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm         := Left( ::cParm,1)
  ::radek         := 0
  ::datumOD       := mh_FirstODate( uctOBDOBI:VYR:NROK, uctOBDOBI:VYR:NOBDOBI)
  ::datumDO       := mh_LastODate( uctOBDOBI:VYR:NROK, uctOBDOBI:VYR:NOBDOBI)
  ::lcan_continue := .f.

  drgDBMS:open('osoby' )

  drgDBMS:open('ListHD',,,,,'listhda')
  drgDBMS:open('ListIT',,,,,'listita')
  drgDBMS:open('DruhyMZD',,,,,'druhymzda')
  drgDBMS:open('c_SazPre',,,,,'c_sazprea')
  *
  lshared := listitW->( DBInfo( DBO_SHARED))
  ::m_filter := listitW->( ads_getAof())
  if( lshared, listitW->( dbcloseArea()), nil )

  drgDBMS:open('listitw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP


  file_name := listitw->( DBInfo(DBO_FILENAME))
               listitw->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'listitw' , .t., .f.) ; listitw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'listitww', .t., .t.) ; listitww->(AdsSetOrder(1))

  if .not. empty(::m_filter)
    listitW->( ads_setAof(::m_filter), dbgoTop() )
  endif
return self


method VYR_plnvyknorem_CRDw:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText, asize_G, asize

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form

  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)
    name    := if( ismemberVar(members[x],'name'    ), isnull(members[x]:name   ,''), '')
    tipText := if( ismemberVar(members[x],'tipText' ), isnull(members[x]:tipText,''), '')

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
       odrg:oxbp:setColorBG( GraMakeRGBColor( {128, 255, 128 } ) )
       asize_G      := odrg:oxbp:currentSize()
    endif

    if odrg:className() = 'drgPushButton'
      if( odrg:event = 'zpracuj_podklady', ::obtn_zpracuj := odrg, nil )
    endif
  next

  * modifikace tlaèítka zpracuj_podklady
  asize          := ::obtn_zpracuj:oxbp:currentSize()
  ::obtn_zpracuj:oxbp:setSize({asize_G[1], asize[2]})
  *
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus
return self


method VYR_plnvyknorem_CRDw:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

  listitww->( dbcloseArea())
return self



method VYR_plnvyknorem_CRDw:zpracuj_podklady()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  nod, ndo
  local  filtrs
  local  cky, ncisRadku := 1, ncisListu := 1
  *
  local  nreccnt, nkeycnt, nkeyno
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2]
  local  celkem    := 0
  local  xx, yy
  *
  Local nAPPENDs := 0, nRemainder, nCount := 0, nLastREC, nUkolTarif, nSazbaPrem
  Local dVyhotML, lContinue := YES, lOK

  ::lcan_continue := .t.
  ::obtn_zpracuj:oxbp:disable()
  ::obtn_zpracuj:oxbp:setFont(drgPP:getFont(5))
  ::obtn_zpracuj:oxbp:setColorFG(GRA_CLR_RED)

  ::obtn_zpracuj:oxbp:setCaption('zpracování podkladù pro plnìní výkonových norem' )

*   vyr_plnvyknorem_inf(::xbp_therm,'zpracování podkladù pro plnìní výkonových norem', nSize, nHight)

  listita->( OrdSetFocus ('LISTI12'))
  listita->( dbSetScope(SCOPE_TOP, DTOS( ::datumOD)))    // 'ListIT', DTOS( dDatOD), DTOS( dDatDO) )
  listita->( dbSetScope(SCOPE_BOTTOM, DTOS( ::datumDO)))
  listita->( dbGoTOP())

   nkeycnt := listitA->( Ads_GetKeyCount(3) )   // ADS_RESPECTSCOPES
   nkeyno  := 1
   nstep   := 0


   do while !listita->( EOF())
     dVyhotML := listita->dVyhotSkut
     if listita->nOsCisPrac > 0
       druhymzda->( dbSEEK( StrZero( listita->nRok,4) +StrZero( listita->nObdobi,2) +StrZero(listita->nDruhMzdy,4),,'DRUHYMZD04'))
       listhda->( dbSEEK( StrZero( listita->nRokVytvor,4) + StrZero( listita->nPorCisLis,12),,'LISTHD1') )
       if lContinue
//         listitw->( dbAPPEND())
//         PutITEM( 'listitw', 'listita' )
         mh_copyFld( 'listita', 'listitw', .t., .t. )
         listitw->dDatOD := ::datumOD
         listitw->dDatDO := ::datumDO
         if druhymzda->lPlanDleSK      //¦ Plnit plán dle skuteènosti
           listitw->nNmNaOpePL := listitw->nNmNaOpeSK
           listitw->nNhNaOpePL := listitw->nNhNaOpeSK
           listitw->nKcNaOpePL := listitw->nKcNaOpeSK
         elseif druhymzda->lNmDleHD    //¦ Plnit normominuty dle hlavièky
           if druhymzda->lVyrobKs
             listitw->nNmNaOpePL := listita->nNmNaOpeSK * ( listhda->nNmNaOpePL / listhda->nNmNaOpeSK ) * ;
                                        ( listhda->nKusyHotov / listhda->nKusyCelk )
           else
             if druhymzda->lHotovNh
               lOK := ( ( listhda->nNhNaOpePL <> 0  .and.( ABS( listhda->nNmNaOpeSK - listhda->nNmNaOpePL) < 0.5 ) )) .or.;
                                                            ( ( listhda->nNmNaOpeSK - listhda->nNmNaOpePL) >= 0.5 )
               if lOK
                 listitw->nNmNaOpePL := listita->nNmNaOpeSK * ( listhda->nNmNaOpePL / listhda->nNmNaOpeSK )
               else
                 listitw->nNmNaOpePL := listitw->nNmNaOpeSK
               endif
             else
               listitw->nNmNaOpePL := listita->nNmNaOpeSK * ( listhda->nNmNaOpePL / listhda->nNmNaOpeSK )
             endif
           endif
           listitw->nNhNaOpePL := listitw->nNmNaOpePL / 60
         endif
         // 15.4.2008
         if Upper( druhymzda->cTypDMZ) $ 'UKOL,PODM'
           nUkolTarif := listitw->nKcNaOpeSk / listitw->nNhNaOpeSk
           c_sazprea->( dbGoTop())
           do while !c_sazprea->( EOF())
             if ( c_sazprea->nUkolTarOd <= nUkolTarif .and. nUkolTarif <= c_sazprea->nUkolTarDo)
               nSazbaPrem := c_sazprea->nSazbaPrem
             endif
             c_sazprea->( dbSkip())
           enddo
           listitw->nSazbaPrem := nSazbaPrem
           if nSazbaPrem <> 0
             listitw->nKcOpePrem := listitw->nKcNaOpeSk / 100 * nSazbaPrem
           endif
         endif

         listitw->( dbCommit())
       endif
     endif

     listita->( dbSKIP())

     nkeyNo++
     vyr_plnvyknorem_pb(::xbp_therm, nkeyCnt, nkeyNo, nsize, nhight)
   enddo

  listita->( dbClearScope())     //ClrSCOPE( 'ListIT')
  listitw->( dbCommit(), dbGoTOP() )

  tmpsumkon(,'VYR')

  // Sumace za pracovníka
  ::obtn_zpracuj:oxbp:setCaption( 'zpracování podkladù sumace za pracovníka' )

*  vyr_plnvyknorem_inf(::xbp_therm,'zpracování podkladù sumace za pracovníka', nSize, nHight)
  nkeycnt := listitw->( Ads_GetKeyCount() )   // ADS_RESPECTSCOPES
  nkeyno  := 1
  nstep   := 0

  listitw->( dbCommit(), dbGoTOP() )
  do while !listitw->( EOF())
    ::doSuma()
    if TMPSUMKOw->( dbSeek(listitw->ncisosoby,,'TSUMKO02'))
      listitw->nOstNahrHo := TMPSUMKOw->nOstNahrHo
      listitw->nNemocenDn := TMPSUMKOw->nNemocenDn
    endif
    listitw->( dbCommit())
    listitw->( dbSKIP())

    nkeyNo++
    vyr_plnvyknorem_pb(::xbp_therm, nkeyCnt, nkeyNo, nsize, nhight)
  enddo

  listitw->( dbCommit(), dbGoTOP() )

  if .not. empty(::m_filter)
    listitW->( ads_setAof(::m_filter), dbgoTop() )
  endif


//  ::obtn_zpracuj:oxbp:setCaption( 'zpracování podkladù z docházky - sumace za pracovníka' )
//  tmpsumkon(,'VYR')

  vyr_plnvyknorem_inf(::xbp_therm,'zpracování podkladù pro plnìní výkonových norem - dokonèeno', nSize, nHight)

//  xx := listitw->cnazpol4
//  listitw->( dbSkip(0))

  _clearEventLoop(.t.)
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.




//¦¦¦< Suma za pracovníka >¦¦¦
method VYR_plnvyknorem_CRDw:doSuma()
  local nOsCisPrac := listitw->nOsCisPrac
  local nNhNaOpePl := 0, nNhNaOpeSk := 0, nKcNaOpeSk := 0
  local lOK
//  local nREC := listitw->( RecNO())

  listitww->( mh_ordSetScope(nOsCisPrac, 'LISTIW01'), dbGotop())
   do while !listitww->( EOF())
     druhymzda->( dbSEEK( StrZero( listitww->nRok,4) +StrZero( listitww->nObdobi,2) +StrZero(listitww->nDruhMzdy,4),,'DRUHYMZD04'))
     if druhymzda->lDMzDoNor       //¦ Zapoèítat druh mzdy do norem
       listhda->( dbSEEK( StrZERO( listitww->nRokVytvor,4) + StrZERO( listitww->nPorCisLis,12),,'LISTHD1') )
       if druhymzda->lHotovKs
         lOK := listhda->nKusyCelk <= listhda->nKusyHotov
       elseif druhymzda->lHotovKc
         lOK := listhda->nNhNaOpePL == 0 .or. ;
                 ( ( listhda->nNhNaOpePL <> 0  .and.( ABS( listhda->nKcNaOpeSK - listhda->nKcNaOpePL) < 1 ) )) .or.;
                      ( ( listhda->nKcNaOpeSK - listhda->nKcNaOpePL) >= 1 )
       elseif druhymzda->lHotovNh
         lOK := ( ( listhda->nNhNaOpePL <> 0  .and.( ABS( listhda->nNmNaOpeSK - listhda->nNmNaOpePL) < 0.5 ) )) .or.;
                                                          ( ( listhda->nNmNaOpeSK - listhda->nNmNaOpePL) >= 0.5 )
       else
         lOK := YES
       endif
       if lOK
         nNhNaOpePl += listitww->nNhNaOpePl
         nNhNaOpeSk += listitww->nNhNaOpeSk
         nKcNaOpeSk += listitww->nKcNaOpeSk
       endif
     endif
     listitww->( dbSkip())
   enddo
  listitww->( dbClearScope())     //ClrSCOPE( 'ListIT')
//  listitw->( dbGoTo( nREC))

  listitw->nPlneniNor := ( nNhNaOpePl / nNhNaOpeSK ) * 100
  listitw->nHodPrumer := ( nKcNaOpeSk / nNhNaOpeSK )

return nil


*
** PROGRESS BAR zpracování *****************************************************
static function vyr_plnvyknorem_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops               , ;
               { 2,2 }           , ;
               { {newPos, nhight}}, ;
               GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  if newPos < (nSize/2) -20
    GraGradient( ops                , ;
                 { newPos+1,2 }, ;
                 { { nsize -newPos, nhight }}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.



function vyr_plnvyknorem_inf(oXbp, ctext, nsize, nhight)
  local  oPS, oFont, aAttr, nwidth

  if .not. empty(oPS := oXbp:lockPS())
    GraGradient( ops               , ;
                 { 2,2 }           , ;
                 { {nsize, nhight}}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)


    oFont := XbpFont():new():create( "9.Arial CE" )
    aAttr := ARRAY( GRA_AS_COUNT )

    nwidth := oFont:width

    GraSetFont( oPS, oFont )

    aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
    GraSetAttrString( oPS, aAttr )
    GraStringAt( oPS, {(nSize/2) -(len(ctext) * nwidth)/2,4}, ctext)
    oXbp:unlockPS(oPS)
  endif
return .t.