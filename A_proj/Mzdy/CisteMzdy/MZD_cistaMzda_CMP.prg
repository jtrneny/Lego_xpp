#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
//
#include "..\Asystem++\Asystem++.ch"


//  AKTUALIZACE promìnné o stavu výpoètu ÈM - nstaVypoCM v MSPRC_MO
*  0 - nebyl proveden žádný výpoèet èisté mzdy
*  1 - nad zamìstnancem byl proveden automatický výpoèet èisté mzdy
*  2 - nad zamìstnancem byl proveden ruèní  výpoèet èisté mzdy
*  6 - výpoèet èisté mzdy byl ruènì zrušen
*  7 - výpoèet èisté mzdy byl zrušen aktualizací dat
*  8 - výpoèet èisté mzdy neprobìhl do konce
*  9 - nad zamìstnancem probíhá výpoèet èisté mzdy


*
** CLASS MZD_cistaMzda_CMP ********************************************************
CLASS  MZD_cistaMzda_CMP
EXPORTED:

  inline method init(parent, oDBro_main)
    local drgDialog := parent:drgDialog, members, x, in_file

    ::oDBro_main := oDBro_main
    ::xbp_therm  := parent:oMessageBar:msgStatus

    ::rok       := uctOBDOBI:MZD:NROK
    ::obdobi    := uctOBDOBI:MZD:NOBDOBI
    ::firstDay  := mh_FirstODate( ::rok, ::obdobi)
    ::lastDay   := mh_LastDayOBD( ::rok, ::obdobi)

    ::staVypoCM := if( lower(drgDialog:formName) = 'mzd_kmenove_scr', 1, 2 )
    return self


  * pøed spuštìním èistých mezd musíme zkontrovat blok druhyMzdX->mdefNap
  inline method mzd_druhyMzd_audit()
    local  bSaveErrorBlock := ErrorBlock( {|e| Break(e)} )
    local  cfiltr, nrok, nobdobi, cb_mdefNap
    local  cdruhMzdy_err := '', npos
    *
    local  pa_druhyMzd   := {}

    nrok    := uctOBDOBI:MZD:NROK
    nobdobi := uctOBDOBI:MZD:NOBDOBI

    drgDBMS:open('druhyMzd',,,,,'druhyMzdX')
    cfiltr := Format("nROK = %% .and. nOBDOBI = %%", {nrok,nobdobi})
    druhyMzdX->( ads_setaof(cfiltr), dbGoTop())

    drgDBMS:open('mzdyhdW',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('mzdyitW',.T.,.T.,drgINI:dir_USERfitm); ZAP

    do while .not. druhyMzdX->(eof())
      *  nìjak se v ditribuci podaøilo založit 2x stejný druh mzdy
      if ascan( pa_druhyMzd, druhyMzdX->ndruhMzdy) <> 0
        cdruhMzdy_err += if( empty(cdruhMzdy_err), '', ',') +str( druhyMzdX->ndruhMzdy)
      endif

      cb_mdefNap := MemoTran(lower(druhyMzdX->mdefNap), ', ', '')

      if .not. empty( cb_mdefNap )
        cb_mdefNap := strTran( cb_mdefNap, 'mzdyhd', 'mzdyhdw' )
        cb_mdefNap := strTran( cb_mdefNap, 'mzdyit', 'mzdyitw' )

        if right( cb_mdefNap, 1 ) = ','
          cb_mdefNap := subStr( cb_mdefNap, 1, len(cb_mdefNap) -1)
        endif

        begin sequence
          eval( COMPILE( cb_mdefNap ))
        recover using oError
          cdruhMzdy_err += if( empty(cdruhMzdy_err), '', ',') +str( druhyMzdX->ndruhMzdy)
        end sequence
      endif

      aadd( pa_druhyMzd, druhyMzdX->ndruhMzdy)
      druhyMzdX->( dbskip())
    enddo

    ErrorBlock(bSaveErrorBlock)
    return cdruhMzdy_err


  inline method mzd_cistaMzda_start()
    local oldoscis, cky, ndanZaklSP
    local lcanCmp_cp, cky_a
    *
    local  ctitle := 'Výpoèet èistých mezd NELZE spustit'
    local  cinfo  := 'Promiòte prosím,'                            +CRLF + ;
                     'výpoèet èistých mezd NELZE spustit         ' +CRLF + ;
                     'na èíselníku druhy mezd jsem našel chyby v ' +CRLF + ;
                     'mzdových položkách '


    if .not. empty( cdruhMzdy_err := ::mzd_druhyMzd_audit() )
      cinfo += cdruhMzdy_err                             +CRLF +CRLF
      cinfo += '... kontaktujte prosím distributora ...' +CRLF

      confirmBox( , cinfo, ctitle, ;
                    XBPMB_CANCEL , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      return .f.
    endif
    *
    ** po init si pøepne období a zùstane tam pùvodní, blbne výpoèet
    ::rok       := uctOBDOBI:MZD:NROK
    ::obdobi    := uctOBDOBI:MZD:NOBDOBI
    ::firstDay  := mh_FirstODate( ::rok, ::obdobi)
    ::lastDay   := mh_LastDayOBD( ::rok, ::obdobi)

    ::xbp_therm:cargo := ''
    ::start_worm()

    ::Add_Mzddavit_to_Mzdyit()
    * JT
    * Vlastní výpoèet èisté mzdy
    *
    * nìkteré soubory nemusí být otevøeny na parentovi
    if(select('msSrz_mo') = 0, drgDBMS:open( 'msSrz_mo'), nil )

    drgDBMS:open( 'msprc_mo',,,,, 'msprc_moA')
      msPrc_MoA->( ordsetFocus( 'MSPRMO01' ))

    drgDBMS:open( 'msprc_mo',,,,, 'msprc_moC')
    drgDBMS:open( 'msprc_mo',,,,, 'msprc_moM')
    drgDBMS:open( 'mssrz_mo',,,,, 'mssrz_moC')
    drgDBMS:open( 'mssrz_mo',,,,, 'mssrz_moM')

    drgDBMS:open('asystem',,,,,'asystema')
    drgDBMS:open('druhymzd',,,,,'druhymzda')
    drgDBMS:open('c_odpoc')
    drgDBMS:open('c_pracvz',,,,,'c_pracvzc')
    drgDBMS:open('msodppol')
    drgDBMS:open('mzdyhd')
    drgDBMS:open('mzdyhd',,,,,'mzdyhdA')
    drgDBMS:open('mzdyhd',,,,,'mzdyhdC')
    drgDBMS:open('mzdyit')
    drgDBMS:open('mzdyhdW',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('mzdyitW',.T.,.T.,drgINI:dir_USERfitm); ZAP

    drgDBMS:open('mssrz_moW',.T.,.T.,drgINI:dir_USERfitm); ZAP

    drgDBMS:open('gen_parW',.T.,.T.,drgINI:dir_USERfitm); ZAP
    gen_parW->( dbAppend())


    file_name := mzdyhdW ->( DBInfo(DBO_FILENAME))
                 mzdyhdW ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, 'mzdyhdW', .t., .f.)  ;   mzdyhdW->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'mzdyhdWa', .t., .t.) ;   mzdyhdWa ->(AdsSetOrder(1))

    cfiltr := Format("nRok = %%", {::rok})
    c_odpoc ->(ads_setaof(cfiltr), dbGoTop())

    cfiltr := Format("nrok = %% .and. nobdobi = %% .and. nstaVypoCM = %%", {::rok,::obdobi,9})
    MsPrc_MOa ->(ads_setaof(cfiltr), dbGoTop())

    oldOsCis  := 0

    do while .not. MsPrc_MOa ->( Eof())
      // mìlo by se zde ještì doplnit test zda mìl v minulém období vypoètenou mzdu
      // a pokud ne nastavit MsPrc_Moa->lmzdavroce := .f.

      ::xbp_therm:cargo := '[ ' + allTrim(msPrc_moA->cjmenoRozl) +' ]'

      if oldoscis <> MsPrc_MOa ->nOsCisPrac

        mzdyhdw ->( dbEval( {||dbDelete()}))
        mzdyitw ->( dbZap())

        cfiltr := Format("nrokobd = %% .and. noscisPrac = %%", {::rok*100+::obdobi,MsPrc_MOa->noscisPrac})
        mzdyhdA ->(ads_setaof(cfiltr), dbGoTop())
        mzdyhdA ->( dbEval( {||Mh_CopyFld('mzdyhdA','mzdyhdw',.t.,.t.)}))

        lcanCmp_cm := .t.

        if mzdyhdw->( Mh_countrec()) = 0
          lcanCmp_cm := .f.

          if msPrc_moA->lstavem
            Mh_CopyFld('msprc_moa','mzdyhdw',.t.)
          endif
        endif

        ndanZaklSP   := 0
//        mzdyhdw->( dbeval( { || ndanZaklSP += mzdyhdw->ndanZaklMZ } ), dbgotop() )
//        ::ndanZaklSP := ndanZaklSP

        mzdyhdw->( dbgotop())
        do while .not. mzdyhdw->( eof())
          cky := strZero(mzdyhdw->nrok,4) +strZero(mzdyhdw->nobdobi,2) + ;
                 strZero(mzdyhdw->noscisPrac,5) +strZero(mzdyhdw->nporPraVzt,3)
          msprc_moC ->( dbseek( cky,,'MSPRMO01'))
          c_pracvzC ->( dbseek( msprc_moC->nTypPraVzt,,'C_PRACVZ01'))

          mzdyhdw->cdenik := 'MC'

          if lcanCmp_cm
            ::Uprav_Napocty()
            ::Vyp_SocPoj()
            ::Vyp_ZdrPoj()
            do case
            case ::rok <= 2013                      ;    ::Vyp_DanMzd()
            case ::rok >= 2014 .and. ::rok <= 2017  ;    ::Vyp_DanMzd_14()
            case ::rok >= 2018 .and. ::rok <= 2020  ;    ::Vyp_DanMzd_18()
            case ::rok >= 2021                      ;    ::Vyp_DanMzd_21()
            endcase
            ::Vyp_SlevOdpDan()
            ::Vyp_CisMzd()

            if( mzdyhdw->nCastKVypl <> 0, ::Gen_SrzMzd(), ::Gen_SrzMzd(.f.))
          endif

          mzdyhdw->( dbskip())
        enddo

        oldoscis  := MsPrc_MOa ->nOsCisPrac
      endif

      mzdyhdA   ->(ads_clearaof())
      MsPrc_MOa ->( dbSkip())

      if ( oldoscis <> MsPrc_MOa ->nOsCisPrac ) .or. msprc_moa ->( eof())
        if mzdyitW->( Mh_countrec()) = 0
           cky_a := strZero(msPrc_moA->nrok,4) +strZero(msPrc_moA->nobdobi,2) + ;
                    strZero(msPrc_moA->noscisPrac,5) +strZero(msPrc_moA->nporPraVzt,3)
           msprc_moC ->( dbseek( cky_a,,'MSPRMO01'))

          if msprc_moC->( dbRlock())
             msprc_moC->nstavypocm := 0
             msprc_moC->(dbunlock(), dbcommit())
          endif
        else
          ::Save_Mzdy__()
        endif
      endif
    enddo

    MsPrc_MOa ->(ads_clearaof())
    mzdyhdw->( dbCloseArea())
    mzdyhdwA->( dbCloseArea())

    ::mzd_cistaMzda_end()

    ::stop_worm()
    return .t.


hidden
  var oDBro_main
  var xbp_therm, oThread_w
  var rok, obdobi, ndanZaklSP, staVypoCM
  var firstDay, lastDay

  method danZalVyp, danPrcVyp, danSolidVyp, OKsrz, zaokrMzdy
  method zustDovol, zustDovolHod


  inline method start_worm()
    local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread_w
    local     xbp_therm := ::xbp_therm
    *
    ** nachystáme si èervíka v samostatném vláknì
    for i := 1 to 4 step 1
      aBitMaps[3,i] := XbpBitmap():new():create()
      aBitMaps[3,i]:load( ,nPHASe )
      nPHASe++
    next

    ::oThread_w := Thread():new()
    ::oThread_w:setInterval( 8 )
    ::oThread_w:start( "mzd_kmenove_scr_animate", xbp_therm, aBitMaps)
    return self

  inline method stop_worm()
    ::oThread_w:setInterval( NIL )
    ::oThread_w:synchronize( 0 )
    ::oThread_w := nil

    ::xbp_therm:setCaption('')
    return self


  inline method Add_Mzddavit_to_Mzdyit()
    local coscisPrac := '', x, pa_oscisPrac := {}
    local stmt := "EXECUTE PROCEDURE p_MZD_Add_Mzddavit_to_Mzdyit( %%, %%, '%%');"
    local cStatement, oStatement, lrun_sp := .f.
    *
    local staVypoCM

    do case
    case ::oDBro_main:is_selAllRec
      coscisPrac := ''
      lrun_sp    := .t.

    case len( ::oDBro_main:arSelect) <> 0
      fordRec( {'msprc_mo'} )
      for x := 1 to len( ::oDBro_main:arSelect) step 1
        msprc_mo->( dbgoTo( ::oDBro_main:arSelect[x]))
        staVypoCM := msPrc_mo->nstaVypoCM

        if ascan( pa_oscisPrac, msprc_mo->noscisPrac) = 0
          * je èistá mzda již spoèítaná ? nepoèítáme
*          if staVypoCM = 1 .or. staVypoCM = 2
*          else
            coscisPrac += strTran( str(msprc_mo->noscisPrac), ' ', '') +','
*          endif
        endif
        aadd( pa_oscisPrac, msprc_mo->noscisPrac)
      next
      fordRec()
      coscisPrac := left( coscisPrac, len( coscisPrac) -1)
      lrun_sp    := (len(coscisPrac) <> 0)

    otherwise
      staVypoCM := msPrc_mo->nstaVypoCM

      * je èistá mzda již spoèítaná ? nepoèítáme
*      if staVypoCM = 1 .or. staVypoCM = 2
*      else
        coscisPrac += strTran( str(msprc_mo->noscisPrac), ' ', '')
*      endif
      lrun_sp    := (len(coscisPrac) <> 0)

    endcase

    if lrun_sp
      cStatement := format( stmt, { ::rok, ::obdobi, coscisPrac })
      oStatement := AdsStatement():New(cStatement,oSession_data)

      if oStatement:LastError > 0
        return .f.
      endif
      oStatement:Execute( 'test', .f. )
      oStatement:Close()

    endif
    return self


  inline method mzd_cistaMzda_end()
    local cStatement, oStatement
    local stmt := 'update msprc_mo set nstaVypoCM = 0 ' + ;
                  'where (nrok = %% and nobdobi = %% and nstaVypoCM = 9)';

    cStatement := format( stmt, { ::rok, ::obdobi })
    oStatement := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
*      return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif
    return self



// vygeneruje automaticky dny dopoètem dle zadané konfigurace
  inline method Gen_DnyFond()
    *

    return self


// vygeneruje automaticky dny dopoètem dle zadané konfigurace
  inline method Uprav_Napocty()
    local  dnast, dvyst
    local  nx
    local  sumZakSoc, sumZakZdr
    local  maxZakSoc, maxZakZdr
    local  cf := "nrok = %% .and. nobdobi <= %% .and. noscisprac = %% .and. nporpravzt = %%"
    *
    sumZakSoc := sumZakZdr := 0
    maxZakSoc := SysConfig( 'mzdy:nMaxZakSoc', ::firstDay)
    maxZakZdr := SysConfig( 'mzdy:nMaxZakZdr', ::firstDay)

  // naplnìní kalendáøního a pracovního fondu ve dnech
    if msprc_moC->ddatnast <= mh_LastODate( msprc_moC->nRok, msprc_moC->nObdobi)
      dnast := mh_FirstODate( msprc_moC->nRok, msprc_moC->nObdobi)
      if Year( msprc_moC->dDatNast) = msprc_moC->nRok                          ;
           .and. Month( msprc_moC->dDatNast) = msprc_moC->nObdobi
        dnast := msprc_moC->dDatNast
      endif
    endif

    if msprc_moC->ddatvyst >= mh_FirstODate( msprc_moC->nRok, msprc_moC->nObdobi) ;
           .or. Empty( msprc_moC->ddatvyst)
      dvyst := mh_LastODate( msprc_moC->nRok, msprc_moC->nObdobi)
      if Year( msprc_moC->ddatvyst) = msprc_moC->nRok                          ;
           .and. Month( msprc_moC->dDatVyst) = msprc_moC->nObdobi
        dvyst := msprc_moC->dDatVyst
      endif
    endif

    if !Empty( dnast) .and. !Empty( dvyst)
      mzdyhdw->nFondKDDn  := D_DnyOdDo(dnast,dvyst,"KALE",'msprc_moC')
      mzdyhdw->nFondPDDn  := D_DnyOdDo(dnast,dvyst,"PRAC",'msprc_moC')
      mzdyhdw->nFondPDsDn := D_DnyOdDo(dnast,dvyst,"PRAC",'msprc_moC') +D_DnyOdDo(dnast,dvyst,"SVAT",'msprc_moC')

      mzdyhdw->nFondPDHo  := mzdyhdw->nFondPDDn  * fPracDOBA( msprc_moC->cDelkPrDob)[3]
      mzdyhdw->nFondPDSHo := mzdyhdw->nFondPDsDn * fPracDOBA( msprc_moC->cDelkPrDob)[3]
    endif

    if msprc_moC->ntyppravzt = 50
      mzdyhdw->nHodFondUP = 0
    endif

    mzdyhdw->nHrubaMzda  := Mh_RoundNumb( mzdyhdw->nHrubaMzda, 31)
    ( gen_parW->nMzda    := mzdyhdw->nHrubaMzda, ::genmzdyIT(900))

    mzdyhdw->ndanZaklMZ  := Mh_RoundNumb( mzdyhdw->ndanZaklMZ, 31)

    mzdyhdw->nZaklSocPo  := Mh_RoundNumb( mzdyhdw->nZaklSocPo, 31)
    mzdyhdw->nZakSocZaD  := Mh_RoundNumb( mzdyhdw->nZakSocZaD, 31)
    mzdyhdw->nZakSocStO  := Mh_RoundNumb( mzdyhdw->nZakSocStO, 31)
    mzdyhdw->nZakSocPrD  := Mh_RoundNumb( mzdyhdw->nZakSocPrD, 31)

    mzdyhdw->nZaklZdrPo  := Mh_RoundNumb( mzdyhdw->nZaklZdrPo, 31)
    mzdyhdw->nZakZdrZaD  := Mh_RoundNumb( mzdyhdw->nZakZdrZaD, 31)
    mzdyhdw->nZakZdrPrD  := Mh_RoundNumb( mzdyhdw->nZakZdrPrD, 31)

    mzdyhdw->nNapMinMzd  := Mh_RoundNumb( mzdyhdw->nNapMinMzd, 31)
    mzdyhdw->nZaklOdbor  := Mh_RoundNumb( mzdyhdw->nZaklOdbor, 31)

    mzdyhdw->nCistPrije  := Mh_RoundNumb( mzdyhdw->nCistPrije, 31)
    mzdyhdw->nCastKVypl  := Mh_RoundNumb( mzdyhdw->nCastKVypl, 31)

//  zjištìní max hodnot základù pro SOC a ZDR
      *
    if mzdyhdw->nobdobi > 1 .and. ( maxZakSoc > 0 .or. maxZakZdr > 0)
      cfiltr := Format( cf, { mzdyhdw->nrok, mzdyhdw->nobdobi-1, mzdyhdw->noscisprac, mzdyhdw->nporpravzt })
      mzdyhdC->( ads_setaof(cfiltr), dbGoTop())
      mzdyhdC->( dbeval( { || ( sumZakSoc += mzdyhdC->nZaklSocPo, sumZakZdr += mzdyhdC->nZaklZdrPo)} ))
      mzdyhdC->( ads_clearaof())

      if maxZakSoc > 0
        if sumZakSoc > maxZakSoc
          mzdyhdw->nZaklSocPo := 0
          mzdyhdw->nZakSocZaD := 0
          mzdyhdw->nZakSocStO := 0
          mzdyhdw->nZakSocPrD := 0
        else
          if (sumZakSoc + mzdyhdw->nZaklSocPo) > maxZakSoc
            mzdyhdw->nZaklSocPo := Mh_RoundNumb( maxZakSoc - sumZakSoc, 31)
            mzdyhdw->nZakSocZaD := mzdyhdw->nZaklSocPo
          endif
        endif
      endif

      if maxZakZdr > 0
        if sumZakZdr > maxZakZdr
          mzdyhdw->nZaklZdrPo := 0
          mzdyhdw->nZakZdrZaD := 0
          mzdyhdw->nZakZdrPrD := 0
        else
          if (sumZakZdr + mzdyhdw->nZaklZdrPo) > maxZakZdr
            mzdyhdw->nZaklZdrPo := Mh_RoundNumb( maxZakZdr - sumZakZdr, 31)
            mzdyhdw->nZakZdrZaD := mzdyhdw->nZaklZdrPo
          endif
        endif
      endif
    endif

    return self


// vypoète sociální pojištìní zamìstnance
  inline method Vyp_SocPoj()
    local ax, cx
    local procOrg := 0, procZam := 0
    local okSoc := .t.
    local duchSpor2P := 0
    *
    if ( msprc_moC->lsocpojis .and. mzdyhdw->nZaklSocPo <> 0 ) .or. mzdyhdw->nZakSocOpr <> 0
      ax       := Mh_Token( SysConfig( 'mzdy:cnOdvSocZa'))
      aEval( ax, {|X|  procZam += Val(X) })
      ax       := Mh_Token( SysConfig( 'mzdy:cnOdvSocOr', ::firstDay))
      aEval( ax, {|X|  procOrg += Val(X) })

      if msprc_moC->lzammalroz
        okSoc := mzdyhdw->nZaklSocPo >= SysConfig( 'mzdy:nUcastSocP')
        mzdyhdw->nZaklSocPo := if( okSoc, mzdyhdw->nZaklSocPo, 0)
      endif

      if msprc_moC->lzamkratko
        okSoc := mzdyhdw->nDnyFondKD >= SysConfig( 'mzdy:nUcastSocP')
        mzdyhdw->nZaklSocPo := if( okSoc, mzdyhdw->nZaklSocPo, 0)
      endif

      if .not. msprc_moC->lsocpojis .and. mzdyhdw->nZakSocOpr <> 0
        mzdyhdw->nZaklSocPo := mzdyhdw->nZakSocOpr
      endif

      if mzdyhdw->nZaklSocPo <> 0 .and. okSoc
        if msprc_moC->lDuchSp2Pi
          mzdyhdw->lDuchSp2Pi := msprc_moC->lDuchSp2Pi
          mzdyhdw->nZakSocDS2 := mzdyhdw->nZaklSocPo
          duchSpor2P          := Mh_RoundNumb( mzdyhdw->nZaklSocPo * 5.0/100, 31)
          mzdyhdw->nOdvSoDS2Z := Mh_RoundNumb( mzdyhdw->nZaklSocPo * 3.5/100, 31)
          mzdyhdw->nOdvoSocPZ := mzdyhdw->nOdvSoDS2Z
          if duchSpor2P > 0
            ( gen_parW->nMzda := duchSpor2P, ::genmzdyIT(582))
            if mzdyhdw->nCastKVypl >= duchSpor2P
              mzdyhdw->nCastKVypl -= duchSpor2P
            endif
          endif
        else
          mzdyhdw->nOdvoSocPZ := Mh_RoundNumb( mzdyhdw->nZaklSocPo * procZam/100, 31)
        endif

        mzdyhdw->nOdvoSocPO := Mh_RoundNumb( mzdyhdw->nZaklSocPo * procOrg/100, 31)

        ( gen_parW->nMzda := mzdyhdw->nZaklSocPo, ::genmzdyIT(904))

        if msprc_moC->nSocPojOdv = 2 .and. mzdyhdw->nZaklSocPo <> 0
          if mzdyhdw->nZaklSocPo > 52253
            mzdyhdw->nZaklSlePo := 52253
          else
            mzdyhdw->nZaklSlePo := mzdyhdw->nZaklSocPo
          endif
        endif

        ( gen_parW->nMzda := mzdyhdw->nOdvoSocPZ, ::genmzdyIT(504))

        ( gen_parW->nMzda := mzdyhdw->nOdvoSocPO, ::genmzdyIT(704))

        mzdyhdw->nOdvoSocPC := mzdyhdw->nOdvoSocPZ +  mzdyhdw->nOdvoSocPO

      endif
    else
      mzdyhdw->nZaklSocPo := mzdyhdw->nZakSocZaD := mzdyhdw->nZakSocStO := mzdyhdw->nZakSocPrD := 0
    endif

    return self

// vypoète zdravotní pojištìní zamìstnance
  inline method Vyp_ZdrPoj()
    local ax, nx, ny, cx, ok
    local procOrg := procZam := 0.00
    local minMzda
    local slovZdr
    local okZdr := .t.
    *
    minMzda := SysConfig( 'mzdy:nMinMzdaNS', ::firstDay)
    slovZdr := SysConfig( 'mzdy:nhodnzdrst')

    ok := ( mzdyhdw->nZaklZdrPo + mzdyhdw->nDnyNV + mzdyhdw->nDnyABS + msprc_moC->nZdrPojDop) <> 0

    if ( msprc_moC->lzdrpojis .and. ok ) .or. mzdyhdw->nZakZdrOpr <> 0
      procZam := SysConfig( 'mzdy:nOdvZdrZam' )
      procOrg := SysConfig( 'mzdy:nOdvZdrOrg' )

*      ax       := Mh_Token( SysConfig( 'mzdy:nOdvZdrZam'))
*      aEval( ax, {|X|  procZam += Val(X) })
*      ax       := Mh_Token( SysConfig( 'mzdy:nOdvZdrOrg'))
*      aEval( ax, {|X|  procOrg += Val(X) })


      if msprc_moC->lzammalroz     //   pozor toto pohlídat jinak èlen družstva, dohoda o èinnosti,peèovatelská služba
        okZdr := mzdyhdw->nZaklZdrPo >= SysConfig( 'mzdy:nUcastZdrP')
        mzdyhdw->nZaklZdrPo := if( okZdr, mzdyhdw->nZaklZdrPo, 0)
      endif

      if .not. msprc_moC->lzdrpojis .and. mzdyhdw->nZakZdrOpr <> 0
        mzdyhdw->nZaklZdrPo := mzdyhdw->nZakZdrOpr
      endif

      if mzdyhdw->nZaklZdrPo <> 0 .and. okZdr
        if slovZdr = 999
          mzdyhdw->nOdvoZdrPZ := Mh_RoundNumb( mzdyhdw->nZaklZdrPo * (procZam)/100, 31)
          mzdyhdw->nOdvoZdrPO := Mh_RoundNumb( mzdyhdw->nZaklZdrPo * (procOrg)/100, 31)
        else
//        mzdyhdw->nOdvoZdrPZ := Mh_RoundNumb( mzdyhdw->nZaklZdrPo * procZam/100, 31)
          nx                  := Mh_RoundNumb( mzdyhdw->nZaklZdrPo * (procZam + procOrg)/100, 31)
          mzdyhdw->nOdvoZdrPZ := Mh_RoundNumb( nx /3, 31)
          mzdyhdw->nOdvoZdrPO := nx - mzdyhdw->nOdvoZdrPZ
        endif
      endif

      if mzdyhdw->nZaklZdrPo < minMzda .and. msprc_moC->nZdrPojDop > 0
        if mzdyhdw->nDnyNemoKD > 0 .or. mzdyhdw->nFondKDDn < ::lastDay
          mzdyhdw->nZakZdrMin := Mh_RoundNumb( minMzda/::lastDay *         ;
                                    ( mzdyhdw->nFondKDDn -mzdyhdw->nDnyNemoKD),32)
        else
          mzdyhdw->nZakZdrMin := minMzda
        endif

        if mzdyhdw->nZakZdrMin > mzdyhdw->nZaklZdrPo

          nx                  := Mh_RoundNumb( mzdyhdw->nZakZdrMin * (procZam + procOrg)/100, 31)
          mzdyhdw->nOdvoZdrMZ := Mh_RoundNumb( nx /3, 31)
          mzdyhdw->nOdvoZdrMZ := mzdyhdw->nOdvoZdrMZ - mzdyhdw->nOdvoZdrPZ
          mzdyhdw->nOdvoZdrMO := nx - ( mzdyhdw->nOdvoZdrMZ + mzdyhdw->nOdvoZdrPZ + mzdyhdw->nOdvoZdrPO)

          mzdyhdw->nZakZdrMin := mzdyhdw->nZakZdrMin - mzdyhdw->nZaklZdrPo

          do case
          case msprc_moC ->nZdrPojDop == 1
            mzdyhdw->nOdvoZdrMO += mzdyhdw->nOdvoZdrMZ
            mzdyhdw->nOdvoZdrMZ := 0
            ( gen_parW->nMzda   := mzdyhdw->nOdvoZdrMO, ::genmzdyIT(718))

          case msprc_moC ->nZdrPojDop == 2
            mzdyhdw->nOdvoZdrMZ += mzdyhdw->nOdvoZdrMO
            mzdyhdw->nOdvoZdrMO := 0
            ( gen_parW->nMzda := mzdyhdw->nOdvoZdrMZ, ::genmzdyIT(518))

          case msprc_moC ->nZdrPojDop == 3 .OR. msprc_moC ->nZdrPojDop == 4
            ( gen_parW->nMzda := mzdyhdw->nOdvoZdrMZ, ::genmzdyIT(518))
            if msprc_moC ->nZdrPojDop == 4
              ( gen_parW->nMzda := mzdyhdw->nOdvoZdrMO, ::genmzdyIT(569))
              mzdyhdw->nCastKVypl -= mzdyhdw->nOdvoZdrMO
            endif
            ( gen_parW->nMzda := mzdyhdw->nOdvoZdrMO, ::genmzdyIT(718))
          endcase
          ( gen_parW->nMzda := mzdyhdw->nZakZdrMin, ::genmzdyIT(918))

        endif
      endif

      if( mzdyhdw->nDnyNV + mzdyhdw->nDnyABS) <> 0 .and. msprc_moC->nZdrPojNVA <> 0

        mzdyhdw->nZakZdrNVA := Mh_RoundNumb( ( mzdyhdw->nDnyNV + mzdyhdw->nDnyABS) * (minMzda / ::lastDay), 32)

        nx                  := Mh_RoundNumb( mzdyhdw->nZakZdrNVA * (procZam + procOrg)/100, 31)
        mzdyhdw->nOdvoZdrNZ := Mh_RoundNumb( nx /3, 31)
        mzdyhdw->nOdvoZdrNO := nx - mzdyhdw->nOdvoZdrNZ

        ( gen_parW->nMzda := mzdyhdw->nZakZdrNVA, ::genmzdyIT(919))
        ( gen_parW->nMzda := mzdyhdw->nOdvoZdrNZ, ::genmzdyIT(519))
        ( gen_parW->nMzda := mzdyhdw->nOdvoZdrNO, ::genmzdyIT(719))
      endif
      ( gen_parW->nMzda := mzdyhdw->nZaklZdrPo, ::genmzdyIT(905))
      ( gen_parW->nMzda := mzdyhdw->nOdvoZdrPZ, ::genmzdyIT(505))
      ( gen_parW->nMzda := mzdyhdw->nOdvoZdrPO, ::genmzdyIT(705))

//      mzdyhdw->nZaklZdrPo := mzdyhdw->nZaklZdrPo + mzdyhdw->nZakZdrMin + mzdyhdw->nZakZdrNVA

      if mzdyhdw->nZakZdrMin > mzdyhdw->nZaklZdrPo
        mzdyhdw->nZaklZdrPo := mzdyhdw->nZakZdrMin + mzdyhdw->nZakZdrNVA
      else
        mzdyhdw->nZaklZdrPo := mzdyhdw->nZaklZdrPo + mzdyhdw->nZakZdrNVA
      endif

      mzdyhdw->nOdvoZdrPZ := mzdyhdw->nOdvoZdrPZ + mzdyhdw->nOdvoZdrNZ + mzdyhdw->nOdvoZdrMZ
      mzdyhdw->nOdvoZdrPO := mzdyhdw->nOdvoZdrPO + mzdyhdw->nOdvoZdrNO + mzdyhdw->nOdvoZdrMO
      mzdyhdw->nOdvoZdrPC := mzdyhdw->nOdvoZdrPZ + mzdyhdw->nOdvoZdrPO
    else
      mzdyhdw->nZaklZdrPo := mzdyhdw->nZakZdrZaD := mzdyhdw->nZakZdrPrD := mzdyhdw->nZakZdrNVA := mzdyhdw->nZakZdrMin := 0
    endif

    return self

// vypoète daò ze mzdy zamìstnance
  inline method Vyp_DanMzd()
    local nDanZakl := nSocOrg := nZdrOrg := 0
    local zaklad   := 0
    local zalDan   := .f.
    local zakladDMZ

    *
    if msprc_moC->lDanPrVzt       // .and. ::ndanZaklSP <> 0
      zalDan := msprc_moC->ntypzamvzt = 2 .or.                 ;
                  msprc_moC->ntypzamvzt = 3 .or.               ;
                    msprc_moC->ntypzamvzt = 5

      mzdyhdw->( dbCommit())
      mzdyhdwA->( dbeval( { || nDanZakl += mzdyhdwA->ndanZaklMZ,  ;
                               nSocOrg  += mzdyhdwA->nOdvoSocPO,  ;
                               nZdrOrg  += mzdyhdwA->nOdvoZdrPO } ), dbgotop() )
      mzdyhdw->nDanZaklSP := nDanZakl
//        ::ndanZaklSP := ndanZaklSP
//      mzdyhdw->nDanZaklSP := ::ndanZaklSP
    endif

    if ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <> 0
      mzdyhdw->nSupHmMz := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD + nSocOrg + nZdrOrg  //+ mzdyhdw->nOdvoSocPO + mzdyhdw->nOdvoZdrPO
      do case
      case zalDan .and. .not. msprc_moC->ldanprohl .and.       ;
            Left( msprc_moC->cDruPraVzt,8) = 'NEPRACPO'
        mzdyhdw->nDanCelVyp := ::danZalVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nDanCelVyp, ::genmzdyIT(501))
        zakladDMZ := 901

      case .not. msprc_moC->ldanprohl .and. ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <= 5000
        mzdyhdw->nSrazkoDan := ::danPrcVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nSrazkoDan, ::genmzdyIT(511))
        zakladDMZ := 911

      otherwise
        mzdyhdw->nDanCelVyp := ::danZalVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nDanCelVyp, ::genmzdyIT(501))
        zakladDMZ := 901

        // výpoèet solidární danì od roku 2013
        zaklad := mzdyhdw->nDanZaklSP - 130796
        if zaklad > 0
          mzdyhdw->nDanSolVyp := ::danSolidVyp( zaklad)
          ( gen_parW->nMzda := mzdyhdw->nDanSolVyp, ::genmzdyIT(502))
        endif
      endcase
      ( gen_parW->nMzda := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD, ::genmzdyIT(zakladDMZ))
      if mzdyhdw->nSupHmMz > 0
        ( gen_parW->nMzda := mzdyhdw->nSupHmMz, ::genmzdyIT(944))
      endif
    else
      mzdyhdw->nSupHmMz := 0
    endif
    return self


