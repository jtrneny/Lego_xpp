#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"
#include "..\SKLADY\SKL_Sklady.ch"

static function SaveWorkarea()
return  { { Alias(Select())            ,{|x|   DbSelectArea(x)         } }, ;
          { OrdSetFocus()              ,{|x|   AdsSetOrder(x)          } }, ;
          { ads_getaof()               ,{|x|   ads_setaof(x)           } }, ;
          { dbrselect(1), dbrelation(1),{|x,y| sys_relation_crd(x,y)   } }, ;
          { Recno()                    ,{|x|   Dbgoto(x)               } }  }


static function RestWorkSpace(asaved)
  local x, y, pa, pb, cfile

  for x := 1 to len(asaved) step 1
    pa    := asaved[x]

    if used( cfile := pa[1,1] )

      (cfile)->( ads_clearaof())     // odstøelíme filtry
      (cfile)->( dbclearrelation())  // odstøelíme relace

      for y := 2 to len( pa ) step 1
        pb := pa[y]

        if .not. empty( pb[1] )
          if len( pb ) = 2

            if y = 5                 // dbgoto nesmíme se snažit postavit na zrušený záznam
              if (cfile)->(deleted())
                (cfile)->(dbskip())
                pb[1] := (cfile)->(recNo())
              endif
            endif

            (cfile)->( eval( pb[2], pb[1]))
          else
            (cfile)->( eval( pb[3], pb[1], pb[2]))
          endif
        endif
      next
    endif
  next
return .t.


static function sys_relation_crd(warea,cblock)
  dbsetrelation(warea,COMPILE(cblock))
return .t.



*===============================================================================
FUNCTION CenZBOZ_isAktivni()
  Local nIcon := if( CenZboz->lAktivni, if( CenZboz->CTYPSKLPOL = 'X', MIS_EXCL_WARN, MIS_ICON_OK), MIS_NO_RUN )
Return nIcon

function cenZboz_isUlozeni()
  local cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

  if( select( 'ulozeni') = 0, drgDBMS:open('ulozeni'), nil )
return if( ulozeni->( dbseek( cky,,'ULOZE1')), MIS_BOOKOPEN, 0 )

function cenZboz_isceCarKod()
  local cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

  if( select( 'ceCarKod') = 0, drgDBMS:open('ceCarKod'), nil )
return if( ceCarKod->( dbseek( cky,,'CECARKOD03')), 556, 0 )   // zelená


********************************************************************************
*
********************************************************************************
CLASS SKL_CenZboz_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  VAR     nAktivni, FormIsRO
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled,;
          ItemMarked, ItemMarked1

  METHOD  Cenik_DODAVATELE
  METHOD  Cenik_ODBERATELE
  METHOD  Cenik_MISTAULOZ
  METHOD  Cenik_VYROBCIS
  METHOD  Cenik_POHYBY
  method  Cenik_pohyby_oDDo

  METHOD  Cenik_PrepoctyMJ
  METHOD  Cenik_Preceneni
  METHOD  Cenik_CarKody
  method  Cenik_TiskCarKodu
  *
  method  Cenik_StavObd
  method  Cenik_StavDen
  *
  method  Cenik_skl_pohybyhd


  METHOD  DocWORD, DocEXCEL, VazDOKUM
  METHOD  Test_01, Test_02, Test_03, Test_04, Test_05

  * MIS_LIGHT
  inline access assign method poc_dodZboz() var poc_dodZboz
    local  cky  := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)
    local  ncnt := 0

    dodZboz_w->(dbSetScope(SCOPE_BOTH, cky))
    ncnt := dodZboz_W->( Ads_GetKeyCount(3))  // ADS_RESPECTSCOPES        3
  return ncnt

  inline access assign method is_inprepMj() var is_inPrepmj
    local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)
    return if( c_prepj_ow->( dbseek(cky,,'C_PREPMJ02')), MIS_LIGHT, 0 )

  * BRO dodZboz
  inline access assign method is_hlavniDod() var is_hlavniDod
    return if( dodZboz->lhlavniDod, 172, 0 )
  *
  * firmy aktivni/neaktivni
   inline access assign method is_aktivni() var is_aktivni
     if dodZboz->ncisFirmy = 0
       return 0
     else
       firmy->( dbseek( dodZboz->ncisFirmy,, 'FIRMY1' ))
     endif
     return if( firmy->lAktivni, MIS_ICON_OK, MIS_NO_RUN )


