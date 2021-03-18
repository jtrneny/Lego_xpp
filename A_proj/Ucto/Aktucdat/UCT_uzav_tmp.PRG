#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "drgRes.ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


Function UctoUZAV()
  Local cScope
  LOCAL nRecCount, nCount, bOKtest
  LOCAL lROPO := .F., lVN89 := .F., nX
//        LOCAL cTMP      := fHomAdr() + '\Tmp\'
  LOCAL xKey, lNewStav
  local nRokUzv, nObdUzv
  local filter, m_filter
  local lpoc_st := .f.
  LOCAL nKcMDsum, nKcDALsum
  LOCAL cUCET_1,cUCET_3, cNAZP_21
  local avyknv, avykpo, atmp
  local lgen, vykonyNv
  local coldKey, nrozdil
  local nTypNV := 2

  drgDBMS:open('UcetKumU')
  drgDBMS:open('UcetKum')
  drgDBMS:open('ucetpocs')
  drgDBMS:open('Ucetpol')

  drgDBMS:open('UcRokUzv')
  drgDBMS:open('UcetPSNV')

  nRokUzv := uctOBDOBI:UCT:NROK
  nObdUzv := ucetsys->nobdobi //uctOBDOBI:UCT:NOBDOBI

  xKey := StrZero( nRokUzv, 4) + StrZero( nObdUzv, 2)
  UcetKumU ->( ADSsetorder( 'UCETK_02'))
  UcetKumU ->( dbSETSCOPE( SCOPE_BOTH, xKEY))
  UcetKum ->( ADSsetorder( 'UCETK_01'))
  UcetKum ->( dbSETSCOPE( SCOPE_BOTH, xKEY))

  IF drgIsYESNO(drgNLS:msg('Zpracovat úèetní uzávìrku ( zavøení a otevøení úèetních knih, otevøení poèáteèních stavù ) za rok' +Str( nRokUzv)+" ?"))

    IF drgIsYESNO(drgNLS:msg("Bude provádìna úèetní roèní uzávìrka bez ROPO ?"))
      bOKtest := {|| ( cUCET_1 == "0" .OR. cUCET_1 == "1" .OR. cUCET_1 == "2"        ;
                                        .OR. cUCET_1 == "3" .OR. cUCET_1 == "4" .OR. cUCET_1 == "7")   ;
                                                    .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }
    ELSE
      bOKtest := {|| ( cUCET_1 == "0" .OR. cUCET_1 == "1" .OR. cUCET_1 == "2"          ;
                                       .OR. cUCET_1 == "3" .OR. cUCET_1 == "4" .OR. cUCET_1 == "7"    ;
                                        .OR. cUCET_1 == "9")                                          ;
                                          .AND. ( cUCET_3 <> "999")                                       ;
                                                     .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }

    ENDIF

//  m_filter := "nrok = '%%' .and. cdenik = %%", filter, x
//  if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)
//  filter := format(m_filter,{nRokUzv,'WO'})


*****  Otevøení úèetních knih

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WO'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    UcetKumU ->( dbGoTop())
    nKcMDsum  := 0
    nKcDALsum := 0

    do while !UcetKumU ->( Eof())
      cUCET_1 := SubStr( UcetKumU ->cUcetMD, 1, 1)
      cUCET_3 := SubStr( UcetKumU ->cUcetMD, 1, 3)
      if  Eval( bOKtest)
        UcRokUzv ->( mh_Append())
        xKEY := "14/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)
        UcRokUzv ->cDenik    := 'WO'
        UcRokUzv ->cObdobi   := xKEY
        UcRokUzv ->nRok      := nRokUzv
        UcRokUzv ->nObdobi   := 14

        UcRokUzv ->cUcetMD   := UcetKumU ->cUcetMD
        UcRokUzv ->cUcetDAL  := "701000"