// vypoète daò ze mzdy zamìstnance od roku 2014
  inline method Vyp_DanMzd_14()
    local nDanZakl := nSocOrg := nZdrOrg := 0
    local zaklad   := 0
    local zalDan   := .f.
    local zakladDMZ

    *
    if msprc_moC->lDanPrVzt       // .and. ::ndanZaklSP <> 0
      zalDan := msprc_moC->ntypzamvzt = 2 .or.                 ;
                  msprc_moC->ntypzamvzt = 3 .or.               ;
                    msprc_moC->ntypzamvzt = 5

      mzdyhdw->( dbCommit())

      if mzdyhdw->nrokobd > 201402
        mzdyhdwA->( dbeval( { || nDanZakl += mzdyhdwA->ndanZaklMZ,  ;
                                 nSocOrg  += mzdyhdwA->nOdvoSocPO,  ;
                                 nZdrOrg  += mzdyhdwA->nOdvoZdrPO,  ;
                                 nZdrOrg  -= mzdyhdwA->nOdvoZdrNO,  ;
                                 nZdrOrg  -= mzdyhdwA->nOdvoZdrMO } ), dbgotop() )
      else
        mzdyhdwA->( dbeval( { || nDanZakl += mzdyhdwA->ndanZaklMZ,  ;
                                 nSocOrg  += mzdyhdwA->nOdvoSocPO,  ;
                                 nZdrOrg  += mzdyhdwA->nOdvoZdrPO } ), dbgotop() )
      endif

      mzdyhdw->nDanZaklSP := nDanZakl
