#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\FINANCE\FIN_finance.ch"


*  POKLADNÍ DOKLADY _ FIN_pokladhd_SCR ****************************************
CLASS FIN_pokladhd_scr_Eet FROM fin_pro_sendEet
EXPORTED:
  method  init
ENDCLASS

METHOD FIN_pokladhd_scr_Eet:init(parent)
  parent:formName := parent:initParam := 'fin_pro_sendEet'
  parent:helpName := 'FIN_pokladhd_scr_Eet'

  ::drgUsrClass:init(parent)
  ::fin_pro_sendEet:init('POKLADHD')
RETURN self


*  REGISTRAÈNÍ POKLADNA _ PRO_poklhd_SCR **************************************
CLASS PRO_poklhd_scr_Eet FROM fin_pro_sendEet
EXPORTED:
  method  init
ENDCLASS


METHOD PRO_poklhd_scr_Eet:init(parent)
  parent:formName := parent:initParam := 'fin_pro_sendEet'
  parent:helpName := 'PRO_poklhd_scr_Eet'

  ::drgUsrClass:init(parent)
  ::fin_pro_sendEet:init('POKLHD')
RETURN self



*
** CLASS for fin_pro_sendEet pokladhd/ poklhd *********************************
STATIC CLASS fin_pro_sendEet FROM drgUsrClass
EXPORTED:
  var     cmain_File
  var     lnewRec, ain_file, denik, typ_dokl, oinf
  METHOD  init, getForm, drgDialogStart, itemMarked, drgDialogEnd
  *
  method  drgDialogInit

  * pokladhd/ poklhd vždy je pøíjem
  inline access assign method typPohybu() var typPohybu
    return MIS_PLUS


  * browColumn - HD
  inline access assign method err_imp_hd() var err_imp_hd
    return if( banvyphd->nerr_imp = 1, MIS_ICON_ERR, 0 )

  inline access assign method cnaz_uct_hd()  var cnaz_uct_hd
    c_uctosn->( DbSeek(upper(banvyphd->cucet_uct),,'UCTOSN1'))
    return c_uctosn->cnaz_uct

  * browColumn - IT
  inline access assign method err_imp_it() var err_imp_it
    return if( banvypit->nerr_imp = 1, MIS_ICON_ERR, 0 )

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
*      if( banvyphd->(eof()), nil, ::postDelete())
      return .t.
    endcase
    return .f.

HIDDEN:
  var     prnFiles
  VAR     tabnum, brow, bank_uct, comboBox
*  method  postDelete
ENDCLASS


METHOD fin_pro_sendEet:init(cmain_File)
  local  filter := "(npokladEET = 1 and cfik = ' ')"

  ::cmain_File := cmain_File

  drgDBMS:open('POKLHD'  )
  drgDBMS:open('POKLADHD')
  *
  drgDBMS:open('POKLADMS')
  drgDBMS:open('DATKOMHD')

  ::oinf  := fin_datainfo():new( ::cmain_FILE )

  ::drgDialog:set_prg_filter( filter, ::cmain_FILE )

  *
*  banvypit->( ordSetFocus( 'BANKVY_7' ))
RETURN self


METHOD fin_pro_sendEet:getForm()
  local  oDrg, drgFC, subTitle
  *
  local  headTitle, prnFiles

  do case
  case ( ::cmain_File = 'POKLADHD' )
    headTitle := 'dokladù finanèní pokladny neodeslaných do Eet'
    prnFiles  := 'pokladhd:ndoklad=ndoklad,'  + ;
                 'pokladit:ndoklad=ndoklad,'  + ;
                 'ucetpol:cdenik=cdenik+ndoklad=ndoklad'
  otherwise
    headTitle := 'dokladù registraèní pokladny neodeslaných do Eet'
    prnFiles  := 'poklhd:ndoklad=ndoklad,'    + ;
                 'poklit:ndoklad=ndoklad,'    + ;
                 'ucetpol:cdenik=cdenik+ndoklad=ncisfak'
  endcase


  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 90,20 DTYPE '10' TITLE 'Seznam ' +headTitle ;
                     FILE ::cmain_File                                 ;
                     GUILOOK 'Message:Y,Action:y,IconBar:y:MyIconBar,Menu:n'

  odrg:prnFiles  := strtran(prnFiles,' ','')
