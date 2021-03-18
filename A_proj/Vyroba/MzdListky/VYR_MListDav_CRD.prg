
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* VYR_MListDAV_crd ... Hromadné poøízení ML
********************************************************************************
CLASS VYR_MListDAV_crd FROM drgUsrClass
EXPORTED:

  VAR     lNewRec, aForDEL, cNazOper, cfg_cStred, cfg_nCisOper, nCfg

  METHOD  Init, ItemMarked, drgDialogStart, drgDialogEnd, PostValidate, eventHandled
  METHOD  VyrZakIT_sel, PolOper_sel, GetCisOper
  METHOD  Save_ML
  METHOD  ebro_afterAppend, ebro_saveEditRow
  method  vyr_kmenove_sel

HIDDEN
  VAR     dm, dc, msg, broIT
  var     o_osCisPrac, o_cisOsoby
  var     firstDay

  METHOD  NewDavka, CtrlDavka, sumColumn, ExistOper, KcCMP
ENDCLASS

********************************************************************************
METHOD VYR_MListDAV_crd:init(parent)
  Local cFilter, cKey

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open( 'osoby',,,,,'osoby_s')
  osoby_s->(ads_setAof( 'nis_VYR = 1 .and. lstavem' ), dbgotop() )
  drgDBMS:open('prsmlDoh' )

  drgDBMS:open('ListHD'    )
  drgDBMS:open('PolOPER'   )
  drgDBMS:open('PolOPER',,,,,'POLOPERa' )
  drgDBMS:open('OPERACE'   )
  drgDBMS:open('C_Tarif'   )
  drgDBMS:open('MsPrc_MO'  )
  drgDBMS:open('MSPRC_MO',,,,,'MSPRC_mos')
  drgDBMS:open('C_Stred'   )
  drgDBMS:open('VyrZAK'    )
  drgDBMS:open('DRUHYMZD'  )
  drgDBMS:open('VyrZAKIT'  )
  drgDBMS:open('List_DAV'  )
  drgDBMS:open('List_DAVw'  ,.T.,.T.,drgINI:dir_USERfitm ); ZAP
  drgDBMS:open('List_DAVIw' ,.T.,.T.,drgINI:dir_USERfitm ); ZAP
  *
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  ::aForDEL := {}
  * do budoucna pøípadné parametry do cfg
  ::cfg_cStred   := '110' // pøednastavení støediska v hlavièce ML
  ::cfg_nCisOper := 10    // pøednastavení è.operace v položce ML
  *
  ::nCfg         := SysCONFIG( 'Vyroba:nMzdaZaKus')
  ::firstDay     := mh_FirstODate( uctOBDOBI:VYR:NROK, uctOBDOBI:VYR:NOBDOBI)
  *
  IF ::lNewREC
    List_DAVw->( dbAppend())
    List_DAVw->nRok       := uctOBDOBI:VYR:NROK
    List_DAVw->nObdobi    := uctOBDOBI:VYR:NOBDOBI
    List_DAVw->nDavka     := ::NewDavka()
    List_DAVw->nDoklad    := List_DAVw->nDavka
    List_DAVw->dDatPorDav := Date()
    List_DAVw->cStred     := ::cfg_cStred

    list_Davw->( dbcommit())
  ELSE
    mh_COPYFLD('LIST_DAV', 'LIST_DAVw', .T.)
    *
    drgDBMS:open('ListIT',,,,,'ListITa' )
    cFilter  := Format("ListITa->nDavka = %%", { List_DAV->nDavka })
    ListITa->( mh_SetFilter( cFilter))
    *
    Do While !ListITa->( Eof())
      mh_COPYFLD('LISTITa' , 'LIST_DAVIw', .T.)
      mh_COPYFLD('LIST_DAV', 'LIST_DAVIw', .F.)
      List_DAVIw->nHodiny  := ListITa->nNhNaOpeSk
      List_DAVIw->_nrecor  := ListITa->( RecNO())
      * plnìní z PolOper
      cKey := StrZero(ListITa->nRokVytvor,4)+ StrZero(ListITa->nPorCisLis,12)
      PolOPER->( dbSeek( cKey,, 'POLOPER5'))
      List_DAVIw->nCisOper := PolOPER->nCisOper
      List_DAVIw->cOznOper := PolOPER->cOznOper
      * Plnìní z Operace
      Operace->( dbSeek( Upper( PolOPER->cOznOper),, 'OPER1'))
      List_DAVIw->cNazOper := Operace->cNazOper

      ListITa->(dbSkip())
    EndDo
    ListITa->( dbCloseArea())

  ENDIF
  *