//        ::ndanZaklSP := ndanZaklSP
//      mzdyhdw->nDanZaklSP := ::ndanZaklSP
    endif

    if ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <> 0
      mzdyhdw->nSupHmMz := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD + nSocOrg + nZdrOrg  //+ mzdyhdw->nOdvoSocPO + mzdyhdw->nOdvoZdrPO
      do case
      case zalDan .and. .not. msprc_moC->ldanprohl .and.       ;
            Left( msprc_moC->cDruPraVzt,8) = 'NEPRACPO'
        mzdyhdw->nDanCelVyp := ::danZalVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nDanCelVyp, ::genmzdyIT(501))
        zakladDMZ := 901

      case .not. msprc_moC->ldanprohl .and. ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <= 10000     ;
            .and. At(msprc_moC->cTypPPVReg, 'TUVWXYZ') > 0
        mzdyhdw->nSrazkoDan := ::danPrcVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nSrazkoDan, ::genmzdyIT(511))
        zakladDMZ := 911

      otherwise
        mzdyhdw->nDanCelVyp := ::danZalVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nDanCelVyp, ::genmzdyIT(501))
        zakladDMZ := 901

        // výpoèet solidární danì od roku 2014
        zaklad := mzdyhdw->nDanZaklSP - 130796
        if zaklad > 0
          mzdyhdw->nDanSolVyp := ::danSolidVyp( zaklad)
          ( gen_parW->nMzda := mzdyhdw->nDanSolVyp, ::genmzdyIT(502))
        endif
      endcase
      ( gen_parW->nMzda := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD, ::genmzdyIT(zakladDMZ))
      if mzdyhdw->nSupHmMz > 0
        ( gen_parW->nMzda := mzdyhdw->nSupHmMz, ::genmzdyIT(944))
      endif
    else
      mzdyhdw->nSupHmMz := 0
    endif
    return self


