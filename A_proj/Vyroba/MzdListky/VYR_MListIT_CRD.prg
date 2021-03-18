/*==============================================================================
  VYR_MListIT_CRD.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"

*  Typ poèítané hodnoty
# Define    PLAN       1   //  Kè Plán
# Define    SKUT       2   //  Kè Skuteènost

* Typ Druhu mzdy
# Define    UKOL        'UKOL'
# Define    CAS         'CASO'
# Define    REZIE       'REZI'
# Define    PRESCAS     'PRES'
# Define    DOHODA      'DOHD'

/*
listit.cstavListk
1 - pøi ruèním založení
2 - !Empty(dVyhotPlan) .and. Empty(nOsCisPrac)
3 - !Empty(dVyhotPlan) .and. !Empty(nOsCisPrac)
4 - ( nKusyHotov < nKusyCelk ) .and. nKusyHotov > 0
5 - ( nKusyHotov = nKusyCelk ) .and. nKusyHotov > 0
6 - ( nKusyKontr = nKusyCelk )
7 -

listit.cdruhListk
  -
1 - pøi zapuštìní zakázky do výroby generuje z polOper listhd a listit.cstavListk = 1
4 -
7 - pøi ruèním založeni listhd je ihned založek listit.cstavListk = 1
*/

STATIC sdVyhotML


********************************************************************************
*
********************************************************************************
CLASS VYR_MListIT_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC, lMLVykazat
  VAR     cTypML, nDrMZD, nCisML, dVyhotML, cDmz, procPremii

  METHOD  Init
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  Destroy
  method  vyr_kmenove_sel


HIDDEN
  VAR     dm, df, members
  var     pa_karOdVml, isEdit_tarSazHod, isEDit_nazPOL1, isEDit_nazPOL4

  var     o_osCisPrac, o_porPraVzt, o_cisOsoby, o_msprc_Mo
  var     firstDay
  VAR     nPlneniProc

  METHOD  PlneniProc, CastkaPripl
  METHOD  KcCMP
  METHOD  IsObd_Uzv, IsNULA_KcSK, CtrlHEAD


  inline access assign method cfile_Tar() var cfile_Tar
    return if( ::o_msPrc_mo:value <> 0, 'msPrc_moB', 'osoby_s' )


  inline method del_mzdDav()
    local cft := "nROK = %% .and. nOBDOBI = %% .and. nOSCISPRAC = %% .and. nPORPRAVZT = %% .and. nAUTOGEN = 5"
    local cfiltr

    drgDBMS:open('mzdDavhd')
    drgDBMS:open('mzdDavit')

    cfiltr := Format( cft, {listit->nROK, listit->nOBDOBI, listit->nOSCISPRAC, listit->nPORPRAVZT})

    * zrušíme minulý pøenos
    mzdDavhd->(ads_setaof(cfiltr), dbGoTop())
    do while .not. mzdDavhd->( EOF())
      if mzdDavhd->( dbRLock())
        mzdDavhd->( dbDelete(), dbUnlock())
      endif
      mzdDavhd->( dbSkip())
    enddo
    mzdDavhd->( ads_clearaof())

    mzdDavit->(ads_setaof(cfiltr), dbGoTop())
    do while .not. mzdDavit->( EOF())
      if mzdDavit->( dbRLock())
        mzdDavit->( dbDelete(), dbUnlock())
      endif
      mzdDavit->( dbSkip())
    enddo
    mzdDavit->( ads_clearaof())
  return self


  inline method refresh(drgVar)
    LOCAL  nIn, nFs, odrg
    LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
    //
    LOCAL  dc       := ::drgDialog:dialogCtrl
    LOCAL  dbArea   := ALIAS(dc:dbArea)

    for nIn := 1 to vars:size() step 1
      oVar := vars:getNth(nIn)

      if isBlock( ovar:block )
        xVal := eval( ovar:Block )

        if ovar:value <> xVal
          ovar:initValue := ovar:prevValue := ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    NEXT
  RETURN .T.

ENDCLASS

*
********************************************************************************
METHOD VYR_MListIT_CRD:init(parent)
  Local   nEvent,mp1,mp2,oXbp
  local   pa

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)

  ::drgUsrClass:init(parent)
*  IF mp1 = 'Vyr_ListIT_INFO'
  IF !IsNULL(mp1)
    IF lower( mp1) $ 'vyr_listit_info,oprava_ml'
      nEvent := drgEVENT_EDIT
    ENDIF
  ENDIF

  ::lNewREC    := !(nEvent = drgEVENT_EDIT)   //!( parent:cargo = drgEVENT_EDIT)
  ::lMLVykazat := .T.                         // zatím vždy umožníme ML vykázat
  ::nCisML     := ListHD->nPorCisLis
  ::dVyhotML   := sdVyhotML
  ::firstDay   := mh_FirstODate( uctOBDOBI:VYR:NROK, uctOBDOBI:VYR:NOBDOBI)
  ::procPremii := 0

  * pøednastavení z CFG
  ::pa_karOdVml := listAsArray( sysconfig( 'vyroba:ckarOdVml' ) )   // 0,0,0,0,0,0,0,0,0  0 - noEDit, 1- isEdit
  if( len(::pa_karOdVml) < 7, aadd( ::pa_karOdVml, '0'), nil )

             pa := listAsArray( sysconfig( 'vyroba:csazbaVml' ) )   // 0,0,0          1.- Nepoužívá se 2. - Používá se noEdit 3. - Používá se isEdit
  ::isEdit_tarSazHod := ( pa[3] = '1' )
             pa := listAsArray( sysconfig( 'vyroba:cstredVml' ) )   // - DTTO -
  ::isEDit_nazPOL1   := ( pa[3] = '1' )
             pa := listAsArray( sysconfig( 'vyroba:cediNakSml' ) )   // - editace nákladové struktury
