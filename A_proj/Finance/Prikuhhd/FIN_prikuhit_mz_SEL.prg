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
** CLASS for FIN_prikuhit_mz_SEL ***********************************************
FUNCTION FIN_prikuhit_mz_BC(nCOLUMn)
  LOCAL  nCEN    := MZDZAVHD ->nCENZAKCEL, nUHR, nZBY
  LOCAL  xRETval := 0

  DO CASE
  CASE( nCOLUMn = 0)                                       // x - . inkaso
    c_typuhr->( dbSeek( upper( mzdzavhd->czkrTypUhr )))
    xRETval := if( c_typuhr->lIsInkaso, MIS_ICON_ERR, 0)

  CASE( nCOLUMn = 1)                                       // H - h -  uhrazeno
    ncen := mzdzavhd->ncenZahCel
    nuhr := mzdzavhd->nuhrCelFaz
    xRETval := IF(nUHR = 0, 0, IF(nUHR < nCEN, H_low, IF(nUHR = nCEN, H_big, MIS_ICON_ERR)))

  CASE( nCOLUMn = 2 )                                      // P - p -  pøíkazy
    nZBY    := FIN_prikuhit_mz_ZBY()
    nuhr    := mzdzavhd->npriuhrCel
    xRETval := IF(nZBY = 0, P_big, IF(nZBY < nuhr, P_low, 0))

  CASE( nCOLUMn = 7 )                                      // zbývá uhradit v mìnì PØIKAZU
    xRETval := FIN_prikuhit_mz_ZBY()

  CASE( nCOLUMN = 8 )                                      // zbývá uhradit v mìnì FAKTURY
    xRETval := FIN_prikuhit_mz_ZBY_FAK()

  ENDCASE
RETURN xRETval

* 7
function FIN_prikuhit_mz_ZBY_FAK( cfile )
  local  cKy, nkoe, n_cenZahCel, n_uhrCelFaz, n_priUhrCel

  default cfile to 'mzdZavhd'

  cKy := Upper( (cfile)->cDENIK) +StrZero( (cfile)->nCISFAK,10)

  prikUhi_w->( dbseek( cky,, 'PRIKUHIT_2'))
  priUhr     := prikUhi_w->npriUhrCel * if( prikUhi_w->_delrec = '9', +1, 0 )

  n_cenZahCel := (cfile)->ncenZahCel
  n_uhrCelFaz := (cfile)->nuhrCelFaz
  n_priUhrCel := (cfile)->npriUhrCel

  if ( n_priUhrCel - n_uhrCelFaz) <= 0
    return (n_cenZahCel - n_uhrCelFaz) +priUhr
  else
    return ( n_cenZahcel -( n_priUhrCel + n_uhrCelFaz )) +priUhr
  endif
return 0

