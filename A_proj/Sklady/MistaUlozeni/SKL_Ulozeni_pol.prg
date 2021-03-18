#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "gra.ch"
#include "..\SKLADY\SKL_Sklady.ch"


FUNCTION NazevMist()
  C_UlozMi->( dbSEEK( Upper( ULOZENIw->cUlozZbo),,'C_ULOZM2'))
RETURN C_UlozMi->cNazevMist


FUNCTION NazevPOH()
  Local cNazev := Space( 25)
  IF PVPUloz->nCislPoh <> 0
    C_DrPohy->( dbSEEK( PVPUloz->nCislPOH,,'C_DRPOH1'))
    cNazev := C_DrPohy->cNazevPoh
  ELSE
    cNazev := IF( PVPUloz->( EOF()), cNazev, PADC('... OPRAVA ...', 25) )
  ENDIF
RETURN cNazev



* Pøehled o místech uložení skladové položky
********************************************************************************
CLASS SKL_Ulozeni_POL FROM drgUsrClass
EXPORTED:
  VAR     nPocStav, nUlozMnoz, nUlozCelk, nUlozMnozPVP
  VAR     cWarning

  METHOD  Init
  METHOD  Destroy
  METHOD  drgDialogStart
  METHOD  ItemMarked
  METHOD  CreateULOZENIw
  METHOD  PostValidate

  METHOD  Prepocet_SKLPOL        // Pøepoèet skladové položky
  METHOD  Prepocet_SKLAD         // Pøepoèet celého skladu
  METHOD  Prepocet               //
  METHOD  DoSave                 // Uloží místa uložení

  inline access assign method nazevMist() var nazevMist
    local cky := upper( ulozeni->culozZbo)
    c_ulozMi->( dbseek(cky,,'C_ULOZM1'))
  return c_ulozMi->cnazevMist

  INLINE ACCESS ASSIGN METHOD typPoh VAR typPoh
  RETURN IF(PVPUloz->nTypPoh = 1, 304, 305 )

  inline method eBro_saveEditRow(o_eBro)
    ulozeni->ccisSklad := cenZboz->ccisSklad
    ulozeni->csklPol   := cenZboz->csklPol
    return .t.


HIDDEN
  VAR     dm, brow

  inline method sumColumn()
    local  recNo := ulozeni->( recNo())
    local  pa, x, sumCol

    pa := { { 'ulozeni->npocStav' , 0 }, ;
            { 'ulozeni->nulozMnoz', 0 }, ;
            { 'ulozeni->nulozCelk', 0 }  }

    ulozeni->( dbeval( { || pa[1,2] += ulozeni->npocStav , ;
                            pa[2,2] += ulozeni->nulozMnoz, ;
                            pa[3,2] += ulozeni->nulozCelk  } ), ;
               dbgoTo( recNo )                                  )

    for x := 1 to len(pa) step 1
      sumCol := ::brow[1]:getColumn_byName( pa[x,1] )
      sumCol:Footing:hide()
      sumCol:Footing:setCell(1, pa[x,2])
      sumCol:Footing:show()
    next
  return self

ENDCLASS


method SKL_ulozeni_POL:init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('c_ulozMi')
  drgDBMS:open('ulozeni' )
  drgDBMS:open('pvpItem' )


*** ven
  drgDBMS:open('pvpUloz' )
  drgDBMS:open('ULOZENIw'  ,.T.,.T.,drgINI:dir_USERfitm)
  ULOZENIw->( dbZAP())
  *
  ::nPocStav := ::nUlozMnoz := ::nUlozCelk := ::nUlozMnozPVP := 0.00
  ::cWarning := ''
return self

