#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#pragma Library( "XppUI2.LIB" )

***  Import mzdových lístkù
***  typy zpùsobù volání importu mzdových lístkù
***        1   -  volání z èásti pøes všechny doklady naèítá se pùvodním zpùsobem
***               pøes vybraná støediska
***        2   -  volání z kmenu èást doklady ke konkrétnímu pracovníku - ruší se
***               a naèítá jen konkrétní pracovník
***        3   -  volání z èásti pracovníci - doklady - ruší se a naèítá za vybraného
***               pracovníka
***        4   -  volání z èásti pracovníci - doklady - ruší se a naèítá za vybrané
***               pracovníky


# DEFINE    DoMEZD       1      // export do modulu MZDY ... A_SYSTEM++
*
# DEFINE    aMESICE     { 'Leden'    ,'Únor'     , 'Bøezen'   ,;
                          'Duben'    ,'Kvìten'   , 'Èerven'   ,;
                          'Èervenec' ,'Srpen'    , 'Záøí'     ,;
                          'Øíjen'    ,'Listopad' , 'Prosinec'  }

********************************************************************************
* VYR_exportML ... Export mzdových lístkù
********************************************************************************
CLASS MZD_ImportDokl_ML FROM drgUsrClass

EXPORTED:
  VAR     nExportML, cImportML, cExpObd, cExpStr, aExport, Info_import
  VAR     nStredVML, cUloha
  VAR     acStred, alStred
  var     cImpObd, acPrac
  var     nImpRok, nImpObd
  var     lnewRec
  *
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, EventHandled, getForm
  METHOD  postValidate, CheckItemSelected
  METHOD  importML_DEL
  METHOD  importML_START
  METHOD  Vyr_UcetSYS_sel, Vyr_Stred_sel

  ACCESS ASSIGN METHOD INFO_import  // VAR INFO_export

   * info only for me
  inline method zaklSocPo_sum()
    local cmain_Ky := strZero(mzdDavHDw->nrok,4) +strZero(mzdDavHDw->nobdobi,2) + ;
                      strZero(mzdDavHDw->nosCisPrac,5) +strZero(mzdDavHDw->nporPraVzt,3)
    local  it_nzaklSocPo := mzdDavHD_s->nzaklSocPo

    mzdDavHd_s->( ordSetFocus('MZDDAVHD01')      , ;
                  dbsetScope(SCOPE_BOTH,cmain_Ky), ;
                  dbeval( { || it_nzaklSocPo += mzdDavHD_s->nzaklSocPo } ), ;
                  dbclearScope()                                            )
    return it_nzaklSocPo

  inline method zaklZdrPo_sum()
    local cmain_Ky := strZero(mzdDavHDw->nrok,4) +strZero(mzdDavHDw->nobdobi,2) + ;
                      strZero(mzdDavHDw->nosCisPrac,5) +strZero(mzdDavHDw->nporPraVzt,3)
    local  it_nzaklZdrPo := mzdDavHD_s->nzaklZdrPo

    mzdDavHd_s->( ordSetFocus('MZDDAVHD01')      , ;
                  dbsetScope(SCOPE_BOTH,cmain_Ky), ;
                  dbeval( { || it_nzaklZdrPo += mzdDavHD_s->nzaklZdrPo } ), ;
                  dbclearScope()                                            )
    return it_nzaklZdrPo


HIDDEN
  var     dm, dc
  var     typCall, nrec_msPrc_mo
  var     newDoklad

  method  VisibleActions
  method  SumMDAVx, AppendItms, CondIsOK, IsZavren

ENDCLASS

********************************************************************************
METHOD MZD_ImportDokl_ML:init(parent)
  Local cHlp     := AllTrim( SysCONFIG( 'Vyroba:cStrExpML'))
  Local aNazPol1 := ListAsARRAY( cHLP)
  local arr
  *
  ::typCall :=  Val( ListAsARRAY( parent:initParam)[2])
  *
  ::nExportML  := SysConfig( 'Vyroba:nExportML')
  ::nStredVML  := SysConfig( 'Vyroba:nStredVML')
  *
  drgDBMS:open('LISTIT'   )
  drgDBMS:open('Osoby'    )

  drgDBMS:open('VYRZAK'   )
  drgDBMS:open('C_PRIPL'  )
  drgDBMS:open('cNazPOL1' )
  drgDBMS:open('UCETSYS'  )
  drgDBMS:open('mzddavhd',,,,,'mzddavhda')
  drgDBMS:open('mzddavit',,,,,'mzddavita')

  * pro sumaci
  drgDBMS:open('mzdDavhd',,,,,'mzdDavHd_s')

  drgDBMS:open('DruhyMZD',,,,,'druhymzda')
  drgDBMS:open('C_STRED'  )
  drgDBMS:open('C_EXPML'  )
  *

  drgDBMS:open('MsPrc_MO' )
  if ::typCall = 2
    msprc_mo->( dbSeek( ListAsARRAY( parent:initParam)[3],,'MSPRMO17' ))
    ::nrec_msPrc_mo := msPrc_mo->(recNo())
  endif

  drgDBMS:open('MsPrc_MO',,,,,'msprc_moa' )

  *
  ::acPrac     := {}
  ::aExport    := { 'do mezd ', 'do úèta '}
  ::cImportML  := 'IMPORT ' + ::aExport[ ::nExportML]
  ::cExpObd    := StrZERO(uctOBDOBI:MZD:NOBDOBI,2) + '/' + STR( uctOBDOBI:MZD:NROK, 4)
  ::cImpObd    := StrZERO(uctOBDOBI:MZD:NOBDOBI,2) + '/' + STR( uctOBDOBI:MZD:NROK, 4)
  ::nImpRok    := uctOBDOBI:MZD:NROK
  ::nImpObd    := uctOBDOBI:MZD:NOBDOBI
  ::cUloha     := 'V'   // IF( ::nExportML = DoMEZD, 'M', 'U')

  * zjištìní posledního èísla dokladu
    arr := sysConfig('Mzdy:nRangeMZ_V')

    cfiltr := Format("ndoklad >= %% .and. nDOKLAD <= %%", {arr[1], arr[2]})
    mzddavhda->(ads_setaof(cfiltr),OrdSetFocus('MZDDAVHD11'), DbGoBottom())
    ::newDoklad := if( mzddavhda->ndoklad = 0, arr[1]-1, mzddavhda->ndoklad)
    mzddavhda->(ads_clearaof())