*  odrg:tskObdobi := 'FIN'

  * hlavièka
  do case
  case ( ::cmain_File = 'POKLADHD' )
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 90,19.5 FILE 'POKLADHD' ;
    FIELDS 'M->oinf|stavEet:e:2.6::2,'         + ;
           'M->oinf|tisk:T:2.6::2,'            + ;
           'COBDOBI:obdÚè:5,'                  + ;
           'NPOKLADNA:èísPokl,'                + ;
           'M->typPohybu::2.7::2,'             + ;
           'NDOKLAD:èísDokladu:10,'            + ;
           'DPORIZDOK:datPoøízení:10,'         + ;
           'CTEXTDOK:úèel platby:28,'          + ;
           'FIN_pokladhd_BC(8):èástka:13:::1,' + ;
           'CZKRATMENZ:mìna'                     ;
    SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' POPUPMENU 'y' FOOTER 'yy'


  otherwise
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 90,19.5 FILE 'POKLHD' ;
    FIELDS 'M->oinf|stavEet:e:2.6::2,'         + ;
           'M->oinf|tisk:T:2.6::2,'            + ;
           'cOBDOBI:obdÚè:5,'                  + ;
           'NPOKLADNA:èísPokl,'                + ;
           'M->typPohybu::2.7::2,'             + ;
           'nCISFAK:èísDokladu:10,'            + ;
           'dvystFak:datPoøízení:10,'          + ;
           'cNAZEV:úèel platby:28,'            + ;
           'nCENzahCEL:èástka:13:::1,'         + ;
           'cZKRATmenz:mìna'                     ;
    SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' POPUPMENU 'y' FOOTER 'yy'
  endcase

  DRGEND INTO drgFC
RETURN drgFC


METHOD fin_pro_sendEet:drgDialogInit(drgDialog)
//  drgDialog:dialog:drawingArea:bitmap  := 1018
//  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
RETURN


METHOD fin_pro_sendEet:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN


METHOD fin_pro_sendEet:itemMarked()
*  LOCAL  cky := upper(banvyphd->cdenik) +strZero(banvyphd ->ndoklad,10)
  *
*  banvypit ->( ordSetFocus('BANKVY_7'), dbsetScope( SCOPE_BOTH, cky), DbGoTop())
*  ucetpol  ->( dbsetScope( SCOPE_BOTH, cky), DbGoTop())
RETURN SELF

/*
method fin_pro_sendEet:postDelete()
  local  oinf := fin_datainfo():new('BANVYPHD'), nsel, nodel := .f.
  local  cc_1 := if(::typ_dokl = 'ban', 'bankovní doklad _'     , ;
                 if(::typ_dokl = 'vzz', 'vzájemný zápoèet _'    , 'doklad úrady _'    ))
  local  cc_2 := if(::typ_dokl = 'ban', 'bankovního dokladu ...', ;
                 if(::typ_dokl = 'vzz', 'vzájemného zápoètu ...', 'dokladu úhrady ...'))

  if oinf:ucuzav() = 0
    nsel := ConfirmBox( ,'Požadujete zrušit ' +cc_1 +alltrim(str(banvyphd->ndoklad)) +'_', ;
                         'Zrušení ' +cc_2                 , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      * banka/vzájemné zápoèty
      drgDBMS:open('banvyphdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
      drgDBMS:open('banvypitw',.T.,.T.,drgINI:dir_USERfitm); ZAP

      fin_banvyp_cpy(self)
      nodel := .not. fin_banvyp_del(self)

      banvyphdw->(dbclosearea())
      banvypitw->(dbclosearea())
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,cc_1 +alltrim(str(banvyphd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení ' +cc_2                 , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE)
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel
*/

METHOD fin_pro_sendEet:drgDialogEnd()
*  banvyphd->(ads_clearAof())
*  BANVYPIT ->( DbClearScope())
RETURN