//        UcZOtevr ->P         := ")"

        UcRokUzv ->nKcMDksR  := UcetKumU ->nKcMDksR
        UcRokUzv ->nKcDALksR := UcetKumU ->nKcDALksR
        UcRokUzv ->nKcMDpsR  := UcetKumU ->nKcMDksR
        UcRokUzv ->nKcDALpsR := UcetKumU ->nKcDALksR

        nKcMDsum  += UcetKumU ->nKcMDksR
        nKcDALsum += UcetKumU ->nKcDALksR
        UcRokUzv ->(dbUnlock())
      ENDIF

      UcetKumU ->( dbSkip())
    ENDDO

    UcRokUzv->( mh_Append())

    xKEY := "14/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)
    UcRokUzv->cDenik    := 'WO'
    UcRokUzv->cObdobi   := xKEY
    UcRokUzv->nRok      := nRokUzv
    UcRokUzv->nObdobi   := 14
    UcRokUzv->cUcetMD   := "431000"
    UcRokUzv->cUcetDAL  := "701000"
    UcRokUzv->nKcDALksR := nKcMDsum - nKcDALsum
    UcRokUzv->nKcDALpsR := nKcMDsum - nKcDALsum
    UcRokUzv ->lGENER   := .T.

    UcRokUzv->( dbUnlock())


***** Poèáteèní stavy úètù

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'WP'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    drgDBMS:open('UcRokUzv',,,,,'UcRokUzva')
    UcRokUzva->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WO'})),dbgotop())

    if drgIsYESNO(drgNLS:msg('Doplnit poèáteèní stavy pro rok' +Str( nRokUzv+1)+" ?"))

      lpocst := .t.

      ucetpocs->(ads_setaof( format("nrok = %%",{nRokUzv+1})),dbgotop())
      ucetpocs->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
      ucetpocs->(ads_clearaof(),dbgotop())

    endif

    do while !UcRokUzva ->( Eof())
      MH_CopyFLD( 'UcRokUzva', 'UcRokUzv', .T.)
      xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
      UcRokUzv->cDenik    := 'WP'
      UcRokUzv->cObdobi   := xKEY
      UcRokUzv->nRok      := nRokUzv +1
      UcRokUzv->nObdobi   := 1

      UcRokUzv->cUcetMD   := IF( UcRokUzv->cUcetMD == "121200"              ;
                                              ,"121100", UcRokUzv->cUcetMD)
      UcRokUzv->cUcetDAL  := IF( UcRokUzv->cUcetDAL == "121200"             ;
                                              ,"121100", UcRokUzv->cUcetDAL)

      UcRokUzv->nKcMDksR  := 0
      UcRokUzv->nKcDALksR := 0
      UcRokUzv ->(dbUnlock())

      if( lpocst, MH_CopyFLD( 'UcRokUzv', 'ucetpocs', .t.), nil)

      UcRokUzva->( dbSkip())
    ENDDO

    UcRokUzv->( dbUnlock())


***** Uzavøení úèetních knih

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WZ'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    UcRokUzva->(dbgotop())

    DO WHILE !UcRokUzva ->( Eof())
      UcRokUzv ->( mh_Append())

      xKEY := "13/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)
      UcRokUzv->cDenik    := 'WZ'
      UcRokUzv->cObdobi   := xKEY
      UcRokUzv->nRok      := nRokUzv
      UcRokUzv->nObdobi   := 13
      UcRokUzv->cUcetMD   := if( UcRokUzva ->lGENER, "710000", UcRokUzva ->cUcetMD)
      UcRokUzv->cUcetDAL  := "702000"

      UcRokUzv->nKcMDksR  := UcRokUzva->nKcMDksR *(-1)
      UcRokUzv->nKcDALksR := UcRokUzva->nKcDALksR *(-1)
      UcRokUzv->( dbUnlock())

      UcRokUzva->( dbSkip())
    ENDDO

    UcRokUzv->( dbUnlock())
    UcRokUzva->(ads_clearaof(),dbgotop())
    UcRokUzva->( dbCloseAre())