RETURN self

********************************************************************************
METHOD MZD_ImportDokl_ML:destroy()
  ::drgUsrClass:destroy()

  ::nExportML   := ::nStredVML := ;
  ::aExport     := ::cImportML := ::cExpObd  := ::cExpStr := ;
  ::Info_import := ::cUloha    := NIL

  if ::typCall = 2
    msPrc_mo->( dbgoTo( ::nrec_msPrc_mo))
  endif

RETURN self

********************************************************************************
METHOD MZD_ImportDokl_ML:drgDialogInit(drgDialog)

  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
  drgDialog:Title := ::aExport[ ::nExportML]

  ::lnewRec := .t.
RETURN self

********************************************************************************
METHOD MZD_ImportDokl_ML:drgDialogStart(drgDialog)
  local  members, x
*  LOCAL  members  := ::drgDialog:oActionBar:Members, x
  *
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager

  *
  do case
  case ::typCall = 1
    members  := drgDialog:oActionBar:Members
    ::Info_import := ''
    ::VisibleActions(drgDialog)
    ::Info_import := '.....IMPORT MZDOVÝCH LÍSTKU ZA STØEDISKA .....'

  case ::typCall = 2 .or. ::typCall = 3
    ::Info_import := ' .... ' + AllTrim(MsPrc_mo->cjmenorozl ) + ' .... '

  case ::typCall = 4
    ::Info_import := '.....IMPORT MZDOVÝCH LÍSTKU ZA VYBRANÉ PRACOVNÍKY.....'

  endcase
  *
RETURN self

********************************************************************************
METHOD MZD_ImportDokl_ML:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  CASE nEvent = drgEVENT_SAVE
  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD MZD_ImportDokl_ML:postValidate( oVar)
  LOCAL xVar  := oVar:get(), cName := UPPER(oVar:name), cKEY
  Local lOK := .T.

  DO CASE
    CASE cName = 'M->cExpObd'
      lOK := ::Vyr_UcetSys_sel()
  ENDCASE
RETURN lOK

********************************************************************************
METHOD MZD_ImportDokl_ML:CheckItemSelected( CheckBox)
  Local name := drgParseSecond( CheckBox:oVar:Name,'>')
  Local nPos := VAL( SUBSTR( name, AT( '[', Name) +1, 2 ))

*  self:&Name := CheckBox:Value
  self:alStred[ nPos] := IF( CheckBox:Value = "T", .T., .F. )
RETURN self


*
********************************************************************************
METHOD MZD_ImportDokl_ML:importML_Start(parent)
  Local nAREA := SELECT(), n
  Local cKey, cKeyOLD, cKeyNEW, cObdPREN
  Local nRYO, nCount := 0, nRecCount, nRemainder
  Local nHrubaMzda := 0, nHodiny   := 0, nMnozPrace := 0
  Local nHodFondPD := 0, nHodPresc := 0, nHodPripl := 0
  Local nDoklad, nOrdItem
  Local lNewREC, lOK, lExp, lSEEK
  Local dPrenos := DATE(), cPrenos := SysCONFIG( 'System:cUserAbb')
  Local aREC := {}, bREC := {}
  Local cMsg := 'Požadujete spustit import mzdových lístkùt za obobí [ & ] ?'
  local arSel
  local recMS

  do case
  case ::typCall = 1
    for n := 1 to  len(::acStred)
      if ::alStred[ n]
        ::cExpStr := ::acStred[ n]
         cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. cKMENSTRPR = '%%'"  ;
                           , {::nImpRok, ::nImpObd, ::cExpStr})
         msprc_moa->(ads_setaof(cfiltr), dbGoTop())
         do while .not. msprc_moa->(Eof())
           if msprc_moa->lexport
             AAdd(::acPrac,msprc_moa->(recNo()))
           endif
           msprc_moa->( dbSkip())
         enddo
      endif
    next
    msprc_moa->(ads_clearaof())

  case ::typCall = 2
    ::acPrac := {msprc_mo->(recNo())}

  case ::typCall >= 3
    if  parent:parent:odbrowse[1]:is_selAllRec
      recMS := msprc_mo->( RecNo())
      msprc_mo->( dbGoTop())
      do while .not. msprc_mo->(Eof())
        if msprc_mo->lexport
          AAdd(::acPrac,msprc_mo->(recNo()))
        endif
        msprc_mo->( dbSkip())
      enddo
      msprc_mo->( dbGoTo(recMS))

    else
      ::acPrac := if(len(parent:parent:odbrowse[1]:arSelect) =0, {msprc_mo->(recNo())}, parent:parent:odbrowse[1]:arSelect)
    endif
  endcase

  drgDBMS:open('mzddavhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP       // pùvodnì m_davs
  drgDBMS:open('mzddavitw',.T.,.T.,drgINI:dir_USERfitm); ZAP       // pùvodnì m_davs
  drgDBMS:open('mzddavitx',.T.,.T.,drgINI:dir_USERfitm); ZAP
  mzddavitx->( AdsSetOrder( 'mzddavitx01'))

  for n := 1 TO LEN( ::acPrac)
    BEGIN SEQUENCE

      mzdDavhdw->( dbZap())
      mzdDavitw->( dbZap())
      mzdDavitx->( dbZap())
        mzddavitx->( AdsSetOrder( 'mzddavitx01'))

      msprc_moa->( dbGoTo( ::acPrac[n]))

      ::Info_import := drgNLS:msg('IMPORTUJI ....' +AllTrim(msprc_moa->cJmenorozl) +'....')

      cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. nOSCISPRAC = %% .and. nPORPRAVZT = %% .and. nAUTOGEN = 5"  ;
                       , {msprc_moa->nROK, msprc_moa->nOBDOBI, msprc_moa->nOSCISPRAC, msprc_moa->nPORPRAVZT})

      * zrušíme minulý pøenos
      mzddavhda->(ads_setaof(cfiltr), dbGoTop())
       do while .not. mzddavhda->( EOF())
          if mzddavhda->( dbRLock())
            mzddavhda->( dbDelete(), dbUnlock())
          endif
          mzddavhda->( dbSkip())
        enddo
       mzddavhda->( ads_clearaof())

       mzddavita->(ads_setaof(cfiltr), dbGoTop())
        do while .not. mzddavita->( EOF())
          if mzddavita->( dbRLock())
            mzddavita->( dbDelete(), dbUnlock())
          endif
          mzddavita->( dbSkip())
        enddo
       mzddavita->( ads_clearaof())
       *
       *
       C_Pripl->( AdsSetOrder( 1))

       cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. nOSCISPRAC = %% .and. nPORPRAVZT = %%"  ;
                       , {msprc_moa->nROK, msprc_moa->nOBDOBI, msprc_moa->nOSCISPRAC, msprc_moa->nPORPRAVZT})
       listit->(ads_setaof(cfiltr), dbGoTop())

        nRecCount := listit->( Ads_GetRecordCount())

        if nRecCount == 0
