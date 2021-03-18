**
**  Remarks
**  BanVyp_MAP() ->  FIN_banvyp_map()
**  BanVyp_DoV() ->  FIN_banvyp_dov()
**

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "Thread.ch"

//
#include "..\FINANCE\FIN_finance.ch"


function ban_istuz_uc()
  static zaklMena

  if(IsNull(zaklMena), zaklMena := SysConfig('Finance:cZaklMena'), nil)
return Equal(zaklMena, BANVYPHDw->cZKRATMENY)


*--- FUNCTION FIN_BANVYPHD_BC()  ;  RETURN( FIN_MAIN_INF( 'BANVYPHD'))

FUNCTION FIN_BANVYPIT_BC(nCOLUMn,typ_dok)
  LOCAL  xRETval := 0
  STATIC cZAKLmena

  cZAKLmena := IsNull(cZAKLmena, SysConfig('Finance:cZaklMena'))

  * SCR *
  DO CASE
  CASE nCOLUMn == 1
    IF (Like('3?????', BANVYPIT ->cUCET_UCT) .and. Empty(BANVYPIT ->cDENIK_PAR))
      xRETval := 301
    ENDIF
  CASE nCOLUMn == 8
    xRETval := IF(BANVYPIT ->nTYPOBRATU = 1, 304, 305 )

  * CRD *
  CASE nCOLUMn == 11
    xRETval := IF( Empty(BANVYPITw ->mTREE_VIEW), 0, Bin2Var(BANVYPITw ->mTREE_VIEW))
  CASE nCOLUMn == 13
    IF (Like( '3?????', BANVYPITw ->cUCET_UCT) .and. BANVYPITw ->nDOKLAD_IV == 0 )
      xRETval := '?_________'
    ELSE
      xRETval := Str(BANVYPITw ->nCISFAK)
    ENDIF
  CASE nCOLUMn == 16 .or. nCOLUMn = 160
    IF( BANVYPITw ->nSUBCOUNT = 0 )
      IF nCOLUMn == 16
        xRETval := IF(C_BANKUc ->lISTUZ_UC  , BANVYPITw ->nCENZAKCEL, BANVYPITw ->nCENZAHCEL)
      ELSE
        xRETval := IF(Equal(cZAKLmena, BANVYPHDw ->cZKRATMENY), BANVYPITw ->nCENZAKCEL, BANVYPITw ->nCENZAHCEL)
      ENDIF
    ENDIF
  CASE nCOLUMn == 18
    xRETval := IF(BANVYPITw ->nTYPOBRATU = 1, 304, 305 )

  ENDCASE
Return(xRETval)


**
*
** uložení babkovního výpisu v transakci **************************************
function fin_banvyp_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := fin_banvyp_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


