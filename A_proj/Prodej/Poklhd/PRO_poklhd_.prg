#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "dbstruct.ch"


static b_pvphead, b_pvpitem


function pro_poklhd_cpy(oDialog, newhd)
  local  nKy, inScope
  *
  local  lNEWrec   := If( IsNull(oDialog), If( IsNull(newhd), .F., newhd), oDialog:lNEWrec)
  local  czkrTypUhr, nkasa

  ** tmp **
  drgDBMS:open('poklhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('poklitw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  ** výdejky **
  drgDBMS:open('pvpheadw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('pvpitemw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  if .not. lNEWrec
    nKy := POKLHD->nCISFAK
    mh_COPYFLD('poklhd', 'poklhdw', .t., .t.)

    if .not. (inScope := poklit->(dbscope()))
      poklit->(AdsSetOrder(1),dbsetscope(SCOPE_BOTH, strzero(poklhd->ncisfak,10)), dbgotop())
    endif

    poklit->( DbEval( { || mh_COPYFLD('poklit', 'poklitw', .t., .t.) }), DbGoTop() )
    *
    pvphead->(AdsSetOrder('PVPHEAD11'), dbSetScope(SCOPE_BOTH,poklhd->ndoklad), dbgotop(), ;
              dbeval( {|| mh_copyfld('pvphead','pvpheadw', .t., .t.) })                    )

    pvpitem->(AdsSetOrder('PVPITEM06'), dbSetScope(SCOPE_BOTH,poklhd->ndoklad), dbgotop(), ;
              dbeval( {||mh_copyfld('pvpitem','pvpitemw', .t., .t.) })                     )

    if( .not. inSCope, poklit->(dbclearscope()), nil)
  else
    poklhdw->(dbappend())

    if .not. c_typuhr->( ads_locate("lisRegPok = .T. .and. lisRegDef = .T."))
       c_typuhr->( ads_locate("lisRegPok = .T."))
    endif
    czkrTypUhr := c_typuhr->czkrTypUhr

    if( .not. c_bankuc->(dbseek(.t.,,'bankuc2')), c_bankuc->(dbgotop()),nil)

    nkasa      := SYSCONFIG('PRODEJ:nCISREGPOK')

    pokladms->( dbseek( nkasa,, 'POKLADM1'))
    if .not. empty(pokladms->czkrTypurp)
      if c_typuhr->( dbseek( upper(pokladms->czkrTypurp),,'TYPUHR1'))
        czkrTypUhr := c_typuhr->czkrTypUhr
      endif
    endif

    oDialog:copyfldto_w('pokladms','poklhdw')

   ( poklhdw ->cULOHA     := "E"                                     , ;
     poklhdw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI                   , ;
     poklhdw ->nROK       := uctOBDOBI:FIN:NROK                      , ;
     poklhdw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI                   , ;
     poklhdw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN                , ;
     poklhdw ->nKODZAOKRD := SYSCONFIG('FINANCE:nROUNDDPH')          , ;
     poklhdw ->cZKRATMENY := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
     poklhdw ->dSPLATFAK  := DATE() +SYSCONFIG( 'FINANCE:nSPLATNOST'), ;
     poklhdw ->dVYSTFAK   := DATE()                                  , ;
     poklhdw ->dPOVINFAK  := DATE()                                  , ;
     poklhdw ->cBANK_UCT  := C_BANKUC ->cBANK_UCT                    , ;
     poklhdw ->cDENIK     := SYSCONFIG('PRODEJ:cDENIKREGP')          , ;
     poklhdw ->cDENIK_PUC := SYSCONFIG('FINANCE:cDENIKPUC')          , ;
     poklhdw ->nKURZAHMEN := 1                                       , ;
     poklhdw ->nMNOZPREP  := 1                                       , ;
     poklhdw ->cJMENOVYS  := logOsoba                                , ;
     poklhdw ->nCISFAK    := fin_range_key('POKLHD')[2]              , ;
     poklhdw ->cVARSYM    := ALLTRIM( STR(poklhdw ->nCISFAK))        , ;
     poklhdw ->cZKRATMENZ := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
     poklhdw ->cVYPSAZDAN := SYSCONFIG('PRODEJ:cVYPSAZDPH')          , ;
     poklhdw ->nkasa      := SYSCONFIG('PRODEJ:nCISREGPOK')            )

*-     poklhdw->ctyppohybu  := sysconfig('finance:ctyppohFAV')
     poklhdw->czkrtypuhr  := czkrTypUhr
     poklhdW->lisHotov    := (odialog:on_isHotov = '1')
     poklhdw->nkodzaokr   := c_typuhr->nkodzaokr
     poklhdw->nzaplaceno  := 0
     poklhdw->nprocDan_1  := SeekSazDPH(1)
     poklhdw->nprocDan_2  := SeekSazDPH(2)
     poklhdw->nprocDan_3  := SeekSazDPH(3)
     poklhdW->cuUid_Zpra  := UuidToChar( UuidCreate() )
     poklhdw->npokladEET  := c_typUhr->npokladEET

     if .not. IsNull(newhd)
       poklhdw->ctask      := 'PRO'
       poklhdw->ctypdoklad := 'PRO_REGPO'
       poklhdw->ctyppohybu := 'PRODEJRP'
       poklhdw->nfinTyp    := 1

       poklhdw->(dbCommit())
     endif
   endif

  fin_vykdph_cpy('poklhdw')
return nil

*
** uložení paragonu z PRODEJE v transakci **************************************
function PRO_poklhd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := pro_poklhd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone



function pro_poklhd_wrt(odialog,newhd)
  local  anPoi := {}, anPvh   := {}, anPvi   := {}, anLik := {}, aPvh := {}
  *
  local                nPvh_o :=  0, anPvi_o := {}
  *
  local  uctLikv, nrecor, nrecpv, lastPvp := 0, newPvp := 0, pos, key
  *
  local  mainOk, ispvp, cky
  local  lnewrec   := If( IsNull(oDialog), If( IsNull(newhd), .F., newhd), oDialog:lNEWrec)
  local  on_vykDph := if( isNull(oDialog), '1', oDialog:on_vykDph )

   *
  ** tento test je strašná ptákovina v CFG je nastaven perametr 0 - nehrá si na DPH, 1 - hrá si na DPH
  ** ale, tento parametr je možné nastavit až na uživatele, takže, pokud by nìkdo opravoval doklad
  ** s jiným nastavením, musíme akceptovat pùvodní uložení dokladu s DPH/ bez DPH
  *
  mainOk  := fin_vykdph_rlo('POKLHDw')
  ispvp   := pro_poklhd_ispvp()
  *
  ** pøi opravì nestojí na pøíslušném záznmu c_typPoh
  cky     := upper(poklhdW->culoha) +upper(poklhdW->ctypdoklad) +upper(poklhdW->ctyppohybu)
  if(select('c_typpoh') = 0, drgDBms:open('c_typpoh'), nil)
  c_typpoh->(dbseek(cky,,'C_TYPPOH05'))


  uctLikv := uct_likvidace():new(upper(poklhdw->culoha) +upper(poklhdw->ctypdoklad),.T.)
  anLik   := aclone(uctLikv:ucetpol_rlo)

  poklitw->(AdsSetOrder(0), dbgotop(), ;
            dbeval({|| if(poklitw->_nrecor <> 0, aadd(anPoi,poklitw->_nrecor), nil) }))

  pvpheadw ->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| pro_poklhd_rlo(anPvh,anLik) }))

  pvpitemw ->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| if(pvpitemw ->_nrecor <> 0, aadd(anPvi,pvpitemw ->_nrecor), nil) }))

  *
  if(ispvp, pro_poklhd_pvp(), nil)
  *

  if .not. lnewrec
    poklhd->(dbgoto(poklhdw->_nrecor))
    mainOk := ( mainOk                      .and. ;
                poklhd  ->(sx_rlock())      .and. ;
                poklit  ->(sx_rlock(anPoi)) .and. ;
                pvp_head->(sx_rlock(anPvh)) .and. ;
                pvp_item->(sx_rlock(anPvi)) .and. ;
                ucetpol ->(sx_rlock(anLik))       )
  endif


  poklitw->(AdsSetOrder(0), dbgotop())

  if mainOk
    if poklhdw->_delrec <> '9'
      if lnewrec     //  JT        odialog:lnewrec
        poklhdw->ndoklad    := poklhdw->ncisfak
        poklhdw->cvarSym    := allTrim( str(poklhdw->ncisfak))
        poklhdw->ncenfakcel := poklhdw->ncenzakcel
        poklhdw->ncenfazcel := poklhdw->ncenzahcel
      endif

      poklhdw->ncenfakcel := poklhdw->ncenzakcel
      poklhdw->ncenfazcel := poklhdw->ncenzahcel

      mh_copyfld('poklhdw','poklhd',lnewRec, .f.)
    endif

    do while .not. poklitw->(eof())
      anPvh_o := {}
      anPvi_o := {}
      *
      ** v nabídce doplòující je možné zmìnit tyto údaje, musí se dostat i do položek
      poklitW->cobdobi   := poklhdW->cobdobi
      poklitW->nrok      := poklhdw->nrok
      poklitW->nobdobi   := poklhdw->nobdobi
      poklitW->dsplatFak := poklhdW->dsplatFak
      poklitW->dvystFak  := poklhdW->dvystFak
      **
      *
      if poklitw->_nrecpvph <> 0 .and. poklitw->_delrec <> '9'
        if ascan(aPvh,poklitw->_nrecpvph) = 0
          pvpheadw->(dbgoto(poklitw->_nrecpvph))
          if(nrecpv := pvpheadw->_nrecor) = 0
            newPvp := fin_range_key('PVPHEAD')[2]
            if(newPvp = lastPvp, newPvp++, nil )

            pvpheadw->ndoklad   := newPvp
            pvpheadw->ncislodl  := poklhd  ->ndoklad
            pvpheadw->ncislopvp := pvpheadw->ndoklad
          else
            pvp_head->(dbgoto(nrecpv))
          endif

          mh_copyfld('pvpheadw','pvp_head',(nrecpv=0), .f.)

          if nrecpv = 0