* MIS_LIGHT
//  inline access assign method cZakObjInt() var cZakObjInt
//      objvysit->( dbseek(pvpitem->nobjvysit,,'ID'))
//      objvyshd->( dbseek(objvysit->ndoklad,,'OBJDODH6'))
//    return objvyshd->cZakObjInt


  inline method tabSelect( tabPage, tabNumber)
    ::tabNUM := tabNumber
    if( tabNumber = 2, ::itemMarked1(), nil )
    ::enable_or_disable_actions( (tabNumber = 2) )
    return .t.

HIDDEN
  VAR     tabNUM, mainbro
  var     dc, brow
  var     pb_cenik_mistaUloz, pb_cenik_Pohyby, pb_cenik_vyrobCis, asaved, pb_cenik_skl_pohybyhd

  inline method enable_or_disable_actions(isin_pvpitem)
    local is_ulozMi := c_ulozMi->( dbseek( upper( cenZboz->ccisSklad),, 'C_ULOZM2'))

    default isin_pvpitem to .f.

    if isObject(::pb_cenik_mistaUloz)
      if( is_ulozMi, ( ::pb_cenik_mistaUloz:disabled := .f., ::pb_cenik_mistaUloz:oXbp:enable() ), ;
                     ( ::pb_cenik_mistaUloz:disabled := .t., ::pb_cenik_mistaUloz:oXbp:disable())  )
    endif

    if isObject(::pb_cenik_vyrobCis)
      if( empty( CenZBOZ->cVyrCis), ( ::pb_cenik_vyrobCis:disabled := .t., ::pb_cenik_vyrobCis:oXbp:disable()), ;
                                    ( ::pb_cenik_vyrobCis:disabled := .f., ::pb_cenik_vyrobCis:oXbp:enable() )  )
    endif

    if isObject(::pb_cenik_skl_pohybyhd)
      if ::tabNum = 2 .and. ( ::dc:oaBrowse = ::brow[2] .or. isin_pvpitem )
        if( pvpitem->( eof()), ( ::pb_cenik_skl_pohybyhd:disabled := .t., ::pb_cenik_skl_pohybyhd:oxbp:disable()), ;
                               ( ::pb_cenik_skl_pohybyhd:disabled := .f., ::pb_cenik_skl_pohybyhd:oxbp:enable() )  )
      else
        ( ::pb_cenik_skl_pohybyhd:disabled := .t., ::pb_cenik_skl_pohybyhd:oxbp:disable() )
      endif
    endif
  return .t.

ENDCLASS

********************************************************************************
METHOD SKL_CenZboz_SCR:init(parent, FormIsRO)

  ::drgUsrClass:init(parent)
  *
  DEFAULT FormIsRO TO .F.
  *
  *
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('C_TYPPOH' )
  drgDBMS:open('C_ulozMi' )
  drgDBMS:open('VYRCIS'   )
  drgDBMS:open('PVPITEM'  )
  drgDBMS:open('PVPHEAD'  )
  drgDBMS:open('CenZB_NS' )
  drgDBMS:open('C_DPH'    )
  drgDBMS:open('C_SKLADY' )

  drgDBMS:open('DODZBOZ'  )
  drgDBMS:open('dodZboz',,,,.t., 'dodZboz_w')
  dodZboz_w->(ordSetFocus('DODAV5'))

  drgDBMS:open('firmy'    )

  drgDBMS:open('NAKPOL'   )
  drgDBMS:open('CECARKOD' )
  drgDBMS:open('OBJVYSHD' )
  drgDBMS:open('OBJVYSIT' )
  *
  c_typPoh->( ordsetFocus('C_TYPPOH05'))
  OBJVYSIT->( ordsetFocus('ID'))
  OBJVYSHD->( ordsetFocus('OBJDODH1'))

  PVPITEM->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU)'))
  PVPITEM->( DbSetRelation( 'PVPHEAD',  { || PVPITEM->nDoklad }  ,'PVPITEM->nDoklad' ))
  CENZBOZ->( DbSetRelation( 'C_DPH'   , { || CENZBOZ->nKlicDPH } ,'CENZBOZ->nKlicDPH' ))
  CENZBOZ->( DbSetRelation( 'C_SKLADY', { || Upper(CENZBOZ->cCisSklad) },'Upper(CENZBOZ->cCisSklad)'))
  PVPITEM->( DbSetRelation( 'OBJVYSHD',  { || PVPITEM->ccislobint}  ,'PVPITEM->ccislobint' ))
