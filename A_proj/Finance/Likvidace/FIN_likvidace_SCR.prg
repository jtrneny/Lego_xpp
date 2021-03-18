#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


** ZÁVAZKY
** CLASS for FIN_likvidace_scr_ZAV *********************************************
CLASS FIN_likvidace_scr_ZAV FROM FIN_likvidace_scr
EXPORTED:
  var     oinf
  method  init

ENDCLASS


method FIN_likvidace_scr_ZAV:init(parent)
  parent:formName := parent:initParam := 'FIN_likvidace_SCR'

  ::drgUsrClass:init(parent)
  ::FIN_likvidace_scr:init('zav')

  ::oinf  := fin_datainfo():new('FAKPRIHD')
return self



** POHLEDÁVKY
** CLASS for FIN_likvidace_scr_POH *********************************************
CLASS FIN_likvidace_scr_POH FROM FIN_likvidace_scr
EXPORTED:
  var     oinf
  method  init

ENDCLASS


METHOD FIN_likvidace_scr_POH:init(parent)
  parent:formName := parent:initParam := 'FIN_likvidace_SCR'

  ::drgUsrClass:init(parent)
  ::FIN_likvidace_scr:init('poh')

  ::oinf  := fin_datainfo():new('FAKVYSHD')
RETURN self


** BANKA
** CLASS for FIN_likvidace_scr_BAN *********************************************
CLASS FIN_likvidace_scr_BAN FROM FIN_likvidace_scr
EXPORTED:
  var     oinf
  method  init

ENDCLASS


METHOD FIN_likvidace_scr_BAN:init(parent)
  local  filter, denik := SYSCONFIG('FINANCE:cDENIKBAVY')

  parent:formName := parent:initParam := 'FIN_likvidace_SCR'

  ::drgUsrClass:init(parent)
  ::FIN_likvidace_scr:init('ban')

  drgDBMS:open('BANVYPHD')
  ::oinf  := fin_datainfo():new('BANVYPHD')

  filter := format("(upper(cdenik) = '%%')", {denik})
  banvyphd->( ads_setAof(filter))
RETURN self


** POKLADNA
** CLASS for FIN_likvidace_scr_POK *********************************************
CLASS FIN_likvidace_scr_POK FROM FIN_likvidace_scr
EXPORTED:
  var     oinf
  method  init

ENDCLASS


METHOD FIN_likvidace_scr_POK:init(parent)
  parent:formName := parent:initParam := 'FIN_likvidace_SCR'

  ::drgUsrClass:init(parent)

  drgDBMS:open('POKLADMS')
  ::FIN_likvidace_scr:init('pok')
  ::oinf  := fin_datainfo():new('POKLADHD')
RETURN self


** VZÁJEMNÉ ZÁPOÈTY
** CLASS for FIN_likvidace_scr_VZZ *********************************************
CLASS FIN_likvidace_scr_VZZ FROM FIN_likvidace_scr
exported:
  var     oinf
  method  init

ENDCLASS


METHOD FIN_likvidace_scr_VZZ:init(parent)
  local  filter, denik := SYSCONFIG('FINANCE:cDENIKVZZA')

  parent:formName := parent:initParam := 'FIN_likvidace_SCR'

  ::drgUsrClass:init(parent)
  ::FIN_likvidace_scr:init('vzz')

  drgDBMS:open('BANVYPHD')
  ::oinf  := fin_datainfo():new('BANVYPHD')

  filter := format("(upper(cdenik) = '%%')", {denik})
  banvyphd->( ads_setAof(filter))
RETURN self


** ÚHDADY ÚÈETNÍM DOKLADEM
** CLASS for FIN_likvidace_scr_UHR *********************************************
CLASS FIN_likvidace_scr_UHR FROM FIN_likvidace_scr
exported:
  var     oinf
  method  init

ENDCLASS


METHOD FIN_likvidace_scr_UHR:init(parent)
  local  filter, denik := SYSCONFIG('FINANCE:cDENIKVZZA')

  parent:formName := parent:initParam := 'FIN_likvidace_SCR'

  ::drgUsrClass:init(parent)
  ::FIN_likvidace_scr:init('uhr')

  drgDBMS:open('BANVYPHD')
  ::oinf  := fin_datainfo():new('BANVYPHD')

  filter := format("(upper(cdenik) = '%%')", {denik})
  banvyphd->( ads_setAof(filter))
RETURN self



