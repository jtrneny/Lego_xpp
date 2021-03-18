#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\FINANCE\FIN_finance.ch"


*  BANKOVN� V�PISY _ FIN_banvyphd_scr_bav **************************************
CLASS FIN_banvyphd_scr_ban FROM FIN_banvyphd_scr
EXPORTED:
  method  init
ENDCLASS


METHOD FIN_banvyphd_scr_ban:init(parent)
  parent:formName := parent:initParam := 'FIN_banvyphd_SCR'
  parent:helpName := 'FIN_banvyphd_scr_ban'

  ::drgUsrClass:init(parent)
  ::FIN_banvyphd_scr:init('ban')
RETURN self


*  VZ�JEMN� Z�PO�TY _ FIN_banvyphd_scr_vzz *************************************
CLASS FIN_banvyphd_scr_vzz FROM FIN_banvyphd_scr
EXPORTED:
  method  init
ENDCLASS


METHOD FIN_banvyphd_scr_vzz:init(parent)
  parent:formName := parent:initParam := 'FIN_banvyphd_SCR'
  parent:helpName := 'FIN_banvyphd_scr_vzz'

  ::drgUsrClass:init(parent)
  ::FIN_banvyphd_scr:init('vzz')
RETURN self


*  �HDADY ��ETN�M DOKLADEM _ FIN_banvyphd_scr_uhr ******************************
CLASS FIN_banvyphd_scr_uhr FROM FIN_banvyphd_scr
EXPORTED:
  method  init
ENDCLASS


METHOD FIN_banvyphd_scr_uhr:init(parent)
  parent:formName := parent:initParam := 'FIN_banvyphd_SCR'
  parent:helpName := 'FIN_banvyphd_scr_uhr'

  ::drgUsrClass:init(parent)
  ::FIN_banvyphd_scr:init('uhr')
RETURN self



*
** CLASS for FIN_banvyphd_SCR ban/vzz/uhr **************************************
STATIC CLASS FIN_banvyphd_SCR FROM drgUsrClass,FIN_ban_vzz_pok
EXPORTED:
  var     lnewRec, ain_file, denik, typ_dokl, oinf
  METHOD  init, getForm, drgDialogStart, itemMarked, tabSelect, drgDialogEnd
  *
  method  drgDialogInit

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
      if( banvyphd->(eof()), nil, ::postDelete())
      return .t.
    endcase
    return .f.

HIDDEN:
  VAR     tabnum, brow, bank_uct, comboBox
  method  postDelete
ENDCLASS


METHOD FIN_banvyphd_SCR:init(typ_dokl)
  local filter
  local cdenik := 'FINANCE:cDENIK' +if(typ_dokl = 'ban', 'BAVY', if(typ_dokl = 'vzz', 'VZZA', 'UHRD'))

  ::denik    := sysConfig(cdenik)
  ::typ_dokl := typ_dokl
  ::tabnum   := 1
  ::lnewRec  := .f.
  *
  * vstupn� soubory pro kontrolu na csymol
  ::ain_file := {{'fakprihd', 0, 0, 1,  9, SysConfig('FINANCE:cDENIKFAPR')}, ;
                 {'fakvyshd', 0, 0, 2, 10, SysConfig('FINANCE:cDENIKFAVY')}, ;
                 {'mzdZavhd', 0, 0, 3, 11, 'MC'                           }  }

  drgDBMS:open('DPH_2004')
  drgDBMS:open('DPHDATA' )
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('UZAVISOZ')

  drgDBMS:open('BANVYPHD')
  drgDBMS:open('BANVYPIT')
  drgDBMS:open('C_BANKUC')
  drgDBMS:open('c_uctosn')

  drgDBMS:open('fakprihd')
  drgDBMS:open('fakvyshd')
  drgDBMS:open('mzdZavhd')

  drgDBMS:open('banVyph_im')
  drgDBMS:open('banVypi_im')

  ::oinf  := fin_datainfo():new('BANVYPHD')

  filter := format("(upper(cdenik) = '%%')", {::denik})
  ::drgDialog:set_prg_filter(filter, 'banvyphd')

  *
  banvypit->( ordSetFocus( 'BANKVY_7' ))
RETURN self


