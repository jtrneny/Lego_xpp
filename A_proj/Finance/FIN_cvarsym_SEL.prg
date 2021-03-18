#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "drg.ch"
#include "Gra.ch"
//
#include "..\Asystem++\Asystem++.ch"


*
** CLASS FIN_cvarsym_SEL *******************************************************
*                                 ban.vzz.pok, 1-edit, 2-append
FUNCTION FIN_CVARSYM_BCZ(nCOLUMn, typ_state)                       // závazky
  local  retVal, inFile := 'fakprihd'
  local  typ_dokl := Left(typ_state, at(',', typ_state) -1), newRec := ('2' $ typ_state)
  local  hdFile   := if(typ_dokl $ 'ban,vzz,uhr', 'banvyphdw', 'pokladhdw')
  *
  local  koe      := (hdFile)->nkurZahMen / (hdFile)->nmnozPrep
  local  cky

  * SCR *
  DO CASE
  CASE nCOLUMn == 1 ; retVal := FIN_cvarsym_INFO(inFile,typ_dokl,newRec)
  CASE nCOLUMn == 5 ; retVal := FIN_cvarsym_CENA(inFile,typ_dokl,newRec)
  CASE nCOLUMn == 6 ; retVal := FIN_cvarsym_NEU (inFile,typ_dokl,newRec)
  CASE nCOLUMn == 7 ; retVal := FIN_cvarsym_MENA(inFile)
  case ncolumn == 8 ; retVal := ((inFile)->ncenZakCel -(inFile)->nuhrCelFak) / koe
  ENDCASE
RETURN retVal

FUNCTION FIN_CVARSYM_BCP(nCOLUMn, typ_state)                       // pohledávky
  local  retVal, inFile := 'fakvyshd'
  local  typ_dokl := Left(typ_state, at(',', typ_state) -1), newRec := ('2' $ typ_state)
  local  file     := if(typ_dokl $ 'ban,vzz,uhr', 'banvyphdw', 'pokladhdw')
  *
  local  koe      := (file)->nkurZahMen / (file)->nmnozPrep

  * SCR *
  DO CASE
  CASE nCOLUMn == 1 ; retVal := FIN_cvarsym_INFO(inFile,typ_dokl,newRec)
  CASE nCOLUMn == 5 ; retVal := FIN_cvarsym_CENA(inFile,typ_dokl,newRec)
  CASE nCOLUMn == 6 ; retVal := FIN_cvarsym_NEU (inFile,typ_dokl,newRec)
  CASE nCOLUMn == 7 ; retVal := FIN_cvarsym_MENA(inFile)
  case ncolumn == 8 ; retVal := ((inFile)->ncenZakCel -(inFile)->nuhrCelFak) / koe
  ENDCASE
RETURN retVal

FUNCTION FIN_CVARSYM_BCM(nCOLUMn, typ_state)                       // Mz_závazky
  local  retVal, inFile := 'mzdzavhd'
  local  typ_dokl := Left(typ_state, at(',', typ_state) -1), newRec := ('2' $ typ_state)
  local  hdFile   := if(typ_dokl $ 'ban,vzz,uhr', 'banvyphdw', 'pokladhdw')
  *
  local  koe      := (hdFile)->nkurZahMen / (hdFile)->nmnozPrep
  local  cky

  * SCR *
  DO CASE
  CASE nCOLUMn == 1 ; retVal := FIN_cvarsym_INFO(inFile,typ_dokl,newRec)
  CASE nCOLUMn == 5 ; retVal := FIN_cvarsym_CENA(inFile,typ_dokl,newRec)
  CASE nCOLUMn == 6 ; retVal := FIN_cvarsym_NEU (inFile,typ_dokl,newRec)
  CASE nCOLUMn == 7 ; retVal := FIN_cvarsym_MENA(inFile)
  case ncolumn == 8 ; retVal := ((inFile)->ncenZakCel -(inFile)->nuhrCelFak) / koe
  ENDCASE
