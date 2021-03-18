#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"

static last

FUNCTION FIN_PRIKUHHD_BC(nCOLUMn)
  LOCAL  xRETval := 0
  local  is_ok_abo := ok_abo_old := ok_abo_new := .f.

  do case
  case( ncolumn = 1)
    ok_abo_old := b_0x00->(dbseek(prikuhhd->ckodban_cr,, AdsCtag(1)))

    c_bankUc->(dbseek( upper(prikUhHd->cbank_Uct),,'BANKUC1'))
    * FIN_PRUHTU  FIN_PRUHZA
    * ciddatkome  ciddatkoze
    do case
    case prikuhhd->ctypDoklad = 'FIN_PRUHTU'
      ok_abo_new  := datkomhd->(dbseek( upper(c_bankuc->cIdDatKomE),, 'DATKOMH01'))

    case prikuhhd->ctypDoklad = 'FIN_PRUHZA'
      ok_abo_new  := datkomhd->(dbseek( upper(c_bankuc->cIdDatKozE),, 'DATKOMH01'))
    endcase

    is_ok_abo := ( ok_abo_old .or. ok_abo_new )

    do case
    case .not. is_ok_abo
      xretVal := MIS_ICON_ERR

    case(is_ok_abo .and. .not. empty(prikuhhd->ddate_Exp))
      xRETval := MIS_ICON_OK
    endcase

  CASE( nCOLUMn = 2 )  ;  xRETval := If( EMPTY( PRIKUHHD ->dDATTISK ), 0, 553 )
  case( ncolumn = 3 )  ;  xRetval := if( prikUhHD ->csubTask = 'MZD', 552, 551 )

  CASE( nCOLUMn = 21)
    xRETval:= If( PRIKUHIT ->cDENIK = '  ', 0, MIS_ICON_OK)

  ** CRD **
  CASE( nCOLUMn = 31)
    xRETval:= If( PRIKUHITw ->cDENIK = '  ', 0, MIS_ICON_OK)
  ENDCASE
RETURN xRETval


**
** CLASS for FIN_prikuhhd_SCR **************************************************
CLASS FIN_prikuhhd_SCR FROM drgUsrClass
EXPORTED:
  var     lnewRec, labo_New
  *
  ** pro nový export do bankou
  var     cpath_kom, cfile_kom, cpor_export, istuz
  *
  ** pro omezení nabídky pro pøíkazy FIN/MZD
  var     subtask

  METHOD  init, drgDialogStart, itemMarked, prikuhhd_abo, prikUhHd_abo_new

  inline method prikuhhd_in_pzo()
    DRGDIALOG FORM 'FIN_prikuhhd_IN_pzo' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  return self

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)

    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     msg, csection
  method  postDelete

  inline method prikuhhd_act()
    LOCAL  ab     := ::drgDialog:oActionBar:members      // actionBar
    LOCAL  x, ev, om, ok
    local  cIdDatKom

    for x := 1 to LEN(ab) step 1
      ev := Lower(ab[x]:event)
      om := ab[x]:parent:aMenu

      if ev $ 'prikuhhd_abo,prikuhhd_abo_new'
        do case
        case ( ev = 'prikuhhd_abo'     )
          ok :=  b_0x00->(dbseek( prikuhhd->ckodban_cr,, AdsCtag(1) ))

        case ( ev = 'prikuhhd_abo_new' )
          c_bankUc->(dbseek( upper(prikUhHd->cbank_Uct),,'BANKUC1'))

          * MZD_PRUHTU  MZD_PRUHZA
          * FIN_PRUHTU  FIN_PRUHZA
          * ciddatkome  ciddatkoze

          do case
          case prikuhhd->ctypDoklad = 'FIN_PRUHTU' .or. prikuhhd->ctypDoklad = 'MZD_PRUHTU'
            ok         := datkomhd->(dbseek( upper(c_bankuc->cIdDatKomE),, 'DATKOMH01'))
            ::csection := 'CIDDATKOME'

          case prikuhhd->ctypDoklad = 'FIN_PRUHZA' .or. prikuhhd->ctypDoklad = 'MZD_PRUHZA'
            ok         := datkomhd->(dbseek( upper(c_bankuc->cIdDatKozE),, 'DATKOMH01'))
            ::csection := 'CIDDATKOZE'
          otherWise
            ok         := .f.
            ::csection := ''
          endcase

