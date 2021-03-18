/*==============================================================================
  HIM_MAJ_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "adsdbe.ch"
#include "..\HIM\HIM_Him.ch"
*
#DEFINE  tab_ZMAJU    2
#DEFINE  tab_ZMAJN    3
#DEFINE  tab_DMAJ     5
#DEFINE  tab_UMAJ     6

*===============================================================================
FUNCTION HIM_isHmotny( cFile)
  Local cRet := IF( (cFile)->lHmotnyIM, 'Ano', 'Ne ' )
RETURN cRet

*===============================================================================
FUNCTION HIM_ZnAkt( cFile, cTypAkt)
  Local nIcon := 0
  Local nZnAkt, cZnAkt := cFile + '->nZnAkt' + If( cTypAkt = 'U', '', 'D' )

  nZnAkt := &cZnAkt
  Do Case
    Case nZnAkt = 0    ;  nIcon := 0                 // aktivní
    Case nZnAkt = 1    ;  nIcon := MIS_NO_RUN        // neaktivní
    Case nZnAkt = 2    ;  nIcon := MIS_ICON_OK       // odepsaný
    Case nZnAkt = 9    ;  nIcon := MIS_ICON_ERR      // prodaný
  EndCase

RETURN nIcon

static function poz_browseContext(obj, ix, nMENU)
return {|| obj:poz_fromContext( ix, nMENU) }



********************************************************************************
*
********************************************************************************
CLASS HIM_MAJ_SCR FROM drgUsrClass
EXPORTED:
  VAR     cAktObd, cTask, isHIM
  VAR     fiMAJ, fiZMAJU, fiZMAJN, fiUMAJ, fiDMAJ, fiCIS

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  ItemMarked

  METHOD  HIM_POHYBY
  METHOD  HIM_POZEMEK
  METHOD  HIM_STROJ
  METHOD  Data_aktual

  Inline Access Assign  METHOD ZustCenaU() VAR ZustCenaU
   RETURN (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct

  Inline Access Assign  METHOD ZustCenaD() VAR ZustCenaD
   RETURN (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan

  *
  ** pozemky / pozemkyit - SCR
  inline method poz_createContext()
    local  pa    := ::a_popUp
    local  aPos  := ::pb_context:oXbp:currentPos()
    local  aSize := ::pb_context:oXbp:currentSize()

    opopup         := XbpImageMenu():new( ::m_Dialog:dialog )
    opopup:barText := 'Pozemky'
    opopup:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                        , ;
                       poz_BrowseContext(self,x,pA[x]), ;
                                                      , ;
                       XBPMENUBAR_MIA_OWNERDRAW         }, ;
                       500                                 )
    next

    opopup:popup( ::pb_context:oxbp:parent, { apos[1] -150, apos[2] } )
  return self

  inline method poz_fromContext(aorder,p_popUp)
    local cformName := p_poPup[2]
    local odialog

    odialog := drgDialog():new( cformName, ::m_Dialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    setAppFocus( ::m_DBrow:oxbp )
    PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)

    if( cformName = 'fin_typUhrfak_in', ::m_DBrow:oxbp:refreshCurrent(), nil )
  return self

HIDDEN:
  VAR     tabNUM, dm, m_DBrow
  var     m_Dialog, a_poPup, pb_context
ENDCLASS

********************************************************************************
METHOD HIM_MAJ_SCR:Init(parent, cTask )
  ::drgUsrClass:init(parent)

  DEFAULT cTASK TO 'HIM'
  ::cTASK := cTASK
  ::isHIM := ( ::cTASK = 'HIM')

  ::fiMAJ   := IF( ::isHIM, 'MAJ'     , 'MAJZ'    )
  ::fiZMAJU := IF( ::isHIM, 'ZMAJU'   , 'ZMAJUZ'  )
  ::fiZMAJN := IF( ::isHIM, 'ZMAJN'   , 'ZMAJNZ'  )
  ::fiDMAJ  := IF( ::isHIM, 'DMAJ'    , 'DMAJZ'   )
  ::fiUMAJ  := IF( ::isHIM, 'UMAJ'    , 'UMAJZ'   )
  ::fiCIS   := 'C_TYPPOH'

  drgDBMS:open( ::fiCIS )
  drgDBMS:open( ::fiMAJ )
  drgDBMS:open( 'C_DrPohI' )  // DOÈASNÌ
  drgDBMS:open( 'C_DrPohZ' )  // DOÈASNÌ
  drgDBMS:open( 'c_uctskZ' )
  drgDBMS:open( 'pozemkit' )

  if (::fiMAJ)->( fieldPos( 'nucetSkup')) <> 0
     c_uctskZ->( dbSeek( (::fiMAJ)->nucetSkup,,'C_UCTSKZ1'))
  endif

  ::tabNUM  := 1
  ::cAktObd := uctOBDOBI:&(::cTask):cObdobi
RETURN self

********************************************************************************
METHOD HIM_MAJ_SCR:drgDialogStart(drgDialog)
  local members := drgDialog:oActionBar:members, x

  ::dm       := drgDialog:dataManager
  ::m_DBrow  := drgDialog:dialogCtrl:oBrowse[1]

  ::m_Dialog := drgDialog
  ::a_poPup  := { { 'Dle pozemkù             ', 'him_pozemky_scr'  }, ;
                  { 'Dle pohybu na pozemcích ', 'him_pozemkit_scr' }  }

  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )

  IF ::isHIM
    MAJ->( DbSetRelation( 'C_TypMaj', {|| MAJ->nTypMaj }, 'MAJ->nTypMaj' ))
  ENDIF
  (::fiZMAJU)->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },;
                                                'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU)',;
                                                'C_TYPPOH05'))

  ::tabSelect( , tab_ZMAJU)

  for x := 1 to len(members) step 1
    if  members[x]:ClassName() = 'drgPushButton'
      if( members[x]:event = 'poz_createContext', ::pb_context := members[x], nil )
    endif
  next
RETURN self

********************************************************************************
METHOD HIM_MAJ_SCR:drgDialogEnd(drgDialog)
RETURN self

********************************************************************************
METHOD HIM_MAJ_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local lRet := .T.
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      HIM_MAJ_DEL( self)
      * oXbp ... je XbpBrowse pøi DELETE pøes klávesu
      *      ... je xbpStatic pøi DELETE pøes action buton na lištì
      * oXbp:cargo:refresh()
      ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
      aeval(::drgDialog:dialogCtrl:obrowse, {|x| if( x = self, nil, x:oxbp:refreshall() )})
      ::dm:refresh()
      RETURN .T.

    CASE nEvent = drgEVENT_APPEND

      if !ObdobiUZV( ::cAktObd, 'U' )                      // období není úèetnì uzavøeno v ÚÈETNICTVÍ
        if !ObdobiUZV( ::cAktObd, IF( ::isHIM, 'I', 'Z' )) // období není úèetnì uzavøeno v úloze HIM (ZVI)
         lRet := .F.
        endif
      endif
      Return lRet

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

********************************************************************************
METHOD HIM_MAJ_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  ::itemMarked()
RETURN .T.

********************************************************************************
METHOD HIM_MAJ_SCR:ItemMarked()
  LOCAL cFILE
  LOCAL cScope := IF( ::isHIM, StrZero( (::fiMaj)->nTypMaj,3), StrZero( (::fiMaj)->nUcetSkup,3)) +StrZero( (::fiMaj)->nInvCis, 15)
  local m_filter := "ninvCis = %%", filter

  cFILE := IF( ::tabNUM = tab_ZMAJU, ::fiZMAJU,;
           IF( ::tabNUM = tab_ZMAJN, ::fiZMAJN,;
           IF( ::tabNUM = tab_DMAJ , ::fiDMAJ ,;
           IF( ::tabNUM = tab_UMAJ , ::fiUMAJ , '' ))))

  IF !EMPTY( cFILE)
    ( cFILE)->( mh_SetScope( cScope) )

    FOR x := 2 To Len( ::drgDialog:odBrowse)
      oB := ::drgDialog:odBrowse[x]
      IF( cFILE = oB:cFile)
        oB:oXbp:refreshAll()
        ( cFILE)->( dbGoTop())
        oB:oXbp:refreshCurrent():hilite()
      ENDIF
    NEXT

  ENDIF

  if (::fiMAJ)->( fieldPos( 'nucetSkup')) <> 0
     c_uctskZ->( dbSeek( (::fiMAJ)->nucetSkup,,'C_UCTSKZ1'))
  endif

  if ::isHIM
    if select('pozemky') <> 0
      filter := format( m_filter, { (::fiMaj)->ninvCis } )
      pozemky ->( ads_setAof( filter), dbgoTop() )
      pozemkit->( ads_setAof( filter), dbgoTop() )

      if isObject(::pb_context)
        if( pozemky->(eof()), ::pb_context:disable(), ::pb_context:enable() )
      endif
    endif
  endif
RETURN SELF

********************************************************************************
METHOD HIM_MAJ_SCR:destroy()
  ::drgUsrClass:destroy()

  ::cTask := ::isHIM := ;
  ::fiMAJ := ::fiZMAJU := ::fiZMAJN := ::fiUMAJ := ::fiDMAJ := ::fiCIS := ;
   Nil
RETURN self

********************************************************************************
METHOD HIM_MAJ_SCR:HIM_POHYBY()
  LOCAL oDialog
  Local cTag := (::fiZMAJU)->( OrdSetFocus()), cTag2 := (::fiMAJ)->( OrdSetFocus())
  Local cOBDsave := uctOBDOBI:&(::cTASK):cObdobi

  DRGDIALOG FORM ::cTASK + '_POHYBY_CRD' PARENT ::drgDialog MODAL DESTROY

*  if cOBDsave = uctOBDOBI:&(::cTASK):cObdobi
    (::fiMAJ)->( AdsSetOrder( cTAG2))
    (::fiZMAJU)->( AdsSetOrder( cTAG))
    ::itemMarked()
    *
    ::drgDialog:odBrowse[1]:oXbp:refreshCurrent():hilite()
*  else
*    uct_ucetsys_inlib( ::drgDialog, .T.)
*  endif
  *

  setAppFocus( ::m_DBrow:oxbp )
  PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)
RETURN self

********************************************************************************
METHOD HIM_MAJ_SCR:HIM_POZEMEK()
  LOCAL oDialog
  Local cTag := (::fiZMAJU)->( OrdSetFocus()), cTag2 := (::fiMAJ)->( OrdSetFocus())

  DRGDIALOG FORM 'HIM_POZEMKY_SCR' PARENT ::drgDialog MODAL DESTROY
*  DRGDIALOG FORM 'HIM_POZEMKY_IN' PARENT ::drgDialog MODAL DESTROY

*  if cOBDsave = uctOBDOBI:&(::cTASK):cObdobi
    (::fiMAJ)->( AdsSetOrder( cTAG2))
    (::fiZMAJU)->( AdsSetOrder( cTAG))
    ::itemMarked()
    *
    ::drgDialog:odBrowse[1]:oXbp:refreshCurrent():hilite()
*  else
*    uct_ucetsys_inlib( ::drgDialog, .T.)
*  endif
  *

  setAppFocus( ::m_DBrow:oxbp )
  PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)
RETURN self

********************************************************************************
METHOD HIM_MAJ_SCR:HIM_STROJ()
  LOCAL oDialog
  Local cTag := (::fiZMAJU)->( OrdSetFocus()), cTag2 := (::fiMAJ)->( OrdSetFocus())

  DRGDIALOG FORM 'HIM_POZEMKY_IN' PARENT ::drgDialog MODAL DESTROY

*  if cOBDsave = uctOBDOBI:&(::cTASK):cObdobi
    (::fiMAJ)->( AdsSetOrder( cTAG2))
    (::fiZMAJU)->( AdsSetOrder( cTAG))
    ::itemMarked()
    *
    ::drgDialog:odBrowse[1]:oXbp:refreshCurrent():hilite()
*  else
*    uct_ucetsys_inlib( ::drgDialog, .T.)
*  endif
  *

  setAppFocus( ::m_DBrow:oxbp )
  PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)
RETURN self




********************************************************************************
METHOD HIM_MAJ_SCR:Data_aktual()
  Local oData

  oData := HIM_Support_1():New( self, ::cTASK)

RETURN self

/********************************************************************************
*
********************************************************************************
CLASS ZVI_MAJ_SCR FROM HIM_MAJ_SCR

EXPORTED:
  METHOD  Init
*  METHOD  ZVI_POHYBY
ENDCLASS

*
********************************************************************************
METHOD ZVI_MAJ_SCR:Init(parent)

*  ::drgUsrClass:init(parent)
  ::HIM_MAJ_SCR:init( parent, 'ZVI' )
RETURN self
*/