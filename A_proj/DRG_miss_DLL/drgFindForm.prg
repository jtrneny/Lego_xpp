#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"

#pragma Library( "XppUI2.lib" )


static function setCursorPos( nX, nY)
  DllCall( "user32.dll", DLL_STDCALL, "SetCursorPos", nX, nY)
return nil

static function getWindowPos(o)
   LOCAL nLeft       := 0
   LOCAL nTop        := 0
   LOCAL nRight      := 0
   LOCAL nBottom     := 0
   LOCAL cBuffer     := Space(16)
   LOCAL aObjPosXY   := {nil,nil}

   DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", o:GetHwnd(), @cBuffer)

   nLeft    := Bin2U(substr(cBuffer,  1, 4))
   nTop     := Bin2U(substr(cBuffer,  5, 4))
   nRight   := Bin2U(substr(cBuffer,  9, 4))
   nBottom  := Bin2U(substr(cBuffer, 13, 4))

   aObjPosXY[1]  := nLeft
   aObjPosXY[2]  := nTop  //AppDeskTop():currentSize()[2] - nBottom
RETURN(aObjPosXY)



*
** CLASS for drgFindDialog *****************************************************
CLASS drgFindDialog from drgUsrClass
EXPORTED:
  var     odBrowse, m_deBrowse
  var     sel_column, sel_value
  var     sea_inAll, sea_onLeft, sea_onRight

  METHOD  init
  METHOD  getForm, postValidate, setFilter, killFilter
  METHOD  destroy

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case (nEvent = xbeP_Selected)
      ::postValidate(oXbp:cargo:oVar, .T., oxbp)
      return .f.

    otherwise
      return .f.
    endCase
  return .T.


  inline method drgDialogStart(drgDialog)
    local  x, members := drgDialog:oActionBar:members

    ::dm               := drgDialog:dataManager             // dataManager
    ::df               := drgDialog:oForm                   // form

    ::odrg_sea_inAll   := ::dm:get( 'M->sea_inAll'  , .f. )
    ::odrg_sea_onLeft  := ::dm:get( 'M->sea_onLeft' , .f. )
    ::odrg_sea_onRight := ::dm:get( 'M->sea_onRight', .f. )

    for x := 1 to len(members) step 1
      if isCharacter( members[x]:event )
        if( members[x]:event = 'setFilter', ::opb_setFilter := members[x], nil)
      endif
    next

    ::opb_setFilter:oxbp:disable()

    ::df:setnextfocus('M->sel_Value',,.t.)
  return self


  inline method comboBoxInit(drgComboBox)
    local  pa_defColum
    local  defCap, defName, defLen, defPict, defType
    local  obro       := ::m_deBrowse:oxbp
    local  acombo_val := {}
    *
    local  ocol, asize, x

    do case
    case( 'sel_column' $ lower(drgComboBox:name) )

      for x := 1 to obro:colCount step 1
        ocol  := obro:getColumn(x)
        asize := ocol:currentSize()

        pa_defColum  := ocol:defColum

          defCap  := pa_defColum.defCap     // záhlaví sloupce
          defName := pa_defColum.defName    // fieldName - var - fce
          defLen  := pa_defColum.defLen     // šíøka sloupce
          defPict := pa_defColum.defPict    // picture
          defType := pa_defColum.defType    // typ sloupce XBPCOL_TYPE_

          cfile   := drgParse( defName, '-')
          citem   := drgParseSecond( defName,'>')

          if isobject(odesc := drgDBMS:getFieldDesc(cfile, citem))
            cdesc := right( odesc:desc, 32)

            aadd( acombo_val, { defName, cdesc, ocol, odesc:type } )
           else
            cdesc := 'Virtuální datová položka'
          endif
      next

      ::pa_comboVal := acombo_Val

      drgComboBox:oXbp:clear()
      drgComboBox:values := acombo_val
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      drgComboBox:value := drgComboBox:ovar:value := obro:getColumn(obro:colPos):defColum[2]
    endcase
  return self

HIDDEN:
  var     dm, df, opb_setFilter, pa_comboVal
  var     odrg_sea_inAll, odrg_sea_onLeft, odrg_sea_onRight

  var     m_parent
ENDCLASS


METHOD drgFindDialog:init(parent)
  LOCAL x

  ::drgUsrClass:init(parent)

  ::dialogIcon  := MIS_ICON_FILTER
  ::dialogTitle := ' Rychlý filtr'

  ::m_parent    := parent:parent
  ::odBrowse    := parent:parent:odBrowse
  ::m_deBrowse  := isNull( parent:cargo_usr, ::m_parent:a_bro_popup[1] )

  ::sel_value   := ''
  ::sea_inAll   := .t.
  ::sea_onLeft  := .f.
  ::sea_onRight := .f.
return self


