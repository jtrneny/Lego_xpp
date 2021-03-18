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
CLASS MZD_ImportDokl_DOCH FROM drgUsrClass, MZD_doklhrmz_in

EXPORTED:
  VAR     nExportDOCH, cImportDOCH, cExpObd, cExpStr, aExport, Info_import
  VAR     nStredVDOCH, cUloha
  VAR     acStred, alStred
  var     cImpObd, acPrac, acOsob
  var     nImpRok, nImpObd
  var     lnewRec
  var     anFND

  *
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, EventHandled, getForm
  METHOD  postValidate, CheckItemSelected
  METHOD  importDOCH_DEL
  METHOD  importDOCH_START
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
  var     typCall, nrec_msPrc_mo
  var     newDoklad, ordItem

  method  VisibleActions
  method  AppendItms, CondIsOK, IsZavren

ENDCLASS

********************************************************************************
METHOD MZD_ImportDokl_DOCH:init(parent)
  Local cHlp     := AllTrim( SysCONFIG( 'Vyroba:cStrExpML'))
  Local aNazPol1 := ListAsARRAY( cHLP)
  local arr

  *
  ::typCall :=  Val( ListAsARRAY( parent:initParam)[2])
  *
//  ::nExportML  := SysConfig( 'Vyroba:nExportML')
  ::nStredVDOCH  := SysConfig( 'Vyroba:nStredVML')
  *
  drgDBMS:open('dspohyby'   )
  drgDBMS:open('Osoby'    )

  drgDBMS:open('VYRZAK'   )
  drgDBMS:open('C_PRIPL'  )
  drgDBMS:open('C_PRERUS' )
  drgDBMS:open('cNazPOL1' )
  drgDBMS:open('UCETSYS'  )
  drgDBMS:open('mzddavhd',,,,,'mzddavhda')
  drgDBMS:open('mzddavit',,,,,'mzddavita')
  drgDBMS:open('c_nakstr',,,,,'c_nakstra')

  ff := 1
  *
  * pro sumu za daný klíè, sociální a zdravotní
  drgDBMS:open('MZDDAVHD',,,,, 'mzddavHd_s')

  drgDBMS:open('DruhyMZD',,,,,'druhymzda')
  drgDBMS:open('C_STRED'  )
  drgDBMS:open('C_EXPML'  )
  *
  drgDBMS:open('MsPrc_MO' )
  *
  drgDBMS:open('MsPrc_MO',,,,,'msprc_moa' )

  drgDBMS:open('mzddavhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP       // pùvodnì m_davs
  drgDBMS:open('mzddavitw',.T.,.T.,drgINI:dir_USERfitm); ZAP       // pùvodnì m_davs

  if ::typCall = 2
    msprc_mo->( dbSeek( ListAsARRAY( parent:initParam)[3],,'MSPRMO17' ))
    ::nrec_msPrc_mo := msPrc_mo->(recNo())
  endif
  *
  ::nExportDOCH := 1
  ::acPrac      := {}
  ::acOsob      := {}
  ::aExport     := { 'do mezd '}
  ::cImportDOCH := 'IMPORT ' + ::aExport[ ::nExportDOCH]
  ::cExpObd     := StrZERO(uctOBDOBI:MZD:NOBDOBI,2) + '/' + STR( uctOBDOBI:MZD:NROK, 4)
  ::cImpObd     := StrZERO(uctOBDOBI:MZD:NOBDOBI,2) + '/' + STR( uctOBDOBI:MZD:NROK, 4)
  ::nImpRok     := uctOBDOBI:MZD:NROK
  ::nImpObd     := uctOBDOBI:MZD:NOBDOBI
  ::cUloha      := 'H'   // IF( ::nExportML = DoMEZD, 'M', 'U')

  * zjištìní posledního èísla dokladu
    arr := sysConfig('Mzdy:nRangeMZ_D')

    cfiltr := Format("ndoklad >= %% .and. nDOKLAD <= %%", {arr[1], arr[2]})
    mzddavhda->(ads_setaof(cfiltr),OrdSetFocus('MZDDAVHD11'), DbGoBottom())
    ::newDoklad := if( mzddavhda->ndoklad = 0, arr[1]-1, mzddavhda->ndoklad)
    mzddavhda->(ads_clearaof())

RETURN self

********************************************************************************
METHOD MZD_ImportDokl_DOCH:destroy()
  ::drgUsrClass:destroy()

  ::nExportDOCH   := ::nStredVDOCH := ;
  ::aExport       := ::cImportDOCH := ::cExpObd  := ::cExpStr := ;
  ::Info_import   := ::cUloha      := NIL

  if ::typCall = 2
    msPrc_mo->( dbgoTo( ::nrec_msPrc_mo))
  endif

RETURN self

********************************************************************************
METHOD MZD_ImportDokl_DOCH:drgDialogInit(drgDialog)

  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
  drgDialog:Title := ::aExport[ ::nExportDOCH]

  ::lnewRec := .t.
RETURN self

********************************************************************************
METHOD MZD_ImportDokl_DOCH:drgDialogStart(drgDialog)
  local  members, x
*  LOCAL  members  := ::drgDialog:oActionBar:Members, x
  *

  ( ::hd_file := 'mzddavhdw', ::it_file := 'mzddavitw' )

  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager

  *
  do case
  case ::typCall = 1
    members  := drgDialog:oActionBar:Members
    ::Info_import := ''
    ::VisibleActions(drgDialog)
    ::Info_import := '.....GENEROVÁNÍ MZDOVÝCH DOKLADU Z DOCHÁZKY ZA STØEDISKA .....'

  case ::typCall = 2 .or. ::typCall = 3
    ::Info_import := ' .... ' + AllTrim(MsPrc_mo->cjmenorozl ) + ' .... '

  case ::typCall = 4
    ::Info_import := '.....GENEROVÁNÍ MZDOVÝCH DOKLADU Z DOCHÁZKY ZA VYBRANÉ PRACOVNÍKY.....'

  endcase
  *
RETURN self

********************************************************************************
METHOD MZD_ImportDokl_DOCH:eventHandled(nEvent, mp1, mp2, oXbp)

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
METHOD MZD_ImportDokl_DOCH:postValidate( oVar)
  LOCAL xVar  := oVar:get(), cName := UPPER(oVar:name), cKEY
  Local lOK := .T.

  DO CASE
    CASE cName = 'M->cExpObd'
      lOK := ::Vyr_UcetSys_sel()
  ENDCASE
RETURN lOK

********************************************************************************
METHOD MZD_ImportDokl_DOCH:CheckItemSelected( CheckBox)
  Local name := drgParseSecond( CheckBox:oVar:Name,'>')
  Local nPos := VAL( SUBSTR( name, AT( '[', Name) +1, 2 ))

*  self:&Name := CheckBox:Value
  self:alStred[ nPos] := IF( CheckBox:Value = "T", .T., .F. )
RETURN self


*
********************************************************************************
METHOD MZD_ImportDokl_DOCH:importDOCH_Start(parent)
  Local nAREA := SELECT(), n
  Local cKey, cKeyOLD, cKeyNEW, cObdPREN
  Local nRYO, nCount := 0, nRecCount, nRemainder
  Local nHrubaMzda := 0, nHodiny   := 0, nMnozPrace := 0
  Local nHodFondPD := 0, nHodPresc := 0, nHodPripl := 0
  Local nDoklad, nOrdItem
  Local lNewREC, lOK, lExp, lSEEK
  Local dPrenos := DATE(), cPrenos := SysCONFIG( 'System:cUserAbb')
  Local aREC := {}, bREC := {}
  Local cMsg := 'Požadujete spustit generování mzdových dokladù z docházky za obobí [ & ] ?'
  local arSel
  local recMS

  do case
  case ::typCall = 1
    for n := 1 to  len(::acStred)
      if ::alStred[ n]
        ::cExpStr := ::acStred[ n]
         cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. cKMENSTRPR = '%%' .and. lImportDoc .and. lStavem"  ;
                           , {::nImpRok, ::nImpObd, ::cExpStr})
         msprc_moa->(ads_setaof(cfiltr), dbGoTop())
         do while .not. msprc_moa->(Eof())
           AAdd(::acPrac,msprc_moa->(recNo()))
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
        if msprc_mo->lImportDoc .and. msprc_mo->lStavem
          AAdd(::acPrac,msprc_mo->(recNo()))
        endif
        msprc_mo->( dbSkip())
      enddo
      msprc_mo->( dbGoTo(recMS))

    else
      ::acPrac := if(len(parent:parent:odbrowse[1]:arSelect) =0, {msprc_mo->(recNo())}, parent:parent:odbrowse[1]:arSelect)
    endif
  endcase

  for n := 1 TO LEN( ::acPrac)
    msprc_mo->( dbGoTo(::acPrac[n]))
    if osoby->( dbSeek( msprc_mo->nosoby,,'sid'))
      AAdd(::acOsob, osoby->(recNo()))
    endif
  next

  tmpsumkon( , 'MZD')

  for n := 1 TO LEN( ::acPrac)
    BEGIN SEQUENCE

      mzdDavhdw->( dbZap())
      mzdDavitw->( dbZap())

      msprc_moa->( dbGoTo( ::acPrac[n]))
      msPrc_mo ->( dbGoTo( ::acPrac[n]))  // pro anSazby

      ::Info_import := drgNLS:msg('GENERUJI ....' +AllTrim(msprc_moa->cJmenorozl) +'....')

      cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. nOSCISPRAC = %% .and. nPORPRAVZT = %% .and. nAUTOGEN = 6"  ;
                       , {msprc_moa->nROK, msprc_moa->nOBDOBI, msprc_moa->nOSCISPRAC, msprc_moa->nPORPRAVZT})

      * použít SQL zrušíme minulý pøenos
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

       cfiltr := Format("ncisOsoby = %%", { msprc_moa->ncisOsoby })
       tmpsumkow->(ads_setaof(cfiltr), dbGoTop())

       nRecCount := tmpsumkow->( Ads_GetRecordCount())

       if nRecCount == 0
