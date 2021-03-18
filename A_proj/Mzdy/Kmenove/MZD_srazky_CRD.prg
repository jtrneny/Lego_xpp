 //////////////////////////////////////////////////////////////////////
//
//  MZD_kmenove_CRD.PRG
//
//////////////////////////////////////////////////////////////////////
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
// #include "asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
*****************************************************************
CLASS MZD_kmenove_CRD FROM drgUsrClass
EXPORTED:
  INLINE ACCESS ASSIGN METHOD cnazgendmz1()  VAR cNazGenDMZ1
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy)),DRUHYMZD->cNazevDMZ, '')
  *
  INLINE ACCESS ASSIGN METHOD cnazgendmz2()  VAR cNazGenDMZ2
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy2)),DRUHYMZD->cNazevDMZ, '')
  *
  INLINE ACCESS ASSIGN METHOD cnazgendmz3()  VAR cNazGenDMZ3
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy3)),DRUHYMZD->cNazevDMZ, '')
  *
  INLINE ACCESS ASSIGN METHOD cstatnaroz()   VAR cSTATnaroz
    RETURN IF(C_STATY->( DbSeek(Upper(PERSONALw->cZkrStatNa))), C_STATY->cNAZEVstat, '')
  *
  INLINE ACCESS ASSIGN METHOD cpscbydl()     VAR cPSCbydl
    RETURN IF(C_PSC->( DbSeek(Upper(PERSONALw->cPSC))), C_PSC->cMISTO, '')
  *
  INLINE ACCESS ASSIGN METHOD cstatbydl()    VAR cSTATbydl
    RETURN IF(C_STATY->( DbSeek(Upper(PERSONALw->cZkratStat))), C_STATY->cNAZEVstat, '')
  *
  INLINE ACCESS ASSIGN METHOD cpscbydlpre()  VAR cPSCbydlPRE
    RETURN IF(C_PSC->( DbSeek(Upper(PERSONALw->cPrePSC))), C_PSC->cMISTO, '')
  *
  INLINE ACCESS ASSIGN METHOD cstatbydlpre() VAR cSTATbydlPRE
    RETURN IF(C_STATY->( DbSeek(Upper(PERSONALw->cZkrStatPr))), C_STATY->cNAZEVstat, '')

  method  init
  method  drgDialogStart
  method  postValidate
  method  postLastField
  method  destroy
  method  onSave
  method  ebro_saveEditRow
  method  ebro_beforeAppend

  method  MZD_kmenove_SEL
  method  MZD_mimoprvz_CRD
  method  MZD_duchody_CRD
  method  MZD_odpocpol_CRD


  INLINE METHOD eventHandled(nEvent,mp1,mp2,oXbp)
    LOCAL tabNum

    DO CASE
     CASE(nEvent = xbeP_SetInputFocus .and. oXbp:ClassName() = 'XbpTabPage')
       ::nextFocus( Val(SubStr(oXbp:caption,2,1)))
       RETURN .F.

     CASE nEvent = drgEVENT_SAVE
*       MZD_kmenove_wrt(self)
       MZD_kmenove_wrt(self)
       PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
       RETURN .T.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

  VAR   lNEWrec

HIDDEN:
  method  copyNewPV

  VAR   onTabSelect
  VAR   msg, dm, dc, df, ab

  VAR   oBROw, inEdit, aEdits

  INLINE METHOD nextFocus(tabNum)
    LOCAL tabPos   := ::onTABselect[tabNum,1]
    LOCAL aMembers := ::drgDialog:oForm:aMembers
    *
    LOCAL x, name := ''

    BEGIN SEQUENCE
      FOR x := tabPos +1 TO LEN(aMembers)
        IF IsMemberVar( aMembers[x], 'isEdit')
          IF aMembers[x]:isEdit
            name := aMembers[x]:name
    BREAK
          ENDIF
        ENDIF
      NEXT
    END SEQUENCE

    if( ::lNEWrec .and. name = 'MSPRC_MOW->CDRUPRAVZT', name := 'MSPRC_MOW->NOSCISPRAC', nil)
    IF( .not. Empty(name), ::df:setNextFocus(name,,.T.), NIL )

  RETURN

