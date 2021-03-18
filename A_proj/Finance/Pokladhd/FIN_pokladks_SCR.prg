#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004' , ;
                   'pokladhd','pokladms'                                   }

*
** CLASS for FIN_pokladks_scr **************************************************
CLASS FIN_pokladks_scr FROM drgUsrClass, FIN_finance_IN
exported:
  var     oinf
  method  init, drgDialogStart, itemMarked, tabSelect, fin_pokladks_cmp

  * ks - browColumn _ 2
  inline access assign method nazPokl() var nazPokl
    pokladms->(dbseek(pokladks->npokladna,,'POKLADM1'))
    return pokladms->cnazpoklad

  inline access assign method zkrMeny() var zkrMeny
    return pokladms->czkratmeny

  * hd - browColumn _ 7
  inline access assign method typPohybu() var typPohybu
    return if(pokladhd->ntypdok = 1, MIS_PLUS , ;
           if(pokladhd->ntypdok = 2, MIS_MINUS, MIS_BOOKOPEN))

  * it - browColumn _ 6
  inline access assign method typObratu() var typObratu
  return if(pokladit->ntypobratu = 1, 304, 305 )

HIDDEN:
  VAR  tabnum, brow, npokladna, comboBox, zaklMena, msg
ENDCLASS


METHOD FIN_pokladks_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::tabnum := 1

  * základní soubory
  ::openfiles(m_files)

  * pro pøepoèet
  drgDBMS:open('pokladms',,,,,'pokl_msW')
  drgDBMS:open('pokladks',,,,,'pokl_ksW')
  drgDBMS:open('pokladhd',,,,,'pokl_hdW')

  ** likvidace
  ::FIN_finance_in:typ_lik := 'pok'
  ::oinf  := fin_datainfo():new('POKLADHD')
RETURN self


METHOD FIN_pokladks_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
  ::msg  := drgDialog:oMessageBar
RETURN


METHOD FIN_pokladks_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


method fin_pokladks_scr:itemMarked(arowco,unil,oxbp)
  local cfile, ky, rest := ''

  if isObject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'pokladks', 'ab', if(cfile = 'pokladhd', 'b', ''))

    if( 'a' $ rest)
      ky := strzero(pokladks->npokladna,3) +dtos(pokladks->dporizdok)
      pokladhd->(AdsSetOrder('POKLADH8'), dbsetscope(SCOPE_BOTH,ky), dbgotop())
    endif

    if ('b' $ rest)
      ky := strzero(pokladhd->ndoklad,10)
      pokladit->(AdsSetOrder('BANKVY_1'), dbsetscope(SCOPE_BOTH,ky), dbGotop())

      ky := upper(pokladhd ->cdenik) +strzero(pokladhd->ndoklad,10)
      ucetpol->(AdsSetOrder('UCETPOL1'), dbsetscope(SCOPE_BOTH,ky), dbgotop())
    endif
  endif
return self