RETURN self

********************************************************************************
METHOD VYR_MListDAV_crd:drgDialogStart(drgDialog)
  *
  ::dm    := drgDialog:dataManager
  ::dc    := drgDialog:dialogCtrl
  ::msg   := drgDialog:oMessageBar
  ::broIT := ::dc:oaBrowse:oXbp
  *
  ::o_osCisPrac := ::dm:has('list_DAVw->nosCisPrac' )
  ::o_cisOsoby  := ::dm:has('list_DAVw->ncisOsoby'  )

  ColorOfTEXT( ::dc:members[1]:aMembers )
  *
  IsEditGET( {'List_DAVw->nCisOsoby' }, drgDialog, .f.)
  IsEditGET( {'LIST_DAVw->nDavka'    , 'List_DAVw->dDatPorDav',;
              'List_DAVw->nOsCisPrac', 'List_DAVw->nTarSazHod',;
              'List_DAVw->cStred'                             }, drgDialog, ::lNewREC)
  *
  IF ::lNewREC
    ::drgDialog:oForm:setNextFocus( 'LIST_DAVw->dDatPorDav',, .t. )
  ELSE
    SetAppFocus( ::broIT)
    ::broIT:refreshAll()
  ENDIF
  *
  ::sumColumn()

RETURN self

****************************************************************************
METHOD VYR_MListDAV_crd:eventHandled(nEvent, mp1, mp2, oXbp)
  Local nrecor, lOk

  DO CASE
   CASE nEvent = drgEVENT_SAVE
     ::Save_ML()
     lOK := .T.
   CASE nEvent = drgEVENT_DELETE
     IF drgIsYESNO(drgNLS:msg( 'Zrušit mzdový lístek [ & ] v dávce èíslo [ & ]  ?',;
                                LIST_DAVIw->nPorCisLis, LIST_DAVIw->nDavka ) )
       nrecor := LIST_DAVIw->_nrecor
       IF (nrecor = 0)
         * nový záznam, dosud neuložený v ListIT
         LIST_DAVIw->( dbDelete() )
       ELSE
         ListIT->( dbGoTO( nrecor))
         * existuje ListIT - musí být splnìny podmínky pro zrušení
         IF lOk := .t.  // podmínky
           LIST_DAVIw->( dbDelete() )
           aAdd( ::aForDEL, ListIT->( RecNo()) )
         ELSE
         * nelze zrusit ( tøeba je uzavøený )
         ENDIF
       ENDIF
       ::broIT:refreshAll()
     ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.
*

********************************************************************************
METHOD VYR_MListDAV_crd:itemMarked()
  Local cMsg :=  Alltrim( Str( LIST_DAVIw->( OrdKeyNO()))) + ' / ' + Alltrim( Str( LIST_DAVIw->( LastRec())))

  ::msg:writeMessage( cMsg)

  VyrZak->( dbSeek( Upper( LIST_DAVIw->cCisZakaz),,'VYRZAK1'))
  ListIT->( dbGoTo(List_DAVIw->_nrecor))

RETURN self

********************************************************************************
METHOD VYR_MListDAV_crd:ebro_afterAppend( ebro)

  ::dm:set('List_DAVIw->nOrdItem'  , List_DAVIw->( LastRec())+1 )
  ::dm:set('List_DAVIw->nCisOper'  , ::cfg_nCisOper )
  ::dm:set('List_DAVIw->dVyhotSkut', List_DAVw->dDatPorDAV )
  *
  if ! isNull(::cNazOper)
    ::dm:set('List_DAVIw->cNazOper', ::cNazOper )
  endif
RETURN self