* 8
FUNCTION FIN_prikuhit_mz_ZBY( cfile )
  LOCAL  nZBY_uhr, nRECs := PRIKUHITw ->( RecNo())
  LOCAL  cKy, isIn := .f.
  *
  local  nkoe, n_cenZahCel, n_uhrCelFaz, n_priUhrCel
  local  ndeciMals
  local  val := 0
  local  istuz_Zuc, istuz_Zal

  static zaklMena
  if( isNull(zaklMena) , zaklMena  := SysConfig('Finance:cZaklMena'), nil )

  default cfile to 'mzdZavhd'

  cKy  := Upper( (cfile)->cDENIK) +StrZero( (cfile)->nCISFAK,10)

  isIn := prikUhi_w->( dbseek( cky,, 'PRIKUHIT_2'))

  istuz_UcPr := Equal( zaklMena, prikuhhdw ->czkratMenU)
  istuz_UcFa := Equal( zaklMena, (cfile)   ->czkratMenZ )
  priUhr     := prikUhi_w->npriUhrCel * if( prikUhi_w->_delrec = '9', +1, 0 )  // -1

  * shodné mìny pøíkazu i faktury pøijaté
  if prikuhhdw->czkratMenU = (cfile)->czkratMenZ
    n_cenZahCel := (cfile)->ncenZahCel
    n_uhrCelFaz := (cfile)->nuhrCelFaz
    n_priUhrCel := (cfile)->npriUhrCel                 // zahranièní - tuzemská ?

  else
    * rùzné mìny poøkazu a faktury pøijaté

    ndeciMals := Set( _SET_DECIMALS, 3 )

    do case
    case istuz_UcPr .and. .not. istuz_UcFa              // pøíkaz v tuzemské mìnì - faktura v zahranièní
      kurzit->( dbseek( upper( (cfile)->czkratMenZ),,'KURZIT9'))

      nkoe        := kurzit->nkurzStred/ kurzit->nmnozPrep
      n_cenZahCel := (cfile) ->ncenZahCel * nkoe
      n_uhrCelFaz := (cfile) ->nuhrCelFaz * nkoe
      n_priUhrCel := (cfile) ->npriUhrCel * nkoe       // zahranièní - tuzemská ?

    case .not. istuz_UcPr .and. istuz_UcFa              // pøíkaz v zahranièní mìnì - faktura v tuzemské
      nkoe        := prikUhHDw->nmnozPrep / prikUhHDw->nkurZahMen
      n_cenZahCel := (cfile) ->ncenZahCel * nkoe
      n_uhrCelFaz := (cfile) ->nuhrCelFaz * nkoe
      n_priUhrCel := (cfile) ->npriUhrCel * nkoe       // zahranièní - tuzemská ?

    case .not. istuz_UcPr .and. .not. istuz_UcFa        // pøíkaz v zahranièní mìnì - faktura zahranièní
      kurzit->( dbseek( upper( (cfile)->czkratMenZ),,'KURZIT9'))

      nkoe        := (kurzit->nkurzStred/ kurzit->nmnozPrep) / (prikUhHDw->nkurZahMen/ prikUhHDw->nmnozPrep)
      n_cenZahCel := (cfile) ->ncenZahCel * nkoe
      n_uhrCelFaz := (cfile) ->nuhrCelFaz * nkoe
      n_priUhrCel := (cfile) ->npriUhrCel * nkoe       // zahranièní - tuzemská ?
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
CLASS FIN_prikuhit_mz_SEL FROM drgUsrClass, quickFiltrs_withCustomizeAof
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart, drgDialogEnd
  *
  var     d_bro, pa_vazRecs, cfiltr_fp_sel

  *
  ** MZDZAVHD stav mzdového závazku lze pøevzít do pøíkazu
  inline access assign method mzdZavhd_isOk() var mzdzavhd_isOk
    local xretVal := 0, it_Ok

    c_typuhr->( dbSeek( upper( mzdzavhd->czkrTypUhr )))
    firmyUc ->( dbseek( upper(mzdzavhd->cucet),, 'FIRMYUC2'))

    it_Ok := ( FIN_prikuhit_mz_ZBY() > 0 .and. .not. c_typuhr->lIsInkaso )

    * odvod na pracovníka, mzda, srážka, ... nemusí být založen ve firmyUC
    if mzdZavhd->noscisPrac <> 0
      return if( it_Ok, 6001, MIS_NO_RUN )

    * odvod sociální, zdravotní, ... za firmu, musí být úèet ve fitmyUC
    else
      return if(( it_Ok .and. upper(firmyUc->cBANK_sta) = upper(mzdZavHD->czkratStat)), 6001, MIS_NO_RUN )

    endif
    return 0


  inline access assign method mzdZavhd_dny_poSpl() var mzdZavhd_dny_poSpl