*                                                  cIdDatKozE
*         ok := datkomhd->(dbseek( upper(c_bankuc->cIdDatKozE),, 'DATKOMH01'))
*          ok := datkomhd->(dbseek( upper(c_bankuc->cIdDatKomE),, 'DATKOMH01'))
        endcase

        ab[x]:disabled := .not. ok

        if(ok, ab[x]:oxbp:enable(), ab[x]:oxbp:disable() )
      endif
    next
    return self

ENDCLASS


METHOD FIN_prikuhhd_SCR:init(parent)
  local c_FIN_fltpruhr, filter := ''

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_bankuc')
  drgDBMS:open('fakprihd')
  drgDBMS:open('banky_cr')
  drgDBMS:open('banky_abo',,,,,'b_0x00')
  drgDBMS:open('datkomhd')
  drgDBMS:open('c_typPoh')

  * mzdy
  drgDBMS:open('mzdzavhd')

  * pøidán nový parametr FIN_fltpruhr
  ::subtask := ''

  if isCharacter( c_FIN_fltpruhr := sysConfig('finance:cfltpruhr'))
    c_FIN_fltpruhr := upper( c_FIN_fltpruhr )

    do case
    case at( 'FIN', c_FIN_fltpruhr ) <> 0 .and. at( 'MZD', c_FIN_fltpruhr ) <> 0
      ** ALL **
    case at( 'FIN', c_FIN_fltpruhr ) <> 0
      ::subtask := 'FIN'
         filter := format("(upper(csubtask) <> '%%')", { 'MZD' })
    case at( 'MZD', c_FIN_fltpruhr ) <> 0
      ::subtask := 'MZD'
         filter := format("(upper(csubtask) =  '%%')", { 'MZD' })
    endcase
  endif

  if .not. empty( ::subtask )
    ::drgDialog:set_prg_filter(filter, 'prikuhhd')
  endif

  ::lnewRec  := .f.
  ::labo_New := .f.
  ::csection := ''
RETURN self


METHOD FIN_prikuhhd_SCR:drgDialogStart(drgDialog)
  ::msg       := drgDialog:oMessageBar             // messageBar

  ::cpath_kom   := ''
  ::cfile_kom   := ''
  ::cpor_export := ''
RETURN


