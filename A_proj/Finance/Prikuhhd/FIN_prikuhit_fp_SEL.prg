#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
//
#include "..\Asystem++\Asystem++.ch"
#include "..\FINANCE\FIN_finance.ch"


*
** CLASS for FIN_prikuhit_fp_SEL ***********************************************
FUNCTION FIN_prikuhit_fp_BC(nCOLUMn)
  LOCAL  nCEN    := FAKPRIHD ->nCENZAKCEL, nUHR, nZBY
  LOCAL  xRETval := 0

  DO CASE
  CASE( nCOLUMn = 0)                                       // x - . inkaso
    c_typuhr->( dbSeek( upper( fakprihd->czkrTypUhr )))
    xRETval := if( c_typuhr->lIsInkaso, MIS_ICON_ERR, 0)

  CASE( nCOLUMn = 1)                                       // H - h -  uhrazeno
    ncen := fakprihd->ncenZahCel
    nuhr := fakprihd->nuhrCelFaz
    xRETval := IF(nUHR = 0, 0, IF(nUHR < nCEN, H_low, IF(nUHR = nCEN, H_big, MIS_ICON_ERR)))

  CASE( nCOLUMn = 2 )                                      // P - p -  pøíkazy
    nZBY    := FIN_prikuhit_fp_ZBY()
    nuhr    := fakprihd->npriuhrCel
    xRETval := IF(nZBY = 0, P_big, IF(nZBY < nuhr, P_low, 0))

  CASE( nCOLUMn = 7 )                                      // zbývá uhradit v mìnì PØIKAZU
    xRETval := FIN_prikuhit_fp_ZBY()

  CASE( nCOLUMN = 8 )                                      // zbývá uhradit v mìnì FAKTURY
    xRETval := FIN_prikuhit_fp_ZBY_FAK()

  ENDCASE
RETURN xRETval


function FIN_prikuhit_fp_ZBY_FAK()
  local  cKy := Upper( FAKPRIHD ->cDENIK) +StrZero( FAKPRIHD ->nCISFAK,10)
  local  nkoe, n_cenZahCel, n_uhrCelFaz, n_priUhrCel

  prikUhi_w->( dbseek( cky,, 'PRIKUHIT_2'))
  priUhr     := prikUhi_w->npriUhrCel * if( prikUhi_w->_delrec = '9', +1, 0 )

  n_cenZahCel := fakprihd->ncenZahCel
  n_uhrCelFaz := fakprihd->nuhrCelFaz
  n_priUhrCel := fakprihd->npriUhrCel

  if ( n_priUhrCel - n_uhrCelFaz) <= 0
    return (n_cenZahCel - n_uhrCelFaz) +priUhr
  else
    return ( n_cenZahcel -( n_priUhrCel + n_uhrCelFaz )) +priUhr
  endif
return 0


