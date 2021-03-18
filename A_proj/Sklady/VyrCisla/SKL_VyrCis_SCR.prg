
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\SKLADY\SKL_Sklady.ch"


* SKL_VyrCis_1_scr ... Výrobní èísla dle skladových položek
********************************************************************************
CLASS SKL_VyrCis_1_scr FROM drgUsrClass, quickFiltrs
EXPORTED:
  VAR     abMembers
  METHOD  ItemMarked, eventHandled

  inline access assign method is_evidvyrCis() var is_evidvyrCis
    local  pa_vyrCis := { 'A', 'B', 'C' }, npos
    local  retVal    := 0

    vyrCis := cenZboz->cvyrCis
    if ( npos := ascan( pa_vyrCis, vyrCis )) <> 0
      retVal := 560 +npos
    endif
  return retVal


  inline method init(parent)
    ::drgUsrClass:init(parent)
  return self


  inline method drgDialogStart(drgDialog)
    local  odesc
    local  pa_it := {}, pa_quick := {{ 'Kompletní ceník zboží    ', ''               }, ;
                                     { 'Položky s výrobními èísly', 'cvyrCis <> " "' }  }

    ::abMembers := drgDialog:oActionBar:Members
     ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )

    * quick pro evideci výrobních èísel
    if isObject( odesc := drgRef:getRef( 'cvyrCis' ))
      pa := listAsArray( odesc:values )

      aeval( pa, {|x| ( pb := listAsArray(x, ':'), aadd( pa_it, {allTrim(pb[1]), allTrim(pb[1]) +' _ ' +pb[2]} ) ) } )
    endif

    aeval( pa_it, { |x| aadd( pa_quick, { x[2], format( 'cvyrCis = "%%"', { x[1] } ) } ) })
    ::quickFiltrs:init( self, pa_quick, 'výrèísla' )
  return self
ENDCLASS



********************************************************************************
METHOD SKL_VYRCIS_1_scr:eventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK := .T.

  DO CASE
    CASE nEvent = drgEVENT_EDIT  .or. nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
      IF EMPTY( CenZBOZ->cVyrCis)
        drgMsgBox(drgNLS:msg( 'U skladové položky není nastavena evidence výrobních èísel !'))
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF
    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_VyrCis_1_scr:ItemMarked()
  Local lOk := ( Upper( CENZBOZ->cVyrCis) = 'C') , x
  *
  VYRCIS->( mh_SetScope( Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)))
  *
  FOR x := 1 TO LEN( ::abMembers)
    IF ::abMembers[x]:event $ 'VYRCIS_INVENTURA'
      * inventura je možná jen pro typ evidence "C"
      IF( lOk, ::abMembers[x]:oXbp:enable(), ::abMembers[x]:oXbp:disable() )

      ::abMembers[x]:oXbp:setColorFG( If( lOk, GraMakeRGBColor({128,128,128}),;
                                               GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT

RETURN SELF


* SKL_VyrCis_2_scr ... Výrobní èísla dle výrobních èísel
********************************************************************************
CLASS SKL_VyrCis_2_scr FROM drgUsrClass

EXPORTED:
  METHOD  Init, ItemMarked, ItemSelected, drgDialogStart, eventHandled
ENDCLASS

********************************************************************************
METHOD SKL_VyrCis_2_scr:init(parent)
  *
  ::drgUsrClass:init(parent)
  drgDBMS:open( 'CENZBOZ')
RETURN self

********************************************************************************
METHOD SKL_VyrCis_2_scr:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  VYRCIS->( DbSetRelation( 'CENZBOZ', { || Upper(VYRCIS->cCisSklad) + Upper( VYRCIS->cSklPol) },;
                                           'Upper(VYRCIS->cCisSklad) + Upper( VYRCIS->cSklPol)',;
                                           'CENIK12'))
RETURN self

********************************************************************************
METHOD SKL_VyrCis_2_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  *
  DO CASE
    CASE nEvent = drgEVENT_APPEND
      RETURN .T.
    CASE nEvent = drgEVENT_DELETE
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD SKL_VyrCis_2_scr:ItemMarked()
  *
  VYRCISV->( mh_SetScope( Upper( VYRCIS->cCisSklad) + Upper( VYRCIS->cSklPol) + Upper(VYRCIS->cVyrobCis) ))
  *
RETURN SELF

********************************************************************************
METHOD SKL_VyrCis_2_scr:ItemSelected()

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_VYRCIS_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN SELF