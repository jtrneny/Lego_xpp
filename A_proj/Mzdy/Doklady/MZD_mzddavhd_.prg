#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
#include "dmlb.ch"



function MZD_mzddavhd_cpy(oDialog)
  local  file_name, ky, nrecs := 0
  local  cky := strZero( mzddavhd->nrok, 4)       +strZero( mzddavhd->nOBDOBI,2)     + ;
                strZero( mzddavhd->noscisPrac, 5) +strZero( mzddavhd->nporPraVzt ,3) + ;
                strZero( mzddavhd->nDoklad ,10)
  *
  local  lnewRec := if( isnull(oDialog), .f., ;
                     if( isMemberVar(oDialog,'lnewRec'), oDialog:lnewRec, .f. ) )

  * pro automat
  drgDBMS:open('mzdDavHDwa',.T.,.T.,drgINI:dir_USERfitm) ; mzdDavHDwa->( dbzap())
  drgDBMS:open('mzdDavITwa',.T.,.T.,drgINI:dir_USERfitm) ; mzdDavITwa->( dbzap())

  * pro automaticky generované prémie k základní mzdì
  drgDBMS:open('mzdDavITs',.T.,.T.,drgINI:dir_USERfitm) ; mzdDavITs->( dbzap())

  * pro bìžné poøízení
  drgDBMS:open('MZDDAVHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MZDDAVITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  file_name := mzddavitw ->( DBInfo(DBO_FILENAME))
               mzddavitw ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'mzddavitw', .t., .f.) ; mzddavitw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'mzdDav_iw', .t., .t.) ; mzddav_iw->(AdsSetOrder(1))
  *

  if .not. lnewRec
    mh_copyFld( 'MZDDAVHD', 'MZDDAVHDw', .t., .t. )

    fOrdRec( { 'MZDDAVIT,12' } )

    mzddavit->( dbsetScope(SCOPE_BOTH,cky), dbgoTop() )
    do while .not. mzdDavit->( eof())
      *
      ** specialitka pro automaticky generované prémie k základní mzdì
      if mzdDavhd->cdenik = 'MH' .and. mzdDavit->nautoGen = 2
        mh_copyFld( 'mzdDavit', 'mzdDavITs', .t., .t. )

      else
        mh_copyFld( 'mzdDavit', 'mzdDavITw' , .t., .t. )
        *
        mzdDavITw->ndnyDok_or := mzdDavit->ndnyDoklad
        mzdDavITw->nhodDok_or := mzdDavit->nhodDoklad
        nrecs += 1
      endif

      mzdDavit->( dbskip())
    enddo
    *
    ** musíme doplnit vazbu mzdDavitW - > mzdDavitS
    mzdDavitS->( dbgotop(), ;
                 dbeval( { || if( mzdDavitW->( dbseek( strZero(mzdDavitS->norditem -9,5),,'MZDITw01')), ;
                                  mzdDavitW->_nsidPrem := isNull( mzdDavitS->sid, 0)                  , ;
                                  nil                                                                   ) }), ;
                 dbgoTop()  )

    mzdDavit->( DbClearScope())
    fOrdRec()
    *
    ** specialitka pro pokraèování nemoci
    if mzdDavHDw->cdenik     = 'MN' .and. ;
       mzdDavHDw->nautoGen   =  1   .and. ;
       nrecs                 =  0

       mzdDavHDw->_npokrN_MO := 1
       mzdDavHDw->_vykazN_KD := mzdDavHDw->nvykazN_KD
     endif

  else
    mzddavhdw->(dbAppend())

   (  mzddavhdw ->ctask      := 'MZD'                                      , ;
      mzddavhdw ->cUloha     := "M"                                        , ;
      mzddavhdw ->nROK       := uctOBDOBI:MZD:NROK                         , ;
      mzddavhdw ->nOBDOBI    := uctOBDOBI:MZD:NOBDOBI                      , ;
      mzddavhdw ->cOBDOBI    := uctOBDOBI:MZD:COBDOBI                      , ;
      mzddavhdw ->nRokObd    := (mzddavhdw ->nROK *100)+mzddavhdw ->nOBDOBI, ;
      mzddavhdw ->ddatPoriz  := date()                                       )
  endif