*
********************************************************************************
METHOD SKL_Ulozeni_POL:drgDialogStart(drgDialog)
  Local cScope := Upper( CenZBOZ->cCisSklad) + Upper( CenZBOZ->cSklPol), cKey
  Local n, oColumn
  Local members := drgDialog:oActionBar:Members
  *
  local cf := "ccisSklad = '%%' and csklPol = '%%'", cfilter


  ::dm   := drgDialog:dataManager
  ::brow := drgDialog:dialogCtrl:oBrowse  // [1]:oXbp
  *
  FOR n:= 1 TO LEN( members)
    IF members[n]:event = 'SEPARATOR'
      members[n]:oXbp:visible := .F.
      members[n]:oXbp:configure()
     ENDIF
  NEXT

  ** filtr na ulozeni.ccisSklad, ulozeni.csklPol
  cfilter := format( cf, { cenZboz->ccisSklad, cenZboz->csklPol })
  ulozeni->( ads_setAof(cfilter), dbgoTop())
  *
  ::CreateULOZENIw()
  *
  ::dm:has('CenZboz->cCisSklad' ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {220, 220, 250} ))
  ::dm:has('C_SKLADY->cNazSklad'):oDrg:oXbp:setColorBG( GraMakeRGBColor( {220, 220, 250} ))
  ::dm:has('CenZboz->cSklPol'   ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {220, 220, 250} ))
  ::dm:has('CenZboz->cNazZbo'   ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {220, 220, 250} ))
  ::dm:has('CenZboz->nMnozSZBO' ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {255, 255, 200} ))
  *
*  ::dm:has('M->nPocStav' ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {255, 255, 200} ))
  ::dm:has('M->nUlozCelk'):oDrg:oXbp:setColorBG( GraMakeRGBColor( {255, 255, 200} ))
  ::dm:has('M->cWarning' ):oDrg:oXbp:setColorFG( GRA_CLR_RED)
  *
  ::itemMarked()
  ::sumColumn()
  ::brow[1]:oXbp:goTop():refreshAll()
  SetAppFocus( ::brow[1]:oXbp)
RETURN self

*
********************************************************************************
METHOD SKL_Ulozeni_POL:ItemMarked()
  Local cScope := Upper( ULOZENIw->cCisSklad) + Upper( ULOZENIw->cSklPol) + ;
                  Upper( ULOZENIw->cUlozZbo)

  PVPULOZ->( mh_SetScope( cScope))
  *
  ::nUlozMnozPVP := 0.00
  PVPUloz->( dbEVAL( {|| ::nUlozMnozPVP += PVPUloz->nUlozMnoz * PVPUloz->nTypPoh }))
  PVPUloz->( dbGoTop())
  ::brow[2]:oXbp:refreshAll()
  ::dm:refresh()
  *
RETURN SELF

*
********************************************************************************
METHOD SKL_Ulozeni_POL:destroy()
  ::drgUsrClass:destroy()
  *
  ::nPocStav := ::nUlozMnoz := ::nUlozCelk := ::nUlozMnoz :=  ;
  ::cWarning := ;
                NIL

  ulozeni->( ads_clearAof())
RETURN self


*
********************************************************************************
METHOD SKL_Ulozeni_POL:CreateULOZENIw()
  Local cKey

  ULOZENIw->( dbZAP())
  C_UlozMi->( AdsSetOrder(1), mh_SetSCOPE( Upper( CenZBOZ->cCisSklad)) )
  DO WHILE !C_UlozMi->( EOF())
    mh_COPYFLD( 'C_UlozMi', 'ULOZENIw', .T.)
    ULOZENIw->cSklPol := CenZboz->cSklPol
    cKey := Upper( ULOZENIw->cCisSklad) + Upper( ULOZENIw->cSklPol) + ;
            Upper( ULOZENIw->cUlozZBO )
    IF ULOZENI->( dbSEEK( cKey))
      mh_COPYFLD( 'ULOZENI', 'ULOZENIw' )
    ENDIF
    C_UlozMi->( dbSkip())
  ENDDO
  ULOZENIw->( dbGoTOP())
  C_UlozMi->( mh_ClrSCOPE(), dbGoTOP() )

RETURN self

