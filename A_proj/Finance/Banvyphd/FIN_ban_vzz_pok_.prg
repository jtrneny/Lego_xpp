#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*

#include "..\Asystem++\Asystem++.ch"


*
** obecná funkce pro uložení stavu úhrad z BANVYPITw / POKLADITw
function FIN_ban_pok_vzz_sum( cky, cfile_iv )
  local  uhrCelFak := uhrcelFaz := kurzRozdf := 0

  if(select('banit_Sum') = 0, drgDBMS:open( 'banvypit',,,,,'banit_Sum'), nil )
  if(select('pokit_Sum') = 0, drgDBMS:open( 'pokladit',,,,,'pokit_Sum'), nil )

  banit_Sum->( ordSetFocus( 'BANKVY_2')     , ;
               dbsetScope( SCOPE_BOTH, cky) , ;
               dbgoTop()                    , ;
               dbeval( { || (uhrCelFak += banit_Sum->nuhrCelFak , ;
                             uhrcelFaz += banit_Sum->nuhrCelFaz , ;
                             kurzRozdf += banit_Sum->nkurzRozdf   ) }))

  pokit_Sum->( ordSetFocus( 'BANKVY_2')     , ;
               dbsetScope( SCOPE_BOTH, cky) , ;
               dbgoTop()                    , ;
               dbeval( { || (uhrCelFak += pokit_Sum->nuhrCelFak , ;
                             uhrcelFaz += pokit_Sum->nuhrCelFaz , ;
                             kurzRozdf += pokit_Sum->nkurzRozdf   ) }))

  (cfile_iv)->nuhrCelFak := uhrCelFak
  (cfile_iv)->nuhrCelFaz := uhrCelFaz
  (cfile_iv)->nkurzRozdf := kurzRozdf
return .t.



*
** class for FIN_ban_vzz_pok_IN ************************************************
class FIN_ban_vzz_pok
  exported:
  method zaklMena, sumColumn, map

  * vld
  method cvarsym_vld, cbank_uct_vld, firmyico_sel

  * import jen pro banku
  var    drgVar_file_imp, cpath_kom, cfile_kom, datUhrZhl

  * ads_customizeAof
  var    ain_file

  inline method init(parent)
     ::parent   := parent

     ::dm       := parent:dm
     ::hd_file  := parent:hd_file
     ::it_file  := parent:it_file
     ::typ_dokl := parent:typ_dokl
     ::ain_file := parent:ain_file
     ::newRec   := .f.
  return

  * hd_crd
  inline access assign method veProspech_hd() var veProspech_hd
    return if(::istuz, (::hd_file)->nprijem, (::hd_file)->nprijemz)

  inline access assign method naVrub_hd()     var naVrub_hd
    return if(::istuz, (::hd_file)->nvydej, (::hd_file)->nvydejz)

  * browCOlumn - 1
  inline access assign method errimp() var errimp
    return if( (::it_file)->nerr_imp = 1, MIS_ICON_ERR, 0 )

  * browColumn _ 2
  inline access assign method treeView() var treeView
  return if( Empty((::it_file) ->mtree_view), 0, Bin2Var((::it_file) ->mtree_view))

  * browColumn _ 4
  inline access assign method cisFaktury() var cisFaktury
    local retVal
    if (Like('3*',(::it_file)->cucet_uct) .and. (::it_file)->ndoklad_iv = 0)
      retVal := '?  ' +Str((::it_file) ->nCISFAK)
    else
      retVal := Str((::it_file) ->nCISFAK)
    endif
  return retVal

  * browColumn _ 7
  inline access assign method veProspech() var veProspech
    local typObratu := (::it_file)->ntypobratu
  return if(typObratu = 1 .and. ::mainItem, if(::istuz, (::it_file)->ncenzakcel, (::it_file)->ncenzahcel), 0)

  * browColumn _ 8
  inline access assign method naVrub() var naVrub
    local typObratu := (::it_file)->ntypobratu
  return if(typObratu = 2 .and. ::mainItem, if(::istuz, (::it_file)->ncenzakcel, (::it_file)->ncenzahcel), 0)

  * browColumn _ 10
  inline access assign method typObratu() var typObratu
  return if((::it_file)->ntypobratu = 1, 304, 305 )

  inline access assign method istuz() var istuz
    local zkrMeny := if(lower(::hd_file) = 'banvyphdw', (::hd_file)->czkratMeny, (::hd_file)->czkratMenz)
  return Equal(::zaklMena(), zkrMeny)

  inline access assign method mainItem() var mainItem
  return ((::it_file)->nsubcount = 0)

  hidden:
    method cvarsym_sel, cvarsym_neu, cvarsym_obr, cvarsym_lik
    var    zaklMena, parent
    var    hd_file, it_file, typ_dokl, newRec, dm
endclass


method FIN_ban_vzz_pok:zaklMena()
  default ::zaklMena to SysConfig('Finance:cZaklMena')
return ::zaklMena


method FIN_ban_vzz_pok:sumColumn()
  local  veProspech := naVrub := likvPol := 0, typObratu, x, value

  banpok_w ->(DbGoTop())
  do while .not. banpok_w ->(Eof())
    if banpok_w->_delrec <> '9'
      typObratu  := banpok_w->ntypobratu
      veProspech += if(typObratu = 1 .and. ::mainItem, if(::istuz, banpok_w->ncenzakcel, banpok_w->ncenzahcel), 0)
      naVrub     += if(typObratu = 2 .and. ::mainItem, if(::istuz, banpok_w->ncenzakcel, banpok_w->ncenzahcel), 0)
      likvPol    += if(::parent:typ_dokl $ 'ban,vzz,uhr', banpok_w->nlikpolbav, banpok_w->nlikpolpok)
    endif
    banpok_w ->(DbSkip())
  enddo

  for x := 7 to 9 step 1
    value := if(x = 7,Str(veProspech),if(x = 8,Str(naVrub),Str(likvPol)))

    ::parent:brow:getColumn(x):Footing:hide()
    ::parent:brow:getColumn(x):Footing:setCell(1,value)
    ::parent:brow:getColumn(x):Footing:show()
  next
return .t.


