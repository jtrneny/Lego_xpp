*======= Prevod zvirat na novou ucetni skupinu =================================
FUNCTION Prevod_ZVI()
  Local acFILES  := { 'MajZ','ZmajuZ','SumMajZ','MajzObd','UMajZ','DMajZ','Zvirata','UcetSys','RokUzvZ' }
  Local cKey, lCond_1, lCond_2, lOK, lOKobd, nOLD_skup, nNEW_skup
  Local N, cFile, nCount
  Local nKcPrevTop := SysConfig( 'Zvirata:nKcPrevTop')
  Local nKcPrevBot := SysConfig( 'Zvirata:nKcPrevBot')

  IF drgIsYesNO(drgNLS:msg('Provést pøevod zvíøat na jinou úèetní skupinu ?'))
    aEval( acFILES, {|File| drgDBMS:open( File) })
    ZmajuZ->( AdsSetOrder( 1))
    SumMajZ->( AdsSetOrder( 2))
    MajZObd->( AdsSetOrder( 2))
    Zvirata->( AdsSetOrder( 3))

    cKey := 'Z' + '2009'
    lCond_1 := ! UcetSys->( dbSeek( cKey,, 'UCETSYS3' ))   // neni otevren rok 2009
    lCond_2 := ! RokUzvZ->( dbSeek( 2008,, 'ROKUZVZ_1'))   // neprobehla uzaverka roku 2008
    lOk     := ( lCond_1 .and. lCond_2 )

    nCount:= MajZ->( mh_COUNTREC())
    MajZ->( AdsSetOrder(0), dbGoTOP())

    drgServiceThread:progressStart(drgNLS:msg('Pøevod na nové úèetní skupiny ...', 'MajZ'), nCount  )

    DO WHILE ! MajZ->( Eof())
      *
      IF MajZ->nCenaVstU >= nKcPrevBot .and.  MajZ->nCenaVstU <= nKcPrevTop

        lOkOBD := ( Val( Right( MajZ->cObdZar, 2)) >= 8 .and. Year( MajZ->dDatZar) >= 2000 )
        // majetek zarazen v roce >= 2008
        IF lOKobd
          nOLD_skup := MajZ->nUcetSkup
          nNEW_skup := MajZ->nUcetSkup + 100
          *
          cKey := StrZero( nOLD_skup) + StrZero( MajZ->nInvCis)
          acFILES := { 'ZmajuZ', 'SumMajZ', 'MajZObd' }
          FOR n := 1 TO LEN( acFILES)
            ReplFILE( acFILES[ n], cKey, nNew_skup)
          NEXT
          ReplFILE( 'Zvirata', MajZ->nInvCis, nNew_skup)
          *
          IF ! lOK
            acFILES := { 'DMajZ', 'UmajZ' }
            FOR n := 1 TO LEN( acFILES)
              ReplFILE( acFILES[ n], cKey, nNew_skup)
            NEXT
          ENDIF
          *
          IF ReplREC( 'MajZ')
            MajZ->nUcetSkup := nNEW_skup
            MajZ->cUcetSkup := Alltrim( Str( nNEW_skup))
            MajZ->( dbUnlock())
          ENDIF
        ENDIF
      ENDIF
      *
*      Sleep( 1)
      MajZ->( dbSkip())

      drgServiceThread:progressInc()
    ENDDO
    *
    drgServiceThread:progressEnd()

  ENDIF
RETURN NIL

//-------------------------------------------------
STATIC FUNCTION ReplFILE( cFile, cScope, nNew_skup)
  Local aRecs := {}, lLock, aLock

  (cFile)->( mh_SetScope( cScope))
  DO WHILE ! (cFile)->( Eof())
    AADD( aRecs, (cFile)->(RecNo()) )
    (cFile)->( dbSkip())
  ENDDO
  IF ( Len(aRecs) > 0)
    lLock := (cFile)->( sx_RLock( aRecs))
    If lLock
      *
      AEVAL( aRecs, {|x| (cFile)->( dbGoTO(x)),;
                         (cFile)->nUcetSkup := nNEW_skup,;
                         (cFile)->cUcetSkup := AllTrim( Str(nNEW_skup))  } )
      *
      (cFile)->( dbUnlock(), dbCommit() )
    EndIf
  Endif
  (cFile)->( mh_ClrScope())

RETURN NIL