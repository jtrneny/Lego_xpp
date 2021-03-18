
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\HIM\HIM_HIM.ch"

********************************************************************************
*
********************************************************************************
CLASS HIM_Main

EXPORTED:
  VAR     isHIM, fiMAJ, fiMAJ_ps, fiZMAJU, fiZMAJUw, fiZMAJN, fiSUMMAJ, fiCIS
  VAR     fiUMAJ, fiDMAJ, fiMAJOBD, fiRokUZV
  METHOD  Init, Destroy, Maj_INFO

ENDCLASS

********************************************************************************
METHOD HIM_Main:init(parent, isHIM)

  DEFAULT isHIM TO .T.
  ::isHIM    := isHIM
  ::fiMAJ    := IF( ::isHIM, 'MAJ'     , 'MAJZ'    )
  ::fiMAJ_ps := IF( ::isHIM, 'MAJ_PS'  , 'MAJZ_PS' )
  ::fiZMAJU  := IF( ::isHIM, 'ZMAJU'   , 'ZMAJUZ'  )
  ::fiZMAJN  := IF( ::isHIM, 'ZMAJN'   , 'ZMAJNZ'  )
  ::fiSUMMAJ := IF( ::isHIM, 'SUMMAJ'  , 'SUMMAJZ' )
  ::fiCIS    := 'C_TypPOH'
  ::fiUMAJ   := IF( ::isHIM, 'UMAJ'    , 'UMAJZ'   )
  ::fiDMAJ   := IF( ::isHIM, 'DMAJ'    , 'DMAJZ'   )
  ::fiRokUZV := IF( ::isHIM, 'RokUZV'  , 'RokUZVZ' )
  ::fiMAJOBD := IF( ::isHIM, 'MAJOBD'  , 'MAJZOBD' )
  ::fiZMAJUw := ::fiZMAJU + 'w'

RETURN self

********************************************************************************
METHOD HIM_Main:destroy()
  ::isHIM  := ::fiMAJ  := ::fiZMAJU  := ::fiZMAJN  := ::fiSUMMAJ := ::fiCIS := ;
  ::fiUMAJ := ::fiDMAJ := ::fiRokUZV := ::fiZMAJUw := ::fiMAJ_ps := ::fiMAJOBD := ;
  NIL
RETURN self

********************************************************************************
METHOD HIM_Main:MAJ_Info( oDialog, cFile)
  LOCAL cKEY

  drgDBMS:open( ::fiMAJ)
  cKEY :=  IF( ::isHIM, StrZero( (cFile)->nTypMaj,3), StrZero( (cFile)->nUcetSkup,3) ) + ;
                        StrZero( (cFile)->nInvCis, 15)

  ( ::fiMAJ)->( dbSEEK( cKEY,, AdsCtag(1)))
  HIM_MAJ_INFO( oDialog)
RETURN self

* V�po�et % z hodnoty
*===============================================================================
FUNCTION ValToPerc( nTotal, nVal, nAlgor)
  Local nPerc
  Default nAlgor To 0

  nPerc := nVal / ( nTotal / 100 )
  nPerc := IF( nAlgor = 0, nPerc, mh_RoundNumb( nPerc, nAlgor ) )
RETURN( nPerc)

* V�po�et hodnoty z %
*===============================================================================
FUNCTION PercToVal( nTotal, nPerc, nAlgor)
  Local nVal
  Default nAlgor To 0

  nVal := ( nTotal / 100 ) * nPerc
  nVal := IF( nAlgor = 0, nVal, mh_RoundNumb( nVal, nAlgor) )
RETURN( nVal)

* Zji�t�n� aktu�ln�ho m�s�ce
*===============================================================================
FUNCTION HIM_AktMes( cObd, cTask)
  Local  nAktMes := 0, nAktRok

  DEFAULT cTask TO 'HIM'

  nAktRok := Val( Right( uctOBDOBI:&cTask:cObdobi, 2))
  If Val( Right( cObd, 2)) == nAktRok
    nAktMes := Val( Left( cObd, 2) )
  EndIf
