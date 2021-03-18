#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "Font.ch"
#include "nls.ch"
#include "dll.ch"


#ifndef COLOR_BG_GETFIND
   # define COLOR_BG_GETFIND    GraMakeRGBcolor( { 220, 235, 223 } )
#endif

#ifndef COLOR_BG_TABLA
   # define COLOR_BG_TABLA      GraMakeRGBcolor( { 255, 255, 239 } )
#endif

#ifndef COLOR_BG_CABCALENDA
   # define COLOR_BG_CABCALENDA GraMakeRGBColor( {   0, 220, 255 } )
#endif

#xtrans  PRESPARAM_CAL  => {;
         { XBP_PP_FGCLR                  , GRA_CLR_BLACK                 }, ;
         { XBP_PP_BGCLR                  , COLOR_BG_TABLA                }, ;
         { XBP_PP_COMPOUNDNAME           , '7.Arial'                     }, ;
         { XBP_PP_ALIGNMENT              , XBPALIGN_RIGHT + XBPALIGN_VCENTER }, ;
         { XBP_PP_CGRP_ROWHEIGHT         , 18                            }, ;
         { XBP_PP_CGRP_HILITEFRAMELAYOUT , XBPFRAME_BOX + XBPFRAME_NONE  }, ;
         { XBP_PP_HILITE_FGCLR           , GRA_CLR_BLACK                 }, ;
         { XBP_PP_HILITE_BGCLR           , GRA_CLR_GREEN                 } }


# define TXT_HOY_ES    'Dnes je: '


function clickDate( drgDialog )
  local oxbpGet := drgDialog:lastXbpInFocus
  local oCalend := drgCalendario():new( oxbpGet )

  oCalend:create()
  oCalend:showCalendario()

  _clearEventLoop(.t.)
  SetAppFocus( oxbpGet )

  if oxbpGet:changed
    postAppEvent(xbeP_Keyboard,xbeK_RETURN,,oxbpGet)
  endif
return .t.


class drgCalendario
protected:
   VAR oRect
   VAR oBoton
   VAR nAno, nMes
   VAR nRowHilite, nColHilite, selDate