return nil


*
** nápoèty do HD se øídí promìnnou druhyMzd->nnapocHm
function mzd_mzddavhd_cmp( isin_aut )
  local it_file_w

  default isin_aut to .f.
  it_file_w := if( isin_aut, 'mzdDavitW',  'mzdDav_iw' )

  mzdDavHdw->nHrubaMZD  := ;
   mzdDavHdw->nMzda      := ;
    mzdDavHdw->nZaklSocPo := ;
     mzdDavHdw->nZaklZdrPo := ;
      mzdDavHdw->nDnyFondKD := ;
       mzdDavHdw->nDnyFondPD := ;
        mzdDavHdw->nDnyDovol  := ;
         mzdDavHdw->nHodFondKD := ;
          mzdDavHdw->nHodFondPD := ;
           mzdDavHdw->nHodPresc  := ;
            mzdDavHdw->nHodPrescS := ;
             mzdDavHdw->nHodPripl  := 0

  * pro nemoceskou denik MN
  mzdDavHdw->nvykazN_HO := mzdDavHdw->nvykazN_KD := ;
   mzdDavHdw->nvykazN_PD := mzdDavHdw->nvykazN_VD := ;
    mzdDavHdw->nNemocCelk := 0

  (it_file_w)->(dbgotop())

  do while .not. (it_file_w)->(eof())
    if ((it_file_w)->_delrec <> '9')

      mzdDavHdw->nHrubaMZD  += (it_file_w)->nHrubaMZD
      mzdDavHdw->nMzda      += (it_file_w)->nMzda

      mzdDavHdw->nZaklSocPo += (it_file_w)->nZaklSocPo
      mzdDavHdw->nZaklZdrPo += (it_file_w)->nZaklZdrPo

      mzdDavHdw->nDnyFondKD += (it_file_w)->nDnyFondKD
      mzdDavHdw->nDnyFondPD += (it_file_w)->nDnyFondPD
      mzdDavHdw->nDnyDovol  += (it_file_w)->nDnyDovol

      mzdDavHdw->nHodFondKD += (it_file_w)->nHodFondKD
      mzdDavHdw->nHodFondPD += (it_file_w)->nHodFondPD
      mzdDavHdw->nHodPresc  += (it_file_w)->nHodPresc
      mzdDavHdw->nHodPrescS += (it_file_w)->nHodPrescS
      mzdDavHdw->nHodPripl  += (it_file_w)->nHodPripl

      * pro nemoceskou denik MN
      mzdDavHdw->nvykazN_HO += (it_file_w)->nvykazN_HO
      mzdDavHdw->nvykazN_KD += (it_file_w)->nvykazN_KD
      mzdDavHdw->nvykazN_PD += (it_file_w)->nvykazN_PD
      mzdDavHdw->nvykazN_VD += (it_file_w)->nvykazN_VD
      mzdDavHdw->nNemocCelk += (it_file_w)->nNemocCelk
      mzdDavHdw->nDnyVylocD += (it_file_w)->nDnyVylocD
      mzdDavHdw->nDnyVylDOD += (it_file_w)->nDnyVylDOD
    endif

    (it_file_w)->(dbskip())
  enddo
  (it_file_w)->(dbgoTop())


  * pro automaticky generované prémie k základní mzdì
  if mzdDavhdW->cdenik = 'MH' .and. select('mzdDavitS') <> 0
    it_file_w := 'mzdDavitS'
    (it_file_w)->(dbgotop())

    do while .not. (it_file_w)->(eof())
      if ((it_file_w)->_delrec <> '9')

        mzdDavHdw->nHrubaMZD  += (it_file_w)->nHrubaMZD
        mzdDavHdw->nMzda      += (it_file_w)->nMzda

        mzdDavHdw->nZaklSocPo += (it_file_w)->nZaklSocPo
        mzdDavHdw->nZaklZdrPo += (it_file_w)->nZaklZdrPo
      endif
      (it_file_w)->(dbskip())
    enddo

    (it_file_w)->(dbgoTop())
  endif