METHOD FIN_prikuhhd_SCR:itemMarked()
  local  cky       := StrZero(PRIKUHHD ->nDOKLAD,10)

  PRIKUHIT ->( AdsSetOrder('PRIKHD5')     , ;
               DbSetScope(SCOPE_BOTH, cky), ;
               DbGoTop()                    )

  c_bankUc->(dbseek( upper(prikUhHd->cbank_Uct),,'BANKUC1'))

  c_typpoh->(dbseek(upper(prikuhhd->culoha) +upper(prikuhhd->ctypdoklad) +upper(prikuhhd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)

  ::prikuhhd_act()
RETURN SELF


method FIN_prikuhhd_SCR:prikuhhd_abo(drgDialog)
  local  cky := prikuhhd->ckodban_cr, ok := .t.

  ::labo_New := .f.

  do case
  case .not. b_0x00->(dbseek(cky,, AdsCtag(1) ))
    ::msg:writeMessage('Pro banku [' +cky +'] není definováno (abo) ...',DRG_MSG_WARNING)
    ok := .f.
  case .not. prikuhhd->(dbrlock())
    ::msg:writeMessage('Neze vytvoøit soubor (abo), blokováno uživatelem ...',DRG_MSG_WARNING)
    ok := .f.
  endcase

  if ok
    prikuhit->(dbGoTop())

    DRGDIALOG FORM 'FIN_prikuhhd_ABO' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
    prikuhhd->(dbrunlock())
    ::drgDialog:dialogCtrl:refreshPostDel()
  endif
return self


method FIN_prikuhhd_SCR:prikuhhd_abo_new(drgDialog)
  local  cIdDatKom := upper( c_bankUc->cIdDatKomE )
  local  sdirW     := drgINI:dir_USERfitm +userWorkDir()
  local  sName     := drgINI:dir_USERfitm, lenBuff, buffer, afiles := {}
  *
  local  cInfo     := 'Promiòte prosím,' +CRLF
  local  is_Ok     := .t.

  sName   := drgINI:dir_USERfitm +userWorkDir() +'\' +cIdDatKom
  lenBuff := 1024
  buffer  := space(lenBuff)

  mycreateDir( sdirW )

  memoWrit(sName, datkomhd->mDefin_kom)

  GetPrivateProfileStringA( ::csection, 'fileExport'    , '', @buffer, lenBuff, sName)
  ::cfile_kom := substr(buffer,1,len(trim(buffer))-1)

  buffer  := space(lenBuff)
  GetPrivateProfileStringA( ::csection , 'porFileExport', '', @buffer, lenBuff, sName)
  ::cpor_export := substr(buffer,1,len(trim(buffer))-1)

  memoWrit(sName, c_bankuc->mDefin_kom)

  buffer  := space(lenBuff)
  GetPrivateProfileStringA( ::csection +'_usr', 'pathExport', '', @buffer, lenBuff, sName)
  ::cpath_kom := substr(buffer,1,len(trim(buffer))-1)
  ::labo_New  := .t.

  if ( empty(::cfile_kom) .or. empty(::cpath_kom) )
    cInfo += if( empty(::cfile_kom), 'není nastaven název souboru pro export ...' +CRLF, '' )
    cInfo += if( empty(::cpath_kom), 'není nastavena cesta pro export ...' +CRLF, '' )
    fin_info_box( cInfo, XBPMB_CRITICAL )
    is_Ok := .f.
  endif

  if is_Ok .and. .not. prikuhhd->(dbrlock())
    cInfo += 'Neze vytvoøit soubor (abo),' +CRLF + ;
             'blokováno uživatelem ...'
    fin_info_box( cInfo, XBPMB_CRITICAL )

    is_Ok := .f.
  endif

  if is_Ok
    prikuhit->(dbGoTop())

    DRGDIALOG FORM 'FIN_prikuhhd_ABO' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
    prikuhhd->(dbrunlock())
    ::drgDialog:dialogCtrl:refreshPostDel()
  endif
return self


method FIN_prikuhhd_SCR:postDelete()
  local  nsel, nodel := .f.

  nsel := ConfirmBox( ,'Požadujete zrušit pøíkaz k úhradì _' +alltrim(str(prikuhhd->ndoklad)) +'_', ;
                       'Zrušení pøíkazu k úhradì ...'   , ;
                        XBPMB_YESNO                     , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

  if nsel = XBPMB_RET_YES
    * pøíkaz k úhadì
    drgDBMS:open('prikuhhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('prikuhitw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    fin_prikuhhd_cpy(self)

    nodel := .not. fin_prikuhhd_del(self)

    prikuhhdw->(dbclosearea())
    prikuhitw->(dbclosearea())
  endif

  if nodel
    ConfirmBox( ,'Pøíkaz k úhradì ' +alltrim(str(prikuhhd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení pøíkazu k úhradì ...'   , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


*
**
class FIN_prikuhhd_ABO FROM drgUsrClass
EXPORTED:
  *
  ** pro nový export do bankou
  var     labo_New, cpath_kom, cfile_kom, cpor_export, istuz
  var     nfile_exp
  *
  var     typOdes, formatAbo
  method  init, drgDialogStart, abo_Odeslat, abo_Zrusit

hidden:
  var     ab, dm, pushOdes, pushZrus, kodban_cr, ofile_exp
  method  file_exp
ENDCLASS


method FIN_prikuhhd_ABO:init(parent)
  local  cc := 'FORMÁT pøenosu '

  ::drgUsrClass:init(parent)

  ::typOdes   := ''
  ::kodban_cr := b_0x00->ckodban_cr
  ::nfile_exp := 1

  if ( ::labo_New  := parent:parent:udcp:labo_new )
    ::cpath_kom   := allTrim(parent:parent:udcp:cpath_kom  )
    ::cfile_kom   := allTrim(parent:parent:udcp:cfile_kom  )
    ::cpor_export := upper( allTrim(parent:parent:udcp:cpor_export))
    ::istuz       := parent:parent:udcp:istuz

    ::formatAbo := datkomhd->cnazDatKom
  else
    if ::kodban_cr = '0100'
      cc += if( b_0x00->ncissta_km = 0, 'KB_DATA', 'BEST_KB')
    else
      cc += ' ABO'
    endif
    ::formatAbo := cc
  endif

  * èíslování pro 600
  drgDBMS:open('prikuhhd',,,,, 'prikuh_v')
  prikuh_v->(OrdSetFocus( 'FDODHD10' ))
return self


method FIN_prikuhhd_ABO:drgDialogStart(drgDialog)
  local  x, ev, ok

  ::ab        := drgDialog:oActionBar:members      // actionBar
  ::dm        := drgDialog:dataManager             // dataMabanager

  ::ofile_exp := ::dm:has('prikuhhd->cfile_exp'):odrg

  for x := 1 to len(::ab) step 1
    if ischaracter(::ab[x]:event)
      ev := lower(::ab[x]:event)

      do case
      case(ev $ 'abo_Odeslat')  ;  ::pushOdes := ::ab[x]
      case(ev $ 'abo_Zrusit' )  ;  ::pushZrus := ::ab[x]
      endcase
    endif
  next

  if( ::labo_New, ::ofile_exp:ovar:set( ::cpath_kom +::cfile_kom), ::file_exp())
return


method FIN_prikuhhd_ABO:file_exp()
  local  cdate  := dtoc(date()), cden, cmes, crok, cc := '_best.ikm'
  *
  local  nrok   := year( date() )
  local  cf     := "upper(ckodBan_cr) = '%%' .and. year(ddate_exp) = %%", filter
  *
  local  cc_Org := ::ofile_exp:ovar:value

  last := 1
  cden := left  ( cdate, 2)
  cmes := substr( cdate, 4, 2)
  crok := substr( cdate, 7)

  banky_cr->(dbSeek( upper(::kodban_cr),, AdsCtag(1) ))

  do case
  case(::kodban_cr = '0100')
    if b_0x00->ncissta_km = 0
      cc := cden +cmes +strZero(b_0x00->ncissta_km,3) +'1.kpc'
    endif

  case(::kodban_cr = '0300')
    cc := crok +strzero(last,4) +'.kpc'

  case(::kodban_cr = '0600')
    filter := format( cf, { ::kodban_cr, nrok })
    prikuh_v->(ads_setAof( filter ), dbgoBottom())
    last   := prikuh_v->nfile_exp +1
    prikuh_v->( ads_clearAOF())

    cc := crok +strzero(last,4) +'.fin'

  case(::kodban_cr = '0800')
    cc := cden +cmes +left(b_0x00->czkrkli_km,3) +str(last,1) +'.kpc'

  case(::kodban_cr = '3400')
    cc := cden + cmes +left(b_0x00->czkrkli_km,3)+str(last,1) +'.kpc'

  case(::kodban_cr = '5500')
    cc := crok +strzero(last,4) +'.fin'

  case(::kodban_cr = '6700')
    cc := crok +strzero(last,4) +'.kpc'

  endcase

  if( .not. Equal(cc_Org,cc), ::ofile_exp:ovar:set(cc), nil)
return self


method FIN_prikuhhd_ABO:abo_Odeslat()
   local  cfileExp  := ::ofile_exp:ovar:value
   local  block_abo := 'B_' +b_0x00->ckodban_cr +'("EXP","' +cfileExp +'")'
   *
   local  cbank_Uct := prikuhhd->cbank_uct
   local  cf := '', filter

   if ::labo_New

     if ::cpor_export $ 'ROK,DEN'
       do case
       case ::cpor_export = 'ROK'
         cf := "upper(cbank_Uct) = '%%' .and. year(ddate_exp) = year(date())"
       case ::cpor_export = 'DEN'
         cf := "upper(cbank_Uct) = '%%' .and. ddate_exp = date()"
       endcase

       filter := format( cf, { cbank_uct } )
       prikuh_v->(ads_setAof( filter ), dbgoBottom())
       ::nfile_exp := prikuh_v->nfile_exp +1
       prikuh_v->( ads_clearAOF())
     endif

     ASys_Komunik( , self)
   else
     eval(COMPILE(block_abo))
   endif

   prikuhhd->ddate_exp := date()
   prikuhhd->nfile_exp := last
   prikuhhd->cfile_exp := cfileExp
   PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self


method FIN_prikuhhd_ABO:abo_Zrusit()

  prikuhhd->ddate_exp := ctod('  .  .  ')
  prikuhhd->cfile_exp := ''
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self