//    local posUhr    := if( empty(mzdZavhd->dposUhrFak), date(), mzdZavhd->dposUhrFak )
    local posUhr    := Date()
    local splFak    := mzdZavhd->dsplatFak
    local dny_poSpl := 0

    dny_poSpl := if(empty(posUhr) .or. isNull( mzdZavhd->sID, 0) = 0, 0, posUhr -splFak)
    return dny_poSpl // max(0, dny_poSpl)


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl
    *
    local  cInfo     := 'Promiòte prosím,' +CRLF

    if ::d_bro:is_selAllRec <> ::is_selAllRec
      ::sumColumn()
      ::is_selAllRec := ::d_bro:is_selAllRec
    endif

    if .not. empty(::ao_sumCol[1]:Footing:getCell(1))
      ::pb_save_marked:enable()
    else
      ::pb_save_marked:disable()
    endif


    DO CASE
     * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
      ::cobdobi_Smz := uctOBDOBI:MZD:cOBDOBI
      return .t.

    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      if FIN_prikuhit_mz_BC(0) = 0
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

      else
        cInfo += 'fakura pøijatá ( ' +allTrim( str( mzdzavhd->ncisFak)) +' )' +CRLF       + ;
                 'je hrazena inkasním poøíkazem ...'                          +CRLF +CRLF + ;
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
      return self

    inline method save_marked()
      local pa := {}

      if ::d_bro:is_selAllRec
        mzdZav_S->( ads_setAof('.T.'))
        mzdZav_S->( ads_customizeAOF(::d_Bro:arselect,2), ;
                    dbeval( { || aadd( pa, mzdZav_S->( recNo()) ) } ))

        ::d_bro:arselect := pa

        mzdZav_S->(ads_clearAof())
      endif

      postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
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

*         if( len(pa) = 0, ::pb_save_marked:disable(), ::pb_save_marked:enable())
         ::d_bro:arselect := pa
         ::d_bro:oxbp:refreshCurrent()
         nOk := 1

         ::sumColumn()
      endif
      return 0

  inline method mzdZav_S_ok_Rec()
    local xretVal := 0, it_Ok, rec_Ok

    c_typuhr->( dbSeek( upper( mzdZav_S->czkrTypUhr )))
    firmyUc ->( dbseek( upper( mzdZav_S->cucet),, 'FIRMYUC2'))

    it_Ok := ( FIN_prikuhit_mz_ZBY('mzdZav_S') > 0 .and. ;
               .not. c_typuhr->lIsInkaso           .and. ;
               mzdZavhd->( dbseek( isNull( mzdZav_s->sID, 0),,'ID')) )

    * odvod na pracovníka, mzda, srážka, ... nemusí být založen ve firmyUC
    if mzdZav_S->noscisPrac <> 0
      rec_Ok := it_Ok

    * odvod sociální, zdravotní, ... za firmu, musí být úèet ve fitmyUC
    else
      rec_Ok := ( it_Ok .and. upper(firmyUc->cBANK_sta) = upper(mzdZav_S->czkratStat) )
    endif

    if( rec_Ok, nil, aadd( ::pa_noOk_Recs, mzdZav_S->( recNo()) ))
    return rec_Ok

HIDDEN:
  VAR     drgGet, setVyber, cobdobi_Smz
  VAR     in_file, pb_mark_doklad, pb_save_marked
  *
  var     is_selAllRec, ao_sumCol, pa_noOk_Recs

  inline method sumColumn()
    local  sum_zahCel := sum_mz_BC8 := sum_mz_BC7 := 0
    local  x, ocol
    local  nsum, recNo := mzdZavhd->( recNo())

    ::pa_noOk_Recs := {}

    if ::d_bro:is_selAllRec
      mzdZav_S->(ads_setAof('.T.'))
      mzdZav_S->(ads_customizeAOF(::d_Bro:arselect,2), dbgotop())
    else
      mzdZav_S->(ads_setAof('.F.'))
      mzdZav_S->(ads_customizeAOF(::d_Bro:arselect), dbgotop())
    endif

    mzdZav_S->( dbeval( { || ( sum_zahCel += mzdZav_S->ncenZahCel               , ;
                               sum_mz_BC8 += FIN_prikuhit_mz_ZBY('mzdZav_S')    , ;
                               sum_mz_BC7 += FIN_prikuhit_mz_ZBY_FAK('mzdZav_S')  ) }, ;
                         { || ::mzdZav_S_ok_Rec()  }                                   ))

    for x := 1 to len(::ao_sumCol) step 1
      if isObject(ocol := ::ao_sumCol[x])
        nsum := if( ocol:defColum[2] = 'FIN_prikuhit_mz_BC(8)', sum_mz_BC8, ;
                 if( ocol:defColum[2] = 'FIN_prikuhit_mz_BC(7)', sum_mz_BC7, sum_zahCel ))

        ocol:Footing:hide()
        ocol:Footing:setCell(1, nsum)
        ocol:Footing:show()
      endif
    next

    mzdZav_S->(ads_clearAof())
    mzdZavHd->( dbgoTo( recNo))

    if ::d_bro:is_selAllRec .and. len(::pa_noOk_Recs) <> 0
      pa := ::d_bro:arselect
      aeval( ::pa_noOk_Recs, { |nrec| aadd( pa, nrec ) })

      ::d_bro:arselect := pa
      ::d_bro:oxbp:refreshAll()
    endif
  return
