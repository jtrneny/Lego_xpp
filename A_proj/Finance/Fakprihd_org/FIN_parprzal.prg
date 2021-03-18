#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "drg.ch"
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


#define     GetDBVal(c)   Eval( &("{||" + c + "}"))


/*
BRO-column
  5           6           7           8
  NCENZALFAK  NCENZAHFAK  NPARZALFAK  NPARZAHFAK

TYPY vstupních karet --nFINTYP--                                        --párování záloh--
1 -> FAKPB  ->  FAKP       ... Faktura pøijatá bìžná                      x    5,7 - zobrazit / 8,6 - zrušit
2 -> FAKPC  ->  FAKPCEL    ... Faktura pøijatá celní                      -
3 -> FAKPZ  ->  FAKPZAL    ... Faktura pøijatá zálohová                   -
4 -> FAKPZB ->  FAKPZAH    ... Faktura pøijatá zahranièní                 x    6,8 - zobrazit / 7,5 - zrušit
5 -> FAKPZZ ->  FAKZAHZAL  ... Faktura pøijatá zahranièní zálohová        -
6 -> FAKPEU ->  FAKPEURO   ... Faktura pøijatá EURo                       x    6,8 - zobrazit / 7,5 - zrušit
*/


*
** CLASS for FIN_parprzal ******************************************************
CLASS FIN_parprzal FROM drgUsrClass, fin_finance_in
exported:
  var     hd_file, it_file, varSym, parFak, butRv, sumPar
  var     cTYPdan, nPROCdan, nZAKLdan
  *
  var     m_filter

  method  init, drgDialogStart, postAppend, postDelete, postValidate, postLastField
  method  parprzal_cvarsym_vld, parprzal_vykdph_in
  *

 inline method  postEscape()
   local  cisZal_fak := ::dm:get(::it_file +'->ncisZalFak')

   if ::varSym:odrg:isEdit
     vykdph_pw->(dbeval( { || if( vykdph_pw->ncisFak = cisZal_fak, vykdph_pw->(dbdelete()), nil ) } ))
   endif
   return self


  inline method  drgDialogEnd()
    return self

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local ok, field_name

    do case
    case nEvent = xbeBRW_ItemMarked

      if oxbp:className() = 'XbpBrowse'
        ok := vykdph_pw->(dbseek(parprzalw->nciszalfak,,'VYKDPH_6'))

        ::parFak:odrg:oxbp:align := if(ok, XBPSLE_LEFT, XBPSLE_RIGHT)
        ::parFak:odrg:oxbp:configure()

        if( ok, ( ::butRv:oxbp:configure():show(), ::butRv:enable()) , ;
                ( ::butRv:oxbp:hide()            , ::butRv:disable())  )


        if .not. (::it_file)->(eof())
          (::varSym:odrg:isEdit := .f., ::varSym:odrg:oxbp:disable())
        endif
      endif

    case nEvent = xbeP_Keyboard
      * blokování položek
      if oxbp:className() = 'XbpGet' .and. ::butRv:oxbp:isVisible() .and. ::isTuz
        if oxbp:cargo:ovar = ::parFak
          if mp1 >= 32 .and. mp1 <= 255
          return .t.
          endif
        endif
      endif

    case nEvent = drgEVENT_SAVE .and. oxbp:className() = 'XbpBrowse'
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
      return .t.

    endcase

    return ::handleEvent(nEvent, mp1, mp2, oXbp)

hidden:
  var     nfintyp, drgget
  method  parprzal_cvarsym_sel, parprzal_vykdph_sel

  inline access assign method isTuz() var isTuz
  return Equal(SysConfig('Finance:cZaklMena'), fakprihdw->czkratMenz)

  * suma
  inline method sumColumn(column)
    local  sumPar := 0, isTuz := ::isTuz
    local  sumCol := ::brow:getColumn(column)

    parprzi_w->(dbgotop(), ;
                dbeval({ || sumPar += if(isTuz, parprzi_w->nparzalFak,parprzi_w->nparzahFak)}, ;
                       { || parprzi_w->_delRec <> '9' }  ))

    sumCol:Footing:hide()
    sumCol:Footing:setCell(1,str(sumPar))
    sumCol:Footing:show()
    ::sumPar := sumPar
  return sumPar
