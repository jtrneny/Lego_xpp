***************************************************************************
*   SKL_OBDOBI                                           DOS... OBDOBI.PRG
***************************************************************************
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"

# Define   ULOHA     'S'

* Kontrola na systémové období
*******************************************************************************
Function UcetSysObd( cObd, lValid)
  Local lRetVal := .t.
  Local cTag := UcetSys->( OrdSetFocus( 2))
  Local cKey := Upper( ULOHA + cObd )
  Local nAutKonSkl := SysConfig( 'Sklady:nAutKonSkl')

  Default lValid To FALSE

BEGIN SEQUENCE
  If UcetSys->( dbSeek( cKey) )
    If UcetSys->lZavren
       MsgBOX( 'Úèetní období < ' + OBD_5TO7( UcetSys->cObdobi) + ' > je již uzavøené',;
               'a nelze v nìm již provádìt zmìny ! )
       lRetVal := lValid
     EndIf
  Else
    // Kontrola na èasovou posloupnost období
    lRetVal := NewObdIsOK()
    If !lRetVal
Break
    Endif
    // Založení nového období
    If Box_Alert( cQM, { 'Zadan‚ £Ÿetn¡ obdob¡ < ' + OBD_5TO7( cObd) + ' > dosud neexistuje !',;
                        'Zalo§it je ?' }, acNOYES, 'R/W*, GR+/R' ) == 2
      If AddRec( 'UcetSys')
        UcetSys_New( cObd, ULOHA) // Zalo§en¡ nov‚ho obdob¡
        DCrUnlock( 'UcetSys')
        UcetSys_UCT( cObd)        // Zalo§en¡ nov‚ho obdob¡ v éŸetnictv¡, pokud neexistuje
        StoreObd( cObd)           // Ulo§en¡ nov‚ho obdob¡
        ControlSCR( , 3 )
        /*/Ä Kontroly dle nastaven¡ v CFG
        If nAutKonSkl == 1 .or. nAutKonSkl == 5
          KoncStavy( nAutKonSkl)
        Endif
        If nAutKonSkl == 3 .or. nAutKonSkl == 5 .or. nAutKonSkl == 7
          KumulCMP( nAutKonSkl)
        Endif
        */
        PVPKumul_New( cObd)       //ÄZalo§en¡ kumulativn¡ch z tnam… pro nov‚ obd.
      EndIf
    Else
     lRetVal := NO
    EndIf
  EndIf
END SEQUENCE
  UcetSys->( OrdSetFocus( cTag))
Return( lRetVal)

* Kontrola zda položka dokladu již prošla uzávìrkou ISOZu
*******************************************************************************
FUNCTIN PVPItem_Uzv( lMessage)
  Local lRetVal := .f.
  Local cDenik, cKey

  Default lMessage  To .T.
  Default cDenik    To PadR( SysConfig( 'Sklady:cDenik'), 2 )
  cKey := Upper( cDenik ) + StrZero( PVPItem->nDoklad, 10) + StrZero( PVPItem->nOrdItem)
  FOrdRec( { 'UcetPol, 1'})
  SetScope( 'UcetPol', cKey )
  Do While !UcetPol->( Eof())
    lRetVal := If( UcetPol->cUzavreni <> ' ', .t., lRetVal )
    UcetPol->( dbSkip())
  EndDo
  If lMessage .and. lRetVal
    Box_Alert( '!!!    N E L Z E    !!!'  ,;
               'Polo§ka dokladu ji§ proçla uz vØrkou ! ',;
                acWAIT, 'R/W*, GR+/R' )
  Endif
  ClrScope( 'UcetPol')
  FOrdRec()
Return( lRetVal)

* Kontrola zda doklad ji§ proçel uz vØrkou ISOZu
*******************************************************************************
FUNCTION PVPHead_Uzv( lMessage)
  Local lRetVal := .f.
  Local nRecItem := PVPItem->( RecNo())

  Default lMessage To .T.
  PVPItem->( dbEval( { || lRetVal := If( PVPItem_Uzv( .F.), .t., lRetVal) } ))
  If lMessage .and. lRetVal
     Box_Alert( '!!!    N E L Z E    !!!',;
                'Polo§ky dokladu ji§ proçly uz vØrkou ! ',;
                acWAIT, 'R/W*, GR+/R' )
  Endif
  PVPItem->( dbGoTo( nRecItem))
Return( lRetVal)

* ÄÄÄ³
*******************************************************************************
Function RightObd( cAlias)
  Local cObd    := StoreObd()  //StackVar( PB_Obdobi)
  Local lRetVal := ( ( cAlias)->cObdPoh == cObd )

  If !lRetval
    Box_Alert( '!!!  N E L Z E  !!!',;
              { 'Doklad spad  do obdob¡   <' + OBD_5TO7( ( cAlias)->cObdPoh) + '> ,',;
                'avçak aktu ln¡ obdob¡ je <' + OBD_5TO7( cObd) + '>  !' },;
                acWAIT, 'R/W*, GR+/R'  )
  Endif
Return( lRetVal)

* Kontrola, zda uživatel pracuje s dokladem své èíselné øady
*******************************************************************************
Function RightDOKL()
  Local lOK := NO, nRange
  Local lRangePVP := SysConfig( 'Sklady:lRangePVP')

  If lRangePVP
    nRange := IIf( PVPHead->nTypPoh == 1, SysConfig( 'Sklady:nRangePrij'),;
               IIf( PVPHead->nTypPoh == 2, SysConfig( 'Sklady:nRangeVyde'),;
                IIf( PVPHead->nTypPoh == 3, SysConfig( 'Sklady:nRangePrev'), Nil)))
  Else
    nRange  := SysConfig( 'Sklady:nRangePrij')
  Endif
  lOK := ( PVPHead->nDoklad >= nRange[ 1] .and. PVPHead->nDoklad <= nRange[ 2])
  If !lOK
    Box_Alert( cEM, 'Doklad spad  do Ÿ¡seln‚ ýady jin‚ho u§ivatele !', acWAIT)
  Endif
Return lOK

* Z sobn¡k promØnnìch
*******************************************************************************
Function StackVar( nPublic, xValue)
  Local   xRetVal
  Static  PB_STACK
  Default PB_STACK To { '     ', '   ', .t., .t., .f. }

  xRetVal := If( xValue != Nil,;
                 PB_STACK[ nPublic] := xValue , PB_STACK[ nPublic] )
Return( xRetVal )