// vypoète daò ze mzdy zamìstnance od roku 2018
  inline method Vyp_DanMzd_18()
    local nDanZakl := nSocOrg := nZdrOrg := 0
    local zaklad   := 0
    local zalDan   := .f.
    local zakladDMZ
    local ndanDokl

    ndanDokl := mzdyhdw->nZalohoDan
    *
    if msprc_moC->lDanPrVzt       // .and. ::ndanZaklSP <> 0
      zalDan := msprc_moC->ntypzamvzt = 2 .or.                 ;
                  msprc_moC->ntypzamvzt = 3 .or.               ;
                    msprc_moC->ntypzamvzt = 5

      mzdyhdw->( dbCommit())

      if mzdyhdw->nrokobd > 201402
        mzdyhdwA->( dbeval( { || nDanZakl += mzdyhdwA->ndanZaklMZ,  ;
                                 nSocOrg  += mzdyhdwA->nOdvoSocPO,  ;
                                 nZdrOrg  += mzdyhdwA->nOdvoZdrPO,  ;
                                 nZdrOrg  -= mzdyhdwA->nOdvoZdrNO,  ;
                                 nZdrOrg  -= mzdyhdwA->nOdvoZdrMO } ), dbgotop() )
      else
        mzdyhdwA->( dbeval( { || nDanZakl += mzdyhdwA->ndanZaklMZ,  ;
                                 nSocOrg  += mzdyhdwA->nOdvoSocPO,  ;
                                 nZdrOrg  += mzdyhdwA->nOdvoZdrPO } ), dbgotop() )
      endif

      mzdyhdw->nDanZaklSP := nDanZakl
//        ::ndanZaklSP := ndanZaklSP
//      mzdyhdw->nDanZaklSP := ::ndanZaklSP
    endif

    if ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <> 0
      mzdyhdw->nSupHmMz := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD + nSocOrg + nZdrOrg  //+ mzdyhdw->nOdvoSocPO + mzdyhdw->nOdvoZdrPO
      do case
      case zalDan .and. .not. msprc_moC->ldanprohl .and.       ;
            Left( msprc_moC->cDruPraVzt,8) = 'NEPRACPO'
        mzdyhdw->nZalohoDan := ::danZalVyp( mzdyhdw->nSupHmMz )
        mzdyhdw->nDanCelVyp := mzdyhdw->nZalohoDan
        ( gen_parW->nMzda   := mzdyhdw->nZalohoDan, ::genmzdyIT(501))
        zakladDMZ := 901

      case .not. msprc_moC->ldanprohl .and. ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <= 10000     ;
            .and. At(msprc_moC->cTypPPVReg, 'TUVWXYZ') > 0
        mzdyhdw->nSrazkoDan := ::danPrcVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nSrazkoDan, ::genmzdyIT(511))
        zakladDMZ := 911

      otherwise
        mzdyhdw->nZalohoDan := ::danZalVyp( mzdyhdw->nSupHmMz )
        mzdyhdw->nDanCelVyp := mzdyhdw->nZalohoDan
        ( gen_parW->nMzda   := mzdyhdw->nZalohoDan, ::genmzdyIT(501))
        zakladDMZ := 901

        // výpoèet solidární danì od roku 2014
        zaklad := mzdyhdw->nDanZaklSP - 139340
        if zaklad > 0
          mzdyhdw->nDanSolVyp := ::danSolidVyp( zaklad)
          ( gen_parW->nMzda := mzdyhdw->nDanSolVyp, ::genmzdyIT(502))
        endif
      endcase
      ( gen_parW->nMzda := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD, ::genmzdyIT(zakladDMZ))
      if mzdyhdw->nSupHmMz > 0
        ( gen_parW->nMzda := mzdyhdw->nSupHmMz, ::genmzdyIT(944))
      endif
    else
      mzdyhdw->nSupHmMz := 0
    endif

    if ndanDokl > 0
      mzdyhdw->nZalohoDan += ndanDokl
    endif
    return self