*****  Pøeúètování

    if .T.     //Box_YesNo( "Vnitropodnikov‚ za£Ÿtov n¡ bez 8 a 9 (jen 5 a 6) ?") = 2
      bOKtest := {|| ( cUCET_1 == "5" .OR. cUCET_1 == "6"                      ;
                          .OR. cUCET_1 == "8" .OR. cUCET_1 == "9")              ;
                           .AND. ( cUCET_3 <> "999")                               ;
                            .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }
    else
      bOKtest := {|| ( cUCET_1 == "5" .OR. cUCET_1 == "6" )                    ;
                           .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }
    endif

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WR'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    UcetKumU ->( dbGoTop())
    nKcMDsum  := 0
    nKcDALsum := 0

    do while !UcetKumU ->( Eof())

      cUCET_1 := SubStr( UcetKumU ->cUcetMD, 1, 1)
      cUCET_3 := SubStr( UcetKumU ->cUcetMD, 1, 3)

      if Eval( bOKtest)
        UcRokUzv ->( mh_Append())

        xKEY                := "13/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)
        UcRokUzv->cDenik    := 'WR'
        UcRokUzv ->cObdobi  := xKEY
        UcRokUzv ->nRok     := nRokUzv
        UcRokUzv ->nObdobi  := 13

        UcRokUzv ->cUcetMD  := UcetKumU ->cUcetMD

        UcRokUzv ->nKcMDksR  := UcetKumU ->nKcMDksR  *(-1)
        UcRokUzv ->nKcDALksR := UcetKumU ->nKcDALksR *(-1)
        UcRokUzv ->nKcMDpsR  := UcetKumU ->nKcMDksR  *(-1)
        UcRokUzv ->nKcDALpsR := UcetKumU ->nKcDALksR *(-1)

        nKcMDsum  += UcetKumU ->nKcMDksR
        nKcDALsum += UcetKumU ->nKcDALksR
        UcRokUzv->( dbUnlock())

      endif

      UcetKumU->( dbSkip())
    enddo

    UcRokUzv ->( mh_Append())

    xKEY := "13/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)

    UcRokUzv->cDenik    := 'WR'
    UcRokUzv->cObdobi   := xKEY
    UcRokUzv->nRok      := nRokUzv
    UcRokUzv->nObdobi   := 13
    UcRokUzv->cUcetMD   := "710000"
    UcRokUzv->nKcDALksR := ( nKcMDsum - nKcDALsum) *(-1)
    UcRokUzv->nKcDALpsR := ( nKcMDsum - nKcDALsum) *(-1)
    UcRokUzv->lGENER    := .T.

    UcRokUzv->( dbUnlock())
  endif


