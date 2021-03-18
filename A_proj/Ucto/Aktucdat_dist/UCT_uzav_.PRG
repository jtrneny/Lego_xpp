#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "Gra.ch"
#include "adsdbe.ch"
#include "drgRes.ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


#define   pa_step  { '... pøeúètování výnosù a nákladù ...'     , ;
                     '... uzavøení úèetních knih ...'           , ;
                     '... otevøení úèetních knih ...'           , ;
                     '... poèáteèní stavy úètù ...'             , ;
                     '... poèáteèní stavy nedokonèené výroby ...' }

static oxbp, nsize, nhight


*
**
function uctoUZAV_inTran( oxbp_therm, nrok_Uzv )
  local  lok := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    uctoUzav( oxbp_therm, nrok_Uzv )
    oSession_data:commitTransaction()

  RECOVER USING oError
    lok := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lok


static function UctoUZAV( oxbp_therm, nrok_Uzv )
  Local cScope
  LOCAL nRecCount, nCount, bOKtest
  LOCAL lROPO := .F., lVN89 := .F., nX
//        LOCAL cTMP      := fHomAdr() + '\Tmp\'
  LOCAL xKey, lNewStav
  local nRokUzv, nObdUzv
  local filter, m_filter, cnaklst
  local nn
  LOCAL nKcMDsum, nKcDALsum
  LOCAL cUCET_1,cUCET_3, cNAZP_21, cUCET_x
  local avyknv, avykpo, atmp
  local lgen, vykonyNv
  local oldOrd
  local coldKey1, coldKey2, coldKey3, coldKey4, coldKey5, coldKey6
  local nrozdil
  local zprava
  *
  local  nkeyCnt, nkeyNo

  oxbp   := oxbp_therm
  nsize  := oxbp_therm:currentSize()[1]
  nhight := oxbp_therm:currentSize()[2]

  drgDBMS:open('UcetKumU')
  drgDBMS:open('UcetKum')
  drgDBMS:open('ucetpocs')
  drgDBMS:open('Ucetpol')

  drgDBMS:open('UcRokUzv')
  drgDBMS:open('UcetPSNV')

  nRokUzv := nrok_Uzv // uctOBDOBI:UCT:NROK
  nObdUzv := SysConfig('Ucto:nLastObdUz') //ucetsys->nobdobi //uctOBDOBI:UCT:NOBDOBI

  xKey := StrZero( nRokUzv, 4) + StrZero( nObdUzv, 2)

  UcetKumU->(ads_setaof( format("nrok = %% .and. nobdobi = %%",{nRokUzv, nObdUzv})),dbgotop())
  UcetKum->(ads_setaof( format("nrok = %% .and. nobdobi = %%",{nRokUzv, nObdUzv})),dbgotop())

  UcetKumU ->( ADSsetorder( 'UCETK_02'))
//  UcetKumU ->( dbSETSCOPE( SCOPE_BOTH, xKEY))
  UcetKum ->( ADSsetorder( 'UCETK_01'))
//  UcetKum ->( dbSETSCOPE( SCOPE_BOTH, xKEY))

  IF drgIsYESNO(drgNLS:msg('Zpracovat úèetní uzávìrku ( zavøení a otevøení úèetních knih, otevøení poèáteèních stavù ) za rok' +Str( nRokUzv)+" ?"))

*****  Pøeúètování výnosù a nákladù

    do case
    case ucetuzv->ntypvnpu = 0    //Box_YesNo( "Výnosy a náklady, za£Ÿtov n¡ bez 8 a 9 (jen 5 a 6) ?") = 2
      bOKtest := {|| ( cUCET_1 == "5" .OR. cUCET_1 == "6"                      ;
                          .OR. cUCET_1 == "8" .OR. cUCET_1 == "9")              ;
                           .AND. ( cUCET_3 <> "999")                               ;
                            .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }

    case ucetuzv->ntypvnpu = 1
      bOKtest := {|| ( cUCET_1 == "5" .OR. cUCET_1 == "6" )                    ;
                           .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }
    otherwise