//  ::isEDit_nazPOL1   := ( pa[1] = '1' )
//  ::isEDit_nazPOL2   := ( pa[2] = '1' )
//  ::isEDit_nazPOL3   := ( pa[3] = '1' )
  ::isEDit_nazPOL4   := ( pa[4] = '1' )
//  ::isEDit_nazPOL5   := ( pa[5] = '1' )
//  ::isEDit_nazPOL6   := ( pa[6] = '1' )

  drgDBMS:open('MsPrc_MO' )
  drgDBMS:open('Osoby'    )

  drgDBMS:open( 'msPrc_mo',,,,,'msPrc_moB')
  drgDBMS:open( 'osoby',,,,,'osoby_s')
  *
  ** základní filtr ...
  osoby_s->(ads_setAof( 'nis_VYR = 1 .and. ( lstavem = .t. .or. nis_EXT = 1 )'), dbgoTop() )

  drgDBMS:open('prsmlDoh' )
  drgDBMS:open('UCETSYS'  )
  drgDBMS:open('DRUHYMZD' )

  drgDBMS:open('LISTITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  VYR_MListIT_edit( self)

  osoby->( dbseek( listITw->ncisOsoby,, 'OSOBY01'))

  if .not. ::lNewREC

    if .not. msprc_mo->( dbSeek( StrZero( listITw->nrok, 4)          + ;
                                   StrZero( listITw->nobdobi, 2)      + ;
                                    StrZero( listITw->nOsCisPrac, 5)      + ;
                                     StrZero( listITw->nPorPraVzt, 3),, 'MSPRMO01'))

      msprc_mo->( dbSeek( StrZero( uctOBDOBI_LAST:MZD:NROK, 4)       + ;
                            StrZero( uctOBDOBI_LAST:MZD:NOBDOBI, 2) + ;
                             StrZero( listITw->nOsCisPrac, 5)      + ;
                              StrZero( listITw->nPorPraVzt, 3),, 'MSPRMO01'))
    endif

    if .not. msprc_moB->( dbSeek( StrZero( listITw->nrok, 4)          + ;
                                   StrZero( listITw->nobdobi, 2)      + ;
                                    StrZero( listITw->nOsCisPrac, 5)      + ;
                                     StrZero( listITw->nPorPraVzt, 3),, 'MSPRMO01'))

      msprc_moB->( dbSeek( StrZero( uctOBDOBI_LAST:MZD:NROK, 4)       + ;
                            StrZero( uctOBDOBI_LAST:MZD:NOBDOBI, 2) + ;
                             StrZero( listITw->nOsCisPrac, 5)      + ;
                              StrZero( listITw->nPorPraVzt, 3),, 'MSPRMO01'))
    endif

    ::procPremii := listitW->nsazPREpr  // fSazZam('PRCPREHLCI', LISTITw->dVyhotSKUT, 'msPrc_moB')
  endif

RETURN self


METHOD VYR_MListIT_CRD:drgDialogStart(drgDialog)
  local  isEdit_noscisPrac
  local  pa      := {}, x
  local  paEdits := { 'listitW->nMzdaZaKus', 'listitW->nKusyCelk' , 'listitW->nKusyHotov' , ;
                      'listitW->nKusyVadne', 'listitW->nNhNaOpeSk', 'listitW->nNmNaOpeSk' , ;
                      'listitW->nKcNaOpeSk'                                                 }

  ::dm          := ::drgDialog:dataManager
  ::df          := drgDialog:oForm                   // dialogForm
  ::members     := drgDialog:oForm:aMembers
  *
  ::o_osCisPrac := ::dm:has( 'listitw->nosCisPrac' )
  ::o_porPraVzt := ::dm:has( 'listitw->nporPraVzt' )
  ::o_cisOsoby  := ::dm:has( 'listitw->ncisOsoby'  )
  ::o_msprc_Mo  := ::dm:has( 'listitw->nmsprc_mo'  )

  IF ( 'INFO' $ UPPER( drgDialog:title) .OR. drgDialog:parent:dialogCtrl:isReadOnly )
     drgDialog:SetReadOnly( .T.)
  ENDIF
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  IsEditGET( { 'ListITw->nPorPraVzt',;
               'ListITw->cKmenStrPr',;
               'ListITw->nCisOsoby' ,;
               'ListITw->nNhNaOpePL',;
               'ListITw->nNmNaOpePL',;
               'ListITw->nKcNaOpePL',;
               'ListITw->nTydKapBlo',;
               'ListITw->nCisloKusu',;
               'ListITw->nKcOpePrip' }, drgDialog, .F. )

  isEdit_noscisPrac := ;
         if(       ::lnewRec, .t., ;
         if( .not. ::lnewRec .and. listITw->noscisPrac = 0 .and. .not. listITw->( eof()), .t., .f. ))
  IsEditGET( { 'ListITw->nosCisPrac' }, drgDialog, isEdit_noscisPrac )

  isEDitGet( { 'listitW->nTarSazHod' }, drgDialog, ::isEdit_tarSazHod )
  isEDitGet( { 'listitW->cnazPol1'   }, drgDialog, ::isEdit_nazPOL1   )
  isEDitGet( { 'listitW->cnazPol4'   }, drgDialog, ::isEdit_nazPOL4   )

  for x := 1 to len(::pa_karOdVml) step 1
    if ::pa_karOdVml[x]  = '0'
      aadd( pa, paEdits[x] )
    endif
  next
  isEditGet( pa, drgDialog, .f. )


  ::cDmz := AllTrim( DruhyMzd->cTypDmz )
  ::PlneniProc()

**  ::drgDialog:oForm:setNextFocus('ListITw->nOsCisPrac')
  ::drgDialog:oForm:setNextFocus('ListITw->dVyhotSkut')
RETURN self

*
********************************************************************************
METHOD VYR_MListIT_CRD:EventHandled(nEvent, mp1, mp2, oXbp)
  local  olastDrg := ::df:oLastDrg
  Local  cMsg, del_mzdDav := .f.

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    * Vyexportovaný lístek nelze opravit
    IF !::lNewREC .AND. !EMPTY( ListIT->dPrenos)
      cMsg := 'POZOR;;Lístek byl již pøenesen do mezd !'
      drgMsgBox(drgNLS:msg( cMsg ))

      del_mzdDav := .t.
    ENDIF

    /* Kontrola na povinné položky
    IF ( ( nSetPOS := NeedITEM( GetLIST)) > 0 )
       nStart := nSetPOS
       LOOP
    ENDIF
    */
    * Kontrola na uzavøení období ( export do mezd)
    /*
    IF ::IsOBD_Uzv( )
      RETURN .T.
    ENDIF
    */
    * Kontrola na nenulovost ceny operace
    IF ::IsNULA_KcSK()
       RETURN .T.
    ENDIF
    *
    IF ( lOK := ::CtrlHEAD() )
      VYR_MLISTIT_save( self)
      sdVyhotML := ::dVyhotML

      if( del_mzdDav, ::del_mzdDav(), nil )

      if ::lnewRec
        listitW->( dbZap())
        VYR_MListIT_edit( self)
        ::procPremii := 0

        ::refresh()

        ::cDmz := AllTrim( DruhyMzd->cTypDmz )
        ::PlneniProc()
        ::drgDialog:oForm:setNextFocus('ListITw->nOsCisPrac', .t., .t.)
        return .t.

      else
        PostAppEvent(xbeP_Close, nEvent,,oXbp)
        return .f.
      endif

    ENDIF

  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_MListIT_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-'), cKey, cTag
  Local  lSetCisOp := SysCONFIG( 'Vyroba:lSetCisOp')
  LOCAL  nRec, nVal := 1, nKCas, nKKc, nNm, nTarif, cMsg
  Local  nKusyCelk, cObdForML
  Local  nCfg := SysCONFIG( 'Vyroba:nMzdaZaKus')
  Local  aCfgKAR := ListAsARRAY( SysCONFIG( 'Vyroba:cKarOdvML'))
  Local  lCfg := SysCONFIG( 'Vyroba:lHODdleNH')
  *
  local  osCisPrac := ::dm:get('listitW->nosCisPrac')
  local  cisOsoby  := ::dm:get('listitW->ncisOsoby' )
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  if( .not. ::lNewREC .and. cisOsoby = 0, lValid := .t., nil)  // úprava 31.10.2017 JT

  aCfgKar := AEVAL( aCfgKar, {|X,i| aCfgKar[i] := (X = '1')} )

    DO CASE
    CASE cName = 'LISTITw->nDruhMzdy'
      ::cDmz := AllTrim( DruhyMzd->cTypDmz)

      If ::dm:get('LISTITw->nOsCisPrac') <> 0
        ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) )
      Endif

    CASE cName = 'LISTITw->nOsCisPrac'
      if ( oscisPrac = 0 .and. cisOsoby = 0 ) .or. lchanged
        lok := ::vyr_kmenove_sel()
      endif

      If lValid   //... 2.6.2004
