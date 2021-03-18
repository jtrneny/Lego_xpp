#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


# xTranslate .dnyDoklad_199   => \[1 \]
# xTranslate .hodDoklad_199   => \[2 \]
# xTranslate .dnyDoklad_122   => \[3 \]

*
** CLASS MZD_doklhrmz_aut *******************************************************
CLASS  MZD_doklhrmz_aut
EXPORTED:
  var   m_parent
  var   hd_file, it_file, brow

  inline method init( parent )
    ::m_parent := parent:drgDialog

    ::hd_file  := lower( parent:hd_file )
    ::it_file  := lower( parent:it_file )
    ::brow     :=        parent:brow
    return self

  *
  ** zkopíuje matrici do položek
  inline method msMzdyit_to_mzdDavitw( keyMatr, autoVypHM )
    local nordItem := 10
    local cky      := strZero( (::hd_file)->noscisPrac, 5) + ;
                        strZero( (::hd_file)->nporPraVzt,3) + strZero( keyMatr, 2)

    default autoVypHM to .f.

    *
    ** pro aoutomat
    if( select( 'mzdDavitA') = 0, drgDBMS:open( 'mzdDavit',,,,, 'mzdDavitA' ), nil )
    mzdDavitA->( ordSetFocus( 'MZDDAVIT01' ))
    if( select( 'druhyMzdA') = 0, drgDBMS:open( 'druhyMzd',,,,, 'druhyMzdA' ), nil )
    if( select( 'c_typDmzA') = 0, drgDBMS:open( 'c_typDmz',,,,, 'c_typDmzA' ), nil )

    autoVypHM := autoVypHM               .and. ;
                 msprc_mo   ->lAutoVypHM .and. ;
                 ( mzdDavhdw->ctypTarMzd = "MESICNI " .or. mzdDavhdw->ctypTarMzd = "CASOVA  " )

    (::hd_file)->nkeyMatr := keyMatr

    mzdDavItw->( dbcloseArea())
    mzdDav_iw->( dbCloseArea())

    drgDBMS:open('MZDDAVITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    file_name := mzddavitw ->( DBInfo(DBO_FILENAME))
                 mzddavitw ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, 'mzddavitw', .t., .f.) ; mzddavitw->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'mzdDav_iw', .t., .t.) ; mzddav_iw->(AdsSetOrder(1))

    msMzdyit->( dbsetscope( SCOPE_BOTH,cky), dbgoTop() )

    do while .not. msMzdyit->( eof())
      mh_copyFld( 'msMzdyit', 'mzddavitW', .t.)
      ::copyfldto_w( ::hd_file, ::it_file     )

      mzdDavITw->nordItem := nordItem
      msMzdyit->(dbskip())

      nordItem += 10
    enddo
    msMzdyit->( dbclearScope())

    (::it_file)->(dbgoTop())


    if( autoVypHM, can_setValues( ::it_file, ::hd_file, ::m_parent ), nil )
  return self

  *
  ** musíme nakopírovat automaticky generovaný doklad pro onLine modifikaci
  inline method doklhrmz_aut_cpy()
    local  cky_autoGen := strZero( mzdDavHD_s->nrok, 4)       + ;
                          strZero( mzdDavHD_s->nOBDOBI, 2)    + ;
                          strZero( mzdDavHD_s->noscisPrac, 5) + ;
                          strZero( mzdDavHD_s->nporPraVzt, 3) + ;
                          strZero( mzdDavHD_s->ndoklad, 10 )

    mh_copyFld( 'mzdDavHD_s', 'mzdDavHDwa', .t., .t. )

    mzdDavit_a->( ordSetFocus('MZDDAVIT12'), ;
                  dbsetScope (SCOPE_BOTH,cky_autoGen), dbgoTop() )

    do while .not. mzdDavit_a->( eof())
      mh_copyFld( 'mzdDavit_a', 'mzdDavITwa', .t., .t. )
      *
      mzdDavITwa->ndnyDok_or := mzdDavit_a->ndnyDoklad
      mzdDavITwa->nhodDok_or := mzdDavit_a->nhodDoklad
      mzdDavit_a->( dbskip())
    enddo
    mzdDavit_a->( DbClearScope())
  return self
  *
  ** online modifikace položky automaticky vypoètené Mzdy
  *  nnapocHM je dejinovaný na mzd_druhyMzd_crd.frm
  * x 0:zapoèítávají se DNY; HODINY; KÈ,
  *   1:zapoèítávají se KÈ,
  * x 2:zapoèítávají se DNY,
  * x 3:zapoèítávají se HODINY,
  * x 4:zapoèítávají se DNY; HODINY,
  * x 5:zapoèítávají se DNY; KÈ,
  * x 6:zapoèítávají se HODINY; KÈ,
  *   7:zapoèítávají se jen kalendáøní DNY,
  *   8:nezapoèítává se NIC
  *
  * nnapocFPD je dejinovaný na mzd_druhyMzd_crd.frm
  *   0:nezapoèítává se,
  * x 1:zapoèítává se do fondu PD
  *
  inline method doklhrmz_aut_modify(isAppend,isDeleted)
    local  recNo      := (::it_file)->( recNo())
    local  an_napocHM := { 0, 2, 3, 4, 5, 6 }
    local  ok_napocHM
    local  it_ndnyDoklad := (::it_file)->ndnyDoklad, it_ndnyDok_or := (::it_file)->ndnyDok_or
    local  it_nhodDoklad := (::it_file)->nhodDoklad, it_nhodDok_or := (::it_file)->nhodDok_or
    local  lcanRefresh   := .f.
    *
    local  hd_file       := ::hd_file
    local  it_file       := ::it_file
    local  is_offLine    := .f.
    *
    local  ok_praVzt      := ( msPrc_mo->ntypPraVzt <> 5 .and. msPrc_mo->nTypPraVzt <> 9 )
    local  is_student     := ( msPrc_mo->ntypZamVzt = 11 .or.  msPrc_mo->lStudent        )

    default isAppend  to .f. , ;
            isDeleted to .f.
    *
    ** tohle je jistota
    druhyMzd->(dbseek( (::it_file)->ndruhMzdy,, 'DRUHYMZD01'))
    ok_napocHM := ( ascan( an_napocHM, { |x| x = druhyMzd->nnapocHM } ) <> 0 )
    ok_napocHM := ( ok_napocHM .and. (druhyMzd->nnapocFPD = 1 ))

    if (::hd_file)->cdenik   = 'MH' .and. ;
       (::it_file)->nautoGen = 0    .and. ;
       ok_napocHM

      if .not. mzdDavHDwa->( eof())
        ::hd_file  := 'mzdDavHDwa'
        ::it_file  := 'mzdDavITwa'
        is_offLine := .t.
      endif

      (::it_file)->(dbgotop())
      do while .not. (::it_file)->(eof())
        if (::it_file)->nautoGen = 1
          lcanRefresh := .t.

          if isDeleted
            (::it_file)->nDnyDoklad += it_ndnyDoklad
            (::it_file)->nHodDoklad += it_nhodDoklad
          else
            (::it_file)->nDnyDoklad -= ( it_ndnyDoklad -it_ndnyDok_or )
            (::it_file)->nHodDoklad -= ( it_nhodDoklad -it_nhodDok_or )
          endif

          (::it_file)->nDnyFondKD := (::it_file)->nDnyDoklad
          (::it_file)->nDnyFondPD := (::it_file)->nDnyDoklad
          (::it_file)->nHodFondKD := (::it_file)->nHodDoklad
          (::it_file)->nHodFondPD := (::it_file)->nHodDoklad

          * bohužel na parentovi jsou taky hd_file a it_file
          ::m_parent:udcp:hd_file := ::hd_file
          ::m_parent:udcp:it_file := ::it_file

            ::m_parent:udcp:VypHrMz( .t. )

          * musíme pøepoèítat na položce sociální a zdravotní pojištìní
          druhyMzd->(dbseek( (::it_file)->ndruhMzdy,, 'DRUHYMZD01'))
          (::it_file)->nzaklSocPo := 0
          (::it_file)->nzaklZdrPo := 0

          if msPrc_mo->lsocPojis .and. druhyMzd->lsocPojis .and. ok_praVzt
            (::it_file)->nzaklSocPo := (::it_file)->nHrubaMZD
          endif

          if msPrc_mo->nzdrPojis <> 0 .and. druhyMzd->lzdrPojis .and. ok_praVzt
            (::it_file)->nzaklZdrPo := (::it_file)->nHrubaMZD
          endif

          ::m_parent:udcp:hd_file := hd_file
          ::m_parent:udcp:it_file := it_file
        endif

        (::it_file)->(dbskip())
      enddo

      if is_offLine
        ::doklhrmz_aut_cmp()
      else
        (::it_file)->(dbgoTo( recNo))
        if( .not. isAppend .and. lcanRefresh, ::brow:refreshAll(), nil  )
      endif

      * raddìji to vrátíme, pro sichr
      ( ::hd_file := hd_file, ::it_file := it_file )

      (::it_file)->nDnyDok_or := (::it_file)->ndnyDoklad
      (::it_file)->nHodDok_or := (::it_file)->nhodDoklad
    endif
  return self

  * musíme pøepoèítat hlavièku automatu
  inline method doklhrmz_aut_cmp()

    mzdDavHdwa->nHrubaMZD  := mzdDavHdwa->nMzda      := ;
      mzdDavHdwa->nZaklSocPo := mzdDavHdwa->nZaklZdrPo := ;
        mzdDavHdwa->nDnyFondKD := mzdDavHdwa->nDnyFondPD := ;
          mzdDavHdwa->nDnyDovol  := mzdDavHdwa->nHodFondKD := ;
            mzdDavHdwa->nHodFondPD := mzdDavHdwa->nHodPresc  := ;
              mzdDavHdwa->nHodPrescS := mzdDavHdwa->nHodPripl  := 0

    mzdDavITwa->(dbgotop())
    do while .not. mzdDavITwa->(eof())
      mzdDavHdwa->nHrubaMZD  += mzdDavITwa->nHrubaMZD
      mzdDavHdwa->nMzda      += mzdDavITwa->nMzda

      mzdDavHdwa->nZaklSocPo += mzdDavITwa->nZaklSocPo
      mzdDavHdwa->nZaklZdrPo += mzdDavITwa->nZaklZdrPo

      mzdDavHdwa->nDnyFondKD += mzdDavITwa->nDnyFondKD
      mzdDavHdwa->nDnyFondPD += mzdDavITwa->nDnyFondPD
      mzdDavHdwa->nDnyDovol  += mzdDavITwa->nDnyDovol

      mzdDavHdwa->nHodFondKD += mzdDavITwa->nHodFondKD
      mzdDavHdwa->nHodFondPD += mzdDavITwa->nHodFondPD
      mzdDavHdwa->nHodPresc  += mzdDavITwa->nHodPresc
      mzdDavHdwa->nHodPrescS += mzdDavITwa->nHodPrescS
      mzdDavHdwa->nHodPripl  += mzdDavITwa->nHodPripl

      mzdDavITwa->(dbskip())
    enddo
  return self