//  OBJVYSIT->( DbSetRelation( 'OBJVYSHD', { || OBJVYSIT->ndoklad}  ,'OBJVYSIT->ndoklad' ))
  *
  ** èíselník pøepoètù mìrných jednotek c_prepmj
  drgDBMS:open( 'c_prepmj',,,,,'c_prepj_ow' )

  drgDBMS:open( 'c_prepmj' )
  drgDBMS:open( 'c_prepmjW',.T.,.T.,drgINI:dir_USERfitm ) ; ZAP


  ::FormIsRO  := FormIsRO
  ::nAktivni  := 2
  ::tabNum    := 1
  *
RETURN self

********************************************************************************
METHOD SKL_CENZBOZ_SCR:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::FormIsRO, ' - INFO', '' )
RETURN

********************************************************************************
METHOD SKL_CENZBOZ_SCR:drgDialogStart(drgDialog)
  Local aEventsDisabled := 'cenik_dodavatele,cenik_mistauloz,cenik_vyrobcis,cenik_pohyby,cenik_prepoctymj,cenik_preceneni'
  Local x, oActions := drgDialog:oActionBar:members
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::mainBro := drgDialog:odBrowse[1]

  ::dc      := drgDialog:dialogCtrl               // dataCtrl
  ::brow    := drgDialog:dialogCtrl:oBrowse

  drgDialog:SetReadOnly( ::formIsRO)

**
  ocolumn := ::brow[1]:getColumn_byName( 'M->poc_dodZboz' )
*  ocolumn:useVisualStyle := .f.
  ocolumn:dataArea:setFontCompoundName( '9.Comic Sans MS' )  // Arial
  ocolumn:dataArea:setColorFG(GRA_CLR_BLUE)
**

  IF ::formIsRO
    for x := 1 to len(oActions)
       if ( lower( oActions[x]:event) $ aEventsDisabled)
         oActions[x]:disabled := .t.
         oActions[x]:parent:amenu:disableItem( x)
         oActions[x]:oXbp:setColorFG( GraMakeRGBColor({128,128,128}))
       endif
    next
  ELSE
    for x := 1 to len(oActions)
      do case
      case oActions[x]:event = 'cenik_mistauloz'
        ::pb_cenik_mistaUloz    := oActions[x]

      case oActions[x]:event = 'cenik_vyrobcis'
        ::pb_cenik_vyrobCis     := oActions[x]

      case oActions[x]:event = 'cenik_pohyby'
        ::pb_cenik_Pohyby       := oActions[x]

      case oActions[x]:event = 'cenik_skl_pohybyhd'
        ::pb_cenik_skl_pohybyhd := oActions[x]
        ::pb_cenik_skl_pohybyhd:oxbp:setPos( { 0,2 } )
      endcase
    next
  ENDIF
  *
  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''               }, ;
                        { 'Aktivní položky        ', 'laktivni = .t.' }, ;
                        { 'Neaktivní položky      ', 'laktivni = .f.' }  }, ;
                      'Ceník'                                            )
RETURN

********************************************************************************
METHOD SKL_CenZboz_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local  dc := ::drgDialog:dialogCtrl
  local  isin_pvpitem := .f.

  DO CASE
     case nEvent = xbeBRW_ItemMarked
       if oxbp:className() = 'XbpCellGroup'
         isin_pvpitem := ( oxbp:parent:cargo:cargo = ::brow[2] )
       endif

       ::enable_or_disable_actions( isin_pvpitem )
       return .f.

    CASE nEvent = drgEVENT_DELETE
      SKL_CENZBOZ_DEL()
      *
      if ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:rowpos = 1
        ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:dehilite()
        ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:rowpos := 2
      endif
      *
      ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
      ::ItemMarked()
      ::ItemMarked1()
      ::drgDialog:datamanager:refresh()
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

*******************************************************************************
METHOD SKL_CenZboz_SCR:ItemMarked()
  local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

  pvpItem->(mh_ordSetScope(cky, 'PVPITEM28'))

  c_prepmjW ->( dbZap())
  c_prepmj  ->( mh_ordSetScope(cky,2))

  do while .not. c_prepmj->( eof())

    mh_copyFld( 'c_prepmj', 'c_prepmjW', .t., .f. )
    c_prepmj->( dbskip())
  endd

  dodZboz ->(mh_ordSetScope(cky, 'DODAV5'))