FUNCTION FIN_prikuhit_fp_ZBY()
  LOCAL  nZBY_uhr, nRECs := PRIKUHITw ->( RecNo())
  LOCAL  cKy  := Upper( FAKPRIHD ->cDENIK) +StrZero( FAKPRIHD ->nCISFAK,10)
  LOCAL  isIn := .f.
  *
  local  nkoe, n_cenZahCel, n_uhrCelFaz, n_priUhrCel
  local  ndeciMals
  local  val := 0
  local  istuz_Zuc, istuz_Zal

  static zaklMena
  if( isNull(zaklMena) , zaklMena  := SysConfig('Finance:cZaklMena'), nil )

  isIn := prikUhi_w->( dbseek( cky,, 'PRIKUHIT_2'))

  istuz_UcPr := Equal( zaklMena, prikuhhdw ->czkratMenU)
  istuz_UcFa := Equal( zaklMena, fakPriHD  ->czkratMenZ )
  priUhr     := prikUhi_w->npriUhrCel * if( prikUhi_w->_delrec = '9', +1, 0 )  // -1

  * shodné mìny poøíkazu i faktury pøijaté
  if prikuhhdw->czkratMenU = fakprihd->czkratMenZ
    n_cenZahCel := fakprihd->ncenZahCel
    n_uhrCelFaz := fakprihd->nuhrCelFaz
    n_priUhrCel := fakprihd->npriUhrCel                 // zahranièní - tuzemská ?

  else
  * rùzné mìny pøíkazu a faktury pøijate

    ndeciMals := Set( _SET_DECIMALS, 3 )

    do case
    case istuz_UcPr .and. .not. istuz_UcFa              // pøíkaz v tuzemské mìnì - faktura v zahranièní
      kurzit->( dbseek( upper( fakPriHD->czkratMenZ),,'KURZIT9'))

      nkoe        := kurzit->nkurzStred/ kurzit->nmnozPrep
      n_cenZahCel := fakPriHD ->ncenZahCel * nkoe
      n_uhrCelFaz := fakPriHD ->nuhrCelFaz * nkoe
      n_priUhrCel := fakprihd ->npriUhrCel * nkoe       // zahranièní - tuzemská ?

    case .not. istuz_UcPr .and. istuz_UcFa              // pøíkaz v zahranièní mìnì - faktura v tuzemské
      nkoe        := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen
      n_cenZahCel := fakPriHD ->ncenZahCel * nkoe
      n_uhrCelFaz := fakPriHD ->nuhrCelFaz * nkoe
      n_priUhrCel := fakprihd ->npriUhrCel * nkoe       // zahranièní - tuzemská ?

    case .not. istuz_UcPr .and. .not. istuz_UcFa        // poøkaz v zahranièní mìnì - faktura zahranièní
      kurzit->( dbseek( upper( fakpriHD->czkratMenZ),,'KURZIT9'))

      nkoe        := (kurzit->nkurzStred/ kurzit->nmnozPrep) / (prikUhHDw->nkurZahMen/ prikUhHDw->nmnozPrep)
      n_cenZahCel := fakPriHD ->ncenZahCel * nkoe
      n_uhrCelFaz := fakPriHD ->nuhrCelFaz * nkoe
      n_priUhrCel := fakprihd ->npriUhrCel * nkoe       // zahranièní - tuzemská ?
    endcase

    Set( _SET_DECIMALS, ndeciMals)
  endif

  if ( n_priUhrCel - n_uhrCelFaz) <= 0
    return (n_cenZahCel - n_uhrCelFaz) +priUhr
  else
    return ( n_cenZahcel -( n_priUhrCel + n_uhrCelFaz )) +priUhr
  endif
return 0
*
**
CLASS FIN_prikuhit_fp_SEL FROM drgUsrClass, quickFiltrs_withCustomizeAof
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart, drgDialogEnd
  method  doPrevzit
  *
  var     d_bro, pa_vazRecs, cfiltr_fp_sel
  *
  ** FAKPRIHD stav/ fakturu lze pøevzít do pøíkazu
  ** žlutá BMP indikuje Pøeshranièní platbu
  inline access assign method fakprihd_isOk() var fakprihd_isOk
    c_typuhr->( dbSeek( upper( fakprihd->czkrTypUhr )))
    firmyUc ->( dbseek( upper(fakPriHD->cucet),, 'FIRMYUC2'))
    return if( FIN_prikuhit_fp_ZBY() > 0 .and. .not. c_typuhr->lIsInkaso,  ;
            if( firmyUc->cBANK_sta = fakPriHD->czkratStat, 6001, 6006)  , 0)

  inline access assign method fakprihd_dny_poSpl() var fakprihd_dny_poSpl
