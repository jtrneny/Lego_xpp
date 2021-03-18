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
#include "dll.ch"
//
#include "..\Asystem++\Asystem++.ch"


static function setCursorPos( nX, nY)
  DllCall( "user32.dll", DLL_STDCALL, "SetCursorPos", nX, nY)
return nil


static function getWindowPos(o)
   LOCAL nLeft       := 0
   LOCAL nTop        := 0
   LOCAL nRight      := 0
   LOCAL nBottom     := 0
   LOCAL cBuffer     := Space(16)
   LOCAL aObjPosXY   := {nil,nil}

   DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", o:GetHwnd(), @cBuffer)

   nLeft    := Bin2U(substr(cBuffer,  1, 4))
   nTop     := Bin2U(substr(cBuffer,  5, 4))
   nRight   := Bin2U(substr(cBuffer,  9, 4))
   nBottom  := Bin2U(substr(cBuffer, 13, 4))

   aObjPosXY[1]  := nLeft
   aObjPosXY[2]  := nTop  //AppDeskTop():currentSize()[2] - nBottom
RETURN(aObjPosXY)





*
** prg je urèen pro doplòující nabídku na stranì závazkù a pohledávek
*
** class for fin_dolnujici_in *************************************************
class FIN_doplnujici_in
exported:
  var     m_File

  var     hd_file, it_file
  method  fakVyshd_to_pokladhd_in


  inline method init(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::m_Dialog := drgDialog
    ::m_udcp   := drgDialog:udcp
    ::m_DBrow  := drgDialog:dialogCtrl:oBrowse[1]
    ::m_File   := ::m_DBrow:cfile
    ::a_poPup  := { { 'Zmìna data splatnosti   ', 'fin_dsplatfak_in'    }, ;
                    { 'Zmìna daòových údajù    ', 'fin_danUdaje_in'     }, ;
                    { 'Zmìna formy úhrady      ', 'fin_typUhrfak_in'    }  }

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( members[x]:event = 'createContext', ::pb_context := members[x], nil )
      endif
    next
  return self


  inline method createContext()
    local  pa    := ::a_popUp
    local  aPos  := ::pb_context:oXbp:currentPos()
    local  aSize := ::pb_context:oXbp:currentSize()

    opopup         := XbpImageMenu():new( ::m_Dialog:dialog )
    opopup:barText := 'Pohledávky'
    opopup:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                       , ;
                       de_BrowseContext(self,x,pA[x]), ;
                                                     , ;
                       XBPMENUBAR_MIA_OWNERDRAW        }, ;
                       500                                )
    next

    opopup:popup( ::pb_context:oxbp:parent, { apos[1] -120, apos[2] } )
  return self

  inline method fromContext(aorder,p_popUp)
    local cformName := p_poPup[2]
    local odialog

    odialog := drgDialog():new( cformName, ::m_Dialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    setAppFocus( ::m_DBrow:oxbp )
    PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)

    if( cformName = 'fin_typUhrfak_in', ::m_DBrow:oxbp:refreshCurrent(), nil )
  return self

hidden:
  var     m_Dialog, m_udcp, m_DBrow, pb_context, a_poPup

  var     typ_Dokl, zaklMena
  method  takeValue

  inline access assign method istuz() var istuz
    local zkrMeny := if(lower(::hd_file) = 'banvyphdw', (::hd_file)->czkratMeny, (::hd_file)->czkratMenz)
  return Equal(::zaklMena, zkrMeny)


  inline method cvarsym_NEU(file_iv,equalMena)
    local  cenzakcel := 0

    if     ::istuz     ;  cenZakCel := (file_iv)->ncenZakCel -(file_iv)->nuhrCelFak
    elseif equalMena   ;  cenZakCel := (file_iv)->ncenZahCel -(file_iv)->nuhrCelFaz
    endif
  return cenzakcel

  inline method cvarsym_LIK(file_iv,equalMena)
    local  likpol := 0

    if ::istuz
      likpol := abs((file_iv)->ncenZakCel -(file_iv)->nuhrCelFak)
    endif
  return likpol

  inline method cvarsym_OBR(file_iv,equalMena)
    local  cenZakCel := 0, retVal

    if     ::istuz     ;  cenZakCel := (file_iv)->ncenZakCel -(file_iv)->nuhrCelFak
    elseif equalMena   ;  cenZakCel := (file_iv)->ncenZahCel -(file_iv)->nuhrCelFaz
    endif

    if Equal(file_iv,'fakprihd')  ;  retVal := if(cenZakCel >= 0,2,1)
    else                          ;  retVal := if(cenZakCel >= 0,1,2)
    endif
  return retVal