RETURN SELF

*******************************************************************************
METHOD SKL_CenZboz_SCR:ItemMarked1()
  PVPHEAD->( dbSeek( PVPItem->nDoklad,,'PVPHEAD01'))
RETURN SELF


********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_DODAVATELE()
  local  oDialog
  local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  dodZboz->( dbclearScope())
  DRGDIALOG FORM 'SKL_DODZBOZ_CRD' PARENT ::drgDialog MODAL DESTROY

  ::itemMarked()
  ::brow[4]:oxbp:refreshAll()
RETURN self


********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_ODBERATELE()
  local  oDialog

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SKL_odbzboz_IN' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


*  Místa uložení skladové položky
********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_MISTAULOZ()
  local  oDialog
  local  cky := upper( cenZboz->ccisSklad)

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_ULOZENI_POL' PARENT ::drgDialog DESTROY
  ::drgDialog:popArea()
RETURN self

* Evidence výrobních èísel
********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_VYROBCIS()
  local  oDialog

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_VYRCIS_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self

********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_POHYBY( oDlg)
  Local oDialog, nExit
  Local nRecCen := CenZboz->( RecNO()), cTagCen := CenZboz->(OrdSetFocus())
  Local nRecIt  := PVPItem->( RecNO()), cTagIt  := PVPItem->(OrdSetFocus())

  *
  DRGDIALOG FORM 'SKL_PVPHEAD_SCR' PARENT oDlg MODAL DESTROY EXITSTATE nExit

  CenZBOZ->( AdsSetOrder( cTagCen), dbGoTO( nRecCen) )
  PVPItem->( AdsSetOrder( cTagIt))    // , dbGoTO( nRecIt)  )
  PVPITEM->( mh_SetScope( Upper(CENZBOZ->cCisSklad) + Upper(CENZBOZ->cSklPol) ))
RETURN self


METHOD SKL_CenZboz_SCR:Cenik_pohyby_oDDo( oDlg)
  Local oDialog, nExit
  Local nRecCen := CenZboz->( RecNO()), cTagCen := CenZboz->(OrdSetFocus())
  Local nRecIt  := PVPItem->( RecNO()), cTagIt  := PVPItem->(OrdSetFocus())

  *
  DRGDIALOG FORM 'SKL_pvpitem_oDDo_SCR' PARENT oDlg MODAL DESTROY EXITSTATE nExit

  CenZBOZ->( AdsSetOrder( cTagCen), dbGoTO( nRecCen) )
  PVPItem->( AdsSetOrder( cTagIt))    // , dbGoTO( nRecIt)  )
  PVPITEM->( mh_SetScope( Upper(CENZBOZ->cCisSklad) + Upper(CENZBOZ->cSklPol) ))
RETURN self


