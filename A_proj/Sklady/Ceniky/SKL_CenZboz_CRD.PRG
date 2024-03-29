//////////////////////////////////////////////////////////////////////
//
//  CENZBOZ.PRG
//
//////////////////////////////////////////////////////////////////////
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
#include "Xbp.ch"
#include "..\SKLADY\SKL_Sklady.ch"

********************************************************************************
*
********************************************************************************
CLASS SKL_CENZBOZ_CRD FROM drgUsrClass
EXPORTED:
  VAR     cKodTPV
  VAR     lEditALL, oView
  * pro p�evod
  VAR     aSetCRD          // p�ednastaven� edit.polo�ek karty
  *
  METHOD  Init, drgDialogInit, Destroy, drgDialogStart, EventHandled

  METHOD  PreValidate, PostValidate, tabSelect
  METHOD  SKL_C_NAZZBO, C_SKLADY, c_ulozmi_sel

  METHOD  CenapVLD
  METHOD  ProcMARZ
  METHOD  CenapZBO
  METHOD  CenamZBO
  METHOD  GetPC
  METHOD  SetEdit

  METHOD  OnSave, FullViewIMG
  method  ebro_saveEditRow
*  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow

  inline access assign method nazRECpop_info() var nazRECpop_info
    local cinfo := ''

    if isObject(::oget_recPopl)
      if c_recPop->( dbseek(upper(::oget_recPopl:oVar:value),,'C_RECPOP01'))
        cinfo := '[ mj ' +c_recpop->czkratJedn +' cena ' +str(c_recPop->nrecPopl) +' ' +c_recPop->czkratMeny +' ]'
      endif
    endif
    return cinfo

  inline access assign method nazevMista_uloz() var nazevMista_uloz
    local  cky := upper( ulozeniW->culozZbo)

    c_ulozMi->( dbSEEK( cky,,'C_ULOZM1'))
  return c_ulozMi->cnazevMist



HIDDEN:
  VAR     dc, dm, df, tabNum
  var     ocmb_typSKLcen, ocmb_polCen
  var     ocmb_typSKLpol, aCOMBO_val
  var     oget_recPopl

  VAR     lNewCENZBOZ, lNewPC, lCopyREC, cFileIMG
  METHOD  SetNoChange, ShowImage
ENDCLASS