**         IF EMPTY( MsPrc_MO->dDatVyst)
**            ::dm:set( 'LISTITw->nOsCisPrac', MsPrc_MO->nOsCisPrac )

        if ::cfile_Tar = 'msPrc_moB'
          if lOK .AND. !EMPTY( msPrc_moB->dDatVyst)
            if ::dm:get('LISTITw->dVyhotSKUT') > msPrc_moB->dDatVyst
              cMsg := 'Pracovník < & > má k vykázanému dni již ukonèen pracovní pomìr !'
              drgMsgBox(drgNLS:msg( cMsg, msPrc_moB->cJmenoRozl ))
              lOK := .F.
            endif
          endif
        endif

        if lOK
          nTarif := fSazTar( ::dm:get( 'LISTITw->dVyhotSkut'), ::cfile_Tar )[1]
          ::dm:set( 'LISTITw->nTarSazHod', nTarif )
          listitW->ntarSAZhod := ntarif

          ::procPremii := fSazZam('PRCPREHLCI',::dm:get('LISTITw->dVyhotSKUT'), 'msPrc_moB', ::o_osCisPrac:value, ::o_porPraVzt:value )
          ::dm:set( 'M->procPremii', ::procPremii )
          listitW->nsazPREpr := ::procPremii
          ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) )
        endif

