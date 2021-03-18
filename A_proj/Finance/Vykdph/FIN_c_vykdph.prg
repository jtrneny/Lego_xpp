#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


*
** pozor obecná funkce pro získání hodnty klíèe ndat_od pro nastavení c_vykdph
** pro doklady pracující s datem UZP se sem pøedává toto datum
** pro èíselník se volá tato funkce s date()
*
function FIN_c_vykdph_ndat_od( date )
  local  retVal := 0

  do case
  * do 1.5.2004 do 31.21.2008
  case date >= ctod( '01.05.04') .and. date <= ctod( '31.12.08')
    retVal := 20040501

  * od 1.1.2004 do 31.12.2010
  case date >= ctod( '01.01.09') .and. date <= ctod( '31.12.10')
    retVal := 20090101

  * od 1.1.2011 do 31.3.2011
  case date >= ctod( '01.01.11') .and. date <= ctod( '31.03.11')
    retVal := 20110101

  * do 1.4.2001 do se zatím neví ?? už vìdí od 1.1.2015 je zmìna DPH
  case date >= ctod('01.04.11' ) .and. date <= ctod( '31.12.14')
    retVal := 20110401

* do 1.1.2015 do se zatím neví ??
  case date >= ctod('01.01.15' )
    retVal := 20150101

  endcase
return retVal


function FIN_c_vykdph_cradDph( date, cfile )
  local  retVal  := ''
  local  ndat_Od := FIN_c_vykdph_ndat_od( date )
  *
  local  pky := upper((cfile)->culoha) +upper((cfile)->ctypdoklad) +upper((cfile)->ctyppohybu)

  c_typpoh->(dbseek(pky,,'C_TYPPOH05'))

  do case
  case ndat_Od = 20040501 .or. ndat_Od = 20090101
    retVal := c_typPoh->craddph

  case ndat_Od = 20110101
    retVal := c_typPoh->craddph091

  case ndat_Od = 20110401
    retVal := c_typPoh->craddph114

  case ndat_Od = 20150101
    retVal := c_typPoh->craddph151

  endCase
return allTrim( retVal )


function FIN_c_vykdph_coddilKohl(lisEditKOHL)
  local aCOMBO_val

  default lisEditKOHL to .f.

  if lisEditKOHL
    aCOMBO_val := { { space(18)          , space(14)       }, ;
                    { padR('A.1'    , 18), padC('A.1'    , 14) }, { padR('A.2', 18), padC('A.2', 14) }, ;
                    { padR('A.3'    , 18), padC('A.3'    , 14) }, { padR('A.4', 18), padC('A.4', 14) }, ;
                    { padR('A.5'    , 18), padC('A.5'    , 14) }, ;
                    { padR('B.1'    , 18), padC('B.1'    , 14) }, { padR('B.2', 18), padC('B.2', 14) }, ;
                    { padR('B.3'    , 18), padC('B.3'    , 14) }                                        }

  else
    aCOMBO_val := { { space(18)          , space(14)       }, ;
                    { padR('A.1'    , 18), padC('A.1'    , 14) }, { padR('A.2', 18), padC('A.2', 14) }, ;
                    { padR('A.3'    , 18), padC('A.3'    , 14) }, { padr('A.4', 18), padC('A.4', 14) }, ;
                    { padR('A.5'    , 18), padC('A.5'    , 14) }, ;
                    { padR('A.4,A.5', 18), padC('A.4,A.5', 14) }, ;
                    { padR('B.1'    , 18), padC('B.1'    , 14) }, { padR('B.2', 18), padC('B.2', 14) }, ;
                    { padR('B.3'    , 18), padC('B.3'    , 14) }, ;
                    { padR('B.2,B.3', 18), padC('B.2,B.3', 14) }                                        }

  endif
return aCOMBO_val



FUNCTION FIN_c_vykdph_BC(nCOLUMn)
  LOCAL  xRETval := ''

  DO CASE
  CASE nCOLUMn == 0  ;  xRETval := IF( C_VYKDPH ->lSETS__DPH, 172, 0 )
  CASE nCOLUMn == 1  ;  xRetval := IF( C_VYKDPH ->nRADEK_DPH = 0, '', C_VYKDPH ->nRADEK_DPH)
  ENDCASE
RETURN(xRETVAL)