return nil

*
** uložení mzdového dokladu v transakci ****************************************
function mzd_mzddavhd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := mzd_mzddavhd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


static function mzd_mzddavhd_wrt(odialog)
  local  mainOk     := .t., premOk
  local  anMzdh     := {}, anMzdi := {}, c_sid_vyucDane := ''
  local  cfiltr_por := "cdenik = '%%' .and. nrok = %% .and. nosCisPrac = %% .and. nporPraVzt = %%"
  local  cfiltr     := "ndoklad = %%", cf
  local  cky
  local  upravZakl  := .f.
  *
  local  uctLikv, ntypUctMzd := SysConfig( 'mzdy:nTypUctMZD')
  local  is_student     := ( msPrc_mo->ntypZamVzt = 11 .or.  msPrc_mo->lStudent )
  local  sum_nzaklSocPo := 0, sum_nzaklZdrPo := 0
  local  ndel_zaklSoc   := 0, ndel_zaklZdr   := 0
  local  cmain_Ky       := strZero(mzdDavHDw->nrok,4) +strZero(mzdDavHDw->nobdobi,2) + ;
                           strZero(mzdDavHDw->nosCisPrac,5) +strZero(mzdDavHDw->nporPraVzt,3)
  *
  local cStatement, oStatement
  local stmt          := "EXECUTE PROCEDURE p_MZD_mzddavhd_autosz400( %%, %%, %%, %%, %%, %%);"
  local stmt_vyucDane := "update vyucDane set nMZDDAVHD = 0, nMZDDAVIT = 0, " + ;
                         "nZuctovano = ( select sum(nMzda) *(-1) from mzdDavit where nVYUCDANE = %vyucdane) " + ;
                         "where sID = %vyucdane"

  *
  ** specialitka pro pokraèování nemoci, zrušila položky páè neví co s tím
  mzdDavITw->( dbgoTop())

  if mzdDavHDw->cdenik     = 'MN'.and. ;
     mzdDavHDw->_vykazN_KD <> 0  .and. ;
     mzdDavITw->( eof())

     mzdDavHDw->ddatumDo   := ctod( '  .  .  ')
     mzdDavHDw->nvykazN_KD := mzdDavHDw->_vykazN_KD

     return .t.
  endif
  *
  ** specialitka pro automaticky generované prémie k základní mzdì
  if mzdDavhdW->cdenik = 'MH' .and. select('mzdDavitS') <> 0
    mzdDavitS->( dbgoTop())

    do while .not. mzdDavitS->( eof())
      premOk := ( mzdDavitS->nmzda <> 0 )

      * zrušil prémii ke mzdì npremie = 0
      if .not. premOk .and. mzdDavitS->_nrecor <> 0
        ( mzdDavitS->_delrec := '9', premOk := .t. )
      endif

      if( premOk, add_mzddav_wa( 'mzdDavitS', 'mzdDavitW', .t.), nil )
      mzdDavitS->( dbskip())
    enddo
  endif
  *
  ** pro deník MN musíme naplnit nporadi pokud je prázdné
  if mzdDavhdW->cdenik = 'MN' .and. mzdDavhdW->nporadi = 0
*    cky := upper(mzdDavhdW->cdenik) +strZero(mzdDavhdW->nrok,4)       + ;
*                                     strZero(mzdDavHDw->nosCisPrac,5) + ;
*                                     strZero(mzdDavHDw->nporPraVzt,3)

    cf  := Format( cfiltr_por, { mzdDavhdW->cdenik, mzdDavhdW->nrok, mzdDavHDw->nosCisPrac, mzdDavHDw->nporPraVzt })
    mzdDavHd_S->( ads_setaof(cf)           , ;
                  ordSetFocus('MZDDAVHD22'), ;
                  dbgoBottom())