********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_PrepoctyMJ()
  LOCAL oDialog, nExit

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  oDialog := drgDialog():new('C_PrepMJ,CENZBOZ->cZkratJEDN', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil
RETURN self

* Pøecenìní skladu z kalkulací
********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_Preceneni()
  LOCAL oDialog, nExit

  IF ::formIsRO  // ::drgDialog:dialogCtrl:isReadOnly
    MsgForRO()
    RETURN self
  ENDIF
  *
  PVPITEM->( dbClearRelation())
  PVPITEM->( mh_ClrScope())
  *
  oDialog := drgDialog():new('VYR_KalkToCEN, MAT', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil
  *
  PVPITEM->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU)', 'C_TYPPOH05'))
  PVPITEM->( DbSetRelation( 'PVPHEAD',  { || PVPITEM->nDoklad }  ,'PVPITEM->nDoklad' ))
RETURN self


* Evidence výrobních èísel
********************************************************************************
METHOD SKL_CenZboz_SCR:Cenik_CarKody()
  local  oDialog

//  IF ::formIsRO
//   MsgForRO()
//    RETURN self
//  ENDIF
  *
  filtr     := format( "ccissklad = '%%' .and. csklpol = '%%'", { cenzboz->ccissklad,cenzboz->csklpol})
  cecarkod->( ads_setAof(filtr),dbgoTop())

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_CECARKOD_IN' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()

  cecarkod->( ads_clearAof())
RETURN self


method SKL_CenZboz_SCR:Cenik_TiskCarKodu()
  local  odialog, nexit := drgEVENT_QUIT, ok := .t.

  local  key

  odialog := drgDialog():new('SKL_PRNcarKODw_IN',::drgDialog)
  odialog:create(,,.T.)
  nexit := odialog:exitState

/*
  drgDBMS:open( 'cenzboz',,,,,'cenzbozq' )
  drgDBMS:open( 'pvpitem',,,,,'pvpitemq' )


  cenzbozq->( dbGoTop())
  do while .not. cenzbozq->( Eof())
    if cenzbozq->ncenanzbo = 0
      key := Upper(cenzbozq->ccissklad) + Upper(cenzbozq->csklpol) + '01'
      if pvpitemq->( dbSeek( key,,'PVPITEM30',.t.))
        if cenzbozq->( dbRlock())
          cenzbozq->ncenanzbo := pvpitemq->ncennapdod
          cenzbozq->( dbUnlock())
        endif
      endif
    endif
    cenzbozq->( dbSkip())
  enddo
*/

return self


*  Stav skladové karty za období
********************************************************************************
method SKL_CenZboz_SCR:Cenik_StavObd()
  local  oDialog
  local  cky := upper( cenZboz->ccisSklad)

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_STAVYobd_kar_SCR' PARENT ::drgDialog DESTROY
  ::drgDialog:popArea()
RETURN self

*  Stav skladové karty za období
********************************************************************************
method SKL_CenZboz_SCR:Cenik_StavDen()
  local  oDialog
  local  cky := upper( cenZboz->ccisSklad)

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_STAVYden_kar_SCR' PARENT ::drgDialog DESTROY
  ::drgDialog:popArea()
RETURN self


method skl_cenZboz_scr:cenik_skl_pohybyhd()
  local  asaved := ::asaved := {}
  local  odialog, nexit := drgEVENT_QUIT, ok := .t.

  WorkSpaceEval( {|| aadd( asaved, SaveWorkarea() ) } )

    pvpitem->( ordSetFocus( 'PVPITEM02' ))

    odialog := drgDialog():new('SKL_pohybyhd',::drgDialog)
    odialog:cargo := drgEVENT_EDIT

    odialog:create(,,.T.)
    nexit := odialog:exitState

  RestWorkSpace(::asaved)
return self



********************************************************************************
METHOD SKL_CenZboz_SCR:DocWord()
  /*
  Local cFile := 'g:\lego_xpp\a_proj\sklady\ceniky\test.doc'

  Doc_Word( cFile)
  */
  ::VazDOKUM()
RETURN .T.

********************************************************************************
METHOD SKL_CenZboz_SCR:DocEXCEL()
  Local cFile := 'g:\lego_xpp\a_proj\sklady\ceniky\test.doc'

  Doc_Excel( cFile)
RETURN .T.

********************************************************************************
METHOD SKL_CenZboz_SCR:VazDokum()
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('SYS_VazDOKUM_SCR',self:drgDialog)
  oDialog:cargo_usr := 'ke skladové položce : ' + Alltrim( CenZBOZ->cSklPol)
  oDialog:create( ,,.F.)
  *
  oDialog:destroy(.T.)
  oDialog := NIL
  *
RETURN .T.

METHOD SKL_CenZboz_SCR:Test_01()
  Skl_Rep_01( 1)
RETURN .T.

METHOD SKL_CenZboz_SCR:Test_02()
  Skl_Rep_01( 2)
RETURN .T.

METHOD SKL_CenZboz_SCR:Test_03()
  Skl_Rep_01( 3)
RETURN .T.

METHOD SKL_CenZboz_SCR:Test_04()
  Skl_Rep_01( 4)
RETURN .T.

METHOD SKL_CenZboz_SCR:Test_05()
  Skl_Rep_01( 5)
RETURN .T.

/********************************************************************************
********************************************************************************
CLASS SKL_CenZboz_SCRro FROM SKL_CenZboz_SCR

EXPORTED:

  INLINE METHOD  Init(parent)
    ::SKL_CenZboz_SCR:init( parent, .T. )
    ::drgDialog:formName := 'SKL_CenZboz_SCR'
  RETURN self

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
*    ::VYR_VyrPol1_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

    DO CASE
    CASE nEvent = drgEVENT_APPEND  .or. ;
         nEvent = drgEVENT_APPEND2 .or. ;
         nEvent = drgEVENT_DELETE

      MsgForRO()
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_INS .or.  mp1 = xbeK_CTRL_DEL
        MsgForRO()
        RETURN .T.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS
*/