RETURN retVal

*
function FIN_cvarsym_tuzuc(typ_dokl)
  local  file     := if(typ_dokl $ 'ban,vzz,uhr', 'banvyphdw', 'pokladhdw')
  local  zkrMeny  := if(file = 'banvyphdw', (file)->czkratMeny, (file)->czkratMenz)
  static zaklMena

  if(IsNull(zaklMena), zaklMena := SysConfig('Finance:cZaklMena'), nil)
return Equal(zaklMena, zkrMeny)


** COLUMN_1 **
static function FIN_cvarsym_info(inFile,typ_dokl,newRec)
  LOCAL xRETval := ' '
  *
  LOCAL _CENA := FIN_cvarsym_CENA(inFile,typ_dokl)
  LOCAL _NEU  := FIN_cvarsym_NEU (inFile,typ_dokl,newRec)

  IF     _NEU = 0      ;  xRETval := IF(_CENA <> 0, 'H', '.')
  ELSEIF _CENA > _NEU  ;  xRETval := 'h'
  ELSEIF _CENA < _NEU  ;  xRETval := '?'
  ENDIF
RETURN xRETval

** COLUMN_5 **
static function FIN_cvarsym_cena(inFile,typ_dokl)                    // celkem nCENZAKCEL/nCENZAHCEL
RETURN IF( FIN_cvarsym_tuzuc(typ_dokl), (inFile) ->nCENZAKCEL, (inFile) ->nCENZAHCEL)


** COLUMN_6
function FIN_cvarsym_NEU(inFile,typ_dokl,newRec)                                // zbývá uhradit
  local  file  := if(typ_dokl $ 'ban,vzz,uhr', 'banvyphdw', 'pokladhdw')
  local  retVal, koe

  koe := (file)->nkurZahMen/ (file)->nmnozPrep
  if(koe = 0, koe := 1, nil)

  retVal := ((inFile)->ncenZakCel -(inFile)->nuhrCelFak) / koe
return retVal


** COLUMN_7
FUNCTION FIN_cvarsym_MENA(inFile)                                               // zkratka mìny
RETURN  Coalesce((inFile) ->cZKRATMENZ, (inFile) ->cZKRATMENY)
**

*
** základní tøída pro nabídku a kontrolu údaje cvarsym *************************
** parent   fin_ban_vzz_pok_in
CLASS FIN_CVARSYM_SEL FROM drgUsrClass
EXPORTED:
  var     fakturovano, uhrazeno, kuhrade

  METHOD  init, getForm, drgDialogStart, destroy
  METHOD  tabSelect, createContext, fromContext


  inline method browseStart( drgDBrow )
    if lower(drgDBrow:cfile) = 'fakvyshd'
      drgDBrow:oXbp:itemRbDown := { |mp1,mp2,obj| drgDBrow:createContext(mp1,mp2,obj) }
    endif
    return self

  * fakprihd - Z - ávazky
  inline access assign method kuhrade_vzmz() var kuhrade_vzmz
    return FAKPRIHD ->nCENZAKCEL -FAKPRIHD ->nUHRCELFAK
  inline access assign method kuhrade_vcmz() var kuhrade_vcmz
    return FAKPRIHD ->nCENZAHCEL -FAKPRIHD ->nUHRCELFAZ

  * fakvyshd - P - ohledávky
  inline access assign method kuhrade_vzmp() var kuhrade_vzmp
    return FAKVYSHD->nCENZAKCEL -FAKVYSHD ->nUHRCELFAK
  inline access assign method kuhrade_vcmp() var kuhrade_vcmp
    return FAKVYSHD->nCENZAHCEL -FAKVYSHD ->nUHRCELFAZ

  **
  ** EVENT *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close,drgEVENT_SELECT,,::drgDialog:dialog)
      return .t.

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
      return .t.
    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  VAR     drgVar, lNEWrec, typ_dokl, typ_state, hd_file, it_file
  VAR     tabNum, drgPush, apopUp, popState, m_filter
  VAR     parent
  var     a_tabSelect

  var     oDBrow
  VAR     msg, dm, dc, df, rowPos

  * ads_customizeAof
  var     ain_file
ENDCLASS


METHOD FIN_CVARSYM_SEL:init(parent)
  Local  nEvent,mp1,mp2,oXbp
  LOCAL  cFn := parent:parent:formName, ain_file := aclone(parent:parent:UDCP:ain_file)
  *
  ** staèí mì jeden jsou shodnì nastavené pro fakVyshd, fakPrihd, mzdZavhd **
  ::m_filter := (ain_file[1,1])->(ads_getAof())
  ::drgVar   := parent:parent:lastXbpInFocus:cargo

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgVar := oXbp:cargo
  ENDIF
   *
  ::typ_dokl    := parent:parent:UDCP:typ_dokl
  ::tabNum      := 1
  ::lNEWrec     := parent:parent:UDCP:lNEWrec

  ::apopUp      := { 'Kompletní seznam závazkù,Neuhrazené závazky,Èásteènì uhrazené závazky'         , ;
                     'Kompletní seznam pohledávek,Neuhrazené pohledávky,Èásteènì uhrazené pohledávky', ;
                     'Kompletní seznam Mz_závazkù,Neuhrazené Mz_závazky,Èásteènì uhrazené Mz_závazky' }
  ::popState    := {  2 ,  2 ,  2  }
  ::a_tabSelect := { .t., .f., .f. }
  ::ain_file    := parent:parent:udcp:ain_file
  ::parent      := parent:parent
  *
  if(::typ_dokl $ 'ban,vzz,uhr', (::hd_file := 'BANVYPHDw', ::it_file := 'BANVYPITw'), ;
                                 (::hd_file := 'POKLADHDw', ::it_file := 'POKLADITw')  )
  ::typ_state := ::typ_dokl +';' +if(::lNEWrec,'2','1')
  *
  ::parent:pushArea()
  *
  drgDBMS:open('C_BANKUC')
  drgDBMS:open('POKLADMS')

  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_cvarsym_SEL:getForm()
  local  odrg, drgFC
  local  kuhr    := 'k uhradì v ' +(::hd_file)->czkratMeny
  local  zkrMeny := lower(SysConfig('Finance:cZaklMena'))

  ::fakturovano := 'fakturováno v ' +zkrMeny
  ::uhrazeno    := 'uhrazeno v '    +zkrMeny
  ::kuhrade     := 'k uhradì v '    +lower( (::hd_file)->czkratMeny)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,17.6 DTYPE '10' TITLE 'Seznam závazkù a pohledávek ...' ;
                                              GUILOOK 'All:N,Border:Y'

  DRGTABPAGE INTO drgFC CAPTION 'Závazky' SIZE 100,17.6 OFFSET 1,82 PRE 'tabSelect' TABHEIGHT 1.2
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 100,11.4 FILE 'FAKPRIHD'              ;
      FIELDS 'FIN_cvarsym_BCZ(1;"' +::typ_state +'"): :2,'                    + ;
             'cVARSYM:varSymbol,'                                             + ;
             'nCISFAK:èísloFaktury:10,'                                       + ;
             'nCISFIRMY:firma,'                                               + ;
             'cNAZEV:názevFirmy:43,'                                          + ;
             'nICO:ièo,'                                                      + ;
             'ncenzakcel:FIN_cvarsym_SEL|fakturovano,'                        + ;
             'nuhrcelfak:FIN_cvarsym_SEL|uhrazeno,'                           + ;
             'ncenzahcel:fakurováno v zm,'                                    + ;
             'nuhrcelfaz:uhrazeno v zm,'                                      + ;
             'FIN_cvarsym_BCZ(7;"' +::typ_state +'"): :4,'                    + ;
             'FIN_cvarsym_BCZ(8;"' +::typ_state +'"):FIN_cvarsym_SEL|kuhrade'   ;
      CURSORMODE 3 PP 7 INDEXORD 2 POPUPMENU 'y'


    * info
    DRGSTATIC INTO drgFC FPOS 1,12 SIZE 98.2,3.9 STYPE 12 RESIZE 'y'
    odrg:ctype := 2
      * 1
      DRGTEXT INTO drgFC CAPTION 'faktura'         CPOS  1, .5
      DRGTEXT INTO drgFC NAME FAKPRIHD->nCENZAKCEL CPOS 12, .5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKPRIHD->cZKRATmeny CPOS 25, .5 CLEN  5 FONT 5

      DRGTEXT INTO drgFC NAME FAKPRIHD->nCENzahCEL CPOS 30, .5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKPRIHD->cZKRATmenz CPOS 43, .5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC CAPTION 'splatno'         CPOS 53, .5 CLEN 10
      DRGTEXT INTO drgFC NAME FAKPRIHD->dSPLATfak  CPOS 67, .5 CLEN 10 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKPRIHD->cZKRtypUHR CPOS 79, .5 CLEN  5 BGND 13 PP 2
      * 2
      DRGTEXT INTO drgFC CAPTION 'uhrazeno'        CPOS  1,1.5
      DRGTEXT INTO drgFC NAME FAKPRIHD->nUHRcelFAK CPOS 12,1.5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKPRIHD->cZKRATmeny CPOS 25,1.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC NAME FAKPRIHD->nUHRcelFAZ CPOS 30,1.5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKPRIHD->cZKRATmenz CPOS 43,1.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC CAPTION 'dne'             CPOS 53,1.5 CLEN 10
      DRGTEXT INTO drgFC NAME FAKPRIHD->dPOSuhrFAK CPOS 67,1.5 CLEN 10 BGND 13 PP 2 CTYPE 2
      * 3
      DRGTEXT INTO drgFC CAPTION 'k úhradì'        CPOS  1,2.5
      DRGTEXT INTO drgFC NAME M->kuhrade_vzmz      CPOS 12,2.5 CLEN 13 BGND 13 PP 2 PICTURE '@N 9999999999.99' CTYPE 2
      DRGTEXT INTO drgFC NAME FAKPRIHD->cZKRATmeny CPOS 25,2.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC NAME M->kuhrade_vcmz      CPOS 30,2.5 CLEN 13 BGND 13 PP 2 PICTURE '@N 9999999999.99' CTYPE 2
      DRGTEXT INTO drgFC NAME FAKPRIHD->cZKRATmenz CPOS 43,2.5 CLEN  5 FONT 5
    DRGEND INTO drgFC
  DRGEND INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Pohledávky' SIZE 100,17.6 OFFSET 18,65 PRE 'tabSelect' TABHEIGHT 1.2
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 100,11.4 FILE 'FAKVYSHD'     ;
      FIELDS 'FIN_cvarsym_BCP(1;"' +::typ_state +'"): :2,'                    + ;
             'cVARSYM:varSymbol,'                                             + ;
             'nCISFAK:èísloFaktury:10,'                                       + ;
             'nCISFIRMY:firma,'                                               + ;
             'cNAZEV:názevFirmy:43,'                                          + ;
             'nICO:ièo,'                                                      + ;
             'ncenzakcel:FIN_cvarsym_SEL|fakturovano,'                        + ;
             'nuhrcelfak:FIN_cvarsym_SEL|uhrazeno,'                           + ;
             'ncenzahcel:fakurováno v zm,'                                    + ;
             'nuhrcelfaz:uhrazeno v zm,'                                      + ;
             'FIN_cvarsym_BCP(7;"' +::typ_state +'"): :4,'                    + ;
             'FIN_cvarsym_BCP(8;"' +::typ_state +'"):FIN_cvarsym_SEL|kuhrade'   ;
      CURSORMODE 3 PP 7 INDEXORD 2 POPUPMENU 'y'

     * info
    DRGSTATIC INTO drgFC FPOS 1,12 SIZE 98.2,3.9 STYPE 12 RESIZE 'y'
    odrg:ctype := 2
      * 1
      DRGTEXT INTO drgFC CAPTION 'faktura'         CPOS  1, .5
      DRGTEXT INTO drgFC NAME FAKVYSHD->nCENZAKCEL CPOS 12, .5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKVYSHD->cZKRATmeny CPOS 25, .5 CLEN  5 FONT 5

      DRGTEXT INTO drgFC NAME FAKVYSHD->nCENzahCEL CPOS 30, .5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKVYSHD->cZKRATmenz CPOS 43, .5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC CAPTION 'splatno'         CPOS 53, .5 CLEN 10
      DRGTEXT INTO drgFC NAME FAKVYSHD->dSPLATfak  CPOS 67, .5 CLEN 10 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKVYSHD->cZKRtypUHR CPOS 79, .5 CLEN  5 BGND 13 PP 2
      * 2
      DRGTEXT INTO drgFC CAPTION 'uhrazeno'        CPOS  1,1.5
      DRGTEXT INTO drgFC NAME FAKVYSHD->nUHRcelFAK CPOS 12,1.5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKVYSHD->cZKRATmeny CPOS 25,1.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC NAME FAKVYSHD->nUHRcelFAZ CPOS 30,1.5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME FAKVYSHD->cZKRATmenz CPOS 43,1.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC CAPTION 'dne'             CPOS 53,1.5 CLEN 10
      DRGTEXT INTO drgFC NAME FAKPRIHD->dPOSuhrFAK CPOS 67,1.5 CLEN 10 BGND 13 PP 2 CTYPE 2
      * 3
      DRGTEXT INTO drgFC CAPTION 'k úhradì'        CPOS  1,2.5
      DRGTEXT INTO drgFC NAME M->kuhrade_vzmp      CPOS 12,2.5 CLEN 13 BGND 13 PP 2 PICTURE '@N 9999999999.99' CTYPE 2
      DRGTEXT INTO drgFC NAME FAKVYSHD->cZKRATmeny CPOS 25,2.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC NAME M->kuhrade_vcmp      CPOS 30,2.5 CLEN 13 BGND 13 PP 2 PICTURE '@N 9999999999.99' CTYPE 2
      DRGTEXT INTO drgFC NAME FAKVYSHD->cZKRATmenz CPOS 43,2.5 CLEN  5 FONT 5
    DRGEND INTO drgFC
  DRGEND INTO drgFC


  DRGTABPAGE INTO drgFC CAPTION 'Mz_Závazky' SIZE 100,17.6 OFFSET 34,48 PRE 'tabSelect' TABHEIGHT 1.2
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 100,11.4 FILE 'MZDZAVHD'              ;
      FIELDS 'FIN_cvarsym_BCM(1;"' +::typ_state +'"): :2,'                    + ;
             'cVARSYM:varSymbol,'                                             + ;
             'nCISFAK:èísloFaktury:10,'                                       + ;
             'nCISFIRMY:firma,'                                               + ;
             'cNAZEV:názevFirmy:43,'                                          + ;
             'nICO:ièo,'                                                      + ;
             'ncenzakcel:FIN_cvarsym_SEL|fakturovano,'                        + ;
             'nuhrcelfak:FIN_cvarsym_SEL|uhrazeno,'                           + ;
             'ncenzahcel:fakurováno v zm,'                                    + ;
             'nuhrcelfaz:uhrazeno v zm,'                                      + ;
             'FIN_cvarsym_BCM(7;"' +::typ_state +'"): :4,'                    + ;
             'FIN_cvarsym_BCM(8;"' +::typ_state +'"):FIN_cvarsym_SEL|kuhrade'   ;
      CURSORMODE 3 PP 7 INDEXORD 2 POPUPMENU 'y'

    * info
    DRGSTATIC INTO drgFC FPOS 1,12 SIZE 98.2,3.9 STYPE 12 RESIZE 'y'
    odrg:ctype := 2
      * 1
      DRGTEXT INTO drgFC CAPTION 'faktura'         CPOS  1, .5
      DRGTEXT INTO drgFC NAME MZDZAVHD->nCENZAKCEL CPOS 12, .5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME MZDZAVHD->cZKRATmeny CPOS 25, .5 CLEN  5 FONT 5

      DRGTEXT INTO drgFC NAME MZDZAVHD->nCENzahCEL CPOS 30, .5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME MZDZAVHD->cZKRATmenz CPOS 43, .5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC CAPTION 'splatno'         CPOS 53, .5 CLEN 10
      DRGTEXT INTO drgFC NAME MZDZAVHD->dSPLATfak  CPOS 67, .5 CLEN 10 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME MZDZAVHD->cZKRtypUHR CPOS 79, .5 CLEN  5 BGND 13 PP 2
      * 2
      DRGTEXT INTO drgFC CAPTION 'uhrazeno'        CPOS  1,1.5
      DRGTEXT INTO drgFC NAME MZDZAVHD->nUHRcelFAK CPOS 12,1.5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME MZDZAVHD->cZKRATmeny CPOS 25,1.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC NAME MZDZAVHD->nUHRcelFAZ CPOS 30,1.5 CLEN 13 BGND 13 PP 2 CTYPE 2
      DRGTEXT INTO drgFC NAME MZDZAVHD->cZKRATmenz CPOS 43,1.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC CAPTION 'dne'             CPOS 53,1.5 CLEN 10
      DRGTEXT INTO drgFC NAME MZDZAVHD->dPOSuhrFAK CPOS 67,1.5 CLEN 10 BGND 13 PP 2 CTYPE 2
      * 3
      DRGTEXT INTO drgFC CAPTION 'k úhradì'        CPOS  1,2.5
      DRGTEXT INTO drgFC NAME M->kuhrade_vzmz      CPOS 12,2.5 CLEN 13 BGND 13 PP 2 PICTURE '@N 9999999999.99' CTYPE 2
      DRGTEXT INTO drgFC NAME MZDZAVHD->cZKRATmeny CPOS 25,2.5 CLEN  5 FONT 5
      DRGTEXT INTO drgFC NAME M->kuhrade_vcmz      CPOS 30,2.5 CLEN 13 BGND 13 PP 2 PICTURE '@N 9999999999.99' CTYPE 2
      DRGTEXT INTO drgFC NAME MZDZAVHD->cZKRATmenz CPOS 43,2.5 CLEN  5 FONT 5
    DRGEND INTO drgFC
  DRGEND INTO drgFC

  DRGPUSHBUTTON INTO drgFC CAPTION 'Neuhrazené závazky' POS 68,0.05 SIZE 31,1 ;
                EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'