**         ELSE
**            cMsg := 'Pracovník < & > má již ukonèen pracovní pomìr !'
**            drgMsgBox(drgNLS:msg( cMsg, MsPrc_MO->cJmenoRozl ))
**         ENDIF

      EndIf

      * 14.1.2003 ... Prunéøov
      IF lOK .and. ::lNewRec
         lOK := VYR_StredInCFG( (::cfile_Tar)->cKmenStrPr)
         IF !lOK
           cMsg := 'Kmenové støedisko pracovníka < & > není v konfiguraèním seznamu !'
           drgMsgBox(drgNLS:msg( cMsg, (::cfile_Tar)->cKmenStrPr ))
         ENDIF
      ENDIF

    CASE cName = 'LISTITw->nMzdaZaKus'
      IF lValid
        ::dm:set( 'LISTITw->nKcNaOpePL', ::KcCMP( PLAN) )
        IF( ::cDmz == UKOL, ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) ), NIL )
      ENDIF

    CASE cName = 'LISTITw->nKusyCelk'
      nNm := IF( nCfg == 1, ( ListHD->nKusovCas * ( xVar - ::dm:get('LISTITw->nKusyVadne') )) ,;
                            ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * ( xVar - ::dm:get('LISTITw->nKusyVadne') ) )
      ::dm:set( 'LISTITw->nNmNaOpePL', nNm )
      ::dm:set( 'LISTITw->nNhNaOpePL', nNm / 60 )
      ::dm:set( 'LISTITw->nKusyHotov', xVar )
      ::dm:set( 'LISTITw->nKusyVadne', 0 )
      * 27.1.2005
      IF lValid  ; ::dm:set( 'LISTITw->nKcNaOpePL', ::KcCMP( PLAN) )
                   ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) )
      ENDIF

    CASE cName = 'LISTITw->nKusyHotov'
      nKusyCelk := ::dm:get('LISTITw->nKusyCelk')
      IF ( lOK :=  xVar <= nKusyCelk )
        ::dm:set( 'LISTITw->nKusyVadne', nKusyCelk - xVar )
        IF lCfg
          nNm := IF( nCfg == 1, ( ListHD->nKusovCas * xVar ) ,;
                                ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * xVar )
          ::dm:set( 'LISTITw->nNmNaOpeSK', nNm )
          ::dm:set( 'LISTITw->nNhNaOpeSK', nNm / 60 )
        ENDIF
        ::dm:set( 'LISTITw->nKcNaOpePL', ::KcCMP( PLAN) )
        ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) )
      ELSE
        drgMsgBox(drgNLS:msg( 'Množství  HOTOVÉ  nesmí být vìtší než množství  CELKEM !' ))
      ENDIF

    CASE cName = 'LISTITw->nKusyVadne'
      nKusyCelk := ::dm:get('LISTITw->nKusyCelk')
      IF ( lOK := xVar <= nKusyCelk )
        ::dm:set( 'LISTITw->nKusyHotov', nKusyCelk - xVar )

        nNm := IF( nCfg == 1, ( ListHD->nKusovCas * ( nKusyCelk - xVar) ) ,;
                              ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * ( nKusyCelk - xVar) )
        ::dm:set( 'LISTITw->nNmNaOpePL', nNm )
        ::dm:set( 'LISTITw->nNhNaOpePL', nNm / 60 )
      ELSE
        drgMsgBox(drgNLS:msg( 'Množství  NESHODNÉ  nesmí být vìtší než množství  CELKEM !' ))
      ENDIF

    CASE cName = 'LISTITw->nNhNaOpePL'
      IF lValid
        ::dm:set( 'LISTITw->nNmNaOpePL', xVar * 60 )
        IF xVar <> 0
          ::dm:set( 'LISTITw->nKcNaOpePL', ::KcCMP( PLAN) )
          ::PlneniProc()
        ENDIF
      ENDIF

    CASE cName = 'LISTITw->nNhNaOpeSK'
      IF lValid
        ::dm:set( 'LISTITw->nNmNaOpeSK', xVar * 60 )
        IF xVar <> 0
          ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) )
          ::PlneniProc()
        ELSEIF !aCfgKAR[ 6]
          drgMsgBox(drgNLS:msg( 'Nutno vyplnit odpracovaný èas !' ))
        ENDIF
        ::CastkaPripl()
      ENDIF


    CASE cName = 'LISTITw->nNmNaOpePL'
      IF lValid ;  ::dm:set( 'LISTITw->nNhNaOpePL', xVar / 60 )
                   ::dm:set( 'LISTITw->nKcNaOpePL', ::KcCMP( PLAN) )
                   ::PlneniProc()
      ENDIF

    CASE cName = 'LISTITw->nNmNaOpeSK'
      IF lValid
        ::dm:set( 'LISTITw->nNhNaOpeSK', xVar / 60 )
        IF xVar <> 0
          ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) )
          ::PlneniProc()
         ELSE // IF !aCfgKAR[ 5]
          drgMsgBox(drgNLS:msg( 'Nutno vyplnit odpracovaný èas !' ))
         ENDIF
         ::CastkaPRIPL()
      ENDIF

    CASE cName = 'LISTITw->dVyhotSkut'
      IF lValid
        IF !Empty( xVar )
          cObdForML := uctObdobi:VYR:cOBDOBI   // SysCONFIG( 'Vyroba:cObdForML')
          lOK := uctObdobi:VYR:nOBDOBI == MONTH( xVar ) .AND. ;
                 uctObdobi:VYR:nROK == YEAR( xVar )
          IF !lOK
            cMsg := 'CHYBNÉ DATUM;;Poøizujete mimo nastavené období < & >;;' + ;
                    'Požadujete zápis ?'
            lOK := drgIsYESNO(drgNLS:msg( cMsg, cObdForML) )
          ENDIF
          IF lOK
            ::dm:set( 'LISTITw->nTydKapBlo', mh_WEEKofYear( xVar) )

            if ::lNewREC
              nTarif := fSazTar(  xVar, ::cfile_Tar )[1]
              ::dm:set( 'LISTITw->nTarSazHod', nTarif )
              listitW->ntarSAZhod := ntarif

              ::procPremii := fSazZam('PRCPREHLCI', xVar, 'msPrc_moB', ::o_osCisPrac:value, ::o_porPraVzt:value )
              ::dm:set( 'M->procPremii', ::procPremii )
              listitW->nsazPREpr := ::procPremii
            endif

            ::dm:set( 'LISTITw->nKcNaOpePL', ::KcCMP( PLAN) )
            ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT) )
          ENDIF
          *
          if ::cfile_Tar = 'msPrc_moB'
            IF lOK .AND. !EMPTY( msPrc_moB->dDatVyst)
              IF xVar > msPrc_moB->dDatVyst
                cMsg := 'Pracovník < & > má k vykázanému dni již ukonèen pracovní pomìr !'
                drgMsgBox(drgNLS:msg( cMsg, msPrc_moB->cJmenoRozl ))
                lOK := .F.
              ENDIF
            ENDIF
          endif

        ENDIF
      ENDIF

    CASE cName = 'LISTITw->nCisloKusu'
      IF ( xVar < 0 )
        drgMsgBox(drgNLS:msg( 'Èíslo kusu musí být kladné !' ))
        RETURN .F.
      ENDIF
      IF( xVar > VyrZAK->nMnozPlano )
        cMsg := 'Èíslo kusu nesmí být vìtší než množství plánované !;;' + ;
                'Množství plánované = < & >'
        drgMsgBox(drgNLS:msg( cMsg, VyrZAK->nMnozPlano ))
        RETURN .F.
      ENDIF

    CASE cName = 'LISTITw->nTarSazHod'
      IF lValid
        listitW->ntarSAZhod := xvar

        ::dm:set( 'LISTITw->nKcNaOpePL', ::KcCMP( PLAN, xVar) )
        ::dm:set( 'LISTITw->nKcNaOpeSK', ::KcCMP( SKUT, xVar) )
      ENDIF

    CASE cName = 'LISTITw->cKodPripl'
      ::dm:set( 'LISTITw->nKcOpePrip', ::dm:get( 'LISTITw->nNhNaOpeSK') * C_Pripl->nHodPripl )

  ENDCASE
  *
  * položku ukládáme na každém prvku
  if( oVar:changed() .and. lok, oVar:save(), nil )

  if( lok .and. cName = 'LISTITw->cKodPripl' )
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
    endif
  endif