Return( nAktMes)

* Kontrola odpis� na z�statkovou cenu a zaokrouhlen� na cel� koruny nahoru
*===============================================================================
FUNCTION HIM_RocniOdpis( nRocniOdpis, nZustCena, nRoundAlgor )
  Local  nRet := If( nRocniOdpis > nZustCena, nZustCena, nRocniOdpis)
  Default  nRoundAlgor To  31
  nRet := mh_RoundNumb( nRet, nRoundAlgor )
Return( nRet)

*  Nov� ��slo dokladu  HIM + ZVI
*===============================================================================
FUNCTION HIM_NewDoklad( cTask)
  Local fiZMAJU := IF( cTask = 'ZVI', 'ZMajUZ', 'ZMajU')
  Local cAlias := fiZMAJU + '_a'
  Local nDoklad, cTop := '0000000000', cBot := '0000899998'

  drgDBMS:open( fiZMAJU,,,,, cAlias)
 ( cAlias)->( AdsSetOrder( 3))
 ( cAlias)->( mh_SetScope( cTop, cBot), dbGoBottom() )
  nDoklad := ( cAlias)->nDoklad + 1
 ( cAlias)->( dbCloseArea())

RETURN( nDoklad)

* ��ta� polo�ek v r�mci stejn�ho dokladu HIM + ZVI
*===============================================================================
FUNCTION HIM_OrdItem( nDoklad, isHIM)
  Local fiZMaju  := IF( isHIM, 'ZMajU', 'ZMajUZ' )
  Local cAlias := fiZMaju + '_a'
  Local nOrdItem

  drgDBMS:open( fiZMaju,,,,, cAlias)
  ( cAlias)->( AdsSetOrder( 3),;
               mh_SetScope( StrZERO( nDoklad, 10)),;
               dbGoBottom() )
  nOrdItem := ( cAlias)->nOrdItem + 1
  ( cAlias)->( mh_ClrScope(), dbCloseArea())
Return( nOrdItem)

* Kontrola duplicity ��sla dokladu  HIM + ZVI
*===============================================================================
FUNCTION HIM_CisDoklad( nDoklad, cTask)
  Local lOk := TRUE, cMsg
  Local cFILE := 'ZMajU' + IF( cTask = 'ZVI', 'Z', '' )

  IF nDoklad >= 900000
     cMsg := '��sla doklad� nad  900000  jsou rezervov�v�na pro automaticky generovan� zm�nov� doklady;( nap�. ��etn� odpisy )!'
     drgMsgBox(drgNLS:msg( cMsg))
     RETURN .F.
  EndIF
  *
  If ( cFILE)->( dbSeek( StrZero( nDoklad, 10),, AdsCtag(3) ) )
    drgMsgBox(drgNLS:msg( 'Duplicitn� ��slo dokladu !'))
    lOk := FALSE
  Endif
Return( lOk)

* Zjist� procento ro�n�ho da�ov�ho odpisu
*===============================================================================
FUNCTION HIM_ProcRDO( cObdZar, cOdpiSkD, nUplProc, nPocetDO, cTask, lZvCena, lnewRec )
  Local cFILE := 'Maj' + IF( cTask = 'ZVI', 'Z', '' )
  Local nProcRDO, nRokZar := VAL( mh_GETcRok4( cObdZar))
  Local isZvCena  // IM ji� pro�el zv��en�m ceny, anebo je jeho cena pr�v�
                  // zvy�ov�na ( fce je vol�na z pohybu zv��en� ceny ... lZvCena)

  DEFAULT lZvCena TO .F., lnewRec to .f.

  isZvCena := if( lnewRec, .f., ( .not. EMPTY((cFILE)->cObdZvys) .OR. lZvCena ) )

