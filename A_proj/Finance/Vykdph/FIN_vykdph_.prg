**
**  Remarks
**  Rv_FOREDIT(cFILE,cBLOCK,dUZ)     ->  FIN_vykdph_cpy(cFILE)
**  Rv_FORSAVE(lIsTST,lIsDEL,cFILE)  ->  FIN_vykdph_wrt()
**                                       FIN_vykdph_rlo()
**
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"


/*
FAKPRIHD  nFINTYP

RV jen
1 -> FAKPB  ->  FAKP       ... Faktura pøijatá bìžná
2 -> FAKPC  ->  FAKPCEL    ... Faktura pøijatá celní
3 -> FAKPZ  ->  FAKPZAL    ... Faktura pøijatá zálohová
4 -> FAKPZB ->  FAKPZAH    ... Faktura pøijatá zahranièní
5 -> FAKPZZ ->  FAKZAHZAL  ... Faktura pøijatá zahranièní zálohová
6 -> FAKPEU ->  FAKPEURO   ... Faktura pøijatá EURo

C_VYKDPH                                                            FAKPRIHD   - FAKPRIHDTU
                                                                    sz sz sz o
 1 FAKPB  nTYP == 1  Bs   SUBSTR( VYKDPH_p ->FAKPRIHD, 1, 1) == 1   10 xx xx x
                  2  Bz   SUBSTR( VYKDPH_p ->FAKPRIHD, 2, 1) == 1   01 xx xx x
 2 FAKPC  nTYP == 1  Cs   SUBSTR( VYKDPH_p ->FAKPRIHD, 3, 1) == 1   xx 10 xx x
                  2  Cz   SUBSTR( VYKDPH_p ->FAKPRIHD, 4, 1) == 1   xx 01 xx x
 6 FAKEU  nTYP == 1  Es   SUBSTR( VYKDPH_p ->FAKPRIHD, 5, 1) == 1   xx xx 10 x
                  2  Ez   SUBSTR( VYKDPH_p ->FAKPRIHD, 6, 1) == 1   xx xx 01 x
--------------------------------------------------------------------------------

POKLADHD  nTYPDOK

1 -> pøíjem
2 -> výdej
3 -> zúètování zálohy

C_VYKDPH                                                            POKLADHD - POKLADHDTU
                                                                    sz sz o
          nTYP == 1  Ps   SUBSTR( c_VYKDPH ->POKLADHD, 1, 1) == 1   10 xx x
                  2  Pz   SUBSTR( c_VYKDPH ->POKLADHD, 2, 1) == 1   01 xx x
--------------------------------------------------------------------------------

UCETDOHD  nTYPOBRATU

1 -> md
2 -> dal

C_VYKDPH                                                            UCETDOHD - UCETDOHDTU
                                                                    sz sz o
 1 MD     nTYP == 1  Ms   SUBSTR( c_VYKDPH ->UCETDOHD, 1, 1) == 1   10 xx x
                  2  Mz   SUBSTR( c_VYKDPH ->UCETDOHD, 2, 1) == 1   01 xx x
 2 DAL    nTYP == 1  Ds   SUBSTR( c_VYKDPH ->UCETDOHD, 3, 1) == 1   xx 10 x
                  2  Dz   SUBSTR( c_VYKDPH ->UCETDOHD, 4, 1) == 1   xx 01 x
--------------------------------------------------------------------------------
*/


static anvyk