*
********************************************************************************
/*
METHOD SKL_Ulozeni_POL:sumColumn( lValid)
  Local nRec := Ulozeniw->( RecNo()), value, cText := '', lOK := .T.

  DEFAULT lValid TO .F.
  ::nPocStav := ::nUlozMnoz := ::nUlozCelk := 0.00
  Ulozeniw->(DbGoTop())
  ULOZENIw->( dbEVAL( {|| ::nPocStav  += Ulozeniw->nPocStav   ,;
                          ::nUlozMnoz += Ulozeniw->nUlozMnoz  ,;
                          ::nUlozCelk += Ulozeniw->nUlozCelk } ))
  Ulozeniw->( dbGoTO( nRec))
  *
  cText := IIF( ::nUlozCelk > CenZBOZ->nMnozSZBO, 'VÍCE',;
           IIF( ::nUlozCelk < CenZBOZ->nMnozSZBO, 'MÉNÌ', cText ))
  ::cWarning := IF( EMPTY( cText), '', '<>  skladového množství  !')
  IF lValid
    IF !( lOK := EMPTY( cText) )
      drgMsgBox(drgNLS:msg( 'Na místech uložení je uloženo  &  než je aktuální skladové množství', cText))
    ENDIF
  ENDIF
RETURN lOK
*/

