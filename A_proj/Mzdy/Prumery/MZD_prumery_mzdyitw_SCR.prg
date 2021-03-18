#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"

#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
*
** CLASS MZD_prumery_SCR *******************************************************
CLASS MZD_prumery_mzdyitw_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  var     stavem

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  method  stableBlock
  method  ebro_saveEditRow

*  method


  * browCOlumn

*  inline method tabSelect( otabPage, tabNum)
*    ::tabNum := tabNum
*    ::stableBlock( ::brow[1]:oxbp )
*  return .t.
  inline access assign method nazevDMZ() var nazevDMZ
    druhymzda->( dbseek( mzdyitw->ndruhmzdy,,'DRUHYMZD01'))
    return druhymzda->cNazevDMz

  inline access assign method nazevDMZd() var nazevDMZd
    druhymzda->( dbseek( mzddavit->ndruhmzdy,,'DRUHYMZD01'))
    return druhymzda->cNazevDMz

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %%", {rokobd})
*       ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')

       * zmìna na < p >- programovém filtru
*       ::quick_setFilter( , 'apuq' )
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  VAR  msg, dm, dc, df, ab
  var  brow, oDBro_msPrc_mo, rok, obdobi, xbp_therm
  var  tabNum

ENDCLASS


*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_prumery_mzdyitw_SCR:Init(parent)
  local  rokObd, cfiltr

  ::drgUsrClass:init(parent)

  ::rok    := uctOBDOBI:MZD:NROK
  ::obdobi := uctOBDOBI:MZD:NOBDOBI
  ::stavem := '1'
  ::tabNum := 1


  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
*  ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')

  drgDBMS:open('mzdyit',,,,,'mzdyita')
  drgDBMS:open('mzdyitpr')
  drgDBMS:open('mzddavit')
  drgDBMS:open('druhymzd',,,,,'druhymzda')
  drgDBMS:open('druhymzd')

  drgDBMS:open('mzdyitw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('mzdyitww',.T.,.T.,drgINI:dir_USERfitm); ZAP

  cfiltr := Format("nOsCisPrac = %% .and. nPorPraVzt = %%" , ;
                    {msprc_mo->noscisprac, msprc_mo->nporpravzt})

  mzdyITpr->( ads_setaof(cfiltr), dbGoTop())


RETURN self


METHOD MZD_prumery_mzdyitw_SCR:drgDialogStart(drgDialog)
 ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )


  ::brow           := drgDialog:dialogCtrl:oBrowse
  ::oDBro_msPrc_mo := ::brow[1]
  ::xbp_therm      := drgDialog:oMessageBar:msgStatus

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

  MzdyItw_PP()

RETURN self


method MZD_prumery_mzdyitw_scr:stableBlock(oxbp)
  local  m_file, ctag, cky

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)
  endif
return self


method MZD_prumery_mzdyitw_scr:ebro_saveEditRow(o_EBro)
  local  cfile := lower( o_EBro:cfile)
  local  ordRec, recNo, nordItem
  * 2
  * mstarindw
  * mssazzamw

  * 3
  * msmzdyhdw
  * msmzdyitw

  if mzdyitpr->nosCisPrac = 0
    mzdyitpr->ctask    := 'MZD'
    mzdyitpr->culoha   := 'M'
    mzdyitpr->cdenik   := 'MH'

    mzdyitpr->cobdobi  :=  StrZero( mzdyitpr->nobdobi,2)+ '/' + SubStr(Str( mzdyitpr->nrok,4),2)
    mzdyitpr->nrokobd  :=  ( mzdyitpr->nrok * 100) + mzdyitpr->nobdobi

    mzdyitpr->nosCisPrac := msprc_mo->nosCisPrac
    mzdyitpr->nporpravzt := msprc_mo->nporpravzt
    mzdyitpr->cjmenorozl := msprc_mo->cjmenorozl

    mzdyitpr->croobcpppv := Str( mzdyitpr->nrok,4) + StrZero( mzdyitpr->nobdobi,2) +   ;
                             StrZero(msprc_mo->nosCisPrac,5) +StrZero(msprc_mo->nporpravzt,3)
    mzdyitpr->crocpppv   := Str( mzdyitpr->nrok,4) +               ;
                             StrZero(msprc_mo->nosCisPrac,5) +StrZero(msprc_mo->nporpravzt,3)

    mzdyitpr->ccpppv     := StrZero(msprc_mo->nosCisPrac,5) +StrZero(msprc_mo->nporpravzt,3)
  endif

