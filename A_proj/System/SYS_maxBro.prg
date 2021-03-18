#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"

********************************************************************************
CLASS SYS_maxBRO FROM drgUsrClass
EXPORTED:
  VAR    cFile, aFields
  METHOD init, destroy, drgDialogStart, getForm, eventHandled

HIDDEN
  VAR    cScoTop, cScoBot, cFilter, cTag, nRecno
  VAR    bro
ENDCLASS

********************************************************************************
METHOD SYS_maxBRO:init(parent)
  *
  ::cFile   := parent:cargo_usr[1]
  ::cTag    := parent:cargo_usr[2]
  ::nRecNo  := parent:cargo_usr[3]
  ::cScoTop := parent:cargo_usr[4]
  ::cScoBot := parent:cargo_usr[5]
  ::cFilter := parent:cargo_usr[6]
  *
  ::aFields := (::cFile)->( dbStruct())
RETURN self

********************************************************************************
METHOD SYS_maxBRO:destroy()
*  ::drgUsrClass:destroy()
  ::cFile := ::aFields := ;
  ::cScoTop := ::cScoBot := ::cFilter := ::cTag := ::nRecno := ::bro := ;
  Nil
RETURN self

********************************************************************************
METHOD SYS_maxBRO:drgDialogStart(drgDialog)
  local  x, nPos, ocolumn
  local  cfield, cfoot, nin
  *
  nPos  := Ascan( drgDialog:dialogCtrl:oBrowse, {|x| x:cFile = ::cFile} )
  ::bro := drgDialog:dialogCtrl:oBrowse[nPos]
  *
  FOR x := 1 TO ::bro:oxbp:colCount step 1
    ocolumn := ::bro:oXbp:getColumn(x)
    ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := GraMakeRGBColor( {200 ,255, 200} ) // GraMakeRGBColor( {220, 220, 250}) //  // GraMakeRGBColor( {255, 255, 200} )
    ocolumn:configure()
    *
    cfield := drgParseSecond( ocolumn:defColum[2], '>' )
    cfoot  := ''

    if ( nin :=  ascan( ::afields, { |i| upper(i[1]) = upper(cfield) } ) ) <> 0
      cfoot := ::afields[nin,1]
    endif

    ocolumn:Footing:hide()
    ocolumn:Footing:setCell(1, lower(cfoot) )
    ocolumn:Footing:show()
  NEXT
  *
  (::cFile)->( AdsSetOrder( ::cTag))
  If( !Empty( ::cScoTop), (::cFile)->( dbSetScope( SCOPE_TOP    , ::cScoTop )), Nil )
  If( !Empty( ::cScoBot), (::cFile)->( dbSetScope( SCOPE_BOTTOM , ::cScoBot )), Nil )
  If( !Empty( ::cFilter), (::cFile)->( Ads_SetAOF( ::cFilter ))   , Nil )
  (::cFile)->( dbGoTO( ::nRecNo))
  *
  ::bro:oXbp:refreshAll()
RETURN self

**********************************************************************
METHOD SYS_maxBRO:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = xbeP_Keyboard
      DO CASE
        CASE mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,,, oXbp)
        OTHERWISE
          Return .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD SYS_maxBRO:getForm()
  Local  oDrg, drgFC
  Local  cTitle := AllTrim( drgDBMS:getDBD(::cFile):description) + ' - ' + Upper(::cFile)
  Local  cFields := '', x

  * T       - timeStamp neumíme zobrazit
  * _NSIDOR - není v popisu DBD, je pøidán do jen do struktury TMP
  **
  for x := 1 to len( ::aFields) step 1
    do case
    case ::aFields[x,2]        = 'T'       .or. ;
         upper(::aFields[x,1]) = '_NSIDOR'
    otherwise
      cFields += ::aFields[x,1] +','
    endcase
  next

** 21.11.2012 js  aEval( ::aFields, {|x| if( x[2] = 'T', nil, cFields += x[1]+',' ) })
  cFields := Left( cFields, len(cFields)-1 )

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 120,24 DTYPE '10' TITLE cTitle ;
                                            GUILOOK 'All:N,IconBar:y:drgStdBrowseIconBar,Border:Y'

  DRGDBROWSE INTO drgFC  SIZE 120,24 FILE ::cFile INDEXORD 1 ;
    FIELDS cFields ;
    SCROLL 'yy' CURSORMODE 3 PP 7 RESIZE 'yy' POPUP 'y' FOOTER 'y'

RETURN drgFC