***** Poèáteèní stavy nedokonèené výroby
  if drgIsYESNO(drgNLS:msg('Vytvoøit poèáteèní stavy nedokonèené výroby pro rok' +Str( nRokUzv+1)+" ?"))
    UcRokUzv->(ads_setaof( format("nrok = %%",{nRokUzv+1})),dbgotop())
    UcetPSNV->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcetPSNV->(ads_clearaof(),dbgotop())

    do case
    case nTypNV = 1
      drgDBMS:open('autom_it')
      vykonyNv  := 'nRok = %% .and. nObdobi = %% .and. ntyp_aut = 1'
      condition := format( vykonyNv, { nrokuzv, nobduzv })
      autom_it->( ads_setAof( condition ), dbgoTop())

      avyknv := avykpo := atmp := {}

      do while .not. autom_it->(eof())
        avyknv := mh_Token(autom_it->cmrozp_co, ',')

        for nn := 1 to len(avyknv)
          atmp := if( at( '..', avyknv[nn]) > 0, mh_Token(avyknv[nn], '..')  ;
                      , {avyknv[nn],avyknv[nn]})
          if atmp[1] >= '400' .and. atmp[2] <= '699'
            AAdd( avykPo, atmp)
          endif
        next

        autom_it->(dbskip())
      enddo


      UcetKum ->( dbGoTop())
      nX := 0

      do while !UcetKum ->( Eof())
        cUCET_1  := SubStr( UcetKum ->cUcetMD, 1, 1)
        cNAZP_21 := SubStr( UcetKum ->cNazPol2, 1, 1)
        lgen := .f.

        if ( cUCET_1 == "5" .OR. cUCET_1 == "6")                                  ;
             .and. ( UcetKum ->nKcMDksR <> UcetKum ->nKcDALksR)                   ;
               .and. (cNAZP_21 == "4" .or. cNAZP_21 == "5" .or. cNAZP_21 == "6")

          for nn := 1 to Len(avykPo)
            if Val(UcetKum ->cNazPol2) >= Val( avykPo[nn,1]) .and.  ;
                 Val(UcetKum ->cNazPol2) <= Val( avykPo[nn,2])
              lgen := .t.
            endif
          next

          if lgen
            nX++
            MH_CopyFLD( 'UcetKum', 'UcetPSNV', .T.)

            xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
            UcetPSNV->cObdobi   := xKEY
            UcetPSNV->nRok      := nRokUzv +1
            UcetPSNV->nObdobi   := 1
            UcetPSNV->cDenik    := "X"
            UcetPSNV->nDoklad   := (nRokUzv +1) * 100
            UcetPSNV->nOrdItem  := nX
            UcetPSNV->nOrdUcto  := 1

            UcetPSNV->cTyp_R    := "MD"
            UcetPSNV->dDatPoriz := Date()
            UcetPSNV->cUloha    := "U"
            UcetPSNV->cText     := "Poè.stav NV " + Str(nRokUzv +1,4)

            UcetPSNV->cUcetMD   := IF( UcetKum ->cUcetMD  == "611200"             ;
                                       , "611101", UcetKum ->cUcetMD )

            UcetPSNV->nKcMD     := UcetKum ->nKcMDksR
            UcetPSNV->nKcDAL    := UcetKum ->nKcDALksR

            UcetPSNV->cNazPol2 := AllTrim( Str( Val( UcetPSNV->cNazPol2) - 300))

            MH_CopyFLD( 'UcetKum', 'UcetPSNV', .T.)

            xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
            UcetPSNV->cObdobi   := xKEY
            UcetPSNV->nRok      := nRokUzv + 1
            UcetPSNV->nObdobi   := 1
            UcetPSNV->cDenik    := "X"
            UcetPSNV->nDoklad   := (nRokUzv +1) * 100
            UcetPSNV->nOrdItem  := nX
            UcetPSNV->nOrdUcto  := 2

            UcetPSNV->cTyp_R    := "DAL"
            UcetPSNV->dDatPoriz := Date()
            UcetPSNV->cUloha    := "U"
            UcetPSNV->cText     := "Poè.stav NV " + Str(nRokUzv +1,4)

            UcetPSNV->cUcetMD   := IF( UcetKum ->cUcetMD  == "611200"             ;
                                        , "611101", UcetKum ->cUcetMD )

  //                        UcZnedVy ->cUcetDAL  := IF( UcetKum ->cUcetDAL == "611200"             ;
  //                                                     , "611101", UcetKum ->cUcetDAL )

            UcetPSNV->nKcMD     := UcetKum ->nKcMDksR  *(-1)
            UcetPSNV->nKcDAL    := UcetKum ->nKcDALksR *(-1)

            UcetPSNV->cNazPol2  := ""
            UcetPSNV->cNazPol3  := ""
            UcetPSNV->cNazPol4  := ""
            UcetPSNV->cNazPol5  := ""
            UcetPSNV->cNazPol6  := ""

            UcetPSNV->( dbUnLock())
          endif
        endif

        UcetKum ->( dbSkip())
      enddo

    case nTypNV = 2
      drgDBMS:open('UCKUMUZ1w',.T.,.T.,drgINI:dir_USERfitm);ZAP
      UcetKum->(ads_setaof( format("nrok = %% .and. nobdobi = %% .and. Left(cucetmd,3) = '%%'",{nRokUzv,nObdUzv,'611'})),dbgotop())
      do while .not. UcetKum->( eof())
        if UcetKum->nKcMDKSR <> UcetKum->nKcDALKSR
          MH_CopyFLD( 'UcetKum','UCKUMUZ1w',.T.)
        endif
        UcetKum->( dbSkip())
      enddo
      UcetKum->(ads_clearaof(),dbgotop())

      xx1 := 0
      xx2 := 0
      UCKUMUZ1w ->( dbGoTop())
      do while .not. UCKUMUZ1w->( eof())
        xx1 += UCKUMUZ1w->nKcMDksR
        xx2 += UCKUMUZ1w->nKcDALksR
        UCKUMUZ1w ->( dbSkip())
      enddo

      drgDBMS:open('UCKUMUZ2w',.T.,.T.,drgINI:dir_USERfitm);ZAP
      UCKUMUZ2w ->( OrdSetFocus('UCKUMUZ2w1'))

      UcetKum->(ads_setaof( format("nrok = %% .and. nobdobi = %% .and. Left(cucetmd,2) <> '%%'.and.( Left(cucetmd,1) = '%%'.or. Left(cucetmd,1) = '%%').and. cnazpol3 <> '  '",{nRokUzv,nObdUzv,'60','5','6'})),dbgotop())
      do while .not. UcetKum->( eof())
        if UCKUMUZ1w->( dbSeek( Upper(UcetKum->cnazpol1) +Upper(UcetKum->cnazpol2) +Upper(UcetKum->cnazpol3),,'UCKUMUZ1w1'))
          MH_CopyFLD( 'UcetKum','UCKUMUZ2w',.T.)
        endif
        UcetKum->( dbSkip())
      enddo
      UcetKum->(ads_clearaof(),dbgotop())

      UCKUMUZ2w ->( dbGoTop())
      nX := 0
      coldKey   := UCKUMUZ2w->cnazpol3
      nKcMDsum  := 0
      nKcDALsum := 0

      do while .not. UCKUMUZ2w->( eof())
        if coldKey = UCKUMUZ2w->cnazpol3
          nKcMDsum  += UCKUMUZ2w->nKcMDKSR
          nKcDALsum += UCKUMUZ2w->nKcDALKSR
        else
          if UCKUMUZ1w->( dbSeek( Upper(UCKUMUZ2w->cnazpol1) +Upper(UCKUMUZ2w->cnazpol2 +Upper(UCKUMUZ2w->cnazpol3)),,'UCKUMUZ1w1'))
            nrozdil := UCKUMUZ1w->nKcDALKSR - nKcMDsum
          endif

          lgen := nrozdil <> 0

          if lgen
            nX++
            MH_CopyFLD( 'UCKUMUZ2w', 'UcetPSNV', .T.)

            xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
            UcetPSNV->cObdobi   := xKEY
            UcetPSNV->nRok      := nRokUzv +1
            UcetPSNV->nObdobi   := 1
            UcetPSNV->cDenik    := "X"
            UcetPSNV->nDoklad   := (nRokUzv +1) * 100
            UcetPSNV->nOrdItem  := nX
            UcetPSNV->nOrdUcto  := 1

            UcetPSNV->cTyp_R    := "MD"
            UcetPSNV->dDatPoriz := Date()
            UcetPSNV->cUloha    := "U"
            UcetPSNV->cText     := "Poè.stav NV " + Str(nRokUzv +1,4)

            UcetPSNV->cUcetMD   := "613999"

            UcetPSNV->nKcMD     := nrozdil