*  isZvCena := !EMPTY( (cFILE)->cObdZvys) .OR. lZvCena
  nProcRDO := IF( isZvCena, c_DanSkp->nRoZvCena,;
                IF( nPocetDO == 0, c_DanSkp->nRoPrvni, c_DanSkp->nRoDalsi) )

  IF nRokZar >= 2005
    DO CASE
      CASE nUplProc = 10
        IF ALLTRIM(cOdpiSkD) $ '1,1A,2,3'
          nProcRDO := IF( isZvCena, c_DanSkp->nRoZvCen10,;
                        IF( nPocetDO == 0, c_DanSkp->nRoPrvni10, c_DanSkp->nRoDalsi10) )
        ENDIF
      CASE nUplProc = 15
        IF ALLTRIM(cOdpiSkD) $ '1,2,3'
          nProcRDO := IF( isZvCena, c_DanSkp->nRoZvCen15,;
                        IF( nPocetDO == 0, c_DanSkp->nRoPrvni15, c_DanSkp->nRoDalsi15) )
        ENDIF
      CASE nUplProc = 20
        IF ALLTRIM(cOdpiSkD) $ '1,2,3'
          nProcRDO := IF( isZvCena, c_DanSkp->nRoZvCen20,;
                        IF( nPocetDO == 0, c_DanSkp->nRoPrvni20, c_DanSkp->nRoDalsi20) )
        ENDIF
    ENDCASE
  ENDIF
RETURN nProcRDO

* P�evod obdob� do ��seln� hodnoty
*===============================================================================
FUNCTION mh_ObdToVal( cObd)
  Local nRRRRMM := VAL( mh_GETcRok4( cObd) + LEFT( cObd, 2) )
Return( nRRRRMM )

* Transformace obdob� : 'MM/RR' --> 'MM/RRRR'
*===============================================================================
FUNCTION mh_OBD_5TO7( cOBDOBI)
  Local cROK4 := mh_GETcRok4( cOBDOBI)
  Local cObd7 := LEFT( cOBDOBI, 3) + cROK4
RETURN( cObd7 )

* Z obdob� : 'MM/RR' --> 'RRRR'
*===============================================================================
FUNCTION mh_GETcRok4( cOBDOBI)
  Local cRok2 := RIGHT( cObdobi, 2)
  Local cRok4 := IIF( cRok2 == '  ', '    ',;
                 IIF( VAL( cRok2) > 30, '19' + cRok2, '20' + cRok2 ))
RETURN( cRok4)

* Nastav� aktu�ln� obdob� pro danou �lohu
*===============================================================================
FUNCTION mh_SetAktObd( cUloha, cObd)
  Local aRec := {}

  drgDBMS:open('ucetsys')
  drgDBMS:open('ucetsys',,,,,'ucetsys_w')
  *
  IF .not. IsNIL( cObd)
    ucetsys_w->( AdsSetOrder( 2), mh_SetScope( Upper( cUloha)) )

    DO WHILE !ucetsys_w->( Eof())
      if( ucetsys_w->laktobd .or. cObd = ucetsys_w->cObdobi )
        aAdd( aRec,ucetsys_w->(recno()))
      endif
      ucetsys_w->( dbSkip())
    ENDDO

    if ucetsys->(sx_RLock( aRec))
      aeval(aRec,{|X| (ucetsys->(dbgoto(x)), ucetsys->laktobd := ( ucetsys->cObdobi = cObd)) })
    endif

    ucetsys->( dbunlock(), dbSeek( cObd,,'UCETSYS1'))
    ucetsys_w->( dbCloseArea())
  ENDIF
RETURN nil