ENDCLASS


static function can_setValues( it_file, hd_file, m_parent )
  local  ddatOd, ddatDo, lok := .f., is_itOk := .f.
  local  anFond, aDnNem, aOst
  local  ndny_PRAC, ndny_SVAT, ndny_VOLN
  local  it_nordItem := 10
  *
  local  ddatFirst   := mh_FirstODate(uctOBDOBI:MZD:NROK,uctOBDOBI:MZD:NOBDOBI)
  local  ddatLast    := mh_LastODate(uctOBDOBI:MZD:NROK,uctOBDOBI:MZD:NOBDOBI)
  local  ndelkPDhod  := FpracDoba( msPrc_mo->cDelkPrDob)[3]
  *
  local  cmain_Ky    := strZero(msPrc_mo->nrok,4) +strZero(msPrc_mo->nobdobi,2) + ;
                        strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)
  *
  **
  local  hodnZdrSt  := sysConfig('MZDY:nHodnZdrSt')
  local  ok_praVzt  := ( msPrc_mo->ntypPraVzt <> 5 .and. msPrc_mo->nTypPraVzt <> 9 )
  local  is_student := ( msPrc_mo->ntypZamVzt = 11 .or.  msPrc_mo->lStudent        )


  ddatOd := if( ddatFirst >= msPrc_mo->ddatNast, ddatFirst, msPrc_mo->ddatNast)

  if ( ddatLast >= msPrc_mo->ddatVyst .and. msPrc_mo->ddatVyst > ddatFirst) ;
                                       .or. empty( msPrc_mo->ddatVyst)
    lOK    := .T.
    ddatDo := if( Empty( msPrc_mo->ddatVyst), ddatLast, msPrc_mo->ddatVyst)
  else
    lOK := .F.
  endif

  if lok
    mzdDavitA->( dbsetScope( SCOPE_BOTH, cmain_Ky))

    ndny_PRAC := D_dnyODdo( ddatOd, ddatDo, "PRAC")
    ndny_SVAT := D_dnyODdo( ddatOd, ddatDo, "SVAT")
    ndny_VOLN := D_dnyODdo( ddatOd, ddatDo, "VOLN")

    aOst      := arrOstO()
    aDnNem    := arrNemO()
    anFond    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    *  1
    anFond[ 1]           := ndny_PRAC +ndny_SVAT
    *  2
    anFond[ 2]           := anFond[1] * ndelkPDhod
    *  3
    anFond[ 3]           := ndny_PRAC +ndny_SVAT -( aDnNem[1] + aOst[1] )
    *  4
    anFond[ 4]           := anFond[2]            -( aDnNem[3] + aOst[2] )
    *  5
    anFond[ 5]           := anFond[4]            +( aOst[3]   + aOst[4] )
    *  6
    *  7
    *  8
    *  9
    anFond[ 9]           := ndny_SVAT
    * 10
    anFond[10]           := ndny_VOLN - aDnNem[2]
    * 11
    * 12
    anFond[12]           := ndny_PRAC
    * 13
    anFond[13]           := anFond[12] * ndelkPDhod
    * 14
    anFond[14]           := ndny_PRAC  - ( aDnNem[1] + aOst[1] )
    * 15
    anFond[15]           := anFond[13] - ( aDnNem[3] + aOst[2] )
    * 16
    anFond[16]           := aOst[3]

    if anFond[1] > 0
      do while .not. (it_file)->( eof())
        is_itOk := .f.

        do case
        case (it_file)->ndruhMzdy = 120 .or. (it_file)->ndruhMzdy = 122
          is_itOk               := .t.

          (it_file)->nordItem   := it_nordItem
          (it_file)->nDnyDoklad := if( (it_file)->ndruhMzdy = 120, anFond[14], anFond[3])
          (it_file)->nHodDoklad := anFond[5]

          (it_file)->nDnyFondKD := (it_file)->nDnyDoklad
          (it_file)->nDnyFondPD := (it_file)->nDnyDoklad
          (it_file)->nHodFondKD := (it_file)->nHodDoklad
          (it_file)->nHodFondPD := (it_file)->nHodDoklad

          (hd_file)->nautoGen   := 1
          (it_file)->nautoGen   := 1

          * jen TMP
          (it_file)->ndnyDok_or := (it_file)->ndnyDoklad
          (it_file)->nhodDok_or := (it_file)->nhodDoklad

          m_parent:udcp:VypHrMz( .t. )

        case (it_file)->ndruhMzdy = 199
          is_itOk               := .t.

          (it_file)->nordItem   := it_nordItem

          (it_file)->nDnyDoklad := anFond[10]
          (it_file)->nHodDoklad := anFond[10] * ndelkPDhod
          (it_file)->nDnyFondKD := (it_file)->nDnyDoklad    // anFond[3]
          (it_file)->nHodFondKD := (it_file)->nHodDoklad    // anFond[4]

        endcase

        if is_itOk
          druhyMzd->( dbseek((it_file)->ndruhMzdy,, 'DRUHYMZD01') )

          m_parent:udcp:aktFnd_DnyHod()
          (it_file)->nHrubaMZD := (it_file)->nmzda

          (it_file)->cucetskup := allTrim( Str( (it_file)->ndruhMzdy))
          (it_file)->nzaklSocPo := 0
          (it_file)->nzaklZdrPo := 0

          if msPrc_mo->lsocPojis .and. druhyMzd->lsocPojis .and. ok_praVzt
            (it_file)->nzaklSocPo := (it_file)->nHrubaMZD
          endif

          if msPrc_mo->nzdrPojis <> 0 .and. druhyMzd->lzdrPojis .and. ok_praVzt
            (it_file)->nzaklZdrPo := (it_file)->nHrubaMZD
          endif
        endif

        it_nordItem += 10
        (it_file)->(dbskip())
      enddo
    endif

    (it_file)->(dbgoTop())
  endif