//    local posUhr    := if( empty(fakPrihd->dposUhrFak), date(), fakPrihd->dposUhrFak )
    local posUhr    := Date()
    local splFak    := fakPrihd->dsplatFak
    local dny_poSpl := 0

    dny_poSpl := if(empty(posUhr) .or. isNull( fakPrihd->sId, 0) = 0, 0, posUhr -splFak)
    return dny_poSpl // max(0, dny_poSpl)


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl
    *
    local  cInfo     := 'Promiòte prosím,' +CRLF

    DO CASE
    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      if FIN_prikuhit_fp_BC(0) = 0
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

      else
        cInfo += 'fakura poøjatá ( ' +allTrim( str( fakprihd->ncisFak)) +' )' +CRLF       + ;
                 'je hrazena inkasním poøkazem ...'                           +CRLF +CRLF + ;
                 '... NELZE PØEVZÍT DO PØÍKAZU K ÚHRADÌ ... '

        fin_info_box( cInfo, XBPMB_CRITICAL )
      endif

    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_FORMDRAWN
       Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      CASE mp1 = xbeK_SPACE
        IF FIN_prikuhit_fp_ZBY() > 0
          RETURN .F.
        ELSE
          RETURN .T.
        ENDIF

      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
    RETURN .T.

    *
    ** oznaèit položku pro pøevzetí, lze jen za splnìní podmínek
    ** je co hradit a není to inkaso uf...
    inline method mark_doklad()
      postAppEvent( xbeP_Keyboard, xbeK_CTRL_ENTER,,::d_bro:oXbp)
      return self // ::post_bro_colourCode()

    inline method save_marked()
      postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
//    postappevent(drgEVENT_EDIT,,,::d_bro:oxbp)
      return self

    inline method post_bro_colourCode()
      local recNo := (::in_file)->(recNo())  , ;
               pa := aclone(::d_bro:arselect), ;
              nOk := 0                       , in_file, obro, ardef, npos_in, ocol_is

      in_file := ::in_file
      obro    := ::d_bro
      ardef   := obro:ardef

      npos_is := ascan(ardef, {|x| x[2] = 'M->' +in_file +'_isOk' })
      ocol_is := obro:oxbp:getColumn(npos_is)

      if ocol_is:getData() = 6001
        if (npos := ascan(pa, recNo)) = 0
           aadd(pa, recNo)
         else
           Aremove(pa, npos )
         endif

         if( len(pa) = 0, ::pb_save_marked:disable(), ::pb_save_marked:enable())
*         ::d_bro:arselect := pa
*         ::d_bro:oxbp:refreshCurrent()
         nOk := 1
      endif
      return nOk    /// .t.

HIDDEN:
  VAR     drgGet, setVyber
  VAR     in_file, pb_mark_doklad, pb_save_marked
ENDCLASS


METHOD FIN_prikuhit_fp_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  ::cfiltr_fp_sel := ''
  ::pa_vazRecs    := {}

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet        := oXbp:cargo
    ::pa_vazRecs    := parent:parent:udcp:pa_vazRecs
    ::cfiltr_fp_sel := parent:parent:udcp:cfiltr_fp_sel
  ENDIF

  if( .not. empty(::cfiltr_fp_sel), parent:set_prg_filter(::cfiltr_fp_sel, 'fakprihd'), nil )

  ::setVyber := 0
  ::in_file  := 'fakprihd'
  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_prikuhit_fp_SEL:getForm()
  LOCAL  oDrg, drgFC
  local  zkratMenU := prikUhHDw->czkratMenU  // mìna úhrady z c_bankUc


  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 120,16.6 DTYPE '10' TITLE 'Seznam závazku ...' ;
                                              GUILOOK 'All:N,Border:Y,ACTION:N'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 120,15.4 FILE 'FAKPRIHD'        ;
    FIELDS 'M->fakprihd_isOk::2.7::2,'                                + ;
           'FIN_prikuhit_fp_BC(0)::2.6::2,'                           + ;
           'FIN_prikuhit_fp_BC(1):H:3::2,'                            + ;
           'FIN_prikuhit_fp_BC(2):P:3::2,'                            + ;
           'dSPLATFAK:datSplatn:10,'                                  + ;
           'nCISFAK:èísloFaktury:10,'                                 + ;
           'cVARSYM:varSymbol,'                                       + ;
           'cNAZEV:názevFirmy:25,'                                    + ;
           'czkratStat:stát,'                                         + ;
           'ncenZahCel:faktura:13:::1,'                               + ;
           'FIN_prikuhit_fp_BC(8):k úhradì:14:::1,'                   + ;
           'czkratMenZ:v:4,'                                          + ;
           'FIN_prikuhit_fp_BC(7):k úhradì v ' +zkratMenU +':14:::1,' + ;
           'M->fakPrihd_dny_poSpl:poSpl:7,'                           + ;
           'cucet:úèet dodav.,'                                       + ;
           'cTextFakt:textFaktury:25'                                   ;
    SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'
  odrg:footer := 'yy'

  DRGSTATIC INTO drgFC FPOS 0.2,0.1 SIZE 119.6,1.2 STYPE 1 RESIZE 'nn'

    DRGPUSHBUTTON INTO drgFC CAPTION '~Kompletní seznam ' POS 75.5,0.2 SIZE 38,1.2 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'              ;
                  ICON1 101 ICON2 201  ATYPE 3

    DRGPUSHBUTTON INTO drgFC POS 113.5,.2 SIZE 3,1.2 ATYPE 1             ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...' ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK

    DRGPUSHBUTTON INTO drgFC POS 116.5,.2 SIZE 3,1.1 ATYPE 1                   ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...' ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS

  DRGEND  INTO drgFC