method drgFindDialog:getForm()
  local drgFC  := drgFormContainer():new(), oDrg
  *
  local pa_txt := { '  Hledaná hodnota obsažena kdekoliv v údaji' , ;
                    '  Hledaná hodnota obsažena zleva'            , ;
                    '  Hledaná hodnota obsažena zprava'             }


  DRGFORM INTO drgFC SIZE 50,8 DTYPE '10' TITLE ' Rychlý filtr' ;
                     GUILOOK 'All:n,Border:Y,Action:y'          ;
                     POST 'postValidate'

  DRGSTATIC INTO drgFC FPOS 1,0.1 SIZE 47,2.5
    odrg:ctype := 2

    DRGTEXT INTO drgFC CAPTION 'Hledat v položce pohledu -->' CPOS 1,0.5 CLEN 15
    DRGCOMBOBOX M->sel_Column INTO drgFC FPOS 16,.6 FLEN 30 VALUES 'a,a,a,a,a,a,a,a'  ;
                              COMBOINIT 'comboBoxInit' ITEMSELECTED 'comboItemSelected'

    DRGGET M->sel_Value       INTO drgFC FPOS 16,1.6 FLEN 29
  DRGEND  INTO drgFC

  DRGCHECKBOX M->sea_inAll   INTO drgFC FPOS 4, 3.3 FLEN 40 VALUES 'T:' +pa_txt[1] +',F:' +pa_txt[1]
  DRGCHECKBOX M->sea_onLeft  INTO drgFC FPOS 4, 4.3 FLEN 40 VALUES 'T:' +pa_txt[2] +',F:' +pa_txt[2]
  DRGCHECKBOX M->sea_onRight INTO drgFC FPOS 4, 5.3 FLEN 40 VALUES 'T:' +pa_txt[3] +',F:' +pa_txt[3]


  DRGACTION INTO drgFC CAPTION 'nastavit ~Filtr' EVENT 'setFilter'   TIPTEXT 'Nastavit rychlý filtr ...'
  DRGACTION INTO drgFC CAPTION 'zrušit ~Filtr'   EVENT 'killFilter' TIPTEXT 'Zrušit rychlý filtr ...'
  DRGACTION INTO drgFC CAPTION      ''           EVENT 'sep'       ATYPE 5
  DRGACTION INTO drgFC CAPTION '~Storno'         EVENT drgEVENT_QUIT TIPTEXT 'Ukonèit dialog ...'
return drgFC



method drgFindDialog:postvalidate(drgVar,lSelected, oxbp)
  Local  lOk  := .T., lValue
  local  name       := Lower(drgVar:name), ;
         field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  it_typSea := 'sea_inall,sea_onleft,sea_onright'
  local  apos_pb, asize_pb, apos

  default lSelected TO .F.

  if lSelected
    do case
    case (field_name $ it_typSea)
      lValue := !drgVar:get()

      ::dm:has('M->sea_inAll'  ):set(.F.)
      ::dm:has('M->sea_onLeft' ):set(.F.)
      ::dm:has('M->sea_onRight'):set(.F.)

      drgVar:set(lValue)
    endcase
  else
    do case
    case field_name = 'sel_value'
      if( empty(drgVar:value), lok := .f., ::opb_setFilter:oxbp:enable() )

      if lok
        apos_pb  := getWindowPos( ::opb_setFilter:oxbp )
        asize_pb := ::opb_setFilter:oxbp:currentSize()
        apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

        setCursorPos( apos[1], apos[2] )
        setAppFocus( ::opb_setFilter:oxbp )
      endif
    endcase
  endif
return lok


method drgFindDialog:setFilter()
  local  sel_Column := ::dm:get( 'M->sel_column' )
  local  sel_Value  := allTrim( ::dm:get( 'M->sel_value'))
  local  pa         := ::pa_comboVal
  *
  local  cfile, cfield_Name, ctype
  local  cField, cCond, contains
  *
  local  ft_APU_cond

  cfile       := drgParse(sel_Column,'-')
  cfield_Name := drgParseSecond(sel_Column, '>')
  ft_APU_cond := ::m_parent:get_APU_filter( cfile, 'apuq')

  if( npos := ascan( pa, { |x| x[1] = sel_Column })) <> 0
    ctype := pa[npos,4]
  endif

  do case
  case ctype = 'C' .or. ctype = 'M'  ;  cField := cfield_Name
  case ctype = 'D'                   ;  cField := "dtos(" +cfield_Name +")"
  case ctype = 'N'                   ;  cField := "str("  +cfield_Name +")"
  endcase

  if .not. empty(cField)
    do case
    case ::odrg_sea_inAll:value      ;  cCond := "*" +sel_Value +'*'
    case ::odrg_sea_onLeft:value     ;  cCond :=      sel_Value +'*'
    otherwise                        ;  cCond := "*" +sel_Value
    endcase

    if empty(ft_APU_cond)
      cCond := 'contains( ' +cField + ', "' +cCond +'" )'
    else
      cCond := ft_APU_cond +' .and. contains( ' +cField + ', "' +cCond +'" )'
    endif

    (cfile)->( ads_setAof( cCond ), dbgoTop() )

    postAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return self


method drgFindDialog:killFilter()

  PostAppEvent(drgEVENT_ACTION, misEVENT_KILLFILTER,'0',::drgDialog:dialog)
  postAppEvent(xbeP_Close,,,::drgDialog:dialog)
return self



*************************************************************************
* CleanUP
*************************************************************************
METHOD drgFindDialog:destroy()
  ::drgUsrClass:destroy()
RETURN self