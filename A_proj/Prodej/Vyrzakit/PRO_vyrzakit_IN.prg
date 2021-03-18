#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"


#define  m_files   { 'firmy'   , 'c_staty', 'c_meny'  , 'c_typzak'                        , ;
                     'cnazPol1', 'cnazPol2','cnazPol3', 'cnazPol4', 'cnazPol5', 'cnazPol6', ;
                     'c_naklST'                                                           , ;
                     'vyrZakpl', 'vyrzakit', 'vyrzak'                                     , ;
                     'kurzit'  , 'osoby'                                                    }

*
** CLASS for PRO_vyrzakit_IN ***************************************************
CLASS PRO_vyrzakit_IN FROM drgUsrClass, FIN_finance_IN
exported:
  var     cmb_typPoh
  var     lnewrec, it_file

  var     info_16, info_25, info_34
  *
  var     cisZakaz, cdic
  method  init, comboBoxInit, comboItemSelected
  method  drgDialogStart, postLastField, postSave, destroy
  method  postValidate
  method  fir_firmy_sel, osb_osoby_sel
  *
  inline access assign method procDph() var procDph
  return 22

  inline access assign method zaklMena() var zaklMena
  return SysConfig('Finance:cZaklMena')


  * hlavièka info
  * 1 -bìžná faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '
  inline access assign method infoval_11 var infoval_11
    return (explsthdw->ncendancel +explsthdw->nzakldaz_1 +explsthdw->nzakldaz_2)
  inline access assign method infoval_12 var infoval_12
    return (explsthdw->nsazdan_1 +explsthdw->nsazdan_2 +explsthdw->nsazdaz_1 +explsthdw->nsazdaz_2)

  * položky - bro
  inline access assign method cenPol() var cenPol
    return if(explstitw->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method cena_za_mj() var cena_za_mj
    local retval := 0

    retval := if(explsthdw->nfintyp > 2 .or. explsthdw->nfintyp = 6, ;
              if(explsthdw->nfintyp = 4, explstitw->ncenzakcel,explstitw->ncejprkbz), explstitw->ncejprkbz)
    return retval

  inline method eventHandled(nevent,mp1,mp2,oxbp)

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::state := 0

      if ::state <> 0
        (::cisZakaz:odrg:isEdit := .F., ::cisZakaz:odrg:oxbp:disable())
      endif

      ::dm:refresh()
      return .f.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse') .and. isobject(::brow)
        if(IsMethod(self, 'postLastField'), ::postLastField(), Nil)
      else
        if isMethod(self,'postSave')
          if( ::isAppend2, ( _clearEventLoop(.t.), ::new_dok := .f. ), nil )

          if ::postSave()
            if( .not. ::new_dok, PostAppEvent(xbeP_Close,,, ::dm:drgDialog:dialog), nil )
            return .t.
          endif
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif

    otherwise
      return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .f.

  method  showGroup

HIDDEN:
  var     members_fak, members_pen, members_inf, isAppend2
  var     cpic_cisZakaz, ccfg_picturZak
  var     len_cnazPol3
ENDCLASS


method PRO_vyrzakit_in:init(parent)
  local odecs

  ::drgUsrClass:init(parent)
  *
  ::it_file        := 'vyrzakitw'
  ::lnewrec        := .not. (parent:cargo = drgEVENT_EDIT   )
  ::isAppend2      :=       (parent:cargo = drgEVENT_APPEND2)
  ::ccfg_picturZak := allTrim( SysCONFIG( 'Vyroba:cPicturZak'))

  * základní soubory
  ::openfiles(m_files)

  * pro nabídku èísla zakázky
  drgDBMS:open( 'vyrzak',,,,,'vyrzak_X' )
  *
  ** bude se mìnit cnazPol3 z C8 -> C36
  odesc := drgDBMS:getFieldDesc('vyrZakit', 'cnazPol3')
  ::len_cnazPol3 := odesc:len

  * likvidace
  ::FIN_finance_in:typ_lik := 'nil'

  PRO_vyrzakit_cpy(self)
return self


method pro_vyrzakit_in:comboBoxInit(drgComboBox)
  local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
  local  cpicture
  local  is_picNum := .t., cpic
  local  acombo_val := {}

  if ( cname $ 'ctypzak,nklicdph' )
    do case
    case (cname = 'ctypzak')
      c_typZak->( dbgoTop())

      do while .not. c_typZak->(eof())
        *
        *  musíme zjisti jestli vzor je èistá numericka
        cpic := if( empty(c_typZak->cpicture), ::ccfg_picturZak, alltrim(c_typZak->cpicture) )
        for x := 1 to len(cpic) step 1
          if( substr(cpic,x,1) = '9', nil, is_picNum := .f. )
        next

        cpicture := if( .not. empty(c_typZak->c1_picture), '@R ' +c_typZak->c1_picture, '')
        cpicture += alltrim(c_typZak->cpicture)

        if( empty(cpicture), cpicture := ::ccfg_picturZak, nil )

        aadd( acombo_val, { c_typZak->ctypZak   , ;
                            c_typZak->cnazev    , ;
                            c_typZak->c1_picture, ;
                            cpicture            , ;
                            is_picNum             } )
        c_typZak->( dbskip())
      enddo

    case (cname = 'nklicdph' )
      drgDBMS:open('c_dph')
      c_dph->(dbgoTop())

      do while .not. c_dph->(eof())
        aadd(acombo_val, {c_dph->nklicDph, str(c_dph->nprocDph)} )
        c_dph->(dbSkip())
      enddo
    endcase

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value
  endif
return self


method PRO_vyrzakit_IN:comboItemSelected(drgCombo,mp2,o)
  local  cname  := lower(drgCombo:name)
  local  value, values, nin
  *
  local  c1_picture, cfiltr := '', cf := '', pa_cond := {}
  local  xcisZakaz := '0'

  if isObject(drgCombo)
     value := drgCombo:Value
    values := drgCombo:Values

    do case
    case( 'ctypzak' $ cname )
      c_typZak->( dbseek( upper(value),,'C_TYPZAK1'))

      if( nin := ascan(values,{|x| x[1] = value })) <> 0

        cfiltr     := "ctypZak = '%%'"
        c1_picture := values[nin,3]

        for x := 1 to len(values) step 1
          if values[x,3] = c1_picture
            cf  += if( empty(cf), "ctypZak = '%%'", " .or. ctypZak = '%%'")
            aadd( pa_cond, values[x,1])
          endif
        next

        if len(pa_cond) <> 0
          cfiltr := format( cf, pa_cond )
          vyrZak_X->( ads_setAof(cfiltr), ordSetFocus('VYRZAK11'), dbgoBottom() )

          (::it_file)->ncisZakaz := vyrZak_X->ncisZakaz +1
          xcisZakaz := allTrim( str((::it_file)->ncisZakaz))
        endif

        ::cisZakaz:odrg:oxbp:picture := values[nin,4]
        ::cisZakaz:odrg:oxbp:updateData( xcisZakaz )

        ::cisZakaz:initValue := ::cisZakaz:prevValue := ::cisZakaz:value := xcisZakaz

        ::dm:set('vyrzakitw->cnazPol3', left(xcisZakaz, ::len_cnazPol3))

        if( len(pa_cond) <> 0, vyrZak_X->( ads_clearAof()), nil )

        (::it_file)->lis_picNum := values[nin,5]
        (::it_file)->c1_picture := c1_picture
      endif
    endcase
  endif
return self


method PRO_vyrzakit_IN:drgDialogStart(drgDialog)
  local  members    := drgDialog:dialogCtrl:members[1]:aMembers, odrg, groups
  local  fst_item   := if(::lnewrec,'ctyppohybu','ncisFirmy'), pa, x
  *
  local  a_noGet    := { 'cnazFirmy', 'cUlice'   , 'cSidlo'   , 'nICO', 'cDIC', ;
                         'cNazevDoA', 'cUliceDoa', 'cSidloDoa'                  }

  local  a_karZakaz := ListAsArray( SysCONFIG('vyroba:cKarZakaz'))

  ::members_fak := {}
  ::members_pen := {}
  pa := ::members_inf := {}

  aeval(members, {|x| if(ismembervar(x,'groups') .and. .not. isnull(x:groups), ;
                        if(x:groups $ '16,25,34', aadd(pa,x), nil),nil) })

  for x := 1 TO Len(members)
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        members[x]:oXbp:setFontCompoundName(ListAsArray(members[x]:groups)[2])
        members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
      endif
    endif
  next

  *
  ::fin_finance_in:init(drgDialog,'poh',::it_file +'->ccisZakaz',' položku expedièního listu')
  ::cdic     := ::dm:get(::it_file +'->cdic'     , .F.)
  ::cisZakaz := ::dm:get(::it_file +'->cciszakaz', .F.)

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      if isobject(members[x]:oxbp:cargo) .and. members[x]:oxbp:cargo:classname() = 'drgGet'
        odrg := members[x]:oxbp:cargo
      endif
    else
      odrg := members[x]
    endif

    groups := if( ismembervar(odrg,'groups'), isnull(members[x]:groups,''), '')

    do case
    case empty(groups)
      aadd(::members_fak,members[x])
      aadd(::members_pen,members[x])
    otherwise
      do case
      case('FAK' $ groups)  ;  aadd(::members_fak,members[x])
      case('PEN' $ groups)  ;  aadd(::members_pen,members[x])
      otherwise
        aadd(::members_fak,members[x])
        aadd(::members_pen,members[x])
      endcase
    endcase
  next

  aeval(a_noGet, {|x| ( odrg        := ::dm:get(::it_file +'->' +x,.f.):oDrg, ;
                        odrg:isEdit := .f.                                  , ;
                        odrg:oxbp:disable()                                   ) })


  for x := 1 to len(a_karZakaz) step 1
    if a_karZakaz[x] = '0'
      odrg := ::dm:get(::it_file +'->cnazPol' +str(x,1),.f.):oDrg
      odrg:isEdit := .f.
      odrg:oxbp:disable()
    endif
  next

  if .not. ::lnewRec .and. empty( (::it_file)->cdic)
    ::cdic:odrg:oxbp:setColorBG( GRA_CLR_RED )
    ::cdic:odrg:oxbp:configure()
  endif

*-  ::comboItemSelected( ::dm:has((::it_file) +'->ctypZak'):odrg )

*-  if(::lnewrec, ::comboItemSelected(::cmb_typPoh,0)                 , ;
*-                ::df:setNextFocus((::hd_file) +'->ncisFirmy',, .T. )  )
*-  ::df:setNextFocus((::hd_file) +'->' +fst_item,, .T. )

  *
  ** 13.9.2013 - v INS se postavit na ccisZakaz
  if ::lnewrec
    ::comboItemSelected( ::dm:has((::it_file) +'->ctypZak'):odrg )
    ::df:setNextFocus((::it_file) +'->ccisZakaz',, .T. )
  endif
RETURN


method PRO_vyrzakit_in:postLastField()
  local  isChanged := ::dm:changed(), file_iv := alltrim(::dm:has(::it_file +'->cfile_iv'):value)

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  if(.not. empty(file_iv), ::copyfldto_w(file_iv,::it_file),nil)
                       ::copyfldto_w(::hd_file,::it_file)
                       (::it_file)->nintcount  := ::ordItem()+1
    endif

    ::itsave()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())
  endif

  ::setfocus(::state)
  ::dm:refresh()