function FIN_banvyp_cpy(oDialog,vzz)
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)
  local  nIn, cky
  local  cFile_in
  local  aFile_in := { {SysConfig('FINANCE:cDENIKFAPR'), 'FAKPRIHD', 'FPRIHD1'   }, ;
                       {SysConfig('Finance:cDENIKFAVY'), 'FAKVYSHD', 'FODBHD1'   }, ;
                       {                          'MC' , 'MZDZAVHD', 'MZDZAVHD01'}  }

  if .not. lNEWrec
    mh_COPYFLD( 'BANVYPHD', 'BANVYPHDw', .t., .t.)

    * nìkdo nám pøepne tag na BANKVY_6
    if .not. banvypit->(dbscope()) .or. upper(banvypit->(ordSetFocus())) <> 'BANKVY_7'
      cky := upper(banvyphd->cdenik) +strZero(banvyphd ->ndoklad,10)

      banvypit->(ordSetFocus('BANKVY_7'), dbsetscope(SCOPE_BOTH, cky), DbGoTop() )
    endif

    IF IsNull(vzz) .and. .not. Empty(BANVYPHD ->cBANK_UCT)
      C_BANKUC ->( DbSeek(BANVYPHD ->cBANK_UCT))
      BANVYPHDw ->cZKRATMENY := C_BANKUC ->cZKRATMENY
    ENDIF

    IF UCETSYS ->( DbSeek('F' +BANVYPHD ->cOBDOBI,,'UCETSYS2'))
      BANVYPHDw ->nROK    := UCETSYS ->nROK
      BANVYPHDw ->nOBDOBI := UCETSYS ->nOBDOBI
    EndIf

    BANVYPIT ->( DbGoTop())

    DO WHILE !BANVYPIT ->( Eof())
      mh_COPYFLD('BANVYPIT', 'BANVYPITw', .t., .t.)
      BANVYPITw ->cOBDOBI    := BANVYPHDw ->cOBDOBI
      BANVYPITw ->nROK       := BANVYPHDw ->nROK
      BANVYPITw ->nOBDOBI    := BANVYPHDw ->nOBDOBI
      BANVYPITw ->cOBDOBIDAN := BANVYPHDw ->cOBDOBIDAN

      IF vzz = 'ban'
        BANVYPITw ->nCENZAK_OR := ;
           IF(Like ( '3?????', BANVYPIT ->cUCET_UCT) .and. Empty( BANVYPIT ->cDENIK_PAR), 0, ;
           If( C_BANKUc ->lIsTUZ_UC   , BANVYPIT ->nUHRCELFAK, BANVYPIT ->nCENZAKCEF ) )

      * platí pro vzz/uhr
      ELSE
         BANVYPITw ->nCENZAK_OR := ;
            If(Like ( '3?????', BANVYPIT ->cUcet_UCT) .and. Empty( BanVypIT ->cDenik_PAR), 0, ;
            If( FIN_banvyphd_vzz_TUZ(), BANVYPIT ->nUHRCELFAK, BANVYPIT ->nCENZAKCEF ) )
      ENDIF

      banvypitw->ncenzak_or  := banvypit->nuhrcelfak
      banvypitw->ncenzah_or  := banvypit->nuhrcelfaz
      banvypitw->nkurzro_or  := banvypit->nkurzrozdf
      banvypitw->ndoklad_or  := banvypit->(recNo())
      banvypitw->ndoklad_iv  := 0

      IF( nIn := AScan(aFile_in, {|X| x[1] = BANVYPIT ->cDENIK_PAR})) <> 0
        cFile_in := aFile_in[nIn,2]

        IF (cFile_in) ->( DbSeek( BANVYPIT ->nCISFAK,, AdsCtag(1) ))
          BANVYPITw ->nDOKLAD_IV := (cFile_in) ->( RecNo())
          BANVYPITw ->cFILE_IV   := cfile_in
          BANVYPITw ->cZKRATMENF := IF( .not. Empty((cFile_in) ->cZKRATMENZ), ;
                                      (cFile_in) ->cZKRATMENZ, (cFile_in) ->cZKRATMENY )
        ENDIF
      ELSE
        * platí pro vzz/uhr
        BANVYPITw ->cZKRATMENF := if(vzz ='ban', C_BANKUc ->cZKRATMENY,  BANVYPHDw ->cZKRATMENY)
      ENDIF

      BANVYPIT ->(DbSkip())
    ENDDO
    BANVYPIT ->( DbGoTop())
  ELSE
    IF( C_BANKUC ->( mh_SEEK( .T., 2, .T.)), Nil, C_BANKUC ->( DBGoTop()) )
    if( vzz = 'ban', mh_copyFld( 'C_BANKUC', 'BANVYPHDw', .t., .f. ), banvyphdw->(dbAppend()))

    ( BANVYPHDw ->cUloha     := "F"                             , ;
      BANVYPHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI           , ;
      BANVYPHDw ->nROK       := uctOBDOBI:FIN:NROK              , ;
      BANVYPHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI           , ;
      BANVYPHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN        , ;
      BANVYPHDw ->cDENIK     := SysConfig( 'Finance:cDenikBAVY'), ;
      BANVYPHDw ->cDENIK_puc := SysConfig( 'Finance:cDENIKpuc' ), ;
      BANVYPHDw ->dDATZUST   := Date()                          , ;
      banvyphdw->czkratMeny  := sysConfig( 'Finance:czaklMena') , ;
      banvyphdw->nkurzahmen  := 1                               , ;
      banvyphdw->nmnozprep   := 1                                 )

    if     vzz = 'vzz'
      banvyphdw->cbank_Naz := 'Vzájemný zápoèet'
      banvyphdw->ddatporiz := date()
      banvyphdw->cdenik    := sysconfig('finance:cdenikvzza')
      banvyphdw->cucet_uct := sysconfig('finance:cucetvzza')
      banvyphdw->nposzust  := 0
      banvyphdw->nzustatek := 0
    elseif vzz = 'uhr'
      banvyphdw->cbank_Naz := 'Úhrady finanèním dokladem'
      banvyphdw->ddatporiz := date()
      banvyphdw->cdenik    := sysconfig('finance:cdenikuhrd')
      banvyphdw->nposzust  := 0
      banvyphdw->nzustatek := 0
    endif

    FIN_banvyp_dov(vzz)
    FIN_banvyp_kurz()
   ENDIF
