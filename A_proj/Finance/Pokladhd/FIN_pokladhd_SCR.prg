#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' , 'uzavisoz', 'dphdada' , 'dph_2001','dph_2004' , ;
                   'datkomhd', 'pokladhd', 'pokladms', 'pokza_za'              }


FUNCTION FIN_POKLADHD_BC(nCOLUMn)
  LOCAL  xRETval := 0

  pokladms->(dbseek(pokladhd->npokladna,,'POKLADM1'))

  * SCR *
  DO CASE
  CASE nCOLUMn == 8
    xRETval := IF(POKLADMS->lISTUZ_UC,POKLADHD ->nCENZAKCEL,POKLADHD ->NCENZAHCEL)
  CASE nCOLUMn = 52
    xRETval := IF(POKLADMS->lISTUZ_UC,POKLADIT ->nCENZAKCEL,POKLADIT ->NCENZAHCEL)
  ENDCASE
RETURN(xRETval)


**
** CLASS for FIN_banvyphd_SCR **************************************************
CLASS FIN_POKLADHD_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, ain_file, oinf
  method  init, drgDialogStart, itemMarked, tabSelect

  * hd - broColumn  _ 2
  inline access assign method typPohybu() var typPohybu
    return if(pokladhd->ntypdok = 1, MIS_PLUS , ;
           if(pokladhd->ntypdok = 2, MIS_MINUS, MIS_BOOKOPEN))

  * it - browColumn _ 6
  inline access assign method typObratu() var typObratu
  return if(pokladit->ntypobratu = 1, 304, 305 )


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.


HIDDEN:
  VAR     tabnum, brow, npokladna, comboBox, zaklMena
  method  postDelete
ENDCLASS


METHOD FIN_pokladhd_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::tabnum   := 1
  ::lnewRec  := .f.

  * vstupní soubory pro kontrolu na csymol
  ::ain_file := {{'fakprihd', 0, 0, 1,  9, SysConfig('FINANCE:cDENIKFAPR')}, ;
                 {'fakvyshd', 0, 0, 2, 10, SysConfig('FINANCE:cDENIKFAVY')}  }

 * základní soubory
  ::openfiles(m_files)

  ** likvidace
  ::FIN_finance_in:typ_lik := 'pok'
  ::oinf  := fin_datainfo():new('POKLADHD')
RETURN self


METHOD FIN_pokladhd_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
*-  POKLADHD ->( DBGoBottom())
RETURN


METHOD FIN_pokladhd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


METHOD FIN_pokladhd_SCR:itemMarked()
  LOCAL  cky, cinfo

  ::npokladna := POKLADHD ->nPOKLADNA

  cky := StrZero(POKLADHD ->nDOKLAD,10)
  pokladit->(ordSetFocus( 'BANKVY_1' ))
**  pokladit->(ordSetFocus( 'POKLADIT1') )
  POKLADIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())

  cky := upper(pokladhd ->cdenik) +strzero(pokladhd->ndoklad,10)
  ucetpol->(AdsSetOrder('UCETPOL1'), dbsetscope(SCOPE_BOTH,cky), dbgotop())

  cky := upper(pokladhd ->cdenik) +strzero(pokladhd->ndoklad,10)
  vykdph_i->(dbsetscope(SCOPE_BOTH,cky), dbGoTop())

  pokladMs->( dbseek( pokladHd->nPokladna ,, 'POKLADM1' ))
  datkomhd->( dbseek( pokladms->cidDATkomE,, 'DATKOMH01'))

  cinfo := pokladMs->cnazPoklad +' aktuální stav ' +str(pokladms->naktStav) +' ' +lower(pokladMs->czkratMeny)
  drgMsg(drgNLS:msg( cinfo), DRG_MSG_INFO, ::drgDialog)
RETURN self


method FIN_pokladhd_SCR:postDelete()
  local  oinf := fin_datainfo():new('POKLADHD'), nsel, nodel := .f.

  if oinf:danuzav() = 0 .and. oinf:ucuzav() = 0 .and. oinf:stavEet() <> 556  // 556 - zelená odeslán do EET
    nsel := ConfirmBox( ,'Požadujete zrušit pokladní doklad _' +alltrim(str(pokladhd->ndoklad)) +'_', ;
                         'Zrušení pokladního dokladu ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      fin_pokladhd_cpy(self)
      nodel := .not. fin_pokladhd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Pokladní doklad _' +alltrim(str(pokladhd->ndoklad)) +'_' +' nelze zrušit ...' +CRLF +CRLF + ;
                 '         ... NELZE ZRUŠit DOKLAD ...' , ;
                 'Zrušení pokladního dokladu ...' , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE)
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