return nil


*
** vrací pole celkové memoci za procovníka v obobí
static function arrNemO()
  local  aDnNem := { 0, 0, 0, 0 }

  mzdDavitA->( dbeval( { || ( aDnNem[1] += mzdDavitA->nVykazN_PD, ;
                              aDnNem[2] += mzdDavitA->nVykazN_VD, ;
                              aDnNem[3] += mzdDavitA->nHodFondPD, ;
                              aDnNem[4] += 0 ) }                , ;
                       { || mzdDavitA->cdenik = 'MN'                                     }  ))

//                              mzdDavitA->nNemocNiSa +mzdDavitA->nNemocVySa ) }, ;

return aDnNem
*
** vrací pole celkem odpracovaná doba za pracovníka v období
static function arrOstO()
  local aOst := { 0, 0, 0, 0, 0, 0, 0, 0}

  mzdDavitA->( dbgotop())
  do while .not. mzdDavitA->( eof())
    if mzdDavitA->cdenik = 'MH'
      druhyMzdA->( dbseek( mzdDavitA->ndruhMzdy ))
      c_typDmzA->( dbseek( druhyMzdA->ctypDmz   ))

      aOst[1] += mzdDavitA->nDnyFondPD
      aOst[2] += mzdDavitA->nHodFondPD
      aOst[3] += mzdDavitA->nHodPresc
      aOst[4] += mzdDavitA->nHodPrescS
      aOst[5] += mzdDavitA->nDnyFondKD
      aOst[6] += mzdDavitA->nHodFondKD
      aOst[7] += if( mzdDavitA->nDruhMzdy  = 142 , mzdDavitA->nHodDoklad, 0 )
      aOst[8] += if( c_typDmzA->ctypNapHoC = "OD", mzdDavitA->nHodDoklad, 0 )
      aOST[8] -= if( c_typDmzA->cTypNapHoC = "PR", mzdDavitA->nHodPresc , 0 )
    endif

    mzdDavitA->( dbSkip())
  enddo

return aOst