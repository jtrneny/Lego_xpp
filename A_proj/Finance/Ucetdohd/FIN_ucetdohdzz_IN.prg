#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
//
#include "..\FINANCE\FIN_finance.ch"


#xtranslate SetDBScope(<tag>,<cky>) => ( AdsSetOrder(<tag>)          , ;
                                         DbSetScope(SCOPE_BOTH,<cky>), ;
                                         DbGoTop()                     )
* pole ckeys_pz
#define p_denik      3
#define p_cisFak     4
#define p_intCount   5
#define p_cenZakCel  6
#define p_datPoriz   7
#define p_uhrCelFak  8
#define p_uhrCelFaZ  9
#define p_zkratMenF 10
#define p_kurzMenU  11
#define p_mnozPreU  12


#define m_files  { 'typdokl' ,'c_typoh'                      , ;
                   'c_meny'  ,'c_dph'                        , ;
                   'banvypit','pokladit','range_hd','range_it' }


*  daòové doklady ZaplacenýchZáloh fakvyshd/fakprihd
** CLASS for FIN_ucetdohdzz_IN *************************************************
CLASS FIN_ucetdohdzz_IN FROM drgUsrClass, FIN_finance_IN
exported:
  VAR     lNEWrec, typ_zz, cmb_typPoh

  method  init, drgDialogStart
  method  postValidate, comboItemSelected, comboBoxInit, postSave
  method  firmyico_sel


  *
  inline access assign method cnaz_uct_hd()  var cnaz_uct_hd
    c_uctosn->( DbSeek(if(isnull(::nazuc_hd),'',::nazuc_hd:value)))
    return c_uctosn->cnaz_uct

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    return ::handleEvent(nEvent, mp1, mp2, oXbp)

hidden:
  VAR     typ, subTitle, mainFile, mainKy, showDialog
  var     nazuc_hd, hd_file, range_key, roundDph, is_danDokUsed

  var     aEdits, panGroup, members

  method  showGroup
ENDCLASS


METHOD FIN_ucetdohdzz_IN:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::hd_file       := 'ucetdohdw'
  ::lnewRec       := .not. (parent:cargo = drgEVENT_EDIT .and. .not. UCETDOHD ->(Eof()))
  ::typ           := IsNull(parent:parent:UDCP:typ_lik, '')
  ::typ_zz        := parent:parent:UDCP:typ_zz
  ::roundDph      := SysConfig('Finance:nRoundDph')
  ::is_danDokUsed := parent:parent:UDCP:is_danDokUsed
  *
  * základní soubory
  ::openfiles(m_files)

  DO CASE
  CASE ::typ_zz = 'zav'
    ::subTitle  := 'závazkù ...'
    ::mainFile  := 'FAKPRIHD'
    ::mainKy    := Upper(FAKPRIHD ->cDENIK) +StrZero(FAKPRIHD ->nCISFAK,10)
    ::range_key := 'UCETDOHD:pz'
  CASE ::typ_zz = 'poh'
    ::subTitle  := 'pohledávek ...'
    ::mainFile  := 'FAKVYSHD'
    ::mainKy    := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
    ::range_key := 'UCETDOHD:vz'
  ENDCASE

  FIN_ucetdohd_CPY(self)
RETURN self


METHOD FIN_ucetdohdzz_IN:drgDialogStart(drgDialog)
  local  x
  local  zaklMena := SysConfig('Finance:cZaklMENA')

  ** likvidace/rvdph
  ::FIN_finance_in:typ_lik := 'ucd'
  ::FIN_finance_in:init(self,'ucd','UCETDOHDw->cUCEMD','_zaplacené zálohy_')

  ::aEdits   := {}
  ::panGroup := if( (::mainFile)->czkratMenZ = zaklMena, '0', '1')
  ::members  := drgDialog:oForm:aMembers

  FOR x := 1 TO LEN(::members)
    IF ::members[x]:ClassName() = 'drgStatic' .and. .not.Empty(::members[x]:groups)
      AAdd(::aEdits, { ::members[x]:groups, x })
    ENDIF
  NEXT

  *
  ::nazuc_hd   := ::dm:get('ucetdohdw->cucet_uct' , .F.)
  ::cmb_typPoh := ::dm:has('ucetdohdw->ctyppohybu'):odrg

  ::comboItemSelected(::cmb_typPoh)
  ::comboItemSelected(::dm:has(::hd_file +'->ckeys_pz'):oDrg)

  drgDialog:dataManager:refresh()
  ::showGroup()

  IF .not. ::showDialog
    drgDialog:parent:oMessageBar:writeMessage('K dokladu neexistují platby ...',DRG_MSG_WARNING)
  ENDIF
RETURN ::showDialog


METHOD FIN_ucetdohdzz_IN:comboBoxInit(drgComboBox)
  LOCAL  cNAME := drgParseSecond(drgComboBox:name,'>'), x, cf
  LOCAL  pa    := {'BANVYPIT','POKLADIT'}, acombo_val := {}
  *
  local  ckeys_pz := allTrim(ucetdohdw->ckeys_pz), nin

  IF ('CKEYS_PZ' $ cNAME)
    FOR x := 1 TO LEN(pa) STEP 1
      cf := pa[x]

      (cf) ->( SetDBScope(2,::mainKy), ;
               DbEval( { || AAdd( acombo_val, {      (cf) ->cDENIK           +'/' + ;
                                                Str( (cf) ->nDOKLAD   ,10  ) +'/' + ;
                                                Str( (cf) ->nINTCOUNT , 5  ) +'/' + ;
                                                Str( (cf) ->nCENZAKCEL,13,2)        , ;
                                                     (cf) ->cDENIK           +'/' + ;
                                                Str( (cf) ->nDOKLAD   ,10  ) +'/' + ;
                                                Str( (cf) ->nINTCOUNT , 5  ) +'/' + ;
                                                Str( (cf) ->nCENZAKCEL,13,2)        , ;
                                                     (cf) ->cDENIK                  , ;
                                                     (cf) ->nCISFAK                 , ;
                                                     (cf) ->nINTCOUNT               , ;
                                                     (cf) ->nCENZAKCEL              , ;
                                                     (cf) ->dDATPORIZ               , ;
                                                     (cf) ->nuhrCelFak              , ;
                                                     (cf) ->nuhrCelFaZ              , ;
                                                     (cf) ->czkratMenF              , ;
                                                     (cf) ->nkurzMenU               , ;
                                                     (cf) ->nmnozPreU                 }) }), ;
               DbClearScope()                                                                )
    NEXT

    IF ::showDialog := (Len(acombo_val) <> 0)
      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * pøi opravì dokladu musím zobrazit vazbu na ckeys_PZ
      if .not. empty( ckeys_pz )
         ucetdohdw->(dbcommit())

         if ( nin := ascan(acombo_val,{|x| ckeys_pz $ x[1] }) ) <> 0

           * musíme nastavit startovací hodnotu
           ucetdohdw->ckeys_pz := acombo_val[nin, 1]
           ckeys_pz            := acombo_val[nin,1]
           drgComboBox:value   := drgComboBox:ovar:value := ckeys_pz

         endif
      endif
    ENDIF
  ELSE
    * základní nastaveni comb je v FIN_finance_IN
    ::FIN_finance_IN:comboBoxInit(drgComboBox)
  ENDIF
RETURN self


method FIN_ucetdohdzz_in:comboItemSelected(mp1,mp2,o)
  local  name  := lower(mp1:name), ovar := ::dm:get('m->typObratu', .F.)
  local  value := mp1:Value, values := mp1:values
  local  nin,pa

  do case
  case(name = ::hd_file +'->cobdobi'   )
    ::cobdobi(mp1)
  case(name = ::hd_file +'->ctyppohybu')
    nin := ascan(values,{|x| x[1] = value })
     pa := listasarray(values[nin,4])
    ovar:set(pa[1])
  case(name = ::hd_file +'->ckeys_pz'  )
    if ::showdialog
      nin := ascan(values,{|x| x[1] = value })

      if ::lnewRec
        ucetdohdw->ncenzakcel := values[nin,6]
        ::dm:set( 'ucetdohdw->ncenzakcel', values[nin,6] )
      endif
      *
      ucetdohdw->ckeys_pz   := values[nin, 1]
      ucetdohdw->nuhrCelFak := values[nin, p_uhrCelFak]
      ucetdohdw->nuhrCelFaZ := values[nin, p_uhrCelFaZ]
      ucetdohdw->czkratMenF := values[nin, p_zkratMenF]
      ucetdohdw->nkurzMenU  := CoalesceEmpty(values[nin, p_kurzMenU ], 1)
      ucetdohdw->nmnozPreU  := CoalesceEmpty(values[nin, p_mnozPreU ], 1)
      ::dm:refresh()
    endif
  endcase