********************************************************************************
METHOD VYR_MListDAV_crd:ebro_saveEditRow

  ::dm:save()
  mh_COPYFLD('LIST_DAVw', 'LIST_DAVIw', .F.)
  List_DAVIw->cCisZakaz  := PolOPER->cCisZakaz
  List_DAVIw->cCisZakazI := PolOPER->cCisZakazI
  List_DAVIw->nPorCisLis := PolOPER->nPorCisLis
  List_DAVIw->nRokVytvor := PolOPER->nRokVytvor
  List_DAVIw->nOrdItem   := IF( (List_DAVIw->_nrecor = 0), List_DAVIw->( LastRec()),;
                                                           List_DAVIw->nOrdItem )
  List_DAVIw->cVyrPol    := PolOPER->cVyrPol
  List_DAVIw->cOznOper   := PolOPER->cOznOper
  *
  Operace->( dbSeek( Upper( PolOPER->cOznOper),, 'OPER1'))
  List_DAVIw->cNazOper   := if( List_DAVIw->nCisOper = ::cfg_nCisOper, ::cNazOper, Operace->cNazOper )
  *
  List_DAVIw->nKusyHotov := List_DAVIw->nKusyCelk
  List_DAVIw->nHodiny    := List_DAVIw->nKusyCelk
  *
  ::sumColumn()
  *
RETURN .T.

********************************************************************************
METHOD VYR_MListDAV_crd:postValidate( oVar, a, b)
  Local xVar := oVAR:value, Name := oVar:Name, lOK := .T.
  Local nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)

  DO CASE
  CASE ( Name = 'List_DAVw->nDavka' )
    IF ( lOK := ControlDUE( oVar) )
      lOK := ::CtrlDavka( xVar)
    ENDIF

  CASE ( Name = 'List_DAVw->nOsCisPrac' )
    if list_DAVw->noscisPrac = 0 .and. list_DAVw->ncisOsoby = 0
     lok := ::vyr_kmenove_sel()
    endif

  CASE ( Name = 'List_DAVw->cStred' )
    If( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN .and. lOK)
      ::dm:save()
      SetAppFocus( ::broIT)
      PostAppEvent( xbeP_Keyboard, xbeK_INS,, ::broIT)
    EndIf
*
  CASE ( Name = 'List_DAVIw->cCisZakazI' )
    lOK := ::VyrZAKIT_sel()
    *
    if IsNull( ::cNazOper)
      cKey := Upper(xVar) + Upper( VyrZakIT->cVyrPol) + StrZero( ::cfg_nCisOper, 4)
      if PolOper->( dbSEEK( cKey,, 'POLOPER8'))
         Operace->( dbSeek( Upper( PolOPER->cOznOper),, 'OPER1'))
         ::cNazOper := Operace->cNazOper
         LIST_DAVIw->cNazOper := Operace->cNazOper
         ::dm:set('List_DAVIw->cNazOper', ::cNazOper )
       endif
    else
      cKey := Upper(xVar) + Upper( VyrZakIT->cVyrPol) + StrZero( ::dm:get('List_DAVIw->nCisOper'), 4)
      PolOper->( dbSEEK( cKey,, 'POLOPER8'))
      Operace->( dbSeek( Upper( PolOPER->cOznOper),, 'OPER1'))
    endif

    if !::ExistOper( 'POLOPERa')
      lOK := .f.
    endif
    *
  CASE ( Name = 'List_DAVIw->nCisOper' )
    lOK := ::PolOPER_sel()

  CASE ( Name = 'List_DAVIw->nKusyCelk' )

  ENDCASE

RETURN lOK

********************************************************************************
METHOD VYR_MListDAV_crd:drgDialogEnd(drgDialog)
*  List_DAVw->( dbCloseArea())
RETURN self