# xTranslate  .pKEY_p   => SubStr(pa,1,5)
# xTranslate  .pKEY_s   => SubStr(pa,6,2)
# xTranslate  .pKEY_ss  => SubStr(pa,8,2)
*
**
method FIN_ban_vzz_pok:map(runSum)
  local hd_file   := ::parent:hd_file, it_file := ::parent:it_file, typ_dokl := ::parent:typ_dokl
  local recNo     := (it_file) ->(recNo()), sign
  local aitems    := {}, pa, items, cntp, cnts, trees
  local pocPol    := prijem := vydej  := prijemz   := vydejz := 0, ;
        cenZakCel := likPol := sumLik := rozdilPol := 0

  (it_file) ->(flock(),DbGoTop())
  do while .not. (it_file) ->(Eof())
    (it_file)->ndoklad    := (hd_file)->ndoklad
    (it_file)->cobdobi    := (hd_file)->cobdobi
    (it_file)->nrok       := (hd_file)->nrok
    (it_file)->nobdobi    := (hd_file)->nobdobi
    (it_file)->cobdobidan := (hd_file)->cobdobidan

    if((it_file)->nsubcount <> 0, Nil, (prijem  += (it_file)->nprijem , ;
                                        vydej   += (it_file)->nvydej  , ;
                                        prijemz += (it_file)->nprijemz, ;
                                        vydejz  += (it_file)->nvydejz , ;
                                        pocPol++                        ))
    cenZakCel += if((it_file)->nsubcount = 0, (it_file)->ncenzakcel,0)
    sign      := if(.not. Empty((it_file)->cvarsym) .or. (it_file)->nsubcount = 0, +1, ;
                 if((it_file)->ntypobratu = 1, +1, -1))
    likPol    := if(typ_dokl $ 'ban,vzz,uhr',(it_file)->nlikpolbav,(it_file)->nlikpolpok) *sign
    sumLik    += likPol

    AAdd(aitems,{(it_file)->(Sx_keyData()), likPol, (it_file)->(RecNo())})
    (it_file)->(DbSkip())
  enddo

  for items := 1 to Len(aitems) step 1
    pa := aitems[items,1]

    if .pKEY_s == '00'
      (cntp := 0, sumLik := 0)
      AEval(aitems, {|x| ;
        if(SubStr(x[1],1,5) == .pKEY_p,cntp++,Nil), ;
        if(SUbStr(x[1],1,5) == .pKEY_p .and. SubStr(x[1],6,2) == '00', sumLik += x[2], Nil) })

      (it_file)->(DbGoTo(aitems[items,3]))
      rozdilPol := (it_file)->ncenzakcel -sumLik
      trees     := if(cntp = 1,if(rozdilPol = 0,           0, BANVYPITM_1), ;
                               if(rozdilPol = 0, BANVYPITM_3, BANVYPITM_2)  )

      (it_file)->mtree_view := Var2Bin(trees)

    else
      ( cntp := 0, cnts := 0)
      AEval(aitems, {|x| ;
           ( if(SubStr(x[1],1,5) == .pKEY_p         ,cntp++,Nil), ;
             if(SubStr(x[1],1,7) == .pKEY_p +.pKEY_s,cnts++,Nil)) }, items)

      do case
      case Val(.pKEY_ss) == 0 .and. cnts  > 1
        trees := if(cntp > cnts,BANVYPIT_1,BANVYPIT_2)
      case Val(.pKEY_ss) == 0
        trees := if(cntp > cnts,BANVYPIT_3,BANVYPIT_4)
      case Val(.pKEY_ss)  > 0
        if     cntp == cnts .and. cnts > 1 ; trees := BANVYPIT_5
        elseif cntp  > 1    .and. cnts > 1 ; trees := BANVYPIT_6
        elseif cntp  > 1    .and. cnts = 1 ; trees := BANVYPIT_7
        else                               ; trees := BANVYPIT_8
        endif
      endcase

      (it_file)->(DbGoTo(aitems[items,3]))
      (it_file)->mtree_view := Var2Bin(trees)
    endif
  next

  (it_file)->(DbGoTo(recNo))

  if(typ_dokl $ 'ban,vzz,uhr')                     // pokladhd nemá npocpoloz,nzustatek //
    (hd_file)->npocpoloz := pocPol
    (hd_file)->nzustatek := (hd_file)->nposzust +if(::istuz,(prijem-vydej),(prijemz-vydejz))
  endif
  (hd_file)->nprijem   := prijem
  (hd_file)->nprijemz  := prijemz
  (hd_file)->nvydej    := vydej
  (hd_file)->nvydejz   := vydejz

  (hd_file)->(dbcommit())

  if(IsNull(runSum,.F.), ::sumColumn(), Nil)
/*
  oDialog:rozPo := (nCENZAKCEL -nLIKPOLBAV)
*/
Return( NIL)

*
** sel and val method for ban/vzz/pok ******************************************
METHOD FIN_ban_vzz_pok:cvarsym_vld( drgDialog )
  local  odialog, nexit, varsym_sel
  *
  local  drgVar := ::parent:dm:get(::it_file +'->cvarsym', .F.)
  local  value  := drgVar:get(), cntDokl, ok := .t., showDlg := .t.
  local  ain_file := AClone(::ain_file), file_iv
  *
  local  cisFir, it_ico, filter
  local  nin, cfile_iv

  ::newRec := (drgvar:drgdialog:udcp:state = 2)

  if IsObject(drgDialog) .or. (drgVar:changed() .and. .not. empty(value))

    * ads_customizeAof
    ::ain_file[1,8] := {}
    ::ain_file[2,8] := {}
    ::ain_file[3,8] := {}

    banPok_w->( dbgoTop())
    do while .not. banPok_w->(eof())
      if(nin := ascan(ain_file, {|x| x[6] = banPok_w->cdenik_par})) <> 0
        aadd( ::ain_file[nin,8], banPok_w->ndoklad_iv )
      endif
      banPok_w->(dbskip())
    enddo

    * pokladní doklady jen pro ncisFirmy - jen pokud je uvedeno na pokladHD
    if ::typ_dokl = 'pok'
      if (::hd_file)->ncisfirmy <> 0
        cisFir := strzero((::hd_file)->ncisfirmy,5)
        filter := format("strzero(ncisfirmy,5) = '%%'", {cisFir})

        aeval(ain_file, {|x| (x[1])->(ads_setAof(filter),dbgoTop())})
      endif
    endif

    * vzájemné zápoèty jen pro ncisFirmy nebo nico dle ctypDoklad
    if ::typ_dokl = 'vzz'
      if upper( (::hd_file)->ctypDoklad) = 'FIN_VZZAP'
        cisFir := strzero((::hd_file)->ncisfirmy,5)
        filter := format("strzero(ncisfirmy,5) = '%%'", {cisFir})
      else
        it_ico := (::hd_file)->nico
        filter := format("nico = %%", {it_ico})
      endif

      aeval(ain_file, {|x| (x[1])->(ads_setAof(filter),dbgoTop())})
    endif

    AEval(ain_file, {|x| ( cntDokl := 0, (x[1])->(AdsSetOrder(2)                , ;
                                                  DbSetScope(SCOPE_BOTH,value)  , ;
                                                  DbGoTop()                     , ;
                                                  DbEval({|| cntDokl++})        , ;
                                                  dbclearscope()                ) , ;
                           x[2] := cntDokl                                    ) } )

    cntDokl := (ain_file[1,2] +ain_file[2,2])

    do case
    case cntDokl = 0         // nenasel žádný doklad
      ok      := .f.
    case cntDokl > 1         //   našel   víc dokladù
      ok      := .f.
    case cntDokl = 1         //   našel jeden doklad
      ok      := .t.
      showDlg := isobject(drgDialog)
      file_iv := ain_file[if(ain_file[1,2] <> 0,1,2),1]
      (file_iv)->(dbseek(value,, AdsCtag(2) ))
    endcase

    if showDlg
      odialog := drgDialog():new('FIN_CVARSYM_SEL', ::parent:drgDialog)
      odialog:cargo := if( cntDokl = 1,file_iv +',' +value +',2',Nil)
      odialog:create(,,.T.)
      nexit := oDialog:exitState
    endif

    if( nexit = drgEVENT_SELECT .or. ok)
      file_iv := if(showDlg, odialog:oform:oLastDrg:cfile,file_iv)
      ::cvarsym_sel(file_iv)
      drgVar:initValue := drgVar:prevValue := drgVar:value
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
      ::dm:refresh()
    endif

    if( isObject(odialog), odialog:destroy(.T.), nil )
