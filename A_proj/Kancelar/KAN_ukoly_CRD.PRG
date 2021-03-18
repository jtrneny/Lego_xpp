#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"


#include "..\Asystem++\Asystem++.ch"


*  UKOLY
** CLASS KAN_ukoly_CRD *********************************************************
CLASS KAN_ukoly_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart, postValidate, onSave, destroy
  method  returnOsoba, osb_osoby_sel

HIDDEN:
 VAR    lnewrec
 VAR    msg, dm, dc, df, ab //, brow

ENDCLASS


METHOD KAN_ukoly_CRD:init(parent)

  ::drgUsrClass:init(parent)

  * pokud to volám ze SEL dialogù
  drgDBMS:open( 'ukoly' )
  drgDBMS:open( 'osoby' )

  * karta osoby volaná pro opravu z ... vodevšad 2 parametr je recNo()
  if len(pa_initParam := listAsArray(parent:initParam)) = 2
    parent:cargo := drgEVENT_EDIT
    ukoly->(dbgoTo( val( pa_initParam[2] )))
  endif

  ::lnewRec := .not. (parent:cargo = drgEVENT_EDIT)
  if( ukoly->(eof()), ::lnewRec := .t., nil )

  * TMP soubory
  drgDBMS:open('ukolyW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  ukolyW->(dbAppend())

  if ::lnewRec
    ukolyW->ncisUkolu  := ukoly->( Ads_GetKeyCount()) +1
    ukolyW->cjmenoRozl := logOsoba
    ukolyW->ddatPoriz  := date()

  else
    mh_copyFld( 'ukoly', 'ukolyW' )
  endif
RETURN self


METHOD KAN_ukoly_CRD:drgDialogStart(drgDialog)
  local  amembers := drgDialog:oForm:amembers, x
  *
  local  acolors  := MIS_COLORS
  local  pa_groups, nin

  *
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  *

/*
  ::oscisPrac  := ::dm:get( 'osobyW->nosCisPrac' , .F.)

  for x := 1 to len(amembers) step 1

    * font a barva u textù
    if  aMembers[x]:ClassName() = 'drgText' .and. .not. empty(aMembers[x]:groups)
      if 'SETFONT' $ aMembers[x]:groups
        pa_groups := ListAsArray(aMembers[x]:groups)
        nin       := ascan(pa_groups,'SETFONT')

        aMembers[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            aMembers[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          aMembers[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endif

    if lower(amembers[x]:ClassName()) $ 'drgdbrowse,drgebrowse'
      AAdd(::pao_brow, {x,amembers[x],val(amembers[x]:groups)})
    endif

    if ( amembers[x]:ClassName() = 'drgPushButton' .and. isCharacter( amembers[x]:event) )
      if lower( amembers[x]:event) = 'editparent'
        tabNum := val(amembers[x]:caption)

        ::paoB_editParent[tabNum] := amembers[x]
      endif
    endif
  next
*/
RETURN self


method KAN_ukoly_CRD:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  lOk   := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case (name = 'ukolyw->cjmerozlre')
    if empty( value)
      lOk := ::osb_osoby_sel()
    else
      lOK := ::returnOsoba(value)
    endif
  endcase


  if(lOk, eval(drgVar:block,drgVar:value), nil)
RETURN lOK


method kan_ukoly_crd:returnOsoba(value)
  local  filtr, cval, cnam, ncnt
  local  lOk := .t.

  if .not. osoby->( dbseek( upper(value),, AdsCTag(2)))
    cval  := Upper(AllTrim(value)+"*")
    cnam  := 'upper(cOsoba)'
    filtr := 'contains(' +cnam + ',"' +cval + '")'

    osoby->(ads_clearaof(), ads_setaof(filtr), DbGoTop())
    ncnt := osoby->( mh_COUNTREC())

    do case
    case ncnt = 0
     ::msg:writeMessage('Uživatel musí být zaøazen v seznamu osob...',DRG_MSG_ERROR)
     lOk := ::osb_osoby_sel(::drgDialog)
    case ncnt > 1
      lOk := ::osb_osoby_sel(::drgDialog)
    otherwise
      ::dm:set("ukolyW->cJmeRozlRe", osoby->cOsoba   )
      ::dm:set("ukolyW->nCisOsoRes", osoby->nCisOsoby)
    endcase
  else
    ::dm:set("ukolyW->cJmeRozlRe", osoby->cOsoba   )
    ::dm:set("ukolyW->nCisOsoRes", osoby->nCisOsoby)
  endif

  osoby->(ads_clearaof())
return lOk


method kan_ukoly_crd:osb_osoby_sel(drgDialog)
  local  odialog, nexit,  odrg := drgDialog:lastXbpInFocus:cargo
  local  lOk := .f.

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dm:set(odrg:name           , osoby->cosoba   )
    ::dm:set('ukolyW->nCisOsoRes', osoby->ncisOsoby)
    lOk := .t.
  endif
return lOk


METHOD KAN_ukoly_CRD:onSave(lIsCheck,lIsAppend)

  c_ukoly->( dbseek( ukolyW->czkrUkolu,,'C_UKOLY01'))
  ukolyW->ctypUkolu := c_ukoly->ctypUkolu

  if ::lNEWrec
    ukolyW->ncisUkolu := ukoly->( Ads_GetKeyCount()) +1
    mh_copyFld( 'ukolyW', 'ukoly', .t.)

  else
    if ukoly->( sx_Rlock())
      mh_copyFld( 'ukolyW', 'ukoly')

      ukoly->(dbUnlock())
    endif
  endif

  ukoly->( dbcommit())
  PostAppEvent(xbeP_Close,drgEVENT_SAVE,,::drgDialog:dialog)
RETURN .t.


METHOD KAN_ukoly_CRD:destroy()
 ::drgUsrClass:destroy()

RETURN SELF


*
**
/*
CLASS KAN_ukoly_SEL FROM drgUsrClass
EXPORTED:

  inline method init( parent )
    local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

    ::lsearch   := (::drgGet <> NIL)
    ::tabNumber := 1

    ::drgUsrClass:init(parent)
  return self


  inline method drgDialogStart(drgDialog)
    local  aPP  := drgPP:getPP(2), oColumn, x

    ::brow    := drgDialog:dialogCtrl:oBrowse
    ::msg     := drgDialog:oMessageBar             // messageBar
    ::dm      := drgDialog:dataManager             // dataMabanager
    ::dc      := drgDialog:dialogCtrl              // dataCtrl
    ::df      := drgDialog:oForm                   // form
    if isobject(drgDialog:oActionBar)
      ::ab      := drgDialog:oActionBar:members    // actionBar
    endif

    if ::lsearch
      for x := 1 TO ::brow:oXbp:colcount
        ocolumn := ::brow:oXbp:getColumn(x)
        ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
        ocolumn:configure()
      next
    endif

    ::zkrUkolu := ::dm:has('ukoly->czkrUkolu')
    ::arRelate := aclone(::zkrUkolu:odrg:arRelate)
  return self


  inline method onLoad( isApend )
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = xbeTab_TabActivate
      ::tabNumber := oxbp:cargo:tabNumber
      ::zkrUkolu:odrg:arRelate := if( oxbp:cargo:tabNumber = 1, nil, ::arRelate )

    case nEvent = xbeP_Keyboard
      if ( ::tabNumber = 2 .and. mp1 = xbeK_ESC, ::zkrUkolu:odrg:arRelate := nil, nil )

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        return .t.
      endif
    endcase
  return .f.



HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, tabNumber
  var    zkrUkolu
  var    arRelate
ENDCLASS
*/