*
** CLASS for FIN_pokladms_SEL **************************************************
CLASS FIN_pokladms_SEL FROM drgUsrClass
exported:
  method  init, getForm, drgDialogInit, drgDialogStart

  * bro col for pokladms
  inline access assign method pokl_isEET() var pokl_isEET
    return if( 'EET' $ pokladms->ctypPoklad, 559, 0 )

  inline access assign method isDatKomE() var isDatKomE
    local  is_IdDatKomE := .not. empty(pokladms->cIdDatKomE)
    local  is_defin_kom := .not. empty(pokladms->mdefin_kom)
    local  retVal       := 0

    do case
    case ( is_IdDatKomE .and.       is_defin_kom )
      retVal := 556   //  m_zelena.bmp

    case ( is_IdDatKomE .and. .not. is_defin_kom )
      retVal := 555   //  m_Zluta.bmp
    endCase
    return retVal

  inline access assign method pokl_inDPH() var pokl_inDPH
     return if( pokladms->lno_inDPH, 301, 0 )  // MIS_ICON_ERR


  * C_TYPPOH09.ctypPohybu  ->  cnazTypPoh
  inline method info_in_msgStatus()
    local  msgStatus := ::msg:msgStatus, picStatus := ::msg:picStatus
    local  ncolor, cinfo, oPs
    *
    local  curSize  := msgStatus:currentSize()
    local  oFont    := XbpFont():new():create( "10.Arial Bold CE" )
    local  aAttr    := ARRAY( GRA_AS_COUNT )

    local  paColors := { { graMakeRGBColor( {  0, 183, 183} ), graMakeRGBColor( {174, 255, 255} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {251,  51,  40} ), graMakeRGBColor( {254, 183, 173} ) }  }
    *
    local  ctypPohybu := if( empty(pokladms->ctypPohybu), ::typPohybu, pokladms->ctypPohybu )
    local  cnazTypPoh, npokladEET

    c_typPoh->( dbseek( ctypPohybu,,'C_TYPPOH09'))
    cnazTypPoh := c_typPoh->cnazTypPoh
    npokladEET := c_typPoh->npokladEET

    msgStatus:setCaption( '' )
    picStatus:hide()

    if .not. empty(cnazTypPoh)
      ncolor := 1
      cinfo  := cnazTypPoh

      oPs := msgStatus:lockPS()
      GraGradient( oPs, {  0, 0 }    , ;
                        { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )

      GraSetFont( oPS, oFont )
      aAttr[GRA_AS_COLOR] := GRA_CLR_RED
      GraSetAttrString( oPS, aAttr )

      graStringAT( oPs, { 20, 4 }, cinfo )

      aAttr[GRA_AS_COLOR] := GRA_CLR_WHITE
      GraSetAttrString( oPS, aAttr )
      graStringAT( oPs, { 21, 4 }, cinfo )

      msgStatus:unlockPS()

      if npokladEET = 1
        picStatus:setCaption(DRG_ICON_MSGWARN)
        picStatus:show()
      endif
    endif
  return


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = xbeBRW_ItemMarked
      ::info_in_msgStatus()
**      ::msg:WriteMessage(,0)

      c_meny->(dbseek(upper(pokladms->czkratMeny),,'C_MENY1'))
      ::parent:showGroup(pokladms->listuz_uc)
      return .f.

    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      ::is_selOk := .t.
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
      return .t.

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
       return .T.

    case nevent = xbeP_Close
      if .not. ::is_selOk
        ::msg:WriteMessage('Èíslo pokladny je povinný údaj ...',DRG_MSG_WARNING)
      endif
      return .f.

    case nEvent = xbeP_Keyboard
     if mp1 == xbeK_ESC .and. .not. ::is_selOk
       ::msg:WriteMessage('Èíslo pokladny je povinný údaj ...',DRG_MSG_WARNING)
     endif
     return .f.

    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  VAR  drgGet, parent, typPohybu, msg, is_selok
ENDCLASS


method FIN_pokladms_SEL:init(parent)

  drgDBMS:open('c_typPoh')

  ::drgget    := parent:cargo
  ::parent    := parent:parent:udcp
  ::typPohybu := sysconfig('finance:ctyppohPOK')

  ::drgUsrClass:init(parent)

  ::is_selOk := .f.
return self


method FIN_pokladms_SEL:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 64,7 DTYPE '10' TITLE 'Výbìr pokladny ...' ;
                                           FILE 'POKLADMS'           ;
                                           GUILOOK 'Action:n,IconBar:n,Menu:n,Border:y'

  DRGDBROWSE INTO drgFC FPOS -.1, .2 SIZE 63,6.8              ;
                        FIELDS 'M->pokl_isEET:eet:2.7::2,'  + ;
                               'M->isDatKomE:e:2.4::2,'     + ;
                               'M->pokl_inDPH:dph:2.4::2,'  + ;
                               'nPOKLADNA:pokladna,'        + ;
                               'cNAZPOKLAD:název pokladny,' + ;
                               'nAKTSTAV:stav,'             + ;
                               'cZKRATMENY:mìna'              ;
                        SCROLL 'ny' CURSORMODE 3 PP 7

RETURN drgFC


method FIN_pokladms_SEL:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  drgDialog:dialog:drawingArea:bitmap  := 1020
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]-25}
  endif
return

method FIN_pokladms_SEL:drgDialogStart(drgDialog)
  ::msg := drgDialog:oMessageBar             // messageBar
return self