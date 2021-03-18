**
**  Remarks
**  BanVyp_MAP() ->  FIN_poklad_map()
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


FUNCTION FIN_pokladhd_cpy(oDialog)
  LOCAL  nIn, cky
  LOCAL  cFile_in
  LOCAL  aFile_in := { {SysConfig('FINANCE:cDENIKFAPR'), 'FAKPRIHD'}, ;
                       {SysConfig('Finance:cDENIKFAVY'), 'FAKVYSHD'}  }
  local  zaklMena := SysConfig('Finance:cZaklMena')
  *
  local  lNEWrec  := if( IsNull(oDialog), .F., oDialog:lNEWrec )

  ** tmp **
  drgDBMS:open('POKLADHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('POKLADITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('FAKPRIHD')
  drgDBMS:open('FAKVYSHD')

  If .not. lNEWrec
    mh_COPYFLD( 'POKLADHD', 'POKLADHDw', .t., .t.)
    *
*-    pokladhdw ->ncencel_hd := pokladhd ->nCENZakCel
*-    pokladhdw ->ncenzah_hd := pokladhd ->ncenZahCel
    if( pokladHdw->nkurZahMen = 0, pokladHdw->nkurZahmen := 1, nil )

    POKLADHDw ->nCENZAK_OR := POKLADHD ->nCENZAKCEL
    POKLADHDw ->nCENZAH_OR := POKLADHD ->nCENZAHCEL
    *
    POKLADHDw ->nOSCISP_OR := POKLADHD ->nOSCISPRAC
    pokladhdw ->dporiz_or  := pokladhd ->dporizdok

    pokladms->( dbseek( pokladhd->npokladna,,'POKLADM1'))
    pokladhdw ->listuz_uc  := pokladms->listuz_uc

** errs    pokladhdw ->listuz_uc  := Equal(zaklMena, pokladhd->czkratmeny)    // czkratmenZ

    IF UCETSYS ->( DbSeek('F' +POKLADHD ->cOBDOBI,,'UCETSYS2'))
      POKLADHDw ->nROK    := UCETSYS ->nROK
      POKLADHDw ->nOBDOBI := UCETSYS ->nOBDOBI
    EndIf

    cky := StrZero(POKLADHD ->nDOKLAD,10)
    pokladit->(AdsSetOrder(1),dbsetscope(SCOPE_BOTH,cky),dbgotop())

    DO WHILE !POKLADIT ->( Eof())
      mh_COPYFLD('POKLADIT', 'POKLADITw', .t., .t.)
      POKLADITw ->cOBDOBI    := POKLADHDw ->cOBDOBI
      POKLADITw ->nROK       := POKLADHDw ->nROK
      POKLADITw ->nOBDOBI    := POKLADHDw ->nOBDOBI
      POKLADITw ->cOBDOBIDAN := POKLADHDw ->cOBDOBIDAN

      POKLADITw ->nCENZAK_OR := ;
         IF(Like ( '3?????', POKLADIT ->cUCET_UCT) .and. Empty( POKLADIT ->cDENIK_PAR), 0, ;
         If( POKLADMS ->lIsTUZ_UC, POKLADIT ->nUHRCELFAK, POKLADIT ->nCENZAKCEF ) )
      POKLADITw ->nCENZAH_OR := POKLADIT ->nUHRCELFAZ
      POKLADITw ->nKURZRO_OR := POKLADIT ->nKURZROZDF
      POKLADITw ->nDOKLAD_OR := POKLADIT ->( RecNo())
      POKLADITw ->nDOKLAD_IV := 0

      IF( nIn := AScan(aFile_in, {|X| x[1] = POKLADIT ->cDENIK_PAR})) <> 0
        cFile_in := aFile_in[nIn,2]

        IF (cFile_in) ->( DbSeek( POKLADIT ->nCISFAK,, AdsCtag(1) ))
          POKLADITw ->nDOKLAD_IV := (cFile_in) ->( RecNo())
          pokladitw ->cfile_iv   := cfile_in
          POKLADITw ->cZKRATMENF := IF( .not. Empty((cFile_in) ->cZKRATMENZ), ;
                                      (cFile_in) ->cZKRATMENZ, (cFile_in) ->cZKRATMENY )
        ENDIF
      ELSE
        POKLADITw ->cZKRATMENF := POKLADMS ->cZKRATMENY
      ENDIF

      POKLADIT ->(DbSkip())
    ENDDO
  ELSE

    if isobject(oDialog)                          .and. ;
       oDialog:drgDialog:cargo = drgEVENT_APPEND2 .and. ;
       .not. pokladhd->( eof())                   .and. ;
       pokladhd->nosCisPrac = 0                   .and. ;
       pokladit->( eof())

       oDialog:lok_append2 := lok_append2 := .t.
       mh_copyFld( 'pokladhd', 'pokladhdW', .t., .f.)

       ( POKLADHDw ->cUloha     := "F"                             , ;
         POKLADHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI           , ;
         POKLADHDw ->nROK       := uctOBDOBI:FIN:NROK              , ;
         POKLADHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI           , ;
         POKLADHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN        , ;
         POKLADHDw ->nDOKLAD    := FIN_range_KEY('POKLADHD')[2]    , ;
         POKLADHDw ->dPORIZDOK  := Date()                          , ;
         POKLADHDw ->dVYSTDOK   := Date()                          , ;
         POKLADHDw ->nKODZAOKRD := SysConfig( 'Finance:nRoundDph') , ;
         POKLADHDw ->cDENIK     := SysConfig( 'Finance:cDenikFIPO'), ;
         pokladhdw ->npocstav   := 0                                 )
       *
       ** musí se zanulovat
       pokladhdW ->ddatTisk     := ctod('  .  .  ')

    else

      mh_COPYFLD( 'POKLADMS', 'POKLADHDw', .t., .f. )

      ( POKLADHDw ->cUloha     := "F"                             , ;
        POKLADHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI           , ;
        POKLADHDw ->nROK       := uctOBDOBI:FIN:NROK              , ;
        POKLADHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI           , ;
        POKLADHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN        , ;
        POKLADHDw ->nPOKLADNA  := 0                               , ;
        POKLADHDw ->nDOKLAD    := FIN_range_KEY('POKLADHD')[2]    , ;
        POKLADHDw ->dPORIZDOK  := Date()                          , ;
        POKLADHDw ->cZKRATMENY := SysConfig( 'Finance:cZaklMena') , ;
        POKLADHDw ->cZKRATMENZ := SysConfig( 'Finance:cZaklMena') , ;
        POKLADHDw ->dVYSTDOK   := Date()                          , ;
        POKLADHDw ->nKODZAOKRD := SysConfig( 'Finance:nRoundDph') , ;
        POKLADHDw ->cDENIK     := SysConfig( 'Finance:cDenikFIPO'), ;
        POKLADHDw ->nNULLDPH   := 4                               , ;
        POKLADHDw ->nKURZAHMEN := 1                               , ;
        POKLADHDw ->nMNOZPREP  := 1                               , ;
        POKLADHDw ->nPROCDAN_1 := SeekSazDPH(1)                   , ;
        POKLADHDw ->nPROCDAN_2 := SeekSazDPH(2)                   , ;
        POKLADHDw ->nPROCDAN_3 := SeekSazDPH(3)                   , ;
        pokladhdw ->npocstav   := 0                                 )

      pokladhdw->ctyppohybu  := sysconfig('finance:ctyppohPOK')
     endif

     pokladhdW->cuUid_Zpra   := UuidToChar( UuidCreate() )
   ENDIF

   fin_vykdph_cpy('POKLADHDw')
RETURN(Nil)

*
** uložení pokladního dokladu v transakci **************************************
function fin_pokladhd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := fin_pokladhd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE

  _clearEventLoop(.t.)
return lDone



static function fin_pokladhd_wrt(odialog)
  local  mainOk    := .t., nrecor
  local  anFap     := {}, anFav := {}, anPok := {}, axFak := {}, anZal := {}, pa
  local  uctLikv, pokladKs
  local  isTuz     := Equal(sysConfig('Finance:cZaklMena'),pokladhdw->czkratMenZ) .or. ;
                                                    empty(pokladhdw->czkratMenZ)
  local  lno_inDPH := pokladhdW->lno_inDPH

  *
  local  ain_file := odialog:ain_file, nin, cfile_iv, npohyb_ms

  if( odialog:lnewRec,fin_pokladhd_typ(odialog:cmb_typDokl),nil)

  uctLikv  := UCT_likvidace():new(upper(pokladhdw->culoha) +upper(pokladhdw->ctypdoklad),.T.)
  pokladKs := fin_pokladks():new()  // .t. -jen objekt pro ukládání, ne npocSTav -

  pokladitw->(AdsSetOrder(0),dbgotop())

  *
  ** zálohy na pracovníka
  if pokladhdw->ncisOsoby <> 0
    if .not. pokza_za->(dbSeek(strZero(pokladhdw->ncisOsoby,6) +strZero(pokladhdw->npokladna,3),,'POKIN_02'))
      pokza_za->(dbAppend())
    endif
    aadd(anZal,pokza_za->(recNo()))
  endif

  do while .not. pokladitw->(eof())
    if(nin := ascan(ain_file,{|x| x[6] = pokladitw->cdenik_par})) <> 0
      pa := if(nin = 1,anFap,anFav)
      aadd(pa,pokladitw->ndoklad_iv)

      aadd(axFak, {pokladitw->(recno()), pokladitw->ndoklad_or, ain_file[nin,1], pokladitw->ndoklad_iv})
    else
      aadd(axFak, {pokladitw->(recno()), pokladitw->ndoklad_or, nil            , 0                    })
    endif
    aadd(anPok,pokladitw->_nrecor)
    pokladitw->(dbskip())
  enddo

  if(.not. odialog:lnewRec, pokladhd->(dbgoto(pokladhdw->_nrecor)),nil)
  mainOk := pokladms->(sx_rlock())                    .and. ;
            pokladhd->(sx_rlock())                    .and. ;
            pokza_za->(sx_rlock(anZal))               .and. ;
            fakprihd->(sx_rlock(anFap))               .and. ;
            fakvyshd->(sx_rlock(anFav))               .and. ;
            pokladit->(sx_rlock(anPok))               .and. ;
            ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo))


  if mainOk .and. fin_vykdph_rlo('pokladhdw') .and. pokladks:rlo(odialog:lnewRec)
    * modifikace hlavièky
    pokladhdw->ncenzakcel := pokladhdw->ncencel_hd +pokladhdw->ncencel_it
    pokladhdw->ncenzahcel := pokladhdw->ncenzah_hd +pokladhdw->ncenzah_it

    if(pokladhdw->ncisOsoby <> 0,fin_pokladhd_zal(),nil)

    if Equal(pokladhdw->ctypdoklad,'FIN_PODOPR')
      pokladhdw->nprijem  := pokladhdw->ncenzakcel
      pokladhdw->nprijemz := pokladhdw->ncenzahcel
    else
      pokladhdw->nvydej   := pokladhdw->ncenzakcel
      pokladhdw->nvydejz  := pokladhdw->ncenzahcel
    endif

    if(pokladhdw->_delrec <> '9', mh_copyfld('pokladhdw','pokladhd',odialog:lnewRec, .f.), nil)
    pokladitw->(dbgotop())

    do while .not. pokladitw->(eof())

      * 26.6.2015 zmìna pøedpisu úètování ddatPORIZ se neplnilo od roku 2007
      pokladitW->ddatPORIZ := pokladhdW->dporizDOK

      if .not. istuz
        pokladitw->nuhrcelfak := pokladitw->ncenzakcef
      endif

      if((nrecor := pokladitw->_nrecor) = 0, nil, pokladit->(dbgoto(nrecor)))
      if   pokladitw->_delrec = '9'
        if(nrecor = 0, nil,  pokladit->(dbdelete()))
      else
        mh_copyfld('pokladitw','pokladit',(nrecor=0), .f.)
        pokladit->ndoklad := pokladhd->ndoklad
      endif

      if .not. empty(cfile_iv := alltrim(pokladitw->cfile_iv))
        (cfile_iv)->(dbgoto(pokladitw->ndoklad_iv))

        if pokladitw->_delrec = '9'
          (cfile_iv)->nuhrcelfak -= pokladitw->ncenzak_or
          (cfile_iv)->nuhrcelfaz -= pokladitw->ncenzah_or
          (cfile_iv)->nkurzrozdf -= pokladitw->nkurzro_or
        else
          if istuz ; (cfile_iv)->nuhrcelfak += (pokladitw->nuhrcelfak -pokladitw->ncenzak_or)
          else     ; (cfile_iv)->nuhrcelfak += (pokladitw->ncenzakcef -pokladitw->ncenzak_or)
          endif

          if istuz ; (cfile_iv)->nuhrcelfaz += (pokladitw->nuhrcelfaz -pokladitw->ncenzah_or)
          else     ; (cfile_iv)->nuhrcelfaz += (pokladitw->nuhrcelfaz -pokladitw->ncenzah_or)
          endif

          (cfile_iv)->nkurzrozdf += (pokladitw->nkurzrozdf -pokladitw->nkurzro_or)
          if pokladitw->ddatuhrady > (cfile_iv)->dposuhrfak
            (cfile_iv)->dposuhrfak := pokladitw->ddatuhrady
          endif

          if cfile_iv = 'FAKVYSHD' .and. (cfile_iv)->cobdobidan = '00/00'
            (cfile_iv)->cobdobidan := pokladhd->codbodbidan
          endif

          *
          ** oprava pro nápoèet nuhrcekFak, nuhrcekFaz, nkurzRozdf
          pokladit->( dbcommit())
          cky := upper( (cfile_iv)->cdenik) +strZero((cfile_iv)->ncisFak,10)
          FIN_ban_pok_vzz_sum( cky, cfile_iv )
        endif
      endif

      pokladitw->(dbskip())
    enddo

    if(pokladhdw->_delrec = '9')  ;  uctLikv:ucetpol_del()
                                     fin_vykdph_wrt(NIL,.t.,'POKLADHD')
                                     pokladKs:pokladks_wrt()
                                     pokladhd->(dbdelete())
    else                          ;  if( lno_inDPH, nil, fin_vykdph_wrt(NIL,.f.,'POKLADHD'))
                                     uctLikv:ucetpol_wrt()
                                     pokladKs:pokladks_wrt()
    endif
    *
    ** modifikace stavu pokladny
    *
    if pokladms->lisTuz_uc
      npohyb_ms := if( pokladhdw->_delrec = '9', pokladhdw->ncenzakcel * (-1), ;
                       pokladhdw->ncenzakcel -pokladhdw->ncenzak_or   )
    else
      npohyb_ms := if( pokladhdw->_delrec = '9', pokladhdw->ncenzahcel * (-1), ;
                       pokladhdw->ncenzahcel -pokladhdw->ncenzah_or  )
    endif

    if pokladhdw->ntypDok = 1  ;  pokladms->dposPrijem := pokladhdw->dporizDok
                                  pokladms->nposPrijem += npohyb_ms
    else                       ;  pokladms->dposVydej  := pokladhdw->dporizDok
                                  pokladms->nposVydej  += npohyb_ms
    endif
    pokladms->naktStav := pokladms->npocStav +pokladms->nposPrijem -pokladms->nposVydej

  else
    drgMsg(drgNLS:msg('Nelze modifikovat POKLADNÍ DOKLAD, blokováno uživatelem ...'),,odialog:drgDialog)
  endif

  fakprihd->(dbunlock(),dbcommit())
   fakvyshd->(dbunlock(),dbcommit())
    pokladhd->(dbunlock(),dbcommit())
     pokladit->(dbunlock(),dbcommit())
      pokladms->(dbunlock(),dbcommit())
       pokza_za->(dbunlock(),dbcommit())
        ucetpol ->(dbunlock(),dbcommit())