RETURN(Nil)


function FIN_banvyp_dov(vzz)                                                     // nDOKLAD/nCISPOVYP //
  local  ndoklad, cdenik := upper(banvyphdw->cdenik)
  local  filter

  if(select('banvyp_b') = 0, drgDBMS:open('banvyphd',,,,,'banvyp_b'), nil)
  *
  filter := format("(upper(cdenik) = '%%')", {cdenik})
  banvyp_b->( ads_setAof(filter))

  if vzz = 'ban'
    banvyp_b->( mh_seek(upper(banvyphdw->cbank_uct), 7, .t., .t. ))
    ndoklad := banvyp_b->ndoklad +1
    if banvyp_b->(dbseek(ndoklad,, AdsCtag(1) ))
      banvyp_b->(AdsSetOrder(12), dbsetscope(SCOPE_BOTH, cdenik), dbgobottom())
      ndoklad := banvyp_b->ndoklad +1
    endif

    banvyp_b->(AdsSetOrder(9), ;
               dbSetScope(SCOPE_BOTH,upper(banvyphdw->cbank_uct) +strZero(banvyphdw->nrok,4)), ;
               dbGoBottom()    )

    banvyphdw->ndoklad   := ndoklad
    banvyphdw->ncispovyp := banvyp_b->ncisPoVyp +1

  * platí pro vzz/uhr
  else
    banvyp_b->(AdsSetOrder(12), dbsetscope(SCOPE_BOTH, cdenik), dbgobottom())
    banvyphdw->ndoklad := banvyp_b->ndoklad +1
  endif

  banvyp_b->(dbClearScope())
  banvyp_b->(ads_clearAof())
return(Nil)


function FIN_banvyp_kurz()
  local  zkrMeny  := upper(banvyphdw->czkratMeny), cky
  local  dporiz   := coalesceEmpty(banvyphdw->ddatPoriz,date())
  local  zaklMena := upper(SysConfig('Finance:cZaklMena'))

  if zkrMeny <> zaklMena
    kurzit->(AdsSetOrder(2), dbsetscope(SCOPE_BOTH,zkrMeny))
    cky := zkrMeny +dtos(dporiz)

    kurzit->(dbseek(cky,.t.))
    if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)
    banvyphdw->nkurzahmen := kurzit->nkurzstred
    banvyphdw->nmnozprep  := kurzit->nmnozprep

    kurzit->(dbclearScope())
  endif
return .t.