********************************************************************************
METHOD VYR_MListDAV_crd:Save_ML()
  Local lOkHD := .T., lSave := .T., cKey, nRecOr
  Local nCelkKusCa, nKCas, nKKc, nNm, aHdToCMP := {}
  Local nKusyHotov, nKcNaOpeSk, nNmNaOpeSk, nNhNaOpeSk, cTag

  IF drgIsYESNO(drgNLS:msg( 'Požadujete uložit tuto dávku ?' ) )
    List_DAVIw->( dbEVAL( {|| ;
                  cKey := StrZero(List_DAVIw->nRokVytvor,4)+ StrZero(List_DAVIw->nPorCisLis,12),;
                  lOkHD := if( ListHD->( dbSeek( cKey,,'LISTHD1')), lOkHD, .f.) }))
    IF !lOkHD
      IF drgIsYESNO(drgNLS:msg( 'K nìkterým lístkùm neexistují hlavièky !;;' + ;
                                'Požadujete pøesto uložit tuto dávku ?' ) )
      ELSE
        lSave := .F.
      ENDIF
    ENDIF
    *
    IF lSave
      * zápis hlavièky dávky List_DAV
      IF( ::lNewRec, nil, List_DAV->( RLock()) )
      mh_COPYFLD( 'List_DAVw' , 'List_DAV', ::lNewREC)
      List_DAV->( dbUnLock())
      * zápis položek dávky ListIT
      List_DAVIw->( dbGoTOP())
      DO WHILE ! List_DAVIw->( Eof())
        cKey := StrZero(List_DAVIw->nRokVytvor,4)+ StrZero(List_DAVIw->nPorCisLis,12)
        IF ListHD->( dbSeek( cKey,,'LISTHD1'))
          * Pole hlavièek ML, které se musí pøepoèítat, nebo v dávce vznikly nové položky
          IF( nPos := ASCAN( aHdToCMP, ListHD->( RecNo()) )) = 0
            AADD( aHdToCMP, ListHD->( RecNo()) )
          ENDIF
          *
          IF( ( nRecOr := List_DAVIw->_nrecor) = 0 )
*             ListIT->( dbAppend())
          ELSE
             ListIT->( dbGoTo( nRecOr))
          ENDIF
          ListIT->( RLock())

          mh_COPYFLD( 'List_DAVIw', 'ListIT', (nRecOr=0) )
          *
          cKey := Upper(ListHD->cCisZakaz)+ Upper(ListHD->cVyrPol) + ;
                  StrZero(List_DAVIw->nCisOper,4)
          PolOPER->( dbSeek( cKey,, 'POLOPER1'))
          Operace->( dbSeek( Upper( PolOper->cOznOper),, 'OPER1'))

          if .not. DRUHYMZD->( dbSEEK( StrZero(List_DAVIw->nRok,4)+                       ;
                                       StrZero(List_DAVIw->nObdobi,2)+                    ;
                                       StrZero(operace->nDruhMzdy,4),, 'DRUHYMZD04'))
            DRUHYMZD->( dbSEEK( StrZero( uctOBDOBI_LAST:MZD:NROK,4)+                      ;
                                StrZero( uctOBDOBI_LAST:MZD:NOBDOBI,2)+                   ;
                                StrZero(operace->nDruhMzdy,4),, 'DRUHYMZD04'))
          endif

          ListIT->nDruhMzdy  := Operace->nDruhMzdy
          ListIT->cTarifStup := Operace->cTarifStup
          ListIT->cTarifTrid := Operace->cTarifTrid
          ListIT->cStred     := Operace->cStred
          ListIT->cOznPrac   := Operace->cOznPrac
          ListIT->cPracZar   := Operace->cPracZar

          ListIT->nTarSazHod := fSazTar( List_DAVIw->dVyhotSkut)[1]
*        ListIT->nTarSazHod := fSazTar( ::dm:get('List_DAVIw->dVyhotSkut') )
          *
          nNm := IF( ::nCfg == 1,( ListHD->nKusovCas * ( ListIT->nKusyCelk - ListIT->nKusyVadne) ) ,;
                                 ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * ( ListIT->nKusyCelk - ListIT->nKusyVadne))

          ListIT->nNhNaOpePL := nNm / 60
          ListIT->nNmNaOpePL := nNm
          ListIT->nKcNaOpePL := ::KcCMP( 1 )
          *
          ListIT->nNhNaOpeSk := List_DAVIw->nHodiny
          ListIT->nNmNaOpeSk := List_DAVIw->nHodiny * 60
          ListIT->nKcNaOpeSk := ::KcCMP( 2 )
          *
          ListIT->cTypListku := 'DAV'
          ListIT->cPrijPrac  := MsPrc_MO->cPrijPrac
          ListIT->cJmenoPrac := MsPrc_MO->cJmenoPrac
          ListIT->cJmenoRozl := MsPrc_MO->cJmenoRozl
          *
          ListIT->cOznOper   := ListHD->cOznOper
          ListIT->cOznPrac   := ListHD->cOznPrac
          ListIT->cPracZar   := ListHD->cPracZar
          ListIT->cNazPol1   := List_DAV->cStred
          ListIT->cObdobi    := VYR_WhatOBD( .t.)

          ListIT->nRok       := Val( Left( Str( Year( ListIT->dVyhotSkut),4),2) + Right(ListIT->cObdobi,2))  // JT úprava
          ListIT->nObdobi    := Val( Left( ListIT->cObdobi,2)) // uctObdobi:VYR:nOBDOBI         // JT úprava

          *
          ListIT->nMzdaZaKus := IF( ::nCfg = 1, PolOper->nKcNaOper,;
                                                ListIT->nKcNaOpePL / ListIT->nKusyCelk )
          *
          VYR_StavLST()   //   ListIT->cStavListk := '5'
          *
          List_DAVIw->_nrecor := ListIT->( Recno())
          ListIT->( dbUnLock())
        ENDIF
        List_DAVIw->( dbSkip())
      ENDDO

      * zrušení položek dávky ListIT
      IF ListIT->( Sx_RLock( ::aForDEL))
        FOR x := 1 TO LEN(::aForDEL)
          ListIT->( dbGoTo( ::aForDEL[ x]), dbDelete())
        NEXT
        ListIT->( dbUnLock())
        ::aForDEL := {}
      ENDIF
      * Pøepoèet hlavièek ML
      IF ListHD->( Sx_RLock( aHdToCMP))
        cTag := ListIT->( OrdSetFocus( 'LISTIT1'))
        FOR x := 1 TO LEN(aHdToCMP)
          nKusyHotov := 0
          nKcNaOpeSk := 0
          nNmNaOpeSk := 0
          nNhNaOpeSk := 0
          ListHD->( dbGoTo( aHdToCMP[ x]))
          cKey := StrZero(ListHD->nRokVytvor,4)+ StrZero(ListHD->nPorCisLis,12)
          ListIT->( mh_SetScope( cKey) ,;
                    dbGoTOP(),;
                    dbEVAL( {|| nKusyHotov += ListIT->nKusyHotov    ,;
                                nKcNaOpeSk += ListIT->nKcNaOpeSk    ,;
                                nNmNaOpeSk += ListIT->nNmNaOpeSk    ,;
                                nNhNaOpeSk += ListIT->nNhNaOpeSk } ) )
          ListHD->nKusyHotov := nKusyHotov
          ListHD->nNmNaOpeSk := nNmNaOpeSk
          ListHD->nNhNaOpeSk := nNhNaOpeSk
          ListHD->nKcNaOpeSk := nKcNaOpeSk
          *
        NEXT
        ListHD->( dbUnLock())
        ListIT->( OrdSetFocus( cTag))
      ENDIF
      */
    ENDIF
    *
    drgMsgBox(drgNLS:msg( 'Dávka èíslo [ & ]  byla uložena ...', List_DAV->nDavka ) )
    *
    _clearEventLoop(.t.)
    PostAppEvent(xbeP_Close,drgEVENT_QUIT,, ::drgDialog:dialog)
  ENDIF
*
RETURN self

* Výpoèet KÈ   Plán / Skuteènost
** HIDDEN **********************************************************************
METHOD VYR_MListDAV_crd:KcCMP( nTypKC, nNewTarif)
  Local nKc := 0, nkS, nNh, nTarif, cDmz
  Local nSazPrePr := fSazZam('PRCPREHLCI', LISTIT->dVyhotSkut)

  cDmz := AllTrim( DruhyMzd->cTypDmz )
  If cDmz == 'UKOL'
     nKs := If( nTypKc = 1, LISTIT->nKusyCelk, LISTIT->nKusyHotov )
     nKc := List_DAVw->nTarSazHod * nKs
*     nKc := LISTIT->nMzdaZaKus * nKs

  ElseIf ( cDmz == 'CAS') .OR. ( cDmz == 'REZIE') .OR. ( cDmz == 'DOHODA' )
     nNh := If( nTypKc == 1, LISTIT->nNhNaOpePl, LISTIT->nNhNaOpeSk )
     IF IsNIL( nNewTarif)
        nTarif := IF( ::lNewREC, fSazTar( LISTIT->dVyhotSkut)[1], LISTIT->nTarSazHod )
        nKc := nTarif * ( nSazPrePr / 100 + 1 ) * nNh
     ELSE
        nKc := nNewTarif * ( nSazPrePr / 100 + 1 ) * nNh
     ENDIF

  ElseIf cDmz == 'PRESCAS'