/*
  if o_EBro:state = 2 .or. (cfile)->nosCisPrac = 0
    if( (cfile)->(fieldPos('stask' )) <> 0, (cfile)->ctask  := msprc_mow->ctask , nil )
    if( (cfile)->(fieldPos('culoha')) <> 0, (cfile)->culoha := msprc_mow->culoha, nil )

    (cfile)->nosCisPrac := msprc_mow->nosCisPrac
    (cfile)->nporPraVzt := msprc_mow->nporPraVzt

    do case
    case cfile = 'msmzdyhdw'
      msMzdyhdW->ctask    := msPrc_moW->ctask
      msMzdyhdW->culoha   := msPrc_moW->culoha
      msMzdyhdW->cdenik   := 'MH'
      msMzdyhdW->nkeyMatr := msMzdyhdW->sID

      msMzdyitW->( dbsetScope( SCOPE_BOTH, strZero( msMzdyhdW->nkeyMatr,4)), dbgoTop())

    case cfile = 'msmzdyitw'
      msMzdyitW->ctask    := msMzdyhdW->ctask
      msMzdyitW->culoha   := msMzdyhdW->culoha
      msMzdyitW->cdenik   := msMzdyhdW->cdenik
      msMzdyitW->nkeyMatr := msMzdyhdW->nkeyMatr
      msMzdyitW->( dbCommit())

      nordItem := max( o_eBro:odata:nordItem, 10)

      do case
      case o_eBro:isAppend

        if o_eBro:isAddData .or. msMzdyitW->(eof())
          msMzdyitW->nordItem := nordItem +10

        else
          msMzdyitW->nordItem := nordItem

           recNo := msMzdyitW->(recNo())
          ordRec := fordRec({ 'msMzdyitW' })

          msMzdyitW ->(AdsSetOrder(0),dbgoTop())

          do while .not. msMzdyitW->(eof())
            if msMzdyitW->nordItem >= nordItem  .and. msMzdyitW->(recNo()) <> recNo
              msMzdyitW->nordItem += 10
            endif

            msMzdyitW->(dbskip())
          enddo
          fordRec()
        endif
      endcase
    endcase
  endif
*/


return .t.




METHOD MZD_prumery_mzdyitw_SCR:destroy()
 ::drgUsrClass:destroy()

RETURN SELF


function MzdyItw_PP(obdobi)
  local rozsahobd
  local a
  local nod, ndo, nrok


  nrok := Val( Left(  MZD_ObdPrumPP()[1], 4))
  nod  := Val( Right( MZD_ObdPrumPP()[1], 2))
  ndo  := Val( Right( MZD_ObdPrumPP()[2], 2))

  filtr := Format("nrok = %% .and. nobdobi >= %% .and. nobdobi <= %% .and. nOsCisPrac = %% .and. nPorPraVzt = %%  " , ;
                    {nrok, nod, ndo, msprc_mo->noscisprac, msprc_mo->nporpravzt})

  mzdyITa->( ads_setaof(filtr), dbGoTop())

//  mzdyIT->( AdsSetOrder('MZDYIT08')        , ;
//              dbSetScope(SCOPE_BOTH   , xkey), ;
//              dbgoTop()                        )

    do while .not. mzdyITa ->( Eof())
      druhyMzd->( dbseek( strZero( mzdyITa->nRokObd,6) +strZero( mzdyITa->ndruhMzdy,4),, 'DRUHYMZD04'))

      if ( DruhyMZD->nPrNapPpDn+DruhyMZD->nPrNapPpHo+DruhyMZD->nPrNapPpMz  ;
            +DruhyMZD->nPrNapNaDn+DruhyMZD->nPrNapNaHo+DruhyMZD->nPrNapNaMz  ;
              +DruhyMZD->nPrNapRoMz+DruhyMZD->P_KcsPOHSL ) <> 0
        mh_copyFLD( 'mzdyita', 'mzdyitw',.t.)

/*
           lOdp_POL  := IF( DruhyMZD ->P_KcsPOHSL = 1, .T., .F.)

           (out_file) ->nHFondu_OO -= IF( lOdp_POL, mzdyIT ->nHodDoklad, 0)
           anSUMo[1,1] -= IF( lOdp_POL .AND. aAlgDNU[1] = 4, mzdyIT ->nDnyDoklad, 0)
           anSUMo[2,1] -= IF( lOdp_POL .AND. ( aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3), mzdyIT ->nHodDoklad, 0)

           (out_File) ->nDOdpra_PP += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           (out_File) ->nDnyNap_PP += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           (out_File) ->nHOdpra_PP += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapPpHo
           (out_File) ->nHodNap_PP += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapPpHo
           (out_File) ->nKcsPRACP  += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz
           (out_File) ->nMzdNap_PP += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz
           anSUMo[1,1]          += IF(aAlgDNU[1] <> 4, mzdyIT->nDnyDoklad*DruhyMZD->nPrNapPpDn, 0)
           anSUMo[2,1]          += IF( aAlgHOD[1] = 1, mzdyIT->nHodDoklad*DruhyMZD->nPrNapPpHo, 0)
           anSUMo[3,1]          += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz

           (out_File) ->nDnyNap_NA += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapNaDn
           (out_File) ->nHodNap_NA += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapNaHo
           (out_File) ->nMzdNap_NA += mzdyIT ->nMzda      * DruhyMZD->nPrNapNaMz
           anSUMo[1,2]          += IF(aAlgDNU[1] <> 4, mzdyIT ->nDnyDoklad*DruhyMZD->nPrNapNaDn, 0)
           anSUMo[2,2]          += IF( aAlgHOD[1] = 1, mzdyIT ->nHodDoklad*DruhyMZD->nPrNapNaHo, 0)
           anSUMo[3,2]          += mzdyIT ->nMzda      * DruhyMZD->nPrNapNaMz

           (out_File) ->nKcsODMEN  += ( mzdyIT ->nMzda*DruhyMZD->nPrNapRoMz / 12 ) * MsVPrum ->nPocMesPr
           (out_File) ->nHOD_presc += mzdyIT ->nHodPresc
           (out_File) ->nHOD_presc += mzdyIT ->nHodPrescS
         ENDIF

         IF mzdyIT ->nDruhMzdy = 960
           (out_File) ->nDanUleva += mzdyIT ->nMzda
         ENDIF
*/      endif

        mzdyITa ->( dbSkip())
      enddo

  mzdyITw->( dbGoTop())