endclass

*
** úhrada faktur(y) pokladním dokladem
method FIN_doplnujici_in:fakVyshd_to_pokladhd_in(drgDialog)
  local  x, nin, npokladna, pa, pa_cfg
  local  arSelect := aclone(::m_DBrow:arSelect), pa_Recs := {}
  *
  local  o_fin_pokladhd_in, o_udcp, o_dm
  local  o_fin_banvyphd_in_pok
  local  file_iv := 'fakvyshd', hd_file, it_file
  local  prijem,vydej,prijemZ,vydejZ,cenZakCel,likPolPok,cenZahCel, isPri := .t.  // (pokladhdw->ntypdok = 1)

  if( len(arSelect) = 0, aadd( arSelect, fakvyshd->(recNo()) ), nil )

  drgDBMS:open('c_typUhr')
  drgDBMS:open('c_uctOsn')
  drgDBMS:open('pokladms')
  drgDBMS:open('firmy'   )

  do case
  case ::m_DBrow:is_selAllRec
  *  kašlem na to

  case len(arSelect) <> 0
    fordRec( {'fakvyshd'} )

    for x := 1 to len(arSelect) step 1
      fakvyshd->( dbgoto(arSelect[x]) )

      if ::m_udcp:oinf:canBe_Del() .and. c_typUhr->( dbseek( upper(fakvyshd->czkrTYPuhr),,'TYPUHR1') )
        npokladna := c_typUhr->npokladna

        if       c_typUhr->lisHotov  .and. ;
           .not. c_typUhr->lisInkaso .and. ;
           .not. c_typUhr->lisregPok .and. ;
           pokladms->(dbseek( npokladna,, 'POKLADM1') )

           if fakvyshd->npokladEet = 1
             aadd( pa_Recs, { npokladna, { fakvyshd->( recNo()) } } )
           else
             if ( nin := ascan( pa_Recs, {|i| i[1] = npokladna } )) = 0
               aadd( pa_Recs, { npokladna, { fakvyshd->( recNo()) } } )
             else
               aadd( pa_Recs[nin,2], fakvyshd->( recNo()) )
             endif
           endif

        endif
      endif
    next
    fordRec()
  endcase


  for nin := 1 to len(pa_Recs) step 1
    pa := pa_Recs[nin]

    pokladms->( dbseek( pa[1]   ))
    fakvyshd->( dbgoto( pa[2,1] ))
    c_typUhr->( dbseek( upper(fakvyshd->czkrTYPuhr),,'TYPUHR1') )

    if isObject(o_fin_pokladhd_in)
      FIN_pokladhd_cpy(o_fin_pokladhd_in:udcp)
      o_fin_pokladhd_in:udcp:drgDialogStart(o_fin_pokladhd_in)

    else
      o_fin_pokladhd_in := drgDialog():new('FIN_pokladhd_IN',drgDialog)
      o_fin_pokladhd_in:cargo_Usr := 'EXT_POK'
      o_fin_pokladhd_in:create( ,, .t. )
      *
      **
      o_udcp     := o_fin_pokladhd_in:udcp
      ::hd_file  := o_udcp:hd_file
      ::it_file  := o_udcp:it_file
      ::typ_Dokl := o_udcp:typ_Dokl
      ::zaklMena := sysConfig('Finance:cZaklMena')

      o_fin_ban_vzz_pok     := FIN_ban_vzz_pok():new(o_fin_pokladhd_in:udcp)
    endif
    *
    ** na c_typUhr je pøednastavený ctypDoklad / ctypPohybu
    if .not. empty( c_typUhr->ctypPohybu )
      (::hd_file)->ctypDoklad := c_typUhr->ctypDoklad
      (::hd_file)->ctypPohybu := c_typUhr->ctypPohybu
    endif
    *
    ** Eet pokladna musíme do pokladhdW nakopírovat firmu
    if fakVyshd->npokladEet = 1
      firmy->(dbseek((file_iv)->ncisFirmy,,'FIRMY1'))
      mh_COPYFLD('FIRMY', ::hd_file,,.F.)
      (::hd_file)->nFAKVYSHD := (file_iv)->sid
    endif
    *
    ** kurz / prepocet
    (::hd_file)->nkurZahMen := fakvyshd->nkurZahMen
    (::hd_file)->nmnozprep  := fakvyshd->nmnozprep
    *
    ** ctextDok
    (::hd_file)->ctextDok   := 'Úhrada fakVys ->' +allTrim( str(fakvyshd->ncisFak))
    
    *
    ** pololožky pokladitW
    for x := 1 to len(pa[2]) step 1
      fakvyshd->( dbgoto( pa[2,x] ))

      o_udcp:copyfldto_w(  file_iv, ::it_file, .t.)
      o_udcp:copyfldto_w(::hd_file, ::it_file)

      ::takeValue( file_iv )

      (::it_file)->cdenik_par := (file_iv)->cdenik
      (::it_file)->cfile_iv   := file_iv
      (::it_file)->ndoklad_iv := (file_iv)->(recno())
      (::it_file)->nFAKVYSHD  := (file_iv)->sid
      (::it_file)->nintcount  := o_udcp:ordItem()+1

      if .not. Equal(fakvyshd->czkratMeny,::zaklMena)
        *
        ** 1
        (::it_file)->czkratMENm := (::hd_file)->czkratMeny
        (::it_file)->nkurzMENm  := (::hd_file)->nkurZahMen
        (::it_file)->nmnozPREm  := (::hd_file)->nmnozPrep
        (::it_file)->ncenzakcel := (::it_file)->ncenzahcel * ((::it_file)->nkurzMENm / (::it_file)->nmnozPREm )
        *
        ** 2
        (::it_file)->nuhrPokFak := (::it_file)->nuhrCelFaz
        (::it_file)->czkratMENu := (::hd_file)->czkratMeny
        (::it_file)->nkurzMENu  := (::hd_file)->nkurZahMen
        (::it_file)->nmnozPREu  := (::hd_file)->nmnozPrep
        (::it_file)->nlikPolPok := (::it_file)->nuhrPokFak * ((::it_file)->nkurzMENu / (::it_file)->nmnozPREu )
        *
        ** 3
        (::it_file)->czkratMENk := (::hd_file)->czkratMeny
        (::it_file)->nkurzMENk  := 1
        *
        ** 4
        (::it_file)->czkratMENf := (::hd_file)->czkratMeny
        (::it_file)->nkurzMENf  := (::hd_file)->nkurZahMen
        (::it_file)->nmnozPREf  := (::hd_file)->nmnozPrep
        (::it_file)->ncenZakCef := (::it_file)->nuhrPokFak * ((::it_file)->nkurzMENf / (::it_file)->nmnozPREf )
        *
        ** 5
        (::it_file)->nkurzROZDf := round( (::it_file)->nlikPolPok - (::it_file)->ncenZakCef, 2 )
        *
        ** 6 - 7
        if (::it_file)->nkurzROZDf <> 0
          ckurz_z := sysconfig('finance:ckurz_z' +if((::it_file)->nkurzROZDf >= 0,'isk','tra'))
          pa_cfg  := listasarray(ckurz_z)

          c_uctosn->(dbseek(alltrim(pa_cfg[1])))
          (::it_file)->cucet_uctk := pa_cfg[1]
          (::it_file)->ctextk     := c_uctosn->cnaz_uct

          if(len(pa) > 1, (::it_file)->cnazpol1k := pa_cfg[2], nil)
          if(len(pa) > 2, (::it_file)->cnazpol2k := pa_cfg[3], nil)
        endif
      endif

      if ((::it_file)->nuhrcelfak < 0 .and. (::it_file)->nlikpolpok < 0)
        (::it_file)->nlikpolpok := (::it_file)->nlikpolpok *(-1)
      endif

      o_fin_ban_vzz_pok:map(.f.)
    next

    * pøepoèet hlavièky
    prijem := vydej := prijemZ := vydejZ := cenZakCel := likPolPok := cenZahCel := 0
    (::it_file)->(dbgotop(), ;
                  dbeval( {|| (prijem    += (::it_file)->nprijem   , ;
                               vydej     += (::it_file)->nvydej    , ;
                               prijemZ   += (::it_file)->nprijemZ  , ;
                               vydejZ    += (::it_file)->nvydejZ   , ;
                               cenZakCel += (::it_file)->ncenzakcel, ;
                               cenZahCel += (::it_file)->ncenzahcel, ;
                               likPolPok += (::it_file)->nlikpolpok  ) }))

    (::hd_file)->nprijem    := prijem  +if(       isPri, (::hd_file)->ncencel_hd, 0)
    (::hd_file)->nvydej     := vydej   +if( .not. isPri, (::hd_file)->ncencel_hd, 0)
    (::hd_file)->nprijemZ   := prijemZ +if(       isPri, (::hd_file)->ncenzah_hd, 0)
    (::hd_file)->nvydejZ    := vydejZ  +If( .not. isPri, (::hd_file)->ncenzah_hd, 0)
    (::hd_file)->ncenzakcel := cenZakCel
    (::hd_file)->ncenzahcel := cenZahCel
    (::hd_file)->ncencel_it := cenZakCel
    (::hd_file)->ncenzah_it := cenZahCel

    drgVar := o_udcp:dm:get('pokladhdw->npokladna', .F.)
    o_udcp:refresh(drgVar)

    o_udcp:lnewREC := .t.
    o_fin_pokladhd_in:quickShow(.t.,.t.)

    _clearEventLoop(.t.)
  next

  * rušíme oznaèení
  ::m_DBrow:arselect := {}
  ::m_DBrow:oxbp:refreshAll()

  setAppFocus( ::m_DBrow:oxbp )
  PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)