*                               paRv_forImp øv zatím jen pro import fakVyst z PALECKA
PROCEDURE FIN_vykdph_cpy(cFILe, paRv_forImp)
  local  file_name, ok, duzp, dat_od
  LOCAL  cKy := UPPER( DBGetVal(cFILe +'->cDENIK')) +STRZERO( DBGetVal(cFILe +'->nDOKLAD'),10)
  LOCAL  cV  := Lower(cFILe), cTy := SubStr(cFILe,1,LEN(cFILe) -1) +'TU'
  LOCAL  typ, pos, nul, poradi := 1, pap := {}
  *
  local  cradDph, pa_radDph
  *
  LOCAL  aIT := ;
  { COMPILE( 'VYKDPH_Iw ->cULOHA     := ' +cFILe +'->cULOHA'    ) , ;
    COMPILE( 'VYKDPH_Iw ->nDOKLAD    := ' +cFILe +'->nDOKLAD'   ) , ;
    COMPILE( 'VYKDPH_Iw ->cOBDOBI    := ' +cFILe +'->cOBDOBI '  ) , ;
    COMPILE( 'VYKDPH_Iw ->nROK       := ' +cFILe +'->nROK'      ) , ;
    COMPILE( 'VYKDPH_Iw ->nOBDOBI    := ' +cFILe +'->nOBDOBI'   ) , ;
    COMPILE( 'VYKDPH_Iw ->cOBDOBIdan := ' +cFILe +'->cOBDOBIdan') , ;
    COMPILE( 'VYKDPH_Iw ->nTYP_dph   := C_VYKDPH ->nNAPOCET'    ) , ;
    COMPILE( 'VYKDPH_Iw ->nODDIL_dph := C_VYKDPH ->nODDIL_dph'  ) , ;
    COMPILE( 'VYKDPH_Iw ->nRADEK_dph := C_VYKDPH ->nRADEK_dph'  ) , ;
    COMPILE( 'VYKDPH_Iw ->cZUSTUCT   := C_VYKDPH ->cZUSTUCT'    ) , ;
    COMPILE( 'VYKDPH_Iw ->nZAKLD_dph := if( vykDph_i->(eof()), 0, VYKDPH_I ->nZAKLD_dph )'  ) , ;
    COMPILE( 'VYKDPH_Iw ->nSAZBA_dph := if( vykDph_i->(eof()), 0, VYKDPH_I ->nSAZBA_dph )'  ) , ;
    COMPILE( 'VYKDPH_Iw ->nKRACE_nar := if( vykDph_i->(eof()), 0, VYKDPH_I ->nKRACE_nar )'  ) , ;
    COMPILE( 'VYKDPH_Iw ->cUCETU_dph := If( EMPTY(VYKDPH_I ->cUCETU_dph), C_VYKDPH ->cUCETU_dph, VYKDPH_I ->cUCETU_dph)') , ;
    COMPILE( 'VYKDPH_Iw ->nDAT_od    := C_VYKDPH ->nDAT_od'     ) , ;
    COMPILE( 'VYKDPH_Iw ->cDENIK     := ' +cFILe +'->cDENIK'    ) , ;
    COMPILE( 'VYKDPH_Iw ->FAKPRIHD   := C_VYKDPH ->FAKPRIHD'    ) , ;
    COMPILE( 'VYKDPH_Iw ->FAKVYSIT   := C_VYKDPH ->FAKVYSIT'    ) , ;
    COMPILE( 'VYKDPH_Iw ->POKLADHD   := C_VYKDPH ->POKLADHD'    ) , ;
    COMPILE( 'VYKDPH_Iw ->UCETDOHD   := C_VYKDPH ->UCETDOHD'    ) , ;
    COMPILE( 'VYKDPH_Iw ->cTYPUCT    := C_VYKDPH ->' +cTY       ) , ;
    COMPILE( 'VYKDPH_Iw ->lSLUZBA    := if( vykDph_i->(eof()), .f., VYKDPH_I ->lSLUZBA )'   ) , ;
    COMPILE( 'VYKDPH_Iw ->nPORADI    := if( vykDph_i->(eof()),   0, VYKDPH_I ->nPORADI )'   ) , ;
    COMPILE( 'VYKDPH_IW ->nkodPlneni := C_VYKDPH ->nkodPlneni'  ) , ;
    COMPILE( 'VYKDPH_IW ->npreDanPov := if( vykDph_i->(eof()),   0, VYKDPH_I ->npreDanPov)' ) , ;
    COMPILE( 'VYKDPH_IW ->ntypPreDan := if( vykDph_i->(eof()),   0, VYKDPH_I ->ntypPreDan)' ) , ;
    COMPILE( 'VYKDPH_IW ->ctypPreDan := if( vykDph_i->(eof()),  "", VYKDPH_I ->ctypPreDan)' ) , ;
    COMPILE( 'VYKDPH_IW ->lpreDanPov := C_VYKDPH ->lpreDanPov'  ) , ;
    COMPILE( 'VYKDPH_IW ->coddilKohl := if( vykDph_i->(eof()),  "", VYKDPH_I ->coddilKohl)' ) , ;
    COMPILE( 'VYKDPH_Iw ->nRECVYK    := if( vykDph_i->( eof()),  0, VYKDPH_I ->(RECNO()))'  )   }



  drgDBMS:open('c_dph')
  drgDBMS:open('C_VYKDPH')
  drgDBMS:open('VYKDPH_I')

  * klasika pro bìžný vstup
  * pokud uvedu paRv_forImp musí být vykDph_Iw otevøený v dané èinnosti
  if isNull( paRv_forImp )
    if(select('vykdph_iw') <> 0, vykdph_iw->(dbclosearea()), nil)
    if(select('vykdph_is') <> 0, vykdph_is->(dbclosearea()), nil )

    drgDBMS:open('VYKDPH_Iw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    * is je pro souètování *
    file_name := vykdph_iw ->( DBInfo(DBO_FILENAME))
                 vykdph_iw ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, 'vykdph_iw', .t., .f.) ; vykdph_iw->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'vykdph_is', .t., .t.)
    * is
  endif

  C_VYKDPH  ->(AdsSetOrder(3), DbGoTop())
  drgDBMS:open('c_typpoh')
  c_typPoh->(dbseek(upper((cfile)->culoha) +upper((cfile)->ctypdoklad) +upper((cfile)->ctyppohybu),,'C_TYPPOH05'))

  DO CASE
  CASE(cV = 'fakprihdw')
    typ  := (cFILe) ->nFINTYP
    pos  := IF(typ = 1, 1, IF(typ = 2, 3, IF(typ = 6, 5, 7)))
    nul  := 7
    duzp := (cFILe)->dvystFak

  CASE(cV = 'pokladhdw')
    typ  := (cFILe) ->nTYPDOK
    pos  := IF(typ = 1, 1, IF(typ = 2, 3, 5))
    nul  := 5
    duzp := (cFILe)->dvystDok

  CASE(cV = 'ucetdohdw')
    typ  := (cFILe) ->nTYPOBRATU
    pos  := IF(typ = 1, 1, IF(typ = 2, 3, 5))
    nul  := 5
    duzp := (cFILe)->dvystDok

  case(cV = 'fakvyshdw')
    typ   := (cFILe) ->nFINTYP
    pos   := IF(typ = 1, 1, IF(typ = 2, 3, IF(typ = 6, 5, 7)))
    nul   := 7
    cfile := 'fakvysitw'
    duzp  := (cV)->dpovinfak

  case(cV = 'poklhdw')
    typ   := (cFILe) ->nFINTYP
    pos   := IF(typ = 1, 1, IF(typ = 2, 3, IF(typ = 6, 5, 7)))
    nul   := 7
    cfile := 'poklitw'
    duzp  := (cV)->dpovinfak

  ENDCASE

  dat_od    := FIN_c_vykdph_ndat_od( duzp )
  cradDph   := FIN_c_vykdph_cradDph( duzp, cV )
  pa_radDph := listAsArray( cradDph )

  vykdph_i->(dbclearscope())

  DO WHILE !C_VYKDPH ->(EOF())
    if c_vykdph->ndat_od = dat_od
      IF .not. Empty(typ := DBGetVal('C_VYKDPH ->' +SubStr(cFILE,1,LEN(cFILe) -1)))

        if (cfile = 'fakvysitw' .or. cfile = 'poklitw')
          ok := .t.
        else
          ok := (SubStr(typ,pos,2) <> '00' .or. SubStr(typ,nul,1) = '1')
        endif

        if ok
          cV := STRZERO( C_VYKDPH ->nODDIL_dph,2) +STRZERO( C_VYKDPH ->nRADEK_dph,3)
          *
          if(lower(cFILe) = 'fakprihdw' .or. ;
             lower(cFILe) = 'fakvysitw', cv += '0000000000', nil)

          * UPPER(cDENIK) +STRZERO(nDOKLAD,10) +STRZERO(nODDIL_dph,2) +STRZERO(nRADEK_dph,3) +STRZERO(nCISFAK,10)

          IF( VYKDPH_I  ->( DbSeek(cKy +cv,,'VYKDPH_4')), AAdd(pap, VYKDPH_I ->nPORADI), NIL )
          VYKDPH_Iw ->( DbAppend())
          aEVAL( aIT, { |X| EVAL(X) } )

          * pro nastavené øádky se aoutomaticky nahodí npreDanPov / lsetDanPov
          if  vykdph_i->(eof()) .and. vykdph_iw->lpreDanPov
            vykdph_iw ->npreDanPov := 1
          endif
          vykdph_iw ->lsetPreDan := (vykdph_iw ->npreDanPov = 1)

          vykdph_iw->nprocdph   := SeekSazDPH(C_VYKDPH ->nNAPOCET)
          vykdph_iw->lmain_rv   := ( ascan( pa_radDph, allTrim( str( vykdph_iw->nradek_dph))) <> 0 )
          vykdph_iw->nradek_vaz := coalesceempty(c_vykdph->nradek_vaz,c_vykdph->nradek_dph)
          vykdph_iw->combotext  := c_vykdph->cradek_say
        endif

      ENDIF
    endif
    C_VYKDPH ->( DbSkip())
  ENDDO

  ** poøadí **
  VYKDPH_Iw ->(DbGoTop())
  DO WHILE .not. VYKDPH_Iw ->(Eof())
    IF VYKDPH_Iw ->nPORADI = 0
      DO WHILE poradi $ pap ; poradi++ ; ENDDO
      VYKDPH_Iw ->nPORADI := poradi
      poradi++
    ENDIF

    VYKDPH_Iw ->(DbSkip())
  ENDDO