*          ::Info_import := drgNLS:msg('Nenalezena žádná data k importu ...')
         BREAK
       endif

       if .not. tmpsumkow->(eof())
         mh_CopyFLD( 'msprc_moa', 'mzddavhdw', .T. )

         ::newDoklad++
         ::ordItem := 0
         mzddavhdw->ndoklad    := ::newDoklad
         mzddavhdw->cdenik     := 'MH'
         mzddavhdw->ctypdoklad := 'MZD_PRIJEM'
         mzddavhdw->ctyppohybu := 'HRUBMZDA'
         mzddavhdw->ddatporiz  := date()
         mzddavhdw->nAutoGen   := 6
       endif

       if tmpsumkow->nDovolenHo <> 0                                      ;
           .and. C_Prerus ->( dbSeek( Upper( "DOV"),,'C_PRERUS01'))                  ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nDovolenDn
         ::anFND[2] := tmpsumkow->nDovolenHo
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nSvatkyHo <> 0                                        ;
           .and. C_Prerus ->( dbSeek( Upper( "SVA"),,'C_PRERUS01'))                   ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow ->nSvatkyDn
         ::anFND[2] := tmpsumkow->nSvatkyHo
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nNeplVolHo <> 0                                       ;
           .and. C_Prerus ->( dbSeek( Upper( "NEV"),,'C_PRERUS01'))                    ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow ->nNeplVolDn
         ::anFND[2] := tmpsumkow->nNeplVolHo
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nNahZMzdHo <> 0                                      ;
            .and. C_Prerus ->( dbSeek( Upper( "NMZ"),,'C_PRERUS01'))                    ;
             .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND  := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nNahZMzdDn
         ::anFND[2] := tmpsumkow->nNahZMzdHo
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nRefuMzdHo <> 0                                      ;
            .and. C_Prerus ->( dbSeek( Upper( "REF"),,'C_PRERUS01'))                   ;
             .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nRefuMzdDn
         ::anFND[2] := tmpsumkow->nRefuMzdHo
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nOstNahrHo <> 0                                    ;
           .and. C_Prerus ->( dbSeek( Upper( "LEK"),,'C_PRERUS01'))     ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nOstNahrDn
         ::anFND[2] := tmpsumkow->nOstNahrHo
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nAbsenceHo <> 0                                    ;
           .and. C_Prerus ->( dbSeek( Upper( "ABS"),,'C_PRERUS01'))     ;
             .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nAbsenceDn
         ::anFND[2] := tmpsumkow->nAbsenceHo
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nPresc25Ho <> 0                                     ;
           .and. ( C_Prerus ->( dbSeek( Upper( "PPD"),,'C_PRERUS01'))                ;
                             .or. C_Prerus ->( dbSeek( Upper( "MPD"),,'C_PRERUS01'))) ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[2] := tmpsumkow->nPresc25Ho
         ::anFND[7] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nPresc50Ho <> 0                                     ;
           .and. ( C_Prerus ->( dbSeek( Upper( "PSN"),,'C_PRERUS01'))                ;
                              .or. C_Prerus ->( dbSeek( Upper( "MSN"),,'C_PRERUS01')))        ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[2] := tmpSumKoW->nPresc50Ho
         ::anFND[7] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nPripl10SN <> 0                                     ;
           .and. C_Prerus ->( dbSeek( Upper( "SNP"),,'C_PRERUS01'))                 ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[2] := tmpsumkow->nPripl10SN
         ::anFND[7] := ::anFND[2]
         ::AppendITMs()
       endif

       IF tmpsumkow->nSvatPriHo <> 0                                     ;
           .and. ( C_Prerus ->( dbSeek( Upper( "PSV"),,'C_PRERUS01'))                ;
                              .or. C_Prerus ->( dbSeek( Upper( "MSV"))))        ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[2] := tmpsumkow->nSvatPriHo
         ::anFND[8] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nPripl10SV <> 0                                     ;
           .and.  C_Prerus ->( dbSeek( Upper( "SVP"),,'C_PRERUS01'))                 ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[2] := tmpsumkow->nPripl10SV
         ::anFND[7] := ::anFND[2]
          ::AppendITMs()
       endif

       if tmpsumkow->nNocnPriHo <> 0                                     ;
           .and. C_Prerus ->( dbSeek( Upper( "PNO"),,'C_PRERUS01'))                  ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND     := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[2]  := tmpsumkow->nNocnPriHo
         ::anFND[8]  := ::anFND[2]
         ::anFND[11] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nNahrZa80h <> 0                                    ;
           .and. C_Prerus ->( dbSeek( Upper( "NM1"),,'C_PRERUS01'))     ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nNahrZa80d
         ::anFND[2] := tmpsumkow->nNahrZa80h
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nNahrZ100h <> 0                                    ;
           .and. C_Prerus ->( dbSeek( Upper( "NM2"),,'C_PRERUS01'))     ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nNahrZ100d
         ::anFND[2] := tmpsumkow->nNahrZ100h
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       if tmpsumkow->nNahrZa60h <> 0                                    ;
           .and. C_Prerus ->( dbSeek( Upper( "NM3"),,'C_PRERUS01'))     ;
            .and. C_Prerus ->nDruhMzdy <> 0
         ::anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
         ::anFND[1] := tmpsumkow->nNahrZa60d
         ::anFND[2] := tmpsumkow->nNahrZa60h
         ::anFND[5] := ::anFND[3] := ::anFND[1]
         ::anFND[6] := ::anFND[4] := ::anFND[2]
         ::AppendITMs()
       endif

       (::it_file)->( dbCOMMIT(), dbgoTop())
       tmpsumkow->( ads_clearaof())

       ( nCount := 0, nRecCount := (::it_file)->( RecCOUNT()) )
       lExp := NO

       mzd_mzddavhd_cmp(.t.)
       msPrc_mo->( dbseek( isNull( msPrc_moa->sID, 0),,'ID'))

       (::hd_file)->( dbcommit())
       mzd_mzddavhd_wrt_inTrans(self)

