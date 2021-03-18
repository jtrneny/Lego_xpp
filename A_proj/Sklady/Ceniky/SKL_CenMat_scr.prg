#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
*
********************************************************************************
CLASS SKL_CenaMat_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, drgDialogStart, EventHandled, ItemMarked
  METHOD  postvalidate, ebro_afterAppend, ebro_afterAppendBlankRec, ebro_saveEditRow

HIDDEN:
  VAR     dm
ENDCLASS

********************************************************************************
METHOD SKL_CenaMat_SCR:Init(parent)
  ::drgUsrClass:init(parent)
  *
RETURN self

*******************************************************************************
METHOD SKL_CenaMat_SCR:drgDialogStart(drgDialog)

  ::dm := drgDialog:dataManager
RETURN self

********************************************************************************
METHOD SKL_CenaMat_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  local cFile, aCenaMat := {}, lOk, cMsg

  DO CASE
  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_DELETE
    cFile := oXbp:cargo:cFile
    cMsg  := if( cFile = 'CenaMat', 'Zrušit cenu materiálové položky ?',;
                                    'Zrušit materiálovou položku a její ceny ?' )
    if drgIsYESNO(drgNLS:msg( cMsg))
      if cFile = 'CenaMat'
        if CenaMat->( dbRlock())
           CenaMat->( dbDelete(), dbUnlock())
        endif
      elseif cFile = 'c_MatPol'
        CenaMat->( dbGoTop(),;
                   dbEval({|| aadd( aCenaMat, CenaMat->( RecNo()) )}),;
                   dbGoTop() )
        lOk := ( c_MatPol->( RLock()) .and. if( Len( aCenaMat) = 0, .t., CenaMat->( sx_RLock( aCenaMat))))
        if lOk
          aEval( aCenaMat, {|nRec| CenaMAT->( dbGoTo( nRec),;
                                   CenaMAT->(dbDelete())  )})
          C_MATPOL->(dbDelete())
        endif
        CenaMAT->(dbUnlock())
        C_MATPOL->(dbUnlock())
      endif
      oXbp:refreshAll()
      ::itemMarked()
    endif
     *  CASE nEvent = xbeP_Keyboard
  OTHERWISE
    RETURN .F.
  ENDCASE
 RETURN .T.

********************************************************************************
METHOD SKL_CenaMat_SCR:ItemMarked()
  local cFilter := "Upper(cZkrMat) = '%%'"

  cFilter := Format( cFilter, { upper(C_MATPOL->cZkrMat)})
  CenaMAT->( mh_SetFilter( cFilter))
RETURN SELF

********************************************************************************
METHOD SKL_CenaMat_SCR:ebro_afterAppend( ebro)
  if ebro:cFile = 'CenaMAT'
    ::dm:set( 'CenaMat->cZkratMeny', SysCONFIG('Finance:cZaklMena'))
  endif
RETURN self

********************************************************************************
METHOD SKL_CenaMat_SCR:ebro_afterAppendBlankRec(eBro)
  if ebro:cFile = 'CenaMAT'
    CenaMAT->cZkrMAT   := C_MATPOL->cZkrMAT
  endif
return .t.

********************************************************************************
METHOD SKL_CenaMat_SCR:postValidate(drgVar)
  LOCAL  value := drgVar:get()
  LOCAL  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  lOK   := .T., lPrep := .f., changed := drgVAR:changed()
  local  nKoef, nCenMatZM, dDatum, nkurzStred, nmnozPrep, aKurz

  dDatum    := ::dm:get('CenaMat->dDatum')
  nCenMatZM := ::dm:get('CenaMat->nCenMatZM')
  nkurzStred := ::dm:get( 'CenaMat->nKurZahMen')
  nmnozPrep  := ::dm:get( 'CenaMat->nMnozPrep' )
  *
  do case
  case( name = 'CenaMat->czkratmenz') .and. changed
    aKurz := LastKurz( value, dDatum)
    ::dm:set( 'CenaMat->nKurZahMen', if( aKurz[ 2] = 0, nkurzStred, if( nkurzStred= 0, aKurz[2], nkurzStred) ))
    ::dm:set( 'CenaMat->nMnozPrep' , if( aKurz[ 1] = 0, nmnozPrep,  if( nmnozPrep = 0, aKurz[1], nmnozPrep) ))

  case name = 'CenaMat->nCenMatZM' .or. name = 'CenaMat->nKurZahMen' .or. name = 'CenaMat->nMnozPrep'
    nKoef := (nkurzStred / nmnozprep)
    ::dm:set('CenaMat->nCenCnMat', nCenMatZM * nKoef )

  case name = 'CenaMat->ncencnmat'
    lOk := ControlDue( drgVar, .t. )
  endcase
  /*
  if lPrep
    aKurz := LastKurz( cZahrMena, dDatum)
    nkurzStred := aKurz[2]   // kurzit->nkurzStred
    nmnozPrep  := aKurz[1]   //kurzit->nmnozPrep
    nKoef := (nkurzStred / nmnozprep)
    ::dm:set('CenaMat->nCenCnMat', nCenMatZM * nKoef )
  endif
  */
RETURN lOK

********************************************************************************
METHOD SKL_CenaMat_SCR:ebro_saveEditRow
  ::dm:save()
RETURN .T.