**
** CLASS for FIN_likvidace_scr *************************************************
CLASS FIN_likvidace_scr FROM drgUsrClass, fin_finance_in
EXPORTED:
  VAR     typ, subTitle, mainFile  //, oinf
  VAR     tabNum, mainKey, subKey, subUKey, formName

  METHOD  init, getForm, drgDialogStart, itemMarked, tabSelect, drgDialogEnd

  * browColumn - pro ban - HD
  inline access assign method err_imp_hd() var err_imp_hd
    return if( banvyphd->nerr_imp = 1, MIS_ICON_ERR, 0 )

 * browColumn - pro ban - IT
  inline access assign method err_imp_it() var err_imp_it
    return if( banvypit->nerr_imp = 1, MIS_ICON_ERR, 0 )

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
      return .t.

    case nEvent = drgEVENT_EDIT
      IF ::typ $ 'zav,poh,pok'
        ::drgDialog:formName := ::formName
        ::fin_finance_in:FIN_likvidace_in(::drgDialog)
      endif
      return .t.
    endcase
  return .f.

ENDCLASS


METHOD FIN_likvidace_scr:init(typ)

  ::typ    := typ
  ::tabNum := 1

  ** likvidace
  ::formName := 'fin_' +if(::typ = 'zav', 'fakprihd_in'   , ;
                         if(::typ = 'poh', 'fakvyshd_in'  , ;
                          if(::typ = 'pok', 'pokladhd_in', '')))
  ::FIN_finance_in:typ_lik := typ
RETURN SELF