*             newPvp := fin_range_key('PVPHEAD')[2]
*             pvp_head->ndoklad   := newPvp
*             pvp_head->ncislopvp := newPvp

             pvpheadw->ndoklad   := pvp_head->ndoklad
             pvpheadw->ncislopvp := pvp_head->ncislopvp
          endif

          * pro likvidace nákladù
          nPvh_o            := pvp_head->(recNo())
          pvpheadw->_nrecor := pvp_head->(recNo())

          aadd(aPvh   ,poklitw->_nrecpvph)

          if(pos := ascan(anPvh,pvpheadw ->_nrecor)) <> 0
            (adel(anPvh,pos),asize(anPvh,len(anPvh)-1))
          endif

          lastPvp := pvpheadW->ndoklad
        endif
      endif

      if((nrecor := poklitw->_nrecor) = 0, nil, poklit->(dbgoto(nrecor)))

      if   poklitw->_delrec = '9'  ;  if(nrecpv := poklitw->_nrecpvpi) <> 0
                                        pvpitemw->(dbgoto(nrecpv))
                                        pvp_item->(dbgoto(pvpitemw->_nrecpvi))

                                        pvpheadw->(dbgoto(poklitw->_nrecpvph))
                                        pvp_head->(dbgoto(pvpheadw ->_nrecor))

                                        pvp_item->(dbdelete())

                                        if(pos := ascan(anPvi,pvpitemw->_nrecpvi)) <> 0
                                          aRemove(anPvi, pos)
                                        endif
                                      endif

                                      if( nrecor = 0, nil, poklit->(dbdelete()) )

      else                         ;  if poklitw->_nrecpvpi <> 0
                                        pvpheadw->(dbgoto(poklitw->_nrecpvph))
                                        pvpitemw->(dbgoto(poklitw->_nrecpvpi))

                                        pvpitemw->ndoklad   := pvpheadw->ndoklad
                                        pvpitemw->ncisfak   := poklhd  ->ndoklad
                                        pvpitemw->ncislopvp := pvpheadw->ndoklad
                                        if((nrecpv := pvpitemw->_nrecpvi) = 0, nil, pvp_item->(dbgoto(nrecpv)))
                                        pvp_head->(dbgoto(pvpheadw ->_nrecor))

                                        key := if(nrecpv = 0, xbeK_INS, xbeK_ENTER)

                                        if((nrecpv := pvpitemw->_nrecor) = 0, nil, pvp_item->(dbgoto(nrecpv)))
                                        mh_copyfld('pvpitemw','pvp_item',(nrecpv=0), .f.)

                                        * pro likvidaci nákladù
                                        aadd( anPvi_o, pvp_item->(recNo()) )
                                        pvpitemw->_nrecor := pvp_item->(recNo())

                                        poklitw->ncislopvp := pvpheadw->ndoklad
                                        *
                                        if(pos := ascan(anPvi,pvpitemw ->_nrecor)) <> 0
                                          (adel(anPvi,pos),asize(anPvi,len(anPvi)-1))
                                        endif

                                      endif
                                      *
                                      mh_copyfld('poklitw','poklit',(nrecor=0), .f.)
                                      poklit->ndoklad := poklhd->ndoklad

      endif

      poklitw->(dbskip())
    enddo
    *
    ** likvidace tržeb
    if( poklhdw->_delrec = '9')  ;  uctLikv:ucetpol_del()
                                    fin_vykdph_wrt(NIL,.t.,'POKLHD')
                                    poklhd->(sx_rlock(),dbdelete())
    else                         ;  fin_vykdph_wrt(NIL,.f.,'POKLHD')
                                    uctLikv:ucetpol_wrt()
    endif

    *
    ** uložení pvp + liknidace nákladù
    pvpheadw->(dbcommit(),dbgotop())
    pvpitemw->(dbcommit(),dbgotop())
    uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.,,'pvpheadw')

    if poklhdw->_delrec = '9'
       uctLikv:ucetpol_del()

       pvpheadw->(dbgotop(),dbeval({||pvp_head->(dbgoto(pvpheadw->_nrecor),dbdelete()) }))
    else
      poklhd->ncislopvp := lastPvp
      aeval(anPvh, {|x| pvp_head->(dbgoto(x),dbdelete()) })
      aeval(anPvi, {|x| pvp_item->(dbgoto(x),dbdelete()) })
      uctLikv:ucetpol_wrt()

      * tady musíme pøepsat nKlikvid a nZlikvid
      if nPvh_o <> 0
        pvp_head->( dbGoto( nPvh_o ))
        if( pvp_head->(sx_rlock()) .and. pvp_item->(sx_rlock(anPvi_o)) )
          pvp_head->nKlikvid := pvpheadw->nKlikvid
          pvp_head->nZlikvid := pvpheadw->nZlikvid

          pvpitemw->( dbGotop())
          do while .not. pvpitemw->(eof())
            if pvpitemw->_delrec <> '9'   // pvpitemw->_nrecor <> 0
              pvp_item->(dbGoto( pvpitemw->_nrecor ))

              pvp_item->nKlikvid := pvpitemw->nKlikvid
              pvp_item->nZlikvid := pvpitemw->nZlikvid
            endif

            pvpitemw->(dbskip())
          enddo
        endif
      endif
      *
    endif
  else
    drgMsg(drgNLS:msg('Nelze modifikovat PARAGON, blokováno uživatelem ...'),,odialog)
  endif

  poklhd->( dbunlock(), dbcommit())
   poklit->( dbunlock() , dbcommit())
    pvp_head->( dbunlock(), dbcommit())
     pvp_item->( dbunlock(), dbcommit())
      ucetpol ->( dbunlock(), dbcommit())