return self


method FIN_doplnujici_in:takeValue(file_iv)
  local  x, cname, value, pos := 1, fieldPos, pai
  local  zkrMeny := if(lower(::hd_file) = 'banvyphdw', (::hd_file)->czkratMeny, (::hd_file)->czkratMenz)
  *
  local  ouFile    := ::it_file +'->'
  local  equalMena := Equal(zkrMeny,(file_iv)->czkratmenz)
  local  isDobr    := (fin_cvarsym_neu(file_iv,::typ_dokl, .t.) < 0)

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


  for x := 1 to len(pa_usr) step 1
    do case
    case At(':', pa_usr[x,2]) <> 0       // metoda
      cname := Substr(pa_usr[x,2],2)
      value := self:&cname(file_iv,equalMena)

    case At('(', pa_usr[x,2]) <> 0       // funkce
      value := DBGetVal('FIN_cvarsym_' +pa_usr[x,2] +'"' +file_iv +'")')

    case At('->',pa_usr[x,2]) <> 0       // hodnota z jiného souboru
      cname := pa_usr[x,2]
      if At(',', pa_usr[x,2]) <> 0
        pai := ListAsArray(pa_usr[x,2],',')
        cname := if( ::typ_dokl $ 'ban,vzz,uhr', pai[1], pai[2])
      endif
      value := DBGetVal(cname)

    otherwise
      value := DBGetVal(file_iv +'->' +pa_usr[x,2])
    endcase

    pos    := if( Len(pa_usr[x]) = 3, if(FIN_cvarsym_tuzuc(::typ_dokl),1,3), 1)
    if( pa_usr[x,pos] = 'ncenzakcel' .and. isDobr, value := abs(value), nil)


    if(fieldPos := pokladitW->( fieldPos( pa_usr[x,pos]))) <> 0
      pokladitW->( fieldPut( fieldPos, value))
    endif
  next

  * nápoèet nprijem, nvydej, nprijemZ, nvzdejZ *
  (::it_file)->nprijem := (::it_file)->nprijemz := ;
  (::it_file)->nvydej  := (::it_file)->nvydejz  := 0
  *
  if (::it_file)->ntypobratu = 1  ;  (::it_file)->nprijem  := abs((::it_file)->ncenzakcel)
                                     (::it_file)->nprijemz := abs((::it_file)->ncenzahcel)
  else                            ;  (::it_file)->nvydej   := abs((::it_file)->ncenzakcel)
                                     (::it_file)->nvydejz  := abs((::it_file)->ncenzahcel)
  endif

  pokladitW->( dbcommit())