RETURN lOK

*
*******************************************************************************
METHOD VYR_MListIT_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC     := ;
  ::lMLVykazat  := ;
  ::cTypML := nDrMZD := nCisML := ;
  ::dVyhotML    := ;
                   Nil
  ListITw->( dbCloseArea())
RETURN self


method VYR_MListIT_CRD:vyr_kmenove_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  local  lok := .f.
  *
  local  drgVar    := ::o_osCisPrac
  local  value     := drgVar:get()
  local  recCnt    := 0, showDlg := .f., recNo, cky
  local  osCisPrac := 0, in_prSmlDoh := .f.
  local  cfiltr, in_file := 'osoby_s'

  * ncisOsoby  tag OSOBY01
  * nosCisPrac tag OSOBY03

  if isObject(drgDialog) .or. value = 0
    showDlg := .t.
  else

    if osoby_s->( dbseek( value,, 'OSOBY03' ))
      osCisPrac := osoby_s->nosCisPrac
            lok := .t.
          recNo := osoby_s->( recNo())

      if osoby_s->( dbseek( value,, 'OSOBY01' )) .and. usrIDdb <> 110801

         ( lok := .f., showDlg := .t. )
      else
        osoby_s->( dbgoTo(recNo))
      endif

    else
      if osoby_s->( dbseek( value,, 'OSOBY01' ))
        osCisPrac := osoby_s->nosCisPrac
              lok := .t.
      else
         ( lok := .f., showDlg := .t. )
      endif
    endif

    * musíme na prsmlDoh
    if lok
      cfiltr := Format("nosCisPrac = %% .and. ( dDATVYST >= '%%' .or. dDATVYST = ''.or. dDATVYST = null )", ;
                      { osCisPrac, ::firstDay} )
      prsmlDoh->( ads_setaof(cfiltr), dbGoTop())

      * musí   mít prsmlDoh, jinak je to špatnì
      * nemusí jedná se o externí pracovníky ve výrobì nosCisPrac = 0