function him_ucetPol_del_w(ctask)
  local  isHim       := ( ctask = 'HIM' )
  local  fiZMAJU     := if( isHim, 'zmaju', 'zmajuz' )
  local  scope       := upper((fiZNAJU)->cdenik) +strZero((fiZMAJU)->nDoklad, 10) +strZero((fiZMAJU)->nOrdItem, 5)
  local  ucetPol_rlo := {}
  local  obdDokl

  drgDBMS:open('UcetPol')
  ucetPol->( dbsetScope(SCOPE_BOTH, scope)                        , ;
             dbgotop()                                            , ;
             dbeval( {|| aadd(ucetpol_rlo, ucetpol->(recno())) } ), ;
             dbclearScope()                                         )

  if ucetPol->( sx_rLock(ucetpol_rlo))
    obdDokl := IsNull(obdDokl, strzero(ucetpol->nrok,4) +strzero(ucetpol->nobdobi,2))

  endif
return nil


*===============================================================================
FUNCTION HIM_UcetPOL_DEL( cTASK)
  Local isHIM := ( cTASK = 'HIM'), lOK := .F.
  Local fiZMAJU := If( isHIM, 'ZMajU', 'ZMajUZ')
  Local cDenik  := IF( isHIM , PadR( SysConfig( 'Im:cDenikIm'     ), 2 ),;
                               PadR( SysConfig( 'Zvirata:cDenikZv'), 2 ) )
  Local cMainKEY := Upper(cDenik ) + StrZero( ( fiZMAJU)->nDoklad, 10) + ;
                    StrZero( ( fiZMAJU)->nOrdItem, 5)
  *
  local obdDokl  := strzero( (fiZMAJU)->nrok,4) +strzero( (fiZMAJU)->nobdobi,2)
  local anUc     := {}


  drgDBMS:open('UcetPOL')
  DO WHILE UcetPOL->( dbSeek( cMainKEY,,'UCETPOL1'))
    IF cDENIK == UcetPOL->cDenik  // �loha ZV��ATA m� dva den�ky !!!
       DelRec( 'UcetPOL')
    ENDIF
    lOK := .T.
  ENDDO


  if lok
    if select('ucetSys_kx') = 0
      drgDBMS:open('ucetSys',,,,,'ucetSys_kx')
    endif

    ucetSys_kx->( ordSetFocus( 'UCETSYS3' ))
    ucetSys_kx->( DbSetScope( SCOPE_BOTH, 'U'), dbGoTop())
    ucetSys_kx->( dbSeek('U' +obdDokl))

    do while .not. ucetSys_kx->(eof())
      if( ucetSys_kx->nAKTUc_KS = 2, AAdd(anUc, ucetSys_kx->(recNo())), nil)
      ucetSys_kx->(dbSkip())
    enddo

    if ucetSys_kx->(sx_rlock(anUc))
      AEval(anUc, {|x| ( ucetSys_kx->(dbGoTo(x))          , ;
                         ucetSys_kx->nAKTUc_KS := 1       , ;
                         ucetSys_kx->cuctKdo   := logOsoba, ;
                         ucetSys_kx->ductDat   := date()  , ;
                         ucetSys_kx->cuctCas   := time()    ) })
    endif

    ucetSys_kx->(dbCommit(), dbUnlock(), dbClearScope())
  endif
RETURN NIL


* Aktualizace UcetSys p�i z�pisu do UcetPol
*===============================================================================
FUNCTION HIM_UcetSys_AKT( cObd)
  Local cKey := 'U' + cObd
  Local cUctKdo := SysConfig( 'System:cUserAbb')
  Local dUctDat := DATE()
  Local cUctCas := TIME()