*    mzdDavHd_S->( ordSetFocus('MZDDAVHD22')   , ;
*                  dbsetScope( SCOPE_BOTH, cky), ;
*                  dbgoBottom()                  )

    mzdDavhdW->nporadi := if( mzdDavHd_S->nporadi = 0, (mzdDavhdW->nrok *100) +1, mzdDavHd_S->nporadi +1 )
    mzdDavHd_S->( ads_clearAof())

*    mzdDavHd_S->( dbclearScope())
  endif
  *
  ** pro jistotu to pøeèíslujem a naplníme cucetSkup tady
  mzdDavITw->( dbgoTop()     , ;
               AdsSetOrder(0), ;
               dbeval( { || ( mzdDavITw->ndoklad   := mzdDavHDw->ndoklad                                       , ;
                              mzdDavITw->nporadi   := mzdDavHDw->nporadi                                       , ;
                              mzdDavITw->ddatporiz := mzdDavHDw->ddatporiz                                     , ;
                              if( mzdDavhdW->cdenik = 'MN', mzdDavitw->ddatumOd := mzdDavitw->dvykazN_Od, nil ), ;
                              if( mzdDavhdW->cdenik = 'MN', mzdDavitw->ddatumDo := mzdDavitw->dvykazN_Do, nil ), ;
                              mzdDavitW->cucetskup := allTrim( str( mzdDavitW->ndruhMzdy))  ) } )                )

  *
  ** je otevøený paralerní soubor automatù a obsahuje data ?
  if select( 'mzdDavHDwa' ) <> 0
    if .not. mzdDavHDwa->( eof())
      add_mzddav_wa('mzdDavHDwa', 'mzdDavHDw')

      mzdDavITwa->( dbgoTop(), ;
                    dbeval({ || add_mzddav_wa( 'mzdDavITWa', 'mzdDavITw') }) )
    endif
  endif
  *
  ** zámky
  mzdDavHDw->( dbgoTop(), ;
               dbeval( { || aadd( anMzdh, mzdDavHDw->_nrecor) }, ;
                       { || mzdDavHDw->_nrecor <> 0           }  ) )

  mzdDavITw->( AdsSetOrder(0), dbgotop() )

  do while .not. mzdDavITw->( eof())
    if( mzdDavitw->_nrecor <> 0, aadd( anMzdi, mzdDavitw->_nrecor), nil )

    if mzdDavitW->nVYUCDANE <> 0 .and. mzdDavItw ->_delrec = '9'
      c_sid_vyucDane += strTran( str(mzdDavitw->nVYUCDANE), ' ', '') +','
      *
      ** odpojíme mzdDavhd od vyucDane
      mzdDavhdW->nVYUCDANE := 0
    endif
    mzdDavITw->( dbskip())
  enddo
  c_sid_vyucDane := left( c_sid_vyucDane, len( c_sid_vyucDane) -1)

  if len(anMzdh) <> 0
    mainOk := mzdDavHD->( sx_rLock(anMzdh)) .and. mzdDavIT->(sx_rLock(anMzdi))
  endif

  if mainOk
    mzdDavHDw->( dbgoTop())

    do while .not. mzdDavHDw->( eof())
      if( (nrecor :=  mzdDavHDw->_nrecor) = 0, nil, mzdDavHD->( dbgoto(nrecor)) )

      if mzdDavHdw->_delrec <> '9'
        mh_copyfld('mzdDavHdw','mzdDavHd',(nrecor = 0), .f.)
        mzdDavHd->nmsprc_mo := isNull( msprc_mo->sid, 0)
      endif

      cf := format( cfiltr, {mzdDavHDw->ndoklad} )
      mzdDavITw->( ads_setAOF(cf), dbgoTop() )
      *
      ** po likvidaci je na posledním záznamu, dle CFG se buï úètuje nebo ne
      if ntypUctMzd <> 0
        uctLikv  := UCT_likvidace():new(upper(mzdDavHdw->culoha) +upper(mzdDavHdw->ctypdoklad),.T.)
      endif
      mzdDavITw->( dbgoTop())

      do while .not. mzdDavItw->(eof())
        if((nrecor := mzdDavItw ->_nrecor) = 0, nil, mzdDavIt->(dbgoto(nrecor)))

        if   mzdDavItw ->_delrec = '9'
          if nrecor <> 0
            mzdDavIt->(dbdelete())
          endif
        else
          mzdDavItw->ndoklad := mzdDavHd->ndoklad

          mh_copyfld('mzdDavItw','mzdDavIt',(nrecor=0), .f.)
          mzdDavIt->nmsprc_mo := isNull( msprc_mo->sid, 0)
        endif

        mzdDavItw->(dbskip())
      enddo

      if mzdDavHdw->_delrec = '9'
        if( ntypUctMzd <> 0, uctLikv:ucetpol_del(), nil )
        mzdDavHD->( dbdelete())
      else
        if( ntypUctMzd <> 0, uctLikv:ucetpol_wrt(), nil )
      endif

      mzddavHDw->( dbskip())
    enddo

    * pokud by mìl náhodou spoèítanou èistou mzdu, shodíme to na 7
    *  1 - nad zamìstnancem byl proveden automatický výpoèet èisté mzdy
    *  2 - nad zamìstnancem byl proveden ruèní  výpoèet èisté mzdy
    *  7 - výpoèet èisté mzdy byl zrušen aktualizací dat
    if msPrc_mo->nstaVypoCM = 1 .or. msPrc_mo->nstaVypoCM = 2
      if msPrc_mo->( dbRLock())
        msPrc_mo->nstaVypoCM := 7
        msPrc_mo->(dbunlock(),dbcommit())
      endif
    endif

    * musíme shodit filtr
    mzdDavITw->( ads_clearAof(), dbgoTop() )

    * pro rušení dokladu z jakékoliv volby a není jich málo
    mzdDavHd ->(dbunlock(),dbcommit())
    mzdDavIt ->(dbunlock(),dbcommit())

     * probìhlo uložení dat OK musíme uložit data, na servru se zapíná automaticky transakce
    oSession_data:commitTransaction()

    if isMethod( odialog, 'zaklSocPo_sum') .and. isMethod( odialog, 'zaklZdrPo_sum')
      *
      ** automat mùže pøidat HD, pak krokuje a HDw na EOF, pak nzaklSocPo a nzaklZdrPo je NùùùLA
      ** a Janièka brble
      mzdDavHdw->( dbgoTop())

      sum_nzaklSocPo := odialog:zaklSocPo_sum()
      sum_nzaklZdrPo := odialog:zaklZdrPo_sum()
    else
      drgDBMS:open('MZDDAVHD',,,,, 'mzddavHd_s')
      mzdDavHd_s->( ordSetFocus('MZDDAVHD01')      , ;
                    dbsetScope(SCOPE_BOTH,cmain_Ky), ;
                    dbgoTop()                      , ;
                    dbeval( { || sum_nzaklSocPo += mzdDavHD_s->nzaklSocPo, ;
                                 sum_nzaklZdrPo += mzdDavHD_s->nzaklZdrPo  } ))

    endif

    do case
    case msPrc_mo->ntypPraVzt = 6
      if( sum_nzaklSocPo < 2500, ndel_zaklSoc := 1, nil)
      if( sum_nzaklZdrPo < 2500, ndel_zaklZdr := 1, nil)
      upravZakl := .t.

    case msPrc_mo->ntypPraVzt = 6 .and. msPrc_mo->lZamMalRoz
      if( sum_nzaklSocPo < 2500, ndel_zaklSoc := 1, nil)
      if( sum_nzaklZdrPo < 2500, ndel_zaklZdr := 1, nil)
      upravZakl := .t.

    case msPrc_mo->ntypPraVzt <> 6 .and. msPrc_mo->lZamMalRoz
      ndel_zaklSoc := 1
      upravZakl := .t.

    endcase

    if ( ndel_zaklSoc +ndel_zaklZdr) <> 0
      cStatement := format( stmt, { msPrc_mo->nrok      , ;
                                    msPrc_mo->nobdobi   , ;
                                    msPrc_mo->noscisPrac, ;
                                    msPrc_mo->nporPraVzt, ;
                                    ndel_zaklSoc        , ;
                                    ndel_zaklZdr          })

      oStatement := AdsStatement():New(cStatement,oSession_data)
      if oStatement:LastError > 0