//            UcetPSNV->nKcDAL    := UcetKum ->nKcDALksR

            MH_CopyFLD( 'UcetKum', 'UcetPSNV', .T.)

            xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
            UcetPSNV->cObdobi   := xKEY
            UcetPSNV->nRok      := nRokUzv + 1
            UcetPSNV->nObdobi   := 1
            UcetPSNV->cDenik    := "X"
            UcetPSNV->nDoklad   := (nRokUzv +1) * 100
            UcetPSNV->nOrdItem  := nX
            UcetPSNV->nOrdUcto  := 2

            UcetPSNV->cTyp_R    := "DAL"
            UcetPSNV->dDatPoriz := Date()
            UcetPSNV->cUloha    := "U"
            UcetPSNV->cText     := "Poè.stav NV " + Str(nRokUzv +1,4)

            UcetPSNV->cUcetMD   := "613999"

  //                        UcZnedVy ->cUcetDAL  := IF( UcetKum ->cUcetDAL == "611200"             ;
  //                                                     , "611101", UcetKum ->cUcetDAL )

            UcetPSNV->nKcMD     := nrozdil *(-1)
//            UcetPSNV->nKcDAL    := UcetKum ->nKcDALksR *(-1)

            UcetPSNV->cNazPol2  := ""
            UcetPSNV->cNazPol3  := ""
            UcetPSNV->cNazPol4  := ""
            UcetPSNV->cNazPol5  := ""
            UcetPSNV->cNazPol6  := ""

            UcetPSNV->( dbUnLock())
          endif

          coldKey   := UCKUMUZ2w->cnazpol3
          nKcMDsum  := UCKUMUZ2w->nKcMDKSR
          nKcDALsum := UCKUMUZ2w->nKcDALKSR
        endif
        UCKUMUZ2w->( dbSkip())
      enddo

    case  nTypNV = 3

    endcase

    Ucetpol->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'X'})),dbgotop())
    Ucetpol->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    Ucetpol->(ads_clearaof(),dbgotop())

    UcetPSNV->( dbGoTop())
    do while !UcetPSNV->( Eof())
      MH_CopyFLD( 'UcetPSNV','ucetpol',.T.)
      ucetpol->( dbUnLock())
      ucetpsnv->( dbSkip())
    enddo

    UcetPSNV->( dbUnLock())

    ucetkumu->( dbCloseAre())
    ucetkum->( dbCloseAre())
    ucetpocs->( dbCloseAre())
    ucetpol->( dbCloseAre())
    ucrokuzv->( dbCloseAre())
    ucetpsnv->( dbCloseAre())
  endif


  drgNLS:msg('Uzávìrka byla dokonèená')