ENDCLASS

*
** init
METHOD MZD_kmenove_CRD:init(parent)
  LOCAL  cKy  := MSPRC_MO ->(sx_KeyData(1))
  *
  ::drgUsrClass:init(parent)
  *
  ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)
  ::onTabselect := {}

  drgDBMS:open('msprc_md')
  drgDBMS:open('msprc_mo',,,,,'msprc_moc')
  drgDBMS:open('personal',,,,,'personalc')

  drgDBMS:open('msmzdyna')


  * TMP soubory *
  drgDBMS:open('MSPRC_MOw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MSPRC_MDw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MSSRZ_MOw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PERSONALw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MSMZDYw'    ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF ::lNEWrec
    msprc_mow ->(DbAppend())
    msprc_mow ->nrok    := uctOBDOBI:MZD:NROK
    msprc_mow ->nobdobi := uctOBDOBI:MZD:NOBDOBI
    msprc_mow ->cobdobi := StrZero( uctOBDOBI:MZD:NROK, 4) +StrZero( uctOBDOBI:MZD:NOBDOBI, 2)
  ELSE                                                                          // oprava
    mh_COPYFLD('MSPRC_MO', 'MSPRC_MOw', .T.)
    mh_COPYFLD('PERSONAL', 'PERSONALw', .T.)
    MSSRZ_MO->( DbSetScope(SCOPE_BOTH, cKy)                        , ;
                  DBEval( { || mh_COPYFLD('MSSRZ_MO', 'MSSRZ_MOw', .T.) } ) )
  ENDIF

  *  1_mimopracovní vztahy
  ** MIMOPRVZ->nMIMOPRVZT(db) ->MZD_mimopr_CRD(fm) ->MZD_mimopr_CRD(pr) *
  cKy := Upper(MSPRC_MOw->cRodCisPra)
  CopyDBWithScope(1,cKy,'MIMPRVZ','MIMPRVZw')

  *  1_dùchody
  ** DUCHODY->nTYPDUCHOD(db) ->MZD_duchody_CRD(fm) ->MZD_duchody_CRD(pr) *
  CopyDBWithScope(1,cKy,'DUCHODY','DUCHODYw')

  *  1_odpoèitatelné položky
  ** MSODPPOL->nODPODOBD(db) ->MZD_odpocpol_CRD(fm) ->MZD_odpocpol_CRD(pr)
  _cpyMSODPPOL()

  *  2_tarifní sazby
  ** MSTARIND/MSTARZAM (eB)
  _cpyMSTAR_SAZ()
RETURN self


METHOD MZD_kmenove_CRD:drgDialogStart(drgDialog)
  LOCAL  x, nIn, cfield
  LOCAL  aMembers := drgDialog:oForm:aMembers, oColumn

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

  ::inEdit := .F.
  ::aEdits := {}

  FOR x := 1 TO LEN(aMembers)
    IF     aMembers[x]:ClassName() = 'drgBrowse'
      IF aMembers[x]:cFile = "MSTARINDw"
        ::oBROw := aMembers[x]:oXbp
      ENDIF
    ELSEIF aMembers[x]:ClassName() = 'drgGet'
      IF !Empty(aMembers[x]:Groups)
        AAdd(::aEdits, { NIL, aMembers[x], Val(aMembers[x]:groups), NIL })
      ENDIF
    ELSEIF aMembers[x]:ClassName() = 'drgPushButton'
      BEGIN SEQUENCE
      FOR nIn := 1 TO LEN(::aEdits)
        IF aMembers[x]:drgGet = ::aEdits[nIn][2]
          ::aEdits[nIn][4] := aMembers[x]
      BREAK
        ENDIF
      NEXT
      END SEQUENCE
**      aMembers[x]:oXbp:hide()
    ELSEIF aMembers[x]:ClassName() = 'drgTabPage'
      AAdd(::onTABselect, {x,aMembers[x]})
    ENDIF
  NEXT

  ::nextFocus(1)
RETURN self


method MZD_kmenove_CRD:ebro_beforeAppend()

  do case
  case Lower(::dc:oaBrowse:cfile) == 'mstarindw'
    mstarindw->noscisprac := msprc_mow->noscisprac
    mstarindw->nporpravzt := msprc_mow->nporpravzt
    mstarindw->cmzdkatpra := msprc_mow->cmzdkatpra
  case Lower(::dc:oaBrowse:cfile) == 'mssazzamw'
    mssazzamw->noscisprac := msprc_mow->noscisprac
    mssazzamw->nporpravzt := msprc_mow->nporpravzt
    mssazzamw->cmzdkatpra := msprc_mow->cmzdkatpra
  endcase

return .t.


method MZD_kmenove_CRD:ebro_saveEditRow()

return .t.


*
*****************************************************************
METHOD MZD_kmenove_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  *
  LOCAL  lOK  := .T., pa, xval
  LOCAL  cky


  DO CASE
  CASE(name = 'msprc_mow->noscisprac')
    if Empty(value)
      ::msg:writeMessage('OSOBNÍ ÈÍSLO pracovníka je povinný údaj ...',DRG_MSG_WARNING)
      lOk := .F.
    else
      if ::lNEWrec .and. changed .and. value <> msprc_mow->noscisprac
        cky :=  StrZero( uctOBDOBI:MZD:NROK, 4) +StrZero( uctOBDOBI:MZD:NOBDOBI, 2) ;
                 +strzero(value,5)
        if msprc_moc->( dbseek( cky,,'MSPRMO01',.t.))
          ::copyNewPV( msprc_moc->(recno()))
        else
          msprc_mow->nporpravzt := 1
          ::drgDialog:dataManager:set('msprc_mow->nporpravzt', msprc_mow->nporpravzt)
        endi
      endif
    endif

  CASE(name = 'msprc_mow->cpracovnik')
    pa := ListAsArray(value, ' ')
    IF .not. Empty(value) .and. Len(pa) >= 2
      MSPRC_MOw->cTITULPRAC := IF( Len(pa) = 3, pa[1], '' )
      MSPRC_MOw->cPRIJPRAC  := pa[2]
      MSPRC_MOw->cJMENOPRAC := pa[3]
    ELSE
      ::msg:writeMessage('JMÉNO pracovníka je povinný údaj ...',DRG_MSG_WARNING)
      lOk := .F.
    ENDIF

  CASE(name = 'msprc_mow->crodcispra'.and. changed)
    MSPRC_MOw->cRODCISPRN := StrTran( StrTran(value, '-', ''), '/', '')
    if .not. Empty(MSPRC_MOw->cRODCISPRN)
      if MSPRC_MOc ->(DbSeek(Upper(value),,'MSPRMO03')) .or. PERSONALc ->(DbSeek(Upper(value),,'PERSO_03'))
        ::msg:writeMessage('Nalezeno duplicitní RÈ v martièních souborech pracovníkù ...',DRG_MSG_WARNING)
        lOk := .F.
      else
        MSPRC_MOw->nRODCISPRA := Val(MSPRC_MOw->cRODCISPRN)
        MSPRC_MOw->nMUZ       := IF( SubStr(MSPRC_MOw->cRODCISPRA, 4, 1) < '2', 1, 0)
        MSPRC_MOw->nZENA      := IF( SubStr(MSPRC_MOw->cRODCISPRA, 4, 1) > '1', 1, 0)
        if Empty( personalw->dDatNaroz)
          if SubStr( msprc_mow->cRodCisPra, 4, 1)  == "5"                     ;
            .or. SubStr( msprc_mow->cRodCisPra, 4, 1) == "6"
            personalw->dDatNaroz := CtoD( SubStr( msprc_mow->cRodCisPra, 7,2) +"/" ;
                                     +if( SubStr( msprc_mow->cRodCisPra, 4, 1) == "5", "0", "1")    ;
                                       +SubStr( msprc_mow->cRodCisPra, 5, 1) +"/"                    ;
                                         +SubStr( msprc_mow->cRodCisPra, 1, 2))
          else
            personalw->dDatNaroz := CtoD( SubStr( msprc_mow->cRodCisPra, 7,2) +"/" ;
                                     +SubStr( msprc_mow->cRodCisPra, 4,2) +"/"     ;
                                       +SubStr( msprc_mow->cRodCisPra, 1,2))
          endif
          ::dm:set('personalw->dDatNaroz', personalw->dDatNaroz)
        endif
      endif
    else
      ::msg:writeMessage( 'Pokud nebude RÈ zadáno nebude pracovník založen do personalistiky ...',DRG_MSG_WARNING)
    endif

  CASE(name = 'msprc_mow->ddatnast')
    if Empty(value)
      ::msg:writeMessage('"Datum nástupu je povinný údaj ...',DRG_MSG_WARNING)
      lOk := .F.
    else
      if Empty( ::drgDialog:dataManager:get('msprc_mow->ddatvznprv'))
        ::drgDialog:dataManager:set('msprc_mow->ddatvznprv', value)
      endif
    endif

  CASE(name = 'msprc_mow->ntyppravzt')
    if Empty(value)
      ::msg:writeMessage('"Typ pracovního vztahu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      MSPRC_MOw->nCLENSPOL  := IF( value $ {2,3,4}, 1, 0)
    endif


  CASE(name = 'msprc_mow->ddatvyst')
    MSPRC_MOw->nTMDATVYST := IF( Empty(value), 99999999, (Year(value) *10000) +(Month(value) *100) +Day(value))

  CASE(name = 'msprc_mow->ntypzamvzt')
    if Empty(value)
      ::msg:writeMessage('"Typ zamìstnaneckého vztahu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif
  ENDCASE

  ** ukládáme pøi zmìnì do tmp **
  IF( changed, (::dm:save(), ::dm:refresh(.T.)), NIL )
RETURN lOk


*
*****************************************************************
METHOD MZD_kmenove_CRD:onSave(lIsCheck,lIsAppend)
RETURN .F.


*
*****************************************************************
METHOD MZD_kmenove_CRD:destroy()
//  W_PODRUC ->(DbClearRelation())
RETURN SELF


METHOD MZD_kmenove_CRD:MZD_kmenove_SEL()
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)
  local  changed

  DRGDIALOG FORM 'MZD_kmenove_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if( nexit <> drgEVENT_QUIT, ::copyNewPV( msprc_mob->(recno())), nil)

RETURN self


method MZD_kmenove_CRD:copyNewPV( rec)
  local vars := ::drgDialog:datamanager:vars:values
  local dm   := ::drgDialog:dataManager
  local n, cky
  local nn := 3
  local newPVcpy := { 'noscisprac', 'cpracovnik', 'crodcispra', ;
                      'cnazpol1',   'ckmenstrpr', ;
                      'cdrupravzt', ;
                      'ntyppravzt', 'cvznpravzt', ;
                      'ntypzamvzt', 'ntypduchod', ;
                      'cmzdkatpra', 'cpraczar',   ;
                      'cfunpra',    'cnazpol4',   ;
                      'cvyplmist',  'nzdrpojis',  ;
                      'nzdrpojdop', 'ldanprohl',  ;
                      'lvypcismzd', 'lautosz400', ;
                      'lautovypcm', 'lzaokrna10', ;
                      'lautovyphm', 'lodborar',   ;
                      'lautovyppr', 'lstatuzast', ;
                      'ltiskmzdli', 'limportdoc', ;
                      'lgenereldp', 'lexport',    ;
                      'ltiskkontr', 'lvyradano'}

  if drgIsYESNO(drgNLS:msg('Pøevzít data z pøedchozího PV ?'))
    nn := len(newPVcpy)
  endif

  msprc_moc->( dbGoto(rec))
  msprc_mow->noscisprac := msprc_moc->noscisprac
*  aEval( newPVcpy,|X| dm:set('msprc_mow->'+X, DBGetVal('msprc_moc->'+ X)),,nn )

  for n := 1 to nn
    dm:set('msprc_mow->'+newPVcpy[n],DBGetVal('msprc_moc->'+newPVcpy[n]))   //DBGetVal(iz_file +"->" +pa[x,iz_pos])
  next

  cky :=  strzero(msprc_mow->nrok,4) +strzero(msprc_mow->nobdobi,2)   ;
           +strzero(msprc_mow->noscisprac,5)
  msprc_moc->( dbseek( cky,,'MSPRMO01',.t.))
  msprc_mow->nporpravzt := msprc_moc->nporpravzt +1
  dm:set('msprc_mow->nporpravzt', msprc_mow->nporpravzt )
  dm:save(.T.)
  dm:refresh(.T.)

  cky += Strzero( msprc_moc->nporpravzt, 3)
  MSSRZ_MO ->( DbSetScope(SCOPE_BOTH, cKy)                        , ;
                DBEval( { || mh_COPYFLD('MSSRZ_MO', 'MSSRZ_MOw', .T.) } ) )

  cky := Upper(MSPRC_MOw->cRodCisPra)
  personalc->( dbseek( cky,,'PERSO_03'))
  mh_COPYFLD('personalc', 'personalw', .T.)

  *  1_mimopracovní vztahy
  ** MIMOPRVZ->nMIMOPRVZT(db) ->MZD_mimopr_CRD(fm) ->MZD_mimopr_CRD(pr) *
  CopyDBWithScope(1,cKy,'MIMPRVZ','MIMPRVZw')

  *  1_dùchody
  ** DUCHODY->nTYPDUCHOD(db) ->MZD_duchody_CRD(fm) ->MZD_duchody_CRD(pr) *
  CopyDBWithScope(1,cKy,'DUCHODY','DUCHODYw')

  *  1_odpoèitatelné položky
  ** MSODPPOL->nODPODOBD(db) ->MZD_odpocpol_CRD(fm) ->MZD_odpocpol_CRD(pr)
  _cpyMSODPPOL()

  *  2_tarifní sazby
  ** MSTARIND/MSTARZAM (eB)
  _cpyMSTAR_SAZ()

  personalc->( dbCloseArea())

  ::df:setNextFocus( 'MSPRC_MOW->CDRUPRAVZT',,.T.)
return .t.



METHOD MZD_kmenove_CRD:MZD_mimoprvz_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()

                 // Save work area
  DRGDIALOG FORM 'MZD_mimoprvz_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
//  ::drgDialog:dataManager:has('msprc_mow->nodpocobd'):refresh()
//  ::drgDialog:dataManager:has('msprc_mow->nodpocrok'):refresh()
//  ::drgDialog:dataManager:has('msprc_mow->ndanulobd'):refresh()
//  ::drgDialog:dataManager:has('msprc_mow->ndanulrok'):refresh()

RETURN self

METHOD MZD_kmenove_CRD:MZD_duchody_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()

                 // Save work area
  DRGDIALOG FORM 'MZD_duchody_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
//  ::drgDialog:dataManager:has('msprc_mow->nodpocobd'):refresh()
//  ::drgDialog:dataManager:has('msprc_mow->nodpocrok'):refresh()
//  ::drgDialog:dataManager:has('msprc_mow->ndanulobd'):refresh()
//  ::drgDialog:dataManager:has('msprc_mow->ndanulrok'):refresh()

RETURN self



METHOD MZD_kmenove_CRD:MZD_odpocpol_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()

                 // Save work area
  DRGDIALOG FORM 'MZD_odpocpol_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
  ::drgDialog:dataManager:has('msprc_mow->nodpocobd'):refresh()
  ::drgDialog:dataManager:has('msprc_mow->nodpocrok'):refresh()
  ::drgDialog:dataManager:has('msprc_mow->ndanulobd'):refresh()
  ::drgDialog:dataManager:has('msprc_mow->ndanulrok'):refresh()
RETURN self



METHOD MZD_kmenove_CRD:postLastField(drgVar)
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  name   := drgVAR:name
  LOCAL  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme VYKDPH_P na každém PRVKU //
  IF lZMENa
    ::dataManager:save()
    ::oBROw:refreshCurrent()
  ENDIF
RETURN .T.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
STATIC FUNCTION _cpyMSODPPOL()
  local  nCelkOdOBD := nCelkOdROK := nCelkUlOBD := nCelkUlROK := 0
  local  cKy := StrZero(MSPRC_MOw->nOsCisPrac,5) +StrZero(uctOBDOBI:MZD:nROK,4) +StrZero(MSPRC_MOw->nPorPraVzt)
  local  newcpypv := {}
  *
  drgDBMS:open('C_ODPOC')
  drgDBMS:open('MSODPPOL')
  drgDBMS:open('RODPRISL')
  *
  drgDBMS:open('C_ODPOCw',.T.,.T.,drgINI:dir_USERfitm);  ZAP
  drgDBMS:open('MSODPPOLw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  MSODPPOL->( AdsSetOrder( 1),DbSetScope(SCOPE_BOTH,cKy),dbGoTop())

  DO WHILE .not. MSODPPOL->( Eof())
    mh_COPYFLD( 'MSODPPOL', 'MSODPPOLw', .T.)
    IF( Year(MSODPPOLw->dPlatnDo)*100 +Month(MSODPPOLw->dPlatnDo)) >= (uctOBDOBI:MZD:nROK*100 +uctOBDOBI:MZD:nOBDOBI) ;
       .OR. Empty(MSODPPOLw->dPlatnDo)
      MSODPPOLw->lAktiv := .T.
      IF MSODPPOLw->lOdpocet
        nCelkOdOBD += MSODPPOLw->nOdpocOBD
        nCelkOdROK += MSODPPOLw->nOdpocROK
      ELSE
        nCelkUlOBD += MSODPPOLw->nDanUlOBD
        nCelkUlROK += MSODPPOLw->nDanUlROK
      ENDIF
    ENDIF
    MSODPPOL->( dbSkip())
  ENDDO

  * odpoèet na dìti *
  cKy := Upper(MSPRC_MOw->cRodCisPra)
  RODPRISL ->( AdsSetOrder(1),DbSetScope(SCOPE_BOTH,cKy),dbGoTop())
  C_ODPOC  ->( AdsSetOrder(3),DbSetScope(SCOPE_BOTH, StrZero(uctOBDOBI:MZD:nROK,4)),dbGoTop())
  MSODPPOLw->( AdsSetOrder( 2))

  DO WHILE .not. C_ODPOC->( Eof())
    lDOPLN  := .F.
    lGENrec := .T.
    *
    DO CASE
    CASE C_ODPOC->cTypOdpPol = "DITE"
      DO WHILE .not. RODPRISL->( Eof())
        IF RODPRISL->cTypRodPri = "DITE" .AND. ;
           .not. MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol) +UPPER(RODPRISL ->cRodCisRP) +"1"))
          mh_COPYFLD( 'C_ODPOC', 'C_ODPOCw', .T.)

          C_ODPOCw ->cNazOdpPol := RODPRISL->cRodPrisl
          C_ODPOCw ->cRodCisRP  := RODPRISL->cRodCisRP
          C_ODPOCw ->nRodPrisl  := RODPRISL->nRodPrisl
          C_ODPOCw->nOsCisPrac  := MSPRC_MOw->nOsCisPrac
          C_ODPOCw->cKmenStrPr  := MSPRC_MOw->cKmenStrPr
          C_ODPOCw->cPracovnik  := MSPRC_MOw->cPracovnik
          C_ODPOCw->nPorPraVzt  := MSPRC_MOw->nPorPraVzt
          C_ODPOCw->dPlatnOd    := cTOd( "01/" +Str( uctOBDOBI:MZD:nOBDOBI) +"/" +Str( uctOBDOBI:MZD:nROK))
          C_ODPOCw->cObdOd      := uctOBDOBI:MZD:cOBDOBI
          C_ODPOCw->cObdDo      := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)
        ENDIF
        RODPRISL->( dbSkip())
      ENDDO

    CASE C_ODPOC->cTypOdpPol = "ZAKL"
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->lDanProhl)
    CASE C_ODPOC->cTypOdpPol = "INVC"
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->nTypDuchod == 7)
    CASE C_ODPOC->cTypOdpPol = "INVP"
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->nTypDuchod == 5)
    CASE C_ODPOC->cTypOdpPol = "INVZ"
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->nTypDuchod == 6)
    ENDCASE

    IF lGENrec
      mh_COPYFLD( 'C_ODPOC', 'C_ODPOCw', .T.)

      C_ODPOCw->nOsCisPrac := MSPRC_MOw ->nOsCisPrac
      C_ODPOCw->cKmenStrPr := MSPRC_MOw ->cKmenStrPr
      C_ODPOCw->cPracovnik := Left( MSPRC_MOw ->cPracovnik, 25) +StrZero( MSPRC_MOw ->nOsCisPrac, 5)
      C_ODPOCw->dPlatnOd   := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
      C_ODPOCw->cObdOd     := uctOBDOBI:MZD:cOBDOBI
      C_ODPOCw->cObdDo     := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)
      C_ODPOCw->nPorOdpPol := C_ODPOCw->( Recno())
    ENDIF

    C_ODPOC->( dbSkip())
  ENDDO