// JS    if(showDlg,odialog:destroy(.T.),nil)
    odialog := Nil

    aeval(ain_file, {|x| (x[1])->(ads_clearAof()) })
  endif
RETURN (nexit != drgEVENT_QUIT) .or. ok


METHOD FIN_ban_vzz_pok:cvarsym_sel(file_iv)
  local  x, cname, value, pos := 1, dm := ::parent:dataManager, pai
  local  zkrMeny := if(lower(::hd_file) = 'banvyphdw', (::hd_file)->czkratMeny, (::hd_file)->czkratMenz)
  local  pa

  local  pa_usr  := { {'cucet_uct' , 'cucet_uct'                                              }, ;
                      {'cvarsym'   , 'cvarsym'                                                }, ;
                      {'cnazev'    , 'cnazev'                                                 }, ;
                      {'ncisfak'   , 'ncisfak'                                                }, ;
                      {'ddatuhrady', 'banvyphdw->ddatporiz,pokladhdw->dporizdok'              }, ;
                      {'czkratmenf', 'MENA('                                                  }, ;
                      {'ctext'     , 'cnazev'                                                 }, ;
                      {'ncenzakcel', ':cvarsym_NEU'                             , 'ncenzahcel'}, ;
                      {'ntypobratu', ':cvarsym_OBR'                                           }, ;
                      {'nuhrcelfak', ':cvarsym_NEU'                             , 'nuhrcelfaz'}, ;
                      {'czkratmenu', 'banvyphdw->czkratmeny,pokladhdw->czkratmenz'            }, ;
                      {'nlikpolbav', ':cvarsym_LIK'                                           }, ;
                      {'nlikpolpok', ':cvarsym_LIK'                                           }  }
  *
  local  pa_imp  := { {'cvarsym'   , 'cvarsym'                                                }, ;
                      {'cucet_uct' , 'cucet_uct'                                              }, ;
                      {'cnazev'    , 'cnazev'                                                 }, ;
                      {'ncisfak'   , 'ncisfak'                                                }  }

  *
  local  ouFile    := ::it_file +'->'
*  local  equalMena := Equal((::hd_file)->czkratmeny,(file_iv)->czkratmenz)
  local  equalMena := Equal(zkrMeny,(file_iv)->czkratmenz)
  local  isDobr    := (fin_cvarsym_neu(file_iv,::typ_dokl,::newRec) < 0)

  if lower(::hd_file) = 'pokladhdw'
    pa := pa_usr
  else
    if ::newRec
      pa := pa_usr
    else
      pa := if ( .not. empty((::hd_file)->cfile_imp), pa_imp, pa_usr )
    endif
  endif


  if .not. IsNull(file_iv)
    for x := 1 to Len(pa) step 1
      do case
      case At(':', pa[x,2]) <> 0       // metoda
        cname := Substr(pa[x,2],2)
        value := self:&cname(file_iv,equalMena)

      case At('(', pa[x,2]) <> 0       // funkce
        value := DBGetVal('FIN_cvarsym_' +pa[x,2] +'"' +file_iv +'")')

      case At('->',pa[x,2]) <> 0       // hodnota z jiného souboru
        cname := pa[x,2]
        if At(',', pa[x,2]) <> 0
          pai := ListAsArray(pa[x,2],',')
          cname := if( ::typ_dokl $ 'ban,vzz,uhr', pai[1], pai[2])
        endif
        value := DBGetVal(cname)

      otherwise
        value := DBGetVal(file_iv +'->' +pa[x,2])
      endcase

      if IsObject(ovar := dm:has(ouFile +pa[x,1]))
        pos    := if( Len(pa[x]) = 3, if(FIN_cvarsym_tuzuc(::typ_dokl),1,3), 1)
        if( pa[x,pos] = 'ncenzakcel' .and. isDobr, value := abs(value), nil)
        dm:set(ouFile +pa[x,pos], value)
      endif
    next

    ovar := ::dm:has(::it_file +'->cfile_iv')
    ovar:set(file_iv)
  endif
RETURN .T.


method fin_ban_vzz_pok:cvarsym_NEU(file_iv,equalMena)
  local  cenzakcel := 0

  if     ::istuz     ;  cenZakCel := (file_iv)->ncenZakCel -(file_iv)->nuhrCelFak
  elseif equalMena   ;  cenZakCel := (file_iv)->ncenZahCel -(file_iv)->nuhrCelFaz
  endif

*  if ::istuz .or. equalMena
*    cenzakcel := fin_cvarsym_neu(file_iv,::typ_dokl,::newRec)
*  endif
return cenzakcel


method fin_ban_vzz_pok:cvarsym_LIK(file_iv,equalMena)
  local  likpol := 0

  if ::istuz
    likpol := abs((file_iv)->ncenZakCel -(file_iv)->nuhrCelFak)
  endif

*  if ::istuz
*    likpol := abs(fin_cvarsym_neu(file_iv,::typ_dokl,::newRec))
*  endif
RETURN likpol


method FIN_ban_vzz_pok:cvarsym_OBR(file_iv,equalMena)
  local  cenZakCel := 0, retVal

  if     ::istuz     ;  cenZakCel := (file_iv)->ncenZakCel -(file_iv)->nuhrCelFak
  elseif equalMena   ;  cenZakCel := (file_iv)->ncenZahCel -(file_iv)->nuhrCelFaz
  endif

  if Equal(file_iv,'fakprihd')  ;  retVal := if(cenZakCel >= 0,2,1)
  else                          ;  retVal := if(cenZakCel >= 0,1,2)
  endif
return retVal
**