ENDCLASS


METHOD FIN_prikuhit_mz_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  ::cfiltr_fp_sel := ''
  ::pa_vazRecs    := {}
  ::ao_sumCol     := {}
  ::cobdobi_Smz   := prikUhHDw->cobdobi  // uctOBDOBI:MZD:cOBDOBI

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet        := oXbp:cargo
    ::pa_vazRecs    := parent:parent:udcp:pa_vazRecs
    ::cfiltr_fp_sel := parent:parent:udcp:cfiltr_fp_sel
  ENDIF

  if( .not. empty(::cfiltr_fp_sel), parent:set_prg_filter(::cfiltr_fp_sel, 'mzdzavhd'), nil )

  ::setVyber := 0
  ::in_file  := 'mzdzavhd'

  * druhý mzdZavHD pro sumColumn
  drgDBMS:open( 'mzdZavHD',,,,,'mzdZav_S')

  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_prikuhit_mz_SEL:getForm()
  LOCAL  oDrg, drgFC
  local  zkratMenU := prikUhHDw->czkratMenU  // mìna úhrady z c_bankUc

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 120,16.6 DTYPE '10' TITLE 'Seznam mzdových závazkù ...' ;
                                              GUILOOK 'All:N,Border:Y,ACTION:N'


  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 120,15.4 FILE 'MZDZAVHD'        ;
    FIELDS 'M->mzdZavhd_isOk::2.7::2,'                                + ;
           'FIN_prikuhit_mz_BC(0)::2.6::2,'                           + ;
           'FIN_prikuhit_mz_BC(1):H:3::2,'                            + ;
           'FIN_prikuhit_mz_BC(2):P:3::2,'                            + ;
           'dSPLATFAK:datSplatn:10,'                                  + ;
           'cobdobi:období,'                                          + ;
           'nCISFAK:èísloDokladu:10,'                                 + ;
           'cVARSYM:varSymbol,'                                       + ;
           'cNAZEV:názevFirmy:25,'                                    + ;
           'czkratStat:stát,'                                         + ;
           'ncenZahCel:doklad:13:::1,'                                + ;
           'FIN_prikuhit_mz_BC(8):k úhradì:14:::1,'                   + ;
           'czkratMenZ:v:4,'                                          + ;
           'FIN_prikuhit_mz_BC(7):k úhradì v ' +zkratMenU +':14:::1,' + ;
           'nuhrCelFaZ:uhrazeno,'                                     + ;
           'M->mzdZavhd_dny_poSpl:poSpl:7'                              ;
    SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'
  odrg:footer := 'y'


  DRGSTATIC INTO drgFC FPOS .2,.02 SIZE 120,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yn'

    DRGPUSHBUTTON INTO drgFC CAPTION '~Kompletní seznam ' POS 56,.2 SIZE 36,1.2 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'            ;
                  ICON1 101 ICON2 201  ATYPE 3

    DRGPUSHBUTTON INTO drgFC POS 113.5,.2 SIZE 3,1.2 ATYPE 1             ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...' ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK

    DRGPUSHBUTTON INTO drgFC POS 116.5,.2 SIZE 3,1.2 ATYPE 1                   ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...' ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS
  DRGEND  INTO drgFC

RETURN drgFC


METHOD FIN_prikuhit_mz_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

**  XbpDialog:titleBar := .F.
  drgDialog:dialog:drawingArea:bitmap  := 1016 // 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
** NE    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  ENDIF
RETURN