RETURN drgFC


METHOD FIN_CVARSYM_SEL:drgDialogStart(drgDialog)
  local  members  := drgDialog:oForm:aMembers
  local  showDlg  := .T., file_iv, varSym, tagNo, pa
  *
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize
  local  drgDBrow  := drgDialog:odbrowse[2]

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::oDBrow   := drgDialog:dialogCtrl:oBrowse


  if IsObject(::drgVar)
    apos := mh_GetAbsPosDlg(::drgVar:oXbp,drgDialog:dataAreaSize)
// ne    drgDialog:usrPos := {aPos[1],aPos[2] -25}
  endif

  *
  if IsCharacter(drgDialog:cargo)
    pa := ListAsArray(drgDialog:cargo)

    (file_iv := pa[1], varSym := pa[2], tagNo := Val(pa[3]))
    (file_iv)->(dbseek(varSym,, AdsCtag(tagNo) ))
  endif

  for x := 1 TO LEN(members) step 1
    IF( members[x]:ClassName() = 'drgPushButton', ::drgPush := members[x], NIL )
  next

  ::drgPush:oXbp:setFont(drgPP:getFont(5))
  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

  ::fromContext(2, 'Neuhrazené závazky')

  * požadavek na pokladnì
  if ::typ_Dokl = 'pok'
    do case
    case (::hd_file)->ntypDok = 1   //  pøíjem na pokladnu - fakVyshd
      drgDialog:oForm:tabPageManager:showPage(2)
    case (::hd_file)->ntypDok = 2   //  výdej   z pokladny - fakPrihd
    endcase
  endif