return .t.


method FIN_ucetdohdzz_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  lOK   := .T., changed := drgVAR:itemChanged()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  if changed
    do case
    case( name = 'ucetdohdw->ndoklad')
      lOk := FIN_range_KEY(::range_key,value)[1]

      if lok .and. (::typ_zz = 'poh')
        if changed
          ucetdohdw->cdanDoklad := alltrim(str( value ))
          ::dm:has(::hd_file +'->cdanDoklad'):set(ucetdohdw->cdanDoklad)
        endif
      endif

    case( name = 'ucetdohdw->dvystdok')
      * zmìna rv_dph
      if .not. vykdph_iw->(dbseek( FIN_c_vykdph_ndat_od(value),, 'VYKDPH_6' ))
//      if  year(drgVar:prevValue) <> year(value)
         eval(drgVar:block,drgVar:value)
         fin_vykdph_cpy('ucetdohdw')
      endif

   case(name = 'ucetdohdw->cdic' .and. changed)
     ok := ::firmyico_sel()

    case(name = 'ucetdohdw->nzakldan_1' .and. changed)
      ucetdohdw->nsazdan_1 := mh_RoundNumb( (value/100) * ucetdohdw->nprocdan_1, ::roundDph )
      ::dm:set('ucetdohdw->nsazdan_1',ucetdohdw->nsazdan_1)

    case(name = 'ucetdohdw->nzakldan_2' .and. changed)
      ucetdohdw->nsazdan_2 := mh_RoundNumb( (value/100) * ucetdohdw->nprocdan_2, ::roundDph )
      ::dm:set('ucetdohdw->nsazdan_2',ucetdohdw->nsazdan_2)

    case(name = 'ucetdohdw->nzakldan_3' .and. changed)
      ucetdohdw->nsazdan_3 := mh_RoundNumb( (value/100) * ucetdohdw->nprocdan_3, ::roundDph )
      ::dm:set('ucetdohdw->nsazdan_3',ucetdohdw->nsazdan_3)

    endcase
  endif

  if(name = ::hd_file +'->nsazdan_2')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
**      ::postSave()
    endif
  endif

  if('ucetdohdw' $ name .and. lok, drgVAR:save(),nil)

  * modifikace vykdph_iw
  if( field_name $ 'nosvoddan,nzakldan_1,nsazdan_1,nzakldan_2,nsazdan_2,nzakldan_3,nsazdan_3') .and. changed
    ::fin_finance_in:FIN_vykdph_mod('ucetdohdw')
  endif
return lok


method FIN_ucetdohdzz_IN:firmyico_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, copy := .F.
  *
  local drgVar := ::dm:has('ucetDohdW->cdic')
  local value  := upper(drgVar:get())
  local lOk    := firmy ->(dbseek(value,,'FIRMY8')) .and. .not. empty(value)

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIR_FIRMYICO_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit
  ENDIF

  if (lOk .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
    mh_copyfld('firmy','ucetDohdW',,.f.)

    drgVar:set(firmy->cdic)
    drgvar:value = drgvar:initValue := drgvar:prevValue := firmy->cdic
  endif
return (nExit != drgEVENT_QUIT) .or. lOk


method FIN_ucetdohdzz_IN:postSave()
  local  ok :=  .f.

  if .not. ::lnewRec .and. ::is_danDokUsed <> 0
    ConfirmBox( ,'Daòový doklad _' +alltrim(str(ucetdohd->ndoklad)) +'_' +' nelze opravit, je již použit ...', ;
                 'Oprava daòového dokladu ...' , ;
                  XBPMB_CANCEL                  , ;
                  XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  else
    ok :=  FIN_ucetdohd_wrt(self)
  endif

  ::new_dok := .f.
return ok


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method FIN_ucetdohdzz_in:showGroup()
  local  x

  for x := 1 to len(::members) step 1
    if IsMemberVar(::members[x],'groups') .and. .not. Empty(::members[x]:groups)
      if .not. (::panGroup $ ::members[x]:groups)
        ::members[x]:oXbp:hide()
        if( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .F.)
      else
        ::members[x]:oXbp:show()
        if( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .T.)
      endif
    endif
  next
return self