//     nKc := MsPrc_M_D->nHodPresca *  nNh
  Endif
RETURN nKc


method VYR_MListDAV_crd:vyr_kmenove_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  local  lok := .f.
  *
  local  drgVar := ::o_osCisPrac
  local  value  := drgVar:get()
  local  recCnt := 0, showDlg := .f.
  local  cfiltr, in_file := 'osoby_s'


  if isObject(drgDialog)
    showDlg := .t.
  else
    osoby_s->( adsSetOrder( 'OSOBY03' )     , ;
               dbSetScope(SCOPE_BOTH, value), ;
               dbGoTop()                    , ;
               dbeval( {|| recCnt++ })      , ;
               dbgotop()                    , ;
               dbclearScope()                 )

    showDlg := .not. (recCnt = 1)
        lok :=       (recCnt = 1)
    if(recCnt = 0, osoby_s->(dbclearscope(),dbgotop()), nil)

    * musíme na prsmlDoh
    if lok
      cfiltr := Format("nOSOBY = %% .and. ( dDATVYST >= '%%' .or. dDATVYST = ''.or. dDATVYST = null )", ;
                      {isNull( osoby_s->sid, 0), ::firstDay} )
      prsmlDoh->( ads_setaof(cfiltr), dbGoTop())

      * musí mít prsmlDoh, jinak je to špatnì
      showDlg := prsmlDoh->(eof())

      prsmlDoh->( ads_clearAof())
    endif
  endif

  if showDlg
    in_file := 'osoby'
    DRGDIALOG FORM 'VYR_kmenove_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  *
  if .not. showDlg .or. ( nExit != drgEVENT_QUIT )
    lok := .t.

    ::dm:set( 'List_DAVw->nOsCisPrac', prsmlDoh->nOsCisPrac )
    ::dm:set( 'List_DAVw->nPorPraVzt', prsmlDoh->nPorPraVzt )
    ::dm:set( 'List_DAVw->nOsoby',     (in_file)->sID       )
    ::dm:set( 'List_DAVw->ncisOsoby',  (in_file)->ncisOsoby )
    ::dm:set( 'List_DAVw->cjmenoRozl', (in_file)->cjmenoRozl)
    *
    List_DAVw->nOsCisPrac := prsmlDoh->nOsCisPrac
    List_DAVw->nPorPraVzt := prsmlDoh->nPorPraVzt
    List_DAVw->nOsoby     := isNull( (in_file)->sID, 0)
    List_DAVw->ncisOsoby  := (in_file)->ncisOsoby
    List_DAVw->cjmenoRozl := (in_file)->cjmenoRozl

    lok := ( msprc_mos->( dbSeek( StrZero( uctOBDOBI:VYR:NROK, 4)          + ;
                                   StrZero( uctOBDOBI:VYR:NOBDOBI, 2)      + ;
                                    StrZero( prsmlDoh->nOsCisPrac, 5)      + ;
                                     StrZero( prsmlDoh->nPorPraVzt, 3),, 'MSPRMO01')) .or. ;
             msprc_mos->( dbSeek( StrZero( uctOBDOBI_LAST:MZD:NROK, 4)       + ;
                                   StrZero( uctOBDOBI_LAST:MZD:NOBDOBI, 2) + ;
                                    StrZero( prsmldoh->nOsCisPrac, 5)      + ;
                                     StrZero( prsmldoh->nPorPraVzt, 3),, 'MSPRMO01'))       )

    if lok
      msPrc_mo->( dbseek( isNull( msprc_mos->sID, 0),, 'ID'))

      ::dm:set( 'List_DAVw->nMsPrc_MO',  isNull( msprc_mos->sID, 0) )
      List_DAVw->nMsPrc_MO := isNull( msprc_mos->sID, 0)

      ::drgDialog:oForm:setNextFocus( 'List_DAVw->nCisOsoby',, .f. )
    endif
  endif
return lok