method FIN_prikuhit_mz_SEL:drgDialogStart( drgDialog )
  local  x, members  := drgDialog:oForm:aMembers
  local  d_bro       := drgDialog:dialogCtrl:obrowse[1]
  local  ocol, chead := 'k úhradì v ' +prikUhHDw->czkratMenU
  *
  local  cm_Filter   := "(ncenZahCel >npriUhrCel) .and. (ncenZahCel - nuhrCelFaz) <> 0"
  local  ctx_KObdobi := 'K obdobi [' +::cobdobi_Smz +']'
  local  cft_Kobdobi := format( "cobdobi = '%%'", {::cobdobi_Smz} )

  local  pa_quick   := { ;
  { 'Kompletní seznam                     '                   , ;
    ''                                                                    }, ;
  { ctx_kObdobi +' pro pøevzetí do pøíkazu'                   , ;
    cft_Kobdobi +" .and. " +cm_Filter                                     }, ;
  { ctx_kObdobi +' hromadné platby pro pøevzetí do pøíkazu'   , ;
    cft_Kobdobi +" .and. " +cm_Filter +" .and. ctypPohybu <> 'GENSRAZKA'" }, ;
  { ctx_kObdobi +' srážky zamìstnancù pro pøevzetí do pøíkazu', ;
    cft_Kobdobi +" .and. " +cm_Filter +" .and. ctypPohybu =  'GENSRAZKA'" }, ;
  { 'Neuhrazené závazky                   '                   , ;
    '(ncenZahCel <> 0 .and. nuhrCelFaz = 0) .or. ((ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0)'        }, ;
  { 'Èásteènì uhrazené závazky            '                   , ;
    '(ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0'                                                      }, ;
  { 'Závazky pro pøevzetí do pøíkazu'                         , ;
    '(ncenZahCel >npriUhrCel) .and. (ncenZahCel - nuhrCelFaz) <> 0'                                             }  }

/*
  { 'Závazky bez pøíkazu k úhradì         ', ;
    'ncenzahcel <> 0 .and. npriuhrcel = 0 .and. nuhrcelfaz = 0'                                                 }, ;
  { 'Závazky s èásteèným pøíkazem k úhradì', ;
    '(ncenZahCel >npriUhrCel) .and. (ncenZahCel - nuhrCelFaz) <> 0 .and. nuhrCelFaz <> 0 .and. npriUhrCel <> 0' }  }
*/

//  pa_tagKey := drgScrPos:getPos_forSel('FIN_prikuhit_mz_SEL', drgDialog, 'mzdZavHD' )


  ::quickFiltrs_withCustomizeAof:init( self, pa_quick, 'Závazky', ::pa_vazRecs, 2 )
  ::quickFiltrs_withCustomizeAof:pb_context:oxbp:gradientColors := {0,6}

  ::d_bro        := d_bro
  ::is_selAllRec := ::d_bro:is_selAllRec
  *
  ** musíme pøehodit záhlaví sloupce, uložený BRO by mohl mít jiné
  if ::in_file = 'mzdzavhd'
    for x := 1 to d_Bro:oxbp:colCount step 1
      ocol := d_Bro:oxbp:getColumn(x)

      if( ocol:sumColum = 1, aadd( ::ao_sumCol, ocol), nil )

      if 'fin_prikuhit_mz_bc(7):k úhradì v ' $ lower(ocol:frmColum)
        ocol:heading:setCell( 1, '', XBPCOL_TYPE_TEXT)
        ocol:heading:setCell( 1, chead, XBPCOL_TYPE_TEXT)
      endif
    next
  endif

  for x := 1 to len(members) step 1
    if  members[x]:ClassName() = 'drgPushButton'
      do case
      case members[x]:event = 'createContext'
        members[x]:oxbp:setSize( { 400,25} )
        members[x]:oxbp:configure()

      case members[x]:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
      case members[x]:event = 'save_marked'    ;  ::pb_save_marked := members[x]
      endcase
    endif
  next

  ::pb_save_marked:disable()
return self


method FIN_prikuhit_mz_SEL:drgDialogEnd()
  (::in_file)->(ads_clearAof())
return