RETURN drgFC


METHOD FIN_prikuhit_fp_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

**  XbpDialog:titleBar := .F.
  drgDialog:dialog:drawingArea:bitmap  := 1020  // sel_background 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
** NE    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  ENDIF
RETURN


method FIN_prikuhit_fp_SEL:drgDialogStart( drgDialog )
  local  x, members  := drgDialog:oForm:aMembers
  local  d_bro       := drgDialog:dialogCtrl:obrowse[1]
  local  ocol, chead := 'k úhradì v ' +prikUhHDw->czkratMenU


  local  pa_quick   := { ;
  { 'Kompletní seznam                     ', ;
    ''                                                                                                          }, ;
  { 'Neuhrazené závazky                   ', ;
    '(ncenZahCel <> 0 .and. nuhrCelFaz = 0) .or. ((ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0)'        }, ;
  { 'Èásteènì uhrazené závazky            ', ;
    '(ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0'                                                      }, ;
  { 'Závazky bez pøíkazu k úhradì         ', ;
    'ncenzahcel <> 0 .and. npriuhrcel = 0 .and. nuhrcelfaz = 0'                                                 }, ;
  { 'Závazky s èásteèným pøíkazem k úhradì', ;
    '(ncenZahCel >npriUhrCel) .and. (ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0 .and. npriUhrCel <> 0' }  }

  ::quickFiltrs_withCustomizeAof:init( self, pa_quick, 'Závazky', ::pa_vazRecs, 2 )
  ::quickFiltrs_withCustomizeAof:pb_context:oxbp:gradientColors := {0,6}

  ::d_bro := d_bro
  *
  ** musíme pøehodit záhlaví sloupce, uložený BRO by mohl mít jiné
  if ::in_file = 'fakprihd'
    begin sequence
      for x := 1 to d_Bro:oxbp:colCount step 1
        ocol := d_Bro:oxbp:getColumn(x)
        if 'fin_prikuhit_fp_bc(7):k úhradi v ' $ lower(ocol:frmColum)
          ocol:heading:setCell( 1, '', XBPCOL_TYPE_TEXT)
          ocol:heading:setCell( 1, chead, XBPCOL_TYPE_TEXT)
    break
        endif
      next
    end sequence
  endif

  for x := 1 to len(members) step 1
    if  members[x]:ClassName() = 'drgPushButton'
      do case
      case members[x]:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
      case members[x]:event = 'save_marked'    ;  ::pb_save_marked := members[x]
      endcase
    endif
  next

  ::pb_save_marked:disable()
return self


method FIN_prikuhit_fp_SEL:drgDialogEnd()
  (::in_file)->(ads_clearAof())
return


METHOD FIN_prikuhit_fp_SEL:doPrevzit()
  LOCAL  pA := ::drgDialog:dialogCtrl:oaBrowse:arSELECT

  IF( Empty(pA), IF(FIN_prikuhit_fp_ZBY() > 0, AAdd(pA,FAKPRIHD ->(RecNo())), NIL ), NIL )
  ::drgDialog:cargo := pA
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN self