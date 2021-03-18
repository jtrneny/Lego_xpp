#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
*
#include "..\SKLADY\SKL_Sklady.ch"



function skl_pvpHead_cpy(odialog)
  local  lNEWhd := if( IsNull(oDialog), .F., oDialog:NEWhd )
  local  cky    := upper(pvpHead->ccisSklad) +strZero(pvpHead->ndoklad,10)
  local  cky_vaz, ndoklad
  *
  local  typDoklad := 'SKL_PRI110', typPvp := 1, nkarta := 110
  local  typPohybu, cisSklad, datPvp
  local  zahrMena

   ** tmp **
  drgDBMS:open('pvpHeadw'  ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('pvpItemww' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('pvpItemw'  ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('vyrCisw'   ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('vyrZakitw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('msDimW'    ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP


  if .not. lNEWhd
    mh_copyFld( 'pvpHead', 'pvpHeadw', .t., .t. )

    if empty(pvpHeadW ->czahrMena)
      pvpHeadW ->czahrMena   := sysConfig( 'FINANCE:cZAKLMENA' )
      pvpHeadW ->nkurZAHmen  := 1
      pvpHeadW ->nmnozPrep   := 1
    else
      pvpHeadW ->czahrMena   := upper(pvpHeadW ->czahrMena)
    endif

    pvpItem->( ordSetFocus( 'PVPITEM02' )   , ;
               dbsetScope( SCOPE_BOTH, cky ), ;
               dbgoTop()                      )

    do while .not. pvpItem->(eof())
      cky_vaz := upper(pvpItem->ccisSklad) +upper(pvpItem->csklPol)
      cenZboz->( dbseek( cky_vaz,,'CENIK03' ))

      mh_copyFld( 'pvpItem', 'pvpItemww', .t., .t. )

      pvpItemWW->ctypSKLcen := cenZboz->ctypSKLcen
      pvpItemww->nmnozP_org := pvpItem->nmnozPRdod   // in pvpItemWW DBD
      pvpItemww->nmnozD_org := pvpItemWW->nmnozDokl1
      *
      ** musíme zabezpeèit naplnìní a doplnìní údajù pøi opravì
      *
      * pro druh pohybu 177 se pøi ukádání zanulují nmnozDokl1/ nmnozPRdod
      * musí se nastavit na 1
      if( pvphead->nkarta = 177, (pvpItemWW->nmnozDokl1 := 1, pvpItemWW->nmnozPRdod := 1), nil )


      if( pvpHeadW->ncenDOKzm   = 0 , pvpHeadW->ncenDOKzm   := pvpHeadW->ncenaDokl  , nil )
      if( pvpHeadW->nnutneVNzm  = 0 , pvpHeadW->nnutneVNzm  := pvpHeadW->nnutneVN   , nil )

      if( pvpItemWW->nmnozDokl1 = 0 , pvpItemWW->nmnozDokl1 := pvpItemWW->nmnozPRdod, nil )
      if( pvpItemWW->cmjDokl1   = '', pvpItemWW->cmjDokl1   := pvpItemWW->czkratJedn, nil )
      if( pvpItemWW->ncenaDokl1 = 0 , pvpItemWW->ncenaDokl1 := pvpItemWW->ncenNAPdod, nil )

      if( pvpItemWW->ncenNADOzm = 0 , pvpItemWW->ncenNADOzm := pvpItemWW->ncenaDokl1, nil )
      if( pvpItemWW->ncenCZAKzm = 0 , pvpItemWW->ncenCZAKzm := pvpItemWW->ncenaCELK , nil )
      if( pvpItemWW->ncenCELKzm = 0 , pvpItemWW->ncenCELKzm := pvpItemWW->ncenaCELK , nil )


      if odialog:pvpitem_isOk() = 558 .and. odialog:lwatchPrij
        pvpItemWW ->nstav_Polo := 9
        pvpHeadW  ->nstav_Dokl := 9
      endif

      *
      ** musíme doplnit vazby na cenZboz, objvysit, objitem, pvpterm
      do case
      case pvpitem->ccisObj <> ''
        cky_vaz := strZero( pvphead->ncisFirmy,5) +upper(pvpitem->ccisObj) +strZero(pvpitem->nintCount,5)

        if objVysit->( dbseek( cky_vaz,,'OBJVYSI1'))
          pvpitemWW->cfile_iv  := 'objvysit'
          pvpitemWW->nOBJVYSIT := objVysit->sID
        endif

      case pvpitem->ccislOBint <> ''
        cky_vaz := upper(pvpitem->ccislOBint) +strZero(pvpitem->ncislPOLob,5)

        if objitem->( dbseek( cky_vaz,,'OBJITEM2'))
          pvpitemWW->cfile_iv  := 'objitem'
          pvpitemWW->nOBJITEM  := isNull(objitem->sID, 0)
        endif

      case pvpitem->nVYRPOL <> 0
        pvpitemWW->cfile_iv := 'vyrPol'
        pvpitemWW->nVYRPOL  := pvpitem->nVYRPOL

      * tohle je blbì, položka mùže být z cenZboz, pvpTerm, pvpItem - storno
      otherwise
        pvpitemWW->cfile_iv  := 'cenzboz'
      endcase


      pvpItem->( dbskip())
    enddo
  else
    pvpHeadw->( dbAppend())

*   s_skl_typPohybu, s_skl_cisSklad, s_skl_datPvp - bacha mají default .F.

    if isMemberVar( oDialog, 'in_kalkToCen' )         // z vyr_kalkTOcen
      typPohybu := c_typPoh->ctypPohybu
      cisSklad  := oDialog:ccisSklad
      ddatPvp   := date()
    else
      typPohybu := if( isNull(s_skl_typPohybu), sysConfig('SKLADY:ctypPohybu'), s_skl_typPohybu )
      cisSklad  := if( empty(s_skl_cisSklad)  , sysConfig('SKLADY:ccisSklad' ), s_skl_cisSklad  )
      datPvp    := if( empty(s_skl_datPvp)    , date()                        , s_skl_datPvp    )
    endif

    if( empty(cisSklad), cisSklad := c_sklady->ccisSklad, nil )
**    ndoklad := if( .not. empty(cisSklad) .and. odialog:nkarta <> 999, newDoklad_skl( odialog:nkarta, cisSklad ), 0 )

    if isCharacter(typPohybu)
      c_typPoh->( dbseek( 'SDOKLADY        ' + typPohybu,,'C_TYPPOH02'))
    else
      c_typPoh->( dbseek( 'SDOKLADY        ' + typDoklad,,'C_TYPPOH01'))
    endif

    typDoklad := c_typPoh->ctypDoklad
    typPvp    := c_typPoh->ntypPvp
    nkarta    := val ( right( allTrim(c_typPoh->ctypDoklad), 3))

    if( nkarta <> odialog:nkarta, odialog:nkarta := nkarta, nil )
    ndoklad := if( .not. empty(cisSklad) .and. odialog:nkarta <> 999, newDoklad_skl( odialog:nkarta, cisSklad ), 0 )


    c_sklady->( dbseek( cisSklad,,'C_SKLAD1' ))
    zahrMena := coalesceEmpty( c_sklady->czkratMeny, sysConfig( 'FINANCE:cZAKLMENA' ) )
    zahrMena := sysConfig( 'FINANCE:cZAKLMENA' )

    ( pvpHeadw ->culoha      := 'S'                             , ;
      pvpHeadw ->ctask       := 'SKL'                           , ;
      pvpheadW ->ctypDoklad  := c_typPoh->ctypDoklad            , ;
      pvpheadW ->ctypPohybu  := c_typPoh->ctypPohybu            , ;
      pvpHeadW ->ntypPvp     := c_typPoh->ntypPvp               , ;
      pvpheadW ->ntypPohyb   := c_typPoh->ntypPohyb             , ;
      pvpheadW ->ncislPoh    := val(c_typPoh->ctypPohybu)       , ;
      pvpheadW ->ntypPvp     := typPvp                          , ;
      pvpheadW ->ntypPoh     := typPvp                          , ;
      pvpHeadw ->ndoklad     := ndoklad                         , ;
      pvpHeadw ->ddatPvp     := datPvp                          , ;
      pvpHeadw ->cobdPoh     := uctObdobi:SKL:cOBDOBI           , ;
      pvpHeadw ->cobdobi     := uctObdobi:SKL:cOBDOBI           , ;
      pvpHeadW ->nkarta      := nkarta                          , ;
      pvpHeadw ->nROK        := uctOBDOBI:SKL:NROK              , ;
      pvpHeadw ->nOBDOBI     := uctOBDOBI:SKL:NOBDOBI           , ;
      pvpHeadw ->ccisSklad   := cisSklad                        , ;
      pvpHeadw ->cdenik      := sysConfig( 'SKLADY:cDenik' )    , ;
      pvpHeadW ->czahrMena   := zahrMena                        , ;
      pvpHeadW ->nkurZAHmen  := 1                               , ;
      pvpHeadW ->nmnozPrep   := 1                                 )
  endif
return nil



*
** uložení dokladu v transakci *************************************************
function skl_pvphead_wrt_inTrans(odialog)
  local  lDone   := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone :=  skl_pvphead_wtrW(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


function skl_pvphead_wtrW(odialog)
  local  anrec_PVPit := {}, ;
         anrec_Term  := {}, ;
         anrec_OBVhd := {}, anrec_OBVit := {}, ;
         anrec_OBPhd := {}, anrec_OBPit := {}, ;
         anrec_VYRpo := {}
  *
  local  lnewHD          := odialog:NEWhd
  local  panew_invCISdim := if( isMemberVar( odialog, 'panew_invCISdim'), odialog:panew_invCISdim, {} )
  *
  local  pa_skladKAM := {}, skladKAm, x, y
  local  uctLikv, mainOk := .t., nrecor, vykhphOk
  local  typPvp          := pvpHeadW->ntypPvp
  local  oMoment
  *
  local  nrozdil
  local  cTypPohyb       := LEFT( ALLTRIM(STR( pvpheadW->nKarta)), 1 )
  local  cTypHead        := SUBSTR( ALLTRIM(STR( pvpheadW->nKarta)), 2, 1)


  pvpitemWW->(AdsSetOrder(0), ;
              dbgotop()     , ;
              dbeval({|| skl_pvphead_rlo( anrec_PVPit, anrec_Term, anrec_OBVhd, anrec_OBVit, anrec_OBPhd, anrec_OBPit, anrec_VYRpo ) }))

//  uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.)

  if .not. lnewHD
    pvphead->( dbgoTo(pvpheadW->_nrecor))

    mainOk := ( pvphead ->( sx_rLock())            .and. ;
                pvpitem ->( sx_rLock(anrec_PVPit)) .and. ;
                pvpterm ->( sx_rLock(anrec_Term))  .and. ;
                objVyshd->( sx_rLock(anrec_OBVhd)) .and. ;
                objVysit->( sx_rLock(anrec_OBVit)) .and. ;
                objhead ->( sx_rlock(anrec_OBPhd)) .and. ;
                objitem ->( sx_rLock(anrec_OBPit)) .and. ;
                vyrPol  ->( sx_rLock(anrec_VYRpo))       )
  else

    mainOk := ( pvpterm ->( sx_rLock(anrec_Term))  .and. ;
                objVyshd->( sx_rLock(anrec_OBVhd)) .and. ;
                objVysit->( sx_rLock(anrec_OBVit)) .and. ;
                objhead ->( sx_rlock(anrec_OBPhd)) .and. ;
                objitem ->( sx_rLock(anrec_OBPit)) .and. ;
                vyrPol  ->( sx_rLock(anrec_VYRpo))       )
  endif


  if mainOk
     oMoment := SYS_MOMENT( if( pvpheadW->_delrec = '9',  '=== RUŠÍM DOKLAD ===', '=== UKLÁDÁM DOKLAD ===' ) )

    if pvpheadW->_delRec <> '9'
      *
      ** trigger pvpHead_after_insert na serveru, mùže pøeèíslovat ndoklad a ncisloPvp
      pvpheadW->ncisloPvp := pvpheadW->ndoklad
      mh_copyFld( 'pvpheadW', 'pvphead', lnewHD, .f. )

      pvpHead->(dbskip(0))

      pvpheadW->ndoklad   := pvphead->ndoklad
      pvpheadW->ncisloPvp := pvphead->ndoklad
    endif

*    pvpitemWW->( AdsSetOrder(0),dbgotop())
    pvpitemWW->( ordSetFocus('PVPITWW_05'), dbgoTop())

    do while .not. pvpitemWW->( eof())
      if((nrecor := pvpitemWW->_nrecor) = 0, nil, pvpitem->(dbgoto(nrecor)))

      if   pvpitemWW->_delrec = '9' .or. pvpHeadW->_delrec = '9'
        if(nrecor = 0, nil, pvpitem->(dbdelete()))

      else
        pvpitemWW->ndoklad   := pvpHead->ndoklad
        pvpitemWW->ncisloPvp := pvpHead->ncisloPvp
        pvpitemWW->nPVPHEAD  := pvpHead->sID
        * oprava 2.2.2017
        pvpitemWW->ncisFak   := pvpHead->ncisFak
        pvpitemWW->ncisloDL  := pvpHead->ncisloDL

*        if (nrecOR = 0)
*          pvpitemWW->ddatPVP := date()
*          pvpitemWW->ccasPVP := time()
*        endif

        mh_copyFld( 'pvpitemWW', 'pvpitem', (nrecOR = 0), .f. )
        *
        ** na trigru dojde k dorovnání ncenaCelk pøi výdeji do nuly
        ** pro likvidaci to musíme akceptovat
        *
        if( nrecOR = 0, pvpitem->( dbcommit()), nil )

        if pvpitemWW->ncenaCelk <> pvpitem->ncenaCelk
          if cTypPohyb = '1' .and. cTypHead $ '1,2,3'
          else
            nrozdil := (pvpitem->ncenaCelk - pvpitemWW->ncenaCelk )

            pvpHead->nCenDokZM += nrozdil
            pvpHead->ncenaPOL  += nrozdil
            pvpHead->ncenaDOKL += nrozdil
          endi

          pvpitemWW->ncenaCelk := pvpitem->ncenaCelk
          pvpitemWW->( dbCommit())
        endif

        if .not. empty( skladKAm := upper( pvpitemWW->cskladKAm) )
          if ( nin := ascan( pa_skladKAm, { |x| x[1] = skladKAm } ) ) = 0
            aadd( pa_skladKAm, { skladKAm, { pvpitem->( recNo()) } } )
          else
            aadd( pa_skladKAm[nin,2], pvpitem->( recNo()) )
          endif
        endif

        if ( nin := ascan( panew_invCISdim, pvpitemWW->ninvCISdim ) ) <> 0
          aremove( panew_invCISdim, nin )
        endif

// ne tohle se musí jinak   if( pvpheadW->nKarta = 205,  skl_pvpitem_205_DIm(), nil )
      endif

      if pvpitemWW->_delrec = '9' .and. nrecOr = 0
        * nic nedìláme, jen zkoušel pøidat položku s vazbou a zrušil ji
      else

        if( pvpitemWW->nrec_Term <> 0, skl_pvpitem_from_pvpTerm(), ;
         if( pvpitemWW->nrec_OBVhd <> 0 .and. pvpitemWW->nrec_OBVit <> 0, skl_pvpItem_from_objVysit(), ;
          if( pvpitemWW->nrec_OBPhd <> 0 .and. pvpitemWW->nrec_OBPit <> 0, skl_pvpItem_from_objitem(), ;
           if( pvpitemWW->nrec_VYRpo <> 0, skl_pvpItem_from_vyrPol(), nil ))))

        skl_dodZboz_modi()  // FCE in skl_dodZboz_crd,prg
      endif

      pvpitemWW->( dbskip())
    enddo
    *
    ** na trigru mùže dojít k dorovnání ncenaCelk pøi výdeji do nuly
    ** pro likvidaci to musíme akceptovat a až tady zlikvidovat
    *
    pvpitemWW->(AdsSetOrder(0), dbgotop() )
    uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.)
    pvphead->nKLikvid := pvpheadW->nKLikvid
    pvphead->nZLikvid := pvpheadW->nZLikvid
    *
    *
    ** likvidace, bacha u pøevodu budou 2x
    if( pvpheadW->_delrec = '9')
      uctLikv:ucetpol_del()
      pvphead->(sx_rlock(),dbdelete())

      if( .not. lnewHD .and. typPvp = 3, skl_pvphead_prevPrij_del(), nil )

    else
      uctLikv:ucetpol_wrt()

      * pøevod generujeme pøíjemky
      if( .not. lnewHD .and. typPvp = 3, skl_pvphead_prevPrij_del(), nil )

      for x := 1 to len(pa_skladKAm) step 1
        pvpheadW ->( dbZAP())
        pvpitemWW->( dbZap())

        skladKAm := pa_skladKAm[x,1]
        skl_pvphead_PRE305_prij(skladKAm)

        for y := 1 to len( pa_skladKAm[x,2]) step 1
          pvpitem->( dbgoTO( pa_skladKAm[x,2,y] ) )

          skl_pvpitem_PRE305_prij()
        next

        pvpitemWW->( dbCommit(), dbgoTop() )
        uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.)
        ucetpolw->( dbCommit(), dbgoTop())
        uctLikv:ucetpol_rlo := {}
        uctLikv:ucetpol_wrt()
      next
    endif

    oMoment:destroy()

    pvpitemWW->( AdsSetOrder(0),dbgotop())

    pvphead->( dbcommit(), dbunlock() )
     pvpitem->( dbcommit(), dbunlock() )
      ucetpol->( dbcommit(), dbunlock() )
       objitem->( dbunlock(), dbcommit() )
        objvysit->( dbunlock(), dbcommit())
         pvpterm ->( dbunlock(), dbcommit())
          vyrPol  ->( dbunlock(), dbcommit())
  endif
return .t.


static function skl_pvphead_rlo( anrec_PVPit, anrec_Term, anrec_OBVhd, anrec_OBVit, anrec_OBPhd, anrec_OBPit, anrec_VYRpo )
  local  nSID
  local  cislOBint := pvpitemWW->ccislOBint
  local  cisObj    := pvpitemWW->ccisObj

  aadd( anrec_PVPit, pvpitemWW->_nrecOr)

  do case
  case (nSID := pvpitemWW->nPVPTERM ) <> 0
    pvpterm->( dbseek(nSID,,'ID'))
    aadd( anrec_Term, pvpterm->(recNo())  )
    pvpitemWW->nrec_Term := pvpterm->(recNo())

  case (nSID := pvpitemWW->nOBJVYSIT) <> 0
    if objVysit->( dbseek(nSID,,'ID'))
      if objVyshd->( dbseek( objVysit->ndoklad,, 'OBJDODH6') )
        aadd( anrec_OBVhd, objVyshd->( recNo()) )
        aadd( anrec_OBVit, objVysit->( recNo()) )

        pvpitemWW->nrec_OBVhd := objVyshd->( recNo())
        pvpItemWW->nrec_OBVit := objVysit->( recNo())
      endif
    endif

  case (nSID := pvpitemWW->nOBJITEM ) <> 0
    if objitem->( dbseek(nSID,,'ID'))
      if objhead->( dbseek( objitem->ndoklad,,'OBJHEAD7') )
        aadd( anrec_OBPhd, objhead->( recNo()) )
        aadd( anrec_OBPit, objitem->( recNo()) )

        pvpitemWW->nrec_OBPhd := objhead->( recNo())
        pvpitemWW->nrec_OBPit := objitem->( recNo())
      endif
    endif

   case (nSID := pvpitemWW->nVYRPOL ) <> 0
    vyrPol->( dbseek(nSID,,'ID'))
    aadd( anrec_VYRpo, vyrPol->(recNo())  )
    pvpitemWW->nrec_VYRpo := vyrPol->(recNo())

  endcase
return .t.


* zrušíme pøíjmové doklady pøevodu
static function skl_pvphead_prevPrij_del()
  local  cStatement, oStatement
  local  stmt    := "delete from %file where nrok = %yyyy and nobdobi = %mm and culoha = 'S' and ctypPohybu = '%pp'"
  *
  local  pa_files := { 'pvphead', 'pvpitem', 'ucetpol' }
  local  c_in     := ''
  local  nrok     := pvpheadW->nrok, nobdobi := pvpheadW->nobdobi, ctypPohybu
  local  ndoklad  := pvpheadW->ndoklad
  local  cky      := upper(pvpheadW->culoha) +upper(pvpheadW->ctypdoklad) +upper(pvpHeadW->ctyppohybu)
  *
  local  cflt     := "nrok = %% .and. nobdobi = %% .and. culoha = 'S' .and. ctypPohybu = '%%' and ndoklad = %%"
  local  cfiltr

  c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

  if .not. empty(cky := c_typpoh->csubpohyb)
    if c_typpoh->(dbseek(cky,,'C_TYPPOH06'))

      drgDBMS:open( 'pvphead',,,,, 'pvphead_pk' )

      ctypPohybu := c_typpoh->ctypPohybu
      ndoklad    := pvpheadW->ndoklad

      pvphead_pk->( ordSetFocus( 'PVPHEAD24')                            , ;
                   dbsetScope( SCOPE_BOTH, ndoklad )                     , ;
                   dbgoTop()                                             , ;
                   dbeval( { || c_in += str(pvphead_pk->ndoklad) +',' } ), ;
                   dbclearScope()                                          )


      * odl 80 -> 40
      if len(c_in) = 0
        cfiltr := format( cflt, { nrok, nobdobi, ctypPohybu, ndoklad } )
        pvphead_pk->( ads_setAof(cfiltr)                                    , ;
                      dbgoTop()                                             , ;
                      dbeval( { || c_in += str(pvphead_pk->ndoklad) +',' } ), ;
                      ads_clearAof()                                          )
      endif


      if len(c_in) <> 0
        c_in := subStr ( c_in, 1, len(c_in)-1 )
        c_in := strTran( c_in, ' ', '' )

        stmt += " and ndoklad IN (" +c_in +")"

        cStatement := strTran( stmt      , '%yyyy', str(nrok   ,4))
        cStatement := strTran( cStatement, '%mm'  , str(nobdobi,2))
        cStatement := strTran( cStatement, '%pp'  , ctypPohybu    )
        stmt       := cStatement

        for x := 1 to len(pa_files) step 1
          cStatement := strTran( stmt, '%file', pa_files[x] )
          oStatement := AdsStatement():New(cStatement, oSession_data)

          if oStatement:LastError > 0
          *  return .f.
          else
            oStatement:Execute( 'test', .f. )
            oStatement:Close()
          endif

          (pa_files[x])->(dbUnlock(), dbCommit())
        next
      endif
    endif
  endif
return .t.

*
** položka z pvpTerm - pøíjem, výdej, pøevod
static function skl_pvpitem_from_pvpTerm()
  local  nrec_Term := pvpitemWW->nrec_Term

  pvpTerm->( dbgoTo( nrec_Term ))

  if pvpitemWW->_delRec = '9'
    pvpTerm ->nmnoz_Pln -= pvpitemWW->nmnozD_org

  else
    pvpTerm ->nmnoz_Pln += (pvpitemWW->nmnozDokl1 -pvpitemWW->nmnozD_org)

  endif

  pvpTerm->nstav_pln  := if( pvpTerm->nmnoz_pln = 0                  , 0, ;
                         if( pvpTerm->nmnoz_pln = pvpTerm->nmnozDokl1, 2, 1 ))
  pvpTerm->dzmenaZazn := date()

  ctext   := 'mnoz_pln = ' +str( pvpitemWW->nmnozDokl1) +' -> pvp_doklad = ' +str( pvpheadW->ndoklad )
  mh_wrtZmena( 'pvpTerm',,, ctext )

return .t.

*
** položka z objednávek vystavených  - objVysit - pøíjem
static function skl_pvpItem_from_objVysit( nKEY )
  local  nrec_OBVhd := pvpitemWW->nrec_OBVhd, ;
         nrec_OBVit := pvpItemWW->nrec_OBVit
  *
  local  nmnozPRdod, nmnozPLdod := 0, cky_objVysit


  if nrec_OBVhd <> 0 .and. nrec_OBVit <> 0
    objVyshd->( dbgoTo( nrec_OBVhd ))
    objVysit->( dbgoTo( nrec_OBVit ))

    if pvpItemww->_delRec = '9'
      nmnozPRdod := pvpitemww->nmnozDokl1

      objVysit->nmnozPRdod -= nmnozPRdod               // množství pøijaté od dodavatele
      objVysit->nmnozPOdod -= nmnozPRdod               // množství potvrzené  dodavatelem
      objVysit->nmnozPLdod -= nmnozPRdod               // množství plnìní     dodavatelem
    else
      nmnozPRdod := ( pvpitemww->nmnozDokl1 -pvpitemww->nmnozD_org )

      objVysit->ddatPRdod  := pvpItemww->ddatPvp       // datum pøíjmu
      objVysit->ncenNAPdod := pvpItemww->ncenNAPdod    // nákupní cena na pøíjemce

      objVysit->nmnozPRdod += nmnozPRdod               // množství pøijaté od dodavatele
      objVysit->nmnozPOdod += nmnozPRdod               // množství potvrzené  dodavatelem
      objVysit->nmnozPLdod += nmnozPRdod               // množství plnìní     dodavatelem
    endif

    * nesmíme jít do mínusu, ale tohle je jen berlièka, mìlo by to hlídat WDS a postValidate
    objVysit->nmnozPRdod := max( objVysit->nmnozPRdod, 0 )
    objVysit->nmnozPOdod := max( objVysit->nmnozPOdod, 0 )
    objVysit->nmnozPLdod := max( objVysit->nmnozPLdod, 0 )

    objVysit->ddatPRdod  := if( objVysit->nmnozPRdod = 0, ctod('  .  .  '), pvpItemww->ddatPvp )

    cky_objVysit := strZero(objVysit->ncisFirmy,5) +upper(objVysit->ccisObj)

    objVysit->( ordSetFocus( 'OBJVYSI1' )                          , ;
                dbsetScope(SCOPE_BOTH, cky_objVysit)               , ;
                dbeval( { || nmnozPLdod += objVysit->nmnozPLdod } ), ;
                dbclearScope()                                       )

    objVyshd->nmnozPLdod  := nmnozPLdod
  endif
return nil


*
** položka z objednávek pøijatých objitem - výdej
static function skl_pvpitem_from_objitem()
  local  nrec_OBPhd := pvpitemWW->nrec_OBPhd, ;
         nrec_OBPit := pvpItemWW->nrec_OBPit
*
  local  nkarta     := pvpHeadW->nkarta
  local  nkey, lmnozVPint := .f.
  local  cky  := upper(pvpitemWW->ccisSklad) +upper(pvpitemWW->csklPOL)
  local  is_274_or_305 := .f.

  * odepisuje stav objednávky pouze pro tyto karty
  if ascan( { 253,274,293,305 }, nkarta) = 0
    return .t.
  endif

  if nkarta = 274 .or. nkarta = 305
    is_274_or_305 := .t.
  endif

  if nrec_OBPhd <> 0 .and. nrec_OBPit <> 0
    objHead->( dbgoTo( nrec_OBPhd ))
    objItem->( dbgoTo( nrec_OBPit ))

    do case
    case ( pvpitemWW->_delRec = '9' ) ; nkey :=  xbeK_DEL
    case ( pvpitemWW->_nrecOr = 0   ) ; nkey :=  xbeK_INS
    otherwise                         ; nkey :=  xbeK_ENTER
    endcase

    drgDBMS:open('nakPol' )
    if nakPOL->( dbSeek( cky,,'NAKPOL3'))
      cKodTPV := UPPER( ALLTRIM( NakPOL->cKodTPV))
      lMnozVpInt := ( cKodTPV $ 'PR')
    endif

    Do Case
    Case nKey == xbeK_ENTER
        If PVPItem->nMnozPoODB < PVPItemWW->nMnozPrDod
           ObjItem->nMnozNeODB -= PVPItemWW->nMnozPrDod - PVPItem->nMnozPoODB
           ObjItem->nMnozNeODB := MAX( 0, ObjItem->nMnozNeODB )
        EndIf
        nHLP := PVPItemWW->nMnozPrDod - PVPItem->nMnozReODB
        IF lMnozVpInt .AND. nKARTA == 274
          ObjItem->nMnozVpInt := MAX( 0, PVPItem->nMnozVpInt - If( nHLP > 0, nHLP, 0))
        ELSE
          ObjItem->nMnozKoDod := MAX( 0, PVPItem->nMnozKobje - If( nHLP > 0, nHLP, 0))
        ENDIF
        IF  PVPItemWW->nMnozPrDod < 0 .AND. PVPItem->nMnozPrDOD < 0
          * neaktualizuj nMnozReODB
        ELSEIF PVPItemWW->nMnozPrDod < 0 .AND. PVPItem->nMnozPrDOD > 0
          ObjItem->nMnozReODB := MAX( 0, PVPItemWW->nMnozReODB )
        ELSE
          ObjItem->nMnozReODB := MAX( 0, PVPItemWW->nMnozReODB - PVPItemWW->nMnozPrDod )
        ENDIF
        nNesplneno := ObjItem->nMnozObODB - PVPItem->nMnozVyObj + ObjItem->nMnozPlODB

        * Množství vykrývající obj.pøijatou
        PVPItem->nMnozVyObj := If( PVPItemWW->nMnozPrDod > nNesplneno,;
                                   nNesplneno, PVPItemWW->nMnozPrDod )
        ObjItem->nMnozPlODB += IF( is_274_or_305,;
                                   PVPItemWW->nMnozPrDOD - PVPItem->nMnozPrDOD,;
                                   PVPItemWW->nMnozVyObj - PVPItem->nMnozVyObj )

        ObjHead->nMnozPlODB += IF( is_274_or_305,;
                                   PVPItemWW->nMnozPrDOD - PVPItem->nMnozPrDOD,;
                                   PVPItemWW->nMnozVyObj - PVPItem->nMnozVyObj )
        ObjHead->cPokrObj := If( ObjHead->nMnozObODB > ObjHead->nMnozPlODB, 'C', 'V' )

     Case nKey == xbeK_DEL

        IF( PVPItem->nMnozPrDod < 0, NIL, ObjItem->nMnozReODB := PVPItem->nMnozReODB )
        ObjItem->nMnozPlODB -= IF( is_274_or_305, PVPItem->nMnozPrDOD, PVPItem->nMnozVyObj )
        ObjItem->nMnozNeODB := ObjItem->nMnozObODB - ObjItem->nMnozPoODB
        IF( lMnozVpInt, ObjItem->nMnozVpInt := PVPItem->nMnozVpInt,;
                        ObjItem->nMnozKoDod := PVPItem->nMnozKobje )
        *
        ObjHead->nMnozPlODB -= IF( is_274_or_305, PVPItem->nMnozPrDOD, PVPItem->nMnozVyObj )
        ObjHead->cPokrObj   := If( ObjHead->nMnozObODB > ObjHead->nMnozPlODB, 'C', 'V' )

     Case nKey == xbeK_INS
        If ObjItem->nMnozPoODB < PVPItemWW->nMnozPrDod
           ObjItem->nMnozNeODB -= PVPItemWW->nMnozPrDod - ObjItem->nMnozPoODB
           ObjItem->nMnozNeODB := MAX( 0, ObjItem->nMnozNeODB )
        EndIf
        nHLP := PVPItemWW->nMnozPrDod - ObjItem->nMnozReODB
        IF lMnozVpInt
          ObjItem->nMnozVpInt -= If( nHLP > 0, nHLP, 0)
          ObjItem->nMnozVpInt := MAX( 0, ObjItem->nMnozVpInt )
        ELSE
          ObjItem->nMnozKoDod -= If( nHLP > 0, nHLP, 0)
          ObjItem->nMnozKoDod := MAX( 0, ObjItem->nMnozKoDod )
        ENDIF

        IF PVPItemWW->nMnozPrDod < 0
          * neaktualizuj nMnozReODB
        ELSE
          ObjItem->nMnozReODB -= PVPItemWW->nMnozPrDod
          ObjItem->nMnozReODB := MAX( 0, ObjItem->nMnozReODB )
        ENDIF
        nNesplneno := ObjItem->nMnozObODB - ObjItem->nMnozPlODB

        * Množství vykrývající obj.pøijatou
        PVPItem->nMnozVyObj := If( PVPItemWW->nMnozPrDod > nNesplneno,;
                                   nNesplneno, PVPItemWW->nMnozPrDod )
        objItem->nmnozPLodb += IF( is_274_or_305, PVPItemWW->nMnozPrDod, PVPItemWW->nMnozVyObj )
        *
        ObjHead->nMnozPlODB += IF( is_274_or_305, PVPItemWW->nMnozPrDod, PVPItemWW->nMnozVyObj )
        ObjHead->cPokrObj := If( ObjHead->nMnozObODB > ObjHead->nMnozPlODB, 'C', 'V' )
    EndCase

    objitem->nmnoz_Svyd := objitem->nmnozPlOdb
    objitem->nstav_Svyd := if(objitem->nmnoz_Svyd = 0                  , 0, ;
                           if(objitem->nmnoz_Svyd < objitem->nmnozObOdb, 1, ;
                           if(objitem->nmnoz_Svyd > objitem->nmnozObOdb, 3, 2)))

  endif
return .t.

*
** položka z vyrPol - pøíjem, výdej
static function skl_pvpitem_from_vyrPol()
  local  nrec_VYRpo := pvpitemWW->nrec_VYRpo
  local  ntypPvp    := pvpHeadW->ntypPvp

  vyrPol->( dbgoTo( nrec_VYRpo))

  if ntypPvp = 1  // pøíjem

    if pvpitemWW->_delRec = '9'
       vyrPol->nmnSKLpri -= pvpitemWW->nmnozD_org
     else
       vyrPol->nmnSKLpri += (pvpitemWW->nmnozDokl1 -pvpitemWW->nmnozD_org)
     endif
  else            // výdej

    if pvpitemWW->_delRec = '9'
       vyrPol->nmnSKLvyd -= pvpitemWW->nmnozD_org
     else
       vyrPol->nmnSKLvyd += (pvpitemWW->nmnozDokl1 -pvpitemWW->nmnozD_org)
     endif
  endif

return .t.


*
** generujeme druhou stranu pro pøevod tj. pøíjmové doklady a položky
static function skl_pvphead_PRE305_prij(cskladKAm)
  local  cky      := upper(pvphead->culoha) +upper(pvphead->ctypdoklad) +upper(pvpHead->ctyppohybu)
  local  nkarta   := pvphead->nkarta
  local  cisSklad := pvphead->ccisSklad
  *
  pvphead ->( dbcommit() )
  c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

  if .not. empty(cky := c_typpoh->csubpohyb)
    if c_typpoh->(dbseek(cky,,'C_TYPPOH06'))

      mh_copyFld( 'pvphead', 'pvpheadW', .t. )

      pvpHeadW ->csubTask    := c_typPoh->ctask
      pvpHeadW ->ctypDoklad  := c_typPoh->ctypDoklad
      pvpHeadW ->ctypPohybu  := c_typPoh->ctypPohybu
      pvpHeadW ->ntypPvp     := c_typPoh->ntypPvp
      pvpHeadW ->ncislPoh    := val(c_typPoh->ctypPohybu)
      pvpheadW ->ntypPohyb   := c_typPoh->ntypPohyb
      pvpHeadW ->ntypPoh     := c_typPoh->ntypPvp
      pvpHeadW ->nkarta      := val ( right( allTrim(c_typPoh->ctypDoklad), 3))

      pvpheadW->ccisSklad   := cSkladKAM
      pvpheadW->ndokladVYD  := pvphead->ndoklad
*      pvpheadW->ddatPVP     := date()

      pvpheadW->ndoklad     := newDoklad_skl( nkarta, cskladKAm )
      mh_copyFld( 'pvpheadW', 'pvphead', .t. )
    endif
  endif
return .t.


static function skl_pvpitem_PRE305_prij()
  local  cky := upper(pvpitem->cskladKAm) +upper(pvpitem->csklPolKAm)

  mh_copyFld( 'pvphead', 'pvpitemWW', .t. )
  mh_copyFld( 'pvpitem', 'pvpitemWW'      )

    pvpitemWW->ndoklad    := pvphead->ndoklad
    pvpitemWW->ctypDoklad := pvpHead->ctypDoklad
    pvpitemWW->ctypPohybu := pvpHead->ctypPohybu
    pvpitemWW->ntypPvp    := pvpHead->ntypPvp
    pvpitemWW->ncislPoh   := pvphead->ncislPoh
    pvpitemWW->ntypPoh    := pvphead->ntypPoh

    cenZboz->( dbseek( cky,,'CENIK03') )
    pvpitemWW->cSklPol    := CenZboz->cSklPol
    pvpitemWW->cNazZBO    := CenZboz->cNazZBO
    pvpitemWW->nKlicDPH   := CenZboz->nKlicDPH
    pvpitemWW->nUcetSkup  := CenZboz->nUcetSkup
    pvpitemWW->cUcetSkup  := PADR( CenZboz->nUcetSkup, 10)
    pvpitemWW->cZkratMENY := CenZboz->cZkratMENY
    pvpitemWW->cZkratJedn := CenZboz->cZkratJedn
    pvpitemWW->nKlicNAZ   := CenZboz ->nKlicNaz
    pvpitemWW->nZboziKAT  := CenZboz ->nZboziKAT
    pvpitemWW->cPolCen    := CenZboz->cPolCen
    pvpitemWW->cTypSKP    := CenZboz->cTypSKP
    pvpitemWW->nRec_CenZb := CenZboz ->( RecNo())

    pvpitemWW->ntypPoh     := 1
    pvpitemWW->cCisSklad   := pvpitem->cSkladKAm
    pvpitemWW->cSklPol     := pvpitem->cSklPolKAm
    pvpitemWW->nUcetSkup   := pvpitem->nUcetSkKAm
    pvpitemWW->cUcetSkup   := PADR( pvpitem->nUcetSkKAm, 10)

    pvpitemWW->cSkladKAM   := pvpitem->cCisSklad   // sklad   odkud byla pøevedena
    pvpitemWW->cSklPolKAM  := pvpitem->cSklPol
    pvpitemWW->nOrdItKAM   := pvpitem->nOrdItem
    pvpitemWW->nUcetSkKAM  := pvpitem->nUcetSkup
    pvpitemWW->cUcetSkKAM  := pvpitem->cUcetSkup
    pvpitemWW->nPVPHEAD    := isNUll(pvpHead->sID,0)
    pvpitemWW->ndokladVYD  := pvpitem->ndoklad

    mh_copyFld( 'pvpitemWW', 'pvpitem', .t. )
return .t.


static function skl_pvpitem_205_DIm()
  local  invCISdim := pvpitemWW->ninvCISdim
  local  cky       := upper(pvpitemWW->ccisSklad) +upper(pvpitemWW->csklPol)

  if .not. empty(invCISdim)
    if .not. msDim->( dbseek( invCISdim,, 'DIM1'))
      cenZboz->( dbseek( cky,,'CENIK03') )

      mh_copyFld( 'pvpitemWW', 'msDIm', .t. )
        msDIm->ntypDim    := 1
        msDIm->cnazevDim  := cenZboz->cnazZbo
        msDIm->ddatZARdim := date()
        msDIm->npocKUSdim := pvpitemWW->nmnozPRdod
        msDIm->czkratJedn := cenZboz->czkratJedn
        msDIm->ncisloPvp  := pvpheadW->ndoklad
        msDIm->ncenJEDdim := cenZboz->ncenaSzbo
        msDIm->ncenCELdim := cenZboz->ncenaSzbo * pvpitemWW->nmnozPRdod

      msDIm->( dbCommit(), dbUnLock())
    endif
  endif
return .t.

*
** zrušení pohybového dokladu pvpHead/ it / etc.
function skl_pvphead_del(odialog)
  local mainOk := .f.

  pvpheadW ->_delrec := '9'
  pvpitemWW->(AdsSetOrder(0),dbgotop(),dbeval({|| pvpitemWW->_delrec := '9'}))

  pvpheadW ->( dbcommit())
  pvpitemWW->( dbcommit())

// TRANSAKCE
  drgDBMS:open( 'pvpTerm'  )
  drgDBMS:open( 'objVyshd' )
  drgDBMS:open( 'objVysit' )
  drgDBMS:open( 'objHead'  )
  drgDBMS:open( 'objItem'  )
  drgDBMS:open( 'vyrZak'   )
  drgDBMS:open( 'vyrPol'   )

  drgDBMS:open( 'dodZboz'  )
  drgDBMS:open( 'firmy'    )

  mainOk := skl_pvphead_wrt_inTrans(odialog)
return mainOk