/*
  local  anUc := {}

  fordRec({'UCETSYS,3'})
  ucetsys->( DbSetScope( SCOPE_BOTH, 'U'), dbGoTop())
  ucetsys->( dbSeek('U' +obdDokl))

  do while .not. ucetsys->(eof())
    if( ucetsys->nAKTUc_KS = 2, AAdd(anUc, ucetsys->(recNo())), nil)
    ucetsys->(dbSkip())
  enddo

  if ucetsys->(sx_rlock(anUc))
    AEval(anUc, {|x| ( ucetsys->(dbGoTo(x))          , ;
                       ucetsys->nAKTUc_KS := 1       , ;
                       ucetsys->cuctKdo   := logOsoba, ;
                       ucetsys->ductDat   := date()  , ;
                       ucetsys->cuctCas   := time()    ) })
  endif

  ucetsys->(dbCommit(), dbUnlock(), dbClearScope())
  fordRec()
*/

  /*
  FOrdRec( { 'UcetSys, 2' } )
  If UcetSys->( dbSeek( Upper( cKey)))
     UcetSys->( AdsSetOrder( 3))
     UcetSys->( dbSetScope( Upper( 'U') + StrZero( nRok, 4)))
     Do While !UcetSys->( Eof())
       If UcetSys->nObdobi >= nObdobi
         If UcetSys->( RLock())
           UcetSys->nAktUc_KS := 1
           UcetSys->cUctKdo   := cUctKdo
           UcetSys->dUctDat   := dUctDat
           UcetSys->cUctCas   := cUctCas
           UcetSys->( Sx_Unlock())
         Endif
       Endif
       UcetSys->( dbSkip())
     EndDo
     UcetSys->( dbClearScope())
  EndIf
  FOrdRec()
  */
RETURN Nil


* prevalida�n� funkce p�ed zalo�en�m obdob�
*===============================================================================
FUNCTION HIM_preAppendObdobi( oDlg, prmTASK)
  Local cTask     := IsNULL( prmTASK, oDlg:udcp:task ), lOK := .T., lUzv
  LOCAL newObdobi := oDlg:udcp:o_Obdobi:value
  LOCAL newRok    := oDlg:udcp:o_Rok:value
*  Local minObdobi := IF( newObdobi = 1, 12, newObdobi - 1 )
  Local minRok    := newRok - 1
  Local fiRokUzv  := IF( cTask = 'HIM', 'RokUzv', 'RokUzvZ')

  * Obdob� nov�ho roku nelze zalo�it, pokud neprob�hla ro�n� uz�v�rka minul�ho roku
  drgDBMS:open( fiRokUzv)
  lUzv := (fiRokUzv)->( dbSeek( minRok,, AdscTag( 1)))
  IF ( !lUzv .and. (fiRokUzv)->( RecCount()) > 0 ) .or. ;
     ( !lUzv .and. (fiRokUzv)->( RecCount()) = 0  .and. newRok > minRok )
    drgMsgBox(drgNLS:msg( 'Obdob�  [ &/& ]  nelze zalo�it ...;;' + ;
                          'Nebyla dosud provedena ro�n� uz�v�rka roku [ & ] ...', newObdobi, newRok, minRok ))
    lOK := .F.
  ENDIF
RETURN lOK