ENDCLASS


method FIN_parprzal:init(parent)

  (::hd_file := 'fakprihdw', ::it_file := 'parprzalw')
  ::drgUsrClass:init(parent)
return self


method FIN_parprzal:drgDialogStart(drgDialog)
  local  zkrMeny  := fakprihdw->czkratMenz
  local  zaklMena := SysConfig('Finance:cZaklMENA')
  *
  local  disPar  := 'parprzalw->npar' +if(::isTuz,'zah', 'zal') +'fak', odrg

  ::fin_finance_in:init(self,'xxx','parprzalw->cvarzalfak','_párované zálohy_',.t.)
  ::m_filter := drgDialog:parent:UDCP:m_filter_parPrZal

  ::nfinTyp := if(fakprihdw->nfinTyp = 1 .and. zkrMeny = zaklMena, 1, 2)

  if(::nfintyp = 1, (::brow:delcolumn(8), ::brow:delcolumn(6)), ;
                    (::brow:delcolumn(7), ::brow:delcolumn(5))  )

  ::brow:getColumn(5):heading:setCell(1,'záloha v '   +zkrMeny)
  ::brow:getColumn(6):heading:setCell(1,'pøevzato v ' +zkrMeny)

  odrg := ::dm:has(disPar):odrg
  (odrg:isEdit := .f., odrg:oxbp:hide(), odrg:pushGet:oxbp:hide())
  *
  ::varSym     := ::dm:get(::it_file +'->cvarzalfak'                         , .f.)
  ::parFak     := ::dm:get('parprzalw->npar' +if(::isTuz, 'zalfak', 'zahfak'), .f.)
  ::butRv      := ::parFak:odrg:pushGet
  *
  ::sumColumn(6)
return


method FIN_parprzal:postAppend()
  (::varSym:odrg:isEdit := .T., ::varSym:odrg:oxbp:enable())
return .t.


method FIN_parprzal:postDelete()

  if( parprzalw->_nrecor = 0, parprzalw->(dbDelete()), nil )
  ::sumColumn(6)
return .t.


method FIN_parprzal:postValidate(drgVar)
  local  value := drgVar:get(), name := Lower(drgVar:name)
  *
  local  ok, cisFak
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case(name = ::it_file +'->cvarzalfak')
    cisFak := ::dm:get(::it_file +'->nciszalfak')

    ok := vykdph_pw->(dbseek(cisFak,,'VYKDPH_6'))

    ::parFak:odrg:oxbp:align := if(ok, XBPSLE_LEFT, XBPSLE_RIGHT)
    ::parFak:odrg:oxbp:configure()

    if( ok, ( ::butRv:oxbp:configure():show(), ::butRv:enable()) , ;
            ( ::butRv:oxbp:hide()            , ::butRv:disable())  )

    ::parFak:odrg:oxbp:setData(::parFak:value)
  endcase

  if(drgVar = ::parFak)
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      ::postLastField()
    endif
  endif
return .t.


METHOD FIN_PARPRZAL:postLastField(drgVar)
  local  isChanged := ::dm:changed()

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    ::itSave()
    *
    if ::state = 2
      parprzalw->ncisFak    := fakprihd->ncisfak
      parprzalw->norditem   := 1000 +parprzalw->(recno())
      parprzalw->ncenzalFak := fakprihd->ncenzakCel
      parprzalw->ncenzahFak := fakprihd->ncenzahCel
      parprzalw->nuhrzalFak := fakprihd->nuhrcelFak
      parprzalw->nuhrzahFak := fakprihd->nuhrcelFaz
      parprzalw->duhrzalFak := fakprihd->dposuhrFak
      parprzalw->cucet_pucR := fakprihd->cucet_pucR
      parprzalw->cucet_pucS := fakprihd->cucet_pucS
    endif

    parprzalw->dparzalFak := date()
    if ::isTuz
      parprzalw->nparZahFak := parprzalw->nparZalFak
    else
      parprzalw->nparZalFak := parprzalw->nparZahFak *(fakprihd->nkurZahMen/ fakprihd->nmnozPrep)
    endif

    if ::state = 2
      ::brow:gobottom()
      ::brow:refreshAll()
    else
      ::brow:refreshCurrent()
    endif
  endif

  ::setfocus(::state)
  ::sumColumn(6)
  ::dm:refresh()
RETURN .T.


*
** sel/vld medhod **************************************************************
method FIN_parprzal:parprzal_cvarsym_vld(drgDialog)
  local  odialog, nexit, varsym_sel
  *
  local  drgVar := ::dm:get(::it_file +'->cvarzalfak', .F.)
  local  value  := drgVar:get(), cntDokl := 0, ok := .t., showDlg := .t.

  if IsObject(drgDialog) .or. drgVar:changed()
    fakprihd->(AdsSetOrder(2),DbSetScope(SCOPE_BOTH,value), DbGoTop(), DbEval({|| cntDokl++}), dbclearscope())

    do case
    case cntDokl = 0         // nenasel žádný doklad
      ok      := .f.
    case cntDokl > 1         //   našel   víc dokladù
      ok      := .f.
    case cntDokl = 1         //   našel jeden doklad
      ok      := .t.
      showDlg := isobject(drgDialog)
      fakprihd->(dbseek(value,,'FPRIHD2'))
    endcase

    if showDlg
      odialog := drgDialog():new('FIN_parprzal_cvarsym_sel', ::drgDialog)
      odialog:cargo := if( cntDokl = 1,'fakprihdw,' +value +',2',Nil)
      odialog:create(,,.T.)
      nexit := oDialog:exitState
    endif

    if( nexit = drgEVENT_SELECT .or. ok)
      ::parprzal_cvarsym_sel()
      ::parprzal_vykdph_sel()
      drgVar:initValue := drgVar:prevValue := drgVar:value
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
      ::dm:refresh()
    endif

    if(showDlg,odialog:destroy(.T.),nil)
    odialog := Nil
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method FIN_parprzal:parprzal_cvarsym_sel()
  local  x, cname, value, pos := 1, pai
  local  pa  := { {'cvarzalfak' , 'fakprihd->cvarsym'                     }, ;
                  {'cuctzalfak' , 'fakprihd->cucet_uct'                   }, ;
                  {'ctextfakt'  , 'fakprihd->ctextfakt'                   }, ;
                  {'nciszalfak' , 'fakprihd->ncisfak'                     }, ;
                  {'duhrzalfak' , 'fakprihd->dposuhrfak'                  }, ;
                  {'nparzalfak' , 'fin_parprzal_csym_bc(9)', 'nparzahfak' }, ;
                  {'czkratmenz' , 'fakprihdw->czkratmenz'                 }  }

  *
  local  ouFile    := ::it_file +'->'
  local  equalMena := Equal(fakprihdw->czkratmeny,fakprihd->czkratmenz)

  for x := 1 to Len(pa) step 1
    do case
    case At(':', pa[x,2]) <> 0       // metoda
      cname := Substr(pa[x,2],2)
      value := self:&cname(file_iv,equalMena)

    case At('(', pa[x,2]) <> 0       // funkce
      value := DBGetVal(pa[x,2])

    case At('->',pa[x,2]) <> 0       // hodnota z jiného souboru
      cname := pa[x,2]
      value := DBGetVal(cname)

    otherwise
      value := DBGetVal(file_iv +'->' +pa[x,2])
    endcase

    if IsObject(ovar := ::dm:has(ouFile +pa[x,1]))
      pos    := if( Len(pa[x]) = 3, if(::isTuz,1,3), 1)
      ::dm:set(ouFile +pa[x,pos], value)
    endif
  next
return .t.
**

method FIN_parprzal:parprzal_vykdph_sel()
  local  cky    := upper(fakprihd ->cdenik) +strZero(fakprihd ->ncisFak,10)
  local  cky_in := upper(fakprihdw->cdenik) +strZero(fakprihdw->ncisFak,10)
  local  isIn, cin_ky
  *
  local  cdenik_dd := SYSconfig('FINANCE:cDENIKfdpz'), cky_pz

  vykdph_i->(AdsSetOrder('VYKDPH_5'), dbsetscope(SCOPE_BOTH,cky), dbgotop())
  do while .not. vykdph_i->(eof())
    cky_pz := vykdph_i->(sx_keyData()) +strZero(vykdph_i->nradek_dph,3)

    if cdenik_dd == vykdph_i->cdenik
      cin_ky := cky_in                           + ;
                strzero(vykdph_i->noddil_dph, 2) + ;
                strZero(vykdph_i->nradek_dph, 3) + ;
                strZero(vykdph_i->ncisFak   ,10)

      mh_copyFld('vykdph_i','vykdph_pw',.t., .f.)
      *
      vykdph_pw->ndoklad    := fakprihdw->ncisFak
      vykdph_pw->cdenik     := fakprihdw->cdenik
      vykdph_pw->cobdobi    := fakprihdw->cobdobi
      vykdph_pw->nrok       := fakprihdw->nrok
      vykdph_pw->nobdobi    := fakprihdw->nobdobi
      vykdph_pw->cobdobiDan := fakprihdw->cobdobiDan
      vykdph_pw->nzakld_zal := vykdph_pw->nzakld_or
      vykdph_pw->nsazba_zal := vykdph_pw->nsazba_or
      *
      ucetdohd->(dbseek(upper(vykdph_i->cdenik_par) +strzero(vykdph_i->ncisFak,10),,'UCETDH_7'))
      vykdph_pw->cucetu_dok := ucetdohd->cucet_uct
      *
      vykdph_pw->nUhrCelFAK := ucetdohd->nUhrCelFAK
      vykdph_pw->nUhrCelFAZ := ucetdohd->nUhrCelFAZ
      vykdph_pw->cZkratMenF := ucetdohd->cZkratMenF
      vykdph_pw->nKurzMenU  := CoalesceEmpty(ucetdohd->nKurzMenU,1)
      vykdph_pw->nMnozPreU  := CoalesceEmpty(ucetdohd->nMnozPreU,1)
      vykdph_pw->cky_pz     := cky_pz
      *
      vykdph_pw->nzakld_dph := vykdph_pw->nzakld_zal * (-1)
      vykdph_pw->nsazba_dph := vykdph_pw->nsazba_zal * (-1)
      vykdph_pw->lis_zal    := .t.
      vykdph_pw->nporadi    := 1
      *
    endif
    vykdph_i->(dbskip())
  enddo
  *
  ** odeèteme již párované èástky záloh
  vykdph_i->(dbgoTop())

  do while .not. vykdph_i->(eof())
    cky_pz := vykdph_i->(sx_keyData()) +strZero(vykdph_i->nradek_dph,3)

    if vykdph_i->cdenik = fakprihdw->cdenik
      if vykdph_pw->(dbseek(cky_pz,,'VYKDPH_8'))
        vykdph_pw->nzakld_or  -= vykdph_i->nzakld_zal
        vykdph_pw->nsazba_or  -= vykdph_i->nsazba_zal
        *
        vykdph_pw->nzakld_zal -= vykdph_i->nzakld_zal
        vykdph_pw->nsazba_zal -= vykdph_i->nsazba_zal
        *
        vykdph_pw->nzakld_dph := vykdph_pw->nzakld_zal * (-1)
        vykdph_pw->nsazba_dph := vykdph_pw->nsazba_zal * (-1)
      endif
    endif
    vykdph_i->(dbskip())
  enddo
return self


method FIN_parprzal:parprzal_vykdph_IN(drgDialog)
  local  oDialog, nExit
  local  cisFak := ::dm:get(::it_file +'->nciszalfak'), ;
         parFak := ::dm:get(::it_file +'->nparZalFak')
  *
  local  filter := format("ncisfak = %% .and. nzakld_or <> 0",{cisFak})

  vykdph_pw->(dbSetfilter(COMPILE(filter)), dbgotop())

  oDialog := drgDialog():new('FIN_parzalfak_vykdph_IN',drgDialog)
  oDialog:cargo_usr := parFak
  oDialog:create(,,.T.)