/*
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
*/
        ** Nastavení indikace uzavøení pøenosu
        **  nCountPRMs := UzavriPREN()
*        ::IsZavren( .T.)

      ENDSEQUENCE
  next

  ::INFO_import := drgNLS:msg('... GENEROVÁNÍ MZDOVÝCH DOKLADU Z DOCHÁZKY UKONÈENO ... ')
  dbSelectAREA( nAREA)
*/


RETURN NIL


* Zrušení exportu mzdových lístkù
********************************************************************************
METHOD MZD_ImportDokl_DOCH:importDOCH_Del(drgDialog)
  Local cKEY := Upper( 'H') + RIGHT( ::cExpOBD, 4) + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0')
  Local cMsg := 'Požadujete zrušit import všech vygenerovaných dokladù z docházky za obobí [ & ] ?'
  Local oMoment, cKeyUcto

  IF drgIsYesNo(drgNLS:msg( cMsg, ::cExpObd))
     oMoment := SYS_MOMENT( 'Probíhá rušení vygenerovaných dokladù z docházky')
    *
    IF ::nExportDOCH = DoMEZD
      cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. nAUTOGEN = 6",{::nImpRok, ::nImpObd})

      * použít SQL zrušíme minulý pøenos
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
      * ???
    ENDIF
    *
    IF UcetSYS->( dbSEEK( cKey,, 'UCETSYS3'))
      IF UcetSYS->( dbRLock())
        UcetSYS->lZavren := .F.
        UcetSYS->( dbUnlock())
        ::VisibleActions(drgDialog)
        ::Info_import := drgNLS:msg( '... VYGENEROVANÉ DOKLADY Z DOCHÁZKY ZRUŠENY ...')
      ENDIF
    ENDIF

    oMoment:destroy()
  ENDIF
RETURN NIL



********************************************************************************
METHOD MZD_ImportDokl_DOCH:AppendITMs()
  local  ndmz := C_Prerus ->nDruhMzdy


  mh_CopyFLD( 'msprc_moa', ::it_file, .T. )
  ::ordItem++
  *
  (::it_file)->ctypdoklad := 'MZD_PRIJEM'
  (::it_file)->ctyppohybu := 'HRUBMZDA'
  (::it_file)->cKmenStrPR := msprc_moa->cKmenStrPr
  (::it_file)->nMnPDoklad := 0    //ListIT->nKusyHotov
  (::it_file)->cUloha     := 'M'
  (::it_file)->cTask      := 'MZD'
  (::it_file)->cDenik     := SysConfig( 'Mzdy:cDenikMZ_D')
  (::it_file)->nRok       := msprc_moa->nRok     //YEAR( ListIT->dVyhotSkut)
  (::it_file)->nObdobi    := msprc_moa->nObdobi     //VAL( LEFT( ListIT->cObdobi, 2))
  (::it_file)->nRokObd    := msprc_moa->nRok*100 + msprc_moa->nObdobi
  (::it_file)->ddatporiz  := date()
  (::it_file)->ndoklad    := ::newDoklad
  (::it_file)->norditem   := ::ordItem
  (::it_file)->ndruhMzdy  := ndmz