********************************************************************************
METHOD SKL_CENZBOZ_CRD:init(parent)
  Local cKEY := Upper(CENZBOZ->cCisSklad) + Upper(CENZBOZ->cSklPol)

  ::drgUsrClass:init(parent)
  *
  ::aSetCRD    := IF( parent:cargo_usr <> NIL, parent:cargo_usr, {} )
  *
  ::lNewCENZBOZ := !( parent:cargo = drgEVENT_EDIT)
  ::lCopyREC    :=  ( parent:cargo = drgEVENT_APPEND2)
  ::lEditALL    := .F.
  ::cFileIMG    := ''
  *
  drgDBMS:open('UcetSYS' )
  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('CenProdC')
  drgDBMS:open('CenZB_ps')
  drgDBMS:open('C_BCD'   )
  drgDBMS:open('NAKPOL'  )
  drgDBMS:open('PVPITEM' )
  drgDBMS:open('CENZBOZw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('CENPRODCw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('CENZBOZ',,,,,'CENZBOZa' )
  drgDBMS:open('c_recPop')

  *
  * system ulo�en� zbo�� v r�mci ccisSklad, csklPol, lze zalo�it i na cen_cenZboz_scr.Cenik_MISTAULOZ
  drgDBMS:open('c_ulozMi')
  drgDBMS:open('ulozeni' )
  drgDBMS:open('ulozeniW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  *
  CenProdC->( mh_SetScope( cKEY ))
  *
  IF ::lCopyREC
     SetCopyREC()
     CENPRODCw->( dbAppend())
     ::lNewPC := .T.
     TestEmptyREC()

  ELSEIF ::lNewCENZBOZ
     CENPRODCw->( dbAppend())
     ::lNewPC := .T.
     * Do�asn�, ne� najdeme fantoma( pr�zdn� z�znam)
     TestEmptyREC()
     *
     CENZBOZw->(dbAppend())
*     IF LEN( ::aSetCRD) = 0
     * zalo�en� karty standartn�m zp�sobem
     CENZBOZw->cTypSklPol := 'U'  // U = Materi�l nebo zbo�� // ::cKodTPV
     CENZBOZw->cTypSklCen := Upper( SysCONFIG('Sklady:cTypCeny'))
     CENZBOZw->nKlicDph   := VAL( SysCONFIG('Finance:cZaklDph') )
     CENZBOZw->cPolCen    := SysCONFIG('Sklady:cPolCen')
     CENZBOZw->cZkratJedn := SysCONFIG('Sklady:cZaklJedn')
     CENZBOZw->cZkratMeny := SysCONFIG('Finance:cZaklMena')
     CENZBOZw->nTypGenBCD := SysCONFIG('Sklady:nTypGenBcd')
     CENZBOZw->cCarKod    := GenBarCod()
     CENZBOZw->cVyrCis    := ' ' // = neevidovat     acVyrCis[ GetCFG( 'cTypVyrCis')]
     CENZBOZw->cKatalCis  := 'N'
     CENZBOZw->lAktivni   := .T.
*     ELSE
     IF LEN( ::aSetCRD) > 0
       * zalo�en� karty extern� s definovan�m p�ednastaven�m :
       *  - p�i p�evodu
       *  - p�i neexistenci nasn�man� termin�lov� polo�ky v cen�ku
       aEval( ::aSetCRD, {|X,n|  &(::aSetCRD[ n, 1]) := ::aSetCRD[ n, 2]  })
     ENDIF

  ELSE
     mh_COPYFLD('CENZBOZ', 'CENZBOZw', .T.)
     NakPol->( dbSEEK( cKey,,'NAKPOL3'))
     if Empty(CENZBOZw->cTypSklPol)
       CENZBOZw->cTypSklPol := NakPOL->cKodTPV
     endif

     ::lNewPC := EMPTY( CenProdC->cCisSklad)
     IF( ::lNewPC, CENPRODCw->( dbAppend()), mh_COPYFLD('CENPRODC', 'CENPRODCw', .T.) )

     ulozeni->( ordSetFocus('ULOZE1')      , ;
                dbsetScope(SCOPE_BOTH,ckey), ;
                dbgoTop()                    )
     ulozeni->( dbeval( { || ( mh_copyFld( 'ulozeni', 'ulozeniW', .t. ), dbclearScope() ) } ))
  ENDIF
  *
RETURN self

********************************************************************************
METHOD SKL_CENZBOZ_CRD:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += IF( ::lCopyREC, ' - KOPIE ...', ' ...' )
RETURN self

********************************************************************************
METHOD SKL_CENZBOZ_CRD:destroy()

  ::drgUsrClass:destroy()
  ::aSetCRD     := ;
  ::lEditALL    := ;
  ::lNewCENZBOZ := ;
  ::lNewPC      := ;
  ::lCopyREC    := ;
  ::cKodTPV     := ;
  ::oView       := ;
                 Nil
  CenProdC->( mh_ClrScope())
RETURN self

********************************************************************************
*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE  nEvent = drgEVENT_SAVE
      IF ::drgDialog:parent:formName <> 'SKL_CENZBOZ_SCR'
        ::onSave()
      ENDIF
      PostAppEvent(xbeP_Close, nEvent,, ::drgDialog:dialog)

    CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
      PostAppEvent(xbeP_Close,nEvent,,oXbp)

    CASE nEvent = xbeP_Keyboard
      DO CASE
        CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,, ::drgDialog:dialog)
        CASE mp1 = xbeK_ALT_F12
          ::lEditALL := !::lEditALL
          ::SetEdit()

        OTHERWISE
          Return .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:drgDialogStart(drgDialog)
  Local isPohyb, isVyrCis
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::df := drgDialog:oForm                   // form

  ::ocmb_typSKLcen := ::dm:has('cenZbozW->ctypSKLcen'):odrg
  ::ocmb_polCen    := ::dm:has('cenZbozW->cpolCen'):odrg
  ::ocmb_typSKLpol := ::dm:has('cenZbozW->ctypSKLpol'):odrg
  ::aCOMBO_val     := ::ocmb_typSKLpol:values

  ::oget_recPopl   := ::dm:has('cenZbozW->crecPopl'):odrg

  *
  * Polo�ka nCenaSZBO je p�i vstupu do karty editovateln� na z�klad� typu skl.ceny ( PEV = edit, PRU = noedit)
  IsEditGET( {'CenZBOZw->nCenaSZbo' },  drgDialog, ( Upper( CenZBOZw->cTypSklCen) == 'PEV'))
  *
  IF !::lNewCENZBOZ
    * Pokud ji� existuj� pohyby, zablokovat opravu t�chto polo�ek
    drgDBMS:open('PVPITEM',,,,,'PVPITEMa' )
    isPohyb := PVPITEMa->( dbSEEK( Upper(CenZBOZ->cCisSklad) + Upper(CenZBOZ->cSklPol),,'PVPITEM01'))
    PVPITEMa->( dbCloseArea())
    IsEditGET( {'CenZBOZw->cTypSklCen'  ,;
                'CenZBOZw->cPOLCEN'     ,;
                'CenZBOZw->nUcetSkup'   ,;
                'CenZBOZw->cZkratJedn'  },  drgDialog, !isPohyb)
    * Pokud ji� existuj� v�r.��sla, nelze vypnout nebo zm�nit typ evidence !
    drgDBMS:open('VYRCIS',,,,,'VYRCISa' )
    isVyrCis := VYRCISa->( dbSEEK( Upper(CenZBOZ->cCisSklad) + Upper(CenZBOZ->cSklPol),,'C_VYRC1'))
    VYRCISa->( dbCloseArea())
    IsEditGET( {'CenZBOZw->cVyrCis' }, drgDialog, !isVyrCis )

  ENDIF
  *

  IF ( 'INFO' $ UPPER( drgDialog:title) .OR. drgDialog:parent:dialogCtrl:isReadOnly )
     drgDialog:SetReadOnly( .T.)
  ENDIF
  *
  IsEditGET( {'CenZBOZw->cCarKod' },  drgDialog, CENZBOZw->nTypGenBCD = 0 )
  * Nastaven� needitovateln�ch polo�ek na ALT_F12
  ::SetEdit()
  * P�i extern�m zakl�d�n� skl.karty nad PVPterm umo�nit editovat i cCisSklad, cSklPol
  IF LEN(::aSetCRD) > 0 .and. ;
    .not. ( lower( drgDialog:parent:formName) $ 'skl_pvpterm_scr, skl_centerm_sel')
    IsEditGET( {'CenZBOZw->cCisSklad'  ,;
                'CenZBOZw->cSklPol'    },  drgDialog, .F.)
  ENDIF


  if  ::lNewCENZBOZ
    if lower( drgDialog:parent:formName) = 'skl_centerm_sel'
      if lower(drgDialog:parent:dialogCtrl:oaBrowse:cfile) = 'cenzboz'
        cenZbozW->ccisSklad := cenZboz->ccisSklad
        iseditGet( {'CenZBOZw->cCisSklad' },  drgDialog, .F.)

        ::dm:set( 'CENZBOZw->cCisSklad', cenZboz->ccisSklad )
        ::dm:refresh()
      endif
    endif
  endif

  *
  * P�i vol�n� z prodejn�ch cen nastav z�lo�ku "Prodejn� ceny"
  IF drgDialog:parent:formName = 'SKL_CenZboz2_SCR'
    drgDialog:oForm:tabPageManager:showPage( 2, .T.)
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_CENZBOZ_CRD:tabSelect( tabPage, tabNumber)

  LOCAL  drawingArea, oView, oXbp

  ::tabNUM := tabNumber

  if( tabNumber = 3, ::dm:refresh(.t.), nil )

  IF ::tabNUM = 5   // tab_OBRAZEK
    ::ShowImage()
    /*
    ::cFileIMG := 'g:\lego_xpp\a_proj\sklady\ceniky\P6090079.jpg'
    IF FILE( ::cFileIMG)
      drawingArea := tabPage:parent:drgDialog:dialog:drawingArea  // oDlg:drawingArea
//      drawingArea:setFontCompoundName( FONT_HELV_SMALL )

**      oView := ImageView():new( drawingArea, , {372,96}, {204,228} ):create()
      ::oView := ImageView():new( drawingArea, , {10, 20}, {354,378} ):create()
      ::oView:load( ::cFileIMG )
      ::oView:display()
    ELSE
      oXbp := XbpStatic():new( drawingArea, , {372,48}, {204,2} )
      oXbp:type := XBPSTATIC_TYPE_TEXT
      oXbp:caption := '... Obr�zek nen� k dispozici ...'
      oXbp:create()
    ENDIF
    */
  ELSE
    IF !IsNil( ::oView)
      ::oView:destroy()
    ENDIF
  ENDIF

RETURN .T.

********************************************************************************
METHOD SKL_CENZBOZ_CRD:FullViewIMG()
  FullView( ::cFileIMG)
RETURN .T.

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:PreValidate(oVar)
  LOCAL lOK := .T.
  LOCAL cName := oVar:Name, Filter
  local ocmb_typSklPol := ::ocmb_typSklPol, aValues, nPos

  aValues := ::ocmb_typSklPol:values

  if ::ocmb_typSKLcen:value = 'PRU' .or. ::ocmb_polCen:value = 'C '
    if( nPos := ascan( aValues, { |pa| pa[1] = 'Y' } )) <> 0
      aRemove( aValues, nPos )
      ocmb_typSklPol:oXbp:delItem(nPos)
    endif
  else
    if( nPos := ascan( aValues, { |pa| pa[1] = 'Y' } )) = 0
      aadd( aValues, { 'Y ', 'Recykla�n� poplatek' })
      ocmb_typSklPol:oXbp:addItem('Recykla�n� poplatek')
    endif
  endif

  DO CASE
    CASE cName = 'CENZBOZw->cUlozZbo'
      * Nab�dnout jen m�sta ulo�en� dan�ho skladu
      Filter := FORMAT("(C_UlozMi->cCisSklad = '%%')",;
                IF( ::lNewCENZBOZ, { ::dm:get('CENZBOZw->cCisSklad')},;
                                   { CENZBOZ->cCisSklad } ) )
*      C_UlozMi->( Ads_setAOF(filter), dbGoTOP() )
     C_UlozMi->( dbSetFilter( COMPILE( Filter)), dbGoTOP() )
  ENDCASE
RETURN lOK

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:PostValidate(oVar)  // VLD_CENZBOZ(oVar)
  LOCAL xVar := oVar:get(), oIt
  LOCAL lFound, lRet := .T.
  LOCAL cName := oVar:Name, cKey, cSklPol, cCarKod, nTypGenBcd
  Local lChanged := oVar:changed()
  Local aValues := ::dm:vars:values
  * F4
  local  nevent := mp1 := mp2 := nil

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, lchanged := .t., nil)


  If ::lNewCENZBOZ .or. lChanged
    cSklPol := ::dm:get('CENZBOZw->cSklPol')

    DO CASE
    CASE cName = 'CENZBOZw->CCISSKLAD'