return .t.


method PRO_vyrzakit_IN:postSave()
  local ok := pro_vyrzakit_wrt_inTrans(self)  // PRO_vyrzakit_wrt(self)

  if(ok .and. ::new_dok)
    vyrzakitw->(dbclosearea())

    PRO_vyrzakit_cpy(self)

    ::fin_finance_in:refresh('vyrzakitw',,::dm:vars)
    *
    ::dm:refresh()
    ::df:tabPageManager:toFront(1)
    ::df:setNextFocus('vyrzakitw->ccisZakaz',,.t.)
  endif
return ok


method PRO_vyrzakit_IN:showGroup()
  local  x, odrg, avars, members := ::df:aMembers
  local  panGroup := if((::hd_file)->nfintyp = 5, 'PEN', 'FAK')

* off
  aeval(members,{|o| ::modi_memvar(o,.f.)})

* on
  members := if( panGroup = 'FAK', ::members_fak, ::members_pen)
  aeval(members,{|o| ::modi_memvar(o,.t.)})

  avars := drgArray():new()
  for x := 1 to len(members) step 1
    if ismembervar(members[x],'ovar') .and. isobject(members[x]:ovar)
      if members[x]:ovar:className() = 'drgVar'
        avars:add(members[x]:ovar,lower(members[x]:ovar:name))
      endif
    endif
  next

  ::df:aMembers := members
  ::dm:vars     := avars