//  mzddavitx->nDoklad    := 5000000000 + ListIT->nOsCisPrac
//  M_DAVx->JM         := ListIT->cPrijPrac
  (::it_file)->cJmenoRozl := msprc_moa->cJmenoRozl
  (::it_file)->cPracovnik := LEFT( msprc_moa->cOsoba, 25) + StrZERO( msprc_moa->nOsCisPrac,5)
  (::it_file)->nPorPraVzt := msprc_moa->nPorPraVzt
  (::it_file)->cPracZar   := msprc_moa->cPracZar
  (::it_file)->cPracZarDo := msprc_moa->cPracZar
  *2
 * IF MsPrc_MZ->( dbSEEK( ListIT->nOsCisPrac,, 'MSPRMZ01'))
*  IF MsPrc_MO->( dbSEEK( ListIT->nOsCisPrac,, 'MSPRMZ01'))
    (::it_file)->nTypZamVzt := msprc_moa->nTypZamVzt
    (::it_file)->nTypPraVzt := msprc_moa->nTypPraVzt
    (::it_file)->cMzdKatPra := msprc_moa->cMzdKatPra
    (::it_file)->nZdrPojis  := msprc_moa->nZdrPojis
    (::it_file)->nClenSpol  := IF( msprc_moa->nTypZamVzt = 2 .or. msprc_moa->nTypZamVzt = 3, 1, 0 )
  (::it_file)->nAutoGen    := 6

/*
  if c_nakstra->( dbSeek( Upper(msprc_moa->cnaklst1),,'NAKSTR01'))
    (::it_file)->cNazPol1 := c_nakstra->cNazPol1
    (::it_file)->cNazPol2 := c_nakstra->cNazPol2
    (::it_file)->cNazPol3 := c_nakstra->cNazPol3
    (::it_file)->cNazPol4 := c_nakstra->cNazPol4
    (::it_file)->cNazPol5 := c_nakstra->cNazPol5
    (::it_file)->cNazPol6 := c_nakstra->cNazPol6
  else
//    BOX_Waring( "POZOR nenaçel jsem pro pracovn¡ka re§ijn¡ vazbu !!!" )
  endif
*/

  PrednaNAKL( ::it_file, msprc_moa->cNazPol1)

  do case
  case nDMZ = 122 .or. nDMZ = 120
    (::it_file)->nDnyDoklad := if( nDMZ = 120, ::anFND[14], ::anFND[3])
    (::it_file)->nHodDoklad := ::anFND[5]

    (::it_file)->nDnyFondKD := (::it_file)->nDnyDoklad
    (::it_file)->nDnyFondPD := (::it_file)->nDnyDoklad
    (::it_file)->nHodFondKD := (::it_file)->nHodDoklad
    (::it_file)->nHodFondPD := (::it_file)->nHodDoklad

  case nDMZ = 127
    do case
    case nTypAutGHM = 1
      (::it_file)->nSazbaDokl := fSazZAM( Date())[2]
      (::it_file)->nMnPDoklad := ::anFND[5]
    otherwise
      (::it_file)->nDnyDoklad := ::anFND[3]
      (::it_file)->nHodDoklad := ::anFND[5]
    endcase

  case nDMZ = 150
    (::it_file)->nSazbaDokl := nTMPsazba
    (::it_file)->nMnPDoklad := fSazZAM( Date())[1] / 100


  case nDMZ = 156
    (::it_file)->nSazbaDokl := fSazZAM( Date())[3]
    (::it_file)->nMnPDoklad := ::anFND[5]

  case nDMZ = 199
    (::it_file)->nDnyDoklad := ::anFND[1]
    (::it_file)->nHodDoklad := ::anFND[2]

    (::it_file)->nDnyFondKD := ::anFND[3]
    (::it_file)->nHodFondKD := ::anFND[4]

  otherwise
    (::it_file)->nDnyDoklad := ::anFND[1]
    (::it_file)->nHodDoklad := ::anFND[2]
    (::it_file)->nMnPDoklad := ::anFND[11]

    (::it_file)->nDnyFondKD := ::anFND[3]
    (::it_file)->nHodFondKD := ::anFND[4]

    (::it_file)->nDnyFondPD := ::anFND[5]
    (::it_file)->nHodFondPD := ::anFND[6]

    (::it_file)->nHodPresc  := ::anFND[7]
    (::it_file)->nHodPripl  := ::anFND[8]

  endcase

  (::it_file)->cUcetSkup  := AllTrim( Str( (::it_file)->nDruhMzdy))

//  anX := fSAZBA( ( cFILE) ->nDruhMzdy, cFILE)

  (::it_file)->(dbcommit())

  ::VypHrMZ( .t. )

//  je tu tvrdost pro naplnìní sociálního a zdravotního
    if msprc_moa->lSocPojis
      (::it_file)->nZaklSocPo  := (::it_file)->nHrubaMzd
    endif

    if msprc_moa->lZdrPojis
      (::it_file)->nZaklZdrPo  := (::it_file)->nHrubaMzd
    endif

*  if (::it_file)->nDnyDoklad == 0 .AND. mzddavitx->nHodDoklad == 0        ;
*       .AND. mzddavitx->nSazbaDokl == 0 .AND. mzddavitx->nMzda == 0
*    DelREC( "M_Dav")
*  endif
RETURN NIL


**HIDDEN************************************************************************
METHOD MZD_ImportDokl_DOCH:CondIsOK()
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
METHOD MZD_ImportDokl_DOCH:IsZavren( lWrtZavren)
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
METHOD MZD_ImportDokl_DOCH:VYR_UcetSYS_SEL( oDlg)
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
METHOD MZD_ImportDokl_DOCH:VYR_STRED_SEL( oDlg)
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
METHOD MZD_ImportDokl_DOCH:VisibleActions(drgDialog)
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
METHOD MZD_ImportDokl_DOCH:INFO_import( cINFO)

  IF Valtype( cINFO ) == "C"
    ::INFO_import := cINFO
    ::dm:set('M->Info_import', ::Info_import)
    ::dm:save()
///    ::dm:refresh()
  ENDIF
RETURN  ::Info_import

********************************************************************************
METHOD MZD_ImportDokl_DOCH:getForm()
  LOCAL oDrg, drgFC, n, x, y
  local ax, ay
  Local acStr
  local info := 'IMPORT-GENEROVÁNÍ mzdových dokladù z docházky'


  if ::typCall = 1
    ::acStred := {}
    ::alStred := {}
    acStr     := {}

/*
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
*/

    cNazPol1->( dbGoTop())
    do while .not. cNazPol1->( Eof())
      ax  := AllTrim(cNazPol1->cnazpol1) + ' - ' + cNazPol1->cNazev
      ay  := AllTrim(cNazPol1->cnazpol1)
      aAdd( ::acStred, ay )
      aAdd( acStr, ax)
      aAdd( ::alStred, .F. )
      cNazPol1->( dbSkip())
    enddo
    *
    drgFC := drgFormContainer():new()
    DRGFORM INTO drgFC SIZE 80, 20 DTYPE '10' TITLE 'IMPORT-GENEROVÁNÍ mzdových dokladù z docházky' ;
                                              GUILOOK 'All:N,Action:y,IconBar:n,Menu:n'

    DRGACTION INTO drgFC CAPTION '~Spustit import'   EVENT 'ImportDOCH_Start' TIPTEXT 'Spustí import - generování mzdových dokladù z docházky'
    DRGACTION INTO drgFC CAPTION '~Zrušit import'    EVENT 'ImportDOCH_Del'   TIPTEXT 'Zruší všechny vygenerované mzdové doklady z docházky'
*    DRGACTION INTO drgFC CAPTION '~Nastavit exp.'    EVENT 'ExportML_Ucto'  TIPTEXT 'Nastavení exportu mzdových lístkù do úèetnictví'

    DRGSTATIC INTO drgFC FPOS 0, 0 SIZE 79.6, 3 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
    DRGTEXT INTO drgFC NAME M->cImportDOCH      CPOS  1,  1  CLEN 20  FONT 5
      DRGTEXT INTO drgFC CAPTION 'za období'  CPOS 25,  1  CLEN 15  FONT 5
      DRGTEXT INTO drgFC NAME M->cImpObd      CPOS 40,  1  CLEN 10  FONT 5
 *      DRGGET M->cExpObd INTO drgFC            FPOS 35,  1  FLEN 10
*      drgFC:members[ Len( drgFC:members)]:push := 'VYR_UCETSYS_SEL'
    DRGEND  INTO drgFC

    DRGTABPAGE INTO drgFC CAPTION 'Støediska'  FPOS 0.2, 3 SIZE 79.6,13.8  OFFSET 1,82
      FOR x := 1 TO LEN( acStr)
        y := IF( x <= 10,  3,;
             IF( x <= 20, 30, 57 ))
        n := IF( y = 30, x - 10,;
             IF( y = 57, x - 20, x  ))
        DRGCHECKBOX M->alStred[x] INTO drgFC   FPOS y, n   FLEN 25   VALUES 'T:'+ acStr[ x]+ ',' + 'F:' + acStr[ x]
        oDrg:name := 'M->alStred[' + Str(x,2) + ']'

      NEXT
    DRGEND INTO drgFC
    *
    DRGTEXT INTO drgFC CAPTION 'Prùbìh importu'      CPOS  1, 18  CLEN 15
    DRGTEXT INTO drgFC NAME M->Info_import           CPOS 20, 18  CLEN 58  BGND 13  FONT 5 CTYPE 3
  else
    drgFC := drgFormContainer():new()
    DRGFORM INTO drgFC SIZE 80, 20 DTYPE '10' TITLE 'Import-generování mzdových dokladù z docházky' ;
                                              GUILOOK 'All:N,Action:n,IconBar:n,Menu:n'

    DRGSTATIC INTO drgFC FPOS 0, 0 SIZE 79.6, 3 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
     DRGTEXT INTO drgFC NAME cImportDOCH       CPOS  1,  1  CLEN 20  FONT 5
       DRGTEXT INTO drgFC CAPTION 'za období'  CPOS 25,  1  CLEN 15  FONT 5
     DRGTEXT INTO drgFC NAME M->cImpObd        CPOS 40,  1  CLEN 10  FONT 5
    DRGEND  INTO drgFC

    DRGSTATIC INTO drgFC FPOS 0.2, 3 SIZE 79.6,13.8  STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'

     DRGPUSHBUTTON INTO drgFC CAPTION 'Start' POS 25,6 SIZE 30,2.2 ;
       EVENT 'ImportML_Start' ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ;
        TIPTEXT 'Spustí import-generování mzdových dokladù z docházky'

    DRGEND  INTO drgFC


    DRGTEXT INTO drgFC CAPTION 'Prùbìh importu'      CPOS  1, 18  CLEN 15
    DRGTEXT INTO drgFC NAME M->Info_import           CPOS 20, 18  CLEN 58  BGND 13  FONT 5 CTYPE 3
  endif

  DRGTEXT INTO drgFC NAME mzdDavitW->nsazbaDokl      CPOS  0,0  CLEN 0
  DRGTEXT INTO drgFC NAME mzdDavitW->npremie         CPOS  0,0  CLEN 0