*  musíme naplnit, parprzalw->nparZalFak i parprzalw->nparZahFak
*  v podstatì je jedno kterou edituje, ale naplnit se musí po návratu z RV obì

  ::dm:set( 'parprzalw->nparZalFak', oDialog:udcp:uplatneno + oDialog:udcp:uplatneno_zFA )
  ::dm:set( 'parprzalw->nparZahFak', oDialog:udcp:uplat_v_cm                             )

  vykdph_pw->(dbclearfilter(), dbgotop())
  oDialog:destroy(.T.)
  oDialog := NIL
return self




*
** CLASS for FIN_parprzal_csym *************************************************
function FIN_parprzal_csym_bc(col)
  local  isTuz    := (fakprihdw->czkratMenz = SysConfig('Finance:cZaklMENA'))
  *
  local  finTyp := IF( FAKPRIHDw ->nFINtyp = 1 .and. isTuz, 1, 2)
  *
  local  cel := GetDBVal( 'FAKPRIHD ->' +if(finTyp = 1,'nCENZAKCEL', 'nCENZAHCEL')), ;
         uhr := GetDBVal( 'FAKPRIHD ->' +if(finTyp = 1,'nUHRCELFAK', 'nUHRCELFAZ')), ;
         par := GetDBVal( 'FAKPRIHD ->' +if(finTyp = 1,'nPARZALFAK', 'nPARZAHFAK'))
  local  val := 0, parZal := 0, isIn := FIN_parprzal_csym_in()

  do case
  case(col =  1) ; val := if( cel == uhr, H_big, if( uhr == 0, 0, H_low ))
  case(col =  2) ; val := if( uhr == par, P_big, if( par == 0, 0, P_low ))
  case(col =  3) ; val := if( isIn      , MIS_ICON_OK, 0)
  case(col =  6)
    ucetdohd->(dbseek(upper(fakprihd->cdenik) +strzero(fakprihd->ncisFak,10),,'UCETDH_7'))
    val := ucetdohd->ndoklad

  case(col =  7) ; val := cel
  case(col =  8) ; val := uhr
  case(col =  9)
    if isIn
      parZal := GetDBVal( 'parprzi_w->' +if(finTyp = 1, 'nPARZALFAK', 'nPARZAHFAK'))
      parZal := parZal * if( parprzi_w->_delrec = '9', +1, 0 )    // -1)
    endif
    val := uhr -par +parZal
  case(col = 10) ; val := GetDBVal('FAKPRIHD ->' +if(finTyp = 1, 'cZKRATMENY', 'cZKRATMENZ'))
  endCase
return val


static function FIN_parprzal_csym_in()
return parprzi_w->(dbseek(fakprihdw->ncisFak,, AdsCtag(2) ))


CLASS FIN_parprzal_cvarsym_sel FROM drgUsrClass
EXPORTED:
  var     drgGet
  method  init, destroy, getForm, drgDialogInit, drgDialogStart
  method  createContext, fromContext


  * event **********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close,drgEVENT_SELECT,,::drgDialog:dialog)
      return .t.

    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_FORMDRAWN
      Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR  parent, m_filter, filter, drgPush, popState

ENDCLASS