// vypoète daò ze mzdy zamìstnance od roku 2021
  inline method Vyp_DanMzd_21()
    local nDanZakl := nSocOrg := nZdrOrg := 0
    local zaklad   := 0
    local zalDan   := .f.
    local zakladDMZ
    local ndanDokl

    ndanDokl := mzdyhdw->nZalohoDan
    *
    if msprc_moC->lDanPrVzt       // .and. ::ndanZaklSP <> 0
      zalDan := msprc_moC->ntypzamvzt = 2 .or.                 ;
                  msprc_moC->ntypzamvzt = 3 .or.               ;
                    msprc_moC->ntypzamvzt = 5

      mzdyhdw->( dbCommit())

      if mzdyhdw->nrokobd > 201402
        mzdyhdwA->( dbeval( { || nDanZakl += mzdyhdwA->ndanZaklMZ,  ;
                                 nSocOrg  += mzdyhdwA->nOdvoSocPO,  ;
                                 nZdrOrg  += mzdyhdwA->nOdvoZdrPO,  ;
                                 nZdrOrg  -= mzdyhdwA->nOdvoZdrNO,  ;
                                 nZdrOrg  -= mzdyhdwA->nOdvoZdrMO } ), dbgotop() )
      else
        mzdyhdwA->( dbeval( { || nDanZakl += mzdyhdwA->ndanZaklMZ,  ;
                                 nSocOrg  += mzdyhdwA->nOdvoSocPO,  ;
                                 nZdrOrg  += mzdyhdwA->nOdvoZdrPO } ), dbgotop() )
      endif

      mzdyhdw->nDanZaklSP := nDanZakl
//        ::ndanZaklSP := ndanZaklSP
//      mzdyhdw->nDanZaklSP := ::ndanZaklSP
    endif

    if ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <> 0
      mzdyhdw->nSupHmMz := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD   //+ mzdyhdw->nOdvoSocPO + mzdyhdw->nOdvoZdrPO
      do case
      case zalDan .and. .not. msprc_moC->ldanprohl .and.       ;
            Left( msprc_moC->cDruPraVzt,8) = 'NEPRACPO'
        mzdyhdw->nZalohoDan := ::danZalVyp( mzdyhdw->nSupHmMz )
        mzdyhdw->nDanCelVyp := mzdyhdw->nZalohoDan
        ( gen_parW->nMzda   := mzdyhdw->nZalohoDan, ::genmzdyIT(501))
        zakladDMZ := 901

      case .not. msprc_moC->ldanprohl .and. ( mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD) <= 10000     ;
            .and. At(msprc_moC->cTypPPVReg, 'TUVWXYZ') > 0
        mzdyhdw->nSrazkoDan := ::danPrcVyp( mzdyhdw->nSupHmMz )
        ( gen_parW->nMzda := mzdyhdw->nSrazkoDan, ::genmzdyIT(511))
        zakladDMZ := 911

      otherwise
        mzdyhdw->nZalohoDan := ::danZalVyp( mzdyhdw->nSupHmMz )
        mzdyhdw->nDanCelVyp := mzdyhdw->nZalohoDan
        ( gen_parW->nMzda   := mzdyhdw->nZalohoDan, ::genmzdyIT(501))
        zakladDMZ := 901

      endcase
      ( gen_parW->nMzda := mzdyhdw->nDanZaklSP + mzdyhdw->nDanZaklPD, ::genmzdyIT(zakladDMZ))
      mzdyhdw->nSupHmMz := 0
//      if mzdyhdw->nSupHmMz > 0
//        ( gen_parW->nMzda := mzdyhdw->nSupHmMz, ::genmzdyIT(944))
//      endif
    else
      mzdyhdw->nSupHmMz := 0
    endif

    if ndanDokl > 0
      mzdyhdw->nZalohoDan += ndanDokl
    endif
    return self


// vypoète slevy a odpoèty na daòi ze mzdy u zamìstnance
  inline method Vyp_SlevOdpDan()
    local  cf := "nrok = %% .and. noscisprac = %% .and. nporpravzt = %%"
    local  nTmpUl, nTMPminMzd, lDanBoOK

    *
     nTMPminMzd := MH_RoundNumb( SysConfig( "Mzdy:nMinMzdaDB", ::firstDay) / 2, 33)
     lDanBoOK   := IF(  mzdyhdw->nNapMinMzd >= nTMPminMzd, .T., .F.)

     cfiltr := Format( cf, { mzdyhdw->nrok, mzdyhdw->noscisprac, mzdyhdw->nporpravzt })
     msodppol->( ads_setaof(cfiltr), dbGoTop())

     do while !msodppol ->( Eof())
       if msodppol ->lDanUleva
         if !Empty( msprc_moC ->dDatVyst) .and. msprc_moC ->dDatVyst <= Mh_LastODate( ::rok, ::obdobi)
           if Empty( msodppol ->dPlatnDO) .or. msodppol ->dPlatnDO >= msprc_moC ->dDatVyst
             if msodppol ->( dbRlock())
               msodppol ->dPlatnDO := msprc_moC ->dDatVyst
               msodppol ->cObdDO   := Mh_OBD_MM_YY( msprc_moC ->dDatVyst)

               if Year( msodppol ->dPlatnDo)*100 +Month( msodppol ->dPlatnDo) >= ( ::rok*100 +::obdobi)      ;
                   .or. Empty( msodppol ->dPlatnDo)
                  msodppol ->lAktiv := .T.
               else
                  msodppol ->lAktiv := .F.
               endif
             endif
           endif
         endif

         if ( Year( msodppol ->dPlatnOd)*100 +Month( msodppol ->dPlatnOd)) <= ( ::rok*100 +::obdobi)            ;
                     .and. ( ( Year( msodppol ->dPlatnDo)*100 +Month( msodppol ->dPlatnDo)) >= ( ::rok*100 +::obdobi)   ;
                                     .or. Empty( msodppol ->dPlatnDo))
            c_odpoc->( dbSeek( msodppol->cTypOdpPol,,'C_ODPOC02'))
           ( gen_parW->nMzda := msodppol ->nDanUlOBD, ::genmzdyIT(C_Odpoc ->nDruhMzdy))

           if msprc_moC ->nDanUlOBD <> 0
             if Left(msodppol->cTypOdpPol,3) <> "DIT"
               if (mzdyhdw->nSlevaDanU +msodppol ->nDanUlOBD) < mzdyhdw->nDanCelVyp
               *                 GenSlevDan( aDanUleva[n,4], aDanUleva[n,5], aDanUleva[n,3])
                ( gen_parW->nMzda := msodppol ->nDanUlOBD*-1, ::genmzdyIT(C_Odpoc ->nDruhMzdy2))
                ( gen_parW->nMzda := msodppol ->nDanUlOBD,    ::genmzdyIT(C_Odpoc ->nDruhMzdy3))
                 mzdyhdw->nSlevaDanU += msodppol ->nDanUlOBD
               else
                 nTmpUl := msodppol ->nDanUlOBD - ( (mzdyhdw->nSlevaDanU +msodppol ->nDanUlOBD) -mzdyhdw->nDanCelVyp)
                 if nTmpUl > 0
                   ( gen_parW->nMzda := nTmpUl*-1, ::genmzdyIT(C_Odpoc ->nDruhMzdy2))
                   ( gen_parW->nMzda := nTmpUl,    ::genmzdyIT(C_Odpoc ->nDruhMzdy3))
                   mzdyhdw->nSlevaDanU += nTmpUl
                 endif
               endif
             else
               mzdyhdw->nDanUlevaC += msodppol ->nDanUlOBD
             endif
           endif
         endif
       endif
       msodppol ->( dbSkip())
     enddo

     msOdppol->( ads_clearAof())
       gen_parW->( dbcommit())
       mzdyhdw ->( dbcommit())

     if mzdyhdw->nDanUlevaC > 0
       if mzdyhdw->nDanCelVyp >= msprc_moC ->nDanUlOBD
         nTmpUl := msprc_moC ->nDanUlOBD -mzdyhdw->nSlevaDanU
       else
         nTmpUl := mzdyhdw->nDanCelVyp - mzdyhdw->nSlevaDanU
         nTmpUl := if( mzdyhdw->nDanUlevaC >= nTmpUl, nTmpUl, 0)
       endif

       if nTmpUl > 0
         ( gen_parW->nMzda := nTmpUl*-1, ::genmzdyIT(530))
         ( gen_parW->nMzda := nTmpUl,    ::genmzdyIT(960))
       endif

       if mzdyhdw->nDanCelVyp < msprc_moC ->nDanUlOBD
         mzdyhdw->nDanBonusC := mzdyhdw->nDanUlevaC - nTmpUl
         mzdyhdw->nDanBonusC := if( mzdyhdw->nDanBonusC >= 50, mzdyhdw->nDanBonusC, 0)
       endif

       if lDanBoOK .and. mzdyhdw->nDanBonusC > 0
         mzdyhdw->nDanBonusC := if( mzdyhdw->nDanBonusC > 5025, 5025, mzdyhdw->nDanBonusC)
         ( gen_parW->nMzda := mzdyhdw->nDanBonusC*-1, ::genmzdyIT(531))
         ( gen_parW->nMzda := mzdyhdw->nDanBonusC,    ::genmzdyIT(961))
       else
         mzdyhdw->nDanBonusC := 0
       endif

*       mzdyhdw->nDanUlevaC := ( mzdyhdw->nDanUlevaC +nTmpUl) * (-1)
       mzdyhdw->nDanUlevaC := nTmpUl     // * (-1)
       mzdyhdw->nDanBonusC := mzdyhdw->nDanBonusC     // * (-1)
     endif
    return self