RETURN drgFC


********************************************************************************
********************************************************************************

/*
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

*/


/*
STATIC FUNCTION GenRADEKdok( nDMZ, nDokl, nPOR, anFPD)
  LOCAL cFILE := "m_Dav"
  LOCAL lOK := .T.
  LOCAL anX
  LOCAL        nRecMSp := MsPrc_Mz ->( Recno())
  LOCAL cTagMSp := MsPrc_Mz ->( OrdSetFOCUS())
  LOCAL nTMPsazba
  LOCAL nX

// nTypAutGHM = 1  -  TREFAL

  IF IsNil( anFPD)
    anFPD := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  ENDIF

  IF nDMZ = 150
    DO CASE
    CASE nTypAutGHM = 1
      IF MsPrc_Mz ->cTypTarMZD = "CASOVA  "
        nTMPsazba := M_Dav ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
      ELSE
        nTMPsazba := M_Dav ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
      ENDIF
    OTHERWISE
      nTMPsazba := M_Dav ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
    ENDCASE
  ENDIF

  MH_CopyFLD( 'MsPrc_Mz', 'M_Dav', .T.,, .T., .T.)

  m_Dav ->cUloha     := "M"
  m_Dav ->cDenik     := "M"
  m_Dav ->nRok       := ACT_OBDyn()
  m_Dav ->nObdobi    := ACT_OBDon()
  m_Dav ->cObdobi    := ACTObdobi()
  m_Dav ->nDoklad    := nDokl +MsPrc_Mz ->nOsCisPrac
  m_Dav ->nOrdItem   := nPOR *10
  m_Dav ->cPracZarDo := MsPrc_Mz ->cPracZar
  IF Month( Date()) <> ACT_OBDon()
    m_Dav ->dDatPoriz := LastODate( ACT_OBDyn(), ACT_OBDon())
  ELSE
    m_Dav ->dDatPoriz := Date()
  ENDIF

  m_Dav ->cKmenStrSt := MsPrc_Mz ->cKmenStrPr
  m_Dav ->nZdrPojis  := MsPrc_Mz ->nZdrPojis
  m_Dav ->cTmKmStrPr := TMPkmenSTR( MsPrc_Mz ->cKmenStrPr)
  m_Dav ->cPracovnik := cPRACsort( "MsPrc_Mz")
  m_Dav ->nUcetMzdy  := 0

  PrednaNAKL( "M_Dav")

  m_Dav ->nDruhMzdy  := nDMZ

  DO CASE
  CASE nDMZ = 122 .OR. nDMZ = 120
    m_Dav ->nDnyDoklad := IF( nDMZ = 120, anFPD[14], anFPD[3])
    m_Dav ->nHodDoklad := anFPD[5]

    m_Dav ->nDnyFondKD := m_Dav ->nDnyDoklad
    m_Dav ->nDnyFondPD := m_Dav ->nDnyDoklad
    m_Dav ->nHodFondKD := m_Dav ->nHodDoklad
    m_Dav ->nHodFondPD := m_Dav ->nHodDoklad

  CASE nDMZ = 127
    DO CASE
    CASE nTypAutGHM = 1
      m_Dav ->nSazbaDokl := fSazZAM( Date())[2]
      m_Dav ->nMnPDoklad := anFPD[5]
    OTHERWISE
      m_Dav ->nDnyDoklad := anFPD[3]
      m_Dav ->nHodDoklad := anFPD[5]
    ENDCASE

  CASE nDMZ = 150
    m_Dav ->nSazbaDokl := nTMPsazba
    m_Dav ->nMnPDoklad := fSazZAM( Date())[1] / 100


  CASE nDMZ = 156
    m_Dav ->nSazbaDokl := fSazZAM( Date())[3]
    m_Dav ->nMnPDoklad := anFPD[5]

  CASE nDMZ = 199
    m_Dav ->nDnyDoklad := anFPD[1]
    m_Dav ->nHodDoklad := anFPD[2]

    m_Dav ->nDnyFondKD := anFPD[3]
    m_Dav ->nHodFondKD := anFPD[4]

  OTHERWISE
    m_Dav ->nDnyDoklad := anFPD[1]
    m_Dav ->nHodDoklad := anFPD[2]
    m_Dav ->nMnPDoklad := anFPD[11]

    m_Dav ->nDnyFondKD := anFPD[3]
    m_Dav ->nHodFondKD := anFPD[4]

    m_Dav ->nDnyFondPD := anFPD[5]
    m_Dav ->nHodFondPD := anFPD[6]

    m_Dav ->nHodPresc  := anFPD[7]
    m_Dav ->nHodPripl  := anFPD[8]

  ENDCASE

  anX := fSAZBA( ( cFILE) ->nDruhMzdy, cFILE)
  VypocHm( anX, cFILE)
  IF m_Dav ->nDnyDoklad == 0 .AND. m_Dav ->nHodDoklad == 0        ;
       .AND. m_Dav ->nSazbaDokl == 0 .AND. m_Dav ->nMzda == 0
    DelREC( "M_Dav")
  ENDIF
  MsPrc_Mz ->( OrdSetFOCUS( cTagMSp))
  MsPrc_Mz ->( dbGoTo( nRecMSp))

RETURN( NIL)


*/