//        return
    endcase

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WR'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    UcetKumU ->( dbGoTop())
    nKcMDsum  := 0
    nKcDALsum := 0

    * 1 teplomìr
    nkeyCnt   := ucetkumu->( ads_getKeyCount(ADS_RESPECTFILTERS))
    nkeyNo    := 1

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

      uctouzav_pb(1, nkeyCnt, nkeyNo)
      nkeyNo++

      UcetKumU->( dbSkip())
    enddo

    UcRokUzv ->( mh_Append())

    xKEY := "13/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)

    UcRokUzv->cDenik    := 'WR'
    UcRokUzv->cObdobi   := xKEY
    UcRokUzv->nRok      := nRokUzv
    UcRokUzv->nObdobi   := 13
    UcRokUzv->cUcetMD   := UCETUZV->cucet_MVU     //"710000"
    UcRokUzv->nKcDALksR := ( nKcMDsum - nKcDALsum) *(-1)
    UcRokUzv->nKcDALpsR := ( nKcMDsum - nKcDALsum) *(-1)
    UcRokUzv->lGENER    := .T.

    UcRokUzv->( dbUnlock())

    do case
    case ucetuzv->ntypuzv = 0    //drgIsYESNO(drgNLS:msg("Bude provádìna úèetní roèní uzávìrka bez ROPO ?"))
      bOKtest := {|| ( cUCET_1 == "0" .OR. cUCET_1 == "1" .OR. cUCET_1 == "2"        ;
                                        .OR. cUCET_1 == "3" .OR. cUCET_1 == "4" .OR. cUCET_1 == "7")   ;
                                                    .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }
    case ucetuzv->ntypuzv = 1
      bOKtest := {|| ( cUCET_1 == "0" .OR. cUCET_1 == "1" .OR. cUCET_1 == "2"          ;
                                       .OR. cUCET_1 == "3" .OR. cUCET_1 == "4" .OR. cUCET_1 == "7"    ;
                                        .OR. cUCET_1 == "9")                                          ;
                                          .AND. ( cUCET_3 <> "999")                                       ;
                                                     .AND. ( UcetKumU ->nKcMDksR <> UcetKumU ->nKcDALksR) }
    otherwise
//        return

    endcase

//  m_filter := "nrok = '%%' .and. cdenik = %%", filter, x
//  if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)
//  filter := format(m_filter,{nRokUzv,'WO'})


*****  Uzavøení úèetních knih

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WZ'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    UcetKumU ->( dbGoTop())
    nKcMDsum  := 0
    nKcDALsum := 0

    * 2 teplomìr
    nkeyCnt   := ucetkumu->( ads_getKeyCount(ADS_RESPECTFILTERS))
    nkeyNo    := 1

    do while !UcetKumU ->( Eof())
      cUCET_1 := SubStr( UcetKumU ->cUcetMD, 1, 1)
      cUCET_3 := SubStr( UcetKumU ->cUcetMD, 1, 3)
      if  Eval( bOKtest)
        UcRokUzv ->( mh_Append())
        xKEY := "13/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)
        UcRokUzv ->cDenik    := 'WZ'
        UcRokUzv ->cObdobi   := xKEY
        UcRokUzv ->nRok      := nRokUzv
        UcRokUzv ->nObdobi   := 13
        UcRokUzv ->cUcetMD   := UcetKumU ->cUcetMD
        UcRokUzv ->cUcetDAL  := UCETUZV->cucet_DUK    //"702000"
        UcRokUzv ->nKcMDksR  := UcetKumU ->nKcMDksR *(-1)
        UcRokUzv ->nKcDALksR := UcetKumU ->nKcDALksR *(-1)

        nKcMDsum  += UcetKumU ->nKcMDksR
        nKcDALsum += UcetKumU ->nKcDALksR
        UcRokUzv ->(dbUnlock())
      ENDIF

      uctouzav_pb(2, nkeyCnt, nkeyNo)
      nkeyNo++

      UcetKumU ->( dbSkip())
    ENDDO

    UcRokUzv->( mh_Append())

    xKEY := "13/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)
    UcRokUzv->cDenik    := 'WZ'
    UcRokUzv->cObdobi   := xKEY
    UcRokUzv->nRok      := nRokUzv
    UcRokUzv->nObdobi   := 13
    UcRokUzv->cUcetMD   := UCETUZV->cucet_MUK     //"710000"
    UcRokUzv->cUcetDAL  := UCETUZV->cucet_DUK     //"702000"
    UcRokUzv->nKcDALksR := (nKcMDsum - nKcDALsum) * (-1)
    UcRokUzv ->lGENER   := .T.

    UcRokUzv->( dbUnlock())