return .t.


*
** class for fin_dsplatfak_in *** zmìna data splatnosti ************************
class fin_dsplatfak_in from drgUsrClass
exported:

  * hodnota z dokladu
  inline access assign method dok_dsplatFak() var dok_dsplatFak
    return (::m_File)->dsplatFak

  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::m_file  := parent:parent:udcp:m_File
    ::hrazeno := parent:parent:udcp:oinf:hrazeno()
  return self

  inline method drgDialogInit(drgDialog)
    local members := drgDialog:formObject:members, x

    BEGIN SEQUENCE
      for x := 1 to len(members) step 1
        if  members[x]:ClassName() = '_drgDrgForm'
          members[x]:file = ::m_file
    BREAK
        endif
      next
    END SEQUENCE
  return self

  inline method drgDialogStart(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::msg := drgDialog:oMessageBar             // messageBar
    ::dm  := drgDialog:dataManager             // dataMabanager

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( ischaracter(members[x]:event) .and. ;
                        members[x]:event = 'save_splatFak', ::pb_save_splatFak := members[x], nil )
      endif
    next

    ::it_splatFak := ::dm:has( ::m_File +'->dsplatfak' )
    ::it_splatFak:set( date() )

    if ::hrazeno = H_big
      ::msg:writeMessage( 'Faktura již byla uhrazena, zmìna data splatnosti nic neovlivní ...', DRG_MSG_WARNING )
    endif
  return self

  inline method postValidate(drgVar)
    Local  value  := drgVar:get()
    Local  name   := lower(drgVar:name)
    Local  file   := drgParse(name,'-')
    *
    local  apos_pb, asize_pb, apos

    if name = lower( ::m_File +'->dsplatfak' )
      apos_pb  := getWindowPos( ::pb_save_splatFak:oxbp )
      asize_pb := ::pb_save_splatFak:oxbp:currentSize()

      apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

      setCursorPos( apos[1], apos[2] )
      setAppFocus( ::pb_save_splatFak:oxbp )
    endif
  return .t.


  inline method save_splatFak()
    local  dat_splatFak := (::m_File)->dsplatFak
    local  ctext        := 'old_splatFak = ' +dtoc(dat_splatFak) + ;
                           ' -> new_splatFak = ' +dtoc(::it_splatFak:value)

    if dat_splatFak <> ::it_splatFak:value
      if (::m_File)->(sx_rLock())
        (::m_File)->dsplatFak := ::it_splatFak:value

        mh_wrtZmena( ::m_File,,, ctext )

        (::m_File)->( dbunlock(), dbcommit())
      endif
    endif

    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self

hidden:
  var     m_File, hrazeno, msg, dm
  var     it_splatFak, pb_save_splatFak

endclass

*
** class for fin_dsplatfak_in *** zmìna daòových údajù ************************
class fin_danUdaje_in from drgUsrClass
exported:

 * hodnoty z dokladu
 inline access assign method dok_nico()       var dok_nico
    return (::m_File)->nico

 inline access assign method dok_cdic()       var dok_cdic
    return (::m_File)->cdic

 inline access assign method dok_cdanDoklad() var dok_cdanDoklad
    return (::m_File)->cdanDoklad


 inline method init(parent)
    ::drgUsrClass:init(parent)

    ::m_file  := parent:parent:udcp:m_File
    ::danUzav := parent:parent:udcp:oinf:danUzav()
  return self

  inline method drgDialogInit(drgDialog)
    local members := drgDialog:formObject:members, x

    BEGIN SEQUENCE
      for x := 1 to len(members) step 1
        if  members[x]:ClassName() = '_drgDrgForm'
          members[x]:file = ::m_file
    BREAK
        endif
      next
    END SEQUENCE
  return self

  inline method drgDialogStart(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::msg := drgDialog:oMessageBar             // messageBar
    ::dm  := drgDialog:dataManager             // dataManager

    isEditGet( { 'M->dok_nico', 'M->dok_cdic', 'M->dok_cdanDoklad' }, drgDialog, .f. )

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( ischaracter(members[x]:event) .and. ;
                        members[x]:event = 'save_danUdaje', ::pb_save_danUdaje := members[x], nil )
      endif
    next

    ::it_nico       := ::dm:has( ::m_File +'->nico'       )
    ::it_cdic       := ::dm:has( ::m_File +'->cdic'       )
    ::it_cdanDoklad := ::dm:has( ::m_File +'->cdanDoklad' )

    if ::danUzav = D_big
      ::msg:writeMessage( 'Faktura již byla daòovì uzavøena, zmìna daòových údajù nic neovlivní ...', DRG_MSG_WARNING )
    endif
  return self

  inline method postValidate(drgVar)
    Local  value  := drgVar:get()
    Local  name   := lower(drgVar:name)
    Local  file   := drgParse(name,'-')
    *
    local  apos_pb, asize_pb, apos

    if name = lower( ::m_File +'->cdanDoklad' )
      apos_pb  := getWindowPos( ::pb_save_danUdaje:oxbp )
      asize_pb := ::pb_save_danUdaje:oxbp:currentSize()

      apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

      setCursorPos( apos[1], apos[2] )
      setAppFocus( ::pb_save_danUdaje:oxbp )
    endif
  return .t.


  inline method save_danUdaje()
    local  nico  := ::it_nico:value, cdic := ::it_cdic:value, cdanDoklad := ::it_cdanDoklad:value
    local  ctext := ''

    if ::dok_nico       <> nico       .or. ;
       ::dok_cdic       <> cdic       .or. ;
       ::dok_cdanDoklad <> cdanDoklad

      if ::dok_nico <> nico
        ctext += 'old_nico = ' +str(::dok_nico) +' -> new_nico = ' +str(nico) +CRLF
      endif

      if ::dok_cdic <> cdic
        ctext += 'old_cdic = ' +    ::dok_cdic  +' -> new_cdic = ' +    cdic  +CRLF
      endif

      if ::dok_cdanDoklad <> cdanDoklad
        ctext += 'old_cdanDoklad = ' +::dok_cdanDoklad +' -> new_cdanDoklad = ' +cdanDoklad
      endif

      if (::m_File)->(sx_rLock())
        (::m_File)->nico       := nico
        (::m_File)->cdic       := cdic
        (::m_File)->cdanDoklad := cdanDoklad

        mh_wrtZmena( ::m_File,,, ctext )

        (::m_File)->( dbunlock(), dbcommit())
      endif
    endif


    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self

hidden:
  var     m_File, danUzav, msg, dm
  var     pb_save_danUdaje, it_nico, it_cdic, it_cdanDoklad

endclass


*
** class for fin_typUhrfak_in *** zmìna formy úhrady ***************************
class fin_typUhrfak_in from drgUsrClass
exported:

  inline method init(parent)
    ::drgUsrClass:init(parent)

    drgDBMS:open('c_typUhr')

    ::m_File  := parent:parent:udcp:m_File
    ::hrazeno := parent:parent:udcp:oinf:hrazeno()

    ::zkrTypUhr     := (::m_File)->czkrTypUhr
    ::new_zkrTypUhr := ''
    ::pokladEet     := (::m_File)->npokladEet
    ::new_pokladEet := 0
  return self


  inline method drgDialogStart(drgDialog)
    local  x, className
    local  members := drgDialog:oActionBar:members

    ::msg := drgDialog:oMessageBar             // messageBar
    ::dm  := drgDialog:dataManager             // dataMananager

     for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( ischaracter(members[x]:event) .and. ;
                        members[x]:event = 'save_typUhrFak', ::pb_save_typUhrFak := members[x], nil )
      endif
    next

    members := drgDialog:oForm:aMembers

    for x := 1 to len(members) step 1
      className := members[x]:ClassName()

      if className = 'drgPushButton'
         if isCharacter( members[x]:event )
           do case
           case ( members[x]:event = 'dokl_typUhr'  )  ; ::obtn_dokl_typUhr := members[x]
           case ( members[x]:event = 'createContext')  ; ::obtn_typUhrady   := members[x]
           endcase
         endif
       endif
     next

     c_typuhr->( dbseek( upper(::zkrTypUhr),,'TYPUHR1' ))
     ::obtn_dokl_typUhr:isEdit := .f.
     ::obtn_dokl_typUhr:oxbp:setCaption('(' +c_typuhr->czkrTypUhr +') -> ' +allTrim(c_typuhr->cpopisUhr) )
     ::obtn_dokl_typUhr:oxbp:setFont(drgPP:getFont(5))
     ::obtn_dokl_typUhr:oxbp:SetGradientColors( { 0,5 } )

     ::pb_save_typUhrFak:oxbp:disable()

     if ::hrazeno = H_big
       ::msg:writeMessage( 'Faktura již byla uhrazena, zmìna formy úhrady nic neovlivní ...', DRG_MSG_WARNING )
     endif
   return self

  *
  ** BUTTON pro czkrTypUhr
  inline method createContext()
    local  pa_context := {}, opopup
    local  x, aPos, aSize, nin
    local  czkrTypUhr := upper(::zkrTypUhr)
    *
    c_typUhr->( dbgoTop())
    do while .not. c_typUhr->( eof())
       aadd( pa_context, { '(' +c_typuhr->czkrTypUhr +') -> ' +allTrim(c_typuhr->cpopisUhr), ;
                            c_typuhr->czkrTypUhr                                           , ;
                            c_typuhr->lisHotov                                             , ;
                            c_typUhr->npokladEet                                             } )
      c_typUhr->(dbskip())
    enddo


    if len(pa_context) > 0
      opopup         := XbpImageMenu( ::drgDialog:dialog ):new()
      opopup:barText := 'Èíselník typù úhrady'
      opopup:create()

      for x := 1 to len(pa_context) step 1
        opopup:addItem( {pa_context[x,1]                       , ;
                         de_BrowseContext(self,x,pa_context[x]), ;
                                                               , ;
                              XBPMENUBAR_MIA_OWNERDRAW        }, ;
                        if( pa_context[x,2] = ::zkrTypUhr, 500, 0) )
      next

      nin := ascan( pa_context, {|x| upper(x[2]) = czkrTypUhr })
      if( nin <> 0, opopup:disableItem(nin), nil )

      aPos    := ::obtn_typUhrady:oXbp:currentPos()
      aSize   := ::obtn_typUhrady:oXbp:currentSize()
      opopup:popup( ::obtn_typUhrady:oxbp:parent, { apos[1] -21, apos[2] } )
    endif
  return self


  inline method fromContext(aorder,p_popUp, lin_Start)
    local  apos_pb, asize_pb, apos
    local  pa  := { GraMakeRGBColor({255,130,192}), 0}

    ::obtn_typUhrady:oxbp:setCaption( allTrim( p_popUp[1]))
    ::obtn_typUhrady:oxbp:SetGradientColors( pa )

    ::new_zkrTypUhr := p_popUp[2]
    ::new_pokladEet := p_popUp[4]

    apos_pb  := getWindowPos( ::pb_save_typUhrFak:oxbp )
    asize_pb := ::pb_save_typUhrFak:oxbp:currentSize()
    apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

    ::pb_save_typUhrFak:oxbp:enable()
    ::pb_save_typUhrFak:oxbp:setCaption('Uložit')

    setCursorPos( apos[1], apos[2] )
    setAppFocus( ::pb_save_typUhrFak:oxbp )
  return self


  inline method save_typUhrFak()
    local  dat_splatFak := (::m_File)->dsplatFak
    local  ctext        := 'old_zkrTypUhr = ' +    ::zkrTypUhr    + '-> new_zkrTypUhr = ' +    ::new_zkrTypUhr +CRLF + ;
                           'old_pokladEet = ' +str(::pokladEet,2) + '-> new_pokladEet = ' +str(::new_pokladEet)

    if ::zkrTypUhr <> ::new_zkrTypUhr .or. ::pokladEet <> ::new_pokladEet
      if (::m_File)->(sx_rLock())
        (::m_File)->czkrTypUhr := ::new_zkrTypUhr
        (::m_File)->npokladEet := ::new_pokladEet

        mh_wrtZmena( ::m_File,,, ctext )

        (::m_File)->( dbunlock(), dbcommit())
      endif
    endif

    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self

hidden:
  var     m_File
  var         zkrTypUhr,     pokladEet
  var     new_zkrTypUhr, new_pokladEet
  var     hrazeno, msg, dm
  var     pb_save_typUhrFak, obtn_dokl_typUhr, obtn_typUhrady
endclass