static function FIN_banvyp_wrt(odialog)
  local  mainOk    := .t., nrecor
  local  anFap     := {}, anFav     := {}, anMzz := {}, anBan := {}, axFak := {}, pa
  local  anBanh_im := {}, anBani_im := {}
  local  uctLikv
  local  istuz    := Equal(sysConfig('Finance:cZaklMena'),banvyphdw->czkratMeny)
  *
  local  ain_file := odialog:ain_file, nin, cfile_iv, cky

  if( odialog:lnewRec,fin_banvyphd_typ(odialog:cmb_typDokl),nil)

  uctLikv := UCT_likvidace():new(upper(banvyphdw->culoha) +upper(banvyphdw->ctypdoklad),.T.)

  banvypitw->(AdsSetOrder(0),dbgotop())

  *
  * rušíme bankovní výpis, mùže nít vazbu na banVypH_IM
  if  banvyphdw->_delrec = '9'
    cky := strZero(banvyphdw->nrok,4) +upper(banvyphdw->cBank_Uce) +strZero(banvyphdw->nCisPoVyp,6)

    if banVyph_im->( dbseek( cky,,'BANIMPH_2'))
      aadd( anBanh_im, banVyph_im->( recNo()) )

      banVypi_im->( dbeval( { || aadd( anBani_im,  banVypi_im->( recNo()) )         }, ;
                            { || ( banVyph_im->nrok_vyp  = banVypi_im->nrok_vyp  .and. ;
                                   banvyph_im->cBank_Uce = banVypi_im->cBank_Uce .and. ;
                                   banvyph_im->nCisPoVyp = banvypi_im->nCisPoVyp       ) } ))
    endif
  endif

  do while .not. banvypitw->(eof())
    if(nin := ascan(ain_file,{|x| x[6] = banvypitw->cdenik_par})) <> 0
      pa       := if(nin = 1, anFap, if( nin = 2, anFav, anMzz ))
      cfile_iv := ain_file[nin,1]

      if (cfile_iv)->(dbseek(banvypitw->ncisFak,, AdsCtag(1) ))
        banvypitw->ndoklad_iv := (cfile_iv)->(recNo())
      else
        banvypitw->ndoklad_iv := 0
      endif

      aadd(pa,banvypitw->ndoklad_iv)

      aadd(axFak, {banvypitw->(recno()), banvypitw->ndoklad_or, ain_file[nin,1], banvypitw->ndoklad_iv})
    else
      aadd(axFak, {banvypitw->(recno()), banvypitw->ndoklad_or, nil            , 0                    })
    endif
    aadd(anBan,banvypitw->_nrecor)
    banvypitw->(dbskip())
  enddo

  if( .not. odialog:lnewRec, banvyphd->(dbgoto(banvyphdw->_nrecor)), nil )
  mainOk := banvyphd->(sx_rlock())                    .and. ;
            fakprihd->(sx_rlock(anFap))               .and. ;
            fakvyshd->(sx_rlock(anFav))               .and. ;
            mzdZavhd->(sx_rlock(anMzz))               .and. ;
            banvypit->(sx_rlock(anBan))               .and. ;
            c_bankuc->(sx_rlock())                    .and. ;
            ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo))

  if banvyphdw->_delrec = '9'
    mainOk := ( mainOk .and. banVyph_im->( sx_rlock(anBanh_im)) .and. banVypi_im->( sx_rlock(anBani_im)) )
  endif

  if mainOk
    if(banvyphdw->_delrec <> '9', mh_copyfld('banvyphdw','banvyphd',odialog:lnewRec, .f.), nil)
    banvypitw->(dbgotop())

    do while .not. banvypitw->(eof())
      if .not. istuz