method SKL_ulozeni_POL:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  ok     := .t., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  if( IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  if ( isNumber(value) .and. .not. ( value >= 0 ) )
    ok := .f.
    drgMsgBox(drgNLS:msg( 'Množství musí být kladné ...'))
  endif

*  IF ok .and. changed
*    &name := value
*    ::sumColumn()
*    ::drgDialog:dataManager:refresh()
*  ENDIF
RETURN ok

*
********************************************************************************
METHOD SKL_Ulozeni_POL:DoSave()
  LOCAL nRec := ULOZENIw->( RecNO())
  LOCAL lOK := ::SumColumn( .T.)

  IF lOK
    ULOZENIw->( dbEVAL( {|| SaveULOZ() }))
    ULOZENIw->( dbGoTo( nREC))
    drgMsgBox(drgNLS:msg( 'Zápis na místa uložení proveden !'))
  ENDIF
RETURN self

*
*===============================================================================
STATIC FUNC SaveULOZ()
  Local cKey := Upper( ULOZENIw->cCisSklad) + Upper( ULOZENIw->cSklPol) + ;
                Upper( ULOZENIw->cUlozZBO)
  Local nMnOprava := ULOZENIw->nUlozCELK - ULOZENIw->nPocSTAV - Ulozeni->nUlozMnoz

  IF Ulozeni->( dbSEEK( cKey))
     IF  ULOZENIw->nPocStav  <> Ulozeni->nPocStav  .OR.  ;
         ULOZENIw->nUlozMnoz <> Ulozeni->nUlozMnoz .OR.  ;
         ULOZENIw->nUlozCELK <> Ulozeni->nUlozCELK
         IF ReplREC( 'ULOZENI')
            mh_COPYFLD( 'ULOZENIw', 'ULOZENI')
            ULOZENI->( dbUnlock())
         ENDIF
     ENDIF
  ELSE
     IF ULOZENIw->nPocStav <> 0 .OR. ULOZENIw->nUlozCELK <> 0
        IF AddREC( 'ULOZENI')
           mh_COPYFLD( 'ULOZENIw', 'ULOZENI')
           ULOZENI->( dbUnlock())
        ENDIF
     ENDIF
  ENDIF
  IF nMnOprava <> 0
     IF AddRec( 'PVPUloz')
        mh_COPYFLD( 'ULOZENI', 'PVPUloz')
        PVPUloz->nUlozMnoz := ABS( nMnOprava)
        PVPUloz->nTypPoh   := IF( nMnOprava > 0, 1, -1)
        PVPUloz->( dbUnlock())
     ENDIF
  ENDIF
RETURN Nil

*
********************************************************************************
METHOD SKL_Ulozeni_POL:Prepocet_SKLPOL()
*  MsgBOX( 'Cenik_MISTAULOZ ... Pøepoèet skladové položky ')
  ::Prepocet( .F.)
RETURN self

*
********************************************************************************
METHOD SKL_Ulozeni_POL:Prepocet_SKLAD()
*  MsgBOX( 'Cenik_MISTAULOZ ... Pøepoèet celého skladu')
  ::Prepocet( .T.)
RETURN self

* Pøepoèet skl. položky / celého skladu
********************************************************************************
METHOD SKL_Ulozeni_POL:Prepocet( lSklad)
  Local cKey
  Local nRecCEN := CenZBOZ->( RecNO())
  Local nREC := Ulozeni->( RecNO()), nCount := 1, nRecCount
  Local nUlozCELK := 0, nUlozSUMA := 0
  Local msg := ::drgDialog:oMessageBar, cC := MIS_ICON_APPEND
  Local  cText := IF( lSKLAD, 'CENÍK ZBOŽÍ', 'SKLADOVÁ POLOŽKA')

  msg:WriteMessage( cText + ' - Probíhá pøepoèet stavù na místech uložení', DRG_MSG_INFO)
  IF( lSKLAD, Ulozeni->( mh_ClrScope()), NIL )
  nRecCount := dbCOUNT( 'Ulozeni')
  Ulozeni->( dbGoTOP())
  cKey := Upper( Ulozeni->cCisSklad) + Upper( Ulozeni->cSklPol)

  DO WHILE !Ulozeni->( EOF())

    PVPUloz->( mh_SetSCOPE( cKEY + Upper( Ulozeni->cUlozZBO)))
      nUlozCELK := SklPolCMP()
    PVPUloz->( mh_ClrSCOPE(), dbGoTOP())
    Ulozeni->( dbSKIP())
    nCount++
    *
    IF (( nCount % 200 ) == 0)
      cC := IF( cC == MIS_ICON_APPEND, MIS_ICON_QUIT, MIS_ICON_APPEND)
      msg:picStatus:setCaption( cC)
      msg:picStatus:show()
    ENDIF

    nUlozSUMA += nUlozCELK
    * Aktualizace CenZboz
    IF cKey <> Upper( Ulozeni->cCisSklad) + Upper( Ulozeni->cSklPol)
       IF CenZboz->( dbSEEK( cKey,,'CENIK03'))
          IF ReplREC( 'CenZboz')
             CenZboz->nUlozCELK := nUlozSUMA
             CenZboz->( dbUnlock())
          ENDIF
       ENDIF
       cKey := Upper( Ulozeni->cCisSklad) + Upper( Ulozeni->cSklPol)
       nUlozSUMA := 0
    ENDIF

  ENDDO

  CenZboz->( dbGoTO( nRecCEN))
  IF lSKLAD
     Ulozeni->( mh_SetScope( Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)))
  ENDIF
  Ulozeni->( dbGoTO( nREC))
  *
  ::CreateULOZENIw()
  ::itemMarked()
  ::sumColumn()
  ::brow[1]:oXbp:refreshAll()
  SetAppFocus( ::brow[1]:oXbp)

  *
  msg:WriteMessage( cText + ' - pøepoèet ukonèen ... ', DRG_MSG_WARNING)
  INKEY(5)
  msg:WriteMessage(,0)
RETURN Nil

*
*-------------------------------------------------------------------------------
STATIC FUNCTION SklPolCMP()
  Local nUlozMnoz := 0

  PVPUloz->( dbEVAL( {|| nUlozMnoz += PVPUloz->nUlozMnoz * PVPUloz->nTypPoh}))
  IF ReplREC( 'Ulozeni')
    Ulozeni->nUlozMnoz := nUlozMnoz
    Ulozeni->nUlozCELK := Ulozeni->nPocStav + nUlozMnoz
    Ulozeni->( dbUnlock())
  ENDIF
RETURN( Ulozeni->nUlozCELK)