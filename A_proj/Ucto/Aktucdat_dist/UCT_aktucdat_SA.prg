#include "Common.ch"
#include "gra.ch"
#include "adsdbe.ch"
#include "dbstruct.ch'


static  cobd_akt, p_sald, p_salk, nrok, nobdobi
static  nrecCnt, nkeyCnt, nkeyNo, nrecSald

*
** AKTUALIZACE saldokontníchch POLOŽEK *****************************************
function uct_aktucdat_sa(cobd_aktu, xbp_therm)

  if ucetsald->(flock()) .and. ucetsalk->(flock())
    p_sald   := {}
    p_salk   := {}
    cobd_akt := cobd_aktu
    nrok     := val( left (cobd_akt, 4))
    nobdobi  := val( right(cobd_akt, 2))
    nrecSald := 0

    * ucetsalD
    ucetsald_ini()
    ucetsald_akt(xbp_therm)

    aeval(p_sald, {|x| ucetsald->(dbgoto(x),dbdelete())})
    ucetsald->(dbcommit(),dbgotop())
    xbp_therm:configure()

    * ucetsalK
    ucetsalk_akt(xbp_therm)

    aeval(p_salk, {|x| ucetsalk->(dbgoto(x),dbdelete())})
    ucetsalk->(dbcommit(),dbgotop())
    ucetsald->(dbClearScope(), DbGotop())
  endif
return nil


static function ucetsald_akt(oxbp)
  local  cky, rec, pos, pa := p_sald

  nrecCnt := uct_setScope('ucetpol', 'UCETPO09', cobd_akt)
  nkeyCnt := nrecCnt / Round(oXbp:currentSize()[1]/(drgINI:fontH -6),0)
  nkeyNo  := 1

  do while .not. ucetpol->(eof())
    aktucdat_pb(oxbp, nkeyCnt, nkeyNo, nrecCnt)
    c_uctosn->(dbseek(upper(ucetpol->cucetMd),, AdsCtag(1) ))

    if c_uctosn->lsaldoUct
      cky := ucetpol->(sx_keyData())
      pos := 0

      if ucetsald->(dbseek(cky,, AdsCtag(2) ))
        rec := ucetsald->(recno())
        if((pos := ascan(pa, rec)) <> 0, (adel(pa,pos), asize(pa, len(pa)-1)), nil)
      else
        ucetsald->(dbappend())
        db_to_db('ucetpol','ucetsald')
        pos := 1
      endif
      nrecSald++

      if pos <> 0  ;  db_to_db('ucetpol','ucetsald')
      else         ;  ucetsald->nKCmd  += ucetpol->nKCmd
                      ucetsald->nKCdal += ucetpol->nKCdal
      endif
    endif

    ucetpol->(dbskip())
    nkeyNo++
  enddo

  uct_clearScope('ucetpol')
return nil


static function ucetsalk_akt(oxbp)
  local  cky, rec, pos := 0, pa := p_salk

  nrecCnt := ucetsalk_cnt()
  nkeyCnt := nrecCnt / Round(oXbp:currentSize()[1]/(drgINI:fontH -4),0)
  nkeyNo  := 1

  ucetsald->(AdsSetOrder('UCSALD01')           , ;
             dbSetScope(SCOPE_TOP   , '000000'), ;
             dbSetScope(SCOPE_BOTTOM, cobd_akt), ;
             DbGoTop()                           )


  do while .not. ucetsald->(eof())
    aktucdat_pb(oxbp, nkeyCnt, nkeyNo, nrecCnt)

    cky := strZero(nrok,4)         + strZero(nobdobi,2)      + ;
           upper(ucetsald->cucetmd)+ upper(ucetsald->csymbol)

    if ucetsalk->(dbseek(cky,,'UCSALD06'))
      rec := ucetsalk->(recno())
      if((pos := ascan(pa, rec)) <> 0, (adel(pa,pos), asize(pa, len(pa)-1)), nil)
    else
      ucetsalk->(dbappend())
      db_to_db('ucetsald','ucetsalk')
      pos := 1
    endif

    if pos <> 0  ;  ucetsalk->nrok    := nrok
                    ucetsalk->nobdobi := nobdobi
                    ucetsalk->nKCmd   := ucetsald->nKCmd
                    ucetsalk->nKCdal  := ucetsald->nKCdal
    else         ;  ucetsalk->nKCmd   += ucetsald->nKCmd
                    ucetsalk->nKCdal  += ucetsald->nKCdal
    endif
    *
    ucetsalk->lisClose := (ucetsalk->nkcMd = ucetsalk->nkcDal)

    ucetsald->(dbskip())
    nkeyNo++
  enddo
return nil


static function ucetsalk_cnt()
  local  ncnt

  ucetsald->(AdsSetOrder('UCSALD01')             , ;
             ads_setScope(SCOPE_TOP   , '000000'), ;
             ads_setScope(SCOPE_BOTTOM, cobd_akt), ;
             dbgotop()                             )

  ncnt := ucetsald->(ads_getKeyCount(ADS_RESPECTSCOPES))

  ucetsald->( ads_clearScope(SCOPE_TOP)   , ;
              ads_clearScope(SCOPE_BOTTOM), ;
              dbGoTop()                    )
return ncnt


static function ucetsald_ini()

  ucetsald->(AdsSetOrder('UCSALD01')                        , ;
             dbsetScope(SCOPE_BOTH, cobd_akt)               , ;
             dbgotop()                                      , ;
             dbeval({|| aadd(p_sald, ucetsald->(recno())) }), ;
             dbclearscope()                                   )

  ucetsalk->(AdsSetOrder('UCSALD06')                        , ;
             dbsetScope(SCOPE_BOTH, cobd_akt)               , ;
             dbgotop()                                      , ;
             dbeval({|| aadd(p_salk, ucetsalk->(recno())) }), ;
             dbclearscope()                                   )
return nil


static function db_to_db(cDBfrom,cDBto)
  local aFrom := ( cDBFrom) ->( dbStruct())

  aEval( aFrom, { |X,M| ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                          nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                          If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )
return nil