*         return .f.
      else
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
      endif
    endif


    *
    ** zvláštní úprava mzdDavHd / mzdDavIt / ucetpol
/*
    if msPrc_mo->lautoSZ400 .and. ( msPrc_mo->ntypPraVzt = 6 .or. ;
                                    msPrc_mo->ntypPraVzt = 7 .or. ;
                                    msPrc_mo->ntypPraVzt = 8      )

      if sum_nzaklSocPo < 400
        ndel_zaklSoc := 1
      endif

      if sum_nzaklZdrPo < 400 .and. ( ( msPrc_mo->ntypDuchod = 0 .or. ;
                                        msPrc_mo->ntypDuchod = 5 .or. ;
                                        msPrc_mo->ntypDuchod = 6 .or. ;
                                        msPrc_mo->nTypDuchod = 7 .or. ;
                                        msPrc_mo->ntypDuchod = 8      ) .and. !is_student )
        ndel_zaklZdr := 1
      endif

      if ( ndel_zaklSoc +ndel_zaklZdr) <> 0
        cStatement := format( stmt, { msPrc_mo->nrok      , ;
                                      msPrc_mo->nobdobi   , ;
                                      msPrc_mo->noscisPrac, ;
                                      msPrc_mo->nporPraVzt, ;
                                      ndel_zaklSoc        , ;
                                      ndel_zaklZdr          })

        oStatement := AdsStatement():New(cStatement,oSession_data)

        if oStatement:LastError > 0
*         return .f.
        else
          oStatement:Execute( 'test', .f. )
          oStatement:Close()
         endif
      endif
    endif
*/

    *
    ** odpojení vazeb na vyucDane pøi rušení dokladu, nebo položky generovaného dokladu
    if len(c_sid_vyucDane) <> 0
      cStatement := strTran( stmt_vyucDane , '%vyucdane', c_sid_vyucdane )