*          ::Info_import := drgNLS:msg('Nenalezena žádná data k importu ...')
          BREAK
        endif

        if .not. listit->(eof())
          mh_CopyFLD( 'msprc_moa', 'mzddavhdw', .T. )

          ::newDoklad++

          mzddavhdw->ndoklad    := ::newDoklad
          mzddavhdw->cdenik     := 'MH'
          mzddavhdw->ctypdoklad := 'MZD_PRIJEM'
          mzddavhdw->ctyppohybu := 'HRUBMZDA'
          mzddavhdw->ddatporiz  := date()
          mzddavhdw->nAutoGen   := 5
        endif

        do while !ListIT->( EOF())
          if .not. ListIT-> lNoExpMzd
            Osoby->( dbSEEK( ListIT->nCisOsoby,, 'OSOBY01'))
            VyrZAK->( dbSEEK( Upper( ListIT->cCisZakaz),, 'VYRZAK1'))
            if msprc_moa->lExport
              if ListIT->nOsCisPrac > 0     // Základní mzda
                lExp := YES
                mh_CopyFLD( 'ListIT', 'mzddavitx', .T. )
                ::AppendITMs()
                mzddavitx->nDruhMzdy  := ListIT->nDruhMzdy
                mzddavitx->cUcetSkup  := AllTrim( Str( mzddavitx->nDruhMzdy))

                mzddavitx->nHrubaMzd  := ListIT->nKcNaOpeSk
                mzddavitx->nHodDoklad := ListIT->nNhNaOpeSK
                if DruhyMzd->( dbSEEK( StrZero(ListIT->nRok,4) +StrZero(ListIT->nObdobi,2) +StrZero(ListIT->nDruhMzdy,4),, 'DRUHYMZD04'))
                  if Upper( DruhyMzd->cTypDMZ) $ 'UKOL,CASO,REZI'
                    mzddavitx->nHodFondPD := ListIT->nNhNaOpeSK
                  endif
                endif
              endif

              if ListIT->nKcOpePrem > 0           // PRÉMIE KE MZDÌ
                mh_CopyFLD( 'ListIT', 'mzddavitx', .T. )
                ::AppendITMs()
                if DruhyMzd->( dbSEEK( StrZero(ListIT->nRok,4) +StrZero(ListIT->nObdobi,2) +StrZero(ListIT->nDruhMzdy,4),, 'DRUHYMZD04'))
                  mzddavitx->nDruhMzdy := DruhyMzd->nDruhMzPre
                  mzddavitx->cUcetSkup := AllTrim( Str( mzddavitx->nDruhMzdy))
                endif
                mzddavitx->nHrubaMzd  := ListIT->nKcOpePrem
                mzddavitx->nHodDoklad := ListIT->nNhNaOpeSK
                mzddavitx->nHodPresc  := ListIT->nNhNaOpeSK
              endif

              if ListIT->nKcOpePrip > 0           // PØÍPLATEK KE MZDÌ
                lExp := YES
                mh_CopyFLD( 'ListIT', 'mzddavitx', .T. )
                ::AppendITMs()
                cKey := ListIT->cKodPripl
                C_Pripl->( dbSEEK( Upper( cKey),, 'C_PRIPL1'))
                mzddavitx->nDruhMzdy  := C_Pripl->nDruhMzdy
                mzddavitx->cUcetSkup  := AllTrim( Str( mzddavitx->nDruhMzdy))
                mzddavitx->nHrubaMzd  := ListIT->nKcOpePrip
                mzddavitx->nHodPripl  := ListIT->nNhNaOpeSK
              endif

              if lExp
                if LEN( aREC) <= 4095
                  AADD( aREC, ListIT->( RecNO()) )
                else
                  AADD( bREC, aREC )
                  aREC := {}
                  AADD( aREC, ListIT->( RecNO()) )
                endif
              endif
            endif
          endif
          ( ListIT->( dbSKIP()), nCount++ )
          nRemainder := nCount % 100
          if( nRemainder == 0, mzddavitx->( dbCOMMIT()), NIL )
        enddo

        mzddavitx->( dbCOMMIT(), dbgoTop())
        ListIT->( ads_clearaof())

        ** Sumarizace mzddavitx do mzddavitw
        mzddavitx->( AdsSetOrder( 'mzddavitx02'), dbGoTOP() )
        ::SumMDAVx()

        ** Aktualizace M_DAV souborem M_DAVs
