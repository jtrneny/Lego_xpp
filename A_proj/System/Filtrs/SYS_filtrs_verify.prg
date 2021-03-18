#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"

#pragma Library( "XppUI2.LIB" )


*
** CLASS for SYS_filtrs_TST ****************************************************
CLASS SYS_filtrs_verify FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogStart

HIDDEN:
  VAR  msg, dm, dc, df, ab, brow
  VAR  aeditS, inedit, postBlock


ENDCLASS


method SYS_filtrs_verify:init(parent)
  ::drgUsrClass:init(parent)

return self


method SYS_filtrs_verify:getForm()
  LOCAL drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 100,20 DTYPE '10' TITLE 'Uživatelské filtry' ;
                     GUILOOK 'All:N,Border:Y' BORDER 4                 ;
                     PRE 'preValidate' POST 'postValidate'

* Browser _filtritw
  DRGEBROWSE INTO drgFC FPOS 0,10.2 SIZE 100,8 FILE 'FILTRITw'             ;
    FIELDS 'CLGATE_1,'       + ;
           'CLGATE_2,'       + ;
           'CLGATE_3,'       + ;
           'CLGATE_4,'       + ;
           'CVYRAZ_1u:výraz:32,'       + ;
           'CRELACE:relace,' + ;
           'CVYRAZ_2u:výraz:32:::GET,' + ;
           'CRGATE_1,'       + ;
           'CRGATE_2,'       + ;
           'CRGATE_3,'       + ;
           'CRGATE_4,'       + ;
           'COPERAND:oper'     ;
            SCROLL 'ny' CURSORMODE 3 PP 7

  DRGPushButton INTO drgFC POS 78,18.7 SIZE 10,1.2 CAPTION 'OK'     EVENT 'runFiltrs' ICON1 101 ICON2 201 ATYPE 3
  DRGPushButton INTO drgFC POS 89,18.7 SIZE 10,1.2 CAPTION 'Cancel' EVENT drgEVENT_QUIT ICON1 102 ICON2 202 ATYPE 3
return drgFC


method SYS_filtrs_verify:drgDialogStart(drgDialog)
  local  aMembers := drgDialog:oForm:aMembers
  local  ocolumn, x, pa, pos
/*
  ::inedit  := .f.
  ::aeditS := {}
  ::postBlock := drgDialog:getMethod('postLastField')

  for x := 1 to len(aMembers) step 1
    if     aMembers[x]:ClassName() = 'drgDBrowse'
      ::brow := aMembers[x]:oXbp
    elseif aMembers[x]:ClassName() = 'drgGet'
      aadd(::aeditS, { NIL                                                       , ;
                       aMembers[x]                                               , ;
                       Val(aMembers[x]:groups)                                   , ;
                       if(isobject(amembers[x]:pushGet),amembers[x]:pushGet,nil) } )
    endif
  next

  *
  pa := ::aeditS
  for x := 1 to ::brow:colCount step 1
    ocolumn := ::brow:getColumn(x)

    if( pos := ascan(pa, {|ax| ax[3] = x})) <> 0
      pa[pos,2]:oxbp:setParent(ocolumn:dataArea)

      if( isobject(pa[pos,4]), pa[pos,4]:oxbp:setParent(ocolumn:dataArea), nil)
    endif
  next

  * doèistnem to
  ::brow:colPos   := 7
  ::brow:Keyboard := { |nKey| ::key_Board (nKey) }
  ::brow:refreshAll()
*/
return self