* Výbìr z položek výrobních zakázek
********************************************************************************
METHOD VYR_MListDAV_crd:VYRZAKIT_SEL( Dialog)
  LOCAL oDialog, nExit
  LOCAL cKey := Upper( ::dm:get('List_DAVIw->cCisZakazI')), Filter
  LOCAL lOK   // ( !Empty(cKey) .and. VYRZAKIT->( dbSEEK( cKey,, 'ZAKIT_4')) )

  * Vybrat lze pouze neukonèené položky zakázek
  Filter := FORMAT("(VyrZakIT->cStavZakaz <> '%%')", { 'U '} )
  VyrZakIT->( mh_SetFilter( Filter))
  lOK := ( !Empty(cKey) .and. VYRZAKIT->( dbSEEK( cKey,, 'ZAKIT_4')) )

  IF IsObject( Dialog) .or. ! lOk

    DRGDIALOG FORM 'VYR_VYRZAKIT_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF
  IF ( nExit != drgEVENT_QUIT )
    ::dm:set( 'List_DAVIw->cCisZakazI', VyrZakIT->cCisZAKAZI )
    ::dm:set( 'List_DAVIw->nCisOper'  , ::GetCisOper(VyrZakIT->nRezObd) )
    lOK := .T.
  ENDIF

  VyrZakIT->( mh_ClrFilter())

RETURN lOK

********************************************************************************
METHOD VYR_MListDAV_crd:GetCisOper( nRezObd)
  Local nCisOper, nMonth := Month(  ::dm:get('List_DAVIw->dVyhotSkut'))

  Do case
    case nRezObd = 0 .or. nRezObd = 1   // nedefinováno, rok
      nCisOper := 10
    case nRezObd = 2  // pololetí
      nCisOper := if( nMonth <= 6, 10, 20)
    case nRezObd = 3  // ètvrtletí
      nCisOper := if( nMonth <= 3, 10,;
                  if( nMonth <= 6, 20,;
                  if( nMonth <= 9, 30, 40)))
    case nRezObd = 4  //mìsíc
      nCisOper := 10 * nMonth
  EndCase

RETURN nCisOper

* Výbìr z operací pro danou položku výrobní zakázky
********************************************************************************
METHOD VYR_MListDAV_crd:POLOPER_SEL( Dialog)
  LOCAL oDialog, nExit, oMoment, nRec, lOK, Filter, cScopeTop, cScopeBot, cTag
  LOCAL cCisZakazI := Upper( ::dm:get('List_DAVIw->cCisZakazI')), cKey
  Local nCisOper  := ::dm:get('List_DAVIw->nCisOper')
  Local aRECs := {}
  *
  if !::ExistOper()
    Return .f.
  endif
  *
  nRec := PolOPER->( RecNO())
  *
  cKey := cCisZakazI + Upper( PolOper->cVyrPol) + StrZero( nCisOper, 4)

  lOK := ( !IsNull( nCisOper) .and. PolOper->( dbSEEK( cKey,, 'POLOPER8')) )

  IF IsObject( Dialog) .or. ! lOk

    DRGDIALOG FORM 'VYR_POLOPER_SEL2' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF
  IF ( nExit != drgEVENT_QUIT ) .or. lOK
    nRec := PolOPER->( RecNO())
    ::dm:set( 'List_DAVIw->nCisOper'  , PolOPER->nCisOper   )
    ::dm:set( 'List_DAVIw->nPorCisLis', PolOPER->nPorCisLis )
    ::dm:set( 'List_DAVIw->nRokVytvor', PolOPER->nRokVytvor )
    List_DAVIw->cOznOper   := PolOPER->cOznOper
    Operace->( dbSeek( Upper( PolOPER->cOznOper),, 'OPER1'))
    ::dm:set( 'List_DAVIw->cNazOper', Operace->cNazOper )

    ::drgDialog:oForm:setNextFocus( 'LIST_DAVIw->nKusyCelk',, .f. )
    *
    lOK := .T.
  ENDIF
  PolOper->( mh_ClrScope(), ORDSETFOCUS( cTag), dbGoTo( nRec))

RETURN lOK