*****  Otevøení úèetních knih

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WO'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    UcetKumU ->( dbGoTop())
    nKcMDsum  := 0
    nKcDALsum := 0

    * 3 teplomìr
    nkeyCnt   := ucetkumu->( ads_getKeyCount(ADS_RESPECTFILTERS))
    nkeyNo    := 1

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
        UcRokUzv ->cUcetDAL  := UCETUZV->cucet_DOK    //"701000"
//        UcZOtevr ->P         := ")"

        UcRokUzv ->nKcMDksR  := UcetKumU ->nKcMDksR
        UcRokUzv ->nKcDALksR := UcetKumU ->nKcDALksR
        UcRokUzv ->nKcMDpsR  := UcetKumU ->nKcMDksR
        UcRokUzv ->nKcDALpsR := UcetKumU ->nKcDALksR

        nKcMDsum  += UcetKumU ->nKcMDksR
        nKcDALsum += UcetKumU ->nKcDALksR
        UcRokUzv ->(dbUnlock())
      ENDIF

      uctouzav_pb(3, nkeyCnt, nkeyNo)
      nkeyNo++

      UcetKumU ->( dbSkip())
    ENDDO

    UcRokUzv->( mh_Append())

    xKEY := "14/" +SubStr( AllTrim( Str( nRokUzv)), 3, 2)
    UcRokUzv->cDenik    := 'WO'
    UcRokUzv->cObdobi   := xKEY
    UcRokUzv->nRok      := nRokUzv
    UcRokUzv->nObdobi   := 14
    UcRokUzv->cUcetMD   := UCETUZV->cucet_MOK    //"431000"
    UcRokUzv->cUcetDAL  := UCETUZV->cucet_DOK    //"701000"
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

    if ucetuzv->ndoplnps = 1    //drgIsYESNO(drgNLS:msg('Doplnit poèáteèní stavy pro rok' +Str( nRokUzv+1)+" ?"))

      ucetpocs->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'WP'})),dbgotop())
      ucetpocs->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
      ucetpocs->(ads_clearaof(),dbgotop())

    endif

    * 4 teplomìr
    nkeyCnt   := ucrokuzva->( ads_getKeyCount(ADS_RESPECTFILTERS))
    nkeyNo    := 1

    do while !UcRokUzva ->( Eof())
      MH_CopyFLD( 'UcRokUzva', 'UcRokUzv', .T.)
      xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
      UcRokUzv->cUloha    := "U"
      UcRokUzv->cTask     := "UCT"
      UcRokUzv->cDenik    := 'WP'
      UcRokUzv->cObdobi   := xKEY
      UcRokUzv->nRok      := nRokUzv +1
      UcRokUzv->nObdobi   := 1

      UcRokUzv->cUcetMD   := IF( UcRokUzv->cUcetMD == UCETUZV->cucet_DPS    ;
                                              ,UCETUZV->cucet_MPS, UcRokUzv->cUcetMD)
      UcRokUzv->cUcetDAL  := IF( UcRokUzv->cUcetDAL == UCETUZV->cucet_DPS   ;
                                              ,UCETUZV->cucet_MPS, UcRokUzv->cUcetDAL)

      UcRokUzv->nKcMDksR  := 0
      UcRokUzv->nKcDALksR := 0
      UcRokUzv ->(dbUnlock())

      if( ucetuzv->ndoplnps = 1, MH_CopyFLD( 'UcRokUzv', 'ucetpocs', .t.), nil)

      uctouzav_pb(4, nkeyCnt, nkeyNo)
      nkeyNo++

      UcRokUzva->( dbSkip())
    ENDDO

    UcRokUzv->( dbUnlock())

