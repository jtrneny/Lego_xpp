/*==============================================================================
  SKL_Ulozeni_pvp.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "gra.ch"
#include "..\SKLADY\SKL_Sklady.ch"

*
*===============================================================================
FUNCTION SKL_NazevMista()
  C_UlozMi->( dbSEEK( Upper( ULOZMIw->cUlozZbo),,'C_ULOZM1'))
RETURN C_UlozMi->cNazevMist

********************************************************************************
* Pøíjem na místa / Výdej z míst  uložení pøi pohybech
********************************************************************************
CLASS SKL_Ulozeni_PVP FROM  drgUsrClass
EXPORTED:
  VAR     nUlozMnoz
  VAR     Sklad, NazSklad, cWarning

  METHOD  Init
  METHOD  Destroy
  METHOD  drgDialogStart
  METHOD  SumColumn
*  METHOD  CreateULOZMIw
  METHOD  PostValidate

  METHOD  DoSave                 // Uloží místa uložení

HIDDEN
  VAR     dm, brow, UDCP

ENDCLASS

*
********************************************************************************
METHOD SKL_Ulozeni_PVP:Init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('PVPUloz' )
  drgDBMS:open('C_ULOZMI')
  drgDBMS:open('ULOZENI' )

  drgDBMS:open('ULOZMIw'  ,.T.,.T.,drgINI:dir_USERfitm)
  ULOZMIw->( dbZAP())

  CreateULOZMIw()
  *
  ::UDCP      := parent:parent:UDCP
  ::Sklad     :=  pvpitemww->ccissklad //  ::UDCP:cSklad
  ::NazSklad  :=  ''                   //::UDCP:cNazSKLAD
  ::cWarning  := ''
  ::nUlozMnoz := 0.00

RETURN self

*
********************************************************************************
METHOD SKL_Ulozeni_PVP:drgDialogStart(drgDialog)
  Local n, members := drgDialog:oActionBar:Members

  ::dm   := drgDialog:dataManager
  ::brow := drgDialog:dialogCtrl:oBrowse
  *
  FOR n:= 1 TO LEN( members)
    IF members[n]:event = 'SEPARATOR'
      members[n]:oXbp:visible := .F.
      members[n]:oXbp:configure()
     ENDIF
  NEXT
  *
  ::dm:has('M->Sklad'    ):oDrg:oXbp:setColorFG( GRA_CLR_BLUE)
  ::dm:has('M->Sklad'    ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {221, 221, 221} ))
  ::dm:has('M->NazSklad' ):oDrg:oXbp:setColorFG( GRA_CLR_BLUE)
  ::dm:has('M->nUlozMnoz'):oDrg:oXbp:setColorBG( GraMakeRGBColor( {255, 255, 200} ))
  ::dm:has('M->cWarning' ):oDrg:oXbp:setColorFG( GRA_CLR_RED)
  *
*  CreateULOZMIw()
  *
  ::sumColumn()
  ::brow[1]:oXbp:refreshAll()
  SetAppFocus( ::brow[1]:oXbp)
  PostAppEvent( drgEVENT_EDIT,,,::brow[1]:oXbp)

RETURN self

*
********************************************************************************
METHOD SKL_Ulozeni_PVP:destroy()
  ::drgUsrClass:destroy()
  *
  ::nUlozMnoz := ::Sklad := ::NazSklad := ::cWarning := ;
   NIL
RETURN self

* Pøednaplní TMP souboru ULOZMIw
********************************************************************************
*METHOD SKL_Ulozeni_PVP:CreateULOZMIw()
STATIC FUNCTION CreateULOZMIw()
  Local cKey, cKeyPVP

*  drgDBMS:open('ULOZMIw'  ,.T.,.T.,drgINI:dir_USERfitm)
*  ULOZMIw->( dbZAP())

  C_UlozMi->( AdsSetOrder(1) ,;
              mh_SetSCOPE( Upper( PVPITEM->cCisSklad)) )

  cKEY := Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol)
  DO WHILE !C_UlozMi->( EOF())
    * z C_UlozMi
    mh_COPYFLD( 'C_UlozMi', 'ULOZMIw', .T.)
    * z Ulozeni
    IF ULOZENI->( dbSEEK( cKey + Upper( C_ULOZMI->cUlozZBO )))
      ULOZMIw->nUlozCelk := Ulozeni->nUlozCelk
      ULOZMIw->cPoznamka := Ulozeni->cPoznamka
    ENDIF
    * z PVPUloz
    cKeyPVP := STRZERO( PVPHead->nDoklad, 10) + StrZERO( PVPItem->nOrdItem, 5) + ;
               Upper( C_UlozMi->cUlozZBO)
    IF PVPUloz->( dbSEEK( cKeyPVP))
      ULOZMIw->nOrigMnoz := PVPUloz->nUlozMnoz
      ULOZMIw->nUlozMnoz := PVPUloz->nUlozMnoz
    ENDIF
    * z PVPItem
    ULOZMIw->nTypPOH   := PVPItem->nTypPOH
    *
    C_UlozMi->( dbSkip())
  ENDDO
  ULOZMIw->( dbGoTOP())
  C_UlozMi->( mh_ClrSCOPE(), dbGoTOP() )

RETURN NIL
*
********************************************************************************
METHOD SKL_Ulozeni_PVP:sumColumn( lValid)
  Local nRec := UlozMIw->( RecNo()), value, cText := '', lOK := .T.
  Local cText2 :=  IF( PVPItem->nTypPoh == 1, 'pøijmout', 'vydat' )

  DEFAULT lValid TO .F.
  ::nUlozMnoz := 0.00
  UlozMIw->(DbGoTop())
  ULOZMIw->( dbEVAL( {||  ::nUlozMnoz += UlozMIw->nUlozMnoz } ))
  UlozMIw->( dbGoTO( nRec))
  *
  cText := IIF( ::nUlozMnoz > PVPItem->nMnozPrDod, 'VÍCE',;
           IIF( ::nUlozMnoz < PVPItem->nMnozPrDod, 'MÉNÌ', cText ))
  ::cWarning := IF( EMPTY( cText), '', '<>  množství na dokladu !')
  IF lValid
    IF !( lOK := EMPTY( cText) )
      drgMsgBox(drgNLS:msg( 'Nelze & & než je na dokladu  !', cText2, cText))
    ENDIF
  ENDIF
  ::dm:refresh()
RETURN lOK

*
********************************************************************************
METHOD SKL_Ulozeni_PVP:postValidate(drgVar)
  LOCAL  lOK := .T., lChanged := drgVAR:changed()
  LOCAL  value := drgVar:get()
  LOCAL  cName := drgVar:name

  IF cName = 'ULOZMIw->nUlozMnoz' .and. lChanged
    IF ULOZMIw->nTypPOH = -1 .AND. ;
      value > ULOZMIw->nUlozCELK + ULOZMIw->nOrigMnoz
      drgMsgBox(drgNLS:msg( 'Nelze vydat více, než je uloženo !'))
      lOK := .F.
    ENDIF
    IF lOK
      &cName := value
      ::sumColumn()
    ENDIF
  ENDIF

RETURN lOK

*
********************************************************************************
METHOD SKL_Ulozeni_PVP:DoSave()
  Local nKEY := ::drgDialog:cargo
  LOCAL lOK := ::SumColumn( .T.)

  IF lOK
    SaveMistaUL( nKEY)
    PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
  ENDIF
RETURN self

*
*===============================================================================
STATIC FUNCTION SaveMistaUL( nKEY)
  Local nSign := PVPItem->nTypPoh
  Local cKey    := Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol)
  Local cKeyPVP := StrZERO( PVPItem->nDoklad, 10) + StrZERO( PVPItem->nOrdItem, 5)
  LOCAL nRec := ULOZMIw->( RecNO())
*  Local nKEY := ::drgDialog:cargo
*  LOCAL lOK := ::SumColumn( .T.)

*  IF lOK
    ULOZMIw->( dbGoTOP())
    DO WHILE !ULOZMIw->( EOF())
      IF ULOZMIw->nOrigMnoz <> 0 .or. ULOZMIw->nUlozMnoz <> 0
        * Aktualizace Ulozeni.dbf
        lOK := Ulozeni->( dbSEEK( cKey + Upper( ULOZMIw->cUlozZBO)))
        IF nKEY == xbeK_DEL
           IF lOK .AND. ReplREC( 'Ulozeni')
              Ulozeni->nUlozMnoz += -( nSign * ULOZMIw->nOrigMnoz)
              Ulozeni->nUlozCelk := Ulozeni->nPocStav + Ulozeni->nUlozMnoz
              Ulozeni->( dbUnlock())
           ENDIF
        ELSE
          IF( lOK := IF( lOK, ReplREC( 'Ulozeni') , AddREC( 'Ulozeni')))
              Ulozeni->cCisSklad := ULOZMIw->cCisSklad
              Ulozeni->cSklPol   := PVPItem->cSklPol
              Ulozeni->cUlozZBO  := ULOZMIw->cUlozZBO
              Ulozeni->cPoznamka := ULOZMIw->cPoznamka
              Ulozeni->nUlozMnoz += -( nSign * ULOZMIw->nOrigMnoz) + ;
                                     ( nSign * ULOZMIw->nUlozMnoz)
              Ulozeni->nUlozCelk := Ulozeni->nPocStav + Ulozeni->nUlozMnoz
              Ulozeni->( dbUnlock())
          ENDIF
        ENDIF

        * Aktualizace PVPUloz.dbf
        lOK := PVPUloz->( dbSEEK( cKeyPVP + Upper( ULOZMIw->cUlozZBO)))
        IF nKEY == xbeK_DEL
          IF( lOK, DelREC( 'PVPUloz'), Nil)
        ELSE
          IF( lOK := IF( lOK, ReplREC( 'PVPUloz') , AddREC( 'PVPUloz')))
            mh_COPYFLD( 'PVPItem', 'PVPUloz')
            PVPUloz->cUlozZBO  := ULOZMIw->cUlozZBO
            PVPUloz->nUlozMnoz := ULOZMIw->nUlozMnoz
            PVPUloz->( dbUnlock())
          ENDIF
        ENDIF
      ENDIF
      ULOZMIw->( dbSKIP())
    ENDDO
    *
*  ENDIF
RETURN NIL

*
*===============================================================================
FUNCTION SKL_DelMistaULOZ()
  Local nAREA := SELECT()

  IF SysCONFIG( 'Sklady:lMistaULOZ')
    drgDBMS:open('C_ULOZMI')
    drgDBMS:open('PVPUloz' )
    drgDBMS:open('ULOZENI' )

    CreateULOZMIw()           //   CreateMisUl( nKEY)
    SaveMistaUL( xbeK_DEL)    //  SaveToFILEs( nKEY)
    dbSelectAREA( nAREA)
  ENDIF
RETURN Nil