** HIDDEN **********************************************************************
METHOD VYR_MListDAV_crd:NewDavka()
  Local  nNewDavka := 1

  drgDBMS:open('List_DAV' ,,,,, 'List_DAVa'  )
  List_DAVa->( dbGoBottom())
  nNewDavka := List_DAVa->nDavka + 1
  List_DAVa->( dbCloseArea())
RETURN nNewDavka

*HIDDEN*************************************************************************
METHOD VYR_MListDAV_crd:ctrlDavka( nDavka)
  Local lOK := YES

  drgDBMS:open( 'List_DAV',,,,, 'List_DAVa')
  IF( lOK := List_DAVa->( dbSeek( nDavka,, 'LISTDAV_01')))
    drgMsgBox(drgNLS:msg( 'Duplicitní èíslo dávky ...'))
  ENDIF
  lOK := !lOK
  List_DAVa->( dbCloseArea())
RETURN lOK

** HIDDEN **********************************************************************
METHOD VYR_MListDAV_crd:sumColumn()
  LOCAL nRec := LIST_DAVIw->( RecNo()), nHodinySUM := 0.00, nPos
  Local aItems, x

  LIST_DAVIw->( dbGoTOP(),;
                dbEVAL( {|| nHodinySUM += LIST_DAVIw->nHodiny  }) ,;
                dbGoTO( nRec) )
  aItems := { {'LIST_DAVIw->nHodiny', nHodinySUM } }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( ::dc:oBrowse[1]:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      ::broIT:getColumn( nPos):Footing:hide()
      ::broIT:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      ::broIT:getColumn( nPos):Footing:show()
    ENDIF
  NEXT

  ::dm:refresh()
RETURN self

** HIDDEN **********************************************************************
METHOD VYR_MListDAV_crd:ExistOper( cAlias)

  LOCAL cScopeTop, cScopeBot, cTag, lExist := .t.
  LOCAL cCisZakazI := Upper( ::dm:get('List_DAVIw->cCisZakazI')), cKey

  DEFAULT cAlias TO 'POLOPER'
  cTag := (cAlias)->( ORDSETFOCUS('POLOPER9'))
  cScopeTop := cCisZakazI + StrZero( 1, 12)
  cScopeBot := cCisZakazI + StrZero( 999999999999, 12)
  (cAlias)->( mh_SetScope( cScopeTop, cScopeBot))
  *
  IF EMPTY( (cAlias)->cCisZakazI )
    drgMsgBox(drgNLS:msg( 'K zakázce [ & ] neexistují operace ...', cCisZakazI ) )
    (cAlias)->( mh_ClrScope(), ORDSETFOCUS( cTag))
    lExist := .f.  // Return .F.
  ENDIF

RETURN lExist

*===============================================================================
FUNCTION ProcPrem( nOsCisPrac, dVyhotSKUT)
  Local cTAG, cKEY := RIGHT( StrZERO( nOsCisPrac ), 5 )
  Local nSazPrePr := 0, lExist := NO, dDatHLP := CTOD( '  .  .  ')

  drgDBMS:open('MsPrc_MO' )
  drgDBMS:open('MSSAZZAM' )

  cTAG := MSSAZZAM->( AdsSetOrder( 4))
  MSSAZZAM->( mh_SetScope( cKEY) )

  DO WHILE !MSSAZZAM->( EOF())
    IF ( MSSAZZAM->dPlatSazOd <= dVyhotSKUT .AND. dVyhotSKUT <= MSSAZZAM->dPlatSazDo ) .OR. ;
       ( MSSAZZAM->dPlatSazOd <= dVyhotSKUT .AND. EMPTY( MSSAZZAM->dPlatSazDo ) )
       IF dDatHLP <= MSSAZZAM->dPlatSazOd
          nSazPrePr := MSSAZZAM->nSazPrePr
          dDatHLP   := MSSAZZAM->dPlatSazOd
       ENDIF
       lExist := YES  // Existuje interval se sazbou premii
    ENDIF
    MSSAZZAM->( dbSKIP())
  ENDDO
  MSSAZZAM->( mh_ClrScope(), AdsSetOrder( cTAG))
  * Není-li sazba prémie v MSSAZZAM, bereme ji z MsPrc_M_D
  nSazPrePr := IF( lExist, nSazPrePr, MsPrc_MO->nSazPrePr )
RETURN nSazPrePr