METHOD FIN_banvyphd_SCR:getForm()
  local  oDrg, drgFC, headTite, subTitle
  *
  local  prnFiles := 'banvyphd:ndoklad=ndoklad,' + ;
                     'banvypit:ndoklad=ndoklad,' + ;
                     'ucetpol:cdenik=cdenik+ndoklad=ndoklad'


  do case
  case(::typ_dokl = 'ban')
    headTitle := 'bankovn�ch v�pis� ...'
    subTitle  := 'bankovn�ho v�pisu'
  case(::typ_dokl = 'vzz')
    headTitle := 'vz�jemn�ch z�po�t� ...'
    subTitle  := 'vz�jen�ho z�po�tu'
  otherwise
    headTitle := 'doklad� �hrad ...'
    subTitle  := 'doklad� �hrad'
  endcase

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 115,25 DTYPE '10' TITLE 'Seznam ' +headTitle ;
                                            CARGO 'FIN_banvyphd_IN' +'_' +::typ_dokl


  odrg:prnFiles  := strtran(prnFiles,' ','')
  odrg:tskObdobi := 'FIN'

  * hlavi�ka
  do case
  case ::typ_dokl = 'ban'
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 114.5,12.1 FILE 'BANVYPHD' ;
    FIELDS 'M->err_imp_hd:E:2.4::2,'     + ;
           'M->oinf|likvidace:L:2.6::2,' + ;
           'M->oinf|ucuzav:U:2.6::2,'    + ;
           'cObdobi:obdob�:5,'           + ;
           'nDOKLAD:doklad:9,'           + ;
           'cBANK_UCT:bankovn� ��et:20,' + ;
           'nCISPOVYP:v�p,'              + ;
           'dDATPORIZ:ze dne,'           + ;
           'nPOSZUST:po�Stav,'           + ;
           'nPRIJEM:p��jem��t,'          + ;
           'nVYDEJ:v�dej��t,'            + ;
           'nZUSTATEK:aktStav,'          + ;
           'nPRIJEMz:p��jemZah,'         + ;
           'nVYDEJz:v�dejZah,'           + ;
           'czkratmeny:m�na'               ;
    SCROLL 'yy' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' ATSTART 'last' POPUPMENU 'y'

  case ::typ_dokl = 'vzz'
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 114.5,12.1 FILE 'BANVYPHD' ;
    FIELDS 'M->oinf|likvidace:L:2.6::2,' + ;
           'M->oinf|ucuzav:U:2.6::2,'    + ;
           'cObdobi:obdob�:5,'           + ;
           'nDOKLAD:doklad,'             + ;
           'nICO:i�o,'                   + ;
           'cNAZEV:n�zev firmy:20,'      + ;
           'dDATPORIZ:datPo�,'           + ;
           'nPOSZUST:po�Stav,'           + ;
           'nPRIJEM:p��jem��t,'          + ;
           'nVYDEJ:v�dej��t,'            + ;
           'nZUSTATEK:aktStav'             ;
    SCROLL 'yy' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' ATSTART 'last' POPUPMENU 'y'

  otherwise
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 114.5,12.1 FILE 'BANVYPHD' ;
    FIELDS 'M->oinf|likvidace:L:2.6::2,'  + ;
           'M->oinf|ucuzav:U:2.6::2,'     + ;
           'cObdobi:obdob�:5,'            + ;
           'nDOKLAD:doklad,'              + ;
           'cUCET_UCT:suau_�,'            + ;
           'M->cnaz_uct_hd:n�zev ��tu:23,'+ ;
           'dDATPORIZ:datPo�,'            + ;
           'nPOSZUST:po�Stav,'            + ;
           'nPRIJEM:p��jem��t,'           + ;
           'nVYDEJ:v�dej��t,'             + ;
           'nZUSTATEK:aktStav'              ;
    SCROLL 'yy' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' ATSTART 'last' POPUPMENU 'y'

  endcase


  * polo�ky
  DRGTABPAGE INTO drgFC CAPTION 'polo�ky' FPOS 0.5,12.4 SIZE 114.5,12.4 OFFSET 1,86 TTYPE 3 PRE 'tabSelect' TABHEIGHT 0.8 RESIZE 'yx'
    DRGTEXT INTO drgFC CAPTION 'Polo�ky ' +subTitle CPOS 0.1,0 CLEN 114.4 FONT 5 PP 3 BGND 11 CTYPE 1
    odrg:resize := 'yx'

    if ::typ_dokl = 'ban'
      DRGDBROWSE INTO drgFC FPOS 0,1 SIZE 114.5,9.5 FILE 'BANVYPIT' ;
      FIELDS 'M->err_imp_it:E:2.4::2,'      + ;
             'FIN_banvypit_BC(1):_:2.7::2,' + ;
             'cVARSYM:varSymb,'             + ;
             'nCISFAK:��sloFak,'            + ;
             'dSPLATFAK:datSplat,'          + ;
             'dDATUHRADY:dat�hrady,'        + ;
             'cTEXT:text Polo�ky:46,'       + ;
             'nCENZAKCEL:celk�hrada,'       + ;
             'FIN_banvypit_BC(8):typ:2.5::2'  ;
      SCROLL 'ny' CURSORMODE 3 PP 7 INDEXORD 7 RESIZE 'yx'

    else
      DRGDBROWSE INTO drgFC FPOS 0,1 SIZE 114.5,9.5 FILE 'BANVYPIT' ;
      FIELDS 'FIN_banvypit_BC(1):_:2.7::2,' + ;
             'cVARSYM:varSymb,'             + ;
             'nCISFAK:��sloFak,'            + ;
             'dSPLATFAK:datSplat,'          + ;
             'dDATUHRADY:dat�hrady,'        + ;
             'cTEXT:text Polo�ky:46,'       + ;
             'nCENZAKCEL:celk�hrada,'       + ;
             'FIN_banvypit_BC(8):typ:2.5::2'  ;
      SCROLL 'ny' CURSORMODE 3 PP 7 INDEXORD 7 RESIZE 'yx'
    endif
  DRGEND INTO drgFC

  * likvidace
  DRGTABPAGE INTO drgFC CAPTION 'likvidace' FPOS 0.5,12.4 SIZE 114.5,12.4 OFFSET 13,74 TTYPE 3 PRE 'tabSelect' TABHEIGHT 0.8 RESIZE 'yx'
    DRGTEXT INTO drgFC CAPTION 'Likvidace ' +subTitle CPOS 0.1,0 CLEN 114.4 FONT 5 PP 3 BGND 11 CTYPE 1
    odrg:resize := 'yx'

    DRGDBROWSE INTO drgFC FPOS 0,1 SIZE 114.5,9.5 FILE 'UCETPOL' ;
    FIELDS 'nDOKLAD:doklad,'               + ;
           'cOBDOBI:obd��,'         + ;
           'CTEXT:Text dokladu:55,' + ;
           'cUCETMD:SuAu_�,'        + ;
           'nKCMD,'                 + ;
           'nKCDAL,'                + ;
           'cUCETDAL:SuAu_S'          ;
    SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yx' INDEXORD 4
  DRGEND INTO drgFC