*
METHOD FIN_likvidace_scr:getForm()
  LOCAL  oDrg, drgFC
  LOCAL  cIN := IF(::typ $ 'zav,poh,pok', 'likvidace_in', '')

  ::subTitle := IF(::typ = 'zav', 'závazkù ...', ;
                 IF(::typ = 'poh', 'pohledávek ...', ;
                  IF(::typ = 'ban', 'bankovních výpisù ...', ;
                   IF(::typ = 'vzz', 'vzájemných zápoètù ...', 'pokladních dokladù ...'))))


  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 105,25 DTYPE '10' TITLE 'Seznam ' +::subTitle

  odrg:tskObdobi := 'FIN'

  DRGTABPAGE INTO drgFC CAPTION 'Doklady' SIZE 105,11.5 OFFSET 0,84 PRE 'tabSelect' TABHEIGHT 0.8
    DO CASE
    CASE( ::typ = 'zav' )
      ::mainFile := 'FAKPRIHD'
      ::mainKey  := 'Upper(FAKPRIHD ->cDENIK) +StrZero(FAKPRIHD ->nCISFAK,10)'
      ::subKey   := 'FAKPRIHD ->nCISFAK'
      ::subUKey  := 'StrZero(PARPRZAL ->nORDITEM,5)'

      DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'FAKPRIHD' ;
      FIELDS 'M->oinf|hrazeno:H:2.6::2,' + ;
             'M->oinf|prikazy:P:2.6::2,' + ;
             'M->oinf|danuzav:D:2.6::2,' + ;
             'M->oinf|likvidace:L:2.6::2,' + ;
             'M->oinf|ucuzav:U:2.6::2,' + ;
             'nCISFAK,'                         + ;
             'cVARSYM:VarSymbol,'               + ;
             'cNAZEV:Název dodavatele:20,'      + ;
             'CTEXTFAKT:Text faktury:20,'       + ;
             'nCENZAKCEL,'                      + ;
             'CUCET_UCT:SuAu_Ø'                   ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' ATSTART 'last' POPUPMENU 'y'

    CASE( ::typ = 'poh' )
      ::mainFile := 'FAKVYSHD'
      ::mainKey  := 'Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)'
      ::subKey   := 'StrZero(FAKVYSHD ->nCISFAK,10)'
      ::subUKey  := 'StrZero(FAKVYSIT ->nINTCOUNT,5)'

      DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'FAKVYSHD' ;
      FIELDS 'M->oinf|hrazeno:H:2.6::2,'   + ;
             'M->oinf|tisk:T:2.6::2,'      + ;
             'M->oinf|danuzav:D:2.6::2,'   + ;
             'M->oinf|likvidace:L:2.6::2,' + ;
             'M->oinf|ucuzav:U:2.6::2,'    + ;
             'nCISFAK:èísloFak,'           + ;
             'cVARSYM:varSymbol,'          + ;
             'cNAZEV:obìratel:40,'         + ;
             'dVYSTFAK:datVyst,'           + ;
             'nCENzahCEL:celkemFak,'       + ;
             'cZKRATmenz:mìna'               ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' ATSTART 'last' POPUPMENU 'y'

    CASE( ::typ = 'ban' .or. ::typ = 'vzz' )
      ::mainFile := 'BANVYPHD'
      ::mainKey  := 'Upper(BANVYPHD ->cDENIK) +StrZero(BANVYPHD ->nDOKLAD,10)'
      ::subKey   := 'StrZero(BANVYPHD ->nDOKLAD,10)'
      ::subUKey  := 'StrZero(BANVYPIT ->nINTCOUNT,5)'

      DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'BANVYPHD' ;
      FIELDS 'M->err_imp_hd:E:2.4::2,'     + ;
             'M->oinf|likvidace:L:2.6::2,' + ;
             'M->oinf|ucuzav:U:2.6::2,'    + ;
             'nDOKLAD:doklad,'             + ;
             'cBANK_UCT:bankovní Úèet:22,' + ;
             'dDATPORIZ:datPoø,'           + ;
             'nPOSZUST:poèStav,'           + ;
             'nPRIJEM:pøíjemÚèt,'          + ;
             'nVYDEJ:výdejÚèt,'            + ;
             'nZUSTATEK:aktStav'             ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' ATSTART 'last' POPUPMENU 'y'

    CASE( ::typ = 'pok' )
      ::mainFile := 'POKLADHD'
      ::mainKey  := 'Upper(POKLADHD ->cDENIK) +StrZero(POKLADHD ->nDOKLAD,10)'
      ::subKey   := 'StrZero(POKLADHD ->nDOKLAD,10)'
      ::subUKey  := 'StrZero(POKLADIT ->nINTCOUNT,5)'

      DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'POKLADHD' ;
      FIELDS 'M->oinf|tisk:T:2.6::2,'            + ;
             'M->oinf|danuzav:D:2.6::2,'         + ;
             'M->oinf|likvidace:L:2.6::2,'       + ;
             'M->oinf|ucuzav:U:2.6::2,'          + ;
             'NPOKLADNA:èísloPokl,'              + ;
             'CTYPDOK:typDokl,'                  + ;
             'NDOKLAD:èísloDokl,'                + ;
             'DPORIZDOK:datPoø,'                 + ;
             'CUCET_UCT:SuAu_Ø,'                 + ;
             'CTEXTDOK:úèel platby:32,'          + ;
             'FIN_pokladhd_BC(8):celkemDokl:13,' + ;
             'POKLADMS->CZKRATMENY:mìna'           ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked' ATSTART 'last' POPUPMENU 'y'

    ENDCASE
  DRGEND INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Položky' SIZE 105,11.5 OFFSET 14,70 PRE 'tabSelect' TABHEIGHT 0.8
    DO CASE
    CASE( ::typ = 'zav' )
      DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'PARPRZAL' ;
      FIELDS 'CVARZALFAK:varSymbol,'     + ;
             'NCISZALFAK:èísloFak,'      + ;
             'CUCTZALFAK:SuAu_S,'        + ;
             'CTEXTFAKT:Text zálohy:39,' + ;
             'NCENZALFAK:Záloha celkem,' + ;
             'NPARZALFAK:Pøevzato celkem'  ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked'

    CASE( ::typ = 'poh' )
      DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'FAKVYSIT' ;
      FIELDS 'cSKLPOL:sklPoložka,'     + ;
             'cNAZZBO:název Zboží:35,' + ;
             'nFAKTMNOZ:faktMnož,'     + ;
             'nCeCPrKDZ:celkSDPh,'     + ;
             'nCECPRKBZ:celkBDPh,'     + ;
             'nRADVYKDPH:øádekVýk'       ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked'

    CASE( ::typ = 'ban' .or. ::typ = 'vzz' )
      DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'BANVYPIT' ;
      FIELDS 'M->err_imp_it:E:2.4::2,'      + ;
             'FIN_banvypit_BC(1):_:2.7::2,' + ;
             'cVARSYM:varSymb,'             + ;
             'nCISFAK:èísloFak,'            + ;
             'dSPLATFAK:datSplat,'          + ;
             'dDATUHRADY:datÚhrady,'        + ;
             'cTEXT:text Položky:36,'       + ;
             'nCENZAKCEL:celkÚhrada,'       + ;
             'FIN_banvypit_BC(8):typ:2.7::2'  ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked'

     CASE( ::typ = 'pok' )
       DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 105,10.5 FILE 'POKLADIT' ;
       FIELDS 'CVARSYM:varSymbol,'                + ;
              'NCISFAK:èísloFak,'                 + ;
              'NCISFIRMY:èísloFirmy,'             + ;
              'CNAZEV:název Firmy:49,'            + ;
              'FIN_pokladhd_BC(52):celkemPol:13,' + ;
              'CTYPOBRATU:typ'                      ;
      SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy' INDEXORD 1 ITEMMARKED 'itemMarked'

    ENDCASE
  DRGEND INTO drgFC

  DRGTEXT INTO drgFC CAPTION 'Likvidace dokladu' CPOS 0.5,11.8 CLEN 104 FONT 5 PP 3 BGND 11 CTYPE 1
  odrg:resize := 'y'

  DRGDBROWSE INTO drgFC FPOS 0,13 SIZE 105,8.5 FILE 'UCETPOL' ;
    FIELDS 'nDOKLAD,'               + ;
           'cOBDOBI:obdÚÈ,'         + ;
           'CTEXT:Text dokladu:45,' + ;
           'cUCETMD:SuAu_Ø,'        + ;
           'nKCMD,'                 + ;
           'nKCDAL,'                + ;
           'cUCETDAL:SuAu_S'          ;
    SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yx' INDEXORD 4