*      stmt_vyucDane += c_sid_vyucDane +")"
      oStatement := AdsStatement():New(cStatement,oSession_data)

      if oStatement:LastError > 0
*       return .f.
      else
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
      endif
    endif

  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat MZDOVÝ DOKLAD, blokováno uživatelem ...'))
  endif
return mainOk


static function add_mzddav_wa(from_db,to_db)
  local  npos, xval, afrom := (from_db)->(dbstruct()), x
  *
  local  citem

  (to_db)->( dbappend())

  for x := 1 to len(afrom) step 1
    citem := to_Db +'->' +(to_Db)->(fieldName(x))

    xval  := (from_db)->(fieldget(x))
    npos  := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

    if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
  next
return nil


*
** zrušení mzdového dokladu **
function mzd_mzddavhd_del(odialog)
  local  mainOk := .t.

  mzdDavhdw->_delrec := '9'
  mzdDavitw->( mzdDavitw->(AdsSetOrder(0),dbgotop()), dbeval({|| mzdDavitw->_delrec := '9'}))

  mzdDavhdw->(dbcommit())
  mzddavitw->(dbcommit())
  *
  ** automaticky generované prémie
  if select('mzdDavitS') <> 0
    mzdDavits->( mzdDavitS->( AdsSetOrder(0),dbgotop())          , ;
                              dbeval({|| mzdDavitS->nmzda := 0 }), ;
                              dbgotop()                          , ;
                              dbcommit()                           )
  endif

  mainOk := mzd_mzddavhd_wrt(odialog)

  mzdDavHDw->( dbcloseArea())
   mzdDavITw->( dbcloseArea())
    mzdDav_iw->( dbCloseArea())
return mainOk