RETURN drgFC


METHOD FIN_banvyphd_SCR:drgDialogInit(drgDialog)
//  drgDialog:dialog:drawingArea:bitmap  := 1018
//  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
RETURN


METHOD FIN_banvyphd_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN


METHOD FIN_banvyphd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


METHOD FIN_banvyphd_SCR:itemMarked()
  LOCAL  cky := upper(banvyphd->cdenik) +strZero(banvyphd ->ndoklad,10)
  *
  banvypit ->( ordSetFocus('BANKVY_7'), dbsetScope( SCOPE_BOTH, cky), DbGoTop())
  ucetpol  ->( dbsetScope( SCOPE_BOTH, cky), DbGoTop())

  do case
  case ::tabnum = 1
*    BANVYPIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())
  case ::tabnum = 2
*    UCETPOL ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
    ::brow[3]:refresh(.T.)
  endcase
RETURN SELF


method FIN_banvyphd_SCR:postDelete()
  local  oinf := fin_datainfo():new('BANVYPHD'), nsel, nodel := .f.
  local  cc_1 := if(::typ_dokl = 'ban', 'bankovn� doklad _'     , ;
                 if(::typ_dokl = 'vzz', 'vz�jemn� z�po�et _'    , 'doklad �rady _'    ))
  local  cc_2 := if(::typ_dokl = 'ban', 'bankovn�ho dokladu ...', ;
                 if(::typ_dokl = 'vzz', 'vz�jemn�ho z�po�tu ...', 'dokladu �hrady ...'))

  if oinf:ucuzav() = 0
    nsel := ConfirmBox( ,'Po�adujete zru�it ' +cc_1 +alltrim(str(banvyphd->ndoklad)) +'_', ;
                         'Zru�en� ' +cc_2                 , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      * banka/vz�jemn� z�po�ty
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
    ConfirmBox( ,cc_1 +alltrim(str(banvyphd->ndoklad)) +'_' +' nelze zru�it ...', ;
                 'Zru�en� ' +cc_2                 , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE)
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


METHOD FIN_banvyphd_SCR:drgDialogEnd()
  banvyphd->(ads_clearAof())
  BANVYPIT ->( DbClearScope())
RETURN