//      mzdyIT ->( ClearAOF())


return nil


function MzdyItw_NM(obdobi)
  local rozsahobd
  local a
  local nod, ndo, nrokod, nrokdo


  nrokod := Val( Left(  MZD_ObdPrumNM()[1], 4))
  nod    := Val( Right( MZD_ObdPrumPP()[1], 2))
  nrokdo := Val( Left(  MZD_ObdPrumNM()[2], 4))
  ndo    := Val( Right( MZD_ObdPrumPP()[2], 2))

  filtr := Format("( nrok >= %% .and. nobdobi >= %% ) .and.( nrok <= %% .and. nobdobi <= %%) .and. nOsCisPrac = %% .and. nPorPraVzt = %%  " , ;
                    {nrokod, nod, nrokdo,ndo, msprc_mo->noscisprac, msprc_mo->nporpravzt})

  mzdyITa->( ads_setaof(filtr), dbGoTop())

//  mzdyIT->( AdsSetOrder('MZDYIT08')        , ;
//              dbSetScope(SCOPE_BOTH   , xkey), ;
//              dbgoTop()                        )

    do while .not. mzdyITa ->( Eof())
      druhyMzd->( dbseek( strZero( mzdyITa->nRokObd,6) +strZero( mzdyITa->ndruhMzdy,4),, 'DRUHYMZD04'))

      if ( DruhyMZD ->P_KcsNEMOC +DruhyMZD ->P_KcsHOPRP ) <> 0
        mh_copyFLD( 'mzdyita', 'mzdyitw',.t.)

/*
           lOdp_POL  := IF( DruhyMZD ->P_KcsPOHSL = 1, .T., .F.)

           (out_file) ->nHFondu_OO -= IF( lOdp_POL, mzdyIT ->nHodDoklad, 0)
           anSUMo[1,1] -= IF( lOdp_POL .AND. aAlgDNU[1] = 4, mzdyIT ->nDnyDoklad, 0)
           anSUMo[2,1] -= IF( lOdp_POL .AND. ( aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3), mzdyIT ->nHodDoklad, 0)

           (out_File) ->nDOdpra_PP += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           (out_File) ->nDnyNap_PP += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           (out_File) ->nHOdpra_PP += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapPpHo
           (out_File) ->nHodNap_PP += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapPpHo
           (out_File) ->nKcsPRACP  += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz
           (out_File) ->nMzdNap_PP += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz
           anSUMo[1,1]          += IF(aAlgDNU[1] <> 4, mzdyIT->nDnyDoklad*DruhyMZD->nPrNapPpDn, 0)
           anSUMo[2,1]          += IF( aAlgHOD[1] = 1, mzdyIT->nHodDoklad*DruhyMZD->nPrNapPpHo, 0)
           anSUMo[3,1]          += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz

           (out_File) ->nDnyNap_NA += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapNaDn
           (out_File) ->nHodNap_NA += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapNaHo
           (out_File) ->nMzdNap_NA += mzdyIT ->nMzda      * DruhyMZD->nPrNapNaMz
           anSUMo[1,2]          += IF(aAlgDNU[1] <> 4, mzdyIT ->nDnyDoklad*DruhyMZD->nPrNapNaDn, 0)
           anSUMo[2,2]          += IF( aAlgHOD[1] = 1, mzdyIT ->nHodDoklad*DruhyMZD->nPrNapNaHo, 0)
           anSUMo[3,2]          += mzdyIT ->nMzda      * DruhyMZD->nPrNapNaMz

           (out_File) ->nKcsODMEN  += ( mzdyIT ->nMzda*DruhyMZD->nPrNapRoMz / 12 ) * MsVPrum ->nPocMesPr
           (out_File) ->nHOD_presc += mzdyIT ->nHodPresc
           (out_File) ->nHOD_presc += mzdyIT ->nHodPrescS
         ENDIF

         IF mzdyIT ->nDruhMzdy = 960
           (out_File) ->nDanUleva += mzdyIT ->nMzda
         ENDIF
*/      endif

        mzdyITa ->( dbSkip())
      enddo

  mzdyITw->( dbGoTop())
//      mzdyIT ->( ClearAOF())


return nil