*      showDlg := prsmlDoh->(eof())
      in_prSmlDoh := .not. prsmlDoh->(eof())
      prsmlDoh->( ads_clearAof())
    endif
  endif

  if showDlg
    in_file := 'osoby'
    DRGDIALOG FORM 'VYR_kmenove_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
    in_prSmlDoh := .not. prsmlDoh->(eof())
  endif

  *
  if .not. showDlg .or. ( nExit != drgEVENT_QUIT )
    lok := .t.

    if in_prSmlDoh
      ::dm:set( 'ListITw->nOsCisPrac', prsmlDoh->nOsCisPrac )
      ::dm:set( 'ListITw->nPorPraVzt', prsmlDoh->nPorPraVzt )
    else
      ::dm:set( 'ListITw->nOsCisPrac', (in_file)->nOsCisPrac )
      ::dm:set( 'ListITw->nPorPraVzt', (in_file)->nPorPraVzt )
    endif

    ::dm:set( 'ListITw->nOsoby',     isNull( (in_file)->sID, 0) )
    ::dm:set( 'ListITw->ncisOsoby',  (in_file)->ncisOsoby )
    ::dm:set( 'ListITw->cjmenoRozl', (in_file)->cjmenoRozl)
    ::dm:set( 'ListITw->ckmenstrpr', (in_file)->ckmenstrpr)
    ::dm:set( 'LISTITw->cNazPol1',   (in_file)->cNazPol1  )
    ::dm:set( 'LISTITw->cNazPol4',   (in_file)->cNazPol4  )

    cky := strZero( ::o_osCisPrac:value, 5) +strZero( ::o_porPraVzt:value, 3)

    if ( msprc_mob->( dbSeek( StrZero( uctOBDOBI:VYR:NROK, 4)        + ;
                              StrZero( uctOBDOBI:VYR:NOBDOBI, 2)     + ;
                              cky,, 'MSPRMO01') ) .or.                 ;
         msprc_mob->( dbSeek( StrZero( uctOBDOBI_LAST:MZD:NROK, 4)   + ;
                              StrZero( uctOBDOBI_LAST:MZD:NOBDOBI, 2)+ ;
                              cky,, 'MSPRMO01') )                      )

      ::dm:set( 'listitW->nmsPrc_mo',  isNull( msprc_mob->sID, 0) )
    endif

    ::drgDialog:oForm:setNextFocus( 'listitW->nMzdaZaKus',, .f. )
  endif
return lok


*** HIDDEN
* Výpoèet  procent plnìní na základì NhPl a NhSk
** HIDDEN **********************************************************************
METHOD VYR_MListIT_CRD:PlneniProc()

  ::dm:set( 'M->nPlneniProc',;
           ( ::dm:get('LISTITw->nNhNaOpePL') / ::dm:get('LISTITw->nNhNaOpeSK')) * 100  )
RETURN self

* Výpoèet èástky pøíplatku
** HIDDEN **********************************************************************
METHOD VYR_MListIT_CRD:CastkaPripl()
 LOCAL nHodPripl := 0, cKodPripl := ::dm:get('LISTITw->cKodPripl')

  IF !EMPTY( cKodPripl)
    c_Pripl->( dbSEEK( Upper( cKodPripl)))
    nHodPripl := c_Pripl->nHodPripl
    ::dm:set( 'LISTITw->nKcOpePrip', ::dm:get('LISTITw->nNhNaOpeSK')* nHodPripl )
  ENDIF
RETURN self

* Výpoèet KÈ   Plán / Skuteènost
** HIDDEN **********************************************************************
method VYR_MListIT_CRD:KcCMP( nTypKC, nNewTarif)
  Local nKc := 0, nkS, nNh
  local ntarif    := listitW->ntarSAZhod
  Local nsazPREpr := listitW->nsazPREpr

  ::cDmz := AllTrim( DruhyMzd->cTypDmz )

  if ::cDmz == UKOL
    nKs := if( nTypKc == PLAN, ::dm:get('LISTITw->nKusyCelk' ), ::dm:get('LISTITw->nKusyHotov') )
    nKc := ::dm:get('LISTITw->nMzdaZaKus') * nKs

  elseIf ( ::cDmz == CAS) .OR. ( ::cDmz == REZIE) .OR. ( ::cDmz == DOHODA )
    nNh := if( nTypKc == PLAN, ::dm:get('LISTITw->nNhNaOpePl' ), ::dm:get('LISTITw->nNhNaOpeSk') )
    nKc := ntarif * ( nsazPREpr / 100 + 1 ) * nNh

  elseIf ::cDmz == PRESCAS
//     nKc := MsPrc_M_D->nHodPresca *  nNh
  endIf
return nKc

/*
METHOD VYR_MListIT_CRD:KcCMP( nTypKC, nNewTarif)
  Local nKc := 0, nkS, nNh, nTarif
  Local nSazPrePr := fSazZam('PRCPREHLCI',::dm:get('LISTITw->dVyhotSKUT'), 'msPrc_moB')

  ::cDmz := AllTrim( DruhyMzd->cTypDmz )

  If ::cDmz == UKOL
     nKs := If( nTypKc == PLAN, ::dm:get('LISTITw->nKusyCelk' ),;
                                ::dm:get('LISTITw->nKusyHotov') )
     nKc := ::dm:get('LISTITw->nMzdaZaKus') * nKs

  ElseIf ( ::cDmz == CAS) .OR. ( ::cDmz == REZIE) .OR. ( ::cDmz == DOHODA )
     nNh := If( nTypKc == PLAN, ::dm:get('LISTITw->nNhNaOpePl' ),;
                                ::dm:get('LISTITw->nNhNaOpeSk' ) )
     IF IsNIL( nNewTarif)
        nTarif := IF( ::lNewREC, fSazTar( ::dm:get('LISTITw->dVyhotSkut'), ::cfile_Tar )[1],;
                                 ::dm:get('LISTITw->nTarSazHod' ) )
        nKc := nTarif * ( nSazPrePr / 100 + 1 ) * nNh
     ELSE
        nKc := nNewTarif * ( nSazPrePr / 100 + 1 ) * nNh
     ENDIF

  ElseIf ( ::cDmz == REZIE)
     nKc := MsPrc_M_D->nHodTarSml * ( MsPrc_M_D->nSazPrePr / 100 + 1 ) * nNh

  ElseIf ::cDmz == PRESCAS
//     nKc := MsPrc_M_D->nHodPresca *  nNh
  Endif
RETURN nKc
*/