RETURN( NIL)


/*

  Box_Make( '< Okam§ik pros¡m ... >',;
               'Prob¡h  pý¡prava pro uz vØrku saldokonta ...',;
                'w+/g, gr+/n*')

//        dbCreate( "Tmp\UcZNedVy", aOutDEF2 )
  dbUseArea( .t., "SIXCDX", ( cUcetSALd),, if( .T. .or. .F., lNetWare, NIL ), .f. )
        COPY TO "Tmp\TmpSalD"
  dbUseArea( .t., "SIXCDX", ( "Tmp\TmpSalD"),, if( .T. .or. .F., .F., NIL ), .f. )

  dbUseArea( .t., "SIXCDX", ( cUcetSALk),, if( .T. .or. .F., lNetWare, NIL ), .f. )
        COPY TO "Tmp\TmpSalK" FOR UCETSALk ->nRok == nRokTMP .AND. UCETSALk ->nObdobi == nObdTMP .AND. !Deleted()
  dbUseArea( .t., "SIXCDX", ( "Tmp\TmpSalK"),, if( .T. .or. .F., .F., NIL ), .f. )
        Index On TmpSalK ->cUcetMd +TmpSalK ->cSymbol To "Tmp\TmpSalK"

        nRecCount := 0
  TmpSalD ->( dbEval( {|| nRecCount++ }))
        Box_Make()

        nCount := 1
  Box_Thermo( 1, nCount, nRec
  Count, '< Okam§ik pros¡m ... >' ,;
                                  'Prob¡h  roŸn¡ uz vØrka saldokonta !')

        TmpSalD ->( dbSetRelation( 'TmpSalK'  , ;
                   { || TmpSalD ->cUcetMd +TmpSalD ->cSymbol } , ;
                       'TmpSalD ->cUcetMd +TmpSalD ->cSymbol' ) )
  TmpSalD ->( dbSkip( 0))

        TmpSalD ->( dbGoTop())

        DO WHILE !TmpSalD ->( Eof())

                IF TmpSalK ->lIsClose
                         TmpSalD ->lZparovano := .T.
                         TmpSalD ->( dbDelete())
                ENDIF

    Box_Thermo( 0, nCount, nRecCount)
    ( TmpSalD ->( dbSkip()), nCount++ )
        ENDDO

        TmpSalK ->( dbGoTop())

        DO WHILE !TmpSalK ->( Eof())
                IF( TmpSalK ->lIsClose, TmpSalK ->( dbDelete()), NIL)
    TmpSalK ->( dbSkip())
        ENDDO

        TmpSalD ->( __dbPack())
        TmpSalK ->( __dbPack())

  Box_Thermo( -1)

        dbCloseAll()

        BOX_Wait( "Vytvoýen¡ uz vØrky £spØçnØ probØhlo... " )



 */