*        ::INFO_import := drgNLS:msg('3. Import ( aktualizace) hrubých mezd ... ')
        ( nCount := 0, nRecCount := mzddavitw->( RecCOUNT()) )
        lExp := NO

        mzd_mzddavhd_cmp(.t.)
        msPrc_mo->( dbseek( isNull( msPrc_moa->sID, 0),,'ID'))
        mzd_mzddavhd_wrt_inTrans(self)

        if Len( bREC) > 0
          AEVAL( bREC, { |Y|;
                 AEVAL( Y, {|X| ListIT->( dbGoTO( X)) ,;
                              IF( ReplREC( 'ListIT'),;
                                  ( ListIT->dPrenos := dPrenos,;
                                  ListIT->cPrenos := cPrenos,;
                                    ListIT->( dbUnlock()))       , NIL) }) })
        else
          AEVAL( aREC, {|X| ListIT->( dbGoTO( X)) ,;
                              IF( ReplREC( 'ListIT'),;
                                  ( ListIT->dPrenos := dPrenos,;
                                    ListIT->cPrenos := cPrenos,;
                                    ListIT->( dbUnlock()))      , NIL) })
        endif

        ** Nastavení indikace uzavøení pøenosu
        **  nCountPRMs := UzavriPREN()
*        ::IsZavren( .T.)

      ENDSEQUENCE
  next

  ::INFO_import := drgNLS:msg('... IMPORT MZDOVÝCH LÍSTKU UKONÈEN ... ')
  dbSelectAREA( nAREA)
*/


RETURN NIL


* Zrušení exportu mzdových lístkù
********************************************************************************
METHOD MZD_ImportDokl_ML:importML_Del(drgDialog)
  Local cKEY := Upper( 'V') + RIGHT( ::cExpOBD, 4) + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0')
  Local cMsg := 'Požadujete zrušit export mzdových lístkù za obobí [ & ] ?'
  Local oMoment, cKeyUcto

  IF drgIsYesNo(drgNLS:msg( cMsg, ::cExpObd))
     oMoment := SYS_MOMENT( 'Probíhá rušení importu mzdových lístkù')
    *
    IF     ::nExportML = DoMEZD
      * ???
    ENDIF
    *
    IF UcetSYS->( dbSEEK( cKey,, 'UCETSYS3'))
      IF UcetSYS->( dbRLock())
        UcetSYS->lZavren := .F.
        UcetSYS->( dbUnlock())
        ::VisibleActions(drgDialog)
        ::Info_import := drgNLS:msg( '... IMPORT MZDOVÝCH LÍSTKU ZRUŠEN ...')
      ENDIF
    ENDIF

    oMoment:destroy()
  ENDIF
RETURN NIL

*
********************************************************************************
METHOD MZD_ImportDokl_ML:SumMDAVx()
  Local cKeyOLD, cKeyNEW
  Local nCount := 0, nRecCount, nRemainder
  Local nHrubaMzda := 0, nHodiny   := 0, nMnozPrace := 0
  Local nHodFondPD := 0, nHodPresc := 0, nHodPripl := 0
  Local nHodFoPDDo := 0
  Local nDoklad, nOrdItem
  Local ok_praVzt
  Local nDenFond

  ok_praVzt  := ( msPrc_moa->ntypPraVzt <> 5 .and. msPrc_moa->nTypPraVzt <> 9 )

  cKeyOLD   := mzddavitx->( Sx_KeyDATA())
  nDoklad   := mzddavitx->nDoklad
  nOrdItem  := 0
  nCount    := 0
  nRecCount := mzddavitx->( RecCOUNT())

  do while .not.mzddavitx->( EOF())

    cKeyNEW := mzddavitx->( Sx_KeyDATA())
    if cKeyOLD == cKeyNEW
      nHrubaMzda += mzddavitx->nHrubaMzd     //  M_DAVx->Hruba_Mzda
      nHodiny    += mzddavitx->nHodDoklad    //  M_DAVx->Hodiny
      nMnozPrace += mzddavitx->nMnPDoklad    //  M_DAVx->Mnoz_Prace
      nHodFondPD += mzddavitx->nHodFondPD
      nHodPresc  += mzddavitx->nHodPresc
      nHodPripl  += mzddavitx->nHodPripl
    else
      mzddavitx->( dbSKIP( -1))
      mh_CopyFLD( 'mzddavitx', 'mzddavitw', .T.)
      mzddavitw->croobcpppv := strzero(mzddavitw->nrok,4)+strzero(mzddavitw->nobdobi,2) ;
                                + strzero(mzddavitw->noscisprac,5)+strzero(mzddavitw->nporpravzt,3)
      mzddavitw->crocpppv   := strzero(mzddavitw->nrok,4) ;
                                + strzero(mzddavitw->noscisprac,5)+strzero(mzddavitw->nporpravzt,3)
      DruhyMzd->( dbSEEK( StrZero(mzddavitw->nRok,4) +StrZero(mzddavitw->nObdobi,2) +StrZero(mzddavitw->nDruhMzdy,4),, 'DRUHYMZD04'))
      mzddavitw->nHrubaMzd  := mh_RoundNUMB( nHrubaMzda, DruhyMzd->nKodZaokr )
      mzddavitw->nHodDoklad := nHodiny
      mzddavitw->nMnPDoklad := nMnozPrace
      mzddavitw->nSazbaDokl := nHrubaMzda / nHodiny
      mzddavitw->nHodFondPD := nHodFondPD
      mzddavitw->nHodFondKD := nHodFondPD
      mzddavitw->nHodPresc  := nHodPresc
      mzddavitw->nHodPripl  := nHodPripl

      nHodFoPDDo += nHodFondPD

      if nDoklad == mzddavitx->nDoklad
        nOrdItem++
        mzddavitw->nOrdItem := nOrdItem * 10
      else
        nOrdItem := 1
        mzddavitw->nOrdItem := nOrdItem * 10
      endif

      mzddavitw->nMzda      := mzddavitw->nHrubaMzd
      mzdDavItw->nzaklSocPo := 0
      mzdDavItw->nzaklZdrPo := 0

      if msPrc_moa->lsocPojis .and. druhyMzd->lsocPojis .and. ok_praVzt
        mzdDavItw->nzaklSocPo := mzdDavItw->nHrubaMZD
      endif

      if msPrc_moa->nzdrPojis <> 0 .and. druhyMzd->lzdrPojis .and. ok_praVzt
        mzdDavItw->nzaklZdrPo := mzdDavItw->nHrubaMZD
      endif

      nDoklad := mzddavitx->nDoklad
      mzddavitx->( dbSkip())
      cKeyOLD := cKeyNEW
      nHrubaMzda := mzddavitx->nHrubaMzd   // Hruba_Mzda
      nHodiny    := mzddavitx->nHodDoklad  // Hodiny
      nMnozPrace := mzddavitx->nMnPDoklad  // Mnoz_Prace
      nHodFondPD := mzddavitx->nHodFondPD
      nHodPresc  := mzddavitx->nHodPresc
      nHodPripl  := mzddavitx->nHodPripl

    endif
    mzddavitx->( dbSKIP())
    nCount++
    nRemainder := nCount % 100
    if( nRemainder == 0, mzddavitw->( dbCOMMIT()), NIL )
  enddo
  *
  if nRecCount > 0
    mzddavitx->( dbSkip( -1))
    mh_CopyFLD( 'mzddavitx', 'mzddavitw', .T. )
    mzddavitw->croobcpppv := strzero(mzddavitw->nrok,4)+strzero(mzddavitw->nobdobi,2) ;
                              + strzero(mzddavitw->noscisprac,5)+strzero(mzddavitw->nporpravzt,3)
    mzddavitw->crocpppv   := strzero(mzddavitw->nrok,4) ;
                              + strzero(mzddavitw->noscisprac,5)+strzero(mzddavitw->nporpravzt,3)
    DruhyMzd->( dbSEEK( StrZero(mzddavitw->nRok,4) +StrZero(mzddavitw->nObdobi,2) +StrZero(mzddavitw->nDruhMzdy,4),, 'DRUHYMZD04'))
    mzddavitw->nHrubaMzd  := mh_RoundNUMB( nHrubaMzda, DruhyMzd->nKodZaokr )
    mzddavitw->nHodDoklad := nHodiny
    mzddavitw->nMnPDoklad := nMnozPrace
    mzddavitw->nSazbaDokl := nHrubaMzda / nHodiny
    mzddavitw->nHodFondPD := nHodFondPD
    mzddavitw->nHodFondKD := nHodFondPD
    mzddavitw->nHodPresc  := nHodPresc
    mzddavitw->nHodPripl  := nHodPripl

    nHodFoPDDo += nHodFondPD

    if nDoklad == mzddavitx->nDoklad
      nOrdItem++
      mzddavitw->nOrdItem := nOrdItem * 10
    endif

    mzddavitw->nMzda      := mzddavitw->nHrubaMzd
    mzdDavItw->nzaklSocPo := 0
    mzdDavItw->nzaklZdrPo := 0

    if msPrc_moa->lsocPojis .and. druhyMzd->lsocPojis .and. ok_praVzt
      mzdDavItw->nzaklSocPo := mzdDavItw->nHrubaMZD
    endif

    if msPrc_moa->nzdrPojis <> 0 .and. druhyMzd->lzdrPojis .and. ok_praVzt
      mzdDavItw->nzaklZdrPo := mzdDavItw->nHrubaMZD
    endif

    mzddavitx->( dbSkip())
  endif

  if nHodFoPDDo > 0 .and. SysConfig('Mzdy:lGenOdpDny')
    mzddavitx->( dbSKIP( -1))
    mh_CopyFLD( 'mzddavitx', 'mzddavitw', .T.)
    mzddavitw->croobcpppv := strzero(mzddavitw->nrok,4)+strzero(mzddavitw->nobdobi,2) ;
                              + strzero(mzddavitw->noscisprac,5)+strzero(mzddavitw->nporpravzt,3)
    mzddavitw->crocpppv   := strzero(mzddavitw->nrok,4) ;
                              + strzero(mzddavitw->noscisprac,5)+strzero(mzddavitw->nporpravzt,3)

    nDenFond := fPracDOBA( msPrc_moa->cDelkPrDob)[3]

    mzddavitw->ndruhmzdy := 109
    mzddavitw->cucetskup := '109'

    nOrdItem++
    mzddavitw->nOrdItem := nOrdItem * 10

    mzddavitw->nHrubaMzd  := 0
    mzddavitw->nHodDoklad := 0
    mzddavitw->nMnPDoklad := 0
    mzddavitw->nSazbaDokl := 0
    mzddavitw->nHodFondPD := 0
    mzddavitw->nHodFondKD := 0
    mzddavitw->nHodPresc  := 0
    mzddavitw->nHodPripl  := 0

    mzddavitw->nDnyDoklad := Mh_RoundNumb( nHodFoPDDo/nDenFond, 32)
    mzddavitw->nDnyFondPD := Mh_RoundNumb( nHodFoPDDo/nDenFond, 32)
    mzddavitw->nDnyFondKD := Mh_RoundNumb( nHodFoPDDo/nDenFond, 32)

    mzddavitx->( dbSKIP())

  endif

  mzddavitw->( dbCommit())

RETURN NIL

********************************************************************************
METHOD MZD_ImportDokl_ML:AppendITMs()
  *
  mzddavitx->ctypdoklad := 'MZD_PRIJEM'
  mzddavitx->ctyppohybu := 'HRUBMZDA'
  mzddavitx->cKmenStrPR := msprc_moa->cKmenStrPr
  mzddavitx->nOsCisPrac := ListIT->nOsCisPrac
  if ::nStredVML == 3
    mzddavitx->cNazPOL1 := ListIT->cNazPOL1
  else
    mzddavitx->cNazPOL1   := IF( EMPTY( VyrZAK->cNazPOL1), msprc_mo->cKmenStrPR, VyrZAK->cNazPOL1 )
  endif
  mzddavitx->cNazPOL2   := VyrZAK->cNazPOL2
  mzddavitx->cNazPOL3   := VyrZAK->cNazPOL3
  mzddavitx->cNazPOL4   := VyrZAK->cNazPOL4
  mzddavitx->nMnPDoklad := ListIT->nKusyHotov
  mzddavitx->cUloha     := 'M'
  mzddavitx->cTask      := 'MZD'
  mzddavitx->cDenik     := 'MH'   // SysConfig( 'Mzdy:cDenikMzdy')
  mzddavitx->nRok       := ListIT->nRok     //YEAR( ListIT->dVyhotSkut)
  mzddavitx->nObdobi    := ListIT->nObdobi     //VAL( LEFT( ListIT->cObdobi, 2))
  mzddavitx->nRokObd    := ListIT->nRok*100 + ListIT->nObdobi
  mzddavitw->ddatporiz  := date()
  mzddavitw->ndoklad    := ::newDoklad
//  mzddavitx->nDoklad    := 5000000000 + ListIT->nOsCisPrac
//  M_DAVx->JM         := ListIT->cPrijPrac
  mzddavitx->cJmenoRozl := msprc_moa->cJmenoRozl
  mzddavitx->cPracovnik := LEFT( OSOBY->cOsoba, 25) + StrZERO( mzddavitx->nOsCisPrac)
  mzddavitx->nPorPraVzt := msprc_moa->nPorPraVzt
  mzddavitx->cPracZar   := msprc_moa->cPracZar
  mzddavitx->cPracZarDo := msprc_moa->cPracZar
  *2
 * IF MsPrc_MZ->( dbSEEK( ListIT->nOsCisPrac,, 'MSPRMZ01'))
*  IF MsPrc_MO->( dbSEEK( ListIT->nOsCisPrac,, 'MSPRMZ01'))
    mzddavitx->nTypZamVzt := msprc_moa->nTypZamVzt
    mzddavitx->nTypPraVzt := msprc_moa->nTypPraVzt
    mzddavitx->cMzdKatPra := msprc_moa->cMzdKatPra
    mzddavitx->nZdrPojis  := msprc_moa->nZdrPojis
    mzddavitx->nClenSpol  := IF( msprc_moa->nTypZamVzt = 2 .or. msprc_moa->nTypZamVzt = 3, 1, 0 )
  mzddavitx->nAutoGen    := 5
*  ENDIF
RETURN NIL


**HIDDEN************************************************************************
METHOD MZD_ImportDokl_ML:CondIsOK()
  Local lOK := NO, nREC := UcetSYS->( RecNO())
  Local acULOHA := { 'MZDY', 'ÚÈETNICTVÍ' }, cKey

  cKey := UPPER( ::cULOHA) + RIGHT( ::cExpOBD, 4) + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0')
  IF UcetSYS->( dbSEEK( cKey,, 'UCETSYS3'))
    IF UcetSYS->lZavren
      drgMsgBox(drgNLS:msg( 'Období [ & ] z VÝROBY je v modulu [ & ] již uzavøené !', ::cExpObd, acULOHA[ ::nExportML] ))
    ELSE
      lOK := YES
    ENDIF
  ELSE
    drgMsgBox(drgNLS:msg( 'Období [ & ]  v modulu [ & ]  neexistuje !', ::cExpObd, acULOHA[ ::nExportML] ))
  ENDIF
  UcetSYS->( dbGoTO( nREC))
RETURN lOK