*  INFO DEFINITION
   DRGSTATIC INTO drgFC FPOS 1,22 SIZE 103,2.5 STYPE 13 RESIZE 'y'
     DRGTEXT INTO drgFC CPOS  3,0.1 CLEN 11 CAPTION 'VýrStøedisko' PP 3 BGND 1
     DRGTEXT INTO drgFC CPOS  3,1.2 CLEN 13 NAME UCETPOL->cNAZPOL1 PP 2 BGND 13

     DRGTEXT INTO drgFC CPOS 19,0.1 CLEN  8 CAPTION 'Výrobek'      PP 3 BGND 1
     DRGTEXT INTO drgFC CPOS 19,1.2 CLEN 13 NAME UCETPOL->cNAZPOL2 PP 2 BGND 13

     DRGTEXT INTO drgFC CPOS 35,0.1 CLEN  8 CAPTION 'Zakázka'      PP 3 BGND 1
     DRGTEXT INTO drgFC CPOS 35,1.2 CLEN 13 NAME UCETPOL->cNAZPOL3 PP 2 BGND 13

     DRGTEXT INTO drgFC CPOS 51,0.1 CLEN  9 CAPTION 'VýrMísto'     PP 3 BGND 1
     DRGTEXT INTO drgFC CPOS 51,1.2 CLEN 13 NAME UCETPOL->cNAZPOL4 PP 2 BGND 13

     DRGTEXT INTO drgFC CPOS 67,0.1 CLEN  6 CAPTION 'Stroj'        PP 3 BGND 1
     DRGTEXT INTO drgFC CPOS 67,1.2 CLEN 13 NAME UCETPOL->cNAZPOL5 PP 2 BGND 13

     DRGTEXT INTO drgFC CPOS 83,0.1 CLEN 10 CAPTION 'VýrOperace'   PP 3 BGND 1
     DRGTEXT INTO drgFC CPOS 83,1.2 CLEN 13 NAME UCETPOL->cNAZPOL6 PP 2 BGND 13

     DRGSTATIC INTO drgFC FPOS 1,0.4 SIZE 101,0.1 STYPE 12
     DRGEND INTO drgFC
   DRGEND INTO drgFC


/*
   DRGACTION INTO drgFC CAPTION '~Pøevzít' EVENT 'doPrevzit' PRE '2' ;
             TIPTEXT 'Pøevzít vyrbané položka do pøíkazu'
*/
RETURN drgFC


METHOD FIN_likvidace_scr:drgDialogStart(drgDialog)
*-  (::mainFile) ->( DBGoBottom())
RETURN


METHOD FIN_likvidace_scr:itemMarked(aRowCol,uNIL,oXbp)
  LOCAL cKy := DBGetVal(::mainKey)

  IF ::tabNum = 1
    ucetpol->(mh_ordSetScope(cKy))
  ELSE
    ucetpol->(mh_ordSetScope(cKy +DBGetVal(::subUKey)))
  ENDIF
RETURN SELF


METHOD FIN_likvidace_scr:tabSelect(drgTabPage, tabNum)
  LOCAL  oBROw, cFILe

  IF ::tabNum <> tabNum
    oBROw := ::drgDialog:dialogCtrl:oBrowse
    cFILe := oBROw[2]:cFile

    DO CASE
    CASE(::tabNum = 1 .and. tabNum = 2)
      (cFile)->(mh_ordSetScope(DBGetVal(::subKey)))
      oBROw[2]:refresh(.T.)
    CASE(::tabNum = 2 .and. tabNum = 1)
      (cFILe) ->(DbClearScope())
    ENDCASE

    ::tabNum := tabNum
  ENDIF
RETURN .T.

method FIN_likvidace_scr:drgDialogEnd(drgDialog)
  if ( ::typ = 'ban' .or. ::typ = 'vzz' )
    banvyphd ->(ads_clearAof())
  endif
RETURN