// vypoète mzdu zamìstnance ( úprava danì,èistá mzda,....)
  inline method Vyp_CisMzd()
    *
    * úprava danì
    if (mzdyhdw->nDanCelVyp +mzdyhdw->nDanSolVyp +mzdyhdw->nSlevaDanU +mzdyhdw->nDanUlevaC) <> 0
      do case
      case (Abs( mzdyhdw->nSlevaDanU) +Abs( mzdyhdw->nDanUlevaC)) = 0
        mzdyhdw->nZalohoDan := mzdyhdw->nDanCelVyp + mzdyhdw->nDanSolVyp

      case (Abs( mzdyhdw->nSlevaDanU) +Abs( mzdyhdw->nDanUlevaC)) >= (mzdyhdw->nDanCelVyp + mzdyhdw->nDanSolVyp)
        mzdyhdw->nZalohoDan := 0

      case (Abs( mzdyhdw->nSlevaDanU) +Abs( mzdyhdw->nDanUlevaC)) < mzdyhdw->nDanCelVyp
        mzdyhdw->nZalohoDan := (mzdyhdw->nDanCelVyp + mzdyhdw->nDanSolVyp) -Abs( mzdyhdw->nSlevaDanU) -Abs( mzdyhdw->nDanUlevaC)

      endcase
    endif

    if mzdyhdw->nDanBonusC > 0
      mzdyhdw->nZalohoDan := mzdyhdw->nDanBonusC * (-1)
    endif

    mzdyhdw->nDanCelkem := mzdyhdw->nZalohoDan +mzdyhdw->nSrazkoDan

    mzdyhdw->nZaklOdbor := mzdyhdw->nZaklOdbor -                             ;
                            ( mzdyhdw->nOdvoSocPZ + mzdyhdw->nOdvoZdrPZ +    ;
                                mzdyhdw->nDanCelkem +mzdyhdw->nDanBonusC)


    mzdyhdw->nCistPriDB := mzdyhdw->nCistPrije -                             ;
                            ( mzdyhdw->nOdvoSocPZ +                          ;
                               mzdyhdw->nOdvoZdrPZ +                         ;
                                mzdyhdw->nDanCelkem )
    ( gen_parW->nMzda := mzdyhdw->nCistPriDB, ::genmzdyIT(945))

    mzdyhdw->nCistPrije := mzdyhdw->nCistPrije -                             ;
                            ( mzdyhdw->nOdvoSocPZ +                          ;
                               mzdyhdw->nOdvoZdrPZ +                         ;
                                mzdyhdw->nDanCelkem +mzdyhdw->nDanBonusC)
    ( gen_parW->nMzda := mzdyhdw->nCistPrije, ::genmzdyIT(940))


    mzdyhdw->nCastKVypl := mzdyhdw->nCastKVypl -                             ;
                            ( mzdyhdw->nOdvoSocPZ +                          ;
                                mzdyhdw->nOdvoZdrPZ +                        ;
                                 mzdyhdw->nDanCelkem)


//  kumulovaná mzda od poèátku roku
    return self


// vygeneruje srážky ze mzdy zamìstnance
  inline method Gen_SrzMzd( kVypl )
    local  cf := "nrokobd = %% .and. noscisprac = %% .and. nporpravzt = %%"
    local  srazka, keyM, nx
    local  splacenoM, nedoplatekM
    local  modiVypl, genSrz
    local  genVypl := .f.
    *
    default kVypl to .t.

     mssrz_moC->(ordsetfocus('MSSRZ_04'))

     cfiltr := Format( cf, { mzdyhdw->nrokobd, mzdyhdw->noscisprac, mzdyhdw->nporpravzt })
     mssrz_moC->( ads_setaof(cfiltr), dbGoTop())

//     mssrz_moC->( dbEval( {||Mh_CopyFld('mssrz_moC','mssrz_mow',.t.,.t.), ;
//                             mssrz_mow->nmssrz_mo := mssrz_moC->sid }))

     do while .not. mssrz_moC->( Eof())
       Mh_CopyFld('mssrz_moC','mssrz_mow',.t.,.t.)
       mssrz_mow->nmssrz_mo := isNull( mssrz_moC->sid, 0)
       mssrz_moC->( dbSkip())
     enddo

     mssrz_mow->( dbGoTop())

     if kVypl
       do while .not. mssrz_mow->( Eof())
         if ::OKsrz()
           modiVypl := genSrz := .t.

           do case
           case mssrz_mow->ntypsrz = 1
             splacenoM := nedoplatekM := 0
             keyM := StrZero( if( ::obdobi == 1, ::rok - 1, ::rok), 4)                          ;
                        +StrZero( if( ::obdobi == 1, 12, ::obdobi - 1), 2)                      ;
                          +StrZero( mssrz_mow->nOsCisPrac, 5) +StrZero( mssrz_mow->nPorPraVzt, 3)
                           +StrZero( mssrz_mow->nporuplsrz, 2)

             if mssrz_moM->( dbSeek(keyM,,'MSSRZ_04'))
               splacenoM   := mssrz_moM->nsplaceno
               nedoplatekM := mssrz_moM->nnedoplat
             endif

             srazka  := 0
             modiVypl := if( mssrz_mow->cTypSrz == "SRPP", .f., .t.)

             do case
             case mssrz_mow->nTypCastka = 2        // procentuelní srážka
               do case
               case mssrz_mow->cTypSrz == "SROD"
                 srazka := Mh_Roundnumb( ( mzdyhdw->nZaklOdbor * mssrz_mow->nSplatka) / 100, 32)

               case mssrz_mow->cTypSrz == "SRPP"
                 if mssrz_mow->nCelkem == 0
                   nx := mzdyhdw->nZaklSocPo
                 else
                   nx := IF( mzdyhdw->nZaklSocPo > mssrz_mow->nCelkem          ;
                                 , mssrz_mow->nCelkem, mzdyhdw->nZaklSocPo)
                 endif
                 srazka := Mh_Roundnumb( (  nx * mssrz_mow->nSplatka) / 100 , 33)
               endcase

             otherwise                             // srážka hodnotou
               srazka := mssrz_mow->nSplatka
             endcase

             do case
             case mssrz_mow->cTypSrz == "SRUV"  // pokud je zùstatek úvìru menší než splátka
               if (( mssrz_mow->nCelkem +splacenoM) -( srazka +nedoplatekM)) < 0
                  srazka := mssrz_mow->nCelkem -splacenoM
               else
                 srazka += nedoplatekM          // pøiètu nedoplatek z min.mìsíce
               endif
               mssrz_mow->nSplaceno  := splacenoM +srazka
               mssrz_mow->nZustatek  := mssrz_mow->nCelkem - mssrz_mow->nSplaceno
               mssrz_mow->dDatZustat := Date()
             endcase

             if modiVypl
               if mzdyhdw->nCastKVypl >= srazka
                 mzdyhdw->nCastKVypl  -= srazka
                 mssrz_mow->nNedoplat := 0
               else
                 if mzdyhdw->nCastKVypl  > 0.51
                   mssrz_mow->nNedoplat += srazka -mzdyhdw->nCastKVypl
                   srazka               := Int( mzdyhdw->nCastKVypl)
                   mzdyhdw->nCastKVypl  -= srazka
                 else
                   mssrz_mow->nNedoplat += srazka
                   genSrz               := .f.
                 endif
               endif
             endif

             if genSrz .and. srazka > 0
               ( gen_parW->nMzda :=  srazka, ::genmzdyIT(mssrz_mow->nDruhMzdy, 'SRZ'))

               if mssrz_mow->cTypSrz == "SRPP"
                 ( gen_parW->nMzda :=  srazka, ::genmzdyIT(mssrz_mow->nDruhMzdy2, 'SRZDM2'))
               endif
             endif

           case mssrz_moW->ntypsrz = 2
             if mzdyhdw->nCastKVypl <> 0
               ::ZaokrMzdy()
               ( gen_parW->nMzda    := mzdyhdw->nCastKVypl, ::genmzdyIT(mssrz_mow->nDruhMzdy, 'SRZ'))
               ( mzdyhdw->nMzdaUcet := mzdyhdw->nCastKVypl)
               ( gen_parW->nMzda    := mzdyhdw->nCastKVypl := 0)
               genVypl := .t.
             endif
           endcase
         endif
         mssrz_mow->( dbSkip())
       enddo

       ::ZaokrMzdy()
       ( gen_parW->nMzda     := mzdyhdw->nCastKVypl, ::genmzdyIT(950))
       ( mzdyhdw->nMzdaHotov := mzdyhdw->nCastKVypl)
     else
       do while .not. mssrz_mow->( Eof())
         if ::OKsrz()
           srazka := mssrz_mow->nSplatka
           if mssrz_mow->cTypSrz == "SRPP" .and. srazka > 0 .and. mssrz_mow->nTypCastka = 1    ;
               .and. mssrz_mow->nDruhMzdy <> 0 .and. mssrz_mow->nDruhMzdy2 <> 0
             ( gen_parW->nMzda :=  srazka, ::genmzdyIT(mssrz_mow->nDruhMzdy, 'SRZ'))
             ( gen_parW->nMzda :=  srazka, ::genmzdyIT(mssrz_mow->nDruhMzdy2, 'SRZDM2'))
           endif
         endif
         mssrz_mow->( dbSkip())
       enddo
     endif

     mssrz_moC->( ads_clearaof())
     mssrz_moW->( dbZap())

    return self


// uloží soubory mzdyhdw, mzdyitw a mssrz_mow
  inline method Save_Mzdy__()
    local  anMzdh := {}, mainOk := .f., nrecOr
    local  anMssr := {}
    local  cky
    *
    local  uctLikv
    * zaèátek transakce

    mzdyhdw  ->( dbeval( { || if( mzdyhdw  ->_nrecor <> 0, aadd( anMzdh, mzdyhdw  ->_nrecor), nil ) } ))
    mssrz_mow->( dbeval( { || if( mssrz_mow->_nrecor <> 0, aadd( anMssr, mssrz_mow->_nrecor), nil ) } ))

    mainOk := if( len( anMzdh ) <> 0, mzdyhdA->( sx_Rlock( anMzdh)), .t. )
    mainOk := mainOk .and. if( len( anMssr ) <> 0, mssrz_mo->( sx_Rlock( anMssr)), .t. )

    if mainOk
      oSession_data:beginTransaction()


      mzdyhdw  ->( dbgotop())
      mzdyitw  ->( dbgotop())
      mssrz_mow->( dbgotop())

      BEGIN SEQUENCE

*        ::zustDovol()
*        EvidPocPrac('msprc_moC', ::nrok,::nobdobi)

        if SysConfig( 'mzdy:nTypUctMzd') > 0
          uctLikv  := UCT_likvidace():new(upper(mzdyhdw->culoha) +upper(mzdyhdw->ctypdoklad),.T.)
        endif

        do while .not. mzdyhdw->( eof())
          cky := strZero(mzdyhdw->nrok,4) +strZero(mzdyhdw->nobdobi,2) + ;
                  strZero(mzdyhdw->noscisPrac,5) +strZero(mzdyhdw->nporPraVzt,3)
          msprc_moC ->( dbseek( cky,,'MSPRMO01'))
          msprc_moC->( dbRlock())

          ::zustDovol()
          ::zustDovolHod()

          if((nrecor := mzdyhdw->_nrecor) = 0, nil, mzdyhdA->(dbgoto(nrecor)))

          mh_copyfld('mzdyhdw','mzdyhdA',(nrecor=0),,.f.)

          msprc_moC->nstavypocm := ::staVypoCM
          msprc_moC->lmzdavroce := .t.
          mzdyhdw->( dbskip())
        enddo

        do while .not. mzdyitw->( eof())
          mh_copyFld( 'mzdyitw', 'mzdyit', .t. )