**HIDDEN************************************************************************
METHOD MZD_ImportDokl_ML:IsZavren( lWrtZavren)
  Local cKEY := Upper( 'V') + RIGHT( ::cExpOBD, 4) + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0')
  Local lOK, lZavren := .F.

  DEFAULT lWrtZavren TO .F.
  * Zjistí, zda období existuje a zda je uzavøené
  IF ( lOK := UcetSYS->( dbSEEK( cKEY,, 'UCETSYS3')) )
    lZavren := UcetSYS->lZavren
    IF !lZavren .and. lWrtZavren
      * Není-li uzavøené a je požadavek na uzavøení - uzavøe ho
      IF UcetSYS->( dbRLock())
        UcetSYS->lZavren := YES
        UcetSYS->( dbUnlock())
        lZavren := UcetSYS->lZavren
//        ::VisibleActions()
      ENDIF
    ENDIF
  ENDIF

RETURN lZavren


* Výbìr období pøenosu
********************************************************************************
METHOD MZD_ImportDokl_ML:VYR_UcetSYS_SEL( oDlg)
  LOCAL oDialog, nExit, nRec // := UcetSYS->( RecNO())
  LOCAL Value := Upper( ::dm:get('M->cExpObd'))
  Local lOK := ( !Empty( Value) .and. UcetSYS->( dbSEEK( 'V' + RIGHT(Value,4) + LEFT( Value,2),, 'UCETSYS3')))

  UcetSYS->( AdsSetOrder( 3),;
             mh_SetScope( ::cUloha ), dbGoBottom() )
  IF  IsObject( oDlg) .or. !lOK
    DRGDIALOG FORM 'VYR_UCETSYS_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( oDlg:lastXbpInFocus:cargo:name,;
              StrZero(UcetSYS->nObdobi, 2) + '/' + StrZero(UcetSYS->nRok, 4) )
    nRec := UcetSYS->( RecNO())
    ::dm:save()
    ::VisibleActions(oDlg)
  ENDIF
  *
  UcetSYS->( mh_ClrScope(), dbGoTo( nRec))

RETURN lOK

* Výbìr období pøenosu
********************************************************************************
METHOD MZD_ImportDokl_ML:VYR_STRED_SEL( oDlg)
  LOCAL oDialog, nExit, nRec

  IF  IsObject( oDlg)   //.or. !lOK
    DRGDIALOG FORM 'VYR_STRED_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
  ENDIF
  *
RETURN lOK


* Aktualizuje viditelnost action-tlaèítek
** HIDDEN******************************************************************************
METHOD MZD_ImportDokl_ML:VisibleActions(drgDialog)
*  LOCAL members  := ::drgDialog:oActionBar:Members, x, lOk
  LOCAL members, x, lOk
  *
  members  := drgDialog:oActionBar:Members
  FOR x := 1 TO LEN( Members)
    IF Upper( members[x]:event) $ 'EXPORTML_UCTO'
      lOk := ( ::nExportML = DoMEZD)
      IF( lOk, members[x]:oXbp:disable(), members[x]:oXbp:enable() )
      members[x]:oXbp:setColorFG( If( lOk, GraMakeRGBColor({128,128,128}),;
                                           GraMakeRGBColor({0,0,0})))
     ELSEIF Upper( members[x]:event) $ 'EXPORTML_DEL'
      lOk := !::IsZavren()
      IF( lOk, members[x]:oXbp:disable(), members[x]:oXbp:enable() )
      members[x]:oXbp:setColorFG( If( lOk, GraMakeRGBColor({128,128,128}),;
                                           GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT
RETURN self

********************************************************************************
METHOD MZD_ImportDokl_ML:INFO_import( cINFO)

  IF Valtype( cINFO ) == "C"
    ::INFO_import := cINFO
    ::dm:set('M->Info_import', ::Info_import)
    ::dm:save()
///    ::dm:refresh()
  ENDIF
RETURN  ::Info_import

********************************************************************************
METHOD MZD_ImportDokl_ML:getForm()
  LOCAL oDrg, drgFC, n, x, y
  Local acStr
  local info := 'IMPORT mzdových lístkù'


  if ::typCall = 1

    ::acStred := ListAsARRAY(  ALLTRIM( SysCONFIG( 'Vyroba:cStrExpML')))
    ::alStred := {}
    acStr     := ListAsARRAY(  ALLTRIM( SysCONFIG( 'Vyroba:cStrExpML')))

    aEval( ::acStred, {|| aAdd( ::alStred, .F. )} )
   *
    FOR x := 1 TO Len( ::acStred)
      IF cNazPol1->( dbSEEK( Upper( ::acStred[ x] )))
        acStr[ x] := acStr[ x] + ' - ' + cNazPol1->cNazev
      ENDIF
    NEXT
    *
    drgFC := drgFormContainer():new()
    DRGFORM INTO drgFC SIZE 80, 20 DTYPE '10' TITLE 'Export mzdových lístkù' ;
                                              GUILOOK 'All:N,Action:y,IconBar:n,Menu:n'

    DRGACTION INTO drgFC CAPTION '~Spustit import'   EVENT 'ImportML_Start' TIPTEXT 'Spustí import mzdových lístkù'
    DRGACTION INTO drgFC CAPTION '~Zrušit import'    EVENT 'ImportML_Del'   TIPTEXT 'Zruší import všech mzdových lístkù'
*    DRGACTION INTO drgFC CAPTION '~Nastavit exp.'    EVENT 'ExportML_Ucto'  TIPTEXT 'Nastavení exportu mzdových lístkù do úèetnictví'

    DRGSTATIC INTO drgFC FPOS 0, 0 SIZE 79.6, 3 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
    DRGTEXT INTO drgFC NAME M->cImportML      CPOS  1,  1  CLEN 20  FONT 5
      DRGTEXT INTO drgFC CAPTION 'za období'  CPOS 25,  1  CLEN 15  FONT 5
      DRGTEXT INTO drgFC NAME M->cImpObd      CPOS 40,  1  CLEN 10  FONT 5
 *      DRGGET M->cExpObd INTO drgFC            FPOS 35,  1  FLEN 10
*      drgFC:members[ Len( drgFC:members)]:push := 'VYR_UCETSYS_SEL'
    DRGEND  INTO drgFC

    DRGTABPAGE INTO drgFC CAPTION 'Støediska'  FPOS 0.2, 3 SIZE 79.6,13.8  OFFSET 1,82
      FOR x := 1 TO LEN( acStr)
        y := IF( x <= 10,  3,;
             IF( x <= 20, 30, 57 ))
        n := IF( y = 30, x - 4,;
             IF( y = 57, x - 8, x  ))
        DRGCHECKBOX M->alStred[x] INTO drgFC   FPOS y, n   FLEN 20   VALUES 'T:'+ acStr[ x]+ ',' + 'F:' + acStr[ x]
        oDrg:name := 'M->alStred[' + Str(x,2) + ']'

      NEXT
    DRGEND INTO drgFC
    *
    DRGTEXT INTO drgFC CAPTION 'Prùbìh importu'      CPOS  1, 18  CLEN 15
    DRGTEXT INTO drgFC NAME M->Info_import           CPOS 20, 18  CLEN 58  BGND 13  FONT 5 CTYPE 3
  else
    drgFC := drgFormContainer():new()
    DRGFORM INTO drgFC SIZE 80, 20 DTYPE '10' TITLE 'Import mzdových lístkù' ;
                                              GUILOOK 'All:N,Action:n,IconBar:n,Menu:n'

    DRGSTATIC INTO drgFC FPOS 0, 0 SIZE 79.6, 3 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
     DRGTEXT INTO drgFC NAME cImportML         CPOS  1,  1  CLEN 20  FONT 5
       DRGTEXT INTO drgFC CAPTION 'za období'  CPOS 25,  1  CLEN 15  FONT 5
     DRGTEXT INTO drgFC NAME M->cImpObd        CPOS 40,  1  CLEN 10  FONT 5
    DRGEND  INTO drgFC

    DRGSTATIC INTO drgFC FPOS 0.2, 3 SIZE 79.6,13.8  STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'

     DRGPUSHBUTTON INTO drgFC CAPTION 'Start' POS 25,6 SIZE 30,2.2 ;
       EVENT 'ImportML_Start' ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ;
        TIPTEXT 'Spustí import mzdových lístkù'

    DRGEND  INTO drgFC


    DRGTEXT INTO drgFC CAPTION 'Prùbìh importu'      CPOS  1, 18  CLEN 15
    DRGTEXT INTO drgFC NAME M->Info_import           CPOS 20, 18  CLEN 58  BGND 13  FONT 5 CTYPE 3
  endif
RETURN drgFC

********************************************************************************
********************************************************************************

CLASS MZD_UcetSYS_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled, getForm
HIDDEN:
  VAR  drgGet
ENDCLASS

********************************************************************************
METHOD MZD_UcetSYS_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('UcetSYS',,,,,'UcetSYSw')
RETURN self

**********************************************************************
METHOD MZD_UcetSYS_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD MZD_UcetSYS_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

********************************************************************************
METHOD MZD_UcetSYS_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    IF .not. Ucetsys ->(DbSeek( 'V' + Right(::drgGet:oVar:value, 4) + Left(::drgGet:oVar:value, 2),,'UCETSYS3'))
       UcetSYS->(DbGoTop())
    ENDIF
*    drgDialog:dialogCtrl:browseRefresh()
    drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  ENDIF
RETURN self

********************************************************************************
METHOD MZD_UcetSYS_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 25, 13 DTYPE '10' TITLE 'Úèetní období - VÝBÌR' ;
                                           FILE 'UcetSYS'                   ;
                                           GUILOOK 'All:N,Border:Y'
  DRGDBROWSE INTO drgFC SIZE 25,12.8 INDEXORD 3 ;
                       FIELDS 'MESIC_():Mìsíc, nRok:Rok, cUloha'  ;
                       SCROLL 'ny' CURSORMODE 3 PP 7
RETURN drgFC

FUNCTION MESIC_()
RETURN aMESICE[UcetSYS->nObdobi]

********************************************************************************
********************************************************************************

CLASS MZD_Stred_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled, getForm
HIDDEN:
  VAR  drgGet
ENDCLASS

********************************************************************************
METHOD MZD_Stred_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('UcetSYS',,,,,'UcetSYSw')
RETURN self

********************************************************************************
METHOD MZD_Stred_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD MZD_Stred_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

********************************************************************************
METHOD MZD_Stred_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    IF .not. Ucetsys ->(DbSeek('V' + Right(::drgGet:oVar:value, 4) + Left(::drgGet:oVar:value, 2),,'UCETSYS3'))
       UcetSYS->(DbGoTop())
    ENDIF
*    drgDialog:dialogCtrl:browseRefresh()
    drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  ENDIF
RETURN self

********************************************************************************
METHOD MZD_Stred_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 35, 13 DTYPE '10' TITLE 'Støediska exportu - VÝBÌR' ;
                                           FILE 'cNazPOL1'                   ;
                                           GUILOOK 'All:N,Border:Y'
  DRGDBROWSE INTO drgFC SIZE 35,12.8 INDEXORD 3 ;
                       FIELDS 'cNazPol1:Stredisko, cNazev:Název støediska'  ;
                       SCROLL 'ny' CURSORMODE 3 PP 7
RETURN drgFC