return mainOk

*
** zrušení paragonu **
function pro_poklhd_del(odialog)
  local  mainOk

  poklhdw->_delrec := '9'
  poklitw->(poklitw->(AdsSetOrder(0),dbgotop()), dbeval({|| poklitw->_delrec := '9'}))
  mainOk := pro_poklhd_wrt(odialog)
return mainOk

*
**
static function pro_poklhd_ispvp()
  local lenBuff := 40960, buffer := space(lenBuff)
  local sname   := drgINI:dir_USERfitm +'mmacro', fields
  local ok      := .f.

  * napozicovat se na záznam typdokl *
  if(select('typdokl') = 0, drgDBMS:open('typdokl'), nil)

  b_pvphead := b_pvpitem := nil

  if typdokl->(dbseek(upper(poklhdw->culoha) +upper(poklhdw->ctypdoklad),,'TYPDOKL02'))

    * pokud je v typdokl mmacro tak ho zpøístupníme *
    if .not. empty(typdokl->mmacro)
      memowrit(sname,typdokl->mmacro)

      * naèteme ze sekce UsedIdentifiers Fields *
      GetPrivateProfileSectionA('pvpheadw', @buffer, lenBuff, sname)
      fields    := substr(buffer,1,len(trim(buffer))-1)
      fields    := strtran(fields,chr(0),',')
      b_pvphead := substr(fields,1,len(fields) -1)

      GetPrivateProfileSectionA('pvpitemw', @buffer, lenBuff, sname)
      fields    := substr(buffer,1,len(trim(buffer))-1)
      fields    := strtran(fields,chr(0),',')
      b_pvpitem := substr(fields,1,len(fields) -1)

      ferase(sname)
      ok := (.not. empty(b_pvphead) .and. .not. empty(b_pvpitem))
    endif
  endif
return ok


static function pro_poklhd_pvp()
  local a_skl := {}, x

  poklitw->(AdsSetOrder(2), dbSetSCope(SCOPE_BOTH, 'C'), dbgotop(), ;
            dbeval({|| if(ascan(a_skl, poklitw->ccissklad) = 0, aadd(a_skl, poklitw->ccissklad), nil) }) )

  pvpheadw->(dbgotop())
  pvpitemw->(dbgotop())

  for x := 1 to len(a_skl) step 1
    poklitw->(dbsetscope(SCOPE_BOTH,'C' +a_skl[x]),dbgotop())
    pro_poklhd_pvhd()

    poklitw->( dbeval( { || pro_poklhd_pvit() }, ;
                       { || .not. (poklitw->_nrecor = 0 .and. poklitw->_delrec = '9') } ))

    pvpheadw->(dbskip())
  next
return nil


static function pro_poklhd_pvhd(ndoklad)
  if   pvpheadw->(eof())  ; pvpheadw->(dbappend())
                            ndoklad := 0
  else                    ; ndoklad := pvpheadw->ndoklad
  endif

  Eval( &("{||" + b_pvphead + "}"))
  pvpheadw ->ndoklad  := ndoklad
  pvpheadw->ncenadokl := 0
  pvpheadw->ncenazakl := 0
  pvpheadw->ccissklad := poklitw ->ccissklad
  poklitw ->_nrecpvph := pvpheadw->(recno())

  pvpheadw->(dbCommit())