*
** HIDDEN **********************************************************************
METHOD VYR_MListIT_CRD:IsOBD_Uzv()
  Local dDatSk := ::dm:get('LISTITw->dVyhotSkut')
  Local cOBDOBI := STRZERO( MONTH( dDatSK), 2)
  Local cROK := STRZERO( YEAR( dDatSK), 4 )
  Local cKEY := UPPER( 'D') + cROK + cOBDOBI, lOK := NO
  Local cObdForML := uctObdobi:VYR:cOBDOBI  // SysConfig( 'Vyroba:cObdForML')
  Local lOKobd, cMsg

  IF UcetSYS->( dbSEEK( cKEY,,'UCETSYS3')) .AND. UcetSYS->lZavren
    cMsg := 'NELZE ULOŽIT;;Datum vyhotovení lístku spadá do uzavøeného období,;' + ;
                           'tj. probìhl export daného období !'
    drgMsgBox(drgNLS:msg( cMsg ))
    lOK := YES
  ELSE
    lOKobd := uctObdobi:VYR:nOBDOBI == MONTH( dDatSk ) .AND. ;
              uctObdobi:VYR:nROK == YEAR( dDatSk )
    IF !lOKobd
      cMsg := 'Chybné datum;;Poøizujete mimo nastaveného období [ & ].;' + ;
              'Požadujete zápis ?'
      If drgIsYesNo(drgNLS:msg( cMsg, cObdForML ))
        lOK := NO
      ENDIF
    ENDIF
  ENDIF

RETURN lOK

*
** HIDDEN **********************************************************************
METHOD VYR_MListIT_CRD:IsNULA_KcSK()
  Local nKcNaOpeSk := ::dm:get('LISTITw->nKcNaOpeSk')
  Local nDruhMzdy  := ::dm:get('LISTITw->nDruhMzdy')
  Local nChoice, nREC := DruhyMzd->( RecNO()), cTypDmz, lOK := NO
  Local cMsg := 'Cena operace je nulová;;' + ;
                'K pracovníkovi není nastavena sazba, tarif nebo stupnice.;' + ;
                'Požadujete zápis lístku ?'

  if nKcNaOpeSK = 0
    if .not. DRUHYMZD->( dbSEEK( StrZero(ListITw->nRok,4)+                       ;
                                 StrZero(ListITw->nObdobi,2)+                    ;
                                 StrZero(ListITw->nDruhMzdy,4),, 'DRUHYMZD04'))
      DRUHYMZD->( dbSEEK( StrZero( uctOBDOBI_LAST:MZD:NROK,4)+                      ;
                          StrZero( uctOBDOBI_LAST:MZD:NOBDOBI,2)+                   ;
                          StrZero(operace->nDruhMzdy,4),, 'DRUHYMZD04'))
    endif

    cTypDmz := UPPER( DruhyMzd->cTypDmz)
    if cTypDmz <> 'PODM'
      if drgIsYesNo(drgNLS:msg( cMsg ))
        lOK := NO
      endif
    endif
    DruhyMzd->(  dbGoTO( nREC) )
  endif
RETURN lOK

*  Kontrola na PLÁN v hlavièce ML oproti SKUTEÈNOSTI v položkách ML
** HIDDEN **********************************************************************
METHOD VYR_MListIT_CRD:CtrlHEAD()
  Local  aS := { 0, 0, 0 }, nRec := ListIT->( RecNo())
  Local  cKey, cTyp, cVar, cText := '', acText, lOK := YES
  Local  nHlp, nPos
  Local  alCFG := ListAsArray( AllTrim( SysConfig( 'Vyroba:cKonVykNOR')))

  alCfg := AEVAL( alCfg, {|X,i| alCfg[i] := (X = '1')} )
  /*
  IF lScr  ;  FOrdREC( { 'ListIT, 2' } )
              cKey := StrZERO( ListHD->nPorCisLis)
              SetSCOPE( 'ListIT', cKey )
  ENDIF
  */