**      lRet := ::C_SKLADY()
      IF ( lRet := ::C_SKLADY() )
        IF ::lNewCENZBOZ .and. !Empty( cSklPol )
          cKey :=  Upper(xVar) + Upper( cSklPol)
          lFound := CENZBOZa->( DBSEEK( cKey,,'CENIK03'))
          IF lFound
            drgMsgBox(drgNLS:msg('Skladov� polo�ka [ & ] v r�mci skladu [ & ] ji� existuje !', cSklPol, xVar ))
            lRet := .F.
          ENDIF
          If lRet
            If CENZBOZa->( DBSEEK( Upper( cSklPol ),,'CENIK01'))
              drgMsgBox(drgNLS:msg( 'Skladov� polo�ka  [ & ]  existuje na jin�m skladu !', cSklPol))
            EndIf
          EndIF

        ENDIF
      ENDIF

    CASE cName = 'CENZBOZw->CSKLPOL'
      IF Empty( cSklPol )
        drgMsgBox(drgNLS:msg('Skladov� polo�ka je povinn� �daj !'), XBPMB_WARNING )
        RETURN .F.
      ENDIF

      ::drgDialog:pushArea()            // save SELECT() + ORDER()
      cKey := ::dm:get('CENZBOZw->cCisSklad') + Upper(xVar)
      lFound := CENZBOZa->( DBSEEK( cKey,,'CENIK03'))

      IF ::lNewCENZBOZ
        IF lFound
          drgMsg(drgNLS:msg('Skladov� polo�ka v r�mci skladu ji� existuje !'),, ::drgDialog:dialog)
          lRet := .F.
        ENDIF
        If lRet
          If CENZBOZa->( DBSEEK( Upper( xVar),,'CENIK01'))
            drgMsgBox(drgNLS:msg( 'Skladov� polo�ka  [ & ] existuje na jin�m skladu !', cSklPol))
          EndIf
        EndIF
      ELSEIF lChanged .AND. lFound
        oVar:recall()
        drgMsgBox('Nelze m�nit kl��ov� �daj!')
        lRet := .F.
      ENDIF
      ::drgDialog:popArea()             // restore SELECT() + ORDER()
      *
      nTypGenBcd := ::dm:get('CENZBOZw->nTypGenBCD')
      If nTypGenBcd >= 2 .and. nTypGenBcd <= 5
        cCarKod := GenBCD( nTypGenBcd, ::dm:get('CENZBOZw->cCisSklad'), ::dm:get('CENZBOZw->cSklPol'))
      ENDIF
      ::dm:set('CENZBOZw->cCarKod', cCarKod)

    CASE cName = 'CENZBOZw->CULOZZBO'
      lret := ::c_ulozmi_sel()

    CASE cName = 'CENZBOZw->CNAZZBO'
       ::SKL_C_NAZZBO()