/*
STATIC FUNCTION AUTGenDOCH()
  LOCAL  nPOR
  LOCAL  anFND, aDNnem, aOST
  LOCAL  xKEYod, xKEYdo
  LOCAL  lOK, nZaklad
  LOCAL  dDatFirst
  LOCAL  dDatLast
  LOCAL  dDatOd, dDatDo

  DruhyMZD ->( OrdSetFOCUS( 1))

  M_Dav ->( dbSetRelation( 'DruhyMZD'  , ;
             { || M_Dav ->nDruhMzdy } , ;
                 'M_Dav ->nDruhMzdy'   ) )
  M_Dav ->( dbSkip( 0))

  dDatFirst := CtoD( "01/" +StrZero( ACT_OBDon(), 2) +"/"     ;
                             +StrZero( ACT_OBDyn(), 4))
  dDatLast  := CtoD( StrZero( LastDayOM( dDatFirst), 2) +"/"  ;
                             +StrZero( ACT_OBDon(), 2) +"/"     ;
                              +StrZero( ACT_OBDyn(), 4))

  IF Box_YesNo( "Vygenerovat data z modulu DOCHAZKA ") == 1
    TMPsumKON()
    C_Prerus ->( OrdSetFOCUS( 1))
    MsPrc_Mz ->( dbGoTop())
    TMp_OMETRp( .T.,, "Generov n¡ mezd z modulu DOCHAZKA...")
    TMp_OMETRp( 1, "MsPrc_Mz")

    DO WHILE !MsPrc_Mz ->( Eof())
      TMp_OMETRp( 0, "MsPrc_Mz")
      lOK := .F.
      dDatOd := IF( dDatFirst >= MsPrc_Mz ->dDatNast, dDatFirst, MsPrc_Mz ->dDatNast)
      IF ( dDatLast >= MsPrc_Mz ->dDatVyst .AND. MsPrc_Mz ->dDatVyst > dDatFirst) ;
                  .OR. Empty( MsPrc_Mz ->dDatVyst)
        lOK    := .T.
        dDatDo := IF( Empty( MsPrc_Mz ->dDatVyst), dDatLast, MsPrc_Mz ->dDatVyst)
      ENDIF
      M_Dav ->( OrdSetFOCUS(1))
      IF lOK .AND. TmpSumKo ->( dbSeek( MsPrc_Mz ->nOsCisPrac))               ;
              .AND. !M_Dav ->( dbSeek( ACT_OBDn()+StrZero( MsPrc_Mz ->nOsCisPrac)  ;                                                                                                        +StrZero( MsPrc_Mz ->nPorPraVzt)          ;                                                                                                          +StrZero( 800000 +MsPrc_Mz ->nOsCisPrac, 6)))
        nPOR  := 1
         anFND := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }



     ENDIF

     MsPrc_Mz ->( dbSkip())
   ENDDO
   TMp_OMETRp( -1)
 ENDIF

RETURN( NIL)





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

          ( ListIT->( dbSKIP()), nCount++ )
          nRemainder := nCount % 100
          if( nRemainder == 0, mzddavitx->( dbCOMMIT()), NIL )
        enddo

        mzddavitx->( dbCOMMIT(), dbgoTop())
        ListIT->( ads_clearaof())






*/