IF ( alCFG[ 1] .or. alCFG[ 2] .or. alCFG[ 3] )

  ListIT->( dbGoTOP())
  ListIT->( dbEVAL( { || cTyp := UPPER( LEFT( ListIT->cTypListku, 1)),;
            IF( ::lNewRec .or. ( !::lNewRec .and. ListIT->( RecNO()) <> nRec),;
            IF( cTyp $ 'VR', NIL,;
               ( aS[ 1] += ListIT->nKusyHotov ,;
                 aS[ 2] += ListIT->nNhNaOpeSk ,;
                 aS[ 3] += ListIT->nKcNaOpeSk  )), NIL ) }))
  ListIT->( dbGoTO( nREC))
  cTyp := UPPER( LEFT( ::dm:get('LISTITw->cTypListku'), 1))

  IF !( cTyp $ 'VR')  // Vícepráce, Rùzné
    aS[ 1] += ::dm:get('LISTITw->nKusyHotov')
    aS[ 2] += ::dm:get('LISTITw->nNhNaOpeSk')
    aS[ 3] += ::dm:get('LISTITw->nKcNaOpeSk')
    * Kontrola na Kusy hotové
    IF ListHD->nKusyCelk < aS[ 1] .AND. alCFG[ 1]
      cVar  :=  Str( aS[ 1] - ListHD->nKusyCelk, 11, 2 )
      cText += 'Nelze vykázat o ' + cVar + ' vìtší množství než je plán !'
    ENDIF
    * Kontrola na Normohodiny skuteèné
    nPos := AT( '.', Str( aS[ 2]) )
    nHlp := VAL( SubStr( Str( aS[ 2] ), 1, nPos+4 ) )
    IF ListHD->nNhNaOpePl < nHlp .AND. alCFG[ 2] //   aS[ 2]
      cVar  := Str( aS[ 2] - ListHD->nNhNaOpePl, 10, 4 )
      cText += If( Empty( cText), '', ';') + 'Nelze vykázat o ' + cVar + '  Nh více než je plán !'
    ENDIF
    * Kontrola na èástku skuteènou
    nPos := AT( '.', Str( aS[ 3]) )
    nHlp := VAL( SubStr( Str( aS[ 3] ), 1, nPos+3 ) )
    IF ListHD->nKcNaOpePl < nHlp .AND. alCFG[ 3] //   aS[ 3]
      cVar  := Str( aS[ 3] - ListHD->nKcNaOpePl, 11, 3 )
      cText += If( Empty( cText), '', ';') + 'Nelze vykázat o ' + cVar + ' Kè více než je plán !'
    ENDIF
    IF !EMPTY( cText)
*       acText := If( ';' $ cText, ListAsArray( cText, ';'), cText )
       drgMsgBox(drgNLS:msg( cText ))
*       BOX_ALERT( cEM, acText, acWAIT )
       lOK := NO
    ENDIF
  ENDIF
*  IF( lScr, ( ClrSCOPE( 'ListIT'), FOrdREC() ), NIL )
ENDIF

RETURN lOK

/*
//ÄÄÄÄÄ< Kontrola na PLµN v hlaviŸce ML oproti SKUTE¬NOSTI v polo§k ch ML
FUNCTION CtrlHEAD( G )
  Local  aS := { 0, 0, 0 }, nRec := ListIT->( RecNo())
  Local  cKey, cTyp, cVar, cText := '', acText, lOK := YES
  Local  nHlp, nPos
  Local  alCFG := GetCFG( 'cKonVykNOR')

  IF lScr  ;  FOrdREC( { 'ListIT, 2' } )
              cKey := StrZERO( ListHD->nPorCisLis)
              SetSCOPE( 'ListIT', cKey )
  ENDIF
  ListIT->( dbGoTOP())
  ListIT->( dbEVAL( { || cTyp := UPPER( LEFT( ListIT->cTypListku, 1)),;
            IF( lNewRec .or. ( !lNewRec .and. ListIT->( RecNO()) <> nRec),;
            IF( cTyp $ 'VR', NIL,;
               ( aS[ 1] += ListIT->nKusyHotov ,;
                 aS[ 2] += ListIT->nNhNaOpeSk ,;
                 aS[ 3] += ListIT->nKcNaOpeSk  )), NIL ) }))
  ListIT->( dbGoTO( nREC))
  cTyp := UPPER( LEFT( G[ TypML]:VarGET(), 1))

  IF !( cTyp $ 'VR')  //Ä V¡cepr ce, RuŸn¡
    aS[ 1] += G[ KsHOT]:VarGET()
    aS[ 2] += G[  NhSK]:VarGET()
    aS[ 3] += G[  KcSK]:VarGET()
    //ÄÄ Kontrola na Kusy hotov‚
    IF ListHD->nKusyCelk < aS[ 1] .AND. alCFG[ 1]
      cVar  :=  Str( aS[ 1] - ListHD->nKusyCelk, 11, 2 )
      cText += 'Nelze vyk zat o ' + cVar + ' vØtç¡ mno§stv¡ ne§ je pl n !'
    ENDIF
    //ÄÄ Kontrola na Normohodiny skuteŸn‚
    nPos := AT( '.', Str( aS[ 2]) )
    nHlp := VAL( SubStr( Str( aS[ 2] ), 1, nPos+4 ) )
    IF ListHD->nNhNaOpePl < nHlp .AND. alCFG[ 2] //   aS[ 2]
      cVar  := Str( aS[ 2] - ListHD->nNhNaOpePl, 10, 4 )
      cText += If( Empty( cText), '', ';') + 'Nelze vyk zat o ' + cVar + '  Nh v¡ce ne§ je pl n !'
    ENDIF
    //ÄÄ Kontrola na ¬ stku skuteŸnou
    nPos := AT( '.', Str( aS[ 3]) )
    nHlp := VAL( SubStr( Str( aS[ 3] ), 1, nPos+3 ) )
    IF ListHD->nKcNaOpePl < nHlp .AND. alCFG[ 3] //   aS[ 3]
      cVar  := Str( aS[ 3] - ListHD->nKcNaOpePl, 11, 3 )
      cText += If( Empty( cText), '', ';') + 'Nelze vyk zat o ' + cVar + ' KŸ v¡ce ne§ je pl n !'
    ENDIF
    IF !EMPTY( cText)
       acText := If( ';' $ cText, ListAsArray( cText, ';'), cText )
       BOX_ALERT( cEM, acText, acWAIT )
       lOK := NO
    ENDIF
  ENDIF
  IF( lScr, ( ClrSCOPE( 'ListIT'), FOrdREC() ), NIL )
RETURN( lOK)

*/