//       ::dm:set('CENZBOZw->nZboziKat', C_NAZZBO->nZboziKAT )

    CASE cName = 'CENZBOZw->CTYPSKLCEN'
      IsEditGET( 'CENZBOZw->nCenaSZBO', ::drgDialog, (Upper( xVar) == 'PEV') )

    CASE ( cName = 'CENZBOZw->NMNOZSZBO' .or. cName = 'CENZBOZw->NCENASZBO' )
      IF xVar <> 0
        ::dm:set('CENZBOZw->nCenaCZBO', ::dm:get('CENZBOZw->nMnozsZBO') * ::dm:get('CENZBOZw->nCenasZBO') )
      ENDIF

    CASE cName = 'CENZBOZw->NCENACZBO'
      IF xVar <> 0
        ::dm:set('CENZBOZw->nCenaSZBO', ::dm:get('CENZBOZw->nCenaCZBO') / ::dm:get('CENZBOZw->nMnozSZBO') )
      ENDIF

    CASE cName = 'CENZBOZw->nTypGenBCD'
      IsEditGET( {'CenZBOZw->cCarKod' }, ::drgDialog, xVar = 0 )
      /*
      If      xVar = 0
      ELSEIF  xVar = 1
        cCarKod := GenBCD_01()
      ELSEIF  xVar = 2
        cCarKod := GenBCD_02( ::dm:get('CENZBOZw->cCisSklad'), ::dm:get('CENZBOZw->cSklPol'))
      ELSEIF  xVar = 3
        cCarKod := GenBCD_03( ::dm:get('CENZBOZw->cCisSklad'), ::dm:get('CENZBOZw->cSklPol'))
      ENDIF
      */

      cCarKod := GenBCD( xVar, ::dm:get('CENZBOZw->cCisSklad'), ::dm:get('CENZBOZw->cSklPol' ) )
      ::dm:set('CENZBOZw->cCarKod', cCarKod)

    *
    **
    CASE cName = 'CenProdCw->NCENCNZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMarz', ::ProcMARZ() )
        ::SetNoChange( 'CenProdCw->nProcMARZ')
        IF( ::dm:get('CenProdCw->nCenaP1ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ1', ::ProcMARZ( 1)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ1')
        IF( ::dm:get('CenProdCw->nCenaP2ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ2', ::ProcMARZ( 2)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ2')
        IF( ::dm:get('CenProdCw->nCenaP3ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ3', ::ProcMARZ( 3)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ3')
        IF( ::dm:get('CenProdCw->nCenaP4ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ4', ::ProcMARZ( 4)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ4')
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ'
      IF xVar <> 0 .and. lChanged
        ::dm:set('CenProdCw->nCenaPZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaPZBO')
        ::dm:set('CenProdCw->nCenaMZBO', ::CenaMZBO() )
        ::SetNoChange( 'CenProdCw->nCenaMZBO')
        ::CenapVLD()
      ENDIF

    CASE cName = 'CenProdCw->NCENAPZBO'
      IF xVar <> 0 .and. lChanged
        ::dm:set('CenProdCw->nProcMARZ', ::ProcMARZ() )
        ::SetNoChange( 'CenProdCw->nProcMarz')
        ::dm:set('CenProdCw->nCenaMZBO', ::CenaMZBO() )
        ::SetNoChange( 'CenProdCw->nCenaMZBO')
        ::CenapVLD()
      ENDIF

    CASE cName = 'CenProdCw->NCENAMZBO'
      IF xVar <> 0 .and. lChanged
        ::dm:set('CenProdCw->nCenaPZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaPZBO')
        ::dm:set('CenProdCw->nProcMARZ', ::ProcMARZ() )
        ::SetNoChange( 'CenProdCw->nProcMARZ')
*        CenapVLD( xVar, ::dm:get('CENZBOZ->NCENASZBO') )
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ1'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP1ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP1ZBO')
        ::CenapVLD( 1)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP1ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ1', ::ProcMARZ( 1) )
        ::SetNoChange( 'CenProdCw->nProcMARZ1')
        ::CenapVLD( 1 )
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ2'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP2ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP2ZBO')
        ::CenapVLD( 2)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP2ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ2', ::ProcMARZ( 2) )
        ::SetNoChange( 'CenProdCw->nProcMARZ2')
        ::CenapVLD( 2)
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ3'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP3ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP3ZBO')
        ::CenapVLD( 3)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP3ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ3', ::ProcMARZ( 3) )
        ::SetNoChange( 'CenProdCw->nProcMARZ3')
        ::CenapVLD( 3)
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ4'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP4ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP4ZBO')
        ::CenapVLD( 4)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP4ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ4', ::ProcMARZ( 4) )
        ::SetNoChange( 'CenProdCw->nProcMARZ4')
        ::CenapVLD( 4)
      ENDIF
    ENDCASE

  ENDIF

RETURN lRet

********************************************************************************
METHOD SKL_CENZBOZ_CRD:SetNoChange( cItem)
  Local oIt := ::dm:has( cItem)
  Local value := Round( oIt:Value, 2)

  oIt:initValue := oIt:prevValue := oIt:Value := value
RETURN self

* Upozorn�, pokud n�kter� z prodejn�ch cen je <= skladov� cen�
********************************************************************************
METHOD SKL_CENZBOZ_CRD:CenapVLD( nTypPC)
  Local nCenaP, nCenaS := ::dm:get( 'CENZBOZw->nCenaSZBO')

  nCenaP := ::GetPC( nTypPC)
  If nCenaP < nCenaS
     drgMsgBox(drgNLS:msg( 'Prodejn� cena je ni��� ne� cena skladov� !'))
  ElseIf nCenaP = nCenaS
     drgMsgBox(drgNLS:msg( 'Prodejn� cena je shodn� s cenou skladovou !'))
  EndIf
Return Nil

* Z p��slu�n� prodejn� ceny vypo��t� p��slu�nou mar�i
* Parametry:
* /nTypPC/ ...typ prodejn� ceny ( 0 = z�kladn�, 1-4 = PC1 - PC4 )
********************************************************************************
METHOD SKL_CENZBOZ_CRD:ProcMARZ( nTypPC)
  Local nProcMarz := 0, nPC
  Local nCenCNZBO := ::dm:get( 'CenProdCw->nCenCNZBO')

  IF nCenCNZBO <> 0
    nPC := ::GetPC( nTypPC)
    nProcMarz := (( nPC - nCenCNZBO ) * 100 )/ nCenCNZBO
    nProcMarz := IF( nPC <= 0, 0, ROUND( nProcMarz, 2) )
  ENDIF

RETURN( nProcMarz )

* Na z�klad� typu prodejn� ceny z�sk� jej� hodnotu z edita�n� karty
********************************************************************************
METHOD SKL_CENZBOZ_CRD:GetPC( nTypPC)
  Local nPC

  DEFAULT nTypPC TO 0
  nPC := IIF( nTypPC = 0, ::dm:get('CenProdCw->nCenaPZBO'),;
          IIF( nTypPC = 1, ::dm:get('CenProdCw->nCenaP1ZBO'),;
           IIF( nTypPC = 2, ::dm:get('CenProdCw->nCenaP2ZBO'),;
            IIF( nTypPC = 3, ::dm:get('CenProdCw->nCenaP3ZBO'),;
             IIF( nTypPC = 4, ::dm:get('CenProdCw->nCenaP4ZBO'), 0 )))))
Return( nPC)

* P�epo��t� z�kladn� prodejn� cenu bez dan�, pop�. PC1 - PC4
********************************************************************************
METHOD SKL_CENZBOZ_CRD:CenaPZBO( cName)
  Local nPC := 0.0000, nCenCNZBO := ::dm:get( 'CenProdCw->NCENCNZBO')
  Local nDph := SeekKodDPH( ::dm:get( 'CENZBOZw->nKlicDph'))

  Do Case
    Case cName = 'CenProdCw->NCENAMZBO'
      nPC := ::dm:get( 'CenProdCw->NCENAMZBO') / ( 1 + ( nDph / 100))
    Case cName = 'CenProdCw->NPROCMARZ'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ') / 100))
    Case cName = 'CenProdCw->NPROCMARZ1'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ1') / 100))
    Case cName = 'CenProdCw->NPROCMARZ2'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ2') / 100))
    Case cName = 'CenProdCw->NPROCMARZ3'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ3') / 100))
    Case cName = 'CenProdCw->NPROCMARZ4'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ4') / 100))
  EndCase

RETURN nPC

* Vypo��t� prodejn� cenu s dan�
********************************************************************************
METHOD SKL_CENZBOZ_CRD:CenaMZBO()
  Local nCenaMZBO := 0.0000
  Local nDph := SeekKodDPH( ::dm:get( 'CENZBOZw->nKlicDph'))

  nCenaMZBO := ::dm:get( 'CenProdCw->NCENAPZBO') * ( 1 + ( nDph / 100))
RETURN nCenaMZBO

* Nastav� (ne)editovatelnost definovan�ch polo�ek
********************************************************************************
METHOD SKL_CENZBOZ_CRD:SetEdit()
  Local aFIELDs

  aFIELDs := { 'CENZBOZw->nMnozsZBO', 'CENZBOZw->nCenaCZBO', 'CENZBOZw->nCarkKod' ,;
               'CENZBOZw->nMnozPoc' , 'CENZBOZw->nMnozDZBO', 'CENZBOZw->nMnozRZBO',;
               'CENZBOZw->nMnozOZBO', 'CENZBOZw->nMnozRZBO', 'CENZBOZw->NMNOZKZBO',;
               'CENZBOZw->NMNOZRSES', 'CENZBOZw->NCENAPOC' , 'CENZBOZw->NCENASVZM',;
               'CENZBOZw->NCENAKURZ', 'CENZBOZw->NCENAVNI' }
  IsEditGET( aFIELDs, ::drgDialog, ::lEditAll )
RETURN NIL


method skl_cenZboz_crd:ebro_saveEditRow(o_EBro)
  local  cfile := lower( o_EBro:cfile)

  if o_EBro:state = 2 .or. empty((cfile)->csklPol)
    (cfile)->cccisSklad := cenZboz->ccisSklad
    (cfile)->csklPol    := cenZboz->csklPol

  endif
return .t.



* Realizace �innost� p�i ulo�en� karty CENZBOZ
********************************************************************************
METHOD SKL_CENZBOZ_CRD:OnSave(isBefore, isAppend)
  local lOkCEN, lOkPC
  local tm

  IF ! ::dc:isReadOnly
    ::dm:save()
    lOkCEN := If( ::lNewCENZBOZ, AddREC('CenZBOZ') , ReplREC('CenZBOZ' ))
    lOkPC  := If( ::lNewPC     , AddREC('CenProdC'), ReplREC('CenProdC'))
    IF lOkCEN .and. lOkPC
      mh_COPYFLD( 'CenZBOZw' , 'CenZBOZ')
      CenZBOZ->cUcetSkup  := ALLTRIM(STR( CenZBOZ->nUcetSkup))
      *
      mh_COPYFLD( 'CenProdCw', 'CenProdC')

      CenProdC->nProcMarz  := ::dm:get('CenProdCw->nProcMarz' )
      CenProdC->nCenaPZBO  := ::dm:get('CenProdCw->nCenaPZBO' )
      CenProdC->nCenaMZBO  := ::dm:get('CenProdCw->nCenaMZBO' )
      CenProdC->nCenaP1ZBO := ::dm:get('CenProdCw->nCenaP1ZBO')
      CenProdC->nCenaP2ZBO := ::dm:get('CenProdCw->nCenaP2ZBO')
      CenProdC->nCenaP3ZBO := ::dm:get('CenProdCw->nCenaP3ZBO')
      CenProdC->nCenaP4ZBO := ::dm:get('CenProdCw->nCenaP4ZBO')
      *
      CENZBOZ->nCenCNZBO := CenProdC->nCenCNZBO
      CENZBOZ->nCenapZBO := CenProdC->nCenapZBO
      CENZBOZ->nCenamZBO := CenProdC->nCenamZBO
      CENZBOZ->lViceCenP := ( CenProdC->nCenaP1ZBO + CenProdC->nCenaP2ZBO + ;
                              CenProdC->nCenaP3ZBO + CenProdC->nCenaP4ZBO ) > 0
      IF ::lNewPC
        CenProdC->cCisSklad := CENZBOZ->cCisSklad
        CenProdC->cSklPol   := CENZBOZ->cSklPol
        CenProdC->cNazZbo   := CENZBOZ->cNazZbo
      ENDIF
      IF ::lNewCENZBOZ
        * Z�pis do ��seln�ku ��rov�ch k�d�
        IF  lOK := AddREC('C_BCD')
          C_BCD->nCarkKod := CENZBOZ->nCarkKod
          mh_WRTzmena( 'C_BCD', .T.)
          C_BCD->( dbUnlock())
        ENDIF
        * Z�pis do souboru po�.stav�
        mh_COPYFLD( 'CenZBOZ' , 'CenZB_ps', .T.)
        CenZB_ps->nROK   := uctOBDOBI:SKL:nRok
      EndIF
      * Aktualizace NakPol
      IF SysCONFIG('Sklady:lVyroba' )
         ::cKodTPV := ::dm:get('CENZBOZw->cTypSklPol' )
*         ::cKodTPV := ::dm:get('M->cKodTpv' )
         SKL_NakPOL_MODI( ::cKodTPV)
      ENDIF
      CenProdC->( dbCommit(), dbUnLock())
      CENZBOZ->( dbCommit(), dbUnLock())
      *
      * Aktualizace pro KARDEX
      if Cfg_kardex('CEN')[1] .and. ::lNewCENZBOZ
        tm := Cfg_kardex('CEN')[2]
        if Ascan( tm, CENZBOZw->cCisSklad) > 0
          ASYs_komunik_int( 'DIST000077', ::drgDialog )
        endif
      endif
 *      PostAppEvent(xbeP_Close,drgEVENT_EXIT,,::drgDialog:dialog)
    ELSE
      drgMsgBox(drgNLS:msg('Nelze modifikovat, z�znam je blokov�n jin�m u�ivatelem !'))
    ENDIF
  ENDIF
RETURN .T.

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:C_SKLADY( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get('CENZBOZw->cCisSklad', .F.)
  Local value  := Upper( drgVar:get())
  Local ok     := ( !Empty(value) .and. C_SKLADY->(dbseek(value,,'C_SKLAD1')))

  if IsObject(drgDialog) .or. !ok
*    _clearEventLoop(.t.)
    DRGDIALOG FORM 'C_SKLADY' PARENT ::drgDialog MODAL DESTROY ;
                              EXITSTATE nExit CARGO drgVar:odrg

    if nExit = drgEVENT_SELECT
      ::dm:set( 'CENZBOZw->cCisSklad', C_Sklady->cCisSklad )
      ::dm:refresh()
    endif
  endif
RETURN (nExit = drgEVENT_SELECT .or. ok)


*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:SKL_C_NAZZBO( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get('CENZBOZw->cNAZZBO', .F.)
  Local value  := Upper(drgVar:get())
  Local ok     := ( !Empty(value) .and. C_NAZZBO->(dbseek(value,,'C_NAZZB1')))
  local keyNaz := SysCONFIG('Sklady:lKlicNazev')

//  ----- �prava JT  10.05.2012
  if keyNaz .and. .not. ok
    IF drgIsYesNO(drgNLS:msg('Neexistuje takov� n�zev v "��seln�ku n�zv� zbo��".;;Zalo�it ho ?') )
      C_NAZZBO->( dbAppend())
      C_NAZZBO->cNAZEVNAZ := drgVar:get()
      C_NAZZBO->(dbCommit())
    ENDIF
  else
    ok := .t.
  endif

  if IsObject(drgDialog)
    DRGDIALOG FORM 'C_NAZZBO' PARENT ::drgDialog MODAL DESTROY ;
                              EXITSTATE nExit CARGO drgVar:odrg

    if nExit = drgEVENT_SELECT
      ::dm:set( 'CENZBOZw->cNazZBO', C_NAZZBO->cNazevNAZ )
    endif
  endif
RETURN (nExit = drgEVENT_SELECT .or. ok)


method skl_cenZboz_crd:c_ulozmi_sel(drgDialog)
  local  odialog, nexit
  local  drgVar   := ::dm:get('cenZbozW->culozZbo', .f. )
  local  value    := upper( drgVar:get())
  *
  local  cisSklad := ::dm:get( 'cenZbozW->ccisSklad' )
  local  lok      := ( empty(value) .or. c_ulozmi->( dbseek( cisSklad +value,, 'C_ULOZM2')) )
  *
  local  filter   := format( "ccisSklad = '%%'", { cisSklad } )

  if isObject(drgDialog) .or. !lok
    c_ulozmi->( ads_setAof(filter), dbgoTop())

    odialog       := drgDialog():new('c_ulozmi', ::drgDialog)
    odialog:cargo := value
    odialog:create(,,.T.)

    nexit         := odialog:exitState
    c_ulozmi->( ads_clearAof())
  endif

  if nExit = drgEVENT_SELECT
    lok := .T.
    ::dm:set( 'cenZbozW->culozZbo', c_ulozmi->culozzbo )
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oxbp)
  endif
return lok


*
** HIDDEN***********************************************************************
METHOD SKL_CENZBOZ_CRD:ShowImage()
  LOCAL  drawingArea, oView, oXbp

  ::cFileIMG := 'g:\lego_xpp\a_proj\sklady\ceniky\P6090079.jpg'
  IF FILE( ::cFileIMG)
    drawingArea := ::drgDialog:dialog:drawingArea  // oDlg:drawingArea
//      drawingArea:setFontCompoundName( FONT_HELV_SMALL )

**      oView := ImageView():new( drawingArea, , {372,96}, {204,228} ):create()
    ::oView := ImageView():new( drawingArea, , {10, 20}, {354,378} ):create()
    ::oView:load( ::cFileIMG )
    ::oView:display()
  ELSE
    oXbp := XbpStatic():new( drawingArea, , {372,48}, {204,2} )
    oXbp:type := XBPSTATIC_TYPE_TEXT
    oXbp:caption := '... Obr�zek nen� k dispozici ...'
    oXbp:create()
  ENDIF

RETURN NIL


* Realizace �innost� p�i zru�en� z�znamu v Cen�ku zbo��.
*===============================================================================
FUNCTION SKL_CENZBOZ_DEL()
  Local cText := 'Skladovou polo�ku nelze zru�it, nebo� ', acText
  Local cKey := Upper( CENZBOZ->cCisSklad) + Upper( CENZBOZ->cSklPol)
  Local lDelete := .T., lOK := .T.
  Local lVyroba := .T.  //SysConfig( "Sklady:lVyroba")

*  fOrdRec( { 'PVPITEM, 1', 'PVPKUMUL, 2', 'CenZb_NS, 1' } )
  IF( Used('PVPITEM'), NIL, drgDBMS:open('PVPITEM'))
  IF( Used('NAKPOL') , NIL, drgDBMS:open('NAKPOL' ))
  IF( Used('KUSOV')  , NIL, drgDBMS:open('KUSOV'  ))
  *
  IF CENZBOZ->nMnozsZBO > 0
     cText += ' ; mno�stv� na sklad�   = ' + AllTrim( Str( CENZBOZ->nMnozsZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF CENZBOZ->nCenacZBO > 0
     cText += ' ; skladov� cena celkem = ' + AllTrim( Str( CENZBOZ->nCenacZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF CENZBOZ->nMnozkZBO > 0
     cText += ' ; mno�stv� k objedn�n� = ' + AllTrim( Str( CENZBOZ->nMnozkZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF CENZBOZ->nMnozrZBO > 0
     cText += ' ; mno�stv� rezervovan� = ' + AllTrim( Str( CENZBOZ->nMnozrZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF PVPITEM->( dbSeek( cKey,,'PVPITEM01'))
     cText += ' ; existuj� k n� pohybov� v�ty '
     lDelete := .F.
  ENDIF
  *
  IF lVyroba   // .and. Upper( AllTrim( CenZboz->cKodTpv)) == 'V'
    IF( lOK := Kusov->( dbSeek( Upper( CENZBOZ->cSklPol),,'KUSOV3')) )
      cText += ' ; je obsa�ena v kusovn�ku jako ni��� polo�ka !'
      lDelete := .F.
    ENDIF
  ENDIF

  **
  IF lDelete
    IF drgIsYESNO(drgNLS:msg('Zru�it skladovou polo�ku < & - & > ?', CenZBOZ->cSklPol, CenZBOZ->cNazZBO ))
      * sma�e Cen�k prodejn�ch cen
      IF( Used('CenProdC'), NIL, drgDBMS:open('CenProdC'))
      IF CenProdC->( dbSeek( cKey,,'CENPROD1'))
        DelREC( 'CenProdC')
      ENDIF
      * sma�e Cen�k zbo�� pro n�kl. strukturu
      IF( Used('CenZb_NS'), NIL, drgDBMS:open('CenZb_NS'))
      IF CenZb_NS->( dbSeek( cKey,,'CENZBNS1'))
        DelREC( 'CenZb_NS')
      ENDIF
      * sma�e z�znamy po�.stav�
      *
      IF( Used('CenZb_ps'), NIL, drgDBMS:open('CenZb_ps'))
      lOK := YES
      DO WHILE lOK
        IF( lOK := CenZb_ps->( dbSeek( cKey,,'CENPS01')))
          IF CenZb_ps->( dbRLock())
            CenZb_ps->( dbDELETE(), dbUnlock() )
          ENDIF
        ENDIF
      ENDDO
      *
      /* sma�e z�znamy po�.stav�
      IF( Used('CenZb_ps'), NIL, drgDBMS:open('CenZb_ps'))
      IF CenZb_ps->( dbSeek( StrZero(uctObdobi:SKL:nRok, 4) + cKey,,'CENPS02'))
        DelREC( 'CenZb_ps')
      ENDIF
      */
      * sma�e NAKPOL
      IF lVyroba  // .and. Upper( AllTrim( CenZboz->cKodTpv)) == 'V'
        IF NakPol->( dbSeek( cKey,,'NAKPOL3'))
          DelREC( 'NAKPOL')
        ENDIF
      ENDIF
      */
      DelREC( 'CenZBOZ')
    ENDIF
  Else
    drgMsgBox(drgNLS:msg( cText))
  EndIf
*  fOrdRec()

RETURN lDelete

* P�i zakl�d�n�/oprav� z�znamu v CENZBOZ zakl�d�/opravuje z�znam v NAKPOL
*===============================================================================
FUNCTION SKL_NakPol_Modi( cKodTpv)
  Local cKey := UPPER( CenZboz->cCisSklad) + UPPER(CenZboz->cSklPol)
  Local nREC := CenZBOZ->( RecNO())
  Local lExist, lOK

  Begin Sequence
    If( lExist := NakPol->( dbSEEK( cKey,,'NAKPOL3')) )
      If !( lOK := WasChange( 'NakPol', 'CenZboz'))
        If ( Upper( cKodTpv) == Upper( NakPol->cKodTpv)) .and. ;
           ( Upper( CenZboz->cNazZbo) == Upper( NakPol->cNazTPV))
  BREAK
        Endif
      EndIf
    EndIf

    If ( lOK := If( lExist, ReplRec( 'NakPol'), AddRec( 'NakPol') )  )
      CenZBOZ->( dbGoTO( nREC))   //
      mh_COPYFLD( 'CENZBOZ', 'NAKPOL' )
      If lExist  ;  NakPol->cZmena     := SysConfig( "System:cUserAbb")
                    NakPol->dZmena     := Date()
                    If ( Upper( CenZboz->cNazZbo) <> Upper( NakPol->cNazTPV) )
                      If ! (lOK := PolInKusov())
                        * pokud skl.pol. nefiguruje v ��dn�m kusovn�ku, lze n�zev v NakPol nahradit n�zvem z CenZboz
                        NakPol->cNazTPV := CenZboz->cNazZbo
                      EndIf
                    EndIf
      Else       ;  NakPol->cZapis     := SysConfig( "System:cUserAbb")
                    NakPol->dZapis     := Date()
                    NakPol->cMjTPV     := CenZboz->cZkratJEDN
                    NakPol->cMjSpo     := CenZboz->cZkratJEDN
                    NakPol->nKoefPrep  := 1
                    NakPol->cKodRezSkl := SysConfig( "Vyroba:cKodRezSkl")
                    NakPol->cNazTPV    := CenZboz->cNazZbo
      Endif
      NakPol->cKodTpv := cKodTpv
      * NakPol->cNazTPV := CenZboz->cNazZbo
      NakPol->( dbUnLock())
    EndIf
  End Sequence

RETURN NIL

*-- Test, zda skl.polo�ka figuruje v n�jak�m kusovn�ku -------------------------
STATIC FUNCTION PolInKusov()
  Local lOK
  drgDBMS:open('KUSOV')
  lOK := Kusov->( dbSeek( Upper( CENZBOZ->cSklPol),,'KUSOV3'))
RETURN lOK

*===============================================================================
STATIC FUNCTION SetCopyREC()
  LOCAL nPos, aFld
  LOCAL cFld := 'cCisSklad,nKliNaz,nZboziKat,nUcetSkup,cUcetSkup,cNazZbo,cNazZbo2,' + ;
                'cTypSklPol,cKatcZbo,cJKPOV,cZkratJedn,nKlicDph,cZkratMeny,nCenPol' + ;
                'cTypSklCen,cPolCen'
  *
  local  cInfo  := 'Promi�te pros�m,'                                 +CRLF + ;
                   'po�adujete p�evz�t ��slo skladov� polo�ky ' +CRLF +CRLF + ;
                   '  !!! sklad a skladov� polo�ka nesm� b�t duplicitn� !!!'
  local  nsel


  aFld :=  ListAsArray( cFld)
  CENZBOZw->( DbAppend())
  aEVAL( aFld, { |X,i| ;
                ( nPos := CENZBOZ->( FieldPos( X))             , ;
                If( nPos <> 0, CENZBOZw->( FieldPut( nPos, CENZBOZ->( FieldGet( nPos)) )), Nil ) ) } )


  nsel := confirmBox( , cinfo                                                 , ;
                       'P�evz�t ��slo sklPolo�ky = ' +cenZboz->csklPol +' ...', ;
                        XBPMB_YESNO                                           , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE            )

  if nsel = XBPMB_RET_YES
    cenZbozW->csklPol := allTrim(cenZboz->csklPol) +'/'
  endif
RETURN NIL

* Zjist�, zda n�kter� ze stejnojmen�ch polo�ek obou soubor� e li��.
*===============================================================================
FUNCTION WasChange( cINTO, cFROM )
  Local aItmInto := {}, aItmFrom := {}, aStr := {}
  Local n, nPos, lWasChange := FALSE

  aStr := ( cINTO)->( dbStruct())
  aEval( aStr, { |aFld| aAdd( aItmInto, aFld[ DBS_NAME] )} )
  aStr := ( cFROM)->( dbStruct())
  aEval( aStr, { |aFld| aAdd( aItmFrom, aFld[ DBS_NAME] )} )
  For n := 1 To Len( aItmInto)
    If (( nPos := aScan( aItmFrom, aItmInto[ n]) ) <> 0 )
      lWasChange := ;
      If( ( cINTO)->( FieldGet( n)) <> ( cFROM)->( FieldGet( nPos)), TRUE, lWasChange )
    Endif
 Next
Return( lWasChange)

* P�ednastaven� ��rov�ho k�du.
*===============================================================================
FUNCTION VldBarCod( nKod)
  Local nCarkKod := Val( '0000000000000' ), nBarCod
  Local nDigitBCD, nDigitCMP := 0, nEven := 0, nOdd := 0, n, nX, nRec
  Local cBCD, lOk := .f., lValid := !IsNil( nKod)

  If IsNil( nKod) ;  ( C_BCD->( dbGoBottom()), nBarCod := C_BCD->nCarkKod )
  Else            ;  nDigitBCD  := Val( Right( StrZero( nKod), 1 ))
                     nBarCod := nKod
  EndIf
  cBCD := Left( StrZero( nBarCod ), 12 )
  cBCD := If( IsNil( nKod), StrZero( Val( cBCD) + 1, 12, 0) + '0', cBCD + '0' )
  For n := 1 To Len( cBcd) Step 2
    nOdd += Val( SubStr( cBcd, n, 1))
  Next
  For n := 2 To Len( cBcd) Step 2
    nEven += Val( SubStr( cBcd, n, 1))
  Next
  nX := ( nEven * 3) + nOdd
  nDigitCMP := Round( nX +4, -1 ) - nX
  nCarkKod := Val( Left( cBCD, 12) + StrZero( nDigitCMP, 1))
  If !IsNil( nKod)
    Do Case
      Case nDigitBCD <> nDigitCMP
        drgMsgBox(drgNLS:msg( '��rov� k�d m� chybnou kontroln� ��slici !'))
        Return( { .f., nKod, Nil } )
      EndCase
  EndIf
  nKod := If( IsNil( nKod), nCarkKod, nKod )
  If nKod > 0
    nRec := CENZBOZ->( RecNo())
    fOrdRec( { 'CENZBOZ, 8' })
    If lOk := CENZBOZ->( dbSeek( nKod))
      If lValid
        If( lOk := If( nRec == CENZBOZ->( RecNo()), .f., .t. ) )
          drgMsgBox(drgNLS:msg( 'Duplicitn� ��slo ��rov�ho k�du !'))
        EndIf
      Endif
    Endif
    fOrdRec()
  Endif
  If lValid
    Return( { !lOk, nKod, Nil } )
  Endif
RETURN( nCarkKod )

*-------------------------------------------------------------------------------
STATIC Function TestEmptyREC()
  Local nRec := CenZboz->( RecNo())

  IF CenZBOZ->( dbSEEK( SPACE( 23),, 'CENIK03'))
     CenZBOZ->( sx_RLock(), DbDelete(), dbUnlock())
  ENDIF
  CenZboz->( dbGoTO( nRec))
RETURN nil