return mainOk

*
**
static function fin_pokladhd_typ(drgComboBox)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin
  *
  local  pa    := {'PØÍJEM', 'VÝDEJ', 'zúèZÁL'}

  nin := ascan(values,{|x| x[1] = value })

  pokladhdw->ctypdoklad := values[nin,3]
  pokladhdw->ctyppohybu := values[nin,1]
  pokladhdw->ntypdok    := val(values[nin,4])
  pokladhdw->ctypdok    := if(pokladhdw->ntypdok <= 3, pa[pokladhdw->ntypdok], '')
*  pokladhdw->cdat_Odesl := mh_DateTimeXML()
*  pokladhdw->cdat_Trzby := pokladhdw->cdat_Odesl
  pokladhdw->(dbcommit())
return nil

*
** zrušení pokladního dokladu **
function fin_pokladhd_del(odialog)
  local  mainOk

  pokladhdw->_delrec := '9'
  pokladitw->(pokladitw->(AdsSetOrder(0),dbgotop()), dbeval({|| pokladitw->_delrec := '9'}))
  mainOk := fin_pokladhd_wrt(odialog)
return mainOk

*
** zálohy na pracovníka
static function fin_pokladhd_zal()
  local  typDok := pokladhdw->ntypDok, pohCel
  local  delRec := (pokladhdw->_delrec = '9')
  *
  local  isTuz  := Equal(SysConfig('Finance:cZaklMena'), pokladhdw->czkratMenz)

  pokza_za->npokladna  := pokladhdw->npokladna
  pokza_za->ncisOsoby  := pokladhdw->ncisOsoby
  pokza_za->nosCisPrac := pokladhdw->nosCisPrac

  if istuz
    pohCel := if(delRec, pokladhdw->ncenZakCel*(-1), pokladhdw->ncenZakCel -pokladhdw->ncenZak_OR)
  else
    pohCel := if(delRec, pokladhdw->ncenZahCel*(-1), pokladhdw->ncenZahCel -pokladhdw->ncenZah_OR)
  endif

  do case
  case(typDok = 1)  ;  pokza_za->nvrac_zal += pohCel
  case(typDok = 2)  ;  pokza_za->nprij_zal += pohCel
  case(typDok = 3)  ;  pokza_za->nzuct_zal += pohCel
  endcase
return .t.