exported:
  var lCalVisible, cTxtHoyEs, oxbpGet

  inline method init( oxbpGet )

    ::cTxtHoyEs   := TXT_HOY_ES
    ::lCalVisible := .F.
    ::oxbpGet     := oxbpGet
    return self

  INLINE METHOD create()
    RETURN self

   INLINE METHOD getPos( aSize, oxbp_pb )
      LOCAL cBuffer  := Space( 16 )
      LOCAL aSizeDesk:= AppDeskTop():currentSize()
      LOCAL aPosXY

      DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", ::oxbpGet:getHwnd(), @cBuffer )

      aPosXY := { Bin2U( Left( cBuffer, 4 ) ), ;
                  aSizeDesk[ 2 ] - Bin2U( substr( cBuffer, 13, 4 ) ) }

      IF aPosXY[ 2 ] - aSize[ 2 ] > 30
         aPosXY[ 2 ] -= aSize[ 2 ]
      ELSE
         aPosXY[ 2 ] += ::oxbpGet:currentSize()[ 2 ]
      ENDIF
      IF aPosXY[ 1 ] + aSize[ 1 ] > aSizeDesk[ 1 ]
         aPosXY[ 1 ]:= aSizeDesk[ 1 ] - aSize[ 1 ]
      ELSEIF aPosXY[ 1 ] < 0
         aPosXY[ 1 ]:= 0
      ENDIF
   RETURN aPosXY

   INLINE METHOD showCalendario()
      LOCAL oDlg, oDrawing, oXbp, oCal, oMesAno, nColor
      LOCAL nEvent, mp1, mp2, nCont, lContinuar
      LOCAL aSize:= { 180, 189 }

      ::lCalVisible:= .T.

      oDlg:= XbpDialog():new( AppDeskTop(), SetAppWindow(), ::getPos( aSize ), aSize,, .F. )
         oDlg:taskList := .F.
         oDlg:titleBar := .F.
         oDlg:border   := XBPDLG_RAISEDBORDERTHICK_FIXED // XBPDLG_RECESSEDBORDERTHICK_FIXED
         oDlg:drawingArea:setFontCompoundName( '7.Arial' )
         oDlg:drawingArea:clipChildren:= .T.
         oDlg:create()

      oDrawing:= oDlg:drawingArea

      oCal := XbpMultiCellGroup():new( oDrawing,, { 0, 20 }, { 175, 114 } )
         oCal:maxCol := 7
         oCal:maxRow := 6
         oCal:style  := XBP_STYLE_3D
         oCal:create()
         oCal:setColWidth( 25 )
         oCal:setPresParam( PRESPARAM_CAL )
         oCal:itemMarked  := ;
         oCal:itemSelected:= {|aRowCol, unil, obj| lContinuar:= ::_itemMarked( aRowCol, unil, obj ) }
         oCal:keyboard    := {|nKey, unil, obj| lContinuar:= ::_Keyboard( nKey, unil, obj, oMesAno ) }

         FOR nCont := 1 TO 7
            oCal:setAlignment( nCont, XBPALIGN_RIGHT + XBPALIGN_VCENTER )
         NEXT

      oXbp := XbpMultiCellGroup():new( oDrawing,,{ 0, 134 }, { 175, 19 } )
         oXbp:maxCol := 7
         oXbp:maxRow := 1
         oXbp:style  := XBP_STYLE_3D
         oXbp:create()
         oXbp:setColWidth( 25 )
         oXbp:setRowHeight( 18 )

         nColor:= COLOR_BG_CABCALENDA

         FOR nCont := 1 TO 7
            oXbp:setAlignment( nCont, XBPALIGN_HCENTER + XBPALIGN_VCENTER )
            oXbp:setCell( 1, nCont, Upper( SetLocale( NLS_SABBREVDAYNAME1 + nCont - 1 )[ 1 ] ) )
            oXbp:setCellColor( 1, nCont, GRA_CLR_BLACK, nColor )
         NEXT

      oXbp:= XbpStatic():new( oDrawing,, { 0, 0 }, { 174, 20 }, ;
                                 { { XBP_PP_BGCLR, COLOR_BG_GETFIND }, ;
                                   { XBP_PP_FGCLR, GRA_CLR_DARKBLUE } } )
         oXbp:caption:= ::cTxtHoyEs + DTOC( DATE() )
         oXbp:options:= XBPALIGN_HCENTER + XBPALIGN_VCENTER
         oXbp:lbDown := {|| lContinuar:= ::cargaActual() }
         oXbp:create()

      oMesAno:= XbpStatic():new( oDrawing,, { 14, 153 }, { 145, 30 }, ;
                                 { { XBP_PP_COMPOUNDNAME, '7.Arial Bold' }, ;
                                   { XBP_PP_BGCLR, COLOR_BG_GETFIND }, ;
                                   { XBP_PP_FGCLR, GRA_CLR_DARKGREEN } } )
         oMesAno:options     := XBPALIGN_HCENTER + XBPALIGN_VCENTER
         oMesAno:clipChildren:= .T.
         oMesAno:create()

      oXbp:= XbpPushButton():new( oDrawing,, { 0, 153 }, { 14, 15 }, ;
                                  { { XBP_PP_COMPOUNDNAME, '7.Marlett' } } )
         oXbp:caption     := '6'
         oXbp:pointerFocus:= .F.
         oXbp:create()
         oXbp:toolTipText := 'mìsíc -1'
         oXbp:activate:= {|| ::CargaOtroMes( -1, oCal, oMesAno ) }

      oXbp:= XbpPushButton():new( oDrawing,, { 0, 168 }, { 14, 15 }, ;
                                  { { XBP_PP_COMPOUNDNAME, '7.Marlett' } } )
         oXbp:caption     := '5'
         oXbp:pointerFocus:= .F.
         oXbp:create()
         oXbp:toolTipText := 'mìsíc +1'
         oXbp:activate:= {|| ::CargaOtroMes( 1, oCal, oMesAno ) }

      oXbp:= XbpPushButton():new( oDrawing,, { 160, 153 }, { 14, 15 }, ;
                                  { { XBP_PP_COMPOUNDNAME, '7.Marlett' } } )
         oXbp:caption     := '6'
         oXbp:pointerFocus:= .F.
         oXbp:create()
         oXbp:toolTipText := 'rok -1'
         oXbp:activate:= {|| ::CargaOtroAno( -1, oCal, oMesAno ) }

      oXbp:= XbpPushButton():new( oDrawing,, { 160, 168 }, { 14, 15 }, ;
                                  { { XBP_PP_COMPOUNDNAME, '7.Marlett' } } )
         oXbp:caption     := '5'
         oXbp:pointerFocus:= .F.
         oXbp:create()
         oXbp:toolTipText := 'rok +1'
         oXbp:activate:= {|| ::CargaOtroAno( 1, oCal, oMesAno ) }

      ::CargaMes( oCal, oMesAno, IIF( ::oxbpGet:badDate(), Date(), ::oxbpGet:value ) )

      oDlg:setModalState( XBP_DISP_APPMODAL )
      oDlg:show()
      SetAppFocus( oCal )

      lContinuar:= .T.
      nCont     := 0
      ::lCalVisible:= .T.

      DO WHILE lContinuar
         nEvent := AppEvent( @mp1, @mp2, @oXbp )
         IF ( nEvent == xbeM_LbDown .OR. nEvent == xbeM_RbDown ) ;
                  .AND. oXbp:setParent() <> oDrawing
            EXIT
         ELSEIF nEvent == xbeP_Keyboard .AND. mp1 == xbeK_ESC
            EXIT
         ELSEIF ( nEvent = 1048630 .OR. nEvent = 1048631 )   // xbeP_SetDisplayFocus or xbeP_KillDisplayFocus
            IF ++nCont = 4
               EXIT
            ENDIF
         ELSE
            nCont:= 0
         ENDIF
         oXbp:handleEvent( nEvent, mp1, mp2 )
      ENDDO

      oDlg:setModalState( XBP_DISP_MODELESS )
      oDlg:destroy()
      ::lCalVisible:= .F.
   RETURN self

   INLINE METHOD CargaOtroAno( nIncremento, oCal, oMesAno )
      LOCAL cAno := Str( ::nAno + nIncremento, 4 )
      LOCAL nDia := VAL( oCal:getCell( ::nRowHilite, ::nColHilite ) )
      LOCAL dFecha

      DO WHILE EMPTY( dFecha:= Stod( cAno + Str( ::nMes, 2 ) + Padl( nDia, 2 ) ) )
         nDia--
      ENDDO
   RETURN ::cargaMes( oCal, oMesAno, dFecha )

   INLINE METHOD CargaOtroMes( nIncremento, oCal, oMesAno )
      LOCAL nMes:= ::nMes + nIncremento
      LOCAL nAno:= ::nAno
      LOCAL dFecha, nDia

      IF nMes = 13
         nMes:= 1
         nAno++
      ELSEIF nMes = 0
         nMes:= 12
         nAno--
      ENDIF
      nDia:= VAL( oCal:getCell( ::nRowHilite, ::nColHilite ) )
      DO WHILE EMPTY( dFecha:= Stod( Str( nAno, 4 ) + Str( nMes, 2 ) + Padl( nDia, 2 ) ) )
         nDia--
      ENDDO
   RETURN ::cargaMes( oCal, oMesAno, dFecha )

   INLINE METHOD CargaMes( oCal, oMesAno, dFecha )
      LOCAL nPrimeraCol, nDiasMes, nDia
      LOCAL nRow, nCol
      LOCAL nDiaDelMes:= 1

      IF Empty( dFecha )
         dFecha:= Date()
      ENDIF
      ::nAno:= Year( dFecha )
      ::nMes:= Month( dFecha )
      nDia  := Day( dFecha )

      oMesAno:setCaption( Upper( Cmonth( dFecha ) ) + Str( ::nAno, 5 ) )

      nPrimeraCol:= DoW( Stod( Str( ::nAno, 4 ) + str( ::nMes, 2 ) + '01' ) )
      nPrimeraCol:= IIF( nPrimeraCol = 1, 7, nPrimeraCol - 1 )

      nDiasMes:= IIF( ::nMes + 1 = 13, ;
                      Day( Stod( Str( ::nAno + 1, 4 ) + '0101' ) - 1 ), ;
                      Day( Stod( Str( ::nAno, 4 ) + str( ::nMes + 1, 2 ) + '01' ) - 1 ) )

      For nRow := 1 to 6
         For nCol := 1 to 7
            IF nCol + ( nRow - 1 ) * 7 < nPrimeraCol .OR. nDiaDelMes > nDiasMes
               oCal:setCell( nRow, nCol, ' ' )
            ELSE
               oCal:setCell( nRow, nCol, Ltrim( Str( nDiaDelMes, 2 ) ) )
               IF nDiaDelMes = nDia
                  oCal:hiliteCell( nRow, nCol, .T., .F. )
                  ::nRowHilite:= nRow
                  ::nColHilite:= nCol
               ENDIF
               nDiaDelMes++
            ENDIF
         Next nCol
      Next nRow
   RETURN self

   INLINE METHOD _ItemMarked( aRowCol, unil, obj )
      LOCAL cDia:= obj:getCell( aRowCol[ 1 ], aRowCol[ 2 ] )
      LOCAL dFecha

      IF ! EMPTY( cDia )
          obj:hiliteCell( ::nRowHilite, ::nColHilite, .F., .F. )
          obj:hiliteCell( aRowCol[ 1 ], aRowCol[ 2 ], .T., .F. )
          dFecha:= Stod( Str( ::nAno, 4 ) + Padl( ::nMes, 2, '0' ) +  ;
                   Padl( cDia, 2, '0' ) )
          IF dFecha <> ::oxbpGet:value
            ::oxbpGet:setData( dFecha )
            ::oxbpGet:changed  := .T.
          ENDIF
          RETURN .F.
      ENDIF
   RETURN .T.

   INLINE METHOD cargaActual

      IF Date() <> ::oxbpGet:value
        ::oxbpGet:setData( Date() )
        ::oxbpGet:changed  := .T.
      ENDIF
   RETURN .F.

   INLINE METHOD _keyboard( nKey, unil, oCal, oMesAno )
      LOCAL nRow, nCol

      IF nKey = xbeK_RIGHT
         nCol := ::nColHilite + 1
         nRow := ::nRowHilite
      ELSEIF nKey = xbeK_LEFT
         nCol := ::nColHilite - 1
         nRow := ::nRowHilite
      ELSEIF nKey = xbeK_UP
         nCol := ::nColHilite
         nRow := ::nRowHilite - 1
      ELSEIF nKey = xbeK_DOWN
         nCol := ::nColHilite
         nRow := ::nRowHilite + 1
      ELSEIF nKey = xbeK_ENTER
         RETURN ::_ItemMarked( { ::nRowHilite, ::nColHilite }, unil, oCal )
      ELSEIF nKey = xbeK_HOME
         nRow := 1
         nCol := 0
         DO WHILE EMPTY( oCal:getCell( nRow, ++nCol ) )
         ENDDO
      ELSEIF nKey = xbeK_END
         nRow := 6
         nCol := 8
         DO WHILE EMPTY( oCal:getCell( nRow, --nCol ) )
            IF nCol = 1
               nCol:= 8
               nRow--
            ENDIF
         ENDDO
      ELSEIF nKey = xbeK_PGDN
         ::CargaOtroMes( 1, oCal, oMesAno )
         RETURN .T.
      ELSEIF nKey = xbeK_PGUP
         ::CargaOtroMes( -1, oCal, oMesAno )
         RETURN .T.
      ELSE
         RETURN .T.
      ENDIF
      IF nCol > 7
         nCol:= 1
         nRow++
      ELSEIF nCol < 1
         nCol:= 7
         nRow--
      ENDIF

      IF nRow > 0 .AND. nRow < 8 .AND. ! EMPTY( oCal:getCell( nRow, nCol ) )
          oCal:hiliteCell( ::nRowHilite, ::nColHilite, .F., .F. )
          ::nRowHilite:= nRow
          ::nColHilite:= nCol
          oCal:hiliteCell( nRow, nCol, .T., .F. )
      ENDIF
   RETURN .T.
ENDCLASS