//          mzdyit->nmzdyhd := mzdyhdA->sid
          mzdyitw->( dbskip())
        enddo

        do while .not. mssrz_mow->( eof())
          if((nrecor := mssrz_mow->_nrecor) = 0, nil, mssrz_mo->(dbgoto(nrecor)))

           mh_copyfld('mssrz_mow','mssrz_mo',(nrecor=0),,.f.)
           mssrz_mow->( dbskip())
        enddo

        if SysConfig( 'mzdy:nTypUctMZD') <> 0
          uctLikv:ucetpol_wrt()
        endif

        oSession_data:commitTransaction()

      RECOVER USING oError
        oSession_data:rollbackTransaction()

      END SEQUENCE

    else

      drgMsg(drgNLS:msg('Nelze modifikovat MZDOVÝ soubor, blokováno uživatelem ...'),,::drgDialog)
    endif

    mzdyhd->(dbunlock(), dbcommit())
     mzdyhdA->(dbunlock(), dbcommit())
      mzdyhdC->(dbunlock(), dbcommit())
       mzdyit->(dbunlock(), dbcommit())
        mssrz_mow->(dbunlock(), dbcommit())
         msprc_moc->(dbunlock(), dbcommit())
  return mainOk


  inline method GenMzdyIT( druhMzdy, typ)
    local  b_mblock
    local  table
    local  key

    default typ to ''

     table := if( At(typ,'SRZ')> 0, 'mssrz_mow', 'mzdyhdw')

     key   := StrZero( (table)->nrok,4) +StrZero( (table)->nobdobi,2) +StrZero(druhmzdy,4)
     druhymzda ->( dbSeek( key,,'DRUHYMZD04' ))

     Mh_CopyFld( table, 'mzdyitw', .t.)

     mzdyitw->ctypdoklad  := 'MZD_GENCM'
     mzdyitw->ctyppohybu  := 'GENMZDA'
     mzdyitw->cdenik      := 'MC'
     mzdyitw->ddatporiz   := date()
     mzdyitw->ndruhmzdy   := druhmzdy
     mzdyitw->cucetskup   := AllTrim( Str(druhmzdy))
     mzdyitw->nDnyDoklad  := gen_parW->nDnyDoklad
     mzdyitw->nHodDoklad  := gen_parW->nHodDoklad
     mzdyitw->nMnPDoklad  := gen_parW->nMnPDoklad
     mzdyitw->nSazbaDokl  := gen_parW->nSazbaDokl
     mzdyitw->nMzda       := gen_parW->nMzda

     mzdyitw->nZaklSocPo  := gen_parW->nZaklSocPo
     mzdyitw->nZaklZdrPo  := gen_parW->nZaklZdrPo

     mzdyitw->cTypPohZAV  := druhymzda->cTypPohZAV
     mzdyitw->ccpppv      := msprc_moc->ccpppv
     mzdyitw->cPolVyplPa  := druhymzda->cPolVyplPa
     mzdyitw->cVyplMist   := msprc_moc->cVyplMist
     mzdyitw->nclenspol   := msprc_moc->nclenspol
     mzdyitw->nmsprc_mo   := isNull( msprc_moc->sid, 0)


     if typ = 'SRZ' .or. typ = 'SRZDM2'
       mzdyitw->ndoklad    := mzdyhdw ->ndoklad
       mzdyitw->ntyppravzt := mzdyhdw ->ntyppravzt
       mzdyitw->ntypzamvzt := mzdyhdw ->ntypzamvzt
*       mzdyitw->nclenspol  := mzdyhdw ->nclenspol
       mzdyitw->cmzdkatpra := mzdyhdw ->cmzdkatpra
       mzdyitw->cpraczar   := mzdyhdw ->cpraczar


       if typ <> 'SRZDM2'
          mzdyitw->cTypPohZAV := mssrz_mow->cTypPohZAV
       endif
       mzdyitw->ntypzamvzt := msprc_moc->ntypzamvzt
       mzdyitw->crocpppv   := msprc_moc->crocpppv
       mzdyitw->nmssrz_mo  := mssrz_mow->nmssrz_mo
     endif

     gen_parW->nDruhMzdy  := gen_parW->nDnyDoklad  := gen_parW->nHodDoklad :=  ;
     gen_parW->nMnPDoklad := gen_parW-> nSazbaDokl := gen_parW->nMzda :=       ;
     gen_parW->nZaklSocPo := gen_parW->nZaklZdrPo  := 0


    return self

ENDCLASS


method danZalVyp( zaklad)
  local dan, procDan
  local dan1, dan2

  do case
  case ::rok = 2012   ;    procDan := 15
  case ::rok = 2013   ;    procDan := 15
  case ::rok = 2014   ;    procDan := 15
  case ::rok = 2015   ;    procDan := 15
  case ::rok = 2016   ;    procDan := 15
  case ::rok = 2017   ;    procDan := 15
  case ::rok = 2018   ;    procDan := 15
  case ::rok = 2019   ;    procDan := 15
  case ::rok = 2020   ;    procDan := 15
  case ::rok = 2021   ;    procDan := 15
  endcase

  if zaklad > 0
    if zaklad <= 100
      zaklad := Mh_roundnumb( zaklad, 31)
    else
      zaklad := Mh_roundnumb( zaklad/100, 31) * 100
    endif

    mzdyhdw->nSupHmMzZa := zaklad
    mzdyhdw->nDanZaklSP := zaklad

  endif

  do case
  case ::rok = 2012   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2013   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2014   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2015   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2016   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2017   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2018   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2019   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2020   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2021
    dan1 := 0
    dan2 := 0
    if mzdyhdw->nDanZaklSP > 141764
      dan1 := 141764 * 0.015
      dan2 := (mzdyhdw->nDanZaklSP - 141764) * 0.23
    else
      dan1 := mzdyhdw->nDanZaklSP * 0.15
    endif

    dan := Mh_roundnumb( (dan1 + dan2), 31)
  endcase


return dan



method danPrcVyp( zaklad)
  local dan, procDan

  do case
  case ::rok = 2012   ;    procDan := 15
  case ::rok = 2013   ;    procDan := 15
  case ::rok = 2014   ;    procDan := 15
  case ::rok = 2015   ;    procDan := 15
  case ::rok = 2016   ;    procDan := 15
  case ::rok = 2017   ;    procDan := 15
  case ::rok = 2018   ;    procDan := 15
  case ::rok = 2019   ;    procDan := 15
  case ::rok = 2020   ;    procDan := 15
  case ::rok = 2021   ;    procDan := 15
  endcase

  if zaklad > 0
    zaklad := Mh_roundnumb( zaklad, 33)
  endif

  do case
  case ::rok = 2013   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2014   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2015   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2016   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2017   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2018   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2019   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2020   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  case ::rok = 2021   ;  dan := Mh_roundnumb( zaklad * procDan/100, 33)
  endcase

return dan


method danSolidVyp( zaklad)
  local dan, procDan

  do case
  case ::rok = 2013   ;    procDan := 7
  case ::rok = 2014   ;    procDan := 7
  case ::rok = 2015   ;    procDan := 7
  case ::rok = 2016   ;    procDan := 7
  case ::rok = 2017   ;    procDan := 7
  case ::rok = 2018   ;    procDan := 7
  case ::rok = 2019   ;    procDan := 7
  case ::rok = 2020   ;    procDan := 7
  case ::rok = 2021   ;    procDan := 23
  endcase

*  if zaklad > 0
*    zaklad := Mh_roundnumb( zaklad, 33)
*  endif

  do case
  case ::rok = 2013   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2014   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2015   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2016   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2017   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2018   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2019   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2020   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  case ::rok = 2021   ;  dan := Mh_roundnumb( zaklad * procDan/100, 31)
  endcase

return dan



method OKsrz()
  local ok := .f.

  if mssrz_moW->lAktivSrz
    ok := if( !Empty( mssrz_moW->dDatOdSpl) ;
               , mssrz_moW->dDatOdSpl <= Mh_LastODate( ::rok, ::obdobi), .t.)
    ok := ok .and. if( !Empty( mssrz_moW->dDatDoSpl) ;
                        , mssrz_moW->dDatDoSpl >= mh_FirstODate( ::rok, ::obdobi), .t.)

    do case
    case mssrz_moW->cTypSrz   == "SROD"   .and. ok  ;  ok := msprc_moC->lOdborar
    case mssrz_moW->cZpusSraz == "OBDOBI" .and. ok  ;  ok := .t.
    endcase
  endif

return ok



// vypoète a vygeneruje zaokrouhlení mzdy zamìstnance
method ZaokrMzdy()
  local  keyM
    *
  if  mzdyhdw->nCastKVypl > 0

    keyM := StrZero( if( ::obdobi == 1, ::rok - 1, ::rok), 4)                       ;
             +StrZero( if( ::obdobi == 1, 12, ::obdobi - 1), 2)                     ;
              +StrZero( mzdyhdw->nOsCisPrac, 5) +StrZero( mzdyhdw->nPorPraVzt, 3)


    do case
    case msprc_moM->( dbSeek(keyM,,'MSPRMO17'))