RETURN


FUNCTION FIN_vykdph_rlo(cFILE)
RETURN FIN_vykdph_wrt(.T.,.F.,cFILE)


FUNCTION FIN_vykdph_wrt(lIsTST,lIsDEL,cFILE)
  Local  cIT   := 'VYKDPH_P ->' +cFILE, cTYP_dph
  Local  lDONe := .T., alVYK
  Local  aUD   := ;
  { COMPILE( 'VYKDPH_Iw ->cDENIK_par := ' +cFILE +'->cDENIK_par' ) , ;
    COMPILE( 'VYKDPH_Iw ->nCISFAK    := ' +cFILE +'->nCISFAK'    ) , ;
    COMPILE( 'VYKDPH_Iw ->cDENIK_or  := ' +cFILE +'->cDENIK'     ) , ;
    COMPILE( 'VYKDPH_Iw ->nDOKLAD_or := ' +cFILE +'->nDOKLAD'    ) , ;
    COMPILE( 'VYKDPH_Iw ->nZAKLD_or  :=  VYKDPH_Iw ->nZAKLD_dph' ) , ;
    COMPILE( 'VYKDPH_Iw ->nSAZBA_or  :=  VYKDPH_Iw ->nSAZBA_dph' )   }
  Local  aIT   := ;
  { COMPILE( 'VYKDPH_Iw ->cULOHA     := ' +cFILE +'->cULOHA'     ) , ;
    COMPILE( 'VYKDPH_Iw ->nDOKLAD    := ' +cFILE +'->nDOKLAD'    ) , ;
    COMPILE( 'VYKDPH_Iw ->cOBDOBI    := ' +cFILE +'->cOBDOBI '   ) , ;
    COMPILE( 'VYKDPH_Iw ->nROK       := ' +cFILE +'->nROK'       ) , ;
    COMPILE( 'VYKDPH_Iw ->nOBDOBI    := ' +cFILE +'->nOBDOBI'    ) , ;
    COMPILE( 'VYKDPH_Iw ->cOBDOBIdan := ' +cFILE +'->cOBDOBIdan' ) , ;
    COMPILE( 'VYKDPH_Iw ->cDENIK     := ' +cFILE +'->cDENIK'     ) , ;
    COMPILE( 'VYKDPH_Iw ->nRECVYK    := 0'                       )   }

  DEFAULT lIsTST TO .F., lIsDEL TO .F.
  VYKDPH_Iw ->(dbclearfilter(),AdsSetOrder(0),dbgotop(), flock())

  if lIsTST
    anVYK     := {}
    DO WHILE !VYKDPH_Iw ->( Eof())
      IF (VYKDPH_Iw ->nPROCdph <> 0 .and. VYKDPH_Iw ->nSAZBA_dph == 0) .or. ;
         (VYKDPH_Iw ->nPROCdph == 0 .and. VYKDPH_Iw ->nZAKLD_dph == 0)

        If( VYKDPH_Iw ->nRECVYK == 0, NIL, AAdd(anVYK,VYKDPH_Iw ->nRECVYK ) )
        VYKDPH_Iw ->( DbDelete())
      ELSE
        IF( VYKDPH_Iw ->nRECVYK == 0, NIL, AAdd(anVYK,VYKDPH_Iw ->nRECVYK ) )
      ENDIF
      VYKDPH_Iw ->( DbSkip())
    ENDDO

    lDONe := VYKDPH_I ->(sx_RLOCK(anVYK))
  else
    if .not. lisdel
      vykdph_iw->(dbgotop())

      do while .not. vykdph_iw ->(eof())
        if .not. empty(anVyk)  ;  vykdph_i ->(dbgoto(anVyk[1]))
                                  (adel(anVyk,1), asize(anVyk, len(anVyk) -1))
        else                   ;  vykdph_i->(dbappend(), sx_rlock())
        endif

        aeval(aIT, {|x| eval(x)} )
        if( upper(cFILe) = 'UCETDOHD', aeval(aUD, {|x| eval(x)} ), NIL )

        * úprava na základì požadavku
        if (upper(cfile) = 'FAKPRIHD' .or. upper(cfile) = 'FAKVYSHD')
          vykdph_iw->lNo_InDph := (cfile)->lNo_InDph
        endif

        *
        ** do vykdhp_i doplnit ncisFirmy/ cdic ze základního souboru
        if( (cfile)->( fieldPos( 'ncisFirmy')) <> 0, vykdph_iw->ncisFirmy := (cfile)->ncisFirmy, nil )
        if( (cfile)->( fieldPos( 'cdic'     )) <> 0, vykdph_iw->cdic      := (cfile)->cdic     , nil )

        mh_COPYFLD('VYKDPH_Iw', 'VYKDPH_I',, .f.)
        vykdph_iw ->(dbskip())
      enddo
    endif

    if isarray(anvyk)
      aeval(anVyk, {|x| vykdph_i ->(dbgoto(x),dbrlock(),dbdelete(),dbrunlock())} )
    endif
  endif
return lDONe