**
** CLASS for FIN_c_vykdph ******************************************************
CLASS FIN_c_vykdph FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postLastField, postValidate
  method  comboBoxInit, comboItemSelected

  **
  ** EVENT *********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  msg      := ::drgDialog:oMessageBar

    DO CASE
    CASE (nEvent = xbeBRW_ItemMarked)
      msg:WriteMessage(,0)
      ::showGroup()
      RETURN .F.

    CASE nEvent = drgEVENT_EDIT
      ::lastEditItem()
      ::drgDialog:oForm:setNextFocus('C_VYKDPH->nRADEK_DPH',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_APPEND
      msg:writeMessage('Pøidání položky VÝKAZU DPH, není povoleno ...',DRG_MSG_WARNING)
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      msg:writeMessage('Zrušení položky VÝKAZU DPH, není povoleno ...',DRG_MSG_WARNING)
      RETURN .T.

    case nEvent = drgEVENT_SAVE
*      ::restColor()
*      ::showGroup()
       ::postLastField()
      return .t.

    CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        ::drgDialog:oForm:setNextFocus(1,, .T. )
         RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR    postBlock, m_filter, obro, ndat_od

  METHOD showGroup
  METHOD lastEditItem

ENDCLASS


METHOD FIN_c_vykdph:init(parent)
  ::drgUsrClass:init(parent)

  ::m_filter := "ndat_od = %%"
  ::ndat_od  := FIN_c_vykdph_ndat_od( date() )

  drgDBMS:open('c_vykdph')
  drgDBMS:open('c_vykdph',,,,, 'c_vykdphs' )
  c_vykdph->(ads_setAof( format(::m_filter, { ::ndat_od })), dbgotop())
RETURN self


METHOD FIN_c_vykdph:drgDialogStart(drgDialog)
 local  x
 local  members    := drgDialog:oForm:aMembers

  ::postBlock := drgDialog:getMethod('postLastField')
  ::obro      := drgDialog:dialogCtrl:oBrowse[1]:oXbp

  for x := 1 TO Len(members) step 1
    do case
    case members[x]:ClassName() = 'drgComboBox'

      members[x]:oxbp:setFontCompoundName('9.Arial CE Bold')
      members[x]:oxbp:setColorFG(GRA_CLR_BLUE)
    endcase
  next

RETURN self


method FIN_c_vykdph:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  if(name = 'c_vykdph->cucetu_dph' .or. name = 'c_vykdph->lsets__dph') .and. ok
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(drgEVENT_SAVE,,, ::drgDialog:lastXbpInFocus)
    endif
  endif
return ok



METHOD FIN_c_vykdph:postLastField(drgVar)
  Local  dc     := ::drgDialog:dialogCtrl
  Local  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme C_VYKDPH na posledním PRVKU //
  IF ::drgDialog:dataManager:changed()
    IF REPLrec('C_VYKDPH')
       ::dataManager:save()
    ENDIF

    ::obro:refreshCurrent()
    ::drgDialog:oForm:setNextFocus(1,, .T.)
    C_VYKDPH ->( DbUnLock())
  ENDIF
RETURN .T.


method fin_c_vykdph:comboBoxInit(drgCombo)
  local  cname := lower( drgParseSecond(drgCombo:name,'>'))
  local  cKy, acombo_val := {}, cc

  do case
  case ( cname = 'selrok'     )
    c_vykdphs->( ordSetFocus( 'VYKDPH5' ), dbgoTop() )

    do while .not. c_vykdphs->(eof())
      cky    := allTrim( str(c_vykdphs->ndat_od))

      if ascan( acombo_val, { |a| a[1] = cky }) = 0
        cc     := subStr( cky, 7, 2) +'.' + ;
                  substr( cky, 5, 2) +'.' + ;
                  substr( cky, 1, 4)

        aadd( acombo_val, { cky, 'platný od ' +cc } )
      endif
      c_vykdphs->(dbSkip())
    enddo

  case ( cname = 'coddilkohl' )
    acombo_val := FIN_c_vykdph_coddilKohl()

  endcase

  drgCombo:oXbp:clear()
  drgCombo:values := ASort( acombo_val,,, {|aX,aY| aX[1] < aY[1] } )
  aeval(drgCombo:values, { |a| drgCombo:oXbp:addItem( a[2] ) } )

  if lower(cname) = 'selrok'
    * musíme nastavit startovací hodnotu *
    drgCombo:refresh( allTrim( str( ::ndat_od)) )
  endif
return self


method fin_c_vykdph:comboItemSelected(mp1,mp2,o)
  local  cname   := lower( drgParseSecond(mp1:name,'>'))
  local  ndat_od

   if lower(cname) = 'selrok'
     ndat_od := val(mp1:value)
     c_vykdph->(ads_setAof( format(::m_filter, { ndat_od })), dbgotop())

     ::obro:forceStable()
     ::obro:refreshAll()
     PostAppEvent(xbeBRW_ItemMarked,,,::obro)
     SetAppFocus(::obro)
   endif
return self


**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_c_vykdph:showGroup()
  LOCAL  nIn
  LOCAL  pA := {'c_vykdph->nradek_dph', 'c_vykdph->cucetu_dph', 'c_vykdph->lsets__dph' }
  LOCAL  drgVar, dm := ::dataManager

  FOR nIn := 1 TO LEN(pA)
    drgVar := dm:has(pA[nIn]):oDrg
    IF   nIn < 3 ; drgVar:isEdit := (C_VYKDPH ->nRADEK_DPH <> 0)
                   drgVar:oXbp:setColorBG(IF( drgVar:isEdit, GRA_CLR_WHITE, GRA_CLR_BACKGROUND))
    ELSE         ; drgVar:isEdit := (AScan( { 30,32,33 }, c_VYKDPH ->nODDIL_dph ) <> 0)
                   IF( drgVar:isEdit, drgVar:oXbp:show(), drgVar:oXbp:hide() )
    ENDIF
  NEXT
RETURN self


METHOD FIN_c_vykdph:lastEditItem()
  LOCAL  values := ASize( ::drgDialog:dataManager:vars:values,::drgDialog:dataManager:vars:size() )
  LOCAL  drgVar
  Local  nIn

  AEval(values, {|X,N| ( drgVar := X[2]:oDrg                                                  , ;
                         IF( IsMemberVar( drgVar, 'postBlock'), drgVar:postBlock := NIL, NIL ), ;
                         IF( drgVar:isEdit                    , nIn := N               , NIL )  ) })
  IF( nIn <> 0, values[nIn,2]:oDrg:postBlock := ::postBlock, NIL )
RETURN self