RETURN NIL


STATIC FUNCTION _cpyMSTAR_SAZ()
  LOCAL cKy := StrZero(MSPRC_MOw->nOsCisPrac,5) +StrZero( MSPRC_MOw->nPorPraVzt,3)

  * tarify individuální *
  drgDBMS:open('MSTARIND')
  drgDBMS:open('MSTARINDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  MSTARIND->( AdsSetOrder(4), DbSetScope(SCOPE_BOTH, cKy),dbGoTop())

  DO WHILE .not. MSTARIND->( Eof())
    IF .not. Empty( MSTARIND->dPlatTarDo) .AND.                 ;
        ( MSPRC_MOw->nRok <= Year( MSTARIND->dPlatTarDo)) .AND. ;
          ( MSPRC_MOw->nObdobi <= Month( MSTARIND->dPlatTarDo))
      mh_COPYFLD( 'MSTARIND', 'MSTARINDw', .T.)

    ELSE
      IF .not. Empty(MSTARINDw->dPlatTarOd)
        MSTARINDw->dPlatTarDo := MSTARINDw->dPlatTarOd -1
        IF ( MSPRC_MOw->nRok > Year( MSTARINDw->dPlatTarDo))
          MSTARINDw->( dbDelete())
        ELSE
         IF ( MSPRC_MOw->nRok = Year( MSTARINDw->dPlatTarDo)) .AND. ;
            ( MSPRC_MOw->nObdobi > Month( MSTARINDw->dPlatTarDo))
           MSTARINDw->( dbDelete())
         ENDIF
        ENDIF
      ENDIF
      mh_COPYFLD( 'MSTARIND', 'MSTARINDw', .T.)
    ENDIF
    MSTARIND->( dbSkip())
  ENDDO

  * tarify zamìstancù *
  drgDBMS:open('MSSAZZAM')
  drgDBMS:open('MSSAZZAMw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  MSSAZZAM->( AdsSetOrder(4),DbSetScope(SCOPE_BOTH, cKy), dbGoTop())

  DO WHILE .not. MSSAZZAM->( Eof())
    IF .not. Empty( MSSAZZAM->dPlatSazDo) .AND.                ;
       ( MSPRC_MOw->nRok <= Year( MSSAZZAM->dPlatSazDo)) .AND. ;
       ( MSPRC_MOw->nObdobi <= Month( MSSAZZAM->dPlatSazDo))
      mh_COPYFLD( 'MSSAZZAM', 'MSSAZZAMw', .T.)
    ELSE
      IF .not. Empty( MSSAZZAMw->dPlatSazOd)
        MSSAZZAMw->dPlatSazDo := MSSAZZAMw->dPlatSazOd -1
        IF ( MSPRC_MOw->nRok > Year( MSSAZZAMw->dPlatSazDo))
          MSSAZZAMw->( dbDelete())
        ELSE
          IF ( MSPRC_MOw->nRok = Year( MSSAZZAMw->dPlatSazDo)) .AND. ;
                ( MSPRC_MOw->nObdobi > Month( MSSAZZAMw->dPlatSazDo))
            MSSAZZAMw->( dbDelete())
          ENDIF
        ENDIF
      ENDIF
      mh_COPYFLD( 'MSSAZZAM', 'MSSAZZAMw', .T.)
    ENDIF
    MSSAZZAM->( dbSkip())
  ENDDO
RETURN NIL