method FIN_ban_vzz_pok:cbank_uct_vld(drgDialog)
  LOCAL oDialog, nExit
  //
  LOCAL drgVar := ::parent:dm:get('banvyphdw->cbank_uct', .F.)
  LOCAL value  := drgVar:get()
  LOCAL lOk    := (.not. Empty(value) .and. C_BANKUC ->(DbSeek(upper(value))))

  if IsObject(drgDialog) .or. .not. lOk
     DRGDIALOG FORM 'FIN_C_BANKUC_SEL' PARENT ::parent:drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit

    if nExit != drgEVENT_QUIT
      mh_COPYFLD( 'C_BANKUC', 'BANVYPHDw',,.f.)
      FIN_banvyp_dov(::typ_dokl)
      ::map()
      ::showGroup()
      ::parent:refresh(drgVar)
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgDialog:lastXbpInFocus)
    endif
  endif
return (nExit != drgEVENT_QUIT) .or. lOk


method FIN_ban_vzz_pok:firmyico_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, copy := .F.
  *
  local drgVar := ::dm:has('banvyphdw->nico')
  local value  := drgVar:get()
  local lOk    := firmy ->(dbseek(value,,'FIRMY6')) .and. .not. empty(value)

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIR_FIRMYICO_SEL' PARENT ::parent:drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit
  ENDIF

  if (lOk .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
    mh_copyfld('firmy','banvyphdw',,.f.)

    c_staty->(dbseek(upper((::hd_file)->czkratstat),,'C_STATY1'))
    c_meny->(dbseek(upper(c_staty->czkratmeny,,'C_MENY1')))

    if ((::hd_file)->nkurzahmen +(::hd_file)->nmnozprep = 0 .or. ;
       empty((::hd_file)->czkratmeny)                       .or. ;
       (c_meny->czkratmeny <> (::hd_file)->czkratmeny)           )

      kurzit->(mh_seek(upper(c_meny->czkratmeny),2,,.t.))

      kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(c_meny->czkratMeny)), DbGoTop() )
      cKy := upper(c_meny->czkratMeny) +dtos((::hd_file)->ddatPoriz)
      kurzit->(dbSeek(cKy, .T.))
      If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

      (::hd_file)->czkratmeny := c_meny->czkratmeny
      (::hd_file)->nkurzahmen := kurzit->nkurzstred
      (::hd_file)->nmnozprep  := kurzit->nmnozprep

      kurzit->(dbclearScope())
    endif

    drgVar:set(firmy->nico)
    drgvar:value = drgvar:initValue := drgvar:prevValue := firmy->nico
    ::showGroup()
    ::parent:refresh(drgVar)
    ::parent:df:setNextFocus('banvyphd->ddatporiz',,.t.)
  endif
return (nExit != drgEVENT_QUIT) .or. lOk


*
** class FIN_c_bankuc_SEL ******************************************************
** for banvyphdw
class FIN_c_bankuc_SEL from drgUsrClass
  exported:
  method  init, getForm, drgDialogInit, drgDialogStart

  * bro col for c_bankuc
  inline access assign method isMain_uc() var isMain_uc
    return if( c_bankuc->lisMain, 300, 0)

  inline access assign method isDatKomI() var isDatKomI
    return if( .not. empty(c_bankuc->cIdDatKomI), 505, 0 )

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
      Return .T.

    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        RETURN .F.
      endcase

    otherwise
      RETURN .F.
    endcase
  RETURN .T.

  hidden:
  var  drgGet
endclass


method FIN_c_bankuc_SEL:init(parent)
  local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::drgUsrClass:init(parent)
return self


method FIN_c_bankuc_SEL:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 80,10 DTYPE '10' TITLE 'Výbìr bankovního úètu ...' ;
                                           FILE 'C_BANKUC'                   ;
                                           GUILOOK 'All:N,Border:Y,ACTION:N'

  DRGDBROWSE INTO drgFC SIZE 80,9.8 ;
                        FIELDS 'M->isMain_uc::2.6::2,'    + ;
                               'M->isDatKomI::2.6::2,'    + ;
                               'cBANK_UCT:bankovní úèet,' + ;
                               'cBANK_NAZ:název banky,'   + ;
                               'nPOSZUST:aktuální stav,'  + ;
                               'cZKRATMENY:mìna'            ;
                        SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'

return drgFC


method FIN_c_bankuc_SEL:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

**  XbpDialog:titleBar := .F.
  drgDialog:dialog:drawingArea:bitmap  := 1020  // 1017  // 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2] -24}
**    drgDialog:usrPos := {aPos[1],aPos[2]}
  endif
return


method FIN_c_bankuc_SEL:drgDialogStart(drgDialog)
  Local val, obro := drgDialog:dialogCtrl:oBrowse[1]

  if IsObject(::drgGet)
    val := ::drgGet:oVar:value

    IF( .not. C_BANKUC ->(DbSeek(::drgGet:oVar:value,,'BANKUC1')), C_BANKUC ->(DbGoTop()), NIL )

    obro:oxbp:refreshAll()
  endif
return self


*
** class FIN_ban_vzz_pok:likpol_krp() ************************ K_urzovní R_ozdíl
** for ban/vzz nlikpolbav
** fpr pok     nlikpolpok
class FIN_ban_vzz_pok_kr from drgUsrClass
  exported:
  method init, getForm, drgDialogInit, drgDialogStart, postValidate, overPostLastField
  var    zkratmenu_1, cenzakcel

  inline access assign method zaklMena() var zaklMena
  return SysConfig('Finance:cZaklMena')

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_SAVE
      if ::overPostLastField()
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
      endif
      return .t.
    endcase
  return .f.


  hidden:
  var    dm, p_dm, is_ban, parent, drgGet, it_file, hd_file, istuz, in_file
  *
  var    sign
  var                okurzmenb , omnozpreb, ocenzakcel                           // - row_1
  var    ouhrfak   , ozkratmenu, okurzmenu, omnozpreu, olikpol                   // - row_2
  var    ozkratmenk, okurzmenk                                                   // - row_3
  var    ouhrcelfaz, ozkratmenf, okurzmenf, omnozpref, ocenzakcef, okurzrozdf    // - row_4


  method kurz_set, item_set, c_naklst_vld

  inline method value(name,in_parent)
    local fullName := if( '->' $ name, name, ::it_file +'->' +name), val

    default in_parent to .f.
  return if(in_parent, ::p_dm:get(fullName), ::dm:get(fullName))

endclass


method FIN_ban_vzz_pok_kr:init(parent)
  local nEvent,mp1,mp2,oXbp

  ::parent := parent:parent:udcp
  ::p_dm   := ::parent:dm

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::istuz   := parent:parent:udcp:istuz
  ::it_file := parent:parent:udcp:it_file
  ::hd_file := parent:parent:udcp:hd_file
  ::in_file := alltrim(::parent:dm:get(::it_file +'->cfile_iv'))
  ::is_ban  := (lower(::it_file) = 'banvypitw')

  ::drgUsrClass:init(parent)
return self


METHOD FIN_ban_vzz_pok_kr:getForm()
  local  odrg, drgFC, it_file := lower(::it_file)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,9.5 DTYPE '10' TITLE 'Poøízení/Oprava kurzovního rozdílu ...' ;
                                             FILE ::it_file                                 ;
                                             POST 'postValidate'                            ;
                                             GUILOOK 'All:N,Action:N,ICONBAR:N'

  DRGTEXT INTO drgFC CAPTION 'kurz      /      mnPøep' CPOS 60,-.1 CLEN 18 FONT 5
  DRGTEXT INTO drgFC CAPTION 'èástka v'                CPOS 83,-.1 CLEN  8 FONT 5
  DRGTEXT INTO drgFC NAME M->zaklMena                  CPOS 91,-.1 CLEN  4 FONT 5


  DRGSTATIC INTO drgFC FPOS .4,.4 SIZE 99,8.9 STYPE 13 RESIZE 'y'
  odrg:ctype := 2

* - 1
    DRGTEXT      INTO drgFC CAPTION 'Èástka_typ       ___' CPOS  1,.5 CLEN 15
    DRGTEXT      INTO drgFC NAME M->cenzakcel   CPOS 17  ,.5 CLEN 14 BGND 13 CTYPE 2
    DRGTEXT      INTO drgFC NAME M->zkratmenu_1 CPOS 32.5,.5 CLEN  8 BGND 13
    DRGTEXT      INTO drgFC NAME ctypobratu     CPOS 42  ,.5 CLEN  4 BGND 13 FONT 5 CTYPE 1

    DRGGET  null INTO drgFC FPOS 48, .5 FLEN 15 FCAPTION '/'                    CPOS 66,.5 CLEN 2
    odrg:name := if(::is_ban,'nkurzmenb','nkurzmenm')

    DRGGET  null INTO drgFC FPOS 70, .5 FLEN 10
    odrg:name := if(::is_ban,'nmnozpreb','nmnozprem')

    DRGTEXT      INTO drgFC NAME ncenzakcel CPOS 83  ,.5 CLEN 15 BGND 13 CTYPE 2

* - 2
    DRGTEXT      INTO drgFC CAPTION 'Úhrada_fakury  ___' CPOS  1,1.5 CLEN 15
    DRGGET  null INTO drgFC FPOS 17  ,1.5 FLEN 13
    odrg:name := if(::is_ban,'nuhrbanfak','nuhrpokfak')

    DRGGET  czkratmenu INTO drgFC FPOS 32.5,1.5 FLEN  7
    DRGGET  nkurzmenu  INTO drgFC FPOS 48  ,1.5 FLEN 15 FCAPTION '/'                    CPOS 66,1.5 CLEN 2
    DRGGET  nmnozpreu  INTO drgFC FPOS 70  ,1.5 FLEN 10

    DRGTEXT      INTO drgFC NAME null CPOS 83,1.5 CLEN 15 BGND 13 CTYPE 2
    odrg:name := if(::is_ban,'nlikpolbav','nlikpolpok')

* - 3
    DRGGET  czkratmenk INTO drgFC FPOS 32.5,2.5 FLEN  7 FCAPTION 'pøepoèet na'          CPOS 17,2.5
    DRGGET  nkurzmenk  INTO drgFC FPOS 48  ,2.5 FLEN 15

* - 4
    DRGGET  nuhrcelfaz INTO drgFC FPOS 17  ,3.5 FLEN 13 FCAPTION 'Pøepoèet_fakt   ___' CPOS 1,3.5 CLEN 15
    DRGTEXT            INTO drgFC NAME czkratmenf CPOS 32.5,3.5 CLEN  8 BGND 13
    DRGTEXT            INTO drgFC NAME nkurzmenf  CPOS 48  ,3.5 CLEN 16 BGND 13 CTYPE 2
    DRGTEXT            INTO drgFC NAME nmnozpref  CPOS 70  ,3.5 CLEN 11 BGND 13 CTYPE 2
    DRGTEXT            INTO drgFC NAME ncenzakcef CPOS 83  ,3.5 CLEN 15 BGND 13 CTYPE 2

* - 5
    DRGTEXT            INTO drgFC CAPTION 'Kurzovní rozdíl'  CPOS 60,4.5 FONT 5
    DRGTEXT            INTO drgFC NAME nkurzrozdf CPOS 83  ,4.6 CLEN 15 BGND 13 CTYPE 2
    DRGSTATIC          INTO drgFC FPOS .2,4.7 SIZE 98.9,3.8 STYPE 2 RESIZE 'y'
      DRGGET  cucet_uctk        INTO drgFC FPOS 17,.7   FLEN  8 FCAPTION 'SuAu_S (kr) ' CPOS  1, .7 CLEN 15
      DRGTEXT ik_ucet->cnaz_uct INTO drgFC CPOS 26,.7   CLEN 25
      DRGGET  ctextk            INTO drgFC FPOS 60,.8   FLEN 37 FCAPTION 'Text (kr)'    CPOS 52, .8
      * NS
      DRGGET cnazpol1k   INTO drgFC FPOS  3,2.9 FLEN 10 FCAPTION 'VýrStøedisko'         CPOS  3,1.85 CLEN 10
      DRGGET cnazpol2k   INTO drgFC FPOS 19,2.9 FLEN 10 FCAPTION 'Výrobek'              CPOS 19,1.85 CLEN  8
      DRGGET cnazpol3k   INTO drgFC FPOS 35,2.9 FLEN 10 FCAPTION 'Zakázka'              CPOS 35,1.85 CLEN  8
      DRGGET cnazpol4k   INTO drgFC FPOS 51,2.9 FLEN 10 FCAPTION 'VýrMísto'             CPOS 51,1.85 CLEN  8
      DRGGET cnazpol5k   INTO drgFC FPOS 67,2.9 FLEN 10 FCAPTION 'Stroj'                CPOS 67,1.85 CLEN  8
      DRGGET cnazpol6k   INTO drgFC FPOS 83,2.9 FLEN 10 FCAPTION 'VýrOperace'           CPOS 83,1.85 CLEN 10

      DRGSTATIC INTO drgFC FPOS 0.4,2.2 SIZE 98.4,.2 STYPE 12
      DRGEND INTO drgFC
    DRGEND INTO drgFC
  DRGEND INTO drgFC
RETURN drgFC


method FIN_ban_vzz_pok_kr:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
return


method FIN_ban_vzz_pok_kr:drgDialogStart(drgDialog)
  local  pa       := ::parent:aval_krp, values, size, x, newRec, inData
  local  kr_memb  := drgDialog:oForm:aMembers, name, val, odrg
  local  neu      := ::p_dm:get(::it_file +'->ncenza'    +if(::istuz ,'kcel','hcel'))
  local  mena_u   := if( ::is_Ban, ::p_dm:get(::hd_file +'->czkratmeny' ), (::hd_file)->czkratMenZ )
  local  mena_k   := DBGetVal(::in_file +'->czkratmen'   +if(::istuz ,'y'   ,'z'   ))
  *
  local  neu_tuz  := (::in_file)->ncenzakcel -(::in_file)->nuhrcelfak
  local  neu_zah  := (::in_file)->ncenzahcel -(::in_file)->nuhrcelfaz
  *
  local  uhrFak   := ::p_dm:get(::it_file +'->nuhrcelfa' +if(::istuz,'k','z'))
  local  zkrMenu  := ::p_dm:get(::it_file +'->czkratmenu')
  local  shodaMen := lower(mena_u) = lower(DBGetVal(::in_file +'->czkratmenz'))

  *
  ::dm   := drgDialog:dataManager                  // dataMabanager
  newRec := (::parent:state = 2)
  inData := (::p_dm:get(::it_file +'->cvarsym') = (::it_file)->cvarsym)


  * tuzemský B-úèet ale FAKTURA v cizí mìnì
  if ::istuz
    zkrMenu := ::p_dm:get(::it_file +'->czkratmenf')

    if .not. Equal((::hd_file)->czkratMeny,DBGetVal(::in_file +'->czkratmenz'))
      uhrFak  := (::in_file)->ncenzahcel -(::in_file)->nuhrcelfaz
    endif
  endif

  * obnovíme si data
  do case
  case .not. Empty(pa)
     values := drgDialog:dataManager:vars:values
       size := drgDialog:dataManager:vars:size()

     for x := 1 to size step 1
       values[x,2]:initValue := pa[x,2]
       values[x,2]:prevValue := pa[x,3]

       values[x,2]:set(pa[x,4])

       if( pa[x,1] = 'm->cenzakcel', ::cenzakcel := pa[x,4], nil)
       if( 'ctypobratu'    $ values[x,1], ::sign := if(pa[x,4] = '-', -1, +1), nil)
     next
     ::item_set(mena_u)

  case .not. inData
    for x := 1 to len(kr_memb) step 1
      if isobject(kr_memb[x]:ovar)
        name := lower(kr_memb[x]:ovar:name)
        val  := nil

        do case
* - 1
        case( 'zkratmenu_1' $ name )
          val           := mena_u
          ::zkratmenu_1 := val

        case( 'cenzakcel'   $ name  )
          val         := ::p_dm:get(::it_file +'->ncenza' +if(::istuz,'kcel','hcel'))
          ::cenzakcel := val

        case( 'ctypobratu'  $ name )
          val    := ::parent:dm:get(strtran(name,'CTYP','NTYP'))
          ::sign := if(val = 1,  +1,  -1)
          val    := if(val = 1, '+', '-')

* - 2
        case( 'nuhrbanfak'  $ name )  ;  val := uhrFak
        case( 'nuhrpokfak'  $ name )  ;  val := uhrFak
        case( 'czkratmenu'  $ name )  ;  val := zkrMenu
        case( 'nkurzmenu'   $ name )  ;  val := 0
        case( 'nmnozpreu'   $ name )  ;  val := 0

* - 3
        case( 'czkratmenk'  $ name )
          mena_k := DBGetVal(::in_file +'->czkratmenz')
          val    := mena_k

        case( 'nkurzmenf'  $ name )
          val := DBGetVal(::in_file +'->nkurzahmen')

        case( 'nmnozpref'  $ name )
          val := DBGetVal(::in_file +'->nmnozprep')

        otherwise
          val := ::parent:dm:get(name)
        endcase

        if( isnull(val), nil, ::dm:set(name,val))
      endif
    next

    ::kurz_set()
    ::item_set(mena_u)
    ::postValidate(::okurzmenb:ovar)
  otherwise
    for x := 1 to len(kr_memb) step 1
      if isobject(kr_memb[x]:ovar)
        name := lower(kr_memb[x]:ovar:name)
        val  := nil

        do case
* - 1
        case( 'zkratmenu_1' $ name )
          val           := mena_u
          ::zkratmenu_1 := val

        case( 'cenzakcel'   $ name  )
          val         := ::p_dm:get(::it_file +'->ncenza' +if(::istuz,'kcel','hcel'))
          ::cenzakcel := val

        case( 'ctypobratu'  $ name )
          val    := ::parent:dm:get(strtran(name,'CTYP','NTYP'))
          ::sign := if(val = 1,  +1,  -1)
          val    := if(val = 1, '+', '-')
        endcase

        if( isnull(val), nil, ::dm:set(name,val))
      endif
    next

    ::item_set(mena_u)
    ::postValidate(::okurzmenb:ovar)
  endcase
return


method fin_ban_vzz_pok_kr:kurz_set()
  local  cky, datUhr := dtos(::value('ddatuhrady',.t.))
  *
  local  c_kurz    := ::it_file +'->nkurzmen', c_prep := ::it_file +'->nmnozpre'
  local  ok        := .f.
  local  iskurz_Hd := ( (::hd_file)->( fieldPos('nkurzahmen')) <> 0 .and. ;
                        (::hd_file)->( fieldPos('nmnozprep' )) <> 0       )


  if     .not. ::istuz .and. empty(::value('nkurzmenb'))
    cky    := upper(::value('M->zkratmenu_1')) +datUhr
    c_kurz += if( ::is_ban, 'b', 'm' )
    c_prep += if( ::is_ban, 'b', 'm' )
    ok     := .t.

  elseif       ::istuz .and. empty(::value('nkurzmenu'))
    cky    := upper(::value('czkratmenu')) +datUhr
    c_kurz += 'u'
    c_prep += 'u'
    ok     := .t.

  endif

  if ok
    kurzit->(AdsSetOrder(2), dbsetscope(SCOPE_BOTH,left(cky,3)), dbseek(cky,.t.))
    if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)

    if ::is_ban .or. iskurz_Hd
      ::dm:set(c_kurz, (::hd_file)->nkurzahmen)
      ::dm:set(c_prep, (::hd_file)->nmnozprep )
    else
      ::dm:set(c_kurz, kurzit->nkurzstred)
      ::dm:set(c_prep, kurzit->nmnozprep )
    endif

    kurzit->(dbclearScope())
  endif
return self


method fin_ban_vzz_pok_kr:item_set(mena_u)
  local  cencel := if(::istuz, 'ncenzakcel', 'ncenzahcel'), ;
         uhrfak := if(::is_ban,'nuhrbanfak', 'nuhrpokfak')
         likpol := if(::is_ban,'nlikpolbav', 'nlikpolpok')


* - 1
  ::okurzmenb  := ::dm:has(::it_file +'->nkurzmen' +if(::is_ban,'b','m')):odrg
  ::omnozpreb  := ::dm:has(::it_file +'->nmnozpre' +if(::is_ban,'b','m')):odrg
  ::ocenzakcel := ::dm:has(::it_file +'->ncenzakcel'):odrg

* - 2
  ::ouhrfak    := ::dm:has(::it_file +'->' +uhrfak  ):odrg
  ::ozkratmenu := ::dm:has(::it_file +'->czkratmenu'):odrg
  ::okurzmenu  := ::dm:has(::it_file +'->nkurzmenu' ):odrg
  ::omnozpreu  := ::dm:has(::it_file +'->nmnozpreu' ):odrg
  ::olikpol    := ::dm:has(::it_file +'->' +likpol  ):odrg

* - 3
  ::ozkratmenk := ::dm:has(::it_file +'->czkratmenk'):odrg
  ::okurzmenk  := ::dm:has(::it_file +'->nkurzmenk' ):odrg

* - 4
  ::ouhrcelfaz := ::dm:has(::it_file +'->nuhrcelfaz'):odrg
  ::ozkratmenf := ::dm:has(::it_file +'->czkratmenf'):odrg
  ::okurzmenf  := ::dm:has(::it_file +'->nkurzmenf' ):odrg
  ::omnozpref  := ::dm:has(::it_file +'->nmnozpref' ):odrg
  ::ocenzakcef := ::dm:has(::it_file +'->ncenzakcef'):odrg
  ::okurzrozdf := ::dm:has(::it_file +'->nkurzrozdf'):odrg

  if ::istuz
    (::okurzmenb:isEdit := .f., ::okurzmenb:oxbp:disable(), ::okurzmenb:ovar:set(1) )
    (::omnozpreb:isEdit := .f., ::omnozpreb:oxbp:disable(), ::omnozpreb:ovar:set(1) )

  else
    (::ozkratmenu:isEdit := .f., ::ozkratmenu:oxbp:disable())
    (::okurzmenu:isEdit  := .f., ::okurzmenu:oxbp:disable() )
    (::omnozpreu:isEdit  := .f., ::omnozpreu:oxbp:disable() )

    if mena_u = ::ozkratmenf:ovar:value
      (::ozkratmenk:isEdit  := .f., ::ozkratmenk:oxbp:disable())
      ::ozkratmenk:ovar:set(mena_u)
      (::okurzmenk:isEdit   := .f., ::okurzmenk:oxbp:disable() )
      ::okurzmenk:ovar:set(1)
    else
      (::ozkratmenk:isEdit  := .t., ::ozkratmenk:oxbp:enable())
      (::okurzmenk:isEdit   := .t., ::okurzmenk:oxbp:enable() )
    endif
  endif
return self


method FIN_ban_vzz_pok_kr:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  ok    := .t., changed := drgVAR:changed()
  *
  local  kurzrozdf_o, kurzrozdf, ckurz_z, pa, ucet_uctk
  local  nevent := mp1 := mp2 := nil, isF4 := .f.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case(drgVar = ::okurzmenb:ovar .or. drgVar = ::omnozpreb:ovar)
    if .not. ::istuz
      ::okurzmenu:ovar:set(::okurzmenb:ovar:value)
      ::omnozpreu:ovar:set(::omnozpreb:ovar:value)
    endif

  case(drgVar = ::ozkratmenu:ovar)
    if changed
      ::ozkratmenk:ovar:set(value)
      ::okurzmenk:ovar:set(1)
      ::ozkratmenf:ovar:set(value)
    endif

  case(drgVar = ::okurzmenk:ovar .and. changed)
    ::ouhrcelfaz:ovar:set(::ouhrfak:ovar:value * value)

  endcase

  ::ocenzakcel:ovar:set(::cenzakcel *(::okurzmenb:ovar:value / ::omnozpreb:ovar:value))
  ::olikpol:ovar:set(::ouhrfak:ovar:value    *(::okurzmenu:ovar:value / ::omnozpreu:ovar:value))

  ** ???
  if ::ouhrcelfaz:ovar:value = 0
    ::ouhrcelfaz:ovar:set(::ouhrfak:ovar:value * ::okurzmenk:ovar:value)
  endif
  ::ocenzakcef:ovar:set(::ouhrcelfaz:ovar:value *(::okurzmenf:ovar:value / ::omnozpref:ovar:value))

  kurzrozdf_o := ::okurzrozdf:ovar:value
  if lower(::in_file) = 'fakprihd'
    kurzrozdf := round(::ocenzakcef:ovar:value - ::olikpol:ovar:value, 2)
  else
    kurzrozdf := round(::olikpol:ovar:value -::ocenzakcef:ovar:value, 2)
  endif
  ::okurzrozdf:ovar:set(kurzrozdf)

  if kurzrozdf_o <> kurzrozdf
    ckurz_z := sysconfig('finance:ckurz_z' +if(kurzrozdf >= 0,'isk','tra'))
    pa      := listasarray(ckurz_z)
    ::dm:set(::it_file +'->cucet_uctk',pa[1])
    c_uctosn->(dbseek(alltrim(pa[1])))
    ::dm:set(::it_file +'->ctextk'    ,c_uctosn->cnaz_uct)

    if(len(pa) > 1, ::dm:set(::it_file +'->cnazpol1k', pa[2]), nil)
    if(len(pa) > 2, ::dm:set(::it_file +'->cnazpol2k', pa[3]), nil)
  endif

  if( ::drgGet:ovar:value <> ::olikpol:ovar:value, ;
      ::drgGet:ovar:set(::olikpol:ovar:value * ::sign), nil)

  **
**  ::p_dm:set(::it_file +'->nuhrcelfak',::ocenzakcef:ovar:value)
  **

  if(name = ::it_file +'->cnazpol6k' .and. ok)
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    endif
  endif
return ok


*
** kontola dokladú na vazební èíselník c_naklst
** na banvypit je dvojí kontrola cnazPol1 .. 6 a cnazPol1K .. 6
method fin_ban_vzz_pok_kr:overPostLastField()
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1K' )
  local  ucet      := ::dm:get(::it_file +'->cucet_UctK')
  local  ok

  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok


method fin_ban_vzz_pok_kr:c_naklst_vld(drgVar_nazPol1,ucet)
  local  name  := Lower(drgVar_nazPol1:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  cEx   := if( item = 'cnazpol1k', 'k', '')
  *
  local  x, value := '', ok := .f., showDlg := .f.
  local  lnaklStr := .f.                         // nákladová struktura není povinná

  drgDBMS:open('c_naklst')
  drgDBMS:open('c_uctosn')

  if .not. isNull(ucet)
    c_uctosn->(dbSeek( upper(ucet),,'UCTOSN1'))
    lnaklStr := c_uctosn->lnaklStr
  endif

  for x := 1 to 6 step 1
    value += upper(::dm:get(file +'->cnazPol' +str(x,1) +cEx))
  next

  do case
  case( empty(value) .and. .not. lnaklStr)
    ok := .t.
  case( empty(value) .and.       lnaklStr)
    fin_info_box('Nákladová struktura je pro úèet >' +ucet +'<' +CRLF +' !!! POVINNÁ !!!')
  otherwise
    ok      := c_naklSt->(dbseek(value,,'C_NAKLST1'))
    showDlg := .not. ok
  endcase

  if showDlg
    DRGDIALOG FORM 'c_naklst_sel' PARENT ::dm:drgDialog MODAL           ;
                                                        DESTROY         ;
                                                        EXITSTATE nExit ;
                                                        CARGO drgVar_nazPol1

    if nexit != drgEVENT_QUIT .or. ok
       for x := 1 to 6 step 1
         ::dm:set(file + '->cnazPol' +str(x,1) +cEx, DBGetVal('c_naklSt->cnazPol' +str(x,1)))
       next
      _clearEventLoop(.t.)
      ok := .t.
    else
      ::df:setNextFocus(file +'->cnazPol1' +cEx,,.t.)
    endif
  endif
return ok


*
** class FIN_ban_vzz_pok:likpol_krp() ******************************** P-oplatek
** for ban/vzz nlikpolbav
** for pok     nlikpolpok
class FIN_ban_vzz_pok_p from drgUsrClass
  exported:
  method init, getForm, drgDialogInit, drgDialogStart, postValidate
  var    zkratmenu_1

  inline access assign method zaklMena() var zaklMena
  return SysConfig('Finance:cZaklMena')

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_SAVE
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
      return .t.
    endcase
  return .f.

  hidden:
  var    dm, p_dm, is_ban, parent, drgGet, hd_file, it_file, istuz
  *
  var    ocencel   , okurzmenb , omnozpreb, ocenzakcel                           // - row_1

  method item_set // kurz_set,
endclass


method FIN_ban_vzz_pok_p:init(parent)
  local nEvent,mp1,mp2,oXbp

  ::parent := parent:parent:udcp
  ::p_dm   := ::parent:dm

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::istuz   := parent:parent:udcp:istuz
  ::it_file := parent:parent:udcp:it_file
  ::hd_file := parent:parent:udcp:hd_file
  ::is_ban  := (lower(::it_file) = 'banvypitw')

  ::drgUsrClass:init(parent)
return self


METHOD FIN_ban_vzz_pok_p:getForm()
  local  odrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,2.5 DTYPE '10' TITLE 'Poøízení/Oprava kurzovního rozdílu ...' ;
                                             FILE ::it_file                                 ;
                                             POST 'postValidate'                            ;
                                             GUILOOK 'All:N,Action:N,ICONBAR:N'

  DRGTEXT INTO drgFC CAPTION 'kurz      /      mnPøep' CPOS 60,-.1 CLEN 18 FONT 5
  DRGTEXT INTO drgFC CAPTION 'èástka v'                CPOS 83,-.1 CLEN  8 FONT 5
  DRGTEXT INTO drgFC NAME M->zaklMena                  CPOS 91,-.1 CLEN  4 FONT 5

  DRGSTATIC INTO drgFC FPOS .4,.4 SIZE 99,1.9 STYPE 13 RESIZE 'y'
  odrg:ctype := 2
* - 1
    DRGTEXT      INTO drgFC CAPTION 'Èástka_typ       ___' CPOS  1,.5 CLEN 15
    DRGTEXT      INTO drgFC NAME null CPOS 17,.5 CLEN 14 BGND 13 CTYPE 2
    odrg:name  := if(::istuz, 'ncenzakcel', 'ncenzahcel')

    DRGTEXT            INTO drgFC NAME M->zkratmenu_1 CPOS 32.5,.5 CLEN  8 BGND 13
    DRGTEXT            INTO drgFC NAME ctypobratu     CPOS 42  ,.5 CLEN  4 BGND 13 FONT 5 CTYPE 1

    DRGGET  null INTO drgFC FPOS 48, .5 FLEN 15 FCAPTION '/'                    CPOS 66,.5 CLEN 2
    odrg:name := if(::is_ban,'nkurzmenb','nkurzmenm')

    DRGGET  null INTO drgFC FPOS 70, .5 FLEN 10
    odrg:name := if(::is_ban,'nmnozpreb','nmnozprem')

    DRGTEXT            INTO drgFC NAME ncenzakcel CPOS 83  ,.5 CLEN 15 BGND 13 CTYPE 2
  DRGEND INTO drgFC
RETURN drgFC


method FIN_ban_vzz_pok_p:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
return


method FIN_ban_vzz_pok_p:drgDialogStart(drgDialog)
  local pa      := ::parent:aval_krp, values, size, x
  local mena_u  := ::p_dm:get(::hd_file +'->czkratmeny')
  local kp_memb := drgDialog:oForm:aMembers, name, val

  *
  ::dm := drgDialog:dataManager                  // dataMabanager

  * obnovíme si data
  if .not. Empty(pa)
     values := drgDialog:dataManager:vars:values
       size := drgDialog:dataManager:vars:size()

     for x := 1 to size step 1

       * hodnotu ncenzakcel/ncenzahcel musím pøevzít VŽDY z parenta
       if x = 2
         val := ::parent:dm:get(pa[x,1])
         if( val <> pa[x,4], pa[x,4] := val, nil)
       endif

       values[x,2]:initValue := pa[x,2]
       values[x,2]:prevValue := pa[x,3]

       values[x,2]:set(pa[x,4])
     next

  else
    for x := 1 to len(kp_memb) step 1
      if isobject(kp_memb[x]:ovar)
        name := lower(kp_memb[x]:ovar:name)
        do case
        case( 'zkratmenu_1' $ name )
          val := mena_u

        case( 'ctypobratu'  $ name )
          val    := ::parent:dm:get(strtran(name,'ctyp','ntyp'))
          val    := if(val = 1, '+', '-')

        otherwise
          val := ::parent:dm:get(name)
        endcase
        if( isnull(val), nil, ::dm:set(name,val))
      endif
    next
  endif

  ::item_set()
return


method fin_ban_vzz_pok_p:item_set()
  local  cencel := if(::istuz, 'ncenzakcel', 'ncenzahcel')

* - 1
  ::ocencel    := ::dm:has(::it_file +'->' +cencel  ):odrg
  ::okurzmenb  := ::dm:has(::it_file +'->nkurzmen' +if(::is_ban,'b','m')):odrg
  ::omnozpreb  := ::dm:has(::it_file +'->nmnozpre' +if(::is_ban,'b','m')):odrg
  ::ocenzakcel := ::dm:has(::it_file +'->ncenzakcel'):odrg
return self


method FIN_ban_vzz_pok_p:postValidate(drgVar)
  local  ok    := .t.
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .f.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  ::ocenzakcel:ovar:set(round(::ocencel:ovar:value *(::okurzmenb:ovar:value / ::omnozpreb:ovar:value),2))
  if(::drgGet:ovar:value <> ::ocenzakcel:ovar:value, ::drgGet:ovar:set(::ocenzakcel:ovar:value), nil)

  if( drgVar = ::omnozpreb:ovar)
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    endif
  endif
return ok