/*
***** Uzavøení úèetních knih

    UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv, 'WZ'})),dbgotop())
    UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
    UcRokUzv->(ads_clearaof(),dbgotop())

    UcRokUzva->(dbgotop())                                    0

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

*/
    UcRokUzva->(ads_clearaof(),dbgotop())
    UcRokUzva->( dbCloseAre())

***** Poèáteèní stavy nedokonèené výroby
    if ucetuzv->nvytpsnv > 0     // drgIsYESNO(drgNLS:msg('Vytvoøit poèáteèní stavy nedokonèené výroby pro rok' +Str( nRokUzv+1)+" ?"))

      UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'WX'})),dbgotop())
      UcRokUzv->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
      UcRokUzv->(ads_clearaof(),dbgotop())

      ucetpocs->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'WX'})),dbgotop())
      ucetpocs->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
      ucetpocs->(ads_clearaof(),dbgotop())

      ucetpol->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'WX'})),dbgotop())
      ucetpol->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
      ucetpol->(ads_clearaof(),dbgotop())

      do case
      case ucetuzv->nvytpsnv = 1
        drgDBMS:open('autom_it')
        vykonyNv  := 'nRok = %% .and. nObdobi = %% .and. ntyp_aut = 1'
        condition := format( vykonyNv, { nrokuzv, nobduzv })
        autom_it->( ads_setAof( condition ), dbgoTop())

        avyknv := avykpo := atmp := {}
        cnaklst := ''

        do while .not. autom_it->(eof())
          avyknv := mh_Token(autom_it->cmrozp_co, ',')

          for nn := 1 to len(avyknv)
            atmp := if( at( '..', avyknv[nn]) > 0, mh_Token(avyknv[nn], '..')  ;
                        , {avyknv[nn],avyknv[nn]})
            if atmp[1] >= '400' .and. atmp[2] <= '699'
              AAdd( avykPo, atmp)

              cnaklst += " ( cnazpol2 >= '" + Padr(atmp[1],8) +"' .and. cnazpol2 <= '" + Padr(atmp[2],8) +"') .or. "
            endif
          next

          autom_it->(dbskip())
        enddo


        filter := format("nrok = %% .and. nobdobi = %% .and. nKcMDksR <> nKcDALksR .and."    ;
                          + "( Left(cucetmd,1) = '5' .or. Left(cucetmd,1) = '6') .and. "     ;
                            + "( Left(cnazpol2,1) = '4' .or. Left(cnazpol2,1) = '5' .or. "   ;
                             +" Left(cnazpol2,1) = '6')", {nRokUzv,nObdUzv})
        filter += " .and. ("+ Left( cnaklst, Len(cnaklst)- 6) +")"

        UcetKum->(ads_setaof( filter),dbgotop())
        oldOrd := UcetKum->(OrdSetFocus('UCETK_14'))
        UcetKum->(dbTotal(drgINI:dir_USERfitm+userWorkDir() +'\UCKUMUZ1w',    ;
                           {|| UPPER(cUcetMD) +UPPER(cNazPol1) +UPPER(cNazPol2)},    ;
                            {'nKcMDksR','nKcDALksR'}))

        drgDBMS:open('UCKUMUZ1w',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
        UCKUMUZ1w ->( dbGoTop())
        * 5 teplomìr
        nkeyCnt   := UCKUMUZ1w->( ads_getKeyCount(ADS_RESPECTFILTERS))
        nkeyNo    := 1

        do while !UCKUMUZ1w ->( Eof())
          UcRokUzv ->( mh_Append())

          xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
          UcRokUzv->cObdobi   := xKEY
          UcRokUzv->nRok      := nRokUzv +1
          UcRokUzv->nObdobi   := 1
          UcRokUzv->cTask     := 'UCT'
          UcRokUzv->cUloha    := 'U'
          UcRokUzv->cDenik    := "WX"

          UcRokUzv->cUcetMD   := IF( UCKUMUZ1w ->cUcetMD  == UCETUZV->cucet_MNV      ;
                                      , UCETUZV->cucet_DNV, UCKUMUZ1w ->cUcetMD )

          UcRokUzv ->nKcMDpsR  := UCKUMUZ1w ->nKcMDksR
          UcRokUzv ->nKcDALpsR := UCKUMUZ1w ->nKcDALksR

          UcRokUzv ->cnazpol1  := UCKUMUZ1w ->cnazpol1
          UcRokUzv ->cnazpol2  := UCKUMUZ1w ->cnazpol2
          UcRokUzv->cNazPol2   := AllTrim( Str( Val( UcRokUzv->cNazPol2) - 300))

          MH_CopyFLD( 'UcRokUzv', 'ucetpocs', .t.)

          UcRokUzv ->(dbUnlock())
          ucetpocs->( dbUnLock())

          uctouzav_pb(5, nkeyCnt, nkeyNo)
          nkeyNo++

          UCKUMUZ1w ->( dbSkip())
        enddo

        oldOrd := UcetKum->(OrdSetFocus('UCETK_15'))
        UcetKum->(dbTotal(drgINI:dir_USERfitm+userWorkDir() +'\UCKUMUZ2w',    ;
                           {|| UPPER(cUcetMD) +UPPER(cNazPol1)},    ;
                            {'nKcMDksR','nKcDALksR'}))

        drgDBMS:open('UCKUMUZ2w',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
        UCKUMUZ2w ->( dbGoTop())
        * 6 teplomìr
        nkeyCnt   := UCKUMUZ2w->( ads_getKeyCount(ADS_RESPECTFILTERS))
        nkeyNo    := 1

        do while !UCKUMUZ2w ->( Eof())
          UcRokUzv ->( mh_Append())

          xKEY := "01/" +SubStr( AllTrim( Str( nRokUzv+1)), 3, 2)
          UcRokUzv->cObdobi   := xKEY
          UcRokUzv->nRok      := nRokUzv +1
          UcRokUzv->nObdobi   := 1
          UcRokUzv->cTask     := 'UCT'
          UcRokUzv->cUloha    := 'U'
          UcRokUzv->cDenik    := "WX"

          UcRokUzv->cUcetMD   := IF( UCKUMUZ2w ->cUcetMD  == UCETUZV->cucet_MNV      ;
                                      , UCETUZV->cucet_DNV, UCKUMUZ2w ->cUcetMD )

          UcRokUzv ->nKcMDpsR  := UCKUMUZ2w ->nKcMDksR  * (-1)
          UcRokUzv ->nKcDALpsR := UCKUMUZ2w ->nKcDALksR * (-1)

          UcRokUzv ->cnazpol1  := UCKUMUZ2w ->cnazpol1

          MH_CopyFLD( 'UcRokUzv', 'ucetpocs', .t.)

          UcRokUzv ->(dbUnlock())
          ucetpocs->( dbUnLock())

          uctouzav_pb(5, nkeyCnt, nkeyNo)
          nkeyNo++

          UCKUMUZ2w ->( dbSkip())
        enddo

        UcetKum->(ads_clearaof(),dbgotop())
        UcetKum->(OrdSetFocus(oldOrd))

      case ucetuzv->nvytpsnv = 2 .or. ucetuzv->nvytpsnv = 3
        UcetKum->(ads_setaof( format("nrok = %% .and. nobdobi = %% .and. Left(cucetmd,3) = '%%' .and. cnazpol3 <> '        '",{nRokUzv,nObdUzv,'611'})),dbgotop())
        oldOrd := UcetKum->(OrdSetFocus('UCETK_13'))
        UcetKum->(dbTotal(drgINI:dir_USERfitm+userWorkDir() +'\UCKUMUZ1w',    ;
                           {|| UPPER(cNazPol1) +UPPER(cNazPol2) +UPPER(cNazPol3)},    ;
                            {'nKcMDksR','nKcDALksR'}))

//        oldOrd := UcetKum->(OrdSetFocus('UCETK_16'))
//        UcetKum->(dbTotal(drgINI:dir_USERfitm+userWorkDir() +'\UCKUMUZ1w',    ;
//                           {|| UPPER(cUcetMD) +UPPER(cNazPol1) +UPPER(cNazPol2) +UPPER(cNazPol3)},    ;
//                            {'nKcMDksR','nKcDALksR'}))


        UcetKum->(ads_clearaof(),dbgotop())
        UcetKum->(OrdSetFocus(oldOrd))

        drgDBMS:open('UCKUMUZ1w',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
        UCKUMUZ1w ->( dbGoTop())
        do while .not. UCKUMUZ1w->( eof())
          if( UCKUMUZ1w->nKcMDksR = UCKUMUZ1w->nKcDALksR, UCKUMUZ1w->(dbDelete()), nil)
          UCKUMUZ1w ->( dbSkip())
        enddo

        drgDBMS:open('UCKUMUZ2w',.T.,.T.,drgINI:dir_USERfitm);ZAP
        UCKUMUZ2w ->( OrdSetFocus('UCKUMUZ2w1'))

        UcetKum->(ads_setaof( format("nrok = %% .and. nobdobi = %% .and. Left(cucetmd,2) <> '%%'.and. Left(cucetmd,4) <> '%%'.and.( Left(cucetmd,1) = '%%'.or. Left(cucetmd,1) = '%%').and. cnazpol3 <> '        '",{nRokUzv,nObdUzv,'60','5999','5','6'})),dbgotop())
        do while .not. UcetKum->( eof())
          if UCKUMUZ1w->( dbSeek( Upper(UcetKum->cnazpol1) +Upper(UcetKum->cnazpol2) +Upper(UcetKum->cnazpol3),,'UCKUMUZ1w1'))
            MH_CopyFLD( 'UcetKum','UCKUMUZ2w',.T.)
          endif
          UcetKum->( dbSkip())
        enddo
        UcetKum->(ads_clearaof(),dbgotop())

        UCKUMUZ2w ->( dbGoTop())
        nX := 0
        coldKey1 := UCKUMUZ2w->cnazpol1
        coldKey2 := UCKUMUZ2w->cnazpol2
        coldKey3 := UCKUMUZ2w->cnazpol3
        coldKey4 := UCKUMUZ2w->cnazpol4
        coldKey5 := UCKUMUZ2w->cnazpol5
        coldKey6 := UCKUMUZ2w->cnazpol6

        nKcMDsum  := 0
        nKcDALsum := 0

        * 5 teplomìr
        nkeyCnt   := uckumuz2w->( lastRec())
        nkeyNo    := 1

        drgDBMS:open('UcRokUzv1w',.T.,.T.,drgINI:dir_USERfitm);ZAP

        do while .not. UCKUMUZ2w->( eof())
          nX++
          if( Left( UCKUMUZ2w->cUcetMD,2) = "60" .or. Left( UCKUMUZ2w->cUcetMD,3) = "621", UCKUMUZ2w->nKcDALKSR := 0 , nil)

          if UCKUMUZ2w->nKcMDksR <> 0 .or. UCKUMUZ2w->nKcDALksR <> 0
            UcRokUzv1w ->( mh_Append())
            ModiPNV( nRokUzv,'MD',nX)
            UcRokUzv1w->cUcetMD   := Left(UCKUMUZ2w ->cUcetMD,5) + "9"
            UcRokUzv1w->nKcMDpsR  := UCKUMUZ2w->nKcMDksR
            UcRokUzv1w->nKcDALpsR := UCKUMUZ2w->nKcDALksR
            UcRokUzv1w->cnazpol1 := coldKey1
            UcRokUzv1w->cnazpol2 := coldKey2
            UcRokUzv1w->cnazpol3 := coldKey3
            UcRokUzv1w->cnazpol4 := coldKey4
            UcRokUzv1w->cnazpol5 := coldKey5
            UcRokUzv1w->cnazpol6 := coldKey6
//            MH_CopyFLD( 'UcRokUzv', 'ucetpocs1w', .t.)

            if coldKey3 = UCKUMUZ2w->cnazpol3
              nKcMDsum  += UCKUMUZ2w->nKcMDKSR
              nKcDALsum += if( Left( UCKUMUZ2w->cUcetMD,3) = "611", UCKUMUZ2w->nKcDALKSR, 0)
            else
              nrozdil := if( nKcDALsum <> nKcMDsum, nKcDALsum - nKcMDsum, 0)
              lgen := nrozdil <> 0
              if lgen
                nX++
                UcRokUzv1w->( mh_Append())
                ModiPNV( nRokUzv,'DAL',nX)
                UcRokUzv1w->cUcetMD   := UCETUZV->cucet_MNV
                UcRokUzv1w->nKcMDpsR  := nrozdil
                UcRokUzv1w->cnazpol1 := coldKey1
                UcRokUzv1w->cnazpol2 := coldKey2
                UcRokUzv1w->cnazpol3 := coldKey3
                UcRokUzv1w->cnazpol4 := coldKey4
                UcRokUzv1w->cnazpol5 := coldKey5
                UcRokUzv1w->cnazpol6 := coldKey6
//                MH_CopyFLD( 'UcRokUzv', 'ucetpocs1w', .t.)

//                UcRokUzv->( dbUnLock())
//                ucetpocs->( dbUnLock())
              endif

              coldKey1 := UCKUMUZ2w->cnazpol1
              coldKey2 := UCKUMUZ2w->cnazpol2
              coldKey3 := UCKUMUZ2w->cnazpol3
              coldKey4 := UCKUMUZ2w->cnazpol4
              coldKey5 := UCKUMUZ2w->cnazpol5
              coldKey6 := UCKUMUZ2w->cnazpol6
              nKcMDsum  := UCKUMUZ2w->nKcMDKSR
              nKcDALsum := if( Left( UCKUMUZ2w->cUcetMD,3) = "611", UCKUMUZ2w->nKcDALKSR, 0)
            endif
          endif

          uctouzav_pb(5, nkeyCnt, nkeyNo)
          nkeyNo++

          UCKUMUZ2w->( dbSkip())
        enddo

//        UcRokUzv->(ads_clearaof(),dbgotop())
//        UcRokUzv->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'WX'})),dbgotop())
        UcRokUzv1w->(OrdSetFocus('UCROKUZ1w1'))
        UcRokUzv1w->(dbTotal(drgINI:dir_USERfitm+userWorkDir() +'\UCROKUZV2w',    ;
                             {|| UPPER(cUcetMD) +UPPER(cNazPol1)},    ;
                             {'nKcMDpsR','nKcDALpsR'}))

//        UcRokUzv->(ads_clearaof(),dbgotop())
//        UcRokUzv->(OrdSetFocus(oldOrd))

        drgDBMS:open('UCROKUZV2w',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
        UCROKUZV2w ->( dbGoTop())
        do while .not. UCROKUZV2w->( eof())
          UcRokUzv2w->nKcMDpsR  := UcRokUzv2w->nKcMDpsR *(-1)
          UcRokUzv2w->nKcDALpsR := UcRokUzv2w->nKcDALpsR *(-1)
          UcRokUzv2w->cnazpol2 := ''
          UcRokUzv2w->cnazpol3 := ''
          UcRokUzv2w->cnazpol4 := ''
          UcRokUzv2w->cnazpol5 := ''
          UcRokUzv2w->cnazpol6 := ''
          MH_CopyFLD( 'UcRokUzv2w','UcRokUzv1w', .t.)

          UCROKUZV2w ->( dbSkip())
        enddo

        UCROKUZV2w->(dbCloseArea( ))

        UcRokUzv1w->(OrdSetFocus('UCROKUZ1w2'))
        UcRokUzv1w->(dbTotal(drgINI:dir_USERfitm+userWorkDir() +'\UCROKUZV2w',    ;
                             {|| UPPER(cUcetMD) +UPPER(cNazPol1)+UPPER(cNazPol2)+UPPER(cNazPol3)+UPPER(cNazPol4)+UPPER(cNazPol5)+UPPER(cNazPol6)},    ;
                             {'nKcMDpsR','nKcDALpsR'}))

        drgDBMS:open('UCROKUZV2w',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
        UCROKUZV2w ->( dbGoTop())

        nn := 0

        do while .not. UCROKUZV2w->( eof())
          nn++
          MH_CopyFLD( 'UcRokUzv2w','UcRokUzv', .t.)

          if ucetuzv->nvytpsnv = 2
            MH_CopyFLD( 'UcRokUzv2w','ucetpocs', .t.)
          else
            MH_CopyFLD( 'UcRokUzv2w','ucetpol', .t.)

            ucetpol->ndoklad  := ucetpol->nrok*100+ucetpol->nobdobi
            ucetpol->norditem := nn
            ucetpol->cText    := "Poè.stav NV " + Str(ucetpol->nrok,4)
            ucetpol->nkcmd    := UcRokUzv2w->nKcMDpsR
            ucetpol->nkcdal   := UcRokUzv2w->nKcDALpsR
          endif

          UCROKUZV2w ->( dbSkip())
        enddo

      case ucetuzv->nvytpsnv = 4

      endcase

/*      Ucetpol->(ads_setaof( format("nrok = %% .and. cdenik = '%%'",{nRokUzv+1, 'X'})),dbgotop())
      Ucetpol->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
      Ucetpol->(ads_clearaof(),dbgotop())

      UcetPSNV->( dbGoTop())
      do while !UcetPSNV->( Eof())
        MH_CopyFLD( 'UcetPSNV','ucetpol',.T.)
        ucetpol->( dbUnLock())
        ucetpsnv->( dbSkip())
      enddo
      UcetPSNV->( dbUnLock())
*/
    endif

    ucetkumu->( ads_clearAof())
    ucetkum ->( ads_clearAof())
    ucetpocs->( ads_clearAof())
    ucetpol ->( ads_clearAof())
**
    if ucetuzv->ntypuzvr = 1
      zprava := 'zpracování roèní uzávìrky bylo dokonèeno vèetnì uzavøení hospodáøského roku'
    else
      zprava := 'zpracování roèní uzávìrky bylo dokonèeno'
    endif

//    oxbp:setCaption( zprava )
//    (tone(100,13), tone(200,13), tone(300,13), tone(500,16))
//    sleep(10)
    oxbp:setCaption('')

    drgMsgBox(drgNLS:msg(zprava), XBPMB_INFORMATION)

    ucrokuzv->( dbCloseAre())

  endif
RETURN( NIL)


static function ModiPNV( nRok, typ, it)
  local nRokUZ

  nRokUZ := nRok +1

  xKEY := "01/" +SubStr( AllTrim( Str( nRokUZ)), 3, 2)
  UcRokUzv1w->cObdobi   := xKEY
  UcRokUzv1w->nRok      := nRokUZ
  UcRokUzv1w->nObdobi   := 1
  UcRokUzv1w->cUloha    := "U"
  UcRokUzv1w->cTask     := "UCT"
  UcRokUzv1w->cDenik    := "WX"

/*
  xKEY := "01/" +SubStr( AllTrim( Str( nRokUZ)), 3, 2)
  UcetPSNV->cObdobi   := xKEY
  UcetPSNV->nRok      := nRokUZ
  UcetPSNV->nObdobi   := 1
  UcetPSNV->cDenik    := "X"
  UcetPSNV->nDoklad   := (nRokUZ) * 100
  UcetPSNV->nOrdItem  := it
  UcetPSNV->nOrdUcto  := if( typ = 'MD', 1, 2)
  UcetPSNV->cTyp_R    := typ
  UcetPSNV->dDatPoriz := Date()
  UcetPSNV->cUloha    := "U"
  UcetPSNV->cText     := "Poè.stav NV " + Str(nRokUZ,4)
//  UcetPSNV->cUcetMD   := UCETUZV->cucet_MNV    //"613999"

*/
  if typ = "DAL"
    UcRokUzv1w->cnazpol3  := ''
  endif

return( nil)



static function uctouzav_pb(nstep_by, nkeyCnt, nkeyNo)
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  local  cinfo          := pa_step[nstep_by]
  local  nx_info        := ( (nSize/2) -(len(cinfo) *drgINI:fontW)/2 ) +20
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  if newPos < (nSize/2) -20
    GraGradient( ops                , ;
                 { newPos+1,2 }, ;
                 { { nsize -newPos, nhight }}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif

  GraStringAt( ops, {nx_info,6}, cinfo )
  GraStringAt( oPS, {20,6}, prc)
//  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.


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