return


method pro_vyrzakit_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  it_fir := 'ncisfirmy,ncisfirdoa'
  local  it_osb := 'ncisoszal,ncisosodp'
  local  cky, koeP, datOVD
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  *
  local  lis_picNum := (::it_file)->lis_picNum
  local  c1_picture := (::it_file)->c1_picture

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

* DRG_MSG_ERROR
* DRG_MSG_WARNING

  c_dph->(dbSeek(vyrzakitw->nklicDph,,'C_DPH1'))

  do case
  case(item = 'cciszakaz')
    if empty(value)
      ::msg:writeMessage('Oznaèení výrobní zakázky je povinný údaj !',DRG_MSG_ERROR)
      ok := .f.
    elseif vyrzak->(dbSeek(upper(value),,'VYRZAK1'))
      ::msg:writeMessage('DUPLICITA -  Výrobní zakázka s tímto oznaèením již existuje !',DRG_MSG_ERROR)
      ok := .f.
    endif
    *
    if ok
      vyrZakitW->cciszakaz := value
      vyrzakitw->cnazPol3  := left(value, ::len_cnazPol3)
      ::dm:set('vyrzakitw->cnazPol3', left(value, ::len_cnazPol3))

      if lis_picNum
        (::it_file)->ncisZakaz := val( substr( value, if( empty(c1_picture),1,2) ))
      endif
    endif

  * 13.9.2013
  case(item = 'nrozm_vys' .and. mp1 = xbeK_RETURN)
    if( ::lnewRec, ::df:setNextFocus((::it_file) +'->ncisFirmy',, .T. ), nil )

  case(item $ it_fir .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

  case(item = 'nmnozplano') .and. changed
    vyrzakitw->ncenaCelk  := vyrzakitw->ncenaMj * value
    vyrzakitw->ncenZakCel := vyrzakitw->ncenaCelk * (1 +c_dph->nprocDph/100)

    ::dm:set('vyrzakitw->ncenaCelk' , vyrzakitw->ncenaCelk )
    ::dm:set('vyrzakitw->ncenZakCel', vyrzakitw->ncenZakCel)

  case(item = 'dodvedzaka')
    if empty(value)
      ::msg:writeMessage('Datum ovedení požadované je povinný údaj ...',DRG_MSG_WARNING)
      ok := .f.
    else
      if empty(::dm:get('vyrzakitw->dmozodvzak'))
        ::dm:set('vyrzakitw->dmozodvzak',value)

        vyrzakitw->nrokODV   := year(value)
        ::dm:set('vyrzakitw->nrokODV',vyrzakitw->nrokODV)

        vyrzakitw->nmesicODV := month(value)
        ::dm:set('vyrzakitw->nmesicODV',vyrzakitw->nmesicODV)

        vyrzakitw->ntydenODV := mh_weekOfYear(value)
        ::dm:set('vyrzakitw->ntydenODV',vyrzakitw->ntydenODV)
      endif
    endif

  case(item = 'dmozodvzak' .or. item = 'dskuodvzak') .and. changed
    if(item = 'dmozodvzak' .and. empty(vyrzakitw->dskuodvzak) .or. item = 'dskuodvzak')
      vyrzakitw->nrokODV   := year(value)
      ::dm:set('vyrzakitw->nrokODV',vyrzakitw->nrokODV)

      vyrzakitw->nmesicODV := month(value)
      ::dm:set('vyrzakitw->nmesicODV',vyrzakitw->nmesicODV)

      vyrzakitw->ntydenODV := mh_weekOfYear(value)
      ::dm:set('vyrzakitw->ntydenODV',vyrzakitw->ntydenODV)
    endif


  case(item = 'ncenamj'   ) .and. changed
   vyrzakitw->ncenaCelk  := vyrzakitw->nmnozPlano * value
   vyrzakitw->ncenZakCel := vyrzakitw->ncenaCelk * (1 +c_dph->nprocDph/100)

   ::dm:set('vyrzakitw->ncenaCelk' , vyrzakitw->ncenaCelk )
   ::dm:set('vyrzakitw->ncenZakCel', vyrzakitw->ncenZakCel)

  case(item = 'ncenacelk' .or. item = 'nklicdph') .and. changed
    vyrzakitw->ncenZakCel := vyrzakitw->ncenaCelk * (1 +c_dph->nprocDph/100)
    ::dm:set('vyrzakitw->ncenZakCel', vyrzakitw->ncenZakCel)

  case(item = 'czkratmenz' .and. changed)
    kurzit->(AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(value)))
    cky := upper(c_meny ->czkratMeny) +dtos(vyrzakitw->dZapis)

    kurzit->(dbSeek(cky,.t.))

    if(kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), nil)

    vyrzakitw->nkurZAHmen := kurzit->nkurzStred
    vyrzakitw->nmnozPrep  := kurzit->nmnozPrep
    ::dm:set('vyrzakitw->nkurZahMen',kurzit->nkurzStred)
    ::dm:set('vyrzakitw->nmnozPrep' ,kurzit->nmnozPrep )

    kurzit->(dbclearScope())

  case(item $ it_osb .and. mp1 = xbeK_RETURN)
    ok := ::osb_osoby_sel()
  endcase

  koeP  := vyrzakitw->nkurzahmen/vyrzakitw->nmnozprep
  vyrzakitw->ncenCelTUZ := vyrzakitw->ncenaCelk * koeP
  ::dm:set('vyrzakitw->ncenCelTUZ', vyrzakitw->ncenCelTUZ)