method FIN_parprzal_cvarsym_sel:getForm()
  local  oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 97,12.6 DTYPE '10' TITLE 'Seznam urazených záloh dodavatele ...' ;
                                             GUILOOK 'All:N,Border:Y'

  DRGSTATIC INTO drgFC FPOS 0,0 SIZE 73,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC CAPTION '['  CPOS  2,.1 CLEN  2 FONT 5
    DRGTEXT INTO drgFC CAPTION ''   CPOS  3,.1 CLEN 55 CTYPE 1
    odrg:caption := str(fakprihdw->ncisFirmy)           +' ' + ;
                    left(alltrim(fakprihdw->cnazev),25) +' ' + ;
                    alltrim(fakprihdw->csidlo)          +'  ièo: ' + ;
                    str(fakprihdw->nico)
    DRGTEXT INTO drgFC CAPTION ']'  CPOS 60,.1 CLEN  2 FONT 5
  DRGEND  INTO drgFC

  DRGDBROWSE INTO drgFC FPOS 0,1.4 SIZE 97,9.6 FILE 'FAKPRIHD'        ;
    FIELDS 'FIN_parprzal_csym_bc(1):H:2.6::2,'                       + ;
           'FIN_parprzal_csym_bc(2):P:2.6::2,'                       + ;
           'nCISFAK:èísFaktury:10,'                                  + ;
           'cVARSYM:varSymbol,'                                      + ;
           'dVYSTFAK:datVyst,'                                       + ;
           'FIN_parprzal_csym_bc(6):daòový_dokl:10,'                 + ;
           'FIN_parprzal_csym_bc(7):záloha:13,'                      + ;
           'FIN_parprzal_csym_bc(8):úhrada:13,'                      + ;
           'FIN_parprzal_csym_bc(9):k uplanìní:13,'                  + ;
           'FIN_parprzal_csym_bc(10):v:4'                              ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'

  DRGPUSHBUTTON INTO drgFC CAPTION 'k uplatnìní' POS 74,.2 SIZE 20,1.2 ;
                EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'
  DRGPUSHBUTTON INTO drgFC POS 94,.2 SIZE 3,1.2 ATYPE 1 ICON1 102 ICON2 202 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
return drgFC


method FIN_parprzal_cvarsym_sel:init(parent)
  local nEvent,mp1,mp2,oXbp, par
  *
  drgDBMS:open('ucetdohd')

  ::parent := parent:parent
  ::parent:pushArea()
  ::m_filter := ::parent:UDCP:m_filter   /// fakprihd->(ads_getAof())
  ::popState := 1

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL )

  par      := if(fakprihdw->nfinTyp = 1,'nparZalFak', 'nparZahFak')
  ::filter := ::m_filter +" .and. (nuhrCelFak <> nparZalFak)"
  fakprihd->(ads_setAof(::filter))

  ::drgUsrClass:init(parent)
return self


method FIN_parprzal_cvarsym_sel:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  endif
return


method FIN_parprzal_cvarsym_sel:drgDialogStart(drgDialog)
  local members  := drgDialog:oForm:aMembers

  if IsObject(::drgGet)
    if( .not. FAKPRIHD ->(DbSeek(::drgGet:oVar:value,,'FPRIHD2')), FAKPRIHD ->(DbGoTop()), NIL )
    drgDialog:odbrowse[1]:oxbp:refreshAll()
  endif

  for x := 1 TO LEN(members) step 1
    if members[x]:ClassName() = 'drgPushButton'
      if( ischaracter(members[x]:event), ::drgPush := members[x], nil)
    endif
  next

  ::drgPush:oXbp:setFont(drgPP:getFont(5))
  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
return self


method FIN_parprzal_cvarsym_sel:createContext()
  LOCAL cSubMenu, oPopup, aPos, aSize, x, pa, nIn
  *
  local popUp := 'k uplatnìní, kompletní seznam'

  pA       := ListAsArray(popup)
  cSubMenu := drgNLS:msg(popUp)
  oPopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 TO LEN(pA) step 1
    oPopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  oPopup:disableItem(::popState)

  aPos    := ::drgPush:oXbp:currentPos()
  oPopup:popup(::drgDialog:dialog, aPos)
return self


method FIN_parprzal_cvarsym_sel:fromContext(aOrder, nMENU)
  local  obro := ::drgDialog:odbrowse[1]

  ::popState := aOrder
  ::drgPush:oText:setCaption(nMENU)

  do case
  case(aOrder = 1)  ;  fakprihd->(ads_setAof(::filter))
  case(aOrder = 2)  ;  fakprihd->(ads_setAof(::m_filter))
  endcase

  fakprihd->(dbgotop())
  obro:oxbp:refreshAll()
return self


METHOD FIN_parprzal_cvarsym_sel:destroy()
  ::parent:popArea()

  ::drgGet   := ;
  ::parent   := NIL

  fakprihd->(ads_setAof(::m_filter))
RETURN