method fin_pokladks_scr:fin_pokladks_cmp()
  local  nsel
  local  nPOCSTAV  , nPRIJEM  := 0, nVYDEJ   := 0, nPOSPRI    := 0, nPOSVYD    := 0
  local  nPOCST_TUZ, nPRI_TUZ := 0, nVYD_TUZ := 0, nPOSPR_TUZ := 0, nPOSVY_TUZ := 0
  local  ckeyS
  local  dPORIZDOK, dPOSPRI, dPOSVYD
  local  ldone := .t., lIsTUZ_Uc
  *
  local  p_kum := {}, rec, pos
  *
  local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread
  local     xbp_therm := ::msg:msgStatus

  *
  ** nachystáme si èervíka v samostatném vláknì
  for i := 1 to 4 step 1
    aBitMaps[3,i] := XbpBitmap():new():create()
    aBitMaps[3,i]:load( ,nPHASe )
    nPHASe++
  next
  *
  **
  nsel := ConfirmBox( ,'Požadujete zpracovat kontrolní pøepoèet stavu pokladen ?', ;
                       'Kontrolní pøepoèet stavu pokladen ...' , ;
                        XBPMB_YESNO                     , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES
    if pokl_ksW->(flock()) .and. pokl_msW->(flock())
      oThread := Thread():new()
      oThread:setInterval( 8 )
      oThread:start( "fin_pokladks_animate", xbp_therm, aBitMaps)

      pokl_msW->(AdsSetOrder(1),dbGoTop())
      do while .not. pokl_msW->(eof())
        pokl_msW->dposPrijem := CTOD( '  .  .  ')
        pokl_msW->nposPrijem := 0
        pokl_msW->dposVydej  := CTOD( '  .  .  ')
        pokl_msW->nposVydej  := 0
        pokl_msW->naktStav   := pokl_msW->npocStav +nposPri -nposVyd

        pokl_msW->(dbskip())
      enddo

      pokl_msW->(AdsSetOrder(1),dbGoTop())
      pokl_hdW->(AdsSetOrder(8), dbgoTop())
      pokl_ksW->(AdsSetOrder(1)                                , ;
                 dbGoTop()                                     , ;
                 dbeval({|| aadd(p_kum, pokl_ksW->(recno())) })  )

      *
      ckeyS := pokl_hdW->(left(sx_keyData(),11))
      pokl_msW->(dbSeek(val(left(ckeys, 3)),, AdsCtag(1) ))
      lisTuz_uc := pokl_msW->lisTuz_uc
      *
      **
      do while lDone
        if ckeyS = pokl_hdW->(left(sx_keyData(),11))
          dporizDok := pokl_hdW->dporizDok
          nprijem   += if( lisTuz_uc, pokl_hdW->nprijem, pokl_hdW->nprijemZ)
          npri_Tuz  += pokl_hdW->nprijem
          nvydej    += if( lisTuz_uc, pokl_hdW->nvydej , pokl_hdW->nvydejZ )
          nvyd_Tuz  += pokl_hdW->nvydej
          dposPri   := if( pokl_hdW->ntypDok = 1, dporizDok, dposPri )
          nposPri   += if( lisTuz_uc, pokl_hdW->nprijem, pokl_hdW->nprijemZ)
          dposVyd   := if( pokl_hdW->ntypDok = 2, dporizDok, dposVyd )
          nposVyd   += if( lisTuz_uc, pokl_hdW->nvydej , pokl_hdW->nvydejZ )

        else
          pokl_msW->(dbSeek(val(left(ckeyS, 3)),, AdsCtag(1) ))

          if pokl_msW->npokladna = 0 .or. pokl_msW->dpocStav > dporizDok
            *
            ** pokladna neexisuje nebo dpocStav > dporizDok --- > nejde do KS **
            *
          else
            if pokl_ksW->(dbseek(ckeyS))
              rec := pokl_ksW->(recno())
              if((pos := ascan(p_kum, rec)) <> 0, (adel(p_kum,pos), asize(p_kum, len(p_kum)-1)), nil)
            else
              pokl_ksW->(dbappend())
            endif

            mh_copyFld('pokl_msW', 'pokl_ksW')
            pokl_ksW->dporizDok  := dporizDok

            if( IsNIL(npocStav), NIL, pokl_ksW->npocStav := npocStav )
            pokl_ksW->nprijem    := nprijem
            pokl_ksW->nvydej     := nvydej
            pokl_ksW->naktStav   := pokl_ksW->npocStav +nprijem -nvydej
            npocStav             := pokl_ksW->naktStav

            if( IsNIL(npocSt_Tuz), NIL, pokl_ksW->npocSt_Tuz := npocSt_Tuz )
            pokl_ksW->npri_Tuz   := npri_Tuz
            pokl_ksW->nvyd_Tuz   := nvyd_Tuz
            pokl_ksW->naktSt_Tuz := pokl_ksW->npocSt_Tuz +npri_Tuz -nvyd_Tuz
            npocSt_Tuz           := pokl_ksW->naktSt_Tuz

            pokl_msW->nposPrijem += nposPri
            pokl_msW->nposVydej  += nposVyd

            * doplnníme pokladms
            if left(ckeyS,3) <> pokl_hdW->( left( sx_keyData(), 3))
              pokl_msW->dposPrijem := if( ISNIL(dposPri), CTOD( '  .  .  '), dposPri )
              pokl_msW->dposVydej  := if( ISNIL(dposVyd), CTOD( '  .  .  '), dposVyd )
              pokl_msW->naktStav   := pokl_msW->npocStav +pokl_msW->nposPrijem -pokl_msW->nposVydej

              nposPri    := 0
              dposPri    := nil
              nposVyd    := 0
              dposVyd    := nil
              npocStav   := nil
              npocSt_Tuz := nil
            endif
          endif

          ckeyS := pokl_hdW->(left(sx_keyData(),11))
          pokl_msW->(dbSeek(val(left(ckeys, 3)),, AdsCtag(1) ))
          lisTuz_uc := pokl_msW->lisTuz_uc
          *
          **
          dporizDok := pokl_hdW->dporizDok
          nprijem   := if( lisTuz_uc, pokl_hdW->nprijem, pokl_hdW->nprijemZ)
          npri_Tuz  := pokl_hdW->nprijem
          nvydej    := if( lisTuz_uc, pokl_hdW->nvydej , pokl_hdW->nvydejZ )
          nvyd_Tuz  := pokl_hdW->nvydej
          dposPri   := if( pokl_hdW->ntypDok = 1, dporizDok, dposPri )
          nposPri   := if( lisTuz_uc, pokl_hdW->nprijem, pokl_hdW->nprijemZ)
          dposVyd   := if( pokl_hdW->ntypDok = 2, dporizDok, dposVyd )
          nposVyd   := if( lisTuz_uc, pokl_hdW->nvydej , pokl_hdW->nvydejZ )

          lDone     := .not. (left(ckeyS,3) = '000') .and. .not. pokl_hdw->(eof())
        endif

        pokl_hdW->(dbSkip())
      enddo

      aeval(p_kum , {|x| pokl_ksW ->(dbgoto(x),dbdelete())})

      xbp_therm:setCaption('')

      * vrátíme to
      oThread:setInterval( NIL )
      oThread:synchronize( 0 )
      oThread := nil

    else
      ConfirmBox( ,'Nelze zpracovat kontrolní pøepoèet, blokováno uživatelem ...', ;
                   'Nelze zpracovat kontrolní pøepoèet ...' , ;
                   XBPMB_CANCEL                             , ;
                   XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE)
    endif
  endif

  pokl_ksW->(dbunlock(), dbcommit())
  pokl_msW->(dbunlock(), dbCommit())

  ::brow[1]:oxbp:forceStable()
  ::brow[1]:oxbp:refreshAll()
  ::itemMarked(,,::brow[1]:oxbp)
return


procedure fin_pokladks_animate(xbp_therm,aBitMaps)
  local  aRect, oPS, nXD, nYD

  xbp_therm:setCaption('')

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  nXD     := abitMaps[2]
  nYD     := 0

  aBitMaps[1] ++
  if aBitMaps[1] > len(aBitMaps[3])
    aBitMaps[1] := 1
  endif

  aBitMaps[ 3, aBitMaps[1] ]:draw( oPS, {nXD,nYD} )
  xbp_therm:unlockPS( oPS )

  if abitMaps[2] +10 > aRect[1]
    abitMaps[2] := 0
  else
    abitMaps[2] := abitMaps[2] +10
  endif
return