*  drgDBrow:oXbp:itemRbDown := { |mp1,mp2,obj| drgDBrow:createContext(mp1,mp2,obj) }
return self


METHOD FIN_CVARSYM_SEL:destroy()
  ::parent:popArea()

  ::drgVar   := ;
  ::lNEWrec  := ;
  ::tabNum   := ;
  ::drgPush  := ;
  ::apopUp   := ;
  ::popState := ;
  ::parent   := NIL

  fakprihd->(ads_clearAof())
  fakvyshd->(ads_clearAof())
RETURN


METHOD FIN_cvarsym_SEL:tabSelect(drgTabPage, tabNum)
  local  pA       := ListAsArray(::apopUp[tabNum])
  local  oaBrowse := ::drgDialog:dialogCtrl:oaBrowse
  local  oColumn  := oaBrowse:oxbp:getColumn(1)
  *
  local  dc := ::dc, oDBrow   := ::oDBrow

  ::tabNum := tabNum
  ::drgPush:oxbp:setCaption(pA[ ::popState[tabNum]])

  if .not. ::a_tabSelect[tabNum]
    ::fromContext(2, pA[ ::popState[tabNum]] )
    ::a_tabSelect[tabNum] := .t.

    ::dc:sp_resetActiveArea( ::oDBrow[tabNum] )
  endif

  PostAppEvent(xbeBRW_ItemMarked,,, ::drgDialog:dialogCtrl:oaBrowse:oXbp)