* ukládáma na každém prvku
  if( changed .and. ok, ::dm:refresh(), nil)
  if( drgVar:changed() .and. ok, drgVar:save(), nil )
return ok


method pro_vyrzakit_in:fir_firmy_sel(drgDialog,a,b,c)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')

  ok := firmy->(dbseek(value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    do case
    case(item = 'ncisfirmy' )
      ::copyfldto_w('firmy',::it_file)
      (::it_file)->cnazFirmy   := firmy->cnazev
      *
      c_staty->(dbseek(upper(firmy->czkratstat),,'C_STATY1'))
      c_meny->(dbseek(upper(c_staty->czkratmeny,,'C_MENY1')))
      *
      if empty((::it_file)->czkratMeny)
        (::it_file)->czkratMenz := c_meny->czkratmeny
      endif

      if empty( firmy->cdic)
        ::cdic:odrg:oxbp:setColorBG( GRA_CLR_RED )
      else
        ::cdic:odrg:oxbp:setColorBG( GraMakeRGBColor( {201, 201, 201} ))
      endif
      ::cdic:odrg:oxbp:configure()

    case(item = 'ncisfirdoa')  ;  (::it_file)->ncisFirDOA  := firmy->ncisFirmy
                                  (::it_file)->cnazevDOA   := firmy->cnazev
                                  (::it_file)->culiceDOA   := firmy->culice
                                  (::it_file)->csidloDOA   := firmy->csidlo
                                  (::it_file)->cpscDOA     := firmy->cpsc
    endcase
    drgVar:set(firmy->ncisfirmy)
    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_vyrzakit_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name),item := drgParseSecond(name,'>')

  ok := .f.  // osoby->(dbseek(value,,'OSOBY01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    do case
    case(item = 'ncisoszal')  ;  (::it_file)->ncisoszal := osoby->ncisOsoby
                                 (::it_file)->cjmeOsZal := osoby->cosoba
    case(item = 'cjmeosodp')  ;  (::it_file)->ncisOsOdp := osoby->ncisOsoby
                                 (::it_file)->cjmeOsOdp := osoby->cosoba
    endcase

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT) .or. ok



*
*****************************************************************
METHOD PRO_vyrzakit_IN:destroy()
  ::drgUsrClass:destroy()
RETURN self