* Po zalo�en� obdob�
*===============================================================================
FUNCTION HIM_postAppendObdobi( oDlg, prmTASK)
  Local cTask     := IsNULL( prmTASK, oDlg:udcp:task )
  LOCAL newRok    := oDlg:udcp:o_Rok:value
  LOCAL newObdobi := oDlg:udcp:o_Obdobi:value
  *
  Local minRok    := IF( newObdobi = 1, newRok - 1, newRok)
  Local minObdobi := IF( newObdobi = 1, 12, newObdobi - 1 )
  *
  LOCAL OdpisyGen
  Local cNewObd := StrZero( newObdobi,2)+'/'+ RIGHT( StrZero( newRok,4), 2)
  Local cUloha := if( cTask = 'HIM', 'I', 'Z')


  if .not. oSession_data:inTransaction()
    oSession_data:beginTransaction()
    BEGIN SEQUENCE

      /* Zalo�en� z�znamu s ro�n�m po�. stavem */
      IF newObdobi = 1
        HIM_MAJ_ps( newRok, cTASK)
      ENDIF

      /* P�ed zalo�en�m nov�ho obdob� se odlo�� MAJ do MAJOBD, resp. MAJZ do MAJZOBD
         To se t�k� zakl�d�n� obdob� 2 - 12.
         Odlo�en� 12.m�s�ce se neprov�d� p�i zalo�en� 1.m�s�ce, ale p�i ro�n� uz�v�rce,
         kter� se d�l� (zpravidla) ve 12.m�s�ci
       */
       IF newObdobi <> 1
         HIM_MajObd( minRok, minObdobi, cTask)
       ENDIF

       /* Vygeneruj� se ��etn� odpisy na nov� zalo�en� obdob�  */
       OdpisyGen := HIM_ODPISY_gen():New( oDlg, cTask)

       oSession_data:commitTransaction()

    RECOVER USING oError
      oSession_data:rollbackTransaction()

      * mus�me zru�it obdbob� pro HIM - padlo to
      if ucetSys->(sx_Rlock())
         ucetSys->(dbdelete(), dbcommit(), dbunlock())
      endif

    END SEQUENCE

  else

    /* Zalo�en� z�znamu s ro�n�m po�. stavem */
    IF newObdobi = 1
      HIM_MAJ_ps( newRok, cTASK)
    ENDIF

    /* P�ed zalo�en�m nov�ho obdob� se odlo�� MAJ do MAJOBD, resp. MAJZ do MAJZOBD
       To se t�k� zakl�d�n� obdob� 2 - 12.
       Odlo�en� 12.m�s�ce se neprov�d� p�i zalo�en� 1.m�s�ce, ale p�i ro�n� uz�v�rce,
       kter� se d�l� (zpravidla) ve 12.m�s�ci
    */
    IF newObdobi <> 1
      HIM_MajObd( minRok, minObdobi, cTask)
    ENDIF

    /* Vygeneruj� se ��etn� odpisy na nov� zalo�en� obdob�  */
    OdpisyGen := HIM_ODPISY_gen():New( oDlg, cTask)
  endif
RETURN NIL

* P�i zalo�en� 1.obdob� zalo�it z�znam s po�.stavem
*===============================================================================
FUNCTION  HIM_MAJ_ps( newRok, cTASK )
  Local nCount, lLock, lMAJ, lMAJ_ps, lSeek
  Local isHIM := ( cTASK = 'HIM')
  Local fiMaj    := 'MAJ' + IF( isHIM, '','Z' )
  Local fiMaj_ps := 'MAJ' + IF( isHIM, '','Z' ) + '_PS'
  Local cKey

  drgDBMS:open( fiMAJ )
  drgDBMS:open( fiMAJ_PS )
  *
  ( fiMAJ)->( dbGoTop())
  lMAJ    := ( fiMAJ)->( FLock())
  lMAJ_ps := ( fiMAJ_ps)->( FLock())
  lLock   := ( lMAJ .and. lMAJ_ps )

  IF lLock
    nCount := ( fiMAJ)->( mh_COUNTREC())
      *
    drgServiceThread:progressStart(drgNLS:msg('Generuji po��te�n� stavy pro rok [ ' + Str( newRok) + ' ]  ...', fiMAJ), nCount  )

    DO WHILE !( fiMAJ)->( Eof())
      * aktualizace po�.hodnot na kart� zv��ete
      ( fiMAJ)->nOprUctPS  := ( fiMAJ)->nOprUct
      ( fiMAJ)->nOprDanPS  := ( fiMAJ)->nOprDan
      * aktualizace souboru po�. stav�
      cKey := IF( isHIM, StrZero( (fiMaj)->nTypMaj,3), StrZero( (fiMaj)->nUcetSkup,3) ) + ;
                         StrZero( (fiMaj)->nInvCis,15) + StrZero( newRok, 4)
      lSeek := ( fiMAJ_ps)->( dbSeek( cKey,, AdsCtag(1)))
      IF !lSeek
        mh_CopyFld( fiMAJ, fiMAJ_ps, .T. )
        ( fiMAJ_ps)->nRok := newRok
      ENDIF
      ( fiMAJ_ps)->nVsCenDPS  := ( fiMAJ)->nCenaVstD
      ( fiMAJ_ps)->nVsCenUPS  := ( fiMAJ)->nCenaVstU
      ( fiMAJ_ps)->nOprUctPS  := ( fiMAJ)->nOprUct
      ( fiMAJ_ps)->nZuCenUPS  := ( fiMAJ)->nCenaVstU - ( fiMAJ)->nOprUct
      mh_WrtZmena( fiMAJ_ps, !lSeek )
      *
      ( fiMAJ)->( dbSkip())
      *
      drgServiceThread:progressInc()
    ENDDO
    *
    drgServiceThread:progressEnd()
    *
    if .not. oSession_data:inTransaction()
      ( fiMAJ)->( dbUnlock())
      ( fiMAJ_ps)->( dbUnlock())
    endif
  ELSE

  ENDIF