// zaokrouhlení na 10 Kè
      if msprc_moM->nZaokrNa10 > 0 .or. msprc_moC->lZaokrNa10
        mzdyhdw->nCastKVypl += msprc_moM->nZaokrNa10

        if Empty( msprc_moC->dDatVyst) .and. msprc_moC->lZaokrNa10
          if msprc_moM->nZaokrNa10 > 0
            ( gen_parW->nMzda  := msprc_moM->nZaokrNa10 * -1, ::genmzdyIT(596))
          endif

          if mzdyhdw->nCastKVypl > 0
            if msprc_moC->( dbRlock())
              msprc_moC->nZaokrNa10 := mzdyhdw->nCastKVypl - mh_RoundNumb( mzdyhdw->nCastKVypl,43)
              msprc_moC->( dbUnLock())
            endif
            ( gen_parW->nMzda   := msprc_moC->nZaokrNa10, ::genmzdyIT(595))
            mzdyhdw->nCastKVypl -= msprc_moC->nZaokrNa10
          endif
        endif
      else
        if Month( msprc_moC->dDatVyst) <= ::obdobi .or. .not. msprc_moC->lZaokrNa10
          if .not. Empty( msprc_moM ->nZaokrNa10)
             ( gen_parW->nMzda  := msprc_moM->nZaokrNa10 * -1, ::genmzdyIT(596))
             if msprc_moC->( dbRlock())
               msprc_moC->nZaokrNa10 := 0
               msprc_moC->( dbUnLock())
             endif
          endif
        endif
      endif

    case Month( msprc_moC->dDatNast) = ::obdobi
      if msprc_moC->lZaokrNa10
        if mzdyhdw->nCastKVypl > 0
          if msprc_moC->( dbRlock())
            msprc_moC->nZaokrNa10 := mzdyhdw->nCastKVypl - mh_RoundNumb( mzdyhdw->nCastKVypl,43)
            msprc_moC->( dbUnLock())
          endif
          ( gen_parW->nMzda   := msprc_moC->nZaokrNa10, ::genmzdyIT(595))
          mzdyhdw->nCastKVypl -= msprc_moC->nZaokrNa10
        endif
      endif

    endcase
  endif

return self



// aktualizuje zùstatky dovolené zamìstnance
method zustDovol()
  local  cf := "nrok = %% .and. nobdobi <= %% .and. noscisprac = %% .and. nporpravzt = %%"
  local  dovBez := 0, dovMin := 0
  local  cerBez := 0, cerMin := 0
  local  cky
      *
  if mzdyhdw->nobdobi > 1
    cfiltr := Format( cf, { mzdyhdw->nrok, mzdyhdw->nobdobi-1, mzdyhdw->noscisprac, mzdyhdw->nporpravzt })
    mzdyhdC->( ads_setaof(cfiltr), dbGoTop())
    mzdyhdC->( dbeval( { || (dovBez += mzdyhdC->nDnyDovBPD, dovMin += mzdyhdC->nDnyDovMPD)} ))
  endif

  msprc_moC->nDovMinCeO := 0
  msprc_moC->nDovMinCer := 0
  msprc_moC->nDovMinZus := msprc_moC->nDovMinNar

  msprc_moC->nDovBezCeO := 0
  msprc_moC->nDovBezCer := 0
  msprc_moC->nDovBezZus := msprc_moC->nDovBezNar

  if ( dovMin + mzdyhdw->nDnyDovMPD) = 0
    if (dovBez + mzdyhdw->nDnyDovBPD) <= msprc_moC->nDovMinNar
      msprc_moC->nDovMinCeO := mzdyhdw->nDnyDovBPD
      msprc_moC->nDovMinCer := dovBez + mzdyhdw->nDnyDovBPD
      msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer
    else
      if dovBez <= msprc_moC->nDovMinNar .and. dovBez <> 0
        msprc_moC->nDovMinCeO := mzdyhdw->nDnyDovBPD - ((dovBez + mzdyhdw->nDnyDovBPD) - msprc_moC->nDovMinNar)
        msprc_moC->nDovMinCer := dovBez + msprc_moC->nDovMinCeO
        msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer

        msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD - msprc_moC->nDovMinCeO
        msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO
        msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR
      else
        if dovBez > 0 .and. msprc_moC->nDovMinNar = 0
          msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD
          msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO + dovBez
          msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR
        else
          msprc_moC->nDovMinCeR := msprc_moC->nDovMinNar
          msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCeR

          msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD
          msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO + (dovBez - msprc_moC->nDovMinNar)
          msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR
        endif
      endif
    endif
  else
    if mzdyhdw->nDnyDovMPD <> 0 .or. dovMin <> 0
      msprc_moC->nDovMinCeO := mzdyhdw->nDnyDovMPD
      msprc_moC->nDovMinCer := dovMin + msprc_moC->nDovMinCeO
      msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer
    endif

    if mzdyhdw->nDnyDovBPD <> 0 .or. dovBez <> 0
      msprc_moC->nDovBezCeO := mzdyhdw->nDnyDovBPD
      msprc_moC->nDovBezCer := dovBez + msprc_moC->nDovBezCeO
      msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCer
    endif
  endif

  msprc_moC->nDovZustat := msprc_moC->nDovBezZus +msprc_moC->nDovMinZus
  msprc_moC->nDoDZustat := msprc_moC->nDoDBezZus +msprc_moC->nDoDMinZus

  msprc_moC->nDovNaroCe := msprc_moC->nDovMinNar+msprc_moC->nDovBezNar      ;
                            +msprc_moC->nDoDMinNar+msprc_moC->nDoDBezNar

  msprc_moC->nDovCerOCe := msprc_moC->nDovMinCeO+msprc_moC->nDovBezCeO      ;
                            +msprc_moC->nDoDMinCeO+msprc_moC->nDoDBezCeO

  msprc_moC->nDovCerRCe := msprc_moC->nDovMinCeR+msprc_moC->nDovBezCeR      ;
                            +msprc_moC->nDoDMinCeR+msprc_moC->nDoDBezCeR

  msprc_moC->nDovZustCe := msprc_moC->nDovMinZus +msprc_moC->nDovBezZus     ;
                            +msprc_moC->nDoDMinZus +msprc_moC->nDoDBezZus

return self


// aktualizuje zùstatky dovolené zamìstnance
method zustDovolHod()
  local  cf := "nrok = %% .and. nobdobi <= %% .and. noscisprac = %% .and. nporpravzt = %%"
  local  dovBez := 0, dovMin := 0
  local  cerBez := 0, cerMin := 0
  local  cky
      *
  if mzdyhdw->nobdobi > 1
    cfiltr := Format( cf, { mzdyhdw->nrok, mzdyhdw->nobdobi-1, mzdyhdw->noscisprac, mzdyhdw->nporpravzt })
    mzdyhdC->( ads_setaof(cfiltr), dbGoTop())
    mzdyhdC->( dbeval( { || (dovBez += mzdyhdC->nHodDovBPD, dovMin += mzdyhdC->nHodDovMPD)} ))
  endif

  msprc_moC->nHDoMinCeO := 0
  msprc_moC->nHDoMinCer := 0
  msprc_moC->nHDoMinZus := msprc_moC->nHDoMinNar

  msprc_moC->nHDoBezCeO := 0
  msprc_moC->nHDoBezCer := 0
  msprc_moC->nHDoBezZus := msprc_moC->nHDoBezNar

  if ( dovMin + mzdyhdw->nHodDovMPD) = 0
    if (dovBez + mzdyhdw->nHodDovBPD) <= msprc_moC->nHDoMinNar
      msprc_moC->nHDoMinCeO := mzdyhdw->nHodDovBPD
      msprc_moC->nHDoMinCer := dovBez + mzdyhdw->nHodDovBPD
      msprc_moC->nHDoMinZus := msprc_moC->nHDoMinNar - msprc_moC->nHDoMinCer
    else
      if dovBez <= msprc_moC->nHDoMinNar .and. dovBez <> 0
        msprc_moC->nHDoMinCeO := mzdyhdw->nHodDovBPD - ((dovBez + mzdyhdw->nHodDovBPD) - msprc_moC->nHDoMinNar)
        msprc_moC->nHDoMinCer := dovBez + msprc_moC->nHDoMinCeO
        msprc_moC->nHDoMinZus := msprc_moC->nHDoMinNar - msprc_moC->nHDoMinCer

        msprc_moC->nHDoBezCeO := mzdyhdw->nHodDovBPD - msprc_moC->nHDoMinCeO
        msprc_moC->nHDoBezCeR := msprc_moC->nHDoBezCeO
        msprc_moC->nHDoBezZus := msprc_moC->nHDoBezNar - msprc_moC->nHDoBezCeR
      else
        if dovBez > 0 .and. msprc_moC->nHDoMinNar = 0
          msprc_moC->nHDoBezCeO := mzdyhdw->nHodDovBPD
          msprc_moC->nHDoBezCeR := msprc_moC->nHDoBezCeO + dovBez
          msprc_moC->nHDoBezZus := msprc_moC->nHDoBezNar - msprc_moC->nHDoBezCeR
        else
          msprc_moC->nHDoMinCeR := msprc_moC->nHDoMinNar
          msprc_moC->nHDoMinZus := msprc_moC->nHDoMinNar - msprc_moC->nHDoMinCeR

          msprc_moC->nHDoBezCeO := mzdyhdw->nHodDovBPD
          msprc_moC->nHDoBezCeR := msprc_moC->nHDoBezCeO + (dovBez - msprc_moC->nHDoMinNar)
          msprc_moC->nHDoBezZus := msprc_moC->nHDoBezNar - msprc_moC->nHDoBezCeR
        endif
      endif
    endif
  else
    if mzdyhdw->nHodDovMPD <> 0 .or. dovMin <> 0
      msprc_moC->nHDoMinCeO := mzdyhdw->nHodDovMPD
      msprc_moC->nHDoMinCer := dovMin + msprc_moC->nHDoMinCeO
      msprc_moC->nHDoMinZus := msprc_moC->nHDoMinNar - msprc_moC->nHDoMinCer
    endif

    if mzdyhdw->nHodDovBPD <> 0 .or. dovBez <> 0
      msprc_moC->nHDoBezCeO := mzdyhdw->nHodDovBPD
      msprc_moC->nHDoBezCer := dovBez + msprc_moC->nHDoBezCeO
      msprc_moC->nHDoBezZus := msprc_moC->nHDoBezNar - msprc_moC->nHDoBezCer
    endif
  endif

  msprc_moC->nHDoZustat := msprc_moC->nHDoBezZus +msprc_moC->nHDoMinZus
  msprc_moC->nHDDZustat := msprc_moC->nHDDBezZus +msprc_moC->nHDDMinZus

  msprc_moC->nHDoNaroCe := msprc_moC->nHDoMinNar+msprc_moC->nHDoBezNar      ;
                            +msprc_moC->nHDDMinNar+msprc_moC->nHDDBezNar

  msprc_moC->nHDoCerOCe := msprc_moC->nHDoMinCeO+msprc_moC->nHDoBezCeO      ;
                            +msprc_moC->nHDDMinCeO+msprc_moC->nHDDBezCeO

  msprc_moC->nHDoCerRCe := msprc_moC->nHDoMinCeR+msprc_moC->nHDoBezCeR      ;
                            +msprc_moC->nHDDMinCeR+msprc_moC->nHDDBezCeR

  msprc_moC->nHDoZustCe := msprc_moC->nHDoMinZus +msprc_moC->nHDoBezZus     ;
                            +msprc_moC->nHDDMinZus +msprc_moC->nHDDBezZus

return self