*-        banvypitw->nuhrcelfak := (banvypitw->ncenzakcef -banvypitw->ncenzak_or)
        banvypitw->nuhrcelfak := banvypitw->ncenzakcef
      endif

      if((nrecor := banvypitw->_nrecor) = 0, nil, banvypit->(dbgoto(nrecor)))
      if   banvypitw->_delrec = '9'
        if(nrecor = 0, nil, banvypit->(dbdelete()))
      else
        mh_copyfld('banvypitw','banvypit',(nrecor=0), .f.)
        banvypit->ndoklad := banvyphd->ndoklad
      endif

      if .not. empty(cfile_iv := alltrim(banvypitw->cfile_iv))
        (cfile_iv)->(dbgoto(banvypitw->ndoklad_iv))

        if banvypitw->_delrec = '9'
          *
          ** oprava dokladu, zrušil položku, která mìla vazbu ?
          if nrecor <> 0
            (cfile_iv)->nuhrcelfak -= banvypitw->ncenzak_or
            (cfile_iv)->nuhrcelfaz -= banvypitw->ncenzah_or
            (cfile_iv)->nkurzrozdf -= banvypitw->nkurzro_or
            if( (cfile_iv)->nuhrcelfak = 0, (cfile_iv)->dposuhrfak := ctod('  .  .  '), nil )
          endif
        else
          if istuz ; (cfile_iv)->nuhrcelfak += (banvypitw->nuhrcelfak -banvypitw->ncenzak_or)
          else     ; (cfile_iv)->nuhrcelfak += (banvypitw->ncenzakcef -banvypitw->ncenzak_or)
          endif

          if istuz ; (cfile_iv)->nuhrcelfaz += (banvypitw->nuhrcelfaz -banvypitw->ncenzah_or)
          else     ; (cfile_iv)->nuhrcelfaz += (banvypitw->nuhrcelfaz -banvypitw->ncenzah_or)
          endif

          (cfile_iv)->nkurzrozdf += (banvypitw->nkurzrozdf -banvypitw->nkurzro_or)
          if banvypitw->ddatuhrady > (cfile_iv)->dposuhrfak
            (cfile_iv)->dposuhrfak := banvypitw->ddatuhrady
          endif

          if cfile_iv = 'FAKVYSHD' .and. (cfile_iv)->cobdobidan = '00/00'
            (cfile_iv)->cobdobidan := banvyphd->codbodbidan
          endif

          *
          ** oprava pro nápoèet nuhrcekFak, nuhrcekFaz, nkurzRozdf
          banvypit->( dbcommit())
          cky := upper( (cfile_iv)->cdenik) +strZero((cfile_iv)->ncisFak,10)
          FIN_ban_pok_vzz_sum( cky, cfile_iv )
         endif
      endif

      banvypitw->(dbskip())
    enddo

    c_bankuc->ncispovyp := banvyphd->ncispovyp
    c_bankuc->ddatpovyp := banvyphd->ddatporiz
    c_bankuc->nposzust  := banvyphd->nzustatek

    if banvyphdw->_delrec = '9'
      ( uctLikv:ucetpol_del(),banvyphd->(dbdelete()) )

      aeval(anBanh_im, {|x| banVyph_im->(dbgoto(x),dbdelete()) })
      aeval(anBani_im, {|x| banVypi_im->(dbgoto(x),dbdelete()) })
    else
      uctLikv:ucetpol_wrt()
    endif
  else
    drgMsg(drgNLS:msg('Nelze modifikovat BANKOVNÍ VÝPIS, blokováno uživatelem ...'),,odialog:drgDialog)
  endif

  fakprihd->(dbunlock(),dbcommit())
   fakvyshd->(dbunlock(),dbcommit())
    mzdZavhd->(dbunlock(),dbcommit())
     banvyphd->(dbunlock(),dbcommit())
      banvypit->(dbunlock(),dbcommit())
       ucetpol ->(dbunlock(),dbcommit())
        c_bankuc->(dbunlock(),dbcommit())

         banVyph_im->(dbunlock(),dbcommit())
          banVypi_im->(dbunlock(),dbcommit())
return mainOk


*
**
static function fin_banvyphd_typ(drgComboBox)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin

  nin := ascan(values,{|x| x[1] = value })

  banvyphdw->ctypdoklad := values[nin,3]
  banvyphdw->ctyppohybu := values[nin,1]
  banvyphdw->(dbcommit())
return nil


*
** zrušení bankovního výpisu/ vzájemného zápoètu **
function fin_banvyp_del(odialog)
  local  mainOk

  banvyphdw->_delrec := '9'
  banvypitw->(banvypitw->(AdsSetOrder(0),dbgotop()), dbeval({|| banvypitw->_delrec := '9'}))
  mainOk := fin_banvyp_wrt_inTrans(odialog)
return mainOk