RETURN NIL


* Ulo�� aktu�ln� stav souboru MAJ( MAJz) za p�edchoz� obdob� do souboru MAJOBD( MAJZOBD)
*===============================================================================
FUNCTION HIM_MajOBD( nROK, nOBDOBI, cTask )
  Local isHIM    := ( cTask = 'HIM')
  Local cOBDOBI  := STRZERO( nOBDOBI, 2) + '/' + RIGHT( STR( nROK, 4), 2 )
  Local fiMAJOBD := IF( isHIM, 'MAJOBD', 'MAJzOBD')
  Local fiMAJ    := IF( isHIM, 'MAJ'   , 'MAJz'   )
  Local fiMAJa   := fiMAJ + 'a'

  drgDBMS:open( fiMAJOBD )
  drgDBMS:open( fiMAJ,,,,, fiMAJa )

  drgServiceThread:progressStart(drgNLS:msg('Ulo�en� aktu�ln�ch stav� za [ ' + cObdobi + ' ] ...', fiMAJa ), (fiMAJa)->( LastREC()) )
  ( fiMAJa)->( dbGoTOP())
  DO WHILE !( fiMAJa)->( EOF())
    *
    ( fiMajOBD)->( dbAppend(), dbRLock() )
    mh_CopyFLD( fiMAJa,  fiMAJOBD )
    ( fiMajOBD)->nROK     := nROK
    ( fiMajOBD)->nOBDOBI  := nOBDOBI
    ( fiMajOBD)->cOBDPOH  := cOBDOBI
    ( fiMajOBD)->( dbRUnLock() )
    *
    ( fiMAJa)->( dbSKIP())
    drgServiceThread:progressInc()
  ENDDO
  ( fiMAJOBD)->( dbCommit())
  drgServiceThread:progressEnd()

  ( fiMAJa)->( dbCloseArea())

RETURN NIL


*===============================================================================
FUNCTION HIM_isRocniUzv( nRok, cAlias)
  Local lOK, lUzv := .T., cTag

  drgDBMS:open( cAlias)
  cTag := ( cAlias)->( AdsSetOrder( 3))
  ( cAlias)->( mh_SetScope( StrZero( nRok, 4)) )
  lOK := .not. ( cAlias)->( EOF())
  ( cAlias)->( mh_ClrScope())
  IF !lOk .and. ( cAlias)->( LastRec()) > 0
    lUzv := .F.
  ENDIF
  ( cAlias)->( AdsSetOrder( cTag))

RETURN lUzv


*===============================================================================
FUNCTION HIM_dMajOdpis( cAlias)
  Local nRet := 0

  default cAlias to 'maj'

  drgDBMS:open(cAlias)
  (cAlias)->( dbGoTop())
  do while .not.(cAlias)->( Eof())
    nret += if((cAlias)->nznaktd = 0,(cAlias)->NDANODPROK, 0)
   (cAlias)->( dbSkip())
  enddo

RETURN nRet