RETURN .T.


**
METHOD FIN_cvarsym_SEL:createContext()
  LOCAL cSubMenu, oPopup, aPos, aSize
  *
  LOCAL x, popUp, pA, nIn

  popUp := ::apopUp[::tabNum]
  pA    := ListAsArray(popup)

  cSubMenu := drgNLS:msg(popUp)
  oPopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  FOR x := 1 TO LEN(pA)
    oPopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  NEXT

  oPopup:disableItem(::popState[::tabNum])

  aPos    := ::drgPush:oXbp:currentPos()
  oPopup:popup(::drgDialog:dialog, aPos)
RETURN self


METHOD FIN_cvarsym_SEL:fromContext(aOrder, nMENU)
  local oBRo    := ::drgDialog:dialogCtrl:oBrowse[::tabNum]
  local in_file := lower(oBRo:cfile)
  local filter  := ::m_filter +if(.not. empty(::m_filter), " .and. ", "")
  *
  local cusAof_pulRecords := ::ain_file[::tabNum,8]

  ::popState[::tabNum] := aOrder
  ::drgPush:oxbp:setCaption(nMENU)

  (in_file)->( ads_setAof('1=1'))

  do case
  case(aorder = 1)                               // kompletní seznan
    if .not. empty(::m_filter)
      (in_file)->(ads_setAof(::m_filter))
    else
      (in_file)->(ads_clearAof())
    endif

  otherwise
    do case
    case(aorder = 2)                             // neuhrazeno
      filter += " (ncenZakCel <> 0) .and. (nuhrCelFak = 0)"

    case(aorder = 3)                             // èásteènì uhrazeno
      filter += " (ncenZakCel - nuhrCelFak) <> 0 .and. (nuhrCelFak <> 0)"
    endcase

    if( .not. empty(filter),(in_file)->(ads_setAof(filter)), nil)
  endcase

  if len(cusAof_pulRecords) <> 0
    (in_file)->( ads_customizeAof( cusAof_pulRecords, 2) )
  endif

  (in_file)->(dbGoTop())
  oBRo:oXbp:refreshAll()
RETURN self