return nil


static function pro_poklhd_pvit()
  local  ky, is_inPvpi

  if( pvpitemw->(eof()), pvpitemw->(dbappend()), nil)

  objitem->(dbseek(upper(poklitw->ccislobint) +strzero(poklitw->ncislpolob,5),,'OBJITEM0'))
  cenzboz->(dbseek(upper(poklitw->ccissklad   +poklitw->csklpol),,'CENIK03'))
  c_dph  ->(dbseek(poklitw->nprocdph,,'C_DPH2'))

  Eval( &("{||" + b_pvpitem + "}"))
  *
  **
  ky        := strZero(pvpitemw->ncisfak,10) +strZero(pvpitemw->norditem,5)
  if( is_inPvpi :=  pvp_item->(dbseek(ky,,'PVPITEM18')) )
     pvpitemw->_nrecpvi := pvp_item->(recNo())
  endif
  *
  ** musíme poktýt i variantu, že zrušil a pak pøidal stejnou položku
  if ( is_inPvpi .and. poklitw->_nrecor <> 0 )
    pvpitemw->_nrecpvi   := pvp_item->(recNo())
    pvpitemw->nmnozPR_or := pvp_item->nmnozPRdod
    pvpitemw->nmnozRE_or := pvp_item->nmnozREodb
    pvpitemw->nmnozZO_or := pvp_item->nmnozZOBJE
    pvpitemw->ncenaCE_or := pvp_item->ncenaCELK
  else
    pvpitemw->_nrecpvi   := 0
    pvpitemw->nmnozPR_or := 0
    pvpitemw->nmnozRE_or := 0
    pvpitemw->nmnozZO_or := 0
    pvpitemw->ncenaCE_or := 0
  endif

  pvpheadw->(dblocate({|| pvpheadw->ccissklad = pvpitemw->ccissklad }))

  if empty(pvpitemw->_delrec)
    pvpheadw->ncenadokl  += pvpitemw->ncenacelk
    pvpheadw->ncenazakl  += pvpitemw->ncenazakl
  endif
  *
  poklitw->ncislopvp := pvpitemw->ndoklad

  poklitw->_nrecpvph := pvpheadw->(recno())
  poklitw->_nrecpvpi := pvpitemw->(recno())
  pvpitemw->(dbCommit(),dbskip())
return nil


*
** pomocná funkce pro zámky ucetpol pro náklady
static function pro_poklhd_rlo(anPvh,anLik)
  local scope := upper(pvpheadw->cdenik) +strzero(pvpheadw->ndoklad,10)

  *
  if(select('ucetpol') = 0, drgDBMS:open('ucetpol'), nil)

  if(pvpheadw ->_nrecor <> 0, aadd(anPvh,pvpheadw ->_nrecor), nil)
  ucetpol->(AdsSetOrder('UCETPOL1')                       , ;
            dbsetscope(SCOPE_BOTH, scope)                 , ;
            dbgotop()                                     , ;
            dbeval({ || aadd(anLik, ucetpol->(recno())) }), ;
            dbclearscope()                                  )
return nil


function OpenKase()
  local cond

  cond := Chr(27)+Chr(112)+Chr(48)+Chr(56)+Chr(56)
  SET DEVICE TO PRINTER
  SET PRINTER TO 'kasaopen.txt' ADDITIVE

  devOut(cond)

  SET DEVICE TO SCREEN

return( nil)